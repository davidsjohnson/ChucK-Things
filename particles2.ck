OscIn oin;
OscMsg msg;
10102 => oin.port;

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
TriOsc @ dinks[maxShreds];

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
            <<<"Stopping", id>>>;
            0 => running[id];
        }
    }
}
spork ~ KillParticle();

// Function to spork for individual particles
Gain g => dac;
fun void RunParticle(TriggerEvent event){
    //Setup Sound
    TriOsc dink => ADSR e => g;
    0.01 => e.gain;
    400::ms => e.releaseTime;
   
    dink @=> dinks[event.objID];
    mapClamp(event.x, -1, 1, 0, 9) $ int => int freqIdx;
    freqs[freqIdx] => float freq;
    mapClamp(event.z, -.6, .6, -freq/5.0, freq/5.0)  => float tuning;
    freq + tuning => dink.freq;
    
    e.keyOn();
    while (running[event.objID] == 1){
        1::ms => now;
    }
    <<<"closing">>>;
    e.keyOff();
    500::ms => now;
    e =< g;
}

fun void ModParticles(){
   
    while(true){
        triggerStayEvent => now;
        triggerStayEvent.objID => int objID;
        if (dinks[objID] != null){
            //mapClamp(triggerStayEvent.x, -1, 1, 0, 9) $ int => int freqIdx;
            dinks[objID].freq() => float freq;
            mapClamp(triggerStayEvent.z, -.6, .6, -freq/5.0, freq/5.0)  => float tuning;
            freq + tuning => dinks[objID].freq;
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
            1::ms => now;   // hack to deal with timing issues...(check to see if works on windows without this)
        }
        else if (msg.address == stayAddr){
            msg.getInt(0) => triggerStayEvent.id;
            msg.getInt(1) => triggerStayEvent.objID;
            msg.getFloat(2) => triggerStayEvent.x;
            msg.getFloat(3) => triggerStayEvent.y;
            msg.getFloat(4) => triggerStayEvent.z;
            triggerStayEvent.broadcast();
            1::ms => now;
        }
        else if (msg.address == exitAddr){
            msg.getInt(0) => triggerExitEvent.id;
            msg.getInt(1) => triggerExitEvent.objID;
            msg.getFloat(2) => triggerExitEvent.x;
            msg.getFloat(3) => triggerExitEvent.y;
            msg.getFloat(4) => triggerExitEvent.z;
            triggerExitEvent.broadcast();
            1::ms => now;
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