
obj/p-forkexit.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	41 54                	push   %r12
  100006:	53                   	push   %rbx
  100007:	eb 02                	jmp    10000b <process_main+0xb>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  100009:	cd 32                	int    $0x32
    while (1) {
        if (rand() % ALLOC_SLOWDOWN == 0) {
  10000b:	e8 05 03 00 00       	callq  100315 <rand>
  100010:	89 c2                	mov    %eax,%edx
  100012:	48 98                	cltq   
  100014:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
  10001b:	48 c1 f8 25          	sar    $0x25,%rax
  10001f:	89 d1                	mov    %edx,%ecx
  100021:	c1 f9 1f             	sar    $0x1f,%ecx
  100024:	29 c8                	sub    %ecx,%eax
  100026:	6b c0 64             	imul   $0x64,%eax,%eax
  100029:	39 c2                	cmp    %eax,%edx
  10002b:	75 dc                	jne    100009 <process_main+0x9>
// sys_fork()
//    Fork the current process. On success, return the child's process ID to
//    the parent, and return 0 to the child. On failure, return -1.
static inline pid_t sys_fork(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  10002d:	cd 34                	int    $0x34
            if (sys_fork() == 0) {
  10002f:	85 c0                	test   %eax,%eax
  100031:	75 d8                	jne    10000b <process_main+0xb>
    asm volatile ("int %1" : "=a" (result)
  100033:	cd 31                	int    $0x31
  100035:	89 c7                	mov    %eax,%edi
  100037:	89 c3                	mov    %eax,%ebx
            sys_yield();
        }
    }

    pid_t p = sys_getpid();
    srand(p);
  100039:	e8 11 03 00 00       	callq  10034f <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  10003e:	b8 17 20 10 00       	mov    $0x102017,%eax
  100043:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100049:	48 89 05 b8 0f 00 00 	mov    %rax,0xfb8(%rip)        # 101008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  100050:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100053:	48 83 e8 01          	sub    $0x1,%rax
  100057:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10005d:	48 89 05 ac 0f 00 00 	mov    %rax,0xfac(%rip)        # 101010 <stack_bottom>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
            heap_top += PAGESIZE;
            if (console[CPOS(24, 0)]) {
  100064:	41 bc 00 80 0b 00    	mov    $0xb8000,%r12d
  10006a:	eb 13                	jmp    10007f <process_main+0x7f>
                /* clear "Out of physical memory" msg */
                console_printf(CPOS(24, 0), 0, "\n");
            }
        } else if (x == 8 * p) {
  10006c:	0f 84 91 00 00 00    	je     100103 <process_main+0x103>
            if (sys_fork() == 0) {
                p = sys_getpid();
            }
        } else if (x == 8 * p + 1) {
  100072:	83 c2 01             	add    $0x1,%edx
  100075:	39 c2                	cmp    %eax,%edx
  100077:	0f 84 99 00 00 00    	je     100116 <process_main+0x116>
    asm volatile ("int %0" : /* no result */
  10007d:	cd 32                	int    $0x32
        int x = rand() % (8 * ALLOC_SLOWDOWN);
  10007f:	e8 91 02 00 00       	callq  100315 <rand>
  100084:	89 c2                	mov    %eax,%edx
  100086:	48 98                	cltq   
  100088:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
  10008f:	48 c1 f8 28          	sar    $0x28,%rax
  100093:	89 d1                	mov    %edx,%ecx
  100095:	c1 f9 1f             	sar    $0x1f,%ecx
  100098:	29 c8                	sub    %ecx,%eax
  10009a:	69 c0 20 03 00 00    	imul   $0x320,%eax,%eax
  1000a0:	29 c2                	sub    %eax,%edx
  1000a2:	89 d0                	mov    %edx,%eax
        if (x < 8 * p) {
  1000a4:	8d 14 dd 00 00 00 00 	lea    0x0(,%rbx,8),%edx
  1000ab:	39 c2                	cmp    %eax,%edx
  1000ad:	7e bd                	jle    10006c <process_main+0x6c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1000af:	48 8b 3d 52 0f 00 00 	mov    0xf52(%rip),%rdi        # 101008 <heap_top>
  1000b6:	48 3b 3d 53 0f 00 00 	cmp    0xf53(%rip),%rdi        # 101010 <stack_bottom>
  1000bd:	74 5b                	je     10011a <process_main+0x11a>
    asm volatile ("int %1" : "=a" (result)
  1000bf:	cd 33                	int    $0x33
  1000c1:	85 c0                	test   %eax,%eax
  1000c3:	78 55                	js     10011a <process_main+0x11a>
            *heap_top = p;      /* check we have write access to new page */
  1000c5:	48 8b 05 3c 0f 00 00 	mov    0xf3c(%rip),%rax        # 101008 <heap_top>
  1000cc:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  1000ce:	48 81 05 2f 0f 00 00 	addq   $0x1000,0xf2f(%rip)        # 101008 <heap_top>
  1000d5:	00 10 00 00 
            if (console[CPOS(24, 0)]) {
  1000d9:	66 41 83 bc 24 00 0f 	cmpw   $0x0,0xf00(%r12)
  1000e0:	00 00 00 
  1000e3:	74 9a                	je     10007f <process_main+0x7f>
                console_printf(CPOS(24, 0), 0, "\n");
  1000e5:	ba 70 0b 10 00       	mov    $0x100b70,%edx
  1000ea:	be 00 00 00 00       	mov    $0x0,%esi
  1000ef:	bf 80 07 00 00       	mov    $0x780,%edi
  1000f4:	b8 00 00 00 00       	mov    $0x0,%eax
  1000f9:	e8 90 09 00 00       	callq  100a8e <console_printf>
  1000fe:	e9 7c ff ff ff       	jmpq   10007f <process_main+0x7f>
    asm volatile ("int %1" : "=a" (result)
  100103:	cd 34                	int    $0x34
            if (sys_fork() == 0) {
  100105:	85 c0                	test   %eax,%eax
  100107:	0f 85 72 ff ff ff    	jne    10007f <process_main+0x7f>
    asm volatile ("int %1" : "=a" (result)
  10010d:	cd 31                	int    $0x31
  10010f:	89 c3                	mov    %eax,%ebx
    return result;
  100111:	e9 69 ff ff ff       	jmpq   10007f <process_main+0x7f>

// sys_exit()
//    Exit this process. Does not return.
static inline void sys_exit(void) __attribute__((noreturn));
static inline void sys_exit(void) {
    asm volatile ("int %0" : /* no result */
  100116:	cd 35                	int    $0x35
                  : "i" (INT_SYS_EXIT)
                  : "cc", "memory");
 spinloop: goto spinloop;       // should never get here
  100118:	eb fe                	jmp    100118 <process_main+0x118>
        }
    }

    // After running out of memory
    while (1) {
        if (rand() % (2 * ALLOC_SLOWDOWN) == 0) {
  10011a:	e8 f6 01 00 00       	callq  100315 <rand>
  10011f:	89 c2                	mov    %eax,%edx
  100121:	48 98                	cltq   
  100123:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
  10012a:	48 c1 f8 26          	sar    $0x26,%rax
  10012e:	89 d1                	mov    %edx,%ecx
  100130:	c1 f9 1f             	sar    $0x1f,%ecx
  100133:	29 c8                	sub    %ecx,%eax
  100135:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
  10013b:	39 c2                	cmp    %eax,%edx
  10013d:	74 04                	je     100143 <process_main+0x143>
    asm volatile ("int %0" : /* no result */
  10013f:	cd 32                	int    $0x32
}
  100141:	eb d7                	jmp    10011a <process_main+0x11a>
    asm volatile ("int %0" : /* no result */
  100143:	cd 35                	int    $0x35
 spinloop: goto spinloop;       // should never get here
  100145:	eb fe                	jmp    100145 <process_main+0x145>

0000000000100147 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100147:	41 89 d0             	mov    %edx,%r8d
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  10014a:	48 81 7f 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rdi)
  100151:	00 
  100152:	72 08                	jb     10015c <console_putc+0x15>
        cp->cursor = console;
  100154:	48 c7 47 08 00 80 0b 	movq   $0xb8000,0x8(%rdi)
  10015b:	00 
    }
    if (c == '\n') {
  10015c:	40 80 fe 0a          	cmp    $0xa,%sil
  100160:	74 17                	je     100179 <console_putc+0x32>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  100162:	48 8b 47 08          	mov    0x8(%rdi),%rax
  100166:	48 8d 50 02          	lea    0x2(%rax),%rdx
  10016a:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  10016e:	40 0f b6 f6          	movzbl %sil,%esi
  100172:	44 09 c6             	or     %r8d,%esi
  100175:	66 89 30             	mov    %si,(%rax)
    }
}
  100178:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  100179:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  10017d:	48 81 ee 00 80 0b 00 	sub    $0xb8000,%rsi
  100184:	48 89 f1             	mov    %rsi,%rcx
  100187:	48 d1 f9             	sar    %rcx
  10018a:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  100191:	66 66 66 
  100194:	48 89 c8             	mov    %rcx,%rax
  100197:	48 f7 ea             	imul   %rdx
  10019a:	48 c1 fa 05          	sar    $0x5,%rdx
  10019e:	48 c1 fe 3f          	sar    $0x3f,%rsi
  1001a2:	48 29 f2             	sub    %rsi,%rdx
  1001a5:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  1001a9:	48 c1 e0 04          	shl    $0x4,%rax
  1001ad:	89 ca                	mov    %ecx,%edx
  1001af:	29 c2                	sub    %eax,%edx
  1001b1:	89 d0                	mov    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1001b3:	44 89 c6             	mov    %r8d,%esi
  1001b6:	83 ce 20             	or     $0x20,%esi
  1001b9:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  1001bd:	4c 8d 41 02          	lea    0x2(%rcx),%r8
  1001c1:	4c 89 47 08          	mov    %r8,0x8(%rdi)
  1001c5:	66 89 31             	mov    %si,(%rcx)
        for (; pos != 80; pos++) {
  1001c8:	83 c0 01             	add    $0x1,%eax
  1001cb:	83 f8 50             	cmp    $0x50,%eax
  1001ce:	75 e9                	jne    1001b9 <console_putc+0x72>
  1001d0:	c3                   	retq   

00000000001001d1 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1001d1:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1001d5:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1001d9:	73 0b                	jae    1001e6 <string_putc+0x15>
        *sp->s++ = c;
  1001db:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1001df:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1001e3:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1001e6:	c3                   	retq   

00000000001001e7 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1001e7:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001ea:	48 85 d2             	test   %rdx,%rdx
  1001ed:	74 17                	je     100206 <memcpy+0x1f>
  1001ef:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1001f4:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1001f9:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001fd:	48 83 c1 01          	add    $0x1,%rcx
  100201:	48 39 d1             	cmp    %rdx,%rcx
  100204:	75 ee                	jne    1001f4 <memcpy+0xd>
}
  100206:	c3                   	retq   

0000000000100207 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  100207:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  10020a:	48 39 fe             	cmp    %rdi,%rsi
  10020d:	72 1d                	jb     10022c <memmove+0x25>
        while (n-- > 0) {
  10020f:	b9 00 00 00 00       	mov    $0x0,%ecx
  100214:	48 85 d2             	test   %rdx,%rdx
  100217:	74 12                	je     10022b <memmove+0x24>
            *d++ = *s++;
  100219:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  10021d:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  100221:	48 83 c1 01          	add    $0x1,%rcx
  100225:	48 39 ca             	cmp    %rcx,%rdx
  100228:	75 ef                	jne    100219 <memmove+0x12>
}
  10022a:	c3                   	retq   
  10022b:	c3                   	retq   
    if (s < d && s + n > d) {
  10022c:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  100230:	48 39 cf             	cmp    %rcx,%rdi
  100233:	73 da                	jae    10020f <memmove+0x8>
        while (n-- > 0) {
  100235:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  100239:	48 85 d2             	test   %rdx,%rdx
  10023c:	74 ec                	je     10022a <memmove+0x23>
            *--d = *--s;
  10023e:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  100242:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  100245:	48 83 e9 01          	sub    $0x1,%rcx
  100249:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  10024d:	75 ef                	jne    10023e <memmove+0x37>
  10024f:	c3                   	retq   

0000000000100250 <memset>:
void* memset(void* v, int c, size_t n) {
  100250:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100253:	48 85 d2             	test   %rdx,%rdx
  100256:	74 13                	je     10026b <memset+0x1b>
  100258:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  10025c:	48 89 fa             	mov    %rdi,%rdx
        *p = c;
  10025f:	40 88 32             	mov    %sil,(%rdx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100262:	48 83 c2 01          	add    $0x1,%rdx
  100266:	48 39 d1             	cmp    %rdx,%rcx
  100269:	75 f4                	jne    10025f <memset+0xf>
}
  10026b:	c3                   	retq   

000000000010026c <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  10026c:	80 3f 00             	cmpb   $0x0,(%rdi)
  10026f:	74 10                	je     100281 <strlen+0x15>
  100271:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  100276:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  10027a:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  10027e:	75 f6                	jne    100276 <strlen+0xa>
  100280:	c3                   	retq   
  100281:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100286:	c3                   	retq   

0000000000100287 <strnlen>:
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  100287:	b8 00 00 00 00       	mov    $0x0,%eax
  10028c:	48 85 f6             	test   %rsi,%rsi
  10028f:	74 10                	je     1002a1 <strnlen+0x1a>
  100291:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  100295:	74 09                	je     1002a0 <strnlen+0x19>
        ++n;
  100297:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10029b:	48 39 c6             	cmp    %rax,%rsi
  10029e:	75 f1                	jne    100291 <strnlen+0xa>
}
  1002a0:	c3                   	retq   
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1002a1:	48 89 f0             	mov    %rsi,%rax
  1002a4:	c3                   	retq   

00000000001002a5 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1002a5:	48 89 f8             	mov    %rdi,%rax
  1002a8:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1002ad:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1002b1:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1002b4:	48 83 c2 01          	add    $0x1,%rdx
  1002b8:	84 c9                	test   %cl,%cl
  1002ba:	75 f1                	jne    1002ad <strcpy+0x8>
}
  1002bc:	c3                   	retq   

00000000001002bd <strcmp>:
    while (*a && *b && *a == *b) {
  1002bd:	0f b6 17             	movzbl (%rdi),%edx
  1002c0:	84 d2                	test   %dl,%dl
  1002c2:	74 1a                	je     1002de <strcmp+0x21>
  1002c4:	0f b6 06             	movzbl (%rsi),%eax
  1002c7:	38 d0                	cmp    %dl,%al
  1002c9:	75 13                	jne    1002de <strcmp+0x21>
  1002cb:	84 c0                	test   %al,%al
  1002cd:	74 0f                	je     1002de <strcmp+0x21>
        ++a, ++b;
  1002cf:	48 83 c7 01          	add    $0x1,%rdi
  1002d3:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1002d7:	0f b6 17             	movzbl (%rdi),%edx
  1002da:	84 d2                	test   %dl,%dl
  1002dc:	75 e6                	jne    1002c4 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  1002de:	0f b6 0e             	movzbl (%rsi),%ecx
  1002e1:	38 ca                	cmp    %cl,%dl
  1002e3:	0f 97 c0             	seta   %al
  1002e6:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1002e9:	83 d8 00             	sbb    $0x0,%eax
}
  1002ec:	c3                   	retq   

00000000001002ed <strchr>:
    while (*s && *s != (char) c) {
  1002ed:	0f b6 07             	movzbl (%rdi),%eax
  1002f0:	84 c0                	test   %al,%al
  1002f2:	74 10                	je     100304 <strchr+0x17>
  1002f4:	40 38 f0             	cmp    %sil,%al
  1002f7:	74 18                	je     100311 <strchr+0x24>
        ++s;
  1002f9:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  1002fd:	0f b6 07             	movzbl (%rdi),%eax
  100300:	84 c0                	test   %al,%al
  100302:	75 f0                	jne    1002f4 <strchr+0x7>
        return NULL;
  100304:	40 84 f6             	test   %sil,%sil
  100307:	b8 00 00 00 00       	mov    $0x0,%eax
  10030c:	48 0f 44 c7          	cmove  %rdi,%rax
}
  100310:	c3                   	retq   
  100311:	48 89 f8             	mov    %rdi,%rax
  100314:	c3                   	retq   

0000000000100315 <rand>:
    if (!rand_seed_set) {
  100315:	83 3d e8 0c 00 00 00 	cmpl   $0x0,0xce8(%rip)        # 101004 <rand_seed_set>
  10031c:	74 1b                	je     100339 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  10031e:	69 05 d8 0c 00 00 0d 	imul   $0x19660d,0xcd8(%rip),%eax        # 101000 <rand_seed>
  100325:	66 19 00 
  100328:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  10032d:	89 05 cd 0c 00 00    	mov    %eax,0xccd(%rip)        # 101000 <rand_seed>
    return rand_seed & RAND_MAX;
  100333:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100338:	c3                   	retq   
    rand_seed = seed;
  100339:	c7 05 bd 0c 00 00 9e 	movl   $0x30d4879e,0xcbd(%rip)        # 101000 <rand_seed>
  100340:	87 d4 30 
    rand_seed_set = 1;
  100343:	c7 05 b7 0c 00 00 01 	movl   $0x1,0xcb7(%rip)        # 101004 <rand_seed_set>
  10034a:	00 00 00 
}
  10034d:	eb cf                	jmp    10031e <rand+0x9>

000000000010034f <srand>:
    rand_seed = seed;
  10034f:	89 3d ab 0c 00 00    	mov    %edi,0xcab(%rip)        # 101000 <rand_seed>
    rand_seed_set = 1;
  100355:	c7 05 a5 0c 00 00 01 	movl   $0x1,0xca5(%rip)        # 101004 <rand_seed_set>
  10035c:	00 00 00 
}
  10035f:	c3                   	retq   

0000000000100360 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  100360:	55                   	push   %rbp
  100361:	48 89 e5             	mov    %rsp,%rbp
  100364:	41 57                	push   %r15
  100366:	41 56                	push   %r14
  100368:	41 55                	push   %r13
  10036a:	41 54                	push   %r12
  10036c:	53                   	push   %rbx
  10036d:	48 83 ec 58          	sub    $0x58,%rsp
  100371:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  100375:	0f b6 02             	movzbl (%rdx),%eax
  100378:	84 c0                	test   %al,%al
  10037a:	0f 84 ba 06 00 00    	je     100a3a <printer_vprintf+0x6da>
  100380:	49 89 fe             	mov    %rdi,%r14
  100383:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  100386:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%rbp)
  10038d:	41 89 f7             	mov    %esi,%r15d
  100390:	e9 a5 04 00 00       	jmpq   10083a <printer_vprintf+0x4da>
        for (++format; *format; ++format) {
  100395:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  10039a:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1003a0:	45 84 e4             	test   %r12b,%r12b
  1003a3:	0f 84 85 06 00 00    	je     100a2e <printer_vprintf+0x6ce>
        int flags = 0;
  1003a9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1003af:	41 0f be f4          	movsbl %r12b,%esi
  1003b3:	bf 71 0d 10 00       	mov    $0x100d71,%edi
  1003b8:	e8 30 ff ff ff       	callq  1002ed <strchr>
  1003bd:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  1003c0:	48 85 c0             	test   %rax,%rax
  1003c3:	74 55                	je     10041a <printer_vprintf+0xba>
                flags |= 1 << (flagc - flag_chars);
  1003c5:	48 81 e9 71 0d 10 00 	sub    $0x100d71,%rcx
  1003cc:	b8 01 00 00 00       	mov    $0x1,%eax
  1003d1:	d3 e0                	shl    %cl,%eax
  1003d3:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1003d6:	48 83 c3 01          	add    $0x1,%rbx
  1003da:	44 0f b6 23          	movzbl (%rbx),%r12d
  1003de:	45 84 e4             	test   %r12b,%r12b
  1003e1:	75 cc                	jne    1003af <printer_vprintf+0x4f>
  1003e3:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  1003e7:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  1003ed:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  1003f4:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  1003f7:	0f 84 a9 00 00 00    	je     1004a6 <printer_vprintf+0x146>
        int length = 0;
  1003fd:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  100402:	0f b6 13             	movzbl (%rbx),%edx
  100405:	8d 42 bd             	lea    -0x43(%rdx),%eax
  100408:	3c 37                	cmp    $0x37,%al
  10040a:	0f 87 c5 04 00 00    	ja     1008d5 <printer_vprintf+0x575>
  100410:	0f b6 c0             	movzbl %al,%eax
  100413:	ff 24 c5 80 0b 10 00 	jmpq   *0x100b80(,%rax,8)
  10041a:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        if (*format >= '1' && *format <= '9') {
  10041e:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  100423:	3c 08                	cmp    $0x8,%al
  100425:	77 2f                	ja     100456 <printer_vprintf+0xf6>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100427:	0f b6 03             	movzbl (%rbx),%eax
  10042a:	8d 50 d0             	lea    -0x30(%rax),%edx
  10042d:	80 fa 09             	cmp    $0x9,%dl
  100430:	77 5e                	ja     100490 <printer_vprintf+0x130>
  100432:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  100438:	48 83 c3 01          	add    $0x1,%rbx
  10043c:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  100441:	0f be c0             	movsbl %al,%eax
  100444:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100449:	0f b6 03             	movzbl (%rbx),%eax
  10044c:	8d 50 d0             	lea    -0x30(%rax),%edx
  10044f:	80 fa 09             	cmp    $0x9,%dl
  100452:	76 e4                	jbe    100438 <printer_vprintf+0xd8>
  100454:	eb 97                	jmp    1003ed <printer_vprintf+0x8d>
        } else if (*format == '*') {
  100456:	41 80 fc 2a          	cmp    $0x2a,%r12b
  10045a:	75 3f                	jne    10049b <printer_vprintf+0x13b>
            width = va_arg(val, int);
  10045c:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100460:	8b 01                	mov    (%rcx),%eax
  100462:	83 f8 2f             	cmp    $0x2f,%eax
  100465:	77 17                	ja     10047e <printer_vprintf+0x11e>
  100467:	89 c2                	mov    %eax,%edx
  100469:	48 03 51 10          	add    0x10(%rcx),%rdx
  10046d:	83 c0 08             	add    $0x8,%eax
  100470:	89 01                	mov    %eax,(%rcx)
  100472:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  100475:	48 83 c3 01          	add    $0x1,%rbx
  100479:	e9 6f ff ff ff       	jmpq   1003ed <printer_vprintf+0x8d>
            width = va_arg(val, int);
  10047e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100482:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100486:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10048a:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10048e:	eb e2                	jmp    100472 <printer_vprintf+0x112>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100490:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  100496:	e9 52 ff ff ff       	jmpq   1003ed <printer_vprintf+0x8d>
        int width = -1;
  10049b:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1004a1:	e9 47 ff ff ff       	jmpq   1003ed <printer_vprintf+0x8d>
            ++format;
  1004a6:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1004aa:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1004ae:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1004b1:	80 f9 09             	cmp    $0x9,%cl
  1004b4:	76 13                	jbe    1004c9 <printer_vprintf+0x169>
            } else if (*format == '*') {
  1004b6:	3c 2a                	cmp    $0x2a,%al
  1004b8:	74 32                	je     1004ec <printer_vprintf+0x18c>
            ++format;
  1004ba:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  1004bd:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  1004c4:	e9 34 ff ff ff       	jmpq   1003fd <printer_vprintf+0x9d>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1004c9:	be 00 00 00 00       	mov    $0x0,%esi
                    precision = 10 * precision + *format++ - '0';
  1004ce:	48 83 c2 01          	add    $0x1,%rdx
  1004d2:	8d 0c b6             	lea    (%rsi,%rsi,4),%ecx
  1004d5:	0f be c0             	movsbl %al,%eax
  1004d8:	8d 74 48 d0          	lea    -0x30(%rax,%rcx,2),%esi
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1004dc:	0f b6 02             	movzbl (%rdx),%eax
  1004df:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1004e2:	80 f9 09             	cmp    $0x9,%cl
  1004e5:	76 e7                	jbe    1004ce <printer_vprintf+0x16e>
                    precision = 10 * precision + *format++ - '0';
  1004e7:	48 89 d3             	mov    %rdx,%rbx
  1004ea:	eb 1c                	jmp    100508 <printer_vprintf+0x1a8>
                precision = va_arg(val, int);
  1004ec:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004f0:	8b 07                	mov    (%rdi),%eax
  1004f2:	83 f8 2f             	cmp    $0x2f,%eax
  1004f5:	77 23                	ja     10051a <printer_vprintf+0x1ba>
  1004f7:	89 c2                	mov    %eax,%edx
  1004f9:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004fd:	83 c0 08             	add    $0x8,%eax
  100500:	89 07                	mov    %eax,(%rdi)
  100502:	8b 32                	mov    (%rdx),%esi
                ++format;
  100504:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  100508:	85 f6                	test   %esi,%esi
  10050a:	b8 00 00 00 00       	mov    $0x0,%eax
  10050f:	0f 48 f0             	cmovs  %eax,%esi
  100512:	89 75 9c             	mov    %esi,-0x64(%rbp)
  100515:	e9 e3 fe ff ff       	jmpq   1003fd <printer_vprintf+0x9d>
                precision = va_arg(val, int);
  10051a:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10051e:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100522:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100526:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10052a:	eb d6                	jmp    100502 <printer_vprintf+0x1a2>
        switch (*format) {
  10052c:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100531:	e9 f1 00 00 00       	jmpq   100627 <printer_vprintf+0x2c7>
            ++format;
  100536:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  10053a:	8b 4d 80             	mov    -0x80(%rbp),%ecx
            goto again;
  10053d:	e9 c0 fe ff ff       	jmpq   100402 <printer_vprintf+0xa2>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100542:	85 c9                	test   %ecx,%ecx
  100544:	74 55                	je     10059b <printer_vprintf+0x23b>
  100546:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10054a:	8b 01                	mov    (%rcx),%eax
  10054c:	83 f8 2f             	cmp    $0x2f,%eax
  10054f:	77 38                	ja     100589 <printer_vprintf+0x229>
  100551:	89 c2                	mov    %eax,%edx
  100553:	48 03 51 10          	add    0x10(%rcx),%rdx
  100557:	83 c0 08             	add    $0x8,%eax
  10055a:	89 01                	mov    %eax,(%rcx)
  10055c:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  10055f:	48 89 d0             	mov    %rdx,%rax
  100562:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  100566:	49 89 d0             	mov    %rdx,%r8
  100569:	49 f7 d8             	neg    %r8
  10056c:	25 80 00 00 00       	and    $0x80,%eax
  100571:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  100575:	0b 45 a8             	or     -0x58(%rbp),%eax
  100578:	83 c8 60             	or     $0x60,%eax
  10057b:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  10057e:	41 bc 71 0b 10 00    	mov    $0x100b71,%r12d
            break;
  100584:	e9 35 01 00 00       	jmpq   1006be <printer_vprintf+0x35e>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100589:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10058d:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100591:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100595:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100599:	eb c1                	jmp    10055c <printer_vprintf+0x1fc>
  10059b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10059f:	8b 07                	mov    (%rdi),%eax
  1005a1:	83 f8 2f             	cmp    $0x2f,%eax
  1005a4:	77 10                	ja     1005b6 <printer_vprintf+0x256>
  1005a6:	89 c2                	mov    %eax,%edx
  1005a8:	48 03 57 10          	add    0x10(%rdi),%rdx
  1005ac:	83 c0 08             	add    $0x8,%eax
  1005af:	89 07                	mov    %eax,(%rdi)
  1005b1:	48 63 12             	movslq (%rdx),%rdx
  1005b4:	eb a9                	jmp    10055f <printer_vprintf+0x1ff>
  1005b6:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005ba:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005be:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005c2:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005c6:	eb e9                	jmp    1005b1 <printer_vprintf+0x251>
        int base = 10;
  1005c8:	be 0a 00 00 00       	mov    $0xa,%esi
  1005cd:	eb 58                	jmp    100627 <printer_vprintf+0x2c7>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1005cf:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005d3:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005d7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005db:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005df:	eb 60                	jmp    100641 <printer_vprintf+0x2e1>
  1005e1:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005e5:	8b 01                	mov    (%rcx),%eax
  1005e7:	83 f8 2f             	cmp    $0x2f,%eax
  1005ea:	77 10                	ja     1005fc <printer_vprintf+0x29c>
  1005ec:	89 c2                	mov    %eax,%edx
  1005ee:	48 03 51 10          	add    0x10(%rcx),%rdx
  1005f2:	83 c0 08             	add    $0x8,%eax
  1005f5:	89 01                	mov    %eax,(%rcx)
  1005f7:	44 8b 02             	mov    (%rdx),%r8d
  1005fa:	eb 48                	jmp    100644 <printer_vprintf+0x2e4>
  1005fc:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100600:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100604:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100608:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10060c:	eb e9                	jmp    1005f7 <printer_vprintf+0x297>
  10060e:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  100611:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  100618:	bf 60 0d 10 00       	mov    $0x100d60,%edi
  10061d:	e9 e6 02 00 00       	jmpq   100908 <printer_vprintf+0x5a8>
            base = 16;
  100622:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100627:	85 c9                	test   %ecx,%ecx
  100629:	74 b6                	je     1005e1 <printer_vprintf+0x281>
  10062b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10062f:	8b 07                	mov    (%rdi),%eax
  100631:	83 f8 2f             	cmp    $0x2f,%eax
  100634:	77 99                	ja     1005cf <printer_vprintf+0x26f>
  100636:	89 c2                	mov    %eax,%edx
  100638:	48 03 57 10          	add    0x10(%rdi),%rdx
  10063c:	83 c0 08             	add    $0x8,%eax
  10063f:	89 07                	mov    %eax,(%rdi)
  100641:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  100644:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  100648:	85 f6                	test   %esi,%esi
  10064a:	79 c2                	jns    10060e <printer_vprintf+0x2ae>
        base = -base;
  10064c:	41 89 f1             	mov    %esi,%r9d
  10064f:	f7 de                	neg    %esi
  100651:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  100658:	bf 40 0d 10 00       	mov    $0x100d40,%edi
  10065d:	e9 a6 02 00 00       	jmpq   100908 <printer_vprintf+0x5a8>
            num = (uintptr_t) va_arg(val, void*);
  100662:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100666:	8b 07                	mov    (%rdi),%eax
  100668:	83 f8 2f             	cmp    $0x2f,%eax
  10066b:	77 1c                	ja     100689 <printer_vprintf+0x329>
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	48 03 57 10          	add    0x10(%rdi),%rdx
  100673:	83 c0 08             	add    $0x8,%eax
  100676:	89 07                	mov    %eax,(%rdi)
  100678:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  10067b:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  100682:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100687:	eb c3                	jmp    10064c <printer_vprintf+0x2ec>
            num = (uintptr_t) va_arg(val, void*);
  100689:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10068d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100691:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100695:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100699:	eb dd                	jmp    100678 <printer_vprintf+0x318>
            data = va_arg(val, char*);
  10069b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10069f:	8b 01                	mov    (%rcx),%eax
  1006a1:	83 f8 2f             	cmp    $0x2f,%eax
  1006a4:	0f 87 a9 01 00 00    	ja     100853 <printer_vprintf+0x4f3>
  1006aa:	89 c2                	mov    %eax,%edx
  1006ac:	48 03 51 10          	add    0x10(%rcx),%rdx
  1006b0:	83 c0 08             	add    $0x8,%eax
  1006b3:	89 01                	mov    %eax,(%rcx)
  1006b5:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1006b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  1006be:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006c1:	83 e0 20             	and    $0x20,%eax
  1006c4:	89 45 8c             	mov    %eax,-0x74(%rbp)
  1006c7:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  1006cd:	0f 85 25 02 00 00    	jne    1008f8 <printer_vprintf+0x598>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1006d3:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006d6:	89 45 88             	mov    %eax,-0x78(%rbp)
  1006d9:	83 e0 60             	and    $0x60,%eax
  1006dc:	83 f8 60             	cmp    $0x60,%eax
  1006df:	0f 84 58 02 00 00    	je     10093d <printer_vprintf+0x5dd>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1006e5:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006e8:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  1006eb:	48 c7 45 a0 71 0b 10 	movq   $0x100b71,-0x60(%rbp)
  1006f2:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1006f3:	83 f8 21             	cmp    $0x21,%eax
  1006f6:	0f 84 7d 02 00 00    	je     100979 <printer_vprintf+0x619>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1006fc:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  1006ff:	89 c8                	mov    %ecx,%eax
  100701:	f7 d0                	not    %eax
  100703:	c1 e8 1f             	shr    $0x1f,%eax
  100706:	89 45 84             	mov    %eax,-0x7c(%rbp)
  100709:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  10070d:	0f 85 a2 02 00 00    	jne    1009b5 <printer_vprintf+0x655>
  100713:	84 c0                	test   %al,%al
  100715:	0f 84 9a 02 00 00    	je     1009b5 <printer_vprintf+0x655>
            len = strnlen(data, precision);
  10071b:	48 63 f1             	movslq %ecx,%rsi
  10071e:	4c 89 e7             	mov    %r12,%rdi
  100721:	e8 61 fb ff ff       	callq  100287 <strnlen>
  100726:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  100729:	8b 45 88             	mov    -0x78(%rbp),%eax
  10072c:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  10072f:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100736:	83 f8 22             	cmp    $0x22,%eax
  100739:	0f 84 ae 02 00 00    	je     1009ed <printer_vprintf+0x68d>
        width -= len + zeros + strlen(prefix);
  10073f:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100743:	e8 24 fb ff ff       	callq  10026c <strlen>
  100748:	8b 55 9c             	mov    -0x64(%rbp),%edx
  10074b:	03 55 98             	add    -0x68(%rbp),%edx
  10074e:	41 29 d5             	sub    %edx,%r13d
  100751:	44 89 ea             	mov    %r13d,%edx
  100754:	29 c2                	sub    %eax,%edx
  100756:	89 55 8c             	mov    %edx,-0x74(%rbp)
  100759:	41 89 d5             	mov    %edx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  10075c:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  100760:	75 2d                	jne    10078f <printer_vprintf+0x42f>
  100762:	85 d2                	test   %edx,%edx
  100764:	7e 29                	jle    10078f <printer_vprintf+0x42f>
            p->putc(p, ' ', color);
  100766:	44 89 fa             	mov    %r15d,%edx
  100769:	be 20 00 00 00       	mov    $0x20,%esi
  10076e:	4c 89 f7             	mov    %r14,%rdi
  100771:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100774:	41 83 ed 01          	sub    $0x1,%r13d
  100778:	45 85 ed             	test   %r13d,%r13d
  10077b:	7f e9                	jg     100766 <printer_vprintf+0x406>
  10077d:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  100780:	85 ff                	test   %edi,%edi
  100782:	b8 01 00 00 00       	mov    $0x1,%eax
  100787:	0f 4f c7             	cmovg  %edi,%eax
  10078a:	29 c7                	sub    %eax,%edi
  10078c:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  10078f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  100793:	0f b6 01             	movzbl (%rcx),%eax
  100796:	84 c0                	test   %al,%al
  100798:	74 22                	je     1007bc <printer_vprintf+0x45c>
  10079a:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  10079e:	48 89 cb             	mov    %rcx,%rbx
            p->putc(p, *prefix, color);
  1007a1:	0f b6 f0             	movzbl %al,%esi
  1007a4:	44 89 fa             	mov    %r15d,%edx
  1007a7:	4c 89 f7             	mov    %r14,%rdi
  1007aa:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1007ad:	48 83 c3 01          	add    $0x1,%rbx
  1007b1:	0f b6 03             	movzbl (%rbx),%eax
  1007b4:	84 c0                	test   %al,%al
  1007b6:	75 e9                	jne    1007a1 <printer_vprintf+0x441>
  1007b8:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  1007bc:	8b 45 9c             	mov    -0x64(%rbp),%eax
  1007bf:	85 c0                	test   %eax,%eax
  1007c1:	7e 1d                	jle    1007e0 <printer_vprintf+0x480>
  1007c3:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1007c7:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  1007c9:	44 89 fa             	mov    %r15d,%edx
  1007cc:	be 30 00 00 00       	mov    $0x30,%esi
  1007d1:	4c 89 f7             	mov    %r14,%rdi
  1007d4:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  1007d7:	83 eb 01             	sub    $0x1,%ebx
  1007da:	75 ed                	jne    1007c9 <printer_vprintf+0x469>
  1007dc:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  1007e0:	8b 45 98             	mov    -0x68(%rbp),%eax
  1007e3:	85 c0                	test   %eax,%eax
  1007e5:	7e 2a                	jle    100811 <printer_vprintf+0x4b1>
  1007e7:	8d 40 ff             	lea    -0x1(%rax),%eax
  1007ea:	49 8d 44 04 01       	lea    0x1(%r12,%rax,1),%rax
  1007ef:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1007f3:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  1007f6:	41 0f b6 34 24       	movzbl (%r12),%esi
  1007fb:	44 89 fa             	mov    %r15d,%edx
  1007fe:	4c 89 f7             	mov    %r14,%rdi
  100801:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  100804:	49 83 c4 01          	add    $0x1,%r12
  100808:	49 39 dc             	cmp    %rbx,%r12
  10080b:	75 e9                	jne    1007f6 <printer_vprintf+0x496>
  10080d:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  100811:	45 85 ed             	test   %r13d,%r13d
  100814:	7e 14                	jle    10082a <printer_vprintf+0x4ca>
            p->putc(p, ' ', color);
  100816:	44 89 fa             	mov    %r15d,%edx
  100819:	be 20 00 00 00       	mov    $0x20,%esi
  10081e:	4c 89 f7             	mov    %r14,%rdi
  100821:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  100824:	41 83 ed 01          	sub    $0x1,%r13d
  100828:	75 ec                	jne    100816 <printer_vprintf+0x4b6>
    for (; *format; ++format) {
  10082a:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  10082e:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100832:	84 c0                	test   %al,%al
  100834:	0f 84 00 02 00 00    	je     100a3a <printer_vprintf+0x6da>
        if (*format != '%') {
  10083a:	3c 25                	cmp    $0x25,%al
  10083c:	0f 84 53 fb ff ff    	je     100395 <printer_vprintf+0x35>
            p->putc(p, *format, color);
  100842:	0f b6 f0             	movzbl %al,%esi
  100845:	44 89 fa             	mov    %r15d,%edx
  100848:	4c 89 f7             	mov    %r14,%rdi
  10084b:	41 ff 16             	callq  *(%r14)
            continue;
  10084e:	4c 89 e3             	mov    %r12,%rbx
  100851:	eb d7                	jmp    10082a <printer_vprintf+0x4ca>
            data = va_arg(val, char*);
  100853:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100857:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10085b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10085f:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100863:	e9 4d fe ff ff       	jmpq   1006b5 <printer_vprintf+0x355>
            color = va_arg(val, int);
  100868:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10086c:	8b 07                	mov    (%rdi),%eax
  10086e:	83 f8 2f             	cmp    $0x2f,%eax
  100871:	77 10                	ja     100883 <printer_vprintf+0x523>
  100873:	89 c2                	mov    %eax,%edx
  100875:	48 03 57 10          	add    0x10(%rdi),%rdx
  100879:	83 c0 08             	add    $0x8,%eax
  10087c:	89 07                	mov    %eax,(%rdi)
  10087e:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  100881:	eb a7                	jmp    10082a <printer_vprintf+0x4ca>
            color = va_arg(val, int);
  100883:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100887:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10088b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10088f:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100893:	eb e9                	jmp    10087e <printer_vprintf+0x51e>
            numbuf[0] = va_arg(val, int);
  100895:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100899:	8b 01                	mov    (%rcx),%eax
  10089b:	83 f8 2f             	cmp    $0x2f,%eax
  10089e:	77 23                	ja     1008c3 <printer_vprintf+0x563>
  1008a0:	89 c2                	mov    %eax,%edx
  1008a2:	48 03 51 10          	add    0x10(%rcx),%rdx
  1008a6:	83 c0 08             	add    $0x8,%eax
  1008a9:	89 01                	mov    %eax,(%rcx)
  1008ab:	8b 02                	mov    (%rdx),%eax
  1008ad:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1008b0:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1008b4:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1008b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1008be:	e9 fb fd ff ff       	jmpq   1006be <printer_vprintf+0x35e>
            numbuf[0] = va_arg(val, int);
  1008c3:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1008c7:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1008cb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1008cf:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1008d3:	eb d6                	jmp    1008ab <printer_vprintf+0x54b>
            numbuf[0] = (*format ? *format : '%');
  1008d5:	84 d2                	test   %dl,%dl
  1008d7:	0f 85 3b 01 00 00    	jne    100a18 <printer_vprintf+0x6b8>
  1008dd:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  1008e1:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  1008e5:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  1008e9:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1008ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1008f3:	e9 c6 fd ff ff       	jmpq   1006be <printer_vprintf+0x35e>
        if (flags & FLAG_NUMERIC) {
  1008f8:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1008fe:	bf 60 0d 10 00       	mov    $0x100d60,%edi
        if (flags & FLAG_NUMERIC) {
  100903:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  100908:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  10090c:	4c 89 c1             	mov    %r8,%rcx
  10090f:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  100913:	48 63 f6             	movslq %esi,%rsi
  100916:	49 83 ec 01          	sub    $0x1,%r12
  10091a:	48 89 c8             	mov    %rcx,%rax
  10091d:	ba 00 00 00 00       	mov    $0x0,%edx
  100922:	48 f7 f6             	div    %rsi
  100925:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  100929:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  10092d:	48 89 ca             	mov    %rcx,%rdx
  100930:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  100933:	48 39 d6             	cmp    %rdx,%rsi
  100936:	76 de                	jbe    100916 <printer_vprintf+0x5b6>
  100938:	e9 96 fd ff ff       	jmpq   1006d3 <printer_vprintf+0x373>
                prefix = "-";
  10093d:	48 c7 45 a0 79 0b 10 	movq   $0x100b79,-0x60(%rbp)
  100944:	00 
            if (flags & FLAG_NEGATIVE) {
  100945:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100948:	a8 80                	test   $0x80,%al
  10094a:	0f 85 ac fd ff ff    	jne    1006fc <printer_vprintf+0x39c>
                prefix = "+";
  100950:	48 c7 45 a0 77 0b 10 	movq   $0x100b77,-0x60(%rbp)
  100957:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100958:	a8 10                	test   $0x10,%al
  10095a:	0f 85 9c fd ff ff    	jne    1006fc <printer_vprintf+0x39c>
                prefix = " ";
  100960:	a8 08                	test   $0x8,%al
  100962:	ba 71 0b 10 00       	mov    $0x100b71,%edx
  100967:	b8 75 0b 10 00       	mov    $0x100b75,%eax
  10096c:	48 0f 44 c2          	cmove  %rdx,%rax
  100970:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100974:	e9 83 fd ff ff       	jmpq   1006fc <printer_vprintf+0x39c>
                   && (base == 16 || base == -16)
  100979:	41 8d 41 10          	lea    0x10(%r9),%eax
  10097d:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  100982:	0f 85 74 fd ff ff    	jne    1006fc <printer_vprintf+0x39c>
                   && (num || (flags & FLAG_ALT2))) {
  100988:	4d 85 c0             	test   %r8,%r8
  10098b:	75 0d                	jne    10099a <printer_vprintf+0x63a>
  10098d:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  100994:	0f 84 62 fd ff ff    	je     1006fc <printer_vprintf+0x39c>
            prefix = (base == -16 ? "0x" : "0X");
  10099a:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  10099e:	ba 72 0b 10 00       	mov    $0x100b72,%edx
  1009a3:	b8 7b 0b 10 00       	mov    $0x100b7b,%eax
  1009a8:	48 0f 44 c2          	cmove  %rdx,%rax
  1009ac:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1009b0:	e9 47 fd ff ff       	jmpq   1006fc <printer_vprintf+0x39c>
            len = strlen(data);
  1009b5:	4c 89 e7             	mov    %r12,%rdi
  1009b8:	e8 af f8 ff ff       	callq  10026c <strlen>
  1009bd:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1009c0:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1009c4:	0f 84 5f fd ff ff    	je     100729 <printer_vprintf+0x3c9>
  1009ca:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  1009ce:	0f 84 55 fd ff ff    	je     100729 <printer_vprintf+0x3c9>
            zeros = precision > len ? precision - len : 0;
  1009d4:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1009d7:	89 fa                	mov    %edi,%edx
  1009d9:	29 c2                	sub    %eax,%edx
  1009db:	39 c7                	cmp    %eax,%edi
  1009dd:	b8 00 00 00 00       	mov    $0x0,%eax
  1009e2:	0f 4e d0             	cmovle %eax,%edx
  1009e5:	89 55 9c             	mov    %edx,-0x64(%rbp)
  1009e8:	e9 52 fd ff ff       	jmpq   10073f <printer_vprintf+0x3df>
                   && len + (int) strlen(prefix) < width) {
  1009ed:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1009f1:	e8 76 f8 ff ff       	callq  10026c <strlen>
  1009f6:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1009f9:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1009fc:	44 89 e9             	mov    %r13d,%ecx
  1009ff:	29 f9                	sub    %edi,%ecx
  100a01:	29 c1                	sub    %eax,%ecx
  100a03:	89 c8                	mov    %ecx,%eax
  100a05:	44 39 ea             	cmp    %r13d,%edx
  100a08:	b9 00 00 00 00       	mov    $0x0,%ecx
  100a0d:	0f 4d c1             	cmovge %ecx,%eax
  100a10:	89 45 9c             	mov    %eax,-0x64(%rbp)
  100a13:	e9 27 fd ff ff       	jmpq   10073f <printer_vprintf+0x3df>
            numbuf[0] = (*format ? *format : '%');
  100a18:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  100a1b:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100a1f:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100a23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100a29:	e9 90 fc ff ff       	jmpq   1006be <printer_vprintf+0x35e>
        int flags = 0;
  100a2e:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  100a35:	e9 ad f9 ff ff       	jmpq   1003e7 <printer_vprintf+0x87>
}
  100a3a:	48 83 c4 58          	add    $0x58,%rsp
  100a3e:	5b                   	pop    %rbx
  100a3f:	41 5c                	pop    %r12
  100a41:	41 5d                	pop    %r13
  100a43:	41 5e                	pop    %r14
  100a45:	41 5f                	pop    %r15
  100a47:	5d                   	pop    %rbp
  100a48:	c3                   	retq   

0000000000100a49 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100a49:	55                   	push   %rbp
  100a4a:	48 89 e5             	mov    %rsp,%rbp
  100a4d:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  100a51:	48 c7 45 f0 47 01 10 	movq   $0x100147,-0x10(%rbp)
  100a58:	00 
        cpos = 0;
  100a59:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  100a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  100a64:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  100a67:	48 63 ff             	movslq %edi,%rdi
  100a6a:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  100a71:	00 
  100a72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100a76:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  100a7a:	e8 e1 f8 ff ff       	callq  100360 <printer_vprintf>
    return cp.cursor - console;
  100a7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100a83:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  100a89:	48 d1 f8             	sar    %rax
}
  100a8c:	c9                   	leaveq 
  100a8d:	c3                   	retq   

0000000000100a8e <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  100a8e:	55                   	push   %rbp
  100a8f:	48 89 e5             	mov    %rsp,%rbp
  100a92:	48 83 ec 50          	sub    $0x50,%rsp
  100a96:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100a9a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100a9e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  100aa2:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100aa9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100aad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100ab1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100ab5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100ab9:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100abd:	e8 87 ff ff ff       	callq  100a49 <console_vprintf>
}
  100ac2:	c9                   	leaveq 
  100ac3:	c3                   	retq   

0000000000100ac4 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100ac4:	55                   	push   %rbp
  100ac5:	48 89 e5             	mov    %rsp,%rbp
  100ac8:	53                   	push   %rbx
  100ac9:	48 83 ec 28          	sub    $0x28,%rsp
  100acd:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100ad0:	48 c7 45 d8 d1 01 10 	movq   $0x1001d1,-0x28(%rbp)
  100ad7:	00 
    sp.s = s;
  100ad8:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100adc:	48 85 f6             	test   %rsi,%rsi
  100adf:	75 0e                	jne    100aef <vsnprintf+0x2b>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100ae1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100ae5:	48 29 d8             	sub    %rbx,%rax
}
  100ae8:	48 83 c4 28          	add    $0x28,%rsp
  100aec:	5b                   	pop    %rbx
  100aed:	5d                   	pop    %rbp
  100aee:	c3                   	retq   
        sp.end = s + size - 1;
  100aef:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100af4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100af8:	be 00 00 00 00       	mov    $0x0,%esi
  100afd:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100b01:	e8 5a f8 ff ff       	callq  100360 <printer_vprintf>
        *sp.s = 0;
  100b06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100b0a:	c6 00 00             	movb   $0x0,(%rax)
  100b0d:	eb d2                	jmp    100ae1 <vsnprintf+0x1d>

0000000000100b0f <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100b0f:	55                   	push   %rbp
  100b10:	48 89 e5             	mov    %rsp,%rbp
  100b13:	48 83 ec 50          	sub    $0x50,%rsp
  100b17:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100b1b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100b1f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100b23:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100b2a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100b2e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100b32:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100b36:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100b3a:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100b3e:	e8 81 ff ff ff       	callq  100ac4 <vsnprintf>
    va_end(val);
    return n;
}
  100b43:	c9                   	leaveq 
  100b44:	c3                   	retq   

0000000000100b45 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b45:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100b4a:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  100b4f:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b54:	48 83 c0 02          	add    $0x2,%rax
  100b58:	48 39 d0             	cmp    %rdx,%rax
  100b5b:	75 f2                	jne    100b4f <console_clear+0xa>
    }
    cursorpos = 0;
  100b5d:	c7 05 95 84 fb ff 00 	movl   $0x0,-0x47b6b(%rip)        # b8ffc <cursorpos>
  100b64:	00 00 00 
}
  100b67:	c3                   	retq   
