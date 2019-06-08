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
	eol: .ascii "\n"
.bss
    .comm product, 2048
    .comm num1_buf, 1024
    .comm num1, 1024
    .comm num2_buf, 1024
    .comm num2, 1024
    .comm sum_buf1, 1024
    .comm sum_out1, 1024
    .comm sum_buf2, 1024
    .comm sum_out2, 1024

.text
.global multiplication
.type multiplication, @function

multiplication:
mov $0, %r12

read_file:
	movq $SYSOPEN, %rax
	movq $O_RDONLY, %rsi
	movq $0666, %rdx
	mov $f_in1, %rdi
	cmp $0, %r12
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

cmp $1, %r12
je to_binary_file2

to_binary_file1:
	mov $sum_out1, %rdi
	mov $num1_buf, %rsi
	jmp to_binary

to_binary_file2:
	mov $sum_out2, %rdi
	mov $num2_buf, %rsi
	jmp to_binary

to_binary:
	mov $0, %rax
	mov $1, %r10
	mov $0, %r11
	mov $0, %rdx
	mov $0, %rcx
	mov $2, %bl

	jedna_seria_dzielenia:
	mov $0, %rdx
	mov $0, %r11

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
	mov %al, (%rsi, %r11,1) #twój wynik zapisz do nastepnej petli
	cmp $0, %rdx
	jne nie_pierwszy #sprawdzamy czy pierwsz cyfra nowej liczby to 0 jezeli tak to zapisujemy na jej miejscu nastepną 
	cmp $48, %al
	je zero_detected

	nie_pierwszy:
	inc %r11

	zero_detected:
	inc %rdx
	jmp dzielenie_jednej_liczby_przez_2

	koniec_lini:
	add $48, %bh
	mov %bh, (%rdi,%rcx,1)
	inc %rcx
	mov $46, %al
	mov %al, (%rsi, %r11,1)
	mov $0, %r8
	mov (%rsi, %r8, 1), %al
	cmp $46, %al
	jne jedna_seria_dzielenia
	mov (%rsi, %r10,1), %al
	cmp $46, %al
	je wypisywanie
	jmp jedna_seria_dzielenia
	
reverse_preparation:
	mov $0, %rdx
	mov $2, %rcx
	mov $BUFLEN, %rax
	div %rcx
	mov %rax, %r8
	mov $0, %rcx
	mov $BUFLEN, %rdx
	dec %rdx

reverse:
	mov (%rdi, %rcx, 1), %al
	mov (%rdi, %rdx, 1), %bl
	mov %bl, (%rdi, %rcx, 1)
	mov %al, (%rdi, %rdx, 1)

	inc %rcx
	dec %rdx
	cmp %r8, %rcx
	jl reverse

	



wypisywanie:
	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	mov $BUFLEN, %rdx
	movq $sum_out1, %rsi
	cmp $0, %r12
	je print_num1

	print_num2:
	mov $sum_out2, %rsi

	print_num1:
	syscall

	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $eol, %rsi
	mov $2, %rdx
	syscall

cmp $1, %r12
je ascii_to_number
mov $1, %r12
mov $sum_out1, %rdi
mov $num1_buf, %rsi
jmp read_file


ascii_to_number:
	mov $0, %rax

	sum_out1_to_number:
	mov sum_out1(, %rax, 1), %bl
	cmp $0, %bl
	je sum_out2_to_number_prepare
	sub $0x30, %bl
	mov %bl, sum_out1(, %rax, 1)
	inc %rax
	jmp sum_out1_to_number

	sum_out2_to_number_prepare:
	mov $0, %rax

	sum_out2_to_number:
	mov sum_out2(, %rax, 1), %bl
	cmp $0, %bl
	je mul_preparations
	sub $0x30, %bl
	mov %bl, sum_out2(, %rax, 1)
	inc %rax
	jmp sum_out2_to_number


mul_preparations:
	mov $0, %r8					# sum_out1 index
	mov $0, %r9					# sum_out2 index
	mov $0, %r10				# carry
	mov $2, %r11				# base


mul_algorithm:
	cmp $1024, %r9
	je koniec

	mov sum_out2(, %r9, 1), %al
	cmp $0, %al
	je found_0
	jmp found_1

	found_0:
		inc %r9
		jmp mul_algorithm
	
	found_1:
		mov $0, %r8
		iterate:
			mov $0, %rdx
			mov $0, %rax
			mov sum_out1(, %r8, 1), %al
			mov product(%r9, %r8, 1), %bl
			add %bl, %al
			add %r10, %rax
			div %r11
			mov %rax, %r10
			mov %dl, product(%r9, %r8, 1)
			inc %r8
			cmp $1024, %r8
			jl iterate
		
		inc %r9
		mov $0, %r10
		jmp mul_algorithm


koniec:
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
	movq $sum_out1, %rsi
	movq $4, %rdx
	syscall
