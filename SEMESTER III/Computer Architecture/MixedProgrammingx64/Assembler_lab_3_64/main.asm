public szukaj64_max
public suma_siedmiu_liczb
.code

szukaj64_max PROC
	push rbx ; przechowanie rejestrów, ktore w x64 MUSZA pozostac takie same
	push rsi

	mov rbx, rcx ; adres tablicy
	mov rcx, rdx ; liczba elementów tablicy
	mov rsi, 0 ; indeks bie¿¹cy w tablicy
	
	mov rax, [rbx + rsi*8] ; przechowuje adres najwiekszego elementu tablicy, poki co pierwszego
	
	dec rcx ; to co w x86 ilosc obiegow mneijsza o 1 od wielkosci tablicy

	ptl: inc rsi 
		
		cmp rax, [rbx + rsi*8]
			jge dalej
		;else;
			mov rax, [rbx+rsi*8]

	dalej: loop ptl 

	pop rsi
	pop rbx
	ret
szukaj64_max ENDP

suma_siedmiu_liczb PROC

	push rbp
	mov rbp, rsp
	push rsi

	
	xor rsi, rsi
	mov rsi, 6

	mov rax, rcx
	add rax, rdx
	add rax, r8
	add rax, r9
	add rax, qword PTR [rbp + rsi*8]
	add rsi, 1
	add rax, qword PTR [rbp + rsi*8]
	add rsi, 1
	add rax, qword PTR [rbp + rsi*8]

	pop rsi
	pop rbp

	ret

suma_siedmiu_liczb ENDP

END