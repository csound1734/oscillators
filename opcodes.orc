
 opcode printftab, i, i
ift xin
ilen = ftlen(ift)
icount = 0
loop:
if icount<ilen then
printf_i "\n%d: %f ", 1, icount, table:i(icount, ift, 0)
icount += 1
igoto loop
endif
xout 0
 endop

 #ifdef CALCULATE_VCO2INIT_TABLES
ginextfree vco2init 16, $CALCULATE_VCO2INIT_TABLES, -1, 2048, 16384, -1 ;triangle
ginextfree vco2init 8, ginextfree, -1, 2048, 16384, -1 ;square
ginextfree vco2init 4, ginextfree, -1, 2048, 16384, -1 ;pulse
ginextfree vco2init 2, ginextfree, -1, 2048, 16384, -1 ;integ saw
ginextfree vco2init 1, ginextfree, -1, 2048, 16384, -1 ;saw
#end

  opcode "Oscil_1pl", a, aaii
 aamp, acps, ift, iphs xin ;in this opcode, aamp is relative to 1
 aamp = abs(aamp)%1
 ares oscil aamp, acps, ift, iphs
 ares += 1
  xout ares
  endop

 opcode "Phasor_1pl", a, ai
acps, iphs xin ;in this opcode, aamp is relative to 1
ares phasor acps, iphs
ares += 1
xout ares
 endop

 opcode "semitSin", a, aao 
asemitamount, acpsmod, iphs xin
alfo poscil3 asemitamount, acpsmod, -1, iphs
alfo = semitone(alfo)
xout alfo
 endop

 opcode "molybdenite", a, aaPOPopp
aamp, acps, klfocps, klfodc, klfoscl, iftcos, iharmonics, ilowh xin
if (iftcos==0) then
          iftcos ftgenonce 0,0,16384,11,1
endif
inumh = int((sr/2)/p5)*iharmonics
kmul oscil klfoscl, klfocps
kmul = klfodc+.5+kmul*.5
ares gbuzz aamp, acps, inumh, ilowh, kmul, iftcos
 xout ares
 endop

 opcode "amethyst", a, kkkijoo
kamp, kcps, kdetune, ivx, iphs, ioct, iskipinit xin
if iphs<0 then
     iphs random 0, 1
endif
ioct = int(ivx%ioct)
kcps__ = kcps*semitone(kdetune)
ares vco2 kamp, kcps__*(2^ioct), -iskipinit, 0, iphs
if ivx>1 then 
anext amethyst kamp, kcps__, kdetune, ivx-1
endif
ares += anext
 xout ares
 endop

 opcode "brookite", a, ikkkPPo ;granulize a single segment of a source table
ifsrc, kcps, kstart, kstop, ktransp, kgrsizem, ifwdw xin ;accepts only (pow-of-2) size tables
if ifwdw==0 then
     ifwdw ftgenonce 0,0,16384,-20,5
endif
istart = i(kstart)
kgrsize divz (kstop-kstart)*kgrsizem, ktransp, 1000
ares1 syncloop 1, kcps, ktransp, kgrsize, 0, kstart, kstop, ifsrc, ifwdw, 1000, istart
xout ares1
 endop

 opcode "brucite", a, ikkOOOO
irisf ftgenonce 0,0,16384,-19,.5,.5,270,.5
igdur, kamp, kcps, kformant, kspread, koct, kband xin ;3 arguments required, 3 optional
kformant = kcps*semitone:k(kformant) ;input kformant in units of semitones
kband = 0 ;bandwidth setting for FOF,usually zero
klfo phasor 1
klfo= (klfo > .5 ? (1-klfo):klfo) ;make triangle
kband += klfo*.25 ;bit of octave warble
irist = igdur/7 ;rise time
klfogrpitch lfo kspread, kcps*.5, 2 ;bisq
kformant *= semitone:k(klfogrpitch)
ares fof kamp, kcps, kformant, koct, kband, irist, igdur, irist, 1000, -1, irisf, p3
 xout ares
 endop

 opcode "gibbsite", a, aaaaaaakkOVVOPPPPJJJJJooo
;                                                                                                                 default=0.5                  default=0            default=1             default=1              default=-1              default=-1          default=0             default=0
;                                                                                                    default=0                     default=0.5           default=1             default=1             default=-1              default=-1              default=-1            default=0          
agrainfreq, async, awavfm, asamplepos1, asamplepos2, asamplepos3, asamplepos4, kwavfreq,  kduration, krandommask, ksustain_amount, ka_d_ratio, kenv2amt, kwavekey1, kwavekey2, kwavekey3, kwavekey4, kwaveform1, kwaveform2, kwaveform3, kwaveform4, kfmenv, ienv_attack, ienv_decay, ienv2tab xin
asig	partikkel agrainfreq, 0, -1, async, kenv2amt, ienv2tab, \
               ienv_attack, ienv_decay, ksustain_amount, ka_d_ratio, kduration, 1, -1, \
               kwavfreq, 0, -1, -1, awavfm, \
               -1, kfmenv, -1, 0, 0, \
               0, -1, krandommask, kwaveform1, kwaveform2, kwaveform3, kwaveform4, \
               -1, asamplepos1, asamplepos2, asamplepos3, asamplepos4, \
               kwavekey1, kwavekey2, kwavekey3, kwavekey4, 256
