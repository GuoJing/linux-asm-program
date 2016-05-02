# how function works
# 2^3 + 5^2

# http://stackoverflow.com/questions/5485468/x86-assembly-pushl-popl-dont-work-with-error-suffix-or-operands-invalid
# http://stackoverflow.com/questions/36974737/my-simple-asm-program-segment-fault

.code32
.section .data
.section .text

.globl _start
_start:
	# push 3
	pushl $3
	# push 2
	pushl $2
	# call function power
	call power
	# move stack pointer
	addl $8, %esp
	# push return value to stack
	pushl %eax
	# push 2
	pushl $2
	# push 5
	pushl $5
	# call function power
	call power
	# move stack pointer
	addl $8, %esp
	# get top from stack and save to ebx
	popl %ebx
	# add eax and ebx
	addl %eax, %ebx
	# syscall
	movl $1, %eax
	int $0x80

# stack view

# pushl %ebp
# movl %esp, %ebp
# subl $4, %esp

# 2^3
# 2             <----  12(%ebp)
# 3             <----  8(%ebp)
# return value  <----  4(%ebp)
# old ebp       <----  (%ebp)
# current value <----  -4(%ebp) and (%esp)

	
.type power, @function
power:
	# push old ebp address
	pushl %ebp
	# mov esp to ebp
	movl %esp, %ebp
	# esp address - 4
	subl $4, %esp
	# 8 bit after ebp address is the first arg
	movl 8(%ebp), %ebx
	# 12 bit after ebp address is the second arg
	movl 12(%ebp), %ecx
	# save current value to 4 before ebp
	movl %ebx, -4(%ebp)

power_loop_start:
	# if ecx -> 2^3 => ecx is 3
	# so if ecx is 1 then end loop
	cmpl $1, %ecx
	je end_power
	# move current value to eax
	movl -4(%ebp), %eax
	# ebx * eax then save to eax
	imull %ebx, %eax
	# eax save to -4 ebp
	movl %eax, -4(%ebp)
	# decl
	decl %ecx
	jmp power_loop_start

end_power:
	# move value to eax
	movl -4(%ebp), %eax
	# restore esp
	movl %ebp, %esp
	# restore ebp
	popl %ebp
	# function return
	ret
