const { defineConfig } = require("@vue/cli-service");

module.exports = defineConfig({
  publicPath: "/guide/",
  transpileDependencies: true,
  configureWebpack: {
    watchOptions: {
      aggregateTimeout: 300,
      poll: 1000,
    },
  },
  pages: {
    index: {
      entry: "src/main.js",
      title: "観光ガイドスケジュール調整システム",
    },
  },
});
