// Audio Input

// Setup Delay Lines
// ###################

// sound network
adc => Gain g => dac;               // 
adc => DelayL d => Gain dgain => dac;
d => Gain fback => d;

// Initial Settings
5::second => d.max;     // Max Delay will be 5 seconds 
0::ms => d.delay;       // start with no delay
0.0 => fback.gain;      // and no feedback


// Setup Events for Incoming Data
//###############################

class SliderEvent extends Event{
    int id;
    float value;
}

class GridEvent extends Event{
    int id;
    float x;
    float y;
    float z;
}


GridEvent chGridEvent;
SliderEvent fbackSlider;
SliderEvent dgainSlider;
SliderEvent delaySlider;


// Setup OSC and OSC functions/shreds for 
// parsing incoming messages
// ######################################

// Start receiver
OscIn oin;
OscMsg msg;
10101 => oin.port;

"/grid3d/values" => string chGridAddress => oin.addAddress;
"/fback/slider/value" => string fbackAddress => oin.addAddress;
"/dgain/slider/value" => string dgainAddress => oin.addAddress;
"/delay/slider/value" => string delayAddress => oin.addAddress;

// Parse OSC Events and Broadcast 
// corresponding event
fun void waitForOSC(){
    while (true){
        oin => now;
        while(oin.recv(msg)){
            if (msg.address == chGridAddress){
                msg.getInt(0) => chGridEvent.id;
                msg.getFloat(1) => chGridEvent.x;
                msg.getFloat(2) => chGridEvent.y;
                msg.getFloat(3) => chGridEvent.z;
                chGridEvent.broadcast();
            }
            else if (msg.address == fbackAddress){
                msg.getInt(0) => fbackSlider.id;
                msg.getFloat(1) => fbackSlider.value;
                fbackSlider.broadcast();
            }
            else if (msg.address == dgainAddress){
                msg.getInt(0) => dgainSlider.id;
                msg.getFloat(1) => dgainSlider.value;
                dgainSlider.broadcast();
            }
            else if (msg.address == delayAddress){
                msg.getInt(0) => delaySlider.id;
                msg.getFloat(1) => delaySlider.value;
                delaySlider.broadcast();
            }
        }
    }
}
spork ~ waitForOSC();

fun void updateDelayGrid(){
    while(true){
        chGridEvent => now;
        <<<"Grid Event">>>;
        <<<chGridEvent.x>>>;
        <<<chGridEvent.y>>>;
        <<<chGridEvent.z>>>;
        chGridEvent.x => fback.gain;
        chGridEvent.y => dgain.gain;
        chGridEvent.z::ms => d.delay;
    }
}
spork ~ updateDelayGrid();

fun void updateFeedback(){
    while(true){
        fbackSlider => now;
        fbackSlider.value => fback.gain;
    }
}
spork ~ updateFeedback();

fun void updateDelayGain(){
    while(true){
        dgainSlider => now;
        dgainSlider.value => dgain.gain;
    }
}
spork ~ updateDelayGain();

fun void updateDelay(){
    while(true){
        delaySlider => now;
        delaySlider.value::ms => d.delay;
    }
}
spork ~ updateDelay();

// Run the Thing
// #############

while( true )
{
    // advance time
    100::ms => now;
}