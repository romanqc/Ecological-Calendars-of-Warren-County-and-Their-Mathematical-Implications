ArrayList<Bird> flock;
PVector attractor; // The fixed point for orbiting
boolean attractorActive = false; // Toggle attractor on/off

void setup() {
  fullScreen();
  flock = new ArrayList<Bird>();
  for (int i = 0; i < 100; i++) {
    flock.add(new Bird(random(width), random(height)));
  }
}

void draw() {
  background(0);
  
  if (attractorActive) {
    fill(255, 0, 0);
    noStroke();
    //ellipse(attractor.x, attractor.y, 10, 10); // Draw attractor point
  }
  
  for (Bird b : flock) {
    if (attractorActive) {
      b.orbit(attractor); // Birds orbit when attractor is active
    } else {
      b.flock(flock); // Birds flock normally when attractor is off
    }
    b.update();
    b.show();
  }
  //saveFrame("frames/line-######.png");
}

void mousePressed() {
  if (attractorActive) {
    attractorActive = false; // Disable the attractor on second click
  } else {
    attractor = new PVector(width / 2, height / 2);
    attractorActive = true; // Enable the attractor on first click
  }
}

class Bird {
  PVector position, velocity, acceleration;
  float maxForce = 0.05;
  float maxSpeed = 3;
  
  Bird(float x, float y) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    velocity.setMag(random(2, 4));
    acceleration = new PVector();
  }
  
  void flock(ArrayList<Bird> birds) {
    PVector align = align(birds);
    PVector cohesion = cohesion(birds);
    PVector separation = separate(birds);
    
    acceleration.add(align);
    acceleration.add(cohesion);
    acceleration.add(separation);
  }
  
  void orbit(PVector target) {
    float orbitRadius = 100; // Radius of the limit cycle

    PVector toCenter = PVector.sub(target, position);
    float distance = toCenter.mag();

    if (distance > orbitRadius) {
      PVector desiredVelocity = toCenter.copy().setMag(maxSpeed); // Move toward orbit
      PVector steer = PVector.sub(desiredVelocity, velocity);
      steer.limit(maxForce);
      acceleration.add(steer);
    } else {
      PVector tangent = new PVector(-toCenter.y, toCenter.x).normalize().mult(maxSpeed); // Perpendicular motion
      PVector steer = PVector.sub(tangent, velocity);
      steer.limit(maxForce);
      acceleration.add(steer);
    }
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);

    // Wrap around edges
    if (position.x > width) position.x = 0;
    if (position.x < 0) position.x = width;
    if (position.y > height) position.y = 0;
    if (position.y < 0) position.y = height;

    acceleration.mult(0); // Reset acceleration
  }
  
  void show() {
    int nearbyBirds = countNearbyBirds(flock); // Count flockmates

    // Assign color based on flock size
    if (nearbyBirds == 0) {
      fill(#50AAB4); // Alone
    } else if (nearbyBirds < 7) {
      fill(#A065BE); // Small group
    } else {
      fill(#FAB81A); // Large group
    }

    noStroke();
    pushMatrix();
    translate(position.x, position.y);
    float angle = velocity.heading();
    rotate(angle);
    beginShape();
    vertex(5, 0);
    vertex(-5, -3);
    vertex(-5, 3);
    endShape(CLOSE);
    popMatrix();
  }
  
  int countNearbyBirds(ArrayList<Bird> birds) {
    int count = 0;
    for (Bird other : birds) {
      if (other != this && dist(position.x, position.y, other.position.x, other.position.y) < 50) {
        count++;
      }
    }
    return count;
  }
  
  PVector align(ArrayList<Bird> birds) {
    PVector steer = new PVector();
    int total = 0;
    for (Bird other : birds) {
      if (other != this && dist(position.x, position.y, other.position.x, other.position.y) < 50) {
        steer.add(other.velocity);
        total++;
      }
    }
    if (total > 0) {
      steer.div(total);
      steer.setMag(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }
  
  PVector cohesion(ArrayList<Bird> birds) {
    PVector center = new PVector();
    int total = 0;
    for (Bird other : birds) {
      if (other != this && dist(position.x, position.y, other.position.x, other.position.y) < 50) {
        center.add(other.position);
        total++;
      }
    }
    if (total > 0) {
      center.div(total);
      return seek(center);
    }
    return new PVector();
  }
  
  PVector separate(ArrayList<Bird> birds) {
    PVector steer = new PVector();
    int total = 0;
    for (Bird other : birds) {
      float d = dist(position.x, position.y, other.position.x, other.position.y);
      if (other != this && d < 25) {
        PVector diff = PVector.sub(position, other.position);
        diff.div(d);
        steer.add(diff);
        total++;
      }
    }
    if (total > 0) {
      steer.div(total);
      steer.setMag(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    return steer;
  }
}
