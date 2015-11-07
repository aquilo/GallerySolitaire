// Mover -------------------------------------------------------------

static int totalTime = 0;
static int totalMoves = 0;

class Mover {
  int steps;
  Card card;
  CardPile to;
  boolean active;
  int x, y;
  float xbegin, ybegin;
  float dx, dy;
  float nr;
  float now;
  int startTime;

  Mover(int nr) {
    this.nr = nr;
    active = false;
  }

  void set(Card card, int xstart, int ystart, CardPile to, int steps) {
    startTime = millis();
    this.card = card;
    this.to = to;
    this.steps = steps;
    to.reserved = true;
    mustDraw = true;
    dirty = true;
    now = 0.0;
    active = true;
    xbegin = float(xstart);
    ybegin = float(ystart);
    dx = (to.getTopX() - xbegin);
    dy = (to.getTopY() - ybegin);
  }

  void stop() {
    float fmtime;
    active = false;
    to.push(card);
    to.reserved = false;
    dirty = true;
    mustDraw = true;
    totalTime += (millis() - startTime);
    totalMoves ++;
    if (debug) {
      fmtime = totalTime / totalMoves;
      mymsg = (global_steps + " / " + global_mtime + " " + My.round2String(fmtime, 1) + " = " + totalMoves + " / " + totalTime);
    }
    if (totalMoves > 12) {
      fmtime = totalTime / totalMoves;
      float old_steps = global_steps;
      global_steps *=  global_mtime / fmtime;
      global_steps = int((global_steps + old_steps) / 2.0);
      global_steps = max(global_steps, 2);
      global_steps = min(global_steps, 150);
      mymsg = ("*** " + global_steps + " / " + global_mtime + " " + My.round2String(fmtime, 1) + " = " + totalMoves + " / " + totalTime);
      //      println(old_steps + " " + global_steps + " / " + global_mtime + " " + fmtime + " ; " + totalMoves + " / " + totalTime);
      totalMoves = 0;
      totalTime = 0;
      setStepsPref();
      //     println();
    }
  }

  void draw() {
    now += 1.0;
    x = int(easeOutCubic(now, xbegin, dx, steps));
    y = int(easeOutQuad(now, ybegin, dy, steps));
    //  println(x + "/" + y + " " + now + " " + steps + " " + xbegin + "/" + ybegin + " " + dx+"/"+dy)
    card.draw(x, y);
    if (now >= steps) {
      stop();
      return;
    }
  }

  float easeOutCubic (float t, float b, float c, float d) {
    return c * ((t = t / d - 1) * t * t + 1) + b;
  }

  float easeOutQuad (float t, float b, float c, float d) {
    t /= d;
    return -c * t*(t-2) + b;
  }
}

String fromto(CardPile from, CardPile to, String undo) {
  return from.peek().toStr() + ": " + from.toStr() + " > " + to.toStr() + " " + undo;
}
// MoverCollection -------------------------------------------------------------

class MoverCollection {
  int maxMover = 100;
  Mover mover[];

  MoverCollection() {
    mover = new Mover[maxMover];
    for (int i = 0; i < maxMover; i++) {
      mover[i] = new Mover(i);
    }
  }

  boolean isOneActive() {
    for (int i = 0; i < maxMover; i++) {
      if (mover[i].active) return true;
    }
    return false;
  }

  void startUndo(CardPile from, CardPile to, int steps) {
    //    println(fromto(from, to, "U"));
    to.push(from.pop());
    to.ok = false;
    return;
    /*
    for (int i = 0; i < maxMover; i++) {
     if (!mover[i].active) {
     if (i > maxnow) {
     maxnow = i;
     println("maxnow: " + maxnow);
     }
     undoing = true;
     mover[i].set(from.pop(), from.getTopX(), from.getTopY(), to, steps);
     return;
     }
     }
     */
  }

  void start(CardPile from, CardPile to, boolean auto, int steps) {
    //    println(auto + " " + fromto(from, to, ""));
    //    println(steps);
    dirty = true;
    if (from.id == 0) {
      moveStack.clear();
    }
    if (from.id != 0 && to.id != 1) {
      moveStack.push(new Move(from, to, auto));
      from.autoMovable = false;
      nMovesStat++;
      if (auto) nAutoMovesStat++;
      if (from.kind == "Tableau") {
        from.movable = false;
      }
    }
    for (int i = 0; i < maxMover; i++) {
      if (!mover[i].active) {
        mover[i].set(from.pop(), from.getTopX(), from.getTopY(), to, steps);
        return;
      }
    }
  }

  int draw() {
    int nActive = 0;
    for (int i = 0; i < maxMover; i++) {
      if (mover[i].active) {
        mover[i].draw();
        nActive++;
      }
    }
    return nActive;
  }
}
