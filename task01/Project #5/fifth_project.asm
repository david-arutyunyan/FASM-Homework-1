format PE console ; ������ ��������� �����

entry start ; ����� ����� � ���������

include 'win32a.inc' ; ������������ ����(��������� � �������)

section '.data' data readable writable ; ��������������������� ������, � ������� �� ����� ����������

        strA db 'Enter A: ', 0 ; strA - ����� �� ������(���������� �� ��������� ��� ����������). Define byte(db) - ������
        strB db 'Enter B: ', 0

        resStr db 'Pow: %d', 0 ; %d - ������� ��������������(�����)

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

                mov [C], 1

                jmp again

                again:
                cmp [B], 0
                je over
                    mov ecx, [B]
                    sub ecx, 1
                    mov [B], ecx

                    mov ebx, [C]
                    imul ebx, [A]
                    mov [C], ebx
                    jmp again

                over:

                push [C]
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