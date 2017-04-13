#203676945  Haim Gil

    .section	.rodata

scan_int:	.string "%d"
scan_str:	.string "%s\0"
scan_char: 	.string "%c"

	.text
###########################################################################
#Function name: main.
#Input: none
#Output: int.
#Function opartion: the function runs the program.
###########################################################################	
.globl main 				
	.type main, @function
main:

    pushq   %rbp	            	#Save the old frame pointer.
    movq    %rsp,%rbp           	#Create the new frame pointer.
	pushq 	%r12     				#Back up callee register.

#Scan p1 length.
	leaq	-4(%rsp), %rsp			#Resizing the stack by int.
	movq 	%rsp, %rsi 		        #Moving the rsp to 2-parameter.
	movq 	$scan_int, %rdi			#Moving the string scan to 1st parameter.
	movq 	$0, %rax		     	
	call	scanf 			        #Scaning the length of p1.
	movl	(%rsp),%r12d            #Put the length of p1 in r12.
    leaq     4(%rsp),%rsp           #Resizing the stack by 3.														

#Scan p1 string.
	subq	%r12, %rsp  			#Resizing the stack by length of p1.
	subq	$1, %rsp  				#Resizing the stack by 1 FOR \0.
	movq 	%rsp, %rsi  			#Moving the rsp to 2-parameter.
	movq 	$scan_str,%rdi          #Moving the string scan to 1st parameter.
	movq 	$0, %rax							
	call 	scanf 					#Scaning p1 string.

#Put p1 length at the start of p1.
	leaq 	-1(%rsp),%rsp			#Resizing the stack by char.
	movb 	%r12b, (%rsp)			#Put the length of p1 at the start of p1.

#Scan p2 length.
	leaq	-4(%rsp), %rsp			#Resizing the stack by int.
	movq 	%rsp, %rsi 		        #Moving the rsp to 2-parameter.
	movq 	$scan_int, %rdi			#Moving the string scan to 1st parameter.
	movq 	$0, %rax		     	
	call	scanf 			        #Scaning the length of p2.
	movl	(%rsp),%r12d            #Put the length of p2 in r12.
    leaq     4(%rsp),%rsp           #Resizing the stack by 3.														

#Scan p2 string.
	subq	%r12, %rsp  			#Resizing the stack by length of p2.
	subq	$1, %rsp  				#Resizing the stack by 1 FOR \0.
	movq 	%rsp, %rsi  			#Moving the rsp to 2-parameter.
	movq 	$scan_str,%rdi          #Moving the string scan to 1st parameter.
	movq 	$0, %rax							
	call 	scanf 					#Scaning p2 string.

#Put p2 length at the start of p2.
	leaq 	-1(%rsp),%rsp			#Resizing the stack by char.
	movb 	%r12b, (%rsp)			#Put the length of p2 at the start of p2.

#Scan number of mission.
	leaq	-4(%rsp), %rsp			#Resizing the stack by int.
	movq 	%rsp, %rsi 		        #Moving the rsp to 2-parameter.
	movq 	$scan_int, %rdi			#Moving the string scan to 1st parameter.
	movq 	$0, %rax				
	call	scanf 					#Scaning the number of mission.

#Calling run_func.
	movl	(%rsp),%edi 			#Moving the number of mission to 1-parameter.					
	leaq    4(%rsp),%rdx			#Moving p2 to 3-parameter.
	movq    %rdx, %r10				#Moving p2 to r10.
	leaq    2(%r12), %r11			#Moving p1 string to r11.
	leaq    (%r10,%r11), %r10		#Moving all p1 to r11.
	movq 	%r10, %rsi				#Moving p1 to 2-parameter.																						             														
	call 	run_func				#Calling the menu.

#Finish program.	
	movq    $0, %rax	     		#Return value is zero.
	leaq    -8(%rbp),%r12			#Resizing the stack to it original size.
	movq	%rbp,%rsp 		 	 	#Restore the old stack pointer-release all used memory.
	popq    %rbp		     		#restore the old frame pointer.
	ret				       			#Return to caller function (OS).	