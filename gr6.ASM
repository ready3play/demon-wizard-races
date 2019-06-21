           PAGE    80,132
;===================================================================
;                  PROGRAM LISTING 13.6
;
; PROGRAM TO MOVE A FACE AROUND THE SCREEN
;===================================================================
                                       ;PROCEDURES TO
           EXTRN   CLEAR:FAR           ;CLEAR VIDEO SCREEN
           EXTRN   DELAY:FAR           ;DELAY n SECONDS
           EXTRN   PUTSHAPE:FAR        ;DISPLAY A TEXTUAL SHAPE
           EXTERN  RANDOM:FAR
            EXTERN  RESEED:FAR
            EXTRN	PUTSTRNG:FAR
            EXTRN PUTDEC$:FAR
            EXTRN	NEWLINE:FAR

;===================================================================
           .MODEL  SMALL,BASIC
;===================================================================
; S T A C K   S E G M E N T   D E F I N I T I O N
;
           .STACK  512
;===================================================================
; D A T A   S E G M E N T   D E F I N I T I O N
           .DATA
playerx dw ?
playery dw ?
demonx dw ?
demony dw ?
UPPER           DW 3
LOWER           DW 0
spawnup dw 1
spawnlow     dw 20

FACE       DB      8,8               ;7 x 11 SHAPE
           DB      20h,07H,20H,07H,20H,07H,20H,07H,20H,07H,223,04H
           DB              223,04H,20H,07H
           DB      20H,07H,20H,07H,20H,07H,20H,07H,2FH,07H,20H,07H
           DB              20H,07H,5CH,07H
           DB      20H,07H,20H,07H,5FH,07H,5FH,07H,20H,07H,7cH,07H
           DB              7cH,07H,20H,07H
           DB      20H,07H,2FH,07H,2eH,07H,2eH,07H,5CH,07H,7cH,07H
           DB              7cH,07H,20H,07H
           DB      20H,07H,5cH,07H,5fH,07H,5fH,07H,2fH,07H,2FH,07H
           DB              20H,07H,20H,07H
           DB      20H,07H,2fH,07H,5bH,07H,5dH,07H,20H,07H,20H,07H
           DB              20H,07H,20H,07H
           DB      20H,07H,20H,07H,5bH,07H,5dH,07H,20H,07H,20H,07H
           DB              20H,07H,20H,07H
           DB      20H,07H,2fH,07H,20H,07H,20H,07H,5cH,07H,20H,07H
           DB              20H,07H,20H,07H
FACE2       DB      8,8               ;7 x 11 SHAPE
           DB      20H,07H,20H,07H,20H,07H,20H,07H,20H,07H,5fH,04H
           DB              5fH,04H,20H,07H
           DB      20H,07H,20H,07H,20H,07H,20H,07H,2FH,07H,20H,07H
           DB              20H,07H,5CH,07H
           DB      20H,07H,20H,07H,5FH,07H,5FH,07H,20H,07H,7cH,07H
           DB              7cH,07H,20H,07H
           DB      20H,07H,2FH,07H,2eH,07H,2eH,07H,5CH,07H,7cH,07H
           DB              7cH,07H,20H,07H
           DB      20H,07H,5cH,07H,5fH,07H,5fH,07H,2fH,07H,2FH,07H
           DB              20H,07H,20H,07H
           DB      20H,07H,2fH,07H,5bH,07H,5dH,07H,20H,07H,20H,07H
           DB              20H,07H,20H,07H
           DB      20H,07H,20H,07H,5bH,07H,5dH,07H,20H,07H,20H,07H
           DB              20H,07H,20H,07H
           DB      20H,07H,20H,07H,7cH,07H,7cH,07H,20H,07H,20H,07H
           DB              20H,07H,20H,07H
