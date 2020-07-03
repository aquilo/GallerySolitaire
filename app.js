function _b33f67daa2a3f24380c80778761e532cc9cfb3b9(){};function _ae6b434f4d35b1104f4d09e94d12212ac0a6ba8f(){};function _be78ecac60833b59bbade78b6e2edc194aab68c4(){};function _c3109d6f5cbb449729e35ca7d34542e099189746(){};function _0021497487d23d000bd931cea27c5701bb35c165(){};function _6d2ff4987bde447da7eb8c4860d66c40175aa80c(){};function _a9d6983b210c6d2db5a4d4f7ea9d9c6b10c6eda7(){};function _253c32b8d947e99c21f91033d47dbb5cca5ff371(){};function _a903d4281647452d37d997b458943ea410669860(){};function _3cc1cce5f9a43cf2895af2c37502c6e01c9d9c91(){};function _aae997236d193bc9ceb61abd2b1685ef8685562e(){};function _b293c14315e3960c8f0ffd3d6c13ffa18abaa4be(){};function _f7ee27e3893e899cbf652c8468ba64ac032e9412(){};/*
    This file is generated and updated by Sencha Cmd. You can edit this file as
    needed for your application, but these edits will have to be merged by
    Sencha Cmd when it performs code generation tasks such as generating new
    models, controllers or views and when running "sencha app upgrade".

    Ideally changes to this file would be limited and most work would be done
    in other places (such as Controllers). If Sencha Cmd cannot merge your
    changes and its generated code, it will produce a "merge conflict" that you
    will need to resolve manually.
*/

Ext.application({
    name: 'com.mapresso.gallery',

    requires: [
        'Ext.MessageBox'
    ],

    views: [
        'Main'
    ],


    isIconPrecomposed: true,

    launch: function() {
        deltay = 0;
        document.body.style.marginTop = "0px";
        Ext.Viewport.setHeight(Ext.Viewport.getWindowHeight() - 0);
        deltay = 0;
        getAllPrefs();
        Ext.Viewport.add(Ext.create('com.mapresso.gallery.view.Main'));
        console.log('...Processing.reload1');
        //Processing.reload();
        //        LANG = navigator.language.substring(0, 2);
        document.addEventListener('deviceready', function() {
            StatusBar.styleDefault();
            StatusBar.overlaysWebView(true);
            startDb();
  /*          window.sqlitePlugin.echoTest(function() {
                console.log('...ECHO test OK');
              });
              window.sqlitePlugin.selfTest(function() {
                console.log('...SELF test OK');
              });
              */
            // db = window.sqlitePlugin.openDatabase({
            //   name: 'my.db',
            //   location: 'default',
            // });
            getAllStats(); 
            
            console.log('...Processing.reload');
            Processing.reload();
            console.log(Processing);
        });
},

 /*    onUpdated: function() {
        Ext.Msg.confirm(
            "Application Update",
            "This application has just successfully been updated to the latest version. Reload now?",
            function(buttonId) {
                if (buttonId === 'yes') {
                    window.location.reload();
                }
            }
        );
    }
 */

});
