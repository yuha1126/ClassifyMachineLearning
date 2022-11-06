.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -40
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)

    addi s0 a0 0 #copy the original value of a0 to s0
    addi s1 a1 0
    addi s2 a2 0 #copy the number of rows to s2
    addi s3 a3 0 #copy the number of columns to s3
    addi s6 ra 0 #save the return address to s6
    
    addi a1 x0 1 #Set the permission variable temporarily
    
    jal ra fopen
    
    addi t0 x0 -1 
    beq a0 t0 error_fopen
    
    sw s2 32(sp) #save this to add the row values as the first value in the file
    sw s3 36(sp) #save this to add the col values as the second value in the file
    addi s4 a0 0 #set s4 as the filename
    addi a1 sp 32
    addi a2 x0 2
    addi a3 x0 4 
    addi s5 a2 0 #set s5 as the expected number of elements to write into file
    
    jal ra fwrite
    bne s5 a0 error_fwrite
    
    addi a0 s4 0
    addi a1 s1 0
    mul a2 s2 s3 #multiply s2 and s3 to get the expected number of elements
    addi a3 x0 4 
    addi s5 a2 0
    
    jal ra fwrite    
    bne s5 a0 error_fwrite
      
    addi a0 s4 0
    jal ra fclose
    bne a0 x0 error_fclose


    # Epilogue
    lw s6 28(sp)
    lw s5 24(sp)
    lw s4 20(sp)
    lw s3 16(sp)
    lw s2 12(sp)
    lw s1 8(sp)
    lw s0 4(sp)
    lw ra 0(sp)
    addi sp sp 40

    jr ra


error_fopen:
    addi a0 x0 27
	j exit
    
error_fclose:
    addi a0 x0 28
    j exit
    
error_fwrite:
    addi a0 x0 30
    j exit