FACESpell1       DB      8,8               ;7 x 11 SHAPE
           DB      20H,07H,20H,07H,20H,07H,20H,07H,20H,07H,20H,07H
           DB              20H,07H,20H,07H
           DB      20H,07H,20H,07H,20H,07H,20H,07H,20H,07H,20H,07H
           DB              20H,07H,20H,07H
           DB      20H,07H,20H,07H,5FH,07H,5fH,07H,20H,07H,20H,07H
           DB              20H,07H,20H,07H
           DB      20H,07H,2FH,07H,2eH,07H,2eH,07H,5CH,07H,20H,07H
           DB              20H,07H,5cH,07H
           DB      20H,07H,5cH,07H,5fH,07H,5fH,07H,2fH,07H,5fH,07H
           DB              20h,07H,5fh,07H
           DB      20H,07H,2fH,07H,5bH,07H,5dH,07H,20H,07H,20h,07H
           DB              196,07H,196,07H
           DB      20H,07H,20H,07H,5bH,07H,5dH,07H,20H,07H,20H,07H
           DB              20H,07H,2fH,07H
           DB      20H,07H,20H,07H,7cH,07H,7cH,07H,20H,07H,20H,07H
           DB              20H,07H,20H,07H
SAD_MOUTH  DB      02,11               ;2 x 11 SHAPE
           DB      7CH,07H,20H,07H,20H,07H,20H,07H,5FH,07H,5FH,07H
           DB              5FH,07H,20H,07H
           DB      20H,07H,5CH,07H,20H,07H,2FH,07H,20H,07H,20H,07H
           DB              20H,07H,5CH,07H
PROJECTILE DB      1,5
           DB      20h,0eH,176,0cH,177,0cH,178,04H,219,04H
DEMON1     DB      10,12
           DB      20h,0CH,20h,0CH,20h,0CH,244,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH
           DB      20h,0CH,20h,0CH,169,0CH,224,0CH,170,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH
           DB      20h,0CH,168,0CH,248,0CH,20h,0CH,248,0CH,245,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH
           DB      20h,0CH,20h,0CH,92,0CH,153,0CH,47,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH
           DB      201,08H,205,08H,205,08H,215,08H,205,08H,187,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
           DB      186,08H,20h,08H,20h,08H,186,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
           DB      20h,08H,20h,08H,20h,08H,186,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
           DB      20h,08H,20h,08H,201,08H,188,08H,187,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
           DB      20h,08H,20h,08H,20h,08H,20h,08H,186,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
           DB      20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
DEMON2     DB      10,12
           DB      20h,0CH,20h,0CH,244,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH
           DB      20h,0CH,169,0CH,224,0CH,170,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH
           DB      168,0CH,248,0CH,20h,0CH,248,0CH,245,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH
           DB      20h,0CH,92,0CH,153,0CH,47,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH,20h,0CH
           DB      201,08H,205,08H,205,08H,215,08H,205,08H,187,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
           DB      20h,08H,20h,08H,20h,08H,186,08H,20h,08H,186,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
           DB      20h,08H,20h,08H,20h,08H,186,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
           DB      20h,08H,20h,08H,201,08H,188,08H,187,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
           DB      20h,08H,20h,08H,186,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
           DB      20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H,20h,08H
ending db 1,60

        db 080,07H,082,07H,079,07H,071,07H,082,07H,065,07H,077,07H,077,07H,069,07H,068,07H,032,07H
        db 066,07H,089,07H,032,07H,074,07H,065,07H,073,07H,032,07H,088,07H,073,07H,079,07H,078,07H,071,07H
        db 20H,07H,20H,07H,067,07H,073,07H,083,07H,080,07H,032,07H,051,07H,049,07H,048,07H,20H,07H,20H,07H,066,07H
        db 082,07H,085,07H,067,07H,069,07H,032,07H,068,07H,079,07H,085,07H,071,07H,076,07H,065,07H,083,07H,083,07H
        db 20H,07H,20H,07H,070,07H,065,07H,076,07H,076,07H,032,07H,050,07H,048,07H,049,07H,052,07H

trackline db 1,1
            db    240,0Fh

introd     DB      'Welcome to the Wizard and Demon Olympics of 100,000 BC!' 
introd2     DB      'The Wizard will shoot a fireball to START the race.' 
introd3    db '     Speeds of the demons are limited but RANDOM.'
spacess   db '     ' 
topwins db 1,25
        db 084,86H,104,86H,101,86H,032,86H,066,86H,111,86H,116,86H,116,86H,111,86H,109,86H,032,86H,068,86H,101,86H,109,86H,111,86H,110,86H,032,86H,104,86H,097,86H,115,86H,032,86H,119,86H
        db 111,86H,110,86H,033,86H 
