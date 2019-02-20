TriOsc tri => dac;

220 => tri.freq;
0.0 => tri.gain;

OscIn oin;
10101 => oin.port;
OscMsg msg;

"/gyro/velocity" => string gyroAddr => oin.addAddress;
"/accxyz" => string touchAccAddr => oin.addAddress;
"/gyro/grabbed" => string grabbedAddr => oin.addAddress;

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

class AccEvent extends Event{
    float x;
    float y;
    float z;
}
AccEvent accEvent;

fun void waitForGyro(){
    while(true){
        gyroEvent => now;
        clamp(tri.freq() + gyroEvent.x * 5, 30, 3000) => tri.freq;
        clamp(tri.gain() + gyroEvent.z * .01, 0, 1) => tri.gain;
        
        <<<"X: ", gyroEvent.x>>>;
        <<<"Y: ", gyroEvent.y>>>;
        <<<"Z: ", gyroEvent.z>>>;
        <<<"Freq: ", tri.freq()>>>;
        <<<"Gain: ", tri.gain()>>>;
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

fun void waitForAcc(){
    while(true){
        accEvent => now;
        clamp(tri.freq() + accEvent.z, 30, 3000) => tri.freq;
        //clamp(tri.gain() + accEvent.z, 0, 1) => tri.gain;
        
        <<<"X: ", accEvent.x>>>;
        <<<"Y: ", accEvent.y>>>;
        <<<"Z: ", accEvent.z>>>;
        <<<"Freq: ", tri.freq()>>>;
        <<<"Gain: ", tri.gain()>>>;
    }
}
spork ~ waitForAcc();

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
            msg.getFloat(0) => accEvent.x;
            msg.getFloat(1) => accEvent.y;
            msg.getFloat(2) => accEvent.z;
            accEvent.broadcast();
        }
        else if (msg.address == grabbedAddr){
            msg.getInt(0) => trigEvent.id;
            trigEvent.broadcast();
        }
    }
}

fun float clamp(float val, float a, float b){
    return Math.max(Math.min(val, b), a);
}