Gain g => ADSR e => DelayL d => NRev r => dac;
d => Gain fback => d;

.8 => fback.gain;
250 => float noteLen;

2500::ms => d.max;
100::ms => d.delay;
noteLen::ms * .75 => e.attackTime;

.1 => r.mix;

TriOsc tri => g;
SqrOsc sqr => LPF lpfSqr => g;
SawOsc saw => LPF lpfSaw => g;

200 => lpfSaw.freq;
800 => lpfSqr.freq;

0.3 => tri.gain;
0.2 => sqr.gain;
0.2 => saw.gain;

0.35 => g.gain;

24 => int base;
[0, 2, 4, 7, 9] @=> int pentScale[];


/// OSC
// Start receiver
OscIn oin;
OscMsg msg;
10101 => oin.port;

"/slider" => string sliderAddress => oin.addAddress;

fun void waitForOSC(){
    while (true){
        oin => now;
        while(oin.recv(msg)){
            if (msg.address == sliderAddress){
                msg.getFloat(0) => noteLen;
                <<<noteLen>>>;
                //noteLen::ms / 2 => d.delay;
                noteLen::ms * .75 => e.attackTime;
            }
        }
    }
}
spork ~ waitForOSC();

0 => int stepCounter;

SndBuf kicky => Envelope kickEnv => dac;
me.dir() + "/audio/kick_04.wav" => kicky.read;
kicky.samples() => kicky.pos;
.25 => kicky.rate;
.25 => kicky.gain;

SndBuf hatty => Echo ec => dac;
.5 => ec.mix;
100::ms => ec.delay;
me.dir() + "/audio/hihat_03.wav" => hatty.read;
hatty.samples() => hatty.pos;
.1 => hatty.rate;
.1 => hatty.gain;

SndBuf snare => dac;
me.dir() + "/audio/hihat_02.wav" => snare.read;
snare.samples() => snare.pos;
2.5 => snare.rate;
.01 => snare.gain;

while (true){
    
    if (stepCounter == 0 || stepCounter == 2){
        0=>kicky.pos;
        kickEnv.keyOn();
    }
    
    if (stepCounter == 2){
        0=>hatty.pos;
    }
    
    if (stepCounter == 2 || stepCounter == Math.random2(6,7)){
        0=>snare.pos;
    }
    
   base + pentScale[Math.random2(0, pentScale.cap() - 1)] => int midiTri => Std.mtof => tri.freq;
   midiTri + 2 + (12 * Math.random2(4, 5)) => int midiSqr => Std.mtof => sqr.freq;
   midiTri + 9 + (12 * Math.random2(0, 2)) => int midiSaw => Std.mtof => saw.freq;
   e.keyOn();
   Math.random2f(noteLen/10, noteLen)::ms => dur onDur => now;
   e.keyOff();
   kickEnv.keyOff();
   noteLen::ms - onDur => dur newDur;
   if ( newDur < 0::ms ) 0::ms => newDur;
   newDur => now;
   stepCounter++;
   8 %=> stepCounter;
}