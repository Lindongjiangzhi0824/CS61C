.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    li t0,1
    blt a2,t0,error_length
    blt a3,t0,error_stride
    blt a4,t0,error_stride

    addi sp,sp,-16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    # s0 = 指针 v0 , s1 = 指针v1
    mv s0,a0
    mv s1,a1

    li t0,0 # 点积和
    li t1,0 # 当前循环计数 i

    
loop_start:
    # if (i >= len) break
    bge t1,a2,loop_end 
    
    lw t2,0(s0) # t2 = v0[i]
    lw t3,0(s1) # t3 = v1[i]
    mul t4,t2,t3 # t4 = v0[i] * v1[i]
    add t0,t0,t4 # 把每轮结果放到t0中

    # 更新指针与循环计数
    addi t1,t1,1 # i++
    
    # v0 += stride_a * 4
    mv s2,a3
    slli s2,s2,2
    add s0,s0,s2

    # v1 += stride_b * 4
    mv s2,a4
    slli s2,s2,2
    add s1,s1,s2

    j loop_start
    

loop_end:

    mv a0,t0
    # Epilogue
    lw s2,0(sp)
    lw s1,4(sp)
    lw s0,8(sp)
    lw ra,12(sp)
    addi sp,sp,16
    
    ret

error_length:
    li a1,75
    j exit2
    

error_stride:
    li a1,76
    j exit2