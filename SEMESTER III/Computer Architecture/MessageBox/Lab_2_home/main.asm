.686
.model flat

extern __read:PROC
extern __write:PROC
extern _ExitProcess@4:PROC
extern _MessageBoxW@16:PROC
 
public _main
 
.data
 
tekst db 80 dup (0) 
len dd 0

tytul db 'A',0,'k',0,'o',0,0,0
 
latin2male db 0a5h,86h,0a9h,88h,0e4h,0a2h,98h,0abh,0beh     ;¹æê³ñóœŸ¿
latin2duze db 0a4h,8fh,0a8h,9dh,0e3h,0e0h,97h,8dh,0bdh      ;¥ÆÊ£ÑÓŒ¯
 
utf16male dw 0105h,0107h,0119h,0142h,0144h,00f3h,015bh,017ah,017ch      ;¹æê³ñóœŸ¿
utf16duze dw 0104h, 0106h,0118h,0141h,0143h,00d3h,015ah,0179h,017bh     ;¥ÆÊ£ÑÓŒ¯
 
magazyn dw 80 dup (0) ;dup (0) wypelnia magazyn samymi zerami
magazyn2 db 80 dup (0)
zamienione db 80 dup (0)
 
.code
 
_main PROC
 
;wczytuje tekst
push 80
push offset tekst
push 0  ;tryb odczytu
call __read
 
add esp,12
 
mov len,eax
mov esi,0
mov edi,0
 
doSpacji:           ;esi jest licznikiem
    mov dl,tekst[esi]
    ;mov dh,0       
    inc esi
    cmp dx, ' '
    je Nazwisko;przesuñ esi na indeks spacji
    jmp doSpacji
 
Nazwisko:
    mov dl, tekst[esi]     ;10h -> 00a5h -> 0104h
    ;mov dh,0
    inc esi
    cmp dl, 0ah            ; 0ah to enter
    je koniecNazwiska
    mov zamienione[edi], dl
    mov magazyn[2*edi],dx  ;przepisz znak do utf16
    mov magazyn2[edi], dl  ;przepisz znak do latin2
    inc edi
    jmp Nazwisko
 
koniecNazwiska:
    mov esi,0
    mov zamienione[edi], ' '
    mov magazyn[edi*2],' ';dodaj spacje
    mov magazyn2[edi], ' '
    inc edi
 
 
wczytajImie:
    mov dl,tekst[esi]
   ; mov dh, 0
    inc esi
    cmp dl, ' '
    je koniecImienia;wypisz magazyn jesli spacja
    mov zamienione[edi], dl
    mov magazyn[edi*2],dx
    mov magazyn2[edi], dl
    inc edi
    jmp wczytajImie
 
koniecImienia:
    mov esi,0
 
 
szukajMalych:
    mov dx, magazyn[2*esi]
    mov cl, magazyn2[esi]
    inc esi
    cmp esi,len
    je wypisz
    cmp dl,'a'
    jb szukajMalych
    cmp dl,'z'
    ja szukajPolskich
    sub dl,20h
    sub cl, 20h
    mov magazyn[2*esi-2],dx
    mov magazyn2[esi-1], cl
    jmp szukajMalych
    szukajPolskich:
    mov ecx,0
        szukanie:
        inc ecx
        cmp ecx, 9                  ; koniec petli kiedy skoncza sie polskie znaki
        ja szukajMalych
        cmp dl,latin2male[ecx-1]
        jne szukanie           
        mov dx,utf16duze[2*ecx-2]
        mov cl, latin2duze[ecx - 1]
        mov magazyn[2*esi-2],dx
        mov magazyn2[esi - 1], cl
        jmp szukajMalych
 
wypisz:
   push len
   ;push offset zamienione
   ;push 10H
   push offset magazyn2
   push 1
   call __write

wypiszMessage:
    push 0
    push offset tytul
    push offset magazyn
    push 0
    call _MessageBoxW@16
 
push 0
call _ExitProcess@4
    
_main ENDP
 
 
END