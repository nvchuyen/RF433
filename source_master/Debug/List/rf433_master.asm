
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _lcd=R5
	.DEF _rx_wr_index=R4
	.DEF _rx_rd_index=R7
	.DEF _rx_counter=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _twi_int_handler
	RJMP 0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0
_conv_delay_G103:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G103:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x4C,0x43,0x44,0x20,0x49,0x32,0x43,0x20
	.DB  0x49,0x4E,0x49,0x54,0x0,0x49,0x4E,0x54
	.DB  0x3A,0x20,0x0,0x42,0x75,0x66,0x66,0x31
	.DB  0x2D,0x62,0x75,0x66,0x66,0x32,0x3D,0x20
	.DB  0x25,0x78,0x20,0x2D,0x20,0x25,0x78,0x20
	.DB  0x20,0x2D,0x20,0x25,0x78,0x20,0x2D,0x20
	.DB  0x25,0x78,0x20,0x2D,0x20,0x25,0x78,0xD
	.DB  0xA,0x0,0x63,0x6C,0x65,0x61,0x72,0x20
	.DB  0x72,0x78,0x5F,0x77,0x72,0x5F,0x69,0x6E
	.DB  0x64,0x65,0x78,0x20,0x69,0x6E,0x74,0x65
	.DB  0x72,0x72,0x75,0x70,0x20,0xD,0xA,0x0
	.DB  0x20,0x52,0x46,0x34,0x33,0x33,0x0,0x68
	.DB  0x69,0x65,0x6E,0x20,0x74,0x68,0x69,0x20
	.DB  0x73,0x6F,0x20,0x61,0x20,0xD,0xA,0x0
	.DB  0x6E,0x68,0x69,0x65,0x74,0x64,0x6F,0x3A
	.DB  0x0,0x63,0x6C,0x65,0x61,0x72,0x20,0x72
	.DB  0x78,0x5F,0x77,0x72,0x5F,0x69,0x6E,0x64
	.DB  0x65,0x78,0x20,0x69,0x6E,0x20,0x77,0x68
	.DB  0x69,0x6C,0x65,0x20,0xD,0xA,0x20,0x0
_0x20000:
	.DB  0x49,0x32,0x43,0x20,0x49,0x4E,0x49,0x54
	.DB  0x20,0x4D,0x41,0x53,0x54,0x45,0x52,0x3A
	.DB  0x0,0x52,0x65,0x70,0x65,0x61,0x74,0x65
	.DB  0x64,0x20,0x53,0x74,0x61,0x72,0x74,0x20
	.DB  0x45,0x78,0x65,0x2E,0x0
_0x2000003:
	.DB  0x7
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0D
	.DW  _0x6
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x8
	.DW  _0x0*2+13

	.DW  0x07
	.DW  _0x10
	.DW  _0x0*2+88

	.DW  0x09
	.DW  _0x10+7
	.DW  _0x0*2+112

	.DW  0x11
	.DW  _0x20003
	.DW  _0x20000*2

	.DW  0x14
	.DW  _0x20017
	.DW  _0x20000*2+17

	.DW  0x01
	.DW  _twi_result
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 5/3/2022
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;#include "twi_i2c.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "twi_lcd.h"

	.CSEG
_PCF8574_write:
; .FSTART _PCF8574_write
	ST   -Y,R26
;	x -> Y+0
	RCALL _twi_start
	LDI  R26,LOW(78)
	RCALL _twi_write_cmd
	LD   R26,Y
	RCALL _twi_write_dwr
	RCALL _twi_stop
	RJMP _0x20E0001
; .FEND
_twi_lcd_4bit_send:
; .FSTART _twi_lcd_4bit_send
	ST   -Y,R26
	ST   -Y,R17
;	x -> Y+1
;	temp -> R17
	LDI  R17,0
	LDI  R30,LOW(15)
	AND  R5,R30
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	RCALL SUBOPT_0x0
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	SWAP R30
	ANDI R30,0xF0
	MOV  R17,R30
	LDI  R30,LOW(15)
	AND  R5,R30
	RCALL SUBOPT_0x0
	LDD  R17,Y+0
	RJMP _0x20E0006
; .FEND
_twi_lcd_cmd:
; .FSTART _twi_lcd_cmd
	ST   -Y,R26
;	x -> Y+0
	LDI  R30,LOW(8)
	MOV  R5,R30
	LDI  R30,LOW(254)
	AND  R5,R30
	RCALL SUBOPT_0x1
	RJMP _0x20E0001
; .FEND
_twi_lcd_dwr:
; .FSTART _twi_lcd_dwr
	ST   -Y,R26
;	x -> Y+0
	LDI  R30,LOW(9)
	OR   R5,R30
	RCALL SUBOPT_0x1
	RJMP _0x20E0001
; .FEND
_twi_lcd_msg:
; .FSTART _twi_lcd_msg
	RCALL SUBOPT_0x2
;	*c -> Y+0
_0x3:
	RCALL SUBOPT_0x3
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
	RCALL SUBOPT_0x4
	RCALL _twi_lcd_dwr
	RJMP _0x3
