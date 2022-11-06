.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    addi t0, x0, 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    bne a2, a4, error
   
    #Prologue
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp) 
    sw ra, 48(sp)
    
    addi s0, a0, 0
    addi s1, a1, 0
    addi s2, a2, 0
    addi s3, a3, 0
    addi s4, a4, 0
    addi s6, a6, 0

    addi s9, a5, 0

    add s7, x0, x0 #current row of resulting matrix     
    add s8, x0, x0 #current col of resulting matrix
    add s10, x0, s3 #pointer to current col of m1
    addi s11, x0, 4 #increment value for m1 pointer
    addi s5, x0 ,4 
    mul s5, s5, s2 #increment value for m0 pointer
    j outer_loop_start

error:
    li a0, 38
    j exit

outer_loop_start:
   bge s7, s1, end #if row counter is >= rows in m0, end loop
   j inner_loop_start # else begin inner loop

inner_loop_start:
   bge s8, s9, outer_loop_end #if col counter is >= cols in m1, go to next iteration of outer loop
   addi a0, s0, 0 #set a0 to current row of m0
   addi a1, s10, 0 #set a1 to current col of m1
   addi a2, s2, 0 #set a2 to number of items (cols in m0)
   addi a3, x0, 1 #set a3 to stride 1
   addi a4, s9, 0 #set a4 to stride m1 col size
   
   jal ra, dot #cal dot function
   sw a0, 0(s6)   
   j inner_loop_end #increment inner loop

inner_loop_end:
   addi s8, s8, 1 #increase col counter by 1
   addi s6, s6, 4 #increase index of return array by 1
   add s10, s10, s11 #point to start of next col 
   j inner_loop_start #restart loop


outer_loop_end:
   addi s8, x0, 0 #set current col counter to 0
   addi s7, s7, 1 #increase row counter by 1
   add s0, s0, s5 #point to next row
   add s10, x0, s3 #point to first col
   j outer_loop_start #restart outer loop

end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11,44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52
    jr ra