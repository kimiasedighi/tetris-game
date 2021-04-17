title (exe) Graphics System Calls 

.model small
 
.stack 64   

.data 
     
     border_left dw 19
     border_right dw 300 
     border_top dw 27 ; 19
     border_bottom dw 180 
     
     border_color db 4 ; red color
          
     
     blue_color db 9

     pink_color db 0Dh ; light magenta

     ;yellow_color db 0Eh
     
     yellow_color db 7 ;gray :\

     brown_color db 6

     green_color db 0Ah
     
          
     ; the features of the incoming block
     shape_code dw 0 ; default=0 the shape_code is between 0 and 12
     shape_color db 9 ; default=blue
     
     ; default value for square's row and col     
     shape_1s_r dw 28
     shape_1s_c dw 28
     
     shape_1s_rr dw 28 
     
     shape_1f_r dw 36
     shape_1f_c dw 36
     
     shape_2s_r dw 28
     shape_2s_c dw 36
     
     shape_2f_r dw 36
     shape_2f_c dw 44
     
     shape_3s_r dw 28
     shape_3s_c dw 44
     
     shape_3f_r dw 36
     shape_3f_c dw 52
     
     shape_4s_r dw 28
     shape_4s_c dw 52
     
     shape_4f_r dw 36
     shape_4f_c dw 60
     
     ; baraye inke bebinim har square shape 
     ; baese por shodane radifi shode ya na
     ; agar 1 bahsad yani shode
     
     square1_fill db 0
     square2_fill db 0
     square3_fill db 0
     square4_fill db 0
     fill_row_counter db 0
     
     shift_row db 0 
     
     my_score dw 0H
     my_score2 dw 0H 
     
     blank1 db "        $" ; debug
     blank2 db "        $" ; debug
     blank3 db "        $" ; debug
     blank4 db "        $" ; debug
          
     score db "SCORE:      $"
     end_game_msg	DB	"GAME OVER.$"     
     
.code 
#start=led_display.exe#

main proc far
    
    mov ax, @data
    mov ds, ax
       
    call clear_screen    
    call set_graphic_mode
    
    
    mov ax, my_score
    call show_score
    call draw_border        
    call init_shape
    
        
check:
    call update_shape    
    jmp check    
       

main endp


clear_screen proc
    mov al, 06h ; scroll down
    mov bh, 00h
    mov cx, 0000h
    mov dx, 184fh
    int 10h
                 
    ret                    
endp clear_screen


set_graphic_mode proc
    mov ah, 00h
    mov al, 13h
    int 10h
        
    ret
endp set_graphic_mode


delay proc
    mov cx, 4fffh ; set delay time
delay_loop:
    loop delay_loop
    
    ret
endp delay


show_score proc 
        
    mov ax, my_score
    lea si, score
    add si, 5
    sub bx, bx
    sub dx, dx
    
    cmp ax, 0
    je zero
    
div_label:
    sub ax, 0
    jz print_label
    mov cx, 10
    div cx         ;ax/cx
    push dx
    inc bx
    sub dx, dx
    jmp div_label

print_label:
    cmp bx, 0
    je return
    
    ;convert to ascii
    pop dx
    add dx, 48
    
    ;storing in score
    add si, 1
    mov [si], dx
    
    ;coordinate of score
    mov ah, 02h
    mov bh, 00
    mov dh, 01h
    mov dl, 05h
    int 10h
    
    ;print
    lea dx, score
    mov ah, 09h
    int 21h
    
    dec bx
    jmp print_label
    
    
zero:
    mov dx, 48
    ;storing in score
    add si, 1
    mov [si], dx
    
    ;coordinate of score
    mov ah, 02h
    mov bh, 00
    mov dh, 01h
    mov dl, 05h
    int 10h
    
    ;print
    lea dx, score
    mov ah, 09h
    int 21h    

return:
    ret
    
endp show_score


show_game_over proc
	mov ah, 02H
    mov bh, 00
    mov dx, 080CH
    int 10H

    mov ah, 09H
    lea dx, end_game_msg
    int 21H
        
    mov ah, 4CH ; exit to operating system.
    int 21H
        
	ret
endp show_game_over


draw_border proc
    ; top border
    mov dx, border_top ; row
    mov cx, border_left ; column
border_top_loop:
    mov ah, 0ch
    mov al, border_color
    int 10h
    inc cx
    cmp cx, border_right
    jnz border_top_loop
    
    ; right border
    mov dx, border_top ; row
    mov cx, border_right ; column
border_right_loop:
    mov ah, 0ch
    mov al, border_color
    int 10h
    inc dx
    cmp dx, border_bottom
    jnz border_right_loop
    
    ; bottom border
    mov dx, border_bottom ; row
    mov cx, border_left ; column
border_bottom_loop:
    mov ah, 0ch
    mov al, border_color
    int 10h
    inc cx
    cmp cx, border_right
    jnz border_bottom_loop
    
    ; left border
    mov dx, border_top ; row
    mov cx, border_left ; column
border_left_loop:
    mov ah, 0ch
    mov al, border_color
    int 10h
    inc dx
    cmp dx, border_bottom
    jnz border_left_loop    
    
    mov dx, border_bottom
    mov cx, border_right
    mov ah, 0ch
    mov al, border_color
    int 10h
    
    ret
endp draw_border


draw_shape proc
    mov ah, 0ch
    mov al, shape_color  ; color
    
    ; square 1
    mov cx, shape_1s_c ; start col
        
loop1_shape_square1:
    mov dx, shape_1s_rr ; start row
    
loop2_shape_square1:

    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz loop2_shape_square1
    
    inc cx
    cmp cx, shape_1f_c ; finish col
    jnz loop1_shape_square1
        
    ; white
    ; top border
    mov dx, shape_1s_rr ; row
    mov cx, shape_1s_c ; column
top_loop1:
    mov ah, 0ch
    mov al, 0Fh ;white
    int 10h
    inc cx
    
    mov bx, shape_1f_c
    dec bx
    
    cmp cx, bx
    jnz top_loop1
    
    ; right border
    mov dx, shape_1s_rr ; row
    mov cx, shape_1f_c ; column
    dec cx
right_loop1:
    mov ah, 0ch
    mov al, 0Fh ;white
    int 10h
    inc dx
    
    mov bx, shape_1f_r
    dec bx
    
    cmp dx, bx
    jnz right_loop1
    
    ; bottom border
    mov dx, shape_1f_r ; row
    dec dx
    
    mov cx, shape_1s_c ; column
bottom_loop1:
    mov ah, 0ch
    mov al, 0fh
    int 10h
    inc cx
    
    mov bx, shape_1f_c
    dec bx
    
    cmp cx, bx
    jnz bottom_loop1
    
    ; left border
    mov dx, shape_1s_rr ; row
    mov cx, shape_1s_c ; column
left_loop1:
    mov ah, 0ch
    mov al, 0fh
    int 10h
    inc dx
    
    mov bx, shape_1f_r
    dec bx
    
    cmp dx, bx
    jnz left_loop1
        
    
    mov dx, shape_1f_r
    dec dx
    mov cx, shape_1f_c
    dec cx
    mov ah, 0ch
    mov al, 0fh
    int 10h
       
    
    ; square 2
    mov cx, shape_2s_c ; start col
        
loop1_shape_square2:
    mov dx, shape_2s_r ; start row

loop2_shape_square2:
    mov al, shape_color
    int 10h
    inc dx
    
    cmp dx, shape_2f_r ; finish row
    jnz loop2_shape_square2
    
    inc cx
    cmp cx, shape_2f_c  ; finish col
    jnz loop1_shape_square2 
    
    
    
    ; white
    ; top border
    mov dx, shape_2s_r ; row
    mov cx, shape_2s_c ; column
top_loop2:
    mov ah, 0ch
    mov al, 0Fh ;white
    int 10h
    inc cx
    
    mov bx, shape_2f_c
    dec bx
    
    cmp cx, bx
    jnz top_loop2
    
    ; right border
    mov dx, shape_2s_r ; row
    mov cx, shape_2f_c ; column
    dec cx
right_loop2:
    mov ah, 0ch
    mov al, 0Fh ;white
    int 10h
    inc dx
    
    mov bx, shape_2f_r
    dec bx
    
    cmp dx, bx
    jnz right_loop2
    
    ; bottom border
    mov dx, shape_2f_r ; row
    dec dx
    
    mov cx, shape_2s_c ; column
