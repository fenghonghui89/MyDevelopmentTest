cordova.define('cordova/plugin_list', function(require, exports, module) {
               module.exports = [
                                 {
                                 "file": "plugins/cordova-plugin-sharePlugin/www/SharePlugin.js",
                                 "id": "cordova-plugin-sharePlugin.SharePlugin",
                                 "pluginId": "cordova-plugin-sharePlugin",
                                 "clobbers": [
                                              "cordova.plugins.SharePlugin"
                                              ]
                                 },
                                 {
                                 "file": "plugins/cordova-plugin-device/www/device.js",
                                 "id": "cordova-plugin-device.device",
                                 "pluginId": "cordova-plugin-device",
                                 "clobbers": [
                                              "device"
                                              ]
                                 }
                                 ];
               module.exports.metadata = 
               // TOP OF METADATA
               {}
               // BOTTOM OF METADATA
               });