xout asig
 endop
 
 opcode "glauberite", a, aaakkOVVOPPPPJooojo
agrainfreq, async, awavfm, kwavfreq, kduration, krandommask, ksustain_amount, ka_d_ratio, kenv2amt, kwavekey1, kwavekey2, kwavekey3, kwavekey4, kfmenv, ienv_attack, ienv_decay, ienv2tab, isin, iphs xin
asig gibbsite agrainfreq, async, awavfm, a(iphs), a(iphs), a(iphs), a(iphs), kwavfreq, kduration, krandommask, ksustain_amount, ka_d_ratio, kenv2amt, kwavekey1, kwavekey2, kwavekey3, kwavekey4, k(isin), k(isin), k(isin), k(isin), kfmenv, ienv_attack, ienv_decay, ienv2tab 
xout asig
 endop

 opcode "overite", a, aaaajoo ;optional wavetable input
aamp, acps, acpsmod, asemitamount, iwf, iphs, istor xin
amod semitSin asemitamount, acpsmod
ares oscilikt aamp, acps*amod, iwf, iphs, istor
 xout ares
 endop
 
 
 opcode "orpiment", a, aaaakoo ;optional wavetable input
aamp, acps, acpsmod, asemitamount, kpw, iftcos, iphs xin
if (iftcos==0) then
          iftcos ftgenonce 0,0,16384,11,1
endif

amod semitSin asemitamount, acpsmod
kcps downsamp acps
ares gbuzz aamp, acps*amod, int(.5*sr/kcps)-16, 2, 2*abs:k(.5-limit:k(kpw,0,1)), iftcos 
 xout ares
 endop

  opcode "realgar", a, aaaaiVVPPPPP
 acenterf, aamp, acps, afilterbw, inumlayers, kalpha, kbeta, kWht, kGau, kPnk, kBrn, kBet xin
 aRwht unirand 1
 aRgau gauss 1
 aRpnk fractalnoise 1, 1
 aRbrn fractalnoise 1, 2
 aRbet betarand 1, kalpha, kbeta
 aRsum sum aRwht, aRgau, aRpnk, aRbrn, aRbet
 aRsum *= db(-5.75*int((kWht+kGau+kPnk+kBrn+kBet)/2))
 ares resonx aRsum, acenterf, afilterbw, 16, 1
 ares *= aamp
  xout ares
  endop
   
 opcode "lapislazuli", a, ikV
inumlayers, kbasefreq, kresonance xin
agauss gauss 1
kbw = kbasefreq*(1/32)*kresonance
ares resony agauss, kbasefreq, kbw, inumlayers, inumlayers, 1, 1
xout ares
 endop
 
 opcode "larimar", a, ikPV
inumlayers, kbasefreq, kresonance, koctsep xin
agauss gauss 1
kbw = kbasefreq*(1/32)*kresonance
ares resony agauss, kbasefreq, kbw, inumlayers, inumlayers*koctsep, 0, 1
xout ares
 endop
 
 opcode "quartz", a, ko
kcps, ifn xin 
ares pluck 1, kcps, 16383, ifn, 1
xout ares
 endop

 opcode "tantalite", a, akkkko
ain, kcps, kphasertrnsp, knum, kdbfeedback, iatktime xin
ares phaser1 ain, kcps*semitone:k(kphasertrnsp), knum, db(kdbfeedback)
aenv expseg 0.0001, iatktime, 1, 100000, 1
ares *= aenv
xout ares
 endop

 opcode "alforsite", aaaaaaaa, kakkikkkkaaaaPPPPOPo
kamp, agrainfreq, kwavfreq, kduration, ienv2tab, kwaveform1, kwaveform2, kwaveform3, kwaveform4, asamplepos1, asamplepos2, asamplepos3, asamplepos4, kwavekey1, kwavekey2, kwavekey3, kwavekey4, krandommask, ixtratim, iopcode_id xin
xtratim ixtratim
kflag release
if (kflag==0) then
agrainfreq = 0
endif 
irandft ftgentmp 0,0,32,-21,1,7 ;random values between 0 and 7
tablew 0, 0, irandft, 0 ;write to table with raw index
tablew 31, 1, irandft, 0 ;write to table with raw index
ichannelmasks = irandft
iwaveamptab = -1 ; default: even mix of all 4 waveforms and no trainlets
iwavfreqstarttab = -1
iwavfreqendtab = -1
awavfm init 1
ifmamptab = -1
kfmenv = -1
ienv_attack = -1 ;default rise shape
ienv_decay = -1 ;default release shape
ksustain_amount init 1 ;no attack/decay except env2
ka_d_ratio init .5 ;insignificant
igainmasks = -1 ;default: no gain masking
idisttab = -1
kdistribution init 0
async init 0
ksweepshape = 0
kenv2amt = 1 ;full windowing
imax_grains = 1000
a1 , a2, a3, a4, a5, a6, a7, a8 partikkel agrainfreq, \
              kdistribution, idisttab, async, kenv2amt, ienv2tab, ienv_attack, \
              ienv_decay, ksustain_amount, ka_d_ratio, kduration, kamp, igainmasks, \
              kwavfreq, ksweepshape, iwavfreqstarttab, iwavfreqendtab, awavfm, \
              ifmamptab, kfmenv, -1,0,0, 0, \;constants here pertain to trainlets
              ichannelmasks, krandommask, kwaveform1, kwaveform2, kwaveform3, \
              kwaveform4, iwaveamptab, asamplepos1, asamplepos2, asamplepos3, \
              asamplepos4, kwavekey1, kwavekey2, kwavekey3, kwavekey4, imax_grains, \
              iopcode_id