_0x5:
	RJMP _0x20E0006
; .FEND
;	c -> Y+6
;	num_integer -> R16,R17
;	tram -> R19
;	chuc -> R18
;	donvi -> R21
_twi_lcd_clear:
; .FSTART _twi_lcd_clear
	LDI  R26,LOW(1)
	RJMP _0x20E0008
; .FEND
_twi_lcd_init:
; .FSTART _twi_lcd_init
	LDI  R30,LOW(4)
	MOV  R5,R30
	MOV  R26,R5
	RCALL _PCF8574_write
	__DELAY_USB 67
	LDI  R26,LOW(3)
	RCALL _twi_lcd_cmd
	LDI  R26,LOW(3)
	RCALL _twi_lcd_cmd
	LDI  R26,LOW(3)
	RCALL _twi_lcd_cmd
	LDI  R26,LOW(2)
	RCALL _twi_lcd_cmd
	LDI  R26,LOW(40)
	RCALL _twi_lcd_cmd
	LDI  R26,LOW(15)
	RCALL _twi_lcd_cmd
	LDI  R26,LOW(1)
	RCALL _twi_lcd_cmd
	LDI  R26,LOW(6)
	RCALL _twi_lcd_cmd
	LDI  R26,LOW(128)
	RCALL _twi_lcd_cmd
	__POINTW2MN _0x6,0
	RCALL _twi_lcd_msg
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
	RCALL _twi_lcd_clear
	LDI  R26,LOW(128)
_0x20E0008:
	RCALL _twi_lcd_cmd
	RET
; .FEND

	.DSEG
_0x6:
	.BYTE 0xD
;#include <mega8.h>
;#include <stdio.h>
;// 1 Wire Bus interface functions
;#include <1wire.h>
;#include <interrupt.h>
;	flags -> R17

	.CSEG
