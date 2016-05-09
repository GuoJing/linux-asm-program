build:
	rm -rf ./write_records
	as --gstabs write.s -o write.o --32
	as --gstabs write_records.s -o write_records.o --32
	ld write.o write_records.o -o write_records -m elf_i386

	rm -rf ./read_records
	as --gstabs count.s -o count.o --32
	as --gstabs newline.s -o newline.o --32
	as --gstabs read.s -o read.o --32
	as --gstabs read_records.s -o read_records.o --32
	ld read.o newline.o count.o read_records.o -o read_records -m elf_i386
