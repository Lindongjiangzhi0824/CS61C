.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp,sp,-32
    sw ra,28(sp)
    sw s0,24(sp)
    sw s1,20(sp)
    sw s2,16(sp)
    sw s3,12(sp) 
    sw s4,8(sp)  # 文件描述符
    sw s5,4(sp)

    mv s0,a0 # filename pointer
    mv s1,a1 # matrix pointer
    mv s2,a2 # rows data
    mv s3,a3 # cols data

    # open file
    mv a1,s0
    li a2,1 # a2:1-> write
    jal fopen

    li t0,-1
    beq a0,t0,error_93

    # save file descriptor to s3
    mv s4,a0

    # allocate space for rows and cols
    addi sp,sp,-8
    sw s2,0(sp) # rows
    sw s3,4(sp) # cols

    # write rows
    mv a1,s4
    # mv a2, s1 
    # here buffer with matrix pointer is not right, should be written to row data rows and column data cols

    mv a2,sp  # datasource : row (stack top)
    li a3,1
    li a4,4

    jal fwrite
    li t0,1
    bne a0,t0,error_94

    # write cols
    mv a1,s4
    addi a2,sp,4 # cols = stack top + 4
    li a3,1
    li a4,4

    jal fwrite
    li t0,1
    bne a0,t0,error_94

    addi sp,sp,8 # free temporary spaces

    # calculate matrix elements number
    mul s5,s2,s3
    # each buffer size
    li t0,4
    # write matrix
    mv a1,s4
    mv a2,s1
    mv a3,s5
    mv a4,t0
    jal fwrite
    bne a0,s5,error_94

    # close file
    mv a1,s4
    jal fclose
    bne a0,zero,error_95

    # Epilogue
    lw s5,4(sp)
    lw s4,8(sp)
    lw s3,12(sp)
    lw s2,16(sp)
    lw s1,20(sp)
    lw s0,24(sp)
    lw ra,28(sp)
    addi sp,sp,32


    ret

error_93:
    li a1,93
    j exit2

error_94:
    li a1,94
    j exit2

error_95:
    li a1,95
    j exit2
