br:	db 0ah
minus:	db	2dh
;void sys()
sys:
	int 80h
	ret

;void quit()
quit:
	mov eax,1
	mov ebx,0
	call sys
	ret

;space
space:
	pusha
	mov eax, 4
	mov ebx, 1
	mov ecx, spce
	mov edx, 1
	call sys
	popa
	ret

;breakline
breakline:
	push eax
	push ebx
	push ecx
	push edx
	mov eax, 4
	mov ebx, 1
	mov ecx, br
	mov edx, 1
	call sys
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

;int strlen(char *str)
;string in EAX
;length in EAX
strlen:
	push ebx
	mov ebx,eax
	;while(str[i] != '\n')
	.next_char:
		cmp byte[eax],0
		je .break
		inc eax
		jmp .next_char
	.break:
		sub eax,ebx
		pop ebx
		ret

;void sprintf(char *str)
;string in EAX
sprintf:
	push edx
	push ecx
	push ebx
	push eax
	call strlen

	mov edx, eax
	pop eax

	mov ecx, eax
	mov ebx, 1
	mov eax, 4
	call sys
	pop ebx
	pop ecx
	pop edx
	ret

;void sprintfLF(char *str)
;string in EAX
sprintfLF:
	call sprintf
	push eax
	mov eax,0ah
	push eax
	mov eax,esp
	call sprintf
	pop eax
	pop eax
	ret

;char *readString()
;string in esi
;len in edi
readString:
	push ecx
	xor ecx,ecx
	readChar:
		push eax
		push ebx
		push ecx
		push edx
		mov eax, 3
		mov ebx, 0
		mov ecx, n1
		mov edx, 1
		call sys
		pop edx
		pop ecx
		pop ebx
		pop eax
		cmp byte[n1],0ah
		je endreadChar
		push eax
		mov al,byte[n1]
		mov byte[esi + ecx],al
		pop eax
		inc ecx
		jmp readChar
	endreadChar:
	mov byte[esi + ecx],0
	mov edi,ecx
	pop ecx
	ret

;char *reverse(char *str)
;string in esi
;reversed required in edi
reverse:
	push ecx
	push ebx
	push eax
	push esi
	mov eax,esi
	call strlen
	mov ebx,eax
	dec eax
	mov ecx,eax	;r = len for esi
	xor edx,edx	;i = 0	for edi
	rev:
		cmp edx,ebx
		je endrev
		mov al,byte[esi + ecx]
		mov byte[edi + edx],al
		inc edx
		dec ecx
		jmp rev
	endrev:
	mov byte[edi + edx],0
	pop esi
	pop eax
	pop ebx
	pop ecx
	ret

;fstring in esi
;sstring in edi
;res in edx true if edx = 1 and edx = 0 if false
compare:
	push ebx
	push eax
	push ecx
	mov edx,1
	mov eax,esi
	call strlen
	mov ebx,eax
	mov eax,edi
	call strlen
	cmp ebx,eax
	je comparator
	mov edx,0
	jmp exitcomparator
	xor ecx,ecx
	comparator:
		cmp ecx,ebx
		je exitcomparator
		mov al,byte[esi + ecx]
		cmp al,byte[edi + ecx]
		je continuecomp
		mov edx, 0
		jmp exitcomparator
		continuecomp:
		inc ecx
		jmp comparator
	exitcomparator:
	pop ecx
	pop eax
	pop ebx
	ret

;bool isPalindrome(char *str)
;string in esi
;res in edx true if edx = 1 and false if edx = 0
isPalindrome:
	push edi
	push eax
	push ebx
	push ecx
	mov edi,tmp
	call reverse
	call compare
	pop ecx
	pop ebx
	pop eax
	pop edi
	ret

;f_string in esi
;s_string in edi
;res in ecx
concatenate:
	push ecx
	push edi
	push esi
	push ebx
	push eax
	xor ebx,ebx
	mov eax,esi
	call strlen
	first_fill:
		cmp ebx,eax
		je exit_first_fill
		push edx
		mov dl,byte[esi + ebx]
		mov byte[ecx + ebx],dl
		pop edx
		inc ebx
		jmp first_fill
	exit_first_fill:
	xor esi,esi
	mov eax,edi
	mov byte[ecx + ebx],' '
	inc ebx
	call strlen
	second_fill:
		cmp esi,eax
		je exit_concatenate
		push edx
		mov dl,byte[edi + esi]
		mov byte[ecx + ebx],dl
		pop edx
		inc ebx
		inc esi
		jmp second_fill
	exit_concatenate:
	mov byte[ecx + ebx],0
	pop eax
	pop ebx
	pop esi
	pop edi
	pop ecx
	ret

;bool isVowel(char ch)
;bl contains character
;eax = 1 if true and eax = 0 o/w
isVowel:
	cmp bl,97
	je YES
	cmp bl,65
	je YES
	cmp bl,101
	je YES
	cmp bl,69
	je YES
	cmp bl,105
	je YES
	cmp bl,73
	je YES
	cmp bl,111
	je YES
	cmp bl,79
	je YES
	cmp bl,117
	je YES
	cmp bl,85
	je YES
	NO:
	mov eax,0
	jmp EXIT_V
	YES:
	mov eax,1
	EXIT_V:
	ret

