.global _start

.section .text
_start:

	mov $0, %rax
	movb (character), %al

	cmp $'!', %rax
	je exit_HW1
	cmp $'@', %rax
	je exit_HW1
	cmp $'#', %rax
	je exit_HW1
	cmp $'$', %rax
	je exit_HW1
	cmp $'%', %rax
	je exit_HW1
	cmp $'^', %rax
	je exit_HW1
	cmp $'&', %rax
	je exit_HW1
	cmp $'*', %rax
	je exit_HW1
	cmp $'(', %rax
	je exit_HW1
	cmp $')', %rax
	je exit_HW1
	cmp $'~', %rax
	je exit_HW1
	cmp $'_', %rax
	je exit_HW1
	cmp $'+', %rax
	je exit_HW1
	cmp $'{', %rax
	je exit_HW1
	cmp $'}', %rax
	je exit_HW1
	cmp $':', %rax
	je exit_HW1
	cmp $'"', %rax
	je exit_HW1
	cmp $'|', %rax
	je exit_HW1
	cmp $'<', %rax
	je exit_HW1
	cmp $'>', %rax
	je exit_HW1
	cmp $'?', %rax
	je exit_HW1

	cmp $'A', %rax
	jl skip_2_HW1
	cmp $'Z', %rax
	jle exit_HW1
skip_2_HW1:

	cmp $'a', %rax
	jl skip_HW1
	cmp $'z', %rax
	jg skip_HW1

	# 'a' <= al <= 'z'
	sub $32, %al
	
skip_HW1:


	mov $'!', %rbx
	cmp $'1', %rax
	cmove %rbx, %rax

	mov $'@', %rbx
	cmp $'2', %rax
	cmove %rbx, %rax

	mov $'#', %rbx
	cmp $'3', %rax
	cmove %rbx, %rax

	mov $'$', %rbx
	cmp $'4', %rax
	cmove %rbx, %rax

	mov $'%', %rbx
	cmp $'5', %rax
	cmove %rbx, %rax

	mov $'^', %rbx
	cmp $'6', %rax
	cmove %rbx, %rax

	mov $'&', %rbx
	cmp $'7', %rax
	cmove %rbx, %rax

	mov $'*', %rbx
	cmp $'8', %rax
	cmove %rbx, %rax

	mov $'(', %rbx
	cmp $'9', %rax
	cmove %rbx, %rax

	mov $')', %rbx
	cmp $'0', %rax
	cmove %rbx, %rax

	mov $'~', %rbx
	cmp $'`', %rax
	cmove %rbx, %rax

	mov $'_', %rbx
	cmp $'-', %rax
	cmove %rbx, %rax

	mov $'+', %rbx
	cmp $'=', %rax
	cmove %rbx, %rax

	mov $'{', %rbx
	cmp $'[', %rax
	cmove %rbx, %rax

	mov $'}', %rbx
	cmp $']', %rax
	cmove %rbx, %rax

	mov $':', %rbx
	cmp $';', %rax
	cmove %rbx, %rax

	mov $'"', %rbx
	cmp $''', %rax
	cmove %rbx, %rax

	mov $'|', %rbx
	cmp $'\\', %rax
	cmove %rbx, %rax

	mov $'<', %rbx
	cmp $',', %rax
	cmove %rbx, %rax

	mov $'>', %rbx
	cmp $'.', %rax
	cmove %rbx, %rax

	mov $'?', %rbx
	cmp $'/', %rax
	cmove %rbx, %rax

	mov $0xff, %rbx
	cmp (character), %al
	cmove %rbx, %rax

exit_HW1:
	movb %al, (shifted)

