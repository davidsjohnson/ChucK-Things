TriOsc tri => dac;

220 => tri.freq;
.0 => tri.gain;

OscIn oin;
10101 => oin.port;
OscMsg msg;

"/gyro/velocity" => string gyroAddr => oin.addAddress;
"/accxyz" => string touchAccAddr => oin.addAddress;

class XYZEvent extends Event{
    int id;
    float x;
    float y;
    float z;
}
XYZEvent gyroEvent;


class AccEvent extends Event{
    float x;
    float y;
    float z;
}
AccEvent accEvent;

fun void waitForGyro(){
    while(true){
        gyroEvent => now;
        clamp(tri.freq() + gyroEvent.x, 30, 3000) => tri.freq;
        clamp(tri.gain() + gyroEvent.z, 0, 1) => tri.gain;
        
        <<<"X: ", gyroEvent.x>>>;
        <<<"Y: ", gyroEvent.y>>>;
        <<<"Z: ", gyroEvent.z>>>;
        <<<"Freq: ", tri.freq()>>>;
        <<<"Gain: ", tri.gain()>>>;
    }
}
spork ~ waitForGyro();

fun void waitForAcc(){
    while(true){
        accEvent => now;
        clamp(tri.freq() + accEvent.x, 30, 3000) => tri.freq;
        clamp(tri.gain() + accEvent.z, 0, 1) => tri.gain;
        
        <<<"X: ", accEvent.x>>>;
        <<<"Y: ", accEvent.y>>>;
        <<<"Z: ", accEvent.z>>>;
        <<<"Freq: ", tri.freq()>>>;
        <<<"Gain: ", tri.gain()>>>;
    }
}
spork ~ waitForGyro();

while (true){
    oin => now;
    while(oin.recv(msg)){
        if (msg.address == gyroAddr){
            msg.getInt(0) => gyroEvent.id;
            msg.getFloat(1) => gyroEvent.x;
            msg.getFloat(2) => gyroEvent.y;
            msg.getFloat(3) => gyroEvent.z;
            gyroEvent.broadcast();
        }
        else if (msg.address == touchAccAddr){
            msg.getFloat(1) => accEvent.x;
            msg.getFloat(2) => accEvent.y;
            msg.getFloat(3) => accEvent.z;
            accEvent.broadcast();
        }
    }
}

fun float clamp(float val, float a, float b){
    return Math.max(Math.min(val, b), a);
}