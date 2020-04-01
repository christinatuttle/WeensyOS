
obj/bootsector.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000007c00 <boot_start>:
.set SEGSEL_BOOT_CODE,0x8       # code segment selector

.globl boot_start                               # Entry point
boot_start:
        .code16                         # This runs in real mode
        cli                             # Disable interrupts
    7c00:	fa                   	cli    
        cld                             # String operations increment
    7c01:	fc                   	cld    

        # All segments are initially 0.
        # Set up the stack pointer, growing downward from 0x7c00.
        movw    $boot_start, %sp
    7c02:	bc                   	.byte 0xbc
    7c03:	00                   	.byte 0x0
    7c04:	7c                   	.byte 0x7c

0000000000007c05 <seta20.1>:
#   and subsequent 80286-based PCs wanted to retain maximum compatibility),
#   physical address line 20 is tied to low when the machine boots.
#   Obviously this a bit of a drag for us, especially when trying to
#   address memory above 1MB.  This code undoes this.

seta20.1:       inb     $0x64, %al              # Get status
    7c05:	e4 64                	in     $0x64,%al
                testb   $0x2, %al               # Busy?
    7c07:	a8 02                	test   $0x2,%al
                jnz     seta20.1                # Yes
    7c09:	75 fa                	jne    7c05 <seta20.1>
                movb    $0xd1, %al              # Command: Write
    7c0b:	b0 d1                	mov    $0xd1,%al
                outb    %al, $0x64              #  output port
    7c0d:	e6 64                	out    %al,$0x64

0000000000007c0f <seta20.2>:
seta20.2:       inb     $0x64, %al              # Get status
    7c0f:	e4 64                	in     $0x64,%al
                testb   $0x2, %al               # Busy?
    7c11:	a8 02                	test   $0x2,%al
                jnz     seta20.2                # Yes
    7c13:	75 fa                	jne    7c0f <seta20.2>
                movb    $0xdf, %al              # Command: Enable
    7c15:	b0 df                	mov    $0xdf,%al
                outb    %al, $0x60              #  A20
    7c17:	e6 60                	out    %al,$0x60

0000000000007c19 <init_pt>:
        .set PTE_U,4
        .set PTE_PS,128

        .code16
init_pt:
        movl    $INITIAL_PT, %edi       # clear page table memory
    7c19:	66 bf 00 80          	mov    $0x8000,%di
    7c1d:	00 00                	add    %al,(%rax)
        xorl    %eax, %eax
    7c1f:	66 31 c0             	xor    %ax,%ax
        movl    $(0x3000 / 4), %ecx
    7c22:	66 b9 00 0c          	mov    $0xc00,%cx
    7c26:	00 00                	add    %al,(%rax)
        rep stosl
    7c28:	66 f3 ab             	rep stos %ax,%es:(%rdi)
        # 0x8000: L1 page table; entry 0 points to:
        # 0x9000: L2 page table; entry 0 points to:
        # 0xA000: L3 page table; entry 0 is a huge page covering 0-0x3FFFFFFF
        # Modern x86-64 processors support PTE_PS on L2 page entries,
        # but the this QEMU version does not.
        movl    $INITIAL_PT, %edi       # set up page table: use a large page
    7c2b:	66 bf 00 80          	mov    $0x8000,%di
    7c2f:	00 00                	add    %al,(%rax)
        leal    0x1000 + PTE_P + PTE_W + PTE_U(%edi), %ecx
    7c31:	67 66 8d 8f 07 10 00 	lea    0x1007(%edi),%cx
    7c38:	00 
        movl    %ecx, (%edi)
    7c39:	67 66 89 0f          	mov    %cx,(%edi)
        leal    0x2000 + PTE_P + PTE_W + PTE_U(%edi), %ecx
    7c3d:	67 66 8d 8f 07 20 00 	lea    0x2007(%edi),%cx
    7c44:	00 
        movl    %ecx, 0x1000(%edi)
    7c45:	67 66 89 8f 00 10 00 	mov    %cx,0x1000(%edi)
    7c4c:	00 
        movl    $(PTE_P + PTE_W + PTE_U + PTE_PS), -7(%ecx)
    7c4d:	67 66 c7 41 f9 87 00 	movw   $0x87,-0x7(%ecx)
    7c54:	00 00                	add    %al,(%rax)
        movl    %edi, %cr3
    7c56:	0f 22 df             	mov    %rdi,%cr3

