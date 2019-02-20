// Event Class to handle input from the OSC-XR OscSlider object
public class OscSliderEvent extends Event{
    int id;
    float val;
}

// Psuedo-Enum for the 3 pad states
public class OscPadState{
    0 => int PRESSED;
    1 => int HOLD;
    2 => int RELEASED;
}
OscPadState OscPadStateEnum;

// Event Class to handle input from the OSC-XR OscPad object
public class OscPadEvent extends Event{
    int id;
    float vel;
    float pos;
    int state;
}

// Psuedo-Enum for the 4 trigger states
public class OscTrigState{
    0 => int ENTER;
    1 => int HOVER;
    2 => int SELECTED;
    3 => int EXIT;
}
OscTrigState OscTrigStateEnum;

// Event Class to handle input from the OSC-XR OscTrigger object
public class OscTrigEvent extends Event{
    int id;
    int state;
}

// Event Class to handle input from the OSC-XR objects that send X Y Z data
// (Can be used data such as position, scale and rotation)
public class OscXYZEvent extends Event{
    int id;
    float x;
    float y;
    float z;
}