const { defineConfig } = require("@vue/cli-service");

module.exports = defineConfig({
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
      title: "[ここにタイトルを入れる]",
    },
  },
});
