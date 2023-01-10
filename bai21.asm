.data
str1: .asciiz "n = '
str2: .asciiz "Hay nhap n la so nguyen duong. n = '
str3: .asciiz "digitDegree(n) = '
Message: .space 100
.text
main:
			li $s6,1		#Gan s6 chua gia tri dung sai cua so lieu da nhap
			li $v0,4		#Gan thanh ghi v0 = 4			
			la $a0,str1		#Dua dia chi bien str1 vao thanh ghi a0
			syscall			#In ra so nguyen n
			
			li $v0,8
			la $a0,Message
			li $a1,100
			syscall			#Nhap gia tri n
			
			jal Check		#Kiem tra da nhap dung chua
			nop
			add $s0,$zero,$s7	#Luu gia tri n vao $s0(duoi ham Check, check xong neu dung se luu gia tri vao s7)
			add $t2,$zero,$s0	#t2=s0=n
			add $t5,$zero,$zero	#sum=t5=0	
			add $t6,$zero,$zero	#dem so lan cong tong			
			blt $t2,10, end_main	#Neu so da nhap la so co mot chu so thi ket qua la 0
			j L

end_main:		li $v0,4		
			la $a0,str3	
			syscall			#In xau str3
			li $v0,1
			add $a0,$t6,$zero	#a0=count
			syscall			#Dua ra ket qua

Quit:			li $v0,10
			syscall			#Thoat
Check: 	
 			li $t0,0		#i=0
 			li $s2,10		#s2=10
 			li $s3,57		#s3='9'
 			li $s4,48		#s4='0'
 			li $s7,0		#s7=0

check_char: 	
			add $t1, $a0, $t0 		#t1=a0+t0
							#=Address(string[0]+i)
 			lb $t2,0($t1) 			#t2=string[i]
 			lb $t3,1($t1)			#t3=string[i+1]
			beq $t3,$zero,end_of_check 	#t3='\n'?
			sle $t4,$t2,$s3			#t2<=s3 thi t4=1, nguoc lai t2>s3 thi t4=0
			sge $t5,$t2,$s4			#t2>=s4 thi t5=1, nguoc lai t2<s4 thi t5=0
			and $t6,$t5,$t4			#t6=1 neu t2 la ki tu trong khoang '0' den '9' va t6=0 neu nguoc lai
			beqz $t6,Error			#Neu t6=0 thi xau da nhap khong phai so nguyen, nhay den ham Error
			sub $t2,$t2,$s4			#Chuyen ki tu t2 thanh so nguyen
			multu $s7,$s2			
			mflo $t7			#t7=s7*10
			add $s7,$t7,$t2			#s7=s7*10+t2
 			addi $t0, $t0, 1 		#t0=t0+1->i = i + 1
			j check_char			#Kiem tra ki tu tiep theo

end_of_check:		add $s6,$s7,$zero		#Dua gia tri s7 vao s6
			beqz $s6,Error			#Neu s6=0 thi xau da nhap khong phai so nguyen, nhay den ham Error
			jr $ra				#Tro ve

Error:			
			li $v0,4
			la $a0,str2
			syscall				#In xau str2
			li $s6,0			#s6=0
			j main				#Neu loi, nhap lai n
			
			
L:			add $t5,$zero,$zero		#sum=t5=0
L1:			div $t3, $t2,10			#Phep chia so nguyen t3=t2/10
			mflo $t2			#Dua phan nguyen vao t2 (t2=n/10)
			mfhi $t4			#dua phan du vao t4 (t4=n%10)
			add $t5,$t4,$t5			#sum=sum+t4
			bnez $t2, L1			#Neu n khac 0 (van chua cong du cac chu so) lap lai vong lap L1
end_L1:			add $t6,$t6,1
			blt $t5,10,end_main		#Neu sum la so co 1 chu so thi do la ket qua
			add $t2,$t5,$zero		#Neu khong thi thay n=sum 
			j L				#Quay lai L
