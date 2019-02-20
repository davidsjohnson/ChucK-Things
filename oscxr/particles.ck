OscIn oin;
OscMsg msg;
10101 => oin.port;

[36.7, 36.7, 73.4, 146.8, 293.7, 440.0, 587.3, 880.0, 1174.7, 1760.0] @=> float freqs[];

class TriggerEvent extends Event{
    int id;
    float x;
    float y;
    float z;
    int objID;
}
TriggerEvent triggerEnterEvent;
TriggerEvent triggerStayEvent;
TriggerEvent triggerExitEvent;

"/particleTrigger/enter" => string enterAddr => oin.addAddress;
"/particleTrigger/stay" => string stayAddr => oin.addAddress;
"/particleTrigger/exit" => string exitAddr => oin.addAddress;

// Setup Shred Mgmt
30 => int maxShreds;
int running[maxShreds];
Osc @ oscs[maxShreds];

fun void StartParticle(){
    while(true){
        triggerEnterEvent => now;
        triggerEnterEvent.objID => int id;
        if (id < maxShreds){
            1 => running[id];
            spork ~ RunParticle(triggerEnterEvent);
        }
    }
}
spork ~ StartParticle();

fun void KillParticle(){
    while(true){
        triggerExitEvent => now;
        triggerExitEvent.objID => int id;
        if (id < maxShreds){
            0 => running[id];
        }
    }
}
spork ~ KillParticle();

// Function to spork for individual particles
fun void RunParticle(TriggerEvent event){
    //Setup Sound
    TriOsc tri => ADSR e => dac;
    e => DelayL delay => e;
    delay => Gain fback => delay;

    500::ms => delay.max => delay.delay;
    1000::ms => e.releaseTime;
    .2 => fback.gain;
    
    tri @=> oscs[event.objID];
    mapClamp(event.x, -1, 1, 0, 9) $ int => int freqIdx;
    freqs[freqIdx] => tri.freq;
    
    .1 => tri.gain;
    e.keyOn();
    while (running[event.objID] == 1){
        100::ms => now;
    }
    e.keyOff();
    1000::ms => now;
    e =< dac;
    // delay =< dac;
}

fun void ModParticles(){
   
    while(true){
        triggerStayEvent => now;
        triggerStayEvent.objID => int objID;
        if (oscs[objID] != null){
            mapClamp(triggerStayEvent.y, -2, 2, -5, 5) => float freqInc;
            <<<"Inc Freq", objID, freqInc, oscs[objID].freq()>>>;
            (oscs[objID].freq() + freqInc ) => oscs[objID].freq;
        }
    }
}
spork ~ ModParticles();
 
// Handle OSC Messages
while (true){
    oin => now;
    while(oin.recv(msg)){
        if (msg.address == enterAddr){
            msg.getInt(0) => triggerEnterEvent.id;
            msg.getInt(1) => triggerEnterEvent.objID;
            msg.getFloat(2) => triggerEnterEvent.x;
            msg.getFloat(3) => triggerEnterEvent.y;
            msg.getFloat(4) => triggerEnterEvent.z;
            triggerEnterEvent.broadcast();
            .5::ms => now;   // hack to deal with timing issues...(check to see if works on windows without this)
        }
        else if (msg.address == stayAddr){
            msg.getInt(0) => triggerStayEvent.id;
            msg.getInt(1) => triggerStayEvent.objID;
            msg.getFloat(2) => triggerStayEvent.x;
            msg.getFloat(3) => triggerStayEvent.y;
            msg.getFloat(4) => triggerStayEvent.z;
            triggerStayEvent.broadcast();
            .5::ms => now;
        }
        else if (msg.address == exitAddr){
            msg.getInt(0) => triggerExitEvent.id;
            msg.getInt(1) => triggerExitEvent.objID;
            msg.getFloat(2) => triggerExitEvent.x;
            msg.getFloat(3) => triggerExitEvent.y;
            msg.getFloat(4) => triggerExitEvent.z;
            triggerExitEvent.broadcast();
            .5::ms => now;
        }
    }
}

fun float mapClamp(float value, float inMin, float inMax, float outMin, float outMax){
    outMin + (outMax - outMin) * ((value - inMin) / (inMax - inMin)) => float tmp;
    return clamp(tmp, outMin, outMax);
}

fun float clamp(float val, float a, float b){
    return Math.max(Math.min(val, b), a);
}