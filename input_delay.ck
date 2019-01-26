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


// Setup Events for Incoming Data
//###############################å

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
10101 => oin.port;

"/grid3d/values" => string chGridAddress => oin.addAddress;


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


// Run the Thing
// #############

while( true )
{
    // advance time
    100::ms => now;
}