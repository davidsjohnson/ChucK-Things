// Audio Input

// Setup Delay Lines
// ###################

// sound network
adc => HPF hpf => LPF lpf => Gain g => dac;
lpf => DelayL d => dac;
d => Gain fback => d;

// Initial Settings
1000 => hpf.freq;
1000 => lpf.freq;

3000::ms => d.max;
50::ms => d.delay;
0.0 => fback.gain;
0.5 => d.gain;

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
"/delay/slider/value" => string delAddress => oin.addAddress;
"/fback/slider/value" => string fbackAddress => oin.addAddress;
"/dgain/slider/value" => string dgainAddress => oin.addAddress;


// Parse OSC Events and Broadcast 
// corresponding event


fun void updateGrid(){
    while(true){
        chGridEvent => now;
        <<<"Grid Event">>>;
        <<<chGridEvent.x>>>;
        <<<chGridEvent.y>>>;
        <<<chGridEvent.z>>>;
        chGridEvent.x => lpf.freq;
        chGridEvent.z => hpf.freq;
    }
}
spork ~ updateGrid();


fun void UpdateDelaySlider(){
    while(true){
        delaySlider => now;
        delaySlider.value::ms => d.delay;
    }
}
spork ~ UpdateDelaySlider();


fun void UpdateFbackSlider(){
    while(true){
        fbackSlider => now;
        fbackSlider.value => fback.gain;
    }
}
spork ~ UpdateFbackSlider();


fun void UpdateDgainSlider(){
    while(true){
        dgainSlider => now;
        dgainSlider.value => d.gain;
    }
}
spork ~ UpdateDgainSlider();

// Run the Thing
// #############
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
        else if (msg.address == delAddress){
            <<<"here1">>>;
            msg.getInt(0) => delaySlider.id;
            msg.getFloat(1) => delaySlider.value;
            delaySlider.broadcast();
        }
        else if (msg.address == fbackAddress){
             <<<"here2">>>;
            msg.getInt(0) => fbackSlider.id;
            msg.getFloat(1) => fbackSlider.value;
            fbackSlider.broadcast();
        }
        else if (msg.address == dgainAddress){
             <<<"here3">>>;
            msg.getInt(0) => dgainSlider.id;
            msg.getFloat(1) => dgainSlider.value;
            dgainSlider.broadcast();
        }
    }
}