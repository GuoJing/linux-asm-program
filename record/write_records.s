.include "linux.s"
.include "def.s"

.section .data

record:
	# first name
	.ascii "Guo\0"
	# padding to 40
	.rept 36
	.byte 0
	.endr

	# last name
	.ascii "Jing\0"
	.rept 35
	.byte 0
	.endr

	# address
	.ascii "BeiJing China\0"
	.rept 226
	.byte 0
	.endr

	# age
	.ascii "28\0"
	.rept 1
	.byte 0
	.endr

file_name:	
	.ascii "test.dat\0"

.equ ST_FILE_DESCRIPTOR, -4

.section .text
.globl _start

_start:
	movl %esp, %ebp
	subl $4, %esp

	movl $SYS_OPEN, %eax
	movl $file_name, %ebx
	movl $0101, %ecx
	movl $0666, %edx
	int $SYSCALL

	movl %eax, ST_FILE_DESCRIPTOR(%ebp)

	pushl ST_FILE_DESCRIPTOR(%ebp)
	pushl $record
	call write_record
	addl $8, %esp
	
	movl $SYS_CLOSE, %eax
	movl ST_FILE_DESCRIPTOR(%ebp), %ebx
	int $SYSCALL

	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $SYSCALL
