    LIST P=16F877A
    INCLUDE <P16F877A.INC>
    __CONFIG _CP_OFF &_WDT_OFF &_HS_OSC &_PWRTE_OFF &_LVP_OFF
;  KOD KORUMA, UYKU MODU, HS OSC SE�?M?, -- , LOW PROGRAMMING KAPALI
 SAYAC0 EQU 0X20
 SAYAC1 EQU 0X21
 SAYAC2 EQU 0X22
 KAYDIR EQU 0X23
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
    CLRF TRISC
    BANK0
    CLRF PORTC
    BSF PORTC,0
    BCF STATUS,C
SOLA
    CALL BEKLE
    RLF PORTC,F
    BTFSC PORTC,7
    GOTO SAGA
    GOTO SOLA
SAGA
    CALL BEKLE
    RRF PORTC,F
    BTFSC PORTC,0
    GOTO SOLA
    GOTO SAGA
BEKLE
    MOVLW .100
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




