    LIST P=16F877A
    INCLUDE <P16F877A.INC>
    __CONFIG _CP_OFF &_WDT_OFF &_HS_OSC &_PWRTE_OFF &_LVP_OFF
;  KOD KORUMA, UYKU MODU, HS OSC SE�?M?, -- , LOW PROGRAMMING KAPALI
 SAYAC0 EQU 0X20
 SAYAC1 EQU 0X21
 SAYAC2 EQU 0X22
 KAYDIR EQU 0X23
 BIRLER EQU 0X24
 ONLAR	EQU 0X25
 YUZLER EQU 0X26
 BINLER EQU 0X27
 BIRKNT	EQU 0X28
 ONKNT	EQU 0X29
 YUZKNT	EQU 0X2A
 BINKNT EQU 0X2B
 ISTENEN EQU 0X2C
 ISI	EQU 0X2D
 TEMP	EQU 0X2E
 TEMP1	EQU 0X2F
 TEMP2	EQU 0X30
; ----------------------- BA?LANGI� AYARLARI //KESME ALTPROGRAMI
    ORG 0X00
    GOTO MAIN	    
    
    ORG 0X04
    GOTO MAIN	    
; ----------------------- STATUS,RP0 (BANKSEL ARASI GE�??)
BANK0 MACRO
    BCF STATUS,5    
    ENDM
BANK1 MACRO
    BSF STATUS,5
    ENDM
;---------------------- BA?LANGI� ALTPROGRAM VE SONSUZ DONGU    
MAIN BANK1
    CLRF ADCON1
    MOVLW B'11110000' ; ANALOG D??TAL AYARLA
    MOVWF TRISD
    CLRF TRISB
    CLRF TRISC
    BANK0
    MOVLW B'00101001' ;00101001 D?KEY - 00110001 YATAY
    MOVWF ADCON0
    CLRF PORTC ;DC YON KONTROLU VE CCP1-RC2 PWM S?NYAL?
    CLRF PORTD
    CLRF PORTB 
    MOVLW 0X00
    MOVWF BINLER    ;RB0
    MOVLW 0X00
    MOVWF YUZLER    ;RB1
    MOVLW 0X00
    MOVWF ONLAR	    ;RB2
    MOVLW 0X00
    MOVWF BIRLER    ;RB3
    MOVLW .128
    MOVWF ISI ;JOYSITCKTEN GELEN ORTA NOKTA SINIRI
    CLRW

LOOP
    CALL ADCOKU
    CALL BASAMAKBUL
    CALL GOSTER ;6MS    
    GOTO LOOP
  
ADCOKU
    BSF ADCON0,0 ;GO/DONE
ADCOKU1
    BTFSC ADCON0,2
    MOVFW ADRESH
    MOVWF ISTENEN
    RETURN

BASAMAKBUL
    CLRF ONLAR
    CLRF BIRLER
    CLRF YUZLER
    MOVFW ISTENEN
    MOVWF TEMP
    
BASAMAKBUL2
    BCF STATUS,C
    BCF STATUS,Z
    MOVLW .100
    SUBWF TEMP,W ;W=ISTENEN-ISI
    BTFSC STATUS,Z
    GOTO ESITLIK2
    BTFSC STATUS,C
    GOTO BUYUKLUK2
    GOTO BASAMAKBUL1
ESITLIK2
    INCF YUZLER,F
    RETURN
BUYUKLUK2
    INCF YUZLER,F
    MOVLW .100
    SUBWF TEMP,F ;W=ISTENEN-ISI
    GOTO BASAMAKBUL2
      
BASAMAKBUL1
    BCF STATUS,C
    BCF STATUS,Z
    MOVLW 0X0A
    SUBWF TEMP,W ;W=ISTENEN-ISI
    BTFSC STATUS,Z
    GOTO ESITLIK1
    BTFSC STATUS,C
    GOTO BUYUKLUK1
    MOVFW TEMP
    MOVWF BIRLER
    RETURN
ESITLIK1
    INCF ONLAR,F
    RETURN
BUYUKLUK1
    INCF ONLAR,F
    MOVLW 0X0A
    SUBWF TEMP,F ;W=ISTENEN-ISI
    GOTO BASAMAKBUL1
     
GOSTER
    MOVLW .1		    ;TUS SEKMES?N? (butondan el �ekme) �NLER.
    MOVWF TEMP1
GOSTER1
    MOVFW BINLER	    ;BINLER BASILDI
    MOVWF PORTD
    MOVLW B'00000001'	    ;RB0 AKT?F
    MOVWF PORTB
    CALL BEKLE
    
    MOVFW YUZLER	    ;YUZLER BASILDI
    MOVWF PORTD
    MOVLW B'00000010'	    ;RB1 AKT?F
    MOVWF PORTB
    CALL BEKLE
    
    MOVFW ONLAR		    ;ONLAR BASILDI
    MOVWF PORTD
    MOVLW B'00000100'	    ;RB2 AKT?F
    MOVWF PORTB
    CALL BEKLE
    
    MOVFW BIRLER	    ;BIRLER BASILDI
    MOVWF PORTD
    MOVLW B'00001000'	    ;RB3 AKT?F
    MOVWF PORTB
    CALL BEKLE
    DECFSZ TEMP1,F
    GOTO GOSTER1
    CLRF PORTB
    RETURN
    
    
BEKLE
    MOVLW .2      ; 2 3MS
    MOVWF SAYAC0
BEKLE1
    MOVLW .50
    MOVWF SAYAC1
BEKLE2
    MOVLW .50
    MOVWF SAYAC2
BEKLEDONGU
    DECFSZ SAYAC2,F
    GOTO BEKLEDONGU
    DECFSZ SAYAC1,F
    GOTO BEKLE2
    DECFSZ SAYAC0,F
    GOTO BEKLE1
    RETURN
    END



