xout a1, a2, a3, a4, a5, a6, a7, a8
 endop

 opcode "phenakite", a, kkakakkOjOp
ienv_attack ftgentmp 0,0,4096,-7,0,4096,1 ;attack
ienv_decay ftgentmp 0,0,4096,-5,1,4096,.000000001 ;decay
kreverse, kwavfreq, agrainfreq, kwavekey, asamplepos, kwaveform, kduration, kdistribution, idisttab, krandommask, ixtratim xin
;xtratim ixtratim
;kflag release
;if (kflag==0) then
;agrainfreq = 0
;endif 
irandft ftgentmp 0,0,2,-2,-1,1
krnd1 rnd31 1, 0, 0
koff = .5+(kreverse*.5+.5)
krnd2 table krnd1*.49+koff, irandft, 0, 0, 0
printk .05, krnd2
kwavfreq *= krnd2
async		= 0			; no sync input
kenv2amt	= 0			; no secondary enveloping
ienv2tab	= -1			; default secondary envelope (flat)
ienv_attack	= -1;ftgentmp 0,0,256,-7,0,256,1 ;			; default attack envelope (flat)
ienv_decay	ftgentmp 0,0,256,-7,1,256,0 ; default decay envelope (flat)
ksustain_amount	= .95			; time (in fraction of grain dur) at sustain level for each grain
ka_d_ratio	= .9995 			; balance between attack and decay time
;kduration	= (0.5/kgrainfreq)*1000	; set grain duration relative to grain rate
kamp		= .125 			; amp
igainmasks	= -1			; (default) no gain masking
ksweepshape	= 0			; shape of frequency sweep (0=no sweep)
iwavfreqstarttab = -1			; default frequency sweep start (value in table = 1, which give no frequency modification)
iwavfreqendtab	= -1			; default frequency sweep end (value in table = 1, which give no frequency modification)
awavfm = 0
ifmamptab	= -1			; default FM scaling (=1)
kfmenv		= -1			; default FM envelope (flat)
icosine		= -1		; cosine ftable
kTrainCps	= 0
knumpartials	= 0			; number of partials in trainlet
kchroma		= 0			; balance of partials in trainlet
ichannelmasks	= -1			; (default) no channel masking, all grains to output 1
;krandommask	= 0			; no random grain masking
iwaveamptab	= -1			; (default) equal mix of all 4 sourcve waveforms and no amp for trainlets
imax_grains	= 1000			; max grains per k period

a1	partikkel agrainfreq, kdistribution, idisttab, async, kenv2amt, ienv2tab, \
               ienv_attack, ienv_decay, ksustain_amount, ka_d_ratio, kduration, kamp, igainmasks, \
               kwavfreq, ksweepshape, iwavfreqstarttab, iwavfreqendtab, awavfm, \
               ifmamptab, kfmenv, icosine, kTrainCps, knumpartials, \
               kchroma, ichannelmasks, krandommask, kwaveform, kwaveform, kwaveform, kwaveform, \
               iwaveamptab, asamplepos, asamplepos, asamplepos, asamplepos, \
               kwavekey, kwavekey, kwavekey, kwavekey, imax_grains
 xout a1
 endop

 
 opcode psykick1, a, iiioj
icps_start, icps_end, isweep, ishape, isin xin
af1 expon icps_start, isweep, icps_end
af1 pdhalfy af1, ishape, 0, icps_start
ares oscili 1, af1, isin
xout ares
 endop
 
 opcode psybass1, a, iipoo 
icps,icos,imul,icurve,itime xin 
itime = ( itime==0 ? p3 : itime)
kmel transeg  .99, p3,icurve, .8^imul
ares gbuzz .95, icps, int((1/3)*.5*sr/icps), 1.995, kmel, 67
xout ares
 endop

 opcode "gaussHat", a, 0
aenv expon 1, .08, .125
ares gauss 1
aresd diff ares
aresd balance aresd, ares
aresd *= aenv
xout aresd
 endop
 
 
 
