
; https://guidedhacking.com/threads/fasm-simple-console-game.9576/

format PE console
entry main

include 'win32a.inc'
section '.text' code executable
main:
sub esp,4
mov dword[ebp-4],0
push dword 0
call [time]
add esp,4
push eax
call [srand]
add esp,4
call [rand]
call [rand]
call [rand]
mov ebx, 100
cdq
idiv ebx
inc edx
mov [nbRandom], edx

push title
call [printf]
add esp, 4

jmp game

; main loop
game:
push askMsg
call [printf]
add esp, 4

push nbInput
push scan
call [scanf]
add esp, 8

mov eax, [nbInput]
cmp eax, [nbRandom]
jb game.more

cmp eax, [nbRandom]
ja game.less

push winMsg
call [printf]
add esp, 4
push 0
call [ExitProcess]

.less:
push lessMsg
call [printf]
add esp, 4
jmp game
.more:
push moreMsg
call [printf]
add esp, 4
jmp game

section '.data' data readable writeable
nbRandom dd ?
nbInput dd ?

section '.rdata' data readable
formatout db "%d", 10, 0
title db 'More or less', 10, 0
winMsg db 'WP you find it', 10, 0
askMsg db 'What is the number? ', 0
lessMsg db 'It s less !', 10, 0
moreMsg db 'It s more !', 10, 0
scan db "%d", 0

section '.idata' data readable import
library kernel32, 'kernel32', \
msvcrt, 'msvcrt'

include 'api\kernel32.inc'
import msvcrt, printf, 'printf', \
scanf, 'scanf', \
rand, 'rand',\
srand, 'srand',\
time, 'time'

import kernel,\
ExitProcess, 'ExitProcess'