bottom_loop2:
    mov ah, 0ch
    mov al, 0fh
    int 10h
    inc cx
    
    mov bx, shape_2f_c
    dec bx
    
    cmp cx, bx
    jnz bottom_loop2
    
    ; left border
    mov dx, shape_2s_r ; row
    mov cx, shape_2s_c ; column
left_loop2:
    mov ah, 0ch
    mov al, 0fh
    int 10h
    inc dx
    
    mov bx, shape_2f_r
    dec bx
    
    cmp dx, bx
    jnz left_loop2
        
    
    mov dx, shape_2f_r
    dec dx
    mov cx, shape_2f_c
    dec cx
    mov ah, 0ch
    mov al, 0fh
    int 10h
    
        
    ; square 3
    mov cx, shape_3s_c ; start col
        
loop1_shape_square3:
    mov dx, shape_3s_r ; start row

loop2_shape_square3:
    mov al, shape_color
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz loop2_shape_square3
    
    inc cx
    cmp cx, shape_3f_c  ; finish col
    jnz loop1_shape_square3 
    
    
    ; white
    ; top border
    mov dx, shape_3s_r ; row
    mov cx, shape_3s_c ; column
top_loop3:
    mov ah, 0ch
    mov al, 0Fh ;white
    int 10h
    inc cx
    
    mov bx, shape_3f_c
    dec bx
    
    cmp cx, bx
    jnz top_loop3
    
    ; right border
    mov dx, shape_3s_r ; row
    mov cx, shape_3f_c ; column
    dec cx
right_loop3:
    mov ah, 0ch
    mov al, 0Fh ;white
    int 10h
    inc dx
    
    mov bx, shape_3f_r
    dec bx
    
    cmp dx, bx
    jnz right_loop3
    
    ; bottom border
    mov dx, shape_3f_r ; row
    dec dx
    
    mov cx, shape_3s_c ; column
bottom_loop3:
    mov ah, 0ch
    mov al, 0fh
    int 10h
    inc cx
    
    mov bx, shape_3f_c
    dec bx
    
    cmp cx, bx
    jnz bottom_loop3
    
    ; left border
    mov dx, shape_3s_r ; row
    mov cx, shape_3s_c ; column
left_loop3:
    mov ah, 0ch
    mov al, 0fh
    int 10h
    inc dx
    
    mov bx, shape_3f_r
    dec bx
    
    cmp dx, bx
    jnz left_loop3
        
    
    mov dx, shape_3f_r
    dec dx
    mov cx, shape_3f_c
    dec cx
    mov ah, 0ch
    mov al, 0fh
    int 10h
    
    
    ; square 4
    mov cx, shape_4s_c ; start col
        
loop1_shape_square4:
    mov dx, shape_4s_r ; start row

loop2_shape_square4:
    mov al, shape_color
    int 10h
    inc dx
    
    cmp dx, shape_4f_r ; finish row
    jnz loop2_shape_square4
    
    inc cx
    cmp cx, shape_4f_c  ; finish col
    jnz loop1_shape_square4
                            
    
    
    
    ; white
    ; top border
    mov dx, shape_4s_r ; row
    mov cx, shape_4s_c ; column
top_loop4:
    mov ah, 0ch
    mov al, 0Fh ;white
    int 10h
    inc cx
    
    mov bx, shape_4f_c
    dec bx
    
    cmp cx, bx
    jnz top_loop4
    
    ; right border
    mov dx, shape_4s_r ; row
    mov cx, shape_4f_c ; column
    dec cx
right_loop4:
    mov ah, 0ch
    mov al, 0Fh ;white
    int 10h
    inc dx
    
    mov bx, shape_4f_r
    dec bx
    
    cmp dx, bx
    jnz right_loop4
    
    ; bottom border
    mov dx, shape_4f_r ; row
    dec dx
    
    mov cx, shape_4s_c ; column
bottom_loop4:
    mov ah, 0ch
    mov al, 0fh
    int 10h
    inc cx
    
    mov bx, shape_4f_c
    dec bx
    
    cmp cx, bx
    jnz bottom_loop4
    
    ; left border
    mov dx, shape_4s_r ; row
    mov cx, shape_4s_c ; column
left_loop4:
    mov ah, 0ch
    mov al, 0fh
    int 10h
    inc dx
    
    mov bx, shape_4f_r
    dec bx
    
    cmp dx, bx
    jnz left_loop4
        
    
    mov dx, shape_4f_r
    dec dx
    mov cx, shape_4f_c
    dec cx
    mov ah, 0ch
    mov al, 0fh
    int 10h
           
    ret
endp draw_shape


init_shape proc
    call get_random_shape_init
       
    cmp shape_code, 0    
    je init_shape_0
    
    cmp shape_code, 1
    je init_shape_1
    
    cmp shape_code, 2
    je init_shape_2
    
    cmp shape_code, 3
    je init_shape_3
    
    cmp shape_code, 4
    je init_shape_4
                          
    
init_shape_0:

    mov shape_1s_rr, 28  
    mov shape_1s_c, 20 ;28
        
    mov shape_1f_r, 36
    mov shape_1f_c, 28 
    
    mov shape_2s_r, 28 
    mov shape_2s_c, 28
      
    mov shape_2f_r, 36 
    mov shape_2f_c, 36
      
    mov shape_3s_r, 28
    mov shape_3s_c, 36
   
    mov shape_3f_r, 36
    mov shape_3f_c, 44

    mov shape_4s_r, 28
    mov shape_4s_c, 44
 
    mov shape_4f_r, 36
    mov shape_4f_c, 52
    
    ; to check if game is over or not
    mov ah, 0dh
    mov cx, shape_1s_c
    mov dx, shape_1s_rr
    int 10h
    cmp al, 0 ; black
    jne game_over_0
    
    mov ah, 0dh
    mov cx, shape_2s_c
    mov dx, shape_2s_r
    int 10h
    cmp al, 0
    jne game_over_0
    
    mov ah, 0dh
    mov cx, shape_3s_c
    mov dx, shape_3s_r
    int 10h
    cmp al, 0
    jne game_over_0
    
    
    mov ah, 0dh
    mov cx, shape_4s_c
    mov dx, shape_4s_r
    int 10h
    cmp al, 0
    jne game_over_0
    
    jmp game_not_over_0
    
game_over_0:

    call show_game_over

game_not_over_0:    
    
    
    mov ax, blue_color
    mov shape_color, ax
    
        
    call draw_shape
    jmp end_shape_init
    
init_shape_1:

    mov shape_1s_rr, 28
    mov shape_1s_c, 20

    mov shape_1f_r, 36
    mov shape_1f_c, 28
     
    mov shape_2s_r, 28
    mov shape_2s_c, 28
 
    mov shape_2f_r, 36
    mov shape_2f_c, 36

    mov shape_3s_r, 36
    mov shape_3s_c, 20

    mov shape_3f_r, 44
    mov shape_3f_c, 28

    mov shape_4s_r, 36
    mov shape_4s_c, 28

    mov shape_4f_r, 44
    mov shape_4f_c, 36
    
    ; to check if game is over or not
    mov ah, 0dh
    mov cx, shape_1s_c
    mov dx, shape_1s_rr
    int 10h
    cmp al, 0 ; black
    jne game_over_1
    
    mov ah, 0dh
    mov cx, shape_2s_c
    mov dx, shape_2s_r
    int 10h
    cmp al, 0
    jne game_over_1
    
    mov ah, 0dh
    mov cx, shape_3s_c
    mov dx, shape_3s_r
    int 10h
    cmp al, 0
    jne game_over_1
    
    
    mov ah, 0dh
    mov cx, shape_4s_c
    mov dx, shape_4s_r
    int 10h
    cmp al, 0
    jne game_over_1
    
    jmp game_not_over_1
    
game_over_1:

    call show_game_over

game_not_over_1:
    
    mov ax, yellow_color
    mov shape_color, ax
    
    call draw_shape
    jmp end_shape_init
    
