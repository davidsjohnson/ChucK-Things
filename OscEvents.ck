// Event Class to handle input from the OSC-XR OscSlider object
class OscSliderEvent extends Event{
    int id;
    float val;
}

// Psuedo-Enum for the 3 pad states
class OscPadState{
    0 => PRESSED;
    1 => HOLD;
    2 => RELEASED;
}
OscPadState OscPadStateEnum;

// Event Class to handle input from the OSC-XR OscPad object
class OscPadEvent extends Event{
    int id;
    float vel;
    float pos;
    int state;
}

// Psuedo-Enum for the 4 trigger states
class OscTrigState{
    0 => ENTER;
    1 => HOVER;
    2 => SELECTED;
    3 => EXIT;
}
OscTrigState OscTrigStateEnum;

// Event Class to handle input from the OSC-XR OscTrigger object
class OscTrigEvent extends Event{
    int id;
    int state;
}

// Event Class to handle input from the OSC-XR objects that send X Y Z data
// (Can be used data such as position, scale and rotation)
class OscXYZEvent extends Event{
    int id;
    float x;
    float y;
    float z;
}