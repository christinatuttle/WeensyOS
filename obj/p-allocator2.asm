
obj/p-allocator2.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000140000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  140000:	55                   	push   %rbp
  140001:	48 89 e5             	mov    %rsp,%rbp
  140004:	53                   	push   %rbx
  140005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  140009:	cd 31                	int    $0x31
  14000b:	89 c7                	mov    %eax,%edi
  14000d:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  14000f:	e8 86 02 00 00       	callq  14029a <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  140014:	b8 17 20 14 00       	mov    $0x142017,%eax
  140019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  14001f:	48 89 05 e2 0f 00 00 	mov    %rax,0xfe2(%rip)        # 141008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  140026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  140029:	48 83 e8 01          	sub    $0x1,%rax
  14002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  140033:	48 89 05 d6 0f 00 00 	mov    %rax,0xfd6(%rip)        # 141010 <stack_bottom>
  14003a:	eb 02                	jmp    14003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  14003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  14003e:	e8 1d 02 00 00       	callq  140260 <rand>
  140043:	89 c2                	mov    %eax,%edx
  140045:	48 98                	cltq   
  140047:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
  14004e:	48 c1 f8 25          	sar    $0x25,%rax
  140052:	89 d1                	mov    %edx,%ecx
  140054:	c1 f9 1f             	sar    $0x1f,%ecx
  140057:	29 c8                	sub    %ecx,%eax
  140059:	6b c0 64             	imul   $0x64,%eax,%eax
  14005c:	29 c2                	sub    %eax,%edx
  14005e:	39 da                	cmp    %ebx,%edx
  140060:	7d da                	jge    14003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  140062:	48 8b 3d 9f 0f 00 00 	mov    0xf9f(%rip),%rdi        # 141008 <heap_top>
  140069:	48 3b 3d a0 0f 00 00 	cmp    0xfa0(%rip),%rdi        # 141010 <stack_bottom>
  140070:	74 1c                	je     14008e <process_main+0x8e>
//    Allocate a page of memory at address `addr`. `Addr` must be page-aligned
//    (i.e., a multiple of PAGESIZE == 4096). Returns 0 on success and -1
//    on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  140072:	cd 33                	int    $0x33
  140074:	85 c0                	test   %eax,%eax
  140076:	78 16                	js     14008e <process_main+0x8e>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  140078:	48 8b 05 89 0f 00 00 	mov    0xf89(%rip),%rax        # 141008 <heap_top>
  14007f:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  140081:	48 81 05 7c 0f 00 00 	addq   $0x1000,0xf7c(%rip)        # 141008 <heap_top>
  140088:	00 10 00 00 
  14008c:	eb ae                	jmp    14003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  14008e:	cd 32                	int    $0x32
  140090:	eb fc                	jmp    14008e <process_main+0x8e>

0000000000140092 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  140092:	41 89 d0             	mov    %edx,%r8d
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  140095:	48 81 7f 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rdi)
  14009c:	00 
  14009d:	72 08                	jb     1400a7 <console_putc+0x15>
        cp->cursor = console;
  14009f:	48 c7 47 08 00 80 0b 	movq   $0xb8000,0x8(%rdi)
  1400a6:	00 
    }
    if (c == '\n') {
  1400a7:	40 80 fe 0a          	cmp    $0xa,%sil
  1400ab:	74 17                	je     1400c4 <console_putc+0x32>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1400ad:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1400b1:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1400b5:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1400b9:	40 0f b6 f6          	movzbl %sil,%esi
  1400bd:	44 09 c6             	or     %r8d,%esi
  1400c0:	66 89 30             	mov    %si,(%rax)
    }
}
  1400c3:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1400c4:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  1400c8:	48 81 ee 00 80 0b 00 	sub    $0xb8000,%rsi
  1400cf:	48 89 f1             	mov    %rsi,%rcx
  1400d2:	48 d1 f9             	sar    %rcx
  1400d5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1400dc:	66 66 66 
  1400df:	48 89 c8             	mov    %rcx,%rax
  1400e2:	48 f7 ea             	imul   %rdx
  1400e5:	48 c1 fa 05          	sar    $0x5,%rdx
  1400e9:	48 c1 fe 3f          	sar    $0x3f,%rsi
  1400ed:	48 29 f2             	sub    %rsi,%rdx
  1400f0:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  1400f4:	48 c1 e0 04          	shl    $0x4,%rax
  1400f8:	89 ca                	mov    %ecx,%edx
  1400fa:	29 c2                	sub    %eax,%edx
  1400fc:	89 d0                	mov    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1400fe:	44 89 c6             	mov    %r8d,%esi
  140101:	83 ce 20             	or     $0x20,%esi
  140104:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  140108:	4c 8d 41 02          	lea    0x2(%rcx),%r8
  14010c:	4c 89 47 08          	mov    %r8,0x8(%rdi)
  140110:	66 89 31             	mov    %si,(%rcx)
        for (; pos != 80; pos++) {
  140113:	83 c0 01             	add    $0x1,%eax
  140116:	83 f8 50             	cmp    $0x50,%eax
  140119:	75 e9                	jne    140104 <console_putc+0x72>
  14011b:	c3                   	retq   

000000000014011c <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  14011c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  140120:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  140124:	73 0b                	jae    140131 <string_putc+0x15>
        *sp->s++ = c;
  140126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  14012a:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  14012e:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  140131:	c3                   	retq   

0000000000140132 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  140132:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  140135:	48 85 d2             	test   %rdx,%rdx
  140138:	74 17                	je     140151 <memcpy+0x1f>
  14013a:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  14013f:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  140144:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  140148:	48 83 c1 01          	add    $0x1,%rcx
  14014c:	48 39 d1             	cmp    %rdx,%rcx
  14014f:	75 ee                	jne    14013f <memcpy+0xd>
}
  140151:	c3                   	retq   

