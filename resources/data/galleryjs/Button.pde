// Button -------------------------------------------------------------

class Button {
  int x, y, dx, dy, id;
  String label;
  boolean active;
  color textcolor, activtextcolor;
  color fillcolor;

  Button(String label, int x, int y, int dx, int dy, int id) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.label = label;
    this.id = id;
    textcolor = color(0);
    // activtextcolor = color(255, 149, 0);
    // activtextcolor = color(61, 200, 0);
    activtextcolor = color(0, 122, 255);
    // fillcolor = color(235);
    fillcolor = color(255, 155, 0);
  }

  void draw() {
    this.draw(true);
  }

  /*  void draw(boolean active) {
   this.active = active;
   if (!active) return;
   stroke(textcolor);
   fill(fillcolor);
   rect(x, y, dx, dy, 6, 6);
   fill(textcolor);
   textFont(myFont, F12);  
   textC(label, x + dx/2, y + dy/2);
   }*/

  void draw3(boolean active, boolean dimmed) {
    this.active = active;
    textFont(myFont, round(F18 * 0.65));  
    if (!active) {
      fill(color(255));
      stroke(color(255));
      stroke(color(255));
      rect(x - 2, y - 2, dx + 4, dy + 8);
      return;
    };
    if (!dimmed) {
      stroke(color(200));
      fill(color(200));
    } else {
      stroke(activtextcolor);
      fill(activtextcolor);
    }
    textC(label, x + dx/2, y + dy/2);
  }

  void draw(boolean active) {
    this.active = active;
    textFont(myFont, F18);  
    if (!active) {
      fill(color(255));
      stroke(color(255));
      stroke(color(255));
      rect(x - 2, y - 2, dx + 4, dy + 4);
      return;
    };
    stroke(activtextcolor);
    fill(activtextcolor);
    textC(label, x + dx/2, y + dy/2);
  }

  boolean includes(int xx, int yy) {
    return (active && xx >= x 
      && yy >= y 
      && xx < (x + dx) 
      && yy < (y + dy));
  }
}
