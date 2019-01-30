####################################################################################
# Created by:  Kwong, Billy
#              bqkwong
#              1 November 2018
#
# Assignment:  Lab 3: Looping in MIPS
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2018
#
# Description: This program iterates through a set of numbers and prints either “Flux,” “Bunny,” or “Flux Bunny.”
#
# Notes:       This program is intended to be run from the MARS IDE.
####################################################################################

# REGISTER USAGE
# $t0: User input
# $t1: Loop counter
# $t2: 35
# $t3: 5
# $t4: 7
# $t5: Divisible by 35
# %t6: Divisible by 5
# $t7: Divisible by 7
# $t9: End loop

.data
    Prompt:    .asciiz "Please input a positive integer: "
    Flux:      .asciiz "Flux\n"
    Bunny:     .asciiz "Bunny\n"
    FluxBunny: .asciiz "Flux Bunny\n"
    newLine:   .asciiz "\n"

.text
main: nop
    # Begin Program
    li $v0 4
    la $a0 Prompt          
    syscall                  # Prints out prompt
    li $v0 5               
    syscall                  # User enters positive number
    add $t0 $v0 $zero        # Save user input into register
    
    # Loop
    add $t1 $t1 $zero        # Start of loop
    add $t9 $t0 1            # End of loop
    
    # Initialize Variables
    li $t2 35                # 35
    li $t3 5                 # 5
    li $t4 7                 # 7
    
Loop: nop
    beq $t1 $t9 Exit         # Exit program if starting number reaches user inputted number
    rem $t5 $t1 $t2          # Divide by 35
    rem $t6 $t1 $t3          # Divide by 5
    rem $t7 $t1 $t4          # Divide by 7
    beq $t5 $zero fluxbunny  # If divisible by 35   
    beq $t6 $zero flux       # If divisible by 5  
    beq $t7 $zero bunny      # If divisible by 7
    bgt $t5 $zero number     # If else
    
number: nop
    li $v0 1
    la $a0 ($t1)
    syscall
    li $v0 4
    la $a0 newLine
    addi $t1 $t1 1
    syscall
    b Loop

fluxbunny: nop
    li $v0 4
    la $a0 FluxBunny
    syscall
    addi $t1 $t1 1
    b Loop
     
flux: nop
    li $v0 4
    la $a0 Flux
    syscall
    addi $t1 $t1 1
    b Loop

bunny: nop
    li $v0 4
    la $a0 Bunny
    syscall
    addi $t1 $t1 1
    b Loop
   
Exit: nop
    li $v0 10
    syscall



















