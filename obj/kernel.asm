
obj/kernel.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000040000 <entry_from_boot>:
# The entry_from_boot routine sets the stack pointer to the top of the
# OS kernel stack, then jumps to the `kernel` routine.

.globl entry_from_boot
entry_from_boot:
        movq $0x80000, %rsp
   40000:	48 c7 c4 00 00 08 00 	mov    $0x80000,%rsp
        movq %rsp, %rbp
   40007:	48 89 e5             	mov    %rsp,%rbp
        pushq $0
   4000a:	6a 00                	pushq  $0x0
        popfq
   4000c:	9d                   	popfq  
        // Check for multiboot command line; if found pass it along.
        cmpl $0x2BADB002, %eax
   4000d:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
        jne 1f
   40012:	75 0d                	jne    40021 <entry_from_boot+0x21>
        testl $4, (%rbx)
   40014:	f7 03 04 00 00 00    	testl  $0x4,(%rbx)
        je 1f
   4001a:	74 05                	je     40021 <entry_from_boot+0x21>
        movl 16(%rbx), %edi
   4001c:	8b 7b 10             	mov    0x10(%rbx),%edi
        jmp 2f
   4001f:	eb 07                	jmp    40028 <entry_from_boot+0x28>
1:      movq $0, %rdi
   40021:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
2:      jmp kernel
   40028:	e9 3a 01 00 00       	jmpq   40167 <kernel>
   4002d:	90                   	nop

000000000004002e <gpf_int_handler>:
# Interrupt handlers
.align 2

        .globl gpf_int_handler
gpf_int_handler:
        pushq $13               // trap number
   4002e:	6a 0d                	pushq  $0xd
        jmp generic_exception_handler
   40030:	eb 6e                	jmp    400a0 <generic_exception_handler>

0000000000040032 <pagefault_int_handler>:

        .globl pagefault_int_handler
pagefault_int_handler:
        pushq $14
   40032:	6a 0e                	pushq  $0xe
        jmp generic_exception_handler
   40034:	eb 6a                	jmp    400a0 <generic_exception_handler>

0000000000040036 <timer_int_handler>:

        .globl timer_int_handler
timer_int_handler:
        pushq $0                // error code
   40036:	6a 00                	pushq  $0x0
        pushq $32
   40038:	6a 20                	pushq  $0x20
        jmp generic_exception_handler
   4003a:	eb 64                	jmp    400a0 <generic_exception_handler>

000000000004003c <sys48_int_handler>:

sys48_int_handler:
        pushq $0
   4003c:	6a 00                	pushq  $0x0
        pushq $48
   4003e:	6a 30                	pushq  $0x30
        jmp generic_exception_handler
   40040:	eb 5e                	jmp    400a0 <generic_exception_handler>

0000000000040042 <sys49_int_handler>:

sys49_int_handler:
        pushq $0
   40042:	6a 00                	pushq  $0x0
        pushq $49
   40044:	6a 31                	pushq  $0x31
        jmp generic_exception_handler
   40046:	eb 58                	jmp    400a0 <generic_exception_handler>

0000000000040048 <sys50_int_handler>:

sys50_int_handler:
        pushq $0
   40048:	6a 00                	pushq  $0x0
        pushq $50
   4004a:	6a 32                	pushq  $0x32
        jmp generic_exception_handler
   4004c:	eb 52                	jmp    400a0 <generic_exception_handler>

000000000004004e <sys51_int_handler>:

sys51_int_handler:
        pushq $0
   4004e:	6a 00                	pushq  $0x0
        pushq $51
   40050:	6a 33                	pushq  $0x33
        jmp generic_exception_handler
   40052:	eb 4c                	jmp    400a0 <generic_exception_handler>

0000000000040054 <sys52_int_handler>:

sys52_int_handler:
        pushq $0
   40054:	6a 00                	pushq  $0x0
        pushq $52
   40056:	6a 34                	pushq  $0x34
        jmp generic_exception_handler
   40058:	eb 46                	jmp    400a0 <generic_exception_handler>

000000000004005a <sys53_int_handler>:

sys53_int_handler:
        pushq $0
   4005a:	6a 00                	pushq  $0x0
        pushq $53
   4005c:	6a 35                	pushq  $0x35
        jmp generic_exception_handler
   4005e:	eb 40                	jmp    400a0 <generic_exception_handler>

0000000000040060 <sys54_int_handler>:

sys54_int_handler:
        pushq $0
   40060:	6a 00                	pushq  $0x0
        pushq $54
   40062:	6a 36                	pushq  $0x36
        jmp generic_exception_handler
   40064:	eb 3a                	jmp    400a0 <generic_exception_handler>

0000000000040066 <sys55_int_handler>:

sys55_int_handler:
        pushq $0
   40066:	6a 00                	pushq  $0x0
        pushq $55
   40068:	6a 37                	pushq  $0x37
        jmp generic_exception_handler
   4006a:	eb 34                	jmp    400a0 <generic_exception_handler>

000000000004006c <sys56_int_handler>:

sys56_int_handler:
        pushq $0
   4006c:	6a 00                	pushq  $0x0
        pushq $56
   4006e:	6a 38                	pushq  $0x38
        jmp generic_exception_handler
   40070:	eb 2e                	jmp    400a0 <generic_exception_handler>

0000000000040072 <sys57_int_handler>:

sys57_int_handler:
        pushq $0
   40072:	6a 00                	pushq  $0x0
        pushq $57
   40074:	6a 39                	pushq  $0x39
        jmp generic_exception_handler
   40076:	eb 28                	jmp    400a0 <generic_exception_handler>

0000000000040078 <sys58_int_handler>:

sys58_int_handler:
        pushq $0
   40078:	6a 00                	pushq  $0x0
        pushq $58
   4007a:	6a 3a                	pushq  $0x3a
        jmp generic_exception_handler
   4007c:	eb 22                	jmp    400a0 <generic_exception_handler>

000000000004007e <sys59_int_handler>:

sys59_int_handler:
        pushq $0
   4007e:	6a 00                	pushq  $0x0
        pushq $59
   40080:	6a 3b                	pushq  $0x3b
        jmp generic_exception_handler
   40082:	eb 1c                	jmp    400a0 <generic_exception_handler>

0000000000040084 <sys60_int_handler>:

sys60_int_handler:
        pushq $0
   40084:	6a 00                	pushq  $0x0
        pushq $60
   40086:	6a 3c                	pushq  $0x3c
        jmp generic_exception_handler
   40088:	eb 16                	jmp    400a0 <generic_exception_handler>

000000000004008a <sys61_int_handler>:

sys61_int_handler:
        pushq $0
   4008a:	6a 00                	pushq  $0x0
        pushq $61
   4008c:	6a 3d                	pushq  $0x3d
        jmp generic_exception_handler
   4008e:	eb 10                	jmp    400a0 <generic_exception_handler>

0000000000040090 <sys62_int_handler>:

sys62_int_handler:
        pushq $0
   40090:	6a 00                	pushq  $0x0
        pushq $62
   40092:	6a 3e                	pushq  $0x3e
        jmp generic_exception_handler
   40094:	eb 0a                	jmp    400a0 <generic_exception_handler>

0000000000040096 <sys63_int_handler>:

sys63_int_handler:
        pushq $0
   40096:	6a 00                	pushq  $0x0
        pushq $63
   40098:	6a 3f                	pushq  $0x3f
        jmp generic_exception_handler
   4009a:	eb 04                	jmp    400a0 <generic_exception_handler>

000000000004009c <default_int_handler>:

        .globl default_int_handler
default_int_handler:
        pushq $0
   4009c:	6a 00                	pushq  $0x0
        jmp generic_exception_handler
   4009e:	eb 00                	jmp    400a0 <generic_exception_handler>

00000000000400a0 <generic_exception_handler>:


generic_exception_handler:
        pushq %gs
   400a0:	0f a8                	pushq  %gs
        pushq %fs
   400a2:	0f a0                	pushq  %fs
        pushq %r15
   400a4:	41 57                	push   %r15
        pushq %r14
   400a6:	41 56                	push   %r14
        pushq %r13
   400a8:	41 55                	push   %r13
        pushq %r12
   400aa:	41 54                	push   %r12
        pushq %r11
   400ac:	41 53                	push   %r11
        pushq %r10
   400ae:	41 52                	push   %r10
        pushq %r9
   400b0:	41 51                	push   %r9
        pushq %r8
   400b2:	41 50                	push   %r8
        pushq %rdi
   400b4:	57                   	push   %rdi
        pushq %rsi
   400b5:	56                   	push   %rsi
        pushq %rbp
   400b6:	55                   	push   %rbp
        pushq %rbx
   400b7:	53                   	push   %rbx
        pushq %rdx
   400b8:	52                   	push   %rdx
        pushq %rcx
   400b9:	51                   	push   %rcx
        pushq %rax
   400ba:	50                   	push   %rax
        movq %rsp, %rdi
   400bb:	48 89 e7             	mov    %rsp,%rdi
        call exception
   400be:	e8 8d 0c 00 00       	callq  40d50 <exception>

00000000000400c3 <exception_return>:
        # `exception` should never return.


        .globl exception_return
exception_return:
        movq %rdi, %rsp
   400c3:	48 89 fc             	mov    %rdi,%rsp
        popq %rax
   400c6:	58                   	pop    %rax
        popq %rcx
   400c7:	59                   	pop    %rcx
        popq %rdx
   400c8:	5a                   	pop    %rdx
        popq %rbx
   400c9:	5b                   	pop    %rbx
        popq %rbp
   400ca:	5d                   	pop    %rbp
        popq %rsi
   400cb:	5e                   	pop    %rsi
        popq %rdi
   400cc:	5f                   	pop    %rdi
        popq %r8
   400cd:	41 58                	pop    %r8
        popq %r9
   400cf:	41 59                	pop    %r9
        popq %r10
   400d1:	41 5a                	pop    %r10
        popq %r11
   400d3:	41 5b                	pop    %r11
        popq %r12
   400d5:	41 5c                	pop    %r12
        popq %r13
   400d7:	41 5d                	pop    %r13
        popq %r14
   400d9:	41 5e                	pop    %r14
        popq %r15
   400db:	41 5f                	pop    %r15
        popq %fs
   400dd:	0f a1                	popq   %fs
        popq %gs
   400df:	0f a9                	popq   %gs
        addq $16, %rsp
   400e1:	48 83 c4 10          	add    $0x10,%rsp
        iretq
   400e5:	48 cf                	iretq  

00000000000400e7 <sys_int_handlers>:
   400e7:	3c 00                	cmp    $0x0,%al
   400e9:	04 00                	add    $0x0,%al
   400eb:	00 00                	add    %al,(%rax)
   400ed:	00 00                	add    %al,(%rax)
   400ef:	42 00 04 00          	add    %al,(%rax,%r8,1)
   400f3:	00 00                	add    %al,(%rax)
   400f5:	00 00                	add    %al,(%rax)
   400f7:	48 00 04 00          	rex.W add %al,(%rax,%rax,1)
   400fb:	00 00                	add    %al,(%rax)
   400fd:	00 00                	add    %al,(%rax)
   400ff:	4e 00 04 00          	rex.WRX add %r8b,(%rax,%r8,1)
   40103:	00 00                	add    %al,(%rax)
   40105:	00 00                	add    %al,(%rax)
   40107:	54                   	push   %rsp
   40108:	00 04 00             	add    %al,(%rax,%rax,1)
   4010b:	00 00                	add    %al,(%rax)
   4010d:	00 00                	add    %al,(%rax)
   4010f:	5a                   	pop    %rdx
   40110:	00 04 00             	add    %al,(%rax,%rax,1)
   40113:	00 00                	add    %al,(%rax)
   40115:	00 00                	add    %al,(%rax)
   40117:	60                   	(bad)  
   40118:	00 04 00             	add    %al,(%rax,%rax,1)
   4011b:	00 00                	add    %al,(%rax)
   4011d:	00 00                	add    %al,(%rax)
   4011f:	66 00 04 00          	data16 add %al,(%rax,%rax,1)
   40123:	00 00                	add    %al,(%rax)
   40125:	00 00                	add    %al,(%rax)
   40127:	6c                   	insb   (%dx),%es:(%rdi)
   40128:	00 04 00             	add    %al,(%rax,%rax,1)
   4012b:	00 00                	add    %al,(%rax)
   4012d:	00 00                	add    %al,(%rax)
   4012f:	72 00                	jb     40131 <sys_int_handlers+0x4a>
   40131:	04 00                	add    $0x0,%al
   40133:	00 00                	add    %al,(%rax)
   40135:	00 00                	add    %al,(%rax)
   40137:	78 00                	js     40139 <sys_int_handlers+0x52>
   40139:	04 00                	add    $0x0,%al
   4013b:	00 00                	add    %al,(%rax)
   4013d:	00 00                	add    %al,(%rax)
   4013f:	7e 00                	jle    40141 <sys_int_handlers+0x5a>
   40141:	04 00                	add    $0x0,%al
   40143:	00 00                	add    %al,(%rax)
   40145:	00 00                	add    %al,(%rax)
   40147:	84 00                	test   %al,(%rax)
   40149:	04 00                	add    $0x0,%al
   4014b:	00 00                	add    %al,(%rax)
   4014d:	00 00                	add    %al,(%rax)
   4014f:	8a 00                	mov    (%rax),%al
   40151:	04 00                	add    $0x0,%al
   40153:	00 00                	add    %al,(%rax)
   40155:	00 00                	add    %al,(%rax)
   40157:	90                   	nop
   40158:	00 04 00             	add    %al,(%rax,%rax,1)
   4015b:	00 00                	add    %al,(%rax)
   4015d:	00 00                	add    %al,(%rax)
   4015f:	96                   	xchg   %eax,%esi
   40160:	00 04 00             	add    %al,(%rax,%rax,1)
   40163:	00 00                	add    %al,(%rax)
	...

0000000000040167 <kernel>:
//    Initialize the hardware and processes and start running. The `command`
//    string is an optional string passed from the boot loader.

static void process_setup(pid_t pid, int program_number);

