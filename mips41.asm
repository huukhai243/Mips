.eqv ENDLINE 0x0a
.data

msg1:	        .asciiz	"Enter string: "
msg2:	        .asciiz	"Enter substring: "
msg3:		.asciiz	"Is case sensitive: "
foundMsg:	.asciiz "FOUND AT: "
seperator:	.asciiz ", "
notFoundMsg:	.asciiz "NOT FOUND!"
MTStrError:	.asciiz "String is empty, try again: "

strMain:	.space	200
strSub:		.space	200


.text
.globl FindSubStr

FindSubStr:
    li $v0, 4
    la $a0, msg1
    syscall
typeMainStr:
    li $v0, 8
    la $a0, strMain
    li $a1, 199
    syscall
    la $a0, strMain
    jal findLengthString
    move $s0, $v0
    bnez $s0, inputSubStr
    li $v0, 4
    la $a0, MTStrError
    syscall
    j typeMainStr
    
inputSubStr:
    li $v0, 4
    la $a0, msg2
    syscall
typeSubStr:
    li $v0, 8
    la $a0, strSub
    li $a1, 199
    syscall
    la $a0, strSub
    jal findLengthString
    move $s1, $v0
    bnez $s1, chooseSearchType
    li $v0, 4
    la $a0, MTStrError
    syscall
    j typeSubStr
    
chooseSearchType:
    li $v0, 50
    la $a0, msg3
    syscall
    move $s2, $a0
    beq $s2, 2, exit

    la $a0, strMain
    la $a1, strSub
    sub $a2, $s0, $s1
    move $a3, $s1	# N=N-M

    jal subStringMatch
    bgtz $v0, exit
    
    notFound:
    li $v0, 4
    la $a0, notFoundMsg
    syscall
 
exit:
    li $v0, 10
    syscall


findLengthString:
    IntSR:
        addi $sp, $sp, 4	# Save $t0 because we may change it later
        sw $t0, 0($sp)
        
    li $v0, 0	# result
    
loop_fls:
        lb $t0, 0($a0)
        beq $t0, ENDLINE, returnLength

        addi $v0, $v0, 1
        addi $a0, $a0, 1
        j loop_fls

returnLength:
        restore:
            lw $t0, 0($sp)	# Restore the registers from stack
            addi $sp, $sp, -4
        jr $ra


subStringMatch:
    li $v0, 0	# result
    li $t0, 0	# i
    loopI:
        bgt $t0, $a2, loopIdone
        li $t1, 0	# j
        loopJ:
            bge $t1, $a3, loopJdone	# contain
            add $t2, $a0, $t1
            lb $t2, 0($t2)		# a[i+j]
            add $t3, $a1, $t1
            lb $t3, 0($t3)		# b[j]
            
            beqz $s2, noLowerB
            
            blt $t2, 65, noLowerA
            bgt $t2, 90, noLowerA
            addi $t2, $t2, 32

            noLowerA:
            blt $t3, 65, noLowerB
            bgt $t3, 90, noLowerB
            addi $t3, $t3, 32
 
            noLowerB:
            bne $t2, $t3, continue_i	# if a[i + j] != b[j]
     
            addi $t1, $t1, 1
            j loopJ
        loopJdone:
            addi $t2, $v0, 1
            move $t3, $a0
            beqz $v0, printResult
            
            la $a0, seperator
            li $v0, 4
            syscall
            j printIndex
            
            printResult:
            la $a0, foundMsg
            li $v0, 4
            syscall
            
        printIndex:
            move $a0, $t0
            li $v0, 1
            syscall
     
            move $v0, $t2
            move $a0, $t3
            j continue_i
    continue_i:
        addi $t0, $t0, 1
        addi $a0, $a0, 1 # a[i]
        j loopI
    loopIdone:
        jr $ra

