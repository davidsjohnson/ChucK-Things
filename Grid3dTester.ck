Gain master => dac;
TriOsc triX => master;
TriOsc triZ => master;

.25 => triX.gain => triZ.gain;

0 => triX.freq;
0 => triZ.freq;

class OscXYZEvent extends Event{
    int id;
    float x;
    float y;
    float z;
}

OscXYZEvent gridEvent;

OscIn oin;
10101 => oin.port;
OscMsg msg;

"/grid3d/values" => string gridAddres => oin.addAddress;

fun void WaitForGrid(){
    while(true){
        gridEvent => now;
        gridEvent.x => triX.freq;
        gridEvent.y => master.gain;
        gridEvent.z => triZ.freq;
        
        <<<triX.freq(), triZ.freq(), master.gain()>>>;
    }
}
spork ~ WaitForGrid();

while (true){
    oin => now;
    while(oin.recv(msg)){
        if (msg.address == gridAddres){
            msg.getInt(0) => gridEvent.id;
            msg.getFloat(1) => gridEvent.x;
            msg.getFloat(2) => gridEvent.y;
            msg.getFloat(3) => gridEvent.z;
            gridEvent.broadcast();
        }
    }
}