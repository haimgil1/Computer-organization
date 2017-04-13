#203676945  Haim Gil

    .section	.rodata

first_pstr_len:    .string "first pstring length: %d, second pstring length: %d\n"

replace_pstr:      .string "old char: %c, new char: %c, first string: %s, second string: %s\n"

scan_char_replace: .string "\n%c %c"

scan_int:          .string "%d\n%d"

print_sub_pstr:    .string "length: %d, string: %s\n"

print_cmp:         .string "compare result: %d\n"

invalidOptionMsg:  .string "invalid option!\n"

    #Jump Table.
    .align  8           #Align ddress to multiple of 8.  
.SWITCH_CASE:           #switch case label.

    .quad .MISSION1     #Case 50.
    .quad .MISSION2     #Case 51.
    .quad .MISSION3     #Case 52.
    .quad .MISSION4     #Case 53.
    .quad .MISSION5     #Case 54.
    .quad .DEFUALT      #Case defualt.

    .text

#################################################################################
#Function name: run_func.
#Input: int option,Pstring* p1, Pstring* p2.
#Output: none.
#Function opartion: the function running the menu.
#Note: In case option is less than 50 or bigger than 54, error msg will display.
#################################################################################
.globl  run_func
        .type   run_func,   @function
run_func:
        leaq -50(%rdi),%rdi         #Compute the value of option, reducing by 50.
        cmpq $4,%rdi                #Compare option to 4.
        ja .DEFUALT                 #If >, goto default-case
        jmp *.SWITCH_CASE(,%rdi,8)  #Goto SWITCH_CASE label.

#################################################################################

#Case 50
.MISSION1:
    movq    (%rsi),%rdi             #Moving p1 to rdi.
    call    pstrlen                 #Calling pstrlen.
  
#Printing.
    movq    %rax,%rsi               #Saving the length of p1 in 2-parameter.
    movq    (%rdx),%rdi             #Moving p2 to rdi.
    call    pstrlen                 #Calling pstrlen.
    movq    %rax,%rdx               #Saving the length of p2 in 3-parameter..
    movq    $first_pstr_len,%rdi    #Saving the string print in 1-parameter.
    movq    $0,%rax                 
    call    printf                  #Printing p1 length. 
     
    jmp .END

#Case 51
.MISSION2:
    pushq   %r12                    #Back up callee register.
    pushq   %r13                    #Back up callee register.
    pushq   %r14                    #Back up callee register.
    pushq   %r15                    #Back up callee register.

    movq    %rsi,%r12               #Back up p1 to r12.
    movq    %rdx,%r13               #Back up  p2 to r13.

#Scan old char and new char.
    leaq    -1(%rsp),%rsp           #Resizing the stack by char.
    movq    %rsp,%rsi               #Moving the rsp to 2-parameter.
    leaq    -1(%rsp),%rsp           #Resizing the stack by char.
    movq    %rsp,%rdx               #Moving the rsp to 3-parameter.
    movq    $scan_char_replace,%rdi #Moving the string scan to 1st parameter.                 
    movq    $0,%rax
    call    scanf                   #Scaning the old char and new char.
    movb    1(%rsp),%r14b           #Moving old char to r14.
    movb    (%rsp),%r15b            #Moving new char to r15.
    
#Replace p1.    
    movq    %r15,%rdx               #Moving new char to 3-parameter.
    movq    %r14,%rsi               #Moving old char to 2-parameter.
    movq    %r12,%rdi               #Moving p1 to 1-parameter.
    call    replaceChar             #Calling replaceChar with p1.
    movq    %rax,%r12               #Moving the new p1 to p1.
    
#Replace p2.  
    movq    %r15,%rdx               #Moving new char to 3-parameter.
    movq    %r14,%rsi               #Moving old char to 2-parameter.
    movq    %r13,%rdi               #Moving p2 to 1-parameter. 
    call    replaceChar             #Calling replaceChar with p2.
    movq    %rax,%r13               #Moving the new p2 to p2.
    
 #Printing.   
    movq    %r13,%r8                #Moving new p2 to 5-parameter.
    movq    %r12,%rcx               #Moving new p1 to 4-parameter.
    movq    %r15,%rdx               #Moving new char to 3-parameter.
    movq    %r14,%rsi               #Moving old char to 2-parameter.
    movq    $replace_pstr,%rdi      #Moving replace string to 1-parameter.
    movq    $0,%rax                
    call    printf                  #Printing the new strings.
    leaq    2(%rsp),%rsp            #Setting the stack to it original size.

#Restore back up.
    pop     %r12                    #Restore Back up.
    pop     %r13                    #Restore Back up.
    pop     %r14                    #Restore Back up.  
    pop     %r15                    #Restore Back up.
    jmp .END
                   
#Case 52
.MISSION3:
    pushq   %r12                    #Back up callee register.
    pushq   %r13                    #Back up callee register.
    pushq   %r14                    #Back up callee register.
    pushq   %r15                    #Back up callee register.

    movq    %rsi,%r12               #Back up p1 to r12.
    movq    %rdx,%r13               #Back up  p2 to r13.

#Scan i and j index.
    leaq    -4(%rsp),%rsp           #Resizing the stack by int.
    movq    %rsp,%rsi               #Moving the rsp to 2-parameter.
    leaq    -4(%rsp),%rsp           #Resizing the stack by int.
    movq    %rsp,%rdx               #Moving the rsp to 3-parameter.
    movq    $scan_int,%rdi          #Moving the string scan to 1st parameter.                 
    movq    $0,%rax
    call    scanf                   #Scaning the old char and new char.
    movl    4(%rsp),%r14d           #Moving i index to r14.
    movl    (%rsp),%r15d            #Moving j index to r15.

