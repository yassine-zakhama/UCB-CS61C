.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    beq a1, zero, exit_with_78

    li t0, 0            # counter

loop:
    mv t1, a0           # address of the array
    slli t2, t0, 2
    add t1, t1, t2      # offset the array address by the count

    lw t3, 0(t1)        # t3 = value at i
    bge t3, zero, loop_continue
    sw zero, 0(t1)

loop_continue:
    addi t0, t0, 1
    bne t0, a1, loop

	ret

exit_with_78:
    li a0, 17
    li a1, 78
    ecall
