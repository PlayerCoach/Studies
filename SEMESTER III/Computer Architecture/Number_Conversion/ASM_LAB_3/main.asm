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
dziesiec dd 10 ; mno¿nik


dekoder db '0123456789ABCDEF'
poczatek_liczby db 0

liczba1 dd 0

; deklaracja tablicy 12-bajtowej do przechowywania
; tworzonych cyfr
dzielnik dd 1
znaki3 db 12 dup (?)
w1 dd 0
w0 dd 0
; obszar instrukcji (rozkazów) programu
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
	mov ebx, 10 ; dzielnik równy 10
konwersja: 
	mov edx, 0 ; zerowanie starszej czêœci dzielnej 
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
; wype³nienie pozosta³ych bajtów spacjami i wpisanie 
; znaków nowego wiersza 
wypeln: 
	or esi, esi		; cmp esi,0
	jz wyswietl ; skok, gdy ESI = 0 
	mov byte PTR [edi][esi], 20H ; kod spacji 
	dec esi ; zmniejszenie indeksu 
	jmp wypeln 

wyswietl: 
	mov byte PTR [edi+0], 0AH ; kod nowego wiersza 
	mov byte PTR [edi][23], 0AH ; kod nowego wiersza
; wyœwietlenie cyfr na ekranie 
	push dword PTR 24 ; liczba wyœwietlanych znaków 
	;push dword PTR OFFSET znaki ; adres wyœw. obszaru 
	push edi
	push dword PTR 1; numer urz¹dzenia (ekran ma numer 1) 
	call __write ; wyœwietlenie liczby na ekranie 
	add esp, 12 ; usuniêcie parametrów ze stosu

	
	popad
	add esp,24	; usuniêcie zmiennej dynamicznej
	;pop ebp
	ret
_wyswietl_EAX_sixfour ENDP

_wyswietl_EAX_hex PROC
; wyœwietlanie zawartoœci rejestru EAX
; w postaci liczby szesnastkowej
pusha ; przechowanie rejestrów

; rezerwacja 12 bajtów na stosie (poprzez zmniejszenie
; rejestru ESP) przeznaczonych na tymczasowe przechowanie
; cyfr szesnastkowych wyœwietlanej liczby
sub esp, 12
mov edi, esp ; adres zarezerwowanego obszaru
; pamiêci
; przygotowanie konwersji
mov ecx, 8 ; liczba obiegów pêtli konwersji
mov esi, 1 ; indeks pocz¹tkowy u¿ywany przy
; zapisie cyfr
; pêtla konwersji
ptl3hex:
; przesuniêcie cykliczne (obrót) rejestru EAX o 4 bity w lewo
; w szczególnoœci, w pierwszym obiegu pêtli bity nr 31 - 28
; rejestru EAX zostan¹ przesuniête na pozycje 3 - 0
rol eax, 4
; wyodrêbnienie 4 najm³odszych bitów i odczytanie z tablicy
; 'dekoder' odpowiadaj¹cej im cyfry w zapisie szesnastkowym
mov ebx, eax ; kopiowanie EAX do EBX
and ebx, 0000000FH ; zerowanie bitów 31 - 4 rej.EBX
mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
; przes³anie cyfry do obszaru roboczego
mov [edi][esi], dl
inc esi ;inkrementacja modyfikatora
loop ptl3hex ; sterowanie pêtl¹

; wpisanie znaku nowego wiersza przed i po cyfrach
 mov byte PTR [edi][0], 0
;mov byte PTR [edi][9], 10
; wyœwietlenie przygotowanych cyfr
push 8; 8 cyfr + 2 znaki nowego wiersza
push edi ; adres obszaru roboczego
push 1 ; nr urz¹dzenia (tu: ekran)
call __write ; wyœwietlenie
; usuniêcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych
; przez 3 rozkazy push przed rozkazem call
; i 12 bajtów zarezerwowanych na pocz¹tku podprogramu
add esp, 24

popa ; odtworzenie rejestrów
ret ; powrót z podprogramu
_wyswietl_EAX_hex ENDP