void kernel(const char* command) {
   40167:	55                   	push   %rbp
   40168:	48 89 e5             	mov    %rsp,%rbp
   4016b:	48 83 ec 20          	sub    $0x20,%rsp
   4016f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    hardware_init();
   40173:	e8 68 1a 00 00       	callq  41be0 <hardware_init>
    pageinfo_init();
   40178:	e8 f4 0f 00 00       	callq  41171 <pageinfo_init>
    console_clear();
   4017d:	e8 d1 3d 00 00       	callq  43f53 <console_clear>
    timer_init(HZ);
   40182:	bf 64 00 00 00       	mov    $0x64,%edi
   40187:	e8 28 1f 00 00       	callq  420b4 <timer_init>

    virtual_memory_map(kernel_pagetable, (uintptr_t) 0, (uintptr_t) 0, // remove write privilege for kernel memory
   4018c:	48 8b 05 2d 61 01 00 	mov    0x1612d(%rip),%rax        # 562c0 <kernel_pagetable>
   40193:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40199:	41 b8 03 00 00 00    	mov    $0x3,%r8d
   4019f:	b9 00 00 10 00       	mov    $0x100000,%ecx
   401a4:	ba 00 00 00 00       	mov    $0x0,%edx
   401a9:	be 00 00 00 00       	mov    $0x0,%esi
   401ae:	48 89 c7             	mov    %rax,%rdi
   401b1:	e8 71 20 00 00       	callq  42227 <virtual_memory_map>
                        PROC_START_ADDR, PTE_P | PTE_W, NULL); 

    // Set up process descriptors
    memset(processes, 0, sizeof(processes));
   401b6:	ba 80 0d 00 00       	mov    $0xd80,%edx
   401bb:	be 00 00 00 00       	mov    $0x0,%esi
   401c0:	bf 00 d0 04 00       	mov    $0x4d000,%edi
   401c5:	e8 94 34 00 00       	callq  4365e <memset>
    for (pid_t i = 0; i < NPROC; i++) {
   401ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   401d1:	eb 58                	jmp    4022b <kernel+0xc4>
        processes[i].p_pid = i;
   401d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401d6:	48 63 d0             	movslq %eax,%rdx
   401d9:	48 89 d0             	mov    %rdx,%rax
   401dc:	48 01 c0             	add    %rax,%rax
   401df:	48 01 d0             	add    %rdx,%rax
   401e2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   401e9:	00 
   401ea:	48 01 d0             	add    %rdx,%rax
   401ed:	48 c1 e0 03          	shl    $0x3,%rax
   401f1:	48 8d 90 00 d0 04 00 	lea    0x4d000(%rax),%rdx
   401f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401fb:	89 02                	mov    %eax,(%rdx)
        processes[i].p_state = P_FREE;
   401fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40200:	48 63 d0             	movslq %eax,%rdx
   40203:	48 89 d0             	mov    %rdx,%rax
   40206:	48 01 c0             	add    %rax,%rax
   40209:	48 01 d0             	add    %rdx,%rax
   4020c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40213:	00 
   40214:	48 01 d0             	add    %rdx,%rax
   40217:	48 c1 e0 03          	shl    $0x3,%rax
   4021b:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   40221:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    for (pid_t i = 0; i < NPROC; i++) {
   40227:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   4022b:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   4022f:	7e a2                	jle    401d3 <kernel+0x6c>
    }

    if (command && strcmp(command, "fork") == 0) {
   40231:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40236:	74 26                	je     4025e <kernel+0xf7>
   40238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4023c:	be 80 3f 04 00       	mov    $0x43f80,%esi
   40241:	48 89 c7             	mov    %rax,%rdi
   40244:	e8 82 34 00 00       	callq  436cb <strcmp>
   40249:	85 c0                	test   %eax,%eax
   4024b:	75 11                	jne    4025e <kernel+0xf7>
        process_setup(1, 4);
   4024d:	be 04 00 00 00       	mov    $0x4,%esi
   40252:	bf 01 00 00 00       	mov    $0x1,%edi
   40257:	e8 08 05 00 00       	callq  40764 <process_setup>
   4025c:	eb 52                	jmp    402b0 <kernel+0x149>
    } else if (command && strcmp(command, "forkexit") == 0) {
   4025e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40263:	74 26                	je     4028b <kernel+0x124>
   40265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40269:	be 85 3f 04 00       	mov    $0x43f85,%esi
   4026e:	48 89 c7             	mov    %rax,%rdi
   40271:	e8 55 34 00 00       	callq  436cb <strcmp>
   40276:	85 c0                	test   %eax,%eax
   40278:	75 11                	jne    4028b <kernel+0x124>
        process_setup(1, 5);
   4027a:	be 05 00 00 00       	mov    $0x5,%esi
   4027f:	bf 01 00 00 00       	mov    $0x1,%edi
   40284:	e8 db 04 00 00       	callq  40764 <process_setup>
   40289:	eb 25                	jmp    402b0 <kernel+0x149>
    } else {
        for (pid_t i = 1; i <= 4; ++i) {
   4028b:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
   40292:	eb 16                	jmp    402aa <kernel+0x143>
            process_setup(i, i - 1);
   40294:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40297:	8d 50 ff             	lea    -0x1(%rax),%edx
   4029a:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4029d:	89 d6                	mov    %edx,%esi
   4029f:	89 c7                	mov    %eax,%edi
   402a1:	e8 be 04 00 00       	callq  40764 <process_setup>
        for (pid_t i = 1; i <= 4; ++i) {
   402a6:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   402aa:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
   402ae:	7e e4                	jle    40294 <kernel+0x12d>
        }
    }

    // Switch to the first process using run()
    run(&processes[1]);
   402b0:	bf d8 d0 04 00       	mov    $0x4d0d8,%edi
   402b5:	e8 5a 0e 00 00       	callq  41114 <run>

00000000000402ba <FreePageAddr>:
}

// Return address of free page
uintptr_t FreePageAddr() {
   402ba:	55                   	push   %rbp
   402bb:	48 89 e5             	mov    %rsp,%rbp
   402be:	48 83 ec 10          	sub    $0x10,%rsp
    uintptr_t addr = PAGESIZE; // start address at element 1
   402c2:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
   402c9:	00 
    while(pageinfo[PAGENUMBER(addr)].refcount != 0) {
   402ca:	eb 32                	jmp    402fe <FreePageAddr+0x44>
        if (addr >= MEMSIZE_PHYSICAL) {
   402cc:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   402d3:	00 
   402d4:	76 20                	jbe    402f6 <FreePageAddr+0x3c>
            console_printf(CPOS(24, 0), 0x0C00, "FreePageAddr Failed\n");
   402d6:	ba 8e 3f 04 00       	mov    $0x43f8e,%edx
   402db:	be 00 0c 00 00       	mov    $0xc00,%esi
   402e0:	bf 80 07 00 00       	mov    $0x780,%edi
   402e5:	b8 00 00 00 00       	mov    $0x0,%eax
   402ea:	e8 ad 3b 00 00       	callq  43e9c <console_printf>
            return 0;
   402ef:	b8 00 00 00 00       	mov    $0x0,%eax
   402f4:	eb 38                	jmp    4032e <FreePageAddr+0x74>
        }
        addr += PAGESIZE; // increment address
   402f6:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   402fd:	00 
    while(pageinfo[PAGENUMBER(addr)].refcount != 0) {
   402fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40302:	48 c1 e8 0c          	shr    $0xc,%rax
   40306:	48 98                	cltq   
   40308:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   4030f:	00 
   40310:	84 c0                	test   %al,%al
   40312:	75 b8                	jne    402cc <FreePageAddr+0x12>
    }
    memset((void*)addr, 0, PAGESIZE); // reset page to empty
   40314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40318:	ba 00 10 00 00       	mov    $0x1000,%edx
   4031d:	be 00 00 00 00       	mov    $0x0,%esi
   40322:	48 89 c7             	mov    %rax,%rdi
   40325:	e8 34 33 00 00       	callq  4365e <memset>
    return addr;
   4032a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   4032e:	c9                   	leaveq 
   4032f:	c3                   	retq   

0000000000040330 <FreeProc>:

// Return pid of free slot in process array
pid_t FreeProc() {
   40330:	55                   	push   %rbp
   40331:	48 89 e5             	mov    %rsp,%rbp
   40334:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 1; i < NPROC; i++) {
   40338:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
   4033f:	eb 56                	jmp    40397 <FreeProc+0x67>
        if(processes[i].p_state == P_FREE) {
   40341:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40344:	48 63 d0             	movslq %eax,%rdx
   40347:	48 89 d0             	mov    %rdx,%rax
   4034a:	48 01 c0             	add    %rax,%rax
   4034d:	48 01 d0             	add    %rdx,%rax
   40350:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40357:	00 
   40358:	48 01 d0             	add    %rdx,%rax
   4035b:	48 c1 e0 03          	shl    $0x3,%rax
   4035f:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   40365:	8b 00                	mov    (%rax),%eax
   40367:	85 c0                	test   %eax,%eax
   40369:	75 28                	jne    40393 <FreeProc+0x63>
            return processes[i].p_pid;
   4036b:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4036e:	48 63 d0             	movslq %eax,%rdx
   40371:	48 89 d0             	mov    %rdx,%rax
   40374:	48 01 c0             	add    %rax,%rax
   40377:	48 01 d0             	add    %rdx,%rax
   4037a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40381:	00 
   40382:	48 01 d0             	add    %rdx,%rax
   40385:	48 c1 e0 03          	shl    $0x3,%rax
   40389:	48 05 00 d0 04 00    	add    $0x4d000,%rax
   4038f:	8b 00                	mov    (%rax),%eax
   40391:	eb 0f                	jmp    403a2 <FreeProc+0x72>
    for (int i = 1; i < NPROC; i++) {
   40393:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40397:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   4039b:	7e a4                	jle    40341 <FreeProc+0x11>
        }
    }
    return (pid_t) -1;
   4039d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
   403a2:	c9                   	leaveq 
   403a3:	c3                   	retq   

00000000000403a4 <AllocPT>:

proc_page_ptrs procs_PT[NPROC];

// Allocate page table
x86_64_pagetable** AllocPT(pid_t pid) {
   403a4:	55                   	push   %rbp
   403a5:	48 89 e5             	mov    %rsp,%rbp
   403a8:	48 83 ec 10          	sub    $0x10,%rsp
   403ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
    assert(pid < (NPROC + 1));
   403af:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
   403b3:	7e 14                	jle    403c9 <AllocPT+0x25>
   403b5:	ba a3 3f 04 00       	mov    $0x43fa3,%edx
   403ba:	be 8d 00 00 00       	mov    $0x8d,%esi
   403bf:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   403c4:	e8 d2 2d 00 00       	callq  4319b <assert_fail>
    memset(procs_PT[pid-1].pages, 0, sizeof(proc_page_ptrs));
   403c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
   403cc:	83 e8 01             	sub    $0x1,%eax
   403cf:	48 63 d0             	movslq %eax,%rdx
   403d2:	48 89 d0             	mov    %rdx,%rax
   403d5:	48 c1 e0 02          	shl    $0x2,%rax
   403d9:	48 01 d0             	add    %rdx,%rax
   403dc:	48 c1 e0 03          	shl    $0x3,%rax
   403e0:	48 05 40 60 05 00    	add    $0x56040,%rax
   403e6:	ba 28 00 00 00       	mov    $0x28,%edx
   403eb:	be 00 00 00 00       	mov    $0x0,%esi
   403f0:	48 89 c7             	mov    %rax,%rdi
   403f3:	e8 66 32 00 00       	callq  4365e <memset>
    return procs_PT[pid-1].pages;
   403f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
   403fb:	83 e8 01             	sub    $0x1,%eax
   403fe:	48 63 d0             	movslq %eax,%rdx
   40401:	48 89 d0             	mov    %rdx,%rax
   40404:	48 c1 e0 02          	shl    $0x2,%rax
   40408:	48 01 d0             	add    %rdx,%rax
   4040b:	48 c1 e0 03          	shl    $0x3,%rax
   4040f:	48 05 40 60 05 00    	add    $0x56040,%rax
}
   40415:	c9                   	leaveq 
   40416:	c3                   	retq   

0000000000040417 <ExitProcess>:


// Mark a process as free and free all of its memory
void ExitProcess(pid_t pid) {    
   40417:	55                   	push   %rbp
   40418:	48 89 e5             	mov    %rsp,%rbp
   4041b:	48 83 ec 18          	sub    $0x18,%rsp
   4041f:	89 7d ec             	mov    %edi,-0x14(%rbp)
    processes[pid].p_state = P_FREE; */


    //processes[pageinfo[addr].owner].p_state = P_FREE;

    for (uintptr_t addr = PAGESIZE; addr < MEMSIZE_PHYSICAL; (addr += PAGESIZE)) {
   40422:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
   40429:	00 
   4042a:	e9 8e 00 00 00       	jmpq   404bd <ExitProcess+0xa6>
        if (pageinfo[PAGENUMBER(addr)].owner == pid) {
   4042f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40433:	48 c1 e8 0c          	shr    $0xc,%rax
   40437:	48 98                	cltq   
   40439:	0f b6 84 00 a0 dd 04 	movzbl 0x4dda0(%rax,%rax,1),%eax
   40440:	00 
   40441:	0f be c0             	movsbl %al,%eax
   40444:	39 45 ec             	cmp    %eax,-0x14(%rbp)
   40447:	75 6c                	jne    404b5 <ExitProcess+0x9e>
            if (--pageinfo[PAGENUMBER(addr)].refcount == 0) {
   40449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4044d:	48 c1 e8 0c          	shr    $0xc,%rax
   40451:	48 63 d0             	movslq %eax,%rdx
   40454:	0f b6 94 12 a1 dd 04 	movzbl 0x4dda1(%rdx,%rdx,1),%edx
   4045b:	00 
   4045c:	83 ea 01             	sub    $0x1,%edx
   4045f:	89 d1                	mov    %edx,%ecx
   40461:	48 63 d0             	movslq %eax,%rdx
   40464:	88 8c 12 a1 dd 04 00 	mov    %cl,0x4dda1(%rdx,%rdx,1)
   4046b:	48 98                	cltq   
   4046d:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   40474:	00 
   40475:	84 c0                	test   %al,%al
   40477:	75 3c                	jne    404b5 <ExitProcess+0x9e>
                pageinfo[PAGENUMBER(addr)].owner = PO_FREE; // reset owner
   40479:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4047d:	48 c1 e8 0c          	shr    $0xc,%rax
   40481:	48 98                	cltq   
   40483:	c6 84 00 a0 dd 04 00 	movb   $0x0,0x4dda0(%rax,%rax,1)
   4048a:	00 
                processes[pid].p_state = P_FREE; // reset state
   4048b:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4048e:	48 63 d0             	movslq %eax,%rdx
   40491:	48 89 d0             	mov    %rdx,%rax
   40494:	48 01 c0             	add    %rax,%rax
   40497:	48 01 d0             	add    %rdx,%rax
   4049a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   404a1:	00 
   404a2:	48 01 d0             	add    %rdx,%rax
   404a5:	48 c1 e0 03          	shl    $0x3,%rax
   404a9:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   404af:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    for (uintptr_t addr = PAGESIZE; addr < MEMSIZE_PHYSICAL; (addr += PAGESIZE)) {
   404b5:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   404bc:	00 
   404bd:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   404c4:	00 
   404c5:	0f 86 64 ff ff ff    	jbe    4042f <ExitProcess+0x18>
            }
        }
    } 
}
   404cb:	90                   	nop
   404cc:	90                   	nop
   404cd:	c9                   	leaveq 
   404ce:	c3                   	retq   

00000000000404cf <CreateProcess>:


// Given pid, create page table with mappings of memory before PROC_START_ADDR
x86_64_pagetable* CreateProcess(pid_t pid) {
   404cf:	55                   	push   %rbp
   404d0:	48 89 e5             	mov    %rsp,%rbp
   404d3:	48 83 ec 60          	sub    $0x60,%rsp
   404d7:	89 7d ac             	mov    %edi,-0x54(%rbp)
    process_init(&processes[pid], 0);
   404da:	8b 45 ac             	mov    -0x54(%rbp),%eax
   404dd:	48 63 d0             	movslq %eax,%rdx
   404e0:	48 89 d0             	mov    %rdx,%rax
   404e3:	48 01 c0             	add    %rax,%rax
   404e6:	48 01 d0             	add    %rdx,%rax
   404e9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   404f0:	00 
   404f1:	48 01 d0             	add    %rdx,%rax
   404f4:	48 c1 e0 03          	shl    $0x3,%rax
   404f8:	48 05 00 d0 04 00    	add    $0x4d000,%rax
   404fe:	be 00 00 00 00       	mov    $0x0,%esi
   40503:	48 89 c7             	mov    %rax,%rdi
   40506:	e8 00 25 00 00       	callq  42a0b <process_init>

    // Create page table
    x86_64_pagetable** proc_pages = AllocPT(pid);
   4050b:	8b 45 ac             	mov    -0x54(%rbp),%eax
   4050e:	89 c7                	mov    %eax,%edi
   40510:	e8 8f fe ff ff       	callq  403a4 <AllocPT>
   40515:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

    for (int i = 0; i < 5; i++) {
   40519:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   40520:	e9 eb 00 00 00       	jmpq   40610 <CreateProcess+0x141>
        proc_pages[i] = (x86_64_pagetable*) FreePageAddr();
   40525:	b8 00 00 00 00       	mov    $0x0,%eax
   4052a:	e8 8b fd ff ff       	callq  402ba <FreePageAddr>
   4052f:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40532:	48 63 d2             	movslq %edx,%rdx
   40535:	48 8d 0c d5 00 00 00 	lea    0x0(,%rdx,8),%rcx
   4053c:	00 
   4053d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40541:	48 01 ca             	add    %rcx,%rdx
   40544:	48 89 02             	mov    %rax,(%rdx)
        if (proc_pages[i] == (uintptr_t) 0) {
   40547:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4054a:	48 98                	cltq   
   4054c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40553:	00 
   40554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40558:	48 01 d0             	add    %rdx,%rax
   4055b:	48 8b 00             	mov    (%rax),%rax
   4055e:	48 85 c0             	test   %rax,%rax
   40561:	75 2f                	jne    40592 <CreateProcess+0xc3>
            console_printf(CPOS(24, 0), 0x0C00, "Out of physical memory!\n");
   40563:	ba be 3f 04 00       	mov    $0x43fbe,%edx
   40568:	be 00 0c 00 00       	mov    $0xc00,%esi
   4056d:	bf 80 07 00 00       	mov    $0x780,%edi
   40572:	b8 00 00 00 00       	mov    $0x0,%eax
   40577:	e8 20 39 00 00       	callq  43e9c <console_printf>
            ExitProcess(pid);
   4057c:	8b 45 ac             	mov    -0x54(%rbp),%eax
   4057f:	89 c7                	mov    %eax,%edi
   40581:	e8 91 fe ff ff       	callq  40417 <ExitProcess>
            return (x86_64_pagetable*) -1;
   40586:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
   4058d:	e9 d0 01 00 00       	jmpq   40762 <CreateProcess+0x293>
        }
        pageinfo[PAGENUMBER(proc_pages[i])].owner = pid; // reserve pages
   40592:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40595:	48 98                	cltq   
   40597:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   4059e:	00 
   4059f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   405a3:	48 01 d0             	add    %rdx,%rax
   405a6:	48 8b 00             	mov    (%rax),%rax
   405a9:	48 c1 e8 0c          	shr    $0xc,%rax
   405ad:	89 c1                	mov    %eax,%ecx
   405af:	8b 45 ac             	mov    -0x54(%rbp),%eax
   405b2:	89 c2                	mov    %eax,%edx
   405b4:	48 63 c1             	movslq %ecx,%rax
   405b7:	88 94 00 a0 dd 04 00 	mov    %dl,0x4dda0(%rax,%rax,1)
        pageinfo[PAGENUMBER(proc_pages[i])].refcount = 1;
   405be:	8b 45 fc             	mov    -0x4(%rbp),%eax
   405c1:	48 98                	cltq   
   405c3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   405ca:	00 
   405cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   405cf:	48 01 d0             	add    %rdx,%rax
   405d2:	48 8b 00             	mov    (%rax),%rax
   405d5:	48 c1 e8 0c          	shr    $0xc,%rax
   405d9:	48 98                	cltq   
   405db:	c6 84 00 a1 dd 04 00 	movb   $0x1,0x4dda1(%rax,%rax,1)
   405e2:	01 
        memset(proc_pages[i], 0, PAGESIZE); // reset pages to empty
   405e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
   405e6:	48 98                	cltq   
   405e8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   405ef:	00 
   405f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   405f4:	48 01 d0             	add    %rdx,%rax
   405f7:	48 8b 00             	mov    (%rax),%rax
   405fa:	ba 00 10 00 00       	mov    $0x1000,%edx
   405ff:	be 00 00 00 00       	mov    $0x0,%esi
   40604:	48 89 c7             	mov    %rax,%rdi
   40607:	e8 52 30 00 00       	callq  4365e <memset>
    for (int i = 0; i < 5; i++) {
   4060c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40610:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
   40614:	0f 8e 0b ff ff ff    	jle    40525 <CreateProcess+0x56>
    }

    x86_64_pagetable* pml4 = proc_pages[0];
   4061a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4061e:	48 8b 00             	mov    (%rax),%rax
   40621:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    x86_64_pagetable* pdpt = proc_pages[1];
   40625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40629:	48 8b 40 08          	mov    0x8(%rax),%rax
   4062d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    x86_64_pagetable* pd = proc_pages[2];
   40631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40635:	48 8b 40 10          	mov    0x10(%rax),%rax
   40639:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    x86_64_pagetable* pt1 = proc_pages[3];
   4063d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40641:	48 8b 40 18          	mov    0x18(%rax),%rax
   40645:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    x86_64_pagetable* pt2 = proc_pages[4];
   40649:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4064d:	48 8b 40 20          	mov    0x20(%rax),%rax
   40651:	48 89 45 c8          	mov    %rax,-0x38(%rbp)

    pml4->entry[0] = (x86_64_pageentry_t)proc_pages[1] | PTE_P | PTE_W | PTE_U;
   40655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40659:	48 83 c0 08          	add    $0x8,%rax
   4065d:	48 8b 00             	mov    (%rax),%rax
   40660:	48 83 c8 07          	or     $0x7,%rax
   40664:	48 89 c2             	mov    %rax,%rdx
   40667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4066b:	48 89 10             	mov    %rdx,(%rax)
    pdpt->entry[0] = (x86_64_pageentry_t)proc_pages[2] | PTE_P | PTE_W | PTE_U;
   4066e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40672:	48 83 c0 10          	add    $0x10,%rax
   40676:	48 8b 00             	mov    (%rax),%rax
   40679:	48 83 c8 07          	or     $0x7,%rax
   4067d:	48 89 c2             	mov    %rax,%rdx
   40680:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40684:	48 89 10             	mov    %rdx,(%rax)
    pd->entry[0] = (x86_64_pageentry_t)proc_pages[3] | PTE_P | PTE_W | PTE_U;
   40687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4068b:	48 83 c0 18          	add    $0x18,%rax
   4068f:	48 8b 00             	mov    (%rax),%rax
   40692:	48 83 c8 07          	or     $0x7,%rax
   40696:	48 89 c2             	mov    %rax,%rdx
   40699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4069d:	48 89 10             	mov    %rdx,(%rax)
    pd->entry[1] = (x86_64_pageentry_t)proc_pages[4] | PTE_P | PTE_W | PTE_U;
   406a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   406a4:	48 83 c0 20          	add    $0x20,%rax
   406a8:	48 8b 00             	mov    (%rax),%rax
   406ab:	48 83 c8 07          	or     $0x7,%rax
   406af:	48 89 c2             	mov    %rax,%rdx
   406b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   406b6:	48 89 50 08          	mov    %rdx,0x8(%rax)

    for(int va = 0; va < PROC_START_ADDR; (va = va + PAGESIZE)) {
   406ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   406c1:	e9 8b 00 00 00       	jmpq   40751 <CreateProcess+0x282>
        vamapping temp = virtual_memory_lookup(pml4, va);
   406c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
   406c9:	48 63 d0             	movslq %eax,%rdx
   406cc:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   406d0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   406d4:	48 89 ce             	mov    %rcx,%rsi
   406d7:	48 89 c7             	mov    %rax,%rdi
   406da:	e8 3f 1f 00 00       	callq  4261e <virtual_memory_lookup>
        if (temp.pn == -1) { // not mapped
   406df:	8b 45 b0             	mov    -0x50(%rbp),%eax
   406e2:	83 f8 ff             	cmp    $0xffffffff,%eax
   406e5:	75 63                	jne    4074a <CreateProcess+0x27b>
            if ((uintptr_t)va == CONSOLE_ADDR) {
   406e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
   406ea:	48 98                	cltq   
   406ec:	ba 00 80 0b 00       	mov    $0xb8000,%edx
   406f1:	48 39 d0             	cmp    %rdx,%rax
   406f4:	75 2b                	jne    40721 <CreateProcess+0x252>
                virtual_memory_map(pml4, va, va, PAGESIZE, PTE_P| PTE_W| PTE_U, NULL);
   406f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
   406f9:	48 63 d0             	movslq %eax,%rdx
   406fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
   406ff:	48 63 f0             	movslq %eax,%rsi
   40702:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40706:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   4070c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   40712:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40717:	48 89 c7             	mov    %rax,%rdi
   4071a:	e8 08 1b 00 00       	callq  42227 <virtual_memory_map>
   4071f:	eb 29                	jmp    4074a <CreateProcess+0x27b>
            } else {
                virtual_memory_map(pml4, va, va, PAGESIZE, PTE_P| PTE_W, NULL);
   40721:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40724:	48 63 d0             	movslq %eax,%rdx
   40727:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4072a:	48 63 f0             	movslq %eax,%rsi
   4072d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40731:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40737:	41 b8 03 00 00 00    	mov    $0x3,%r8d
   4073d:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40742:	48 89 c7             	mov    %rax,%rdi
   40745:	e8 dd 1a 00 00       	callq  42227 <virtual_memory_map>
    for(int va = 0; va < PROC_START_ADDR; (va = va + PAGESIZE)) {
   4074a:	81 45 f8 00 10 00 00 	addl   $0x1000,-0x8(%rbp)
   40751:	81 7d f8 ff ff 0f 00 	cmpl   $0xfffff,-0x8(%rbp)
   40758:	0f 8e 68 ff ff ff    	jle    406c6 <CreateProcess+0x1f7>
            }
        }
    }
    return pml4;
   4075e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   40762:	c9                   	leaveq 
   40763:	c3                   	retq   

0000000000040764 <process_setup>:
// process_setup(pid, program_number)
//    Load application program `program_number` as process number `pid`.
//    This loads the application's code and data into memory, sets its
//    %rip and %rsp, gives it a stack page, and marks it as runnable.

void process_setup(pid_t pid, int program_number) {
   40764:	55                   	push   %rbp
   40765:	48 89 e5             	mov    %rsp,%rbp
   40768:	48 83 ec 30          	sub    $0x30,%rsp
   4076c:	89 7d dc             	mov    %edi,-0x24(%rbp)
   4076f:	89 75 d8             	mov    %esi,-0x28(%rbp)
    
    x86_64_pagetable* pml4 = CreateProcess(pid);
   40772:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40775:	89 c7                	mov    %eax,%edi
   40777:	e8 53 fd ff ff       	callq  404cf <CreateProcess>
   4077c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (pml4 == (x86_64_pagetable*) -1) { // out of memory - cannot complete process setup
   40780:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
   40785:	0f 84 78 01 00 00    	je     40903 <process_setup+0x19f>
        return;
    }

    processes[pid].p_pagetable = pml4;
   4078b:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4078e:	48 63 d0             	movslq %eax,%rdx
   40791:	48 89 d0             	mov    %rdx,%rax
   40794:	48 01 c0             	add    %rax,%rax
   40797:	48 01 d0             	add    %rdx,%rax
   4079a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   407a1:	00 
   407a2:	48 01 d0             	add    %rdx,%rax
   407a5:	48 c1 e0 03          	shl    $0x3,%rax
   407a9:	48 8d 90 d0 d0 04 00 	lea    0x4d0d0(%rax),%rdx
   407b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   407b4:	48 89 02             	mov    %rax,(%rdx)
    int r = program_load(&processes[pid], program_number, NULL);
   407b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
   407ba:	48 63 d0             	movslq %eax,%rdx
   407bd:	48 89 d0             	mov    %rdx,%rax
   407c0:	48 01 c0             	add    %rax,%rax
   407c3:	48 01 d0             	add    %rdx,%rax
   407c6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   407cd:	00 
   407ce:	48 01 d0             	add    %rdx,%rax
   407d1:	48 c1 e0 03          	shl    $0x3,%rax
   407d5:	48 8d 88 00 d0 04 00 	lea    0x4d000(%rax),%rcx
   407dc:	8b 45 d8             	mov    -0x28(%rbp),%eax
   407df:	ba 00 00 00 00       	mov    $0x0,%edx
   407e4:	89 c6                	mov    %eax,%esi
   407e6:	48 89 cf             	mov    %rcx,%rdi
   407e9:	e8 dd 29 00 00       	callq  431cb <program_load>
   407ee:	89 45 f4             	mov    %eax,-0xc(%rbp)
    assert(r >= 0);
   407f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   407f5:	79 14                	jns    4080b <process_setup+0xa7>
   407f7:	ba d7 3f 04 00       	mov    $0x43fd7,%edx
   407fc:	be ff 00 00 00       	mov    $0xff,%esi
   40801:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   40806:	e8 90 29 00 00       	callq  4319b <assert_fail>
    processes[pid].p_registers.reg_rsp =  MEMSIZE_VIRTUAL;
   4080b:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4080e:	48 63 d0             	movslq %eax,%rdx
   40811:	48 89 d0             	mov    %rdx,%rax
   40814:	48 01 c0             	add    %rax,%rax
   40817:	48 01 d0             	add    %rdx,%rax
   4081a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40821:	00 
   40822:	48 01 d0             	add    %rdx,%rax
   40825:	48 c1 e0 03          	shl    $0x3,%rax
   40829:	48 05 b8 d0 04 00    	add    $0x4d0b8,%rax
   4082f:	48 c7 00 00 00 30 00 	movq   $0x300000,(%rax)
    uintptr_t stack_va = MEMSIZE_VIRTUAL - PAGESIZE;
   40836:	48 c7 45 e8 00 f0 2f 	movq   $0x2ff000,-0x18(%rbp)
   4083d:	00 
    uintptr_t stack_pa = FreePageAddr();
   4083e:	b8 00 00 00 00       	mov    $0x0,%eax
   40843:	e8 72 fa ff ff       	callq  402ba <FreePageAddr>
   40848:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    if (stack_pa == (uintptr_t) 0) {
   4084c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   40851:	75 28                	jne    4087b <process_setup+0x117>
        console_printf(CPOS(24, 0), 0x0C00, "Out of physical memory!\n");
   40853:	ba be 3f 04 00       	mov    $0x43fbe,%edx
   40858:	be 00 0c 00 00       	mov    $0xc00,%esi
   4085d:	bf 80 07 00 00       	mov    $0x780,%edi
   40862:	b8 00 00 00 00       	mov    $0x0,%eax
   40867:	e8 30 36 00 00       	callq  43e9c <console_printf>
        ExitProcess(pid);
   4086c:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4086f:	89 c7                	mov    %eax,%edi
   40871:	e8 a1 fb ff ff       	callq  40417 <ExitProcess>
        return;
   40876:	e9 89 00 00 00       	jmpq   40904 <process_setup+0x1a0>
    }
    assign_physical_page(stack_pa, pid);
   4087b:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4087e:	0f be d0             	movsbl %al,%edx
   40881:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40885:	89 d6                	mov    %edx,%esi
   40887:	48 89 c7             	mov    %rax,%rdi
   4088a:	e8 4d 04 00 00       	callq  40cdc <assign_physical_page>
    virtual_memory_map(processes[pid].p_pagetable, stack_va, stack_pa,
   4088f:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40892:	48 63 d0             	movslq %eax,%rdx
   40895:	48 89 d0             	mov    %rdx,%rax
   40898:	48 01 c0             	add    %rax,%rax
   4089b:	48 01 d0             	add    %rdx,%rax
   4089e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   408a5:	00 
   408a6:	48 01 d0             	add    %rdx,%rax
   408a9:	48 c1 e0 03          	shl    $0x3,%rax
   408ad:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   408b3:	48 8b 00             	mov    (%rax),%rax
   408b6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   408ba:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
   408be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   408c4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   408ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
   408cf:	48 89 c7             	mov    %rax,%rdi
   408d2:	e8 50 19 00 00       	callq  42227 <virtual_memory_map>
                       PAGESIZE, PTE_P | PTE_W | PTE_U, NULL);
    processes[pid].p_state = P_RUNNABLE; 
   408d7:	8b 45 dc             	mov    -0x24(%rbp),%eax
   408da:	48 63 d0             	movslq %eax,%rdx
   408dd:	48 89 d0             	mov    %rdx,%rax
   408e0:	48 01 c0             	add    %rax,%rax
   408e3:	48 01 d0             	add    %rdx,%rax
   408e6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   408ed:	00 
   408ee:	48 01 d0             	add    %rdx,%rax
   408f1:	48 c1 e0 03          	shl    $0x3,%rax
   408f5:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   408fb:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
   40901:	eb 01                	jmp    40904 <process_setup+0x1a0>
        return;
   40903:	90                   	nop
}
   40904:	c9                   	leaveq 
   40905:	c3                   	retq   

0000000000040906 <Fork>:

// complete Fork
int Fork(pid_t p_pid) {
   40906:	55                   	push   %rbp
   40907:	48 89 e5             	mov    %rsp,%rbp
   4090a:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
   4090e:	89 7d 8c             	mov    %edi,-0x74(%rbp)
    pid_t c_pid = FreeProc(); // child pid
   40911:	b8 00 00 00 00       	mov    $0x0,%eax
   40916:	e8 15 fa ff ff       	callq  40330 <FreeProc>
   4091b:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if (c_pid == -1) {
   4091e:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%rbp)
   40922:	75 0a                	jne    4092e <Fork+0x28>
        return -1; // no free slot in processes array
   40924:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   40929:	e9 ac 03 00 00       	jmpq   40cda <Fork+0x3d4>
    }

    x86_64_pagetable* c_pagetable = CreateProcess(c_pid); // child page table
   4092e:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40931:	89 c7                	mov    %eax,%edi
   40933:	e8 97 fb ff ff       	callq  404cf <CreateProcess>
   40938:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (c_pagetable== (x86_64_pagetable*) -1) { // out of memory - cannot complete process setup
   4093c:	48 83 7d f0 ff       	cmpq   $0xffffffffffffffff,-0x10(%rbp)
   40941:	75 0a                	jne    4094d <Fork+0x47>
        return -1;
   40943:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   40948:	e9 8d 03 00 00       	jmpq   40cda <Fork+0x3d4>
    }
    x86_64_pagetable* p_pagetable = processes[p_pid].p_pagetable; // parent page table
   4094d:	8b 45 8c             	mov    -0x74(%rbp),%eax
   40950:	48 63 d0             	movslq %eax,%rdx
   40953:	48 89 d0             	mov    %rdx,%rax
   40956:	48 01 c0             	add    %rax,%rax
   40959:	48 01 d0             	add    %rdx,%rax
   4095c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40963:	00 
   40964:	48 01 d0             	add    %rdx,%rax
   40967:	48 c1 e0 03          	shl    $0x3,%rax
   4096b:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   40971:	48 8b 00             	mov    (%rax),%rax
   40974:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

    // map parents' data to child
    for(int va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; (va = va + PAGESIZE)) {
   40978:	c7 45 fc 00 00 10 00 	movl   $0x100000,-0x4(%rbp)
   4097f:	e9 65 01 00 00       	jmpq   40ae9 <Fork+0x1e3>
        vamapping c_map = virtual_memory_lookup(c_pagetable, va);
   40984:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40987:	48 63 d0             	movslq %eax,%rdx
   4098a:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   4098e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
   40992:	48 89 ce             	mov    %rcx,%rsi
   40995:	48 89 c7             	mov    %rax,%rdi
   40998:	e8 81 1c 00 00       	callq  4261e <virtual_memory_lookup>
        if (c_map.pn == -1) { // not mapped
   4099d:	8b 45 b0             	mov    -0x50(%rbp),%eax
   409a0:	83 f8 ff             	cmp    $0xffffffff,%eax
   409a3:	0f 85 39 01 00 00    	jne    40ae2 <Fork+0x1dc>
            vamapping p_map = virtual_memory_lookup(p_pagetable, va);
   409a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
   409ac:	48 63 d0             	movslq %eax,%rdx
   409af:	48 8d 45 98          	lea    -0x68(%rbp),%rax
   409b3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   409b7:	48 89 ce             	mov    %rcx,%rsi
   409ba:	48 89 c7             	mov    %rax,%rdi
   409bd:	e8 5c 1c 00 00       	callq  4261e <virtual_memory_lookup>
            if ((p_map.perm & PTE_W)) {
   409c2:	8b 45 a8             	mov    -0x58(%rbp),%eax
   409c5:	48 98                	cltq   
   409c7:	83 e0 02             	and    $0x2,%eax
   409ca:	48 85 c0             	test   %rax,%rax
   409cd:	0f 84 bd 00 00 00    	je     40a90 <Fork+0x18a>
                uintptr_t c_pa = FreePageAddr(); // Allocate New Page
   409d3:	b8 00 00 00 00       	mov    $0x0,%eax
   409d8:	e8 dd f8 ff ff       	callq  402ba <FreePageAddr>
   409dd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
                if (c_pa == (uintptr_t) 0) {
   409e1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
   409e6:	75 2d                	jne    40a15 <Fork+0x10f>
                    console_printf(CPOS(24, 0), 0x0C00, "Out of physical memory!\n");
   409e8:	ba be 3f 04 00       	mov    $0x43fbe,%edx
   409ed:	be 00 0c 00 00       	mov    $0xc00,%esi
   409f2:	bf 80 07 00 00       	mov    $0x780,%edi
   409f7:	b8 00 00 00 00       	mov    $0x0,%eax
   409fc:	e8 9b 34 00 00       	callq  43e9c <console_printf>
                    ExitProcess(c_pid);
   40a01:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40a04:	89 c7                	mov    %eax,%edi
   40a06:	e8 0c fa ff ff       	callq  40417 <ExitProcess>
                    return -1;
   40a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   40a10:	e9 c5 02 00 00       	jmpq   40cda <Fork+0x3d4>
                }
                memset((void*)c_pa, 0, PAGESIZE); // reset pages to empty
   40a15:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40a19:	ba 00 10 00 00       	mov    $0x1000,%edx
   40a1e:	be 00 00 00 00       	mov    $0x0,%esi
   40a23:	48 89 c7             	mov    %rax,%rdi
   40a26:	e8 33 2c 00 00       	callq  4365e <memset>

                int r = assign_physical_page(c_pa, c_pid);
   40a2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40a2e:	0f be d0             	movsbl %al,%edx
   40a31:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40a35:	89 d6                	mov    %edx,%esi
   40a37:	48 89 c7             	mov    %rax,%rdi
   40a3a:	e8 9d 02 00 00       	callq  40cdc <assign_physical_page>
   40a3f:	89 45 cc             	mov    %eax,-0x34(%rbp)
                if (r >= 0) {
   40a42:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
   40a46:	0f 88 96 00 00 00    	js     40ae2 <Fork+0x1dc>
                    memcpy((x86_64_pagetable*)c_pa, (x86_64_pagetable*)p_map.pa, PAGESIZE);
   40a4c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   40a50:	48 89 c1             	mov    %rax,%rcx
   40a53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40a57:	ba 00 10 00 00       	mov    $0x1000,%edx
   40a5c:	48 89 ce             	mov    %rcx,%rsi
   40a5f:	48 89 c7             	mov    %rax,%rdi
   40a62:	e8 8e 2b 00 00       	callq  435f5 <memcpy>
                    virtual_memory_map(c_pagetable, va, c_pa, PAGESIZE, p_map.perm, NULL);
   40a67:	8b 4d a8             	mov    -0x58(%rbp),%ecx
   40a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40a6d:	48 63 f0             	movslq %eax,%rsi
   40a70:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   40a74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40a78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40a7e:	41 89 c8             	mov    %ecx,%r8d
   40a81:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40a86:	48 89 c7             	mov    %rax,%rdi
   40a89:	e8 99 17 00 00       	callq  42227 <virtual_memory_map>
   40a8e:	eb 52                	jmp    40ae2 <Fork+0x1dc>
                }
            } else if (p_map.perm) {
   40a90:	8b 45 a8             	mov    -0x58(%rbp),%eax
   40a93:	85 c0                	test   %eax,%eax
   40a95:	74 4b                	je     40ae2 <Fork+0x1dc>
                //log_printf("increased refcount for page %d in process %d\n", p_map.pn, p_pid);
                pageinfo[PAGENUMBER(p_map.pa)].refcount++; // increment ref count
   40a97:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   40a9b:	48 c1 e8 0c          	shr    $0xc,%rax
   40a9f:	89 c2                	mov    %eax,%edx
   40aa1:	48 63 c2             	movslq %edx,%rax
   40aa4:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   40aab:	00 
   40aac:	83 c0 01             	add    $0x1,%eax
   40aaf:	89 c1                	mov    %eax,%ecx
   40ab1:	48 63 c2             	movslq %edx,%rax
   40ab4:	88 8c 00 a1 dd 04 00 	mov    %cl,0x4dda1(%rax,%rax,1)
                //log_printf("\trefcount now %d\n", pageinfo[PAGENUMBER(p_map.pa)].refcount);
                virtual_memory_map(c_pagetable, va, p_map.pa, PAGESIZE, p_map.perm, NULL);
   40abb:	8b 4d a8             	mov    -0x58(%rbp),%ecx
   40abe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
   40ac2:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40ac5:	48 63 f0             	movslq %eax,%rsi
   40ac8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40acc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40ad2:	41 89 c8             	mov    %ecx,%r8d
   40ad5:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40ada:	48 89 c7             	mov    %rax,%rdi
   40add:	e8 45 17 00 00       	callq  42227 <virtual_memory_map>
    for(int va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; (va = va + PAGESIZE)) {
   40ae2:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
   40ae9:	81 7d fc ff ff 2f 00 	cmpl   $0x2fffff,-0x4(%rbp)
   40af0:	0f 8e 8e fe ff ff    	jle    40984 <Fork+0x7e>
            } 
        }
    }

    // copy registers
    memcpy(&processes[c_pid].p_registers, &processes[p_pid].p_registers, sizeof(x86_64_registers));
   40af6:	8b 45 8c             	mov    -0x74(%rbp),%eax
   40af9:	48 63 d0             	movslq %eax,%rdx
   40afc:	48 89 d0             	mov    %rdx,%rax
   40aff:	48 01 c0             	add    %rax,%rax
   40b02:	48 01 d0             	add    %rdx,%rax
   40b05:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40b0c:	00 
   40b0d:	48 01 d0             	add    %rdx,%rax
   40b10:	48 c1 e0 03          	shl    $0x3,%rax
   40b14:	48 05 00 d0 04 00    	add    $0x4d000,%rax
   40b1a:	48 8d 48 08          	lea    0x8(%rax),%rcx
   40b1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40b21:	48 63 d0             	movslq %eax,%rdx
   40b24:	48 89 d0             	mov    %rdx,%rax
   40b27:	48 01 c0             	add    %rax,%rax
   40b2a:	48 01 d0             	add    %rdx,%rax
   40b2d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40b34:	00 
   40b35:	48 01 d0             	add    %rdx,%rax
   40b38:	48 c1 e0 03          	shl    $0x3,%rax
   40b3c:	48 05 00 d0 04 00    	add    $0x4d000,%rax
   40b42:	48 83 c0 08          	add    $0x8,%rax
   40b46:	ba c0 00 00 00       	mov    $0xc0,%edx
   40b4b:	48 89 ce             	mov    %rcx,%rsi
   40b4e:	48 89 c7             	mov    %rax,%rdi
   40b51:	e8 9f 2a 00 00       	callq  435f5 <memcpy>

    processes[c_pid].p_pagetable = c_pagetable;
   40b56:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40b59:	48 63 d0             	movslq %eax,%rdx
   40b5c:	48 89 d0             	mov    %rdx,%rax
   40b5f:	48 01 c0             	add    %rax,%rax
   40b62:	48 01 d0             	add    %rdx,%rax
   40b65:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40b6c:	00 
   40b6d:	48 01 d0             	add    %rdx,%rax
   40b70:	48 c1 e0 03          	shl    $0x3,%rax
   40b74:	48 8d 90 d0 d0 04 00 	lea    0x4d0d0(%rax),%rdx
   40b7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40b7f:	48 89 02             	mov    %rax,(%rdx)
    processes[c_pid].p_registers.reg_rsp =  MEMSIZE_VIRTUAL;
   40b82:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40b85:	48 63 d0             	movslq %eax,%rdx
   40b88:	48 89 d0             	mov    %rdx,%rax
   40b8b:	48 01 c0             	add    %rax,%rax
   40b8e:	48 01 d0             	add    %rdx,%rax
   40b91:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40b98:	00 
   40b99:	48 01 d0             	add    %rdx,%rax
   40b9c:	48 c1 e0 03          	shl    $0x3,%rax
   40ba0:	48 05 b8 d0 04 00    	add    $0x4d0b8,%rax
   40ba6:	48 c7 00 00 00 30 00 	movq   $0x300000,(%rax)
    uintptr_t stack_va = MEMSIZE_VIRTUAL - PAGESIZE;
   40bad:	48 c7 45 e0 00 f0 2f 	movq   $0x2ff000,-0x20(%rbp)
   40bb4:	00 
    uintptr_t stack_pa = FreePageAddr();
   40bb5:	b8 00 00 00 00       	mov    $0x0,%eax
   40bba:	e8 fb f6 ff ff       	callq  402ba <FreePageAddr>
   40bbf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    if (stack_pa == (uintptr_t) 0) {
   40bc3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   40bc8:	75 2d                	jne    40bf7 <Fork+0x2f1>
        console_printf(CPOS(24, 0), 0x0C00, "Out of physical memory!\n");
   40bca:	ba be 3f 04 00       	mov    $0x43fbe,%edx
   40bcf:	be 00 0c 00 00       	mov    $0xc00,%esi
   40bd4:	bf 80 07 00 00       	mov    $0x780,%edi
   40bd9:	b8 00 00 00 00       	mov    $0x0,%eax
   40bde:	e8 b9 32 00 00       	callq  43e9c <console_printf>
        ExitProcess(c_pid);
   40be3:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40be6:	89 c7                	mov    %eax,%edi
   40be8:	e8 2a f8 ff ff       	callq  40417 <ExitProcess>
        return -1;
   40bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   40bf2:	e9 e3 00 00 00       	jmpq   40cda <Fork+0x3d4>
    }
    assign_physical_page(stack_pa, c_pid);
   40bf7:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40bfa:	0f be d0             	movsbl %al,%edx
   40bfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40c01:	89 d6                	mov    %edx,%esi
   40c03:	48 89 c7             	mov    %rax,%rdi
   40c06:	e8 d1 00 00 00       	callq  40cdc <assign_physical_page>
    virtual_memory_map(processes[c_pid].p_pagetable, stack_va, stack_pa,
   40c0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40c0e:	48 63 d0             	movslq %eax,%rdx
   40c11:	48 89 d0             	mov    %rdx,%rax
   40c14:	48 01 c0             	add    %rax,%rax
   40c17:	48 01 d0             	add    %rdx,%rax
   40c1a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40c21:	00 
   40c22:	48 01 d0             	add    %rdx,%rax
   40c25:	48 c1 e0 03          	shl    $0x3,%rax
   40c29:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   40c2f:	48 8b 00             	mov    (%rax),%rax
   40c32:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   40c36:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
   40c3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40c40:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   40c46:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40c4b:	48 89 c7             	mov    %rax,%rdi
   40c4e:	e8 d4 15 00 00       	callq  42227 <virtual_memory_map>
                       PAGESIZE, PTE_P | PTE_W | PTE_U, NULL);
    processes[c_pid].p_state = P_RUNNABLE; 
   40c53:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40c56:	48 63 d0             	movslq %eax,%rdx
   40c59:	48 89 d0             	mov    %rdx,%rax
   40c5c:	48 01 c0             	add    %rax,%rax
   40c5f:	48 01 d0             	add    %rdx,%rax
   40c62:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40c69:	00 
   40c6a:	48 01 d0             	add    %rdx,%rax
   40c6d:	48 c1 e0 03          	shl    $0x3,%rax
   40c71:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   40c77:	c7 00 01 00 00 00    	movl   $0x1,(%rax)

    // "On success, return the child's process ID to the parent, and return 0 to the child"
    (processes[p_pid].p_registers).reg_rax = c_pid;
   40c7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40c80:	48 63 c8             	movslq %eax,%rcx
   40c83:	8b 45 8c             	mov    -0x74(%rbp),%eax
   40c86:	48 63 d0             	movslq %eax,%rdx
   40c89:	48 89 d0             	mov    %rdx,%rax
   40c8c:	48 01 c0             	add    %rax,%rax
   40c8f:	48 01 d0             	add    %rdx,%rax
   40c92:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40c99:	00 
   40c9a:	48 01 d0             	add    %rdx,%rax
   40c9d:	48 c1 e0 03          	shl    $0x3,%rax
   40ca1:	48 05 08 d0 04 00    	add    $0x4d008,%rax
   40ca7:	48 89 08             	mov    %rcx,(%rax)
    (processes[c_pid].p_registers).reg_rax = 0;
   40caa:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40cad:	48 63 d0             	movslq %eax,%rdx
   40cb0:	48 89 d0             	mov    %rdx,%rax
   40cb3:	48 01 c0             	add    %rax,%rax
   40cb6:	48 01 d0             	add    %rdx,%rax
   40cb9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40cc0:	00 
   40cc1:	48 01 d0             	add    %rdx,%rax
   40cc4:	48 c1 e0 03          	shl    $0x3,%rax
   40cc8:	48 05 08 d0 04 00    	add    $0x4d008,%rax
   40cce:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

    return 1;
   40cd5:	b8 01 00 00 00       	mov    $0x1,%eax
} 
   40cda:	c9                   	leaveq 
   40cdb:	c3                   	retq   

0000000000040cdc <assign_physical_page>:
// assign_physical_page(addr, owner)
//    Allocates the page with physical address `addr` to the given owner.
//    Fails if physical page `addr` was already allocated. Returns 0 on
//    success and -1 on failure. Used by the program loader.

int assign_physical_page(uintptr_t addr, int8_t owner) {
   40cdc:	55                   	push   %rbp
   40cdd:	48 89 e5             	mov    %rsp,%rbp
   40ce0:	48 83 ec 10          	sub    $0x10,%rsp
   40ce4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   40ce8:	89 f0                	mov    %esi,%eax
   40cea:	88 45 f4             	mov    %al,-0xc(%rbp)
    if ((addr & 0xFFF) != 0
   40ced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40cf1:	25 ff 0f 00 00       	and    $0xfff,%eax
   40cf6:	48 85 c0             	test   %rax,%rax
   40cf9:	75 20                	jne    40d1b <assign_physical_page+0x3f>
        || addr >= MEMSIZE_PHYSICAL
   40cfb:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   40d02:	00 
   40d03:	77 16                	ja     40d1b <assign_physical_page+0x3f>
        || pageinfo[PAGENUMBER(addr)].refcount != 0) {
   40d05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40d09:	48 c1 e8 0c          	shr    $0xc,%rax
   40d0d:	48 98                	cltq   
   40d0f:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   40d16:	00 
   40d17:	84 c0                	test   %al,%al
   40d19:	74 07                	je     40d22 <assign_physical_page+0x46>
        return -1;
   40d1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   40d20:	eb 2c                	jmp    40d4e <assign_physical_page+0x72>
    } else {
        pageinfo[PAGENUMBER(addr)].refcount = 1;
   40d22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40d26:	48 c1 e8 0c          	shr    $0xc,%rax
   40d2a:	48 98                	cltq   
   40d2c:	c6 84 00 a1 dd 04 00 	movb   $0x1,0x4dda1(%rax,%rax,1)
   40d33:	01 
        pageinfo[PAGENUMBER(addr)].owner = owner;
   40d34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40d38:	48 c1 e8 0c          	shr    $0xc,%rax
   40d3c:	48 98                	cltq   
   40d3e:	0f b6 55 f4          	movzbl -0xc(%rbp),%edx
   40d42:	88 94 00 a0 dd 04 00 	mov    %dl,0x4dda0(%rax,%rax,1)
        return 0;
   40d49:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   40d4e:	c9                   	leaveq 
   40d4f:	c3                   	retq   

0000000000040d50 <exception>:
//    k-exception.S). That code saves more registers on the kernel's stack,
//    then calls exception().
//
//    Note that hardware interrupts are disabled whenever the kernel is running.

void exception(x86_64_registers* reg) {
   40d50:	55                   	push   %rbp
   40d51:	48 89 e5             	mov    %rsp,%rbp
   40d54:	48 83 ec 50          	sub    $0x50,%rsp
   40d58:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
    // Copy the saved registers into the `current` process descriptor
    // and always use the kernel's page table.
    current->p_registers = *reg;
   40d5c:	48 8b 05 bd 52 01 00 	mov    0x152bd(%rip),%rax        # 56020 <current>
   40d63:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   40d67:	48 83 c0 08          	add    $0x8,%rax
   40d6b:	48 89 d6             	mov    %rdx,%rsi
   40d6e:	ba 18 00 00 00       	mov    $0x18,%edx
   40d73:	48 89 c7             	mov    %rax,%rdi
   40d76:	48 89 d1             	mov    %rdx,%rcx
   40d79:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    set_pagetable(kernel_pagetable);
   40d7c:	48 8b 05 3d 55 01 00 	mov    0x1553d(%rip),%rax        # 562c0 <kernel_pagetable>
   40d83:	48 89 c7             	mov    %rax,%rdi
   40d86:	e8 8a 19 00 00       	callq  42715 <set_pagetable>
    // Events logged this way are stored in the host's `log.txt` file.
    /*log_printf("proc %d: exception %d\n", current->p_pid, reg->reg_intno);*/

    // Show the current cursor location and memory state
    // (unless this is a kernel fault).
    console_show_cursor(cursorpos);
   40d8b:	8b 05 6b 82 07 00    	mov    0x7826b(%rip),%eax        # b8ffc <cursorpos>
   40d91:	89 c7                	mov    %eax,%edi
   40d93:	e8 32 1d 00 00       	callq  42aca <console_show_cursor>
    if (reg->reg_intno != INT_PAGEFAULT || (reg->reg_err & PFERR_USER)) {
   40d98:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40d9c:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   40da3:	48 83 f8 0e          	cmp    $0xe,%rax
   40da7:	75 13                	jne    40dbc <exception+0x6c>
   40da9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40dad:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40db4:	83 e0 04             	and    $0x4,%eax
   40db7:	48 85 c0             	test   %rax,%rax
   40dba:	74 0f                	je     40dcb <exception+0x7b>
        check_virtual_memory();
   40dbc:	e8 5b 07 00 00       	callq  4151c <check_virtual_memory>
        memshow_physical();
   40dc1:	e8 7b 09 00 00       	callq  41741 <memshow_physical>
        memshow_virtual_animate();
   40dc6:	e8 86 0c 00 00       	callq  41a51 <memshow_virtual_animate>
    }

    // If Control-C was typed, exit the virtual machine.
    check_keyboard();
   40dcb:	e8 d5 21 00 00       	callq  42fa5 <check_keyboard>


    // Actually handle the exception.
    switch (reg->reg_intno) {
   40dd0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40dd4:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   40ddb:	48 83 e8 0e          	sub    $0xe,%rax
   40ddf:	48 83 f8 27          	cmp    $0x27,%rax
   40de3:	0f 87 58 02 00 00    	ja     41041 <exception+0x2f1>
   40de9:	48 8b 04 c5 90 40 04 	mov    0x44090(,%rax,8),%rax
   40df0:	00 
   40df1:	ff e0                	jmpq   *%rax

    case INT_SYS_PANIC:
        panic(NULL);
   40df3:	bf 00 00 00 00       	mov    $0x0,%edi
   40df8:	b8 00 00 00 00       	mov    $0x0,%eax
   40dfd:	e8 b9 22 00 00       	callq  430bb <panic>
        break;                  // will not be reached

    case INT_SYS_GETPID:
        current->p_registers.reg_rax = current->p_pid;
   40e02:	48 8b 05 17 52 01 00 	mov    0x15217(%rip),%rax        # 56020 <current>
   40e09:	8b 10                	mov    (%rax),%edx
   40e0b:	48 8b 05 0e 52 01 00 	mov    0x1520e(%rip),%rax        # 56020 <current>
   40e12:	48 63 d2             	movslq %edx,%rdx
   40e15:	48 89 50 08          	mov    %rdx,0x8(%rax)
        break;
   40e19:	e9 41 02 00 00       	jmpq   4105f <exception+0x30f>

    case INT_SYS_YIELD:
        schedule();
   40e1e:	e8 65 02 00 00       	callq  41088 <schedule>
        break;                  /* will not be reached */
   40e23:	e9 37 02 00 00       	jmpq   4105f <exception+0x30f>

    case INT_SYS_FORK:
        console_printf(CPOS(24, 0), 0x0C00, "Fork!\n");
   40e28:	ba de 3f 04 00       	mov    $0x43fde,%edx
   40e2d:	be 00 0c 00 00       	mov    $0xc00,%esi
   40e32:	bf 80 07 00 00       	mov    $0x780,%edi
   40e37:	b8 00 00 00 00       	mov    $0x0,%eax
   40e3c:	e8 5b 30 00 00       	callq  43e9c <console_printf>
        if (Fork(current->p_pid) == -1) {
   40e41:	48 8b 05 d8 51 01 00 	mov    0x151d8(%rip),%rax        # 56020 <current>
   40e48:	8b 00                	mov    (%rax),%eax
   40e4a:	89 c7                	mov    %eax,%edi
   40e4c:	e8 b5 fa ff ff       	callq  40906 <Fork>
   40e51:	83 f8 ff             	cmp    $0xffffffff,%eax
   40e54:	0f 85 04 02 00 00    	jne    4105e <exception+0x30e>
            current->p_registers.reg_rax = -1; // fork failed, return -1
   40e5a:	48 8b 05 bf 51 01 00 	mov    0x151bf(%rip),%rax        # 56020 <current>
   40e61:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40e68:	ff 
        }
        break;
   40e69:	e9 f0 01 00 00       	jmpq   4105e <exception+0x30e>

    case INT_SYS_PAGE_ALLOC: {
        uintptr_t addr = current->p_registers.reg_rdi;
   40e6e:	48 8b 05 ab 51 01 00 	mov    0x151ab(%rip),%rax        # 56020 <current>
   40e75:	48 8b 40 38          	mov    0x38(%rax),%rax
   40e79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        uintptr_t pa = FreePageAddr(); // physical address
   40e7d:	b8 00 00 00 00       	mov    $0x0,%eax
   40e82:	e8 33 f4 ff ff       	callq  402ba <FreePageAddr>
   40e87:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
        if (pa == (uintptr_t) 0) {
   40e8b:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   40e90:	75 2d                	jne    40ebf <exception+0x16f>
            console_printf(CPOS(24, 0), 0x0C00, "Out of physical memory!\n");
   40e92:	ba be 3f 04 00       	mov    $0x43fbe,%edx
   40e97:	be 00 0c 00 00       	mov    $0xc00,%esi
   40e9c:	bf 80 07 00 00       	mov    $0x780,%edi
   40ea1:	b8 00 00 00 00       	mov    $0x0,%eax
   40ea6:	e8 f1 2f 00 00       	callq  43e9c <console_printf>
            current->p_registers.reg_rax = -1;
   40eab:	48 8b 05 6e 51 01 00 	mov    0x1516e(%rip),%rax        # 56020 <current>
   40eb2:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40eb9:	ff 
            break;
   40eba:	e9 a0 01 00 00       	jmpq   4105f <exception+0x30f>
        }
        int r = assign_physical_page(pa, current->p_pid);
   40ebf:	48 8b 05 5a 51 01 00 	mov    0x1515a(%rip),%rax        # 56020 <current>
   40ec6:	8b 00                	mov    (%rax),%eax
   40ec8:	0f be d0             	movsbl %al,%edx
   40ecb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40ecf:	89 d6                	mov    %edx,%esi
   40ed1:	48 89 c7             	mov    %rax,%rdi
   40ed4:	e8 03 fe ff ff       	callq  40cdc <assign_physical_page>
   40ed9:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (r >= 0) {
   40edc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
   40ee0:	78 2f                	js     40f11 <exception+0x1c1>
            virtual_memory_map(current->p_pagetable, addr, pa,
   40ee2:	48 8b 05 37 51 01 00 	mov    0x15137(%rip),%rax        # 56020 <current>
   40ee9:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   40ef0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40ef4:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   40ef8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40efe:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   40f04:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40f09:	48 89 c7             	mov    %rax,%rdi
   40f0c:	e8 16 13 00 00       	callq  42227 <virtual_memory_map>
                               PAGESIZE, PTE_P | PTE_W | PTE_U, NULL);
        }
        current->p_registers.reg_rax = r;
   40f11:	48 8b 05 08 51 01 00 	mov    0x15108(%rip),%rax        # 56020 <current>
   40f18:	8b 55 ec             	mov    -0x14(%rbp),%edx
   40f1b:	48 63 d2             	movslq %edx,%rdx
   40f1e:	48 89 50 08          	mov    %rdx,0x8(%rax)
        break;
   40f22:	e9 38 01 00 00       	jmpq   4105f <exception+0x30f>
    }

    case INT_SYS_EXIT:
        ExitProcess(current->p_pid);
   40f27:	48 8b 05 f2 50 01 00 	mov    0x150f2(%rip),%rax        # 56020 <current>
   40f2e:	8b 00                	mov    (%rax),%eax
   40f30:	89 c7                	mov    %eax,%edi
   40f32:	e8 e0 f4 ff ff       	callq  40417 <ExitProcess>
        break;
   40f37:	e9 23 01 00 00       	jmpq   4105f <exception+0x30f>

    case INT_TIMER:
        ++ticks;
   40f3c:	8b 05 3e ce 00 00    	mov    0xce3e(%rip),%eax        # 4dd80 <ticks>
   40f42:	83 c0 01             	add    $0x1,%eax
   40f45:	89 05 35 ce 00 00    	mov    %eax,0xce35(%rip)        # 4dd80 <ticks>
        schedule();
   40f4b:	e8 38 01 00 00       	callq  41088 <schedule>
        break;                  /* will not be reached */
   40f50:	e9 0a 01 00 00       	jmpq   4105f <exception+0x30f>
    return val;
}

static inline uintptr_t rcr2(void) {
    uintptr_t val;
    asm volatile("movq %%cr2,%0" : "=r" (val));
   40f55:	0f 20 d0             	mov    %cr2,%rax
   40f58:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return val;
   40f5c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax

    case INT_PAGEFAULT: {
        // Analyze faulting address and access type.
        uintptr_t addr = rcr2();
   40f60:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        const char* operation = reg->reg_err & PFERR_WRITE
   40f64:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40f68:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40f6f:	83 e0 02             	and    $0x2,%eax
                ? "write" : "read";
   40f72:	48 85 c0             	test   %rax,%rax
   40f75:	74 07                	je     40f7e <exception+0x22e>
   40f77:	b8 e5 3f 04 00       	mov    $0x43fe5,%eax
   40f7c:	eb 05                	jmp    40f83 <exception+0x233>
   40f7e:	b8 eb 3f 04 00       	mov    $0x43feb,%eax
        const char* operation = reg->reg_err & PFERR_WRITE
   40f83:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
        const char* problem = reg->reg_err & PFERR_PRESENT
   40f87:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40f8b:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40f92:	83 e0 01             	and    $0x1,%eax
                ? "protection problem" : "missing page";
   40f95:	48 85 c0             	test   %rax,%rax
   40f98:	74 07                	je     40fa1 <exception+0x251>
   40f9a:	b8 f0 3f 04 00       	mov    $0x43ff0,%eax
   40f9f:	eb 05                	jmp    40fa6 <exception+0x256>
   40fa1:	b8 03 40 04 00       	mov    $0x44003,%eax
        const char* problem = reg->reg_err & PFERR_PRESENT
   40fa6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

        if (!(reg->reg_err & PFERR_USER)) {
   40faa:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40fae:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40fb5:	83 e0 04             	and    $0x4,%eax
   40fb8:	48 85 c0             	test   %rax,%rax
   40fbb:	75 2c                	jne    40fe9 <exception+0x299>
            panic("Kernel page fault for %p (%s %s, rip=%p)!\n",
   40fbd:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40fc1:	48 8b b0 98 00 00 00 	mov    0x98(%rax),%rsi
   40fc8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
   40fcc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   40fd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40fd4:	49 89 f0             	mov    %rsi,%r8
   40fd7:	48 89 c6             	mov    %rax,%rsi
   40fda:	bf 10 40 04 00       	mov    $0x44010,%edi
   40fdf:	b8 00 00 00 00       	mov    $0x0,%eax
   40fe4:	e8 d2 20 00 00       	callq  430bb <panic>
                  addr, operation, problem, reg->reg_rip);
        }
        console_printf(CPOS(24, 0), 0x0C00,
   40fe9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40fed:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
                       "Process %d page fault for %p (%s %s, rip=%p)!\n",
                       current->p_pid, addr, operation, problem, reg->reg_rip);
   40ff4:	48 8b 05 25 50 01 00 	mov    0x15025(%rip),%rax        # 56020 <current>
        console_printf(CPOS(24, 0), 0x0C00,
   40ffb:	8b 00                	mov    (%rax),%eax
   40ffd:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
   41001:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
   41005:	52                   	push   %rdx
   41006:	ff 75 d0             	pushq  -0x30(%rbp)
   41009:	49 89 f1             	mov    %rsi,%r9
   4100c:	49 89 c8             	mov    %rcx,%r8
   4100f:	89 c1                	mov    %eax,%ecx
   41011:	ba 40 40 04 00       	mov    $0x44040,%edx
   41016:	be 00 0c 00 00       	mov    $0xc00,%esi
   4101b:	bf 80 07 00 00       	mov    $0x780,%edi
   41020:	b8 00 00 00 00       	mov    $0x0,%eax
   41025:	e8 72 2e 00 00       	callq  43e9c <console_printf>
   4102a:	48 83 c4 10          	add    $0x10,%rsp
        current->p_state = P_BROKEN;
   4102e:	48 8b 05 eb 4f 01 00 	mov    0x14feb(%rip),%rax        # 56020 <current>
   41035:	c7 80 c8 00 00 00 03 	movl   $0x3,0xc8(%rax)
   4103c:	00 00 00 
        break;
   4103f:	eb 1e                	jmp    4105f <exception+0x30f>
    }

    default:
        panic("Unexpected exception %d!\n", reg->reg_intno);
   41041:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   41045:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   4104c:	48 89 c6             	mov    %rax,%rsi
   4104f:	bf 6f 40 04 00       	mov    $0x4406f,%edi
   41054:	b8 00 00 00 00       	mov    $0x0,%eax
   41059:	e8 5d 20 00 00       	callq  430bb <panic>
        break;
   4105e:	90                   	nop

    }


    // Return to the current process (or run something else).
    if (current->p_state == P_RUNNABLE) {
   4105f:	48 8b 05 ba 4f 01 00 	mov    0x14fba(%rip),%rax        # 56020 <current>
   41066:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
   4106c:	83 f8 01             	cmp    $0x1,%eax
   4106f:	75 0f                	jne    41080 <exception+0x330>
        run(current);
   41071:	48 8b 05 a8 4f 01 00 	mov    0x14fa8(%rip),%rax        # 56020 <current>
   41078:	48 89 c7             	mov    %rax,%rdi
   4107b:	e8 94 00 00 00       	callq  41114 <run>
    } else {
        schedule();
   41080:	e8 03 00 00 00       	callq  41088 <schedule>
    }
}
   41085:	90                   	nop
   41086:	c9                   	leaveq 
   41087:	c3                   	retq   

0000000000041088 <schedule>:

// schedule
//    Pick the next process to run and then run it.
//    If there are no runnable processes, spins forever.

void schedule(void) {
   41088:	55                   	push   %rbp
   41089:	48 89 e5             	mov    %rsp,%rbp
   4108c:	48 83 ec 10          	sub    $0x10,%rsp
    pid_t pid = current->p_pid;
   41090:	48 8b 05 89 4f 01 00 	mov    0x14f89(%rip),%rax        # 56020 <current>
   41097:	8b 00                	mov    (%rax),%eax
   41099:	89 45 fc             	mov    %eax,-0x4(%rbp)
    while (1) {
        pid = (pid + 1) % NPROC;
   4109c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4109f:	8d 50 01             	lea    0x1(%rax),%edx
   410a2:	89 d0                	mov    %edx,%eax
   410a4:	c1 f8 1f             	sar    $0x1f,%eax
   410a7:	c1 e8 1c             	shr    $0x1c,%eax
   410aa:	01 c2                	add    %eax,%edx
   410ac:	83 e2 0f             	and    $0xf,%edx
   410af:	29 c2                	sub    %eax,%edx
   410b1:	89 d0                	mov    %edx,%eax
   410b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (processes[pid].p_state == P_RUNNABLE) {
   410b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
   410b9:	48 63 d0             	movslq %eax,%rdx
   410bc:	48 89 d0             	mov    %rdx,%rax
   410bf:	48 01 c0             	add    %rax,%rax
   410c2:	48 01 d0             	add    %rdx,%rax
   410c5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   410cc:	00 
   410cd:	48 01 d0             	add    %rdx,%rax
   410d0:	48 c1 e0 03          	shl    $0x3,%rax
   410d4:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   410da:	8b 00                	mov    (%rax),%eax
   410dc:	83 f8 01             	cmp    $0x1,%eax
   410df:	75 2c                	jne    4110d <schedule+0x85>
            run(&processes[pid]);
   410e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
   410e4:	48 63 d0             	movslq %eax,%rdx
   410e7:	48 89 d0             	mov    %rdx,%rax
   410ea:	48 01 c0             	add    %rax,%rax
   410ed:	48 01 d0             	add    %rdx,%rax
   410f0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   410f7:	00 
   410f8:	48 01 d0             	add    %rdx,%rax
   410fb:	48 c1 e0 03          	shl    $0x3,%rax
   410ff:	48 05 00 d0 04 00    	add    $0x4d000,%rax
   41105:	48 89 c7             	mov    %rax,%rdi
   41108:	e8 07 00 00 00       	callq  41114 <run>
        }
        // If Control-C was typed, exit the virtual machine.
        check_keyboard();
   4110d:	e8 93 1e 00 00       	callq  42fa5 <check_keyboard>
        pid = (pid + 1) % NPROC;
   41112:	eb 88                	jmp    4109c <schedule+0x14>

0000000000041114 <run>:
//    Run process `p`. This means reloading all the registers from
//    `p->p_registers` using the `popal`, `popl`, and `iret` instructions.
//
//    As a side effect, sets `current = p`.

void run(proc* p) {
   41114:	55                   	push   %rbp
   41115:	48 89 e5             	mov    %rsp,%rbp
   41118:	48 83 ec 10          	sub    $0x10,%rsp
   4111c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    assert(p->p_state == P_RUNNABLE);
   41120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41124:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
   4112a:	83 f8 01             	cmp    $0x1,%eax
   4112d:	74 14                	je     41143 <run+0x2f>
   4112f:	ba d0 41 04 00       	mov    $0x441d0,%edx
   41134:	be f1 01 00 00       	mov    $0x1f1,%esi
   41139:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   4113e:	e8 58 20 00 00       	callq  4319b <assert_fail>
    current = p;
   41143:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41147:	48 89 05 d2 4e 01 00 	mov    %rax,0x14ed2(%rip)        # 56020 <current>

    // Load the process's current pagetable.
    set_pagetable(p->p_pagetable);
   4114e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41152:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   41159:	48 89 c7             	mov    %rax,%rdi
   4115c:	e8 b4 15 00 00       	callq  42715 <set_pagetable>

    // This function is defined in k-exception.S. It restores the process's
    // registers then jumps back to user mode.
    exception_return(&p->p_registers);
   41161:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41165:	48 83 c0 08          	add    $0x8,%rax
   41169:	48 89 c7             	mov    %rax,%rdi
   4116c:	e8 52 ef ff ff       	callq  400c3 <exception_return>

0000000000041171 <pageinfo_init>:


// pageinfo_init
//    Initialize the `pageinfo[]` array.

void pageinfo_init(void) {
   41171:	55                   	push   %rbp
   41172:	48 89 e5             	mov    %rsp,%rbp
   41175:	48 83 ec 10          	sub    $0x10,%rsp
    extern char end[];

    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   41179:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   41180:	00 
   41181:	e9 81 00 00 00       	jmpq   41207 <pageinfo_init+0x96>
        int owner;
        if (physical_memory_isreserved(addr)) {
   41186:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4118a:	48 89 c7             	mov    %rax,%rdi
   4118d:	e8 b4 16 00 00       	callq  42846 <physical_memory_isreserved>
   41192:	85 c0                	test   %eax,%eax
   41194:	74 09                	je     4119f <pageinfo_init+0x2e>
            owner = PO_RESERVED;
   41196:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%rbp)
   4119d:	eb 2f                	jmp    411ce <pageinfo_init+0x5d>
        } else if ((addr >= KERNEL_START_ADDR && addr < (uintptr_t) end)
   4119f:	48 81 7d f8 ff ff 03 	cmpq   $0x3ffff,-0x8(%rbp)
   411a6:	00 
   411a7:	76 0b                	jbe    411b4 <pageinfo_init+0x43>
   411a9:	b8 c8 62 05 00       	mov    $0x562c8,%eax
   411ae:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   411b2:	72 0a                	jb     411be <pageinfo_init+0x4d>
                   || addr == KERNEL_STACK_TOP - PAGESIZE) {
   411b4:	48 81 7d f8 00 f0 07 	cmpq   $0x7f000,-0x8(%rbp)
   411bb:	00 
   411bc:	75 09                	jne    411c7 <pageinfo_init+0x56>
            owner = PO_KERNEL;
   411be:	c7 45 f4 fe ff ff ff 	movl   $0xfffffffe,-0xc(%rbp)
   411c5:	eb 07                	jmp    411ce <pageinfo_init+0x5d>
        } else {
            owner = PO_FREE;
   411c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
        }
        pageinfo[PAGENUMBER(addr)].owner = owner;
   411ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   411d2:	48 c1 e8 0c          	shr    $0xc,%rax
   411d6:	89 c1                	mov    %eax,%ecx
   411d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
   411db:	89 c2                	mov    %eax,%edx
   411dd:	48 63 c1             	movslq %ecx,%rax
   411e0:	88 94 00 a0 dd 04 00 	mov    %dl,0x4dda0(%rax,%rax,1)
        pageinfo[PAGENUMBER(addr)].refcount = (owner != PO_FREE);
   411e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   411eb:	0f 95 c2             	setne  %dl
   411ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   411f2:	48 c1 e8 0c          	shr    $0xc,%rax
   411f6:	48 98                	cltq   
   411f8:	88 94 00 a1 dd 04 00 	mov    %dl,0x4dda1(%rax,%rax,1)
    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   411ff:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   41206:	00 
   41207:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   4120e:	00 
   4120f:	0f 86 71 ff ff ff    	jbe    41186 <pageinfo_init+0x15>
    }
}
   41215:	90                   	nop
   41216:	90                   	nop
   41217:	c9                   	leaveq 
   41218:	c3                   	retq   

0000000000041219 <check_page_table_mappings>:

// check_page_table_mappings
//    Check operating system invariants about kernel mappings for page
//    table `pt`. Panic if any of the invariants are false.

void check_page_table_mappings(x86_64_pagetable* pt) {
   41219:	55                   	push   %rbp
   4121a:	48 89 e5             	mov    %rsp,%rbp
   4121d:	48 83 ec 50          	sub    $0x50,%rsp
   41221:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
    extern char start_data[], end[];
    assert(PTE_ADDR(pt) == (uintptr_t) pt);
   41225:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   41229:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   4122f:	48 89 c2             	mov    %rax,%rdx
   41232:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   41236:	48 39 c2             	cmp    %rax,%rdx
   41239:	74 14                	je     4124f <check_page_table_mappings+0x36>
   4123b:	ba f0 41 04 00       	mov    $0x441f0,%edx
   41240:	be 1b 02 00 00       	mov    $0x21b,%esi
   41245:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   4124a:	e8 4c 1f 00 00       	callq  4319b <assert_fail>

    // kernel memory is identity mapped; data is writable
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   4124f:	48 c7 45 f8 00 00 04 	movq   $0x40000,-0x8(%rbp)
   41256:	00 
   41257:	e9 9a 00 00 00       	jmpq   412f6 <check_page_table_mappings+0xdd>
         va += PAGESIZE) {
        vamapping vam = virtual_memory_lookup(pt, va);
   4125c:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
   41260:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   41264:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   41268:	48 89 ce             	mov    %rcx,%rsi
   4126b:	48 89 c7             	mov    %rax,%rdi
   4126e:	e8 ab 13 00 00       	callq  4261e <virtual_memory_lookup>
        if (vam.pa != va) {
   41273:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   41277:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   4127b:	74 27                	je     412a4 <check_page_table_mappings+0x8b>
            console_printf(CPOS(22, 0), 0xC000, "%p vs %p\n", va, vam.pa);
   4127d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   41281:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41285:	49 89 d0             	mov    %rdx,%r8
   41288:	48 89 c1             	mov    %rax,%rcx
   4128b:	ba 0f 42 04 00       	mov    $0x4420f,%edx
   41290:	be 00 c0 00 00       	mov    $0xc000,%esi
   41295:	bf e0 06 00 00       	mov    $0x6e0,%edi
   4129a:	b8 00 00 00 00       	mov    $0x0,%eax
   4129f:	e8 f8 2b 00 00       	callq  43e9c <console_printf>
        }
        assert(vam.pa == va);
   412a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   412a8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   412ac:	74 14                	je     412c2 <check_page_table_mappings+0xa9>
   412ae:	ba 19 42 04 00       	mov    $0x44219,%edx
   412b3:	be 24 02 00 00       	mov    $0x224,%esi
   412b8:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   412bd:	e8 d9 1e 00 00       	callq  4319b <assert_fail>
        if (va >= (uintptr_t) start_data) {
   412c2:	b8 00 50 04 00       	mov    $0x45000,%eax
   412c7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   412cb:	72 21                	jb     412ee <check_page_table_mappings+0xd5>
            assert(vam.perm & PTE_W);
   412cd:	8b 45 d0             	mov    -0x30(%rbp),%eax
   412d0:	48 98                	cltq   
   412d2:	83 e0 02             	and    $0x2,%eax
   412d5:	48 85 c0             	test   %rax,%rax
   412d8:	75 14                	jne    412ee <check_page_table_mappings+0xd5>
   412da:	ba 26 42 04 00       	mov    $0x44226,%edx
   412df:	be 26 02 00 00       	mov    $0x226,%esi
   412e4:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   412e9:	e8 ad 1e 00 00       	callq  4319b <assert_fail>
         va += PAGESIZE) {
   412ee:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   412f5:	00 
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   412f6:	b8 c8 62 05 00       	mov    $0x562c8,%eax
   412fb:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   412ff:	0f 82 57 ff ff ff    	jb     4125c <check_page_table_mappings+0x43>
        }
    }

    // kernel stack is identity mapped and writable
    uintptr_t kstack = KERNEL_STACK_TOP - PAGESIZE;
   41305:	48 c7 45 f0 00 f0 07 	movq   $0x7f000,-0x10(%rbp)
   4130c:	00 
    vamapping vam = virtual_memory_lookup(pt, kstack);
   4130d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
   41311:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   41315:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   41319:	48 89 ce             	mov    %rcx,%rsi
   4131c:	48 89 c7             	mov    %rax,%rdi
   4131f:	e8 fa 12 00 00       	callq  4261e <virtual_memory_lookup>
    assert(vam.pa == kstack);
   41324:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41328:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
   4132c:	74 14                	je     41342 <check_page_table_mappings+0x129>
   4132e:	ba 37 42 04 00       	mov    $0x44237,%edx
   41333:	be 2d 02 00 00       	mov    $0x22d,%esi
   41338:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   4133d:	e8 59 1e 00 00       	callq  4319b <assert_fail>
    assert(vam.perm & PTE_W);
   41342:	8b 45 e8             	mov    -0x18(%rbp),%eax
   41345:	48 98                	cltq   
   41347:	83 e0 02             	and    $0x2,%eax
   4134a:	48 85 c0             	test   %rax,%rax
   4134d:	75 14                	jne    41363 <check_page_table_mappings+0x14a>
   4134f:	ba 26 42 04 00       	mov    $0x44226,%edx
   41354:	be 2e 02 00 00       	mov    $0x22e,%esi
   41359:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   4135e:	e8 38 1e 00 00       	callq  4319b <assert_fail>
}
   41363:	90                   	nop
   41364:	c9                   	leaveq 
   41365:	c3                   	retq   

0000000000041366 <check_page_table_ownership>:
//    counts for page table `pt`. Panic if any of the invariants are false.

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount);

void check_page_table_ownership(x86_64_pagetable* pt, pid_t pid) {
   41366:	55                   	push   %rbp
   41367:	48 89 e5             	mov    %rsp,%rbp
   4136a:	48 83 ec 20          	sub    $0x20,%rsp
   4136e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   41372:	89 75 e4             	mov    %esi,-0x1c(%rbp)
    // calculate expected reference count for page tables
    int owner = pid;
   41375:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   41378:	89 45 fc             	mov    %eax,-0x4(%rbp)
    int expected_refcount = 1;
   4137b:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
    if (pt == kernel_pagetable) {
   41382:	48 8b 05 37 4f 01 00 	mov    0x14f37(%rip),%rax        # 562c0 <kernel_pagetable>
   41389:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
   4138d:	75 7b                	jne    4140a <check_page_table_ownership+0xa4>
        owner = PO_KERNEL;
   4138f:	c7 45 fc fe ff ff ff 	movl   $0xfffffffe,-0x4(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   41396:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   4139d:	eb 65                	jmp    41404 <check_page_table_ownership+0x9e>
            if (processes[xpid].p_state != P_FREE
   4139f:	8b 45 f4             	mov    -0xc(%rbp),%eax
   413a2:	48 63 d0             	movslq %eax,%rdx
   413a5:	48 89 d0             	mov    %rdx,%rax
   413a8:	48 01 c0             	add    %rax,%rax
   413ab:	48 01 d0             	add    %rdx,%rax
   413ae:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   413b5:	00 
   413b6:	48 01 d0             	add    %rdx,%rax
   413b9:	48 c1 e0 03          	shl    $0x3,%rax
   413bd:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   413c3:	8b 00                	mov    (%rax),%eax
   413c5:	85 c0                	test   %eax,%eax
   413c7:	74 37                	je     41400 <check_page_table_ownership+0x9a>
                && processes[xpid].p_pagetable == kernel_pagetable) {
   413c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
   413cc:	48 63 d0             	movslq %eax,%rdx
   413cf:	48 89 d0             	mov    %rdx,%rax
   413d2:	48 01 c0             	add    %rax,%rax
   413d5:	48 01 d0             	add    %rdx,%rax
   413d8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   413df:	00 
   413e0:	48 01 d0             	add    %rdx,%rax
   413e3:	48 c1 e0 03          	shl    $0x3,%rax
   413e7:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   413ed:	48 8b 10             	mov    (%rax),%rdx
   413f0:	48 8b 05 c9 4e 01 00 	mov    0x14ec9(%rip),%rax        # 562c0 <kernel_pagetable>
   413f7:	48 39 c2             	cmp    %rax,%rdx
   413fa:	75 04                	jne    41400 <check_page_table_ownership+0x9a>
                ++expected_refcount;
   413fc:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   41400:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   41404:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
   41408:	7e 95                	jle    4139f <check_page_table_ownership+0x39>
            }
        }
    }
    check_page_table_ownership_level(pt, 0, owner, expected_refcount);
   4140a:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   4140d:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41414:	be 00 00 00 00       	mov    $0x0,%esi
   41419:	48 89 c7             	mov    %rax,%rdi
   4141c:	e8 03 00 00 00       	callq  41424 <check_page_table_ownership_level>
}
   41421:	90                   	nop
   41422:	c9                   	leaveq 
   41423:	c3                   	retq   

0000000000041424 <check_page_table_ownership_level>:

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount) {
   41424:	55                   	push   %rbp
   41425:	48 89 e5             	mov    %rsp,%rbp
   41428:	48 83 ec 30          	sub    $0x30,%rsp
   4142c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   41430:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   41433:	89 55 e0             	mov    %edx,-0x20(%rbp)
   41436:	89 4d dc             	mov    %ecx,-0x24(%rbp)
    assert(PAGENUMBER(pt) < NPAGES);
   41439:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4143d:	48 c1 e8 0c          	shr    $0xc,%rax
   41441:	3d ff 01 00 00       	cmp    $0x1ff,%eax
   41446:	7e 14                	jle    4145c <check_page_table_ownership_level+0x38>
   41448:	ba 48 42 04 00       	mov    $0x44248,%edx
   4144d:	be 4b 02 00 00       	mov    $0x24b,%esi
   41452:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   41457:	e8 3f 1d 00 00       	callq  4319b <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].owner == owner);
   4145c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41460:	48 c1 e8 0c          	shr    $0xc,%rax
   41464:	48 98                	cltq   
   41466:	0f b6 84 00 a0 dd 04 	movzbl 0x4dda0(%rax,%rax,1),%eax
   4146d:	00 
   4146e:	0f be c0             	movsbl %al,%eax
   41471:	39 45 e0             	cmp    %eax,-0x20(%rbp)
   41474:	74 14                	je     4148a <check_page_table_ownership_level+0x66>
   41476:	ba 60 42 04 00       	mov    $0x44260,%edx
   4147b:	be 4c 02 00 00       	mov    $0x24c,%esi
   41480:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   41485:	e8 11 1d 00 00       	callq  4319b <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].refcount == refcount);
   4148a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4148e:	48 c1 e8 0c          	shr    $0xc,%rax
   41492:	48 98                	cltq   
   41494:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   4149b:	00 
   4149c:	0f be c0             	movsbl %al,%eax
   4149f:	39 45 dc             	cmp    %eax,-0x24(%rbp)
   414a2:	74 14                	je     414b8 <check_page_table_ownership_level+0x94>
   414a4:	ba 88 42 04 00       	mov    $0x44288,%edx
   414a9:	be 4d 02 00 00       	mov    $0x24d,%esi
   414ae:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   414b3:	e8 e3 1c 00 00       	callq  4319b <assert_fail>
    if (level < 3) {
   414b8:	83 7d e4 02          	cmpl   $0x2,-0x1c(%rbp)
   414bc:	7f 5b                	jg     41519 <check_page_table_ownership_level+0xf5>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   414be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   414c5:	eb 49                	jmp    41510 <check_page_table_ownership_level+0xec>
            if (pt->entry[index]) {
   414c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   414cb:	8b 55 fc             	mov    -0x4(%rbp),%edx
   414ce:	48 63 d2             	movslq %edx,%rdx
   414d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   414d5:	48 85 c0             	test   %rax,%rax
   414d8:	74 32                	je     4150c <check_page_table_ownership_level+0xe8>
                x86_64_pagetable* nextpt =
                    (x86_64_pagetable*) PTE_ADDR(pt->entry[index]);
   414da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   414de:	8b 55 fc             	mov    -0x4(%rbp),%edx
   414e1:	48 63 d2             	movslq %edx,%rdx
   414e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   414e8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
                x86_64_pagetable* nextpt =
   414ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                check_page_table_ownership_level(nextpt, level + 1, owner, 1);
   414f2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   414f5:	8d 70 01             	lea    0x1(%rax),%esi
   414f8:	8b 55 e0             	mov    -0x20(%rbp),%edx
   414fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   414ff:	b9 01 00 00 00       	mov    $0x1,%ecx
   41504:	48 89 c7             	mov    %rax,%rdi
   41507:	e8 18 ff ff ff       	callq  41424 <check_page_table_ownership_level>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   4150c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41510:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   41517:	7e ae                	jle    414c7 <check_page_table_ownership_level+0xa3>
            }
        }
    }
}
   41519:	90                   	nop
   4151a:	c9                   	leaveq 
   4151b:	c3                   	retq   

000000000004151c <check_virtual_memory>:

// check_virtual_memory
//    Check operating system invariants about virtual memory. Panic if any
//    of the invariants are false.

void check_virtual_memory(void) {
   4151c:	55                   	push   %rbp
   4151d:	48 89 e5             	mov    %rsp,%rbp
   41520:	48 83 ec 10          	sub    $0x10,%rsp
    // Process 0 must never be used.
    assert(processes[0].p_state == P_FREE);
   41524:	8b 05 9e bb 00 00    	mov    0xbb9e(%rip),%eax        # 4d0c8 <processes+0xc8>
   4152a:	85 c0                	test   %eax,%eax
   4152c:	74 14                	je     41542 <check_virtual_memory+0x26>
   4152e:	ba b8 42 04 00       	mov    $0x442b8,%edx
   41533:	be 60 02 00 00       	mov    $0x260,%esi
   41538:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   4153d:	e8 59 1c 00 00       	callq  4319b <assert_fail>
    // that don't have their own page tables.
    // Active processes have their own page tables. A process page table
    // should be owned by that process and have reference count 1.
    // All level-2-4 page tables must have reference count 1.

    check_page_table_mappings(kernel_pagetable);
   41542:	48 8b 05 77 4d 01 00 	mov    0x14d77(%rip),%rax        # 562c0 <kernel_pagetable>
   41549:	48 89 c7             	mov    %rax,%rdi
   4154c:	e8 c8 fc ff ff       	callq  41219 <check_page_table_mappings>
    check_page_table_ownership(kernel_pagetable, -1);
   41551:	48 8b 05 68 4d 01 00 	mov    0x14d68(%rip),%rax        # 562c0 <kernel_pagetable>
   41558:	be ff ff ff ff       	mov    $0xffffffff,%esi
   4155d:	48 89 c7             	mov    %rax,%rdi
   41560:	e8 01 fe ff ff       	callq  41366 <check_page_table_ownership>

    for (int pid = 0; pid < NPROC; ++pid) {
   41565:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4156c:	e9 c8 00 00 00       	jmpq   41639 <check_virtual_memory+0x11d>
        if (processes[pid].p_state != P_FREE
   41571:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41574:	48 63 d0             	movslq %eax,%rdx
   41577:	48 89 d0             	mov    %rdx,%rax
   4157a:	48 01 c0             	add    %rax,%rax
   4157d:	48 01 d0             	add    %rdx,%rax
   41580:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41587:	00 
   41588:	48 01 d0             	add    %rdx,%rax
   4158b:	48 c1 e0 03          	shl    $0x3,%rax
   4158f:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   41595:	8b 00                	mov    (%rax),%eax
   41597:	85 c0                	test   %eax,%eax
   41599:	0f 84 96 00 00 00    	je     41635 <check_virtual_memory+0x119>
            && processes[pid].p_pagetable != kernel_pagetable) {
   4159f:	8b 45 fc             	mov    -0x4(%rbp),%eax
   415a2:	48 63 d0             	movslq %eax,%rdx
   415a5:	48 89 d0             	mov    %rdx,%rax
   415a8:	48 01 c0             	add    %rax,%rax
   415ab:	48 01 d0             	add    %rdx,%rax
   415ae:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   415b5:	00 
   415b6:	48 01 d0             	add    %rdx,%rax
   415b9:	48 c1 e0 03          	shl    $0x3,%rax
   415bd:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   415c3:	48 8b 10             	mov    (%rax),%rdx
   415c6:	48 8b 05 f3 4c 01 00 	mov    0x14cf3(%rip),%rax        # 562c0 <kernel_pagetable>
   415cd:	48 39 c2             	cmp    %rax,%rdx
   415d0:	74 63                	je     41635 <check_virtual_memory+0x119>
            check_page_table_mappings(processes[pid].p_pagetable);
   415d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
   415d5:	48 63 d0             	movslq %eax,%rdx
   415d8:	48 89 d0             	mov    %rdx,%rax
   415db:	48 01 c0             	add    %rax,%rax
   415de:	48 01 d0             	add    %rdx,%rax
   415e1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   415e8:	00 
   415e9:	48 01 d0             	add    %rdx,%rax
   415ec:	48 c1 e0 03          	shl    $0x3,%rax
   415f0:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   415f6:	48 8b 00             	mov    (%rax),%rax
   415f9:	48 89 c7             	mov    %rax,%rdi
   415fc:	e8 18 fc ff ff       	callq  41219 <check_page_table_mappings>
            check_page_table_ownership(processes[pid].p_pagetable, pid);
   41601:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41604:	48 63 d0             	movslq %eax,%rdx
   41607:	48 89 d0             	mov    %rdx,%rax
   4160a:	48 01 c0             	add    %rax,%rax
   4160d:	48 01 d0             	add    %rdx,%rax
   41610:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41617:	00 
   41618:	48 01 d0             	add    %rdx,%rax
   4161b:	48 c1 e0 03          	shl    $0x3,%rax
   4161f:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   41625:	48 8b 00             	mov    (%rax),%rax
   41628:	8b 55 fc             	mov    -0x4(%rbp),%edx
   4162b:	89 d6                	mov    %edx,%esi
   4162d:	48 89 c7             	mov    %rax,%rdi
   41630:	e8 31 fd ff ff       	callq  41366 <check_page_table_ownership>
    for (int pid = 0; pid < NPROC; ++pid) {
   41635:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41639:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   4163d:	0f 8e 2e ff ff ff    	jle    41571 <check_virtual_memory+0x55>
        }
    }

    // Check that all referenced pages refer to active processes
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   41643:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   4164a:	e9 e1 00 00 00       	jmpq   41730 <check_virtual_memory+0x214>
        if (pageinfo[pn].refcount > 0 && pageinfo[pn].owner >= 0) {
   4164f:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41652:	48 98                	cltq   
   41654:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   4165b:	00 
   4165c:	84 c0                	test   %al,%al
   4165e:	0f 8e c8 00 00 00    	jle    4172c <check_virtual_memory+0x210>
   41664:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41667:	48 98                	cltq   
   41669:	0f b6 84 00 a0 dd 04 	movzbl 0x4dda0(%rax,%rax,1),%eax
   41670:	00 
   41671:	84 c0                	test   %al,%al
   41673:	0f 88 b3 00 00 00    	js     4172c <check_virtual_memory+0x210>
            if (processes[pageinfo[pn].owner].p_state == P_FREE) {
   41679:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4167c:	48 98                	cltq   
   4167e:	0f b6 84 00 a0 dd 04 	movzbl 0x4dda0(%rax,%rax,1),%eax
   41685:	00 
   41686:	0f be c0             	movsbl %al,%eax
   41689:	48 63 d0             	movslq %eax,%rdx
   4168c:	48 89 d0             	mov    %rdx,%rax
   4168f:	48 01 c0             	add    %rax,%rax
   41692:	48 01 d0             	add    %rdx,%rax
   41695:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   4169c:	00 
   4169d:	48 01 d0             	add    %rdx,%rax
   416a0:	48 c1 e0 03          	shl    $0x3,%rax
   416a4:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   416aa:	8b 00                	mov    (%rax),%eax
   416ac:	85 c0                	test   %eax,%eax
   416ae:	75 31                	jne    416e1 <check_virtual_memory+0x1c5>
                console_printf(CPOS(100, 0), 0xC000, "process: %d page number: %d\n", pageinfo[pn].owner, pn);
   416b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
   416b3:	48 98                	cltq   
   416b5:	0f b6 84 00 a0 dd 04 	movzbl 0x4dda0(%rax,%rax,1),%eax
   416bc:	00 
   416bd:	0f be c0             	movsbl %al,%eax
   416c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
   416c3:	41 89 d0             	mov    %edx,%r8d
   416c6:	89 c1                	mov    %eax,%ecx
   416c8:	ba d7 42 04 00       	mov    $0x442d7,%edx
   416cd:	be 00 c0 00 00       	mov    $0xc000,%esi
   416d2:	bf 40 1f 00 00       	mov    $0x1f40,%edi
   416d7:	b8 00 00 00 00       	mov    $0x0,%eax
   416dc:	e8 bb 27 00 00       	callq  43e9c <console_printf>
            }
            assert(processes[pageinfo[pn].owner].p_state != P_FREE);
   416e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
   416e4:	48 98                	cltq   
   416e6:	0f b6 84 00 a0 dd 04 	movzbl 0x4dda0(%rax,%rax,1),%eax
   416ed:	00 
   416ee:	0f be c0             	movsbl %al,%eax
   416f1:	48 63 d0             	movslq %eax,%rdx
   416f4:	48 89 d0             	mov    %rdx,%rax
   416f7:	48 01 c0             	add    %rax,%rax
   416fa:	48 01 d0             	add    %rdx,%rax
   416fd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41704:	00 
   41705:	48 01 d0             	add    %rdx,%rax
   41708:	48 c1 e0 03          	shl    $0x3,%rax
   4170c:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   41712:	8b 00                	mov    (%rax),%eax
   41714:	85 c0                	test   %eax,%eax
   41716:	75 14                	jne    4172c <check_virtual_memory+0x210>
   41718:	ba f8 42 04 00       	mov    $0x442f8,%edx
   4171d:	be 7a 02 00 00       	mov    $0x27a,%esi
   41722:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   41727:	e8 6f 1a 00 00       	callq  4319b <assert_fail>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   4172c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   41730:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
   41737:	0f 8e 12 ff ff ff    	jle    4164f <check_virtual_memory+0x133>
        }
    }
}
   4173d:	90                   	nop
   4173e:	90                   	nop
   4173f:	c9                   	leaveq 
   41740:	c3                   	retq   

0000000000041741 <memshow_physical>:
    'E' | 0x0E00, 'F' | 0x0F00, 'S'
};
#define SHARED_COLOR memstate_colors[18]
#define SHARED

void memshow_physical(void) {
   41741:	55                   	push   %rbp
   41742:	48 89 e5             	mov    %rsp,%rbp
   41745:	48 83 ec 10          	sub    $0x10,%rsp
    console_printf(CPOS(0, 32), 0x0F00, "PHYSICAL MEMORY");
   41749:	ba 66 43 04 00       	mov    $0x44366,%edx
   4174e:	be 00 0f 00 00       	mov    $0xf00,%esi
   41753:	bf 20 00 00 00       	mov    $0x20,%edi
   41758:	b8 00 00 00 00       	mov    $0x0,%eax
   4175d:	e8 3a 27 00 00       	callq  43e9c <console_printf>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   41762:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   41769:	e9 ec 00 00 00       	jmpq   4185a <memshow_physical+0x119>
        if (pn % 64 == 0) {
   4176e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41771:	83 e0 3f             	and    $0x3f,%eax
   41774:	85 c0                	test   %eax,%eax
   41776:	75 3c                	jne    417b4 <memshow_physical+0x73>
            console_printf(CPOS(1 + pn / 64, 3), 0x0F00, "0x%06X ", pn << 12);
   41778:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4177b:	c1 e0 0c             	shl    $0xc,%eax
   4177e:	89 c1                	mov    %eax,%ecx
   41780:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41783:	8d 50 3f             	lea    0x3f(%rax),%edx
   41786:	85 c0                	test   %eax,%eax
   41788:	0f 48 c2             	cmovs  %edx,%eax
   4178b:	c1 f8 06             	sar    $0x6,%eax
   4178e:	8d 50 01             	lea    0x1(%rax),%edx
   41791:	89 d0                	mov    %edx,%eax
   41793:	c1 e0 02             	shl    $0x2,%eax
   41796:	01 d0                	add    %edx,%eax
   41798:	c1 e0 04             	shl    $0x4,%eax
   4179b:	83 c0 03             	add    $0x3,%eax
   4179e:	ba 76 43 04 00       	mov    $0x44376,%edx
   417a3:	be 00 0f 00 00       	mov    $0xf00,%esi
   417a8:	89 c7                	mov    %eax,%edi
   417aa:	b8 00 00 00 00       	mov    $0x0,%eax
   417af:	e8 e8 26 00 00       	callq  43e9c <console_printf>
        }

        int owner = pageinfo[pn].owner;
   417b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
   417b7:	48 98                	cltq   
   417b9:	0f b6 84 00 a0 dd 04 	movzbl 0x4dda0(%rax,%rax,1),%eax
   417c0:	00 
   417c1:	0f be c0             	movsbl %al,%eax
   417c4:	89 45 f8             	mov    %eax,-0x8(%rbp)
        if (pageinfo[pn].refcount == 0) {
   417c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
   417ca:	48 98                	cltq   
   417cc:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   417d3:	00 
   417d4:	84 c0                	test   %al,%al
   417d6:	75 07                	jne    417df <memshow_physical+0x9e>
            owner = PO_FREE;
   417d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
        }
        uint16_t color = memstate_colors[owner - PO_KERNEL];
   417df:	8b 45 f8             	mov    -0x8(%rbp),%eax
   417e2:	83 c0 02             	add    $0x2,%eax
   417e5:	48 98                	cltq   
   417e7:	0f b7 84 00 40 43 04 	movzwl 0x44340(%rax,%rax,1),%eax
   417ee:	00 
   417ef:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
        // darker color for shared pages
        if (pageinfo[pn].refcount > 1 && pn != PAGENUMBER(CONSOLE_ADDR)){
   417f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
   417f6:	48 98                	cltq   
   417f8:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   417ff:	00 
   41800:	3c 01                	cmp    $0x1,%al
   41802:	7e 14                	jle    41818 <memshow_physical+0xd7>
   41804:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   41809:	48 c1 e8 0c          	shr    $0xc,%rax
   4180d:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   41810:	74 06                	je     41818 <memshow_physical+0xd7>
#ifdef SHARED
            color = SHARED_COLOR;
   41812:	66 c7 45 f6 53 00    	movw   $0x53,-0xa(%rbp)
#else
        color &= 0x77FF;
#endif
        }

        console[CPOS(1 + pn / 64, 12 + pn % 64)] = color;
   41818:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4181b:	8d 50 3f             	lea    0x3f(%rax),%edx
   4181e:	85 c0                	test   %eax,%eax
   41820:	0f 48 c2             	cmovs  %edx,%eax
   41823:	c1 f8 06             	sar    $0x6,%eax
   41826:	8d 50 01             	lea    0x1(%rax),%edx
   41829:	89 d0                	mov    %edx,%eax
   4182b:	c1 e0 02             	shl    $0x2,%eax
   4182e:	01 d0                	add    %edx,%eax
   41830:	c1 e0 04             	shl    $0x4,%eax
   41833:	89 c1                	mov    %eax,%ecx
   41835:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41838:	99                   	cltd   
   41839:	c1 ea 1a             	shr    $0x1a,%edx
   4183c:	01 d0                	add    %edx,%eax
   4183e:	83 e0 3f             	and    $0x3f,%eax
   41841:	29 d0                	sub    %edx,%eax
   41843:	83 c0 0c             	add    $0xc,%eax
   41846:	01 c8                	add    %ecx,%eax
   41848:	48 98                	cltq   
   4184a:	0f b7 55 f6          	movzwl -0xa(%rbp),%edx
   4184e:	66 89 94 00 00 80 0b 	mov    %dx,0xb8000(%rax,%rax,1)
   41855:	00 
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   41856:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   4185a:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   41861:	0f 8e 07 ff ff ff    	jle    4176e <memshow_physical+0x2d>
    }
}
   41867:	90                   	nop
   41868:	90                   	nop
   41869:	c9                   	leaveq 
   4186a:	c3                   	retq   

000000000004186b <memshow_virtual>:

// memshow_virtual(pagetable, name)
//    Draw a picture of the virtual memory map `pagetable` (named `name`) on
//    the CGA console.

void memshow_virtual(x86_64_pagetable* pagetable, const char* name) {
   4186b:	55                   	push   %rbp
   4186c:	48 89 e5             	mov    %rsp,%rbp
   4186f:	48 83 ec 40          	sub    $0x40,%rsp
   41873:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   41877:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
    assert((uintptr_t) pagetable == PTE_ADDR(pagetable));
   4187b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4187f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   41885:	48 89 c2             	mov    %rax,%rdx
   41888:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4188c:	48 39 c2             	cmp    %rax,%rdx
   4188f:	74 14                	je     418a5 <memshow_virtual+0x3a>
   41891:	ba 80 43 04 00       	mov    $0x44380,%edx
   41896:	be ac 02 00 00       	mov    $0x2ac,%esi
   4189b:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   418a0:	e8 f6 18 00 00       	callq  4319b <assert_fail>

    console_printf(CPOS(10, 26), 0x0F00, "VIRTUAL ADDRESS SPACE FOR %s", name);
   418a5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   418a9:	48 89 c1             	mov    %rax,%rcx
   418ac:	ba ad 43 04 00       	mov    $0x443ad,%edx
   418b1:	be 00 0f 00 00       	mov    $0xf00,%esi
   418b6:	bf 3a 03 00 00       	mov    $0x33a,%edi
   418bb:	b8 00 00 00 00       	mov    $0x0,%eax
   418c0:	e8 d7 25 00 00       	callq  43e9c <console_printf>
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   418c5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   418cc:	00 
   418cd:	e9 6d 01 00 00       	jmpq   41a3f <memshow_virtual+0x1d4>
        vamapping vam = virtual_memory_lookup(pagetable, va);
   418d2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   418d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   418da:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   418de:	48 89 ce             	mov    %rcx,%rsi
   418e1:	48 89 c7             	mov    %rax,%rdi
   418e4:	e8 35 0d 00 00       	callq  4261e <virtual_memory_lookup>
        uint16_t color;
        if (vam.pn < 0) {
   418e9:	8b 45 d0             	mov    -0x30(%rbp),%eax
   418ec:	85 c0                	test   %eax,%eax
   418ee:	79 0b                	jns    418fb <memshow_virtual+0x90>
            color = ' ';
   418f0:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%rbp)
   418f6:	e9 c4 00 00 00       	jmpq   419bf <memshow_virtual+0x154>
        } else {
            assert(vam.pa < MEMSIZE_PHYSICAL);
   418fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   418ff:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   41905:	76 14                	jbe    4191b <memshow_virtual+0xb0>
   41907:	ba ca 43 04 00       	mov    $0x443ca,%edx
   4190c:	be b5 02 00 00       	mov    $0x2b5,%esi
   41911:	bf b5 3f 04 00       	mov    $0x43fb5,%edi
   41916:	e8 80 18 00 00       	callq  4319b <assert_fail>
            int owner = pageinfo[vam.pn].owner;
   4191b:	8b 45 d0             	mov    -0x30(%rbp),%eax
   4191e:	48 98                	cltq   
   41920:	0f b6 84 00 a0 dd 04 	movzbl 0x4dda0(%rax,%rax,1),%eax
   41927:	00 
   41928:	0f be c0             	movsbl %al,%eax
   4192b:	89 45 f0             	mov    %eax,-0x10(%rbp)
            if (pageinfo[vam.pn].refcount == 0) {
   4192e:	8b 45 d0             	mov    -0x30(%rbp),%eax
   41931:	48 98                	cltq   
   41933:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   4193a:	00 
   4193b:	84 c0                	test   %al,%al
   4193d:	75 07                	jne    41946 <memshow_virtual+0xdb>
                owner = PO_FREE;
   4193f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
            }
            color = memstate_colors[owner - PO_KERNEL];
   41946:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41949:	83 c0 02             	add    $0x2,%eax
   4194c:	48 98                	cltq   
   4194e:	0f b7 84 00 40 43 04 	movzwl 0x44340(%rax,%rax,1),%eax
   41955:	00 
   41956:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            // reverse video for user-accessible pages
            if (vam.perm & PTE_U) {
   4195a:	8b 45 e0             	mov    -0x20(%rbp),%eax
   4195d:	48 98                	cltq   
   4195f:	83 e0 04             	and    $0x4,%eax
   41962:	48 85 c0             	test   %rax,%rax
   41965:	74 27                	je     4198e <memshow_virtual+0x123>
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   41967:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   4196b:	c1 e0 04             	shl    $0x4,%eax
   4196e:	66 25 00 f0          	and    $0xf000,%ax
   41972:	89 c2                	mov    %eax,%edx
   41974:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   41978:	c1 f8 04             	sar    $0x4,%eax
   4197b:	66 25 00 0f          	and    $0xf00,%ax
   4197f:	09 c2                	or     %eax,%edx
                    | (color & 0x00FF);
   41981:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   41985:	0f b6 c0             	movzbl %al,%eax
   41988:	09 d0                	or     %edx,%eax
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   4198a:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            }
            // darker color for shared pages
            if (pageinfo[vam.pn].refcount > 1 && va != CONSOLE_ADDR) {
   4198e:	8b 45 d0             	mov    -0x30(%rbp),%eax
   41991:	48 98                	cltq   
   41993:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   4199a:	00 
   4199b:	3c 01                	cmp    $0x1,%al
   4199d:	7e 20                	jle    419bf <memshow_virtual+0x154>
   4199f:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   419a4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   419a8:	74 15                	je     419bf <memshow_virtual+0x154>
#ifdef SHARED
                color = (SHARED_COLOR | (color & 0xF000));
   419aa:	b8 53 00 00 00       	mov    $0x53,%eax
   419af:	89 c2                	mov    %eax,%edx
   419b1:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   419b5:	66 25 00 f0          	and    $0xf000,%ax
   419b9:	09 d0                	or     %edx,%eax
   419bb:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
#else
        color &= 0x77FF;
#endif
            }
        }
        uint32_t pn = PAGENUMBER(va);
   419bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   419c3:	48 c1 e8 0c          	shr    $0xc,%rax
   419c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (pn % 64 == 0) {
   419ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
   419cd:	83 e0 3f             	and    $0x3f,%eax
   419d0:	85 c0                	test   %eax,%eax
   419d2:	75 34                	jne    41a08 <memshow_virtual+0x19d>
            console_printf(CPOS(11 + pn / 64, 3), 0x0F00, "0x%06X ", va);
   419d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
   419d7:	c1 e8 06             	shr    $0x6,%eax
   419da:	89 c2                	mov    %eax,%edx
   419dc:	89 d0                	mov    %edx,%eax
   419de:	c1 e0 02             	shl    $0x2,%eax
   419e1:	01 d0                	add    %edx,%eax
   419e3:	c1 e0 04             	shl    $0x4,%eax
   419e6:	05 73 03 00 00       	add    $0x373,%eax
   419eb:	89 c7                	mov    %eax,%edi
   419ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   419f1:	48 89 c1             	mov    %rax,%rcx
   419f4:	ba 76 43 04 00       	mov    $0x44376,%edx
   419f9:	be 00 0f 00 00       	mov    $0xf00,%esi
   419fe:	b8 00 00 00 00       	mov    $0x0,%eax
   41a03:	e8 94 24 00 00       	callq  43e9c <console_printf>
        }
        console[CPOS(11 + pn / 64, 12 + pn % 64)] = color;
   41a08:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41a0b:	c1 e8 06             	shr    $0x6,%eax
   41a0e:	89 c2                	mov    %eax,%edx
   41a10:	89 d0                	mov    %edx,%eax
   41a12:	c1 e0 02             	shl    $0x2,%eax
   41a15:	01 d0                	add    %edx,%eax
   41a17:	c1 e0 04             	shl    $0x4,%eax
   41a1a:	89 c2                	mov    %eax,%edx
   41a1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41a1f:	83 e0 3f             	and    $0x3f,%eax
   41a22:	01 d0                	add    %edx,%eax
   41a24:	05 7c 03 00 00       	add    $0x37c,%eax
   41a29:	89 c2                	mov    %eax,%edx
   41a2b:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   41a2f:	66 89 84 12 00 80 0b 	mov    %ax,0xb8000(%rdx,%rdx,1)
   41a36:	00 
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   41a37:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   41a3e:	00 
   41a3f:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   41a46:	00 
   41a47:	0f 86 85 fe ff ff    	jbe    418d2 <memshow_virtual+0x67>
    }
}
   41a4d:	90                   	nop
   41a4e:	90                   	nop
   41a4f:	c9                   	leaveq 
   41a50:	c3                   	retq   

0000000000041a51 <memshow_virtual_animate>:

// memshow_virtual_animate
//    Draw a picture of process virtual memory maps on the CGA console.
//    Starts with process 1, then switches to a new process every 0.25 sec.

void memshow_virtual_animate(void) {
   41a51:	55                   	push   %rbp
   41a52:	48 89 e5             	mov    %rsp,%rbp
   41a55:	48 83 ec 10          	sub    $0x10,%rsp
    static unsigned last_ticks = 0;
    static int showing = 1;

    // switch to a new process every 0.25 sec
    if (last_ticks == 0 || ticks - last_ticks >= HZ / 2) {
   41a59:	8b 05 41 c7 00 00    	mov    0xc741(%rip),%eax        # 4e1a0 <last_ticks.1704>
   41a5f:	85 c0                	test   %eax,%eax
   41a61:	74 15                	je     41a78 <memshow_virtual_animate+0x27>
   41a63:	8b 15 17 c3 00 00    	mov    0xc317(%rip),%edx        # 4dd80 <ticks>
   41a69:	8b 05 31 c7 00 00    	mov    0xc731(%rip),%eax        # 4e1a0 <last_ticks.1704>
   41a6f:	29 c2                	sub    %eax,%edx
   41a71:	89 d0                	mov    %edx,%eax
   41a73:	83 f8 31             	cmp    $0x31,%eax
   41a76:	76 2c                	jbe    41aa4 <memshow_virtual_animate+0x53>
        last_ticks = ticks;
   41a78:	8b 05 02 c3 00 00    	mov    0xc302(%rip),%eax        # 4dd80 <ticks>
   41a7e:	89 05 1c c7 00 00    	mov    %eax,0xc71c(%rip)        # 4e1a0 <last_ticks.1704>
        ++showing;
   41a84:	8b 05 76 35 00 00    	mov    0x3576(%rip),%eax        # 45000 <start_data>
   41a8a:	83 c0 01             	add    $0x1,%eax
   41a8d:	89 05 6d 35 00 00    	mov    %eax,0x356d(%rip)        # 45000 <start_data>
    }

    // the current process may have died -- don't display it if so
    while (showing <= 2*NPROC
   41a93:	eb 0f                	jmp    41aa4 <memshow_virtual_animate+0x53>
           && processes[showing % NPROC].p_state == P_FREE) {
        ++showing;
   41a95:	8b 05 65 35 00 00    	mov    0x3565(%rip),%eax        # 45000 <start_data>
   41a9b:	83 c0 01             	add    $0x1,%eax
   41a9e:	89 05 5c 35 00 00    	mov    %eax,0x355c(%rip)        # 45000 <start_data>
    while (showing <= 2*NPROC
   41aa4:	8b 05 56 35 00 00    	mov    0x3556(%rip),%eax        # 45000 <start_data>
   41aaa:	83 f8 20             	cmp    $0x20,%eax
   41aad:	7f 38                	jg     41ae7 <memshow_virtual_animate+0x96>
           && processes[showing % NPROC].p_state == P_FREE) {
   41aaf:	8b 05 4b 35 00 00    	mov    0x354b(%rip),%eax        # 45000 <start_data>
   41ab5:	99                   	cltd   
   41ab6:	c1 ea 1c             	shr    $0x1c,%edx
   41ab9:	01 d0                	add    %edx,%eax
   41abb:	83 e0 0f             	and    $0xf,%eax
   41abe:	29 d0                	sub    %edx,%eax
   41ac0:	48 63 d0             	movslq %eax,%rdx
   41ac3:	48 89 d0             	mov    %rdx,%rax
   41ac6:	48 01 c0             	add    %rax,%rax
   41ac9:	48 01 d0             	add    %rdx,%rax
   41acc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41ad3:	00 
   41ad4:	48 01 d0             	add    %rdx,%rax
   41ad7:	48 c1 e0 03          	shl    $0x3,%rax
   41adb:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   41ae1:	8b 00                	mov    (%rax),%eax
   41ae3:	85 c0                	test   %eax,%eax
   41ae5:	74 ae                	je     41a95 <memshow_virtual_animate+0x44>
    }
    showing = showing % NPROC;
   41ae7:	8b 05 13 35 00 00    	mov    0x3513(%rip),%eax        # 45000 <start_data>
   41aed:	99                   	cltd   
   41aee:	c1 ea 1c             	shr    $0x1c,%edx
   41af1:	01 d0                	add    %edx,%eax
   41af3:	83 e0 0f             	and    $0xf,%eax
   41af6:	29 d0                	sub    %edx,%eax
   41af8:	89 05 02 35 00 00    	mov    %eax,0x3502(%rip)        # 45000 <start_data>

    if (processes[showing].p_state != P_FREE) {
   41afe:	8b 05 fc 34 00 00    	mov    0x34fc(%rip),%eax        # 45000 <start_data>
   41b04:	48 63 d0             	movslq %eax,%rdx
   41b07:	48 89 d0             	mov    %rdx,%rax
   41b0a:	48 01 c0             	add    %rax,%rax
   41b0d:	48 01 d0             	add    %rdx,%rax
   41b10:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41b17:	00 
   41b18:	48 01 d0             	add    %rdx,%rax
   41b1b:	48 c1 e0 03          	shl    $0x3,%rax
   41b1f:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   41b25:	8b 00                	mov    (%rax),%eax
   41b27:	85 c0                	test   %eax,%eax
   41b29:	74 5c                	je     41b87 <memshow_virtual_animate+0x136>
        char s[4];
        snprintf(s, 4, "%d ", showing);
   41b2b:	8b 15 cf 34 00 00    	mov    0x34cf(%rip),%edx        # 45000 <start_data>
   41b31:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
   41b35:	89 d1                	mov    %edx,%ecx
   41b37:	ba e4 43 04 00       	mov    $0x443e4,%edx
   41b3c:	be 04 00 00 00       	mov    $0x4,%esi
   41b41:	48 89 c7             	mov    %rax,%rdi
   41b44:	b8 00 00 00 00       	mov    $0x0,%eax
   41b49:	e8 cf 23 00 00       	callq  43f1d <snprintf>
        memshow_virtual(processes[showing].p_pagetable, s);
   41b4e:	8b 05 ac 34 00 00    	mov    0x34ac(%rip),%eax        # 45000 <start_data>
   41b54:	48 63 d0             	movslq %eax,%rdx
   41b57:	48 89 d0             	mov    %rdx,%rax
   41b5a:	48 01 c0             	add    %rax,%rax
   41b5d:	48 01 d0             	add    %rdx,%rax
   41b60:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   41b67:	00 
   41b68:	48 01 d0             	add    %rdx,%rax
   41b6b:	48 c1 e0 03          	shl    $0x3,%rax
   41b6f:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   41b75:	48 8b 00             	mov    (%rax),%rax
   41b78:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
   41b7c:	48 89 d6             	mov    %rdx,%rsi
   41b7f:	48 89 c7             	mov    %rax,%rdi
   41b82:	e8 e4 fc ff ff       	callq  4186b <memshow_virtual>
    }
}
   41b87:	90                   	nop
   41b88:	c9                   	leaveq 
   41b89:	c3                   	retq   

0000000000041b8a <pageindex>:
static inline int pageindex(uintptr_t addr, int level) {
   41b8a:	55                   	push   %rbp
   41b8b:	48 89 e5             	mov    %rsp,%rbp
   41b8e:	48 83 ec 10          	sub    $0x10,%rsp
   41b92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41b96:	89 75 f4             	mov    %esi,-0xc(%rbp)
    assert(level >= 0 && level <= 3);
   41b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   41b9d:	78 06                	js     41ba5 <pageindex+0x1b>
   41b9f:	83 7d f4 03          	cmpl   $0x3,-0xc(%rbp)
   41ba3:	7e 14                	jle    41bb9 <pageindex+0x2f>
   41ba5:	ba 00 44 04 00       	mov    $0x44400,%edx
   41baa:	be 1e 00 00 00       	mov    $0x1e,%esi
   41baf:	bf 19 44 04 00       	mov    $0x44419,%edi
   41bb4:	e8 e2 15 00 00       	callq  4319b <assert_fail>
    return (int) (addr >> (PAGEOFFBITS + (3 - level) * PAGEINDEXBITS)) & 0x1FF;
   41bb9:	b8 03 00 00 00       	mov    $0x3,%eax
   41bbe:	2b 45 f4             	sub    -0xc(%rbp),%eax
   41bc1:	89 c2                	mov    %eax,%edx
   41bc3:	89 d0                	mov    %edx,%eax
   41bc5:	c1 e0 03             	shl    $0x3,%eax
   41bc8:	01 d0                	add    %edx,%eax
   41bca:	83 c0 0c             	add    $0xc,%eax
   41bcd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   41bd1:	89 c1                	mov    %eax,%ecx
   41bd3:	48 d3 ea             	shr    %cl,%rdx
   41bd6:	48 89 d0             	mov    %rdx,%rax
   41bd9:	25 ff 01 00 00       	and    $0x1ff,%eax
}
   41bde:	c9                   	leaveq 
   41bdf:	c3                   	retq   

0000000000041be0 <hardware_init>:

static void segments_init(void);
static void interrupt_init(void);
static void virtual_memory_init(void);

void hardware_init(void) {
   41be0:	55                   	push   %rbp
   41be1:	48 89 e5             	mov    %rsp,%rbp
    segments_init();
   41be4:	e8 4f 01 00 00       	callq  41d38 <segments_init>
    interrupt_init();
   41be9:	e8 b8 03 00 00       	callq  41fa6 <interrupt_init>
    virtual_memory_init();
   41bee:	e8 8d 05 00 00       	callq  42180 <virtual_memory_init>
}
   41bf3:	90                   	nop
   41bf4:	5d                   	pop    %rbp
   41bf5:	c3                   	retq   

0000000000041bf6 <set_app_segment>:
#define SEGSEL_TASKSTATE        0x28            // task state segment

// Segments
static uint64_t segments[7];

static void set_app_segment(uint64_t* segment, uint64_t type, int dpl) {
   41bf6:	55                   	push   %rbp
   41bf7:	48 89 e5             	mov    %rsp,%rbp
   41bfa:	48 83 ec 18          	sub    $0x18,%rsp
   41bfe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41c02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41c06:	89 55 ec             	mov    %edx,-0x14(%rbp)
    *segment = type
        | X86SEG_S                    // code/data segment
        | ((uint64_t) dpl << 45)
   41c09:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41c0c:	48 98                	cltq   
   41c0e:	48 c1 e0 2d          	shl    $0x2d,%rax
   41c12:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | X86SEG_P;                   // segment present
   41c16:	48 ba 00 00 00 00 00 	movabs $0x900000000000,%rdx
   41c1d:	90 00 00 
   41c20:	48 09 c2             	or     %rax,%rdx
    *segment = type
   41c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41c27:	48 89 10             	mov    %rdx,(%rax)
}
   41c2a:	90                   	nop
   41c2b:	c9                   	leaveq 
   41c2c:	c3                   	retq   

0000000000041c2d <set_sys_segment>:

static void set_sys_segment(uint64_t* segment, uint64_t type, int dpl,
                            uintptr_t addr, size_t size) {
   41c2d:	55                   	push   %rbp
   41c2e:	48 89 e5             	mov    %rsp,%rbp
   41c31:	48 83 ec 28          	sub    $0x28,%rsp
   41c35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41c39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41c3d:	89 55 ec             	mov    %edx,-0x14(%rbp)
   41c40:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
   41c44:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   41c48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41c4c:	48 c1 e0 10          	shl    $0x10,%rax
   41c50:	48 89 c2             	mov    %rax,%rdx
   41c53:	48 b8 00 00 ff ff ff 	movabs $0xffffff0000,%rax
   41c5a:	00 00 00 
   41c5d:	48 21 c2             	and    %rax,%rdx
        | ((addr & 0x00000000FF000000UL) << 32)
   41c60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41c64:	48 c1 e0 20          	shl    $0x20,%rax
   41c68:	48 89 c1             	mov    %rax,%rcx
   41c6b:	48 b8 00 00 00 00 00 	movabs $0xff00000000000000,%rax
   41c72:	00 00 ff 
   41c75:	48 21 c8             	and    %rcx,%rax
   41c78:	48 09 c2             	or     %rax,%rdx
        | ((size - 1) & 0x0FFFFUL)
   41c7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   41c7f:	48 83 e8 01          	sub    $0x1,%rax
   41c83:	0f b7 c0             	movzwl %ax,%eax
        | (((size - 1) & 0xF0000UL) << 48)
   41c86:	48 09 d0             	or     %rdx,%rax
        | type
   41c89:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | ((uint64_t) dpl << 45)
   41c8d:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41c90:	48 63 d2             	movslq %edx,%rdx
   41c93:	48 c1 e2 2d          	shl    $0x2d,%rdx
   41c97:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P;                   // segment present
   41c9a:	48 b8 00 00 00 00 00 	movabs $0x800000000000,%rax
   41ca1:	80 00 00 
   41ca4:	48 09 c2             	or     %rax,%rdx
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   41ca7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41cab:	48 89 10             	mov    %rdx,(%rax)
    segment[1] = addr >> 32;
   41cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41cb2:	48 83 c0 08          	add    $0x8,%rax
   41cb6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   41cba:	48 c1 ea 20          	shr    $0x20,%rdx
   41cbe:	48 89 10             	mov    %rdx,(%rax)
}
   41cc1:	90                   	nop
   41cc2:	c9                   	leaveq 
   41cc3:	c3                   	retq   

0000000000041cc4 <set_gate>:

// Processor state for taking an interrupt
static x86_64_taskstate kernel_task_descriptor;

static void set_gate(x86_64_gatedescriptor* gate, uint64_t type, int dpl,
                     uintptr_t function) {
   41cc4:	55                   	push   %rbp
   41cc5:	48 89 e5             	mov    %rsp,%rbp
   41cc8:	48 83 ec 20          	sub    $0x20,%rsp
   41ccc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41cd0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41cd4:	89 55 ec             	mov    %edx,-0x14(%rbp)
   41cd7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41cdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41cdf:	0f b7 c0             	movzwl %ax,%eax
        | (SEGSEL_KERN_CODE << 16)
        | type
   41ce2:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | ((uint64_t) dpl << 45)
   41ce6:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41ce9:	48 63 d2             	movslq %edx,%rdx
   41cec:	48 c1 e2 2d          	shl    $0x2d,%rdx
   41cf0:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P
        | ((function & 0x00000000FFFF0000UL) << 32);
   41cf3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41cf7:	48 c1 e0 20          	shl    $0x20,%rax
   41cfb:	48 89 c1             	mov    %rax,%rcx
   41cfe:	48 b8 00 00 00 00 00 	movabs $0xffff000000000000,%rax
   41d05:	00 ff ff 
   41d08:	48 21 c8             	and    %rcx,%rax
   41d0b:	48 09 c2             	or     %rax,%rdx
   41d0e:	48 b8 00 00 08 00 00 	movabs $0x800000080000,%rax
   41d15:	80 00 00 
   41d18:	48 09 c2             	or     %rax,%rdx
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41d1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41d1f:	48 89 10             	mov    %rdx,(%rax)
    gate->gd_high = function >> 32;
   41d22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41d26:	48 c1 e8 20          	shr    $0x20,%rax
   41d2a:	48 89 c2             	mov    %rax,%rdx
   41d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41d31:	48 89 50 08          	mov    %rdx,0x8(%rax)
}
   41d35:	90                   	nop
   41d36:	c9                   	leaveq 
   41d37:	c3                   	retq   

0000000000041d38 <segments_init>:
extern void default_int_handler(void);
extern void gpf_int_handler(void);
extern void pagefault_int_handler(void);
extern void timer_int_handler(void);

void segments_init(void) {
   41d38:	55                   	push   %rbp
   41d39:	48 89 e5             	mov    %rsp,%rbp
   41d3c:	48 83 ec 40          	sub    $0x40,%rsp
    // Segments for kernel & user code & data
    // The privilege level, which can be 0 or 3, differentiates between
    // kernel and user code. (Data segments are unused in WeensyOS.)
    segments[0] = 0;
   41d40:	48 c7 05 b5 d2 00 00 	movq   $0x0,0xd2b5(%rip)        # 4f000 <segments>
   41d47:	00 00 00 00 
    set_app_segment(&segments[SEGSEL_KERN_CODE >> 3], X86SEG_X | X86SEG_L, 0);
   41d4b:	ba 00 00 00 00       	mov    $0x0,%edx
   41d50:	48 be 00 00 00 00 00 	movabs $0x20080000000000,%rsi
   41d57:	08 20 00 
   41d5a:	bf 08 f0 04 00       	mov    $0x4f008,%edi
   41d5f:	e8 92 fe ff ff       	callq  41bf6 <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_CODE >> 3], X86SEG_X | X86SEG_L, 3);
   41d64:	ba 03 00 00 00       	mov    $0x3,%edx
   41d69:	48 be 00 00 00 00 00 	movabs $0x20080000000000,%rsi
   41d70:	08 20 00 
   41d73:	bf 10 f0 04 00       	mov    $0x4f010,%edi
   41d78:	e8 79 fe ff ff       	callq  41bf6 <set_app_segment>
    set_app_segment(&segments[SEGSEL_KERN_DATA >> 3], X86SEG_W, 0);
   41d7d:	ba 00 00 00 00       	mov    $0x0,%edx
   41d82:	48 be 00 00 00 00 00 	movabs $0x20000000000,%rsi
   41d89:	02 00 00 
   41d8c:	bf 18 f0 04 00       	mov    $0x4f018,%edi
   41d91:	e8 60 fe ff ff       	callq  41bf6 <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_DATA >> 3], X86SEG_W, 3);
   41d96:	ba 03 00 00 00       	mov    $0x3,%edx
   41d9b:	48 be 00 00 00 00 00 	movabs $0x20000000000,%rsi
   41da2:	02 00 00 
   41da5:	bf 20 f0 04 00       	mov    $0x4f020,%edi
   41daa:	e8 47 fe ff ff       	callq  41bf6 <set_app_segment>
    set_sys_segment(&segments[SEGSEL_TASKSTATE >> 3], X86SEG_TSS, 0,
   41daf:	b8 40 00 05 00       	mov    $0x50040,%eax
   41db4:	41 b8 60 00 00 00    	mov    $0x60,%r8d
   41dba:	48 89 c1             	mov    %rax,%rcx
   41dbd:	ba 00 00 00 00       	mov    $0x0,%edx
   41dc2:	48 be 00 00 00 00 00 	movabs $0x90000000000,%rsi
   41dc9:	09 00 00 
   41dcc:	bf 28 f0 04 00       	mov    $0x4f028,%edi
   41dd1:	e8 57 fe ff ff       	callq  41c2d <set_sys_segment>
                    (uintptr_t) &kernel_task_descriptor,
                    sizeof(kernel_task_descriptor));

    x86_64_pseudodescriptor gdt;
    gdt.pseudod_limit = sizeof(segments) - 1;
   41dd6:	66 c7 45 d6 37 00    	movw   $0x37,-0x2a(%rbp)
    gdt.pseudod_base = (uint64_t) segments;
   41ddc:	b8 00 f0 04 00       	mov    $0x4f000,%eax
   41de1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

    // Kernel task descriptor lets us receive interrupts
    memset(&kernel_task_descriptor, 0, sizeof(kernel_task_descriptor));
   41de5:	ba 60 00 00 00       	mov    $0x60,%edx
   41dea:	be 00 00 00 00       	mov    $0x0,%esi
   41def:	bf 40 00 05 00       	mov    $0x50040,%edi
   41df4:	e8 65 18 00 00       	callq  4365e <memset>
    kernel_task_descriptor.ts_rsp[0] = KERNEL_STACK_TOP;
   41df9:	48 c7 05 40 e2 00 00 	movq   $0x80000,0xe240(%rip)        # 50044 <kernel_task_descriptor+0x4>
   41e00:	00 00 08 00 

    // Interrupt handler; most interrupts are effectively ignored
    memset(interrupt_descriptors, 0, sizeof(interrupt_descriptors));
   41e04:	ba 00 10 00 00       	mov    $0x1000,%edx
   41e09:	be 00 00 00 00       	mov    $0x0,%esi
   41e0e:	bf 40 f0 04 00       	mov    $0x4f040,%edi
   41e13:	e8 46 18 00 00       	callq  4365e <memset>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   41e18:	c7 45 fc 10 00 00 00 	movl   $0x10,-0x4(%rbp)
   41e1f:	eb 30                	jmp    41e51 <segments_init+0x119>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 0,
   41e21:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   41e26:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41e29:	48 c1 e0 04          	shl    $0x4,%rax
   41e2d:	48 05 40 f0 04 00    	add    $0x4f040,%rax
   41e33:	48 89 d1             	mov    %rdx,%rcx
   41e36:	ba 00 00 00 00       	mov    $0x0,%edx
   41e3b:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41e42:	0e 00 00 
   41e45:	48 89 c7             	mov    %rax,%rdi
   41e48:	e8 77 fe ff ff       	callq  41cc4 <set_gate>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   41e4d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41e51:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
   41e58:	76 c7                	jbe    41e21 <segments_init+0xe9>
                 (uint64_t) default_int_handler);
    }

    // Timer interrupt
    set_gate(&interrupt_descriptors[INT_TIMER], X86GATE_INTERRUPT, 0,
   41e5a:	b8 36 00 04 00       	mov    $0x40036,%eax
   41e5f:	48 89 c1             	mov    %rax,%rcx
   41e62:	ba 00 00 00 00       	mov    $0x0,%edx
   41e67:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41e6e:	0e 00 00 
   41e71:	bf 40 f2 04 00       	mov    $0x4f240,%edi
   41e76:	e8 49 fe ff ff       	callq  41cc4 <set_gate>
             (uint64_t) timer_int_handler);

    // GPF and page fault
    set_gate(&interrupt_descriptors[INT_GPF], X86GATE_INTERRUPT, 0,
   41e7b:	b8 2e 00 04 00       	mov    $0x4002e,%eax
   41e80:	48 89 c1             	mov    %rax,%rcx
   41e83:	ba 00 00 00 00       	mov    $0x0,%edx
   41e88:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41e8f:	0e 00 00 
   41e92:	bf 10 f1 04 00       	mov    $0x4f110,%edi
   41e97:	e8 28 fe ff ff       	callq  41cc4 <set_gate>
             (uint64_t) gpf_int_handler);
    set_gate(&interrupt_descriptors[INT_PAGEFAULT], X86GATE_INTERRUPT, 0,
   41e9c:	b8 32 00 04 00       	mov    $0x40032,%eax
   41ea1:	48 89 c1             	mov    %rax,%rcx
   41ea4:	ba 00 00 00 00       	mov    $0x0,%edx
   41ea9:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41eb0:	0e 00 00 
   41eb3:	bf 20 f1 04 00       	mov    $0x4f120,%edi
   41eb8:	e8 07 fe ff ff       	callq  41cc4 <set_gate>
             (uint64_t) pagefault_int_handler);

    // System calls get special handling.
    // Note that the last argument is '3'.  This means that unprivileged
    // (level-3) applications may generate these interrupts.
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   41ebd:	c7 45 f8 30 00 00 00 	movl   $0x30,-0x8(%rbp)
   41ec4:	eb 3e                	jmp    41f04 <segments_init+0x1cc>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
                 (uint64_t) sys_int_handlers[i - INT_SYS]);
   41ec6:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41ec9:	83 e8 30             	sub    $0x30,%eax
   41ecc:	89 c0                	mov    %eax,%eax
   41ece:	48 8b 04 c5 e7 00 04 	mov    0x400e7(,%rax,8),%rax
   41ed5:	00 
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
   41ed6:	48 89 c2             	mov    %rax,%rdx
   41ed9:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41edc:	48 c1 e0 04          	shl    $0x4,%rax
   41ee0:	48 05 40 f0 04 00    	add    $0x4f040,%rax
   41ee6:	48 89 d1             	mov    %rdx,%rcx
   41ee9:	ba 03 00 00 00       	mov    $0x3,%edx
   41eee:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41ef5:	0e 00 00 
   41ef8:	48 89 c7             	mov    %rax,%rdi
   41efb:	e8 c4 fd ff ff       	callq  41cc4 <set_gate>
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   41f00:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   41f04:	83 7d f8 3f          	cmpl   $0x3f,-0x8(%rbp)
   41f08:	76 bc                	jbe    41ec6 <segments_init+0x18e>
    }

    x86_64_pseudodescriptor idt;
    idt.pseudod_limit = sizeof(interrupt_descriptors) - 1;
   41f0a:	66 c7 45 cc ff 0f    	movw   $0xfff,-0x34(%rbp)
    idt.pseudod_base = (uint64_t) interrupt_descriptors;
   41f10:	b8 40 f0 04 00       	mov    $0x4f040,%eax
   41f15:	48 89 45 ce          	mov    %rax,-0x32(%rbp)

    // Reload segment pointers
    asm volatile("lgdt %0\n\t"
   41f19:	b8 28 00 00 00       	mov    $0x28,%eax
   41f1e:	0f 01 55 d6          	lgdt   -0x2a(%rbp)
   41f22:	0f 00 d8             	ltr    %ax
   41f25:	0f 01 5d cc          	lidt   -0x34(%rbp)
    asm volatile("movq %%cr0,%0" : "=r" (val));
   41f29:	0f 20 c0             	mov    %cr0,%rax
   41f2c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    return val;
   41f30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
                     "r" ((uint16_t) SEGSEL_TASKSTATE),
                     "m" (idt)
                 : "memory");

    // Set up control registers: check alignment
    uint32_t cr0 = rcr0();
   41f34:	89 45 f4             	mov    %eax,-0xc(%rbp)
    cr0 |= CR0_PE | CR0_PG | CR0_WP | CR0_AM | CR0_MP | CR0_NE;
   41f37:	81 4d f4 23 00 05 80 	orl    $0x80050023,-0xc(%rbp)
   41f3e:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41f41:	89 45 f0             	mov    %eax,-0x10(%rbp)
    uint64_t xval = val;
   41f44:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41f47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    asm volatile("movq %0,%%cr0" : : "r" (xval));
   41f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41f4f:	0f 22 c0             	mov    %rax,%cr0
}
   41f52:	90                   	nop
    lcr0(cr0);
}
   41f53:	90                   	nop
   41f54:	c9                   	leaveq 
   41f55:	c3                   	retq   

