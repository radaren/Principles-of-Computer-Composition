#################################################
# 查找替换匹配字符或字符串。
# 从键盘输入一字符或字符串与在内存某单元开始字符串相匹配，
# 若找到匹配字符或字符串，
# 则将键盘输入的一字符或字符串将其替换，
# 并统计替换个数，
# 将统计结果和替换后的整个字符串显示在屏幕上，
# 如找不到匹配的则显示“No match!”。如：
# ”Replace?：”+??
# “String?：”+?????????????????
#################################################

.text
.globl main

main:
	
	la $a0, dictionary
	li $v0, 4
	syscall		# show tips for putin string
	
	la $a0, putInTips
	li $v0, 4
	syscall		# show tips for putin string
	
	la $a0, putInString
	la $a1, putInSize
	li $v0, 8
	syscall		# putin string
	
	add $s0,$zero,$zero # save show times
	add $s1,$zero,$zero # save length of string
	la  $s2,putInString # save putinString address
	la  $s3,dictionary  # save dictionary address
	la  $s4,savePosition
	add $s5,$zero,$zero # save length of replace
	la  $s6,replaceString
	addi$s7,$zero,10    # save '\n'
	la  $s8,replaced	# save replaced

	# obtain length of the input string
	addi $t0,$s2,0
	Strlen:
		lb $t1,0($t0)  # attention ! use lb to obtain char
		beq $t1,$s7,ExitStrlen
		addi $t0,$t0,1
		addi $s1,$s1,1
		j Strlen
	ExitStrlen:
	
	# obtain begin and end position of each matching
	addi $t1,$s2,0	# begining of input character
	addi $t0,$s3,0  # begining of dictionary
	addi $t7,$s4,0  # begining of position address
	
	Find:
		lb $t2,0($t0)
		lb $t3,0($t1)
		
		beq $t2,$zero,ExitFind	# end of dictionary
		bne $t2,$t3,AddPosition # not equal at first place
		
		addi $t4,$t0,1
		addi $t5,$t1,1
		addi $t6,$zero,1 # save length
	CheckFullString:
		beq $t6,$s1,AddCount
		lb $t2,0($t4)
		lb $t3,0($t5)
		beq $t2,$s7,AddPosition
		beq $t3,$s7,AddPosition # check boundary
		bne $t2, $t3,AddPosition
		addi $t4,$t4,1
		addi $t5,$t5,1
		addi $t6,$t6,1
		j CheckFullString
	AddCount:
		addi $s0,$s0,1
		sw $t0,($t7)
		addi $t7,$t7,4
	AddPosition:
		addi $t0,$t0,1
		j Find
	ExitFind:
	
	
	# output replace function
	beq $s0,$zero,NotFound
		la $a0,matchingfor # .asciiz"matching for "
		li $v0,4
		syscall 
		add $a0,$s0,$zero
		li $v0,1
		syscall	# show findTimes
		la $a0,times_n  #.asciiz" times\n"
		li $v0,4
		syscall 
		la $a0,replaceTips
		li $v0,4
		syscall # show replace tips
		la $a0, replaceString
		la $a1, putInSize
		li $v0, 8
		syscall	# putin replace string
		
		addi $t1,$s3,0 # begin of Dictionary
		addi $t7,$s4,0 # begin of startposition queue
		addi $t8,$s8,0 # begin of replaced string
		ReplacePrint:
			lb $t2,0($t1)
			lw $t4,($t7)
			beq $t2,$zero,ExitReplacePrint
			bne $t1,$t4,printChar
			# enter matching & replace area
			addi $t0,$s6,0
			printReplace:
				lb $t3,0($t0)  # attention ! use lb to obtain char
				beq $t3,$s7,ContinuePrint # '\n'
				add $a0,$zero,$t3
				sb $a0,0($t8)
				addi $t8,$t8,1
				addi $t0,$t0,1
				j printReplace 
			ContinuePrint:
				addi $t7,$t7,4	# turn to next start position
				add $t1,$t1,$s1 # add the length of string
				j ReplacePrint
			# end of matching & replace area
			printChar:
				add $a0,$zero,$t2
				sb $a0,0($t8)
				addi $t8,$t8,1
				addi $t1,$t1,1	
				j ReplacePrint	
		ExitReplacePrint:
		la $a0, replaced
		li $v0, 4
		syscall		# show tips for putin string
		
		j Exit
	NotFound:
		la $a0,FailedSign
		li $v0,4
		syscall	
	Exit:

.data
	putInString: .space 200 	# find string
	replaceString:.space 200 	# replace string
	savePosition:.space 400 	# savePosition for matching start and end
	replaced:    .space 400     # replaced string

	putInSize :  .word 100		# length of putinString
 	
 	dictionary: .asciiz"helloworld myworld\n"  # matching string
 	
 	putInTips:  .asciiz"String?:"	 # tip for input searching string 
 	replaceTips:.asciiz"Replace?:"	 # tip for asking changing string
 	FailedSign: .asciiz"No match!\n" # if not find this,show failedSign
 	matchingfor:.asciiz"matching for "
 	times_n:    .asciiz" times\n"