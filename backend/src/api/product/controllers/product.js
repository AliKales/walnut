'use strict';

/**
 * product controller
 */

const { createCoreController } = require('@strapi/strapi').factories;

module.exports = {
    async find(ctx) {
        const { isAuthenticated } = ctx.state;

        if (!isAuthenticated) {
            ctx.unauthorized("Authorization is required!")
        }

        const products = await strapi.db.query('api::product.product').findMany()

        return ctx.send(products);
    },

    async findOne(ctx) {
        const { id } = ctx.request.params;
        const { isAuthenticated, user } = ctx.state;

        if (!isAuthenticated) {
            ctx.unauthorized("Authorization is required!")
        }

        let product;

        //if id is 0 we want to return all products of current user!
        //we do not make one more controller we shorten it with a ifelse block
        //we use 0 because id will be > 0 so there won't be a product with id 0 ever
        if (id == 0) {
            product = await strapi.db.query('api::product.product').findMany({ where: { user_id: user.id } });
        } else {
            product = await strapi.db.query('api::product.product').findOne({ where: { id: id } });
        }


        if (!product) {
            return ctx.notFound("Not found a product with id: " + id);
        }

        return ctx.send(product);
    },

    async create(ctx) {
        const { user, isAuthenticated } = ctx.state;
        const { name, price, description } = ctx.request.body;

        try {
            if (!isAuthenticated) {
                ctx.unauthorized("Authorization is required!")
            }

            //we want only sellers to be able to create product
            if (user.role.type !== "seller") {
                return ctx.forbidden('Not allowed!');
            }

            if (!name || !price || !description) {
                return ctx.badRequest('Name, price, and description are required fields');
            }

            const product = await strapi.db.query('api::product.product').create({
                data: {
                    name: name,
                    price: price,
                    description: description,
                    user_id: user.id,
                }
            });


            return ctx.send(product);
        } catch (err) {
            return ctx.badRequest('Failed to create product');
        }
    },

    async update(ctx) {
        const { id } = ctx.request.params;
        const { user, isAuthenticated } = ctx.state;
        const body = ctx.request.body;

        if (!isAuthenticated) {
            return ctx.unauthorized('Authentication is required!');
        }

        //here we set user_id because we do not want that any seller can update any product
        //only products belong to him
        //and we don't need to check if user's role is seller
        //because a customer won't be able to create a product anyways
        const updatedProduct = await strapi.db.query('api::product.product').update({
            where: { id: id, user_id: user.id },
            data: body,
        });

        if (!updatedProduct) {
            return ctx.notFound("You do not have a product with id: " + id)
        }

        return ctx.send(updatedProduct);
    },

    async delete(ctx) {
        const { id } = ctx.request.params;
        const { user, isAuthenticated } = ctx.state;

        console.log(user);

        if (!isAuthenticated) {
            return ctx.unauthorized('Authentication is required!');
        }

        //here we set user_id because we do not want that any seller can delete any product
        //only products belong to him
        //and we don't need to check if user's role is seller
        //because a customer won't be able to create a product anyways
        const deletedProduct = await strapi.db.query('api::product.product').delete({
            where: { id: id, user_id: user.id },
        });

        if (!deletedProduct) {
            return ctx.notFound("You do not have a product with id: " + id)
        }

        return ctx.send(deletedProduct);
    },
}
