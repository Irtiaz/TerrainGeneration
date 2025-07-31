float xIncrement = 0.1;
float yIncrement = 0.1;
int cellSize = 10;
float maxHeight = 300;
int terrainToWindowScale = 3;

float mountainThresholdFactor = 1.0 / 2;
float waterThresholdFactor = 1.0 / 3.0;

color mountainDarkMost = color(95, 99, 80);
color mountainLightMost = color(209, 229, 231);

color grassDarkMost = color(1, 50, 32);
color grassLightMost = color(86, 125, 70);

int rows, cols;
float mountainMinHeight;
float waterHeight;

float yParamInit = 0;
int w, h;

void setup() {
  size(1200, 900, P3D);

  h = height * terrainToWindowScale;
  w = width * terrainToWindowScale;

  rows = h / cellSize;
  cols = w / cellSize;
  
  mountainMinHeight = maxHeight * mountainThresholdFactor;
  waterHeight = maxHeight * waterThresholdFactor;
  
}

void keyPressed() {
  if (key == ' ') {
    save("terrain.png");
  }
}

void draw() {
  background(100, 137, 200);

  translate(width / 2, height / 2);
  rotateX(PI / 3);
  translate(-w / 2, -h / 2);

  noStroke();
  
  fill(135, 206, 235);
  beginShape(QUADS);
  vertex(0, 0, waterHeight);
  vertex(w, 0, waterHeight);
  vertex(w, h, waterHeight);
  vertex(0, h, waterHeight);
  endShape();
  
  for (int i = 0; i < rows - 1; ++i) {
    beginShape(TRIANGLE_STRIP);

    for (int j = 0; j < cols; ++j) {
      float x1 = j * cellSize;
      float y1 = i * cellSize;
      float z1 = terrainHeightAt(x1, y1, 0, yParamInit, maxHeight);

      float x2 = x1;
      float y2 = y1 + cellSize;
      float z2 = terrainHeightAt(x2, y2, 0, yParamInit, maxHeight);

      float averageZ = (z1 + z2) / 2;
      
      if (averageZ >= mountainMinHeight) {
        fill(mapColor(averageZ, mountainMinHeight, maxHeight, mountainDarkMost, mountainLightMost));
      }
      else {
        fill(mapColor(averageZ, 0, mountainMinHeight, grassDarkMost, grassLightMost));
      }

      vertex(x1, y1, z1);
      vertex(x2, y2, z2);
    }

    endShape();
  }


  yParamInit -= yIncrement;
}


float terrainHeightAt(float x, float y, float xParamInit, float yParamInit, float maxHeight) {
  float xParam = xParamInit + x * xIncrement / cellSize;
  float yParam = yParamInit + y * yIncrement / cellSize;
  return maxHeight * noise(xParam, yParam);
}


color mapColor(float value, float minValue, float maxValue, color minColor, color maxColor) {
  float r = map(value, minValue, maxValue, red(minColor), red(maxColor));
  float g = map(value, minValue, maxValue, green(minColor), green(maxColor));
  float b = map(value, minValue, maxValue, blue(minColor), blue(maxColor));
  
  return color(r, g, b);
}
