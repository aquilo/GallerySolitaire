/*jslint unparam: true, sloppy: true */
/*global global_helplevel:true, stat_n:true, stat_player:true, stat_mean:true, statText:true, global_steps:true, global_mtime:true, global_sayAuto:true, global_csv:true, global_colorblind:true, global_cardface:true, global_evaluations:true, setAllPrefs, Processing, doDumpDb, dbDrop, getAllStats, Ext  */
global_helplevel = 999;
stat_n = 0;
stat_player = -1.0;
stat_mean = -1.0;
statText = '---';
global_steps = 55;
global_mtime = 200;
global_sayAuto = 0;
global_auto = 1;
global_show = 1;
global_csv = "";
global_colorblind = 2; // 1: blau / 2: grün
global_cardface = 2;
global_evaluations = 1000;
global_statistics0 = {};
global_statistics = {};

Ext.define('com.mapresso.gallery.view.Main', {
  extend: 'Ext.tab.Panel',
  requires: [
    'Ext.TitleBar',
    'Ext.form.FieldSet',
    'Ext.field.Select',
    'Ext.Label',
    'Ext.field.Toggle',
    'Ext.field.Checkbox',
    'Ext.field.Radio',
    'Ext.field.Slider'
    ],

  old_cardface: -1,
  old_evaluations: -1,
  old_speed: 0,
  fullscreen: true,
  tabBarPosition: 'bottom',

  config: {
    maxHeight: '100%',
    maxWidth: '100%',
    fullscreen: true,
    maximized: true,
    items: [{

      xtype: 'panel',
      title: 'Gallery Solitaire',
      iconCls: 'favorites',

      style: {"background-color": "rgb(255,255, 255)", "width": "100%", "text-align": "center"},
      html: '<canvas id="sketch" width="640" style="width:320px" data-processing-sources="resources/data/galleryjs/galleryjs.pde resources/data/galleryjs/graphparams.pde resources/data/galleryjs/Card.pde resources/data/galleryjs/CardPile.pde resources/data/galleryjs/SpecialCardPiles.pde resources/data/galleryjs/Movers.pde resources/data/galleryjs/MoveStack.pde resources/data/galleryjs/Statistics.pde resources/data/galleryjs/Button.pde resources/data/galleryjs/My.pde"></canvas>'
    }, {
      title: 'Statistics',
      iconCls: 'chart2',
      items: [{
        xtype: 'panel',
        id: 'stattext',
        height: '100%',
        html: `
          <h2>Your Results</h2>
          <div class="rules">For comparison: <i>empirical results</i>.<br><br>
          <h3>Basic Indicators</h3>
          [no games yet]
          <h3>Winning Situations</h3>
          [no games yet]
          <h3>Other indicator</h3>
          [no games yet]
          </div>
          `,
        styleHtmlContent: true,
        scrollable: 'vertical'
      }],
      listeners: {
        'show': function (panel) {
          var hhh = '';
          getAllStats();
          this.items.items[0].setHtml(statText + " " + hhh);
        }
      }
    },{

      title: 'Rules',
      iconCls: 'info',

      items: [{
        xtype: 'panel',
        height: '100%',
        //              styleHtmlCls: 'rules',
        html: '<div class="rules"><h1>Summary</h1> <p>The object of this <strong>solitaire game</strong> is to build a complete <strong>face-card gallery</strong> of Jacks, Queens, and Kings.<br>You build sequences of cards on the Foundation rows by suit (<strong>building rules</strong>: top row <strong>2-5-8-Jack</strong>; middle <strong>3-6-9-Queen</strong>; bottom <strong>4-7-10-King</strong>) using the cards of the Tableau and the still incorrect cards of the Foundation. Deal cards from the Stock to the Tableau as needed. At the end of the game, let the computer play out the same starting situation many times.</p><h1>Details</h1><h2>Layout</h2><center><img src="resources/data/img/screen.png" alt="game" width="230" height="305"/></center><br><h3>Foundation</h3><p>24 piles: 3 rows with 8 columns.</p> <p>Empty spots can be filled with the <strong>base cards "2", "3", and "4"</strong>, as above. <strong>Building rule</strong>: Add cards <strong>by suit, in increasing rank, by a difference of 3.</strong></p><p><strong>Cards at their correct position have an altered appearance</strong> (no number, plus a narrow frame).</p> <h3>Tableau</h3><p>8 piles are fed by the cards played from the Stock. Only completely visible cards are available for play.</p> <h3>Stock</h3><p>The Stock initially consists of two decks (104 cards). As the game begins, the first 24 cards are played to the Foundation. Each time you click Stock, 8 cards move into play, one to each of the Tableau piles.</p> <p><strong>Ace Pile</strong>: Aces are automatically removed to the Aces pile and are not a part of play.</p><h2>Setup and Play</h2><p>The game begins by dealing 24 cards, face up, to the Foundation and 8 cards to the Tableau. Some of the cards on the Foundation may now already be at their final position ("2", "3", "4"), and aces go directly to the ace pile. Just <strong>tap on a card</strong> to play it (it finds its correct position automatically).</p><h3>You can now</h3> <ul class="b"> <li>Move "2", "3", "4" cards to empty spaces in the Foundation area</li> <li>Move cards of the same suit and of a 3 point higher rank onto already correct cards of the Foundation</li> <li>Undo your moves (but only back to the latest operation on the Stock)</li> <li>Deal another 8 cards from the Stock to the Tableau.</li> </ul> <h3>You cannot</h3> <ul> <li>Place a card onto an incorrect card of the Foundation (even if it would be in the correct row)</li> <li>Move cards of the Tableau to another column of the Tableau</li> <li>Move groups of cards</li> <li>Undo an operation on the Stock.</li> </ul> <h3>Winning situation</h3><p>You build a complete gallery of all face cards, removing all cards from the Tableau (score: 0)<center><img src="resources/data/img/gallery_success.png" alt="Winning situation" /></center>The appearing photos are all from <a href="#" onclick="cordova.InAppBrowser.open(encodeURI(\'http://www.myswitzerland.com/en/blenio-valley-valle-di-blenio.html#phonegap=external\'), \'_system\', \'location=yes\')">Blenio Valley</a>, Ticino, Switzerland</p> <p><strong>Or</strong>, you make a better score than the computer (see the "Statistics" tab). For your personal evaluation use whatever measure you like (better than the minimum or better than the median or the mean).</p><p>After the evaluation you start a <strong>New</strong> game or you <strong>Redo</strong> the same starting game.</p></li></ul><h2>Hints</h2> <ul> <li><strong>You do not have to play all cards which are movable.</strong></li> <li>Look for the position of the twin card (the card with the same suit and rank). This can help you avoid (final) jamming situations.</li> <li><strong>Focus on the optimal sequence of moves.</strong></li> <li>Try to resolve "jammed situations": In the Tableau, a card may cover another card which needs to be played on the Foundation first. This creates a jam, which you can resolve using the twin of the trapped card, when it comes into play.</li> </ul><h2>CAP: "computer-aided play"</h2> <ul> <li>Yellow shaded cards are movable. <strong>Concentrate your efforts on making good decisions</strong> instead of searching around for movable cards. </li> <li>"<span style="color: #00f;">Jammed </span>situations" are marked by a blue bar.</li> <li>In many situations there is no reason not to play a movable card: in these cases <strong>CAP does such evident, unproblematic moves automatically</strong>. Some obvious cases: <ul> <li>the twin card is already in its correct place</li> <li>you have two Foundation piles to play a card to</li> <li>the twin card is below your card on the Tableau pile</li> <li>...</li> </ul> </li> </ul> <ul> <li>If there is no movable card, the Stock is marked by a blue point. Click on Stock to get 8 more cards.<li>With the exception of actions on the Stock you can <strong>undo</strong> one or more moves.</li><li>In the options you can deactivate this <strong>Auto play</strong> feature.</ul><h2>Evaluations</h2><p><img src="resources/data/img/eval.png" alt="eval" align="left" style="padding: 12px 8px 6px 3px" width="49" height="64"/>During the evaluation process each single result of the random process gets a small square. <span style="color: #00f;font-weight:bold;">Blue</span>: your result is better - <span style="color: #999;font-weight:bold;">white</span>: drawn - <span style="color: #f00;font-weight:bold;">red</span>: computer is better - <span style="color: #B00;font-weight:bold">dark red</span>: solved game (result 0); if your result was also 0: <span style="color: #ccc;font-weight:bold">grey</span>.</p> <h3>Evaluation Indicators</h3> <p>(at bottom right corner of the statistics graph) <br /><strong>Left</strong>: Was the game solvable? Yes: square / no: circle; <br />Was your result better than the minimum? Blue, otherwise red.<br /><strong>Right</strong>: Upper part: color comparison to the mean. Below: "result"</p><img src="resources/data/img/10last.png" alt="10 last games" align="center" /><br>Graphs of the last 1<a onclick="clearResultImage()" href="javascript:void(0);">0</a> games.<br><br><h3>Thanks</h3> <p>Thanks to Karen Morris for editing the texts. The cards are <a href="#" onclick="cordova.InAppBrowser.open(encodeURI(\'https://totalnonsense.com/open-source-vector-playing-cards/#phonegap=external\'), \'_system\', \'location=yes\')">Open Source Vector Playing Cards</a>, Copyright 2011, 2020 - Chris Aguilar, Licensed under <a href="#" onclick="cordova.InAppBrowser.open(encodeURI(\'https://www.gnu.org/licenses/lgpl-3.0.html#phonegap=external\'), \'_system\', \'location=yes\')">LGPL 3</a>. The historic aerial mountain <a href="#" onclick="cordova.InAppBrowser.open(encodeURI(\'http://doi.org/10.3932/ethz-a-000295434 #phonegap=external\'), \'_system\', \'location=yes\')">photo (Rheinwaldhorn, Adula)</a> by Walter Mittelholzer (1923) is Public Domain from ETH-Bibliothek Zürich, Bildarchiv/Stiftung Luftbild Schweiz; LBS_MH01-003541</p><br/><br/><br/><br/><br/><br/><br/></div>',
        styleHtmlContent: true,
        scrollable: 'vertical'
      }]
    },
    {
      xtype: 'panel',
      title: 'Options',
      iconCls: 'settings',
      scrollable: 'vertical',
      visible: false,
      first: true,

      listeners: {

        'show': function (panel) {
          this.old_speed = global_mtime;
          this.first = false;
          // console.log(global_mtime);
          Ext.getCmp('speed').setValue(-this.old_speed);
          this.old_cardface = global_cardface;
          this.old_evaluations = global_evaluations;
        },

        'hide': function (panel) {
          // console.log('hide');
          if (this.first) {
            this.first = false;
            return;
          }
          if (this.old_speed !== undefined && Ext.getCmp('speed').getValue()[0] !== -this.old_speed) {
            global_mtime = -Ext.getCmp('speed').getValue();
            global_steps = Math.round(global_steps * (global_mtime / this.old_speed));
            global_steps = Math.min(global_steps, 150);
            global_steps = Math.max(global_steps, 1);
          }
          if (Processing !== 'undefined') {
            if (Processing.getInstanceById('sketch')) {
              if (this.old_cardface !== global_cardface) {
              //ACHTUNG  
                Processing.getInstanceById('sketch').setup();
              }
              Processing.getInstanceById('sketch').doStatisticsGraphInit();
            }
          }
          setAllPrefs();
        }
      },

      items: [{
        xtype: 'label',
        id: 'about',
        styleHtmlContent: true,
        html: '<div><img src="resources/data/img/mittelholzer_strip.png" width="100%"></div><div class="rules"><center><h1>Gallery Solitaire</h1>Version 2.6, &copy; 2020, Adrian Herzog<br/><br/>' +
        '<table border=0>' + 

        '<tr>' +
        '<td align="center" width=31><a href="#" onclick="cordova.InAppBrowser.open(encodeURI(\'http://gallery.mapresso.com#phonegap=external\'), \'_system\', \'location=yes\')">' +
        '<img src="resources/data/img/29.png" width="29" "height="29" align="middle"></a></td>' +
        '<td><a href="#" onclick="cordova.InAppBrowser.open(encodeURI(\'http://gallery.mapresso.com#phonegap=external\'), \'_system\', \'location=yes\')">' +
        'http://gallery.mapresso.com</a></td>' + 

        '<td align="center" width=31><a href="#" onclick="cordova.InAppBrowser.open(encodeURI(\'http://twitter.com/gallerysol1#phonegap=external\'), \'_system\', \'location=yes\')">' +
        '<img src="resources/data/img/Twitter_Social_Icon_Circle_Color.png" width="29" "height="29" align="middle"></a></td>' + 
        
        '<td align="center" width=31><a href="#" onclick="cordova.InAppBrowser.open(encodeURI(\'https://www.facebook.com/Gallery-Solitaire-113763543718658#phonegap=external\'), \'_system\', \'location=yes\')">' +
        '<img src="resources/data/img/f_logo_RGB-Blue_58.png" width="29" "height="29" align="middle"></a></td>' +

        '</tr></table>'
      },        
      {
          xtype: 'fieldset',
          title: '<div class="fst">Animation Speed</div>',
          width: "100%",
          instructions: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moving speed of cards &nbsp;&nbsp;(slow &rarr; fast)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
          items: [{
            xtype: 'sliderfield',
            id: 'speed',
            minValue: -1000,
            maxValue: -1,

            listeners: {
              'change': function (me, sl, thumb, newValue, oldValue, eOpts) {
              }
            }
          }]
      }, {
        xtype: 'fieldset',
        title: '<div class="fst">Computer Aided Playing</div>',
        instructions: '<b>Auto move reasons</b><div style="text-align:left"><br/><b>Twin</b> = card of same suit and rank<br/><br/><ol><li><b>T ok</b>: Twin is already ok.<li><b>2 poss</b>: There are two possibilities for this card.<li><b>F clean</b>: Foundation row is completely clear.<li><b>just 1</b>: At the end and just one card movable.<li><b>T row</b>: Twin is on the same foundation row.<li><b>Tbelow</b>: Twin lies under this card.<li><b>T botm</b>: Twin (image) lies directly at the bottom.<li><b>TuBase</b>: Twin lies directly under its own base.<li><b>Tjammed</b>: Twin unreachable (jammed)</ol></div>',
        items: [
            {
              xtype: 'togglefield',
              name: 'sayNoHelp',
              label: 'Show movable cards',
              labelWidth: '80%',
              value: 1,
              listeners: {
                change: function (checkboxfield, newValue, oldValue) {
                  global_show = newValue ? 1 : 0;
                }
              }
            },           
            {
              xtype: 'togglefield',
              name: 'sayAuto',
              label: 'Show auto move reason',
              labelWidth: '80%',
              listeners: {
                change: function (checkboxfield, newValue, oldValue) {
                  global_sayAuto = newValue ? 1 : 0;
                }
              }
            },
            {
              xtype: 'togglefield',
              name: 'sayNoAuto',
              label: 'Do auto moves',
              labelWidth: '80%',
              value: 1,
              listeners: {
                change: function (checkboxfield, newValue, oldValue) {
                  global_auto = newValue ? 1 : 0;
                }
              }
            }

            ]
      }, {
        xtype: 'fieldset',
        instructions: 'Include your game results in an email<br/>(in CSV format) for further evaluation.',
        title: '<div class="fst">Statistics</div>',
        items: [{
          xtype: 'button',
          ui: 'action',
          width: "100%",
          handler: function (button, event) {
            doDumpDb();
          },
          text: 'Export Statistics'
        }]

      }, {
        xtype: 'fieldset',
        instructions: 'Delete your statistics records<br/> and start at zero.',
        items: [{
          xtype: 'button',
          ui: 'action',
          width: "100%",
          handler: function (button, event) {
            Ext.Msg.confirm('Warning', 'You \'ll loose all the results of previous games. Are you sure to reset the statistics?', function (btn) {
              if (btn === "yes") {
                dbDrop();
                dbCreate();
              }
            }, this);
          },
          text: 'Reset Statistics'
        }]

      }
        ]
    }
 ],
    tabBar: {
      docked: 'bottom'
    }
  }
});
