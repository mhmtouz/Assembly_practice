    LIST P=16F877A
    #INCLUDE <P16F877A.INC>
    __CONFIG H'3F31'
    KESMESAYAC EQU 0X20
    TEMP EQU 0X21 
    BEKLE EQU 0X22
    BEKLE2 EQU 0X23
    SAYAC1 EQU 0X27
    SAYAC10 EQU 0X28
    SAYAC100 EQU 0X29
    SAYAC1K EQU 0X30
    SAYAC10K EQU 0X31
    SAYAC100K EQU 0X32 
    ORG 0X00
    GOTO MAIN
    ORG 0X04
    GOTO KESME
MAIN
    BANKSEL TRISB
    CLRF TRISD
    MOVLW 0X06
    MOVWF ADCON1
    BSF TRISA,0    
    BSF TRISA,1
    BANKSEL PORTB
    BSF PORTB,2
    BCF PORTB,3
    BANKSEL PORTD
    CLRF PORTD
    BANKSEL SAYAC1
    MOVLW 0X05
    MOVWF KESMESAYAC
    MOVLW 0X01
    MOVWF SAYAC100
    CLRF SAYAC10
    CLRF SAYAC1
    CLRF SAYAC100K
    CLRF SAYAC10K
    CLRF SAYAC1K    
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
    CALL LCDCLEAR
    ;L1 KESME ILE OTO ARTTIRMA
DONGU
    GOTO DONGU
KESME
    BANKSEL PIR1
    BCF PIR1,TMR1IF
    BANKSEL TMR1H
    MOVLW H'3C'
    MOVWF TMR1H
    MOVLW H'B0'
    MOVWF TMR1L
    DECFSZ KESMESAYAC,F
    GOTO CNTRLBUTON
    CALL WRITEKESME
    MOVLW 0X05
    MOVWF KESMESAYAC
    RETFIE
WRITEKESME    
    CALL LCDCLEAR
    
    MOVLW 0X82
    CALL CMDWRITE
    MOVFW SAYAC1K
    CALL LOOKUP
    CALL DATAWRITE
    
    MOVLW 0X81
    CALL CMDWRITE
    MOVFW SAYAC10K
    CALL LOOKUP
    CALL DATAWRITE

    MOVLW 0X80
    CALL CMDWRITE
    MOVFW SAYAC100K
    CALL LOOKUP
    CALL DATAWRITE
    
    CALL WRITE1K    
    RETURN
WRITE1K
    MOVLW 0X09
    SUBWF SAYAC1K,W
    BTFSC STATUS,Z
    GOTO WRITE10K
    INCF SAYAC1K
    RETURN
WRITE10K
    CLRF SAYAC1K
    BSF STATUS,Z
    MOVLW 0X09
    SUBWF SAYAC10K,W
    BTFSS STATUS,Z
    GOTO INC10K
    GOTO WRITE100K
INC10K
    INCF SAYAC10K
    GOTO WRITEKESME
WRITE100K
    CLRF SAYAC10K    
    BSF STATUS,Z
    MOVLW 0X01
    SUBWF SAYAC100K,W
    BTFSC STATUS,Z
    GOTO CLRALLK
    INCF SAYAC100K
    GOTO WRITEKESME
CLRALLK
    CLRF SAYAC1K
    CLRF SAYAC10K
    CLRF SAYAC100K
    GOTO WRITEKESME
 ;----------------------------------L2 BUTTON ?LE ARTTIRMA-------------------------------
LCDCLEAR
    MOVLW 0X02
    CALL CMDWRITE
    MOVLW 0X0C
    CALL CMDWRITE
    MOVLW 0X28
    CALL CMDWRITE
    RETURN
CMDWRITE
    CALL CMDSEND
    RETURN
CMDSEND
    MOVWF PORTB
    BANKSEL PORTB    
    BCF PORTB,4
    BCF PORTB,5
    BSF PORTB,6
    CALL BEKLEME
    BCF PORTB,6
    RETURN 