0000000000041f56 <interrupt_mask>:
#define TIMER_FREQ      1193182
#define TIMER_DIV(x)    ((TIMER_FREQ+(x)/2)/(x))

static uint16_t interrupts_enabled;

static void interrupt_mask(void) {
   41f56:	55                   	push   %rbp
   41f57:	48 89 e5             	mov    %rsp,%rbp
   41f5a:	48 83 ec 20          	sub    $0x20,%rsp
    uint16_t masked = ~interrupts_enabled;
   41f5e:	0f b7 05 3b e1 00 00 	movzwl 0xe13b(%rip),%eax        # 500a0 <interrupts_enabled>
   41f65:	f7 d0                	not    %eax
   41f67:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
    outb(IO_PIC1+1, masked & 0xFF);
   41f6b:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   41f6f:	0f b6 c0             	movzbl %al,%eax
   41f72:	c7 45 f0 21 00 00 00 	movl   $0x21,-0x10(%rbp)
   41f79:	88 45 ef             	mov    %al,-0x11(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f7c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   41f80:	8b 55 f0             	mov    -0x10(%rbp),%edx
   41f83:	ee                   	out    %al,(%dx)
}
   41f84:	90                   	nop
    outb(IO_PIC2+1, (masked >> 8) & 0xFF);
   41f85:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   41f89:	66 c1 e8 08          	shr    $0x8,%ax
   41f8d:	0f b6 c0             	movzbl %al,%eax
   41f90:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%rbp)
   41f97:	88 45 f7             	mov    %al,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f9a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   41f9e:	8b 55 f8             	mov    -0x8(%rbp),%edx
   41fa1:	ee                   	out    %al,(%dx)
}
   41fa2:	90                   	nop
}
   41fa3:	90                   	nop
   41fa4:	c9                   	leaveq 
   41fa5:	c3                   	retq   

