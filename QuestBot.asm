#start=robot.exe#
name "robot"  
; robot base i/o port:
r_port equ 9

call default_screen                  

;===================================
eternal_loop:
    
    call wait_robot         ; wait until the robot is ready
    call examine
    call examine              ; check if the object is a
                            ;  switched-on lamp
    jne lamp_off            ; if no, continue moving,
                            ; if yes switch it off 
    jmp  cont               ; then continue moving
    
    lamp_off: nop
    mov al, 4
    out r_port, al
    call wait_exam
    
         
    call switch_on_lamp     ; if the program gets here, it
                            ; means the lamp is off
    cont:
        call move 
        
call wait_robot
jmp eternal_loop            ; go again!
;===================================
examine proc
    mov al, 4               ; examine the object in front of robot
    out r_port, al
    call wait_exam
    in al, r_port + 1       ; get binary result
    cmp al, 0               ; check if the object is air 
    je cont                 ; if yes, continue moving
    cmp al, 255             ; check if the object is a wall
    je cont                 ; if yes, continue moving
    cmp al, 7 
    ret
examine endp
;===================================
; this procedure does not return until robot is ready to receive next command:
wait_robot proc
; check if robot busy:
busy: in al, r_port+2
      test al, 00000010b
      jnz busy              ; busy, so wait.
ret    
wait_robot endp
;===================================
; wait until the robot finished examining
wait_exam proc
; check if has new data:
busy2: in al, r_port+2
       test al, 00000001b
       jz busy2             ; no new data, so wait.
ret    
wait_exam endp
;===================================
; switch off the lamp:
switch_off_lamp proc
mov al, 6
out r_port, al
ret
switch_off_lamp endp
;===================================
; switch on the lamp:
switch_on_lamp proc
cmp counter, 0
je q1

cmp counter, 1
je q2

cmp counter, 2
je q3

cmp counter, 3
je q4

cmp counter, 4
je q5

cmp counter, 5
je q6

cmp counter, 6
je q7

cmp counter, 7 
je q8

q1: ;===============
call file_read

call ans  

cmp al, 'A'
je correct

cmp al, 'a'
je correct
jne wrong

q2: ;===============
call file_read

call ans

cmp al, 'D'
je correct

cmp al, 'd'
je correct
jne wrong

q3: ;===============
call file_read

call ans

cmp al, 'B'
je correct 

cmp al, 'b'
je correct
jne wrong

q4: ;===============
call file_read

call ans

cmp al, 'C'
je correct

cmp al, 'c'
je correct
jne wrong

q5: ;===============
call file_read

call ans

cmp al, 'A'
je correct

cmp al, 'a'
je correct
jne wrong

q6: ;===============
call file_read

call ans

cmp al, 'B'
je correct

cmp al, 'b'
je correct
jne wrong

q7: ;===============
call file_read

call ans

cmp al, 'C'
je correct

cmp al, 'c'
je correct
jne wrong 

q8: ;===============
call file_read

call ans

cmp al, 'B'
je correct

cmp al, 'b'
je correct
jne wrong

correct:
    call correct_answer
    jmp return
wrong:
    call incorrect_answer
    jmp return
return:
ret
switch_on_lamp endp
;===================================
; procedures for robot's movement
move proc
mov ah, 0
int 0x16
cmp ah, 0x48               ; if up arrow key is inputted, move forward
je forward
cmp ah, 0x4D               ; if right arrow key is inputted, turn right
je right
cmp ah, 0x4B               ; if left arrow key is inputted, turn left
je left 

forward:
mov al, 1
out r_port, al
ret 
 
right:
mov al, 3
out r_port, al
ret

