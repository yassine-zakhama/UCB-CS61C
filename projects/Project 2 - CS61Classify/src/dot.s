.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    ble a2, zero, exit_with_75
    ble a3, zero, exit_with_76
    ble a4, zero, exit_with_76

    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)

    mv s0, a0
    mv s1, a1
    li t0, 0            # counter
    li a0, 0            # result

loop:
    mul t3, t0, a3      # offset for v0, considering stride
    slli t3, t3, 2
    mv t1, s0           # address of v0
    add t1, t1, t3      # offset v0 address by the count
    lw t1, 0(t1)        # load v0[i]

    mul t3, t0, a4      # offset for v1, considering stride
    slli t3, t3, 2
    mv t2, s1           # address of v1
    add t2, t2, t3      # offset v1 address by the count
    lw t2, 0(t2)        # load v1[i]

    mul t1, t1, t2
    add a0, a0, t1

    addi t0, t0, 1
    blt t0, a2, loop   # while i < len

    # Epilogue
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 8

    ret

exit_with_75:
    li a0, 17
    li a1, 75
    ecall

exit_with_76:
    li a0, 17
    li a1, 76
    ecall
