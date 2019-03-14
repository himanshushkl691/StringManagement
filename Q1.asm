%include 'function.asm'

section .data
msg1:db	'Enter first string: ',0h
msg2:db	'Enter second string: ',0h
string0:	TIMES 100 db 0
string1:	TIMES 100 db 0
result:		TIMES 200 db 0
arr:		TIMES 1000 dd 0

section .bss
len0:	resb	4
len1:	resb	4
len2:	resb	4
size:	resb	4
n_space:resb	4
tmp01:	resb	4

section .text
global _start
_start:
	mov eax, msg1
	call sprintf

	mov esi,string0
	call readString
	mov [len0],edi

	mov eax,msg2
	call sprintf

	mov esi,string1
	call readString
	mov [len1],edi

	mov dword[len2],edi
	mov edi,dword[len0]
	add dword[len2],edi

	mov esi,string0
	mov edi,string1
	mov ecx,result
	call concatenate

	;count number of words
	mov esi,result 								;esi = result
	mov dword[n_space],0					;n_space = 0
	xor eax,eax 									;i = 0
	count_space:
		cmp eax,[len2]
		jnl exit_count_space
		cmp byte[esi + eax],' '
		jne continue_cs
		inc dword[n_space]
		continue_cs:
		inc eax
		jmp count_space
	exit_count_space:
	inc dword[n_space]
	;number of words in string

	mov edi,result				;edi = result
	mov esi,arr						;esi = arr
	xor eax,eax						;i = 0
	xor ebx,ebx						;z = 0
	fill_array:
		cmp eax,[len2]
		jnl exit_fill_arr
		cmp eax,0
		jne continue0
		mov dword[esi + 4 * ebx],0
		inc ebx
		jmp continue1
		continue0:
			cmp byte[edi + eax],' '
			jne continue1
			mov dword[esi + 4 * ebx],eax
			inc dword[esi + 4 * ebx]
			inc ebx
			continue1:
			inc eax
			jmp fill_array
	exit_fill_arr:
	mov ebx,dword[n_space]
	mov dword[tmp01],ebx
	dec dword[tmp01]
	mov dword[size],ebx

	mov esi,result
	mov edi,arr
	xor ecx,ecx					;i = 0
	xor edx,edx					;j = 0
	BUBBLE_SORT:
			cmp ecx,dword[size]
			je EXIT_BUBBLE_SORT
			xor edx,edx				;j = 0
			SECOND_LOOP:
				cmp edx,dword[tmp01]
				je EXIT_SECOND_LOOP
				push edx
				push ecx
				push eax
				push ebx
				push esi
				mov eax,dword[edi + 4 * edx]
				push edx
				inc edx
				mov ebx,dword[edi + 4 * edx]
				pop edx
				call Comparator
				cmp ecx,1
				jne continue_SECOND_LOOP
				mov ecx,dword[edi + 4 * edx]				;tmp0 = arr[j]
				inc edx
				mov esi,dword[edi + 4 * edx]				;tmp1 = arr[j+1]
				mov dword[edi + 4 * edx],ecx				;arr[j+1] = tmp0
				dec edx
				mov dword[edi + 4 * edx],esi				;arr[j] = tmp1
				pop esi
				pop ebx
				pop eax
				pop ecx
				pop edx
				jmp goto
				continue_SECOND_LOOP:
						pop esi
						pop ebx
						pop eax
						pop ecx
						pop edx
						goto:
						inc edx
						jmp SECOND_LOOP
				EXIT_SECOND_LOOP:
				inc ecx
				jmp BUBBLE_SORT
	EXIT_BUBBLE_SORT:
	mov esi,result
	mov edi,arr
	xor eax,eax						;i = 0
	xor ebx,ebx						;z = 0
	print_string:
			cmp eax,dword[size]
			je exit_print_string
			xor ebx,ebx
			mov ebx,dword[edi + 4 * eax]
			inner_loop_print:
					cmp byte[esi + ebx],0
					je exit_inner_print_loop
					cmp byte[esi + ebx],' '
					je exit_inner_print_loop
					push eax
					xor eax,eax
					mov al,byte[esi + ebx]
					push eax
					mov eax,esp
					call sprintf
					pop eax
					pop eax
					inc ebx
					jmp inner_loop_print
					exit_inner_print_loop:
							call space
							inc eax
							jmp print_string
	exit_print_string:
	call breakline
	call quit
