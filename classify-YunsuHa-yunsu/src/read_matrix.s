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
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -44
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)
    sw s8 36(sp)
    sw s9 40(sp)
    
    addi s0 a0 0 #copy the filename pointer to a0    
    addi s1 a1 0 #copy the num row pointer to s1
    addi s2 a2 0 #copy the num col pointer to s2
    
    addi a1 x0 0 #temporarily set a1 to the 0 permission bit for fopen
        
    jal ra fopen #opens the file with the file name stored by a0; sets a0 as the file descriptor
    
    addi t0 x0 -1 #temporarily set t0 to -1 for error checking
    beq a0 t0 error_fopen
    
    addi s3 a0 0
    addi a0 x0 8
    
    jal ra malloc #checks for malloc
    beq a0 x0 error_malloc
    
    addi s4 a0 0
    addi a1 s4 0
    addi a0 s3 0
    addi a2 x0 8
    addi s5 a2 0
    
    jal ra fread
    bne s5 a0 error_fread
    
    lw s6 0(s4)
    lw s7 4(s4)
    
    sw s6 0(s1)
    sw s7 0(s2) 
    
    mul s6 s6 s7
    addi t0 x0 4
    mul s6 s6 t0
    addi a0 s6 0
    
    jal ra malloc
    
    beq a0 x0 error_malloc
    
    addi s4 a0 0
    addi a1 s4 0
    addi a0 s3 0
    addi a2 s6 0
    
    jal ra fread
    bne s6 a0 error_fread
    
    addi a0 s3 0
    
    jal ra fclose
    
    bne a0 x0 error_fclose
    
    addi a1 s1 0
    addi a2 s2 0
    addi a0 s4 0

    # Epilogue
    lw s9 40(sp)
    lw s8 36(sp)
    lw s7 32(sp)
    lw s6 28(sp)
    lw s5 24(sp)
    lw s4 20(sp)
    lw s3 16(sp)
    lw s2 12(sp)
    lw s1 8(sp)
    lw s0 4(sp)
    lw ra 0(sp)
    addi sp sp 44

    jr ra

error_malloc:
    addi a0 x0 26
  	j exit
    
error_fopen:
    addi a0 x0 27
	j exit
    
error_fclose:
	addi a0 x0 28
    j exit
      
error_fread:
	addi a0 x0 29
	j exit
   