//import ddf.minim.*;
//import ddf.minim.analysis.*;

//Minim minim;
//AudioPlayer song;
//FFT fft;
//int cols = 100;
//int rows = 50;
//float r1 = 350;
//float r2 = 200;
//float time = 0;

//void setup() {
//  fullScreen(P3D);
//  minim = new Minim(this);
//  song = minim.loadFile("beat.mp3", 1024);
//  song.loop();
//  fft = new FFT(song.bufferSize(), song.sampleRate());
//}

//void draw() {
//  background(0);
//  lights();
//  directionalLight(255, 255, 255, 0, 0, -1);
//  pointLight(255, 0, 0, width / 2, height / 2, 200);
  
//  translate(width/2, height/2, -200);
//  rotateX(frameCount * 0.01);
//  rotateY(frameCount * 0.01);
  
//  fft.forward(song.mix);
//  float amp = song.mix.level() * 200;
//  time += 0.02;
  
//  for (int i = 0; i < cols; i++) {
//    float theta = map(i, 0, cols, 0, TWO_PI);
//    for (int j = 0; j < rows; j++) {
//      float phi = map(j, 0, rows, 0, TWO_PI);
      
//      int bassIndex = (int)map(i, 0, cols, 0, fft.specSize() / 3);
//      int midIndex = (int)map(j, 0, rows, fft.specSize() / 3, 2 * fft.specSize() / 3);
//      int trebleIndex = (int)map(i + j, 0, cols + rows, 2 * fft.specSize() / 3, fft.specSize());
      
//      float bassAmp = fft.getBand(bassIndex) * 20;
//      float midAmp = fft.getBand(midIndex) * 30;
//      float trebleAmp = fft.getBand(trebleIndex) * 20;
      
//      float ripple = sin(time - theta * 2 - phi * 3) * 50;
//      float distortion = bassAmp * sin(theta * 5) + midAmp * cos(phi * 4) + trebleAmp * sin(phi * 3) + ripple;
      
//      float x = (r1 + (r2 + distortion) * cos(phi)) * cos(theta);
//      float y = (r1 + (r2 + distortion) * cos(phi)) * sin(theta);
//      float z = (r2 + distortion) * sin(phi);
      
//      color c = color(map(bassAmp, 0, 300, 50, 255), map(midAmp, 0, 400, 50, 255), map(trebleAmp, 0, 200, 50, 255));
      
//      pushMatrix();
//      translate(x, y, z);
//      stroke(c);
//      strokeWeight(6);
//      point(0, 0, 0);
//      popMatrix();
//    }
//  }
//}

//void stop() {
//  song.close();
//  minim.stop();
//  super.stop();
//}
