.global _start

.section .text
_start:
	# ==Algorithm==:
	# 	index <- 0
	#	skip_to_after_dollar()
	#	
	# 	if command[index] == '0':
	#		if command[index+1] == ',':
	#			exit with legal <- 1, integer <- 0
	#
	# 	read_base()
	# 	read_digit_chars()
	# 	parse_char(c1)
	# 	parse_char(c2)
	# 	parse_char(c3)
	#
	#	legal <- 1
	#	integer <- c3
	#	if base == 2:
	#		integer <- c1 * 4 + c2 * 2
	#	if base == 8:
	#		integer <- c1 * 64 + c2 * 8
	#	if base == 100:
	#		integer <- c1 * 100 + c2 * 10
	#	if base == 16:
	#		integer <- c1 * 256 + c2 * 16
	#	
	#	void skip_to_after_dollar():
	#		if command[index] == '\0': exit with legal <- 0
	#		if command[index] == '$':
	#			index++
	#			return
	#		index++
	#		skip_to_after_dollar()
	#	
	# 	void read_base():
	# 		if command[index] == '0':
	#			index++
	#			if command[index] == 'b':
	#				index++
	#				base <- 2
	#			else if command[index] == 'x':
	#				index++
	#				base <- 16
	#			else if command[index] == 'q':
	#				index++
	#				base <- 8
	#			else: base <- 8
	# 		else: base <- 10
	#	
	#	void count_digits():
	#		if command[index + digits] == '\0': exit with legal <- 0
	#		if command[index + digits] == ',': return
	#		digits++
	#		count_digits()
	#	
	#	void read_digit_chars():
	# 		digits <- 0
	#		count_digits()
	# 		if digits == 0: exit with legal <- 0
	# 		if digits > 3: exit with legal <- 0
	#		
	# 		if digits == 1:
	#			c1 <- '0'
	#			c2 <- '0'
	#			c3 <- command[index]
	# 		if digits == 2:
	#			c1 <- '0'
	#			c2 <- command[index]
	#			c3 <- command[index+1]
	# 		if digits == 3:
	#			c1 <- command[index]
	#			c2 <- command[index+1]
	#			c3 <- command[index+2]
	#	
	# 	void parse_char(&c):
	#		if '0' <= c <= '9': c <- c - '0'
	#		if 'a' <= c <= 'f': c <- c - 'a' + 10
	#		if 'A' <= c <= 'F': c <- c - 'A' + 10
	#		if c >= base: exit with legal <- 0
	#		
	#	

	# rax will be the index
	# r9-r11 wil be c1-c3
	# rbx will be c
	# rcx will be like a return address for fake functions
	# rdx will be base
	# rsi will be a temporary
	# rdi will be a digits

	mov $0, %rax
	jmp skip_to_after_dollar_HW1
	skip_to_after_dollar_ret_HW1:
	
	# 	if command[index] == '0':
	#		if command[index+1] == ',':
	#			exit with legal <- 1, integer <- 0
	cmpb $'0', command(%rax)
	jne skip_zero_special_case_HW1
		cmpb $',', (command+1)(%rax)
		je zero_special_case_exit_HW1
	skip_zero_special_case_HW1:

	jmp read_base_HW1
	read_digit_chars_ret_HW1:

	# These are like fake function calls
	mov %r9, %rbx
	lea parse_char_ret_1_HW1(%rip), %rcx
	jmp parse_char_HW1 
	parse_char_ret_1_HW1:
	mov %rbx, %r9
	mov %r10, %rbx
	lea parse_char_ret_2_HW1(%rip), %rcx
	jmp parse_char_HW1
	parse_char_ret_2_HW1:
	mov %rbx, %r10
	mov %r11, %rbx
	lea parse_char_ret_3_HW1(%rip), %rcx
	jmp parse_char_HW1
	parse_char_ret_3_HW1:
	mov %rbx, %r11

	movb $1, (legal)
	mov %r11, %rsi
	mov %esi, (integer)

	cmp $2, %rdx
	jne base_not_2_HW1
		shl %r10 # c2 *= 2
		lea (%r10, %r9, 4), %rsi
		add %esi, (integer)
	base_not_2_HW1:
	cmp $8, %rdx
	jne base_not_8_HW1
		shl $6, %r9 # c1 *= 64
		lea (%r9,%r10, 8), %rsi
		add %esi, (integer)
	base_not_8_HW1:
	cmp $10, %rdx
	jne base_not_10_HW1
		mov $100, %rsi
		imul %rsi, %r9
		lea (%r10, %r10, 4), %r10
		shl %r10
		lea (%r9, %r10), %rsi
		add %esi, (integer)
	base_not_10_HW1:
	cmp $16, %rdx
	jne base_not_16_HW1
		shl $4, %r9
		add %r10, %r9
		shl $4, %r9
		mov %r9, %rsi
		add %esi, (integer)
	base_not_16_HW1:

	jmp exit_HW1