;string in ESI
;idx0 in EAX
;idx1 in ebx
;res in ecx=1 if true o/w ecx = 0
Comparator:
						push edi
						push eax
						push ebx
						push edx
						mov ecx,0
						xor edi,edi
						Compare:
										cmp byte[esi + eax],0
										je exit_comparator
										cmp byte[esi + ebx],0
										je exit_comparator
										cmp byte[esi + eax],' '
										je exit_comparator
										cmp byte[esi + ebx],' '
										je exit_comparator
										mov edx,eax
										push eax
										xor eax,eax
										mov al,byte[esi + ebx]
										cmp byte[esi + edx],al
										ja return_1
										je continue_Compare
										jb return_0
										return_1:
										pop eax
										mov ecx,1
										inc eax
										inc ebx
										jmp exit_comparator
										return_0:
										pop eax
										mov ecx,0
										inc eax
										inc ebx
										jmp exit_comparator
										continue_Compare:
										pop eax
										inc ebx
										inc eax
										jmp Compare
						exit_comparator:
										cmp ecx,0
										jne g1
										dec eax
										dec ebx
										push edx
										mov dl,byte[esi + eax]
										cmp byte[esi + ebx],dl
										jne RETURNED
										pop edx
										inc eax
										inc ebx
										cmp byte[esi + eax],0
										je g1
										cmp byte[esi + eax],' '
										je g1
										mov ecx,1
										jmp g1
										RETURNED:
										pop edx
										g1:
										pop edx
										pop ebx
										pop eax
										pop edi
										ret

;int str_to_int(char *str)
;string in ESI
;integer in EAX
atoi:
	push esi
	xor ebx,ebx
	.loop:
		cmp byte[esi],0ah
		je .exit
		movzx eax,byte[esi]
		inc esi
		sub eax,48
		imul ebx,10
		add ebx,eax
		jmp .loop
	.exit:
		mov eax,ebx
		pop esi
		ret

;convert to signed or unsigned
;esi contains string
;result in eax
atosigned:
	push esi
	cmp byte[esi],45
	je sign
	unsign:
		call atoi
		jmp exit_u
	sign:
		inc esi
		call atoi
		not eax
		inc eax			;two's complement
		jmp exit_u
	exit_u:
		pop esi
		ret

;print integer
;n in eax
iprintf:
	push eax
	push ecx
	push edx
	push edi

	xor ecx,ecx
	cmp eax,0
	jne put_sign
	push eax
	mov eax,48
	push eax
	mov eax,esp
	call sprintf
	pop eax
	pop eax
	jmp break_print_digit

	put_sign:
	push eax
	shr eax,31
	and eax,1
	cmp eax,1
	pop eax
	jne .digit_loop
	push eax
	mov eax,45
	push eax
	mov eax,esp
	call sprintf
	pop eax
	pop eax
	not eax
	inc eax

	.digit_loop:
		cmp eax,0
		je .print_digit
		inc ecx
		xor edi,edi
		xor edx,edx
		mov edi,10
		idiv edi
		add edx,48
		push edx
		jmp .digit_loop
	.print_digit:
		cmp ecx,0
		je break_print_digit
		dec ecx
		mov eax,esp
		call sprintf
		pop edx
		jmp .print_digit
	break_print_digit:
		pop edi
		pop edx
		pop ecx
		pop eax
		ret


;maximum of two
;x in eax
;y in ebx
;max in ecx
max:
	push eax
	cmp eax,ebx
	jg greater
	jmp less
	greater:
		mov ecx,eax
		jmp exit
	less:
		mov ecx,ebx
		jmp exit
	exit:
		pop eax
		ret

;minimum of two
;x in eax
;y in ebx
;min in ecx
min:
	push eax
	cmp eax,ebx
	jg .less
	jmp .greater
	.less:
		mov ecx,ebx
		jmp .exit
	.greater:
		mov ecx,eax
		jmp .exit
	.exit:
		pop eax
		ret

;bool isDivisible(int a,int b) check if a%b == 0
;a in eax
;b in ebx
isDivisible:
	push eax
	push ebx
	xor edx,edx
	idiv ebx
	cmp edx,0
	je .y
	jmp .n
	.y:
		mov edx,1
		jmp .e
	.n:
		mov edx,0
		jmp .e
	.e:
		pop ebx
		pop eax
		ret

