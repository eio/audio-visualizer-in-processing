import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
//// change between loaded song or live input
AudioPlayer input;
// AudioInput live;
FFT fft;
float maxAmp;
float maxBand;
float curFreq;
float colour;
float force;
float sat;
int mode;
int imgOut;
int k;
int history;
int filled;
int fade;

int midX;
int midY;

void setup() {
  size(displayWidth, displayHeight, P3D);
  if (frame != null) {
    frame.setResizable(true);
  }
  colorMode(HSB, 1);
  smooth();
  minim = new Minim(this);
  
  // this gets one channel of microphone input 
  // with a buffer size of 1024 and sample rate of 44100 Hz
  //  live = minim.getLineIn(Minim.MONO, 256, 22050);
  
  // 16-bit WAV files will also work
  input = minim.loadFile("All In.mp3", 256);
  input.loop();

  // this creates an FFT object 
  // with the same buffer size and sample rate of our input
  fft = new FFT(input.bufferSize(), input.sampleRate());

  // use a Hamming window to shape the buffer
  // this reduces "spectral leakage" or "noise" in our signal
  // http://en.wikipedia.org/wiki/Window_function#Hamming_window
  // fft.window(FFT.HAMMING);

  //initialize drawing mode
  mode = 1;
  noCursor();
  
  midX = width/2;
  midY = height/2;
  // NOTE: 
  // the default frameRate() in Processing is 60 fps [frames per second]
  // this is very fast, but far less than 44100 Hz
  background(0);
  history = 0;
  filled = 0;
  fade = 0;
}

