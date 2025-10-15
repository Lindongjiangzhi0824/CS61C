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
    addi sp,sp,-32
    sw ra,28(sp)
    sw s0,24(sp)
    sw s1,20(sp)
    sw s2,16(sp)
    sw s3,12(sp)
    sw s4,8(sp)

    # Setup saved registers
    mv s0,a0 # base_m0
    mv s1,a3 # base_m1
    mv s2,a6 # base_d
    mv s3,a2 # cols_mo = n
    mv s4,a5 # cols_m1 = k

    # 要写第一个循环了，所以设置循环变量值
    li t0,0  # i = 0



outer_loop_i:
    bge t0,a1,done # if i>=rows_m0: done
    li t1,0        # j = 0

inner_loop_j:
    bge t1,a5,next_i # if j>=cols_m1: next_i
    li t2,0          # sum = 0
    li t3,0          # r = 0

inner_loop_r:
    bge t3,s3,store_value # if r >= cols_m0: store

    # load m0[i][r]
    mul t4,t0,s3          # i * col_m0
    add t4,t4,t3          # + r
    slli t4,t4,2          # *4 Bytes
    add t4,s0,t4          
    lw t5,0(t4)

    # load m1[r][j]
    mul t6,t3,s4          # r * col_m1
    add t6,t6,t1          # + j
    slli t6,t6,2          # * 4 Bytes
    add t6,s1,t6
    lw t4,0(t6)

    # accumulate
    mul t5,t5,t4
    add t2,t2,t5

    addi t3,t3,1
    j inner_loop_r

store_value:
    # d[i][j] = sum
    mul t4,t0,s4
    add t4,t4,t1
    slli t4,t4,2
    add t4,t4,s2
    sw t2,0(t4)

    # j += 1
    addi t1,t1,1
    j inner_loop_j

next_i:
    addi t0,t0,1
    j outer_loop_i

done:
    lw s4,8(sp)
    lw s3,12(sp)
    lw s2,16(sp)
    lw s1,20(sp)
    lw s0,24(sp)
    lw ra,28(sp)
    addi sp,sp,32
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
