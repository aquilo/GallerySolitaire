
// SpecialCardPiles ----------------------------------------------------------

class FoundationPile extends CardPile {
  FoundationPile(int x, int y, int id, int nMax, int base) {
    super(x, y, id, nMax);
    this.base = base;
    this.col = (id - 1) % 8;
    kind = "Foundation";
  }

  void draw() {
    if (empty()) {
      os.mytextFont(myFont, F14);  
      //      os.myfill(TEXTCOLOR);
      os.myfill(167);
      textC(base + "", xc, yc);
    } else {
      peek().draw(x, y, ok, movable, autoMovable);
      if (global_helplevel != 8 && global_helplevel != 10) return;
      Card c = peek();
      if (ok) {
        if (c.rank < 11) {   
          os.mytextFont(myFont, F12);  
          os.myrectMode(CENTER); 
          os.mystroke(0);
          os.myfill3(200, 255, 200);
          os.myrect(xc, yc, 11, 14);
          os.myfill(0);
          textC(c.rankShortStr[c.rank + 3], 1 + xc, yc);
          os.myrectMode(CORNER);
        } else {
          /*          
           textFont(myFont, F12);  
           fill(255, 200, 200);
           rect(x + 5, y + 30, 13, 13);
           fill(0);
           textC("x", x + 12, y + 44);
           */
        }
      }
    }
  }

  String toStr() {
    return super.toStr() + base + "" + col;
  }

  void doOkCheck() {
    if (ok) return;
    if (empty()) ok = false;
    else ok = cards[0].rank == base;
  }

  boolean canTake(Card c) {
    if (empty()) {
      return c.rank == base;
    }
    Card topCard = peek();
    return ok && c.suit == topCard.suit && (c.rank - topCard.rank) == 3;
  }

  boolean checkTwinAtBottom(Card topCard) {
    // info("checkTwinAtBottom");
    if (topCard.rank > 10) {
      for (int i = 0; i < 8; i++) {
        if (!tableau[i].empty() 
          && tableau[i].elementAt(0).isTwin(topCard)) { 
          sayAutoReason(id, 5, "twin at tableau bottom (f) ", topCard.toString());
          return true;
        }
      }
    }
    return false;
  }

  boolean checkTwinSameRow(Card topCard) {
    // info("checkTwinSameRow");
    if (topCard.rank < 5) {
      return false;
    }
    int thisRow = base % 3;
    for (int i = 0; i < 8; i++)
      if (!foundationPile[thisRow][i].empty()
        && foundationPile[thisRow][i].peek().isTwin(
      topCard)) {
        sayAutoReason(id, 6, "twin on same row ", topCard.toString());
        return true;
      }     
    return false;
  }

  int nOk() {
    if (empty() || !ok)
      return 0;
    else
      return nCards;
  }
}


// TableauPile -------------------------------------------------------------

class TableauPile extends CardPile {
  TableauPile(int x, int y, int id, int nMax) {
    super(x, y, id, nMax);
    kind = "Tableau";
  }

  String toStr() {
    return super.toStr() + ((id-1) % 8);
  }

  void draw() {
    if (empty()) return;
    int yy = y;
    for (int i = 0; i < (nCards-1); i++) {
      elementAt(i).drawHidden(x, yy);
      yy += DYST;
    }
    peek().draw(x, yy, ok, movable, autoMovable);
    yc = yy + CARDHEIGHT / 2;
  }

  int getTopY () {
    return y + nCards * DYST;
  }

  boolean includes(int xx, int yy) {
    return (xx >= x
      && yy >= y
      && xx < (x + CARDWIDTH)
      && yy < (y + 3 * CARDHEIGHT));
  }

  void doJamCheck() {
    if (empty())
      return;
    for (int j = 0; j < nCards; j++) { 
      Card aCard = elementAt(j);
      aCard.jammed = false;
      aCard.jammer = false;
      setElementAt(aCard, j);
    }
    if (nCards < 2)
      return;
    for (int j = 0; j < nCards - 1; j++) {
      Card belowCard = elementAt(j);
      for (int k = j + 1; k < nCards; k++) {
        Card aboveCard = elementAt(k);
        if (aboveCard.suit == belowCard.suit 
          && (aboveCard.rank > belowCard.rank)
          && (aboveCard.rank - belowCard.rank) % 3 == 0) {
          belowCard.jammed = true;
          setElementAt(belowCard, j);
          aboveCard.jammer = true;
          setElementAt(aboveCard, k);
        }
      }
    }
  }

  boolean checkTwinBelow(Card topCard) { 
    // info("checkTwinBelow");
    if (topCard.rank > 4) {
      for (int j = 0; j < nCards-1; j++) {
        if (topCard.isTwin(elementAt(j))) {
          sayAutoReason(id, 7, "twin card under it ", topCard.toString());
          return true;
        }
      }
    }
    return false;
  }

  boolean checkTwinAtBottom(Card topCard) {
    // info("checkTwinAtBottom");  
    if (topCard.rank < 11) return false;  
    for (int i = 0; i < 8; i++) {
      if (!tableau[i].empty() 
        && tableau[i].elementAt(0).isTwin(topCard)) { 
        sayAutoReason(id, 8, "twin at tableau bottom (t) ", topCard.toString());
        return true;
      }
    }
    return false;
  }
}

// StockPile -------------------------------------------------------------

class StockPile extends CardPile {
  StockPile(int x, int y, int id, int nMax) {
    super(x, y, id, nMax);
    kind = "Stock";
  }

