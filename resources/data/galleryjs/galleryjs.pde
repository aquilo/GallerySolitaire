// import java.util.Date;
boolean isProcessing = false;
// galleryjs -------------------------------------------------------------

/* @pjs font="resources/data/helveticaneueultralight.ttf"; preload="resources/data/img/allcards.gif,resources/data/img/newcards.png,resources/data/img/newcards2013.png,resources/data/img/numbersandcolors.png,resources/data/img/numbersandcolors.png,resources/data/photos/adula.png,resources/data/photos/mittelholzer.png,resources/data/photos/mittelholzer2.png,resources/data/photos/clariden.png,resources/data/photos/gelb.png,resources/data/photos/img_0611b.png,resources/data/photos/img_0812b.png,resources/data/photos/img_1021b.png,resources/data/photos/img_1029b.png,resources/data/photos/img_1049b.png,resources/data/photos/img_1058b.png,resources/data/photos/img_1080b.png,resources/data/photos/img_1119b.png,resources/data/photos/img_1125b.png,resources/data/photos/img_1144b.png,resources/data/photos/img_1536b.png,resources/data/photos/img_1747b.png,resources/data/photos/img_1972b.png,resources/data/photos/img_2070b.png,resources/data/photos/img_2225b.png,resources/data/photos/img_2856b.png,resources/data/photos/img_2867b.png,resources/data/photos/pratod.png,resources/data/photos/terri.png,resources/data/photos/terribw.png,resources/data/photos/toedi.png,resources/data/photos/uomo.png,resources/data/photos/grafik.png"; 
 */
// Entwicklung processing:
// Entwicklung processingjs:
// 
// Todo: OkChecks gleich beim Zug abhaken
// evaluation quasi parallel?
// auswertung bis die anzahl unterschiedlicher resultate lange nicht mehr ändert
// hover: erklärung zu einer karte
// zusätzlicher automove: twin  jammed
// links aussen j auf 5 nicht als jam!
// rechts aussen: tableau von klick auf stack mitbetroffen
// schnell und häufiges new: unklare situation

// int global_helplevel;
// Constants, defaults

// --------------------------------------------------------------
// top left of Foundation, Tableau, Aces, Stock
String version = "Version 2.6"; // a
String device = "";
String mymsg;
int XSF, YSF, XST, YST, XSA, YSA, XSS, YSS; 
int DXSF, DYSF, DXST, DYST, DXSA, DYSA, DXSS, DYSS; 
int FACT;
int CARDWIDTH, CARDHEIGHT;

int XRIGHT;
int WIDTH0, HEIGHT0;
int XSTAT, YSTAT, XHISTO, YHISTO, XGRAPH, XRES, YRES;
int XBN, YBN, XBU, YBU, XBE, YBE, XBF, YBF;
int WBN, HBN, WBU, HBU, WBE, HBE, WBF, HBF;
int XMSG, YMSG, DXMSG;
int XBUTTONS, DYBUTTON;
int YPROGRESS, DYPROGRESS;
int BUTTONSMALLHEIGHT;
int WINDRAWSTART;
int NEVALUATIONS = 1000;
int nEvaluationsEnd = 0;
int NEVALUATIONSTEP = 5;
int BLUECIRCLERADIUS;
int nrbox;
int F9, F10, F12, F14, F16, F18, F24;
float alfa = 0.99;
boolean debug = false;
String LANG = "en";
boolean withNewCards = true;
boolean retina = true;
boolean colorblind = true;
boolean evaluationfinished = false;
boolean redoing = false;
// --------------------------------------------------------------

int ndraw = 00;
boolean dirty = true;
boolean undoing = false;

color winfrom, winto, lostfrom, lostto;

PImage allCards, newCards, bgImg, numbcol;
PImage cardImages[][][] = new PImage[3][4][13];
PImage suitImages[] = new PImage[4];
PImage numberImages[][] = new PImage[2][15];
PImage bimg[];
PImage lastGames;
PImage resImage;

static PGraphics offScreen;
static PGraphics lastGamesScreen;
int imgNow;
int windrawloop;

CardPile allPiles[] = new CardPile[34];
FoundationPile foundationPile[][] = new FoundationPile[3][8];
TableauPile tableau[] = new TableauPile[8];
StockPile stockPile;
AcePile acePile;