init_shape_2:
       
    mov shape_1s_rr, 28
    mov shape_1s_c, 20

    mov shape_1f_r, 36
    mov shape_1f_c, 28

    mov shape_2s_r, 36
    mov shape_2s_c, 20

    mov shape_2f_r, 44
    mov shape_2f_c, 28
 
    mov shape_3s_r, 44
    mov shape_3s_c, 20
  
    mov shape_3f_r, 52
    mov shape_3f_c, 28
 
    mov shape_4s_r, 44
    mov shape_4s_c, 28
 
    mov shape_4f_r, 52
    mov shape_4f_c, 36
    
        
    ; to check if game is over or not
    mov ah, 0dh
    mov cx, shape_1s_c
    mov dx, shape_1s_rr
    int 10h
    cmp al, 0 ; black
    jne game_over_2
    
    mov ah, 0dh
    mov cx, shape_2s_c
    mov dx, shape_2s_r
    int 10h
    cmp al, 0
    jne game_over_2
    
    mov ah, 0dh
    mov cx, shape_3s_c
    mov dx, shape_3s_r
    int 10h
    cmp al, 0
    jne game_over_2
    
    
    mov ah, 0dh
    mov cx, shape_4s_c
    mov dx, shape_4s_r
    int 10h
    cmp al, 0
    jne game_over_2
    
    jmp game_not_over_2
    
game_over_2:

    call show_game_over

game_not_over_2:
    
    
    mov ax, brown_color
    mov shape_color, ax

    call draw_shape
    jmp end_shape_init
    
init_shape_3:
     
    mov shape_1s_rr, 28
    mov shape_1s_c, 20

    mov shape_1f_r, 36
    mov shape_1f_c, 28

    mov shape_2s_r, 36
    mov shape_2s_c, 20
  
    mov shape_2f_r, 44
    mov shape_2f_c, 28

    mov shape_3s_r, 36
    mov shape_3s_c, 28

    mov shape_3f_r, 44
    mov shape_3f_c, 36
  
    mov shape_4s_r, 44
    mov shape_4s_c, 28

    mov shape_4f_r, 52
    mov shape_4f_c, 36
    
    ; to check if game is over or not
    mov ah, 0dh
    mov cx, shape_1s_c
    mov dx, shape_1s_rr
    int 10h
    cmp al, 0 ; black
    jne game_over_3
    
    mov ah, 0dh
    mov cx, shape_2s_c
    mov dx, shape_2s_r
    int 10h
    cmp al, 0
    jne game_over_3
    
    mov ah, 0dh
    mov cx, shape_3s_c
    mov dx, shape_3s_r
    int 10h
    cmp al, 0
    jne game_over_3
    
    
    mov ah, 0dh
    mov cx, shape_4s_c
    mov dx, shape_4s_r
    int 10h
    cmp al, 0
    jne game_over_3
    
    jmp game_not_over_3
    
game_over_3:

    call show_game_over

game_not_over_3:
    
    mov ax, green_color
    mov shape_color, ax
    
    call draw_shape
    jmp end_shape_init
    
init_shape_4:
  
    mov shape_1s_rr, 28
    mov shape_1s_c, 20

    mov shape_1f_r, 36
    mov shape_1f_c, 28

    mov shape_2s_r, 28
    mov shape_2s_c, 28
   
    mov shape_2f_r, 36
    mov shape_2f_c, 36

    mov shape_3s_r, 28
    mov shape_3s_c, 36
 
    mov shape_3f_r, 36
    mov shape_3f_c, 44
 
    mov shape_4s_r, 36
    mov shape_4s_c, 28
    
    mov shape_4f_r, 44
    mov shape_4f_c, 36
    
    ; to check if game is over or not
    mov ah, 0dh
    mov cx, shape_1s_c
    mov dx, shape_1s_rr
    int 10h
    cmp al, 0 ; black
    jne game_over_4
    
    mov ah, 0dh
    mov cx, shape_2s_c
    mov dx, shape_2s_r
    int 10h
    cmp al, 0
    jne game_over_4
    
    mov ah, 0dh
    mov cx, shape_3s_c
    mov dx, shape_3s_r
    int 10h
    cmp al, 0
    jne game_over_4
    
    
    mov ah, 0dh
    mov cx, shape_4s_c
    mov dx, shape_4s_r
    int 10h
    cmp al, 0
    jne game_over_4
    
    jmp game_not_over_4
    
game_over_4:

    call show_game_over

game_not_over_4:

    mov ax, pink_color
    mov shape_color, ax
    
    call draw_shape
    jmp end_shape_init
    
end_shape_init:
    
    ret
endp init_shape


delete_shape proc
    mov ah, 0ch
    mov al, 0  ; black color
    
    ; square 1
    mov cx, shape_1s_c ; start col
        
loop1_delete_square1:
    mov dx, shape_1s_rr ; start row
    
loop2_delete_square1:
    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz loop2_delete_square1
    
    inc cx
    cmp cx, shape_1f_c ; finish col
    jnz loop1_delete_square1
    

    ; square 2
    mov cx, shape_2s_c ; start col
        
loop1_delete_square2:
    mov dx, shape_2s_r ; start row

loop2_delete_square2:
    int 10h
    inc dx
    
    cmp dx, shape_2f_r ; finish row
    jnz loop2_delete_square2
    
    inc cx
    cmp cx, shape_2f_c  ; finish col
    jnz loop1_delete_square2
    
    
    ; square 3
    mov cx, shape_3s_c ; start col
        
loop1_delete_square3:
    mov dx, shape_3s_r ; start row

loop2_delete_square3:
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz loop2_delete_square3
    
    inc cx
    cmp cx, shape_3f_c  ; finish col
    jnz loop1_delete_square3
    
    ; square 4
    mov cx, shape_4s_c ; start col
        
loop1_delete_square4:
    mov dx, shape_4s_r ; start row

loop2_delete_square4:
    int 10h
    inc dx
    
    cmp dx, shape_4f_r ; finish row
    jnz loop2_delete_square4
    
    inc cx
    cmp cx, shape_4f_c  ; finish col
    jnz loop1_delete_square4
    
    ret
endp delete_shape



get_random_shape_init proc        
    mov ah, 2CH ;get time
	int 21H
	mov  ax, 0H
	mov  al, dl
    xor  dx, dx
	mov  cx, 05H
	div  cx
	mov  shape_code, dl
    
    ret
endp get_random_shape_init


update_shape proc
    ; check any character enterd or not
	mov ah, 01H
	int 16H
	jz	update_shape_end ; nothing is entered in keybored
		
	; to get entered character
	mov	ah, 00H
	int 16H
	
	cmp al, 61H ; a entered
	je	move_left
	cmp	al, 64H ; d entered
	je	move_right
	cmp al, 77H ; w entered
	je	rotate
	cmp al, 73H ; s entered
	je	move_down
	cmp al, 66H ; f entered
	je	move_bottom
	jmp update_shape_end ; illegal character
	
move_left:
    cmp shape_code, 0
    je move_left_0
    
    cmp shape_code, 1
    je move_left_1
    
    cmp shape_code, 2
    je move_left_2
    
    cmp shape_code, 3
    je move_left_3
    
    cmp shape_code, 4
    je move_left_4
    
    cmp shape_code, 5
    je move_left_5
    
    cmp shape_code, 6
    je move_left_6
    
    cmp shape_code, 7
    je move_left_7
    
    cmp shape_code, 8
    je move_left_8
    
    cmp shape_code, 9
    je move_left_9
    
    cmp shape_code, 10
    je move_left_10
    
    cmp shape_code, 11
    je move_left_11
    
    cmp shape_code, 12
    je move_left_12
    
move_left_0:
    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1s_c
    dec cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_left_1:
    
    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1s_c
    dec cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    ; third square
    mov cx, shape_3s_c
    dec cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_left_2:

    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1s_c
    dec cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; second square
    mov cx, shape_2s_c
    dec cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    ; third square
    mov cx, shape_3s_c
    dec cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_left_3:
    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1s_c
    dec cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; second square
    mov cx, shape_2s_c
    dec cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end

    ; fourth square
    mov cx, shape_4s_c
    dec cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_left_4:
    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1s_c
    dec cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov cx, shape_4s_c
    dec cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end      

