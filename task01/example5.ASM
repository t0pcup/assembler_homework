format PE console ; ������ ��������� �����

entry start ; ����� ����� � ���������

include 'win32a.inc' ; ������������ ����(��������� � �������)

section '.data' data readable writable ; ��������������������� ������, � ������� �� ����� ����������

        strA db 'Enter A: ', 0 ; strA - ����� �� ������(���������� �� ��������� ��� ����������). Define byte(db) - ������
        strB db 'Enter B: ', 0

        resStr db 'GCD: %d', 0 ; %d - ������� ��������������(�����)

        spaceStr db ' %d', 0

        A dd ? ; dd - Define double (2 �������� ����� ~ 4 bytes)
        B dd ?
        C dd ?

        NULL = 0

section '.code' code readable executable ; ����������� ��� ���������

        start:
                push strA ; ���������� � ����
                call [printf] ; ����� �������

                push A
                push spaceStr
                call [scanf]

                push strB ; ���������� � ����
                call [printf] ; ����� �������

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

section '.idata' import data readable ; ������ � �������������� �� ������ ��������� ���������

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'