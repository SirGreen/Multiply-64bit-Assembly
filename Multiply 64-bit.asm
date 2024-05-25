.data
	SoA: .asciiz "So A la: "
	SoB: .asciiz "So B la: "
	KetQua: .asciiz "Ket qua A x B = "
	endl: .asciiz "\n"
	ketqua_st: .asciiz "0x"
	ketqua_st_neg: .asciiz "-0x"
	hex_chars: .asciiz "0123456789ABCDEF"
	ketqua_hex: .space 16
	ketqua_int: .space 16
	ketqua: .space 16
	numA: .word 0x36B953EA 0xCB5ED140
	numB: .word 0x1D1C766D 0xC03047F8
	numAB: .space 16
	buffer: .asciiz "0123456789"
	array: .space 40
	dau_am: .asciiz "-"
	thapphan: .asciiz "Theo he thap phan: "
.text
main:
	#la $a1, numA
	lui $at, 0x1001
	ori $a1, $at, 0x70
	
	#la $a2, numB
	lui $at, 0x1001
	ori $a2, $at, 0x78
	
	#addi $v0, $zero, 41
	#syscall
	#sw $a0, 0($a1)
	#syscall
	#sw $a0, 4($a1)
	#syscall
	#sw $a0, 0($a2)
	#syscall
	#sw $a0, 4($a2)
		
	#Lay dau cua 2 thanh ghi:
	lw $t1, 0($a1)
	srl $k0, $t1, 31
	sll $t1, $t1, 1
	srl $t1, $t1, 1
	sw $t1, 0($a1)
	
	lw $t2, 0($a2)
	srl $k1, $a2, 31
	sll $t2, $t2, 1
	srl $t2, $t2, 1
	sw $t2, 0($a2)
	
	addi $v0, $zero, 4 #In so A
	#la $a0, SoA
	lui $at, 0x1001
	ori $a0, $at, 0x0
	syscall	
	bne $k0, $zero, am1 #Xac dinh so am hay duong de in dau '-'
	#la $a0, ketqua_st
	lui $at, 0x1001
	ori $a0, $at, 0x27
	syscall	
	j skip1
	am1:
	#la $a0, ketqua_st_neg
	lui $at, 0x1001
	ori $a0, $at, 0x2a
	syscall	
	skip1:
	add $a0, $zero, $a1
	jal bin_to_hex_string #Ham chuyen doi nhi phan sang chuoi Hex de xuat ra man hinh -> bin_to_hex_string
	#In ket qua xuat ra cua bin_to_hex_string
	add $a0, $zero, $v1
	syscall	
	#la $a0, endl
	lui $at, 0x1001
	ori $a0, $at, 0x25
	syscall
	
	#la $a0, SoB
	lui $at, 0x1001
	ori $a0, $at, 0xa
	syscall	
	bne $k1, $zero, am2  #Xac dinh so am hay duong de in dau '-'
	#la $a0, ketqua_st
	lui $at, 0x1001
	ori $a0, $at, 0x27
	syscall	
	j skip2
	am2:
	#la $a0, ketqua_st_neg
	lui $at, 0x1001
	ori $a0, $at, 0x2a
	syscall	
	skip2:
	add $a0, $zero, $a2
	jal bin_to_hex_string
	#In ket qua xuat ra cua bin_to_hex_string
	add $a0, $zero, $v1
	syscall	
	#la $a0, endl
	lui $at, 0x1001
	ori $a0, $at, 0x25
	syscall
	
	jal NhanAB #Thuc hien nhan A, B va Xuat cac gia tri can thiet
	add $t7, $v1, $zero
	
	addi $v0, $zero, 4 #In chu ket qua A, B va '0x' truoc so hex
	#la $a0, KetQua
	lui $at, 0x1001
	ori $a0, $at, 0x14
	syscall
	xor $k0, $k0, $k1 #Xac dinh dau ket qua
	bne $k0, $zero, am3
	#la $a0, ketqua_st
	lui $at, 0x1001
	ori $a0, $at, 0x27
	syscall
	j skip3
	am3:
	#la $a0, ketqua_st_neg
	lui $at, 0x1001
	ori $a0, $at, 0x2a
	syscall
	skip3:
	
	add $a0, $zero, $t7 #In 64 bit dau cua ket qua
	jal bin_to_hex_string
	addi $v0, $zero, 4
	#In ket qua xuat ra cua bin_to_hex_string
	add $a0, $zero, $v1
	syscall
	
	addi $t7, $t7, 8 #Dich con tro sang 64 bit cuoi
	add $a0, $zero, $t7 #In 64 bit cuoi cua ket qua
	jal bin_to_hex_string
	addi $v0, $zero, 4
	
	#la $a0, ketqua_hex
	add $a0, $zero, $v1
	syscall
	
	#la $a0, endl
	lui $at, 0x1001
	ori $a0, $at, 0x25
	syscall
	
	la $a0, thapphan
	syscall
	
	xor $k0, $k0, $k1 #Xac dinh dau ket qua
	bne $k0, $zero, am4
	j skip4
	am4:
	#la $a0, dau_am
	lui $at, 0x1001
	ori $a0, $at, 0xc3
	syscall
	skip4:
	
	#Dua bit dau vao chuong trinh
	#la $a0, numAB
	lui $at, 0x1001
	ori $a0, $at, 0x80
	lw $t0, 0($a0)
	sll $k0, $k0, 31
	or $t0, $t0, $k0
	sw $t0, 0($a0)
	
	jal bin128_to_decimal
	
	addi $v0, $zero, 10       #Thoat chuong trinh
        syscall    	

