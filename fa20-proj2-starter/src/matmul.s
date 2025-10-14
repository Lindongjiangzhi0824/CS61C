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


outer_loop_start:




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
