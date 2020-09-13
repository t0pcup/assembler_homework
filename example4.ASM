
; self-written

format PE console
entry main

include 'win32a.inc'
section '.text' code executable

main:
push helloMsg ; says hello
call [printf]
add esp, 4

push name ; to enter the name
push scan
call [scanf]
add esp, 8
;mov eax, [name]

push hobbyMsg1 ; asks about hobby
call[printf]
push name
call[printf]
push hobbyMsg2
call[printf]
add esp, 4

push hobby ; to enter the hobby
push scan
call [scanf]
add esp, 8
mov eax, [hobby]

push answerMsg ; answers about hobby
call[printf]
add esp, 4

push 0
call [ExitProcess]


section '.data' data readable writeable
name dd ?
hobby dd ?

section '.rdata' data readable
formatout db "%d", 10, 0
helloMsg db 'Hello, I am assembler. What is your name, human?', 10, 0
hobbyMsg1 db 'Nice to meet you ', 0, 0
hobbyMsg2 db '. I like chatting to humans. What is your hobby?', 10, 0
answerMsg db 'Wow, sounds nice! Maybe I will try it one day...', 10, 0
scan db "%d", 0

section '.idata' data readable import
library kernel32, 'kernel32', \
msvcrt, 'msvcrt'

include 'api\kernel32.inc'
import msvcrt, printf, 'printf', \
scanf, 'scanf', \
srand, 'srand',\
time, 'time'

import kernel,\
ExitProcess, 'ExitProcess'
