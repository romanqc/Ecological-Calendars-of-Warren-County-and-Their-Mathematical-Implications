import ddf.minim.*;
import java.util.ArrayList;

Minim minim;
AudioPlayer song;

ArrayList<Particle> particles;
ArrayList<FixedPoint> fixedPoints;

void setup() {
  fullScreen();
  minim = new Minim(this);
  
  // Load the audio file
  song = minim.loadFile("beat.mp3", 2048);
  song.play();
  
  particles = new ArrayList<Particle>();
  fixedPoints = new ArrayList<FixedPoint>();
  
  // Create initial particles
  for (int i = 0; i < 100; i++) {
    particles.add(new Particle(random(width), random(height)));
  }
}

void draw() {
  background(0);
  
  // Get the amplitude of the song
  float amplitude = song.mix.get(0); // Mono audio
  
  // Based on amplitude, spawn attracting or repelling points
  if (amplitude > 0.5) {
    fixedPoints.add(new FixedPoint(random(width), random(height), true));  // Attracting
  } else {
    fixedPoints.add(new FixedPoint(random(width), random(height), false));  // Repelling
  }
  
  // Update and display particles
  for (Particle p : particles) {
    p.update();
    p.display();
  }
  
  // Update and display fixed points
  for (FixedPoint f : fixedPoints) {
    f.display();
  }
}

class Particle {
  PVector position;
  PVector velocity;
  
  Particle(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(random(-2, 2), random(-2, 2));
  }
  
  void update() {
    for (FixedPoint f : fixedPoints) {
      PVector direction = PVector.sub(f.position, position);
      float dist = direction.mag();
      direction.normalize();
      
      // Apply force based on whether the fixed point is attracting or repelling
      if (f.isAttracting) {
        velocity.add(direction.mult(0.1));  // Attract
      } else {
        velocity.sub(direction.mult(0.1));  // Repel
      }
    }
    
    position.add(velocity);
    velocity.limit(5);  // Limit speed
  }
  
  void display() {
    fill(255, 180, 61);
    noStroke();
    ellipse(position.x, position.y, 10, 10);
  }
}

class FixedPoint {
  PVector position;
  boolean isAttracting;
  
  FixedPoint(float x, float y, boolean attract) {
    position = new PVector(x, y);
    isAttracting = attract;
  }
  
  void display() {
    if (isAttracting) {
      fill(0, 255, 255);
    } else {
      fill(128, 0, 128);
    }
    noStroke();
    ellipse(position.x, position.y, 20, 20);
  }
}
