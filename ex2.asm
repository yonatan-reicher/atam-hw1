.global _start

.section .text
_start:
	# The idea for the algorithm:
	# Find a cycle by continuely removing nodes which we know are
	# not in a cycle, until you can't.
	# You know a node is not part of a cycle if it has no edges
	# going from it. And you know a node is not part of a cycle
	# if all of it's edges lead to nodes that you know are not part
	# of cycle.
	#
	# ==Algorithm==:
	# 
	# removed = {}
	# 
	# while True:
	# 	node_index <- 0
	#	none_leaves_seen <- 0
	#	skip_until_leaf()
	#	
	#	if node is null: exit with circle <- none_leaves_seen
	#	else: add node to removed
	#	
	# void skip_until_leaf():
	#	node <- vertices[node_index]
	#	if node is null: return
	#	if node_index in removed:
	#		node_index++
	#		skip_until_leaf()
	#		return
	#
	#	child_children_index <- 0
	#	skip_until_non_removed_child()
	#	if child != null:
	#		none_leaves_seen <- 1
	#		node_index++
	#		skip_until_leaf()
	#		return
	#		
	# void skip_until_non_removed_child():
	#	child <- node->children[child_children_index]
	#	child_vertices_index <- 0
	#	while vertices[child_vertices_index] != child
	#	and vertices[child_vertices_index] != null:
	#		child_vertices_index++
	#	if (child == null) return
	#	if child_vertices_index in removed:
	#		child_children_index++
	#		skip_until_non_removed_child()
	#		return
	
	# rax will be removed. al will be an 8-bit mask.
	# rbx will be node_index
	# rcx, rdx will help with setting bits in al
	# rdi will be none_leaves_seen
	# rsi will be node
	# r9 will be child_children_index
	# r10 will be child_vertices_index
	# r11 will be child
	mov $0, %rax
	
loop_start_HW1:
	mov $0, %rbx
	mov $0, %rdi
	jmp skip_until_leaf_HW1
skip_until_leaf_ret_HW1:
	cmp $0, %rsi
	je exit_HW1
	mov $1, %rdx
	mov %rbx, %rcx
	shl %cl, %rdx
	or %rdx, %rax
	jmp loop_start_HW1
	
skip_until_leaf_HW1:
	mov vertices(,%rbx, 8), %rsi
	cmp $0, %rsi
	je skip_until_leaf_ret_HW1
	mov $1, %rdx
	mov %rbx, %rcx
	shl %cl, %rdx
	and %rax, %rdx
	jz node_not_removed_HW1
		inc %rbx
		jmp skip_until_leaf_HW1
	node_not_removed_HW1:
	
	mov $0, %r9
	jmp skip_until_non_removed_child_HW1
skip_until_non_removed_child_ret_HW1:
	cmp $0, %r11
	je skip_until_leaf_ret_HW1

	mov $1, %rdi
	inc %rbx
	jmp skip_until_leaf_HW1

skip_until_non_removed_child_HW1:
	mov (%rsi, %r9, 8), %r11
	mov $0, %r10
	child_loop_HW1:
		cmp vertices(,%r10, 8), %r11
		je skip_child_loop_HW1
		cmpq $0, vertices(,%r10, 8)
		je skip_child_loop_HW1
		inc %r10
		jmp child_loop_HW1
	skip_child_loop_HW1:
	cmp $0, %r11
	je skip_until_non_removed_child_ret_HW1
	mov $1, %rdx
	mov %r10, %rcx
	shl %cl, %rdx
	and %rax, %rdx
	jz skip_until_non_removed_child_ret_HW1
	inc %r9
	jmp skip_until_non_removed_child_HW1

exit_HW1:
	mov %rdi, %rax
    cmp $0, %rax
    mov $-1, %rbx
    cmove %rbx, %rax
	mov %al, (circle)
