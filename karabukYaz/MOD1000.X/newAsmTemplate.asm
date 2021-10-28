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
    CLRF TRISD
    CLRF TRISB
    BANK0
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
    CLRW

BINLERD
    MOVLW 0X0A
    MOVWF BINKNT
YUZLERD
    MOVLW 0X0A
    MOVWF YUZKNT
ONLARD
    MOVLW 0X0A
    MOVWF ONKNT
BIRLERD
    MOVLW 0X0A
    MOVWF BIRKNT
LOOP
    CALL GOSTER    
    INCF BIRLER,F
    DECFSZ BIRKNT,F
    GOTO LOOP
    CLRF BIRLER
    
    ;CALL GOSTER    
    INCF ONLAR,F
    DECFSZ ONKNT,F
    GOTO BIRLERD
    CLRF ONLAR
    
    ;CALL GOSTER    
    INCF YUZLER,F
    DECFSZ YUZKNT,F
    GOTO ONLARD
    CLRF YUZLER
    
    ;CALL GOSTER    
    INCF BINLER,F
    DECFSZ BINKNT,F
    GOTO YUZLERD
    CLRF BINLER
    
    GOTO LOOP
GOSTER
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
    CLRF PORTB
    RETURN
    
    
BEKLE
    MOVLW .50
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