#Copy p2->[i:j] into p1->[i:j].
    movq    %r15,%rcx               #Moving j index to 4-parameter.
    movq    %r14,%rdx               #Moving i index to 3-parameter.
    movq    %r13,%rsi               #Moving p2 to 2-parameter.
    movq    %r12,%rdi               #Moving p1 to 1-parameter.
    call    pstrijcpy               #Calling pstrijcpy.
    movq    %rax,%r12               #Moving the new p1 to p1.
 
#Printing p1.           
    movq    (%r12),%rdi             #Moving p1 to 1-parameter.
    call    pstrlen                 #Calling pstrlen.
    movq    %rax,%rsi               #Saving the length of p1 in 2-parameter.
    incq    %r12                    #Saving p1 without his length.
    movq    %r12,%rdx               #Moving new p1 to 3-parameter.
    movq    $print_sub_pstr,%rdi    #Moving replace string to 1-parameter.
    movq    $0,%rax                
    call    printf                  #Printing the new strings.

#Printing p2.   
    movq    (%r13),%rdi             #Moving p2 to 1-parameter.
    call    pstrlen                 #Calling pstrlen.
    movq    %rax,%rsi               #Saving the length of p2 in 2-parameter.
    incq    %r13                    #Saving p2 without his length.
    movq    %r13,%rdx               #Moving p2 to 3-parameter.
    movq    $print_sub_pstr,%rdi    #Moving replace string to 1-parameter.
    movq    $0,%rax                
    call    printf                  #Printing the new strings.

#Restore back up.
    pop     %r12                    #Restore Back up.
    pop     %r13                    #Restore Back up.
    pop     %r14                    #Restore Back up.  
    pop     %r15                    #Restore Back up.
    leaq    8(%rsp),%rsp            #Setting the stack to it original size.
    jmp .END

#Case 53
.MISSION4:
    pushq   %r12                    #Back up callee register.
    pushq   %r13                    #Back up callee register.

    movq    %rsi,%r12               #Back up p1 to r12.
    movq    %rdx,%r13               #Back up  p2 to r13.
 
#Swap p1.   
    movq    %r12,%rdi               #Moving p1 to 1-parameter.
    call    swapCase
    movq    %rax,%r12               #Moving new p1 back to p1.

#Printing p1.    
    movq    (%r12),%rdi             #Moving p1 to 1-parameter.
    call    pstrlen                 #Calling pstrlen.
    movq    %rax,%rsi               #Saving the length of p1 in 2-parameter.
    incq    %r12                    #Saving p1 without his length.
    movq    %r12,%rdx               #Moving new p1 to 3-parameter.
    movq    $print_sub_pstr,%rdi    #Moving replace string to 1-parameter.
    movq    $0,%rax                
    call    printf                  #Printing the new strings.

#Swap p2.            
    movq    %r13,%rdi               #Moving p2 to 1-parameter.
    call    swapCase
    movq    %rax,%r13               #Moving new p2 back to p2.

#Printing p2.    
    movq    (%r13),%rdi             #Moving p2 to 1-parameter.
    call    pstrlen                 #Calling pstrlen.
    movq    %rax,%rsi               #Saving the length of p2 in 2-parameter.
    incq    %r13                    #Saving p2 without his length.
    movq    %r13,%rdx               #Moving p2 to 3-parameter.
    movq    $print_sub_pstr,%rdi    #Moving replace string to 1-parameter.
    movq    $0,%rax                
    call    printf                  #Printing the new strings.
    
    pop     %r12                    #Restore Back up.
    pop     %r13                    #Restore Back up.
    jmp .END
   
#Case 54
.MISSION5:
    pushq   %r12                    #Back up callee register.
    pushq   %r13                    #Back up callee register.
    pushq   %r14                    #Back up callee register.
    pushq   %r15                    #Back up callee register.

    movq    %rsi,%r12               #Back up p1 to r12.
    movq    %rdx,%r13               #Back up  p2 to r13.

#Scan i and j index.
    leaq    -4(%rsp),%rsp           #Resizing the stack by int.
    movq    %rsp,%rsi               #Moving the rsp to 2-parameter.
    leaq    -4(%rsp),%rsp           #Resizing the stack by int.
    movq    %rsp,%rdx               #Moving the rsp to 3-parameter.
    movq    $scan_int,%rdi          #Moving the string scan to 1st parameter.                 
    movq    $0,%rax
    call    scanf                   #Scaning the old char and new char.

    movl    4(%rsp),%r14d           #Moving i index to r14.
    movl    (%rsp),%r15d            #Moving j index to r15.

#Compare p2->[i:j] with p1->[i:j].
    movq    %r15,%rcx               #Moving j index to 4-parameter.
    movq    %r14,%rdx               #Moving i index to 3-parameter.
    movq    %r13,%rsi               #Moving p2 to 2-parameter.
    movq    %r12,%rdi               #Moving p1 to 1-parameter.
    call    pstrijcmp               #Calling pstrijcmp.
    movq    %rax,%r10               #Moving the new p1 to p1.
            
#Printing result.
    movq    %r10,%rsi               #Moving comare result to 2-parameter.
    movq    $print_cmp,%rdi         #Moving replace string to 1-parameter.
    movq    $0,%rax                
    call    printf                  #Printing the new strings.

#Restore back up.
    pop     %r12                    #Restore Back up.
    pop     %r13                    #Restore Back up.
    pop     %r14                    #Restore Back up.  
    pop     %r15                    #Restore Back up.
    leaq    8(%rsp),%rsp            #Setting the stack to it original size.
    jmp .END

#Case DEFUALT
.DEFUALT:
    movq    $invalidOptionMsg,%rdi  #Printing the error massege.    
    movq    $0,%rax                
    call    printf
    ret
    
#End Program
.END:
    ret
    