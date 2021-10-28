    LIST P=16F877A
    #INCLUDE <P16F877A.INC>
    __CONFIG H'3F31'
    SAYAC EQU 0X20
    BEKLE EQU 0X22
    BEKLE2 EQU 0X23 
    TEMP EQU 0X24
    ORG 0X00
    GOTO MAIN
    ORG 0X04
KESME
    BANKSEL RCREG
    MOVFW RCREG	;BAK
    CALL DATAWRITE
    RETFIE
MAIN
    BANKSEL TRISB
    CLRF TRISB
    CLRF TRISD
    BSF TRISC,7
    BANKSEL PORTB
    CLRF PORTB
    CLRF PORTD
    
    CALL LCDREADY
    
    BSF PORTB,2
    BCF PORTB,3
    BANKSEL SPBRG
    MOVLW B'00011001'	;BAK    BAUD RATE:25
    MOVWF SPBRG
    BANKSEL TXSTA
    MOVLW B'00000100'	;BAK
    MOVWF TXSTA
    BANKSEL RCSTA
    MOVLW B'10010000'	;BAK
    MOVWF RCSTA
    BANKSEL INTCON
    BSF INTCON,GIE
    BSF INTCON,PEIE
    BANKSEL PIE1
    BSF PIE1,RCIE	;BAK
DONGU 
    GOTO DONGU
LCDREADY
    MOVLW 0X02
    CALL CMDWRITE
    MOVLW 0X28		;BAK
    CALL CMDWRITE
    MOVLW 0X0C
    CALL CMDWRITE
    MOVLW 0XC0
    CALL CMDWRITE
    RETURN
CMDWRITE
    MOVWF TEMP
    SWAPF TEMP,W
    CALL CMDSEND
    MOVF TEMP,W
    CALL CMDSEND
    RETURN
CMDSEND
    ANDLW 0X0F
    BANKSEL PORTB
    MOVWF PORTB
    BANKSEL PORTB
    BCF PORTB,4
    BSF PORTB,5
    CALL BEKLEME
    BCF PORTB,5
    RETURN
DATAWRITE
    MOVWF TEMP
    SWAPF TEMP,W
    CALL DATASEND
    MOVF TEMP,W
    CALL DATASEND
    RETURN
DATASEND
    ANDLW 0X0F

    BANKSEL PORTB
    MOVWF PORTB
    BANKSEL PORTB
    BSF PORTB,4
    BSF PORTB,5
    CALL BEKLEME
    BCF PORTB,5
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



