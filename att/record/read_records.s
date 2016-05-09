.include "linux.s"
.include "def.s"

.section .data

file_name:
	.ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
.globl _start

_start:
	.equ ST_INPUT_DESCRIPTOR, -4
	.equ ST_OUTPUT_DESCRIPTOR, -8

	movl %esp, %ebp
	sub $8, %esp

	movl $SYS_OPEN, %eax
	movl $file_name, %ebx
	movl $0, %ecx
	movl $0666, %edx
	int $SYSCALL

	movl %eax, ST_INPUT_DESCRIPTOR(%ebp)
	movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
	pushl ST_INPUT_DESCRIPTOR(%ebp)
	pushl $record_buffer
	call read_record
	addl $8, %esp

	cmpl $RECORD_SIZE, %eax
	jne finished_reading

	pushl $RECORD_FIRSTNAME + record_buffer
	call count
	addl $4, %esp
	movl %eax, %edx
	movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
	movl $SYS_WRITE, %eax
	movl $RECORD_FIRSTNAME + record_buffer, %ecx
	int $SYSCALL

	pushl ST_OUTPUT_DESCRIPTOR(%ebp)
	call write_newline
	addl $4, %esp

	jmp record_read_loop

finished_reading:
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $SYSCALL
