Windy w;

w.connect(dac);

OscRecv recv;
10101 => recv.port;
recv.listen();

recv.event("/slider/1, f") @=> OscEvent oscSlider1;
fun void oscSlider1Shred(OscEvent event)
{
    while(true){
        event => now;
        while (event.nextMsg() != 0)
        {
            float f;
            event.getFloat() => f => w.rmix;
        }
    }
}

recv.event("/slider/2, f") @=> OscEvent oscSlider2;
fun void oscSlider2Shred(OscEvent event)
{
    while(true){
        event => now;
        while (event.nextMsg() != 0)
        {
            float f;
            event.getFloat() => f => w.noiseLevel;
        }
    }
}

// create osc shreads
spork ~ oscSlider1Shred(oscSlider1);
spork ~ oscSlider1Shred(oscSlider2);

// process sound
0.0 => float t;
while(true){

        100.0 + Std.fabs(Math.sin(t)) * 1500.0 => w.bffreq;
        t + .05 => t;
        .25::second => now;
}