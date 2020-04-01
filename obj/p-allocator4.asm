
obj/p-allocator4.full:     file format elf64-x86-64


Disassembly of section .text:

00000000001c0000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  1c0000:	55                   	push   %rbp
  1c0001:	48 89 e5             	mov    %rsp,%rbp
  1c0004:	53                   	push   %rbx
  1c0005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  1c0009:	cd 31                	int    $0x31
  1c000b:	89 c7                	mov    %eax,%edi
  1c000d:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  1c000f:	e8 86 02 00 00       	callq  1c029a <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  1c0014:	b8 17 20 1c 00       	mov    $0x1c2017,%eax
  1c0019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1c001f:	48 89 05 e2 0f 00 00 	mov    %rax,0xfe2(%rip)        # 1c1008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  1c0026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  1c0029:	48 83 e8 01          	sub    $0x1,%rax
  1c002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1c0033:	48 89 05 d6 0f 00 00 	mov    %rax,0xfd6(%rip)        # 1c1010 <stack_bottom>
  1c003a:	eb 02                	jmp    1c003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  1c003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  1c003e:	e8 1d 02 00 00       	callq  1c0260 <rand>
  1c0043:	89 c2                	mov    %eax,%edx
  1c0045:	48 98                	cltq   
  1c0047:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
  1c004e:	48 c1 f8 25          	sar    $0x25,%rax
  1c0052:	89 d1                	mov    %edx,%ecx
  1c0054:	c1 f9 1f             	sar    $0x1f,%ecx
  1c0057:	29 c8                	sub    %ecx,%eax
  1c0059:	6b c0 64             	imul   $0x64,%eax,%eax
  1c005c:	29 c2                	sub    %eax,%edx
  1c005e:	39 da                	cmp    %ebx,%edx
  1c0060:	7d da                	jge    1c003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1c0062:	48 8b 3d 9f 0f 00 00 	mov    0xf9f(%rip),%rdi        # 1c1008 <heap_top>
  1c0069:	48 3b 3d a0 0f 00 00 	cmp    0xfa0(%rip),%rdi        # 1c1010 <stack_bottom>
  1c0070:	74 1c                	je     1c008e <process_main+0x8e>
//    Allocate a page of memory at address `addr`. `Addr` must be page-aligned
//    (i.e., a multiple of PAGESIZE == 4096). Returns 0 on success and -1
//    on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  1c0072:	cd 33                	int    $0x33
  1c0074:	85 c0                	test   %eax,%eax
  1c0076:	78 16                	js     1c008e <process_main+0x8e>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  1c0078:	48 8b 05 89 0f 00 00 	mov    0xf89(%rip),%rax        # 1c1008 <heap_top>
  1c007f:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  1c0081:	48 81 05 7c 0f 00 00 	addq   $0x1000,0xf7c(%rip)        # 1c1008 <heap_top>
  1c0088:	00 10 00 00 
  1c008c:	eb ae                	jmp    1c003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  1c008e:	cd 32                	int    $0x32
  1c0090:	eb fc                	jmp    1c008e <process_main+0x8e>

00000000001c0092 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  1c0092:	41 89 d0             	mov    %edx,%r8d
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1c0095:	48 81 7f 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rdi)
  1c009c:	00 
  1c009d:	72 08                	jb     1c00a7 <console_putc+0x15>
        cp->cursor = console;
  1c009f:	48 c7 47 08 00 80 0b 	movq   $0xb8000,0x8(%rdi)
  1c00a6:	00 
    }
    if (c == '\n') {
  1c00a7:	40 80 fe 0a          	cmp    $0xa,%sil
  1c00ab:	74 17                	je     1c00c4 <console_putc+0x32>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1c00ad:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1c00b1:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1c00b5:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1c00b9:	40 0f b6 f6          	movzbl %sil,%esi
  1c00bd:	44 09 c6             	or     %r8d,%esi
  1c00c0:	66 89 30             	mov    %si,(%rax)
    }
}
  1c00c3:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1c00c4:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  1c00c8:	48 81 ee 00 80 0b 00 	sub    $0xb8000,%rsi
  1c00cf:	48 89 f1             	mov    %rsi,%rcx
  1c00d2:	48 d1 f9             	sar    %rcx
  1c00d5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1c00dc:	66 66 66 
  1c00df:	48 89 c8             	mov    %rcx,%rax
  1c00e2:	48 f7 ea             	imul   %rdx
  1c00e5:	48 c1 fa 05          	sar    $0x5,%rdx
  1c00e9:	48 c1 fe 3f          	sar    $0x3f,%rsi
  1c00ed:	48 29 f2             	sub    %rsi,%rdx
  1c00f0:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  1c00f4:	48 c1 e0 04          	shl    $0x4,%rax
  1c00f8:	89 ca                	mov    %ecx,%edx
  1c00fa:	29 c2                	sub    %eax,%edx
  1c00fc:	89 d0                	mov    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1c00fe:	44 89 c6             	mov    %r8d,%esi
  1c0101:	83 ce 20             	or     $0x20,%esi
  1c0104:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  1c0108:	4c 8d 41 02          	lea    0x2(%rcx),%r8
  1c010c:	4c 89 47 08          	mov    %r8,0x8(%rdi)
  1c0110:	66 89 31             	mov    %si,(%rcx)
        for (; pos != 80; pos++) {
  1c0113:	83 c0 01             	add    $0x1,%eax
  1c0116:	83 f8 50             	cmp    $0x50,%eax
  1c0119:	75 e9                	jne    1c0104 <console_putc+0x72>
  1c011b:	c3                   	retq   

00000000001c011c <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1c011c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1c0120:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1c0124:	73 0b                	jae    1c0131 <string_putc+0x15>
        *sp->s++ = c;
  1c0126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1c012a:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1c012e:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1c0131:	c3                   	retq   

00000000001c0132 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1c0132:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c0135:	48 85 d2             	test   %rdx,%rdx
  1c0138:	74 17                	je     1c0151 <memcpy+0x1f>
  1c013a:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1c013f:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1c0144:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c0148:	48 83 c1 01          	add    $0x1,%rcx
  1c014c:	48 39 d1             	cmp    %rdx,%rcx
  1c014f:	75 ee                	jne    1c013f <memcpy+0xd>
}
  1c0151:	c3                   	retq   

