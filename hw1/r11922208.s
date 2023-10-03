.globl __start

.rodata
    division_by_zero: .string "division by zero"

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0

###################################
#  TODO: Develop your calculator  #
#                                 #
###################################

# Check if op = 0 (Addition)
beq s1, zero, addition

# Check if op = 1 (Subtraction)
li t0, 1
beq s1, t0, subtraction

# Check if op = 2 (Multiplication)
li t0, 2
beq s1, t0, multiplication

# Check if op = 3 (Division)
li t0, 3
beq s1, t0, division

# Check if op = 4 (Minimum)
li t0, 4
beq s1, t0, minimum

# Check if op = 5 (Exponentiation)
li t0, 5
beq s1, t0, exponentiation

# Check if op = 6 (Factorial)
li t0, 6
beq s1, t0, factorial


# Perform addition
addition:
    add s3, s0, s2
    beq x0, x0, output

# Perform subtraction
subtraction:
    sub s3, s0, s2
    beq x0, x0, output

# Perform multiplication
multiplication:
    mul s3, s0, s2
    beq x0, x0, output

# Perform division (Check for division by zero first)
division:
    beq s2, x0, division_by_zero_except
    div s3, s0, s2
    beq x0, x0, output

# Find minimum
minimum:
    blt s0, s2, output_a
    add s3, x0, s2
    beq x0, x0, output

output_a:
    add s3, x0, s0
    beq x0, x0, output

# Exponentiation (A^B)
exponentiation:
    li s3, 1 # result initialized to 1
    li t0, 0 # loop counter initialized to 0
    beq x0, x0, exponent_loop
exponent_loop:
    beq t0, s2, output
    mul s3, s3, s0
    addi t0, t0, 1
    beq x0, x0, exponent_loop

# Factorial
factorial:
    li s3, 1 # result initialized to 1
    mv t0, s0 # copy A to t0 for decrement
    beq x0, x0, factorial_loop

factorial_loop:
    beq t0, x0, output
    mul s3, s3, t0
    li t1, 1
    sub t0, t0, t1
    beq x0, x0, factorial_loop

output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit
