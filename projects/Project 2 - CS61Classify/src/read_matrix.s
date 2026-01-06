.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)

    mv s0, a0           # pointer to filename string
    mv s1, a1           # pointer to int; # rows
    mv s2, a2           # pointer to int; # cols

    # Open file with read only permission
    mv a1, s0           # pointer to filename
    li a2, 0            # permission: 0 = read only
    jal fopen
    li t0, -1
    beq a0, t0, exit_with_90
    mv s3, a0           # file descriptor (unique integer tied to file)

    # Read number of rows
    mv a1, s3
    mv a2, s1
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, exit_with_91

    # Read number of cols
    mv a1, s3
    mv a2, s2
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, exit_with_91

    lw s4, 0(s1)        # number of rows
    lw s5, 0(s2)        # number of cols

    # Malloc matrix
    mul s7, s4, s5      # matrix size
    slli a0, s7, 2       # number of bytes to allocate (size * 4)
    jal malloc
    beq a0, zero, exit_with_88
    mv s6, a0           # pointer to matrix

    # Read matrix
    mv a1, s3
    mv a2, s6
    slli a3, s7, 2
    jal fread
    slli t0, s7, 2
    bne a0, t0, exit_with_91

    # Close file
    mv a1, s3           # file descriptor
    jal fclose
    li t0, -1
    beq a0, t0, exit_with_92

    mv a0, s6

    # Epilogue
    lw s7, 32(sp)
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 36

    ret

exit_with_88:
    li a0, 17
    li a1, 88
    ecall

exit_with_90:
    li a0, 17
    li a1, 90
    ecall

exit_with_91:
    li a0, 17
    li a1, 91
    ecall

exit_with_92:
    li a0, 17
    li a1, 92
    ecall
