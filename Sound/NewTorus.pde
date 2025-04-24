//import ddf.minim.*;
//import ddf.minim.analysis.*;

//Minim minim;
//AudioPlayer song;
//FFT fft;

//int numU = 100, numV = 50;
//float[][][] torusPoints;
//color[] palette = { color(255, 180, 61), color(128, 0, 128), color(0, 255, 255) };

//void setup() {
//  fullScreen(P3D);
//  minim = new Minim(this);
//  song = minim.loadFile("beat.mp3");
//  song.loop();
  
//  fft = new FFT(song.bufferSize(), song.sampleRate());
//  torusPoints = new float[numU][numV][3];
//}

//void draw() {
//  background(0);
//  lights();
//  translate(width / 2, height / 2);
//  //rotateX(frameCount * 0.01);
//  //rotateY(frameCount * 0.02);
  
//  fft.forward(song.mix);
  
//  float R = 300;
//  float r = 150;
  
//  strokeWeight(3);

//  for (int i = 0; i < numU; i++) {
//    float u = map(i, 0, numU, 0, TWO_PI);
//    float uWrapped = map((i + 1) % numU, 0, numU, 0, TWO_PI); // Wrapping effect for continuity
//    for (int j = 0; j < numV; j++) {
//      float v = map(j, 0, numV, 0, TWO_PI);
//      float vWrapped = map((j + 1) % numV, 0, numV, 0, TWO_PI);
      
//      int band = int(map(i * j, 0, numU * numV, 0, fft.specSize())); // Ensuring all points are mapped
//      float amplitude = fft.getBand(band) * 20;
//      float noiseFactor = (noise(i * 0.1, j * 0.1, frameCount * 0.02) - 0.5) * amplitude * 2;
//      float noiseFactorWrapped = (noise((i + 1) * 0.1, (j + 1) * 0.1, frameCount * 0.02) - 0.5) * amplitude * 2;
      
//      float x = (R + r * cos(v) + noiseFactor) * cos(u);
//      float y = (R + r * cos(v) + noiseFactor) * sin(u);
//      float z = (r + noiseFactor) * sin(v);
      
//      float xWrapped = (R + r * cos(vWrapped) + noiseFactorWrapped) * cos(uWrapped);
//      float yWrapped = (R + r * cos(vWrapped) + noiseFactorWrapped) * sin(uWrapped);
//      float zWrapped = (r + noiseFactorWrapped) * sin(vWrapped);
      
//      torusPoints[i][j][0] = lerp(x, xWrapped, 0.5); // Smoothly transitioning
//      torusPoints[i][j][1] = lerp(y, yWrapped, 0.5);
//      torusPoints[i][j][2] = lerp(z, zWrapped, 0.5);
      
//      stroke(palette[(i + j) % palette.length]);
//      point(torusPoints[i][j][0], torusPoints[i][j][1], torusPoints[i][j][2]);
//    }
//  }
//}
