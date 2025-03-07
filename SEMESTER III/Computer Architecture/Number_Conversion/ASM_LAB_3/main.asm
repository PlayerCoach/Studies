.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC 
extern __read : PROC
public _main
; obszar danych programu
.data
; deklaracja tablicy 12-bajtowej do przechowywania
; tworzonych cyfr
znaki db 32 dup (?)
liczba db 50
znak_enter db 10

; deklaracja tablicy 12-bajtowej do przechowywania
; tworzonych cyfr

znaki2 db 11 dup (?)

; deklaracja tablicy do przechowywania wprowadzanych cyfr
obszar db 12 dup (?)
dziesiec dd 10 ; mno�nik


dekoder db '0123456789ABCDEF'
poczatek_liczby db 0

liczba1 dd 0

; deklaracja tablicy 12-bajtowej do przechowywania
; tworzonych cyfr
dzielnik dd 1
znaki3 db 12 dup (?)
w1 dd 0
w0 dd 0
; obszar instrukcji (rozkaz�w) programu
.code

_wyswietl_EAX_sixfour PROC
	;push ebp
	;mov ebp,esp
	sub esp,24  ; rezerwacja zmiennej dynamicznej
	mov edi,esp
	pushad
	;mov eax,[ebp+8]
	mov w1,edx  ; w1 = a1
	mov w0,eax  ; w0 = a0
	;lea edi,[ebp-12]
		
	mov esi, 22 ; indeks w tablicy 'znaki' 
	mov ebx, 10 ; dzielnik r�wny 10
