// David Johnson
// Bell Patch
// Jan 18, 2019

// Sound Network
TubeBell b => BPF f => NRev r => Gain g => dac;
5 => b.lfoSpeed;
.1 => b.lfoDepth;
13 => f.Q;

.3 => r.mix;

5 => g.gain;

48 => int base;
[ 0, 2, 4, 7, 9 ] @=> int scale[];

4::second => now;

while(true){

    scale[ Math.random2(0,4) ] => float freq;
    Std.mtof( base + freq ) => freq;
    <<<freq>>>;
    freq => b.freq => f.freq;

    b.noteOn(.75);
    2::second => now;
    b.noteOff(1);
    2::second => now;
}