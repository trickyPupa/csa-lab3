    .data

input_addr:      .word  0x80
output_addr:     .word  0x84

    .text

_start:
    @p input_addr a! @ a!   \ num -> A
    lit 10 
    a

    lit 0
    >r

    loop

    @p output_addr a! !

    halt

loop:
    dup    
    lit 10      
    a!         
    lit 0     
    >r          \ сохраняем remainder в R
    lit 0       \ quotient = 0
    >r          \ сохраняем quotient в R
    lit 10      \ divisor = 10
    >r          \ сохраняем divisor в R
    \ Выполняем 32 шага деления (+/)
    lit 32      \ counter = 32
    >r          \ сохраняем counter в R
div_loop:
    +/          \ шаг деления
    r>          \ достаём counter
    lit 1       \ 1
    -           \ counter -= 1
    dup         \ копируем counter
    >r          \ сохраняем counter обратно
    -if div_loop \ если counter > 0, повторяем
    drop        \ убираем counter
    \ --- После деления:
    \ remainder = последняя цифра (n % 10)
    \ quotient = n / 10
    r>          \ divisor (больше не нужно)
    drop
    r>          \ quotient (n / 10)
    r>          \ remainder (последняя цифра)
    \ --- Добавляем цифру к сумме
    r>          \ достаём sum
    over        \ копируем remainder
    +           \ sum += remainder
    >r          \ сохраняем sum обратно
    \ --- Проверяем, закончили ли (n == 0?)
    dup         \ копируем quotient (n / 10)
    if end      \ если n == 0, завершаем
    \ --- Иначе повторяем
    drop        \ убираем копию
    jump loop   \ повторяем цикл

end:
    drop        \ убираем 0 (остаток от n)
    r>          \ достаём sum
    \ Теперь sum на вершине стека
    halt        \ завершаем программу