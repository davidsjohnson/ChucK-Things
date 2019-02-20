[37.5, 75, 150, 300, 600, 900, 1200, 1500, 1800,
 37.5, 75, 150, 300, 600, 900, 1200, 1500, 1800,
 37.5, 75, 150, 300, 600, 900, 1200,       1800,
           150, 300,      900, 1200
] @=> float targets[];

float initials[30];
3.0::second => dur CHAOS_HOLD_TIME;
5.5::second => dur CONVERGENCE_TIME;
3.5::second => dur TARGET_HOLD_TIME;
2.0::second => dur DECAY_TIME;

SawOsc saws[30];
Gain gainL[30];
Gain gainR[30];
NRev reverbL => dac.left;
NRev reverbR => dac.right;
0.075 => reverbL.mix => reverbR.mix;

for (0 => int i; i < 30; i++){
    saws[i] => gainL => reverbL;
    saws[i] => gainR => reverbR;
    Math.random2f(0.0, 1.0) * .25 => gainL[i].gain;
    (1.0 - gainL[i].gain()) * .25 => gainR[i].gain;
    <<<gainL[i].gain(), gainR[i].gain()>>>;
    0.1 => saws[i].gain;    
    Math.random2f(160, 360) => initials[i] => saws[i].freq;
}

//initial stage
now + CHAOS_HOLD_TIME => time end;
while (now < end){
    1 - (end-now) / CHAOS_HOLD_TIME => float progress;
    for (0 => int i; i < 30; i++){
        0.1 * Math.pow(progress, 3) => saws[i].gain;
    }
    10::ms => now;
}

//convergence stage
now + CONVERGENCE_TIME => end;
while (now < end){
    1 - (end-now) / CONVERGENCE_TIME => float progress;
    for (0 => int i; i < 30; i++){
        initials[i] + (targets[i] - initials[i]) * progress => saws[i].freq;
    }
    10::ms => now;
}

// resolution
TARGET_HOLD_TIME => now;

now + DECAY_TIME => end;
while (now < end){
    (end-now) / DECAY_TIME => float progress;
    for (0 => int i; i < 30; i++){
        0.1 * progress => saws[i].gain;
    }
    10::ms => now;
}