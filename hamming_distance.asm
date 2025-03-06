section .data
    newLine db " ", 0xA
    lenNewLine equ $ - newLine
    
    word1 db "foo"
    lenWord1 equ $ - word1

    word2 db "bar"
    lenWord2 equ $ - word2
    
section .bss
    ham_dis resw 2
    counter resw 2
    onesPlace resb 1
    tensPlace resb 1

section .text
    global _start

_start:
    mov edi, counter
    xor edi, edi
    
    mov esi, word1
    mov esp, word2
    
    mov dl, [ham_dis]
    xor dl, dl
    
through_each_letter:
    cmp edi, lenWord1 - 1
    jg end_program
    
    cmp edi, lenWord2 - 1
    jg end_program

    xor cl, cl
    xor al, al

    mov cl, [esi + edi]
    mov al, [esp + edi]
        
    xor cl, al
    
    inc edi

check_result_for_ones:
    cmp cl, 0
    jz through_each_letter

    test cl, 1
    jnz inc_ham_dis
    
    shr cl, 1
    jmp check_result_for_ones

end_program:
    mov [ham_dis], dl

    xor eax, eax
    xor cl, cl
    
    mov ax, [ham_dis]
    mov cl, 10
    
    div cl
    
    add ah, '0'
    add al, '0'
    
    mov [onesPlace], ah
    mov [tensPlace], al

    mov eax, 4
    mov ebx, 1
    mov ecx, tensPlace
    mov edx, 1
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, onesPlace
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newLine
    mov edx, lenNewLine
    int 0x80

    mov eax, 1
    int 0x80
    
inc_ham_dis:
    inc dl
    shr cl, 1
    jmp check_result_for_ones
