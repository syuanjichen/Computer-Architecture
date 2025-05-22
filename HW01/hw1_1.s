.data
input: .word 7

.text
.global main

# This is 1132 CA Homework 1
# Implement fact(x) = 4*F(floor(n-1)/2) + 8n + 3 , where F(0)=4
# Input: n in a0(x10)
# Output: fact(n) in a0(x10)
# DO NOT MOTIFY "main" function

main:        
	# Load input into a0
	lw a0, input
	
	# Jump to fact   
	jal fact       

    # You should use ret or jalr x1 to jump back here after function complete
	# Exit program
    # System id for exit is 10 in Ripes, 93 in GEM5 !
    li a7, 10
    ecall

fact:
    # TODO #
    addi sp, sp, -16 # Allocate stack frame
    sw ra, 8(sp) # Save return address
    sw a0, 0(sp) # Save argument (n)

    addi t0, a0, -1 # t0 = n - 1
    bge t0, zero, recur

    # Base case: n <= 0 -> return 4
    addi a0, zero, 4
    addi sp, sp, 16
    jr x1

recur:
    srli t1, t0, 1 # t1 = floor((n-1)/2) e.g., n = 1, t1 = 0; n = 2, t1 = 0 
    bge t1, zero, nfact # If t1 > 0, run the recursive case

nfact:
    addi a0, a0, -1
    srli a0, a0, 1
    jal ra, fact # Recursive call: fact(floor((n-1/2))) 
    slli t2, a0, 2

    lw a0, 0(sp)
    add t3, zero, a0
    slli t3, t3, 3
    addi t3, t3, 3

    lw ra, 8(sp)
    addi sp, sp, 16

    add s0, t2, t3
    add a0, s0, zero
    ret