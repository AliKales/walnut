module.exports = {
  routes: [
    {
     method: 'GET',
     path: '/products-csv',
     handler: 'products-csv.productsCsv',
     config: {
       policies: [],
       middlewares: [],
     },
    },
  ],
};
