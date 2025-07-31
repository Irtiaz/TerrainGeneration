Terrain layer3, layer2, layer1;

void setup() {
  size(900, 600);
  layer3 = new Terrain(0, width, height, 10, height / 4, 2, ShiftDirection.LEFT, 0, width);
  layer2 = new Terrain(0, width, height - 20, 10, height / 3, 3, ShiftDirection.LEFT, 0, width);
  layer1 = new Terrain(0, width, height - 40, 10, height / 2, 4, ShiftDirection.LEFT, 0, width);
  
  
  noStroke();
}

void draw() {
  background(240, 203, 163);
  
  fill(255);
  circle(80, 60, 60);
  
  fill(159,99,204,255);
  layer1.render();
  
  fill(131,79,139,255);
  layer2.render();

  fill(68,28,99,255);
  layer3.render();

  layer1.shift(2);
  layer2.shift(5);
  layer3.shift(10);
}


void keyPressed() {
  if (key == ' ') {
    save("2d-terrain.png");
  }
}