0000000000041fa6 <interrupt_init>:

void interrupt_init(void) {
   41fa6:	55                   	push   %rbp
   41fa7:	48 89 e5             	mov    %rsp,%rbp
   41faa:	48 83 ec 60          	sub    $0x60,%rsp
    // mask all interrupts
    interrupts_enabled = 0;
   41fae:	66 c7 05 e9 e0 00 00 	movw   $0x0,0xe0e9(%rip)        # 500a0 <interrupts_enabled>
   41fb5:	00 00 
    interrupt_mask();
   41fb7:	e8 9a ff ff ff       	callq  41f56 <interrupt_mask>
   41fbc:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%rbp)
   41fc3:	c6 45 a3 11          	movb   $0x11,-0x5d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41fc7:	0f b6 45 a3          	movzbl -0x5d(%rbp),%eax
   41fcb:	8b 55 a4             	mov    -0x5c(%rbp),%edx
   41fce:	ee                   	out    %al,(%dx)
}
   41fcf:	90                   	nop
   41fd0:	c7 45 ac 21 00 00 00 	movl   $0x21,-0x54(%rbp)
   41fd7:	c6 45 ab 20          	movb   $0x20,-0x55(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41fdb:	0f b6 45 ab          	movzbl -0x55(%rbp),%eax
   41fdf:	8b 55 ac             	mov    -0x54(%rbp),%edx
   41fe2:	ee                   	out    %al,(%dx)
}
   41fe3:	90                   	nop
   41fe4:	c7 45 b4 21 00 00 00 	movl   $0x21,-0x4c(%rbp)
   41feb:	c6 45 b3 04          	movb   $0x4,-0x4d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41fef:	0f b6 45 b3          	movzbl -0x4d(%rbp),%eax
   41ff3:	8b 55 b4             	mov    -0x4c(%rbp),%edx
   41ff6:	ee                   	out    %al,(%dx)
}
   41ff7:	90                   	nop
   41ff8:	c7 45 bc 21 00 00 00 	movl   $0x21,-0x44(%rbp)
   41fff:	c6 45 bb 03          	movb   $0x3,-0x45(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42003:	0f b6 45 bb          	movzbl -0x45(%rbp),%eax
   42007:	8b 55 bc             	mov    -0x44(%rbp),%edx
   4200a:	ee                   	out    %al,(%dx)
}
   4200b:	90                   	nop
   4200c:	c7 45 c4 a0 00 00 00 	movl   $0xa0,-0x3c(%rbp)
   42013:	c6 45 c3 11          	movb   $0x11,-0x3d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42017:	0f b6 45 c3          	movzbl -0x3d(%rbp),%eax
   4201b:	8b 55 c4             	mov    -0x3c(%rbp),%edx
   4201e:	ee                   	out    %al,(%dx)
}
   4201f:	90                   	nop
   42020:	c7 45 cc a1 00 00 00 	movl   $0xa1,-0x34(%rbp)
   42027:	c6 45 cb 28          	movb   $0x28,-0x35(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4202b:	0f b6 45 cb          	movzbl -0x35(%rbp),%eax
   4202f:	8b 55 cc             	mov    -0x34(%rbp),%edx
   42032:	ee                   	out    %al,(%dx)
}
   42033:	90                   	nop
   42034:	c7 45 d4 a1 00 00 00 	movl   $0xa1,-0x2c(%rbp)
   4203b:	c6 45 d3 02          	movb   $0x2,-0x2d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4203f:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
   42043:	8b 55 d4             	mov    -0x2c(%rbp),%edx
   42046:	ee                   	out    %al,(%dx)
}
   42047:	90                   	nop
   42048:	c7 45 dc a1 00 00 00 	movl   $0xa1,-0x24(%rbp)
   4204f:	c6 45 db 01          	movb   $0x1,-0x25(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42053:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
   42057:	8b 55 dc             	mov    -0x24(%rbp),%edx
   4205a:	ee                   	out    %al,(%dx)
}
   4205b:	90                   	nop
   4205c:	c7 45 e4 20 00 00 00 	movl   $0x20,-0x1c(%rbp)
   42063:	c6 45 e3 68          	movb   $0x68,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42067:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   4206b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   4206e:	ee                   	out    %al,(%dx)
}
   4206f:	90                   	nop
   42070:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%rbp)
   42077:	c6 45 eb 0a          	movb   $0xa,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4207b:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   4207f:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42082:	ee                   	out    %al,(%dx)
}
   42083:	90                   	nop
   42084:	c7 45 f4 a0 00 00 00 	movl   $0xa0,-0xc(%rbp)
   4208b:	c6 45 f3 68          	movb   $0x68,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4208f:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   42093:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42096:	ee                   	out    %al,(%dx)
}
   42097:	90                   	nop
   42098:	c7 45 fc a0 00 00 00 	movl   $0xa0,-0x4(%rbp)
   4209f:	c6 45 fb 0a          	movb   $0xa,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   420a3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   420a7:	8b 55 fc             	mov    -0x4(%rbp),%edx
   420aa:	ee                   	out    %al,(%dx)
}
   420ab:	90                   	nop

    outb(IO_PIC2, 0x68);               /* OCW3 */
    outb(IO_PIC2, 0x0a);               /* OCW3 */

    // re-disable interrupts
    interrupt_mask();
   420ac:	e8 a5 fe ff ff       	callq  41f56 <interrupt_mask>
}
   420b1:	90                   	nop
   420b2:	c9                   	leaveq 
   420b3:	c3                   	retq   

