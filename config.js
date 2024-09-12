// see: https://github.com/opencomponents/oc/wiki/Registry

var s3 = require("oc-s3-storage-adapter");

exports.configuration = {
    verbosity: 0,
    discovery: true,
    tempDir: "./temp/",
    refreshInterval: 600,
    pollingInterval: 5,
    baseUrl: process.env.BASE_URL,
    port: process.env.PORT || 9000,
    tempDir: './temp/',
    refreshInterval: 600,
    pollingInterval: 5,
    storage: {
      adapter: s3,
      options: {
        endpoint: process.env.S3_ENDPOINT,
        region: process.env.S3_REGION,
        key: process.env.S3_ACCCESS_KEY,
        secret: process.env.S3_SECRET_KEY,
        bucket: process.env.S3_BUCKET,
        componentsDir: process.env.COMPONENTS_DIR,
        sslEnabled: Boolean(process.env.S3_USE_SSL),
        s3ForcePathStyle: Boolean(process.env.S3_FORCE_PATH_STYLE),
        debug: Boolean(process.env.S3_DEBUG),
      },
    },
    dependencies: [],
    env: { name: 'production' }
  }
  
  if (process.env.PUBLISH_USERNAME && process.env.PUBLISH_PASSWORD) {
    exports.configuration.publishAuth = {
      type: 'basic',
      username: process.env.PUBLISH_USERNAME,
      password: process.env.PUBLISH_PASSWORD
    };
  }

  exports.registerPlugins = (registry) => {
    // You plugins registration code
  }