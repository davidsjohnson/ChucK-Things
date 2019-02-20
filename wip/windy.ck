public class Windy{

    Noise i => BiQuad bf => Gain g => ResonZ z => JCRev r =>  HPF hpf => ResonZ z2;

    0.99 => bf.prad;
    0.05 => bf.gain;
    1 => bf.eqzs;

    0.2 => g.gain;

    0.9 => r.mix;
    0.7 => i.gain;

    200 => hpf.freq;
    
    1000 => z.freq;
    2 => z.Q;

    500 => z2.freq;
    .5 => z2.Q;

    public void bfrad(float rad){
        rad => bf.prad;
    }

    public void bfgain(float gain){
        gain => bf.gain;
    }

    public void bffreq(float freq){
        freq => bf.pfreq;
    }

    public void rmix(float mix){
        mix => r.mix;
    }

    public void noiseLevel(float level){
        level => i.gain;
    }

    public void hpfreq(float freq){
        freq => hpf.freq;
    }

    public void zfreq(float freq){
        freq => z.freq;
    }

    public void zQ(float Q){
        Q => z.Q;
    }

    public void z2freq(float freq){
        freq => z2.freq;
    }

    public void z2Q(float Q){
        Q => z2.Q;
    }

    public void connect(UGen ugen){
        z2 => ugen;
    }

}