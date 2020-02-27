include "emu8086.inc"
.MODEL SMALL
.DATA
hour1 dw 0
minu dw 0
sec dw 0  

a db 0
b db 0
c db 0
d db 0
i db 0
j db 0  

ala db 0
alb db 0
alc db 0
ald db 0
ali db 0
alj db 0 
alf db 0
alg db 0
alh db 0 



ra db 0
rb db 0
rc db 0
rd db 0
ri db 0
rj db 0 
rf db 0
rg db 0
rh db 0 


f db 0
g db 0
h db 0 
w db 0 
hr dw 0
min dw 0

a1 db 0
b1 db 0
c1 db 0
d1 db 0
i1 db 0
j1 db 0 
msg db 100 dup(?) 

.CODE

START: 
MOV AX,@DATA
MOV DS,AX
menu:  
printn 
printn
printn
print '-------MENU-------  '
printn
print '    1-->DATE'
printn
print '    2-->REMINDER'
printn
print '    3-->TIME'
printn  
print '    4-->ALARM'
printn 
print '    5-->STOPWATCH'
printn 
print 'ENTER YOUR CHOICE   :'
call scan_num

cmp cx,1  
mov ah,0
int 10h
je date
cmp cx,2
mov ah,0
int 10h
je remainder
cmp cx,3     
mov ah,0
int 10h
je time
cmp cx,4
mov ah,0
int 10h
je alarm
cmp cx,5 
mov ah,0
int 10h
je stopwatch
jne inv
inv:
print 'INVALID'
jmp exitt 

stopwatch:
printn 
print "PRESS ANY KEY TO STOP TIMER"

infi2:
    mov hour1,0        
    mov minu,0  
    mov sec,0
        
        seco:
          
        
            inc sec
                    
                    
                    
                    
            set1:
            mov dh, 10
	mov dl, 10
	mov bh, 0
	mov ah, 2
	int 10h
	
            mov ax,hour1
            call print_num
            print ":" 
            mov ax,minu
            call print_num
            print ":"
            mov ax,sec
            call print_num  
            mov ah,01h
            int 16h
            jnz exit2
            jz cont
            
            
            cont:
            cmp sec,60 
            je incmin1
            jmp seco
            
    
incmin1:
cmp minu,60
jne incmin
jmp inchour


incmin: 
inc minu 
mov sec,0
jmp seco 


newday:
call infi2
     

inchour: 
inc hour1 
mov min,0 
mov sec,0 
jmp seco

inchour1:            
cmp hour1,24 
jne inchour  
jmp newday

exit2:
printn
print "TIMER STOPPED!"
mov ah,0
int 10h
jmp menu



alarm:
printn  
printn
setalarm:
printn
print "ENTER HOUR:"
mov ah,1
int 21h
mov ala,al 
mov ah,1
int 21h
mov alb,al 



printn
print "ENTER MIN:" 
mov ah,1
int 21h
mov alc,al 
mov ah,1
int 21h
mov ald,al 


jmp alcompare



   

loopalarm:
mov ah,01h
int 16h
jnz menu
alset3:
mov dh,0
mov dl,10
mov bh, 0
mov ah, 2
int 10h
printn 



alhour:
mov ah,2ch    
int 21h
mov al,ch 

aam
mov bx,ax
call dispal

mov dl,':'
mov ah,02h    
int 21h


alminutes:
mov ah,2ch    
int 21h
mov al,cl     
aam
mov bx,ax
call dispal2

mov dl,':'    
mov ah,02h
int 21h 





alseconds:
mov ah,2ch    
int 21h
mov al,dh     
aam
mov bx,ax
call dispal3
        
mov al,ch
cmp al,12
jnge am
print " pm"
jmp exit 
am:
print " am"        
 exit:
 nop  
 
alcompare:
mov al,alf 
cmp al,ala
jne loopalarm
1:
mov al,alg
cmp al,alb
jne loopalarm 
2:
mov al,alh
cmp al,alc
jne loopalarm
3:
mov al,ali
cmp al,ald
jne loopalarm 

 
mov cx,60
alinfi1:
albeep:

cmp cx,0
je allabel2
mov dl,7
mov ah,2
int 21h  
mov ah,01h
int 16h 
jnz allabel1    
loop alinfi1

allabel2:
printn
print "ALARM SNOOZED!"
mov ah,0
int 10h
jmp menu

allabel1:
printn
print "ALARM CLOSED!"
mov ah,0
int 10h 
jmp menu 

  


timereinitial:
mov a,0

mov b,0

mov c,0

mov d,0
 

        
jmp loopalarm




remainder:
printn
print "SET REMINDER:"
printn
printn 
print "ENTER REMINDER TEXT:"   
printn

    mov ax,@data
    mov ds,ax
    mov si,offset msg
take: mov ah,1
    int 21h
    mov [si],al
    cmp al,13
    je  getreminder
    inc si
    jmp take
  
