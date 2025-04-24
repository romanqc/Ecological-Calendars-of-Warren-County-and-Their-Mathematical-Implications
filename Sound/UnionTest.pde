//import ddf.minim.*;
//import ddf.minim.analysis.*;

//ArrayList<Star> stars = new ArrayList<Star>();

//Minim minim;
//AudioPlayer song;
//FFT fft;
//float angle = 0;

//// Store the drawn lines' space offsets over time
//ArrayList<Float> lineOffsets = new ArrayList<Float>();

//void setup() {
//  fullScreen(P3D);
//  minim = new Minim(this);
//  song = minim.loadFile("beat.mp3", 1024);
//  song.play();
//  noCursor();
//  fft = new FFT(song.bufferSize(), song.sampleRate());
//}

//void draw() {
//  background(0);
//  lights();
  
//  // Draw main waveform with rotation
//  pushMatrix();
//  translate(width / 2, height / 2, -300);
//  rotateZ(angle);
//  rotateX(angle);
  
//  fft.forward(song.mix);
  
//  strokeWeight(2);
//  noFill();
  
//  int numPoints = song.bufferSize();
//  float radius = 300;
  
//  beginShape();
//  for (int i = 0; i < numPoints; i += 50) {
//    float amplitude = abs(song.mix.get(i));
//    float waveform = amplitude * 300;
//    float theta = map(i, 0, numPoints, 0, TWO_PI * 5);
//    float x = cos(theta) * (radius + waveform);
//    float y = sin(theta) * (radius + waveform);
//    float z = map(i, 0, numPoints, -200, 200);
    
//    color waveColor;
//    if (amplitude < 0.1) {
//      waveColor = color(0, 255, 255); // Cyan - Low amplitude
//    } else if (amplitude < 0.15) {
//      waveColor = color(128, 0, 128); // Purple - Medium amplitude
//    } else {
//      waveColor = color(255, 180, 61); // Orange - High amplitude
//    }
    
//    stroke(waveColor);
//    vertex(x, y, z);
    
//    // Spawn stars randomly based on amplitude
//    if (random(1) < amplitude * 0.5) {
//      stars.add(new Star(random(width), random(height), waveColor));
//    }
//  }
//  endShape();
//  popMatrix(); // Restore original (unrotated) coordinate system
  
//  // Compute the average amplitude
//  float avgAmplitude = 0;
//  for (int i = 0; i < song.mix.size(); i++) {
//    avgAmplitude += abs(song.mix.get(i));
//  }
//  avgAmplitude /= song.mix.size(); // Normalize
  
//  // Dynamically add lines around the canvas based on average amplitude
//  float rotationAmount = map(avgAmplitude, 0, 0.2, 0, PI / 2); // Adjust rotation range
//  float dynamicSpacing = map(avgAmplitude, 0, 0.2, 40, 50); // Adjust spacing range
  
//  // Apply rotation and spacing
//  pushMatrix();
//  translate(width / 2, height / 2);
//  rotateZ(rotationAmount - PI / 4);  // Rotate based on amplitude
//  translate(-width / 2, -height / 2);
  
//  strokeWeight(1);
  
//  // Add new line offsets over time, increasing the number of lines drawn
//  if (frameCount % 60 == 0) { // Every second, add a new offset
//    lineOffsets.add(dynamicSpacing);
//  }
  
//  // Draw lines surrounding the canvas over time
//  for (float space : lineOffsets) {
//    float xOffset = random(-avgAmplitude * 50, avgAmplitude * 50);
//    float yOffset = random(-avgAmplitude * 50, avgAmplitude * 50);
    
//    line(space + xOffset, space + yOffset, width - space + xOffset, space + yOffset);
//    line(space + xOffset, space + yOffset, space + xOffset, height - space + yOffset);
//    line(space + xOffset, height - space + yOffset, width - space + xOffset, height - space + yOffset);
//    line(width - space + xOffset, space + yOffset, width - space + xOffset, height - space + yOffset);
//  }
  
//  strokeWeight(1);
//  popMatrix(); // Restore original state

//  // Draw stars outside of rotation
//  pushMatrix();
//  translate(0, 0, 0); // Ensure stars are unaffected by rotations
//  for (int i = stars.size() - 1; i >= 0; i--) {
//    Star s = stars.get(i);
//    s.update();
//    s.display();
//    if (s.alpha <= 0) {
//      stars.remove(i);
//    }
//  }
//  popMatrix();
  
//  angle += 0.01;
//}

//void stop() {
//  song.close();
//  minim.stop();
//  super.stop();
//}

//// Star class to handle random stars
//class Star {
//  float x, y;
//  float alpha;
//  color c;
  
//  Star(float x, float y, color c) {
//    this.x = x;
//    this.y = y;
//    this.c = c;
//    this.alpha = 255;
//  }
  
//  void update() {
//    alpha -= 5; // Fade out over time
//  }
  
//  void display() {
//    fill(c, alpha);
//    noStroke();
//    ellipse(x, y, 5, 5);
//  }
//}
