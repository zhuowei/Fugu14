//
//  asm.S
//  jailbreakd - asmAndC
//
//  Created by Linus Henze.
//  Copyright © 2021 Linus Henze. All rights reserved.
//

.text
.align 4

.globl _doMagic
_doMagic:
    ldr x0, =0x4949494949494949
    str x0, [x23]
    str x0, [x23,#0x8]

    //str x22, [x21,x24]
    // zhuowei: hack: we can't map the kernel struct into our process
    // and I don't want to RPC from this weirdo thread,
    // so we wait for our main thread to do the write for us via RPC instead.
    //
    mov w0, 0x62
    strb w0, [x21]
first_wait_loop:
    ldrb w0, [x21]
    cmp w0, 0x63
    b.ne first_wait_loop

    mov x0, x23
    add x0, x0, 0xC
    mov x1, 0x6
    mov x2, x23
    mov x3, x23
    mov x4, 0
    mov x5, 0
    ldr s1, =0x42424242
    ldr s2, =0x43434343
    ldr s3, =0x44444444
    ldr s4, =0x45454545
    mov x16, #274
    svc #0x80
doMagicLoop:
    b doMagicLoop

.globl _userReturn
_userReturn:
    ldr x23, =0x12345678
    b _userReturn