MoverCollection moverCollection;
Statistics statistics = new Statistics();
boolean oneMoving = false;

int res;
int resPlayer;
int nMovesStat = 0;
int nAutoMovesStat = 0;
int nAutoMoves = 0;
boolean gameFinished = false;
boolean mustDraw = true;
static boolean osp = true; // offscreen painting
Button btnEvaluate, btnNew, btnRedo, btnUndo;//, btnAuto;
boolean humanPlayer = true;
int nrMovable[] = new int[32];
MoveStack moveStack = new MoveStack(104);
String explain = "";
String[] caption;
color TEXTCOLOR, col_resulttext;
String gameStart;
int timerstart;
boolean reduce = false;

Card cards[] = new Card[104];
int autoStat[] = new int[10];

int[] randbuffer;

int nEvals0 = 0;
int nEvalsEnd0;

int nrEval = 0;
boolean evaluating = false;
boolean evaluated = false;

int ifact;

int  x1res, y1res, dx1res, dy1res;
int  x2res, y2res, dx2res, dy2res, x2res0, y2res0;


PFont myFont;
int serie[] = new int[32];
int serie32[] = new int[32];
Os os;
float drawNext = 0.0;
String dataPath = "";
String dataPathImg = "";
String dataPathPhotos = "";
int actualWidth;
float deviceFactor;