bin128_to_decimal:#Chuyen doi so 128-bit ve he thap phan
	#lw $t0, numAB
	lui $at, 0x1001
	lw $t0, 0x80($at)
	sll $t0, $t0, 1 #Bo bit dau truoc khi chuyen doi sang thap phan
	srl $t0, $t0, 1
	
	#lw $t1, numAB+4
	lui $at, 0x1001
	lw $t1, 0x84($at)
	
	#lw $t2, numAB+8
	lui $at, 0x1001
	lw $t2, 0x88($at)
	
	#lw $t3, numAB+12
	lui $at, 0x1001
	lw $t3, 0x8c($at) #Luu so 128-bit ve 4 register tu cao den thap: $t0, $t1, $t2, $t3
			
	addi $t9, $zero, 50 #Lap khoang 50 lan de dam bao khong bi lap vo han
	#la $t8, array
	lui $at, 0x1001
	ori $t8, $at, 0x9b #Dua dia chi ghi ket qua vao $t8
	#...
	addi $t7, $zero, 0 #Dem khi chuyen ra duoc bao nhieu so thap phan
	loop: 
	#divu $t0, $t0, 10
	addi $at, $zero, 0xa
	divu $t0, $at
	mflo $t0 #Chia 32-bit lon nhat cho 10
	
	mfhi $s0
	mflo $t4 #Lay phan nguyen va du
	
	sll $s0, $s0, 28 #Thuc hien dich chuyen cac bit trong register tiep theo de them vao phan du cua phep chia 32bit lon hon o truoc
	srl $s1, $t1, 4
	or $s0, $s0, $s1
	
	#divu $s0, $s0, 10
	addi $at, $zero, 0xa
	divu $s0, $at
	mflo $s0
	mfhi $s1 #Chia 32-bit tiep theo cho 10, lay phan nguyen va du
	
	sll $s1, $s1, 28  #Thuc hien dich chuyen cac bit trong register tiep theo de them vao phan du cua phep chia 32bit lon hon o truoc
	sll $s2, $t1, 28
	srl $s2, $s2, 4
	srl $s3, $t2, 8
	or $s3, $s3, $s1
	or $s3, $s3, $s2
	
	#divu $s3, $s3, 10
	addi $at, $zero, 0xa
	divu $s3, $at
	mflo $s3
	mfhi $s1 #Chia 32-bit tiep theo cho 10, lay phan nguyen va du
	
	sll $s1, $s1, 28  #Thuc hien dich chuyen cac bit trong register tiep theo de them vao phan du cua phep chia 32bit lon hon o truoc
	sll $s2, $t2, 24
	srl $s2, $s2, 4
	srl $s4, $t3, 12
	or $s4, $s4, $s1
	or $s4, $s4, $s2
	
	#divu $s4, $s4, 10
	addi $at, $zero, 0xa
	divu $s4, $at
	mflo $s4
	mfhi $s1 #Chia 32-bit tiep theo cho 10, lay phan nguyen va du
	
	sll $s1, $s1, 28  #Thuc hien dich chuyen cac bit trong register tiep theo de them vao phan du cua phep chia 32bit lon hon o truoc
	sll $s2, $t3, 20
	srl $s2, $s2, 4
	or $s5, $s1, $s2
	srl $s5, $s5, 16
	
	#divu $s5, $s5, 10
	addi $at, $zero, 0xa
	divu $s5, $at
	mflo $s5
	mfhi $s1 #Chia 32-bit cuoi cho 10, lay phan nguyen va du; phan du duoc them vao $s1
	
	#lb $s1, buffer($s1) 
	lui $at, 0x1001
	addu $at, $at, $s1
	lb $s1, 0x90($at)
	add $t6, $t7, $t8
	sb $s1, 0($t6)
	addi $t7, $t7,1 #Ta dung phan du so voi buffer[$s1] de tim so 0-9 trong bang ma ASCII va luu no vao o nho tai dia chi $t8
	
	move $t1, $s0 #Bat dau dich chuyen cac so sang trai de vua voi 4 registers ban dau vi khi chia cac bit da bi dich sang phai mot doan
	move $t2, $s3
	move $t3, $s4
	
	sll $t1, $t1, 4
	sll $t2, $t2, 4
	srl $s1, $t2, 28
	or $t1, $t1, $s1
	
	sll $t2, $t2, 4
	srl $s2, $t3, 20
	or $t2, $t2, $s2
	
	sll $t3, $t3, 12
	or $t3, $s5, $t3
	
	addi $t9, $t9, -1 #Giam vong lap di 1
	beqz $t9, exit #Neu het 50 vong lap thi ket thuc
	beqz $t3, exit #Neu khong con so de chia thi ket thuc
	j loop
	exit:
	
	addi $v0, $zero, 11 #In ki tu ra mang hinh
	loop2: #Bat dau vong lap in ki tu vua moi bo vao dia chi tai $t8
	addi $t7, $t7, -1 #Doc chuoi nguoi lai do khi tim so theo he thap phan ta tim tu so nho nhat truoc
	add $t6, $t7, $t8
	lb $a0, 0($t6)
	syscall
	beqz $t7, exit2 #$t7 la so luong so decimal, nen neu het t7 thi thoat khoi vong lap
	j loop2
	exit2:
	#or $s4, $s4, $s2
	 
	jr $ra

