############################################################################
# Created by: Kwong, Billy
# bqkwong
# 12 November 2018
#
# Assignment: Lab 4: ASCII Decimal to 2SC
# CMPE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Fall 2018
#
# Description: Read a string input and
# learn how to convert numerical ASCII characters into a two's complement binary
# number. You will also learn how to print a two's complement integer stored in a
# register.
#
# Notes: This program is intended to be run from the MARS IDE.
############################################################################

# PSEUDO CODE
# Print out prompt
# Enter program input in program arguments
# Store input into $a0
# Print $a0 output
# Convert ASCII strings to 2SC
# Store values $a1, 4($a1) into $s1, $s2 respectively
# Add the saved values $s1, $s2 and store sum into $s0
# Print out $s0
# Create bitmask loop to check every bit
# Loop to shift bitmask by 1
# Print out string
# End loop when end of string

# REGISTER USAGE
# $s0: stores 2sc sum of user inputs
# $s1: first 32-bit 2sc user entered integer
# $s2: second 32-bit 2sc user entered integer
# $t0: start of loop
# $t1: first byte, store converted value, end of loop
# $t2: second byte, store converted value, bitmask
# $t3: third byte, store converted value

.data
    Prompt1: .asciiz "You entered the decimal numbers:\n"
    Prompt2: .asciiz "\n\nThe sum in decimal is:\n"
    Prompt3: .asciiz "\n\nThe sum in two's complement binary is:\n"
    newLine: .asciiz "\n"
    Space:   .asciiz " "

.text
main:
    # Prints out first prompt
    li $v0 4
    la $a0 Prompt1
    syscall
    
    # Prints out user entered decimal numbers
    lw $a0  ($a1)    # Argument 1
    syscall
    la $a0 Space    
    syscall          # Space
    lw $a0 4($a1)    # Argument 2
    syscall
    
    # Prints out second prompt
    li $v0 4
    la $a0 Prompt2
    syscall
    
    # Convert first input   
    lw  $a0  ($a1)            # Load contents of $a1 into $a0
    lb  $t1  ($a0)            # Load first byte into $t1
    lb  $t2  1($a0)           # Load second byte into $t2
    beq $t1   45    negative  # Checks if first bit negative
    bne $t1   45    positive  # If first bit isn't negative, it is positive
    
# If negative 
negative: 
    lb  $t3  2($a0)           # Load third byte into $t3
    beq $t3  $zero negSingle  # If negative single number
    add $t2  $t2   -48	      # Must be negative double digit number, convert 2nd bit in tens place
    add $t3  $t3   -48	      # Convert 3rd bit in ones place
    mul $t2  $t2    10	      # Multiply by 10 and grab it from mflo
    add $s1  $t2   $t3	      # Add tens and ones digit together
    not $s1  $s1              # Invert and add 1
    add $s1  $s1     1
    b   nextInput

# If number is negative single digit   
negSingle:                       
    add $t2  $t2 -48
    la  $s1 ($t2)
    not $s1  $s1             # Invert
    add $s1  $s1   1         # Add 1
    b   nextInput

# If positive
positive: 
    beq $t2 $zero posSingle  # If positive single number, if not it is positive double digit number
    add $t1 $t1   -48
    add $t2 $t2   -48 
    mul $t1 $t1    10
    add $s1 $t1   $t2
    b   nextInput

# If positive single digit        
posSingle:
    add $t1  $t1 -48
    la  $s1 ($t1)
    b   nextInput
    
# Convert second input	
nextInput:
    lw  $a0 4($a1)            # Load contents of $a1 into $a0
    lb  $t1 ($a0)             # Load first byte into $t1
    lb  $t2 1($a0)            # Load second byte into $t2
    beq $t1   45   Neg2
    bne $t1   45   Pos2
# If negative double digit   
Neg2:
    lb  $t3 2($a0)
    beq $t3 $zero negSingle2  # If negative single number
    add $t2 $t2   -48	      # Must be negative double digit number, convert 2nd bit in tens place
    add $t3 $t3   -48	      # Convert 3rd bit in ones place
    mul $t2 $t2    10	      # Multiply by 10 and grab it from mflo
    add $s2 $t2   $t3	      # Add tens and ones digit together
    not $s2 $s2               # Invert 
    add $s2 $s2     1         # Add 1
    b   Sum
     
# If number is negative single digit   
negSingle2:                       
    add $t2  $t2 -48
    la  $s2 ($t2)
    not $s2  $s2
    add $s2  $s2   1
    b   Sum

# If positive double digit   
Pos2:
    beq $t2 $zero posSingle2  # If positive single number, if not it is positive doulbe digit number
    add $t1 $t1   -48
    add $t2 $t2   -48 
    mul $t1 $t1    10
    add $s2 $t1   $t2
    b   Sum

# If number is positive single digit   
posSingle2:
    add $t1  $t1 -48
    la  $s2 ($t1)

