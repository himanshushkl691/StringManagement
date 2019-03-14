%include 'function.asm'

section .data
msg1:db	'Enter a string: ',0h
string0:	TIMES 100 db 0
result0:	TIMES 100 db 0

section .bss
len0:	resb 4
len1:	resb 4
z:	resb 4

section .text
global _start
_start:
	mov eax,msg1
	call sprintf

	mov esi,string0
	call readString
	mov dword[len0],edi
	mov dword[len1],edi

	xor eax,eax	;i = 0
	mov eax,[len0]
	dec eax		;i = len0 - 1
	xor ecx,ecx	;z = 0
	xor ebx,ebx	;idx
	mov esi,string0	;esi = string0
	mov edi,result0	;edi = result0
	outerLoop:
		cmp eax,0
		jl exit_outer_loop
		inner_while:
			cmp eax,0
			jl continue_outer_loop
			cmp byte[esi + eax],' '
			je continue_outer_loop
			dec eax
			jmp inner_while
		continue_outer_loop:
		mov edx,eax
		xor ebx,ebx
		mov ebx,eax
		inc ebx				;idx = i + 1;
		filler:
			cmp ebx,dword[len0]
			jnl exit_filler
			cmp byte[esi + ebx],0h
			je exit_filler
			cmp byte[esi + ebx],' '
			je exit_filler
			push eax
			xor eax,eax
			mov al,byte[esi + ebx]
			mov byte[edi + ecx],al
			pop eax
			inc ebx
			inc ecx
			jmp filler
		exit_filler:
		mov byte[edi + ecx],32
		inc ecx
		mov eax,edx
		dec eax
		jmp outerLoop
	exit_outer_loop:
	dec ecx
	mov byte[edi + ecx],0
	mov eax,result0
	call sprintf
	call breakline
	call quit
