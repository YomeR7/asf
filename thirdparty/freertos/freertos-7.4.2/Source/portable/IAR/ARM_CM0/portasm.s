/*
    FreeRTOS V7.4.2 - Copyright (C) 2013 Real Time Engineers Ltd.

    FEATURES AND PORTS ARE ADDED TO FREERTOS ALL THE TIME.  PLEASE VISIT
    http://www.FreeRTOS.org TO ENSURE YOU ARE USING THE LATEST VERSION.

    ***************************************************************************
     *                                                                       *
     *    FreeRTOS tutorial books are available in pdf and paperback.        *
     *    Complete, revised, and edited pdf reference manuals are also       *
     *    available.                                                         *
     *                                                                       *
     *    Purchasing FreeRTOS documentation will not only help you, by       *
     *    ensuring you get running as quickly as possible and with an        *
     *    in-depth knowledge of how to use FreeRTOS, it will also help       *
     *    the FreeRTOS project to continue with its mission of providing     *
     *    professional grade, cross platform, de facto standard solutions    *
     *    for microcontrollers - completely free of charge!                  *
     *                                                                       *
     *    >>> See http://www.FreeRTOS.org/Documentation for details. <<<     *
     *                                                                       *
     *    Thank you for using FreeRTOS, and thank you for your support!      *
     *                                                                       *
    ***************************************************************************


    This file is part of the FreeRTOS distribution.

    FreeRTOS is free software; you can redistribute it and/or modify it under
    the terms of the GNU General Public License (version 2) as published by the
    Free Software Foundation AND MODIFIED BY the FreeRTOS exception.

    >>>>>>NOTE<<<<<< The modification to the GPL is included to allow you to
    distribute a combined work that includes FreeRTOS without being obliged to
    provide the source code for proprietary components outside of the FreeRTOS
    kernel.

    FreeRTOS is distributed in the hope that it will be useful, but WITHOUT ANY
    WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    details. You should have received a copy of the GNU General Public License
    and the FreeRTOS license exception along with FreeRTOS; if not it can be
    viewed here: http://www.freertos.org/a00114.html and also obtained by
    writing to Real Time Engineers Ltd., contact details for whom are available
    on the FreeRTOS WEB site.

    1 tab == 4 spaces!

    ***************************************************************************
     *                                                                       *
     *    Having a problem?  Start by reading the FAQ "My application does   *
     *    not run, what could be wrong?"                                     *
     *                                                                       *
     *    http://www.FreeRTOS.org/FAQHelp.html                               *
     *                                                                       *
    ***************************************************************************


    http://www.FreeRTOS.org - Documentation, books, training, latest versions, 
    license and Real Time Engineers Ltd. contact details.

    http://www.FreeRTOS.org/plus - A selection of FreeRTOS ecosystem products,
    including FreeRTOS+Trace - an indispensable productivity tool, and our new
    fully thread aware and reentrant UDP/IP stack.

    http://www.OpenRTOS.com - Real Time Engineers ltd license FreeRTOS to High 
    Integrity Systems, who sell the code with commercial support, 
    indemnification and middleware, under the OpenRTOS brand.
    
    http://www.SafeRTOS.com - High Integrity Systems also provide a safety 
    engineered and independently SIL3 certified version for use in safety and 
    mission critical applications that require provable dependability.
*/

#include <FreeRTOSConfig.h>

/* For backward compatibility, ensure configKERNEL_INTERRUPT_PRIORITY is
defined.  The value zero should also ensure backward compatibility.
FreeRTOS.org versions prior to V4.3.0 did not include this definition. */
#ifndef configKERNEL_INTERRUPT_PRIORITY
	#define configKERNEL_INTERRUPT_PRIORITY 0
#endif

	
	RSEG    CODE:CODE(2)
	thumb

	EXTERN vPortYieldFromISR
	EXTERN pxCurrentTCB
	EXTERN vTaskSwitchContext

	PUBLIC vSetMSP
	PUBLIC xPortPendSVHandler
	PUBLIC vPortSVCHandler
	PUBLIC vPortStartFirstTask


/*-----------------------------------------------------------*/

vSetMSP
	msr msp, r0
	bx lr
	
/*-----------------------------------------------------------*/

xPortPendSVHandler:
	mrs r0, psp							
											
	ldr	r3, =pxCurrentTCB	/* Get the location of the current TCB. */
	ldr	r2, [r3]						
											
	subs r0, r0, #32		/* Make space for the remaining low registers. */
	str r0, [r2]			/* Save the new top of stack. */
	stmia r0!, {r4-r7}		/* Store the low registers that are not saved automatically. */
	mov r4, r8				/* Store the high registers. */
	mov r5, r9							
	mov r6, r10							
	mov r7, r11							
	stmia r0!, {r4-r7}              	
											
	push {r3, r14}						
	cpsid i								
	bl vTaskSwitchContext				
	cpsie i								
	pop {r2, r3}			/* lr goes in r3. r2 now holds tcb pointer. */
											
	ldr r1, [r2]						
	ldr r0, [r1]			/* The first item in pxCurrentTCB is the task top of stack. */
	adds r0, r0, #16		/* Move to the high registers. */
	ldmia r0!, {r4-r7}		/* Pop the high registers. */
	mov r8, r4							
	mov r9, r5							
	mov r10, r6							
	mov r11, r7							
											
	msr psp, r0				/* Remember the new top of stack for the task. */
											
	subs r0, r0, #32		/* Go back for the low registers that are not automatically restored. */
	ldmia r0!, {r4-r7}		/* Pop low registers.  */
											
	bx r3								

/*-----------------------------------------------------------*/

vPortSVCHandler;
	ldr	r3, =pxCurrentTCB	/* Restore the context. */
	ldr r1, [r3]			/* Get the pxCurrentTCB address. */
	ldr r0, [r1]			/* The first item in pxCurrentTCB is the task top of stack. */
	adds r0, r0, #16		/* Move to the high registers. */
	ldmia r0!, {r4-r7}		/* Pop the high registers. */
	mov r8, r4						
	mov r9, r5						
	mov r10, r6						
	mov r11, r7						
										
	msr psp, r0				/* Remember the new top of stack for the task. */
										
	subs r0, r0, #32		/* Go back for the low registers that are not automatically restored. */
	ldmia r0!, {r4-r7}		/* Pop low registers.  */
	mov r1, r14				/* OR R14 with 0x0d. */
	movs r0, #0x0d					
	orrs r1, r0						
	bx r1							

/*-----------------------------------------------------------*/

vPortStartFirstTask
	/* The MSP stack is not reset as, unlike on M3/4 parts, there is no vector
	table offset register that can be used to locate the initial stack value.
	Not all M0 parts have the application vector table at address 0. */

	ldr	r3, =pxCurrentTCB	/* Obtain location of pxCurrentTCB. */
	ldr r1, [r3]
	ldr r0, [r1]			/* The first item in pxCurrentTCB is the task top of stack. */
	adds r0, #32			/* Discard everything up to r0. */
	msr psp, r0				/* This is now the new top of stack to use in the task. */
	movs r0, #2				/* Switch to the psp stack. */
	msr CONTROL, r0
	pop {r0-r5}				/* Pop the registers that are saved automatically. */
	mov lr, r5				/* lr is now in r5. */
	cpsie i					/* The first task has its context and interrupts can be enabled. */
	pop {pc}				/* Finally, pop the PC to jump to the user defined task code. */
	
	END
	