NhanAB: #Bat dau nhan 2 thanh ghi 64-bit
	#-----------------	
	#nhan fraction -> (t0: a) (t1: b) (t2: c) (t3: d)
	#x = a*2^32 + b
	#y = c*2^32 + d
	#x * y = 2^64*ac + 2^32*ad + 2^32*bc + bd
	lw $t0, 0($a1)
	lw $t1, 4($a1)
	lw $t2, 0($a2)
	lw $t3, 4($a2)
	
	multu $t0, $t2 
	mfhi $s0
	mflo $s1 #2^64 ac
	
	multu $t0, $t3
	mfhi $s2
	mflo $s3 #2^32 ad
	#...
	multu $t1, $t2
	mfhi $s4
	mflo $s5 #2^32 bc
	
	multu $t1, $t3
	mfhi $s6
	mflo $s7 #bd
	
	#Cong cac phan high va low cua tung phan sao cho phu hop
	addu $s3, $s3, $s5 #Cong low 2^32 ad va low 2^32 bc		
	#bgeu $s3, $s5, no_overflow3  # Neu khong co tran bit thi bo qua
	sltu $at, $s3, $s5
	beq $at, $zero, no_overflow3
	
	addi $s2, $s2, 1  # Cong 1 cho high 2^32 neu co tran bit
	no_overflow3:
	addu $s3, $s3, $s6 #Cong low 2^32 va high bd	
	#bgeu $s3, $s6, no_overflow4  
	sltu $at, $s3, $s6
	beq $at, $zero, no_overflow4
	
	
	addi $s2, $s2, 1  #Cong 1 cho high 2^32 neu co tran bit
	no_overflow4:	
	addu $s2, $s2, $s4 #Cong high 2^32 ad va high 2^32 bc
	#bgeu $s2, $s4, no_overflow1  
	sltu $at, $s2, $s4
	beq $at, $zero, no_overflow1
	
	addi $s0, $s0, 1  #Cong 1 cho high 2^64 neu tran bit
	no_overflow1:
	addu $s1, $s1, $s2 #Cong high 2^32 va low 2^64 ac
	#bgeu $s1, $s2, no_overflow2  
	sltu $at, $s1, $s2
	beq $at, $zero, no_overflow2
	
	addi $s0, $s0, 1  #Cong 1 cho high 2^64 neu tran bit
	no_overflow2: #Cac so ket qua nam trong 4 registers sau khi tinh toan theo thu tu tu lon nhat: $s0, $s1, $s3, $s7
	
	#la $v1, numAB
	lui $at, 0x1001
	ori $v1, $at, 0x80
	
	#luu ket qua phep nhan vao array ket qua
	sw $s0, 0($v1)
	sw $s1, 4($v1)
	sw $s3, 8($v1)
	sw $s7, 12($v1)
	
	jr $ra
	
