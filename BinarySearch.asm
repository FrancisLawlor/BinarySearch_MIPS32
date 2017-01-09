		.data
testdata:	.word		2, 3, 4, 5, 6
		.text
		.globl		main
main:
		la	$t0, testdata
		lw	$t1, 0($t0)
		
		li	$v0, 10
		syscall			