// Statistics -------------------------------------------------------------

boolean titlePrinted = false;

class Statistics {
  int less, more;

  int median = -1, equal, n, modus, scores;

  int minimum = 97, maximum = -1;
  int histo[];
  float gless, gequal, gmore, mean;
  int res;
  int boxx[], boxy[];

  String str_result, str_mean, str_equal;
  float resultf;

  Statistics() {
    str_result = " ";
    histo = new int[97];
    boxx = new int[1000];
    boxy = new int[1000];
  }

  void statisticsgraphinit() {
    if (global_evaluations == 250) {
      dx1res = ifact * 20;
      dy1res = ifact * 20;
    } else {
      dx1res = ifact * 10;
      dy1res = ifact * 10;
    }
    x1res = -dx1res; 
    y1res = 0;
    for (int i = 0; i < global_evaluations; i++) {
      x1res += dx1res;
      if (x1res >= width) {
        x1res = 0;
        y1res += dy1res;
        if (y1res >= ifact * 310) {
          y1res = 0;
        }
      }
      boxx[i] = x1res;
      boxy[i] = y1res;
    }
    randomizeEvaluation();
  }

  void randomizeEvaluation() {
    for (int i = global_evaluations - 1; i >= 0; i--) {
      int j = int(random(i));
      int k = boxx[j];
      boxx[j] = boxx[i];
      boxx[i] = k;
      int k = boxy[j];
      boxy[j] = boxy[i];
      boxy[i] = k;
    }
  }

  void add(int resultat) {
    histo[resultat]++;
    draw1Result(resultat, res);
  }

  void drawEvaluationLegendOne(int i, int myres, int iy, boolean evnot) {
    //     if (histo[i] > 1) return;
    if (i != 1 && i != 95) {
      int ix;
      if (histo[i] > 0) {
        if (i == myres && histo[i] > 1) {
          ix = min(i, 95) * ifact * 10 / 3;
          c = color(55);
          fill(c);
          rect(ix, iy - 4, dx, 4);
        }
        if (evnot && histo[i] > 1) {
          return;
        }
        c = getResColor(i, myres);
        if (i == myres) {
          c = color(255);
        }
      } else {
        if (evnot) {
          return;
        }
        c = histo[i] == 0 && i == myres ? color(55) : color(220);
      }
      noStroke();
      dy = ifact * 9;
      fill(c);
      ix = min(i, 95) * ifact * 10 / 3;
      if (i == 0) {
        dx = ifact * 13 / 3;
      } else {
        dx = ifact * 10 / 3;
      }
       rect(ix, iy, dx, dy);
      stroke(0);
      line(ix, iy, ix, iy + dy - ifact);
      if (i == 0) {
        line(dx, iy, dx, iy + dy - ifact);
      }
      if (evnot) {
        ix = ix + dx;
        line(ix, iy, ix, iy + dy - ifact);
      }
    }
  }

  void drawEvaluationLegend(int myres, int iy) {
    color c;
    boolean all;
    inx jx, dx, dy, drawNext;
    int n = 0;
    dy = ifact * 9;
    for (int i = 0; i < 97; i++) {
      n += histo[i];
    }
    all = n < 100;

    all = false;
    for (int i = 0; i < 97; i++) {
      drawEvaluationLegendOne(i, myres, iy, false);
    }
  }

  void draw1Result(int now, int myres) {
    /*
    x1res += dx1res;
    if (x1res >= width) {
      x1res = 0;
      y1res += dy1res;
      if (y1res >= ifact * 310) {
        y1res = 0;
      }
    }
    */
    x1res = boxx[nrbox];
    y1res = boxy[nrbox];
    stroke(0);
    setResColor(now, myres);
    //  fill(getResColor(float(now), myres));
    rect(x1res, y1res, dx1res, dy1res);
    nrbox++;

    drawEvaluationLegendOne(now, myres, YRES - ifact * 30, true);

    //IDEA plot of a small fingerprint of this game
    
/*
     x2res += dx2res;
     if (x2res >= x2res0 + ifact * 31) {
     x2res = x2res0;
     y2res += dy2res;
     if (y2res >= y2res0 + ifact * 31) {
     y2res = y2res0;
     }
     }
     //  stroke(getResColor(float(now), myres));
     //  println(x2res + " " + y2res);
     noStroke();
     rect(x2res, y2res, dx2res, dy2res);
     stroke(0);
     //  point(x2res, y2res)
    */
     
  }