0000000000007c59 <real_to_prot>:
        .set IA32_EFER_SCE,1            # enable syscall/sysret
        .set IA32_EFER_LME,0x100        # enable 64-bit mode
        .set IA32_EFER_NXE,0x800

real_to_prot:
        movl    %cr4, %eax              # enable physical address extensions
    7c59:	0f 20 e0             	mov    %cr4,%rax
        orl     $(CR4_PSE | CR4_PAE), %eax
    7c5c:	66 83 c8 30          	or     $0x30,%ax
        movl    %eax, %cr4
    7c60:	0f 22 e0             	mov    %rax,%cr4

        movl    $MSR_IA32_EFER, %ecx    # turn on 64-bit mode
    7c63:	66 b9 80 00          	mov    $0x80,%cx
    7c67:	00 c0                	add    %al,%al
        rdmsr
    7c69:	0f 32                	rdmsr  
        orl     $(IA32_EFER_LME | IA32_EFER_SCE | IA32_EFER_NXE), %eax
    7c6b:	66 0d 01 09          	or     $0x901,%ax
    7c6f:	00 00                	add    %al,(%rax)
        wrmsr
    7c71:	0f 30                	wrmsr  

        movl    %cr0, %eax              # turn on protected mode
    7c73:	0f 20 c0             	mov    %cr0,%rax
        orl     $(CR0_PE | CR0_WP | CR0_PG), %eax
    7c76:	66 0d 01 00          	or     $0x1,%ax
    7c7a:	01 80 0f 22 c0 0f    	add    %eax,0xfc0220f(%rax)
        movl    %eax, %cr0

        lgdt    gdtdesc                 # load GDT
    7c80:	01 16                	add    %edx,(%rsi)
    7c82:	9c                   	pushfq 
    7c83:	7c ea                	jl     7c6f <real_to_prot+0x16>

        # CPU magic: jump to relocation, flush prefetch queue, and
        # reload %cs.  Has the effect of just jmp to the next
        # instruction, but simultaneously loads CS with
        # $SEGSEL_BOOT_CODE.
        ljmp    $SEGSEL_BOOT_CODE, $boot
    7c85:	09 7d 08             	or     %edi,0x8(%rbp)
    7c88:	00 0f                	add    %cl,(%rdi)
    7c8a:	1f                   	(bad)  
	...

0000000000007c8c <gdt>:
	...
    7c98:	00                   	.byte 0x0
    7c99:	98                   	cwtl   
    7c9a:	20 00                	and    %al,(%rax)

0000000000007c9c <gdtdesc>:
    7c9c:	0f 00 8c 7c 00 00 00 	str    0x0(%rsp,%rdi,2)
    7ca3:	00 
	...

0000000000007ca6 <boot_readsect>:
    asm volatile("int3");
}

