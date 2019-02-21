OscIn oin;
OscMsg msg;
10101 = oin.port;

"/gyro/values" => string gyroAddr => oin.addAddress;
"/orientation/faceup" => string orientAddr => oin.addAddress;


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
StateEvent orientEven


LPF f => NRev r =>  Gain g => dac;

BeeThree b3_0 => f;
BeeThree b3_1 => f;
BeeThree b3_2 => f;

440 => f.freq;

.2 => b3_0.gain;
.2 => b3_1.gain;
.2 => b3_2.gain;

.2 => b3_0.lfoDepth => b3_1.lfoDepth => b3_2.lfoDepth;
.5 => b3_0.controlOne => b3_1.controlOne => b3_2.controlOne;

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

1 => b3_0.noteOn => b3_1.noteOn => b3_2.noteOn;
while (true){

    Math.random2(0, 3) => b3_0.lfoSpeed;
    Math.random2(0, 3) => b3_1.lfoSpeed;
    Math.random2(0, 3) => b3_2.lfoSpeed;
    
    bases[Math.random2(0, 5)] => int base;
    octaves[Math.random2(0, 5)] => int oct;
    Std.mtof(base + intervals[Math.random2(0, 5)][Math.random2(0,4)] + 12 * oct) => b3_0.freq;
    Std.mtof(base + intervals[Math.random2(0, 5)][Math.random2(0,4)] + 12 * oct) => b3_1.freq;
    Std.mtof(base + intervals[Math.random2(0, 5)][Math.random2(0,4)] + 12 * oct) => b3_2.freq;

    1000::ms => now;
}