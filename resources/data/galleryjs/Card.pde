// Card -------------------------------------------------------------

class Card {
  PImage img, imgOk, imgCovered;
  int suit, rank, id;
  boolean jammer, jammed;
  String suitStr[] = {
    "Spade", "Hearts", "Club", "Diamond"
  };
  String rankStr[] = {
    "-", "Ace", "2", "3", "4", "5", "6", 
    "7", "8", "9", "10", "Jack", "Queen", "King"
  };
  String rankShortStr[] = {
    "-", "A", "2", "3", "4", "5", "6", 
    "7", "8", "9", "X", "J", "Q", "K"
  };

  Card(int suit, int rank, int id, PImage img, PImage imgOk, PImage imgCovered) {
    this.suit = suit;
    this.rank = rank;
    this.id = id;
    this.img = img;
    this.imgOk = imgOk;
    this.imgCovered = imgCovered;
  }

  String toString() {
    return (suitStr[suit] + "-" + rankStr[rank]);
  }

  String toStr() {
    return (suitStr[suit].substring(0, 1) + rankShortStr[rank]);
  }

  boolean isAce() {
    return rank == 1;
  }

  boolean isTwin(Card a) {
    return (rank == a.rank) && (suit == a.suit) && (id != a.id);
  }

  void draw(int x, int y) {
    os.myimage(img, x, y);
  }

  void drawHidden(int x, int y) {
    if (global_cardface == 2) {
      os.myimage(imgCovered, x, y);
      //  return;
    }
    if (global_cardface == 1) {
      drawHidden2(x, y);
      return;
    }

    // os.mynoStroke();
    os.mystroke(180);
    if (jammed && !noHelp) {
      os.myfill3(180, 180, 180);
      os.myrect(x + 34, y + 2, 36, 12);
    }
    if (jammer && !noHelp) {
      os.myfill3(0, 200, 0);
      os.mynoStroke();
      os.myrect(x + 38, y + 5, 30, 7);
    }
  }

  void drawHidden2(int x, int y) {
    draw(x, y);
    os.mynoStroke();
    os.myfill(255);
    os.myrect(x + 2, y + 9, 33, 9);
    if (rank == 10) {
      os.myrect(x + 9, y + 1, 26, 9);
    } else {
      os.myrect(x + 8, y + 1, 27, 9);
    }
    if (osp) {
      offScreen.image(suitImages[suit], x + 26, y + 1);
    } else {
      image(suitImages[suit], x + 26, y + 1);
    }
    if (jammed && !noHelp) {
      os.myfill3(0, 200, 0);
      os.myrect(x + 11, y + 3, 14, 5);
    }
    if (jammer && !noHelp) {
      os.myfill3(0, 200, 0);
      os.myrect(x + 11, y + 4, 14, 3);
    }
  }

  void drawMovable(int x, int y) {
    if (noHelp) return;
    os.mynoStroke();
    os.myfill4(255, 127, 0, 80);
    os.myrect(x, y, CARDWIDTH, CARDHEIGHT);
  }

  void drawAutoMovable(int x, int y) {
    if (noHelp) return;
    if (global_sayAuto != 1) return;
    os.mynoStroke();
    os.myfill4(0, 255, 100, 80);
    os.myrect(x, y, CARDWIDTH, CARDHEIGHT);
  }

  void draw(int x, int y, boolean ok, boolean movable, boolean autoMovable) {
    if (ok) {
      jammer = jammed = false;
      os.myimage(imgOk, x, y);
    } else {
      draw(x, y);
      if (autoMovable) {
        drawAutoMovable(x, y);
        return;
      }
      if (movable) {
        drawMovable(x, y);
      }
    }
    if (jammer && !noHelp) {
      os.myfill3(0, 200, 0);
      if (global_cardface == 2) {
        os.myfill3(0, 200, 0);
        os.mynoStroke();
        os.myrect(x + 38, y + 5, 30, 7);
      } else {
        os.myrect(x + 11, y + 3, 14, 3);
      }
    }
  }
}
