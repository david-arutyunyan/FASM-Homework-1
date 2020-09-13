format PE console ; Формат выходного файла

entry start ; Точка входа в программу

include 'win32a.inc' ; Заголовочный файл(константы и макросы)

section '.data' data readable writable ; Проинициализированные данные, к которым мы будем обращаться

        strA db 'Enter A: ', 0 ; strA - метка на данные(заменяется на указатель при компиляции). Define byte(db) - данные
        strB db 'Enter B: ', 0

        resStr db 'Pow: %d', 0 ; %d - функция форматирования(число)

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

section '.idata' import data readable ; Секция с импортируемыми из других библиотек функциями

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'