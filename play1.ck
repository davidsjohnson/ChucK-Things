// David Johnson
// Just for Play 1
// Jan 1, 2018

// Variable Waves
// TriOsc tri;
// SawOsc saw;
// SqrOsc sqr;

// Post Control Path
TriOsc tri => LPF f => DelayL r => r => dac;
SawOsc saw => f;
SqrOsc sqr => f;

.7 => tri.gain;
.5 => saw.gain;
.6 => sqr.gain;

1::second => r.max;
.4 => r.gain;
1000::ms => r.delay;

220 => f.freq;

//Define Scale and base
57 => int base;
[0, 2, 3, 5, 7, 8, 10, 12] @=> int scale[];

20::second + now => time later;
now => time start;
while(now < later){
    
    Math.random2(0, 7) => int j;
    for (0 => int i; i < 4; 1 + i => i){
       scale[(Math.random2(0, 2) + j) % 7] + base => int note;
       Std.mtof(note) => tri.freq;
       Std.mtof(12*2 + note + 3) => saw.freq;
       Std.mtof(note + 5) => sqr.freq;
       .15::second => now;
    }
    .15::second => now;
}
0 => tri.gain => saw.gain => sqr.gain;

30::second - (now - start) => now;