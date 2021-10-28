#iNCLUDE<P16F877.iNC>
ORG 0X00

;Erdogan Canbay Taraf�ndan Dizayn Edildi 
;F�rat Universitesi Bilgisayar Muhendisligi ��rencisi
;~~ WWW.mikroislemcim.com ~~

GOTO MAIN
MAIN
	CALL PORT_AYARLARI
	GOTO BUTON_KONTROL

PORT_AYARLARI
	BANKSEL TRISA
	CLRF TRISB
	BCF TRISC,2
	BSF TRISD,0
	BSF TRISD,1
	
	BANKSEL PORTA
	MOVLW B'00001100'
	MOVWF CCP1CON
	CLRF CCPR1L
	CLRF PORTB
	CLRF PORTC
	CLRF PORTD
RETURN

BUTON_KONTROL
	BANKSEL PORTA
	BTFSC PORTD,0
	GOTO ARTIM
	BTFSC PORTD,1
	GOTO AZALT
GOTO BUTON_KONTROL

ARTIM
	BTFSC PORTD,0
	GOTO ARTIM
	INCFSZ PORTB,F
	INCF CCPR1L,F
	GOTO BUTON_KONTROL
	
AZALT
	BTFSC PORTD,1 
	GOTO AZALT
	DECFSZ PORTB,F
	DECF CCPR1L,F
	GOTO BUTON_KONTROL
END