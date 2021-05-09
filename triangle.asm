Stacksg     SEGMENT PARA STACK 'STACK'
            DW 32 DUP(?)
Stacksg     ENDS
Datasg      SEGMENT PARA 'DATA'
Ucgendizi   DW 100 DUP(0) 
ELEMAN      DW ?
MSG1        DB 'ELEMAN SAYISINI VERINIZ:',0
MSG2        DB 'ELEMANLARI GIRINIZ:',0
MSG3        DB 'UYGUN KENAR YOK',0
MSG4        DB 'UYGUN KENARLAR:',0
MSG5        DB 'ONEMLI NOT:LUTFEN 3 BASAMAKLI SAYI GIRDIGINIZDE ENTER TUSUNA BASMAYINIZ!',0
Datasg      ENDS
Codesg      SEGMENT PARA 'CODE'
            ASSUME CS:Codesg,DS:Datasg,SS:Stacksg
            
MAIN        PROC FAR
            PUSH DS
            XOR AX,AX
            PUSH AX
            MOV AX,Datasg
            MOV DS,AX
            MOV AX, OFFSET MSG1
            CALL PUT_STR
            MOV DL,10
            MOV AH,02H
            INT 21H
            MOV DL,13
            MOV AH,02H
            INT 21H
            XOR AX,AX       ;Registerlar 0 lanir
            XOR BX,BX 
            XOR CX,CX
            XOR DX,DX
            XOR SI,SI
            
Elemansayi: MOV AH,00H
            INT 16H
            CMP AL,0DH
            JE CIK
            MOV AH,0EH
            INT 10H
            SUB AL,30H
            XOR AH,AH
            MOV BX,10
            XCHG AX,CX
            MUL BX
            ADD AX,CX
            XCHG AX,CX
            JMP Elemansayi 
            
CIK:        MOV DL,10
            MOV AH,02H
            INT 21H
            MOV DL,13
            MOV AH,02H
            INT 21H    
            MOV ELEMAN,CX
            MOV AX,OFFSET MSG2
            CALL PUT_STR
            MOV DL,10
            MOV AH,02H
            INT 21H
            MOV DL,13
            MOV AH,02H
            INT 21H
            MOV AX, OFFSET MSG5
            CALL PUT_STR
            MOV DL,10
            MOV AH,02H
            INT 21H
            MOV DL,13
            MOV AH,02H
            INT 21H
            XOR AX,AX
            XOR DX,DX
            XOR BX,BX

            
Basadon:    MOV AH,00H
            INT 16H
            CMP AL,0DH
            JE Enter
            JMP Karakter
            
Karakter:   CMP AL,47
            JA Buyuk
            JMP Basadon
            
Buyuk:      CMP AL,58
            JB Kucuk
            JMP Basadon
            
Kucuk:      MOV AH,0EH
            INT 10H
            SUB AL,30H
            XOR AH,AH     ;Sadece al den alinan degeri kontrol eddebilmek icin ah 0 lanir
            PUSH CX
            MOV CX,10
            XCHG AX,DX
            PUSH BX       ;MUL isleminde DX yazmacinin degeri degistigi icin kisa sureligine BX yazmacinda degeri sakliyoruz
            MOV BX,DX
            MUL CX  
            MOV DX,BX
            POP BX
            ADD AX,DX
            XCHG AX,DX
            POP CX        
            INC BX
            CMP BX,3      ;Basamak sayisi kontrolunu yapar
            JE Enter
            JMP Basadon
            
Enter:      MOV Ucgendizi[SI],DX
            MOV DL,10
            MOV AH,02H
            INT 21H
            MOV DL,13
            MOV AH,02H
            INT 21H
            XOR DX,DX
            XOR BX,BX
            ADD SI,2
            LOOP Basadon
            
            MOV CX,ELEMAN               ;BUBBLE SORT
            DEC CX
            XOR AX,AX
L2:         PUSH CX
            XOR SI,SI
            MOV CX,ELEMAN
            DEC CX
L1:         MOV AX,Ucgendizi[SI]
            CMP AX,Ucgendizi[SI+2]
            JBE Next
            XCHG AX,Ucgendizi[SI+2]
            MOV Ucgendizi[SI],AX
Next:       ADD SI,2
            LOOP L1
            POP CX
            LOOP L2
            
            XOR DX,DX
            XOR BX,BX
            XOR AX,AX
            XOR DI,DI
            XOR SI,SI
            ADD DI,2
            MOV DL,2
            MOV CX,ELEMAN
            SUB CX,2
            
L4:         PUSH CX
            MOV CX,ELEMAN
            SUB CX,2
            MOV AX,SI
            DIV DL
            XOR AH,AH
            SUB CX,AX         
L3:         MOV BX,Ucgendizi[SI]
            ADD BX,Ucgendizi[DI]
            ADD DI,2
            CMP BX,Ucgendizi[DI]
            JA CIKIS
            LOOP L3
            ADD SI,2
            MOV DI,SI
            ADD DI,2
            POP CX
            LOOP L4
            
            MOV AX,OFFSET MSG3
            CALL PUT_STR
            JMP BITIS
               
            
            
CIKIS:      XOR AX,AX
            MOV AX,OFFSET MSG4
            CALL PUT_STR
            MOV DL,10           ;\n
            MOV AH,02H          ;
            INT 21H             ;
            MOV DL,13           ;
            MOV AH,02H          ;
            INT 21H             ;
            XOR AX,AX
            MOV AX,Ucgendizi[SI]
            CALL PUTN
            MOV DL,10           ;\n
            MOV AH,02H          ;
            INT 21H             ;
            MOV DL,13           ;
            MOV AH,02H          ;
            INT 21H             ;
            MOV AX,Ucgendizi[DI-2]
            CALL PUTN           
            MOV DL,10           ;\n
            MOV AH,02H          ;
            INT 21H             ;
            MOV DL,13           ;
            MOV AH,02H          ;
            INT 21H             ;
            MOV AX,Ucgendizi[DI]
            CALL PUTN

            
BITIS:      RETF
MAIN        ENDP 
            
            
PUTC        PROC NEAR
            PUSH AX
            PUSH DX
            MOV DL,AL
            MOV AH,2
            INT 21H
            POP DX
            POP AX
            RET
PUTC        ENDP  
            
            
PUTN        PROC NEAR
            PUSH CX
            PUSH DX
            XOR DX,DX
            PUSH DX
            MOV CX,10
CALC_DIGITS:DIV CX
            ADD DX,'0'
            PUSH DX
            XOR DX,DX
            CMP AX,0
            JNE CALC_DIGITS
DISP_LOOP:  POP AX
            CMP AX,0
            JE END_DISP_LOOP
            CALL PUTC
            JMP DISP_LOOP
END_DISP_LOOP:POP DX
            POP CX
            RET
PUTN        ENDP                        
                       
                

PUT_STR     PROC NEAR
            PUSH BX
            MOV BX,AX
            MOV AL,BYTE PTR [BX]
PUT_LOOP:   CMP AL,0
            JE PUT_FIN
            CALL PUTC
            INC BX
            MOV AL,BYTE PTR [BX]
            JMP PUT_LOOP
PUT_FIN:    POP BX
            RET
PUT_STR     ENDP                                    



Codesg      ENDS
            END MAIN
                                                            
                                               

        