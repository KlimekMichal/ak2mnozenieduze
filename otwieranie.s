.data
    SYSEXIT = 60
    EXIT_SUCCESS = 0
    SYSREAD = 0
    SYSWRITE = 1
    STDOUT = 1
    SYSOPEN = 2
    SYSCLOSE = 3
    O_RDONLY = 00
    O_WRONLY = 01
    O_WR_CRT_TRNC = 01101

    BUFLEN = 1024

    f_in1: .ascii "in1\0"
    f_in2: .ascii "in2\0"
    f_out: .ascii "out\0"

.bss
    .comm num1_buf, 1024
    .comm num1, 1024
    .comm num2_buf, 1024
    .comm num2, 1024
    .comm sum_buf1, 1024
    .comm sum_out1, 1024
    .comm sum_buf2, 1024
    .comm sum_out2, 1024

.text
    .globl _start
    _start:

    num1_file:              # %r14 - number of num1 bytes
        movq $SYSOPEN, %rax
        movq $f_in1, %rdi
        movq $O_RDONLY, %rsi
        movq $0666, %rdx
        syscall

        movq %rax, %rdi  # file handle
        movq $SYSREAD, %rax
        movq $num1_buf, %rsi
        movq $BUFLEN, %rdx
        syscall

        movq %rax, %r14  
        sub $3, %r14       # taking 2 bytes at a time

        movq $SYSCLOSE, %rax    # file handle still in %rdi
        syscall
    num2_file:              # %r15 - number of num1 bytes
        movq $SYSOPEN, %rax
        movq $f_in2, %rdi
        movq $O_RDONLY, %rsi
        movq $0666, %rdx
        syscall

        movq %rax, %rdi
        movq $SYSREAD, %rax
        movq $num2_buf, %rsi
        movq $BUFLEN, %rdx
        syscall

        movq %rax, %r15  
        sub $3, %r15

        movq $SYSCLOSE, %rax
		syscall
mov $0, %rax
mov $0, %r10
mov $0, %r11
mov $0, %rdx
mov $0, %rcx
mov $0, %rsi
mov $sum_out2, %rdi
mov $num2_buf, %rsi
mov $2, %bl
jedna_seria_dzielenia:
mov $0, %rdx
dzielenie_jednej_liczby_przez_2:
mov $0, %ax
mov (%rsi, %rdx,1), %al # wez cyfrę
cmp $46, %al
je koniec_lini
sub $48, %al
cmp $1, %bh #sprawdz przeniesienie z poprzedniej
jne brak_reszty
add $10, %al	#jezeli jest to dodaj 10^(ile cyfer bierzesz+1)
brak_reszty:
div %bl #podziel przez 2
mov $0, %bh
mov %ah, %bh
add $48, %al
mov %al, (%rsi, %rdx,1) #twój wynik zapisz do nastepnej petli
inc %rdx
jmp dzielenie_jednej_liczby_przez_2
koniec_lini:
add $48, %bh
mov %bh, (%rdi,%rcx,1)
inc %rcx
inc %rdx
mov $46, %al
mov %al, (%rsi, %rdx,1)
dec %rdx
mov (%rsi, %rcx,1), %al
cmp $48, %al
je wypisywanie
jmp jedna_seria_dzielenia



wypisywanie:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $sum_out2, %rsi
mov %rcx, %rdx
syscall

movq $SYSEXIT, %rax
    movq $EXIT_SUCCESS, %rdi
syscall

movq $SYSOPEN, %rax
    movq $f_out, %rdi
    movq $O_WR_CRT_TRNC, %rsi
    movq $0666, %rdx
    syscall

    movq %rax, %rdi  # file handle
    movq $SYSWRITE, %rax
    movq $sum_out2, %rsi
    movq $4, %rdx
syscall






