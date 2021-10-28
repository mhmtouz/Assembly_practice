    LIST P=16F877A
    #INCLUDE <P16F877A.INC>
    __CONFIG H'3F31'
    SAY EQU 0X24
    ORG 0X00
    GOTO MAIN
    ORG 0X04
    GOTO KESME
MAIN
    BANKSEL TRISB
    CLRF TRISB
    BANKSEL PORTB
    CLRF PORTB
    ;BSF PORTB,0
    MOVLW D'125'
    MOVWF SAY
    BANKSEL OPTION_REG
    MOVLW B'10000100'
    MOVWF OPTION_REG
    BANKSEL INTCON
    BSF INTCON,T0IE
    BSF INTCON,GIE
    BCF INTCON,T0IF
    BANKSEL PORTB
DONGU
    GOTO DONGU
KESME    
    BCF INTCON,T0IF
    DECFSZ SAY,F
    GOTO SON
    CALL ISLEM
    MOVLW D'125'
    MOVWF SAY
    MOVLW 0X06
    MOVWF TMR0
    GOTO SON
ISLEM
    BANKSEL PORTB
    MOVLW 0X01
    XORWF PORTB,F
    RETURN
SON
    RETFIE
    END