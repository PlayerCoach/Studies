.686
.model flat
extern _ExitProcess@4 : PROC


.data
; data here;
.code
_szukaj_abs_min PROC
	push ebp
	mov ebp, esp
	
	push ebx
	push ecx
	push edi
	push esi
	push edx

	mov edx,ebp
	mov ebx, [ebp + 8] ; adres pierwszego elementu tablicy
	mov ecx, [ebp + 12] ; liczba elementów tablicy\
	

	mov esi, 7FFFFFFFh ; najwiêksza liczba
	mov eax, [ebx] ; przenoszê wartoœæ pierwszego elementu do rejestru eax

	szukaj:
		
		cmp eax, 0
		jge dalej ; je¿eli msb=1 to negujê liczbê
		neg eax
		dalej:
	
		cmp esi, eax ; porównujê z najmanijesz¹ liczb¹
		jb dalej2
		mov esi ,eax ; jeœli mniejsza to zamieniam

		dalej2:
		add ebx, 4
		mov eax,[ebx]
		dec ecx
	jnz szukaj
	
	mov eax, esi
	pop edx
	pop esi
	pop edi
	pop ecx
	pop ebx
	pop ebp
	ret
_szukaj_abs_min ENDP


END