;bool isPrime(int n)
;n in eax
;ans in esi
isPrime:
	push edx
	push edi
	push eax
	push ebx
	mov esi,eax	;tmp = n
	xor edx,edx	;rem = 0
	mov edi,2
	idiv edi	;n = n/2
	mov ecx,eax	;h = n
	add ecx,1	;h = h + 1
	mov eax,esi	;n = tmp
	mov ebx,2	;i = 2
	cmp eax,1
	je not_prime
	.l:
		cmp ebx,ecx	;for (int i = 2;i < h;i++)
		je .break
		call isDivisible	;check if eax%ebx == 0
		cmp edx,1
		je not_prime
		inc ebx
		jmp .l
	.break:
		mov esi,1
		jmp return
	not_prime:
		mov esi,0
		jmp return
	return:
		pop ebx
		pop eax
		pop edi
		pop edx
		ret

;int *readArray(int *arr,int n)
;arr in esi
;n in ecx
readArray:
	push eax
	push ebx
	push edx
	push ecx
	mov edi,0
	xor eax,eax
	readNum:
		cmp eax,ecx
		je iter
		push eax
		push ebx
		push ecx
		push edx
		mov eax, 3
		mov ebx, 0
		mov ecx, n1
		mov edx, l1
		call sys
		push esi
		mov esi, n1
		call atosigned
		pop esi
		mov dword[esi + 4 * edi],eax
		pop edx
		pop ecx
		pop ebx
		pop eax
		inc eax
		inc edi
		jmp readNum
	iter:
		pop ecx
		pop edx
		pop ebx
		pop eax
		ret

;void printArray(int *arr,int n)
;arr in esi
;n in ecx
printArray:
	pusha
	xor ebx,ebx
	printArray_loop:
		cmp ebx,ecx
		je exit__
		mov eax,dword[esi + 4 * ebx]
		call iprintf
		call space
		inc ebx
		jmp printArray_loop
	exit__:
			popa
			ret

;i in eax
;j in ebx
;matrix in esi
;col in ecx
;address of a[i][j] in edx
access:
	push edi
	push ecx
	push esi
	mov edi,eax
	imul ecx,edi
	add ecx,ebx
	shl ecx,2
	add esi,ecx
	mov edx,esi
	pop esi
	pop ecx
	pop edi
	ret

;row in edx
;col in ecx
;matrix in esi
printMatrix:
	push edx
	push eax
	push ebx
	xor eax,eax	;i = 0
	printMat:
		cmp eax,edx
		je exit_printMat
		xor ebx,ebx	;j = 0
		inner_loop:
			cmp ebx,ecx
			je exit_inner_loop
			push eax
			push edx
			call access
			mov eax,dword[edx]
			call iprintf
			call space
			pop edx
			pop eax
			inc ebx
			jmp inner_loop
		exit_inner_loop:
		call breakline
		inc eax
		jmp printMat
	exit_printMat:
	pop ebx
	pop eax
	pop edx
	ret

;matrix0 in esi
;matrix1 in edi
;res_matrix in eax
;row in edx
;col in ecx
addMatrix:
	push ebx
	mov dword[j],0
	addMat:
		cmp [j],edx
		je exit_addMat
		mov dword[k],0
		inner_mat:
			cmp [k],ecx
			je Exit_inner_loop
			push eax
			push edx
			mov eax,[j]
			mov ebx,[k]

			call access
			mov ebx,dword[edx]	;ebx = A[j][k]

			push esi
			mov esi,edi
			push ebx
			mov ebx,[k]
			call access
			pop ebx
			add ebx,dword[edx]	;ebx = A[j][k] + B[j][k]
			pop esi
			pop edx
			pop eax
			push esi
			mov esi,eax
			push eax
			mov eax,[j]
			push edx
			push ebx
			mov ebx,[k]
			call access
			pop ebx
			mov dword[edx],ebx
			pop edx
			pop eax
			pop esi
			inc dword[k]
			jmp inner_mat
		Exit_inner_loop:
		inc dword[j]
		jmp addMat
	exit_addMat:
	pop ebx
	ret

;matrix in esi
;res in edi
;row in edx
;col in ecx
transpose:
	push eax
	push ebx
	mov dword[j],0
	t:
		cmp [j],edx
		je exit_t
		mov dword[k],0
		inner_t:
			cmp [k],ecx
			je exit_inner_t
			push eax
			push ebx
			push ecx
			push edx
			mov eax,[j]
			mov ebx,[k]
			call access
			mov eax,dword[edx]
			push eax
			push esi
			pop esi
			pop eax
			pop edx
			mov ecx,edx
			push edx
			push eax
			push esi
			mov esi,edi
			mov eax,[k]
			mov ebx,[j]
			call access
			pop esi
			pop eax
			mov dword[edx],eax
			pop edx
			pop ecx
			pop ebx
			pop eax
			inc dword[k]
			jmp inner_t
		exit_inner_t:
		inc dword[j]
		jmp t
	exit_t:
	pop ebx
	pop eax
	ret

section .data
spce:db ' '
tmp:	TIMES 100 db	0
a:db 'a'
A:db 'A'
e:db 'e'
E:db 'E'
i:db 'i'
I:db 'I'
o:db 'o'
O:db 'O'
u:db 'u'
U:db 'U'

section .bss
n1:	resb	100
l1:	resb	100
j:	resb	100
k:	resb	100
