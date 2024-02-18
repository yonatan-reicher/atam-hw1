.global _start

.section .text
_start:

movq $head, %rbx #load address of first node which is also address of data
xor %r10, %r10 #initialize flags
xor %r11, %r11
xor %r8, %r8
movb $1, %r10b #greater flag set to true
movb $1, %r11b #greater equal flag set to true
movb $0, %r8b #almost greater equal flag set to false
cmp $0, (%rbx) #check end of list
je end_of_array_HW1

check_g_HW1:
movq %rbx, %rcx #backup current node in case we need to jump somewhere else
movq 8(%rbx), %rax  #load address of next node
cmp $0, %rax #check end of list
je end_of_array_HW1

movq (%rbx), %rsi #load value stored where rbx is pointing to 
movq %rax, %rbx #update rbx to point to next node
cmp %esi, (%rbx)  #compare values
ja check_g_HW1

movq %rcx, %rbx #restore current node, if we get here we need to jump
movb $0, %r10b #set greater flag false
jmp check_ge_HW1

check_ge_HW1:
movq 8(%rbx), %rax  #load address of next node
cmp $0, %rax #check end of list
je end_of_array_HW1

movq (%rbx), %rsi #load value stored where rbx is pointing to 
movq %rax, %rbx #update rbx to point to next node
cmpq %rsi, (%rbx)  #compare values
jae check_ge_HW1
movb $0, %r11b #set greater equal flag to false
jmp check_almost_ge_HW1

check_almost_ge_HW1:
#do this from the begining
movq $head, %rax
movq 8(%rax), %rbx #load address of next node
movq 8(%rbx), %rcx #load address of 2x next node
cmp $0, %rcx #check end of list
je end_of_array_HW1 #if there are only two numbers and we got here removing one number will result in almost ge

movq (%rax), %r9
cmp %r9, (%rbx)
jae loop_almost_ge_HW1 
cmpq %r9, (%rcx)
jae skip_middle_number_HW1
movq (%rbx), %r9
cmpq %r9, (%rcx)
jae skip_first_number_HW1
jmp failure_HW1


loop_almost_ge_HW1: #this follows the logic that a<=b and we insert c to check
cmp $0, %rcx #check end of list
je end_of_array_HW1
movq (%rbx), %r9 
cmpq %r9, (%rcx) #b<=c ?
jae get_next_node_ge_HW1
cmpb $1, %r8b #check if we already removed 
je failure_HW1
movq (%rax), %r9
cmpq %r9, (%rcx) #a<=c ?
jae skip_middle_number_HW1
movb $1, %r8b #almost greater equal flag set to true
movq 8(%rcx), %rcx #skip last number
jmp loop_almost_ge_HW1


get_next_node_ge_HW1:
movq 8(%rax), %rax #load address of next node
movq 8(%rbx), %rbx #load address of 2x next node
movq 8(%rcx), %rcx #load address of 3x next node
jmp loop_almost_ge_HW1

skip_first_number_HW1:
movb $1, %r8b #almost greater equal flag set to true
movq 8(%rax), %rax #load address of next node
movq 8(%rbx), %rbx #load address of 2x next node
movq 8(%rcx), %rcx #load address of 3x next node
jmp loop_almost_ge_HW1


skip_middle_number_HW1:
cmp $1, %r8b #check if we already removed
je failure_HW1
movb $1, %r8b #almost greater equal flag set to true
movq 8(%rbx), %rbx #load address of next node
movq 8(%rcx), %rcx #load address of 2x next node
jmp loop_almost_ge_HW1

end_of_array_HW1:
cmp $1, %r10b
je result_greater_HW1
cmp $1, %r11b
je result_greater_equal_HW1
movb $1, result
jmp end_HW1

result_greater_HW1:
movb $3, result
jmp end_HW1

result_greater_equal_HW1:
movb $2, result
jmp end_HW1

failure_HW1:
movb $0, result
jmp end_HW1

end_HW1:

