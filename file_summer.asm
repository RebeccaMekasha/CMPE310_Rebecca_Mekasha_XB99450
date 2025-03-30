section .data
	user_file_name_text db "Please enter a file name: ", 0
	len_user_file_name_text equ $ - user_file_name_text
	new_line db "", 0xA
	len_new_line equ $ - new_line

section .bss
	file_name resb 100
	file_info resb 6006
	current_num resd 1
	current_digit resb 1
	total resd 1
	print_num resb 1

section .text
	global _start

_start:
	call getFile
	call resetSetup

	mov ecx, file_name
	call removeNewLine
	call resetSetup

	call fileOpening
	call resetSetup

	mov ecx, file_info

	mov ebp, 1
	call sumTheFile

	mov ebp, esi
	xor esi, esi

	call sumTheFile
	call finalAdd

getFile:
	mov eax, 4
	mov ebx, 1
	mov ecx, user_file_name_text
	mov edx, len_user_file_name_text
	int 0x80

	mov eax, 3
	mov ebx, 2
	mov ecx, file_name
	mov edx, 100
	int 0x80
	ret

removeNewLine:
	mov bl, [ecx]

	cmp bl, 0Ah
	je foundNewLine

	cmp bl, 0
	je doneCounting

	inc ecx
	jmp removeNewLine

foundNewLine:	
	mov byte [ecx], 0
	ret

fileOpening:
	mov eax, 5
	mov ebx, file_name
	mov ecx, 0
	int 0x80

	mov ebx, eax
	mov eax, 3
	mov ecx, file_info
	mov edx, 6006
	int 0x80

	mov eax, 6
	int 0x80

	ret

sumTheFile:
	mov bl, [ecx]
	
	cmp ebp, 0
	jle doneCounting

	cmp bl, 0
	je finalAdd

	cmp bl, 0Ah
	je newLineAdd

	sub bl, '0'
	mov [current_digit], bl

	mov eax, 10
	xor edx, edx
	mul edi

	mov [current_num], eax
	mov edi, [current_num]
	mov edx, [current_digit]

	add edi, edx

	inc ecx
	jmp sumTheFile

newLineAdd:
	add esi, edi

	xor edi, edi
	mov [current_num], edi

	inc ecx
	dec ebp
	jmp sumTheFile

doneCounting:
	ret

finalAdd:
	add esi, edi

	xor edi, edi
	mov [current_num], edi

	mov [total], esi
	call resetSetup

getDigits:
	xor edx, edx
	mov ebx, 10
	mov eax, [total]
	div ebx

	mov [total], eax

	add edx, '0'
	mov [print_num], edx

	mov rsi, [print_num]
	push rsi

	cmp eax, 0
	je startPrinting

	inc ecx
	jmp getDigits

startPrinting:
	mov edi, ecx

printLoop:
	pop rsi
	mov [print_num], esi

	mov eax, 4
	mov ebx, 1
	mov ecx, print_num
	mov edx, 1
	int 0x80

	cmp edi, 0
	je exit

	dec edi
	jmp printLoop

exit:
	mov eax, 4
	mov ebx, 1
	mov ecx, new_line
	mov edx, len_new_line
	int 0x80

	mov eax, 1
	int 0x80

resetSetup:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor esi, esi
	xor edi, edi
	ret