Sum:
    add $s0 $s1 $s2	        # Add the sum together

# Branches to respective values in $s0
Print: 
    bge $s0 100  Hundred        # Branch if 100+
    bge $s0 0    DoubleDig      # Branch if double digit number 0-99
    ble $s0 -100 NegHundred     # Branch if less than or equal to -100
    blt $s0 0    NegDoubleDig   # Branch if less than 0 -1 to -99

# If positive triple digit   
Hundred:
    div $t1  $s0 $s0    # Divide by itself to print 1
    add $t1  $t1  48
    la  $a0 ($t1)
    li  $v0  11
    syscall             # Print out character
    rem $t1  $s0  100	# Remainder by 100 so it is in double digit
    div $t2  $t1   10   # Divide by 10 then convert and print second digit
    add $t2  $t2   48
    la  $a0 ($t2)
    syscall	        # Print out character
    rem $t2  $t1   10   # Remainder by 10 then convert and print third digit
    add $t2  $t2   48
    la  $a0 ($t2)
    syscall             # Print out character
    b   Binary 

# If negative triple digit   
NegHundred:
    li  $v0   11	# Print minus sign
    la  $a0   45
    syscall
    div $t1  $s0 $s0    # Divide by itself to print 1
    add $t1  $t1  48
    la  $a0 ($t1)
    syscall             # Print out character
    rem $t1  $s0 100	# Remainder by 100 so it is in double digit
    mul $t1  $t1  -1    # Multiply by -1 to turn into positive
    div $t2  $t1  10    # Divide by 10 then convert and print second digit
    add $t2  $t2  48
    la  $a0 ($t2)
    syscall	        # Print out character
    rem $t2  $t1  10    # Remainder by 10 then convert and print third digit
    add $t2  $t2  48
    la  $a0 ($t2)
    syscall             # Print out character
    b   Binary

# If negative double digit   
NegDoubleDig:
    bgt $s0  -10  NegSingleDig
    li  $v0   11	                 
    la  $a0   45
    syscall                 # Print minus sign
    mul $t1  $s0  -1        # Multiply by -1 to turn into positive
    div $t2  $t1  10        # Divide by 10 then convert and print second digit
    add $t2  $t2  48
    la  $a0 ($t2)
    syscall	    
    rem $t2  $t1  10        # Remainder by 10 then convert and print third digit
    add $t2  $t2  48
    la  $a0 ($t2)
    syscall
    b   Binary
   
# If negative single digit
NegSingleDig:
    li  $v0   11        # Print minus sign
    la  $a0   45
    syscall
    mul $t1  $s0  -1    # Multiply by -1 to turn into positive
    rem $t2  $t1  10    # Remainder by 10 then convert and print 
    add $t2  $t2  48
    la  $a0 ($t2)
    syscall
    b   Binary
   
# If positive double digit
DoubleDig:
    blt $s0   10  SingleDig #0-9 isntead
    div $t2  $s0  10        # Divide by 10 then convert and print first digit, 10-99
    add $t2  $t2  48
    li  $v0  11
    la  $a0 ($t2)
    syscall	            # Print out character
    rem $t2  $s0  10        # Remainder by 10 then convert and print second digit
    add $t2  $t2  48
    la  $a0 ($t2)
    syscall                 # Print out character
    b   Binary
   
# If positive single digit
SingleDig:
    rem $t2  $s0 10        # Remainder by 10 then convert and print 
    add $t2  $t2 48
    li  $v0   11
    la  $a0 ($t2)
    syscall                # Print out character
  
# Prints out third prompt
Binary:
    li $v0 4 
    la $a0 Prompt3
    syscall
    li $t0 0               # Initialize $t0 to 0 for loop
    li $t1 32              # Initialize $t1 to 32 for loop
    li $t2 0x80000000	   # Bitmask

# Mask loop
loop:
    li  $v0   11
    and $t3  $s0   $t2		# and MSB with 0x80000000
    beq $t3  $zero printZero	# If it is 0, branch 
    div $t3  $t3   $t3		# If not, divide by itself to make it 1
    srl $t2  $t2    1		# Shift $t2 to the right by 1 place
    add $t3  $t3   48		# Convert by adding 48
    la  $a0 ($t3)		# Print
    syscall
    add $t0  $t0    1		# Add 1 to loop counter
    beq $t0  $t1   Terminate	# Branch if loop is equal to 32
    b   loop
    
# If bitmask is zero
printZero:
    la  $a0  48			# Print 0
    syscall
    srl $t2 $t2 1		# Shift $t2 to the right by 1 place
    add $t0 $t0 1		# Add 1 to loop counter
    beq $t0 $t1 Terminate	# Branch if loop is equal to 32
    b   loop

# End of program
Terminate:         # End program
    li $v0 4
    la $a0 newLine
    syscall        # Print new line
    li $v0 10
    syscall        # Terminate