;// DS1820 Temperature Sensor functions
;#include <ds18b20.h>
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 5//64
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 003E {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003F char status,data;
; 0000 0040 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0041 data=UDR;
	IN   R16,12
; 0000 0042     usart_msg("INT: ");
	__POINTW2MN _0x8,0
	RCALL _usart_msg
; 0000 0043 //    printf("Buff1-buff2= %x - %x  - %x - %x - %x\r\n", rx_buffer[0], rx_buffer[1],  rx_buffer[2],  rx_buffer[3], rx_bu ...
; 0000 0044 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x9
; 0000 0045    {
; 0000 0046    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0047    printf("Buff1-buff2= %x - %x  - %x - %x - %x\r\n", rx_buffer[0], rx_buffer[1],  rx_buffer[2],  rx_buffer[3], rx_buffe ...
	__POINTW1FN _0x0,19
	RCALL SUBOPT_0x5
	LDS  R30,_rx_buffer
	RCALL SUBOPT_0x6
	__GETB1MN _rx_buffer,1
	RCALL SUBOPT_0x6
	__GETB1MN _rx_buffer,2
	RCALL SUBOPT_0x6
	__GETB1MN _rx_buffer,3
	RCALL SUBOPT_0x6
	__GETB1MN _rx_buffer,4
	RCALL SUBOPT_0x6
	LDI  R24,20
	RCALL _printf
	ADIW R28,22
; 0000 0048 #if RX_BUFFER_SIZE == 256
; 0000 0049    // special case for receiver buffer size=256
; 0000 004A    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 004B #else
; 0000 004C    if (rx_wr_index == RX_BUFFER_SIZE){ rx_wr_index=0; printf("clear rx_wr_index interrup \r\n");}
	LDI  R30,LOW(5)
	CP   R30,R4
	BRNE _0xA
	CLR  R4
	__POINTW1FN _0x0,58
	RCALL SUBOPT_0x7
; 0000 004D    if (++rx_counter == RX_BUFFER_SIZE)
_0xA:
	INC  R6
	LDI  R30,LOW(5)
	CP   R30,R6
	BRNE _0xB
; 0000 004E       {
; 0000 004F       rx_counter=0;
	CLR  R6
; 0000 0050       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0051       }
; 0000 0052 #endif
; 0000 0053    }
_0xB:
; 0000 0054 }
_0x9:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x8:
	.BYTE 0x6
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 005B {

	.CSEG
; 0000 005C char data;
; 0000 005D while (rx_counter==0);
;	data -> R17
; 0000 005E data=rx_buffer[rx_rd_index++];
; 0000 005F #if RX_BUFFER_SIZE != 256
; 0000 0060 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0061 #endif
; 0000 0062 #asm("cli")
; 0000 0063 --rx_counter;
; 0000 0064 #asm("sei")
; 0000 0065 return data;
; 0000 0066 }
;#pragma used-
;#endif
;
;
;
;void main(void)
; 0000 006D {
_main:
; .FSTART _main
; 0000 006E   // Port C initialization
; 0000 006F // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0070 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0071 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0072 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0073 
; 0000 0074     twi_init();                                    //--- TWI Initialize
	RCALL _twi_init
; 0000 0075     twi_lcd_init();                                //--- TWI LCD Initialize
	RCALL _twi_lcd_init
; 0000 0076     twi_lcd_msg(" RF433");                        //--- Send a String to LCD
	__POINTW2MN _0x10,0
	RCALL _twi_lcd_msg
; 0000 0077     /* Replace with your application code */
; 0000 0078 
; 0000 0079     w1_init();
	RCALL _w1_init
; 0000 007A //    ds18b20_init(NULL, 0 , 0 ,DS18B20_10BIT_RES )  ;
; 0000 007B      sei(); //cho phep ngat toan cuc
	sei
; 0000 007C //    twi_lcd_cmd(0xC0);
; 0000 007D //    twi_lcd_msg("nhiet do: \r\n");
; 0000 007E     while (1)
_0x11:
; 0000 007F     {
; 0000 0080      twi_lcd_cmd(0xC0);
	LDI  R26,LOW(192)
	RCALL _twi_lcd_cmd
; 0000 0081      if((rx_buffer[0] == 'a'))// && (rx_buffer[1] == '*'))
	LDS  R26,_rx_buffer
	CPI  R26,LOW(0x61)
	BRNE _0x14
; 0000 0082         {
; 0000 0083            delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0084            printf("hien thi so a \r\n");
	__POINTW1FN _0x0,95
	RCALL SUBOPT_0x7
; 0000 0085              twi_lcd_cmd(0xC0);
	LDI  R26,LOW(192)
	RCALL _twi_lcd_cmd
; 0000 0086              twi_lcd_msg("nhietdo:");
	__POINTW2MN _0x10,7
	RCALL _twi_lcd_msg
; 0000 0087             twi_lcd_dwr(rx_buffer[2]);
	__GETB2MN _rx_buffer,2
	RCALL _twi_lcd_dwr
; 0000 0088             twi_lcd_dwr(rx_buffer[2]);
	__GETB2MN _rx_buffer,2
	RCALL _twi_lcd_dwr
; 0000 0089             twi_lcd_dwr(46);
	LDI  R26,LOW(46)
	RCALL _twi_lcd_dwr
; 0000 008A             twi_lcd_dwr(rx_buffer[3]);
	__GETB2MN _rx_buffer,3
	RCALL _twi_lcd_dwr
; 0000 008B             if(rx_buffer[4] == 'e')
	__GETB2MN _rx_buffer,4
	CPI  R26,LOW(0x65)
	BRNE _0x15
; 0000 008C             {
; 0000 008D                 printf("clear rx_wr_index in while \r\n ");
	__POINTW1FN _0x0,121
	RCALL SUBOPT_0x7
; 0000 008E                 rx_buffer[0] = 0;
	LDI  R30,LOW(0)
	STS  _rx_buffer,R30
; 0000 008F //                rx_wr_index =0;
; 0000 0090              }
; 0000 0091         }
_0x15:
; 0000 0092 //      else if(rx_buffer[0] != 'a')
; 0000 0093 //         {
; 0000 0094 //          delay_ms(500);
; 0000 0095 //          usart_msg("data clear buffer");
; 0000 0096 //           usart_msg("\r\n buffer 0: ");
; 0000 0097 //          usart_tx(rx_buffer[0]);
; 0000 0098 //           usart_msg("\r\n buffer 1: ");
; 0000 0099 //           usart_tx(rx_buffer[1]);
; 0000 009A //           usart_msg("\r\n buffer 2: ");
; 0000 009B //           usart_tx(rx_buffer[2]);
; 0000 009C //           usart_msg("\r\n buffer 3: ");
; 0000 009D //           usart_tx(rx_buffer[3]);
; 0000 009E //           usart_msg("\r\n buffer 4: ");
; 0000 009F //           usart_tx(rx_buffer[4]);
; 0000 00A0 
; 0000 00A1 //           rx_buffer[0] =0;
; 0000 00A2 //           rx_buffer[1] =0;
; 0000 00A3 //           rx_buffer[2] =0;
; 0000 00A4 //           rx_buffer[3] =0;
; 0000 00A5 //           rx_buffer[4] =0;
; 0000 00A6 //            rx_wr_index =0;
; 0000 00A7 //         }
; 0000 00A8     }
_0x14:
	RJMP _0x11
; 0000 00A9 }
_0x16:
	RJMP _0x16
; .FEND

	.DSEG
_0x10:
	.BYTE 0x10
; 0001 0001 /*
; 0001 0002 
; 0001 0003 		TWI MAIN FILE
; 0001 0004 		twi.c
; 0001 0005 */
; 0001 0006 
; 0001 0007 #include "twi_i2c.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <mega8.h>
;#include <delay.h>
;#define F_CPU 8000000UL
;
;void twi_init()
; 0001 000D {

	.CSEG
_twi_init:
; .FSTART _twi_init
; 0001 000E 	DDRC = 0x30;								//--- PORTC Last two bit as Output
	LDI  R30,LOW(48)
	OUT  0x14,R30
; 0001 000F 	PORTC = 0x30;
	OUT  0x15,R30
; 0001 0010 
; 0001 0011 	usart_init();								//--- Usart Initialization
	RCALL _usart_init
; 0001 0012 	usart_msg("I2C INIT MASTER:");				        //--- Send String to Com Port of PC
	__POINTW2MN _0x20003,0
	RCALL _usart_msg
; 0001 0013 	usart_tx(0x0d);								//--- Next Line
	LDI  R26,LOW(13)
	RCALL _usart_tx
; 0001 0014 
; 0001 0015 	TWCR &= ~(1<<TWEN);							//--- Diable TWI
	IN   R30,0x36
	ANDI R30,0xFB
	OUT  0x36,R30
; 0001 0016 	TWBR = BITRATE(TWSR = 0x00);	 			//--- Bit rate with prescaler 4
	__GETD1N 0x40800000
	RCALL __PUTPARD1
	OUT  0x1,R30
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x8
	RCALL _pow
	__GETD2N 0x40000000
	RCALL __MULF12
	__GETD2N 0x40800000
	RCALL __DIVF21
	RCALL __CFD1U
	OUT  0x0,R30
; 0001 0017 	TWCR = (1<<TWEN);							//--- Enable TWI
	LDI  R30,LOW(4)
	OUT  0x36,R30
; 0001 0018 	delay_us(10);								//--- Delay
	__DELAY_USB 27
; 0001 0019 }
	RET
; .FEND

	.DSEG
_0x20003:
	.BYTE 0x11
;
;/* Function to Send Start Condition */
;
;void twi_start()
; 0001 001E {

	.CSEG
_twi_start:
; .FSTART _twi_start
; 0001 001F     char status;
; 0001 0020 	TWCR= (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);		//--- Start Condition as per Datasheet
	ST   -Y,R17
;	status -> R17
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0001 0021 	while(!(TWCR & (1<<TWINT)));				//--- Wait till start condition is transmitted to Slave
_0x20004:
	RCALL SUBOPT_0x9
	BREQ _0x20004
; 0001 0022     while(!(TWCR&(1<<TWINT)));	                /* Wait until TWI finish its current job */
_0x20007:
	RCALL SUBOPT_0x9
	BREQ _0x20007
; 0001 0023     status=TWSR&0xF8;		                    /* Read TWI status register */
	RCALL SUBOPT_0xA
; 0001 0024     if(status!=0x10) return ;		            /* Check for repeated start transmitted */
; 0001 0025 
; 0001 0026 //	usart_msg("Start Exe.");					//--- Feedback msg to check for error
; 0001 0027 //	usart_tx(0x0D);								//--- Next Line
; 0001 0028 }
_0x20E0007:
	LD   R17,Y+
	RET
; .FEND
;
;/* Function to Send Slave Address for Write operation */
;
;void twi_write_cmd(unsigned char address)
; 0001 002D {
_twi_write_cmd:
; .FSTART _twi_write_cmd
; 0001 002E     char status;
; 0001 002F 	TWDR=address;								//--- SLA Address and write instruction
	RCALL SUBOPT_0xB
;	address -> Y+1
;	status -> R17
; 0001 0030 	TWCR=(1<<TWINT)|(1<<TWEN);					//--- Clear TWI interrupt flag,Enable TWI
; 0001 0031 	while (!(TWCR & (1<<TWINT)));				//--- Wait till complete TWDR byte transmitted to Slave
_0x2000B:
	RCALL SUBOPT_0x9
	BREQ _0x2000B
; 0001 0032     status=TWSR&0xF8;		    /* Read TWI status register */
	RCALL SUBOPT_0xA
; 0001 0033     if(status==0x28) return ;	/* Check for data transmitted &ack received */
	CPI  R17,40
	BRNE _0x2000E
	LDD  R17,Y+0
	RJMP _0x20E0006
; 0001 0034 
; 0001 0035 //	usart_msg("ACK Received for MT SLA");		//--- Feedback msg to check for error
; 0001 0036 //	usart_tx(0x0D);								//--- Next Line
; 0001 0037 }
_0x2000E:
	LDD  R17,Y+0
	RJMP _0x20E0006
; .FEND
;
;/* Function to Send Data to Slave Device  */
;
;void twi_write_dwr(unsigned char data)
; 0001 003C {
_twi_write_dwr:
; .FSTART _twi_write_dwr
; 0001 003D     char status;
; 0001 003E 	TWDR=data;									//--- Put data in TWDR
	RCALL SUBOPT_0xB
;	data -> Y+1
;	status -> R17
; 0001 003F 	TWCR=(1<<TWINT)|(1<<TWEN);					//--- Clear TWI interrupt flag,Enable TWI
; 0001 0040 	while(!(TWCR&(1<<TWINT)));	/* Wait until TWI finish its current job */
_0x2000F:
	RCALL SUBOPT_0x9
	BREQ _0x2000F
; 0001 0041     status=TWSR&0xF8;		    /* Read TWI status register */
	RCALL SUBOPT_0xA
; 0001 0042     if(status==0x28) return ;	/* Check for data transmitted &ack received */
	CPI  R17,40
	BRNE _0x20012
	LDD  R17,Y+0
	RJMP _0x20E0006
; 0001 0043 
; 0001 0044 //	usart_msg("ACK Received for MT Data");		//--- Feedback msg to check error
; 0001 0045 //	usart_tx(0x0D);								//--- Next Line
; 0001 0046 
; 0001 0047 }
_0x20012:
	LDD  R17,Y+0
	RJMP _0x20E0006
; .FEND
;
;/* Function to Send Stop Condition */
;
;void twi_stop()
; 0001 004C {
_twi_stop:
; .FSTART _twi_stop
; 0001 004D 	TWCR = (1<<TWINT)|(1<<TWEN)|(1<<TWSTO);		//--- Stop Condition as per Datasheet
	LDI  R30,LOW(148)
	OUT  0x36,R30
; 0001 004E }
	RET
; .FEND
;
;/* Function to Send Repeated Start Condition */
;
;
;void twi_repeated_start()
; 0001 0054 {
; 0001 0055     char status;
; 0001 0056 	TWCR= (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);		//--- Repeated Start Condition as per Datasheet
;	status -> R17
; 0001 0057 	while(!(TWCR & (1<<TWINT)));				//--- Wait till restart condition is transmitted to Slave
; 0001 0058 	status=TWSR&0xF8;		/* Read TWI status register */
; 0001 0059     if(status!=0x10)     return ;		/* Check for repeated start transmitted */
; 0001 005A 
; 0001 005B 	usart_msg("Repeated Start Exe.");			//--- Feedback msg to check error
; 0001 005C 	usart_tx(0x0D);								//--- Next Line
; 0001 005D }

	.DSEG
_0x20017:
	.BYTE 0x14
;
;
;/* Function to Send Read Acknowledgment */
;
;char twi_read_ack()
; 0001 0063 {

	.CSEG
; 0001 0064 	TWCR=(1<<TWEN)|(1<<TWINT)|(1<<TWEA);		//--- Acknowledgment Condition as per Datasheet
; 0001 0065 	while (!(TWCR & (1<<TWINT)));				//--- Wait until Acknowledgment Condition is transmitted to Slave
; 0001 0066 //	while(TW_STATUS != TW_MR_DATA_ACK);			//--- Check for Acknowledgment
; 0001 0067 //	usart_msg("Receiving MR data ACK ");		//--- Feedback msg to check error
; 0001 0068 //	usart_tx(0x0D);								//--- Next Line
; 0001 0069 	return TWDR;								//--- Return received data from Slave
; 0001 006A }
;
;/* Function to Send Read No Acknowledgment */
;
;char twi_read_nack()
; 0001 006F {
; 0001 0070 	TWCR=(1<<TWEN)|(1<<TWINT);					//--- No Acknowledgment Condition as per Datasheet
; 0001 0071 	while (!(TWCR & (1<<TWINT)));				//--- Wait until No Acknowledgment Condition is transmitted to Slave
; 0001 0072 //	while(TW_STATUS != TW_MR_DATA_NACK);		//--- Check for Acknowledgment
; 0001 0073 //	usart_msg("Receiving MR Data NACK");		//--- Feedback msg to check error
; 0001 0074 //	usart_tx(0x0D);								//--- Next Line
; 0001 0075 	return TWDR;								//--- Return received data
; 0001 0076 }
;
;/* Function to Initialize USART */
;
;void usart_init()
; 0001 007B {
_usart_init:
; .FSTART _usart_init
; 0001 007C 	UBRRH = 0;										//--- USART Baud Rate is set to 115200
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0001 007D 	UBRRL = UBRRL=0x33;//0x08;
	LDI  R30,LOW(51)
	OUT  0x9,R30
	OUT  0x9,R30
; 0001 007E 	UCSRC = (1<<URSEL) | (1<<UCSZ1) | (1<<UCSZ0);	//--- 8-Bit Data Selected
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0001 007F 	UCSRB = (1<<TXEN) | (1<<RXEN) | (1<<RXCIE);					//--- Enable TX & RX
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0001 0080 }
	RET
; .FEND
;
;/* Function to Transmit data */
;
;void usart_tx(char x)
; 0001 0085 {
_usart_tx:
; .FSTART _usart_tx
; 0001 0086 	while (!( UCSRA & (1<<UDRE)));					//--- Check for Buffer is empty
	ST   -Y,R26
;	x -> Y+0
_0x2001E:
	SBIS 0xB,5
	RJMP _0x2001E
; 0001 0087 	UDR = x;										//--- Send data to USART Buffer
	LD   R30,Y
	OUT  0xC,R30
; 0001 0088 }
	RJMP _0x20E0001
; .FEND
;
;/* Function to Receive data */
;
;unsigned char usart_rx()
; 0001 008D {
; 0001 008E 	while(!(UCSRA & (1<<RXC)));						//--- Check for data received completed
; 0001 008F 	return(UDR);									//--- Return the received data
; 0001 0090 }
;
;/* Function to transmit string */
;
;void usart_msg(char *c)
; 0001 0095 {
_usart_msg:
; .FSTART _usart_msg
; 0001 0096 	while(*c != '\0')								//--- Check for Null
	RCALL SUBOPT_0x2
;	*c -> Y+0
_0x20024:
	RCALL SUBOPT_0x3
	LD   R30,X
	CPI  R30,0
	BREQ _0x20026
; 0001 0097 	usart_tx(*c++);									//--- Send the String
	RCALL SUBOPT_0x4
	RCALL _usart_tx
	RJMP _0x20024
_0x20026:
; 0001 0098 }
_0x20E0006:
	ADIW R28,2
	RET
; .FEND
;
;
;/****** END of Program ******/
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
_twi_int_handler:
; .FSTART _twi_int_handler
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RCALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G100
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G100
	LDS  R27,_twi_rx_buffer_G100+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x2000017
	LDI  R18,LOW(0)
	RJMP _0x2000018
_0x2000017:
	CPI  R30,LOW(0x10)
	BRNE _0x2000019
_0x2000018:
	LDS  R30,_slave_address_G100
	RJMP _0x2000067
_0x2000019:
	CPI  R30,LOW(0x18)
	BREQ _0x200001D
	CPI  R30,LOW(0x28)
	BRNE _0x200001E
_0x200001D:
	CP   R16,R19
	BRSH _0x200001F
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G100
	LDS  R27,_twi_tx_buffer_G100+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
_0x2000067:
	OUT  0x3,R30
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	OUT  0x36,R30
	RJMP _0x2000020
_0x200001F:
	LDS  R30,_bytes_to_rx_G100
	CP   R17,R30
	BRSH _0x2000021
	LDS  R30,_slave_address_G100
	ORI  R30,1
	STS  _slave_address_G100,R30
	CLT
	BLD  R2,1
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	OUT  0x36,R30
	RJMP _0x2000016
_0x2000021:
	RJMP _0x2000022
_0x2000020:
	RJMP _0x2000016
_0x200001E:
	CPI  R30,LOW(0x50)
	BRNE _0x2000023
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2000024
_0x2000023:
	CPI  R30,LOW(0x40)
	BRNE _0x2000025
_0x2000024:
	LDS  R30,_bytes_to_rx_G100
	SUBI R30,LOW(1)
	CP   R17,R30
	BRLO _0x2000026
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2000068
_0x2000026:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2000068:
	OUT  0x36,R30
	RJMP _0x2000016
_0x2000025:
	CPI  R30,LOW(0x58)
	BRNE _0x2000028
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2000029
_0x2000028:
	CPI  R30,LOW(0x20)
	BRNE _0x200002A
_0x2000029:
	RJMP _0x200002B
_0x200002A:
	CPI  R30,LOW(0x30)
	BRNE _0x200002C
_0x200002B:
	RJMP _0x200002D
_0x200002C:
	CPI  R30,LOW(0x48)
	BRNE _0x200002E
_0x200002D:
	CPI  R18,0
	BRNE _0x200002F
	SBRS R2,1
	RJMP _0x2000030
	CP   R16,R19
	BRLO _0x2000032
	RJMP _0x2000033
_0x2000030:
	LDS  R30,_bytes_to_rx_G100
	CP   R17,R30
	BRSH _0x2000034
_0x2000032:
	LDI  R18,LOW(4)
_0x2000034:
_0x2000033:
_0x200002F:
_0x2000022:
	RJMP _0x2000069
_0x200002E:
	CPI  R30,LOW(0x38)
	BRNE _0x2000037
	LDI  R18,LOW(2)
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x200006A
_0x2000037:
	CPI  R30,LOW(0x68)
	BREQ _0x200003A
	CPI  R30,LOW(0x78)
	BRNE _0x200003B
_0x200003A:
	LDI  R18,LOW(2)
	RJMP _0x200003C
_0x200003B:
	CPI  R30,LOW(0x60)
	BREQ _0x200003F
	CPI  R30,LOW(0x70)
	BRNE _0x2000040
_0x200003F:
	LDI  R18,LOW(0)
_0x200003C:
	LDI  R17,LOW(0)
	CLT
	BLD  R2,1
	LDS  R30,_twi_rx_buffer_size_G100
	CPI  R30,0
	BRNE _0x2000041
	LDI  R18,LOW(1)
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x200006B
_0x2000041:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x200006B:
	OUT  0x36,R30
	RJMP _0x2000016
_0x2000040:
	CPI  R30,LOW(0x80)
	BREQ _0x2000044
	CPI  R30,LOW(0x90)
	BRNE _0x2000045
_0x2000044:
	SBRS R2,1
	RJMP _0x2000046
	LDI  R18,LOW(1)
	RJMP _0x2000047
_0x2000046:
	IN   R30,0x3
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G100
	CP   R17,R30
	BRSH _0x2000048
	LDS  R30,_twi_slave_rx_handler_G100
	LDS  R31,_twi_slave_rx_handler_G100+1
	SBIW R30,0
	BRNE _0x2000049
	LDI  R18,LOW(6)
	RJMP _0x2000047
_0x2000049:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G100,0
	CPI  R30,0
	BREQ _0x200004A
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	RJMP _0x2000016
_0x200004A:
	RJMP _0x200004B
_0x2000048:
	SET
	BLD  R2,1
_0x200004B:
	RJMP _0x200004C
_0x2000045:
	CPI  R30,LOW(0x88)
	BRNE _0x200004D
_0x200004C:
	RJMP _0x200004E
_0x200004D:
	CPI  R30,LOW(0x98)
	BRNE _0x200004F
_0x200004E:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	OUT  0x36,R30
	RJMP _0x2000016
_0x200004F:
	CPI  R30,LOW(0xA0)
	BRNE _0x2000050
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	SET
	BLD  R2,2
	LDS  R30,_twi_slave_rx_handler_G100
	LDS  R31,_twi_slave_rx_handler_G100+1
	SBIW R30,0
	BREQ _0x2000051
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G100,0
	RJMP _0x2000052
_0x2000051:
	LDI  R18,LOW(6)
_0x2000052:
	RJMP _0x2000016
_0x2000050:
	CPI  R30,LOW(0xB0)
	BRNE _0x2000053
	LDI  R18,LOW(2)
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0xA8)
	BRNE _0x2000055