0000000000140152 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  140152:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  140155:	48 39 fe             	cmp    %rdi,%rsi
  140158:	72 1d                	jb     140177 <memmove+0x25>
        while (n-- > 0) {
  14015a:	b9 00 00 00 00       	mov    $0x0,%ecx
  14015f:	48 85 d2             	test   %rdx,%rdx
  140162:	74 12                	je     140176 <memmove+0x24>
            *d++ = *s++;
  140164:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  140168:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  14016c:	48 83 c1 01          	add    $0x1,%rcx
  140170:	48 39 ca             	cmp    %rcx,%rdx
  140173:	75 ef                	jne    140164 <memmove+0x12>
}
  140175:	c3                   	retq   
  140176:	c3                   	retq   
    if (s < d && s + n > d) {
  140177:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  14017b:	48 39 cf             	cmp    %rcx,%rdi
  14017e:	73 da                	jae    14015a <memmove+0x8>
        while (n-- > 0) {
  140180:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  140184:	48 85 d2             	test   %rdx,%rdx
  140187:	74 ec                	je     140175 <memmove+0x23>
            *--d = *--s;
  140189:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  14018d:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  140190:	48 83 e9 01          	sub    $0x1,%rcx
  140194:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  140198:	75 ef                	jne    140189 <memmove+0x37>
  14019a:	c3                   	retq   

000000000014019b <memset>:
void* memset(void* v, int c, size_t n) {
  14019b:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  14019e:	48 85 d2             	test   %rdx,%rdx
  1401a1:	74 13                	je     1401b6 <memset+0x1b>
  1401a3:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  1401a7:	48 89 fa             	mov    %rdi,%rdx
        *p = c;
  1401aa:	40 88 32             	mov    %sil,(%rdx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1401ad:	48 83 c2 01          	add    $0x1,%rdx
  1401b1:	48 39 d1             	cmp    %rdx,%rcx
  1401b4:	75 f4                	jne    1401aa <memset+0xf>
}
  1401b6:	c3                   	retq   

00000000001401b7 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1401b7:	80 3f 00             	cmpb   $0x0,(%rdi)
  1401ba:	74 10                	je     1401cc <strlen+0x15>
  1401bc:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1401c1:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1401c5:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1401c9:	75 f6                	jne    1401c1 <strlen+0xa>
  1401cb:	c3                   	retq   
  1401cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1401d1:	c3                   	retq   

00000000001401d2 <strnlen>:
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1401d2:	b8 00 00 00 00       	mov    $0x0,%eax
  1401d7:	48 85 f6             	test   %rsi,%rsi
  1401da:	74 10                	je     1401ec <strnlen+0x1a>
  1401dc:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1401e0:	74 09                	je     1401eb <strnlen+0x19>
        ++n;
  1401e2:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1401e6:	48 39 c6             	cmp    %rax,%rsi
  1401e9:	75 f1                	jne    1401dc <strnlen+0xa>
}
  1401eb:	c3                   	retq   
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1401ec:	48 89 f0             	mov    %rsi,%rax
  1401ef:	c3                   	retq   

00000000001401f0 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1401f0:	48 89 f8             	mov    %rdi,%rax
  1401f3:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1401f8:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1401fc:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1401ff:	48 83 c2 01          	add    $0x1,%rdx
  140203:	84 c9                	test   %cl,%cl
  140205:	75 f1                	jne    1401f8 <strcpy+0x8>
}
  140207:	c3                   	retq   

0000000000140208 <strcmp>:
    while (*a && *b && *a == *b) {
  140208:	0f b6 17             	movzbl (%rdi),%edx
  14020b:	84 d2                	test   %dl,%dl
  14020d:	74 1a                	je     140229 <strcmp+0x21>
  14020f:	0f b6 06             	movzbl (%rsi),%eax
  140212:	38 d0                	cmp    %dl,%al
  140214:	75 13                	jne    140229 <strcmp+0x21>
  140216:	84 c0                	test   %al,%al
  140218:	74 0f                	je     140229 <strcmp+0x21>
        ++a, ++b;
  14021a:	48 83 c7 01          	add    $0x1,%rdi
  14021e:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  140222:	0f b6 17             	movzbl (%rdi),%edx
  140225:	84 d2                	test   %dl,%dl
  140227:	75 e6                	jne    14020f <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  140229:	0f b6 0e             	movzbl (%rsi),%ecx
  14022c:	38 ca                	cmp    %cl,%dl
  14022e:	0f 97 c0             	seta   %al
  140231:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  140234:	83 d8 00             	sbb    $0x0,%eax
}
  140237:	c3                   	retq   

0000000000140238 <strchr>:
    while (*s && *s != (char) c) {
  140238:	0f b6 07             	movzbl (%rdi),%eax
  14023b:	84 c0                	test   %al,%al
  14023d:	74 10                	je     14024f <strchr+0x17>
  14023f:	40 38 f0             	cmp    %sil,%al
  140242:	74 18                	je     14025c <strchr+0x24>
        ++s;
  140244:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  140248:	0f b6 07             	movzbl (%rdi),%eax
  14024b:	84 c0                	test   %al,%al
  14024d:	75 f0                	jne    14023f <strchr+0x7>
        return NULL;
  14024f:	40 84 f6             	test   %sil,%sil
  140252:	b8 00 00 00 00       	mov    $0x0,%eax
  140257:	48 0f 44 c7          	cmove  %rdi,%rax
}
  14025b:	c3                   	retq   
  14025c:	48 89 f8             	mov    %rdi,%rax
  14025f:	c3                   	retq   

0000000000140260 <rand>:
    if (!rand_seed_set) {
  140260:	83 3d 9d 0d 00 00 00 	cmpl   $0x0,0xd9d(%rip)        # 141004 <rand_seed_set>
  140267:	74 1b                	je     140284 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  140269:	69 05 8d 0d 00 00 0d 	imul   $0x19660d,0xd8d(%rip),%eax        # 141000 <rand_seed>
  140270:	66 19 00 
  140273:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  140278:	89 05 82 0d 00 00    	mov    %eax,0xd82(%rip)        # 141000 <rand_seed>
    return rand_seed & RAND_MAX;
  14027e:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  140283:	c3                   	retq   
    rand_seed = seed;
  140284:	c7 05 72 0d 00 00 9e 	movl   $0x30d4879e,0xd72(%rip)        # 141000 <rand_seed>
  14028b:	87 d4 30 
    rand_seed_set = 1;
  14028e:	c7 05 6c 0d 00 00 01 	movl   $0x1,0xd6c(%rip)        # 141004 <rand_seed_set>
  140295:	00 00 00 
}
  140298:	eb cf                	jmp    140269 <rand+0x9>

000000000014029a <srand>:
    rand_seed = seed;
  14029a:	89 3d 60 0d 00 00    	mov    %edi,0xd60(%rip)        # 141000 <rand_seed>
    rand_seed_set = 1;
  1402a0:	c7 05 5a 0d 00 00 01 	movl   $0x1,0xd5a(%rip)        # 141004 <rand_seed_set>
  1402a7:	00 00 00 
}
  1402aa:	c3                   	retq   