display:mov ah,0
        int 10h
        mov [si],'$'
        mov dl,10
        mov ah,2
        int 21h
  
        lea di,msg
    
palo: mov dl,[di]
    cmp dl,'$'
    je stop
    cmp dl,' '
    je next
    mov ah,2
    int 21h
    inc di
    jmp palo
  
next: mov dl,10
    mov ah,2
    int 21h
    inc di
    jmp palo
  
stop:
printn 
print "HOPE WE REMINDED!"
jmp menu  
getreminder:
printn
print "ENTER DATE:"
mov ah,1
int 21h
mov a,al 
mov ah,1
int 21h
mov b,al 



printn
print "ENTER MONTH:" 
mov ah,1
int 21h
mov c,al 
mov ah,1
int 21h
mov d,al 


            
printn
print "ENTER YEAR:" 
mov ah,1
int 21h
mov i,al 
mov ah,1
int 21h
mov j,al 


DAY:
MOV AH,2AH    ; To get System Date
INT 21H
MOV AL,DL     ; Day is in DL
AAM
MOV BX,AX
CALL RDISP1

MOV DL,'/'
MOV AH,02H    ; To Print / in DOS
INT 21H

;Month Part
MONTH:
MOV AH,2AH    ; To get System Date
INT 21H
MOV AL,DH     ; Month is in DH
AAM
MOV BX,AX
CALL RDISP2

MOV DL,'/'    ; To Print / in DOS
MOV AH,02H
INT 21H

;Year Part
YEAR:
MOV AH,2AH    ; To get System Date
INT 21H
ADD CX,0F830H ; To negate the effects of 16bit value,
MOV AX,CX     ; since AAM is applicable only for AL (YYYY -> YY)
AAM
MOV BX,AX
CALL RDISP3


;To terminate the Program

;MOV AH,4CH     ; To Terminate the Program
;INT 21H 

 
compare:
mov al,a1 
cmp al,a
jne exit1
1:
mov al,b1
cmp al,b
jne exit1 
2:
mov al,c1
cmp al,c
jne exit1
3:
mov al,d1
cmp al,d
jne exit1
4:
mov al,i1
cmp al,i
jne exit1
5:
mov al,j1
cmp al,j
jne exit1
 
 printn
 print "ENTER THE TIME YOU WANT TO BE REMINDED:"
jmp reminderalarm

 
mov cx,100
infi1:
beep:
mov ah,01h
int 16h 
jnz label1 

mov dl,7
mov ah,2
int 21h  
   
loop infi1

;label2:
;printn
;print "ALARM SNOOZED!"
;jmp exit1

label1:
printn
print "HOPE WE REMINDED!"
printn
call display 
xor cx,cx
jmp menu 





  



 

        

date:
printn
print "DATE:" 
printn


DAYS:
MOV AH,2AH    
INT 21H
MOV AL,DL     
AAM
MOV BX,AX
CALL DDISP11

MOV DL,'/'
MOV AH,02H    
INT 21H

MONTHS:
MOV AH,2AH    
INT 21H
MOV AL,DH     
AAM
MOV BX,AX
CALL DDISP11

MOV DL,'/'    
MOV AH,02H
INT 21H

YEARS:
MOV AH,2AH    
INT 21H
ADD CX,0F830H 
MOV AX,CX     
AAM
MOV BX,AX
CALL DDISP11 
jmp menu
time:   

printn
print "TIME:"
loop1:
set:
    mov dh,0
    mov dl,70
    mov bh,0
    mov ah,2
    int 10h    
    printn
HOUR:
MOV AH,2CH   
INT 21H
MOV AL,CH     
AAM
MOV BX,AX
CALL TDISP22 

MOV DL,':'
MOV AH,02H    
INT 21H

MINUTES:
MOV AH,2CH   
INT 21H
MOV AL,CL     
AAM
MOV BX,AX
CALL TDISP22

MOV DL,':'   
MOV AH,02H
INT 21H

Seconds:
MOV AH,2CH    
INT 21H
MOV AL,DH    
AAM
MOV BX,AX
CALL TDISP33

jmp loop1 


reminderalarm:
printn  
setralarm:
printn
print "ENTER HOUR:"
mov ah,1
int 21h
mov ra,al 
mov ah,1
int 21h
mov rb,al 



printn
print "ENTER MIN:" 
mov ah,1
int 21h
mov rc,al 
mov ah,1
int 21h
mov rd,al 


jmp rcompare



   

loopralarm:
mov ah,01h
int 16h
jnz menu
rset3:
mov dh,0
mov dl,10
mov bh, 0
mov ah, 2
int 10h
printn 



rhour:
mov ah,2ch    
int 21h
mov al,ch 

aam
mov bx,ax
call rdispal

mov dl,':'
mov ah,02h    
int 21h


rminutes:
mov ah,2ch    
int 21h
mov al,cl     
aam
mov bx,ax
call rdispal2

