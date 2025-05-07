    .data

result_buff:     .byte  '________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
buff:            .byte  '________________________________'
temp:            .word  0x40
i:               .word  0
j:               .word  0
is_first:        .word  1                  ; флаг для определения начала слова
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

    .text
    .org         0x90

_start:

    load_imm     buff
    store        i

read_loop:
 ; цикл для чтения данных

    load_addr    length
    sub          buffer_size
    beqz         overflow

    load_ind     input_addr
    and          const_FF
    store        temp

    sub          newline
    beqz         end_read

    load_addr    length
    add          const_1
    store_addr   length

    load         temp
    sub          space
    beqz         is_space
    bnez         is_not_space

is_not_space:
 ; если буква не пробем установить флаг is_first=0

    load_addr    is_first
    sub          const_1
    beqz         capitalize
    bnez         decapitalize

capitalize:
 ; если буква первая в слове и строчная - сделать заглавной

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

decapitalize:
 ; если буква не первая в слове и заглавная - сделать строчной

    load         temp
    add          upper_delta
    sub          a_ascii
    ble          set_is_first_0

    load         temp
    add          upper_delta
    sub          z_ascii
    bgt          set_is_first_0

    load         temp
    add          upper_delta
    store        temp

    jmp          set_is_first_0

store_char:
 ; запись данных в буффер

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
 ; конец чтения, запись длины слова в результирующий буффер

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
 ; запись символов в результирующий буффер

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

    load_imm     0xCCCC_CCCC
    store_ind    output_addr

    halt