# Changes for macOS:
# .section .data/.text => .data/.text
# .type allocate_init/allocate/deallocate @function removed
# current_break => current_break(%rip)	
# heap_begin => heap_begin(%rip)	
#
# Under macOS the brk system call doesn not exist anymore. We will use
# the c-Function _sbrk instead. sbrk is slighlity different than brk
# Explanations below.
#
# Interchanged %rsi and %rdi. Because rdi is the argument for the function call and
# must contain the increment of the break point
#
# movq ST_MEM_SIZE(%rbp), %rsi => movq ST_MEM_SIZE(%rbp), %rdi
# movq current_break(%rip), %rdi => movq current_break(%rip), %rsi 
# cmpq %rdi, %rax => cmpq %rsi, %rax	
# cmpq %rdx, %rsi => cmpq %rdx, %rdi
# addq %rsi, %rdi => addq %rdi, %rsi	
# movq %rsi, HDR_SIZE_OFFSET(%rax) => movq %rdi, HDR_SIZE_OFFSET(%rax)
# movq %rdi, current_break(%rip) => movq %rsi, current_break(%rip)
#
# movq $SYS_BRK, %rax  removed
# syscall => call _sbrk


# Changes for 64-Bit:
# eXX => rXX
# movq, push pop add sub cmp inc
# int $LINUX_SYSCALL => syscall
# SYS_BRK, 45 => SYS_BRK, 12
# for syscalls rbx => rdi , rcx => rsi

# .long => .quad
# Stack Size doubled

# PURPOSE: Program to manage memory usage - allocates and deallocates
#	   memory as requested
#
# Notes:   The prgrams using these routines will ask for a certain
#          size of memory. We acutally use more than that size, but
#          we put it at the beginning, before the pointer we hand
#          back. We add a size field and an AVAILABLE/UNAVAILABLE
#          marker. So, the memory looks like this:
#
#	  ###############################################################
#	  # Available Marker # Size of memory # Actual memory locations #
#	  ###############################################################
#					       ^
#					       L__ Returned pointer,
#						   points here!
#
#	   The pointer we return only points to the acutal locations requested
#          to make it easier for the calling program. It also allows us to
#          change our structure without the calling program having to change
#          at all.


.data

######## GLOBAL VARIABLES ########

# This points to the beginning of the memory we are managing
heap_begin:
 .quad 0

# This points to one location past the memory we are managing
current_break:
 .quad 0


######## STRUCTURE INOFORMATION ########

# Size of space for memory region header
.equ HEADER_SIZE, 16
# Location of the "available" flag in the header
.equ HDR_AVAIL_OFFSET, 0				# 0-8 bytes
# Location of the size field in the header
.equ HDR_SIZE_OFFSET, 8					# 8-16 bytes

# HDR High-dynamic-ran... OHHHhh it means header...

######## CONSTANTS ########

.equ UNAVAILABLE, 0		# This is the number we will use to mark
				# space that has been given out.
.equ AVAILABLE, 1		# This is the number we will use to mark
				# space that has been teturned, and is
				# available for giving
.equ SYS_BRK, 12		# system call number for break

#.equ LINUX_SYSCALL, 0x80	# make system calls easier to read.


.text

######## FUNCTIONS ########

## allocate_init ##
# PURPOSE: Call this function to initialize the
#          functions (specifically, this sets heep_begin and
#          current_break). This has no parameters and no
#	   return value.

.globl allocate_init
#.type allocate_init, @function

allocate_init:
 pushq %rbp			# Standard function stuff
 movq %rsp, %rbp
 subq $8, %rsp			# Stack alignment bullshit! Why?

# If the brk system call is called with 0 in %rdi, it returns
# the last valid usable address

#movq $SYS_BRK, %rax		# find out where the break is
movq $0, %rdi
call _sbrk

incq %rax			# %rax now hat the last valid
				# address, and we want the memory
				# location after that.

movq %rax, current_break(%rip)	# store the current break

movq %rax, heap_begin(%rip)	# store the current break as our
				# first address. This will
				# cause the allocate function
				# to get more memory from Linux
				# the first time it is run.

# At this point heap_begin and curent_break are both pointing to the
# first non vaild memory address. The heap has therefore no space.

movq %rbp, %rsp			# exit the function
popq %rbp
ret

######## END OF FUNCTION ########

## allocate ##
# PURPOSE:	This function is used to grab a section of memory.
#		It checks to see if there are any free blocks,
#		and, if not, it asks Linux for a new one.
#
# PARAMETERS:	This function has one parameter - the size
#		of the memory block we want to allocate
#
# RETURN VALUE: This function returns the address of the
#		allocated memory in %rax. If there is no
#		memory available, it will return 0 in %rax
#

######## PROCESSING ########

# Variables used:
#
#	%rdi - hold the size of the requested memory
#	       (first/only parameter)
#	%rax - current memory region being examined
#	%rsi - current break position (address)
#	%rdx - size of current memory region
#
# We scan through each memory region starting with heap_begin.
# We look at the size of each one, and if it has been allocated.
# If it's big enough for the requested size, and it's available,
# it grabs that one. If it dosen't find a region large enough,
# it asks Linux for more memory. In that case, it moves
# current_break up

