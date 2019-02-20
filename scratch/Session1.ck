// David Johnson
// Session 1 Submission
// Jan 1, 2018


TriOsc tri => dac;
SawOsc saw => dac;
SqrOsc sqr => dac;
0 => tri.gain;
0 => saw.gain;
0 => sqr.gain;

.25::second => dur startDur;

56 => int base;
for (0 => int i; i < 4; 1 +=> i){
    0.8 => tri.gain;
    Std.mtof(base) => tri.freq;
    startDur => now;
    Std.mtof(base + 5) => tri.freq;
    startDur => now;
    Std.mtof(base + 3) => tri.freq;
    startDur => now;
    Std.mtof(base + 2) => tri.freq;
    startDur => now;
}

59 => int base2;
for (0 => int i; i < 4; 1 +=> i){
    0.8 => saw.gain;
    Std.mtof(base2) => saw.freq;
    Std.mtof(base) => tri.freq;
    startDur/2 => now;
    Std.mtof(base + 5) => tri.freq;
    startDur/2 => now;
    Std.mtof(base2 + 5) => saw.freq;
    Std.mtof(base + 3) => tri.freq;
    startDur/2 => now;
    Std.mtof(base + 2) => tri.freq;
    startDur/2 => now;
    Std.mtof(base2 + 3) => saw.freq;
    Std.mtof(base) => tri.freq;
    startDur/2 => now;
    Std.mtof(base + 5) => tri.freq;
    startDur/2 => now;
    Std.mtof(base2 + 2) => saw.freq;
    Std.mtof(base + 3) => tri.freq;
    startDur/2 => now;
    Std.mtof(base + 2) => tri.freq;
    startDur/2 => now;
}

64 => int base3;
for (0 => int i; i < 4; 1 +=> i){
    0.8 => sqr.gain;
    Std.mtof(base3) => sqr.freq;
    Std.mtof(base2) => saw.freq;
    Std.mtof(base) => tri.freq;
    startDur/2 => now;
    Std.mtof(base + 5) => tri.freq;
    Std.mtof(base2 + 5) => saw.freq;
    startDur/2 => now;
    Std.mtof(base3 + 5) => sqr.freq;
    Std.mtof(base + 3) => tri.freq;
    Std.mtof(base2 + 3) => saw.freq;
    startDur/2 => now;
    Std.mtof(base + 2) => tri.freq;
    Std.mtof(base2 + 2) => saw.freq;
    startDur/2 => now;
    Std.mtof(base3 + 3) => sqr.freq;
    Std.mtof(base) => tri.freq;
    Std.mtof(base2) => saw.freq;
    startDur/2 => now;
    Std.mtof(base + 5) => tri.freq;
    Std.mtof(base2 + 5) => saw.freq;
    startDur/2 => now;
    Std.mtof(base3 + 2) => sqr.freq;
    Std.mtof(base + 3) => tri.freq;
    Std.mtof(base2 + 3) => saw.freq;
    startDur/2 => now;
    Std.mtof(base + 2) => tri.freq;
    Std.mtof(base2 + 2) => saw.freq;
    startDur/2 => now;
}

0 => sqr.gain;
0 => saw.gain;
0 => tri.gain;

startDur * 4 => now;

.8 => tri.gain;
for (0 => int i; i < 4; 1 +=> i){
    Std.mtof(base) => tri.freq;
    startDur/8 => now;
    Std.mtof(base + 5) => tri.freq;
    startDur/8 => now;
    Std.mtof(base) => tri.freq;
    startDur/8 => now;
    Std.mtof(base+2) => tri.freq;
    startDur/8 => now;
}

0 => sqr.gain;
0 => saw.gain;
0 => tri.gain;

startDur * 2 => now;

.4 => sqr.gain;

for (0 => int i; i < 4; 1 +=> i){
    Std.mtof(base) => tri.freq;
    Std.mtof(base3+Math.random2(-12,12)) => sqr.freq;
    startDur/4 => now;
    Std.mtof(base + 5) => tri.freq;
    Std.mtof(base3+Math.random2(-12,12)) => sqr.freq;
    startDur/4 => now;
    Std.mtof(base) => tri.freq;
    Std.mtof(base3+Math.random2(-12,12)) => sqr.freq;
    startDur/4 => now;
    Std.mtof(base+2) => tri.freq;
    Std.mtof(base3+Math.random2(-12,12)) => sqr.freq;
    startDur/4 => now;
}