00000000001c0152 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  1c0152:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  1c0155:	48 39 fe             	cmp    %rdi,%rsi
  1c0158:	72 1d                	jb     1c0177 <memmove+0x25>
        while (n-- > 0) {
  1c015a:	b9 00 00 00 00       	mov    $0x0,%ecx
  1c015f:	48 85 d2             	test   %rdx,%rdx
  1c0162:	74 12                	je     1c0176 <memmove+0x24>
            *d++ = *s++;
  1c0164:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  1c0168:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  1c016c:	48 83 c1 01          	add    $0x1,%rcx
  1c0170:	48 39 ca             	cmp    %rcx,%rdx
  1c0173:	75 ef                	jne    1c0164 <memmove+0x12>
}
  1c0175:	c3                   	retq   
  1c0176:	c3                   	retq   
    if (s < d && s + n > d) {
  1c0177:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  1c017b:	48 39 cf             	cmp    %rcx,%rdi
  1c017e:	73 da                	jae    1c015a <memmove+0x8>
        while (n-- > 0) {
  1c0180:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  1c0184:	48 85 d2             	test   %rdx,%rdx
  1c0187:	74 ec                	je     1c0175 <memmove+0x23>
            *--d = *--s;
  1c0189:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  1c018d:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  1c0190:	48 83 e9 01          	sub    $0x1,%rcx
  1c0194:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  1c0198:	75 ef                	jne    1c0189 <memmove+0x37>
  1c019a:	c3                   	retq   

00000000001c019b <memset>:
void* memset(void* v, int c, size_t n) {
  1c019b:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c019e:	48 85 d2             	test   %rdx,%rdx
  1c01a1:	74 13                	je     1c01b6 <memset+0x1b>
  1c01a3:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  1c01a7:	48 89 fa             	mov    %rdi,%rdx
        *p = c;
  1c01aa:	40 88 32             	mov    %sil,(%rdx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c01ad:	48 83 c2 01          	add    $0x1,%rdx
  1c01b1:	48 39 d1             	cmp    %rdx,%rcx
  1c01b4:	75 f4                	jne    1c01aa <memset+0xf>
}
  1c01b6:	c3                   	retq   

00000000001c01b7 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1c01b7:	80 3f 00             	cmpb   $0x0,(%rdi)
  1c01ba:	74 10                	je     1c01cc <strlen+0x15>
  1c01bc:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1c01c1:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1c01c5:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1c01c9:	75 f6                	jne    1c01c1 <strlen+0xa>
  1c01cb:	c3                   	retq   
  1c01cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1c01d1:	c3                   	retq   

00000000001c01d2 <strnlen>:
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c01d2:	b8 00 00 00 00       	mov    $0x0,%eax
  1c01d7:	48 85 f6             	test   %rsi,%rsi
  1c01da:	74 10                	je     1c01ec <strnlen+0x1a>
  1c01dc:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1c01e0:	74 09                	je     1c01eb <strnlen+0x19>
        ++n;
  1c01e2:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c01e6:	48 39 c6             	cmp    %rax,%rsi
  1c01e9:	75 f1                	jne    1c01dc <strnlen+0xa>
}
  1c01eb:	c3                   	retq   
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c01ec:	48 89 f0             	mov    %rsi,%rax
  1c01ef:	c3                   	retq   

00000000001c01f0 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1c01f0:	48 89 f8             	mov    %rdi,%rax
  1c01f3:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1c01f8:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1c01fc:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1c01ff:	48 83 c2 01          	add    $0x1,%rdx
  1c0203:	84 c9                	test   %cl,%cl
  1c0205:	75 f1                	jne    1c01f8 <strcpy+0x8>
}
  1c0207:	c3                   	retq   

00000000001c0208 <strcmp>:
    while (*a && *b && *a == *b) {
  1c0208:	0f b6 17             	movzbl (%rdi),%edx
  1c020b:	84 d2                	test   %dl,%dl
  1c020d:	74 1a                	je     1c0229 <strcmp+0x21>
  1c020f:	0f b6 06             	movzbl (%rsi),%eax
  1c0212:	38 d0                	cmp    %dl,%al
  1c0214:	75 13                	jne    1c0229 <strcmp+0x21>
  1c0216:	84 c0                	test   %al,%al
  1c0218:	74 0f                	je     1c0229 <strcmp+0x21>
        ++a, ++b;
  1c021a:	48 83 c7 01          	add    $0x1,%rdi
  1c021e:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1c0222:	0f b6 17             	movzbl (%rdi),%edx
  1c0225:	84 d2                	test   %dl,%dl
  1c0227:	75 e6                	jne    1c020f <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  1c0229:	0f b6 0e             	movzbl (%rsi),%ecx
  1c022c:	38 ca                	cmp    %cl,%dl
  1c022e:	0f 97 c0             	seta   %al
  1c0231:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1c0234:	83 d8 00             	sbb    $0x0,%eax
}
  1c0237:	c3                   	retq   

00000000001c0238 <strchr>:
    while (*s && *s != (char) c) {
  1c0238:	0f b6 07             	movzbl (%rdi),%eax
  1c023b:	84 c0                	test   %al,%al
  1c023d:	74 10                	je     1c024f <strchr+0x17>
  1c023f:	40 38 f0             	cmp    %sil,%al
  1c0242:	74 18                	je     1c025c <strchr+0x24>
        ++s;
  1c0244:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  1c0248:	0f b6 07             	movzbl (%rdi),%eax
  1c024b:	84 c0                	test   %al,%al
  1c024d:	75 f0                	jne    1c023f <strchr+0x7>
        return NULL;
  1c024f:	40 84 f6             	test   %sil,%sil
  1c0252:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0257:	48 0f 44 c7          	cmove  %rdi,%rax
}
  1c025b:	c3                   	retq   
  1c025c:	48 89 f8             	mov    %rdi,%rax
  1c025f:	c3                   	retq   

00000000001c0260 <rand>:
    if (!rand_seed_set) {
  1c0260:	83 3d 9d 0d 00 00 00 	cmpl   $0x0,0xd9d(%rip)        # 1c1004 <rand_seed_set>
  1c0267:	74 1b                	je     1c0284 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1c0269:	69 05 8d 0d 00 00 0d 	imul   $0x19660d,0xd8d(%rip),%eax        # 1c1000 <rand_seed>
  1c0270:	66 19 00 
  1c0273:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1c0278:	89 05 82 0d 00 00    	mov    %eax,0xd82(%rip)        # 1c1000 <rand_seed>
    return rand_seed & RAND_MAX;
  1c027e:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1c0283:	c3                   	retq   
    rand_seed = seed;
  1c0284:	c7 05 72 0d 00 00 9e 	movl   $0x30d4879e,0xd72(%rip)        # 1c1000 <rand_seed>
  1c028b:	87 d4 30 
    rand_seed_set = 1;
  1c028e:	c7 05 6c 0d 00 00 01 	movl   $0x1,0xd6c(%rip)        # 1c1004 <rand_seed_set>
  1c0295:	00 00 00 
}
  1c0298:	eb cf                	jmp    1c0269 <rand+0x9>

00000000001c029a <srand>:
    rand_seed = seed;
  1c029a:	89 3d 60 0d 00 00    	mov    %edi,0xd60(%rip)        # 1c1000 <rand_seed>
    rand_seed_set = 1;
  1c02a0:	c7 05 5a 0d 00 00 01 	movl   $0x1,0xd5a(%rip)        # 1c1004 <rand_seed_set>
  1c02a7:	00 00 00 
}
  1c02aa:	c3                   	retq   

