; Mikhaylova Ksenia, BSE192
; This program finds a minimum and a maximum char of a string
format  PE GUI 4.0 ; GUI app for windows
 
include 'win32ax.inc'
entry start ; choosing an entry point

.data ; data section
min dd '' ; minimum char
max dd '' ; maximum char
input_pointer dd ? ; command line pointer
string db 4096 dup(?) ; ASCII string
forming_str db "String: ""%s""", 10, 10, "min: %c", " (code: %d)", 10, "max: %c", " (code: %d)", 10, 0 ; format string
output_str db 4096 dup(?) ; output string
input_str db "%*s %[^", 0, "]", 10, 0 ; input string
default db "Remember, you can enter any sybmols from ASCII, even Cyrillic letters!", 0 ; default string if user don't enter string
help db "You should enter a string and the program will show the minimum and the maximum char code.", 10, 0 ; string for informing user what program does
 
data import ; import all windows functions we need
  library user32,'USER32.DLL', \
          msvcrt,'MSVCRT.DLL', \
          kernel32,'KERNEL32.DLL', \
          shell32,'SHELL32.DLL'
         
  import kernel32, \
           ExitProcess,'ExitProcess', \
           GetCommandLine,'GetCommandLineA'
  import user32, \                    
           MessageBox, 'MessageBoxA'
  import msvcrt, \
           sprintf, 'sprintf', \
           sscanf,  'sscanf', \
           strcmp, 'strcmp', \
           strcpy, 'strcpy'  
end data


.code ; code section
start: ; entry point
 
cinvoke GetCommandLine ; read the command line param
mov [input_pointer], eax ; put a pointer of a command line param from eax
cinvoke sscanf, [input_pointer], input_str, string ; reading input string
 
; there we check if user needs help
cinvoke strcmp, string, "-h"
cmp al, 0
jnz absence_of_h
cinvoke MessageBox, 0, help, "Output", MB_OK
cinvoke ExitProcess, 0
absence_of_h:
cinvoke strcmp, string, "-?"
cmp al, 0
jnz absence_of_question
cinvoke MessageBox, 0, help, "Output", MB_OK
cinvoke ExitProcess, 0
absence_of_question:
 
; if user entered an empty string we will use a default string instead
cinvoke strcmp, string, ""
cmp al, 0
jnz processing_input
cinvoke strcpy, string, default
 
processing_input:
push string ; push string to stack
call findMinMax ; call procedure to find minimum and maximum
add esp, 16 ; restoring stack after calling our procedure
mov [min], ecx ; putting minimum value from eax to min
call hahaSoCool
mov [max], edx ; putting maximum value from ebx to max

cinvoke sprintf, output_str, forming_str, string, [min], [min], [max], [max] ; forming an output string
cinvoke MessageBox, 0, output_str, "Output", MB_OK ; output
 
cinvoke ExitProcess,0 ; exit with code 0

proc findMinMax ; procedure for searching minimum and maximum char of a string
; at the and eax has a minimum value and ebx has a maximum value
 
mov esi, [esp+4] ; esi keeps a begining of a string
xor ecx, ecx
xor edx, edx
mov ecx, 255d ; min
mov edx, 0d ; max

;mov esi, [esp+4] 

iteration: ; checking a char of a string

mov eax, [esi] ; putting a char to al

cmp eax, 0 ; checking if char is a null-symbol (end of string)
jz end_of_str

cmp ecx, eax ; checking if we should update minimum
jb do_not_update_min
mov ecx, eax ; updating minimum
do_not_update_min:

cmp eax, edx ; checking if we should update maximum
jb do_not_update_max
mov edx, eax ; updating maximum
do_not_update_max:

inc esi ; moving to rhe next char
jmp iteration ; checking of a next char
 
end_of_str: ; cycle is over, minimum in ecx, maximum in edx
ret
endp ; end of procedure

proc hahaSoCool

iter:
cmp edx, 256
jl end_of_fun

sub edx, 256
dec ebx

jmp iter

end_of_fun:
ret

endp ; end of procedure