void setup() {
  //debug=true;
  //JS screenwidth = screen.width
  background(248);
  if (debug) {
    if (!isProcessing) {
       Processing.logger = console; 
    }
    println("" + new Date());
    println("processing setup: " + millis());
  }
  detectDevice();
  if (!isProcessing) {
    dataPath = "resources/data/";
    dataPathImg = "resources/data/img/";
    dataPathPhotos = "resources/data/photos/";
  }

  //Ext.getDom('sketch').style.width = "320px";
  //  scale(2.0);

  // randomSeed(0);

  //-  Processing.logger = console; 

  // offScreen = createGraphics(320, 568, P3D); // iphone5: 640 * 1136
  //  offScreen = createGraphics(320, 568, JAVA2D); // iphone5: 640 * 1136
  // offScreen = createGraphics(640, 1136, JAVA2D); // iphone5: 640 * 1136
  os = new Os();

  // dbDrop();
  dbCreate();
  openTranslations();

  size(WIDTH0, HEIGHT0);

  actualWidth = min(screen.width, 480);
  deviceFactor = actualWidth / 320.0;

  //myFont = loadFont("SansSerif-12.vlw");
  //-myFont = loadFont("SansSerif-12.vlw");
  //myFont = loadFont("resources/data/helveticaneueultralight.ttf");
  if (isProcessing) {
    myFont = loadFont("SansSerif-12.vlw");
  } else {
  //  myFont = loadFont(dataPath + "helveticaneue.ttf");
  }

  // myFont = createFont("SFUIText", 24, true);
  myFont2 = createFont("SFUIDisplay-Medium", 24, true);
//   myFont = createFont("SFUIDisplay-Light", 24, true);
   myFont = createFont("SFUIDisplay", 24, true);
//  textFont(myFont, F12);  

  textFont(myFont, F12);  

  int n = 0;
  for (int i = 0; i < 4; i++) {
    for (int j=0; j < 13; j++) {
      if (global_cardface == 2) {
        cards[n] = new Card(i, j + 1, n, cardImages[0][i][j], cardImages[1][i][j], cardImages[2][i][j]);
        n++;
        cards[n] = new Card(i, j + 1, n, cardImages[0][i][j], cardImages[1][i][j], cardImages[2][i][j]);
        n++;
      } else {
        cards[n] = new Card(i, j + 1, n, cardImages[0][i][j], cardImages[1][i][j], cardImages[0][i][j]);
        n++;
        cards[n] = new Card(i, j + 1, n, cardImages[0][i][j], cardImages[1][i][j], cardImages[0][i][j]);
        n++;
      }
    }
  }

  allPiles[0] = stockPile = new StockPile(XSS, YSS, 0, 104);
  //  allPiles[1] = acePile = new AcePile(-40, YSA, 1, 8);
  allPiles[1] = acePile = new AcePile(XSS + 60, YSF + DYSF, 1, 8);
  int j = 2;
  for (int i = 0; i < 8; i++)
    allPiles[j++] = foundationPile[2][i] = 
      new FoundationPile(XSF + DXSF * i, YSF, j - 1, 4, 2);
  for (int i = 0; i < 8; i++)
    allPiles[j++] = foundationPile[0][i] = 
      new FoundationPile(XSF + DXSF * i, YSF + DYSF, j - 1, 4, 3);
  for (int i = 0; i < 8; i++)
    allPiles[j++] = foundationPile[1][i] = 
      new FoundationPile(XSF + DXSF * i, YSF + 2 * DYSF, j - 1, 4, 4);
  for (int i = 0; i < 8; i++)
    allPiles[j++] = tableau[i] = 
      new TableauPile(XST + DXSF * i, YST, j - 1, 10);

//  btnEvaluate = new Button(getTranslation(LANG, "Evaluate"), XRES - ifact * 135, YRES - ifact * 15, WBF, HBF, 1);
//  btnEvaluate = new Button(getTranslation(LANG, "Evaluate"), XRES - ifact * 105, YRES - ifact * 15, WBF, HBF, 1);
//  btnEvaluate = new Button(getTranslation(LANG, "Evaluate"), XRES - ifact * 105, YRES-  ifact * 10, WBF, HBF, 1);

int ybtns = YBN + 60;
  btnEvaluate = new Button(getTranslation(LANG, "Evaluate"), XBN + ifact * 132, ybtns, WBF, HBF, 1);

  btnNew = new Button(getTranslation(LANG, "New"), XBN - ifact * 60, ybtns, WBN, HBN, 1);
  btnUndo = new Button(getTranslation(LANG, "Undo"), XBN, ybtns, WBU, HBU, 1);  
  //btnUndo = new Button(getTranslation(LANG, "Undo"), XBU - ifact * 50, YBU - ifact * 6, WBU, HBU, 1);
  // btnAuto = new Button(getTranslation(LANG, "Auto"), XBN + ifact * 15, YBU - ifact * 2, WBN, HBN, 1);
  // btnAuto = new Button(getTranslation(LANG, "Auto\nplay"), XBN + ifact * 100, ybtns, WBN, HBN, 1);
//  btnRedo = new Button(getTranslation(LANG, "Redo"), XBN + ifact * 15, YBN, WBN, HBN, 1);
  btnRedo = new Button(getTranslation(LANG, "Redo"), XBN + ifact * 60, ybtns, WBU, HBU, 1);  
  for (int i = 2; i < 34; i++) {
    serie[i - 2] = i;
    serie32[i - 2] = i;
  }

  moverCollection = new MoverCollection();

  String[] imagenr = { 
    "0611b", "0812b", "1021b", "1029b", "1049b", "1058b", "1080b", "1119b", 
    "1125b", "1144b", "1536b", "1747b", "1972b", "2070b", "2225b", "2856b", "2867b"
  };

  String[] imagename = { 
    "adula", "clariden", "gelb", "mittelholzer","mittelholzer2", "pratod", "terri", "terribw", "toedi", "uomo", "grafik","showyourstripes_switzerland"
  };

  caption = [
     "Adula (3402m) from Val Malvalglia", "Laghetto (2233m) near Cima di Pinadee", "", "", "Pizzo Cassinello (3103m)", "", "Adula (3402m) from Pizzo Cassinello", "Oratorio di Santa Caterina d'Alessandria (Ponto Aquilesco)", 
    "From Campra to the east", "In Val Scaradra", "Motterascio", "Oratorio di Santa Caterina d'Alessandria (Ponto Aquilesco)", "Val Canal", "Adula (3402m) from Lago Retico", "Cima di Gana Bianca (2843m)", "Piz Terri (3149m)", "Piz Terri (3149m) from Corói",
     "Adula (3402m) from south", "Clariden (3267m) and Tödi (3614m) from Pizzo dell'Uomo", "", "Adula (3402m), areal view by Walter Mittelholzer, 1923", "Adula (3402m), areal view by Walter Mittelholzer, 1919", "Prodóir (1460m)", "Piz Terri (3149m)", "Piz Terri (3149m) Corói", "Clariden (3267m) and Tödi (3614m)", "Pizzo dell'Uomo (2663m)", "Data: Swiss Glacier Monitoring", "Warming Stripes for Switzerland 1864-2019"
];

  bimg = new PImage[imagenr.length + imagename.length];


  for (int i = 0; i < imagenr.length; i++) {
  //  println(i + " " + dataPathPhotos + "img_" + imagenr[i] + ".png");
    bimg[i] = loadImage(dataPathPhotos + "img_" + imagenr[i] + ".png");
  }
  j = imagenr.length;
  for (int i = 0; i < imagename.length; i++) {
  //  println((i + j) + " " + dataPathPhotos + imagename[i] + ".png");
   bimg[i + j] = loadImage(dataPathPhotos + imagename[i] + ".png");
 }

  randbuffer = new int[bimg.length / 2];
  for (int i = 0; i < randbuffer.length; i++) {
    randbuffer[i] = -1;
  }
 if (global_resimg == '' || global_resimg == 0 || global_resimg == "0") {
   lastGames = loadImage(dataPathPhotos + "emptyLastGames.png");
 } else {
  lastGames = loadImage(global_resimg);
 }

  statistics.statisticsgraphinit();

  newGame();
  if (debug) println("processing end setup: " + millis());

  //   zeitAuswertungen();
  smooth();

  loop();
}

