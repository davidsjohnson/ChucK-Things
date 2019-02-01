SinOsc s => Envelope e => GVerb g => dac;

3000::ms => g.revtime;
100 => g.roomsize;
.5 => g.damping;
.5 => g.gain;

while (true){
    e.keyOn();
    1::second => now;
    e.keyOff();
    2::second => now;
}