	LIST P=16F877A
	INCLUDE <P16F877A.INC>
	__CONFIG _CP_OFF &_WDT_OFF &_HS_OSC &_PWRTE_OFF &_LVP_OFF

SAYAC0	EQU	0x20
SAYAC1 	EQU	0x21
SAYAC2 	EQU	0x22
BIRLER 	EQU	0x23
ONLAR	EQU	0x24
YUZLER 	EQU	0x25
BINLER	EQU	0x26
ISTENEN	EQU	0x27
ESIK	EQU	0x28
TEMP	EQU	0x29
TEMP1	EQU 0x2A
TEMP2 	EQU	0x2B


;*****************RESET VECTOR***********
	ORG 0x00
	GOTO BASLA

;*****************INTERRUPT VECTOR*******
	ORG	0x04
	
	RETFIE                    	; Kesme 'den don

;*****************MACRO TANIMLANAB�L�R***
BANK0 MACRO
	  BCF STATUS,5
	  ENDM
BANK1 MACRO
	  BSF STATUS,5
	  ENDM

BEKLE ; YAKLASIK 3MS GECIKME
	MOVLW .2
	MOVWF SAYAC0
AZALT1
	MOVLW .50
	MOVWF SAYAC1
AZALT2
	MOVLW .50
	MOVWF SAYAC2
AZALT3
	DECFSZ SAYAC2,F
	GOTO AZALT3
	DECFSZ SAYAC1,F
	GOTO AZALT2
	DECFSZ SAYAC0,F
	GOTO AZALT1

	RETURN

BEKLE2 ; YAKLASIK 300MS GECIKME
	MOVLW .50
	MOVWF SAYAC0
AZALTT1
	MOVLW .100
	MOVWF SAYAC1
AZALTT2
	MOVLW .100
	MOVWF SAYAC2 
AZALTT3
	DECFSZ SAYAC2,F
	GOTO AZALTT3
	DECFSZ SAYAC1,F
	GOTO AZALTT2
	DECFSZ SAYAC0,F
	GOTO AZALTT1

	RETURN

BEKLE3 ; YAKLASIK 1.5MS GECIKME
	MOVF  TEMP1,W
	MOVWF SAYAC0
AZALTTT1
	MOVLW .50
	MOVWF SAYAC1
AZALTTT2
	MOVLW .50
	MOVWF SAYAC2
AZALTTT3
	DECFSZ SAYAC2,F
	GOTO AZALTTT3
	DECFSZ SAYAC1,F
	GOTO AZALTTT2
	DECFSZ SAYAC0,F
	GOTO AZALTTT1

	RETURN


GOSTER
	MOVF YUZLER,W
	MOVWF PORTD
	MOVLW B'00000010'
	MOVWF  PORTB
	CALL  BEKLE2
	MOVF  ONLAR,W
	MOVWF PORTD        ; 7448 ENTEGRES�NE 4 TANE LED BA�LANAB�L�YOR.PORTDN�N 4 P�N� �LE VER�Y�, PORTBN�N 4 P�N� �LE HANG� DISPLAY�N �ALI�ACA�INI SE��YORUZ.VER�Y� D�REK DEC�MAL OLARAK G�NDEREB�L�YORUZ.
	MOVLW B'00000100'
	MOVWF  PORTB
	CALL  BEKLE2
	MOVF  BIRLER,W
	MOVWF PORTD
	MOVLW B'00001000'
	MOVWF PORTB
	CALL  BEKLE2
	CLRF  PORTB 
	RETURN

BASAMAKBUL        ; �� BASMAKLI SAYILAR ���N BASAMAK DE�ERLER�N� BULAN ALTPROGRAM
	CLRF BIRLER
	CLRF ONLAR
	CLRF YUZLER
	MOVF TEMP1,W
	MOVWF TEMP
BASAMAKDEVAM1
	BCF STATUS,C
	BCF STATUS,Z
	MOVLW .100
	SUBWF TEMP,W   ; ISTENEN SICAKLIKTAN ODA SICAKLI�I �IKARILDI.
	BTFSC STATUS,Z
	GOTO ESITLIK1
	BTFSC STATUS,C   ; �IKARILAN DE�ER DAHA B�Y�KSE C B�T� 0 OLUR AKS� HALDE 1 OLUR.
	GOTO BUYUKLUK1
	GOTO BASAMAKDEVAM2
ESITLIK1
	INCF YUZLER,F
	RETURN
BUYUKLUK1
	INCF YUZLER,F
	MOVWF TEMP
	GOTO BASAMAKDEVAM1

BASAMAKDEVAM2
	BCF STATUS,C
	BCF STATUS,Z
	MOVLW .10
	SUBWF TEMP,W   ; ISTENEN SICAKLIKTAN ODA SICAKLI�I �IKARILDI.
	BTFSC STATUS,Z
	GOTO ESITLIK2
	BTFSC STATUS,C   ; �IKARILAN DE�ER DAHA B�Y�KSE C B�T� 0 OLUR AKS� HALDE 1 OLUR.
	GOTO BUYUKLUK2
	MOVF TEMP,W
	MOVWF BIRLER
	RETURN