move_left_5:
    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1s_c
    dec cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; second square
    mov cx, shape_2s_c
    dec cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    ; third square
    mov cx, shape_3s_c
    dec cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    ; fourth square
    mov cx, shape_4s_c
    dec cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end 

    
move_left_6:

    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; third square
    mov cx, shape_3s_c
    dec cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    ; fourth square
    mov cx, shape_4s_c
    dec cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end 

move_left_7:

    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1s_c
    dec cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; second square
    mov cx, shape_2s_c
    dec cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end

    ; fourth square
    mov cx, shape_4s_c
    dec cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end 

move_left_8:

    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1s_c
    dec cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
        
    ; fourth square
    mov cx, shape_4s_c
    dec cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end 


move_left_9:

    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; second square
    mov cx, shape_2s_c
    dec cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
        
    ; fourth square
    mov cx, shape_4s_c
    dec cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end 

move_left_10:

    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1s_c
    dec cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
       
    ; third square
    mov cx, shape_3s_c
    dec cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    ; fourth square
    mov cx, shape_4s_c
    dec cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end 

move_left_11:

    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
        
    ; third square
    mov cx, shape_3s_c
    dec cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    ; fourth square
    mov cx, shape_4s_c
    dec cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end 


move_left_12:

    ; first we check if it is possible to move left or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1s_c
    dec cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; second square
    mov cx, shape_2s_c
    dec cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    ; third square
    mov cx, shape_3s_c
    dec cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
        
    call delete_shape
    
    sub shape_1s_c, 8      
    sub shape_1f_c, 8           
    sub shape_2s_c, 8      
    sub shape_2f_c, 8           
    sub shape_3s_c, 8           
    sub shape_3f_c, 8           
    sub shape_4s_c, 8           
    sub shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end     


move_right:

    cmp shape_code, 0
    je move_right_0
    
    cmp shape_code, 1
    je move_right_1
    
    cmp shape_code, 2
    je move_right_2
    
    cmp shape_code, 3
    je move_right_3
    
    cmp shape_code, 4
    je move_right_4
    
    cmp shape_code, 5
    je move_right_5
    
    cmp shape_code, 6
    je move_right_6
    
    cmp shape_code, 7
    je move_right_7
    
    cmp shape_code, 8
    je move_right_8
    
    cmp shape_code, 9
    je move_right_9
    
    cmp shape_code, 10
    je move_right_10
    
    cmp shape_code, 11
    je move_right_11
    
    cmp shape_code, 12
    je move_right_12

move_right_0:

    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; fourth square
    mov cx, shape_4f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end 

move_right_1:

    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; second square
    mov cx, shape_2f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov cx, shape_4f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_right_2:
    
    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; second square
    mov cx, shape_2f_c
        
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov cx, shape_4f_c
    
    cmp cx, 300
    je update_shape_end
    
    
    inc cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_right_3:

    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    
    cmp cx, 300
    je update_shape_end
    
    
    inc cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov cx, shape_3f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov cx, shape_4f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
    
move_right_4:
    
    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; third square
    mov cx, shape_3f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov cx, shape_4f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_right_5:
    
    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; second square
    mov cx, shape_2f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov cx, shape_3f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov cx, shape_4f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end

move_right_6:

    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    ; fourth square
    mov cx, shape_4f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end

move_right_7:

    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; second square
    mov cx, shape_2f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov cx, shape_3f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_right_8:

    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; third square
    mov cx, shape_3f_c
        
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov cx, shape_4f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_right_9:
    
    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov cx, shape_3f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
        
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_right_10:

    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; second square
    mov cx, shape_2f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_2s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov cx, shape_3f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end

move_right_11:

    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov cx, shape_4f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    
move_right_12:

    ; first we check if it is possible to move right or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_1s_rr
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov cx, shape_3f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_3s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov cx, shape_4f_c
    
    cmp cx, 300
    je update_shape_end
    
    inc cx
    mov dx, shape_4s_r
    inc dx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    add shape_1s_c, 8      
    add shape_1f_c, 8           
    add shape_2s_c, 8      
    add shape_2f_c, 8           
    add shape_3s_c, 8           
    add shape_3f_c, 8           
    add shape_4s_c, 8           
    add shape_4f_c, 8
        
    call draw_shape
    jmp update_shape_end
    

rotate:
    cmp shape_code, 0
    je rotate_0
    
    cmp shape_code, 1
    je rotate_1
    
    cmp shape_code, 2
    je rotate_2
    
    cmp shape_code, 3
    je rotate_3
    
    cmp shape_code, 4
    je rotate_4
    
    cmp shape_code, 5
    je rotate_5
    
    cmp shape_code, 6
    je rotate_6
    
    cmp shape_code, 7
    je rotate_7
    
    cmp shape_code, 8
    je rotate_8
    
    cmp shape_code, 9
    je rotate_9
    
    cmp shape_code, 10
    je rotate_10
    
    cmp shape_code, 11
    je rotate_11
    
    cmp shape_code, 12
    je rotate_12
    
rotate_0:
    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2s_r
    dec dx
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov dx, shape_2f_r
    add dx, 9
    
    dec dx
        
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    ; make square 1
    mov ax, shape_2s_r ; start row
    sub ax, 8
    mov shape_1s_rr, ax
    
    mov ax, shape_2s_r ; finish row
    mov shape_1f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_1s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_1f_c, ax 
    
    ; make square 3
    mov ax, shape_2f_r ; start row
    mov shape_3s_r, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_3f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_3s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_3f_c, ax
    
    ; make square 4
    mov ax, shape_2f_r ; start row
    add ax, 8
    mov shape_4s_r, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 16
    mov shape_4f_r, ax ;? 
    
    mov ax, shape_2s_c ; start col
    mov shape_4s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_4f_c, ax
    
    mov shape_code, 5
    
    call draw_shape
    jmp update_shape_end
    
rotate_1:

    jmp update_shape_end 
       
rotate_2:

    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2s_r
    inc dx
    mov cx, shape_2f_c
    inc cx
    
    dec cx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov dx, shape_2s_r
    inc dx
    mov cx, shape_2s_c
    dec cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    mov cx, shape_2s_c
    dec cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    ; make square 1
    mov ax, shape_2s_r ; start row
    mov shape_1s_rr, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_1f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_1s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_1f_c, ax
    
    ; make square 3
    mov ax, shape_2s_r ; start row
    mov shape_3s_r, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_3f_r, ax  
    
    mov ax, shape_2s_c ; start col
    sub ax, 8
    mov shape_3s_c, ax
    
    mov ax, shape_2s_c ; finish col
    mov shape_3f_c, ax 
    
    ; make square 4
    mov ax, shape_2f_r ; start row
    mov shape_4s_r, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_4f_r, ax 
    
    mov ax, shape_2s_c ; start col
    sub ax, 8
    mov shape_4s_c, ax
    
    mov ax, shape_2s_c ; finish col
    mov shape_4f_c, ax
    
    mov shape_code, 6
    
    call draw_shape
    jmp update_shape_end


rotate_3:
    
    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
        
    ; third square
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    ; fourth square
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    mov cx, shape_2s_c
    dec cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    ; make square 1
    mov ax, shape_2s_r ; start row
    mov shape_1s_rr, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_1f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_1s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_1f_c, ax
    
    ; make square 3
    mov ax, shape_2f_r ; start row
    mov shape_3s_r, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_3f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_3s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_3f_c, ax 
    
    ; make square 4
    mov ax, shape_2f_r ; start row
    mov shape_4s_r, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_4f_r, ax 
    
    mov ax, shape_2s_c ; start col
    sub ax, 8
    mov shape_4s_c, ax
    
    mov ax, shape_2s_c ; finish col
    mov shape_4f_c, ax
    
    mov shape_code, 9
    
    call draw_shape
    jmp update_shape_end

rotate_4:

    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2s_r
    dec dx
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
       
    call delete_shape
    
    ; make square 1
    mov ax, shape_2s_r ; start row
    sub ax, 8
    mov shape_1s_rr, ax
    
    mov ax, shape_2s_r ; finish row
    mov shape_1f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_1s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_1f_c, ax 
    
    ; make square 3
    mov ax, shape_2f_r ; start row
    mov shape_3s_r, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_3f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_3s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_3f_c, ax
    
    ; make square 4
    mov ax, shape_2s_r ; start row
    mov shape_4s_r, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_4f_r, ax  
    
    mov ax, shape_2s_c ; start col
    sub ax, 8
    mov shape_4s_c, ax 
    
    mov ax, shape_2s_c   ; finish col
    mov shape_4f_c, ax
    
    mov shape_code, 10
    
    call draw_shape
    jmp update_shape_end

     
