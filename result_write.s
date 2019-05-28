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

    BUFLEN = 10024

    result: .ascii "result\0"
	eol: .ascii "\n"
.bss
    .comm sum_buf, 10024
    .comm sum_out, 10024

.text
    .globl _start
    _start:

    result_file:              # %r15 - number of num1 bytes
        movq $SYSOPEN, %rax
        movq $result, %rdi
        movq $O_RDONLY, %rsi
        movq $0666, %rdx
        syscall

        movq %rax, %rdi
        movq $SYSREAD, %rax
        movq $sum_buf, %rsi
        movq $BUFLEN, %rdx
        syscall

        movq %rax, %r15  

        movq $SYSCLOSE, %rax
		syscall


wypisywanie:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $sum_buf, %rsi
mov $BUFLEN, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
