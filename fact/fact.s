# get n!
# 1! = 1
# 2! = 2
# 4! = 24

.section .data
.section .text

.globl _start

_start:
	# 4!
	pushl $4
	# call function
	call factorial
	addl $4, %esp
	# return value is in eax, but we want show in ebx
	# echo $? will return value in ebx
	movl %eax, %ebx
	# syscall
	movl $1, %eax
	int $0x80

.type factorial, @function
factorial:
	pushl %ebp
	movl %esp, %ebp
	# first argument
	movl 8(%ebp), %eax
	cmpl $1, %eax
	je end_factorial
	decl %eax
	pushl %eax
	# call function itself
	call factorial
	movl 8(%ebp), %ebx
	imull %ebx, %eax

end_factorial:
	movl %ebp, %esp
	popl %ebp
	ret