ESITLIK2
	INCF ONLAR,F
	RETURN
BUYUKLUK2
	INCF ONLAR,F
	MOVWF TEMP
	GOTO BASAMAKDEVAM2




YONTESPIT            ; DC MOTOR �LER�/GER�/ORTA DURUMUNU ALGILAMAK
	BCF STATUS,C
	BCF STATUS,Z
	MOVF ESIK,W
	SUBWF ISTENEN,W   
	BTFSC STATUS,Z
	GOTO ESITLIK
	BTFSC STATUS,C   ; �IKARILAN DE�ER DAHA B�Y�KSE C B�T� 0 OLUR AKS� HALDE 1 OLUR.
	GOTO SOLADONDUR
	BSF PORTC,0  	 ; RCO = 1 OLDU SA�A D�NME AKT�F
	MOVF ISTENEN,W
	SUBLW .127
	MOVWF TEMP1
	BCF STATUS,C
	RLF	 TEMP1,F
	INCF TEMP1,F
	RETURN

ESITLIK
	CLRF TEMP1
	RETURN

SOLADONDUR
	BCF PORTC,0      ; RCO = 0 OLDU SOLA D�NME AKT�F
	MOVLW .128
	SUBWF ISTENEN,W
	MOVWF TEMP1
	BCF STATUS,C
	RLF	 TEMP1,F
	INCF TEMP1,F
	RETURN




ADCOKU
	MOVLW B'00101001'
	MOVWF ADCON0
	BANK1
	CLRF ADCON1
	BANK0
	BSF ADCON0,2    ; GO P�N� 1 YAPILDI B�YLECE ADC ��LEME BA�LADI
ADCDEVAM
	BTFSC ADCON0,2  ; GO P�N� 0 OLDU �SE ��LEM B�TM�� DEMEKT�R. 
 	GOTO ADCDEVAM
	MOVF ADRESH,W  ; D�N��T�RME ��LEM�N�N SONUCU ADRESH REG�ST�RINA YAZILDI. 
	MOVWF ISTENEN
	CLRF ADCON0
	BANK1
	MOVLW .6
	MOVWF ADCON1
	CLRF TRISA
	BANK0
	RETURN

SAGA
	MOVLW .10
	MOVWF TEMP2
SAGA1
	MOVLW B'00001010'    ; DEFTERDE Y�NLER�N OLU�MA TABLOSU VE MANTI�I VAR.ORDAN YAPTIK.
	MOVWF PORTA
	CALL BEKLE3
	MOVLW B'00000110'
	MOVWF PORTA
	CALL BEKLE3          ; STEP MOTOR ���N HER ADIMDA GEREKEN BEKLEMEY� SA�LIYOR.
	MOVLW B'00000101'
	MOVWF PORTA
	CALL BEKLE3
	MOVLW B'00001001'
	MOVWF PORTA
	CALL BEKLE3
	CLRF PORTA
	DECFSZ TEMP2,F
	GOTO SAGA1
	RETURN

SOLA
	MOVLW .10
	MOVWF TEMP2
SOLA1
	MOVLW B'00001001'
	MOVWF PORTA
	CALL BEKLE3
	MOVLW B'00000101'
	MOVWF PORTA
	CALL BEKLE3
	MOVLW B'00000110'
	MOVWF PORTA
	CALL BEKLE3
	MOVLW B'00001010'
	MOVWF PORTA  
	CALL BEKLE3
	CLRF PORTA
	DECFSZ TEMP2,F
	GOTO SOLA1
	RETURN
	

KONTROL
	BCF STATUS,Z
	MOVF TEMP1,F
	BTFSC STATUS,Z
	RETURN
	BTFSC PORTC,0
	GOTO SOLKE
	CALL SAGA
	RETURN
SOLKE		
	CALL SOLA
	RETURN



;*****************BASLANGIC**************

BASLA

	BANK1       ; ADCON1 AYARLANACAK
	CLRF TRISB
	CLRF TRISD
	CLRF TRISC
	BANK0 
	CLRF PORTA
	CLRF PORTB
	CLRF PORTD
	BCF PORTC,0
	MOVLW .0
	MOVWF YUZLER
	MOVLW .0
	MOVWF ONLAR
	MOVLW .0
	MOVWF BIRLER
	MOVLW .128
	MOVWF ESIK         ; JOYSTIK ORTA NOKTASI ���N E��K DE�ER 

LOOP
	CALL ADCOKU        ; RE0/AN5 JOYSTIK �LER�/GER� HAREKET� D�J�TALLE�T�
	CALL YONTESPIT	
	CALL BASAMAKBUL
	CALL GOSTER
	CALL KONTROL	
	GOTO LOOP

END	
