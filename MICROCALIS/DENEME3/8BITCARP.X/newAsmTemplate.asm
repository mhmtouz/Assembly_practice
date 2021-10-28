    LIST P=16F877A
    #INCLUDE <P16F877A.INC>
    SAYI1 EQU 0X24
    SAYI2 EQU 0X25
    SAYAC EQU 0X26
    SONUCL EQU 0X27
    SONUCH EQU 0X28
    ORG 0X00
    GOTO MAIN
MAIN
    BANKSEL TRISB
    CLRF TRISB
    BSF PORTA,1
    BANKSEL PORTD
    CLRF PORTB
    CLRF PORTA
    MOVLW D'100'
    MOVWF SAYI1
    MOVLW D'200'
    MOVWF SAYI2
    CLRW
ISLEM
    ADDWF SAYI1,W
    MOVWF SONUCL
    BTFSS STATUS,C
    GOTO L
    GOTO H
L
    DECFSZ SAYI2,F
    BSF SAYAC
    GOTO ISLEM
    GOTO SON
H
    BCF STATUS,C
    BCF SAYAC
    INCF SONUCH
    DECFSZ SAYI2,F
    GOTO ISLEM
    GOTO SON
BUTONLAR
    BTFSS SAYAC
    MOVLW SONUCH
    MOVLW SONUCL
    MOVWF PORTB    
SON
    END
    


