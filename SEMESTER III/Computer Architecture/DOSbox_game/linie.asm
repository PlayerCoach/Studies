.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy
linia PROC
    ; <=======>PROLOG<=======>
    push ax
    push bx
    push es

    cmp cs:counter, 377
    je koniec
    mov ax, 0A000H ; adres pamięci ekranu dla trybu 13H
    mov es, ax

    mov bx, cs:adres_piksela ; adres bieżący piksela
    mov al, cs:kolor
    mov es:[bx], al ; wpisanie kodu koloru do pamięci ekranu
    ;add bx, cs:counter
    cmp cs:counter_slope, 7
    jb koniec
    mov cs:counter_slope, 0
    add bx, 322
    mov cs:adres_piksela, bx
    ; sprawdzenie czy cała linia wykreślona
    
    ; jb dalej 
    
    ; add word PTR cs:przyrost, 
    ; mov bx, 2
    ; add bx, cs:przyrost
    ; dalej:
    mov cs:adres_piksela, bx
    koniec:
    add cs:counter_slope, 1 ; <=======>EPILOG<=======>
    pop es
    pop bx
    pop ax
  
    jmp dword PTR cs:wektor8

    ; .data segment
    kolor db 1 ; bieżący numer koloru
    adres_piksela dw 0 ; bieżący adres piksela
    przyrost dw 0
    wektor8 dd ?
    counter dw 0
    counter_slope dw 0
linia ENDP

zacznij:
    mov ah, 0 ; argument
    mov al, 13H ; nr trybu
    int 10H ; wyołanie trybu graficznego, w trybie 13 320x200 pixeli 256 kolorów

    mov bx, 0
    mov es, bx ; zerowanie rejestru ES
    mov eax, es:[32] ; odczytanie wektora nr 8 // segment::offset
    mov cs:wektor8, eax ; zapamiętanie wektora nr 8, wektor 8 jest wektorem zegara
    

    mov ax, SEG linia
    mov bx, OFFSET linia

    cli ; zablokowanie przerwań
    mov es:[32], bx
    mov es:[32+2], ax
    sti ; odblokowanie przerwań

    czekaj:

        mov ah, 1 ; sprawdzenie czy jest jakiś znak
        int 16h ; w buforze klawiatury

    jz czekaj
    mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
    mov al, 3H ; text mode 80 columns 25 rows
    int 10H

    ; odtworzenie oryginalnej zawartości wektora nr 8
    mov eax, cs:wektor8
    mov es:[32], eax

    ; zakończenie wykonywania programu i zwróć kotrolę do systemu operacyjnego
    mov ax, 4C00H
    int 21H

rozkazy ENDS
stosik SEGMENT stack
db 256 dup (?)
stosik ENDS
END zacznij
