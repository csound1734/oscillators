<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 100
nchnls = 1
0dbfs = 1
#include "opcodes.orc"
instr 100
icps = 1/(ftlen(40)/sr)
;icps *= -1 ;make it go backwards
a1 phenakite k(p4), k(1), a(icps), k(icps*3), a(0), k(40), (1/3)*1*1000*ftlen(40)/sr, 0, -1, 0
;1 table3 line:a(0,1,sr), 40, 0
out a1*db(-82)
endin
instr 200 ;print;
;ires printftab p4
endin
</CsInstruments>
<CsScore>
f 0 2
f 1 0 16384 10 1
f 3 0 16384 -7 -1 16384 1
f 20 0 16384 -20 1 1 
f 30 0 16384 11 30 1 .86
f 40 0 [2^17] 1 "impact1.wav" 0 0 1
i 100 0 16 1
{64 x
;i 200 [.05*$x+1] 0 101
}
i 100 16 8 -1
i 200 17 0
i 100 24 8 .5
i 200 25 1
i 100 32 8 -.5
i 200 33 0
i 100 40 8 0
i 200 40 0
</CsScore>
</CsoundSynthesizer>

