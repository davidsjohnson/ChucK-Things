public class BPM{
    
    dur durations[4];
    static dur quarterNote, eighthNote, sixteenthNote, thirtysecondNote;
    
    fun void tempo(float beat){
        60.0/beat => float spb;
        spb::second => quarterNote;
        quarterNote * 0.5 => eighthNote;
        eighthNote * 0.5 => sixteenthNote;
        sixteenthNote * 0.5 => thirtysecondNote;
        
        [quarterNote, eighthNote, sixteenthNote, thirtysecondNote] @=> durations;
    }
}