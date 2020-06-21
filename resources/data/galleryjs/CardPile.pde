
// CardPile -------------------------------------------------------------

class CardPile {
  int x, y, id; 
  int xc, yc;   
  PImage picture;    
  Card cards[];
  int nCards;
  boolean ok, movable, autoMovable;
  String kind = "";
  CardPile ziel;
  boolean reserved;
  boolean emptyVar = false;
  int base = 0;
  int col = 0;


  CardPile(int x, int y, int id, int nMax) {
    this.x = x;
    this.y = y;
    this.id = id;
    xc = x + CARDWIDTH / 2;
    yc = y + CARDHEIGHT / 2;
    cards = new Card[nMax];
    clear();
  }

  void doClick() {
    if (empty()) return;
    if (movable && !ziel.reserved) {
      doMove(this, ziel, false);
    }
  }

  void doAutoClick() {
    if (empty()) return;
    if (movable && !ziel.reserved) {
      doMove(this, ziel, true);
    }
  }

  String toString() {
    if (!empty()) {
      if (ok) {
        return(kind + " stack with " + cards.length + " places, occupied: +" + nCards 
          + ", top: " + peek().toString());
      } else {
        return(kind + " stack with " + cards.length + " places, occupied:  " + nCards 
          + ", top: " + peek().toString());
      }
    } else {
      return(kind + " stack with " + cards.length + " places, empty");
    }
  }

  String toStr() {
    return kind.substring(0, 1);
  }

  void doChecks() {
    if (empty()) {
      ok = movable = false;
      return;
    }
    doOkCheck();
    doMovableCheck();
    doAutoMovableCheck();
  }

  void doOkCheck() {
    ok = false;
  }

  void doMovableCheck() {
    movable = false;
    if (empty()) return;
    if (ok) return;

    Card topCard = peek();
    if (topCard.rank == 1) {
      ziel = acePile;
      movable = true;
      return;
    }
    int suitRow = topCard.rank % 3;
    for (int i = 0; i < 8; i++) {
      FoundationPile f = foundationPile[suitRow][i];
      if (!f.reserved) {
        if (f.empty()) {
          //         if (topCard.rank < 5 && topCard.rank > 1) {
          if (topCard.rank < 5) {
            ziel = f;
            movable = true;
            return;
          }
        } else if (f.ok) {
          Card d = f.peek();
          if (topCard.suit == d.suit && (topCard.rank - d.rank) == 3) {
            ziel = f;
            movable = true;
            return;
          }
        }
      }
    }
  }

  void doJamCheck() {
    return;
  }

  boolean checkTwinBelow(Card topCard) { 
    return false;
  }

  boolean checkTwinSameRow(Card topCard) { 
    return false;
  }

  boolean checkTwinAtBottom(Card topCard) { 
    return false;
  }

  void doAutoMovableCheck() {
    autoMovable = doAllAutoMovableChecks();
    if ((global_auto !== 0) && humanPlayer) return;
    if (autoMovable && global_sayAuto == 0) doAutoClick();
  }

  boolean doAllAutoMovableChecks() {
    if (!movable) return false;
    if (ziel.reserved) return false;
    Card topCard = peek();
    if (topCard.isAce()) return true;
    if (checkTwinBelow(topCard)) return true;
    if (checkJust1()) return true;
    if (checkRowClean(topCard)) return true;
    if (checkTwinOk(topCard)) return true;
    if (check2Possibilities(topCard)) return true;
    if (checkTwinSameRow(topCard)) return true;
    if (checkTwinAtBottom(topCard)) return true;
    if (checkTwinUnderBase(topCard)) return true;
    if (checkTwinIsJammed(topCard)) return true;

    return false;
  }

  boolean checkJust1() {
    info("checkJust1");
    int m = -1;
    if (stockPile.empty() && !cardMoving()) {
      int nMovable = 0;
      for (int i = 1; i < 34; i++) {
        if (allPiles[i].movable) {
          nMovable++;
          m = i;
        }
        if (nMovable > 1)
          return false;
      }
      if (nMovable == 1) {
        sayAutoReason(id, 4, "just 1 card movable ", allPiles[m].peek().toString());
        return true;
      }
    }
    return false;
  }

  boolean checkRowClean(Card topCard) { 
    info("checkRowClean");
    if (topCard.rank < 5) {
      int suitRow = topCard.rank % 3;
      for (int i = 0; i < 8; i++) {
        if (!foundationPile[suitRow][i].empty()
          && !foundationPile[suitRow][i].ok) {
          return false;
        }
      }
      sayAutoReason(id, 3, "row on foundation clean ", topCard.toString());
      return true;
    }
    return false;
  }

