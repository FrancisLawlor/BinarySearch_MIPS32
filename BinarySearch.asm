		.data
testdata:	.word		2, 3, 4, 5, 6
target:		.word		2
		.text
		.globl		main
main:
		la	$t0, testdata		# Load address of array containing test data
		la	$s0, target		# Load address of target value
		lw	$s0, 0($s0)		# Load target value
		
		addi	$t1, $zero, 0		# Store 0 in register for start value
		addi	$t2, $zero, 4		# Store 4 in register for end value (length - 1)
		
startLoop:		
		addi	$t3, $t1, 1		# Add 1 to start
				
		bgt	$t3, $t2, endLoop	# if (start + 1 > end)
		beq	$t3, $t2, endLoop	# if (start + 1 == end)
		
		sub	$t4, $t2, $t1		# (end - start)
		div	$t4, $t4, 2		# (end - start) / 2
		add	$t5, $t1, $t4		# mid = start + ((end - start) / 2)
		
		mul	$t7, $t5, 4		# Multiply mid by word length to use as offset
						
		add 	$t6, $t0, $t7		# testdata[mid]
		lw	$t6, 0($t6)		# Load value from testdata[mid]
		
		bgt	$s0, $t6, afterElse	# if (target > data[mid]) jump to afterElse
		beq	$s0, $t6, afterElse	# if (target == data[mid]) jump to afterElse
		
		add	$t2, $zero, $t5		# end = mid
		j 	startLoop
afterElse:
		add	$t1, $zero, $t5		# start = mid
		j	startLoop
endLoop:	
		
		mul	$t7, $t1, 4		# Multiply start by word length to use as offset
		
		add 	$t6, $t0, $t7		# testdata[start]
		lw	$t6, 0($t6)		# Load value at testdata[start]
		
		bne	$s0, $t6, notStart	# If (target != testdata[start])
		addi	$s1, $zero, 1 
		j	finish
notStart:	

		mul	$t7, $t2, 4		# Multiply start by word length to use as offset
				
		add 	$t6, $t0, $t7		# testdata[end]
		lw	$t6, 0($t6)		# Load value at testdata[end]
		
		bne	$s0, $t6, notEnd	# If (target != testdata[end])
		addi	$s1, $zero, 1 
		j	finish
notEnd:		
		addi	$s1, $zero, 0

finish:	
		li	$v0, 10
		syscall			
