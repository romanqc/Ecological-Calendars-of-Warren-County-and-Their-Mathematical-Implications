//import ddf.minim.*;
//import ddf.minim.analysis.*;
//import peasy.*;

//Minim minim;
//AudioPlayer song;
//FFT fft;
//PeasyCam cam;

//int detailX = 60;
//int detailY = 30;
//float radius = 150;
//float tubeRadius = 50;

//void setup() {
//  size(800, 800, P3D);
//  minim = new Minim(this);
//  song = minim.loadFile("beat.mp3", 1024);
//  fft = new FFT(song.bufferSize(), song.sampleRate());
//  fft.logAverages(22, 3);
//  cam = new PeasyCam(this, 400);
//  song.play();
//}

//void draw() {
//  background(0);
//  lights();
//  noStroke();
//  fft.forward(song.mix);
  
//  float bass = fft.getAvg(1) * 5;
//  float mid = fft.getAvg(5) * 5;
//  float treble = fft.getAvg(10) * 5;
  
//  drawTorus(radius, tubeRadius, bass, mid, treble);
//}

//void drawTorus(float r, float tr, float bass, float mid, float treble) {
//  for (int i = 0; i < detailX; i++) {
//    float theta1 = map(i, 0, detailX, 0, TWO_PI);
//    float theta2 = map(i + 1, 0, detailX, 0, TWO_PI);
    
//    beginShape(TRIANGLE_STRIP);
//    for (int j = 0; j <= detailY; j++) {
//      float phi = map(j, 0, detailY, 0, TWO_PI);
      
//      float amp = (j < detailY / 3) ? bass : (j < 2 * detailY / 3) ? mid : treble;
//      float colorFactor = map(j, 0, detailY, 0, 1);
      
//      int c1 = color(255, 0, 0);  // Bass - Red
//      int c2 = color(0, 255, 0);  // Mid - Green
//      int c3 = color(0, 0, 255);  // Treble - Blue
      
//      int c = (j < detailY / 3) ? lerpColor(c1, c2, colorFactor * 3) : 
//              (j < 2 * detailY / 3) ? lerpColor(c2, c3, (colorFactor - 1.0 / 3) * 3) : 
//              lerpColor(c3, c1, (colorFactor - 2.0 / 3) * 3);
      
//      PVector p1 = getTorusPoint(r, tr + sin(frameCount * 0.1 + phi * 2) * amp, theta1, phi);
//      PVector p2 = getTorusPoint(r, tr + sin(frameCount * 0.1 + phi * 2) * amp, theta2, phi);
     
      
//      fill(c);
//      vertex(p1.x, p1.y, p1.z);
//      vertex(p2.x, p2.y, p2.z);
//    }
//    endShape();
//  }
//}

//PVector getTorusPoint(float r, float tr, float theta, float phi) {
//  float x = (r + tr * cos(phi)) * cos(theta);
//  float y = (r + tr * cos(phi)) * sin(theta);
//  float z = tr * sin(phi);
//  return new PVector(x, y, z);
//}