mov dl,':'    
mov ah,02h
int 21h 





rseconds:
mov ah,2ch    
int 21h
mov al,dh     
aam
mov bx,ax
call rdispal3
        
mov al,ch
cmp al,12
jnge Ram
print " pm"
jmp Rexit 
Ram:
print " am"        
 Rexit:
 nop  
 
rcompare:
mov al,rf 
cmp al,ra
jne loopralarm
1:
mov al,rg
cmp al,rb
jne loopralarm 
2:
mov al,rh
cmp al,rc
jne loopralarm
3:
mov al,ri
cmp al,rd
jne loopralarm 

 
mov cx,100
rinfi1:
rbeep:
mov ah,01h
int 16h 
jnz rlabel1 

mov dl,7
mov ah,2
int 21h  
   
loop rinfi1

rlabel2:
printn
mov ah,0
int 10h   
call display
;print "HOPE WE REMINDED!" 


jmp menu

rlabel1:
printn  
mov ah,0
int 10h 
call display



jmp menu 

  


timereinitial2:
mov a,0

mov b,0

mov c,0

mov d,0
 

        
jmp loopralarm






TDISP22 PROC
MOV DL,BH     
ADD DL,30H 
;mov h,dl    
MOV AH,02H  
INT 21H
MOV DL,BL       
ADD DL,30H
;mov w,dl     
MOV AH,02H     
INT 21H
RET
TDISP22 ENDP   




DDISP11 PROC
MOV DL,BH      
ADD DL,30H     
MOV AH,02H     
INT 21H 
MOV DL,BL      
ADD DL,30H     
MOV AH,02H     
INT 21H
RET    
DDISP11 ENDP 
 
 




TDISP33 PROC
MOV DL,BH     
ADD DL,30H     
MOV AH,02H  
INT 21H
MOV DL,BL       
ADD DL,30H     
MOV AH,02H     
INT 21H
MOV AL,CH
CMP AL,12
JNGE Tam
print " PM"
JMP Texit
Tam:
print " AM"
Texit:
RET
TDISP33 ENDP    





RDISP1 PROC 
    printn
MOV DL,BH      ; Since the values are in BX, BH Part
ADD DL,30H     ; ASCII Adjustment
mov a1,dl

MOV AH,02H     ; To Print in DOS
INT 21H
MOV DL,BL      ; BL Part 
ADD DL,30H     ; ASCII Adjustment

mov b1,dl
MOV AH,02H     ; To Print in DOS
INT 21H
RET
RDISP1 ENDP      ; End Disp Procedure

RDISP2 PROC
MOV DL,BH      ; Since the values are in BX, BH Part
ADD DL,30H     ; ASCII Adjustment
mov c1,dl
MOV AH,02H     ; To Print in DOS
INT 21H
MOV DL,BL      ; BL Part 
ADD DL,30H     ; ASCII Adjustment
mov d1,dl
MOV AH,02H     ; To Print in DOS
INT 21H
RET
RDISP2 ENDP 


RDISP3 PROC
MOV DL,BH      ; Since the values are in BX, BH Part
ADD DL,30H     ; ASCII Adjustment
mov i1,dl
MOV AH,02H     ; To Print in DOS
INT 21H
MOV DL,BL      ; BL Part 
ADD DL,30H     ; ASCII Adjustment
mov j1,dl
MOV AH,02H     ; To Print in DOS
INT 21H
RET
RDISP3 ENDP    




dispal proc
mov dl,bh   
add dl,30h 
mov alf,dl    
mov ah,02h   
int 21h
mov dl,bl     
add dl,30h
mov alg,dl     
mov ah,02h   
int 21h 



rdispal proc
mov dl,bh   
add dl,30h 
mov rf,dl    
mov ah,02h   
int 21h
mov dl,bl     
add dl,30h
mov rg,dl     
mov ah,02h   
int 21h







ret
rdispal endp    



dispal2 proc
mov dl,bh    
add dl,30h
mov alh,dl     
mov ah,02h   
int 21h
mov dl,bl     
add dl,30h
mov ali,dl     
mov ah,02h     
int 21h    


ret
dispal2 endp     



rdispal2 proc
mov dl,bh    
add dl,30h
mov rh,dl     
mov ah,02h   
int 21h
mov dl,bl     
add dl,30h
mov ri,dl     
mov ah,02h     
int 21h    


ret
rdispal2 endp     



dispal3 proc
mov dl,bh      
add dl,30h     
mov ah,02h     
int 21h
mov dl,bl       
add dl,30h     
mov ah,02h     
int 21h
ret
dispal3 endp
               
               
               
rdispal3 proc
mov dl,bh      
add dl,30h     
mov ah,02h     
int 21h
mov dl,bl       
add dl,30h     
mov ah,02h     
int 21h
ret
rdispal3 endp


exit1:
nop  
exitt:
ret



DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS    
DEFINE_SCAN_NUM
END START      