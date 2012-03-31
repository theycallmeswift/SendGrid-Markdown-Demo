require('coffee-script');

// Launch the server
app = module.exports = require('./lib/app');
app.listen(app.port || 3000);
