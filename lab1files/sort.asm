.text
.globl main
main:
	# Read 
	li $t0,10			# the length of the loop
	li $t1, 0			# the begining of the loop
	la $t2 array		# load base address of array into reg $t2
	loopRead:
		beq $t1, $t0, endr		# t1 add up equal to 10
		li $v0,5
		syscall					
		sw $v0,($t2)			# save value of v0 to v2
		addi $t1, $t1, 1        # increment the count
		addi $t2,$t2,4      	# read an interger
		j loopRead              # continue loop
	endr:

	li $t1, 0
	loopt1:
		beq $t1,$t0,endt1
		addi $t1,$t1,1          # make 10 times loop
		li $t2, 1
		la $t3 array
		loopt2:
			beq $t2,$t0,endt2
			lw $s0,0($t3)
			lw $s1,4($t3)
			bge $s0,$s1,endswap
				xor $s0,$s0,$s1
				xor $s1,$s0,$s1
				xor $s0,$s0,$s1
				sw $s0,0($t3)
				sw $s1,4($t3)
			endswap:
			addi $t3,$t3,4
			addi $t2,$t2,1
			j loopt2
		endt2:
		j loopt1
	endt1:


	#output the final answer
	li $t1, 0			# the begining of the loop
	la $t2 array		# load base address of array into reg $t2
	loopoutput:
		beq $t1, $t0, endo		# t1 add up equal to 10
		addi $t1, $t1, 1        # increment the count
		lw $a0,($t2)
		li $v0,1
		addi $t2,$t2,4
		syscall					# print an interger
		la $a0,endl
		li $v0,4
		syscall
		j loopoutput            # continue loop
	endo:

.data
	array:  .space 40	# save 10 interger array
	endl:	.asciiz "\n"