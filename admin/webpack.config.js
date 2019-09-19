const path = require('path');	
const CopyPlugin = require('copy-webpack-plugin');

module.exports = {	
    entry: {	
        jquery:'./src/jquery.js',	
        modules:'./src/modules.js',	
        theme:'./src/theme.js',	
        bootstrap:'./src/bootstrap.js',
        toast:'./src/toast.js'	
    },	
    target: "web",	
    output: {	
        path: path.resolve(__dirname, 'dist'),	
        filename: '[name].bundle.js'	
    },	
    externals: {	
        jquery: 'jQuery',	
        'mura.js': 'Mura'	
    },	
    module: {	
        rules: [	
            {	
                test: /\.css$/i,	
                use: ['style-loader', 'css-loader'],	
            },	
            {	
                test: /\.(png|jpe?g|gif|svg)$/i,	
                loader: 'file-loader',	
                options: {	
                    outputPath: './images',
                    publicPath: 'dist/images',
                    name: '[contenthash].[ext]',	
                },	
            }
        ],	
      }
      
    /*,	
      plugins: [
        new CopyPlugin([
            {from:'./src/_toast/image-editor',to:'./image-editor'} 
        ]), 
    */

  }; 