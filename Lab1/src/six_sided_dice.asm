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
; config word(s)
;--------------------------------------------------------
	__config 0x0
;--------------------------------------------------------
; external declarations
;--------------------------------------------------------
	extern	__modsint
	extern	_TRISIO
	extern	_GPIO
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
;7 compiler assigned registers:
;   r0x1007
;   r0x1008
;   r0x1009
;   STK02
;   STK01
;   STK00
;   r0x100A
;; Starting pCode block
S_six_sided_dice__main	code
_main:
; 2 exit points
;	.line	27; "six_sided_dice.c"	TRISIO = 0b00100000;  // Set GP5 as input
	MOVLW	0x20
	BANKSEL	_TRISIO
	MOVWF	_TRISIO
;	.line	28; "six_sided_dice.c"	GPIO = 0x00;
	BANKSEL	_GPIO
	CLRF	_GPIO
_00160_DS_:
;	.line	33; "six_sided_dice.c"	if (GP5) {
	BANKSEL	_GPIObits
	BTFSS	_GPIObits,5
	GOTO	_00160_DS_
;	.line	35; "six_sided_dice.c"	unsigned char numLeds = (lfsrGenerate() % 6) + 1;
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
	MOVWF	r0x1009
	MOVWF	r0x1007
;	.line	38; "six_sided_dice.c"	unsigned char temp = 0;
	CLRF	r0x1008
;;100	MOVF	r0x1007,W
;;1	CLRF	r0x100A
;	.line	40; "six_sided_dice.c"	if (numLeds % 2){
	BTFSS	r0x1009,0
	GOTO	_00147_DS_
;	.line	41; "six_sided_dice.c"	temp |= (0b00001);
	MOVLW	0x01
	MOVWF	r0x1008
;;swapping arguments (AOP_TYPEs 1/2)
;;unsigned compare: left >= lit(0x2=2), size=1
_00147_DS_:
;	.line	43; "six_sided_dice.c"	if (numLeds > 1){
	MOVLW	0x02
;	.line	44; "six_sided_dice.c"	temp |= (0b00010);
	BANKSEL	r0x1007
	SUBWF	r0x1007,W
;	.line	46; "six_sided_dice.c"	if (numLeds > 3){
	BTFSC	STATUS,0
	BSF	r0x1008,1
	MOVLW	0x04
;	.line	47; "six_sided_dice.c"	temp |= (0b10000);
	SUBWF	r0x1007,W
;	.line	49; "six_sided_dice.c"	if (numLeds == 6){
	BTFSC	STATUS,0
	BSF	r0x1008,4
	MOVF	r0x1007,W
	XORLW	0x06
	BTFSS	STATUS,2
	GOTO	_00153_DS_
;	.line	50; "six_sided_dice.c"	temp |= (0b00101);
	MOVLW	0x05
	IORWF	r0x1008,F
_00153_DS_:
;	.line	53; "six_sided_dice.c"	GPIO = temp;
	BANKSEL	r0x1008
	MOVF	r0x1008,W
	BANKSEL	_GPIO
	MOVWF	_GPIO
;	.line	55; "six_sided_dice.c"	delay(TIME);
	MOVLW	0x64
	MOVWF	STK00
	MOVLW	0x00
	PAGESEL	_delay
	CALL	_delay
	PAGESEL	$
_00154_DS_:
;	.line	57; "six_sided_dice.c"	while (GP5);
	BANKSEL	_GPIObits
	BTFSC	_GPIObits,5
	GOTO	_00154_DS_
;	.line	60; "six_sided_dice.c"	GPIO = 0x00;
	CLRF	_GPIO
	GOTO	_00160_DS_
;	.line	63; "six_sided_dice.c"	}
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
;	.line	17; "six_sided_dice.c"	if (lfsr & 0x01) {
	BANKSEL	_lfsr
	MOVF	_lfsr,W
	BANKSEL	r0x1001
	MOVWF	r0x1001
	BTFSS	r0x1001,0
	GOTO	_00140_DS_
;;shiftRight_Left2ResultLit:5474: shCount=1, size=1, sign=0, same=0, offr=0
;	.line	18; "six_sided_dice.c"	lfsr = (lfsr >> 1) ^ LFSR_XOR;  // XOR feedback polynomial
	BCF	STATUS,0
	BANKSEL	_lfsr
	RRF	_lfsr,W
	BANKSEL	r0x1001
	MOVWF	r0x1001
	MOVWF	r0x1002
;;1	CLRF	r0x1003
	MOVLW	0xb8
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
;	.line	20; "six_sided_dice.c"	lfsr >>= 1;
	BCF	STATUS,0
	BANKSEL	_lfsr
	RRF	_lfsr,F
_00141_DS_:
;	.line	22; "six_sided_dice.c"	return lfsr;
	BANKSEL	_lfsr
	MOVF	_lfsr,W
;	.line	23; "six_sided_dice.c"	}
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
;	.line	11; "six_sided_dice.c"	void delay (unsigned int time){
	BANKSEL	r0x1001
	MOVWF	r0x1001
	MOVF	STK00,W
	MOVWF	r0x1002
;	.line	12; "six_sided_dice.c"	for(unsigned int i= 0; i < time; i++)
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
;;genSkipc:3307: created from rifx:0x7fff495c46b0
;	.line	13; "six_sided_dice.c"	for(unsigned int j= 0; j < 1000; j++);
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
;;genSkipc:3307: created from rifx:0x7fff495c46b0
	BANKSEL	r0x1005
	INCF	r0x1005,F
	BTFSC	STATUS,2
	INCF	r0x1006,F
	GOTO	_00108_DS_
_00112_DS_:
;	.line	12; "six_sided_dice.c"	for(unsigned int i= 0; i < time; i++)
	BANKSEL	r0x1003
	INCF	r0x1003,F
	BTFSC	STATUS,2
	INCF	r0x1004,F
	GOTO	_00111_DS_
_00113_DS_:
;	.line	14; "six_sided_dice.c"	}
	RETURN	
; exit point of _delay


;	code size estimation:
;	  104+   29 =   133 instructions (  324 byte)

	end
