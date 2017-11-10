void keyPressed() { 
  if (key == 's' ) { // screenshot
    saveFrame("Img " + imgOut);
    imgOut++;
  }
  if (key == 'w' ) { // thicker lines
    strokeWeight(map(mouseY, 0, height, 0.5, 15.0));
  }
  if (key == 'h' ) { // toggle history 
    if (history == 1) {
      background(0);
      history = 0;
    } else {
      history = 1;
    }
  }
  if (key == 'f' ) { // toggle fill 
    if (filled == 1) {
      filled = 0;
      background(0);
    } else {
      filled = 1;
    }
  }
  if (key == 'g' ) { // toggle fade 
    if (fade == 1) {
      fade = 0;
    } else {
      fade = 1;
    }
  }
  if ( key == '0' ) {
    mode = 0;
  }
  if ( key == '1' ) {
    mode = 1;
  }
  if ( key == '2' ) {
    mode = 2;
  }
  if ( key == '3' ) {
    mode = 3;
  }
  if ( key == '4' ) {
    mode = 4;
  }
  if ( key == '5' ) {
    mode = 5;
  }
  if ( key == '6' ) {
    mode = 6;
  }
  if ( key == '7' ) {
    mode = 7;
  }
  if ( key == '8' ) {
    mode = 8;
  }
  if ( key == '9' ) {
    mode = 9;
  }
  if ( key == '-' ) {
    mode = 10;
  }
}