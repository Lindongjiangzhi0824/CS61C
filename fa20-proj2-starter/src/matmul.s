.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    li t0,1
    blt a1,t0,error_length_m0
    blt a2,t0,error_length_m0
    blt a4,t0,error_length_m1
    blt a5,t0,error_length_m1
    bne a2,a4,error_match # col_a != row_b



    # Prologue
    add t0,zero,a0 # pointer to m0
    add t1,zero,a3 # pointer t0 m1
    addi t2,zero,0 # counter (outer)
    mul t3,a1,a5   # calculate need loop num  m*n n*k -> m*k
    addi t4,zero,0 # result of inner loop
    addi t5,zero,0 # counter (inner)

    addi a2,zero,0 # 作为行计数器 

    addi a0,t3,zero   # calculate need memory m*n n*k -> m*k
    slli a0,a0,2   # every val have 4 byte memory
    j malloc       # return a0 pointer to new matrix d
    li a5,0
    add a5,a0,zero # 保存 d 的地址
    

outer_loop_start:
    beq t2,t3,loop_end
    beq a2,a4,change_row_pointer # m1_col == m2_row 所以可以空出一个可以使用的 reg


    j inner_loop_start
    li t5,0 # 内部计数器重置

    sw t4,0(a5) # 将结果存入新的地址空间
    addi a5,a5,4 # 指向下一个元素

    addi t4,zero,0 # 新一轮结果值重置为 0
    addi t2,t2,1
    addi a2,a2,1 # a2是行计数器，每执行到一行的数量，更改行头指针地址 eg.a[0][0] -> a[1][0]
    
    addi t1,t1,4 # 列指针指向下一个元素
change_row_pointer:
    li a2,1 
    slli a2,a2,2 
    mul a2,a1,a2 # offset = row_m0 * 4
    add t0,t0,a2 # next_pointer = base + offset
    mv t1,a3 # 恢复列指针指向第一列第一个元素
    
    
    li a2,0 # 行计数重置

inner_loop_start:
    beq t5,a4,outer_loop_start # inner loop execute col_m0 or row_m1
    lw t6,0(t0)
    lw t7,0(t1)
    mul t6,t6,t7
    add t4,t4,t6

    add t0,t0,4 # new_add = current_add + offset
    slli t6,a4,2 # 列偏移 (使用t6作为暂存) offset
    add t1,t1,t6 # base + offset
    addi t5,t5,1
loop_end:
    ret

error_length_m0:
    li a1,72
    j exit2

error_length_m1:
    li a1,73
    j exit2

error_match:
    li a1,74
    j exit2











inner_loop_end:




outer_loop_end:


    # Epilogue
    
    
    ret
