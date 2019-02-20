//--------------------------------------------------------------------
// name: shepard.ck
// desc: continuous shepard-risset tone generator; 
//       descending but can easily made to ascend
//
// author: Ge Wang (http://www.gewang.com/)
//   date: spring 2016
//--------------------------------------------------------------------

// mean for normal intensity curve
72 => float MU;
// standard deviation for normal intensity curve
42 => float SIGMA;
// normalize to 1.0 at x==MU
1 / gauss(MU, MU, SIGMA) => float SCALE;
// increment per unit time (use negative for descending)
.002 => float INC;
// unit time (change interval)
1::ms => dur T;

MAUI_Slider slider;
"param" => slider.name;
slider.display();
slider.range(-.2,  .2);

// starting pitches (in MIDI note numbers, octaves apart)
float pitches[10];
12 => int midiStart;
for (0 => int i; i < pitches.cap(); i++){
    midiStart + 7 * i => pitches[i];
}

// number of tones
pitches.size() => int N;
// bank of tones
TriOsc tones[N];
// overall gain
Gain gain => NRev r => LPF lpf => dac; 1.0/N => gain.gain;
1000 => lpf.freq; 
// connect to dac
for( int i; i < N; i++ ) { tones[i] => gain; }


fun void sliderInput(){
    while(true){
        slider =>now;
        slider.value() => INC;
    }
}
spork ~ sliderInput();

// infinite time loop
while( true )
{
    for( int i; i < N; i++ )
    {
        // set frequency from pitch
        pitches[i] => Std.mtof => tones[i].freq;
        // compute loundess for each tone
        gauss( pitches[i], MU, SIGMA ) * SCALE => float intensity;
        // map intensity to amplitude
        intensity*96 => Math.dbtorms => tones[i].gain;
        // increment pitch
        INC +=> pitches[i];
        // wrap (for positive INC)
        if( pitches[i] > 105 + midiStart ) midiStart => pitches[i];
        // wrap (for negative INC)
        if( pitches[i] < midiStart ) 105+midiStart => pitches[i];
    }
    
    // advance time
    T => now;
}

// normal function for loudness curve
// NOTE: chuck-1.3.5.3 and later: can use Math.gauss() instead
fun float gauss( float x, float mu, float sd )
{
    return (1 / (sd*Math.sqrt(2*pi))) 
    * Math.exp( -(x-mu)*(x-mu) / (2*sd*sd) );
}
