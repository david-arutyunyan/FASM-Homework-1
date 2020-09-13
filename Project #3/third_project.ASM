format PE console ; Формат выходного файла

entry start ; Точка входа в программу

include 'win32a.inc' ; Заголовочный файл(константы и макросы)

section '.data' data readable writable ; Проинициализированные данные, к которым мы будем обращаться

        strA db 'Enter A: ', 0 ; strA - метка на данные(заменяется на указатель при компиляции). Define byte(db) - данные
        strB db 'Enter B: ', 0

        spaceStr db ' %d', 0

        older db '%d more than %d!', 0
        younger db '%d less than %d!', 0
        same db '%d and %d are equal!', 0

        A dd ? ; dd - Define double (2 машинных слова ~ 4 bytes)
        B dd ?

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

                mov edx, [B]

                cmp [A], edx
                jge vers1
                   mov ecx, [A]
                   sub ecx, [B]

                   push [A]
                   push edx
                   push older
                   call [printf]

                   jmp finish
                vers1:

                cmp [A], edx
                jle vers2
                   mov ecx, [B]
                   sub ecx, [A]

                   push [A]
                   push edx
                   push younger
                   call [printf]

                   jmp finish
                vers2:

                cmp [A], edx
                jne vers3

                   push [A]
                   push edx
                   push same
                   call [printf]

                   jmp finish
                vers3:


                finish:

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