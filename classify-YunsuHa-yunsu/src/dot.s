.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    addi t6 x0 1 #temporarily store 1
    blt a3 t6 j_exit37
    blt a4 t6 j_exit37
    # Prologue
    addi t3 a0 0 #stores the pointer of arr0 to t3
    addi t4 a1 0 #stores the pointer to arr1 to t4
    slli a3 a3 2 #left shifts the stride to multiply the value by 4
    slli a4 a4 2 #left shifts the stride to multiply the value by 4
    
    lw t0 0(a0) #loads the first value of a0 to t0
    lw t1 0(a1) #loads the first value of a1 to t1
    add t2 x0 x0 #counter of how many elements to use
    
    add t5 x0 x0 #the total product of the dot product

    bge a2 t6 loop_start #starts the loop if length of array is greater than or eq to 1
    li a0 36
    j exit
    
loop_start:
    bge t2 a2 loop_end #if the counter is equal to number of elements to use, end loop
    
    lw t0 0(t3) #assign t0 to the current value of arr0
    lw t1 0(t4) #assign t1 to the current value of arr1
    
    mul t6 t0 t1
    add t5 t5 t6
    j loop_continue
    
loop_continue:
    add t3 t3 a3 #advance arr0 by stride0 byte
    add t4 t4 a4 #advance arr1 by stride1 bytes
    addi t2 t2 1 #advance counter by 1
    j loop_start
    
j_exit37:
    li a0 37
    j exit

loop_end:


    # Epilogue

    mv a0 t5
    jr ra
