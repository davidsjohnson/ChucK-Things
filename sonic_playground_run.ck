
//Initialize BPM
BPM bpm;
120 => bpm.tempo;

Machine.add(me.dir() + "sonic_playground_cube.ck") => int cube;

// Setup OSC and OSC functions/shreds for 
// parsing incoming messages
// ######################################

// Start receiver
OscIn oin;
OscMsg msg;
10101 => oin.port;

// Setup BPM OSC
OscSliderEvent bpmEvent;
"/bpmslider/value" => string bpmAddress => oin.addAddress;

fun void WaitForTempo(){
    while(true){
        bpmEvent => now;
        bpmEvent.val => bpm.tempo;
    }
}
spork ~ WaitForTempo();

while(true){
    oin => now;
    while(oin.recv(msg)){
        if (msg.address == bpmAddress){
            msg.getInt(0) => bpmEvent.id;
            msg.getFloat(1) => bpmEvent.val;
            bpmEvent.broadcast();
        }
    }
}