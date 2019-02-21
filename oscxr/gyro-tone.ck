TriOsc tri => Gain g => dac;

100 => int ogFreq;

ogFreq => tri.freq;
0.2 => tri.gain;

0 => g.gain;

0 => int gyroID;
if (me.args() > 0){
    Std.atoi(me.arg(0)) => gyroID;
}

OscIn oin;
20101 + gyroID => oin.port;
OscMsg msg;

"/gyro/velocity" => string gyroAddr => oin.addAddress;
"/gyro/grabbed" => string grabbedAddr => oin.addAddress;
"/orientation/faceup" => string orientAddr => oin.addAddress;

class XYZEvent extends Event{
    int id;
    float x;
    float y;
    float z;
}
XYZEvent gyroEvent;

class TriggerEvent extends Event{
    int id;
}
TriggerEvent trigEvent;

class StateEvent extends Event{
    int id;
    int state;
}
StateEvent orientEvent;

fun void waitForGyro(){
    while(true){
        gyroEvent => now;
        clamp(tri.freq() + gyroEvent.x * 5, 30, 3000) => tri.freq;
        clamp(g.gain() + gyroEvent.z * .01, 0, 1) => g.gain;
    }
}
spork ~ waitForGyro();

0 => int started;
fun void waitForTrigger(){
    
    while(started == 0){
        trigEvent => now;
        .5 => tri.gain;
        1 => started;
    }
}
spork ~ waitForTrigger();

fun void WaitForOrientation(){
    while(true){
        orientEvent => now;
        (ogFreq * (orientEvent.state + 1)) => tri.freq;
    }
}
spork ~ WaitForOrientation();

while (true){
    oin => now;
    while(oin.recv(msg)){
        if (msg.getInt(0) == gyroID){
            if (msg.address == gyroAddr){
                msg.getInt(0) => gyroEvent.id;
                msg.getFloat(1) => gyroEvent.x;
                msg.getFloat(2) => gyroEvent.y;
                msg.getFloat(3) => gyroEvent.z;
                gyroEvent.broadcast();
            }
            else if (msg.address == grabbedAddr){
                msg.getInt(0) => trigEvent.id;
                trigEvent.broadcast();
            }
        }
        if (msg.address == orientAddr){
            msg.getInt(0) => orientEvent.id;
            msg.getInt(1) => orientEvent.state;
            orientEvent.broadcast();
        }
    }
}

fun float clamp(float val, float a, float b){
    return Math.max(Math.min(val, b), a);
}