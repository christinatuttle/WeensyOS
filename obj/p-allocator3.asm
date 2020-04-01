
obj/p-allocator3.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000180000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  180000:	55                   	push   %rbp
  180001:	48 89 e5             	mov    %rsp,%rbp
  180004:	53                   	push   %rbx
  180005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  180009:	cd 31                	int    $0x31
  18000b:	89 c7                	mov    %eax,%edi
  18000d:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  18000f:	e8 86 02 00 00       	callq  18029a <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  180014:	b8 17 20 18 00       	mov    $0x182017,%eax
  180019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  18001f:	48 89 05 e2 0f 00 00 	mov    %rax,0xfe2(%rip)        # 181008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  180026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  180029:	48 83 e8 01          	sub    $0x1,%rax
  18002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  180033:	48 89 05 d6 0f 00 00 	mov    %rax,0xfd6(%rip)        # 181010 <stack_bottom>
  18003a:	eb 02                	jmp    18003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  18003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  18003e:	e8 1d 02 00 00       	callq  180260 <rand>
  180043:	89 c2                	mov    %eax,%edx
  180045:	48 98                	cltq   
  180047:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
  18004e:	48 c1 f8 25          	sar    $0x25,%rax
  180052:	89 d1                	mov    %edx,%ecx
  180054:	c1 f9 1f             	sar    $0x1f,%ecx
  180057:	29 c8                	sub    %ecx,%eax
  180059:	6b c0 64             	imul   $0x64,%eax,%eax
  18005c:	29 c2                	sub    %eax,%edx
  18005e:	39 da                	cmp    %ebx,%edx
  180060:	7d da                	jge    18003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  180062:	48 8b 3d 9f 0f 00 00 	mov    0xf9f(%rip),%rdi        # 181008 <heap_top>
  180069:	48 3b 3d a0 0f 00 00 	cmp    0xfa0(%rip),%rdi        # 181010 <stack_bottom>
  180070:	74 1c                	je     18008e <process_main+0x8e>
//    Allocate a page of memory at address `addr`. `Addr` must be page-aligned
//    (i.e., a multiple of PAGESIZE == 4096). Returns 0 on success and -1
//    on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  180072:	cd 33                	int    $0x33
  180074:	85 c0                	test   %eax,%eax
  180076:	78 16                	js     18008e <process_main+0x8e>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  180078:	48 8b 05 89 0f 00 00 	mov    0xf89(%rip),%rax        # 181008 <heap_top>
  18007f:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  180081:	48 81 05 7c 0f 00 00 	addq   $0x1000,0xf7c(%rip)        # 181008 <heap_top>
  180088:	00 10 00 00 
  18008c:	eb ae                	jmp    18003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  18008e:	cd 32                	int    $0x32
  180090:	eb fc                	jmp    18008e <process_main+0x8e>

0000000000180092 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  180092:	41 89 d0             	mov    %edx,%r8d
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  180095:	48 81 7f 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rdi)
  18009c:	00 
  18009d:	72 08                	jb     1800a7 <console_putc+0x15>
        cp->cursor = console;
  18009f:	48 c7 47 08 00 80 0b 	movq   $0xb8000,0x8(%rdi)
  1800a6:	00 
    }
    if (c == '\n') {
  1800a7:	40 80 fe 0a          	cmp    $0xa,%sil
  1800ab:	74 17                	je     1800c4 <console_putc+0x32>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1800ad:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1800b1:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1800b5:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1800b9:	40 0f b6 f6          	movzbl %sil,%esi
  1800bd:	44 09 c6             	or     %r8d,%esi
  1800c0:	66 89 30             	mov    %si,(%rax)
    }
}
  1800c3:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1800c4:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  1800c8:	48 81 ee 00 80 0b 00 	sub    $0xb8000,%rsi
  1800cf:	48 89 f1             	mov    %rsi,%rcx
  1800d2:	48 d1 f9             	sar    %rcx
  1800d5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1800dc:	66 66 66 
  1800df:	48 89 c8             	mov    %rcx,%rax
  1800e2:	48 f7 ea             	imul   %rdx
  1800e5:	48 c1 fa 05          	sar    $0x5,%rdx
  1800e9:	48 c1 fe 3f          	sar    $0x3f,%rsi
  1800ed:	48 29 f2             	sub    %rsi,%rdx
  1800f0:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  1800f4:	48 c1 e0 04          	shl    $0x4,%rax
  1800f8:	89 ca                	mov    %ecx,%edx
  1800fa:	29 c2                	sub    %eax,%edx
  1800fc:	89 d0                	mov    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1800fe:	44 89 c6             	mov    %r8d,%esi
  180101:	83 ce 20             	or     $0x20,%esi
  180104:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  180108:	4c 8d 41 02          	lea    0x2(%rcx),%r8
  18010c:	4c 89 47 08          	mov    %r8,0x8(%rdi)
  180110:	66 89 31             	mov    %si,(%rcx)
        for (; pos != 80; pos++) {
  180113:	83 c0 01             	add    $0x1,%eax
  180116:	83 f8 50             	cmp    $0x50,%eax
  180119:	75 e9                	jne    180104 <console_putc+0x72>
  18011b:	c3                   	retq   

000000000018011c <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  18011c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  180120:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  180124:	73 0b                	jae    180131 <string_putc+0x15>
        *sp->s++ = c;
  180126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  18012a:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  18012e:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  180131:	c3                   	retq   

0000000000180132 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  180132:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  180135:	48 85 d2             	test   %rdx,%rdx
  180138:	74 17                	je     180151 <memcpy+0x1f>
  18013a:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  18013f:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  180144:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  180148:	48 83 c1 01          	add    $0x1,%rcx
  18014c:	48 39 d1             	cmp    %rdx,%rcx
  18014f:	75 ee                	jne    18013f <memcpy+0xd>
}
  180151:	c3                   	retq   