_0x2000054:
	LDS  R30,_twi_slave_tx_handler_G100
	LDS  R31,_twi_slave_tx_handler_G100+1
	SBIW R30,0
	BREQ _0x2000056
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G100,0
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2000058
	LDI  R18,LOW(0)
	RJMP _0x2000059
_0x2000056:
_0x2000058:
	LDI  R18,LOW(6)
	RJMP _0x2000047
_0x2000059:
	LDI  R16,LOW(0)
	CLT
	BLD  R2,1
	RJMP _0x200005A
_0x2000055:
	CPI  R30,LOW(0xB8)
	BRNE _0x200005B
_0x200005A:
	SBRS R2,1
	RJMP _0x200005C
	LDI  R18,LOW(1)
	RJMP _0x2000047
_0x200005C:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G100
	LDS  R27,_twi_tx_buffer_G100+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x3,R30
	CP   R16,R19
	BRSH _0x200005D
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	RJMP _0x200006C
_0x200005D:
	SET
	BLD  R2,1
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
_0x200006C:
	OUT  0x36,R30
	RJMP _0x2000016
_0x200005B:
	CPI  R30,LOW(0xC0)
	BREQ _0x2000060
	CPI  R30,LOW(0xC8)
	BRNE _0x2000061
_0x2000060:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	OUT  0x36,R30
	LDS  R30,_twi_slave_tx_handler_G100
	LDS  R31,_twi_slave_tx_handler_G100+1
	SBIW R30,0
	BREQ _0x2000062
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G100,0
_0x2000062:
	RJMP _0x2000035
