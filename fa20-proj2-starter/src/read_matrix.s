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
	addi sp,sp,-32
    sw ra,28(sp)
    sw s0,24(sp)
    sw s1,20(sp)
    sw s2,16(sp)
    sw s3,12(sp) # 文件描述符
    sw s4,8(sp)
    sw s5,4(sp)

    mv s0,a0 # 文件名指针
    mv s1,a1 # 行数据地址
    mv s2,a2 # 列数据地址
    

    mv a1,s0 # fopen 需要a1:文件名指针 
    li a2,0  # a2:0 -> 只读权限
    jal ra,fopen

    li t0,-1 
    beq a0,t0,fopen_error

    # Save file descriptor to s3
    mv s3,a0
    # read rows
    mv a1,s3
    # 已经有指针就不要创建缓冲区了
    mv a2,s1
    addi a3,zero,4
    jal ra,fread
    li t0,4
    bne a0,t0,fread_error

    # 再读 cols
    mv a1,s3
    mv a2,s2
    addi a3,zero,4
    jal ra,fread
    li t0,4
    bne a0,t0,fread_error

    # 从缓冲区中取 row, col 两个值
    lw t0,0(s1)
    lw t1,0(s2)

    mul a0,t0,t1
    slli a0,a0,2
    mv s5, a0 # save size of matrix to s5
    jal malloc
    beq a0,zero,malloc_error

    # s4 保存申请的空间的指针
    mv s4,a0
    
    # 读取 matrix
    mv a1,s3
    mv a2,s4
    mv a3,s5
    jal ra,fread
    bne a0,s5,fread_error

    # close file
    mv a1,s3
    jal fclose
    bne a0,zero,fclose_error

    # Set return value
    mv a0,s4

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
malloc_error:
    li a1,88
    j exit2

fopen_error:
    li a1,90
    j exit2

fread_error:
    li a1,91
    j exit2

fclose_error:
    li a1,92
    j exit2