00000000000420b4 <timer_init>:

// timer_init(rate)
//    Set the timer interrupt to fire `rate` times a second. Disables the
//    timer interrupt if `rate <= 0`.

void timer_init(int rate) {
   420b4:	55                   	push   %rbp
   420b5:	48 89 e5             	mov    %rsp,%rbp
   420b8:	48 83 ec 28          	sub    $0x28,%rsp
   420bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (rate > 0) {
   420bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   420c3:	0f 8e 9e 00 00 00    	jle    42167 <timer_init+0xb3>
   420c9:	c7 45 ec 43 00 00 00 	movl   $0x43,-0x14(%rbp)
   420d0:	c6 45 eb 34          	movb   $0x34,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   420d4:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   420d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
   420db:	ee                   	out    %al,(%dx)
}
   420dc:	90                   	nop
        outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
        outb(IO_TIMER1, TIMER_DIV(rate) % 256);
   420dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
   420e0:	89 c2                	mov    %eax,%edx
   420e2:	c1 ea 1f             	shr    $0x1f,%edx
   420e5:	01 d0                	add    %edx,%eax
   420e7:	d1 f8                	sar    %eax
   420e9:	05 de 34 12 00       	add    $0x1234de,%eax
   420ee:	99                   	cltd   
   420ef:	f7 7d dc             	idivl  -0x24(%rbp)
   420f2:	89 c2                	mov    %eax,%edx
   420f4:	89 d0                	mov    %edx,%eax
   420f6:	c1 f8 1f             	sar    $0x1f,%eax
   420f9:	c1 e8 18             	shr    $0x18,%eax
   420fc:	01 c2                	add    %eax,%edx
   420fe:	0f b6 d2             	movzbl %dl,%edx
   42101:	29 c2                	sub    %eax,%edx
   42103:	89 d0                	mov    %edx,%eax
   42105:	0f b6 c0             	movzbl %al,%eax
   42108:	c7 45 f4 40 00 00 00 	movl   $0x40,-0xc(%rbp)
   4210f:	88 45 f3             	mov    %al,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42112:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   42116:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42119:	ee                   	out    %al,(%dx)
}
   4211a:	90                   	nop
        outb(IO_TIMER1, TIMER_DIV(rate) / 256);
   4211b:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4211e:	89 c2                	mov    %eax,%edx
   42120:	c1 ea 1f             	shr    $0x1f,%edx
   42123:	01 d0                	add    %edx,%eax
   42125:	d1 f8                	sar    %eax
   42127:	05 de 34 12 00       	add    $0x1234de,%eax
   4212c:	99                   	cltd   
   4212d:	f7 7d dc             	idivl  -0x24(%rbp)
   42130:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   42136:	85 c0                	test   %eax,%eax
   42138:	0f 48 c2             	cmovs  %edx,%eax
   4213b:	c1 f8 08             	sar    $0x8,%eax
   4213e:	0f b6 c0             	movzbl %al,%eax
   42141:	c7 45 fc 40 00 00 00 	movl   $0x40,-0x4(%rbp)
   42148:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4214b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   4214f:	8b 55 fc             	mov    -0x4(%rbp),%edx
   42152:	ee                   	out    %al,(%dx)
}
   42153:	90                   	nop
        interrupts_enabled |= 1 << (INT_TIMER - INT_HARDWARE);
   42154:	0f b7 05 45 df 00 00 	movzwl 0xdf45(%rip),%eax        # 500a0 <interrupts_enabled>
   4215b:	83 c8 01             	or     $0x1,%eax
   4215e:	66 89 05 3b df 00 00 	mov    %ax,0xdf3b(%rip)        # 500a0 <interrupts_enabled>
   42165:	eb 11                	jmp    42178 <timer_init+0xc4>
    } else {
        interrupts_enabled &= ~(1 << (INT_TIMER - INT_HARDWARE));
   42167:	0f b7 05 32 df 00 00 	movzwl 0xdf32(%rip),%eax        # 500a0 <interrupts_enabled>
   4216e:	83 e0 fe             	and    $0xfffffffe,%eax
   42171:	66 89 05 28 df 00 00 	mov    %ax,0xdf28(%rip)        # 500a0 <interrupts_enabled>
    }
    interrupt_mask();
   42178:	e8 d9 fd ff ff       	callq  41f56 <interrupt_mask>
}
   4217d:	90                   	nop
   4217e:	c9                   	leaveq 
   4217f:	c3                   	retq   

0000000000042180 <virtual_memory_init>:
//    `kernel_pagetable`.

static x86_64_pagetable kernel_pagetables[5];
x86_64_pagetable* kernel_pagetable;

void virtual_memory_init(void) {
   42180:	55                   	push   %rbp
   42181:	48 89 e5             	mov    %rsp,%rbp
   42184:	48 83 ec 10          	sub    $0x10,%rsp
    kernel_pagetable = &kernel_pagetables[0];
   42188:	48 c7 05 2d 41 01 00 	movq   $0x51000,0x1412d(%rip)        # 562c0 <kernel_pagetable>
   4218f:	00 10 05 00 
    memset(kernel_pagetables, 0, sizeof(kernel_pagetables));
   42193:	ba 00 50 00 00       	mov    $0x5000,%edx
   42198:	be 00 00 00 00       	mov    $0x0,%esi
   4219d:	bf 00 10 05 00       	mov    $0x51000,%edi
   421a2:	e8 b7 14 00 00       	callq  4365e <memset>
    kernel_pagetables[0].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[1] | PTE_P | PTE_W | PTE_U;
   421a7:	b8 00 20 05 00       	mov    $0x52000,%eax
   421ac:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[0].entry[0] =
   421b0:	48 89 05 49 ee 00 00 	mov    %rax,0xee49(%rip)        # 51000 <kernel_pagetables>
    kernel_pagetables[1].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[2] | PTE_P | PTE_W | PTE_U;
   421b7:	b8 00 30 05 00       	mov    $0x53000,%eax
   421bc:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[1].entry[0] =
   421c0:	48 89 05 39 fe 00 00 	mov    %rax,0xfe39(%rip)        # 52000 <kernel_pagetables+0x1000>
    kernel_pagetables[2].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[3] | PTE_P | PTE_W | PTE_U;
   421c7:	b8 00 40 05 00       	mov    $0x54000,%eax
   421cc:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[0] =
   421d0:	48 89 05 29 0e 01 00 	mov    %rax,0x10e29(%rip)        # 53000 <kernel_pagetables+0x2000>
    kernel_pagetables[2].entry[1] =
        (x86_64_pageentry_t) &kernel_pagetables[4] | PTE_P | PTE_W | PTE_U;
   421d7:	b8 00 50 05 00       	mov    $0x55000,%eax
   421dc:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[1] =
   421e0:	48 89 05 21 0e 01 00 	mov    %rax,0x10e21(%rip)        # 53008 <kernel_pagetables+0x2008>

    virtual_memory_map(kernel_pagetable, (uintptr_t) 0, (uintptr_t) 0,
   421e7:	48 8b 05 d2 40 01 00 	mov    0x140d2(%rip),%rax        # 562c0 <kernel_pagetable>
   421ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   421f4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   421fa:	b9 00 00 20 00       	mov    $0x200000,%ecx
   421ff:	ba 00 00 00 00       	mov    $0x0,%edx
   42204:	be 00 00 00 00       	mov    $0x0,%esi
   42209:	48 89 c7             	mov    %rax,%rdi
   4220c:	e8 16 00 00 00       	callq  42227 <virtual_memory_map>
                       MEMSIZE_PHYSICAL, PTE_P | PTE_W | PTE_U, NULL);

    lcr3((uintptr_t) kernel_pagetable);
   42211:	48 8b 05 a8 40 01 00 	mov    0x140a8(%rip),%rax        # 562c0 <kernel_pagetable>
   42218:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
}

static inline void lcr3(uintptr_t val) {
    asm volatile("" : : : "memory");
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   4221c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42220:	0f 22 d8             	mov    %rax,%cr3
}
   42223:	90                   	nop
}
   42224:	90                   	nop
   42225:	c9                   	leaveq 
   42226:	c3                   	retq   

0000000000042227 <virtual_memory_map>:
static x86_64_pagetable* lookup_l4pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm, x86_64_pagetable* (*allocator)(void));

int virtual_memory_map(x86_64_pagetable* pagetable, uintptr_t va,
                       uintptr_t pa, size_t sz, int perm,
                       x86_64_pagetable* (*allocator)(void)) {
   42227:	55                   	push   %rbp
   42228:	48 89 e5             	mov    %rsp,%rbp
   4222b:	53                   	push   %rbx
   4222c:	48 83 ec 58          	sub    $0x58,%rsp
   42230:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   42234:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   42238:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
   4223c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
   42240:	44 89 45 ac          	mov    %r8d,-0x54(%rbp)
   42244:	4c 89 4d a0          	mov    %r9,-0x60(%rbp)

    assert(va % PAGESIZE == 0); // virtual address is page-aligned
   42248:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   4224c:	25 ff 0f 00 00       	and    $0xfff,%eax
   42251:	48 85 c0             	test   %rax,%rax
   42254:	74 14                	je     4226a <virtual_memory_map+0x43>
   42256:	ba 22 44 04 00       	mov    $0x44422,%edx
   4225b:	be 3c 01 00 00       	mov    $0x13c,%esi
   42260:	bf 35 44 04 00       	mov    $0x44435,%edi
   42265:	e8 31 0f 00 00       	callq  4319b <assert_fail>
    assert(sz % PAGESIZE == 0); // size is a multiple of PAGESIZE
   4226a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   4226e:	25 ff 0f 00 00       	and    $0xfff,%eax
   42273:	48 85 c0             	test   %rax,%rax
   42276:	74 14                	je     4228c <virtual_memory_map+0x65>
   42278:	ba 42 44 04 00       	mov    $0x44442,%edx
   4227d:	be 3d 01 00 00       	mov    $0x13d,%esi
   42282:	bf 35 44 04 00       	mov    $0x44435,%edi
   42287:	e8 0f 0f 00 00       	callq  4319b <assert_fail>
    assert(va + sz >= va || va + sz == 0); // va range does not wrap
   4228c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   42290:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42294:	48 01 d0             	add    %rdx,%rax
   42297:	48 39 45 c0          	cmp    %rax,-0x40(%rbp)
   4229b:	76 24                	jbe    422c1 <virtual_memory_map+0x9a>
   4229d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   422a1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   422a5:	48 01 d0             	add    %rdx,%rax
   422a8:	48 85 c0             	test   %rax,%rax
   422ab:	74 14                	je     422c1 <virtual_memory_map+0x9a>
   422ad:	ba 55 44 04 00       	mov    $0x44455,%edx
   422b2:	be 3e 01 00 00       	mov    $0x13e,%esi
   422b7:	bf 35 44 04 00       	mov    $0x44435,%edi
   422bc:	e8 da 0e 00 00       	callq  4319b <assert_fail>
    if (perm & PTE_P) {
   422c1:	8b 45 ac             	mov    -0x54(%rbp),%eax
   422c4:	48 98                	cltq   
   422c6:	83 e0 01             	and    $0x1,%eax
   422c9:	48 85 c0             	test   %rax,%rax
   422cc:	74 6e                	je     4233c <virtual_memory_map+0x115>
        assert(pa % PAGESIZE == 0); // physical addr is page-aligned
   422ce:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   422d2:	25 ff 0f 00 00       	and    $0xfff,%eax
   422d7:	48 85 c0             	test   %rax,%rax
   422da:	74 14                	je     422f0 <virtual_memory_map+0xc9>
   422dc:	ba 73 44 04 00       	mov    $0x44473,%edx
   422e1:	be 40 01 00 00       	mov    $0x140,%esi
   422e6:	bf 35 44 04 00       	mov    $0x44435,%edi
   422eb:	e8 ab 0e 00 00       	callq  4319b <assert_fail>
        assert(pa + sz >= pa);      // physical address range does not wrap
   422f0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   422f4:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   422f8:	48 01 d0             	add    %rdx,%rax
   422fb:	48 39 45 b8          	cmp    %rax,-0x48(%rbp)
   422ff:	76 14                	jbe    42315 <virtual_memory_map+0xee>
   42301:	ba 86 44 04 00       	mov    $0x44486,%edx
   42306:	be 41 01 00 00       	mov    $0x141,%esi
   4230b:	bf 35 44 04 00       	mov    $0x44435,%edi
   42310:	e8 86 0e 00 00       	callq  4319b <assert_fail>
        assert(pa + sz <= MEMSIZE_PHYSICAL); // physical addresses exist
   42315:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   42319:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   4231d:	48 01 d0             	add    %rdx,%rax
   42320:	48 3d 00 00 20 00    	cmp    $0x200000,%rax
   42326:	76 14                	jbe    4233c <virtual_memory_map+0x115>
   42328:	ba 94 44 04 00       	mov    $0x44494,%edx
   4232d:	be 42 01 00 00       	mov    $0x142,%esi
   42332:	bf 35 44 04 00       	mov    $0x44435,%edi
   42337:	e8 5f 0e 00 00       	callq  4319b <assert_fail>
    }
    assert(perm >= 0 && perm < 0x1000); // `perm` makes sense
   4233c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
   42340:	78 09                	js     4234b <virtual_memory_map+0x124>
   42342:	81 7d ac ff 0f 00 00 	cmpl   $0xfff,-0x54(%rbp)
   42349:	7e 14                	jle    4235f <virtual_memory_map+0x138>
   4234b:	ba b0 44 04 00       	mov    $0x444b0,%edx
   42350:	be 44 01 00 00       	mov    $0x144,%esi
   42355:	bf 35 44 04 00       	mov    $0x44435,%edi
   4235a:	e8 3c 0e 00 00       	callq  4319b <assert_fail>
    assert((uintptr_t) pagetable % PAGESIZE == 0); // `pagetable` page-aligned
   4235f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42363:	25 ff 0f 00 00       	and    $0xfff,%eax
   42368:	48 85 c0             	test   %rax,%rax
   4236b:	74 14                	je     42381 <virtual_memory_map+0x15a>
   4236d:	ba d0 44 04 00       	mov    $0x444d0,%edx
   42372:	be 45 01 00 00       	mov    $0x145,%esi
   42377:	bf 35 44 04 00       	mov    $0x44435,%edi
   4237c:	e8 1a 0e 00 00       	callq  4319b <assert_fail>

    int last_index123 = -1;
   42381:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%rbp)
    x86_64_pagetable* l4pagetable = NULL;
   42388:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
   4238f:	00 
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   42390:	e9 ce 00 00 00       	jmpq   42463 <virtual_memory_map+0x23c>
        int cur_index123 = (va >> (PAGEOFFBITS + PAGEINDEXBITS));
   42395:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42399:	48 c1 e8 15          	shr    $0x15,%rax
   4239d:	89 45 dc             	mov    %eax,-0x24(%rbp)
        if (cur_index123 != last_index123) {
   423a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
   423a3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
   423a6:	74 21                	je     423c9 <virtual_memory_map+0x1a2>
            l4pagetable = lookup_l4pagetable(pagetable, va, perm, allocator);
   423a8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
   423ac:	8b 55 ac             	mov    -0x54(%rbp),%edx
   423af:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
   423b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   423b7:	48 89 c7             	mov    %rax,%rdi
   423ba:	e8 bb 00 00 00       	callq  4247a <lookup_l4pagetable>
   423bf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            last_index123 = cur_index123;
   423c3:	8b 45 dc             	mov    -0x24(%rbp),%eax
   423c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
        }
        if ((perm & PTE_P) && l4pagetable) {
   423c9:	8b 45 ac             	mov    -0x54(%rbp),%eax
   423cc:	48 98                	cltq   
   423ce:	83 e0 01             	and    $0x1,%eax
   423d1:	48 85 c0             	test   %rax,%rax
   423d4:	74 34                	je     4240a <virtual_memory_map+0x1e3>
   423d6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   423db:	74 2d                	je     4240a <virtual_memory_map+0x1e3>
            l4pagetable->entry[L4PAGEINDEX(va)] = pa | perm;
   423dd:	8b 45 ac             	mov    -0x54(%rbp),%eax
   423e0:	48 63 d8             	movslq %eax,%rbx
   423e3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   423e7:	be 03 00 00 00       	mov    $0x3,%esi
   423ec:	48 89 c7             	mov    %rax,%rdi
   423ef:	e8 96 f7 ff ff       	callq  41b8a <pageindex>
   423f4:	89 c2                	mov    %eax,%edx
   423f6:	48 0b 5d b8          	or     -0x48(%rbp),%rbx
   423fa:	48 89 d9             	mov    %rbx,%rcx
   423fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42401:	48 63 d2             	movslq %edx,%rdx
   42404:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   42408:	eb 41                	jmp    4244b <virtual_memory_map+0x224>
        } else if (l4pagetable) {
   4240a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   4240f:	74 26                	je     42437 <virtual_memory_map+0x210>
            l4pagetable->entry[L4PAGEINDEX(va)] = perm;
   42411:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42415:	be 03 00 00 00       	mov    $0x3,%esi
   4241a:	48 89 c7             	mov    %rax,%rdi
   4241d:	e8 68 f7 ff ff       	callq  41b8a <pageindex>
   42422:	89 c2                	mov    %eax,%edx
   42424:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42427:	48 63 c8             	movslq %eax,%rcx
   4242a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4242e:	48 63 d2             	movslq %edx,%rdx
   42431:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   42435:	eb 14                	jmp    4244b <virtual_memory_map+0x224>
        } else if (perm & PTE_P) {
   42437:	8b 45 ac             	mov    -0x54(%rbp),%eax
   4243a:	48 98                	cltq   
   4243c:	83 e0 01             	and    $0x1,%eax
   4243f:	48 85 c0             	test   %rax,%rax
   42442:	74 07                	je     4244b <virtual_memory_map+0x224>
            return -1;
   42444:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42449:	eb 28                	jmp    42473 <virtual_memory_map+0x24c>
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   4244b:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
   42452:	00 
   42453:	48 81 45 b8 00 10 00 	addq   $0x1000,-0x48(%rbp)
   4245a:	00 
   4245b:	48 81 6d b0 00 10 00 	subq   $0x1000,-0x50(%rbp)
   42462:	00 
   42463:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
   42468:	0f 85 27 ff ff ff    	jne    42395 <virtual_memory_map+0x16e>
        }
    }
    return 0;
   4246e:	b8 00 00 00 00       	mov    $0x0,%eax
}
   42473:	48 83 c4 58          	add    $0x58,%rsp
   42477:	5b                   	pop    %rbx
   42478:	5d                   	pop    %rbp
   42479:	c3                   	retq   

000000000004247a <lookup_l4pagetable>:

static x86_64_pagetable* lookup_l4pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm, x86_64_pagetable* (*allocator)(void)) {
   4247a:	55                   	push   %rbp
   4247b:	48 89 e5             	mov    %rsp,%rbp
   4247e:	48 83 ec 40          	sub    $0x40,%rsp
   42482:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   42486:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
   4248a:	89 55 cc             	mov    %edx,-0x34(%rbp)
   4248d:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    x86_64_pagetable* pt = pagetable;
   42491:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42495:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 2; ++i) {
   42499:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   424a0:	e9 69 01 00 00       	jmpq   4260e <lookup_l4pagetable+0x194>
        x86_64_pageentry_t pe = pt->entry[PAGEINDEX(va, i)];
   424a5:	8b 55 f4             	mov    -0xc(%rbp),%edx
   424a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   424ac:	89 d6                	mov    %edx,%esi
   424ae:	48 89 c7             	mov    %rax,%rdi
   424b1:	e8 d4 f6 ff ff       	callq  41b8a <pageindex>
   424b6:	89 c2                	mov    %eax,%edx
   424b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   424bc:	48 63 d2             	movslq %edx,%rdx
   424bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   424c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        if (!(pe & PTE_P)) {
   424c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   424cb:	83 e0 01             	and    $0x1,%eax
   424ce:	48 85 c0             	test   %rax,%rax
   424d1:	0f 85 a5 00 00 00    	jne    4257c <lookup_l4pagetable+0x102>
            // allocate a new page table page if required
            if (!(perm & PTE_P) || !allocator) {
   424d7:	8b 45 cc             	mov    -0x34(%rbp),%eax
   424da:	48 98                	cltq   
   424dc:	83 e0 01             	and    $0x1,%eax
   424df:	48 85 c0             	test   %rax,%rax
   424e2:	74 07                	je     424eb <lookup_l4pagetable+0x71>
   424e4:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
   424e9:	75 0a                	jne    424f5 <lookup_l4pagetable+0x7b>
                return NULL;
   424eb:	b8 00 00 00 00       	mov    $0x0,%eax
   424f0:	e9 27 01 00 00       	jmpq   4261c <lookup_l4pagetable+0x1a2>
            }
            x86_64_pagetable* new_pt = allocator();
   424f5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   424f9:	ff d0                	callq  *%rax
   424fb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            if (!new_pt) {
   424ff:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   42504:	75 0a                	jne    42510 <lookup_l4pagetable+0x96>
                return NULL;
   42506:	b8 00 00 00 00       	mov    $0x0,%eax
   4250b:	e9 0c 01 00 00       	jmpq   4261c <lookup_l4pagetable+0x1a2>
            }
            assert((uintptr_t) new_pt % PAGESIZE == 0);
   42510:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42514:	25 ff 0f 00 00       	and    $0xfff,%eax
   42519:	48 85 c0             	test   %rax,%rax
   4251c:	74 14                	je     42532 <lookup_l4pagetable+0xb8>
   4251e:	ba f8 44 04 00       	mov    $0x444f8,%edx
   42523:	be 68 01 00 00       	mov    $0x168,%esi
   42528:	bf 35 44 04 00       	mov    $0x44435,%edi
   4252d:	e8 69 0c 00 00       	callq  4319b <assert_fail>
            pt->entry[PAGEINDEX(va, i)] = pe =
                PTE_ADDR(new_pt) | PTE_P | PTE_W | PTE_U;
   42532:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42536:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
            pt->entry[PAGEINDEX(va, i)] = pe =
   4253c:	48 83 c8 07          	or     $0x7,%rax
   42540:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   42544:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42547:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   4254b:	89 d6                	mov    %edx,%esi
   4254d:	48 89 c7             	mov    %rax,%rdi
   42550:	e8 35 f6 ff ff       	callq  41b8a <pageindex>
   42555:	89 c2                	mov    %eax,%edx
   42557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4255b:	48 63 d2             	movslq %edx,%rdx
   4255e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   42562:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
            memset(new_pt, 0, PAGESIZE);
   42566:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4256a:	ba 00 10 00 00       	mov    $0x1000,%edx
   4256f:	be 00 00 00 00       	mov    $0x0,%esi
   42574:	48 89 c7             	mov    %rax,%rdi
   42577:	e8 e2 10 00 00       	callq  4365e <memset>
        }

        // sanity-check page entry
        assert(PTE_ADDR(pe) < MEMSIZE_PHYSICAL); // at sensible address
   4257c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42580:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42586:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   4258c:	76 14                	jbe    425a2 <lookup_l4pagetable+0x128>
   4258e:	ba 20 45 04 00       	mov    $0x44520,%edx
   42593:	be 6f 01 00 00       	mov    $0x16f,%esi
   42598:	bf 35 44 04 00       	mov    $0x44435,%edi
   4259d:	e8 f9 0b 00 00       	callq  4319b <assert_fail>
        if (perm & PTE_W) {       // if requester wants PTE_W,
   425a2:	8b 45 cc             	mov    -0x34(%rbp),%eax
   425a5:	48 98                	cltq   
   425a7:	83 e0 02             	and    $0x2,%eax
   425aa:	48 85 c0             	test   %rax,%rax
   425ad:	74 20                	je     425cf <lookup_l4pagetable+0x155>
            assert(pe & PTE_W);   //   entry must allow PTE_W
   425af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   425b3:	83 e0 02             	and    $0x2,%eax
   425b6:	48 85 c0             	test   %rax,%rax
   425b9:	75 14                	jne    425cf <lookup_l4pagetable+0x155>
   425bb:	ba 40 45 04 00       	mov    $0x44540,%edx
   425c0:	be 71 01 00 00       	mov    $0x171,%esi
   425c5:	bf 35 44 04 00       	mov    $0x44435,%edi
   425ca:	e8 cc 0b 00 00       	callq  4319b <assert_fail>
        }
        if (perm & PTE_U) {       // if requester wants PTE_U,
   425cf:	8b 45 cc             	mov    -0x34(%rbp),%eax
   425d2:	48 98                	cltq   
   425d4:	83 e0 04             	and    $0x4,%eax
   425d7:	48 85 c0             	test   %rax,%rax
   425da:	74 20                	je     425fc <lookup_l4pagetable+0x182>
            assert(pe & PTE_U);   //   entry must allow PTE_U
   425dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   425e0:	83 e0 04             	and    $0x4,%eax
   425e3:	48 85 c0             	test   %rax,%rax
   425e6:	75 14                	jne    425fc <lookup_l4pagetable+0x182>
   425e8:	ba 4b 45 04 00       	mov    $0x4454b,%edx
   425ed:	be 74 01 00 00       	mov    $0x174,%esi
   425f2:	bf 35 44 04 00       	mov    $0x44435,%edi
   425f7:	e8 9f 0b 00 00       	callq  4319b <assert_fail>
        }

        pt = (x86_64_pagetable*) PTE_ADDR(pe);
   425fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42600:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42606:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 2; ++i) {
   4260a:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   4260e:	83 7d f4 02          	cmpl   $0x2,-0xc(%rbp)
   42612:	0f 8e 8d fe ff ff    	jle    424a5 <lookup_l4pagetable+0x2b>
    }
    return pt;
   42618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   4261c:	c9                   	leaveq 
   4261d:	c3                   	retq   

000000000004261e <virtual_memory_lookup>:

// virtual_memory_lookup(pagetable, va)
//    Returns information about the mapping of the virtual address `va` in
//    `pagetable`. The information is returned as a `vamapping` object.

vamapping virtual_memory_lookup(x86_64_pagetable* pagetable, uintptr_t va) {
   4261e:	55                   	push   %rbp
   4261f:	48 89 e5             	mov    %rsp,%rbp
   42622:	48 83 ec 50          	sub    $0x50,%rsp
   42626:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   4262a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   4262e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
    x86_64_pagetable* pt = pagetable;
   42632:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42636:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    x86_64_pageentry_t pe = PTE_W | PTE_U | PTE_P;
   4263a:	48 c7 45 f0 07 00 00 	movq   $0x7,-0x10(%rbp)
   42641:	00 
    for (int i = 0; i <= 3 && (pe & PTE_P); ++i) {
   42642:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
   42649:	eb 41                	jmp    4268c <virtual_memory_lookup+0x6e>
        pe = pt->entry[PAGEINDEX(va, i)] & ~(pe & (PTE_W | PTE_U));
   4264b:	8b 55 ec             	mov    -0x14(%rbp),%edx
   4264e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   42652:	89 d6                	mov    %edx,%esi
   42654:	48 89 c7             	mov    %rax,%rdi
   42657:	e8 2e f5 ff ff       	callq  41b8a <pageindex>
   4265c:	89 c2                	mov    %eax,%edx
   4265e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42662:	48 63 d2             	movslq %edx,%rdx
   42665:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   42669:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   4266d:	83 e2 06             	and    $0x6,%edx
   42670:	48 f7 d2             	not    %rdx
   42673:	48 21 d0             	and    %rdx,%rax
   42676:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
        pt = (x86_64_pagetable*) PTE_ADDR(pe);
   4267a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4267e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42684:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 3 && (pe & PTE_P); ++i) {
   42688:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
   4268c:	83 7d ec 03          	cmpl   $0x3,-0x14(%rbp)
   42690:	7f 0c                	jg     4269e <virtual_memory_lookup+0x80>
   42692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42696:	83 e0 01             	and    $0x1,%eax
   42699:	48 85 c0             	test   %rax,%rax
   4269c:	75 ad                	jne    4264b <virtual_memory_lookup+0x2d>
    }
    vamapping vam = { -1, (uintptr_t) -1, 0 };
   4269e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%rbp)
   426a5:	48 c7 45 d8 ff ff ff 	movq   $0xffffffffffffffff,-0x28(%rbp)
   426ac:	ff 
   426ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
    if (pe & PTE_P) {
   426b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   426b8:	83 e0 01             	and    $0x1,%eax
   426bb:	48 85 c0             	test   %rax,%rax
   426be:	74 34                	je     426f4 <virtual_memory_lookup+0xd6>
        vam.pn = PAGENUMBER(pe);
   426c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   426c4:	48 c1 e8 0c          	shr    $0xc,%rax
   426c8:	89 45 d0             	mov    %eax,-0x30(%rbp)
        vam.pa = PTE_ADDR(pe) + PAGEOFFSET(va);
   426cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   426cf:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   426d5:	48 89 c2             	mov    %rax,%rdx
   426d8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   426dc:	25 ff 0f 00 00       	and    $0xfff,%eax
   426e1:	48 09 d0             	or     %rdx,%rax
   426e4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
        vam.perm = PTE_FLAGS(pe);
   426e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   426ec:	25 ff 0f 00 00       	and    $0xfff,%eax
   426f1:	89 45 e0             	mov    %eax,-0x20(%rbp)
    }
    return vam;
   426f4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   426f8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   426fc:	48 89 10             	mov    %rdx,(%rax)
   426ff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   42703:	48 89 50 08          	mov    %rdx,0x8(%rax)
   42707:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   4270b:	48 89 50 10          	mov    %rdx,0x10(%rax)
}
   4270f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42713:	c9                   	leaveq 
   42714:	c3                   	retq   

0000000000042715 <set_pagetable>:
// set_pagetable
//    Change page directory. lcr3() is the hardware instruction;
//    set_pagetable() additionally checks that important kernel procedures are
//    mappable in `pagetable`, and calls panic() if they aren't.

