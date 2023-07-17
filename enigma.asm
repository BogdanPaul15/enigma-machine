%include "../include/io.mac"
LETTERS_COUNT EQU 26

section .data
    extern len_plain
    ; Create a copy of the entire configuration
    copy_config: db "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", 0
    global char
    char db 0
    global enc
    enc db 0
section .text
    global rotate_x_positions
    global enigma
    extern printf

; void rotate_x_positions(int x, int rotor, char config[10][26], int forward);
rotate_x_positions:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; x
    mov ebx, [ebp + 12] ; rotor
    mov ecx, [ebp + 16] ; config (address of first element in matrix)
    mov edx, [ebp + 20] ; forward
    ;; DO NOT MODIFY

    ; First, I will copy the entire configuration into copy_config, in order to make swapping rotors much easier

    ; A simple loop that copies character by character from the current config into copy_config
    push ebx
    mov esi, 0
    copy:
        lea edi, [ecx + 1 * esi]
        mov bl, [edi]
        lea edi, [copy_config + 1 * esi]
        mov [edi], bl
    inc esi
    cmp esi, 155
    jle copy
    pop ebx

    ; Verify if we need left or right shifting
    cmp edx, 0
    je left

    cmp edx, 1
    je right
left:
    ; For left shifting, I check which rotor it is

    ; Rotor 1
    cmp ebx, 0
    je rot_0l

    ; Rotor 2
    cmp ebx, 1
    je rot_1l

    ; Rotor 3
    cmp ebx, 2
    je rot_2l
right:
    ; For right shifting, I check which rotor it is

    ; Rotor 1
    cmp ebx, 0
    je rot_0r

    ; Rotor 2
    cmp ebx, 1
    je rot_1r

    ; Rotor 3
    cmp ebx, 2
    je rot_2r
