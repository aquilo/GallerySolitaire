/*global Ext, getAllPrefs, getAllStats, window, Processing */
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

  name: 'GallerySolitaire',
  isNative: true,

  requires: [
    'Ext.MessageBox'
  ],

  views: [
    'Main'
  ],

  isIconPrecomposed: true,

  launch: function () {
    deltay = 0;
    document.body.style.marginTop = "20px";
    Ext.Viewport.setHeight(Ext.Viewport.getWindowHeight() - 20);
    deltay = 20;
    getAllPrefs();
    Ext.Viewport.add(Ext.create('GallerySolitaire.view.Main'));
    Processing.reload();
    //        LANG = navigator.language.substring(0, 2);
    getAllStats();
  },

  onUpdated: function () {
    Ext.Msg.confirm(
      "Application Update",
      "This application has just successfully been updated to the latest version. Reload now?",
      function (buttonId) {
        if (buttonId === 'yes') {
          window.location.reload();
        }
      }
    );
  }

});