void doStatisticsGraphInit() {
  statistics.statisticsgraphinit();
}

void drawE() {
  btnUndo.draw(false);
  fill(255);
  rect(XRES - 20, YRES - 20, 40, 40)
  statistics.drawEvaluationLegend(resPlayer, YRES - ifact * 30);
  textFont(myFont, F14);
  fill(color(0));
  stroke(color(0));
  jx = max(min(resPlayer, 93), 2);
  jx = 3 + jx * ifact * 10 / 3;
  textC(resPlayer + "", jx, YRES - ifact * 10);
}

void doEvaluation(int n, float alfa) {
  humanPlayer = false;
  debug = false;
  evaluating = true;
  stroke(0);
//  btnUndo.draw(false);
  //  int start = millis();
  for (int i = 0; i < n; i++) {
    btnNew.draw(false);
    btnRedo.draw(false);
    statistics.add(evalGame(alfa));
  }
  // int d1 = (millis() - start);
}

void draw() {
//    int i = random(bimg.length);
//      image(bimg[i], 0, 0, 640, 640);
    

 // println("D");
  //TODO change 320px for iPhone6
  // println(device + " " + screen.width+ " " + screen.height+ " " + online);
  /*
  if (device == "iPhone6") {
    Ext.getDom("sketch").style.width = "375px";
  } else if (device == "iPhone6s") {
    Ext.getDom("sketch").style.width = "414px";
  } else {  
    Ext.getDom("sketch").style.width = "320px";
  }
  */

  Ext.getDom("sketch").style.width = actualWidth + "px";

  if (evaluating) {
    doEvaluation(NEVALUATIONSTEP, alfa);
    nrEval += NEVALUATIONSTEP;
    nEvals0 += NEVALUATIONSTEP;
    drawProgress(nEvals0, nEvalsEnd0);
    if (nrEval >= nEvaluationsEnd) {
      if (debug) 
        println((millis() - timerstart) / 1000.0 + " sec");
 //     color(0);fill(0);
 //     text((millis() - timerstart) / 1000.0 + " sec", 300, 380);

      statistics.doStatistics();
      statistics.saveResultat(alfa, gameStart);
      drawProgress(-1, nEvalsEnd0);
      nEvalsEnd0 = 0;
      nEvals0 = 0;
      global_statistics0 = global_statistics;
      getAllStats();
      evaluating = false;
      evaluated = true;
    } 
    evaluationfinished = true;
 //   dirty = true;
    return;
  }

  if (getResult() == 0  && humanPlayer) {
    int nloops = 5;
    if (windrawloop > nloops) {
      return;
    }
    if (windrawloop < 0) {
      windrawloop = 1;
      imgNow = morerandom(bimg.length, randbuffer);
      randbuffer = addlast(imgNow, randbuffer);
      res = getResult();
      gameFinished = stockPile.empty() && !cardMoving() && noMovables(); 
      if (gameFinished && humanPlayer) {
        resPlayer = res;
      }
      allDraw();
    }
    windrawloop++;
    tint(255, round(map(windrawloop, 0, nloops, 50, 255)));
    if (windrawloop == nloops) {
      fill(50,0,0);
      stroke(50,0,0);
      textFont(myFont, F9);
      textR(caption[imgNow], ifact * 310, ifact * 344);
      noTint();
    }
    // println(bimg + " " + bimg[imgNow]);
    if (reduce) {
      image(bimg[imgNow], 0, 0, 640, 640);
    } else {
      image(bimg[imgNow], 0, 0);
    }
    noTint();
    return;
  }
  if (!dirty) noLoop();
  if (!dirty) return;
  // println("d");

// webkit-zeug hier?

  allDraw();
  doAllAceMoves();
  allOkChecks();
  allMovableChecks();
  allAutoMovableChecks();
  allJamChecks();

  res = getResult();

  gameFinished = stockPile.empty() && !cardMoving() && noMovables(); 
  // Game finished
  if (gameFinished && humanPlayer) {
    resPlayer = res;
  }

  dirty = cardMoving();
  for (int i = 0; i < 34; i++) {
    if (allPiles[i].autoMovable) {
      if (!humanPlayer || (global_sayAuto == 0 && global_auto !== 0)) allPiles[i].doAutoClick();
//      if (global_sayAuto) allPiles[i].doAutoClick();
      dirty = true;
      return;
    }
  }
  allDraw();
 
  // if (reduce) 
// if (reduce) Ext.getDom("sketch").style = " -webkit-transform: scale3d(0.5, 1.5, 0) translate3d(200px, 110px, 0);";
}

