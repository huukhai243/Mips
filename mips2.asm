.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014
.text
main: li $t1, IN_ADDRESS_HEXA_KEYBOARD
 li $t2, OUT_ADDRESS_HEXA_KEYBOARD
 li $t3, 0x01 # check row 4 with key 0, 1, 2, 3
 li $t4, 0x02 # check row 4 with key 4-7
 li $t5, 0x04 # check row 4 with key 8-b
 li $t6, 0x08 # check row 4 with key c-f
polling:
 sb $t3, 0($t1 ) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
 bnez $a0, print
 
 sb $t4, 0($t1) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
 bnez $a0, print
 
 sb $t5, 0($t1 ) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
 bnez $a0, print
 
 sb $t6, 0($t1 ) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
 j print
 
print:
 li $v0, 34 # print integer (hexa)
 syscall
 
sleep:
 li $a0, 1000 # sleep 1s
 li $v0, 32
 syscall
 
back_to_polling: j polling # continue polling
