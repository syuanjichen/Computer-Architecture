.data
n:      .word 8                        # sequence length
nums:   .word 4, 5, 1, 8, 3, 6, 9 ,2    # input sequence
dp:     .word 0, 0, 0, 0, 0, 0, 0, 0, 0   # dp array


.text
.globl main

# This is 1132 CA Homework 1 Problem 2
# Implement Longest Increasing Subsequence Algorithm
# Input: 
#       sequence length (n) store in a0
#       address of sequence store in a1
#       address of dp array with length n store in a2 (we can decide to use or not)        
# Output: Length of Longest Increasing Subsequenc in a0(x10)

# DO NOT MODIFY "main" FUNCTION !!!

main:

    lw a0, n          # a0 = n
    la a1, nums       # a1 = &nums[0]
    la a2, dp         # a2 = &dp[0] 
      
    jal LIS         # Jump to LIS algorithm
    
    # You should use ret or jalr x1 to jump back after algorithm complete
    # Exit program
    # System id for exit is 10 in Ripes, 93 in GEM5 
    li a7, 10
    ecall

LIS:
    # TODO #
    addi t0, zero, 0 # i in the pseudocode
    addi t1, zero, 0 # j in the pseudocode
    
    initialize:
        blt a0, t0, end_initialize # i from 0 to n
        slli t2, t0, 2
        add t3, a2, t2
        lw t4, 0(t3)
        addi t4, zero, 1
        sw t4, 0(t3)
        addi t0, t0, 1
        j initialize
    end_initialize:
    
    addi t0, zero, 0 # reset i

    loop_i:
        bge t0, a0, end_loop_i # 1 <= i < n
        addi t1, zero, 0 # reset j
        loop_j:
            bge t1, t0, end_loop_j # 0 <= j < i
            slli t2, t0, 2
            add t3, a1, t2 # t3 = offset i
            lw t4, 0(t3) # t4 = A[i]
            slli t5, t1, 2
            add t3, a1, t5 # t3 = offset j
            lw t6, 0(t3) # t6 = A[j]
            bge t6, t4, maintain # if A[j] < A[i]
                add s0, a2, t2
                lw s1, 0(s0) # dp[i]
                add s2, a2, t5
                lw s3, 0(s2) # dp[j]
                addi s3, s3, 1 # dp[j] + 1
                bge s1, s3, keep_dp # if dp[i] < dp[j] + 1
                    sw s3, 0(s0) # dp[i] = dp[j] + 1
                keep_dp:
            maintain:
            addi t1, t1, 1
            j loop_j
        end_loop_j:
        addi t0, t0, 1
        j loop_i
    end_loop_i:

    addi t0, zero, 0 # reset i
    lw s4, 0(a2) # dp[0]

    find_result:
        bge t0, a0, end_find_result
        slli t5, t0, 2
        add t3, a2, t5 # t3 = offset i
        lw s5, 0(t3) # t4 = dp[i]
        bge s4, s5, find_next
            addi s4, s5, 0
        find_next:
        addi t0, t0, 1
        j find_result
    end_find_result:
    addi a0, s4, 0
    ret