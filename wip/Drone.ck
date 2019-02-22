// Init Event Classes
class GyroEvent extends Event{
    int id;
    float x;
    float y;
    float z;
}
GyroEvent gyroEvent;

class StateEvent extends Event{
    int id;
    int state;
}
StateEvent orientEvent;
StateEvent grabEvent;

class SliderEvent extends Event{
    int id;
    float value;
}
SliderEvent gainEvent;

// Init OSC In
OscIn oin;
OscMsg msg;
10101 => oin.port;

// Add OSC Address
"/gyro/velocity" => string gyroAddr => oin.addAddress;
"/orientation/faceup" => string orientAddr => oin.addAddress;
"/gyro/grabbed" => string grabAddr => oin.addAddress;
"/gainSlider/value" => string gainAddr => oin.addAddress;

// Setup Gyros
// Gyro Sounds
PRCRev r =>  Gain g => dac;
.05 => r.mix;

3 => int maxGyros;      // how many gyro in the env?

BeeThree b3s[maxGyros];
LPF fs[maxGyros];
vec3 gyroStates[maxGyros];
for (0 => int i; i < maxGyros; i++){
    BeeThree b => LPF f => r;
    220 * (i + 1) => f.freq;
    .9 / maxGyros => b.gain;
    //.1 => b.controlOne;

    b @=> b3s[i];
    f @=> fs[i];
    0 => gyroStates[i].x => gyroStates[i].y => gyroStates[i].z;
}


// Setup Notes
[16, 19, 22, 23, 24, 27] @=> int bases[];
[0, 1, 4, 3, 2, 0] @=> int octaves[];
[
 [0, 2, 4, 7, 11],
 [0, 3, 7, 9, 11],
 [0, 3, 5, 9, 11], 
 [0, 1, 3, 7, 10],
 [5, 7, 9, 10, 11],
 [0, 2, 4, 7, 9]
]
@=> int intervals[][];

// Global State for current orientations
0 => int basesIdx => int octsIdx => int intsIdx;

// Event Functions 
fun void MapGyroValues(){
    while(true){
        gyroEvent => now;
        gyroEvent.id => int b3idx;
        gyroEvent.x/10.0 +=> gyroStates[b3idx].x;
        gyroEvent.y/10.0 +=> gyroStates[b3idx].y;
        gyroEvent.z/10.0 +=> gyroStates[b3idx].z;

        UpdateFrequencies(b3idx);
    }
}

fun void MapOrientations(){
    while (true){
        orientEvent => now;
        if (orientEvent.id == 0){
            orientEvent.state => basesIdx;
        }
        else if (orientEvent.id == 1){
            orientEvent.state => octsIdx;
        }
        else if (orientEvent.id == 2){
            orientEvent.state => intsIdx;
        }

        for (0 => int i; i < maxGyros; i++){
            UpdateFrequencies(i);
        }
    }
}

[0, 0, 0] @=> int started[];
fun void StartGyro(int id){
    while(started[id] == 0){
        grabEvent => now;
        if (grabEvent.id == id){
            1 => started[id];
            1 => b3s[id].noteOn;
        }
    }
}

fun void UpdateGain(){
    while(true){
        gainEvent => now;
        gainEvent.value => g.gain;
    }
}

spork ~ MapGyroValues();
spork ~ MapOrientations();
spork ~ UpdateGain();
for (0 => int i; i < maxGyros; i++){
    spork ~ StartGyro(i);
}

// Updating Frequencies based on GryoState
fun void UpdateFrequencies(int id){
    Math.fmod(Math.fabs(gyroStates[id].x), intervals[intsIdx].cap()) $ int => int noteIncIdx;
    Std.mtof(bases[basesIdx] + intervals[intsIdx][noteIncIdx] + 12 * octaves[octsIdx]) => b3s[id].freq;
    
    mapClamp(gyroStates[id].y, -2, 2, 0, 1) => b3s[id].lfoDepth;
    mapClamp(gyroStates[id].z, -2, 2, -10, 10) + b3s[id].freq() => b3s[id].freq;
    
    
    <<<"Inc Idx: ", id, noteIncIdx>>>;
    <<< gyroStates[id]>>>;
    <<<b3s[id].freq(), b3s[id].lfoDepth(), b3s[id].lfoSpeed()>>>;
}


// Setup initial frequencies
for (0 => int i; i < maxGyros; i++){
    UpdateFrequencies(i);
}
// Start it all up
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
        else if (msg.address == grabAddr){
            msg.getInt(0) => grabEvent.id;
            grabEvent.broadcast();
        }
        else if (msg.address == orientAddr){
            msg.getInt(0) => orientEvent.id;
            msg.getInt(1) => orientEvent.state;
            orientEvent.broadcast();
        }
        else if (msg.address == gainAddr){
            msg.getInt(0) => gainEvent.id;
            msg.getFloat(1) => gainEvent.value;
            gainEvent.broadcast();
        }
    }
}

fun float mapClamp(float value, float inMin, float inMax, float outMin, float outMax){
    outMin + (outMax - outMin) * ((value - inMin) / (inMax - inMin)) => float tmp;
    return clamp(tmp, outMin, outMax);
}

fun float clamp(float val, float a, float b){
    return Math.max(Math.min(val, b), a);
}