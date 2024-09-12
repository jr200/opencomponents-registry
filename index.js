'use strict';

const dotenvFiles = process.env.DOTENV_FILES || './.env';
var dotenv = require('@dotenvx/dotenvx')
dotenv.config({
  path: dotenvFiles.split(';')
})

var oc = require('oc');
var configuration = require('./config').configuration;
var registerPlugins = require('./config').registerPlugins;

var registry = new oc.Registry(configuration);

// Register plugins defined in config.js
registerPlugins(registry)

registry.start(function(err, app){
  if(err){
    console.log('Registry not started: ', err);
    process.exit(1);
  }
});
