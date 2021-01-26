#Sri Khushi Surey
#Homework 4
#Bitmap display

#Instructions:
	#set pixel dimension to 4x4
	#set display dimension to 256x256
	#set Base address for display to be 0x10008000 ($gp)
	#keyboard shortcut w moves the colored box up
	#keyboard shortcut a moves the colored box left
	#keyboard shortcut s moves the colored box down
	#keyboard shortcut d moves the colored box right
	#keyboard shortcut space terminates the program
	#connect to MIPS before running
	#run

#constants
#width of screen in pixels = 256
#each pixel = 4. 256/4 = 64
#width 
.eqv	WIDTH	64			#64 pixels across
#height
.eqv	HEIGHT  64			#64 pixels up and down

#colors
.eqv	RED	0x00FF0000
.eqv	GREEN	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	WHITE	0x00FFFFFF
.eqv	YELLOW	0x00FFFF00
.eqv	CYAN	0x0000FFFF
.eqv	MAGENTA	0x00FF00FF
.eqv	BLACK	0x00000000

	.data
colors:	.word	MAGENTA, CYAN, YELLOW, WHITE, BLUE, GREEN, RED
	
	.text
main:
	li	$t5, 0				#offset for x coordinate	
	li	$t6, 0				#offset for y coordinate
	addi	$a0, $0, 28			#a0 is width
	addi	$a1, $0, 28			#a1 is height
	li	$t0, 0				#t0 = pixel iterator
	li	$t1, 0				#t1 = color iterator		
	li	$t3, 0				#t3= marquee iterator
	
loop:
	jal	drawbox				#drawing rainbow box	
	
moveup:	
	jal	Blackbox			#if w keyboard shortcut is clicked,		
	subi	$t6, $t6, 1			#moving y coorcinate by 1
	jal	drawbox				#drawing rainbow box back at the updated coordinates
	
movedown:
	jal	Blackbox			#if s keyboard shortcut is clicked,
	addi	$t6, $t6, 1			#moving y coorcinate by 1
	jal	drawbox				#drawing rainbow box back at the updated coordinates
	
moveleft:
	jal	Blackbox			#if a keyboard shortcut is clicked,
	subi	$t5, $t5, 1			#moving x coorcinate by 1
	jal	drawbox				#drawing rainbow box back at the updated coordinates
	
moveright:
	jal	Blackbox			#if a keyboard shortcut is clicked,
	addi	$t5, $t5, 1			#moving x coorcinate by 1
	jal	drawbox				#drawing rainbow box back at the updated coordinates
			
Blackbox:
	move	$t2,	$ra			#string return address at t2
	
blackHorizontal1:
	li	$a2, 0				#resetting color array
	
	jal	loop1				#drawing the pixel
	
	addi	$s0, $s0, 1			#incrementing black loop iterator
	addi	$a0, $a0, 1			#increasing width
	
	blt	$s0, 7, blackHorizontal1	#draw first black horizontal line
	li	$s0, 0				#resetting black loop iterator
blackVertical1:
	li	$a2, 0				#resetting color array

	jal	loop1				#drawing the pixel

	addi	$s0, $s0, 1			#incrementing black loop iterator
	addi	$a1, $a1, 1			#increasing width
	
	blt	$s0, 7, blackVertical1		#draw first black horizontal line
	li	$s0, 0				#resetting black loop iterator
	#j	blackHorizontal2
blackHorizontal2:
	li	$a2, 0				#resetting color array
	
	jal	loop1				#drawing the pixel
	
	addi	$s0, $s0, 1			#incrementing black loop iterator
	addi	$a0, $a0, -1			#increasing width
	
	blt	$s0, 7, blackHorizontal2	#draw first black horizontal line
	li	$s0, 0				#resetting black loop iterator
	#j	blackVertical2
blackVertical2:
	li	$a2, 0				#resetting color array
	
	jal	loop1				#drawing the pixel
		
	addi	$s0, $s0, 1			#incrementing black loop iterator
	addi	$a1, $a1, -1			#increasing width
	
	blt	$s0, 7, blackVertical2		#draw first black horizontal line
	li	$s0, 0				#resetting black loop iterator
	
	addi	$ra, $t2, 0			#moving contents of t2 back to return address
	jr	$ra				#jump back to return address
		
	
drawbox:
Horizontal1:
	sll	$a2, $t1, 2 				
	lw 	$a2, colors($a2)		#setting the color address to a2

	jal	loop1				#drawing the pixel
	
	addi	$t0, $t0, 1			#incrementing the pixel iterator
	addi	$t1, $t1, 1			#incrementing color iterator
	addi	$a0, $a0, 1			#incrementing width
	
	beq	$t0, 7, nextlp1			#if reached last pixel of line/side, jump to next loop
	bge	$t1,7, resetC1			#if color iterator is greater than max, reset and increment
	
	bge	$t3, 6, restartarray		#if reached 6, start marqueee 
	
	li 	$v0, 32				#syscall command to slow down marquee effect/pause
	li	$a3, 1				#by 1 milli second
	syscall
	      
	j	Horizontal1			#if not equal to max pixel, reloop
	
