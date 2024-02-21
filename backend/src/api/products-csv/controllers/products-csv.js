'use strict';

/**
 * A set of functions called "actions" for `products-csv`
 */

module.exports = {
  productsCsv: async (ctx, next) => {
    const { user } = ctx.state;

    const products = await strapi.db.query('api::product.product').findMany({where:{user_id:user.id}})

    if (products.length == 0) {
      return ctx.notFound("You do not have any product!")
    }

    const csvData = products.map(product => `${product.name},${product.price},${product.description}`).join('\n');

    ctx.response.set('Content-disposition', 'attachment; filename=products.csv');
    ctx.response.body = csvData;
    ctx.response.type = 'text/csv';

    return ctx.response;
  }
};
