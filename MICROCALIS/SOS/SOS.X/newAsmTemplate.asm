    LIST P=16F877A
    #INCLUDE <P16F877A.INC>
    __CONFIG H'3F31'
    BEKLE EQU 0X22
    BEKLE2 EQU 0X23
    SAY EQU 0X24
    ORG 0X00
    GOTO MAIN
    ORG 0X04
    GOTO KESME
MAIN
    BANKSEL TRISB
    CLRF TRISB
    CLRF TRISD
    BSF TRISC,7
    BANKSEL PORTB
    CLRF PORTB
    CLRF PORTD
    BSF PORTB,2
    BCF PORTB,3
    BANKSEL SAY
    MOVLW 0X04
    MOVWF SAY
    BANKSEL SPBRG
    MOVLW D'25'
    MOVWF SPBRG
    BANKSEL TXSTA
    MOVLW B'00100100'
    MOVWF TXSTA
    BANKSEL RCSTA
    MOVLW B'10000000'
    MOVWF RCSTA
    BANKSEL INTCON
    BSF INTCON,GIE
    BSF INTCON,PEIE
    BANKSEL PIE1
    BSF PIE1,TXIE
DONGU    
    GOTO DONGU
KESME    
    BANKSEL PIR1
    BTFSC PIR1,TXIF
    CALL KONTROL
    BCF PIR1,TXIF
    RETFIE
KONTROL
    DECFSZ SAY,F
    GOTO GONDER
    MOVLW 0X04
    MOVWF SAY
    RETURN
GONDER
    MOVFW SAY
    CALL LOOKUP
    MOVWF TXREG
    CALL BEKLEME
    GOTO KONTROL
LOOKUP
    ADDWF PCL,F    
    RETLW ' '
    RETLW 'S'
    RETLW 'O'
    RETLW 'S'
    RETURN
BEKLEME
    MOVLW 0X30
    MOVWF BEKLE
BEKLEME2
    MOVLW 0X80
    MOVWF BEKLE2
BEKLEMEDONGU
    DECFSZ BEKLE2,F
    GOTO BEKLEMEDONGU
    DECFSZ BEKLE,F
    GOTO BEKLEME2
    RETURN    
    END