_0x2000061:
	CPI  R30,0
	BRNE _0x2000016
	LDI  R18,LOW(3)
_0x2000047:
_0x2000069:
	IN   R30,0x36
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
_0x200006A:
	OUT  0x36,R30
_0x2000035:
	SET
	BLD  R2,2
_0x2000016:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G100,R19
	RCALL __LOADLOCR6
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0xC
	RJMP _0x20E0005
__floor1:
    brtc __floor0
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
_0x20E0005:
	ADIW R28,4
	RET
; .FEND
_log:
; .FSTART _log
	RCALL __PUTPARD2
	SBIW R28,4
	RCALL __SAVELOCR2
	RCALL SUBOPT_0xE
	RCALL __CPD02
	BRLT _0x202000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20E0004
_0x202000C:
	RCALL SUBOPT_0xF
	RCALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	RCALL _frexp
	POP  R16
	POP  R17
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xE
	__GETD1N 0x3F3504F3
	RCALL __CMPF12
	BRSH _0x202000D
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xE
	RCALL __ADDF12
	RCALL SUBOPT_0x10
	__SUBWRN 16,17,1
_0x202000D:
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xF
	__GETD2N 0x3F800000
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	RCALL SUBOPT_0x11
	__GETD2N 0x3F654226
	RCALL __MULF12
	RCALL SUBOPT_0x8
	__GETD1N 0x4054114E
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0xE
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x12
	__GETD2N 0x3FD4114D
	RCALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3F317218
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
_0x20E0004:
	RCALL __LOADLOCR2
	ADIW R28,10
	RET