  color getResColor(float now, int myres) {
    if (now == myres) {
      if (now == 0) {
//        return color(255, 255, 50);
        return color(200);
      } else {
        return color(255);
      }
    } else if (now == 0) {
      return color(175, 0, 0); //TODO: color
 //     return color(255, 127, 255); //TODO: color
 //     return color(255, 100, 220); //TODO: color
    }

    float amt = min(1.0, max(-1.0, ((now - myres) / 40.0)));
    if (amt > 0) {
      return color(lerpColor(winfrom, winto, amt));
    } else {
      return color(lerpColor(lostfrom, lostto, -amt));
    }
  }

  void setResColor(int now, int myres) {
    fill(getResColor(now, myres));
    return;
    /*
     if (now == myres) {
      if (now == 0) {
        fill(255, 255, 150);
      } else {
        fill(255);
      }
      return;
    } else if (now == 0) {
      fill(50, 255, 0); //TODO: color
      return;
    }

    float amt = min(1.0, max(-1.0, ((now - myres) / 40.0)));
    if (amt > 0) {
      fill(lerpColor(winfrom, winto, amt));
    } else {
      fill(lerpColor(lostfrom, lostto, -amt));
    }
    */
  }

  void emptyStat() {
    for (int i = 0; i < histo.length; i++)
      histo[i] = 0;
  }

  void setResPlayer(int res0) {
    res = res0;
  }

  void doStatistics() {
    n = 0;
    for (int i = 0; i < 97; i++)
      n += histo[i];
    int xmed = (int) Math.round(n / (2.0 - 0.0000001));
    int nn = 0;
    less = more = 0;
    minimum = 97;
    maximum = median = -1;
    int maxres = 0, nXi = 0;
    scores = 0;
    for (int i = 0; i < 97; i++) {
      if (histo[i] > 0 && minimum > i)
        minimum = i;
      if (histo[i] > 0 && maximum < i)
        maximum = i;
      if (histo[i] > 0)
        scores++;
      nn += histo[i];
      if (median < 0 && nn >= xmed) median = i;
      if (i < res)
        less += histo[i];
      if (i > res)
        more += histo[i];
      if (histo[i] > maxres) {
        maxres = histo[i];
        modus = i;
      }
      nXi += i * histo[i];
    }
    int equal = histo[res];
    resultf = (100.0 * ((float) more + ((float) equal) / 2.0) / (float) n);
    str_result = My.round2String(resultf, 3);
    float gn = (float) n / 100.0;
    gmore = ((float) more) / gn;
    gequal =  ((float) equal) / gn;
    gless =  ((float) less) / gn;
    more = My.prozround(more, n);
    equal = My.prozround(equal, n);
    less = My.prozround(less, n);
    mean = (float) nXi / (float) n;
    str_mean = My.round2String((float) nXi / (float) n, 3);
    str_equal = My.round2String(100.0 * (float) equal / (float) n, 3);
  }

  String toString() {
    String str = less + " " + more + " " + str_mean;
    return str;
  }

  void saveResultat(float alphanow, String gameId) {
    String s = "\"" + gameId + "\", " + My.round2String(alphanow, 5) + "," + res + "," + str_result + "," +
      My.round2String(gless, 2) + "," + My.round2String(gequal, 2) + "," + My.round2String(gmore, 2) + "," +
      minimum + "," + median + "," + str_mean + "," + maximum + "," + 
      modus + "," + scores +  "," + n +  "," +  nAutoMovesStat +  "," + nMovesStat;
    dbSave(s);
    //    println(s);
  }
}

