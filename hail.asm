# Anthony Knight 

.data
prompt:	.asciiz "Enter a number: "
	.align 2
saven:	.word

.text
	la	$a0, prompt
	li	$v0, 4
	syscall
	li 	$v0, 5
	syscall
	sw	$v0, saven($0)
	
	jal	multiply
	
done:	move	$a0, $a2	# put answer into syscall arg
	li	$v0, 1		# syscall: print integer
	syscall
	
	li	$v0, 10
	syscall
multiply:
	lw	$v0, saven($0)	# set v0 to stored number
	li	$t0, 16		# number of bits to multiply
	addi	$a2, $0, 1	#sets $a2 to one to be used as increment counter
check:	addi	$a3, $0, 1	#set $a3 to 1	
	beq	$v0, $a3, done	#jump to end if int == 1
	andi	$a1, $v0, 1	#check if odd
	beq	$a1, $a3, odd	#jump to odd if number is odd
	j	even		#else jump to even
odd:
	sll 	$a1, $v0, 1	# multiplying multiplier by 2
	add	$a0, $v0, $a1	# adds a1*2 to a1 resulting in a1*3
	addi	$v0, $a0, 1	#adds 1
	addi	$a2, $a2, 1	#increments counter
	j	check
even:
	srl	$v0, $v0, 1	#divide by 2
	addi	$a2, $a2, 1	#increments counter
	j	check

	