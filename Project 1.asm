	.data
menu1:	.asciiz "1. Binary to Decimal and Hexadecimal"
menu2:	.asciiz "\n2. Hexadecimal to Binary and Decimal"
menu3:	.asciiz "\n3. Decimal to Binary and Hexadecimal"
menu4:	.asciiz "\n4. Exit"
enterBinaryMsg:	.asciiz "Enter Binary Number: "
enterHexMsg:	.asciiz "Enter Hexadecimal Number: "
enterDecMsg:	.asciiz "Enter Decimal Number: "
binaryDisplay:	.asciiz "Binary Number: "
hexDisplay:	.asciiz "\nHexadecimal Number: "
decDisplay:	.asciiz "Decimal Number: "
userInput:	.space	32
errorBinMsg:	.asciiz "\n0's and 1's only! Max 30 Digits.\n"
errorDecMsg:	.asciiz "\n0-9 digits only! Max 8 Digits.\n"
errorHexMsg:	.asciiz "\n0-9 and A-F only! Max 6 Digits.\n"
errorMenuMsg:	.asciiz "\nInvalid Input! 1-4 only."
slashN:		.asciiz "\n"
	.text
main:	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0

	li $v0, 4
	la $a0, slashN
	syscall

	li $v0, 4
	la $a0, menu1
	syscall
	
	li $v0, 4
	la $a0, menu2
	syscall
	
	li $v0, 4
	la $a0, menu3
	syscall
	
	li $v0, 4
	la $a0, menu4
	syscall
	
	li $v0, 4
	la $a0, slashN
	syscall
	
	li $v0, 5
	syscall
	beq $v0, 1, binary
	beq $v0, 2, hex
	beq $v0, 3, decimal
	beq $v0, 4, exit
	bgt $v0, 4, errorMenu
	blt $v0, 0, errorMenu
	
errorMenu:
	li $v0, 4
	la $a0, errorMenuMsg
	syscall
	
	j main

exit:
	li $v0, 10
	syscall
	
	
hex:
	li $v0, 4
	la $a0, enterHexMsg
	syscall
	
	li $v0, 8
	la $a0, userInput
	li $a1, 8
	syscall
	move $s0, $a0
	move $s1, $a0
	move $s2, $a0
	
	li $t0, 0
	jal verifyHex
	
	jal hexStringToInt
	
	li $v0, 4
	la $a0, hexDisplay
	syscall
	
	li $v0, 4
	move $a0, $s2
	syscall
	
	li $v0, 4
	la $a0, binaryDisplay
	syscall
	
	li $v0, 35
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, slashN
	syscall
	
	li $v0, 4
	la $a0, decDisplay
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	j main
	
hexStringToInt:
	sub $t0, $t0, 1
	
	li $t1, 0
	
loop3:	li $t5, 16
	move $t7, $t0
	beq $t0, -1, exitLoop3
	lb $t1, ($s1)
	sub $t2, $t1, 48 
	ble $t2, 9, skipSetter
	beq $t1, 'A', aSetter
	beq $t1, 'a', aSetter
	beq $t1, 'B', bSetter
	beq $t1, 'b', bSetter
	beq $t1, 'C', cSetter
	beq $t1, 'c', cSetter
	beq $t1, 'D', dSetter
	beq $t1, 'd', dSetter
	beq $t1, 'E', eSetter
	beq $t1, 'e', eSetter
	beq $t1, 'F', fSetter
	beq $t1, 'f', fSetter
aSetter:
	li $t2, 10
	j skipSetter
bSetter:
	li $t2, 11
	j skipSetter
cSetter:
	li $t2, 12
	j skipSetter
dSetter:
	li $t2, 13
	j skipSetter
eSetter:
	li $t2, 14
	j skipSetter
fSetter:
	li $t2, 15
	j skipSetter

skipSetter:
loopHex:beq $t7, 0, contHex
	beq $t7, 1, contHex
	mul $t5, $t5, 16
	sub $t7, $t7, 1
	j loopHex
contHex: 	beq $t0, 0, skipMult
	beq $t0, 1, setSixteen
	mul $t4, $t5, $t2    
	j addSkip
setSixteen: li $t5, 16	
	mul $t4, $t5, $t2
addSkip:	add $t3, $t3, $t4 #$t3 is total
	j skipSkipper
skipMult:
	add $t3, $t3, $t2
skipSkipper: add $s1, $s1, 1 #Shift to next bit
	sub $t0, $t0, 1
	j loop3
exitLoop3:
	jr $ra
	
continueHex:
	add $t0, $t0, 1
	add $s0, $s0, 1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
	