rotate_5:

    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2s_r
    inc dx
    mov cx, shape_2s_c
    dec cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    mov cx, shape_2f_c
    inc cx
    
    dec cx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov dx, shape_2s_r
    inc dx
    mov cx, shape_2f_c
    add cx, 9
    
    dec cx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    ; make square 1
    mov ax, shape_2s_r ; start row
    mov shape_1s_rr, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_1f_r, ax  
    
    mov ax, shape_2s_c ; start col
    sub ax, 8
    mov shape_1s_c, ax
    
    mov ax, shape_2s_c ; finish col
    mov shape_1f_c, ax 
    
    ; make square 3
    mov ax, shape_2s_r ; start row
    mov shape_3s_r, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_3f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_3s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_3f_c, ax
    
    ; make square 4
    mov ax, shape_2s_r ; start row
    mov shape_4s_r, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_4f_r, ax  
    
    mov ax, shape_2f_c ; start col
    add ax, 8
    mov shape_4s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 16
    mov shape_4f_c, ax
    
    mov shape_code, 0
    
    call draw_shape
    jmp update_shape_end

    
rotate_6:

    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov dx, shape_2s_r
    dec dx
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov dx, shape_2s_r
    dec dx
    mov cx, shape_2s_c
    dec cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    ; make square 1
    mov ax, shape_2f_r ; start row
    mov shape_1s_rr, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_1f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_1s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_1f_c, ax 
    
    ; make square 3
    mov ax, shape_2s_r ; start row
    sub ax, 8
    mov shape_3s_r, ax
    
    mov ax, shape_2s_r ; finish row
    mov shape_3f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_3s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_3f_c, ax
    
    ; make square 4
    mov ax, shape_2s_r ; start row
    sub ax, 8
    mov shape_4s_r, ax
    
    mov ax, shape_2s_r ; finish row
    mov shape_4f_r, ax  
    
    mov ax, shape_2s_c ; start col
    sub ax, 8
    mov shape_4s_c, ax
    
    mov ax, shape_2s_c ; finish col
    mov shape_4f_c, ax
    
    mov shape_code, 7
    
    call draw_shape
    jmp update_shape_end

rotate_7:

    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2s_r
    inc dx
    mov cx, shape_2s_c
    dec cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov dx, shape_2s_r
    inc dx
    mov cx, shape_2f_c
    inc cx
    
    dec cx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov dx, shape_2s_r
    dec dx
    mov cx, shape_2f_c
    inc cx
    
    dec cx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    ; make square 1
    mov ax, shape_2s_r ; start row
    mov shape_1s_rr, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_1f_r, ax  
    
    mov ax, shape_2s_c ; start col
    sub ax, 8
    mov shape_1s_c, ax
    
    mov ax, shape_2s_c ; finish col
    mov shape_1f_c, ax 
    
    ; make square 3
    mov ax, shape_2s_r ; start row
    mov shape_3s_r, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_3f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_3s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_3f_c, ax
    
    ; make square 4
    mov ax, shape_2s_r ; start row
    sub ax, 8
    mov shape_4s_r, ax
    
    mov ax, shape_2s_r ; finish row
    mov shape_4f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_4s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_4f_c, ax
    
    mov shape_code, 8
    
    call draw_shape
    jmp update_shape_end

rotate_8:

    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2s_r
    dec dx
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; third square
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    mov cx, shape_2f_c
    inc cx
    
    dec cx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    ; make square 1
    mov ax, shape_2s_r ; start row
    sub ax, 8
    mov shape_1s_rr, ax
    
    mov ax, shape_2s_r ; finish row
    mov shape_1f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_1s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_1f_c, ax 
    
    ; make square 3
    mov ax, shape_2f_r ; start row
    mov shape_3s_r, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_3f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_3s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_3f_c, ax
    
    ; make square 4
    mov ax, shape_2f_r ; start row
    mov shape_4s_r, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_4f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_4s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_4f_c, ax
    
    mov shape_code, 2
    
    call draw_shape
    jmp update_shape_end

rotate_9:

    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2s_r
    dec dx
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    ; fourth square
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    mov cx, shape_2f_c
    inc cx
    
    dec cx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    ; make square 1
    mov ax, shape_2s_r ; start row
    sub ax, 8
    mov shape_1s_rr, ax
    
    mov ax, shape_2s_r ; finish row
    mov shape_1f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_1s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_1f_c, ax
    
    ; make square 3
    mov ax, shape_2s_r ; start row
    mov shape_3s_r, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_3f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_3s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_3f_c, ax
    
    ; make square 4
    mov ax, shape_2f_r ; start row
    mov shape_4s_r, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_4f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_4s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_4f_c, ax
    
    mov shape_code, 3
    
    call draw_shape
    jmp update_shape_end

rotate_10:

    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2s_r
    inc dx
    mov cx, shape_2f_c
    inc cx
    
    dec cx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    
    call delete_shape
    
    ; make square 1
    mov ax, shape_2s_r ; start row
    mov shape_1s_rr, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_1f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_1s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_1f_c, ax
    
    ; make square 3
    mov ax, shape_2s_r ; start row
    mov shape_3s_r, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_3f_r, ax  
    
    mov ax, shape_2s_c ; start col
    sub ax, 8
    mov shape_3s_c, ax
    
    mov ax, shape_2s_c ; finish col
    mov shape_3f_c, ax 
    
    ; make square 4
    mov ax, shape_2s_r ; start row
    sub ax, 8
    mov shape_4s_r, ax
    
    mov ax, shape_2s_r ; finish row
    mov shape_4f_r, ax 
    
    mov ax, shape_2s_c ; start col
    mov shape_4s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_4f_c, ax
    
    mov shape_code, 11
    
    call draw_shape
    jmp update_shape_end


rotate_11:

    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    mov cx, shape_2s_c
    inc cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
    
    call delete_shape
    
    ; make square 1
    mov ax, shape_2f_r ; start row
    mov shape_1s_rr, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_1f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_1s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_1f_c, ax 
    
    ; make square 3
    mov ax, shape_2s_r ; start row
    sub ax, 8
    mov shape_3s_r, ax
    
    mov ax, shape_2s_r ; finish row
    mov shape_3f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_3s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_3f_c, ax
    
    ; make square 4
    mov ax, shape_2s_r ; start row
    mov shape_4s_r, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_4f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_4s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_4f_c, ax
    
    mov shape_code, 12
    
    call draw_shape
    jmp update_shape_end

rotate_12:

    ; square 2 is fixed
    ; first we check if it is possible to rotate    
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov dx, shape_2s_r
    inc dx
    mov cx, shape_2s_c
    dec cx
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end
       
    call delete_shape
    
    ; make square 1
    mov ax, shape_2s_r ; start row
    mov shape_1s_rr, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_1f_r, ax  
    
    mov ax, shape_2s_c ; start col
    sub ax, 8
    mov shape_1s_c, ax
    
    mov ax, shape_2s_c ; finish col
    mov shape_1f_c, ax 
    
    ; make square 3
    mov ax, shape_2s_r ; start row
    mov shape_3s_r, ax
    
    mov ax, shape_2f_r ; finish row
    mov shape_3f_r, ax  
    
    mov ax, shape_2f_c ; start col
    mov shape_3s_c, ax
    
    mov ax, shape_2f_c ; finish col
    add ax, 8
    mov shape_3f_c, ax
    
    ; make square 4
    mov ax, shape_2f_r ; start row
    mov shape_4s_r, ax
    
    mov ax, shape_2f_r ; finish row
    add ax, 8
    mov shape_4f_r, ax  
    
    mov ax, shape_2s_c ; start col
    mov shape_4s_c, ax
    
    mov ax, shape_2f_c ; finish col
    mov shape_4f_c, ax
    
    mov shape_code, 4
    
    call draw_shape
    jmp update_shape_end
     
