.text

.global get_clock
.type get_clock, @function

get_clock:
	rdtsc
	shl $32, %rdx
	add %rax, %rdx
	ret
