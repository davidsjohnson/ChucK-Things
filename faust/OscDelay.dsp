
declare name    "smoothDelay";
declare author  "Yann Orlarey";
declare copyright "Grame";
declare version "1.0";
declare license "STK-4.3";

declare options "[osc:on]";

//--------------------------process----------------------------
//
//  A stereo smooth delay with a feedback control
//  
//  This example shows how to use sdelay, a delay that doesn't
//  click and doesn't transpose when the delay time is changed
//-------------------------------------------------------------

import("stdfaust.lib");

process = _ <: _,_, par(i, 2, voice)
    with 
    { 
        voice   = (+ : de.sdelay(N, interp, dtime)) ~ *(fback);
        N       = int(2^19); 
        interp  = hslider("interpolation[unit:ms][style:knob][osc:/interp/slider/1]",10,1,100,0.1)*ma.SR/1000.0; 
        dtime   = hslider("delay[unit:ms][style:knob][osc:/dtime/slider/1]", 0, 0, 5000, 0.1)*ma.SR/1000.0;
        fback   = hslider("feedback[style:knob][osc:/fback/slider/1]",0,0,100,0.1)/100.0; 
    } :> _,_;