static inline uint8_t inb(int port) {
    uint8_t data;
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7ca6:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
    7cab:	89 ca                	mov    %ecx,%edx
    7cad:	ec                   	in     (%dx),%al
// boot_waitdisk
//    Wait for the disk to be ready.
static void boot_waitdisk(void) {
    // Wait until the ATA status register says ready (0x40 is on)
    // & not busy (0x80 is off)
    while ((inb(0x1F7) & 0xC0) != 0x40) {
    7cae:	83 e0 c0             	and    $0xffffffc0,%eax
    7cb1:	3c 40                	cmp    $0x40,%al
    7cb3:	75 f6                	jne    7cab <boot_readsect+0x5>
                 : "d" (port), "0" (addr), "1" (cnt)
                 : "memory", "cc");
}

static inline void outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7cb5:	b0 01                	mov    $0x1,%al
    7cb7:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7cbc:	ee                   	out    %al,(%dx)
    7cbd:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7cc2:	89 f0                	mov    %esi,%eax
    7cc4:	ee                   	out    %al,(%dx)
static void boot_readsect(uintptr_t dst, uint32_t src_sect) {
    // programmed I/O for "read sector"
    boot_waitdisk();
    outb(0x1F2, 1);             // send `count = 1` as an ATA argument
    outb(0x1F3, src_sect);      // send `src_sect`, the sector number
    outb(0x1F4, src_sect >> 8);
    7cc5:	89 f0                	mov    %esi,%eax
    7cc7:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7ccc:	c1 e8 08             	shr    $0x8,%eax
    7ccf:	ee                   	out    %al,(%dx)
    outb(0x1F5, src_sect >> 16);
    7cd0:	89 f0                	mov    %esi,%eax
    7cd2:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7cd7:	c1 e8 10             	shr    $0x10,%eax
    7cda:	ee                   	out    %al,(%dx)
    outb(0x1F6, (src_sect >> 24) | 0xE0);
    7cdb:	c1 ee 18             	shr    $0x18,%esi
    7cde:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7ce3:	89 f0                	mov    %esi,%eax
    7ce5:	83 c8 e0             	or     $0xffffffe0,%eax
    7ce8:	ee                   	out    %al,(%dx)
    7ce9:	b0 20                	mov    $0x20,%al
    7ceb:	89 ca                	mov    %ecx,%edx
    7ced:	ee                   	out    %al,(%dx)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7cee:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cf3:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40) {
    7cf4:	83 e0 c0             	and    $0xffffffc0,%eax
    7cf7:	3c 40                	cmp    $0x40,%al
    7cf9:	75 f8                	jne    7cf3 <boot_readsect+0x4d>
    asm volatile("cld\n\trepne\n\tinsl"
    7cfb:	b9 80 00 00 00       	mov    $0x80,%ecx
    7d00:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7d05:	fc                   	cld    
    7d06:	f2 6d                	repnz insl (%dx),%es:(%rdi)
    outb(0x1F7, 0x20);          // send the command: 0x20 = read sectors

    // then move the data into memory
    boot_waitdisk();
    insl(0x1F0, (void*) dst, SECTORSIZE/4); // read 128 words from the disk
}
    7d08:	c3                   	retq   

0000000000007d09 <boot>:
void boot(void) {
    7d09:	55                   	push   %rbp
    7d0a:	41 b9 01 00 00 00    	mov    $0x1,%r9d
    ptr &= ~(SECTORSIZE - 1);
    7d10:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
void boot(void) {
    7d16:	53                   	push   %rbx
    7d17:	50                   	push   %rax
        boot_readsect(ptr, src_sect);
    7d18:	44 89 ce             	mov    %r9d,%esi
    7d1b:	4c 89 c7             	mov    %r8,%rdi
    7d1e:	e8 83 ff ff ff       	callq  7ca6 <boot_readsect>
    for (; ptr < end_ptr; ptr += SECTORSIZE, ++src_sect) {
    7d23:	49 81 c0 00 02 00 00 	add    $0x200,%r8
    7d2a:	41 ff c1             	inc    %r9d
    7d2d:	49 81 f8 00 10 01 00 	cmp    $0x11000,%r8
    7d34:	75 e2                	jne    7d18 <boot+0xf>
    while (ELFHDR->e_magic != ELF_MAGIC) {
    7d36:	8b 04 25 00 00 01 00 	mov    0x10000,%eax
    7d3d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
    7d42:	75 f9                	jne    7d3d <boot+0x34>
    elf_program* eph = ph + ELFHDR->e_phnum;
    7d44:	44 0f b7 1c 25 38 00 	movzwl 0x10038,%r11d
    7d4b:	01 00 
    elf_program* ph = (elf_program*) ((uint8_t*) ELFHDR + ELFHDR->e_phoff);
    7d4d:	48 8b 04 25 20 00 01 	mov    0x10020,%rax
    7d54:	00 
    elf_program* eph = ph + ELFHDR->e_phnum;
    7d55:	4d 6b db 38          	imul   $0x38,%r11,%r11
    elf_program* ph = (elf_program*) ((uint8_t*) ELFHDR + ELFHDR->e_phoff);
    7d59:	4c 8d 80 00 00 01 00 	lea    0x10000(%rax),%r8
    elf_program* eph = ph + ELFHDR->e_phnum;
    7d60:	4d 01 c3             	add    %r8,%r11
    for (; ph < eph; ++ph) {
    7d63:	4d 39 d8             	cmp    %r11,%r8
    7d66:	73 53                	jae    7dbb <boot+0xb2>
        boot_readseg(ph->p_va, ph->p_offset / SECTORSIZE + 1,
    7d68:	4d 8b 50 08          	mov    0x8(%r8),%r10
    7d6c:	4d 8b 48 10          	mov    0x10(%r8),%r9
    uintptr_t end_ptr = ptr + filesz;
    7d70:	49 8b 58 20          	mov    0x20(%r8),%rbx
    memsz += ptr;
    7d74:	49 8b 68 28          	mov    0x28(%r8),%rbp
        boot_readseg(ph->p_va, ph->p_offset / SECTORSIZE + 1,
    7d78:	49 c1 ea 09          	shr    $0x9,%r10
    uintptr_t end_ptr = ptr + filesz;
    7d7c:	4c 01 cb             	add    %r9,%rbx
    memsz += ptr;
    7d7f:	4c 01 cd             	add    %r9,%rbp
        boot_readseg(ph->p_va, ph->p_offset / SECTORSIZE + 1,
    7d82:	41 ff c2             	inc    %r10d
    ptr &= ~(SECTORSIZE - 1);
    7d85:	49 81 e1 00 fe ff ff 	and    $0xfffffffffffffe00,%r9
    for (; ptr < end_ptr; ptr += SECTORSIZE, ++src_sect) {
    7d8c:	4c 39 cb             	cmp    %r9,%rbx
    7d8f:	76 17                	jbe    7da8 <boot+0x9f>
        boot_readsect(ptr, src_sect);
    7d91:	44 89 d6             	mov    %r10d,%esi
    7d94:	4c 89 cf             	mov    %r9,%rdi
    7d97:	e8 0a ff ff ff       	callq  7ca6 <boot_readsect>
    for (; ptr < end_ptr; ptr += SECTORSIZE, ++src_sect) {
    7d9c:	49 81 c1 00 02 00 00 	add    $0x200,%r9
    7da3:	41 ff c2             	inc    %r10d
    7da6:	eb e4                	jmp    7d8c <boot+0x83>
    for (; end_ptr < memsz; ++end_ptr) {
    7da8:	48 39 dd             	cmp    %rbx,%rbp
    7dab:	76 08                	jbe    7db5 <boot+0xac>
        *(uint8_t*) end_ptr = 0;
    7dad:	c6 03 00             	movb   $0x0,(%rbx)
    for (; end_ptr < memsz; ++end_ptr) {
    7db0:	48 ff c3             	inc    %rbx
    7db3:	eb f3                	jmp    7da8 <boot+0x9f>
    for (; ph < eph; ++ph) {
    7db5:	49 83 c0 38          	add    $0x38,%r8
    7db9:	eb a8                	jmp    7d63 <boot+0x5a>
    kernel_entry();
    7dbb:	ff 14 25 18 00 01 00 	callq  *0x10018