void drawHisto(int x0, int y0) {
  float fhisto;
  int x = x0;
  int y = y0;
  int xx = x + ifact * 4;

  int dy0 = 194;
  int dy = ifact * dy0;

  int maxres = 0;
  //colorblind = global_colorblind == 1;
  //NEW
  colorblind = true;

  for (int i = 0; i < 97; i++) {
    if (statistics.histo[i] > maxres) {
      maxres = statistics.histo[i];
      statistics.modus = i;
    }
  }

  fill(255);
  stroke(0);
  rect(x, y, ifact * 200, dy);
  fhisto = (float) statistics.histo[statistics.modus] / (float) (dy0 - 13);
  if (!(statistics.histo[statistics.modus] > dy0 - 13)) {
    fhisto = (float) Math.sqrt(fhisto);
  }
  fill(34);
  strokeWeight(2);
  int ybasis = y + dy - ifact * 5;
  boolean gray = true;
  noStroke();
  for (int i = 0; i < 9; i++) {
    if (gray)
      fill(242);
    else
      fill(255);
    gray = !gray;
    rect(xx + (i * ifact * 2) * 10 - ifact, y + ifact * 4, ifact * 20, dy - ifact * 9);
  }
 
  /*
  stroke(100, 100);
  int nsum = 0;
  int yold = ybasis;
  fhisto = (float) statistics.n / (float) (dy0 - 10);
  for (int i = 0; i < 97; i++) {
    nsum += statistics.histo[i];
    int xnow = xx + i * ifact * 2;
    ynow = 2 + ybasis
        - ifact * Math.max((int) (nsum / fhisto), 1);
     line(xnow - ifact * 2, yold, xnow, ynow);
    yold = ynow;
  }
*/
  stroke(255);
  int ynow;
   float ffhisto = (float) statistics.n / (float) (dy0 - 10);
    ynow = ybasis - ifact * Math.max((int) ((statistics.n/4) / ffhisto), 1);
  line(xx, ynow, xx + 97 * ifact * 2, ynow);
  ynow = ybasis - ifact * Math.max((int) ((statistics.n/2) / ffhisto), 1);
  line(xx, ynow, xx + 97 * ifact * 2, ynow);
  ynow = ybasis - ifact * Math.max((int) ((3*statistics.n/4) / ffhisto), 1);
  line(xx, ynow, xx + 97 * ifact * 2, ynow);
  for (int i = 0; i < 97; i++) {
    if (statistics.histo[i] > 0) {
      if (i < resPlayer) { 
        if (i % 2 == 0) {
          stroke(215, 48, 39);
        } else {
          stroke(244, 109, 67);
        }
        if (i == 0) {
          if (resPlayer == 0) {
            stroke(255, 255, 150);
          } else {
            stroke(50, 255, 0);
          }
        }
      } else if (i == resPlayer)
        stroke(0);
      else
        if (i % 2 == 0) {
        if (colorblind) {
          stroke(69, 117, 180);
        } else {
          stroke(26, 152, 80);
        }
      } else {
        if (colorblind) {
          stroke(116, 173, 209);
        } else {
          stroke(102, 189, 99);
        }
      }
      if (i == resPlayer) {
        c = color(120);
      } else {
       c = statistics.getResColor(float(i), resPlayer);
       if (i % 5 == 0) {
        c = darker(c, 0.9);
       }
      }

      stroke(c);
      int xnow = xx + i * ifact * 2;
      int ynow = ybasis
        - ifact * Math.max((int) (statistics.histo[i] / fhisto), 1);

      rect(xnow, ybasis, ifact, ynow - ybasis);
    }
  }
  /*
  stroke(55);
  int nsum = 0;
  int yold = ybasis;
  fhisto = (float) statistics.n / (float) (dy0 - 10);
  stroke(0, 127);
  for (int i = 0; i < 97; i++) {
    nsum += statistics.histo[i];
    int xnow = xx + i * ifact * 2;
    ynow = ybasis
        - ifact * Math.max((int) (nsum / fhisto), 1);
     line(xnow - ifact * 2, yold, xnow, ynow);
    yold = ynow;
  }
  */
  stroke(0);
  noFill();
  line(xx, ybasis + ifact * 2, xx + ifact * 192, ybasis + ifact * 2);
  line(xx, ybasis - ifact, xx, ybasis + ifact * 3);
  int xres = xx + ifact * 2 * resPlayer;
  line(xres, ybasis - ifact, xres, ybasis + ifact * 3);
  line(xx + ifact * 192, ybasis - ifact, xx + ifact * 192, ybasis + ifact * 3);

  noStroke();
  fill(255, 0, 0, 20);
  rect(xx - ifact, y + ifact * 4, resPlayer * ifact * 2, dy - ifact * 8);

  if (colorblind) {
    fill(0, 0, 200, 20);
  } else {
    fill(0, 200, 0, 20);
  }
  rect(ifact + xx + resPlayer * ifact * 2, y + ifact * 4, ifact * 2 * (96 - resPlayer), dy - ifact * 8);
  strokeWeight(1);
}