_wyswietl_EAX PROC
    pusha
    mov esi, 10 ; indeks w tablicy 'znaki'
    ;mov eax, qword PTR[liczba]
    mov ebx, 10 ; dzielnik równy 10

    konwersja:
    xor edx, edx ; zerowanie starszej czêœci dzielnej
    div ebx ; dzielenie przez 10, reszta w EDX,
    ; iloraz w EAX
    add dl, 30H ; zamiana reszty z dzielenia na kod
    ; ASCII
    mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
    dec esi ; zmniejszenie indeksu
    cmp eax, 0 ; sprawdzenie czy iloraz = 0
    jne konwersja ; skok, gdy iloraz niezerowy
    ; wype³nienie pozosta³ych bajtów spacjami i wpisanie
    ; znaków nowego wiersza

    wypeln:
    or esi, esi
    jz wyswietl ; skok, gdy ESI = 0
    mov byte PTR znaki [esi], 20H ; kod spacji
    dec esi ; zmniejszenie indeksu
    jmp wypeln
    wyswietl:
    mov byte PTR znaki [0], 0AH ; kod nowego wiersza
    mov byte PTR znaki [11], 0AH ; kod nowego wiersza
    ; wyœwietlenie cyfr na ekranie
    push dword PTR 12 ; liczba wyœwietlanych znaków
    push dword PTR OFFSET znaki ; adres wyœw. obszaru
    push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
    call __write ; wyœwietlenie liczby na ekranie
    add esp, 12 ; usuniêcie parametrów ze stosu
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
        je byl_enter ; skok, gdy naciœniêto Enter
        sub cl, 30H ; zamiana kodu ASCII na wartoœæ cyfry
        movzx ecx, cl ; przechowanie wartoœci cyfry w rejestrze ECX
        ; mno¿enie wczeœniej obliczonej wartoœci razy 10
        mul dword PTR dziesiec
        add eax, ecx ; dodanie ostatnio odczytanej cyfry
    jmp pobieraj_znaki ; skok na pocz¹tek pêtli
    byl_enter:
    ; wartoœæ binarna wprowadzonej liczby znajduje siê teraz w
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
    mov esi, esp ; adres zarezerwowanego obszaru pamiêci
    push dword PTR 10 ; max iloœæ znaków wczytyw. liczby
    push esi ; adres obszaru pamiêci
    push dword PTR 0; numer urz¹dzenia (0 dla klawiatury)
    call __read ; odczytywanie znaków z klawiatury
    add esp, 12 ; usuniêcie parametrów ze stosu
    mov eax, 0 ; dotychczas uzyskany wynik
    pocz_konw:
    mov dl, [esi] ; pobranie kolejnego bajtu
    inc esi ; inkrementacja indeksu
    cmp dl, 10 ; sprawdzenie czy naciœniêto Enter
    je gotowe ; skok do koñca podprogramu
    ; sprawdzenie czy wprowadzony znak jest cyfr¹ 0, 1, 2 , ..., 9
    cmp dl, '0'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, '9'
    ja sprawdzaj_dalej
    sub dl, '0' ; zamiana kodu ASCII na wartoœæ cyfry
    dopisz:
    shl eax, 4 ; przesuniêcie logiczne w lewo o 4 bity
    or al, dl ; dopisanie utworzonego kodu 4-bitowego 12
     ; na 4 ostatnie bity rejestru EAX
    jmp pocz_konw ; skok na pocz¹tek pêtli konwersji
    ; sprawdzenie czy wprowadzony znak jest cyfr¹ A, B, ..., F
    sprawdzaj_dalej:
    cmp dl, 'A'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, 'F'
    ja sprawdzaj_dalej2
    sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
    jmp dopisz
    ; sprawdzenie czy wprowadzony znak jest cyfr¹ a, b, ..., f
    sprawdzaj_dalej2:
    cmp dl, 'a'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, 'f'
    ja pocz_konw ; inny znak jest ignorowany
    sub dl, 'a' - 10
    jmp dopisz
    gotowe:
    ; zwolnienie zarezerwowanego obszaru pamiêci
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