left:
mov al, 2
out r_port, al
ret
move endp
;===================================
file_read proc
    call cls
    
    call nextline
    call nextline
    
    MOV AX, 3d02h
    cmp counter, 0
    je first_q
    cmp counter, 1
    je second_q
    cmp counter, 2
    je third_q
    cmp counter, 3
    je fourth_q
    cmp counter, 4
    je fifth_q
    cmp counter, 5
    je sixth_q
    cmp counter, 6
    je seventh_q
    cmp counter, 7
    je eighth_q
    
    first_q:            ; Open file function register,  3dh default register, add 02 to show output
	LEA DX, question1
	jmp continue
	
	second_q:
	LEA DX, question2
	jmp continue
	
	third_q:
	LEA DX, question3
	jmp continue
	
	fourth_q:
	LEA DX, question4
	jmp continue
	
	fifth_q:
	LEA DX, question5
	jmp continue
	
	sixth_q:
	LEA DX, question6
	jmp continue
	
	seventh_q:
	LEA DX, question7
	jmp continue
	
	eighth_q:
	LEA DX, question8
	jmp continue
	
	continue:                      ; DX has filename address and points to ASCII filename
	MOV CL, 1	        ; CL, file attribute and 1 for read-only attribute
	INT 21H		
	MOV HANDLE, AX	    ; AX is for file handle and store in HANDLE 
	JC  here	    ; Jump to CONDITION: if condition met 
	
    ;READING A FILE
    MOV	AH, 3fh       
    MOV	BX, HANDLE     
    MOV	CX, 150 
    
    cmp counter,2
    je str3
    cmp counter,3
    je str4
    cmp counter,4
    je str5
    cmp counter,5
    je str6
    cmp counter,6
    je str7
    cmp counter,7
    je str8
    jne default
    
    default:
    LEA	DX, STRING    
    INT	21h
    JC	here      
   
    MOV	AH, 09h       
    LEA	DX, STRING     
    INT	21h
    jmp close
    
    str3:   
    LEA	DX, STRING3    
    INT	21h
    JC	here      
   
    MOV	AH, 09h       
    LEA	DX, STRING3     
    INT	21h
    jmp close
    
    str4:   
    LEA	DX, STRING4    
    INT	21h
    JC	here      
   
    MOV	AH, 09h       
    LEA	DX, STRING4     
    INT	21h
    jmp close
    
    str5:   
    LEA	DX, STRING5    
    INT	21h
    JC	here      
   
    MOV	AH, 09h       
    LEA	DX, STRING5     
    INT	21h
    jmp close
    
    str6:   
    LEA	DX, STRING6    
    INT	21h
    JC	here      
   
    MOV	AH, 09h       
    LEA	DX, STRING6     
    INT	21h
    jmp close
    
    str7:   
    LEA	DX, STRING7    
    INT	21h
    JC	here      
   
    MOV	AH, 09h       
    LEA	DX, STRING7     
    INT	21h
    jmp close
    
    str8:   
    LEA	DX, STRING8    
    INT	21h
    JC	here      
   
    MOV	AH, 09h       
    LEA	DX, STRING8     
    INT	21h
    jmp close
    
    close:  
    MOV	AH, 3eh         ; Close file function
    MOV	BX, HANDLE      ; BX is the file handle 
    INT	21h 
    JC here        ; Jump to CONDITION: if condition met
    
    here:  
    ret
 file_read endp 
;=================================== 
default_screen proc
    call nextline
    call nextline
    call nextline
    call nextline
    call nextline
    call nextline
    mov ah, 9
    lea dx, opening_message
    int 21h
    call nextline
    call nextline
    mov ah, 9
    lea dx, controls
    int 21h
    call nextline
    mov ah, 9
    lea dx, f_key
    int 21h
    mov ah, 9
    lea dx, l_key
    int 21h
    mov ah, 9
    lea dx, r_key
    int 21h
    ret
default_screen endp
;===================================
ans proc   
    mov ah, 9
    lea dx, answer
    int 21h
    mov ah, 1
    int 21h
    ret
ans endp
;===================================
cls proc
    mov ah, 00
    mov al, 2
    int 10h
    ret
cls endp    
;===================================
correct_answer proc
    mov al, 5
    out r_port, al
    mov ah, 9
    lea dx, correct_message
    int 21h 
    inc counter
    call y
    ret
correct_answer endp
;===================================
incorrect_answer proc 
    mov ah, 9
    lea dx, incorrect_message
    int 21h
    call y
    ret
incorrect_answer endp
;===================================
y proc
    mov ah, 9
    lea dx, key
    int 21h
	
    mov ah,7
    int 21h
    call cls
    
    cmp counter, 8
    je done
    call default_screen 
    ret
y endp
;===================================
nextline proc
    mov ah, 9
    lea dx, nl
    int 21h
    ret
nextline endp
;=================================== 
done proc
   call cls
   call nextline
   call nextline
   call nextline
   mov ah, 9
   lea dx, ms
   int 21h
   
   MOV	AX, 4c00h
   int	21h  
   ret
done endp
;===================================  

    opening_message db 10,13, "          Mission: Turn all the lights on by answering the questions.$"
    controls db 10,13, "                                  Controls$"
    l_key db 10,13,"                          Arrow Left = Turn Left$"
    r_key db 10,13,"                          Arrow Right = Turn Right$"
    f_key db 10,13,"                          Arrow Up = Move Forward$"
    ms db 10,13,"          Congratulations! You have successfully finished your task.$"
    correct_message db 10,13, "Your answer is CORRECT.$"
    incorrect_message db 10,13, "INCORRECT ANSWER.$"
    answer db 10,13, "ANSWER: $"
    key db 10,13, "Press any key to continue... $"    
    question1 db 'DIRECTORY\QUESTION_1.txt',0
    question2 db 'DIRECTORY\QUESTION_2.txt',0
    question3 db 'DIRECTORY\QUESTION_3.txt',0
    question4 db 'DIRECTORY\QUESTION_4.txt',0
    question5 db 'DIRECTORY\QUESTION_5.txt',0
    question6 db 'DIRECTORY\QUESTION_6.txt',0
    question7 db 'DIRECTORY\QUESTION_7.txt',0
    question8 db 'DIRECTORY\QUESTION_8.txt',0 
    STRING DB 150 dup(0)
    STRING3 DB 150 dup(0)
    STRING4 DB 150 dup(0)
    STRING5 DB 150 dup(0)
    STRING6 DB 150 dup(0)
    STRING7 DB 150 dup(0)
    STRING8 DB 150 dup(0)
    endchar db '$'         
    HANDLE DW 0          
    counter DW 0  
    nl db 10,13, "$"