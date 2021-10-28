#INCLUDE<P16F877.INC>
;Erdogan Canbay Tarafýndan Dizayn Edildi Fýrat Universitesi Bilgisayar Muhendisligi Ogrencisi
ORG 0X00

BIRLER EQU 0X21
ONLAR EQU 0X22
SAYACB EQU 0X23
SAYACO EQU 0X24

GEC1 EQU 0X25
GEC2 EQU 0X26

BANKSEL ADCON1
MOVLW 0X06
MOVWF ADCON1

CLRF TRISA
CLRF TRISB

BANKSEL PORTA
BSF PORTA,1
CLRF PORTB

MOVLW 0X00		;birler basamaðý 
MOVWF BIRLER

MOVLW 0X09		;birler basamaðý sayaçý
MOVWF SAYACB	;her 9 olduðunda 0 a dönmesi için 

MOVLW 0X00		;onlar basamaðý (soldaki 7segment)
MOVWF ONLAR

MOVLW 0X0A		;onlar basamaðý sayacý 9 oldugunda 0 a dönsün
MOVWF SAYACO

DONGU1
BSF PORTA,0
BCF PORTA,1		;porta,1 clear seçme ucuna gelen verýyý okuyacaktýr
INCF BIRLER,F		;birler basamaðý 1-1 artacaktýr
MOVF BIRLER,W	;birler basamaðýnýn anlýk deðeri workinge yüklenip
CALL RAKAMLAR	;rakamlardan deðer alýnacaktýr
MOVWF PORTB
CALL GECIKME

BCF PORTA,0		;onlar basamaðý için porta,0 seçim ucu kullanýlmýþtýr
BSF PORTA,1		;birler basamaðý set edip kapandýðýnda onlar basamaðýna yazýlacaktýr deðer
MOVF ONLAR,W	;lookup table dan deðer alýnacaktýr
CALL RAKAMLAR
MOVWF PORTB
CALL GECIKME
DECFSZ SAYACB		;her dongude sayac birler 1-1 azalacaktýr
CALL DONGU1

MOVLW 0X00		;sayac birler sýfýr olunca birler basamðýndaki rakam 9 olmuþ demektýr
MOVWF BIRLER		;tekrardan bu basamaðý 0 yapacaðýz 0-9 arasýnda sürekli saydýðýmýz için

MOVLW 0X09		;birler sayacý tekrardan 9 yapýlýyor
MOVWF SAYACB

DONGU2			;birler basamaðý 9 olduðu zaman tekrar 0 ladýk
BSF PORTA,1		;þimdi yapmamýz gereken soldaki rakamý yani onlar basamaðýný
BCF PORTA,0		;1 artýrmak bu sayede 9 dan sonra 10
INCF ONLAR		; 19 dan sonra 20 .... 89 dan sonra 90 gelecektir
MOVF ONLAR,W
CALL RAKAMLAR
MOVWF PORTB
CALL GECIKME
DECFSZ SAYACO		;sayac onlarda sýfýr olduysa demektirki 99 sayýsýný görüyoruz þimdi bütün iþlemleri baþa almamýz gerekiyor
CALL DONGU1

MOVLW 0X00		;99 olduysa bütün deðerleri baþtan yükleyip ilk döngüye tekrar dallanýyoruz
MOVWF BIRLER

MOVLW 0X09
MOVWF SAYACB

MOVLW 0X00
MOVWF ONLAR

MOVLW 0X0A
MOVWF SAYACO
CALL DONGU1

GECIKME
	MOVLW 0XF7
	MOVWF GEC1
DON1
	MOVLW 0X47
	MOVWF GEC2
DON2
	DECFSZ GEC2,F
	GOTO DON2
	DECFSZ GEC1
	GOTO DON1
RETURN

RAKAMLAR
ADDWF PCL,F
	RETLW h'3F'                              
	RETLW h'06'                             
	RETLW h'5B'                              
	RETLW h'4F'                             
	RETLW h'66'                             
	RETLW h'6D'                           
	RETLW h'7D'                             
	RETLW h'07'                             
	RETLW h'7F'
	RETLW h'6F'
RETURN
				;~~ www.mikroislemcim.com ~~
END