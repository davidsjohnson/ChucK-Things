public class Wind{

    Noise i => BiQuad bf => Gain g => ResonZ z => JCRev r =>  HPF hpf => ResonZ z2 => dac;
    SawOsc osc => LPF lpf => Gain g2 => r;
}