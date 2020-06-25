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
global_csv = "";
global_colorblind = 2; // 1: blau / 2: grün
global_cardface = 2;
global_evaluations = 1000;
global_statistics0 = {};
global_statistics = {};

Ext.define('com.mapresso.gallery.view.Main', {
  extend: 'Ext.tab.Panel',
  requires: ['Ext.TitleBar',
    'Ext.form.FieldSet',
    'Ext.field.Select',
    'Ext.Label',
    'Ext.field.Toggle',
    'Ext.field.Checkbox',
    'Ext.field.Radio',
    'Ext.field.Slider'
    ],
  sLeft: 1000,
  sRight: 1,
  old_cardface: -1,
  old_evaluations: -1,
  old_speed: 0,

  config: {
 //   maxWidth: '320px',
   // maxWidth: '414px',
    //       maxHeight: '480px',
    maxHeight: '100%',
    items: [{
      xtype: 'panel',
      title: 'Gallery Solitaire',
      style: {"background-color": "rgb(255,255,255)", "width": "100%", "text-align": "center"},
    //  style:{"background":"url(resources/startup/1496x204.png) no-repeat !important;"},
   //     iconCls: 'docs_black2',
   //     iconCls: 'icomoon-stats',
      iconCls: 'favorites',
    //   style: 'width: 322px;background-color: #ffffff;top:20px;',
      listeners: {
    //               initialize: function (list, opts) {
          //                  alert("initialize");
          //                Processing.getInstanceById('sketch').newGame();
 //         },
 //         painted: function (list, opts) {
          //                   alert("painted");
          //                Processing.getInstanceById('sketch').newGame();
    //               Ext.getDom('sketch').style.width = "321px";
//          },
/*          show: function (list, opts) {
            var sk = Ext.get('sketch');
            console.log(sk);
            sk.dom.click();
           alert("hoi");
          //                  Processing.getInstanceById('sketch').newGame();
          //                  alert("show");
          //               Ext.getDom('sketch').style.width = "320px";
          //               Ext.getDom('sketch').style.width = "320px";
        }*/
/*        activate: function (list, opts) {
          if (Processing !== 'undefined') {
          // Processing.getInstanceById('sketch').draw();
          }
          //                Ext.Function.defer(function(){
          //                                 alert('Anonymous');
          //                               }, 100);
          //              Ext.getDom('sketch').style.width = "320px";
        }*/
      },
      html: '<canvas id="sketch" width="640" style="width:320px" data-processing-sources="resources/data/galleryjs/galleryjs.pde resources/data/galleryjs/graphparams.pde resources/data/galleryjs/Card.pde resources/data/galleryjs/CardPile.pde resources/data/galleryjs/SpecialCardPiles.pde resources/data/galleryjs/Movers.pde resources/data/galleryjs/MoveStack.pde resources/data/galleryjs/Statistics.pde resources/data/galleryjs/Button.pde resources/data/galleryjs/My.pde"></canvas>'
    }, {
      title: 'Rules',
      iconCls: 'info',
      items: [{
        docked: 'top',
        xtype: 'titlebar',
        title: 'Rules'
      }, {
        xtype: 'panel',
        height: '100%',
        //              styleHtmlCls: 'rules',
        html: '<div class="rules"><!--<h2>Summary</h2><p><strong>Briefly</strong>: You can compare your efforts with the results of random or strategy-less play (using the "Evaluate" button). And, you don\'t have to spend time doing obvious moves; the computer will make those for you, using <strong>CAP</strong> or computer-aided play.</p> --><h1>Summary</h1> <p>The object of this <strong>solitaire game</strong> is to build a complete <strong>face-card gallery</strong> of Jacks, Queens, and Kings.</br>You build sequences of cards on the Foundation rows by suit (<strong>building rules</strong>: top row <strong>2-5-8-Jack</strong>; middle <strong>3-6-9-Queen</strong>; bottom <strong>4-7-10-King</strong>) using the cards of the Tableau and the still incorrect cards of the Foundation. Deal cards from the Stock to the Tableau as needed. At the end of the game, let the computer play out the same starting situation many times.</p><h1>Details</h1><h2>Layout</h2><center><img src="resources/data/img/screen.png" alt="game" width="230" height="305"/></center></br><h3>Foundation</h3><p>24 piles: 3 rows with 8 columns.</p> <p>Empty spots can be filled with the <strong>base cards "2", "3", and "4"</strong>, as above. <strong>Building rule</strong>: Add cards <strong>by suit, in increasing rank, by a difference of 3.</strong></p><p><strong>Cards at their correct position have an altered appearance</strong> (no number, plus a narrow frame).</p> <h3>Tableau</h3><p>8 piles are fed by the cards played from the Stock. Only completely visible cards are available for play.</p> <h3>Stock</h3><p>The Stock initially consists of two decks (104 cards). As the game begins, the first 24 cards are played to the Foundation. Each time you click Stock, 8 cards move into play, one to each of the Tableau piles.</p> <p><strong>Ace Pile</strong>: Aces are automatically removed to the Aces pile and are not a part of play.</p><h2>Setup and Play</h2><p>The game begins by dealing 24 cards, face up, to the Foundation and 8 cards to the Tableau. Some of the cards on the Foundation may now already be at their final position ("2", "3", "4"), and aces go directly to the ace pile. Just <strong>tap on a card</strong> to play it (it finds its correct position automatically).</p><h3>You can now</h3> <ul class="b"> <li>Move "2", "3", "4" cards to empty spaces in the Foundation area</li> <li>Move cards of the same suit and of a 3 point higher rank onto already correct cards of the Foundation</li> <li>Undo your moves (but only back to the latest operation on the Stock)</li> <li>Deal another 8 cards from the Stock to the Tableau.</li> </ul> <h3>You cannot</h3> <ul> <li>Place a card onto an incorrect card of the Foundation (even if it would be in the correct row)</li> <li>Move cards of the Tableau to another column of the Tableau</li> <li>Move groups of cards</li> <li>Undo an operation on the Stock.</li> </ul> <h3>Winning situation</h3><p>You build a complete gallery of all face cards, removing all cards from the Tableau (score: 0)<center><img src="resources/data/img/gallery_success.png" alt="Winning situation" /></center>The appearing photos are all from <a href="#" onclick="window.open(encodeURI(\'http://www.myswitzerland.com/en/blenio-valley-valle-di-blenio.html#phonegap=external\'), \'_system\')">Blenio Valley</a>, Ticino, Switzerland</p> <p><strong>Or</strong>, you make a better score than the computer (see the "Statistics" tab). For your personal evaluation use whatever measure you like (better than the minimum or better than the median or the mean).</p><p>After the evaluation you start a <strong>New</strong> game or you <strong>Redo</strong> the same starting game.</p></li></ul><h2>Hints</h2> <ul> <li><strong>You do not have to play all cards which are movable.</strong></li> <li>Look for the position of the twin card (the card with the same suit and rank). This can help you avoid (final) jamming situations.</li> <li>Focus on the optimal sequence of moves.</li> <li>Try to resolve "jammed situations": In the Tableau, a card may cover another card which needs to be played on the Foundation first. This creates a jam, which you can resolve using the twin of the trapped card, when it comes into play.</li> </ul><h2>CAP: "computer-aided play"</h2> <ul> <li>Yellow shaded cards are movable. Concentrate your efforts on making good decisions instead of searching around for movable cards. </li> <li>"<span style="color: #00f;">Jammed </span>situations" are marked by a blue bar.</li> <li>In many situations there is no reason not to play a movable card: in these cases CAP does such evident, unproblematic moves automatically. Some obvious cases: <ul> <li>the twin card is already in its correct place</li> <li>you have two Foundation piles to play a card to</li> <li>the twin card is below your card on the Tableau pile</li> <li>etc.</li> </ul> </li> </ul> <ul> <li>If there is no movable card, the Stock is marked by a blue point. Click on Stock to get 8 more cards.<li>With the exception of actions on the Stock you can <strong>undo</strong> one or more moves.</li><li>With a click on <strong>Auto play</strong> you can switch <strong>on/off</strong> this feature.</ul><h2>Evaluations</h2><p><img src="resources/data/img/eval.png" alt="eval" align="left" style="padding: 12px 8px 6px 3px" width="49" height="64"/>During the evaluation process each single result of the random process gets a small square. <span style="color: #00f;font-weight:bold;">Blue</span>: your result is better - <span style="color: #999;font-weight:bold;">white</span>: drawn - <span style="color: #f00;font-weight:bold;">red</span>: computer is better - <span style="color: #B00;font-weight:bold">dark red</span>: solved game (result 0); if your result was also 0: <span style="color: #ccc;font-weight:bold">grey</span>.</p> <h3>Evaluation Indicators</h3> <p>(at bottom right corner of the statistics graph) <br /><strong>Left</strong>: Was the game solvable? Yes: square / no: circle; <br />Was your result better than the minimum? Blue, otherwise red.<br /><strong>Right</strong>: Upper part: color comparison to the mean. Below: "result"</p><h3>Thanks</h3> <p>Thanks to Karen Morris for editing the texts. The cards are <a href="#" onclick="window.open(encodeURI(\'https://sourceforge.net/projects/vector-cards/#phonegap=external\'), \'_system\')">Vectorized Playing Cards 1.3</a>, Copyright 2011 - Chris Aguilar, Licensed under <a href="#" onclick="window.open(encodeURI(\'http://www.gnu.org/copyleft/lesser.html#phonegap=external\'), \'_system\')">LGPL 3</a></p><br/><br/><br/><br/><br/><br/><br/></div>',
        styleHtmlContent: true,
        scrollable: 'vertical'
      }]
    }, {
      xtype: 'panel',
      title: 'Options',
      iconCls: 'settings',
      scrollable: 'vertical',
      visible: false,
      first: true,

      listeners: {
      /*              'add': function (panel) {
             console.log('add');
          },
           'activate': function (panel) {
             console.log('activate');
          },
          */
        'show': function (panel) {
          this.old_speed = global_mtime;
          //                   console.log('show');
          this.first = false;
          // console.log(global_mtime);
          Ext.getCmp('speed').setValue(-this.old_speed);
          this.old_cardface = global_cardface;
//          Ext.getCmp('cardfaces').down('radiofield[name=cardface]').setGroupValue(this.old_cardface);

          this.old_evaluations = global_evaluations;
//          Ext.getCmp('evaluations').down('radiofield[name=evaluation]').setGroupValue(this.old_evaluations);
          //x                    Ext.getCmp('colorschemes').down('radiofield[name=colorscheme]').setGroupValue(global_colorblind);
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
 //         global_cardface = Ext.getCmp('cardfaces').down('radiofield[name=cardface]').getGroupValue();
  //        global_evaluations = Ext.getCmp('evaluations').down('radiofield[name=evaluation]').getGroupValue();
          if (Processing !== 'undefined') {
            if (Processing.getInstanceById('sketch')) {
              if (this.old_cardface !== global_cardface) {
              //ACHTUNG  
                Processing.getInstanceById('sketch').setup();
              }
              Processing.getInstanceById('sketch').doStatisticsGraphInit();
            }
          }
        //x                   global_colorblind = Ext.getCmp('colorschemes').down('radiofield[name=colorscheme]').getGroupValue();
          setAllPrefs();
        }
      },

      items: [{
        xtype: 'titlebar',
        docked: 'top',
        title: 'Options',
        id: 'options'
      }, {
        xtype: 'label',
        //            styleHtmlCls: 'rules',
        styleHtmlContent: true,
        html: '<div class="rules"><center><h1>Gallery Solitaire</h1>Version 2.5, &copy; 2017, Adrian Herzog<br/><br/>' +
        '<table border=0>' + 

        '<tr>' +
        '<td align="center" width=31><a href="#" onclick="window.open(encodeURI(\'http://gallery.mapresso.com#phonegap=external\'), \'_system\')">' +
        '<img src="resources/data/img/appicon-Small.png" width="29" "height="29" align="middle"></a></td>' +
        '<td><a href="#" onclick="window.open(encodeURI(\'http://gallery.mapresso.com#phonegap=external\'), \'_system\')">' +
        'http://gallery.mapresso.com</a></td></tr>' + 

        '<tr>' +
        '<td align="center" width=31><a href="#" onclick="window.open(encodeURI(\'http://https://www.facebook.com/Gallery-Solitaire-113763543718658#phonegap=external\'), \'_system\')">' +
        '<img src="resources/data/img/FB_logo_blue_29.png" width="29" "height="29" align="middle"></a></td>' +
        '<td><a href="#" onclick="window.open(encodeURI(\'http://https://www.facebook.com/Gallery-Solitaire-113763543718658#phonegap=external\'), \'_system\')">' +
        'http://https://www.facebook.com/Gallery-Solitaire-113763543718658</a></td></tr>' + 

        '<tr>' +
        '<td align="center" width=31><a href="#" onclick="window.open(encodeURI(\'http://twitter.com/gallerysol1#phonegap=external\'), \'_system\')">' +
        '<img src="resources/data/img/Twitter_logo_blue_32.png" width="29" "height="29" align="middle"></a></td>' +
        '<td><a href="#" onclick="window.open(encodeURI(\'http://twitter.com/gallerysol1#phonegap=external\'), \'_system\')">' +
        'http://twitter.com/gallerysol1</a></td></tr>' + 
        '</table>'
      },
    /* {
        xtype: 'sliderfield',
        id: 'speed'
 //                  label: 'Speed',
  //                labelWidth: '50%',

  //                 minValue: -500,
  //                 maxValue: 0 
 }, */
        {
          xtype: 'fieldset',
          title: '<div class="fst">Animation Speed</div>',
          width: "100%",
          instructions: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moving speed of cards &nbsp;&nbsp;(slow &rarr; fast)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
          items: [{
            xtype: 'sliderfield',
            id: 'speed',
           //                label: 'Speed',
           //                 labelWidth: '30%',
            minValue: -1000,
            maxValue: -1,

            listeners: {
              'change': function (me, sl, thumb, newValue, oldValue, eOpts) {
            //                            console.log(newValue);
              }
            }
          }]
  /*        }, {
        instructions: 'Nostalgic card face: as in old Mac Gallery versions.',
        xtype: 'fieldset',
        title: '<div class="fst">Card Faces</div>',
        name: 'cardfaces',
        id: 'cardfaces',
        defaults: {
          xtype: 'radiofield',
          labelWidth: '80%',
          name: 'cardface'
        },
        items: [{
          value: 2,
          checked: global_cardface === 2,
          label: 'Classic'
        }, {
          value: 1,
          checked: global_cardface === 1,
          label: 'Nostalgic'
        }]
      }, {

        instructions: 'Number of evaluation tries.',
        xtype: 'fieldset',
        title: '<div class="fst">Evaluations</div>',
        name: 'evaluations',
        id: 'evaluations',
        defaults: {
          xtype: 'radiofield',
          labelWidth: '80%',
          name: 'evaluation'
        },
        items: [{
          value: 1000,
          checked: global_evaluations === 1000,
          label: '1000 games'
        }, {
          value: 250,
          checked: global_evaluations === 250,
          label: '250 games'
        }]
             }, {
        xtype: 'fieldset',
        instructions: '&nbsp;&nbsp;&nbsp;&nbsp;Color scheme in statistical evaluations.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
        title: 'Color Scheme',
        name: 'colorschemes',
        id: 'colorschemes',
        defaults: {
          xtype: 'radiofield',
          labelWidth: '50%',
          name: 'colorscheme'
        },
        items: [{
          value: 2,
          checked: global_colorblind == 2,
          label: 'Red / Green'
        }, {
          value: 1,
          checked: global_colorblind == 1,
         label: 'Red / Blue'
        }]
       */
      }, {
        xtype: 'fieldset',
        title: '<div class="fst">Computer Aided Playing</div>',
        instructions: '<b>Auto move reasons</b><div style="text-align:left"><br/><b>Twin</b> = card of same suit and rank<br/><br/><ol><li><b>T ok</b>: Twin is already ok.<li><b>2 poss</b>: There are two possibilities for this card.<li><b>F clean</b>: Foundation row is completely clear.<li><b>just 1</b>: At the end and just one card movable.<li><b>T row</b>: Twin is on the same foundation row.<li><b>Tbelow</b>: Twin lies under this card.<li><b>T botm</b>: Twin (image) lies directly at the bottom.<li><b>TuBase</b>: Twin lies directly under its own base.<li><b>Tjammed</b>: Twin unreachable (jammed)</ol></div>',
        items: [
          /*               {
              xtype: 'selectfield',
              label: 'Explain',
              id: 'helplevel',
              name: 'explain',
              options: [
                {
                  text: 'No Help',
                  value: 0
                }, {
                  text: 'Help Numbers',
                  value: 8
                }, {
                  text: 'Help Arrows',
                  value: 9
                }, {
                  text: 'Numbers + Arrows',
                  value: 10
                }
              ],
              listeners: {
                change: function (selectbox, newValue, oldValue) {
                  if (newValue !== null && !selectbox.initdata) {
                   global_helplevel = newValue;
                   window.localStorage.setItem('helplevel', global_helplevel);
                  }
                }
              }
            },*/
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
              name: 'sayNoHelp',
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
          //                   ui: 'decline',
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
          //                   ui: 'decline',
          handler: function (button, event) {
            Ext.Msg.confirm('Warning', 'You \'ll loose all the results of previous games. Are you sure to reset the statistics?', function (btn) {
              if (btn === "yes") {
                dbDrop();
              }
            }, this);
          },
          text: 'Reset Statistics'
        }]

      }
        ]
    }, {
      title: 'Statistics',
   //     iconCls: 'icomoon-stats',
      iconCls: 'chart2',
      items: [{
        docked: 'top',
        xtype: 'titlebar',
        title: 'Statistics'
      }, {
        xtype: 'panel',
        //               styleHtmlCls: 'rules',
        // height: 425,
        height: '100%',
        html: '---',
        styleHtmlContent: true,
        scrollable: 'vertical'
      }],
      listeners: {
        'show': function (panel) {
          var hhh = '';
          //'<h2>Empirical Data</h2><p>A good player achieves a mean score of about 22, he/she makes a score of 0 (zero) every 7th game and compared to the trivial all-you-can-do strategy he/she wins 74% of the games and looses 20% (6% are drawn). If you compare your result with the best attempt by the computer in 5000 attempts, you win in 6.6% and loose in 75.9% (drawn: 17.5). With these many attempts the computer solves the game every 3rd time. This non-strategy leads to a mean score of about 31.7.</p><br/><br/><br/><br/><br/><br/><br/>';
          getAllStats();
          this.items.items[1].setHtml(statText + " " + hhh);
        }
      }
    }],
    tabBar: {
      docked: 'bottom'
    }
  }
});
