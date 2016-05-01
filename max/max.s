# edi - save index
# ebx - max number
# eax - current number

.section .data
data_items:
	# data items should end with 0!
	.long 3, 67, 34, 22, 0

.section .text

.globl _start

_start:
	# mov 0 to edi
	movl  $0, %edi
	# mov data_items 0 to eax
	movl data_items (, %edi, 4), %eax
	# move eax to ebx
	# ebx is max number now
	movl %eax, %ebx

start_loop:
	# compare 0 to eax (current number)
	cmpl $0, %eax
	# if current nmber is 0 then goto loop exit
	# 0 is the end of the data items
	je loop_exit
	# increase edi (index->next)
	incl %edi
	# read next data items 4 is bytes lenght
	movl data_items (, %edi, 4), %eax
	# compare ebx and eax
	cmpl %ebx, %eax
	# if eax < ebx then start_loop
	jle start_loop
	# else eax >= ebx
	# move eax to max number which is ebx
	movl %eax, %ebx
	# goto loop
	jmp start_loop

loop_exit:
	movl $1, %eax
	int $0x80
