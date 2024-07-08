.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
zacznij:
mov ah, 0 ; funkcja nr 0 ustawia tryb
; sterownika
mov al, 13H ; nr trybu
int 10H ; wywołanie funkcji systemu BIOS
mov ax, 0A000H ; adres pamięci ekranu
mov es, ax
mov cx, 200 ; liczba linii na ekranie
mov bx, 160 ; adres początkowy
ptl_lin:
mov byte PTR es:[bx], 10 ; kolor
; jasnozielony
add bx, 320
loop ptl_lin
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij