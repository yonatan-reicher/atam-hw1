.global _start

.section .text
_start:
movq $source_array, %rax
movq $up_array, %rbx
movq $down_array, %rcx
movl size, %r12d #load size value
xor %rsi,%rsi #set index = 0
xor %r8,%r8 #increasing started flag set to 0
xor %r9,%r9 #decreasing started flag set to 0

cmpl $0, %r12d #check if size = 0 
je success_HW1
inc %esi
jmp fit_both_HW1 #see how to handle first element

check_and_load_HW1:
cmpl %esi, %r12d #check if size > index
jl success_HW1
lea 4(%rax), %rax #load next element address
inc %esi
jmp check_inc_HW1


check_inc_HW1:
cmpb $0, %r8b #check if we sarted increasing
je check_dec_op1_HW1
movl (%rax), %edx
cmp -4(%rbx), %edx
jg check_dec_op1_HW1
jmp check_dec_op2_HW1


check_dec_op1_HW1: #fits into increasing
cmpb $0, %r9b #check if we sarted decreasing
je fit_both_HW1
movl (%rax), %edx
cmpl -4(%rcx), %edx
jl fit_both_HW1
jmp add_inc_HW1


check_dec_op2_HW1: #doesnt fit into increasing
cmp $0, %r9d #check if we sarted decreasing
je add_dec_HW1
movl (%rax), %edx
cmpl -4(%rcx), %edx
jl add_dec_HW1
jmp failure_HW1


add_inc_HW1:
movl (%rax), %edx
movl %edx, (%rbx)
movl $1,%r8d
lea 4(%rbx), %rbx
jmp check_and_load_HW1

add_dec_HW1:
movl (%rax), %edx
movl %edx, (%rcx)
movb $1,%r9b
lea 4(%rcx), %rcx
jmp check_and_load_HW1


fit_both_HW1:
cmpl %esi, %r12d #check if size = index
je add_inc_HW1
movl 4(%rax), %edx #load next value
cmpl (%rax), %edx #compare the numbers if 2nd>1st add 1 to inc
jg add_inc_HW1
jmp add_dec_HW1

success_HW1:
movq $bool, %rax
movb $1, (%rax)
jmp end_HW1


failure_HW1:
movq $bool, %rax
movb $0, (%rax)
jmp end_HW1

end_HW1:
