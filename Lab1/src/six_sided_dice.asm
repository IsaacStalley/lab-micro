;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
; PIC port for the 14-bit core
;--------------------------------------------------------
;	.file	"six_sided_dice.c"
	list	p=12f683
	radix dec
	include "p12f683.inc"
;--------------------------------------------------------
; external declarations
;--------------------------------------------------------
	extern	__modsint
	extern	_TRISIO
	extern	_GPIObits
	extern	__sdcc_gsinit_startup
;--------------------------------------------------------
; global declarations
;--------------------------------------------------------
	global	_main
	global	_lfsrGenerate
	global	_delay
	global	_lfsr

	global PSAVE
	global SSAVE
	global WSAVE
	global STK12
	global STK11
	global STK10
	global STK09
	global STK08
	global STK07
	global STK06
	global STK05
	global STK04
	global STK03
	global STK02
	global STK01
	global STK00

sharebank udata_ovr 0x0070
PSAVE	res 1
SSAVE	res 1
WSAVE	res 1
STK12	res 1
STK11	res 1
STK10	res 1
STK09	res 1
STK08	res 1
STK07	res 1
STK06	res 1
STK05	res 1
STK04	res 1
STK03	res 1
STK02	res 1
STK01	res 1
STK00	res 1

;--------------------------------------------------------
; global definitions
;--------------------------------------------------------
;--------------------------------------------------------
; absolute symbol definitions
;--------------------------------------------------------
;--------------------------------------------------------
; compiler-defined variables
;--------------------------------------------------------
UDL_six_sided_dice_0	udata
r0x1002	res	1
r0x1001	res	1
r0x1003	res	1
r0x1004	res	1
r0x1005	res	1
r0x1006	res	1
r0x1007	res	1
r0x1008	res	1
r0x1009	res	1
;--------------------------------------------------------
; initialized data
;--------------------------------------------------------

IDD_six_sided_dice_0	idata
_lfsr
	db	0x55	; 85	'U'

;--------------------------------------------------------
; initialized absolute data
;--------------------------------------------------------
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
;	udata_ovr
;--------------------------------------------------------
; reset vector 
;--------------------------------------------------------
STARTUP	code 0x0000
	nop
	pagesel __sdcc_gsinit_startup
	goto	__sdcc_gsinit_startup
;--------------------------------------------------------
; code
;--------------------------------------------------------
code_six_sided_dice	code
;***
;  pBlock Stats: dbName = M
;***
;has an exit
;functions called:
;   _lfsrGenerate
;   __modsint
;   _delay
;   _lfsrGenerate
;   __modsint
;   _delay
;6 compiler assigned registers:
;   r0x1007
;   r0x1008
;   r0x1009
;   STK02
;   STK01
;   STK00
;; Starting pCode block
S_six_sided_dice__main	code
_main:
; 2 exit points
;	.line	24; "six_sided_dice.c"	TRISIO = 0b00100000;  // Set GP5 as input
	MOVLW	0x20
	BANKSEL	_TRISIO
	MOVWF	_TRISIO
