.data
list: .word 3, 6, -2, -5, 7, 3
size: .word 6

.text
la $t1, list # get array address
lw $t2, size
subi $t2, $t2,1 # only run to array size-1
li $t3, 0 # counter
li $t4, -2147483648 #max

loop:
beq $t2, $t3, loop_end # check for array end
lw $t5, ($t1) # load element
lw $t6, 4($t1) # load adj. elem.
mul $t5, $t5, $t6
ble $t4, $t5, change_max
continue_loop:
addi $t3, $t3, 1 # advance loop counter
addi $t1, $t1, 4 # advance array pointer
j loop # repeat the loop

change_max:
move $t4, $t5
j continue_loop


loop_end:
move $a0, $t4
li $v0, 1
syscall