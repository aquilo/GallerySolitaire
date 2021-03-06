/*
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
        debuglog = false;
        if (debuglog) console.log('...Launch');
        deltay = 0;
        document.body.style.marginTop = "0px";
        Ext.Viewport.setHeight(Ext.Viewport.getWindowHeight() - 0);
        deltay = 0;
        getAllPrefs();
        Ext.Viewport.add(Ext.create('com.mapresso.gallery.view.Main'));
        if (debuglog) console.log('...Processing.reload1');
        //Processing.reload();
        //        LANG = navigator.language.substring(0, 2);
        document.addEventListener('deviceready', function() {
            StatusBar.show();
            StatusBar.overlaysWebView(false);
            // StatusBar.backgroundColorByHexString("#cbc2ae");
            StatusBar.backgroundColorByHexString("#000000");
       //   cordova.plugins.statusbarOverlay.show();
            startDb();
  /*          window.sqlitePlugin.echoTest(function() {
                if (debuglog) console.log('...ECHO test OK');
              });
              window.sqlitePlugin.selfTest(function() {
                if (debuglog) console.log('...SELF test OK');
              });
              */
            // db = window.sqlitePlugin.openDatabase({
            //   name: 'my.db',
            //   location: 'default',
            // });
            getAllStats(); 
            
            if (debuglog) console.log('...Processing.reload2');
            Processing.reload();
            if (debuglog) console.log(Processing);
            StatusBar.show();
            if (debuglog) console.log('...StatusBar.isVisible');
            if (debuglog) console.log(StatusBar.isVisible);
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
