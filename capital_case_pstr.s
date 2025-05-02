    .data

result_buff:     .byte  '________________________________'
buff:            .byte  '________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
temp:            .word  0x40
i:               .word  0
j:               .word  0
is_first:        .word  1
length:          .word  0

buffer_size:     .word  0x20
const_1:         .word  1
const_FF:        .word  0xFF
const_0:         .word  0
newline:         .word  0x0A
space:           .word  0x20
a_ascii:         .word  0x61
z_ascii:         .word  0x7A
upper_delta:     .word  0x20
error_msg:       .word  0xCCCC_CCCC

    .text
    .org         0x85

_start:

    load_imm     buff
    store        i

read_loop:

    load_ind     input_addr
    and          const_FF
    store        temp

    sub          newline
    beqz         end_read

    load_addr    length
    add          const_1
    store_addr   length
    sub          buffer_size
    beqz         overflow

    load         temp
    sub          space
    beqz         is_space
    bnez         is_not_space

is_not_space:

    load_addr    is_first
    sub          const_1
    beqz         capitalize
    bnez         set_is_first_0

capitalize:

    load         temp
    sub          a_ascii
    ble          set_is_first_0

    load         temp
    sub          z_ascii
    bgt          set_is_first_0

    load         temp
    sub          upper_delta
    store        temp

    jmp          set_is_first_0

store_char:

    load         temp
    store_ind    i

    load         i
    add          const_1
    store        i

    jmp          read_loop

is_space:

    load_addr    const_1
    store_addr   is_first

    jmp          store_char

set_is_first_0:

    load_addr    const_0
    store_addr   is_first

    jmp          store_char

end_read:

    load_imm     buff
    store        i

    load_imm     result_buff
    store        j

    load_addr    length
    store_ind    j

    load         j
    add          const_1
    store        j

print_loop:

    load         j
    sub          length
    sub          const_1
    beqz         end

    load_ind     i
    and          const_FF
    store_ind    output_addr
    store_ind    j

    load         i
    add          const_1
    store        i                           ; i++

    load         j
    add          const_1
    store        j                           ; j++

    jmp          print_loop

end:
    load_imm     0x5f5f5f5f
    store_ind    j

    halt

overflow:

    load         error_msg
    store_ind    output_addr

    halt