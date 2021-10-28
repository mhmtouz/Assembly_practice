#INCLUDE<P16F877.INC>
;Erdogan Canbay Taraf�ndan Dizayn Edildi F�rat Universitesi Bilgisayar Muhendisligi Ogrencisi
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

MOVLW 0X00		;birler basama�� 
MOVWF BIRLER

MOVLW 0X09		;birler basama�� saya��
MOVWF SAYACB	;her 9 oldu�unda 0 a d�nmesi i�in 

MOVLW 0X00		;onlar basama�� (soldaki 7segment)
MOVWF ONLAR

MOVLW 0X0A		;onlar basama�� sayac� 9 oldugunda 0 a d�ns�n
MOVWF SAYACO

DONGU1
BSF PORTA,0
BCF PORTA,1		;porta,1 clear se�me ucuna gelen ver�y� okuyacakt�r
INCF BIRLER,F		;birler basama�� 1-1 artacakt�r
MOVF BIRLER,W	;birler basama��n�n anl�k de�eri workinge y�klenip
CALL RAKAMLAR	;rakamlardan de�er al�nacakt�r
MOVWF PORTB
CALL GECIKME

BCF PORTA,0		;onlar basama�� i�in porta,0 se�im ucu kullan�lm��t�r
BSF PORTA,1		;birler basama�� set edip kapand���nda onlar basama��na yaz�lacakt�r de�er
MOVF ONLAR,W	;lookup table dan de�er al�nacakt�r
CALL RAKAMLAR
MOVWF PORTB
CALL GECIKME
DECFSZ SAYACB		;her dongude sayac birler 1-1 azalacakt�r
CALL DONGU1

MOVLW 0X00		;sayac birler s�f�r olunca birler basam��ndaki rakam 9 olmu� demekt�r
MOVWF BIRLER		;tekrardan bu basama�� 0 yapaca��z 0-9 aras�nda s�rekli sayd���m�z i�in

MOVLW 0X09		;birler sayac� tekrardan 9 yap�l�yor
MOVWF SAYACB

DONGU2			;birler basama�� 9 oldu�u zaman tekrar 0 lad�k
BSF PORTA,1		;�imdi yapmam�z gereken soldaki rakam� yani onlar basama��n�
BCF PORTA,0		;1 art�rmak bu sayede 9 dan sonra 10
INCF ONLAR		; 19 dan sonra 20 .... 89 dan sonra 90 gelecektir
MOVF ONLAR,W
CALL RAKAMLAR
MOVWF PORTB
CALL GECIKME
DECFSZ SAYACO		;sayac onlarda s�f�r olduysa demektirki 99 say�s�n� g�r�yoruz �imdi b�t�n i�lemleri ba�a almam�z gerekiyor
CALL DONGU1

MOVLW 0X00		;99 olduysa b�t�n de�erleri ba�tan y�kleyip ilk d�ng�ye tekrar dallan�yoruz
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