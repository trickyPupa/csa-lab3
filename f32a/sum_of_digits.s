    .data

input_addr:      .word  0x80
output_addr:     .word  0x84
divider:         .word  10
is_positive:     .word  0   \ is_positive=false

    .text

_start:
    @p input_addr a! @ dup a!   \ num -> A
    lit divider b!          \ divider -> [B]

    -if sum_of_digits

    @p is_positive
    if negative

    \@p output_addr a! !

    \halt

negative:
    a inv lit 1 + a! \ -A -> A

    sum_of_digits

divide:
    lit 0 lit 0         \ 0 -> remainder; 0 -> quotient
    lit 31 >r
divide_do:
    +/
    next divide_do
    ;

sum_of_digits:
    lit 1 !p is_positive  \ is_positive=true
    lit 0                 \ result -> stack[0]

    while

    @p output_addr a! !

    halt
while:
    a 
    if finish

    divide

    a!                  \ dividend = num\\10; num\\10 -> A
    +                   \ remainder = num%10; num%10 -> stack[0]; stack[0] = result

    while
    ;

finish:
    ;