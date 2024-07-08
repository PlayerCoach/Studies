.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
; podprogram 'wyswietl_AL' wyświetla zawartość rejestru AL
; w postaci liczby dziesiętnej bez znaku
wyswietl_AL PROC
; wyświetlanie zawartości rejestru AL na ekranie wg adresu
; podanego w ES:BX
; stosowany jest bezpośredni zapis do pamięci ekranu
; przechowanie rejestrów
push ax
push cx
push dx
mov cl, 10 ; dzielnik

mov ah, 0 ; zerowanie starszej części dzielnej
; dzielenie liczby w AX przez liczbę w CL, iloraz w AL,
; reszta w AH (tu: dzielenie przez 10)
div cl
add ah, 30H ; zamiana na kod ASCII
mov es:[bx+4], ah ; cyfra jedności
mov ah, 0
div cl ; drugie dzielenie przez 10
add ah, 30H ; zamiana na kod ASCII
mov es:[bx+2], ah ; cyfra dziesiątek
add al, 30H ; zamiana na kod ASCII
mov es:[bx+0], al ; cyfra setek
; wpisanie kodu koloru (intensywny biały) do pamięci ekranu
mov al, 00001111B
mov es:[bx+1],al
mov es:[bx+3],al
mov es:[bx+5],al
; odtworzenie rejestrów
pop dx
pop cx
pop ax
ret ; wyjście z podprogramu
wyswietl_AL ENDP

    obsluga_przerwan PROC
        push ax
        push bx
        push es
        push cx

        mov ax, 0B800h ;adres pamieci ekranu
        mov es, ax
        ; zmienna 'licznik' zawiera adres biezacy w pamieci ekranu
        in al, 60h
        call wyswietl_AL
        ; zwiększenie o 2 adresu bieżącego w pamięci ekranu
       

        pop cx
        pop es
        pop bx
        pop ax
       
        jmp dword PTR cs:wektor9  ; skok do oryginalnej procedury obslugi przerwania zegarowego

        wektor9 dd ?
    obsluga_przerwan ENDP
    ;============================================================
    zacznij:
        mov al, 0 ; video mode
        mov ah, 5
        int 10

        mov ax, 0
        mov ds,ax ; zerowanie rejestru DS
        mov eax, ds:[36] ; adres fizyczny 0*16 + 36 = 36
        mov cs:wektor9, eax

        ; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
        mov ax, SEG obsluga_przerwan ; część segmentowa adresu
        mov bx, OFFSET obsluga_przerwan ; offset adresu

        cli 
        ; zapisanie adresu procedury do wektora nr 9
        mov ds:[36], bx 
        mov ds:[38], ax 
        sti 

        ; oczekiwanie na naciśnięcie klawisza 'x'
        aktywne_oczekiwanie:
            mov ah,1
            int 16H ; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeśli naciśnięto jakiś klawisz
            jz aktywne_oczekiwanie
            
            mov ah, 0
            int 16H ; odczytanie kodu ASCII naciśniętego klawisza (INT 16H, AH=0) do rejestru AL
            cmp al, 'x' ; porównanie z kodem litery 'x'
            jne aktywne_oczekiwanie ; skok, gdy inny znak
        
        
        mov eax, cs:wektor9 ;odtworzenie oryginalnej zawartości wektora nr 8

        cli
        mov ds:[36], eax ; przesłanie wartości oryginalnej do wektora 8 w tablicy wektorów przerwań <==> cli i sti zabezpiecza przed przerwaniami w trakcie
        sti

       
        ;przerwanie programu i zwrócenie kontroli do programu wywołującego
        mov al, 0
        mov ah, 4CH
        int 21H

rozkazy ENDS
        nasz_stos SEGMENT stack
          db 128 dup (?)
        nasz_stos ENDS
    END zacznij