0000000000180152 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  180152:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  180155:	48 39 fe             	cmp    %rdi,%rsi
  180158:	72 1d                	jb     180177 <memmove+0x25>
        while (n-- > 0) {
  18015a:	b9 00 00 00 00       	mov    $0x0,%ecx
  18015f:	48 85 d2             	test   %rdx,%rdx
  180162:	74 12                	je     180176 <memmove+0x24>
            *d++ = *s++;
  180164:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  180168:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  18016c:	48 83 c1 01          	add    $0x1,%rcx
  180170:	48 39 ca             	cmp    %rcx,%rdx
  180173:	75 ef                	jne    180164 <memmove+0x12>
}
  180175:	c3                   	retq   
  180176:	c3                   	retq   
    if (s < d && s + n > d) {
  180177:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  18017b:	48 39 cf             	cmp    %rcx,%rdi
  18017e:	73 da                	jae    18015a <memmove+0x8>
        while (n-- > 0) {
  180180:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  180184:	48 85 d2             	test   %rdx,%rdx
  180187:	74 ec                	je     180175 <memmove+0x23>
            *--d = *--s;
  180189:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  18018d:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  180190:	48 83 e9 01          	sub    $0x1,%rcx
  180194:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  180198:	75 ef                	jne    180189 <memmove+0x37>
  18019a:	c3                   	retq   

000000000018019b <memset>:
void* memset(void* v, int c, size_t n) {
  18019b:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  18019e:	48 85 d2             	test   %rdx,%rdx
  1801a1:	74 13                	je     1801b6 <memset+0x1b>
  1801a3:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  1801a7:	48 89 fa             	mov    %rdi,%rdx
        *p = c;
  1801aa:	40 88 32             	mov    %sil,(%rdx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1801ad:	48 83 c2 01          	add    $0x1,%rdx
  1801b1:	48 39 d1             	cmp    %rdx,%rcx
  1801b4:	75 f4                	jne    1801aa <memset+0xf>
}
  1801b6:	c3                   	retq   

00000000001801b7 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1801b7:	80 3f 00             	cmpb   $0x0,(%rdi)
  1801ba:	74 10                	je     1801cc <strlen+0x15>
  1801bc:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1801c1:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1801c5:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1801c9:	75 f6                	jne    1801c1 <strlen+0xa>
  1801cb:	c3                   	retq   
  1801cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1801d1:	c3                   	retq   

00000000001801d2 <strnlen>:
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1801d2:	b8 00 00 00 00       	mov    $0x0,%eax
  1801d7:	48 85 f6             	test   %rsi,%rsi
  1801da:	74 10                	je     1801ec <strnlen+0x1a>
  1801dc:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1801e0:	74 09                	je     1801eb <strnlen+0x19>
        ++n;
  1801e2:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1801e6:	48 39 c6             	cmp    %rax,%rsi
  1801e9:	75 f1                	jne    1801dc <strnlen+0xa>
}
  1801eb:	c3                   	retq   
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1801ec:	48 89 f0             	mov    %rsi,%rax
  1801ef:	c3                   	retq   

00000000001801f0 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1801f0:	48 89 f8             	mov    %rdi,%rax
  1801f3:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1801f8:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1801fc:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1801ff:	48 83 c2 01          	add    $0x1,%rdx
  180203:	84 c9                	test   %cl,%cl
  180205:	75 f1                	jne    1801f8 <strcpy+0x8>
}
  180207:	c3                   	retq   

0000000000180208 <strcmp>:
    while (*a && *b && *a == *b) {
  180208:	0f b6 17             	movzbl (%rdi),%edx
  18020b:	84 d2                	test   %dl,%dl
  18020d:	74 1a                	je     180229 <strcmp+0x21>
  18020f:	0f b6 06             	movzbl (%rsi),%eax
  180212:	38 d0                	cmp    %dl,%al
  180214:	75 13                	jne    180229 <strcmp+0x21>
  180216:	84 c0                	test   %al,%al
  180218:	74 0f                	je     180229 <strcmp+0x21>
        ++a, ++b;
  18021a:	48 83 c7 01          	add    $0x1,%rdi
  18021e:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  180222:	0f b6 17             	movzbl (%rdi),%edx
  180225:	84 d2                	test   %dl,%dl
  180227:	75 e6                	jne    18020f <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  180229:	0f b6 0e             	movzbl (%rsi),%ecx
  18022c:	38 ca                	cmp    %cl,%dl
  18022e:	0f 97 c0             	seta   %al
  180231:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  180234:	83 d8 00             	sbb    $0x0,%eax
}
  180237:	c3                   	retq   

0000000000180238 <strchr>:
    while (*s && *s != (char) c) {
  180238:	0f b6 07             	movzbl (%rdi),%eax
  18023b:	84 c0                	test   %al,%al
  18023d:	74 10                	je     18024f <strchr+0x17>
  18023f:	40 38 f0             	cmp    %sil,%al
  180242:	74 18                	je     18025c <strchr+0x24>
        ++s;
  180244:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  180248:	0f b6 07             	movzbl (%rdi),%eax
  18024b:	84 c0                	test   %al,%al
  18024d:	75 f0                	jne    18023f <strchr+0x7>
        return NULL;
  18024f:	40 84 f6             	test   %sil,%sil
  180252:	b8 00 00 00 00       	mov    $0x0,%eax
  180257:	48 0f 44 c7          	cmove  %rdi,%rax
}
  18025b:	c3                   	retq   
  18025c:	48 89 f8             	mov    %rdi,%rax
  18025f:	c3                   	retq   

0000000000180260 <rand>:
    if (!rand_seed_set) {
  180260:	83 3d 9d 0d 00 00 00 	cmpl   $0x0,0xd9d(%rip)        # 181004 <rand_seed_set>
  180267:	74 1b                	je     180284 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  180269:	69 05 8d 0d 00 00 0d 	imul   $0x19660d,0xd8d(%rip),%eax        # 181000 <rand_seed>
  180270:	66 19 00 
  180273:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  180278:	89 05 82 0d 00 00    	mov    %eax,0xd82(%rip)        # 181000 <rand_seed>
    return rand_seed & RAND_MAX;
  18027e:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  180283:	c3                   	retq   
    rand_seed = seed;
  180284:	c7 05 72 0d 00 00 9e 	movl   $0x30d4879e,0xd72(%rip)        # 181000 <rand_seed>
  18028b:	87 d4 30 
    rand_seed_set = 1;
  18028e:	c7 05 6c 0d 00 00 01 	movl   $0x1,0xd6c(%rip)        # 181004 <rand_seed_set>
  180295:	00 00 00 
}
  180298:	eb cf                	jmp    180269 <rand+0x9>

000000000018029a <srand>:
    rand_seed = seed;
  18029a:	89 3d 60 0d 00 00    	mov    %edi,0xd60(%rip)        # 181000 <rand_seed>
    rand_seed_set = 1;
  1802a0:	c7 05 5a 0d 00 00 01 	movl   $0x1,0xd5a(%rip)        # 181004 <rand_seed_set>
  1802a7:	00 00 00 
}
  1802aa:	c3                   	retq   

