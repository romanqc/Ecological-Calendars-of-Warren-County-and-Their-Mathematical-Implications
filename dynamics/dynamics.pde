
import peasy.*;

PeasyCam cam;

int cols, rows, layers;
int scl = 20;
Particle[] particles;
PVector[][][] flowfield;
ArrayList<FixedPoint> fixedPoints;
int numFixedPoints = 6;
Particle redLeader, redFollower;

void setup() {
  size(1920, 1080, P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
  cols = width / scl;
  rows = height / scl;
  layers = width / scl;

  flowfield = new PVector[cols][rows][layers];
  particles = new Particle[98];

  fixedPoints = new ArrayList<>();
  for (int i = 0; i < numFixedPoints; i++) {
    float x = random(width * 0.25, width * 0.75);
    float y = random(height * 0.25, height * 0.75);
    float z = random(-width / 2, width / 2);
    PVector pos = new PVector(x, y, z);
    int type = int(random(4));
    fixedPoints.add(new FixedPoint(pos, type));
  }

  for (int i = 0; i < particles.length; i++) {
    PVector startPos = new PVector(random(width), random(height), random(-width / 2, width / 2));
    particles[i] = new Particle(startPos, false);
  }

  redLeader = new Particle(new PVector(random(width), random(height), 0), true);
  redFollower = new Particle(new PVector(random(width), random(height), 0), true);
}

void draw() {
  background(0);
  lights();
  translate(width / 2, height / 2, -500);

  for (int z = 0; z < layers; z++) {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        PVector pos = new PVector(x * scl, y * scl, z * scl);
        PVector field = computeVectorField(pos);
        flowfield[x][y][z] = field;
      }
    }
  }

  for (Particle p : particles) {
    p.follow(flowfield);
    p.update();
    p.show();
  }

  redLeader.follow(flowfield);
  redLeader.update();
  applyAttraction(redLeader, redFollower);
  redFollower.follow(flowfield);
  redFollower.update();

  redLeader.show();
  redFollower.show();
}

// Computes the vector field dynamically for 3D space
PVector computeVectorField(PVector pos) {
  PVector field = new PVector(0, 0, 0);
  for (FixedPoint fp : fixedPoints) {
    PVector dir = PVector.sub(pos, fp.pos);
    float r2 = dir.magSq() + 1;

    switch (fp.type) {
      case 0: dir.mult(-1 / r2); break; // Attractor
      case 1: dir.mult(1 / r2); break;  // Repeller
      case 2: dir = new PVector(dir.x, -dir.y, dir.z); break; // Saddle Point
      case 3: 
        float r = sqrt(r2);
        dir.set(-dir.y, dir.x, dir.z);
        dir.mult(1 - (r / 100));
        break;
    }
    field.add(dir);
  }
  field.limit(5);
  return field;
}

// Fixed Point class
class FixedPoint {
  PVector pos;
  int type;
  FixedPoint(PVector pos, int type) {
    this.pos = pos;
    this.type = type;
  }
}

// Particle class with trail history
class Particle {
  PVector pos, vel, acc;
  float maxSpeed = 4;
  boolean isRed;
  ArrayList<PVector> trail;
  int maxTrailLength = 50; // Trail length limit

  Particle(PVector startPos, boolean isRed) {
    pos = startPos.copy();
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);
    this.isRed = isRed;
    trail = new ArrayList<>();
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void follow(PVector[][][] field) {
    int x = int(pos.x / scl);
    int y = int(pos.y / scl);
    int z = int(pos.z / scl);
    x = constrain(x, 0, cols - 1);
    y = constrain(y, 0, rows - 1);
    z = constrain(z, 0, layers - 1);
    PVector force = field[x][y][z];
    applyForce(force);
  }

  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);

    // Add current position to trail
    trail.add(pos.copy());

    // Remove oldest point if trail is too long
    if (trail.size() > maxTrailLength) {
      trail.remove(0);
    }
  }

  void show() {
    pushMatrix();
    translate(pos.x - width / 2, pos.y - height / 2, pos.z);
    fill(isRed ? color(255, 0, 0) : color(255));
    noStroke();
    sphere(4);
    popMatrix();
    
    // Draw trail
    noFill();
    beginShape();
    for (int i = 0; i < trail.size(); i++) {
      float alpha = map(i, 0, trail.size(), 0, 255); // Fade effect
      stroke(isRed ? color(255, 0, 0, alpha) : color(255, alpha));
      PVector t = trail.get(i);
      vertex(t.x - width / 2, t.y - height / 2, t.z);
    }
    endShape();
  }
}

// Attraction between red leader and follower
void applyAttraction(Particle leader, Particle follower) {
  PVector attractionForce = PVector.sub(leader.pos, follower.pos);
  float distance = attractionForce.mag();
  if (distance > 5) {
    attractionForce.setMag(2.0);
    follower.applyForce(attractionForce);
  }
}
