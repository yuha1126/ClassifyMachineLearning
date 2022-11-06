.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    addi t0 a0 0 #makes a copy of a0
    add t1 x0 x0 #initializes t1 as the counter
    add t5 x0 x0 #initializes t5 as the max counter
    lw  t2 0(a0) #initializes t2 as the first value of the array.

    addi t4 x0 1 #t3 = temporary value storing 1
    bge a1 t4 loop_start #start the loop
    li a0 36
    j exit
    
loop_start:
    bge t1 a1 loop_end #if the counter exceeds or is equal to the lenght of the array end loop
    lw t3 0(t0) #set t3 as the first 
    bge t2 t3 loop_continue #continue the loop if t3 is not the highest value so far
    mv t2 t3 #set t2
    mv t5 t1 #sets a0 as the new highest index 
    j loop_continue

loop_continue:
    addi t1 t1 1 #advance the counter
    addi t0 t0 4 #update the pointer to the next byte
    j loop_start #jump back to the start of loop

loop_end:
    # Epilogue
    mv a0 t5
    jr ra