bin_to_hex_string: #doi 64 bit tai dia chi luu trong $a0 thanh string tai ketqua_hex
	 # Dua vi tri luu ket qua vao $t1
    	#la $t1, ketqua_hex
	lui $at, 0x1001
	ori $t1, $at, 0x3f
	lw $t0, 0($a0) #Xu ly 32 bit dau
    	# Bat dau lap de chuyen doi
    	li $t2, 8   # moi register co 8 so hex, lap 8 lan
	convert_loop:
    		# Lay 4 bit lon nha cua $k0
    		#andi $t3, $t0, 0xF0000000
    		lui $at, 0xf000
    		ori $at, $at, 0x00000000
    		and $t3, $t0, $at
    		
		srl $t3, $t3, 28
    		# Su dung 4 bit nhu la index de tim ki tu hex tuong ung, nhu la hex_chars[$t3] trong C
    		#lb $t4, hex_chars($t3)
		lui $at, 0x1001
		addu $at, $at, $t3
		lb $t4, 0x2e($at)
		#...
    		# Luu so hex vao dia chi ket qua
    		sb $t4, 0($t1)

    		# Dich sang trai 4 bit de su ly 4 bit tiep theo
    		sll $t0, $t0, 4

    		# Dich sang ki tu tiep theo de luu trong dia chi luu ket qua
    		addi $t1, $t1, 1

    		# Giam bien dem vong lap xuong 1
    		addi $t2, $t2, -1

    		# Lap lai 8 lan
    		bnez $t2, convert_loop
	
	lw $t0, 4($a0)#Xu ly 32 bit cuoi
    	# Bat dau lap de chuyen doi
    	li $t2, 8   # moi register co 8 so hex, lap 8 lan
	convert_loop2:
    		# Lay 4 bit lon nha cua $k0
    		#andi $t3, $t0, 0xF0000000
    		lui $at, 0xf000
    		ori $at, $at, 0x00000000
    		and $t3, $t0, $at
    		
		srl $t3, $t3, 28
    		# Su dung 4 bit nhu la index de tim ki tu hex tuong ung, nhu la hex_chars[$t3] trong C
    		#lb $t4, hex_chars($t3)
		lui $at, 0x1001
		addu $at, $at, $t3
		lb $t4, 0x2e($at)
		
    		# Luu so hex vao dia chi ket qua
    		sb $t4, 0($t1)

    		# Dich sang trai 4 bit de su ly 4 bit tiep theo
    		sll $t0, $t0, 4

    		# Dich sang ki tu tiep theo de luu trong dia chi luu ket qua
    		addi $t1, $t1, 1

    		# Giam bien dem vong lap xuong 1
    		addi $t2, $t2, -1

    		# Lap lai 8 lan
    		bnez $t2, convert_loop2
    	# Them ki tu ket thuc vao string ket qua
    	li $t4, 0
    	sb $t4, 0($t1)
    	
    	la $v1, ketqua_hex
    	lui $at, 0x1001
    	ori $v1, $at, 0x3f
    	
    	jr $ra
	
	
        