move_down:
    
    cmp shape_code, 0
    je move_down_0
    
    cmp shape_code, 1
    je move_down_1
    
    cmp shape_code, 2
    je move_down_2
    
    cmp shape_code, 3
    je move_down_3
    
    cmp shape_code, 4
    je move_down_4
    
    cmp shape_code, 5
    je move_down_5
    
    cmp shape_code, 6
    je move_down_6
    
    cmp shape_code, 7
    je move_down_7
    
    cmp shape_code, 8
    je move_down_8
    
    cmp shape_code, 9
    je move_down_9
    
    cmp shape_code, 10
    je move_down_10
    
    cmp shape_code, 11
    je move_down_11
    
    cmp shape_code, 12
    je move_down_12
        
move_down_0:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; second square
    mov cx, shape_2f_c
    dec cx
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end
    

move_down_1:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end

        
move_down_2:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end

move_down_3:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
        
    ; second square
    mov cx, shape_2f_c
    dec cx
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end


move_down_4:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
   
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end


move_down_5:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end

move_down_6:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; second square
    mov cx, shape_2f_c
    dec cx
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
        
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end

move_down_7:
    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
        
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end
    
move_down_8:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; second square
    mov cx, shape_2f_c
    dec cx
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end
    
move_down_9:
    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx 
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end
    
move_down_10: 

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH    
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end
    
move_down_11:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; second square
    mov cx, shape_2f_c
    dec cx
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
        
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end

move_down_12:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
            
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne update_shape_end_and_init_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    call draw_shape
    jmp update_shape_end
    

move_bottom:

    cmp shape_code, 0
    je move_bottom_0
    
    cmp shape_code, 1
    je move_bottom_1
    
    cmp shape_code, 2
    je move_bottom_2
    
    cmp shape_code, 3
    je move_bottom_3
    
    cmp shape_code, 4
    je move_bottom_4
    
    cmp shape_code, 5
    je move_bottom_5
    
    cmp shape_code, 6
    je move_bottom_6
    
    cmp shape_code, 7
    je move_bottom_7
    
    cmp shape_code, 8
    je move_bottom_8
    
    cmp shape_code, 9
    je move_bottom_9
    
    cmp shape_code, 10
    je move_bottom_10
    
    cmp shape_code, 11
    je move_bottom_11
    
    cmp shape_code, 12
    je move_bottom_12


move_bottom_0:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; second square
    mov cx, shape_2f_c
    dec cx
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape ; not sure
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_0



move_bottom_1:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_1


move_bottom_2:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_2


move_bottom_3:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
        
    ; second square
    mov cx, shape_2f_c
    dec cx
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
            
    jmp move_bottom_3


move_bottom_4:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
   
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_4


move_bottom_5:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_5


move_bottom_6:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; second square
    mov cx, shape_2f_c
    dec cx
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
        
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_6


move_bottom_7:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
        
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
        
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_7


move_bottom_8:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; second square
    mov cx, shape_2f_c
    dec cx
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_8


move_bottom_9:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx 
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_9


move_bottom_10:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH    
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_10


move_bottom_11:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; second square
    mov cx, shape_2f_c
    dec cx
    mov dx, shape_2f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    ; third square
    mov cx, shape_3f_c
    dec cx
    mov dx, shape_3f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
        
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_11


move_bottom_12:

    ; first we check if it is possible to move down or not
    ; get pixel color
    mov ah, 0DH
    
    ; first square
    mov cx, shape_1f_c
    dec cx
    mov dx, shape_1f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
            
    ; fourth square
    mov cx, shape_4f_c
    dec cx
    mov dx, shape_4f_r
    inc dx
    
    dec dx
    
    int 10h
    cmp al, 0 ; we check if it is black or not
    jne move_bottom_draw_shape
    
    call delete_shape
    
    add shape_1s_rr, 8      
    add shape_1f_r, 8           
    add shape_2s_r, 8      
    add shape_2f_r, 8           
    add shape_3s_r, 8           
    add shape_3f_r, 8           
    add shape_4s_r, 8           
    add shape_4f_r, 8
        
    jmp move_bottom_12


move_bottom_draw_shape:
    call draw_shape
	    
update_shape_end_and_init_shape:

    mov fill_row_counter, 0

    ; dar inja bayad bebinim radifi hast ke 
    ; kamel rangi shode bashad 
        
    mov ah, 0DH
       
    cmp shape_code, 0
    je shape_0_fill
    
    cmp shape_code, 1
    je shape_1_fill
    
    cmp shape_code, 2
    je shape_2_fill
    
    cmp shape_code, 3
    je shape_3_fill
    
    cmp shape_code, 4
    je shape_4_fill
    
    cmp shape_code, 5
    je shape_5_fill
    
    cmp shape_code, 6
    je shape_6_fill
    
    cmp shape_code, 7
    je shape_7_fill
    
    cmp shape_code, 8
    je shape_8_fill
    
    cmp shape_code, 9
    je shape_9_fill
    
    cmp shape_code, 10
    je shape_10_fill
    
    cmp shape_code, 11
    je shape_11_fill
    
    cmp shape_code, 12
    je shape_12_fill
    

shape_0_fill:
    
    ; square 1
    mov ah, 0DH    
    mov cx, 21  ; start col
        
fill_1_check_0:
    mov dx, shape_1s_rr ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je end_fill_check 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_1_check_0
    
    mov square1_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 1
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_1_0:
    mov dx, shape_1s_rr ; start row
    
delete2_row_1_0:
    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz delete2_row_1_0
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_1_0
    
    
       
    
    ; to do shift    
    mov ax, shape_1f_r
    mov shift_row, ax
    call shift_down 
    
    jmp end_fill_check
    

shape_1_fill:

    
    ; square 1
    mov ah, 0DH
    mov cx, 21  ; start col
        
fill_1_check_1:

    mov dx, shape_1s_rr ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_3_check_1
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_1_check_1
    
    mov square1_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 1
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_1_1:
    mov dx, shape_1s_rr ; start row
    
delete2_row_1_1:
    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz delete2_row_1_1
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_1_1
    
    
   
    
    ; to do shift
    mov ax, shape_1f_r
    mov shift_row, ax
    call shift_down
    
        
    ; square 3
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_3_check_1:
    mov dx, shape_3s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je end_fill_check 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_3_check_1
    
    mov square3_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 3
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_3_1:
    mov dx, shape_3s_r ; start row
    
delete2_row_3_1:
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz delete2_row_3_1
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_3_1
    
           
    
    ; to do shift
    mov ax, shape_3f_r
    mov shift_row, ax
    call shift_down
    
    jmp end_fill_check


shape_2_fill:
    
    ; square 1
    mov ah, 0DH
    mov cx, 21  ; start col
        
fill_1_check_2:
    mov dx, shape_1s_rr ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_2_check_2
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_1_check_2
    
    mov square1_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 1
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_1_2:
    mov dx, shape_1s_rr ; start row
    
delete2_row_1_2:
    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz delete2_row_1_2
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_1_2
    
    
    
    
    ; to do shift
    mov ax, shape_1f_r
    mov shift_row, ax
    call shift_down
                   
                   
    ; square 2
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_2_check_2:
    mov dx, shape_2s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je fill_3_check_2 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_2_check_2
    
    mov square2_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 2
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_2_2:
    mov dx, shape_2s_r ; start row
    
delete2_row_2_2:
    int 10h
    inc dx
    
    cmp dx, shape_2f_r ; finish row
    jnz delete2_row_2_2
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_2_2
    
    
        
    
    ; to do shift    
    mov ax, shape_2f_r
    mov shift_row, ax
    call shift_down
    
    
    ; square 3
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_3_check_2:
    mov dx, shape_3s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je end_fill_check 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_3_check_2
    
    mov square3_fill, 1
    add fill_row_counter, 1
    
    
        
        
    ; delete row of square 3
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_3_2:
    mov dx, shape_3s_r ; start row
    
delete2_row_3_2:
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz delete2_row_3_2
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_3_2
    
    
    
    ; to do shift
    mov ax, shape_3f_r
    mov shift_row, ax
    call shift_down
    
    jmp end_fill_check
    
    
shape_3_fill:
    
    
    ; square 1
    mov ah, 0DH
    mov cx, 21  ; start col
        
