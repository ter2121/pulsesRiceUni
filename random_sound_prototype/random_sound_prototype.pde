import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//////////// FROM HEARTBEAT CODE //////////////////////////
import processing.serial.*;  // serial library lets us talk to Arduino
Serial myPort;
PFont font;
PFont portsFont;
Serial port;
int Sensor;      // HOLDS PULSE SENSOR DATA FROM ARDUINO
int IBI;         // HOLDS TIME BETWEN HEARTBEATS FROM ARDUINO
int BPM = 0;         // HOLDS HEART RATE VALUE FROM ARDUINO
String inData = "";
int mode = 35;

int dataSerialInt;

int heart = 0;   // This variable times the heart image 'pulse' on screen
//  THESE VARIABLES DETERMINE THE SIZE OF THE DATA WINDOWS
boolean beat = false;    // set when a heart beat is detected, then cleared when the BPM graph is advanced
/////////////////////////////////////////////////////////////////////////////////

AudioPlayer player; //Initialize audio plaeyr
Minim minim; //Initialize minim
//This is a test change

//store names of mp3 files here
String[] sound_files = {
  "zhiPipa.mp3", "yuMountain.mp3", "melodyYuYao.mp3", "lanHuaHua.mp3", "yuAncient.mp3",
  "shangSnow.mp3", "gong.mp3"
};
int[] song_backgrounds = {
  200, 50, 173, 25, 150, 75, 250
};
 
void setup() {
  //Changed these two lines so we can just change the Array index to change ports
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  myPort.buffer(4);
  size(100, 100);
  minim = new Minim(this);
  int random_value = int(random(sound_files.length));
  String song_name = sound_files[random_value];
  player = minim.loadFile(song_name);
  background(0, mode, 200);
  player.pause();
}
 
void serialEvent (Serial myPort) {
  // get the byte:
  //int inByte = myPort.read();
  // print it:
  //println(inByte);
  if (myPort.available() > 0){
    inData = myPort.readString();
    inData = trim(inData);
  } else {
      inData = "";
    }
}
  


void draw() {
   dataSerialInt = int(inData);
   dataSerialInt = min(dataSerialInt, 200);
   println("serial data " + dataSerialInt);
   boolean isPulse = 40 < dataSerialInt;
 
    if (!player.isPlaying() && isPulse) {
      int random_value = int(random(sound_files.length));
      //math.floor ? math.round, math.ceiling
      String song_name = sound_files[random_value];
      int song_background = song_backgrounds[random_value];
      background(0,song_background, 200);
      player = minim.loadFile(song_name);
      player.play();
      //if (keyPressed){
      //  player.pause();
      //}
    }
}

  void stop(){
 
    player.close();//kill player
    minim.stop();//kill minim
    super.stop();//kill superClass audio Minim
  }
