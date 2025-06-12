    .data

result_buff:     .byte  0x00, '_______________________________'
buffer:          .byte  0x00, '_______________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
error_msg:       .word  0xCCCC_CCCC
stack_top:       .word  0x300

    .text
    .org     0x90

_start:
    movea.l  stack_top, A7
    movea.l  (A7), A7
    movea.l  input_addr, A5
    movea.l  (A5), A5
    movea.l  output_addr, A6
    movea.l  (A6), A6

    move.l   0, D0                           ; D0 <- str length
    move.b   0, D1                           ; D1 <- current letter
    movea.l  buffer, A1                      ; A1 <- buffer pointer

    jsr      read_loop

    halt

read_loop:
    cmp.b    0x20, D0                        ; check if overflow
    beq      overflow

    move.b   (A5), D1                        ; read 1 letter

    cmp.b    0x0a, D1
    beq      end_read

    move.b   D1, 1(A1, D0)                   ; write letter to buffer
    add.b    1, D0
    move.b   D0, (A1)

    jsr      read_loop

    rts

end_read:
    link     A4, -4

    movea.l  result_buff, A2                 ; A2 <- result buffer pointer
    move.b   D0, (A2)+

    move.l   D0, -4(A4)                      ; save D0 as local variable

    add.l    buffer, D0
    add.l    1, D0
    movea.l  D0, A1

    move.l   -4(A4), D0                      ; restore D0 value from stack

    jsr reverse_loop

    rts

reverse_loop:
    beq      end_reverse

    move.b   -(A1), (A6)                     ; write to output address
    move.b   (A1), (A2)+                     ; write to result buffer
    sub.l    1, D0

    jsr      reverse_loop

    rts

end_reverse:
    rts

overflow:
    movea.l  error_msg, A5
    move.l   (A5), (A6)
    
    rts
