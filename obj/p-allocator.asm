
obj/p-allocator.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:

// These global variables go on the data page.
uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	53                   	push   %rbx
  100005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100009:	cd 31                	int    $0x31
  10000b:	89 c7                	mov    %eax,%edi
  10000d:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  10000f:	e8 86 02 00 00       	callq  10029a <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100014:	b8 17 20 10 00       	mov    $0x102017,%eax
  100019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10001f:	48 89 05 e2 0f 00 00 	mov    %rax,0xfe2(%rip)        # 101008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  100026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100029:	48 83 e8 01          	sub    $0x1,%rax
  10002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100033:	48 89 05 d6 0f 00 00 	mov    %rax,0xfd6(%rip)        # 101010 <stack_bottom>
  10003a:	eb 02                	jmp    10003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  10003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  10003e:	e8 1d 02 00 00       	callq  100260 <rand>
  100043:	89 c2                	mov    %eax,%edx
  100045:	48 98                	cltq   
  100047:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
  10004e:	48 c1 f8 25          	sar    $0x25,%rax
  100052:	89 d1                	mov    %edx,%ecx
  100054:	c1 f9 1f             	sar    $0x1f,%ecx
  100057:	29 c8                	sub    %ecx,%eax
  100059:	6b c0 64             	imul   $0x64,%eax,%eax
  10005c:	29 c2                	sub    %eax,%edx
  10005e:	39 da                	cmp    %ebx,%edx
  100060:	7d da                	jge    10003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  100062:	48 8b 3d 9f 0f 00 00 	mov    0xf9f(%rip),%rdi        # 101008 <heap_top>
  100069:	48 3b 3d a0 0f 00 00 	cmp    0xfa0(%rip),%rdi        # 101010 <stack_bottom>
  100070:	74 1c                	je     10008e <process_main+0x8e>
//    Allocate a page of memory at address `addr`. `Addr` must be page-aligned
//    (i.e., a multiple of PAGESIZE == 4096). Returns 0 on success and -1
//    on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  100072:	cd 33                	int    $0x33
  100074:	85 c0                	test   %eax,%eax
  100076:	78 16                	js     10008e <process_main+0x8e>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  100078:	48 8b 05 89 0f 00 00 	mov    0xf89(%rip),%rax        # 101008 <heap_top>
  10007f:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  100081:	48 81 05 7c 0f 00 00 	addq   $0x1000,0xf7c(%rip)        # 101008 <heap_top>
  100088:	00 10 00 00 
  10008c:	eb ae                	jmp    10003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  10008e:	cd 32                	int    $0x32
  100090:	eb fc                	jmp    10008e <process_main+0x8e>

0000000000100092 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100092:	41 89 d0             	mov    %edx,%r8d
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  100095:	48 81 7f 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rdi)
  10009c:	00 
  10009d:	72 08                	jb     1000a7 <console_putc+0x15>
        cp->cursor = console;
  10009f:	48 c7 47 08 00 80 0b 	movq   $0xb8000,0x8(%rdi)
  1000a6:	00 
    }
    if (c == '\n') {
  1000a7:	40 80 fe 0a          	cmp    $0xa,%sil
  1000ab:	74 17                	je     1000c4 <console_putc+0x32>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1000ad:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1000b1:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1000b5:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1000b9:	40 0f b6 f6          	movzbl %sil,%esi
  1000bd:	44 09 c6             	or     %r8d,%esi
  1000c0:	66 89 30             	mov    %si,(%rax)
    }
}
  1000c3:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1000c4:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  1000c8:	48 81 ee 00 80 0b 00 	sub    $0xb8000,%rsi
  1000cf:	48 89 f1             	mov    %rsi,%rcx
  1000d2:	48 d1 f9             	sar    %rcx
  1000d5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1000dc:	66 66 66 
  1000df:	48 89 c8             	mov    %rcx,%rax
  1000e2:	48 f7 ea             	imul   %rdx
  1000e5:	48 c1 fa 05          	sar    $0x5,%rdx
  1000e9:	48 c1 fe 3f          	sar    $0x3f,%rsi
  1000ed:	48 29 f2             	sub    %rsi,%rdx
  1000f0:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  1000f4:	48 c1 e0 04          	shl    $0x4,%rax
  1000f8:	89 ca                	mov    %ecx,%edx
  1000fa:	29 c2                	sub    %eax,%edx
  1000fc:	89 d0                	mov    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1000fe:	44 89 c6             	mov    %r8d,%esi
  100101:	83 ce 20             	or     $0x20,%esi
  100104:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  100108:	4c 8d 41 02          	lea    0x2(%rcx),%r8
  10010c:	4c 89 47 08          	mov    %r8,0x8(%rdi)
  100110:	66 89 31             	mov    %si,(%rcx)
        for (; pos != 80; pos++) {
  100113:	83 c0 01             	add    $0x1,%eax
  100116:	83 f8 50             	cmp    $0x50,%eax
  100119:	75 e9                	jne    100104 <console_putc+0x72>
  10011b:	c3                   	retq   

000000000010011c <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  10011c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  100120:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  100124:	73 0b                	jae    100131 <string_putc+0x15>
        *sp->s++ = c;
  100126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  10012a:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  10012e:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  100131:	c3                   	retq   

0000000000100132 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  100132:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100135:	48 85 d2             	test   %rdx,%rdx
  100138:	74 17                	je     100151 <memcpy+0x1f>
  10013a:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  10013f:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  100144:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100148:	48 83 c1 01          	add    $0x1,%rcx
  10014c:	48 39 d1             	cmp    %rdx,%rcx
  10014f:	75 ee                	jne    10013f <memcpy+0xd>
}
  100151:	c3                   	retq   