; .FEND
_exp:
; .FSTART _exp
	RCALL __PUTPARD2
	SBIW R28,8
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x13
	__GETD1N 0xC2AEAC50
	RCALL __CMPF12
	BRSH _0x202000F
	RCALL SUBOPT_0x14
	RJMP _0x20E0003
_0x202000F:
	__GETD1S 10
	RCALL __CPD10
	BRNE _0x2020010
	RCALL SUBOPT_0x15
	RJMP _0x20E0003
_0x2020010:
	RCALL SUBOPT_0x13
	__GETD1N 0x42B17218
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2020011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20E0003
_0x2020011:
	RCALL SUBOPT_0x13
	__GETD1N 0x3FB8AA3B
	RCALL __MULF12
	__PUTD1S 10
	RCALL SUBOPT_0x13
	RCALL _floor
	RCALL __CFD1
	MOVW R16,R30
	RCALL SUBOPT_0x13
	RCALL __CWD1
	RCALL __CDF1
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x8
	__GETD1N 0x3F000000
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x11
	__GETD2N 0x3D6C4C6D
	RCALL __MULF12
	__GETD2N 0x40E6E3A6
	RCALL __ADDF12
	RCALL SUBOPT_0xE
	RCALL __MULF12
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x12
	__GETD2N 0x41A68D28
	RCALL __ADDF12
	__PUTD1S 2
	RCALL SUBOPT_0xF
	__GETD2S 2
	RCALL __ADDF12
	__GETD2N 0x3FB504F3
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x12
	RCALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	RCALL __PUTPARD1
	MOVW R26,R16
	RCALL _ldexp
