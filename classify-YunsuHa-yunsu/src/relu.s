.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi t0 a0 0 #creates t0 which points to the start of the a0 array
    add t1 x0 x0 #creates a counter to go through the array
    addi t2 x0 1 #temporary value for holding 1
    bge a1 t2 loop_start #if the length of the array is greater than or eq to 1 start the loop
    li a0 36
    j exit

loop_start:
    bge t1 a1 loop_end #if t1 is greater than length of array, loop_end
    lw t3 0(t0) #set t3 as the first value in t0
    
    bge t3 x0 loop_continue #if t3 is >= 0 continue the loop
    sw x0 0(t0) #set the first value of t0 as 0
    j loop_continue

loop_continue:
    addi t0 t0 4 #update t0 to point to the next byte
    addi t1 t1 1 #update the counter
    j loop_start


loop_end:
    

    # Epilogue


    jr ra
