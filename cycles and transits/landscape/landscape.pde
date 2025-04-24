// Grid and Terrain Settings
int cols, rows;
int scl = 30;
int w = 3000/5;
int h = 2400/5;
float[][] terrain;

// Animation & Movement Variables
float flying = 0;
float t = 0;
float editz = 0;
float rmove = 0, lmove = 0;
float m = 0;

// Sphere Variables
int numSpheres = 3;
float[] sphereX, sphereZ, sphereOffset;
float[] sphereTargetX, sphereTargetZ;

void setup() {
  size(1080, 1920, P3D);
  cols = w / scl;
  rows = h / scl;
  terrain = new float[cols][rows];

  // Initialize spheres with random positions
  sphereX = new float[numSpheres];
  sphereZ = new float[numSpheres];
  sphereOffset = new float[numSpheres];
  sphereTargetX = new float[numSpheres];
  sphereTargetZ = new float[numSpheres];

  for (int i = 0; i < numSpheres; i++) {
    sphereX[i] = random(-w / 2, w / 2);
    sphereZ[i] = random(-50, 50);
    sphereOffset[i] = random(1000);
    sphereTargetX[i] = sphereX[i];
    sphereTargetZ[i] = sphereZ[i];
  }
}

void draw() {
  frameRate(30);
  background(0);

  translate(width / 2, height / 2 + 100);
  
  drawBackground();
  generateTerrain();
  
  // Draw terrain layers
  drawTerrain(0, #FAB81A, 0.5);
  drawTerrain(-75, #A065BE, 0.7);
  drawTerrain(-150, #50AAB4, 1.0);

  // Draw floating spheres
  drawFloatingSpheres();

  t += 0.004;
  editz += 1;
  
  saveFrame("frames/line-######.png");
}

void drawBackground() {
  fill(#50AAB4);
  stroke(30, 30);
  ellipse(150 + rmove, -150, 30, 30);
  ellipse(-190 - lmove / 1.4, -180, 20, 20);
  
  noFill();
  stroke(#50AAB4);
  translate(-160, -225, 40);
  sphereDetail(6);
  rotateY(t);
  sphere(60);
  rotateY(-t);
  translate(160, 255, -40);
  
  sphereDetail(40);

  if (rmove >= width / 2 - 150) rmove = -width + 150;
  if (lmove >= width / 2 - 150) lmove = -width - 80;

  rmove++;
  lmove++;
}

void generateTerrain() {
  flying -= 0.1;
  float yoff = flying;
  
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -30, 90);
      xoff += 0.2;
    }
    yoff += 0.2;
  }
}

void drawTerrain(float yOffset, color strokeColor, float strokeWeightScale) {
  rotateY(t);
  noFill();
  stroke(strokeColor);
  strokeWeight(0.5 * strokeWeightScale);
  
  rotateX(PI / 2);
  pushMatrix();
  translate(-w / 2, -h / 2 + yOffset);
  
  for (int y = 0; y < rows - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x * scl, y * scl, terrain[x][y]);
      vertex(x * scl, (y + 1) * scl, terrain[x][y + 1]);
    }
    endShape();
  }
  
  popMatrix();
}

void drawFloatingSpheres() {
  for (int i = 0; i < numSpheres; i++) {
    // Smooth transition with lerp
    sphereX[i] = lerp(sphereX[i], sphereTargetX[i], 0.02);
    sphereZ[i] = lerp(sphereZ[i], sphereTargetZ[i], 0.02);

    pushMatrix();
    
    float terrainHeight = getTerrainHeight(sphereX[i], sphereZ[i]);
    translate(sphereX[i], terrainHeight + 50, sphereZ[i]);
    fill(brightenColor(getSphereColor(i)));
    noFill();
    //noStroke();
    stroke(brightenColor(getSphereColor(i)));
    sphereDetail(10);
    sphere(30);

    popMatrix();
    
    // Update sphere movement with smoother Perlin noise
    sphereTargetX[i] = map(noise(sphereOffset[i]), 0, 1, -w / 2, w / 2);
    sphereTargetZ[i] = map(noise(sphereOffset[i] + 500), 0, 1, -50, 50);
    sphereOffset[i] += 0.002; // Slower movement for smoother effect
  }
}

float getTerrainHeight(float xPos, float zPos) {
  int xIndex = int(map(xPos, -w / 2, w / 2, 0, cols - 1));
  int zIndex = int(map(zPos, -50, 50, 0, rows - 1));
  return terrain[constrain(xIndex, 0, cols - 1)][constrain(zIndex, 0, rows - 1)];
}

color getSphereColor(int index) {
  if (index == 0) return #FAB81A;
  if (index == 1) return #A065BE;
  return #50AAB4;
}

color brightenColor(color c) {
  return color(min(red(c) + 50, 255), min(green(c) + 50, 255), min(blue(c) + 50, 255));
}
