int cols, rows;
float[][] A, B;  
float feed = 0.055, kill = 0.062, diffusionA = 1.0, diffusionB = 0.5;
int scaleFactor = 3; 
int dropletInterval = 10;  
int dropletSize = 6;  // Droplet size to form initial expanding rings

void setup() {
  size(1080/2, 1920/2);
  cols = width / scaleFactor;
  rows = height / scaleFactor;

  A = new float[cols][rows];
  B = new float[cols][rows];

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      A[x][y] = 1;
      B[x][y] = 0;
    }
  }
}

void draw() {
  background(0);  

  float[][] newA = new float[cols][rows];
  float[][] newB = new float[cols][rows];

  for (int x = 1; x < cols - 1; x++) {
    for (int y = 1; y < rows - 1; y++) {
      float a = A[x][y];
      float b = B[x][y];

      float laplaceA = (
        A[x-1][y] + A[x+1][y] + A[x][y-1] + A[x][y+1]) * 0.2 +
        (A[x-1][y-1] + A[x+1][y-1] + A[x-1][y+1] + A[x+1][y+1]) * 0.05 -
        a;
        
      float laplaceB = (
        B[x-1][y] + B[x+1][y] + B[x][y-1] + B[x][y+1]) * 0.2 +
        (B[x-1][y-1] + B[x+1][y-1] + B[x-1][y+1] + B[x+1][y+1]) * 0.05 -
        b;

      float reaction = a * b * b;
      newA[x][y] = a + (diffusionA * laplaceA - reaction + feed * (1 - a));
      newB[x][y] = b + (diffusionB * laplaceB + reaction - (kill + feed) * b);
      
      newA[x][y] = constrain(newA[x][y], 0, 1);
      newB[x][y] = constrain(newB[x][y], 0, 1);
    }
  }

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      A[x][y] = newA[x][y];
      B[x][y] = newB[x][y];

      float value = A[x][y] - B[x][y];
      value = map(value, -0.5, 0.5, 255, 0);  
      value = constrain(value, 0, 255);
      
      fill(value);
      noStroke();
      rect(x * scaleFactor, y * scaleFactor, scaleFactor, scaleFactor);
    }
  }

  if (frameCount % dropletInterval == 0) {
    int dropX = int(random(10, cols - 10));
    int dropY = int(random(10, rows - 10));

    for (int dx = -dropletSize; dx <= dropletSize; dx++) {
      for (int dy = -dropletSize; dy <= dropletSize; dy++) {
        int nx = dropX + dx;
        int ny = dropY + dy;
        if (nx > 0 && ny > 0 && nx < cols && ny < rows && dist(0, 0, dx, dy) <= dropletSize) {
          B[nx][ny] = 1;
        }
      }
    }
  }
  
  //saveFrame("frames/line-######.png");

}
