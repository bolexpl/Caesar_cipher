section .data
normal db "Program implementujący szyfr cezara.", 0ah, 0Ah, "Normalny napis: "
sizeNormal equ $-normal

napis db "Ala ma kota.", 0Ah
sizeNapis equ $-napis

encrypted db 0ah, "Zaszyfrowany napis: "
sizeEnc equ $-encrypted

decrypted db 0ah, "Odszyfrowany napis: "
sizeDec equ $-decrypted

key db 1

section .bss
napis2 resb sizeNapis
napis3 resb sizeNapis

section .text
	global _start
_start:
    mov rbp, rsp; for correct debugging
    
    ;pętla
    mov rcx, 0
    loop1:
    ;pobranie znaku z przesunięciem
    mov al, [napis+rcx]
    mov dl, al   ;kopia
    
    ;pomijanie znaków <'A'
    cmp al, 65
    js skip
    ;pomijanie znaków >'z'
    cmp al, 123
    jns skip
    ;pomijanie znaków 'Z'-'a'
    cmp al, 91
    js noskip   ;mniejsze od 'Z'
    cmp al, 96
    jns noskip  ;większe od 'a'
    jmp skip    ;else skip
    noskip:
    add al, [key]
    
    ;------------------czy wychodzi poza zakres liter
    ;czy to mała litera
    cmp dl, 96
    jns small
    
    ;duże litery
    cmp al, 91
    js skip
    sub al, 26
    jmp skip
    
    ;małe litery
    small:
    cmp al, 123
    js skip
    sub al, 26
    
    skip:
    mov [napis2+rcx], al
    
    
    mov rax, 0
    ;sterowanie pętlą
    inc rcx
    cmp rcx, sizeNapis
    jnz loop1
    
    ;------------------------------------------------------odszyfrowanie
    mov rcx, 0
    loop2:
    ;pobranie znaku z przesunięciem
    mov al, [napis2+rcx]
    mov dl, al   ;kopia
    
    ;pomijanie znaków <'A'
    cmp al, 65
    js skip2
    ;pomijanie znaków >'z'
    cmp al, 123
    jns skip2
    ;pomijanie znaków 'Z'-'a'
    cmp al, 91
    js noskip2   ;mniejsze od 'Z'
    cmp al, 96
    jns noskip2  ;większe od 'a'
    jmp skip2    ;else skip
    noskip2:
    sub al, [key]
    
    ;------------------czy wychodzi poza zakres liter
    ;czy to mała litera
    cmp dl, 91
    js big
    
    ;małe litery
    cmp al, 97
    jns skip2
    add al, 26
    jmp skip2
    
    ;duże litery
    big:
    cmp al, 65
    jns skip2
    add al, 26
    
    skip2:
    mov [napis3+rcx], al
    
    mov rax, 0
    ;sterowanie pętlą
    inc rcx
    cmp rcx, sizeNapis
    jnz loop2
    
    
    
    ;------------------------------------------------------------------------------------
    ;------------------------------------------------------------------------wyświetlenie
    ;normalny napis
    mov rax, 4
    mov rbx, 1
    mov rcx, normal
    mov rdx, sizeNormal
    int 80h
    mov rax, 4
    mov rbx, 1
    mov rcx, napis
    mov rdx, sizeNapis
    int 80h
    
    mov rax, 4
    mov rbx, 1
    mov rcx, encrypted
    mov rdx, sizeEnc
    int 80h
    
    ;przerobiony napis
    mov rax, 4
    mov rbx, 1
    mov rcx, napis2
    mov rdx, sizeNapis
    int 80h
    
    mov rax, 4
    mov rbx, 1
    mov rcx, decrypted
    mov rdx, sizeDec
    int 80h
    
    ;odszyfrowany napis
    mov rax, 4
    mov rbx, 1
    mov rcx, napis3
    mov rdx, sizeNapis
    int 80h
    
    ;koniec
    mov rax, 1
    mov rbx, 0
    int 80h
    