.2 => saw.gain;

for (0 => int i; i < 4; 1 +=> i){
    Std.mtof(base) => tri.freq;
    Std.mtof(base3) => sqr.freq;
    Std.mtof(base2+Math.random2(-12,12)) => saw.freq;
    startDur/8 => now;
    Std.mtof(base + 5) => tri.freq;
    Std.mtof(base3 + 5) => sqr.freq;
    Std.mtof(base2+Math.random2(-12,12)) => saw.freq;
    startDur/4 => now;
    Std.mtof(base) => tri.freq;
    Std.mtof(base3) => sqr.freq;
    Std.mtof(base2+Math.random2(-12,12)) => saw.freq;
    startDur/8 => now;
    Std.mtof(base + 2) => tri.freq;
    Std.mtof(base3 + 2) => sqr.freq;
    Std.mtof(base2+Math.random2(-12,12)) => saw.freq;
    startDur/4 => now;
}

0 => sqr.gain;
0 => saw.gain;
0 => tri.gain;
startDur * 3 => now;

for (0 => int i; i < 4; 1 +=> i){
    0.8 => sqr.gain;
    Std.mtof(base3) => sqr.freq;
    Std.mtof(base2) => saw.freq;
    Std.mtof(base) => tri.freq;
    startDur/2 => now;
    Std.mtof(base + 5) => tri.freq;
    Std.mtof(base2 + 5) => saw.freq;
    startDur/2 => now;
    Std.mtof(base3 + 5) => sqr.freq;
    Std.mtof(base + 3) => tri.freq;
    Std.mtof(base2 + 3) => saw.freq;
    startDur/2 => now;
    Std.mtof(base + 2) => tri.freq;
    Std.mtof(base2 + 2) => saw.freq;
    startDur/2 => now;
    Std.mtof(base3 + 3) => sqr.freq;
    Std.mtof(base) => tri.freq;
    Std.mtof(base2) => saw.freq;
    startDur/2 => now;
    Std.mtof(base + 5) => tri.freq;
    Std.mtof(base2 + 5) => saw.freq;
    startDur/2 => now;
    Std.mtof(base3 + 2) => sqr.freq;
    Std.mtof(base + 3) => tri.freq;
    Std.mtof(base2 + 3) => saw.freq;
    startDur/2 => now;
    Std.mtof(base + 2) => tri.freq;
    Std.mtof(base2 + 2) => saw.freq;
    startDur/2 => now;
}

for (0 => int i; i < 4; 1 +=> i){
    0.8 => saw.gain;
    Std.mtof(base2) => saw.freq;
    Std.mtof(base) => tri.freq;
    startDur/2 => now;
    Std.mtof(base + 5) => tri.freq;
    startDur/2 => now;
    Std.mtof(base2 + 5) => saw.freq;
    Std.mtof(base + 3) => tri.freq;
    startDur/2 => now;
    Std.mtof(base + 2) => tri.freq;
    startDur/2 => now;
    Std.mtof(base2 + 3) => saw.freq;
    Std.mtof(base) => tri.freq;
    startDur/2 => now;
    Std.mtof(base + 5) => tri.freq;
    startDur/2 => now;
    Std.mtof(base2 + 2) => saw.freq;
    Std.mtof(base + 3) => tri.freq;
    startDur/2 => now;
    Std.mtof(base + 2) => tri.freq;
    startDur/2 => now;
}

for (0 => int i; i < 4; 1 +=> i){
    0.8 => tri.gain;
    Std.mtof(base) => tri.freq;
    startDur => now;
    Std.mtof(base + 5) => tri.freq;
    startDur => now;
    Std.mtof(base + 3) => tri.freq;
    startDur => now;
    Std.mtof(base + 2) => tri.freq;
    startDur => now;
}

startDur * 1 => now;

.8 => tri.gain;
for (0 => int i; i < 4; 1 +=> i){
    Std.mtof(base) => tri.freq;
    startDur/8 => now;
    Std.mtof(base + 5) => tri.freq;
    startDur/8 => now;
    Std.mtof(base) => tri.freq;
    startDur/8 => now;
    Std.mtof(base+2) => tri.freq;
    startDur/8 => now;
}