_00160_DS_:
;	.line	29; "six_sided_dice.c"	if (GP5) {
	BANKSEL	_GPIObits
	BTFSS	_GPIObits,5
	GOTO	_00160_DS_
;	.line	31; "six_sided_dice.c"	unsigned char numLeds = (lfsrGenerate() % 6) + 1;
	PAGESEL	_lfsrGenerate
	CALL	_lfsrGenerate
	PAGESEL	$
	BANKSEL	r0x1007
	MOVWF	r0x1007
	MOVWF	r0x1008
	CLRF	r0x1009
	MOVLW	0x06
	MOVWF	STK02
	MOVLW	0x00
	MOVWF	STK01
	MOVF	r0x1008,W
	MOVWF	STK00
	MOVLW	0x00
	PAGESEL	__modsint
	CALL	__modsint
	PAGESEL	$
	BANKSEL	r0x1008
	MOVWF	r0x1008
	MOVF	STK00,W
	MOVWF	r0x1007
	MOVWF	r0x1009
	INCF	r0x1009,W
;	.line	33; "six_sided_dice.c"	if (numLeds % 2 != 0){
	MOVWF	r0x1007
	MOVWF	r0x1008
	CLRF	r0x1009
	BTFSS	r0x1008,0
	GOTO	_00149_DS_
;	.line	34; "six_sided_dice.c"	if (numLeds == 6){
	MOVF	r0x1007,W
;	.line	35; "six_sided_dice.c"	GP2 = 0x01;
	XORLW	0x06
;	.line	37; "six_sided_dice.c"	GP0 = 0x01;
	BTFSS	STATUS,2
	GOTO	_00001_DS_
	BANKSEL	_GPIObits
	BSF	_GPIObits,2
_00001_DS_:
	BANKSEL	_GPIObits
	BSF	_GPIObits,0
_00149_DS_:
;	.line	39; "six_sided_dice.c"	if (numLeds > 1){
	MOVLW	0x02
;	.line	40; "six_sided_dice.c"	GP1 = 0x01;
	BANKSEL	r0x1007
	SUBWF	r0x1007,W
;	.line	42; "six_sided_dice.c"	if (numLeds > 3){
	BTFSS	STATUS,0
	GOTO	_00002_DS_
	BANKSEL	_GPIObits
	BSF	_GPIObits,1
_00002_DS_:
	MOVLW	0x04
;	.line	43; "six_sided_dice.c"	GP4 = 0x01;
	BANKSEL	r0x1007
	SUBWF	r0x1007,W
;	.line	46; "six_sided_dice.c"	delay(TIME);
	BTFSS	STATUS,0
	GOTO	_00003_DS_
	BANKSEL	_GPIObits
	BSF	_GPIObits,4
_00003_DS_:
	MOVLW	0x64
	MOVWF	STK00
	MOVLW	0x00
	PAGESEL	_delay
	CALL	_delay
	PAGESEL	$
_00154_DS_:
;	.line	48; "six_sided_dice.c"	while (GP5);
	BANKSEL	_GPIObits
	BTFSC	_GPIObits,5
	GOTO	_00154_DS_
;	.line	51; "six_sided_dice.c"	GP0 = 0x00;
	BCF	_GPIObits,0
;	.line	52; "six_sided_dice.c"	GP1 = 0x00;
	BCF	_GPIObits,1
;	.line	53; "six_sided_dice.c"	GP2 = 0x00;
	BCF	_GPIObits,2
;	.line	54; "six_sided_dice.c"	GP3 = 0x00;
	BCF	_GPIObits,3
	GOTO	_00160_DS_
;	.line	57; "six_sided_dice.c"	}
	RETURN	
; exit point of _main

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;4 compiler assigned registers:
;   r0x1001
;   r0x1002
;   r0x1003
;   r0x1004
;; Starting pCode block
S_six_sided_dice__lfsrGenerate	code
_lfsrGenerate:
; 2 exit points
;	.line	14; "six_sided_dice.c"	if (lfsr & 0x01) {
	BANKSEL	_lfsr
	MOVF	_lfsr,W
	BANKSEL	r0x1001
	MOVWF	r0x1001
	BTFSS	r0x1001,0
	GOTO	_00140_DS_
;;shiftRight_Left2ResultLit:5474: shCount=1, size=1, sign=0, same=0, offr=0
;	.line	15; "six_sided_dice.c"	lfsr = (lfsr >> 1) ^ 0x91;  // XOR feedback polynomial
	BCF	STATUS,0
	BANKSEL	_lfsr
	RRF	_lfsr,W
	BANKSEL	r0x1001
	MOVWF	r0x1001
	MOVWF	r0x1002
;;1	CLRF	r0x1003
	MOVLW	0x91
	XORWF	r0x1002,W
	BANKSEL	_lfsr
	MOVWF	_lfsr
	BANKSEL	r0x1001
	MOVWF	r0x1001
	MOVLW	0x00
;;1	MOVWF	r0x1004
;;99	MOVF	r0x1001,W
	GOTO	_00141_DS_
;;shiftRight_Left2ResultLit:5474: shCount=1, size=1, sign=0, same=1, offr=0
_00140_DS_:
;	.line	17; "six_sided_dice.c"	lfsr >>= 1;
	BCF	STATUS,0
	BANKSEL	_lfsr
	RRF	_lfsr,F
_00141_DS_:
;	.line	19; "six_sided_dice.c"	return lfsr;
	BANKSEL	_lfsr
	MOVF	_lfsr,W
;	.line	20; "six_sided_dice.c"	}
	RETURN	
; exit point of _lfsrGenerate

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;7 compiler assigned registers:
;   r0x1001
;   STK00
;   r0x1002
;   r0x1003
;   r0x1004
;   r0x1005
;   r0x1006
;; Starting pCode block
S_six_sided_dice__delay	code
_delay:
; 2 exit points
;	.line	8; "six_sided_dice.c"	void delay (unsigned int time){
	BANKSEL	r0x1001
	MOVWF	r0x1001
	MOVF	STK00,W
	MOVWF	r0x1002
;	.line	9; "six_sided_dice.c"	for(unsigned int i= 0; i < time; i++)
	CLRF	r0x1003
	CLRF	r0x1004
_00111_DS_:
	BANKSEL	r0x1001
	MOVF	r0x1001,W
	SUBWF	r0x1004,W
	BTFSS	STATUS,2
	GOTO	_00133_DS_
	MOVF	r0x1002,W
	SUBWF	r0x1003,W
_00133_DS_:
	BTFSC	STATUS,0
	GOTO	_00113_DS_
;;genSkipc:3307: created from rifx:0x7ffe4131fba0
;	.line	10; "six_sided_dice.c"	for(unsigned int j= 0; j < 1000; j++);
	BANKSEL	r0x1005
	CLRF	r0x1005
	CLRF	r0x1006
;;unsigned compare: left < lit(0x3E8=1000), size=2
_00108_DS_:
	MOVLW	0x03
	BANKSEL	r0x1006
	SUBWF	r0x1006,W
	BTFSS	STATUS,2
	GOTO	_00134_DS_
	MOVLW	0xe8
	SUBWF	r0x1005,W
_00134_DS_:
	BTFSC	STATUS,0
	GOTO	_00112_DS_
;;genSkipc:3307: created from rifx:0x7ffe4131fba0
	BANKSEL	r0x1005
	INCF	r0x1005,F
	BTFSC	STATUS,2
	INCF	r0x1006,F
	GOTO	_00108_DS_
_00112_DS_:
;	.line	9; "six_sided_dice.c"	for(unsigned int i= 0; i < time; i++)
	BANKSEL	r0x1003
	INCF	r0x1003,F
	BTFSC	STATUS,2
	INCF	r0x1004,F
	GOTO	_00111_DS_
_00113_DS_:
;	.line	11; "six_sided_dice.c"	}
	RETURN	
; exit point of _delay


;	code size estimation:
;	  104+   31 =   135 instructions (  332 byte)

	end