.globl allocate
#.type allocate, @function
.equ ST_MEM_SIZE, 16              # Stack position of the memory size
				 # to allocate

allocate:
 pushq %rbp			 # standard function stuff
 movq %rsp, %rbp

 movq ST_MEM_SIZE(%rbp), %rdi    # %rdi will hold the size we are looking for
				 # (which is the first and only parameter)

 movq heap_begin(%rip), %rax	 # %rax will hold the current search location

 movq current_break(%rip), %rsi	 # %rsi will hold the current break


alloc_loop_begin:		 # here we iterate through each memory region

 cmpq %rsi, %rax		 # need more memory if these are equal
 je   move_break

# Note: This condition is met the first time the function is called, due to
# the allocate_init function.

# grab the size of this memory
movq HDR_SIZE_OFFSET(%rax), %rdx          # On the stack is now %rdi+HEADER size, which be pushed on he
				          # stack in move_break

# If the space is unavailable, go to the next one.
cmpq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)
je next_location

cmpq %rdx, %rdi			 # If the space is available, compare
jle  allocate_here		 # the size to the needed size. If it's
				 # big enough, go to allocate_here

next_location:

# At this point %rax does already contain the HEADER_SIZE, therefore
# we musn't add it here again.

# addq $HEADER_SIZE, %rax	 # 
 addq %rdx, %rax		 # We already changed %rdx
				 # by the size of the header.
				 # Therefore, we don't need 
				 # to add it here.
				 # We add %rdx and %rax and
				 # get the address of the next
				 # location.
				 # 

jmp alloc_loop_begin		 # go look at the next location

allocate_here:			 # If we've made it here, that means
				 # that the region header of the
				 # region to allocate is in %rax

# mark space as unavailable
movq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)
addq $HEADER_SIZE, %rax		# move %rax past the header to
				# the usable memory (since that's
				# what we return)

movq %rbp, %rsp			# return from the function
popq %rbp
ret

#  Note: For in the original code we would pass the address to brk.
#        By adding %rsi and %rdi, we had the new address, where we 
#        want our current_break to be. With sbrk, we need to pass 
#        the increament, and the current_break will move by that 
#        amount. The return value in %rax however, is still the 
#	 old address for break_begin.

move_break:			# If we've made it here, that
				# means that we have exhausted
				# all addressable memory, and
				# we need to ask for more.
				# %rdi holds the current endpoint
				# of the data, and %rsi holds its
				# size.

				######### CHANGED ##########
				# Here we change %rdi by 10
				# for the header. We need to 
addq $HEADER_SIZE, %rdi		# do this, because the value
				# in %rdi will be requested.
addq %rdi, %rsi			#
				# In the original code, the 
				# address was passed and changed.


pushq %rax			# save needed registers
pushq %rsi
pushq %rdi

#movq $SYS_BRK, %rax		# reset the break (%rdi has the
				# requested break point)
call _sbrk

####################### NOT TRUE FOR SBRK ##############################
# Under normal conditions, this should return the new break in %rax,
# which will be either 0 if it fails, or if will be equal to or larger
# than it will be equal to or larger than we asked for. We don't care
# in this program where it acutally sets the break, so as long as %rax
# isn't 0, we don't care what it is.


cmpq $0, %rax			# Check for error conditions
je error

popq %rdi			# Restore saved registers
popq %rsi
popq %rax

# Set this momory as unavailable, since we're about to
# give it away
movq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)
# Set the size of the memory
movq %rdi, HDR_SIZE_OFFSET(%rax)		# Here we move the requested memory+HEADER on the stack
						# This is different to the original code.

# Move %rax to the actual start of usable memory.
# %rax now holds the return value
addq $HEADER_SIZE, %rax

movq %rsi, current_break(%rip)	# Save the new break

movq %rbp, %rsp			# return the function
popq %rbp
ret

error:				# On error, we return 0
 movq $0, %rax
 movq %rbp, %rsp
 popq %rbp
 ret

######## END OF FUNCTION ########

## deallocate ##
# PURPOSE: The purpose of this function is to give back a region of memory
#	   to the pool after we're done using it.
#
# PARAMETERS: The only parameter is the address of the memory we want to
#	      return to the memory pool.
#
# RETURN VALUE: There is no return value.
#
# PROCESSING: If you remember, we acutally hand the program the start of the
#	      memory that they can use, which is 8 storage locations after the
#	      actual start of the memory region. All we have to do is go back
#	      8 locations and mark that memory as available, so that the
#	      allocate function knows it can use it.
.globl deallocate
#.type deallocate, @function

# Stack position of the memory region to free
.equ ST_MEMORY_SEG, 8

deallocate:
# Since the function is so simple, we don't need any of the fancy
# function stuff.

# Get the address of the memory to free (normally this is 8(%rbp),
# but since we didn't push %rbp or move %rsp to %rbp, we can just
# doe 4(%rsp)
movq ST_MEMORY_SEG(%rsp), %rax


# Get the pointer to the real beginning of the memory
subq $HEADER_SIZE, %rax

# mark it as available
movq $AVAILABLE, HDR_AVAIL_OFFSET(%rax)

#return
ret

######## END OF FUNCTION ########
