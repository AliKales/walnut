'use strict';

/**
 * A set of functions called "actions" for `become-seller`
 */

module.exports = {
  becomeSeller: async (ctx, next) => {
    const { user } = ctx.state;

    if (user.role.id != 4) {
      return ctx.badRequest("Only customers can become a seller!")
    }

    await strapi.entityService.update("plugin::users-permissions.user", user.id, {
      data: {
        role: 3
      }
    })

    return ctx.send("You are a seller now!")
  }
};