Vertical1:
	sll 	$a2, $t1, 2 
	lw 	$a2, colors($a2)		#setting the color address to a2
	
	jal	loop1				#drawing the pixel
	
	addi	$t0, $t0, 1			#incrementing the pixel iterator
	addi	$t1, $t1, 1			#incrementing color iterator
	addi	$a1, $a1, 1			#incrementing height
	
	beq	$t0, 7, nextlp2			#if reached last pixel of line/side, jump to next loop
	bge	$t1, 7, resetC2			#if color iterator is greater than max, reset and increment
	
	li 	$v0, 32				#syscall command to slow down marquee effect/pause
	li	$a3, 1				#by 1 milli second
	syscall
	      
	j	Vertical1			#if not equal to max pixel, reloop
	
Horizontal2:
	sll 	$a2, $t1, 2 
	lw   	$a2, colors($a2)
	jal	loop1				#drawing the pixel
	
	addi	$t0, $t0, 1			#incrementing the pixel iterator
	addi	$t1, $t1, 1			#incrementing color iterator
	subi	$a0, $a0, 1			#decrementing width
	
	beq	$t0, 7, nextlp3			#if reached last pixel of line/side, jump to next loop
	bge	$t1, 7, resetC3			#if color iterator is greater than max, reset and increment
	
	li 	$v0, 32				#syscall command to slow down marquee effect/pause
	li	$a3, 1				#by 1 milli second
	syscall
	      
	j	Horizontal2			#if not equal to max pixel, reloop
	
	
Vertical2:
	sll 	$a2, $t1, 2
	lw 	$a2, colors($a2)
	jal	loop1				#drawing the pixel
	
	addi	$t0, $t0, 1			#incrementing the pixel iterator
	addi	$t1, $t1, 1			#incrementing color iterator
	subi	$a1, $a1, 1			#decrementing height
	
	beq	$t0, 7, nextlp4			#if reached last pixel of line/side, jump to next loop
	bge	$t1, 7, resetC4			#if color iterator is greater than max, reset and increment
	
	li 	$v0, 32				#syscall command to slow down marquee effect/pause
	li	$a3, 1				#by 1 milli second
	syscall
	      
	j 	Vertical2			#if not equal to max pixel, reloop
	
nextlp1:
	li	$t0, 0				#resetting oixel iterator to 0
	addi	$t3, $t3, 1			#incrementing marquee index
	move	$t1, $t3			#moving marquee index to t1 to loop through
	j	Vertical1			#jumping to next loop

nextlp2: 
	li	$t0, 0				#resetting oixel iterator to 0
	move	$t1, $t3			#moving marquee index to t1 to loop through	
	j	Horizontal2			#jumping to next loop

nextlp3:
	li	$t0, 0				#resetting oixel iterator to 0
	move	$t1, $t3			#moving marquee index to t1 to loop through
	j	Vertical2			#jumping to next loop
	
nextlp4:
	li	$t0, 0				#resetting oixel iterator to 0
	move	$t1, $t3			#moving marquee index to t1 to loop through
	
	
######	
	lw	$t7,  0xffff0000	
	beq	$t7,  0, loop			#if no input found, continue through loop
	

	lw	$s2, 0xffff0004			#invrementing coordinates
	beq	$s2, 32, exit			# input space, exit
	beq	$s2, 119, moveup 		# input w
	beq	$s2, 115, movedown 		# input s
	beq	$s2, 97, moveleft  		# input a
	beq	$s2, 100, moveright		# input d
	
	j	Horizontal1			#jump back to Horizontal 1 and continue drawing required box
	
restartarray:
	li	$t3, 0				#resettin marquee iterator
	j	Horizontal1			#redrawing box with current 

resetC1:
	li	$t1, 0				#resetting pixel iterator to 0
	j	Horizontal1			#continuing through loops to redraw box

resetC2:
	li	$t1, 0				#resetting pixel iterator to 0
	j	Vertical1			#continuing to next loop to continue

resetC3:
	li	$t1, 0				#resetting pixel iterator to 0
	j	Horizontal2			#continuing to next loop to continue

resetC4:
	li	$t1, 0				#resetting pixel iterator to 0
	j	Vertical2			#continuing to next loop to continue

loop1:
	# s1 = address = $gp + 4*(x + y*width)
	add	$t9, $a1, $t6
	mul	$s1, $t9, WIDTH		  # y * WIDTH
	add	$t8, $a0, $t5
	add	$s1, $s1, $t8		  # add X		  
	mul	$s1, $s1, 4		  # multiply by 4 to get word offset				  
	add	$s1, $s1, $gp		  # add to base address	 
	sw	$a2, 0($s1)		  # store color at memory location	  
	jr 	$ra

exit: 	li	$v0, 10
	syscall
