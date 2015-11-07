
// MoveStack -------------------------------------------------------------

class MoveStack {
  Move moves[];
  int nMoves;

  MoveStack(int nMax) {
    moves = new Move[nMax];
    nMoves = 0;
  }

  void push(Move move) {
    moves[nMoves] = move;
    nMoves++;
  }

  Move peek() {
    if (empty()) return null;
    return moves[nMoves - 1];
  }

  Move elementAt(int ix) {
    if (empty()) return null;
    return moves[ix];
  }

  void setElementAt(Move move, int ix) {
    moves[ix] = move;
  }

  Move pop() {
    if (empty()) return null;
    else {
      nMoves--;
      return moves[nMoves];
    }
  }

  boolean empty() {
    return nMoves == 0;
  }

  void clear() {
    nMoves = 0;
  }

  void print() {
    for (int i=0; i < nMoves; i++) {
      println(i + ". " + elementAt(i).toString());
    }
    println();
  }
}

// Move -------------------------------------------------------------

class Move {
  CardPile from, to;
  boolean auto;
  Move(CardPile from, CardPile to, boolean auto) {
    this.from = from;
    this.to = to;
    this.auto = auto;
  }

  Move() {
    this.from = null;
    this.to = null;
    this.auto = false;
  }

  String toString() {
    return this.from.id + " " + this.from.toString() + " > " + this.to.toString() + " " + this.auto;
  }

  String toString2() {
    return this.from.id + " " + this.from.base + " > " + this.to.kind + " " + from.peek().toString();
  }
}
