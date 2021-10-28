LIST P=16F877A
#INCLUDE <P16F877A.INC>
__CONFIG _CP_OFF &_WDT_OFF &_HS_OSC &_PWRTE_OFF

SAYI0 EQU 0X20
SAYI1 EQU 0X21
SAYI2 EQU 0X22
BIRLER EQU 0X23
ONLAR EQU 0X24
YUZLER EQU 0X25
BINLER EQU 0X26
TEMP1 EQU 0X27
TEMP2 EQU 0X28
TEMP3 EQU 0X29
TEMP4 EQU 0X30
TEMP EQU 0X31



ORG 0X00
GOTO PROGRAM
ORG 0X04
GOTO PROGRAM


PROGRAM
BANKSEL TRISB
CLRF TRISB
MOVLW B'11110000'
MOVWF TRISD
BANKSEL PORTB
CLRF PORTB
CLRF PORTD
MOVLW .0
MOVWF BINLER
MOVWF YUZLER
MOVWF ONLAR
MOVWF BIRLER


LOOP
CALL GOSTER
CALL TUSTARA
GOTO LOOP


TUSTARA
MOVLW B'11110111'
MOVWF PORTD
BTFSC PORTD,4
GOTO B2
MOVLW .0
MOVWF ONLAR
MOVLW .1
MOVWF BIRLER
RETURN
B2
BTFSC PORTD,5
GOTO B3
MOVLW .0
MOVWF ONLAR
MOVLW .2
MOVWF BIRLER
RETURN
B3
BTFSC PORTD,6
GOTO B4
MOVLW .0
MOVWF ONLAR
MOVLW .3
MOVWF BIRLER
RETURN
B4
BTFSC PORTD,7
GOTO B5
MOVLW .0
MOVWF ONLAR
MOVLW .4
MOVWF BIRLER
RETURN


B5
MOVLW B'11111011'
MOVWF PORTD
BTFSC PORTD,4
GOTO B6
MOVLW .0
MOVWF ONLAR
MOVLW .5
MOVWF BIRLER
RETURN
B6
BTFSC PORTD,5
GOTO B7
MOVLW .0
MOVWF ONLAR
MOVLW .6
MOVWF BIRLER
RETURN
B7
BTFSC PORTD,6
GOTO B8
MOVLW .0
MOVWF ONLAR
MOVLW .7
MOVWF ONLAR
RETURN
B8
BTFSC PORTD,7
GOTO B9
MOVLW .0
MOVWF ONLAR
MOVLW .8
MOVWF BIRLER
RETURN



B9
MOVLW B'11111101'
MOVWF PORTD
BTFSC PORTD,4
GOTO B10
MOVLW .0
MOVWF ONLAR
MOVLW .9
MOVWF BIRLER
RETURN
B10
BTFSC PORTD,5
GOTO B11
MOVLW .1
MOVWF ONLAR
MOVLW .0
MOVWF BIRLER
RETURN
B11
BTFSC PORTD,6
GOTO B12
MOVLW .1
MOVWF ONLAR
MOVLW .1
MOVWF ONLAR
RETURN
B12
BTFSC PORTD,7
GOTO B13
MOVLW .1
MOVWF ONLAR
MOVLW .2
MOVWF BIRLER
RETURN


B13
MOVLW B'11111110'
MOVWF PORTD
BTFSC PORTD,4
GOTO B14
MOVLW .1
MOVWF ONLAR
MOVLW .3
MOVWF BIRLER
RETURN
B14
BTFSC PORTD,5
GOTO B15
MOVLW .1
MOVWF ONLAR
MOVLW .4
MOVWF BIRLER
RETURN
B15
BTFSC PORTD,6
GOTO B16
MOVLW .1
MOVWF ONLAR
MOVLW .5
MOVWF ONLAR
RETURN
B16
BTFSC PORTD,7
RETURN
MOVLW .1
MOVWF ONLAR
MOVLW .6
MOVWF BIRLER
RETURN



GOSTER
MOVLW B'00001000'
MOVWF PORTB
MOVF BIRLER,W
MOVWF PORTD
CALL BEKLE
MOVLW B'00000100'
MOVWF PORTB
MOVF ONLAR,W
MOVWF PORTD
CALL BEKLE
MOVLW B'00000010'
MOVWF PORTB
MOVF YUZLER,W
MOVWF PORTD
CALL BEKLE
MOVLW B'00000001'
MOVWF PORTB
MOVF BINLER,W
MOVWF PORTD
CALL BEKLE
CLRF PORTB
RETURN

BEKLE
BANKSEL SAYI0
MOVLW .50
MOVWF SAYI0
BEKLE1
MOVLW .50
MOVWF SAYI1
BEKLE2
MOVLW .50
MOVWF SAYI2
BEKLE3
DECFSZ SAYI2,F
GOTO BEKLE3
DECFSZ SAYI1,F
GOTO BEKLE2
DECFSZ SAYI0,F
GOTO BEKLE1
RETURN







END