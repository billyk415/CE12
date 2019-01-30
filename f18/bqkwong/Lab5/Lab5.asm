############################################################################
# Created by: Kwong, Billy
# bqkwong
# 28 November 2018
#
# Assignment: Lab 5: Subroutines
# CMPE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Fall 2018
#
# Description: This program will display a string and prompt the user to type the same string in a
# given time limit. It will check if this string is identical to the given one and
# whether the user made the time limit. If the user types in the prompt incorrectly or
# does not finish the prompt in the given time limit, the game is over.
# You will learn how to implement subroutines and manage data on the
# stack.
#
# Notes: This program is intended to be run from the MARS IDE.
############################################################################

# REGISTER USAGE
# $a0: prompt, first string, allocate space, first char of string
# $a1: start time, 1000, second string
# $a2: 10 seconds
# $v0: 0, 1
# $s0: string
# $t0: start time, bit of first string
# $t1: second string, bit of second string
# $t2: total time elapsed

.data
Prompt: .asciiz "Type Prompt: "
allocateSpace: .byte 1000

.text
#--------------------------------------------------------------------
# give_type_prompt
#
# input: $a0 - address of type prompt to be printed to user
#
# output: $v0 - lower 32 bit of time prompt was given in milliseconds
#--------------------------------------------------------------------
give_type_prompt: nop
    li $v0 4
    la $a0 Prompt    
    syscall        # Print out prompt
    lw $a0 ($s0)
    syscall        # Print out string
    li $v0 30
    syscall        # Start timer
    la $v0 ($a0)  
    jr $ra


#--------------------------------------------------------------------
# check_user_input_string
#
# input: $a0 - address of type prompt printed to user
# $a1 - time type prompt was given to user
# $a2 - contains amount of time allowed for response
#
# output: $v0 - success or loss value (1 or 0)
#--------------------------------------------------------------------
check_user_input_string: nop
    addi $sp  $sp -4        # Create stack
    sw   $ra ($sp)
    move $t0  $a1           # store start time to $t0
    la   $a0 allocateSpace  # Create space for user entered string
    li   $a1 1000
    li   $v0 8
    syscall                 # Print out user entered string
    move $t1  $a0           # Store second string into $t1
    li   $v0  30
    syscall
    sub  $t2  $a0 $t0       # End time minus start time to get total time
    la   $a1 ($t1)          # Move second string to $a1
    lw   $a0 ($s0)          # Move first string to $a0
    ble  $t2  $a2 passes    # If user types prompt under 10 seconds
    li   $v0  0
    jr   $ra


# If user types prompt within 10 seconds    
passes: nop
    jal compare_strings     # Jump to compare_strings
    lw $ra ($sp)      
    addi $sp $sp 4          # Pop stack
	
	
#--------------------------------------------------------------------
# compare_strings
#
# input: $a0 - address of first string to compare
# $a1 - address of second string to compare
#
# output: $v0 - comparison result (1 == strings the same, 0 == strings not the same)
#--------------------------------------------------------------------
compare_strings: nop
    addi $sp  $sp -4  # Second stack
    sw   $ra ($sp)
    lb   $t0 ($a0)    # Store first bit of first string into $t0
    lb   $t1 ($a1)    # Store first bit of second string into $t1
    jal compare_chars


#--------------------------------------------------------------------
# compare_chars
#
# input: $a0 - first char to compare (contained in the least significant byte)
# $a1 - second char to compare (contained in the least significant byte)
#
# output: $v0 - comparison result (1 == chars the same, 0 == chars not the same)
#
#--------------------------------------------------------------------
compare_chars: nop
    addi $sp  $sp   -4            # Third stack
    sw   $ra ($sp)
    beq  $t1  $zero finishString  # If end of string
    beq  $t0  $t1   matches       # If first string and second string matches
    li   $v0  0
    lw   $ra ($sp)
    addi $sp  $sp   4             # Pop third stack
    lw   $ra ($sp)
    addi $sp  $sp   4             # Pop second stack
    jr   $ra
    
    
# Loop to move character one bit right if matches
matches: nop
    addi $a0  $a0 1   
    addi $a1  $a1 1
    lw   $ra ($sp)
    addi $sp  $sp 4   # Pop third stack
    lw   $ra ($sp)
    addi $sp  $sp 4   # Pop second stack
    jr   $ra
    
	
# End of string
finishString: nop
    lw   $ra ($sp)
    addi $sp  $sp 4   # Pop third stack
    lw   $ra ($sp)
    addi $sp  $sp 4   # Pop second stack
    li   $v0  1
    jr   $ra
    


