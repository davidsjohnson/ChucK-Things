SndBuf buffy => dac;

me.dir() + "audio/genres/blues/blues.00000.au" => buffy.read;
buffy.samples() => buffy.pos;

1::second => now;
0 => buffy.pos;
45::second => now;