.686
.model flat
extern _ExitProcess@4 : PROC


.data
; data here;
.code

_szukaj_max PROC
	push EBP
	mov EBP,ESP
	mov eax, [ebp + 8]
	cmp eax,[ebp + 12]
	jge porownaj_z_z ; x>= y
	mov eax, [ebp + 12]

	porownaj_z_z:
		cmp eax, [ebp + 16]
		jge koniec_porownan

	mov eax, [ebp + 16]

	koniec_porownan:
		pop ebp
		ret
_szukaj_max ENDP

_szukaj_max_cztery PROC
		push EBP
		mov EBP,ESP

		mov eax, [ebp + 8]
		cmp eax,[ebp + 12]
		jge porownaj_z_c ; a>= b
		mov eax, [ebp + 12]; b>a

		porownaj_z_c:
			cmp eax, [ebp + 16]
			jge porownaj_z_d ; c< a/b

		mov eax, [ebp + 16]; c>a/b

		porownaj_z_d:
			cmp eax, [ebp + 20]
			jge koniec ; a/b/c > d

		mov eax, [ebp + 20] ; d > a/b/c


		koniec:
			pop ebp
			ret
_szukaj_max_cztery ENDP

_plus_jeden PROC
	push ebp
	mov ebp,esp
	push ebx 
	mov ebx, [ebp+8]
	inc dword PTR [ebx]
	;mov eax, [ebx] ; odczytanie wartoœci zmiennej
	;inc eax ; dodanie 1
	;mov [ebx], eax ; odes³anie wyniku do zmiennej
	pop ebx
	pop ebp
	ret
_plus_jeden ENDP

_liczba_przeciwna PROC
	push ebp
	mov ebp, esp
	push ebx

	mov ebx, [ebp + 8]
	neg dword ptr [ebx]

	pop ebx
	pop ebp
	ret
_liczba_przeciwna ENDP

_odejmij_jeden PROC
	push ebp
	mov ebp, esp
	push ebx
	push eax

	mov ebx, [ebp + 8]
	mov eax, [ebx]
	dec dword ptr [eax]
	mov [ebx], eax

	pop eax
	pop ebx
	pop ebp
	ret
_odejmij_jeden ENDP

_przestaw PROC
	push ebp
	mov ebp,esp

	push ebx

	mov ebx, [ebp+8] 
	mov ecx, [ebp+12] ; liczba elementów tablicy
	dec ecx
	; wpisanie kolejnego elementu tablicy do rejestru EAX
	ptl:
		mov eax, [ebx]
		cmp eax, [ebx+4]
		jle gotowe ; skok, gdy nie ma przestawiania

		; zamiana s¹siednich elementów tablicy
		mov edx, [ebx+4]
		mov [ebx], edx
		mov [ebx+4], eax

		gotowe:
		add ebx, 4
	loop ptl 
	pop ebx
	pop ebp
	ret
_przestaw ENDP

END