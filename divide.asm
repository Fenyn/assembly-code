# Anthony Knight 

.data
prompt:	.asciiz "Enter a number: "
	.align 2
error:	.asciiz	"ERROR: Cannot divide by zero"
qprint:	.asciiz "\nAnswer: "
rprint:	.asciiz "\nRemainder: "

.text

	move	$t6, $0		#initialize Q to 0
	move 	$t7, $0		#initialize R to 0

	la 	$a0, prompt
	li	$v0, 4
	syscall
	li 	$v0, 5
	syscall
	move	$t4, $v0	#$t4 becomes N
	
	la 	$a0, prompt
	li	$v0, 4
	syscall
	li 	$v0, 5
	syscall
	move	$t5, $v0	#$t5 becomes D
	
	j	check

zerobreak:
	la	$a0, error	#print error message
	li	$v0, 4
	syscall
	
	li	$v0, 10		#terminate
	syscall
	
done:	li	$v0, 4		#syscall print string
	la	$a0, qprint	#print qanswer string
	syscall
	move	$a0, $t6	# put quotient into syscall arg
	li	$v0, 1		# syscall: print integer
	syscall
	
	li	$v0, 4		#syscall print string
	la	$a0, rprint	#print ranswer string
	syscall
	move	$a0, $t7	# put remainder into syscall arg
	li	$v0, 1		# syscall: print integer
	syscall
	
	li	$v0, 10
	syscall
	
MSBfind:
	beqz 	$a0, divide	#jumps out if N becomes 0
	srl 	$a0, $a0, 1	#shifts N right one bit
	addi 	$t3, $t3, 1	#increment shift count
	j 	MSBfind		#loop back around
	
check:	move	$a0, $t5	#loads divisor and checks if 0
	beqz	$a0, zerobreak	#breaks and prints error if so
	move	$a0, $t4	#loads number to be divided
	move 	$t3, $0		#counts number of bits shifted, need outside of MSB loop
	j	MSBfind
	j	divide

divide:	
	beqz	$t3, done
	sll	$t7, $t7, 1	#shift R left 1
	xor	$t7, $t7, $t3	#set LSB of R to bit i of numerator
	bgt	$t7, $t2, divide2
	subi	$t3, $t3, 1
	j 	divide
divide2:
	sub	$t7, $t7, $t2
	xor	$t6, $t6, $t3
	subi	$t3, $t3, 1
	j	divide
	