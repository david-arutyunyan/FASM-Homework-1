;Var 2. Array B of elements A whose value does not match the first and last elements of A.

format PE console

entry start

include 'win32a.inc'

section '.data' data readable writeable

        strVecSize db 'Size of vector A: ', 0
        strIncorSize db 'Incorrect size of the vector = %d', 10, 0

        strElemA db 'A[%d]: ', 0
        strScanInt db '%d', 0
        strVecElemAOut db 'A[%d] = %d  ', 0
        strVecElemBOut db 'B[%d] = %d  ', 0
        strResultA db 'Array A: ', 0
        strResultB db 'Array B: ', 0
        strResultBEnd db ')', 10, 0
        endl db '', 10, 0

        vec_sizeA dd 0
        vec_sizeB dd 0
        vecA rd 100
        vecB rd 100
        tmpA dd ?
        tmpB dd ?
        first_element dd 0
        second_element dd 0
        k dd ?
        i dd ?

        null dd 0

section '.code' code readable executable

        initArrayA:
                mov eax, [vec_sizeA]

                cmp eax, 0
                jg getVector

                push [vec_sizeA]
                push strIncorSize
                call [printf]
                jmp finish ; end

                getVector: ; Init array
                        xor ecx, ecx    ; ecx = 0
                        mov ebx, vecA    ; ebx = &vec
        ret

        initArrayB:
                mov eax, [vec_sizeB]
                xor ecx, ecx    ; ecx = 0
                mov edx, vecB    ; ebx = &vec
                mov ebx, vecA
        ret

        loop1:
                xor ecx, ecx
                mov edx, vecB
                mov ebx, vecA

                mov eax, [vec_sizeA]
                mov [vec_sizeB], eax

                getVecLoop2:

                        mov [tmpA], ebx
                        cmp ecx, [vec_sizeA]
                        jge endInputVector2      ; to end of loop
                        mov [i], ecx

                        mov eax, [ebx]
                        cmp eax, [first_element]
                        je shlyapa1
                        jmp shlyapa2
                        shlyapa1:
                                dec [vec_sizeB]
                                jmp shlyapa_exit
                        shlyapa2:
                                cmp eax, [second_element]
                                je shlyapa3
                                jmp shlyapa_exit
                                shlyapa3:
                                    dec [vec_sizeB]
                                    jmp shlyapa_exit
                        shlyapa_exit:

                        mov ecx, [i]
                        inc ecx
                        mov ebx, [tmpA]
                        add ebx, 4
                        jmp getVecLoop2 ; end

                endInputVector2:

        ret

        enteringElementsA:
                mov eax, [vec_sizeA]
                mov [k], eax
                dec [k]

                getVecLoop:

                        mov [tmpA], ebx
                        cmp ecx, [vec_sizeA]
                        jge endInputVector      ; to end of loop

                        ; input element
                        mov [i], ecx
                        push ecx
                        push strElemA
                        call [printf]
                        add esp, 8

                        ; push ebx
                        push [tmpA]
                        push strScanInt
                        call [scanf]
                        add esp, 8

                        cmp [i], 0
                        je firstElement
                        jmp endFirstElement
                        firstElement:
                                mov eax, [ebx]
                                mov [first_element], eax
                        endFirstElement:

                        mov eax, [k]
                        cmp [i], eax
                        je secondElement
                        jmp endSecondElement
                        secondElement:
                                mov eax, [ebx]
                                mov [second_element], eax
                        endSecondElement:

                        mov ecx, [i]
                        inc ecx
                        mov ebx, [tmpA]
                        add ebx, 4
                        jmp getVecLoop ; end

                endInputVector:
        ret

        enteringElementsB:
                xor ecx, ecx
                mov edx, vecB
                mov ebx, vecA

                getVecLoop3:
                        mov [tmpB], edx
                        mov [tmpA], ebx
                        cmp ecx, [vec_sizeA]
                        jge endInputVector3      ; to end of loop

                        ; input element
                        mov [i], ecx

                        mov eax, [ebx]

                        cmp eax, [first_element]
                        jne shlyapa11
                        jmp shlyapa_exitt
                        shlyapa11:
                                cmp eax, [second_element]
                                jne shlyapa33
                                jmp shlyapa_exitt
                                shlyapa33:
                                        mov dword [edx], eax
                                        mov edx, [tmpB]
                                        add edx, 4
                                        jmp shlyapa_exitt
                        shlyapa_exitt:


                        mov ecx, [i]
                        inc ecx
                        mov ebx, [tmpA]
                        add ebx, 4
                        jmp getVecLoop3 ; end
                endInputVector3:
        ret

        outputingElementsA:
                cinvoke printf, strResultA
                ;push strResultA
                ;call [printf]

                xor ecx, ecx
                mov ebx, vecA

                putVecLoop4:

                        mov [tmpA], ebx
                        cmp ecx, [vec_sizeA]
                        je endOutputVector4
                        mov [i], ecx

                        ; output element
                        cinvoke printf, strVecElemAOut, ecx, dword [ebx]
                        ;push dword [ebx]
                        ;push ecx
                        ;push strVecElemAOut
                        ;call [printf]

                        mov ecx, [i]
                        inc ecx
                        mov ebx, [tmpA]
                        add ebx, 4
                        jmp putVecLoop4

                endOutputVector4:
        ret

        outputingElementsB:
                cinvoke printf, strResultB
                ;push strResultB
                ;call [printf]

                xor ecx, ecx
                mov edx, vecB

                putVecLoop5:

                        mov [tmpB], edx
                        cmp ecx, [vec_sizeB]
                        je endOutputVector5
                        mov [i], ecx

                        ; output element
                        cinvoke printf, strVecElemBOut, ecx, dword [edx]
                        ;push dword [edx]
                        ;push ecx
                        ;push strVecElemBOut
                        ;call [printf]

                        mov ecx, [i]
                        inc ecx
                        mov edx, [tmpB]
                        add edx, 4
                        jmp putVecLoop5

                endOutputVector5:

        ret

        start:
                push strVecSize
                call [printf]
                add esp, 4

                push vec_sizeA
                push strScanInt
                call [scanf]
                add esp, 8

                call initArrayA

                call enteringElementsA

                call loop1

                call initArrayB

                call enteringElementsB

                call outputingElementsA

                cinvoke printf, endl

                call outputingElementsB
        finish:

                call [getch]

                push [null]
                call [ExitProcess]

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