int evalGame(float alphanow) {
  initLayout();
  doAllAceMoves();
  allOkChecks();
  while (!stockPile.empty ()) {
    while (tryToMove (alphanow)) {
    }
    moveStock2Tableau();
    doAllAceMoves();
    allOkChecks();
  }
  while (tryToMove (2.0)) {
  }
  return getResult();
}

boolean tryToMove(float alfa) {
  if (random(1) > alfa) return false;
  for (int i = 31; i >= 0; i--) {
    int j = int(random(i));
    int k = serie32[j];
    serie32[j] = serie32[i];
    serie32[i] = k;
    allPiles[k].doMovableCheck();
    if (allPiles[k].movable) {
      doEvalMove2(allPiles[k], allPiles[k].ziel);
      return true;
    }
  }
  return false;
}

void doEvalMove(int k) {
  CardPile to = allPiles[k].ziel;
  to.push(allPiles[k].pop());
  to.ok = true;
}

void doEvalMove2(CardPile from, CardPile to) {
  to.push(from.pop());
  to.ok = true;
}

void doMove(CardPile from, CardPile to, boolean auto) {
  if (humanPlayer) {
    moverCollection.start(from, to, auto, global_steps);
  } else {
    if (debug) println(from.peek().toString() + ": " + from.kind + " > " + to.kind);
    to.push(from.pop());
  }
}

void shuffle32() {
  for (int i = 31; i >= 0; i--) {
    int j = int(random(i));
    int k = serie[j];
    serie[j] = serie[i];
    serie[i] = k;
  }
}

void shuffle32b() {
  for (int i = 31; i >= 0; i--) {
    int j = int(random(i));
    int k = serie32[j];
    serie32[j] = serie32[i];
    serie32[i] = k;
  }
}

int getResult() {
  res = 96;
  for (int i = 2; i < 26; i++) {
    res -= allPiles[i].nOk();
  }
  return res;
}

void allOkChecks() {      
  for (int i = 2; i < 34; i++) {
    if (!allPiles[i].ok) 
      allPiles[i].doOkCheck();
  }
}

void doAllAceMoves() {      
  for (int i = 2; i < 34; i++) {
    if (allPiles[i].isAce()) {
      doMove(allPiles[i], acePile, true);
    };
  }
}

void allMovableChecks() {    
  for (int i = 2; i < 34; i++) {
    allPiles[i].doMovableCheck();
  }
}

void allAutoMovableChecks() {      
  for (int i = 2; i < 34; i++) {
    allPiles[i].doAutoMovableCheck();
  }
}