00000000001402ab <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1402ab:	55                   	push   %rbp
  1402ac:	48 89 e5             	mov    %rsp,%rbp
  1402af:	41 57                	push   %r15
  1402b1:	41 56                	push   %r14
  1402b3:	41 55                	push   %r13
  1402b5:	41 54                	push   %r12
  1402b7:	53                   	push   %rbx
  1402b8:	48 83 ec 58          	sub    $0x58,%rsp
  1402bc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1402c0:	0f b6 02             	movzbl (%rdx),%eax
  1402c3:	84 c0                	test   %al,%al
  1402c5:	0f 84 ba 06 00 00    	je     140985 <printer_vprintf+0x6da>
  1402cb:	49 89 fe             	mov    %rdi,%r14
  1402ce:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1402d1:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%rbp)
  1402d8:	41 89 f7             	mov    %esi,%r15d
  1402db:	e9 a5 04 00 00       	jmpq   140785 <printer_vprintf+0x4da>
        for (++format; *format; ++format) {
  1402e0:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1402e5:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1402eb:	45 84 e4             	test   %r12b,%r12b
  1402ee:	0f 84 85 06 00 00    	je     140979 <printer_vprintf+0x6ce>
        int flags = 0;
  1402f4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1402fa:	41 0f be f4          	movsbl %r12b,%esi
  1402fe:	bf c1 0c 14 00       	mov    $0x140cc1,%edi
  140303:	e8 30 ff ff ff       	callq  140238 <strchr>
  140308:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  14030b:	48 85 c0             	test   %rax,%rax
  14030e:	74 55                	je     140365 <printer_vprintf+0xba>
                flags |= 1 << (flagc - flag_chars);
  140310:	48 81 e9 c1 0c 14 00 	sub    $0x140cc1,%rcx
  140317:	b8 01 00 00 00       	mov    $0x1,%eax
  14031c:	d3 e0                	shl    %cl,%eax
  14031e:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  140321:	48 83 c3 01          	add    $0x1,%rbx
  140325:	44 0f b6 23          	movzbl (%rbx),%r12d
  140329:	45 84 e4             	test   %r12b,%r12b
  14032c:	75 cc                	jne    1402fa <printer_vprintf+0x4f>
  14032e:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  140332:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  140338:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  14033f:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  140342:	0f 84 a9 00 00 00    	je     1403f1 <printer_vprintf+0x146>
        int length = 0;
  140348:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  14034d:	0f b6 13             	movzbl (%rbx),%edx
  140350:	8d 42 bd             	lea    -0x43(%rdx),%eax
  140353:	3c 37                	cmp    $0x37,%al
  140355:	0f 87 c5 04 00 00    	ja     140820 <printer_vprintf+0x575>
  14035b:	0f b6 c0             	movzbl %al,%eax
  14035e:	ff 24 c5 d0 0a 14 00 	jmpq   *0x140ad0(,%rax,8)
  140365:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        if (*format >= '1' && *format <= '9') {
  140369:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  14036e:	3c 08                	cmp    $0x8,%al
  140370:	77 2f                	ja     1403a1 <printer_vprintf+0xf6>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  140372:	0f b6 03             	movzbl (%rbx),%eax
  140375:	8d 50 d0             	lea    -0x30(%rax),%edx
  140378:	80 fa 09             	cmp    $0x9,%dl
  14037b:	77 5e                	ja     1403db <printer_vprintf+0x130>
  14037d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  140383:	48 83 c3 01          	add    $0x1,%rbx
  140387:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  14038c:	0f be c0             	movsbl %al,%eax
  14038f:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  140394:	0f b6 03             	movzbl (%rbx),%eax
  140397:	8d 50 d0             	lea    -0x30(%rax),%edx
  14039a:	80 fa 09             	cmp    $0x9,%dl
  14039d:	76 e4                	jbe    140383 <printer_vprintf+0xd8>
  14039f:	eb 97                	jmp    140338 <printer_vprintf+0x8d>
        } else if (*format == '*') {
  1403a1:	41 80 fc 2a          	cmp    $0x2a,%r12b
  1403a5:	75 3f                	jne    1403e6 <printer_vprintf+0x13b>
            width = va_arg(val, int);
  1403a7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1403ab:	8b 01                	mov    (%rcx),%eax
  1403ad:	83 f8 2f             	cmp    $0x2f,%eax
  1403b0:	77 17                	ja     1403c9 <printer_vprintf+0x11e>
  1403b2:	89 c2                	mov    %eax,%edx
  1403b4:	48 03 51 10          	add    0x10(%rcx),%rdx
  1403b8:	83 c0 08             	add    $0x8,%eax
  1403bb:	89 01                	mov    %eax,(%rcx)
  1403bd:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1403c0:	48 83 c3 01          	add    $0x1,%rbx
  1403c4:	e9 6f ff ff ff       	jmpq   140338 <printer_vprintf+0x8d>
            width = va_arg(val, int);
  1403c9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1403cd:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1403d1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1403d5:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1403d9:	eb e2                	jmp    1403bd <printer_vprintf+0x112>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1403db:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1403e1:	e9 52 ff ff ff       	jmpq   140338 <printer_vprintf+0x8d>
        int width = -1;
  1403e6:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1403ec:	e9 47 ff ff ff       	jmpq   140338 <printer_vprintf+0x8d>
            ++format;
  1403f1:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1403f5:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1403f9:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1403fc:	80 f9 09             	cmp    $0x9,%cl
  1403ff:	76 13                	jbe    140414 <printer_vprintf+0x169>
            } else if (*format == '*') {
  140401:	3c 2a                	cmp    $0x2a,%al
  140403:	74 32                	je     140437 <printer_vprintf+0x18c>
            ++format;
  140405:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  140408:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  14040f:	e9 34 ff ff ff       	jmpq   140348 <printer_vprintf+0x9d>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  140414:	be 00 00 00 00       	mov    $0x0,%esi
                    precision = 10 * precision + *format++ - '0';
  140419:	48 83 c2 01          	add    $0x1,%rdx
  14041d:	8d 0c b6             	lea    (%rsi,%rsi,4),%ecx
  140420:	0f be c0             	movsbl %al,%eax
  140423:	8d 74 48 d0          	lea    -0x30(%rax,%rcx,2),%esi
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  140427:	0f b6 02             	movzbl (%rdx),%eax
  14042a:	8d 48 d0             	lea    -0x30(%rax),%ecx
  14042d:	80 f9 09             	cmp    $0x9,%cl
  140430:	76 e7                	jbe    140419 <printer_vprintf+0x16e>
                    precision = 10 * precision + *format++ - '0';
  140432:	48 89 d3             	mov    %rdx,%rbx
  140435:	eb 1c                	jmp    140453 <printer_vprintf+0x1a8>
                precision = va_arg(val, int);
  140437:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14043b:	8b 07                	mov    (%rdi),%eax
  14043d:	83 f8 2f             	cmp    $0x2f,%eax
  140440:	77 23                	ja     140465 <printer_vprintf+0x1ba>
  140442:	89 c2                	mov    %eax,%edx
  140444:	48 03 57 10          	add    0x10(%rdi),%rdx
  140448:	83 c0 08             	add    $0x8,%eax
  14044b:	89 07                	mov    %eax,(%rdi)
  14044d:	8b 32                	mov    (%rdx),%esi
                ++format;
  14044f:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  140453:	85 f6                	test   %esi,%esi
  140455:	b8 00 00 00 00       	mov    $0x0,%eax
  14045a:	0f 48 f0             	cmovs  %eax,%esi
  14045d:	89 75 9c             	mov    %esi,-0x64(%rbp)
  140460:	e9 e3 fe ff ff       	jmpq   140348 <printer_vprintf+0x9d>
                precision = va_arg(val, int);
  140465:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140469:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  14046d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140471:	48 89 41 08          	mov    %rax,0x8(%rcx)
  140475:	eb d6                	jmp    14044d <printer_vprintf+0x1a2>
        switch (*format) {
  140477:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  14047c:	e9 f1 00 00 00       	jmpq   140572 <printer_vprintf+0x2c7>
            ++format;
  140481:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  140485:	8b 4d 80             	mov    -0x80(%rbp),%ecx
            goto again;
  140488:	e9 c0 fe ff ff       	jmpq   14034d <printer_vprintf+0xa2>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  14048d:	85 c9                	test   %ecx,%ecx
  14048f:	74 55                	je     1404e6 <printer_vprintf+0x23b>
  140491:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140495:	8b 01                	mov    (%rcx),%eax
  140497:	83 f8 2f             	cmp    $0x2f,%eax
  14049a:	77 38                	ja     1404d4 <printer_vprintf+0x229>
  14049c:	89 c2                	mov    %eax,%edx
  14049e:	48 03 51 10          	add    0x10(%rcx),%rdx
  1404a2:	83 c0 08             	add    $0x8,%eax
  1404a5:	89 01                	mov    %eax,(%rcx)
  1404a7:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1404aa:	48 89 d0             	mov    %rdx,%rax
  1404ad:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1404b1:	49 89 d0             	mov    %rdx,%r8
  1404b4:	49 f7 d8             	neg    %r8
  1404b7:	25 80 00 00 00       	and    $0x80,%eax
  1404bc:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1404c0:	0b 45 a8             	or     -0x58(%rbp),%eax
  1404c3:	83 c8 60             	or     $0x60,%eax
  1404c6:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1404c9:	41 bc c4 0a 14 00    	mov    $0x140ac4,%r12d
            break;
  1404cf:	e9 35 01 00 00       	jmpq   140609 <printer_vprintf+0x35e>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1404d4:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1404d8:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1404dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1404e0:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1404e4:	eb c1                	jmp    1404a7 <printer_vprintf+0x1fc>
  1404e6:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1404ea:	8b 07                	mov    (%rdi),%eax
  1404ec:	83 f8 2f             	cmp    $0x2f,%eax
  1404ef:	77 10                	ja     140501 <printer_vprintf+0x256>
  1404f1:	89 c2                	mov    %eax,%edx
  1404f3:	48 03 57 10          	add    0x10(%rdi),%rdx
  1404f7:	83 c0 08             	add    $0x8,%eax
  1404fa:	89 07                	mov    %eax,(%rdi)
  1404fc:	48 63 12             	movslq (%rdx),%rdx
  1404ff:	eb a9                	jmp    1404aa <printer_vprintf+0x1ff>
  140501:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140505:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140509:	48 8d 42 08          	lea    0x8(%rdx),%rax
  14050d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  140511:	eb e9                	jmp    1404fc <printer_vprintf+0x251>
        int base = 10;
  140513:	be 0a 00 00 00       	mov    $0xa,%esi
  140518:	eb 58                	jmp    140572 <printer_vprintf+0x2c7>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  14051a:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  14051e:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140522:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140526:	48 89 41 08          	mov    %rax,0x8(%rcx)
  14052a:	eb 60                	jmp    14058c <printer_vprintf+0x2e1>
  14052c:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140530:	8b 01                	mov    (%rcx),%eax
  140532:	83 f8 2f             	cmp    $0x2f,%eax
  140535:	77 10                	ja     140547 <printer_vprintf+0x29c>
  140537:	89 c2                	mov    %eax,%edx
  140539:	48 03 51 10          	add    0x10(%rcx),%rdx
  14053d:	83 c0 08             	add    $0x8,%eax
  140540:	89 01                	mov    %eax,(%rcx)
  140542:	44 8b 02             	mov    (%rdx),%r8d
  140545:	eb 48                	jmp    14058f <printer_vprintf+0x2e4>
  140547:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14054b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  14054f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140553:	48 89 47 08          	mov    %rax,0x8(%rdi)
  140557:	eb e9                	jmp    140542 <printer_vprintf+0x297>
  140559:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  14055c:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  140563:	bf b0 0c 14 00       	mov    $0x140cb0,%edi
  140568:	e9 e6 02 00 00       	jmpq   140853 <printer_vprintf+0x5a8>
            base = 16;
  14056d:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  140572:	85 c9                	test   %ecx,%ecx
  140574:	74 b6                	je     14052c <printer_vprintf+0x281>
  140576:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14057a:	8b 07                	mov    (%rdi),%eax
  14057c:	83 f8 2f             	cmp    $0x2f,%eax
  14057f:	77 99                	ja     14051a <printer_vprintf+0x26f>
  140581:	89 c2                	mov    %eax,%edx
  140583:	48 03 57 10          	add    0x10(%rdi),%rdx
  140587:	83 c0 08             	add    $0x8,%eax
  14058a:	89 07                	mov    %eax,(%rdi)
  14058c:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  14058f:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  140593:	85 f6                	test   %esi,%esi
  140595:	79 c2                	jns    140559 <printer_vprintf+0x2ae>
        base = -base;
  140597:	41 89 f1             	mov    %esi,%r9d
  14059a:	f7 de                	neg    %esi
  14059c:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  1405a3:	bf 90 0c 14 00       	mov    $0x140c90,%edi
  1405a8:	e9 a6 02 00 00       	jmpq   140853 <printer_vprintf+0x5a8>
            num = (uintptr_t) va_arg(val, void*);
  1405ad:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1405b1:	8b 07                	mov    (%rdi),%eax
  1405b3:	83 f8 2f             	cmp    $0x2f,%eax
  1405b6:	77 1c                	ja     1405d4 <printer_vprintf+0x329>
  1405b8:	89 c2                	mov    %eax,%edx
  1405ba:	48 03 57 10          	add    0x10(%rdi),%rdx
  1405be:	83 c0 08             	add    $0x8,%eax
  1405c1:	89 07                	mov    %eax,(%rdi)
  1405c3:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1405c6:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1405cd:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1405d2:	eb c3                	jmp    140597 <printer_vprintf+0x2ec>
            num = (uintptr_t) va_arg(val, void*);
  1405d4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1405d8:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1405dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1405e0:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1405e4:	eb dd                	jmp    1405c3 <printer_vprintf+0x318>
            data = va_arg(val, char*);
  1405e6:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1405ea:	8b 01                	mov    (%rcx),%eax
  1405ec:	83 f8 2f             	cmp    $0x2f,%eax
  1405ef:	0f 87 a9 01 00 00    	ja     14079e <printer_vprintf+0x4f3>
  1405f5:	89 c2                	mov    %eax,%edx
  1405f7:	48 03 51 10          	add    0x10(%rcx),%rdx
  1405fb:	83 c0 08             	add    $0x8,%eax
  1405fe:	89 01                	mov    %eax,(%rcx)
  140600:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  140603:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  140609:	8b 45 a8             	mov    -0x58(%rbp),%eax
  14060c:	83 e0 20             	and    $0x20,%eax
  14060f:	89 45 8c             	mov    %eax,-0x74(%rbp)
  140612:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  140618:	0f 85 25 02 00 00    	jne    140843 <printer_vprintf+0x598>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  14061e:	8b 45 a8             	mov    -0x58(%rbp),%eax
  140621:	89 45 88             	mov    %eax,-0x78(%rbp)
  140624:	83 e0 60             	and    $0x60,%eax
  140627:	83 f8 60             	cmp    $0x60,%eax
  14062a:	0f 84 58 02 00 00    	je     140888 <printer_vprintf+0x5dd>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  140630:	8b 45 a8             	mov    -0x58(%rbp),%eax
  140633:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  140636:	48 c7 45 a0 c4 0a 14 	movq   $0x140ac4,-0x60(%rbp)
  14063d:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  14063e:	83 f8 21             	cmp    $0x21,%eax
  140641:	0f 84 7d 02 00 00    	je     1408c4 <printer_vprintf+0x619>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  140647:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  14064a:	89 c8                	mov    %ecx,%eax
  14064c:	f7 d0                	not    %eax
  14064e:	c1 e8 1f             	shr    $0x1f,%eax
  140651:	89 45 84             	mov    %eax,-0x7c(%rbp)
  140654:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  140658:	0f 85 a2 02 00 00    	jne    140900 <printer_vprintf+0x655>
  14065e:	84 c0                	test   %al,%al
  140660:	0f 84 9a 02 00 00    	je     140900 <printer_vprintf+0x655>
            len = strnlen(data, precision);
  140666:	48 63 f1             	movslq %ecx,%rsi
  140669:	4c 89 e7             	mov    %r12,%rdi
  14066c:	e8 61 fb ff ff       	callq  1401d2 <strnlen>
  140671:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  140674:	8b 45 88             	mov    -0x78(%rbp),%eax
  140677:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  14067a:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  140681:	83 f8 22             	cmp    $0x22,%eax
  140684:	0f 84 ae 02 00 00    	je     140938 <printer_vprintf+0x68d>
        width -= len + zeros + strlen(prefix);
  14068a:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  14068e:	e8 24 fb ff ff       	callq  1401b7 <strlen>
  140693:	8b 55 9c             	mov    -0x64(%rbp),%edx
  140696:	03 55 98             	add    -0x68(%rbp),%edx
  140699:	41 29 d5             	sub    %edx,%r13d
  14069c:	44 89 ea             	mov    %r13d,%edx
  14069f:	29 c2                	sub    %eax,%edx
  1406a1:	89 55 8c             	mov    %edx,-0x74(%rbp)
  1406a4:	41 89 d5             	mov    %edx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1406a7:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1406ab:	75 2d                	jne    1406da <printer_vprintf+0x42f>
  1406ad:	85 d2                	test   %edx,%edx
  1406af:	7e 29                	jle    1406da <printer_vprintf+0x42f>
            p->putc(p, ' ', color);
  1406b1:	44 89 fa             	mov    %r15d,%edx
  1406b4:	be 20 00 00 00       	mov    $0x20,%esi
  1406b9:	4c 89 f7             	mov    %r14,%rdi
  1406bc:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1406bf:	41 83 ed 01          	sub    $0x1,%r13d
  1406c3:	45 85 ed             	test   %r13d,%r13d
  1406c6:	7f e9                	jg     1406b1 <printer_vprintf+0x406>
  1406c8:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1406cb:	85 ff                	test   %edi,%edi
  1406cd:	b8 01 00 00 00       	mov    $0x1,%eax
  1406d2:	0f 4f c7             	cmovg  %edi,%eax
  1406d5:	29 c7                	sub    %eax,%edi
  1406d7:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1406da:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  1406de:	0f b6 01             	movzbl (%rcx),%eax
  1406e1:	84 c0                	test   %al,%al
  1406e3:	74 22                	je     140707 <printer_vprintf+0x45c>
  1406e5:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1406e9:	48 89 cb             	mov    %rcx,%rbx
            p->putc(p, *prefix, color);
  1406ec:	0f b6 f0             	movzbl %al,%esi
  1406ef:	44 89 fa             	mov    %r15d,%edx
  1406f2:	4c 89 f7             	mov    %r14,%rdi
  1406f5:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1406f8:	48 83 c3 01          	add    $0x1,%rbx
  1406fc:	0f b6 03             	movzbl (%rbx),%eax
  1406ff:	84 c0                	test   %al,%al
  140701:	75 e9                	jne    1406ec <printer_vprintf+0x441>
  140703:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  140707:	8b 45 9c             	mov    -0x64(%rbp),%eax
  14070a:	85 c0                	test   %eax,%eax
  14070c:	7e 1d                	jle    14072b <printer_vprintf+0x480>
  14070e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  140712:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  140714:	44 89 fa             	mov    %r15d,%edx
  140717:	be 30 00 00 00       	mov    $0x30,%esi
  14071c:	4c 89 f7             	mov    %r14,%rdi
  14071f:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  140722:	83 eb 01             	sub    $0x1,%ebx
  140725:	75 ed                	jne    140714 <printer_vprintf+0x469>
  140727:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  14072b:	8b 45 98             	mov    -0x68(%rbp),%eax
  14072e:	85 c0                	test   %eax,%eax
  140730:	7e 2a                	jle    14075c <printer_vprintf+0x4b1>
  140732:	8d 40 ff             	lea    -0x1(%rax),%eax
  140735:	49 8d 44 04 01       	lea    0x1(%r12,%rax,1),%rax
  14073a:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  14073e:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  140741:	41 0f b6 34 24       	movzbl (%r12),%esi
  140746:	44 89 fa             	mov    %r15d,%edx
  140749:	4c 89 f7             	mov    %r14,%rdi
  14074c:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  14074f:	49 83 c4 01          	add    $0x1,%r12
  140753:	49 39 dc             	cmp    %rbx,%r12
  140756:	75 e9                	jne    140741 <printer_vprintf+0x496>
  140758:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  14075c:	45 85 ed             	test   %r13d,%r13d
  14075f:	7e 14                	jle    140775 <printer_vprintf+0x4ca>
            p->putc(p, ' ', color);
  140761:	44 89 fa             	mov    %r15d,%edx
  140764:	be 20 00 00 00       	mov    $0x20,%esi
  140769:	4c 89 f7             	mov    %r14,%rdi
  14076c:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  14076f:	41 83 ed 01          	sub    $0x1,%r13d
  140773:	75 ec                	jne    140761 <printer_vprintf+0x4b6>
    for (; *format; ++format) {
  140775:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  140779:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  14077d:	84 c0                	test   %al,%al
  14077f:	0f 84 00 02 00 00    	je     140985 <printer_vprintf+0x6da>
        if (*format != '%') {
  140785:	3c 25                	cmp    $0x25,%al
  140787:	0f 84 53 fb ff ff    	je     1402e0 <printer_vprintf+0x35>
            p->putc(p, *format, color);
  14078d:	0f b6 f0             	movzbl %al,%esi
  140790:	44 89 fa             	mov    %r15d,%edx
  140793:	4c 89 f7             	mov    %r14,%rdi
  140796:	41 ff 16             	callq  *(%r14)
            continue;
  140799:	4c 89 e3             	mov    %r12,%rbx
  14079c:	eb d7                	jmp    140775 <printer_vprintf+0x4ca>
            data = va_arg(val, char*);
  14079e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1407a2:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1407a6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1407aa:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1407ae:	e9 4d fe ff ff       	jmpq   140600 <printer_vprintf+0x355>
            color = va_arg(val, int);
  1407b3:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1407b7:	8b 07                	mov    (%rdi),%eax
  1407b9:	83 f8 2f             	cmp    $0x2f,%eax
  1407bc:	77 10                	ja     1407ce <printer_vprintf+0x523>
  1407be:	89 c2                	mov    %eax,%edx
  1407c0:	48 03 57 10          	add    0x10(%rdi),%rdx
  1407c4:	83 c0 08             	add    $0x8,%eax
  1407c7:	89 07                	mov    %eax,(%rdi)
  1407c9:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1407cc:	eb a7                	jmp    140775 <printer_vprintf+0x4ca>
            color = va_arg(val, int);
  1407ce:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1407d2:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1407d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1407da:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1407de:	eb e9                	jmp    1407c9 <printer_vprintf+0x51e>
            numbuf[0] = va_arg(val, int);
  1407e0:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1407e4:	8b 01                	mov    (%rcx),%eax
  1407e6:	83 f8 2f             	cmp    $0x2f,%eax
  1407e9:	77 23                	ja     14080e <printer_vprintf+0x563>
  1407eb:	89 c2                	mov    %eax,%edx
  1407ed:	48 03 51 10          	add    0x10(%rcx),%rdx
  1407f1:	83 c0 08             	add    $0x8,%eax
  1407f4:	89 01                	mov    %eax,(%rcx)
  1407f6:	8b 02                	mov    (%rdx),%eax
  1407f8:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1407fb:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1407ff:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  140803:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  140809:	e9 fb fd ff ff       	jmpq   140609 <printer_vprintf+0x35e>
            numbuf[0] = va_arg(val, int);
  14080e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  140812:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  140816:	48 8d 42 08          	lea    0x8(%rdx),%rax
  14081a:	48 89 47 08          	mov    %rax,0x8(%rdi)
  14081e:	eb d6                	jmp    1407f6 <printer_vprintf+0x54b>
            numbuf[0] = (*format ? *format : '%');
  140820:	84 d2                	test   %dl,%dl
  140822:	0f 85 3b 01 00 00    	jne    140963 <printer_vprintf+0x6b8>
  140828:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  14082c:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  140830:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  140834:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  140838:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  14083e:	e9 c6 fd ff ff       	jmpq   140609 <printer_vprintf+0x35e>
        if (flags & FLAG_NUMERIC) {
  140843:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  140849:	bf b0 0c 14 00       	mov    $0x140cb0,%edi
        if (flags & FLAG_NUMERIC) {
  14084e:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  140853:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  140857:	4c 89 c1             	mov    %r8,%rcx
  14085a:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  14085e:	48 63 f6             	movslq %esi,%rsi
  140861:	49 83 ec 01          	sub    $0x1,%r12
  140865:	48 89 c8             	mov    %rcx,%rax
  140868:	ba 00 00 00 00       	mov    $0x0,%edx
  14086d:	48 f7 f6             	div    %rsi
  140870:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  140874:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  140878:	48 89 ca             	mov    %rcx,%rdx
  14087b:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  14087e:	48 39 d6             	cmp    %rdx,%rsi
  140881:	76 de                	jbe    140861 <printer_vprintf+0x5b6>
  140883:	e9 96 fd ff ff       	jmpq   14061e <printer_vprintf+0x373>
                prefix = "-";
  140888:	48 c7 45 a0 c7 0a 14 	movq   $0x140ac7,-0x60(%rbp)
  14088f:	00 
            if (flags & FLAG_NEGATIVE) {
  140890:	8b 45 a8             	mov    -0x58(%rbp),%eax
  140893:	a8 80                	test   $0x80,%al
  140895:	0f 85 ac fd ff ff    	jne    140647 <printer_vprintf+0x39c>
                prefix = "+";
  14089b:	48 c7 45 a0 c5 0a 14 	movq   $0x140ac5,-0x60(%rbp)
  1408a2:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1408a3:	a8 10                	test   $0x10,%al
  1408a5:	0f 85 9c fd ff ff    	jne    140647 <printer_vprintf+0x39c>
                prefix = " ";
  1408ab:	a8 08                	test   $0x8,%al
  1408ad:	ba c4 0a 14 00       	mov    $0x140ac4,%edx
  1408b2:	b8 c3 0a 14 00       	mov    $0x140ac3,%eax
  1408b7:	48 0f 44 c2          	cmove  %rdx,%rax
  1408bb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1408bf:	e9 83 fd ff ff       	jmpq   140647 <printer_vprintf+0x39c>
                   && (base == 16 || base == -16)
  1408c4:	41 8d 41 10          	lea    0x10(%r9),%eax
  1408c8:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1408cd:	0f 85 74 fd ff ff    	jne    140647 <printer_vprintf+0x39c>
                   && (num || (flags & FLAG_ALT2))) {
  1408d3:	4d 85 c0             	test   %r8,%r8
  1408d6:	75 0d                	jne    1408e5 <printer_vprintf+0x63a>
  1408d8:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1408df:	0f 84 62 fd ff ff    	je     140647 <printer_vprintf+0x39c>
            prefix = (base == -16 ? "0x" : "0X");
  1408e5:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1408e9:	ba c0 0a 14 00       	mov    $0x140ac0,%edx
  1408ee:	b8 c9 0a 14 00       	mov    $0x140ac9,%eax
  1408f3:	48 0f 44 c2          	cmove  %rdx,%rax
  1408f7:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1408fb:	e9 47 fd ff ff       	jmpq   140647 <printer_vprintf+0x39c>
            len = strlen(data);
  140900:	4c 89 e7             	mov    %r12,%rdi
  140903:	e8 af f8 ff ff       	callq  1401b7 <strlen>
  140908:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  14090b:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  14090f:	0f 84 5f fd ff ff    	je     140674 <printer_vprintf+0x3c9>
  140915:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  140919:	0f 84 55 fd ff ff    	je     140674 <printer_vprintf+0x3c9>
            zeros = precision > len ? precision - len : 0;
  14091f:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  140922:	89 fa                	mov    %edi,%edx
  140924:	29 c2                	sub    %eax,%edx
  140926:	39 c7                	cmp    %eax,%edi
  140928:	b8 00 00 00 00       	mov    $0x0,%eax
  14092d:	0f 4e d0             	cmovle %eax,%edx
  140930:	89 55 9c             	mov    %edx,-0x64(%rbp)
  140933:	e9 52 fd ff ff       	jmpq   14068a <printer_vprintf+0x3df>
                   && len + (int) strlen(prefix) < width) {
  140938:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  14093c:	e8 76 f8 ff ff       	callq  1401b7 <strlen>
  140941:	8b 7d 98             	mov    -0x68(%rbp),%edi
  140944:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  140947:	44 89 e9             	mov    %r13d,%ecx
  14094a:	29 f9                	sub    %edi,%ecx
  14094c:	29 c1                	sub    %eax,%ecx
  14094e:	89 c8                	mov    %ecx,%eax
  140950:	44 39 ea             	cmp    %r13d,%edx
  140953:	b9 00 00 00 00       	mov    $0x0,%ecx
  140958:	0f 4d c1             	cmovge %ecx,%eax
  14095b:	89 45 9c             	mov    %eax,-0x64(%rbp)
  14095e:	e9 27 fd ff ff       	jmpq   14068a <printer_vprintf+0x3df>
            numbuf[0] = (*format ? *format : '%');
  140963:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  140966:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  14096a:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  14096e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  140974:	e9 90 fc ff ff       	jmpq   140609 <printer_vprintf+0x35e>
        int flags = 0;
  140979:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  140980:	e9 ad f9 ff ff       	jmpq   140332 <printer_vprintf+0x87>
}
  140985:	48 83 c4 58          	add    $0x58,%rsp
  140989:	5b                   	pop    %rbx
  14098a:	41 5c                	pop    %r12
  14098c:	41 5d                	pop    %r13
  14098e:	41 5e                	pop    %r14
  140990:	41 5f                	pop    %r15
  140992:	5d                   	pop    %rbp
  140993:	c3                   	retq   

0000000000140994 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  140994:	55                   	push   %rbp
  140995:	48 89 e5             	mov    %rsp,%rbp
  140998:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  14099c:	48 c7 45 f0 92 00 14 	movq   $0x140092,-0x10(%rbp)
  1409a3:	00 
        cpos = 0;
  1409a4:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  1409aa:	b8 00 00 00 00       	mov    $0x0,%eax
  1409af:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1409b2:	48 63 ff             	movslq %edi,%rdi
  1409b5:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1409bc:	00 
  1409bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1409c1:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1409c5:	e8 e1 f8 ff ff       	callq  1402ab <printer_vprintf>
    return cp.cursor - console;
  1409ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1409ce:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1409d4:	48 d1 f8             	sar    %rax
}
  1409d7:	c9                   	leaveq 
  1409d8:	c3                   	retq   

00000000001409d9 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1409d9:	55                   	push   %rbp
  1409da:	48 89 e5             	mov    %rsp,%rbp
  1409dd:	48 83 ec 50          	sub    $0x50,%rsp
  1409e1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1409e5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1409e9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1409ed:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1409f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1409f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1409fc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  140a00:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  140a04:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  140a08:	e8 87 ff ff ff       	callq  140994 <console_vprintf>
}
  140a0d:	c9                   	leaveq 
  140a0e:	c3                   	retq   

0000000000140a0f <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  140a0f:	55                   	push   %rbp
  140a10:	48 89 e5             	mov    %rsp,%rbp
  140a13:	53                   	push   %rbx
  140a14:	48 83 ec 28          	sub    $0x28,%rsp
  140a18:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  140a1b:	48 c7 45 d8 1c 01 14 	movq   $0x14011c,-0x28(%rbp)
  140a22:	00 
    sp.s = s;
  140a23:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  140a27:	48 85 f6             	test   %rsi,%rsi
  140a2a:	75 0e                	jne    140a3a <vsnprintf+0x2b>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  140a2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  140a30:	48 29 d8             	sub    %rbx,%rax
}
  140a33:	48 83 c4 28          	add    $0x28,%rsp
  140a37:	5b                   	pop    %rbx
  140a38:	5d                   	pop    %rbp
  140a39:	c3                   	retq   
        sp.end = s + size - 1;
  140a3a:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  140a3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  140a43:	be 00 00 00 00       	mov    $0x0,%esi
  140a48:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  140a4c:	e8 5a f8 ff ff       	callq  1402ab <printer_vprintf>
        *sp.s = 0;
  140a51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  140a55:	c6 00 00             	movb   $0x0,(%rax)
  140a58:	eb d2                	jmp    140a2c <vsnprintf+0x1d>

0000000000140a5a <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  140a5a:	55                   	push   %rbp
  140a5b:	48 89 e5             	mov    %rsp,%rbp
  140a5e:	48 83 ec 50          	sub    $0x50,%rsp
  140a62:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  140a66:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  140a6a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  140a6e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  140a75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  140a79:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  140a7d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  140a81:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  140a85:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  140a89:	e8 81 ff ff ff       	callq  140a0f <vsnprintf>
    va_end(val);
    return n;
}
  140a8e:	c9                   	leaveq 
  140a8f:	c3                   	retq   

0000000000140a90 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  140a90:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  140a95:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  140a9a:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  140a9f:	48 83 c0 02          	add    $0x2,%rax
  140aa3:	48 39 d0             	cmp    %rdx,%rax
  140aa6:	75 f2                	jne    140a9a <console_clear+0xa>
    }
    cursorpos = 0;
  140aa8:	c7 05 4a 85 f7 ff 00 	movl   $0x0,-0x87ab6(%rip)        # b8ffc <cursorpos>
  140aaf:	00 00 00 
}
  140ab2:	c3                   	retq   