botwins db 1,22
        db 084,86H,104,86H,101,86H,032,86H,084,86H,111,86H,112,86H,032,86H,068,86H,101,86H,109,86H,111,86H,110,86H,032,86H,072,86H,097,86H,115,86H,032,86H,087,86H,111,86H,110,86H,033,86H      
WINK       DB      1,1,2bh,86H         ;1 X 1 SHAPE
erase       DB      1,5,20h,07H,20h,07H,20h,07H,20h,07H,20h,07H,         ;1 X 1 SHAPE
;===================================================================
; C O D E   S E G M E N T   D E F I N I T I O N
;
           .CODE   EX_13_6
           .STARTUP                     ;GENERATE STARTUP CODE
;


MOV	AX,@DATA
		MOV	ES,AX
		MOV	DS,AX

           MOV     AH,15                ;GET PG <ACTIVE PAGE NO.>
           INT     10H


call clear
mov cx,10
.repeat
call newline
.if cx<=4
push cx

lea di,spacess
mov cx,5
call putstrng
pop cx
.endif
.untilcxz
mov cx, sizeof introd
lea di,introd
call putstrng



mov ax, 3
call delay

mov cx,5
.repeat
call newline
.if cx<=4
push cx

lea di,spacess
mov cx,5
call putstrng
pop cx
.endif
.untilcxz
mov cx, sizeof introd2
lea di,introd2
call putstrng

call newline
mov cx, sizeof introd3
lea di,introd3
call putstrng



mov ax, 5
call delay




           LEA     SI,FACE2              ;SPTR = ADDRESS OF FACE
           MOV     DH,1                 ;I = 3
           MOV     DL,1                ;J = 18
           MOV     AL,1
           MOV     CX,10                ;LOOP_CNT = 12


           .REPEAT                      ;REPEAT
           CALL    CLEAR                ;   CLEAR SCREEN
           INC     DH                   ;   I = I + 1
           ;INC     DL                   ;   J = J + 1
            LEA     SI,Face
           CALL    PUTSHAPE             ;   CALL PUTSHAPE(SPTR,PG,I,J)
           ;CALL    DELAY                ;   DELAY 1 SECOND

;==================================================================
           push cx
           push bx
           push ax
           push dx
MOV DI, 2
  MOV AH, 0
  INT 1Ah
  MOV BX, DX
  call Delau
           pop dx
           pop ax
           pop bx
           pop cx


;======================================================================

            LEA     SI,Face2         ;SPTR = ADDRESS OF SAD_MOUTH
           CALL    PUTSHAPE
;==================================================================
           push cx
           push bx
           push ax
           push dx
MOV DI, 2
  MOV AH, 0
  INT 1Ah
  MOV BX, DX
call delau
           pop dx
           pop ax
           pop bx
           pop cx

;======================================================================
           ;call delay
           .UNTILCXZ                    ;   LOOP_CNT = LOOP_CNT - 1
                                        ;UNTIL LOOP_CNT = 0
           ;ADD     DH,4                 ;I = I + 4

           call clear






           LEA     SI,facespell1         ;SPTR = ADDRESS OF SAD_MOUTH
           CALL    PUTSHAPE             ;CALL PUTSHAPE(SPTR,PG,I,J)
           MOV     AL,1                 ;DELAY 5 SECONDS
           CALL    DELAY
           LEA     SI,FACE              ;SPTR = ADDRESS OF WINK
           call putshape
 
           CALL    projshoot             ;CALL PUTSHAPE(SPTR,PG,I,J)

           call placing
           call startrace

racedone:

           CALL clear
           mov dl, 10
           mov dh, 9
        lea si,ending
        call putshape

           mov ax,5
           CALL    DELAY                ;DELAY 5 SECONDS
           call clear
           .EXIT                        ;RETURN TO DOS
;
;===================================================================
placing proc

mov dl,73
mov dh,15
lea si, demon1
call putshape
mov playerx, dx


mov dl,73
mov dh,3
lea si, demon1
call putshape
mov demonx, dx


ret



placing endp
;===================================================================
startrace proc
mov dh,14
mov dl,1 
mov cx,75
.repeat
inc dl
lea si, trackline
call putshape
.untilcxz