void allJamChecks() {      
  for (int i = 26; i < 34; i++) {
    allPiles[i].doJamCheck();
  }
}

void drawProgress(int part, int all) {
  if (part < 10) drawE();
  if (part < 0) {
    //println(statistics.mean + " " + resPlayer);
    noStroke();
    fill(statistics.getResColor(statistics.mean, resPlayer));
    rect(0, YPROGRESS - 0.5 * ifact, width, DYPROGRESS + 0.5 * ifact);
    fill(0);
    textFont(myFont, F12);
    textC("Tap to continue.", width / 2, YRES - ifact * 46);
    fill(255, 200, 12);
    noStroke();
  //   rect(0, YPROGRESS + DYPROGRESS + 3, width, 0.6 * DYPROGRESS);
    statistics.setResPlayer(resPlayer);
    PImage nowImage;
    resImage = get(0, 0, width, width);
    nowImage = get(0, 0, width, width);
    nowImage.resize(width/25, width / 16);
    int ylastgames = width + 230;
    if (nEvaluationsEnd <= global_evaluations) {
      image(lastGames, width/25, ylastgames);
    }
    image(nowImage, 0, ylastgames);
    stroke(255);
    line(width/25, ylastgames, width/25, ylastgames + width/16);
    lastGames = get(0, ylastgames, width, width/16);
    //image(lastGames, 0, ylastgames);
    lastGames.loadPixels();
    doSaveResultImage(lastGames);
// 
  } else {
    float p = float(part) / float(all);
    if (p < drawNext) return;
    drawNext += 0.01;
    // if (drawNext >= 0.95) drawNext = 1.0;
    fill(255);
    noStroke();
    rect(0, YPROGRESS, width, DYPROGRESS);
    //    fill(128); 
    //    rect(0, YPROGRESS + 8 * ifact, p * width, 4 * ifact);
    fill(0, 122, 255);
    fill(122);
    rect(0, YPROGRESS + 16 * ifact, p * width, 4 * ifact);
  }
  stroke(0);
  line(0, YPROGRESS - ifact, width, YPROGRESS - ifact);
  line(0, YPROGRESS + DYPROGRESS, width, YPROGRESS + DYPROGRESS);
}

// DRAWING

void allDraw() {
  if (mustDraw) {
    osp = true;
    offScreen.beginDraw();
    offScreen.background(248);
    offScreen.fill(255);
    offScreen.stroke(255);
    offScreen.rect(0, ifact * 331, width, 670);
    offScreen.stroke(224);
    offScreen.line(0, ifact * 331, width, ifact * 331);
    offScreen.stroke(0);
    for (int i = 0; i < 34; i++) {
      allPiles[i].draw();
    }
     int ylastgames = width + 230;
     offScreen.image(lastGames, 0, ylastgames);

    offScreen.endDraw();
    mustDraw = false;
    osp = false;
  } 

  if (!evaluated) {
    image(offScreen, 0, 0);
  } else {
    // HERE
    stroke(255);
    fill(255);
    rect(0, ifact * 350, width, ifact * 80);
  }

  if (global_helplevel == 9 || global_helplevel == 10) {
    for (int i = 0; i < 34; i++) {
      allPiles[i].drawArrow();
    }
  }

  if (humanPlayer)
  btnUndo.draw(moveStack.nMoves > 0 && res != 0);
  //btnAuto.draw3(true, !global_noHelp);

  if (humanPlayer) {
    int nact = moverCollection.draw();
    if (nact == 0) {
      mustDraw = true;
    }
  } else {
    // copy(0, 0, 320, 320, 144, 430, 96, 96);
    drawHisto(XSTAT, YHISTO - ifact * 2);
    drawStatistics(XSTAT, YSTAT - ifact * 10);
    fill(statistics.getResColor(statistics.mean, resPlayer));
    drawResult(XSTAT, YSTAT - ifact * 21);
  }
  btnNew.draw((!gameFinished && stockPile.nCards > 32) || evaluated);
  btnRedo.draw(evaluated);
  if (res > 94) {
    mymsg = version;
  }
  if (debug) My.msg(mymsg);
  btnEvaluate.draw(gameFinished);
  // btnAuto.draw3(!gameFinished, !global_noHelp);
  fill(col_resulttext);
  if (gameFinished) {
    //   textFont(myFont, F18); 
    if (evaluating) {
   //   println("Evaluating");
      textC("Evaluating", XRES - ifact * 95, YRES - ifact * 12);
    } else {
      //  textC("Evaluateeeee", XRES - ifact * 95, YRES - ifact * 12);
    }
    if (!evaluated && res != 0) {
      textFont(myFont, F12);
      textC("The End. Now the evaluation:", XRES - ifact * 95, YRES - ifact * 46);
    }
  }
  if (humanPlayer) {
    textFont(myFont, F18); 
    if (gameFinished) {
    //  drawE();
      // textFont(myFont, F24);
      // statistics.drawEvaluationLegend(res, YRES - ifact * 30);
     // textC(res + "", res * ifact * 10 / 3, YRES);
    }
    textC(res + "", XRES, YRES);
    
  //  drawE();
 //    textC(res + "", res * ifact * 10 / 3, YRES);
    textFont(myFont, F12);
    if (res == 0) {
      // textC(getTranslation(LANG, "You win!"), XRES/2, YRES);
//      textC(getTranslation(LANG, "You win!"), XBU - ifact * 20, YRES - ifact * 2);
    }
  } 
  if (explain != "") {
    textC(explain, XRES + 50, YRES);
  }
  if (noMovables() && !cardMoving() && humanPlayer && res != 0) {
    os.mynoStroke();
    os.myfill2(0, 40);
    os.myrect(0, 0, width, ifact * 331);
  }
}

