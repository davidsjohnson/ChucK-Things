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

// Init OSC In
OscIn oin;
OscMsg msg;
10101 => oin.port;

// Add OSC Address
"/gyro/values" => string gyroAddr => oin.addAddress;
"/orientation/faceup" => string orientAddr => oin.addAddress;
"/gryo/grabbed" => string grabAddr => oin.addAddress;

// Setup Gyros
// Gyro Sounds
LPF f => NRev r =>  Gain g => dac;
440 => f.freq;

3 => int maxGyros;      // how many gyro in the env?

BeeThree b3s[maxGyros];
vec3 gryoStates[maxGyros];
for (0 => int i; i < maxGyros; i++){
    BeeThree b => f;
    .9 / maxGyros => b.gain;
    .2 => b.lfoDepth;
    .5 => b.controlOne;

    b @=> b3s[i];
    0 => gryoStates[i].x => gryoStates[i].y => gryoStates[i].z;
}


// Setup Notes
[10, 12, 14, 16, 19, 22] @=> int bases[];
[0, 1, 4, 3, 2, 0] @=> int octaves[];
[
 [0, 2, 4, 7, 12],
 [0, 3, 7, 9, 11],
 [0, 3, 5, 11, 12], 
 [0, 1, 3, 7, 10],
 [5, 7, 9, 11, 12],
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
        gyroEvent.x/10.0 +=> gryoStates[b3idx].x;
        gyroEvent.y/10.0 +=> gryoStates[b3idx].y;
        gyroEvent.z/10.0 +=> gryoStates[b3idx].z;

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

spork ~ MapGyroValues();
spork ~ MapOrientations();
for (0 => int i; i < maxGyros; i++){
    spork ~ StartGyro(i);
}

// Updating Frequencies based on GryoState
fun void UpdateFrequencies(int id){
    (gryoStates[id].x $ int % intervals[intsIdx].cap()) => int noteIncIdx;
    <<<"Inc Idx: ", id, noteIncIdx>>>;
    Std.mtof(bases[basesIdx] + intervals[intsIdx][noteIncIdx] + 12 * octaves[octsIdx]) => b3s[id].freq;
    <<<"Freq: ", id, b3s[id].freq()>>>;
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
    }
}

    // Math.random2(0, 3) => b3_0.lfoSpeed;
    // Math.random2(0, 3) => b3_1.lfoSpeed;
    // Math.random2(0, 3) => b3_2.lfoSpeed;
    
    // bases[Math.random2(0, 5)] => int base;
    // octaves[Math.random2(0, 5)] => int oct;
    // Std.mtof(base + intervals[Math.random2(0, 5)][Math.random2(0,4)] + 12 * oct) => b3_0.freq;
    // Std.mtof(base + intervals[Math.random2(0, 5)][Math.random2(0,4)] + 12 * oct) => b3_1.freq;
    // Std.mtof(base + intervals[Math.random2(0, 5)][Math.random2(0,4)] + 12 * oct) => b3_2.freq;

    // 1000::ms => now;