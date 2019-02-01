public class SonicCube{
    
    Impulse i => ResonZ fz => BiQuad f => JCRev r2 => DelayL d;
    d => Gain fback => d;
    
    //5000::ms => r.revtime;
    .5 => r2.mix;
    125::ms => d.max => d.delay;
    .75 => d.gain;
    .50 => fback.gain;
    
    440.0 => f.pfreq;
    .99 => f.prad;
    1 => f.eqzs;
    440.0 => fz.freq;
    100 => fz.Q;
    
    .75 => float myGain;
    
    fun void next(){
        20 * myGain => i.next;
    }
    
    fun void freq(float freq){
        freq => f.pfreq;
        freq =>  fz.freq;
    }
    
    fun void freq(int note){
        note => Std.mtof => f.pfreq => fz.freq;
    }
    
    fun void set_fback(float val){
        val => fback.gain;
    }
    
    fun void gain(float g){
        g => myGain;
    }
    
    fun void Q(float value){
        value => fz.Q;
    }
    
    fun void connect(UGen ugen){
        d => ugen;
        f => ugen;
    }
}