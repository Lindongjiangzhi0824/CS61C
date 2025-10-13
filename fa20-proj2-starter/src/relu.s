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
    # Prologue
    addi sp,sp,-12
    sw ra,8(sp)
    sw s0,4(sp)
    sw s1,0(sp)
    # 检查 a1 是否有效
    li t0,1
    ble a1,t0,loop_end

    mv s0,a0
    mv s1,a1
loop_start:
    lw t2,0(s0)
    bgt t2, zero, loop_continue # if t2 > zero then loop_continue
    sw zero,0(s0)


loop_continue:
    # 更新指针和计数器，检查循环是否继续
    addi s0,s0,4
    addi s1,s1,-1
    bne s1,zero,loop_start


loop_end:
    # Epilogue
    lw s1,0(sp)
    lw s0,4(sp)
    lw ra,8(sp)
    addi sp,sp,12
    
	ret