verifyHex:
	lb $t1, ($s0)
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	beq $t1, '0', continueHex
	beq $t1, '1', continueHex
	beq $t1, '2', continueHex
	beq $t1, '3', continueHex
	beq $t1, '4', continueHex
	beq $t1, '5', continueHex
	beq $t1, '6', continueHex
	beq $t1, '7', continueHex
	beq $t1, '8', continueHex
	beq $t1, '9', continueHex
	beq $t1, 'a', continueHex
	beq $t1, 'b', continueHex
	beq $t1, 'c', continueHex
	beq $t1, 'd', continueHex
	beq $t1, 'e', continueHex
	beq $t1, 'f', continueHex
	beq $t1, 'A', continueHex
	beq $t1, 'B', continueHex
	beq $t1, 'C', continueHex
	beq $t1, 'D', continueHex
	beq $t1, 'E', continueHex
	beq $t1, 'F', continueHex
	beq $t1, 10, return #NL in ascii table
	
	li $v0, 4
	la $a0, errorHexMsg
	syscall
	j hex
	

decimal:
	li $v0, 4
	la $a0, enterDecMsg
	syscall
	
	li $v0, 8
	la $a0, userInput
	li $a1, 10
	syscall
	move $s0, $a0
	move $s1, $a0
	li $t0, 0
	jal verifyDec
	
	jal decStringToInt
	li $t7, 10
	div $t3, $t7
	mflo $t3
	
	li $v0, 4
	la $a0, decDisplay
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, slashN
	syscall
	
	li $v0, 4
	la $a0, binaryDisplay
	syscall
	
	li $v0, 35
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, hexDisplay
	syscall
	
	li $v0, 34
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, slashN
	syscall
	
	j main
	
decStringToInt:
	sub $t0, $t0, 1
	
	li $t1, 0
	
loop2:	li $t5, 10 
	move $t7, $t0
	beq $t0, -1, exitLoop2
	lb $t1, ($s1)
	sub $t2, $t1, 48 
loop:	beq $t7, 0, cont
	mul $t5, $t5, 10
	sub $t7, $t7, 1
	j loop
cont: 	mul $t4, $t5, $t2    
	add $t3, $t3, $t4 #$t3 is total
	add $s1, $s1, 1 #Shift to next bit
	sub $t0, $t0, 1
	j loop2
exitLoop2:
	jr $ra
	
continueDec:
	add $t0, $t0, 1
	add $s0, $s0, 1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
	
verifyDec:
	lb $t1, ($s0)
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	beq $t1, '0', continueDec
	beq $t1, '1', continueDec
	beq $t1, '2', continueDec
	beq $t1, '3', continueDec
	beq $t1, '4', continueDec
	beq $t1, '5', continueDec
	beq $t1, '6', continueDec
	beq $t1, '7', continueDec
	beq $t1, '8', continueDec
	beq $t1, '9', continueDec
	
	beq $t1, 10, return #NL in ascii table
	
	li $v0, 4
	la $a0, errorDecMsg
	syscall
	j decimal
	
	
binary:
	li $v0, 4
	la $a0, enterBinaryMsg
	syscall
	
	li $v0, 8
	la $a0, userInput
	li $a1, 32
	syscall
	move $s0, $a0
	move $s1, $a0
	move $s2, $a0
	#move $s0, $v0
	li $t0, 0
	jal verifyBinary
	
	jal binaryStringToInt
	
	li $v0, 4
	la $a0, binaryDisplay
	syscall
	
	li $v0, 4
	move $a0, $s1
	syscall
	
	li $v0, 4
	la $a0, decDisplay
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, hexDisplay
	syscall
	
	li $v0, 34
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, slashN
	syscall
	
	j main
	
binaryStringToInt:
	sub $t0, $t0, 1
	li $t1, 0
loop1:
	beq $t0, -1, exitLoop1
	lb $t1, ($s2)
	sub $t2, $t1, 48 
	sllv $t2, $t2, $t0
	add $t3, $t3, $t2 #$t3 is total
	add $s2, $s2, 1 #Shift to next bit
	sub $t0, $t0, 1
	j loop1
exitLoop1:
	jr $ra


continueBin:
	add $s0, $s0, 1
	addi $t0, $t0, 1 # Binary String Length
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
verifyBinary:
	lb $t1, ($s0)
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	beq $t1, '1', continueBin
	beq $t1, '0', continueBin
	beq $t1, 10, return #NL in ascii table
	
	li $v0, 4
	la $a0, errorBinMsg
	syscall
	j binary
return:
	jr $ra

	
	
