
obj/p-fork.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
extern uint8_t end[];

uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	53                   	push   %rbx
  100005:	48 83 ec 08          	sub    $0x8,%rsp
// sys_fork()
//    Fork the current process. On success, return the child's process ID to
//    the parent, and return 0 to the child. On failure, return -1.
static inline pid_t sys_fork(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100009:	cd 34                	int    $0x34
    // Fork a total of three new copies.
    pid_t p1 = sys_fork();
    assert(p1 >= 0);
  10000b:	85 c0                	test   %eax,%eax
  10000d:	78 50                	js     10005f <process_main+0x5f>
  10000f:	89 c1                	mov    %eax,%ecx
  100011:	cd 34                	int    $0x34
  100013:	89 c2                	mov    %eax,%edx
    pid_t p2 = sys_fork();
    assert(p2 >= 0);
  100015:	85 c0                	test   %eax,%eax
  100017:	78 5a                	js     100073 <process_main+0x73>
    asm volatile ("int %1" : "=a" (result)
  100019:	cd 31                	int    $0x31

    // Check fork return values: fork should return 0 to child.
    if (sys_getpid() == 1) {
  10001b:	83 f8 01             	cmp    $0x1,%eax
  10001e:	74 67                	je     100087 <process_main+0x87>
        assert(p1 != 0 && p2 != 0 && p1 != p2);
    } else {
        assert(p1 == 0 || p2 == 0);
  100020:	85 c9                	test   %ecx,%ecx
  100022:	74 08                	je     10002c <process_main+0x2c>
  100024:	85 d2                	test   %edx,%edx
  100026:	0f 85 83 00 00 00    	jne    1000af <process_main+0xaf>
  10002c:	cd 31                	int    $0x31
  10002e:	89 c7                	mov    %eax,%edi
  100030:	89 c3                	mov    %eax,%ebx
    }

    // The rest of this code is like p-allocator.c.

    pid_t p = sys_getpid();
    srand(p);
  100032:	e8 ea 02 00 00       	callq  100321 <srand>

    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100037:	b8 17 20 10 00       	mov    $0x102017,%eax
  10003c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100042:	48 89 05 bf 0f 00 00 	mov    %rax,0xfbf(%rip)        # 101008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  100049:	48 89 e0             	mov    %rsp,%rax
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  10004c:	48 83 e8 01          	sub    $0x1,%rax
  100050:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100056:	48 89 05 b3 0f 00 00 	mov    %rax,0xfb3(%rip)        # 101010 <stack_bottom>
  10005d:	eb 66                	jmp    1000c5 <process_main+0xc5>
    assert(p1 >= 0);
  10005f:	ba d0 0c 10 00       	mov    $0x100cd0,%edx
  100064:	be 0d 00 00 00       	mov    $0xd,%esi
  100069:	bf d8 0c 10 00       	mov    $0x100cd8,%edi
  10006e:	e8 23 0c 00 00       	callq  100c96 <assert_fail>
    assert(p2 >= 0);
  100073:	ba e1 0c 10 00       	mov    $0x100ce1,%edx
  100078:	be 0f 00 00 00       	mov    $0xf,%esi
  10007d:	bf d8 0c 10 00       	mov    $0x100cd8,%edi
  100082:	e8 0f 0c 00 00       	callq  100c96 <assert_fail>
        assert(p1 != 0 && p2 != 0 && p1 != p2);
  100087:	85 d2                	test   %edx,%edx
  100089:	40 0f 94 c6          	sete   %sil
  10008d:	39 d1                	cmp    %edx,%ecx
  10008f:	0f 94 c0             	sete   %al
  100092:	40 08 c6             	or     %al,%sil
  100095:	75 04                	jne    10009b <process_main+0x9b>
  100097:	85 c9                	test   %ecx,%ecx
  100099:	75 91                	jne    10002c <process_main+0x2c>
  10009b:	ba 00 0d 10 00       	mov    $0x100d00,%edx
  1000a0:	be 13 00 00 00       	mov    $0x13,%esi
  1000a5:	bf d8 0c 10 00       	mov    $0x100cd8,%edi
  1000aa:	e8 e7 0b 00 00       	callq  100c96 <assert_fail>
        assert(p1 == 0 || p2 == 0);
  1000af:	ba e9 0c 10 00       	mov    $0x100ce9,%edx
  1000b4:	be 15 00 00 00       	mov    $0x15,%esi
  1000b9:	bf d8 0c 10 00       	mov    $0x100cd8,%edi
  1000be:	e8 d3 0b 00 00       	callq  100c96 <assert_fail>
    asm volatile ("int %0" : /* no result */
  1000c3:	cd 32                	int    $0x32

    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  1000c5:	e8 1d 02 00 00       	callq  1002e7 <rand>
  1000ca:	89 c2                	mov    %eax,%edx
  1000cc:	48 98                	cltq   
  1000ce:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
  1000d5:	48 c1 f8 25          	sar    $0x25,%rax
  1000d9:	89 d1                	mov    %edx,%ecx
  1000db:	c1 f9 1f             	sar    $0x1f,%ecx
  1000de:	29 c8                	sub    %ecx,%eax
  1000e0:	6b c0 64             	imul   $0x64,%eax,%eax
  1000e3:	29 c2                	sub    %eax,%edx
  1000e5:	39 da                	cmp    %ebx,%edx
  1000e7:	7d da                	jge    1000c3 <process_main+0xc3>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1000e9:	48 8b 3d 18 0f 00 00 	mov    0xf18(%rip),%rdi        # 101008 <heap_top>
  1000f0:	48 3b 3d 19 0f 00 00 	cmp    0xf19(%rip),%rdi        # 101010 <stack_bottom>
  1000f7:	74 1c                	je     100115 <process_main+0x115>
    asm volatile ("int %1" : "=a" (result)
  1000f9:	cd 33                	int    $0x33
  1000fb:	85 c0                	test   %eax,%eax
  1000fd:	78 16                	js     100115 <process_main+0x115>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  1000ff:	48 8b 05 02 0f 00 00 	mov    0xf02(%rip),%rax        # 101008 <heap_top>
  100106:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  100108:	48 81 05 f5 0e 00 00 	addq   $0x1000,0xef5(%rip)        # 101008 <heap_top>
  10010f:	00 10 00 00 
  100113:	eb ae                	jmp    1000c3 <process_main+0xc3>
    asm volatile ("int %0" : /* no result */
  100115:	cd 32                	int    $0x32
  100117:	eb fc                	jmp    100115 <process_main+0x115>

0000000000100119 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100119:	41 89 d0             	mov    %edx,%r8d
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  10011c:	48 81 7f 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rdi)
  100123:	00 
  100124:	72 08                	jb     10012e <console_putc+0x15>
        cp->cursor = console;
  100126:	48 c7 47 08 00 80 0b 	movq   $0xb8000,0x8(%rdi)
  10012d:	00 
    }
    if (c == '\n') {
  10012e:	40 80 fe 0a          	cmp    $0xa,%sil
  100132:	74 17                	je     10014b <console_putc+0x32>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  100134:	48 8b 47 08          	mov    0x8(%rdi),%rax
  100138:	48 8d 50 02          	lea    0x2(%rax),%rdx
  10013c:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  100140:	40 0f b6 f6          	movzbl %sil,%esi
  100144:	44 09 c6             	or     %r8d,%esi
  100147:	66 89 30             	mov    %si,(%rax)
    }
}
  10014a:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  10014b:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  10014f:	48 81 ee 00 80 0b 00 	sub    $0xb8000,%rsi
  100156:	48 89 f1             	mov    %rsi,%rcx
  100159:	48 d1 f9             	sar    %rcx
  10015c:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  100163:	66 66 66 
  100166:	48 89 c8             	mov    %rcx,%rax
  100169:	48 f7 ea             	imul   %rdx
  10016c:	48 c1 fa 05          	sar    $0x5,%rdx
  100170:	48 c1 fe 3f          	sar    $0x3f,%rsi
  100174:	48 29 f2             	sub    %rsi,%rdx
  100177:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  10017b:	48 c1 e0 04          	shl    $0x4,%rax
  10017f:	89 ca                	mov    %ecx,%edx
  100181:	29 c2                	sub    %eax,%edx
  100183:	89 d0                	mov    %edx,%eax
            *cp->cursor++ = ' ' | color;
  100185:	44 89 c6             	mov    %r8d,%esi
  100188:	83 ce 20             	or     $0x20,%esi
  10018b:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  10018f:	4c 8d 41 02          	lea    0x2(%rcx),%r8
  100193:	4c 89 47 08          	mov    %r8,0x8(%rdi)
  100197:	66 89 31             	mov    %si,(%rcx)
        for (; pos != 80; pos++) {
  10019a:	83 c0 01             	add    $0x1,%eax
  10019d:	83 f8 50             	cmp    $0x50,%eax
  1001a0:	75 e9                	jne    10018b <console_putc+0x72>
  1001a2:	c3                   	retq   

00000000001001a3 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1001a3:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1001a7:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1001ab:	73 0b                	jae    1001b8 <string_putc+0x15>
        *sp->s++ = c;
  1001ad:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1001b1:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1001b5:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1001b8:	c3                   	retq   

00000000001001b9 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1001b9:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001bc:	48 85 d2             	test   %rdx,%rdx
  1001bf:	74 17                	je     1001d8 <memcpy+0x1f>
  1001c1:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1001c6:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1001cb:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001cf:	48 83 c1 01          	add    $0x1,%rcx
  1001d3:	48 39 d1             	cmp    %rdx,%rcx
  1001d6:	75 ee                	jne    1001c6 <memcpy+0xd>
}
  1001d8:	c3                   	retq   

00000000001001d9 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  1001d9:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  1001dc:	48 39 fe             	cmp    %rdi,%rsi
  1001df:	72 1d                	jb     1001fe <memmove+0x25>
        while (n-- > 0) {
  1001e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  1001e6:	48 85 d2             	test   %rdx,%rdx
  1001e9:	74 12                	je     1001fd <memmove+0x24>
            *d++ = *s++;
  1001eb:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  1001ef:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  1001f3:	48 83 c1 01          	add    $0x1,%rcx
  1001f7:	48 39 ca             	cmp    %rcx,%rdx
  1001fa:	75 ef                	jne    1001eb <memmove+0x12>
}
  1001fc:	c3                   	retq   
  1001fd:	c3                   	retq   
    if (s < d && s + n > d) {
  1001fe:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  100202:	48 39 cf             	cmp    %rcx,%rdi
  100205:	73 da                	jae    1001e1 <memmove+0x8>
        while (n-- > 0) {
  100207:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  10020b:	48 85 d2             	test   %rdx,%rdx
  10020e:	74 ec                	je     1001fc <memmove+0x23>
            *--d = *--s;
  100210:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  100214:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  100217:	48 83 e9 01          	sub    $0x1,%rcx
  10021b:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  10021f:	75 ef                	jne    100210 <memmove+0x37>
  100221:	c3                   	retq   

0000000000100222 <memset>:
void* memset(void* v, int c, size_t n) {
  100222:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100225:	48 85 d2             	test   %rdx,%rdx
  100228:	74 13                	je     10023d <memset+0x1b>
  10022a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  10022e:	48 89 fa             	mov    %rdi,%rdx
        *p = c;
  100231:	40 88 32             	mov    %sil,(%rdx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100234:	48 83 c2 01          	add    $0x1,%rdx
  100238:	48 39 d1             	cmp    %rdx,%rcx
  10023b:	75 f4                	jne    100231 <memset+0xf>
}
  10023d:	c3                   	retq   

000000000010023e <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  10023e:	80 3f 00             	cmpb   $0x0,(%rdi)
  100241:	74 10                	je     100253 <strlen+0x15>
  100243:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  100248:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  10024c:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  100250:	75 f6                	jne    100248 <strlen+0xa>
  100252:	c3                   	retq   
  100253:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100258:	c3                   	retq   

0000000000100259 <strnlen>:
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  100259:	b8 00 00 00 00       	mov    $0x0,%eax
  10025e:	48 85 f6             	test   %rsi,%rsi
  100261:	74 10                	je     100273 <strnlen+0x1a>
  100263:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  100267:	74 09                	je     100272 <strnlen+0x19>
        ++n;
  100269:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10026d:	48 39 c6             	cmp    %rax,%rsi
  100270:	75 f1                	jne    100263 <strnlen+0xa>
}
  100272:	c3                   	retq   
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  100273:	48 89 f0             	mov    %rsi,%rax
  100276:	c3                   	retq   

0000000000100277 <strcpy>:
char* strcpy(char* dst, const char* src) {
  100277:	48 89 f8             	mov    %rdi,%rax
  10027a:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  10027f:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  100283:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  100286:	48 83 c2 01          	add    $0x1,%rdx
  10028a:	84 c9                	test   %cl,%cl
  10028c:	75 f1                	jne    10027f <strcpy+0x8>
}
  10028e:	c3                   	retq   

000000000010028f <strcmp>:
    while (*a && *b && *a == *b) {
  10028f:	0f b6 17             	movzbl (%rdi),%edx
  100292:	84 d2                	test   %dl,%dl
  100294:	74 1a                	je     1002b0 <strcmp+0x21>
  100296:	0f b6 06             	movzbl (%rsi),%eax
  100299:	38 d0                	cmp    %dl,%al
  10029b:	75 13                	jne    1002b0 <strcmp+0x21>
  10029d:	84 c0                	test   %al,%al
  10029f:	74 0f                	je     1002b0 <strcmp+0x21>
        ++a, ++b;
  1002a1:	48 83 c7 01          	add    $0x1,%rdi
  1002a5:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1002a9:	0f b6 17             	movzbl (%rdi),%edx
  1002ac:	84 d2                	test   %dl,%dl
  1002ae:	75 e6                	jne    100296 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  1002b0:	0f b6 0e             	movzbl (%rsi),%ecx
  1002b3:	38 ca                	cmp    %cl,%dl
  1002b5:	0f 97 c0             	seta   %al
  1002b8:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1002bb:	83 d8 00             	sbb    $0x0,%eax
}
  1002be:	c3                   	retq   

00000000001002bf <strchr>:
    while (*s && *s != (char) c) {
  1002bf:	0f b6 07             	movzbl (%rdi),%eax
  1002c2:	84 c0                	test   %al,%al
  1002c4:	74 10                	je     1002d6 <strchr+0x17>
  1002c6:	40 38 f0             	cmp    %sil,%al
  1002c9:	74 18                	je     1002e3 <strchr+0x24>
        ++s;
  1002cb:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  1002cf:	0f b6 07             	movzbl (%rdi),%eax
  1002d2:	84 c0                	test   %al,%al
  1002d4:	75 f0                	jne    1002c6 <strchr+0x7>
        return NULL;
  1002d6:	40 84 f6             	test   %sil,%sil
  1002d9:	b8 00 00 00 00       	mov    $0x0,%eax
  1002de:	48 0f 44 c7          	cmove  %rdi,%rax
}
  1002e2:	c3                   	retq   
  1002e3:	48 89 f8             	mov    %rdi,%rax
  1002e6:	c3                   	retq   

00000000001002e7 <rand>:
    if (!rand_seed_set) {
  1002e7:	83 3d 16 0d 00 00 00 	cmpl   $0x0,0xd16(%rip)        # 101004 <rand_seed_set>
  1002ee:	74 1b                	je     10030b <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1002f0:	69 05 06 0d 00 00 0d 	imul   $0x19660d,0xd06(%rip),%eax        # 101000 <rand_seed>
  1002f7:	66 19 00 
  1002fa:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1002ff:	89 05 fb 0c 00 00    	mov    %eax,0xcfb(%rip)        # 101000 <rand_seed>
    return rand_seed & RAND_MAX;
  100305:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  10030a:	c3                   	retq   
    rand_seed = seed;
  10030b:	c7 05 eb 0c 00 00 9e 	movl   $0x30d4879e,0xceb(%rip)        # 101000 <rand_seed>
  100312:	87 d4 30 
    rand_seed_set = 1;
  100315:	c7 05 e5 0c 00 00 01 	movl   $0x1,0xce5(%rip)        # 101004 <rand_seed_set>
  10031c:	00 00 00 
}
  10031f:	eb cf                	jmp    1002f0 <rand+0x9>

0000000000100321 <srand>:
    rand_seed = seed;
  100321:	89 3d d9 0c 00 00    	mov    %edi,0xcd9(%rip)        # 101000 <rand_seed>
    rand_seed_set = 1;
  100327:	c7 05 d3 0c 00 00 01 	movl   $0x1,0xcd3(%rip)        # 101004 <rand_seed_set>
  10032e:	00 00 00 
}
  100331:	c3                   	retq   

0000000000100332 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  100332:	55                   	push   %rbp
  100333:	48 89 e5             	mov    %rsp,%rbp
  100336:	41 57                	push   %r15
  100338:	41 56                	push   %r14
  10033a:	41 55                	push   %r13
  10033c:	41 54                	push   %r12
  10033e:	53                   	push   %rbx
  10033f:	48 83 ec 58          	sub    $0x58,%rsp
  100343:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  100347:	0f b6 02             	movzbl (%rdx),%eax
  10034a:	84 c0                	test   %al,%al
  10034c:	0f 84 ba 06 00 00    	je     100a0c <printer_vprintf+0x6da>
  100352:	49 89 fe             	mov    %rdi,%r14
  100355:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  100358:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%rbp)
  10035f:	41 89 f7             	mov    %esi,%r15d
  100362:	e9 a5 04 00 00       	jmpq   10080c <printer_vprintf+0x4da>
        for (++format; *format; ++format) {
  100367:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  10036c:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  100372:	45 84 e4             	test   %r12b,%r12b
  100375:	0f 84 85 06 00 00    	je     100a00 <printer_vprintf+0x6ce>
        int flags = 0;
  10037b:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  100381:	41 0f be f4          	movsbl %r12b,%esi
  100385:	bf 21 0f 10 00       	mov    $0x100f21,%edi
  10038a:	e8 30 ff ff ff       	callq  1002bf <strchr>
  10038f:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  100392:	48 85 c0             	test   %rax,%rax
  100395:	74 55                	je     1003ec <printer_vprintf+0xba>
                flags |= 1 << (flagc - flag_chars);
  100397:	48 81 e9 21 0f 10 00 	sub    $0x100f21,%rcx
  10039e:	b8 01 00 00 00       	mov    $0x1,%eax
  1003a3:	d3 e0                	shl    %cl,%eax
  1003a5:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1003a8:	48 83 c3 01          	add    $0x1,%rbx
  1003ac:	44 0f b6 23          	movzbl (%rbx),%r12d
  1003b0:	45 84 e4             	test   %r12b,%r12b
  1003b3:	75 cc                	jne    100381 <printer_vprintf+0x4f>
  1003b5:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  1003b9:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  1003bf:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  1003c6:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  1003c9:	0f 84 a9 00 00 00    	je     100478 <printer_vprintf+0x146>
        int length = 0;
  1003cf:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  1003d4:	0f b6 13             	movzbl (%rbx),%edx
  1003d7:	8d 42 bd             	lea    -0x43(%rdx),%eax
  1003da:	3c 37                	cmp    $0x37,%al
  1003dc:	0f 87 c5 04 00 00    	ja     1008a7 <printer_vprintf+0x575>
  1003e2:	0f b6 c0             	movzbl %al,%eax
  1003e5:	ff 24 c5 30 0d 10 00 	jmpq   *0x100d30(,%rax,8)
  1003ec:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        if (*format >= '1' && *format <= '9') {
  1003f0:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  1003f5:	3c 08                	cmp    $0x8,%al
  1003f7:	77 2f                	ja     100428 <printer_vprintf+0xf6>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1003f9:	0f b6 03             	movzbl (%rbx),%eax
  1003fc:	8d 50 d0             	lea    -0x30(%rax),%edx
  1003ff:	80 fa 09             	cmp    $0x9,%dl
  100402:	77 5e                	ja     100462 <printer_vprintf+0x130>
  100404:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  10040a:	48 83 c3 01          	add    $0x1,%rbx
  10040e:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  100413:	0f be c0             	movsbl %al,%eax
  100416:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  10041b:	0f b6 03             	movzbl (%rbx),%eax
  10041e:	8d 50 d0             	lea    -0x30(%rax),%edx
  100421:	80 fa 09             	cmp    $0x9,%dl
  100424:	76 e4                	jbe    10040a <printer_vprintf+0xd8>
  100426:	eb 97                	jmp    1003bf <printer_vprintf+0x8d>
        } else if (*format == '*') {
  100428:	41 80 fc 2a          	cmp    $0x2a,%r12b
  10042c:	75 3f                	jne    10046d <printer_vprintf+0x13b>
            width = va_arg(val, int);
  10042e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100432:	8b 01                	mov    (%rcx),%eax
  100434:	83 f8 2f             	cmp    $0x2f,%eax
  100437:	77 17                	ja     100450 <printer_vprintf+0x11e>
  100439:	89 c2                	mov    %eax,%edx
  10043b:	48 03 51 10          	add    0x10(%rcx),%rdx
  10043f:	83 c0 08             	add    $0x8,%eax
  100442:	89 01                	mov    %eax,(%rcx)
  100444:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  100447:	48 83 c3 01          	add    $0x1,%rbx
  10044b:	e9 6f ff ff ff       	jmpq   1003bf <printer_vprintf+0x8d>
            width = va_arg(val, int);
  100450:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100454:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100458:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10045c:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100460:	eb e2                	jmp    100444 <printer_vprintf+0x112>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100462:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  100468:	e9 52 ff ff ff       	jmpq   1003bf <printer_vprintf+0x8d>
        int width = -1;
  10046d:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  100473:	e9 47 ff ff ff       	jmpq   1003bf <printer_vprintf+0x8d>
            ++format;
  100478:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  10047c:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100480:	8d 48 d0             	lea    -0x30(%rax),%ecx
  100483:	80 f9 09             	cmp    $0x9,%cl
  100486:	76 13                	jbe    10049b <printer_vprintf+0x169>
            } else if (*format == '*') {
  100488:	3c 2a                	cmp    $0x2a,%al
  10048a:	74 32                	je     1004be <printer_vprintf+0x18c>
            ++format;
  10048c:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  10048f:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  100496:	e9 34 ff ff ff       	jmpq   1003cf <printer_vprintf+0x9d>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  10049b:	be 00 00 00 00       	mov    $0x0,%esi
                    precision = 10 * precision + *format++ - '0';
  1004a0:	48 83 c2 01          	add    $0x1,%rdx
  1004a4:	8d 0c b6             	lea    (%rsi,%rsi,4),%ecx
  1004a7:	0f be c0             	movsbl %al,%eax
  1004aa:	8d 74 48 d0          	lea    -0x30(%rax,%rcx,2),%esi
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1004ae:	0f b6 02             	movzbl (%rdx),%eax
  1004b1:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1004b4:	80 f9 09             	cmp    $0x9,%cl
  1004b7:	76 e7                	jbe    1004a0 <printer_vprintf+0x16e>
                    precision = 10 * precision + *format++ - '0';
  1004b9:	48 89 d3             	mov    %rdx,%rbx
  1004bc:	eb 1c                	jmp    1004da <printer_vprintf+0x1a8>
                precision = va_arg(val, int);
  1004be:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004c2:	8b 07                	mov    (%rdi),%eax
  1004c4:	83 f8 2f             	cmp    $0x2f,%eax
  1004c7:	77 23                	ja     1004ec <printer_vprintf+0x1ba>
  1004c9:	89 c2                	mov    %eax,%edx
  1004cb:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004cf:	83 c0 08             	add    $0x8,%eax
  1004d2:	89 07                	mov    %eax,(%rdi)
  1004d4:	8b 32                	mov    (%rdx),%esi
                ++format;
  1004d6:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  1004da:	85 f6                	test   %esi,%esi
  1004dc:	b8 00 00 00 00       	mov    $0x0,%eax
  1004e1:	0f 48 f0             	cmovs  %eax,%esi
  1004e4:	89 75 9c             	mov    %esi,-0x64(%rbp)
  1004e7:	e9 e3 fe ff ff       	jmpq   1003cf <printer_vprintf+0x9d>
                precision = va_arg(val, int);
  1004ec:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1004f0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1004f4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004f8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1004fc:	eb d6                	jmp    1004d4 <printer_vprintf+0x1a2>
        switch (*format) {
  1004fe:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100503:	e9 f1 00 00 00       	jmpq   1005f9 <printer_vprintf+0x2c7>
            ++format;
  100508:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  10050c:	8b 4d 80             	mov    -0x80(%rbp),%ecx
            goto again;
  10050f:	e9 c0 fe ff ff       	jmpq   1003d4 <printer_vprintf+0xa2>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100514:	85 c9                	test   %ecx,%ecx
  100516:	74 55                	je     10056d <printer_vprintf+0x23b>
  100518:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10051c:	8b 01                	mov    (%rcx),%eax
  10051e:	83 f8 2f             	cmp    $0x2f,%eax
  100521:	77 38                	ja     10055b <printer_vprintf+0x229>
  100523:	89 c2                	mov    %eax,%edx
  100525:	48 03 51 10          	add    0x10(%rcx),%rdx
  100529:	83 c0 08             	add    $0x8,%eax
  10052c:	89 01                	mov    %eax,(%rcx)
  10052e:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  100531:	48 89 d0             	mov    %rdx,%rax
  100534:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  100538:	49 89 d0             	mov    %rdx,%r8
  10053b:	49 f7 d8             	neg    %r8
  10053e:	25 80 00 00 00       	and    $0x80,%eax
  100543:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  100547:	0b 45 a8             	or     -0x58(%rbp),%eax
  10054a:	83 c8 60             	or     $0x60,%eax
  10054d:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  100550:	41 bc 30 0f 10 00    	mov    $0x100f30,%r12d
            break;
  100556:	e9 35 01 00 00       	jmpq   100690 <printer_vprintf+0x35e>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  10055b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10055f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100563:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100567:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10056b:	eb c1                	jmp    10052e <printer_vprintf+0x1fc>
  10056d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100571:	8b 07                	mov    (%rdi),%eax
  100573:	83 f8 2f             	cmp    $0x2f,%eax
  100576:	77 10                	ja     100588 <printer_vprintf+0x256>
  100578:	89 c2                	mov    %eax,%edx
  10057a:	48 03 57 10          	add    0x10(%rdi),%rdx
  10057e:	83 c0 08             	add    $0x8,%eax
  100581:	89 07                	mov    %eax,(%rdi)
  100583:	48 63 12             	movslq (%rdx),%rdx
  100586:	eb a9                	jmp    100531 <printer_vprintf+0x1ff>
  100588:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10058c:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100590:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100594:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100598:	eb e9                	jmp    100583 <printer_vprintf+0x251>
        int base = 10;
  10059a:	be 0a 00 00 00       	mov    $0xa,%esi
  10059f:	eb 58                	jmp    1005f9 <printer_vprintf+0x2c7>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1005a1:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005a5:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005a9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005ad:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005b1:	eb 60                	jmp    100613 <printer_vprintf+0x2e1>
  1005b3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005b7:	8b 01                	mov    (%rcx),%eax
  1005b9:	83 f8 2f             	cmp    $0x2f,%eax
  1005bc:	77 10                	ja     1005ce <printer_vprintf+0x29c>
  1005be:	89 c2                	mov    %eax,%edx
  1005c0:	48 03 51 10          	add    0x10(%rcx),%rdx
  1005c4:	83 c0 08             	add    $0x8,%eax
  1005c7:	89 01                	mov    %eax,(%rcx)
  1005c9:	44 8b 02             	mov    (%rdx),%r8d
  1005cc:	eb 48                	jmp    100616 <printer_vprintf+0x2e4>
  1005ce:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1005d2:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1005d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005da:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1005de:	eb e9                	jmp    1005c9 <printer_vprintf+0x297>
  1005e0:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  1005e3:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  1005ea:	bf 10 0f 10 00       	mov    $0x100f10,%edi
  1005ef:	e9 e6 02 00 00       	jmpq   1008da <printer_vprintf+0x5a8>
            base = 16;
  1005f4:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1005f9:	85 c9                	test   %ecx,%ecx
  1005fb:	74 b6                	je     1005b3 <printer_vprintf+0x281>
  1005fd:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100601:	8b 07                	mov    (%rdi),%eax
  100603:	83 f8 2f             	cmp    $0x2f,%eax
  100606:	77 99                	ja     1005a1 <printer_vprintf+0x26f>
  100608:	89 c2                	mov    %eax,%edx
  10060a:	48 03 57 10          	add    0x10(%rdi),%rdx
  10060e:	83 c0 08             	add    $0x8,%eax
  100611:	89 07                	mov    %eax,(%rdi)
  100613:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  100616:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  10061a:	85 f6                	test   %esi,%esi
  10061c:	79 c2                	jns    1005e0 <printer_vprintf+0x2ae>
        base = -base;
  10061e:	41 89 f1             	mov    %esi,%r9d
  100621:	f7 de                	neg    %esi
  100623:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  10062a:	bf f0 0e 10 00       	mov    $0x100ef0,%edi
  10062f:	e9 a6 02 00 00       	jmpq   1008da <printer_vprintf+0x5a8>
            num = (uintptr_t) va_arg(val, void*);
  100634:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100638:	8b 07                	mov    (%rdi),%eax
  10063a:	83 f8 2f             	cmp    $0x2f,%eax
  10063d:	77 1c                	ja     10065b <printer_vprintf+0x329>
  10063f:	89 c2                	mov    %eax,%edx
  100641:	48 03 57 10          	add    0x10(%rdi),%rdx
  100645:	83 c0 08             	add    $0x8,%eax
  100648:	89 07                	mov    %eax,(%rdi)
  10064a:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  10064d:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  100654:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100659:	eb c3                	jmp    10061e <printer_vprintf+0x2ec>
            num = (uintptr_t) va_arg(val, void*);
  10065b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10065f:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100663:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100667:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10066b:	eb dd                	jmp    10064a <printer_vprintf+0x318>
            data = va_arg(val, char*);
  10066d:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100671:	8b 01                	mov    (%rcx),%eax
  100673:	83 f8 2f             	cmp    $0x2f,%eax
  100676:	0f 87 a9 01 00 00    	ja     100825 <printer_vprintf+0x4f3>
  10067c:	89 c2                	mov    %eax,%edx
  10067e:	48 03 51 10          	add    0x10(%rcx),%rdx
  100682:	83 c0 08             	add    $0x8,%eax
  100685:	89 01                	mov    %eax,(%rcx)
  100687:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  10068a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  100690:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100693:	83 e0 20             	and    $0x20,%eax
  100696:	89 45 8c             	mov    %eax,-0x74(%rbp)
  100699:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  10069f:	0f 85 25 02 00 00    	jne    1008ca <printer_vprintf+0x598>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1006a5:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006a8:	89 45 88             	mov    %eax,-0x78(%rbp)
  1006ab:	83 e0 60             	and    $0x60,%eax
  1006ae:	83 f8 60             	cmp    $0x60,%eax
  1006b1:	0f 84 58 02 00 00    	je     10090f <printer_vprintf+0x5dd>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1006b7:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006ba:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  1006bd:	48 c7 45 a0 30 0f 10 	movq   $0x100f30,-0x60(%rbp)
  1006c4:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1006c5:	83 f8 21             	cmp    $0x21,%eax
  1006c8:	0f 84 7d 02 00 00    	je     10094b <printer_vprintf+0x619>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1006ce:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  1006d1:	89 c8                	mov    %ecx,%eax
  1006d3:	f7 d0                	not    %eax
  1006d5:	c1 e8 1f             	shr    $0x1f,%eax
  1006d8:	89 45 84             	mov    %eax,-0x7c(%rbp)
  1006db:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1006df:	0f 85 a2 02 00 00    	jne    100987 <printer_vprintf+0x655>
  1006e5:	84 c0                	test   %al,%al
  1006e7:	0f 84 9a 02 00 00    	je     100987 <printer_vprintf+0x655>
            len = strnlen(data, precision);
  1006ed:	48 63 f1             	movslq %ecx,%rsi
  1006f0:	4c 89 e7             	mov    %r12,%rdi
  1006f3:	e8 61 fb ff ff       	callq  100259 <strnlen>
  1006f8:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  1006fb:	8b 45 88             	mov    -0x78(%rbp),%eax
  1006fe:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  100701:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100708:	83 f8 22             	cmp    $0x22,%eax
  10070b:	0f 84 ae 02 00 00    	je     1009bf <printer_vprintf+0x68d>
        width -= len + zeros + strlen(prefix);
  100711:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100715:	e8 24 fb ff ff       	callq  10023e <strlen>
  10071a:	8b 55 9c             	mov    -0x64(%rbp),%edx
  10071d:	03 55 98             	add    -0x68(%rbp),%edx
  100720:	41 29 d5             	sub    %edx,%r13d
  100723:	44 89 ea             	mov    %r13d,%edx
  100726:	29 c2                	sub    %eax,%edx
  100728:	89 55 8c             	mov    %edx,-0x74(%rbp)
  10072b:	41 89 d5             	mov    %edx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  10072e:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  100732:	75 2d                	jne    100761 <printer_vprintf+0x42f>
  100734:	85 d2                	test   %edx,%edx
  100736:	7e 29                	jle    100761 <printer_vprintf+0x42f>
            p->putc(p, ' ', color);
  100738:	44 89 fa             	mov    %r15d,%edx
  10073b:	be 20 00 00 00       	mov    $0x20,%esi
  100740:	4c 89 f7             	mov    %r14,%rdi
  100743:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100746:	41 83 ed 01          	sub    $0x1,%r13d
  10074a:	45 85 ed             	test   %r13d,%r13d
  10074d:	7f e9                	jg     100738 <printer_vprintf+0x406>
  10074f:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  100752:	85 ff                	test   %edi,%edi
  100754:	b8 01 00 00 00       	mov    $0x1,%eax
  100759:	0f 4f c7             	cmovg  %edi,%eax
  10075c:	29 c7                	sub    %eax,%edi
  10075e:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  100761:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  100765:	0f b6 01             	movzbl (%rcx),%eax
  100768:	84 c0                	test   %al,%al
  10076a:	74 22                	je     10078e <printer_vprintf+0x45c>
  10076c:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100770:	48 89 cb             	mov    %rcx,%rbx
            p->putc(p, *prefix, color);
  100773:	0f b6 f0             	movzbl %al,%esi
  100776:	44 89 fa             	mov    %r15d,%edx
  100779:	4c 89 f7             	mov    %r14,%rdi
  10077c:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  10077f:	48 83 c3 01          	add    $0x1,%rbx
  100783:	0f b6 03             	movzbl (%rbx),%eax
  100786:	84 c0                	test   %al,%al
  100788:	75 e9                	jne    100773 <printer_vprintf+0x441>
  10078a:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  10078e:	8b 45 9c             	mov    -0x64(%rbp),%eax
  100791:	85 c0                	test   %eax,%eax
  100793:	7e 1d                	jle    1007b2 <printer_vprintf+0x480>
  100795:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100799:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  10079b:	44 89 fa             	mov    %r15d,%edx
  10079e:	be 30 00 00 00       	mov    $0x30,%esi
  1007a3:	4c 89 f7             	mov    %r14,%rdi
  1007a6:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  1007a9:	83 eb 01             	sub    $0x1,%ebx
  1007ac:	75 ed                	jne    10079b <printer_vprintf+0x469>
  1007ae:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  1007b2:	8b 45 98             	mov    -0x68(%rbp),%eax
  1007b5:	85 c0                	test   %eax,%eax
  1007b7:	7e 2a                	jle    1007e3 <printer_vprintf+0x4b1>
  1007b9:	8d 40 ff             	lea    -0x1(%rax),%eax
  1007bc:	49 8d 44 04 01       	lea    0x1(%r12,%rax,1),%rax
  1007c1:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1007c5:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  1007c8:	41 0f b6 34 24       	movzbl (%r12),%esi
  1007cd:	44 89 fa             	mov    %r15d,%edx
  1007d0:	4c 89 f7             	mov    %r14,%rdi
  1007d3:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  1007d6:	49 83 c4 01          	add    $0x1,%r12
  1007da:	49 39 dc             	cmp    %rbx,%r12
  1007dd:	75 e9                	jne    1007c8 <printer_vprintf+0x496>
  1007df:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  1007e3:	45 85 ed             	test   %r13d,%r13d
  1007e6:	7e 14                	jle    1007fc <printer_vprintf+0x4ca>
            p->putc(p, ' ', color);
  1007e8:	44 89 fa             	mov    %r15d,%edx
  1007eb:	be 20 00 00 00       	mov    $0x20,%esi
  1007f0:	4c 89 f7             	mov    %r14,%rdi
  1007f3:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  1007f6:	41 83 ed 01          	sub    $0x1,%r13d
  1007fa:	75 ec                	jne    1007e8 <printer_vprintf+0x4b6>
    for (; *format; ++format) {
  1007fc:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  100800:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100804:	84 c0                	test   %al,%al
  100806:	0f 84 00 02 00 00    	je     100a0c <printer_vprintf+0x6da>
        if (*format != '%') {
  10080c:	3c 25                	cmp    $0x25,%al
  10080e:	0f 84 53 fb ff ff    	je     100367 <printer_vprintf+0x35>
            p->putc(p, *format, color);
  100814:	0f b6 f0             	movzbl %al,%esi
  100817:	44 89 fa             	mov    %r15d,%edx
  10081a:	4c 89 f7             	mov    %r14,%rdi
  10081d:	41 ff 16             	callq  *(%r14)
            continue;
  100820:	4c 89 e3             	mov    %r12,%rbx
  100823:	eb d7                	jmp    1007fc <printer_vprintf+0x4ca>
            data = va_arg(val, char*);
  100825:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100829:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10082d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100831:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100835:	e9 4d fe ff ff       	jmpq   100687 <printer_vprintf+0x355>
            color = va_arg(val, int);
  10083a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10083e:	8b 07                	mov    (%rdi),%eax
  100840:	83 f8 2f             	cmp    $0x2f,%eax
  100843:	77 10                	ja     100855 <printer_vprintf+0x523>
  100845:	89 c2                	mov    %eax,%edx
  100847:	48 03 57 10          	add    0x10(%rdi),%rdx
  10084b:	83 c0 08             	add    $0x8,%eax
  10084e:	89 07                	mov    %eax,(%rdi)
  100850:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  100853:	eb a7                	jmp    1007fc <printer_vprintf+0x4ca>
            color = va_arg(val, int);
  100855:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100859:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10085d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100861:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100865:	eb e9                	jmp    100850 <printer_vprintf+0x51e>
            numbuf[0] = va_arg(val, int);
  100867:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10086b:	8b 01                	mov    (%rcx),%eax
  10086d:	83 f8 2f             	cmp    $0x2f,%eax
  100870:	77 23                	ja     100895 <printer_vprintf+0x563>
  100872:	89 c2                	mov    %eax,%edx
  100874:	48 03 51 10          	add    0x10(%rcx),%rdx
  100878:	83 c0 08             	add    $0x8,%eax
  10087b:	89 01                	mov    %eax,(%rcx)
  10087d:	8b 02                	mov    (%rdx),%eax
  10087f:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  100882:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100886:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  10088a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  100890:	e9 fb fd ff ff       	jmpq   100690 <printer_vprintf+0x35e>
            numbuf[0] = va_arg(val, int);
  100895:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100899:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10089d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1008a1:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1008a5:	eb d6                	jmp    10087d <printer_vprintf+0x54b>
            numbuf[0] = (*format ? *format : '%');
  1008a7:	84 d2                	test   %dl,%dl
  1008a9:	0f 85 3b 01 00 00    	jne    1009ea <printer_vprintf+0x6b8>
  1008af:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  1008b3:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  1008b7:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  1008bb:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1008bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1008c5:	e9 c6 fd ff ff       	jmpq   100690 <printer_vprintf+0x35e>
        if (flags & FLAG_NUMERIC) {
  1008ca:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1008d0:	bf 10 0f 10 00       	mov    $0x100f10,%edi
        if (flags & FLAG_NUMERIC) {
  1008d5:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1008da:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1008de:	4c 89 c1             	mov    %r8,%rcx
  1008e1:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  1008e5:	48 63 f6             	movslq %esi,%rsi
  1008e8:	49 83 ec 01          	sub    $0x1,%r12
  1008ec:	48 89 c8             	mov    %rcx,%rax
  1008ef:	ba 00 00 00 00       	mov    $0x0,%edx
  1008f4:	48 f7 f6             	div    %rsi
  1008f7:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  1008fb:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  1008ff:	48 89 ca             	mov    %rcx,%rdx
  100902:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  100905:	48 39 d6             	cmp    %rdx,%rsi
  100908:	76 de                	jbe    1008e8 <printer_vprintf+0x5b6>
  10090a:	e9 96 fd ff ff       	jmpq   1006a5 <printer_vprintf+0x373>
                prefix = "-";
  10090f:	48 c7 45 a0 24 0d 10 	movq   $0x100d24,-0x60(%rbp)
  100916:	00 
            if (flags & FLAG_NEGATIVE) {
  100917:	8b 45 a8             	mov    -0x58(%rbp),%eax
  10091a:	a8 80                	test   $0x80,%al
  10091c:	0f 85 ac fd ff ff    	jne    1006ce <printer_vprintf+0x39c>
                prefix = "+";
  100922:	48 c7 45 a0 22 0d 10 	movq   $0x100d22,-0x60(%rbp)
  100929:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  10092a:	a8 10                	test   $0x10,%al
  10092c:	0f 85 9c fd ff ff    	jne    1006ce <printer_vprintf+0x39c>
                prefix = " ";
  100932:	a8 08                	test   $0x8,%al
  100934:	ba 30 0f 10 00       	mov    $0x100f30,%edx
  100939:	b8 2d 0f 10 00       	mov    $0x100f2d,%eax
  10093e:	48 0f 44 c2          	cmove  %rdx,%rax
  100942:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100946:	e9 83 fd ff ff       	jmpq   1006ce <printer_vprintf+0x39c>
                   && (base == 16 || base == -16)
  10094b:	41 8d 41 10          	lea    0x10(%r9),%eax
  10094f:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  100954:	0f 85 74 fd ff ff    	jne    1006ce <printer_vprintf+0x39c>
                   && (num || (flags & FLAG_ALT2))) {
  10095a:	4d 85 c0             	test   %r8,%r8
  10095d:	75 0d                	jne    10096c <printer_vprintf+0x63a>
  10095f:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  100966:	0f 84 62 fd ff ff    	je     1006ce <printer_vprintf+0x39c>
            prefix = (base == -16 ? "0x" : "0X");
  10096c:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  100970:	ba 1f 0d 10 00       	mov    $0x100d1f,%edx
  100975:	b8 26 0d 10 00       	mov    $0x100d26,%eax
  10097a:	48 0f 44 c2          	cmove  %rdx,%rax
  10097e:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100982:	e9 47 fd ff ff       	jmpq   1006ce <printer_vprintf+0x39c>
            len = strlen(data);
  100987:	4c 89 e7             	mov    %r12,%rdi
  10098a:	e8 af f8 ff ff       	callq  10023e <strlen>
  10098f:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100992:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100996:	0f 84 5f fd ff ff    	je     1006fb <printer_vprintf+0x3c9>
  10099c:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  1009a0:	0f 84 55 fd ff ff    	je     1006fb <printer_vprintf+0x3c9>
            zeros = precision > len ? precision - len : 0;
  1009a6:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1009a9:	89 fa                	mov    %edi,%edx
  1009ab:	29 c2                	sub    %eax,%edx
  1009ad:	39 c7                	cmp    %eax,%edi
  1009af:	b8 00 00 00 00       	mov    $0x0,%eax
  1009b4:	0f 4e d0             	cmovle %eax,%edx
  1009b7:	89 55 9c             	mov    %edx,-0x64(%rbp)
  1009ba:	e9 52 fd ff ff       	jmpq   100711 <printer_vprintf+0x3df>
                   && len + (int) strlen(prefix) < width) {
  1009bf:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1009c3:	e8 76 f8 ff ff       	callq  10023e <strlen>
  1009c8:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1009cb:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1009ce:	44 89 e9             	mov    %r13d,%ecx
  1009d1:	29 f9                	sub    %edi,%ecx
  1009d3:	29 c1                	sub    %eax,%ecx
  1009d5:	89 c8                	mov    %ecx,%eax
  1009d7:	44 39 ea             	cmp    %r13d,%edx
  1009da:	b9 00 00 00 00       	mov    $0x0,%ecx
  1009df:	0f 4d c1             	cmovge %ecx,%eax
  1009e2:	89 45 9c             	mov    %eax,-0x64(%rbp)
  1009e5:	e9 27 fd ff ff       	jmpq   100711 <printer_vprintf+0x3df>
            numbuf[0] = (*format ? *format : '%');
  1009ea:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  1009ed:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1009f1:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1009f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1009fb:	e9 90 fc ff ff       	jmpq   100690 <printer_vprintf+0x35e>
        int flags = 0;
  100a00:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  100a07:	e9 ad f9 ff ff       	jmpq   1003b9 <printer_vprintf+0x87>
}
  100a0c:	48 83 c4 58          	add    $0x58,%rsp
  100a10:	5b                   	pop    %rbx
  100a11:	41 5c                	pop    %r12
  100a13:	41 5d                	pop    %r13
  100a15:	41 5e                	pop    %r14
  100a17:	41 5f                	pop    %r15
  100a19:	5d                   	pop    %rbp
  100a1a:	c3                   	retq   

0000000000100a1b <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100a1b:	55                   	push   %rbp
  100a1c:	48 89 e5             	mov    %rsp,%rbp
  100a1f:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  100a23:	48 c7 45 f0 19 01 10 	movq   $0x100119,-0x10(%rbp)
  100a2a:	00 
        cpos = 0;
  100a2b:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  100a31:	b8 00 00 00 00       	mov    $0x0,%eax
  100a36:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  100a39:	48 63 ff             	movslq %edi,%rdi
  100a3c:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  100a43:	00 
  100a44:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100a48:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  100a4c:	e8 e1 f8 ff ff       	callq  100332 <printer_vprintf>
    return cp.cursor - console;
  100a51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100a55:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  100a5b:	48 d1 f8             	sar    %rax
}
  100a5e:	c9                   	leaveq 
  100a5f:	c3                   	retq   

0000000000100a60 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  100a60:	55                   	push   %rbp
  100a61:	48 89 e5             	mov    %rsp,%rbp
  100a64:	48 83 ec 50          	sub    $0x50,%rsp
  100a68:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100a6c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100a70:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  100a74:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100a7b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100a7f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100a83:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100a87:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100a8b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100a8f:	e8 87 ff ff ff       	callq  100a1b <console_vprintf>
}
  100a94:	c9                   	leaveq 
  100a95:	c3                   	retq   

0000000000100a96 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100a96:	55                   	push   %rbp
  100a97:	48 89 e5             	mov    %rsp,%rbp
  100a9a:	53                   	push   %rbx
  100a9b:	48 83 ec 28          	sub    $0x28,%rsp
  100a9f:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100aa2:	48 c7 45 d8 a3 01 10 	movq   $0x1001a3,-0x28(%rbp)
  100aa9:	00 
    sp.s = s;
  100aaa:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100aae:	48 85 f6             	test   %rsi,%rsi
  100ab1:	75 0e                	jne    100ac1 <vsnprintf+0x2b>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100ab3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100ab7:	48 29 d8             	sub    %rbx,%rax
}
  100aba:	48 83 c4 28          	add    $0x28,%rsp
  100abe:	5b                   	pop    %rbx
  100abf:	5d                   	pop    %rbp
  100ac0:	c3                   	retq   
        sp.end = s + size - 1;
  100ac1:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100ac6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100aca:	be 00 00 00 00       	mov    $0x0,%esi
  100acf:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100ad3:	e8 5a f8 ff ff       	callq  100332 <printer_vprintf>
        *sp.s = 0;
  100ad8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100adc:	c6 00 00             	movb   $0x0,(%rax)
  100adf:	eb d2                	jmp    100ab3 <vsnprintf+0x1d>

0000000000100ae1 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100ae1:	55                   	push   %rbp
  100ae2:	48 89 e5             	mov    %rsp,%rbp
  100ae5:	48 83 ec 50          	sub    $0x50,%rsp
  100ae9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100aed:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100af1:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100af5:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100afc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100b00:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100b04:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100b08:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100b0c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100b10:	e8 81 ff ff ff       	callq  100a96 <vsnprintf>
    va_end(val);
    return n;
}
  100b15:	c9                   	leaveq 
  100b16:	c3                   	retq   

0000000000100b17 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b17:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100b1c:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  100b21:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b26:	48 83 c0 02          	add    $0x2,%rax
  100b2a:	48 39 d0             	cmp    %rdx,%rax
  100b2d:	75 f2                	jne    100b21 <console_clear+0xa>
    }
    cursorpos = 0;
  100b2f:	c7 05 c3 84 fb ff 00 	movl   $0x0,-0x47b3d(%rip)        # b8ffc <cursorpos>
  100b36:	00 00 00 
}
  100b39:	c3                   	retq   

0000000000100b3a <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  100b3a:	55                   	push   %rbp
  100b3b:	48 89 e5             	mov    %rsp,%rbp
  100b3e:	48 83 ec 50          	sub    $0x50,%rsp
  100b42:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  100b46:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100b4a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100b4e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  100b52:	b8 00 07 00 00       	mov    $0x700,%eax
    if (colorid < 0) {
  100b57:	85 ff                	test   %edi,%edi
  100b59:	78 2e                	js     100b89 <app_printf+0x4f>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  100b5b:	48 63 ff             	movslq %edi,%rdi
  100b5e:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  100b65:	cc cc cc 
  100b68:	48 89 f8             	mov    %rdi,%rax
  100b6b:	48 f7 e2             	mul    %rdx
  100b6e:	48 89 d0             	mov    %rdx,%rax
  100b71:	48 c1 e8 02          	shr    $0x2,%rax
  100b75:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  100b79:	48 01 c2             	add    %rax,%rdx
  100b7c:	48 29 d7             	sub    %rdx,%rdi
  100b7f:	0f b6 87 60 0f 10 00 	movzbl 0x100f60(%rdi),%eax
  100b86:	c1 e0 08             	shl    $0x8,%eax
    }

    va_list val;
    va_start(val, format);
  100b89:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  100b90:	48 8d 4d 10          	lea    0x10(%rbp),%rcx
  100b94:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  100b98:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  100b9c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  100ba0:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100ba4:	48 89 f2             	mov    %rsi,%rdx
  100ba7:	89 c6                	mov    %eax,%esi
  100ba9:	8b 3d 4d 84 fb ff    	mov    -0x47bb3(%rip),%edi        # b8ffc <cursorpos>
  100baf:	e8 67 fe ff ff       	callq  100a1b <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  100bb4:	3d 30 07 00 00       	cmp    $0x730,%eax
  100bb9:	ba 00 00 00 00       	mov    $0x0,%edx
  100bbe:	0f 4d c2             	cmovge %edx,%eax
  100bc1:	89 05 35 84 fb ff    	mov    %eax,-0x47bcb(%rip)        # b8ffc <cursorpos>
    }
}
  100bc7:	c9                   	leaveq 
  100bc8:	c3                   	retq   

0000000000100bc9 <panic>:


// panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void panic(const char* format, ...) {
  100bc9:	55                   	push   %rbp
  100bca:	48 89 e5             	mov    %rsp,%rbp
  100bcd:	53                   	push   %rbx
  100bce:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  100bd5:	48 89 fb             	mov    %rdi,%rbx
  100bd8:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  100bdc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  100be0:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  100be4:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  100be8:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  100bec:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  100bf3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100bf7:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  100bfb:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  100bff:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  100c03:	ba 07 00 00 00       	mov    $0x7,%edx
  100c08:	be 27 0f 10 00       	mov    $0x100f27,%esi
  100c0d:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  100c14:	e8 a0 f5 ff ff       	callq  1001b9 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  100c19:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  100c1d:	48 89 da             	mov    %rbx,%rdx
  100c20:	be 99 00 00 00       	mov    $0x99,%esi
  100c25:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  100c2c:	e8 65 fe ff ff       	callq  100a96 <vsnprintf>
  100c31:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  100c34:	85 d2                	test   %edx,%edx
  100c36:	7e 0f                	jle    100c47 <panic+0x7e>
  100c38:	83 c0 06             	add    $0x6,%eax
  100c3b:	48 98                	cltq   
  100c3d:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  100c44:	0a 
  100c45:	75 29                	jne    100c70 <panic+0xa7>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  100c47:	48 8d 8d 08 ff ff ff 	lea    -0xf8(%rbp),%rcx
  100c4e:	ba 31 0f 10 00       	mov    $0x100f31,%edx
  100c53:	be 00 c0 00 00       	mov    $0xc000,%esi
  100c58:	bf 30 07 00 00       	mov    $0x730,%edi
  100c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  100c62:	e8 f9 fd ff ff       	callq  100a60 <console_printf>
}

