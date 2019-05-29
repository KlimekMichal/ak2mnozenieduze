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

    f_in1: .ascii "in1_binary\0"
    f_in2: .ascii "in2_binary\0"
    f_out: .ascii "out\0"
	eol: .ascii "\n"
.bss
    .comm num1_buf, 1024
    .comm num2_buf, 1024
    .comm sum_buf1, 1024
    .comm sum_out1, 1024
    .comm sum_buf2, 1024
    .comm sum_out2, 1024

.text

.global multiplication
.type multiplication, @function

multiplication:

mov $0, %r12

num1_file:
	movq $SYSOPEN, %rax
    movq $O_RDONLY, %rsi
    movq $0666, %rdx
    movq $f_in1, %rdi
	cmp $0,  %r12
	je open_file_1

	open_file_2:
	mov $f_in2, %rdi

	open_file_1:
    syscall

    movq %rax, %rdi
    movq $SYSREAD, %rax
    movq $BUFLEN, %rdx
    movq $num1_buf, %rsi
	cmp $0, %r12
	je read_file_1

	read_file_2:
	mov $num2_buf, %rsi

	read_file_1:
    syscall
    movq $SYSCLOSE, %rax
	syscall


wypisywanie:
	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	mov $BUFLEN, %rdx
	movq $num1_buf, %rsi
	cmp $0, %r12
	je print_file_1

	print_file_2:
	mov $num2_buf, %rsi

	print_file_1:
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $eol, %rsi
	mov $2, %rdx
	syscall

cmp $1, %r12
je koniec
mov $1, %r12
jmp num1_file

koniec:
ret
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

