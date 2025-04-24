//import ddf.minim.*;

//Minim minim;
//AudioPlayer song;
//float angle = 0;
//float scaleFactor = 1.0;
//color waveColor; 
//float lowThreshold = 0.1;
//float mediumThreshold = 0.15;

//void setup() {
//  fullScreen(P3D);
//  minim = new Minim(this);
//  song = minim.loadFile("beat.mp3", 1024);
//  song.play();
//  noCursor();
//}

//void draw() {
//  background(0);
//  lights();
  
//  float[] mix = song.mix.toArray();
//  int len = mix.length;
  
//  float amplitude = 0;
//  for (float sample : mix) {
//    amplitude += abs(sample);
//  }
//  amplitude /= len;
  
//  scaleFactor = map(amplitude, 0, 0.5, 0.5, 2.0);
//  if (amplitude > 0.2 && random(1) > 0.7) {
//    scaleFactor *= random(1.2, 1.5);
//  }
  
//  if (amplitude > mediumThreshold) {
//    waveColor = color(255, 180, 61); // High amplitude → Orange
//  } else if (amplitude > lowThreshold) {
//    waveColor = color(128, 0, 128); // Medium amplitude → Purple
//  } else {
//    waveColor = color(0, 255, 255); // Low amplitude → Cyan
//  }
  
//  pushMatrix();
//  translate(width / 2, height / 2, 600);
//  rotateX(angle * amplitude * 2);
//  rotateY(angle);
//  rotateZ(angle * amplitude);
//  angle += 0.01;
  
//  strokeWeight(2);
//  for (int i = 0; i < len - 1; i++) {
//    float x1 = map(i, 0, len, -300 * scaleFactor, 300 * scaleFactor);
//    float y1 = map(mix[i], -1, 1, -150 * scaleFactor, 150 * scaleFactor);
//    float z1 = sin(i * 0.1) * 200 * scaleFactor;
//    float x2 = map(i + 1, 0, len, -300 * scaleFactor, 300 * scaleFactor);
//    float y2 = map(mix[i + 1], -1, 1, -150 * scaleFactor, 150 * scaleFactor);
//    float z2 = sin((i + 1) * 0.1) * 200 * scaleFactor;
    
//    stroke(waveColor);
//    line(x1, y1, z1, x2, y2, z2);
//  }
//  popMatrix();
  
//  translate(width/2, height/2);
  
//  for (int i = 0; i < 50; i++) {
//    float px = random(-width*3, width*3);
//    float py = random(-height*3, height*3);
//    float pz = random(-500, 500);
//    stroke(random(255), random(255), random(255));
//    strokeWeight(3);
//    point(px * amplitude, py * amplitude, pz);
//  }
  
//  if (amplitude > mediumThreshold && random(5) > 0.7) {
//    for (int i = 0; i < 10; i++) { // Generate 10 spheres
//      float sphereX = random(-width / 2, width / 2);
//      float sphereY = random(-height / 2, height / 2);
//      float sphereZ = random(-500, 500);
//      int sphereDetailLevel = int(map(amplitude, lowThreshold, 0.5, 1, 10));
//      pushMatrix();
//      translate(sphereX, sphereY, sphereZ);
//      rotateX(angle * 2 + i * 0.2);
//      rotateY(angle * 3 + i * 0.3);
//      stroke(random(255), random(255), random(255));
//      fill(random(255), random(255), random(255));
//      sphereDetail(sphereDetailLevel);
//      sphere(50 * scaleFactor);
//      popMatrix();
//    }
//  }
//}
