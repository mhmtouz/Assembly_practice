 #INCLUDE <P16F877A.INC>
    __CONFIG H'3F31'
    SAYAC EQU 0X20
    KESMESAYAC EQU 0X21
    SAYAC_BIRLER EQU 0X22
    SAYAC_ONLAR EQU 0X24
    BEKLE EQU 0X25
    BEKLE2 EQU 0X26
    ORG 0X00
    GOTO MAIN
    ORG 0X04
    GOTO KESME
MAIN
    BANKSEL TRISB
    CLRF TRISB 
    BANKSEL TRISA
    CLRF TRISA 
    MOVLW 0X06
    MOVWF ADCON1
    BANKSEL PORTB
    CLRF PORTB
    BANKSEL PORTA
    CLRF PORTA
    MOVLW D'10'
    MOVWF SAYAC          
    MOVLW D'0'
    MOVWF SAYAC_BIRLER
    MOVWF SAYAC_ONLAR
    BANKSEL TMR1H
    MOVLW H'3C'
    MOVWF TMR1H
    MOVLW H'B0'
    MOVWF TMR1L
    BANKSEL INTCON
    MOVLW B'11000000'
    MOVWF INTCON
    BANKSEL PIE1
    BSF PIE1,TMR1IE
    BANKSEL T1CON
    BCF T1CON,T1CKPS1
    BSF T1CON,T1CKPS0
    BSF T1CON,TMR1ON
DONGU
    GOTO DONGU  
KESME
    BANKSEL PIR1
    BCF PIR1,TMR1IF
    BANKSEL TMR1H
    INCF KESMESAYAC
    MOVLW H'3C'
    MOVWF TMR1H
    MOVLW H'B0'
    MOVWF TMR1L
    DECFSZ SAYAC,F
    RETFIE
    CALL KNT
    MOVLW D'10'
    MOVWF SAYAC  
    RETFIE
KNT
    MOVFW SAYAC_ONLAR
    SUBLW D'6'
    BTFSS STATUS,Z
    GOTO GOSTERB
    RETURN
GOSTERB
    BSF PORTA,1
    BCF PORTA,0
    MOVFW SAYAC_ONLAR
    CALL LOOKUP_ONLAR
    MOVWF PORTB
    CALL BEKLEME
    INCF SAYAC_ONLAR
    MOVFW SAYAC_BIRLER
    SUBLW D'10'
    BTFSS STATUS,Z
    GOTO GOSTERO
    CALL BASTAN 
GOSTERO
    BSF PORTA,1
    BCF PORTA,0
    MOVFW SAYAC_BIRLER
    CALL LOOKUP_BIRLER
    MOVWF PORTB
    INCF SAYAC_BIRLER
    CALL BEKLEME
BASTAN
    CLRF SAYAC_ONLAR
    CLRF SAYAC_BIRLER
    RETURN
LOOKUP_BIRLER
    ADDWF PCL,F
    RETLW B'11000000' ;0
    RETLW B'11111001' ;1                            
    RETLW B'10100100' ;2    
    RETLW B'10110000' ;3
    RETLW B'10011001' ;4
    RETLW B'10010010' ;5
    RETLW B'10000010' ;6
    RETLW B'11111000' ;7
    RETLW B'10000000' ;8    
    RETLW B'10010000' ;9
    RETURN
LOOKUP_ONLAR
    ADDWF PCL,F    
    RETLW B'11000000' ;0
    RETLW B'11111001' ;1                            
    RETLW B'10100100' ;2    
    RETLW B'10110000' ;3
    RETLW B'10011001' ;4
    RETLW B'10010010' ;5
BEKLEME
    MOVLW D'255'
    MOVWF BEKLE
BEKLEME2
    MOVLW D'255'
    MOVWF BEKLE2  
BEKLEMEDONGU
    DECFSZ BEKLE2,F
    GOTO BEKLEMEDONGU
    DECFSZ BEKLE,F
    GOTO BEKLEME2
    RETURN 
    END
    