  void doClick() {
    if (cardMoving() || empty() || acePile.reserved) return;

    for (int i = 0; i < 8; i++) {
      if (tableau[i].reserved) return;
    }
    for (int i = 0; i < 8; i++) {
      doMove(stockPile, tableau[i], true);
    }
  }

  void doAutoMovableCheck() {
    autoMovable = false;
  }

  void doMovableCheck() {
    movable = false;
  }

  void doOkCheck() {
    ok = false;
  }

  void draw() {
    if (empty()) {
      if (gameFinished) {
        os.mystroke3(255, 255, 0);
        os.myfill3(255, 255, 0);
        if (humanPlayer) {
          text("The End", XSA + 4, y + 20);
        } 
      } else {
        os.mystroke(180);
        os.myfill(180);
        os.myrect(0, YPROGRESS + 16 * ifact, width, 4 * ifact);
      }
      return;
    }
    int dd = nCards / 8;
    int xx = x + dd * DXSS;
    int yy = y + dd * DYSS;
    for (int i = 0; i < dd; i++) {
      xx -= DXSS;
      yy -= DYSS;
      os.myfill(255);
 //     os.myrect(xx, yy, ifact * 37, ifact * 51);
      os.myrect(xx, yy, ifact * 36, ifact * 51);
    if (noMovables() && !cardMoving()) {
      os.myfill3(29, 128, 242);
    } else {
      os.myfill4(255, 127, 0, 80);
    }
 //   os.myrect(xx + ifact * 3, yy + ifact * 3, ifact * 31, ifact * 45);
    os.myrect(xx + ifact * 3, yy + ifact * 3, ifact * 30, ifact * 45);
    os.myfill(0);
  }
   //  textC(nCards + "", xc, yc);
    int mrows = nCards / 8;
    int xl = xx + ifact * 6;
    int yo = yy + ifact * 10;
    int dxs = 8 * ifact;
    int dys = 10 * ifact;
    int nrows = 9;
    os.mystroke(0);
    for (int i = 0; i < 3; i++) {
      xl = xx + ifact * 6;
      for (int j = 0; j < 3; j++) {
        if (mrows >= nrows) {
          os.myfill(128);
//          os.myfill4(0, 0, 0, 90);
        } else {
          os.myfill(255);
          //os.myfill4(255, 127, 0, 80);
        }
        os.myrect(xl, yo, dxs, dys);
        xl += dxs;
        mrows++;
      }
      yo += dys;
    }
  }

/*  void draw() {
    if (empty()) {
      if (gameFinished) {
        os.mystroke3(255, 255, 0);
        os.myfill3(255, 255, 0);
        if (humanPlayer) {
          text("The End", XSA + 4, y + 20);
        }
      }
      return;
    }
    int dd = nCards / 8;
    int xx = x + dd * DXSS;
    int yy = y + dd * DYSS;
    for (int i = 0; i < dd; i++) {
      xx -= DXSS;
      yy -= DYSS;
      if (global_cardface != 22) {
        os.myfill(255);
        os.myrect(xx, yy, ifact * 37, ifact * 51);
        os.myfill4(255, 127, 0, 80);
        os.myrect(xx + ifact * 3, yy + ifact * 3, ifact * 31, ifact * 45);
      } else {
        os.myimage(bgImg, xx, yy);
      }
    }
    os.myfill(TEXTCOLOR);
    os.myfill(0);
    if (noMovables() && !cardMoving()) {
      os.myfill3(50, 50, 250);
      os.myellipseMode(CENTER);
      os.myellipse(x+CARDWIDTH/2, y+CARDHEIGHT/2, BLUECIRCLERADIUS, BLUECIRCLERADIUS);
      os.myfill(255);
    } else {
      os.mytextFont(myFont, F12); 
      os.myfill3(0, 122, 255);
    }

   //  textC(nCards + "", xc, yc);
    int mrows = nCards / 8;
    int xl = xx + ifact * 6;
    int yo = yy + ifact * 8;
    int dxdy = 8 * ifact;
    int nrows = 12;
    os.mystroke(0);
    for (int i = 0; i < 3; i++) {
      xl = xx + 6;
      for (int j = 0; j < 3; j++) {
        if (mrows >= nrows) {
          os.myfill4(0, 0, 0, 90);
        } else {
          os.myfill4(0, 255, 0, 0);
          //os.myfill4(255, 127, 0, 80);
        }
        os.myrect(xl, yo, dxdy, dxdy);
        xl += dxdy;
        mrows++;
      }
      yo += dxdy;
    }
  }
*/
  void shuffle() {
    for (int i = 103; i >= 0; i--) {
      int j = int(random(i));
      Card card = elementAt(j);
      // card.reset();
      setElementAt(elementAt(i), j);
      setElementAt(card, i);
    }
  }
}

// AcePile -------------------------------------------------------------

class AcePile extends CardPile {
  AcePile(int x, int y, int id, int nMax) {
    super(x, y, id, nMax);
    kind = "Aces";
    //   dy += 40;
    ok = true;
  }

  int getTopX () {
    return x + nCards * DXSA;
  }

  int getTopY () {
    return y + (nCards - 1) * DYSA;
  }

  void draw() {
    return;
    /*P
     if (empty()) return;
     int xx = x;
     int yy = y;
     for (int i = 0; i < nCards; i++) {
     elementAt(i).draw(xx, yy);
     xx += DXSA;
     yy += DYSA;
     }*/
  }

  void doAutoMovableCheck() {
    autoMovable = false;
  }

  void doMovableCheck() {
    movable = false;
  }

  int nOk() {
    return nCards;
  }
}
