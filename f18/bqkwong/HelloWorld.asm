#Cory Ibanez
#HelloWorld.asm

.text

li	$v0, 5
syscall
la	$t0, ($v0)



li	$v0, 4
li	$t1, 0

#while(t1 <= t0){
loop:	bgt	$t1, $t0, exitLoop #if(t1>=t0) break;
	la	$a0, helloWorld
	addi	$t1, $t1, 1	#t1++
	add	$a0, $a0, $t1 	#a0 = a0 + t1
	syscall
	
	#if t1 == 5 then print message 2
	
	bne	$t1, 5, skip
	la	$a0, messageTwo
	syscall
	b	skipElse
	
	skip:
	
	#else
	la	$a0, messageThree
	syscall
	
	skipElse:
	b loop
#}

exitLoop:
li	$v0, 10
syscall

.data
helloWorld: .asciiz "Hello World!!!"
messageTwo: .asciiz "Message Number 2..."
messageThree: .asciiz "Hi!"
