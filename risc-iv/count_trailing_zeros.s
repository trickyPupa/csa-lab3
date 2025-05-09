    .data

input_addr:      .word  0x80
output_addr:     .word  0x84
default_val:     .word  0x20

    .text

_start:

    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)

    lw       t0, 0(t0)

    lw       t1, 0(t0)

    beqz     t1, num_is_null                 ; t1 - number

begin:

    addi     t2, zero, 0                     ; t2 - counter
    addi     t3, zero, 1                     ; t3 = 1

while:

    and      t4, t1, t3                      ; t2 & 1 -> t4
    bnez     t4, finish

    add      t2, t2, t3

    srl      t1, t1, t3

    j        while

finish:

    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)

    lw       t0, 0(t0)

    sw       t2, 0(t0)

    halt

num_is_null:

    lui      t0, %hi(default_val)
    addi     t0, t0, %lo(default_val)

    lw       t2, 0(t0)

    j        finish