color darker(color c, float f) {
  int r = red(c) * f;
  int g = green(c) * f;
  int b = blue(c) * f;
  return color(r, g, b);
}

void drawResult(int x, int y) {
  if (statistics.maximum < 0) return;
  int dx = ifact * 200;
  int dy = ifact * 17;
  int yc = y + dy / 2;
  stroke(0);
  if (colorblind) {
   // fill(140, 199, 255);
    fill(statistics.getResColor(30.0, 20));
  
} else {
    fill(140, 255, 115);
  }
  rect(x, y, dx, dy);
  noStroke();
  fill(127);
  rect(x, y, 2 * (statistics.less + statistics.equal), dy);

//  fill(255, 128, 128);
  fill(statistics.getResColor(30.0, 40));
  rect(x, y, statistics.less * 2, dy);
  stroke(0);
  fill(0);
  textAlign(LEFT, CENTER);
  text(("" + statistics.less), x + ifact * 5, yc);
  textAlign(RIGHT, CENTER);
  text( ("" + statistics.more), x + dx - ifact * 5, yc);
  textAlign(CENTER, CENTER);
  text(statistics.str_result, x + dx/2, yc);
  textAlign(LEFT, BASELINE);
  noFill();
  rect(x, y, dx, dy);
}

void drawStatistics(int x0, int y0) {
  textFont(myFont, F12);
  int x = x0;
  int y = y0;
  int xr = x + ifact * 120;
  int xm = x + ifact * 193;
  int dy = ifact * 125;
  fill(255);
  rect(x, y, ifact * 200, dy + 2);
  stroke(0);
  noFill();
  rect(x, y, ifact * 200, dy + 2);
  if (statistics.maximum < 0) return;
  y += ifact * 18;
  x += ifact * 7;
  fill(0);

  text(getTranslation(LANG, "Random tapping") + ", " + statistics.n + " " + getTranslation(LANG, "games") + ": ", x, y + ifact * 2);
  text(getTranslation(LANG, "best score") + ":", x, y += ifact * 21);
  setStatisticsColor(resPlayer, statistics.minimum);
  if (statistics.minimum == 0 && resPlayer > 0) {
    fill(35, 176, 0);
  }
  textR("" + statistics.minimum, xr, y);
  fill(0);
  if (statistics.minimum == 0) {
    text("! (" + statistics.histo[0] + "x)", xr + ifact, y);
  } else {
    text(" (" + statistics.histo[statistics.minimum] + "x)", xr + ifact, y);
  }
  text(getTranslation(LANG, "median") + ":", x, y += ifact * 16);
  setStatisticsColor(resPlayer, statistics.median);
  textR("" + statistics.median, xr, y);
  fill(0);

  textFont(myFont, F16);
  int yyou = y - ifact * 7;
  textR(getTranslation(LANG, "You"), xm, yyou);
  textR("" + resPlayer, xm, yyou + ifact * 20);
  textFont(myFont, F12);

  text(getTranslation(LANG, "mean") + ":", x, y += ifact * 13);
  setStatisticsColor(resPlayer, statistics.mean);
  textR(My.round2String(statistics.mean, 3), xr + ifact * 12, y);
  fill(0);
  text(getTranslation(LANG, "worst") + ":", x, y += ifact * 16);
  setStatisticsColor(resPlayer, statistics.maximum);
  textR("" + statistics.maximum, xr, y);
  fill(0);
  text(getTranslation(LANG, "most frequent") + ":", x, y += ifact * 20);
  setStatisticsColor(resPlayer, statistics.modus);
  textR("" + statistics.modus, xr, y);
  fill(0);
  text("" + statistics.scores + " " + getTranslation(LANG, "different scores"), x, y += ifact * 16);

  stroke(0);
  if (statistics.minimum == 0 ||  resPlayer == 0) {
    if (resPlayer == 0) {
      fill(0, 0, 200);
    } else {
      fill(215, 40, 40);
    }
    rect(xm - ifact * 30, y - ifact * 14, ifact * 14, ifact * 14);
  } else {
    if (resPlayer <= statistics.minimum) {
      fill(0, 0, 200);
    } else {
      fill(215, 40, 40);
    }
    ellipse(xm - ifact * 26, y - ifact * 7, ifact * 14, ifact * 14);
  }

  fill(statistics.getResColor(statistics.mean, resPlayer));
  rect(xm - ifact * 14, y - ifact * 14, ifact * 14, ifact * 7);

  fill(statistics.getResColor(statistics.str_result, 50.0));
  rect(xm - ifact * 14, y - ifact * 7, ifact * 14, ifact * 7);

  //println(global_statistics.n + " " + global_statistics0.n);
  //println("***" + HEIGHT0);
  if (HEIGHT0 > 96000) {
    String evaluationText = getEvaluationText();
    println(evaluationText);
    My.msg(evaluationText);
  }
}