  boolean checkTwinOk(Card topCard) {
    info("checkTwinOk");
    if (topCard.rank > 4) {
      int suitRow = topCard.rank % 3;
      for (int i = 0; i < 8; i++)
        if (foundationPile[suitRow][i].ok 
          && foundationPile[suitRow][i].containsTwin(topCard)) {
          sayAutoReason(id, 1, "twin already OK ", topCard.toString());
          return true;
        }
    }
    return false;
  }

  boolean isAce() {
    if (nCards == 0) return false;
    if (peek().rank == 1) return true;
    return false;
  }

  boolean check2Possibilities(Card topCard) { 
    info("check2Possibilities");
    if (topCard.rank < 5) {
      return false;
    }
    int possibilities = 0;
    int suitRow = topCard.rank % 3;
    //      println("sr " + suitRow);
    for (int i = 0; i < 8; i++) {
      //        println(foundationPile[suitRow][i].toString());
      if (foundationPile[suitRow][i].canTake(topCard)) {
        //         println(possibilities);
        possibilities++;
        if (possibilities == 2) {
          sayAutoReason(id, 2, "2 possibilities ", topCard.toString());
          return true;
        }
      }
    }
    return false;
  }

  boolean checkTwinUnderBase(Card topCard) { 
    if (topCard.rank > 4) {
      for (int i = 0; i < 8; i++)
        if (!tableau[i].empty()) {
          for (int j = 0; j < tableau[i].nCards - 1; j++)
            if (topCard.isTwin(tableau[i].elementAt(j))) {
              if (topCard.rank - (tableau[i].elementAt(j + 1)).rank != 3) {
                return false;
              }
              if (topCard.suit != (tableau[i].elementAt(j + 1)).suit) {
                return false;
              }
              sayAutoReason(id, 9, "twin card directly under its base", topCard.toString());
              return true;
            }
        }
    }
    return false;
  }

  boolean checkTwinIsJammed(Card topCard) { 
    if (topCard.rank > 4) {
      for (int i = 0; i < 8; i++)
        if (!tableau[i].empty()) {
          for (int j = 0; j < tableau[i].nCards - 1; j++)
            if (topCard.isTwin(tableau[i].elementAt(j))) {
              if (tableau[i].elementAt(j).jammed) {
                sayAutoReason(id, 10, "twin card jammed", topCard.toString());
                return true;
              } else {
                return false;
              }
            }
        }
    }
    return false;
  }

  boolean canTake(Card c) {
    return false;
  }

  boolean containsTwin(Card topCard) { 
    for (int j = 0; j < nCards; j++) {
      if (topCard.isTwin(elementAt(j))) {
        return true;
      }
    }
    return false;
  }

  void draw() {
    if (empty()) return;
    peek().draw(x, y, ok, movable, autoMovable);
  }

  void arrow(int x1, int y1, int x2, int y2) {
    line(x1, y1, x2, y2);
    //  curve(x1, y1, x1+20, y1, x2, y2-40, x2, y2);
    pushMatrix();
    translate(x2, y2);
    float a = atan2(x1-x2, y2-y1);
    rotate(a);
    line(0, 0, -3, -9);
    line(0, 0, 3, -9);
    popMatrix();
  } 

  void drawArrow() {
    if (!empty() && movable && ziel.id > 1) {
      //        stroke(50+random(100),50+random(100), 50+random(100));
      stroke(0, 120);
      strokeWeight(3);
      int x1 = xc;
      int y1 = yc;
      int x2 = ziel.xc;
      int y2 = ziel.yc;
      int d1 = 4;
      int d2 = 8;
      if (x2 > x1) {
        x1 += d1;
        x2 -= d2;
      } else if (x2 < x1) {
        x1 -= d1;
        x2 += d2;
      }
      if (y2 > y1) {
        y1 += d1; 
        y2 -= d2;
      } else if (y2 < y1) {
        y1 -= d1; 
        y2 += d2;
      }
      arrow(x1, y1, x2, y2);   
      strokeWeight(1);
    }
  }

  boolean includes(int xx, int yy) {
    return (xx >= x 
      && yy >= y 
      && xx < (x + CARDWIDTH) 
      && yy < (y + CARDHEIGHT));
  }

  void push(Card c) {
    cards[nCards] = c;
    nCards++;
  }

  boolean empty() {
    return nCards == 0;
  }

  Card peek() {
    //   if (empty()) return null;
    return cards[nCards - 1];
  }

  Card elementAt(int ix) {
    if (empty()) return null;
    return cards[ix];
  }

  void setElementAt(Card card, int ix) {
    cards[ix] = card;
  }

  Card pop() {
    if (empty()) return null;
    else {
      nCards--;
      return cards[nCards];
    }
  }

  void clear() {
    nCards = 0;
    reserved = false;
    ziel = null;
    ok = false;
    movable = false;
    autoMovable = false;
  }

  void doHover() {
    explain = kind;
  }

  int nOk() {
    return 0;
  }

  int getTopX () { 
    return x;
  }
  int getTopY () { 
    return y;
  }
}
