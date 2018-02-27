dev_modules = {
  resolve: {
    alias: {
      vue: 'vue/dist/vue.js',
      vue_resource: 'vue-resource/dist/vue-resource',
    }
  }
}

const environment = require('./environment')
const merge = require('webpack-merge')

module.exports = merge(environment.toWebpackConfig(), dev_modules)