void draw() { 
  // perform a forward FFT on the samples in our monophonic input buffer
  fft.forward(input.left);
  fill(0,0,0,0.1);
  if (filled == 1){
    fill(colour, random(0.5, 1.0), 1, colour);  
  }
  if(history == 0){
    background(0);
  }
  if(fade == 1){
    fill(0,0,0,0.8);
    rect(0,0, width, height);
  }
  // reset the highest band value and current frequency
  // at the beginning of each draw
  //maxAmp = 0;
  //maxBand = 0;
  //curFreq = 0;

  //fft.forward(input.left);
  
  // find the frequency band with the highest amplitude
  // NOTES: 
  //   * fft.specSize() = the number of frequency bands returned = (fft.bufferSize/2) + 1
  //   * start i at 1 to avoid low frequencies we don't care about
  //for (int i = 1; i < fft.specSize(); i++) {
  //  if (fft.getBand(i) > maxAmp) {
  //    maxAmp = fft.getBand(i);
  //    maxBand = i;
  //  }
  //}
  // use the band number to find the center frequency of this band
  //curFreq = (maxBand/input.bufferSize()) * 44100;
  // print the current frequency to test alongside a tuner
  // this site is a great resource: http://www.phy.mtu.edu/~suits/notefreqs.html
  //println(curFreq);
  
  // fft.specSize() = 1025
  for (int i = 0; i < fft.specSize(); i+=2) {
    k = 2*i;
    colour = map(fft.getBand(i), 0, 5, 0, 1);
    stroke(colour, random(0.5, 1.0), 1, colour/2);
    // drawing lines will get a traditional spectogram 
    // (might need to scale band amplitude to visualize)
    //    line(i, height, i, height - fft.getBand(i) * 4);
    if (i < fft.specSize()/4) {
      force = fft.getBand(i);
    } else { 
      force = fft.getBand(i) * 50;
    }

    /////////////////////
    //  Visual Modes  //
    ///////////////////

    if (mode == 1) {// classic 2D spectrum analyzer mode
      line(i * 10, height, i * 10, height - fft.getBand(i) * 100);
    }
 
    if (mode == 2) {
      bezier(i, height, mouseX - force + i, mouseY - force + i, mouseX + force + i, mouseY + force + i, i, 0);
      bezier(width - i, height, mouseX - force + i, mouseY - force + i, mouseX + force + i, mouseY + force + i, width - i, 0);
      bezier(width, i, mouseX + force + i, mouseY + force + i, mouseX - force + i, mouseY - force + i, 0, i);
      bezier(width, height - i, mouseX + force + i, mouseY + force + i, mouseX - force + i, mouseY - force + i, 0, height - i);
    }

    if (mode == 3) {
      bezier(i, height, mouseX - force + i, force + i, force + i, mouseY - force + i, i, 0);
      bezier(width - i, height, mouseX - force + i, force + i, force + i, mouseY - force + i, width - i, 0);
      bezier(width, i/2, mouseY - force + i, force + i, force + i, mouseY - force + i, 0, i/2);
      bezier(width, height - i/2, mouseY - force + i, force + i, force + i, mouseY - force + i, 0, height - i/2);
    }
//    if (mode == 3) {
//    bezier(i, mouseY, width - force + i, force + i, force + i, height - force + i, i, 0);
//    bezier(width - i, height - mouseY + i, width - force + i, force + i, force + i, height - force + i, width - i, 0);
//    bezier(mouseX, i/2, height - force + i, force + i, force + i, height - force + i, 0, i/2);
//    bezier(mouseX, height - i/2, height - force + i, force + i, force + i, height - force + i, 0, height - i/2);
//    }

    if (mode == 4) {
      bezier(i, mouseY, width - force + i, force + i, force + i, height - force + i, i, 0);
      bezier(width - i, height - mouseY + i, width - force + i, mouseX + force + i, force + i, mouseX - force + i, width - i, 0);
      bezier(width - mouseX, i/2, height - force + i, force + i, force + i, mouseY - force + i, 0, i/2);
      bezier(mouseX, height - i/2, height - force + i, force + i, mouseY + force + i, height - force + i, 0, height - i/2);
    }

    if (mode == 5) {
      bezier(i, height, mouseX - force + k, force + mouseX, force + k, mouseX - force + k, i, 0);
      bezier(width - i, height - force + k, width - force + k, mouseX + force + k, force + k, mouseX - force + k, width - k, 0);
      bezier(width - k, k + force, mouseY - force + k, force + k, force + k, mouseY - force + k, 0, i/2);
      bezier(mouseX, height - k, height - force + k, force + k, mouseY + force + k, height - force + k, 0, height - k);
    }
    
    if (mode == 6) {
      beginShape();
      vertex(mouseX + random(force), mouseY + random(force));
      vertex(mouseX + random(force), mouseY - random(force));
      vertex(mouseX - random(force), mouseY - random(force));
      vertex(mouseX - random(force), mouseY + random(force));
      //vertex(midX + random(force), midY + random(force), midY + random(force));
      //vertex(midX + random(force), midY - random(force), midY - random(force));
      //vertex(midX - random(force), midY - random(force), midY + random(force));
      //vertex(midX - random(force), midY + random(force), midY - random(force));
      endShape(CLOSE);
    }

    if (mode == 7) {
      curve(i, height, mouseX - force + i, mouseY - force + i, mouseX + force - i, mouseY + force - i, i, mouseY);
      curve(width - i, height, mouseX - force - i, mouseY - force + i, mouseX + force + i, mouseY + force + i, width - i, mouseY);
      curve(mouseX, i, mouseX + force + i, mouseY + force - i, mouseX - force - i, mouseY - force + i, mouseX, i);
      curve(width, height - i, mouseX + force - i, mouseY + force - i, mouseX - force + i, mouseY - force - i, mouseX, mouseY - i);
    }

    if (mode == 8) {
      //point(mouseX - force + sin(i), mouseY - force + cos(i));
      //point(mouseX + force - sin(i), mouseY + force - cos(i));
      //point(mouseX - force + sin(i), mouseY + force + cos(i));
      //point(mouseX + force - sin(i), mouseY - force - cos(i));
      point(mouseX - force * sin(i), mouseY - force * cos(i));
      point(mouseX + force * sin(i), mouseY + force * cos(i));
      point(mouseX - force * sin(i), mouseY + force * cos(i));
      point(mouseX + force * sin(i), mouseY - force * cos(i));
    }

//    if (mode == 9) { // conductor
//    curve(i, height, mouseX - force + i, force + i, force + i, mouseY - force + i, i, 0);
//    curve(width - i, height, mouseX - force + i, mouseX * force + i, force + i, mouseY - force + i, width - i, 0);
//    curve(width, i/2, mouseY - force + i, force + i, force + i, mouseY - force + i, 0, i/2);
//    curve(width, height - i/2, mouseY - force + i, mouseY * force + i, force + i, mouseY - force + i, 0, height - i/2);
//    }
    if (mode == 9) {
      line(mouseX,mouseY,mouseX - force * sin(i), mouseY - force * cos(i));
      line(mouseX,mouseY,mouseX + force * sin(i), mouseY + force * cos(i));
      line(mouseX,mouseY,mouseX - force * sin(i), mouseY + force * cos(i));
      line(mouseX,mouseY,mouseX + force * sin(i), mouseY - force * cos(i));
    }
//    if (mode == 9) {
//    curve(i, height, mouseX - force + k, force + mouseX, force + k, mouseX - force + k, i, 0);
//    curve(width - i, height - force + k, width - force + k, mouseX + force + k, force + k, mouseX - force + k, width - k, 0);
//    curve(width - k, k + force, mouseY - force + k, force + k, force + k, mouseY - force + k, 0, i/2);
//    curve(mouseX, height - k, height - force + k, force + k, mouseY + force + k, height - force + k, 0, height - k);
//    }

    if (mode == 10) {
      bezier(mouseX,mouseY,mouseX - force * sin(i), mouseY - force * tan(i),mouseX - force + sin(i), mouseY - force + cos(i),mouseX,mouseY);
      bezier(mouseX,mouseY,mouseX + force * sin(i), mouseY + force * cos(i),mouseX - force + sin(i), mouseY - force + tan(i),mouseX,mouseY);
      bezier(mouseX,mouseY,mouseX - force * sin(i), mouseY + force * cos(i),mouseX - force + tan(i), mouseY - force + cos(i),mouseX,mouseY);
      bezier(mouseX,mouseY,mouseX + force * tan(i), mouseY - force * cos(i),mouseX - force + sin(i), mouseY - force + cos(i),mouseX,mouseY);
    }

    if (mode == 0) {
      ellipse(mouseX,mouseY, force + k, force + k);
    }
  }
}

void stop() {
  //close Minim audio classes
  input.close();
  minim.stop();
  super.stop();
}