String getEvaluationText() {
  // String txt = resPlayer + " pts. / " + statistics.str_result + "%:  Your result is";
  String txt = "";
  float proz0f = 100.0 * (statistics.histo[0] / statistics.n);
  String proz0 = My.round2String(proz0f, 2);
  boolean prtbetter = false;
  if (resPlayer == 0) {
    txt += "Absolutly perfect, you solved it!";
  } else {
    if (statistics.resultf == 100) {
      txt = "Perfect game. The random strategy gives no better result. Gratulation!";
    } else if (statistics.resultf > 95) {
      txt += "Very good.";
    } else if (statistics.resultf > 80) {
      txt += "Good.";
    } else if (statistics.resultf > 60) {
      txt += "Rather good, but you could do it better.";
    } else if (statistics.resultf > 50) {
      txt += "Just over 50%.";
    } else if (statistics.resultf == 50) {
      txt += "Exactly as good as the random strategy.";
    } else if (statistics.resultf > 40) {
      txt += "Not so good.";
    } else if (statistics.resultf > 30) {
      txt += "Rather bad.";
    } else if (statistics.resultf > 10) {
      txt += "Bad.";
    } else if (statistics.resultf > 0) {
      txt += "Extremely bad.";
    } else if (statistics.resultf == 0) {
      txt += "Very bad. You did not play (?).";
    }
    if (statistics.minimum == resPlayer) {
      txt += " Perhaps there is really no better solution than " + resPlayer + " achievable.";
    }
    if (statistics.minimum < resPlayer && statistics.minimum > 0) {
      int d = (resPlayer - statistics.minimum);
      String ds = "" + d;
      if (d < 5) {
        ds = "only " + ds;
      }
      txt += " The best random solution was " + ds + " point";
      if (d > 1) {
        txt += "s";
      }
      txt += " better,";
      if (statistics.less > 0) {
        txt += " the random \"strategy\" was in " + nfc(statistics.less, 1) + "% better.";
      } else {
        txt += " the random \"strategy\" was in nearly never better.";
      }
    }
    if (statistics.minimum == 0) {
      txt += (statistics.resultf >= 50 ? " But t" : " And t") + "he game was solvable, and you did not!";
      if (proz0f < 10) {
        if (proz0f < 1) {
          txt += " Only";
        } 
        txt +=  " " + proz0  + "% of random games solve the game completely.";
      } else {
        txt += " It was perhaps not so difficult, " + proz0  + "% of random games get a 0.";
      }
      prtbetter = true;
      txt += " The random strategy was in " + nfc(statistics.less, 1) + "% of the tries better.";
    } else if (statistics.minimum != resPlayer) {
      txt += " The game seems until now not to be solvable.";
    }
  }
  if (statistics.minimum == 0 && !prtbetter) {
    if (proz0f < 10) {
      if (proz0f < 1) {
        txt += " Only";
      } 
      txt +=  " " + proz0  + "% of random games solve the game completely.";
    } else {
      txt += " It was perhaps not so difficult, " + proz0  + "% of random games get a 0.";
    }
  }
  if (statistics.scores > 40) {
    txt += " It was a game with " + (statistics.scores > 50 ? "very " : "") + "many different ways to play, there were " + statistics.scores + " different scores.";
  } else if (statistics.scores < 25) {
    txt +=  " It is not a rich game, there were only " + statistics.scores + " different scores achieved.";
  }
  return txt;
}

void setStatisticsColor(int res, float indicator) {
  if (res == indicator) {
    fill(0);
  } else if (res > indicator) {
    fill(215, 48, 39);
  } else {
    if (colorblind) {
      fill(69, 117, 180);
    } else {
      fill(26, 152, 80);
    }
  }
}
