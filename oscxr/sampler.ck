// Initial Sampler Setup 
//######################

// Samples to use
["../audio/stereo_fx_03.wav",
 "../audio/stereo_fx_05.wav",
 "../audio/click_05.wav",
 "../audio/snare_01.wav",
 "../audio/hihat_04.wav",
 "../audio/snare_03.wav",
 "../audio/hihat_02.wav",
 "../audio/kick_02.wav",
 "../audio/kick_04.wav"
 ] @=> string files[];

// Intials Sound Buffers
files.cap() => int numSamples;
SndBuf samples[numSamples];

// Initial Sound Chain
Gain g => LPF lpf => dac;

2000 => lpf.freq;

// Load files and connect to dac
for (0 => int i; i < numSamples; 1 +=> i){
    me.dir() + files[i] => samples[i].read;
    samples[i].samples() => samples[i].pos;

    samples[i] => g;
}

// Setup Events for Button Pressess
//################################

// Button Press Event for storing data
// parsed from OSC Messages
class ButtonPressEvent extends Event{
    int id;
    float velocity;
}
ButtonPressEvent bp;

class SliderEvent extends Event{
    int id;
    float value;
}
SliderEvent rateEvent;

class GridEvent extends Event{
    int id;
    float x;
    float y;
    float z;
}
GridEvent chGridEvent;

// Setup OSC and OSC functions/shreds for 
// parsing incoming messages
// ######################################

// Start receiver
OscIn oin;
OscMsg msg;
10103 => oin.port;

// Registered OSC Addresses
"/pad/pressed" => string pressedAddress => oin.addAddress;
"/slider/value" => string rateAddress => oin.addAddress;
"/grid3d/values" => string chGridAddress => oin.addAddress;

// Parse OSC Events and Broadcast 
// corresponding event
fun void waitForOSC(){
    while (true){
        oin => now;
        while(oin.recv(msg)){
            if (msg.address == pressedAddress){
                msg.getInt(0) => bp.id;
                msg.getFloat(1) => bp.velocity;
                bp.broadcast();
            }
            else if (msg.address == rateAddress){
                msg.getInt(0) => rateEvent.id;
                msg.getFloat(1) => rateEvent.value;
                rateEvent.broadcast();
            }
            else if (msg.address == chGridAddress){
                msg.getInt(0) => chGridEvent.id;
                msg.getFloat(1) => chGridEvent.x;
                msg.getFloat(2) => chGridEvent.y;
                msg.getFloat(3) => chGridEvent.z;
                chGridEvent.broadcast();
            }
        }
    }
}
spork ~ waitForOSC();

// Change Sample Rate based on slider event
fun void updateSampleRate(){
    while(true){
        rateEvent => now;
        rateEvent.value => samples[rateEvent.id].rate;
    }
}
spork ~ updateSampleRate();

//fun void updateModGridPos(){
    //while(true){
    //    chGridEvent => now;
    //    chGridEvent.x => ch.modFreq;
    //    chGridEvent.y => ch.mix;
   //     chGridEvent.z => ch.modDepth;
  //  }
//}
//spork ~ updateModGridPos();
        

// While loop waiting for Button Presses 
// (which are triggered via OSC)
while (true){
    bp => now;
    clamp(bp.velocity * 1.5, 0, 1) => samples[bp.id].gain;
    0 => samples[bp.id].pos;
}

fun float clamp(float val, float a, float b){
    return Math.max(Math.min(val, b), a);
}