void set_pagetable(x86_64_pagetable* pagetable) {
   42715:	55                   	push   %rbp
   42716:	48 89 e5             	mov    %rsp,%rbp
   42719:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
   4271d:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
    assert(PAGEOFFSET(pagetable) == 0); // must be page aligned
   42721:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42725:	25 ff 0f 00 00       	and    $0xfff,%eax
   4272a:	48 85 c0             	test   %rax,%rax
   4272d:	74 14                	je     42743 <set_pagetable+0x2e>
   4272f:	ba 56 45 04 00       	mov    $0x44556,%edx
   42734:	be 98 01 00 00       	mov    $0x198,%esi
   42739:	bf 35 44 04 00       	mov    $0x44435,%edi
   4273e:	e8 58 0a 00 00       	callq  4319b <assert_fail>
    assert(virtual_memory_lookup(pagetable, (uintptr_t) default_int_handler).pa
   42743:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   42748:	48 8d 45 98          	lea    -0x68(%rbp),%rax
   4274c:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42750:	48 89 ce             	mov    %rcx,%rsi
   42753:	48 89 c7             	mov    %rax,%rdi
   42756:	e8 c3 fe ff ff       	callq  4261e <virtual_memory_lookup>
   4275b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   4275f:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   42764:	48 39 d0             	cmp    %rdx,%rax
   42767:	74 14                	je     4277d <set_pagetable+0x68>
   42769:	ba 78 45 04 00       	mov    $0x44578,%edx
   4276e:	be 99 01 00 00       	mov    $0x199,%esi
   42773:	bf 35 44 04 00       	mov    $0x44435,%edi
   42778:	e8 1e 0a 00 00       	callq  4319b <assert_fail>
           == (uintptr_t) default_int_handler);
    assert(virtual_memory_lookup(kernel_pagetable, (uintptr_t) pagetable).pa
   4277d:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
   42781:	48 8b 0d 38 3b 01 00 	mov    0x13b38(%rip),%rcx        # 562c0 <kernel_pagetable>
   42788:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   4278c:	48 89 ce             	mov    %rcx,%rsi
   4278f:	48 89 c7             	mov    %rax,%rdi
   42792:	e8 87 fe ff ff       	callq  4261e <virtual_memory_lookup>
   42797:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   4279b:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   4279f:	48 39 c2             	cmp    %rax,%rdx
   427a2:	74 14                	je     427b8 <set_pagetable+0xa3>
   427a4:	ba e0 45 04 00       	mov    $0x445e0,%edx
   427a9:	be 9b 01 00 00       	mov    $0x19b,%esi
   427ae:	bf 35 44 04 00       	mov    $0x44435,%edi
   427b3:	e8 e3 09 00 00       	callq  4319b <assert_fail>
           == (uintptr_t) pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) kernel_pagetable).pa
   427b8:	48 8b 05 01 3b 01 00 	mov    0x13b01(%rip),%rax        # 562c0 <kernel_pagetable>
   427bf:	48 89 c2             	mov    %rax,%rdx
   427c2:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
   427c6:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   427ca:	48 89 ce             	mov    %rcx,%rsi
   427cd:	48 89 c7             	mov    %rax,%rdi
   427d0:	e8 49 fe ff ff       	callq  4261e <virtual_memory_lookup>
   427d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   427d9:	48 8b 15 e0 3a 01 00 	mov    0x13ae0(%rip),%rdx        # 562c0 <kernel_pagetable>
   427e0:	48 39 d0             	cmp    %rdx,%rax
   427e3:	74 14                	je     427f9 <set_pagetable+0xe4>
   427e5:	ba 40 46 04 00       	mov    $0x44640,%edx
   427ea:	be 9d 01 00 00       	mov    $0x19d,%esi
   427ef:	bf 35 44 04 00       	mov    $0x44435,%edi
   427f4:	e8 a2 09 00 00       	callq  4319b <assert_fail>
           == (uintptr_t) kernel_pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) virtual_memory_map).pa
   427f9:	ba 27 22 04 00       	mov    $0x42227,%edx
   427fe:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   42802:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42806:	48 89 ce             	mov    %rcx,%rsi
   42809:	48 89 c7             	mov    %rax,%rdi
   4280c:	e8 0d fe ff ff       	callq  4261e <virtual_memory_lookup>
   42811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42815:	ba 27 22 04 00       	mov    $0x42227,%edx
   4281a:	48 39 d0             	cmp    %rdx,%rax
   4281d:	74 14                	je     42833 <set_pagetable+0x11e>
   4281f:	ba a8 46 04 00       	mov    $0x446a8,%edx
   42824:	be 9f 01 00 00       	mov    $0x19f,%esi
   42829:	bf 35 44 04 00       	mov    $0x44435,%edi
   4282e:	e8 68 09 00 00       	callq  4319b <assert_fail>
           == (uintptr_t) virtual_memory_map);
    lcr3((uintptr_t) pagetable);
   42833:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42837:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   4283b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4283f:	0f 22 d8             	mov    %rax,%cr3
}
   42842:	90                   	nop
}
   42843:	90                   	nop
   42844:	c9                   	leaveq 
   42845:	c3                   	retq   

0000000000042846 <physical_memory_isreserved>:
//    Returns non-zero iff `pa` is a reserved physical address.

#define IOPHYSMEM       0x000A0000
#define EXTPHYSMEM      0x00100000

int physical_memory_isreserved(uintptr_t pa) {
   42846:	55                   	push   %rbp
   42847:	48 89 e5             	mov    %rsp,%rbp
   4284a:	48 83 ec 08          	sub    $0x8,%rsp
   4284e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    return pa == 0 || (pa >= IOPHYSMEM && pa < EXTPHYSMEM);
   42852:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   42857:	74 14                	je     4286d <physical_memory_isreserved+0x27>
   42859:	48 81 7d f8 ff ff 09 	cmpq   $0x9ffff,-0x8(%rbp)
   42860:	00 
   42861:	76 11                	jbe    42874 <physical_memory_isreserved+0x2e>
   42863:	48 81 7d f8 ff ff 0f 	cmpq   $0xfffff,-0x8(%rbp)
   4286a:	00 
   4286b:	77 07                	ja     42874 <physical_memory_isreserved+0x2e>
   4286d:	b8 01 00 00 00       	mov    $0x1,%eax
   42872:	eb 05                	jmp    42879 <physical_memory_isreserved+0x33>
   42874:	b8 00 00 00 00       	mov    $0x0,%eax
}
   42879:	c9                   	leaveq 
   4287a:	c3                   	retq   

000000000004287b <pci_make_configaddr>:


// pci_make_configaddr(bus, slot, func)
//    Construct a PCI configuration space address from parts.

static int pci_make_configaddr(int bus, int slot, int func) {
   4287b:	55                   	push   %rbp
   4287c:	48 89 e5             	mov    %rsp,%rbp
   4287f:	48 83 ec 10          	sub    $0x10,%rsp
   42883:	89 7d fc             	mov    %edi,-0x4(%rbp)
   42886:	89 75 f8             	mov    %esi,-0x8(%rbp)
   42889:	89 55 f4             	mov    %edx,-0xc(%rbp)
    return (bus << 16) | (slot << 11) | (func << 8);
   4288c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4288f:	c1 e0 10             	shl    $0x10,%eax
   42892:	89 c2                	mov    %eax,%edx
   42894:	8b 45 f8             	mov    -0x8(%rbp),%eax
   42897:	c1 e0 0b             	shl    $0xb,%eax
   4289a:	09 c2                	or     %eax,%edx
   4289c:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4289f:	c1 e0 08             	shl    $0x8,%eax
   428a2:	09 d0                	or     %edx,%eax
}
   428a4:	c9                   	leaveq 
   428a5:	c3                   	retq   

00000000000428a6 <pci_config_readl>:
//    Read a 32-bit word in PCI configuration space.

#define PCI_HOST_BRIDGE_CONFIG_ADDR 0xCF8
#define PCI_HOST_BRIDGE_CONFIG_DATA 0xCFC

static uint32_t pci_config_readl(int configaddr, int offset) {
   428a6:	55                   	push   %rbp
   428a7:	48 89 e5             	mov    %rsp,%rbp
   428aa:	48 83 ec 18          	sub    $0x18,%rsp
   428ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
   428b1:	89 75 e8             	mov    %esi,-0x18(%rbp)
    outl(PCI_HOST_BRIDGE_CONFIG_ADDR, 0x80000000 | configaddr | offset);
   428b4:	8b 55 ec             	mov    -0x14(%rbp),%edx
   428b7:	8b 45 e8             	mov    -0x18(%rbp),%eax
   428ba:	09 d0                	or     %edx,%eax
   428bc:	0d 00 00 00 80       	or     $0x80000000,%eax
   428c1:	c7 45 f4 f8 0c 00 00 	movl   $0xcf8,-0xc(%rbp)
   428c8:	89 45 f0             	mov    %eax,-0x10(%rbp)
    asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
   428cb:	8b 45 f0             	mov    -0x10(%rbp),%eax
   428ce:	8b 55 f4             	mov    -0xc(%rbp),%edx
   428d1:	ef                   	out    %eax,(%dx)
}
   428d2:	90                   	nop
   428d3:	c7 45 fc fc 0c 00 00 	movl   $0xcfc,-0x4(%rbp)
    asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
   428da:	8b 45 fc             	mov    -0x4(%rbp),%eax
   428dd:	89 c2                	mov    %eax,%edx
   428df:	ed                   	in     (%dx),%eax
   428e0:	89 45 f8             	mov    %eax,-0x8(%rbp)
    return data;
   428e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
    return inl(PCI_HOST_BRIDGE_CONFIG_DATA);
}
   428e6:	c9                   	leaveq 
   428e7:	c3                   	retq   

00000000000428e8 <pci_find_device>:

// pci_find_device
//    Search for a PCI device matching `vendor` and `device`. Return
//    the config base address or -1 if no device was found.

static int pci_find_device(int vendor, int device) {
   428e8:	55                   	push   %rbp
   428e9:	48 89 e5             	mov    %rsp,%rbp
   428ec:	48 83 ec 28          	sub    $0x28,%rsp
   428f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
   428f3:	89 75 d8             	mov    %esi,-0x28(%rbp)
    for (int bus = 0; bus != 256; ++bus) {
   428f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   428fd:	eb 73                	jmp    42972 <pci_find_device+0x8a>
        for (int slot = 0; slot != 32; ++slot) {
   428ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   42906:	eb 60                	jmp    42968 <pci_find_device+0x80>
            for (int func = 0; func != 8; ++func) {
   42908:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   4290f:	eb 4a                	jmp    4295b <pci_find_device+0x73>
                int configaddr = pci_make_configaddr(bus, slot, func);
   42911:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42914:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   42917:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4291a:	89 ce                	mov    %ecx,%esi
   4291c:	89 c7                	mov    %eax,%edi
   4291e:	e8 58 ff ff ff       	callq  4287b <pci_make_configaddr>
   42923:	89 45 f0             	mov    %eax,-0x10(%rbp)
                uint32_t vendor_device = pci_config_readl(configaddr, 0);
   42926:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42929:	be 00 00 00 00       	mov    $0x0,%esi
   4292e:	89 c7                	mov    %eax,%edi
   42930:	e8 71 ff ff ff       	callq  428a6 <pci_config_readl>
   42935:	89 45 ec             	mov    %eax,-0x14(%rbp)
                if (vendor_device == (uint32_t) (vendor | (device << 16))) {
   42938:	8b 45 d8             	mov    -0x28(%rbp),%eax
   4293b:	c1 e0 10             	shl    $0x10,%eax
   4293e:	0b 45 dc             	or     -0x24(%rbp),%eax
   42941:	39 45 ec             	cmp    %eax,-0x14(%rbp)
   42944:	75 05                	jne    4294b <pci_find_device+0x63>
                    return configaddr;
   42946:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42949:	eb 35                	jmp    42980 <pci_find_device+0x98>
                } else if (vendor_device == (uint32_t) -1 && func == 0) {
   4294b:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%rbp)
   4294f:	75 06                	jne    42957 <pci_find_device+0x6f>
   42951:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   42955:	74 0c                	je     42963 <pci_find_device+0x7b>
            for (int func = 0; func != 8; ++func) {
   42957:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   4295b:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
   4295f:	75 b0                	jne    42911 <pci_find_device+0x29>
   42961:	eb 01                	jmp    42964 <pci_find_device+0x7c>
                    break;
   42963:	90                   	nop
        for (int slot = 0; slot != 32; ++slot) {
   42964:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   42968:	83 7d f8 20          	cmpl   $0x20,-0x8(%rbp)
   4296c:	75 9a                	jne    42908 <pci_find_device+0x20>
    for (int bus = 0; bus != 256; ++bus) {
   4296e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   42972:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
   42979:	75 84                	jne    428ff <pci_find_device+0x17>
                }
            }
        }
    }
    return -1;
   4297b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
   42980:	c9                   	leaveq 
   42981:	c3                   	retq   

0000000000042982 <poweroff>:
//    that speaks ACPI; QEMU emulates a PIIX4 Power Management Controller.

#define PCI_VENDOR_ID_INTEL     0x8086
#define PCI_DEVICE_ID_PIIX4     0x7113

void poweroff(void) {
   42982:	55                   	push   %rbp
   42983:	48 89 e5             	mov    %rsp,%rbp
   42986:	48 83 ec 10          	sub    $0x10,%rsp
    int configaddr = pci_find_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PIIX4);
   4298a:	be 13 71 00 00       	mov    $0x7113,%esi
   4298f:	bf 86 80 00 00       	mov    $0x8086,%edi
   42994:	e8 4f ff ff ff       	callq  428e8 <pci_find_device>
   42999:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if (configaddr >= 0) {
   4299c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   429a0:	78 30                	js     429d2 <poweroff+0x50>
        // Read I/O base register from controller's PCI configuration space.
        int pm_io_base = pci_config_readl(configaddr, 0x40) & 0xFFC0;
   429a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
   429a5:	be 40 00 00 00       	mov    $0x40,%esi
   429aa:	89 c7                	mov    %eax,%edi
   429ac:	e8 f5 fe ff ff       	callq  428a6 <pci_config_readl>
   429b1:	25 c0 ff 00 00       	and    $0xffc0,%eax
   429b6:	89 45 f8             	mov    %eax,-0x8(%rbp)
        // Write `suspend enable` to the power management control register.
        outw(pm_io_base + 4, 0x2000);
   429b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
   429bc:	83 c0 04             	add    $0x4,%eax
   429bf:	89 45 f4             	mov    %eax,-0xc(%rbp)
   429c2:	66 c7 45 f2 00 20    	movw   $0x2000,-0xe(%rbp)
    asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
   429c8:	0f b7 45 f2          	movzwl -0xe(%rbp),%eax
   429cc:	8b 55 f4             	mov    -0xc(%rbp),%edx
   429cf:	66 ef                	out    %ax,(%dx)
}
   429d1:	90                   	nop
    }
    // No PIIX4; spin.
    console_printf(CPOS(24, 0), 0xC000, "Cannot power off!\n");
   429d2:	ba 0e 47 04 00       	mov    $0x4470e,%edx
   429d7:	be 00 c0 00 00       	mov    $0xc000,%esi
   429dc:	bf 80 07 00 00       	mov    $0x780,%edi
   429e1:	b8 00 00 00 00       	mov    $0x0,%eax
   429e6:	e8 b1 14 00 00       	callq  43e9c <console_printf>
 spinloop: goto spinloop;
   429eb:	eb fe                	jmp    429eb <poweroff+0x69>

00000000000429ed <reboot>:


// reboot
//    Reboot the virtual machine.

void reboot(void) {
   429ed:	55                   	push   %rbp
   429ee:	48 89 e5             	mov    %rsp,%rbp
   429f1:	48 83 ec 10          	sub    $0x10,%rsp
   429f5:	c7 45 fc 92 00 00 00 	movl   $0x92,-0x4(%rbp)
   429fc:	c6 45 fb 03          	movb   $0x3,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42a00:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42a04:	8b 55 fc             	mov    -0x4(%rbp),%edx
   42a07:	ee                   	out    %al,(%dx)
}
   42a08:	90                   	nop
    outb(0x92, 3);
 spinloop: goto spinloop;
   42a09:	eb fe                	jmp    42a09 <reboot+0x1c>

0000000000042a0b <process_init>:


// process_init(p, flags)
//    Initialize special-purpose registers for process `p`.

void process_init(proc* p, int flags) {
   42a0b:	55                   	push   %rbp
   42a0c:	48 89 e5             	mov    %rsp,%rbp
   42a0f:	48 83 ec 10          	sub    $0x10,%rsp
   42a13:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   42a17:	89 75 f4             	mov    %esi,-0xc(%rbp)
    memset(&p->p_registers, 0, sizeof(p->p_registers));
   42a1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42a1e:	48 83 c0 08          	add    $0x8,%rax
   42a22:	ba c0 00 00 00       	mov    $0xc0,%edx
   42a27:	be 00 00 00 00       	mov    $0x0,%esi
   42a2c:	48 89 c7             	mov    %rax,%rdi
   42a2f:	e8 2a 0c 00 00       	callq  4365e <memset>
    p->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
   42a34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42a38:	66 c7 80 a8 00 00 00 	movw   $0x13,0xa8(%rax)
   42a3f:	13 00 
    p->p_registers.reg_fs = SEGSEL_APP_DATA | 3;
   42a41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42a45:	48 c7 80 80 00 00 00 	movq   $0x23,0x80(%rax)
   42a4c:	23 00 00 00 
    p->p_registers.reg_gs = SEGSEL_APP_DATA | 3;
   42a50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42a54:	48 c7 80 88 00 00 00 	movq   $0x23,0x88(%rax)
   42a5b:	23 00 00 00 
    p->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
   42a5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42a63:	66 c7 80 c0 00 00 00 	movw   $0x23,0xc0(%rax)
   42a6a:	23 00 
    p->p_registers.reg_rflags = EFLAGS_IF;
   42a6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42a70:	48 c7 80 b0 00 00 00 	movq   $0x200,0xb0(%rax)
   42a77:	00 02 00 00 

    if (flags & PROCINIT_ALLOW_PROGRAMMED_IO) {
   42a7b:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42a7e:	83 e0 01             	and    $0x1,%eax
   42a81:	85 c0                	test   %eax,%eax
   42a83:	74 1c                	je     42aa1 <process_init+0x96>
        p->p_registers.reg_rflags |= EFLAGS_IOPL_3;
   42a85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42a89:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
   42a90:	80 cc 30             	or     $0x30,%ah
   42a93:	48 89 c2             	mov    %rax,%rdx
   42a96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42a9a:	48 89 90 b0 00 00 00 	mov    %rdx,0xb0(%rax)
    }
    if (flags & PROCINIT_DISABLE_INTERRUPTS) {
   42aa1:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42aa4:	83 e0 02             	and    $0x2,%eax
   42aa7:	85 c0                	test   %eax,%eax
   42aa9:	74 1c                	je     42ac7 <process_init+0xbc>
        p->p_registers.reg_rflags &= ~EFLAGS_IF;
   42aab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42aaf:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
   42ab6:	80 e4 fd             	and    $0xfd,%ah
   42ab9:	48 89 c2             	mov    %rax,%rdx
   42abc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42ac0:	48 89 90 b0 00 00 00 	mov    %rdx,0xb0(%rax)
    }
}
   42ac7:	90                   	nop
   42ac8:	c9                   	leaveq 
   42ac9:	c3                   	retq   

0000000000042aca <console_show_cursor>:

// console_show_cursor(cpos)
//    Move the console cursor to position `cpos`, which should be between 0
//    and 80 * 25.

void console_show_cursor(int cpos) {
   42aca:	55                   	push   %rbp
   42acb:	48 89 e5             	mov    %rsp,%rbp
   42ace:	48 83 ec 28          	sub    $0x28,%rsp
   42ad2:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (cpos < 0 || cpos > CONSOLE_ROWS * CONSOLE_COLUMNS) {
   42ad5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   42ad9:	78 09                	js     42ae4 <console_show_cursor+0x1a>
   42adb:	81 7d dc d0 07 00 00 	cmpl   $0x7d0,-0x24(%rbp)
   42ae2:	7e 07                	jle    42aeb <console_show_cursor+0x21>
        cpos = 0;
   42ae4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
   42aeb:	c7 45 e4 d4 03 00 00 	movl   $0x3d4,-0x1c(%rbp)
   42af2:	c6 45 e3 0e          	movb   $0xe,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42af6:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   42afa:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   42afd:	ee                   	out    %al,(%dx)
}
   42afe:	90                   	nop
    }
    outb(0x3D4, 14);
    outb(0x3D5, cpos / 256);
   42aff:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42b02:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   42b08:	85 c0                	test   %eax,%eax
   42b0a:	0f 48 c2             	cmovs  %edx,%eax
   42b0d:	c1 f8 08             	sar    $0x8,%eax
   42b10:	0f b6 c0             	movzbl %al,%eax
   42b13:	c7 45 ec d5 03 00 00 	movl   $0x3d5,-0x14(%rbp)
   42b1a:	88 45 eb             	mov    %al,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42b1d:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   42b21:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42b24:	ee                   	out    %al,(%dx)
}
   42b25:	90                   	nop
   42b26:	c7 45 f4 d4 03 00 00 	movl   $0x3d4,-0xc(%rbp)
   42b2d:	c6 45 f3 0f          	movb   $0xf,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42b31:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   42b35:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42b38:	ee                   	out    %al,(%dx)
}
   42b39:	90                   	nop
    outb(0x3D4, 15);
    outb(0x3D5, cpos % 256);
   42b3a:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42b3d:	99                   	cltd   
   42b3e:	c1 ea 18             	shr    $0x18,%edx
   42b41:	01 d0                	add    %edx,%eax
   42b43:	0f b6 c0             	movzbl %al,%eax
   42b46:	29 d0                	sub    %edx,%eax
   42b48:	0f b6 c0             	movzbl %al,%eax
   42b4b:	c7 45 fc d5 03 00 00 	movl   $0x3d5,-0x4(%rbp)
   42b52:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42b55:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42b59:	8b 55 fc             	mov    -0x4(%rbp),%edx
   42b5c:	ee                   	out    %al,(%dx)
}
   42b5d:	90                   	nop
}
   42b5e:	90                   	nop
   42b5f:	c9                   	leaveq 
   42b60:	c3                   	retq   

0000000000042b61 <keyboard_readc>:
    /*CKEY(16)*/ {{'\'', '"', 0, 0}},  /*CKEY(17)*/ {{'`', '~', 0, 0}},
    /*CKEY(18)*/ {{'\\', '|', 034, 0}},  /*CKEY(19)*/ {{',', '<', 0, 0}},
    /*CKEY(20)*/ {{'.', '>', 0, 0}},  /*CKEY(21)*/ {{'/', '?', 0, 0}}
};

int keyboard_readc(void) {
   42b61:	55                   	push   %rbp
   42b62:	48 89 e5             	mov    %rsp,%rbp
   42b65:	48 83 ec 20          	sub    $0x20,%rsp
   42b69:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42b70:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42b73:	89 c2                	mov    %eax,%edx
   42b75:	ec                   	in     (%dx),%al
   42b76:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   42b79:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
    static uint8_t modifiers;
    static uint8_t last_escape;

    if ((inb(KEYBOARD_STATUSREG) & KEYBOARD_STATUS_READY) == 0) {
   42b7d:	0f b6 c0             	movzbl %al,%eax
   42b80:	83 e0 01             	and    $0x1,%eax
   42b83:	85 c0                	test   %eax,%eax
   42b85:	75 0a                	jne    42b91 <keyboard_readc+0x30>
        return -1;
   42b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42b8c:	e9 e5 01 00 00       	jmpq   42d76 <keyboard_readc+0x215>
   42b91:	c7 45 e8 60 00 00 00 	movl   $0x60,-0x18(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42b98:	8b 45 e8             	mov    -0x18(%rbp),%eax
   42b9b:	89 c2                	mov    %eax,%edx
   42b9d:	ec                   	in     (%dx),%al
   42b9e:	88 45 e7             	mov    %al,-0x19(%rbp)
    return data;
   42ba1:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
    }

    uint8_t data = inb(KEYBOARD_DATAREG);
   42ba5:	88 45 fb             	mov    %al,-0x5(%rbp)
    uint8_t escape = last_escape;
   42ba8:	0f b6 05 51 34 01 00 	movzbl 0x13451(%rip),%eax        # 56000 <last_escape.1653>
   42baf:	88 45 fa             	mov    %al,-0x6(%rbp)
    last_escape = 0;
   42bb2:	c6 05 47 34 01 00 00 	movb   $0x0,0x13447(%rip)        # 56000 <last_escape.1653>

    if (data == 0xE0) {         // mode shift
   42bb9:	80 7d fb e0          	cmpb   $0xe0,-0x5(%rbp)
   42bbd:	75 11                	jne    42bd0 <keyboard_readc+0x6f>
        last_escape = 0x80;
   42bbf:	c6 05 3a 34 01 00 80 	movb   $0x80,0x1343a(%rip)        # 56000 <last_escape.1653>
        return 0;
   42bc6:	b8 00 00 00 00       	mov    $0x0,%eax
   42bcb:	e9 a6 01 00 00       	jmpq   42d76 <keyboard_readc+0x215>
    } else if (data & 0x80) {   // key release: matters only for modifier keys
   42bd0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42bd4:	84 c0                	test   %al,%al
   42bd6:	79 5e                	jns    42c36 <keyboard_readc+0xd5>
        int ch = keymap[(data & 0x7F) | escape];
   42bd8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42bdc:	83 e0 7f             	and    $0x7f,%eax
   42bdf:	89 c2                	mov    %eax,%edx
   42be1:	0f b6 45 fa          	movzbl -0x6(%rbp),%eax
   42be5:	09 d0                	or     %edx,%eax
   42be7:	48 98                	cltq   
   42be9:	0f b6 80 40 47 04 00 	movzbl 0x44740(%rax),%eax
   42bf0:	0f b6 c0             	movzbl %al,%eax
   42bf3:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if (ch >= KEY_SHIFT && ch < KEY_CAPSLOCK) {
   42bf6:	81 7d f4 f9 00 00 00 	cmpl   $0xf9,-0xc(%rbp)
   42bfd:	7e 2d                	jle    42c2c <keyboard_readc+0xcb>
   42bff:	81 7d f4 fc 00 00 00 	cmpl   $0xfc,-0xc(%rbp)
   42c06:	7f 24                	jg     42c2c <keyboard_readc+0xcb>
            modifiers &= ~(1 << (ch - KEY_SHIFT));
   42c08:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42c0b:	2d fa 00 00 00       	sub    $0xfa,%eax
   42c10:	ba 01 00 00 00       	mov    $0x1,%edx
   42c15:	89 c1                	mov    %eax,%ecx
   42c17:	d3 e2                	shl    %cl,%edx
   42c19:	89 d0                	mov    %edx,%eax
   42c1b:	f7 d0                	not    %eax
   42c1d:	0f b6 15 dd 33 01 00 	movzbl 0x133dd(%rip),%edx        # 56001 <modifiers.1652>
   42c24:	21 d0                	and    %edx,%eax
   42c26:	88 05 d5 33 01 00    	mov    %al,0x133d5(%rip)        # 56001 <modifiers.1652>
        }
        return 0;
   42c2c:	b8 00 00 00 00       	mov    $0x0,%eax
   42c31:	e9 40 01 00 00       	jmpq   42d76 <keyboard_readc+0x215>
    }

    int ch = (unsigned char) keymap[data | escape];
   42c36:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42c3a:	0a 45 fa             	or     -0x6(%rbp),%al
   42c3d:	0f b6 c0             	movzbl %al,%eax
   42c40:	48 98                	cltq   
   42c42:	0f b6 80 40 47 04 00 	movzbl 0x44740(%rax),%eax
   42c49:	0f b6 c0             	movzbl %al,%eax
   42c4c:	89 45 fc             	mov    %eax,-0x4(%rbp)

    if (ch >= 'a' && ch <= 'z') {
   42c4f:	83 7d fc 60          	cmpl   $0x60,-0x4(%rbp)
   42c53:	7e 57                	jle    42cac <keyboard_readc+0x14b>
   42c55:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%rbp)
   42c59:	7f 51                	jg     42cac <keyboard_readc+0x14b>
        if (modifiers & MOD_CONTROL) {
   42c5b:	0f b6 05 9f 33 01 00 	movzbl 0x1339f(%rip),%eax        # 56001 <modifiers.1652>
   42c62:	0f b6 c0             	movzbl %al,%eax
   42c65:	83 e0 02             	and    $0x2,%eax
   42c68:	85 c0                	test   %eax,%eax
   42c6a:	74 09                	je     42c75 <keyboard_readc+0x114>
            ch -= 0x60;
   42c6c:	83 6d fc 60          	subl   $0x60,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   42c70:	e9 fd 00 00 00       	jmpq   42d72 <keyboard_readc+0x211>
        } else if (!(modifiers & MOD_SHIFT) != !(modifiers & MOD_CAPSLOCK)) {
   42c75:	0f b6 05 85 33 01 00 	movzbl 0x13385(%rip),%eax        # 56001 <modifiers.1652>
   42c7c:	0f b6 c0             	movzbl %al,%eax
   42c7f:	83 e0 01             	and    $0x1,%eax
   42c82:	85 c0                	test   %eax,%eax
   42c84:	0f 94 c2             	sete   %dl
   42c87:	0f b6 05 73 33 01 00 	movzbl 0x13373(%rip),%eax        # 56001 <modifiers.1652>
   42c8e:	0f b6 c0             	movzbl %al,%eax
   42c91:	83 e0 08             	and    $0x8,%eax
   42c94:	85 c0                	test   %eax,%eax
   42c96:	0f 94 c0             	sete   %al
   42c99:	31 d0                	xor    %edx,%eax
   42c9b:	84 c0                	test   %al,%al
   42c9d:	0f 84 cf 00 00 00    	je     42d72 <keyboard_readc+0x211>
            ch -= 0x20;
   42ca3:	83 6d fc 20          	subl   $0x20,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   42ca7:	e9 c6 00 00 00       	jmpq   42d72 <keyboard_readc+0x211>
        }
    } else if (ch >= KEY_CAPSLOCK) {
   42cac:	81 7d fc fc 00 00 00 	cmpl   $0xfc,-0x4(%rbp)
   42cb3:	7e 30                	jle    42ce5 <keyboard_readc+0x184>
        modifiers ^= 1 << (ch - KEY_SHIFT);
   42cb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42cb8:	2d fa 00 00 00       	sub    $0xfa,%eax
   42cbd:	ba 01 00 00 00       	mov    $0x1,%edx
   42cc2:	89 c1                	mov    %eax,%ecx
   42cc4:	d3 e2                	shl    %cl,%edx
   42cc6:	89 d0                	mov    %edx,%eax
   42cc8:	89 c2                	mov    %eax,%edx
   42cca:	0f b6 05 30 33 01 00 	movzbl 0x13330(%rip),%eax        # 56001 <modifiers.1652>
   42cd1:	31 d0                	xor    %edx,%eax
   42cd3:	88 05 28 33 01 00    	mov    %al,0x13328(%rip)        # 56001 <modifiers.1652>
        ch = 0;
   42cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42ce0:	e9 8e 00 00 00       	jmpq   42d73 <keyboard_readc+0x212>
    } else if (ch >= KEY_SHIFT) {
   42ce5:	81 7d fc f9 00 00 00 	cmpl   $0xf9,-0x4(%rbp)
   42cec:	7e 2d                	jle    42d1b <keyboard_readc+0x1ba>
        modifiers |= 1 << (ch - KEY_SHIFT);
   42cee:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42cf1:	2d fa 00 00 00       	sub    $0xfa,%eax
   42cf6:	ba 01 00 00 00       	mov    $0x1,%edx
   42cfb:	89 c1                	mov    %eax,%ecx
   42cfd:	d3 e2                	shl    %cl,%edx
   42cff:	89 d0                	mov    %edx,%eax
   42d01:	89 c2                	mov    %eax,%edx
   42d03:	0f b6 05 f7 32 01 00 	movzbl 0x132f7(%rip),%eax        # 56001 <modifiers.1652>
   42d0a:	09 d0                	or     %edx,%eax
   42d0c:	88 05 ef 32 01 00    	mov    %al,0x132ef(%rip)        # 56001 <modifiers.1652>
        ch = 0;
   42d12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42d19:	eb 58                	jmp    42d73 <keyboard_readc+0x212>
    } else if (ch >= CKEY(0) && ch <= CKEY(21)) {
   42d1b:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   42d1f:	7e 31                	jle    42d52 <keyboard_readc+0x1f1>
   42d21:	81 7d fc 95 00 00 00 	cmpl   $0x95,-0x4(%rbp)
   42d28:	7f 28                	jg     42d52 <keyboard_readc+0x1f1>
        ch = complex_keymap[ch - CKEY(0)].map[modifiers & 3];
   42d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42d2d:	8d 50 80             	lea    -0x80(%rax),%edx
   42d30:	0f b6 05 ca 32 01 00 	movzbl 0x132ca(%rip),%eax        # 56001 <modifiers.1652>
   42d37:	0f b6 c0             	movzbl %al,%eax
   42d3a:	83 e0 03             	and    $0x3,%eax
   42d3d:	48 98                	cltq   
   42d3f:	48 63 d2             	movslq %edx,%rdx
   42d42:	0f b6 84 90 40 48 04 	movzbl 0x44840(%rax,%rdx,4),%eax
   42d49:	00 
   42d4a:	0f b6 c0             	movzbl %al,%eax
   42d4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
   42d50:	eb 21                	jmp    42d73 <keyboard_readc+0x212>
    } else if (ch < 0x80 && (modifiers & MOD_CONTROL)) {
   42d52:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   42d56:	7f 1b                	jg     42d73 <keyboard_readc+0x212>
   42d58:	0f b6 05 a2 32 01 00 	movzbl 0x132a2(%rip),%eax        # 56001 <modifiers.1652>
   42d5f:	0f b6 c0             	movzbl %al,%eax
   42d62:	83 e0 02             	and    $0x2,%eax
   42d65:	85 c0                	test   %eax,%eax
   42d67:	74 0a                	je     42d73 <keyboard_readc+0x212>
        ch = 0;
   42d69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42d70:	eb 01                	jmp    42d73 <keyboard_readc+0x212>
        if (modifiers & MOD_CONTROL) {
   42d72:	90                   	nop
    }

    return ch;
   42d73:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
   42d76:	c9                   	leaveq 
   42d77:	c3                   	retq   

0000000000042d78 <delay>:
#define IO_PARALLEL1_CONTROL    0x37A
# define IO_PARALLEL_CONTROL_SELECT     0x08
# define IO_PARALLEL_CONTROL_INIT       0x04
# define IO_PARALLEL_CONTROL_STROBE     0x01

static void delay(void) {
   42d78:	55                   	push   %rbp
   42d79:	48 89 e5             	mov    %rsp,%rbp
   42d7c:	48 83 ec 20          	sub    $0x20,%rsp
   42d80:	c7 45 e4 84 00 00 00 	movl   $0x84,-0x1c(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42d87:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   42d8a:	89 c2                	mov    %eax,%edx
   42d8c:	ec                   	in     (%dx),%al
   42d8d:	88 45 e3             	mov    %al,-0x1d(%rbp)
   42d90:	c7 45 ec 84 00 00 00 	movl   $0x84,-0x14(%rbp)
   42d97:	8b 45 ec             	mov    -0x14(%rbp),%eax
   42d9a:	89 c2                	mov    %eax,%edx
   42d9c:	ec                   	in     (%dx),%al
   42d9d:	88 45 eb             	mov    %al,-0x15(%rbp)
   42da0:	c7 45 f4 84 00 00 00 	movl   $0x84,-0xc(%rbp)
   42da7:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42daa:	89 c2                	mov    %eax,%edx
   42dac:	ec                   	in     (%dx),%al
   42dad:	88 45 f3             	mov    %al,-0xd(%rbp)
   42db0:	c7 45 fc 84 00 00 00 	movl   $0x84,-0x4(%rbp)
   42db7:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42dba:	89 c2                	mov    %eax,%edx
   42dbc:	ec                   	in     (%dx),%al
   42dbd:	88 45 fb             	mov    %al,-0x5(%rbp)
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
}
   42dc0:	90                   	nop
   42dc1:	c9                   	leaveq 
   42dc2:	c3                   	retq   

0000000000042dc3 <parallel_port_putc>:

static void parallel_port_putc(printer* p, unsigned char c, int color) {
   42dc3:	55                   	push   %rbp
   42dc4:	48 89 e5             	mov    %rsp,%rbp
   42dc7:	48 83 ec 40          	sub    $0x40,%rsp
   42dcb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   42dcf:	89 f0                	mov    %esi,%eax
   42dd1:	89 55 c0             	mov    %edx,-0x40(%rbp)
   42dd4:	88 45 c4             	mov    %al,-0x3c(%rbp)
    static int initialized;
    (void) p, (void) color;
    if (!initialized) {
   42dd7:	8b 05 27 32 01 00    	mov    0x13227(%rip),%eax        # 56004 <initialized.1666>
   42ddd:	85 c0                	test   %eax,%eax
   42ddf:	75 1e                	jne    42dff <parallel_port_putc+0x3c>
   42de1:	c7 45 f8 7a 03 00 00 	movl   $0x37a,-0x8(%rbp)
   42de8:	c6 45 f7 00          	movb   $0x0,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42dec:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   42df0:	8b 55 f8             	mov    -0x8(%rbp),%edx
   42df3:	ee                   	out    %al,(%dx)
}
   42df4:	90                   	nop
        outb(IO_PARALLEL1_CONTROL, 0);
        initialized = 1;
   42df5:	c7 05 05 32 01 00 01 	movl   $0x1,0x13205(%rip)        # 56004 <initialized.1666>
   42dfc:	00 00 00 
    }

    for (int i = 0;
   42dff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42e06:	eb 09                	jmp    42e11 <parallel_port_putc+0x4e>
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
         ++i) {
        delay();
   42e08:	e8 6b ff ff ff       	callq  42d78 <delay>
         ++i) {
   42e0d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    for (int i = 0;
   42e11:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%rbp)
   42e18:	7f 18                	jg     42e32 <parallel_port_putc+0x6f>
   42e1a:	c7 45 f0 79 03 00 00 	movl   $0x379,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42e21:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42e24:	89 c2                	mov    %eax,%edx
   42e26:	ec                   	in     (%dx),%al
   42e27:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   42e2a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
   42e2e:	84 c0                	test   %al,%al
   42e30:	79 d6                	jns    42e08 <parallel_port_putc+0x45>
    }
    outb(IO_PARALLEL1_DATA, c);
   42e32:	0f b6 45 c4          	movzbl -0x3c(%rbp),%eax
   42e36:	c7 45 d8 78 03 00 00 	movl   $0x378,-0x28(%rbp)
   42e3d:	88 45 d7             	mov    %al,-0x29(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42e40:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
   42e44:	8b 55 d8             	mov    -0x28(%rbp),%edx
   42e47:	ee                   	out    %al,(%dx)
}
   42e48:	90                   	nop
   42e49:	c7 45 e0 7a 03 00 00 	movl   $0x37a,-0x20(%rbp)
   42e50:	c6 45 df 0d          	movb   $0xd,-0x21(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42e54:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
   42e58:	8b 55 e0             	mov    -0x20(%rbp),%edx
   42e5b:	ee                   	out    %al,(%dx)
}
   42e5c:	90                   	nop
   42e5d:	c7 45 e8 7a 03 00 00 	movl   $0x37a,-0x18(%rbp)
   42e64:	c6 45 e7 0c          	movb   $0xc,-0x19(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42e68:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
   42e6c:	8b 55 e8             	mov    -0x18(%rbp),%edx
   42e6f:	ee                   	out    %al,(%dx)
}
   42e70:	90                   	nop
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT | IO_PARALLEL_CONTROL_STROBE);
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT);
}
   42e71:	90                   	nop
   42e72:	c9                   	leaveq 
   42e73:	c3                   	retq   