int numberOfMovables() {
  int nAuto = 0;
  for (int i = 0; i < 34; i++) {
    if (allPiles[i].movable) {
      nAuto++;
    }
  }
  return nAuto;
}

void newGame() {
  redoing = false;
  humanPlayer = true;
  nrEval = 0;
  nEvaluationsEnd = 0;
  evaluated = false;
  statistics.emptyStat();
  moveStack.clear();
  boolean startable = false;
  while (!startable) {
    shuffle();
    startable = checkStartable();
  }
  windrawloop = - 1;
  gameStart = My.simpleDateFormat();
  initLayout();
}

void redoGame() {
  redoing = true;
  humanPlayer = true;
  nrEval = 0;
  nEvaluationsEnd = 0;
  evaluated = false;
  statistics.emptyStat();
  moveStack.clear();
  windrawloop = - 1;
  gameStart = My.simpleDateFormat();
  initLayout();
}

boolean checkStartable() {
  for (int i = 0; i < 24; i++) {
    Card card = cards[103 - i];
    if (card.isAce()) return true;
    int base = int(i / 8) + 2;
    if (card.rank == base) return true;
  }
  return false;
}

void initLayout() {
  for (int i = 0; i < 34; i++) 
    allPiles[i].clear();
  for (int i = 0; i < 104; i++) {
    cards[i].jammer = false;
    cards[i].jammed = false;
    stockPile.push(cards[i]);
  }
  moveStock2Foundation(2);
  moveStock2Foundation(0);
  moveStock2Foundation(1);
  moveStock2Tableau();
}

void moveStock2Tableau() {
  for (int i = 0; i < 8; i++) {
    doMove(stockPile, tableau[i], true);
  }
}

void moveStock2Foundation(int row) {
  for (int i = 0; i < 8; i++) {
    doMove(stockPile, foundationPile[row][i], true);
  }
}

void doUndo() {
  dirty = true;
  Move m = moveStack.pop();
  if (m == null) return;
  moverCollection.startUndo(m.to, m.from, 12);
  loop();
  if (m.auto) {
    doUndo();
  }
}

void doUndoClick() {
  if (cardMoving() || acePile.reserved) return;
  doUndo();
}

/*
void doAutoSwitch() {
  global_noHelp = !global_noHelp;
  dirty = true;
}
*/
boolean noMovables() {
  for (int i = 2; i < 34; i++) {
    if (allPiles[i].movable)
      return false;
  }
  return true;
}