00000000001802ab <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1802ab:	55                   	push   %rbp
  1802ac:	48 89 e5             	mov    %rsp,%rbp
  1802af:	41 57                	push   %r15
  1802b1:	41 56                	push   %r14
  1802b3:	41 55                	push   %r13
  1802b5:	41 54                	push   %r12
  1802b7:	53                   	push   %rbx
  1802b8:	48 83 ec 58          	sub    $0x58,%rsp
  1802bc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1802c0:	0f b6 02             	movzbl (%rdx),%eax
  1802c3:	84 c0                	test   %al,%al
  1802c5:	0f 84 ba 06 00 00    	je     180985 <printer_vprintf+0x6da>
  1802cb:	49 89 fe             	mov    %rdi,%r14
  1802ce:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1802d1:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%rbp)
  1802d8:	41 89 f7             	mov    %esi,%r15d
  1802db:	e9 a5 04 00 00       	jmpq   180785 <printer_vprintf+0x4da>
        for (++format; *format; ++format) {
  1802e0:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1802e5:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1802eb:	45 84 e4             	test   %r12b,%r12b
  1802ee:	0f 84 85 06 00 00    	je     180979 <printer_vprintf+0x6ce>
        int flags = 0;
  1802f4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1802fa:	41 0f be f4          	movsbl %r12b,%esi
  1802fe:	bf c1 0c 18 00       	mov    $0x180cc1,%edi
  180303:	e8 30 ff ff ff       	callq  180238 <strchr>
  180308:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  18030b:	48 85 c0             	test   %rax,%rax
  18030e:	74 55                	je     180365 <printer_vprintf+0xba>
                flags |= 1 << (flagc - flag_chars);
  180310:	48 81 e9 c1 0c 18 00 	sub    $0x180cc1,%rcx
  180317:	b8 01 00 00 00       	mov    $0x1,%eax
  18031c:	d3 e0                	shl    %cl,%eax
  18031e:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  180321:	48 83 c3 01          	add    $0x1,%rbx
  180325:	44 0f b6 23          	movzbl (%rbx),%r12d
  180329:	45 84 e4             	test   %r12b,%r12b
  18032c:	75 cc                	jne    1802fa <printer_vprintf+0x4f>
  18032e:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  180332:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  180338:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  18033f:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  180342:	0f 84 a9 00 00 00    	je     1803f1 <printer_vprintf+0x146>
        int length = 0;
  180348:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  18034d:	0f b6 13             	movzbl (%rbx),%edx
  180350:	8d 42 bd             	lea    -0x43(%rdx),%eax
  180353:	3c 37                	cmp    $0x37,%al
  180355:	0f 87 c5 04 00 00    	ja     180820 <printer_vprintf+0x575>
  18035b:	0f b6 c0             	movzbl %al,%eax
  18035e:	ff 24 c5 d0 0a 18 00 	jmpq   *0x180ad0(,%rax,8)
  180365:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        if (*format >= '1' && *format <= '9') {
  180369:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  18036e:	3c 08                	cmp    $0x8,%al
  180370:	77 2f                	ja     1803a1 <printer_vprintf+0xf6>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  180372:	0f b6 03             	movzbl (%rbx),%eax
  180375:	8d 50 d0             	lea    -0x30(%rax),%edx
  180378:	80 fa 09             	cmp    $0x9,%dl
  18037b:	77 5e                	ja     1803db <printer_vprintf+0x130>
  18037d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  180383:	48 83 c3 01          	add    $0x1,%rbx
  180387:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  18038c:	0f be c0             	movsbl %al,%eax
  18038f:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  180394:	0f b6 03             	movzbl (%rbx),%eax
  180397:	8d 50 d0             	lea    -0x30(%rax),%edx
  18039a:	80 fa 09             	cmp    $0x9,%dl
  18039d:	76 e4                	jbe    180383 <printer_vprintf+0xd8>
  18039f:	eb 97                	jmp    180338 <printer_vprintf+0x8d>
        } else if (*format == '*') {
  1803a1:	41 80 fc 2a          	cmp    $0x2a,%r12b
  1803a5:	75 3f                	jne    1803e6 <printer_vprintf+0x13b>
            width = va_arg(val, int);
  1803a7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1803ab:	8b 01                	mov    (%rcx),%eax
  1803ad:	83 f8 2f             	cmp    $0x2f,%eax
  1803b0:	77 17                	ja     1803c9 <printer_vprintf+0x11e>
  1803b2:	89 c2                	mov    %eax,%edx
  1803b4:	48 03 51 10          	add    0x10(%rcx),%rdx
  1803b8:	83 c0 08             	add    $0x8,%eax
  1803bb:	89 01                	mov    %eax,(%rcx)
  1803bd:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1803c0:	48 83 c3 01          	add    $0x1,%rbx
  1803c4:	e9 6f ff ff ff       	jmpq   180338 <printer_vprintf+0x8d>
            width = va_arg(val, int);
  1803c9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1803cd:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1803d1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1803d5:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1803d9:	eb e2                	jmp    1803bd <printer_vprintf+0x112>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1803db:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1803e1:	e9 52 ff ff ff       	jmpq   180338 <printer_vprintf+0x8d>
        int width = -1;
  1803e6:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1803ec:	e9 47 ff ff ff       	jmpq   180338 <printer_vprintf+0x8d>
            ++format;
  1803f1:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1803f5:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1803f9:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1803fc:	80 f9 09             	cmp    $0x9,%cl
  1803ff:	76 13                	jbe    180414 <printer_vprintf+0x169>
            } else if (*format == '*') {
  180401:	3c 2a                	cmp    $0x2a,%al
  180403:	74 32                	je     180437 <printer_vprintf+0x18c>
            ++format;
  180405:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  180408:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  18040f:	e9 34 ff ff ff       	jmpq   180348 <printer_vprintf+0x9d>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  180414:	be 00 00 00 00       	mov    $0x0,%esi
                    precision = 10 * precision + *format++ - '0';
  180419:	48 83 c2 01          	add    $0x1,%rdx
  18041d:	8d 0c b6             	lea    (%rsi,%rsi,4),%ecx
  180420:	0f be c0             	movsbl %al,%eax
  180423:	8d 74 48 d0          	lea    -0x30(%rax,%rcx,2),%esi
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  180427:	0f b6 02             	movzbl (%rdx),%eax
  18042a:	8d 48 d0             	lea    -0x30(%rax),%ecx
  18042d:	80 f9 09             	cmp    $0x9,%cl
  180430:	76 e7                	jbe    180419 <printer_vprintf+0x16e>
                    precision = 10 * precision + *format++ - '0';
  180432:	48 89 d3             	mov    %rdx,%rbx
  180435:	eb 1c                	jmp    180453 <printer_vprintf+0x1a8>
                precision = va_arg(val, int);
  180437:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18043b:	8b 07                	mov    (%rdi),%eax
  18043d:	83 f8 2f             	cmp    $0x2f,%eax
  180440:	77 23                	ja     180465 <printer_vprintf+0x1ba>
  180442:	89 c2                	mov    %eax,%edx
  180444:	48 03 57 10          	add    0x10(%rdi),%rdx
  180448:	83 c0 08             	add    $0x8,%eax
  18044b:	89 07                	mov    %eax,(%rdi)
  18044d:	8b 32                	mov    (%rdx),%esi
                ++format;
  18044f:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  180453:	85 f6                	test   %esi,%esi
  180455:	b8 00 00 00 00       	mov    $0x0,%eax
  18045a:	0f 48 f0             	cmovs  %eax,%esi
  18045d:	89 75 9c             	mov    %esi,-0x64(%rbp)
  180460:	e9 e3 fe ff ff       	jmpq   180348 <printer_vprintf+0x9d>
                precision = va_arg(val, int);
  180465:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180469:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  18046d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180471:	48 89 41 08          	mov    %rax,0x8(%rcx)
  180475:	eb d6                	jmp    18044d <printer_vprintf+0x1a2>
        switch (*format) {
  180477:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  18047c:	e9 f1 00 00 00       	jmpq   180572 <printer_vprintf+0x2c7>
            ++format;
  180481:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  180485:	8b 4d 80             	mov    -0x80(%rbp),%ecx
            goto again;
  180488:	e9 c0 fe ff ff       	jmpq   18034d <printer_vprintf+0xa2>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  18048d:	85 c9                	test   %ecx,%ecx
  18048f:	74 55                	je     1804e6 <printer_vprintf+0x23b>
  180491:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180495:	8b 01                	mov    (%rcx),%eax
  180497:	83 f8 2f             	cmp    $0x2f,%eax
  18049a:	77 38                	ja     1804d4 <printer_vprintf+0x229>
  18049c:	89 c2                	mov    %eax,%edx
  18049e:	48 03 51 10          	add    0x10(%rcx),%rdx
  1804a2:	83 c0 08             	add    $0x8,%eax
  1804a5:	89 01                	mov    %eax,(%rcx)
  1804a7:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1804aa:	48 89 d0             	mov    %rdx,%rax
  1804ad:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1804b1:	49 89 d0             	mov    %rdx,%r8
  1804b4:	49 f7 d8             	neg    %r8
  1804b7:	25 80 00 00 00       	and    $0x80,%eax
  1804bc:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1804c0:	0b 45 a8             	or     -0x58(%rbp),%eax
  1804c3:	83 c8 60             	or     $0x60,%eax
  1804c6:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1804c9:	41 bc c4 0a 18 00    	mov    $0x180ac4,%r12d
            break;
  1804cf:	e9 35 01 00 00       	jmpq   180609 <printer_vprintf+0x35e>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1804d4:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1804d8:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1804dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1804e0:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1804e4:	eb c1                	jmp    1804a7 <printer_vprintf+0x1fc>
  1804e6:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1804ea:	8b 07                	mov    (%rdi),%eax
  1804ec:	83 f8 2f             	cmp    $0x2f,%eax
  1804ef:	77 10                	ja     180501 <printer_vprintf+0x256>
  1804f1:	89 c2                	mov    %eax,%edx
  1804f3:	48 03 57 10          	add    0x10(%rdi),%rdx
  1804f7:	83 c0 08             	add    $0x8,%eax
  1804fa:	89 07                	mov    %eax,(%rdi)
  1804fc:	48 63 12             	movslq (%rdx),%rdx
  1804ff:	eb a9                	jmp    1804aa <printer_vprintf+0x1ff>
  180501:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180505:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180509:	48 8d 42 08          	lea    0x8(%rdx),%rax
  18050d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  180511:	eb e9                	jmp    1804fc <printer_vprintf+0x251>
        int base = 10;
  180513:	be 0a 00 00 00       	mov    $0xa,%esi
  180518:	eb 58                	jmp    180572 <printer_vprintf+0x2c7>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  18051a:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  18051e:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  180522:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180526:	48 89 41 08          	mov    %rax,0x8(%rcx)
  18052a:	eb 60                	jmp    18058c <printer_vprintf+0x2e1>
  18052c:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  180530:	8b 01                	mov    (%rcx),%eax
  180532:	83 f8 2f             	cmp    $0x2f,%eax
  180535:	77 10                	ja     180547 <printer_vprintf+0x29c>
  180537:	89 c2                	mov    %eax,%edx
  180539:	48 03 51 10          	add    0x10(%rcx),%rdx
  18053d:	83 c0 08             	add    $0x8,%eax
  180540:	89 01                	mov    %eax,(%rcx)
  180542:	44 8b 02             	mov    (%rdx),%r8d
  180545:	eb 48                	jmp    18058f <printer_vprintf+0x2e4>
  180547:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18054b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  18054f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  180553:	48 89 47 08          	mov    %rax,0x8(%rdi)
  180557:	eb e9                	jmp    180542 <printer_vprintf+0x297>
  180559:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  18055c:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  180563:	bf b0 0c 18 00       	mov    $0x180cb0,%edi
  180568:	e9 e6 02 00 00       	jmpq   180853 <printer_vprintf+0x5a8>
            base = 16;
  18056d:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  180572:	85 c9                	test   %ecx,%ecx
  180574:	74 b6                	je     18052c <printer_vprintf+0x281>
  180576:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  18057a:	8b 07                	mov    (%rdi),%eax
  18057c:	83 f8 2f             	cmp    $0x2f,%eax
  18057f:	77 99                	ja     18051a <printer_vprintf+0x26f>
  180581:	89 c2                	mov    %eax,%edx
  180583:	48 03 57 10          	add    0x10(%rdi),%rdx
  180587:	83 c0 08             	add    $0x8,%eax
  18058a:	89 07                	mov    %eax,(%rdi)
  18058c:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  18058f:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  180593:	85 f6                	test   %esi,%esi
  180595:	79 c2                	jns    180559 <printer_vprintf+0x2ae>
        base = -base;
  180597:	41 89 f1             	mov    %esi,%r9d
  18059a:	f7 de                	neg    %esi
  18059c:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  1805a3:	bf 90 0c 18 00       	mov    $0x180c90,%edi
  1805a8:	e9 a6 02 00 00       	jmpq   180853 <printer_vprintf+0x5a8>
            num = (uintptr_t) va_arg(val, void*);
  1805ad:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1805b1:	8b 07                	mov    (%rdi),%eax
  1805b3:	83 f8 2f             	cmp    $0x2f,%eax
  1805b6:	77 1c                	ja     1805d4 <printer_vprintf+0x329>
  1805b8:	89 c2                	mov    %eax,%edx
  1805ba:	48 03 57 10          	add    0x10(%rdi),%rdx
  1805be:	83 c0 08             	add    $0x8,%eax
  1805c1:	89 07                	mov    %eax,(%rdi)
  1805c3:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1805c6:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1805cd:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1805d2:	eb c3                	jmp    180597 <printer_vprintf+0x2ec>
            num = (uintptr_t) va_arg(val, void*);
  1805d4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1805d8:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1805dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1805e0:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1805e4:	eb dd                	jmp    1805c3 <printer_vprintf+0x318>
            data = va_arg(val, char*);
  1805e6:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1805ea:	8b 01                	mov    (%rcx),%eax
  1805ec:	83 f8 2f             	cmp    $0x2f,%eax
  1805ef:	0f 87 a9 01 00 00    	ja     18079e <printer_vprintf+0x4f3>
  1805f5:	89 c2                	mov    %eax,%edx
  1805f7:	48 03 51 10          	add    0x10(%rcx),%rdx
  1805fb:	83 c0 08             	add    $0x8,%eax
  1805fe:	89 01                	mov    %eax,(%rcx)
  180600:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  180603:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  180609:	8b 45 a8             	mov    -0x58(%rbp),%eax
  18060c:	83 e0 20             	and    $0x20,%eax
  18060f:	89 45 8c             	mov    %eax,-0x74(%rbp)
  180612:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  180618:	0f 85 25 02 00 00    	jne    180843 <printer_vprintf+0x598>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  18061e:	8b 45 a8             	mov    -0x58(%rbp),%eax
  180621:	89 45 88             	mov    %eax,-0x78(%rbp)
  180624:	83 e0 60             	and    $0x60,%eax
  180627:	83 f8 60             	cmp    $0x60,%eax
  18062a:	0f 84 58 02 00 00    	je     180888 <printer_vprintf+0x5dd>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  180630:	8b 45 a8             	mov    -0x58(%rbp),%eax
  180633:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  180636:	48 c7 45 a0 c4 0a 18 	movq   $0x180ac4,-0x60(%rbp)
  18063d:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  18063e:	83 f8 21             	cmp    $0x21,%eax
  180641:	0f 84 7d 02 00 00    	je     1808c4 <printer_vprintf+0x619>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  180647:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  18064a:	89 c8                	mov    %ecx,%eax
  18064c:	f7 d0                	not    %eax
  18064e:	c1 e8 1f             	shr    $0x1f,%eax
  180651:	89 45 84             	mov    %eax,-0x7c(%rbp)
  180654:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  180658:	0f 85 a2 02 00 00    	jne    180900 <printer_vprintf+0x655>
  18065e:	84 c0                	test   %al,%al
  180660:	0f 84 9a 02 00 00    	je     180900 <printer_vprintf+0x655>
            len = strnlen(data, precision);
  180666:	48 63 f1             	movslq %ecx,%rsi
  180669:	4c 89 e7             	mov    %r12,%rdi
  18066c:	e8 61 fb ff ff       	callq  1801d2 <strnlen>
  180671:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  180674:	8b 45 88             	mov    -0x78(%rbp),%eax
  180677:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  18067a:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  180681:	83 f8 22             	cmp    $0x22,%eax
  180684:	0f 84 ae 02 00 00    	je     180938 <printer_vprintf+0x68d>
        width -= len + zeros + strlen(prefix);
  18068a:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  18068e:	e8 24 fb ff ff       	callq  1801b7 <strlen>
  180693:	8b 55 9c             	mov    -0x64(%rbp),%edx
  180696:	03 55 98             	add    -0x68(%rbp),%edx
  180699:	41 29 d5             	sub    %edx,%r13d
  18069c:	44 89 ea             	mov    %r13d,%edx
  18069f:	29 c2                	sub    %eax,%edx
  1806a1:	89 55 8c             	mov    %edx,-0x74(%rbp)
  1806a4:	41 89 d5             	mov    %edx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1806a7:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1806ab:	75 2d                	jne    1806da <printer_vprintf+0x42f>
  1806ad:	85 d2                	test   %edx,%edx
  1806af:	7e 29                	jle    1806da <printer_vprintf+0x42f>
            p->putc(p, ' ', color);
  1806b1:	44 89 fa             	mov    %r15d,%edx
  1806b4:	be 20 00 00 00       	mov    $0x20,%esi
  1806b9:	4c 89 f7             	mov    %r14,%rdi
  1806bc:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1806bf:	41 83 ed 01          	sub    $0x1,%r13d
  1806c3:	45 85 ed             	test   %r13d,%r13d
  1806c6:	7f e9                	jg     1806b1 <printer_vprintf+0x406>
  1806c8:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1806cb:	85 ff                	test   %edi,%edi
  1806cd:	b8 01 00 00 00       	mov    $0x1,%eax
  1806d2:	0f 4f c7             	cmovg  %edi,%eax
  1806d5:	29 c7                	sub    %eax,%edi
  1806d7:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1806da:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  1806de:	0f b6 01             	movzbl (%rcx),%eax
  1806e1:	84 c0                	test   %al,%al
  1806e3:	74 22                	je     180707 <printer_vprintf+0x45c>
  1806e5:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1806e9:	48 89 cb             	mov    %rcx,%rbx
            p->putc(p, *prefix, color);
  1806ec:	0f b6 f0             	movzbl %al,%esi
  1806ef:	44 89 fa             	mov    %r15d,%edx
  1806f2:	4c 89 f7             	mov    %r14,%rdi
  1806f5:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1806f8:	48 83 c3 01          	add    $0x1,%rbx
  1806fc:	0f b6 03             	movzbl (%rbx),%eax
  1806ff:	84 c0                	test   %al,%al
  180701:	75 e9                	jne    1806ec <printer_vprintf+0x441>
  180703:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  180707:	8b 45 9c             	mov    -0x64(%rbp),%eax
  18070a:	85 c0                	test   %eax,%eax
  18070c:	7e 1d                	jle    18072b <printer_vprintf+0x480>
  18070e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  180712:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  180714:	44 89 fa             	mov    %r15d,%edx
  180717:	be 30 00 00 00       	mov    $0x30,%esi
  18071c:	4c 89 f7             	mov    %r14,%rdi
  18071f:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  180722:	83 eb 01             	sub    $0x1,%ebx
  180725:	75 ed                	jne    180714 <printer_vprintf+0x469>
  180727:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  18072b:	8b 45 98             	mov    -0x68(%rbp),%eax
  18072e:	85 c0                	test   %eax,%eax
  180730:	7e 2a                	jle    18075c <printer_vprintf+0x4b1>
  180732:	8d 40 ff             	lea    -0x1(%rax),%eax
  180735:	49 8d 44 04 01       	lea    0x1(%r12,%rax,1),%rax
  18073a:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  18073e:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  180741:	41 0f b6 34 24       	movzbl (%r12),%esi
  180746:	44 89 fa             	mov    %r15d,%edx
  180749:	4c 89 f7             	mov    %r14,%rdi
  18074c:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  18074f:	49 83 c4 01          	add    $0x1,%r12
  180753:	49 39 dc             	cmp    %rbx,%r12
  180756:	75 e9                	jne    180741 <printer_vprintf+0x496>
  180758:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  18075c:	45 85 ed             	test   %r13d,%r13d
  18075f:	7e 14                	jle    180775 <printer_vprintf+0x4ca>
            p->putc(p, ' ', color);
  180761:	44 89 fa             	mov    %r15d,%edx
  180764:	be 20 00 00 00       	mov    $0x20,%esi
  180769:	4c 89 f7             	mov    %r14,%rdi
  18076c:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  18076f:	41 83 ed 01          	sub    $0x1,%r13d
  180773:	75 ec                	jne    180761 <printer_vprintf+0x4b6>
    for (; *format; ++format) {
  180775:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  180779:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  18077d:	84 c0                	test   %al,%al
  18077f:	0f 84 00 02 00 00    	je     180985 <printer_vprintf+0x6da>
        if (*format != '%') {
  180785:	3c 25                	cmp    $0x25,%al
  180787:	0f 84 53 fb ff ff    	je     1802e0 <printer_vprintf+0x35>
            p->putc(p, *format, color);
  18078d:	0f b6 f0             	movzbl %al,%esi
  180790:	44 89 fa             	mov    %r15d,%edx
  180793:	4c 89 f7             	mov    %r14,%rdi
  180796:	41 ff 16             	callq  *(%r14)
            continue;
  180799:	4c 89 e3             	mov    %r12,%rbx
  18079c:	eb d7                	jmp    180775 <printer_vprintf+0x4ca>
            data = va_arg(val, char*);
  18079e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1807a2:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1807a6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1807aa:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1807ae:	e9 4d fe ff ff       	jmpq   180600 <printer_vprintf+0x355>
            color = va_arg(val, int);
  1807b3:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1807b7:	8b 07                	mov    (%rdi),%eax
  1807b9:	83 f8 2f             	cmp    $0x2f,%eax
  1807bc:	77 10                	ja     1807ce <printer_vprintf+0x523>
  1807be:	89 c2                	mov    %eax,%edx
  1807c0:	48 03 57 10          	add    0x10(%rdi),%rdx
  1807c4:	83 c0 08             	add    $0x8,%eax
  1807c7:	89 07                	mov    %eax,(%rdi)
  1807c9:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1807cc:	eb a7                	jmp    180775 <printer_vprintf+0x4ca>
            color = va_arg(val, int);
  1807ce:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1807d2:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1807d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1807da:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1807de:	eb e9                	jmp    1807c9 <printer_vprintf+0x51e>
            numbuf[0] = va_arg(val, int);
  1807e0:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1807e4:	8b 01                	mov    (%rcx),%eax
  1807e6:	83 f8 2f             	cmp    $0x2f,%eax
  1807e9:	77 23                	ja     18080e <printer_vprintf+0x563>
  1807eb:	89 c2                	mov    %eax,%edx
  1807ed:	48 03 51 10          	add    0x10(%rcx),%rdx
  1807f1:	83 c0 08             	add    $0x8,%eax
  1807f4:	89 01                	mov    %eax,(%rcx)
  1807f6:	8b 02                	mov    (%rdx),%eax
  1807f8:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1807fb:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1807ff:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  180803:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  180809:	e9 fb fd ff ff       	jmpq   180609 <printer_vprintf+0x35e>
            numbuf[0] = va_arg(val, int);
  18080e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  180812:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  180816:	48 8d 42 08          	lea    0x8(%rdx),%rax
  18081a:	48 89 47 08          	mov    %rax,0x8(%rdi)
  18081e:	eb d6                	jmp    1807f6 <printer_vprintf+0x54b>
            numbuf[0] = (*format ? *format : '%');
  180820:	84 d2                	test   %dl,%dl
  180822:	0f 85 3b 01 00 00    	jne    180963 <printer_vprintf+0x6b8>
  180828:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  18082c:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  180830:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  180834:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  180838:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  18083e:	e9 c6 fd ff ff       	jmpq   180609 <printer_vprintf+0x35e>
        if (flags & FLAG_NUMERIC) {
  180843:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  180849:	bf b0 0c 18 00       	mov    $0x180cb0,%edi
        if (flags & FLAG_NUMERIC) {
  18084e:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  180853:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  180857:	4c 89 c1             	mov    %r8,%rcx
  18085a:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  18085e:	48 63 f6             	movslq %esi,%rsi
  180861:	49 83 ec 01          	sub    $0x1,%r12
  180865:	48 89 c8             	mov    %rcx,%rax
  180868:	ba 00 00 00 00       	mov    $0x0,%edx
  18086d:	48 f7 f6             	div    %rsi
  180870:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  180874:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  180878:	48 89 ca             	mov    %rcx,%rdx
  18087b:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  18087e:	48 39 d6             	cmp    %rdx,%rsi
  180881:	76 de                	jbe    180861 <printer_vprintf+0x5b6>
  180883:	e9 96 fd ff ff       	jmpq   18061e <printer_vprintf+0x373>
                prefix = "-";
  180888:	48 c7 45 a0 c7 0a 18 	movq   $0x180ac7,-0x60(%rbp)
  18088f:	00 
            if (flags & FLAG_NEGATIVE) {
  180890:	8b 45 a8             	mov    -0x58(%rbp),%eax
  180893:	a8 80                	test   $0x80,%al
  180895:	0f 85 ac fd ff ff    	jne    180647 <printer_vprintf+0x39c>
                prefix = "+";
  18089b:	48 c7 45 a0 c5 0a 18 	movq   $0x180ac5,-0x60(%rbp)
  1808a2:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1808a3:	a8 10                	test   $0x10,%al
  1808a5:	0f 85 9c fd ff ff    	jne    180647 <printer_vprintf+0x39c>
                prefix = " ";
  1808ab:	a8 08                	test   $0x8,%al
  1808ad:	ba c4 0a 18 00       	mov    $0x180ac4,%edx
  1808b2:	b8 c3 0a 18 00       	mov    $0x180ac3,%eax
  1808b7:	48 0f 44 c2          	cmove  %rdx,%rax
  1808bb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1808bf:	e9 83 fd ff ff       	jmpq   180647 <printer_vprintf+0x39c>
                   && (base == 16 || base == -16)
  1808c4:	41 8d 41 10          	lea    0x10(%r9),%eax
  1808c8:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1808cd:	0f 85 74 fd ff ff    	jne    180647 <printer_vprintf+0x39c>
                   && (num || (flags & FLAG_ALT2))) {
  1808d3:	4d 85 c0             	test   %r8,%r8
  1808d6:	75 0d                	jne    1808e5 <printer_vprintf+0x63a>
  1808d8:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1808df:	0f 84 62 fd ff ff    	je     180647 <printer_vprintf+0x39c>
            prefix = (base == -16 ? "0x" : "0X");
  1808e5:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1808e9:	ba c0 0a 18 00       	mov    $0x180ac0,%edx
  1808ee:	b8 c9 0a 18 00       	mov    $0x180ac9,%eax
  1808f3:	48 0f 44 c2          	cmove  %rdx,%rax
  1808f7:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1808fb:	e9 47 fd ff ff       	jmpq   180647 <printer_vprintf+0x39c>
            len = strlen(data);
  180900:	4c 89 e7             	mov    %r12,%rdi
  180903:	e8 af f8 ff ff       	callq  1801b7 <strlen>
  180908:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  18090b:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  18090f:	0f 84 5f fd ff ff    	je     180674 <printer_vprintf+0x3c9>
  180915:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  180919:	0f 84 55 fd ff ff    	je     180674 <printer_vprintf+0x3c9>
            zeros = precision > len ? precision - len : 0;
  18091f:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  180922:	89 fa                	mov    %edi,%edx
  180924:	29 c2                	sub    %eax,%edx
  180926:	39 c7                	cmp    %eax,%edi
  180928:	b8 00 00 00 00       	mov    $0x0,%eax
  18092d:	0f 4e d0             	cmovle %eax,%edx
  180930:	89 55 9c             	mov    %edx,-0x64(%rbp)
  180933:	e9 52 fd ff ff       	jmpq   18068a <printer_vprintf+0x3df>
                   && len + (int) strlen(prefix) < width) {
  180938:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  18093c:	e8 76 f8 ff ff       	callq  1801b7 <strlen>
  180941:	8b 7d 98             	mov    -0x68(%rbp),%edi
  180944:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  180947:	44 89 e9             	mov    %r13d,%ecx
  18094a:	29 f9                	sub    %edi,%ecx
  18094c:	29 c1                	sub    %eax,%ecx
  18094e:	89 c8                	mov    %ecx,%eax
  180950:	44 39 ea             	cmp    %r13d,%edx
  180953:	b9 00 00 00 00       	mov    $0x0,%ecx
  180958:	0f 4d c1             	cmovge %ecx,%eax
  18095b:	89 45 9c             	mov    %eax,-0x64(%rbp)
  18095e:	e9 27 fd ff ff       	jmpq   18068a <printer_vprintf+0x3df>
            numbuf[0] = (*format ? *format : '%');
  180963:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  180966:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  18096a:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  18096e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  180974:	e9 90 fc ff ff       	jmpq   180609 <printer_vprintf+0x35e>
        int flags = 0;
  180979:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  180980:	e9 ad f9 ff ff       	jmpq   180332 <printer_vprintf+0x87>
}
  180985:	48 83 c4 58          	add    $0x58,%rsp
  180989:	5b                   	pop    %rbx
  18098a:	41 5c                	pop    %r12
  18098c:	41 5d                	pop    %r13
  18098e:	41 5e                	pop    %r14
  180990:	41 5f                	pop    %r15
  180992:	5d                   	pop    %rbp
  180993:	c3                   	retq   

0000000000180994 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  180994:	55                   	push   %rbp
  180995:	48 89 e5             	mov    %rsp,%rbp
  180998:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  18099c:	48 c7 45 f0 92 00 18 	movq   $0x180092,-0x10(%rbp)
  1809a3:	00 
        cpos = 0;
  1809a4:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  1809aa:	b8 00 00 00 00       	mov    $0x0,%eax
  1809af:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1809b2:	48 63 ff             	movslq %edi,%rdi
  1809b5:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1809bc:	00 
  1809bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1809c1:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1809c5:	e8 e1 f8 ff ff       	callq  1802ab <printer_vprintf>
    return cp.cursor - console;
  1809ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1809ce:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1809d4:	48 d1 f8             	sar    %rax
}
  1809d7:	c9                   	leaveq 
  1809d8:	c3                   	retq   

00000000001809d9 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1809d9:	55                   	push   %rbp
  1809da:	48 89 e5             	mov    %rsp,%rbp
  1809dd:	48 83 ec 50          	sub    $0x50,%rsp
  1809e1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1809e5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1809e9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1809ed:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1809f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1809f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1809fc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  180a00:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  180a04:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  180a08:	e8 87 ff ff ff       	callq  180994 <console_vprintf>
}
  180a0d:	c9                   	leaveq 
  180a0e:	c3                   	retq   

0000000000180a0f <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  180a0f:	55                   	push   %rbp
  180a10:	48 89 e5             	mov    %rsp,%rbp
  180a13:	53                   	push   %rbx
  180a14:	48 83 ec 28          	sub    $0x28,%rsp
  180a18:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  180a1b:	48 c7 45 d8 1c 01 18 	movq   $0x18011c,-0x28(%rbp)
  180a22:	00 
    sp.s = s;
  180a23:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  180a27:	48 85 f6             	test   %rsi,%rsi
  180a2a:	75 0e                	jne    180a3a <vsnprintf+0x2b>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  180a2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  180a30:	48 29 d8             	sub    %rbx,%rax
}
  180a33:	48 83 c4 28          	add    $0x28,%rsp
  180a37:	5b                   	pop    %rbx
  180a38:	5d                   	pop    %rbp
  180a39:	c3                   	retq   
        sp.end = s + size - 1;
  180a3a:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  180a3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  180a43:	be 00 00 00 00       	mov    $0x0,%esi
  180a48:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  180a4c:	e8 5a f8 ff ff       	callq  1802ab <printer_vprintf>
        *sp.s = 0;
  180a51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  180a55:	c6 00 00             	movb   $0x0,(%rax)
  180a58:	eb d2                	jmp    180a2c <vsnprintf+0x1d>

0000000000180a5a <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  180a5a:	55                   	push   %rbp
  180a5b:	48 89 e5             	mov    %rsp,%rbp
  180a5e:	48 83 ec 50          	sub    $0x50,%rsp
  180a62:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  180a66:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  180a6a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  180a6e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  180a75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  180a79:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  180a7d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  180a81:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  180a85:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  180a89:	e8 81 ff ff ff       	callq  180a0f <vsnprintf>
    va_end(val);
    return n;
}
  180a8e:	c9                   	leaveq 
  180a8f:	c3                   	retq   

0000000000180a90 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  180a90:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  180a95:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  180a9a:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  180a9f:	48 83 c0 02          	add    $0x2,%rax
  180aa3:	48 39 d0             	cmp    %rdx,%rax
  180aa6:	75 f2                	jne    180a9a <console_clear+0xa>
    }
    cursorpos = 0;
  180aa8:	c7 05 4a 85 f3 ff 00 	movl   $0x0,-0xc7ab6(%rip)        # b8ffc <cursorpos>
  180aaf:	00 00 00 
}
  180ab2:	c3                   	retq   