;==================
push cx
           push bx
           push ax
           push dx

MOV DI, 1
  MOV AH, 0
  INT 1Ah
  MOV BX, DX
call delau
pop dx
           pop ax
           pop bx
           pop cx





;==============

MOV     BL,0
CALL    RESEED 
MOV     AX,UPPER          
        PUSH    AX
        MOV     AX,LOWER            
        PUSH    AX
        CALL    RANDOM



mov dx, playerx
cmp dl,3
jle topwon
sub dl, al

lea si, demon1
call putshape
push cx

           push bx
           push ax
           push dx
MOV DI, 1
  MOV AH, 0
  INT 1Ah
  MOV BX, DX
call delau
           pop dx
           pop ax
           pop bx
           pop cx
           
lea si, demon2
call putshape
mov playerx,dx
           push cx
           push bx
           push ax
           push dx
MOV DI, 1
  MOV AH, 0
  INT 1Ah
  MOV BX, DX
call delau
           pop dx
           pop ax
           pop bx
           pop cx
;=============
;MOV     BL,0
;CALL    RESEED 
MOV     AX,UPPER          
        PUSH    AX
        MOV     AX,LOWER            
        PUSH    AX
        CALL    RANDOM



mov dx, demonx
cmp dl,3
jle botwon
sub dl, al

lea si, demon1
call putshape
push cx

           push bx
           push ax
           push dx
MOV DI, 1
  MOV AH, 0
  INT 1Ah
  MOV BX, DX
call delau
           pop dx
           pop ax
           pop bx
           pop cx
           
lea si, demon2
call putshape
mov demonx,dx
           push cx
           push bx
           push ax
           push dx
MOV DI, 1
  MOV AH, 0
  INT 1Ah
  MOV BX, DX
call delau
           pop dx
           pop ax
           pop bx
           pop cx

;===========


cmp dl, 1
jge startrace




ret

startrace endp
;===================================================================
topwon proc

mov dh, 2
mov dl, 2
lea si, topwins
call putshape
mov ax,5
call delay

jmp racedone
topwon endp
;===================================================================
botwon proc

mov dh, 2
mov dl, 2
lea si, botwins
call putshape
mov ax,5
call delay

jmp racedone
botwon endp
;===================================================================

Delau proc
  MOV AH, 0
  INT 1Ah
  SUB DX, BX
  CMP DI, DX
  JA Delau
  RET
  Delau endp
  
;============================
projshoot proc
add dh,5
add dl,10
mov cx, 65
.repeat
push cx

           push bx
           push ax
           push dx
MOV DI, 1
  MOV AH, 0
  INT 1Ah
  MOV BX, DX
call delau
           pop dx
           pop ax
           pop bx
           pop cx
           
lea si, projectile
call putshape
  inc dl
.untilcxz
call clear
lea si, erase
call putshape

  ret
  projshoot endp
;=============================
;============================
demonwalk proc

mov cx, 55
.repeat
lea si, demon1
call putshape
push cx

           push bx
           push ax
           push dx
MOV DI, 1
  MOV Ah, 0
  INT 1Ah
  MOV BX, DX
call delau
           pop dx
           pop ax
           pop bx
           pop cx
           
lea si, demon2
call putshape
           push cx
           push bx
           push ax
           push dx
MOV DI, 1
  MOV Ah, 0
  INT 1Ah
  MOV BX, DX
call delau
           pop dx
           pop ax
           pop bx
           pop cx


 MOV     AX,spawnup          
        PUSH    AX
        MOV     AX,spawnlow            
        PUSH    AX
        CALL    RANDOM          
  sub dl,al
.untilcxz
  ret
  demonwalk endp
;============================
spawn proc
call clear
mov cx,5
push cx
.repeat


MOV     BL,0
CALL    RESEED 
MOV     AX,spawnup          
        PUSH    AX
        MOV     AX,spawnlow            
        PUSH    AX
        CALL    RANDOM

mov dl,73
sub DH,Al
call demonwalk

.untilcxz
pop cx
ret

spawn endp
;=============================
introduc proc

lea di,introd
mov cx,sizeof introd
call putstrng

mov ax, 5
call delay
ret
introduc endp
;============================
           END