void mouseClicked() {
 // dirty = true;
  loop();
  int x = mouseX;
  int y = mouseY;
//  mymsg = x + " / " + y + " " + device;
 // println(mymsg);
  y -= deltay;
  if (reduce) {
    x *= 2;
    y *= 2;
  }
  //  mymsg = x + " / " + y;
  // println(mymsg);
/*  if (device == "iPhone6") {
    x = round(x / 1.171875);
    y = round(y / 1.171875);
  } else if (device == "iPhone6s") {
    x = round(x / 1.29375);
    y = round(y / 1.29375);
  }  
*/

  x = round(x / deviceFactor);
  y = round(y / deviceFactor);

  // mymsg = x + " / " + y;
  // println(mymsg);
  for (int i = 0; i < 34; i++) {
    if (allPiles[i].includes(x, y))
      allPiles[i].doClick();
  }

  if (btnEvaluate.includes(x, y)) {
    btnEvaluate.draw(false);
    //btnAuto.draw3(false, false);

    moveStack.clear();
    evaluating = true;
    nrbox = 0;
    btnNew.draw(false);
    btnRedo.draw(false);
    if (resPlayer > 0 || (resPlayer == 0 && evaluated)) {
      fill(0);
      stroke(0);
      rect(0, 0, width, width + 1);
    }
    statistics.setResPlayer(resPlayer);
    drawNext = 0.0;
    if (global_evaluations == 250) {
      dx1res = ifact * 20;
      dy1res = ifact * 20;
    } else {
      dx1res = ifact * 10;
      dy1res = ifact * 10;
    }
    nEvaluationsEnd += global_evaluations;
    nEvalsEnd0 += global_evaluations;
    if (y1res < 20 || global_evaluations == 1000) {
      x1res = - dx1res; 
      y1res = 0;
      x2res = x2res0 - dx2res; 
      y2res0 = 2 * 341;
      y2res0 = 2 * 500;
    }
    timerstart = millis();
    return;
  }
  if (evaluationfinished) {
    evaluationfinished = false;
    dirty = true;
  }

  if (btnNew.includes(x, y) && !evaluating) newGame();
  if (btnRedo.includes(x, y) && !evaluating) redoGame();
  if (btnUndo.includes(x, y)) doUndoClick();
  //if (btnAuto.includes(x, y)) doAutoSwitch();
}

void keyPressed() {
  if (key == 'p' || key == 'P') {
    for (int i = 0; i < 34; i++) {
      println(allPiles[i].toString());
    }
  }
  if (key == 's' || key == 'S') {
    sayAutoReasonStat();
  }
  if (key == 'm' || key == 'M') {
    moveStack.print();
  }
  if (key == 'd' || key == 'd') {
    mustDraw = true;
  }
  if (key == 'z' || key == 'Z') {
    zeitAuswertungen();
  }
}

void sayAutoReasonStat() {
  for (int i = 0; i < autoStat.length; i++) {
    print(autoStat[i] + " ");
  }
  println();
}

void sayAutoReason(int id, int type, String what, String card) {
  // println(global_sayAuto);
  if (global_sayAuto != 1) return;
  String shortTxt[] = {
    "", "T ok", "2 poss", "F clean", "just 1", "T botm", 
    "T row", "Tbelow", "T botm", "TuBase", "Tjammed"
  };
  autoStat[type] ++;
  /*  if (false) {
   for (int i = 0; i < 9; i++) {
   print(autoStat[i] + " ");
   }
   println();
   }
   */
 // println(id + " " + type + " " + what + " " + card);
  os.myfill4(255, 255, 0, 200);
  os.myrect(allPiles[id].getTopX(), allPiles[id].yc - 13, CARDWIDTH, 26);
  os.mystroke(0);
  os.myfill(0);
  os.mytextFont(myFont, F10);  
  textC(shortTxt[type], allPiles[id].xc, allPiles[id].yc);
}

void info(String what) {
  //   println("* " + card + ": " + what + "(#" + type + ")");
}

boolean cardMoving() {
  if (evaluating) return false;
  return moverCollection.isOneActive();
}

int countOKs() {
  int n_ok = 0;
  for (int i = 2; i < 26; i++) {
    n_ok += allPiles[i].nOk();
  }
  return n_ok;
}

void shuffle() {
  for (int i = 103; i >= 0; i--) {
    int j = int(random(i));
    Card card = cards[j];
    cards[j] = cards[i];
    cards[i] = card;
  }
}