WRITE
    CALL LCDCLEAR
    MOVLW 0X0A
    SUBWF SAYAC1,W
    BTFSC STATUS,Z
    GOTO WRITE10
    
    MOVLW 0XC2
    CALL CMDWRITE
    MOVFW SAYAC1
    CALL LOOKUP
    CALL DATAWRITE
    
    MOVLW 0XC1
    CALL CMDWRITE
    MOVFW SAYAC10
    CALL LOOKUP
    CALL DATAWRITE

    MOVLW 0XC0
    CALL CMDWRITE
    MOVFW SAYAC100
    CALL LOOKUP
    CALL DATAWRITE
    GOTO CNTRLBUTON
WRITE10
    CLRF SAYAC1
    MOVLW 0X09
    SUBWF SAYAC10,W
    BTFSS STATUS,Z
    GOTO INC10
    GOTO WRITE100
INC10
    INCF SAYAC10
    GOTO WRITE
WRITE100
    CLRF SAYAC10 
    MOVLW 0X02
    SUBWF SAYAC100,W
    BTFSC STATUS,Z
    GOTO CLRALL
    INCF SAYAC100
    GOTO WRITE
CLRALL
    CLRF SAYAC1
    CLRF SAYAC10
    CLRF SAYAC100
    GOTO WRITE
CNTRLBUTON
     BTFSC PORTA,0
     GOTO INCBUTTON
     BTFSC PORTA,1
     GOTO DECBUTTON
     BANKSEL PORTB
    BSF PORTB,2
    BCF PORTB,3
     RETFIE
INCBUTTON
    BTFSC PORTA,0
    GOTO INCBUTTON
    INCF SAYAC1
    MOVLW 0X09
    SUBWF SAYAC100,W
    BTFSC STATUS,Z
    CALL REFRESH2
    GOTO WRITE
REFRESH2    
    MOVLW 0X01
    MOVWF SAYAC100
    CLRF SAYAC10
    CLRF SAYAC1    
    RETURN
DECBUTTON    
    BTFSC PORTA,1
    GOTO DECBUTTON    
    CALL CNTRLDEC1
    GOTO WRITE
CNTRLDEC1
    MOVLW 0X00
    SUBWF SAYAC1,W
    BTFSC STATUS,Z    
    CALL CNTRLDEC10
    DECF SAYAC1
    RETURN
CNTRLDEC10
    MOVLW 0X0A
    MOVWF SAYAC1
    MOVLW 0X00
    SUBWF SAYAC10,W
    BTFSC STATUS,Z    
    CALL CNTRLDEC100
    DECF SAYAC10
    RETURN    
CNTRLDEC100 
    MOVLW 0X0A
    MOVWF SAYAC10    
    MOVLW 0X01
    SUBWF SAYAC100,W
    BTFSC STATUS,Z
    CALL REFRESH
    DECF SAYAC100
    RETURN
REFRESH
    MOVLW 0X0A
    MOVWF SAYAC100
    MOVWF SAYAC10
    MOVWF SAYAC1    
    RETURN
DATAWRITE
    CALL DATASEND
    RETURN
DATASEND
    MOVWF PORTB
    BANKSEL PORTB
    BSF PORTB,4
    BCF PORTB,5
    BSF PORTB,6
    CALL BEKLEME
    BCF PORTB,6
    RETURN
LOOKUP
    ADDWF PCL,F
    RETLW A'0'    
    RETLW A'1'
    RETLW A'2'
    RETLW A'3'
    RETLW A'4'
    RETLW A'5'
    RETLW A'6'
    RETLW A'7'    
    RETLW A'8'
    RETLW A'9'
    RETURN
BEKLEME
    MOVLW D'30'
    MOVWF BEKLE
BEKLEME2
    MOVLW D'80'
    MOVWF BEKLE2  
BEKLEMEDONGU
    DECFSZ BEKLE2,F
    GOTO BEKLEMEDONGU
    DECFSZ BEKLE,F
    GOTO BEKLEME2
    RETURN  
    END
