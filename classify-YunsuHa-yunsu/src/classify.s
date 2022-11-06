.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    #Prolouge
    ebreak
    addi sp, sp, -56
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
    sw s11, 48(sp)
    
    addi t0, x0, 5
    beq a0, t0, continue
    addi a0, x0, 31
    j exit
   
    continue:
    sw a2, 52(sp)
    addi, s1, a1, 0 #s1 points to args pointer
        

    # Read pretrained m0 (stored in s0)
    addi a0, x0, 4
    jal ra, malloc
    beq a0, x0, malloc_error
    addi s2, a0, 0 #s2 pointes to rows in m0
    addi a0, x0, 4
    jal ra, malloc
    beq a0, x0, malloc_error 
    addi s3, a0, 0 #s3 points to cols in m0
    lw a0, 4(s1)
    addi a1, s2, 0
    addi a2, s3, 0
    ebreak
    jal ra, read_matrix
    addi s0, a0, 0 #stores m0 in s0
    
    # Read pretrained m1 (stored in s4)
    addi a0, x0, 4
    jal ra, malloc
    beq a0, x0, malloc_error
    addi s5, a0, 0 #s5 points to rows in m1
    addi a0, x0, 4
    jal ra, malloc 
    beq a0, x0, malloc_error
    addi s6, a0, 0 #s6 points to cols in m1
    lw a0, 8(s1)
    addi a1, s5, 0
    addi a2, s6, 0
    ebreak
    jal ra, read_matrix
    addi s4, a0, 0 #stores m1 in s4

    # Read input matrix (stored in s7)
    addi a0, x0, 4
    jal ra, malloc
    beq a0, x0, malloc_error
    addi s8, a0, 0 #s8 points to rows in input matrix
    addi a0, x0, 4
    jal ra, malloc
    beq a0, x0, malloc_error
    addi s9, a0, 0 #s9 points to cols in input matrix
    lw a0, 12(s1)
    addi a1, s8, 0
    addi a2, s9, 0
    ebreak
    jal ra, read_matrix
    addi s7, a0, 0 #stores input in s7
     
    # Compute h = matmul(m0, input) (stored in s10)
    addi t0, x0, 4
    lw t1, 0(s2)
    lw t2, 0(s9)
    mul a0, t1, t2
    mul a0, a0, t0
    jal ra, malloc
    beq a0, x0, malloc_error
    addi s10, a0, 0
    addi a0, s0, 0
    lw a1, 0(s2)
    lw a2, 0(s3)
    addi a3, s7, 0
    lw a4, 0(s8)
    lw a5, 0(s9)
    addi a6, s10, 0
    jal ra, matmul

    # Compute h = relu(h)
     addi a0, s10, 0
     lw t0, 0(s2)
     lw t1, 0(s9)
     mul a1, t0, t1
     jal ra, relu   

    # Compute o = matmul(m1, h)
    addi t0, x0, 4
    lw t1, 0(s5)
    lw t2, 0(s9)
    mul a0, t1, t2
    mul a0, a0, t0
    jal ra, malloc
    beq a0, x0, malloc_error
    addi s11, a0, 0
    addi a0, s4, 0
    lw a1, 0(s5)
    lw a2, 0(s6)
    addi a3, s10, 0
    lw a4, 0(s2)
    lw a5, 0(s9)
    addi a6, s11, 0
    jal ra, matmul

    # Write output matrix o
    lw a0, 16(s1)
    addi a1, s11, 0
    lw a2, 0(s5)
    lw a3, 0(s9)
    ebreak
    jal ra, write_matrix    
 
    # Compute and return argmax(o)
    addi a0, s11, 0
    lw t0, 0(s5)
    lw t1, 0(s9)
    mul t0, t0, t1
    addi a1, t0, 0
    jal ra, argmax
    addi s1, a0, 0
    j skip  
  
    malloc_error:
    	addi a0, x0, 26
        j exit
    
    skip:
    # If enabled, print argmax(o) and newline
    lw t1, 52(sp)
    bne t1, x0, finish
    addi a0, s1, 0
    jal ra, print_int
    li a0, '\n'
    jal ra, print_char
         
    finish:
    addi a0, s0, 0
    jal ra, free
    addi a0, s2, 0
    jal ra, free
    addi a0, s3, 0
    jal ra, free
    addi a0, s4, 0
    jal ra, free
    addi a0, s5, 0
    jal ra, free
    addi a0, s6, 0
    jal ra, free
    addi a0, s7, 0
    jal ra, free
    addi a0, s8, 0
    jal ra, free
    addi a0, s9, 0
    jal ra, free
    addi a0, s10, 0
    jal ra, free
    addi a0, s11, 0
    jal ra, free
    addi a0, s1, 0 
   
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    lw a1, 52(sp)
    addi sp, sp 56
      
    jr ra