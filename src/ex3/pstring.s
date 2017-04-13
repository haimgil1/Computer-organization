#203676945  Haim Gil

    .section	.rodata

invalidInputMsg:    .string "invalid input!\n"

    .text
###########################################################################
#Function name: pstrlen.
#Input: Pstring* pstr.
#Output: int.
#Function opartion: the function retturn the length of pstr.
###########################################################################
.globl  pstrlen
        .type   pstrlen,   @function
pstrlen:
        movzbq	%dil,%rax			#Get the first address in pstring.
        ret

###########################################################################
#Function name: replaceChar.
#Input: Pstring* pstr, char oldChar, char newChar.
#Output: Pstring* pstr.
#Function opartion: the function replace any old char in pstr
#by new char.
###########################################################################
.globl  replaceChar
        .type   replaceChar,   @function
replaceChar:
        movq  	%rdi,%rcx			#Saving pstring in rcx.
		movq 	%rcx,%r10			#Back up pstring in r10.
        movzbq	%cl,%r11			#Saving the length in counter.
        incq	%rcx				#Ignoring the length.

        cmp 	$0, %r11			#Checking if length >0.
        jle .ENDREPLACE
        jmp .LOOP

.LOOP:								#Loop label.
	movb 	(%r10),%al				#Geting the first char in pstring.
	cmpb	%sil,%al				#Comparing the current char with old char.
	je .EQUAL
	jmp .NEXT

.EQUAL:								#Changing the old char with new char.
	movb 	%dl,(%r10)				#Replace new char with old char.
	jmp .NEXT						#Checking the next char.

.NEXT:
	incq	%r10					#Nect char.
	decq	%r11					#Counter--.
    jns .LOOP 						#Checking if length >0.
    jmp .ENDREPLACE

.ENDREPLACE:
	movq 	%rcx,%rax				#Saving the new pstring in return value.
    ret

###########################################################################
#Function name: pstrijcpy.
#Input: Pstring* dst, Pstring* src, char i, char j.
#Output: Pstring* pstr.
#Function opartion: the function copy any p2->str[i:j] into p1->str[i:j].
#Note: In case i/j is negative or bigger than p1/p2 length, the function
#will return p1 with no change.
###########################################################################
.globl  pstrijcpy
        .type   pstrijcpy,   @function
pstrijcpy:

		movq 	%rdi,%r12			#Back up pstring in r12.
        
		call	validInput			#Call input valid.
		cmpq 	$(-2),%rax			#return -2 if not valid.
		je 	.ENDNOTVALID1

		movzbq	%dl,%r9				#Saving i index in r9.
		movzbq	%cl,%r10			#Saving j index in r10.	
		movq  	%rdi,%rax			#Saving p1 in rax.
		movq 	%rsi,%r8 			#Saving p2 in r8.

		incq	%r12				#Ignoring the length in p1.
		incq	%r8 				#Ignoring the length in p2.

		xorq 	%r11,%r11			#counter = 0.
		jmp .CHECKIINDEX

.CHECKIINDEX:		
		cmpq	%r9,%r11			#Checkeing if i got to counter.
		jge .COPY					#Start copy.
		jmp .LOOPIINDEX				#Go to next char.

.LOOPIINDEX:						#Loop label.
		incq	%r12				#Go to the next char.
		incq	%r8					#Go to the next char.
		incq	%r11				#Counter++.
		jmp .CHECKIINDEX

.COPY:
		movb 	(%r8),%dl 			#Save char from p2 to rdx.
		movb 	%dl,(%r12)			#Save char from rdx to p1. (Can't do it in one step)
		incq	%r12				#Go to the next char in p1.
		incq	%r8					#Go to the next char in p2.
		incq	%r11				#Counter++.		
		jmp .CHECKJINDEX

.CHECKJINDEX:		
		cmpq	%r10,%r11			#Checkeing if i got to counter.
		jg .ENDCOPY
		jmp .COPY

.ENDCOPY:
    	ret

.ENDNOTVALID1:
   		movq  	%r12,%rax				 #Saving p1 in rax.
   		ret

###########################################################################
#Function name: swapCase.
#Input: Pstring* pstr.
#Output: Pstring* pstr.
#Function opartion: the function swap any little letter to big letter and
# any big letter to little. 
#Note: In case there is a char that isn't a letter, it will stay the same.
###########################################################################
.globl  swapCase
        .type   swapCase,   @function
swapCase:
        movq  	%rdi,%rcx			#Saving pstring in rcx.
		movq 	%rcx,%r10			#Back up pstring in r10.
        movzbq	%cl,%r11			#Saving the length in counter.
        incq	%rcx				#Ignoring the length.

        cmp 	$0, %r11			#Checking if length >0.
        jle .ENDSWAP
        jmp .LOOPSWAP

