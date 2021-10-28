    LIST P=16F877A
    #INCLUDE <P16F877A.INC>
    __CONFIG H'3F32'
    SAYI EQU 0X20
    TEMP EQU 0X21
    BEKLE EQU 0X22
    BEKLE2 EQU 0X23
    ORG 0X00
MAIN
    BANKSEL TRISB
    CLRF TRISB
    BANKSEL PORTB
    CLRF PORTB
    MOVLW D'5'
    MOVWF SAYI
    CALL TEMIZLE
    GOTO ISLEM
TEMIZLE
    MOVLW 0X02
    CALL CMDYAZ
    MOVLW 0X28
    CALL CMDYAZ
    MOVLW 0X0C
    CALL CMDYAZ
    RETURN
CMDYAZ
    MOVWF TEMP
    SWAPF TEMP,W
    CALL CMDGONDER
    MOVFW TEMP
    CALL CMDGONDER
    RETURN
CMDGONDER
    ANDLW 0X0F
    BANKSEL PORTB
    MOVWF PORTB
    BANKSEL PORTB
    BCF PORTB,4
    BSF PORTB,5
    CALL BEKLEME
    BCF PORTB,5
    RETURN
VERIYAZ
    MOVWF TEMP
    SWAPF TEMP,W
    CALL VERIGONDER
    MOVFW TEMP
    CALL VERIGONDER
    RETURN
VERIGONDER
    ANDLW 0X0F
    BANKSEL PORTB
    MOVWF PORTB
    BANKSEL PORTB
    BSF PORTB,4
    BSF PORTB,5
    CALL BEKLEME
    BCF PORTB,5
    RETURN
ISLEM
    MOVLW 0X80
    CALL CMDYAZ
    MOVLW A'S'
    CALL VERIYAZ
    
    MOVLW 0X81
    CALL CMDYAZ
    MOVLW A'O'    
    CALL VERIYAZ
    
    MOVLW 0X82
    CALL CMDYAZ    
    MOVLW A'S' 
    CALL VERIYAZ
    GOTO ISLEM
BEKLEME
    MOVLW 0XA0
    MOVWF BEKLE
BEKLEME2
    MOVLW 0X70
    MOVWF BEKLE2
BEKLEMEDONGU
    DECFSZ BEKLE2,F
    GOTO BEKLEMEDONGU
    DECFSZ BEKLE,F
    GOTO BEKLEME2
    RETURN  
END