// sys_panic(msg)
//    Panic.
static inline pid_t __attribute__((noreturn)) sys_panic(const char* msg) {
    asm volatile ("int %0" : /* no result */
  100c67:	bf 00 00 00 00       	mov    $0x0,%edi
  100c6c:	cd 30                	int    $0x30
                  : "i" (INT_SYS_PANIC), "D" (msg)
                  : "cc", "memory");
 loop: goto loop;
  100c6e:	eb fe                	jmp    100c6e <panic+0xa5>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  100c70:	48 63 c2             	movslq %edx,%rax
  100c73:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  100c79:	0f 94 c2             	sete   %dl
  100c7c:	0f b6 d2             	movzbl %dl,%edx
  100c7f:	48 29 d0             	sub    %rdx,%rax
  100c82:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  100c89:	ff 
  100c8a:	be 2f 0f 10 00       	mov    $0x100f2f,%esi
  100c8f:	e8 e3 f5 ff ff       	callq  100277 <strcpy>
  100c94:	eb b1                	jmp    100c47 <panic+0x7e>

0000000000100c96 <assert_fail>:
    sys_panic(NULL);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  100c96:	55                   	push   %rbp
  100c97:	48 89 e5             	mov    %rsp,%rbp
  100c9a:	48 89 f9             	mov    %rdi,%rcx
  100c9d:	41 89 f0             	mov    %esi,%r8d
  100ca0:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  100ca3:	ba 38 0f 10 00       	mov    $0x100f38,%edx
  100ca8:	be 00 c0 00 00       	mov    $0xc000,%esi
  100cad:	bf 30 07 00 00       	mov    $0x730,%edi
  100cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  100cb7:	e8 a4 fd ff ff       	callq  100a60 <console_printf>
    asm volatile ("int %0" : /* no result */
  100cbc:	bf 00 00 00 00       	mov    $0x0,%edi
  100cc1:	cd 30                	int    $0x30
 loop: goto loop;
  100cc3:	eb fe                	jmp    100cc3 <assert_fail+0x2d>
