int cols, rows;
int scl = 20; // Grid spacing
Particle[] particles;
PVector[][] flowfield;
ArrayList<FixedPoint> fixedPoints;
int numFixedPoints = 6; // Number of attractors, repellers, saddles, limit cycles
Particle redLeader, redFollower;
FixedPoint selectedFixedPoint = null;
int selectedType = -1;

void setup() {
  fullScreen();
  cols = width / scl;
  rows = height / scl;

  flowfield = new PVector[cols][rows];
  particles = new Particle[498]; // 498 regular particles

  // Randomly generate fixed points centered on the screen
  fixedPoints = new ArrayList<>();
  for (int i = 0; i < numFixedPoints; i++) {
    float x = random(width * 0.25, width * 0.75);  
    float y = random(height * 0.25, height * 0.75);
    PVector pos = new PVector(x, y);
    int type = int(random(4)); // 0: Attractor, 1: Repeller, 2: Saddle, 3: Limit Cycle
    fixedPoints.add(new FixedPoint(pos, type));
  }

  for (int i = 0; i < particles.length; i++) {
    PVector startPos = new PVector(random(width), random(height));
    particles[i] = new Particle(startPos, false);
  }

  PVector redStartLeader = new PVector(random(width), random(height));
  PVector redStartFollower = new PVector(random(width), random(height));

  redLeader = new Particle(redStartLeader, true);
  redFollower = new Particle(redStartFollower, true);
}

void draw() {
  background(0, 10);

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      PVector pos = new PVector(x * scl, y * scl);
      PVector field = computeVectorField(pos);
      flowfield[x][y] = field;
    }
  }

  for (Particle p : particles) {
    p.follow(flowfield);
    p.update();
    p.edges();
    p.show();
  }

  redLeader.follow(flowfield);
  redLeader.update();
  redLeader.edges();
  applyAttraction(redLeader, redFollower);
  redFollower.follow(flowfield);
  redFollower.update();
  redFollower.edges();
  redLeader.show();
  redFollower.show();
}

void keyPressed() {
  if (key >= '1' && key <= '5') {
    int newType = key - '1';
    if (selectedFixedPoint != null) {
      fixedPoints.remove(selectedFixedPoint);
    }
    float x = random(width * 0.25, width * 0.75);
    float y = random(height * 0.25, height * 0.75);
    selectedFixedPoint = new FixedPoint(new PVector(x, y), newType);
    fixedPoints.add(selectedFixedPoint);
    selectedType = newType;
  } else if (key == 'r' || key == 'R') {
    for (Particle p : particles) {
      p.pos = new PVector(random(width), random(height));
      p.vel.set(0, 0);
      p.trail.clear();
    }
    redLeader.pos = new PVector(random(width), random(height));
    redLeader.vel.set(0, 0);
    redLeader.trail.clear();

    redFollower.pos = new PVector(random(width), random(height));
    redFollower.vel.set(0, 0);
    redFollower.trail.clear();
  }
}


PVector computeVectorField(PVector pos) {
  PVector field = new PVector(0, 0);
  for (FixedPoint fp : fixedPoints) {
    PVector dir = PVector.sub(pos, fp.pos);
    float r2 = dir.magSq() + 1;
    switch (fp.type) {
      case 0:
        dir.mult(-1 / r2);
        break;
      case 1:
        dir.mult(1 / r2);
        break;
      case 2:
        dir = new PVector(dir.x, -dir.y);
        break;
      case 3:
        float r = sqrt(r2);
        dir.set(-dir.y, dir.x);
        dir.mult(1 - (r / 100));
        break;
    }
    field.add(dir);
  }
  field.limit(5);
  return field;
}

class FixedPoint {
  PVector pos;
  int type;
  FixedPoint(PVector pos, int type) {
    this.pos = pos;
    this.type = type;
  }
}

class Particle {
  PVector pos, vel, acc;
  float maxSpeed = 4;
  ArrayList<PVector> trail = new ArrayList<PVector>();
  int trailLength = 20;
  boolean isRed;

  Particle(PVector startPos, boolean isRed) {
    pos = startPos.copy();
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    this.isRed = isRed;
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void follow(PVector[][] field) {
    int x = int(pos.x / scl);
    int y = int(pos.y / scl);
    x = constrain(x, 0, cols - 1);
    y = constrain(y, 0, rows - 1);
    applyForce(field[x][y]);
  }

  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
    trail.add(pos.copy());
    if (trail.size() > trailLength) trail.remove(0);
  }

  void edges() {
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
      FixedPoint repeller = fixedPoints.stream().filter(fp -> fp.type == 1).findFirst().orElse(fixedPoints.get(0));
      PVector dir = PVector.sub(pos, repeller.pos).setMag(50);
      pos = PVector.add(repeller.pos, dir);
      vel.set(0, 0);
      trail.clear();
    }
  }

  void show() {
    noFill();
    for (int i = 1; i < trail.size(); i++) {
      PVector prev = trail.get(i - 1);
      PVector curr = trail.get(i);
      if (dist(prev.x, prev.y, curr.x, curr.y) > width / 2) continue;
      float alpha = map(i, 0, trail.size(), 0, 255);
      stroke(isRed ? color(255, 0, 0, alpha) : color(255, alpha));
      strokeWeight(isRed ? 5 : 0.5);
      line(prev.x, prev.y, curr.x, curr.y);
    }
  }
}

void applyAttraction(Particle leader, Particle follower) {
  PVector attractionForce = PVector.sub(leader.pos, follower.pos);
  float distance = attractionForce.mag();
  if (distance > 5) attractionForce.setMag(2.0);
  follower.applyForce(attractionForce);
}