.LOOPSWAP:
		movb 	(%r10),%al			#Geting the first char in pstring.
		cmpb	$65,%al				#Check if the current char is a letter by asci table.
		jl .NEXTCHAR				#Less than smallest letter.	
		cmpb	$90,%al				#If its less/equal- its big letter.
		jg .ISLITTLE

		addq 	$32,(%r10)			#Change to littel letter.
		jmp .NEXTCHAR

.NEXTCHAR:
		incq	%r10				#Nect char.
		decq	%r11				#Counter--.
    	jns .LOOPSWAP 				#Checking if length >0.
    	jmp .ENDSWAP

.ISLITTLE:    
		cmpb	$97,%al 			#Check if the current char is a big letter by asci table. 
		jl .NEXTCHAR
		cmpb	$122,%al			#More than the biggest letter.
		jg .NEXTCHAR
		subq 	$32,(%r10)			#Change to big letter.
		jmp .NEXTCHAR

.ENDSWAP:
		decq	%rcx					#Return the length.
		movq 	%rcx,%rax				#Saving the new pstring in return value.
		ret

##########################################################################################
#Function name: pstrijcmp.
#Input: Pstring* dst, Pstring* src, char i, char j.
#Output: Pstring* pstr.
#Function opartion: the function compare any p2->str[i:j] with p1->str[i:j].
#The function will return 1 if p1 is bigger, -1 if p2 is bigger and 0 otherwise.
#Note: In case i/j is negative or bigger than p1/p2 length, the function
#will return -2.
##########################################################################################
.globl  pstrijcmp
        .type   pstrijcmp,   @function
pstrijcmp:

		movq 	%rdi,%r12			#Back up pstring in r12.
        
		call	validInput			#Call valid input.
		cmpq 	$(-2),%rax			#return -2 if not valid.
		je 	.ENDNOTVALID

		movzbq	%dl,%r9				#Saving i index in r9.
		movzbq	%cl,%r10			#Saving j index in r10.	
		movq  	%rdi,%rax			#Saving p1 in rax.
		movq 	%rsi,%r8 			#Saving p2 in r8.

		incq	%r12				#Ignoring the length in p1.
		incq	%r8 				#Ignoring the length in p2.

		xorq 	%r11,%r11			#counter = 0.
		jmp .CHECKIINDEX1

.CHECKIINDEX1:		
		cmpq	%r9,%r11			#Checkeing if i got to counter.
		jge .CMP					#Start compare.
		jmp .LOOPIINDEX1			#Go to next char.

.LOOPIINDEX1:						
		incq	%r12				#Go to the next char in p1.
		incq	%r8					#Go to the next char in p2.
		incq	%r11				#Counter++.
		jmp .CHECKIINDEX1

.CMP:
		movb 	(%r8),%dl 			#Save char from p2 to rdx.
		movb 	(%r12),%cl 			#Save char from p1 to rcx.
		cmpb	%dl,%cl 			#Compare char in p1 with char in p2.
		jl .P1BIGGER
		jg .P2BIGGER
		incq	%r12				#Go to the next char in p1.
		incq	%r8					#Go to the next char in p2.
		incq	%r11				#Counter++.		
		jmp .CHECKJINDEX1			#Check next char.

.CHECKJINDEX1:		
		cmpq	%r10,%r11			#Checkeing if j got to counter.
		jg .ENDCMP					#Ending if yes.
		jmp .CMP 					#Compare next char.

.P1BIGGER:
		movq  	$(-1),%rax			#P1 is bigger.
   		ret
.P2BIGGER:
    	movq  	$1,%rax				#P2 is bigger.
   		ret
.ENDCMP:
    	movq  	$0,%rax				#Equal sub string.
    	ret

.ENDNOTVALID:
		ret

################################################################################
#Function name: validInput.
#Input: char i,char j, int p1 length, int p2 length.
#Output: int.
#Function opartion: the function check valid of index i and j.
#Note: In case the input is not valid, the function will return -2. otherwise,0.
################################################################################
.globl  validInput
        .type   validInput,   @function
validInput:
        movb 	(%rdi),%al 			#Get the length of p1.
        cmpq	%rdx,%rax			#Check that i is less/equal than p1 length.
        jl .WRONGINPUT 
        cmpq	%rcx,%rax			#Check that j is less/equal than p1 length.
        jl .WRONGINPUT 
        movb 	(%rsi),%al 			#Get the length of p2.
        cmpq	%rdx,%rax			#Check that i is less/equal than p2 length.
        jl .WRONGINPUT
        cmpq	%rcx,%rax			#Check that j is less/equal than p2 length.
        jl .WRONGINPUT			
        cmpq	%rdx,%rcx			#Check that i is less than j.
        jl 	.WRONGINPUT
        movq  	$0,%rax				#If index are valid, 0 will return..
		ret

.WRONGINPUT:
    	movq    $invalidInputMsg,%rdi    #Printing the error massege.    
    	movq    $0,%rax                
    	call    printf
    	movq  	$(-2),%rax				 #Result is -2 when wrong it's input.
		ret