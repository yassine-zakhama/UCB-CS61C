.globl classify

.data
newline: .string "\n"

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit
    #   code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne a0, t0, exit_with_89

    # Prologue
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)

    mv s0, a1           # (char**) argv
    mv s1, a2           # print classification?

    # Array that stores n of rows and cols for m0, m1, and input matrices
    # i == 0 -> n rows of m0
    # i == 1 -> n cols of m0
    # i == 2 -> n rows of m1
    # i == 3 -> n cols of m1
    # i == 4 -> n rows of input
    # i == 5 -> n cols of input
    li a0, 24
    jal malloc
    beq a0, zero, exit_with_88
    mv s2, a0           # array containing n of rows and cols

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pre-trained m0
    lw a0, 4(s0)        # m0 path
    mv a1, s2           # pointer to m0 n of rows
    addi a2, s2, 4      # pointer to m0 n of cols
    jal read_matrix
    mv s3, a0           # pointer to m0

    # Load pre-trained m1
    lw a0, 8(s0)        # m1 path
    addi a1, s2, 8      # pointer to m1 n of rows
    addi a2, s2, 12     # pointer to m1 n of cols
    jal read_matrix
    mv s4, a0           # pointer to m1

    # Load input matrix
    lw a0, 12(s0)
    addi a1, s2, 16     # pointer to input n of rows
    addi a2, s2, 20     # pointer to input n of cols
    jal read_matrix
    mv s5, a0           # pointer to input

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input

    # 1.1 malloc result of m0 * input
    lw t0, 0(s2)
    lw t1, 20(s2)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, zero, exit_with_88
    mv s6, a0

    # 1.2 do matrix multiplication
    mv a0, s3
    lw a1, 0(s2)
    lw a2, 4(s2)
    mv a3, s5
    lw a4, 16(s2)
    lw a5, 20(s2)
    mv a6, s6
    jal matmul

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    lw t0, 0(s2)
    lw t1, 20(s2)
    mul a1, t0, t1
    mv a0, s6
    jal relu

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # 1.1 malloc result of m1 * ReLU(m0 * input)
    lw t0, 8(s2)
    lw t1, 20(s2)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, zero, exit_with_88
    mv s7, a0

    # 1.2 do matrix multiplication
    mv a0, s4
    lw a1, 8(s2)
    lw a2, 12(s2)
    mv a3, s6
    lw a4, 0(s2)
    lw a5, 20(s2)
    mv a6, s7
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s0)
    mv a1, s7
    lw a2, 8(s2)
    lw a3, 20(s2)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    bne s1, zero, done

    # Call argmax
    mv a0, s7
    lw t0, 8(s2)
    lw t1, 20(s2)
    mul a1, t0, t1
    jal argmax
    mv s8, a0

    # Print classification
    mv a1, s8
    jal print_int

    # Print newline afterwards for clarity
    li a1, 10
    jal print_char

done:
    # free memory
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free

    # Epilogue
    lw s8, 36(sp)
    lw s7, 32(sp)
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 40

    ret

exit_with_88:
    li a1, 88
    jal exit2

exit_with_89:
    li a1, 89
    jal exit2
