// Audio Input

// Setup Delay Lines
// ###################

// sound network
adc => Gain g => dac;               // 
adc => Gain dgain => DelayL d => dac;
d => Gain fback => d;

// Initial Settings
5::second => d.max;     // Max Delay will be 5 seconds 
0::ms => d.delay;       // start with no delay
0.0 => fback.gain;      // and no feedback


// Setup Events for Incoing Data
//##############################
class SliderEvent extends Event{
    int id;
    float value;
}
SliderEvent se;git 

// Setup OSC and OSC functions/shreds for 
// parsing incoming messages
// ######################################

// Start receiver
OscIn oin;
OscMsg msg;
10101 => oin.port;

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


// Run the Thing
// #############

while( true )
{
    // advance time
    100::ms => now;
}