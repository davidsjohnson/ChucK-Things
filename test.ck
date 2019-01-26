SinOsc s => Chorus ch => dac;
440 => s.freq;

3 => ch.modDepth;  // 0-5
.5 => ch.mix;      // 0-1
1 => ch.modFreq;   // 0-100


while (true){
    1::second => now;
}