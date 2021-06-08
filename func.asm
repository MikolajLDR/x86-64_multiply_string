; r8        length of first number
; r9        length of second number
; r10       first number pointer
; r11       second number pointer
; r12       result pointer

; rdi       address of result string
; rsi       address of first number string
; rdx       address of second number string

section .text
    global  smul

smul:
    push    r12
    mov     ch, 10              ; divider

    ; Change first number to int
    xor     r8d, r8d
first_to_int:
    mov     al, [rsi+r8]
    sub     al, '0'
    xchg    al, [rsi+r8]
    inc     r8d
    test    al, al
    jnz     first_to_int
    dec     r8d

    ; Change second number to int
    xor     r9d, r9d
second_to_int:
    mov     al, [rdx + r9]
    sub     al, '0'
    xchg    al, [rdx + r9]
    inc     r9d
    test    al, al
    jnz     second_to_int
    dec     r9d

    ; Muliply numbers
    mov     r10d, r8d           ; r10d = length of first number
    mov     r12, rdi            ; r12 = address of result string
    add     r12, r10            ; r12 += length of first number
    inc     r12
outer_loop:
    dec     r12
    dec     r10d                ; move to next digit in first number
    mov     cl, [rsi + r10]     ; cl = first number current digit

    mov     r11d, r9d           ; r11d = length of second number
    add     r12, r11
inner_loop:
    dec     r11d
    dec     r12
    mov     al, [rdx + r11]     ; al = second number current digit
    mul     cl                  ; ax = al * cl

    add     al, [r12]
    div     ch

    add     byte [r12-1], al
    shr     ax, 8
    mov     [r12], al

    test    r11d, r11d
    jnz     inner_loop

    test    r10d, r10d
    jnz     outer_loop

    ; Remove 0 from result beggining
    mov     al, [rdi]
    test    al, al
    jnz     finish
    inc     rdi
    dec     r9d
    ; If result begins with 00 then result = 0
    mov     al, [rdi]
    test    al, al
    jnz     finish
    dec     rdi
    add     byte [rdi], '0'
    jmp     end

    ; Change result to ascii
finish:
    mov     r12, rdi
    add     r12, r8
    add     r12, r9
change_to_ascii:
    dec     r12
    add     byte [r12], '0'
    cmp     r12, rdi
    jg      change_to_ascii

end:
    mov     rax, rdi
    pop     r12
    ret
