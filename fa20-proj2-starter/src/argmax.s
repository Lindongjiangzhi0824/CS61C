.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp,sp,-12
    sw ra,8(sp)
    sw s0,4(sp)
    sw s1,0(sp)

    li t0,1
    blt a1,t0, error_exit

    mv s0, a0
    mv s1, a1
    
    # t1 存放当前的最大值
    lw t1, 0(s0)

loop_start:
    beq s1,zero,loop_end

    # t2 存放每轮读到的值
    lw t2, 0(s0)
    # 当前的 <= 最大的t1,继续循环
    ble t2,t1,loop_continue
    # 更新最大值与最大值index
    mv t1,t2
    
    sub a0,a1,s1


loop_continue:
    addi s0,s0,4
    addi s1,s1,-1
    j loop_start

loop_end:

    # Epilogue
    lw s1,0(sp)
    lw s0,4(sp)
    lw ra,8(sp)
    addi sp,sp,12

    ret

error_exit:
    li a0,77
    ecall           #exit(77)