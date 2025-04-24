Fluid fluid;
int N = 300; // Grid resolution
float dt = 0.1f; // Time step
float diff = 0.0001f; // Diffusion rate
float visc = 0.0001f; // Viscosity

void setup() {
  size(500, 500);
  fluid = new Fluid(N, diff, visc, dt);
}

void draw() {
  background(0);
  fluid.step();
  fluid.render(this);
}

void mouseDragged() {
  int x = (int) map(mouseX, 0, width, 0, N);
  int y = (int) map(mouseY, 0, height, 0, N);
  fluid.addDensity(x, y, 100);
  fluid.addVelocity(x, y, (mouseX - pmouseX) * 10, (mouseY - pmouseY) * 10);
}

class Fluid {
  int size;
  float dt, diff, visc;
  float[] s, density;
  float[] vx, vy, vx0, vy0;

  Fluid(int size, float diff, float visc, float dt) {
    this.size = size;
    this.diff = diff;
    this.visc = visc;
    this.dt = dt;
    s = new float[size * size];
    density = new float[size * size];
    vx = new float[size * size];
    vy = new float[size * size];
    vx0 = new float[size * size];
    vy0 = new float[size * size];
  }

  void addDensity(int x, int y, float amount) {
    density[IX(x, y)] += amount;
  }

  void addVelocity(int x, int y, float amountX, float amountY) {
    vx[IX(x, y)] += amountX;
    vy[IX(x, y)] += amountY;
  }

  void step() {
    diffuse(1, vx0, vx, visc, dt);
    diffuse(2, vy0, vy, visc, dt);
    project(vx0, vy0, vx, vy);
    advect(1, vx, vx0, vx0, vy0, dt);
    advect(2, vy, vy0, vx0, vy0, dt);
    project(vx, vy, vx0, vy0);
    diffuse(0, s, density, diff, dt);
    advect(0, density, s, vx, vy, dt);
  }

  void render(PApplet p) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            float d = density[IX(i, j)];

            // Interpolate between light blue (light cyan) and light pink
            float r = lerp(173, 255, d);  // Red component (light pink is closer to 255)
            float g = lerp(216, 182, d);  // Green component
            float b = lerp(255, 191, d);  // Blue component (light blue is closer to 255)

            p.fill(r, g, b);
            p.noStroke();
            p.rect(i * (p.width / size), j * (p.height / size), p.width / size, p.height / size);
          }
      }
  }

  int IX(int x, int y) {
    return constrain(x, 0, size - 1) + constrain(y, 0, size - 1) * size;
  }

  void diffuse(int b, float[] x, float[] x0, float diff, float dt) {
    float a = dt * diff * (size - 2) * (size - 2);
    for (int k = 0; k < 20; k++) {
      for (int i = 1; i < size - 1; i++) {
        for (int j = 1; j < size - 1; j++) {
          x[IX(i, j)] = (x0[IX(i, j)] + a * (x[IX(i - 1, j)] + x[IX(i + 1, j)] + x[IX(i, j - 1)] + x[IX(i, j + 1)])) / (1 + 4 * a);
        }
      }
    }
  }

  void advect(int b, float[] d, float[] d0, float[] u, float[] v, float dt) {
    for (int i = 1; i < size - 1; i++) {
      for (int j = 1; j < size - 1; j++) {
        float x = i - dt * u[IX(i, j)];
        float y = j - dt * v[IX(i, j)];
        x = constrain(x, 0, size - 1);
        y = constrain(y, 0, size - 1);
        int i0 = (int) x, j0 = (int) y;
        d[IX(i, j)] = d0[IX(i0, j0)];
      }
    }
  }

  void project(float[] u, float[] v, float[] p, float[] div) {
    for (int i = 1; i < size - 1; i++) {
      for (int j = 1; j < size - 1; j++) {
        div[IX(i, j)] = -0.5f * (u[IX(i + 1, j)] - u[IX(i - 1, j)] + v[IX(i, j + 1)] - v[IX(i, j - 1)]) / size;
        p[IX(i, j)] = 0;
      }
    }
    for (int k = 0; k < 20; k++) {
      for (int i = 1; i < size - 1; i++) {
        for (int j = 1; j < size - 1; j++) {
          p[IX(i, j)] = (div[IX(i, j)] + (p[IX(i - 1, j)] + p[IX(i + 1, j)] + p[IX(i, j - 1)] + p[IX(i, j + 1)])) / 4;
        }
      }
    }
    for (int i = 1; i < size - 1; i++) {
      for (int j = 1; j < size - 1; j++) {
        u[IX(i, j)] -= 0.5f * (p[IX(i + 1, j)] - p[IX(i - 1, j)]) * size;
        v[IX(i, j)] -= 0.5f * (p[IX(i, j + 1)] - p[IX(i, j - 1)]) * size;
      }
    }
  }
}
