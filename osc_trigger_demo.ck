class TriggerState{
    0 => int ENTER;
    1 => int HOVER;
    2 => int SELECTED;
    3 => int EXIT;
}
TriggerState TriggerStateEnum;

class TriggerEvent extends Event{
    int id;
    int state;
    string name;
}
TriggerEvent te;

// Setup OSC and OSC functions/shreds for 
// parsing incoming messages
// ######################################

// Start receiver
OscIn oin;
OscMsg msg;
10105 => oin.port;

// Registered OSC Addresses
"/pointer/trigger/enter" => string trigEnterAddress => oin.addAddress;
"/pointer/trigger/hover" => string trigHoverAddress => oin.addAddress;
"/pointer/trigger/selected" => string trigSelectedAddress => oin.addAddress;
"/pointer/trigger/exit" => string trigExitAddress => oin.addAddress;

// Parse OSC Events and Broadcast 
// corresponding event
fun void waitForOSC(){
    while (true){
        oin => now;
        while(oin.recv(msg)){
            if (msg.address == trigEnterAddress){
                msg.getInt(0) => te.id;
                msg.getString(1) => te.name;
                TriggerStateEnum.ENTER => te.state;
                te.broadcast();
            }
            else if (msg.address == trigSelectedAddress){
                 msg.getInt(0) => te.id;
                msg.getString(1) => te.name;
                TriggerStateEnum.SELECTED => te.state;
                te.broadcast();
            }
            else if (msg.address == trigExitAddress){
                msg.getInt(0) => te.id;
                msg.getString(1) => te.name;
                TriggerStateEnum.EXIT => te.state;
                te.broadcast();
            }
        }
    }
}
spork ~ waitForOSC();


// Setup Up Audio Playback
SndBuf buffy => Envelope e => dac;
e => DelayL d => dac;
d => Gain fback => d;

0 => fback.gain;

3::second => d.max;
250::ms => d.delay;
0 => d.gain;

me.dir() + "audio/"=> string basefolder;

while (true){
    te => now;
    if (te.state == TriggerStateEnum.ENTER){
        e.keyOff();
        <<<"Trigger Entered">>>;
        basefolder + te.name => buffy.read;
        0 => buffy.pos;
        e.keyOn();
    }
    else if (te.state == TriggerStateEnum.SELECTED){
        <<<"Trigger Selected">>>;
        
    }
    else if (te.state == TriggerStateEnum.EXIT){ 
        <<<"Trigger Exit">>>;
    }
        
}