skip_to_after_dollar_HW1:
	cmpb $0, command(%rax)
	je exit_illegal_HW1
	inc %rax
	cmpb $'$', (command-1)(%rax)
	je skip_to_after_dollar_ret_HW1
	jmp skip_to_after_dollar_HW1

read_base_HW1:
	mov $10, %rdx # default base is 10
	cmpb $'0', command(%rax)
	jne read_base_ret_HW1

	inc %rax
	mov $8, %rdx
	cmpb $'b', command(%rax)
	jne read_base_not_b_HW1
		inc %rax
		mov $2, %rdx
		jmp read_base_ret_HW1
	read_base_not_b_HW1:
	cmpb $'x', command(%rax)
	jne read_base_not_x_HW1
		inc %rax
		mov $16, %rdx
		jmp read_base_ret_HW1
	read_base_not_x_HW1:
	cmpb $'q', command(%rax)
	jne read_base_ret_HW1
		inc %rax
		jmp read_base_ret_HW1

count_digits_HW1:
	cmpb $0, command(%rax, %rdi)
	je exit_illegal_HW1
	cmpb $',', command(%rax, %rdi)
	je count_digits_ret_HW1
	inc %rdi
	jmp count_digits_HW1

read_base_ret_HW1:
read_digit_chars_HW1:
	mov $0, %rdi
	jmp count_digits_HW1
	count_digits_ret_HW1:
	cmp $0, %rdi
	je exit_illegal_HW1
	cmp $3, %rdi
	jg exit_illegal_HW1

	cmp $1, %rdi
	jne digits_not_one_HW1
		mov $'0', %r9
		mov $'0', %r10
		mov command(%rax), %r11
	digits_not_one_HW1:
	cmp $2, %rdi
	jne digits_not_two_HW1
		mov $'0', %r9
		mov command(%rax), %r10
		mov (command+1)(%rax), %r11
	digits_not_two_HW1:
	cmp $3, %rdi
	jne digits_not_three_HW1
		mov command(%rax), %r9
		mov (command+1)(%rax), %r10
		mov (command+2)(%rax), %r11
	digits_not_three_HW1:
	# Zero out everything outside the first byte
	and $0xFF, %r9
	and $0xFF, %r10
	and $0xFF, %r11
	jmp read_digit_chars_ret_HW1

parse_char_HW1:
	lea (-'0')(%rbx), %rsi
	cmp $9, %rsi
	cmovbe %rsi, %rbx
	jbe parse_char_end_HW1
	lea (-'a')(%rbx), %rsi
	cmp $('f'-'a'), %rsi
	cmovbe %rsi, %rbx
	lea (-'A')(%rbx), %rsi
	cmp $('F'-'A'), %rsi
	cmovbe %rsi, %rbx
	
	add $10, %rbx
parse_char_end_HW1:
	cmp %rdx, %rbx
	jge exit_illegal_HW1
	jmp *%rcx

zero_special_case_exit_HW1:
	movb $1, (legal)
	movl $0, (integer)
	jmp exit_HW1
exit_illegal_HW1:
	movb $0, (legal)
exit_HW1:
	
