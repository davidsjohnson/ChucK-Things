Noise n => Gain g => dac;
SinOsc s => g;
.2 => g.gain;
now + 5::second => time later;

while (true)
{
    Math.random2(30, 1000) => s.freq;
    .25::second => now;
}