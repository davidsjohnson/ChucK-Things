Dinky imp;

// Connect patch
Gain g => NRev r => Echo e => Echo e2 => dac;

//direct/dry
g => dac;
e => dac;

// delay, gain, mix
1500::ms => e.max => e.delay;
3500::ms => e2.max => e2.delay;
1 => g.gain;
.5 => e.gain;
.25 => e2.gain;
.1 => r.mix;

//Connect Dinky
imp.connect(g);
imp.radius(.999);

// Scale
[0, 2, 4, 7, 9, 11] @=> int hi[];

while(true){
    36 + Math.random2(0,3) * 12 + 
        hi[Math.random2(0, hi.cap()-1)] => imp.t;
    
    195::ms => now;
    imp.c();
    5::ms => now;
}