<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac      ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o octave.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

; Required settings for WebAudio:

sr = 48000
ksmps = 128
nchnls = 2
nchnls_i = 1

; sr = 44100
; ksmps = 32
; nchnls = 2
0dbfs  = 1
alwayson 11011

zakinit 4, 4

 opcode myBass, a, k
kcps xin
aenv1 expsegr db(-96), 0.024, 1, 1.95, db(-45), .025, db(-96)
aenv2 expsegr 1, .036, db(-36), p3-.016, db(-36), .025, db(-96)
aopC vco2 3.79, kcps*2, 0, 0, 0
aopC *= aenv2
aopD oscil 3*aenv2, kcps*2*semitone(-.2)
aopE oscil db(2), kcps*(1+aopD)*(1+aopC)
ares oscil 1, kcps*(1+aopE)
ares *= aenv1
xout ares
 endop

 opcode myStep, kk, kiiiii
kunit, iseqt, iseq, ist, ien, i1 xin
ktrig seqtime kunit, ist, ien, i1, iseqt
k1 init 1
trigseq ktrig, ist, ien, i1, iseq, k1
xout k1, ktrig
 endop

instr 1
kcps zkr 0
kpower zkr 1
printk 1, kpower, 20
ares myBass kcps/2
ares chebyshevpoly ares, 0, 1, kpower, kpower^.95, kpower^.90 , kpower^.87, kpower^.86, kpower^.88, kpower^.90
ares *= db(-49)
     outs ares, ares
endin

instr 11011
kunit = .5
iseq ftgentmp 0,0,4,-2, 1, semitone:i(-2), .75, semitone:i(-2)
iseqt ftgentmp 0,0,4,-2,0,1,1,1
k1, kxx myStep kunit, iseqt, iseq, 0, 4, 0
ziw 98, 0
zkw 98*k1, 0
endin

instr 11010
iseqt ftgentmp 0,0,8,-2,0,0.5,1,0.5,.75,.75,0.5
ktrig seqtime .5, 0, 7, 0, iseqt
schedkwhen ktrig, 0, 1000, 1, 0, .25
ziw 1, 1
zkw linseg:k(1,p3/2,6,p3/2,1), 1
endin

</CsInstruments>
<CsScore>

t 0 120

i 11010 0 64

e

</CsScore>
</CsoundSynthesizer>
