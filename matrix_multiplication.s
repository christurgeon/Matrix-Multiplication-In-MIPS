# Author: Chris Turgeon

		 	.data
prompt:   .asciiz "Please enter values for n, k, and m:\n"
print1:  	.asciiz "Please enter values for the first matrix ("
print2:  	.asciiz "Please enter values for the second matrix ("
print3:  	.asciiz "x"
print4:  	.asciiz "):\n"
print5:  	.asciiz "["
print6:  	.asciiz "]\n"
print7:  	.asciiz "\t"
print8:  	.asciiz "\n"
print9:  	.asciiz "multiplied by\n"
print10:	.asciiz "equals\n"

			.text
			.globl main
main:

		la $a0, prompt
		li $v0, 4     		# print message
		syscall
		li $v0, 5
		syscall			# read_int 'n'
		move $t0, $v0
		li $v0, 5
		syscall			# read_int 'k'
		move $t1, $v0
		li $v0, 5
		syscall			# read_int 'm'
		move $t2, $v0

		li $v0, 4
		la $a0, print1		# print message
		syscall
		li $v0, 1
		move $a0, $t0 		# print number of rows
		syscall
		li $v0, 4
		la $a0, print3		# print 'x' character
		syscall
		li $v0, 1
		move $a0, $t1     	# print number of columns
		syscall
		li $v0, 4
		la $a0, print4    	# print '):\n'
		syscall

		li $t3, 0           	# loop counter to read in values
		mul $t4, $t0, $t1   	# store n*k (total num in mat 1)
		mul $s5, $t1, $t2   	# store l*m (total num in mat 2)
		mul $t8, $t4, 4     	# store n*k*4
		j mat1_init


mat1_init:

	# dynamically allocate memory for matrix one
        move $a0, $t8
        li $v0, 9
        syscall
        move $s0, $v0       		# store martrix one in $s0
        move $t6, $s0       		# store base address in $t6
        j mat1


mat1:

		beq $t3, $t4, mat2_init

		li $v0, 5           	# read_int
		syscall

		move $t5, $v0       	# move input to register
		sw $t5, 0($s0)      	# store in array

		addi $s0, $s0, 4    	# increment array index
		addi $t3, $t3, 1    	# increment counter
		j mat1


mat2_init:

		li $v0, 4
		la $a0, print2		# print message
		syscall
		li $v0, 1
		move $a0, $t1 		# print number of rows
		syscall
		li $v0, 4
		la $a0, print3		# print 'x' character
		syscall
		li $v0, 1
		move $a0, $t2     	# print number of columns
		syscall
		li $v0, 4
		la $a0, print4   	# print '):\n'
		syscall

        # dynamically allocate memory for matrix two
        move $a0, $t8
        li $v0, 9
        syscall
        move $s1, $v0       		# store matrix two in $s1
        move $t7, $s1       		# store base address in $t7

        move $t3, $zero     		# reset counter to zero
		j mat2


mat2:

		beq $t3, $s5, mat1_print_init

		li $v0, 5         	# read_int
		syscall

		move $t5, $v0      	# move input to register
		sw $t5, 0($s1)   	# store in array

		addi $s1, $s1, 4   	# increment array index
		addi $t3, $t3, 1   	# increment counter
		j mat2


mat1_print_init:

		la $a0, print8
		li $v0, 4          	# print '\n' for formatting
		syscall

		move $s0, $t6      	# reset $s0 to beginning of array
		li $t9, 0          	# column counter
		li $t5, 0          	# array length counter
		j mat1_left

mat1_left:

	    beq $t5, $t4, mat2_print_init
		la $a0, print5
		li $v0, 4        	# print starting '['
		syscall
		j mat1_print_numbers

mat1_print_numbers:

		# if $t9 is equal to number of columns
		# then go to the next line in matrix
		beq $t9, $t1, mat1_right

		lw $t3, 0($s0)    	# load number from array
		move $a0, $t3
		li $v0, 1          	# print number
		syscall

		la $a0, print7
		li $v0, 4          	# print tab
		syscall

		addi $s0, $s0, 4   	# increment array index
		addi $t9, $t9, 1   	# increment column counter
		addi $t5, $t5, 1   	# increment array length counter
		j mat1_print_numbers

