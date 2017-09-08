		.data
testData:	.word		2, 3, 26, 39, 2689
absentMessage:	.ascii		" was not found."
target:		.word		39
presentMessage:	.ascii		" was found."
		.text
		.globl		main
main:
		la	$a0, testData		# Load address of array containing test data
		la	$s0, target		# Load address of target value
		lw	$a1, 0($s0)		# Load target value
		
		jal	BinarySearch		# Execute BinarySearch subroutine
		
		addi	$a2, $s1, 0
		jal	OutputMessage		# Execute OutputMessage subroutine
		
		li	$v0, 10
		syscall	
		
BinarySearch:
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
						
		add 	$t6, $a0, $t7		# testdata[mid] 
		lw	$t6, 0($t6)		# Load value from testdata[mid]
		
		bgt	$a1, $t6, afterElse	# if (target > data[mid]) jump to afterElse
		beq	$a1, $t6, afterElse	# if (target == data[mid]) jump to afterElse
		
		add	$t2, $zero, $t5		# end = mid
		j 	startLoop
		
afterElse:
		add	$t1, $zero, $t5		# start = mid
		j	startLoop
		
endLoop:	
		mul	$t7, $t1, 4		# Multiply start by word length to use as offset
		
		add 	$t6, $a0, $t7		# testdata[start]
		lw	$t6, 0($t6)		# Load value at testdata[start]
		
		bne	$a1, $t6, notStart	# If (target != testdata[start])
		addi	$s1, $zero, 1 		# Store 1 in register $s1, indicating presence of target value
		j	finish
		
notStart:	
		mul	$t7, $t2, 4		# Multiply start by word length to use as offset
				
		add 	$t6, $a0, $t7		# testdata[end]
		lw	$t6, 0($t6)		# Load value at testdata[end]
		
		bne	$a1, $t6, notEnd	# If (target != testdata[end])
		addi	$s1, $zero, 1 		# Store 1 in register $s1, indicating presence of target value
		j	finish
notEnd:		
		addi	$s1, $zero, 0		# Store 0 in register $s1, indicating absence of target value

finish:	
		jr	$ra		

OutputMessage:	
		li	$v0, 1
		add	$a0, $a1, 0		# Print target number to preface output message
		syscall
				
		bne	$a2, 0, present		# Check register $a2 for presence of 0 (which would indicate the target number's absence)
		
absent:		
		li	$v0, 4
		la	$a0, absentMessage	# Output message indicating absence of number
		syscall
		
		j	OutputMessageEnd

present:
		li	$v0, 4
		la	$a0, presentMessage	# Output message indicating presence of number
		syscall
			
OutputMessageEnd:
		jr	$ra
