

[org 0x0100]
jmp start
size: dw 5
charonL: dw 0x072a,0x072a,0x072a
locations: dw 236, 248, 326
clrscr:
            push ax
            push cx
            push es
            push di
            mov ax,0xb800
            mov es,ax
            mov ax,0x0720
            mov di,0
            mov cx,2000
            cld
            rep stosw
            pop di
            pop es
            pop cx
            pop ax
            ret

printL:
            push ax
            push cx
            push dx
            push es
            push di
            push si
            mov ax,0xb800
            mov es,ax
            mov dx,locations
            mov cx,3
            mov si,0
innerL:
            mov ax,[charonL+si]
            mov dx,[locations+si]
            mov di,dx
            mov word[es:di],ax
            add si,2
            loop innerL

            pop si
            pop di
            pop es
            pop dx
            pop cx
            pop ax
            ret

delay:          ; delay the program
    push cx
    mov cx, 40000
loop1:    
    push cx
    pop cx
    loop loop1
    pop cx
    ret

checkHit:
        push di
        push si
        push cx
        mov cx,3
        add di,2
        mov si,0
loopC:
        cmp di,[locations+si]
        jne skip
        mov word[locations+si],0x0720
        add word[size],1
skip:
        add si,2
        loop loopC

        pop cx
        pop si
        pop di
        ret


movsnk:
        push ax
        push bx
        push cx
        push dx
        push si
        push es
        push di

        mov ax,0xb800
        mov es,ax
        xor ax,ax
        mov dx,0
        mov si,1998
inner:
        mov bx,[size]
        sub bx,1
        mov ax,0x072A
        mov di,dx
        mov cx,bx
mostIn:
        mov word[es:di],ax
        add di,2
        loop mostIn
        mov word[es:di],0x0740
        call checkHit
        call printL
        call delay
        call clrscr
        add dx,2
        sub si,1
        cmp si,0
        jne inner

        pop di
        pop es
        pop si
        pop dx
        pop cx
        pop ax
        ret

start: 
        call clrscr
        call movsnk

mov ax,4c00h
int 21h