int w = 1080, h = 1920;
float[][][] grid, next;
float dA = 1.0, dB = 0.5;
float feed = 0.055, kill = 0.062;
color[] palette;
float dropletExpansionRate = 2; // Rate at which droplets expand

void setup() {
  size(1080/2, 1920/2);
  pixelDensity(2);
  grid = new float[w][h][2];
  next = new float[w][h][2];

  // Define the color palette
  palette = new color[4];
  palette[0] = color(0, 0, 0); // black
  palette[1] = color(80, 170, 180); // blue
  palette[2] = color(250, 184, 26); // yellow
  palette[3] = color(160, 101, 190); // purple

  // Initialize everything to black
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = color(0);
  }
  updatePixels();

  // Initialize the grid with black background (A = 0, B = 0)
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      grid[x][y][0] = 1; // A starts at 1
      grid[x][y][1] = 0; // B starts at 0
    }
  }
}

void draw() {
  // More frequent drops for faster evolution
  if (frameCount % 20 == 0) {
    addRandomDroplet();
  }

  // Reaction-diffusion update
  for (int x = 1; x < w - 1; x++) {
    for (int y = 1; y < h - 1; y++) {
      float a = grid[x][y][0];
      float b = grid[x][y][1];

      float laplaceA = laplace(x, y, 0);
      float laplaceB = laplace(x, y, 1);

      float reaction = a * b * b;
      next[x][y][0] = a + (dA * laplaceA - reaction + feed * (1 - a)) * 1.0;
      next[x][y][1] = b + (dB * laplaceB + reaction - (kill + feed) * b) * 1.0;

      next[x][y][0] = constrain(next[x][y][0], 0, 1);
      next[x][y][1] = constrain(next[x][y][1], 0, 1);
    }
  }

  float[][][] temp = grid;
  grid = next;
  next = temp;

  // Draw to screen
  loadPixels();
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      float b = grid[x][y][1];
      pixels[x + y * w] = (b > 0) ? colorMap(b) : color(0);
    }
  }
  updatePixels();
  
  //saveFrame("frames/line-######.png");
}

// Laplacian calculation
float laplace(int x, int y, int index) {
  float sum = 0;
  sum += grid[x][y][index] * -1;
  sum += grid[x - 1][y][index] * 0.21;
  sum += grid[x + 1][y][index] * 0.2;
  sum += grid[x][y - 1][index] * 0.2;
  sum += grid[x][y + 1][index] * 0.2;
  sum += grid[x - 1][y - 1][index] * 0.04;
  sum += grid[x + 1][y - 1][index] * 0.05;
  sum += grid[x - 1][y + 1][index] * 0.05;
  sum += grid[x + 1][y + 1][index] * 0.05;
  return sum;
}

// Map B concentration to color
color colorMap(float value) {
  if (value < 0.25) return palette[0]; // Black
  else if (value < 0.5) return palette[1]; // Blue
  else if (value < 0.75) return palette[2]; // Yellow
  else return palette[3]; // Red
}

// Add a droplet at a random location and expand its rings over time
void addRandomDroplet() {
  int x = int(random(w));
  int y = int(random(h));
  color dropColor = palette[int(random(4))];

  int initialRadius = 10; // Initial size of the drop ring
  int maxRadius = 100; // Max size of the drop ring

  // Expand the ring gradually
  for (int r = initialRadius; r < maxRadius; r += dropletExpansionRate) {
    for (int dx = -r; dx <= r; dx++) {
      for (int dy = -r; dy <= r; dy++) {
        int nx = x + dx;
        int ny = y + dy;
        float distance = dist(0, 0, dx, dy);
        
        if (nx >= 0 && nx < w && ny >= 0 && ny < h && distance <= r) {
          // Apply a radial decay to create the ring effect
          float decay = 1 - (distance / r);
          grid[nx][ny][1] = max(grid[nx][ny][1], decay);
        }
      }
    }
  }
}
