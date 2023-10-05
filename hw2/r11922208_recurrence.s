.globl __start

.text
__start:
    li a0, 5  # read input n
    ecall
    mv s0, a0
    jal ra, fibonacci
    addi sp, sp, 12
    addi s2, a0, 0
    # print
    li a0, 1
    mv a1, s2
    ecall
    # exit
    li a0, 10
    ecall

fibonacci:
    addi sp, sp, -12
    sw ra, 8(sp)  # store return address
    sw a0, 4(sp)  # store the last return value
    sw s0, 0(sp)  # store the input
    addi t0, s0, -1  # if input > 1: do recursive call, or return input
    bgt t0, x0, recursive
    addi a0, s0, 0
    jalr x0, 0(ra)
recursive:
    addi s0, s0, -1  # T(n - 1)
    jal ra, fibonacci
    addi sp, sp, 12  # restore the stack
    lw s0, 0(sp)  # restore the input
    addi s0, s0, -2  # T(n - 2)
    jal ra, fibonacci
    lw t0, 4(sp)  # restore the last output
    addi sp, sp, 12  # restore the stack
    lw ra, 8(sp)  # restore the return address
    slli t0, t0, 1  # 2 * T(n - 1)
    add a0, a0, t0  # 2 * T(n - 1) + T(n - 2)
    jalr x0, 0(ra)
