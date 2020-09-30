format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize   db 'size of vector? ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strVecElemI  db '[%d]? ', 0
        strScanInt   db '%d', 0
        strMinValue  db 'Min = %d', 10, 0
        strVecElemOut  db '[%d] = %d', 10, 0

        vec_size     dd 0
        min          dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?
        vec          rd 100

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) vector input
        call VectorInput
; 2) get vector min
        call VectorMin ; подготовка к проходу по массиву
        call VectorMinLoop ; ищем минимум в цикле
        call VectorMin ; подготовка к проходу по массиву
        call zeroVecLoop ; заменить нули минимальным
; 3) out of min
        push [min]
        push strMinValue
        call [printf]
; 4) test vector out
        call VectorOut
finish:
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jg  getVector
; fail size
        push vec_size
        push strIncorSize
        call [printf]
        push 0
        call [ExitProcess]
; else continue...
getVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector       ; to end of loop

        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        mov ebx, vec
        xor ecx, ecx
        ret
;--------------------------------------------------------------------------
VectorMin:
        xor ecx, ecx
        mov ebx, vec                 ; ebx = &vec
        ret ;kek3
VectorMinLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endZeroVector
        mov [i], ecx ; to end of loop

        mov eax, 0
        cmp [ebx], eax ; если текущий эл-т больше или меньше 0, проверяем не первый ли он

        jg firstMin
        jl firstMin
afterParty:

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4

        jmp VectorMinLoop

firstMin:
        cmp [min], 0
        je newMin  ; если ненулевой элемент первый в массиве, берем его как минимум
        jmp checkForMin ; иначе проверяем, меньше ли он, чем текущий минимум
checkForMin:
        mov edi, [ebx] ; [ebx] в регистр edi, чтобы видеть флаг
        cmp edi, [min] ; сравним с текущим минимумои
        jl newMin      ; если после вычитания [min] в edi поднялся ZF, делаем [ebx] новым минимумом
        jmp afterParty
newMin:
        mov ecx, [ebx]
        mov [min], ecx
        jmp afterParty
zeroVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endZeroVector
        mov [i], ecx

        mov edx, [ebx]
        cmp edx, 0
        je makeZeroMin
afterMk:
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp zeroVecLoop

makeZeroMin:
        mov edx, [min]
        mov [ebx], edx
        jmp afterMk

endZeroVector:
        ret
;--------------------------------------------------------------------------
VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
putVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        je endOutputVector      ; to end of loop
        mov [i], ecx

        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop
endOutputVector:
        mov esp, [tmpStack]
        ret
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'