fill_1_check_3:
    mov dx, shape_1s_rr ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_2_check_3
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_1_check_3
    
    mov square1_fill, 1
    add fill_row_counter, 1
    
    
    
    
        
    ; delete row of square 1
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_1_3:
    mov dx, shape_1s_rr ; start row
    
delete2_row_1_3:
    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz delete2_row_1_3
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_1_3
    
    
    
        
    ; to do shift
    mov ax, shape_1f_r
    mov shift_row, ax
    call shift_down
    
        
    ; square 2
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_2_check_3:
    mov dx, shape_2s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je fill_4_check_3 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_2_check_3
    
    mov square2_fill, 1
    add fill_row_counter, 1
    
    
    
        
        
    ; delete row of square 2
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_2_3:
    mov dx, shape_2s_r ; start row
    
delete2_row_2_3:
    int 10h
    inc dx
    
    cmp dx, shape_2f_r ; finish row
    jnz delete2_row_2_3
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_2_3
    
    
    
    ; to do shift
    mov ax, shape_2f_r
    mov shift_row, ax
    call shift_down
    
    
    ; square 4
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_4_check_3:
    mov dx, shape_4s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je end_fill_check 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_4_check_3
    
    mov square4_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 4
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_4_3:
    mov dx, shape_4s_r ; start row
    
delete2_row_4_3:
    int 10h
    inc dx
    
    cmp dx, shape_4f_r ; finish row
    jnz delete2_row_4_3
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_4_3
    
    
        
    
    ; to do shift    
    mov ax, shape_4f_r
    mov shift_row, ax
    call shift_down
    
    jmp end_fill_check
    

shape_4_fill:

    ; square 1
    mov ah, 0DH
    mov cx, 21  ; start col
        
fill_1_check_4:
    mov dx, shape_1s_rr ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_4_check_4
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_1_check_4
    
    mov square1_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 1
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_1_4:
    mov dx, shape_1s_rr ; start row
    
delete2_row_1_4:
    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz delete2_row_1_4
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_1_4 
    
    
    
    
        
    ; to do shift
    mov ax, shape_1f_r
    mov shift_row, ax
    call shift_down
    
    ; square 4
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_4_check_4:
    mov dx, shape_4s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je end_fill_check 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_4_check_4
    
    mov square4_fill, 1
    add fill_row_counter, 1
    
    
       
        
    ; delete row of square 4
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_4_4:
    mov dx, shape_4s_r ; start row
    
delete2_row_4_4:
    int 10h
    inc dx
    
    cmp dx, shape_4f_r ; finish row
    jnz delete2_row_4_4
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_4_4 ;radife 4, shekl ba code 4 
    
        
    
    ; to do shift
    mov ax, shape_4f_r
    mov shift_row, ax
    call shift_down
    
    jmp end_fill_check
    

shape_5_fill:

    ; square 1
    mov ah, 0DH
    mov cx, 21  ; start col
        
fill_1_check_5:
    mov dx, shape_1s_rr ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_2_check_5
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_1_check_5
    
    mov square1_fill, 1
    add fill_row_counter, 1
    
    
    
    
        
    ; delete row of square 1
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_1_5:
    mov dx, shape_1s_rr ; start row
    
delete2_row_1_5:
    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz delete2_row_1_5
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_1_5
    
        
        
    ; to do shift
    mov ax, shape_1f_r
    mov shift_row, ax
    call shift_down
    
    ; square 2
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_2_check_5: ; square 2, shekl ba code 5
    
    mov dx, shape_2s_r ; start row
    inc dx
            
    int 10h
    
    cmp al, 0
    je fill_3_check_5 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_2_check_5
    
    mov square2_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 2
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_2_5:
    mov dx, shape_2s_r ; start row
    
delete2_row_2_5:
    int 10h
    inc dx
    
    cmp dx, shape_2f_r ; finish row
    jnz delete2_row_2_5
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_2_5
    
    
    
        
    
    ; to do shift    
    mov ax, shape_2f_r
    mov shift_row, ax
    call shift_down    
    
    ; square 3
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_3_check_5:
    mov dx, shape_3s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_4_check_5
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_3_check_5
    
    mov square3_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 3
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_3_5:
    mov dx, shape_3s_r ; start row
    
delete2_row_3_5:
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz delete2_row_3_5
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_3_5
    
    
        
    
    ; to do shift
    mov ax, shape_3f_r
    mov shift_row, ax
    call shift_down
    
        
    ; square 4
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_4_check_5:
    mov dx, shape_4s_r ; start row
    inc dx
            
    int 10h
    
    cmp al, 0
    je end_fill_check 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_4_check_5
    
    mov square4_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 4
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_4_5:
    mov dx, shape_4s_r ; start row
    
delete2_row_4_5:
    int 10h
    inc dx
    
    cmp dx, shape_4f_r ; finish row
    jnz delete2_row_4_5
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_4_5
    
        
    
    ; to do shift
    mov ax, shape_4f_r
    mov shift_row, ax
    call shift_down
    
    jmp end_fill_check
    

shape_6_fill:

    
    ; square 3
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_3_check_6:
    mov dx, shape_3s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_4_check_6
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_3_check_6
    
    mov square3_fill, 1
    add fill_row_counter, 1
    
    
        
        
    ; delete row of square 3
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_3_6:
    mov dx, shape_3s_r ; start row
    
delete2_row_3_6:
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz delete2_row_3_6
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_3_6
    
    
    
    ; to do shift
    mov ax, shape_3f_r
    mov shift_row, ax
    call shift_down
           
    ; square 4
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_4_check_6:
    mov dx, shape_4s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je end_fill_check 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_4_check_6
    
    mov square4_fill, 1
    add fill_row_counter, 1
    
    
        
    
        
    ; delete row of square 4
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_4_6:
    mov dx, shape_4s_r ; start row
    
delete2_row_4_6:
    int 10h
    inc dx
    
    cmp dx, shape_4f_r ; finish row
    jnz delete2_row_4_6
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_4_6
    
    
    ; to do shift
    mov ax, shape_4f_r
    mov shift_row, ax
    call shift_down
    
    jmp end_fill_check
    

shape_7_fill: 


    ; square 3
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_3_check_7:
    mov dx, shape_3s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_2_check_7
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_3_check_7
    
    mov square3_fill, 1
    add fill_row_counter, 1
    
        
        
    ; delete row of square 3
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_3_7:
    mov dx, shape_3s_r ; start row
    
delete2_row_3_7:
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz delete2_row_3_7
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_3_7
    
    
            
    
    ; to do shift
    mov ax, shape_3f_r
    mov shift_row, ax
    call shift_down
    
       
    
    ; square 2
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_2_check_7: ; square 2, shekl ba code 5

    mov dx, shape_2s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je fill_1_check_7 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_2_check_7
    
    mov square2_fill, 1
    add fill_row_counter, 1
    
         
        
    ; delete row of square 2
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_2_7:
    mov dx, shape_2s_r ; start row
    
delete2_row_2_7:
    int 10h
    inc dx
    
    cmp dx, shape_2f_r ; finish row
    jnz delete2_row_2_7
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_2_7
    
   
    ; to do shift
    mov ax, shape_2f_r
    mov shift_row, ax
    call shift_down
        


    ; square 1
    mov ah, 0DH
    mov cx, 21  ; start col
        
fill_1_check_7:
    mov dx, shape_1s_rr ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  end_fill_check 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_1_check_7
    
    mov square1_fill, 1
    add fill_row_counter, 1
    
            
        
    ; delete row of square 1
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_1_7:
    mov dx, shape_1s_rr ; start row
    
delete2_row_1_7:
    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz delete2_row_1_7
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_1_7
    
    
    ; to do shift    
    mov ax, shape_1f_r
    mov shift_row, ax
    call shift_down

    
    jmp end_fill_check
    
    
shape_8_fill:


    ; square 4
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_4_check_8:
    mov dx, shape_4s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_3_check_8 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_4_check_8
    
    mov square4_fill, 1
    add fill_row_counter, 1 
    
    
        
        
    ; delete row of square 4
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_4_8:
    mov dx, shape_4s_r ; start row
    
