
kernel:     file format elf64-x86-64


Disassembly of section .text:

ffff800000100000 <begin>:
ffff800000100000:	02 b0 ad 1b 00 00    	add    0x1bad(%rax),%dh
ffff800000100006:	01 00                	add    %eax,(%rax)
ffff800000100008:	fe 4f 51             	decb   0x51(%rdi)
ffff80000010000b:	e4 00                	in     $0x0,%al
ffff80000010000d:	00 10                	add    %dl,(%rax)
ffff80000010000f:	00 00                	add    %al,(%rax)
ffff800000100011:	00 10                	add    %dl,(%rax)
ffff800000100013:	00 00                	add    %al,(%rax)
ffff800000100015:	e0 10                	loopne ffff800000100027 <mboot_entry+0x7>
ffff800000100017:	00 00                	add    %al,(%rax)
ffff800000100019:	b0 11                	mov    $0x11,%al
ffff80000010001b:	00 20                	add    %ah,(%rax)
ffff80000010001d:	00 10                	add    %dl,(%rax)
	...

ffff800000100020 <mboot_entry>:
  .long mboot_entry_addr

.code32
mboot_entry:
# zero 2 pages for our bootstrap page tables
  xor     %eax, %eax    # value=0
ffff800000100020:	31 c0                	xor    %eax,%eax
  mov     $0x1000, %edi # starting at 4096
ffff800000100022:	bf 00 10 00 00       	mov    $0x1000,%edi
  mov     $0x2000, %ecx # size=8192
ffff800000100027:	b9 00 20 00 00       	mov    $0x2000,%ecx
  rep     stosb         # memset(4096, 0, 8192)
ffff80000010002c:	f3 aa                	rep stos %al,%es:(%rdi)

# map both virtual address 0 and KERNBASE to the same PDPT
# PML4T[0] -> 0x2000 (PDPT)
# PML4T[256] -> 0x2000 (PDPT)
  mov     $(0x2000 | PTE_P | PTE_W), %eax
ffff80000010002e:	b8 03 20 00 00       	mov    $0x2003,%eax
  mov     %eax, 0x1000  # PML4T[0]
ffff800000100033:	a3 00 10 00 00 a3 00 	movabs %eax,0x1800a300001000
ffff80000010003a:	18 00 
  mov     %eax, 0x1800  # PML4T[512]
ffff80000010003c:	00 b8 83 00 00 00    	add    %bh,0x83(%rax)

# PDPT[0] -> 0x0 (1 GB flat map page)
  mov     $(0x0 | PTE_P | PTE_PS | PTE_W), %eax
  mov     %eax, 0x2000  # PDPT[0]
ffff800000100042:	a3                   	.byte 0xa3
ffff800000100043:	00 20                	add    %ah,(%rax)
ffff800000100045:	00 00                	add    %al,(%rax)

# Clear ebx for initial processor boot.
# When secondary processors boot, they'll call through
# entry32mp (from entryother), but with a nonzero ebx.
# We'll reuse these bootstrap pagetables and GDT.
  xor     %ebx, %ebx
ffff800000100047:	31 db                	xor    %ebx,%ebx

ffff800000100049 <entry32mp>:

.global entry32mp
entry32mp:
# CR3 -> 0x1000 (PML4T)
  mov     $0x1000, %eax
ffff800000100049:	b8 00 10 00 00       	mov    $0x1000,%eax
  mov     %eax, %cr3
ffff80000010004e:	0f 22 d8             	mov    %rax,%cr3

  lgdt    (gdtr64 - mboot_header + mboot_load_addr)
ffff800000100051:	0f 01 15 90 00 10 00 	lgdt   0x100090(%rip)        # ffff8000002000e8 <end+0xe50e8>

# PAE is required for 64-bit paging: CR4.PAE=1
  mov     %cr4, %eax
ffff800000100058:	0f 20 e0             	mov    %cr4,%rax
  bts     $5, %eax
ffff80000010005b:	0f ba e8 05          	bts    $0x5,%eax
  mov     %eax, %cr4
ffff80000010005f:	0f 22 e0             	mov    %rax,%cr4

# access EFER Model specific register
  mov     $MSR_EFER, %ecx
ffff800000100062:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
ffff800000100067:	0f 32                	rdmsr  
  bts     $0, %eax #enable system call extentions
ffff800000100069:	0f ba e8 00          	bts    $0x0,%eax
  bts     $8, %eax #enable long mode
ffff80000010006d:	0f ba e8 08          	bts    $0x8,%eax
  wrmsr
ffff800000100071:	0f 30                	wrmsr  

# enable paging
  mov     %cr0, %eax
ffff800000100073:	0f 20 c0             	mov    %cr0,%rax
  orl     $(CR0_PG | CR0_WP | CR0_MP), %eax
ffff800000100076:	0d 02 00 01 80       	or     $0x80010002,%eax
  mov     %eax, %cr0
ffff80000010007b:	0f 22 c0             	mov    %rax,%cr0

# shift to 64bit segment
  ljmp    $8, $(entry64low - mboot_header + mboot_load_addr)
ffff80000010007e:	ea                   	(bad)  
ffff80000010007f:	c0 00 10             	rolb   $0x10,(%rax)
ffff800000100082:	00 08                	add    %cl,(%rax)
ffff800000100084:	00 66 66             	add    %ah,0x66(%rsi)
ffff800000100087:	2e 0f 1f 84 00 00 00 	nopl   %cs:0x0(%rax,%rax,1)
ffff80000010008e:	00 00 

ffff800000100090 <gdtr64>:
ffff800000100090:	17                   	(bad)  
ffff800000100091:	00 a0 00 10 00 00    	add    %ah,0x1000(%rax)
ffff800000100097:	00 00                	add    %al,(%rax)
ffff800000100099:	00 66 0f             	add    %ah,0xf(%rsi)
ffff80000010009c:	1f                   	(bad)  
ffff80000010009d:	44 00 00             	add    %r8b,(%rax)

ffff8000001000a0 <gdt64_begin>:
	...
ffff8000001000ac:	00 98 20 00 00 00    	add    %bl,0x20(%rax)
ffff8000001000b2:	00 00                	add    %al,(%rax)
ffff8000001000b4:	00                   	.byte 0x0
ffff8000001000b5:	90                   	nop
	...

ffff8000001000b8 <gdt64_end>:
ffff8000001000b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
ffff8000001000bf:	00 

ffff8000001000c0 <entry64low>:
gdt64_end:

.align 16
.code64
entry64low:
  movabs  $entry64high, %rax
ffff8000001000c0:	48 b8 cc 00 10 00 00 	movabs $0xffff8000001000cc,%rax
ffff8000001000c7:	80 ff ff 
  jmp     *%rax
ffff8000001000ca:	ff e0                	jmpq   *%rax

ffff8000001000cc <_start>:
.global _start
_start:
entry64high:

# ensure data segment registers are sane
  xor     %rax, %rax
ffff8000001000cc:	48 31 c0             	xor    %rax,%rax
  mov     %ax, %ss
ffff8000001000cf:	8e d0                	mov    %eax,%ss
  mov     %ax, %ds
ffff8000001000d1:	8e d8                	mov    %eax,%ds
  mov     %ax, %es
ffff8000001000d3:	8e c0                	mov    %eax,%es
  mov     %ax, %fs
ffff8000001000d5:	8e e0                	mov    %eax,%fs
  mov     %ax, %gs
ffff8000001000d7:	8e e8                	mov    %eax,%gs
  # mov     %cr4, %rax
  # or      $(CR4_PAE | CR4_OSXFSR | CR4_OSXMMEXCPT) , %rax
  # mov     %rax, %cr4

# check to see if we're booting a secondary core
  test    %ebx, %ebx
ffff8000001000d9:	85 db                	test   %ebx,%ebx
  jnz     entry64mp  # jump if booting a secondary code
ffff8000001000db:	75 14                	jne    ffff8000001000f1 <entry64mp>
# setup initial stack
  movabs  $0xFFFF800000010000, %rax
ffff8000001000dd:	48 b8 00 00 01 00 00 	movabs $0xffff800000010000,%rax
ffff8000001000e4:	80 ff ff 
  mov     %rax, %rsp
ffff8000001000e7:	48 89 c4             	mov    %rax,%rsp

# enter main()
  jmp     main  # end of initial (the first) core ASM
ffff8000001000ea:	e9 a5 53 00 00       	jmpq   ffff800000105494 <main>

ffff8000001000ef <__deadloop>:

.global __deadloop
__deadloop:
# we should never return here...
  jmp     .
ffff8000001000ef:	eb fe                	jmp    ffff8000001000ef <__deadloop>

ffff8000001000f1 <entry64mp>:

entry64mp:
# obtain kstack from data block before entryother
  mov     $0x7000, %rax
ffff8000001000f1:	48 c7 c0 00 70 00 00 	mov    $0x7000,%rax
  mov     -16(%rax), %rsp
ffff8000001000f8:	48 8b 60 f0          	mov    -0x10(%rax),%rsp
  jmp     mpenter  # end of secondary code ASM
ffff8000001000fc:	e9 c4 54 00 00       	jmpq   ffff8000001055c5 <mpenter>

ffff800000100101 <wrmsr>:

.global wrmsr
wrmsr:
  mov     %rdi, %rcx     # arg0 -> msrnum
ffff800000100101:	48 89 f9             	mov    %rdi,%rcx
  mov     %rsi, %rax     # val.low -> eax
ffff800000100104:	48 89 f0             	mov    %rsi,%rax
  shr     $32, %rsi
ffff800000100107:	48 c1 ee 20          	shr    $0x20,%rsi
  mov     %rsi, %rdx     # val.high -> edx
ffff80000010010b:	48 89 f2             	mov    %rsi,%rdx
  wrmsr
ffff80000010010e:	0f 30                	wrmsr  
  retq
ffff800000100110:	c3                   	retq   

ffff800000100111 <ignore_sysret>:

.global ignore_sysret
ignore_sysret: #return error code 38, meaning function unimplemented
  mov     $-38, %rax
ffff800000100111:	48 c7 c0 da ff ff ff 	mov    $0xffffffffffffffda,%rax
  sysret
ffff800000100118:	0f 07                	sysret 

ffff80000010011a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
ffff80000010011a:	f3 0f 1e fa          	endbr64 
ffff80000010011e:	55                   	push   %rbp
ffff80000010011f:	48 89 e5             	mov    %rsp,%rbp
ffff800000100122:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
ffff800000100126:	48 be d8 bd 10 00 00 	movabs $0xffff80000010bdd8,%rsi
ffff80000010012d:	80 ff ff 
ffff800000100130:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff800000100137:	80 ff ff 
ffff80000010013a:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff800000100141:	80 ff ff 
ffff800000100144:	ff d0                	callq  *%rax
//PAGEBREAK!

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
ffff800000100146:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010014d:	80 ff ff 
ffff800000100150:	48 b9 08 31 11 00 00 	movabs $0xffff800000113108,%rcx
ffff800000100157:	80 ff ff 
ffff80000010015a:	48 89 88 a0 51 00 00 	mov    %rcx,0x51a0(%rax)
  bcache.head.next = &bcache.head;
ffff800000100161:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100168:	80 ff ff 
ffff80000010016b:	48 89 88 a8 51 00 00 	mov    %rcx,0x51a8(%rax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffff800000100172:	48 b8 68 e0 10 00 00 	movabs $0xffff80000010e068,%rax
ffff800000100179:	80 ff ff 
ffff80000010017c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100180:	e9 8b 00 00 00       	jmpq   ffff800000100210 <binit+0xf6>
    b->next = bcache.head.next;
ffff800000100185:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010018c:	80 ff ff 
ffff80000010018f:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
ffff800000100196:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010019a:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->prev = &bcache.head;
ffff8000001001a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001001a5:	48 be 08 31 11 00 00 	movabs $0xffff800000113108,%rsi
ffff8000001001ac:	80 ff ff 
ffff8000001001af:	48 89 b0 98 00 00 00 	mov    %rsi,0x98(%rax)
    initsleeplock(&b->lock, "buffer");
ffff8000001001b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001001ba:	48 83 c0 10          	add    $0x10,%rax
ffff8000001001be:	48 be df bd 10 00 00 	movabs $0xffff80000010bddf,%rsi
ffff8000001001c5:	80 ff ff 
ffff8000001001c8:	48 89 c7             	mov    %rax,%rdi
ffff8000001001cb:	48 b8 ff 72 10 00 00 	movabs $0xffff8000001072ff,%rax
ffff8000001001d2:	80 ff ff 
ffff8000001001d5:	ff d0                	callq  *%rax
    bcache.head.next->prev = b;
ffff8000001001d7:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001001de:	80 ff ff 
ffff8000001001e1:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff8000001001e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001001ec:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    bcache.head.next = b;
ffff8000001001f3:	48 ba 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdx
ffff8000001001fa:	80 ff ff 
ffff8000001001fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100201:	48 89 82 a8 51 00 00 	mov    %rax,0x51a8(%rdx)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffff800000100208:	48 81 45 f8 b0 02 00 	addq   $0x2b0,-0x8(%rbp)
ffff80000010020f:	00 
ffff800000100210:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff800000100217:	80 ff ff 
ffff80000010021a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010021e:	0f 82 61 ff ff ff    	jb     ffff800000100185 <binit+0x6b>
  }
}
ffff800000100224:	90                   	nop
ffff800000100225:	90                   	nop
ffff800000100226:	c9                   	leaveq 
ffff800000100227:	c3                   	retq   

ffff800000100228 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
ffff800000100228:	f3 0f 1e fa          	endbr64 
ffff80000010022c:	55                   	push   %rbp
ffff80000010022d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100230:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100234:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000100237:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  acquire(&bcache.lock);
ffff80000010023a:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff800000100241:	80 ff ff 
ffff800000100244:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff80000010024b:	80 ff ff 
ffff80000010024e:	ff d0                	callq  *%rax

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffff800000100250:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100257:	80 ff ff 
ffff80000010025a:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff800000100261:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100265:	eb 74                	jmp    ffff8000001002db <bget+0xb3>
    if(b->dev == dev && b->blockno == blockno){
ffff800000100267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010026b:	8b 40 04             	mov    0x4(%rax),%eax
ffff80000010026e:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000100271:	75 59                	jne    ffff8000001002cc <bget+0xa4>
ffff800000100273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100277:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010027a:	39 45 e8             	cmp    %eax,-0x18(%rbp)
ffff80000010027d:	75 4d                	jne    ffff8000001002cc <bget+0xa4>
      b->refcnt++;
ffff80000010027f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100283:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100289:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010028c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100290:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
      release(&bcache.lock);
ffff800000100296:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff80000010029d:	80 ff ff 
ffff8000001002a0:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001002a7:	80 ff ff 
ffff8000001002aa:	ff d0                	callq  *%rax
      acquiresleep(&b->lock);
ffff8000001002ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002b0:	48 83 c0 10          	add    $0x10,%rax
ffff8000001002b4:	48 89 c7             	mov    %rax,%rdi
ffff8000001002b7:	48 b8 58 73 10 00 00 	movabs $0xffff800000107358,%rax
ffff8000001002be:	80 ff ff 
ffff8000001002c1:	ff d0                	callq  *%rax
      return b;
ffff8000001002c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002c7:	e9 f0 00 00 00       	jmpq   ffff8000001003bc <bget+0x194>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffff8000001002cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002d0:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff8000001002d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001002db:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff8000001002e2:	80 ff ff 
ffff8000001002e5:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001002e9:	0f 85 78 ff ff ff    	jne    ffff800000100267 <bget+0x3f>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffff8000001002ef:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001002f6:	80 ff ff 
ffff8000001002f9:	48 8b 80 a0 51 00 00 	mov    0x51a0(%rax),%rax
ffff800000100300:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100304:	e9 89 00 00 00       	jmpq   ffff800000100392 <bget+0x16a>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
ffff800000100309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010030d:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100313:	85 c0                	test   %eax,%eax
ffff800000100315:	75 6c                	jne    ffff800000100383 <bget+0x15b>
ffff800000100317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010031b:	8b 00                	mov    (%rax),%eax
ffff80000010031d:	83 e0 04             	and    $0x4,%eax
ffff800000100320:	85 c0                	test   %eax,%eax
ffff800000100322:	75 5f                	jne    ffff800000100383 <bget+0x15b>
      b->dev = dev;
ffff800000100324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100328:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010032b:	89 50 04             	mov    %edx,0x4(%rax)
      b->blockno = blockno;
ffff80000010032e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100332:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000100335:	89 50 08             	mov    %edx,0x8(%rax)
      b->flags = 0;
ffff800000100338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010033c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
      b->refcnt = 1;
ffff800000100342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100346:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%rax)
ffff80000010034d:	00 00 00 
      release(&bcache.lock);
ffff800000100350:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff800000100357:	80 ff ff 
ffff80000010035a:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000100361:	80 ff ff 
ffff800000100364:	ff d0                	callq  *%rax
      acquiresleep(&b->lock);
ffff800000100366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010036a:	48 83 c0 10          	add    $0x10,%rax
ffff80000010036e:	48 89 c7             	mov    %rax,%rdi
ffff800000100371:	48 b8 58 73 10 00 00 	movabs $0xffff800000107358,%rax
ffff800000100378:	80 ff ff 
ffff80000010037b:	ff d0                	callq  *%rax
      return b;
ffff80000010037d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100381:	eb 39                	jmp    ffff8000001003bc <bget+0x194>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffff800000100383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100387:	48 8b 80 98 00 00 00 	mov    0x98(%rax),%rax
ffff80000010038e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100392:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff800000100399:	80 ff ff 
ffff80000010039c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001003a0:	0f 85 63 ff ff ff    	jne    ffff800000100309 <bget+0xe1>
    }
  }
  panic("bget: no buffers");
ffff8000001003a6:	48 bf e6 bd 10 00 00 	movabs $0xffff80000010bde6,%rdi
ffff8000001003ad:	80 ff ff 
ffff8000001003b0:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001003b7:	80 ff ff 
ffff8000001003ba:	ff d0                	callq  *%rax
}
ffff8000001003bc:	c9                   	leaveq 
ffff8000001003bd:	c3                   	retq   

ffff8000001003be <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
ffff8000001003be:	f3 0f 1e fa          	endbr64 
ffff8000001003c2:	55                   	push   %rbp
ffff8000001003c3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001003c6:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001003ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001003cd:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  b = bget(dev, blockno);
ffff8000001003d0:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff8000001003d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001003d6:	89 d6                	mov    %edx,%esi
ffff8000001003d8:	89 c7                	mov    %eax,%edi
ffff8000001003da:	48 b8 28 02 10 00 00 	movabs $0xffff800000100228,%rax
ffff8000001003e1:	80 ff ff 
ffff8000001003e4:	ff d0                	callq  *%rax
ffff8000001003e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(!(b->flags & B_VALID)) {
ffff8000001003ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001003ee:	8b 00                	mov    (%rax),%eax
ffff8000001003f0:	83 e0 02             	and    $0x2,%eax
ffff8000001003f3:	85 c0                	test   %eax,%eax
ffff8000001003f5:	75 13                	jne    ffff80000010040a <bread+0x4c>
    iderw(b);
ffff8000001003f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001003fb:	48 89 c7             	mov    %rax,%rdi
ffff8000001003fe:	48 b8 37 3d 10 00 00 	movabs $0xffff800000103d37,%rax
ffff800000100405:	80 ff ff 
ffff800000100408:	ff d0                	callq  *%rax
  }
  return b;
ffff80000010040a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010040e:	c9                   	leaveq 
ffff80000010040f:	c3                   	retq   

ffff800000100410 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
ffff800000100410:	f3 0f 1e fa          	endbr64 
ffff800000100414:	55                   	push   %rbp
ffff800000100415:	48 89 e5             	mov    %rsp,%rbp
ffff800000100418:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010041c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holdingsleep(&b->lock))
ffff800000100420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100424:	48 83 c0 10          	add    $0x10,%rax
ffff800000100428:	48 89 c7             	mov    %rax,%rdi
ffff80000010042b:	48 b8 4b 74 10 00 00 	movabs $0xffff80000010744b,%rax
ffff800000100432:	80 ff ff 
ffff800000100435:	ff d0                	callq  *%rax
ffff800000100437:	85 c0                	test   %eax,%eax
ffff800000100439:	75 16                	jne    ffff800000100451 <bwrite+0x41>
    panic("bwrite");
ffff80000010043b:	48 bf f7 bd 10 00 00 	movabs $0xffff80000010bdf7,%rdi
ffff800000100442:	80 ff ff 
ffff800000100445:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010044c:	80 ff ff 
ffff80000010044f:	ff d0                	callq  *%rax
  b->flags |= B_DIRTY;
ffff800000100451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100455:	8b 00                	mov    (%rax),%eax
ffff800000100457:	83 c8 04             	or     $0x4,%eax
ffff80000010045a:	89 c2                	mov    %eax,%edx
ffff80000010045c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100460:	89 10                	mov    %edx,(%rax)
  iderw(b);
ffff800000100462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100466:	48 89 c7             	mov    %rax,%rdi
ffff800000100469:	48 b8 37 3d 10 00 00 	movabs $0xffff800000103d37,%rax
ffff800000100470:	80 ff ff 
ffff800000100473:	ff d0                	callq  *%rax
}
ffff800000100475:	90                   	nop
ffff800000100476:	c9                   	leaveq 
ffff800000100477:	c3                   	retq   

ffff800000100478 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
ffff800000100478:	f3 0f 1e fa          	endbr64 
ffff80000010047c:	55                   	push   %rbp
ffff80000010047d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100480:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100484:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holdingsleep(&b->lock))
ffff800000100488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010048c:	48 83 c0 10          	add    $0x10,%rax
ffff800000100490:	48 89 c7             	mov    %rax,%rdi
ffff800000100493:	48 b8 4b 74 10 00 00 	movabs $0xffff80000010744b,%rax
ffff80000010049a:	80 ff ff 
ffff80000010049d:	ff d0                	callq  *%rax
ffff80000010049f:	85 c0                	test   %eax,%eax
ffff8000001004a1:	75 16                	jne    ffff8000001004b9 <brelse+0x41>
    panic("brelse");
ffff8000001004a3:	48 bf fe bd 10 00 00 	movabs $0xffff80000010bdfe,%rdi
ffff8000001004aa:	80 ff ff 
ffff8000001004ad:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001004b4:	80 ff ff 
ffff8000001004b7:	ff d0                	callq  *%rax

  releasesleep(&b->lock);
ffff8000001004b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004bd:	48 83 c0 10          	add    $0x10,%rax
ffff8000001004c1:	48 89 c7             	mov    %rax,%rdi
ffff8000001004c4:	48 b8 e2 73 10 00 00 	movabs $0xffff8000001073e2,%rax
ffff8000001004cb:	80 ff ff 
ffff8000001004ce:	ff d0                	callq  *%rax

  acquire(&bcache.lock);
ffff8000001004d0:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff8000001004d7:	80 ff ff 
ffff8000001004da:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff8000001004e1:	80 ff ff 
ffff8000001004e4:	ff d0                	callq  *%rax
  b->refcnt--;
ffff8000001004e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004ea:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff8000001004f0:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001004f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004f7:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
  if (b->refcnt == 0) {
ffff8000001004fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100501:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100507:	85 c0                	test   %eax,%eax
ffff800000100509:	0f 85 9c 00 00 00    	jne    ffff8000001005ab <brelse+0x133>
    // no one is waiting for it.
    b->next->prev = b->prev;
ffff80000010050f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100513:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff80000010051a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010051e:	48 8b 92 98 00 00 00 	mov    0x98(%rdx),%rdx
ffff800000100525:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    b->prev->next = b->next;
ffff80000010052c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100530:	48 8b 80 98 00 00 00 	mov    0x98(%rax),%rax
ffff800000100537:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010053b:	48 8b 92 a0 00 00 00 	mov    0xa0(%rdx),%rdx
ffff800000100542:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->next = bcache.head.next;
ffff800000100549:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100550:	80 ff ff 
ffff800000100553:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
ffff80000010055a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010055e:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->prev = &bcache.head;
ffff800000100565:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100569:	48 b9 08 31 11 00 00 	movabs $0xffff800000113108,%rcx
ffff800000100570:	80 ff ff 
ffff800000100573:	48 89 88 98 00 00 00 	mov    %rcx,0x98(%rax)
    bcache.head.next->prev = b;
ffff80000010057a:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100581:	80 ff ff 
ffff800000100584:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff80000010058b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010058f:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    bcache.head.next = b;
ffff800000100596:	48 ba 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdx
ffff80000010059d:	80 ff ff 
ffff8000001005a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001005a4:	48 89 82 a8 51 00 00 	mov    %rax,0x51a8(%rdx)
  }

  release(&bcache.lock);
ffff8000001005ab:	48 bf 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdi
ffff8000001005b2:	80 ff ff 
ffff8000001005b5:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001005bc:	80 ff ff 
ffff8000001005bf:	ff d0                	callq  *%rax
}
ffff8000001005c1:	90                   	nop
ffff8000001005c2:	c9                   	leaveq 
ffff8000001005c3:	c3                   	retq   

ffff8000001005c4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
ffff8000001005c4:	f3 0f 1e fa          	endbr64 
ffff8000001005c8:	55                   	push   %rbp
ffff8000001005c9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001005cc:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001005d0:	89 f8                	mov    %edi,%eax
ffff8000001005d2:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001005d6:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001005da:	89 c2                	mov    %eax,%edx
ffff8000001005dc:	ec                   	in     (%dx),%al
ffff8000001005dd:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff8000001005e0:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff8000001005e4:	c9                   	leaveq 
ffff8000001005e5:	c3                   	retq   

ffff8000001005e6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffff8000001005e6:	f3 0f 1e fa          	endbr64 
ffff8000001005ea:	55                   	push   %rbp
ffff8000001005eb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001005ee:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001005f2:	89 f8                	mov    %edi,%eax
ffff8000001005f4:	89 f2                	mov    %esi,%edx
ffff8000001005f6:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff8000001005fa:	89 d0                	mov    %edx,%eax
ffff8000001005fc:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff8000001005ff:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000100603:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000100607:	ee                   	out    %al,(%dx)
}
ffff800000100608:	90                   	nop
ffff800000100609:	c9                   	leaveq 
ffff80000010060a:	c3                   	retq   

ffff80000010060b <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
ffff80000010060b:	f3 0f 1e fa          	endbr64 
ffff80000010060f:	55                   	push   %rbp
ffff800000100610:	48 89 e5             	mov    %rsp,%rbp
ffff800000100613:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000100617:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010061b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  volatile ushort pd[5];
  addr_t addr = (addr_t)p;
ffff80000010061e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000100622:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  pd[0] = size-1;
ffff800000100626:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000100629:	83 e8 01             	sub    $0x1,%eax
ffff80000010062c:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff800000100630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100634:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff800000100638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010063c:	48 c1 e8 10          	shr    $0x10,%rax
ffff800000100640:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff800000100644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100648:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010064c:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff800000100650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100654:	48 c1 e8 30          	shr    $0x30,%rax
ffff800000100658:	66 89 45 f6          	mov    %ax,-0xa(%rbp)

  asm volatile("lidt (%0)" : : "r" (pd));
ffff80000010065c:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff800000100660:	0f 01 18             	lidt   (%rax)
}
ffff800000100663:	90                   	nop
ffff800000100664:	c9                   	leaveq 
ffff800000100665:	c3                   	retq   

ffff800000100666 <cli>:
  return eflags;
}

static inline void
cli(void)
{
ffff800000100666:	f3 0f 1e fa          	endbr64 
ffff80000010066a:	55                   	push   %rbp
ffff80000010066b:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffff80000010066e:	fa                   	cli    
}
ffff80000010066f:	90                   	nop
ffff800000100670:	5d                   	pop    %rbp
ffff800000100671:	c3                   	retq   

ffff800000100672 <hlt>:
  asm volatile("sti");
}

static inline void
hlt(void)
{
ffff800000100672:	f3 0f 1e fa          	endbr64 
ffff800000100676:	55                   	push   %rbp
ffff800000100677:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffff80000010067a:	f4                   	hlt    
}
ffff80000010067b:	90                   	nop
ffff80000010067c:	5d                   	pop    %rbp
ffff80000010067d:	c3                   	retq   

ffff80000010067e <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(addr_t x)
{
ffff80000010067e:	f3 0f 1e fa          	endbr64 
ffff800000100682:	55                   	push   %rbp
ffff800000100683:	48 89 e5             	mov    %rsp,%rbp
ffff800000100686:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010068a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
ffff80000010068e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100695:	eb 30                	jmp    ffff8000001006c7 <print_x64+0x49>
    consputc(digits[x >> (sizeof(addr_t) * 8 - 4)]);
ffff800000100697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010069b:	48 c1 e8 3c          	shr    $0x3c,%rax
ffff80000010069f:	48 ba 00 d0 10 00 00 	movabs $0xffff80000010d000,%rdx
ffff8000001006a6:	80 ff ff 
ffff8000001006a9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff8000001006ad:	0f be c0             	movsbl %al,%eax
ffff8000001006b0:	89 c7                	mov    %eax,%edi
ffff8000001006b2:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff8000001006b9:	80 ff ff 
ffff8000001006bc:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
ffff8000001006be:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001006c2:	48 c1 65 e8 04       	shlq   $0x4,-0x18(%rbp)
ffff8000001006c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001006ca:	83 f8 0f             	cmp    $0xf,%eax
ffff8000001006cd:	76 c8                	jbe    ffff800000100697 <print_x64+0x19>
}
ffff8000001006cf:	90                   	nop
ffff8000001006d0:	90                   	nop
ffff8000001006d1:	c9                   	leaveq 
ffff8000001006d2:	c3                   	retq   

ffff8000001006d3 <print_x32>:

  static void
print_x32(uint x)
{
ffff8000001006d3:	f3 0f 1e fa          	endbr64 
ffff8000001006d7:	55                   	push   %rbp
ffff8000001006d8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001006db:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001006df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
ffff8000001006e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001006e9:	eb 31                	jmp    ffff80000010071c <print_x32+0x49>
    consputc(digits[x >> (sizeof(uint) * 8 - 4)]);
ffff8000001006eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001006ee:	c1 e8 1c             	shr    $0x1c,%eax
ffff8000001006f1:	89 c2                	mov    %eax,%edx
ffff8000001006f3:	48 b8 00 d0 10 00 00 	movabs $0xffff80000010d000,%rax
ffff8000001006fa:	80 ff ff 
ffff8000001006fd:	89 d2                	mov    %edx,%edx
ffff8000001006ff:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
ffff800000100703:	0f be c0             	movsbl %al,%eax
ffff800000100706:	89 c7                	mov    %eax,%edi
ffff800000100708:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010070f:	80 ff ff 
ffff800000100712:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
ffff800000100714:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100718:	c1 65 ec 04          	shll   $0x4,-0x14(%rbp)
ffff80000010071c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010071f:	83 f8 07             	cmp    $0x7,%eax
ffff800000100722:	76 c7                	jbe    ffff8000001006eb <print_x32+0x18>
}
ffff800000100724:	90                   	nop
ffff800000100725:	90                   	nop
ffff800000100726:	c9                   	leaveq 
ffff800000100727:	c3                   	retq   

ffff800000100728 <print_d>:

  static void
print_d(int v)
{
ffff800000100728:	f3 0f 1e fa          	endbr64 
ffff80000010072c:	55                   	push   %rbp
ffff80000010072d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100730:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000100734:	89 7d dc             	mov    %edi,-0x24(%rbp)
  char buf[16];
  int64 x = v;
ffff800000100737:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010073a:	48 98                	cltq   
ffff80000010073c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
ffff800000100740:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000100744:	79 04                	jns    ffff80000010074a <print_d+0x22>
    x = -x;
ffff800000100746:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
ffff80000010074a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
ffff800000100751:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000100755:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
ffff80000010075c:	66 66 66 
ffff80000010075f:	48 89 c8             	mov    %rcx,%rax
ffff800000100762:	48 f7 ea             	imul   %rdx
ffff800000100765:	48 c1 fa 02          	sar    $0x2,%rdx
ffff800000100769:	48 89 c8             	mov    %rcx,%rax
ffff80000010076c:	48 c1 f8 3f          	sar    $0x3f,%rax
ffff800000100770:	48 29 c2             	sub    %rax,%rdx
ffff800000100773:	48 89 d0             	mov    %rdx,%rax
ffff800000100776:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010077a:	48 01 d0             	add    %rdx,%rax
ffff80000010077d:	48 01 c0             	add    %rax,%rax
ffff800000100780:	48 29 c1             	sub    %rax,%rcx
ffff800000100783:	48 89 ca             	mov    %rcx,%rdx
ffff800000100786:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000100789:	8d 48 01             	lea    0x1(%rax),%ecx
ffff80000010078c:	89 4d f4             	mov    %ecx,-0xc(%rbp)
ffff80000010078f:	48 b9 00 d0 10 00 00 	movabs $0xffff80000010d000,%rcx
ffff800000100796:	80 ff ff 
ffff800000100799:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
ffff80000010079d:	48 98                	cltq   
ffff80000010079f:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
ffff8000001007a3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001007a7:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
ffff8000001007ae:	66 66 66 
ffff8000001007b1:	48 89 c8             	mov    %rcx,%rax
ffff8000001007b4:	48 f7 ea             	imul   %rdx
ffff8000001007b7:	48 c1 fa 02          	sar    $0x2,%rdx
ffff8000001007bb:	48 89 c8             	mov    %rcx,%rax
ffff8000001007be:	48 c1 f8 3f          	sar    $0x3f,%rax
ffff8000001007c2:	48 29 c2             	sub    %rax,%rdx
ffff8000001007c5:	48 89 d0             	mov    %rdx,%rax
ffff8000001007c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
ffff8000001007cc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001007d1:	0f 85 7a ff ff ff    	jne    ffff800000100751 <print_d+0x29>

  if (v < 0)
ffff8000001007d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff8000001007db:	79 2d                	jns    ffff80000010080a <print_d+0xe2>
    buf[i++] = '-';
ffff8000001007dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001007e0:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001007e3:	89 55 f4             	mov    %edx,-0xc(%rbp)
ffff8000001007e6:	48 98                	cltq   
ffff8000001007e8:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
ffff8000001007ed:	eb 1b                	jmp    ffff80000010080a <print_d+0xe2>
    consputc(buf[i]);
ffff8000001007ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001007f2:	48 98                	cltq   
ffff8000001007f4:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
ffff8000001007f9:	0f be c0             	movsbl %al,%eax
ffff8000001007fc:	89 c7                	mov    %eax,%edi
ffff8000001007fe:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100805:	80 ff ff 
ffff800000100808:	ff d0                	callq  *%rax
  while (--i >= 0)
ffff80000010080a:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
ffff80000010080e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000100812:	79 db                	jns    ffff8000001007ef <print_d+0xc7>
}
ffff800000100814:	90                   	nop
ffff800000100815:	90                   	nop
ffff800000100816:	c9                   	leaveq 
ffff800000100817:	c3                   	retq   

ffff800000100818 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
  void
cprintf(char *fmt, ...)
{
ffff800000100818:	f3 0f 1e fa          	endbr64 
ffff80000010081c:	55                   	push   %rbp
ffff80000010081d:	48 89 e5             	mov    %rsp,%rbp
ffff800000100820:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
ffff800000100827:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
ffff80000010082e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
ffff800000100835:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
ffff80000010083c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
ffff800000100843:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
ffff80000010084a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
ffff800000100851:	84 c0                	test   %al,%al
ffff800000100853:	74 20                	je     ffff800000100875 <cprintf+0x5d>
ffff800000100855:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
ffff800000100859:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
ffff80000010085d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
ffff800000100861:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
ffff800000100865:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
ffff800000100869:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
ffff80000010086d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
ffff800000100871:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c, locking;
  char *s;

  va_start(ap, fmt);
ffff800000100875:	c7 85 20 ff ff ff 08 	movl   $0x8,-0xe0(%rbp)
ffff80000010087c:	00 00 00 
ffff80000010087f:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
ffff800000100886:	00 00 00 
ffff800000100889:	48 8d 45 10          	lea    0x10(%rbp),%rax
ffff80000010088d:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
ffff800000100894:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
ffff80000010089b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)

  locking = cons.locking;
ffff8000001008a2:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff8000001008a9:	80 ff ff 
ffff8000001008ac:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001008af:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
  if (locking)
ffff8000001008b5:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffff8000001008bc:	74 16                	je     ffff8000001008d4 <cprintf+0xbc>
    acquire(&cons.lock);
ffff8000001008be:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff8000001008c5:	80 ff ff 
ffff8000001008c8:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff8000001008cf:	80 ff ff 
ffff8000001008d2:	ff d0                	callq  *%rax

  if (fmt == 0)
ffff8000001008d4:	48 83 bd 18 ff ff ff 	cmpq   $0x0,-0xe8(%rbp)
ffff8000001008db:	00 
ffff8000001008dc:	75 16                	jne    ffff8000001008f4 <cprintf+0xdc>
    panic("null fmt");
ffff8000001008de:	48 bf 05 be 10 00 00 	movabs $0xffff80000010be05,%rdi
ffff8000001008e5:	80 ff ff 
ffff8000001008e8:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001008ef:	80 ff ff 
ffff8000001008f2:	ff d0                	callq  *%rax

  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
ffff8000001008f4:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
ffff8000001008fb:	00 00 00 
ffff8000001008fe:	e9 a0 02 00 00       	jmpq   ffff800000100ba3 <cprintf+0x38b>
    if (c != '%') {
ffff800000100903:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffff80000010090a:	74 19                	je     ffff800000100925 <cprintf+0x10d>
      consputc(c);
ffff80000010090c:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffff800000100912:	89 c7                	mov    %eax,%edi
ffff800000100914:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010091b:	80 ff ff 
ffff80000010091e:	ff d0                	callq  *%rax
      continue;
ffff800000100920:	e9 77 02 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    }
    c = fmt[++i] & 0xff;
ffff800000100925:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff80000010092c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000100932:	48 63 d0             	movslq %eax,%rdx
ffff800000100935:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffff80000010093c:	48 01 d0             	add    %rdx,%rax
ffff80000010093f:	0f b6 00             	movzbl (%rax),%eax
ffff800000100942:	0f be c0             	movsbl %al,%eax
ffff800000100945:	25 ff 00 00 00       	and    $0xff,%eax
ffff80000010094a:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
    if (c == 0)
ffff800000100950:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffff800000100957:	0f 84 79 02 00 00    	je     ffff800000100bd6 <cprintf+0x3be>
      break;
    switch(c) {
ffff80000010095d:	83 bd 38 ff ff ff 78 	cmpl   $0x78,-0xc8(%rbp)
ffff800000100964:	0f 84 b0 00 00 00    	je     ffff800000100a1a <cprintf+0x202>
ffff80000010096a:	83 bd 38 ff ff ff 78 	cmpl   $0x78,-0xc8(%rbp)
ffff800000100971:	0f 8f ff 01 00 00    	jg     ffff800000100b76 <cprintf+0x35e>
ffff800000100977:	83 bd 38 ff ff ff 73 	cmpl   $0x73,-0xc8(%rbp)
ffff80000010097e:	0f 84 42 01 00 00    	je     ffff800000100ac6 <cprintf+0x2ae>
ffff800000100984:	83 bd 38 ff ff ff 73 	cmpl   $0x73,-0xc8(%rbp)
ffff80000010098b:	0f 8f e5 01 00 00    	jg     ffff800000100b76 <cprintf+0x35e>
ffff800000100991:	83 bd 38 ff ff ff 70 	cmpl   $0x70,-0xc8(%rbp)
ffff800000100998:	0f 84 d1 00 00 00    	je     ffff800000100a6f <cprintf+0x257>
ffff80000010099e:	83 bd 38 ff ff ff 70 	cmpl   $0x70,-0xc8(%rbp)
ffff8000001009a5:	0f 8f cb 01 00 00    	jg     ffff800000100b76 <cprintf+0x35e>
ffff8000001009ab:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffff8000001009b2:	0f 84 ab 01 00 00    	je     ffff800000100b63 <cprintf+0x34b>
ffff8000001009b8:	83 bd 38 ff ff ff 64 	cmpl   $0x64,-0xc8(%rbp)
ffff8000001009bf:	0f 85 b1 01 00 00    	jne    ffff800000100b76 <cprintf+0x35e>
    case 'd':
      print_d(va_arg(ap, int));
ffff8000001009c5:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff8000001009cb:	83 f8 2f             	cmp    $0x2f,%eax
ffff8000001009ce:	77 23                	ja     ffff8000001009f3 <cprintf+0x1db>
ffff8000001009d0:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff8000001009d7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff8000001009dd:	89 d2                	mov    %edx,%edx
ffff8000001009df:	48 01 d0             	add    %rdx,%rax
ffff8000001009e2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff8000001009e8:	83 c2 08             	add    $0x8,%edx
ffff8000001009eb:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff8000001009f1:	eb 12                	jmp    ffff800000100a05 <cprintf+0x1ed>
ffff8000001009f3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff8000001009fa:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff8000001009fe:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100a05:	8b 00                	mov    (%rax),%eax
ffff800000100a07:	89 c7                	mov    %eax,%edi
ffff800000100a09:	48 b8 28 07 10 00 00 	movabs $0xffff800000100728,%rax
ffff800000100a10:	80 ff ff 
ffff800000100a13:	ff d0                	callq  *%rax
      break;
ffff800000100a15:	e9 82 01 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    case 'x':
      print_x32(va_arg(ap, uint));
ffff800000100a1a:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100a20:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100a23:	77 23                	ja     ffff800000100a48 <cprintf+0x230>
ffff800000100a25:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100a2c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a32:	89 d2                	mov    %edx,%edx
ffff800000100a34:	48 01 d0             	add    %rdx,%rax
ffff800000100a37:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a3d:	83 c2 08             	add    $0x8,%edx
ffff800000100a40:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100a46:	eb 12                	jmp    ffff800000100a5a <cprintf+0x242>
ffff800000100a48:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100a4f:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100a53:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100a5a:	8b 00                	mov    (%rax),%eax
ffff800000100a5c:	89 c7                	mov    %eax,%edi
ffff800000100a5e:	48 b8 d3 06 10 00 00 	movabs $0xffff8000001006d3,%rax
ffff800000100a65:	80 ff ff 
ffff800000100a68:	ff d0                	callq  *%rax
      break;
ffff800000100a6a:	e9 2d 01 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    case 'p':
      print_x64(va_arg(ap, addr_t));
ffff800000100a6f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100a75:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100a78:	77 23                	ja     ffff800000100a9d <cprintf+0x285>
ffff800000100a7a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100a81:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a87:	89 d2                	mov    %edx,%edx
ffff800000100a89:	48 01 d0             	add    %rdx,%rax
ffff800000100a8c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a92:	83 c2 08             	add    $0x8,%edx
ffff800000100a95:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100a9b:	eb 12                	jmp    ffff800000100aaf <cprintf+0x297>
ffff800000100a9d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100aa4:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100aa8:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100aaf:	48 8b 00             	mov    (%rax),%rax
ffff800000100ab2:	48 89 c7             	mov    %rax,%rdi
ffff800000100ab5:	48 b8 7e 06 10 00 00 	movabs $0xffff80000010067e,%rax
ffff800000100abc:	80 ff ff 
ffff800000100abf:	ff d0                	callq  *%rax
      break;
ffff800000100ac1:	e9 d6 00 00 00       	jmpq   ffff800000100b9c <cprintf+0x384>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
ffff800000100ac6:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100acc:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100acf:	77 23                	ja     ffff800000100af4 <cprintf+0x2dc>
ffff800000100ad1:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100ad8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100ade:	89 d2                	mov    %edx,%edx
ffff800000100ae0:	48 01 d0             	add    %rdx,%rax
ffff800000100ae3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100ae9:	83 c2 08             	add    $0x8,%edx
ffff800000100aec:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100af2:	eb 12                	jmp    ffff800000100b06 <cprintf+0x2ee>
ffff800000100af4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100afb:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100aff:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100b06:	48 8b 00             	mov    (%rax),%rax
ffff800000100b09:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
ffff800000100b10:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
ffff800000100b17:	00 
ffff800000100b18:	75 39                	jne    ffff800000100b53 <cprintf+0x33b>
        s = "(null)";
ffff800000100b1a:	48 b8 0e be 10 00 00 	movabs $0xffff80000010be0e,%rax
ffff800000100b21:	80 ff ff 
ffff800000100b24:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
ffff800000100b2b:	eb 26                	jmp    ffff800000100b53 <cprintf+0x33b>
        consputc(*(s++));
ffff800000100b2d:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffff800000100b34:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000100b38:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
ffff800000100b3f:	0f b6 00             	movzbl (%rax),%eax
ffff800000100b42:	0f be c0             	movsbl %al,%eax
ffff800000100b45:	89 c7                	mov    %eax,%edi
ffff800000100b47:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b4e:	80 ff ff 
ffff800000100b51:	ff d0                	callq  *%rax
      while (*s)
ffff800000100b53:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffff800000100b5a:	0f b6 00             	movzbl (%rax),%eax
ffff800000100b5d:	84 c0                	test   %al,%al
ffff800000100b5f:	75 cc                	jne    ffff800000100b2d <cprintf+0x315>
      break;
ffff800000100b61:	eb 39                	jmp    ffff800000100b9c <cprintf+0x384>
    case '%':
      consputc('%');
ffff800000100b63:	bf 25 00 00 00       	mov    $0x25,%edi
ffff800000100b68:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b6f:	80 ff ff 
ffff800000100b72:	ff d0                	callq  *%rax
      break;
ffff800000100b74:	eb 26                	jmp    ffff800000100b9c <cprintf+0x384>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
ffff800000100b76:	bf 25 00 00 00       	mov    $0x25,%edi
ffff800000100b7b:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b82:	80 ff ff 
ffff800000100b85:	ff d0                	callq  *%rax
      consputc(c);
ffff800000100b87:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffff800000100b8d:	89 c7                	mov    %eax,%edi
ffff800000100b8f:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000100b96:	80 ff ff 
ffff800000100b99:	ff d0                	callq  *%rax
      break;
ffff800000100b9b:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
ffff800000100b9c:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff800000100ba3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000100ba9:	48 63 d0             	movslq %eax,%rdx
ffff800000100bac:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffff800000100bb3:	48 01 d0             	add    %rdx,%rax
ffff800000100bb6:	0f b6 00             	movzbl (%rax),%eax
ffff800000100bb9:	0f be c0             	movsbl %al,%eax
ffff800000100bbc:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000100bc1:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
ffff800000100bc7:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffff800000100bce:	0f 85 2f fd ff ff    	jne    ffff800000100903 <cprintf+0xeb>
ffff800000100bd4:	eb 01                	jmp    ffff800000100bd7 <cprintf+0x3bf>
      break;
ffff800000100bd6:	90                   	nop
    }
  }

  if (locking)
ffff800000100bd7:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffff800000100bde:	74 16                	je     ffff800000100bf6 <cprintf+0x3de>
    release(&cons.lock);
ffff800000100be0:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff800000100be7:	80 ff ff 
ffff800000100bea:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000100bf1:	80 ff ff 
ffff800000100bf4:	ff d0                	callq  *%rax
}
ffff800000100bf6:	90                   	nop
ffff800000100bf7:	c9                   	leaveq 
ffff800000100bf8:	c3                   	retq   

ffff800000100bf9 <panic>:

__attribute__((noreturn))
  void
panic(char *s)
{
ffff800000100bf9:	f3 0f 1e fa          	endbr64 
ffff800000100bfd:	55                   	push   %rbp
ffff800000100bfe:	48 89 e5             	mov    %rsp,%rbp
ffff800000100c01:	48 83 ec 70          	sub    $0x70,%rsp
ffff800000100c05:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
  int i;
  addr_t pcs[10];

  cli();
ffff800000100c09:	48 b8 66 06 10 00 00 	movabs $0xffff800000100666,%rax
ffff800000100c10:	80 ff ff 
ffff800000100c13:	ff d0                	callq  *%rax
  cons.locking = 0;
ffff800000100c15:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff800000100c1c:	80 ff ff 
ffff800000100c1f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
  cprintf("cpu%d: panic: ", cpu->id);
ffff800000100c26:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000100c2d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000100c31:	0f b6 00             	movzbl (%rax),%eax
ffff800000100c34:	0f b6 c0             	movzbl %al,%eax
ffff800000100c37:	89 c6                	mov    %eax,%esi
ffff800000100c39:	48 bf 15 be 10 00 00 	movabs $0xffff80000010be15,%rdi
ffff800000100c40:	80 ff ff 
ffff800000100c43:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c48:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100c4f:	80 ff ff 
ffff800000100c52:	ff d2                	callq  *%rdx
  cprintf(s);
ffff800000100c54:	48 8b 45 98          	mov    -0x68(%rbp),%rax
ffff800000100c58:	48 89 c7             	mov    %rax,%rdi
ffff800000100c5b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c60:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100c67:	80 ff ff 
ffff800000100c6a:	ff d2                	callq  *%rdx
  cprintf("\n");
ffff800000100c6c:	48 bf 24 be 10 00 00 	movabs $0xffff80000010be24,%rdi
ffff800000100c73:	80 ff ff 
ffff800000100c76:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c7b:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100c82:	80 ff ff 
ffff800000100c85:	ff d2                	callq  *%rdx
  getcallerpcs(&s, pcs);
ffff800000100c87:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
ffff800000100c8b:	48 8d 45 98          	lea    -0x68(%rbp),%rax
ffff800000100c8f:	48 89 d6             	mov    %rdx,%rsi
ffff800000100c92:	48 89 c7             	mov    %rax,%rdi
ffff800000100c95:	48 b8 3d 76 10 00 00 	movabs $0xffff80000010763d,%rax
ffff800000100c9c:	80 ff ff 
ffff800000100c9f:	ff d0                	callq  *%rax
  for (i=0; i<10; i++)
ffff800000100ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100ca8:	eb 2c                	jmp    ffff800000100cd6 <panic+0xdd>
    cprintf(" %p\n", pcs[i]);
ffff800000100caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100cad:	48 98                	cltq   
ffff800000100caf:	48 8b 44 c5 a0       	mov    -0x60(%rbp,%rax,8),%rax
ffff800000100cb4:	48 89 c6             	mov    %rax,%rsi
ffff800000100cb7:	48 bf 26 be 10 00 00 	movabs $0xffff80000010be26,%rdi
ffff800000100cbe:	80 ff ff 
ffff800000100cc1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100cc6:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000100ccd:	80 ff ff 
ffff800000100cd0:	ff d2                	callq  *%rdx
  for (i=0; i<10; i++)
ffff800000100cd2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100cd6:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000100cda:	7e ce                	jle    ffff800000100caa <panic+0xb1>
  panicked = 1; // freeze other CPU
ffff800000100cdc:	48 b8 b8 34 11 00 00 	movabs $0xffff8000001134b8,%rax
ffff800000100ce3:	80 ff ff 
ffff800000100ce6:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  for (;;)
    hlt();
ffff800000100cec:	48 b8 72 06 10 00 00 	movabs $0xffff800000100672,%rax
ffff800000100cf3:	80 ff ff 
ffff800000100cf6:	ff d0                	callq  *%rax
ffff800000100cf8:	eb f2                	jmp    ffff800000100cec <panic+0xf3>

ffff800000100cfa <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

  static void
cgaputc(int c)
{
ffff800000100cfa:	f3 0f 1e fa          	endbr64 
ffff800000100cfe:	55                   	push   %rbp
ffff800000100cff:	48 89 e5             	mov    %rsp,%rbp
ffff800000100d02:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100d06:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
ffff800000100d09:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000100d0e:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100d13:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100d1a:	80 ff ff 
ffff800000100d1d:	ff d0                	callq  *%rax
  pos = inb(CRTPORT+1) << 8;
ffff800000100d1f:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100d24:	48 b8 c4 05 10 00 00 	movabs $0xffff8000001005c4,%rax
ffff800000100d2b:	80 ff ff 
ffff800000100d2e:	ff d0                	callq  *%rax
ffff800000100d30:	0f b6 c0             	movzbl %al,%eax
ffff800000100d33:	c1 e0 08             	shl    $0x8,%eax
ffff800000100d36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  outb(CRTPORT, 15);
ffff800000100d39:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000100d3e:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100d43:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100d4a:	80 ff ff 
ffff800000100d4d:	ff d0                	callq  *%rax
  pos |= inb(CRTPORT+1);
ffff800000100d4f:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100d54:	48 b8 c4 05 10 00 00 	movabs $0xffff8000001005c4,%rax
ffff800000100d5b:	80 ff ff 
ffff800000100d5e:	ff d0                	callq  *%rax
ffff800000100d60:	0f b6 c0             	movzbl %al,%eax
ffff800000100d63:	09 45 fc             	or     %eax,-0x4(%rbp)

  if (c == '\n')
ffff800000100d66:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
ffff800000100d6a:	75 37                	jne    ffff800000100da3 <cgaputc+0xa9>
    pos += 80 - pos%80;
ffff800000100d6c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000100d6f:	48 63 c1             	movslq %ecx,%rax
ffff800000100d72:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
ffff800000100d79:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000100d7d:	89 c2                	mov    %eax,%edx
ffff800000100d7f:	c1 fa 05             	sar    $0x5,%edx
ffff800000100d82:	89 c8                	mov    %ecx,%eax
ffff800000100d84:	c1 f8 1f             	sar    $0x1f,%eax
ffff800000100d87:	29 c2                	sub    %eax,%edx
ffff800000100d89:	89 d0                	mov    %edx,%eax
ffff800000100d8b:	c1 e0 02             	shl    $0x2,%eax
ffff800000100d8e:	01 d0                	add    %edx,%eax
ffff800000100d90:	c1 e0 04             	shl    $0x4,%eax
ffff800000100d93:	29 c1                	sub    %eax,%ecx
ffff800000100d95:	89 ca                	mov    %ecx,%edx
ffff800000100d97:	b8 50 00 00 00       	mov    $0x50,%eax
ffff800000100d9c:	29 d0                	sub    %edx,%eax
ffff800000100d9e:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff800000100da1:	eb 43                	jmp    ffff800000100de6 <cgaputc+0xec>
  else if (c == BACKSPACE) {
ffff800000100da3:	81 7d ec 00 01 00 00 	cmpl   $0x100,-0x14(%rbp)
ffff800000100daa:	75 0c                	jne    ffff800000100db8 <cgaputc+0xbe>
    if (pos > 0) --pos;
ffff800000100dac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000100db0:	7e 34                	jle    ffff800000100de6 <cgaputc+0xec>
ffff800000100db2:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
ffff800000100db6:	eb 2e                	jmp    ffff800000100de6 <cgaputc+0xec>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
ffff800000100db8:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000100dbb:	0f b6 c0             	movzbl %al,%eax
ffff800000100dbe:	80 cc 07             	or     $0x7,%ah
ffff800000100dc1:	89 c6                	mov    %eax,%esi
ffff800000100dc3:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100dca:	80 ff ff 
ffff800000100dcd:	48 8b 08             	mov    (%rax),%rcx
ffff800000100dd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100dd3:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000100dd6:	89 55 fc             	mov    %edx,-0x4(%rbp)
ffff800000100dd9:	48 98                	cltq   
ffff800000100ddb:	48 01 c0             	add    %rax,%rax
ffff800000100dde:	48 01 c8             	add    %rcx,%rax
ffff800000100de1:	89 f2                	mov    %esi,%edx
ffff800000100de3:	66 89 10             	mov    %dx,(%rax)

  if ((pos/80) >= 24){  // Scroll up.
ffff800000100de6:	81 7d fc 7f 07 00 00 	cmpl   $0x77f,-0x4(%rbp)
ffff800000100ded:	7e 76                	jle    ffff800000100e65 <cgaputc+0x16b>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
ffff800000100def:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100df6:	80 ff ff 
ffff800000100df9:	48 8b 00             	mov    (%rax),%rax
ffff800000100dfc:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffff800000100e03:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100e0a:	80 ff ff 
ffff800000100e0d:	48 8b 00             	mov    (%rax),%rax
ffff800000100e10:	ba 60 0e 00 00       	mov    $0xe60,%edx
ffff800000100e15:	48 89 ce             	mov    %rcx,%rsi
ffff800000100e18:	48 89 c7             	mov    %rax,%rdi
ffff800000100e1b:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff800000100e22:	80 ff ff 
ffff800000100e25:	ff d0                	callq  *%rax
    pos -= 80;
ffff800000100e27:	83 6d fc 50          	subl   $0x50,-0x4(%rbp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
ffff800000100e2b:	b8 80 07 00 00       	mov    $0x780,%eax
ffff800000100e30:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000100e33:	48 98                	cltq   
ffff800000100e35:	8d 14 00             	lea    (%rax,%rax,1),%edx
ffff800000100e38:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100e3f:	80 ff ff 
ffff800000100e42:	48 8b 00             	mov    (%rax),%rax
ffff800000100e45:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000100e48:	48 63 c9             	movslq %ecx,%rcx
ffff800000100e4b:	48 01 c9             	add    %rcx,%rcx
ffff800000100e4e:	48 01 c8             	add    %rcx,%rax
ffff800000100e51:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000100e56:	48 89 c7             	mov    %rax,%rdi
ffff800000100e59:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff800000100e60:	80 ff ff 
ffff800000100e63:	ff d0                	callq  *%rax
  }

  outb(CRTPORT, 14);
ffff800000100e65:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000100e6a:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100e6f:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100e76:	80 ff ff 
ffff800000100e79:	ff d0                	callq  *%rax
  outb(CRTPORT+1, pos>>8);
ffff800000100e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100e7e:	c1 f8 08             	sar    $0x8,%eax
ffff800000100e81:	0f b6 c0             	movzbl %al,%eax
ffff800000100e84:	89 c6                	mov    %eax,%esi
ffff800000100e86:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100e8b:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100e92:	80 ff ff 
ffff800000100e95:	ff d0                	callq  *%rax
  outb(CRTPORT, 15);
ffff800000100e97:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000100e9c:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100ea1:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100ea8:	80 ff ff 
ffff800000100eab:	ff d0                	callq  *%rax
  outb(CRTPORT+1, pos);
ffff800000100ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100eb0:	0f b6 c0             	movzbl %al,%eax
ffff800000100eb3:	89 c6                	mov    %eax,%esi
ffff800000100eb5:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100eba:	48 b8 e6 05 10 00 00 	movabs $0xffff8000001005e6,%rax
ffff800000100ec1:	80 ff ff 
ffff800000100ec4:	ff d0                	callq  *%rax
  crt[pos] = ' ' | 0x0700;
ffff800000100ec6:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100ecd:	80 ff ff 
ffff800000100ed0:	48 8b 00             	mov    (%rax),%rax
ffff800000100ed3:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000100ed6:	48 63 d2             	movslq %edx,%rdx
ffff800000100ed9:	48 01 d2             	add    %rdx,%rdx
ffff800000100edc:	48 01 d0             	add    %rdx,%rax
ffff800000100edf:	66 c7 00 20 07       	movw   $0x720,(%rax)
}
ffff800000100ee4:	90                   	nop
ffff800000100ee5:	c9                   	leaveq 
ffff800000100ee6:	c3                   	retq   

ffff800000100ee7 <consputc>:

  void
consputc(int c)
{
ffff800000100ee7:	f3 0f 1e fa          	endbr64 
ffff800000100eeb:	55                   	push   %rbp
ffff800000100eec:	48 89 e5             	mov    %rsp,%rbp
ffff800000100eef:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100ef3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  if (panicked) {
ffff800000100ef6:	48 b8 b8 34 11 00 00 	movabs $0xffff8000001134b8,%rax
ffff800000100efd:	80 ff ff 
ffff800000100f00:	8b 00                	mov    (%rax),%eax
ffff800000100f02:	85 c0                	test   %eax,%eax
ffff800000100f04:	74 1a                	je     ffff800000100f20 <consputc+0x39>
    cli();
ffff800000100f06:	48 b8 66 06 10 00 00 	movabs $0xffff800000100666,%rax
ffff800000100f0d:	80 ff ff 
ffff800000100f10:	ff d0                	callq  *%rax
    for(;;)
      hlt();
ffff800000100f12:	48 b8 72 06 10 00 00 	movabs $0xffff800000100672,%rax
ffff800000100f19:	80 ff ff 
ffff800000100f1c:	ff d0                	callq  *%rax
ffff800000100f1e:	eb f2                	jmp    ffff800000100f12 <consputc+0x2b>
  }

  if (c == BACKSPACE) {
ffff800000100f20:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
ffff800000100f27:	75 35                	jne    ffff800000100f5e <consputc+0x77>
    uartputc('\b'); uartputc(' '); uartputc('\b');
ffff800000100f29:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000100f2e:	48 b8 a8 9d 10 00 00 	movabs $0xffff800000109da8,%rax
ffff800000100f35:	80 ff ff 
ffff800000100f38:	ff d0                	callq  *%rax
ffff800000100f3a:	bf 20 00 00 00       	mov    $0x20,%edi
ffff800000100f3f:	48 b8 a8 9d 10 00 00 	movabs $0xffff800000109da8,%rax
ffff800000100f46:	80 ff ff 
ffff800000100f49:	ff d0                	callq  *%rax
ffff800000100f4b:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000100f50:	48 b8 a8 9d 10 00 00 	movabs $0xffff800000109da8,%rax
ffff800000100f57:	80 ff ff 
ffff800000100f5a:	ff d0                	callq  *%rax
ffff800000100f5c:	eb 11                	jmp    ffff800000100f6f <consputc+0x88>
  } else
    uartputc(c);
ffff800000100f5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100f61:	89 c7                	mov    %eax,%edi
ffff800000100f63:	48 b8 a8 9d 10 00 00 	movabs $0xffff800000109da8,%rax
ffff800000100f6a:	80 ff ff 
ffff800000100f6d:	ff d0                	callq  *%rax
  cgaputc(c);
ffff800000100f6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100f72:	89 c7                	mov    %eax,%edi
ffff800000100f74:	48 b8 fa 0c 10 00 00 	movabs $0xffff800000100cfa,%rax
ffff800000100f7b:	80 ff ff 
ffff800000100f7e:	ff d0                	callq  *%rax
}
ffff800000100f80:	90                   	nop
ffff800000100f81:	c9                   	leaveq 
ffff800000100f82:	c3                   	retq   

ffff800000100f83 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

  void
consoleintr(int (*getc)(void))
{
ffff800000100f83:	f3 0f 1e fa          	endbr64 
ffff800000100f87:	55                   	push   %rbp
ffff800000100f88:	48 89 e5             	mov    %rsp,%rbp
ffff800000100f8b:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100f8f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int c;

  acquire(&input.lock);
ffff800000100f93:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff800000100f9a:	80 ff ff 
ffff800000100f9d:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000100fa4:	80 ff ff 
ffff800000100fa7:	ff d0                	callq  *%rax
  while((c = getc()) >= 0){
ffff800000100fa9:	e9 6a 02 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    switch(c){
ffff800000100fae:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff800000100fb2:	0f 84 fd 00 00 00    	je     ffff8000001010b5 <consoleintr+0x132>
ffff800000100fb8:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff800000100fbc:	0f 8f 54 01 00 00    	jg     ffff800000101116 <consoleintr+0x193>
ffff800000100fc2:	83 7d fc 1a          	cmpl   $0x1a,-0x4(%rbp)
ffff800000100fc6:	74 2f                	je     ffff800000100ff7 <consoleintr+0x74>
ffff800000100fc8:	83 7d fc 1a          	cmpl   $0x1a,-0x4(%rbp)
ffff800000100fcc:	0f 8f 44 01 00 00    	jg     ffff800000101116 <consoleintr+0x193>
ffff800000100fd2:	83 7d fc 15          	cmpl   $0x15,-0x4(%rbp)
ffff800000100fd6:	74 7f                	je     ffff800000101057 <consoleintr+0xd4>
ffff800000100fd8:	83 7d fc 15          	cmpl   $0x15,-0x4(%rbp)
ffff800000100fdc:	0f 8f 34 01 00 00    	jg     ffff800000101116 <consoleintr+0x193>
ffff800000100fe2:	83 7d fc 08          	cmpl   $0x8,-0x4(%rbp)
ffff800000100fe6:	0f 84 c9 00 00 00    	je     ffff8000001010b5 <consoleintr+0x132>
ffff800000100fec:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
ffff800000100ff0:	74 20                	je     ffff800000101012 <consoleintr+0x8f>
ffff800000100ff2:	e9 1f 01 00 00       	jmpq   ffff800000101116 <consoleintr+0x193>
    case C('Z'): // reboot
      lidt(0,0);
ffff800000100ff7:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000100ffc:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000101001:	48 b8 0b 06 10 00 00 	movabs $0xffff80000010060b,%rax
ffff800000101008:	80 ff ff 
ffff80000010100b:	ff d0                	callq  *%rax
      break;
ffff80000010100d:	e9 06 02 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    case C('P'):  // Process listing.
      procdump();
ffff800000101012:	48 b8 8d 71 10 00 00 	movabs $0xffff80000010718d,%rax
ffff800000101019:	80 ff ff 
ffff80000010101c:	ff d0                	callq  *%rax
      break;
ffff80000010101e:	e9 f5 01 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
ffff800000101023:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010102a:	80 ff ff 
ffff80000010102d:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff800000101033:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101036:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010103d:	80 ff ff 
ffff800000101040:	89 90 f0 00 00 00    	mov    %edx,0xf0(%rax)
        consputc(BACKSPACE);
ffff800000101046:	bf 00 01 00 00       	mov    $0x100,%edi
ffff80000010104b:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff800000101052:	80 ff ff 
ffff800000101055:	ff d0                	callq  *%rax
      while(input.e != input.w &&
ffff800000101057:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010105e:	80 ff ff 
ffff800000101061:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff800000101067:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010106e:	80 ff ff 
ffff800000101071:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff800000101077:	39 c2                	cmp    %eax,%edx
ffff800000101079:	0f 84 99 01 00 00    	je     ffff800000101218 <consoleintr+0x295>
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
ffff80000010107f:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101086:	80 ff ff 
ffff800000101089:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff80000010108f:	83 e8 01             	sub    $0x1,%eax
ffff800000101092:	83 e0 7f             	and    $0x7f,%eax
ffff800000101095:	89 c2                	mov    %eax,%edx
ffff800000101097:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010109e:	80 ff ff 
ffff8000001010a1:	89 d2                	mov    %edx,%edx
ffff8000001010a3:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
      while(input.e != input.w &&
ffff8000001010a8:	3c 0a                	cmp    $0xa,%al
ffff8000001010aa:	0f 85 73 ff ff ff    	jne    ffff800000101023 <consoleintr+0xa0>
      }
      break;
ffff8000001010b0:	e9 63 01 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    case C('H'): case '\x7f':  // Backspace
      if (input.e != input.w) {
ffff8000001010b5:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010bc:	80 ff ff 
ffff8000001010bf:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff8000001010c5:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010cc:	80 ff ff 
ffff8000001010cf:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff8000001010d5:	39 c2                	cmp    %eax,%edx
ffff8000001010d7:	0f 84 3b 01 00 00    	je     ffff800000101218 <consoleintr+0x295>
        input.e--;
ffff8000001010dd:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010e4:	80 ff ff 
ffff8000001010e7:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001010ed:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001010f0:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010f7:	80 ff ff 
ffff8000001010fa:	89 90 f0 00 00 00    	mov    %edx,0xf0(%rax)
        consputc(BACKSPACE);
ffff800000101100:	bf 00 01 00 00       	mov    $0x100,%edi
ffff800000101105:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010110c:	80 ff ff 
ffff80000010110f:	ff d0                	callq  *%rax
      }
      break;
ffff800000101111:	e9 02 01 00 00       	jmpq   ffff800000101218 <consoleintr+0x295>
    default:
      if (c != 0 && input.e-input.r < INPUT_BUF) {
ffff800000101116:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010111a:	0f 84 f7 00 00 00    	je     ffff800000101217 <consoleintr+0x294>
ffff800000101120:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101127:	80 ff ff 
ffff80000010112a:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff800000101130:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101137:	80 ff ff 
ffff80000010113a:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff800000101140:	29 c2                	sub    %eax,%edx
ffff800000101142:	89 d0                	mov    %edx,%eax
ffff800000101144:	83 f8 7f             	cmp    $0x7f,%eax
ffff800000101147:	0f 87 ca 00 00 00    	ja     ffff800000101217 <consoleintr+0x294>
        c = (c == '\r') ? '\n' : c;
ffff80000010114d:	83 7d fc 0d          	cmpl   $0xd,-0x4(%rbp)
ffff800000101151:	74 05                	je     ffff800000101158 <consoleintr+0x1d5>
ffff800000101153:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101156:	eb 05                	jmp    ffff80000010115d <consoleintr+0x1da>
ffff800000101158:	b8 0a 00 00 00       	mov    $0xa,%eax
ffff80000010115d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        input.buf[input.e++ % INPUT_BUF] = c;
ffff800000101160:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101167:	80 ff ff 
ffff80000010116a:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff800000101170:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101173:	48 b9 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rcx
ffff80000010117a:	80 ff ff 
ffff80000010117d:	89 91 f0 00 00 00    	mov    %edx,0xf0(%rcx)
ffff800000101183:	83 e0 7f             	and    $0x7f,%eax
ffff800000101186:	89 c2                	mov    %eax,%edx
ffff800000101188:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010118b:	89 c1                	mov    %eax,%ecx
ffff80000010118d:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101194:	80 ff ff 
ffff800000101197:	89 d2                	mov    %edx,%edx
ffff800000101199:	88 4c 10 68          	mov    %cl,0x68(%rax,%rdx,1)
        consputc(c);
ffff80000010119d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001011a0:	89 c7                	mov    %eax,%edi
ffff8000001011a2:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff8000001011a9:	80 ff ff 
ffff8000001011ac:	ff d0                	callq  *%rax
        if (c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF) {
ffff8000001011ae:	83 7d fc 0a          	cmpl   $0xa,-0x4(%rbp)
ffff8000001011b2:	74 2d                	je     ffff8000001011e1 <consoleintr+0x25e>
ffff8000001011b4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
ffff8000001011b8:	74 27                	je     ffff8000001011e1 <consoleintr+0x25e>
ffff8000001011ba:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001011c1:	80 ff ff 
ffff8000001011c4:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001011ca:	48 ba c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdx
ffff8000001011d1:	80 ff ff 
ffff8000001011d4:	8b 92 e8 00 00 00    	mov    0xe8(%rdx),%edx
ffff8000001011da:	83 ea 80             	sub    $0xffffff80,%edx
ffff8000001011dd:	39 d0                	cmp    %edx,%eax
ffff8000001011df:	75 36                	jne    ffff800000101217 <consoleintr+0x294>
          input.w = input.e;
ffff8000001011e1:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001011e8:	80 ff ff 
ffff8000001011eb:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001011f1:	48 ba c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdx
ffff8000001011f8:	80 ff ff 
ffff8000001011fb:	89 82 ec 00 00 00    	mov    %eax,0xec(%rdx)
          wakeup(&input.r);
ffff800000101201:	48 bf a8 34 11 00 00 	movabs $0xffff8000001134a8,%rdi
ffff800000101208:	80 ff ff 
ffff80000010120b:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff800000101212:	80 ff ff 
ffff800000101215:	ff d0                	callq  *%rax
        }
      }
      break;
ffff800000101217:	90                   	nop
  while((c = getc()) >= 0){
ffff800000101218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010121c:	ff d0                	callq  *%rax
ffff80000010121e:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000101221:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000101225:	0f 89 83 fd ff ff    	jns    ffff800000100fae <consoleintr+0x2b>
    }
  }
  release(&input.lock);
ffff80000010122b:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff800000101232:	80 ff ff 
ffff800000101235:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010123c:	80 ff ff 
ffff80000010123f:	ff d0                	callq  *%rax
}
ffff800000101241:	90                   	nop
ffff800000101242:	c9                   	leaveq 
ffff800000101243:	c3                   	retq   

ffff800000101244 <consoleread>:

  int
consoleread(struct inode *ip, uint off, char *dst, int n)
{
ffff800000101244:	f3 0f 1e fa          	endbr64 
ffff800000101248:	55                   	push   %rbp
ffff800000101249:	48 89 e5             	mov    %rsp,%rbp
ffff80000010124c:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101250:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101254:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000101257:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff80000010125b:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  uint target;
  int c;

  iunlock(ip);
ffff80000010125e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101262:	48 89 c7             	mov    %rax,%rdi
ffff800000101265:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff80000010126c:	80 ff ff 
ffff80000010126f:	ff d0                	callq  *%rax
  target = n;
ffff800000101271:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000101274:	89 45 fc             	mov    %eax,-0x4(%rbp)
  acquire(&input.lock);
ffff800000101277:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff80000010127e:	80 ff ff 
ffff800000101281:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000101288:	80 ff ff 
ffff80000010128b:	ff d0                	callq  *%rax
  while(n > 0){
ffff80000010128d:	e9 1a 01 00 00       	jmpq   ffff8000001013ac <consoleread+0x168>
    while(input.r == input.w){
      if (proc->killed) {
ffff800000101292:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101299:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010129d:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001012a0:	85 c0                	test   %eax,%eax
ffff8000001012a2:	74 33                	je     ffff8000001012d7 <consoleread+0x93>
        release(&input.lock);
ffff8000001012a4:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff8000001012ab:	80 ff ff 
ffff8000001012ae:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001012b5:	80 ff ff 
ffff8000001012b8:	ff d0                	callq  *%rax
        ilock(ip);
ffff8000001012ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001012be:	48 89 c7             	mov    %rax,%rdi
ffff8000001012c1:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001012c8:	80 ff ff 
ffff8000001012cb:	ff d0                	callq  *%rax
        return -1;
ffff8000001012cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001012d2:	e9 18 01 00 00       	jmpq   ffff8000001013ef <consoleread+0x1ab>
      }
      sleep(&input.r, &input.lock);
ffff8000001012d7:	48 be c0 33 11 00 00 	movabs $0xffff8000001133c0,%rsi
ffff8000001012de:	80 ff ff 
ffff8000001012e1:	48 bf a8 34 11 00 00 	movabs $0xffff8000001134a8,%rdi
ffff8000001012e8:	80 ff ff 
ffff8000001012eb:	48 b8 15 6f 10 00 00 	movabs $0xffff800000106f15,%rax
ffff8000001012f2:	80 ff ff 
ffff8000001012f5:	ff d0                	callq  *%rax
    while(input.r == input.w){
ffff8000001012f7:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001012fe:	80 ff ff 
ffff800000101301:	8b 90 e8 00 00 00    	mov    0xe8(%rax),%edx
ffff800000101307:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010130e:	80 ff ff 
ffff800000101311:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff800000101317:	39 c2                	cmp    %eax,%edx
ffff800000101319:	0f 84 73 ff ff ff    	je     ffff800000101292 <consoleread+0x4e>
    }
    c = input.buf[input.r++ % INPUT_BUF];
ffff80000010131f:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101326:	80 ff ff 
ffff800000101329:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff80000010132f:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101332:	48 b9 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rcx
ffff800000101339:	80 ff ff 
ffff80000010133c:	89 91 e8 00 00 00    	mov    %edx,0xe8(%rcx)
ffff800000101342:	83 e0 7f             	and    $0x7f,%eax
ffff800000101345:	89 c2                	mov    %eax,%edx
ffff800000101347:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010134e:	80 ff ff 
ffff800000101351:	89 d2                	mov    %edx,%edx
ffff800000101353:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
ffff800000101358:	0f be c0             	movsbl %al,%eax
ffff80000010135b:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if (c == C('D')) {  // EOF
ffff80000010135e:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
ffff800000101362:	75 2d                	jne    ffff800000101391 <consoleread+0x14d>
      if (n < target) {
ffff800000101364:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000101367:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff80000010136a:	76 4c                	jbe    ffff8000001013b8 <consoleread+0x174>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
ffff80000010136c:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101373:	80 ff ff 
ffff800000101376:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff80000010137c:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff80000010137f:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101386:	80 ff ff 
ffff800000101389:	89 90 e8 00 00 00    	mov    %edx,0xe8(%rax)
      }
      break;
ffff80000010138f:	eb 27                	jmp    ffff8000001013b8 <consoleread+0x174>
    }
    *dst++ = c;
ffff800000101391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101395:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000101399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff80000010139d:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff8000001013a0:	88 10                	mov    %dl,(%rax)
    --n;
ffff8000001013a2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
    if (c == '\n')
ffff8000001013a6:	83 7d f8 0a          	cmpl   $0xa,-0x8(%rbp)
ffff8000001013aa:	74 0f                	je     ffff8000001013bb <consoleread+0x177>
  while(n > 0){
ffff8000001013ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
ffff8000001013b0:	0f 8f 41 ff ff ff    	jg     ffff8000001012f7 <consoleread+0xb3>
ffff8000001013b6:	eb 04                	jmp    ffff8000001013bc <consoleread+0x178>
      break;
ffff8000001013b8:	90                   	nop
ffff8000001013b9:	eb 01                	jmp    ffff8000001013bc <consoleread+0x178>
      break;
ffff8000001013bb:	90                   	nop
  }
  release(&input.lock);
ffff8000001013bc:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff8000001013c3:	80 ff ff 
ffff8000001013c6:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001013cd:	80 ff ff 
ffff8000001013d0:	ff d0                	callq  *%rax
  ilock(ip);
ffff8000001013d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001013d6:	48 89 c7             	mov    %rax,%rdi
ffff8000001013d9:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001013e0:	80 ff ff 
ffff8000001013e3:	ff d0                	callq  *%rax

  return target - n;
ffff8000001013e5:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff8000001013e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001013eb:	29 c2                	sub    %eax,%edx
ffff8000001013ed:	89 d0                	mov    %edx,%eax
}
ffff8000001013ef:	c9                   	leaveq 
ffff8000001013f0:	c3                   	retq   

ffff8000001013f1 <consolewrite>:

  int
consolewrite(struct inode *ip, uint off, char *buf, int n)
{
ffff8000001013f1:	f3 0f 1e fa          	endbr64 
ffff8000001013f5:	55                   	push   %rbp
ffff8000001013f6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001013f9:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001013fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101401:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000101404:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000101408:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  int i;

  iunlock(ip);
ffff80000010140b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010140f:	48 89 c7             	mov    %rax,%rdi
ffff800000101412:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000101419:	80 ff ff 
ffff80000010141c:	ff d0                	callq  *%rax
  acquire(&cons.lock);
ffff80000010141e:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff800000101425:	80 ff ff 
ffff800000101428:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff80000010142f:	80 ff ff 
ffff800000101432:	ff d0                	callq  *%rax
  for(i = 0; i < n; i++)
ffff800000101434:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010143b:	eb 28                	jmp    ffff800000101465 <consolewrite+0x74>
    consputc(buf[i] & 0xff);
ffff80000010143d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101440:	48 63 d0             	movslq %eax,%rdx
ffff800000101443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101447:	48 01 d0             	add    %rdx,%rax
ffff80000010144a:	0f b6 00             	movzbl (%rax),%eax
ffff80000010144d:	0f be c0             	movsbl %al,%eax
ffff800000101450:	0f b6 c0             	movzbl %al,%eax
ffff800000101453:	89 c7                	mov    %eax,%edi
ffff800000101455:	48 b8 e7 0e 10 00 00 	movabs $0xffff800000100ee7,%rax
ffff80000010145c:	80 ff ff 
ffff80000010145f:	ff d0                	callq  *%rax
  for(i = 0; i < n; i++)
ffff800000101461:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000101465:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101468:	3b 45 e0             	cmp    -0x20(%rbp),%eax
ffff80000010146b:	7c d0                	jl     ffff80000010143d <consolewrite+0x4c>
  release(&cons.lock);
ffff80000010146d:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff800000101474:	80 ff ff 
ffff800000101477:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010147e:	80 ff ff 
ffff800000101481:	ff d0                	callq  *%rax
  ilock(ip);
ffff800000101483:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101487:	48 89 c7             	mov    %rax,%rdi
ffff80000010148a:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101491:	80 ff ff 
ffff800000101494:	ff d0                	callq  *%rax

  return n;
ffff800000101496:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
ffff800000101499:	c9                   	leaveq 
ffff80000010149a:	c3                   	retq   

ffff80000010149b <consoleinit>:

  void
consoleinit(void)
{
ffff80000010149b:	f3 0f 1e fa          	endbr64 
ffff80000010149f:	55                   	push   %rbp
ffff8000001014a0:	48 89 e5             	mov    %rsp,%rbp
  initlock(&cons.lock, "console");
ffff8000001014a3:	48 be 2b be 10 00 00 	movabs $0xffff80000010be2b,%rsi
ffff8000001014aa:	80 ff ff 
ffff8000001014ad:	48 bf c0 34 11 00 00 	movabs $0xffff8000001134c0,%rdi
ffff8000001014b4:	80 ff ff 
ffff8000001014b7:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff8000001014be:	80 ff ff 
ffff8000001014c1:	ff d0                	callq  *%rax
  initlock(&input.lock, "input");
ffff8000001014c3:	48 be 33 be 10 00 00 	movabs $0xffff80000010be33,%rsi
ffff8000001014ca:	80 ff ff 
ffff8000001014cd:	48 bf c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdi
ffff8000001014d4:	80 ff ff 
ffff8000001014d7:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff8000001014de:	80 ff ff 
ffff8000001014e1:	ff d0                	callq  *%rax

  devsw[CONSOLE].write = consolewrite;
ffff8000001014e3:	48 b8 40 35 11 00 00 	movabs $0xffff800000113540,%rax
ffff8000001014ea:	80 ff ff 
ffff8000001014ed:	48 ba f1 13 10 00 00 	movabs $0xffff8000001013f1,%rdx
ffff8000001014f4:	80 ff ff 
ffff8000001014f7:	48 89 50 18          	mov    %rdx,0x18(%rax)
  devsw[CONSOLE].read = consoleread;
ffff8000001014fb:	48 b8 40 35 11 00 00 	movabs $0xffff800000113540,%rax
ffff800000101502:	80 ff ff 
ffff800000101505:	48 b9 44 12 10 00 00 	movabs $0xffff800000101244,%rcx
ffff80000010150c:	80 ff ff 
ffff80000010150f:	48 89 48 10          	mov    %rcx,0x10(%rax)
  cons.locking = 1;
ffff800000101513:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff80000010151a:	80 ff ff 
ffff80000010151d:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)

  ioapicenable(IRQ_KBD, 0);
ffff800000101524:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000101529:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010152e:	48 b8 e5 3f 10 00 00 	movabs $0xffff800000103fe5,%rax
ffff800000101535:	80 ff ff 
ffff800000101538:	ff d0                	callq  *%rax
}
ffff80000010153a:	90                   	nop
ffff80000010153b:	5d                   	pop    %rbp
ffff80000010153c:	c3                   	retq   

ffff80000010153d <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
ffff80000010153d:	f3 0f 1e fa          	endbr64 
ffff800000101541:	55                   	push   %rbp
ffff800000101542:	48 89 e5             	mov    %rsp,%rbp
ffff800000101545:	48 81 ec 00 02 00 00 	sub    $0x200,%rsp
ffff80000010154c:	48 89 bd 08 fe ff ff 	mov    %rdi,-0x1f8(%rbp)
ffff800000101553:	48 89 b5 00 fe ff ff 	mov    %rsi,-0x200(%rbp)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  oldpgdir = proc->pgdir;
ffff80000010155a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101561:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101565:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000101569:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

  begin_op();
ffff80000010156d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101572:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000101579:	80 ff ff 
ffff80000010157c:	ff d2                	callq  *%rdx

  if((ip = namei(path)) == 0){
ffff80000010157e:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffff800000101585:	48 89 c7             	mov    %rax,%rdi
ffff800000101588:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff80000010158f:	80 ff ff 
ffff800000101592:	ff d0                	callq  *%rax
ffff800000101594:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
ffff800000101598:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff80000010159d:	75 1b                	jne    ffff8000001015ba <exec+0x7d>
    end_op();
ffff80000010159f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001015a4:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001015ab:	80 ff ff 
ffff8000001015ae:	ff d2                	callq  *%rdx
    return -1;
ffff8000001015b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001015b5:	e9 9d 05 00 00       	jmpq   ffff800000101b57 <exec+0x61a>
  }
  ilock(ip);
ffff8000001015ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001015be:	48 89 c7             	mov    %rax,%rdi
ffff8000001015c1:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001015c8:	80 ff ff 
ffff8000001015cb:	ff d0                	callq  *%rax
  pgdir = 0;
ffff8000001015cd:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
ffff8000001015d4:	00 

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
ffff8000001015d5:	48 8d b5 50 fe ff ff 	lea    -0x1b0(%rbp),%rsi
ffff8000001015dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001015e0:	b9 40 00 00 00       	mov    $0x40,%ecx
ffff8000001015e5:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001015ea:	48 89 c7             	mov    %rax,%rdi
ffff8000001015ed:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff8000001015f4:	80 ff ff 
ffff8000001015f7:	ff d0                	callq  *%rax
ffff8000001015f9:	83 f8 40             	cmp    $0x40,%eax
ffff8000001015fc:	0f 85 e6 04 00 00    	jne    ffff800000101ae8 <exec+0x5ab>
    goto bad;
  if(elf.magic != ELF_MAGIC)
ffff800000101602:	8b 85 50 fe ff ff    	mov    -0x1b0(%rbp),%eax
ffff800000101608:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
ffff80000010160d:	0f 85 d8 04 00 00    	jne    ffff800000101aeb <exec+0x5ae>
    goto bad;

  if((pgdir = setupkvm()) == 0)
ffff800000101613:	48 b8 90 ae 10 00 00 	movabs $0xffff80000010ae90,%rax
ffff80000010161a:	80 ff ff 
ffff80000010161d:	ff d0                	callq  *%rax
ffff80000010161f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
ffff800000101623:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff800000101628:	0f 84 c0 04 00 00    	je     ffff800000101aee <exec+0x5b1>
    goto bad;

  // Load program into memory.
  sz = PGSIZE; // skip the first page
ffff80000010162e:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
ffff800000101635:	00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffff800000101636:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff80000010163d:	48 8b 85 70 fe ff ff 	mov    -0x190(%rbp),%rax
ffff800000101644:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff800000101647:	e9 0f 01 00 00       	jmpq   ffff80000010175b <exec+0x21e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
ffff80000010164c:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010164f:	48 8d b5 10 fe ff ff 	lea    -0x1f0(%rbp),%rsi
ffff800000101656:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010165a:	b9 38 00 00 00       	mov    $0x38,%ecx
ffff80000010165f:	48 89 c7             	mov    %rax,%rdi
ffff800000101662:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff800000101669:	80 ff ff 
ffff80000010166c:	ff d0                	callq  *%rax
ffff80000010166e:	83 f8 38             	cmp    $0x38,%eax
ffff800000101671:	0f 85 7a 04 00 00    	jne    ffff800000101af1 <exec+0x5b4>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
ffff800000101677:	8b 85 10 fe ff ff    	mov    -0x1f0(%rbp),%eax
ffff80000010167d:	83 f8 01             	cmp    $0x1,%eax
ffff800000101680:	0f 85 c7 00 00 00    	jne    ffff80000010174d <exec+0x210>
      continue;
    if(ph.memsz < ph.filesz)
ffff800000101686:	48 8b 95 38 fe ff ff 	mov    -0x1c8(%rbp),%rdx
ffff80000010168d:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffff800000101694:	48 39 c2             	cmp    %rax,%rdx
ffff800000101697:	0f 82 57 04 00 00    	jb     ffff800000101af4 <exec+0x5b7>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
ffff80000010169d:	48 8b 95 20 fe ff ff 	mov    -0x1e0(%rbp),%rdx
ffff8000001016a4:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffff8000001016ab:	48 01 c2             	add    %rax,%rdx
ffff8000001016ae:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff8000001016b5:	48 39 c2             	cmp    %rax,%rdx
ffff8000001016b8:	0f 82 39 04 00 00    	jb     ffff800000101af7 <exec+0x5ba>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
ffff8000001016be:	48 8b 95 20 fe ff ff 	mov    -0x1e0(%rbp),%rdx
ffff8000001016c5:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffff8000001016cc:	48 01 c2             	add    %rax,%rdx
ffff8000001016cf:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001016d3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001016d7:	48 89 ce             	mov    %rcx,%rsi
ffff8000001016da:	48 89 c7             	mov    %rax,%rdi
ffff8000001016dd:	48 b8 f8 b5 10 00 00 	movabs $0xffff80000010b5f8,%rax
ffff8000001016e4:	80 ff ff 
ffff8000001016e7:	ff d0                	callq  *%rax
ffff8000001016e9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff8000001016ed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001016f2:	0f 84 02 04 00 00    	je     ffff800000101afa <exec+0x5bd>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
ffff8000001016f8:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff8000001016ff:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff800000101704:	48 85 c0             	test   %rax,%rax
ffff800000101707:	0f 85 f0 03 00 00    	jne    ffff800000101afd <exec+0x5c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
ffff80000010170d:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffff800000101714:	89 c7                	mov    %eax,%edi
ffff800000101716:	48 8b 85 18 fe ff ff 	mov    -0x1e8(%rbp),%rax
ffff80000010171d:	89 c1                	mov    %eax,%ecx
ffff80000010171f:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff800000101726:	48 89 c6             	mov    %rax,%rsi
ffff800000101729:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffff80000010172d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101731:	41 89 f8             	mov    %edi,%r8d
ffff800000101734:	48 89 c7             	mov    %rax,%rdi
ffff800000101737:	48 b8 d2 b4 10 00 00 	movabs $0xffff80000010b4d2,%rax
ffff80000010173e:	80 ff ff 
ffff800000101741:	ff d0                	callq  *%rax
ffff800000101743:	85 c0                	test   %eax,%eax
ffff800000101745:	0f 88 b5 03 00 00    	js     ffff800000101b00 <exec+0x5c3>
ffff80000010174b:	eb 01                	jmp    ffff80000010174e <exec+0x211>
      continue;
ffff80000010174d:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffff80000010174e:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffff800000101752:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000101755:	83 c0 38             	add    $0x38,%eax
ffff800000101758:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff80000010175b:	0f b7 85 88 fe ff ff 	movzwl -0x178(%rbp),%eax
ffff800000101762:	0f b7 c0             	movzwl %ax,%eax
ffff800000101765:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000101768:	0f 8c de fe ff ff    	jl     ffff80000010164c <exec+0x10f>
      goto bad;
  }
  iunlockput(ip);
ffff80000010176e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101772:	48 89 c7             	mov    %rax,%rdi
ffff800000101775:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff80000010177c:	80 ff ff 
ffff80000010177f:	ff d0                	callq  *%rax
  end_op();
ffff800000101781:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101786:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff80000010178d:	80 ff ff 
ffff800000101790:	ff d2                	callq  *%rdx
  ip = 0;
ffff800000101792:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
ffff800000101799:	00 

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
ffff80000010179a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010179e:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff8000001017a4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff8000001017aa:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
ffff8000001017ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001017b2:	48 8d 90 00 20 00 00 	lea    0x2000(%rax),%rdx
ffff8000001017b9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001017bd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001017c1:	48 89 ce             	mov    %rcx,%rsi
ffff8000001017c4:	48 89 c7             	mov    %rax,%rdi
ffff8000001017c7:	48 b8 f8 b5 10 00 00 	movabs $0xffff80000010b5f8,%rax
ffff8000001017ce:	80 ff ff 
ffff8000001017d1:	ff d0                	callq  *%rax
ffff8000001017d3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff8000001017d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001017dc:	0f 84 21 03 00 00    	je     ffff800000101b03 <exec+0x5c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
ffff8000001017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001017e6:	48 2d 00 20 00 00    	sub    $0x2000,%rax
ffff8000001017ec:	48 89 c2             	mov    %rax,%rdx
ffff8000001017ef:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001017f3:	48 89 d6             	mov    %rdx,%rsi
ffff8000001017f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001017f9:	48 b8 72 ba 10 00 00 	movabs $0xffff80000010ba72,%rax
ffff800000101800:	80 ff ff 
ffff800000101803:	ff d0                	callq  *%rax
  sp = sz;
ffff800000101805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101809:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
ffff80000010180d:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
ffff800000101814:	00 
ffff800000101815:	e9 c9 00 00 00       	jmpq   ffff8000001018e3 <exec+0x3a6>
    if(argc >= MAXARG)
ffff80000010181a:	48 83 7d e0 1f       	cmpq   $0x1f,-0x20(%rbp)
ffff80000010181f:	0f 87 e1 02 00 00    	ja     ffff800000101b06 <exec+0x5c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~(sizeof(addr_t)-1);
ffff800000101825:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101829:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000101830:	00 
ffff800000101831:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff800000101838:	48 01 d0             	add    %rdx,%rax
ffff80000010183b:	48 8b 00             	mov    (%rax),%rax
ffff80000010183e:	48 89 c7             	mov    %rax,%rdi
ffff800000101841:	48 b8 07 7c 10 00 00 	movabs $0xffff800000107c07,%rax
ffff800000101848:	80 ff ff 
ffff80000010184b:	ff d0                	callq  *%rax
ffff80000010184d:	83 c0 01             	add    $0x1,%eax
ffff800000101850:	48 98                	cltq   
ffff800000101852:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101856:	48 29 c2             	sub    %rax,%rdx
ffff800000101859:	48 89 d0             	mov    %rdx,%rax
ffff80000010185c:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
ffff800000101860:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
ffff800000101864:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101868:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010186f:	00 
ffff800000101870:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff800000101877:	48 01 d0             	add    %rdx,%rax
ffff80000010187a:	48 8b 00             	mov    (%rax),%rax
ffff80000010187d:	48 89 c7             	mov    %rax,%rdi
ffff800000101880:	48 b8 07 7c 10 00 00 	movabs $0xffff800000107c07,%rax
ffff800000101887:	80 ff ff 
ffff80000010188a:	ff d0                	callq  *%rax
ffff80000010188c:	83 c0 01             	add    $0x1,%eax
ffff80000010188f:	48 63 c8             	movslq %eax,%rcx
ffff800000101892:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101896:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010189d:	00 
ffff80000010189e:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff8000001018a5:	48 01 d0             	add    %rdx,%rax
ffff8000001018a8:	48 8b 10             	mov    (%rax),%rdx
ffff8000001018ab:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffff8000001018af:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001018b3:	48 89 c7             	mov    %rax,%rdi
ffff8000001018b6:	48 b8 e7 bc 10 00 00 	movabs $0xffff80000010bce7,%rax
ffff8000001018bd:	80 ff ff 
ffff8000001018c0:	ff d0                	callq  *%rax
ffff8000001018c2:	85 c0                	test   %eax,%eax
ffff8000001018c4:	0f 88 3f 02 00 00    	js     ffff800000101b09 <exec+0x5cc>
      goto bad;
    ustack[3+argc] = sp;
ffff8000001018ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001018ce:	48 8d 50 03          	lea    0x3(%rax),%rdx
ffff8000001018d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001018d6:	48 89 84 d5 90 fe ff 	mov    %rax,-0x170(%rbp,%rdx,8)
ffff8000001018dd:	ff 
  for(argc = 0; argv[argc]; argc++) {
ffff8000001018de:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
ffff8000001018e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001018e7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001018ee:	00 
ffff8000001018ef:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff8000001018f6:	48 01 d0             	add    %rdx,%rax
ffff8000001018f9:	48 8b 00             	mov    (%rax),%rax
ffff8000001018fc:	48 85 c0             	test   %rax,%rax
ffff8000001018ff:	0f 85 15 ff ff ff    	jne    ffff80000010181a <exec+0x2dd>
  }
  ustack[3+argc] = 0;
ffff800000101905:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101909:	48 83 c0 03          	add    $0x3,%rax
ffff80000010190d:	48 c7 84 c5 90 fe ff 	movq   $0x0,-0x170(%rbp,%rax,8)
ffff800000101914:	ff 00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
ffff800000101919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010191e:	48 89 85 90 fe ff ff 	mov    %rax,-0x170(%rbp)
  ustack[1] = argc;
ffff800000101925:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101929:	48 89 85 98 fe ff ff 	mov    %rax,-0x168(%rbp)
  ustack[2] = sp - (argc+1)*sizeof(addr_t);  // argv pointer
ffff800000101930:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101934:	48 83 c0 01          	add    $0x1,%rax
ffff800000101938:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010193f:	00 
ffff800000101940:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000101944:	48 29 d0             	sub    %rdx,%rax
ffff800000101947:	48 89 85 a0 fe ff ff 	mov    %rax,-0x160(%rbp)

  proc->tf->rdi = argc;
ffff80000010194e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101955:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101959:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010195d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000101961:	48 89 50 30          	mov    %rdx,0x30(%rax)
  proc->tf->rsi = sp - (argc+1)*sizeof(addr_t);
ffff800000101965:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101969:	48 83 c0 01          	add    $0x1,%rax
ffff80000010196d:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff800000101974:	00 
ffff800000101975:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010197c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101980:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101984:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101988:	48 29 ca             	sub    %rcx,%rdx
ffff80000010198b:	48 89 50 28          	mov    %rdx,0x28(%rax)


  sp -= (3+argc+1) * sizeof(addr_t);
ffff80000010198f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101993:	48 83 c0 04          	add    $0x4,%rax
ffff800000101997:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010199b:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*sizeof(addr_t)) < 0)
ffff80000010199f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001019a3:	48 83 c0 04          	add    $0x4,%rax
ffff8000001019a7:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff8000001019ae:	00 
ffff8000001019af:	48 8d 95 90 fe ff ff 	lea    -0x170(%rbp),%rdx
ffff8000001019b6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffff8000001019ba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001019be:	48 89 c7             	mov    %rax,%rdi
ffff8000001019c1:	48 b8 e7 bc 10 00 00 	movabs $0xffff80000010bce7,%rax
ffff8000001019c8:	80 ff ff 
ffff8000001019cb:	ff d0                	callq  *%rax
ffff8000001019cd:	85 c0                	test   %eax,%eax
ffff8000001019cf:	0f 88 37 01 00 00    	js     ffff800000101b0c <exec+0x5cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
ffff8000001019d5:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffff8000001019dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001019e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001019e8:	eb 1c                	jmp    ffff800000101a06 <exec+0x4c9>
    if(*s == '/')
ffff8000001019ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019ee:	0f b6 00             	movzbl (%rax),%eax
ffff8000001019f1:	3c 2f                	cmp    $0x2f,%al
ffff8000001019f3:	75 0c                	jne    ffff800000101a01 <exec+0x4c4>
      last = s+1;
ffff8000001019f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019f9:	48 83 c0 01          	add    $0x1,%rax
ffff8000001019fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(last=s=path; *s; s++)
ffff800000101a01:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000101a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101a0a:	0f b6 00             	movzbl (%rax),%eax
ffff800000101a0d:	84 c0                	test   %al,%al
ffff800000101a0f:	75 d9                	jne    ffff8000001019ea <exec+0x4ad>
  safestrcpy(proc->name, last, sizeof(proc->name));
ffff800000101a11:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a18:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a1c:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff800000101a23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000101a27:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000101a2c:	48 89 c6             	mov    %rax,%rsi
ffff800000101a2f:	48 89 cf             	mov    %rcx,%rdi
ffff800000101a32:	48 b8 a1 7b 10 00 00 	movabs $0xffff800000107ba1,%rax
ffff800000101a39:	80 ff ff 
ffff800000101a3c:	ff d0                	callq  *%rax

  // Commit to the user image.
  proc->pgdir = pgdir;
ffff800000101a3e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a45:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a49:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
ffff800000101a4d:	48 89 50 08          	mov    %rdx,0x8(%rax)
  proc->sz = sz;
ffff800000101a51:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a58:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a5c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000101a60:	48 89 10             	mov    %rdx,(%rax)
  proc->tf->rip = elf.entry;  // main
ffff800000101a63:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a6a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a6e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a72:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffff800000101a79:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
  proc->tf->rcx = elf.entry;
ffff800000101a80:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a87:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a8b:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a8f:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffff800000101a96:	48 89 50 10          	mov    %rdx,0x10(%rax)
  proc->tf->rsp = sp;
ffff800000101a9a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101aa1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101aa5:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101aa9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101aad:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  switchuvm(proc);
ffff800000101ab4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101abb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101abf:	48 89 c7             	mov    %rax,%rdi
ffff800000101ac2:	48 b8 f6 af 10 00 00 	movabs $0xffff80000010aff6,%rax
ffff800000101ac9:	80 ff ff 
ffff800000101acc:	ff d0                	callq  *%rax
  freevm(oldpgdir);
ffff800000101ace:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101ad2:	48 89 c7             	mov    %rax,%rdi
ffff800000101ad5:	48 b8 3a b8 10 00 00 	movabs $0xffff80000010b83a,%rax
ffff800000101adc:	80 ff ff 
ffff800000101adf:	ff d0                	callq  *%rax
  return 0;
ffff800000101ae1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101ae6:	eb 6f                	jmp    ffff800000101b57 <exec+0x61a>
    goto bad;
ffff800000101ae8:	90                   	nop
ffff800000101ae9:	eb 22                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101aeb:	90                   	nop
ffff800000101aec:	eb 1f                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101aee:	90                   	nop
ffff800000101aef:	eb 1c                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101af1:	90                   	nop
ffff800000101af2:	eb 19                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101af4:	90                   	nop
ffff800000101af5:	eb 16                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101af7:	90                   	nop
ffff800000101af8:	eb 13                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101afa:	90                   	nop
ffff800000101afb:	eb 10                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101afd:	90                   	nop
ffff800000101afe:	eb 0d                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101b00:	90                   	nop
ffff800000101b01:	eb 0a                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101b03:	90                   	nop
ffff800000101b04:	eb 07                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101b06:	90                   	nop
ffff800000101b07:	eb 04                	jmp    ffff800000101b0d <exec+0x5d0>
      goto bad;
ffff800000101b09:	90                   	nop
ffff800000101b0a:	eb 01                	jmp    ffff800000101b0d <exec+0x5d0>
    goto bad;
ffff800000101b0c:	90                   	nop

 bad:
  if(pgdir)
ffff800000101b0d:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff800000101b12:	74 13                	je     ffff800000101b27 <exec+0x5ea>
    freevm(pgdir);
ffff800000101b14:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101b18:	48 89 c7             	mov    %rax,%rdi
ffff800000101b1b:	48 b8 3a b8 10 00 00 	movabs $0xffff80000010b83a,%rax
ffff800000101b22:	80 ff ff 
ffff800000101b25:	ff d0                	callq  *%rax
  if(ip){
ffff800000101b27:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff800000101b2c:	74 24                	je     ffff800000101b52 <exec+0x615>
    iunlockput(ip);
ffff800000101b2e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101b32:	48 89 c7             	mov    %rax,%rdi
ffff800000101b35:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000101b3c:	80 ff ff 
ffff800000101b3f:	ff d0                	callq  *%rax
    end_op();
ffff800000101b41:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101b46:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000101b4d:	80 ff ff 
ffff800000101b50:	ff d2                	callq  *%rdx
  }
  return -1;
ffff800000101b52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000101b57:	c9                   	leaveq 
ffff800000101b58:	c3                   	retq   

ffff800000101b59 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
ffff800000101b59:	f3 0f 1e fa          	endbr64 
ffff800000101b5d:	55                   	push   %rbp
ffff800000101b5e:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ftable.lock, "ftable");
ffff800000101b61:	48 be 39 be 10 00 00 	movabs $0xffff80000010be39,%rsi
ffff800000101b68:	80 ff ff 
ffff800000101b6b:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101b72:	80 ff ff 
ffff800000101b75:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff800000101b7c:	80 ff ff 
ffff800000101b7f:	ff d0                	callq  *%rax
}
ffff800000101b81:	90                   	nop
ffff800000101b82:	5d                   	pop    %rbp
ffff800000101b83:	c3                   	retq   

ffff800000101b84 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
ffff800000101b84:	f3 0f 1e fa          	endbr64 
ffff800000101b88:	55                   	push   %rbp
ffff800000101b89:	48 89 e5             	mov    %rsp,%rbp
ffff800000101b8c:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;

  acquire(&ftable.lock);
ffff800000101b90:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101b97:	80 ff ff 
ffff800000101b9a:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000101ba1:	80 ff ff 
ffff800000101ba4:	ff d0                	callq  *%rax
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffff800000101ba6:	48 b8 48 36 11 00 00 	movabs $0xffff800000113648,%rax
ffff800000101bad:	80 ff ff 
ffff800000101bb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000101bb4:	eb 37                	jmp    ffff800000101bed <filealloc+0x69>
    if(f->ref == 0){
ffff800000101bb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101bba:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101bbd:	85 c0                	test   %eax,%eax
ffff800000101bbf:	75 27                	jne    ffff800000101be8 <filealloc+0x64>
      f->ref = 1;
ffff800000101bc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101bc5:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%rax)
      release(&ftable.lock);
ffff800000101bcc:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101bd3:	80 ff ff 
ffff800000101bd6:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000101bdd:	80 ff ff 
ffff800000101be0:	ff d0                	callq  *%rax
      return f;
ffff800000101be2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101be6:	eb 30                	jmp    ffff800000101c18 <filealloc+0x94>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffff800000101be8:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffff800000101bed:	48 b8 e8 45 11 00 00 	movabs $0xffff8000001145e8,%rax
ffff800000101bf4:	80 ff ff 
ffff800000101bf7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000101bfb:	72 b9                	jb     ffff800000101bb6 <filealloc+0x32>
    }
  }
  release(&ftable.lock);
ffff800000101bfd:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101c04:	80 ff ff 
ffff800000101c07:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000101c0e:	80 ff ff 
ffff800000101c11:	ff d0                	callq  *%rax
  return 0;
ffff800000101c13:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000101c18:	c9                   	leaveq 
ffff800000101c19:	c3                   	retq   

ffff800000101c1a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
ffff800000101c1a:	f3 0f 1e fa          	endbr64 
ffff800000101c1e:	55                   	push   %rbp
ffff800000101c1f:	48 89 e5             	mov    %rsp,%rbp
ffff800000101c22:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101c26:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ftable.lock);
ffff800000101c2a:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101c31:	80 ff ff 
ffff800000101c34:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000101c3b:	80 ff ff 
ffff800000101c3e:	ff d0                	callq  *%rax
  if(f->ref < 1)
ffff800000101c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c44:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101c47:	85 c0                	test   %eax,%eax
ffff800000101c49:	7f 16                	jg     ffff800000101c61 <filedup+0x47>
    panic("filedup");
ffff800000101c4b:	48 bf 40 be 10 00 00 	movabs $0xffff80000010be40,%rdi
ffff800000101c52:	80 ff ff 
ffff800000101c55:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000101c5c:	80 ff ff 
ffff800000101c5f:	ff d0                	callq  *%rax
  f->ref++;
ffff800000101c61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c65:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101c68:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101c6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c6f:	89 50 04             	mov    %edx,0x4(%rax)
  release(&ftable.lock);
ffff800000101c72:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101c79:	80 ff ff 
ffff800000101c7c:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000101c83:	80 ff ff 
ffff800000101c86:	ff d0                	callq  *%rax
  return f;
ffff800000101c88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000101c8c:	c9                   	leaveq 
ffff800000101c8d:	c3                   	retq   

ffff800000101c8e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
ffff800000101c8e:	f3 0f 1e fa          	endbr64 
ffff800000101c92:	55                   	push   %rbp
ffff800000101c93:	48 89 e5             	mov    %rsp,%rbp
ffff800000101c96:	53                   	push   %rbx
ffff800000101c97:	48 83 ec 48          	sub    $0x48,%rsp
ffff800000101c9b:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct file ff;

  acquire(&ftable.lock);
ffff800000101c9f:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101ca6:	80 ff ff 
ffff800000101ca9:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000101cb0:	80 ff ff 
ffff800000101cb3:	ff d0                	callq  *%rax
  if(f->ref < 1)
ffff800000101cb5:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101cb9:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101cbc:	85 c0                	test   %eax,%eax
ffff800000101cbe:	7f 16                	jg     ffff800000101cd6 <fileclose+0x48>
    panic("fileclose");
ffff800000101cc0:	48 bf 48 be 10 00 00 	movabs $0xffff80000010be48,%rdi
ffff800000101cc7:	80 ff ff 
ffff800000101cca:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000101cd1:	80 ff ff 
ffff800000101cd4:	ff d0                	callq  *%rax
  if(--f->ref > 0){
ffff800000101cd6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101cda:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101cdd:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101ce0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101ce4:	89 50 04             	mov    %edx,0x4(%rax)
ffff800000101ce7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101ceb:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101cee:	85 c0                	test   %eax,%eax
ffff800000101cf0:	7e 1b                	jle    ffff800000101d0d <fileclose+0x7f>
    release(&ftable.lock);
ffff800000101cf2:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101cf9:	80 ff ff 
ffff800000101cfc:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000101d03:	80 ff ff 
ffff800000101d06:	ff d0                	callq  *%rax
ffff800000101d08:	e9 b9 00 00 00       	jmpq   ffff800000101dc6 <fileclose+0x138>
    return;
  }
  ff = *f;
ffff800000101d0d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d11:	48 8b 08             	mov    (%rax),%rcx
ffff800000101d14:	48 8b 58 08          	mov    0x8(%rax),%rbx
ffff800000101d18:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff800000101d1c:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
ffff800000101d20:	48 8b 48 10          	mov    0x10(%rax),%rcx
ffff800000101d24:	48 8b 58 18          	mov    0x18(%rax),%rbx
ffff800000101d28:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
ffff800000101d2c:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
ffff800000101d30:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff800000101d34:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  f->ref = 0;
ffff800000101d38:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
  f->type = FD_NONE;
ffff800000101d43:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d47:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  release(&ftable.lock);
ffff800000101d4d:	48 bf e0 35 11 00 00 	movabs $0xffff8000001135e0,%rdi
ffff800000101d54:	80 ff ff 
ffff800000101d57:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000101d5e:	80 ff ff 
ffff800000101d61:	ff d0                	callq  *%rax

  if(ff.type == FD_PIPE)
ffff800000101d63:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff800000101d66:	83 f8 01             	cmp    $0x1,%eax
ffff800000101d69:	75 1e                	jne    ffff800000101d89 <fileclose+0xfb>
    pipeclose(ff.pipe, ff.writable);
ffff800000101d6b:	0f b6 45 c9          	movzbl -0x37(%rbp),%eax
ffff800000101d6f:	0f be d0             	movsbl %al,%edx
ffff800000101d72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000101d76:	89 d6                	mov    %edx,%esi
ffff800000101d78:	48 89 c7             	mov    %rax,%rdi
ffff800000101d7b:	48 b8 85 5e 10 00 00 	movabs $0xffff800000105e85,%rax
ffff800000101d82:	80 ff ff 
ffff800000101d85:	ff d0                	callq  *%rax
ffff800000101d87:	eb 3d                	jmp    ffff800000101dc6 <fileclose+0x138>
  else if(ff.type == FD_INODE){
ffff800000101d89:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff800000101d8c:	83 f8 02             	cmp    $0x2,%eax
ffff800000101d8f:	75 35                	jne    ffff800000101dc6 <fileclose+0x138>
    begin_op();
ffff800000101d91:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101d96:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000101d9d:	80 ff ff 
ffff800000101da0:	ff d2                	callq  *%rdx
    iput(ff.ip);
ffff800000101da2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101da6:	48 89 c7             	mov    %rax,%rdi
ffff800000101da9:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000101db0:	80 ff ff 
ffff800000101db3:	ff d0                	callq  *%rax
    end_op();
ffff800000101db5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101dba:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000101dc1:	80 ff ff 
ffff800000101dc4:	ff d2                	callq  *%rdx
  }
}
ffff800000101dc6:	48 83 c4 48          	add    $0x48,%rsp
ffff800000101dca:	5b                   	pop    %rbx
ffff800000101dcb:	5d                   	pop    %rbp
ffff800000101dcc:	c3                   	retq   

ffff800000101dcd <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
ffff800000101dcd:	f3 0f 1e fa          	endbr64 
ffff800000101dd1:	55                   	push   %rbp
ffff800000101dd2:	48 89 e5             	mov    %rsp,%rbp
ffff800000101dd5:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101dd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000101ddd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(f->type == FD_INODE){
ffff800000101de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101de5:	8b 00                	mov    (%rax),%eax
ffff800000101de7:	83 f8 02             	cmp    $0x2,%eax
ffff800000101dea:	75 53                	jne    ffff800000101e3f <filestat+0x72>
    ilock(f->ip);
ffff800000101dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101df0:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101df4:	48 89 c7             	mov    %rax,%rdi
ffff800000101df7:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101dfe:	80 ff ff 
ffff800000101e01:	ff d0                	callq  *%rax
    stati(f->ip, st);
ffff800000101e03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101e07:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101e0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000101e0f:	48 89 d6             	mov    %rdx,%rsi
ffff800000101e12:	48 89 c7             	mov    %rax,%rdi
ffff800000101e15:	48 b8 e7 2e 10 00 00 	movabs $0xffff800000102ee7,%rax
ffff800000101e1c:	80 ff ff 
ffff800000101e1f:	ff d0                	callq  *%rax
    iunlock(f->ip);
ffff800000101e21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101e25:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101e29:	48 89 c7             	mov    %rax,%rdi
ffff800000101e2c:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000101e33:	80 ff ff 
ffff800000101e36:	ff d0                	callq  *%rax
    return 0;
ffff800000101e38:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101e3d:	eb 05                	jmp    ffff800000101e44 <filestat+0x77>
  }
  return -1;
ffff800000101e3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000101e44:	c9                   	leaveq 
ffff800000101e45:	c3                   	retq   

ffff800000101e46 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
ffff800000101e46:	f3 0f 1e fa          	endbr64 
ffff800000101e4a:	55                   	push   %rbp
ffff800000101e4b:	48 89 e5             	mov    %rsp,%rbp
ffff800000101e4e:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101e52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101e56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000101e5a:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->readable == 0)
ffff800000101e5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e61:	0f b6 40 08          	movzbl 0x8(%rax),%eax
ffff800000101e65:	84 c0                	test   %al,%al
ffff800000101e67:	75 0a                	jne    ffff800000101e73 <fileread+0x2d>
    return -1;
ffff800000101e69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000101e6e:	e9 c6 00 00 00       	jmpq   ffff800000101f39 <fileread+0xf3>
  if(f->type == FD_PIPE)
ffff800000101e73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e77:	8b 00                	mov    (%rax),%eax
ffff800000101e79:	83 f8 01             	cmp    $0x1,%eax
ffff800000101e7c:	75 26                	jne    ffff800000101ea4 <fileread+0x5e>
    return piperead(f->pipe, addr, n);
ffff800000101e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e82:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000101e86:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000101e89:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff800000101e8d:	48 89 ce             	mov    %rcx,%rsi
ffff800000101e90:	48 89 c7             	mov    %rax,%rdi
ffff800000101e93:	48 b8 a0 60 10 00 00 	movabs $0xffff8000001060a0,%rax
ffff800000101e9a:	80 ff ff 
ffff800000101e9d:	ff d0                	callq  *%rax
ffff800000101e9f:	e9 95 00 00 00       	jmpq   ffff800000101f39 <fileread+0xf3>
  if(f->type == FD_INODE){
ffff800000101ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ea8:	8b 00                	mov    (%rax),%eax
ffff800000101eaa:	83 f8 02             	cmp    $0x2,%eax
ffff800000101ead:	75 74                	jne    ffff800000101f23 <fileread+0xdd>
    ilock(f->ip);
ffff800000101eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101eb3:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101eb7:	48 89 c7             	mov    %rax,%rdi
ffff800000101eba:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101ec1:	80 ff ff 
ffff800000101ec4:	ff d0                	callq  *%rax
    if((r = readi(f->ip, addr, f->off, n)) > 0)
ffff800000101ec6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
ffff800000101ec9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ecd:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ed4:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101ed8:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
ffff800000101edc:	48 89 c7             	mov    %rax,%rdi
ffff800000101edf:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff800000101ee6:	80 ff ff 
ffff800000101ee9:	ff d0                	callq  *%rax
ffff800000101eeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000101eee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000101ef2:	7e 13                	jle    ffff800000101f07 <fileread+0xc1>
      f->off += r;
ffff800000101ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ef8:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101efe:	01 c2                	add    %eax,%edx
ffff800000101f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f04:	89 50 20             	mov    %edx,0x20(%rax)
    iunlock(f->ip);
ffff800000101f07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f0b:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101f0f:	48 89 c7             	mov    %rax,%rdi
ffff800000101f12:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000101f19:	80 ff ff 
ffff800000101f1c:	ff d0                	callq  *%rax
    return r;
ffff800000101f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101f21:	eb 16                	jmp    ffff800000101f39 <fileread+0xf3>
  }
  panic("fileread");
ffff800000101f23:	48 bf 52 be 10 00 00 	movabs $0xffff80000010be52,%rdi
ffff800000101f2a:	80 ff ff 
ffff800000101f2d:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000101f34:	80 ff ff 
ffff800000101f37:	ff d0                	callq  *%rax
}
ffff800000101f39:	c9                   	leaveq 
ffff800000101f3a:	c3                   	retq   

ffff800000101f3b <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
ffff800000101f3b:	f3 0f 1e fa          	endbr64 
ffff800000101f3f:	55                   	push   %rbp
ffff800000101f40:	48 89 e5             	mov    %rsp,%rbp
ffff800000101f43:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101f47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101f4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000101f4f:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->writable == 0)
ffff800000101f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f56:	0f b6 40 09          	movzbl 0x9(%rax),%eax
ffff800000101f5a:	84 c0                	test   %al,%al
ffff800000101f5c:	75 0a                	jne    ffff800000101f68 <filewrite+0x2d>
    return -1;
ffff800000101f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000101f63:	e9 67 01 00 00       	jmpq   ffff8000001020cf <filewrite+0x194>
  if(f->type == FD_PIPE)
ffff800000101f68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f6c:	8b 00                	mov    (%rax),%eax
ffff800000101f6e:	83 f8 01             	cmp    $0x1,%eax
ffff800000101f71:	75 26                	jne    ffff800000101f99 <filewrite+0x5e>
    return pipewrite(f->pipe, addr, n);
ffff800000101f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f77:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000101f7b:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000101f7e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff800000101f82:	48 89 ce             	mov    %rcx,%rsi
ffff800000101f85:	48 89 c7             	mov    %rax,%rdi
ffff800000101f88:	48 b8 5c 5f 10 00 00 	movabs $0xffff800000105f5c,%rax
ffff800000101f8f:	80 ff ff 
ffff800000101f92:	ff d0                	callq  *%rax
ffff800000101f94:	e9 36 01 00 00       	jmpq   ffff8000001020cf <filewrite+0x194>
  if(f->type == FD_INODE){
ffff800000101f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f9d:	8b 00                	mov    (%rax),%eax
ffff800000101f9f:	83 f8 02             	cmp    $0x2,%eax
ffff800000101fa2:	0f 85 11 01 00 00    	jne    ffff8000001020b9 <filewrite+0x17e>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
ffff800000101fa8:	c7 45 f4 00 1a 00 00 	movl   $0x1a00,-0xc(%rbp)
    int i = 0;
ffff800000101faf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    while(i < n){
ffff800000101fb6:	e9 db 00 00 00       	jmpq   ffff800000102096 <filewrite+0x15b>
      int n1 = n - i;
ffff800000101fbb:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000101fbe:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000101fc1:	89 45 f8             	mov    %eax,-0x8(%rbp)
      if(n1 > max)
ffff800000101fc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000101fc7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
ffff800000101fca:	7e 06                	jle    ffff800000101fd2 <filewrite+0x97>
        n1 = max;
ffff800000101fcc:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000101fcf:	89 45 f8             	mov    %eax,-0x8(%rbp)

      begin_op();
ffff800000101fd2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101fd7:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000101fde:	80 ff ff 
ffff800000101fe1:	ff d2                	callq  *%rdx
      ilock(f->ip);
ffff800000101fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101fe7:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101feb:	48 89 c7             	mov    %rax,%rdi
ffff800000101fee:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000101ff5:	80 ff ff 
ffff800000101ff8:	ff d0                	callq  *%rax
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
ffff800000101ffa:	8b 4d f8             	mov    -0x8(%rbp),%ecx
ffff800000101ffd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102001:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000102004:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102007:	48 63 f0             	movslq %eax,%rsi
ffff80000010200a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010200e:	48 01 c6             	add    %rax,%rsi
ffff800000102011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102015:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000102019:	48 89 c7             	mov    %rax,%rdi
ffff80000010201c:	48 b8 22 31 10 00 00 	movabs $0xffff800000103122,%rax
ffff800000102023:	80 ff ff 
ffff800000102026:	ff d0                	callq  *%rax
ffff800000102028:	89 45 f0             	mov    %eax,-0x10(%rbp)
ffff80000010202b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffff80000010202f:	7e 13                	jle    ffff800000102044 <filewrite+0x109>
        f->off += r;
ffff800000102031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102035:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000102038:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010203b:	01 c2                	add    %eax,%edx
ffff80000010203d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102041:	89 50 20             	mov    %edx,0x20(%rax)
      iunlock(f->ip);
ffff800000102044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102048:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff80000010204c:	48 89 c7             	mov    %rax,%rdi
ffff80000010204f:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000102056:	80 ff ff 
ffff800000102059:	ff d0                	callq  *%rax
      end_op();
ffff80000010205b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000102060:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000102067:	80 ff ff 
ffff80000010206a:	ff d2                	callq  *%rdx

      if(r < 0)
ffff80000010206c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffff800000102070:	78 32                	js     ffff8000001020a4 <filewrite+0x169>
        break;
      if(r != n1)
ffff800000102072:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102075:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffff800000102078:	74 16                	je     ffff800000102090 <filewrite+0x155>
        panic("short filewrite");
ffff80000010207a:	48 bf 5b be 10 00 00 	movabs $0xffff80000010be5b,%rdi
ffff800000102081:	80 ff ff 
ffff800000102084:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010208b:	80 ff ff 
ffff80000010208e:	ff d0                	callq  *%rax
      i += r;
ffff800000102090:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102093:	01 45 fc             	add    %eax,-0x4(%rbp)
    while(i < n){
ffff800000102096:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102099:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff80000010209c:	0f 8c 19 ff ff ff    	jl     ffff800000101fbb <filewrite+0x80>
ffff8000001020a2:	eb 01                	jmp    ffff8000001020a5 <filewrite+0x16a>
        break;
ffff8000001020a4:	90                   	nop
    }
    return i == n ? n : -1;
ffff8000001020a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001020a8:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff8000001020ab:	75 05                	jne    ffff8000001020b2 <filewrite+0x177>
ffff8000001020ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001020b0:	eb 1d                	jmp    ffff8000001020cf <filewrite+0x194>
ffff8000001020b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001020b7:	eb 16                	jmp    ffff8000001020cf <filewrite+0x194>
  }
  panic("filewrite");
ffff8000001020b9:	48 bf 6b be 10 00 00 	movabs $0xffff80000010be6b,%rdi
ffff8000001020c0:	80 ff ff 
ffff8000001020c3:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001020ca:	80 ff ff 
ffff8000001020cd:	ff d0                	callq  *%rax
}
ffff8000001020cf:	c9                   	leaveq 
ffff8000001020d0:	c3                   	retq   

ffff8000001020d1 <readsb>:
struct superblock sb;

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
ffff8000001020d1:	f3 0f 1e fa          	endbr64 
ffff8000001020d5:	55                   	push   %rbp
ffff8000001020d6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001020d9:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001020dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001020e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct buf *bp = bread(dev, 1);
ffff8000001020e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001020e7:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001020ec:	89 c7                	mov    %eax,%edi
ffff8000001020ee:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001020f5:	80 ff ff 
ffff8000001020f8:	ff d0                	callq  *%rax
ffff8000001020fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memmove(sb, bp->data, sizeof(*sb));
ffff8000001020fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102102:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff800000102109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010210d:	ba 1c 00 00 00       	mov    $0x1c,%edx
ffff800000102112:	48 89 ce             	mov    %rcx,%rsi
ffff800000102115:	48 89 c7             	mov    %rax,%rdi
ffff800000102118:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff80000010211f:	80 ff ff 
ffff800000102122:	ff d0                	callq  *%rax
  brelse(bp);
ffff800000102124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102128:	48 89 c7             	mov    %rax,%rdi
ffff80000010212b:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102132:	80 ff ff 
ffff800000102135:	ff d0                	callq  *%rax
}
ffff800000102137:	90                   	nop
ffff800000102138:	c9                   	leaveq 
ffff800000102139:	c3                   	retq   

ffff80000010213a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
ffff80000010213a:	f3 0f 1e fa          	endbr64 
ffff80000010213e:	55                   	push   %rbp
ffff80000010213f:	48 89 e5             	mov    %rsp,%rbp
ffff800000102142:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102146:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000102149:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *bp = bread(dev, bno);
ffff80000010214c:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010214f:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102152:	89 d6                	mov    %edx,%esi
ffff800000102154:	89 c7                	mov    %eax,%edi
ffff800000102156:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff80000010215d:	80 ff ff 
ffff800000102160:	ff d0                	callq  *%rax
ffff800000102162:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(bp->data, 0, BSIZE);
ffff800000102166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010216a:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102170:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000102175:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010217a:	48 89 c7             	mov    %rax,%rdi
ffff80000010217d:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff800000102184:	80 ff ff 
ffff800000102187:	ff d0                	callq  *%rax
  log_write(bp);
ffff800000102189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010218d:	48 89 c7             	mov    %rax,%rdi
ffff800000102190:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff800000102197:	80 ff ff 
ffff80000010219a:	ff d0                	callq  *%rax
  brelse(bp);
ffff80000010219c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001021a0:	48 89 c7             	mov    %rax,%rdi
ffff8000001021a3:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001021aa:	80 ff ff 
ffff8000001021ad:	ff d0                	callq  *%rax
}
ffff8000001021af:	90                   	nop
ffff8000001021b0:	c9                   	leaveq 
ffff8000001021b1:	c3                   	retq   

ffff8000001021b2 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
ffff8000001021b2:	f3 0f 1e fa          	endbr64 
ffff8000001021b6:	55                   	push   %rbp
ffff8000001021b7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001021ba:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001021be:	89 7d dc             	mov    %edi,-0x24(%rbp)
  int b, bi, m;
  struct buf *bp;
  for(b = 0; b < sb.size; b += BPB){
ffff8000001021c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001021c8:	e9 52 01 00 00       	jmpq   ffff80000010231f <balloc+0x16d>
    bp = bread(dev, BBLOCK(b, sb));
ffff8000001021cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001021d0:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
ffff8000001021d6:	85 c0                	test   %eax,%eax
ffff8000001021d8:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001021db:	c1 f8 0c             	sar    $0xc,%eax
ffff8000001021de:	89 c2                	mov    %eax,%edx
ffff8000001021e0:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff8000001021e7:	80 ff ff 
ffff8000001021ea:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001021ed:	01 c2                	add    %eax,%edx
ffff8000001021ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001021f2:	89 d6                	mov    %edx,%esi
ffff8000001021f4:	89 c7                	mov    %eax,%edi
ffff8000001021f6:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001021fd:	80 ff ff 
ffff800000102200:	ff d0                	callq  *%rax
ffff800000102202:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffff800000102206:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff80000010220d:	e9 cc 00 00 00       	jmpq   ffff8000001022de <balloc+0x12c>
      m = 1 << (bi % 8);
ffff800000102212:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102215:	99                   	cltd   
ffff800000102216:	c1 ea 1d             	shr    $0x1d,%edx
ffff800000102219:	01 d0                	add    %edx,%eax
ffff80000010221b:	83 e0 07             	and    $0x7,%eax
ffff80000010221e:	29 d0                	sub    %edx,%eax
ffff800000102220:	ba 01 00 00 00       	mov    $0x1,%edx
ffff800000102225:	89 c1                	mov    %eax,%ecx
ffff800000102227:	d3 e2                	shl    %cl,%edx
ffff800000102229:	89 d0                	mov    %edx,%eax
ffff80000010222b:	89 45 ec             	mov    %eax,-0x14(%rbp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
ffff80000010222e:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102231:	8d 50 07             	lea    0x7(%rax),%edx
ffff800000102234:	85 c0                	test   %eax,%eax
ffff800000102236:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102239:	c1 f8 03             	sar    $0x3,%eax
ffff80000010223c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102240:	48 98                	cltq   
ffff800000102242:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff800000102249:	00 
ffff80000010224a:	0f b6 c0             	movzbl %al,%eax
ffff80000010224d:	23 45 ec             	and    -0x14(%rbp),%eax
ffff800000102250:	85 c0                	test   %eax,%eax
ffff800000102252:	0f 85 82 00 00 00    	jne    ffff8000001022da <balloc+0x128>
        bp->data[bi/8] |= m;  // Mark block in use.
ffff800000102258:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010225b:	8d 50 07             	lea    0x7(%rax),%edx
ffff80000010225e:	85 c0                	test   %eax,%eax
ffff800000102260:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102263:	c1 f8 03             	sar    $0x3,%eax
ffff800000102266:	89 c1                	mov    %eax,%ecx
ffff800000102268:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010226c:	48 63 c1             	movslq %ecx,%rax
ffff80000010226f:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff800000102276:	00 
ffff800000102277:	89 c2                	mov    %eax,%edx
ffff800000102279:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010227c:	09 d0                	or     %edx,%eax
ffff80000010227e:	89 c6                	mov    %eax,%esi
ffff800000102280:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102284:	48 63 c1             	movslq %ecx,%rax
ffff800000102287:	40 88 b4 02 b0 00 00 	mov    %sil,0xb0(%rdx,%rax,1)
ffff80000010228e:	00 
        log_write(bp);
ffff80000010228f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102293:	48 89 c7             	mov    %rax,%rdi
ffff800000102296:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff80000010229d:	80 ff ff 
ffff8000001022a0:	ff d0                	callq  *%rax
        brelse(bp);
ffff8000001022a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001022a6:	48 89 c7             	mov    %rax,%rdi
ffff8000001022a9:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001022b0:	80 ff ff 
ffff8000001022b3:	ff d0                	callq  *%rax
        bzero(dev, b + bi);
ffff8000001022b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001022b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001022bb:	01 c2                	add    %eax,%edx
ffff8000001022bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001022c0:	89 d6                	mov    %edx,%esi
ffff8000001022c2:	89 c7                	mov    %eax,%edi
ffff8000001022c4:	48 b8 3a 21 10 00 00 	movabs $0xffff80000010213a,%rax
ffff8000001022cb:	80 ff ff 
ffff8000001022ce:	ff d0                	callq  *%rax
        return b + bi;
ffff8000001022d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001022d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001022d6:	01 d0                	add    %edx,%eax
ffff8000001022d8:	eb 72                	jmp    ffff80000010234c <balloc+0x19a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffff8000001022da:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff8000001022de:	81 7d f8 ff 0f 00 00 	cmpl   $0xfff,-0x8(%rbp)
ffff8000001022e5:	7f 1e                	jg     ffff800000102305 <balloc+0x153>
ffff8000001022e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001022ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001022ed:	01 d0                	add    %edx,%eax
ffff8000001022ef:	89 c2                	mov    %eax,%edx
ffff8000001022f1:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff8000001022f8:	80 ff ff 
ffff8000001022fb:	8b 00                	mov    (%rax),%eax
ffff8000001022fd:	39 c2                	cmp    %eax,%edx
ffff8000001022ff:	0f 82 0d ff ff ff    	jb     ffff800000102212 <balloc+0x60>
      }
    }
    brelse(bp);
ffff800000102305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102309:	48 89 c7             	mov    %rax,%rdi
ffff80000010230c:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102313:	80 ff ff 
ffff800000102316:	ff d0                	callq  *%rax
  for(b = 0; b < sb.size; b += BPB){
ffff800000102318:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffff80000010231f:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102326:	80 ff ff 
ffff800000102329:	8b 10                	mov    (%rax),%edx
ffff80000010232b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010232e:	39 c2                	cmp    %eax,%edx
ffff800000102330:	0f 87 97 fe ff ff    	ja     ffff8000001021cd <balloc+0x1b>
  }
  panic("balloc: out of blocks");
ffff800000102336:	48 bf 75 be 10 00 00 	movabs $0xffff80000010be75,%rdi
ffff80000010233d:	80 ff ff 
ffff800000102340:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102347:	80 ff ff 
ffff80000010234a:	ff d0                	callq  *%rax
}
ffff80000010234c:	c9                   	leaveq 
ffff80000010234d:	c3                   	retq   

ffff80000010234e <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
ffff80000010234e:	f3 0f 1e fa          	endbr64 
ffff800000102352:	55                   	push   %rbp
ffff800000102353:	48 89 e5             	mov    %rsp,%rbp
ffff800000102356:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010235a:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010235d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int bi, m;

  readsb(dev, &sb);
ffff800000102360:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102363:	48 be 00 46 11 00 00 	movabs $0xffff800000114600,%rsi
ffff80000010236a:	80 ff ff 
ffff80000010236d:	89 c7                	mov    %eax,%edi
ffff80000010236f:	48 b8 d1 20 10 00 00 	movabs $0xffff8000001020d1,%rax
ffff800000102376:	80 ff ff 
ffff800000102379:	ff d0                	callq  *%rax
  struct buf *bp = bread(dev, BBLOCK(b, sb));
ffff80000010237b:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff80000010237e:	c1 e8 0c             	shr    $0xc,%eax
ffff800000102381:	89 c2                	mov    %eax,%edx
ffff800000102383:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff80000010238a:	80 ff ff 
ffff80000010238d:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000102390:	01 c2                	add    %eax,%edx
ffff800000102392:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102395:	89 d6                	mov    %edx,%esi
ffff800000102397:	89 c7                	mov    %eax,%edi
ffff800000102399:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001023a0:	80 ff ff 
ffff8000001023a3:	ff d0                	callq  *%rax
ffff8000001023a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  bi = b % BPB;
ffff8000001023a9:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff8000001023ac:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff8000001023b1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  m = 1 << (bi % 8);
ffff8000001023b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001023b7:	99                   	cltd   
ffff8000001023b8:	c1 ea 1d             	shr    $0x1d,%edx
ffff8000001023bb:	01 d0                	add    %edx,%eax
ffff8000001023bd:	83 e0 07             	and    $0x7,%eax
ffff8000001023c0:	29 d0                	sub    %edx,%eax
ffff8000001023c2:	ba 01 00 00 00       	mov    $0x1,%edx
ffff8000001023c7:	89 c1                	mov    %eax,%ecx
ffff8000001023c9:	d3 e2                	shl    %cl,%edx
ffff8000001023cb:	89 d0                	mov    %edx,%eax
ffff8000001023cd:	89 45 f0             	mov    %eax,-0x10(%rbp)
  if((bp->data[bi/8] & m) == 0)
ffff8000001023d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001023d3:	8d 50 07             	lea    0x7(%rax),%edx
ffff8000001023d6:	85 c0                	test   %eax,%eax
ffff8000001023d8:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001023db:	c1 f8 03             	sar    $0x3,%eax
ffff8000001023de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001023e2:	48 98                	cltq   
ffff8000001023e4:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff8000001023eb:	00 
ffff8000001023ec:	0f b6 c0             	movzbl %al,%eax
ffff8000001023ef:	23 45 f0             	and    -0x10(%rbp),%eax
ffff8000001023f2:	85 c0                	test   %eax,%eax
ffff8000001023f4:	75 16                	jne    ffff80000010240c <bfree+0xbe>
    panic("freeing free block");
ffff8000001023f6:	48 bf 8b be 10 00 00 	movabs $0xffff80000010be8b,%rdi
ffff8000001023fd:	80 ff ff 
ffff800000102400:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102407:	80 ff ff 
ffff80000010240a:	ff d0                	callq  *%rax
  bp->data[bi/8] &= ~m;
ffff80000010240c:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010240f:	8d 50 07             	lea    0x7(%rax),%edx
ffff800000102412:	85 c0                	test   %eax,%eax
ffff800000102414:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102417:	c1 f8 03             	sar    $0x3,%eax
ffff80000010241a:	89 c1                	mov    %eax,%ecx
ffff80000010241c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000102420:	48 63 c1             	movslq %ecx,%rax
ffff800000102423:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff80000010242a:	00 
ffff80000010242b:	89 c2                	mov    %eax,%edx
ffff80000010242d:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102430:	f7 d0                	not    %eax
ffff800000102432:	21 d0                	and    %edx,%eax
ffff800000102434:	89 c6                	mov    %eax,%esi
ffff800000102436:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010243a:	48 63 c1             	movslq %ecx,%rax
ffff80000010243d:	40 88 b4 02 b0 00 00 	mov    %sil,0xb0(%rdx,%rax,1)
ffff800000102444:	00 
  log_write(bp);
ffff800000102445:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102449:	48 89 c7             	mov    %rax,%rdi
ffff80000010244c:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff800000102453:	80 ff ff 
ffff800000102456:	ff d0                	callq  *%rax
  brelse(bp);
ffff800000102458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010245c:	48 89 c7             	mov    %rax,%rdi
ffff80000010245f:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102466:	80 ff ff 
ffff800000102469:	ff d0                	callq  *%rax
}
ffff80000010246b:	90                   	nop
ffff80000010246c:	c9                   	leaveq 
ffff80000010246d:	c3                   	retq   

ffff80000010246e <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
ffff80000010246e:	f3 0f 1e fa          	endbr64 
ffff800000102472:	55                   	push   %rbp
ffff800000102473:	48 89 e5             	mov    %rsp,%rbp
ffff800000102476:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010247a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i = 0;
ffff80000010247d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  initlock(&icache.lock, "icache");
ffff800000102484:	48 be 9e be 10 00 00 	movabs $0xffff80000010be9e,%rsi
ffff80000010248b:	80 ff ff 
ffff80000010248e:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102495:	80 ff ff 
ffff800000102498:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff80000010249f:	80 ff ff 
ffff8000001024a2:	ff d0                	callq  *%rax
  for(i = 0; i < NINODE; i++) {
ffff8000001024a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001024ab:	eb 50                	jmp    ffff8000001024fd <iinit+0x8f>
    initsleeplock(&icache.inode[i].lock, "inode");
ffff8000001024ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001024b0:	48 63 d0             	movslq %eax,%rdx
ffff8000001024b3:	48 89 d0             	mov    %rdx,%rax
ffff8000001024b6:	48 01 c0             	add    %rax,%rax
ffff8000001024b9:	48 01 d0             	add    %rdx,%rax
ffff8000001024bc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001024c3:	00 
ffff8000001024c4:	48 01 d0             	add    %rdx,%rax
ffff8000001024c7:	48 c1 e0 03          	shl    $0x3,%rax
ffff8000001024cb:	48 8d 50 70          	lea    0x70(%rax),%rdx
ffff8000001024cf:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff8000001024d6:	80 ff ff 
ffff8000001024d9:	48 01 d0             	add    %rdx,%rax
ffff8000001024dc:	48 83 c0 08          	add    $0x8,%rax
ffff8000001024e0:	48 be a5 be 10 00 00 	movabs $0xffff80000010bea5,%rsi
ffff8000001024e7:	80 ff ff 
ffff8000001024ea:	48 89 c7             	mov    %rax,%rdi
ffff8000001024ed:	48 b8 ff 72 10 00 00 	movabs $0xffff8000001072ff,%rax
ffff8000001024f4:	80 ff ff 
ffff8000001024f7:	ff d0                	callq  *%rax
  for(i = 0; i < NINODE; i++) {
ffff8000001024f9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001024fd:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
ffff800000102501:	7e aa                	jle    ffff8000001024ad <iinit+0x3f>
  }

  readsb(dev, &sb);
ffff800000102503:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102506:	48 be 00 46 11 00 00 	movabs $0xffff800000114600,%rsi
ffff80000010250d:	80 ff ff 
ffff800000102510:	89 c7                	mov    %eax,%edi
ffff800000102512:	48 b8 d1 20 10 00 00 	movabs $0xffff8000001020d1,%rax
ffff800000102519:	80 ff ff 
ffff80000010251c:	ff d0                	callq  *%rax
  /*cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);*/
}
ffff80000010251e:	90                   	nop
ffff80000010251f:	c9                   	leaveq 
ffff800000102520:	c3                   	retq   

ffff800000102521 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
ffff800000102521:	f3 0f 1e fa          	endbr64 
ffff800000102525:	55                   	push   %rbp
ffff800000102526:	48 89 e5             	mov    %rsp,%rbp
ffff800000102529:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010252d:	89 7d dc             	mov    %edi,-0x24(%rbp)
ffff800000102530:	89 f0                	mov    %esi,%eax
ffff800000102532:	66 89 45 d8          	mov    %ax,-0x28(%rbp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
ffff800000102536:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
ffff80000010253d:	e9 d8 00 00 00       	jmpq   ffff80000010261a <ialloc+0xf9>
    bp = bread(dev, IBLOCK(inum, sb));
ffff800000102542:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102545:	48 98                	cltq   
ffff800000102547:	48 c1 e8 03          	shr    $0x3,%rax
ffff80000010254b:	89 c2                	mov    %eax,%edx
ffff80000010254d:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102554:	80 ff ff 
ffff800000102557:	8b 40 14             	mov    0x14(%rax),%eax
ffff80000010255a:	01 c2                	add    %eax,%edx
ffff80000010255c:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010255f:	89 d6                	mov    %edx,%esi
ffff800000102561:	89 c7                	mov    %eax,%edi
ffff800000102563:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff80000010256a:	80 ff ff 
ffff80000010256d:	ff d0                	callq  *%rax
ffff80000010256f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    dip = (struct dinode*)bp->data + inum%IPB;
ffff800000102573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102577:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010257e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102581:	48 98                	cltq   
ffff800000102583:	83 e0 07             	and    $0x7,%eax
ffff800000102586:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010258a:	48 01 d0             	add    %rdx,%rax
ffff80000010258d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(dip->type == 0){  // a free inode
ffff800000102591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102595:	0f b7 00             	movzwl (%rax),%eax
ffff800000102598:	66 85 c0             	test   %ax,%ax
ffff80000010259b:	75 66                	jne    ffff800000102603 <ialloc+0xe2>
      memset(dip, 0, sizeof(*dip));
ffff80000010259d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001025a1:	ba 40 00 00 00       	mov    $0x40,%edx
ffff8000001025a6:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001025ab:	48 89 c7             	mov    %rax,%rdi
ffff8000001025ae:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff8000001025b5:	80 ff ff 
ffff8000001025b8:	ff d0                	callq  *%rax
      dip->type = type;
ffff8000001025ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001025be:	0f b7 55 d8          	movzwl -0x28(%rbp),%edx
ffff8000001025c2:	66 89 10             	mov    %dx,(%rax)
      log_write(bp);   // mark it allocated on the disk
ffff8000001025c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001025c9:	48 89 c7             	mov    %rax,%rdi
ffff8000001025cc:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff8000001025d3:	80 ff ff 
ffff8000001025d6:	ff d0                	callq  *%rax
      brelse(bp);
ffff8000001025d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001025dc:	48 89 c7             	mov    %rax,%rdi
ffff8000001025df:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001025e6:	80 ff ff 
ffff8000001025e9:	ff d0                	callq  *%rax
      return iget(dev, inum);
ffff8000001025eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001025ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001025f1:	89 d6                	mov    %edx,%esi
ffff8000001025f3:	89 c7                	mov    %eax,%edi
ffff8000001025f5:	48 b8 60 27 10 00 00 	movabs $0xffff800000102760,%rax
ffff8000001025fc:	80 ff ff 
ffff8000001025ff:	ff d0                	callq  *%rax
ffff800000102601:	eb 45                	jmp    ffff800000102648 <ialloc+0x127>
    }
    brelse(bp);
ffff800000102603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102607:	48 89 c7             	mov    %rax,%rdi
ffff80000010260a:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102611:	80 ff ff 
ffff800000102614:	ff d0                	callq  *%rax
  for(inum = 1; inum < sb.ninodes; inum++){
ffff800000102616:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010261a:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102621:	80 ff ff 
ffff800000102624:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000102627:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010262a:	39 c2                	cmp    %eax,%edx
ffff80000010262c:	0f 87 10 ff ff ff    	ja     ffff800000102542 <ialloc+0x21>
  }
  panic("ialloc: no inodes");
ffff800000102632:	48 bf ab be 10 00 00 	movabs $0xffff80000010beab,%rdi
ffff800000102639:	80 ff ff 
ffff80000010263c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102643:	80 ff ff 
ffff800000102646:	ff d0                	callq  *%rax
}
ffff800000102648:	c9                   	leaveq 
ffff800000102649:	c3                   	retq   

ffff80000010264a <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
ffff80000010264a:	f3 0f 1e fa          	endbr64 
ffff80000010264e:	55                   	push   %rbp
ffff80000010264f:	48 89 e5             	mov    %rsp,%rbp
ffff800000102652:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102656:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
ffff80000010265a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010265e:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102661:	c1 e8 03             	shr    $0x3,%eax
ffff800000102664:	89 c2                	mov    %eax,%edx
ffff800000102666:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff80000010266d:	80 ff ff 
ffff800000102670:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000102673:	01 c2                	add    %eax,%edx
ffff800000102675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102679:	8b 00                	mov    (%rax),%eax
ffff80000010267b:	89 d6                	mov    %edx,%esi
ffff80000010267d:	89 c7                	mov    %eax,%edi
ffff80000010267f:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102686:	80 ff ff 
ffff800000102689:	ff d0                	callq  *%rax
ffff80000010268b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
ffff80000010268f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102693:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010269a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010269e:	8b 40 04             	mov    0x4(%rax),%eax
ffff8000001026a1:	89 c0                	mov    %eax,%eax
ffff8000001026a3:	83 e0 07             	and    $0x7,%eax
ffff8000001026a6:	48 c1 e0 06          	shl    $0x6,%rax
ffff8000001026aa:	48 01 d0             	add    %rdx,%rax
ffff8000001026ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  dip->type = ip->type;
ffff8000001026b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026b5:	0f b7 90 94 00 00 00 	movzwl 0x94(%rax),%edx
ffff8000001026bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026c0:	66 89 10             	mov    %dx,(%rax)
  dip->major = ip->major;
ffff8000001026c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026c7:	0f b7 90 96 00 00 00 	movzwl 0x96(%rax),%edx
ffff8000001026ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026d2:	66 89 50 02          	mov    %dx,0x2(%rax)
  dip->minor = ip->minor;
ffff8000001026d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026da:	0f b7 90 98 00 00 00 	movzwl 0x98(%rax),%edx
ffff8000001026e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026e5:	66 89 50 04          	mov    %dx,0x4(%rax)
  dip->nlink = ip->nlink;
ffff8000001026e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026ed:	0f b7 90 9a 00 00 00 	movzwl 0x9a(%rax),%edx
ffff8000001026f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026f8:	66 89 50 06          	mov    %dx,0x6(%rax)
  dip->size = ip->size;
ffff8000001026fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102700:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff800000102706:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010270a:	89 50 08             	mov    %edx,0x8(%rax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
ffff80000010270d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102711:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffff800000102718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010271c:	48 83 c0 0c          	add    $0xc,%rax
ffff800000102720:	ba 34 00 00 00       	mov    $0x34,%edx
ffff800000102725:	48 89 ce             	mov    %rcx,%rsi
ffff800000102728:	48 89 c7             	mov    %rax,%rdi
ffff80000010272b:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff800000102732:	80 ff ff 
ffff800000102735:	ff d0                	callq  *%rax
  log_write(bp);
ffff800000102737:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010273b:	48 89 c7             	mov    %rax,%rdi
ffff80000010273e:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff800000102745:	80 ff ff 
ffff800000102748:	ff d0                	callq  *%rax
  brelse(bp);
ffff80000010274a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010274e:	48 89 c7             	mov    %rax,%rdi
ffff800000102751:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102758:	80 ff ff 
ffff80000010275b:	ff d0                	callq  *%rax
}
ffff80000010275d:	90                   	nop
ffff80000010275e:	c9                   	leaveq 
ffff80000010275f:	c3                   	retq   

ffff800000102760 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
ffff800000102760:	f3 0f 1e fa          	endbr64 
ffff800000102764:	55                   	push   %rbp
ffff800000102765:	48 89 e5             	mov    %rsp,%rbp
ffff800000102768:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010276c:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010276f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
ffff800000102772:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102779:	80 ff ff 
ffff80000010277c:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000102783:	80 ff ff 
ffff800000102786:	ff d0                	callq  *%rax

  // Is the inode already cached?
  empty = 0;
ffff800000102788:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffff80000010278f:	00 
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffff800000102790:	48 b8 88 46 11 00 00 	movabs $0xffff800000114688,%rax
ffff800000102797:	80 ff ff 
ffff80000010279a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010279e:	eb 74                	jmp    ffff800000102814 <iget+0xb4>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
ffff8000001027a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027a4:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001027a7:	85 c0                	test   %eax,%eax
ffff8000001027a9:	7e 47                	jle    ffff8000001027f2 <iget+0x92>
ffff8000001027ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027af:	8b 00                	mov    (%rax),%eax
ffff8000001027b1:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff8000001027b4:	75 3c                	jne    ffff8000001027f2 <iget+0x92>
ffff8000001027b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027ba:	8b 40 04             	mov    0x4(%rax),%eax
ffff8000001027bd:	39 45 e8             	cmp    %eax,-0x18(%rbp)
ffff8000001027c0:	75 30                	jne    ffff8000001027f2 <iget+0x92>
      ip->ref++;
ffff8000001027c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027c6:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001027c9:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001027cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027d0:	89 50 08             	mov    %edx,0x8(%rax)
      release(&icache.lock);
ffff8000001027d3:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff8000001027da:	80 ff ff 
ffff8000001027dd:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001027e4:	80 ff ff 
ffff8000001027e7:	ff d0                	callq  *%rax
      return ip;
ffff8000001027e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027ed:	e9 a1 00 00 00       	jmpq   ffff800000102893 <iget+0x133>
    }
    if(empty == 0 && ip->ref == 0) // Remember empty slot.
ffff8000001027f2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001027f7:	75 13                	jne    ffff80000010280c <iget+0xac>
ffff8000001027f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027fd:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102800:	85 c0                	test   %eax,%eax
ffff800000102802:	75 08                	jne    ffff80000010280c <iget+0xac>
      empty = ip;
ffff800000102804:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102808:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffff80000010280c:	48 81 45 f8 d8 00 00 	addq   $0xd8,-0x8(%rbp)
ffff800000102813:	00 
ffff800000102814:	48 b8 b8 70 11 00 00 	movabs $0xffff8000001170b8,%rax
ffff80000010281b:	80 ff ff 
ffff80000010281e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000102822:	0f 82 78 ff ff ff    	jb     ffff8000001027a0 <iget+0x40>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
ffff800000102828:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010282d:	75 16                	jne    ffff800000102845 <iget+0xe5>
    panic("iget: no inodes");
ffff80000010282f:	48 bf bd be 10 00 00 	movabs $0xffff80000010bebd,%rdi
ffff800000102836:	80 ff ff 
ffff800000102839:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102840:	80 ff ff 
ffff800000102843:	ff d0                	callq  *%rax

  ip = empty;
ffff800000102845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102849:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ip->dev = dev;
ffff80000010284d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102851:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000102854:	89 10                	mov    %edx,(%rax)
  ip->inum = inum;
ffff800000102856:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010285a:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010285d:	89 50 04             	mov    %edx,0x4(%rax)
  ip->ref = 1;
ffff800000102860:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102864:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
  ip->flags = 0;
ffff80000010286b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010286f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%rax)
ffff800000102876:	00 00 00 
  release(&icache.lock);
ffff800000102879:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102880:	80 ff ff 
ffff800000102883:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010288a:	80 ff ff 
ffff80000010288d:	ff d0                	callq  *%rax

  return ip;
ffff80000010288f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000102893:	c9                   	leaveq 
ffff800000102894:	c3                   	retq   

ffff800000102895 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
ffff800000102895:	f3 0f 1e fa          	endbr64 
ffff800000102899:	55                   	push   %rbp
ffff80000010289a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010289d:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001028a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffff8000001028a5:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff8000001028ac:	80 ff ff 
ffff8000001028af:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff8000001028b6:	80 ff ff 
ffff8000001028b9:	ff d0                	callq  *%rax
  ip->ref++;
ffff8000001028bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001028bf:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001028c2:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001028c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001028c9:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffff8000001028cc:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff8000001028d3:	80 ff ff 
ffff8000001028d6:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001028dd:	80 ff ff 
ffff8000001028e0:	ff d0                	callq  *%rax
  return ip;
ffff8000001028e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001028e6:	c9                   	leaveq 
ffff8000001028e7:	c3                   	retq   

ffff8000001028e8 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
ffff8000001028e8:	f3 0f 1e fa          	endbr64 
ffff8000001028ec:	55                   	push   %rbp
ffff8000001028ed:	48 89 e5             	mov    %rsp,%rbp
ffff8000001028f0:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001028f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
ffff8000001028f8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001028fd:	74 0b                	je     ffff80000010290a <ilock+0x22>
ffff8000001028ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102903:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102906:	85 c0                	test   %eax,%eax
ffff800000102908:	7f 16                	jg     ffff800000102920 <ilock+0x38>
    panic("ilock");
ffff80000010290a:	48 bf cd be 10 00 00 	movabs $0xffff80000010becd,%rdi
ffff800000102911:	80 ff ff 
ffff800000102914:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010291b:	80 ff ff 
ffff80000010291e:	ff d0                	callq  *%rax

  acquiresleep(&ip->lock);
ffff800000102920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102924:	48 83 c0 10          	add    $0x10,%rax
ffff800000102928:	48 89 c7             	mov    %rax,%rdi
ffff80000010292b:	48 b8 58 73 10 00 00 	movabs $0xffff800000107358,%rax
ffff800000102932:	80 ff ff 
ffff800000102935:	ff d0                	callq  *%rax

  if(!(ip->flags & I_VALID)){
ffff800000102937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010293b:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102941:	83 e0 02             	and    $0x2,%eax
ffff800000102944:	85 c0                	test   %eax,%eax
ffff800000102946:	0f 85 2e 01 00 00    	jne    ffff800000102a7a <ilock+0x192>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
ffff80000010294c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102950:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102953:	c1 e8 03             	shr    $0x3,%eax
ffff800000102956:	89 c2                	mov    %eax,%edx
ffff800000102958:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff80000010295f:	80 ff ff 
ffff800000102962:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000102965:	01 c2                	add    %eax,%edx
ffff800000102967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010296b:	8b 00                	mov    (%rax),%eax
ffff80000010296d:	89 d6                	mov    %edx,%esi
ffff80000010296f:	89 c7                	mov    %eax,%edi
ffff800000102971:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102978:	80 ff ff 
ffff80000010297b:	ff d0                	callq  *%rax
ffff80000010297d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
ffff800000102981:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102985:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010298c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102990:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102993:	89 c0                	mov    %eax,%eax
ffff800000102995:	83 e0 07             	and    $0x7,%eax
ffff800000102998:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010299c:	48 01 d0             	add    %rdx,%rax
ffff80000010299f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    ip->type = dip->type;
ffff8000001029a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029a7:	0f b7 10             	movzwl (%rax),%edx
ffff8000001029aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029ae:	66 89 90 94 00 00 00 	mov    %dx,0x94(%rax)
    ip->major = dip->major;
ffff8000001029b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029b9:	0f b7 50 02          	movzwl 0x2(%rax),%edx
ffff8000001029bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029c1:	66 89 90 96 00 00 00 	mov    %dx,0x96(%rax)
    ip->minor = dip->minor;
ffff8000001029c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029cc:	0f b7 50 04          	movzwl 0x4(%rax),%edx
ffff8000001029d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029d4:	66 89 90 98 00 00 00 	mov    %dx,0x98(%rax)
    ip->nlink = dip->nlink;
ffff8000001029db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029df:	0f b7 50 06          	movzwl 0x6(%rax),%edx
ffff8000001029e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029e7:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    ip->size = dip->size;
ffff8000001029ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029f2:	8b 50 08             	mov    0x8(%rax),%edx
ffff8000001029f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029f9:	89 90 9c 00 00 00    	mov    %edx,0x9c(%rax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
ffff8000001029ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102a03:	48 8d 48 0c          	lea    0xc(%rax),%rcx
ffff800000102a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a0b:	48 05 a0 00 00 00    	add    $0xa0,%rax
ffff800000102a11:	ba 34 00 00 00       	mov    $0x34,%edx
ffff800000102a16:	48 89 ce             	mov    %rcx,%rsi
ffff800000102a19:	48 89 c7             	mov    %rax,%rdi
ffff800000102a1c:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff800000102a23:	80 ff ff 
ffff800000102a26:	ff d0                	callq  *%rax
    brelse(bp);
ffff800000102a28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102a2c:	48 89 c7             	mov    %rax,%rdi
ffff800000102a2f:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102a36:	80 ff ff 
ffff800000102a39:	ff d0                	callq  *%rax
    ip->flags |= I_VALID;
ffff800000102a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a3f:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102a45:	83 c8 02             	or     $0x2,%eax
ffff800000102a48:	89 c2                	mov    %eax,%edx
ffff800000102a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a4e:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
    if(ip->type == 0)
ffff800000102a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102a58:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000102a5f:	66 85 c0             	test   %ax,%ax
ffff800000102a62:	75 16                	jne    ffff800000102a7a <ilock+0x192>
      panic("ilock: no type");
ffff800000102a64:	48 bf d3 be 10 00 00 	movabs $0xffff80000010bed3,%rdi
ffff800000102a6b:	80 ff ff 
ffff800000102a6e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102a75:	80 ff ff 
ffff800000102a78:	ff d0                	callq  *%rax
  }
}
ffff800000102a7a:	90                   	nop
ffff800000102a7b:	c9                   	leaveq 
ffff800000102a7c:	c3                   	retq   

ffff800000102a7d <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
ffff800000102a7d:	f3 0f 1e fa          	endbr64 
ffff800000102a81:	55                   	push   %rbp
ffff800000102a82:	48 89 e5             	mov    %rsp,%rbp
ffff800000102a85:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102a89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
ffff800000102a8d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000102a92:	74 26                	je     ffff800000102aba <iunlock+0x3d>
ffff800000102a94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102a98:	48 83 c0 10          	add    $0x10,%rax
ffff800000102a9c:	48 89 c7             	mov    %rax,%rdi
ffff800000102a9f:	48 b8 4b 74 10 00 00 	movabs $0xffff80000010744b,%rax
ffff800000102aa6:	80 ff ff 
ffff800000102aa9:	ff d0                	callq  *%rax
ffff800000102aab:	85 c0                	test   %eax,%eax
ffff800000102aad:	74 0b                	je     ffff800000102aba <iunlock+0x3d>
ffff800000102aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ab3:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102ab6:	85 c0                	test   %eax,%eax
ffff800000102ab8:	7f 16                	jg     ffff800000102ad0 <iunlock+0x53>
    panic("iunlock");
ffff800000102aba:	48 bf e2 be 10 00 00 	movabs $0xffff80000010bee2,%rdi
ffff800000102ac1:	80 ff ff 
ffff800000102ac4:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102acb:	80 ff ff 
ffff800000102ace:	ff d0                	callq  *%rax

  releasesleep(&ip->lock);
ffff800000102ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ad4:	48 83 c0 10          	add    $0x10,%rax
ffff800000102ad8:	48 89 c7             	mov    %rax,%rdi
ffff800000102adb:	48 b8 e2 73 10 00 00 	movabs $0xffff8000001073e2,%rax
ffff800000102ae2:	80 ff ff 
ffff800000102ae5:	ff d0                	callq  *%rax
}
ffff800000102ae7:	90                   	nop
ffff800000102ae8:	c9                   	leaveq 
ffff800000102ae9:	c3                   	retq   

ffff800000102aea <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
ffff800000102aea:	f3 0f 1e fa          	endbr64 
ffff800000102aee:	55                   	push   %rbp
ffff800000102aef:	48 89 e5             	mov    %rsp,%rbp
ffff800000102af2:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102af6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffff800000102afa:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102b01:	80 ff ff 
ffff800000102b04:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000102b0b:	80 ff ff 
ffff800000102b0e:	ff d0                	callq  *%rax
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
ffff800000102b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b14:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102b17:	83 f8 01             	cmp    $0x1,%eax
ffff800000102b1a:	0f 85 8e 00 00 00    	jne    ffff800000102bae <iput+0xc4>
ffff800000102b20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b24:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102b2a:	83 e0 02             	and    $0x2,%eax
ffff800000102b2d:	85 c0                	test   %eax,%eax
ffff800000102b2f:	74 7d                	je     ffff800000102bae <iput+0xc4>
ffff800000102b31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b35:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000102b3c:	66 85 c0             	test   %ax,%ax
ffff800000102b3f:	75 6d                	jne    ffff800000102bae <iput+0xc4>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
ffff800000102b41:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102b48:	80 ff ff 
ffff800000102b4b:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000102b52:	80 ff ff 
ffff800000102b55:	ff d0                	callq  *%rax
    itrunc(ip);
ffff800000102b57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b5b:	48 89 c7             	mov    %rax,%rdi
ffff800000102b5e:	48 b8 6f 2d 10 00 00 	movabs $0xffff800000102d6f,%rax
ffff800000102b65:	80 ff ff 
ffff800000102b68:	ff d0                	callq  *%rax
    ip->type = 0;
ffff800000102b6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b6e:	66 c7 80 94 00 00 00 	movw   $0x0,0x94(%rax)
ffff800000102b75:	00 00 
    iupdate(ip);
ffff800000102b77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b7b:	48 89 c7             	mov    %rax,%rdi
ffff800000102b7e:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000102b85:	80 ff ff 
ffff800000102b88:	ff d0                	callq  *%rax
    acquire(&icache.lock);
ffff800000102b8a:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102b91:	80 ff ff 
ffff800000102b94:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000102b9b:	80 ff ff 
ffff800000102b9e:	ff d0                	callq  *%rax
    ip->flags = 0;
ffff800000102ba0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ba4:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%rax)
ffff800000102bab:	00 00 00 
  }
  ip->ref--;
ffff800000102bae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bb2:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102bb5:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000102bb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bbc:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffff800000102bbf:	48 bf 20 46 11 00 00 	movabs $0xffff800000114620,%rdi
ffff800000102bc6:	80 ff ff 
ffff800000102bc9:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000102bd0:	80 ff ff 
ffff800000102bd3:	ff d0                	callq  *%rax
}
ffff800000102bd5:	90                   	nop
ffff800000102bd6:	c9                   	leaveq 
ffff800000102bd7:	c3                   	retq   

ffff800000102bd8 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
ffff800000102bd8:	f3 0f 1e fa          	endbr64 
ffff800000102bdc:	55                   	push   %rbp
ffff800000102bdd:	48 89 e5             	mov    %rsp,%rbp
ffff800000102be0:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102be4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  iunlock(ip);
ffff800000102be8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bec:	48 89 c7             	mov    %rax,%rdi
ffff800000102bef:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000102bf6:	80 ff ff 
ffff800000102bf9:	ff d0                	callq  *%rax
  iput(ip);
ffff800000102bfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bff:	48 89 c7             	mov    %rax,%rdi
ffff800000102c02:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000102c09:	80 ff ff 
ffff800000102c0c:	ff d0                	callq  *%rax
}
ffff800000102c0e:	90                   	nop
ffff800000102c0f:	c9                   	leaveq 
ffff800000102c10:	c3                   	retq   

ffff800000102c11 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
ffff800000102c11:	f3 0f 1e fa          	endbr64 
ffff800000102c15:	55                   	push   %rbp
ffff800000102c16:	48 89 e5             	mov    %rsp,%rbp
ffff800000102c19:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102c1d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000102c21:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
ffff800000102c24:	83 7d d4 0b          	cmpl   $0xb,-0x2c(%rbp)
ffff800000102c28:	77 47                	ja     ffff800000102c71 <bmap+0x60>
    if((addr = ip->addrs[bn]) == 0)
ffff800000102c2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c2e:	8b 55 d4             	mov    -0x2c(%rbp),%edx
ffff800000102c31:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102c35:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102c38:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102c3f:	75 28                	jne    ffff800000102c69 <bmap+0x58>
      ip->addrs[bn] = addr = balloc(ip->dev);
ffff800000102c41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c45:	8b 00                	mov    (%rax),%eax
ffff800000102c47:	89 c7                	mov    %eax,%edi
ffff800000102c49:	48 b8 b2 21 10 00 00 	movabs $0xffff8000001021b2,%rax
ffff800000102c50:	80 ff ff 
ffff800000102c53:	ff d0                	callq  *%rax
ffff800000102c55:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c5c:	8b 55 d4             	mov    -0x2c(%rbp),%edx
ffff800000102c5f:	48 8d 4a 28          	lea    0x28(%rdx),%rcx
ffff800000102c63:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102c66:	89 14 88             	mov    %edx,(%rax,%rcx,4)
    return addr;
ffff800000102c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102c6c:	e9 fc 00 00 00       	jmpq   ffff800000102d6d <bmap+0x15c>
  }
  bn -= NDIRECT;
ffff800000102c71:	83 6d d4 0c          	subl   $0xc,-0x2c(%rbp)

  if(bn < NINDIRECT){
ffff800000102c75:	83 7d d4 7f          	cmpl   $0x7f,-0x2c(%rbp)
ffff800000102c79:	0f 87 d8 00 00 00    	ja     ffff800000102d57 <bmap+0x146>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
ffff800000102c7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c83:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102c89:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102c90:	75 24                	jne    ffff800000102cb6 <bmap+0xa5>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
ffff800000102c92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c96:	8b 00                	mov    (%rax),%eax
ffff800000102c98:	89 c7                	mov    %eax,%edi
ffff800000102c9a:	48 b8 b2 21 10 00 00 	movabs $0xffff8000001021b2,%rax
ffff800000102ca1:	80 ff ff 
ffff800000102ca4:	ff d0                	callq  *%rax
ffff800000102ca6:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102ca9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102cad:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102cb0:	89 90 d0 00 00 00    	mov    %edx,0xd0(%rax)
    bp = bread(ip->dev, addr);
ffff800000102cb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102cba:	8b 00                	mov    (%rax),%eax
ffff800000102cbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102cbf:	89 d6                	mov    %edx,%esi
ffff800000102cc1:	89 c7                	mov    %eax,%edi
ffff800000102cc3:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102cca:	80 ff ff 
ffff800000102ccd:	ff d0                	callq  *%rax
ffff800000102ccf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffff800000102cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102cd7:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102cdd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if((addr = a[bn]) == 0){
ffff800000102ce1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000102ce4:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102ceb:	00 
ffff800000102cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102cf0:	48 01 d0             	add    %rdx,%rax
ffff800000102cf3:	8b 00                	mov    (%rax),%eax
ffff800000102cf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102cf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102cfc:	75 41                	jne    ffff800000102d3f <bmap+0x12e>
      a[bn] = addr = balloc(ip->dev);
ffff800000102cfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d02:	8b 00                	mov    (%rax),%eax
ffff800000102d04:	89 c7                	mov    %eax,%edi
ffff800000102d06:	48 b8 b2 21 10 00 00 	movabs $0xffff8000001021b2,%rax
ffff800000102d0d:	80 ff ff 
ffff800000102d10:	ff d0                	callq  *%rax
ffff800000102d12:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102d15:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000102d18:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102d1f:	00 
ffff800000102d20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102d24:	48 01 c2             	add    %rax,%rdx
ffff800000102d27:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102d2a:	89 02                	mov    %eax,(%rdx)
      log_write(bp);
ffff800000102d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102d30:	48 89 c7             	mov    %rax,%rdi
ffff800000102d33:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff800000102d3a:	80 ff ff 
ffff800000102d3d:	ff d0                	callq  *%rax
    }
    brelse(bp);
ffff800000102d3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102d43:	48 89 c7             	mov    %rax,%rdi
ffff800000102d46:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102d4d:	80 ff ff 
ffff800000102d50:	ff d0                	callq  *%rax
    return addr;
ffff800000102d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102d55:	eb 16                	jmp    ffff800000102d6d <bmap+0x15c>
  }

  panic("bmap: out of range");
ffff800000102d57:	48 bf ea be 10 00 00 	movabs $0xffff80000010beea,%rdi
ffff800000102d5e:	80 ff ff 
ffff800000102d61:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000102d68:	80 ff ff 
ffff800000102d6b:	ff d0                	callq  *%rax
}
ffff800000102d6d:	c9                   	leaveq 
ffff800000102d6e:	c3                   	retq   

ffff800000102d6f <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
ffff800000102d6f:	f3 0f 1e fa          	endbr64 
ffff800000102d73:	55                   	push   %rbp
ffff800000102d74:	48 89 e5             	mov    %rsp,%rbp
ffff800000102d77:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102d7b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
ffff800000102d7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000102d86:	eb 55                	jmp    ffff800000102ddd <itrunc+0x6e>
    if(ip->addrs[i]){
ffff800000102d88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d8c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102d8f:	48 63 d2             	movslq %edx,%rdx
ffff800000102d92:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102d96:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102d99:	85 c0                	test   %eax,%eax
ffff800000102d9b:	74 3c                	je     ffff800000102dd9 <itrunc+0x6a>
      bfree(ip->dev, ip->addrs[i]);
ffff800000102d9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102da1:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102da4:	48 63 d2             	movslq %edx,%rdx
ffff800000102da7:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102dab:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102dae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102db2:	8b 12                	mov    (%rdx),%edx
ffff800000102db4:	89 c6                	mov    %eax,%esi
ffff800000102db6:	89 d7                	mov    %edx,%edi
ffff800000102db8:	48 b8 4e 23 10 00 00 	movabs $0xffff80000010234e,%rax
ffff800000102dbf:	80 ff ff 
ffff800000102dc2:	ff d0                	callq  *%rax
      ip->addrs[i] = 0;
ffff800000102dc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102dc8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102dcb:	48 63 d2             	movslq %edx,%rdx
ffff800000102dce:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102dd2:	c7 04 90 00 00 00 00 	movl   $0x0,(%rax,%rdx,4)
  for(i = 0; i < NDIRECT; i++){
ffff800000102dd9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000102ddd:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
ffff800000102de1:	7e a5                	jle    ffff800000102d88 <itrunc+0x19>
    }
  }

  if(ip->addrs[NDIRECT]){
ffff800000102de3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102de7:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102ded:	85 c0                	test   %eax,%eax
ffff800000102def:	0f 84 ce 00 00 00    	je     ffff800000102ec3 <itrunc+0x154>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
ffff800000102df5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102df9:	8b 90 d0 00 00 00    	mov    0xd0(%rax),%edx
ffff800000102dff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e03:	8b 00                	mov    (%rax),%eax
ffff800000102e05:	89 d6                	mov    %edx,%esi
ffff800000102e07:	89 c7                	mov    %eax,%edi
ffff800000102e09:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000102e10:	80 ff ff 
ffff800000102e13:	ff d0                	callq  *%rax
ffff800000102e15:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffff800000102e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102e1d:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102e23:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for(j = 0; j < NINDIRECT; j++){
ffff800000102e27:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff800000102e2e:	eb 4a                	jmp    ffff800000102e7a <itrunc+0x10b>
      if(a[j])
ffff800000102e30:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102e33:	48 98                	cltq   
ffff800000102e35:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102e3c:	00 
ffff800000102e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102e41:	48 01 d0             	add    %rdx,%rax
ffff800000102e44:	8b 00                	mov    (%rax),%eax
ffff800000102e46:	85 c0                	test   %eax,%eax
ffff800000102e48:	74 2c                	je     ffff800000102e76 <itrunc+0x107>
        bfree(ip->dev, a[j]);
ffff800000102e4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102e4d:	48 98                	cltq   
ffff800000102e4f:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102e56:	00 
ffff800000102e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102e5b:	48 01 d0             	add    %rdx,%rax
ffff800000102e5e:	8b 00                	mov    (%rax),%eax
ffff800000102e60:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102e64:	8b 12                	mov    (%rdx),%edx
ffff800000102e66:	89 c6                	mov    %eax,%esi
ffff800000102e68:	89 d7                	mov    %edx,%edi
ffff800000102e6a:	48 b8 4e 23 10 00 00 	movabs $0xffff80000010234e,%rax
ffff800000102e71:	80 ff ff 
ffff800000102e74:	ff d0                	callq  *%rax
    for(j = 0; j < NINDIRECT; j++){
ffff800000102e76:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff800000102e7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102e7d:	83 f8 7f             	cmp    $0x7f,%eax
ffff800000102e80:	76 ae                	jbe    ffff800000102e30 <itrunc+0xc1>
    }
    brelse(bp);
ffff800000102e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102e86:	48 89 c7             	mov    %rax,%rdi
ffff800000102e89:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000102e90:	80 ff ff 
ffff800000102e93:	ff d0                	callq  *%rax
    bfree(ip->dev, ip->addrs[NDIRECT]);
ffff800000102e95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e99:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102e9f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102ea3:	8b 12                	mov    (%rdx),%edx
ffff800000102ea5:	89 c6                	mov    %eax,%esi
ffff800000102ea7:	89 d7                	mov    %edx,%edi
ffff800000102ea9:	48 b8 4e 23 10 00 00 	movabs $0xffff80000010234e,%rax
ffff800000102eb0:	80 ff ff 
ffff800000102eb3:	ff d0                	callq  *%rax
    ip->addrs[NDIRECT] = 0;
ffff800000102eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102eb9:	c7 80 d0 00 00 00 00 	movl   $0x0,0xd0(%rax)
ffff800000102ec0:	00 00 00 
  }

  ip->size = 0;
ffff800000102ec3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102ec7:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%rax)
ffff800000102ece:	00 00 00 
  iupdate(ip);
ffff800000102ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102ed5:	48 89 c7             	mov    %rax,%rdi
ffff800000102ed8:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000102edf:	80 ff ff 
ffff800000102ee2:	ff d0                	callq  *%rax
}
ffff800000102ee4:	90                   	nop
ffff800000102ee5:	c9                   	leaveq 
ffff800000102ee6:	c3                   	retq   

ffff800000102ee7 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
ffff800000102ee7:	f3 0f 1e fa          	endbr64 
ffff800000102eeb:	55                   	push   %rbp
ffff800000102eec:	48 89 e5             	mov    %rsp,%rbp
ffff800000102eef:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102ef3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000102ef7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  st->dev = ip->dev;
ffff800000102efb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102eff:	8b 00                	mov    (%rax),%eax
ffff800000102f01:	89 c2                	mov    %eax,%edx
ffff800000102f03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f07:	89 50 04             	mov    %edx,0x4(%rax)
  st->ino = ip->inum;
ffff800000102f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f0e:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000102f11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f15:	89 50 08             	mov    %edx,0x8(%rax)
  st->type = ip->type;
ffff800000102f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f1c:	0f b7 90 94 00 00 00 	movzwl 0x94(%rax),%edx
ffff800000102f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f27:	66 89 10             	mov    %dx,(%rax)
  st->nlink = ip->nlink;
ffff800000102f2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f2e:	0f b7 90 9a 00 00 00 	movzwl 0x9a(%rax),%edx
ffff800000102f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f39:	66 89 50 0c          	mov    %dx,0xc(%rax)
  st->size = ip->size;
ffff800000102f3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102f41:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff800000102f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102f4b:	89 50 10             	mov    %edx,0x10(%rax)
}
ffff800000102f4e:	90                   	nop
ffff800000102f4f:	c9                   	leaveq 
ffff800000102f50:	c3                   	retq   

ffff800000102f51 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
ffff800000102f51:	f3 0f 1e fa          	endbr64 
ffff800000102f55:	55                   	push   %rbp
ffff800000102f56:	48 89 e5             	mov    %rsp,%rbp
ffff800000102f59:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000102f5d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000102f61:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000102f65:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffff800000102f68:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffff800000102f6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f6f:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000102f76:	66 83 f8 03          	cmp    $0x3,%ax
ffff800000102f7a:	0f 85 8d 00 00 00    	jne    ffff80000010300d <readi+0xbc>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
ffff800000102f80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f84:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102f8b:	66 85 c0             	test   %ax,%ax
ffff800000102f8e:	78 38                	js     ffff800000102fc8 <readi+0x77>
ffff800000102f90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f94:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102f9b:	66 83 f8 09          	cmp    $0x9,%ax
ffff800000102f9f:	7f 27                	jg     ffff800000102fc8 <readi+0x77>
ffff800000102fa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fa5:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102fac:	98                   	cwtl   
ffff800000102fad:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000102fb4:	80 ff ff 
ffff800000102fb7:	48 98                	cltq   
ffff800000102fb9:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000102fbd:	48 01 d0             	add    %rdx,%rax
ffff800000102fc0:	48 8b 00             	mov    (%rax),%rax
ffff800000102fc3:	48 85 c0             	test   %rax,%rax
ffff800000102fc6:	75 0a                	jne    ffff800000102fd2 <readi+0x81>
      return -1;
ffff800000102fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000102fcd:	e9 4e 01 00 00       	jmpq   ffff800000103120 <readi+0x1cf>
    return devsw[ip->major].read(ip, off, dst, n);
ffff800000102fd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fd6:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102fdd:	98                   	cwtl   
ffff800000102fde:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000102fe5:	80 ff ff 
ffff800000102fe8:	48 98                	cltq   
ffff800000102fea:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000102fee:	48 01 d0             	add    %rdx,%rax
ffff800000102ff1:	4c 8b 00             	mov    (%rax),%r8
ffff800000102ff4:	8b 4d c8             	mov    -0x38(%rbp),%ecx
ffff800000102ff7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000102ffb:	8b 75 cc             	mov    -0x34(%rbp),%esi
ffff800000102ffe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103002:	48 89 c7             	mov    %rax,%rdi
ffff800000103005:	41 ff d0             	callq  *%r8
ffff800000103008:	e9 13 01 00 00       	jmpq   ffff800000103120 <readi+0x1cf>
  }

  if(off > ip->size || off + n < off)
ffff80000010300d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103011:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000103017:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff80000010301a:	77 0d                	ja     ffff800000103029 <readi+0xd8>
ffff80000010301c:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff80000010301f:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103022:	01 d0                	add    %edx,%eax
ffff800000103024:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff800000103027:	76 0a                	jbe    ffff800000103033 <readi+0xe2>
    return -1;
ffff800000103029:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010302e:	e9 ed 00 00 00       	jmpq   ffff800000103120 <readi+0x1cf>
  if(off + n > ip->size)
ffff800000103033:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff800000103036:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103039:	01 c2                	add    %eax,%edx
ffff80000010303b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010303f:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000103045:	39 c2                	cmp    %eax,%edx
ffff800000103047:	76 10                	jbe    ffff800000103059 <readi+0x108>
    n = ip->size - off;
ffff800000103049:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010304d:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000103053:	2b 45 cc             	sub    -0x34(%rbp),%eax
ffff800000103056:	89 45 c8             	mov    %eax,-0x38(%rbp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffff800000103059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103060:	e9 ac 00 00 00       	jmpq   ffff800000103111 <readi+0x1c0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffff800000103065:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103068:	c1 e8 09             	shr    $0x9,%eax
ffff80000010306b:	89 c2                	mov    %eax,%edx
ffff80000010306d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103071:	89 d6                	mov    %edx,%esi
ffff800000103073:	48 89 c7             	mov    %rax,%rdi
ffff800000103076:	48 b8 11 2c 10 00 00 	movabs $0xffff800000102c11,%rax
ffff80000010307d:	80 ff ff 
ffff800000103080:	ff d0                	callq  *%rax
ffff800000103082:	89 c2                	mov    %eax,%edx
ffff800000103084:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103088:	8b 00                	mov    (%rax),%eax
ffff80000010308a:	89 d6                	mov    %edx,%esi
ffff80000010308c:	89 c7                	mov    %eax,%edi
ffff80000010308e:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000103095:	80 ff ff 
ffff800000103098:	ff d0                	callq  *%rax
ffff80000010309a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffff80000010309e:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff8000001030a1:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff8000001030a6:	ba 00 02 00 00       	mov    $0x200,%edx
ffff8000001030ab:	29 c2                	sub    %eax,%edx
ffff8000001030ad:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff8000001030b0:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff8000001030b3:	39 c2                	cmp    %eax,%edx
ffff8000001030b5:	0f 46 c2             	cmovbe %edx,%eax
ffff8000001030b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(dst, bp->data + off%BSIZE, m);
ffff8000001030bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001030bf:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff8000001030c6:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff8000001030c9:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff8000001030ce:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff8000001030d2:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001030d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001030d9:	48 89 ce             	mov    %rcx,%rsi
ffff8000001030dc:	48 89 c7             	mov    %rax,%rdi
ffff8000001030df:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff8000001030e6:	80 ff ff 
ffff8000001030e9:	ff d0                	callq  *%rax
    brelse(bp);
ffff8000001030eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001030ef:	48 89 c7             	mov    %rax,%rdi
ffff8000001030f2:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001030f9:	80 ff ff 
ffff8000001030fc:	ff d0                	callq  *%rax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffff8000001030fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000103101:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff800000103104:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000103107:	01 45 cc             	add    %eax,-0x34(%rbp)
ffff80000010310a:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010310d:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffff800000103111:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103114:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffff800000103117:	0f 82 48 ff ff ff    	jb     ffff800000103065 <readi+0x114>
  }
  return n;
ffff80000010311d:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffff800000103120:	c9                   	leaveq 
ffff800000103121:	c3                   	retq   

ffff800000103122 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
ffff800000103122:	f3 0f 1e fa          	endbr64 
ffff800000103126:	55                   	push   %rbp
ffff800000103127:	48 89 e5             	mov    %rsp,%rbp
ffff80000010312a:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010312e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000103132:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000103136:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffff800000103139:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffff80000010313c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103140:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000103147:	66 83 f8 03          	cmp    $0x3,%ax
ffff80000010314b:	0f 85 95 00 00 00    	jne    ffff8000001031e6 <writei+0xc4>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
ffff800000103151:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103155:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff80000010315c:	66 85 c0             	test   %ax,%ax
ffff80000010315f:	78 3c                	js     ffff80000010319d <writei+0x7b>
ffff800000103161:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103165:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff80000010316c:	66 83 f8 09          	cmp    $0x9,%ax
ffff800000103170:	7f 2b                	jg     ffff80000010319d <writei+0x7b>
ffff800000103172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103176:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff80000010317d:	98                   	cwtl   
ffff80000010317e:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000103185:	80 ff ff 
ffff800000103188:	48 98                	cltq   
ffff80000010318a:	48 c1 e0 04          	shl    $0x4,%rax
ffff80000010318e:	48 01 d0             	add    %rdx,%rax
ffff800000103191:	48 83 c0 08          	add    $0x8,%rax
ffff800000103195:	48 8b 00             	mov    (%rax),%rax
ffff800000103198:	48 85 c0             	test   %rax,%rax
ffff80000010319b:	75 0a                	jne    ffff8000001031a7 <writei+0x85>
      return -1;
ffff80000010319d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001031a2:	e9 8d 01 00 00       	jmpq   ffff800000103334 <writei+0x212>
    return devsw[ip->major].write(ip, off, src, n);
ffff8000001031a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031ab:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff8000001031b2:	98                   	cwtl   
ffff8000001031b3:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff8000001031ba:	80 ff ff 
ffff8000001031bd:	48 98                	cltq   
ffff8000001031bf:	48 c1 e0 04          	shl    $0x4,%rax
ffff8000001031c3:	48 01 d0             	add    %rdx,%rax
ffff8000001031c6:	48 83 c0 08          	add    $0x8,%rax
ffff8000001031ca:	4c 8b 00             	mov    (%rax),%r8
ffff8000001031cd:	8b 4d c8             	mov    -0x38(%rbp),%ecx
ffff8000001031d0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff8000001031d4:	8b 75 cc             	mov    -0x34(%rbp),%esi
ffff8000001031d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031db:	48 89 c7             	mov    %rax,%rdi
ffff8000001031de:	41 ff d0             	callq  *%r8
ffff8000001031e1:	e9 4e 01 00 00       	jmpq   ffff800000103334 <writei+0x212>
  }

  if(off > ip->size || off + n < off)
ffff8000001031e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031ea:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001031f0:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff8000001031f3:	77 0d                	ja     ffff800000103202 <writei+0xe0>
ffff8000001031f5:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001031f8:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff8000001031fb:	01 d0                	add    %edx,%eax
ffff8000001031fd:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff800000103200:	76 0a                	jbe    ffff80000010320c <writei+0xea>
    return -1;
ffff800000103202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000103207:	e9 28 01 00 00       	jmpq   ffff800000103334 <writei+0x212>
  if(off + n > MAXFILE*BSIZE)
ffff80000010320c:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff80000010320f:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103212:	01 d0                	add    %edx,%eax
ffff800000103214:	3d 00 18 01 00       	cmp    $0x11800,%eax
ffff800000103219:	76 0a                	jbe    ffff800000103225 <writei+0x103>
    return -1;
ffff80000010321b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000103220:	e9 0f 01 00 00       	jmpq   ffff800000103334 <writei+0x212>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffff800000103225:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010322c:	e9 bf 00 00 00       	jmpq   ffff8000001032f0 <writei+0x1ce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffff800000103231:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103234:	c1 e8 09             	shr    $0x9,%eax
ffff800000103237:	89 c2                	mov    %eax,%edx
ffff800000103239:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010323d:	89 d6                	mov    %edx,%esi
ffff80000010323f:	48 89 c7             	mov    %rax,%rdi
ffff800000103242:	48 b8 11 2c 10 00 00 	movabs $0xffff800000102c11,%rax
ffff800000103249:	80 ff ff 
ffff80000010324c:	ff d0                	callq  *%rax
ffff80000010324e:	89 c2                	mov    %eax,%edx
ffff800000103250:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103254:	8b 00                	mov    (%rax),%eax
ffff800000103256:	89 d6                	mov    %edx,%esi
ffff800000103258:	89 c7                	mov    %eax,%edi
ffff80000010325a:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000103261:	80 ff ff 
ffff800000103264:	ff d0                	callq  *%rax
ffff800000103266:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffff80000010326a:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff80000010326d:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000103272:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000103277:	29 c2                	sub    %eax,%edx
ffff800000103279:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff80000010327c:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010327f:	39 c2                	cmp    %eax,%edx
ffff800000103281:	0f 46 c2             	cmovbe %edx,%eax
ffff800000103284:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(bp->data + off%BSIZE, src, m);
ffff800000103287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010328b:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff800000103292:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103295:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010329a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010329e:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001032a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001032a5:	48 89 c6             	mov    %rax,%rsi
ffff8000001032a8:	48 89 cf             	mov    %rcx,%rdi
ffff8000001032ab:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff8000001032b2:	80 ff ff 
ffff8000001032b5:	ff d0                	callq  *%rax
    log_write(bp);
ffff8000001032b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001032bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001032be:	48 b8 ef 52 10 00 00 	movabs $0xffff8000001052ef,%rax
ffff8000001032c5:	80 ff ff 
ffff8000001032c8:	ff d0                	callq  *%rax
    brelse(bp);
ffff8000001032ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001032ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001032d1:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff8000001032d8:	80 ff ff 
ffff8000001032db:	ff d0                	callq  *%rax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffff8000001032dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001032e0:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff8000001032e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001032e6:	01 45 cc             	add    %eax,-0x34(%rbp)
ffff8000001032e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001032ec:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffff8000001032f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001032f3:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffff8000001032f6:	0f 82 35 ff ff ff    	jb     ffff800000103231 <writei+0x10f>
  }

  if(n > 0 && off > ip->size){
ffff8000001032fc:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
ffff800000103300:	74 2f                	je     ffff800000103331 <writei+0x20f>
ffff800000103302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103306:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff80000010330c:	39 45 cc             	cmp    %eax,-0x34(%rbp)
ffff80000010330f:	76 20                	jbe    ffff800000103331 <writei+0x20f>
    ip->size = off;
ffff800000103311:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103315:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff800000103318:	89 90 9c 00 00 00    	mov    %edx,0x9c(%rax)
    iupdate(ip);
ffff80000010331e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103322:	48 89 c7             	mov    %rax,%rdi
ffff800000103325:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff80000010332c:	80 ff ff 
ffff80000010332f:	ff d0                	callq  *%rax
  }
  return n;
ffff800000103331:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffff800000103334:	c9                   	leaveq 
ffff800000103335:	c3                   	retq   

ffff800000103336 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
ffff800000103336:	f3 0f 1e fa          	endbr64 
ffff80000010333a:	55                   	push   %rbp
ffff80000010333b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010333e:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103342:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000103346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return strncmp(s, t, DIRSIZ);
ffff80000010334a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010334e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103352:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff800000103357:	48 89 ce             	mov    %rcx,%rsi
ffff80000010335a:	48 89 c7             	mov    %rax,%rdi
ffff80000010335d:	48 b8 bb 7a 10 00 00 	movabs $0xffff800000107abb,%rax
ffff800000103364:	80 ff ff 
ffff800000103367:	ff d0                	callq  *%rax
}
ffff800000103369:	c9                   	leaveq 
ffff80000010336a:	c3                   	retq   

ffff80000010336b <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
ffff80000010336b:	f3 0f 1e fa          	endbr64 
ffff80000010336f:	55                   	push   %rbp
ffff800000103370:	48 89 e5             	mov    %rsp,%rbp
ffff800000103373:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000103377:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010337b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010337f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
ffff800000103383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103387:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff80000010338e:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000103392:	74 16                	je     ffff8000001033aa <dirlookup+0x3f>
    panic("dirlookup not DIR");
ffff800000103394:	48 bf fd be 10 00 00 	movabs $0xffff80000010befd,%rdi
ffff80000010339b:	80 ff ff 
ffff80000010339e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001033a5:	80 ff ff 
ffff8000001033a8:	ff d0                	callq  *%rax

  for(off = 0; off < dp->size; off += sizeof(de)){
ffff8000001033aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001033b1:	e9 9f 00 00 00       	jmpq   ffff800000103455 <dirlookup+0xea>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff8000001033b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001033b9:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff8000001033bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001033c1:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff8000001033c6:	48 89 c7             	mov    %rax,%rdi
ffff8000001033c9:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff8000001033d0:	80 ff ff 
ffff8000001033d3:	ff d0                	callq  *%rax
ffff8000001033d5:	83 f8 10             	cmp    $0x10,%eax
ffff8000001033d8:	74 16                	je     ffff8000001033f0 <dirlookup+0x85>
      panic("dirlookup read");
ffff8000001033da:	48 bf 0f bf 10 00 00 	movabs $0xffff80000010bf0f,%rdi
ffff8000001033e1:	80 ff ff 
ffff8000001033e4:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001033eb:	80 ff ff 
ffff8000001033ee:	ff d0                	callq  *%rax
    if(de.inum == 0)
ffff8000001033f0:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff8000001033f4:	66 85 c0             	test   %ax,%ax
ffff8000001033f7:	74 57                	je     ffff800000103450 <dirlookup+0xe5>
      continue;
    if(namecmp(name, de.name) == 0){
ffff8000001033f9:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff8000001033fd:	48 8d 50 02          	lea    0x2(%rax),%rdx
ffff800000103401:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000103405:	48 89 d6             	mov    %rdx,%rsi
ffff800000103408:	48 89 c7             	mov    %rax,%rdi
ffff80000010340b:	48 b8 36 33 10 00 00 	movabs $0xffff800000103336,%rax
ffff800000103412:	80 ff ff 
ffff800000103415:	ff d0                	callq  *%rax
ffff800000103417:	85 c0                	test   %eax,%eax
ffff800000103419:	75 36                	jne    ffff800000103451 <dirlookup+0xe6>
      // entry matches path element
      if(poff)
ffff80000010341b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff800000103420:	74 09                	je     ffff80000010342b <dirlookup+0xc0>
        *poff = off;
ffff800000103422:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000103426:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103429:	89 10                	mov    %edx,(%rax)
      inum = de.inum;
ffff80000010342b:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff80000010342f:	0f b7 c0             	movzwl %ax,%eax
ffff800000103432:	89 45 f8             	mov    %eax,-0x8(%rbp)
      return iget(dp->dev, inum);
ffff800000103435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103439:	8b 00                	mov    (%rax),%eax
ffff80000010343b:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff80000010343e:	89 d6                	mov    %edx,%esi
ffff800000103440:	89 c7                	mov    %eax,%edi
ffff800000103442:	48 b8 60 27 10 00 00 	movabs $0xffff800000102760,%rax
ffff800000103449:	80 ff ff 
ffff80000010344c:	ff d0                	callq  *%rax
ffff80000010344e:	eb 1d                	jmp    ffff80000010346d <dirlookup+0x102>
      continue;
ffff800000103450:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff800000103451:	83 45 fc 10          	addl   $0x10,-0x4(%rbp)
ffff800000103455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103459:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff80000010345f:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000103462:	0f 82 4e ff ff ff    	jb     ffff8000001033b6 <dirlookup+0x4b>
    }
  }

  return 0;
ffff800000103468:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010346d:	c9                   	leaveq 
ffff80000010346e:	c3                   	retq   

ffff80000010346f <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
ffff80000010346f:	f3 0f 1e fa          	endbr64 
ffff800000103473:	55                   	push   %rbp
ffff800000103474:	48 89 e5             	mov    %rsp,%rbp
ffff800000103477:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010347b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010347f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000103483:	89 55 cc             	mov    %edx,-0x34(%rbp)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
ffff800000103486:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
ffff80000010348a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010348e:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000103493:	48 89 ce             	mov    %rcx,%rsi
ffff800000103496:	48 89 c7             	mov    %rax,%rdi
ffff800000103499:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff8000001034a0:	80 ff ff 
ffff8000001034a3:	ff d0                	callq  *%rax
ffff8000001034a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001034a9:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001034ae:	74 1d                	je     ffff8000001034cd <dirlink+0x5e>
    iput(ip);
ffff8000001034b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001034b4:	48 89 c7             	mov    %rax,%rdi
ffff8000001034b7:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff8000001034be:	80 ff ff 
ffff8000001034c1:	ff d0                	callq  *%rax
    return -1;
ffff8000001034c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001034c8:	e9 d2 00 00 00       	jmpq   ffff80000010359f <dirlink+0x130>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff8000001034cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001034d4:	eb 4c                	jmp    ffff800000103522 <dirlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff8000001034d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001034d9:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff8000001034dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001034e1:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff8000001034e6:	48 89 c7             	mov    %rax,%rdi
ffff8000001034e9:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff8000001034f0:	80 ff ff 
ffff8000001034f3:	ff d0                	callq  *%rax
ffff8000001034f5:	83 f8 10             	cmp    $0x10,%eax
ffff8000001034f8:	74 16                	je     ffff800000103510 <dirlink+0xa1>
      panic("dirlink read");
ffff8000001034fa:	48 bf 1e bf 10 00 00 	movabs $0xffff80000010bf1e,%rdi
ffff800000103501:	80 ff ff 
ffff800000103504:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010350b:	80 ff ff 
ffff80000010350e:	ff d0                	callq  *%rax
    if(de.inum == 0)
ffff800000103510:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff800000103514:	66 85 c0             	test   %ax,%ax
ffff800000103517:	74 1c                	je     ffff800000103535 <dirlink+0xc6>
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff800000103519:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010351c:	83 c0 10             	add    $0x10,%eax
ffff80000010351f:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000103522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103526:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff80000010352c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010352f:	39 c2                	cmp    %eax,%edx
ffff800000103531:	77 a3                	ja     ffff8000001034d6 <dirlink+0x67>
ffff800000103533:	eb 01                	jmp    ffff800000103536 <dirlink+0xc7>
      break;
ffff800000103535:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
ffff800000103536:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010353a:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff80000010353e:	48 8d 4a 02          	lea    0x2(%rdx),%rcx
ffff800000103542:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff800000103547:	48 89 c6             	mov    %rax,%rsi
ffff80000010354a:	48 89 cf             	mov    %rcx,%rdi
ffff80000010354d:	48 b8 2c 7b 10 00 00 	movabs $0xffff800000107b2c,%rax
ffff800000103554:	80 ff ff 
ffff800000103557:	ff d0                	callq  *%rax
  de.inum = inum;
ffff800000103559:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff80000010355c:	66 89 45 e0          	mov    %ax,-0x20(%rbp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000103560:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103563:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000103567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010356b:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000103570:	48 89 c7             	mov    %rax,%rdi
ffff800000103573:	48 b8 22 31 10 00 00 	movabs $0xffff800000103122,%rax
ffff80000010357a:	80 ff ff 
ffff80000010357d:	ff d0                	callq  *%rax
ffff80000010357f:	83 f8 10             	cmp    $0x10,%eax
ffff800000103582:	74 16                	je     ffff80000010359a <dirlink+0x12b>
    panic("dirlink");
ffff800000103584:	48 bf 2b bf 10 00 00 	movabs $0xffff80000010bf2b,%rdi
ffff80000010358b:	80 ff ff 
ffff80000010358e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103595:	80 ff ff 
ffff800000103598:	ff d0                	callq  *%rax

  return 0;
ffff80000010359a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010359f:	c9                   	leaveq 
ffff8000001035a0:	c3                   	retq   

ffff8000001035a1 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
ffff8000001035a1:	f3 0f 1e fa          	endbr64 
ffff8000001035a5:	55                   	push   %rbp
ffff8000001035a6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001035a9:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001035ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001035b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s;
  int len;

  while(*path == '/')
ffff8000001035b5:	eb 05                	jmp    ffff8000001035bc <skipelem+0x1b>
    path++;
ffff8000001035b7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
ffff8000001035bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035c0:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035c3:	3c 2f                	cmp    $0x2f,%al
ffff8000001035c5:	74 f0                	je     ffff8000001035b7 <skipelem+0x16>
  if(*path == 0)
ffff8000001035c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035cb:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035ce:	84 c0                	test   %al,%al
ffff8000001035d0:	75 0a                	jne    ffff8000001035dc <skipelem+0x3b>
    return 0;
ffff8000001035d2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001035d7:	e9 9a 00 00 00       	jmpq   ffff800000103676 <skipelem+0xd5>
  s = path;
ffff8000001035dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(*path != '/' && *path != 0)
ffff8000001035e4:	eb 05                	jmp    ffff8000001035eb <skipelem+0x4a>
    path++;
ffff8000001035e6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path != '/' && *path != 0)
ffff8000001035eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035ef:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035f2:	3c 2f                	cmp    $0x2f,%al
ffff8000001035f4:	74 0b                	je     ffff800000103601 <skipelem+0x60>
ffff8000001035f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001035fa:	0f b6 00             	movzbl (%rax),%eax
ffff8000001035fd:	84 c0                	test   %al,%al
ffff8000001035ff:	75 e5                	jne    ffff8000001035e6 <skipelem+0x45>
  len = path - s;
ffff800000103601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103605:	48 2b 45 f8          	sub    -0x8(%rbp),%rax
ffff800000103609:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(len >= DIRSIZ)
ffff80000010360c:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
ffff800000103610:	7e 21                	jle    ffff800000103633 <skipelem+0x92>
    memmove(name, s, DIRSIZ);
ffff800000103612:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000103616:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010361a:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff80000010361f:	48 89 ce             	mov    %rcx,%rsi
ffff800000103622:	48 89 c7             	mov    %rax,%rdi
ffff800000103625:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff80000010362c:	80 ff ff 
ffff80000010362f:	ff d0                	callq  *%rax
ffff800000103631:	eb 34                	jmp    ffff800000103667 <skipelem+0xc6>
  else {
    memmove(name, s, len);
ffff800000103633:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000103636:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010363a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010363e:	48 89 ce             	mov    %rcx,%rsi
ffff800000103641:	48 89 c7             	mov    %rax,%rdi
ffff800000103644:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff80000010364b:	80 ff ff 
ffff80000010364e:	ff d0                	callq  *%rax
    name[len] = 0;
ffff800000103650:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103653:	48 63 d0             	movslq %eax,%rdx
ffff800000103656:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010365a:	48 01 d0             	add    %rdx,%rax
ffff80000010365d:	c6 00 00             	movb   $0x0,(%rax)
  }
  while(*path == '/')
ffff800000103660:	eb 05                	jmp    ffff800000103667 <skipelem+0xc6>
    path++;
ffff800000103662:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
ffff800000103667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010366b:	0f b6 00             	movzbl (%rax),%eax
ffff80000010366e:	3c 2f                	cmp    $0x2f,%al
ffff800000103670:	74 f0                	je     ffff800000103662 <skipelem+0xc1>
  return path;
ffff800000103672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffff800000103676:	c9                   	leaveq 
ffff800000103677:	c3                   	retq   

ffff800000103678 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
ffff800000103678:	f3 0f 1e fa          	endbr64 
ffff80000010367c:	55                   	push   %rbp
ffff80000010367d:	48 89 e5             	mov    %rsp,%rbp
ffff800000103680:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000103684:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000103688:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff80000010368b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  struct inode *ip, *next;

  if(*path == '/')
ffff80000010368f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103693:	0f b6 00             	movzbl (%rax),%eax
ffff800000103696:	3c 2f                	cmp    $0x2f,%al
ffff800000103698:	75 1f                	jne    ffff8000001036b9 <namex+0x41>
    ip = iget(ROOTDEV, ROOTINO);
ffff80000010369a:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010369f:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001036a4:	48 b8 60 27 10 00 00 	movabs $0xffff800000102760,%rax
ffff8000001036ab:	80 ff ff 
ffff8000001036ae:	ff d0                	callq  *%rax
ffff8000001036b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001036b4:	e9 f7 00 00 00       	jmpq   ffff8000001037b0 <namex+0x138>
  else
    ip = idup(proc->cwd);
ffff8000001036b9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001036c0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001036c4:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff8000001036cb:	48 89 c7             	mov    %rax,%rdi
ffff8000001036ce:	48 b8 95 28 10 00 00 	movabs $0xffff800000102895,%rax
ffff8000001036d5:	80 ff ff 
ffff8000001036d8:	ff d0                	callq  *%rax
ffff8000001036da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  while((path = skipelem(path, name)) != 0){
ffff8000001036de:	e9 cd 00 00 00       	jmpq   ffff8000001037b0 <namex+0x138>
    ilock(ip);
ffff8000001036e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001036e7:	48 89 c7             	mov    %rax,%rdi
ffff8000001036ea:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001036f1:	80 ff ff 
ffff8000001036f4:	ff d0                	callq  *%rax
    if(ip->type != T_DIR){
ffff8000001036f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001036fa:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000103701:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000103705:	74 1d                	je     ffff800000103724 <namex+0xac>
      iunlockput(ip);
ffff800000103707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010370b:	48 89 c7             	mov    %rax,%rdi
ffff80000010370e:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000103715:	80 ff ff 
ffff800000103718:	ff d0                	callq  *%rax
      return 0;
ffff80000010371a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010371f:	e9 d9 00 00 00       	jmpq   ffff8000001037fd <namex+0x185>
    }
    if(nameiparent && *path == '\0'){
ffff800000103724:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff800000103728:	74 27                	je     ffff800000103751 <namex+0xd9>
ffff80000010372a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010372e:	0f b6 00             	movzbl (%rax),%eax
ffff800000103731:	84 c0                	test   %al,%al
ffff800000103733:	75 1c                	jne    ffff800000103751 <namex+0xd9>
      iunlock(ip);  // Stop one level early.
ffff800000103735:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103739:	48 89 c7             	mov    %rax,%rdi
ffff80000010373c:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000103743:	80 ff ff 
ffff800000103746:	ff d0                	callq  *%rax
      return ip;
ffff800000103748:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010374c:	e9 ac 00 00 00       	jmpq   ffff8000001037fd <namex+0x185>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
ffff800000103751:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff800000103755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103759:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010375e:	48 89 ce             	mov    %rcx,%rsi
ffff800000103761:	48 89 c7             	mov    %rax,%rdi
ffff800000103764:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff80000010376b:	80 ff ff 
ffff80000010376e:	ff d0                	callq  *%rax
ffff800000103770:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000103774:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000103779:	75 1a                	jne    ffff800000103795 <namex+0x11d>
      iunlockput(ip);
ffff80000010377b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010377f:	48 89 c7             	mov    %rax,%rdi
ffff800000103782:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000103789:	80 ff ff 
ffff80000010378c:	ff d0                	callq  *%rax
      return 0;
ffff80000010378e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000103793:	eb 68                	jmp    ffff8000001037fd <namex+0x185>
    }
    iunlockput(ip);
ffff800000103795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103799:	48 89 c7             	mov    %rax,%rdi
ffff80000010379c:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001037a3:	80 ff ff 
ffff8000001037a6:	ff d0                	callq  *%rax
    ip = next;
ffff8000001037a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001037ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((path = skipelem(path, name)) != 0){
ffff8000001037b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff8000001037b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001037b8:	48 89 d6             	mov    %rdx,%rsi
ffff8000001037bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001037be:	48 b8 a1 35 10 00 00 	movabs $0xffff8000001035a1,%rax
ffff8000001037c5:	80 ff ff 
ffff8000001037c8:	ff d0                	callq  *%rax
ffff8000001037ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001037ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001037d3:	0f 85 0a ff ff ff    	jne    ffff8000001036e3 <namex+0x6b>
  }
  if(nameiparent){
ffff8000001037d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff8000001037dd:	74 1a                	je     ffff8000001037f9 <namex+0x181>
    iput(ip);
ffff8000001037df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001037e3:	48 89 c7             	mov    %rax,%rdi
ffff8000001037e6:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff8000001037ed:	80 ff ff 
ffff8000001037f0:	ff d0                	callq  *%rax
    return 0;
ffff8000001037f2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001037f7:	eb 04                	jmp    ffff8000001037fd <namex+0x185>
  }
  return ip;
ffff8000001037f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001037fd:	c9                   	leaveq 
ffff8000001037fe:	c3                   	retq   

ffff8000001037ff <namei>:

struct inode*
namei(char *path)
{
ffff8000001037ff:	f3 0f 1e fa          	endbr64 
ffff800000103803:	55                   	push   %rbp
ffff800000103804:	48 89 e5             	mov    %rsp,%rbp
ffff800000103807:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010380b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  char name[DIRSIZ];
  return namex(path, 0, name);
ffff80000010380f:	48 8d 55 f2          	lea    -0xe(%rbp),%rdx
ffff800000103813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103817:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010381c:	48 89 c7             	mov    %rax,%rdi
ffff80000010381f:	48 b8 78 36 10 00 00 	movabs $0xffff800000103678,%rax
ffff800000103826:	80 ff ff 
ffff800000103829:	ff d0                	callq  *%rax
}
ffff80000010382b:	c9                   	leaveq 
ffff80000010382c:	c3                   	retq   

ffff80000010382d <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
ffff80000010382d:	f3 0f 1e fa          	endbr64 
ffff800000103831:	55                   	push   %rbp
ffff800000103832:	48 89 e5             	mov    %rsp,%rbp
ffff800000103835:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103839:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010383d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return namex(path, 1, name);
ffff800000103841:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000103845:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103849:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010384e:	48 89 c7             	mov    %rax,%rdi
ffff800000103851:	48 b8 78 36 10 00 00 	movabs $0xffff800000103678,%rax
ffff800000103858:	80 ff ff 
ffff80000010385b:	ff d0                	callq  *%rax
}
ffff80000010385d:	c9                   	leaveq 
ffff80000010385e:	c3                   	retq   

ffff80000010385f <inb>:
{
ffff80000010385f:	f3 0f 1e fa          	endbr64 
ffff800000103863:	55                   	push   %rbp
ffff800000103864:	48 89 e5             	mov    %rsp,%rbp
ffff800000103867:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010386b:	89 f8                	mov    %edi,%eax
ffff80000010386d:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000103871:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000103875:	89 c2                	mov    %eax,%edx
ffff800000103877:	ec                   	in     (%dx),%al
ffff800000103878:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff80000010387b:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010387f:	c9                   	leaveq 
ffff800000103880:	c3                   	retq   

ffff800000103881 <insl>:
{
ffff800000103881:	f3 0f 1e fa          	endbr64 
ffff800000103885:	55                   	push   %rbp
ffff800000103886:	48 89 e5             	mov    %rsp,%rbp
ffff800000103889:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010388d:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103890:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000103894:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep insl" :
ffff800000103897:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010389a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff80000010389e:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001038a1:	48 89 ce             	mov    %rcx,%rsi
ffff8000001038a4:	48 89 f7             	mov    %rsi,%rdi
ffff8000001038a7:	89 c1                	mov    %eax,%ecx
ffff8000001038a9:	fc                   	cld    
ffff8000001038aa:	f3 6d                	rep insl (%dx),%es:(%rdi)
ffff8000001038ac:	89 c8                	mov    %ecx,%eax
ffff8000001038ae:	48 89 fe             	mov    %rdi,%rsi
ffff8000001038b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001038b5:	89 45 f8             	mov    %eax,-0x8(%rbp)
}
ffff8000001038b8:	90                   	nop
ffff8000001038b9:	c9                   	leaveq 
ffff8000001038ba:	c3                   	retq   

ffff8000001038bb <outb>:
{
ffff8000001038bb:	f3 0f 1e fa          	endbr64 
ffff8000001038bf:	55                   	push   %rbp
ffff8000001038c0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001038c3:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001038c7:	89 f8                	mov    %edi,%eax
ffff8000001038c9:	89 f2                	mov    %esi,%edx
ffff8000001038cb:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff8000001038cf:	89 d0                	mov    %edx,%eax
ffff8000001038d1:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff8000001038d4:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff8000001038d8:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff8000001038dc:	ee                   	out    %al,(%dx)
}
ffff8000001038dd:	90                   	nop
ffff8000001038de:	c9                   	leaveq 
ffff8000001038df:	c3                   	retq   

ffff8000001038e0 <outsl>:
{
ffff8000001038e0:	f3 0f 1e fa          	endbr64 
ffff8000001038e4:	55                   	push   %rbp
ffff8000001038e5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001038e8:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001038ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff8000001038ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001038f3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep outsl" :
ffff8000001038f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001038f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff8000001038fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103900:	48 89 ce             	mov    %rcx,%rsi
ffff800000103903:	89 c1                	mov    %eax,%ecx
ffff800000103905:	fc                   	cld    
ffff800000103906:	f3 6f                	rep outsl %ds:(%rsi),(%dx)
ffff800000103908:	89 c8                	mov    %ecx,%eax
ffff80000010390a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff80000010390e:	89 45 f8             	mov    %eax,-0x8(%rbp)
}
ffff800000103911:	90                   	nop
ffff800000103912:	c9                   	leaveq 
ffff800000103913:	c3                   	retq   

ffff800000103914 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
ffff800000103914:	f3 0f 1e fa          	endbr64 
ffff800000103918:	55                   	push   %rbp
ffff800000103919:	48 89 e5             	mov    %rsp,%rbp
ffff80000010391c:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000103920:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
ffff800000103923:	90                   	nop
ffff800000103924:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103929:	48 b8 5f 38 10 00 00 	movabs $0xffff80000010385f,%rax
ffff800000103930:	80 ff ff 
ffff800000103933:	ff d0                	callq  *%rax
ffff800000103935:	0f b6 c0             	movzbl %al,%eax
ffff800000103938:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff80000010393b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010393e:	25 c0 00 00 00       	and    $0xc0,%eax
ffff800000103943:	83 f8 40             	cmp    $0x40,%eax
ffff800000103946:	75 dc                	jne    ffff800000103924 <idewait+0x10>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
ffff800000103948:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff80000010394c:	74 11                	je     ffff80000010395f <idewait+0x4b>
ffff80000010394e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103951:	83 e0 21             	and    $0x21,%eax
ffff800000103954:	85 c0                	test   %eax,%eax
ffff800000103956:	74 07                	je     ffff80000010395f <idewait+0x4b>
    return -1;
ffff800000103958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010395d:	eb 05                	jmp    ffff800000103964 <idewait+0x50>
  return 0;
ffff80000010395f:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000103964:	c9                   	leaveq 
ffff800000103965:	c3                   	retq   

ffff800000103966 <ideinit>:

void
ideinit(void)
{
ffff800000103966:	f3 0f 1e fa          	endbr64 
ffff80000010396a:	55                   	push   %rbp
ffff80000010396b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010396e:	48 83 ec 10          	sub    $0x10,%rsp
  initlock(&idelock, "ide");
ffff800000103972:	48 be 33 bf 10 00 00 	movabs $0xffff80000010bf33,%rsi
ffff800000103979:	80 ff ff 
ffff80000010397c:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103983:	80 ff ff 
ffff800000103986:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff80000010398d:	80 ff ff 
ffff800000103990:	ff d0                	callq  *%rax
  ioapicenable(IRQ_IDE, ncpu - 1);
ffff800000103992:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000103999:	80 ff ff 
ffff80000010399c:	8b 00                	mov    (%rax),%eax
ffff80000010399e:	83 e8 01             	sub    $0x1,%eax
ffff8000001039a1:	89 c6                	mov    %eax,%esi
ffff8000001039a3:	bf 0e 00 00 00       	mov    $0xe,%edi
ffff8000001039a8:	48 b8 e5 3f 10 00 00 	movabs $0xffff800000103fe5,%rax
ffff8000001039af:	80 ff ff 
ffff8000001039b2:	ff d0                	callq  *%rax
  idewait(0);
ffff8000001039b4:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001039b9:	48 b8 14 39 10 00 00 	movabs $0xffff800000103914,%rax
ffff8000001039c0:	80 ff ff 
ffff8000001039c3:	ff d0                	callq  *%rax

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
ffff8000001039c5:	be f0 00 00 00       	mov    $0xf0,%esi
ffff8000001039ca:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff8000001039cf:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff8000001039d6:	80 ff ff 
ffff8000001039d9:	ff d0                	callq  *%rax
  for(int i=0; i<1000; i++){
ffff8000001039db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001039e2:	eb 2b                	jmp    ffff800000103a0f <ideinit+0xa9>
    if(inb(0x1f7) != 0){
ffff8000001039e4:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff8000001039e9:	48 b8 5f 38 10 00 00 	movabs $0xffff80000010385f,%rax
ffff8000001039f0:	80 ff ff 
ffff8000001039f3:	ff d0                	callq  *%rax
ffff8000001039f5:	84 c0                	test   %al,%al
ffff8000001039f7:	74 12                	je     ffff800000103a0b <ideinit+0xa5>
      havedisk1 = 1;
ffff8000001039f9:	48 b8 30 71 11 00 00 	movabs $0xffff800000117130,%rax
ffff800000103a00:	80 ff ff 
ffff800000103a03:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
      break;
ffff800000103a09:	eb 0d                	jmp    ffff800000103a18 <ideinit+0xb2>
  for(int i=0; i<1000; i++){
ffff800000103a0b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000103a0f:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
ffff800000103a16:	7e cc                	jle    ffff8000001039e4 <ideinit+0x7e>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
ffff800000103a18:	be e0 00 00 00       	mov    $0xe0,%esi
ffff800000103a1d:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103a22:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103a29:	80 ff ff 
ffff800000103a2c:	ff d0                	callq  *%rax
}
ffff800000103a2e:	90                   	nop
ffff800000103a2f:	c9                   	leaveq 
ffff800000103a30:	c3                   	retq   

ffff800000103a31 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
ffff800000103a31:	f3 0f 1e fa          	endbr64 
ffff800000103a35:	55                   	push   %rbp
ffff800000103a36:	48 89 e5             	mov    %rsp,%rbp
ffff800000103a39:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000103a3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  if(b == 0)
ffff800000103a41:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000103a46:	75 16                	jne    ffff800000103a5e <idestart+0x2d>
    panic("idestart");
ffff800000103a48:	48 bf 37 bf 10 00 00 	movabs $0xffff80000010bf37,%rdi
ffff800000103a4f:	80 ff ff 
ffff800000103a52:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103a59:	80 ff ff 
ffff800000103a5c:	ff d0                	callq  *%rax
  if(b->blockno >= FSSIZE)
ffff800000103a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103a62:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000103a65:	3d e7 03 00 00       	cmp    $0x3e7,%eax
ffff800000103a6a:	76 16                	jbe    ffff800000103a82 <idestart+0x51>
    panic("incorrect blockno");
ffff800000103a6c:	48 bf 40 bf 10 00 00 	movabs $0xffff80000010bf40,%rdi
ffff800000103a73:	80 ff ff 
ffff800000103a76:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103a7d:	80 ff ff 
ffff800000103a80:	ff d0                	callq  *%rax
  int sector_per_block =  BSIZE/SECTOR_SIZE;
ffff800000103a82:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  int sector = b->blockno * sector_per_block;
ffff800000103a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103a8d:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000103a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103a93:	0f af c2             	imul   %edx,%eax
ffff800000103a96:	89 45 f8             	mov    %eax,-0x8(%rbp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
ffff800000103a99:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000103a9d:	75 07                	jne    ffff800000103aa6 <idestart+0x75>
ffff800000103a9f:	b8 20 00 00 00       	mov    $0x20,%eax
ffff800000103aa4:	eb 05                	jmp    ffff800000103aab <idestart+0x7a>
ffff800000103aa6:	b8 c4 00 00 00       	mov    $0xc4,%eax
ffff800000103aab:	89 45 f4             	mov    %eax,-0xc(%rbp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
ffff800000103aae:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000103ab2:	75 07                	jne    ffff800000103abb <idestart+0x8a>
ffff800000103ab4:	b8 30 00 00 00       	mov    $0x30,%eax
ffff800000103ab9:	eb 05                	jmp    ffff800000103ac0 <idestart+0x8f>
ffff800000103abb:	b8 c5 00 00 00       	mov    $0xc5,%eax
ffff800000103ac0:	89 45 f0             	mov    %eax,-0x10(%rbp)

  if (sector_per_block > 7) panic("idestart");
ffff800000103ac3:	83 7d fc 07          	cmpl   $0x7,-0x4(%rbp)
ffff800000103ac7:	7e 16                	jle    ffff800000103adf <idestart+0xae>
ffff800000103ac9:	48 bf 37 bf 10 00 00 	movabs $0xffff80000010bf37,%rdi
ffff800000103ad0:	80 ff ff 
ffff800000103ad3:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103ada:	80 ff ff 
ffff800000103add:	ff d0                	callq  *%rax

  idewait(0);
ffff800000103adf:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103ae4:	48 b8 14 39 10 00 00 	movabs $0xffff800000103914,%rax
ffff800000103aeb:	80 ff ff 
ffff800000103aee:	ff d0                	callq  *%rax
  outb(0x3f6, 0);  // generate interrupt
ffff800000103af0:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000103af5:	bf f6 03 00 00       	mov    $0x3f6,%edi
ffff800000103afa:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b01:	80 ff ff 
ffff800000103b04:	ff d0                	callq  *%rax
  outb(0x1f2, sector_per_block);  // number of sectors
ffff800000103b06:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103b09:	0f b6 c0             	movzbl %al,%eax
ffff800000103b0c:	89 c6                	mov    %eax,%esi
ffff800000103b0e:	bf f2 01 00 00       	mov    $0x1f2,%edi
ffff800000103b13:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b1a:	80 ff ff 
ffff800000103b1d:	ff d0                	callq  *%rax
  outb(0x1f3, sector & 0xff);
ffff800000103b1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b22:	0f b6 c0             	movzbl %al,%eax
ffff800000103b25:	89 c6                	mov    %eax,%esi
ffff800000103b27:	bf f3 01 00 00       	mov    $0x1f3,%edi
ffff800000103b2c:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b33:	80 ff ff 
ffff800000103b36:	ff d0                	callq  *%rax
  outb(0x1f4, (sector >> 8) & 0xff);
ffff800000103b38:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b3b:	c1 f8 08             	sar    $0x8,%eax
ffff800000103b3e:	0f b6 c0             	movzbl %al,%eax
ffff800000103b41:	89 c6                	mov    %eax,%esi
ffff800000103b43:	bf f4 01 00 00       	mov    $0x1f4,%edi
ffff800000103b48:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b4f:	80 ff ff 
ffff800000103b52:	ff d0                	callq  *%rax
  outb(0x1f5, (sector >> 16) & 0xff);
ffff800000103b54:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b57:	c1 f8 10             	sar    $0x10,%eax
ffff800000103b5a:	0f b6 c0             	movzbl %al,%eax
ffff800000103b5d:	89 c6                	mov    %eax,%esi
ffff800000103b5f:	bf f5 01 00 00       	mov    $0x1f5,%edi
ffff800000103b64:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b6b:	80 ff ff 
ffff800000103b6e:	ff d0                	callq  *%rax
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
ffff800000103b70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103b74:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000103b77:	c1 e0 04             	shl    $0x4,%eax
ffff800000103b7a:	83 e0 10             	and    $0x10,%eax
ffff800000103b7d:	89 c2                	mov    %eax,%edx
ffff800000103b7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b82:	c1 f8 18             	sar    $0x18,%eax
ffff800000103b85:	83 e0 0f             	and    $0xf,%eax
ffff800000103b88:	09 d0                	or     %edx,%eax
ffff800000103b8a:	83 c8 e0             	or     $0xffffffe0,%eax
ffff800000103b8d:	0f b6 c0             	movzbl %al,%eax
ffff800000103b90:	89 c6                	mov    %eax,%esi
ffff800000103b92:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103b97:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103b9e:	80 ff ff 
ffff800000103ba1:	ff d0                	callq  *%rax
  if(b->flags & B_DIRTY){
ffff800000103ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103ba7:	8b 00                	mov    (%rax),%eax
ffff800000103ba9:	83 e0 04             	and    $0x4,%eax
ffff800000103bac:	85 c0                	test   %eax,%eax
ffff800000103bae:	74 3e                	je     ffff800000103bee <idestart+0x1bd>
    outb(0x1f7, write_cmd);
ffff800000103bb0:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103bb3:	0f b6 c0             	movzbl %al,%eax
ffff800000103bb6:	89 c6                	mov    %eax,%esi
ffff800000103bb8:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103bbd:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103bc4:	80 ff ff 
ffff800000103bc7:	ff d0                	callq  *%rax
    outsl(0x1f0, b->data, BSIZE/4);
ffff800000103bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103bcd:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000103bd3:	ba 80 00 00 00       	mov    $0x80,%edx
ffff800000103bd8:	48 89 c6             	mov    %rax,%rsi
ffff800000103bdb:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffff800000103be0:	48 b8 e0 38 10 00 00 	movabs $0xffff8000001038e0,%rax
ffff800000103be7:	80 ff ff 
ffff800000103bea:	ff d0                	callq  *%rax
  } else {
    outb(0x1f7, read_cmd);
  }
}
ffff800000103bec:	eb 19                	jmp    ffff800000103c07 <idestart+0x1d6>
    outb(0x1f7, read_cmd);
ffff800000103bee:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103bf1:	0f b6 c0             	movzbl %al,%eax
ffff800000103bf4:	89 c6                	mov    %eax,%esi
ffff800000103bf6:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103bfb:	48 b8 bb 38 10 00 00 	movabs $0xffff8000001038bb,%rax
ffff800000103c02:	80 ff ff 
ffff800000103c05:	ff d0                	callq  *%rax
}
ffff800000103c07:	90                   	nop
ffff800000103c08:	c9                   	leaveq 
ffff800000103c09:	c3                   	retq   

ffff800000103c0a <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
ffff800000103c0a:	f3 0f 1e fa          	endbr64 
ffff800000103c0e:	55                   	push   %rbp
ffff800000103c0f:	48 89 e5             	mov    %rsp,%rbp
ffff800000103c12:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
ffff800000103c16:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103c1d:	80 ff ff 
ffff800000103c20:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000103c27:	80 ff ff 
ffff800000103c2a:	ff d0                	callq  *%rax
  if((b = idequeue) == 0){
ffff800000103c2c:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103c33:	80 ff ff 
ffff800000103c36:	48 8b 00             	mov    (%rax),%rax
ffff800000103c39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103c3d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000103c42:	75 1b                	jne    ffff800000103c5f <ideintr+0x55>
    release(&idelock);
ffff800000103c44:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103c4b:	80 ff ff 
ffff800000103c4e:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000103c55:	80 ff ff 
ffff800000103c58:	ff d0                	callq  *%rax
    // cprintf("spurious IDE interrupt\n");
    return;
ffff800000103c5a:	e9 d6 00 00 00       	jmpq   ffff800000103d35 <ideintr+0x12b>
  }
  idequeue = b->qnext;
ffff800000103c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c63:	48 8b 80 a8 00 00 00 	mov    0xa8(%rax),%rax
ffff800000103c6a:	48 ba 28 71 11 00 00 	movabs $0xffff800000117128,%rdx
ffff800000103c71:	80 ff ff 
ffff800000103c74:	48 89 02             	mov    %rax,(%rdx)

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
ffff800000103c77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c7b:	8b 00                	mov    (%rax),%eax
ffff800000103c7d:	83 e0 04             	and    $0x4,%eax
ffff800000103c80:	85 c0                	test   %eax,%eax
ffff800000103c82:	75 38                	jne    ffff800000103cbc <ideintr+0xb2>
ffff800000103c84:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103c89:	48 b8 14 39 10 00 00 	movabs $0xffff800000103914,%rax
ffff800000103c90:	80 ff ff 
ffff800000103c93:	ff d0                	callq  *%rax
ffff800000103c95:	85 c0                	test   %eax,%eax
ffff800000103c97:	78 23                	js     ffff800000103cbc <ideintr+0xb2>
    insl(0x1f0, b->data, BSIZE/4);
ffff800000103c99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c9d:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000103ca3:	ba 80 00 00 00       	mov    $0x80,%edx
ffff800000103ca8:	48 89 c6             	mov    %rax,%rsi
ffff800000103cab:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffff800000103cb0:	48 b8 81 38 10 00 00 	movabs $0xffff800000103881,%rax
ffff800000103cb7:	80 ff ff 
ffff800000103cba:	ff d0                	callq  *%rax

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
ffff800000103cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103cc0:	8b 00                	mov    (%rax),%eax
ffff800000103cc2:	83 c8 02             	or     $0x2,%eax
ffff800000103cc5:	89 c2                	mov    %eax,%edx
ffff800000103cc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103ccb:	89 10                	mov    %edx,(%rax)
  b->flags &= ~B_DIRTY;
ffff800000103ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103cd1:	8b 00                	mov    (%rax),%eax
ffff800000103cd3:	83 e0 fb             	and    $0xfffffffb,%eax
ffff800000103cd6:	89 c2                	mov    %eax,%edx
ffff800000103cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103cdc:	89 10                	mov    %edx,(%rax)
  wakeup(b);
ffff800000103cde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103ce2:	48 89 c7             	mov    %rax,%rdi
ffff800000103ce5:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff800000103cec:	80 ff ff 
ffff800000103cef:	ff d0                	callq  *%rax

  // Start disk on next buf in queue.
  if(idequeue != 0)
ffff800000103cf1:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103cf8:	80 ff ff 
ffff800000103cfb:	48 8b 00             	mov    (%rax),%rax
ffff800000103cfe:	48 85 c0             	test   %rax,%rax
ffff800000103d01:	74 1c                	je     ffff800000103d1f <ideintr+0x115>
    idestart(idequeue);
ffff800000103d03:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103d0a:	80 ff ff 
ffff800000103d0d:	48 8b 00             	mov    (%rax),%rax
ffff800000103d10:	48 89 c7             	mov    %rax,%rdi
ffff800000103d13:	48 b8 31 3a 10 00 00 	movabs $0xffff800000103a31,%rax
ffff800000103d1a:	80 ff ff 
ffff800000103d1d:	ff d0                	callq  *%rax

  release(&idelock);
ffff800000103d1f:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103d26:	80 ff ff 
ffff800000103d29:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000103d30:	80 ff ff 
ffff800000103d33:	ff d0                	callq  *%rax
}
ffff800000103d35:	c9                   	leaveq 
ffff800000103d36:	c3                   	retq   

ffff800000103d37 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
ffff800000103d37:	f3 0f 1e fa          	endbr64 
ffff800000103d3b:	55                   	push   %rbp
ffff800000103d3c:	48 89 e5             	mov    %rsp,%rbp
ffff800000103d3f:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000103d43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf **pp;

  if(!holdingsleep(&b->lock))
ffff800000103d47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103d4b:	48 83 c0 10          	add    $0x10,%rax
ffff800000103d4f:	48 89 c7             	mov    %rax,%rdi
ffff800000103d52:	48 b8 4b 74 10 00 00 	movabs $0xffff80000010744b,%rax
ffff800000103d59:	80 ff ff 
ffff800000103d5c:	ff d0                	callq  *%rax
ffff800000103d5e:	85 c0                	test   %eax,%eax
ffff800000103d60:	75 16                	jne    ffff800000103d78 <iderw+0x41>
    panic("iderw: buf not locked");
ffff800000103d62:	48 bf 52 bf 10 00 00 	movabs $0xffff80000010bf52,%rdi
ffff800000103d69:	80 ff ff 
ffff800000103d6c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103d73:	80 ff ff 
ffff800000103d76:	ff d0                	callq  *%rax
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
ffff800000103d78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103d7c:	8b 00                	mov    (%rax),%eax
ffff800000103d7e:	83 e0 06             	and    $0x6,%eax
ffff800000103d81:	83 f8 02             	cmp    $0x2,%eax
ffff800000103d84:	75 16                	jne    ffff800000103d9c <iderw+0x65>
    panic("iderw: nothing to do");
ffff800000103d86:	48 bf 68 bf 10 00 00 	movabs $0xffff80000010bf68,%rdi
ffff800000103d8d:	80 ff ff 
ffff800000103d90:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103d97:	80 ff ff 
ffff800000103d9a:	ff d0                	callq  *%rax
  if(b->dev != 0 && !havedisk1)
ffff800000103d9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103da0:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000103da3:	85 c0                	test   %eax,%eax
ffff800000103da5:	74 26                	je     ffff800000103dcd <iderw+0x96>
ffff800000103da7:	48 b8 30 71 11 00 00 	movabs $0xffff800000117130,%rax
ffff800000103dae:	80 ff ff 
ffff800000103db1:	8b 00                	mov    (%rax),%eax
ffff800000103db3:	85 c0                	test   %eax,%eax
ffff800000103db5:	75 16                	jne    ffff800000103dcd <iderw+0x96>
    panic("iderw: ide disk 1 not present");
ffff800000103db7:	48 bf 7d bf 10 00 00 	movabs $0xffff80000010bf7d,%rdi
ffff800000103dbe:	80 ff ff 
ffff800000103dc1:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000103dc8:	80 ff ff 
ffff800000103dcb:	ff d0                	callq  *%rax

  acquire(&idelock);  //DOC:acquire-lock
ffff800000103dcd:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103dd4:	80 ff ff 
ffff800000103dd7:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000103dde:	80 ff ff 
ffff800000103de1:	ff d0                	callq  *%rax

  // Append b to idequeue.
  b->qnext = 0;
ffff800000103de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103de7:	48 c7 80 a8 00 00 00 	movq   $0x0,0xa8(%rax)
ffff800000103dee:	00 00 00 00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
ffff800000103df2:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103df9:	80 ff ff 
ffff800000103dfc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103e00:	eb 11                	jmp    ffff800000103e13 <iderw+0xdc>
ffff800000103e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103e06:	48 8b 00             	mov    (%rax),%rax
ffff800000103e09:	48 05 a8 00 00 00    	add    $0xa8,%rax
ffff800000103e0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103e17:	48 8b 00             	mov    (%rax),%rax
ffff800000103e1a:	48 85 c0             	test   %rax,%rax
ffff800000103e1d:	75 e3                	jne    ffff800000103e02 <iderw+0xcb>
    ;
  *pp = b;
ffff800000103e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103e23:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000103e27:	48 89 10             	mov    %rdx,(%rax)

  // Start disk if necessary.
  if(idequeue == b)
ffff800000103e2a:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103e31:	80 ff ff 
ffff800000103e34:	48 8b 00             	mov    (%rax),%rax
ffff800000103e37:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000103e3b:	75 32                	jne    ffff800000103e6f <iderw+0x138>
    idestart(b);
ffff800000103e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e41:	48 89 c7             	mov    %rax,%rdi
ffff800000103e44:	48 b8 31 3a 10 00 00 	movabs $0xffff800000103a31,%rax
ffff800000103e4b:	80 ff ff 
ffff800000103e4e:	ff d0                	callq  *%rax

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffff800000103e50:	eb 1d                	jmp    ffff800000103e6f <iderw+0x138>
    sleep(b, &idelock);
ffff800000103e52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e56:	48 be c0 70 11 00 00 	movabs $0xffff8000001170c0,%rsi
ffff800000103e5d:	80 ff ff 
ffff800000103e60:	48 89 c7             	mov    %rax,%rdi
ffff800000103e63:	48 b8 15 6f 10 00 00 	movabs $0xffff800000106f15,%rax
ffff800000103e6a:	80 ff ff 
ffff800000103e6d:	ff d0                	callq  *%rax
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffff800000103e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e73:	8b 00                	mov    (%rax),%eax
ffff800000103e75:	83 e0 06             	and    $0x6,%eax
ffff800000103e78:	83 f8 02             	cmp    $0x2,%eax
ffff800000103e7b:	75 d5                	jne    ffff800000103e52 <iderw+0x11b>
  }

  release(&idelock);
ffff800000103e7d:	48 bf c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdi
ffff800000103e84:	80 ff ff 
ffff800000103e87:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000103e8e:	80 ff ff 
ffff800000103e91:	ff d0                	callq  *%rax
}
ffff800000103e93:	90                   	nop
ffff800000103e94:	c9                   	leaveq 
ffff800000103e95:	c3                   	retq   

ffff800000103e96 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
ffff800000103e96:	f3 0f 1e fa          	endbr64 
ffff800000103e9a:	55                   	push   %rbp
ffff800000103e9b:	48 89 e5             	mov    %rsp,%rbp
ffff800000103e9e:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103ea2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  ioapic->reg = reg;
ffff800000103ea5:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103eac:	80 ff ff 
ffff800000103eaf:	48 8b 00             	mov    (%rax),%rax
ffff800000103eb2:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103eb5:	89 10                	mov    %edx,(%rax)
  return ioapic->data;
ffff800000103eb7:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103ebe:	80 ff ff 
ffff800000103ec1:	48 8b 00             	mov    (%rax),%rax
ffff800000103ec4:	8b 40 10             	mov    0x10(%rax),%eax
}
ffff800000103ec7:	c9                   	leaveq 
ffff800000103ec8:	c3                   	retq   

ffff800000103ec9 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
ffff800000103ec9:	f3 0f 1e fa          	endbr64 
ffff800000103ecd:	55                   	push   %rbp
ffff800000103ece:	48 89 e5             	mov    %rsp,%rbp
ffff800000103ed1:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103ed5:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103ed8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  ioapic->reg = reg;
ffff800000103edb:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103ee2:	80 ff ff 
ffff800000103ee5:	48 8b 00             	mov    (%rax),%rax
ffff800000103ee8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103eeb:	89 10                	mov    %edx,(%rax)
  ioapic->data = data;
ffff800000103eed:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103ef4:	80 ff ff 
ffff800000103ef7:	48 8b 00             	mov    (%rax),%rax
ffff800000103efa:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000103efd:	89 50 10             	mov    %edx,0x10(%rax)
}
ffff800000103f00:	90                   	nop
ffff800000103f01:	c9                   	leaveq 
ffff800000103f02:	c3                   	retq   

ffff800000103f03 <ioapicinit>:

void
ioapicinit(void)
{
ffff800000103f03:	f3 0f 1e fa          	endbr64 
ffff800000103f07:	55                   	push   %rbp
ffff800000103f08:	48 89 e5             	mov    %rsp,%rbp
ffff800000103f0b:	48 83 ec 10          	sub    $0x10,%rsp
  int i, id, maxintr;

  ioapic = P2V((volatile struct ioapic*)IOAPIC);
ffff800000103f0f:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103f16:	80 ff ff 
ffff800000103f19:	48 b9 00 00 c0 fe 00 	movabs $0xffff8000fec00000,%rcx
ffff800000103f20:	80 ff ff 
ffff800000103f23:	48 89 08             	mov    %rcx,(%rax)
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
ffff800000103f26:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103f2b:	48 b8 96 3e 10 00 00 	movabs $0xffff800000103e96,%rax
ffff800000103f32:	80 ff ff 
ffff800000103f35:	ff d0                	callq  *%rax
ffff800000103f37:	c1 e8 10             	shr    $0x10,%eax
ffff800000103f3a:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000103f3f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  id = ioapicread(REG_ID) >> 24;
ffff800000103f42:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103f47:	48 b8 96 3e 10 00 00 	movabs $0xffff800000103e96,%rax
ffff800000103f4e:	80 ff ff 
ffff800000103f51:	ff d0                	callq  *%rax
ffff800000103f53:	c1 e8 18             	shr    $0x18,%eax
ffff800000103f56:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(id != ioapicid)
ffff800000103f59:	48 b8 24 74 11 00 00 	movabs $0xffff800000117424,%rax
ffff800000103f60:	80 ff ff 
ffff800000103f63:	0f b6 00             	movzbl (%rax),%eax
ffff800000103f66:	0f b6 c0             	movzbl %al,%eax
ffff800000103f69:	39 45 f4             	cmp    %eax,-0xc(%rbp)
ffff800000103f6c:	74 1b                	je     ffff800000103f89 <ioapicinit+0x86>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
ffff800000103f6e:	48 bf a0 bf 10 00 00 	movabs $0xffff80000010bfa0,%rdi
ffff800000103f75:	80 ff ff 
ffff800000103f78:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000103f7d:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000103f84:	80 ff ff 
ffff800000103f87:	ff d2                	callq  *%rdx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
ffff800000103f89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103f90:	eb 47                	jmp    ffff800000103fd9 <ioapicinit+0xd6>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
ffff800000103f92:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103f95:	83 c0 20             	add    $0x20,%eax
ffff800000103f98:	0d 00 00 01 00       	or     $0x10000,%eax
ffff800000103f9d:	89 c2                	mov    %eax,%edx
ffff800000103f9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103fa2:	83 c0 08             	add    $0x8,%eax
ffff800000103fa5:	01 c0                	add    %eax,%eax
ffff800000103fa7:	89 d6                	mov    %edx,%esi
ffff800000103fa9:	89 c7                	mov    %eax,%edi
ffff800000103fab:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000103fb2:	80 ff ff 
ffff800000103fb5:	ff d0                	callq  *%rax
    ioapicwrite(REG_TABLE+2*i+1, 0);
ffff800000103fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103fba:	83 c0 08             	add    $0x8,%eax
ffff800000103fbd:	01 c0                	add    %eax,%eax
ffff800000103fbf:	83 c0 01             	add    $0x1,%eax
ffff800000103fc2:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000103fc7:	89 c7                	mov    %eax,%edi
ffff800000103fc9:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000103fd0:	80 ff ff 
ffff800000103fd3:	ff d0                	callq  *%rax
  for(i = 0; i <= maxintr; i++){
ffff800000103fd5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000103fd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103fdc:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffff800000103fdf:	7e b1                	jle    ffff800000103f92 <ioapicinit+0x8f>
  }
}
ffff800000103fe1:	90                   	nop
ffff800000103fe2:	90                   	nop
ffff800000103fe3:	c9                   	leaveq 
ffff800000103fe4:	c3                   	retq   

ffff800000103fe5 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
ffff800000103fe5:	f3 0f 1e fa          	endbr64 
ffff800000103fe9:	55                   	push   %rbp
ffff800000103fea:	48 89 e5             	mov    %rsp,%rbp
ffff800000103fed:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103ff1:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103ff4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
ffff800000103ff7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103ffa:	83 c0 20             	add    $0x20,%eax
ffff800000103ffd:	89 c2                	mov    %eax,%edx
ffff800000103fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104002:	83 c0 08             	add    $0x8,%eax
ffff800000104005:	01 c0                	add    %eax,%eax
ffff800000104007:	89 d6                	mov    %edx,%esi
ffff800000104009:	89 c7                	mov    %eax,%edi
ffff80000010400b:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000104012:	80 ff ff 
ffff800000104015:	ff d0                	callq  *%rax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
ffff800000104017:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010401a:	c1 e0 18             	shl    $0x18,%eax
ffff80000010401d:	89 c2                	mov    %eax,%edx
ffff80000010401f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104022:	83 c0 08             	add    $0x8,%eax
ffff800000104025:	01 c0                	add    %eax,%eax
ffff800000104027:	83 c0 01             	add    $0x1,%eax
ffff80000010402a:	89 d6                	mov    %edx,%esi
ffff80000010402c:	89 c7                	mov    %eax,%edi
ffff80000010402e:	48 b8 c9 3e 10 00 00 	movabs $0xffff800000103ec9,%rax
ffff800000104035:	80 ff ff 
ffff800000104038:	ff d0                	callq  *%rax
}
ffff80000010403a:	90                   	nop
ffff80000010403b:	c9                   	leaveq 
ffff80000010403c:	c3                   	retq   

ffff80000010403d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
ffff80000010403d:	f3 0f 1e fa          	endbr64 
ffff800000104041:	55                   	push   %rbp
ffff800000104042:	48 89 e5             	mov    %rsp,%rbp
ffff800000104045:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000104049:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010404d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&kmem.lock, "kmem");
ffff800000104051:	48 be d2 bf 10 00 00 	movabs $0xffff80000010bfd2,%rsi
ffff800000104058:	80 ff ff 
ffff80000010405b:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff800000104062:	80 ff ff 
ffff800000104065:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff80000010406c:	80 ff ff 
ffff80000010406f:	ff d0                	callq  *%rax
  kmem.use_lock = 0;
ffff800000104071:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104078:	80 ff ff 
ffff80000010407b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
  freerange(vstart, vend);
ffff800000104082:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000104086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010408a:	48 89 d6             	mov    %rdx,%rsi
ffff80000010408d:	48 89 c7             	mov    %rax,%rdi
ffff800000104090:	48 b8 e1 40 10 00 00 	movabs $0xffff8000001040e1,%rax
ffff800000104097:	80 ff ff 
ffff80000010409a:	ff d0                	callq  *%rax
}
ffff80000010409c:	90                   	nop
ffff80000010409d:	c9                   	leaveq 
ffff80000010409e:	c3                   	retq   

ffff80000010409f <kinit2>:

void
kinit2(void *vstart, void *vend)
{
ffff80000010409f:	f3 0f 1e fa          	endbr64 
ffff8000001040a3:	55                   	push   %rbp
ffff8000001040a4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001040a7:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001040ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001040af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  freerange(vstart, vend);
ffff8000001040b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001040b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001040bb:	48 89 d6             	mov    %rdx,%rsi
ffff8000001040be:	48 89 c7             	mov    %rax,%rdi
ffff8000001040c1:	48 b8 e1 40 10 00 00 	movabs $0xffff8000001040e1,%rax
ffff8000001040c8:	80 ff ff 
ffff8000001040cb:	ff d0                	callq  *%rax
  kmem.use_lock = 1;
ffff8000001040cd:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff8000001040d4:	80 ff ff 
ffff8000001040d7:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)
}
ffff8000001040de:	90                   	nop
ffff8000001040df:	c9                   	leaveq 
ffff8000001040e0:	c3                   	retq   

ffff8000001040e1 <freerange>:

void
freerange(void *vstart, void *vend)
{
ffff8000001040e1:	f3 0f 1e fa          	endbr64 
ffff8000001040e5:	55                   	push   %rbp
ffff8000001040e6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001040e9:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001040ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001040f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *p;
  p = (char*)PGROUNDUP((addr_t)vstart);
ffff8000001040f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001040f9:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff8000001040ff:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff800000104105:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffff800000104109:	eb 1b                	jmp    ffff800000104126 <freerange+0x45>
    kfree(p);
ffff80000010410b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010410f:	48 89 c7             	mov    %rax,%rdi
ffff800000104112:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff800000104119:	80 ff ff 
ffff80000010411c:	ff d0                	callq  *%rax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffff80000010411e:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff800000104125:	00 
ffff800000104126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010412a:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff800000104130:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
ffff800000104134:	73 d5                	jae    ffff80000010410b <freerange+0x2a>
}
ffff800000104136:	90                   	nop
ffff800000104137:	90                   	nop
ffff800000104138:	c9                   	leaveq 
ffff800000104139:	c3                   	retq   

ffff80000010413a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
ffff80000010413a:	f3 0f 1e fa          	endbr64 
ffff80000010413e:	55                   	push   %rbp
ffff80000010413f:	48 89 e5             	mov    %rsp,%rbp
ffff800000104142:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000104146:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct run *r;

  if((addr_t)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
ffff80000010414a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010414e:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff800000104153:	48 85 c0             	test   %rax,%rax
ffff800000104156:	75 29                	jne    ffff800000104181 <kfree+0x47>
ffff800000104158:	48 b8 00 b0 11 00 00 	movabs $0xffff80000011b000,%rax
ffff80000010415f:	80 ff ff 
ffff800000104162:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000104166:	72 19                	jb     ffff800000104181 <kfree+0x47>
ffff800000104168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010416c:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff800000104173:	80 00 00 
ffff800000104176:	48 01 d0             	add    %rdx,%rax
ffff800000104179:	48 3d ff ff ff 0d    	cmp    $0xdffffff,%rax
ffff80000010417f:	76 16                	jbe    ffff800000104197 <kfree+0x5d>
    panic("kfree");
ffff800000104181:	48 bf d7 bf 10 00 00 	movabs $0xffff80000010bfd7,%rdi
ffff800000104188:	80 ff ff 
ffff80000010418b:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000104192:	80 ff ff 
ffff800000104195:	ff d0                	callq  *%rax

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
ffff800000104197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010419b:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff8000001041a0:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001041a5:	48 89 c7             	mov    %rax,%rdi
ffff8000001041a8:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff8000001041af:	80 ff ff 
ffff8000001041b2:	ff d0                	callq  *%rax

  if(kmem.use_lock)
ffff8000001041b4:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff8000001041bb:	80 ff ff 
ffff8000001041be:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001041c1:	85 c0                	test   %eax,%eax
ffff8000001041c3:	74 16                	je     ffff8000001041db <kfree+0xa1>
    acquire(&kmem.lock);
ffff8000001041c5:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff8000001041cc:	80 ff ff 
ffff8000001041cf:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff8000001041d6:	80 ff ff 
ffff8000001041d9:	ff d0                	callq  *%rax
  r = (struct run*)v;
ffff8000001041db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001041df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  r->next = kmem.freelist;
ffff8000001041e3:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff8000001041ea:	80 ff ff 
ffff8000001041ed:	48 8b 50 70          	mov    0x70(%rax),%rdx
ffff8000001041f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001041f5:	48 89 10             	mov    %rdx,(%rax)
  kmem.freelist = r;
ffff8000001041f8:	48 ba 40 71 11 00 00 	movabs $0xffff800000117140,%rdx
ffff8000001041ff:	80 ff ff 
ffff800000104202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104206:	48 89 42 70          	mov    %rax,0x70(%rdx)
  if(kmem.use_lock)
ffff80000010420a:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104211:	80 ff ff 
ffff800000104214:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104217:	85 c0                	test   %eax,%eax
ffff800000104219:	74 16                	je     ffff800000104231 <kfree+0xf7>
    release(&kmem.lock);
ffff80000010421b:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff800000104222:	80 ff ff 
ffff800000104225:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010422c:	80 ff ff 
ffff80000010422f:	ff d0                	callq  *%rax
}
ffff800000104231:	90                   	nop
ffff800000104232:	c9                   	leaveq 
ffff800000104233:	c3                   	retq   

ffff800000104234 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
ffff800000104234:	f3 0f 1e fa          	endbr64 
ffff800000104238:	55                   	push   %rbp
ffff800000104239:	48 89 e5             	mov    %rsp,%rbp
ffff80000010423c:	48 83 ec 10          	sub    $0x10,%rsp
  struct run *r;

  if(kmem.use_lock)
ffff800000104240:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104247:	80 ff ff 
ffff80000010424a:	8b 40 68             	mov    0x68(%rax),%eax
ffff80000010424d:	85 c0                	test   %eax,%eax
ffff80000010424f:	74 16                	je     ffff800000104267 <kalloc+0x33>
    acquire(&kmem.lock);
ffff800000104251:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff800000104258:	80 ff ff 
ffff80000010425b:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000104262:	80 ff ff 
ffff800000104265:	ff d0                	callq  *%rax
  r = kmem.freelist;
ffff800000104267:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff80000010426e:	80 ff ff 
ffff800000104271:	48 8b 40 70          	mov    0x70(%rax),%rax
ffff800000104275:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(r)
ffff800000104279:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010427e:	74 15                	je     ffff800000104295 <kalloc+0x61>
    kmem.freelist = r->next;
ffff800000104280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104284:	48 8b 00             	mov    (%rax),%rax
ffff800000104287:	48 ba 40 71 11 00 00 	movabs $0xffff800000117140,%rdx
ffff80000010428e:	80 ff ff 
ffff800000104291:	48 89 42 70          	mov    %rax,0x70(%rdx)
  if(kmem.use_lock)
ffff800000104295:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff80000010429c:	80 ff ff 
ffff80000010429f:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001042a2:	85 c0                	test   %eax,%eax
ffff8000001042a4:	74 16                	je     ffff8000001042bc <kalloc+0x88>
    release(&kmem.lock);
ffff8000001042a6:	48 bf 40 71 11 00 00 	movabs $0xffff800000117140,%rdi
ffff8000001042ad:	80 ff ff 
ffff8000001042b0:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001042b7:	80 ff ff 
ffff8000001042ba:	ff d0                	callq  *%rax
  return (char*)r;
ffff8000001042bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001042c0:	c9                   	leaveq 
ffff8000001042c1:	c3                   	retq   

ffff8000001042c2 <inb>:
{
ffff8000001042c2:	f3 0f 1e fa          	endbr64 
ffff8000001042c6:	55                   	push   %rbp
ffff8000001042c7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001042ca:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001042ce:	89 f8                	mov    %edi,%eax
ffff8000001042d0:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001042d4:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001042d8:	89 c2                	mov    %eax,%edx
ffff8000001042da:	ec                   	in     (%dx),%al
ffff8000001042db:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff8000001042de:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff8000001042e2:	c9                   	leaveq 
ffff8000001042e3:	c3                   	retq   

ffff8000001042e4 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
ffff8000001042e4:	f3 0f 1e fa          	endbr64 
ffff8000001042e8:	55                   	push   %rbp
ffff8000001042e9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001042ec:	48 83 ec 10          	sub    $0x10,%rsp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
ffff8000001042f0:	bf 64 00 00 00       	mov    $0x64,%edi
ffff8000001042f5:	48 b8 c2 42 10 00 00 	movabs $0xffff8000001042c2,%rax
ffff8000001042fc:	80 ff ff 
ffff8000001042ff:	ff d0                	callq  *%rax
ffff800000104301:	0f b6 c0             	movzbl %al,%eax
ffff800000104304:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if((st & KBS_DIB) == 0)
ffff800000104307:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010430a:	83 e0 01             	and    $0x1,%eax
ffff80000010430d:	85 c0                	test   %eax,%eax
ffff80000010430f:	75 0a                	jne    ffff80000010431b <kbdgetc+0x37>
    return -1;
ffff800000104311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000104316:	e9 ae 01 00 00       	jmpq   ffff8000001044c9 <kbdgetc+0x1e5>
  data = inb(KBDATAP);
ffff80000010431b:	bf 60 00 00 00       	mov    $0x60,%edi
ffff800000104320:	48 b8 c2 42 10 00 00 	movabs $0xffff8000001042c2,%rax
ffff800000104327:	80 ff ff 
ffff80000010432a:	ff d0                	callq  *%rax
ffff80000010432c:	0f b6 c0             	movzbl %al,%eax
ffff80000010432f:	89 45 fc             	mov    %eax,-0x4(%rbp)

  if(data == 0xE0){
ffff800000104332:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%rbp)
ffff800000104339:	75 27                	jne    ffff800000104362 <kbdgetc+0x7e>
    shift |= E0ESC;
ffff80000010433b:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104342:	80 ff ff 
ffff800000104345:	8b 00                	mov    (%rax),%eax
ffff800000104347:	83 c8 40             	or     $0x40,%eax
ffff80000010434a:	89 c2                	mov    %eax,%edx
ffff80000010434c:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104353:	80 ff ff 
ffff800000104356:	89 10                	mov    %edx,(%rax)
    return 0;
ffff800000104358:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010435d:	e9 67 01 00 00       	jmpq   ffff8000001044c9 <kbdgetc+0x1e5>
  } else if(data & 0x80){
ffff800000104362:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104365:	25 80 00 00 00       	and    $0x80,%eax
ffff80000010436a:	85 c0                	test   %eax,%eax
ffff80000010436c:	74 60                	je     ffff8000001043ce <kbdgetc+0xea>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
ffff80000010436e:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104375:	80 ff ff 
ffff800000104378:	8b 00                	mov    (%rax),%eax
ffff80000010437a:	83 e0 40             	and    $0x40,%eax
ffff80000010437d:	85 c0                	test   %eax,%eax
ffff80000010437f:	75 08                	jne    ffff800000104389 <kbdgetc+0xa5>
ffff800000104381:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104384:	83 e0 7f             	and    $0x7f,%eax
ffff800000104387:	eb 03                	jmp    ffff80000010438c <kbdgetc+0xa8>
ffff800000104389:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010438c:	89 45 fc             	mov    %eax,-0x4(%rbp)
    shift &= ~(shiftcode[data] | E0ESC);
ffff80000010438f:	48 ba 20 d0 10 00 00 	movabs $0xffff80000010d020,%rdx
ffff800000104396:	80 ff ff 
ffff800000104399:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010439c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff8000001043a0:	83 c8 40             	or     $0x40,%eax
ffff8000001043a3:	0f b6 c0             	movzbl %al,%eax
ffff8000001043a6:	f7 d0                	not    %eax
ffff8000001043a8:	89 c2                	mov    %eax,%edx
ffff8000001043aa:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043b1:	80 ff ff 
ffff8000001043b4:	8b 00                	mov    (%rax),%eax
ffff8000001043b6:	21 c2                	and    %eax,%edx
ffff8000001043b8:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043bf:	80 ff ff 
ffff8000001043c2:	89 10                	mov    %edx,(%rax)
    return 0;
ffff8000001043c4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001043c9:	e9 fb 00 00 00       	jmpq   ffff8000001044c9 <kbdgetc+0x1e5>
  } else if(shift & E0ESC){
ffff8000001043ce:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043d5:	80 ff ff 
ffff8000001043d8:	8b 00                	mov    (%rax),%eax
ffff8000001043da:	83 e0 40             	and    $0x40,%eax
ffff8000001043dd:	85 c0                	test   %eax,%eax
ffff8000001043df:	74 24                	je     ffff800000104405 <kbdgetc+0x121>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
ffff8000001043e1:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%rbp)
    shift &= ~E0ESC;
ffff8000001043e8:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043ef:	80 ff ff 
ffff8000001043f2:	8b 00                	mov    (%rax),%eax
ffff8000001043f4:	83 e0 bf             	and    $0xffffffbf,%eax
ffff8000001043f7:	89 c2                	mov    %eax,%edx
ffff8000001043f9:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104400:	80 ff ff 
ffff800000104403:	89 10                	mov    %edx,(%rax)
  }

  shift |= shiftcode[data];
ffff800000104405:	48 ba 20 d0 10 00 00 	movabs $0xffff80000010d020,%rdx
ffff80000010440c:	80 ff ff 
ffff80000010440f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104412:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff800000104416:	0f b6 d0             	movzbl %al,%edx
ffff800000104419:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104420:	80 ff ff 
ffff800000104423:	8b 00                	mov    (%rax),%eax
ffff800000104425:	09 c2                	or     %eax,%edx
ffff800000104427:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010442e:	80 ff ff 
ffff800000104431:	89 10                	mov    %edx,(%rax)
  shift ^= togglecode[data];
ffff800000104433:	48 ba 20 d1 10 00 00 	movabs $0xffff80000010d120,%rdx
ffff80000010443a:	80 ff ff 
ffff80000010443d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104440:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff800000104444:	0f b6 d0             	movzbl %al,%edx
ffff800000104447:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010444e:	80 ff ff 
ffff800000104451:	8b 00                	mov    (%rax),%eax
ffff800000104453:	31 c2                	xor    %eax,%edx
ffff800000104455:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010445c:	80 ff ff 
ffff80000010445f:	89 10                	mov    %edx,(%rax)
  c = charcode[shift & (CTL | SHIFT)][data];
ffff800000104461:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104468:	80 ff ff 
ffff80000010446b:	8b 00                	mov    (%rax),%eax
ffff80000010446d:	83 e0 03             	and    $0x3,%eax
ffff800000104470:	89 c2                	mov    %eax,%edx
ffff800000104472:	48 b8 20 d5 10 00 00 	movabs $0xffff80000010d520,%rax
ffff800000104479:	80 ff ff 
ffff80000010447c:	89 d2                	mov    %edx,%edx
ffff80000010447e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
ffff800000104482:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104485:	48 01 d0             	add    %rdx,%rax
ffff800000104488:	0f b6 00             	movzbl (%rax),%eax
ffff80000010448b:	0f b6 c0             	movzbl %al,%eax
ffff80000010448e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(shift & CAPSLOCK){
ffff800000104491:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104498:	80 ff ff 
ffff80000010449b:	8b 00                	mov    (%rax),%eax
ffff80000010449d:	83 e0 08             	and    $0x8,%eax
ffff8000001044a0:	85 c0                	test   %eax,%eax
ffff8000001044a2:	74 22                	je     ffff8000001044c6 <kbdgetc+0x1e2>
    if('a' <= c && c <= 'z')
ffff8000001044a4:	83 7d f8 60          	cmpl   $0x60,-0x8(%rbp)
ffff8000001044a8:	76 0c                	jbe    ffff8000001044b6 <kbdgetc+0x1d2>
ffff8000001044aa:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%rbp)
ffff8000001044ae:	77 06                	ja     ffff8000001044b6 <kbdgetc+0x1d2>
      c += 'A' - 'a';
ffff8000001044b0:	83 6d f8 20          	subl   $0x20,-0x8(%rbp)
ffff8000001044b4:	eb 10                	jmp    ffff8000001044c6 <kbdgetc+0x1e2>
    else if('A' <= c && c <= 'Z')
ffff8000001044b6:	83 7d f8 40          	cmpl   $0x40,-0x8(%rbp)
ffff8000001044ba:	76 0a                	jbe    ffff8000001044c6 <kbdgetc+0x1e2>
ffff8000001044bc:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%rbp)
ffff8000001044c0:	77 04                	ja     ffff8000001044c6 <kbdgetc+0x1e2>
      c += 'a' - 'A';
ffff8000001044c2:	83 45 f8 20          	addl   $0x20,-0x8(%rbp)
  }
  return c;
ffff8000001044c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffff8000001044c9:	c9                   	leaveq 
ffff8000001044ca:	c3                   	retq   

ffff8000001044cb <kbdintr>:

void
kbdintr(void)
{
ffff8000001044cb:	f3 0f 1e fa          	endbr64 
ffff8000001044cf:	55                   	push   %rbp
ffff8000001044d0:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(kbdgetc);
ffff8000001044d3:	48 bf e4 42 10 00 00 	movabs $0xffff8000001042e4,%rdi
ffff8000001044da:	80 ff ff 
ffff8000001044dd:	48 b8 83 0f 10 00 00 	movabs $0xffff800000100f83,%rax
ffff8000001044e4:	80 ff ff 
ffff8000001044e7:	ff d0                	callq  *%rax
}
ffff8000001044e9:	90                   	nop
ffff8000001044ea:	5d                   	pop    %rbp
ffff8000001044eb:	c3                   	retq   

ffff8000001044ec <inb>:
{
ffff8000001044ec:	f3 0f 1e fa          	endbr64 
ffff8000001044f0:	55                   	push   %rbp
ffff8000001044f1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001044f4:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001044f8:	89 f8                	mov    %edi,%eax
ffff8000001044fa:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001044fe:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000104502:	89 c2                	mov    %eax,%edx
ffff800000104504:	ec                   	in     (%dx),%al
ffff800000104505:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000104508:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010450c:	c9                   	leaveq 
ffff80000010450d:	c3                   	retq   

ffff80000010450e <outb>:
{
ffff80000010450e:	f3 0f 1e fa          	endbr64 
ffff800000104512:	55                   	push   %rbp
ffff800000104513:	48 89 e5             	mov    %rsp,%rbp
ffff800000104516:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010451a:	89 f8                	mov    %edi,%eax
ffff80000010451c:	89 f2                	mov    %esi,%edx
ffff80000010451e:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff800000104522:	89 d0                	mov    %edx,%eax
ffff800000104524:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000104527:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010452b:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010452f:	ee                   	out    %al,(%dx)
}
ffff800000104530:	90                   	nop
ffff800000104531:	c9                   	leaveq 
ffff800000104532:	c3                   	retq   

ffff800000104533 <readeflags>:
{
ffff800000104533:	f3 0f 1e fa          	endbr64 
ffff800000104537:	55                   	push   %rbp
ffff800000104538:	48 89 e5             	mov    %rsp,%rbp
ffff80000010453b:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff80000010453f:	9c                   	pushfq 
ffff800000104540:	58                   	pop    %rax
ffff800000104541:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff800000104545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000104549:	c9                   	leaveq 
ffff80000010454a:	c3                   	retq   

ffff80000010454b <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
ffff80000010454b:	f3 0f 1e fa          	endbr64 
ffff80000010454f:	55                   	push   %rbp
ffff800000104550:	48 89 e5             	mov    %rsp,%rbp
ffff800000104553:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104557:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010455a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  lapic[index] = value;
ffff80000010455d:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104564:	80 ff ff 
ffff800000104567:	48 8b 00             	mov    (%rax),%rax
ffff80000010456a:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010456d:	48 63 d2             	movslq %edx,%rdx
ffff800000104570:	48 c1 e2 02          	shl    $0x2,%rdx
ffff800000104574:	48 01 c2             	add    %rax,%rdx
ffff800000104577:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010457a:	89 02                	mov    %eax,(%rdx)
  lapic[ID];  // wait for write to finish, by reading
ffff80000010457c:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104583:	80 ff ff 
ffff800000104586:	48 8b 00             	mov    (%rax),%rax
ffff800000104589:	48 83 c0 20          	add    $0x20,%rax
ffff80000010458d:	8b 00                	mov    (%rax),%eax
}
ffff80000010458f:	90                   	nop
ffff800000104590:	c9                   	leaveq 
ffff800000104591:	c3                   	retq   

ffff800000104592 <lapicinit>:

void
lapicinit(void)
{
ffff800000104592:	f3 0f 1e fa          	endbr64 
ffff800000104596:	55                   	push   %rbp
ffff800000104597:	48 89 e5             	mov    %rsp,%rbp
  if(!lapic)
ffff80000010459a:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff8000001045a1:	80 ff ff 
ffff8000001045a4:	48 8b 00             	mov    (%rax),%rax
ffff8000001045a7:	48 85 c0             	test   %rax,%rax
ffff8000001045aa:	0f 84 74 01 00 00    	je     ffff800000104724 <lapicinit+0x192>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
ffff8000001045b0:	be 3f 01 00 00       	mov    $0x13f,%esi
ffff8000001045b5:	bf 3c 00 00 00       	mov    $0x3c,%edi
ffff8000001045ba:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001045c1:	80 ff ff 
ffff8000001045c4:	ff d0                	callq  *%rax

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
ffff8000001045c6:	be 0b 00 00 00       	mov    $0xb,%esi
ffff8000001045cb:	bf f8 00 00 00       	mov    $0xf8,%edi
ffff8000001045d0:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001045d7:	80 ff ff 
ffff8000001045da:	ff d0                	callq  *%rax
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
ffff8000001045dc:	be 20 00 02 00       	mov    $0x20020,%esi
ffff8000001045e1:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff8000001045e6:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001045ed:	80 ff ff 
ffff8000001045f0:	ff d0                	callq  *%rax
  lapicw(TICR, 10000000);
ffff8000001045f2:	be 80 96 98 00       	mov    $0x989680,%esi
ffff8000001045f7:	bf e0 00 00 00       	mov    $0xe0,%edi
ffff8000001045fc:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104603:	80 ff ff 
ffff800000104606:	ff d0                	callq  *%rax

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
ffff800000104608:	be 00 00 01 00       	mov    $0x10000,%esi
ffff80000010460d:	bf d4 00 00 00       	mov    $0xd4,%edi
ffff800000104612:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104619:	80 ff ff 
ffff80000010461c:	ff d0                	callq  *%rax
  lapicw(LINT1, MASKED);
ffff80000010461e:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000104623:	bf d8 00 00 00       	mov    $0xd8,%edi
ffff800000104628:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010462f:	80 ff ff 
ffff800000104632:	ff d0                	callq  *%rax

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
ffff800000104634:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff80000010463b:	80 ff ff 
ffff80000010463e:	48 8b 00             	mov    (%rax),%rax
ffff800000104641:	48 83 c0 30          	add    $0x30,%rax
ffff800000104645:	8b 00                	mov    (%rax),%eax
ffff800000104647:	c1 e8 10             	shr    $0x10,%eax
ffff80000010464a:	25 fc 00 00 00       	and    $0xfc,%eax
ffff80000010464f:	85 c0                	test   %eax,%eax
ffff800000104651:	74 16                	je     ffff800000104669 <lapicinit+0xd7>
    lapicw(PCINT, MASKED);
ffff800000104653:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000104658:	bf d0 00 00 00       	mov    $0xd0,%edi
ffff80000010465d:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104664:	80 ff ff 
ffff800000104667:	ff d0                	callq  *%rax

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
ffff800000104669:	be 33 00 00 00       	mov    $0x33,%esi
ffff80000010466e:	bf dc 00 00 00       	mov    $0xdc,%edi
ffff800000104673:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010467a:	80 ff ff 
ffff80000010467d:	ff d0                	callq  *%rax

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
ffff80000010467f:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104684:	bf a0 00 00 00       	mov    $0xa0,%edi
ffff800000104689:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104690:	80 ff ff 
ffff800000104693:	ff d0                	callq  *%rax
  lapicw(ESR, 0);
ffff800000104695:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010469a:	bf a0 00 00 00       	mov    $0xa0,%edi
ffff80000010469f:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001046a6:	80 ff ff 
ffff8000001046a9:	ff d0                	callq  *%rax

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
ffff8000001046ab:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001046b0:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffff8000001046b5:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001046bc:	80 ff ff 
ffff8000001046bf:	ff d0                	callq  *%rax

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
ffff8000001046c1:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001046c6:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff8000001046cb:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001046d2:	80 ff ff 
ffff8000001046d5:	ff d0                	callq  *%rax
  lapicw(ICRLO, BCAST | INIT | LEVEL);
ffff8000001046d7:	be 00 85 08 00       	mov    $0x88500,%esi
ffff8000001046dc:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff8000001046e1:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001046e8:	80 ff ff 
ffff8000001046eb:	ff d0                	callq  *%rax
  while(lapic[ICRLO] & DELIVS)
ffff8000001046ed:	90                   	nop
ffff8000001046ee:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff8000001046f5:	80 ff ff 
ffff8000001046f8:	48 8b 00             	mov    (%rax),%rax
ffff8000001046fb:	48 05 00 03 00 00    	add    $0x300,%rax
ffff800000104701:	8b 00                	mov    (%rax),%eax
ffff800000104703:	25 00 10 00 00       	and    $0x1000,%eax
ffff800000104708:	85 c0                	test   %eax,%eax
ffff80000010470a:	75 e2                	jne    ffff8000001046ee <lapicinit+0x15c>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
ffff80000010470c:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104711:	bf 20 00 00 00       	mov    $0x20,%edi
ffff800000104716:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010471d:	80 ff ff 
ffff800000104720:	ff d0                	callq  *%rax
ffff800000104722:	eb 01                	jmp    ffff800000104725 <lapicinit+0x193>
    return;
ffff800000104724:	90                   	nop
}
ffff800000104725:	5d                   	pop    %rbp
ffff800000104726:	c3                   	retq   

ffff800000104727 <cpunum>:

int
cpunum(void)
{
ffff800000104727:	f3 0f 1e fa          	endbr64 
ffff80000010472b:	55                   	push   %rbp
ffff80000010472c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010472f:	48 83 ec 10          	sub    $0x10,%rsp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
ffff800000104733:	48 b8 33 45 10 00 00 	movabs $0xffff800000104533,%rax
ffff80000010473a:	80 ff ff 
ffff80000010473d:	ff d0                	callq  *%rax
ffff80000010473f:	25 00 02 00 00       	and    $0x200,%eax
ffff800000104744:	48 85 c0             	test   %rax,%rax
ffff800000104747:	74 41                	je     ffff80000010478a <cpunum+0x63>
    static int n;
    if(n++ == 0)
ffff800000104749:	48 b8 c8 71 11 00 00 	movabs $0xffff8000001171c8,%rax
ffff800000104750:	80 ff ff 
ffff800000104753:	8b 00                	mov    (%rax),%eax
ffff800000104755:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000104758:	48 b9 c8 71 11 00 00 	movabs $0xffff8000001171c8,%rcx
ffff80000010475f:	80 ff ff 
ffff800000104762:	89 11                	mov    %edx,(%rcx)
ffff800000104764:	85 c0                	test   %eax,%eax
ffff800000104766:	75 22                	jne    ffff80000010478a <cpunum+0x63>
      cprintf("cpu called from %x with interrupts enabled\n",
ffff800000104768:	48 8b 45 08          	mov    0x8(%rbp),%rax
ffff80000010476c:	48 89 c6             	mov    %rax,%rsi
ffff80000010476f:	48 bf e0 bf 10 00 00 	movabs $0xffff80000010bfe0,%rdi
ffff800000104776:	80 ff ff 
ffff800000104779:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010477e:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000104785:	80 ff ff 
ffff800000104788:	ff d2                	callq  *%rdx
        __builtin_return_address(0));
  }

  if (!lapic)
ffff80000010478a:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104791:	80 ff ff 
ffff800000104794:	48 8b 00             	mov    (%rax),%rax
ffff800000104797:	48 85 c0             	test   %rax,%rax
ffff80000010479a:	75 0a                	jne    ffff8000001047a6 <cpunum+0x7f>
    return 0;
ffff80000010479c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001047a1:	e9 82 00 00 00       	jmpq   ffff800000104828 <cpunum+0x101>

  apicid = lapic[ID] >> 24;
ffff8000001047a6:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff8000001047ad:	80 ff ff 
ffff8000001047b0:	48 8b 00             	mov    (%rax),%rax
ffff8000001047b3:	48 83 c0 20          	add    $0x20,%rax
ffff8000001047b7:	8b 00                	mov    (%rax),%eax
ffff8000001047b9:	c1 e8 18             	shr    $0x18,%eax
ffff8000001047bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (i = 0; i < ncpu; ++i) {
ffff8000001047bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001047c6:	eb 39                	jmp    ffff800000104801 <cpunum+0xda>
    if (cpus[i].apicid == apicid)
ffff8000001047c8:	48 b9 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rcx
ffff8000001047cf:	80 ff ff 
ffff8000001047d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001047d5:	48 63 d0             	movslq %eax,%rdx
ffff8000001047d8:	48 89 d0             	mov    %rdx,%rax
ffff8000001047db:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001047df:	48 01 d0             	add    %rdx,%rax
ffff8000001047e2:	48 c1 e0 03          	shl    $0x3,%rax
ffff8000001047e6:	48 01 c8             	add    %rcx,%rax
ffff8000001047e9:	48 83 c0 01          	add    $0x1,%rax
ffff8000001047ed:	0f b6 00             	movzbl (%rax),%eax
ffff8000001047f0:	0f b6 c0             	movzbl %al,%eax
ffff8000001047f3:	39 45 f8             	cmp    %eax,-0x8(%rbp)
ffff8000001047f6:	75 05                	jne    ffff8000001047fd <cpunum+0xd6>
      return i;
ffff8000001047f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001047fb:	eb 2b                	jmp    ffff800000104828 <cpunum+0x101>
  for (i = 0; i < ncpu; ++i) {
ffff8000001047fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104801:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000104808:	80 ff ff 
ffff80000010480b:	8b 00                	mov    (%rax),%eax
ffff80000010480d:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104810:	7c b6                	jl     ffff8000001047c8 <cpunum+0xa1>
  }
  panic("unknown apicid\n");
ffff800000104812:	48 bf 0c c0 10 00 00 	movabs $0xffff80000010c00c,%rdi
ffff800000104819:	80 ff ff 
ffff80000010481c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000104823:	80 ff ff 
ffff800000104826:	ff d0                	callq  *%rax
}
ffff800000104828:	c9                   	leaveq 
ffff800000104829:	c3                   	retq   

ffff80000010482a <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
ffff80000010482a:	f3 0f 1e fa          	endbr64 
ffff80000010482e:	55                   	push   %rbp
ffff80000010482f:	48 89 e5             	mov    %rsp,%rbp
  if(lapic)
ffff800000104832:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104839:	80 ff ff 
ffff80000010483c:	48 8b 00             	mov    (%rax),%rax
ffff80000010483f:	48 85 c0             	test   %rax,%rax
ffff800000104842:	74 16                	je     ffff80000010485a <lapiceoi+0x30>
    lapicw(EOI, 0);
ffff800000104844:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104849:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffff80000010484e:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104855:	80 ff ff 
ffff800000104858:	ff d0                	callq  *%rax
}
ffff80000010485a:	90                   	nop
ffff80000010485b:	5d                   	pop    %rbp
ffff80000010485c:	c3                   	retq   

ffff80000010485d <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
ffff80000010485d:	f3 0f 1e fa          	endbr64 
ffff800000104861:	55                   	push   %rbp
ffff800000104862:	48 89 e5             	mov    %rsp,%rbp
ffff800000104865:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104869:	89 7d fc             	mov    %edi,-0x4(%rbp)
}
ffff80000010486c:	90                   	nop
ffff80000010486d:	c9                   	leaveq 
ffff80000010486e:	c3                   	retq   

ffff80000010486f <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
ffff80000010486f:	f3 0f 1e fa          	endbr64 
ffff800000104873:	55                   	push   %rbp
ffff800000104874:	48 89 e5             	mov    %rsp,%rbp
ffff800000104877:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010487b:	89 f8                	mov    %edi,%eax
ffff80000010487d:	89 75 e8             	mov    %esi,-0x18(%rbp)
ffff800000104880:	88 45 ec             	mov    %al,-0x14(%rbp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
ffff800000104883:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000104888:	bf 70 00 00 00       	mov    $0x70,%edi
ffff80000010488d:	48 b8 0e 45 10 00 00 	movabs $0xffff80000010450e,%rax
ffff800000104894:	80 ff ff 
ffff800000104897:	ff d0                	callq  *%rax
  outb(CMOS_PORT+1, 0x0A);
ffff800000104899:	be 0a 00 00 00       	mov    $0xa,%esi
ffff80000010489e:	bf 71 00 00 00       	mov    $0x71,%edi
ffff8000001048a3:	48 b8 0e 45 10 00 00 	movabs $0xffff80000010450e,%rax
ffff8000001048aa:	80 ff ff 
ffff8000001048ad:	ff d0                	callq  *%rax
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
ffff8000001048af:	48 b8 67 04 00 00 00 	movabs $0xffff800000000467,%rax
ffff8000001048b6:	80 ff ff 
ffff8000001048b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  wrv[0] = 0;
ffff8000001048bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001048c1:	66 c7 00 00 00       	movw   $0x0,(%rax)
  wrv[1] = addr >> 4;
ffff8000001048c6:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff8000001048c9:	c1 e8 04             	shr    $0x4,%eax
ffff8000001048cc:	89 c2                	mov    %eax,%edx
ffff8000001048ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001048d2:	48 83 c0 02          	add    $0x2,%rax
ffff8000001048d6:	66 89 10             	mov    %dx,(%rax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
ffff8000001048d9:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffff8000001048dd:	c1 e0 18             	shl    $0x18,%eax
ffff8000001048e0:	89 c6                	mov    %eax,%esi
ffff8000001048e2:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff8000001048e7:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff8000001048ee:	80 ff ff 
ffff8000001048f1:	ff d0                	callq  *%rax
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
ffff8000001048f3:	be 00 c5 00 00       	mov    $0xc500,%esi
ffff8000001048f8:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff8000001048fd:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff800000104904:	80 ff ff 
ffff800000104907:	ff d0                	callq  *%rax
  microdelay(200);
ffff800000104909:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff80000010490e:	48 b8 5d 48 10 00 00 	movabs $0xffff80000010485d,%rax
ffff800000104915:	80 ff ff 
ffff800000104918:	ff d0                	callq  *%rax
  lapicw(ICRLO, INIT | LEVEL);
ffff80000010491a:	be 00 85 00 00       	mov    $0x8500,%esi
ffff80000010491f:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104924:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010492b:	80 ff ff 
ffff80000010492e:	ff d0                	callq  *%rax
  microdelay(100);    // should be 10ms, but too slow in Bochs!
ffff800000104930:	bf 64 00 00 00       	mov    $0x64,%edi
ffff800000104935:	48 b8 5d 48 10 00 00 	movabs $0xffff80000010485d,%rax
ffff80000010493c:	80 ff ff 
ffff80000010493f:	ff d0                	callq  *%rax
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
ffff800000104941:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104948:	eb 4b                	jmp    ffff800000104995 <lapicstartap+0x126>
    lapicw(ICRHI, apicid<<24);
ffff80000010494a:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffff80000010494e:	c1 e0 18             	shl    $0x18,%eax
ffff800000104951:	89 c6                	mov    %eax,%esi
ffff800000104953:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff800000104958:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010495f:	80 ff ff 
ffff800000104962:	ff d0                	callq  *%rax
    lapicw(ICRLO, STARTUP | (addr>>12));
ffff800000104964:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104967:	c1 e8 0c             	shr    $0xc,%eax
ffff80000010496a:	80 cc 06             	or     $0x6,%ah
ffff80000010496d:	89 c6                	mov    %eax,%esi
ffff80000010496f:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104974:	48 b8 4b 45 10 00 00 	movabs $0xffff80000010454b,%rax
ffff80000010497b:	80 ff ff 
ffff80000010497e:	ff d0                	callq  *%rax
    microdelay(200);
ffff800000104980:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104985:	48 b8 5d 48 10 00 00 	movabs $0xffff80000010485d,%rax
ffff80000010498c:	80 ff ff 
ffff80000010498f:	ff d0                	callq  *%rax
  for(i = 0; i < 2; i++){
ffff800000104991:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104995:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff800000104999:	7e af                	jle    ffff80000010494a <lapicstartap+0xdb>
  }
}
ffff80000010499b:	90                   	nop
ffff80000010499c:	90                   	nop
ffff80000010499d:	c9                   	leaveq 
ffff80000010499e:	c3                   	retq   

ffff80000010499f <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
ffff80000010499f:	f3 0f 1e fa          	endbr64 
ffff8000001049a3:	55                   	push   %rbp
ffff8000001049a4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001049a7:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001049ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  outb(CMOS_PORT,  reg);
ffff8000001049ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001049b1:	0f b6 c0             	movzbl %al,%eax
ffff8000001049b4:	89 c6                	mov    %eax,%esi
ffff8000001049b6:	bf 70 00 00 00       	mov    $0x70,%edi
ffff8000001049bb:	48 b8 0e 45 10 00 00 	movabs $0xffff80000010450e,%rax
ffff8000001049c2:	80 ff ff 
ffff8000001049c5:	ff d0                	callq  *%rax
  microdelay(200);
ffff8000001049c7:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff8000001049cc:	48 b8 5d 48 10 00 00 	movabs $0xffff80000010485d,%rax
ffff8000001049d3:	80 ff ff 
ffff8000001049d6:	ff d0                	callq  *%rax

  return inb(CMOS_RETURN);
ffff8000001049d8:	bf 71 00 00 00       	mov    $0x71,%edi
ffff8000001049dd:	48 b8 ec 44 10 00 00 	movabs $0xffff8000001044ec,%rax
ffff8000001049e4:	80 ff ff 
ffff8000001049e7:	ff d0                	callq  *%rax
ffff8000001049e9:	0f b6 c0             	movzbl %al,%eax
}
ffff8000001049ec:	c9                   	leaveq 
ffff8000001049ed:	c3                   	retq   

ffff8000001049ee <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
ffff8000001049ee:	f3 0f 1e fa          	endbr64 
ffff8000001049f2:	55                   	push   %rbp
ffff8000001049f3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001049f6:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001049fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  r->second = cmos_read(SECS);
ffff8000001049fe:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000104a03:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a0a:	80 ff ff 
ffff800000104a0d:	ff d0                	callq  *%rax
ffff800000104a0f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a13:	89 02                	mov    %eax,(%rdx)
  r->minute = cmos_read(MINS);
ffff800000104a15:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000104a1a:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a21:	80 ff ff 
ffff800000104a24:	ff d0                	callq  *%rax
ffff800000104a26:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a2a:	89 42 04             	mov    %eax,0x4(%rdx)
  r->hour   = cmos_read(HOURS);
ffff800000104a2d:	bf 04 00 00 00       	mov    $0x4,%edi
ffff800000104a32:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a39:	80 ff ff 
ffff800000104a3c:	ff d0                	callq  *%rax
ffff800000104a3e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a42:	89 42 08             	mov    %eax,0x8(%rdx)
  r->day    = cmos_read(DAY);
ffff800000104a45:	bf 07 00 00 00       	mov    $0x7,%edi
ffff800000104a4a:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a51:	80 ff ff 
ffff800000104a54:	ff d0                	callq  *%rax
ffff800000104a56:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a5a:	89 42 0c             	mov    %eax,0xc(%rdx)
  r->month  = cmos_read(MONTH);
ffff800000104a5d:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000104a62:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a69:	80 ff ff 
ffff800000104a6c:	ff d0                	callq  *%rax
ffff800000104a6e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a72:	89 42 10             	mov    %eax,0x10(%rdx)
  r->year   = cmos_read(YEAR);
ffff800000104a75:	bf 09 00 00 00       	mov    $0x9,%edi
ffff800000104a7a:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104a81:	80 ff ff 
ffff800000104a84:	ff d0                	callq  *%rax
ffff800000104a86:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104a8a:	89 42 14             	mov    %eax,0x14(%rdx)
}
ffff800000104a8d:	90                   	nop
ffff800000104a8e:	c9                   	leaveq 
ffff800000104a8f:	c3                   	retq   

ffff800000104a90 <cmostime>:
//PAGEBREAK!

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
ffff800000104a90:	f3 0f 1e fa          	endbr64 
ffff800000104a94:	55                   	push   %rbp
ffff800000104a95:	48 89 e5             	mov    %rsp,%rbp
ffff800000104a98:	48 83 ec 50          	sub    $0x50,%rsp
ffff800000104a9c:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
ffff800000104aa0:	bf 0b 00 00 00       	mov    $0xb,%edi
ffff800000104aa5:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104aac:	80 ff ff 
ffff800000104aaf:	ff d0                	callq  *%rax
ffff800000104ab1:	89 45 fc             	mov    %eax,-0x4(%rbp)

  bcd = (sb & (1 << 2)) == 0;
ffff800000104ab4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104ab7:	83 e0 04             	and    $0x4,%eax
ffff800000104aba:	85 c0                	test   %eax,%eax
ffff800000104abc:	0f 94 c0             	sete   %al
ffff800000104abf:	0f b6 c0             	movzbl %al,%eax
ffff800000104ac2:	89 45 f8             	mov    %eax,-0x8(%rbp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
ffff800000104ac5:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000104ac9:	48 89 c7             	mov    %rax,%rdi
ffff800000104acc:	48 b8 ee 49 10 00 00 	movabs $0xffff8000001049ee,%rax
ffff800000104ad3:	80 ff ff 
ffff800000104ad6:	ff d0                	callq  *%rax
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
ffff800000104ad8:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff800000104add:	48 b8 9f 49 10 00 00 	movabs $0xffff80000010499f,%rax
ffff800000104ae4:	80 ff ff 
ffff800000104ae7:	ff d0                	callq  *%rax
ffff800000104ae9:	25 80 00 00 00       	and    $0x80,%eax
ffff800000104aee:	85 c0                	test   %eax,%eax
ffff800000104af0:	75 38                	jne    ffff800000104b2a <cmostime+0x9a>
        continue;
    fill_rtcdate(&t2);
ffff800000104af2:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff800000104af6:	48 89 c7             	mov    %rax,%rdi
ffff800000104af9:	48 b8 ee 49 10 00 00 	movabs $0xffff8000001049ee,%rax
ffff800000104b00:	80 ff ff 
ffff800000104b03:	ff d0                	callq  *%rax
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
ffff800000104b05:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
ffff800000104b09:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000104b0d:	ba 18 00 00 00       	mov    $0x18,%edx
ffff800000104b12:	48 89 ce             	mov    %rcx,%rsi
ffff800000104b15:	48 89 c7             	mov    %rax,%rdi
ffff800000104b18:	48 b8 6b 79 10 00 00 	movabs $0xffff80000010796b,%rax
ffff800000104b1f:	80 ff ff 
ffff800000104b22:	ff d0                	callq  *%rax
ffff800000104b24:	85 c0                	test   %eax,%eax
ffff800000104b26:	74 05                	je     ffff800000104b2d <cmostime+0x9d>
ffff800000104b28:	eb 9b                	jmp    ffff800000104ac5 <cmostime+0x35>
        continue;
ffff800000104b2a:	90                   	nop
    fill_rtcdate(&t1);
ffff800000104b2b:	eb 98                	jmp    ffff800000104ac5 <cmostime+0x35>
      break;
ffff800000104b2d:	90                   	nop
  }

  // convert
  if(bcd) {
ffff800000104b2e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff800000104b32:	0f 84 b4 00 00 00    	je     ffff800000104bec <cmostime+0x15c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
ffff800000104b38:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104b3b:	c1 e8 04             	shr    $0x4,%eax
ffff800000104b3e:	89 c2                	mov    %eax,%edx
ffff800000104b40:	89 d0                	mov    %edx,%eax
ffff800000104b42:	c1 e0 02             	shl    $0x2,%eax
ffff800000104b45:	01 d0                	add    %edx,%eax
ffff800000104b47:	01 c0                	add    %eax,%eax
ffff800000104b49:	89 c2                	mov    %eax,%edx
ffff800000104b4b:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104b4e:	83 e0 0f             	and    $0xf,%eax
ffff800000104b51:	01 d0                	add    %edx,%eax
ffff800000104b53:	89 45 e0             	mov    %eax,-0x20(%rbp)
    CONV(minute);
ffff800000104b56:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104b59:	c1 e8 04             	shr    $0x4,%eax
ffff800000104b5c:	89 c2                	mov    %eax,%edx
ffff800000104b5e:	89 d0                	mov    %edx,%eax
ffff800000104b60:	c1 e0 02             	shl    $0x2,%eax
ffff800000104b63:	01 d0                	add    %edx,%eax
ffff800000104b65:	01 c0                	add    %eax,%eax
ffff800000104b67:	89 c2                	mov    %eax,%edx
ffff800000104b69:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104b6c:	83 e0 0f             	and    $0xf,%eax
ffff800000104b6f:	01 d0                	add    %edx,%eax
ffff800000104b71:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    CONV(hour  );
ffff800000104b74:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104b77:	c1 e8 04             	shr    $0x4,%eax
ffff800000104b7a:	89 c2                	mov    %eax,%edx
ffff800000104b7c:	89 d0                	mov    %edx,%eax
ffff800000104b7e:	c1 e0 02             	shl    $0x2,%eax
ffff800000104b81:	01 d0                	add    %edx,%eax
ffff800000104b83:	01 c0                	add    %eax,%eax
ffff800000104b85:	89 c2                	mov    %eax,%edx
ffff800000104b87:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104b8a:	83 e0 0f             	and    $0xf,%eax
ffff800000104b8d:	01 d0                	add    %edx,%eax
ffff800000104b8f:	89 45 e8             	mov    %eax,-0x18(%rbp)
    CONV(day   );
ffff800000104b92:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104b95:	c1 e8 04             	shr    $0x4,%eax
ffff800000104b98:	89 c2                	mov    %eax,%edx
ffff800000104b9a:	89 d0                	mov    %edx,%eax
ffff800000104b9c:	c1 e0 02             	shl    $0x2,%eax
ffff800000104b9f:	01 d0                	add    %edx,%eax
ffff800000104ba1:	01 c0                	add    %eax,%eax
ffff800000104ba3:	89 c2                	mov    %eax,%edx
ffff800000104ba5:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104ba8:	83 e0 0f             	and    $0xf,%eax
ffff800000104bab:	01 d0                	add    %edx,%eax
ffff800000104bad:	89 45 ec             	mov    %eax,-0x14(%rbp)
    CONV(month );
ffff800000104bb0:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104bb3:	c1 e8 04             	shr    $0x4,%eax
ffff800000104bb6:	89 c2                	mov    %eax,%edx
ffff800000104bb8:	89 d0                	mov    %edx,%eax
ffff800000104bba:	c1 e0 02             	shl    $0x2,%eax
ffff800000104bbd:	01 d0                	add    %edx,%eax
ffff800000104bbf:	01 c0                	add    %eax,%eax
ffff800000104bc1:	89 c2                	mov    %eax,%edx
ffff800000104bc3:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104bc6:	83 e0 0f             	and    $0xf,%eax
ffff800000104bc9:	01 d0                	add    %edx,%eax
ffff800000104bcb:	89 45 f0             	mov    %eax,-0x10(%rbp)
    CONV(year  );
ffff800000104bce:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104bd1:	c1 e8 04             	shr    $0x4,%eax
ffff800000104bd4:	89 c2                	mov    %eax,%edx
ffff800000104bd6:	89 d0                	mov    %edx,%eax
ffff800000104bd8:	c1 e0 02             	shl    $0x2,%eax
ffff800000104bdb:	01 d0                	add    %edx,%eax
ffff800000104bdd:	01 c0                	add    %eax,%eax
ffff800000104bdf:	89 c2                	mov    %eax,%edx
ffff800000104be1:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104be4:	83 e0 0f             	and    $0xf,%eax
ffff800000104be7:	01 d0                	add    %edx,%eax
ffff800000104be9:	89 45 f4             	mov    %eax,-0xc(%rbp)
#undef     CONV
  }

  *r = t1;
ffff800000104bec:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
ffff800000104bf0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000104bf4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000104bf8:	48 89 01             	mov    %rax,(%rcx)
ffff800000104bfb:	48 89 51 08          	mov    %rdx,0x8(%rcx)
ffff800000104bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104c03:	48 89 41 10          	mov    %rax,0x10(%rcx)
  r->year += 2000;
ffff800000104c07:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000104c0b:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000104c0e:	8d 90 d0 07 00 00    	lea    0x7d0(%rax),%edx
ffff800000104c14:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000104c18:	89 50 14             	mov    %edx,0x14(%rax)
}
ffff800000104c1b:	90                   	nop
ffff800000104c1c:	c9                   	leaveq 
ffff800000104c1d:	c3                   	retq   

ffff800000104c1e <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
ffff800000104c1e:	f3 0f 1e fa          	endbr64 
ffff800000104c22:	55                   	push   %rbp
ffff800000104c23:	48 89 e5             	mov    %rsp,%rbp
ffff800000104c26:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000104c2a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
ffff800000104c2d:	48 be 1c c0 10 00 00 	movabs $0xffff80000010c01c,%rsi
ffff800000104c34:	80 ff ff 
ffff800000104c37:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000104c3e:	80 ff ff 
ffff800000104c41:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff800000104c48:	80 ff ff 
ffff800000104c4b:	ff d0                	callq  *%rax
  readsb(dev, &sb);
ffff800000104c4d:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff800000104c51:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104c54:	48 89 d6             	mov    %rdx,%rsi
ffff800000104c57:	89 c7                	mov    %eax,%edi
ffff800000104c59:	48 b8 d1 20 10 00 00 	movabs $0xffff8000001020d1,%rax
ffff800000104c60:	80 ff ff 
ffff800000104c63:	ff d0                	callq  *%rax
  log.start = sb.logstart;
ffff800000104c65:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104c68:	89 c2                	mov    %eax,%edx
ffff800000104c6a:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104c71:	80 ff ff 
ffff800000104c74:	89 50 68             	mov    %edx,0x68(%rax)
  log.size = sb.nlog;
ffff800000104c77:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104c7a:	89 c2                	mov    %eax,%edx
ffff800000104c7c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104c83:	80 ff ff 
ffff800000104c86:	89 50 6c             	mov    %edx,0x6c(%rax)
  log.dev = dev;
ffff800000104c89:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104c90:	80 ff ff 
ffff800000104c93:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104c96:	89 42 78             	mov    %eax,0x78(%rdx)
  recover_from_log();
ffff800000104c99:	48 b8 39 4f 10 00 00 	movabs $0xffff800000104f39,%rax
ffff800000104ca0:	80 ff ff 
ffff800000104ca3:	ff d0                	callq  *%rax
}
ffff800000104ca5:	90                   	nop
ffff800000104ca6:	c9                   	leaveq 
ffff800000104ca7:	c3                   	retq   

ffff800000104ca8 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
ffff800000104ca8:	f3 0f 1e fa          	endbr64 
ffff800000104cac:	55                   	push   %rbp
ffff800000104cad:	48 89 e5             	mov    %rsp,%rbp
ffff800000104cb0:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000104cb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104cbb:	e9 dc 00 00 00       	jmpq   ffff800000104d9c <install_trans+0xf4>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
ffff800000104cc0:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104cc7:	80 ff ff 
ffff800000104cca:	8b 50 68             	mov    0x68(%rax),%edx
ffff800000104ccd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104cd0:	01 d0                	add    %edx,%eax
ffff800000104cd2:	83 c0 01             	add    $0x1,%eax
ffff800000104cd5:	89 c2                	mov    %eax,%edx
ffff800000104cd7:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104cde:	80 ff ff 
ffff800000104ce1:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104ce4:	89 d6                	mov    %edx,%esi
ffff800000104ce6:	89 c7                	mov    %eax,%edi
ffff800000104ce8:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000104cef:	80 ff ff 
ffff800000104cf2:	ff d0                	callq  *%rax
ffff800000104cf4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
ffff800000104cf8:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104cff:	80 ff ff 
ffff800000104d02:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104d05:	48 63 d2             	movslq %edx,%rdx
ffff800000104d08:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000104d0c:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff800000104d10:	89 c2                	mov    %eax,%edx
ffff800000104d12:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104d19:	80 ff ff 
ffff800000104d1c:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104d1f:	89 d6                	mov    %edx,%esi
ffff800000104d21:	89 c7                	mov    %eax,%edi
ffff800000104d23:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000104d2a:	80 ff ff 
ffff800000104d2d:	ff d0                	callq  *%rax
ffff800000104d2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
ffff800000104d33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104d37:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff800000104d3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104d42:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104d48:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000104d4d:	48 89 ce             	mov    %rcx,%rsi
ffff800000104d50:	48 89 c7             	mov    %rax,%rdi
ffff800000104d53:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff800000104d5a:	80 ff ff 
ffff800000104d5d:	ff d0                	callq  *%rax
    bwrite(dbuf);  // write dst to disk
ffff800000104d5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104d63:	48 89 c7             	mov    %rax,%rdi
ffff800000104d66:	48 b8 10 04 10 00 00 	movabs $0xffff800000100410,%rax
ffff800000104d6d:	80 ff ff 
ffff800000104d70:	ff d0                	callq  *%rax
    brelse(lbuf);
ffff800000104d72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104d76:	48 89 c7             	mov    %rax,%rdi
ffff800000104d79:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000104d80:	80 ff ff 
ffff800000104d83:	ff d0                	callq  *%rax
    brelse(dbuf);
ffff800000104d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104d89:	48 89 c7             	mov    %rax,%rdi
ffff800000104d8c:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000104d93:	80 ff ff 
ffff800000104d96:	ff d0                	callq  *%rax
  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000104d98:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104d9c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104da3:	80 ff ff 
ffff800000104da6:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104da9:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104dac:	0f 8c 0e ff ff ff    	jl     ffff800000104cc0 <install_trans+0x18>
  }
}
ffff800000104db2:	90                   	nop
ffff800000104db3:	90                   	nop
ffff800000104db4:	c9                   	leaveq 
ffff800000104db5:	c3                   	retq   

ffff800000104db6 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
ffff800000104db6:	f3 0f 1e fa          	endbr64 
ffff800000104dba:	55                   	push   %rbp
ffff800000104dbb:	48 89 e5             	mov    %rsp,%rbp
ffff800000104dbe:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffff800000104dc2:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104dc9:	80 ff ff 
ffff800000104dcc:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104dcf:	89 c2                	mov    %eax,%edx
ffff800000104dd1:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104dd8:	80 ff ff 
ffff800000104ddb:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104dde:	89 d6                	mov    %edx,%esi
ffff800000104de0:	89 c7                	mov    %eax,%edi
ffff800000104de2:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000104de9:	80 ff ff 
ffff800000104dec:	ff d0                	callq  *%rax
ffff800000104dee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *lh = (struct logheader *) (buf->data);
ffff800000104df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104df6:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104dfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  log.lh.n = lh->n;
ffff800000104e00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104e04:	8b 00                	mov    (%rax),%eax
ffff800000104e06:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104e0d:	80 ff ff 
ffff800000104e10:	89 42 7c             	mov    %eax,0x7c(%rdx)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104e13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104e1a:	eb 2a                	jmp    ffff800000104e46 <read_head+0x90>
    log.lh.block[i] = lh->block[i];
ffff800000104e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104e20:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104e23:	48 63 d2             	movslq %edx,%rdx
ffff800000104e26:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffff800000104e2a:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104e31:	80 ff ff 
ffff800000104e34:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000104e37:	48 63 c9             	movslq %ecx,%rcx
ffff800000104e3a:	48 83 c1 1c          	add    $0x1c,%rcx
ffff800000104e3e:	89 44 8a 10          	mov    %eax,0x10(%rdx,%rcx,4)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104e42:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104e46:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104e4d:	80 ff ff 
ffff800000104e50:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104e53:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104e56:	7c c4                	jl     ffff800000104e1c <read_head+0x66>
  }
  brelse(buf);
ffff800000104e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104e5c:	48 89 c7             	mov    %rax,%rdi
ffff800000104e5f:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000104e66:	80 ff ff 
ffff800000104e69:	ff d0                	callq  *%rax
}
ffff800000104e6b:	90                   	nop
ffff800000104e6c:	c9                   	leaveq 
ffff800000104e6d:	c3                   	retq   

ffff800000104e6e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
ffff800000104e6e:	f3 0f 1e fa          	endbr64 
ffff800000104e72:	55                   	push   %rbp
ffff800000104e73:	48 89 e5             	mov    %rsp,%rbp
ffff800000104e76:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffff800000104e7a:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104e81:	80 ff ff 
ffff800000104e84:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104e87:	89 c2                	mov    %eax,%edx
ffff800000104e89:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104e90:	80 ff ff 
ffff800000104e93:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104e96:	89 d6                	mov    %edx,%esi
ffff800000104e98:	89 c7                	mov    %eax,%edi
ffff800000104e9a:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000104ea1:	80 ff ff 
ffff800000104ea4:	ff d0                	callq  *%rax
ffff800000104ea6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *hb = (struct logheader *) (buf->data);
ffff800000104eaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104eae:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104eb4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  hb->n = log.lh.n;
ffff800000104eb8:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104ebf:	80 ff ff 
ffff800000104ec2:	8b 50 7c             	mov    0x7c(%rax),%edx
ffff800000104ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104ec9:	89 10                	mov    %edx,(%rax)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104ecb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104ed2:	eb 2a                	jmp    ffff800000104efe <write_head+0x90>
    hb->block[i] = log.lh.block[i];
ffff800000104ed4:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104edb:	80 ff ff 
ffff800000104ede:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104ee1:	48 63 d2             	movslq %edx,%rdx
ffff800000104ee4:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000104ee8:	8b 4c 90 10          	mov    0x10(%rax,%rdx,4),%ecx
ffff800000104eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104ef0:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104ef3:	48 63 d2             	movslq %edx,%rdx
ffff800000104ef6:	89 4c 90 04          	mov    %ecx,0x4(%rax,%rdx,4)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104efa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104efe:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f05:	80 ff ff 
ffff800000104f08:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104f0b:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104f0e:	7c c4                	jl     ffff800000104ed4 <write_head+0x66>
  }
  bwrite(buf);
ffff800000104f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104f14:	48 89 c7             	mov    %rax,%rdi
ffff800000104f17:	48 b8 10 04 10 00 00 	movabs $0xffff800000100410,%rax
ffff800000104f1e:	80 ff ff 
ffff800000104f21:	ff d0                	callq  *%rax
  brelse(buf);
ffff800000104f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104f27:	48 89 c7             	mov    %rax,%rdi
ffff800000104f2a:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff800000104f31:	80 ff ff 
ffff800000104f34:	ff d0                	callq  *%rax
}
ffff800000104f36:	90                   	nop
ffff800000104f37:	c9                   	leaveq 
ffff800000104f38:	c3                   	retq   

ffff800000104f39 <recover_from_log>:

static void
recover_from_log(void)
{
ffff800000104f39:	f3 0f 1e fa          	endbr64 
ffff800000104f3d:	55                   	push   %rbp
ffff800000104f3e:	48 89 e5             	mov    %rsp,%rbp
  read_head();
ffff800000104f41:	48 b8 b6 4d 10 00 00 	movabs $0xffff800000104db6,%rax
ffff800000104f48:	80 ff ff 
ffff800000104f4b:	ff d0                	callq  *%rax
  install_trans(); // if committed, copy from log to disk
ffff800000104f4d:	48 b8 a8 4c 10 00 00 	movabs $0xffff800000104ca8,%rax
ffff800000104f54:	80 ff ff 
ffff800000104f57:	ff d0                	callq  *%rax
  log.lh.n = 0;
ffff800000104f59:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f60:	80 ff ff 
ffff800000104f63:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%rax)
  write_head(); // clear the log
ffff800000104f6a:	48 b8 6e 4e 10 00 00 	movabs $0xffff800000104e6e,%rax
ffff800000104f71:	80 ff ff 
ffff800000104f74:	ff d0                	callq  *%rax
}
ffff800000104f76:	90                   	nop
ffff800000104f77:	5d                   	pop    %rbp
ffff800000104f78:	c3                   	retq   

ffff800000104f79 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
ffff800000104f79:	f3 0f 1e fa          	endbr64 
ffff800000104f7d:	55                   	push   %rbp
ffff800000104f7e:	48 89 e5             	mov    %rsp,%rbp
  acquire(&log.lock);
ffff800000104f81:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000104f88:	80 ff ff 
ffff800000104f8b:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000104f92:	80 ff ff 
ffff800000104f95:	ff d0                	callq  *%rax
  while(1){
    if(log.committing){
ffff800000104f97:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f9e:	80 ff ff 
ffff800000104fa1:	8b 40 74             	mov    0x74(%rax),%eax
ffff800000104fa4:	85 c0                	test   %eax,%eax
ffff800000104fa6:	74 22                	je     ffff800000104fca <begin_op+0x51>
      sleep(&log, &log.lock);
ffff800000104fa8:	48 be e0 71 11 00 00 	movabs $0xffff8000001171e0,%rsi
ffff800000104faf:	80 ff ff 
ffff800000104fb2:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000104fb9:	80 ff ff 
ffff800000104fbc:	48 b8 15 6f 10 00 00 	movabs $0xffff800000106f15,%rax
ffff800000104fc3:	80 ff ff 
ffff800000104fc6:	ff d0                	callq  *%rax
ffff800000104fc8:	eb cd                	jmp    ffff800000104f97 <begin_op+0x1e>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
ffff800000104fca:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104fd1:	80 ff ff 
ffff800000104fd4:	8b 48 7c             	mov    0x7c(%rax),%ecx
ffff800000104fd7:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104fde:	80 ff ff 
ffff800000104fe1:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000104fe4:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000104fe7:	89 d0                	mov    %edx,%eax
ffff800000104fe9:	c1 e0 02             	shl    $0x2,%eax
ffff800000104fec:	01 d0                	add    %edx,%eax
ffff800000104fee:	01 c0                	add    %eax,%eax
ffff800000104ff0:	01 c8                	add    %ecx,%eax
ffff800000104ff2:	83 f8 1e             	cmp    $0x1e,%eax
ffff800000104ff5:	7e 25                	jle    ffff80000010501c <begin_op+0xa3>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
ffff800000104ff7:	48 be e0 71 11 00 00 	movabs $0xffff8000001171e0,%rsi
ffff800000104ffe:	80 ff ff 
ffff800000105001:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105008:	80 ff ff 
ffff80000010500b:	48 b8 15 6f 10 00 00 	movabs $0xffff800000106f15,%rax
ffff800000105012:	80 ff ff 
ffff800000105015:	ff d0                	callq  *%rax
ffff800000105017:	e9 7b ff ff ff       	jmpq   ffff800000104f97 <begin_op+0x1e>
    } else {
      log.outstanding += 1;
ffff80000010501c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105023:	80 ff ff 
ffff800000105026:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105029:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010502c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105033:	80 ff ff 
ffff800000105036:	89 50 70             	mov    %edx,0x70(%rax)
      release(&log.lock);
ffff800000105039:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105040:	80 ff ff 
ffff800000105043:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010504a:	80 ff ff 
ffff80000010504d:	ff d0                	callq  *%rax
      break;
ffff80000010504f:	90                   	nop
    }
  }
}
ffff800000105050:	90                   	nop
ffff800000105051:	5d                   	pop    %rbp
ffff800000105052:	c3                   	retq   

ffff800000105053 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
ffff800000105053:	f3 0f 1e fa          	endbr64 
ffff800000105057:	55                   	push   %rbp
ffff800000105058:	48 89 e5             	mov    %rsp,%rbp
ffff80000010505b:	48 83 ec 10          	sub    $0x10,%rsp
  int do_commit = 0;
ffff80000010505f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  acquire(&log.lock);
ffff800000105066:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff80000010506d:	80 ff ff 
ffff800000105070:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000105077:	80 ff ff 
ffff80000010507a:	ff d0                	callq  *%rax
  log.outstanding -= 1;
ffff80000010507c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105083:	80 ff ff 
ffff800000105086:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105089:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff80000010508c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105093:	80 ff ff 
ffff800000105096:	89 50 70             	mov    %edx,0x70(%rax)
  if(log.committing)
ffff800000105099:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001050a0:	80 ff ff 
ffff8000001050a3:	8b 40 74             	mov    0x74(%rax),%eax
ffff8000001050a6:	85 c0                	test   %eax,%eax
ffff8000001050a8:	74 16                	je     ffff8000001050c0 <end_op+0x6d>
    panic("log.committing");
ffff8000001050aa:	48 bf 20 c0 10 00 00 	movabs $0xffff80000010c020,%rdi
ffff8000001050b1:	80 ff ff 
ffff8000001050b4:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001050bb:	80 ff ff 
ffff8000001050be:	ff d0                	callq  *%rax
  if(log.outstanding == 0){
ffff8000001050c0:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001050c7:	80 ff ff 
ffff8000001050ca:	8b 40 70             	mov    0x70(%rax),%eax
ffff8000001050cd:	85 c0                	test   %eax,%eax
ffff8000001050cf:	75 1a                	jne    ffff8000001050eb <end_op+0x98>
    do_commit = 1;
ffff8000001050d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    log.committing = 1;
ffff8000001050d8:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001050df:	80 ff ff 
ffff8000001050e2:	c7 40 74 01 00 00 00 	movl   $0x1,0x74(%rax)
ffff8000001050e9:	eb 16                	jmp    ffff800000105101 <end_op+0xae>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
ffff8000001050eb:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff8000001050f2:	80 ff ff 
ffff8000001050f5:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff8000001050fc:	80 ff ff 
ffff8000001050ff:	ff d0                	callq  *%rax
  }
  release(&log.lock);
ffff800000105101:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105108:	80 ff ff 
ffff80000010510b:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000105112:	80 ff ff 
ffff800000105115:	ff d0                	callq  *%rax

  if(do_commit){
ffff800000105117:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010511b:	74 64                	je     ffff800000105181 <end_op+0x12e>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
ffff80000010511d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105122:	48 ba 92 52 10 00 00 	movabs $0xffff800000105292,%rdx
ffff800000105129:	80 ff ff 
ffff80000010512c:	ff d2                	callq  *%rdx
    acquire(&log.lock);
ffff80000010512e:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105135:	80 ff ff 
ffff800000105138:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff80000010513f:	80 ff ff 
ffff800000105142:	ff d0                	callq  *%rax
    log.committing = 0;
ffff800000105144:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010514b:	80 ff ff 
ffff80000010514e:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%rax)
    wakeup(&log);
ffff800000105155:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff80000010515c:	80 ff ff 
ffff80000010515f:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff800000105166:	80 ff ff 
ffff800000105169:	ff d0                	callq  *%rax
    release(&log.lock);
ffff80000010516b:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105172:	80 ff ff 
ffff800000105175:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010517c:	80 ff ff 
ffff80000010517f:	ff d0                	callq  *%rax
  }
}
ffff800000105181:	90                   	nop
ffff800000105182:	c9                   	leaveq 
ffff800000105183:	c3                   	retq   

ffff800000105184 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
ffff800000105184:	f3 0f 1e fa          	endbr64 
ffff800000105188:	55                   	push   %rbp
ffff800000105189:	48 89 e5             	mov    %rsp,%rbp
ffff80000010518c:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000105190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000105197:	e9 dc 00 00 00       	jmpq   ffff800000105278 <write_log+0xf4>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
ffff80000010519c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001051a3:	80 ff ff 
ffff8000001051a6:	8b 50 68             	mov    0x68(%rax),%edx
ffff8000001051a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001051ac:	01 d0                	add    %edx,%eax
ffff8000001051ae:	83 c0 01             	add    $0x1,%eax
ffff8000001051b1:	89 c2                	mov    %eax,%edx
ffff8000001051b3:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001051ba:	80 ff ff 
ffff8000001051bd:	8b 40 78             	mov    0x78(%rax),%eax
ffff8000001051c0:	89 d6                	mov    %edx,%esi
ffff8000001051c2:	89 c7                	mov    %eax,%edi
ffff8000001051c4:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff8000001051cb:	80 ff ff 
ffff8000001051ce:	ff d0                	callq  *%rax
ffff8000001051d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
ffff8000001051d4:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001051db:	80 ff ff 
ffff8000001051de:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001051e1:	48 63 d2             	movslq %edx,%rdx
ffff8000001051e4:	48 83 c2 1c          	add    $0x1c,%rdx
ffff8000001051e8:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff8000001051ec:	89 c2                	mov    %eax,%edx
ffff8000001051ee:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001051f5:	80 ff ff 
ffff8000001051f8:	8b 40 78             	mov    0x78(%rax),%eax
ffff8000001051fb:	89 d6                	mov    %edx,%esi
ffff8000001051fd:	89 c7                	mov    %eax,%edi
ffff8000001051ff:	48 b8 be 03 10 00 00 	movabs $0xffff8000001003be,%rax
ffff800000105206:	80 ff ff 
ffff800000105209:	ff d0                	callq  *%rax
ffff80000010520b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(to->data, from->data, BSIZE);
ffff80000010520f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105213:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff80000010521a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010521e:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000105224:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000105229:	48 89 ce             	mov    %rcx,%rsi
ffff80000010522c:	48 89 c7             	mov    %rax,%rdi
ffff80000010522f:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff800000105236:	80 ff ff 
ffff800000105239:	ff d0                	callq  *%rax
    bwrite(to);  // write the log
ffff80000010523b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010523f:	48 89 c7             	mov    %rax,%rdi
ffff800000105242:	48 b8 10 04 10 00 00 	movabs $0xffff800000100410,%rax
ffff800000105249:	80 ff ff 
ffff80000010524c:	ff d0                	callq  *%rax
    brelse(from);
ffff80000010524e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105252:	48 89 c7             	mov    %rax,%rdi
ffff800000105255:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff80000010525c:	80 ff ff 
ffff80000010525f:	ff d0                	callq  *%rax
    brelse(to);
ffff800000105261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105265:	48 89 c7             	mov    %rax,%rdi
ffff800000105268:	48 b8 78 04 10 00 00 	movabs $0xffff800000100478,%rax
ffff80000010526f:	80 ff ff 
ffff800000105272:	ff d0                	callq  *%rax
  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000105274:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105278:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010527f:	80 ff ff 
ffff800000105282:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000105285:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000105288:	0f 8c 0e ff ff ff    	jl     ffff80000010519c <write_log+0x18>
  }
}
ffff80000010528e:	90                   	nop
ffff80000010528f:	90                   	nop
ffff800000105290:	c9                   	leaveq 
ffff800000105291:	c3                   	retq   

ffff800000105292 <commit>:

static void
commit()
{
ffff800000105292:	f3 0f 1e fa          	endbr64 
ffff800000105296:	55                   	push   %rbp
ffff800000105297:	48 89 e5             	mov    %rsp,%rbp
  if (log.lh.n > 0) {
ffff80000010529a:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001052a1:	80 ff ff 
ffff8000001052a4:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001052a7:	85 c0                	test   %eax,%eax
ffff8000001052a9:	7e 41                	jle    ffff8000001052ec <commit+0x5a>
    write_log();     // Write modified blocks from cache to log
ffff8000001052ab:	48 b8 84 51 10 00 00 	movabs $0xffff800000105184,%rax
ffff8000001052b2:	80 ff ff 
ffff8000001052b5:	ff d0                	callq  *%rax
    write_head();    // Write header to disk -- the real commit
ffff8000001052b7:	48 b8 6e 4e 10 00 00 	movabs $0xffff800000104e6e,%rax
ffff8000001052be:	80 ff ff 
ffff8000001052c1:	ff d0                	callq  *%rax
    install_trans(); // Now install writes to home locations
ffff8000001052c3:	48 b8 a8 4c 10 00 00 	movabs $0xffff800000104ca8,%rax
ffff8000001052ca:	80 ff ff 
ffff8000001052cd:	ff d0                	callq  *%rax
    log.lh.n = 0;
ffff8000001052cf:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001052d6:	80 ff ff 
ffff8000001052d9:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%rax)
    write_head();    // Erase the transaction from the log
ffff8000001052e0:	48 b8 6e 4e 10 00 00 	movabs $0xffff800000104e6e,%rax
ffff8000001052e7:	80 ff ff 
ffff8000001052ea:	ff d0                	callq  *%rax
  }
}
ffff8000001052ec:	90                   	nop
ffff8000001052ed:	5d                   	pop    %rbp
ffff8000001052ee:	c3                   	retq   

ffff8000001052ef <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
ffff8000001052ef:	f3 0f 1e fa          	endbr64 
ffff8000001052f3:	55                   	push   %rbp
ffff8000001052f4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001052f7:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001052fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
ffff8000001052ff:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105306:	80 ff ff 
ffff800000105309:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010530c:	83 f8 1d             	cmp    $0x1d,%eax
ffff80000010530f:	7f 21                	jg     ffff800000105332 <log_write+0x43>
ffff800000105311:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105318:	80 ff ff 
ffff80000010531b:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010531e:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000105325:	80 ff ff 
ffff800000105328:	8b 52 6c             	mov    0x6c(%rdx),%edx
ffff80000010532b:	83 ea 01             	sub    $0x1,%edx
ffff80000010532e:	39 d0                	cmp    %edx,%eax
ffff800000105330:	7c 16                	jl     ffff800000105348 <log_write+0x59>
    panic("too big a transaction");
ffff800000105332:	48 bf 2f c0 10 00 00 	movabs $0xffff80000010c02f,%rdi
ffff800000105339:	80 ff ff 
ffff80000010533c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000105343:	80 ff ff 
ffff800000105346:	ff d0                	callq  *%rax
  if (log.outstanding < 1)
ffff800000105348:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010534f:	80 ff ff 
ffff800000105352:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105355:	85 c0                	test   %eax,%eax
ffff800000105357:	7f 16                	jg     ffff80000010536f <log_write+0x80>
    panic("log_write outside of trans");
ffff800000105359:	48 bf 45 c0 10 00 00 	movabs $0xffff80000010c045,%rdi
ffff800000105360:	80 ff ff 
ffff800000105363:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010536a:	80 ff ff 
ffff80000010536d:	ff d0                	callq  *%rax

  acquire(&log.lock);
ffff80000010536f:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105376:	80 ff ff 
ffff800000105379:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000105380:	80 ff ff 
ffff800000105383:	ff d0                	callq  *%rax
  for (i = 0; i < log.lh.n; i++) {
ffff800000105385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010538c:	eb 29                	jmp    ffff8000001053b7 <log_write+0xc8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
ffff80000010538e:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105395:	80 ff ff 
ffff800000105398:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010539b:	48 63 d2             	movslq %edx,%rdx
ffff80000010539e:	48 83 c2 1c          	add    $0x1c,%rdx
ffff8000001053a2:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff8000001053a6:	89 c2                	mov    %eax,%edx
ffff8000001053a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001053ac:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001053af:	39 c2                	cmp    %eax,%edx
ffff8000001053b1:	74 18                	je     ffff8000001053cb <log_write+0xdc>
  for (i = 0; i < log.lh.n; i++) {
ffff8000001053b3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001053b7:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001053be:	80 ff ff 
ffff8000001053c1:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001053c4:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff8000001053c7:	7c c5                	jl     ffff80000010538e <log_write+0x9f>
ffff8000001053c9:	eb 01                	jmp    ffff8000001053cc <log_write+0xdd>
      break;
ffff8000001053cb:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
ffff8000001053cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001053d0:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001053d3:	89 c1                	mov    %eax,%ecx
ffff8000001053d5:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001053dc:	80 ff ff 
ffff8000001053df:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001053e2:	48 63 d2             	movslq %edx,%rdx
ffff8000001053e5:	48 83 c2 1c          	add    $0x1c,%rdx
ffff8000001053e9:	89 4c 90 10          	mov    %ecx,0x10(%rax,%rdx,4)
  if (i == log.lh.n)
ffff8000001053ed:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001053f4:	80 ff ff 
ffff8000001053f7:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001053fa:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff8000001053fd:	75 1d                	jne    ffff80000010541c <log_write+0x12d>
    log.lh.n++;
ffff8000001053ff:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105406:	80 ff ff 
ffff800000105409:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010540c:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010540f:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105416:	80 ff ff 
ffff800000105419:	89 50 7c             	mov    %edx,0x7c(%rax)
  b->flags |= B_DIRTY; // prevent eviction
ffff80000010541c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105420:	8b 00                	mov    (%rax),%eax
ffff800000105422:	83 c8 04             	or     $0x4,%eax
ffff800000105425:	89 c2                	mov    %eax,%edx
ffff800000105427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010542b:	89 10                	mov    %edx,(%rax)
  release(&log.lock);
ffff80000010542d:	48 bf e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdi
ffff800000105434:	80 ff ff 
ffff800000105437:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010543e:	80 ff ff 
ffff800000105441:	ff d0                	callq  *%rax
}
ffff800000105443:	90                   	nop
ffff800000105444:	c9                   	leaveq 
ffff800000105445:	c3                   	retq   

ffff800000105446 <v2p>:
#define KERNBASE 0xFFFF800000000000 // First kernel virtual address

#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__
static inline addr_t v2p(void *a) {
ffff800000105446:	f3 0f 1e fa          	endbr64 
ffff80000010544a:	55                   	push   %rbp
ffff80000010544b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010544e:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000105452:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return ((addr_t) (a)) - ((addr_t)KERNBASE);
ffff800000105456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010545a:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff800000105461:	80 00 00 
ffff800000105464:	48 01 d0             	add    %rdx,%rax
}
ffff800000105467:	c9                   	leaveq 
ffff800000105468:	c3                   	retq   

ffff800000105469 <xchg>:

static inline uint
xchg(volatile uint *addr, addr_t newval)
{
ffff800000105469:	f3 0f 1e fa          	endbr64 
ffff80000010546d:	55                   	push   %rbp
ffff80000010546e:	48 89 e5             	mov    %rsp,%rbp
ffff800000105471:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105475:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105479:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
ffff80000010547d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000105481:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105485:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000105489:	f0 87 02             	lock xchg %eax,(%rdx)
ffff80000010548c:	89 45 fc             	mov    %eax,-0x4(%rbp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
ffff80000010548f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000105492:	c9                   	leaveq 
ffff800000105493:	c3                   	retq   

ffff800000105494 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
ffff800000105494:	f3 0f 1e fa          	endbr64 
ffff800000105498:	55                   	push   %rbp
ffff800000105499:	48 89 e5             	mov    %rsp,%rbp
  uartearlyinit();
ffff80000010549c:	48 b8 4b 9c 10 00 00 	movabs $0xffff800000109c4b,%rax
ffff8000001054a3:	80 ff ff 
ffff8000001054a6:	ff d0                	callq  *%rax
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
ffff8000001054a8:	48 be 00 00 40 00 00 	movabs $0xffff800000400000,%rsi
ffff8000001054af:	80 ff ff 
ffff8000001054b2:	48 bf 00 b0 11 00 00 	movabs $0xffff80000011b000,%rdi
ffff8000001054b9:	80 ff ff 
ffff8000001054bc:	48 b8 3d 40 10 00 00 	movabs $0xffff80000010403d,%rax
ffff8000001054c3:	80 ff ff 
ffff8000001054c6:	ff d0                	callq  *%rax
  kvmalloc();      // kernel page table
ffff8000001054c8:	48 b8 fd ae 10 00 00 	movabs $0xffff80000010aefd,%rax
ffff8000001054cf:	80 ff ff 
ffff8000001054d2:	ff d0                	callq  *%rax
  mpinit();        // detect other processors
ffff8000001054d4:	48 b8 b7 5a 10 00 00 	movabs $0xffff800000105ab7,%rax
ffff8000001054db:	80 ff ff 
ffff8000001054de:	ff d0                	callq  *%rax
  lapicinit();     // interrupt controller
ffff8000001054e0:	48 b8 92 45 10 00 00 	movabs $0xffff800000104592,%rax
ffff8000001054e7:	80 ff ff 
ffff8000001054ea:	ff d0                	callq  *%rax
  tvinit();        // trap vectors
ffff8000001054ec:	48 b8 bf 97 10 00 00 	movabs $0xffff8000001097bf,%rax
ffff8000001054f3:	80 ff ff 
ffff8000001054f6:	ff d0                	callq  *%rax
  seginit();       // segment descriptors
ffff8000001054f8:	48 b8 3a aa 10 00 00 	movabs $0xffff80000010aa3a,%rax
ffff8000001054ff:	80 ff ff 
ffff800000105502:	ff d0                	callq  *%rax
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
ffff800000105504:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff80000010550b:	80 ff ff 
ffff80000010550e:	ff d0                	callq  *%rax
ffff800000105510:	89 c6                	mov    %eax,%esi
ffff800000105512:	48 bf 60 c0 10 00 00 	movabs $0xffff80000010c060,%rdi
ffff800000105519:	80 ff ff 
ffff80000010551c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105521:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000105528:	80 ff ff 
ffff80000010552b:	ff d2                	callq  *%rdx
  ioapicinit();    // another interrupt controller
ffff80000010552d:	48 b8 03 3f 10 00 00 	movabs $0xffff800000103f03,%rax
ffff800000105534:	80 ff ff 
ffff800000105537:	ff d0                	callq  *%rax
  consoleinit();   // console hardware
ffff800000105539:	48 b8 9b 14 10 00 00 	movabs $0xffff80000010149b,%rax
ffff800000105540:	80 ff ff 
ffff800000105543:	ff d0                	callq  *%rax
  uartinit();      // serial port
ffff800000105545:	48 b8 53 9d 10 00 00 	movabs $0xffff800000109d53,%rax
ffff80000010554c:	80 ff ff 
ffff80000010554f:	ff d0                	callq  *%rax
  pinit();         // process table
ffff800000105551:	48 b8 0b 62 10 00 00 	movabs $0xffff80000010620b,%rax
ffff800000105558:	80 ff ff 
ffff80000010555b:	ff d0                	callq  *%rax
  binit();         // buffer cache
ffff80000010555d:	48 b8 1a 01 10 00 00 	movabs $0xffff80000010011a,%rax
ffff800000105564:	80 ff ff 
ffff800000105567:	ff d0                	callq  *%rax
  fileinit();      // file table
ffff800000105569:	48 b8 59 1b 10 00 00 	movabs $0xffff800000101b59,%rax
ffff800000105570:	80 ff ff 
ffff800000105573:	ff d0                	callq  *%rax
  ideinit();       // disk
ffff800000105575:	48 b8 66 39 10 00 00 	movabs $0xffff800000103966,%rax
ffff80000010557c:	80 ff ff 
ffff80000010557f:	ff d0                	callq  *%rax
  startothers();   // start other processors
ffff800000105581:	48 b8 75 56 10 00 00 	movabs $0xffff800000105675,%rax
ffff800000105588:	80 ff ff 
ffff80000010558b:	ff d0                	callq  *%rax
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
ffff80000010558d:	48 be 00 00 00 0e 00 	movabs $0xffff80000e000000,%rsi
ffff800000105594:	80 ff ff 
ffff800000105597:	48 bf 00 00 40 00 00 	movabs $0xffff800000400000,%rdi
ffff80000010559e:	80 ff ff 
ffff8000001055a1:	48 b8 9f 40 10 00 00 	movabs $0xffff80000010409f,%rax
ffff8000001055a8:	80 ff ff 
ffff8000001055ab:	ff d0                	callq  *%rax
  userinit();      // first user process
ffff8000001055ad:	48 b8 b3 63 10 00 00 	movabs $0xffff8000001063b3,%rax
ffff8000001055b4:	80 ff ff 
ffff8000001055b7:	ff d0                	callq  *%rax
  mpmain();        // finish this processor's setup
ffff8000001055b9:	48 b8 fd 55 10 00 00 	movabs $0xffff8000001055fd,%rax
ffff8000001055c0:	80 ff ff 
ffff8000001055c3:	ff d0                	callq  *%rax

ffff8000001055c5 <mpenter>:
}

// Other CPUs jump here from entryother.S.
void
mpenter(void)
{
ffff8000001055c5:	f3 0f 1e fa          	endbr64 
ffff8000001055c9:	55                   	push   %rbp
ffff8000001055ca:	48 89 e5             	mov    %rsp,%rbp
  switchkvm();
ffff8000001055cd:	48 b8 07 b3 10 00 00 	movabs $0xffff80000010b307,%rax
ffff8000001055d4:	80 ff ff 
ffff8000001055d7:	ff d0                	callq  *%rax
  seginit();
ffff8000001055d9:	48 b8 3a aa 10 00 00 	movabs $0xffff80000010aa3a,%rax
ffff8000001055e0:	80 ff ff 
ffff8000001055e3:	ff d0                	callq  *%rax
  lapicinit();
ffff8000001055e5:	48 b8 92 45 10 00 00 	movabs $0xffff800000104592,%rax
ffff8000001055ec:	80 ff ff 
ffff8000001055ef:	ff d0                	callq  *%rax
  mpmain();
ffff8000001055f1:	48 b8 fd 55 10 00 00 	movabs $0xffff8000001055fd,%rax
ffff8000001055f8:	80 ff ff 
ffff8000001055fb:	ff d0                	callq  *%rax

ffff8000001055fd <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
ffff8000001055fd:	f3 0f 1e fa          	endbr64 
ffff800000105601:	55                   	push   %rbp
ffff800000105602:	48 89 e5             	mov    %rsp,%rbp
  cprintf("cpu%d: starting\n", cpunum());
ffff800000105605:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff80000010560c:	80 ff ff 
ffff80000010560f:	ff d0                	callq  *%rax
ffff800000105611:	89 c6                	mov    %eax,%esi
ffff800000105613:	48 bf 77 c0 10 00 00 	movabs $0xffff80000010c077,%rdi
ffff80000010561a:	80 ff ff 
ffff80000010561d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105622:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000105629:	80 ff ff 
ffff80000010562c:	ff d2                	callq  *%rdx
  idtinit();       // load idt register
ffff80000010562e:	48 b8 93 97 10 00 00 	movabs $0xffff800000109793,%rax
ffff800000105635:	80 ff ff 
ffff800000105638:	ff d0                	callq  *%rax
  syscallinit();   // syscall set up
ffff80000010563a:	48 b8 c2 a9 10 00 00 	movabs $0xffff80000010a9c2,%rax
ffff800000105641:	80 ff ff 
ffff800000105644:	ff d0                	callq  *%rax
  xchg(&cpu->started, 1); // tell startothers() we're up
ffff800000105646:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff80000010564d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000105651:	48 83 c0 10          	add    $0x10,%rax
ffff800000105655:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010565a:	48 89 c7             	mov    %rax,%rdi
ffff80000010565d:	48 b8 69 54 10 00 00 	movabs $0xffff800000105469,%rax
ffff800000105664:	80 ff ff 
ffff800000105667:	ff d0                	callq  *%rax
  scheduler();     // start running processes
ffff800000105669:	48 b8 1a 6c 10 00 00 	movabs $0xffff800000106c1a,%rax
ffff800000105670:	80 ff ff 
ffff800000105673:	ff d0                	callq  *%rax

ffff800000105675 <startothers>:
void entry32mp(void);

// Start the non-boot (AP) processors.
static void
startothers(void)
{
ffff800000105675:	f3 0f 1e fa          	endbr64 
ffff800000105679:	55                   	push   %rbp
ffff80000010567a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010567d:	48 83 ec 20          	sub    $0x20,%rsp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
ffff800000105681:	48 b8 00 70 00 00 00 	movabs $0xffff800000007000,%rax
ffff800000105688:	80 ff ff 
ffff80000010568b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  memmove(code, _binary_entryother_start,
ffff80000010568f:	48 b8 72 00 00 00 00 	movabs $0x72,%rax
ffff800000105696:	00 00 00 
ffff800000105699:	89 c2                	mov    %eax,%edx
ffff80000010569b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010569f:	48 be 8c de 10 00 00 	movabs $0xffff80000010de8c,%rsi
ffff8000001056a6:	80 ff ff 
ffff8000001056a9:	48 89 c7             	mov    %rax,%rdi
ffff8000001056ac:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff8000001056b3:	80 ff ff 
ffff8000001056b6:	ff d0                	callq  *%rax
          (addr_t)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
ffff8000001056b8:	48 b8 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rax
ffff8000001056bf:	80 ff ff 
ffff8000001056c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001056c6:	e9 c0 00 00 00       	jmpq   ffff80000010578b <startothers+0x116>
    if(c == cpus+cpunum())  // We've started already.
ffff8000001056cb:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff8000001056d2:	80 ff ff 
ffff8000001056d5:	ff d0                	callq  *%rax
ffff8000001056d7:	48 63 d0             	movslq %eax,%rdx
ffff8000001056da:	48 89 d0             	mov    %rdx,%rax
ffff8000001056dd:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001056e1:	48 01 d0             	add    %rdx,%rax
ffff8000001056e4:	48 c1 e0 03          	shl    $0x3,%rax
ffff8000001056e8:	48 89 c2             	mov    %rax,%rdx
ffff8000001056eb:	48 b8 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rax
ffff8000001056f2:	80 ff ff 
ffff8000001056f5:	48 01 d0             	add    %rdx,%rax
ffff8000001056f8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001056fc:	0f 84 83 00 00 00    	je     ffff800000105785 <startothers+0x110>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
ffff800000105702:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff800000105709:	80 ff ff 
ffff80000010570c:	ff d0                	callq  *%rax
ffff80000010570e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    *(uint32*)(code-4) = 0x8000; // enough stack to get us to entry64mp
ffff800000105712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105716:	48 83 e8 04          	sub    $0x4,%rax
ffff80000010571a:	c7 00 00 80 00 00    	movl   $0x8000,(%rax)
    *(uint32*)(code-8) = v2p(entry32mp);
ffff800000105720:	48 bf 49 00 10 00 00 	movabs $0xffff800000100049,%rdi
ffff800000105727:	80 ff ff 
ffff80000010572a:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff800000105731:	80 ff ff 
ffff800000105734:	ff d0                	callq  *%rax
ffff800000105736:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010573a:	48 83 ea 08          	sub    $0x8,%rdx
ffff80000010573e:	89 02                	mov    %eax,(%rdx)
    *(uint64*)(code-16) = (uint64) (stack + KSTACKSIZE);
ffff800000105740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105744:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
ffff80000010574b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010574f:	48 83 e8 10          	sub    $0x10,%rax
ffff800000105753:	48 89 10             	mov    %rdx,(%rax)

    lapicstartap(c->apicid, V2P(code));
ffff800000105756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010575a:	89 c2                	mov    %eax,%edx
ffff80000010575c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105760:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffff800000105764:	0f b6 c0             	movzbl %al,%eax
ffff800000105767:	89 d6                	mov    %edx,%esi
ffff800000105769:	89 c7                	mov    %eax,%edi
ffff80000010576b:	48 b8 6f 48 10 00 00 	movabs $0xffff80000010486f,%rax
ffff800000105772:	80 ff ff 
ffff800000105775:	ff d0                	callq  *%rax

    // wait for cpu to finish mpmain()
    while(c->started == 0)
ffff800000105777:	90                   	nop
ffff800000105778:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010577c:	8b 40 10             	mov    0x10(%rax),%eax
ffff80000010577f:	85 c0                	test   %eax,%eax
ffff800000105781:	74 f5                	je     ffff800000105778 <startothers+0x103>
ffff800000105783:	eb 01                	jmp    ffff800000105786 <startothers+0x111>
      continue;
ffff800000105785:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
ffff800000105786:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffff80000010578b:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105792:	80 ff ff 
ffff800000105795:	8b 00                	mov    (%rax),%eax
ffff800000105797:	48 63 d0             	movslq %eax,%rdx
ffff80000010579a:	48 89 d0             	mov    %rdx,%rax
ffff80000010579d:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001057a1:	48 01 d0             	add    %rdx,%rax
ffff8000001057a4:	48 c1 e0 03          	shl    $0x3,%rax
ffff8000001057a8:	48 89 c2             	mov    %rax,%rdx
ffff8000001057ab:	48 b8 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rax
ffff8000001057b2:	80 ff ff 
ffff8000001057b5:	48 01 d0             	add    %rdx,%rax
ffff8000001057b8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001057bc:	0f 82 09 ff ff ff    	jb     ffff8000001056cb <startothers+0x56>
      ;
  }
}
ffff8000001057c2:	90                   	nop
ffff8000001057c3:	90                   	nop
ffff8000001057c4:	c9                   	leaveq 
ffff8000001057c5:	c3                   	retq   

ffff8000001057c6 <inb>:
{
ffff8000001057c6:	f3 0f 1e fa          	endbr64 
ffff8000001057ca:	55                   	push   %rbp
ffff8000001057cb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001057ce:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001057d2:	89 f8                	mov    %edi,%eax
ffff8000001057d4:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001057d8:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001057dc:	89 c2                	mov    %eax,%edx
ffff8000001057de:	ec                   	in     (%dx),%al
ffff8000001057df:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff8000001057e2:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff8000001057e6:	c9                   	leaveq 
ffff8000001057e7:	c3                   	retq   

ffff8000001057e8 <outb>:
{
ffff8000001057e8:	f3 0f 1e fa          	endbr64 
ffff8000001057ec:	55                   	push   %rbp
ffff8000001057ed:	48 89 e5             	mov    %rsp,%rbp
ffff8000001057f0:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001057f4:	89 f8                	mov    %edi,%eax
ffff8000001057f6:	89 f2                	mov    %esi,%edx
ffff8000001057f8:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff8000001057fc:	89 d0                	mov    %edx,%eax
ffff8000001057fe:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000105801:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000105805:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000105809:	ee                   	out    %al,(%dx)
}
ffff80000010580a:	90                   	nop
ffff80000010580b:	c9                   	leaveq 
ffff80000010580c:	c3                   	retq   

ffff80000010580d <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
ffff80000010580d:	f3 0f 1e fa          	endbr64 
ffff800000105811:	55                   	push   %rbp
ffff800000105812:	48 89 e5             	mov    %rsp,%rbp
ffff800000105815:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105819:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010581d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, sum;

  sum = 0;
ffff800000105820:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  for(i=0; i<len; i++)
ffff800000105827:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010582e:	eb 1a                	jmp    ffff80000010584a <sum+0x3d>
    sum += addr[i];
ffff800000105830:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105833:	48 63 d0             	movslq %eax,%rdx
ffff800000105836:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010583a:	48 01 d0             	add    %rdx,%rax
ffff80000010583d:	0f b6 00             	movzbl (%rax),%eax
ffff800000105840:	0f b6 c0             	movzbl %al,%eax
ffff800000105843:	01 45 f8             	add    %eax,-0x8(%rbp)
  for(i=0; i<len; i++)
ffff800000105846:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010584a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010584d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
ffff800000105850:	7c de                	jl     ffff800000105830 <sum+0x23>
  return sum;
ffff800000105852:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffff800000105855:	c9                   	leaveq 
ffff800000105856:	c3                   	retq   

ffff800000105857 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(addr_t a, int len)
{
ffff800000105857:	f3 0f 1e fa          	endbr64 
ffff80000010585b:	55                   	push   %rbp
ffff80000010585c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010585f:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000105863:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000105867:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  uchar *e, *p, *addr;
  addr = P2V(a);
ffff80000010586a:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff800000105871:	80 ff ff 
ffff800000105874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000105878:	48 01 d0             	add    %rdx,%rax
ffff80000010587b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  e = addr+len;
ffff80000010587f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000105882:	48 63 d0             	movslq %eax,%rdx
ffff800000105885:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105889:	48 01 d0             	add    %rdx,%rax
ffff80000010588c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(p = addr; p < e; p += sizeof(struct mp))
ffff800000105890:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105894:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105898:	eb 4d                	jmp    ffff8000001058e7 <mpsearch1+0x90>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
ffff80000010589a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010589e:	ba 04 00 00 00       	mov    $0x4,%edx
ffff8000001058a3:	48 be 88 c0 10 00 00 	movabs $0xffff80000010c088,%rsi
ffff8000001058aa:	80 ff ff 
ffff8000001058ad:	48 89 c7             	mov    %rax,%rdi
ffff8000001058b0:	48 b8 6b 79 10 00 00 	movabs $0xffff80000010796b,%rax
ffff8000001058b7:	80 ff ff 
ffff8000001058ba:	ff d0                	callq  *%rax
ffff8000001058bc:	85 c0                	test   %eax,%eax
ffff8000001058be:	75 22                	jne    ffff8000001058e2 <mpsearch1+0x8b>
ffff8000001058c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058c4:	be 10 00 00 00       	mov    $0x10,%esi
ffff8000001058c9:	48 89 c7             	mov    %rax,%rdi
ffff8000001058cc:	48 b8 0d 58 10 00 00 	movabs $0xffff80000010580d,%rax
ffff8000001058d3:	80 ff ff 
ffff8000001058d6:	ff d0                	callq  *%rax
ffff8000001058d8:	84 c0                	test   %al,%al
ffff8000001058da:	75 06                	jne    ffff8000001058e2 <mpsearch1+0x8b>
      return (struct mp*)p;
ffff8000001058dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058e0:	eb 14                	jmp    ffff8000001058f6 <mpsearch1+0x9f>
  for(p = addr; p < e; p += sizeof(struct mp))
ffff8000001058e2:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
ffff8000001058e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058eb:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff8000001058ef:	72 a9                	jb     ffff80000010589a <mpsearch1+0x43>
  return 0;
ffff8000001058f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001058f6:	c9                   	leaveq 
ffff8000001058f7:	c3                   	retq   

ffff8000001058f8 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
ffff8000001058f8:	f3 0f 1e fa          	endbr64 
ffff8000001058fc:	55                   	push   %rbp
ffff8000001058fd:	48 89 e5             	mov    %rsp,%rbp
ffff800000105900:	48 83 ec 20          	sub    $0x20,%rsp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
ffff800000105904:	48 b8 00 04 00 00 00 	movabs $0xffff800000000400,%rax
ffff80000010590b:	80 ff ff 
ffff80000010590e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
ffff800000105912:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105916:	48 83 c0 0f          	add    $0xf,%rax
ffff80000010591a:	0f b6 00             	movzbl (%rax),%eax
ffff80000010591d:	0f b6 c0             	movzbl %al,%eax
ffff800000105920:	c1 e0 08             	shl    $0x8,%eax
ffff800000105923:	89 c2                	mov    %eax,%edx
ffff800000105925:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105929:	48 83 c0 0e          	add    $0xe,%rax
ffff80000010592d:	0f b6 00             	movzbl (%rax),%eax
ffff800000105930:	0f b6 c0             	movzbl %al,%eax
ffff800000105933:	09 d0                	or     %edx,%eax
ffff800000105935:	c1 e0 04             	shl    $0x4,%eax
ffff800000105938:	89 45 f4             	mov    %eax,-0xc(%rbp)
ffff80000010593b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff80000010593f:	74 28                	je     ffff800000105969 <mpsearch+0x71>
    if((mp = mpsearch1(p, 1024)))
ffff800000105941:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000105944:	be 00 04 00 00       	mov    $0x400,%esi
ffff800000105949:	48 89 c7             	mov    %rax,%rdi
ffff80000010594c:	48 b8 57 58 10 00 00 	movabs $0xffff800000105857,%rax
ffff800000105953:	80 ff ff 
ffff800000105956:	ff d0                	callq  *%rax
ffff800000105958:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010595c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000105961:	74 5e                	je     ffff8000001059c1 <mpsearch+0xc9>
      return mp;
ffff800000105963:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105967:	eb 6e                	jmp    ffff8000001059d7 <mpsearch+0xdf>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
ffff800000105969:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010596d:	48 83 c0 14          	add    $0x14,%rax
ffff800000105971:	0f b6 00             	movzbl (%rax),%eax
ffff800000105974:	0f b6 c0             	movzbl %al,%eax
ffff800000105977:	c1 e0 08             	shl    $0x8,%eax
ffff80000010597a:	89 c2                	mov    %eax,%edx
ffff80000010597c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105980:	48 83 c0 13          	add    $0x13,%rax
ffff800000105984:	0f b6 00             	movzbl (%rax),%eax
ffff800000105987:	0f b6 c0             	movzbl %al,%eax
ffff80000010598a:	09 d0                	or     %edx,%eax
ffff80000010598c:	c1 e0 0a             	shl    $0xa,%eax
ffff80000010598f:	89 45 f4             	mov    %eax,-0xc(%rbp)
    if((mp = mpsearch1(p-1024, 1024)))
ffff800000105992:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000105995:	2d 00 04 00 00       	sub    $0x400,%eax
ffff80000010599a:	89 c0                	mov    %eax,%eax
ffff80000010599c:	be 00 04 00 00       	mov    $0x400,%esi
ffff8000001059a1:	48 89 c7             	mov    %rax,%rdi
ffff8000001059a4:	48 b8 57 58 10 00 00 	movabs $0xffff800000105857,%rax
ffff8000001059ab:	80 ff ff 
ffff8000001059ae:	ff d0                	callq  *%rax
ffff8000001059b0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001059b4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001059b9:	74 06                	je     ffff8000001059c1 <mpsearch+0xc9>
      return mp;
ffff8000001059bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001059bf:	eb 16                	jmp    ffff8000001059d7 <mpsearch+0xdf>
  }
  return mpsearch1(0xF0000, 0x10000);
ffff8000001059c1:	be 00 00 01 00       	mov    $0x10000,%esi
ffff8000001059c6:	bf 00 00 0f 00       	mov    $0xf0000,%edi
ffff8000001059cb:	48 b8 57 58 10 00 00 	movabs $0xffff800000105857,%rax
ffff8000001059d2:	80 ff ff 
ffff8000001059d5:	ff d0                	callq  *%rax
}
ffff8000001059d7:	c9                   	leaveq 
ffff8000001059d8:	c3                   	retq   

ffff8000001059d9 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
ffff8000001059d9:	f3 0f 1e fa          	endbr64 
ffff8000001059dd:	55                   	push   %rbp
ffff8000001059de:	48 89 e5             	mov    %rsp,%rbp
ffff8000001059e1:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001059e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
ffff8000001059e9:	48 b8 f8 58 10 00 00 	movabs $0xffff8000001058f8,%rax
ffff8000001059f0:	80 ff ff 
ffff8000001059f3:	ff d0                	callq  *%rax
ffff8000001059f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001059f9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001059fe:	74 0b                	je     ffff800000105a0b <mpconfig+0x32>
ffff800000105a00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a04:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105a07:	85 c0                	test   %eax,%eax
ffff800000105a09:	75 0a                	jne    ffff800000105a15 <mpconfig+0x3c>
    return 0;
ffff800000105a0b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105a10:	e9 a0 00 00 00       	jmpq   ffff800000105ab5 <mpconfig+0xdc>
  conf = (struct mpconf*) P2V((addr_t) mp->physaddr);
ffff800000105a15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a19:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105a1c:	89 c2                	mov    %eax,%edx
ffff800000105a1e:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff800000105a25:	80 ff ff 
ffff800000105a28:	48 01 d0             	add    %rdx,%rax
ffff800000105a2b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(memcmp(conf, "PCMP", 4) != 0)
ffff800000105a2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a33:	ba 04 00 00 00       	mov    $0x4,%edx
ffff800000105a38:	48 be 8d c0 10 00 00 	movabs $0xffff80000010c08d,%rsi
ffff800000105a3f:	80 ff ff 
ffff800000105a42:	48 89 c7             	mov    %rax,%rdi
ffff800000105a45:	48 b8 6b 79 10 00 00 	movabs $0xffff80000010796b,%rax
ffff800000105a4c:	80 ff ff 
ffff800000105a4f:	ff d0                	callq  *%rax
ffff800000105a51:	85 c0                	test   %eax,%eax
ffff800000105a53:	74 07                	je     ffff800000105a5c <mpconfig+0x83>
    return 0;
ffff800000105a55:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105a5a:	eb 59                	jmp    ffff800000105ab5 <mpconfig+0xdc>
  if(conf->version != 1 && conf->version != 4)
ffff800000105a5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a60:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffff800000105a64:	3c 01                	cmp    $0x1,%al
ffff800000105a66:	74 13                	je     ffff800000105a7b <mpconfig+0xa2>
ffff800000105a68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a6c:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffff800000105a70:	3c 04                	cmp    $0x4,%al
ffff800000105a72:	74 07                	je     ffff800000105a7b <mpconfig+0xa2>
    return 0;
ffff800000105a74:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105a79:	eb 3a                	jmp    ffff800000105ab5 <mpconfig+0xdc>
  if(sum((uchar*)conf, conf->length) != 0)
ffff800000105a7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a7f:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffff800000105a83:	0f b7 d0             	movzwl %ax,%edx
ffff800000105a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a8a:	89 d6                	mov    %edx,%esi
ffff800000105a8c:	48 89 c7             	mov    %rax,%rdi
ffff800000105a8f:	48 b8 0d 58 10 00 00 	movabs $0xffff80000010580d,%rax
ffff800000105a96:	80 ff ff 
ffff800000105a99:	ff d0                	callq  *%rax
ffff800000105a9b:	84 c0                	test   %al,%al
ffff800000105a9d:	74 07                	je     ffff800000105aa6 <mpconfig+0xcd>
    return 0;
ffff800000105a9f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105aa4:	eb 0f                	jmp    ffff800000105ab5 <mpconfig+0xdc>
  *pmp = mp;
ffff800000105aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105aaa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105aae:	48 89 10             	mov    %rdx,(%rax)
  return conf;
ffff800000105ab1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffff800000105ab5:	c9                   	leaveq 
ffff800000105ab6:	c3                   	retq   

ffff800000105ab7 <mpinit>:

void
mpinit(void)
{
ffff800000105ab7:	f3 0f 1e fa          	endbr64 
ffff800000105abb:	55                   	push   %rbp
ffff800000105abc:	48 89 e5             	mov    %rsp,%rbp
ffff800000105abf:	48 83 ec 30          	sub    $0x30,%rsp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0) {
ffff800000105ac3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffff800000105ac7:	48 89 c7             	mov    %rax,%rdi
ffff800000105aca:	48 b8 d9 59 10 00 00 	movabs $0xffff8000001059d9,%rax
ffff800000105ad1:	80 ff ff 
ffff800000105ad4:	ff d0                	callq  *%rax
ffff800000105ad6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000105ada:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000105adf:	75 20                	jne    ffff800000105b01 <mpinit+0x4a>
    cprintf("No other CPUs found.\n");
ffff800000105ae1:	48 bf 92 c0 10 00 00 	movabs $0xffff80000010c092,%rdi
ffff800000105ae8:	80 ff ff 
ffff800000105aeb:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105af0:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000105af7:	80 ff ff 
ffff800000105afa:	ff d2                	callq  *%rdx
ffff800000105afc:	e9 c3 01 00 00       	jmpq   ffff800000105cc4 <mpinit+0x20d>
    return;
  }
  lapic = P2V((addr_t)conf->lapicaddr_p);
ffff800000105b01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105b05:	8b 40 24             	mov    0x24(%rax),%eax
ffff800000105b08:	89 c2                	mov    %eax,%edx
ffff800000105b0a:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff800000105b11:	80 ff ff 
ffff800000105b14:	48 01 d0             	add    %rdx,%rax
ffff800000105b17:	48 89 c2             	mov    %rax,%rdx
ffff800000105b1a:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000105b21:	80 ff ff 
ffff800000105b24:	48 89 10             	mov    %rdx,(%rax)
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffff800000105b27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105b2b:	48 83 c0 2c          	add    $0x2c,%rax
ffff800000105b2f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105b37:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffff800000105b3b:	0f b7 d0             	movzwl %ax,%edx
ffff800000105b3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105b42:	48 01 d0             	add    %rdx,%rax
ffff800000105b45:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105b49:	e9 f3 00 00 00       	jmpq   ffff800000105c41 <mpinit+0x18a>
    switch(*p){
ffff800000105b4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105b52:	0f b6 00             	movzbl (%rax),%eax
ffff800000105b55:	0f b6 c0             	movzbl %al,%eax
ffff800000105b58:	83 f8 04             	cmp    $0x4,%eax
ffff800000105b5b:	0f 8f ca 00 00 00    	jg     ffff800000105c2b <mpinit+0x174>
ffff800000105b61:	83 f8 03             	cmp    $0x3,%eax
ffff800000105b64:	0f 8d ba 00 00 00    	jge    ffff800000105c24 <mpinit+0x16d>
ffff800000105b6a:	83 f8 02             	cmp    $0x2,%eax
ffff800000105b6d:	0f 84 8e 00 00 00    	je     ffff800000105c01 <mpinit+0x14a>
ffff800000105b73:	83 f8 02             	cmp    $0x2,%eax
ffff800000105b76:	0f 8f af 00 00 00    	jg     ffff800000105c2b <mpinit+0x174>
ffff800000105b7c:	85 c0                	test   %eax,%eax
ffff800000105b7e:	74 0e                	je     ffff800000105b8e <mpinit+0xd7>
ffff800000105b80:	83 f8 01             	cmp    $0x1,%eax
ffff800000105b83:	0f 84 9b 00 00 00    	je     ffff800000105c24 <mpinit+0x16d>
ffff800000105b89:	e9 9d 00 00 00       	jmpq   ffff800000105c2b <mpinit+0x174>
    case MPPROC:
      proc = (struct mpproc*)p;
ffff800000105b8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105b92:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      if(ncpu < NCPU) {
ffff800000105b96:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105b9d:	80 ff ff 
ffff800000105ba0:	8b 00                	mov    (%rax),%eax
ffff800000105ba2:	83 f8 07             	cmp    $0x7,%eax
ffff800000105ba5:	7f 53                	jg     ffff800000105bfa <mpinit+0x143>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
ffff800000105ba7:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105bae:	80 ff ff 
ffff800000105bb1:	8b 10                	mov    (%rax),%edx
ffff800000105bb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000105bb7:	0f b6 48 01          	movzbl 0x1(%rax),%ecx
ffff800000105bbb:	48 be e0 72 11 00 00 	movabs $0xffff8000001172e0,%rsi
ffff800000105bc2:	80 ff ff 
ffff800000105bc5:	48 63 d2             	movslq %edx,%rdx
ffff800000105bc8:	48 89 d0             	mov    %rdx,%rax
ffff800000105bcb:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000105bcf:	48 01 d0             	add    %rdx,%rax
ffff800000105bd2:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000105bd6:	48 01 f0             	add    %rsi,%rax
ffff800000105bd9:	48 83 c0 01          	add    $0x1,%rax
ffff800000105bdd:	88 08                	mov    %cl,(%rax)
        ncpu++;
ffff800000105bdf:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105be6:	80 ff ff 
ffff800000105be9:	8b 00                	mov    (%rax),%eax
ffff800000105beb:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000105bee:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105bf5:	80 ff ff 
ffff800000105bf8:	89 10                	mov    %edx,(%rax)
      }
      p += sizeof(struct mpproc);
ffff800000105bfa:	48 83 45 f8 14       	addq   $0x14,-0x8(%rbp)
      continue;
ffff800000105bff:	eb 40                	jmp    ffff800000105c41 <mpinit+0x18a>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
ffff800000105c01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c05:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      ioapicid = ioapic->apicno;
ffff800000105c09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105c0d:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffff800000105c11:	48 ba 24 74 11 00 00 	movabs $0xffff800000117424,%rdx
ffff800000105c18:	80 ff ff 
ffff800000105c1b:	88 02                	mov    %al,(%rdx)
      p += sizeof(struct mpioapic);
ffff800000105c1d:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffff800000105c22:	eb 1d                	jmp    ffff800000105c41 <mpinit+0x18a>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
ffff800000105c24:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffff800000105c29:	eb 16                	jmp    ffff800000105c41 <mpinit+0x18a>
    default:
      panic("Major problem parsing mp config.");
ffff800000105c2b:	48 bf a8 c0 10 00 00 	movabs $0xffff80000010c0a8,%rdi
ffff800000105c32:	80 ff ff 
ffff800000105c35:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000105c3c:	80 ff ff 
ffff800000105c3f:	ff d0                	callq  *%rax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffff800000105c41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c45:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff800000105c49:	0f 82 ff fe ff ff    	jb     ffff800000105b4e <mpinit+0x97>
      break;
    }
  }
  cprintf("Seems we are SMP, ncpu = %d\n",ncpu);
ffff800000105c4f:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105c56:	80 ff ff 
ffff800000105c59:	8b 00                	mov    (%rax),%eax
ffff800000105c5b:	89 c6                	mov    %eax,%esi
ffff800000105c5d:	48 bf c9 c0 10 00 00 	movabs $0xffff80000010c0c9,%rdi
ffff800000105c64:	80 ff ff 
ffff800000105c67:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105c6c:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000105c73:	80 ff ff 
ffff800000105c76:	ff d2                	callq  *%rdx
  if(mp->imcrp){
ffff800000105c78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000105c7c:	0f b6 40 0c          	movzbl 0xc(%rax),%eax
ffff800000105c80:	84 c0                	test   %al,%al
ffff800000105c82:	74 40                	je     ffff800000105cc4 <mpinit+0x20d>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
ffff800000105c84:	be 70 00 00 00       	mov    $0x70,%esi
ffff800000105c89:	bf 22 00 00 00       	mov    $0x22,%edi
ffff800000105c8e:	48 b8 e8 57 10 00 00 	movabs $0xffff8000001057e8,%rax
ffff800000105c95:	80 ff ff 
ffff800000105c98:	ff d0                	callq  *%rax
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
ffff800000105c9a:	bf 23 00 00 00       	mov    $0x23,%edi
ffff800000105c9f:	48 b8 c6 57 10 00 00 	movabs $0xffff8000001057c6,%rax
ffff800000105ca6:	80 ff ff 
ffff800000105ca9:	ff d0                	callq  *%rax
ffff800000105cab:	83 c8 01             	or     $0x1,%eax
ffff800000105cae:	0f b6 c0             	movzbl %al,%eax
ffff800000105cb1:	89 c6                	mov    %eax,%esi
ffff800000105cb3:	bf 23 00 00 00       	mov    $0x23,%edi
ffff800000105cb8:	48 b8 e8 57 10 00 00 	movabs $0xffff8000001057e8,%rax
ffff800000105cbf:	80 ff ff 
ffff800000105cc2:	ff d0                	callq  *%rax
  }
}
ffff800000105cc4:	c9                   	leaveq 
ffff800000105cc5:	c3                   	retq   

ffff800000105cc6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
ffff800000105cc6:	f3 0f 1e fa          	endbr64 
ffff800000105cca:	55                   	push   %rbp
ffff800000105ccb:	48 89 e5             	mov    %rsp,%rbp
ffff800000105cce:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105cd2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105cd6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct pipe *p;

  p = 0;
ffff800000105cda:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffff800000105ce1:	00 
  *f0 = *f1 = 0;
ffff800000105ce2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105ce6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
ffff800000105ced:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105cf1:	48 8b 10             	mov    (%rax),%rdx
ffff800000105cf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105cf8:	48 89 10             	mov    %rdx,(%rax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
ffff800000105cfb:	48 b8 84 1b 10 00 00 	movabs $0xffff800000101b84,%rax
ffff800000105d02:	80 ff ff 
ffff800000105d05:	ff d0                	callq  *%rax
ffff800000105d07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000105d0b:	48 89 02             	mov    %rax,(%rdx)
ffff800000105d0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105d12:	48 8b 00             	mov    (%rax),%rax
ffff800000105d15:	48 85 c0             	test   %rax,%rax
ffff800000105d18:	0f 84 fe 00 00 00    	je     ffff800000105e1c <pipealloc+0x156>
ffff800000105d1e:	48 b8 84 1b 10 00 00 	movabs $0xffff800000101b84,%rax
ffff800000105d25:	80 ff ff 
ffff800000105d28:	ff d0                	callq  *%rax
ffff800000105d2a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000105d2e:	48 89 02             	mov    %rax,(%rdx)
ffff800000105d31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105d35:	48 8b 00             	mov    (%rax),%rax
ffff800000105d38:	48 85 c0             	test   %rax,%rax
ffff800000105d3b:	0f 84 db 00 00 00    	je     ffff800000105e1c <pipealloc+0x156>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
ffff800000105d41:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff800000105d48:	80 ff ff 
ffff800000105d4b:	ff d0                	callq  *%rax
ffff800000105d4d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105d51:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105d56:	0f 84 c3 00 00 00    	je     ffff800000105e1f <pipealloc+0x159>
    goto bad;
  p->readopen = 1;
ffff800000105d5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d60:	c7 80 70 02 00 00 01 	movl   $0x1,0x270(%rax)
ffff800000105d67:	00 00 00 
  p->writeopen = 1;
ffff800000105d6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d6e:	c7 80 74 02 00 00 01 	movl   $0x1,0x274(%rax)
ffff800000105d75:	00 00 00 
  p->nwrite = 0;
ffff800000105d78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d7c:	c7 80 6c 02 00 00 00 	movl   $0x0,0x26c(%rax)
ffff800000105d83:	00 00 00 
  p->nread = 0;
ffff800000105d86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d8a:	c7 80 68 02 00 00 00 	movl   $0x0,0x268(%rax)
ffff800000105d91:	00 00 00 
  initlock(&p->lock, "pipe");
ffff800000105d94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d98:	48 be e6 c0 10 00 00 	movabs $0xffff80000010c0e6,%rsi
ffff800000105d9f:	80 ff ff 
ffff800000105da2:	48 89 c7             	mov    %rax,%rdi
ffff800000105da5:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff800000105dac:	80 ff ff 
ffff800000105daf:	ff d0                	callq  *%rax
  (*f0)->type = FD_PIPE;
ffff800000105db1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105db5:	48 8b 00             	mov    (%rax),%rax
ffff800000105db8:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f0)->readable = 1;
ffff800000105dbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105dc2:	48 8b 00             	mov    (%rax),%rax
ffff800000105dc5:	c6 40 08 01          	movb   $0x1,0x8(%rax)
  (*f0)->writable = 0;
ffff800000105dc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105dcd:	48 8b 00             	mov    (%rax),%rax
ffff800000105dd0:	c6 40 09 00          	movb   $0x0,0x9(%rax)
  (*f0)->pipe = p;
ffff800000105dd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105dd8:	48 8b 00             	mov    (%rax),%rax
ffff800000105ddb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105ddf:	48 89 50 10          	mov    %rdx,0x10(%rax)
  (*f1)->type = FD_PIPE;
ffff800000105de3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105de7:	48 8b 00             	mov    (%rax),%rax
ffff800000105dea:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f1)->readable = 0;
ffff800000105df0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105df4:	48 8b 00             	mov    (%rax),%rax
ffff800000105df7:	c6 40 08 00          	movb   $0x0,0x8(%rax)
  (*f1)->writable = 1;
ffff800000105dfb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105dff:	48 8b 00             	mov    (%rax),%rax
ffff800000105e02:	c6 40 09 01          	movb   $0x1,0x9(%rax)
  (*f1)->pipe = p;
ffff800000105e06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e0a:	48 8b 00             	mov    (%rax),%rax
ffff800000105e0d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105e11:	48 89 50 10          	mov    %rdx,0x10(%rax)
  return 0;
ffff800000105e15:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105e1a:	eb 67                	jmp    ffff800000105e83 <pipealloc+0x1bd>
    goto bad;
ffff800000105e1c:	90                   	nop
ffff800000105e1d:	eb 01                	jmp    ffff800000105e20 <pipealloc+0x15a>
    goto bad;
ffff800000105e1f:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
ffff800000105e20:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105e25:	74 13                	je     ffff800000105e3a <pipealloc+0x174>
    kfree((char*)p);
ffff800000105e27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e2b:	48 89 c7             	mov    %rax,%rdi
ffff800000105e2e:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff800000105e35:	80 ff ff 
ffff800000105e38:	ff d0                	callq  *%rax
  if(*f0)
ffff800000105e3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105e3e:	48 8b 00             	mov    (%rax),%rax
ffff800000105e41:	48 85 c0             	test   %rax,%rax
ffff800000105e44:	74 16                	je     ffff800000105e5c <pipealloc+0x196>
    fileclose(*f0);
ffff800000105e46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105e4a:	48 8b 00             	mov    (%rax),%rax
ffff800000105e4d:	48 89 c7             	mov    %rax,%rdi
ffff800000105e50:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000105e57:	80 ff ff 
ffff800000105e5a:	ff d0                	callq  *%rax
  if(*f1)
ffff800000105e5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e60:	48 8b 00             	mov    (%rax),%rax
ffff800000105e63:	48 85 c0             	test   %rax,%rax
ffff800000105e66:	74 16                	je     ffff800000105e7e <pipealloc+0x1b8>
    fileclose(*f1);
ffff800000105e68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105e6c:	48 8b 00             	mov    (%rax),%rax
ffff800000105e6f:	48 89 c7             	mov    %rax,%rdi
ffff800000105e72:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000105e79:	80 ff ff 
ffff800000105e7c:	ff d0                	callq  *%rax
  return -1;
ffff800000105e7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000105e83:	c9                   	leaveq 
ffff800000105e84:	c3                   	retq   

ffff800000105e85 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
ffff800000105e85:	f3 0f 1e fa          	endbr64 
ffff800000105e89:	55                   	push   %rbp
ffff800000105e8a:	48 89 e5             	mov    %rsp,%rbp
ffff800000105e8d:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000105e91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000105e95:	89 75 f4             	mov    %esi,-0xc(%rbp)
  acquire(&p->lock);
ffff800000105e98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e9c:	48 89 c7             	mov    %rax,%rdi
ffff800000105e9f:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000105ea6:	80 ff ff 
ffff800000105ea9:	ff d0                	callq  *%rax
  if(writable){
ffff800000105eab:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000105eaf:	74 29                	je     ffff800000105eda <pipeclose+0x55>
    p->writeopen = 0;
ffff800000105eb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105eb5:	c7 80 74 02 00 00 00 	movl   $0x0,0x274(%rax)
ffff800000105ebc:	00 00 00 
    wakeup(&p->nread);
ffff800000105ebf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ec3:	48 05 68 02 00 00    	add    $0x268,%rax
ffff800000105ec9:	48 89 c7             	mov    %rax,%rdi
ffff800000105ecc:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff800000105ed3:	80 ff ff 
ffff800000105ed6:	ff d0                	callq  *%rax
ffff800000105ed8:	eb 27                	jmp    ffff800000105f01 <pipeclose+0x7c>
  } else {
    p->readopen = 0;
ffff800000105eda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ede:	c7 80 70 02 00 00 00 	movl   $0x0,0x270(%rax)
ffff800000105ee5:	00 00 00 
    wakeup(&p->nwrite);
ffff800000105ee8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105eec:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffff800000105ef2:	48 89 c7             	mov    %rax,%rdi
ffff800000105ef5:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff800000105efc:	80 ff ff 
ffff800000105eff:	ff d0                	callq  *%rax
  }
  if(p->readopen == 0 && p->writeopen == 0){
ffff800000105f01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f05:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffff800000105f0b:	85 c0                	test   %eax,%eax
ffff800000105f0d:	75 36                	jne    ffff800000105f45 <pipeclose+0xc0>
ffff800000105f0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f13:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffff800000105f19:	85 c0                	test   %eax,%eax
ffff800000105f1b:	75 28                	jne    ffff800000105f45 <pipeclose+0xc0>
    release(&p->lock);
ffff800000105f1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f21:	48 89 c7             	mov    %rax,%rdi
ffff800000105f24:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000105f2b:	80 ff ff 
ffff800000105f2e:	ff d0                	callq  *%rax
    kfree((char*)p);
ffff800000105f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f34:	48 89 c7             	mov    %rax,%rdi
ffff800000105f37:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff800000105f3e:	80 ff ff 
ffff800000105f41:	ff d0                	callq  *%rax
ffff800000105f43:	eb 14                	jmp    ffff800000105f59 <pipeclose+0xd4>
  } else
    release(&p->lock);
ffff800000105f45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105f49:	48 89 c7             	mov    %rax,%rdi
ffff800000105f4c:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000105f53:	80 ff ff 
ffff800000105f56:	ff d0                	callq  *%rax
}
ffff800000105f58:	90                   	nop
ffff800000105f59:	90                   	nop
ffff800000105f5a:	c9                   	leaveq 
ffff800000105f5b:	c3                   	retq   

ffff800000105f5c <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
ffff800000105f5c:	f3 0f 1e fa          	endbr64 
ffff800000105f60:	55                   	push   %rbp
ffff800000105f61:	48 89 e5             	mov    %rsp,%rbp
ffff800000105f64:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000105f68:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105f6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000105f70:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffff800000105f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f77:	48 89 c7             	mov    %rax,%rdi
ffff800000105f7a:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000105f81:	80 ff ff 
ffff800000105f84:	ff d0                	callq  *%rax
  for(i = 0; i < n; i++){
ffff800000105f86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000105f8d:	e9 d5 00 00 00       	jmpq   ffff800000106067 <pipewrite+0x10b>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
ffff800000105f92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f96:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffff800000105f9c:	85 c0                	test   %eax,%eax
ffff800000105f9e:	74 12                	je     ffff800000105fb2 <pipewrite+0x56>
ffff800000105fa0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000105fa7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000105fab:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000105fae:	85 c0                	test   %eax,%eax
ffff800000105fb0:	74 1d                	je     ffff800000105fcf <pipewrite+0x73>
        release(&p->lock);
ffff800000105fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105fb6:	48 89 c7             	mov    %rax,%rdi
ffff800000105fb9:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000105fc0:	80 ff ff 
ffff800000105fc3:	ff d0                	callq  *%rax
        return -1;
ffff800000105fc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000105fca:	e9 cf 00 00 00       	jmpq   ffff80000010609e <pipewrite+0x142>
      }
      wakeup(&p->nread);
ffff800000105fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105fd3:	48 05 68 02 00 00    	add    $0x268,%rax
ffff800000105fd9:	48 89 c7             	mov    %rax,%rdi
ffff800000105fdc:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff800000105fe3:	80 ff ff 
ffff800000105fe6:	ff d0                	callq  *%rax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
ffff800000105fe8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105fec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000105ff0:	48 81 c2 6c 02 00 00 	add    $0x26c,%rdx
ffff800000105ff7:	48 89 c6             	mov    %rax,%rsi
ffff800000105ffa:	48 89 d7             	mov    %rdx,%rdi
ffff800000105ffd:	48 b8 15 6f 10 00 00 	movabs $0xffff800000106f15,%rax
ffff800000106004:	80 ff ff 
ffff800000106007:	ff d0                	callq  *%rax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
ffff800000106009:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010600d:	8b 90 6c 02 00 00    	mov    0x26c(%rax),%edx
ffff800000106013:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106017:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffff80000010601d:	05 00 02 00 00       	add    $0x200,%eax
ffff800000106022:	39 c2                	cmp    %eax,%edx
ffff800000106024:	0f 84 68 ff ff ff    	je     ffff800000105f92 <pipewrite+0x36>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
ffff80000010602a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010602d:	48 63 d0             	movslq %eax,%rdx
ffff800000106030:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106034:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
ffff800000106038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010603c:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff800000106042:	8d 48 01             	lea    0x1(%rax),%ecx
ffff800000106045:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106049:	89 8a 6c 02 00 00    	mov    %ecx,0x26c(%rdx)
ffff80000010604f:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000106054:	89 c1                	mov    %eax,%ecx
ffff800000106056:	0f b6 16             	movzbl (%rsi),%edx
ffff800000106059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010605d:	89 c9                	mov    %ecx,%ecx
ffff80000010605f:	88 54 08 68          	mov    %dl,0x68(%rax,%rcx,1)
  for(i = 0; i < n; i++){
ffff800000106063:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000106067:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010606a:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff80000010606d:	7c 9a                	jl     ffff800000106009 <pipewrite+0xad>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
ffff80000010606f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106073:	48 05 68 02 00 00    	add    $0x268,%rax
ffff800000106079:	48 89 c7             	mov    %rax,%rdi
ffff80000010607c:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff800000106083:	80 ff ff 
ffff800000106086:	ff d0                	callq  *%rax
  release(&p->lock);
ffff800000106088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010608c:	48 89 c7             	mov    %rax,%rdi
ffff80000010608f:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000106096:	80 ff ff 
ffff800000106099:	ff d0                	callq  *%rax
  return n;
ffff80000010609b:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffff80000010609e:	c9                   	leaveq 
ffff80000010609f:	c3                   	retq   

ffff8000001060a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
ffff8000001060a0:	f3 0f 1e fa          	endbr64 
ffff8000001060a4:	55                   	push   %rbp
ffff8000001060a5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001060a8:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001060ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001060b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001060b4:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffff8000001060b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001060be:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff8000001060c5:	80 ff ff 
ffff8000001060c8:	ff d0                	callq  *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffff8000001060ca:	eb 50                	jmp    ffff80000010611c <piperead+0x7c>
    if(proc->killed){
ffff8000001060cc:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001060d3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001060d7:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001060da:	85 c0                	test   %eax,%eax
ffff8000001060dc:	74 1d                	je     ffff8000001060fb <piperead+0x5b>
      release(&p->lock);
ffff8000001060de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060e2:	48 89 c7             	mov    %rax,%rdi
ffff8000001060e5:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001060ec:	80 ff ff 
ffff8000001060ef:	ff d0                	callq  *%rax
      return -1;
ffff8000001060f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001060f6:	e9 de 00 00 00       	jmpq   ffff8000001061d9 <piperead+0x139>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
ffff8000001060fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106103:	48 81 c2 68 02 00 00 	add    $0x268,%rdx
ffff80000010610a:	48 89 c6             	mov    %rax,%rsi
ffff80000010610d:	48 89 d7             	mov    %rdx,%rdi
ffff800000106110:	48 b8 15 6f 10 00 00 	movabs $0xffff800000106f15,%rax
ffff800000106117:	80 ff ff 
ffff80000010611a:	ff d0                	callq  *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffff80000010611c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106120:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffff800000106126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010612a:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff800000106130:	39 c2                	cmp    %eax,%edx
ffff800000106132:	75 0e                	jne    ffff800000106142 <piperead+0xa2>
ffff800000106134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106138:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffff80000010613e:	85 c0                	test   %eax,%eax
ffff800000106140:	75 8a                	jne    ffff8000001060cc <piperead+0x2c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffff800000106142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000106149:	eb 54                	jmp    ffff80000010619f <piperead+0xff>
    if(p->nread == p->nwrite)
ffff80000010614b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010614f:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffff800000106155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106159:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff80000010615f:	39 c2                	cmp    %eax,%edx
ffff800000106161:	74 46                	je     ffff8000001061a9 <piperead+0x109>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
ffff800000106163:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106167:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffff80000010616d:	8d 48 01             	lea    0x1(%rax),%ecx
ffff800000106170:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106174:	89 8a 68 02 00 00    	mov    %ecx,0x268(%rdx)
ffff80000010617a:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010617f:	89 c1                	mov    %eax,%ecx
ffff800000106181:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000106184:	48 63 d0             	movslq %eax,%rdx
ffff800000106187:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010618b:	48 01 c2             	add    %rax,%rdx
ffff80000010618e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106192:	89 c9                	mov    %ecx,%ecx
ffff800000106194:	0f b6 44 08 68       	movzbl 0x68(%rax,%rcx,1),%eax
ffff800000106199:	88 02                	mov    %al,(%rdx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffff80000010619b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010619f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001061a2:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff8000001061a5:	7c a4                	jl     ffff80000010614b <piperead+0xab>
ffff8000001061a7:	eb 01                	jmp    ffff8000001061aa <piperead+0x10a>
      break;
ffff8000001061a9:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
ffff8000001061aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001061ae:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffff8000001061b4:	48 89 c7             	mov    %rax,%rdi
ffff8000001061b7:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff8000001061be:	80 ff ff 
ffff8000001061c1:	ff d0                	callq  *%rax
  release(&p->lock);
ffff8000001061c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001061c7:	48 89 c7             	mov    %rax,%rdi
ffff8000001061ca:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001061d1:	80 ff ff 
ffff8000001061d4:	ff d0                	callq  *%rax
  return i;
ffff8000001061d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001061d9:	c9                   	leaveq 
ffff8000001061da:	c3                   	retq   

ffff8000001061db <readeflags>:
{
ffff8000001061db:	f3 0f 1e fa          	endbr64 
ffff8000001061df:	55                   	push   %rbp
ffff8000001061e0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001061e3:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff8000001061e7:	9c                   	pushfq 
ffff8000001061e8:	58                   	pop    %rax
ffff8000001061e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff8000001061ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001061f1:	c9                   	leaveq 
ffff8000001061f2:	c3                   	retq   

ffff8000001061f3 <sti>:
{
ffff8000001061f3:	f3 0f 1e fa          	endbr64 
ffff8000001061f7:	55                   	push   %rbp
ffff8000001061f8:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffff8000001061fb:	fb                   	sti    
}
ffff8000001061fc:	90                   	nop
ffff8000001061fd:	5d                   	pop    %rbp
ffff8000001061fe:	c3                   	retq   

ffff8000001061ff <hlt>:
{
ffff8000001061ff:	f3 0f 1e fa          	endbr64 
ffff800000106203:	55                   	push   %rbp
ffff800000106204:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffff800000106207:	f4                   	hlt    
}
ffff800000106208:	90                   	nop
ffff800000106209:	5d                   	pop    %rbp
ffff80000010620a:	c3                   	retq   

ffff80000010620b <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
ffff80000010620b:	f3 0f 1e fa          	endbr64 
ffff80000010620f:	55                   	push   %rbp
ffff800000106210:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ptable.lock, "ptable");
ffff800000106213:	48 be eb c0 10 00 00 	movabs $0xffff80000010c0eb,%rsi
ffff80000010621a:	80 ff ff 
ffff80000010621d:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106224:	80 ff ff 
ffff800000106227:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff80000010622e:	80 ff ff 
ffff800000106231:	ff d0                	callq  *%rax
}
ffff800000106233:	90                   	nop
ffff800000106234:	5d                   	pop    %rbp
ffff800000106235:	c3                   	retq   

ffff800000106236 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
ffff800000106236:	f3 0f 1e fa          	endbr64 
ffff80000010623a:	55                   	push   %rbp
ffff80000010623b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010623e:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
ffff800000106242:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106249:	80 ff ff 
ffff80000010624c:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000106253:	80 ff ff 
ffff800000106256:	ff d0                	callq  *%rax

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000106258:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff80000010625f:	80 ff ff 
ffff800000106262:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106266:	eb 13                	jmp    ffff80000010627b <allocproc+0x45>
    if(p->state == UNUSED)
ffff800000106268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010626c:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010626f:	85 c0                	test   %eax,%eax
ffff800000106271:	74 38                	je     ffff8000001062ab <allocproc+0x75>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000106273:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff80000010627a:	00 
ffff80000010627b:	48 b8 a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rax
ffff800000106282:	80 ff ff 
ffff800000106285:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106289:	72 dd                	jb     ffff800000106268 <allocproc+0x32>
      goto found;

  release(&ptable.lock);
ffff80000010628b:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106292:	80 ff ff 
ffff800000106295:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010629c:	80 ff ff 
ffff80000010629f:	ff d0                	callq  *%rax
  return 0;
ffff8000001062a1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001062a6:	e9 06 01 00 00       	jmpq   ffff8000001063b1 <allocproc+0x17b>
      goto found;
ffff8000001062ab:	90                   	nop
ffff8000001062ac:	f3 0f 1e fa          	endbr64 

found:
  p->state = EMBRYO;
ffff8000001062b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001062b4:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%rax)
  p->pid = nextpid++;
ffff8000001062bb:	48 b8 40 d5 10 00 00 	movabs $0xffff80000010d540,%rax
ffff8000001062c2:	80 ff ff 
ffff8000001062c5:	8b 00                	mov    (%rax),%eax
ffff8000001062c7:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001062ca:	48 b9 40 d5 10 00 00 	movabs $0xffff80000010d540,%rcx
ffff8000001062d1:	80 ff ff 
ffff8000001062d4:	89 11                	mov    %edx,(%rcx)
ffff8000001062d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001062da:	89 42 1c             	mov    %eax,0x1c(%rdx)

  release(&ptable.lock);
ffff8000001062dd:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff8000001062e4:	80 ff ff 
ffff8000001062e7:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001062ee:	80 ff ff 
ffff8000001062f1:	ff d0                	callq  *%rax

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
ffff8000001062f3:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff8000001062fa:	80 ff ff 
ffff8000001062fd:	ff d0                	callq  *%rax
ffff8000001062ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106303:	48 89 42 10          	mov    %rax,0x10(%rdx)
ffff800000106307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010630b:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff80000010630f:	48 85 c0             	test   %rax,%rax
ffff800000106312:	75 15                	jne    ffff800000106329 <allocproc+0xf3>
    p->state = UNUSED;
ffff800000106314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106318:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return 0;
ffff80000010631f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106324:	e9 88 00 00 00       	jmpq   ffff8000001063b1 <allocproc+0x17b>
  }
  sp = p->kstack + KSTACKSIZE;
ffff800000106329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010632d:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106331:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff800000106337:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
ffff80000010633b:	48 81 6d f0 b0 00 00 	subq   $0xb0,-0x10(%rbp)
ffff800000106342:	00 
  p->tf = (struct trapframe*)sp;
ffff800000106343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106347:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010634b:	48 89 50 28          	mov    %rdx,0x28(%rax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= sizeof(addr_t);
ffff80000010634f:	48 83 6d f0 08       	subq   $0x8,-0x10(%rbp)
  *(addr_t*)sp = (addr_t)syscall_trapret;
ffff800000106354:	48 ba 3e 96 10 00 00 	movabs $0xffff80000010963e,%rdx
ffff80000010635b:	80 ff ff 
ffff80000010635e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106362:	48 89 10             	mov    %rdx,(%rax)

  sp -= sizeof *p->context;
ffff800000106365:	48 83 6d f0 38       	subq   $0x38,-0x10(%rbp)
  p->context = (struct context*)sp;
ffff80000010636a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010636e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000106372:	48 89 50 30          	mov    %rdx,0x30(%rax)
  memset(p->context, 0, sizeof *p->context);
ffff800000106376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010637a:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff80000010637e:	ba 38 00 00 00       	mov    $0x38,%edx
ffff800000106383:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000106388:	48 89 c7             	mov    %rax,%rdi
ffff80000010638b:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff800000106392:	80 ff ff 
ffff800000106395:	ff d0                	callq  *%rax
  p->context->rip = (addr_t)forkret;
ffff800000106397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010639b:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff80000010639f:	48 ba b2 6e 10 00 00 	movabs $0xffff800000106eb2,%rdx
ffff8000001063a6:	80 ff ff 
ffff8000001063a9:	48 89 50 30          	mov    %rdx,0x30(%rax)

  return p;
ffff8000001063ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001063b1:	c9                   	leaveq 
ffff8000001063b2:	c3                   	retq   

ffff8000001063b3 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
ffff8000001063b3:	f3 0f 1e fa          	endbr64 
ffff8000001063b7:	55                   	push   %rbp
ffff8000001063b8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001063bb:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();
ffff8000001063bf:	48 b8 36 62 10 00 00 	movabs $0xffff800000106236,%rax
ffff8000001063c6:	80 ff ff 
ffff8000001063c9:	ff d0                	callq  *%rax
ffff8000001063cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  initproc = p;
ffff8000001063cf:	48 ba a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rdx
ffff8000001063d6:	80 ff ff 
ffff8000001063d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001063dd:	48 89 02             	mov    %rax,(%rdx)
  if((p->pgdir = setupkvm()) == 0)
ffff8000001063e0:	48 b8 90 ae 10 00 00 	movabs $0xffff80000010ae90,%rax
ffff8000001063e7:	80 ff ff 
ffff8000001063ea:	ff d0                	callq  *%rax
ffff8000001063ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001063f0:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffff8000001063f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001063f8:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001063fc:	48 85 c0             	test   %rax,%rax
ffff8000001063ff:	75 16                	jne    ffff800000106417 <userinit+0x64>
    panic("userinit: out of memory?");
ffff800000106401:	48 bf f2 c0 10 00 00 	movabs $0xffff80000010c0f2,%rdi
ffff800000106408:	80 ff ff 
ffff80000010640b:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106412:	80 ff ff 
ffff800000106415:	ff d0                	callq  *%rax

  inituvm(p->pgdir, _binary_initcode_start,
ffff800000106417:	48 b8 3c 00 00 00 00 	movabs $0x3c,%rax
ffff80000010641e:	00 00 00 
ffff800000106421:	89 c2                	mov    %eax,%edx
ffff800000106423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106427:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010642b:	48 be 50 de 10 00 00 	movabs $0xffff80000010de50,%rsi
ffff800000106432:	80 ff ff 
ffff800000106435:	48 89 c7             	mov    %rax,%rdi
ffff800000106438:	48 b8 18 b4 10 00 00 	movabs $0xffff80000010b418,%rax
ffff80000010643f:	80 ff ff 
ffff800000106442:	ff d0                	callq  *%rax
          (addr_t)_binary_initcode_size);
  p->sz = PGSIZE * 2;
ffff800000106444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106448:	48 c7 00 00 20 00 00 	movq   $0x2000,(%rax)
  memset(p->tf, 0, sizeof(*p->tf));
ffff80000010644f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106453:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000106457:	ba b0 00 00 00       	mov    $0xb0,%edx
ffff80000010645c:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000106461:	48 89 c7             	mov    %rax,%rdi
ffff800000106464:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff80000010646b:	80 ff ff 
ffff80000010646e:	ff d0                	callq  *%rax

  p->tf->r11 = FL_IF;  // with SYSRET, EFLAGS is in R11
ffff800000106470:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106474:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000106478:	48 c7 40 50 00 02 00 	movq   $0x200,0x50(%rax)
ffff80000010647f:	00 
  p->tf->rsp = p->sz;
ffff800000106480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106484:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000106488:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010648c:	48 8b 12             	mov    (%rdx),%rdx
ffff80000010648f:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  p->tf->rcx = PGSIZE;  // with SYSRET, RIP is in RCX
ffff800000106496:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010649a:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010649e:	48 c7 40 10 00 10 00 	movq   $0x1000,0x10(%rax)
ffff8000001064a5:	00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
ffff8000001064a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001064aa:	48 05 d0 00 00 00    	add    $0xd0,%rax
ffff8000001064b0:	ba 10 00 00 00       	mov    $0x10,%edx
ffff8000001064b5:	48 be 0b c1 10 00 00 	movabs $0xffff80000010c10b,%rsi
ffff8000001064bc:	80 ff ff 
ffff8000001064bf:	48 89 c7             	mov    %rax,%rdi
ffff8000001064c2:	48 b8 a1 7b 10 00 00 	movabs $0xffff800000107ba1,%rax
ffff8000001064c9:	80 ff ff 
ffff8000001064cc:	ff d0                	callq  *%rax
  p->cwd = namei("/");
ffff8000001064ce:	48 bf 14 c1 10 00 00 	movabs $0xffff80000010c114,%rdi
ffff8000001064d5:	80 ff ff 
ffff8000001064d8:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff8000001064df:	80 ff ff 
ffff8000001064e2:	ff d0                	callq  *%rax
ffff8000001064e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001064e8:	48 89 82 c8 00 00 00 	mov    %rax,0xc8(%rdx)

  __sync_synchronize();
ffff8000001064ef:	0f ae f0             	mfence 
  p->state = RUNNABLE;
ffff8000001064f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001064f6:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
}
ffff8000001064fd:	90                   	nop
ffff8000001064fe:	c9                   	leaveq 
ffff8000001064ff:	c3                   	retq   

ffff800000106500 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int64 n)
{
ffff800000106500:	f3 0f 1e fa          	endbr64 
ffff800000106504:	55                   	push   %rbp
ffff800000106505:	48 89 e5             	mov    %rsp,%rbp
ffff800000106508:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010650c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  addr_t sz;

  sz = proc->sz;
ffff800000106510:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106517:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010651b:	48 8b 00             	mov    (%rax),%rax
ffff80000010651e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n > 0){
ffff800000106522:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000106527:	7e 42                	jle    ffff80000010656b <growproc+0x6b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
ffff800000106529:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010652d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106531:	48 01 c2             	add    %rax,%rdx
ffff800000106534:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010653b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010653f:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106543:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000106547:	48 89 ce             	mov    %rcx,%rsi
ffff80000010654a:	48 89 c7             	mov    %rax,%rdi
ffff80000010654d:	48 b8 f8 b5 10 00 00 	movabs $0xffff80000010b5f8,%rax
ffff800000106554:	80 ff ff 
ffff800000106557:	ff d0                	callq  *%rax
ffff800000106559:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010655d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000106562:	75 50                	jne    ffff8000001065b4 <growproc+0xb4>
      return -1;
ffff800000106564:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106569:	eb 7a                	jmp    ffff8000001065e5 <growproc+0xe5>
  } else if(n < 0){
ffff80000010656b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000106570:	79 42                	jns    ffff8000001065b4 <growproc+0xb4>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
ffff800000106572:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106576:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010657a:	48 01 c2             	add    %rax,%rdx
ffff80000010657d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106584:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106588:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010658c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000106590:	48 89 ce             	mov    %rcx,%rsi
ffff800000106593:	48 89 c7             	mov    %rax,%rdi
ffff800000106596:	48 b8 40 b7 10 00 00 	movabs $0xffff80000010b740,%rax
ffff80000010659d:	80 ff ff 
ffff8000001065a0:	ff d0                	callq  *%rax
ffff8000001065a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001065a6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001065ab:	75 07                	jne    ffff8000001065b4 <growproc+0xb4>
      return -1;
ffff8000001065ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001065b2:	eb 31                	jmp    ffff8000001065e5 <growproc+0xe5>
  }
  proc->sz = sz;
ffff8000001065b4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001065bb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001065bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001065c3:	48 89 10             	mov    %rdx,(%rax)
  switchuvm(proc);
ffff8000001065c6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001065cd:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001065d1:	48 89 c7             	mov    %rax,%rdi
ffff8000001065d4:	48 b8 f6 af 10 00 00 	movabs $0xffff80000010aff6,%rax
ffff8000001065db:	80 ff ff 
ffff8000001065de:	ff d0                	callq  *%rax
  return 0;
ffff8000001065e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001065e5:	c9                   	leaveq 
ffff8000001065e6:	c3                   	retq   

ffff8000001065e7 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
ffff8000001065e7:	f3 0f 1e fa          	endbr64 
ffff8000001065eb:	55                   	push   %rbp
ffff8000001065ec:	48 89 e5             	mov    %rsp,%rbp
ffff8000001065ef:	53                   	push   %rbx
ffff8000001065f0:	48 83 ec 28          	sub    $0x28,%rsp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
ffff8000001065f4:	48 b8 36 62 10 00 00 	movabs $0xffff800000106236,%rax
ffff8000001065fb:	80 ff ff 
ffff8000001065fe:	ff d0                	callq  *%rax
ffff800000106600:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000106604:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff800000106609:	75 0a                	jne    ffff800000106615 <fork+0x2e>
    return -1;
ffff80000010660b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106610:	e9 85 02 00 00       	jmpq   ffff80000010689a <fork+0x2b3>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
ffff800000106615:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010661c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106620:	48 8b 00             	mov    (%rax),%rax
ffff800000106623:	89 c2                	mov    %eax,%edx
ffff800000106625:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010662c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106630:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106634:	89 d6                	mov    %edx,%esi
ffff800000106636:	48 89 c7             	mov    %rax,%rdi
ffff800000106639:	48 b8 de ba 10 00 00 	movabs $0xffff80000010bade,%rax
ffff800000106640:	80 ff ff 
ffff800000106643:	ff d0                	callq  *%rax
ffff800000106645:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000106649:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffff80000010664d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106651:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106655:	48 85 c0             	test   %rax,%rax
ffff800000106658:	75 38                	jne    ffff800000106692 <fork+0xab>
    kfree(np->kstack);
ffff80000010665a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010665e:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106662:	48 89 c7             	mov    %rax,%rdi
ffff800000106665:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010666c:	80 ff ff 
ffff80000010666f:	ff d0                	callq  *%rax
    np->kstack = 0;
ffff800000106671:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106675:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff80000010667c:	00 
    np->state = UNUSED;
ffff80000010667d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106681:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return -1;
ffff800000106688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010668d:	e9 08 02 00 00       	jmpq   ffff80000010689a <fork+0x2b3>
  }
  np->sz = proc->sz;
ffff800000106692:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106699:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010669d:	48 8b 10             	mov    (%rax),%rdx
ffff8000001066a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001066a4:	48 89 10             	mov    %rdx,(%rax)
  np->parent = proc;
ffff8000001066a7:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001066ae:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffff8000001066b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001066b6:	48 89 50 20          	mov    %rdx,0x20(%rax)
  *np->tf = *proc->tf;
ffff8000001066ba:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001066c1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001066c5:	48 8b 50 28          	mov    0x28(%rax),%rdx
ffff8000001066c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001066cd:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001066d1:	48 8b 0a             	mov    (%rdx),%rcx
ffff8000001066d4:	48 8b 5a 08          	mov    0x8(%rdx),%rbx
ffff8000001066d8:	48 89 08             	mov    %rcx,(%rax)
ffff8000001066db:	48 89 58 08          	mov    %rbx,0x8(%rax)
ffff8000001066df:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
ffff8000001066e3:	48 8b 5a 18          	mov    0x18(%rdx),%rbx
ffff8000001066e7:	48 89 48 10          	mov    %rcx,0x10(%rax)
ffff8000001066eb:	48 89 58 18          	mov    %rbx,0x18(%rax)
ffff8000001066ef:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
ffff8000001066f3:	48 8b 5a 28          	mov    0x28(%rdx),%rbx
ffff8000001066f7:	48 89 48 20          	mov    %rcx,0x20(%rax)
ffff8000001066fb:	48 89 58 28          	mov    %rbx,0x28(%rax)
ffff8000001066ff:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
ffff800000106703:	48 8b 5a 38          	mov    0x38(%rdx),%rbx
ffff800000106707:	48 89 48 30          	mov    %rcx,0x30(%rax)
ffff80000010670b:	48 89 58 38          	mov    %rbx,0x38(%rax)
ffff80000010670f:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
ffff800000106713:	48 8b 5a 48          	mov    0x48(%rdx),%rbx
ffff800000106717:	48 89 48 40          	mov    %rcx,0x40(%rax)
ffff80000010671b:	48 89 58 48          	mov    %rbx,0x48(%rax)
ffff80000010671f:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
ffff800000106723:	48 8b 5a 58          	mov    0x58(%rdx),%rbx
ffff800000106727:	48 89 48 50          	mov    %rcx,0x50(%rax)
ffff80000010672b:	48 89 58 58          	mov    %rbx,0x58(%rax)
ffff80000010672f:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
ffff800000106733:	48 8b 5a 68          	mov    0x68(%rdx),%rbx
ffff800000106737:	48 89 48 60          	mov    %rcx,0x60(%rax)
ffff80000010673b:	48 89 58 68          	mov    %rbx,0x68(%rax)
ffff80000010673f:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
ffff800000106743:	48 8b 5a 78          	mov    0x78(%rdx),%rbx
ffff800000106747:	48 89 48 70          	mov    %rcx,0x70(%rax)
ffff80000010674b:	48 89 58 78          	mov    %rbx,0x78(%rax)
ffff80000010674f:	48 8b 8a 80 00 00 00 	mov    0x80(%rdx),%rcx
ffff800000106756:	48 8b 9a 88 00 00 00 	mov    0x88(%rdx),%rbx
ffff80000010675d:	48 89 88 80 00 00 00 	mov    %rcx,0x80(%rax)
ffff800000106764:	48 89 98 88 00 00 00 	mov    %rbx,0x88(%rax)
ffff80000010676b:	48 8b 8a 90 00 00 00 	mov    0x90(%rdx),%rcx
ffff800000106772:	48 8b 9a 98 00 00 00 	mov    0x98(%rdx),%rbx
ffff800000106779:	48 89 88 90 00 00 00 	mov    %rcx,0x90(%rax)
ffff800000106780:	48 89 98 98 00 00 00 	mov    %rbx,0x98(%rax)
ffff800000106787:	48 8b 8a a0 00 00 00 	mov    0xa0(%rdx),%rcx
ffff80000010678e:	48 8b 9a a8 00 00 00 	mov    0xa8(%rdx),%rbx
ffff800000106795:	48 89 88 a0 00 00 00 	mov    %rcx,0xa0(%rax)
ffff80000010679c:	48 89 98 a8 00 00 00 	mov    %rbx,0xa8(%rax)

  // Clear %rax so that fork returns 0 in the child.
  np->tf->rax = 0;
ffff8000001067a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001067a7:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001067ab:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  for(i = 0; i < NOFILE; i++)
ffff8000001067b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff8000001067b9:	eb 5f                	jmp    ffff80000010681a <fork+0x233>
    if(proc->ofile[i])
ffff8000001067bb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001067c2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001067c6:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001067c9:	48 63 d2             	movslq %edx,%rdx
ffff8000001067cc:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001067d0:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff8000001067d5:	48 85 c0             	test   %rax,%rax
ffff8000001067d8:	74 3c                	je     ffff800000106816 <fork+0x22f>
      np->ofile[i] = filedup(proc->ofile[i]);
ffff8000001067da:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001067e1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001067e5:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001067e8:	48 63 d2             	movslq %edx,%rdx
ffff8000001067eb:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001067ef:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff8000001067f4:	48 89 c7             	mov    %rax,%rdi
ffff8000001067f7:	48 b8 1a 1c 10 00 00 	movabs $0xffff800000101c1a,%rax
ffff8000001067fe:	80 ff ff 
ffff800000106801:	ff d0                	callq  *%rax
ffff800000106803:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000106807:	8b 4d ec             	mov    -0x14(%rbp),%ecx
ffff80000010680a:	48 63 c9             	movslq %ecx,%rcx
ffff80000010680d:	48 83 c1 08          	add    $0x8,%rcx
ffff800000106811:	48 89 44 ca 08       	mov    %rax,0x8(%rdx,%rcx,8)
  for(i = 0; i < NOFILE; i++)
ffff800000106816:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffff80000010681a:	83 7d ec 0f          	cmpl   $0xf,-0x14(%rbp)
ffff80000010681e:	7e 9b                	jle    ffff8000001067bb <fork+0x1d4>
  np->cwd = idup(proc->cwd);
ffff800000106820:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106827:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010682b:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff800000106832:	48 89 c7             	mov    %rax,%rdi
ffff800000106835:	48 b8 95 28 10 00 00 	movabs $0xffff800000102895,%rax
ffff80000010683c:	80 ff ff 
ffff80000010683f:	ff d0                	callq  *%rax
ffff800000106841:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000106845:	48 89 82 c8 00 00 00 	mov    %rax,0xc8(%rdx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
ffff80000010684c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106853:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106857:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff80000010685e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106862:	48 05 d0 00 00 00    	add    $0xd0,%rax
ffff800000106868:	ba 10 00 00 00       	mov    $0x10,%edx
ffff80000010686d:	48 89 ce             	mov    %rcx,%rsi
ffff800000106870:	48 89 c7             	mov    %rax,%rdi
ffff800000106873:	48 b8 a1 7b 10 00 00 	movabs $0xffff800000107ba1,%rax
ffff80000010687a:	80 ff ff 
ffff80000010687d:	ff d0                	callq  *%rax

  pid = np->pid;
ffff80000010687f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106883:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000106886:	89 45 dc             	mov    %eax,-0x24(%rbp)

  __sync_synchronize();
ffff800000106889:	0f ae f0             	mfence 
  np->state = RUNNABLE;
ffff80000010688c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106890:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)

  return pid;
ffff800000106897:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffff80000010689a:	48 83 c4 28          	add    $0x28,%rsp
ffff80000010689e:	5b                   	pop    %rbx
ffff80000010689f:	5d                   	pop    %rbp
ffff8000001068a0:	c3                   	retq   

ffff8000001068a1 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
ffff8000001068a1:	f3 0f 1e fa          	endbr64 
ffff8000001068a5:	55                   	push   %rbp
ffff8000001068a6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001068a9:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int fd;

  if(proc == initproc)
ffff8000001068ad:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001068b4:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffff8000001068b8:	48 b8 a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rax
ffff8000001068bf:	80 ff ff 
ffff8000001068c2:	48 8b 00             	mov    (%rax),%rax
ffff8000001068c5:	48 39 c2             	cmp    %rax,%rdx
ffff8000001068c8:	75 16                	jne    ffff8000001068e0 <exit+0x3f>
    panic("init exiting");
ffff8000001068ca:	48 bf 16 c1 10 00 00 	movabs $0xffff80000010c116,%rdi
ffff8000001068d1:	80 ff ff 
ffff8000001068d4:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001068db:	80 ff ff 
ffff8000001068de:	ff d0                	callq  *%rax

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
ffff8000001068e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff8000001068e7:	eb 6a                	jmp    ffff800000106953 <exit+0xb2>
    if(proc->ofile[fd]){
ffff8000001068e9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001068f0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001068f4:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001068f7:	48 63 d2             	movslq %edx,%rdx
ffff8000001068fa:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001068fe:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000106903:	48 85 c0             	test   %rax,%rax
ffff800000106906:	74 47                	je     ffff80000010694f <exit+0xae>
      fileclose(proc->ofile[fd]);
ffff800000106908:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010690f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106913:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106916:	48 63 d2             	movslq %edx,%rdx
ffff800000106919:	48 83 c2 08          	add    $0x8,%rdx
ffff80000010691d:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000106922:	48 89 c7             	mov    %rax,%rdi
ffff800000106925:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff80000010692c:	80 ff ff 
ffff80000010692f:	ff d0                	callq  *%rax
      proc->ofile[fd] = 0;
ffff800000106931:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106938:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010693c:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010693f:	48 63 d2             	movslq %edx,%rdx
ffff800000106942:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106946:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff80000010694d:	00 00 
  for(fd = 0; fd < NOFILE; fd++){
ffff80000010694f:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff800000106953:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
ffff800000106957:	7e 90                	jle    ffff8000001068e9 <exit+0x48>
    }
  }

  begin_op();
ffff800000106959:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010695e:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000106965:	80 ff ff 
ffff800000106968:	ff d2                	callq  *%rdx
  iput(proc->cwd);
ffff80000010696a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106971:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106975:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff80000010697c:	48 89 c7             	mov    %rax,%rdi
ffff80000010697f:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000106986:	80 ff ff 
ffff800000106989:	ff d0                	callq  *%rax
  end_op();
ffff80000010698b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106990:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000106997:	80 ff ff 
ffff80000010699a:	ff d2                	callq  *%rdx
  proc->cwd = 0;
ffff80000010699c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001069a3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001069a7:	48 c7 80 c8 00 00 00 	movq   $0x0,0xc8(%rax)
ffff8000001069ae:	00 00 00 00 

  acquire(&ptable.lock);
ffff8000001069b2:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff8000001069b9:	80 ff ff 
ffff8000001069bc:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff8000001069c3:	80 ff ff 
ffff8000001069c6:	ff d0                	callq  *%rax

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
ffff8000001069c8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001069cf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001069d3:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff8000001069d7:	48 89 c7             	mov    %rax,%rdi
ffff8000001069da:	48 b8 25 70 10 00 00 	movabs $0xffff800000107025,%rax
ffff8000001069e1:	80 ff ff 
ffff8000001069e4:	ff d0                	callq  *%rax

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff8000001069e6:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff8000001069ed:	80 ff ff 
ffff8000001069f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001069f4:	eb 5d                	jmp    ffff800000106a53 <exit+0x1b2>
    if(p->parent == proc){
ffff8000001069f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001069fa:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff8000001069fe:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106a05:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106a09:	48 39 c2             	cmp    %rax,%rdx
ffff800000106a0c:	75 3d                	jne    ffff800000106a4b <exit+0x1aa>
      p->parent = initproc;
ffff800000106a0e:	48 b8 a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rax
ffff800000106a15:	80 ff ff 
ffff800000106a18:	48 8b 10             	mov    (%rax),%rdx
ffff800000106a1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a1f:	48 89 50 20          	mov    %rdx,0x20(%rax)
      if(p->state == ZOMBIE)
ffff800000106a23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a27:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106a2a:	83 f8 05             	cmp    $0x5,%eax
ffff800000106a2d:	75 1c                	jne    ffff800000106a4b <exit+0x1aa>
        wakeup1(initproc);
ffff800000106a2f:	48 b8 a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rax
ffff800000106a36:	80 ff ff 
ffff800000106a39:	48 8b 00             	mov    (%rax),%rax
ffff800000106a3c:	48 89 c7             	mov    %rax,%rdi
ffff800000106a3f:	48 b8 25 70 10 00 00 	movabs $0xffff800000107025,%rax
ffff800000106a46:	80 ff ff 
ffff800000106a49:	ff d0                	callq  *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106a4b:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff800000106a52:	00 
ffff800000106a53:	48 b8 a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rax
ffff800000106a5a:	80 ff ff 
ffff800000106a5d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106a61:	72 93                	jb     ffff8000001069f6 <exit+0x155>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
ffff800000106a63:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106a6a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106a6e:	c7 40 18 05 00 00 00 	movl   $0x5,0x18(%rax)
  sched();
ffff800000106a75:	48 b8 4e 6d 10 00 00 	movabs $0xffff800000106d4e,%rax
ffff800000106a7c:	80 ff ff 
ffff800000106a7f:	ff d0                	callq  *%rax
  panic("zombie exit");
ffff800000106a81:	48 bf 23 c1 10 00 00 	movabs $0xffff80000010c123,%rdi
ffff800000106a88:	80 ff ff 
ffff800000106a8b:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106a92:	80 ff ff 
ffff800000106a95:	ff d0                	callq  *%rax

ffff800000106a97 <wait>:
//PAGEBREAK!
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
ffff800000106a97:	f3 0f 1e fa          	endbr64 
ffff800000106a9b:	55                   	push   %rbp
ffff800000106a9c:	48 89 e5             	mov    %rsp,%rbp
ffff800000106a9f:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
ffff800000106aa3:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106aaa:	80 ff ff 
ffff800000106aad:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000106ab4:	80 ff ff 
ffff800000106ab7:	ff d0                	callq  *%rax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
ffff800000106ab9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106ac0:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000106ac7:	80 ff ff 
ffff800000106aca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106ace:	e9 d3 00 00 00       	jmpq   ffff800000106ba6 <wait+0x10f>
      if(p->parent != proc)
ffff800000106ad3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ad7:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff800000106adb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106ae2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106ae6:	48 39 c2             	cmp    %rax,%rdx
ffff800000106ae9:	0f 85 ae 00 00 00    	jne    ffff800000106b9d <wait+0x106>
        continue;
      havekids = 1;
ffff800000106aef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
      if(p->state == ZOMBIE){
ffff800000106af6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106afa:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106afd:	83 f8 05             	cmp    $0x5,%eax
ffff800000106b00:	0f 85 98 00 00 00    	jne    ffff800000106b9e <wait+0x107>
        // Found one.
        pid = p->pid;
ffff800000106b06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b0a:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000106b0d:	89 45 f0             	mov    %eax,-0x10(%rbp)
        kfree(p->kstack);
ffff800000106b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b14:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106b18:	48 89 c7             	mov    %rax,%rdi
ffff800000106b1b:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff800000106b22:	80 ff ff 
ffff800000106b25:	ff d0                	callq  *%rax
        p->kstack = 0;
ffff800000106b27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b2b:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000106b32:	00 
        freevm(p->pgdir);
ffff800000106b33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b37:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106b3b:	48 89 c7             	mov    %rax,%rdi
ffff800000106b3e:	48 b8 3a b8 10 00 00 	movabs $0xffff80000010b83a,%rax
ffff800000106b45:	80 ff ff 
ffff800000106b48:	ff d0                	callq  *%rax
        p->pid = 0;
ffff800000106b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b4e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
        p->parent = 0;
ffff800000106b55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b59:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
ffff800000106b60:	00 
        p->name[0] = 0;
ffff800000106b61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b65:	c6 80 d0 00 00 00 00 	movb   $0x0,0xd0(%rax)
        p->killed = 0;
ffff800000106b6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b70:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%rax)
        p->state = UNUSED;
ffff800000106b77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b7b:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
        release(&ptable.lock);
ffff800000106b82:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106b89:	80 ff ff 
ffff800000106b8c:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000106b93:	80 ff ff 
ffff800000106b96:	ff d0                	callq  *%rax
        return pid;
ffff800000106b98:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000106b9b:	eb 7b                	jmp    ffff800000106c18 <wait+0x181>
        continue;
ffff800000106b9d:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106b9e:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff800000106ba5:	00 
ffff800000106ba6:	48 b8 a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rax
ffff800000106bad:	80 ff ff 
ffff800000106bb0:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106bb4:	0f 82 19 ff ff ff    	jb     ffff800000106ad3 <wait+0x3c>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
ffff800000106bba:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000106bbe:	74 12                	je     ffff800000106bd2 <wait+0x13b>
ffff800000106bc0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106bc7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106bcb:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000106bce:	85 c0                	test   %eax,%eax
ffff800000106bd0:	74 1d                	je     ffff800000106bef <wait+0x158>
      release(&ptable.lock);
ffff800000106bd2:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106bd9:	80 ff ff 
ffff800000106bdc:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000106be3:	80 ff ff 
ffff800000106be6:	ff d0                	callq  *%rax
      return -1;
ffff800000106be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106bed:	eb 29                	jmp    ffff800000106c18 <wait+0x181>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
ffff800000106bef:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106bf6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106bfa:	48 be 40 74 11 00 00 	movabs $0xffff800000117440,%rsi
ffff800000106c01:	80 ff ff 
ffff800000106c04:	48 89 c7             	mov    %rax,%rdi
ffff800000106c07:	48 b8 15 6f 10 00 00 	movabs $0xffff800000106f15,%rax
ffff800000106c0e:	80 ff ff 
ffff800000106c11:	ff d0                	callq  *%rax
    havekids = 0;
ffff800000106c13:	e9 a1 fe ff ff       	jmpq   ffff800000106ab9 <wait+0x22>
  }
}
ffff800000106c18:	c9                   	leaveq 
ffff800000106c19:	c3                   	retq   

ffff800000106c1a <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
ffff800000106c1a:	f3 0f 1e fa          	endbr64 
ffff800000106c1e:	55                   	push   %rbp
ffff800000106c1f:	48 89 e5             	mov    %rsp,%rbp
ffff800000106c22:	48 83 ec 20          	sub    $0x20,%rsp
  int i = 0;
ffff800000106c26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  struct proc *p;
  int skipped = 0;
ffff800000106c2d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  for(;;){
    ++i;
ffff800000106c34:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    // Enable interrupts on this processor.
    sti();
ffff800000106c38:	48 b8 f3 61 10 00 00 	movabs $0xffff8000001061f3,%rax
ffff800000106c3f:	80 ff ff 
ffff800000106c42:	ff d0                	callq  *%rax
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
ffff800000106c44:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106c4b:	80 ff ff 
ffff800000106c4e:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000106c55:	80 ff ff 
ffff800000106c58:	ff d0                	callq  *%rax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106c5a:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000106c61:	80 ff ff 
ffff800000106c64:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000106c68:	e9 92 00 00 00       	jmpq   ffff800000106cff <scheduler+0xe5>
      if(p->state != RUNNABLE) {
ffff800000106c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106c71:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106c74:	83 f8 03             	cmp    $0x3,%eax
ffff800000106c77:	74 06                	je     ffff800000106c7f <scheduler+0x65>
        skipped++;
ffff800000106c79:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
        continue;
ffff800000106c7d:	eb 78                	jmp    ffff800000106cf7 <scheduler+0xdd>
      }
      skipped = 0;
ffff800000106c7f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
ffff800000106c86:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106c8d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000106c91:	64 48 89 10          	mov    %rdx,%fs:(%rax)
      switchuvm(p);
ffff800000106c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106c99:	48 89 c7             	mov    %rax,%rdi
ffff800000106c9c:	48 b8 f6 af 10 00 00 	movabs $0xffff80000010aff6,%rax
ffff800000106ca3:	80 ff ff 
ffff800000106ca6:	ff d0                	callq  *%rax
      p->state = RUNNING;
ffff800000106ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106cac:	c7 40 18 04 00 00 00 	movl   $0x4,0x18(%rax)
      swtch(&cpu->scheduler, p->context);
ffff800000106cb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106cb7:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000106cbb:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffff800000106cc2:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000106cc6:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106cca:	48 89 c6             	mov    %rax,%rsi
ffff800000106ccd:	48 89 d7             	mov    %rdx,%rdi
ffff800000106cd0:	48 b8 3d 7c 10 00 00 	movabs $0xffff800000107c3d,%rax
ffff800000106cd7:	80 ff ff 
ffff800000106cda:	ff d0                	callq  *%rax
      switchkvm();
ffff800000106cdc:	48 b8 07 b3 10 00 00 	movabs $0xffff80000010b307,%rax
ffff800000106ce3:	80 ff ff 
ffff800000106ce6:	ff d0                	callq  *%rax

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
ffff800000106ce8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106cef:	64 48 c7 00 00 00 00 	movq   $0x0,%fs:(%rax)
ffff800000106cf6:	00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106cf7:	48 81 45 f0 e0 00 00 	addq   $0xe0,-0x10(%rbp)
ffff800000106cfe:	00 
ffff800000106cff:	48 b8 a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rax
ffff800000106d06:	80 ff ff 
ffff800000106d09:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000106d0d:	0f 82 5a ff ff ff    	jb     ffff800000106c6d <scheduler+0x53>
    }
    release(&ptable.lock);
ffff800000106d13:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106d1a:	80 ff ff 
ffff800000106d1d:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000106d24:	80 ff ff 
ffff800000106d27:	ff d0                	callq  *%rax
    if (skipped > (2*NPROC)) {
ffff800000106d29:	81 7d ec 80 00 00 00 	cmpl   $0x80,-0x14(%rbp)
ffff800000106d30:	0f 8e fe fe ff ff    	jle    ffff800000106c34 <scheduler+0x1a>
      hlt();
ffff800000106d36:	48 b8 ff 61 10 00 00 	movabs $0xffff8000001061ff,%rax
ffff800000106d3d:	80 ff ff 
ffff800000106d40:	ff d0                	callq  *%rax
      skipped = 0;
ffff800000106d42:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    ++i;
ffff800000106d49:	e9 e6 fe ff ff       	jmpq   ffff800000106c34 <scheduler+0x1a>

ffff800000106d4e <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
ffff800000106d4e:	f3 0f 1e fa          	endbr64 
ffff800000106d52:	55                   	push   %rbp
ffff800000106d53:	48 89 e5             	mov    %rsp,%rbp
ffff800000106d56:	48 83 ec 10          	sub    $0x10,%rsp
  int intena;


  if(!holding(&ptable.lock))
ffff800000106d5a:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106d61:	80 ff ff 
ffff800000106d64:	48 b8 13 77 10 00 00 	movabs $0xffff800000107713,%rax
ffff800000106d6b:	80 ff ff 
ffff800000106d6e:	ff d0                	callq  *%rax
ffff800000106d70:	85 c0                	test   %eax,%eax
ffff800000106d72:	75 16                	jne    ffff800000106d8a <sched+0x3c>
    panic("sched ptable.lock");
ffff800000106d74:	48 bf 2f c1 10 00 00 	movabs $0xffff80000010c12f,%rdi
ffff800000106d7b:	80 ff ff 
ffff800000106d7e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106d85:	80 ff ff 
ffff800000106d88:	ff d0                	callq  *%rax
  if(cpu->ncli != 1)
ffff800000106d8a:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106d91:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d95:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000106d98:	83 f8 01             	cmp    $0x1,%eax
ffff800000106d9b:	74 16                	je     ffff800000106db3 <sched+0x65>
    panic("sched locks");
ffff800000106d9d:	48 bf 41 c1 10 00 00 	movabs $0xffff80000010c141,%rdi
ffff800000106da4:	80 ff ff 
ffff800000106da7:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106dae:	80 ff ff 
ffff800000106db1:	ff d0                	callq  *%rax
  if(proc->state == RUNNING)
ffff800000106db3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106dba:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106dbe:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106dc1:	83 f8 04             	cmp    $0x4,%eax
ffff800000106dc4:	75 16                	jne    ffff800000106ddc <sched+0x8e>
    panic("sched running");
ffff800000106dc6:	48 bf 4d c1 10 00 00 	movabs $0xffff80000010c14d,%rdi
ffff800000106dcd:	80 ff ff 
ffff800000106dd0:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106dd7:	80 ff ff 
ffff800000106dda:	ff d0                	callq  *%rax
  if(readeflags()&FL_IF)
ffff800000106ddc:	48 b8 db 61 10 00 00 	movabs $0xffff8000001061db,%rax
ffff800000106de3:	80 ff ff 
ffff800000106de6:	ff d0                	callq  *%rax
ffff800000106de8:	25 00 02 00 00       	and    $0x200,%eax
ffff800000106ded:	48 85 c0             	test   %rax,%rax
ffff800000106df0:	74 16                	je     ffff800000106e08 <sched+0xba>
    panic("sched interruptible");
ffff800000106df2:	48 bf 5b c1 10 00 00 	movabs $0xffff80000010c15b,%rdi
ffff800000106df9:	80 ff ff 
ffff800000106dfc:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106e03:	80 ff ff 
ffff800000106e06:	ff d0                	callq  *%rax
  intena = cpu->intena;
ffff800000106e08:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106e0f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106e13:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106e16:	89 45 fc             	mov    %eax,-0x4(%rbp)

  swtch(&proc->context, cpu->scheduler);
ffff800000106e19:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106e20:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106e24:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106e28:	48 c7 c2 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rdx
ffff800000106e2f:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000106e33:	48 83 c2 30          	add    $0x30,%rdx
ffff800000106e37:	48 89 c6             	mov    %rax,%rsi
ffff800000106e3a:	48 89 d7             	mov    %rdx,%rdi
ffff800000106e3d:	48 b8 3d 7c 10 00 00 	movabs $0xffff800000107c3d,%rax
ffff800000106e44:	80 ff ff 
ffff800000106e47:	ff d0                	callq  *%rax
  cpu->intena = intena;
ffff800000106e49:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106e50:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106e54:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000106e57:	89 50 18             	mov    %edx,0x18(%rax)
}
ffff800000106e5a:	90                   	nop
ffff800000106e5b:	c9                   	leaveq 
ffff800000106e5c:	c3                   	retq   

ffff800000106e5d <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
ffff800000106e5d:	f3 0f 1e fa          	endbr64 
ffff800000106e61:	55                   	push   %rbp
ffff800000106e62:	48 89 e5             	mov    %rsp,%rbp
  acquire(&ptable.lock);  //DOC: yieldlock
ffff800000106e65:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106e6c:	80 ff ff 
ffff800000106e6f:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000106e76:	80 ff ff 
ffff800000106e79:	ff d0                	callq  *%rax
  proc->state = RUNNABLE;
ffff800000106e7b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106e82:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106e86:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  sched();
ffff800000106e8d:	48 b8 4e 6d 10 00 00 	movabs $0xffff800000106d4e,%rax
ffff800000106e94:	80 ff ff 
ffff800000106e97:	ff d0                	callq  *%rax
  release(&ptable.lock);
ffff800000106e99:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106ea0:	80 ff ff 
ffff800000106ea3:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000106eaa:	80 ff ff 
ffff800000106ead:	ff d0                	callq  *%rax
}
ffff800000106eaf:	90                   	nop
ffff800000106eb0:	5d                   	pop    %rbp
ffff800000106eb1:	c3                   	retq   

ffff800000106eb2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
ffff800000106eb2:	f3 0f 1e fa          	endbr64 
ffff800000106eb6:	55                   	push   %rbp
ffff800000106eb7:	48 89 e5             	mov    %rsp,%rbp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
ffff800000106eba:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106ec1:	80 ff ff 
ffff800000106ec4:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000106ecb:	80 ff ff 
ffff800000106ece:	ff d0                	callq  *%rax

  if (first) {
ffff800000106ed0:	48 b8 44 d5 10 00 00 	movabs $0xffff80000010d544,%rax
ffff800000106ed7:	80 ff ff 
ffff800000106eda:	8b 00                	mov    (%rax),%eax
ffff800000106edc:	85 c0                	test   %eax,%eax
ffff800000106ede:	74 32                	je     ffff800000106f12 <forkret+0x60>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
ffff800000106ee0:	48 b8 44 d5 10 00 00 	movabs $0xffff80000010d544,%rax
ffff800000106ee7:	80 ff ff 
ffff800000106eea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    iinit(ROOTDEV);
ffff800000106ef0:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000106ef5:	48 b8 6e 24 10 00 00 	movabs $0xffff80000010246e,%rax
ffff800000106efc:	80 ff ff 
ffff800000106eff:	ff d0                	callq  *%rax
    initlog(ROOTDEV);
ffff800000106f01:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000106f06:	48 b8 1e 4c 10 00 00 	movabs $0xffff800000104c1e,%rax
ffff800000106f0d:	80 ff ff 
ffff800000106f10:	ff d0                	callq  *%rax
  }

  // Return to "caller", actually trapret (see allocproc).
}
ffff800000106f12:	90                   	nop
ffff800000106f13:	5d                   	pop    %rbp
ffff800000106f14:	c3                   	retq   

ffff800000106f15 <sleep>:
//PAGEBREAK!
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
ffff800000106f15:	f3 0f 1e fa          	endbr64 
ffff800000106f19:	55                   	push   %rbp
ffff800000106f1a:	48 89 e5             	mov    %rsp,%rbp
ffff800000106f1d:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106f21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106f25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(proc == 0)
ffff800000106f29:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106f30:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106f34:	48 85 c0             	test   %rax,%rax
ffff800000106f37:	75 16                	jne    ffff800000106f4f <sleep+0x3a>
    panic("sleep");
ffff800000106f39:	48 bf 6f c1 10 00 00 	movabs $0xffff80000010c16f,%rdi
ffff800000106f40:	80 ff ff 
ffff800000106f43:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106f4a:	80 ff ff 
ffff800000106f4d:	ff d0                	callq  *%rax

  if(lk == 0)
ffff800000106f4f:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000106f54:	75 16                	jne    ffff800000106f6c <sleep+0x57>
    panic("sleep without lk");
ffff800000106f56:	48 bf 75 c1 10 00 00 	movabs $0xffff80000010c175,%rdi
ffff800000106f5d:	80 ff ff 
ffff800000106f60:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000106f67:	80 ff ff 
ffff800000106f6a:	ff d0                	callq  *%rax
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
ffff800000106f6c:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106f73:	80 ff ff 
ffff800000106f76:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000106f7a:	74 29                	je     ffff800000106fa5 <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
ffff800000106f7c:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000106f83:	80 ff ff 
ffff800000106f86:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000106f8d:	80 ff ff 
ffff800000106f90:	ff d0                	callq  *%rax
    release(lk);
ffff800000106f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106f96:	48 89 c7             	mov    %rax,%rdi
ffff800000106f99:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000106fa0:	80 ff ff 
ffff800000106fa3:	ff d0                	callq  *%rax
  }

  // Go to sleep.
  proc->chan = chan;
ffff800000106fa5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106fac:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106fb0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106fb4:	48 89 50 38          	mov    %rdx,0x38(%rax)
  proc->state = SLEEPING;
ffff800000106fb8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106fbf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106fc3:	c7 40 18 02 00 00 00 	movl   $0x2,0x18(%rax)
  sched();
ffff800000106fca:	48 b8 4e 6d 10 00 00 	movabs $0xffff800000106d4e,%rax
ffff800000106fd1:	80 ff ff 
ffff800000106fd4:	ff d0                	callq  *%rax

  // Tidy up.
  proc->chan = 0;
ffff800000106fd6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106fdd:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106fe1:	48 c7 40 38 00 00 00 	movq   $0x0,0x38(%rax)
ffff800000106fe8:	00 

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
ffff800000106fe9:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106ff0:	80 ff ff 
ffff800000106ff3:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000106ff7:	74 29                	je     ffff800000107022 <sleep+0x10d>
    release(&ptable.lock);
ffff800000106ff9:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000107000:	80 ff ff 
ffff800000107003:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010700a:	80 ff ff 
ffff80000010700d:	ff d0                	callq  *%rax
    acquire(lk);
ffff80000010700f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107013:	48 89 c7             	mov    %rax,%rdi
ffff800000107016:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff80000010701d:	80 ff ff 
ffff800000107020:	ff d0                	callq  *%rax
  }
}
ffff800000107022:	90                   	nop
ffff800000107023:	c9                   	leaveq 
ffff800000107024:	c3                   	retq   

ffff800000107025 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
ffff800000107025:	f3 0f 1e fa          	endbr64 
ffff800000107029:	55                   	push   %rbp
ffff80000010702a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010702d:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107031:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000107035:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff80000010703c:	80 ff ff 
ffff80000010703f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000107043:	eb 2d                	jmp    ffff800000107072 <wakeup1+0x4d>
    if(p->state == SLEEPING && p->chan == chan)
ffff800000107045:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107049:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010704c:	83 f8 02             	cmp    $0x2,%eax
ffff80000010704f:	75 19                	jne    ffff80000010706a <wakeup1+0x45>
ffff800000107051:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107055:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff800000107059:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff80000010705d:	75 0b                	jne    ffff80000010706a <wakeup1+0x45>
      p->state = RUNNABLE;
ffff80000010705f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107063:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff80000010706a:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff800000107071:	00 
ffff800000107072:	48 b8 a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rax
ffff800000107079:	80 ff ff 
ffff80000010707c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107080:	72 c3                	jb     ffff800000107045 <wakeup1+0x20>
}
ffff800000107082:	90                   	nop
ffff800000107083:	90                   	nop
ffff800000107084:	c9                   	leaveq 
ffff800000107085:	c3                   	retq   

ffff800000107086 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
ffff800000107086:	f3 0f 1e fa          	endbr64 
ffff80000010708a:	55                   	push   %rbp
ffff80000010708b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010708e:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107092:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ptable.lock);
ffff800000107096:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff80000010709d:	80 ff ff 
ffff8000001070a0:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff8000001070a7:	80 ff ff 
ffff8000001070aa:	ff d0                	callq  *%rax
  wakeup1(chan);
ffff8000001070ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001070b0:	48 89 c7             	mov    %rax,%rdi
ffff8000001070b3:	48 b8 25 70 10 00 00 	movabs $0xffff800000107025,%rax
ffff8000001070ba:	80 ff ff 
ffff8000001070bd:	ff d0                	callq  *%rax
  release(&ptable.lock);
ffff8000001070bf:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff8000001070c6:	80 ff ff 
ffff8000001070c9:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001070d0:	80 ff ff 
ffff8000001070d3:	ff d0                	callq  *%rax
}
ffff8000001070d5:	90                   	nop
ffff8000001070d6:	c9                   	leaveq 
ffff8000001070d7:	c3                   	retq   

ffff8000001070d8 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
ffff8000001070d8:	f3 0f 1e fa          	endbr64 
ffff8000001070dc:	55                   	push   %rbp
ffff8000001070dd:	48 89 e5             	mov    %rsp,%rbp
ffff8000001070e0:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001070e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  struct proc *p;

  acquire(&ptable.lock);
ffff8000001070e7:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff8000001070ee:	80 ff ff 
ffff8000001070f1:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff8000001070f8:	80 ff ff 
ffff8000001070fb:	ff d0                	callq  *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff8000001070fd:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000107104:	80 ff ff 
ffff800000107107:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010710b:	eb 53                	jmp    ffff800000107160 <kill+0x88>
    if(p->pid == pid){
ffff80000010710d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107111:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000107114:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000107117:	75 3f                	jne    ffff800000107158 <kill+0x80>
      p->killed = 1;
ffff800000107119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010711d:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
ffff800000107124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107128:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010712b:	83 f8 02             	cmp    $0x2,%eax
ffff80000010712e:	75 0b                	jne    ffff80000010713b <kill+0x63>
        p->state = RUNNABLE;
ffff800000107130:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107134:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
      release(&ptable.lock);
ffff80000010713b:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000107142:	80 ff ff 
ffff800000107145:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010714c:	80 ff ff 
ffff80000010714f:	ff d0                	callq  *%rax
      return 0;
ffff800000107151:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107156:	eb 33                	jmp    ffff80000010718b <kill+0xb3>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000107158:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffff80000010715f:	00 
ffff800000107160:	48 b8 a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rax
ffff800000107167:	80 ff ff 
ffff80000010716a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010716e:	72 9d                	jb     ffff80000010710d <kill+0x35>
    }
  }
  release(&ptable.lock);
ffff800000107170:	48 bf 40 74 11 00 00 	movabs $0xffff800000117440,%rdi
ffff800000107177:	80 ff ff 
ffff80000010717a:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000107181:	80 ff ff 
ffff800000107184:	ff d0                	callq  *%rax
  return -1;
ffff800000107186:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff80000010718b:	c9                   	leaveq 
ffff80000010718c:	c3                   	retq   

ffff80000010718d <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
ffff80000010718d:	f3 0f 1e fa          	endbr64 
ffff800000107191:	55                   	push   %rbp
ffff800000107192:	48 89 e5             	mov    %rsp,%rbp
ffff800000107195:	48 83 ec 70          	sub    $0x70,%rsp
  int i;
  struct proc *p;
  char *state;
  addr_t pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000107199:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff8000001071a0:	80 ff ff 
ffff8000001071a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001071a7:	e9 3b 01 00 00       	jmpq   ffff8000001072e7 <procdump+0x15a>
    if(p->state == UNUSED)
ffff8000001071ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001071b0:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001071b3:	85 c0                	test   %eax,%eax
ffff8000001071b5:	0f 84 23 01 00 00    	je     ffff8000001072de <procdump+0x151>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
ffff8000001071bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001071bf:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001071c2:	83 f8 05             	cmp    $0x5,%eax
ffff8000001071c5:	77 39                	ja     ffff800000107200 <procdump+0x73>
ffff8000001071c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001071cb:	8b 50 18             	mov    0x18(%rax),%edx
ffff8000001071ce:	48 b8 60 d5 10 00 00 	movabs $0xffff80000010d560,%rax
ffff8000001071d5:	80 ff ff 
ffff8000001071d8:	89 d2                	mov    %edx,%edx
ffff8000001071da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffff8000001071de:	48 85 c0             	test   %rax,%rax
ffff8000001071e1:	74 1d                	je     ffff800000107200 <procdump+0x73>
      state = states[p->state];
ffff8000001071e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001071e7:	8b 50 18             	mov    0x18(%rax),%edx
ffff8000001071ea:	48 b8 60 d5 10 00 00 	movabs $0xffff80000010d560,%rax
ffff8000001071f1:	80 ff ff 
ffff8000001071f4:	89 d2                	mov    %edx,%edx
ffff8000001071f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffff8000001071fa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001071fe:	eb 0e                	jmp    ffff80000010720e <procdump+0x81>
    else
      state = "???";
ffff800000107200:	48 b8 86 c1 10 00 00 	movabs $0xffff80000010c186,%rax
ffff800000107207:	80 ff ff 
ffff80000010720a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    cprintf("%d %s %s", p->pid, state, p->name);
ffff80000010720e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107212:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff800000107219:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010721d:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000107220:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107224:	89 c6                	mov    %eax,%esi
ffff800000107226:	48 bf 8a c1 10 00 00 	movabs $0xffff80000010c18a,%rdi
ffff80000010722d:	80 ff ff 
ffff800000107230:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107235:	49 b8 18 08 10 00 00 	movabs $0xffff800000100818,%r8
ffff80000010723c:	80 ff ff 
ffff80000010723f:	41 ff d0             	callq  *%r8
    if(p->state == SLEEPING){
ffff800000107242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107246:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107249:	83 f8 02             	cmp    $0x2,%eax
ffff80000010724c:	75 73                	jne    ffff8000001072c1 <procdump+0x134>
      getstackpcs((addr_t*)p->context->rbp+2, pc);
ffff80000010724e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107252:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000107256:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010725a:	48 83 c0 10          	add    $0x10,%rax
ffff80000010725e:	48 89 c2             	mov    %rax,%rdx
ffff800000107261:	48 8d 45 90          	lea    -0x70(%rbp),%rax
ffff800000107265:	48 89 c6             	mov    %rax,%rsi
ffff800000107268:	48 89 d7             	mov    %rdx,%rdi
ffff80000010726b:	48 b8 75 76 10 00 00 	movabs $0xffff800000107675,%rax
ffff800000107272:	80 ff ff 
ffff800000107275:	ff d0                	callq  *%rax
      for(i=0; i<10 && pc[i] != 0; i++)
ffff800000107277:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010727e:	eb 2c                	jmp    ffff8000001072ac <procdump+0x11f>
        cprintf(" %p", pc[i]);
ffff800000107280:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107283:	48 98                	cltq   
ffff800000107285:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffff80000010728a:	48 89 c6             	mov    %rax,%rsi
ffff80000010728d:	48 bf 93 c1 10 00 00 	movabs $0xffff80000010c193,%rdi
ffff800000107294:	80 ff ff 
ffff800000107297:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010729c:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff8000001072a3:	80 ff ff 
ffff8000001072a6:	ff d2                	callq  *%rdx
      for(i=0; i<10 && pc[i] != 0; i++)
ffff8000001072a8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001072ac:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff8000001072b0:	7f 0f                	jg     ffff8000001072c1 <procdump+0x134>
ffff8000001072b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001072b5:	48 98                	cltq   
ffff8000001072b7:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffff8000001072bc:	48 85 c0             	test   %rax,%rax
ffff8000001072bf:	75 bf                	jne    ffff800000107280 <procdump+0xf3>
    }
    cprintf("\n");
ffff8000001072c1:	48 bf 97 c1 10 00 00 	movabs $0xffff80000010c197,%rdi
ffff8000001072c8:	80 ff ff 
ffff8000001072cb:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001072d0:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff8000001072d7:	80 ff ff 
ffff8000001072da:	ff d2                	callq  *%rdx
ffff8000001072dc:	eb 01                	jmp    ffff8000001072df <procdump+0x152>
      continue;
ffff8000001072de:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff8000001072df:	48 81 45 f0 e0 00 00 	addq   $0xe0,-0x10(%rbp)
ffff8000001072e6:	00 
ffff8000001072e7:	48 b8 a8 ac 11 00 00 	movabs $0xffff80000011aca8,%rax
ffff8000001072ee:	80 ff ff 
ffff8000001072f1:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff8000001072f5:	0f 82 b1 fe ff ff    	jb     ffff8000001071ac <procdump+0x1f>
  }
}
ffff8000001072fb:	90                   	nop
ffff8000001072fc:	90                   	nop
ffff8000001072fd:	c9                   	leaveq 
ffff8000001072fe:	c3                   	retq   

ffff8000001072ff <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
ffff8000001072ff:	f3 0f 1e fa          	endbr64 
ffff800000107303:	55                   	push   %rbp
ffff800000107304:	48 89 e5             	mov    %rsp,%rbp
ffff800000107307:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010730b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010730f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&lk->lk, "sleep lock");
ffff800000107313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107317:	48 83 c0 08          	add    $0x8,%rax
ffff80000010731b:	48 be c3 c1 10 00 00 	movabs $0xffff80000010c1c3,%rsi
ffff800000107322:	80 ff ff 
ffff800000107325:	48 89 c7             	mov    %rax,%rdi
ffff800000107328:	48 b8 f2 74 10 00 00 	movabs $0xffff8000001074f2,%rax
ffff80000010732f:	80 ff ff 
ffff800000107332:	ff d0                	callq  *%rax
  lk->name = name;
ffff800000107334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107338:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010733c:	48 89 50 70          	mov    %rdx,0x70(%rax)
  lk->locked = 0;
ffff800000107340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107344:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->pid = 0;
ffff80000010734a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010734e:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%rax)
}
ffff800000107355:	90                   	nop
ffff800000107356:	c9                   	leaveq 
ffff800000107357:	c3                   	retq   

ffff800000107358 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
ffff800000107358:	f3 0f 1e fa          	endbr64 
ffff80000010735c:	55                   	push   %rbp
ffff80000010735d:	48 89 e5             	mov    %rsp,%rbp
ffff800000107360:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107364:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&lk->lk);
ffff800000107368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010736c:	48 83 c0 08          	add    $0x8,%rax
ffff800000107370:	48 89 c7             	mov    %rax,%rdi
ffff800000107373:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff80000010737a:	80 ff ff 
ffff80000010737d:	ff d0                	callq  *%rax
  while (lk->locked)
ffff80000010737f:	eb 1e                	jmp    ffff80000010739f <acquiresleep+0x47>
    sleep(lk, &lk->lk);
ffff800000107381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107385:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000107389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010738d:	48 89 d6             	mov    %rdx,%rsi
ffff800000107390:	48 89 c7             	mov    %rax,%rdi
ffff800000107393:	48 b8 15 6f 10 00 00 	movabs $0xffff800000106f15,%rax
ffff80000010739a:	80 ff ff 
ffff80000010739d:	ff d0                	callq  *%rax
  while (lk->locked)
ffff80000010739f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001073a3:	8b 00                	mov    (%rax),%eax
ffff8000001073a5:	85 c0                	test   %eax,%eax
ffff8000001073a7:	75 d8                	jne    ffff800000107381 <acquiresleep+0x29>
  lk->locked = 1;
ffff8000001073a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001073ad:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  lk->pid = proc->pid;
ffff8000001073b3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001073ba:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001073be:	8b 50 1c             	mov    0x1c(%rax),%edx
ffff8000001073c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001073c5:	89 50 78             	mov    %edx,0x78(%rax)
  release(&lk->lk);
ffff8000001073c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001073cc:	48 83 c0 08          	add    $0x8,%rax
ffff8000001073d0:	48 89 c7             	mov    %rax,%rdi
ffff8000001073d3:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001073da:	80 ff ff 
ffff8000001073dd:	ff d0                	callq  *%rax
}
ffff8000001073df:	90                   	nop
ffff8000001073e0:	c9                   	leaveq 
ffff8000001073e1:	c3                   	retq   

ffff8000001073e2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
ffff8000001073e2:	f3 0f 1e fa          	endbr64 
ffff8000001073e6:	55                   	push   %rbp
ffff8000001073e7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001073ea:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001073ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&lk->lk);
ffff8000001073f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001073f6:	48 83 c0 08          	add    $0x8,%rax
ffff8000001073fa:	48 89 c7             	mov    %rax,%rdi
ffff8000001073fd:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000107404:	80 ff ff 
ffff800000107407:	ff d0                	callq  *%rax
  lk->locked = 0;
ffff800000107409:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010740d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->pid = 0;
ffff800000107413:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107417:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%rax)
  wakeup(lk);
ffff80000010741e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107422:	48 89 c7             	mov    %rax,%rdi
ffff800000107425:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff80000010742c:	80 ff ff 
ffff80000010742f:	ff d0                	callq  *%rax
  release(&lk->lk);
ffff800000107431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107435:	48 83 c0 08          	add    $0x8,%rax
ffff800000107439:	48 89 c7             	mov    %rax,%rdi
ffff80000010743c:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000107443:	80 ff ff 
ffff800000107446:	ff d0                	callq  *%rax
}
ffff800000107448:	90                   	nop
ffff800000107449:	c9                   	leaveq 
ffff80000010744a:	c3                   	retq   

ffff80000010744b <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
ffff80000010744b:	f3 0f 1e fa          	endbr64 
ffff80000010744f:	55                   	push   %rbp
ffff800000107450:	48 89 e5             	mov    %rsp,%rbp
ffff800000107453:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107457:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  acquire(&lk->lk);
ffff80000010745b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010745f:	48 83 c0 08          	add    $0x8,%rax
ffff800000107463:	48 89 c7             	mov    %rax,%rdi
ffff800000107466:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff80000010746d:	80 ff ff 
ffff800000107470:	ff d0                	callq  *%rax
  int r = lk->locked;
ffff800000107472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107476:	8b 00                	mov    (%rax),%eax
ffff800000107478:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&lk->lk);
ffff80000010747b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010747f:	48 83 c0 08          	add    $0x8,%rax
ffff800000107483:	48 89 c7             	mov    %rax,%rdi
ffff800000107486:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff80000010748d:	80 ff ff 
ffff800000107490:	ff d0                	callq  *%rax
  return r;
ffff800000107492:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000107495:	c9                   	leaveq 
ffff800000107496:	c3                   	retq   

ffff800000107497 <readeflags>:
{
ffff800000107497:	f3 0f 1e fa          	endbr64 
ffff80000010749b:	55                   	push   %rbp
ffff80000010749c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010749f:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff8000001074a3:	9c                   	pushfq 
ffff8000001074a4:	58                   	pop    %rax
ffff8000001074a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff8000001074a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001074ad:	c9                   	leaveq 
ffff8000001074ae:	c3                   	retq   

ffff8000001074af <cli>:
{
ffff8000001074af:	f3 0f 1e fa          	endbr64 
ffff8000001074b3:	55                   	push   %rbp
ffff8000001074b4:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffff8000001074b7:	fa                   	cli    
}
ffff8000001074b8:	90                   	nop
ffff8000001074b9:	5d                   	pop    %rbp
ffff8000001074ba:	c3                   	retq   

ffff8000001074bb <sti>:
{
ffff8000001074bb:	f3 0f 1e fa          	endbr64 
ffff8000001074bf:	55                   	push   %rbp
ffff8000001074c0:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffff8000001074c3:	fb                   	sti    
}
ffff8000001074c4:	90                   	nop
ffff8000001074c5:	5d                   	pop    %rbp
ffff8000001074c6:	c3                   	retq   

ffff8000001074c7 <xchg>:
{
ffff8000001074c7:	f3 0f 1e fa          	endbr64 
ffff8000001074cb:	55                   	push   %rbp
ffff8000001074cc:	48 89 e5             	mov    %rsp,%rbp
ffff8000001074cf:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001074d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001074d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  asm volatile("lock; xchgl %0, %1" :
ffff8000001074db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001074df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001074e3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff8000001074e7:	f0 87 02             	lock xchg %eax,(%rdx)
ffff8000001074ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  return result;
ffff8000001074ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001074f0:	c9                   	leaveq 
ffff8000001074f1:	c3                   	retq   

ffff8000001074f2 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
ffff8000001074f2:	f3 0f 1e fa          	endbr64 
ffff8000001074f6:	55                   	push   %rbp
ffff8000001074f7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001074fa:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001074fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107502:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  lk->name = name;
ffff800000107506:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010750a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010750e:	48 89 50 08          	mov    %rdx,0x8(%rax)
  lk->locked = 0;
ffff800000107512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107516:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->cpu = 0;
ffff80000010751c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107520:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000107527:	00 
}
ffff800000107528:	90                   	nop
ffff800000107529:	c9                   	leaveq 
ffff80000010752a:	c3                   	retq   

ffff80000010752b <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
ffff80000010752b:	f3 0f 1e fa          	endbr64 
ffff80000010752f:	55                   	push   %rbp
ffff800000107530:	48 89 e5             	mov    %rsp,%rbp
ffff800000107533:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107537:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  pushcli(); // disable interrupts to avoid deadlock.
ffff80000010753b:	48 b8 53 77 10 00 00 	movabs $0xffff800000107753,%rax
ffff800000107542:	80 ff ff 
ffff800000107545:	ff d0                	callq  *%rax
  if(holding(lk))
ffff800000107547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010754b:	48 89 c7             	mov    %rax,%rdi
ffff80000010754e:	48 b8 13 77 10 00 00 	movabs $0xffff800000107713,%rax
ffff800000107555:	80 ff ff 
ffff800000107558:	ff d0                	callq  *%rax
ffff80000010755a:	85 c0                	test   %eax,%eax
ffff80000010755c:	74 16                	je     ffff800000107574 <acquire+0x49>
    panic("acquire");
ffff80000010755e:	48 bf ce c1 10 00 00 	movabs $0xffff80000010c1ce,%rdi
ffff800000107565:	80 ff ff 
ffff800000107568:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010756f:	80 ff ff 
ffff800000107572:	ff d0                	callq  *%rax

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
ffff800000107574:	90                   	nop
ffff800000107575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107579:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010757e:	48 89 c7             	mov    %rax,%rdi
ffff800000107581:	48 b8 c7 74 10 00 00 	movabs $0xffff8000001074c7,%rax
ffff800000107588:	80 ff ff 
ffff80000010758b:	ff d0                	callq  *%rax
ffff80000010758d:	85 c0                	test   %eax,%eax
ffff80000010758f:	75 e4                	jne    ffff800000107575 <acquire+0x4a>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
ffff800000107591:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
ffff800000107594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107598:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffff80000010759f:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff8000001075a3:	48 89 50 10          	mov    %rdx,0x10(%rax)
  getcallerpcs(&lk, lk->pcs);
ffff8000001075a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075ab:	48 8d 50 18          	lea    0x18(%rax),%rdx
ffff8000001075af:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff8000001075b3:	48 89 d6             	mov    %rdx,%rsi
ffff8000001075b6:	48 89 c7             	mov    %rax,%rdi
ffff8000001075b9:	48 b8 3d 76 10 00 00 	movabs $0xffff80000010763d,%rax
ffff8000001075c0:	80 ff ff 
ffff8000001075c3:	ff d0                	callq  *%rax
}
ffff8000001075c5:	90                   	nop
ffff8000001075c6:	c9                   	leaveq 
ffff8000001075c7:	c3                   	retq   

ffff8000001075c8 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
ffff8000001075c8:	f3 0f 1e fa          	endbr64 
ffff8000001075cc:	55                   	push   %rbp
ffff8000001075cd:	48 89 e5             	mov    %rsp,%rbp
ffff8000001075d0:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001075d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holding(lk))
ffff8000001075d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001075dc:	48 89 c7             	mov    %rax,%rdi
ffff8000001075df:	48 b8 13 77 10 00 00 	movabs $0xffff800000107713,%rax
ffff8000001075e6:	80 ff ff 
ffff8000001075e9:	ff d0                	callq  *%rax
ffff8000001075eb:	85 c0                	test   %eax,%eax
ffff8000001075ed:	75 16                	jne    ffff800000107605 <release+0x3d>
    panic("release");
ffff8000001075ef:	48 bf d6 c1 10 00 00 	movabs $0xffff80000010c1d6,%rdi
ffff8000001075f6:	80 ff ff 
ffff8000001075f9:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107600:	80 ff ff 
ffff800000107603:	ff d0                	callq  *%rax

  lk->pcs[0] = 0;
ffff800000107605:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107609:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
ffff800000107610:	00 
  lk->cpu = 0;
ffff800000107611:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107615:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff80000010761c:	00 
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
ffff80000010761d:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
ffff800000107620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107624:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000107628:	c7 00 00 00 00 00    	movl   $0x0,(%rax)

  popcli();
ffff80000010762e:	48 b8 c5 77 10 00 00 	movabs $0xffff8000001077c5,%rax
ffff800000107635:	80 ff ff 
ffff800000107638:	ff d0                	callq  *%rax
}
ffff80000010763a:	90                   	nop
ffff80000010763b:	c9                   	leaveq 
ffff80000010763c:	c3                   	retq   

ffff80000010763d <getcallerpcs>:

// Record the current call stack in pcs[] by following the %rbp chain.
void
getcallerpcs(void *v, addr_t pcs[])
{
ffff80000010763d:	f3 0f 1e fa          	endbr64 
ffff800000107641:	55                   	push   %rbp
ffff800000107642:	48 89 e5             	mov    %rsp,%rbp
ffff800000107645:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107649:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010764d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  addr_t *rbp;

  asm volatile("mov %%rbp, %0" : "=r" (rbp));
ffff800000107651:	48 89 e8             	mov    %rbp,%rax
ffff800000107654:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  getstackpcs(rbp, pcs);
ffff800000107658:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010765c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107660:	48 89 d6             	mov    %rdx,%rsi
ffff800000107663:	48 89 c7             	mov    %rax,%rdi
ffff800000107666:	48 b8 75 76 10 00 00 	movabs $0xffff800000107675,%rax
ffff80000010766d:	80 ff ff 
ffff800000107670:	ff d0                	callq  *%rax
}
ffff800000107672:	90                   	nop
ffff800000107673:	c9                   	leaveq 
ffff800000107674:	c3                   	retq   

ffff800000107675 <getstackpcs>:

void
getstackpcs(addr_t *rbp, addr_t pcs[])
{
ffff800000107675:	f3 0f 1e fa          	endbr64 
ffff800000107679:	55                   	push   %rbp
ffff80000010767a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010767d:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107681:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107685:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  for(i = 0; i < 10; i++){
ffff800000107689:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000107690:	eb 50                	jmp    ffff8000001076e2 <getstackpcs+0x6d>
    if(rbp == 0 || rbp < (addr_t*)KERNBASE || rbp == (addr_t*)0xffffffff)
ffff800000107692:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000107697:	74 70                	je     ffff800000107709 <getstackpcs+0x94>
ffff800000107699:	48 b8 ff ff ff ff ff 	movabs $0xffff7fffffffffff,%rax
ffff8000001076a0:	7f ff ff 
ffff8000001076a3:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff8000001076a7:	76 60                	jbe    ffff800000107709 <getstackpcs+0x94>
ffff8000001076a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001076ae:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff8000001076b2:	74 55                	je     ffff800000107709 <getstackpcs+0x94>
      break;
    pcs[i] = rbp[1];     // saved %rip
ffff8000001076b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001076b7:	48 98                	cltq   
ffff8000001076b9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001076c0:	00 
ffff8000001076c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001076c5:	48 01 c2             	add    %rax,%rdx
ffff8000001076c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001076cc:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001076d0:	48 89 02             	mov    %rax,(%rdx)
    rbp = (addr_t*)rbp[0]; // saved %rbp
ffff8000001076d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001076d7:	48 8b 00             	mov    (%rax),%rax
ffff8000001076da:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(i = 0; i < 10; i++){
ffff8000001076de:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001076e2:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff8000001076e6:	7e aa                	jle    ffff800000107692 <getstackpcs+0x1d>
  }
  for(; i < 10; i++)
ffff8000001076e8:	eb 1f                	jmp    ffff800000107709 <getstackpcs+0x94>
    pcs[i] = 0;
ffff8000001076ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001076ed:	48 98                	cltq   
ffff8000001076ef:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001076f6:	00 
ffff8000001076f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001076fb:	48 01 d0             	add    %rdx,%rax
ffff8000001076fe:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(; i < 10; i++)
ffff800000107705:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107709:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff80000010770d:	7e db                	jle    ffff8000001076ea <getstackpcs+0x75>
}
ffff80000010770f:	90                   	nop
ffff800000107710:	90                   	nop
ffff800000107711:	c9                   	leaveq 
ffff800000107712:	c3                   	retq   

ffff800000107713 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
ffff800000107713:	f3 0f 1e fa          	endbr64 
ffff800000107717:	55                   	push   %rbp
ffff800000107718:	48 89 e5             	mov    %rsp,%rbp
ffff80000010771b:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010771f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return lock->locked && lock->cpu == cpu;
ffff800000107723:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107727:	8b 00                	mov    (%rax),%eax
ffff800000107729:	85 c0                	test   %eax,%eax
ffff80000010772b:	74 1f                	je     ffff80000010774c <holding+0x39>
ffff80000010772d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107731:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000107735:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff80000010773c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107740:	48 39 c2             	cmp    %rax,%rdx
ffff800000107743:	75 07                	jne    ffff80000010774c <holding+0x39>
ffff800000107745:	b8 01 00 00 00       	mov    $0x1,%eax
ffff80000010774a:	eb 05                	jmp    ffff800000107751 <holding+0x3e>
ffff80000010774c:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107751:	c9                   	leaveq 
ffff800000107752:	c3                   	retq   

ffff800000107753 <pushcli>:
// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.
void
pushcli(void)
{
ffff800000107753:	f3 0f 1e fa          	endbr64 
ffff800000107757:	55                   	push   %rbp
ffff800000107758:	48 89 e5             	mov    %rsp,%rbp
ffff80000010775b:	48 83 ec 10          	sub    $0x10,%rsp
  int eflags;

  eflags = readeflags();
ffff80000010775f:	48 b8 97 74 10 00 00 	movabs $0xffff800000107497,%rax
ffff800000107766:	80 ff ff 
ffff800000107769:	ff d0                	callq  *%rax
ffff80000010776b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  cli();
ffff80000010776e:	48 b8 af 74 10 00 00 	movabs $0xffff8000001074af,%rax
ffff800000107775:	80 ff ff 
ffff800000107778:	ff d0                	callq  *%rax
  if(cpu->ncli == 0)
ffff80000010777a:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107781:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107785:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000107788:	85 c0                	test   %eax,%eax
ffff80000010778a:	75 17                	jne    ffff8000001077a3 <pushcli+0x50>
    cpu->intena = eflags & FL_IF;
ffff80000010778c:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107793:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107797:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010779a:	81 e2 00 02 00 00    	and    $0x200,%edx
ffff8000001077a0:	89 50 18             	mov    %edx,0x18(%rax)
  cpu->ncli += 1;
ffff8000001077a3:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff8000001077aa:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001077ae:	8b 50 14             	mov    0x14(%rax),%edx
ffff8000001077b1:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff8000001077b8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001077bc:	83 c2 01             	add    $0x1,%edx
ffff8000001077bf:	89 50 14             	mov    %edx,0x14(%rax)
}
ffff8000001077c2:	90                   	nop
ffff8000001077c3:	c9                   	leaveq 
ffff8000001077c4:	c3                   	retq   

ffff8000001077c5 <popcli>:

void
popcli(void)
{
ffff8000001077c5:	f3 0f 1e fa          	endbr64 
ffff8000001077c9:	55                   	push   %rbp
ffff8000001077ca:	48 89 e5             	mov    %rsp,%rbp
  if(readeflags()&FL_IF)
ffff8000001077cd:	48 b8 97 74 10 00 00 	movabs $0xffff800000107497,%rax
ffff8000001077d4:	80 ff ff 
ffff8000001077d7:	ff d0                	callq  *%rax
ffff8000001077d9:	25 00 02 00 00       	and    $0x200,%eax
ffff8000001077de:	48 85 c0             	test   %rax,%rax
ffff8000001077e1:	74 16                	je     ffff8000001077f9 <popcli+0x34>
    panic("popcli - interruptible");
ffff8000001077e3:	48 bf de c1 10 00 00 	movabs $0xffff80000010c1de,%rdi
ffff8000001077ea:	80 ff ff 
ffff8000001077ed:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001077f4:	80 ff ff 
ffff8000001077f7:	ff d0                	callq  *%rax
  if(--cpu->ncli < 0)
ffff8000001077f9:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107800:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107804:	8b 50 14             	mov    0x14(%rax),%edx
ffff800000107807:	83 ea 01             	sub    $0x1,%edx
ffff80000010780a:	89 50 14             	mov    %edx,0x14(%rax)
ffff80000010780d:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000107810:	85 c0                	test   %eax,%eax
ffff800000107812:	79 16                	jns    ffff80000010782a <popcli+0x65>
    panic("popcli");
ffff800000107814:	48 bf f5 c1 10 00 00 	movabs $0xffff80000010c1f5,%rdi
ffff80000010781b:	80 ff ff 
ffff80000010781e:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107825:	80 ff ff 
ffff800000107828:	ff d0                	callq  *%rax
  if(cpu->ncli == 0 && cpu->intena)
ffff80000010782a:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107831:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107835:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000107838:	85 c0                	test   %eax,%eax
ffff80000010783a:	75 1e                	jne    ffff80000010785a <popcli+0x95>
ffff80000010783c:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107843:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107847:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010784a:	85 c0                	test   %eax,%eax
ffff80000010784c:	74 0c                	je     ffff80000010785a <popcli+0x95>
    sti();
ffff80000010784e:	48 b8 bb 74 10 00 00 	movabs $0xffff8000001074bb,%rax
ffff800000107855:	80 ff ff 
ffff800000107858:	ff d0                	callq  *%rax
}
ffff80000010785a:	90                   	nop
ffff80000010785b:	5d                   	pop    %rbp
ffff80000010785c:	c3                   	retq   

ffff80000010785d <stosb>:
{
ffff80000010785d:	f3 0f 1e fa          	endbr64 
ffff800000107861:	55                   	push   %rbp
ffff800000107862:	48 89 e5             	mov    %rsp,%rbp
ffff800000107865:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107869:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010786d:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000107870:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
ffff800000107873:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000107877:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff80000010787a:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010787d:	48 89 ce             	mov    %rcx,%rsi
ffff800000107880:	48 89 f7             	mov    %rsi,%rdi
ffff800000107883:	89 d1                	mov    %edx,%ecx
ffff800000107885:	fc                   	cld    
ffff800000107886:	f3 aa                	rep stos %al,%es:(%rdi)
ffff800000107888:	89 ca                	mov    %ecx,%edx
ffff80000010788a:	48 89 fe             	mov    %rdi,%rsi
ffff80000010788d:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffff800000107891:	89 55 f0             	mov    %edx,-0x10(%rbp)
}
ffff800000107894:	90                   	nop
ffff800000107895:	c9                   	leaveq 
ffff800000107896:	c3                   	retq   

ffff800000107897 <stosl>:
{
ffff800000107897:	f3 0f 1e fa          	endbr64 
ffff80000010789b:	55                   	push   %rbp
ffff80000010789c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010789f:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001078a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001078a7:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff8000001078aa:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosl" :
ffff8000001078ad:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001078b1:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff8000001078b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001078b7:	48 89 ce             	mov    %rcx,%rsi
ffff8000001078ba:	48 89 f7             	mov    %rsi,%rdi
ffff8000001078bd:	89 d1                	mov    %edx,%ecx
ffff8000001078bf:	fc                   	cld    
ffff8000001078c0:	f3 ab                	rep stos %eax,%es:(%rdi)
ffff8000001078c2:	89 ca                	mov    %ecx,%edx
ffff8000001078c4:	48 89 fe             	mov    %rdi,%rsi
ffff8000001078c7:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffff8000001078cb:	89 55 f0             	mov    %edx,-0x10(%rbp)
}
ffff8000001078ce:	90                   	nop
ffff8000001078cf:	c9                   	leaveq 
ffff8000001078d0:	c3                   	retq   

ffff8000001078d1 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint64 n)
{
ffff8000001078d1:	f3 0f 1e fa          	endbr64 
ffff8000001078d5:	55                   	push   %rbp
ffff8000001078d6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001078d9:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001078dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001078e1:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff8000001078e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  if ((addr_t)dst%4 == 0 && n%4 == 0){
ffff8000001078e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001078ec:	83 e0 03             	and    $0x3,%eax
ffff8000001078ef:	48 85 c0             	test   %rax,%rax
ffff8000001078f2:	75 53                	jne    ffff800000107947 <memset+0x76>
ffff8000001078f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001078f8:	83 e0 03             	and    $0x3,%eax
ffff8000001078fb:	48 85 c0             	test   %rax,%rax
ffff8000001078fe:	75 47                	jne    ffff800000107947 <memset+0x76>
    c &= 0xFF;
ffff800000107900:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
ffff800000107907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010790b:	48 c1 e8 02          	shr    $0x2,%rax
ffff80000010790f:	89 c6                	mov    %eax,%esi
ffff800000107911:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107914:	c1 e0 18             	shl    $0x18,%eax
ffff800000107917:	89 c2                	mov    %eax,%edx
ffff800000107919:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010791c:	c1 e0 10             	shl    $0x10,%eax
ffff80000010791f:	09 c2                	or     %eax,%edx
ffff800000107921:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107924:	c1 e0 08             	shl    $0x8,%eax
ffff800000107927:	09 d0                	or     %edx,%eax
ffff800000107929:	0b 45 f4             	or     -0xc(%rbp),%eax
ffff80000010792c:	89 c1                	mov    %eax,%ecx
ffff80000010792e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107932:	89 f2                	mov    %esi,%edx
ffff800000107934:	89 ce                	mov    %ecx,%esi
ffff800000107936:	48 89 c7             	mov    %rax,%rdi
ffff800000107939:	48 b8 97 78 10 00 00 	movabs $0xffff800000107897,%rax
ffff800000107940:	80 ff ff 
ffff800000107943:	ff d0                	callq  *%rax
ffff800000107945:	eb 1e                	jmp    ffff800000107965 <memset+0x94>
  } else
    stosb(dst, c, n);
ffff800000107947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010794b:	89 c2                	mov    %eax,%edx
ffff80000010794d:	8b 4d f4             	mov    -0xc(%rbp),%ecx
ffff800000107950:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107954:	89 ce                	mov    %ecx,%esi
ffff800000107956:	48 89 c7             	mov    %rax,%rdi
ffff800000107959:	48 b8 5d 78 10 00 00 	movabs $0xffff80000010785d,%rax
ffff800000107960:	80 ff ff 
ffff800000107963:	ff d0                	callq  *%rax
  return dst;
ffff800000107965:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107969:	c9                   	leaveq 
ffff80000010796a:	c3                   	retq   

ffff80000010796b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
ffff80000010796b:	f3 0f 1e fa          	endbr64 
ffff80000010796f:	55                   	push   %rbp
ffff800000107970:	48 89 e5             	mov    %rsp,%rbp
ffff800000107973:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107977:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010797b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010797f:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const uchar *s1, *s2;

  s1 = v1;
ffff800000107982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107986:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  s2 = v2;
ffff80000010798a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010798e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0){
ffff800000107992:	eb 36                	jmp    ffff8000001079ca <memcmp+0x5f>
    if(*s1 != *s2)
ffff800000107994:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107998:	0f b6 10             	movzbl (%rax),%edx
ffff80000010799b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010799f:	0f b6 00             	movzbl (%rax),%eax
ffff8000001079a2:	38 c2                	cmp    %al,%dl
ffff8000001079a4:	74 1a                	je     ffff8000001079c0 <memcmp+0x55>
      return *s1 - *s2;
ffff8000001079a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001079aa:	0f b6 00             	movzbl (%rax),%eax
ffff8000001079ad:	0f b6 d0             	movzbl %al,%edx
ffff8000001079b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001079b4:	0f b6 00             	movzbl (%rax),%eax
ffff8000001079b7:	0f b6 c0             	movzbl %al,%eax
ffff8000001079ba:	29 c2                	sub    %eax,%edx
ffff8000001079bc:	89 d0                	mov    %edx,%eax
ffff8000001079be:	eb 1c                	jmp    ffff8000001079dc <memcmp+0x71>
    s1++, s2++;
ffff8000001079c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff8000001079c5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(n-- > 0){
ffff8000001079ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001079cd:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001079d0:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff8000001079d3:	85 c0                	test   %eax,%eax
ffff8000001079d5:	75 bd                	jne    ffff800000107994 <memcmp+0x29>
  }

  return 0;
ffff8000001079d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001079dc:	c9                   	leaveq 
ffff8000001079dd:	c3                   	retq   

ffff8000001079de <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
ffff8000001079de:	f3 0f 1e fa          	endbr64 
ffff8000001079e2:	55                   	push   %rbp
ffff8000001079e3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001079e6:	48 83 ec 28          	sub    $0x28,%rsp
ffff8000001079ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001079ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001079f2:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const char *s;
  char *d;

  s = src;
ffff8000001079f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001079f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  d = dst;
ffff8000001079fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107a01:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(s < d && s + n > d){
ffff800000107a05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a09:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff800000107a0d:	73 63                	jae    ffff800000107a72 <memmove+0x94>
ffff800000107a0f:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000107a12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a16:	48 01 d0             	add    %rdx,%rax
ffff800000107a19:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000107a1d:	73 53                	jae    ffff800000107a72 <memmove+0x94>
    s += n;
ffff800000107a1f:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107a22:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    d += n;
ffff800000107a26:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107a29:	48 01 45 f0          	add    %rax,-0x10(%rbp)
    while(n-- > 0)
ffff800000107a2d:	eb 17                	jmp    ffff800000107a46 <memmove+0x68>
      *--d = *--s;
ffff800000107a2f:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
ffff800000107a34:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
ffff800000107a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a3d:	0f b6 10             	movzbl (%rax),%edx
ffff800000107a40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107a44:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
ffff800000107a46:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107a49:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107a4c:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107a4f:	85 c0                	test   %eax,%eax
ffff800000107a51:	75 dc                	jne    ffff800000107a2f <memmove+0x51>
  if(s < d && s + n > d){
ffff800000107a53:	eb 2a                	jmp    ffff800000107a7f <memmove+0xa1>
  } else
    while(n-- > 0)
      *d++ = *s++;
ffff800000107a55:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000107a59:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000107a5d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000107a61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107a65:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000107a69:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
ffff800000107a6d:	0f b6 12             	movzbl (%rdx),%edx
ffff800000107a70:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
ffff800000107a72:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107a75:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107a78:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107a7b:	85 c0                	test   %eax,%eax
ffff800000107a7d:	75 d6                	jne    ffff800000107a55 <memmove+0x77>

  return dst;
ffff800000107a7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffff800000107a83:	c9                   	leaveq 
ffff800000107a84:	c3                   	retq   

ffff800000107a85 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
ffff800000107a85:	f3 0f 1e fa          	endbr64 
ffff800000107a89:	55                   	push   %rbp
ffff800000107a8a:	48 89 e5             	mov    %rsp,%rbp
ffff800000107a8d:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107a91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107a95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107a99:	89 55 ec             	mov    %edx,-0x14(%rbp)
  return memmove(dst, src, n);
ffff800000107a9c:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000107a9f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff800000107aa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107aa7:	48 89 ce             	mov    %rcx,%rsi
ffff800000107aaa:	48 89 c7             	mov    %rax,%rdi
ffff800000107aad:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff800000107ab4:	80 ff ff 
ffff800000107ab7:	ff d0                	callq  *%rax
}
ffff800000107ab9:	c9                   	leaveq 
ffff800000107aba:	c3                   	retq   

ffff800000107abb <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
ffff800000107abb:	f3 0f 1e fa          	endbr64 
ffff800000107abf:	55                   	push   %rbp
ffff800000107ac0:	48 89 e5             	mov    %rsp,%rbp
ffff800000107ac3:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107ac7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107acb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107acf:	89 55 ec             	mov    %edx,-0x14(%rbp)
  while(n > 0 && *p && *p == *q)
ffff800000107ad2:	eb 0e                	jmp    ffff800000107ae2 <strncmp+0x27>
    n--, p++, q++;
ffff800000107ad4:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
ffff800000107ad8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000107add:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(n > 0 && *p && *p == *q)
ffff800000107ae2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff800000107ae6:	74 1d                	je     ffff800000107b05 <strncmp+0x4a>
ffff800000107ae8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107aec:	0f b6 00             	movzbl (%rax),%eax
ffff800000107aef:	84 c0                	test   %al,%al
ffff800000107af1:	74 12                	je     ffff800000107b05 <strncmp+0x4a>
ffff800000107af3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107af7:	0f b6 10             	movzbl (%rax),%edx
ffff800000107afa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107afe:	0f b6 00             	movzbl (%rax),%eax
ffff800000107b01:	38 c2                	cmp    %al,%dl
ffff800000107b03:	74 cf                	je     ffff800000107ad4 <strncmp+0x19>
  if(n == 0)
ffff800000107b05:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff800000107b09:	75 07                	jne    ffff800000107b12 <strncmp+0x57>
    return 0;
ffff800000107b0b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107b10:	eb 18                	jmp    ffff800000107b2a <strncmp+0x6f>
  return (uchar)*p - (uchar)*q;
ffff800000107b12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107b16:	0f b6 00             	movzbl (%rax),%eax
ffff800000107b19:	0f b6 d0             	movzbl %al,%edx
ffff800000107b1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107b20:	0f b6 00             	movzbl (%rax),%eax
ffff800000107b23:	0f b6 c0             	movzbl %al,%eax
ffff800000107b26:	29 c2                	sub    %eax,%edx
ffff800000107b28:	89 d0                	mov    %edx,%eax
}
ffff800000107b2a:	c9                   	leaveq 
ffff800000107b2b:	c3                   	retq   

ffff800000107b2c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
ffff800000107b2c:	f3 0f 1e fa          	endbr64 
ffff800000107b30:	55                   	push   %rbp
ffff800000107b31:	48 89 e5             	mov    %rsp,%rbp
ffff800000107b34:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107b38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107b3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107b40:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os = s;
ffff800000107b43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107b47:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(n-- > 0 && (*s++ = *t++) != 0)
ffff800000107b4b:	90                   	nop
ffff800000107b4c:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107b4f:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107b52:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107b55:	85 c0                	test   %eax,%eax
ffff800000107b57:	7e 35                	jle    ffff800000107b8e <strncpy+0x62>
ffff800000107b59:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000107b5d:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000107b61:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000107b65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107b69:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000107b6d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
ffff800000107b71:	0f b6 12             	movzbl (%rdx),%edx
ffff800000107b74:	88 10                	mov    %dl,(%rax)
ffff800000107b76:	0f b6 00             	movzbl (%rax),%eax
ffff800000107b79:	84 c0                	test   %al,%al
ffff800000107b7b:	75 cf                	jne    ffff800000107b4c <strncpy+0x20>
    ;
  while(n-- > 0)
ffff800000107b7d:	eb 0f                	jmp    ffff800000107b8e <strncpy+0x62>
    *s++ = 0;
ffff800000107b7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107b83:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000107b87:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffff800000107b8b:	c6 00 00             	movb   $0x0,(%rax)
  while(n-- > 0)
ffff800000107b8e:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000107b91:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000107b94:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000107b97:	85 c0                	test   %eax,%eax
ffff800000107b99:	7f e4                	jg     ffff800000107b7f <strncpy+0x53>
  return os;
ffff800000107b9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107b9f:	c9                   	leaveq 
ffff800000107ba0:	c3                   	retq   

ffff800000107ba1 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
ffff800000107ba1:	f3 0f 1e fa          	endbr64 
ffff800000107ba5:	55                   	push   %rbp
ffff800000107ba6:	48 89 e5             	mov    %rsp,%rbp
ffff800000107ba9:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000107bad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107bb1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107bb5:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os = s;
ffff800000107bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107bbc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n <= 0)
ffff800000107bc0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000107bc4:	7f 06                	jg     ffff800000107bcc <safestrcpy+0x2b>
    return os;
ffff800000107bc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107bca:	eb 39                	jmp    ffff800000107c05 <safestrcpy+0x64>
  while(--n > 0 && (*s++ = *t++) != 0)
ffff800000107bcc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
ffff800000107bd0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000107bd4:	7e 24                	jle    ffff800000107bfa <safestrcpy+0x59>
ffff800000107bd6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000107bda:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000107bde:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000107be2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107be6:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000107bea:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
ffff800000107bee:	0f b6 12             	movzbl (%rdx),%edx
ffff800000107bf1:	88 10                	mov    %dl,(%rax)
ffff800000107bf3:	0f b6 00             	movzbl (%rax),%eax
ffff800000107bf6:	84 c0                	test   %al,%al
ffff800000107bf8:	75 d2                	jne    ffff800000107bcc <safestrcpy+0x2b>
    ;
  *s = 0;
ffff800000107bfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107bfe:	c6 00 00             	movb   $0x0,(%rax)
  return os;
ffff800000107c01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107c05:	c9                   	leaveq 
ffff800000107c06:	c3                   	retq   

ffff800000107c07 <strlen>:

int
strlen(const char *s)
{
ffff800000107c07:	f3 0f 1e fa          	endbr64 
ffff800000107c0b:	55                   	push   %rbp
ffff800000107c0c:	48 89 e5             	mov    %rsp,%rbp
ffff800000107c0f:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107c13:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
ffff800000107c17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000107c1e:	eb 04                	jmp    ffff800000107c24 <strlen+0x1d>
ffff800000107c20:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107c24:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107c27:	48 63 d0             	movslq %eax,%rdx
ffff800000107c2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107c2e:	48 01 d0             	add    %rdx,%rax
ffff800000107c31:	0f b6 00             	movzbl (%rax),%eax
ffff800000107c34:	84 c0                	test   %al,%al
ffff800000107c36:	75 e8                	jne    ffff800000107c20 <strlen+0x19>
    ;
  return n;
ffff800000107c38:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000107c3b:	c9                   	leaveq 
ffff800000107c3c:	c3                   	retq   

ffff800000107c3d <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
ffff800000107c3d:	55                   	push   %rbp
  pushq   %rbx
ffff800000107c3e:	53                   	push   %rbx
  pushq   %r12
ffff800000107c3f:	41 54                	push   %r12
  pushq   %r13
ffff800000107c41:	41 55                	push   %r13
  pushq   %r14
ffff800000107c43:	41 56                	push   %r14
  pushq   %r15
ffff800000107c45:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
ffff800000107c47:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
ffff800000107c4a:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
ffff800000107c4d:	41 5f                	pop    %r15
  popq    %r14
ffff800000107c4f:	41 5e                	pop    %r14
  popq    %r13
ffff800000107c51:	41 5d                	pop    %r13
  popq    %r12
ffff800000107c53:	41 5c                	pop    %r12
  popq    %rbx
ffff800000107c55:	5b                   	pop    %rbx
  popq    %rbp
ffff800000107c56:	5d                   	pop    %rbp

  retq #??
ffff800000107c57:	c3                   	retq   

ffff800000107c58 <fetchint>:
#include "syscall.h"

// Fetch the int at addr from the current process.
int
fetchint(addr_t addr, int *ip)
{
ffff800000107c58:	f3 0f 1e fa          	endbr64 
ffff800000107c5c:	55                   	push   %rbp
ffff800000107c5d:	48 89 e5             	mov    %rsp,%rbp
ffff800000107c60:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107c64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107c68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr >= proc->sz || addr+sizeof(int) > proc->sz)
ffff800000107c6c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107c73:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107c77:	48 8b 00             	mov    (%rax),%rax
ffff800000107c7a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107c7e:	73 1b                	jae    ffff800000107c9b <fetchint+0x43>
ffff800000107c80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c84:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000107c88:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107c8f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107c93:	48 8b 00             	mov    (%rax),%rax
ffff800000107c96:	48 39 c2             	cmp    %rax,%rdx
ffff800000107c99:	76 07                	jbe    ffff800000107ca2 <fetchint+0x4a>
    return -1;
ffff800000107c9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107ca0:	eb 11                	jmp    ffff800000107cb3 <fetchint+0x5b>
  *ip = *(int*)(addr);
ffff800000107ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107ca6:	8b 10                	mov    (%rax),%edx
ffff800000107ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107cac:	89 10                	mov    %edx,(%rax)
  return 0;
ffff800000107cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107cb3:	c9                   	leaveq 
ffff800000107cb4:	c3                   	retq   

ffff800000107cb5 <fetchaddr>:

int
fetchaddr(addr_t addr, addr_t *ip)
{
ffff800000107cb5:	f3 0f 1e fa          	endbr64 
ffff800000107cb9:	55                   	push   %rbp
ffff800000107cba:	48 89 e5             	mov    %rsp,%rbp
ffff800000107cbd:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107cc1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107cc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr >= proc->sz || addr+sizeof(addr_t) > proc->sz)
ffff800000107cc9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107cd0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107cd4:	48 8b 00             	mov    (%rax),%rax
ffff800000107cd7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107cdb:	73 1b                	jae    ffff800000107cf8 <fetchaddr+0x43>
ffff800000107cdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107ce1:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000107ce5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107cec:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107cf0:	48 8b 00             	mov    (%rax),%rax
ffff800000107cf3:	48 39 c2             	cmp    %rax,%rdx
ffff800000107cf6:	76 07                	jbe    ffff800000107cff <fetchaddr+0x4a>
    return -1;
ffff800000107cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107cfd:	eb 13                	jmp    ffff800000107d12 <fetchaddr+0x5d>
  *ip = *(addr_t*)(addr);
ffff800000107cff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d03:	48 8b 10             	mov    (%rax),%rdx
ffff800000107d06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107d0a:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff800000107d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107d12:	c9                   	leaveq 
ffff800000107d13:	c3                   	retq   

ffff800000107d14 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(addr_t addr, char **pp)
{
ffff800000107d14:	f3 0f 1e fa          	endbr64 
ffff800000107d18:	55                   	push   %rbp
ffff800000107d19:	48 89 e5             	mov    %rsp,%rbp
ffff800000107d1c:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107d20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107d24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s, *ep;

  if(addr >= proc->sz)
ffff800000107d28:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107d2f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107d33:	48 8b 00             	mov    (%rax),%rax
ffff800000107d36:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000107d3a:	72 07                	jb     ffff800000107d43 <fetchstr+0x2f>
    return -1;
ffff800000107d3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107d41:	eb 5c                	jmp    ffff800000107d9f <fetchstr+0x8b>
  *pp = (char*)addr;
ffff800000107d43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107d47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107d4b:	48 89 10             	mov    %rdx,(%rax)
  ep = (char*)proc->sz;
ffff800000107d4e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107d55:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107d59:	48 8b 00             	mov    (%rax),%rax
ffff800000107d5c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(s = *pp; s < ep; s++)
ffff800000107d60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107d64:	48 8b 00             	mov    (%rax),%rax
ffff800000107d67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000107d6b:	eb 23                	jmp    ffff800000107d90 <fetchstr+0x7c>
    if(*s == 0)
ffff800000107d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d71:	0f b6 00             	movzbl (%rax),%eax
ffff800000107d74:	84 c0                	test   %al,%al
ffff800000107d76:	75 13                	jne    ffff800000107d8b <fetchstr+0x77>
      return s - *pp;
ffff800000107d78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107d7c:	48 8b 00             	mov    (%rax),%rax
ffff800000107d7f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000107d83:	48 29 c2             	sub    %rax,%rdx
ffff800000107d86:	48 89 d0             	mov    %rdx,%rax
ffff800000107d89:	eb 14                	jmp    ffff800000107d9f <fetchstr+0x8b>
  for(s = *pp; s < ep; s++)
ffff800000107d8b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000107d90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d94:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff800000107d98:	72 d3                	jb     ffff800000107d6d <fetchstr+0x59>
  return -1;
ffff800000107d9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000107d9f:	c9                   	leaveq 
ffff800000107da0:	c3                   	retq   

ffff800000107da1 <fetcharg>:

static addr_t
fetcharg(int n)
{
ffff800000107da1:	f3 0f 1e fa          	endbr64 
ffff800000107da5:	55                   	push   %rbp
ffff800000107da6:	48 89 e5             	mov    %rsp,%rbp
ffff800000107da9:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107dad:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000107db0:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
ffff800000107db4:	0f 87 9c 00 00 00    	ja     ffff800000107e56 <fetcharg+0xb5>
ffff800000107dba:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107dbd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000107dc4:	00 
ffff800000107dc5:	48 b8 10 c2 10 00 00 	movabs $0xffff80000010c210,%rax
ffff800000107dcc:	80 ff ff 
ffff800000107dcf:	48 01 d0             	add    %rdx,%rax
ffff800000107dd2:	48 8b 00             	mov    (%rax),%rax
ffff800000107dd5:	3e ff e0             	notrack jmpq *%rax
  switch (n) {
  case 0: return proc->tf->rdi;
ffff800000107dd8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107ddf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107de3:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107de7:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000107deb:	eb 7f                	jmp    ffff800000107e6c <fetcharg+0xcb>
  case 1: return proc->tf->rsi;
ffff800000107ded:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107df4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107df8:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107dfc:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107e00:	eb 6a                	jmp    ffff800000107e6c <fetcharg+0xcb>
  case 2: return proc->tf->rdx;
ffff800000107e02:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107e09:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e0d:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107e11:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000107e15:	eb 55                	jmp    ffff800000107e6c <fetcharg+0xcb>
  case 3: return proc->tf->r10;
ffff800000107e17:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107e1e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e22:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107e26:	48 8b 40 48          	mov    0x48(%rax),%rax
ffff800000107e2a:	eb 40                	jmp    ffff800000107e6c <fetcharg+0xcb>
  case 4: return proc->tf->r8;
ffff800000107e2c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107e33:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e37:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107e3b:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff800000107e3f:	eb 2b                	jmp    ffff800000107e6c <fetcharg+0xcb>
  case 5: return proc->tf->r9;
ffff800000107e41:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107e48:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e4c:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107e50:	48 8b 40 40          	mov    0x40(%rax),%rax
ffff800000107e54:	eb 16                	jmp    ffff800000107e6c <fetcharg+0xcb>
  }
  panic("failed fetch");
ffff800000107e56:	48 bf 00 c2 10 00 00 	movabs $0xffff80000010c200,%rdi
ffff800000107e5d:	80 ff ff 
ffff800000107e60:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000107e67:	80 ff ff 
ffff800000107e6a:	ff d0                	callq  *%rax
}
ffff800000107e6c:	c9                   	leaveq 
ffff800000107e6d:	c3                   	retq   

ffff800000107e6e <argint>:

int
argint(int n, int *ip)
{
ffff800000107e6e:	f3 0f 1e fa          	endbr64 
ffff800000107e72:	55                   	push   %rbp
ffff800000107e73:	48 89 e5             	mov    %rsp,%rbp
ffff800000107e76:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107e7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000107e7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffff800000107e81:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107e84:	89 c7                	mov    %eax,%edi
ffff800000107e86:	48 b8 a1 7d 10 00 00 	movabs $0xffff800000107da1,%rax
ffff800000107e8d:	80 ff ff 
ffff800000107e90:	ff d0                	callq  *%rax
ffff800000107e92:	89 c2                	mov    %eax,%edx
ffff800000107e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107e98:	89 10                	mov    %edx,(%rax)
  return 0;
ffff800000107e9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107e9f:	c9                   	leaveq 
ffff800000107ea0:	c3                   	retq   

ffff800000107ea1 <argaddr>:

int
argaddr(int n, addr_t *ip)
{
ffff800000107ea1:	f3 0f 1e fa          	endbr64 
ffff800000107ea5:	55                   	push   %rbp
ffff800000107ea6:	48 89 e5             	mov    %rsp,%rbp
ffff800000107ea9:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107ead:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000107eb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffff800000107eb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107eb7:	89 c7                	mov    %eax,%edi
ffff800000107eb9:	48 b8 a1 7d 10 00 00 	movabs $0xffff800000107da1,%rax
ffff800000107ec0:	80 ff ff 
ffff800000107ec3:	ff d0                	callq  *%rax
ffff800000107ec5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000107ec9:	48 89 02             	mov    %rax,(%rdx)
  return 0;
ffff800000107ecc:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107ed1:	c9                   	leaveq 
ffff800000107ed2:	c3                   	retq   

ffff800000107ed3 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
ffff800000107ed3:	f3 0f 1e fa          	endbr64 
ffff800000107ed7:	55                   	push   %rbp
ffff800000107ed8:	48 89 e5             	mov    %rsp,%rbp
ffff800000107edb:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107edf:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000107ee2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000107ee6:	89 55 e8             	mov    %edx,-0x18(%rbp)
  addr_t i;

  if(argaddr(n, &i) < 0)
ffff800000107ee9:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
ffff800000107eed:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000107ef0:	48 89 d6             	mov    %rdx,%rsi
ffff800000107ef3:	89 c7                	mov    %eax,%edi
ffff800000107ef5:	48 b8 a1 7e 10 00 00 	movabs $0xffff800000107ea1,%rax
ffff800000107efc:	80 ff ff 
ffff800000107eff:	ff d0                	callq  *%rax
ffff800000107f01:	85 c0                	test   %eax,%eax
ffff800000107f03:	79 07                	jns    ffff800000107f0c <argptr+0x39>
    return -1;
ffff800000107f05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107f0a:	eb 59                	jmp    ffff800000107f65 <argptr+0x92>
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
ffff800000107f0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
ffff800000107f10:	78 39                	js     ffff800000107f4b <argptr+0x78>
ffff800000107f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f16:	89 c2                	mov    %eax,%edx
ffff800000107f18:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107f1f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107f23:	48 8b 00             	mov    (%rax),%rax
ffff800000107f26:	48 39 c2             	cmp    %rax,%rdx
ffff800000107f29:	73 20                	jae    ffff800000107f4b <argptr+0x78>
ffff800000107f2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f2f:	89 c2                	mov    %eax,%edx
ffff800000107f31:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000107f34:	01 d0                	add    %edx,%eax
ffff800000107f36:	89 c2                	mov    %eax,%edx
ffff800000107f38:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107f3f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107f43:	48 8b 00             	mov    (%rax),%rax
ffff800000107f46:	48 39 c2             	cmp    %rax,%rdx
ffff800000107f49:	76 07                	jbe    ffff800000107f52 <argptr+0x7f>
    return -1;
ffff800000107f4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107f50:	eb 13                	jmp    ffff800000107f65 <argptr+0x92>
  *pp = (char*)i;
ffff800000107f52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107f56:	48 89 c2             	mov    %rax,%rdx
ffff800000107f59:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107f5d:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff800000107f60:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107f65:	c9                   	leaveq 
ffff800000107f66:	c3                   	retq   

ffff800000107f67 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
ffff800000107f67:	f3 0f 1e fa          	endbr64 
ffff800000107f6b:	55                   	push   %rbp
ffff800000107f6c:	48 89 e5             	mov    %rsp,%rbp
ffff800000107f6f:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107f73:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000107f76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int addr;
  if(argint(n, &addr) < 0)
ffff800000107f7a:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
ffff800000107f7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000107f81:	48 89 d6             	mov    %rdx,%rsi
ffff800000107f84:	89 c7                	mov    %eax,%edi
ffff800000107f86:	48 b8 6e 7e 10 00 00 	movabs $0xffff800000107e6e,%rax
ffff800000107f8d:	80 ff ff 
ffff800000107f90:	ff d0                	callq  *%rax
ffff800000107f92:	85 c0                	test   %eax,%eax
ffff800000107f94:	79 07                	jns    ffff800000107f9d <argstr+0x36>
    return -1;
ffff800000107f96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107f9b:	eb 1b                	jmp    ffff800000107fb8 <argstr+0x51>
  return fetchstr(addr, pp);
ffff800000107f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107fa0:	48 98                	cltq   
ffff800000107fa2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000107fa6:	48 89 d6             	mov    %rdx,%rsi
ffff800000107fa9:	48 89 c7             	mov    %rax,%rdi
ffff800000107fac:	48 b8 14 7d 10 00 00 	movabs $0xffff800000107d14,%rax
ffff800000107fb3:	80 ff ff 
ffff800000107fb6:	ff d0                	callq  *%rax
}
ffff800000107fb8:	c9                   	leaveq 
ffff800000107fb9:	c3                   	retq   

ffff800000107fba <syscall>:
[SYS_close]   sys_close,
};

void
syscall(struct trapframe *tf)
{
ffff800000107fba:	f3 0f 1e fa          	endbr64 
ffff800000107fbe:	55                   	push   %rbp
ffff800000107fbf:	48 89 e5             	mov    %rsp,%rbp
ffff800000107fc2:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107fc6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  if (proc->killed)
ffff800000107fca:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107fd1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107fd5:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000107fd8:	85 c0                	test   %eax,%eax
ffff800000107fda:	74 0c                	je     ffff800000107fe8 <syscall+0x2e>
    exit();
ffff800000107fdc:	48 b8 a1 68 10 00 00 	movabs $0xffff8000001068a1,%rax
ffff800000107fe3:	80 ff ff 
ffff800000107fe6:	ff d0                	callq  *%rax
  proc->tf = tf;
ffff800000107fe8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107fef:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107ff3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107ff7:	48 89 50 28          	mov    %rdx,0x28(%rax)
  uint64 num = proc->tf->rax;
ffff800000107ffb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108002:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108006:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010800a:	48 8b 00             	mov    (%rax),%rax
ffff80000010800d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
ffff800000108011:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108016:	74 3b                	je     ffff800000108053 <syscall+0x99>
ffff800000108018:	48 83 7d f8 15       	cmpq   $0x15,-0x8(%rbp)
ffff80000010801d:	77 34                	ja     ffff800000108053 <syscall+0x99>
ffff80000010801f:	48 ba a0 d5 10 00 00 	movabs $0xffff80000010d5a0,%rdx
ffff800000108026:	80 ff ff 
ffff800000108029:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010802d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffff800000108031:	48 85 c0             	test   %rax,%rax
ffff800000108034:	74 1d                	je     ffff800000108053 <syscall+0x99>
    tf->rax = syscalls[num]();
ffff800000108036:	48 ba a0 d5 10 00 00 	movabs $0xffff80000010d5a0,%rdx
ffff80000010803d:	80 ff ff 
ffff800000108040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108044:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffff800000108048:	ff d0                	callq  *%rax
ffff80000010804a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010804e:	48 89 02             	mov    %rax,(%rdx)
ffff800000108051:	eb 53                	jmp    ffff8000001080a6 <syscall+0xec>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
ffff800000108053:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010805a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010805e:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
ffff800000108065:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010806c:	64 48 8b 00          	mov    %fs:(%rax),%rax
    cprintf("%d %s: unknown sys call %d\n",
ffff800000108070:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000108073:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000108077:	48 89 d1             	mov    %rdx,%rcx
ffff80000010807a:	48 89 f2             	mov    %rsi,%rdx
ffff80000010807d:	89 c6                	mov    %eax,%esi
ffff80000010807f:	48 bf 40 c2 10 00 00 	movabs $0xffff80000010c240,%rdi
ffff800000108086:	80 ff ff 
ffff800000108089:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010808e:	49 b8 18 08 10 00 00 	movabs $0xffff800000100818,%r8
ffff800000108095:	80 ff ff 
ffff800000108098:	41 ff d0             	callq  *%r8
    tf->rax = -1;
ffff80000010809b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010809f:	48 c7 00 ff ff ff ff 	movq   $0xffffffffffffffff,(%rax)
  }
  if (proc->killed)
ffff8000001080a6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001080ad:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001080b1:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001080b4:	85 c0                	test   %eax,%eax
ffff8000001080b6:	74 0c                	je     ffff8000001080c4 <syscall+0x10a>
    exit();
ffff8000001080b8:	48 b8 a1 68 10 00 00 	movabs $0xffff8000001068a1,%rax
ffff8000001080bf:	80 ff ff 
ffff8000001080c2:	ff d0                	callq  *%rax
}
ffff8000001080c4:	90                   	nop
ffff8000001080c5:	c9                   	leaveq 
ffff8000001080c6:	c3                   	retq   

ffff8000001080c7 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
ffff8000001080c7:	f3 0f 1e fa          	endbr64 
ffff8000001080cb:	55                   	push   %rbp
ffff8000001080cc:	48 89 e5             	mov    %rsp,%rbp
ffff8000001080cf:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001080d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001080d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001080da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
ffff8000001080de:	48 8d 55 f4          	lea    -0xc(%rbp),%rdx
ffff8000001080e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001080e5:	48 89 d6             	mov    %rdx,%rsi
ffff8000001080e8:	89 c7                	mov    %eax,%edi
ffff8000001080ea:	48 b8 6e 7e 10 00 00 	movabs $0xffff800000107e6e,%rax
ffff8000001080f1:	80 ff ff 
ffff8000001080f4:	ff d0                	callq  *%rax
ffff8000001080f6:	85 c0                	test   %eax,%eax
ffff8000001080f8:	79 07                	jns    ffff800000108101 <argfd+0x3a>
    return -1;
ffff8000001080fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001080ff:	eb 62                	jmp    ffff800000108163 <argfd+0x9c>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
ffff800000108101:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108104:	85 c0                	test   %eax,%eax
ffff800000108106:	78 2d                	js     ffff800000108135 <argfd+0x6e>
ffff800000108108:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010810b:	83 f8 0f             	cmp    $0xf,%eax
ffff80000010810e:	7f 25                	jg     ffff800000108135 <argfd+0x6e>
ffff800000108110:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108117:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010811b:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010811e:	48 63 d2             	movslq %edx,%rdx
ffff800000108121:	48 83 c2 08          	add    $0x8,%rdx
ffff800000108125:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010812a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010812e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108133:	75 07                	jne    ffff80000010813c <argfd+0x75>
    return -1;
ffff800000108135:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010813a:	eb 27                	jmp    ffff800000108163 <argfd+0x9c>
  if(pfd)
ffff80000010813c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff800000108141:	74 09                	je     ffff80000010814c <argfd+0x85>
    *pfd = fd;
ffff800000108143:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108146:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010814a:	89 10                	mov    %edx,(%rax)
  if(pf)
ffff80000010814c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff800000108151:	74 0b                	je     ffff80000010815e <argfd+0x97>
    *pf = f;
ffff800000108153:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108157:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010815b:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff80000010815e:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108163:	c9                   	leaveq 
ffff800000108164:	c3                   	retq   

ffff800000108165 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
ffff800000108165:	f3 0f 1e fa          	endbr64 
ffff800000108169:	55                   	push   %rbp
ffff80000010816a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010816d:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000108171:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
ffff800000108175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010817c:	eb 46                	jmp    ffff8000001081c4 <fdalloc+0x5f>
    if(proc->ofile[fd] == 0){
ffff80000010817e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108185:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108189:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010818c:	48 63 d2             	movslq %edx,%rdx
ffff80000010818f:	48 83 c2 08          	add    $0x8,%rdx
ffff800000108193:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000108198:	48 85 c0             	test   %rax,%rax
ffff80000010819b:	75 23                	jne    ffff8000001081c0 <fdalloc+0x5b>
      proc->ofile[fd] = f;
ffff80000010819d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001081a4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001081a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001081ab:	48 63 d2             	movslq %edx,%rdx
ffff8000001081ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
ffff8000001081b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001081b6:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
      return fd;
ffff8000001081bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001081be:	eb 0f                	jmp    ffff8000001081cf <fdalloc+0x6a>
  for(fd = 0; fd < NOFILE; fd++){
ffff8000001081c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001081c4:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
ffff8000001081c8:	7e b4                	jle    ffff80000010817e <fdalloc+0x19>
    }
  }
  return -1;
ffff8000001081ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff8000001081cf:	c9                   	leaveq 
ffff8000001081d0:	c3                   	retq   

ffff8000001081d1 <sys_dup>:

int
sys_dup(void)
{
ffff8000001081d1:	f3 0f 1e fa          	endbr64 
ffff8000001081d5:	55                   	push   %rbp
ffff8000001081d6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001081d9:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
ffff8000001081dd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff8000001081e1:	48 89 c2             	mov    %rax,%rdx
ffff8000001081e4:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001081e9:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001081ee:	48 b8 c7 80 10 00 00 	movabs $0xffff8000001080c7,%rax
ffff8000001081f5:	80 ff ff 
ffff8000001081f8:	ff d0                	callq  *%rax
ffff8000001081fa:	85 c0                	test   %eax,%eax
ffff8000001081fc:	79 07                	jns    ffff800000108205 <sys_dup+0x34>
    return -1;
ffff8000001081fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108203:	eb 39                	jmp    ffff80000010823e <sys_dup+0x6d>
  if((fd=fdalloc(f)) < 0)
ffff800000108205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108209:	48 89 c7             	mov    %rax,%rdi
ffff80000010820c:	48 b8 65 81 10 00 00 	movabs $0xffff800000108165,%rax
ffff800000108213:	80 ff ff 
ffff800000108216:	ff d0                	callq  *%rax
ffff800000108218:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff80000010821b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff80000010821f:	79 07                	jns    ffff800000108228 <sys_dup+0x57>
    return -1;
ffff800000108221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108226:	eb 16                	jmp    ffff80000010823e <sys_dup+0x6d>
  filedup(f);
ffff800000108228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010822c:	48 89 c7             	mov    %rax,%rdi
ffff80000010822f:	48 b8 1a 1c 10 00 00 	movabs $0xffff800000101c1a,%rax
ffff800000108236:	80 ff ff 
ffff800000108239:	ff d0                	callq  *%rax
  return fd;
ffff80000010823b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff80000010823e:	c9                   	leaveq 
ffff80000010823f:	c3                   	retq   

ffff800000108240 <sys_read>:

int
sys_read(void)
{
ffff800000108240:	f3 0f 1e fa          	endbr64 
ffff800000108244:	55                   	push   %rbp
ffff800000108245:	48 89 e5             	mov    %rsp,%rbp
ffff800000108248:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffff80000010824c:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000108250:	48 89 c2             	mov    %rax,%rdx
ffff800000108253:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108258:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010825d:	48 b8 c7 80 10 00 00 	movabs $0xffff8000001080c7,%rax
ffff800000108264:	80 ff ff 
ffff800000108267:	ff d0                	callq  *%rax
ffff800000108269:	85 c0                	test   %eax,%eax
ffff80000010826b:	78 3b                	js     ffff8000001082a8 <sys_read+0x68>
ffff80000010826d:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff800000108271:	48 89 c6             	mov    %rax,%rsi
ffff800000108274:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000108279:	48 b8 6e 7e 10 00 00 	movabs $0xffff800000107e6e,%rax
ffff800000108280:	80 ff ff 
ffff800000108283:	ff d0                	callq  *%rax
ffff800000108285:	85 c0                	test   %eax,%eax
ffff800000108287:	78 1f                	js     ffff8000001082a8 <sys_read+0x68>
ffff800000108289:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010828c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000108290:	48 89 c6             	mov    %rax,%rsi
ffff800000108293:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108298:	48 b8 d3 7e 10 00 00 	movabs $0xffff800000107ed3,%rax
ffff80000010829f:	80 ff ff 
ffff8000001082a2:	ff d0                	callq  *%rax
ffff8000001082a4:	85 c0                	test   %eax,%eax
ffff8000001082a6:	79 07                	jns    ffff8000001082af <sys_read+0x6f>
    return -1;
ffff8000001082a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001082ad:	eb 1d                	jmp    ffff8000001082cc <sys_read+0x8c>
  return fileread(f, p, n);
ffff8000001082af:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001082b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff8000001082b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001082ba:	48 89 ce             	mov    %rcx,%rsi
ffff8000001082bd:	48 89 c7             	mov    %rax,%rdi
ffff8000001082c0:	48 b8 46 1e 10 00 00 	movabs $0xffff800000101e46,%rax
ffff8000001082c7:	80 ff ff 
ffff8000001082ca:	ff d0                	callq  *%rax
}
ffff8000001082cc:	c9                   	leaveq 
ffff8000001082cd:	c3                   	retq   

ffff8000001082ce <sys_write>:

int
sys_write(void)
{
ffff8000001082ce:	f3 0f 1e fa          	endbr64 
ffff8000001082d2:	55                   	push   %rbp
ffff8000001082d3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001082d6:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffff8000001082da:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff8000001082de:	48 89 c2             	mov    %rax,%rdx
ffff8000001082e1:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001082e6:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001082eb:	48 b8 c7 80 10 00 00 	movabs $0xffff8000001080c7,%rax
ffff8000001082f2:	80 ff ff 
ffff8000001082f5:	ff d0                	callq  *%rax
ffff8000001082f7:	85 c0                	test   %eax,%eax
ffff8000001082f9:	78 3b                	js     ffff800000108336 <sys_write+0x68>
ffff8000001082fb:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff8000001082ff:	48 89 c6             	mov    %rax,%rsi
ffff800000108302:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000108307:	48 b8 6e 7e 10 00 00 	movabs $0xffff800000107e6e,%rax
ffff80000010830e:	80 ff ff 
ffff800000108311:	ff d0                	callq  *%rax
ffff800000108313:	85 c0                	test   %eax,%eax
ffff800000108315:	78 1f                	js     ffff800000108336 <sys_write+0x68>
ffff800000108317:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010831a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff80000010831e:	48 89 c6             	mov    %rax,%rsi
ffff800000108321:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108326:	48 b8 d3 7e 10 00 00 	movabs $0xffff800000107ed3,%rax
ffff80000010832d:	80 ff ff 
ffff800000108330:	ff d0                	callq  *%rax
ffff800000108332:	85 c0                	test   %eax,%eax
ffff800000108334:	79 07                	jns    ffff80000010833d <sys_write+0x6f>
    return -1;
ffff800000108336:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010833b:	eb 1d                	jmp    ffff80000010835a <sys_write+0x8c>
  return filewrite(f, p, n);
ffff80000010833d:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108340:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000108344:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108348:	48 89 ce             	mov    %rcx,%rsi
ffff80000010834b:	48 89 c7             	mov    %rax,%rdi
ffff80000010834e:	48 b8 3b 1f 10 00 00 	movabs $0xffff800000101f3b,%rax
ffff800000108355:	80 ff ff 
ffff800000108358:	ff d0                	callq  *%rax
}
ffff80000010835a:	c9                   	leaveq 
ffff80000010835b:	c3                   	retq   

ffff80000010835c <sys_close>:

int
sys_close(void)
{
ffff80000010835c:	f3 0f 1e fa          	endbr64 
ffff800000108360:	55                   	push   %rbp
ffff800000108361:	48 89 e5             	mov    %rsp,%rbp
ffff800000108364:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
ffff800000108368:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
ffff80000010836c:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff800000108370:	48 89 c6             	mov    %rax,%rsi
ffff800000108373:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108378:	48 b8 c7 80 10 00 00 	movabs $0xffff8000001080c7,%rax
ffff80000010837f:	80 ff ff 
ffff800000108382:	ff d0                	callq  *%rax
ffff800000108384:	85 c0                	test   %eax,%eax
ffff800000108386:	79 07                	jns    ffff80000010838f <sys_close+0x33>
    return -1;
ffff800000108388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010838d:	eb 36                	jmp    ffff8000001083c5 <sys_close+0x69>
  proc->ofile[fd] = 0;
ffff80000010838f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108396:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010839a:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010839d:	48 63 d2             	movslq %edx,%rdx
ffff8000001083a0:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001083a4:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff8000001083ab:	00 00 
  fileclose(f);
ffff8000001083ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001083b1:	48 89 c7             	mov    %rax,%rdi
ffff8000001083b4:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff8000001083bb:	80 ff ff 
ffff8000001083be:	ff d0                	callq  *%rax
  return 0;
ffff8000001083c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001083c5:	c9                   	leaveq 
ffff8000001083c6:	c3                   	retq   

ffff8000001083c7 <sys_fstat>:

int
sys_fstat(void)
{
ffff8000001083c7:	f3 0f 1e fa          	endbr64 
ffff8000001083cb:	55                   	push   %rbp
ffff8000001083cc:	48 89 e5             	mov    %rsp,%rbp
ffff8000001083cf:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
ffff8000001083d3:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff8000001083d7:	48 89 c2             	mov    %rax,%rdx
ffff8000001083da:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001083df:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001083e4:	48 b8 c7 80 10 00 00 	movabs $0xffff8000001080c7,%rax
ffff8000001083eb:	80 ff ff 
ffff8000001083ee:	ff d0                	callq  *%rax
ffff8000001083f0:	85 c0                	test   %eax,%eax
ffff8000001083f2:	78 21                	js     ffff800000108415 <sys_fstat+0x4e>
ffff8000001083f4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff8000001083f8:	ba 14 00 00 00       	mov    $0x14,%edx
ffff8000001083fd:	48 89 c6             	mov    %rax,%rsi
ffff800000108400:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108405:	48 b8 d3 7e 10 00 00 	movabs $0xffff800000107ed3,%rax
ffff80000010840c:	80 ff ff 
ffff80000010840f:	ff d0                	callq  *%rax
ffff800000108411:	85 c0                	test   %eax,%eax
ffff800000108413:	79 07                	jns    ffff80000010841c <sys_fstat+0x55>
    return -1;
ffff800000108415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010841a:	eb 1a                	jmp    ffff800000108436 <sys_fstat+0x6f>
  return filestat(f, st);
ffff80000010841c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000108420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108424:	48 89 d6             	mov    %rdx,%rsi
ffff800000108427:	48 89 c7             	mov    %rax,%rdi
ffff80000010842a:	48 b8 cd 1d 10 00 00 	movabs $0xffff800000101dcd,%rax
ffff800000108431:	80 ff ff 
ffff800000108434:	ff d0                	callq  *%rax
}
ffff800000108436:	c9                   	leaveq 
ffff800000108437:	c3                   	retq   

ffff800000108438 <isdirempty>:

static int
isdirempty(struct inode *dp)
{
ffff800000108438:	f3 0f 1e fa          	endbr64 
ffff80000010843c:	55                   	push   %rbp
ffff80000010843d:	48 89 e5             	mov    %rsp,%rbp
ffff800000108440:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000108444:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int off;
  struct dirent de;
  // Is the directory dp empty except for "." and ".." ?
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffff800000108448:	c7 45 fc 20 00 00 00 	movl   $0x20,-0x4(%rbp)
ffff80000010844f:	eb 53                	jmp    ffff8000001084a4 <isdirempty+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000108451:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108454:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000108458:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010845c:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000108461:	48 89 c7             	mov    %rax,%rdi
ffff800000108464:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff80000010846b:	80 ff ff 
ffff80000010846e:	ff d0                	callq  *%rax
ffff800000108470:	83 f8 10             	cmp    $0x10,%eax
ffff800000108473:	74 16                	je     ffff80000010848b <isdirempty+0x53>
      panic("isdirempty: readi");
ffff800000108475:	48 bf 5c c2 10 00 00 	movabs $0xffff80000010c25c,%rdi
ffff80000010847c:	80 ff ff 
ffff80000010847f:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108486:	80 ff ff 
ffff800000108489:	ff d0                	callq  *%rax
    if(de.inum != 0)
ffff80000010848b:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff80000010848f:	66 85 c0             	test   %ax,%ax
ffff800000108492:	74 07                	je     ffff80000010849b <isdirempty+0x63>
      return 0;
ffff800000108494:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108499:	eb 1f                	jmp    ffff8000001084ba <isdirempty+0x82>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffff80000010849b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010849e:	83 c0 10             	add    $0x10,%eax
ffff8000001084a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001084a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001084a8:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff8000001084ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001084b1:	39 c2                	cmp    %eax,%edx
ffff8000001084b3:	77 9c                	ja     ffff800000108451 <isdirempty+0x19>
  }
  return 1;
ffff8000001084b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
ffff8000001084ba:	c9                   	leaveq 
ffff8000001084bb:	c3                   	retq   

ffff8000001084bc <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
ffff8000001084bc:	f3 0f 1e fa          	endbr64 
ffff8000001084c0:	55                   	push   %rbp
ffff8000001084c1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001084c4:	48 83 ec 30          	sub    $0x30,%rsp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
ffff8000001084c8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffff8000001084cc:	48 89 c6             	mov    %rax,%rsi
ffff8000001084cf:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001084d4:	48 b8 67 7f 10 00 00 	movabs $0xffff800000107f67,%rax
ffff8000001084db:	80 ff ff 
ffff8000001084de:	ff d0                	callq  *%rax
ffff8000001084e0:	85 c0                	test   %eax,%eax
ffff8000001084e2:	78 1c                	js     ffff800000108500 <sys_link+0x44>
ffff8000001084e4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
ffff8000001084e8:	48 89 c6             	mov    %rax,%rsi
ffff8000001084eb:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001084f0:	48 b8 67 7f 10 00 00 	movabs $0xffff800000107f67,%rax
ffff8000001084f7:	80 ff ff 
ffff8000001084fa:	ff d0                	callq  *%rax
ffff8000001084fc:	85 c0                	test   %eax,%eax
ffff8000001084fe:	79 0a                	jns    ffff80000010850a <sys_link+0x4e>
    return -1;
ffff800000108500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108505:	e9 0c 02 00 00       	jmpq   ffff800000108716 <sys_link+0x25a>

  begin_op();
ffff80000010850a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010850f:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000108516:	80 ff ff 
ffff800000108519:	ff d2                	callq  *%rdx
  if((ip = namei(old)) == 0){
ffff80000010851b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010851f:	48 89 c7             	mov    %rax,%rdi
ffff800000108522:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff800000108529:	80 ff ff 
ffff80000010852c:	ff d0                	callq  *%rax
ffff80000010852e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108532:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108537:	75 1b                	jne    ffff800000108554 <sys_link+0x98>
    end_op();
ffff800000108539:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010853e:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108545:	80 ff ff 
ffff800000108548:	ff d2                	callq  *%rdx
    return -1;
ffff80000010854a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010854f:	e9 c2 01 00 00       	jmpq   ffff800000108716 <sys_link+0x25a>
  }

  ilock(ip);
ffff800000108554:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108558:	48 89 c7             	mov    %rax,%rdi
ffff80000010855b:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108562:	80 ff ff 
ffff800000108565:	ff d0                	callq  *%rax
  if(ip->type == T_DIR){
ffff800000108567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010856b:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108572:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108576:	75 2e                	jne    ffff8000001085a6 <sys_link+0xea>
    iunlockput(ip);
ffff800000108578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010857c:	48 89 c7             	mov    %rax,%rdi
ffff80000010857f:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108586:	80 ff ff 
ffff800000108589:	ff d0                	callq  *%rax
    end_op();
ffff80000010858b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108590:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108597:	80 ff ff 
ffff80000010859a:	ff d2                	callq  *%rdx
    return -1;
ffff80000010859c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001085a1:	e9 70 01 00 00       	jmpq   ffff800000108716 <sys_link+0x25a>
  }

  ip->nlink++;
ffff8000001085a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001085aa:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff8000001085b1:	83 c0 01             	add    $0x1,%eax
ffff8000001085b4:	89 c2                	mov    %eax,%edx
ffff8000001085b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001085ba:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff8000001085c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001085c5:	48 89 c7             	mov    %rax,%rdi
ffff8000001085c8:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff8000001085cf:	80 ff ff 
ffff8000001085d2:	ff d0                	callq  *%rax
  iunlock(ip);
ffff8000001085d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001085d8:	48 89 c7             	mov    %rax,%rdi
ffff8000001085db:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff8000001085e2:	80 ff ff 
ffff8000001085e5:	ff d0                	callq  *%rax

  if((dp = nameiparent(new, name)) == 0)
ffff8000001085e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001085eb:	48 8d 55 e2          	lea    -0x1e(%rbp),%rdx
ffff8000001085ef:	48 89 d6             	mov    %rdx,%rsi
ffff8000001085f2:	48 89 c7             	mov    %rax,%rdi
ffff8000001085f5:	48 b8 2d 38 10 00 00 	movabs $0xffff80000010382d,%rax
ffff8000001085fc:	80 ff ff 
ffff8000001085ff:	ff d0                	callq  *%rax
ffff800000108601:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108605:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010860a:	0f 84 9b 00 00 00    	je     ffff8000001086ab <sys_link+0x1ef>
    goto bad;
  ilock(dp);
ffff800000108610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108614:	48 89 c7             	mov    %rax,%rdi
ffff800000108617:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff80000010861e:	80 ff ff 
ffff800000108621:	ff d0                	callq  *%rax
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
ffff800000108623:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108627:	8b 10                	mov    (%rax),%edx
ffff800000108629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010862d:	8b 00                	mov    (%rax),%eax
ffff80000010862f:	39 c2                	cmp    %eax,%edx
ffff800000108631:	75 25                	jne    ffff800000108658 <sys_link+0x19c>
ffff800000108633:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108637:	8b 50 04             	mov    0x4(%rax),%edx
ffff80000010863a:	48 8d 4d e2          	lea    -0x1e(%rbp),%rcx
ffff80000010863e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108642:	48 89 ce             	mov    %rcx,%rsi
ffff800000108645:	48 89 c7             	mov    %rax,%rdi
ffff800000108648:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff80000010864f:	80 ff ff 
ffff800000108652:	ff d0                	callq  *%rax
ffff800000108654:	85 c0                	test   %eax,%eax
ffff800000108656:	79 15                	jns    ffff80000010866d <sys_link+0x1b1>
    iunlockput(dp);
ffff800000108658:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010865c:	48 89 c7             	mov    %rax,%rdi
ffff80000010865f:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108666:	80 ff ff 
ffff800000108669:	ff d0                	callq  *%rax
    goto bad;
ffff80000010866b:	eb 3f                	jmp    ffff8000001086ac <sys_link+0x1f0>
  }
  iunlockput(dp);
ffff80000010866d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108671:	48 89 c7             	mov    %rax,%rdi
ffff800000108674:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff80000010867b:	80 ff ff 
ffff80000010867e:	ff d0                	callq  *%rax
  iput(ip);
ffff800000108680:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108684:	48 89 c7             	mov    %rax,%rdi
ffff800000108687:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff80000010868e:	80 ff ff 
ffff800000108691:	ff d0                	callq  *%rax

  end_op();
ffff800000108693:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108698:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff80000010869f:	80 ff ff 
ffff8000001086a2:	ff d2                	callq  *%rdx

  return 0;
ffff8000001086a4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001086a9:	eb 6b                	jmp    ffff800000108716 <sys_link+0x25a>
    goto bad;
ffff8000001086ab:	90                   	nop

bad:
  ilock(ip);
ffff8000001086ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001086b0:	48 89 c7             	mov    %rax,%rdi
ffff8000001086b3:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001086ba:	80 ff ff 
ffff8000001086bd:	ff d0                	callq  *%rax
  ip->nlink--;
ffff8000001086bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001086c3:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff8000001086ca:	83 e8 01             	sub    $0x1,%eax
ffff8000001086cd:	89 c2                	mov    %eax,%edx
ffff8000001086cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001086d3:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff8000001086da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001086de:	48 89 c7             	mov    %rax,%rdi
ffff8000001086e1:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff8000001086e8:	80 ff ff 
ffff8000001086eb:	ff d0                	callq  *%rax
  iunlockput(ip);
ffff8000001086ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001086f1:	48 89 c7             	mov    %rax,%rdi
ffff8000001086f4:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001086fb:	80 ff ff 
ffff8000001086fe:	ff d0                	callq  *%rax
  end_op();
ffff800000108700:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108705:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff80000010870c:	80 ff ff 
ffff80000010870f:	ff d2                	callq  *%rdx
  return -1;
ffff800000108711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108716:	c9                   	leaveq 
ffff800000108717:	c3                   	retq   

ffff800000108718 <sys_unlink>:
//PAGEBREAK!

int
sys_unlink(void)
{
ffff800000108718:	f3 0f 1e fa          	endbr64 
ffff80000010871c:	55                   	push   %rbp
ffff80000010871d:	48 89 e5             	mov    %rsp,%rbp
ffff800000108720:	48 83 ec 40          	sub    $0x40,%rsp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
ffff800000108724:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
ffff800000108728:	48 89 c6             	mov    %rax,%rsi
ffff80000010872b:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108730:	48 b8 67 7f 10 00 00 	movabs $0xffff800000107f67,%rax
ffff800000108737:	80 ff ff 
ffff80000010873a:	ff d0                	callq  *%rax
ffff80000010873c:	85 c0                	test   %eax,%eax
ffff80000010873e:	79 0a                	jns    ffff80000010874a <sys_unlink+0x32>
    return -1;
ffff800000108740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108745:	e9 83 02 00 00       	jmpq   ffff8000001089cd <sys_unlink+0x2b5>

  begin_op();
ffff80000010874a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010874f:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000108756:	80 ff ff 
ffff800000108759:	ff d2                	callq  *%rdx
  if((dp = nameiparent(path, name)) == 0){
ffff80000010875b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010875f:	48 8d 55 d2          	lea    -0x2e(%rbp),%rdx
ffff800000108763:	48 89 d6             	mov    %rdx,%rsi
ffff800000108766:	48 89 c7             	mov    %rax,%rdi
ffff800000108769:	48 b8 2d 38 10 00 00 	movabs $0xffff80000010382d,%rax
ffff800000108770:	80 ff ff 
ffff800000108773:	ff d0                	callq  *%rax
ffff800000108775:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108779:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010877e:	75 1b                	jne    ffff80000010879b <sys_unlink+0x83>
    end_op();
ffff800000108780:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108785:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff80000010878c:	80 ff ff 
ffff80000010878f:	ff d2                	callq  *%rdx
    return -1;
ffff800000108791:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108796:	e9 32 02 00 00       	jmpq   ffff8000001089cd <sys_unlink+0x2b5>
  }

  ilock(dp);
ffff80000010879b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010879f:	48 89 c7             	mov    %rax,%rdi
ffff8000001087a2:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff8000001087a9:	80 ff ff 
ffff8000001087ac:	ff d0                	callq  *%rax

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
ffff8000001087ae:	48 8d 45 d2          	lea    -0x2e(%rbp),%rax
ffff8000001087b2:	48 be 6e c2 10 00 00 	movabs $0xffff80000010c26e,%rsi
ffff8000001087b9:	80 ff ff 
ffff8000001087bc:	48 89 c7             	mov    %rax,%rdi
ffff8000001087bf:	48 b8 36 33 10 00 00 	movabs $0xffff800000103336,%rax
ffff8000001087c6:	80 ff ff 
ffff8000001087c9:	ff d0                	callq  *%rax
ffff8000001087cb:	85 c0                	test   %eax,%eax
ffff8000001087cd:	0f 84 cd 01 00 00    	je     ffff8000001089a0 <sys_unlink+0x288>
ffff8000001087d3:	48 8d 45 d2          	lea    -0x2e(%rbp),%rax
ffff8000001087d7:	48 be 70 c2 10 00 00 	movabs $0xffff80000010c270,%rsi
ffff8000001087de:	80 ff ff 
ffff8000001087e1:	48 89 c7             	mov    %rax,%rdi
ffff8000001087e4:	48 b8 36 33 10 00 00 	movabs $0xffff800000103336,%rax
ffff8000001087eb:	80 ff ff 
ffff8000001087ee:	ff d0                	callq  *%rax
ffff8000001087f0:	85 c0                	test   %eax,%eax
ffff8000001087f2:	0f 84 a8 01 00 00    	je     ffff8000001089a0 <sys_unlink+0x288>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
ffff8000001087f8:	48 8d 55 c4          	lea    -0x3c(%rbp),%rdx
ffff8000001087fc:	48 8d 4d d2          	lea    -0x2e(%rbp),%rcx
ffff800000108800:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108804:	48 89 ce             	mov    %rcx,%rsi
ffff800000108807:	48 89 c7             	mov    %rax,%rdi
ffff80000010880a:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff800000108811:	80 ff ff 
ffff800000108814:	ff d0                	callq  *%rax
ffff800000108816:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010881a:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010881f:	0f 84 7e 01 00 00    	je     ffff8000001089a3 <sys_unlink+0x28b>
    goto bad;
  ilock(ip);
ffff800000108825:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108829:	48 89 c7             	mov    %rax,%rdi
ffff80000010882c:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108833:	80 ff ff 
ffff800000108836:	ff d0                	callq  *%rax

  if(ip->nlink < 1)
ffff800000108838:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010883c:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108843:	66 85 c0             	test   %ax,%ax
ffff800000108846:	7f 16                	jg     ffff80000010885e <sys_unlink+0x146>
    panic("unlink: nlink < 1");
ffff800000108848:	48 bf 73 c2 10 00 00 	movabs $0xffff80000010c273,%rdi
ffff80000010884f:	80 ff ff 
ffff800000108852:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108859:	80 ff ff 
ffff80000010885c:	ff d0                	callq  *%rax
  if(ip->type == T_DIR && !isdirempty(ip)){
ffff80000010885e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108862:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108869:	66 83 f8 01          	cmp    $0x1,%ax
ffff80000010886d:	75 2f                	jne    ffff80000010889e <sys_unlink+0x186>
ffff80000010886f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108873:	48 89 c7             	mov    %rax,%rdi
ffff800000108876:	48 b8 38 84 10 00 00 	movabs $0xffff800000108438,%rax
ffff80000010887d:	80 ff ff 
ffff800000108880:	ff d0                	callq  *%rax
ffff800000108882:	85 c0                	test   %eax,%eax
ffff800000108884:	75 18                	jne    ffff80000010889e <sys_unlink+0x186>
    iunlockput(ip);
ffff800000108886:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010888a:	48 89 c7             	mov    %rax,%rdi
ffff80000010888d:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108894:	80 ff ff 
ffff800000108897:	ff d0                	callq  *%rax
    goto bad;
ffff800000108899:	e9 06 01 00 00       	jmpq   ffff8000001089a4 <sys_unlink+0x28c>
  }

  memset(&de, 0, sizeof(de));
ffff80000010889e:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff8000001088a2:	ba 10 00 00 00       	mov    $0x10,%edx
ffff8000001088a7:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001088ac:	48 89 c7             	mov    %rax,%rdi
ffff8000001088af:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff8000001088b6:	80 ff ff 
ffff8000001088b9:	ff d0                	callq  *%rax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff8000001088bb:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff8000001088be:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff8000001088c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001088c6:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff8000001088cb:	48 89 c7             	mov    %rax,%rdi
ffff8000001088ce:	48 b8 22 31 10 00 00 	movabs $0xffff800000103122,%rax
ffff8000001088d5:	80 ff ff 
ffff8000001088d8:	ff d0                	callq  *%rax
ffff8000001088da:	83 f8 10             	cmp    $0x10,%eax
ffff8000001088dd:	74 16                	je     ffff8000001088f5 <sys_unlink+0x1dd>
    panic("unlink: writei");
ffff8000001088df:	48 bf 85 c2 10 00 00 	movabs $0xffff80000010c285,%rdi
ffff8000001088e6:	80 ff ff 
ffff8000001088e9:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff8000001088f0:	80 ff ff 
ffff8000001088f3:	ff d0                	callq  *%rax
  if(ip->type == T_DIR){
ffff8000001088f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001088f9:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108900:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108904:	75 2e                	jne    ffff800000108934 <sys_unlink+0x21c>
    dp->nlink--;
ffff800000108906:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010890a:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108911:	83 e8 01             	sub    $0x1,%eax
ffff800000108914:	89 c2                	mov    %eax,%edx
ffff800000108916:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010891a:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    iupdate(dp);
ffff800000108921:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108925:	48 89 c7             	mov    %rax,%rdi
ffff800000108928:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff80000010892f:	80 ff ff 
ffff800000108932:	ff d0                	callq  *%rax
  }
  iunlockput(dp);
ffff800000108934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108938:	48 89 c7             	mov    %rax,%rdi
ffff80000010893b:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108942:	80 ff ff 
ffff800000108945:	ff d0                	callq  *%rax

  ip->nlink--;
ffff800000108947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010894b:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108952:	83 e8 01             	sub    $0x1,%eax
ffff800000108955:	89 c2                	mov    %eax,%edx
ffff800000108957:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010895b:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff800000108962:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108966:	48 89 c7             	mov    %rax,%rdi
ffff800000108969:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000108970:	80 ff ff 
ffff800000108973:	ff d0                	callq  *%rax
  iunlockput(ip);
ffff800000108975:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108979:	48 89 c7             	mov    %rax,%rdi
ffff80000010897c:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108983:	80 ff ff 
ffff800000108986:	ff d0                	callq  *%rax

  end_op();
ffff800000108988:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010898d:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108994:	80 ff ff 
ffff800000108997:	ff d2                	callq  *%rdx

  return 0;
ffff800000108999:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010899e:	eb 2d                	jmp    ffff8000001089cd <sys_unlink+0x2b5>
    goto bad;
ffff8000001089a0:	90                   	nop
ffff8000001089a1:	eb 01                	jmp    ffff8000001089a4 <sys_unlink+0x28c>
    goto bad;
ffff8000001089a3:	90                   	nop

bad:
  iunlockput(dp);
ffff8000001089a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001089a8:	48 89 c7             	mov    %rax,%rdi
ffff8000001089ab:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001089b2:	80 ff ff 
ffff8000001089b5:	ff d0                	callq  *%rax
  end_op();
ffff8000001089b7:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001089bc:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001089c3:	80 ff ff 
ffff8000001089c6:	ff d2                	callq  *%rdx
  return -1;
ffff8000001089c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff8000001089cd:	c9                   	leaveq 
ffff8000001089ce:	c3                   	retq   

ffff8000001089cf <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
ffff8000001089cf:	f3 0f 1e fa          	endbr64 
ffff8000001089d3:	55                   	push   %rbp
ffff8000001089d4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001089d7:	48 83 ec 50          	sub    $0x50,%rsp
ffff8000001089db:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff8000001089df:	89 c8                	mov    %ecx,%eax
ffff8000001089e1:	89 f1                	mov    %esi,%ecx
ffff8000001089e3:	66 89 4d c4          	mov    %cx,-0x3c(%rbp)
ffff8000001089e7:	66 89 55 c0          	mov    %dx,-0x40(%rbp)
ffff8000001089eb:	66 89 45 bc          	mov    %ax,-0x44(%rbp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
ffff8000001089ef:	48 8d 55 de          	lea    -0x22(%rbp),%rdx
ffff8000001089f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001089f7:	48 89 d6             	mov    %rdx,%rsi
ffff8000001089fa:	48 89 c7             	mov    %rax,%rdi
ffff8000001089fd:	48 b8 2d 38 10 00 00 	movabs $0xffff80000010382d,%rax
ffff800000108a04:	80 ff ff 
ffff800000108a07:	ff d0                	callq  *%rax
ffff800000108a09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108a0d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108a12:	75 0a                	jne    ffff800000108a1e <create+0x4f>
    return 0;
ffff800000108a14:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108a19:	e9 1d 02 00 00       	jmpq   ffff800000108c3b <create+0x26c>
  ilock(dp);
ffff800000108a1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108a22:	48 89 c7             	mov    %rax,%rdi
ffff800000108a25:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108a2c:	80 ff ff 
ffff800000108a2f:	ff d0                	callq  *%rax

  if((ip = dirlookup(dp, name, &off)) != 0){
ffff800000108a31:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
ffff800000108a35:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
ffff800000108a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108a3d:	48 89 ce             	mov    %rcx,%rsi
ffff800000108a40:	48 89 c7             	mov    %rax,%rdi
ffff800000108a43:	48 b8 6b 33 10 00 00 	movabs $0xffff80000010336b,%rax
ffff800000108a4a:	80 ff ff 
ffff800000108a4d:	ff d0                	callq  *%rax
ffff800000108a4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108a53:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108a58:	74 64                	je     ffff800000108abe <create+0xef>
    iunlockput(dp);
ffff800000108a5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108a5e:	48 89 c7             	mov    %rax,%rdi
ffff800000108a61:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108a68:	80 ff ff 
ffff800000108a6b:	ff d0                	callq  *%rax
    ilock(ip);
ffff800000108a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108a71:	48 89 c7             	mov    %rax,%rdi
ffff800000108a74:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108a7b:	80 ff ff 
ffff800000108a7e:	ff d0                	callq  *%rax
    if(type == T_FILE && ip->type == T_FILE)
ffff800000108a80:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%rbp)
ffff800000108a85:	75 1a                	jne    ffff800000108aa1 <create+0xd2>
ffff800000108a87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108a8b:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108a92:	66 83 f8 02          	cmp    $0x2,%ax
ffff800000108a96:	75 09                	jne    ffff800000108aa1 <create+0xd2>
      return ip;
ffff800000108a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108a9c:	e9 9a 01 00 00       	jmpq   ffff800000108c3b <create+0x26c>
    iunlockput(ip);
ffff800000108aa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108aa5:	48 89 c7             	mov    %rax,%rdi
ffff800000108aa8:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108aaf:	80 ff ff 
ffff800000108ab2:	ff d0                	callq  *%rax
    return 0;
ffff800000108ab4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108ab9:	e9 7d 01 00 00       	jmpq   ffff800000108c3b <create+0x26c>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
ffff800000108abe:	0f bf 55 c4          	movswl -0x3c(%rbp),%edx
ffff800000108ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108ac6:	8b 00                	mov    (%rax),%eax
ffff800000108ac8:	89 d6                	mov    %edx,%esi
ffff800000108aca:	89 c7                	mov    %eax,%edi
ffff800000108acc:	48 b8 21 25 10 00 00 	movabs $0xffff800000102521,%rax
ffff800000108ad3:	80 ff ff 
ffff800000108ad6:	ff d0                	callq  *%rax
ffff800000108ad8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108adc:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108ae1:	75 16                	jne    ffff800000108af9 <create+0x12a>
    panic("create: ialloc");
ffff800000108ae3:	48 bf 94 c2 10 00 00 	movabs $0xffff80000010c294,%rdi
ffff800000108aea:	80 ff ff 
ffff800000108aed:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108af4:	80 ff ff 
ffff800000108af7:	ff d0                	callq  *%rax

  ilock(ip);
ffff800000108af9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108afd:	48 89 c7             	mov    %rax,%rdi
ffff800000108b00:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108b07:	80 ff ff 
ffff800000108b0a:	ff d0                	callq  *%rax
  ip->major = major;
ffff800000108b0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b10:	0f b7 55 c0          	movzwl -0x40(%rbp),%edx
ffff800000108b14:	66 89 90 96 00 00 00 	mov    %dx,0x96(%rax)
  ip->minor = minor;
ffff800000108b1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b1f:	0f b7 55 bc          	movzwl -0x44(%rbp),%edx
ffff800000108b23:	66 89 90 98 00 00 00 	mov    %dx,0x98(%rax)
  ip->nlink = 1;
ffff800000108b2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b2e:	66 c7 80 9a 00 00 00 	movw   $0x1,0x9a(%rax)
ffff800000108b35:	01 00 
  iupdate(ip);
ffff800000108b37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b3b:	48 89 c7             	mov    %rax,%rdi
ffff800000108b3e:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000108b45:	80 ff ff 
ffff800000108b48:	ff d0                	callq  *%rax

  if(type == T_DIR){  // Create . and .. entries.
ffff800000108b4a:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%rbp)
ffff800000108b4f:	0f 85 94 00 00 00    	jne    ffff800000108be9 <create+0x21a>
    dp->nlink++;  // for ".."
ffff800000108b55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108b59:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108b60:	83 c0 01             	add    $0x1,%eax
ffff800000108b63:	89 c2                	mov    %eax,%edx
ffff800000108b65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108b69:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    iupdate(dp);
ffff800000108b70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108b74:	48 89 c7             	mov    %rax,%rdi
ffff800000108b77:	48 b8 4a 26 10 00 00 	movabs $0xffff80000010264a,%rax
ffff800000108b7e:	80 ff ff 
ffff800000108b81:	ff d0                	callq  *%rax
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
ffff800000108b83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b87:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108b8e:	48 be 6e c2 10 00 00 	movabs $0xffff80000010c26e,%rsi
ffff800000108b95:	80 ff ff 
ffff800000108b98:	48 89 c7             	mov    %rax,%rdi
ffff800000108b9b:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff800000108ba2:	80 ff ff 
ffff800000108ba5:	ff d0                	callq  *%rax
ffff800000108ba7:	85 c0                	test   %eax,%eax
ffff800000108ba9:	78 28                	js     ffff800000108bd3 <create+0x204>
ffff800000108bab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108baf:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108bb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108bb6:	48 be 70 c2 10 00 00 	movabs $0xffff80000010c270,%rsi
ffff800000108bbd:	80 ff ff 
ffff800000108bc0:	48 89 c7             	mov    %rax,%rdi
ffff800000108bc3:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff800000108bca:	80 ff ff 
ffff800000108bcd:	ff d0                	callq  *%rax
ffff800000108bcf:	85 c0                	test   %eax,%eax
ffff800000108bd1:	79 16                	jns    ffff800000108be9 <create+0x21a>
      panic("create dots");
ffff800000108bd3:	48 bf a3 c2 10 00 00 	movabs $0xffff80000010c2a3,%rdi
ffff800000108bda:	80 ff ff 
ffff800000108bdd:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108be4:	80 ff ff 
ffff800000108be7:	ff d0                	callq  *%rax
  }

  if(dirlink(dp, name, ip->inum) < 0)
ffff800000108be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108bed:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108bf0:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
ffff800000108bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108bf8:	48 89 ce             	mov    %rcx,%rsi
ffff800000108bfb:	48 89 c7             	mov    %rax,%rdi
ffff800000108bfe:	48 b8 6f 34 10 00 00 	movabs $0xffff80000010346f,%rax
ffff800000108c05:	80 ff ff 
ffff800000108c08:	ff d0                	callq  *%rax
ffff800000108c0a:	85 c0                	test   %eax,%eax
ffff800000108c0c:	79 16                	jns    ffff800000108c24 <create+0x255>
    panic("create: dirlink");
ffff800000108c0e:	48 bf af c2 10 00 00 	movabs $0xffff80000010c2af,%rdi
ffff800000108c15:	80 ff ff 
ffff800000108c18:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000108c1f:	80 ff ff 
ffff800000108c22:	ff d0                	callq  *%rax

  iunlockput(dp);
ffff800000108c24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c28:	48 89 c7             	mov    %rax,%rdi
ffff800000108c2b:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108c32:	80 ff ff 
ffff800000108c35:	ff d0                	callq  *%rax

  return ip;
ffff800000108c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffff800000108c3b:	c9                   	leaveq 
ffff800000108c3c:	c3                   	retq   

ffff800000108c3d <sys_open>:

int
sys_open(void)
{
ffff800000108c3d:	f3 0f 1e fa          	endbr64 
ffff800000108c41:	55                   	push   %rbp
ffff800000108c42:	48 89 e5             	mov    %rsp,%rbp
ffff800000108c45:	48 83 ec 30          	sub    $0x30,%rsp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
ffff800000108c49:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000108c4d:	48 89 c6             	mov    %rax,%rsi
ffff800000108c50:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108c55:	48 b8 67 7f 10 00 00 	movabs $0xffff800000107f67,%rax
ffff800000108c5c:	80 ff ff 
ffff800000108c5f:	ff d0                	callq  *%rax
ffff800000108c61:	85 c0                	test   %eax,%eax
ffff800000108c63:	78 1c                	js     ffff800000108c81 <sys_open+0x44>
ffff800000108c65:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
ffff800000108c69:	48 89 c6             	mov    %rax,%rsi
ffff800000108c6c:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108c71:	48 b8 6e 7e 10 00 00 	movabs $0xffff800000107e6e,%rax
ffff800000108c78:	80 ff ff 
ffff800000108c7b:	ff d0                	callq  *%rax
ffff800000108c7d:	85 c0                	test   %eax,%eax
ffff800000108c7f:	79 0a                	jns    ffff800000108c8b <sys_open+0x4e>
    return -1;
ffff800000108c81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108c86:	e9 fb 01 00 00       	jmpq   ffff800000108e86 <sys_open+0x249>

  begin_op();
ffff800000108c8b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108c90:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000108c97:	80 ff ff 
ffff800000108c9a:	ff d2                	callq  *%rdx

  if(omode & O_CREATE){
ffff800000108c9c:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108c9f:	25 00 02 00 00       	and    $0x200,%eax
ffff800000108ca4:	85 c0                	test   %eax,%eax
ffff800000108ca6:	74 4c                	je     ffff800000108cf4 <sys_open+0xb7>
    ip = create(path, T_FILE, 0, 0);
ffff800000108ca8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108cac:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff800000108cb1:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000108cb6:	be 02 00 00 00       	mov    $0x2,%esi
ffff800000108cbb:	48 89 c7             	mov    %rax,%rdi
ffff800000108cbe:	48 b8 cf 89 10 00 00 	movabs $0xffff8000001089cf,%rax
ffff800000108cc5:	80 ff ff 
ffff800000108cc8:	ff d0                	callq  *%rax
ffff800000108cca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(ip == 0){
ffff800000108cce:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108cd3:	0f 85 ad 00 00 00    	jne    ffff800000108d86 <sys_open+0x149>
      end_op();
ffff800000108cd9:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108cde:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108ce5:	80 ff ff 
ffff800000108ce8:	ff d2                	callq  *%rdx
      return -1;
ffff800000108cea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108cef:	e9 92 01 00 00       	jmpq   ffff800000108e86 <sys_open+0x249>
    }
  } else {
    if((ip = namei(path)) == 0){
ffff800000108cf4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108cf8:	48 89 c7             	mov    %rax,%rdi
ffff800000108cfb:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff800000108d02:	80 ff ff 
ffff800000108d05:	ff d0                	callq  *%rax
ffff800000108d07:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108d0b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108d10:	75 1b                	jne    ffff800000108d2d <sys_open+0xf0>
      end_op();
ffff800000108d12:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108d17:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108d1e:	80 ff ff 
ffff800000108d21:	ff d2                	callq  *%rdx
      return -1;
ffff800000108d23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108d28:	e9 59 01 00 00       	jmpq   ffff800000108e86 <sys_open+0x249>
    }
    ilock(ip);
ffff800000108d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d31:	48 89 c7             	mov    %rax,%rdi
ffff800000108d34:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000108d3b:	80 ff ff 
ffff800000108d3e:	ff d0                	callq  *%rax
    if(ip->type == T_DIR && omode != O_RDONLY){
ffff800000108d40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d44:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108d4b:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108d4f:	75 35                	jne    ffff800000108d86 <sys_open+0x149>
ffff800000108d51:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108d54:	85 c0                	test   %eax,%eax
ffff800000108d56:	74 2e                	je     ffff800000108d86 <sys_open+0x149>
      iunlockput(ip);
ffff800000108d58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d5c:	48 89 c7             	mov    %rax,%rdi
ffff800000108d5f:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108d66:	80 ff ff 
ffff800000108d69:	ff d0                	callq  *%rax
      end_op();
ffff800000108d6b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108d70:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108d77:	80 ff ff 
ffff800000108d7a:	ff d2                	callq  *%rdx
      return -1;
ffff800000108d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108d81:	e9 00 01 00 00       	jmpq   ffff800000108e86 <sys_open+0x249>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
ffff800000108d86:	48 b8 84 1b 10 00 00 	movabs $0xffff800000101b84,%rax
ffff800000108d8d:	80 ff ff 
ffff800000108d90:	ff d0                	callq  *%rax
ffff800000108d92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108d96:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108d9b:	74 1c                	je     ffff800000108db9 <sys_open+0x17c>
ffff800000108d9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108da1:	48 89 c7             	mov    %rax,%rdi
ffff800000108da4:	48 b8 65 81 10 00 00 	movabs $0xffff800000108165,%rax
ffff800000108dab:	80 ff ff 
ffff800000108dae:	ff d0                	callq  *%rax
ffff800000108db0:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffff800000108db3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff800000108db7:	79 48                	jns    ffff800000108e01 <sys_open+0x1c4>
    if(f)
ffff800000108db9:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108dbe:	74 13                	je     ffff800000108dd3 <sys_open+0x196>
      fileclose(f);
ffff800000108dc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108dc4:	48 89 c7             	mov    %rax,%rdi
ffff800000108dc7:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000108dce:	80 ff ff 
ffff800000108dd1:	ff d0                	callq  *%rax
    iunlockput(ip);
ffff800000108dd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108dd7:	48 89 c7             	mov    %rax,%rdi
ffff800000108dda:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108de1:	80 ff ff 
ffff800000108de4:	ff d0                	callq  *%rax
    end_op();
ffff800000108de6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108deb:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108df2:	80 ff ff 
ffff800000108df5:	ff d2                	callq  *%rdx
    return -1;
ffff800000108df7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108dfc:	e9 85 00 00 00       	jmpq   ffff800000108e86 <sys_open+0x249>
  }
  iunlock(ip);
ffff800000108e01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108e05:	48 89 c7             	mov    %rax,%rdi
ffff800000108e08:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff800000108e0f:	80 ff ff 
ffff800000108e12:	ff d0                	callq  *%rax
  end_op();
ffff800000108e14:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108e19:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108e20:	80 ff ff 
ffff800000108e23:	ff d2                	callq  *%rdx

  f->type = FD_INODE;
ffff800000108e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e29:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
  f->ip = ip;
ffff800000108e2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e33:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000108e37:	48 89 50 18          	mov    %rdx,0x18(%rax)
  f->off = 0;
ffff800000108e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e3f:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%rax)
  f->readable = !(omode & O_WRONLY);
ffff800000108e46:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108e49:	83 e0 01             	and    $0x1,%eax
ffff800000108e4c:	85 c0                	test   %eax,%eax
ffff800000108e4e:	0f 94 c0             	sete   %al
ffff800000108e51:	89 c2                	mov    %eax,%edx
ffff800000108e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e57:	88 50 08             	mov    %dl,0x8(%rax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
ffff800000108e5a:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108e5d:	83 e0 01             	and    $0x1,%eax
ffff800000108e60:	85 c0                	test   %eax,%eax
ffff800000108e62:	75 0a                	jne    ffff800000108e6e <sys_open+0x231>
ffff800000108e64:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108e67:	83 e0 02             	and    $0x2,%eax
ffff800000108e6a:	85 c0                	test   %eax,%eax
ffff800000108e6c:	74 07                	je     ffff800000108e75 <sys_open+0x238>
ffff800000108e6e:	b8 01 00 00 00       	mov    $0x1,%eax
ffff800000108e73:	eb 05                	jmp    ffff800000108e7a <sys_open+0x23d>
ffff800000108e75:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108e7a:	89 c2                	mov    %eax,%edx
ffff800000108e7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e80:	88 50 09             	mov    %dl,0x9(%rax)
  return fd;
ffff800000108e83:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
ffff800000108e86:	c9                   	leaveq 
ffff800000108e87:	c3                   	retq   

ffff800000108e88 <sys_mkdir>:

int
sys_mkdir(void)
{
ffff800000108e88:	f3 0f 1e fa          	endbr64 
ffff800000108e8c:	55                   	push   %rbp
ffff800000108e8d:	48 89 e5             	mov    %rsp,%rbp
ffff800000108e90:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffff800000108e94:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108e99:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000108ea0:	80 ff ff 
ffff800000108ea3:	ff d2                	callq  *%rdx
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
ffff800000108ea5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000108ea9:	48 89 c6             	mov    %rax,%rsi
ffff800000108eac:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108eb1:	48 b8 67 7f 10 00 00 	movabs $0xffff800000107f67,%rax
ffff800000108eb8:	80 ff ff 
ffff800000108ebb:	ff d0                	callq  *%rax
ffff800000108ebd:	85 c0                	test   %eax,%eax
ffff800000108ebf:	78 2d                	js     ffff800000108eee <sys_mkdir+0x66>
ffff800000108ec1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108ec5:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff800000108eca:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000108ecf:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000108ed4:	48 89 c7             	mov    %rax,%rdi
ffff800000108ed7:	48 b8 cf 89 10 00 00 	movabs $0xffff8000001089cf,%rax
ffff800000108ede:	80 ff ff 
ffff800000108ee1:	ff d0                	callq  *%rax
ffff800000108ee3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108ee7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108eec:	75 18                	jne    ffff800000108f06 <sys_mkdir+0x7e>
    end_op();
ffff800000108eee:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108ef3:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108efa:	80 ff ff 
ffff800000108efd:	ff d2                	callq  *%rdx
    return -1;
ffff800000108eff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108f04:	eb 29                	jmp    ffff800000108f2f <sys_mkdir+0xa7>
  }
  iunlockput(ip);
ffff800000108f06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f0a:	48 89 c7             	mov    %rax,%rdi
ffff800000108f0d:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108f14:	80 ff ff 
ffff800000108f17:	ff d0                	callq  *%rax
  end_op();
ffff800000108f19:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108f1e:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108f25:	80 ff ff 
ffff800000108f28:	ff d2                	callq  *%rdx
  return 0;
ffff800000108f2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108f2f:	c9                   	leaveq 
ffff800000108f30:	c3                   	retq   

ffff800000108f31 <sys_mknod>:

int
sys_mknod(void)
{
ffff800000108f31:	f3 0f 1e fa          	endbr64 
ffff800000108f35:	55                   	push   %rbp
ffff800000108f36:	48 89 e5             	mov    %rsp,%rbp
ffff800000108f39:	48 83 ec 20          	sub    $0x20,%rsp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
ffff800000108f3d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108f42:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff800000108f49:	80 ff ff 
ffff800000108f4c:	ff d2                	callq  *%rdx
  if((argstr(0, &path)) < 0 ||
ffff800000108f4e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000108f52:	48 89 c6             	mov    %rax,%rsi
ffff800000108f55:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108f5a:	48 b8 67 7f 10 00 00 	movabs $0xffff800000107f67,%rax
ffff800000108f61:	80 ff ff 
ffff800000108f64:	ff d0                	callq  *%rax
ffff800000108f66:	85 c0                	test   %eax,%eax
ffff800000108f68:	78 67                	js     ffff800000108fd1 <sys_mknod+0xa0>
     argint(1, &major) < 0 ||
ffff800000108f6a:	48 8d 45 ec          	lea    -0x14(%rbp),%rax
ffff800000108f6e:	48 89 c6             	mov    %rax,%rsi
ffff800000108f71:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108f76:	48 b8 6e 7e 10 00 00 	movabs $0xffff800000107e6e,%rax
ffff800000108f7d:	80 ff ff 
ffff800000108f80:	ff d0                	callq  *%rax
  if((argstr(0, &path)) < 0 ||
ffff800000108f82:	85 c0                	test   %eax,%eax
ffff800000108f84:	78 4b                	js     ffff800000108fd1 <sys_mknod+0xa0>
     argint(2, &minor) < 0 ||
ffff800000108f86:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000108f8a:	48 89 c6             	mov    %rax,%rsi
ffff800000108f8d:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000108f92:	48 b8 6e 7e 10 00 00 	movabs $0xffff800000107e6e,%rax
ffff800000108f99:	80 ff ff 
ffff800000108f9c:	ff d0                	callq  *%rax
     argint(1, &major) < 0 ||
ffff800000108f9e:	85 c0                	test   %eax,%eax
ffff800000108fa0:	78 2f                	js     ffff800000108fd1 <sys_mknod+0xa0>
     (ip = create(path, T_DEV, major, minor)) == 0){
ffff800000108fa2:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000108fa5:	0f bf c8             	movswl %ax,%ecx
ffff800000108fa8:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000108fab:	0f bf d0             	movswl %ax,%edx
ffff800000108fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108fb2:	be 03 00 00 00       	mov    $0x3,%esi
ffff800000108fb7:	48 89 c7             	mov    %rax,%rdi
ffff800000108fba:	48 b8 cf 89 10 00 00 	movabs $0xffff8000001089cf,%rax
ffff800000108fc1:	80 ff ff 
ffff800000108fc4:	ff d0                	callq  *%rax
ffff800000108fc6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
     argint(2, &minor) < 0 ||
ffff800000108fca:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108fcf:	75 18                	jne    ffff800000108fe9 <sys_mknod+0xb8>
    end_op();
ffff800000108fd1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108fd6:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000108fdd:	80 ff ff 
ffff800000108fe0:	ff d2                	callq  *%rdx
    return -1;
ffff800000108fe2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108fe7:	eb 29                	jmp    ffff800000109012 <sys_mknod+0xe1>
  }
  iunlockput(ip);
ffff800000108fe9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108fed:	48 89 c7             	mov    %rax,%rdi
ffff800000108ff0:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff800000108ff7:	80 ff ff 
ffff800000108ffa:	ff d0                	callq  *%rax
  end_op();
ffff800000108ffc:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109001:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000109008:	80 ff ff 
ffff80000010900b:	ff d2                	callq  *%rdx
  return 0;
ffff80000010900d:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109012:	c9                   	leaveq 
ffff800000109013:	c3                   	retq   

ffff800000109014 <sys_chdir>:

int
sys_chdir(void)
{
ffff800000109014:	f3 0f 1e fa          	endbr64 
ffff800000109018:	55                   	push   %rbp
ffff800000109019:	48 89 e5             	mov    %rsp,%rbp
ffff80000010901c:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffff800000109020:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109025:	48 ba 79 4f 10 00 00 	movabs $0xffff800000104f79,%rdx
ffff80000010902c:	80 ff ff 
ffff80000010902f:	ff d2                	callq  *%rdx
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
ffff800000109031:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109035:	48 89 c6             	mov    %rax,%rsi
ffff800000109038:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010903d:	48 b8 67 7f 10 00 00 	movabs $0xffff800000107f67,%rax
ffff800000109044:	80 ff ff 
ffff800000109047:	ff d0                	callq  *%rax
ffff800000109049:	85 c0                	test   %eax,%eax
ffff80000010904b:	78 1e                	js     ffff80000010906b <sys_chdir+0x57>
ffff80000010904d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109051:	48 89 c7             	mov    %rax,%rdi
ffff800000109054:	48 b8 ff 37 10 00 00 	movabs $0xffff8000001037ff,%rax
ffff80000010905b:	80 ff ff 
ffff80000010905e:	ff d0                	callq  *%rax
ffff800000109060:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000109064:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000109069:	75 1b                	jne    ffff800000109086 <sys_chdir+0x72>
    end_op();
ffff80000010906b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109070:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000109077:	80 ff ff 
ffff80000010907a:	ff d2                	callq  *%rdx
    return -1;
ffff80000010907c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109081:	e9 af 00 00 00       	jmpq   ffff800000109135 <sys_chdir+0x121>
  }
  ilock(ip);
ffff800000109086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010908a:	48 89 c7             	mov    %rax,%rdi
ffff80000010908d:	48 b8 e8 28 10 00 00 	movabs $0xffff8000001028e8,%rax
ffff800000109094:	80 ff ff 
ffff800000109097:	ff d0                	callq  *%rax
  if(ip->type != T_DIR){
ffff800000109099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010909d:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff8000001090a4:	66 83 f8 01          	cmp    $0x1,%ax
ffff8000001090a8:	74 2b                	je     ffff8000001090d5 <sys_chdir+0xc1>
    iunlockput(ip);
ffff8000001090aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001090ae:	48 89 c7             	mov    %rax,%rdi
ffff8000001090b1:	48 b8 d8 2b 10 00 00 	movabs $0xffff800000102bd8,%rax
ffff8000001090b8:	80 ff ff 
ffff8000001090bb:	ff d0                	callq  *%rax
    end_op();
ffff8000001090bd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001090c2:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff8000001090c9:	80 ff ff 
ffff8000001090cc:	ff d2                	callq  *%rdx
    return -1;
ffff8000001090ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001090d3:	eb 60                	jmp    ffff800000109135 <sys_chdir+0x121>
  }
  iunlock(ip);
ffff8000001090d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001090d9:	48 89 c7             	mov    %rax,%rdi
ffff8000001090dc:	48 b8 7d 2a 10 00 00 	movabs $0xffff800000102a7d,%rax
ffff8000001090e3:	80 ff ff 
ffff8000001090e6:	ff d0                	callq  *%rax
  iput(proc->cwd);
ffff8000001090e8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001090ef:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001090f3:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff8000001090fa:	48 89 c7             	mov    %rax,%rdi
ffff8000001090fd:	48 b8 ea 2a 10 00 00 	movabs $0xffff800000102aea,%rax
ffff800000109104:	80 ff ff 
ffff800000109107:	ff d0                	callq  *%rax
  end_op();
ffff800000109109:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010910e:	48 ba 53 50 10 00 00 	movabs $0xffff800000105053,%rdx
ffff800000109115:	80 ff ff 
ffff800000109118:	ff d2                	callq  *%rdx
  proc->cwd = ip;
ffff80000010911a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109121:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109125:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000109129:	48 89 90 c8 00 00 00 	mov    %rdx,0xc8(%rax)
  return 0;
ffff800000109130:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109135:	c9                   	leaveq 
ffff800000109136:	c3                   	retq   

ffff800000109137 <sys_exec>:

int
sys_exec(void)
{
ffff800000109137:	f3 0f 1e fa          	endbr64 
ffff80000010913b:	55                   	push   %rbp
ffff80000010913c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010913f:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  char *path, *argv[MAXARG];
  int i;
  addr_t uargv, uarg;

  if(argstr(0, &path) < 0 || argaddr(1, &uargv) < 0){
ffff800000109146:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff80000010914a:	48 89 c6             	mov    %rax,%rsi
ffff80000010914d:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109152:	48 b8 67 7f 10 00 00 	movabs $0xffff800000107f67,%rax
ffff800000109159:	80 ff ff 
ffff80000010915c:	ff d0                	callq  *%rax
ffff80000010915e:	85 c0                	test   %eax,%eax
ffff800000109160:	78 1f                	js     ffff800000109181 <sys_exec+0x4a>
ffff800000109162:	48 8d 85 e8 fe ff ff 	lea    -0x118(%rbp),%rax
ffff800000109169:	48 89 c6             	mov    %rax,%rsi
ffff80000010916c:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000109171:	48 b8 a1 7e 10 00 00 	movabs $0xffff800000107ea1,%rax
ffff800000109178:	80 ff ff 
ffff80000010917b:	ff d0                	callq  *%rax
ffff80000010917d:	85 c0                	test   %eax,%eax
ffff80000010917f:	79 0a                	jns    ffff80000010918b <sys_exec+0x54>
    return -1;
ffff800000109181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109186:	e9 f2 00 00 00       	jmpq   ffff80000010927d <sys_exec+0x146>
  }
  memset(argv, 0, sizeof(argv));
ffff80000010918b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffff800000109192:	ba 00 01 00 00       	mov    $0x100,%edx
ffff800000109197:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010919c:	48 89 c7             	mov    %rax,%rdi
ffff80000010919f:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff8000001091a6:	80 ff ff 
ffff8000001091a9:	ff d0                	callq  *%rax
  for(i=0;; i++){
ffff8000001091ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    if(i >= NELEM(argv))
ffff8000001091b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001091b5:	83 f8 1f             	cmp    $0x1f,%eax
ffff8000001091b8:	76 0a                	jbe    ffff8000001091c4 <sys_exec+0x8d>
      return -1;
ffff8000001091ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001091bf:	e9 b9 00 00 00       	jmpq   ffff80000010927d <sys_exec+0x146>
    if(fetchaddr(uargv+(sizeof(addr_t))*i, (addr_t*)&uarg) < 0)
ffff8000001091c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001091c7:	48 98                	cltq   
ffff8000001091c9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001091d0:	00 
ffff8000001091d1:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
ffff8000001091d8:	48 01 c2             	add    %rax,%rdx
ffff8000001091db:	48 8d 85 e0 fe ff ff 	lea    -0x120(%rbp),%rax
ffff8000001091e2:	48 89 c6             	mov    %rax,%rsi
ffff8000001091e5:	48 89 d7             	mov    %rdx,%rdi
ffff8000001091e8:	48 b8 b5 7c 10 00 00 	movabs $0xffff800000107cb5,%rax
ffff8000001091ef:	80 ff ff 
ffff8000001091f2:	ff d0                	callq  *%rax
ffff8000001091f4:	85 c0                	test   %eax,%eax
ffff8000001091f6:	79 07                	jns    ffff8000001091ff <sys_exec+0xc8>
      return -1;
ffff8000001091f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001091fd:	eb 7e                	jmp    ffff80000010927d <sys_exec+0x146>
    if(uarg == 0){
ffff8000001091ff:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffff800000109206:	48 85 c0             	test   %rax,%rax
ffff800000109209:	75 31                	jne    ffff80000010923c <sys_exec+0x105>
      argv[i] = 0;
ffff80000010920b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010920e:	48 98                	cltq   
ffff800000109210:	48 c7 84 c5 f0 fe ff 	movq   $0x0,-0x110(%rbp,%rax,8)
ffff800000109217:	ff 00 00 00 00 
      break;
ffff80000010921c:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
ffff80000010921d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109221:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
ffff800000109228:	48 89 d6             	mov    %rdx,%rsi
ffff80000010922b:	48 89 c7             	mov    %rax,%rdi
ffff80000010922e:	48 b8 3d 15 10 00 00 	movabs $0xffff80000010153d,%rax
ffff800000109235:	80 ff ff 
ffff800000109238:	ff d0                	callq  *%rax
ffff80000010923a:	eb 41                	jmp    ffff80000010927d <sys_exec+0x146>
    if(fetchstr(uarg, &argv[i]) < 0)
ffff80000010923c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffff800000109243:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000109246:	48 63 d2             	movslq %edx,%rdx
ffff800000109249:	48 c1 e2 03          	shl    $0x3,%rdx
ffff80000010924d:	48 01 c2             	add    %rax,%rdx
ffff800000109250:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffff800000109257:	48 89 d6             	mov    %rdx,%rsi
ffff80000010925a:	48 89 c7             	mov    %rax,%rdi
ffff80000010925d:	48 b8 14 7d 10 00 00 	movabs $0xffff800000107d14,%rax
ffff800000109264:	80 ff ff 
ffff800000109267:	ff d0                	callq  *%rax
ffff800000109269:	85 c0                	test   %eax,%eax
ffff80000010926b:	79 07                	jns    ffff800000109274 <sys_exec+0x13d>
      return -1;
ffff80000010926d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109272:	eb 09                	jmp    ffff80000010927d <sys_exec+0x146>
  for(i=0;; i++){
ffff800000109274:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    if(i >= NELEM(argv))
ffff800000109278:	e9 35 ff ff ff       	jmpq   ffff8000001091b2 <sys_exec+0x7b>
}
ffff80000010927d:	c9                   	leaveq 
ffff80000010927e:	c3                   	retq   

ffff80000010927f <sys_pipe>:

int
sys_pipe(void)
{
ffff80000010927f:	f3 0f 1e fa          	endbr64 
ffff800000109283:	55                   	push   %rbp
ffff800000109284:	48 89 e5             	mov    %rsp,%rbp
ffff800000109287:	48 83 ec 20          	sub    $0x20,%rsp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
ffff80000010928b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff80000010928f:	ba 08 00 00 00       	mov    $0x8,%edx
ffff800000109294:	48 89 c6             	mov    %rax,%rsi
ffff800000109297:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010929c:	48 b8 d3 7e 10 00 00 	movabs $0xffff800000107ed3,%rax
ffff8000001092a3:	80 ff ff 
ffff8000001092a6:	ff d0                	callq  *%rax
ffff8000001092a8:	85 c0                	test   %eax,%eax
ffff8000001092aa:	79 0a                	jns    ffff8000001092b6 <sys_pipe+0x37>
    return -1;
ffff8000001092ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001092b1:	e9 d3 00 00 00       	jmpq   ffff800000109389 <sys_pipe+0x10a>
  if(pipealloc(&rf, &wf) < 0)
ffff8000001092b6:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff8000001092ba:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff8000001092be:	48 89 d6             	mov    %rdx,%rsi
ffff8000001092c1:	48 89 c7             	mov    %rax,%rdi
ffff8000001092c4:	48 b8 c6 5c 10 00 00 	movabs $0xffff800000105cc6,%rax
ffff8000001092cb:	80 ff ff 
ffff8000001092ce:	ff d0                	callq  *%rax
ffff8000001092d0:	85 c0                	test   %eax,%eax
ffff8000001092d2:	79 0a                	jns    ffff8000001092de <sys_pipe+0x5f>
    return -1;
ffff8000001092d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001092d9:	e9 ab 00 00 00       	jmpq   ffff800000109389 <sys_pipe+0x10a>
  fd0 = -1;
ffff8000001092de:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
ffff8000001092e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001092e9:	48 89 c7             	mov    %rax,%rdi
ffff8000001092ec:	48 b8 65 81 10 00 00 	movabs $0xffff800000108165,%rax
ffff8000001092f3:	80 ff ff 
ffff8000001092f6:	ff d0                	callq  *%rax
ffff8000001092f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001092fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff8000001092ff:	78 1c                	js     ffff80000010931d <sys_pipe+0x9e>
ffff800000109301:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000109305:	48 89 c7             	mov    %rax,%rdi
ffff800000109308:	48 b8 65 81 10 00 00 	movabs $0xffff800000108165,%rax
ffff80000010930f:	80 ff ff 
ffff800000109312:	ff d0                	callq  *%rax
ffff800000109314:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffff800000109317:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff80000010931b:	79 51                	jns    ffff80000010936e <sys_pipe+0xef>
    if(fd0 >= 0)
ffff80000010931d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000109321:	78 1e                	js     ffff800000109341 <sys_pipe+0xc2>
      proc->ofile[fd0] = 0;
ffff800000109323:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010932a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010932e:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000109331:	48 63 d2             	movslq %edx,%rdx
ffff800000109334:	48 83 c2 08          	add    $0x8,%rdx
ffff800000109338:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff80000010933f:	00 00 
    fileclose(rf);
ffff800000109341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109345:	48 89 c7             	mov    %rax,%rdi
ffff800000109348:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff80000010934f:	80 ff ff 
ffff800000109352:	ff d0                	callq  *%rax
    fileclose(wf);
ffff800000109354:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000109358:	48 89 c7             	mov    %rax,%rdi
ffff80000010935b:	48 b8 8e 1c 10 00 00 	movabs $0xffff800000101c8e,%rax
ffff800000109362:	80 ff ff 
ffff800000109365:	ff d0                	callq  *%rax
    return -1;
ffff800000109367:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010936c:	eb 1b                	jmp    ffff800000109389 <sys_pipe+0x10a>
  }
  fd[0] = fd0;
ffff80000010936e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109372:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000109375:	89 10                	mov    %edx,(%rax)
  fd[1] = fd1;
ffff800000109377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010937b:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff80000010937f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000109382:	89 02                	mov    %eax,(%rdx)
  return 0;
ffff800000109384:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109389:	c9                   	leaveq 
ffff80000010938a:	c3                   	retq   

ffff80000010938b <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
ffff80000010938b:	f3 0f 1e fa          	endbr64 
ffff80000010938f:	55                   	push   %rbp
ffff800000109390:	48 89 e5             	mov    %rsp,%rbp
  return fork();
ffff800000109393:	48 b8 e7 65 10 00 00 	movabs $0xffff8000001065e7,%rax
ffff80000010939a:	80 ff ff 
ffff80000010939d:	ff d0                	callq  *%rax
}
ffff80000010939f:	5d                   	pop    %rbp
ffff8000001093a0:	c3                   	retq   

ffff8000001093a1 <sys_exit>:

int
sys_exit(void)
{
ffff8000001093a1:	f3 0f 1e fa          	endbr64 
ffff8000001093a5:	55                   	push   %rbp
ffff8000001093a6:	48 89 e5             	mov    %rsp,%rbp
  exit();
ffff8000001093a9:	48 b8 a1 68 10 00 00 	movabs $0xffff8000001068a1,%rax
ffff8000001093b0:	80 ff ff 
ffff8000001093b3:	ff d0                	callq  *%rax
  return 0;  // not reached
ffff8000001093b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001093ba:	5d                   	pop    %rbp
ffff8000001093bb:	c3                   	retq   

ffff8000001093bc <sys_wait>:

int
sys_wait(void)
{
ffff8000001093bc:	f3 0f 1e fa          	endbr64 
ffff8000001093c0:	55                   	push   %rbp
ffff8000001093c1:	48 89 e5             	mov    %rsp,%rbp
  return wait();
ffff8000001093c4:	48 b8 97 6a 10 00 00 	movabs $0xffff800000106a97,%rax
ffff8000001093cb:	80 ff ff 
ffff8000001093ce:	ff d0                	callq  *%rax
}
ffff8000001093d0:	5d                   	pop    %rbp
ffff8000001093d1:	c3                   	retq   

ffff8000001093d2 <sys_kill>:

int
sys_kill(void)
{
ffff8000001093d2:	f3 0f 1e fa          	endbr64 
ffff8000001093d6:	55                   	push   %rbp
ffff8000001093d7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001093da:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  if(argint(0, &pid) < 0)
ffff8000001093de:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff8000001093e2:	48 89 c6             	mov    %rax,%rsi
ffff8000001093e5:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001093ea:	48 b8 6e 7e 10 00 00 	movabs $0xffff800000107e6e,%rax
ffff8000001093f1:	80 ff ff 
ffff8000001093f4:	ff d0                	callq  *%rax
ffff8000001093f6:	85 c0                	test   %eax,%eax
ffff8000001093f8:	79 07                	jns    ffff800000109401 <sys_kill+0x2f>
    return -1;
ffff8000001093fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001093ff:	eb 11                	jmp    ffff800000109412 <sys_kill+0x40>
  return kill(pid);
ffff800000109401:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109404:	89 c7                	mov    %eax,%edi
ffff800000109406:	48 b8 d8 70 10 00 00 	movabs $0xffff8000001070d8,%rax
ffff80000010940d:	80 ff ff 
ffff800000109410:	ff d0                	callq  *%rax
}
ffff800000109412:	c9                   	leaveq 
ffff800000109413:	c3                   	retq   

ffff800000109414 <sys_getpid>:

int
sys_getpid(void)
{
ffff800000109414:	f3 0f 1e fa          	endbr64 
ffff800000109418:	55                   	push   %rbp
ffff800000109419:	48 89 e5             	mov    %rsp,%rbp
  return proc->pid;
ffff80000010941c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109423:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109427:	8b 40 1c             	mov    0x1c(%rax),%eax
}
ffff80000010942a:	5d                   	pop    %rbp
ffff80000010942b:	c3                   	retq   

ffff80000010942c <sys_sbrk>:

addr_t
sys_sbrk(void)
{
ffff80000010942c:	f3 0f 1e fa          	endbr64 
ffff800000109430:	55                   	push   %rbp
ffff800000109431:	48 89 e5             	mov    %rsp,%rbp
ffff800000109434:	48 83 ec 10          	sub    $0x10,%rsp
  addr_t addr;
  addr_t n;

  argaddr(0, &n);
ffff800000109438:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff80000010943c:	48 89 c6             	mov    %rax,%rsi
ffff80000010943f:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109444:	48 b8 a1 7e 10 00 00 	movabs $0xffff800000107ea1,%rax
ffff80000010944b:	80 ff ff 
ffff80000010944e:	ff d0                	callq  *%rax
  addr = proc->sz;
ffff800000109450:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109457:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010945b:	48 8b 00             	mov    (%rax),%rax
ffff80000010945e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(growproc(n) < 0)
ffff800000109462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109466:	48 89 c7             	mov    %rax,%rdi
ffff800000109469:	48 b8 00 65 10 00 00 	movabs $0xffff800000106500,%rax
ffff800000109470:	80 ff ff 
ffff800000109473:	ff d0                	callq  *%rax
ffff800000109475:	85 c0                	test   %eax,%eax
ffff800000109477:	79 09                	jns    ffff800000109482 <sys_sbrk+0x56>
    return -1;
ffff800000109479:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
ffff800000109480:	eb 04                	jmp    ffff800000109486 <sys_sbrk+0x5a>
  return addr;
ffff800000109482:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000109486:	c9                   	leaveq 
ffff800000109487:	c3                   	retq   

ffff800000109488 <sys_sleep>:

int
sys_sleep(void)
{
ffff800000109488:	f3 0f 1e fa          	endbr64 
ffff80000010948c:	55                   	push   %rbp
ffff80000010948d:	48 89 e5             	mov    %rsp,%rbp
ffff800000109490:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
ffff800000109494:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000109498:	48 89 c6             	mov    %rax,%rsi
ffff80000010949b:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001094a0:	48 b8 6e 7e 10 00 00 	movabs $0xffff800000107e6e,%rax
ffff8000001094a7:	80 ff ff 
ffff8000001094aa:	ff d0                	callq  *%rax
ffff8000001094ac:	85 c0                	test   %eax,%eax
ffff8000001094ae:	79 0a                	jns    ffff8000001094ba <sys_sleep+0x32>
    return -1;
ffff8000001094b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001094b5:	e9 a7 00 00 00       	jmpq   ffff800000109561 <sys_sleep+0xd9>
  acquire(&tickslock);
ffff8000001094ba:	48 bf e0 ac 11 00 00 	movabs $0xffff80000011ace0,%rdi
ffff8000001094c1:	80 ff ff 
ffff8000001094c4:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff8000001094cb:	80 ff ff 
ffff8000001094ce:	ff d0                	callq  *%rax
  ticks0 = ticks;
ffff8000001094d0:	48 b8 48 ad 11 00 00 	movabs $0xffff80000011ad48,%rax
ffff8000001094d7:	80 ff ff 
ffff8000001094da:	8b 00                	mov    (%rax),%eax
ffff8000001094dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while(ticks - ticks0 < n){
ffff8000001094df:	eb 4f                	jmp    ffff800000109530 <sys_sleep+0xa8>
    if(proc->killed){
ffff8000001094e1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001094e8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001094ec:	8b 40 40             	mov    0x40(%rax),%eax
ffff8000001094ef:	85 c0                	test   %eax,%eax
ffff8000001094f1:	74 1d                	je     ffff800000109510 <sys_sleep+0x88>
      release(&tickslock);
ffff8000001094f3:	48 bf e0 ac 11 00 00 	movabs $0xffff80000011ace0,%rdi
ffff8000001094fa:	80 ff ff 
ffff8000001094fd:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000109504:	80 ff ff 
ffff800000109507:	ff d0                	callq  *%rax
      return -1;
ffff800000109509:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010950e:	eb 51                	jmp    ffff800000109561 <sys_sleep+0xd9>
    }
    sleep(&ticks, &tickslock);
ffff800000109510:	48 be e0 ac 11 00 00 	movabs $0xffff80000011ace0,%rsi
ffff800000109517:	80 ff ff 
ffff80000010951a:	48 bf 48 ad 11 00 00 	movabs $0xffff80000011ad48,%rdi
ffff800000109521:	80 ff ff 
ffff800000109524:	48 b8 15 6f 10 00 00 	movabs $0xffff800000106f15,%rax
ffff80000010952b:	80 ff ff 
ffff80000010952e:	ff d0                	callq  *%rax
  while(ticks - ticks0 < n){
ffff800000109530:	48 b8 48 ad 11 00 00 	movabs $0xffff80000011ad48,%rax
ffff800000109537:	80 ff ff 
ffff80000010953a:	8b 00                	mov    (%rax),%eax
ffff80000010953c:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010953f:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000109542:	39 d0                	cmp    %edx,%eax
ffff800000109544:	72 9b                	jb     ffff8000001094e1 <sys_sleep+0x59>
  }
  release(&tickslock);
ffff800000109546:	48 bf e0 ac 11 00 00 	movabs $0xffff80000011ace0,%rdi
ffff80000010954d:	80 ff ff 
ffff800000109550:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000109557:	80 ff ff 
ffff80000010955a:	ff d0                	callq  *%rax
  return 0;
ffff80000010955c:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109561:	c9                   	leaveq 
ffff800000109562:	c3                   	retq   

ffff800000109563 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
ffff800000109563:	f3 0f 1e fa          	endbr64 
ffff800000109567:	55                   	push   %rbp
ffff800000109568:	48 89 e5             	mov    %rsp,%rbp
ffff80000010956b:	48 83 ec 10          	sub    $0x10,%rsp
  uint xticks;

  acquire(&tickslock);
ffff80000010956f:	48 bf e0 ac 11 00 00 	movabs $0xffff80000011ace0,%rdi
ffff800000109576:	80 ff ff 
ffff800000109579:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff800000109580:	80 ff ff 
ffff800000109583:	ff d0                	callq  *%rax
  xticks = ticks;
ffff800000109585:	48 b8 48 ad 11 00 00 	movabs $0xffff80000011ad48,%rax
ffff80000010958c:	80 ff ff 
ffff80000010958f:	8b 00                	mov    (%rax),%eax
ffff800000109591:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&tickslock);
ffff800000109594:	48 bf e0 ac 11 00 00 	movabs $0xffff80000011ace0,%rdi
ffff80000010959b:	80 ff ff 
ffff80000010959e:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff8000001095a5:	80 ff ff 
ffff8000001095a8:	ff d0                	callq  *%rax
  return xticks;
ffff8000001095aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001095ad:	c9                   	leaveq 
ffff8000001095ae:	c3                   	retq   

ffff8000001095af <alltraps>:
# vectors.S sends all traps here.
.global alltraps
alltraps:
  # Build trap frame.
  pushq   %r15
ffff8000001095af:	41 57                	push   %r15
  pushq   %r14
ffff8000001095b1:	41 56                	push   %r14
  pushq   %r13
ffff8000001095b3:	41 55                	push   %r13
  pushq   %r12
ffff8000001095b5:	41 54                	push   %r12
  pushq   %r11
ffff8000001095b7:	41 53                	push   %r11
  pushq   %r10
ffff8000001095b9:	41 52                	push   %r10
  pushq   %r9
ffff8000001095bb:	41 51                	push   %r9
  pushq   %r8
ffff8000001095bd:	41 50                	push   %r8
  pushq   %rdi
ffff8000001095bf:	57                   	push   %rdi
  pushq   %rsi
ffff8000001095c0:	56                   	push   %rsi
  pushq   %rbp
ffff8000001095c1:	55                   	push   %rbp
  pushq   %rdx
ffff8000001095c2:	52                   	push   %rdx
  pushq   %rcx
ffff8000001095c3:	51                   	push   %rcx
  pushq   %rbx
ffff8000001095c4:	53                   	push   %rbx
  pushq   %rax
ffff8000001095c5:	50                   	push   %rax

  movq    %rsp, %rdi  # frame in arg1
ffff8000001095c6:	48 89 e7             	mov    %rsp,%rdi
  callq   trap
ffff8000001095c9:	e8 8d 02 00 00       	callq  ffff80000010985b <trap>

ffff8000001095ce <trapret>:
# Return falls through to trapret...

.global trapret
trapret:
  popq    %rax
ffff8000001095ce:	58                   	pop    %rax
  popq    %rbx
ffff8000001095cf:	5b                   	pop    %rbx
  popq    %rcx
ffff8000001095d0:	59                   	pop    %rcx
  popq    %rdx
ffff8000001095d1:	5a                   	pop    %rdx
  popq    %rbp
ffff8000001095d2:	5d                   	pop    %rbp
  popq    %rsi
ffff8000001095d3:	5e                   	pop    %rsi
  popq    %rdi
ffff8000001095d4:	5f                   	pop    %rdi
  popq    %r8
ffff8000001095d5:	41 58                	pop    %r8
  popq    %r9
ffff8000001095d7:	41 59                	pop    %r9
  popq    %r10
ffff8000001095d9:	41 5a                	pop    %r10
  popq    %r11
ffff8000001095db:	41 5b                	pop    %r11
  popq    %r12
ffff8000001095dd:	41 5c                	pop    %r12
  popq    %r13
ffff8000001095df:	41 5d                	pop    %r13
  popq    %r14
ffff8000001095e1:	41 5e                	pop    %r14
  popq    %r15
ffff8000001095e3:	41 5f                	pop    %r15

  addq    $16, %rsp  # discard trapnum and errorcode
ffff8000001095e5:	48 83 c4 10          	add    $0x10,%rsp
  iretq
ffff8000001095e9:	48 cf                	iretq  

ffff8000001095eb <syscall_entry>:
.global syscall_entry
syscall_entry:
  # switch to kernel stack. With the syscall instruction,
  # this is a kernel resposibility
  # store %rsp on the top of proc->kstack,
  movq    %rax, %fs:(0)      # save %rax above __thread vars
ffff8000001095eb:	64 48 89 04 25 00 00 	mov    %rax,%fs:0x0
ffff8000001095f2:	00 00 
  movq    %fs:(-8), %rax     # %fs:(-8) is proc (the last __thread)
ffff8000001095f4:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff8000001095fb:	ff ff 
  movq    0x10(%rax), %rax   # get proc->kstack (see struct proc)
ffff8000001095fd:	48 8b 40 10          	mov    0x10(%rax),%rax
  addq    $(4096-16), %rax   # %rax points to tf->rsp
ffff800000109601:	48 05 f0 0f 00 00    	add    $0xff0,%rax
  movq    %rsp, (%rax)       # save user rsp to tf->rsp
ffff800000109607:	48 89 20             	mov    %rsp,(%rax)
  movq    %rax, %rsp         # switch to the kstack
ffff80000010960a:	48 89 c4             	mov    %rax,%rsp
  movq    %fs:(0), %rax      # restore %rax
ffff80000010960d:	64 48 8b 04 25 00 00 	mov    %fs:0x0,%rax
ffff800000109614:	00 00 

  pushq   %r11         # rflags
ffff800000109616:	41 53                	push   %r11
  pushq   $0           # cs is ignored
ffff800000109618:	6a 00                	pushq  $0x0
  pushq   %rcx         # rip (next user insn)
ffff80000010961a:	51                   	push   %rcx

  pushq   $0           # err
ffff80000010961b:	6a 00                	pushq  $0x0
  pushq   $0           # trapno ignored
ffff80000010961d:	6a 00                	pushq  $0x0

  pushq   %r15
ffff80000010961f:	41 57                	push   %r15
  pushq   %r14
ffff800000109621:	41 56                	push   %r14
  pushq   %r13
ffff800000109623:	41 55                	push   %r13
  pushq   %r12
ffff800000109625:	41 54                	push   %r12
  pushq   %r11
ffff800000109627:	41 53                	push   %r11
  pushq   %r10
ffff800000109629:	41 52                	push   %r10
  pushq   %r9
ffff80000010962b:	41 51                	push   %r9
  pushq   %r8
ffff80000010962d:	41 50                	push   %r8
  pushq   %rdi
ffff80000010962f:	57                   	push   %rdi
  pushq   %rsi
ffff800000109630:	56                   	push   %rsi
  pushq   %rbp
ffff800000109631:	55                   	push   %rbp
  pushq   %rdx
ffff800000109632:	52                   	push   %rdx
  pushq   %rcx
ffff800000109633:	51                   	push   %rcx
  pushq   %rbx
ffff800000109634:	53                   	push   %rbx
  pushq   %rax
ffff800000109635:	50                   	push   %rax

  movq    %rsp, %rdi  # frame in arg1
ffff800000109636:	48 89 e7             	mov    %rsp,%rdi
  callq   syscall
ffff800000109639:	e8 7c e9 ff ff       	callq  ffff800000107fba <syscall>

ffff80000010963e <syscall_trapret>:
# Return falls through to syscall_trapret...
#PAGEBREAK!

.global syscall_trapret
syscall_trapret:
  popq    %rax
ffff80000010963e:	58                   	pop    %rax
  popq    %rbx
ffff80000010963f:	5b                   	pop    %rbx
  popq    %rcx
ffff800000109640:	59                   	pop    %rcx
  popq    %rdx
ffff800000109641:	5a                   	pop    %rdx
  popq    %rbp
ffff800000109642:	5d                   	pop    %rbp
  popq    %rsi
ffff800000109643:	5e                   	pop    %rsi
  popq    %rdi
ffff800000109644:	5f                   	pop    %rdi
  popq    %r8
ffff800000109645:	41 58                	pop    %r8
  popq    %r9
ffff800000109647:	41 59                	pop    %r9
  popq    %r10
ffff800000109649:	41 5a                	pop    %r10
  popq    %r11
ffff80000010964b:	41 5b                	pop    %r11
  popq    %r12
ffff80000010964d:	41 5c                	pop    %r12
  popq    %r13
ffff80000010964f:	41 5d                	pop    %r13
  popq    %r14
ffff800000109651:	41 5e                	pop    %r14
  popq    %r15
ffff800000109653:	41 5f                	pop    %r15

  addq    $40, %rsp  # discard trapnum, errorcode, rip, cs and rflags
ffff800000109655:	48 83 c4 28          	add    $0x28,%rsp

  # to make sure we don't get any interrupts on the user stack while in
  # supervisor mode. this is actually slightly unsafe still,
  # since some interrupts are nonmaskable.
  # See https://www.felixcloutier.com/x86/sysret
  cli
ffff800000109659:	fa                   	cli    
  movq    (%rsp), %rsp  # restore the user stack
ffff80000010965a:	48 8b 24 24          	mov    (%rsp),%rsp
  sysretq
ffff80000010965e:	48 0f 07             	sysretq 

ffff800000109661 <lidt>:
{
ffff800000109661:	f3 0f 1e fa          	endbr64 
ffff800000109665:	55                   	push   %rbp
ffff800000109666:	48 89 e5             	mov    %rsp,%rbp
ffff800000109669:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010966d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000109671:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  addr_t addr = (addr_t)p;
ffff800000109674:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000109678:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  pd[0] = size-1;
ffff80000010967c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff80000010967f:	83 e8 01             	sub    $0x1,%eax
ffff800000109682:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff800000109686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010968a:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff80000010968e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109692:	48 c1 e8 10          	shr    $0x10,%rax
ffff800000109696:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff80000010969a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010969e:	48 c1 e8 20          	shr    $0x20,%rax
ffff8000001096a2:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff8000001096a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001096aa:	48 c1 e8 30          	shr    $0x30,%rax
ffff8000001096ae:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  asm volatile("lidt (%0)" : : "r" (pd));
ffff8000001096b2:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff8000001096b6:	0f 01 18             	lidt   (%rax)
}
ffff8000001096b9:	90                   	nop
ffff8000001096ba:	c9                   	leaveq 
ffff8000001096bb:	c3                   	retq   

ffff8000001096bc <rcr2>:

static inline addr_t
rcr2(void)
{
ffff8000001096bc:	f3 0f 1e fa          	endbr64 
ffff8000001096c0:	55                   	push   %rbp
ffff8000001096c1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001096c4:	48 83 ec 10          	sub    $0x10,%rsp
  addr_t val;
  asm volatile("mov %%cr2,%0" : "=r" (val));
ffff8000001096c8:	0f 20 d0             	mov    %cr2,%rax
ffff8000001096cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return val;
ffff8000001096cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001096d3:	c9                   	leaveq 
ffff8000001096d4:	c3                   	retq   

ffff8000001096d5 <mkgate>:
struct spinlock tickslock;
uint ticks;

static void
mkgate(uint *idt, uint n, addr_t kva, uint pl)
{
ffff8000001096d5:	f3 0f 1e fa          	endbr64 
ffff8000001096d9:	55                   	push   %rbp
ffff8000001096da:	48 89 e5             	mov    %rsp,%rbp
ffff8000001096dd:	48 83 ec 28          	sub    $0x28,%rsp
ffff8000001096e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001096e5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff8000001096e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff8000001096ec:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  uint64 addr = (uint64) kva;
ffff8000001096ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001096f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  n *= 4;
ffff8000001096f7:	c1 65 e4 02          	shll   $0x2,-0x1c(%rbp)
  idt[n+0] = (addr & 0xFFFF) | (KERNEL_CS << 16);
ffff8000001096fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001096ff:	0f b7 d0             	movzwl %ax,%edx
ffff800000109702:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109705:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff80000010970c:	00 
ffff80000010970d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109711:	48 01 c8             	add    %rcx,%rax
ffff800000109714:	81 ca 00 00 08 00    	or     $0x80000,%edx
ffff80000010971a:	89 10                	mov    %edx,(%rax)
  idt[n+1] = (addr & 0xFFFF0000) | 0x8E00 | ((pl & 3) << 13);
ffff80000010971c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109720:	66 b8 00 00          	mov    $0x0,%ax
ffff800000109724:	89 c2                	mov    %eax,%edx
ffff800000109726:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000109729:	c1 e0 0d             	shl    $0xd,%eax
ffff80000010972c:	25 00 60 00 00       	and    $0x6000,%eax
ffff800000109731:	09 c2                	or     %eax,%edx
ffff800000109733:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109736:	83 c0 01             	add    $0x1,%eax
ffff800000109739:	89 c0                	mov    %eax,%eax
ffff80000010973b:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff800000109742:	00 
ffff800000109743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109747:	48 01 c8             	add    %rcx,%rax
ffff80000010974a:	80 ce 8e             	or     $0x8e,%dh
ffff80000010974d:	89 10                	mov    %edx,(%rax)
  idt[n+2] = addr >> 32;
ffff80000010974f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109753:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000109757:	48 89 c2             	mov    %rax,%rdx
ffff80000010975a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff80000010975d:	83 c0 02             	add    $0x2,%eax
ffff800000109760:	89 c0                	mov    %eax,%eax
ffff800000109762:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff800000109769:	00 
ffff80000010976a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010976e:	48 01 c8             	add    %rcx,%rax
ffff800000109771:	89 10                	mov    %edx,(%rax)
  idt[n+3] = 0;
ffff800000109773:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109776:	83 c0 03             	add    $0x3,%eax
ffff800000109779:	89 c0                	mov    %eax,%eax
ffff80000010977b:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000109782:	00 
ffff800000109783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109787:	48 01 d0             	add    %rdx,%rax
ffff80000010978a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
ffff800000109790:	90                   	nop
ffff800000109791:	c9                   	leaveq 
ffff800000109792:	c3                   	retq   

ffff800000109793 <idtinit>:

void idtinit(void)
{
ffff800000109793:	f3 0f 1e fa          	endbr64 
ffff800000109797:	55                   	push   %rbp
ffff800000109798:	48 89 e5             	mov    %rsp,%rbp
  lidt((void*) idt, PGSIZE);
ffff80000010979b:	48 b8 c0 ac 11 00 00 	movabs $0xffff80000011acc0,%rax
ffff8000001097a2:	80 ff ff 
ffff8000001097a5:	48 8b 00             	mov    (%rax),%rax
ffff8000001097a8:	be 00 10 00 00       	mov    $0x1000,%esi
ffff8000001097ad:	48 89 c7             	mov    %rax,%rdi
ffff8000001097b0:	48 b8 61 96 10 00 00 	movabs $0xffff800000109661,%rax
ffff8000001097b7:	80 ff ff 
ffff8000001097ba:	ff d0                	callq  *%rax
}
ffff8000001097bc:	90                   	nop
ffff8000001097bd:	5d                   	pop    %rbp
ffff8000001097be:	c3                   	retq   

ffff8000001097bf <tvinit>:

void tvinit(void)
{
ffff8000001097bf:	f3 0f 1e fa          	endbr64 
ffff8000001097c3:	55                   	push   %rbp
ffff8000001097c4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001097c7:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  idt = (uint*) kalloc();
ffff8000001097cb:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff8000001097d2:	80 ff ff 
ffff8000001097d5:	ff d0                	callq  *%rax
ffff8000001097d7:	48 ba c0 ac 11 00 00 	movabs $0xffff80000011acc0,%rdx
ffff8000001097de:	80 ff ff 
ffff8000001097e1:	48 89 02             	mov    %rax,(%rdx)
  memset(idt, 0, PGSIZE);
ffff8000001097e4:	48 b8 c0 ac 11 00 00 	movabs $0xffff80000011acc0,%rax
ffff8000001097eb:	80 ff ff 
ffff8000001097ee:	48 8b 00             	mov    (%rax),%rax
ffff8000001097f1:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff8000001097f6:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001097fb:	48 89 c7             	mov    %rax,%rdi
ffff8000001097fe:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff800000109805:	80 ff ff 
ffff800000109808:	ff d0                	callq  *%rax

  for (n = 0; n < 256; n++)
ffff80000010980a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000109811:	eb 3b                	jmp    ffff80000010984e <tvinit+0x8f>
    mkgate(idt, n, vectors[n], 0);
ffff800000109813:	48 ba 50 d6 10 00 00 	movabs $0xffff80000010d650,%rdx
ffff80000010981a:	80 ff ff 
ffff80000010981d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109820:	48 98                	cltq   
ffff800000109822:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
ffff800000109826:	8b 75 fc             	mov    -0x4(%rbp),%esi
ffff800000109829:	48 b8 c0 ac 11 00 00 	movabs $0xffff80000011acc0,%rax
ffff800000109830:	80 ff ff 
ffff800000109833:	48 8b 00             	mov    (%rax),%rax
ffff800000109836:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff80000010983b:	48 89 c7             	mov    %rax,%rdi
ffff80000010983e:	48 b8 d5 96 10 00 00 	movabs $0xffff8000001096d5,%rax
ffff800000109845:	80 ff ff 
ffff800000109848:	ff d0                	callq  *%rax
  for (n = 0; n < 256; n++)
ffff80000010984a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010984e:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffff800000109855:	7e bc                	jle    ffff800000109813 <tvinit+0x54>
}
ffff800000109857:	90                   	nop
ffff800000109858:	90                   	nop
ffff800000109859:	c9                   	leaveq 
ffff80000010985a:	c3                   	retq   

ffff80000010985b <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
ffff80000010985b:	f3 0f 1e fa          	endbr64 
ffff80000010985f:	55                   	push   %rbp
ffff800000109860:	48 89 e5             	mov    %rsp,%rbp
ffff800000109863:	41 54                	push   %r12
ffff800000109865:	53                   	push   %rbx
ffff800000109866:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010986a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  switch(tf->trapno){
ffff80000010986e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109872:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109876:	48 83 e8 20          	sub    $0x20,%rax
ffff80000010987a:	48 83 f8 1f          	cmp    $0x1f,%rax
ffff80000010987e:	0f 87 47 01 00 00    	ja     ffff8000001099cb <trap+0x170>
ffff800000109884:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010988b:	00 
ffff80000010988c:	48 b8 78 c3 10 00 00 	movabs $0xffff80000010c378,%rax
ffff800000109893:	80 ff ff 
ffff800000109896:	48 01 d0             	add    %rdx,%rax
ffff800000109899:	48 8b 00             	mov    (%rax),%rax
ffff80000010989c:	3e ff e0             	notrack jmpq *%rax
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
ffff80000010989f:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff8000001098a6:	80 ff ff 
ffff8000001098a9:	ff d0                	callq  *%rax
ffff8000001098ab:	85 c0                	test   %eax,%eax
ffff8000001098ad:	75 5d                	jne    ffff80000010990c <trap+0xb1>
      acquire(&tickslock);
ffff8000001098af:	48 bf e0 ac 11 00 00 	movabs $0xffff80000011ace0,%rdi
ffff8000001098b6:	80 ff ff 
ffff8000001098b9:	48 b8 2b 75 10 00 00 	movabs $0xffff80000010752b,%rax
ffff8000001098c0:	80 ff ff 
ffff8000001098c3:	ff d0                	callq  *%rax
      ticks++;
ffff8000001098c5:	48 b8 48 ad 11 00 00 	movabs $0xffff80000011ad48,%rax
ffff8000001098cc:	80 ff ff 
ffff8000001098cf:	8b 00                	mov    (%rax),%eax
ffff8000001098d1:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001098d4:	48 b8 48 ad 11 00 00 	movabs $0xffff80000011ad48,%rax
ffff8000001098db:	80 ff ff 
ffff8000001098de:	89 10                	mov    %edx,(%rax)
      wakeup(&ticks);
ffff8000001098e0:	48 bf 48 ad 11 00 00 	movabs $0xffff80000011ad48,%rdi
ffff8000001098e7:	80 ff ff 
ffff8000001098ea:	48 b8 86 70 10 00 00 	movabs $0xffff800000107086,%rax
ffff8000001098f1:	80 ff ff 
ffff8000001098f4:	ff d0                	callq  *%rax
      release(&tickslock);
ffff8000001098f6:	48 bf e0 ac 11 00 00 	movabs $0xffff80000011ace0,%rdi
ffff8000001098fd:	80 ff ff 
ffff800000109900:	48 b8 c8 75 10 00 00 	movabs $0xffff8000001075c8,%rax
ffff800000109907:	80 ff ff 
ffff80000010990a:	ff d0                	callq  *%rax
    }
    lapiceoi();
ffff80000010990c:	48 b8 2a 48 10 00 00 	movabs $0xffff80000010482a,%rax
ffff800000109913:	80 ff ff 
ffff800000109916:	ff d0                	callq  *%rax
    break;
ffff800000109918:	e9 1c 02 00 00       	jmpq   ffff800000109b39 <trap+0x2de>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
ffff80000010991d:	48 b8 0a 3c 10 00 00 	movabs $0xffff800000103c0a,%rax
ffff800000109924:	80 ff ff 
ffff800000109927:	ff d0                	callq  *%rax
    lapiceoi();
ffff800000109929:	48 b8 2a 48 10 00 00 	movabs $0xffff80000010482a,%rax
ffff800000109930:	80 ff ff 
ffff800000109933:	ff d0                	callq  *%rax
    break;
ffff800000109935:	e9 ff 01 00 00       	jmpq   ffff800000109b39 <trap+0x2de>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
ffff80000010993a:	48 b8 cb 44 10 00 00 	movabs $0xffff8000001044cb,%rax
ffff800000109941:	80 ff ff 
ffff800000109944:	ff d0                	callq  *%rax
    lapiceoi();
ffff800000109946:	48 b8 2a 48 10 00 00 	movabs $0xffff80000010482a,%rax
ffff80000010994d:	80 ff ff 
ffff800000109950:	ff d0                	callq  *%rax
    break;
ffff800000109952:	e9 e2 01 00 00       	jmpq   ffff800000109b39 <trap+0x2de>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
ffff800000109957:	48 b8 7b 9e 10 00 00 	movabs $0xffff800000109e7b,%rax
ffff80000010995e:	80 ff ff 
ffff800000109961:	ff d0                	callq  *%rax
    lapiceoi();
ffff800000109963:	48 b8 2a 48 10 00 00 	movabs $0xffff80000010482a,%rax
ffff80000010996a:	80 ff ff 
ffff80000010996d:	ff d0                	callq  *%rax
    break;
ffff80000010996f:	e9 c5 01 00 00       	jmpq   ffff800000109b39 <trap+0x2de>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %p:%p\n",
ffff800000109974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109978:	4c 8b a0 88 00 00 00 	mov    0x88(%rax),%r12
ffff80000010997f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109983:	48 8b 98 90 00 00 00 	mov    0x90(%rax),%rbx
ffff80000010998a:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff800000109991:	80 ff ff 
ffff800000109994:	ff d0                	callq  *%rax
ffff800000109996:	4c 89 e1             	mov    %r12,%rcx
ffff800000109999:	48 89 da             	mov    %rbx,%rdx
ffff80000010999c:	89 c6                	mov    %eax,%esi
ffff80000010999e:	48 bf c0 c2 10 00 00 	movabs $0xffff80000010c2c0,%rdi
ffff8000001099a5:	80 ff ff 
ffff8000001099a8:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001099ad:	49 b8 18 08 10 00 00 	movabs $0xffff800000100818,%r8
ffff8000001099b4:	80 ff ff 
ffff8000001099b7:	41 ff d0             	callq  *%r8
            cpunum(), tf->cs, tf->rip);
    lapiceoi();
ffff8000001099ba:	48 b8 2a 48 10 00 00 	movabs $0xffff80000010482a,%rax
ffff8000001099c1:	80 ff ff 
ffff8000001099c4:	ff d0                	callq  *%rax
    break;
ffff8000001099c6:	e9 6e 01 00 00       	jmpq   ffff800000109b39 <trap+0x2de>

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
ffff8000001099cb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001099d2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001099d6:	48 85 c0             	test   %rax,%rax
ffff8000001099d9:	74 17                	je     ffff8000001099f2 <trap+0x197>
ffff8000001099db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001099df:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff8000001099e6:	83 e0 03             	and    $0x3,%eax
ffff8000001099e9:	48 85 c0             	test   %rax,%rax
ffff8000001099ec:	0f 85 a6 00 00 00    	jne    ffff800000109a98 <trap+0x23d>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d rip %p (cr2=0x%p)\n",
ffff8000001099f2:	48 b8 bc 96 10 00 00 	movabs $0xffff8000001096bc,%rax
ffff8000001099f9:	80 ff ff 
ffff8000001099fc:	ff d0                	callq  *%rax
ffff8000001099fe:	49 89 c4             	mov    %rax,%r12
ffff800000109a01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109a05:	48 8b 98 88 00 00 00 	mov    0x88(%rax),%rbx
ffff800000109a0c:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff800000109a13:	80 ff ff 
ffff800000109a16:	ff d0                	callq  *%rax
ffff800000109a18:	89 c2                	mov    %eax,%edx
ffff800000109a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109a1e:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109a22:	4d 89 e0             	mov    %r12,%r8
ffff800000109a25:	48 89 d9             	mov    %rbx,%rcx
ffff800000109a28:	48 89 c6             	mov    %rax,%rsi
ffff800000109a2b:	48 bf e8 c2 10 00 00 	movabs $0xffff80000010c2e8,%rdi
ffff800000109a32:	80 ff ff 
ffff800000109a35:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109a3a:	49 b9 18 08 10 00 00 	movabs $0xffff800000100818,%r9
ffff800000109a41:	80 ff ff 
ffff800000109a44:	41 ff d1             	callq  *%r9
              tf->trapno, cpunum(), tf->rip, rcr2());
      if (proc)
ffff800000109a47:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109a4e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109a52:	48 85 c0             	test   %rax,%rax
ffff800000109a55:	74 2b                	je     ffff800000109a82 <trap+0x227>
        cprintf("proc id: %d\n", proc->pid);
ffff800000109a57:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109a5e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109a62:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000109a65:	89 c6                	mov    %eax,%esi
ffff800000109a67:	48 bf 1a c3 10 00 00 	movabs $0xffff80000010c31a,%rdi
ffff800000109a6e:	80 ff ff 
ffff800000109a71:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109a76:	48 ba 18 08 10 00 00 	movabs $0xffff800000100818,%rdx
ffff800000109a7d:	80 ff ff 
ffff800000109a80:	ff d2                	callq  *%rdx
      panic("trap");
ffff800000109a82:	48 bf 27 c3 10 00 00 	movabs $0xffff80000010c327,%rdi
ffff800000109a89:	80 ff ff 
ffff800000109a8c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff800000109a93:	80 ff ff 
ffff800000109a96:	ff d0                	callq  *%rax
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffff800000109a98:	48 b8 bc 96 10 00 00 	movabs $0xffff8000001096bc,%rax
ffff800000109a9f:	80 ff ff 
ffff800000109aa2:	ff d0                	callq  *%rax
ffff800000109aa4:	48 89 c3             	mov    %rax,%rbx
ffff800000109aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109aab:	4c 8b a0 88 00 00 00 	mov    0x88(%rax),%r12
ffff800000109ab2:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff800000109ab9:	80 ff ff 
ffff800000109abc:	ff d0                	callq  *%rax
ffff800000109abe:	89 c1                	mov    %eax,%ecx
ffff800000109ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109ac4:	48 8b b8 80 00 00 00 	mov    0x80(%rax),%rdi
ffff800000109acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109acf:	48 8b 50 78          	mov    0x78(%rax),%rdx
            "rip 0x%p addr 0x%p--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->rip,
ffff800000109ad3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109ada:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109ade:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
ffff800000109ae5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109aec:	64 48 8b 00          	mov    %fs:(%rax),%rax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffff800000109af0:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000109af3:	53                   	push   %rbx
ffff800000109af4:	41 54                	push   %r12
ffff800000109af6:	41 89 c9             	mov    %ecx,%r9d
ffff800000109af9:	49 89 f8             	mov    %rdi,%r8
ffff800000109afc:	48 89 d1             	mov    %rdx,%rcx
ffff800000109aff:	48 89 f2             	mov    %rsi,%rdx
ffff800000109b02:	89 c6                	mov    %eax,%esi
ffff800000109b04:	48 bf 30 c3 10 00 00 	movabs $0xffff80000010c330,%rdi
ffff800000109b0b:	80 ff ff 
ffff800000109b0e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109b13:	49 ba 18 08 10 00 00 	movabs $0xffff800000100818,%r10
ffff800000109b1a:	80 ff ff 
ffff800000109b1d:	41 ff d2             	callq  *%r10
ffff800000109b20:	48 83 c4 10          	add    $0x10,%rsp
            rcr2());
    proc->killed = 1;
ffff800000109b24:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109b2b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109b2f:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
ffff800000109b36:	eb 01                	jmp    ffff800000109b39 <trap+0x2de>
    break;
ffff800000109b38:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffff800000109b39:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109b40:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109b44:	48 85 c0             	test   %rax,%rax
ffff800000109b47:	74 32                	je     ffff800000109b7b <trap+0x320>
ffff800000109b49:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109b50:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109b54:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000109b57:	85 c0                	test   %eax,%eax
ffff800000109b59:	74 20                	je     ffff800000109b7b <trap+0x320>
ffff800000109b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109b5f:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff800000109b66:	83 e0 03             	and    $0x3,%eax
ffff800000109b69:	48 83 f8 03          	cmp    $0x3,%rax
ffff800000109b6d:	75 0c                	jne    ffff800000109b7b <trap+0x320>
    exit();
ffff800000109b6f:	48 b8 a1 68 10 00 00 	movabs $0xffff8000001068a1,%rax
ffff800000109b76:	80 ff ff 
ffff800000109b79:	ff d0                	callq  *%rax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
ffff800000109b7b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109b82:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109b86:	48 85 c0             	test   %rax,%rax
ffff800000109b89:	74 2d                	je     ffff800000109bb8 <trap+0x35d>
ffff800000109b8b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109b92:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109b96:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000109b99:	83 f8 04             	cmp    $0x4,%eax
ffff800000109b9c:	75 1a                	jne    ffff800000109bb8 <trap+0x35d>
ffff800000109b9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109ba2:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff800000109ba6:	48 83 f8 20          	cmp    $0x20,%rax
ffff800000109baa:	75 0c                	jne    ffff800000109bb8 <trap+0x35d>
    yield();
ffff800000109bac:	48 b8 5d 6e 10 00 00 	movabs $0xffff800000106e5d,%rax
ffff800000109bb3:	80 ff ff 
ffff800000109bb6:	ff d0                	callq  *%rax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffff800000109bb8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109bbf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109bc3:	48 85 c0             	test   %rax,%rax
ffff800000109bc6:	74 32                	je     ffff800000109bfa <trap+0x39f>
ffff800000109bc8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109bcf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109bd3:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000109bd6:	85 c0                	test   %eax,%eax
ffff800000109bd8:	74 20                	je     ffff800000109bfa <trap+0x39f>
ffff800000109bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109bde:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff800000109be5:	83 e0 03             	and    $0x3,%eax
ffff800000109be8:	48 83 f8 03          	cmp    $0x3,%rax
ffff800000109bec:	75 0c                	jne    ffff800000109bfa <trap+0x39f>
    exit();
ffff800000109bee:	48 b8 a1 68 10 00 00 	movabs $0xffff8000001068a1,%rax
ffff800000109bf5:	80 ff ff 
ffff800000109bf8:	ff d0                	callq  *%rax
}
ffff800000109bfa:	90                   	nop
ffff800000109bfb:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
ffff800000109bff:	5b                   	pop    %rbx
ffff800000109c00:	41 5c                	pop    %r12
ffff800000109c02:	5d                   	pop    %rbp
ffff800000109c03:	c3                   	retq   

ffff800000109c04 <inb>:
{
ffff800000109c04:	f3 0f 1e fa          	endbr64 
ffff800000109c08:	55                   	push   %rbp
ffff800000109c09:	48 89 e5             	mov    %rsp,%rbp
ffff800000109c0c:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000109c10:	89 f8                	mov    %edi,%eax
ffff800000109c12:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000109c16:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000109c1a:	89 c2                	mov    %eax,%edx
ffff800000109c1c:	ec                   	in     (%dx),%al
ffff800000109c1d:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000109c20:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff800000109c24:	c9                   	leaveq 
ffff800000109c25:	c3                   	retq   

ffff800000109c26 <outb>:
{
ffff800000109c26:	f3 0f 1e fa          	endbr64 
ffff800000109c2a:	55                   	push   %rbp
ffff800000109c2b:	48 89 e5             	mov    %rsp,%rbp
ffff800000109c2e:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000109c32:	89 f8                	mov    %edi,%eax
ffff800000109c34:	89 f2                	mov    %esi,%edx
ffff800000109c36:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff800000109c3a:	89 d0                	mov    %edx,%eax
ffff800000109c3c:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000109c3f:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000109c43:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000109c47:	ee                   	out    %al,(%dx)
}
ffff800000109c48:	90                   	nop
ffff800000109c49:	c9                   	leaveq 
ffff800000109c4a:	c3                   	retq   

ffff800000109c4b <uartearlyinit>:

static int uart;    // is there a uart?

void
uartearlyinit(void)
{
ffff800000109c4b:	f3 0f 1e fa          	endbr64 
ffff800000109c4f:	55                   	push   %rbp
ffff800000109c50:	48 89 e5             	mov    %rsp,%rbp
ffff800000109c53:	48 83 ec 10          	sub    $0x10,%rsp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
ffff800000109c57:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000109c5c:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff800000109c61:	48 b8 26 9c 10 00 00 	movabs $0xffff800000109c26,%rax
ffff800000109c68:	80 ff ff 
ffff800000109c6b:	ff d0                	callq  *%rax

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
ffff800000109c6d:	be 80 00 00 00       	mov    $0x80,%esi
ffff800000109c72:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff800000109c77:	48 b8 26 9c 10 00 00 	movabs $0xffff800000109c26,%rax
ffff800000109c7e:	80 ff ff 
ffff800000109c81:	ff d0                	callq  *%rax
  outb(COM1+0, 115200/9600);
ffff800000109c83:	be 0c 00 00 00       	mov    $0xc,%esi
ffff800000109c88:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff800000109c8d:	48 b8 26 9c 10 00 00 	movabs $0xffff800000109c26,%rax
ffff800000109c94:	80 ff ff 
ffff800000109c97:	ff d0                	callq  *%rax
  outb(COM1+1, 0);
ffff800000109c99:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000109c9e:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff800000109ca3:	48 b8 26 9c 10 00 00 	movabs $0xffff800000109c26,%rax
ffff800000109caa:	80 ff ff 
ffff800000109cad:	ff d0                	callq  *%rax
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
ffff800000109caf:	be 03 00 00 00       	mov    $0x3,%esi
ffff800000109cb4:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff800000109cb9:	48 b8 26 9c 10 00 00 	movabs $0xffff800000109c26,%rax
ffff800000109cc0:	80 ff ff 
ffff800000109cc3:	ff d0                	callq  *%rax
  outb(COM1+4, 0);
ffff800000109cc5:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000109cca:	bf fc 03 00 00       	mov    $0x3fc,%edi
ffff800000109ccf:	48 b8 26 9c 10 00 00 	movabs $0xffff800000109c26,%rax
ffff800000109cd6:	80 ff ff 
ffff800000109cd9:	ff d0                	callq  *%rax
  outb(COM1+1, 0x01);    // Enable receive interrupts.
ffff800000109cdb:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000109ce0:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff800000109ce5:	48 b8 26 9c 10 00 00 	movabs $0xffff800000109c26,%rax
ffff800000109cec:	80 ff ff 
ffff800000109cef:	ff d0                	callq  *%rax

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
ffff800000109cf1:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff800000109cf6:	48 b8 04 9c 10 00 00 	movabs $0xffff800000109c04,%rax
ffff800000109cfd:	80 ff ff 
ffff800000109d00:	ff d0                	callq  *%rax
ffff800000109d02:	3c ff                	cmp    $0xff,%al
ffff800000109d04:	74 4a                	je     ffff800000109d50 <uartearlyinit+0x105>
    return;
  uart = 1;
ffff800000109d06:	48 b8 4c ad 11 00 00 	movabs $0xffff80000011ad4c,%rax
ffff800000109d0d:	80 ff ff 
ffff800000109d10:	c7 00 01 00 00 00    	movl   $0x1,(%rax)



  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
ffff800000109d16:	48 b8 78 c4 10 00 00 	movabs $0xffff80000010c478,%rax
ffff800000109d1d:	80 ff ff 
ffff800000109d20:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000109d24:	eb 1d                	jmp    ffff800000109d43 <uartearlyinit+0xf8>
    uartputc(*p);
ffff800000109d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109d2a:	0f b6 00             	movzbl (%rax),%eax
ffff800000109d2d:	0f be c0             	movsbl %al,%eax
ffff800000109d30:	89 c7                	mov    %eax,%edi
ffff800000109d32:	48 b8 a8 9d 10 00 00 	movabs $0xffff800000109da8,%rax
ffff800000109d39:	80 ff ff 
ffff800000109d3c:	ff d0                	callq  *%rax
  for(p="xv6...\n"; *p; p++)
ffff800000109d3e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000109d43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109d47:	0f b6 00             	movzbl (%rax),%eax
ffff800000109d4a:	84 c0                	test   %al,%al
ffff800000109d4c:	75 d8                	jne    ffff800000109d26 <uartearlyinit+0xdb>
ffff800000109d4e:	eb 01                	jmp    ffff800000109d51 <uartearlyinit+0x106>
    return;
ffff800000109d50:	90                   	nop
}
ffff800000109d51:	c9                   	leaveq 
ffff800000109d52:	c3                   	retq   

ffff800000109d53 <uartinit>:

void
uartinit(void)
{
ffff800000109d53:	f3 0f 1e fa          	endbr64 
ffff800000109d57:	55                   	push   %rbp
ffff800000109d58:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffff800000109d5b:	48 b8 4c ad 11 00 00 	movabs $0xffff80000011ad4c,%rax
ffff800000109d62:	80 ff ff 
ffff800000109d65:	8b 00                	mov    (%rax),%eax
ffff800000109d67:	85 c0                	test   %eax,%eax
ffff800000109d69:	74 3a                	je     ffff800000109da5 <uartinit+0x52>
    return;

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
ffff800000109d6b:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff800000109d70:	48 b8 04 9c 10 00 00 	movabs $0xffff800000109c04,%rax
ffff800000109d77:	80 ff ff 
ffff800000109d7a:	ff d0                	callq  *%rax
  inb(COM1+0);
ffff800000109d7c:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff800000109d81:	48 b8 04 9c 10 00 00 	movabs $0xffff800000109c04,%rax
ffff800000109d88:	80 ff ff 
ffff800000109d8b:	ff d0                	callq  *%rax
  ioapicenable(IRQ_COM1, 0);
ffff800000109d8d:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000109d92:	bf 04 00 00 00       	mov    $0x4,%edi
ffff800000109d97:	48 b8 e5 3f 10 00 00 	movabs $0xffff800000103fe5,%rax
ffff800000109d9e:	80 ff ff 
ffff800000109da1:	ff d0                	callq  *%rax
ffff800000109da3:	eb 01                	jmp    ffff800000109da6 <uartinit+0x53>
    return;
ffff800000109da5:	90                   	nop

}
ffff800000109da6:	5d                   	pop    %rbp
ffff800000109da7:	c3                   	retq   

ffff800000109da8 <uartputc>:
void
uartputc(int c)
{
ffff800000109da8:	f3 0f 1e fa          	endbr64 
ffff800000109dac:	55                   	push   %rbp
ffff800000109dad:	48 89 e5             	mov    %rsp,%rbp
ffff800000109db0:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000109db4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;

  if(!uart)
ffff800000109db7:	48 b8 4c ad 11 00 00 	movabs $0xffff80000011ad4c,%rax
ffff800000109dbe:	80 ff ff 
ffff800000109dc1:	8b 00                	mov    (%rax),%eax
ffff800000109dc3:	85 c0                	test   %eax,%eax
ffff800000109dc5:	74 5a                	je     ffff800000109e21 <uartputc+0x79>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffff800000109dc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000109dce:	eb 15                	jmp    ffff800000109de5 <uartputc+0x3d>
    microdelay(10);
ffff800000109dd0:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff800000109dd5:	48 b8 5d 48 10 00 00 	movabs $0xffff80000010485d,%rax
ffff800000109ddc:	80 ff ff 
ffff800000109ddf:	ff d0                	callq  *%rax
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffff800000109de1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000109de5:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff800000109de9:	7f 1b                	jg     ffff800000109e06 <uartputc+0x5e>
ffff800000109deb:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff800000109df0:	48 b8 04 9c 10 00 00 	movabs $0xffff800000109c04,%rax
ffff800000109df7:	80 ff ff 
ffff800000109dfa:	ff d0                	callq  *%rax
ffff800000109dfc:	0f b6 c0             	movzbl %al,%eax
ffff800000109dff:	83 e0 20             	and    $0x20,%eax
ffff800000109e02:	85 c0                	test   %eax,%eax
ffff800000109e04:	74 ca                	je     ffff800000109dd0 <uartputc+0x28>
  outb(COM1+0, c);
ffff800000109e06:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000109e09:	0f b6 c0             	movzbl %al,%eax
ffff800000109e0c:	89 c6                	mov    %eax,%esi
ffff800000109e0e:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff800000109e13:	48 b8 26 9c 10 00 00 	movabs $0xffff800000109c26,%rax
ffff800000109e1a:	80 ff ff 
ffff800000109e1d:	ff d0                	callq  *%rax
ffff800000109e1f:	eb 01                	jmp    ffff800000109e22 <uartputc+0x7a>
    return;
ffff800000109e21:	90                   	nop
}
ffff800000109e22:	c9                   	leaveq 
ffff800000109e23:	c3                   	retq   

ffff800000109e24 <uartgetc>:

static int
uartgetc(void)
{
ffff800000109e24:	f3 0f 1e fa          	endbr64 
ffff800000109e28:	55                   	push   %rbp
ffff800000109e29:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffff800000109e2c:	48 b8 4c ad 11 00 00 	movabs $0xffff80000011ad4c,%rax
ffff800000109e33:	80 ff ff 
ffff800000109e36:	8b 00                	mov    (%rax),%eax
ffff800000109e38:	85 c0                	test   %eax,%eax
ffff800000109e3a:	75 07                	jne    ffff800000109e43 <uartgetc+0x1f>
    return -1;
ffff800000109e3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109e41:	eb 36                	jmp    ffff800000109e79 <uartgetc+0x55>
  if(!(inb(COM1+5) & 0x01))
ffff800000109e43:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff800000109e48:	48 b8 04 9c 10 00 00 	movabs $0xffff800000109c04,%rax
ffff800000109e4f:	80 ff ff 
ffff800000109e52:	ff d0                	callq  *%rax
ffff800000109e54:	0f b6 c0             	movzbl %al,%eax
ffff800000109e57:	83 e0 01             	and    $0x1,%eax
ffff800000109e5a:	85 c0                	test   %eax,%eax
ffff800000109e5c:	75 07                	jne    ffff800000109e65 <uartgetc+0x41>
    return -1;
ffff800000109e5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109e63:	eb 14                	jmp    ffff800000109e79 <uartgetc+0x55>
  return inb(COM1+0);
ffff800000109e65:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff800000109e6a:	48 b8 04 9c 10 00 00 	movabs $0xffff800000109c04,%rax
ffff800000109e71:	80 ff ff 
ffff800000109e74:	ff d0                	callq  *%rax
ffff800000109e76:	0f b6 c0             	movzbl %al,%eax
}
ffff800000109e79:	5d                   	pop    %rbp
ffff800000109e7a:	c3                   	retq   

ffff800000109e7b <uartintr>:

void
uartintr(void)
{
ffff800000109e7b:	f3 0f 1e fa          	endbr64 
ffff800000109e7f:	55                   	push   %rbp
ffff800000109e80:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(uartgetc);
ffff800000109e83:	48 bf 24 9e 10 00 00 	movabs $0xffff800000109e24,%rdi
ffff800000109e8a:	80 ff ff 
ffff800000109e8d:	48 b8 83 0f 10 00 00 	movabs $0xffff800000100f83,%rax
ffff800000109e94:	80 ff ff 
ffff800000109e97:	ff d0                	callq  *%rax
}
ffff800000109e99:	90                   	nop
ffff800000109e9a:	5d                   	pop    %rbp
ffff800000109e9b:	c3                   	retq   

ffff800000109e9c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.global alltraps
vector0:
  push $0
ffff800000109e9c:	6a 00                	pushq  $0x0
  push $0
ffff800000109e9e:	6a 00                	pushq  $0x0
  jmp alltraps
ffff800000109ea0:	e9 0a f7 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109ea5 <vector1>:
vector1:
  push $0
ffff800000109ea5:	6a 00                	pushq  $0x0
  push $1
ffff800000109ea7:	6a 01                	pushq  $0x1
  jmp alltraps
ffff800000109ea9:	e9 01 f7 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109eae <vector2>:
vector2:
  push $0
ffff800000109eae:	6a 00                	pushq  $0x0
  push $2
ffff800000109eb0:	6a 02                	pushq  $0x2
  jmp alltraps
ffff800000109eb2:	e9 f8 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109eb7 <vector3>:
vector3:
  push $0
ffff800000109eb7:	6a 00                	pushq  $0x0
  push $3
ffff800000109eb9:	6a 03                	pushq  $0x3
  jmp alltraps
ffff800000109ebb:	e9 ef f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109ec0 <vector4>:
vector4:
  push $0
ffff800000109ec0:	6a 00                	pushq  $0x0
  push $4
ffff800000109ec2:	6a 04                	pushq  $0x4
  jmp alltraps
ffff800000109ec4:	e9 e6 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109ec9 <vector5>:
vector5:
  push $0
ffff800000109ec9:	6a 00                	pushq  $0x0
  push $5
ffff800000109ecb:	6a 05                	pushq  $0x5
  jmp alltraps
ffff800000109ecd:	e9 dd f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109ed2 <vector6>:
vector6:
  push $0
ffff800000109ed2:	6a 00                	pushq  $0x0
  push $6
ffff800000109ed4:	6a 06                	pushq  $0x6
  jmp alltraps
ffff800000109ed6:	e9 d4 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109edb <vector7>:
vector7:
  push $0
ffff800000109edb:	6a 00                	pushq  $0x0
  push $7
ffff800000109edd:	6a 07                	pushq  $0x7
  jmp alltraps
ffff800000109edf:	e9 cb f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109ee4 <vector8>:
vector8:
  push $8
ffff800000109ee4:	6a 08                	pushq  $0x8
  jmp alltraps
ffff800000109ee6:	e9 c4 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109eeb <vector9>:
vector9:
  push $0
ffff800000109eeb:	6a 00                	pushq  $0x0
  push $9
ffff800000109eed:	6a 09                	pushq  $0x9
  jmp alltraps
ffff800000109eef:	e9 bb f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109ef4 <vector10>:
vector10:
  push $10
ffff800000109ef4:	6a 0a                	pushq  $0xa
  jmp alltraps
ffff800000109ef6:	e9 b4 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109efb <vector11>:
vector11:
  push $11
ffff800000109efb:	6a 0b                	pushq  $0xb
  jmp alltraps
ffff800000109efd:	e9 ad f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f02 <vector12>:
vector12:
  push $12
ffff800000109f02:	6a 0c                	pushq  $0xc
  jmp alltraps
ffff800000109f04:	e9 a6 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f09 <vector13>:
vector13:
  push $13
ffff800000109f09:	6a 0d                	pushq  $0xd
  jmp alltraps
ffff800000109f0b:	e9 9f f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f10 <vector14>:
vector14:
  push $14
ffff800000109f10:	6a 0e                	pushq  $0xe
  jmp alltraps
ffff800000109f12:	e9 98 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f17 <vector15>:
vector15:
  push $0
ffff800000109f17:	6a 00                	pushq  $0x0
  push $15
ffff800000109f19:	6a 0f                	pushq  $0xf
  jmp alltraps
ffff800000109f1b:	e9 8f f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f20 <vector16>:
vector16:
  push $0
ffff800000109f20:	6a 00                	pushq  $0x0
  push $16
ffff800000109f22:	6a 10                	pushq  $0x10
  jmp alltraps
ffff800000109f24:	e9 86 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f29 <vector17>:
vector17:
  push $17
ffff800000109f29:	6a 11                	pushq  $0x11
  jmp alltraps
ffff800000109f2b:	e9 7f f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f30 <vector18>:
vector18:
  push $0
ffff800000109f30:	6a 00                	pushq  $0x0
  push $18
ffff800000109f32:	6a 12                	pushq  $0x12
  jmp alltraps
ffff800000109f34:	e9 76 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f39 <vector19>:
vector19:
  push $0
ffff800000109f39:	6a 00                	pushq  $0x0
  push $19
ffff800000109f3b:	6a 13                	pushq  $0x13
  jmp alltraps
ffff800000109f3d:	e9 6d f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f42 <vector20>:
vector20:
  push $0
ffff800000109f42:	6a 00                	pushq  $0x0
  push $20
ffff800000109f44:	6a 14                	pushq  $0x14
  jmp alltraps
ffff800000109f46:	e9 64 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f4b <vector21>:
vector21:
  push $0
ffff800000109f4b:	6a 00                	pushq  $0x0
  push $21
ffff800000109f4d:	6a 15                	pushq  $0x15
  jmp alltraps
ffff800000109f4f:	e9 5b f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f54 <vector22>:
vector22:
  push $0
ffff800000109f54:	6a 00                	pushq  $0x0
  push $22
ffff800000109f56:	6a 16                	pushq  $0x16
  jmp alltraps
ffff800000109f58:	e9 52 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f5d <vector23>:
vector23:
  push $0
ffff800000109f5d:	6a 00                	pushq  $0x0
  push $23
ffff800000109f5f:	6a 17                	pushq  $0x17
  jmp alltraps
ffff800000109f61:	e9 49 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f66 <vector24>:
vector24:
  push $0
ffff800000109f66:	6a 00                	pushq  $0x0
  push $24
ffff800000109f68:	6a 18                	pushq  $0x18
  jmp alltraps
ffff800000109f6a:	e9 40 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f6f <vector25>:
vector25:
  push $0
ffff800000109f6f:	6a 00                	pushq  $0x0
  push $25
ffff800000109f71:	6a 19                	pushq  $0x19
  jmp alltraps
ffff800000109f73:	e9 37 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f78 <vector26>:
vector26:
  push $0
ffff800000109f78:	6a 00                	pushq  $0x0
  push $26
ffff800000109f7a:	6a 1a                	pushq  $0x1a
  jmp alltraps
ffff800000109f7c:	e9 2e f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f81 <vector27>:
vector27:
  push $0
ffff800000109f81:	6a 00                	pushq  $0x0
  push $27
ffff800000109f83:	6a 1b                	pushq  $0x1b
  jmp alltraps
ffff800000109f85:	e9 25 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f8a <vector28>:
vector28:
  push $0
ffff800000109f8a:	6a 00                	pushq  $0x0
  push $28
ffff800000109f8c:	6a 1c                	pushq  $0x1c
  jmp alltraps
ffff800000109f8e:	e9 1c f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f93 <vector29>:
vector29:
  push $0
ffff800000109f93:	6a 00                	pushq  $0x0
  push $29
ffff800000109f95:	6a 1d                	pushq  $0x1d
  jmp alltraps
ffff800000109f97:	e9 13 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109f9c <vector30>:
vector30:
  push $0
ffff800000109f9c:	6a 00                	pushq  $0x0
  push $30
ffff800000109f9e:	6a 1e                	pushq  $0x1e
  jmp alltraps
ffff800000109fa0:	e9 0a f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109fa5 <vector31>:
vector31:
  push $0
ffff800000109fa5:	6a 00                	pushq  $0x0
  push $31
ffff800000109fa7:	6a 1f                	pushq  $0x1f
  jmp alltraps
ffff800000109fa9:	e9 01 f6 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109fae <vector32>:
vector32:
  push $0
ffff800000109fae:	6a 00                	pushq  $0x0
  push $32
ffff800000109fb0:	6a 20                	pushq  $0x20
  jmp alltraps
ffff800000109fb2:	e9 f8 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109fb7 <vector33>:
vector33:
  push $0
ffff800000109fb7:	6a 00                	pushq  $0x0
  push $33
ffff800000109fb9:	6a 21                	pushq  $0x21
  jmp alltraps
ffff800000109fbb:	e9 ef f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109fc0 <vector34>:
vector34:
  push $0
ffff800000109fc0:	6a 00                	pushq  $0x0
  push $34
ffff800000109fc2:	6a 22                	pushq  $0x22
  jmp alltraps
ffff800000109fc4:	e9 e6 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109fc9 <vector35>:
vector35:
  push $0
ffff800000109fc9:	6a 00                	pushq  $0x0
  push $35
ffff800000109fcb:	6a 23                	pushq  $0x23
  jmp alltraps
ffff800000109fcd:	e9 dd f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109fd2 <vector36>:
vector36:
  push $0
ffff800000109fd2:	6a 00                	pushq  $0x0
  push $36
ffff800000109fd4:	6a 24                	pushq  $0x24
  jmp alltraps
ffff800000109fd6:	e9 d4 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109fdb <vector37>:
vector37:
  push $0
ffff800000109fdb:	6a 00                	pushq  $0x0
  push $37
ffff800000109fdd:	6a 25                	pushq  $0x25
  jmp alltraps
ffff800000109fdf:	e9 cb f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109fe4 <vector38>:
vector38:
  push $0
ffff800000109fe4:	6a 00                	pushq  $0x0
  push $38
ffff800000109fe6:	6a 26                	pushq  $0x26
  jmp alltraps
ffff800000109fe8:	e9 c2 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109fed <vector39>:
vector39:
  push $0
ffff800000109fed:	6a 00                	pushq  $0x0
  push $39
ffff800000109fef:	6a 27                	pushq  $0x27
  jmp alltraps
ffff800000109ff1:	e9 b9 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109ff6 <vector40>:
vector40:
  push $0
ffff800000109ff6:	6a 00                	pushq  $0x0
  push $40
ffff800000109ff8:	6a 28                	pushq  $0x28
  jmp alltraps
ffff800000109ffa:	e9 b0 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff800000109fff <vector41>:
vector41:
  push $0
ffff800000109fff:	6a 00                	pushq  $0x0
  push $41
ffff80000010a001:	6a 29                	pushq  $0x29
  jmp alltraps
ffff80000010a003:	e9 a7 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a008 <vector42>:
vector42:
  push $0
ffff80000010a008:	6a 00                	pushq  $0x0
  push $42
ffff80000010a00a:	6a 2a                	pushq  $0x2a
  jmp alltraps
ffff80000010a00c:	e9 9e f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a011 <vector43>:
vector43:
  push $0
ffff80000010a011:	6a 00                	pushq  $0x0
  push $43
ffff80000010a013:	6a 2b                	pushq  $0x2b
  jmp alltraps
ffff80000010a015:	e9 95 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a01a <vector44>:
vector44:
  push $0
ffff80000010a01a:	6a 00                	pushq  $0x0
  push $44
ffff80000010a01c:	6a 2c                	pushq  $0x2c
  jmp alltraps
ffff80000010a01e:	e9 8c f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a023 <vector45>:
vector45:
  push $0
ffff80000010a023:	6a 00                	pushq  $0x0
  push $45
ffff80000010a025:	6a 2d                	pushq  $0x2d
  jmp alltraps
ffff80000010a027:	e9 83 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a02c <vector46>:
vector46:
  push $0
ffff80000010a02c:	6a 00                	pushq  $0x0
  push $46
ffff80000010a02e:	6a 2e                	pushq  $0x2e
  jmp alltraps
ffff80000010a030:	e9 7a f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a035 <vector47>:
vector47:
  push $0
ffff80000010a035:	6a 00                	pushq  $0x0
  push $47
ffff80000010a037:	6a 2f                	pushq  $0x2f
  jmp alltraps
ffff80000010a039:	e9 71 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a03e <vector48>:
vector48:
  push $0
ffff80000010a03e:	6a 00                	pushq  $0x0
  push $48
ffff80000010a040:	6a 30                	pushq  $0x30
  jmp alltraps
ffff80000010a042:	e9 68 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a047 <vector49>:
vector49:
  push $0
ffff80000010a047:	6a 00                	pushq  $0x0
  push $49
ffff80000010a049:	6a 31                	pushq  $0x31
  jmp alltraps
ffff80000010a04b:	e9 5f f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a050 <vector50>:
vector50:
  push $0
ffff80000010a050:	6a 00                	pushq  $0x0
  push $50
ffff80000010a052:	6a 32                	pushq  $0x32
  jmp alltraps
ffff80000010a054:	e9 56 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a059 <vector51>:
vector51:
  push $0
ffff80000010a059:	6a 00                	pushq  $0x0
  push $51
ffff80000010a05b:	6a 33                	pushq  $0x33
  jmp alltraps
ffff80000010a05d:	e9 4d f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a062 <vector52>:
vector52:
  push $0
ffff80000010a062:	6a 00                	pushq  $0x0
  push $52
ffff80000010a064:	6a 34                	pushq  $0x34
  jmp alltraps
ffff80000010a066:	e9 44 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a06b <vector53>:
vector53:
  push $0
ffff80000010a06b:	6a 00                	pushq  $0x0
  push $53
ffff80000010a06d:	6a 35                	pushq  $0x35
  jmp alltraps
ffff80000010a06f:	e9 3b f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a074 <vector54>:
vector54:
  push $0
ffff80000010a074:	6a 00                	pushq  $0x0
  push $54
ffff80000010a076:	6a 36                	pushq  $0x36
  jmp alltraps
ffff80000010a078:	e9 32 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a07d <vector55>:
vector55:
  push $0
ffff80000010a07d:	6a 00                	pushq  $0x0
  push $55
ffff80000010a07f:	6a 37                	pushq  $0x37
  jmp alltraps
ffff80000010a081:	e9 29 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a086 <vector56>:
vector56:
  push $0
ffff80000010a086:	6a 00                	pushq  $0x0
  push $56
ffff80000010a088:	6a 38                	pushq  $0x38
  jmp alltraps
ffff80000010a08a:	e9 20 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a08f <vector57>:
vector57:
  push $0
ffff80000010a08f:	6a 00                	pushq  $0x0
  push $57
ffff80000010a091:	6a 39                	pushq  $0x39
  jmp alltraps
ffff80000010a093:	e9 17 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a098 <vector58>:
vector58:
  push $0
ffff80000010a098:	6a 00                	pushq  $0x0
  push $58
ffff80000010a09a:	6a 3a                	pushq  $0x3a
  jmp alltraps
ffff80000010a09c:	e9 0e f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0a1 <vector59>:
vector59:
  push $0
ffff80000010a0a1:	6a 00                	pushq  $0x0
  push $59
ffff80000010a0a3:	6a 3b                	pushq  $0x3b
  jmp alltraps
ffff80000010a0a5:	e9 05 f5 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0aa <vector60>:
vector60:
  push $0
ffff80000010a0aa:	6a 00                	pushq  $0x0
  push $60
ffff80000010a0ac:	6a 3c                	pushq  $0x3c
  jmp alltraps
ffff80000010a0ae:	e9 fc f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0b3 <vector61>:
vector61:
  push $0
ffff80000010a0b3:	6a 00                	pushq  $0x0
  push $61
ffff80000010a0b5:	6a 3d                	pushq  $0x3d
  jmp alltraps
ffff80000010a0b7:	e9 f3 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0bc <vector62>:
vector62:
  push $0
ffff80000010a0bc:	6a 00                	pushq  $0x0
  push $62
ffff80000010a0be:	6a 3e                	pushq  $0x3e
  jmp alltraps
ffff80000010a0c0:	e9 ea f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0c5 <vector63>:
vector63:
  push $0
ffff80000010a0c5:	6a 00                	pushq  $0x0
  push $63
ffff80000010a0c7:	6a 3f                	pushq  $0x3f
  jmp alltraps
ffff80000010a0c9:	e9 e1 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0ce <vector64>:
vector64:
  push $0
ffff80000010a0ce:	6a 00                	pushq  $0x0
  push $64
ffff80000010a0d0:	6a 40                	pushq  $0x40
  jmp alltraps
ffff80000010a0d2:	e9 d8 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0d7 <vector65>:
vector65:
  push $0
ffff80000010a0d7:	6a 00                	pushq  $0x0
  push $65
ffff80000010a0d9:	6a 41                	pushq  $0x41
  jmp alltraps
ffff80000010a0db:	e9 cf f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0e0 <vector66>:
vector66:
  push $0
ffff80000010a0e0:	6a 00                	pushq  $0x0
  push $66
ffff80000010a0e2:	6a 42                	pushq  $0x42
  jmp alltraps
ffff80000010a0e4:	e9 c6 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0e9 <vector67>:
vector67:
  push $0
ffff80000010a0e9:	6a 00                	pushq  $0x0
  push $67
ffff80000010a0eb:	6a 43                	pushq  $0x43
  jmp alltraps
ffff80000010a0ed:	e9 bd f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0f2 <vector68>:
vector68:
  push $0
ffff80000010a0f2:	6a 00                	pushq  $0x0
  push $68
ffff80000010a0f4:	6a 44                	pushq  $0x44
  jmp alltraps
ffff80000010a0f6:	e9 b4 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a0fb <vector69>:
vector69:
  push $0
ffff80000010a0fb:	6a 00                	pushq  $0x0
  push $69
ffff80000010a0fd:	6a 45                	pushq  $0x45
  jmp alltraps
ffff80000010a0ff:	e9 ab f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a104 <vector70>:
vector70:
  push $0
ffff80000010a104:	6a 00                	pushq  $0x0
  push $70
ffff80000010a106:	6a 46                	pushq  $0x46
  jmp alltraps
ffff80000010a108:	e9 a2 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a10d <vector71>:
vector71:
  push $0
ffff80000010a10d:	6a 00                	pushq  $0x0
  push $71
ffff80000010a10f:	6a 47                	pushq  $0x47
  jmp alltraps
ffff80000010a111:	e9 99 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a116 <vector72>:
vector72:
  push $0
ffff80000010a116:	6a 00                	pushq  $0x0
  push $72
ffff80000010a118:	6a 48                	pushq  $0x48
  jmp alltraps
ffff80000010a11a:	e9 90 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a11f <vector73>:
vector73:
  push $0
ffff80000010a11f:	6a 00                	pushq  $0x0
  push $73
ffff80000010a121:	6a 49                	pushq  $0x49
  jmp alltraps
ffff80000010a123:	e9 87 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a128 <vector74>:
vector74:
  push $0
ffff80000010a128:	6a 00                	pushq  $0x0
  push $74
ffff80000010a12a:	6a 4a                	pushq  $0x4a
  jmp alltraps
ffff80000010a12c:	e9 7e f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a131 <vector75>:
vector75:
  push $0
ffff80000010a131:	6a 00                	pushq  $0x0
  push $75
ffff80000010a133:	6a 4b                	pushq  $0x4b
  jmp alltraps
ffff80000010a135:	e9 75 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a13a <vector76>:
vector76:
  push $0
ffff80000010a13a:	6a 00                	pushq  $0x0
  push $76
ffff80000010a13c:	6a 4c                	pushq  $0x4c
  jmp alltraps
ffff80000010a13e:	e9 6c f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a143 <vector77>:
vector77:
  push $0
ffff80000010a143:	6a 00                	pushq  $0x0
  push $77
ffff80000010a145:	6a 4d                	pushq  $0x4d
  jmp alltraps
ffff80000010a147:	e9 63 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a14c <vector78>:
vector78:
  push $0
ffff80000010a14c:	6a 00                	pushq  $0x0
  push $78
ffff80000010a14e:	6a 4e                	pushq  $0x4e
  jmp alltraps
ffff80000010a150:	e9 5a f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a155 <vector79>:
vector79:
  push $0
ffff80000010a155:	6a 00                	pushq  $0x0
  push $79
ffff80000010a157:	6a 4f                	pushq  $0x4f
  jmp alltraps
ffff80000010a159:	e9 51 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a15e <vector80>:
vector80:
  push $0
ffff80000010a15e:	6a 00                	pushq  $0x0
  push $80
ffff80000010a160:	6a 50                	pushq  $0x50
  jmp alltraps
ffff80000010a162:	e9 48 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a167 <vector81>:
vector81:
  push $0
ffff80000010a167:	6a 00                	pushq  $0x0
  push $81
ffff80000010a169:	6a 51                	pushq  $0x51
  jmp alltraps
ffff80000010a16b:	e9 3f f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a170 <vector82>:
vector82:
  push $0
ffff80000010a170:	6a 00                	pushq  $0x0
  push $82
ffff80000010a172:	6a 52                	pushq  $0x52
  jmp alltraps
ffff80000010a174:	e9 36 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a179 <vector83>:
vector83:
  push $0
ffff80000010a179:	6a 00                	pushq  $0x0
  push $83
ffff80000010a17b:	6a 53                	pushq  $0x53
  jmp alltraps
ffff80000010a17d:	e9 2d f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a182 <vector84>:
vector84:
  push $0
ffff80000010a182:	6a 00                	pushq  $0x0
  push $84
ffff80000010a184:	6a 54                	pushq  $0x54
  jmp alltraps
ffff80000010a186:	e9 24 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a18b <vector85>:
vector85:
  push $0
ffff80000010a18b:	6a 00                	pushq  $0x0
  push $85
ffff80000010a18d:	6a 55                	pushq  $0x55
  jmp alltraps
ffff80000010a18f:	e9 1b f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a194 <vector86>:
vector86:
  push $0
ffff80000010a194:	6a 00                	pushq  $0x0
  push $86
ffff80000010a196:	6a 56                	pushq  $0x56
  jmp alltraps
ffff80000010a198:	e9 12 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a19d <vector87>:
vector87:
  push $0
ffff80000010a19d:	6a 00                	pushq  $0x0
  push $87
ffff80000010a19f:	6a 57                	pushq  $0x57
  jmp alltraps
ffff80000010a1a1:	e9 09 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a1a6 <vector88>:
vector88:
  push $0
ffff80000010a1a6:	6a 00                	pushq  $0x0
  push $88
ffff80000010a1a8:	6a 58                	pushq  $0x58
  jmp alltraps
ffff80000010a1aa:	e9 00 f4 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a1af <vector89>:
vector89:
  push $0
ffff80000010a1af:	6a 00                	pushq  $0x0
  push $89
ffff80000010a1b1:	6a 59                	pushq  $0x59
  jmp alltraps
ffff80000010a1b3:	e9 f7 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a1b8 <vector90>:
vector90:
  push $0
ffff80000010a1b8:	6a 00                	pushq  $0x0
  push $90
ffff80000010a1ba:	6a 5a                	pushq  $0x5a
  jmp alltraps
ffff80000010a1bc:	e9 ee f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a1c1 <vector91>:
vector91:
  push $0
ffff80000010a1c1:	6a 00                	pushq  $0x0
  push $91
ffff80000010a1c3:	6a 5b                	pushq  $0x5b
  jmp alltraps
ffff80000010a1c5:	e9 e5 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a1ca <vector92>:
vector92:
  push $0
ffff80000010a1ca:	6a 00                	pushq  $0x0
  push $92
ffff80000010a1cc:	6a 5c                	pushq  $0x5c
  jmp alltraps
ffff80000010a1ce:	e9 dc f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a1d3 <vector93>:
vector93:
  push $0
ffff80000010a1d3:	6a 00                	pushq  $0x0
  push $93
ffff80000010a1d5:	6a 5d                	pushq  $0x5d
  jmp alltraps
ffff80000010a1d7:	e9 d3 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a1dc <vector94>:
vector94:
  push $0
ffff80000010a1dc:	6a 00                	pushq  $0x0
  push $94
ffff80000010a1de:	6a 5e                	pushq  $0x5e
  jmp alltraps
ffff80000010a1e0:	e9 ca f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a1e5 <vector95>:
vector95:
  push $0
ffff80000010a1e5:	6a 00                	pushq  $0x0
  push $95
ffff80000010a1e7:	6a 5f                	pushq  $0x5f
  jmp alltraps
ffff80000010a1e9:	e9 c1 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a1ee <vector96>:
vector96:
  push $0
ffff80000010a1ee:	6a 00                	pushq  $0x0
  push $96
ffff80000010a1f0:	6a 60                	pushq  $0x60
  jmp alltraps
ffff80000010a1f2:	e9 b8 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a1f7 <vector97>:
vector97:
  push $0
ffff80000010a1f7:	6a 00                	pushq  $0x0
  push $97
ffff80000010a1f9:	6a 61                	pushq  $0x61
  jmp alltraps
ffff80000010a1fb:	e9 af f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a200 <vector98>:
vector98:
  push $0
ffff80000010a200:	6a 00                	pushq  $0x0
  push $98
ffff80000010a202:	6a 62                	pushq  $0x62
  jmp alltraps
ffff80000010a204:	e9 a6 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a209 <vector99>:
vector99:
  push $0
ffff80000010a209:	6a 00                	pushq  $0x0
  push $99
ffff80000010a20b:	6a 63                	pushq  $0x63
  jmp alltraps
ffff80000010a20d:	e9 9d f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a212 <vector100>:
vector100:
  push $0
ffff80000010a212:	6a 00                	pushq  $0x0
  push $100
ffff80000010a214:	6a 64                	pushq  $0x64
  jmp alltraps
ffff80000010a216:	e9 94 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a21b <vector101>:
vector101:
  push $0
ffff80000010a21b:	6a 00                	pushq  $0x0
  push $101
ffff80000010a21d:	6a 65                	pushq  $0x65
  jmp alltraps
ffff80000010a21f:	e9 8b f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a224 <vector102>:
vector102:
  push $0
ffff80000010a224:	6a 00                	pushq  $0x0
  push $102
ffff80000010a226:	6a 66                	pushq  $0x66
  jmp alltraps
ffff80000010a228:	e9 82 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a22d <vector103>:
vector103:
  push $0
ffff80000010a22d:	6a 00                	pushq  $0x0
  push $103
ffff80000010a22f:	6a 67                	pushq  $0x67
  jmp alltraps
ffff80000010a231:	e9 79 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a236 <vector104>:
vector104:
  push $0
ffff80000010a236:	6a 00                	pushq  $0x0
  push $104
ffff80000010a238:	6a 68                	pushq  $0x68
  jmp alltraps
ffff80000010a23a:	e9 70 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a23f <vector105>:
vector105:
  push $0
ffff80000010a23f:	6a 00                	pushq  $0x0
  push $105
ffff80000010a241:	6a 69                	pushq  $0x69
  jmp alltraps
ffff80000010a243:	e9 67 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a248 <vector106>:
vector106:
  push $0
ffff80000010a248:	6a 00                	pushq  $0x0
  push $106
ffff80000010a24a:	6a 6a                	pushq  $0x6a
  jmp alltraps
ffff80000010a24c:	e9 5e f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a251 <vector107>:
vector107:
  push $0
ffff80000010a251:	6a 00                	pushq  $0x0
  push $107
ffff80000010a253:	6a 6b                	pushq  $0x6b
  jmp alltraps
ffff80000010a255:	e9 55 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a25a <vector108>:
vector108:
  push $0
ffff80000010a25a:	6a 00                	pushq  $0x0
  push $108
ffff80000010a25c:	6a 6c                	pushq  $0x6c
  jmp alltraps
ffff80000010a25e:	e9 4c f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a263 <vector109>:
vector109:
  push $0
ffff80000010a263:	6a 00                	pushq  $0x0
  push $109
ffff80000010a265:	6a 6d                	pushq  $0x6d
  jmp alltraps
ffff80000010a267:	e9 43 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a26c <vector110>:
vector110:
  push $0
ffff80000010a26c:	6a 00                	pushq  $0x0
  push $110
ffff80000010a26e:	6a 6e                	pushq  $0x6e
  jmp alltraps
ffff80000010a270:	e9 3a f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a275 <vector111>:
vector111:
  push $0
ffff80000010a275:	6a 00                	pushq  $0x0
  push $111
ffff80000010a277:	6a 6f                	pushq  $0x6f
  jmp alltraps
ffff80000010a279:	e9 31 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a27e <vector112>:
vector112:
  push $0
ffff80000010a27e:	6a 00                	pushq  $0x0
  push $112
ffff80000010a280:	6a 70                	pushq  $0x70
  jmp alltraps
ffff80000010a282:	e9 28 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a287 <vector113>:
vector113:
  push $0
ffff80000010a287:	6a 00                	pushq  $0x0
  push $113
ffff80000010a289:	6a 71                	pushq  $0x71
  jmp alltraps
ffff80000010a28b:	e9 1f f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a290 <vector114>:
vector114:
  push $0
ffff80000010a290:	6a 00                	pushq  $0x0
  push $114
ffff80000010a292:	6a 72                	pushq  $0x72
  jmp alltraps
ffff80000010a294:	e9 16 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a299 <vector115>:
vector115:
  push $0
ffff80000010a299:	6a 00                	pushq  $0x0
  push $115
ffff80000010a29b:	6a 73                	pushq  $0x73
  jmp alltraps
ffff80000010a29d:	e9 0d f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2a2 <vector116>:
vector116:
  push $0
ffff80000010a2a2:	6a 00                	pushq  $0x0
  push $116
ffff80000010a2a4:	6a 74                	pushq  $0x74
  jmp alltraps
ffff80000010a2a6:	e9 04 f3 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2ab <vector117>:
vector117:
  push $0
ffff80000010a2ab:	6a 00                	pushq  $0x0
  push $117
ffff80000010a2ad:	6a 75                	pushq  $0x75
  jmp alltraps
ffff80000010a2af:	e9 fb f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2b4 <vector118>:
vector118:
  push $0
ffff80000010a2b4:	6a 00                	pushq  $0x0
  push $118
ffff80000010a2b6:	6a 76                	pushq  $0x76
  jmp alltraps
ffff80000010a2b8:	e9 f2 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2bd <vector119>:
vector119:
  push $0
ffff80000010a2bd:	6a 00                	pushq  $0x0
  push $119
ffff80000010a2bf:	6a 77                	pushq  $0x77
  jmp alltraps
ffff80000010a2c1:	e9 e9 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2c6 <vector120>:
vector120:
  push $0
ffff80000010a2c6:	6a 00                	pushq  $0x0
  push $120
ffff80000010a2c8:	6a 78                	pushq  $0x78
  jmp alltraps
ffff80000010a2ca:	e9 e0 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2cf <vector121>:
vector121:
  push $0
ffff80000010a2cf:	6a 00                	pushq  $0x0
  push $121
ffff80000010a2d1:	6a 79                	pushq  $0x79
  jmp alltraps
ffff80000010a2d3:	e9 d7 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2d8 <vector122>:
vector122:
  push $0
ffff80000010a2d8:	6a 00                	pushq  $0x0
  push $122
ffff80000010a2da:	6a 7a                	pushq  $0x7a
  jmp alltraps
ffff80000010a2dc:	e9 ce f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2e1 <vector123>:
vector123:
  push $0
ffff80000010a2e1:	6a 00                	pushq  $0x0
  push $123
ffff80000010a2e3:	6a 7b                	pushq  $0x7b
  jmp alltraps
ffff80000010a2e5:	e9 c5 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2ea <vector124>:
vector124:
  push $0
ffff80000010a2ea:	6a 00                	pushq  $0x0
  push $124
ffff80000010a2ec:	6a 7c                	pushq  $0x7c
  jmp alltraps
ffff80000010a2ee:	e9 bc f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2f3 <vector125>:
vector125:
  push $0
ffff80000010a2f3:	6a 00                	pushq  $0x0
  push $125
ffff80000010a2f5:	6a 7d                	pushq  $0x7d
  jmp alltraps
ffff80000010a2f7:	e9 b3 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a2fc <vector126>:
vector126:
  push $0
ffff80000010a2fc:	6a 00                	pushq  $0x0
  push $126
ffff80000010a2fe:	6a 7e                	pushq  $0x7e
  jmp alltraps
ffff80000010a300:	e9 aa f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a305 <vector127>:
vector127:
  push $0
ffff80000010a305:	6a 00                	pushq  $0x0
  push $127
ffff80000010a307:	6a 7f                	pushq  $0x7f
  jmp alltraps
ffff80000010a309:	e9 a1 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a30e <vector128>:
vector128:
  push $0
ffff80000010a30e:	6a 00                	pushq  $0x0
  push $128
ffff80000010a310:	68 80 00 00 00       	pushq  $0x80
  jmp alltraps
ffff80000010a315:	e9 95 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a31a <vector129>:
vector129:
  push $0
ffff80000010a31a:	6a 00                	pushq  $0x0
  push $129
ffff80000010a31c:	68 81 00 00 00       	pushq  $0x81
  jmp alltraps
ffff80000010a321:	e9 89 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a326 <vector130>:
vector130:
  push $0
ffff80000010a326:	6a 00                	pushq  $0x0
  push $130
ffff80000010a328:	68 82 00 00 00       	pushq  $0x82
  jmp alltraps
ffff80000010a32d:	e9 7d f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a332 <vector131>:
vector131:
  push $0
ffff80000010a332:	6a 00                	pushq  $0x0
  push $131
ffff80000010a334:	68 83 00 00 00       	pushq  $0x83
  jmp alltraps
ffff80000010a339:	e9 71 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a33e <vector132>:
vector132:
  push $0
ffff80000010a33e:	6a 00                	pushq  $0x0
  push $132
ffff80000010a340:	68 84 00 00 00       	pushq  $0x84
  jmp alltraps
ffff80000010a345:	e9 65 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a34a <vector133>:
vector133:
  push $0
ffff80000010a34a:	6a 00                	pushq  $0x0
  push $133
ffff80000010a34c:	68 85 00 00 00       	pushq  $0x85
  jmp alltraps
ffff80000010a351:	e9 59 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a356 <vector134>:
vector134:
  push $0
ffff80000010a356:	6a 00                	pushq  $0x0
  push $134
ffff80000010a358:	68 86 00 00 00       	pushq  $0x86
  jmp alltraps
ffff80000010a35d:	e9 4d f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a362 <vector135>:
vector135:
  push $0
ffff80000010a362:	6a 00                	pushq  $0x0
  push $135
ffff80000010a364:	68 87 00 00 00       	pushq  $0x87
  jmp alltraps
ffff80000010a369:	e9 41 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a36e <vector136>:
vector136:
  push $0
ffff80000010a36e:	6a 00                	pushq  $0x0
  push $136
ffff80000010a370:	68 88 00 00 00       	pushq  $0x88
  jmp alltraps
ffff80000010a375:	e9 35 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a37a <vector137>:
vector137:
  push $0
ffff80000010a37a:	6a 00                	pushq  $0x0
  push $137
ffff80000010a37c:	68 89 00 00 00       	pushq  $0x89
  jmp alltraps
ffff80000010a381:	e9 29 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a386 <vector138>:
vector138:
  push $0
ffff80000010a386:	6a 00                	pushq  $0x0
  push $138
ffff80000010a388:	68 8a 00 00 00       	pushq  $0x8a
  jmp alltraps
ffff80000010a38d:	e9 1d f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a392 <vector139>:
vector139:
  push $0
ffff80000010a392:	6a 00                	pushq  $0x0
  push $139
ffff80000010a394:	68 8b 00 00 00       	pushq  $0x8b
  jmp alltraps
ffff80000010a399:	e9 11 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a39e <vector140>:
vector140:
  push $0
ffff80000010a39e:	6a 00                	pushq  $0x0
  push $140
ffff80000010a3a0:	68 8c 00 00 00       	pushq  $0x8c
  jmp alltraps
ffff80000010a3a5:	e9 05 f2 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a3aa <vector141>:
vector141:
  push $0
ffff80000010a3aa:	6a 00                	pushq  $0x0
  push $141
ffff80000010a3ac:	68 8d 00 00 00       	pushq  $0x8d
  jmp alltraps
ffff80000010a3b1:	e9 f9 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a3b6 <vector142>:
vector142:
  push $0
ffff80000010a3b6:	6a 00                	pushq  $0x0
  push $142
ffff80000010a3b8:	68 8e 00 00 00       	pushq  $0x8e
  jmp alltraps
ffff80000010a3bd:	e9 ed f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a3c2 <vector143>:
vector143:
  push $0
ffff80000010a3c2:	6a 00                	pushq  $0x0
  push $143
ffff80000010a3c4:	68 8f 00 00 00       	pushq  $0x8f
  jmp alltraps
ffff80000010a3c9:	e9 e1 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a3ce <vector144>:
vector144:
  push $0
ffff80000010a3ce:	6a 00                	pushq  $0x0
  push $144
ffff80000010a3d0:	68 90 00 00 00       	pushq  $0x90
  jmp alltraps
ffff80000010a3d5:	e9 d5 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a3da <vector145>:
vector145:
  push $0
ffff80000010a3da:	6a 00                	pushq  $0x0
  push $145
ffff80000010a3dc:	68 91 00 00 00       	pushq  $0x91
  jmp alltraps
ffff80000010a3e1:	e9 c9 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a3e6 <vector146>:
vector146:
  push $0
ffff80000010a3e6:	6a 00                	pushq  $0x0
  push $146
ffff80000010a3e8:	68 92 00 00 00       	pushq  $0x92
  jmp alltraps
ffff80000010a3ed:	e9 bd f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a3f2 <vector147>:
vector147:
  push $0
ffff80000010a3f2:	6a 00                	pushq  $0x0
  push $147
ffff80000010a3f4:	68 93 00 00 00       	pushq  $0x93
  jmp alltraps
ffff80000010a3f9:	e9 b1 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a3fe <vector148>:
vector148:
  push $0
ffff80000010a3fe:	6a 00                	pushq  $0x0
  push $148
ffff80000010a400:	68 94 00 00 00       	pushq  $0x94
  jmp alltraps
ffff80000010a405:	e9 a5 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a40a <vector149>:
vector149:
  push $0
ffff80000010a40a:	6a 00                	pushq  $0x0
  push $149
ffff80000010a40c:	68 95 00 00 00       	pushq  $0x95
  jmp alltraps
ffff80000010a411:	e9 99 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a416 <vector150>:
vector150:
  push $0
ffff80000010a416:	6a 00                	pushq  $0x0
  push $150
ffff80000010a418:	68 96 00 00 00       	pushq  $0x96
  jmp alltraps
ffff80000010a41d:	e9 8d f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a422 <vector151>:
vector151:
  push $0
ffff80000010a422:	6a 00                	pushq  $0x0
  push $151
ffff80000010a424:	68 97 00 00 00       	pushq  $0x97
  jmp alltraps
ffff80000010a429:	e9 81 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a42e <vector152>:
vector152:
  push $0
ffff80000010a42e:	6a 00                	pushq  $0x0
  push $152
ffff80000010a430:	68 98 00 00 00       	pushq  $0x98
  jmp alltraps
ffff80000010a435:	e9 75 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a43a <vector153>:
vector153:
  push $0
ffff80000010a43a:	6a 00                	pushq  $0x0
  push $153
ffff80000010a43c:	68 99 00 00 00       	pushq  $0x99
  jmp alltraps
ffff80000010a441:	e9 69 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a446 <vector154>:
vector154:
  push $0
ffff80000010a446:	6a 00                	pushq  $0x0
  push $154
ffff80000010a448:	68 9a 00 00 00       	pushq  $0x9a
  jmp alltraps
ffff80000010a44d:	e9 5d f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a452 <vector155>:
vector155:
  push $0
ffff80000010a452:	6a 00                	pushq  $0x0
  push $155
ffff80000010a454:	68 9b 00 00 00       	pushq  $0x9b
  jmp alltraps
ffff80000010a459:	e9 51 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a45e <vector156>:
vector156:
  push $0
ffff80000010a45e:	6a 00                	pushq  $0x0
  push $156
ffff80000010a460:	68 9c 00 00 00       	pushq  $0x9c
  jmp alltraps
ffff80000010a465:	e9 45 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a46a <vector157>:
vector157:
  push $0
ffff80000010a46a:	6a 00                	pushq  $0x0
  push $157
ffff80000010a46c:	68 9d 00 00 00       	pushq  $0x9d
  jmp alltraps
ffff80000010a471:	e9 39 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a476 <vector158>:
vector158:
  push $0
ffff80000010a476:	6a 00                	pushq  $0x0
  push $158
ffff80000010a478:	68 9e 00 00 00       	pushq  $0x9e
  jmp alltraps
ffff80000010a47d:	e9 2d f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a482 <vector159>:
vector159:
  push $0
ffff80000010a482:	6a 00                	pushq  $0x0
  push $159
ffff80000010a484:	68 9f 00 00 00       	pushq  $0x9f
  jmp alltraps
ffff80000010a489:	e9 21 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a48e <vector160>:
vector160:
  push $0
ffff80000010a48e:	6a 00                	pushq  $0x0
  push $160
ffff80000010a490:	68 a0 00 00 00       	pushq  $0xa0
  jmp alltraps
ffff80000010a495:	e9 15 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a49a <vector161>:
vector161:
  push $0
ffff80000010a49a:	6a 00                	pushq  $0x0
  push $161
ffff80000010a49c:	68 a1 00 00 00       	pushq  $0xa1
  jmp alltraps
ffff80000010a4a1:	e9 09 f1 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a4a6 <vector162>:
vector162:
  push $0
ffff80000010a4a6:	6a 00                	pushq  $0x0
  push $162
ffff80000010a4a8:	68 a2 00 00 00       	pushq  $0xa2
  jmp alltraps
ffff80000010a4ad:	e9 fd f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a4b2 <vector163>:
vector163:
  push $0
ffff80000010a4b2:	6a 00                	pushq  $0x0
  push $163
ffff80000010a4b4:	68 a3 00 00 00       	pushq  $0xa3
  jmp alltraps
ffff80000010a4b9:	e9 f1 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a4be <vector164>:
vector164:
  push $0
ffff80000010a4be:	6a 00                	pushq  $0x0
  push $164
ffff80000010a4c0:	68 a4 00 00 00       	pushq  $0xa4
  jmp alltraps
ffff80000010a4c5:	e9 e5 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a4ca <vector165>:
vector165:
  push $0
ffff80000010a4ca:	6a 00                	pushq  $0x0
  push $165
ffff80000010a4cc:	68 a5 00 00 00       	pushq  $0xa5
  jmp alltraps
ffff80000010a4d1:	e9 d9 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a4d6 <vector166>:
vector166:
  push $0
ffff80000010a4d6:	6a 00                	pushq  $0x0
  push $166
ffff80000010a4d8:	68 a6 00 00 00       	pushq  $0xa6
  jmp alltraps
ffff80000010a4dd:	e9 cd f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a4e2 <vector167>:
vector167:
  push $0
ffff80000010a4e2:	6a 00                	pushq  $0x0
  push $167
ffff80000010a4e4:	68 a7 00 00 00       	pushq  $0xa7
  jmp alltraps
ffff80000010a4e9:	e9 c1 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a4ee <vector168>:
vector168:
  push $0
ffff80000010a4ee:	6a 00                	pushq  $0x0
  push $168
ffff80000010a4f0:	68 a8 00 00 00       	pushq  $0xa8
  jmp alltraps
ffff80000010a4f5:	e9 b5 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a4fa <vector169>:
vector169:
  push $0
ffff80000010a4fa:	6a 00                	pushq  $0x0
  push $169
ffff80000010a4fc:	68 a9 00 00 00       	pushq  $0xa9
  jmp alltraps
ffff80000010a501:	e9 a9 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a506 <vector170>:
vector170:
  push $0
ffff80000010a506:	6a 00                	pushq  $0x0
  push $170
ffff80000010a508:	68 aa 00 00 00       	pushq  $0xaa
  jmp alltraps
ffff80000010a50d:	e9 9d f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a512 <vector171>:
vector171:
  push $0
ffff80000010a512:	6a 00                	pushq  $0x0
  push $171
ffff80000010a514:	68 ab 00 00 00       	pushq  $0xab
  jmp alltraps
ffff80000010a519:	e9 91 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a51e <vector172>:
vector172:
  push $0
ffff80000010a51e:	6a 00                	pushq  $0x0
  push $172
ffff80000010a520:	68 ac 00 00 00       	pushq  $0xac
  jmp alltraps
ffff80000010a525:	e9 85 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a52a <vector173>:
vector173:
  push $0
ffff80000010a52a:	6a 00                	pushq  $0x0
  push $173
ffff80000010a52c:	68 ad 00 00 00       	pushq  $0xad
  jmp alltraps
ffff80000010a531:	e9 79 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a536 <vector174>:
vector174:
  push $0
ffff80000010a536:	6a 00                	pushq  $0x0
  push $174
ffff80000010a538:	68 ae 00 00 00       	pushq  $0xae
  jmp alltraps
ffff80000010a53d:	e9 6d f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a542 <vector175>:
vector175:
  push $0
ffff80000010a542:	6a 00                	pushq  $0x0
  push $175
ffff80000010a544:	68 af 00 00 00       	pushq  $0xaf
  jmp alltraps
ffff80000010a549:	e9 61 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a54e <vector176>:
vector176:
  push $0
ffff80000010a54e:	6a 00                	pushq  $0x0
  push $176
ffff80000010a550:	68 b0 00 00 00       	pushq  $0xb0
  jmp alltraps
ffff80000010a555:	e9 55 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a55a <vector177>:
vector177:
  push $0
ffff80000010a55a:	6a 00                	pushq  $0x0
  push $177
ffff80000010a55c:	68 b1 00 00 00       	pushq  $0xb1
  jmp alltraps
ffff80000010a561:	e9 49 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a566 <vector178>:
vector178:
  push $0
ffff80000010a566:	6a 00                	pushq  $0x0
  push $178
ffff80000010a568:	68 b2 00 00 00       	pushq  $0xb2
  jmp alltraps
ffff80000010a56d:	e9 3d f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a572 <vector179>:
vector179:
  push $0
ffff80000010a572:	6a 00                	pushq  $0x0
  push $179
ffff80000010a574:	68 b3 00 00 00       	pushq  $0xb3
  jmp alltraps
ffff80000010a579:	e9 31 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a57e <vector180>:
vector180:
  push $0
ffff80000010a57e:	6a 00                	pushq  $0x0
  push $180
ffff80000010a580:	68 b4 00 00 00       	pushq  $0xb4
  jmp alltraps
ffff80000010a585:	e9 25 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a58a <vector181>:
vector181:
  push $0
ffff80000010a58a:	6a 00                	pushq  $0x0
  push $181
ffff80000010a58c:	68 b5 00 00 00       	pushq  $0xb5
  jmp alltraps
ffff80000010a591:	e9 19 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a596 <vector182>:
vector182:
  push $0
ffff80000010a596:	6a 00                	pushq  $0x0
  push $182
ffff80000010a598:	68 b6 00 00 00       	pushq  $0xb6
  jmp alltraps
ffff80000010a59d:	e9 0d f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a5a2 <vector183>:
vector183:
  push $0
ffff80000010a5a2:	6a 00                	pushq  $0x0
  push $183
ffff80000010a5a4:	68 b7 00 00 00       	pushq  $0xb7
  jmp alltraps
ffff80000010a5a9:	e9 01 f0 ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a5ae <vector184>:
vector184:
  push $0
ffff80000010a5ae:	6a 00                	pushq  $0x0
  push $184
ffff80000010a5b0:	68 b8 00 00 00       	pushq  $0xb8
  jmp alltraps
ffff80000010a5b5:	e9 f5 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a5ba <vector185>:
vector185:
  push $0
ffff80000010a5ba:	6a 00                	pushq  $0x0
  push $185
ffff80000010a5bc:	68 b9 00 00 00       	pushq  $0xb9
  jmp alltraps
ffff80000010a5c1:	e9 e9 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a5c6 <vector186>:
vector186:
  push $0
ffff80000010a5c6:	6a 00                	pushq  $0x0
  push $186
ffff80000010a5c8:	68 ba 00 00 00       	pushq  $0xba
  jmp alltraps
ffff80000010a5cd:	e9 dd ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a5d2 <vector187>:
vector187:
  push $0
ffff80000010a5d2:	6a 00                	pushq  $0x0
  push $187
ffff80000010a5d4:	68 bb 00 00 00       	pushq  $0xbb
  jmp alltraps
ffff80000010a5d9:	e9 d1 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a5de <vector188>:
vector188:
  push $0
ffff80000010a5de:	6a 00                	pushq  $0x0
  push $188
ffff80000010a5e0:	68 bc 00 00 00       	pushq  $0xbc
  jmp alltraps
ffff80000010a5e5:	e9 c5 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a5ea <vector189>:
vector189:
  push $0
ffff80000010a5ea:	6a 00                	pushq  $0x0
  push $189
ffff80000010a5ec:	68 bd 00 00 00       	pushq  $0xbd
  jmp alltraps
ffff80000010a5f1:	e9 b9 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a5f6 <vector190>:
vector190:
  push $0
ffff80000010a5f6:	6a 00                	pushq  $0x0
  push $190
ffff80000010a5f8:	68 be 00 00 00       	pushq  $0xbe
  jmp alltraps
ffff80000010a5fd:	e9 ad ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a602 <vector191>:
vector191:
  push $0
ffff80000010a602:	6a 00                	pushq  $0x0
  push $191
ffff80000010a604:	68 bf 00 00 00       	pushq  $0xbf
  jmp alltraps
ffff80000010a609:	e9 a1 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a60e <vector192>:
vector192:
  push $0
ffff80000010a60e:	6a 00                	pushq  $0x0
  push $192
ffff80000010a610:	68 c0 00 00 00       	pushq  $0xc0
  jmp alltraps
ffff80000010a615:	e9 95 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a61a <vector193>:
vector193:
  push $0
ffff80000010a61a:	6a 00                	pushq  $0x0
  push $193
ffff80000010a61c:	68 c1 00 00 00       	pushq  $0xc1
  jmp alltraps
ffff80000010a621:	e9 89 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a626 <vector194>:
vector194:
  push $0
ffff80000010a626:	6a 00                	pushq  $0x0
  push $194
ffff80000010a628:	68 c2 00 00 00       	pushq  $0xc2
  jmp alltraps
ffff80000010a62d:	e9 7d ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a632 <vector195>:
vector195:
  push $0
ffff80000010a632:	6a 00                	pushq  $0x0
  push $195
ffff80000010a634:	68 c3 00 00 00       	pushq  $0xc3
  jmp alltraps
ffff80000010a639:	e9 71 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a63e <vector196>:
vector196:
  push $0
ffff80000010a63e:	6a 00                	pushq  $0x0
  push $196
ffff80000010a640:	68 c4 00 00 00       	pushq  $0xc4
  jmp alltraps
ffff80000010a645:	e9 65 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a64a <vector197>:
vector197:
  push $0
ffff80000010a64a:	6a 00                	pushq  $0x0
  push $197
ffff80000010a64c:	68 c5 00 00 00       	pushq  $0xc5
  jmp alltraps
ffff80000010a651:	e9 59 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a656 <vector198>:
vector198:
  push $0
ffff80000010a656:	6a 00                	pushq  $0x0
  push $198
ffff80000010a658:	68 c6 00 00 00       	pushq  $0xc6
  jmp alltraps
ffff80000010a65d:	e9 4d ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a662 <vector199>:
vector199:
  push $0
ffff80000010a662:	6a 00                	pushq  $0x0
  push $199
ffff80000010a664:	68 c7 00 00 00       	pushq  $0xc7
  jmp alltraps
ffff80000010a669:	e9 41 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a66e <vector200>:
vector200:
  push $0
ffff80000010a66e:	6a 00                	pushq  $0x0
  push $200
ffff80000010a670:	68 c8 00 00 00       	pushq  $0xc8
  jmp alltraps
ffff80000010a675:	e9 35 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a67a <vector201>:
vector201:
  push $0
ffff80000010a67a:	6a 00                	pushq  $0x0
  push $201
ffff80000010a67c:	68 c9 00 00 00       	pushq  $0xc9
  jmp alltraps
ffff80000010a681:	e9 29 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a686 <vector202>:
vector202:
  push $0
ffff80000010a686:	6a 00                	pushq  $0x0
  push $202
ffff80000010a688:	68 ca 00 00 00       	pushq  $0xca
  jmp alltraps
ffff80000010a68d:	e9 1d ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a692 <vector203>:
vector203:
  push $0
ffff80000010a692:	6a 00                	pushq  $0x0
  push $203
ffff80000010a694:	68 cb 00 00 00       	pushq  $0xcb
  jmp alltraps
ffff80000010a699:	e9 11 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a69e <vector204>:
vector204:
  push $0
ffff80000010a69e:	6a 00                	pushq  $0x0
  push $204
ffff80000010a6a0:	68 cc 00 00 00       	pushq  $0xcc
  jmp alltraps
ffff80000010a6a5:	e9 05 ef ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a6aa <vector205>:
vector205:
  push $0
ffff80000010a6aa:	6a 00                	pushq  $0x0
  push $205
ffff80000010a6ac:	68 cd 00 00 00       	pushq  $0xcd
  jmp alltraps
ffff80000010a6b1:	e9 f9 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a6b6 <vector206>:
vector206:
  push $0
ffff80000010a6b6:	6a 00                	pushq  $0x0
  push $206
ffff80000010a6b8:	68 ce 00 00 00       	pushq  $0xce
  jmp alltraps
ffff80000010a6bd:	e9 ed ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a6c2 <vector207>:
vector207:
  push $0
ffff80000010a6c2:	6a 00                	pushq  $0x0
  push $207
ffff80000010a6c4:	68 cf 00 00 00       	pushq  $0xcf
  jmp alltraps
ffff80000010a6c9:	e9 e1 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a6ce <vector208>:
vector208:
  push $0
ffff80000010a6ce:	6a 00                	pushq  $0x0
  push $208
ffff80000010a6d0:	68 d0 00 00 00       	pushq  $0xd0
  jmp alltraps
ffff80000010a6d5:	e9 d5 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a6da <vector209>:
vector209:
  push $0
ffff80000010a6da:	6a 00                	pushq  $0x0
  push $209
ffff80000010a6dc:	68 d1 00 00 00       	pushq  $0xd1
  jmp alltraps
ffff80000010a6e1:	e9 c9 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a6e6 <vector210>:
vector210:
  push $0
ffff80000010a6e6:	6a 00                	pushq  $0x0
  push $210
ffff80000010a6e8:	68 d2 00 00 00       	pushq  $0xd2
  jmp alltraps
ffff80000010a6ed:	e9 bd ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a6f2 <vector211>:
vector211:
  push $0
ffff80000010a6f2:	6a 00                	pushq  $0x0
  push $211
ffff80000010a6f4:	68 d3 00 00 00       	pushq  $0xd3
  jmp alltraps
ffff80000010a6f9:	e9 b1 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a6fe <vector212>:
vector212:
  push $0
ffff80000010a6fe:	6a 00                	pushq  $0x0
  push $212
ffff80000010a700:	68 d4 00 00 00       	pushq  $0xd4
  jmp alltraps
ffff80000010a705:	e9 a5 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a70a <vector213>:
vector213:
  push $0
ffff80000010a70a:	6a 00                	pushq  $0x0
  push $213
ffff80000010a70c:	68 d5 00 00 00       	pushq  $0xd5
  jmp alltraps
ffff80000010a711:	e9 99 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a716 <vector214>:
vector214:
  push $0
ffff80000010a716:	6a 00                	pushq  $0x0
  push $214
ffff80000010a718:	68 d6 00 00 00       	pushq  $0xd6
  jmp alltraps
ffff80000010a71d:	e9 8d ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a722 <vector215>:
vector215:
  push $0
ffff80000010a722:	6a 00                	pushq  $0x0
  push $215
ffff80000010a724:	68 d7 00 00 00       	pushq  $0xd7
  jmp alltraps
ffff80000010a729:	e9 81 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a72e <vector216>:
vector216:
  push $0
ffff80000010a72e:	6a 00                	pushq  $0x0
  push $216
ffff80000010a730:	68 d8 00 00 00       	pushq  $0xd8
  jmp alltraps
ffff80000010a735:	e9 75 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a73a <vector217>:
vector217:
  push $0
ffff80000010a73a:	6a 00                	pushq  $0x0
  push $217
ffff80000010a73c:	68 d9 00 00 00       	pushq  $0xd9
  jmp alltraps
ffff80000010a741:	e9 69 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a746 <vector218>:
vector218:
  push $0
ffff80000010a746:	6a 00                	pushq  $0x0
  push $218
ffff80000010a748:	68 da 00 00 00       	pushq  $0xda
  jmp alltraps
ffff80000010a74d:	e9 5d ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a752 <vector219>:
vector219:
  push $0
ffff80000010a752:	6a 00                	pushq  $0x0
  push $219
ffff80000010a754:	68 db 00 00 00       	pushq  $0xdb
  jmp alltraps
ffff80000010a759:	e9 51 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a75e <vector220>:
vector220:
  push $0
ffff80000010a75e:	6a 00                	pushq  $0x0
  push $220
ffff80000010a760:	68 dc 00 00 00       	pushq  $0xdc
  jmp alltraps
ffff80000010a765:	e9 45 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a76a <vector221>:
vector221:
  push $0
ffff80000010a76a:	6a 00                	pushq  $0x0
  push $221
ffff80000010a76c:	68 dd 00 00 00       	pushq  $0xdd
  jmp alltraps
ffff80000010a771:	e9 39 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a776 <vector222>:
vector222:
  push $0
ffff80000010a776:	6a 00                	pushq  $0x0
  push $222
ffff80000010a778:	68 de 00 00 00       	pushq  $0xde
  jmp alltraps
ffff80000010a77d:	e9 2d ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a782 <vector223>:
vector223:
  push $0
ffff80000010a782:	6a 00                	pushq  $0x0
  push $223
ffff80000010a784:	68 df 00 00 00       	pushq  $0xdf
  jmp alltraps
ffff80000010a789:	e9 21 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a78e <vector224>:
vector224:
  push $0
ffff80000010a78e:	6a 00                	pushq  $0x0
  push $224
ffff80000010a790:	68 e0 00 00 00       	pushq  $0xe0
  jmp alltraps
ffff80000010a795:	e9 15 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a79a <vector225>:
vector225:
  push $0
ffff80000010a79a:	6a 00                	pushq  $0x0
  push $225
ffff80000010a79c:	68 e1 00 00 00       	pushq  $0xe1
  jmp alltraps
ffff80000010a7a1:	e9 09 ee ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a7a6 <vector226>:
vector226:
  push $0
ffff80000010a7a6:	6a 00                	pushq  $0x0
  push $226
ffff80000010a7a8:	68 e2 00 00 00       	pushq  $0xe2
  jmp alltraps
ffff80000010a7ad:	e9 fd ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a7b2 <vector227>:
vector227:
  push $0
ffff80000010a7b2:	6a 00                	pushq  $0x0
  push $227
ffff80000010a7b4:	68 e3 00 00 00       	pushq  $0xe3
  jmp alltraps
ffff80000010a7b9:	e9 f1 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a7be <vector228>:
vector228:
  push $0
ffff80000010a7be:	6a 00                	pushq  $0x0
  push $228
ffff80000010a7c0:	68 e4 00 00 00       	pushq  $0xe4
  jmp alltraps
ffff80000010a7c5:	e9 e5 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a7ca <vector229>:
vector229:
  push $0
ffff80000010a7ca:	6a 00                	pushq  $0x0
  push $229
ffff80000010a7cc:	68 e5 00 00 00       	pushq  $0xe5
  jmp alltraps
ffff80000010a7d1:	e9 d9 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a7d6 <vector230>:
vector230:
  push $0
ffff80000010a7d6:	6a 00                	pushq  $0x0
  push $230
ffff80000010a7d8:	68 e6 00 00 00       	pushq  $0xe6
  jmp alltraps
ffff80000010a7dd:	e9 cd ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a7e2 <vector231>:
vector231:
  push $0
ffff80000010a7e2:	6a 00                	pushq  $0x0
  push $231
ffff80000010a7e4:	68 e7 00 00 00       	pushq  $0xe7
  jmp alltraps
ffff80000010a7e9:	e9 c1 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a7ee <vector232>:
vector232:
  push $0
ffff80000010a7ee:	6a 00                	pushq  $0x0
  push $232
ffff80000010a7f0:	68 e8 00 00 00       	pushq  $0xe8
  jmp alltraps
ffff80000010a7f5:	e9 b5 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a7fa <vector233>:
vector233:
  push $0
ffff80000010a7fa:	6a 00                	pushq  $0x0
  push $233
ffff80000010a7fc:	68 e9 00 00 00       	pushq  $0xe9
  jmp alltraps
ffff80000010a801:	e9 a9 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a806 <vector234>:
vector234:
  push $0
ffff80000010a806:	6a 00                	pushq  $0x0
  push $234
ffff80000010a808:	68 ea 00 00 00       	pushq  $0xea
  jmp alltraps
ffff80000010a80d:	e9 9d ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a812 <vector235>:
vector235:
  push $0
ffff80000010a812:	6a 00                	pushq  $0x0
  push $235
ffff80000010a814:	68 eb 00 00 00       	pushq  $0xeb
  jmp alltraps
ffff80000010a819:	e9 91 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a81e <vector236>:
vector236:
  push $0
ffff80000010a81e:	6a 00                	pushq  $0x0
  push $236
ffff80000010a820:	68 ec 00 00 00       	pushq  $0xec
  jmp alltraps
ffff80000010a825:	e9 85 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a82a <vector237>:
vector237:
  push $0
ffff80000010a82a:	6a 00                	pushq  $0x0
  push $237
ffff80000010a82c:	68 ed 00 00 00       	pushq  $0xed
  jmp alltraps
ffff80000010a831:	e9 79 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a836 <vector238>:
vector238:
  push $0
ffff80000010a836:	6a 00                	pushq  $0x0
  push $238
ffff80000010a838:	68 ee 00 00 00       	pushq  $0xee
  jmp alltraps
ffff80000010a83d:	e9 6d ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a842 <vector239>:
vector239:
  push $0
ffff80000010a842:	6a 00                	pushq  $0x0
  push $239
ffff80000010a844:	68 ef 00 00 00       	pushq  $0xef
  jmp alltraps
ffff80000010a849:	e9 61 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a84e <vector240>:
vector240:
  push $0
ffff80000010a84e:	6a 00                	pushq  $0x0
  push $240
ffff80000010a850:	68 f0 00 00 00       	pushq  $0xf0
  jmp alltraps
ffff80000010a855:	e9 55 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a85a <vector241>:
vector241:
  push $0
ffff80000010a85a:	6a 00                	pushq  $0x0
  push $241
ffff80000010a85c:	68 f1 00 00 00       	pushq  $0xf1
  jmp alltraps
ffff80000010a861:	e9 49 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a866 <vector242>:
vector242:
  push $0
ffff80000010a866:	6a 00                	pushq  $0x0
  push $242
ffff80000010a868:	68 f2 00 00 00       	pushq  $0xf2
  jmp alltraps
ffff80000010a86d:	e9 3d ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a872 <vector243>:
vector243:
  push $0
ffff80000010a872:	6a 00                	pushq  $0x0
  push $243
ffff80000010a874:	68 f3 00 00 00       	pushq  $0xf3
  jmp alltraps
ffff80000010a879:	e9 31 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a87e <vector244>:
vector244:
  push $0
ffff80000010a87e:	6a 00                	pushq  $0x0
  push $244
ffff80000010a880:	68 f4 00 00 00       	pushq  $0xf4
  jmp alltraps
ffff80000010a885:	e9 25 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a88a <vector245>:
vector245:
  push $0
ffff80000010a88a:	6a 00                	pushq  $0x0
  push $245
ffff80000010a88c:	68 f5 00 00 00       	pushq  $0xf5
  jmp alltraps
ffff80000010a891:	e9 19 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a896 <vector246>:
vector246:
  push $0
ffff80000010a896:	6a 00                	pushq  $0x0
  push $246
ffff80000010a898:	68 f6 00 00 00       	pushq  $0xf6
  jmp alltraps
ffff80000010a89d:	e9 0d ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a8a2 <vector247>:
vector247:
  push $0
ffff80000010a8a2:	6a 00                	pushq  $0x0
  push $247
ffff80000010a8a4:	68 f7 00 00 00       	pushq  $0xf7
  jmp alltraps
ffff80000010a8a9:	e9 01 ed ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a8ae <vector248>:
vector248:
  push $0
ffff80000010a8ae:	6a 00                	pushq  $0x0
  push $248
ffff80000010a8b0:	68 f8 00 00 00       	pushq  $0xf8
  jmp alltraps
ffff80000010a8b5:	e9 f5 ec ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a8ba <vector249>:
vector249:
  push $0
ffff80000010a8ba:	6a 00                	pushq  $0x0
  push $249
ffff80000010a8bc:	68 f9 00 00 00       	pushq  $0xf9
  jmp alltraps
ffff80000010a8c1:	e9 e9 ec ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a8c6 <vector250>:
vector250:
  push $0
ffff80000010a8c6:	6a 00                	pushq  $0x0
  push $250
ffff80000010a8c8:	68 fa 00 00 00       	pushq  $0xfa
  jmp alltraps
ffff80000010a8cd:	e9 dd ec ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a8d2 <vector251>:
vector251:
  push $0
ffff80000010a8d2:	6a 00                	pushq  $0x0
  push $251
ffff80000010a8d4:	68 fb 00 00 00       	pushq  $0xfb
  jmp alltraps
ffff80000010a8d9:	e9 d1 ec ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a8de <vector252>:
vector252:
  push $0
ffff80000010a8de:	6a 00                	pushq  $0x0
  push $252
ffff80000010a8e0:	68 fc 00 00 00       	pushq  $0xfc
  jmp alltraps
ffff80000010a8e5:	e9 c5 ec ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a8ea <vector253>:
vector253:
  push $0
ffff80000010a8ea:	6a 00                	pushq  $0x0
  push $253
ffff80000010a8ec:	68 fd 00 00 00       	pushq  $0xfd
  jmp alltraps
ffff80000010a8f1:	e9 b9 ec ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a8f6 <vector254>:
vector254:
  push $0
ffff80000010a8f6:	6a 00                	pushq  $0x0
  push $254
ffff80000010a8f8:	68 fe 00 00 00       	pushq  $0xfe
  jmp alltraps
ffff80000010a8fd:	e9 ad ec ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a902 <vector255>:
vector255:
  push $0
ffff80000010a902:	6a 00                	pushq  $0x0
  push $255
ffff80000010a904:	68 ff 00 00 00       	pushq  $0xff
  jmp alltraps
ffff80000010a909:	e9 a1 ec ff ff       	jmpq   ffff8000001095af <alltraps>

ffff80000010a90e <lgdt>:
{
ffff80000010a90e:	f3 0f 1e fa          	endbr64 
ffff80000010a912:	55                   	push   %rbp
ffff80000010a913:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a916:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010a91a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010a91e:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  addr_t addr = (addr_t)p;
ffff80000010a921:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010a925:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  pd[0] = size-1;
ffff80000010a929:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff80000010a92c:	83 e8 01             	sub    $0x1,%eax
ffff80000010a92f:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff80000010a933:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a937:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff80000010a93b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a93f:	48 c1 e8 10          	shr    $0x10,%rax
ffff80000010a943:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff80000010a947:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a94b:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010a94f:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff80000010a953:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a957:	48 c1 e8 30          	shr    $0x30,%rax
ffff80000010a95b:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  asm volatile("lgdt (%0)" : : "r" (pd));
ffff80000010a95f:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff80000010a963:	0f 01 10             	lgdt   (%rax)
}
ffff80000010a966:	90                   	nop
ffff80000010a967:	c9                   	leaveq 
ffff80000010a968:	c3                   	retq   

ffff80000010a969 <ltr>:
{
ffff80000010a969:	f3 0f 1e fa          	endbr64 
ffff80000010a96d:	55                   	push   %rbp
ffff80000010a96e:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a971:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010a975:	89 f8                	mov    %edi,%eax
ffff80000010a977:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  asm volatile("ltr %0" : : "r" (sel));
ffff80000010a97b:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
ffff80000010a97f:	0f 00 d8             	ltr    %ax
}
ffff80000010a982:	90                   	nop
ffff80000010a983:	c9                   	leaveq 
ffff80000010a984:	c3                   	retq   

ffff80000010a985 <lcr3>:

static inline void
lcr3(addr_t val)
{
ffff80000010a985:	f3 0f 1e fa          	endbr64 
ffff80000010a989:	55                   	push   %rbp
ffff80000010a98a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a98d:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010a991:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  asm volatile("mov %0,%%cr3" : : "r" (val));
ffff80000010a995:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a999:	0f 22 d8             	mov    %rax,%cr3
}
ffff80000010a99c:	90                   	nop
ffff80000010a99d:	c9                   	leaveq 
ffff80000010a99e:	c3                   	retq   

ffff80000010a99f <v2p>:
static inline addr_t v2p(void *a) {
ffff80000010a99f:	f3 0f 1e fa          	endbr64 
ffff80000010a9a3:	55                   	push   %rbp
ffff80000010a9a4:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a9a7:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010a9ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return ((addr_t) (a)) - ((addr_t)KERNBASE);
ffff80000010a9af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a9b3:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010a9ba:	80 00 00 
ffff80000010a9bd:	48 01 d0             	add    %rdx,%rax
}
ffff80000010a9c0:	c9                   	leaveq 
ffff80000010a9c1:	c3                   	retq   

ffff80000010a9c2 <syscallinit>:
static pde_t *kpml4;
static pde_t *kpdpt;

void
syscallinit(void)
{
ffff80000010a9c2:	f3 0f 1e fa          	endbr64 
ffff80000010a9c6:	55                   	push   %rbp
ffff80000010a9c7:	48 89 e5             	mov    %rsp,%rbp
  // the MSR/SYSRET wants the segment for 32-bit user data
  // next up is 64-bit user data, then code
  // This is simply the way the sysret instruction
  // is designed to work (it assumes they follow).
  wrmsr(MSR_STAR,
ffff80000010a9ca:	48 be 00 00 00 00 08 	movabs $0x1b000800000000,%rsi
ffff80000010a9d1:	00 1b 00 
ffff80000010a9d4:	bf 81 00 00 c0       	mov    $0xc0000081,%edi
ffff80000010a9d9:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010a9e0:	80 ff ff 
ffff80000010a9e3:	ff d0                	callq  *%rax
    ((((uint64)USER32_CS) << 48) | ((uint64)KERNEL_CS << 32)));
  wrmsr(MSR_LSTAR, (addr_t)syscall_entry);
ffff80000010a9e5:	48 b8 eb 95 10 00 00 	movabs $0xffff8000001095eb,%rax
ffff80000010a9ec:	80 ff ff 
ffff80000010a9ef:	48 89 c6             	mov    %rax,%rsi
ffff80000010a9f2:	bf 82 00 00 c0       	mov    $0xc0000082,%edi
ffff80000010a9f7:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010a9fe:	80 ff ff 
ffff80000010aa01:	ff d0                	callq  *%rax
  wrmsr(MSR_CSTAR, (addr_t)ignore_sysret);
ffff80000010aa03:	48 b8 11 01 10 00 00 	movabs $0xffff800000100111,%rax
ffff80000010aa0a:	80 ff ff 
ffff80000010aa0d:	48 89 c6             	mov    %rax,%rsi
ffff80000010aa10:	bf 83 00 00 c0       	mov    $0xc0000083,%edi
ffff80000010aa15:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010aa1c:	80 ff ff 
ffff80000010aa1f:	ff d0                	callq  *%rax

  wrmsr(MSR_SFMASK, FL_TF|FL_DF|FL_IF|FL_IOPL_3|FL_AC|FL_NT);
ffff80000010aa21:	be 00 77 04 00       	mov    $0x47700,%esi
ffff80000010aa26:	bf 84 00 00 c0       	mov    $0xc0000084,%edi
ffff80000010aa2b:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010aa32:	80 ff ff 
ffff80000010aa35:	ff d0                	callq  *%rax
}
ffff80000010aa37:	90                   	nop
ffff80000010aa38:	5d                   	pop    %rbp
ffff80000010aa39:	c3                   	retq   

ffff80000010aa3a <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
ffff80000010aa3a:	f3 0f 1e fa          	endbr64 
ffff80000010aa3e:	55                   	push   %rbp
ffff80000010aa3f:	48 89 e5             	mov    %rsp,%rbp
ffff80000010aa42:	48 83 ec 30          	sub    $0x30,%rsp
  uint64 addr;
  void *local;
  struct cpu *c;

  // create a page for cpu local storage
  local = kalloc();
ffff80000010aa46:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010aa4d:	80 ff ff 
ffff80000010aa50:	ff d0                	callq  *%rax
ffff80000010aa52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(local, 0, PGSIZE);
ffff80000010aa56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010aa5a:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010aa5f:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010aa64:	48 89 c7             	mov    %rax,%rdi
ffff80000010aa67:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff80000010aa6e:	80 ff ff 
ffff80000010aa71:	ff d0                	callq  *%rax

  gdt = (struct segdesc*) local;
ffff80000010aa73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010aa77:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  tss = (uint*) (((char*) local) + 1024);
ffff80000010aa7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010aa7f:	48 05 00 04 00 00    	add    $0x400,%rax
ffff80000010aa85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  tss[16] = 0x00680000; // IO Map Base = End of TSS
ffff80000010aa89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010aa8d:	48 83 c0 40          	add    $0x40,%rax
ffff80000010aa91:	c7 00 00 00 68 00    	movl   $0x680000,(%rax)

  // point FS smack in the middle of our local storage page
  wrmsr(0xC0000100, ((uint64) local) + 2048);
ffff80000010aa97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010aa9b:	48 05 00 08 00 00    	add    $0x800,%rax
ffff80000010aaa1:	48 89 c6             	mov    %rax,%rsi
ffff80000010aaa4:	bf 00 01 00 c0       	mov    $0xc0000100,%edi
ffff80000010aaa9:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010aab0:	80 ff ff 
ffff80000010aab3:	ff d0                	callq  *%rax

  c = &cpus[cpunum()];
ffff80000010aab5:	48 b8 27 47 10 00 00 	movabs $0xffff800000104727,%rax
ffff80000010aabc:	80 ff ff 
ffff80000010aabf:	ff d0                	callq  *%rax
ffff80000010aac1:	48 63 d0             	movslq %eax,%rdx
ffff80000010aac4:	48 89 d0             	mov    %rdx,%rax
ffff80000010aac7:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010aacb:	48 01 d0             	add    %rdx,%rax
ffff80000010aace:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010aad2:	48 ba e0 72 11 00 00 	movabs $0xffff8000001172e0,%rdx
ffff80000010aad9:	80 ff ff 
ffff80000010aadc:	48 01 d0             	add    %rdx,%rax
ffff80000010aadf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  c->local = local;
ffff80000010aae3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010aae7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010aaeb:	48 89 50 20          	mov    %rdx,0x20(%rax)

  cpu = c;
ffff80000010aaef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010aaf3:	64 48 89 04 25 f0 ff 	mov    %rax,%fs:0xfffffffffffffff0
ffff80000010aafa:	ff ff 
  proc = 0;
ffff80000010aafc:	64 48 c7 04 25 f8 ff 	movq   $0x0,%fs:0xfffffffffffffff8
ffff80000010ab03:	ff ff 00 00 00 00 

  addr = (uint64) tss;
ffff80000010ab09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ab0d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  gdt[0] =  (struct segdesc) {};
ffff80000010ab11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ab15:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  gdt[SEG_KCODE] = SEG((STA_X|STA_R), 0, 0, APP_SEG, !DPL_USER, 1);
ffff80000010ab1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ab20:	48 83 c0 08          	add    $0x8,%rax
ffff80000010ab24:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010ab29:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010ab2f:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010ab33:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ab37:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010ab3a:	83 ca 0a             	or     $0xa,%edx
ffff80000010ab3d:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ab40:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ab44:	83 ca 10             	or     $0x10,%edx
ffff80000010ab47:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ab4a:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ab4e:	83 e2 9f             	and    $0xffffff9f,%edx
ffff80000010ab51:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ab54:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ab58:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010ab5b:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ab5e:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ab62:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010ab65:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ab68:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ab6c:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010ab6f:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ab72:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ab76:	83 ca 20             	or     $0x20,%edx
ffff80000010ab79:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ab7c:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ab80:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010ab83:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ab86:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ab8a:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010ab8d:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ab90:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_KDATA] = SEG(STA_W, 0, 0, APP_SEG, !DPL_USER, 0);
ffff80000010ab94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ab98:	48 83 c0 10          	add    $0x10,%rax
ffff80000010ab9c:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010aba1:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010aba7:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010abab:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010abaf:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010abb2:	83 ca 02             	or     $0x2,%edx
ffff80000010abb5:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010abb8:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010abbc:	83 ca 10             	or     $0x10,%edx
ffff80000010abbf:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010abc2:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010abc6:	83 e2 9f             	and    $0xffffff9f,%edx
ffff80000010abc9:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010abcc:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010abd0:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010abd3:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010abd6:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010abda:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010abdd:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010abe0:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010abe4:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010abe7:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010abea:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010abee:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010abf1:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010abf4:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010abf8:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010abfb:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010abfe:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ac02:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010ac05:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ac08:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_UCODE32] = (struct segdesc) {}; // required by syscall/sysret
ffff80000010ac0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ac10:	48 83 c0 18          	add    $0x18,%rax
ffff80000010ac14:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  gdt[SEG_UDATA] = SEG(STA_W, 0, 0, APP_SEG, DPL_USER, 0);
ffff80000010ac1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ac1f:	48 83 c0 20          	add    $0x20,%rax
ffff80000010ac23:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010ac28:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010ac2e:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010ac32:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ac36:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010ac39:	83 ca 02             	or     $0x2,%edx
ffff80000010ac3c:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ac3f:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ac43:	83 ca 10             	or     $0x10,%edx
ffff80000010ac46:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ac49:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ac4d:	83 ca 60             	or     $0x60,%edx
ffff80000010ac50:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ac53:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ac57:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010ac5a:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ac5d:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ac61:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010ac64:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ac67:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ac6b:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010ac6e:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ac71:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ac75:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010ac78:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ac7b:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ac7f:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010ac82:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ac85:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ac89:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010ac8c:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ac8f:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_UCODE] = SEG((STA_X|STA_R), 0, 0, APP_SEG, DPL_USER, 1);
ffff80000010ac93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ac97:	48 83 c0 28          	add    $0x28,%rax
ffff80000010ac9b:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010aca0:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010aca6:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010acaa:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010acae:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010acb1:	83 ca 0a             	or     $0xa,%edx
ffff80000010acb4:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010acb7:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010acbb:	83 ca 10             	or     $0x10,%edx
ffff80000010acbe:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010acc1:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010acc5:	83 ca 60             	or     $0x60,%edx
ffff80000010acc8:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010accb:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010accf:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010acd2:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010acd5:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010acd9:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010acdc:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010acdf:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ace3:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010ace6:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ace9:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010aced:	83 ca 20             	or     $0x20,%edx
ffff80000010acf0:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010acf3:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010acf7:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010acfa:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010acfd:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ad01:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010ad04:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ad07:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_KCPU]  = (struct segdesc) {};
ffff80000010ad0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ad0f:	48 83 c0 30          	add    $0x30,%rax
ffff80000010ad13:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  // TSS: See IA32 SDM Figure 7-4
  gdt[SEG_TSS]   = SEG(STS_T64A, 0xb, addr, !APP_SEG, DPL_USER, 0);
ffff80000010ad1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ad1e:	48 83 c0 38          	add    $0x38,%rax
ffff80000010ad22:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010ad26:	89 d7                	mov    %edx,%edi
ffff80000010ad28:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010ad2c:	48 c1 ea 10          	shr    $0x10,%rdx
ffff80000010ad30:	89 d6                	mov    %edx,%esi
ffff80000010ad32:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010ad36:	48 c1 ea 18          	shr    $0x18,%rdx
ffff80000010ad3a:	89 d1                	mov    %edx,%ecx
ffff80000010ad3c:	66 c7 00 0b 00       	movw   $0xb,(%rax)
ffff80000010ad41:	66 89 78 02          	mov    %di,0x2(%rax)
ffff80000010ad45:	40 88 70 04          	mov    %sil,0x4(%rax)
ffff80000010ad49:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ad4d:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010ad50:	83 ca 09             	or     $0x9,%edx
ffff80000010ad53:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ad56:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ad5a:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010ad5d:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ad60:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ad64:	83 ca 60             	or     $0x60,%edx
ffff80000010ad67:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ad6a:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010ad6e:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010ad71:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010ad74:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ad78:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010ad7b:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ad7e:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ad82:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010ad85:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ad88:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ad8c:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010ad8f:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ad92:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ad96:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010ad99:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ad9c:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ada0:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010ada3:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ada6:	88 48 07             	mov    %cl,0x7(%rax)
  gdt[SEG_TSS+1] = SEG(0, addr >> 32, addr >> 48, 0, 0, 0);
ffff80000010ada9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010adad:	48 83 c0 40          	add    $0x40,%rax
ffff80000010adb1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010adb5:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010adb9:	41 89 d1             	mov    %edx,%r9d
ffff80000010adbc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010adc0:	48 c1 ea 30          	shr    $0x30,%rdx
ffff80000010adc4:	41 89 d0             	mov    %edx,%r8d
ffff80000010adc7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010adcb:	48 c1 ea 30          	shr    $0x30,%rdx
ffff80000010adcf:	48 c1 ea 10          	shr    $0x10,%rdx
ffff80000010add3:	89 d7                	mov    %edx,%edi
ffff80000010add5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010add9:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010addd:	48 c1 ea 3c          	shr    $0x3c,%rdx
ffff80000010ade1:	83 e2 0f             	and    $0xf,%edx
ffff80000010ade4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010ade8:	48 c1 e9 30          	shr    $0x30,%rcx
ffff80000010adec:	48 c1 e9 18          	shr    $0x18,%rcx
ffff80000010adf0:	89 ce                	mov    %ecx,%esi
ffff80000010adf2:	66 44 89 08          	mov    %r9w,(%rax)
ffff80000010adf6:	66 44 89 40 02       	mov    %r8w,0x2(%rax)
ffff80000010adfb:	40 88 78 04          	mov    %dil,0x4(%rax)
ffff80000010adff:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010ae03:	83 e1 f0             	and    $0xfffffff0,%ecx
ffff80000010ae06:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010ae09:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010ae0d:	83 e1 ef             	and    $0xffffffef,%ecx
ffff80000010ae10:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010ae13:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010ae17:	83 e1 9f             	and    $0xffffff9f,%ecx
ffff80000010ae1a:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010ae1d:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010ae21:	83 c9 80             	or     $0xffffff80,%ecx
ffff80000010ae24:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010ae27:	89 d1                	mov    %edx,%ecx
ffff80000010ae29:	83 e1 0f             	and    $0xf,%ecx
ffff80000010ae2c:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ae30:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010ae33:	09 ca                	or     %ecx,%edx
ffff80000010ae35:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ae38:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ae3c:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010ae3f:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ae42:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ae46:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010ae49:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ae4c:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ae50:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010ae53:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ae56:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010ae5a:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010ae5d:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010ae60:	40 88 70 07          	mov    %sil,0x7(%rax)

  lgdt((void*) gdt, (NSEGS+1) * sizeof(struct segdesc));
ffff80000010ae64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010ae68:	be 48 00 00 00       	mov    $0x48,%esi
ffff80000010ae6d:	48 89 c7             	mov    %rax,%rdi
ffff80000010ae70:	48 b8 0e a9 10 00 00 	movabs $0xffff80000010a90e,%rax
ffff80000010ae77:	80 ff ff 
ffff80000010ae7a:	ff d0                	callq  *%rax

  ltr(SEG_TSS << 3);
ffff80000010ae7c:	bf 38 00 00 00       	mov    $0x38,%edi
ffff80000010ae81:	48 b8 69 a9 10 00 00 	movabs $0xffff80000010a969,%rax
ffff80000010ae88:	80 ff ff 
ffff80000010ae8b:	ff d0                	callq  *%rax
};
ffff80000010ae8d:	90                   	nop
ffff80000010ae8e:	c9                   	leaveq 
ffff80000010ae8f:	c3                   	retq   

ffff80000010ae90 <setupkvm>:
// (directly addressable from end..P2V(PHYSTOP)).


pde_t*
setupkvm(void)
{
ffff80000010ae90:	f3 0f 1e fa          	endbr64 
ffff80000010ae94:	55                   	push   %rbp
ffff80000010ae95:	48 89 e5             	mov    %rsp,%rbp
ffff80000010ae98:	48 83 ec 10          	sub    $0x10,%rsp
  pde_t *pml4 = (pde_t*) kalloc();
ffff80000010ae9c:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010aea3:	80 ff ff 
ffff80000010aea6:	ff d0                	callq  *%rax
ffff80000010aea8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(pml4, 0, PGSIZE);
ffff80000010aeac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010aeb0:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010aeb5:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010aeba:	48 89 c7             	mov    %rax,%rdi
ffff80000010aebd:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff80000010aec4:	80 ff ff 
ffff80000010aec7:	ff d0                	callq  *%rax
  pml4[256] = v2p(kpdpt) | PTE_P | PTE_W;
ffff80000010aec9:	48 b8 60 ad 11 00 00 	movabs $0xffff80000011ad60,%rax
ffff80000010aed0:	80 ff ff 
ffff80000010aed3:	48 8b 00             	mov    (%rax),%rax
ffff80000010aed6:	48 89 c7             	mov    %rax,%rdi
ffff80000010aed9:	48 b8 9f a9 10 00 00 	movabs $0xffff80000010a99f,%rax
ffff80000010aee0:	80 ff ff 
ffff80000010aee3:	ff d0                	callq  *%rax
ffff80000010aee5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010aee9:	48 81 c2 00 08 00 00 	add    $0x800,%rdx
ffff80000010aef0:	48 83 c8 03          	or     $0x3,%rax
ffff80000010aef4:	48 89 02             	mov    %rax,(%rdx)
  return pml4;
ffff80000010aef7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
};
ffff80000010aefb:	c9                   	leaveq 
ffff80000010aefc:	c3                   	retq   

ffff80000010aefd <kvmalloc>:
//
// linear map the first 4GB of physical memory starting
// at 0xFFFF800000000000
void
kvmalloc(void)
{
ffff80000010aefd:	f3 0f 1e fa          	endbr64 
ffff80000010af01:	55                   	push   %rbp
ffff80000010af02:	48 89 e5             	mov    %rsp,%rbp
  kpml4 = (pde_t*) kalloc();
ffff80000010af05:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010af0c:	80 ff ff 
ffff80000010af0f:	ff d0                	callq  *%rax
ffff80000010af11:	48 ba 58 ad 11 00 00 	movabs $0xffff80000011ad58,%rdx
ffff80000010af18:	80 ff ff 
ffff80000010af1b:	48 89 02             	mov    %rax,(%rdx)
  memset(kpml4, 0, PGSIZE);
ffff80000010af1e:	48 b8 58 ad 11 00 00 	movabs $0xffff80000011ad58,%rax
ffff80000010af25:	80 ff ff 
ffff80000010af28:	48 8b 00             	mov    (%rax),%rax
ffff80000010af2b:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010af30:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010af35:	48 89 c7             	mov    %rax,%rdi
ffff80000010af38:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff80000010af3f:	80 ff ff 
ffff80000010af42:	ff d0                	callq  *%rax

  // the kernel memory region starts at KERNBASE and up
  // allocate one PDPT at the bottom of that range.
  kpdpt = (pde_t*) kalloc();
ffff80000010af44:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010af4b:	80 ff ff 
ffff80000010af4e:	ff d0                	callq  *%rax
ffff80000010af50:	48 ba 60 ad 11 00 00 	movabs $0xffff80000011ad60,%rdx
ffff80000010af57:	80 ff ff 
ffff80000010af5a:	48 89 02             	mov    %rax,(%rdx)
  memset(kpdpt, 0, PGSIZE);
ffff80000010af5d:	48 b8 60 ad 11 00 00 	movabs $0xffff80000011ad60,%rax
ffff80000010af64:	80 ff ff 
ffff80000010af67:	48 8b 00             	mov    (%rax),%rax
ffff80000010af6a:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010af6f:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010af74:	48 89 c7             	mov    %rax,%rdi
ffff80000010af77:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff80000010af7e:	80 ff ff 
ffff80000010af81:	ff d0                	callq  *%rax
  kpml4[PMX(KERNBASE)] = v2p(kpdpt) | PTE_P | PTE_W;
ffff80000010af83:	48 b8 60 ad 11 00 00 	movabs $0xffff80000011ad60,%rax
ffff80000010af8a:	80 ff ff 
ffff80000010af8d:	48 8b 00             	mov    (%rax),%rax
ffff80000010af90:	48 89 c7             	mov    %rax,%rdi
ffff80000010af93:	48 b8 9f a9 10 00 00 	movabs $0xffff80000010a99f,%rax
ffff80000010af9a:	80 ff ff 
ffff80000010af9d:	ff d0                	callq  *%rax
ffff80000010af9f:	48 ba 58 ad 11 00 00 	movabs $0xffff80000011ad58,%rdx
ffff80000010afa6:	80 ff ff 
ffff80000010afa9:	48 8b 12             	mov    (%rdx),%rdx
ffff80000010afac:	48 81 c2 00 08 00 00 	add    $0x800,%rdx
ffff80000010afb3:	48 83 c8 03          	or     $0x3,%rax
ffff80000010afb7:	48 89 02             	mov    %rax,(%rdx)

  // direct map first GB of physical addresses to KERNBASE
  kpdpt[0] = 0 | PTE_PS | PTE_P | PTE_W;
ffff80000010afba:	48 b8 60 ad 11 00 00 	movabs $0xffff80000011ad60,%rax
ffff80000010afc1:	80 ff ff 
ffff80000010afc4:	48 8b 00             	mov    (%rax),%rax
ffff80000010afc7:	48 c7 00 83 00 00 00 	movq   $0x83,(%rax)

  // direct map 4th GB of physical addresses to KERNBASE+3GB
  // this is a very lazy way to map IO memory (for lapic and ioapic)
  // PTE_PWT and PTE_PCD for memory mapped I/O correctness.
  kpdpt[3] = 0xC0000000 | PTE_PS | PTE_P | PTE_W | PTE_PWT | PTE_PCD;
ffff80000010afce:	48 b8 60 ad 11 00 00 	movabs $0xffff80000011ad60,%rax
ffff80000010afd5:	80 ff ff 
ffff80000010afd8:	48 8b 00             	mov    (%rax),%rax
ffff80000010afdb:	48 83 c0 18          	add    $0x18,%rax
ffff80000010afdf:	b9 9b 00 00 c0       	mov    $0xc000009b,%ecx
ffff80000010afe4:	48 89 08             	mov    %rcx,(%rax)

  switchkvm();
ffff80000010afe7:	48 b8 07 b3 10 00 00 	movabs $0xffff80000010b307,%rax
ffff80000010afee:	80 ff ff 
ffff80000010aff1:	ff d0                	callq  *%rax
}
ffff80000010aff3:	90                   	nop
ffff80000010aff4:	5d                   	pop    %rbp
ffff80000010aff5:	c3                   	retq   

ffff80000010aff6 <switchuvm>:

void
switchuvm(struct proc *p)
{
ffff80000010aff6:	f3 0f 1e fa          	endbr64 
ffff80000010affa:	55                   	push   %rbp
ffff80000010affb:	48 89 e5             	mov    %rsp,%rbp
ffff80000010affe:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010b002:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  pushcli();
ffff80000010b006:	48 b8 53 77 10 00 00 	movabs $0xffff800000107753,%rax
ffff80000010b00d:	80 ff ff 
ffff80000010b010:	ff d0                	callq  *%rax
  if(p->pgdir == 0)
ffff80000010b012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b016:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010b01a:	48 85 c0             	test   %rax,%rax
ffff80000010b01d:	75 16                	jne    ffff80000010b035 <switchuvm+0x3f>
    panic("switchuvm: no pgdir");
ffff80000010b01f:	48 bf 80 c4 10 00 00 	movabs $0xffff80000010c480,%rdi
ffff80000010b026:	80 ff ff 
ffff80000010b029:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b030:	80 ff ff 
ffff80000010b033:	ff d0                	callq  *%rax
  uint *tss = (uint*) (((char*) cpu->local) + 1024);
ffff80000010b035:	64 48 8b 04 25 f0 ff 	mov    %fs:0xfffffffffffffff0,%rax
ffff80000010b03c:	ff ff 
ffff80000010b03e:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff80000010b042:	48 05 00 04 00 00    	add    $0x400,%rax
ffff80000010b048:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  const addr_t stktop = (addr_t)p->kstack + KSTACKSIZE;
ffff80000010b04c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b050:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff80000010b054:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010b05a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  tss[1] = (uint)stktop; // https://wiki.osdev.org/Task_State_Segment
ffff80000010b05e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b062:	48 83 c0 04          	add    $0x4,%rax
ffff80000010b066:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010b06a:	89 10                	mov    %edx,(%rax)
  tss[2] = (uint)(stktop >> 32);
ffff80000010b06c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b070:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010b074:	48 89 c2             	mov    %rax,%rdx
ffff80000010b077:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b07b:	48 83 c0 08          	add    $0x8,%rax
ffff80000010b07f:	89 10                	mov    %edx,(%rax)
  lcr3(v2p(p->pgdir));
ffff80000010b081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b085:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010b089:	48 89 c7             	mov    %rax,%rdi
ffff80000010b08c:	48 b8 9f a9 10 00 00 	movabs $0xffff80000010a99f,%rax
ffff80000010b093:	80 ff ff 
ffff80000010b096:	ff d0                	callq  *%rax
ffff80000010b098:	48 89 c7             	mov    %rax,%rdi
ffff80000010b09b:	48 b8 85 a9 10 00 00 	movabs $0xffff80000010a985,%rax
ffff80000010b0a2:	80 ff ff 
ffff80000010b0a5:	ff d0                	callq  *%rax
  popcli();
ffff80000010b0a7:	48 b8 c5 77 10 00 00 	movabs $0xffff8000001077c5,%rax
ffff80000010b0ae:	80 ff ff 
ffff80000010b0b1:	ff d0                	callq  *%rax
}
ffff80000010b0b3:	90                   	nop
ffff80000010b0b4:	c9                   	leaveq 
ffff80000010b0b5:	c3                   	retq   

ffff80000010b0b6 <walkpgdir>:
// In 64-bit mode, the page table has four levels: PML4, PDPT, PD and PT
// For each level, we dereference the correct entry, or allocate and
// initialize entry if the PTE_P bit is not set
static pte_t *
walkpgdir(pde_t *pml4, const void *va, int alloc)
{
ffff80000010b0b6:	f3 0f 1e fa          	endbr64 
ffff80000010b0ba:	55                   	push   %rbp
ffff80000010b0bb:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b0be:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010b0c2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff80000010b0c6:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
ffff80000010b0ca:	89 55 bc             	mov    %edx,-0x44(%rbp)
  pml4e_t *pml4e;
  pdpe_t *pdp, *pdpe;
  pde_t *pde, *pd, *pgtab;

  // from the PML4, find or allocate the appropriate PDP table
  pml4e = &pml4[PMX(va)];
ffff80000010b0cd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b0d1:	48 c1 e8 27          	shr    $0x27,%rax
ffff80000010b0d5:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b0da:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b0e1:	00 
ffff80000010b0e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b0e6:	48 01 d0             	add    %rdx,%rax
ffff80000010b0e9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  if(*pml4e & PTE_P)
ffff80000010b0ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b0f1:	48 8b 00             	mov    (%rax),%rax
ffff80000010b0f4:	83 e0 01             	and    $0x1,%eax
ffff80000010b0f7:	48 85 c0             	test   %rax,%rax
ffff80000010b0fa:	74 23                	je     ffff80000010b11f <walkpgdir+0x69>
    pdp = (pdpe_t*)P2V(PTE_ADDR(*pml4e));
ffff80000010b0fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b100:	48 8b 00             	mov    (%rax),%rax
ffff80000010b103:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b109:	48 89 c2             	mov    %rax,%rdx
ffff80000010b10c:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b113:	80 ff ff 
ffff80000010b116:	48 01 d0             	add    %rdx,%rax
ffff80000010b119:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010b11d:	eb 63                	jmp    ffff80000010b182 <walkpgdir+0xcc>
  else {
    if(!alloc || (pdp = (pdpe_t*)kalloc()) == 0)
ffff80000010b11f:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010b123:	74 17                	je     ffff80000010b13c <walkpgdir+0x86>
ffff80000010b125:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010b12c:	80 ff ff 
ffff80000010b12f:	ff d0                	callq  *%rax
ffff80000010b131:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010b135:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010b13a:	75 0a                	jne    ffff80000010b146 <walkpgdir+0x90>
      return 0;
ffff80000010b13c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b141:	e9 bf 01 00 00       	jmpq   ffff80000010b305 <walkpgdir+0x24f>
    memset(pdp, 0, PGSIZE);
ffff80000010b146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b14a:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b14f:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b154:	48 89 c7             	mov    %rax,%rdi
ffff80000010b157:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff80000010b15e:	80 ff ff 
ffff80000010b161:	ff d0                	callq  *%rax
    *pml4e = V2P(pdp) | PTE_P | PTE_W | PTE_U;
ffff80000010b163:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b167:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b16e:	80 00 00 
ffff80000010b171:	48 01 d0             	add    %rdx,%rax
ffff80000010b174:	48 83 c8 07          	or     $0x7,%rax
ffff80000010b178:	48 89 c2             	mov    %rax,%rdx
ffff80000010b17b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b17f:	48 89 10             	mov    %rdx,(%rax)
  }

  //from the PDP, find or allocate the appropriate PD (page directory)
  pdpe = &pdp[PDPX(va)];
ffff80000010b182:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b186:	48 c1 e8 1e          	shr    $0x1e,%rax
ffff80000010b18a:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b18f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b196:	00 
ffff80000010b197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b19b:	48 01 d0             	add    %rdx,%rax
ffff80000010b19e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(*pdpe & PTE_P)
ffff80000010b1a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b1a6:	48 8b 00             	mov    (%rax),%rax
ffff80000010b1a9:	83 e0 01             	and    $0x1,%eax
ffff80000010b1ac:	48 85 c0             	test   %rax,%rax
ffff80000010b1af:	74 23                	je     ffff80000010b1d4 <walkpgdir+0x11e>
    pd = (pde_t*)P2V(PTE_ADDR(*pdpe));
ffff80000010b1b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b1b5:	48 8b 00             	mov    (%rax),%rax
ffff80000010b1b8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b1be:	48 89 c2             	mov    %rax,%rdx
ffff80000010b1c1:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b1c8:	80 ff ff 
ffff80000010b1cb:	48 01 d0             	add    %rdx,%rax
ffff80000010b1ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010b1d2:	eb 63                	jmp    ffff80000010b237 <walkpgdir+0x181>
  else {
    if(!alloc || (pd = (pde_t*)kalloc()) == 0)//allocate page table
ffff80000010b1d4:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010b1d8:	74 17                	je     ffff80000010b1f1 <walkpgdir+0x13b>
ffff80000010b1da:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010b1e1:	80 ff ff 
ffff80000010b1e4:	ff d0                	callq  *%rax
ffff80000010b1e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010b1ea:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010b1ef:	75 0a                	jne    ffff80000010b1fb <walkpgdir+0x145>
      return 0;
ffff80000010b1f1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b1f6:	e9 0a 01 00 00       	jmpq   ffff80000010b305 <walkpgdir+0x24f>
    memset(pd, 0, PGSIZE);
ffff80000010b1fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b1ff:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b204:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b209:	48 89 c7             	mov    %rax,%rdi
ffff80000010b20c:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff80000010b213:	80 ff ff 
ffff80000010b216:	ff d0                	callq  *%rax
    *pdpe = V2P(pd) | PTE_P | PTE_W | PTE_U;
ffff80000010b218:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b21c:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b223:	80 00 00 
ffff80000010b226:	48 01 d0             	add    %rdx,%rax
ffff80000010b229:	48 83 c8 07          	or     $0x7,%rax
ffff80000010b22d:	48 89 c2             	mov    %rax,%rdx
ffff80000010b230:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b234:	48 89 10             	mov    %rdx,(%rax)
  }

  // from the PD, find or allocate the appropriate page table
  pde = &pd[PDX(va)];
ffff80000010b237:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b23b:	48 c1 e8 15          	shr    $0x15,%rax
ffff80000010b23f:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b244:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b24b:	00 
ffff80000010b24c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b250:	48 01 d0             	add    %rdx,%rax
ffff80000010b253:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  if(*pde & PTE_P)
ffff80000010b257:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b25b:	48 8b 00             	mov    (%rax),%rax
ffff80000010b25e:	83 e0 01             	and    $0x1,%eax
ffff80000010b261:	48 85 c0             	test   %rax,%rax
ffff80000010b264:	74 23                	je     ffff80000010b289 <walkpgdir+0x1d3>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
ffff80000010b266:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b26a:	48 8b 00             	mov    (%rax),%rax
ffff80000010b26d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b273:	48 89 c2             	mov    %rax,%rdx
ffff80000010b276:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b27d:	80 ff ff 
ffff80000010b280:	48 01 d0             	add    %rdx,%rax
ffff80000010b283:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010b287:	eb 60                	jmp    ffff80000010b2e9 <walkpgdir+0x233>
  else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)//allocate page table
ffff80000010b289:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010b28d:	74 17                	je     ffff80000010b2a6 <walkpgdir+0x1f0>
ffff80000010b28f:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010b296:	80 ff ff 
ffff80000010b299:	ff d0                	callq  *%rax
ffff80000010b29b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010b29f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010b2a4:	75 07                	jne    ffff80000010b2ad <walkpgdir+0x1f7>
      return 0;
ffff80000010b2a6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b2ab:	eb 58                	jmp    ffff80000010b305 <walkpgdir+0x24f>
    memset(pgtab, 0, PGSIZE);
ffff80000010b2ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b2b1:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b2b6:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b2bb:	48 89 c7             	mov    %rax,%rdi
ffff80000010b2be:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff80000010b2c5:	80 ff ff 
ffff80000010b2c8:	ff d0                	callq  *%rax
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
ffff80000010b2ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b2ce:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b2d5:	80 00 00 
ffff80000010b2d8:	48 01 d0             	add    %rdx,%rax
ffff80000010b2db:	48 83 c8 07          	or     $0x7,%rax
ffff80000010b2df:	48 89 c2             	mov    %rax,%rdx
ffff80000010b2e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b2e6:	48 89 10             	mov    %rdx,(%rax)
  }

  return &pgtab[PTX(va)];
ffff80000010b2e9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010b2ed:	48 c1 e8 0c          	shr    $0xc,%rax
ffff80000010b2f1:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010b2f6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b2fd:	00 
ffff80000010b2fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b302:	48 01 d0             	add    %rdx,%rax
}
ffff80000010b305:	c9                   	leaveq 
ffff80000010b306:	c3                   	retq   

ffff80000010b307 <switchkvm>:

void
switchkvm(void)
{
ffff80000010b307:	f3 0f 1e fa          	endbr64 
ffff80000010b30b:	55                   	push   %rbp
ffff80000010b30c:	48 89 e5             	mov    %rsp,%rbp
  lcr3(v2p(kpml4));
ffff80000010b30f:	48 b8 58 ad 11 00 00 	movabs $0xffff80000011ad58,%rax
ffff80000010b316:	80 ff ff 
ffff80000010b319:	48 8b 00             	mov    (%rax),%rax
ffff80000010b31c:	48 89 c7             	mov    %rax,%rdi
ffff80000010b31f:	48 b8 9f a9 10 00 00 	movabs $0xffff80000010a99f,%rax
ffff80000010b326:	80 ff ff 
ffff80000010b329:	ff d0                	callq  *%rax
ffff80000010b32b:	48 89 c7             	mov    %rax,%rdi
ffff80000010b32e:	48 b8 85 a9 10 00 00 	movabs $0xffff80000010a985,%rax
ffff80000010b335:	80 ff ff 
ffff80000010b338:	ff d0                	callq  *%rax
}
ffff80000010b33a:	90                   	nop
ffff80000010b33b:	5d                   	pop    %rbp
ffff80000010b33c:	c3                   	retq   

ffff80000010b33d <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, addr_t size, addr_t pa, int perm)
{
ffff80000010b33d:	f3 0f 1e fa          	endbr64 
ffff80000010b341:	55                   	push   %rbp
ffff80000010b342:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b345:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010b349:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010b34d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010b351:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010b355:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff80000010b359:	44 89 45 bc          	mov    %r8d,-0x44(%rbp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((addr_t)va);
ffff80000010b35d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b361:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b367:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  last = (char*)PGROUNDDOWN(((addr_t)va) + size - 1);
ffff80000010b36b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff80000010b36f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b373:	48 01 d0             	add    %rdx,%rax
ffff80000010b376:	48 83 e8 01          	sub    $0x1,%rax
ffff80000010b37a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b380:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffff80000010b384:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010b388:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b38c:	ba 01 00 00 00       	mov    $0x1,%edx
ffff80000010b391:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b394:	48 89 c7             	mov    %rax,%rdi
ffff80000010b397:	48 b8 b6 b0 10 00 00 	movabs $0xffff80000010b0b6,%rax
ffff80000010b39e:	80 ff ff 
ffff80000010b3a1:	ff d0                	callq  *%rax
ffff80000010b3a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010b3a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010b3ac:	75 07                	jne    ffff80000010b3b5 <mappages+0x78>
      return -1;
ffff80000010b3ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010b3b3:	eb 61                	jmp    ffff80000010b416 <mappages+0xd9>
    if(*pte & PTE_P)
ffff80000010b3b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b3b9:	48 8b 00             	mov    (%rax),%rax
ffff80000010b3bc:	83 e0 01             	and    $0x1,%eax
ffff80000010b3bf:	48 85 c0             	test   %rax,%rax
ffff80000010b3c2:	74 16                	je     ffff80000010b3da <mappages+0x9d>
      panic("remap");
ffff80000010b3c4:	48 bf 94 c4 10 00 00 	movabs $0xffff80000010c494,%rdi
ffff80000010b3cb:	80 ff ff 
ffff80000010b3ce:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b3d5:	80 ff ff 
ffff80000010b3d8:	ff d0                	callq  *%rax
    *pte = pa | perm | PTE_P;
ffff80000010b3da:	8b 45 bc             	mov    -0x44(%rbp),%eax
ffff80000010b3dd:	48 98                	cltq   
ffff80000010b3df:	48 0b 45 c0          	or     -0x40(%rbp),%rax
ffff80000010b3e3:	48 83 c8 01          	or     $0x1,%rax
ffff80000010b3e7:	48 89 c2             	mov    %rax,%rdx
ffff80000010b3ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b3ee:	48 89 10             	mov    %rdx,(%rax)
    if(a == last)
ffff80000010b3f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b3f5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff80000010b3f9:	74 15                	je     ffff80000010b410 <mappages+0xd3>
      break;
    a += PGSIZE;
ffff80000010b3fb:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010b402:	00 
    pa += PGSIZE;
ffff80000010b403:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
ffff80000010b40a:	00 
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffff80000010b40b:	e9 74 ff ff ff       	jmpq   ffff80000010b384 <mappages+0x47>
      break;
ffff80000010b410:	90                   	nop
  }
  return 0;
ffff80000010b411:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010b416:	c9                   	leaveq 
ffff80000010b417:	c3                   	retq   

ffff80000010b418 <inituvm>:

// Load the initcode into address 0x1000 (4KB) of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
ffff80000010b418:	f3 0f 1e fa          	endbr64 
ffff80000010b41c:	55                   	push   %rbp
ffff80000010b41d:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b420:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010b424:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010b428:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010b42c:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *mem;

  if(sz >= PGSIZE)
ffff80000010b42f:	81 7d dc ff 0f 00 00 	cmpl   $0xfff,-0x24(%rbp)
ffff80000010b436:	76 16                	jbe    ffff80000010b44e <inituvm+0x36>
    panic("inituvm: more than a page");
ffff80000010b438:	48 bf 9a c4 10 00 00 	movabs $0xffff80000010c49a,%rdi
ffff80000010b43f:	80 ff ff 
ffff80000010b442:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b449:	80 ff ff 
ffff80000010b44c:	ff d0                	callq  *%rax

  mem = kalloc();
ffff80000010b44e:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010b455:	80 ff ff 
ffff80000010b458:	ff d0                	callq  *%rax
ffff80000010b45a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(mem, 0, PGSIZE);
ffff80000010b45e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b462:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b467:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b46c:	48 89 c7             	mov    %rax,%rdi
ffff80000010b46f:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff80000010b476:	80 ff ff 
ffff80000010b479:	ff d0                	callq  *%rax
  mappages(pgdir, (void *)PGSIZE, PGSIZE, V2P(mem), PTE_W|PTE_U);
ffff80000010b47b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b47f:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b486:	80 00 00 
ffff80000010b489:	48 01 c2             	add    %rax,%rdx
ffff80000010b48c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b490:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffff80000010b496:	48 89 d1             	mov    %rdx,%rcx
ffff80000010b499:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b49e:	be 00 10 00 00       	mov    $0x1000,%esi
ffff80000010b4a3:	48 89 c7             	mov    %rax,%rdi
ffff80000010b4a6:	48 b8 3d b3 10 00 00 	movabs $0xffff80000010b33d,%rax
ffff80000010b4ad:	80 ff ff 
ffff80000010b4b0:	ff d0                	callq  *%rax

  memmove(mem, init, sz);
ffff80000010b4b2:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff80000010b4b5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010b4b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b4bd:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b4c0:	48 89 c7             	mov    %rax,%rdi
ffff80000010b4c3:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff80000010b4ca:	80 ff ff 
ffff80000010b4cd:	ff d0                	callq  *%rax
}
ffff80000010b4cf:	90                   	nop
ffff80000010b4d0:	c9                   	leaveq 
ffff80000010b4d1:	c3                   	retq   

ffff80000010b4d2 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
ffff80000010b4d2:	f3 0f 1e fa          	endbr64 
ffff80000010b4d6:	55                   	push   %rbp
ffff80000010b4d7:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b4da:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010b4de:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010b4e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010b4e6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010b4ea:	89 4d c4             	mov    %ecx,-0x3c(%rbp)
ffff80000010b4ed:	44 89 45 c0          	mov    %r8d,-0x40(%rbp)
  uint i, n;
  addr_t pa;
  pte_t *pte;

  if((addr_t) addr % PGSIZE != 0)
ffff80000010b4f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b4f5:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010b4fa:	48 85 c0             	test   %rax,%rax
ffff80000010b4fd:	74 16                	je     ffff80000010b515 <loaduvm+0x43>
    panic("loaduvm: addr must be page aligned");
ffff80000010b4ff:	48 bf b8 c4 10 00 00 	movabs $0xffff80000010c4b8,%rdi
ffff80000010b506:	80 ff ff 
ffff80000010b509:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b510:	80 ff ff 
ffff80000010b513:	ff d0                	callq  *%rax
  for(i = 0; i < sz; i += PGSIZE){
ffff80000010b515:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010b51c:	e9 c4 00 00 00       	jmpq   ffff80000010b5e5 <loaduvm+0x113>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
ffff80000010b521:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010b524:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b528:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010b52c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b530:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010b535:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b538:	48 89 c7             	mov    %rax,%rdi
ffff80000010b53b:	48 b8 b6 b0 10 00 00 	movabs $0xffff80000010b0b6,%rax
ffff80000010b542:	80 ff ff 
ffff80000010b545:	ff d0                	callq  *%rax
ffff80000010b547:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010b54b:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010b550:	75 16                	jne    ffff80000010b568 <loaduvm+0x96>
      panic("loaduvm: address should exist");
ffff80000010b552:	48 bf db c4 10 00 00 	movabs $0xffff80000010c4db,%rdi
ffff80000010b559:	80 ff ff 
ffff80000010b55c:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b563:	80 ff ff 
ffff80000010b566:	ff d0                	callq  *%rax
    pa = PTE_ADDR(*pte);
ffff80000010b568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b56c:	48 8b 00             	mov    (%rax),%rax
ffff80000010b56f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b575:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(sz - i < PGSIZE)
ffff80000010b579:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff80000010b57c:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010b57f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
ffff80000010b584:	77 0b                	ja     ffff80000010b591 <loaduvm+0xbf>
      n = sz - i;
ffff80000010b586:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff80000010b589:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010b58c:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffff80000010b58f:	eb 07                	jmp    ffff80000010b598 <loaduvm+0xc6>
    else
      n = PGSIZE;
ffff80000010b591:	c7 45 f8 00 10 00 00 	movl   $0x1000,-0x8(%rbp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
ffff80000010b598:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff80000010b59b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010b59e:	8d 34 02             	lea    (%rdx,%rax,1),%esi
ffff80000010b5a1:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010b5a8:	80 ff ff 
ffff80000010b5ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b5af:	48 01 d0             	add    %rdx,%rax
ffff80000010b5b2:	48 89 c7             	mov    %rax,%rdi
ffff80000010b5b5:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff80000010b5b8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b5bc:	89 d1                	mov    %edx,%ecx
ffff80000010b5be:	89 f2                	mov    %esi,%edx
ffff80000010b5c0:	48 89 fe             	mov    %rdi,%rsi
ffff80000010b5c3:	48 89 c7             	mov    %rax,%rdi
ffff80000010b5c6:	48 b8 51 2f 10 00 00 	movabs $0xffff800000102f51,%rax
ffff80000010b5cd:	80 ff ff 
ffff80000010b5d0:	ff d0                	callq  *%rax
ffff80000010b5d2:	39 45 f8             	cmp    %eax,-0x8(%rbp)
ffff80000010b5d5:	74 07                	je     ffff80000010b5de <loaduvm+0x10c>
      return -1;
ffff80000010b5d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010b5dc:	eb 18                	jmp    ffff80000010b5f6 <loaduvm+0x124>
  for(i = 0; i < sz; i += PGSIZE){
ffff80000010b5de:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffff80000010b5e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010b5e8:	3b 45 c0             	cmp    -0x40(%rbp),%eax
ffff80000010b5eb:	0f 82 30 ff ff ff    	jb     ffff80000010b521 <loaduvm+0x4f>
  }
  return 0;
ffff80000010b5f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010b5f6:	c9                   	leaveq 
ffff80000010b5f7:	c3                   	retq   

ffff80000010b5f8 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
allocuvm(pde_t *pgdir, uint64 oldsz, uint64 newsz)
{
ffff80000010b5f8:	f3 0f 1e fa          	endbr64 
ffff80000010b5fc:	55                   	push   %rbp
ffff80000010b5fd:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b600:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010b604:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010b608:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010b60c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  char *mem;
  addr_t a;

  if(newsz >= KERNBASE)
ffff80000010b610:	48 b8 ff ff ff ff ff 	movabs $0xffff7fffffffffff,%rax
ffff80000010b617:	7f ff ff 
ffff80000010b61a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
ffff80000010b61e:	76 0a                	jbe    ffff80000010b62a <allocuvm+0x32>
    return 0;
ffff80000010b620:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b625:	e9 14 01 00 00       	jmpq   ffff80000010b73e <allocuvm+0x146>
  if(newsz < oldsz)
ffff80000010b62a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b62e:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
ffff80000010b632:	73 09                	jae    ffff80000010b63d <allocuvm+0x45>
    return oldsz;
ffff80000010b634:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b638:	e9 01 01 00 00       	jmpq   ffff80000010b73e <allocuvm+0x146>

  a = PGROUNDUP(oldsz);
ffff80000010b63d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b641:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010b647:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b64d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a < newsz; a += PGSIZE){
ffff80000010b651:	e9 d6 00 00 00       	jmpq   ffff80000010b72c <allocuvm+0x134>
    mem = kalloc();
ffff80000010b656:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010b65d:	80 ff ff 
ffff80000010b660:	ff d0                	callq  *%rax
ffff80000010b662:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(mem == 0){
ffff80000010b666:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010b66b:	75 28                	jne    ffff80000010b695 <allocuvm+0x9d>
      //cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
ffff80000010b66d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010b671:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010b675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b679:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b67c:	48 89 c7             	mov    %rax,%rdi
ffff80000010b67f:	48 b8 40 b7 10 00 00 	movabs $0xffff80000010b740,%rax
ffff80000010b686:	80 ff ff 
ffff80000010b689:	ff d0                	callq  *%rax
      return 0;
ffff80000010b68b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b690:	e9 a9 00 00 00       	jmpq   ffff80000010b73e <allocuvm+0x146>
    }
    memset(mem, 0, PGSIZE);
ffff80000010b695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b699:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b69e:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b6a3:	48 89 c7             	mov    %rax,%rdi
ffff80000010b6a6:	48 b8 d1 78 10 00 00 	movabs $0xffff8000001078d1,%rax
ffff80000010b6ad:	80 ff ff 
ffff80000010b6b0:	ff d0                	callq  *%rax
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
ffff80000010b6b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b6b6:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b6bd:	80 00 00 
ffff80000010b6c0:	48 01 c2             	add    %rax,%rdx
ffff80000010b6c3:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffff80000010b6c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b6cb:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffff80000010b6d1:	48 89 d1             	mov    %rdx,%rcx
ffff80000010b6d4:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b6d9:	48 89 c7             	mov    %rax,%rdi
ffff80000010b6dc:	48 b8 3d b3 10 00 00 	movabs $0xffff80000010b33d,%rax
ffff80000010b6e3:	80 ff ff 
ffff80000010b6e6:	ff d0                	callq  *%rax
ffff80000010b6e8:	85 c0                	test   %eax,%eax
ffff80000010b6ea:	79 38                	jns    ffff80000010b724 <allocuvm+0x12c>
      //cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
ffff80000010b6ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010b6f0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010b6f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b6f8:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b6fb:	48 89 c7             	mov    %rax,%rdi
ffff80000010b6fe:	48 b8 40 b7 10 00 00 	movabs $0xffff80000010b740,%rax
ffff80000010b705:	80 ff ff 
ffff80000010b708:	ff d0                	callq  *%rax
      kfree(mem);
ffff80000010b70a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b70e:	48 89 c7             	mov    %rax,%rdi
ffff80000010b711:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010b718:	80 ff ff 
ffff80000010b71b:	ff d0                	callq  *%rax
      return 0;
ffff80000010b71d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010b722:	eb 1a                	jmp    ffff80000010b73e <allocuvm+0x146>
  for(; a < newsz; a += PGSIZE){
ffff80000010b724:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010b72b:	00 
ffff80000010b72c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b730:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
ffff80000010b734:	0f 82 1c ff ff ff    	jb     ffff80000010b656 <allocuvm+0x5e>
    }
  }
  return newsz;
ffff80000010b73a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
}
ffff80000010b73e:	c9                   	leaveq 
ffff80000010b73f:	c3                   	retq   

ffff80000010b740 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
deallocuvm(pde_t *pgdir, uint64 oldsz, uint64 newsz)
{
ffff80000010b740:	f3 0f 1e fa          	endbr64 
ffff80000010b744:	55                   	push   %rbp
ffff80000010b745:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b748:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010b74c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010b750:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010b754:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  pte_t *pte;
  addr_t a, pa;

  if(newsz >= oldsz)
ffff80000010b758:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b75c:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffff80000010b760:	72 09                	jb     ffff80000010b76b <deallocuvm+0x2b>
    return oldsz;
ffff80000010b762:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b766:	e9 cd 00 00 00       	jmpq   ffff80000010b838 <deallocuvm+0xf8>

  a = PGROUNDUP(newsz);
ffff80000010b76b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b76f:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010b775:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b77b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a  < oldsz; a += PGSIZE){
ffff80000010b77f:	e9 a2 00 00 00       	jmpq   ffff80000010b826 <deallocuvm+0xe6>
    pte = walkpgdir(pgdir, (char*)a, 0);
ffff80000010b784:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010b788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b78c:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010b791:	48 89 ce             	mov    %rcx,%rsi
ffff80000010b794:	48 89 c7             	mov    %rax,%rdi
ffff80000010b797:	48 b8 b6 b0 10 00 00 	movabs $0xffff80000010b0b6,%rax
ffff80000010b79e:	80 ff ff 
ffff80000010b7a1:	ff d0                	callq  *%rax
ffff80000010b7a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(pte && (*pte & PTE_P) != 0){
ffff80000010b7a7:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010b7ac:	74 70                	je     ffff80000010b81e <deallocuvm+0xde>
ffff80000010b7ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b7b2:	48 8b 00             	mov    (%rax),%rax
ffff80000010b7b5:	83 e0 01             	and    $0x1,%eax
ffff80000010b7b8:	48 85 c0             	test   %rax,%rax
ffff80000010b7bb:	74 61                	je     ffff80000010b81e <deallocuvm+0xde>
      pa = PTE_ADDR(*pte);
ffff80000010b7bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b7c1:	48 8b 00             	mov    (%rax),%rax
ffff80000010b7c4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b7ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      if(pa == 0)
ffff80000010b7ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010b7d3:	75 16                	jne    ffff80000010b7eb <deallocuvm+0xab>
        panic("kfree");
ffff80000010b7d5:	48 bf f9 c4 10 00 00 	movabs $0xffff80000010c4f9,%rdi
ffff80000010b7dc:	80 ff ff 
ffff80000010b7df:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b7e6:	80 ff ff 
ffff80000010b7e9:	ff d0                	callq  *%rax
      char *v = P2V(pa);
ffff80000010b7eb:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010b7f2:	80 ff ff 
ffff80000010b7f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b7f9:	48 01 d0             	add    %rdx,%rax
ffff80000010b7fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      kfree(v);
ffff80000010b800:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b804:	48 89 c7             	mov    %rax,%rdi
ffff80000010b807:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010b80e:	80 ff ff 
ffff80000010b811:	ff d0                	callq  *%rax
      *pte = 0;
ffff80000010b813:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b817:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(; a  < oldsz; a += PGSIZE){
ffff80000010b81e:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010b825:	00 
ffff80000010b826:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b82a:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffff80000010b82e:	0f 82 50 ff ff ff    	jb     ffff80000010b784 <deallocuvm+0x44>
    }
  }
  return newsz;
ffff80000010b834:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
ffff80000010b838:	c9                   	leaveq 
ffff80000010b839:	c3                   	retq   

ffff80000010b83a <freevm>:

// Free all the pages mapped by, and all the memory used for,
// this page table
void
freevm(pde_t *pml4)
{
ffff80000010b83a:	f3 0f 1e fa          	endbr64 
ffff80000010b83e:	55                   	push   %rbp
ffff80000010b83f:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b842:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010b846:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  uint i, j, k, l;
  pde_t *pdp, *pd, *pt;

  if(pml4 == 0)
ffff80000010b84a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff80000010b84f:	75 16                	jne    ffff80000010b867 <freevm+0x2d>
    panic("freevm: no pgdir");
ffff80000010b851:	48 bf ff c4 10 00 00 	movabs $0xffff80000010c4ff,%rdi
ffff80000010b858:	80 ff ff 
ffff80000010b85b:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010b862:	80 ff ff 
ffff80000010b865:	ff d0                	callq  *%rax

  // then need to loop through pml4 entry
  for(i = 0; i < (NPDENTRIES/2); i++){
ffff80000010b867:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010b86e:	e9 dc 01 00 00       	jmpq   ffff80000010ba4f <freevm+0x215>
    if(pml4[i] & PTE_P){
ffff80000010b873:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010b876:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b87d:	00 
ffff80000010b87e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b882:	48 01 d0             	add    %rdx,%rax
ffff80000010b885:	48 8b 00             	mov    (%rax),%rax
ffff80000010b888:	83 e0 01             	and    $0x1,%eax
ffff80000010b88b:	48 85 c0             	test   %rax,%rax
ffff80000010b88e:	0f 84 b7 01 00 00    	je     ffff80000010ba4b <freevm+0x211>
      pdp = (pdpe_t*)P2V(PTE_ADDR(pml4[i]));
ffff80000010b894:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010b897:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b89e:	00 
ffff80000010b89f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010b8a3:	48 01 d0             	add    %rdx,%rax
ffff80000010b8a6:	48 8b 00             	mov    (%rax),%rax
ffff80000010b8a9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b8af:	48 89 c2             	mov    %rax,%rdx
ffff80000010b8b2:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b8b9:	80 ff ff 
ffff80000010b8bc:	48 01 d0             	add    %rdx,%rax
ffff80000010b8bf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

      // and every entry in the corresponding pdpt
      for(j = 0; j < NPDENTRIES; j++){
ffff80000010b8c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff80000010b8ca:	e9 5c 01 00 00       	jmpq   ffff80000010ba2b <freevm+0x1f1>
        if(pdp[j] & PTE_P){
ffff80000010b8cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010b8d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b8d9:	00 
ffff80000010b8da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b8de:	48 01 d0             	add    %rdx,%rax
ffff80000010b8e1:	48 8b 00             	mov    (%rax),%rax
ffff80000010b8e4:	83 e0 01             	and    $0x1,%eax
ffff80000010b8e7:	48 85 c0             	test   %rax,%rax
ffff80000010b8ea:	0f 84 37 01 00 00    	je     ffff80000010ba27 <freevm+0x1ed>
          pd = (pde_t*)P2V(PTE_ADDR(pdp[j]));
ffff80000010b8f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010b8f3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b8fa:	00 
ffff80000010b8fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b8ff:	48 01 d0             	add    %rdx,%rax
ffff80000010b902:	48 8b 00             	mov    (%rax),%rax
ffff80000010b905:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b90b:	48 89 c2             	mov    %rax,%rdx
ffff80000010b90e:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b915:	80 ff ff 
ffff80000010b918:	48 01 d0             	add    %rdx,%rax
ffff80000010b91b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

          // and every entry in the corresponding page directory
          for(k = 0; k < (NPDENTRIES); k++){
ffff80000010b91f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff80000010b926:	e9 dc 00 00 00       	jmpq   ffff80000010ba07 <freevm+0x1cd>
            if(pd[k] & PTE_P) {
ffff80000010b92b:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010b92e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b935:	00 
ffff80000010b936:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b93a:	48 01 d0             	add    %rdx,%rax
ffff80000010b93d:	48 8b 00             	mov    (%rax),%rax
ffff80000010b940:	83 e0 01             	and    $0x1,%eax
ffff80000010b943:	48 85 c0             	test   %rax,%rax
ffff80000010b946:	0f 84 b7 00 00 00    	je     ffff80000010ba03 <freevm+0x1c9>
              pt = (pde_t*)P2V(PTE_ADDR(pd[k]));
ffff80000010b94c:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010b94f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b956:	00 
ffff80000010b957:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b95b:	48 01 d0             	add    %rdx,%rax
ffff80000010b95e:	48 8b 00             	mov    (%rax),%rax
ffff80000010b961:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b967:	48 89 c2             	mov    %rax,%rdx
ffff80000010b96a:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b971:	80 ff ff 
ffff80000010b974:	48 01 d0             	add    %rdx,%rax
ffff80000010b977:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

              // and every entry in the corresponding page table
              for(l = 0; l < (NPDENTRIES); l++){
ffff80000010b97b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
ffff80000010b982:	eb 63                	jmp    ffff80000010b9e7 <freevm+0x1ad>
                if(pt[l] & PTE_P) {
ffff80000010b984:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010b987:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b98e:	00 
ffff80000010b98f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b993:	48 01 d0             	add    %rdx,%rax
ffff80000010b996:	48 8b 00             	mov    (%rax),%rax
ffff80000010b999:	83 e0 01             	and    $0x1,%eax
ffff80000010b99c:	48 85 c0             	test   %rax,%rax
ffff80000010b99f:	74 42                	je     ffff80000010b9e3 <freevm+0x1a9>
                  char * v = P2V(PTE_ADDR(pt[l]));
ffff80000010b9a1:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010b9a4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010b9ab:	00 
ffff80000010b9ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b9b0:	48 01 d0             	add    %rdx,%rax
ffff80000010b9b3:	48 8b 00             	mov    (%rax),%rax
ffff80000010b9b6:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010b9bc:	48 89 c2             	mov    %rax,%rdx
ffff80000010b9bf:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010b9c6:	80 ff ff 
ffff80000010b9c9:	48 01 d0             	add    %rdx,%rax
ffff80000010b9cc:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

                  kfree((char*)v);
ffff80000010b9d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010b9d4:	48 89 c7             	mov    %rax,%rdi
ffff80000010b9d7:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010b9de:	80 ff ff 
ffff80000010b9e1:	ff d0                	callq  *%rax
              for(l = 0; l < (NPDENTRIES); l++){
ffff80000010b9e3:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
ffff80000010b9e7:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
ffff80000010b9ee:	76 94                	jbe    ffff80000010b984 <freevm+0x14a>
                }
              }
              //freeing every page table
              kfree((char*)pt);
ffff80000010b9f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b9f4:	48 89 c7             	mov    %rax,%rdi
ffff80000010b9f7:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010b9fe:	80 ff ff 
ffff80000010ba01:	ff d0                	callq  *%rax
          for(k = 0; k < (NPDENTRIES); k++){
ffff80000010ba03:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff80000010ba07:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
ffff80000010ba0e:	0f 86 17 ff ff ff    	jbe    ffff80000010b92b <freevm+0xf1>
            }
          }
          // freeing every page directory
          kfree((char*)pd);
ffff80000010ba14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010ba18:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba1b:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010ba22:	80 ff ff 
ffff80000010ba25:	ff d0                	callq  *%rax
      for(j = 0; j < NPDENTRIES; j++){
ffff80000010ba27:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff80000010ba2b:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
ffff80000010ba32:	0f 86 97 fe ff ff    	jbe    ffff80000010b8cf <freevm+0x95>
        }
      }
      // freeing every page directory pointer table
      kfree((char*)pdp);
ffff80000010ba38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ba3c:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba3f:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010ba46:	80 ff ff 
ffff80000010ba49:	ff d0                	callq  *%rax
  for(i = 0; i < (NPDENTRIES/2); i++){
ffff80000010ba4b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010ba4f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffff80000010ba56:	0f 86 17 fe ff ff    	jbe    ffff80000010b873 <freevm+0x39>
    }
  }
  // freeing the pml4
  kfree((char*)pml4);
ffff80000010ba5c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010ba60:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba63:	48 b8 3a 41 10 00 00 	movabs $0xffff80000010413a,%rax
ffff80000010ba6a:	80 ff ff 
ffff80000010ba6d:	ff d0                	callq  *%rax
}
ffff80000010ba6f:	90                   	nop
ffff80000010ba70:	c9                   	leaveq 
ffff80000010ba71:	c3                   	retq   

ffff80000010ba72 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
ffff80000010ba72:	f3 0f 1e fa          	endbr64 
ffff80000010ba76:	55                   	push   %rbp
ffff80000010ba77:	48 89 e5             	mov    %rsp,%rbp
ffff80000010ba7a:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010ba7e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010ba82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffff80000010ba86:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010ba8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ba8e:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010ba93:	48 89 ce             	mov    %rcx,%rsi
ffff80000010ba96:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba99:	48 b8 b6 b0 10 00 00 	movabs $0xffff80000010b0b6,%rax
ffff80000010baa0:	80 ff ff 
ffff80000010baa3:	ff d0                	callq  *%rax
ffff80000010baa5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(pte == 0)
ffff80000010baa9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010baae:	75 16                	jne    ffff80000010bac6 <clearpteu+0x54>
    panic("clearpteu");
ffff80000010bab0:	48 bf 10 c5 10 00 00 	movabs $0xffff80000010c510,%rdi
ffff80000010bab7:	80 ff ff 
ffff80000010baba:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010bac1:	80 ff ff 
ffff80000010bac4:	ff d0                	callq  *%rax
  *pte &= ~PTE_U;
ffff80000010bac6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010baca:	48 8b 00             	mov    (%rax),%rax
ffff80000010bacd:	48 83 e0 fb          	and    $0xfffffffffffffffb,%rax
ffff80000010bad1:	48 89 c2             	mov    %rax,%rdx
ffff80000010bad4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bad8:	48 89 10             	mov    %rdx,(%rax)
}
ffff80000010badb:	90                   	nop
ffff80000010badc:	c9                   	leaveq 
ffff80000010badd:	c3                   	retq   

ffff80000010bade <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
ffff80000010bade:	f3 0f 1e fa          	endbr64 
ffff80000010bae2:	55                   	push   %rbp
ffff80000010bae3:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bae6:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010baea:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff80000010baee:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  pde_t *d;
  pte_t *pte;
  addr_t pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
ffff80000010baf1:	48 b8 90 ae 10 00 00 	movabs $0xffff80000010ae90,%rax
ffff80000010baf8:	80 ff ff 
ffff80000010bafb:	ff d0                	callq  *%rax
ffff80000010bafd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010bb01:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010bb06:	75 0a                	jne    ffff80000010bb12 <copyuvm+0x34>
    return 0;
ffff80000010bb08:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bb0d:	e9 51 01 00 00       	jmpq   ffff80000010bc63 <copyuvm+0x185>
  for(i = PGSIZE; i < sz; i += PGSIZE){
ffff80000010bb12:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
ffff80000010bb19:	00 
ffff80000010bb1a:	e9 15 01 00 00       	jmpq   ffff80000010bc34 <copyuvm+0x156>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
ffff80000010bb1f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010bb23:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bb27:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010bb2c:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bb2f:	48 89 c7             	mov    %rax,%rdi
ffff80000010bb32:	48 b8 b6 b0 10 00 00 	movabs $0xffff80000010b0b6,%rax
ffff80000010bb39:	80 ff ff 
ffff80000010bb3c:	ff d0                	callq  *%rax
ffff80000010bb3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010bb42:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010bb47:	75 16                	jne    ffff80000010bb5f <copyuvm+0x81>
      panic("copyuvm: pte should exist");
ffff80000010bb49:	48 bf 1a c5 10 00 00 	movabs $0xffff80000010c51a,%rdi
ffff80000010bb50:	80 ff ff 
ffff80000010bb53:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010bb5a:	80 ff ff 
ffff80000010bb5d:	ff d0                	callq  *%rax
    if(!(*pte & PTE_P))
ffff80000010bb5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bb63:	48 8b 00             	mov    (%rax),%rax
ffff80000010bb66:	83 e0 01             	and    $0x1,%eax
ffff80000010bb69:	48 85 c0             	test   %rax,%rax
ffff80000010bb6c:	75 16                	jne    ffff80000010bb84 <copyuvm+0xa6>
      panic("copyuvm: page not present");
ffff80000010bb6e:	48 bf 34 c5 10 00 00 	movabs $0xffff80000010c534,%rdi
ffff80000010bb75:	80 ff ff 
ffff80000010bb78:	48 b8 f9 0b 10 00 00 	movabs $0xffff800000100bf9,%rax
ffff80000010bb7f:	80 ff ff 
ffff80000010bb82:	ff d0                	callq  *%rax
    pa = PTE_ADDR(*pte);
ffff80000010bb84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bb88:	48 8b 00             	mov    (%rax),%rax
ffff80000010bb8b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bb91:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    flags = PTE_FLAGS(*pte);
ffff80000010bb95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bb99:	48 8b 00             	mov    (%rax),%rax
ffff80000010bb9c:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010bba1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    if((mem = kalloc()) == 0)
ffff80000010bba5:	48 b8 34 42 10 00 00 	movabs $0xffff800000104234,%rax
ffff80000010bbac:	80 ff ff 
ffff80000010bbaf:	ff d0                	callq  *%rax
ffff80000010bbb1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ffff80000010bbb5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
ffff80000010bbba:	0f 84 87 00 00 00    	je     ffff80000010bc47 <copyuvm+0x169>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
ffff80000010bbc0:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010bbc7:	80 ff ff 
ffff80000010bbca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bbce:	48 01 d0             	add    %rdx,%rax
ffff80000010bbd1:	48 89 c1             	mov    %rax,%rcx
ffff80000010bbd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bbd8:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bbdd:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bbe0:	48 89 c7             	mov    %rax,%rdi
ffff80000010bbe3:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff80000010bbea:	80 ff ff 
ffff80000010bbed:	ff d0                	callq  *%rax
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
ffff80000010bbef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bbf3:	89 c1                	mov    %eax,%ecx
ffff80000010bbf5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bbf9:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010bc00:	80 00 00 
ffff80000010bc03:	48 01 c2             	add    %rax,%rdx
ffff80000010bc06:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffff80000010bc0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bc0e:	41 89 c8             	mov    %ecx,%r8d
ffff80000010bc11:	48 89 d1             	mov    %rdx,%rcx
ffff80000010bc14:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bc19:	48 89 c7             	mov    %rax,%rdi
ffff80000010bc1c:	48 b8 3d b3 10 00 00 	movabs $0xffff80000010b33d,%rax
ffff80000010bc23:	80 ff ff 
ffff80000010bc26:	ff d0                	callq  *%rax
ffff80000010bc28:	85 c0                	test   %eax,%eax
ffff80000010bc2a:	78 1e                	js     ffff80000010bc4a <copyuvm+0x16c>
  for(i = PGSIZE; i < sz; i += PGSIZE){
ffff80000010bc2c:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010bc33:	00 
ffff80000010bc34:	8b 45 c4             	mov    -0x3c(%rbp),%eax
ffff80000010bc37:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010bc3b:	0f 82 de fe ff ff    	jb     ffff80000010bb1f <copyuvm+0x41>
      goto bad;
  }
  return d;
ffff80000010bc41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bc45:	eb 1c                	jmp    ffff80000010bc63 <copyuvm+0x185>
      goto bad;
ffff80000010bc47:	90                   	nop
ffff80000010bc48:	eb 01                	jmp    ffff80000010bc4b <copyuvm+0x16d>
      goto bad;
ffff80000010bc4a:	90                   	nop

bad:
  freevm(d);
ffff80000010bc4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bc4f:	48 89 c7             	mov    %rax,%rdi
ffff80000010bc52:	48 b8 3a b8 10 00 00 	movabs $0xffff80000010b83a,%rax
ffff80000010bc59:	80 ff ff 
ffff80000010bc5c:	ff d0                	callq  *%rax
  return 0;
ffff80000010bc5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010bc63:	c9                   	leaveq 
ffff80000010bc64:	c3                   	retq   

ffff80000010bc65 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
ffff80000010bc65:	f3 0f 1e fa          	endbr64 
ffff80000010bc69:	55                   	push   %rbp
ffff80000010bc6a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bc6d:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010bc71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010bc75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffff80000010bc79:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010bc7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bc81:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010bc86:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bc89:	48 89 c7             	mov    %rax,%rdi
ffff80000010bc8c:	48 b8 b6 b0 10 00 00 	movabs $0xffff80000010b0b6,%rax
ffff80000010bc93:	80 ff ff 
ffff80000010bc96:	ff d0                	callq  *%rax
ffff80000010bc98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((*pte & PTE_P) == 0)
ffff80000010bc9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bca0:	48 8b 00             	mov    (%rax),%rax
ffff80000010bca3:	83 e0 01             	and    $0x1,%eax
ffff80000010bca6:	48 85 c0             	test   %rax,%rax
ffff80000010bca9:	75 07                	jne    ffff80000010bcb2 <uva2ka+0x4d>
    return 0;
ffff80000010bcab:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bcb0:	eb 33                	jmp    ffff80000010bce5 <uva2ka+0x80>
  if((*pte & PTE_U) == 0)
ffff80000010bcb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bcb6:	48 8b 00             	mov    (%rax),%rax
ffff80000010bcb9:	83 e0 04             	and    $0x4,%eax
ffff80000010bcbc:	48 85 c0             	test   %rax,%rax
ffff80000010bcbf:	75 07                	jne    ffff80000010bcc8 <uva2ka+0x63>
    return 0;
ffff80000010bcc1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bcc6:	eb 1d                	jmp    ffff80000010bce5 <uva2ka+0x80>
  return (char*)P2V(PTE_ADDR(*pte));
ffff80000010bcc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bccc:	48 8b 00             	mov    (%rax),%rax
ffff80000010bccf:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bcd5:	48 89 c2             	mov    %rax,%rdx
ffff80000010bcd8:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bcdf:	80 ff ff 
ffff80000010bce2:	48 01 d0             	add    %rdx,%rax
}
ffff80000010bce5:	c9                   	leaveq 
ffff80000010bce6:	c3                   	retq   

ffff80000010bce7 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, addr_t va, void *p, uint64 len)
{
ffff80000010bce7:	f3 0f 1e fa          	endbr64 
ffff80000010bceb:	55                   	push   %rbp
ffff80000010bcec:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bcef:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010bcf3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010bcf7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010bcfb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010bcff:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  char *buf, *pa0;
  addr_t n, va0;

  buf = (char*)p;
ffff80000010bd03:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bd07:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(len > 0){
ffff80000010bd0b:	e9 b0 00 00 00       	jmpq   ffff80000010bdc0 <copyout+0xd9>
    va0 = PGROUNDDOWN(va);
ffff80000010bd10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bd14:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bd1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    pa0 = uva2ka(pgdir, (char*)va0);
ffff80000010bd1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010bd22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bd26:	48 89 d6             	mov    %rdx,%rsi
ffff80000010bd29:	48 89 c7             	mov    %rax,%rdi
ffff80000010bd2c:	48 b8 65 bc 10 00 00 	movabs $0xffff80000010bc65,%rax
ffff80000010bd33:	80 ff ff 
ffff80000010bd36:	ff d0                	callq  *%rax
ffff80000010bd38:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    if(pa0 == 0)
ffff80000010bd3c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff80000010bd41:	75 0a                	jne    ffff80000010bd4d <copyout+0x66>
      return -1;
ffff80000010bd43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010bd48:	e9 83 00 00 00       	jmpq   ffff80000010bdd0 <copyout+0xe9>
    n = PGSIZE - (va - va0);
ffff80000010bd4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bd51:	48 2b 45 d0          	sub    -0x30(%rbp),%rax
ffff80000010bd55:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010bd5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(n > len)
ffff80000010bd5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bd63:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
ffff80000010bd67:	76 08                	jbe    ffff80000010bd71 <copyout+0x8a>
      n = len;
ffff80000010bd69:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010bd6d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    memmove(pa0 + (va - va0), buf, n);
ffff80000010bd71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bd75:	89 c6                	mov    %eax,%esi
ffff80000010bd77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bd7b:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
ffff80000010bd7f:	48 89 c2             	mov    %rax,%rdx
ffff80000010bd82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bd86:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010bd8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bd8e:	89 f2                	mov    %esi,%edx
ffff80000010bd90:	48 89 c6             	mov    %rax,%rsi
ffff80000010bd93:	48 89 cf             	mov    %rcx,%rdi
ffff80000010bd96:	48 b8 de 79 10 00 00 	movabs $0xffff8000001079de,%rax
ffff80000010bd9d:	80 ff ff 
ffff80000010bda0:	ff d0                	callq  *%rax
    len -= n;
ffff80000010bda2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bda6:	48 29 45 c0          	sub    %rax,-0x40(%rbp)
    buf += n;
ffff80000010bdaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bdae:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    va = va0 + PGSIZE;
ffff80000010bdb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bdb6:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010bdbc:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  while(len > 0){
ffff80000010bdc0:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff80000010bdc5:	0f 85 45 ff ff ff    	jne    ffff80000010bd10 <copyout+0x29>
  }
  return 0;
ffff80000010bdcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010bdd0:	c9                   	leaveq 
ffff80000010bdd1:	c3                   	retq   