0000000000042e74 <log_vprintf>:

void log_vprintf(const char* format, va_list val) {
   42e74:	55                   	push   %rbp
   42e75:	48 89 e5             	mov    %rsp,%rbp
   42e78:	48 83 ec 20          	sub    $0x20,%rsp
   42e7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   42e80:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    printer p;
    p.putc = parallel_port_putc;
   42e84:	48 c7 45 f8 c3 2d 04 	movq   $0x42dc3,-0x8(%rbp)
   42e8b:	00 
    printer_vprintf(&p, 0, format, val);
   42e8c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
   42e90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   42e94:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
   42e98:	be 00 00 00 00       	mov    $0x0,%esi
   42e9d:	48 89 c7             	mov    %rax,%rdi
   42ea0:	e8 c9 08 00 00       	callq  4376e <printer_vprintf>
}
   42ea5:	90                   	nop
   42ea6:	c9                   	leaveq 
   42ea7:	c3                   	retq   

0000000000042ea8 <log_printf>:

void log_printf(const char* format, ...) {
   42ea8:	55                   	push   %rbp
   42ea9:	48 89 e5             	mov    %rsp,%rbp
   42eac:	48 83 ec 60          	sub    $0x60,%rsp
   42eb0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   42eb4:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   42eb8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   42ebc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   42ec0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   42ec4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   42ec8:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
   42ecf:	48 8d 45 10          	lea    0x10(%rbp),%rax
   42ed3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   42ed7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   42edb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    log_vprintf(format, val);
   42edf:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
   42ee3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   42ee7:	48 89 d6             	mov    %rdx,%rsi
   42eea:	48 89 c7             	mov    %rax,%rdi
   42eed:	e8 82 ff ff ff       	callq  42e74 <log_vprintf>
    va_end(val);
}
   42ef2:	90                   	nop
   42ef3:	c9                   	leaveq 
   42ef4:	c3                   	retq   

0000000000042ef5 <error_vprintf>:

// error_printf, error_vprintf
//    Print debugging messages to the console and to the host's
//    `log.txt` file via `log_printf`.

int error_vprintf(int cpos, int color, const char* format, va_list val) {
   42ef5:	55                   	push   %rbp
   42ef6:	48 89 e5             	mov    %rsp,%rbp
   42ef9:	48 83 ec 40          	sub    $0x40,%rsp
   42efd:	89 7d dc             	mov    %edi,-0x24(%rbp)
   42f00:	89 75 d8             	mov    %esi,-0x28(%rbp)
   42f03:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
   42f07:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
    va_list val2;
    __builtin_va_copy(val2, val);
   42f0b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
   42f0f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   42f13:	48 8b 0a             	mov    (%rdx),%rcx
   42f16:	48 89 08             	mov    %rcx,(%rax)
   42f19:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   42f1d:	48 89 48 08          	mov    %rcx,0x8(%rax)
   42f21:	48 8b 52 10          	mov    0x10(%rdx),%rdx
   42f25:	48 89 50 10          	mov    %rdx,0x10(%rax)
    log_vprintf(format, val2);
   42f29:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
   42f2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42f31:	48 89 d6             	mov    %rdx,%rsi
   42f34:	48 89 c7             	mov    %rax,%rdi
   42f37:	e8 38 ff ff ff       	callq  42e74 <log_vprintf>
    va_end(val2);
    return console_vprintf(cpos, color, format, val);
   42f3c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   42f40:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   42f44:	8b 75 d8             	mov    -0x28(%rbp),%esi
   42f47:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42f4a:	89 c7                	mov    %eax,%edi
   42f4c:	e8 06 0f 00 00       	callq  43e57 <console_vprintf>
}
   42f51:	c9                   	leaveq 
   42f52:	c3                   	retq   

0000000000042f53 <error_printf>:

int error_printf(int cpos, int color, const char* format, ...) {
   42f53:	55                   	push   %rbp
   42f54:	48 89 e5             	mov    %rsp,%rbp
   42f57:	48 83 ec 60          	sub    $0x60,%rsp
   42f5b:	89 7d ac             	mov    %edi,-0x54(%rbp)
   42f5e:	89 75 a8             	mov    %esi,-0x58(%rbp)
   42f61:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
   42f65:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   42f69:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   42f6d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   42f71:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   42f78:	48 8d 45 10          	lea    0x10(%rbp),%rax
   42f7c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   42f80:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   42f84:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = error_vprintf(cpos, color, format, val);
   42f88:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   42f8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
   42f90:	8b 75 a8             	mov    -0x58(%rbp),%esi
   42f93:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42f96:	89 c7                	mov    %eax,%edi
   42f98:	e8 58 ff ff ff       	callq  42ef5 <error_vprintf>
   42f9d:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
   42fa0:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
   42fa3:	c9                   	leaveq 
   42fa4:	c3                   	retq   

0000000000042fa5 <check_keyboard>:
//    Check for the user typing a control key. 'a', 'f', and 'e' cause a soft
//    reboot where the kernel runs the allocator programs, "fork", or
//    "forkexit", respectively. Control-C or 'q' exit the virtual machine.
//    Returns key typed or -1 for no key.

int check_keyboard(void) {
   42fa5:	55                   	push   %rbp
   42fa6:	48 89 e5             	mov    %rsp,%rbp
   42fa9:	53                   	push   %rbx
   42faa:	48 83 ec 48          	sub    $0x48,%rsp
    int c = keyboard_readc();
   42fae:	e8 ae fb ff ff       	callq  42b61 <keyboard_readc>
   42fb3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    if (c == 'a' || c == 'f' || c == 'e') {
   42fb6:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   42fba:	74 10                	je     42fcc <check_keyboard+0x27>
   42fbc:	83 7d e4 66          	cmpl   $0x66,-0x1c(%rbp)
   42fc0:	74 0a                	je     42fcc <check_keyboard+0x27>
   42fc2:	83 7d e4 65          	cmpl   $0x65,-0x1c(%rbp)
   42fc6:	0f 85 c9 00 00 00    	jne    43095 <check_keyboard+0xf0>
        // Install a temporary page table to carry us through the
        // process of reinitializing memory. This replicates work the
        // bootloader does.
        x86_64_pagetable* pt = (x86_64_pagetable*) 0x8000;
   42fcc:	48 c7 45 d8 00 80 00 	movq   $0x8000,-0x28(%rbp)
   42fd3:	00 
        memset(pt, 0, PAGESIZE * 3);
   42fd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42fd8:	ba 00 30 00 00       	mov    $0x3000,%edx
   42fdd:	be 00 00 00 00       	mov    $0x0,%esi
   42fe2:	48 89 c7             	mov    %rax,%rdi
   42fe5:	e8 74 06 00 00       	callq  4365e <memset>
        pt[0].entry[0] = 0x9000 | PTE_P | PTE_W | PTE_U;
   42fea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42fee:	48 c7 00 07 90 00 00 	movq   $0x9007,(%rax)
        pt[1].entry[0] = 0xA000 | PTE_P | PTE_W | PTE_U;
   42ff5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42ff9:	48 05 00 10 00 00    	add    $0x1000,%rax
   42fff:	48 c7 00 07 a0 00 00 	movq   $0xa007,(%rax)
        pt[2].entry[0] = PTE_P | PTE_W | PTE_U | PTE_PS;
   43006:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4300a:	48 05 00 20 00 00    	add    $0x2000,%rax
   43010:	48 c7 00 87 00 00 00 	movq   $0x87,(%rax)
        lcr3((uintptr_t) pt);
   43017:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4301b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   4301f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   43023:	0f 22 d8             	mov    %rax,%cr3
}
   43026:	90                   	nop
        // The soft reboot process doesn't modify memory, so it's
        // safe to pass `multiboot_info` on the kernel stack, even
        // though it will get overwritten as the kernel runs.
        uint32_t multiboot_info[5];
        multiboot_info[0] = 4;
   43027:	c7 45 b4 04 00 00 00 	movl   $0x4,-0x4c(%rbp)
        const char* argument = "fork";
   4302e:	48 c7 45 e8 98 48 04 	movq   $0x44898,-0x18(%rbp)
   43035:	00 
        if (c == 'a') {
   43036:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   4303a:	75 0a                	jne    43046 <check_keyboard+0xa1>
            argument = "allocator";
   4303c:	48 c7 45 e8 9d 48 04 	movq   $0x4489d,-0x18(%rbp)
   43043:	00 
   43044:	eb 0e                	jmp    43054 <check_keyboard+0xaf>
        } else if (c == 'e') {
   43046:	83 7d e4 65          	cmpl   $0x65,-0x1c(%rbp)
   4304a:	75 08                	jne    43054 <check_keyboard+0xaf>
            argument = "forkexit";
   4304c:	48 c7 45 e8 a7 48 04 	movq   $0x448a7,-0x18(%rbp)
   43053:	00 
        }
        uintptr_t argument_ptr = (uintptr_t) argument;
   43054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43058:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        assert(argument_ptr < 0x100000000L);
   4305c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43061:	48 39 45 d0          	cmp    %rax,-0x30(%rbp)
   43065:	76 14                	jbe    4307b <check_keyboard+0xd6>
   43067:	ba b0 48 04 00       	mov    $0x448b0,%edx
   4306c:	be f3 02 00 00       	mov    $0x2f3,%esi
   43071:	bf 35 44 04 00       	mov    $0x44435,%edi
   43076:	e8 20 01 00 00       	callq  4319b <assert_fail>
        multiboot_info[4] = (uint32_t) argument_ptr;
   4307b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   4307f:	89 45 c4             	mov    %eax,-0x3c(%rbp)
        asm volatile("movl $0x2BADB002, %%eax; jmp entry_from_boot"
   43082:	48 8d 45 b4          	lea    -0x4c(%rbp),%rax
   43086:	48 89 c3             	mov    %rax,%rbx
   43089:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
   4308e:	e9 6d cf ff ff       	jmpq   40000 <entry_from_boot>
    if (c == 'a' || c == 'f' || c == 'e') {
   43093:	eb 11                	jmp    430a6 <check_keyboard+0x101>
                     : : "b" (multiboot_info) : "memory");
    } else if (c == 0x03 || c == 'q') {
   43095:	83 7d e4 03          	cmpl   $0x3,-0x1c(%rbp)
   43099:	74 06                	je     430a1 <check_keyboard+0xfc>
   4309b:	83 7d e4 71          	cmpl   $0x71,-0x1c(%rbp)
   4309f:	75 05                	jne    430a6 <check_keyboard+0x101>
        poweroff();
   430a1:	e8 dc f8 ff ff       	callq  42982 <poweroff>
    }
    return c;
   430a6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
}
   430a9:	48 83 c4 48          	add    $0x48,%rsp
   430ad:	5b                   	pop    %rbx
   430ae:	5d                   	pop    %rbp
   430af:	c3                   	retq   

00000000000430b0 <fail>:

// fail
//    Loop until user presses Control-C, then poweroff.

static void fail(void) __attribute__((noreturn));
static void fail(void) {
   430b0:	55                   	push   %rbp
   430b1:	48 89 e5             	mov    %rsp,%rbp
    while (1) {
        check_keyboard();
   430b4:	e8 ec fe ff ff       	callq  42fa5 <check_keyboard>
   430b9:	eb f9                	jmp    430b4 <fail+0x4>

00000000000430bb <panic>:

// panic, assert_fail
//    Use console_printf() to print a failure message and then wait for
//    control-C. Also write the failure message to the log.

void panic(const char* format, ...) {
   430bb:	55                   	push   %rbp
   430bc:	48 89 e5             	mov    %rsp,%rbp
   430bf:	48 83 ec 60          	sub    $0x60,%rsp
   430c3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   430c7:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   430cb:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   430cf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   430d3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   430d7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   430db:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%rbp)
   430e2:	48 8d 45 10          	lea    0x10(%rbp),%rax
   430e6:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
   430ea:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   430ee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)

    if (format) {
   430f2:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
   430f7:	0f 84 80 00 00 00    	je     4317d <panic+0xc2>
        // Print panic message to both the screen and the log
        int cpos = error_printf(CPOS(23, 0), 0xC000, "PANIC: ");
   430fd:	ba cc 48 04 00       	mov    $0x448cc,%edx
   43102:	be 00 c0 00 00       	mov    $0xc000,%esi
   43107:	bf 30 07 00 00       	mov    $0x730,%edi
   4310c:	b8 00 00 00 00       	mov    $0x0,%eax
   43111:	e8 3d fe ff ff       	callq  42f53 <error_printf>
   43116:	89 45 cc             	mov    %eax,-0x34(%rbp)
        cpos = error_vprintf(cpos, 0xC000, format, val);
   43119:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
   4311d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
   43121:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43124:	be 00 c0 00 00       	mov    $0xc000,%esi
   43129:	89 c7                	mov    %eax,%edi
   4312b:	e8 c5 fd ff ff       	callq  42ef5 <error_vprintf>
   43130:	89 45 cc             	mov    %eax,-0x34(%rbp)
        if (CCOL(cpos)) {
   43133:	8b 4d cc             	mov    -0x34(%rbp),%ecx
   43136:	48 63 c1             	movslq %ecx,%rax
   43139:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
   43140:	48 c1 e8 20          	shr    $0x20,%rax
   43144:	89 c2                	mov    %eax,%edx
   43146:	c1 fa 05             	sar    $0x5,%edx
   43149:	89 c8                	mov    %ecx,%eax
   4314b:	c1 f8 1f             	sar    $0x1f,%eax
   4314e:	29 c2                	sub    %eax,%edx
   43150:	89 d0                	mov    %edx,%eax
   43152:	c1 e0 02             	shl    $0x2,%eax
   43155:	01 d0                	add    %edx,%eax
   43157:	c1 e0 04             	shl    $0x4,%eax
   4315a:	29 c1                	sub    %eax,%ecx
   4315c:	89 ca                	mov    %ecx,%edx
   4315e:	85 d2                	test   %edx,%edx
   43160:	74 34                	je     43196 <panic+0xdb>
            error_printf(cpos, 0xC000, "\n");
   43162:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43165:	ba d4 48 04 00       	mov    $0x448d4,%edx
   4316a:	be 00 c0 00 00       	mov    $0xc000,%esi
   4316f:	89 c7                	mov    %eax,%edi
   43171:	b8 00 00 00 00       	mov    $0x0,%eax
   43176:	e8 d8 fd ff ff       	callq  42f53 <error_printf>
   4317b:	eb 19                	jmp    43196 <panic+0xdb>
        }
    } else {
        error_printf(CPOS(23, 0), 0xC000, "PANIC");
   4317d:	ba d6 48 04 00       	mov    $0x448d6,%edx
   43182:	be 00 c0 00 00       	mov    $0xc000,%esi
   43187:	bf 30 07 00 00       	mov    $0x730,%edi
   4318c:	b8 00 00 00 00       	mov    $0x0,%eax
   43191:	e8 bd fd ff ff       	callq  42f53 <error_printf>
    }

    va_end(val);
    fail();
   43196:	e8 15 ff ff ff       	callq  430b0 <fail>

000000000004319b <assert_fail>:
}

void assert_fail(const char* file, int line, const char* msg) {
   4319b:	55                   	push   %rbp
   4319c:	48 89 e5             	mov    %rsp,%rbp
   4319f:	48 83 ec 20          	sub    $0x20,%rsp
   431a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   431a7:	89 75 f4             	mov    %esi,-0xc(%rbp)
   431aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    panic("%s:%d: assertion '%s' failed\n", file, line, msg);
   431ae:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   431b2:	8b 55 f4             	mov    -0xc(%rbp),%edx
   431b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   431b9:	48 89 c6             	mov    %rax,%rsi
   431bc:	bf dc 48 04 00       	mov    $0x448dc,%edi
   431c1:	b8 00 00 00 00       	mov    $0x0,%eax
   431c6:	e8 f0 fe ff ff       	callq  430bb <panic>

00000000000431cb <program_load>:
//    `assign_physical_page` to as required. Returns 0 on success and
//    -1 on failure (e.g. out-of-memory). `allocator` is passed to
//    `virtual_memory_map`.

int program_load(proc* p, int programnumber,
                 x86_64_pagetable* (*allocator)(void)) {
   431cb:	55                   	push   %rbp
   431cc:	48 89 e5             	mov    %rsp,%rbp
   431cf:	48 83 ec 40          	sub    $0x40,%rsp
   431d3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   431d7:	89 75 d4             	mov    %esi,-0x2c(%rbp)
   431da:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    // is this a valid program?
    int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);
   431de:	c7 45 f8 06 00 00 00 	movl   $0x6,-0x8(%rbp)
    assert(programnumber >= 0 && programnumber < nprograms);
   431e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   431e9:	78 08                	js     431f3 <program_load+0x28>
   431eb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   431ee:	3b 45 f8             	cmp    -0x8(%rbp),%eax
   431f1:	7c 14                	jl     43207 <program_load+0x3c>
   431f3:	ba 00 49 04 00       	mov    $0x44900,%edx
   431f8:	be 35 00 00 00       	mov    $0x35,%esi
   431fd:	bf 30 49 04 00       	mov    $0x44930,%edi
   43202:	e8 94 ff ff ff       	callq  4319b <assert_fail>
    elf_header* eh = (elf_header*) ramimages[programnumber].begin;
   43207:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   4320a:	48 98                	cltq   
   4320c:	48 c1 e0 04          	shl    $0x4,%rax
   43210:	48 05 20 50 04 00    	add    $0x45020,%rax
   43216:	48 8b 00             	mov    (%rax),%rax
   43219:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    assert(eh->e_magic == ELF_MAGIC);
   4321d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43221:	8b 00                	mov    (%rax),%eax
   43223:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
   43228:	74 14                	je     4323e <program_load+0x73>
   4322a:	ba 3b 49 04 00       	mov    $0x4493b,%edx
   4322f:	be 37 00 00 00       	mov    $0x37,%esi
   43234:	bf 30 49 04 00       	mov    $0x44930,%edi
   43239:	e8 5d ff ff ff       	callq  4319b <assert_fail>

    // load each loadable program segment into memory
    elf_program* ph = (elf_program*) ((const uint8_t*) eh + eh->e_phoff);
   4323e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43242:	48 8b 50 20          	mov    0x20(%rax),%rdx
   43246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4324a:	48 01 d0             	add    %rdx,%rax
   4324d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for (int i = 0; i < eh->e_phnum; ++i) {
   43251:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   43258:	e9 94 00 00 00       	jmpq   432f1 <program_load+0x126>
        if (ph[i].p_type == ELF_PTYPE_LOAD) {
   4325d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   43260:	48 63 d0             	movslq %eax,%rdx
   43263:	48 89 d0             	mov    %rdx,%rax
   43266:	48 c1 e0 03          	shl    $0x3,%rax
   4326a:	48 29 d0             	sub    %rdx,%rax
   4326d:	48 c1 e0 03          	shl    $0x3,%rax
   43271:	48 89 c2             	mov    %rax,%rdx
   43274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43278:	48 01 d0             	add    %rdx,%rax
   4327b:	8b 00                	mov    (%rax),%eax
   4327d:	83 f8 01             	cmp    $0x1,%eax
   43280:	75 6b                	jne    432ed <program_load+0x122>
            const uint8_t* pdata = (const uint8_t*) eh + ph[i].p_offset;
   43282:	8b 45 fc             	mov    -0x4(%rbp),%eax
   43285:	48 63 d0             	movslq %eax,%rdx
   43288:	48 89 d0             	mov    %rdx,%rax
   4328b:	48 c1 e0 03          	shl    $0x3,%rax
   4328f:	48 29 d0             	sub    %rdx,%rax
   43292:	48 c1 e0 03          	shl    $0x3,%rax
   43296:	48 89 c2             	mov    %rax,%rdx
   43299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4329d:	48 01 d0             	add    %rdx,%rax
   432a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
   432a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   432a8:	48 01 d0             	add    %rdx,%rax
   432ab:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            if (program_load_segment(p, &ph[i], pdata, allocator) < 0) {
   432af:	8b 45 fc             	mov    -0x4(%rbp),%eax
   432b2:	48 63 d0             	movslq %eax,%rdx
   432b5:	48 89 d0             	mov    %rdx,%rax
   432b8:	48 c1 e0 03          	shl    $0x3,%rax
   432bc:	48 29 d0             	sub    %rdx,%rax
   432bf:	48 c1 e0 03          	shl    $0x3,%rax
   432c3:	48 89 c2             	mov    %rax,%rdx
   432c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   432ca:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
   432ce:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   432d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   432d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   432da:	48 89 c7             	mov    %rax,%rdi
   432dd:	e8 3d 00 00 00       	callq  4331f <program_load_segment>
   432e2:	85 c0                	test   %eax,%eax
   432e4:	79 07                	jns    432ed <program_load+0x122>
                return -1;
   432e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   432eb:	eb 30                	jmp    4331d <program_load+0x152>
    for (int i = 0; i < eh->e_phnum; ++i) {
   432ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   432f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   432f5:	0f b7 40 38          	movzwl 0x38(%rax),%eax
   432f9:	0f b7 c0             	movzwl %ax,%eax
   432fc:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   432ff:	0f 8c 58 ff ff ff    	jl     4325d <program_load+0x92>
            }
        }
    }

    // set the entry point from the ELF header
    p->p_registers.reg_rip = eh->e_entry;
   43305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43309:	48 8b 50 18          	mov    0x18(%rax),%rdx
   4330d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43311:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    return 0;
   43318:	b8 00 00 00 00       	mov    $0x0,%eax
}
   4331d:	c9                   	leaveq 
   4331e:	c3                   	retq   

000000000004331f <program_load_segment>:
//    Calls `assign_physical_page` to allocate pages and `virtual_memory_map`
//    to map them in `p->p_pagetable`. Returns 0 on success and -1 on failure.

static int program_load_segment(proc* p, const elf_program* ph,
                                const uint8_t* src,
                                x86_64_pagetable* (*allocator)(void)) {
   4331f:	55                   	push   %rbp
   43320:	48 89 e5             	mov    %rsp,%rbp
   43323:	48 83 ec 70          	sub    $0x70,%rsp
   43327:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   4332b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
   4332f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
   43333:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    uintptr_t va = (uintptr_t) ph->p_va;
   43337:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   4333b:	48 8b 40 10          	mov    0x10(%rax),%rax
   4333f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    uintptr_t end_file = va + ph->p_filesz, end_mem = va + ph->p_memsz;
   43343:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   43347:	48 8b 50 20          	mov    0x20(%rax),%rdx
   4334b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4334f:	48 01 d0             	add    %rdx,%rax
   43352:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   43356:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   4335a:	48 8b 50 28          	mov    0x28(%rax),%rdx
   4335e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43362:	48 01 d0             	add    %rdx,%rax
   43365:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    va &= ~(PAGESIZE - 1);                // round to page boundary
   43369:	48 81 65 e8 00 f0 ff 	andq   $0xfffffffffffff000,-0x18(%rbp)
   43370:	ff 

    // allocate memory
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   43371:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43375:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   43379:	e9 cb 00 00 00       	jmpq   43449 <program_load_segment+0x12a>
        uintptr_t pa = FreePageAddr();
   4337e:	b8 00 00 00 00       	mov    $0x0,%eax
   43383:	e8 32 cf ff ff       	callq  402ba <FreePageAddr>
   43388:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        if (pa == (uintptr_t) 0) {
   4338c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
   43391:	75 30                	jne    433c3 <program_load_segment+0xa4>
            console_printf(CPOS(24, 0), 0x0C00, "Out of physical memory!\n");
   43393:	ba 54 49 04 00       	mov    $0x44954,%edx
   43398:	be 00 0c 00 00       	mov    $0xc00,%esi
   4339d:	bf 80 07 00 00       	mov    $0x780,%edi
   433a2:	b8 00 00 00 00       	mov    $0x0,%eax
   433a7:	e8 f0 0a 00 00       	callq  43e9c <console_printf>
            ExitProcess(p->p_pid);
   433ac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   433b0:	8b 00                	mov    (%rax),%eax
   433b2:	89 c7                	mov    %eax,%edi
   433b4:	e8 5e d0 ff ff       	callq  40417 <ExitProcess>
            return -1;
   433b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   433be:	e9 90 01 00 00       	jmpq   43553 <program_load_segment+0x234>
        }
        if (assign_physical_page(pa, p->p_pid) < 0 || virtual_memory_map(p->p_pagetable, addr, pa, PAGESIZE,
   433c3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   433c7:	8b 00                	mov    (%rax),%eax
   433c9:	0f be d0             	movsbl %al,%edx
   433cc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   433d0:	89 d6                	mov    %edx,%esi
   433d2:	48 89 c7             	mov    %rax,%rdi
   433d5:	e8 02 d9 ff ff       	callq  40cdc <assign_physical_page>
   433da:	85 c0                	test   %eax,%eax
   433dc:	78 31                	js     4340f <program_load_segment+0xf0>
   433de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   433e2:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   433e9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   433ed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   433f1:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   433f5:	49 89 c9             	mov    %rcx,%r9
   433f8:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   433fe:	b9 00 10 00 00       	mov    $0x1000,%ecx
   43403:	48 89 c7             	mov    %rax,%rdi
   43406:	e8 1c ee ff ff       	callq  42227 <virtual_memory_map>
   4340b:	85 c0                	test   %eax,%eax
   4340d:	79 32                	jns    43441 <program_load_segment+0x122>
                                  PTE_P | PTE_W | PTE_U, allocator) < 0) {
            console_printf(CPOS(22, 0), 0xC000, "program_load_segment(pid %d): can't assign address %p\n", p->p_pid, addr);
   4340f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43413:	8b 00                	mov    (%rax),%eax
   43415:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   43419:	49 89 d0             	mov    %rdx,%r8
   4341c:	89 c1                	mov    %eax,%ecx
   4341e:	ba 70 49 04 00       	mov    $0x44970,%edx
   43423:	be 00 c0 00 00       	mov    $0xc000,%esi
   43428:	bf e0 06 00 00       	mov    $0x6e0,%edi
   4342d:	b8 00 00 00 00       	mov    $0x0,%eax
   43432:	e8 65 0a 00 00       	callq  43e9c <console_printf>
            return -1;
   43437:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   4343c:	e9 12 01 00 00       	jmpq   43553 <program_load_segment+0x234>
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   43441:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   43448:	00 
   43449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4344d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
   43451:	0f 82 27 ff ff ff    	jb     4337e <program_load_segment+0x5f>
        }
    }

    // ensure new memory mappings are active
    set_pagetable(p->p_pagetable);
   43457:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   4345b:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   43462:	48 89 c7             	mov    %rax,%rdi
   43465:	e8 ab f2 ff ff       	callq  42715 <set_pagetable>

    // copy data from executable image into process memory
    memcpy((uint8_t*) va, src, end_file - va);
   4346a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4346e:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
   43472:	48 89 c2             	mov    %rax,%rdx
   43475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43479:	48 8b 4d 98          	mov    -0x68(%rbp),%rcx
   4347d:	48 89 ce             	mov    %rcx,%rsi
   43480:	48 89 c7             	mov    %rax,%rdi
   43483:	e8 6d 01 00 00       	callq  435f5 <memcpy>
    memset((uint8_t*) end_file, 0, end_mem - end_file);
   43488:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4348c:	48 2b 45 e0          	sub    -0x20(%rbp),%rax
   43490:	48 89 c2             	mov    %rax,%rdx
   43493:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43497:	be 00 00 00 00       	mov    $0x0,%esi
   4349c:	48 89 c7             	mov    %rax,%rdi
   4349f:	e8 ba 01 00 00       	callq  4365e <memset>

    // remove write access if not required
    if ((ph->p_flags & ELF_PFLAG_WRITE) == 0) {
   434a4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   434a8:	8b 40 04             	mov    0x4(%rax),%eax
   434ab:	83 e0 02             	and    $0x2,%eax
   434ae:	85 c0                	test   %eax,%eax
   434b0:	0f 85 89 00 00 00    	jne    4353f <program_load_segment+0x220>
        for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   434b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   434ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   434be:	eb 75                	jmp    43535 <program_load_segment+0x216>
            vamapping map = virtual_memory_lookup(p->p_pagetable, addr);
   434c0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   434c4:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   434cb:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   434cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   434d3:	48 89 ce             	mov    %rcx,%rsi
   434d6:	48 89 c7             	mov    %rax,%rdi
   434d9:	e8 40 f1 ff ff       	callq  4261e <virtual_memory_lookup>
            uintptr_t pa = map.pa;
   434de:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   434e2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
            log_printf("va = %d, pa = %d\n", va, pa);
   434e6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   434ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   434ee:	48 89 c6             	mov    %rax,%rsi
   434f1:	bf a7 49 04 00       	mov    $0x449a7,%edi
   434f6:	b8 00 00 00 00       	mov    $0x0,%eax
   434fb:	e8 a8 f9 ff ff       	callq  42ea8 <log_printf>
            virtual_memory_map(p->p_pagetable, addr, pa, PAGESIZE, PTE_P | PTE_U, allocator);
   43500:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43504:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   4350b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   4350f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   43513:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   43517:	49 89 c9             	mov    %rcx,%r9
   4351a:	41 b8 05 00 00 00    	mov    $0x5,%r8d
   43520:	b9 00 10 00 00       	mov    $0x1000,%ecx
   43525:	48 89 c7             	mov    %rax,%rdi
   43528:	e8 fa ec ff ff       	callq  42227 <virtual_memory_map>
        for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   4352d:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
   43534:	00 
   43535:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43539:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
   4353d:	72 81                	jb     434c0 <program_load_segment+0x1a1>
        } 
    }

    // restore kernel pagetable
    set_pagetable(kernel_pagetable);
   4353f:	48 8b 05 7a 2d 01 00 	mov    0x12d7a(%rip),%rax        # 562c0 <kernel_pagetable>
   43546:	48 89 c7             	mov    %rax,%rdi
   43549:	e8 c7 f1 ff ff       	callq  42715 <set_pagetable>
    return 0;
   4354e:	b8 00 00 00 00       	mov    $0x0,%eax
}
   43553:	c9                   	leaveq 
   43554:	c3                   	retq   

0000000000043555 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
   43555:	41 89 d0             	mov    %edx,%r8d
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
   43558:	48 81 7f 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rdi)
   4355f:	00 
   43560:	72 08                	jb     4356a <console_putc+0x15>
        cp->cursor = console;
   43562:	48 c7 47 08 00 80 0b 	movq   $0xb8000,0x8(%rdi)
   43569:	00 
    }
    if (c == '\n') {
   4356a:	40 80 fe 0a          	cmp    $0xa,%sil
   4356e:	74 17                	je     43587 <console_putc+0x32>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
   43570:	48 8b 47 08          	mov    0x8(%rdi),%rax
   43574:	48 8d 50 02          	lea    0x2(%rax),%rdx
   43578:	48 89 57 08          	mov    %rdx,0x8(%rdi)
   4357c:	40 0f b6 f6          	movzbl %sil,%esi
   43580:	44 09 c6             	or     %r8d,%esi
   43583:	66 89 30             	mov    %si,(%rax)
    }
}
   43586:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
   43587:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   4358b:	48 81 ee 00 80 0b 00 	sub    $0xb8000,%rsi
   43592:	48 89 f1             	mov    %rsi,%rcx
   43595:	48 d1 f9             	sar    %rcx
   43598:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
   4359f:	66 66 66 
   435a2:	48 89 c8             	mov    %rcx,%rax
   435a5:	48 f7 ea             	imul   %rdx
   435a8:	48 c1 fa 05          	sar    $0x5,%rdx
   435ac:	48 c1 fe 3f          	sar    $0x3f,%rsi
   435b0:	48 29 f2             	sub    %rsi,%rdx
   435b3:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
   435b7:	48 c1 e0 04          	shl    $0x4,%rax
   435bb:	89 ca                	mov    %ecx,%edx
   435bd:	29 c2                	sub    %eax,%edx
   435bf:	89 d0                	mov    %edx,%eax
            *cp->cursor++ = ' ' | color;
   435c1:	44 89 c6             	mov    %r8d,%esi
   435c4:	83 ce 20             	or     $0x20,%esi
   435c7:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
   435cb:	4c 8d 41 02          	lea    0x2(%rcx),%r8
   435cf:	4c 89 47 08          	mov    %r8,0x8(%rdi)
   435d3:	66 89 31             	mov    %si,(%rcx)
        for (; pos != 80; pos++) {
   435d6:	83 c0 01             	add    $0x1,%eax
   435d9:	83 f8 50             	cmp    $0x50,%eax
   435dc:	75 e9                	jne    435c7 <console_putc+0x72>
   435de:	c3                   	retq   

00000000000435df <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
   435df:	48 8b 47 08          	mov    0x8(%rdi),%rax
   435e3:	48 3b 47 10          	cmp    0x10(%rdi),%rax
   435e7:	73 0b                	jae    435f4 <string_putc+0x15>
        *sp->s++ = c;
   435e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
   435ed:	48 89 57 08          	mov    %rdx,0x8(%rdi)
   435f1:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
   435f4:	c3                   	retq   

00000000000435f5 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
   435f5:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   435f8:	48 85 d2             	test   %rdx,%rdx
   435fb:	74 17                	je     43614 <memcpy+0x1f>
   435fd:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
   43602:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
   43607:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   4360b:	48 83 c1 01          	add    $0x1,%rcx
   4360f:	48 39 d1             	cmp    %rdx,%rcx
   43612:	75 ee                	jne    43602 <memcpy+0xd>
}
   43614:	c3                   	retq   

