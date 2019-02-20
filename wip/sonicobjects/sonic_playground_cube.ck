// Sonic Playground Cube
// A Patch for an interactable cube in the OSC-XR Sonic Playgruond

// Params for control
// Q - Rotation
// Scale (which face is on top)
// Gain (3D Grid)
// Rate (3D Grid) - controlled by BPM class and controls all objects
// Feedback

int scale;
int octave;
int cubeID;

BPM bpm;
100 => bpm.tempo;

SonicCube sc;
SonicCube sc2;
SonicCube sc3;
[sc, sc2, sc3] @=> SonicCube cubes[];

Gain g => dac;
sc.connect(g);
.1 => sc.gain;
sc2.connect(g);
.1 => sc2.gain;
sc3.connect(g);
.1 => sc3.gain;

.5 => g.gain;

40 => int base;

[0, 2, 4, 7, 9] @=> int majorPentaScale[];
[0, 2, 3, 7, 8] @=> int minorPentaScale[];
[0, 2, 4, 5, 7, 9, 11, 12] @=> int majorScale[];
[0, 2, 3, 5, 7, 8, 10, 12] @=> int minorScale[];
[0, 2, 4, 5, 7, 9, 10, 12] @=> int mixolydianScale[];
[0, 2, 3, 5, 7, 8, 10, 12] @=> int aeolianScale[];
[majorPentaScale, 
 minorPentaScale,
 majorScale,
 minorScale,
 mixolydianScale,
 aeolianScale] @=> int scales[][];

// Setup OSC
// Start receiver
OscIn oin;
OscMsg msg;
10102 => oin.port;

class OscStateEvent extends Event{
    int id;
    int state;
}

class OscXYZEvent extends Event{
    int id;
    float x;
    float y;
    float z;
}

OscStateEvent faceupEvent;
"/osccube/faceup" => string faceupAddr => oin.addAddress;

OscXYZEvent pyrEvent;
"/osccube/rotation/world" => string pyrAddr => oin.addAddress;

fun void WaitForPYR(){
    while(true){
        pyrEvent => now;
        //pyrEvent.x / 360.0 * 300.0 + 10 => float tempo => bpm.tempo;
        //pyrEvent.y / 360.0 * .70 => float fback => cubes[pyrEvent.id].set_fback;
        (pyrEvent.z / 360 * 6 - 3) $ int => octave;
        
        //<<<pyrEvent.id>>>;
        <<<"oct: " + octave>>>;
        //<<<"fback: " + fback>>>;
        //<<<"Gain " + gain>>>;
        //<<<"Q " + Q>>>;
    }
}
spork ~ WaitForPYR();

fun void WaitForFaceup(){
    while(true){
        faceupEvent => now;
        faceupEvent.state => scale;
    }
}
spork ~ WaitForFaceup();


fun void WaitForOSC(){
    while(true){
        oin => now;
        while(oin.recv(msg)){
            if (msg.address == faceupAddr){
                msg.getInt(0) => faceupEvent.id;
                msg.getInt(1) => faceupEvent.state;
                faceupEvent.broadcast();
            }
            else if (msg.address == pyrAddr){
                msg.getInt(0) => pyrEvent.id;
                msg.getFloat(1) => pyrEvent.x;
                msg.getFloat(2) => pyrEvent.y;
                msg.getFloat(3) => pyrEvent.z;
                pyrEvent.broadcast();
            }
        }
    }   
}
spork ~ WaitForOSC();

while(true){
    
    base + (octave * 12) + scales[scale][Math.random2(0, scales[scale].cap() - 1)] => int f0 => sc.freq;
    f0 + 5 + (12 * Math.random2(2, 3)) => sc2.freq;
    f0 + 7 + (12 * Math.random2(0, 2)) => sc3.freq;
    
    bpm.sixteenthNote => now;
    
    sc.next();
    sc2.next();
    sc3.next();
}