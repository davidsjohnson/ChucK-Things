adc => JCRev r => HPF hpf => Gain master => dac;
.6 => master.gain;
.03 => r.mix;

MAUI_Slider slider;
"param" => slider.name;
slider.display();
slider.range( 220, 1000);


while(true){
    slider.value() => hpf.freq;
    33.3::ms => now;
}