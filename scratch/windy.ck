Noise i => BiQuad bf => Gain g => ResonZ z => JCRev r =>  HPF hpf => ResonZ z2 => dac;
SawOsc osc => LPF lpf => Gain g2 => r;

.99 => bf.prad;
.05 => bf.gain;
1 => bf.eqzs;

0.9 => r.mix;
0.05 => g.gain;
0.0 => g2.gain;

660.0 => lpf.freq;
200.0 => hpf.freq;

1000 => z.freq;
2 => z.Q;

500 => z2.freq;
.5 => z2.Q;

[ 0, 2, 4, 7, 9 ] @=> int scale[];

0.0 => float t;

while(true){

    100.0 + Std.fabs(Math.sin(t)) * 1500.0 => bf.pfreq;
    t + .05 => t;

    scale[ Math.random2(0,4) ] => float freq;
    Std.mtof( 36 + (Math.random2(0,3)*12 + freq) ) => osc.freq;
    0.25::second => now;
}