_0x20E0003:
	RCALL __LOADLOCR2
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	RCALL __PUTPARD2
	SBIW R28,4
	RCALL SUBOPT_0x16
	RCALL __CPD10
	BRNE _0x2020012
	RCALL SUBOPT_0x14
	RJMP _0x20E0002
_0x2020012:
	RCALL SUBOPT_0x17
	RCALL __CPD02
	BRGE _0x2020013
	RCALL SUBOPT_0x18
	RCALL __CPD10
	BRNE _0x2020014
	RCALL SUBOPT_0x15
	RJMP _0x20E0002
_0x2020014:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x19
	RJMP _0x20E0002
_0x2020013:
	RCALL SUBOPT_0x18
	MOVW R26,R28
	RCALL __CFD1
	RCALL __PUTDP1
	RCALL SUBOPT_0xC
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x18
	RCALL __CPD12
	BREQ _0x2020015
	RCALL SUBOPT_0x14
	RJMP _0x20E0002
_0x2020015:
	RCALL SUBOPT_0x16
	RCALL __ANEGF1
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x19
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2020016
	RCALL SUBOPT_0x16
	RJMP _0x20E0002
_0x2020016:
	RCALL SUBOPT_0x16
	RCALL __ANEGF1
_0x20E0002:
	ADIW R28,12
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20E0001:
	ADIW R28,1
	RET