delete2_row_4_8:
    int 10h
    inc dx
    
    cmp dx, shape_4f_r ; finish row
    jnz delete2_row_4_8
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_4_8
    
    
    ; to do shift
    mov ax, shape_4f_r
    mov shift_row, ax
    call shift_down

   
    
    ; square 3
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_3_check_8:
    mov dx, shape_3s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  end_fill_check
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_3_check_8
    
    mov square3_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 4
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_3_8:
    mov dx, shape_3s_r ; start row
    
delete2_row_3_8:
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz delete2_row_3_8
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_3_8 
    
        
    ; to do shift
    mov ax, shape_3f_r
    mov shift_row, ax
    call shift_down
    
        
    
    
    jmp end_fill_check
    
   
shape_9_fill:

    ; square 2
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_2_check_9: ; square 2, shekl ba code 5

    mov dx, shape_2s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je fill_4_check_9 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_2_check_9
    
    mov square2_fill, 1
    add fill_row_counter, 1 
    
    
    
        
    ; delete row of square 2
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_2_9:
    mov dx, shape_2s_r ; start row
    
delete2_row_2_9:
    int 10h
    inc dx
    
    cmp dx, shape_2f_r ; finish row
    jnz delete2_row_2_9
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_2_9
    
        
    
    ; to do shift
    mov ax, shape_2f_r
    mov shift_row, ax
    call shift_down    
        
    ; square 4
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_4_check_9:
    mov dx, shape_4s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je end_fill_check 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_4_check_9
    
    mov square4_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 4
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_4_9:
    mov dx, shape_4s_r ; start row
    
delete2_row_4_9:
    int 10h
    inc dx
    
    cmp dx, shape_4f_r ; finish row
    jnz delete2_row_4_9
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_4_9
    
        
    
    ; to do shift    
    mov ax, shape_4f_r
    mov shift_row, ax
    call shift_down
    
    jmp end_fill_check


shape_10_fill:

    ; square 1
    mov ah, 0DH
    mov cx, 21  ; start col
        
fill_1_check_10:
    mov dx, shape_1s_rr ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_2_check_10
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_1_check_10
    
    mov square1_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 1
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_1_10:
    mov dx, shape_1s_rr ; start row
    
delete2_row_1_10:
    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz delete2_row_1_10
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_1_10
    
        
    ; to do shift
    mov ax, shape_1f_r
    mov shift_row, ax
    call shift_down
    
    ; square 2
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_2_check_10: ; square 2, shekl ba code 5

    mov dx, shape_2s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je fill_3_check_10 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_2_check_10
    
    mov square2_fill, 1
    add fill_row_counter, 1
    
    
    
    
        
    ; delete row of square 2
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_2_10:
    mov dx, shape_2s_r ; start row
    
delete2_row_2_10:
    int 10h
    inc dx
    
    cmp dx, shape_2f_r ; finish row
    jnz delete2_row_2_10
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_2_10
        
    
    ; to do shift    
    mov ax, shape_2f_r
    mov shift_row, ax
    call shift_down    
    
    ; square 3
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_3_check_10:
    mov dx, shape_3s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  end_fill_check
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_3_check_10
    
    mov square3_fill, 1
    add fill_row_counter, 1
    
    
     
    
        
    ; delete row of square 4
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_3_10:
    mov dx, shape_3s_r ; start row
    
delete2_row_3_10:
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz delete2_row_3_10
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_3_10 
      
    
    ; to do shift
    mov ax, shape_3f_r
    mov shift_row, ax
    call shift_down
    
    jmp end_fill_check


shape_11_fill: 



    ; square 4
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_4_check_11:
    mov dx, shape_4s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je fill_3_check_11 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_4_check_11
    
    mov square4_fill, 1
    add fill_row_counter, 1
    
    
    
        
    ; delete row of square 4
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_4_11:
    mov dx, shape_4s_r ; start row
    
delete2_row_4_11:
    int 10h
    inc dx
    
    cmp dx, shape_4f_r ; finish row
    jnz delete2_row_4_11
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_4_11

        
    
    ; to do shift
    mov ax, shape_4f_r
    mov shift_row, ax
    call shift_down
    
   
   
    ; square 3
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_3_check_11:
    mov dx, shape_3s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  end_fill_check
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_3_check_11
    
    mov square3_fill, 1
    add fill_row_counter, 1
    
    
            
    ; delete row of square 4
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_3_11:
    mov dx, shape_3s_r ; start row
    
delete2_row_3_11:
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz delete2_row_3_11
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_3_11
    
        
    
    ; to do shift    
    mov ax, shape_3f_r
    mov shift_row, ax
    call shift_down
        
        
    jmp end_fill_check
    

shape_12_fill:


    ; square 3
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_3_check_12:
    mov dx, shape_3s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  fill_2_check_12
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_3_check_12
    
    mov square3_fill, 1
    add fill_row_counter, 1
    
            
    ; delete row of square 3
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_3_12:
    mov dx, shape_3s_r ; start row
    
delete2_row_3_12:
    int 10h
    inc dx
    
    cmp dx, shape_3f_r ; finish row
    jnz delete2_row_3_12
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_3_12    
        
    
    ; to do shift
    mov ax, shape_3f_r
    mov shift_row, ax
    call shift_down

    
    
    ; square 2
    mov ah, 0DH
    mov cx, 21  ; start col
            
fill_2_check_12: ; square 2, shekl ba code 5

    mov dx, shape_2s_r ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je fill_1_check_12 
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_2_check_12
    
    mov square2_fill, 1
    add fill_row_counter, 1
    
    
        
        
    ; delete row of square 2
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_2_12:
    mov dx, shape_2s_r ; start row
    
delete2_row_2_12:
    int 10h
    inc dx
    
    cmp dx, shape_2f_r ; finish row
    jnz delete2_row_2_12
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_2_12
        
    
    ; to do shift
    mov ax, shape_2f_r
    mov shift_row, ax
    call shift_down
    
    

    ; square 1
    mov ah, 0DH
    mov cx, 21  ; start col
        
fill_1_check_12:
    mov dx, shape_1s_rr ; start row
    inc dx
        
    int 10h
    
    cmp al, 0
    je  end_fill_check
    
    add cx, 8
    cmp cx, 301 ; finish col
    jnz fill_1_check_12
    
    mov square1_fill, 1
    add fill_row_counter, 1
    
            
    ; delete row of square 1
    mov ah, 0ch
    mov al, 0  ; black color
    
    mov cx, 20 ; start col
        
delete1_row_1_12:
    mov dx, shape_1s_rr ; start row
    
delete2_row_1_12:
    int 10h
    inc dx
    
    cmp dx, shape_1f_r ; finish row
    jnz delete2_row_1_12
    
    inc cx
    cmp cx, 300 ; finish col
    jnz delete1_row_1_12
    
    
        
    ; to do shift
    mov ax, shape_1f_r
    mov shift_row, ax
    call shift_down
    
    
                
    jmp end_fill_check
              
    
end_fill_check:
    
    ; emtiyaz ra add mikonim ,------
    
    cmp fill_row_counter, 1
    jg score_plus_20    
    je score_plus_10
    
               
    call init_shape
    jmp  update_shape_end
    
score_plus_20:
    mov bx, my_score2
    add bx, 14h
    mov my_score, bx
    mov my_score2, bx    
    ;show new score
    call show_score
    
    call init_shape
    jmp update_shape_end

score_plus_10:
    
    mov bx, my_score2
    add bx, 0ah
    mov my_score, bx
    mov my_score2, bx    
    ;show new score
    call show_score
                    
    call init_shape
    jmp update_shape_end
             
update_shape_end:
    
    ret
endp update_shape


shift_down proc
             
    mov dx, shift_row ; row
    dec dx
            
shift_down_loop1:

    mov cx, 20 ; col 
    
shift_down_loop2:

    push dx
    sub dx, 8
    
    cmp dx, 28 ;19
    jle got_top_border
        
    mov ah, 0dH ; colore 8 pixel balatar ra bedast miavarim
    int 10h
    jmp line
    
got_top_border:
    mov al, 0 ; black

line:
    
    pop dx
    mov ah, 0cH
    int 10h ; range an ra taghir midahim
    
    inc cx
    cmp cx, 300
    jne shift_down_loop2
    
    dec dx
    cmp dx, 28 
    jne shift_down_loop1 
                
    ret
endp shift_down
                                   
end main