00000000001c02ab <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1c02ab:	55                   	push   %rbp
  1c02ac:	48 89 e5             	mov    %rsp,%rbp
  1c02af:	41 57                	push   %r15
  1c02b1:	41 56                	push   %r14
  1c02b3:	41 55                	push   %r13
  1c02b5:	41 54                	push   %r12
  1c02b7:	53                   	push   %rbx
  1c02b8:	48 83 ec 58          	sub    $0x58,%rsp
  1c02bc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1c02c0:	0f b6 02             	movzbl (%rdx),%eax
  1c02c3:	84 c0                	test   %al,%al
  1c02c5:	0f 84 ba 06 00 00    	je     1c0985 <printer_vprintf+0x6da>
  1c02cb:	49 89 fe             	mov    %rdi,%r14
  1c02ce:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1c02d1:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%rbp)
  1c02d8:	41 89 f7             	mov    %esi,%r15d
  1c02db:	e9 a5 04 00 00       	jmpq   1c0785 <printer_vprintf+0x4da>
        for (++format; *format; ++format) {
  1c02e0:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1c02e5:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1c02eb:	45 84 e4             	test   %r12b,%r12b
  1c02ee:	0f 84 85 06 00 00    	je     1c0979 <printer_vprintf+0x6ce>
        int flags = 0;
  1c02f4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1c02fa:	41 0f be f4          	movsbl %r12b,%esi
  1c02fe:	bf c1 0c 1c 00       	mov    $0x1c0cc1,%edi
  1c0303:	e8 30 ff ff ff       	callq  1c0238 <strchr>
  1c0308:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  1c030b:	48 85 c0             	test   %rax,%rax
  1c030e:	74 55                	je     1c0365 <printer_vprintf+0xba>
                flags |= 1 << (flagc - flag_chars);
  1c0310:	48 81 e9 c1 0c 1c 00 	sub    $0x1c0cc1,%rcx
  1c0317:	b8 01 00 00 00       	mov    $0x1,%eax
  1c031c:	d3 e0                	shl    %cl,%eax
  1c031e:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1c0321:	48 83 c3 01          	add    $0x1,%rbx
  1c0325:	44 0f b6 23          	movzbl (%rbx),%r12d
  1c0329:	45 84 e4             	test   %r12b,%r12b
  1c032c:	75 cc                	jne    1c02fa <printer_vprintf+0x4f>
  1c032e:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  1c0332:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  1c0338:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  1c033f:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  1c0342:	0f 84 a9 00 00 00    	je     1c03f1 <printer_vprintf+0x146>
        int length = 0;
  1c0348:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  1c034d:	0f b6 13             	movzbl (%rbx),%edx
  1c0350:	8d 42 bd             	lea    -0x43(%rdx),%eax
  1c0353:	3c 37                	cmp    $0x37,%al
  1c0355:	0f 87 c5 04 00 00    	ja     1c0820 <printer_vprintf+0x575>
  1c035b:	0f b6 c0             	movzbl %al,%eax
  1c035e:	ff 24 c5 d0 0a 1c 00 	jmpq   *0x1c0ad0(,%rax,8)
  1c0365:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        if (*format >= '1' && *format <= '9') {
  1c0369:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  1c036e:	3c 08                	cmp    $0x8,%al
  1c0370:	77 2f                	ja     1c03a1 <printer_vprintf+0xf6>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c0372:	0f b6 03             	movzbl (%rbx),%eax
  1c0375:	8d 50 d0             	lea    -0x30(%rax),%edx
  1c0378:	80 fa 09             	cmp    $0x9,%dl
  1c037b:	77 5e                	ja     1c03db <printer_vprintf+0x130>
  1c037d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  1c0383:	48 83 c3 01          	add    $0x1,%rbx
  1c0387:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  1c038c:	0f be c0             	movsbl %al,%eax
  1c038f:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c0394:	0f b6 03             	movzbl (%rbx),%eax
  1c0397:	8d 50 d0             	lea    -0x30(%rax),%edx
  1c039a:	80 fa 09             	cmp    $0x9,%dl
  1c039d:	76 e4                	jbe    1c0383 <printer_vprintf+0xd8>
  1c039f:	eb 97                	jmp    1c0338 <printer_vprintf+0x8d>
        } else if (*format == '*') {
  1c03a1:	41 80 fc 2a          	cmp    $0x2a,%r12b
  1c03a5:	75 3f                	jne    1c03e6 <printer_vprintf+0x13b>
            width = va_arg(val, int);
  1c03a7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c03ab:	8b 01                	mov    (%rcx),%eax
  1c03ad:	83 f8 2f             	cmp    $0x2f,%eax
  1c03b0:	77 17                	ja     1c03c9 <printer_vprintf+0x11e>
  1c03b2:	89 c2                	mov    %eax,%edx
  1c03b4:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c03b8:	83 c0 08             	add    $0x8,%eax
  1c03bb:	89 01                	mov    %eax,(%rcx)
  1c03bd:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1c03c0:	48 83 c3 01          	add    $0x1,%rbx
  1c03c4:	e9 6f ff ff ff       	jmpq   1c0338 <printer_vprintf+0x8d>
            width = va_arg(val, int);
  1c03c9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c03cd:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c03d1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c03d5:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c03d9:	eb e2                	jmp    1c03bd <printer_vprintf+0x112>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c03db:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1c03e1:	e9 52 ff ff ff       	jmpq   1c0338 <printer_vprintf+0x8d>
        int width = -1;
  1c03e6:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1c03ec:	e9 47 ff ff ff       	jmpq   1c0338 <printer_vprintf+0x8d>
            ++format;
  1c03f1:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1c03f5:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1c03f9:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1c03fc:	80 f9 09             	cmp    $0x9,%cl
  1c03ff:	76 13                	jbe    1c0414 <printer_vprintf+0x169>
            } else if (*format == '*') {
  1c0401:	3c 2a                	cmp    $0x2a,%al
  1c0403:	74 32                	je     1c0437 <printer_vprintf+0x18c>
            ++format;
  1c0405:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  1c0408:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  1c040f:	e9 34 ff ff ff       	jmpq   1c0348 <printer_vprintf+0x9d>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c0414:	be 00 00 00 00       	mov    $0x0,%esi
                    precision = 10 * precision + *format++ - '0';
  1c0419:	48 83 c2 01          	add    $0x1,%rdx
  1c041d:	8d 0c b6             	lea    (%rsi,%rsi,4),%ecx
  1c0420:	0f be c0             	movsbl %al,%eax
  1c0423:	8d 74 48 d0          	lea    -0x30(%rax,%rcx,2),%esi
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c0427:	0f b6 02             	movzbl (%rdx),%eax
  1c042a:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1c042d:	80 f9 09             	cmp    $0x9,%cl
  1c0430:	76 e7                	jbe    1c0419 <printer_vprintf+0x16e>
                    precision = 10 * precision + *format++ - '0';
  1c0432:	48 89 d3             	mov    %rdx,%rbx
  1c0435:	eb 1c                	jmp    1c0453 <printer_vprintf+0x1a8>
                precision = va_arg(val, int);
  1c0437:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c043b:	8b 07                	mov    (%rdi),%eax
  1c043d:	83 f8 2f             	cmp    $0x2f,%eax
  1c0440:	77 23                	ja     1c0465 <printer_vprintf+0x1ba>
  1c0442:	89 c2                	mov    %eax,%edx
  1c0444:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c0448:	83 c0 08             	add    $0x8,%eax
  1c044b:	89 07                	mov    %eax,(%rdi)
  1c044d:	8b 32                	mov    (%rdx),%esi
                ++format;
  1c044f:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  1c0453:	85 f6                	test   %esi,%esi
  1c0455:	b8 00 00 00 00       	mov    $0x0,%eax
  1c045a:	0f 48 f0             	cmovs  %eax,%esi
  1c045d:	89 75 9c             	mov    %esi,-0x64(%rbp)
  1c0460:	e9 e3 fe ff ff       	jmpq   1c0348 <printer_vprintf+0x9d>
                precision = va_arg(val, int);
  1c0465:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0469:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c046d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0471:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c0475:	eb d6                	jmp    1c044d <printer_vprintf+0x1a2>
        switch (*format) {
  1c0477:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1c047c:	e9 f1 00 00 00       	jmpq   1c0572 <printer_vprintf+0x2c7>
            ++format;
  1c0481:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  1c0485:	8b 4d 80             	mov    -0x80(%rbp),%ecx
            goto again;
  1c0488:	e9 c0 fe ff ff       	jmpq   1c034d <printer_vprintf+0xa2>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1c048d:	85 c9                	test   %ecx,%ecx
  1c048f:	74 55                	je     1c04e6 <printer_vprintf+0x23b>
  1c0491:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0495:	8b 01                	mov    (%rcx),%eax
  1c0497:	83 f8 2f             	cmp    $0x2f,%eax
  1c049a:	77 38                	ja     1c04d4 <printer_vprintf+0x229>
  1c049c:	89 c2                	mov    %eax,%edx
  1c049e:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c04a2:	83 c0 08             	add    $0x8,%eax
  1c04a5:	89 01                	mov    %eax,(%rcx)
  1c04a7:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1c04aa:	48 89 d0             	mov    %rdx,%rax
  1c04ad:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1c04b1:	49 89 d0             	mov    %rdx,%r8
  1c04b4:	49 f7 d8             	neg    %r8
  1c04b7:	25 80 00 00 00       	and    $0x80,%eax
  1c04bc:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1c04c0:	0b 45 a8             	or     -0x58(%rbp),%eax
  1c04c3:	83 c8 60             	or     $0x60,%eax
  1c04c6:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1c04c9:	41 bc c4 0a 1c 00    	mov    $0x1c0ac4,%r12d
            break;
  1c04cf:	e9 35 01 00 00       	jmpq   1c0609 <printer_vprintf+0x35e>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1c04d4:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c04d8:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c04dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c04e0:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c04e4:	eb c1                	jmp    1c04a7 <printer_vprintf+0x1fc>
  1c04e6:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c04ea:	8b 07                	mov    (%rdi),%eax
  1c04ec:	83 f8 2f             	cmp    $0x2f,%eax
  1c04ef:	77 10                	ja     1c0501 <printer_vprintf+0x256>
  1c04f1:	89 c2                	mov    %eax,%edx
  1c04f3:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c04f7:	83 c0 08             	add    $0x8,%eax
  1c04fa:	89 07                	mov    %eax,(%rdi)
  1c04fc:	48 63 12             	movslq (%rdx),%rdx
  1c04ff:	eb a9                	jmp    1c04aa <printer_vprintf+0x1ff>
  1c0501:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0505:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0509:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c050d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c0511:	eb e9                	jmp    1c04fc <printer_vprintf+0x251>
        int base = 10;
  1c0513:	be 0a 00 00 00       	mov    $0xa,%esi
  1c0518:	eb 58                	jmp    1c0572 <printer_vprintf+0x2c7>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1c051a:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c051e:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c0522:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0526:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c052a:	eb 60                	jmp    1c058c <printer_vprintf+0x2e1>
  1c052c:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c0530:	8b 01                	mov    (%rcx),%eax
  1c0532:	83 f8 2f             	cmp    $0x2f,%eax
  1c0535:	77 10                	ja     1c0547 <printer_vprintf+0x29c>
  1c0537:	89 c2                	mov    %eax,%edx
  1c0539:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c053d:	83 c0 08             	add    $0x8,%eax
  1c0540:	89 01                	mov    %eax,(%rcx)
  1c0542:	44 8b 02             	mov    (%rdx),%r8d
  1c0545:	eb 48                	jmp    1c058f <printer_vprintf+0x2e4>
  1c0547:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c054b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c054f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c0553:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c0557:	eb e9                	jmp    1c0542 <printer_vprintf+0x297>
  1c0559:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  1c055c:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  1c0563:	bf b0 0c 1c 00       	mov    $0x1c0cb0,%edi
  1c0568:	e9 e6 02 00 00       	jmpq   1c0853 <printer_vprintf+0x5a8>
            base = 16;
  1c056d:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1c0572:	85 c9                	test   %ecx,%ecx
  1c0574:	74 b6                	je     1c052c <printer_vprintf+0x281>
  1c0576:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c057a:	8b 07                	mov    (%rdi),%eax
  1c057c:	83 f8 2f             	cmp    $0x2f,%eax
  1c057f:	77 99                	ja     1c051a <printer_vprintf+0x26f>
  1c0581:	89 c2                	mov    %eax,%edx
  1c0583:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c0587:	83 c0 08             	add    $0x8,%eax
  1c058a:	89 07                	mov    %eax,(%rdi)
  1c058c:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  1c058f:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  1c0593:	85 f6                	test   %esi,%esi
  1c0595:	79 c2                	jns    1c0559 <printer_vprintf+0x2ae>
        base = -base;
  1c0597:	41 89 f1             	mov    %esi,%r9d
  1c059a:	f7 de                	neg    %esi
  1c059c:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  1c05a3:	bf 90 0c 1c 00       	mov    $0x1c0c90,%edi
  1c05a8:	e9 a6 02 00 00       	jmpq   1c0853 <printer_vprintf+0x5a8>
            num = (uintptr_t) va_arg(val, void*);
  1c05ad:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c05b1:	8b 07                	mov    (%rdi),%eax
  1c05b3:	83 f8 2f             	cmp    $0x2f,%eax
  1c05b6:	77 1c                	ja     1c05d4 <printer_vprintf+0x329>
  1c05b8:	89 c2                	mov    %eax,%edx
  1c05ba:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c05be:	83 c0 08             	add    $0x8,%eax
  1c05c1:	89 07                	mov    %eax,(%rdi)
  1c05c3:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1c05c6:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1c05cd:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1c05d2:	eb c3                	jmp    1c0597 <printer_vprintf+0x2ec>
            num = (uintptr_t) va_arg(val, void*);
  1c05d4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c05d8:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c05dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c05e0:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c05e4:	eb dd                	jmp    1c05c3 <printer_vprintf+0x318>
            data = va_arg(val, char*);
  1c05e6:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c05ea:	8b 01                	mov    (%rcx),%eax
  1c05ec:	83 f8 2f             	cmp    $0x2f,%eax
  1c05ef:	0f 87 a9 01 00 00    	ja     1c079e <printer_vprintf+0x4f3>
  1c05f5:	89 c2                	mov    %eax,%edx
  1c05f7:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c05fb:	83 c0 08             	add    $0x8,%eax
  1c05fe:	89 01                	mov    %eax,(%rcx)
  1c0600:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  1c0603:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  1c0609:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c060c:	83 e0 20             	and    $0x20,%eax
  1c060f:	89 45 8c             	mov    %eax,-0x74(%rbp)
  1c0612:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  1c0618:	0f 85 25 02 00 00    	jne    1c0843 <printer_vprintf+0x598>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1c061e:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c0621:	89 45 88             	mov    %eax,-0x78(%rbp)
  1c0624:	83 e0 60             	and    $0x60,%eax
  1c0627:	83 f8 60             	cmp    $0x60,%eax
  1c062a:	0f 84 58 02 00 00    	je     1c0888 <printer_vprintf+0x5dd>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1c0630:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c0633:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  1c0636:	48 c7 45 a0 c4 0a 1c 	movq   $0x1c0ac4,-0x60(%rbp)
  1c063d:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1c063e:	83 f8 21             	cmp    $0x21,%eax
  1c0641:	0f 84 7d 02 00 00    	je     1c08c4 <printer_vprintf+0x619>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1c0647:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  1c064a:	89 c8                	mov    %ecx,%eax
  1c064c:	f7 d0                	not    %eax
  1c064e:	c1 e8 1f             	shr    $0x1f,%eax
  1c0651:	89 45 84             	mov    %eax,-0x7c(%rbp)
  1c0654:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1c0658:	0f 85 a2 02 00 00    	jne    1c0900 <printer_vprintf+0x655>
  1c065e:	84 c0                	test   %al,%al
  1c0660:	0f 84 9a 02 00 00    	je     1c0900 <printer_vprintf+0x655>
            len = strnlen(data, precision);
  1c0666:	48 63 f1             	movslq %ecx,%rsi
  1c0669:	4c 89 e7             	mov    %r12,%rdi
  1c066c:	e8 61 fb ff ff       	callq  1c01d2 <strnlen>
  1c0671:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  1c0674:	8b 45 88             	mov    -0x78(%rbp),%eax
  1c0677:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  1c067a:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  1c0681:	83 f8 22             	cmp    $0x22,%eax
  1c0684:	0f 84 ae 02 00 00    	je     1c0938 <printer_vprintf+0x68d>
        width -= len + zeros + strlen(prefix);
  1c068a:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1c068e:	e8 24 fb ff ff       	callq  1c01b7 <strlen>
  1c0693:	8b 55 9c             	mov    -0x64(%rbp),%edx
  1c0696:	03 55 98             	add    -0x68(%rbp),%edx
  1c0699:	41 29 d5             	sub    %edx,%r13d
  1c069c:	44 89 ea             	mov    %r13d,%edx
  1c069f:	29 c2                	sub    %eax,%edx
  1c06a1:	89 55 8c             	mov    %edx,-0x74(%rbp)
  1c06a4:	41 89 d5             	mov    %edx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c06a7:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1c06ab:	75 2d                	jne    1c06da <printer_vprintf+0x42f>
  1c06ad:	85 d2                	test   %edx,%edx
  1c06af:	7e 29                	jle    1c06da <printer_vprintf+0x42f>
            p->putc(p, ' ', color);
  1c06b1:	44 89 fa             	mov    %r15d,%edx
  1c06b4:	be 20 00 00 00       	mov    $0x20,%esi
  1c06b9:	4c 89 f7             	mov    %r14,%rdi
  1c06bc:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c06bf:	41 83 ed 01          	sub    $0x1,%r13d
  1c06c3:	45 85 ed             	test   %r13d,%r13d
  1c06c6:	7f e9                	jg     1c06b1 <printer_vprintf+0x406>
  1c06c8:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1c06cb:	85 ff                	test   %edi,%edi
  1c06cd:	b8 01 00 00 00       	mov    $0x1,%eax
  1c06d2:	0f 4f c7             	cmovg  %edi,%eax
  1c06d5:	29 c7                	sub    %eax,%edi
  1c06d7:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1c06da:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  1c06de:	0f b6 01             	movzbl (%rcx),%eax
  1c06e1:	84 c0                	test   %al,%al
  1c06e3:	74 22                	je     1c0707 <printer_vprintf+0x45c>
  1c06e5:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1c06e9:	48 89 cb             	mov    %rcx,%rbx
            p->putc(p, *prefix, color);
  1c06ec:	0f b6 f0             	movzbl %al,%esi
  1c06ef:	44 89 fa             	mov    %r15d,%edx
  1c06f2:	4c 89 f7             	mov    %r14,%rdi
  1c06f5:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1c06f8:	48 83 c3 01          	add    $0x1,%rbx
  1c06fc:	0f b6 03             	movzbl (%rbx),%eax
  1c06ff:	84 c0                	test   %al,%al
  1c0701:	75 e9                	jne    1c06ec <printer_vprintf+0x441>
  1c0703:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  1c0707:	8b 45 9c             	mov    -0x64(%rbp),%eax
  1c070a:	85 c0                	test   %eax,%eax
  1c070c:	7e 1d                	jle    1c072b <printer_vprintf+0x480>
  1c070e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1c0712:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  1c0714:	44 89 fa             	mov    %r15d,%edx
  1c0717:	be 30 00 00 00       	mov    $0x30,%esi
  1c071c:	4c 89 f7             	mov    %r14,%rdi
  1c071f:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  1c0722:	83 eb 01             	sub    $0x1,%ebx
  1c0725:	75 ed                	jne    1c0714 <printer_vprintf+0x469>
  1c0727:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  1c072b:	8b 45 98             	mov    -0x68(%rbp),%eax
  1c072e:	85 c0                	test   %eax,%eax
  1c0730:	7e 2a                	jle    1c075c <printer_vprintf+0x4b1>
  1c0732:	8d 40 ff             	lea    -0x1(%rax),%eax
  1c0735:	49 8d 44 04 01       	lea    0x1(%r12,%rax,1),%rax
  1c073a:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1c073e:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  1c0741:	41 0f b6 34 24       	movzbl (%r12),%esi
  1c0746:	44 89 fa             	mov    %r15d,%edx
  1c0749:	4c 89 f7             	mov    %r14,%rdi
  1c074c:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  1c074f:	49 83 c4 01          	add    $0x1,%r12
  1c0753:	49 39 dc             	cmp    %rbx,%r12
  1c0756:	75 e9                	jne    1c0741 <printer_vprintf+0x496>
  1c0758:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  1c075c:	45 85 ed             	test   %r13d,%r13d
  1c075f:	7e 14                	jle    1c0775 <printer_vprintf+0x4ca>
            p->putc(p, ' ', color);
  1c0761:	44 89 fa             	mov    %r15d,%edx
  1c0764:	be 20 00 00 00       	mov    $0x20,%esi
  1c0769:	4c 89 f7             	mov    %r14,%rdi
  1c076c:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  1c076f:	41 83 ed 01          	sub    $0x1,%r13d
  1c0773:	75 ec                	jne    1c0761 <printer_vprintf+0x4b6>
    for (; *format; ++format) {
  1c0775:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  1c0779:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1c077d:	84 c0                	test   %al,%al
  1c077f:	0f 84 00 02 00 00    	je     1c0985 <printer_vprintf+0x6da>
        if (*format != '%') {
  1c0785:	3c 25                	cmp    $0x25,%al
  1c0787:	0f 84 53 fb ff ff    	je     1c02e0 <printer_vprintf+0x35>
            p->putc(p, *format, color);
  1c078d:	0f b6 f0             	movzbl %al,%esi
  1c0790:	44 89 fa             	mov    %r15d,%edx
  1c0793:	4c 89 f7             	mov    %r14,%rdi
  1c0796:	41 ff 16             	callq  *(%r14)
            continue;
  1c0799:	4c 89 e3             	mov    %r12,%rbx
  1c079c:	eb d7                	jmp    1c0775 <printer_vprintf+0x4ca>
            data = va_arg(val, char*);
  1c079e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c07a2:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c07a6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c07aa:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c07ae:	e9 4d fe ff ff       	jmpq   1c0600 <printer_vprintf+0x355>
            color = va_arg(val, int);
  1c07b3:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c07b7:	8b 07                	mov    (%rdi),%eax
  1c07b9:	83 f8 2f             	cmp    $0x2f,%eax
  1c07bc:	77 10                	ja     1c07ce <printer_vprintf+0x523>
  1c07be:	89 c2                	mov    %eax,%edx
  1c07c0:	48 03 57 10          	add    0x10(%rdi),%rdx
  1c07c4:	83 c0 08             	add    $0x8,%eax
  1c07c7:	89 07                	mov    %eax,(%rdi)
  1c07c9:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1c07cc:	eb a7                	jmp    1c0775 <printer_vprintf+0x4ca>
            color = va_arg(val, int);
  1c07ce:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c07d2:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1c07d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c07da:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1c07de:	eb e9                	jmp    1c07c9 <printer_vprintf+0x51e>
            numbuf[0] = va_arg(val, int);
  1c07e0:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1c07e4:	8b 01                	mov    (%rcx),%eax
  1c07e6:	83 f8 2f             	cmp    $0x2f,%eax
  1c07e9:	77 23                	ja     1c080e <printer_vprintf+0x563>
  1c07eb:	89 c2                	mov    %eax,%edx
  1c07ed:	48 03 51 10          	add    0x10(%rcx),%rdx
  1c07f1:	83 c0 08             	add    $0x8,%eax
  1c07f4:	89 01                	mov    %eax,(%rcx)
  1c07f6:	8b 02                	mov    (%rdx),%eax
  1c07f8:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1c07fb:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1c07ff:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c0803:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  1c0809:	e9 fb fd ff ff       	jmpq   1c0609 <printer_vprintf+0x35e>
            numbuf[0] = va_arg(val, int);
  1c080e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1c0812:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c0816:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1c081a:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1c081e:	eb d6                	jmp    1c07f6 <printer_vprintf+0x54b>
            numbuf[0] = (*format ? *format : '%');
  1c0820:	84 d2                	test   %dl,%dl
  1c0822:	0f 85 3b 01 00 00    	jne    1c0963 <printer_vprintf+0x6b8>
  1c0828:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  1c082c:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  1c0830:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  1c0834:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c0838:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1c083e:	e9 c6 fd ff ff       	jmpq   1c0609 <printer_vprintf+0x35e>
        if (flags & FLAG_NUMERIC) {
  1c0843:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1c0849:	bf b0 0c 1c 00       	mov    $0x1c0cb0,%edi
        if (flags & FLAG_NUMERIC) {
  1c084e:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1c0853:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1c0857:	4c 89 c1             	mov    %r8,%rcx
  1c085a:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  1c085e:	48 63 f6             	movslq %esi,%rsi
  1c0861:	49 83 ec 01          	sub    $0x1,%r12
  1c0865:	48 89 c8             	mov    %rcx,%rax
  1c0868:	ba 00 00 00 00       	mov    $0x0,%edx
  1c086d:	48 f7 f6             	div    %rsi
  1c0870:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  1c0874:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  1c0878:	48 89 ca             	mov    %rcx,%rdx
  1c087b:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  1c087e:	48 39 d6             	cmp    %rdx,%rsi
  1c0881:	76 de                	jbe    1c0861 <printer_vprintf+0x5b6>
  1c0883:	e9 96 fd ff ff       	jmpq   1c061e <printer_vprintf+0x373>
                prefix = "-";
  1c0888:	48 c7 45 a0 c7 0a 1c 	movq   $0x1c0ac7,-0x60(%rbp)
  1c088f:	00 
            if (flags & FLAG_NEGATIVE) {
  1c0890:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1c0893:	a8 80                	test   $0x80,%al
  1c0895:	0f 85 ac fd ff ff    	jne    1c0647 <printer_vprintf+0x39c>
                prefix = "+";
  1c089b:	48 c7 45 a0 c5 0a 1c 	movq   $0x1c0ac5,-0x60(%rbp)
  1c08a2:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1c08a3:	a8 10                	test   $0x10,%al
  1c08a5:	0f 85 9c fd ff ff    	jne    1c0647 <printer_vprintf+0x39c>
                prefix = " ";
  1c08ab:	a8 08                	test   $0x8,%al
  1c08ad:	ba c4 0a 1c 00       	mov    $0x1c0ac4,%edx
  1c08b2:	b8 c3 0a 1c 00       	mov    $0x1c0ac3,%eax
  1c08b7:	48 0f 44 c2          	cmove  %rdx,%rax
  1c08bb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1c08bf:	e9 83 fd ff ff       	jmpq   1c0647 <printer_vprintf+0x39c>
                   && (base == 16 || base == -16)
  1c08c4:	41 8d 41 10          	lea    0x10(%r9),%eax
  1c08c8:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1c08cd:	0f 85 74 fd ff ff    	jne    1c0647 <printer_vprintf+0x39c>
                   && (num || (flags & FLAG_ALT2))) {
  1c08d3:	4d 85 c0             	test   %r8,%r8
  1c08d6:	75 0d                	jne    1c08e5 <printer_vprintf+0x63a>
  1c08d8:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1c08df:	0f 84 62 fd ff ff    	je     1c0647 <printer_vprintf+0x39c>
            prefix = (base == -16 ? "0x" : "0X");
  1c08e5:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1c08e9:	ba c0 0a 1c 00       	mov    $0x1c0ac0,%edx
  1c08ee:	b8 c9 0a 1c 00       	mov    $0x1c0ac9,%eax
  1c08f3:	48 0f 44 c2          	cmove  %rdx,%rax
  1c08f7:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1c08fb:	e9 47 fd ff ff       	jmpq   1c0647 <printer_vprintf+0x39c>
            len = strlen(data);
  1c0900:	4c 89 e7             	mov    %r12,%rdi
  1c0903:	e8 af f8 ff ff       	callq  1c01b7 <strlen>
  1c0908:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1c090b:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1c090f:	0f 84 5f fd ff ff    	je     1c0674 <printer_vprintf+0x3c9>
  1c0915:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  1c0919:	0f 84 55 fd ff ff    	je     1c0674 <printer_vprintf+0x3c9>
            zeros = precision > len ? precision - len : 0;
  1c091f:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1c0922:	89 fa                	mov    %edi,%edx
  1c0924:	29 c2                	sub    %eax,%edx
  1c0926:	39 c7                	cmp    %eax,%edi
  1c0928:	b8 00 00 00 00       	mov    $0x0,%eax
  1c092d:	0f 4e d0             	cmovle %eax,%edx
  1c0930:	89 55 9c             	mov    %edx,-0x64(%rbp)
  1c0933:	e9 52 fd ff ff       	jmpq   1c068a <printer_vprintf+0x3df>
                   && len + (int) strlen(prefix) < width) {
  1c0938:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1c093c:	e8 76 f8 ff ff       	callq  1c01b7 <strlen>
  1c0941:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1c0944:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1c0947:	44 89 e9             	mov    %r13d,%ecx
  1c094a:	29 f9                	sub    %edi,%ecx
  1c094c:	29 c1                	sub    %eax,%ecx
  1c094e:	89 c8                	mov    %ecx,%eax
  1c0950:	44 39 ea             	cmp    %r13d,%edx
  1c0953:	b9 00 00 00 00       	mov    $0x0,%ecx
  1c0958:	0f 4d c1             	cmovge %ecx,%eax
  1c095b:	89 45 9c             	mov    %eax,-0x64(%rbp)
  1c095e:	e9 27 fd ff ff       	jmpq   1c068a <printer_vprintf+0x3df>
            numbuf[0] = (*format ? *format : '%');
  1c0963:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  1c0966:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1c096a:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1c096e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1c0974:	e9 90 fc ff ff       	jmpq   1c0609 <printer_vprintf+0x35e>
        int flags = 0;
  1c0979:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  1c0980:	e9 ad f9 ff ff       	jmpq   1c0332 <printer_vprintf+0x87>
}
  1c0985:	48 83 c4 58          	add    $0x58,%rsp
  1c0989:	5b                   	pop    %rbx
  1c098a:	41 5c                	pop    %r12
  1c098c:	41 5d                	pop    %r13
  1c098e:	41 5e                	pop    %r14
  1c0990:	41 5f                	pop    %r15
  1c0992:	5d                   	pop    %rbp
  1c0993:	c3                   	retq   

00000000001c0994 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  1c0994:	55                   	push   %rbp
  1c0995:	48 89 e5             	mov    %rsp,%rbp
  1c0998:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  1c099c:	48 c7 45 f0 92 00 1c 	movq   $0x1c0092,-0x10(%rbp)
  1c09a3:	00 
        cpos = 0;
  1c09a4:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  1c09aa:	b8 00 00 00 00       	mov    $0x0,%eax
  1c09af:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1c09b2:	48 63 ff             	movslq %edi,%rdi
  1c09b5:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1c09bc:	00 
  1c09bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1c09c1:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1c09c5:	e8 e1 f8 ff ff       	callq  1c02ab <printer_vprintf>
    return cp.cursor - console;
  1c09ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c09ce:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1c09d4:	48 d1 f8             	sar    %rax
}
  1c09d7:	c9                   	leaveq 
  1c09d8:	c3                   	retq   

00000000001c09d9 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1c09d9:	55                   	push   %rbp
  1c09da:	48 89 e5             	mov    %rsp,%rbp
  1c09dd:	48 83 ec 50          	sub    $0x50,%rsp
  1c09e1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c09e5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c09e9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1c09ed:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1c09f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c09f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c09fc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c0a00:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1c0a04:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c0a08:	e8 87 ff ff ff       	callq  1c0994 <console_vprintf>
}
  1c0a0d:	c9                   	leaveq 
  1c0a0e:	c3                   	retq   

00000000001c0a0f <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  1c0a0f:	55                   	push   %rbp
  1c0a10:	48 89 e5             	mov    %rsp,%rbp
  1c0a13:	53                   	push   %rbx
  1c0a14:	48 83 ec 28          	sub    $0x28,%rsp
  1c0a18:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  1c0a1b:	48 c7 45 d8 1c 01 1c 	movq   $0x1c011c,-0x28(%rbp)
  1c0a22:	00 
    sp.s = s;
  1c0a23:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  1c0a27:	48 85 f6             	test   %rsi,%rsi
  1c0a2a:	75 0e                	jne    1c0a3a <vsnprintf+0x2b>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  1c0a2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c0a30:	48 29 d8             	sub    %rbx,%rax
}
  1c0a33:	48 83 c4 28          	add    $0x28,%rsp
  1c0a37:	5b                   	pop    %rbx
  1c0a38:	5d                   	pop    %rbp
  1c0a39:	c3                   	retq   
        sp.end = s + size - 1;
  1c0a3a:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  1c0a3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  1c0a43:	be 00 00 00 00       	mov    $0x0,%esi
  1c0a48:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  1c0a4c:	e8 5a f8 ff ff       	callq  1c02ab <printer_vprintf>
        *sp.s = 0;
  1c0a51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c0a55:	c6 00 00             	movb   $0x0,(%rax)
  1c0a58:	eb d2                	jmp    1c0a2c <vsnprintf+0x1d>

00000000001c0a5a <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  1c0a5a:	55                   	push   %rbp
  1c0a5b:	48 89 e5             	mov    %rsp,%rbp
  1c0a5e:	48 83 ec 50          	sub    $0x50,%rsp
  1c0a62:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c0a66:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c0a6a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1c0a6e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1c0a75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c0a79:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c0a7d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c0a81:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  1c0a85:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c0a89:	e8 81 ff ff ff       	callq  1c0a0f <vsnprintf>
    va_end(val);
    return n;
}
  1c0a8e:	c9                   	leaveq 
  1c0a8f:	c3                   	retq   

00000000001c0a90 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c0a90:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  1c0a95:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  1c0a9a:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c0a9f:	48 83 c0 02          	add    $0x2,%rax
  1c0aa3:	48 39 d0             	cmp    %rdx,%rax
  1c0aa6:	75 f2                	jne    1c0a9a <console_clear+0xa>
    }
    cursorpos = 0;
  1c0aa8:	c7 05 4a 85 ef ff 00 	movl   $0x0,-0x107ab6(%rip)        # b8ffc <cursorpos>
  1c0aaf:	00 00 00 
}
  1c0ab2:	c3                   	retq   
