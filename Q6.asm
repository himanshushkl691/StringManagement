%include 'function.asm'

section .data
msg1:db	'Enter a string: ',0h
string0:	TIMES 100 db 0
result0:	TIMES 100 db 0

section .bss
len0:	resb	4

section .text
global _start
_start:
	mov eax, msg1
	call sprintf

	mov esi,string0
	call readString
	mov [len0],edi
	
	xor ecx,ecx		;z = 0
	xor ebx,ebx		;idx = 0
	mov esi,string0		;esi = string0
	mov edi,result0		;edi = result0
	xor eax,eax		;i = 0
	outerLoop:
		cmp eax,[len0]
		jnl exit_outer_loop
		push eax
		push ebx
		mov bl,byte[esi + eax]
		call isVowel
		pop ebx
		mov edx,eax
		pop eax
		mov ebx,eax
		cmp edx,1
		jne filler
		mov byte[edi + ecx],'a'
		inc ecx
		mov byte[edi + ecx],'n'
		inc ecx
		mov byte[edi + ecx],' '
		inc ecx
		filler:
			cmp ebx,dword[len0]
			jnl exit_filler
			cmp byte[esi + ebx],0
			je exit_filler
			cmp byte[esi + ebx],' '
			je exit_filler
			push eax
			mov al,byte[esi + ebx]
			mov byte[edi + ecx],al
			pop eax
			inc ecx
			inc ebx
			jmp filler
		exit_filler:
		mov byte[edi + ecx],' '
		inc ecx
		mov eax,ebx
		inc eax
		jmp outerLoop
	exit_outer_loop:
	dec ecx
	mov byte[edi + ecx],0
	mov eax,result0
	call sprintf
	call breakline
	call quit	
