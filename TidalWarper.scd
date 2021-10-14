(
~dirt.soundLibrary.addSynth(\warper, (play:
	{|dirtEvent|
		~dirt.server.makeBundle(dirtEvent.event[\latency], {
			// ~samplePlay.postln;
			var buf = ~dirt.buffers[~samplePlay][1];
			Synth(\warp, [
				\buf, buf,
				\timeEnv, ~timeEnv,
				\poinEnv, ~pointEnv,
				\freqEnv, ~freqEnv,
				\amp, ~gain
			];)
			// "ciao".postln;
		})

}));
)


(
SynthDef(\warp, { |buf=0, pointEnv=#[0,1,0], timeEnv=#[1,1], freqEnv=#[1,1], windowSize=0.1, pan=0.5, amp=0.2, out=0|

	var sig, pointer, freqScale, volume;

	pointer = EnvGen.ar(Env(pointEnv, timeEnv), doneAction:2);
	freqScale = EnvGen.ar(Env(freqEnv, timeEnv));

	volume = EnvGen.ar(Env([0,1,1,0], [0.01, timeEnv.sum - 0.03,0.01])); // avoid clicks

	sig = Warp1.ar(
		2,
		buf,
		pointer,
		freqScale,
		windowSize
	);
	sig = sig * amp * 0.1;
	OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;
);


/*in tidal

d1 $ slow 4
$ pS "samplePlay" "sk [vho, vfx]"
# s "warper"
# pF "timeEnv" "[1,1,4]"
# pF "pointEnv" "[0, 1, 0.5, 0.2]"
# pF "freqEnv" "[1,2,0.1]"*/