0000000000100152 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  100152:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  100155:	48 39 fe             	cmp    %rdi,%rsi
  100158:	72 1d                	jb     100177 <memmove+0x25>
        while (n-- > 0) {
  10015a:	b9 00 00 00 00       	mov    $0x0,%ecx
  10015f:	48 85 d2             	test   %rdx,%rdx
  100162:	74 12                	je     100176 <memmove+0x24>
            *d++ = *s++;
  100164:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  100168:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  10016c:	48 83 c1 01          	add    $0x1,%rcx
  100170:	48 39 ca             	cmp    %rcx,%rdx
  100173:	75 ef                	jne    100164 <memmove+0x12>
}
  100175:	c3                   	retq   
  100176:	c3                   	retq   
    if (s < d && s + n > d) {
  100177:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  10017b:	48 39 cf             	cmp    %rcx,%rdi
  10017e:	73 da                	jae    10015a <memmove+0x8>
        while (n-- > 0) {
  100180:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  100184:	48 85 d2             	test   %rdx,%rdx
  100187:	74 ec                	je     100175 <memmove+0x23>
            *--d = *--s;
  100189:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  10018d:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  100190:	48 83 e9 01          	sub    $0x1,%rcx
  100194:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  100198:	75 ef                	jne    100189 <memmove+0x37>
  10019a:	c3                   	retq   

000000000010019b <memset>:
void* memset(void* v, int c, size_t n) {
  10019b:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  10019e:	48 85 d2             	test   %rdx,%rdx
  1001a1:	74 13                	je     1001b6 <memset+0x1b>
  1001a3:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  1001a7:	48 89 fa             	mov    %rdi,%rdx
        *p = c;
  1001aa:	40 88 32             	mov    %sil,(%rdx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1001ad:	48 83 c2 01          	add    $0x1,%rdx
  1001b1:	48 39 d1             	cmp    %rdx,%rcx
  1001b4:	75 f4                	jne    1001aa <memset+0xf>
}
  1001b6:	c3                   	retq   

00000000001001b7 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1001b7:	80 3f 00             	cmpb   $0x0,(%rdi)
  1001ba:	74 10                	je     1001cc <strlen+0x15>
  1001bc:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1001c1:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1001c5:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1001c9:	75 f6                	jne    1001c1 <strlen+0xa>
  1001cb:	c3                   	retq   
  1001cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1001d1:	c3                   	retq   

00000000001001d2 <strnlen>:
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1001d2:	b8 00 00 00 00       	mov    $0x0,%eax
  1001d7:	48 85 f6             	test   %rsi,%rsi
  1001da:	74 10                	je     1001ec <strnlen+0x1a>
  1001dc:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1001e0:	74 09                	je     1001eb <strnlen+0x19>
        ++n;
  1001e2:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1001e6:	48 39 c6             	cmp    %rax,%rsi
  1001e9:	75 f1                	jne    1001dc <strnlen+0xa>
}
  1001eb:	c3                   	retq   
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1001ec:	48 89 f0             	mov    %rsi,%rax
  1001ef:	c3                   	retq   

00000000001001f0 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1001f0:	48 89 f8             	mov    %rdi,%rax
  1001f3:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1001f8:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1001fc:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1001ff:	48 83 c2 01          	add    $0x1,%rdx
  100203:	84 c9                	test   %cl,%cl
  100205:	75 f1                	jne    1001f8 <strcpy+0x8>
}
  100207:	c3                   	retq   

0000000000100208 <strcmp>:
    while (*a && *b && *a == *b) {
  100208:	0f b6 17             	movzbl (%rdi),%edx
  10020b:	84 d2                	test   %dl,%dl
  10020d:	74 1a                	je     100229 <strcmp+0x21>
  10020f:	0f b6 06             	movzbl (%rsi),%eax
  100212:	38 d0                	cmp    %dl,%al
  100214:	75 13                	jne    100229 <strcmp+0x21>
  100216:	84 c0                	test   %al,%al
  100218:	74 0f                	je     100229 <strcmp+0x21>
        ++a, ++b;
  10021a:	48 83 c7 01          	add    $0x1,%rdi
  10021e:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  100222:	0f b6 17             	movzbl (%rdi),%edx
  100225:	84 d2                	test   %dl,%dl
  100227:	75 e6                	jne    10020f <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  100229:	0f b6 0e             	movzbl (%rsi),%ecx
  10022c:	38 ca                	cmp    %cl,%dl
  10022e:	0f 97 c0             	seta   %al
  100231:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  100234:	83 d8 00             	sbb    $0x0,%eax
}
  100237:	c3                   	retq   

0000000000100238 <strchr>:
    while (*s && *s != (char) c) {
  100238:	0f b6 07             	movzbl (%rdi),%eax
  10023b:	84 c0                	test   %al,%al
  10023d:	74 10                	je     10024f <strchr+0x17>
  10023f:	40 38 f0             	cmp    %sil,%al
  100242:	74 18                	je     10025c <strchr+0x24>
        ++s;
  100244:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  100248:	0f b6 07             	movzbl (%rdi),%eax
  10024b:	84 c0                	test   %al,%al
  10024d:	75 f0                	jne    10023f <strchr+0x7>
        return NULL;
  10024f:	40 84 f6             	test   %sil,%sil
  100252:	b8 00 00 00 00       	mov    $0x0,%eax
  100257:	48 0f 44 c7          	cmove  %rdi,%rax
}
  10025b:	c3                   	retq   
  10025c:	48 89 f8             	mov    %rdi,%rax
  10025f:	c3                   	retq   

0000000000100260 <rand>:
    if (!rand_seed_set) {
  100260:	83 3d 9d 0d 00 00 00 	cmpl   $0x0,0xd9d(%rip)        # 101004 <rand_seed_set>
  100267:	74 1b                	je     100284 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  100269:	69 05 8d 0d 00 00 0d 	imul   $0x19660d,0xd8d(%rip),%eax        # 101000 <rand_seed>
  100270:	66 19 00 
  100273:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  100278:	89 05 82 0d 00 00    	mov    %eax,0xd82(%rip)        # 101000 <rand_seed>
    return rand_seed & RAND_MAX;
  10027e:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100283:	c3                   	retq   
    rand_seed = seed;
  100284:	c7 05 72 0d 00 00 9e 	movl   $0x30d4879e,0xd72(%rip)        # 101000 <rand_seed>
  10028b:	87 d4 30 
    rand_seed_set = 1;
  10028e:	c7 05 6c 0d 00 00 01 	movl   $0x1,0xd6c(%rip)        # 101004 <rand_seed_set>
  100295:	00 00 00 
}
  100298:	eb cf                	jmp    100269 <rand+0x9>

000000000010029a <srand>:
    rand_seed = seed;
  10029a:	89 3d 60 0d 00 00    	mov    %edi,0xd60(%rip)        # 101000 <rand_seed>
    rand_seed_set = 1;
  1002a0:	c7 05 5a 0d 00 00 01 	movl   $0x1,0xd5a(%rip)        # 101004 <rand_seed_set>
  1002a7:	00 00 00 
}
  1002aa:	c3                   	retq   

