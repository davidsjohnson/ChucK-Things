// Initial Sampler Setup 
//######################

// Samples to use
["/audio/snare_01.wav", 
 "/audio/snare_03.wav",
 "/audio/click_05.wav",
 "/audio/kick_02.wav",
 "/audio/kick_05.wav",
 "/audio/hihat_02.wav",
 "/audio/hihat_04.wav",
 "/audio/stereo_fx_03.wav",
 "/audio/stereo_fx_05.wav"
 ] @=> string files[];

// Intials Sound Buffers
files.cap() => int numSamples;
SndBuf samples[numSamples];

// Initial Sound Chain with Reverb
JCRev r => dac;
0.2 => r.mix;

// Load files and connect to dac
for (0 => int i; i < numSamples; 1 +=> i){
    me.dir() + files[i] => samples[i].read;
    samples[i].samples() => samples[i].pos;

    samples[i] => r;
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
SliderEvent se;

// Setup OSC and OSC functions/shreds for 
// parsing incoming messages
// ######################################

// Start receiver
OscIn oin;
OscMsg msg;
10101 => oin.port;

"/buttonPressed" => string pressedAddress;
pressedAddress => oin.addAddress;

"/rateSlider" => string rateAddress;
rateAddress => oin.addAddress;

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
                msg.getInt(0) => se.id;
                msg.getFloat(1) => se.value;
                se.broadcast();
            }
        }
    }
}
spork ~ waitForOSC();

// Change Sample Rate based on slider event
fun void updateSampleRate(){
    while(true){
        se => now;
        se.value => samples[se.id].rate;
    }
}
spork ~ updateSampleRate();

// While loop waiting for Button Presses 
// (which are triggered via OSC)
while (true){
    bp => now;
    bp.velocity => samples[bp.id].gain;
    0 => samples[bp.id].pos;
}