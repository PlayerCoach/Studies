.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
; procedura obsługi przerwania zegarowego
    obsluga_zegara PROC
        push ax
        push bx
        push es
        push cx
        push di

        mov cx, 21
        mov ax, 0B800h ;adres pamieci ekranu
        mov es, ax

        mov al, 03h
        mov ah, 10H
        int 10h
        mov di, 0

        in al, 60h
        cmp al, 17 ; w
        je here
        cmp al, 31 ;s
        je here
        cmp al, 32 ;a
        je here
        cmp al, 30 ;d
        je here
        jmp stop
        
        here:
        move:
        mov bx, word ptr cs:[body_table + di]
        mov byte PTR es:[bx], '*' 
        mov byte PTR es:[bx+1], 10011110B ; 
        add di, 2
        cmp di, cs:body_size
        jb move

        ; zmienna 'licznik' zawiera adres biezacy w pamieci ekranu
        mov bx, word ptr cs:[body_table + 8]
        mov byte PTR es:[bx], '*' 
        mov byte PTR es:[bx+1], 00000000B ; 
        ;<==============MOVE=================>
       

        mov bx, word ptr cs:[body_table]
        mov word ptr cs:[body_table + 2], bx

        cmp cs:direction, 'w'
        jne notw
        sub word ptr cs:body_table, 160
        cmp word ptr cs:body_table, 0
        ja notw
        mov byte ptr cs:is_killed, 1
        jmp stop

        notw:

         cmp cs:direction, 's'
        jne nots
        add word ptr cs:body_table, 160
        cmp word ptr cs:body_table, 4000
        jb nots
        mov byte ptr cs:is_killed, 1
        jmp stop
        nots:

         cmp cs:direction, 'd'
        jne notd
        add word ptr cs:body_table, 2
        notd:

         cmp cs:direction, 'a'
        jne nota
        sub word ptr cs:body_table, 2
        nota:
        stop:
        pop di
        pop cx
        pop es
        pop bx
        pop ax
       
        jmp dword PTR cs:wektor8  ; skok do oryginalnej procedury obslugi przerwania zegarowego
        licznik dw 320 ; wyswietla od 2 wiersza
        wektor8 dd ? ; kod powrotu
        timer dw 20
        body_size dw 4
        body_table dw 2,4
        direction db ?
        move_direction db ?
        is_killed db 0
        
    obsluga_zegara ENDP
    ;============================================================
    zacznij:
        mov al, 0 ; video mode
        mov ah, 5
        int 10

        mov ax, 0
        mov ds,ax ; zerowanie rejestru DS
        mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
        mov cs:wektor8, eax

        ; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
        mov ax, SEG obsluga_zegara ; część segmentowa adresu
        mov bx, OFFSET obsluga_zegara ; offset adresu

        cli 
        ; zapisanie adresu procedury do wektora nr 8
        mov ds:[32], bx 
        mov ds:[34], ax 
        sti 

        ; oczekiwanie na naciśnięcie klawisza 'x'
        aktywne_oczekiwanie:
            cmp cs:is_killed, 00000001b
            je killed
            mov ah,1
            int 16H ; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeśli naciśnięto jakiś klawisz
            jz aktywne_oczekiwanie
            mov ah, 0
            int 16H ; odczytanie kodu ASCII naciśniętego klawisza (INT 16H, AH=0) do rejestru AL
            mov cs:direction, al
            cmp al, 'x' ; porównanie z kodem litery 'x'
            jne aktywne_oczekiwanie ; skok, gdy inny znak
        killed:
        mov eax, cs:wektor8 ;odtworzenie oryginalnej zawartości wektora nr 8

        cli
        mov ds:[32], eax ; przesłanie wartości oryginalnej do wektora 8 w tablicy wektorów przerwań <==> cli i sti zabezpiecza przed przerwaniami w trakcie
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