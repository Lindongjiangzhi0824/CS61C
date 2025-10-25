.globl classify

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
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # check arguemnt count ,need 5 arguements
    li t0,5
    bne a0,t0,error_89

    addi sp, sp, -48
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
    sw s9, 40(sp)
    sw s10, 44(sp)




	# =====================================
    # LOAD MATRICES
    # =====================================
    # Save arguments
    mv s0,a1 # argv
    mv s1,a2 # print_classification    

    # Load pretrained m0
    li a0,8
    jal malloc
    beq a0,zero,error_88

    # Reserve the m0's rows and cols pointer
    mv s5,a0
    mv a1,a0 # rows data space of read_matrix parament
    addi a2,a0,4 # # cols data space of read_matrix parament
    lw a0,4(s0) # read m0 pointer
    jal read_matrix

    mv s2, a0 # save matrix m0 (integers matrix)



    # Load pretrained m1
    li a0,8
    jal malloc
    beq a0,zero,error_88

    # Reserve the m1's rows and cols pointer
    mv s6,a0
    mv a1,a0 # rows data space of read_matrix parament
    addi a2,a0,4 # # cols data space of read_matrix parament
    lw a0,8(s0) # read m1 pointer
    jal read_matrix

    mv s3, a0 # save matrix m1 (integers matrix)





    # Load input matrix
    li a0,8
    jal malloc
    beq a0,zero,error_88

    # Reserve the input matrix's rows and cols pointer
    mv s7,a0
    mv a1,a0 # rows data space of read_matrix parament
    addi a2,a0,4 # # cols data space of read_matrix parament
    lw a0,12(s0) # read m1 pointer
    jal read_matrix

    mv s4, a0 # save matrix input matrix (integers matrix)



    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)


    # 1. LINEAR LAYER:    m0 * input = d
    # Allocate the spaces of d
    lw t0,0(s5) # m0 rows
    lw t1,4(s7) # m1 cols
    mul t0,t0,t1
    slli t0,t0,2
    jal malloc
    beq a0,zero,error_88
    mv s8,a0 # pointer of d

    mv a0,s2
    lw a1,0(s5)
    lw a2,4(s5)
    mv a3,s4
    lw a4,0(s7)
    lw a5,4(s7)
    mv a6,s8
    jal matmul


    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mv a0,s8
    lw t0,0(s5) # rows of d
    lw t1,4(s7) # cols of d
    mul a1,t0,t1
    jal relu


    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0, 0(s6) # rows of m1
    lw t1, 4(s7) # cols of d
    mul t0, t0, t1
    slli a0, t0, 2
    jal malloc
    beq a0,zero,error_88
    mv s9,a0 # scores matrixs

    mv a0,s3
    lw a1,0(s6)
    lw a2,4(s6)
    mv a3,s8
    lw a4,0(s5)
    lw a5,4(s7)
    mv a6,s9
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0,16(s0)
    mv a1,s9
    lw a2,0(s6)
    lw a3,4(s7)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0,s9
    lw t0,0(s6)
    lw t1,4(s7)
    mul a1,t0,t1
    jal argmax
    mv s10,a0 # classification

    # Print classification
    bne s1, zero, skip_print_classification
    mv a1,s10
    jal print_int

    # Print newline afterwards for clarity
    li a1,'\n'
    jal print_char


skip_print_classification:
    # Free memory
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
    mv a0, s9
    jal free

    # Return value
    mv a0, s10

    # Epilouge
    lw s10, 44(sp)
    lw s9, 40(sp)
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
    addi sp, sp, 48

    ret

error_88:
    li a1,88
    j exit2

error_89:
    li a1,89
    j exit2