00000000001002ab <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1002ab:	55                   	push   %rbp
  1002ac:	48 89 e5             	mov    %rsp,%rbp
  1002af:	41 57                	push   %r15
  1002b1:	41 56                	push   %r14
  1002b3:	41 55                	push   %r13
  1002b5:	41 54                	push   %r12
  1002b7:	53                   	push   %rbx
  1002b8:	48 83 ec 58          	sub    $0x58,%rsp
  1002bc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1002c0:	0f b6 02             	movzbl (%rdx),%eax
  1002c3:	84 c0                	test   %al,%al
  1002c5:	0f 84 ba 06 00 00    	je     100985 <printer_vprintf+0x6da>
  1002cb:	49 89 fe             	mov    %rdi,%r14
  1002ce:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1002d1:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%rbp)
  1002d8:	41 89 f7             	mov    %esi,%r15d
  1002db:	e9 a5 04 00 00       	jmpq   100785 <printer_vprintf+0x4da>
        for (++format; *format; ++format) {
  1002e0:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1002e5:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1002eb:	45 84 e4             	test   %r12b,%r12b
  1002ee:	0f 84 85 06 00 00    	je     100979 <printer_vprintf+0x6ce>
        int flags = 0;
  1002f4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1002fa:	41 0f be f4          	movsbl %r12b,%esi
  1002fe:	bf c1 0c 10 00       	mov    $0x100cc1,%edi
  100303:	e8 30 ff ff ff       	callq  100238 <strchr>
  100308:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  10030b:	48 85 c0             	test   %rax,%rax
  10030e:	74 55                	je     100365 <printer_vprintf+0xba>
                flags |= 1 << (flagc - flag_chars);
  100310:	48 81 e9 c1 0c 10 00 	sub    $0x100cc1,%rcx
  100317:	b8 01 00 00 00       	mov    $0x1,%eax
  10031c:	d3 e0                	shl    %cl,%eax
  10031e:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  100321:	48 83 c3 01          	add    $0x1,%rbx
  100325:	44 0f b6 23          	movzbl (%rbx),%r12d
  100329:	45 84 e4             	test   %r12b,%r12b
  10032c:	75 cc                	jne    1002fa <printer_vprintf+0x4f>
  10032e:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  100332:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  100338:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  10033f:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  100342:	0f 84 a9 00 00 00    	je     1003f1 <printer_vprintf+0x146>
        int length = 0;
  100348:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  10034d:	0f b6 13             	movzbl (%rbx),%edx
  100350:	8d 42 bd             	lea    -0x43(%rdx),%eax
  100353:	3c 37                	cmp    $0x37,%al
  100355:	0f 87 c5 04 00 00    	ja     100820 <printer_vprintf+0x575>
  10035b:	0f b6 c0             	movzbl %al,%eax
  10035e:	ff 24 c5 d0 0a 10 00 	jmpq   *0x100ad0(,%rax,8)
  100365:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        if (*format >= '1' && *format <= '9') {
  100369:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  10036e:	3c 08                	cmp    $0x8,%al
  100370:	77 2f                	ja     1003a1 <printer_vprintf+0xf6>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100372:	0f b6 03             	movzbl (%rbx),%eax
  100375:	8d 50 d0             	lea    -0x30(%rax),%edx
  100378:	80 fa 09             	cmp    $0x9,%dl
  10037b:	77 5e                	ja     1003db <printer_vprintf+0x130>
  10037d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  100383:	48 83 c3 01          	add    $0x1,%rbx
  100387:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  10038c:	0f be c0             	movsbl %al,%eax
  10038f:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100394:	0f b6 03             	movzbl (%rbx),%eax
  100397:	8d 50 d0             	lea    -0x30(%rax),%edx
  10039a:	80 fa 09             	cmp    $0x9,%dl
  10039d:	76 e4                	jbe    100383 <printer_vprintf+0xd8>
  10039f:	eb 97                	jmp    100338 <printer_vprintf+0x8d>
        } else if (*format == '*') {
  1003a1:	41 80 fc 2a          	cmp    $0x2a,%r12b
  1003a5:	75 3f                	jne    1003e6 <printer_vprintf+0x13b>
            width = va_arg(val, int);
  1003a7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1003ab:	8b 01                	mov    (%rcx),%eax
  1003ad:	83 f8 2f             	cmp    $0x2f,%eax
  1003b0:	77 17                	ja     1003c9 <printer_vprintf+0x11e>
  1003b2:	89 c2                	mov    %eax,%edx
  1003b4:	48 03 51 10          	add    0x10(%rcx),%rdx
  1003b8:	83 c0 08             	add    $0x8,%eax
  1003bb:	89 01                	mov    %eax,(%rcx)
  1003bd:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1003c0:	48 83 c3 01          	add    $0x1,%rbx
  1003c4:	e9 6f ff ff ff       	jmpq   100338 <printer_vprintf+0x8d>
            width = va_arg(val, int);
  1003c9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1003cd:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1003d1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1003d5:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1003d9:	eb e2                	jmp    1003bd <printer_vprintf+0x112>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1003db:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1003e1:	e9 52 ff ff ff       	jmpq   100338 <printer_vprintf+0x8d>
        int width = -1;
  1003e6:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1003ec:	e9 47 ff ff ff       	jmpq   100338 <printer_vprintf+0x8d>
            ++format;
  1003f1:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1003f5:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1003f9:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1003fc:	80 f9 09             	cmp    $0x9,%cl
  1003ff:	76 13                	jbe    100414 <printer_vprintf+0x169>
            } else if (*format == '*') {
  100401:	3c 2a                	cmp    $0x2a,%al
  100403:	74 32                	je     100437 <printer_vprintf+0x18c>
            ++format;
  100405:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  100408:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  10040f:	e9 34 ff ff ff       	jmpq   100348 <printer_vprintf+0x9d>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100414:	be 00 00 00 00       	mov    $0x0,%esi
                    precision = 10 * precision + *format++ - '0';
  100419:	48 83 c2 01          	add    $0x1,%rdx
  10041d:	8d 0c b6             	lea    (%rsi,%rsi,4),%ecx
  100420:	0f be c0             	movsbl %al,%eax
  100423:	8d 74 48 d0          	lea    -0x30(%rax,%rcx,2),%esi
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100427:	0f b6 02             	movzbl (%rdx),%eax
  10042a:	8d 48 d0             	lea    -0x30(%rax),%ecx
  10042d:	80 f9 09             	cmp    $0x9,%cl
  100430:	76 e7                	jbe    100419 <printer_vprintf+0x16e>
                    precision = 10 * precision + *format++ - '0';
  100432:	48 89 d3             	mov    %rdx,%rbx
  100435:	eb 1c                	jmp    100453 <printer_vprintf+0x1a8>
                precision = va_arg(val, int);
  100437:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10043b:	8b 07                	mov    (%rdi),%eax
  10043d:	83 f8 2f             	cmp    $0x2f,%eax
  100440:	77 23                	ja     100465 <printer_vprintf+0x1ba>
  100442:	89 c2                	mov    %eax,%edx
  100444:	48 03 57 10          	add    0x10(%rdi),%rdx
  100448:	83 c0 08             	add    $0x8,%eax
  10044b:	89 07                	mov    %eax,(%rdi)
  10044d:	8b 32                	mov    (%rdx),%esi
                ++format;
  10044f:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  100453:	85 f6                	test   %esi,%esi
  100455:	b8 00 00 00 00       	mov    $0x0,%eax
  10045a:	0f 48 f0             	cmovs  %eax,%esi
  10045d:	89 75 9c             	mov    %esi,-0x64(%rbp)
  100460:	e9 e3 fe ff ff       	jmpq   100348 <printer_vprintf+0x9d>
                precision = va_arg(val, int);
  100465:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100469:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10046d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100471:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100475:	eb d6                	jmp    10044d <printer_vprintf+0x1a2>
        switch (*format) {
  100477:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  10047c:	e9 f1 00 00 00       	jmpq   100572 <printer_vprintf+0x2c7>
            ++format;
  100481:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  100485:	8b 4d 80             	mov    -0x80(%rbp),%ecx
            goto again;
  100488:	e9 c0 fe ff ff       	jmpq   10034d <printer_vprintf+0xa2>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  10048d:	85 c9                	test   %ecx,%ecx
  10048f:	74 55                	je     1004e6 <printer_vprintf+0x23b>
  100491:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100495:	8b 01                	mov    (%rcx),%eax
  100497:	83 f8 2f             	cmp    $0x2f,%eax
  10049a:	77 38                	ja     1004d4 <printer_vprintf+0x229>
  10049c:	89 c2                	mov    %eax,%edx
  10049e:	48 03 51 10          	add    0x10(%rcx),%rdx
  1004a2:	83 c0 08             	add    $0x8,%eax
  1004a5:	89 01                	mov    %eax,(%rcx)
  1004a7:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1004aa:	48 89 d0             	mov    %rdx,%rax
  1004ad:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1004b1:	49 89 d0             	mov    %rdx,%r8
  1004b4:	49 f7 d8             	neg    %r8
  1004b7:	25 80 00 00 00       	and    $0x80,%eax
  1004bc:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1004c0:	0b 45 a8             	or     -0x58(%rbp),%eax
  1004c3:	83 c8 60             	or     $0x60,%eax
  1004c6:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1004c9:	41 bc c4 0a 10 00    	mov    $0x100ac4,%r12d
            break;
  1004cf:	e9 35 01 00 00       	jmpq   100609 <printer_vprintf+0x35e>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1004d4:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004d8:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1004dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004e0:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1004e4:	eb c1                	jmp    1004a7 <printer_vprintf+0x1fc>
  1004e6:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004ea:	8b 07                	mov    (%rdi),%eax
  1004ec:	83 f8 2f             	cmp    $0x2f,%eax
  1004ef:	77 10                	ja     100501 <printer_vprintf+0x256>
  1004f1:	89 c2                	mov    %eax,%edx
  1004f3:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004f7:	83 c0 08             	add    $0x8,%eax
  1004fa:	89 07                	mov    %eax,(%rdi)
  1004fc:	48 63 12             	movslq (%rdx),%rdx
  1004ff:	eb a9                	jmp    1004aa <printer_vprintf+0x1ff>
  100501:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100505:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100509:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10050d:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100511:	eb e9                	jmp    1004fc <printer_vprintf+0x251>
        int base = 10;
  100513:	be 0a 00 00 00       	mov    $0xa,%esi
  100518:	eb 58                	jmp    100572 <printer_vprintf+0x2c7>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  10051a:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10051e:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100522:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100526:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10052a:	eb 60                	jmp    10058c <printer_vprintf+0x2e1>
  10052c:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100530:	8b 01                	mov    (%rcx),%eax
  100532:	83 f8 2f             	cmp    $0x2f,%eax
  100535:	77 10                	ja     100547 <printer_vprintf+0x29c>
  100537:	89 c2                	mov    %eax,%edx
  100539:	48 03 51 10          	add    0x10(%rcx),%rdx
  10053d:	83 c0 08             	add    $0x8,%eax
  100540:	89 01                	mov    %eax,(%rcx)
  100542:	44 8b 02             	mov    (%rdx),%r8d
  100545:	eb 48                	jmp    10058f <printer_vprintf+0x2e4>
  100547:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10054b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10054f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100553:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100557:	eb e9                	jmp    100542 <printer_vprintf+0x297>
  100559:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  10055c:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  100563:	bf b0 0c 10 00       	mov    $0x100cb0,%edi
  100568:	e9 e6 02 00 00       	jmpq   100853 <printer_vprintf+0x5a8>
            base = 16;
  10056d:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100572:	85 c9                	test   %ecx,%ecx
  100574:	74 b6                	je     10052c <printer_vprintf+0x281>
  100576:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10057a:	8b 07                	mov    (%rdi),%eax
  10057c:	83 f8 2f             	cmp    $0x2f,%eax
  10057f:	77 99                	ja     10051a <printer_vprintf+0x26f>
  100581:	89 c2                	mov    %eax,%edx
  100583:	48 03 57 10          	add    0x10(%rdi),%rdx
  100587:	83 c0 08             	add    $0x8,%eax
  10058a:	89 07                	mov    %eax,(%rdi)
  10058c:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  10058f:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  100593:	85 f6                	test   %esi,%esi
  100595:	79 c2                	jns    100559 <printer_vprintf+0x2ae>
        base = -base;
  100597:	41 89 f1             	mov    %esi,%r9d
  10059a:	f7 de                	neg    %esi
  10059c:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  1005a3:	bf 90 0c 10 00       	mov    $0x100c90,%edi
  1005a8:	e9 a6 02 00 00       	jmpq   100853 <printer_vprintf+0x5a8>
            num = (uintptr_t) va_arg(val, void*);
  1005ad:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1005b1:	8b 07                	mov    (%rdi),%eax
  1005b3:	83 f8 2f             	cmp    $0x2f,%eax
  1005b6:	77 1c                	ja     1005d4 <printer_vprintf+0x329>
  1005b8:	89 c2                	mov    %eax,%edx
  1005ba:	48 03 57 10          	add    0x10(%rdi),%rdx
  1005be:	83 c0 08             	add    $0x8,%eax
  1005c1:	89 07                	mov    %eax,(%rdi)
  1005c3:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1005c6:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1005cd:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1005d2:	eb c3                	jmp    100597 <printer_vprintf+0x2ec>
            num = (uintptr_t) va_arg(val, void*);
  1005d4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005d8:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005e0:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005e4:	eb dd                	jmp    1005c3 <printer_vprintf+0x318>
            data = va_arg(val, char*);
  1005e6:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005ea:	8b 01                	mov    (%rcx),%eax
  1005ec:	83 f8 2f             	cmp    $0x2f,%eax
  1005ef:	0f 87 a9 01 00 00    	ja     10079e <printer_vprintf+0x4f3>
  1005f5:	89 c2                	mov    %eax,%edx
  1005f7:	48 03 51 10          	add    0x10(%rcx),%rdx
  1005fb:	83 c0 08             	add    $0x8,%eax
  1005fe:	89 01                	mov    %eax,(%rcx)
  100600:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  100603:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  100609:	8b 45 a8             	mov    -0x58(%rbp),%eax
  10060c:	83 e0 20             	and    $0x20,%eax
  10060f:	89 45 8c             	mov    %eax,-0x74(%rbp)
  100612:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  100618:	0f 85 25 02 00 00    	jne    100843 <printer_vprintf+0x598>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  10061e:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100621:	89 45 88             	mov    %eax,-0x78(%rbp)
  100624:	83 e0 60             	and    $0x60,%eax
  100627:	83 f8 60             	cmp    $0x60,%eax
  10062a:	0f 84 58 02 00 00    	je     100888 <printer_vprintf+0x5dd>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100630:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100633:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  100636:	48 c7 45 a0 c4 0a 10 	movq   $0x100ac4,-0x60(%rbp)
  10063d:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  10063e:	83 f8 21             	cmp    $0x21,%eax
  100641:	0f 84 7d 02 00 00    	je     1008c4 <printer_vprintf+0x619>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  100647:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  10064a:	89 c8                	mov    %ecx,%eax
  10064c:	f7 d0                	not    %eax
  10064e:	c1 e8 1f             	shr    $0x1f,%eax
  100651:	89 45 84             	mov    %eax,-0x7c(%rbp)
  100654:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100658:	0f 85 a2 02 00 00    	jne    100900 <printer_vprintf+0x655>
  10065e:	84 c0                	test   %al,%al
  100660:	0f 84 9a 02 00 00    	je     100900 <printer_vprintf+0x655>
            len = strnlen(data, precision);
  100666:	48 63 f1             	movslq %ecx,%rsi
  100669:	4c 89 e7             	mov    %r12,%rdi
  10066c:	e8 61 fb ff ff       	callq  1001d2 <strnlen>
  100671:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  100674:	8b 45 88             	mov    -0x78(%rbp),%eax
  100677:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  10067a:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100681:	83 f8 22             	cmp    $0x22,%eax
  100684:	0f 84 ae 02 00 00    	je     100938 <printer_vprintf+0x68d>
        width -= len + zeros + strlen(prefix);
  10068a:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  10068e:	e8 24 fb ff ff       	callq  1001b7 <strlen>
  100693:	8b 55 9c             	mov    -0x64(%rbp),%edx
  100696:	03 55 98             	add    -0x68(%rbp),%edx
  100699:	41 29 d5             	sub    %edx,%r13d
  10069c:	44 89 ea             	mov    %r13d,%edx
  10069f:	29 c2                	sub    %eax,%edx
  1006a1:	89 55 8c             	mov    %edx,-0x74(%rbp)
  1006a4:	41 89 d5             	mov    %edx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1006a7:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1006ab:	75 2d                	jne    1006da <printer_vprintf+0x42f>
  1006ad:	85 d2                	test   %edx,%edx
  1006af:	7e 29                	jle    1006da <printer_vprintf+0x42f>
            p->putc(p, ' ', color);
  1006b1:	44 89 fa             	mov    %r15d,%edx
  1006b4:	be 20 00 00 00       	mov    $0x20,%esi
  1006b9:	4c 89 f7             	mov    %r14,%rdi
  1006bc:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1006bf:	41 83 ed 01          	sub    $0x1,%r13d
  1006c3:	45 85 ed             	test   %r13d,%r13d
  1006c6:	7f e9                	jg     1006b1 <printer_vprintf+0x406>
  1006c8:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1006cb:	85 ff                	test   %edi,%edi
  1006cd:	b8 01 00 00 00       	mov    $0x1,%eax
  1006d2:	0f 4f c7             	cmovg  %edi,%eax
  1006d5:	29 c7                	sub    %eax,%edi
  1006d7:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1006da:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  1006de:	0f b6 01             	movzbl (%rcx),%eax
  1006e1:	84 c0                	test   %al,%al
  1006e3:	74 22                	je     100707 <printer_vprintf+0x45c>
  1006e5:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1006e9:	48 89 cb             	mov    %rcx,%rbx
            p->putc(p, *prefix, color);
  1006ec:	0f b6 f0             	movzbl %al,%esi
  1006ef:	44 89 fa             	mov    %r15d,%edx
  1006f2:	4c 89 f7             	mov    %r14,%rdi
  1006f5:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1006f8:	48 83 c3 01          	add    $0x1,%rbx
  1006fc:	0f b6 03             	movzbl (%rbx),%eax
  1006ff:	84 c0                	test   %al,%al
  100701:	75 e9                	jne    1006ec <printer_vprintf+0x441>
  100703:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  100707:	8b 45 9c             	mov    -0x64(%rbp),%eax
  10070a:	85 c0                	test   %eax,%eax
  10070c:	7e 1d                	jle    10072b <printer_vprintf+0x480>
  10070e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100712:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  100714:	44 89 fa             	mov    %r15d,%edx
  100717:	be 30 00 00 00       	mov    $0x30,%esi
  10071c:	4c 89 f7             	mov    %r14,%rdi
  10071f:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  100722:	83 eb 01             	sub    $0x1,%ebx
  100725:	75 ed                	jne    100714 <printer_vprintf+0x469>
  100727:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  10072b:	8b 45 98             	mov    -0x68(%rbp),%eax
  10072e:	85 c0                	test   %eax,%eax
  100730:	7e 2a                	jle    10075c <printer_vprintf+0x4b1>
  100732:	8d 40 ff             	lea    -0x1(%rax),%eax
  100735:	49 8d 44 04 01       	lea    0x1(%r12,%rax,1),%rax
  10073a:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  10073e:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  100741:	41 0f b6 34 24       	movzbl (%r12),%esi
  100746:	44 89 fa             	mov    %r15d,%edx
  100749:	4c 89 f7             	mov    %r14,%rdi
  10074c:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  10074f:	49 83 c4 01          	add    $0x1,%r12
  100753:	49 39 dc             	cmp    %rbx,%r12
  100756:	75 e9                	jne    100741 <printer_vprintf+0x496>
  100758:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  10075c:	45 85 ed             	test   %r13d,%r13d
  10075f:	7e 14                	jle    100775 <printer_vprintf+0x4ca>
            p->putc(p, ' ', color);
  100761:	44 89 fa             	mov    %r15d,%edx
  100764:	be 20 00 00 00       	mov    $0x20,%esi
  100769:	4c 89 f7             	mov    %r14,%rdi
  10076c:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  10076f:	41 83 ed 01          	sub    $0x1,%r13d
  100773:	75 ec                	jne    100761 <printer_vprintf+0x4b6>
    for (; *format; ++format) {
  100775:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  100779:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  10077d:	84 c0                	test   %al,%al
  10077f:	0f 84 00 02 00 00    	je     100985 <printer_vprintf+0x6da>
        if (*format != '%') {
  100785:	3c 25                	cmp    $0x25,%al
  100787:	0f 84 53 fb ff ff    	je     1002e0 <printer_vprintf+0x35>
            p->putc(p, *format, color);
  10078d:	0f b6 f0             	movzbl %al,%esi
  100790:	44 89 fa             	mov    %r15d,%edx
  100793:	4c 89 f7             	mov    %r14,%rdi
  100796:	41 ff 16             	callq  *(%r14)
            continue;
  100799:	4c 89 e3             	mov    %r12,%rbx
  10079c:	eb d7                	jmp    100775 <printer_vprintf+0x4ca>
            data = va_arg(val, char*);
  10079e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1007a2:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1007a6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1007aa:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1007ae:	e9 4d fe ff ff       	jmpq   100600 <printer_vprintf+0x355>
            color = va_arg(val, int);
  1007b3:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1007b7:	8b 07                	mov    (%rdi),%eax
  1007b9:	83 f8 2f             	cmp    $0x2f,%eax
  1007bc:	77 10                	ja     1007ce <printer_vprintf+0x523>
  1007be:	89 c2                	mov    %eax,%edx
  1007c0:	48 03 57 10          	add    0x10(%rdi),%rdx
  1007c4:	83 c0 08             	add    $0x8,%eax
  1007c7:	89 07                	mov    %eax,(%rdi)
  1007c9:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1007cc:	eb a7                	jmp    100775 <printer_vprintf+0x4ca>
            color = va_arg(val, int);
  1007ce:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1007d2:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1007d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1007da:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1007de:	eb e9                	jmp    1007c9 <printer_vprintf+0x51e>
            numbuf[0] = va_arg(val, int);
  1007e0:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1007e4:	8b 01                	mov    (%rcx),%eax
  1007e6:	83 f8 2f             	cmp    $0x2f,%eax
  1007e9:	77 23                	ja     10080e <printer_vprintf+0x563>
  1007eb:	89 c2                	mov    %eax,%edx
  1007ed:	48 03 51 10          	add    0x10(%rcx),%rdx
  1007f1:	83 c0 08             	add    $0x8,%eax
  1007f4:	89 01                	mov    %eax,(%rcx)
  1007f6:	8b 02                	mov    (%rdx),%eax
  1007f8:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1007fb:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1007ff:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100803:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  100809:	e9 fb fd ff ff       	jmpq   100609 <printer_vprintf+0x35e>
            numbuf[0] = va_arg(val, int);
  10080e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100812:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100816:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10081a:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10081e:	eb d6                	jmp    1007f6 <printer_vprintf+0x54b>
            numbuf[0] = (*format ? *format : '%');
  100820:	84 d2                	test   %dl,%dl
  100822:	0f 85 3b 01 00 00    	jne    100963 <printer_vprintf+0x6b8>
  100828:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  10082c:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  100830:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  100834:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100838:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  10083e:	e9 c6 fd ff ff       	jmpq   100609 <printer_vprintf+0x35e>
        if (flags & FLAG_NUMERIC) {
  100843:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  100849:	bf b0 0c 10 00       	mov    $0x100cb0,%edi
        if (flags & FLAG_NUMERIC) {
  10084e:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  100853:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  100857:	4c 89 c1             	mov    %r8,%rcx
  10085a:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  10085e:	48 63 f6             	movslq %esi,%rsi
  100861:	49 83 ec 01          	sub    $0x1,%r12
  100865:	48 89 c8             	mov    %rcx,%rax
  100868:	ba 00 00 00 00       	mov    $0x0,%edx
  10086d:	48 f7 f6             	div    %rsi
  100870:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  100874:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  100878:	48 89 ca             	mov    %rcx,%rdx
  10087b:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  10087e:	48 39 d6             	cmp    %rdx,%rsi
  100881:	76 de                	jbe    100861 <printer_vprintf+0x5b6>
  100883:	e9 96 fd ff ff       	jmpq   10061e <printer_vprintf+0x373>
                prefix = "-";
  100888:	48 c7 45 a0 c7 0a 10 	movq   $0x100ac7,-0x60(%rbp)
  10088f:	00 
            if (flags & FLAG_NEGATIVE) {
  100890:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100893:	a8 80                	test   $0x80,%al
  100895:	0f 85 ac fd ff ff    	jne    100647 <printer_vprintf+0x39c>
                prefix = "+";
  10089b:	48 c7 45 a0 c5 0a 10 	movq   $0x100ac5,-0x60(%rbp)
  1008a2:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1008a3:	a8 10                	test   $0x10,%al
  1008a5:	0f 85 9c fd ff ff    	jne    100647 <printer_vprintf+0x39c>
                prefix = " ";
  1008ab:	a8 08                	test   $0x8,%al
  1008ad:	ba c4 0a 10 00       	mov    $0x100ac4,%edx
  1008b2:	b8 c3 0a 10 00       	mov    $0x100ac3,%eax
  1008b7:	48 0f 44 c2          	cmove  %rdx,%rax
  1008bb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1008bf:	e9 83 fd ff ff       	jmpq   100647 <printer_vprintf+0x39c>
                   && (base == 16 || base == -16)
  1008c4:	41 8d 41 10          	lea    0x10(%r9),%eax
  1008c8:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1008cd:	0f 85 74 fd ff ff    	jne    100647 <printer_vprintf+0x39c>
                   && (num || (flags & FLAG_ALT2))) {
  1008d3:	4d 85 c0             	test   %r8,%r8
  1008d6:	75 0d                	jne    1008e5 <printer_vprintf+0x63a>
  1008d8:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1008df:	0f 84 62 fd ff ff    	je     100647 <printer_vprintf+0x39c>
            prefix = (base == -16 ? "0x" : "0X");
  1008e5:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1008e9:	ba c0 0a 10 00       	mov    $0x100ac0,%edx
  1008ee:	b8 c9 0a 10 00       	mov    $0x100ac9,%eax
  1008f3:	48 0f 44 c2          	cmove  %rdx,%rax
  1008f7:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1008fb:	e9 47 fd ff ff       	jmpq   100647 <printer_vprintf+0x39c>
            len = strlen(data);
  100900:	4c 89 e7             	mov    %r12,%rdi
  100903:	e8 af f8 ff ff       	callq  1001b7 <strlen>
  100908:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  10090b:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  10090f:	0f 84 5f fd ff ff    	je     100674 <printer_vprintf+0x3c9>
  100915:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  100919:	0f 84 55 fd ff ff    	je     100674 <printer_vprintf+0x3c9>
            zeros = precision > len ? precision - len : 0;
  10091f:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  100922:	89 fa                	mov    %edi,%edx
  100924:	29 c2                	sub    %eax,%edx
  100926:	39 c7                	cmp    %eax,%edi
  100928:	b8 00 00 00 00       	mov    $0x0,%eax
  10092d:	0f 4e d0             	cmovle %eax,%edx
  100930:	89 55 9c             	mov    %edx,-0x64(%rbp)
  100933:	e9 52 fd ff ff       	jmpq   10068a <printer_vprintf+0x3df>
                   && len + (int) strlen(prefix) < width) {
  100938:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  10093c:	e8 76 f8 ff ff       	callq  1001b7 <strlen>
  100941:	8b 7d 98             	mov    -0x68(%rbp),%edi
  100944:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  100947:	44 89 e9             	mov    %r13d,%ecx
  10094a:	29 f9                	sub    %edi,%ecx
  10094c:	29 c1                	sub    %eax,%ecx
  10094e:	89 c8                	mov    %ecx,%eax
  100950:	44 39 ea             	cmp    %r13d,%edx
  100953:	b9 00 00 00 00       	mov    $0x0,%ecx
  100958:	0f 4d c1             	cmovge %ecx,%eax
  10095b:	89 45 9c             	mov    %eax,-0x64(%rbp)
  10095e:	e9 27 fd ff ff       	jmpq   10068a <printer_vprintf+0x3df>
            numbuf[0] = (*format ? *format : '%');
  100963:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  100966:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  10096a:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  10096e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100974:	e9 90 fc ff ff       	jmpq   100609 <printer_vprintf+0x35e>
        int flags = 0;
  100979:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  100980:	e9 ad f9 ff ff       	jmpq   100332 <printer_vprintf+0x87>
}
  100985:	48 83 c4 58          	add    $0x58,%rsp
  100989:	5b                   	pop    %rbx
  10098a:	41 5c                	pop    %r12
  10098c:	41 5d                	pop    %r13
  10098e:	41 5e                	pop    %r14
  100990:	41 5f                	pop    %r15
  100992:	5d                   	pop    %rbp
  100993:	c3                   	retq   

0000000000100994 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100994:	55                   	push   %rbp
  100995:	48 89 e5             	mov    %rsp,%rbp
  100998:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  10099c:	48 c7 45 f0 92 00 10 	movq   $0x100092,-0x10(%rbp)
  1009a3:	00 
        cpos = 0;
  1009a4:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  1009aa:	b8 00 00 00 00       	mov    $0x0,%eax
  1009af:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1009b2:	48 63 ff             	movslq %edi,%rdi
  1009b5:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1009bc:	00 
  1009bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1009c1:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1009c5:	e8 e1 f8 ff ff       	callq  1002ab <printer_vprintf>
    return cp.cursor - console;
  1009ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1009ce:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1009d4:	48 d1 f8             	sar    %rax
}
  1009d7:	c9                   	leaveq 
  1009d8:	c3                   	retq   

00000000001009d9 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1009d9:	55                   	push   %rbp
  1009da:	48 89 e5             	mov    %rsp,%rbp
  1009dd:	48 83 ec 50          	sub    $0x50,%rsp
  1009e1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1009e5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1009e9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1009ed:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1009f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1009f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1009fc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100a00:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100a04:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100a08:	e8 87 ff ff ff       	callq  100994 <console_vprintf>
}
  100a0d:	c9                   	leaveq 
  100a0e:	c3                   	retq   

0000000000100a0f <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100a0f:	55                   	push   %rbp
  100a10:	48 89 e5             	mov    %rsp,%rbp
  100a13:	53                   	push   %rbx
  100a14:	48 83 ec 28          	sub    $0x28,%rsp
  100a18:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100a1b:	48 c7 45 d8 1c 01 10 	movq   $0x10011c,-0x28(%rbp)
  100a22:	00 
    sp.s = s;
  100a23:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100a27:	48 85 f6             	test   %rsi,%rsi
  100a2a:	75 0e                	jne    100a3a <vsnprintf+0x2b>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100a2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100a30:	48 29 d8             	sub    %rbx,%rax
}
  100a33:	48 83 c4 28          	add    $0x28,%rsp
  100a37:	5b                   	pop    %rbx
  100a38:	5d                   	pop    %rbp
  100a39:	c3                   	retq   
        sp.end = s + size - 1;
  100a3a:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100a3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100a43:	be 00 00 00 00       	mov    $0x0,%esi
  100a48:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100a4c:	e8 5a f8 ff ff       	callq  1002ab <printer_vprintf>
        *sp.s = 0;
  100a51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100a55:	c6 00 00             	movb   $0x0,(%rax)
  100a58:	eb d2                	jmp    100a2c <vsnprintf+0x1d>

0000000000100a5a <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100a5a:	55                   	push   %rbp
  100a5b:	48 89 e5             	mov    %rsp,%rbp
  100a5e:	48 83 ec 50          	sub    $0x50,%rsp
  100a62:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100a66:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100a6a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100a6e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100a75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100a79:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100a7d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100a81:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100a85:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100a89:	e8 81 ff ff ff       	callq  100a0f <vsnprintf>
    va_end(val);
    return n;
}
  100a8e:	c9                   	leaveq 
  100a8f:	c3                   	retq   

0000000000100a90 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100a90:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100a95:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  100a9a:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100a9f:	48 83 c0 02          	add    $0x2,%rax
  100aa3:	48 39 d0             	cmp    %rdx,%rax
  100aa6:	75 f2                	jne    100a9a <console_clear+0xa>
    }
    cursorpos = 0;
  100aa8:	c7 05 4a 85 fb ff 00 	movl   $0x0,-0x47ab6(%rip)        # b8ffc <cursorpos>
  100aaf:	00 00 00 
}
  100ab2:	c3                   	retq   
