module.exports = {
  routes: [
    {
     method: 'GET',
     path: '/become-seller',
     handler: 'become-seller.becomeSeller',
     config: {
       policies: [],
       middlewares: [],
     },
    },
  ],
};