0000000000043615 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
   43615:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
   43618:	48 39 fe             	cmp    %rdi,%rsi
   4361b:	72 1d                	jb     4363a <memmove+0x25>
        while (n-- > 0) {
   4361d:	b9 00 00 00 00       	mov    $0x0,%ecx
   43622:	48 85 d2             	test   %rdx,%rdx
   43625:	74 12                	je     43639 <memmove+0x24>
            *d++ = *s++;
   43627:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
   4362b:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
   4362f:	48 83 c1 01          	add    $0x1,%rcx
   43633:	48 39 ca             	cmp    %rcx,%rdx
   43636:	75 ef                	jne    43627 <memmove+0x12>
}
   43638:	c3                   	retq   
   43639:	c3                   	retq   
    if (s < d && s + n > d) {
   4363a:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
   4363e:	48 39 cf             	cmp    %rcx,%rdi
   43641:	73 da                	jae    4361d <memmove+0x8>
        while (n-- > 0) {
   43643:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
   43647:	48 85 d2             	test   %rdx,%rdx
   4364a:	74 ec                	je     43638 <memmove+0x23>
            *--d = *--s;
   4364c:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
   43650:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
   43653:	48 83 e9 01          	sub    $0x1,%rcx
   43657:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
   4365b:	75 ef                	jne    4364c <memmove+0x37>
   4365d:	c3                   	retq   

000000000004365e <memset>:
void* memset(void* v, int c, size_t n) {
   4365e:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
   43661:	48 85 d2             	test   %rdx,%rdx
   43664:	74 13                	je     43679 <memset+0x1b>
   43666:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
   4366a:	48 89 fa             	mov    %rdi,%rdx
        *p = c;
   4366d:	40 88 32             	mov    %sil,(%rdx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
   43670:	48 83 c2 01          	add    $0x1,%rdx
   43674:	48 39 d1             	cmp    %rdx,%rcx
   43677:	75 f4                	jne    4366d <memset+0xf>
}
   43679:	c3                   	retq   

000000000004367a <strlen>:
    for (n = 0; *s != '\0'; ++s) {
   4367a:	80 3f 00             	cmpb   $0x0,(%rdi)
   4367d:	74 10                	je     4368f <strlen+0x15>
   4367f:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
   43684:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
   43688:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
   4368c:	75 f6                	jne    43684 <strlen+0xa>
   4368e:	c3                   	retq   
   4368f:	b8 00 00 00 00       	mov    $0x0,%eax
}
   43694:	c3                   	retq   

0000000000043695 <strnlen>:
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   43695:	b8 00 00 00 00       	mov    $0x0,%eax
   4369a:	48 85 f6             	test   %rsi,%rsi
   4369d:	74 10                	je     436af <strnlen+0x1a>
   4369f:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
   436a3:	74 09                	je     436ae <strnlen+0x19>
        ++n;
   436a5:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   436a9:	48 39 c6             	cmp    %rax,%rsi
   436ac:	75 f1                	jne    4369f <strnlen+0xa>
}
   436ae:	c3                   	retq   
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   436af:	48 89 f0             	mov    %rsi,%rax
   436b2:	c3                   	retq   

00000000000436b3 <strcpy>:
char* strcpy(char* dst, const char* src) {
   436b3:	48 89 f8             	mov    %rdi,%rax
   436b6:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
   436bb:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
   436bf:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
   436c2:	48 83 c2 01          	add    $0x1,%rdx
   436c6:	84 c9                	test   %cl,%cl
   436c8:	75 f1                	jne    436bb <strcpy+0x8>
}
   436ca:	c3                   	retq   

00000000000436cb <strcmp>:
    while (*a && *b && *a == *b) {
   436cb:	0f b6 17             	movzbl (%rdi),%edx
   436ce:	84 d2                	test   %dl,%dl
   436d0:	74 1a                	je     436ec <strcmp+0x21>
   436d2:	0f b6 06             	movzbl (%rsi),%eax
   436d5:	38 d0                	cmp    %dl,%al
   436d7:	75 13                	jne    436ec <strcmp+0x21>
   436d9:	84 c0                	test   %al,%al
   436db:	74 0f                	je     436ec <strcmp+0x21>
        ++a, ++b;
   436dd:	48 83 c7 01          	add    $0x1,%rdi
   436e1:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
   436e5:	0f b6 17             	movzbl (%rdi),%edx
   436e8:	84 d2                	test   %dl,%dl
   436ea:	75 e6                	jne    436d2 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
   436ec:	0f b6 0e             	movzbl (%rsi),%ecx
   436ef:	38 ca                	cmp    %cl,%dl
   436f1:	0f 97 c0             	seta   %al
   436f4:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
   436f7:	83 d8 00             	sbb    $0x0,%eax
}
   436fa:	c3                   	retq   

00000000000436fb <strchr>:
    while (*s && *s != (char) c) {
   436fb:	0f b6 07             	movzbl (%rdi),%eax
   436fe:	84 c0                	test   %al,%al
   43700:	74 10                	je     43712 <strchr+0x17>
   43702:	40 38 f0             	cmp    %sil,%al
   43705:	74 18                	je     4371f <strchr+0x24>
        ++s;
   43707:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
   4370b:	0f b6 07             	movzbl (%rdi),%eax
   4370e:	84 c0                	test   %al,%al
   43710:	75 f0                	jne    43702 <strchr+0x7>
        return NULL;
   43712:	40 84 f6             	test   %sil,%sil
   43715:	b8 00 00 00 00       	mov    $0x0,%eax
   4371a:	48 0f 44 c7          	cmove  %rdi,%rax
}
   4371e:	c3                   	retq   
   4371f:	48 89 f8             	mov    %rdi,%rax
   43722:	c3                   	retq   

0000000000043723 <rand>:
    if (!rand_seed_set) {
   43723:	83 3d e2 28 01 00 00 	cmpl   $0x0,0x128e2(%rip)        # 5600c <rand_seed_set>
   4372a:	74 1b                	je     43747 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
   4372c:	69 05 d2 28 01 00 0d 	imul   $0x19660d,0x128d2(%rip),%eax        # 56008 <rand_seed>
   43733:	66 19 00 
   43736:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
   4373b:	89 05 c7 28 01 00    	mov    %eax,0x128c7(%rip)        # 56008 <rand_seed>
    return rand_seed & RAND_MAX;
   43741:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
   43746:	c3                   	retq   
    rand_seed = seed;
   43747:	c7 05 b7 28 01 00 9e 	movl   $0x30d4879e,0x128b7(%rip)        # 56008 <rand_seed>
   4374e:	87 d4 30 
    rand_seed_set = 1;
   43751:	c7 05 b1 28 01 00 01 	movl   $0x1,0x128b1(%rip)        # 5600c <rand_seed_set>
   43758:	00 00 00 
}
   4375b:	eb cf                	jmp    4372c <rand+0x9>

000000000004375d <srand>:
    rand_seed = seed;
   4375d:	89 3d a5 28 01 00    	mov    %edi,0x128a5(%rip)        # 56008 <rand_seed>
    rand_seed_set = 1;
   43763:	c7 05 9f 28 01 00 01 	movl   $0x1,0x1289f(%rip)        # 5600c <rand_seed_set>
   4376a:	00 00 00 
}
   4376d:	c3                   	retq   

000000000004376e <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
   4376e:	55                   	push   %rbp
   4376f:	48 89 e5             	mov    %rsp,%rbp
   43772:	41 57                	push   %r15
   43774:	41 56                	push   %r14
   43776:	41 55                	push   %r13
   43778:	41 54                	push   %r12
   4377a:	53                   	push   %rbx
   4377b:	48 83 ec 58          	sub    $0x58,%rsp
   4377f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
   43783:	0f b6 02             	movzbl (%rdx),%eax
   43786:	84 c0                	test   %al,%al
   43788:	0f 84 ba 06 00 00    	je     43e48 <printer_vprintf+0x6da>
   4378e:	49 89 fe             	mov    %rdi,%r14
   43791:	49 89 d4             	mov    %rdx,%r12
            length = 1;
   43794:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%rbp)
   4379b:	41 89 f7             	mov    %esi,%r15d
   4379e:	e9 a5 04 00 00       	jmpq   43c48 <printer_vprintf+0x4da>
        for (++format; *format; ++format) {
   437a3:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
   437a8:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
   437ae:	45 84 e4             	test   %r12b,%r12b
   437b1:	0f 84 85 06 00 00    	je     43e3c <printer_vprintf+0x6ce>
        int flags = 0;
   437b7:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
   437bd:	41 0f be f4          	movsbl %r12b,%esi
   437c1:	bf c1 4b 04 00       	mov    $0x44bc1,%edi
   437c6:	e8 30 ff ff ff       	callq  436fb <strchr>
   437cb:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
   437ce:	48 85 c0             	test   %rax,%rax
   437d1:	74 55                	je     43828 <printer_vprintf+0xba>
                flags |= 1 << (flagc - flag_chars);
   437d3:	48 81 e9 c1 4b 04 00 	sub    $0x44bc1,%rcx
   437da:	b8 01 00 00 00       	mov    $0x1,%eax
   437df:	d3 e0                	shl    %cl,%eax
   437e1:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
   437e4:	48 83 c3 01          	add    $0x1,%rbx
   437e8:	44 0f b6 23          	movzbl (%rbx),%r12d
   437ec:	45 84 e4             	test   %r12b,%r12b
   437ef:	75 cc                	jne    437bd <printer_vprintf+0x4f>
   437f1:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
   437f5:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
   437fb:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
   43802:	80 3b 2e             	cmpb   $0x2e,(%rbx)
   43805:	0f 84 a9 00 00 00    	je     438b4 <printer_vprintf+0x146>
        int length = 0;
   4380b:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
   43810:	0f b6 13             	movzbl (%rbx),%edx
   43813:	8d 42 bd             	lea    -0x43(%rdx),%eax
   43816:	3c 37                	cmp    $0x37,%al
   43818:	0f 87 c5 04 00 00    	ja     43ce3 <printer_vprintf+0x575>
   4381e:	0f b6 c0             	movzbl %al,%eax
   43821:	ff 24 c5 d0 49 04 00 	jmpq   *0x449d0(,%rax,8)
   43828:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        if (*format >= '1' && *format <= '9') {
   4382c:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
   43831:	3c 08                	cmp    $0x8,%al
   43833:	77 2f                	ja     43864 <printer_vprintf+0xf6>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   43835:	0f b6 03             	movzbl (%rbx),%eax
   43838:	8d 50 d0             	lea    -0x30(%rax),%edx
   4383b:	80 fa 09             	cmp    $0x9,%dl
   4383e:	77 5e                	ja     4389e <printer_vprintf+0x130>
   43840:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
   43846:	48 83 c3 01          	add    $0x1,%rbx
   4384a:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
   4384f:	0f be c0             	movsbl %al,%eax
   43852:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   43857:	0f b6 03             	movzbl (%rbx),%eax
   4385a:	8d 50 d0             	lea    -0x30(%rax),%edx
   4385d:	80 fa 09             	cmp    $0x9,%dl
   43860:	76 e4                	jbe    43846 <printer_vprintf+0xd8>
   43862:	eb 97                	jmp    437fb <printer_vprintf+0x8d>
        } else if (*format == '*') {
   43864:	41 80 fc 2a          	cmp    $0x2a,%r12b
   43868:	75 3f                	jne    438a9 <printer_vprintf+0x13b>
            width = va_arg(val, int);
   4386a:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   4386e:	8b 01                	mov    (%rcx),%eax
   43870:	83 f8 2f             	cmp    $0x2f,%eax
   43873:	77 17                	ja     4388c <printer_vprintf+0x11e>
   43875:	89 c2                	mov    %eax,%edx
   43877:	48 03 51 10          	add    0x10(%rcx),%rdx
   4387b:	83 c0 08             	add    $0x8,%eax
   4387e:	89 01                	mov    %eax,(%rcx)
   43880:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
   43883:	48 83 c3 01          	add    $0x1,%rbx
   43887:	e9 6f ff ff ff       	jmpq   437fb <printer_vprintf+0x8d>
            width = va_arg(val, int);
   4388c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43890:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43894:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43898:	48 89 47 08          	mov    %rax,0x8(%rdi)
   4389c:	eb e2                	jmp    43880 <printer_vprintf+0x112>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   4389e:	41 bd 00 00 00 00    	mov    $0x0,%r13d
   438a4:	e9 52 ff ff ff       	jmpq   437fb <printer_vprintf+0x8d>
        int width = -1;
   438a9:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
   438af:	e9 47 ff ff ff       	jmpq   437fb <printer_vprintf+0x8d>
            ++format;
   438b4:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
   438b8:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
   438bc:	8d 48 d0             	lea    -0x30(%rax),%ecx
   438bf:	80 f9 09             	cmp    $0x9,%cl
   438c2:	76 13                	jbe    438d7 <printer_vprintf+0x169>
            } else if (*format == '*') {
   438c4:	3c 2a                	cmp    $0x2a,%al
   438c6:	74 32                	je     438fa <printer_vprintf+0x18c>
            ++format;
   438c8:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
   438cb:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
   438d2:	e9 34 ff ff ff       	jmpq   4380b <printer_vprintf+0x9d>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   438d7:	be 00 00 00 00       	mov    $0x0,%esi
                    precision = 10 * precision + *format++ - '0';
   438dc:	48 83 c2 01          	add    $0x1,%rdx
   438e0:	8d 0c b6             	lea    (%rsi,%rsi,4),%ecx
   438e3:	0f be c0             	movsbl %al,%eax
   438e6:	8d 74 48 d0          	lea    -0x30(%rax,%rcx,2),%esi
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   438ea:	0f b6 02             	movzbl (%rdx),%eax
   438ed:	8d 48 d0             	lea    -0x30(%rax),%ecx
   438f0:	80 f9 09             	cmp    $0x9,%cl
   438f3:	76 e7                	jbe    438dc <printer_vprintf+0x16e>
                    precision = 10 * precision + *format++ - '0';
   438f5:	48 89 d3             	mov    %rdx,%rbx
   438f8:	eb 1c                	jmp    43916 <printer_vprintf+0x1a8>
                precision = va_arg(val, int);
   438fa:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   438fe:	8b 07                	mov    (%rdi),%eax
   43900:	83 f8 2f             	cmp    $0x2f,%eax
   43903:	77 23                	ja     43928 <printer_vprintf+0x1ba>
   43905:	89 c2                	mov    %eax,%edx
   43907:	48 03 57 10          	add    0x10(%rdi),%rdx
   4390b:	83 c0 08             	add    $0x8,%eax
   4390e:	89 07                	mov    %eax,(%rdi)
   43910:	8b 32                	mov    (%rdx),%esi
                ++format;
   43912:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
   43916:	85 f6                	test   %esi,%esi
   43918:	b8 00 00 00 00       	mov    $0x0,%eax
   4391d:	0f 48 f0             	cmovs  %eax,%esi
   43920:	89 75 9c             	mov    %esi,-0x64(%rbp)
   43923:	e9 e3 fe ff ff       	jmpq   4380b <printer_vprintf+0x9d>
                precision = va_arg(val, int);
   43928:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   4392c:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43930:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43934:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43938:	eb d6                	jmp    43910 <printer_vprintf+0x1a2>
        switch (*format) {
   4393a:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
   4393f:	e9 f1 00 00 00       	jmpq   43a35 <printer_vprintf+0x2c7>
            ++format;
   43944:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
   43948:	8b 4d 80             	mov    -0x80(%rbp),%ecx
            goto again;
   4394b:	e9 c0 fe ff ff       	jmpq   43810 <printer_vprintf+0xa2>
            long x = length ? va_arg(val, long) : va_arg(val, int);
   43950:	85 c9                	test   %ecx,%ecx
   43952:	74 55                	je     439a9 <printer_vprintf+0x23b>
   43954:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43958:	8b 01                	mov    (%rcx),%eax
   4395a:	83 f8 2f             	cmp    $0x2f,%eax
   4395d:	77 38                	ja     43997 <printer_vprintf+0x229>
   4395f:	89 c2                	mov    %eax,%edx
   43961:	48 03 51 10          	add    0x10(%rcx),%rdx
   43965:	83 c0 08             	add    $0x8,%eax
   43968:	89 01                	mov    %eax,(%rcx)
   4396a:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
   4396d:	48 89 d0             	mov    %rdx,%rax
   43970:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
   43974:	49 89 d0             	mov    %rdx,%r8
   43977:	49 f7 d8             	neg    %r8
   4397a:	25 80 00 00 00       	and    $0x80,%eax
   4397f:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
   43983:	0b 45 a8             	or     -0x58(%rbp),%eax
   43986:	83 c8 60             	or     $0x60,%eax
   43989:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
   4398c:	41 bc bd 49 04 00    	mov    $0x449bd,%r12d
            break;
   43992:	e9 35 01 00 00       	jmpq   43acc <printer_vprintf+0x35e>
            long x = length ? va_arg(val, long) : va_arg(val, int);
   43997:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   4399b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   4399f:	48 8d 42 08          	lea    0x8(%rdx),%rax
   439a3:	48 89 47 08          	mov    %rax,0x8(%rdi)
   439a7:	eb c1                	jmp    4396a <printer_vprintf+0x1fc>
   439a9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   439ad:	8b 07                	mov    (%rdi),%eax
   439af:	83 f8 2f             	cmp    $0x2f,%eax
   439b2:	77 10                	ja     439c4 <printer_vprintf+0x256>
   439b4:	89 c2                	mov    %eax,%edx
   439b6:	48 03 57 10          	add    0x10(%rdi),%rdx
   439ba:	83 c0 08             	add    $0x8,%eax
   439bd:	89 07                	mov    %eax,(%rdi)
   439bf:	48 63 12             	movslq (%rdx),%rdx
   439c2:	eb a9                	jmp    4396d <printer_vprintf+0x1ff>
   439c4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   439c8:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   439cc:	48 8d 42 08          	lea    0x8(%rdx),%rax
   439d0:	48 89 41 08          	mov    %rax,0x8(%rcx)
   439d4:	eb e9                	jmp    439bf <printer_vprintf+0x251>
        int base = 10;
   439d6:	be 0a 00 00 00       	mov    $0xa,%esi
   439db:	eb 58                	jmp    43a35 <printer_vprintf+0x2c7>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
   439dd:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   439e1:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   439e5:	48 8d 42 08          	lea    0x8(%rdx),%rax
   439e9:	48 89 41 08          	mov    %rax,0x8(%rcx)
   439ed:	eb 60                	jmp    43a4f <printer_vprintf+0x2e1>
   439ef:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   439f3:	8b 01                	mov    (%rcx),%eax
   439f5:	83 f8 2f             	cmp    $0x2f,%eax
   439f8:	77 10                	ja     43a0a <printer_vprintf+0x29c>
   439fa:	89 c2                	mov    %eax,%edx
   439fc:	48 03 51 10          	add    0x10(%rcx),%rdx
   43a00:	83 c0 08             	add    $0x8,%eax
   43a03:	89 01                	mov    %eax,(%rcx)
   43a05:	44 8b 02             	mov    (%rdx),%r8d
   43a08:	eb 48                	jmp    43a52 <printer_vprintf+0x2e4>
   43a0a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43a0e:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43a12:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43a16:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43a1a:	eb e9                	jmp    43a05 <printer_vprintf+0x297>
   43a1c:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
   43a1f:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
   43a26:	bf b0 4b 04 00       	mov    $0x44bb0,%edi
   43a2b:	e9 e6 02 00 00       	jmpq   43d16 <printer_vprintf+0x5a8>
            base = 16;
   43a30:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
   43a35:	85 c9                	test   %ecx,%ecx
   43a37:	74 b6                	je     439ef <printer_vprintf+0x281>
   43a39:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43a3d:	8b 07                	mov    (%rdi),%eax
   43a3f:	83 f8 2f             	cmp    $0x2f,%eax
   43a42:	77 99                	ja     439dd <printer_vprintf+0x26f>
   43a44:	89 c2                	mov    %eax,%edx
   43a46:	48 03 57 10          	add    0x10(%rdi),%rdx
   43a4a:	83 c0 08             	add    $0x8,%eax
   43a4d:	89 07                	mov    %eax,(%rdi)
   43a4f:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
   43a52:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
   43a56:	85 f6                	test   %esi,%esi
   43a58:	79 c2                	jns    43a1c <printer_vprintf+0x2ae>
        base = -base;
   43a5a:	41 89 f1             	mov    %esi,%r9d
   43a5d:	f7 de                	neg    %esi
   43a5f:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
   43a66:	bf 90 4b 04 00       	mov    $0x44b90,%edi
   43a6b:	e9 a6 02 00 00       	jmpq   43d16 <printer_vprintf+0x5a8>
            num = (uintptr_t) va_arg(val, void*);
   43a70:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43a74:	8b 07                	mov    (%rdi),%eax
   43a76:	83 f8 2f             	cmp    $0x2f,%eax
   43a79:	77 1c                	ja     43a97 <printer_vprintf+0x329>
   43a7b:	89 c2                	mov    %eax,%edx
   43a7d:	48 03 57 10          	add    0x10(%rdi),%rdx
   43a81:	83 c0 08             	add    $0x8,%eax
   43a84:	89 07                	mov    %eax,(%rdi)
   43a86:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
   43a89:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
   43a90:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
   43a95:	eb c3                	jmp    43a5a <printer_vprintf+0x2ec>
            num = (uintptr_t) va_arg(val, void*);
   43a97:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43a9b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43a9f:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43aa3:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43aa7:	eb dd                	jmp    43a86 <printer_vprintf+0x318>
            data = va_arg(val, char*);
   43aa9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43aad:	8b 01                	mov    (%rcx),%eax
   43aaf:	83 f8 2f             	cmp    $0x2f,%eax
   43ab2:	0f 87 a9 01 00 00    	ja     43c61 <printer_vprintf+0x4f3>
   43ab8:	89 c2                	mov    %eax,%edx
   43aba:	48 03 51 10          	add    0x10(%rcx),%rdx
   43abe:	83 c0 08             	add    $0x8,%eax
   43ac1:	89 01                	mov    %eax,(%rcx)
   43ac3:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
   43ac6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
   43acc:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43acf:	83 e0 20             	and    $0x20,%eax
   43ad2:	89 45 8c             	mov    %eax,-0x74(%rbp)
   43ad5:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
   43adb:	0f 85 25 02 00 00    	jne    43d06 <printer_vprintf+0x598>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
   43ae1:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43ae4:	89 45 88             	mov    %eax,-0x78(%rbp)
   43ae7:	83 e0 60             	and    $0x60,%eax
   43aea:	83 f8 60             	cmp    $0x60,%eax
   43aed:	0f 84 58 02 00 00    	je     43d4b <printer_vprintf+0x5dd>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
   43af3:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43af6:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
   43af9:	48 c7 45 a0 bd 49 04 	movq   $0x449bd,-0x60(%rbp)
   43b00:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
   43b01:	83 f8 21             	cmp    $0x21,%eax
   43b04:	0f 84 7d 02 00 00    	je     43d87 <printer_vprintf+0x619>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
   43b0a:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
   43b0d:	89 c8                	mov    %ecx,%eax
   43b0f:	f7 d0                	not    %eax
   43b11:	c1 e8 1f             	shr    $0x1f,%eax
   43b14:	89 45 84             	mov    %eax,-0x7c(%rbp)
   43b17:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
   43b1b:	0f 85 a2 02 00 00    	jne    43dc3 <printer_vprintf+0x655>
   43b21:	84 c0                	test   %al,%al
   43b23:	0f 84 9a 02 00 00    	je     43dc3 <printer_vprintf+0x655>
            len = strnlen(data, precision);
   43b29:	48 63 f1             	movslq %ecx,%rsi
   43b2c:	4c 89 e7             	mov    %r12,%rdi
   43b2f:	e8 61 fb ff ff       	callq  43695 <strnlen>
   43b34:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
   43b37:	8b 45 88             	mov    -0x78(%rbp),%eax
   43b3a:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
   43b3d:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
   43b44:	83 f8 22             	cmp    $0x22,%eax
   43b47:	0f 84 ae 02 00 00    	je     43dfb <printer_vprintf+0x68d>
        width -= len + zeros + strlen(prefix);
   43b4d:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
   43b51:	e8 24 fb ff ff       	callq  4367a <strlen>
   43b56:	8b 55 9c             	mov    -0x64(%rbp),%edx
   43b59:	03 55 98             	add    -0x68(%rbp),%edx
   43b5c:	41 29 d5             	sub    %edx,%r13d
   43b5f:	44 89 ea             	mov    %r13d,%edx
   43b62:	29 c2                	sub    %eax,%edx
   43b64:	89 55 8c             	mov    %edx,-0x74(%rbp)
   43b67:	41 89 d5             	mov    %edx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   43b6a:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
   43b6e:	75 2d                	jne    43b9d <printer_vprintf+0x42f>
   43b70:	85 d2                	test   %edx,%edx
   43b72:	7e 29                	jle    43b9d <printer_vprintf+0x42f>
            p->putc(p, ' ', color);
   43b74:	44 89 fa             	mov    %r15d,%edx
   43b77:	be 20 00 00 00       	mov    $0x20,%esi
   43b7c:	4c 89 f7             	mov    %r14,%rdi
   43b7f:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   43b82:	41 83 ed 01          	sub    $0x1,%r13d
   43b86:	45 85 ed             	test   %r13d,%r13d
   43b89:	7f e9                	jg     43b74 <printer_vprintf+0x406>
   43b8b:	8b 7d 8c             	mov    -0x74(%rbp),%edi
   43b8e:	85 ff                	test   %edi,%edi
   43b90:	b8 01 00 00 00       	mov    $0x1,%eax
   43b95:	0f 4f c7             	cmovg  %edi,%eax
   43b98:	29 c7                	sub    %eax,%edi
   43b9a:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
   43b9d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
   43ba1:	0f b6 01             	movzbl (%rcx),%eax
   43ba4:	84 c0                	test   %al,%al
   43ba6:	74 22                	je     43bca <printer_vprintf+0x45c>
   43ba8:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
   43bac:	48 89 cb             	mov    %rcx,%rbx
            p->putc(p, *prefix, color);
   43baf:	0f b6 f0             	movzbl %al,%esi
   43bb2:	44 89 fa             	mov    %r15d,%edx
   43bb5:	4c 89 f7             	mov    %r14,%rdi
   43bb8:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
   43bbb:	48 83 c3 01          	add    $0x1,%rbx
   43bbf:	0f b6 03             	movzbl (%rbx),%eax
   43bc2:	84 c0                	test   %al,%al
   43bc4:	75 e9                	jne    43baf <printer_vprintf+0x441>
   43bc6:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
   43bca:	8b 45 9c             	mov    -0x64(%rbp),%eax
   43bcd:	85 c0                	test   %eax,%eax
   43bcf:	7e 1d                	jle    43bee <printer_vprintf+0x480>
   43bd1:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
   43bd5:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
   43bd7:	44 89 fa             	mov    %r15d,%edx
   43bda:	be 30 00 00 00       	mov    $0x30,%esi
   43bdf:	4c 89 f7             	mov    %r14,%rdi
   43be2:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
   43be5:	83 eb 01             	sub    $0x1,%ebx
   43be8:	75 ed                	jne    43bd7 <printer_vprintf+0x469>
   43bea:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
   43bee:	8b 45 98             	mov    -0x68(%rbp),%eax
   43bf1:	85 c0                	test   %eax,%eax
   43bf3:	7e 2a                	jle    43c1f <printer_vprintf+0x4b1>
   43bf5:	8d 40 ff             	lea    -0x1(%rax),%eax
   43bf8:	49 8d 44 04 01       	lea    0x1(%r12,%rax,1),%rax
   43bfd:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
   43c01:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
   43c04:	41 0f b6 34 24       	movzbl (%r12),%esi
   43c09:	44 89 fa             	mov    %r15d,%edx
   43c0c:	4c 89 f7             	mov    %r14,%rdi
   43c0f:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
   43c12:	49 83 c4 01          	add    $0x1,%r12
   43c16:	49 39 dc             	cmp    %rbx,%r12
   43c19:	75 e9                	jne    43c04 <printer_vprintf+0x496>
   43c1b:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
   43c1f:	45 85 ed             	test   %r13d,%r13d
   43c22:	7e 14                	jle    43c38 <printer_vprintf+0x4ca>
            p->putc(p, ' ', color);
   43c24:	44 89 fa             	mov    %r15d,%edx
   43c27:	be 20 00 00 00       	mov    $0x20,%esi
   43c2c:	4c 89 f7             	mov    %r14,%rdi
   43c2f:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
   43c32:	41 83 ed 01          	sub    $0x1,%r13d
   43c36:	75 ec                	jne    43c24 <printer_vprintf+0x4b6>
    for (; *format; ++format) {
   43c38:	4c 8d 63 01          	lea    0x1(%rbx),%r12
   43c3c:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
   43c40:	84 c0                	test   %al,%al
   43c42:	0f 84 00 02 00 00    	je     43e48 <printer_vprintf+0x6da>
        if (*format != '%') {
   43c48:	3c 25                	cmp    $0x25,%al
   43c4a:	0f 84 53 fb ff ff    	je     437a3 <printer_vprintf+0x35>
            p->putc(p, *format, color);
   43c50:	0f b6 f0             	movzbl %al,%esi
   43c53:	44 89 fa             	mov    %r15d,%edx
   43c56:	4c 89 f7             	mov    %r14,%rdi
   43c59:	41 ff 16             	callq  *(%r14)
            continue;
   43c5c:	4c 89 e3             	mov    %r12,%rbx
   43c5f:	eb d7                	jmp    43c38 <printer_vprintf+0x4ca>
            data = va_arg(val, char*);
   43c61:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43c65:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43c69:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43c6d:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43c71:	e9 4d fe ff ff       	jmpq   43ac3 <printer_vprintf+0x355>
            color = va_arg(val, int);
   43c76:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43c7a:	8b 07                	mov    (%rdi),%eax
   43c7c:	83 f8 2f             	cmp    $0x2f,%eax
   43c7f:	77 10                	ja     43c91 <printer_vprintf+0x523>
   43c81:	89 c2                	mov    %eax,%edx
   43c83:	48 03 57 10          	add    0x10(%rdi),%rdx
   43c87:	83 c0 08             	add    $0x8,%eax
   43c8a:	89 07                	mov    %eax,(%rdi)
   43c8c:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
   43c8f:	eb a7                	jmp    43c38 <printer_vprintf+0x4ca>
            color = va_arg(val, int);
   43c91:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43c95:	48 8b 51 08          	mov    0x8(%rcx),%rdx
   43c99:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43c9d:	48 89 41 08          	mov    %rax,0x8(%rcx)
   43ca1:	eb e9                	jmp    43c8c <printer_vprintf+0x51e>
            numbuf[0] = va_arg(val, int);
   43ca3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   43ca7:	8b 01                	mov    (%rcx),%eax
   43ca9:	83 f8 2f             	cmp    $0x2f,%eax
   43cac:	77 23                	ja     43cd1 <printer_vprintf+0x563>
   43cae:	89 c2                	mov    %eax,%edx
   43cb0:	48 03 51 10          	add    0x10(%rcx),%rdx
   43cb4:	83 c0 08             	add    $0x8,%eax
   43cb7:	89 01                	mov    %eax,(%rcx)
   43cb9:	8b 02                	mov    (%rdx),%eax
   43cbb:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
   43cbe:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
   43cc2:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43cc6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
   43ccc:	e9 fb fd ff ff       	jmpq   43acc <printer_vprintf+0x35e>
            numbuf[0] = va_arg(val, int);
   43cd1:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
   43cd5:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   43cd9:	48 8d 42 08          	lea    0x8(%rdx),%rax
   43cdd:	48 89 47 08          	mov    %rax,0x8(%rdi)
   43ce1:	eb d6                	jmp    43cb9 <printer_vprintf+0x54b>
            numbuf[0] = (*format ? *format : '%');
   43ce3:	84 d2                	test   %dl,%dl
   43ce5:	0f 85 3b 01 00 00    	jne    43e26 <printer_vprintf+0x6b8>
   43ceb:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
   43cef:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
   43cf3:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
   43cf7:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43cfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
   43d01:	e9 c6 fd ff ff       	jmpq   43acc <printer_vprintf+0x35e>
        if (flags & FLAG_NUMERIC) {
   43d06:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
   43d0c:	bf b0 4b 04 00       	mov    $0x44bb0,%edi
        if (flags & FLAG_NUMERIC) {
   43d11:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
   43d16:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
   43d1a:	4c 89 c1             	mov    %r8,%rcx
   43d1d:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
   43d21:	48 63 f6             	movslq %esi,%rsi
   43d24:	49 83 ec 01          	sub    $0x1,%r12
   43d28:	48 89 c8             	mov    %rcx,%rax
   43d2b:	ba 00 00 00 00       	mov    $0x0,%edx
   43d30:	48 f7 f6             	div    %rsi
   43d33:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
   43d37:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
   43d3b:	48 89 ca             	mov    %rcx,%rdx
   43d3e:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
   43d41:	48 39 d6             	cmp    %rdx,%rsi
   43d44:	76 de                	jbe    43d24 <printer_vprintf+0x5b6>
   43d46:	e9 96 fd ff ff       	jmpq   43ae1 <printer_vprintf+0x373>
                prefix = "-";
   43d4b:	48 c7 45 a0 c0 49 04 	movq   $0x449c0,-0x60(%rbp)
   43d52:	00 
            if (flags & FLAG_NEGATIVE) {
   43d53:	8b 45 a8             	mov    -0x58(%rbp),%eax
   43d56:	a8 80                	test   $0x80,%al
   43d58:	0f 85 ac fd ff ff    	jne    43b0a <printer_vprintf+0x39c>
                prefix = "+";
   43d5e:	48 c7 45 a0 be 49 04 	movq   $0x449be,-0x60(%rbp)
   43d65:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
   43d66:	a8 10                	test   $0x10,%al
   43d68:	0f 85 9c fd ff ff    	jne    43b0a <printer_vprintf+0x39c>
                prefix = " ";
   43d6e:	a8 08                	test   $0x8,%al
   43d70:	ba bd 49 04 00       	mov    $0x449bd,%edx
   43d75:	b8 bc 49 04 00       	mov    $0x449bc,%eax
   43d7a:	48 0f 44 c2          	cmove  %rdx,%rax
   43d7e:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
   43d82:	e9 83 fd ff ff       	jmpq   43b0a <printer_vprintf+0x39c>
                   && (base == 16 || base == -16)
   43d87:	41 8d 41 10          	lea    0x10(%r9),%eax
   43d8b:	a9 df ff ff ff       	test   $0xffffffdf,%eax
   43d90:	0f 85 74 fd ff ff    	jne    43b0a <printer_vprintf+0x39c>
                   && (num || (flags & FLAG_ALT2))) {
   43d96:	4d 85 c0             	test   %r8,%r8
   43d99:	75 0d                	jne    43da8 <printer_vprintf+0x63a>
   43d9b:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
   43da2:	0f 84 62 fd ff ff    	je     43b0a <printer_vprintf+0x39c>
            prefix = (base == -16 ? "0x" : "0X");
   43da8:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
   43dac:	ba b9 49 04 00       	mov    $0x449b9,%edx
   43db1:	b8 c2 49 04 00       	mov    $0x449c2,%eax
   43db6:	48 0f 44 c2          	cmove  %rdx,%rax
   43dba:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
   43dbe:	e9 47 fd ff ff       	jmpq   43b0a <printer_vprintf+0x39c>
            len = strlen(data);
   43dc3:	4c 89 e7             	mov    %r12,%rdi
   43dc6:	e8 af f8 ff ff       	callq  4367a <strlen>
   43dcb:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
   43dce:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
   43dd2:	0f 84 5f fd ff ff    	je     43b37 <printer_vprintf+0x3c9>
   43dd8:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
   43ddc:	0f 84 55 fd ff ff    	je     43b37 <printer_vprintf+0x3c9>
            zeros = precision > len ? precision - len : 0;
   43de2:	8b 7d 9c             	mov    -0x64(%rbp),%edi
   43de5:	89 fa                	mov    %edi,%edx
   43de7:	29 c2                	sub    %eax,%edx
   43de9:	39 c7                	cmp    %eax,%edi
   43deb:	b8 00 00 00 00       	mov    $0x0,%eax
   43df0:	0f 4e d0             	cmovle %eax,%edx
   43df3:	89 55 9c             	mov    %edx,-0x64(%rbp)
   43df6:	e9 52 fd ff ff       	jmpq   43b4d <printer_vprintf+0x3df>
                   && len + (int) strlen(prefix) < width) {
   43dfb:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
   43dff:	e8 76 f8 ff ff       	callq  4367a <strlen>
   43e04:	8b 7d 98             	mov    -0x68(%rbp),%edi
   43e07:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
   43e0a:	44 89 e9             	mov    %r13d,%ecx
   43e0d:	29 f9                	sub    %edi,%ecx
   43e0f:	29 c1                	sub    %eax,%ecx
   43e11:	89 c8                	mov    %ecx,%eax
   43e13:	44 39 ea             	cmp    %r13d,%edx
   43e16:	b9 00 00 00 00       	mov    $0x0,%ecx
   43e1b:	0f 4d c1             	cmovge %ecx,%eax
   43e1e:	89 45 9c             	mov    %eax,-0x64(%rbp)
   43e21:	e9 27 fd ff ff       	jmpq   43b4d <printer_vprintf+0x3df>
            numbuf[0] = (*format ? *format : '%');
   43e26:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
   43e29:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
   43e2d:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
   43e31:	41 b8 00 00 00 00    	mov    $0x0,%r8d
   43e37:	e9 90 fc ff ff       	jmpq   43acc <printer_vprintf+0x35e>
        int flags = 0;
   43e3c:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
   43e43:	e9 ad f9 ff ff       	jmpq   437f5 <printer_vprintf+0x87>
}
   43e48:	48 83 c4 58          	add    $0x58,%rsp
   43e4c:	5b                   	pop    %rbx
   43e4d:	41 5c                	pop    %r12
   43e4f:	41 5d                	pop    %r13
   43e51:	41 5e                	pop    %r14
   43e53:	41 5f                	pop    %r15
   43e55:	5d                   	pop    %rbp
   43e56:	c3                   	retq   

0000000000043e57 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
   43e57:	55                   	push   %rbp
   43e58:	48 89 e5             	mov    %rsp,%rbp
   43e5b:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
   43e5f:	48 c7 45 f0 55 35 04 	movq   $0x43555,-0x10(%rbp)
   43e66:	00 
        cpos = 0;
   43e67:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
   43e6d:	b8 00 00 00 00       	mov    $0x0,%eax
   43e72:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
   43e75:	48 63 ff             	movslq %edi,%rdi
   43e78:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
   43e7f:	00 
   43e80:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
   43e84:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
   43e88:	e8 e1 f8 ff ff       	callq  4376e <printer_vprintf>
    return cp.cursor - console;
   43e8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43e91:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
   43e97:	48 d1 f8             	sar    %rax
}
   43e9a:	c9                   	leaveq 
   43e9b:	c3                   	retq   

0000000000043e9c <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
   43e9c:	55                   	push   %rbp
   43e9d:	48 89 e5             	mov    %rsp,%rbp
   43ea0:	48 83 ec 50          	sub    $0x50,%rsp
   43ea4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   43ea8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   43eac:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
   43eb0:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   43eb7:	48 8d 45 10          	lea    0x10(%rbp),%rax
   43ebb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   43ebf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   43ec3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
   43ec7:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   43ecb:	e8 87 ff ff ff       	callq  43e57 <console_vprintf>
}
   43ed0:	c9                   	leaveq 
   43ed1:	c3                   	retq   

0000000000043ed2 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
   43ed2:	55                   	push   %rbp
   43ed3:	48 89 e5             	mov    %rsp,%rbp
   43ed6:	53                   	push   %rbx
   43ed7:	48 83 ec 28          	sub    $0x28,%rsp
   43edb:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
   43ede:	48 c7 45 d8 df 35 04 	movq   $0x435df,-0x28(%rbp)
   43ee5:	00 
    sp.s = s;
   43ee6:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
   43eea:	48 85 f6             	test   %rsi,%rsi
   43eed:	75 0e                	jne    43efd <vsnprintf+0x2b>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
   43eef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43ef3:	48 29 d8             	sub    %rbx,%rax
}
   43ef6:	48 83 c4 28          	add    $0x28,%rsp
   43efa:	5b                   	pop    %rbx
   43efb:	5d                   	pop    %rbp
   43efc:	c3                   	retq   
        sp.end = s + size - 1;
   43efd:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
   43f02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
   43f06:	be 00 00 00 00       	mov    $0x0,%esi
   43f0b:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
   43f0f:	e8 5a f8 ff ff       	callq  4376e <printer_vprintf>
        *sp.s = 0;
   43f14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43f18:	c6 00 00             	movb   $0x0,(%rax)
   43f1b:	eb d2                	jmp    43eef <vsnprintf+0x1d>

0000000000043f1d <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
   43f1d:	55                   	push   %rbp
   43f1e:	48 89 e5             	mov    %rsp,%rbp
   43f21:	48 83 ec 50          	sub    $0x50,%rsp
   43f25:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   43f29:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   43f2d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   43f31:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   43f38:	48 8d 45 10          	lea    0x10(%rbp),%rax
   43f3c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   43f40:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   43f44:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
   43f48:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   43f4c:	e8 81 ff ff ff       	callq  43ed2 <vsnprintf>
    va_end(val);
    return n;
}
   43f51:	c9                   	leaveq 
   43f52:	c3                   	retq   

0000000000043f53 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   43f53:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   43f58:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
   43f5d:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   43f62:	48 83 c0 02          	add    $0x2,%rax
   43f66:	48 39 d0             	cmp    %rdx,%rax
   43f69:	75 f2                	jne    43f5d <console_clear+0xa>
    }
    cursorpos = 0;
   43f6b:	c7 05 87 50 07 00 00 	movl   $0x0,0x75087(%rip)        # b8ffc <cursorpos>
   43f72:	00 00 00 
}
   43f75:	c3                   	retq   
