TriOsc tri => Gain g => ADSR e => DelayL d;
e => DelayL d2;

2500::ms => d.max;
100::ms => d.delay;

100 => float noteLen;

0.10 => g.gain;

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
                noteLen::ms / 2 => d.delay;
            }
        }
    }
}
spork ~ waitForOSC();


while (true){
    e.keyOn();
    500::second => now;
    e.keyOff();
}