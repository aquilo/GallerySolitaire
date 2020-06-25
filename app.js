function _aa814c3d61196715043ec78e39123ca23d18cd11(){};/*
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
    isNative: true,

    requires: [
        'Ext.MessageBox'
    ],

    views: [
        'Main'
    ],

    isIconPrecomposed: true,
    
    launch: function() {
        deltay = 0;
        document.body.style.marginTop = "220px";
        Ext.Viewport.setHeight(Ext.Viewport.getWindowHeight() - 220);
        deltay = 220;
        getAllPrefs();
        Ext.Viewport.add(Ext.create('com.mapresso.gallery.view.Main'));
        Processing.reload();
        //        LANG = navigator.language.substring(0, 2);
        document.addEventListener('deviceready', function() {
            startDb();
            getAllStats(); 
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