konwersja: 
	mov edx, 0 ; zerowanie starszej cz�ci dzielnej 
	mov eax,w1
	div ebx ; dzielenie przez 10, reszta w EDX, 
			; iloraz w EAX 

	mov w1,eax 
	mov eax,w0
	div ebx
	mov w0,eax

	add dl, 30H ; zamiana reszty z dzielenia na kod ASCII 
	mov [edi][esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu 

	or eax, w1 ; w1 i w0 =0??? sprawdzenie czy iloraz = 0 
	jne konwersja ; skok, gdy iloraz niezerowy
; wype�nienie pozosta�ych bajt�w spacjami i wpisanie 
; znak�w nowego wiersza 
wypeln: 
	or esi, esi		; cmp esi,0
	jz wyswietl ; skok, gdy ESI = 0 
	mov byte PTR [edi][esi], 20H ; kod spacji 
	dec esi ; zmniejszenie indeksu 
	jmp wypeln 

wyswietl: 
	mov byte PTR [edi+0], 0AH ; kod nowego wiersza 
	mov byte PTR [edi][23], 0AH ; kod nowego wiersza
; wy�wietlenie cyfr na ekranie 
	push dword PTR 24 ; liczba wy�wietlanych znak�w 
	;push dword PTR OFFSET znaki ; adres wy�w. obszaru 
	push edi
	push dword PTR 1; numer urz�dzenia (ekran ma numer 1) 
	call __write ; wy�wietlenie liczby na ekranie 
	add esp, 12 ; usuni�cie parametr�w ze stosu

	
	popad
	add esp,24	; usuni�cie zmiennej dynamicznej
	;pop ebp
	ret
_wyswietl_EAX_sixfour ENDP

_wyswietl_EAX_hex PROC
; wy�wietlanie zawarto�ci rejestru EAX
; w postaci liczby szesnastkowej
pusha ; przechowanie rejestr�w

; rezerwacja 12 bajt�w na stosie (poprzez zmniejszenie
; rejestru ESP) przeznaczonych na tymczasowe przechowanie
; cyfr szesnastkowych wy�wietlanej liczby
sub esp, 12
mov edi, esp ; adres zarezerwowanego obszaru
; pami�ci
; przygotowanie konwersji
mov ecx, 8 ; liczba obieg�w p�tli konwersji
mov esi, 1 ; indeks pocz�tkowy u�ywany przy
; zapisie cyfr
; p�tla konwersji
ptl3hex:
; przesuni�cie cykliczne (obr�t) rejestru EAX o 4 bity w lewo
; w szczeg�lno�ci, w pierwszym obiegu p�tli bity nr 31 - 28
; rejestru EAX zostan� przesuni�te na pozycje 3 - 0
rol eax, 4
; wyodr�bnienie 4 najm�odszych bit�w i odczytanie z tablicy
; 'dekoder' odpowiadaj�cej im cyfry w zapisie szesnastkowym
mov ebx, eax ; kopiowanie EAX do EBX
and ebx, 0000000FH ; zerowanie bit�w 31 - 4 rej.EBX
mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
; przes�anie cyfry do obszaru roboczego
mov [edi][esi], dl
inc esi ;inkrementacja modyfikatora
loop ptl3hex ; sterowanie p�tl�

; wpisanie znaku nowego wiersza przed i po cyfrach
 mov byte PTR [edi][0], 0
;mov byte PTR [edi][9], 10
; wy�wietlenie przygotowanych cyfr
push 8; 8 cyfr + 2 znaki nowego wiersza
push edi ; adres obszaru roboczego
push 1 ; nr urz�dzenia (tu: ekran)
call __write ; wy�wietlenie
; usuni�cie ze stosu 24 bajt�w, w tym 12 bajt�w zapisanych
; przez 3 rozkazy push przed rozkazem call
; i 12 bajt�w zarezerwowanych na pocz�tku podprogramu
add esp, 24

popa ; odtworzenie rejestr�w
ret ; powr�t z podprogramu
_wyswietl_EAX_hex ENDP

_wyswietl_EAX PROC
    pusha
    mov esi, 10 ; indeks w tablicy 'znaki'
    ;mov eax, qword PTR[liczba]
    mov ebx, 10 ; dzielnik r�wny 10

    konwersja:
    xor edx, edx ; zerowanie starszej cz�ci dzielnej
    div ebx ; dzielenie przez 10, reszta w EDX,
    ; iloraz w EAX
    add dl, 30H ; zamiana reszty z dzielenia na kod
    ; ASCII
    mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
    dec esi ; zmniejszenie indeksu
    cmp eax, 0 ; sprawdzenie czy iloraz = 0
    jne konwersja ; skok, gdy iloraz niezerowy
    ; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
    ; znak�w nowego wiersza

    wypeln:
    or esi, esi
    jz wyswietl ; skok, gdy ESI = 0
    mov byte PTR znaki [esi], 20H ; kod spacji
    dec esi ; zmniejszenie indeksu
    jmp wypeln
    wyswietl:
    mov byte PTR znaki [0], 0AH ; kod nowego wiersza
    mov byte PTR znaki [11], 0AH ; kod nowego wiersza
    ; wy�wietlenie cyfr na ekranie
    push dword PTR 12 ; liczba wy�wietlanych znak�w
    push dword PTR OFFSET znaki ; adres wy�w. obszaru
    push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
    call __write ; wy�wietlenie liczby na ekranie
    add esp, 12 ; usuni�cie parametr�w ze stosu
    popa
    ret
_wyswietl_EAX ENDP



_wczytaj_do_EAX PROC
    push ebx
    push ecx
    push edx
    push ebp
    push esi
    push edi

    

    push dword PTR 12
    push dword PTR OFFSET obszar
    push dword PTR 0
    call __read
    add esp, 12
    mov eax, 0
    mov ebx, OFFSET obszar
    pobieraj_znaki:
        mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
        inc ebx
        cmp cl,znak_enter
        je byl_enter ; skok, gdy naci�ni�to Enter
        sub cl, 30H ; zamiana kodu ASCII na warto�� cyfry
        movzx ecx, cl ; przechowanie warto�ci cyfry w rejestrze ECX
        ; mno�enie wcze�niej obliczonej warto�ci razy 10
        mul dword PTR dziesiec
        add eax, ecx ; dodanie ostatnio odczytanej cyfry
    jmp pobieraj_znaki ; skok na pocz�tek p�tli
    byl_enter:
    ; warto�� binarna wprowadzonej liczby znajduje si� teraz w
    ;rejestrze EAX
    pop edi
    pop esi
    pop ebp
    pop edx
    pop ecx
    pop ebx
    ret
_wczytaj_do_EAX ENDP

_wczytaj_do_EAX_hex PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp
    sub esp, 12 ; rezerwacja poprzez zmniejszenie ESP
    mov esi, esp ; adres zarezerwowanego obszaru pami�ci
    push dword PTR 10 ; max ilo�� znak�w wczytyw. liczby
    push esi ; adres obszaru pami�ci
    push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
    call __read ; odczytywanie znak�w z klawiatury
    add esp, 12 ; usuni�cie parametr�w ze stosu
    mov eax, 0 ; dotychczas uzyskany wynik
    pocz_konw:
    mov dl, [esi] ; pobranie kolejnego bajtu
    inc esi ; inkrementacja indeksu
    cmp dl, 10 ; sprawdzenie czy naci�ni�to Enter
    je gotowe ; skok do ko�ca podprogramu
    ; sprawdzenie czy wprowadzony znak jest cyfr� 0, 1, 2 , ..., 9
    cmp dl, '0'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, '9'
    ja sprawdzaj_dalej
    sub dl, '0' ; zamiana kodu ASCII na warto�� cyfry
    dopisz:
    shl eax, 4 ; przesuni�cie logiczne w lewo o 4 bity
    or al, dl ; dopisanie utworzonego kodu 4-bitowego 12
     ; na 4 ostatnie bity rejestru EAX
    jmp pocz_konw ; skok na pocz�tek p�tli konwersji
    ; sprawdzenie czy wprowadzony znak jest cyfr� A, B, ..., F
    sprawdzaj_dalej:
    cmp dl, 'A'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, 'F'
    ja sprawdzaj_dalej2
    sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
    jmp dopisz
    ; sprawdzenie czy wprowadzony znak jest cyfr� a, b, ..., f
    sprawdzaj_dalej2:
    cmp dl, 'a'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, 'f'
    ja pocz_konw ; inny znak jest ignorowany
    sub dl, 'a' - 10
    jmp dopisz
    gotowe:
    ; zwolnienie zarezerwowanego obszaru pami�ci
    add esp, 12
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
_wczytaj_do_EAX_hex ENDP

_main PROC
 ;1 zadanie
    call _wczytaj_do_EAX_hex
    call _wyswietl_EAX
    mov liczba1, eax

    call _wczytaj_do_EAX_hex
    call _wyswietl_EAX

    ;2 zadanie
    mul liczba1
    call _wyswietl_EAX_sixfour
    ;call wyswietl_EAX
    
    push eax
    mov eax, edx
    call _wyswietl_EAX_hex
    pop eax
    call _wyswietl_EAX_hex
    ;3 zadanie


    push 0
    call _ExitProcess@4
    
_main ENDP
 
 
END