rot_0l:
    ; Rotation of the first rotor to the left

    ; To rotate a rotor, I've used two loops
    ; Since I already know what the dimensions of the configuration (10 x 26), I decided to
    ; rotate for each individual rotor, in turn, the first line of the rotor and
    ; after that the second

    ; Rotation of the first line from the first rotor to the left (0 - 25)
    mov esi, 0
    loop_rot0l_1:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the first line
        add edi, eax
        lea edx, [copy_config + 25] ; load in edx the effective address of the last character from the first line

        ; Because its about a circular rotation to the left, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be subtracted (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jle modify_rot0l_1
        sub edi, 26
    modify_rot0l_1:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 25
    jle loop_rot0l_1

    ; Rotation of the second line from the first rotor to the left (26 - 51)
    mov esi, 26
    loop_rot0l_2:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the second line
        add edi, eax
        lea edx, [copy_config + 51] ; load in edx the effective address of the last character from the second line

        ; Because its about a circular rotation to the left, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be subtracted (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jle modify_rot0l_2
        sub edi, 26
    modify_rot0l_2:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 51
    jle loop_rot0l_2
    jmp end_rotation
rot_1l:
    ; Rotation of the second rotor to the left

    ; Rotation of the first line from the second rotor to the left (52 - 77)
    mov esi, 52 
    loop_rot1l_1:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the first line
        add edi, eax
        lea edx, [copy_config + 77] ; load in edx the effective address of the last character from the first line

        ; Because its about a circular rotation to the left, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be subtracted (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jle modify_rot1l_1
        sub edi, 26
    modify_rot1l_1:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 77
    jle loop_rot1l_1

    ; Rotation of the second line from the second rotor to the left (78 - 103)
    mov esi, 78
    loop_rot1l_2:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the second line
        add edi, eax
        lea edx, [copy_config + 103] ; load in edx the effective address of the last character from the second line

        ; Because its about a circular rotation to the left, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be subtracted (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jle modify_rot1l_2
        sub edi, 26
    modify_rot1l_2:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 103
    jle loop_rot1l_2
    jmp end_rotation
rot_2l:
    ; Rotation of the third rotor to the left

    ; Rotation of the first line from the third rotor to the left (104 - 129)
    mov esi, 104
    loop_rot2l_1:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the first line
        add edi, eax
        lea edx, [copy_config + 129] ; load in edx the effective address of the last character from the first line

        ; Because its about a circular rotation to the left, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be subtracted (the value of one line) from the
        ; character address and that will be the new character
        
        cmp edi, edx
        jle modify_rot2l_1
        sub edi, 26
    modify_rot2l_1:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 129
    jle loop_rot2l_1

    ; Rotation of the second line from the third rotor to the left (130 - 155)
    mov esi, 130
    loop_rot2l_2:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the second line
        add edi, eax
        lea edx, [copy_config + 155] ; load in edx the effective address of the last character from the second line

        ; Because its about a circular rotation to the left, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be subtracted (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jle modify_rot2l_2
        sub edi, 26
    modify_rot2l_2:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 155
    jle loop_rot2l_2
    jmp end_rotation
rot_0r:
    ; Rotation of the first rotor to the right

    ; To rotate a rotor, I've used two loops
    ; Since I already know what the dimensions of the configuration (10 x 26), I decided to
    ; rotate for each individual rotor, in turn, the first line of the rotor and
    ; after that the second

    ; Rotation of the first line from the first rotor to the right (0 - 25)
    mov esi, 0
    loop_rot0r_1:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the first line
        sub edi, eax
        lea edx, [copy_config] ; load in edx the effective address of the last character from the first line

        ; Because its about a circular rotation to the right, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be added (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jge modify_rot0r_1
        add edi, 26
    modify_rot0r_1:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 25
    jle loop_rot0r_1

    ; Rotation of the second line from the first rotor to the right (26 - 51)
    mov esi, 26
    loop_rot0r_2:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the second line
        sub edi, eax
        lea edx, [copy_config + 26] ; load in edx the effective address of the last character from the second line

        ; Because its about a circular rotation to the right, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be added (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jge modify_rot0r_2
        add edi, 26
    modify_rot0r_2:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 51
    jle loop_rot0r_2
    jmp end_rotation
rot_1r:
    ; Rotation of the second rotor to the right

    ; Rotation of the first line from the second rotor to the right (52 - 77)
    mov esi, 52
    loop_rot1r_1:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the first line
        sub edi, eax
        lea edx, [copy_config + 52] ; load in edx the effective address of the last character from the first line

        ; Because its about a circular rotation to the right, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be added (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jge modify_rot1r_1
        add edi, 26
    modify_rot1r_1:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 77
    jle loop_rot1r_1

    ; Rotation of the second line from the second rotor to the right (78 - 103)
    mov esi, 78
    loop_rot1r_2:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the second line
        sub edi, eax
        lea edx, [copy_config + 78] ; load in edx the effective address of the last character from the second line

        ; Because its about a circular rotation to the right, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be added (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jge modify_rot1r_2
        add edi, 26
    modify_rot1r_2:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 103
    jle loop_rot1r_2
    jmp end_rotation
rot_2r:
    ; Rotation of the third rotor to the right

    ; Rotation of the first line from the third rotor to the right (104 - 129)
    mov esi, 104
    loop_rot2r_1:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the first line
        sub edi, eax
        lea edx, [copy_config + 104] ; load in edx the effective address of the last character from the first line

        ; Because its about a circular rotation to the right, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be added (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jge modify_rot2r_1
        add edi, 26
    modify_rot2r_1:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 129
    jle loop_rot2r_1

    ; Rotation of the second line from the third rotor to the right (130 - 155)
    mov esi, 130
    loop_rot2r_2:
        xor ebx, ebx
        xor edx, edx
        xor edi, edi
        lea edi, [copy_config + 1 * esi] ; load in edi the effective address of the first character from the first line
        sub edi, eax
        lea edx, [copy_config + 130] ; load in edx the effective address of the last character from the first line

        ; Because its about a circular rotation to the right, I verify if the
        ; effective address of the current character + offset would overflow the line.
        ; If this happens, then 26 must be added (the value of one line) from the
        ; character address and that will be the new character

        cmp edi, edx
        jge modify_rot2r_2
        add edi, 26
    modify_rot2r_2:
        mov bl, [edi]
        mov [ecx + 1 * esi], bl
    inc esi
    cmp esi, 155
    jle loop_rot2r_2
    jmp end_rotation
end_rotation:
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

; void enigma(char *plain, char key[3], char notches[3], char config[10][26], char *enc)
enigma:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; plain (address of first element in string)
    mov ebx, [ebp + 12] ; key
    mov ecx, [ebp + 16] ; notches
    mov edx, [ebp + 20] ; config (address of first element in matrix)
    mov edi, [ebp + 24] ; enc
    ;; DO NOT MODIFY

    ; First I start by going through all the characters from plain with a simple loop

    mov esi, 0
    loop:

        push esi ; I save the current index on stack because I will use esi and I don't want to modify it
        
        ; Translate the current character into global variable 'char'
        push ebx
        xor ebx, ebx
        mov bl, [eax + 1 * esi]
        mov [char], bl
        pop ebx


        ; Comparisons to set initial rotor positions begin
        ; As a side note, I want to mention that if key[2] == notch[2], then
        ; rotate all rotors to the left and increment all keys
        ; if key[3] == notch[3], then only key[2], key[3] are incremented
        ; and rotors 2 and 3 rotate to the left, or if none of the
        ; above is not true, then only key[3] is incremented and
        ; rotor 3 rotates


        push eax
        push edi
        xor eax, eax
        mov al, [ebx + 1] 
        cmp al, [ecx + 1] ; Comparing key[2] == notch[2]
        je rotate_all

        ; Otherwise, jump to check key[3] == notch[3]
        jmp comp_2_3
        rotate_all:

            ; If key[2] == notch[2], then all rotors rotate to the left and increment all keys

            ; Rotation of the first rotor to the left (offset = 1) is done by calling the function rotate_x_positions
            push ecx
            push ebx

            mov ebx, 0 ; forward
            mov ecx, 1 ; offset
            mov eax, 0 ; rotor

            ; Push the function parameters in reverse order on the stack
            push ebx
            push edx
            push eax
            push ecx
            call rotate_x_positions
            add esp, 16


            ; Rotation of the second rotor to the left (offset = 1) is done by calling the function rotate_x_positions
            mov ebx, 0 ; forward
            mov ecx, 1 ; offset
            mov eax, 1 ; rotor

            ; Push the function parameters in reverse order on the stack
            push ebx
            push edx
            push eax
            push ecx
            call rotate_x_positions
            add esp, 16


            ; Rotation of the third rotor to the left (offset = 1) is done by calling the function rotate_x_positions
            mov ebx, 0 ; forward
            mov ecx, 1 ; offset
            mov eax, 2 ; rotor

            ; Push the function parameters in reverse order on the stack
            push ebx
            push edx
            push eax
            push ecx
            call rotate_x_positions
            add esp, 16

            pop ebx
            xor ecx, ecx

            ; Increment all keys

            ; Increment key[1] same as before, in alphabetical order
            xor ecx, ecx
            mov cl, [ebx]
            inc ecx
            cmp cl, 'Z'
            jle increment_key_1_1
            sub cl, 26
            increment_key_1_1:
                mov [ebx], cl
            
            ; Increment key[2] same as before, in alphabetical order
            xor ecx, ecx
            mov cl, [ebx + 1]
            inc ecx
            cmp cl, 'Z'
            jle increment_key_2_1
            sub cl, 26
            increment_key_2_1:
                mov [ebx + 1], cl

            ; Increment key[3] same as before, in alphabetical order
            xor ecx, ecx
            mov cl, [ebx + 2]
            inc ecx
            cmp cl, 'Z'
            jle increment_key_3_1
            sub cl, 26
            increment_key_3_1:
                mov [ebx + 2], cl
                
            pop ecx
            jmp end
        comp_2_3:

            xor eax, eax
            mov al, [ebx + 2]
            cmp al, [ecx + 2] ; Compare key[3] == notch[3]
            je rotate_2_3

            ; Otherwise, only increment key[3] and rotate third rotor
            jmp rotate_3
            rotate_2_3:

                ; If key[3] == notch[3], then rotor 2 and 3 are rotating to the left and increment key[2] and key[3]

                push ecx
                push ebx

                ; Rotation of the second rotor to the left (offset = 1) is done by calling the function rotate_x_positions
                mov ebx, 0 ; forward
                mov ecx, 1 ; offset
                mov eax, 1 ; rotor

                ; Push the function parameters in reverse order on the stack
                push ebx
                push edx
                push eax
                push ecx
                call rotate_x_positions
                add esp, 16


                ; Rotation of the third rotor to the left (offset = 1) is done by calling the function rotate_x_positions
                mov ebx, 0 ; forward
                mov ecx, 1 ; offset
                mov eax, 2 ; rotor

                ; Push the function parameters in reverse order on the stack
                push ebx
                push edx
                push eax
                push ecx
                call rotate_x_positions
                add esp, 16

                pop ebx
                xor ecx, ecx


                ; Increment key[2] și key[3]
                
                ; Increment key[2] same as before, in alphabetical order
                mov cl, [ebx + 1]
                inc ecx
                cmp cl, 'Z'
                jle increment_key_2_2
                sub cl, 26
                increment_key_2_2:
                    mov [ebx + 1], cl

                ; Increment key[3] same as before, in alphabetical order
                xor ecx, ecx
                mov cl, [ebx + 2]
                inc ecx
                cmp cl, 'Z'
                jle increment_key_3_2
                sub cl, 26
                increment_key_3_2:
                    mov [ebx + 2], cl

                pop ecx
                jmp end
            rotate_3:

                ; Increment key[3] and rotate rotor 3

                push ecx
                push ebx
                
                ; Rotation of the third rotor to the left (offset = 1) is done by calling the function rotate_x_positions
                mov ebx, 0 ; forward
                mov ecx, 1 ; offset
                mov eax, 2 ; rotor

                ; Push the function parameters in reverse order on the stack
                push ebx
                push edx
                push eax
                push ecx
                call rotate_x_positions
                add esp, 16

                pop ebx

                ; Increment key[3] same as before, in alphabetical order
                xor ecx, ecx
                mov cl, [ebx + 2]
                inc ecx
                cmp cl, 'Z'
                jle increment_key_3_3
                sub cl, 26
                increment_key_3_3:
                    mov [ebx + 2], cl
                pop ecx
        end:
            pop edi
            pop eax

        ; Having set the initial positions of the rotors, what remains to be done
        ; done is the traversal of the character in the plain of the config
        ; (Plugboard, Rotors, Reflector, Rotors, Plugboard)

        push ecx
        push ebx
        push eax
        xor eax, eax
        mov al, [char] ; Assign al to the current character, put at the beginning in global variable 'char'
        xor ecx, ecx

        ; Because it is enough to go through just a few lines in the config
        ; so that I can figure out which character will be output,
        ; I decided to go through config like this:

        ; I look for the input character on the first line of the Plugboard, I find it,
        ; and then because immediately after the Plugboard is the Reflector,
        ; I subtract 4 lines (4 x 26 = 104) from the address where I find the character
        ; to keep the new character on the second line in rotor 3
        mov esi, 234
        loop1:
            mov cl, [edx + 1 * esi]
            lea ebx, [edx + 1 * esi]
        inc esi
        cmp cl, al
        jne loop1

        mov cl, [ebx - 104]

        ; Now that I have the character on rotor 3, I look for it on the first line of the
        ; rotor 3, I find it and save the address. Thus, the new character on
        ; the second line in rotor 2 will be at the
        ; address found earlier - 1 line (1 x 26 = 26)
        mov esi, 104
        loop2:
            mov al, [edx + 1 * esi]
            lea ebx, [edx + 1 * esi]
        inc esi
        cmp al, cl
        jne loop2

        mov al, [ebx - 26]

        ; Now that I have the character on rotor 2, I look for it on the first line of the
        ; rotor 2, I find it and save the address. Thus, the new character on
        ; the second line in rotor 1 will be at the
        ; address found earlier - 1 line (1 x 26 = 26)
        mov esi, 52
        loop3:
            mov cl, [edx + 1 * esi]
            lea ebx, [edx + 1 * esi]
        inc esi
        cmp cl, al
        jne loop3

        mov cl, [ebx - 26]

        ; Now that I have the character on rotor 1, I look for it on the first line of the
        ; rotor 1, I find it and save the address. Thus, the character that will
        ; enter the reflector is at the address found on the first line in the rotor
        ; 1 + 7 lines (7 x 26 = 182)
        mov esi, 0
        loop4:
            mov al, [edx + 1 * esi]
            lea ebx, [edx + 1 * esi]
        inc esi
        cmp al, cl
        jne loop4

        mov al, [ebx + 182]

        ; Acum că am caracterul de pe reflector a doua linie, îl caut pe prima
        ; linie din reflector, îl găsesc și salvez adresa. Astfel, caracterul
        ; se va propaga pe prima linie din rotorul 1 se află la adresa găsită
        ; pe prima linie a reflectorului - 6 linii (6 x 26 = 156)

        ; Now that I have the character on the second line of the reflector, I'm looking for it on the first
        ; line from the reflector, I find it and save the address. Thus, the character
        ; will propagate to the first line in rotor 1 is at the address found
        ; on the first line of the reflector - 6 lines (6 x 26 = 156)
        mov esi, 156
        loop5:
            mov cl, [edx + 1 * esi]
            lea ebx, [edx + 1 * esi]
        inc esi
        cmp cl, al
        jne loop5

        mov cl, [ebx - 156]

        ; Now that I have the character on the first line in rotor 1, I'm looking for it on the second
        ; line from rotor 1, I find it and save the address. Thus, the new character
        ; from the first line in rotor 2 will be at the
        ; address found earlier + 1 line (1 x 26 = 26)
        mov esi, 26
        loop6:
            mov al, [edx + 1 * esi]
            lea ebx, [edx + 1 * esi]
        inc esi
        cmp al, cl
        jne loop6

        mov al, [ebx + 26]

        ; Now that I have the character on the first line in rotor 2, I'm looking for it on the second 
        ; line from rotor 2, I find it and save the address. Thus, the new character
        ; from the first line in rotor 3 will be at the
        ; address found earlier + 1 line (1 x 26 = 26)
        mov esi, 78
        loop7:
            mov cl, [edx + 1 * esi]
            lea ebx, [edx + 1 * esi]
        inc esi
        cmp cl, al
        jne loop7

        mov cl, [ebx + 26] 

        ; Now that I have the character on the first line in rotor 3, I'm looking for it on the second 
        ; line from rotor 3, I find it and save the address. Thus, the new character
        ; from the reflector will be at the
        ; address found earlier + 4 lines (4 x 26 = 104)
        mov esi, 130
        loop8:
            mov al, [edx + 1 * esi]
            lea ebx, [edx + 1 * esi]
        inc esi
        cmp al, cl
        jne loop8

        mov al, [ebx + 104]
        mov [enc], al

        ; The encrypted character will be in al, which is moved to
        ; global variable 'enc' so that it can be added to the encrypted string

        pop eax
        pop ebx
        pop ecx
        pop esi
        push ecx
        xor ecx, ecx
        mov cl, [enc]
        mov [edi + 1 * esi], cl
        pop ecx

    inc esi ; Increment the index
    push edi
    mov edi, [len_plain]
    ; I check if I have reached the end of the string, if not, I repeat same process for the next character
    cmp esi, edi
    pop edi
    jl loop

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY