    .data

result_buff:     .byte  0x00, '_______________________________'
buffer:          .byte  0x00, '_______________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
error_msg:       .word  0xCCCC_CCCC

    .text
    .org     0x90

_start:
    movea.l  input_addr, A6
    movea.l  (A6), A6
    movea.l  output_addr, A7
    movea.l  (A7), A7

    move.l   0, D0                           ; D0 <- str length
    move.b   0, D1                           ; D1 <- current letter
    movea.l  buffer, A1                      ; A1 <- buffer pointer

read_loop:
    move.b   D0, D7                          ; check if overflow
    sub.b    0x20, D7
    beq      overflow

    move.b   (A6), D1                        ; read 1 letter

    move.b   D1, D7                          ; check if last symbol
    sub.b    0x0a, D7
    beq      end_read

    move.b   D1, 1(A1, D0)                   ; write letter to buffer
    add.b    1, D0
    move.b   D0, (A1)

    jmp      read_loop

end_read:
    movea.l  result_buff, A2                 ; A2 <- result buffer pointer
    move.b   D0, (A2)+

    move.l   buffer, D7
    add.l    D0, D7
    add.l    1, D7
    movea.l  D7, A1

    move.l   D0, D0

reverse_loop:
    beq      finish

    move.b   -(A1), (A7)                     ; write to output address
    move.b   (A1), (A2)+                     ; write to result buffer
    sub.l    1, D0

    jmp      reverse_loop

finish:
    halt

overflow:
    movea.l  error_msg, A5
    move.l   (A5), (A7)
    halt
