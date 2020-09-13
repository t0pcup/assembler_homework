format PE console ; Формат выходного файла

entry start ; Точка входа в программу

include 'win32a.inc' ; Заголовочный файл(константы и макросы)

section '.data' data readable writable ; Проинициализированные данные, к которым мы будем обращаться

        strA db 'Enter A: ', 0 ; strA - метка на данные(заменяется на указатель при компиляции). Define byte(db) - данные
        strB db 'Enter B: ', 0

        resStr db 'GCD: %d', 0 ; %d - функция форматирования(число)

        spaceStr db ' %d', 0

        A dd ? ; dd - Define double (2 машинных слова ~ 4 bytes)
        B dd ?
        C dd ?

        NULL = 0

section '.code' code readable executable ; Исполняемый код программы

        start:
                push strA ; Запихиваем в стек
                call [printf] ; Вызов функции

                push A
                push spaceStr
                call [scanf]

                push strB ; Запихиваем в стек
                call [printf] ; Вызов функции

                push B
                push spaceStr
                call [scanf]

                jmp again

                again:
                cmp [B], 0
                je over

                    mov eax, [A]
                    mov ecx, [B]
                    mov edx, 0

                    div ecx ; %
                    mov [C], edx

                    mov edx, [B]
                    mov [A], edx
                    mov ebx, [C]
                    mov [B], ebx

                    jmp again
                over:

                push [A]
                push resStr
                call [printf]

                call [getch]

                push NULL
                call [ExitProcess]

section '.idata' import data readable ; Секция с импортируемыми из других библиотек функциями

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'