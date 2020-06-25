function _dbfd617260979a98c77b7eb5e570ad8e8b211690(){};function _ca0df8006ad6e35becf6ab031083261acb119347(){};function _3e94d61560c2e498de79f19ca939d6633b9834e1(){};function _2844ecfd9f4529cfbc9d12270d79a73682fab7c6(){};function _68b8e235079b920c54758705f1cc73da03a010e1(){};function _0416e4e3bc96e63ed239296d420c1fb4a48615ae(){};function _3b41cbe020f6acf5dced1a290f1103896d901884(){};function _9cd4f8e1531bca0532f7cfb5d34bebed18d06a6d(){};function _dce0df643656378e2f2a4b5b852acece6e4c374a(){};function _e362bbc2c1d014c17865eb7d4fa5f23b7641c60a(){};function _e80770dee59209c534ee973ed1256acbffe6e6f4(){};function _3033046d0d0bd046526c690adb293f3205d90e9e(){};function _dff2401a4f1cb9ba3ed9d6535a602af2d64a1f83(){};function _7bbead3d0347890a40fbd62c6d2d2dd4f8e243ec(){};function _68ea97d382fbfca3c1fc3e8c566c071a64656c3b(){};function _43ff3a3cdf8448a13c5eb288238165a7dcf36688(){};function _e8a7b02e8ecf12a31a7601050cff240b1bd1dfa4(){};function _650eeeebe8273446fa6f2e059a42be8a7cd36018(){};function _2005e97c24015da322dfe39082f6a758e699b6b4(){};function _4fc324b86a7443135aa74bd305064fee50aad6e5(){};function _3fdd01691ce81792cf9484a2acbf7619eca81a38(){};function _0497fcc4f5de9247511f04017d8e543cf1e1a899(){};function _74a61d5d141141acdf7756b070b122afbd3049c2(){};/*
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

    icon: {
        '57': 'resources/icons/Icon.png',
        '72': 'resources/icons/Icon~ipad.png',
        '114': 'resources/icons/Icon@2x.png',
        '144': 'resources/icons/Icon~ipad@2x.png'
    },

    isIconPrecomposed: true,

    startupImage: {
        '320x460': 'resources/startup/320x460.jpg',
        '640x920': 'resources/startup/640x920.png',
        '768x1004': 'resources/startup/768x1004.png',
        '748x1024': 'resources/startup/748x1024.png',
        '1536x2008': 'resources/startup/1536x2008.png',
        '1496x2048': 'resources/startup/1496x2048.png'
    },

    launch: function() {
        deltay = 0;
        document.body.style.marginTop = "20px";
        Ext.Viewport.setHeight(Ext.Viewport.getWindowHeight() - 20);
        deltay = 20;
        getAllPrefs();
        Ext.Viewport.add(Ext.create('com.mapresso.gallery.view.Main'));
        Processing.reload();
        //        LANG = navigator.language.substring(0, 2);
        document.addEventListener('deviceready', function() {
            window.sqlitePlugin.echoTest(function() {
                alert('ECHO test OK');
                console.log('ECHO test OK');
              });
              window.sqlitePlugin.selfTest(function() {
                calert('SELF test OK');
                console.log('SELF test OK');
              });
            // db = window.sqlitePlugin.openDatabase({
            //   name: 'my.db',
            //   location: 'default',
            // });
            startDb();
            getAllStats();    

            myDB.transaction(function(transaction) {
                transaction.executeSql('CREATE TABLE IF NOT EXISTS codesundar (id integer primary key, title text, desc text)', [],
                    function(tx, result) {
                        alert("Table created successfully");
                    },
                    function(error) {
                        alert("Error occurred while creating the table.");
                    });
            });
            var title = "sundaravel";
            var desc = "phonegap freelancer";
            myDB.transaction(function(transaction) {
                var executeQuery = "INSERT INTO codesundar (title, desc) VALUES (?, ?)";
                transaction.executeSql(executeQuery, [title, desc], function(tx, result) {
                        alert('Inserted');
                    },
                    function(error) {
                        alert('Error occurred');
                    });
            });
            myDB.transaction(function(transaction) {
                transaction.executeSql('SELECT * FROM codesundar', [], function(tx, results) {
                    var len = results.rows.length,
                        i;
                }, null);
            });

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
