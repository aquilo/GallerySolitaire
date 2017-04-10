// My -------------------------------------------------------------

HashMap hm = new HashMap();

static class My {

/*   static String runden(float num, int n) {
    println(num + " " + n);
    println(nfc(num, n));
    return nfc(num, n);
  }
*/

/*  static String runden(float num, int n) {
    if (num == 0) {
      return "0";
    }
    float x = pow(10, n);
    return nfc(round( num * x ) / x, n);
  }
*/

  static String round2String(float num, int n) {
    float x = pow(10, n);
    return nf(round(num * x) / x, 0, 2);
  }

  static int prozround(int x, int n) {
    return (int) round(100.0 * ((float) x) / (float) n);
  }

  static float interpol(int anow, int afrom, int ato, float bfrom, float bto) {
    return bfrom + ((float) (anow - afrom) / (float) (ato - afrom)) * (bto - bfrom);
  }

  static String simpleDateFormat() {
    //   new SimpleDateFormat("dd.MM.yyyy_HH:mm:ss");
    return fill2(day()) + "." + fill2(month()) + "." + year() +
      "_" + fill2(hour()) + ":" + fill2(minute()) + ":" + fill2(second());
  }

  static String fill2(int inum)  {
    String s = "" + inum;
    if (s.length() == 1) return "0" + s;
    else return s;
  }

  static void msg(String txt) {
    if (!debug) return;
    stroke(255);
    fill(255);
    rect( XMSG, YMSG, ifact * 200, ifact * 670);
    stroke(0);
    fill(0);
    textFont(myFont, F12);
    text(txt, XMSG, YMSG, DXMSG, ifact * 200);
  }

}

void openTranslations() {
  //-  LANG = navigator.language.substring(0, 2);
//  String lines[] = loadStrings(dataPath + "translations.txt");
    dataPath = "resources/data/";
  console.log(dataPath);
  String lines[] = loadStrings(dataPath + "translations.txt");
  String[] lang = split(lines[0], "\t");
  int langs = lang.length;

  for (int i = 1; i < lines.length; i++) {
    for (int j = 1; j < langs; j++) {
      String[] words = split(lines[i], "\t");
      if (j < words.length)  
        hm.put(lang[j] + "_" + words[0], words[j]);
    }
  }
}

String getTranslation(String lang, String t) {
  if (lang == "en") return t.replace("$", "\n");
  Object a = hm.get(lang + "_" + t);
  if (a == null) return t.replace("$", "\n");
  return a.toString().replace("$", "\n");
}

int morerandom(int m, int[] a) {
  int res = -9;
  if (m <= a.length || a.length < 1) {
    res = int(random(m));
    return res;
  } 
  boolean found = false;
  while (!found) {
    res = int(random(m));
    found = true;
    for (int i = 0; i < a.length; i++) {
      if (a[i] == res) {
        found = false;
        break;
      }
    }
  }
  return res;
}

void zeitAuswertungen() {
  // for comparison of some routines
  int start, dtime;
  int n = 10000000;
  int xxx = 7;
  Card topCard = cards[55];
  int zz;
  println(topCard);
  start = millis();
  for (int ii = 0; ii < n; ii++) {
    zz = topCard.rank - 3;
    for (int i = 0; i < 8; i++) {
      FoundationPile f = foundationPile[xxx % 3][i];
      if (!f.empty()) {
        Card d = f.peek();
        if (zz == d.rank && topCard.suit == d.suit ) {
        }
      }
    }
  } 
  dtime = (millis() - start);
  println(n + " evaluations in " + dtime + " millis");
  start = millis();
  for (int ii = 0; ii < n; ii++) {
    for (int i = 0; i < 8; i++) {
      FoundationPile f = foundationPile[xxx % 3][i];
      if (!f.empty()) {
        Card d = f.peek();
        if ((topCard.rank - d.rank) == 3 && topCard.suit == d.suit) {
        }
      }
    }
  } 
  dtime = (millis() - start);
  println(n + " e2valuations in " + dtime + " millis");
}  

int[] addlast(int val, int[] a) {
  for (int i = 1; i < a.length; i++) {
    a[i - 1] = a[i];
  }
  a[a.length - 1] = val;
  return a;
}

void textR(String s, int x, int y) {
  os.mytextAlign(RIGHT);
  os.mytext(s, x, y);
  os.mytextAlign(LEFT);
}

void textC(String s, int x, int y) {
  os.mytextAlign2(CENTER, CENTER);
  os.mytext(s, x, y);
//  println(s + " " +  x + " " + y);
  os.mytextAlign2(LEFT, BASELINE);
}

class Os {
  void myimage(PImage p, int x, int y)  {
    if (osp)
      offScreen.image(p, x, y);
    else
      image(p, x, y);
  }

  void mynoStroke() {
    if (osp)
      offScreen.noStroke();
    else
      noStroke();
  }

  void mynoFill() {
    if (osp)
      offScreen.noFill();
    else
      noFill();
  }

  void mytextAlign(int a) {
    if (osp)
      offScreen.textAlign(a);
    else
      textAlign(a);
  }

  void myrectMode(int a) {
    if (osp)
      offScreen.rectMode(a);
    else
      rectMode(a);
  }

  void myellipseMode(int a) {
    if (osp)
      offScreen.ellipseMode(a);
    else
      ellipseMode(a);
  }

  void mytextAlign2(int a, int b) {
    if (osp)
      offScreen.textAlign(a, b);
    else
      textAlign(a, b);
  }

  void mytextFont(PFont pf, int s) {
    if (osp)
      offScreen.textFont(pf, s);
    else
      textFont(pf, s);
  }

  void myfill(int g) {
    if (osp)
      offScreen.fill(g);
    else
      fill(g);
  }
  void mystroke(int g) {
    if (osp)
      offScreen.stroke(g);
    else
      stroke(g);
  }

  void myfill2(int g, int a) {
    if (osp)
      offScreen.fill(g, a);
    else
      fill(g, a);
  }

  void myfill3(int r, int g, int b) {
    if (osp)
      offScreen.fill(r, g, b);
    else
      fill(r, g, b);
  }

  void mystroke3(int r, int g, int b) {
    if (osp)
      offScreen.stroke(r, g, b);
    else
      stroke(r, g, b);
  }

  void mytext(String s, int x, int y) {
    if (osp)
      offScreen.text(s, x, y);
    else
      text(s, x, y);
  }

  void myfill4(int r, int g, int b, int a) {
    if (osp)
      offScreen.fill(r, g, b, a);
    else
      fill(r, g, b, a);
  }

  void myrect6(int x, int y, int w, int h, int r1, int r2) {
    if (osp)
      offScreen.rect(float(x), float(y), float(w), float(h), float(r1), float(r2), float(r1), float(r2));
    else
      rect(x, y, w, h, r1, r2, r1, r2);
  }

  void myrect(int x, int y, int w, int h) {
    if (osp)
      offScreen.rect(x, y, w, h);
    else
      rect(x, y, w, h);
  }

  void myellipse(int x, int y, int w, int h) {
    if (osp)
      offScreen.ellipse(x, y, w, h);
    else
      ellipse(x, y, w, h);
  }
}