; .FEND
_put_usart_G102:
; .FSTART _put_usart_G102
	RCALL SUBOPT_0x2
	LDD  R26,Y+2
	RCALL _putchar
	RCALL SUBOPT_0x3
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R28,3
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	RCALL SUBOPT_0x2
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	RCALL SUBOPT_0x1A
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	RCALL SUBOPT_0x1A
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1B
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x1D
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	RCALL SUBOPT_0x20
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	RCALL SUBOPT_0x20
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x21
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x21
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	RCALL SUBOPT_0x1A
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x20
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	RCALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x20
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x1D
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	RCALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x1D
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x5
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G102)
	LDI  R31,HIGH(_put_usart_G102)
	RCALL SUBOPT_0x5
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G102
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x2
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x2
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
___ds18b20_scratch_pad:
	.BYTE 0x9
_rx_buffer:
	.BYTE 0x5
_slave_address_G100:
	.BYTE 0x1
_twi_tx_buffer_G100:
	.BYTE 0x2
_bytes_to_tx_G100:
	.BYTE 0x1
_twi_rx_buffer_G100:
	.BYTE 0x2
_bytes_to_rx_G100:
	.BYTE 0x1
_twi_rx_buffer_size_G100:
	.BYTE 0x1
_twi_slave_rx_handler_G100:
	.BYTE 0x2
_twi_slave_tx_handler_G100:
	.BYTE 0x2
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x0:
	OR   R5,R17
	LDI  R30,LOW(4)
	OR   R5,R30
	MOV  R26,R5
	RCALL _PCF8574_write
	__DELAY_USB 3
	LDI  R30,LOW(251)
	AND  R5,R30
	MOV  R26,R5
	RCALL _PCF8574_write
	__DELAY_USB 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOV  R26,R5
	RCALL _PCF8574_write
	LD   R26,Y
	RJMP _twi_lcd_4bit_send

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x3
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x5
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	OUT  0x3,R30
	LDI  R30,LOW(132)
	OUT  0x36,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	__GETD2N 0x3F800000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xE:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xF:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x10:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xE
	RCALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x13:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	RCALL _log
	__GETD2S 4
	RCALL __MULF12
	RCALL SUBOPT_0x8
	RJMP _exp

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1A:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x1B
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x15
	.equ __w1_bit=0x00

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x30C
	ret

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