mat1_right:

		la $a0, print6
		li $v0, 4          	# print ending ']\n'
 		syscall
 		li $t9, 0          	# reset column counter to zero
 		j mat1_left


mat2_print_init:

		la $a0, print9
		li $v0, 4          	# print 'multiplied by\n'
		syscall

		move $s1, $t7      	# reset $s0 to beginning of array
		li $t9, 0          	# column counter
		li $t5, 0          	# array length counter
		j mat2_left

mat2_left:

	  beq $t5, $s5, multiply_init
		la $a0, print5
		li $v0, 4          	# print starting '['
		syscall
		j mat2_print_numbers

mat2_print_numbers:

		# if $t9 is equal to number of columns
		# then go to the next line in matrix
		beq $t9, $t2, mat2_right

		lw $t3, 0($s1)     	# load number from array
		move $a0, $t3
		li $v0, 1         	# print number
		syscall

		la $a0, print7
		li $v0, 4          	# print tab
		syscall

		addi $s1, $s1, 4   	# increment array index
		addi $t9, $t9, 1   	# increment column counter
		addi $t5, $t5, 1   	# increment array length counter
		j mat2_print_numbers

mat2_right:

		la $a0, print6
		li $v0, 4         	# print ending ']\n'
 		syscall	
 		li $t9, 0          	# reset column counter to zero
 		j mat2_left


multiply_init:

		li $t3, 0          	# matrix one column counter
		li $s4, 0           	# value to be printed
		li $s5, 0           	# total print counter
		li $s7, 0           	# row print counter
		mul $t4, $t0, $t2   	# store size of matrix 3

		move $s0, $t6       	# reset mat 1 to starting address
		move $s1, $t7       	# reset mat 2 to starting address
		move $t0, $t7       	# hold mat 2 starting index

		mul $s6, $t1, 4     	# holds incremental value for matrix one
		mul $t8, $t2, 4     	# holds incremental value for matrix two

		la $a0, print10
		li $v0, 4          	# print "equals\n"
		syscall
		la $a0, print5
		li $v0, 4           	# print "["
		syscall
		j matrix_load

matrix_load:

		# check to see where in matrices we are
		beq $t3, $t1, print_and_reset
		lw $t5, 0($s0)      	# load from matrix one
		addi $s0, $s0, 4    	# move to next index

		lw $t9, 0($s1)      	# load from matrix two
		add $s1, $s1, $t8   	# move to next value

		mul $s3, $t5, $t9   	# multiply numbers
		add $s4, $s4, $s3   	# add to holder register

		addi $t3, $t3, 1    	# increment counter
		j matrix_load

print_and_reset:

		move $a0, $s4
		li $v0, 1           	# print value
		syscall
		la $a0, print7
		li $v0, 4           	# print tab
		syscall

		# MATRIX ONE: reset to start of row
		move $s0, $t6

		# MATRIX TWO: move to start of next column
		addi $t0, $t0, 4
		move $s1, $t0

		addi $s5, $s5, 1    	# ++ print counter
		addi $s7, $s7, 1    	# ++ row counter
		li $t3, 0           	# reset counter to 0
		li $s4, 0           	# reset holder to 0

		beq $s5, $t4, EXIT
		beq $s7, $t2, mat1_next_row
		j matrix_load

mat1_next_row:

		# MATRIX ONE: move to start of next row
		add $t6, $t6, $s6
		move $s0, $t6

		# MATRIX TWO: reset it to first column
		move $s1, $t7
		move $t0, $t7

		li $s7, 0            	# reset counter to 0

		la $a0, print6
		li $v0, 4            	# print "]\n"
		syscall
		la $a0, print5
		li $v0, 4            	# print "["
		syscall
		j matrix_load


EXIT:

		la $a0, print6
		li $v0, 4            	# print "]"
		syscall
		jr $ra
