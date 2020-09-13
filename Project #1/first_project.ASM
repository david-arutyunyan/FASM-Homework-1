format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        formatStr db '%s', 0
        formatNum db '%d', 0

        name rd 2
        age rd 1

        wn db 'Hey! What is your name? ', 0
        ho db 'Hello %s, how old are you? ', 0

        older db 'Oh, you are %d years older than me!', 0
        younger db 'Oh, you are %d years younger than me!', 0
        same db 'Oh, we are the same age!', 0


        NULL = 0

section '.code' code readable executable

        start:
                push wn
                call [printf]

                push name
                push formatStr
                call [scanf]

                push name
                push ho
                call [printf]

                push age
                push formatNum
                call [scanf]

                cmp [age], 19
                jle vers1
                   mov ecx, [age]
                   sub ecx, 19

                   push ecx
                   push older
                   call [printf]

                   jmp finish
                vers1:

                cmp [age], 19
                jge vers2
                   mov ecx, 19
                   sub ecx, [age]

                   push ecx
                   push younger
                   call [printf]

                   jmp finish
                vers2:

                cmp [age], 19
                jne vers3

                   push same
                   call [printf]

                   jmp finish
                vers3:


                finish:

                call [getch]

                push NULL
                call [ExitProcess]


section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'