.686
.model flat
extern _ExitProcess@4 : PROC


.data
radious dq ?
radious3 dq ?
x dq ?

;quadratic_eq 

a_param dq ? 
b_param dq ?
c_param dq ?

.code

_kula PROC

    push ebp
    mov ebp, esp

    ;; caclulate r
    fld qword ptr [ebp + 16] ; 2 argument czyli (8) + 8
    fld qword ptr [ebp + 8]

    mov eax, 2
    push eax

    fild  dword ptr [esp]
    pop eax

    fdivp st(1), st(0)
    fsub st(0),st(1) 
    fstp qword ptr radious
    fstp st(0)

    ;;calculate 3r

    mov eax, 3
    push eax
    fild dword ptr [esp]
    pop eax
    fld qword ptr radious
    fmulp 
    fstp qword ptr radious3

    ;;calculate x

    fld qword ptr [ebp + 32] ; 4 argument
    fld qword ptr [ebp + 16]
    fsubp 
    fstp qword ptr x

    ;; calculate comlicated stuff

    fld qword ptr x
    fmul st(0), st(0)
    fld qword ptr radious3
    fld qword ptr x
    fsubp
    fmulp

    ;; st(0) = x^2 ( 3r - x)

    fld qword ptr [ebp + 24] ; 3 argument
    fmul st(0), st(0)
    fld qword ptr radious3
    fld qword ptr [ebp + 24]
    fsubp
    fmulp

    ;;st(0) = a^2(3r-a)  st(1)= x^2 ( 3r - x)

    faddp

    fldpi
    mov eax, 3
    push eax
    fild dword ptr [esp]
    pop eax

    fdivp 

    fmulp

    ;; st(0) = to dlugie wyrazenie po prawej stronie

    mov eax, 4
    push eax
    fild dword ptr [esp]
    pop eax

    mov eax,3
    push eax
    fild dword ptr [esp]
    pop eax

    fdivp

    fldpi

    fmulp ;;st(0) = pi * 4/3

    fld qword ptr radious
    fld qword ptr radious
    fmul st(0), st(0)
    fmulp
    fmulp

    fsub st(0), st(1)
    fxch st(1)
    fstp st(0)

    pop ebp
    ret
_kula ENDP

_srednia_harm PROC
	push EBP
	mov EBP,ESP
	push esi
	push ecx

	mov ecx, [ebp + 12]
	mov esi, [ebp + 8]
	xor edx, edx

	finit
	fldz

	licz:

	fld1
	fld  dword ptr [esi + 4*edx]
	fdivp

	faddp 

	inc edx

	loop licz

	fild dword ptr[ebp+12]
	fdiv st(0), st(1)

	pop ecx
	pop esi
	pop ebp
	ret
_srednia_harm ENDP

_new_exp PROC
        push ebp
        mov ebp, esp
    
        finit
   
    
        fld1   ; => initialize sum 
        fld1 ; => initialize divisor
        fld qword ptr [ebp + 8] ; => initialize divident
        mov ecx, 1; initialize counter of main_loop  ecx = 20 - 1
        ; st(2) = SUM ; st(1) = n! st(0) = x^n 

        main_loop:
            fst st(3)
            fdiv st(0), st(1)
            fadd st(2), st(0)
            fxch st(3)

            inc ecx 

            fld qword ptr [ebp + 8]
            fmulp 

            fxch st(1)
            push ecx
            fild dword ptr [esp]
            pop ecx
            fmulp

            fxch st(1)
            cmp ecx, 19
        jne main_loop

        fstp st(0)
        fstp st(0)
        fxch st(1)
        fstp st(0)
   
        pop ebp
        ret
_new_exp ENDP

_quadratic_eq PROC
    push ebp
    mov ebp, esp
    push edi ; direction index will point to the array address
    mov edi, [ebp + 32] ; load address of the array
    finit 

    ; => load parameters into static memory
    fld qword ptr [ebp + 8]
    fstp qword ptr a_param

    fld qword ptr [ebp + 16]
    fstp qword ptr b_param

    fld qword ptr [ebp + 24]
    fstp qword ptr c_param

    ; => calculate delta
    
    fld b_param
    fmul st(0), st(0)

    fld a_param
    fld c_param
    fmulp ; == fmul

    mov eax, 4
    push eax
    fild dword ptr [esp]
    pop eax
    fmulp ; == fmul
    
    fsubp 
    fsqrt

    fld b_param
    fchs
    fsub st(0), st(1) ; -b - sqrt(delta)

    fld a_param
    mov eax, 2
    push eax
    fild dword ptr [esp]
    pop eax
    fmulp ; == fmul

    fdiv st(1), st(0)

    fxch st(1)

    fstp qword ptr [edi] ; => transfer x1 into memory st(0) = 2a st(1)  = sqrt(delta)

    fld qword ptr b_param
    fchs
    fadd st(0), st(2)
    fdiv st(0), st(1)

    fstp qword ptr [edi + 8]

    fstp st(0)
    fstp st(0)

    pop edi
    pop ebp
    ret
_quadratic_eq ENDP

END