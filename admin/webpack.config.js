const path = require('path');

module.exports = {
    entry: {
        jquery:'./src/jquery.js',
        modules:'./src/modules.js',
        theme:'./src/theme.js',
        bootstrap:'./src/bootstrap.js'
    },
    target: "web",
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].bundle.js'
    },
    externals: {
        jquery: 'jQuery',
        'mura.js': 'Mura'
      }
  };