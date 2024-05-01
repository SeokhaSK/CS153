
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2d 10 80       	mov    $0x80102de0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 c0 6d 10 	movl   $0x80106dc0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 e0 3f 00 00       	call   80104040 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 c7 6d 10 	movl   $0x80106dc7,0x4(%esp)
8010009b:	80 
8010009c:	e8 8f 3e 00 00       	call   80103f30 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 45 40 00 00       	call   80104130 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 ba 40 00 00       	call   80104220 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 ff 3d 00 00       	call   80103f70 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 92 1f 00 00       	call   80102110 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 ce 6d 10 80 	movl   $0x80106dce,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 5b 3e 00 00       	call   80104010 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 47 1f 00 00       	jmp    80102110 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 df 6d 10 80 	movl   $0x80106ddf,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 1a 3e 00 00       	call   80104010 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 ce 3d 00 00       	call   80103fd0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 22 3f 00 00       	call   80104130 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 cb 3f 00 00       	jmp    80104220 <release>
    panic("brelse");
80100255:	c7 04 24 e6 6d 10 80 	movl   $0x80106de6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 f9 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 9d 3e 00 00       	call   80104130 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 e3 33 00 00       	call   80103690 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 28 39 00 00       	call   80103bf0 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 0a 3f 00 00       	call   80104220 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 82 13 00 00       	call   801016a0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 ec 3e 00 00       	call   80104220 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 64 13 00 00       	call   801016a0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 d5 23 00 00       	call   80102750 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 ed 6d 10 80 	movl   $0x80106ded,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 3f 77 10 80 	movl   $0x8010773f,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 ac 3c 00 00       	call   80104060 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 01 6e 10 80 	movl   $0x80106e01,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 92 53 00 00       	call   801057a0 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 e2 52 00 00       	call   801057a0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 d6 52 00 00       	call   801057a0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 ca 52 00 00       	call   801057a0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 0f 3e 00 00       	call   80104310 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 52 3d 00 00       	call   80104270 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 05 6e 10 80 	movl   $0x80106e05,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 30 6e 10 80 	movzbl -0x7fef91d0(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 79 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 1d 3b 00 00       	call   80104130 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 e5 3b 00 00       	call   80104220 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 5a 10 00 00       	call   801016a0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 28 3b 00 00       	call   80104220 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 18 6e 10 80       	mov    $0x80106e18,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 94 39 00 00       	call   80104130 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 1f 6e 10 80 	movl   $0x80106e1f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 66 39 00 00       	call   80104130 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 f4 39 00 00       	call   80104220 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 c9 34 00 00       	call   80103d80 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 34 35 00 00       	jmp    80103e60 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 28 6e 10 	movl   $0x80106e28,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 d6 36 00 00       	call   80104040 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 04 19 00 00       	call   801022a0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 df 2c 00 00       	call   80103690 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 44 21 00 00       	call   80102b00 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 29 15 00 00       	call   80101ef0 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 4f 02 00 00    	je     80100c20 <exec+0x280>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 c7 0c 00 00       	call   801016a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 55 0f 00 00       	call   80101950 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 f8 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a08:	e8 63 21 00 00       	call   80102b70 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 7f 5f 00 00       	call   801069b0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 bd 0e 00 00       	call   80101950 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 39 5d 00 00       	call   80106810 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 38 5c 00 00       	call   80106750 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 02 5e 00 00       	call   80106930 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 c5 0d 00 00       	call   80101900 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 2b 20 00 00       	call   80102b70 <end_op>
  if((allocuvm(pgdir, sp - PGSIZE, sp)) == 0)
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	c7 44 24 08 ff ff ff 	movl   $0x7fffffff,0x8(%esp)
80100b52:	7f 
80100b53:	c7 44 24 04 ff ef ff 	movl   $0x7fffefff,0x4(%esp)
80100b5a:	7f 
80100b5b:	89 04 24             	mov    %eax,(%esp)
80100b5e:	e8 ad 5c 00 00       	call   80106810 <allocuvm>
80100b63:	85 c0                	test   %eax,%eax
80100b65:	0f 84 9d 00 00 00    	je     80100c08 <exec+0x268>
  curproc->stack_pages = 1;
80100b6b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b71:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
  for(argc = 0; argv[argc]; argc++) {
80100b78:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b7b:	8b 00                	mov    (%eax),%eax
80100b7d:	85 c0                	test   %eax,%eax
80100b7f:	0f 84 97 01 00 00    	je     80100d1c <exec+0x37c>
80100b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b88:	31 d2                	xor    %edx,%edx
  sp = KERNBASE-1;
80100b8a:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
80100b8f:	8d 71 04             	lea    0x4(%ecx),%esi
  for(argc = 0; argv[argc]; argc++) {
80100b92:	89 cf                	mov    %ecx,%edi
80100b94:	89 d1                	mov    %edx,%ecx
80100b96:	89 f2                	mov    %esi,%edx
80100b98:	89 ce                	mov    %ecx,%esi
80100b9a:	eb 2a                	jmp    80100bc6 <exec+0x226>
80100b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ba0:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
    ustack[3+argc] = sp;
80100ba6:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100bac:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100bb3:	83 c6 01             	add    $0x1,%esi
80100bb6:	8b 02                	mov    (%edx),%eax
80100bb8:	89 d7                	mov    %edx,%edi
80100bba:	85 c0                	test   %eax,%eax
80100bbc:	74 7d                	je     80100c3b <exec+0x29b>
80100bbe:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bc1:	83 fe 20             	cmp    $0x20,%esi
80100bc4:	74 42                	je     80100c08 <exec+0x268>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bc6:	89 04 24             	mov    %eax,(%esp)
80100bc9:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100bcf:	e8 bc 38 00 00       	call   80104490 <strlen>
80100bd4:	f7 d0                	not    %eax
80100bd6:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bd8:	8b 07                	mov    (%edi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bda:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bdd:	89 04 24             	mov    %eax,(%esp)
80100be0:	e8 ab 38 00 00       	call   80104490 <strlen>
80100be5:	83 c0 01             	add    $0x1,%eax
80100be8:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bec:	8b 07                	mov    (%edi),%eax
80100bee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100bf2:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bf6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bfc:	89 04 24             	mov    %eax,(%esp)
80100bff:	e8 9c 60 00 00       	call   80106ca0 <copyout>
80100c04:	85 c0                	test   %eax,%eax
80100c06:	79 98                	jns    80100ba0 <exec+0x200>
    freevm(pgdir);
80100c08:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c0e:	89 04 24             	mov    %eax,(%esp)
80100c11:	e8 1a 5d 00 00       	call   80106930 <freevm>
  return -1;
80100c16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c1b:	e9 f2 fd ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100c20:	e8 4b 1f 00 00       	call   80102b70 <end_op>
    cprintf("exec: fail\n");
80100c25:	c7 04 24 41 6e 10 80 	movl   $0x80106e41,(%esp)
80100c2c:	e8 1f fa ff ff       	call   80100650 <cprintf>
    return -1;
80100c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c36:	e9 d7 fd ff ff       	jmp    80100a12 <exec+0x72>
80100c3b:	89 f2                	mov    %esi,%edx
  ustack[3+argc] = 0;
80100c3d:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c44:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c48:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c4f:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c55:	89 da                	mov    %ebx,%edx
80100c57:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c59:	83 c0 0c             	add    $0xc,%eax
80100c5c:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c62:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c68:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c6c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c70:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c77:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7a:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c7d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c83:	e8 18 60 00 00       	call   80106ca0 <copyout>
80100c88:	85 c0                	test   %eax,%eax
80100c8a:	0f 88 78 ff ff ff    	js     80100c08 <exec+0x268>
  for(last=s=path; *s; s++)
80100c90:	8b 45 08             	mov    0x8(%ebp),%eax
80100c93:	0f b6 10             	movzbl (%eax),%edx
80100c96:	84 d2                	test   %dl,%dl
80100c98:	74 19                	je     80100cb3 <exec+0x313>
80100c9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c9d:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100ca0:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100ca3:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100ca6:	0f 44 c8             	cmove  %eax,%ecx
80100ca9:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100cac:	84 d2                	test   %dl,%dl
80100cae:	75 f0                	jne    80100ca0 <exec+0x300>
80100cb0:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cb3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80100cbc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cc3:	00 
80100cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc8:	89 f8                	mov    %edi,%eax
80100cca:	83 c0 6c             	add    $0x6c,%eax
80100ccd:	89 04 24             	mov    %eax,(%esp)
80100cd0:	e8 7b 37 00 00       	call   80104450 <safestrcpy>
  sz = PGROUNDUP(sz);
80100cd5:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  curproc->pgdir = pgdir;
80100cdb:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100ce1:	8b 77 04             	mov    0x4(%edi),%esi
  sz = PGROUNDUP(sz);
80100ce4:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ce9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cee:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100cf0:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100cf3:	89 57 04             	mov    %edx,0x4(%edi)
  curproc->tf->eip = elf.entry;  // main
80100cf6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100cfc:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
80100d02:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d05:	89 3c 24             	mov    %edi,(%esp)
80100d08:	e8 a3 58 00 00       	call   801065b0 <switchuvm>
  freevm(oldpgdir);
80100d0d:	89 34 24             	mov    %esi,(%esp)
80100d10:	e8 1b 5c 00 00       	call   80106930 <freevm>
  return 0;
80100d15:	31 c0                	xor    %eax,%eax
80100d17:	e9 f6 fc ff ff       	jmp    80100a12 <exec+0x72>
  sp = KERNBASE-1;
80100d1c:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
  for(argc = 0; argv[argc]; argc++) {
80100d21:	31 d2                	xor    %edx,%edx
80100d23:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d29:	e9 0f ff ff ff       	jmp    80100c3d <exec+0x29d>
80100d2e:	66 90                	xchg   %ax,%ax

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d36:	c7 44 24 04 4d 6e 10 	movl   $0x80106e4d,0x4(%esp)
80100d3d:	80 
80100d3e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d45:	e8 f6 32 00 00       	call   80104040 <initlock>
}
80100d4a:	c9                   	leave  
80100d4b:	c3                   	ret    
80100d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d59:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d5c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d63:	e8 c8 33 00 00       	call   80104130 <acquire>
80100d68:	eb 11                	jmp    80100d7b <filealloc+0x2b>
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d79:	74 25                	je     80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d82:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100d89:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d90:	e8 8b 34 00 00       	call   80104220 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d95:	83 c4 14             	add    $0x14,%esp
      return f;
80100d98:	89 d8                	mov    %ebx,%eax
}
80100d9a:	5b                   	pop    %ebx
80100d9b:	5d                   	pop    %ebp
80100d9c:	c3                   	ret    
80100d9d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100da0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100da7:	e8 74 34 00 00       	call   80104220 <release>
}
80100dac:	83 c4 14             	add    $0x14,%esp
  return 0;
80100daf:	31 c0                	xor    %eax,%eax
}
80100db1:	5b                   	pop    %ebx
80100db2:	5d                   	pop    %ebp
80100db3:	c3                   	ret    
80100db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 14             	sub    $0x14,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dd1:	e8 5a 33 00 00       	call   80104130 <acquire>
  if(f->ref < 1)
80100dd6:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd9:	85 c0                	test   %eax,%eax
80100ddb:	7e 1a                	jle    80100df7 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100ddd:	83 c0 01             	add    $0x1,%eax
80100de0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de3:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dea:	e8 31 34 00 00       	call   80104220 <release>
  return f;
}
80100def:	83 c4 14             	add    $0x14,%esp
80100df2:	89 d8                	mov    %ebx,%eax
80100df4:	5b                   	pop    %ebx
80100df5:	5d                   	pop    %ebp
80100df6:	c3                   	ret    
    panic("filedup");
80100df7:	c7 04 24 54 6e 10 80 	movl   $0x80106e54,(%esp)
80100dfe:	e8 5d f5 ff ff       	call   80100360 <panic>
80100e03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	57                   	push   %edi
80100e14:	56                   	push   %esi
80100e15:	53                   	push   %ebx
80100e16:	83 ec 1c             	sub    $0x1c,%esp
80100e19:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e23:	e8 08 33 00 00       	call   80104130 <acquire>
  if(f->ref < 1)
80100e28:	8b 57 04             	mov    0x4(%edi),%edx
80100e2b:	85 d2                	test   %edx,%edx
80100e2d:	0f 8e 89 00 00 00    	jle    80100ebc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e33:	83 ea 01             	sub    $0x1,%edx
80100e36:	85 d2                	test   %edx,%edx
80100e38:	89 57 04             	mov    %edx,0x4(%edi)
80100e3b:	74 13                	je     80100e50 <fileclose+0x40>
    release(&ftable.lock);
80100e3d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e44:	83 c4 1c             	add    $0x1c,%esp
80100e47:	5b                   	pop    %ebx
80100e48:	5e                   	pop    %esi
80100e49:	5f                   	pop    %edi
80100e4a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e4b:	e9 d0 33 00 00       	jmp    80104220 <release>
  ff = *f;
80100e50:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e54:	8b 37                	mov    (%edi),%esi
80100e56:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e59:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e5f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e62:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e65:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e6f:	e8 ac 33 00 00       	call   80104220 <release>
  if(ff.type == FD_PIPE)
80100e74:	83 fe 01             	cmp    $0x1,%esi
80100e77:	74 0f                	je     80100e88 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100e79:	83 fe 02             	cmp    $0x2,%esi
80100e7c:	74 22                	je     80100ea0 <fileclose+0x90>
}
80100e7e:	83 c4 1c             	add    $0x1c,%esp
80100e81:	5b                   	pop    %ebx
80100e82:	5e                   	pop    %esi
80100e83:	5f                   	pop    %edi
80100e84:	5d                   	pop    %ebp
80100e85:	c3                   	ret    
80100e86:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100e88:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e8c:	89 1c 24             	mov    %ebx,(%esp)
80100e8f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100e93:	e8 b8 23 00 00       	call   80103250 <pipeclose>
80100e98:	eb e4                	jmp    80100e7e <fileclose+0x6e>
80100e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ea0:	e8 5b 1c 00 00       	call   80102b00 <begin_op>
    iput(ff.ip);
80100ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ea8:	89 04 24             	mov    %eax,(%esp)
80100eab:	e8 10 09 00 00       	call   801017c0 <iput>
}
80100eb0:	83 c4 1c             	add    $0x1c,%esp
80100eb3:	5b                   	pop    %ebx
80100eb4:	5e                   	pop    %esi
80100eb5:	5f                   	pop    %edi
80100eb6:	5d                   	pop    %ebp
    end_op();
80100eb7:	e9 b4 1c 00 00       	jmp    80102b70 <end_op>
    panic("fileclose");
80100ebc:	c7 04 24 5c 6e 10 80 	movl   $0x80106e5c,(%esp)
80100ec3:	e8 98 f4 ff ff       	call   80100360 <panic>
80100ec8:	90                   	nop
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	53                   	push   %ebx
80100ed4:	83 ec 14             	sub    $0x14,%esp
80100ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100edd:	75 31                	jne    80100f10 <filestat+0x40>
    ilock(f->ip);
80100edf:	8b 43 10             	mov    0x10(%ebx),%eax
80100ee2:	89 04 24             	mov    %eax,(%esp)
80100ee5:	e8 b6 07 00 00       	call   801016a0 <ilock>
    stati(f->ip, st);
80100eea:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eed:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ef1:	8b 43 10             	mov    0x10(%ebx),%eax
80100ef4:	89 04 24             	mov    %eax,(%esp)
80100ef7:	e8 24 0a 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100efc:	8b 43 10             	mov    0x10(%ebx),%eax
80100eff:	89 04 24             	mov    %eax,(%esp)
80100f02:	e8 79 08 00 00       	call   80101780 <iunlock>
    return 0;
  }
  return -1;
}
80100f07:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f0a:	31 c0                	xor    %eax,%eax
}
80100f0c:	5b                   	pop    %ebx
80100f0d:	5d                   	pop    %ebp
80100f0e:	c3                   	ret    
80100f0f:	90                   	nop
80100f10:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f18:	5b                   	pop    %ebx
80100f19:	5d                   	pop    %ebp
80100f1a:	c3                   	ret    
80100f1b:	90                   	nop
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f20 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	57                   	push   %edi
80100f24:	56                   	push   %esi
80100f25:	53                   	push   %ebx
80100f26:	83 ec 1c             	sub    $0x1c,%esp
80100f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f32:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f36:	74 68                	je     80100fa0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f38:	8b 03                	mov    (%ebx),%eax
80100f3a:	83 f8 01             	cmp    $0x1,%eax
80100f3d:	74 49                	je     80100f88 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f3f:	83 f8 02             	cmp    $0x2,%eax
80100f42:	75 63                	jne    80100fa7 <fileread+0x87>
    ilock(f->ip);
80100f44:	8b 43 10             	mov    0x10(%ebx),%eax
80100f47:	89 04 24             	mov    %eax,(%esp)
80100f4a:	e8 51 07 00 00       	call   801016a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f4f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f53:	8b 43 14             	mov    0x14(%ebx),%eax
80100f56:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f5a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f5e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f61:	89 04 24             	mov    %eax,(%esp)
80100f64:	e8 e7 09 00 00       	call   80101950 <readi>
80100f69:	85 c0                	test   %eax,%eax
80100f6b:	89 c6                	mov    %eax,%esi
80100f6d:	7e 03                	jle    80100f72 <fileread+0x52>
      f->off += r;
80100f6f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f72:	8b 43 10             	mov    0x10(%ebx),%eax
80100f75:	89 04 24             	mov    %eax,(%esp)
80100f78:	e8 03 08 00 00       	call   80101780 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7d:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100f7f:	83 c4 1c             	add    $0x1c,%esp
80100f82:	5b                   	pop    %ebx
80100f83:	5e                   	pop    %esi
80100f84:	5f                   	pop    %edi
80100f85:	5d                   	pop    %ebp
80100f86:	c3                   	ret    
80100f87:	90                   	nop
    return piperead(f->pipe, addr, n);
80100f88:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f8b:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100f8e:	83 c4 1c             	add    $0x1c,%esp
80100f91:	5b                   	pop    %ebx
80100f92:	5e                   	pop    %esi
80100f93:	5f                   	pop    %edi
80100f94:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100f95:	e9 36 24 00 00       	jmp    801033d0 <piperead>
80100f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fa5:	eb d8                	jmp    80100f7f <fileread+0x5f>
  panic("fileread");
80100fa7:	c7 04 24 66 6e 10 80 	movl   $0x80106e66,(%esp)
80100fae:	e8 ad f3 ff ff       	call   80100360 <panic>
80100fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fc0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 2c             	sub    $0x2c,%esp
80100fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fcc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fcf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fd5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80100fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100fdc:	0f 84 ae 00 00 00    	je     80101090 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100fe2:	8b 07                	mov    (%edi),%eax
80100fe4:	83 f8 01             	cmp    $0x1,%eax
80100fe7:	0f 84 c2 00 00 00    	je     801010af <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fed:	83 f8 02             	cmp    $0x2,%eax
80100ff0:	0f 85 d7 00 00 00    	jne    801010cd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff9:	31 db                	xor    %ebx,%ebx
80100ffb:	85 c0                	test   %eax,%eax
80100ffd:	7f 31                	jg     80101030 <filewrite+0x70>
80100fff:	e9 9c 00 00 00       	jmp    801010a0 <filewrite+0xe0>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101008:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010100b:	01 47 14             	add    %eax,0x14(%edi)
8010100e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101011:	89 0c 24             	mov    %ecx,(%esp)
80101014:	e8 67 07 00 00       	call   80101780 <iunlock>
      end_op();
80101019:	e8 52 1b 00 00       	call   80102b70 <end_op>
8010101e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101021:	39 f0                	cmp    %esi,%eax
80101023:	0f 85 98 00 00 00    	jne    801010c1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101029:	01 c3                	add    %eax,%ebx
    while(i < n){
8010102b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010102e:	7e 70                	jle    801010a0 <filewrite+0xe0>
      int n1 = n - i;
80101030:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101033:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101038:	29 de                	sub    %ebx,%esi
8010103a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101040:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101043:	e8 b8 1a 00 00       	call   80102b00 <begin_op>
      ilock(f->ip);
80101048:	8b 47 10             	mov    0x10(%edi),%eax
8010104b:	89 04 24             	mov    %eax,(%esp)
8010104e:	e8 4d 06 00 00       	call   801016a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101053:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101057:	8b 47 14             	mov    0x14(%edi),%eax
8010105a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010105e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101061:	01 d8                	add    %ebx,%eax
80101063:	89 44 24 04          	mov    %eax,0x4(%esp)
80101067:	8b 47 10             	mov    0x10(%edi),%eax
8010106a:	89 04 24             	mov    %eax,(%esp)
8010106d:	e8 de 09 00 00       	call   80101a50 <writei>
80101072:	85 c0                	test   %eax,%eax
80101074:	7f 92                	jg     80101008 <filewrite+0x48>
      iunlock(f->ip);
80101076:	8b 4f 10             	mov    0x10(%edi),%ecx
80101079:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010107c:	89 0c 24             	mov    %ecx,(%esp)
8010107f:	e8 fc 06 00 00       	call   80101780 <iunlock>
      end_op();
80101084:	e8 e7 1a 00 00       	call   80102b70 <end_op>
      if(r < 0)
80101089:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010108c:	85 c0                	test   %eax,%eax
8010108e:	74 91                	je     80101021 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101090:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80101093:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101098:	5b                   	pop    %ebx
80101099:	5e                   	pop    %esi
8010109a:	5f                   	pop    %edi
8010109b:	5d                   	pop    %ebp
8010109c:	c3                   	ret    
8010109d:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010a0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010a3:	89 d8                	mov    %ebx,%eax
801010a5:	75 e9                	jne    80101090 <filewrite+0xd0>
}
801010a7:	83 c4 2c             	add    $0x2c,%esp
801010aa:	5b                   	pop    %ebx
801010ab:	5e                   	pop    %esi
801010ac:	5f                   	pop    %edi
801010ad:	5d                   	pop    %ebp
801010ae:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010af:	8b 47 0c             	mov    0xc(%edi),%eax
801010b2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010b5:	83 c4 2c             	add    $0x2c,%esp
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010bc:	e9 1f 22 00 00       	jmp    801032e0 <pipewrite>
        panic("short filewrite");
801010c1:	c7 04 24 6f 6e 10 80 	movl   $0x80106e6f,(%esp)
801010c8:	e8 93 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010cd:	c7 04 24 75 6e 10 80 	movl   $0x80106e75,(%esp)
801010d4:	e8 87 f2 ff ff       	call   80100360 <panic>
801010d9:	66 90                	xchg   %ax,%ax
801010db:	66 90                	xchg   %ax,%ax
801010dd:	66 90                	xchg   %ax,%ax
801010df:	90                   	nop

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 2c             	sub    $0x2c,%esp
801010e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010ec:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801010f1:	85 c0                	test   %eax,%eax
801010f3:	0f 84 8c 00 00 00    	je     80101185 <balloc+0xa5>
801010f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101100:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101103:	89 f0                	mov    %esi,%eax
80101105:	c1 f8 0c             	sar    $0xc,%eax
80101108:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010110e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101112:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101115:	89 04 24             	mov    %eax,(%esp)
80101118:	e8 b3 ef ff ff       	call   801000d0 <bread>
8010111d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101120:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101125:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101128:	31 c0                	xor    %eax,%eax
8010112a:	eb 33                	jmp    8010115f <balloc+0x7f>
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101130:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101133:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101135:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101137:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010113a:	83 e1 07             	and    $0x7,%ecx
8010113d:	bf 01 00 00 00       	mov    $0x1,%edi
80101142:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101144:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101149:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010114b:	0f b6 fb             	movzbl %bl,%edi
8010114e:	85 cf                	test   %ecx,%edi
80101150:	74 46                	je     80101198 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101152:	83 c0 01             	add    $0x1,%eax
80101155:	83 c6 01             	add    $0x1,%esi
80101158:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010115d:	74 05                	je     80101164 <balloc+0x84>
8010115f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101162:	72 cc                	jb     80101130 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101167:	89 04 24             	mov    %eax,(%esp)
8010116a:	e8 71 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010116f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101176:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101179:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010117f:	0f 82 7b ff ff ff    	jb     80101100 <balloc+0x20>
  }
  panic("balloc: out of blocks");
80101185:	c7 04 24 7f 6e 10 80 	movl   $0x80106e7f,(%esp)
8010118c:	e8 cf f1 ff ff       	call   80100360 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101198:	09 d9                	or     %ebx,%ecx
8010119a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010119d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011a1:	89 1c 24             	mov    %ebx,(%esp)
801011a4:	e8 f7 1a 00 00       	call   80102ca0 <log_write>
        brelse(bp);
801011a9:	89 1c 24             	mov    %ebx,(%esp)
801011ac:	e8 2f f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011b4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011b8:	89 04 24             	mov    %eax,(%esp)
801011bb:	e8 10 ef ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011c0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011c7:	00 
801011c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011cf:	00 
  bp = bread(dev, bno);
801011d0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011d5:	89 04 24             	mov    %eax,(%esp)
801011d8:	e8 93 30 00 00       	call   80104270 <memset>
  log_write(bp);
801011dd:	89 1c 24             	mov    %ebx,(%esp)
801011e0:	e8 bb 1a 00 00       	call   80102ca0 <log_write>
  brelse(bp);
801011e5:	89 1c 24             	mov    %ebx,(%esp)
801011e8:	e8 f3 ef ff ff       	call   801001e0 <brelse>
}
801011ed:	83 c4 2c             	add    $0x2c,%esp
801011f0:	89 f0                	mov    %esi,%eax
801011f2:	5b                   	pop    %ebx
801011f3:	5e                   	pop    %esi
801011f4:	5f                   	pop    %edi
801011f5:	5d                   	pop    %ebp
801011f6:	c3                   	ret    
801011f7:	89 f6                	mov    %esi,%esi
801011f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101200 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	89 c7                	mov    %eax,%edi
80101206:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101207:	31 f6                	xor    %esi,%esi
{
80101209:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010120f:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101212:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101219:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010121c:	e8 0f 2f 00 00       	call   80104130 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101224:	eb 14                	jmp    8010123a <iget+0x3a>
80101226:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101228:	85 f6                	test   %esi,%esi
8010122a:	74 3c                	je     80101268 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101232:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101238:	74 46                	je     80101280 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010123a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010123d:	85 c9                	test   %ecx,%ecx
8010123f:	7e e7                	jle    80101228 <iget+0x28>
80101241:	39 3b                	cmp    %edi,(%ebx)
80101243:	75 e3                	jne    80101228 <iget+0x28>
80101245:	39 53 04             	cmp    %edx,0x4(%ebx)
80101248:	75 de                	jne    80101228 <iget+0x28>
      ip->ref++;
8010124a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010124d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010124f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101256:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101259:	e8 c2 2f 00 00       	call   80104220 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010125e:	83 c4 1c             	add    $0x1c,%esp
80101261:	89 f0                	mov    %esi,%eax
80101263:	5b                   	pop    %ebx
80101264:	5e                   	pop    %esi
80101265:	5f                   	pop    %edi
80101266:	5d                   	pop    %ebp
80101267:	c3                   	ret    
80101268:	85 c9                	test   %ecx,%ecx
8010126a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101273:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101279:	75 bf                	jne    8010123a <iget+0x3a>
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 29                	je     801012ad <iget+0xad>
  ip->dev = dev;
80101284:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101286:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101289:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101290:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101297:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010129e:	e8 7d 2f 00 00       	call   80104220 <release>
}
801012a3:	83 c4 1c             	add    $0x1c,%esp
801012a6:	89 f0                	mov    %esi,%eax
801012a8:	5b                   	pop    %ebx
801012a9:	5e                   	pop    %esi
801012aa:	5f                   	pop    %edi
801012ab:	5d                   	pop    %ebp
801012ac:	c3                   	ret    
    panic("iget: no inodes");
801012ad:	c7 04 24 95 6e 10 80 	movl   $0x80106e95,(%esp)
801012b4:	e8 a7 f0 ff ff       	call   80100360 <panic>
801012b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c3                	mov    %eax,%ebx
801012c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012cb:	83 fa 0b             	cmp    $0xb,%edx
801012ce:	77 18                	ja     801012e8 <bmap+0x28>
801012d0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012d3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012d6:	85 c0                	test   %eax,%eax
801012d8:	74 66                	je     80101340 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012da:	83 c4 1c             	add    $0x1c,%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret    
801012e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
801012e8:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801012eb:	83 fe 7f             	cmp    $0x7f,%esi
801012ee:	77 77                	ja     80101367 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
801012f0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 5e                	je     80101358 <bmap+0x98>
    bp = bread(ip->dev, addr);
801012fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801012fe:	8b 03                	mov    (%ebx),%eax
80101300:	89 04 24             	mov    %eax,(%esp)
80101303:	e8 c8 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101308:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
8010130c:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010130e:	8b 32                	mov    (%edx),%esi
80101310:	85 f6                	test   %esi,%esi
80101312:	75 19                	jne    8010132d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101314:	8b 03                	mov    (%ebx),%eax
80101316:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101319:	e8 c2 fd ff ff       	call   801010e0 <balloc>
8010131e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101321:	89 02                	mov    %eax,(%edx)
80101323:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101325:	89 3c 24             	mov    %edi,(%esp)
80101328:	e8 73 19 00 00       	call   80102ca0 <log_write>
    brelse(bp);
8010132d:	89 3c 24             	mov    %edi,(%esp)
80101330:	e8 ab ee ff ff       	call   801001e0 <brelse>
}
80101335:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
80101338:	89 f0                	mov    %esi,%eax
}
8010133a:	5b                   	pop    %ebx
8010133b:	5e                   	pop    %esi
8010133c:	5f                   	pop    %edi
8010133d:	5d                   	pop    %ebp
8010133e:	c3                   	ret    
8010133f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101340:	8b 03                	mov    (%ebx),%eax
80101342:	e8 99 fd ff ff       	call   801010e0 <balloc>
80101347:	89 46 5c             	mov    %eax,0x5c(%esi)
}
8010134a:	83 c4 1c             	add    $0x1c,%esp
8010134d:	5b                   	pop    %ebx
8010134e:	5e                   	pop    %esi
8010134f:	5f                   	pop    %edi
80101350:	5d                   	pop    %ebp
80101351:	c3                   	ret    
80101352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101358:	8b 03                	mov    (%ebx),%eax
8010135a:	e8 81 fd ff ff       	call   801010e0 <balloc>
8010135f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101365:	eb 93                	jmp    801012fa <bmap+0x3a>
  panic("bmap: out of range");
80101367:	c7 04 24 a5 6e 10 80 	movl   $0x80106ea5,(%esp)
8010136e:	e8 ed ef ff ff       	call   80100360 <panic>
80101373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101380 <readsb>:
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	56                   	push   %esi
80101384:	53                   	push   %ebx
80101385:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
80101388:	8b 45 08             	mov    0x8(%ebp),%eax
8010138b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101392:	00 
{
80101393:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101396:	89 04 24             	mov    %eax,(%esp)
80101399:	e8 32 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010139e:	89 34 24             	mov    %esi,(%esp)
801013a1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013a8:	00 
  bp = bread(dev, 1);
801013a9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013ab:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801013b2:	e8 59 2f 00 00       	call   80104310 <memmove>
  brelse(bp);
801013b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013ba:	83 c4 10             	add    $0x10,%esp
801013bd:	5b                   	pop    %ebx
801013be:	5e                   	pop    %esi
801013bf:	5d                   	pop    %ebp
  brelse(bp);
801013c0:	e9 1b ee ff ff       	jmp    801001e0 <brelse>
801013c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013d0 <bfree>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	89 d7                	mov    %edx,%edi
801013d6:	56                   	push   %esi
801013d7:	53                   	push   %ebx
801013d8:	89 c3                	mov    %eax,%ebx
801013da:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
801013dd:	89 04 24             	mov    %eax,(%esp)
801013e0:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801013e7:	80 
801013e8:	e8 93 ff ff ff       	call   80101380 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013ed:	89 fa                	mov    %edi,%edx
801013ef:	c1 ea 0c             	shr    $0xc,%edx
801013f2:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801013f8:	89 1c 24             	mov    %ebx,(%esp)
  m = 1 << (bi % 8);
801013fb:	bb 01 00 00 00       	mov    $0x1,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101400:	89 54 24 04          	mov    %edx,0x4(%esp)
80101404:	e8 c7 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101409:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
8010140b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101411:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101413:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101416:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101419:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010141b:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
8010141d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101422:	0f b6 c8             	movzbl %al,%ecx
80101425:	85 d9                	test   %ebx,%ecx
80101427:	74 20                	je     80101449 <bfree+0x79>
  bp->data[bi/8] &= ~m;
80101429:	f7 d3                	not    %ebx
8010142b:	21 c3                	and    %eax,%ebx
8010142d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 67 18 00 00       	call   80102ca0 <log_write>
  brelse(bp);
80101439:	89 34 24             	mov    %esi,(%esp)
8010143c:	e8 9f ed ff ff       	call   801001e0 <brelse>
}
80101441:	83 c4 1c             	add    $0x1c,%esp
80101444:	5b                   	pop    %ebx
80101445:	5e                   	pop    %esi
80101446:	5f                   	pop    %edi
80101447:	5d                   	pop    %ebp
80101448:	c3                   	ret    
    panic("freeing free block");
80101449:	c7 04 24 b8 6e 10 80 	movl   $0x80106eb8,(%esp)
80101450:	e8 0b ef ff ff       	call   80100360 <panic>
80101455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <iinit>:
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101469:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010146c:	c7 44 24 04 cb 6e 10 	movl   $0x80106ecb,0x4(%esp)
80101473:	80 
80101474:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010147b:	e8 c0 2b 00 00       	call   80104040 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
80101480:	89 1c 24             	mov    %ebx,(%esp)
80101483:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101489:	c7 44 24 04 d2 6e 10 	movl   $0x80106ed2,0x4(%esp)
80101490:	80 
80101491:	e8 9a 2a 00 00       	call   80103f30 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101496:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010149c:	75 e2                	jne    80101480 <iinit+0x20>
  readsb(dev, &sb);
8010149e:	8b 45 08             	mov    0x8(%ebp),%eax
801014a1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014a8:	80 
801014a9:	89 04 24             	mov    %eax,(%esp)
801014ac:	e8 cf fe ff ff       	call   80101380 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014b1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014b6:	c7 04 24 38 6f 10 80 	movl   $0x80106f38,(%esp)
801014bd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014c1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014c6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ca:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014cf:	89 44 24 14          	mov    %eax,0x14(%esp)
801014d3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014d8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014dc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801014e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014e5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801014ea:	89 44 24 08          	mov    %eax,0x8(%esp)
801014ee:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801014f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f7:	e8 54 f1 ff ff       	call   80100650 <cprintf>
}
801014fc:	83 c4 24             	add    $0x24,%esp
801014ff:	5b                   	pop    %ebx
80101500:	5d                   	pop    %ebp
80101501:	c3                   	ret    
80101502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 2c             	sub    $0x2c,%esp
80101519:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010151c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101523:	8b 7d 08             	mov    0x8(%ebp),%edi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 a2 00 00 00    	jbe    801015d1 <ialloc+0xc1>
8010152f:	be 01 00 00 00       	mov    $0x1,%esi
80101534:	bb 01 00 00 00       	mov    $0x1,%ebx
80101539:	eb 1a                	jmp    80101555 <ialloc+0x45>
8010153b:	90                   	nop
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101540:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	e8 95 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154b:	89 de                	mov    %ebx,%esi
8010154d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101553:	73 7c                	jae    801015d1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101555:	89 f0                	mov    %esi,%eax
80101557:	c1 e8 03             	shr    $0x3,%eax
8010155a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101560:	89 3c 24             	mov    %edi,(%esp)
80101563:	89 44 24 04          	mov    %eax,0x4(%esp)
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 f0                	mov    %esi,%eax
80101570:	83 e0 07             	and    $0x7,%eax
80101573:	c1 e0 06             	shl    $0x6,%eax
80101576:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010157e:	75 c0                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101580:	89 0c 24             	mov    %ecx,(%esp)
80101583:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010158a:	00 
8010158b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101592:	00 
80101593:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	e8 d2 2c 00 00       	call   80104270 <memset>
      dip->type = type;
8010159e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015a5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015ab:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ae:	89 14 24             	mov    %edx,(%esp)
801015b1:	e8 ea 16 00 00       	call   80102ca0 <log_write>
      brelse(bp);
801015b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015b9:	89 14 24             	mov    %edx,(%esp)
801015bc:	e8 1f ec ff ff       	call   801001e0 <brelse>
}
801015c1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015c4:	89 f2                	mov    %esi,%edx
}
801015c6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015c7:	89 f8                	mov    %edi,%eax
}
801015c9:	5e                   	pop    %esi
801015ca:	5f                   	pop    %edi
801015cb:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cc:	e9 2f fc ff ff       	jmp    80101200 <iget>
  panic("ialloc: no inodes");
801015d1:	c7 04 24 d8 6e 10 80 	movl   $0x80106ed8,(%esp)
801015d8:	e8 83 ed ff ff       	call   80100360 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	83 ec 10             	sub    $0x10,%esp
801015e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801015fe:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101601:	89 04 24             	mov    %eax,(%esp)
80101604:	e8 c7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101609:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010160c:	83 e2 07             	and    $0x7,%edx
8010160f:	c1 e2 06             	shl    $0x6,%edx
80101612:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101616:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101618:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010161f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101623:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101627:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010162b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010162f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101633:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101637:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010163b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010163e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101641:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101645:	89 14 24             	mov    %edx,(%esp)
80101648:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010164f:	00 
80101650:	e8 bb 2c 00 00       	call   80104310 <memmove>
  log_write(bp);
80101655:	89 34 24             	mov    %esi,(%esp)
80101658:	e8 43 16 00 00       	call   80102ca0 <log_write>
  brelse(bp);
8010165d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101660:	83 c4 10             	add    $0x10,%esp
80101663:	5b                   	pop    %ebx
80101664:	5e                   	pop    %esi
80101665:	5d                   	pop    %ebp
  brelse(bp);
80101666:	e9 75 eb ff ff       	jmp    801001e0 <brelse>
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <idup>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	83 ec 14             	sub    $0x14,%esp
80101677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010167a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101681:	e8 aa 2a 00 00       	call   80104130 <acquire>
  ip->ref++;
80101686:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010168a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101691:	e8 8a 2b 00 00       	call   80104220 <release>
}
80101696:	83 c4 14             	add    $0x14,%esp
80101699:	89 d8                	mov    %ebx,%eax
8010169b:	5b                   	pop    %ebx
8010169c:	5d                   	pop    %ebp
8010169d:	c3                   	ret    
8010169e:	66 90                	xchg   %ax,%ax

801016a0 <ilock>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	83 ec 10             	sub    $0x10,%esp
801016a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016ab:	85 db                	test   %ebx,%ebx
801016ad:	0f 84 b3 00 00 00    	je     80101766 <ilock+0xc6>
801016b3:	8b 53 08             	mov    0x8(%ebx),%edx
801016b6:	85 d2                	test   %edx,%edx
801016b8:	0f 8e a8 00 00 00    	jle    80101766 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016be:	8d 43 0c             	lea    0xc(%ebx),%eax
801016c1:	89 04 24             	mov    %eax,(%esp)
801016c4:	e8 a7 28 00 00       	call   80103f70 <acquiresleep>
  if(ip->valid == 0){
801016c9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016cc:	85 c0                	test   %eax,%eax
801016ce:	74 08                	je     801016d8 <ilock+0x38>
}
801016d0:	83 c4 10             	add    $0x10,%esp
801016d3:	5b                   	pop    %ebx
801016d4:	5e                   	pop    %esi
801016d5:	5d                   	pop    %ebp
801016d6:	c3                   	ret    
801016d7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
801016db:	c1 e8 03             	shr    $0x3,%eax
801016de:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016e8:	8b 03                	mov    (%ebx),%eax
801016ea:	89 04 24             	mov    %eax,(%esp)
801016ed:	e8 de e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f2:	8b 53 04             	mov    0x4(%ebx),%edx
801016f5:	83 e2 07             	and    $0x7,%edx
801016f8:	c1 e2 06             	shl    $0x6,%edx
801016fb:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ff:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101701:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101704:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101707:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010170b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010170f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101713:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101717:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010171b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010171f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101723:	8b 42 fc             	mov    -0x4(%edx),%eax
80101726:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101729:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010172c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101730:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101737:	00 
80101738:	89 04 24             	mov    %eax,(%esp)
8010173b:	e8 d0 2b 00 00       	call   80104310 <memmove>
    brelse(bp);
80101740:	89 34 24             	mov    %esi,(%esp)
80101743:	e8 98 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101748:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010174d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101754:	0f 85 76 ff ff ff    	jne    801016d0 <ilock+0x30>
      panic("ilock: no type");
8010175a:	c7 04 24 f0 6e 10 80 	movl   $0x80106ef0,(%esp)
80101761:	e8 fa eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101766:	c7 04 24 ea 6e 10 80 	movl   $0x80106eea,(%esp)
8010176d:	e8 ee eb ff ff       	call   80100360 <panic>
80101772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101780 <iunlock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010178b:	85 db                	test   %ebx,%ebx
8010178d:	74 24                	je     801017b3 <iunlock+0x33>
8010178f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101792:	89 34 24             	mov    %esi,(%esp)
80101795:	e8 76 28 00 00       	call   80104010 <holdingsleep>
8010179a:	85 c0                	test   %eax,%eax
8010179c:	74 15                	je     801017b3 <iunlock+0x33>
8010179e:	8b 43 08             	mov    0x8(%ebx),%eax
801017a1:	85 c0                	test   %eax,%eax
801017a3:	7e 0e                	jle    801017b3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017a5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	5b                   	pop    %ebx
801017ac:	5e                   	pop    %esi
801017ad:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017ae:	e9 1d 28 00 00       	jmp    80103fd0 <releasesleep>
    panic("iunlock");
801017b3:	c7 04 24 ff 6e 10 80 	movl   $0x80106eff,(%esp)
801017ba:	e8 a1 eb ff ff       	call   80100360 <panic>
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 1c             	sub    $0x1c,%esp
801017c9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017cc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017cf:	89 3c 24             	mov    %edi,(%esp)
801017d2:	e8 99 27 00 00       	call   80103f70 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017da:	85 d2                	test   %edx,%edx
801017dc:	74 07                	je     801017e5 <iput+0x25>
801017de:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017e3:	74 2b                	je     80101810 <iput+0x50>
  releasesleep(&ip->lock);
801017e5:	89 3c 24             	mov    %edi,(%esp)
801017e8:	e8 e3 27 00 00       	call   80103fd0 <releasesleep>
  acquire(&icache.lock);
801017ed:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f4:	e8 37 29 00 00       	call   80104130 <acquire>
  ip->ref--;
801017f9:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017fd:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101804:	83 c4 1c             	add    $0x1c,%esp
80101807:	5b                   	pop    %ebx
80101808:	5e                   	pop    %esi
80101809:	5f                   	pop    %edi
8010180a:	5d                   	pop    %ebp
  release(&icache.lock);
8010180b:	e9 10 2a 00 00       	jmp    80104220 <release>
    acquire(&icache.lock);
80101810:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101817:	e8 14 29 00 00       	call   80104130 <acquire>
    int r = ip->ref;
8010181c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010181f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101826:	e8 f5 29 00 00       	call   80104220 <release>
    if(r == 1){
8010182b:	83 fb 01             	cmp    $0x1,%ebx
8010182e:	75 b5                	jne    801017e5 <iput+0x25>
80101830:	8d 4e 30             	lea    0x30(%esi),%ecx
80101833:	89 f3                	mov    %esi,%ebx
80101835:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x87>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fb                	cmp    %edi,%ebx
80101845:	74 19                	je     80101860 <iput+0xa0>
    if(ip->addrs[i]){
80101847:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010184a:	85 d2                	test   %edx,%edx
8010184c:	74 f2                	je     80101840 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010184e:	8b 06                	mov    (%esi),%eax
80101850:	e8 7b fb ff ff       	call   801013d0 <bfree>
      ip->addrs[i] = 0;
80101855:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010185c:	eb e2                	jmp    80101840 <iput+0x80>
8010185e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 2b                	jne    80101898 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010186d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101874:	89 34 24             	mov    %esi,(%esp)
80101877:	e8 64 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010187c:	31 c0                	xor    %eax,%eax
8010187e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101882:	89 34 24             	mov    %esi,(%esp)
80101885:	e8 56 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010188a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101891:	e9 4f ff ff ff       	jmp    801017e5 <iput+0x25>
80101896:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101898:	89 44 24 04          	mov    %eax,0x4(%esp)
8010189c:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
8010189e:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	89 04 24             	mov    %eax,(%esp)
801018a3:	e8 28 e8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018a8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018ab:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018b1:	89 cf                	mov    %ecx,%edi
801018b3:	31 c0                	xor    %eax,%eax
801018b5:	eb 0e                	jmp    801018c5 <iput+0x105>
801018b7:	90                   	nop
801018b8:	83 c3 01             	add    $0x1,%ebx
801018bb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018c1:	89 d8                	mov    %ebx,%eax
801018c3:	74 10                	je     801018d5 <iput+0x115>
      if(a[j])
801018c5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018c8:	85 d2                	test   %edx,%edx
801018ca:	74 ec                	je     801018b8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018cc:	8b 06                	mov    (%esi),%eax
801018ce:	e8 fd fa ff ff       	call   801013d0 <bfree>
801018d3:	eb e3                	jmp    801018b8 <iput+0xf8>
    brelse(bp);
801018d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018db:	89 04 24             	mov    %eax,(%esp)
801018de:	e8 fd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018e3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e9:	8b 06                	mov    (%esi),%eax
801018eb:	e8 e0 fa ff ff       	call   801013d0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f0:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f7:	00 00 00 
801018fa:	e9 6e ff ff ff       	jmp    8010186d <iput+0xad>
801018ff:	90                   	nop

80101900 <iunlockput>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 14             	sub    $0x14,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	89 1c 24             	mov    %ebx,(%esp)
8010190d:	e8 6e fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101912:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101915:	83 c4 14             	add    $0x14,%esp
80101918:	5b                   	pop    %ebx
80101919:	5d                   	pop    %ebp
  iput(ip);
8010191a:	e9 a1 fe ff ff       	jmp    801017c0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 2c             	sub    $0x2c,%esp
80101959:	8b 45 0c             	mov    0xc(%ebp),%eax
8010195c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
80101962:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101965:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101968:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010196d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101970:	0f 84 aa 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101976:	8b 47 58             	mov    0x58(%edi),%eax
80101979:	39 f0                	cmp    %esi,%eax
8010197b:	0f 82 c7 00 00 00    	jb     80101a48 <readi+0xf8>
80101981:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101984:	89 da                	mov    %ebx,%edx
80101986:	01 f2                	add    %esi,%edx
80101988:	0f 82 ba 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010198e:	89 c1                	mov    %eax,%ecx
80101990:	29 f1                	sub    %esi,%ecx
80101992:	39 d0                	cmp    %edx,%eax
80101994:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101997:	31 c0                	xor    %eax,%eax
80101999:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
8010199b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199e:	74 70                	je     80101a10 <readi+0xc0>
801019a0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019a3:	89 c7                	mov    %eax,%edi
801019a5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019ab:	89 f2                	mov    %esi,%edx
801019ad:	c1 ea 09             	shr    $0x9,%edx
801019b0:	89 d8                	mov    %ebx,%eax
801019b2:	e8 09 f9 ff ff       	call   801012c0 <bmap>
801019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019bb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019bd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c2:	89 04 24             	mov    %eax,(%esp)
801019c5:	e8 06 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019cd:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	89 f0                	mov    %esi,%eax
801019d3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019d8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019da:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019de:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019e7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ea:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ee:	01 df                	add    %ebx,%edi
801019f0:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801019f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019f5:	89 04 24             	mov    %eax,(%esp)
801019f8:	e8 13 29 00 00       	call   80104310 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a0e:	77 98                	ja     801019a8 <readi+0x58>
  }
  return n;
80101a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a13:	83 c4 2c             	add    $0x2c,%esp
80101a16:	5b                   	pop    %ebx
80101a17:	5e                   	pop    %esi
80101a18:	5f                   	pop    %edi
80101a19:	5d                   	pop    %ebp
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a35:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a38:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a3b:	83 c4 2c             	add    $0x2c,%esp
80101a3e:	5b                   	pop    %ebx
80101a3f:	5e                   	pop    %esi
80101a40:	5f                   	pop    %edi
80101a41:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a42:	ff e0                	jmp    *%eax
80101a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c4                	jmp    80101a13 <readi+0xc3>
80101a4f:	90                   	nop

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 2c             	sub    $0x2c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a70:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 e3 00 00 00    	jb     80101b68 <writei+0x118>
80101a85:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a88:	89 c8                	mov    %ecx,%eax
80101a8a:	01 f0                	add    %esi,%eax
80101a8c:	0f 82 d6 00 00 00    	jb     80101b68 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a92:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a97:	0f 87 cb 00 00 00    	ja     80101b68 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9d:	85 c9                	test   %ecx,%ecx
80101a9f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa6:	74 77                	je     80101b1f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aab:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aad:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab2:	c1 ea 09             	shr    $0x9,%edx
80101ab5:	89 f8                	mov    %edi,%eax
80101ab7:	e8 04 f8 ff ff       	call   801012c0 <bmap>
80101abc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ac0:	8b 07                	mov    (%edi),%eax
80101ac2:	89 04 24             	mov    %eax,(%esp)
80101ac5:	e8 06 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101acd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ad0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad5:	89 f0                	mov    %esi,%eax
80101ad7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101adc:	29 c3                	sub    %eax,%ebx
80101ade:	39 cb                	cmp    %ecx,%ebx
80101ae0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae7:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101aed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101af1:	89 04 24             	mov    %eax,(%esp)
80101af4:	e8 17 28 00 00       	call   80104310 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 9f 11 00 00       	call   80102ca0 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b0f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b12:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b15:	77 91                	ja     80101aa8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b17:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b1d:	72 39                	jb     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b22:	83 c4 2c             	add    $0x2c,%esp
80101b25:	5b                   	pop    %ebx
80101b26:	5e                   	pop    %esi
80101b27:	5f                   	pop    %edi
80101b28:	5d                   	pop    %ebp
80101b29:	c3                   	ret    
80101b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 2e                	ja     80101b68 <writei+0x118>
80101b3a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 23                	je     80101b68 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b48:	83 c4 2c             	add    $0x2c,%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b5e:	89 04 24             	mov    %eax,(%esp)
80101b61:	e8 7a fa ff ff       	call   801015e0 <iupdate>
80101b66:	eb b7                	jmp    80101b1f <writei+0xcf>
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b70:	5b                   	pop    %ebx
80101b71:	5e                   	pop    %esi
80101b72:	5f                   	pop    %edi
80101b73:	5d                   	pop    %ebp
80101b74:	c3                   	ret    
80101b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b89:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b90:	00 
80101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b95:	8b 45 08             	mov    0x8(%ebp),%eax
80101b98:	89 04 24             	mov    %eax,(%esp)
80101b9b:	e8 f0 27 00 00       	call   80104390 <strncmp>
}
80101ba0:	c9                   	leave  
80101ba1:	c3                   	ret    
80101ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 2c             	sub    $0x2c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 97 00 00 00    	jne    80101c5e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	75 0d                	jne    80101be0 <dirlookup+0x30>
80101bd3:	eb 73                	jmp    80101c48 <dirlookup+0x98>
80101bd5:	8d 76 00             	lea    0x0(%esi),%esi
80101bd8:	83 c7 10             	add    $0x10,%edi
80101bdb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bde:	76 68                	jbe    80101c48 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101be7:	00 
80101be8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bec:	89 74 24 04          	mov    %esi,0x4(%esp)
80101bf0:	89 1c 24             	mov    %ebx,(%esp)
80101bf3:	e8 58 fd ff ff       	call   80101950 <readi>
80101bf8:	83 f8 10             	cmp    $0x10,%eax
80101bfb:	75 55                	jne    80101c52 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c02:	74 d4                	je     80101bd8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c04:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c0e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c15:	00 
80101c16:	89 04 24             	mov    %eax,(%esp)
80101c19:	e8 72 27 00 00       	call   80104390 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c1e:	85 c0                	test   %eax,%eax
80101c20:	75 b6                	jne    80101bd8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c22:	8b 45 10             	mov    0x10(%ebp),%eax
80101c25:	85 c0                	test   %eax,%eax
80101c27:	74 05                	je     80101c2e <dirlookup+0x7e>
        *poff = off;
80101c29:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c32:	8b 03                	mov    (%ebx),%eax
80101c34:	e8 c7 f5 ff ff       	call   80101200 <iget>
    }
  }

  return 0;
}
80101c39:	83 c4 2c             	add    $0x2c,%esp
80101c3c:	5b                   	pop    %ebx
80101c3d:	5e                   	pop    %esi
80101c3e:	5f                   	pop    %edi
80101c3f:	5d                   	pop    %ebp
80101c40:	c3                   	ret    
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c48:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c4b:	31 c0                	xor    %eax,%eax
}
80101c4d:	5b                   	pop    %ebx
80101c4e:	5e                   	pop    %esi
80101c4f:	5f                   	pop    %edi
80101c50:	5d                   	pop    %ebp
80101c51:	c3                   	ret    
      panic("dirlookup read");
80101c52:	c7 04 24 19 6f 10 80 	movl   $0x80106f19,(%esp)
80101c59:	e8 02 e7 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c5e:	c7 04 24 07 6f 10 80 	movl   $0x80106f07,(%esp)
80101c65:	e8 f6 e6 ff ff       	call   80100360 <panic>
80101c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	89 cf                	mov    %ecx,%edi
80101c76:	56                   	push   %esi
80101c77:	53                   	push   %ebx
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 51 01 00 00    	je     80101dda <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 02 1a 00 00       	call   80103690 <myproc>
80101c8e:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c91:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c98:	e8 93 24 00 00       	call   80104130 <acquire>
  ip->ref++;
80101c9d:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca8:	e8 73 25 00 00       	call   80104220 <release>
80101cad:	eb 04                	jmp    80101cb3 <namex+0x43>
80101caf:	90                   	nop
    path++;
80101cb0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cb3:	0f b6 03             	movzbl (%ebx),%eax
80101cb6:	3c 2f                	cmp    $0x2f,%al
80101cb8:	74 f6                	je     80101cb0 <namex+0x40>
  if(*path == 0)
80101cba:	84 c0                	test   %al,%al
80101cbc:	0f 84 ed 00 00 00    	je     80101daf <namex+0x13f>
  while(*path != '/' && *path != 0)
80101cc2:	0f b6 03             	movzbl (%ebx),%eax
80101cc5:	89 da                	mov    %ebx,%edx
80101cc7:	84 c0                	test   %al,%al
80101cc9:	0f 84 b1 00 00 00    	je     80101d80 <namex+0x110>
80101ccf:	3c 2f                	cmp    $0x2f,%al
80101cd1:	75 0f                	jne    80101ce2 <namex+0x72>
80101cd3:	e9 a8 00 00 00       	jmp    80101d80 <namex+0x110>
80101cd8:	3c 2f                	cmp    $0x2f,%al
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ce0:	74 0a                	je     80101cec <namex+0x7c>
    path++;
80101ce2:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce5:	0f b6 02             	movzbl (%edx),%eax
80101ce8:	84 c0                	test   %al,%al
80101cea:	75 ec                	jne    80101cd8 <namex+0x68>
80101cec:	89 d1                	mov    %edx,%ecx
80101cee:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf0:	83 f9 0d             	cmp    $0xd,%ecx
80101cf3:	0f 8e 8f 00 00 00    	jle    80101d88 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cf9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101cfd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d04:	00 
80101d05:	89 3c 24             	mov    %edi,(%esp)
80101d08:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d0b:	e8 00 26 00 00       	call   80104310 <memmove>
    path++;
80101d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d13:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d15:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d18:	75 0e                	jne    80101d28 <namex+0xb8>
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	89 34 24             	mov    %esi,(%esp)
80101d2b:	e8 70 f9 ff ff       	call   801016a0 <ilock>
    if(ip->type != T_DIR){
80101d30:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d35:	0f 85 85 00 00 00    	jne    80101dc0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d3e:	85 d2                	test   %edx,%edx
80101d40:	74 09                	je     80101d4b <namex+0xdb>
80101d42:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d45:	0f 84 a5 00 00 00    	je     80101df0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d52:	00 
80101d53:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d57:	89 34 24             	mov    %esi,(%esp)
80101d5a:	e8 51 fe ff ff       	call   80101bb0 <dirlookup>
80101d5f:	85 c0                	test   %eax,%eax
80101d61:	74 5d                	je     80101dc0 <namex+0x150>
  iunlock(ip);
80101d63:	89 34 24             	mov    %esi,(%esp)
80101d66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d69:	e8 12 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	89 c6                	mov    %eax,%esi
80101d7b:	e9 33 ff ff ff       	jmp    80101cb3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101d80:	31 c9                	xor    %ecx,%ecx
80101d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101d88:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d8c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d90:	89 3c 24             	mov    %edi,(%esp)
80101d93:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d96:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d99:	e8 72 25 00 00       	call   80104310 <memmove>
    name[len] = 0;
80101d9e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101da8:	89 d3                	mov    %edx,%ebx
80101daa:	e9 66 ff ff ff       	jmp    80101d15 <namex+0xa5>
  }
  if(nameiparent){
80101daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101db2:	85 c0                	test   %eax,%eax
80101db4:	75 4c                	jne    80101e02 <namex+0x192>
80101db6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101db8:	83 c4 2c             	add    $0x2c,%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
80101dbf:	c3                   	ret    
  iunlock(ip);
80101dc0:	89 34 24             	mov    %esi,(%esp)
80101dc3:	e8 b8 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101dc8:	89 34 24             	mov    %esi,(%esp)
80101dcb:	e8 f0 f9 ff ff       	call   801017c0 <iput>
}
80101dd0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101dd3:	31 c0                	xor    %eax,%eax
}
80101dd5:	5b                   	pop    %ebx
80101dd6:	5e                   	pop    %esi
80101dd7:	5f                   	pop    %edi
80101dd8:	5d                   	pop    %ebp
80101dd9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dda:	ba 01 00 00 00       	mov    $0x1,%edx
80101ddf:	b8 01 00 00 00       	mov    $0x1,%eax
80101de4:	e8 17 f4 ff ff       	call   80101200 <iget>
80101de9:	89 c6                	mov    %eax,%esi
80101deb:	e9 c3 fe ff ff       	jmp    80101cb3 <namex+0x43>
      iunlock(ip);
80101df0:	89 34 24             	mov    %esi,(%esp)
80101df3:	e8 88 f9 ff ff       	call   80101780 <iunlock>
}
80101df8:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101dfb:	89 f0                	mov    %esi,%eax
}
80101dfd:	5b                   	pop    %ebx
80101dfe:	5e                   	pop    %esi
80101dff:	5f                   	pop    %edi
80101e00:	5d                   	pop    %ebp
80101e01:	c3                   	ret    
    iput(ip);
80101e02:	89 34 24             	mov    %esi,(%esp)
80101e05:	e8 b6 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e0a:	31 c0                	xor    %eax,%eax
80101e0c:	eb aa                	jmp    80101db8 <namex+0x148>
80101e0e:	66 90                	xchg   %ax,%ax

80101e10 <dirlink>:
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 2c             	sub    $0x2c,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e26:	00 
80101e27:	89 1c 24             	mov    %ebx,(%esp)
80101e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e2e:	e8 7d fd ff ff       	call   80101bb0 <dirlookup>
80101e33:	85 c0                	test   %eax,%eax
80101e35:	0f 85 8b 00 00 00    	jne    80101ec6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e3e:	31 ff                	xor    %edi,%edi
80101e40:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e43:	85 c0                	test   %eax,%eax
80101e45:	75 13                	jne    80101e5a <dirlink+0x4a>
80101e47:	eb 35                	jmp    80101e7e <dirlink+0x6e>
80101e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e50:	8d 57 10             	lea    0x10(%edi),%edx
80101e53:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e56:	89 d7                	mov    %edx,%edi
80101e58:	76 24                	jbe    80101e7e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e61:	00 
80101e62:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e66:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e6a:	89 1c 24             	mov    %ebx,(%esp)
80101e6d:	e8 de fa ff ff       	call   80101950 <readi>
80101e72:	83 f8 10             	cmp    $0x10,%eax
80101e75:	75 5e                	jne    80101ed5 <dirlink+0xc5>
    if(de.inum == 0)
80101e77:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7c:	75 d2                	jne    80101e50 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e81:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e88:	00 
80101e89:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e8d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e90:	89 04 24             	mov    %eax,(%esp)
80101e93:	e8 68 25 00 00       	call   80104400 <strncpy>
  de.inum = inum;
80101e98:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ea2:	00 
80101ea3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ea7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eab:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101eae:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb2:	e8 99 fb ff ff       	call   80101a50 <writei>
80101eb7:	83 f8 10             	cmp    $0x10,%eax
80101eba:	75 25                	jne    80101ee1 <dirlink+0xd1>
  return 0;
80101ebc:	31 c0                	xor    %eax,%eax
}
80101ebe:	83 c4 2c             	add    $0x2c,%esp
80101ec1:	5b                   	pop    %ebx
80101ec2:	5e                   	pop    %esi
80101ec3:	5f                   	pop    %edi
80101ec4:	5d                   	pop    %ebp
80101ec5:	c3                   	ret    
    iput(ip);
80101ec6:	89 04 24             	mov    %eax,(%esp)
80101ec9:	e8 f2 f8 ff ff       	call   801017c0 <iput>
    return -1;
80101ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed3:	eb e9                	jmp    80101ebe <dirlink+0xae>
      panic("dirlink read");
80101ed5:	c7 04 24 28 6f 10 80 	movl   $0x80106f28,(%esp)
80101edc:	e8 7f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101ee1:	c7 04 24 26 75 10 80 	movl   $0x80107526,(%esp)
80101ee8:	e8 73 e4 ff ff       	call   80100360 <panic>
80101eed:	8d 76 00             	lea    0x0(%esi),%esi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	56                   	push   %esi
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	53                   	push   %ebx
80101f37:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f3a:	85 c0                	test   %eax,%eax
80101f3c:	0f 84 99 00 00 00    	je     80101fdb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f42:	8b 48 08             	mov    0x8(%eax),%ecx
80101f45:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f4b:	0f 87 7e 00 00 00    	ja     80101fcf <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f51:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f59:	83 e0 c0             	and    $0xffffffc0,%eax
80101f5c:	3c 40                	cmp    $0x40,%al
80101f5e:	75 f8                	jne    80101f58 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f60:	31 db                	xor    %ebx,%ebx
80101f62:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f67:	89 d8                	mov    %ebx,%eax
80101f69:	ee                   	out    %al,(%dx)
80101f6a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f74:	ee                   	out    %al,(%dx)
80101f75:	0f b6 c1             	movzbl %cl,%eax
80101f78:	b2 f3                	mov    $0xf3,%dl
80101f7a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f7b:	89 c8                	mov    %ecx,%eax
80101f7d:	b2 f4                	mov    $0xf4,%dl
80101f7f:	c1 f8 08             	sar    $0x8,%eax
80101f82:	ee                   	out    %al,(%dx)
80101f83:	b2 f5                	mov    $0xf5,%dl
80101f85:	89 d8                	mov    %ebx,%eax
80101f87:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f88:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8c:	b2 f6                	mov    $0xf6,%dl
80101f8e:	83 e0 01             	and    $0x1,%eax
80101f91:	c1 e0 04             	shl    $0x4,%eax
80101f94:	83 c8 e0             	or     $0xffffffe0,%eax
80101f97:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f98:	f6 06 04             	testb  $0x4,(%esi)
80101f9b:	75 13                	jne    80101fb0 <idestart+0x80>
80101f9d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5d                   	pop    %ebp
80101fae:	c3                   	ret    
80101faf:	90                   	nop
80101fb0:	b2 f7                	mov    $0xf7,%dl
80101fb2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fb7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fb8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fbd:	83 c6 5c             	add    $0x5c,%esi
80101fc0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fc5:	fc                   	cld    
80101fc6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
    panic("incorrect blockno");
80101fcf:	c7 04 24 94 6f 10 80 	movl   $0x80106f94,(%esp)
80101fd6:	e8 85 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101fdb:	c7 04 24 8b 6f 10 80 	movl   $0x80106f8b,(%esp)
80101fe2:	e8 79 e3 ff ff       	call   80100360 <panic>
80101fe7:	89 f6                	mov    %esi,%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ff0 <ideinit>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80101ff6:	c7 44 24 04 a6 6f 10 	movl   $0x80106fa6,0x4(%esp)
80101ffd:	80 
80101ffe:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102005:	e8 36 20 00 00       	call   80104040 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010200a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010200f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102016:	83 e8 01             	sub    $0x1,%eax
80102019:	89 44 24 04          	mov    %eax,0x4(%esp)
8010201d:	e8 7e 02 00 00       	call   801022a0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102022:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102027:	90                   	nop
80102028:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102029:	83 e0 c0             	and    $0xffffffc0,%eax
8010202c:	3c 40                	cmp    $0x40,%al
8010202e:	75 f8                	jne    80102028 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102030:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102035:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203a:	ee                   	out    %al,(%dx)
8010203b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102040:	b2 f7                	mov    $0xf7,%dl
80102042:	eb 09                	jmp    8010204d <ideinit+0x5d>
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102048:	83 e9 01             	sub    $0x1,%ecx
8010204b:	74 0f                	je     8010205c <ideinit+0x6c>
8010204d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010204e:	84 c0                	test   %al,%al
80102050:	74 f6                	je     80102048 <ideinit+0x58>
      havedisk1 = 1;
80102052:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102059:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010205c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102061:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102066:	ee                   	out    %al,(%dx)
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102079:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102080:	e8 ab 20 00 00       	call   80104130 <acquire>

  if((b = idequeue) == 0){
80102085:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010208b:	85 db                	test   %ebx,%ebx
8010208d:	74 30                	je     801020bf <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010208f:	8b 43 58             	mov    0x58(%ebx),%eax
80102092:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102097:	8b 33                	mov    (%ebx),%esi
80102099:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010209f:	74 37                	je     801020d8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020a1:	83 e6 fb             	and    $0xfffffffb,%esi
801020a4:	83 ce 02             	or     $0x2,%esi
801020a7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020a9:	89 1c 24             	mov    %ebx,(%esp)
801020ac:	e8 cf 1c 00 00       	call   80103d80 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020b1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020b6:	85 c0                	test   %eax,%eax
801020b8:	74 05                	je     801020bf <ideintr+0x4f>
    idestart(idequeue);
801020ba:	e8 71 fe ff ff       	call   80101f30 <idestart>
    release(&idelock);
801020bf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020c6:	e8 55 21 00 00       	call   80104220 <release>

  release(&idelock);
}
801020cb:	83 c4 1c             	add    $0x1c,%esp
801020ce:	5b                   	pop    %ebx
801020cf:	5e                   	pop    %esi
801020d0:	5f                   	pop    %edi
801020d1:	5d                   	pop    %ebp
801020d2:	c3                   	ret    
801020d3:	90                   	nop
801020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020dd:	8d 76 00             	lea    0x0(%esi),%esi
801020e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c1                	mov    %eax,%ecx
801020e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020e6:	80 f9 40             	cmp    $0x40,%cl
801020e9:	75 f5                	jne    801020e0 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020eb:	a8 21                	test   $0x21,%al
801020ed:	75 b2                	jne    801020a1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
801020ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fc:	fc                   	cld    
801020fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801020ff:	8b 33                	mov    (%ebx),%esi
80102101:	eb 9e                	jmp    801020a1 <ideintr+0x31>
80102103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 14             	sub    $0x14,%esp
80102117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010211a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010211d:	89 04 24             	mov    %eax,(%esp)
80102120:	e8 eb 1e 00 00       	call   80104010 <holdingsleep>
80102125:	85 c0                	test   %eax,%eax
80102127:	0f 84 9e 00 00 00    	je     801021cb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010212d:	8b 03                	mov    (%ebx),%eax
8010212f:	83 e0 06             	and    $0x6,%eax
80102132:	83 f8 02             	cmp    $0x2,%eax
80102135:	0f 84 a8 00 00 00    	je     801021e3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010213b:	8b 53 04             	mov    0x4(%ebx),%edx
8010213e:	85 d2                	test   %edx,%edx
80102140:	74 0d                	je     8010214f <iderw+0x3f>
80102142:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102147:	85 c0                	test   %eax,%eax
80102149:	0f 84 88 00 00 00    	je     801021d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010214f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102156:	e8 d5 1f 00 00       	call   80104130 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010215b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102160:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102167:	85 c0                	test   %eax,%eax
80102169:	75 07                	jne    80102172 <iderw+0x62>
8010216b:	eb 4e                	jmp    801021bb <iderw+0xab>
8010216d:	8d 76 00             	lea    0x0(%esi),%esi
80102170:	89 d0                	mov    %edx,%eax
80102172:	8b 50 58             	mov    0x58(%eax),%edx
80102175:	85 d2                	test   %edx,%edx
80102177:	75 f7                	jne    80102170 <iderw+0x60>
80102179:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010217c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010217e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102184:	74 3c                	je     801021c2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102186:	8b 03                	mov    (%ebx),%eax
80102188:	83 e0 06             	and    $0x6,%eax
8010218b:	83 f8 02             	cmp    $0x2,%eax
8010218e:	74 1a                	je     801021aa <iderw+0x9a>
    sleep(b, &idelock);
80102190:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102197:	80 
80102198:	89 1c 24             	mov    %ebx,(%esp)
8010219b:	e8 50 1a 00 00       	call   80103bf0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a0:	8b 13                	mov    (%ebx),%edx
801021a2:	83 e2 06             	and    $0x6,%edx
801021a5:	83 fa 02             	cmp    $0x2,%edx
801021a8:	75 e6                	jne    80102190 <iderw+0x80>
  }


  release(&idelock);
801021aa:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021b1:	83 c4 14             	add    $0x14,%esp
801021b4:	5b                   	pop    %ebx
801021b5:	5d                   	pop    %ebp
  release(&idelock);
801021b6:	e9 65 20 00 00       	jmp    80104220 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021c0:	eb ba                	jmp    8010217c <iderw+0x6c>
    idestart(b);
801021c2:	89 d8                	mov    %ebx,%eax
801021c4:	e8 67 fd ff ff       	call   80101f30 <idestart>
801021c9:	eb bb                	jmp    80102186 <iderw+0x76>
    panic("iderw: buf not locked");
801021cb:	c7 04 24 aa 6f 10 80 	movl   $0x80106faa,(%esp)
801021d2:	e8 89 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021d7:	c7 04 24 d5 6f 10 80 	movl   $0x80106fd5,(%esp)
801021de:	e8 7d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
801021e3:	c7 04 24 c0 6f 10 80 	movl   $0x80106fc0,(%esp)
801021ea:	e8 71 e1 ff ff       	call   80100360 <panic>
801021ef:	90                   	nop

801021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	56                   	push   %esi
801021f4:	53                   	push   %ebx
801021f5:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021f8:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021ff:	00 c0 fe 
  ioapic->reg = reg;
80102202:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102209:	00 00 00 
  return ioapic->data;
8010220c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102212:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102215:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010221b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102221:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102228:	c1 e8 10             	shr    $0x10,%eax
8010222b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010222e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102231:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102234:	39 c2                	cmp    %eax,%edx
80102236:	74 12                	je     8010224a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102238:	c7 04 24 f4 6f 10 80 	movl   $0x80106ff4,(%esp)
8010223f:	e8 0c e4 ff ff       	call   80100650 <cprintf>
80102244:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010224a:	ba 10 00 00 00       	mov    $0x10,%edx
8010224f:	31 c0                	xor    %eax,%eax
80102251:	eb 07                	jmp    8010225a <ioapicinit+0x6a>
80102253:	90                   	nop
80102254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102258:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010225a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010225c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102262:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102265:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010226b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010226e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102271:	8d 4a 01             	lea    0x1(%edx),%ecx
80102274:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102277:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102279:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010227f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
80102281:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102288:	7d ce                	jge    80102258 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010228a:	83 c4 10             	add    $0x10,%esp
8010228d:	5b                   	pop    %ebx
8010228e:	5e                   	pop    %esi
8010228f:	5d                   	pop    %ebp
80102290:	c3                   	ret    
80102291:	eb 0d                	jmp    801022a0 <ioapicenable>
80102293:	90                   	nop
80102294:	90                   	nop
80102295:	90                   	nop
80102296:	90                   	nop
80102297:	90                   	nop
80102298:	90                   	nop
80102299:	90                   	nop
8010229a:	90                   	nop
8010229b:	90                   	nop
8010229c:	90                   	nop
8010229d:	90                   	nop
8010229e:	90                   	nop
8010229f:	90                   	nop

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	8b 55 08             	mov    0x8(%ebp),%edx
801022a6:	53                   	push   %ebx
801022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022aa:	8d 5a 20             	lea    0x20(%edx),%ebx
801022ad:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022b1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022ba:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022bc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022c5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022c8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ca:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022d0:	89 42 10             	mov    %eax,0x10(%edx)
}
801022d3:	5b                   	pop    %ebx
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	66 90                	xchg   %ax,%ax
801022d8:	66 90                	xchg   %ax,%ax
801022da:	66 90                	xchg   %ax,%ax
801022dc:	66 90                	xchg   %ax,%ax
801022de:	66 90                	xchg   %ax,%ax

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 14             	sub    $0x14,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 7c                	jne    8010236e <kfree+0x8e>
801022f2:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
801022f8:	72 74                	jb     8010236e <kfree+0x8e>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 67                	ja     8010236e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010230e:	00 
8010230f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102316:	00 
80102317:	89 1c 24             	mov    %ebx,(%esp)
8010231a:	e8 51 1f 00 00       	call   80104270 <memset>

  if(kmem.use_lock)
8010231f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102325:	85 d2                	test   %edx,%edx
80102327:	75 37                	jne    80102360 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102329:	a1 78 26 11 80       	mov    0x80112678,%eax
8010232e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102330:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102335:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010233b:	85 c0                	test   %eax,%eax
8010233d:	75 09                	jne    80102348 <kfree+0x68>
    release(&kmem.lock);
}
8010233f:	83 c4 14             	add    $0x14,%esp
80102342:	5b                   	pop    %ebx
80102343:	5d                   	pop    %ebp
80102344:	c3                   	ret    
80102345:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102348:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
    release(&kmem.lock);
80102354:	e9 c7 1e 00 00       	jmp    80104220 <release>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102360:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102367:	e8 c4 1d 00 00       	call   80104130 <acquire>
8010236c:	eb bb                	jmp    80102329 <kfree+0x49>
    panic("kfree");
8010236e:	c7 04 24 26 70 10 80 	movl   $0x80107026,(%esp)
80102375:	e8 e6 df ff ff       	call   80100360 <panic>
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <freerange>:
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102388:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010238b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010238e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102394:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023a0:	39 de                	cmp    %ebx,%esi
801023a2:	73 08                	jae    801023ac <freerange+0x2c>
801023a4:	eb 18                	jmp    801023be <freerange+0x3e>
801023a6:	66 90                	xchg   %ax,%ax
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ac:	89 14 24             	mov    %edx,(%esp)
801023af:	e8 2c ff ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ba:	39 f0                	cmp    %esi,%eax
801023bc:	76 ea                	jbe    801023a8 <freerange+0x28>
}
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	5b                   	pop    %ebx
801023c2:	5e                   	pop    %esi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <kinit1>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	83 ec 10             	sub    $0x10,%esp
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023db:	c7 44 24 04 2c 70 10 	movl   $0x8010702c,0x4(%esp)
801023e2:	80 
801023e3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023ea:	e8 51 1c 00 00       	call   80104040 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
801023f2:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023f9:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801023fc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102402:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102408:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010240e:	39 de                	cmp    %ebx,%esi
80102410:	73 0a                	jae    8010241c <kinit1+0x4c>
80102412:	eb 1a                	jmp    8010242e <kinit1+0x5e>
80102414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102418:	89 da                	mov    %ebx,%edx
8010241a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010241c:	89 14 24             	mov    %edx,(%esp)
8010241f:	e8 bc fe ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102424:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010242a:	39 c6                	cmp    %eax,%esi
8010242c:	73 ea                	jae    80102418 <kinit1+0x48>
}
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010244b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010244e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102454:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 08                	jae    8010246c <kinit2+0x2c>
80102464:	eb 18                	jmp    8010247e <kinit2+0x3e>
80102466:	66 90                	xchg   %ax,%ax
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 6c fe ff ff       	call   801022e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 c6                	cmp    %eax,%esi
8010247c:	73 ea                	jae    80102468 <kinit2+0x28>
  kmem.use_lock = 1;
8010247e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102485:	00 00 00 
}
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5d                   	pop    %ebp
8010248e:	c3                   	ret    
8010248f:	90                   	nop

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 74 26 11 80       	mov    0x80112674,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 08                	je     801024b2 <kalloc+0x22>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 0c                	je     801024c2 <kalloc+0x32>
    release(&kmem.lock);
801024b6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024bd:	e8 5e 1d 00 00       	call   80104220 <release>
  return (char*)r;
}
801024c2:	83 c4 14             	add    $0x14,%esp
801024c5:	89 d8                	mov    %ebx,%eax
801024c7:	5b                   	pop    %ebx
801024c8:	5d                   	pop    %ebp
801024c9:	c3                   	ret    
801024ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024d0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024d7:	e8 54 1c 00 00       	call   80104130 <acquire>
801024dc:	a1 74 26 11 80       	mov    0x80112674,%eax
801024e1:	eb bd                	jmp    801024a0 <kalloc+0x10>
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f0:	ba 64 00 00 00       	mov    $0x64,%edx
801024f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f6:	a8 01                	test   $0x1,%al
801024f8:	0f 84 ba 00 00 00    	je     801025b8 <kbdgetc+0xc8>
801024fe:	b2 60                	mov    $0x60,%dl
80102500:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102501:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102504:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010250a:	0f 84 88 00 00 00    	je     80102598 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102510:	84 c0                	test   %al,%al
80102512:	79 2c                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010251a:	f6 c2 40             	test   $0x40,%dl
8010251d:	75 05                	jne    80102524 <kbdgetc+0x34>
8010251f:	89 c1                	mov    %eax,%ecx
80102521:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102524:	0f b6 81 60 71 10 80 	movzbl -0x7fef8ea0(%ecx),%eax
8010252b:	83 c8 40             	or     $0x40,%eax
8010252e:	0f b6 c0             	movzbl %al,%eax
80102531:	f7 d0                	not    %eax
80102533:	21 d0                	and    %edx,%eax
80102535:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253a:	31 c0                	xor    %eax,%eax
8010253c:	c3                   	ret    
8010253d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010254a:	f6 c3 40             	test   $0x40,%bl
8010254d:	74 09                	je     80102558 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102552:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102555:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102558:	0f b6 91 60 71 10 80 	movzbl -0x7fef8ea0(%ecx),%edx
  shift ^= togglecode[data];
8010255f:	0f b6 81 60 70 10 80 	movzbl -0x7fef8fa0(%ecx),%eax
  shift |= shiftcode[data];
80102566:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102568:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010256a:	89 d0                	mov    %edx,%eax
8010256c:	83 e0 03             	and    $0x3,%eax
8010256f:	8b 04 85 40 70 10 80 	mov    -0x7fef8fc0(,%eax,4),%eax
  shift ^= togglecode[data];
80102576:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
8010257c:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010257f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102583:	74 0b                	je     80102590 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102585:	8d 50 9f             	lea    -0x61(%eax),%edx
80102588:	83 fa 19             	cmp    $0x19,%edx
8010258b:	77 1b                	ja     801025a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010258d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102590:	5b                   	pop    %ebx
80102591:	5d                   	pop    %ebp
80102592:	c3                   	ret    
80102593:	90                   	nop
80102594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102598:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010259f:	31 c0                	xor    %eax,%eax
801025a1:	c3                   	ret    
801025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025ab:	8d 50 20             	lea    0x20(%eax),%edx
801025ae:	83 f9 19             	cmp    $0x19,%ecx
801025b1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025b4:	eb da                	jmp    80102590 <kbdgetc+0xa0>
801025b6:	66 90                	xchg   %ax,%ax
    return -1;
801025b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax

801025c0 <kbdintr>:

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025c6:	c7 04 24 f0 24 10 80 	movl   $0x801024f0,(%esp)
801025cd:	e8 de e1 ff ff       	call   801007b0 <consoleintr>
}
801025d2:	c9                   	leave  
801025d3:	c3                   	ret    
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025e0:	55                   	push   %ebp
801025e1:	89 c1                	mov    %eax,%ecx
801025e3:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e5:	ba 70 00 00 00       	mov    $0x70,%edx
801025ea:	53                   	push   %ebx
801025eb:	31 c0                	xor    %eax,%eax
801025ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ee:	bb 71 00 00 00       	mov    $0x71,%ebx
801025f3:	89 da                	mov    %ebx,%edx
801025f5:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
801025f6:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f9:	b2 70                	mov    $0x70,%dl
801025fb:	89 01                	mov    %eax,(%ecx)
801025fd:	b8 02 00 00 00       	mov    $0x2,%eax
80102602:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
80102606:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 41 04             	mov    %eax,0x4(%ecx)
8010260e:	b8 04 00 00 00       	mov    $0x4,%eax
80102613:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102614:	89 da                	mov    %ebx,%edx
80102616:	ec                   	in     (%dx),%al
80102617:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261a:	b2 70                	mov    $0x70,%dl
8010261c:	89 41 08             	mov    %eax,0x8(%ecx)
8010261f:	b8 07 00 00 00       	mov    $0x7,%eax
80102624:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102625:	89 da                	mov    %ebx,%edx
80102627:	ec                   	in     (%dx),%al
80102628:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262b:	b2 70                	mov    $0x70,%dl
8010262d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102630:	b8 08 00 00 00       	mov    $0x8,%eax
80102635:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102636:	89 da                	mov    %ebx,%edx
80102638:	ec                   	in     (%dx),%al
80102639:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263c:	b2 70                	mov    $0x70,%dl
8010263e:	89 41 10             	mov    %eax,0x10(%ecx)
80102641:	b8 09 00 00 00       	mov    $0x9,%eax
80102646:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102647:	89 da                	mov    %ebx,%edx
80102649:	ec                   	in     (%dx),%al
8010264a:	0f b6 d8             	movzbl %al,%ebx
8010264d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102650:	5b                   	pop    %ebx
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret    
80102653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <lapicinit>:
  if(!lapic)
80102660:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c0 00 00 00    	je     80102730 <lapicinit+0xd0>
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 6f                	ja     80102738 <lapicinit+0xd8>
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102718:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010271e:	80 e6 10             	and    $0x10,%dh
80102721:	75 f5                	jne    80102718 <lapicinit+0xb8>
  lapic[index] = value;
80102723:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102730:	5d                   	pop    %ebp
80102731:	c3                   	ret    
80102732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102738:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010273f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102742:	8b 50 20             	mov    0x20(%eax),%edx
80102745:	eb 82                	jmp    801026c9 <lapicinit+0x69>
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicid>:
  if (!lapic)
80102750:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0c                	je     80102768 <lapicid+0x18>
  return lapic[ID] >> 24;
8010275c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010275f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102760:	c1 e8 18             	shr    $0x18,%eax
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102768:	31 c0                	xor    %eax,%eax
}
8010276a:	5d                   	pop    %ebp
8010276b:	c3                   	ret    
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <lapiceoi>:
  if(lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0d                	je     80102789 <lapiceoi+0x19>
  lapic[index] = value;
8010277c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102783:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 40 20             	mov    0x20(%eax),%eax
}
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <microdelay>:
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
}
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicstartap>:
{
801027a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	ba 70 00 00 00       	mov    $0x70,%edx
801027a6:	89 e5                	mov    %esp,%ebp
801027a8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027ad:	53                   	push   %ebx
801027ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027b4:	ee                   	out    %al,(%dx)
801027b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ba:	b2 71                	mov    $0x71,%dl
801027bc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027bd:	31 c0                	xor    %eax,%eax
801027bf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027c5:	89 d8                	mov    %ebx,%eax
801027c7:	c1 e8 04             	shr    $0x4,%eax
801027ca:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
801027d5:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027d8:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
801027db:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027eb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fe:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102807:	89 da                	mov    %ebx,%edx
80102809:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010280c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102812:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102815:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010281e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 40 20             	mov    0x20(%eax),%eax
}
80102827:	5b                   	pop    %ebx
80102828:	5d                   	pop    %ebp
80102829:	c3                   	ret    
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102830 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	ba 70 00 00 00       	mov    $0x70,%edx
80102836:	89 e5                	mov    %esp,%ebp
80102838:	b8 0b 00 00 00       	mov    $0xb,%eax
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 4c             	sub    $0x4c,%esp
80102843:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	b2 71                	mov    $0x71,%dl
80102846:	ec                   	in     (%dx),%al
80102847:	88 45 b7             	mov    %al,-0x49(%ebp)
8010284a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010284d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102851:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010285d:	89 d8                	mov    %ebx,%eax
8010285f:	e8 7c fd ff ff       	call   801025e0 <fill_rtcdate>
80102864:	b8 0a 00 00 00       	mov    $0xa,%eax
80102869:	89 f2                	mov    %esi,%edx
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	ba 71 00 00 00       	mov    $0x71,%edx
80102871:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102872:	84 c0                	test   %al,%al
80102874:	78 e7                	js     8010285d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102876:	89 f8                	mov    %edi,%eax
80102878:	e8 63 fd ff ff       	call   801025e0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010287d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102884:	00 
80102885:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102889:	89 1c 24             	mov    %ebx,(%esp)
8010288c:	e8 2f 1a 00 00       	call   801042c0 <memcmp>
80102891:	85 c0                	test   %eax,%eax
80102893:	75 c3                	jne    80102858 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102895:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102899:	75 78                	jne    80102913 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010289b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010289e:	89 c2                	mov    %eax,%edx
801028a0:	83 e0 0f             	and    $0xf,%eax
801028a3:	c1 ea 04             	shr    $0x4,%edx
801028a6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028a9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028ac:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028af:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028b2:	89 c2                	mov    %eax,%edx
801028b4:	83 e0 0f             	and    $0xf,%eax
801028b7:	c1 ea 04             	shr    $0x4,%edx
801028ba:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028bd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028c0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028c6:	89 c2                	mov    %eax,%edx
801028c8:	83 e0 0f             	and    $0xf,%eax
801028cb:	c1 ea 04             	shr    $0x4,%edx
801028ce:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028d1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028da:	89 c2                	mov    %eax,%edx
801028dc:	83 e0 0f             	and    $0xf,%eax
801028df:	c1 ea 04             	shr    $0x4,%edx
801028e2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028ee:	89 c2                	mov    %eax,%edx
801028f0:	83 e0 0f             	and    $0xf,%eax
801028f3:	c1 ea 04             	shr    $0x4,%edx
801028f6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801028ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102902:	89 c2                	mov    %eax,%edx
80102904:	83 e0 0f             	and    $0xf,%eax
80102907:	c1 ea 04             	shr    $0x4,%edx
8010290a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010290d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102910:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102913:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102916:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102919:	89 01                	mov    %eax,(%ecx)
8010291b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010291e:	89 41 04             	mov    %eax,0x4(%ecx)
80102921:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102924:	89 41 08             	mov    %eax,0x8(%ecx)
80102927:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010292a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010292d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102930:	89 41 10             	mov    %eax,0x10(%ecx)
80102933:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102936:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102939:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102940:	83 c4 4c             	add    $0x4c,%esp
80102943:	5b                   	pop    %ebx
80102944:	5e                   	pop    %esi
80102945:	5f                   	pop    %edi
80102946:	5d                   	pop    %ebp
80102947:	c3                   	ret    
80102948:	66 90                	xchg   %ax,%ax
8010294a:	66 90                	xchg   %ax,%ax
8010294c:	66 90                	xchg   %ax,%ax
8010294e:	66 90                	xchg   %ax,%ax

80102950 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102950:	55                   	push   %ebp
80102951:	89 e5                	mov    %esp,%ebp
80102953:	57                   	push   %edi
80102954:	56                   	push   %esi
80102955:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102956:	31 db                	xor    %ebx,%ebx
{
80102958:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010295b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102960:	85 c0                	test   %eax,%eax
80102962:	7e 78                	jle    801029dc <install_trans+0x8c>
80102964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102968:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010296d:	01 d8                	add    %ebx,%eax
8010296f:	83 c0 01             	add    $0x1,%eax
80102972:	89 44 24 04          	mov    %eax,0x4(%esp)
80102976:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010297b:	89 04 24             	mov    %eax,(%esp)
8010297e:	e8 4d d7 ff ff       	call   801000d0 <bread>
80102983:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102985:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
8010298c:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010298f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102993:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102998:	89 04 24             	mov    %eax,(%esp)
8010299b:	e8 30 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029a0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029a7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029a8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029aa:	8d 47 5c             	lea    0x5c(%edi),%eax
801029ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029b4:	89 04 24             	mov    %eax,(%esp)
801029b7:	e8 54 19 00 00       	call   80104310 <memmove>
    bwrite(dbuf);  // write dst to disk
801029bc:	89 34 24             	mov    %esi,(%esp)
801029bf:	e8 dc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029c4:	89 3c 24             	mov    %edi,(%esp)
801029c7:	e8 14 d8 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029cc:	89 34 24             	mov    %esi,(%esp)
801029cf:	e8 0c d8 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029d4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029da:	7f 8c                	jg     80102968 <install_trans+0x18>
  }
}
801029dc:	83 c4 1c             	add    $0x1c,%esp
801029df:	5b                   	pop    %ebx
801029e0:	5e                   	pop    %esi
801029e1:	5f                   	pop    %edi
801029e2:	5d                   	pop    %ebp
801029e3:	c3                   	ret    
801029e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801029f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	57                   	push   %edi
801029f4:	56                   	push   %esi
801029f5:	53                   	push   %ebx
801029f6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
801029f9:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a02:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a07:	89 04 24             	mov    %eax,(%esp)
80102a0a:	e8 c1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a0f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a15:	31 d2                	xor    %edx,%edx
80102a17:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a19:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a1b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a1e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a21:	7e 17                	jle    80102a3a <write_head+0x4a>
80102a23:	90                   	nop
80102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a28:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a2f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a33:	83 c2 01             	add    $0x1,%edx
80102a36:	39 da                	cmp    %ebx,%edx
80102a38:	75 ee                	jne    80102a28 <write_head+0x38>
  }
  bwrite(buf);
80102a3a:	89 3c 24             	mov    %edi,(%esp)
80102a3d:	e8 5e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a42:	89 3c 24             	mov    %edi,(%esp)
80102a45:	e8 96 d7 ff ff       	call   801001e0 <brelse>
}
80102a4a:	83 c4 1c             	add    $0x1c,%esp
80102a4d:	5b                   	pop    %ebx
80102a4e:	5e                   	pop    %esi
80102a4f:	5f                   	pop    %edi
80102a50:	5d                   	pop    %ebp
80102a51:	c3                   	ret    
80102a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <initlog>:
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	56                   	push   %esi
80102a64:	53                   	push   %ebx
80102a65:	83 ec 30             	sub    $0x30,%esp
80102a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a6b:	c7 44 24 04 60 72 10 	movl   $0x80107260,0x4(%esp)
80102a72:	80 
80102a73:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a7a:	e8 c1 15 00 00       	call   80104040 <initlock>
  readsb(dev, &sb);
80102a7f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a82:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a86:	89 1c 24             	mov    %ebx,(%esp)
80102a89:	e8 f2 e8 ff ff       	call   80101380 <readsb>
  log.start = sb.logstart;
80102a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102a91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102a94:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102a97:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102aa1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102aa7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102aac:	e8 1f d6 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ab1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102ab3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ab6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ab9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102abb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ac1:	7e 17                	jle    80102ada <initlog+0x7a>
80102ac3:	90                   	nop
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ac8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102acc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ad3:	83 c2 01             	add    $0x1,%edx
80102ad6:	39 da                	cmp    %ebx,%edx
80102ad8:	75 ee                	jne    80102ac8 <initlog+0x68>
  brelse(buf);
80102ada:	89 04 24             	mov    %eax,(%esp)
80102add:	e8 fe d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ae2:	e8 69 fe ff ff       	call   80102950 <install_trans>
  log.lh.n = 0;
80102ae7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102aee:	00 00 00 
  write_head(); // clear the log
80102af1:	e8 fa fe ff ff       	call   801029f0 <write_head>
}
80102af6:	83 c4 30             	add    $0x30,%esp
80102af9:	5b                   	pop    %ebx
80102afa:	5e                   	pop    %esi
80102afb:	5d                   	pop    %ebp
80102afc:	c3                   	ret    
80102afd:	8d 76 00             	lea    0x0(%esi),%esi

80102b00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b06:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b0d:	e8 1e 16 00 00       	call   80104130 <acquire>
80102b12:	eb 18                	jmp    80102b2c <begin_op+0x2c>
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b18:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b1f:	80 
80102b20:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b27:	e8 c4 10 00 00       	call   80103bf0 <sleep>
    if(log.committing){
80102b2c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b31:	85 c0                	test   %eax,%eax
80102b33:	75 e3                	jne    80102b18 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b35:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b3a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b40:	83 c0 01             	add    $0x1,%eax
80102b43:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b46:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b49:	83 fa 1e             	cmp    $0x1e,%edx
80102b4c:	7f ca                	jg     80102b18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b4e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b55:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b5a:	e8 c1 16 00 00       	call   80104220 <release>
      break;
    }
  }
}
80102b5f:	c9                   	leave  
80102b60:	c3                   	ret    
80102b61:	eb 0d                	jmp    80102b70 <end_op>
80102b63:	90                   	nop
80102b64:	90                   	nop
80102b65:	90                   	nop
80102b66:	90                   	nop
80102b67:	90                   	nop
80102b68:	90                   	nop
80102b69:	90                   	nop
80102b6a:	90                   	nop
80102b6b:	90                   	nop
80102b6c:	90                   	nop
80102b6d:	90                   	nop
80102b6e:	90                   	nop
80102b6f:	90                   	nop

80102b70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	57                   	push   %edi
80102b74:	56                   	push   %esi
80102b75:	53                   	push   %ebx
80102b76:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b79:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b80:	e8 ab 15 00 00       	call   80104130 <acquire>
  log.outstanding -= 1;
80102b85:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102b8a:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102b90:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102b93:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102b95:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102b9a:	0f 85 f3 00 00 00    	jne    80102c93 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102ba0:	85 c0                	test   %eax,%eax
80102ba2:	0f 85 cb 00 00 00    	jne    80102c73 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ba8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102baf:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102bb1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bb8:	00 00 00 
  release(&log.lock);
80102bbb:	e8 60 16 00 00       	call   80104220 <release>
  if (log.lh.n > 0) {
80102bc0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bc5:	85 c0                	test   %eax,%eax
80102bc7:	0f 8e 90 00 00 00    	jle    80102c5d <end_op+0xed>
80102bcd:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bd0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bd5:	01 d8                	add    %ebx,%eax
80102bd7:	83 c0 01             	add    $0x1,%eax
80102bda:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bde:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102be3:	89 04 24             	mov    %eax,(%esp)
80102be6:	e8 e5 d4 ff ff       	call   801000d0 <bread>
80102beb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bed:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102bf4:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bfb:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c00:	89 04 24             	mov    %eax,(%esp)
80102c03:	e8 c8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c08:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c0f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c10:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c12:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c15:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c19:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1c:	89 04 24             	mov    %eax,(%esp)
80102c1f:	e8 ec 16 00 00       	call   80104310 <memmove>
    bwrite(to);  // write the log
80102c24:	89 34 24             	mov    %esi,(%esp)
80102c27:	e8 74 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c2c:	89 3c 24             	mov    %edi,(%esp)
80102c2f:	e8 ac d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c34:	89 34 24             	mov    %esi,(%esp)
80102c37:	e8 a4 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c3c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c42:	7c 8c                	jl     80102bd0 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c44:	e8 a7 fd ff ff       	call   801029f0 <write_head>
    install_trans(); // Now install writes to home locations
80102c49:	e8 02 fd ff ff       	call   80102950 <install_trans>
    log.lh.n = 0;
80102c4e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c55:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c58:	e8 93 fd ff ff       	call   801029f0 <write_head>
    acquire(&log.lock);
80102c5d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c64:	e8 c7 14 00 00       	call   80104130 <acquire>
    log.committing = 0;
80102c69:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c70:	00 00 00 
    wakeup(&log);
80102c73:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c7a:	e8 01 11 00 00       	call   80103d80 <wakeup>
    release(&log.lock);
80102c7f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c86:	e8 95 15 00 00       	call   80104220 <release>
}
80102c8b:	83 c4 1c             	add    $0x1c,%esp
80102c8e:	5b                   	pop    %ebx
80102c8f:	5e                   	pop    %esi
80102c90:	5f                   	pop    %edi
80102c91:	5d                   	pop    %ebp
80102c92:	c3                   	ret    
    panic("log.committing");
80102c93:	c7 04 24 64 72 10 80 	movl   $0x80107264,(%esp)
80102c9a:	e8 c1 d6 ff ff       	call   80100360 <panic>
80102c9f:	90                   	nop

80102ca0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ca7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102cac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102caf:	83 f8 1d             	cmp    $0x1d,%eax
80102cb2:	0f 8f 98 00 00 00    	jg     80102d50 <log_write+0xb0>
80102cb8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cbe:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cc1:	39 d0                	cmp    %edx,%eax
80102cc3:	0f 8d 87 00 00 00    	jge    80102d50 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cc9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cce:	85 c0                	test   %eax,%eax
80102cd0:	0f 8e 86 00 00 00    	jle    80102d5c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cd6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cdd:	e8 4e 14 00 00       	call   80104130 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ce2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ce8:	83 fa 00             	cmp    $0x0,%edx
80102ceb:	7e 54                	jle    80102d41 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ced:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102cf0:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102cf2:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102cf8:	75 0f                	jne    80102d09 <log_write+0x69>
80102cfa:	eb 3c                	jmp    80102d38 <log_write+0x98>
80102cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d00:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d07:	74 2f                	je     80102d38 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d09:	83 c0 01             	add    $0x1,%eax
80102d0c:	39 d0                	cmp    %edx,%eax
80102d0e:	75 f0                	jne    80102d00 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d10:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d17:	83 c2 01             	add    $0x1,%edx
80102d1a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d20:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d23:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d2a:	83 c4 14             	add    $0x14,%esp
80102d2d:	5b                   	pop    %ebx
80102d2e:	5d                   	pop    %ebp
  release(&log.lock);
80102d2f:	e9 ec 14 00 00       	jmp    80104220 <release>
80102d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d38:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d3f:	eb df                	jmp    80102d20 <log_write+0x80>
80102d41:	8b 43 08             	mov    0x8(%ebx),%eax
80102d44:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d49:	75 d5                	jne    80102d20 <log_write+0x80>
80102d4b:	eb ca                	jmp    80102d17 <log_write+0x77>
80102d4d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d50:	c7 04 24 73 72 10 80 	movl   $0x80107273,(%esp)
80102d57:	e8 04 d6 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d5c:	c7 04 24 89 72 10 80 	movl   $0x80107289,(%esp)
80102d63:	e8 f8 d5 ff ff       	call   80100360 <panic>
80102d68:	66 90                	xchg   %ax,%ax
80102d6a:	66 90                	xchg   %ax,%ax
80102d6c:	66 90                	xchg   %ax,%ax
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d77:	e8 f4 08 00 00       	call   80103670 <cpuid>
80102d7c:	89 c3                	mov    %eax,%ebx
80102d7e:	e8 ed 08 00 00       	call   80103670 <cpuid>
80102d83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d87:	c7 04 24 a4 72 10 80 	movl   $0x801072a4,(%esp)
80102d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d92:	e8 b9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102d97:	e8 34 27 00 00       	call   801054d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102d9c:	e8 4f 08 00 00       	call   801035f0 <mycpu>
80102da1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102da3:	b8 01 00 00 00       	mov    $0x1,%eax
80102da8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102daf:	e8 9c 0b 00 00       	call   80103950 <scheduler>
80102db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102dc0 <mpenter>:
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102dc6:	e8 c5 37 00 00       	call   80106590 <switchkvm>
  seginit();
80102dcb:	e8 80 36 00 00       	call   80106450 <seginit>
  lapicinit();
80102dd0:	e8 8b f8 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102dd5:	e8 96 ff ff ff       	call   80102d70 <mpmain>
80102dda:	66 90                	xchg   %ax,%ax
80102ddc:	66 90                	xchg   %ax,%ax
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <main>:
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102de4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102de9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dec:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102def:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102df6:	80 
80102df7:	c7 04 24 f4 58 11 80 	movl   $0x801158f4,(%esp)
80102dfe:	e8 cd f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e03:	e8 38 3c 00 00       	call   80106a40 <kvmalloc>
  mpinit();        // detect other processors
80102e08:	e8 73 01 00 00       	call   80102f80 <mpinit>
80102e0d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e10:	e8 4b f8 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102e15:	e8 36 36 00 00       	call   80106450 <seginit>
  picinit();       // disable pic
80102e1a:	e8 21 03 00 00       	call   80103140 <picinit>
80102e1f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e20:	e8 cb f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102e25:	e8 26 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e2a:	e8 c1 29 00 00       	call   801057f0 <uartinit>
80102e2f:	90                   	nop
  pinit();         // process table
80102e30:	e8 9b 07 00 00       	call   801035d0 <pinit>
  shminit();       // shared memory
80102e35:	e8 f6 3e 00 00       	call   80106d30 <shminit>
  tvinit();        // trap vectors
80102e3a:	e8 f1 25 00 00       	call   80105430 <tvinit>
80102e3f:	90                   	nop
  binit();         // buffer cache
80102e40:	e8 fb d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e45:	e8 e6 de ff ff       	call   80100d30 <fileinit>
  ideinit();       // disk 
80102e4a:	e8 a1 f1 ff ff       	call   80101ff0 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e4f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e56:	00 
80102e57:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e5e:	80 
80102e5f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e66:	e8 a5 14 00 00       	call   80104310 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e6b:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e72:	00 00 00 
80102e75:	05 80 27 11 80       	add    $0x80112780,%eax
80102e7a:	39 d8                	cmp    %ebx,%eax
80102e7c:	76 65                	jbe    80102ee3 <main+0x103>
80102e7e:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102e80:	e8 6b 07 00 00       	call   801035f0 <mycpu>
80102e85:	39 d8                	cmp    %ebx,%eax
80102e87:	74 41                	je     80102eca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e89:	e8 02 f6 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102e8e:	c7 05 f8 6f 00 80 c0 	movl   $0x80102dc0,0x80006ff8
80102e95:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e98:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e9f:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ea2:	05 00 10 00 00       	add    $0x1000,%eax
80102ea7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102eac:	0f b6 03             	movzbl (%ebx),%eax
80102eaf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102eb6:	00 
80102eb7:	89 04 24             	mov    %eax,(%esp)
80102eba:	e8 e1 f8 ff ff       	call   801027a0 <lapicstartap>
80102ebf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ec0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ec6:	85 c0                	test   %eax,%eax
80102ec8:	74 f6                	je     80102ec0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102eca:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ed1:	00 00 00 
80102ed4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eda:	05 80 27 11 80       	add    $0x80112780,%eax
80102edf:	39 c3                	cmp    %eax,%ebx
80102ee1:	72 9d                	jb     80102e80 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ee3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102eea:	8e 
80102eeb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102ef2:	e8 49 f5 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80102ef7:	e8 c4 07 00 00       	call   801036c0 <userinit>
  mpmain();        // finish this processor's setup
80102efc:	e8 6f fe ff ff       	call   80102d70 <mpmain>
80102f01:	66 90                	xchg   %ax,%ax
80102f03:	66 90                	xchg   %ax,%ax
80102f05:	66 90                	xchg   %ax,%ax
80102f07:	66 90                	xchg   %ax,%ax
80102f09:	66 90                	xchg   %ax,%ax
80102f0b:	66 90                	xchg   %ax,%ax
80102f0d:	66 90                	xchg   %ax,%ax
80102f0f:	90                   	nop

80102f10 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f14:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f1a:	53                   	push   %ebx
  e = addr+len;
80102f1b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f1e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f21:	39 de                	cmp    %ebx,%esi
80102f23:	73 3c                	jae    80102f61 <mpsearch1+0x51>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f28:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f2f:	00 
80102f30:	c7 44 24 04 b8 72 10 	movl   $0x801072b8,0x4(%esp)
80102f37:	80 
80102f38:	89 34 24             	mov    %esi,(%esp)
80102f3b:	e8 80 13 00 00       	call   801042c0 <memcmp>
80102f40:	85 c0                	test   %eax,%eax
80102f42:	75 16                	jne    80102f5a <mpsearch1+0x4a>
80102f44:	31 c9                	xor    %ecx,%ecx
80102f46:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f48:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f4c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f4f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f51:	83 fa 10             	cmp    $0x10,%edx
80102f54:	75 f2                	jne    80102f48 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f56:	84 c9                	test   %cl,%cl
80102f58:	74 10                	je     80102f6a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f5a:	83 c6 10             	add    $0x10,%esi
80102f5d:	39 f3                	cmp    %esi,%ebx
80102f5f:	77 c7                	ja     80102f28 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f61:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f64:	31 c0                	xor    %eax,%eax
}
80102f66:	5b                   	pop    %ebx
80102f67:	5e                   	pop    %esi
80102f68:	5d                   	pop    %ebp
80102f69:	c3                   	ret    
80102f6a:	83 c4 10             	add    $0x10,%esp
80102f6d:	89 f0                	mov    %esi,%eax
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5d                   	pop    %ebp
80102f72:	c3                   	ret    
80102f73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f80 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
80102f85:	53                   	push   %ebx
80102f86:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f89:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102f90:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102f97:	c1 e0 08             	shl    $0x8,%eax
80102f9a:	09 d0                	or     %edx,%eax
80102f9c:	c1 e0 04             	shl    $0x4,%eax
80102f9f:	85 c0                	test   %eax,%eax
80102fa1:	75 1b                	jne    80102fbe <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fa3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102faa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fb1:	c1 e0 08             	shl    $0x8,%eax
80102fb4:	09 d0                	or     %edx,%eax
80102fb6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fb9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102fbe:	ba 00 04 00 00       	mov    $0x400,%edx
80102fc3:	e8 48 ff ff ff       	call   80102f10 <mpsearch1>
80102fc8:	85 c0                	test   %eax,%eax
80102fca:	89 c7                	mov    %eax,%edi
80102fcc:	0f 84 22 01 00 00    	je     801030f4 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fd2:	8b 77 04             	mov    0x4(%edi),%esi
80102fd5:	85 f6                	test   %esi,%esi
80102fd7:	0f 84 30 01 00 00    	je     8010310d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fdd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80102fe3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fea:	00 
80102feb:	c7 44 24 04 bd 72 10 	movl   $0x801072bd,0x4(%esp)
80102ff2:	80 
80102ff3:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ff6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102ff9:	e8 c2 12 00 00       	call   801042c0 <memcmp>
80102ffe:	85 c0                	test   %eax,%eax
80103000:	0f 85 07 01 00 00    	jne    8010310d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103006:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010300d:	3c 04                	cmp    $0x4,%al
8010300f:	0f 85 0b 01 00 00    	jne    80103120 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103015:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010301c:	85 c0                	test   %eax,%eax
8010301e:	74 21                	je     80103041 <mpinit+0xc1>
  sum = 0;
80103020:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103022:	31 d2                	xor    %edx,%edx
80103024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103028:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010302f:	80 
  for(i=0; i<len; i++)
80103030:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103033:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103035:	39 d0                	cmp    %edx,%eax
80103037:	7f ef                	jg     80103028 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103039:	84 c9                	test   %cl,%cl
8010303b:	0f 85 cc 00 00 00    	jne    8010310d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103044:	85 c0                	test   %eax,%eax
80103046:	0f 84 c1 00 00 00    	je     8010310d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010304c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103052:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103057:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010305c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103063:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103069:	03 55 e4             	add    -0x1c(%ebp),%edx
8010306c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103070:	39 c2                	cmp    %eax,%edx
80103072:	76 1b                	jbe    8010308f <mpinit+0x10f>
80103074:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103077:	80 f9 04             	cmp    $0x4,%cl
8010307a:	77 74                	ja     801030f0 <mpinit+0x170>
8010307c:	ff 24 8d fc 72 10 80 	jmp    *-0x7fef8d04(,%ecx,4)
80103083:	90                   	nop
80103084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103088:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010308b:	39 c2                	cmp    %eax,%edx
8010308d:	77 e5                	ja     80103074 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010308f:	85 db                	test   %ebx,%ebx
80103091:	0f 84 93 00 00 00    	je     8010312a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103097:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010309b:	74 12                	je     801030af <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010309d:	ba 22 00 00 00       	mov    $0x22,%edx
801030a2:	b8 70 00 00 00       	mov    $0x70,%eax
801030a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a8:	b2 23                	mov    $0x23,%dl
801030aa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030ab:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ae:	ee                   	out    %al,(%dx)
  }
}
801030af:	83 c4 1c             	add    $0x1c,%esp
801030b2:	5b                   	pop    %ebx
801030b3:	5e                   	pop    %esi
801030b4:	5f                   	pop    %edi
801030b5:	5d                   	pop    %ebp
801030b6:	c3                   	ret    
801030b7:	90                   	nop
      if(ncpu < NCPU) {
801030b8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030be:	83 fe 07             	cmp    $0x7,%esi
801030c1:	7f 17                	jg     801030da <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030c3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030c7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030cd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030d4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
801030da:	83 c0 14             	add    $0x14,%eax
      continue;
801030dd:	eb 91                	jmp    80103070 <mpinit+0xf0>
801030df:	90                   	nop
      ioapicid = ioapic->apicno;
801030e0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801030e4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801030e7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
801030ed:	eb 81                	jmp    80103070 <mpinit+0xf0>
801030ef:	90                   	nop
      ismp = 0;
801030f0:	31 db                	xor    %ebx,%ebx
801030f2:	eb 83                	jmp    80103077 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
801030f4:	ba 00 00 01 00       	mov    $0x10000,%edx
801030f9:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801030fe:	e8 0d fe ff ff       	call   80102f10 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103103:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103105:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103107:	0f 85 c5 fe ff ff    	jne    80102fd2 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010310d:	c7 04 24 c2 72 10 80 	movl   $0x801072c2,(%esp)
80103114:	e8 47 d2 ff ff       	call   80100360 <panic>
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103120:	3c 01                	cmp    $0x1,%al
80103122:	0f 84 ed fe ff ff    	je     80103015 <mpinit+0x95>
80103128:	eb e3                	jmp    8010310d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010312a:	c7 04 24 dc 72 10 80 	movl   $0x801072dc,(%esp)
80103131:	e8 2a d2 ff ff       	call   80100360 <panic>
80103136:	66 90                	xchg   %ax,%ax
80103138:	66 90                	xchg   %ax,%ax
8010313a:	66 90                	xchg   %ax,%ax
8010313c:	66 90                	xchg   %ax,%ax
8010313e:	66 90                	xchg   %ax,%ax

80103140 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103140:	55                   	push   %ebp
80103141:	ba 21 00 00 00       	mov    $0x21,%edx
80103146:	89 e5                	mov    %esp,%ebp
80103148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010314d:	ee                   	out    %al,(%dx)
8010314e:	b2 a1                	mov    $0xa1,%dl
80103150:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103151:	5d                   	pop    %ebp
80103152:	c3                   	ret    
80103153:	66 90                	xchg   %ax,%ax
80103155:	66 90                	xchg   %ax,%ax
80103157:	66 90                	xchg   %ax,%ax
80103159:	66 90                	xchg   %ax,%ax
8010315b:	66 90                	xchg   %ax,%ax
8010315d:	66 90                	xchg   %ax,%ax
8010315f:	90                   	nop

80103160 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
80103165:	53                   	push   %ebx
80103166:	83 ec 1c             	sub    $0x1c,%esp
80103169:	8b 75 08             	mov    0x8(%ebp),%esi
8010316c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010316f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103175:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010317b:	e8 d0 db ff ff       	call   80100d50 <filealloc>
80103180:	85 c0                	test   %eax,%eax
80103182:	89 06                	mov    %eax,(%esi)
80103184:	0f 84 a4 00 00 00    	je     8010322e <pipealloc+0xce>
8010318a:	e8 c1 db ff ff       	call   80100d50 <filealloc>
8010318f:	85 c0                	test   %eax,%eax
80103191:	89 03                	mov    %eax,(%ebx)
80103193:	0f 84 87 00 00 00    	je     80103220 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103199:	e8 f2 f2 ff ff       	call   80102490 <kalloc>
8010319e:	85 c0                	test   %eax,%eax
801031a0:	89 c7                	mov    %eax,%edi
801031a2:	74 7c                	je     80103220 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031a4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031ab:	00 00 00 
  p->writeopen = 1;
801031ae:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031b5:	00 00 00 
  p->nwrite = 0;
801031b8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031bf:	00 00 00 
  p->nread = 0;
801031c2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031c9:	00 00 00 
  initlock(&p->lock, "pipe");
801031cc:	89 04 24             	mov    %eax,(%esp)
801031cf:	c7 44 24 04 10 73 10 	movl   $0x80107310,0x4(%esp)
801031d6:	80 
801031d7:	e8 64 0e 00 00       	call   80104040 <initlock>
  (*f0)->type = FD_PIPE;
801031dc:	8b 06                	mov    (%esi),%eax
801031de:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801031e4:	8b 06                	mov    (%esi),%eax
801031e6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801031ea:	8b 06                	mov    (%esi),%eax
801031ec:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801031f0:	8b 06                	mov    (%esi),%eax
801031f2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801031f5:	8b 03                	mov    (%ebx),%eax
801031f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801031fd:	8b 03                	mov    (%ebx),%eax
801031ff:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103203:	8b 03                	mov    (%ebx),%eax
80103205:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103209:	8b 03                	mov    (%ebx),%eax
  return 0;
8010320b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010320d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103210:	83 c4 1c             	add    $0x1c,%esp
80103213:	89 d8                	mov    %ebx,%eax
80103215:	5b                   	pop    %ebx
80103216:	5e                   	pop    %esi
80103217:	5f                   	pop    %edi
80103218:	5d                   	pop    %ebp
80103219:	c3                   	ret    
8010321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103220:	8b 06                	mov    (%esi),%eax
80103222:	85 c0                	test   %eax,%eax
80103224:	74 08                	je     8010322e <pipealloc+0xce>
    fileclose(*f0);
80103226:	89 04 24             	mov    %eax,(%esp)
80103229:	e8 e2 db ff ff       	call   80100e10 <fileclose>
  if(*f1)
8010322e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103230:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103235:	85 c0                	test   %eax,%eax
80103237:	74 d7                	je     80103210 <pipealloc+0xb0>
    fileclose(*f1);
80103239:	89 04 24             	mov    %eax,(%esp)
8010323c:	e8 cf db ff ff       	call   80100e10 <fileclose>
}
80103241:	83 c4 1c             	add    $0x1c,%esp
80103244:	89 d8                	mov    %ebx,%eax
80103246:	5b                   	pop    %ebx
80103247:	5e                   	pop    %esi
80103248:	5f                   	pop    %edi
80103249:	5d                   	pop    %ebp
8010324a:	c3                   	ret    
8010324b:	90                   	nop
8010324c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103250 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	56                   	push   %esi
80103254:	53                   	push   %ebx
80103255:	83 ec 10             	sub    $0x10,%esp
80103258:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010325e:	89 1c 24             	mov    %ebx,(%esp)
80103261:	e8 ca 0e 00 00       	call   80104130 <acquire>
  if(writable){
80103266:	85 f6                	test   %esi,%esi
80103268:	74 3e                	je     801032a8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010326a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103270:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103277:	00 00 00 
    wakeup(&p->nread);
8010327a:	89 04 24             	mov    %eax,(%esp)
8010327d:	e8 fe 0a 00 00       	call   80103d80 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103282:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103288:	85 d2                	test   %edx,%edx
8010328a:	75 0a                	jne    80103296 <pipeclose+0x46>
8010328c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	74 32                	je     801032c8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103296:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	5b                   	pop    %ebx
8010329d:	5e                   	pop    %esi
8010329e:	5d                   	pop    %ebp
    release(&p->lock);
8010329f:	e9 7c 0f 00 00       	jmp    80104220 <release>
801032a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032a8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032ae:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032b5:	00 00 00 
    wakeup(&p->nwrite);
801032b8:	89 04 24             	mov    %eax,(%esp)
801032bb:	e8 c0 0a 00 00       	call   80103d80 <wakeup>
801032c0:	eb c0                	jmp    80103282 <pipeclose+0x32>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032c8:	89 1c 24             	mov    %ebx,(%esp)
801032cb:	e8 50 0f 00 00       	call   80104220 <release>
    kfree((char*)p);
801032d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032d3:	83 c4 10             	add    $0x10,%esp
801032d6:	5b                   	pop    %ebx
801032d7:	5e                   	pop    %esi
801032d8:	5d                   	pop    %ebp
    kfree((char*)p);
801032d9:	e9 02 f0 ff ff       	jmp    801022e0 <kfree>
801032de:	66 90                	xchg   %ax,%ax

801032e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	57                   	push   %edi
801032e4:	56                   	push   %esi
801032e5:	53                   	push   %ebx
801032e6:	83 ec 1c             	sub    $0x1c,%esp
801032e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032ec:	89 1c 24             	mov    %ebx,(%esp)
801032ef:	e8 3c 0e 00 00       	call   80104130 <acquire>
  for(i = 0; i < n; i++){
801032f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801032f7:	85 c9                	test   %ecx,%ecx
801032f9:	0f 8e b2 00 00 00    	jle    801033b1 <pipewrite+0xd1>
801032ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103302:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103308:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010330e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103314:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103317:	03 4d 10             	add    0x10(%ebp),%ecx
8010331a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010331d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103323:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103329:	39 c8                	cmp    %ecx,%eax
8010332b:	74 38                	je     80103365 <pipewrite+0x85>
8010332d:	eb 55                	jmp    80103384 <pipewrite+0xa4>
8010332f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103330:	e8 5b 03 00 00       	call   80103690 <myproc>
80103335:	8b 40 24             	mov    0x24(%eax),%eax
80103338:	85 c0                	test   %eax,%eax
8010333a:	75 33                	jne    8010336f <pipewrite+0x8f>
      wakeup(&p->nread);
8010333c:	89 3c 24             	mov    %edi,(%esp)
8010333f:	e8 3c 0a 00 00       	call   80103d80 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103344:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103348:	89 34 24             	mov    %esi,(%esp)
8010334b:	e8 a0 08 00 00       	call   80103bf0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103350:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103356:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010335c:	05 00 02 00 00       	add    $0x200,%eax
80103361:	39 c2                	cmp    %eax,%edx
80103363:	75 23                	jne    80103388 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103365:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010336b:	85 d2                	test   %edx,%edx
8010336d:	75 c1                	jne    80103330 <pipewrite+0x50>
        release(&p->lock);
8010336f:	89 1c 24             	mov    %ebx,(%esp)
80103372:	e8 a9 0e 00 00       	call   80104220 <release>
        return -1;
80103377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010337c:	83 c4 1c             	add    $0x1c,%esp
8010337f:	5b                   	pop    %ebx
80103380:	5e                   	pop    %esi
80103381:	5f                   	pop    %edi
80103382:	5d                   	pop    %ebp
80103383:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103384:	89 c2                	mov    %eax,%edx
80103386:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103388:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010338b:	8d 42 01             	lea    0x1(%edx),%eax
8010338e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103394:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010339a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010339e:	0f b6 09             	movzbl (%ecx),%ecx
801033a1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033a8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033ab:	0f 85 6c ff ff ff    	jne    8010331d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033b1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b7:	89 04 24             	mov    %eax,(%esp)
801033ba:	e8 c1 09 00 00       	call   80103d80 <wakeup>
  release(&p->lock);
801033bf:	89 1c 24             	mov    %ebx,(%esp)
801033c2:	e8 59 0e 00 00       	call   80104220 <release>
  return n;
801033c7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ca:	eb b0                	jmp    8010337c <pipewrite+0x9c>
801033cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	57                   	push   %edi
801033d4:	56                   	push   %esi
801033d5:	53                   	push   %ebx
801033d6:	83 ec 1c             	sub    $0x1c,%esp
801033d9:	8b 75 08             	mov    0x8(%ebp),%esi
801033dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033df:	89 34 24             	mov    %esi,(%esp)
801033e2:	e8 49 0d 00 00       	call   80104130 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033e7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033ed:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033f3:	75 5b                	jne    80103450 <piperead+0x80>
801033f5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801033fb:	85 db                	test   %ebx,%ebx
801033fd:	74 51                	je     80103450 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033ff:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103405:	eb 25                	jmp    8010342c <piperead+0x5c>
80103407:	90                   	nop
80103408:	89 74 24 04          	mov    %esi,0x4(%esp)
8010340c:	89 1c 24             	mov    %ebx,(%esp)
8010340f:	e8 dc 07 00 00       	call   80103bf0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103414:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010341a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103420:	75 2e                	jne    80103450 <piperead+0x80>
80103422:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103428:	85 d2                	test   %edx,%edx
8010342a:	74 24                	je     80103450 <piperead+0x80>
    if(myproc()->killed){
8010342c:	e8 5f 02 00 00       	call   80103690 <myproc>
80103431:	8b 48 24             	mov    0x24(%eax),%ecx
80103434:	85 c9                	test   %ecx,%ecx
80103436:	74 d0                	je     80103408 <piperead+0x38>
      release(&p->lock);
80103438:	89 34 24             	mov    %esi,(%esp)
8010343b:	e8 e0 0d 00 00       	call   80104220 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103440:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103448:	5b                   	pop    %ebx
80103449:	5e                   	pop    %esi
8010344a:	5f                   	pop    %edi
8010344b:	5d                   	pop    %ebp
8010344c:	c3                   	ret    
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103450:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103453:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103455:	85 d2                	test   %edx,%edx
80103457:	7f 2b                	jg     80103484 <piperead+0xb4>
80103459:	eb 31                	jmp    8010348c <piperead+0xbc>
8010345b:	90                   	nop
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103460:	8d 48 01             	lea    0x1(%eax),%ecx
80103463:	25 ff 01 00 00       	and    $0x1ff,%eax
80103468:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010346e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103473:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103476:	83 c3 01             	add    $0x1,%ebx
80103479:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010347c:	74 0e                	je     8010348c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010347e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103484:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010348a:	75 d4                	jne    80103460 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010348c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103492:	89 04 24             	mov    %eax,(%esp)
80103495:	e8 e6 08 00 00       	call   80103d80 <wakeup>
  release(&p->lock);
8010349a:	89 34 24             	mov    %esi,(%esp)
8010349d:	e8 7e 0d 00 00       	call   80104220 <release>
}
801034a2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034a5:	89 d8                	mov    %ebx,%eax
}
801034a7:	5b                   	pop    %ebx
801034a8:	5e                   	pop    %esi
801034a9:	5f                   	pop    %edi
801034aa:	5d                   	pop    %ebp
801034ab:	c3                   	ret    
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034b9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034bc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034c3:	e8 68 0c 00 00       	call   80104130 <acquire>
801034c8:	eb 11                	jmp    801034db <allocproc+0x2b>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d0:	83 eb 80             	sub    $0xffffff80,%ebx
801034d3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801034d9:	74 7d                	je     80103558 <allocproc+0xa8>
    if(p->state == UNUSED)
801034db:	8b 43 0c             	mov    0xc(%ebx),%eax
801034de:	85 c0                	test   %eax,%eax
801034e0:	75 ee                	jne    801034d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801034e7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
801034ee:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801034f5:	8d 50 01             	lea    0x1(%eax),%edx
801034f8:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801034fe:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103501:	e8 1a 0d 00 00       	call   80104220 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103506:	e8 85 ef ff ff       	call   80102490 <kalloc>
8010350b:	85 c0                	test   %eax,%eax
8010350d:	89 43 08             	mov    %eax,0x8(%ebx)
80103510:	74 5a                	je     8010356c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103512:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103518:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010351d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103520:	c7 40 14 25 54 10 80 	movl   $0x80105425,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103527:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010352e:	00 
8010352f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103536:	00 
80103537:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010353a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010353d:	e8 2e 0d 00 00       	call   80104270 <memset>
  p->context->eip = (uint)forkret;
80103542:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103545:	c7 40 10 80 35 10 80 	movl   $0x80103580,0x10(%eax)

  return p;
8010354c:	89 d8                	mov    %ebx,%eax
}
8010354e:	83 c4 14             	add    $0x14,%esp
80103551:	5b                   	pop    %ebx
80103552:	5d                   	pop    %ebp
80103553:	c3                   	ret    
80103554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103558:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010355f:	e8 bc 0c 00 00       	call   80104220 <release>
}
80103564:	83 c4 14             	add    $0x14,%esp
  return 0;
80103567:	31 c0                	xor    %eax,%eax
}
80103569:	5b                   	pop    %ebx
8010356a:	5d                   	pop    %ebp
8010356b:	c3                   	ret    
    p->state = UNUSED;
8010356c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103573:	eb d9                	jmp    8010354e <allocproc+0x9e>
80103575:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103580 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103586:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010358d:	e8 8e 0c 00 00       	call   80104220 <release>

  if (first) {
80103592:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	75 05                	jne    801035a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010359b:	c9                   	leave  
8010359c:	c3                   	ret    
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035a7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035ae:	00 00 00 
    iinit(ROOTDEV);
801035b1:	e8 aa de ff ff       	call   80101460 <iinit>
    initlog(ROOTDEV);
801035b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035bd:	e8 9e f4 ff ff       	call   80102a60 <initlog>
}
801035c2:	c9                   	leave  
801035c3:	c3                   	ret    
801035c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035d0 <pinit>:
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801035d6:	c7 44 24 04 15 73 10 	movl   $0x80107315,0x4(%esp)
801035dd:	80 
801035de:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035e5:	e8 56 0a 00 00       	call   80104040 <initlock>
}
801035ea:	c9                   	leave  
801035eb:	c3                   	ret    
801035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801035f0 <mycpu>:
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035f8:	9c                   	pushf  
801035f9:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035fa:	f6 c4 02             	test   $0x2,%ah
801035fd:	75 57                	jne    80103656 <mycpu+0x66>
  apicid = lapicid();
801035ff:	e8 4c f1 ff ff       	call   80102750 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103604:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010360a:	85 f6                	test   %esi,%esi
8010360c:	7e 3c                	jle    8010364a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010360e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103615:	39 c2                	cmp    %eax,%edx
80103617:	74 2d                	je     80103646 <mycpu+0x56>
80103619:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010361e:	31 d2                	xor    %edx,%edx
80103620:	83 c2 01             	add    $0x1,%edx
80103623:	39 f2                	cmp    %esi,%edx
80103625:	74 23                	je     8010364a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103627:	0f b6 19             	movzbl (%ecx),%ebx
8010362a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103630:	39 c3                	cmp    %eax,%ebx
80103632:	75 ec                	jne    80103620 <mycpu+0x30>
      return &cpus[i];
80103634:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010363a:	83 c4 10             	add    $0x10,%esp
8010363d:	5b                   	pop    %ebx
8010363e:	5e                   	pop    %esi
8010363f:	5d                   	pop    %ebp
      return &cpus[i];
80103640:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103645:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103646:	31 d2                	xor    %edx,%edx
80103648:	eb ea                	jmp    80103634 <mycpu+0x44>
  panic("unknown apicid\n");
8010364a:	c7 04 24 1c 73 10 80 	movl   $0x8010731c,(%esp)
80103651:	e8 0a cd ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103656:	c7 04 24 f8 73 10 80 	movl   $0x801073f8,(%esp)
8010365d:	e8 fe cc ff ff       	call   80100360 <panic>
80103662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103670 <cpuid>:
cpuid() {
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103676:	e8 75 ff ff ff       	call   801035f0 <mycpu>
}
8010367b:	c9                   	leave  
  return mycpu()-cpus;
8010367c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103681:	c1 f8 04             	sar    $0x4,%eax
80103684:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010368a:	c3                   	ret    
8010368b:	90                   	nop
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103690 <myproc>:
myproc(void) {
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	53                   	push   %ebx
80103694:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103697:	e8 54 0a 00 00       	call   801040f0 <pushcli>
  c = mycpu();
8010369c:	e8 4f ff ff ff       	call   801035f0 <mycpu>
  p = c->proc;
801036a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036a7:	e8 04 0b 00 00       	call   801041b0 <popcli>
}
801036ac:	83 c4 04             	add    $0x4,%esp
801036af:	89 d8                	mov    %ebx,%eax
801036b1:	5b                   	pop    %ebx
801036b2:	5d                   	pop    %ebp
801036b3:	c3                   	ret    
801036b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036c0 <userinit>:
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
801036c7:	e8 e4 fd ff ff       	call   801034b0 <allocproc>
801036cc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801036ce:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801036d3:	e8 d8 32 00 00       	call   801069b0 <setupkvm>
801036d8:	85 c0                	test   %eax,%eax
801036da:	89 43 04             	mov    %eax,0x4(%ebx)
801036dd:	0f 84 d4 00 00 00    	je     801037b7 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801036e3:	89 04 24             	mov    %eax,(%esp)
801036e6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801036ed:	00 
801036ee:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801036f5:	80 
801036f6:	e8 c5 2f 00 00       	call   801066c0 <inituvm>
  p->sz = PGSIZE;
801036fb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103701:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103708:	00 
80103709:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103710:	00 
80103711:	8b 43 18             	mov    0x18(%ebx),%eax
80103714:	89 04 24             	mov    %eax,(%esp)
80103717:	e8 54 0b 00 00       	call   80104270 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010371c:	8b 43 18             	mov    0x18(%ebx),%eax
8010371f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103724:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103729:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010372d:	8b 43 18             	mov    0x18(%ebx),%eax
80103730:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103734:	8b 43 18             	mov    0x18(%ebx),%eax
80103737:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010373b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010373f:	8b 43 18             	mov    0x18(%ebx),%eax
80103742:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103746:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010374a:	8b 43 18             	mov    0x18(%ebx),%eax
8010374d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103754:	8b 43 18             	mov    0x18(%ebx),%eax
80103757:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010375e:	8b 43 18             	mov    0x18(%ebx),%eax
80103761:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103768:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010376b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103772:	00 
80103773:	c7 44 24 04 45 73 10 	movl   $0x80107345,0x4(%esp)
8010377a:	80 
8010377b:	89 04 24             	mov    %eax,(%esp)
8010377e:	e8 cd 0c 00 00       	call   80104450 <safestrcpy>
  p->cwd = namei("/");
80103783:	c7 04 24 4e 73 10 80 	movl   $0x8010734e,(%esp)
8010378a:	e8 61 e7 ff ff       	call   80101ef0 <namei>
8010378f:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103792:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103799:	e8 92 09 00 00       	call   80104130 <acquire>
  p->state = RUNNABLE;
8010379e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037a5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037ac:	e8 6f 0a 00 00       	call   80104220 <release>
}
801037b1:	83 c4 14             	add    $0x14,%esp
801037b4:	5b                   	pop    %ebx
801037b5:	5d                   	pop    %ebp
801037b6:	c3                   	ret    
    panic("userinit: out of memory?");
801037b7:	c7 04 24 2c 73 10 80 	movl   $0x8010732c,(%esp)
801037be:	e8 9d cb ff ff       	call   80100360 <panic>
801037c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037d0 <growproc>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	56                   	push   %esi
801037d4:	53                   	push   %ebx
801037d5:	83 ec 10             	sub    $0x10,%esp
801037d8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801037db:	e8 b0 fe ff ff       	call   80103690 <myproc>
  if(n > 0){
801037e0:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
801037e3:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801037e5:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801037e7:	7e 2f                	jle    80103818 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037e9:	01 c6                	add    %eax,%esi
801037eb:	89 74 24 08          	mov    %esi,0x8(%esp)
801037ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801037f3:	8b 43 04             	mov    0x4(%ebx),%eax
801037f6:	89 04 24             	mov    %eax,(%esp)
801037f9:	e8 12 30 00 00       	call   80106810 <allocuvm>
801037fe:	85 c0                	test   %eax,%eax
80103800:	74 36                	je     80103838 <growproc+0x68>
  curproc->sz = sz;
80103802:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103804:	89 1c 24             	mov    %ebx,(%esp)
80103807:	e8 a4 2d 00 00       	call   801065b0 <switchuvm>
  return 0;
8010380c:	31 c0                	xor    %eax,%eax
}
8010380e:	83 c4 10             	add    $0x10,%esp
80103811:	5b                   	pop    %ebx
80103812:	5e                   	pop    %esi
80103813:	5d                   	pop    %ebp
80103814:	c3                   	ret    
80103815:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103818:	74 e8                	je     80103802 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010381a:	01 c6                	add    %eax,%esi
8010381c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103820:	89 44 24 04          	mov    %eax,0x4(%esp)
80103824:	8b 43 04             	mov    0x4(%ebx),%eax
80103827:	89 04 24             	mov    %eax,(%esp)
8010382a:	e8 e1 30 00 00       	call   80106910 <deallocuvm>
8010382f:	85 c0                	test   %eax,%eax
80103831:	75 cf                	jne    80103802 <growproc+0x32>
80103833:	90                   	nop
80103834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010383d:	eb cf                	jmp    8010380e <growproc+0x3e>
8010383f:	90                   	nop

80103840 <fork>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103849:	e8 42 fe ff ff       	call   80103690 <myproc>
8010384e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103850:	e8 5b fc ff ff       	call   801034b0 <allocproc>
80103855:	85 c0                	test   %eax,%eax
80103857:	89 c7                	mov    %eax,%edi
80103859:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010385c:	0f 84 bc 00 00 00    	je     8010391e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103862:	8b 03                	mov    (%ebx),%eax
80103864:	89 44 24 04          	mov    %eax,0x4(%esp)
80103868:	8b 43 04             	mov    0x4(%ebx),%eax
8010386b:	89 04 24             	mov    %eax,(%esp)
8010386e:	e8 1d 32 00 00       	call   80106a90 <copyuvm>
80103873:	85 c0                	test   %eax,%eax
80103875:	89 47 04             	mov    %eax,0x4(%edi)
80103878:	0f 84 a7 00 00 00    	je     80103925 <fork+0xe5>
  np->sz = curproc->sz;
8010387e:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103880:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103885:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103888:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
8010388a:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
8010388d:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103890:	8b 73 18             	mov    0x18(%ebx),%esi
80103893:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103895:	31 f6                	xor    %esi,%esi
  np->stack_pages = curproc->stack_pages;
80103897:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010389a:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->tf->eax = 0;
8010389d:	8b 42 18             	mov    0x18(%edx),%eax
801038a0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038a7:	90                   	nop
    if(curproc->ofile[i])
801038a8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038ac:	85 c0                	test   %eax,%eax
801038ae:	74 0f                	je     801038bf <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038b0:	89 04 24             	mov    %eax,(%esp)
801038b3:	e8 08 d5 ff ff       	call   80100dc0 <filedup>
801038b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038bb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801038bf:	83 c6 01             	add    $0x1,%esi
801038c2:	83 fe 10             	cmp    $0x10,%esi
801038c5:	75 e1                	jne    801038a8 <fork+0x68>
  np->cwd = idup(curproc->cwd);
801038c7:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038ca:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801038cd:	89 04 24             	mov    %eax,(%esp)
801038d0:	e8 9b dd ff ff       	call   80101670 <idup>
801038d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038d8:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038db:	8d 47 6c             	lea    0x6c(%edi),%eax
801038de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801038e2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801038e9:	00 
801038ea:	89 04 24             	mov    %eax,(%esp)
801038ed:	e8 5e 0b 00 00       	call   80104450 <safestrcpy>
  pid = np->pid;
801038f2:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801038f5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038fc:	e8 2f 08 00 00       	call   80104130 <acquire>
  np->state = RUNNABLE;
80103901:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103908:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010390f:	e8 0c 09 00 00       	call   80104220 <release>
  return pid;
80103914:	89 d8                	mov    %ebx,%eax
}
80103916:	83 c4 1c             	add    $0x1c,%esp
80103919:	5b                   	pop    %ebx
8010391a:	5e                   	pop    %esi
8010391b:	5f                   	pop    %edi
8010391c:	5d                   	pop    %ebp
8010391d:	c3                   	ret    
    return -1;
8010391e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103923:	eb f1                	jmp    80103916 <fork+0xd6>
    kfree(np->kstack);
80103925:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103928:	8b 47 08             	mov    0x8(%edi),%eax
8010392b:	89 04 24             	mov    %eax,(%esp)
8010392e:	e8 ad e9 ff ff       	call   801022e0 <kfree>
    return -1;
80103933:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103938:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010393f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103946:	eb ce                	jmp    80103916 <fork+0xd6>
80103948:	90                   	nop
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103950 <scheduler>:
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	57                   	push   %edi
80103954:	56                   	push   %esi
80103955:	53                   	push   %ebx
80103956:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103959:	e8 92 fc ff ff       	call   801035f0 <mycpu>
8010395e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103960:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103967:	00 00 00 
8010396a:	8d 78 04             	lea    0x4(%eax),%edi
8010396d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103970:	fb                   	sti    
    acquire(&ptable.lock);
80103971:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103978:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
8010397d:	e8 ae 07 00 00       	call   80104130 <acquire>
80103982:	eb 0f                	jmp    80103993 <scheduler+0x43>
80103984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103988:	83 eb 80             	sub    $0xffffff80,%ebx
8010398b:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103991:	74 45                	je     801039d8 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103993:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103997:	75 ef                	jne    80103988 <scheduler+0x38>
      c->proc = p;
80103999:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010399f:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a2:	83 eb 80             	sub    $0xffffff80,%ebx
      switchuvm(p);
801039a5:	e8 06 2c 00 00       	call   801065b0 <switchuvm>
      swtch(&(c->scheduler), p->context);
801039aa:	8b 43 9c             	mov    -0x64(%ebx),%eax
      p->state = RUNNING;
801039ad:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)
      swtch(&(c->scheduler), p->context);
801039b4:	89 3c 24             	mov    %edi,(%esp)
801039b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801039bb:	e8 eb 0a 00 00       	call   801044ab <swtch>
      switchkvm();
801039c0:	e8 cb 2b 00 00       	call   80106590 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c5:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      c->proc = 0;
801039cb:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039d2:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d5:	75 bc                	jne    80103993 <scheduler+0x43>
801039d7:	90                   	nop
    release(&ptable.lock);
801039d8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039df:	e8 3c 08 00 00       	call   80104220 <release>
  }
801039e4:	eb 8a                	jmp    80103970 <scheduler+0x20>
801039e6:	8d 76 00             	lea    0x0(%esi),%esi
801039e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039f0 <sched>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	56                   	push   %esi
801039f4:	53                   	push   %ebx
801039f5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
801039f8:	e8 93 fc ff ff       	call   80103690 <myproc>
  if(!holding(&ptable.lock))
801039fd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103a04:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a06:	e8 b5 06 00 00       	call   801040c0 <holding>
80103a0b:	85 c0                	test   %eax,%eax
80103a0d:	74 4f                	je     80103a5e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a0f:	e8 dc fb ff ff       	call   801035f0 <mycpu>
80103a14:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a1b:	75 65                	jne    80103a82 <sched+0x92>
  if(p->state == RUNNING)
80103a1d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a21:	74 53                	je     80103a76 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a23:	9c                   	pushf  
80103a24:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a25:	f6 c4 02             	test   $0x2,%ah
80103a28:	75 40                	jne    80103a6a <sched+0x7a>
  intena = mycpu()->intena;
80103a2a:	e8 c1 fb ff ff       	call   801035f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a2f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a32:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a38:	e8 b3 fb ff ff       	call   801035f0 <mycpu>
80103a3d:	8b 40 04             	mov    0x4(%eax),%eax
80103a40:	89 1c 24             	mov    %ebx,(%esp)
80103a43:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a47:	e8 5f 0a 00 00       	call   801044ab <swtch>
  mycpu()->intena = intena;
80103a4c:	e8 9f fb ff ff       	call   801035f0 <mycpu>
80103a51:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a57:	83 c4 10             	add    $0x10,%esp
80103a5a:	5b                   	pop    %ebx
80103a5b:	5e                   	pop    %esi
80103a5c:	5d                   	pop    %ebp
80103a5d:	c3                   	ret    
    panic("sched ptable.lock");
80103a5e:	c7 04 24 50 73 10 80 	movl   $0x80107350,(%esp)
80103a65:	e8 f6 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103a6a:	c7 04 24 7c 73 10 80 	movl   $0x8010737c,(%esp)
80103a71:	e8 ea c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103a76:	c7 04 24 6e 73 10 80 	movl   $0x8010736e,(%esp)
80103a7d:	e8 de c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103a82:	c7 04 24 62 73 10 80 	movl   $0x80107362,(%esp)
80103a89:	e8 d2 c8 ff ff       	call   80100360 <panic>
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <exit>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
  if(curproc == initproc)
80103a94:	31 f6                	xor    %esi,%esi
{
80103a96:	53                   	push   %ebx
80103a97:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103a9a:	e8 f1 fb ff ff       	call   80103690 <myproc>
  if(curproc == initproc)
80103a9f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103aa5:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103aa7:	0f 84 ea 00 00 00    	je     80103b97 <exit+0x107>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ab0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ab4:	85 c0                	test   %eax,%eax
80103ab6:	74 10                	je     80103ac8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103ab8:	89 04 24             	mov    %eax,(%esp)
80103abb:	e8 50 d3 ff ff       	call   80100e10 <fileclose>
      curproc->ofile[fd] = 0;
80103ac0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103ac7:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103ac8:	83 c6 01             	add    $0x1,%esi
80103acb:	83 fe 10             	cmp    $0x10,%esi
80103ace:	75 e0                	jne    80103ab0 <exit+0x20>
  begin_op();
80103ad0:	e8 2b f0 ff ff       	call   80102b00 <begin_op>
  iput(curproc->cwd);
80103ad5:	8b 43 68             	mov    0x68(%ebx),%eax
80103ad8:	89 04 24             	mov    %eax,(%esp)
80103adb:	e8 e0 dc ff ff       	call   801017c0 <iput>
  end_op();
80103ae0:	e8 8b f0 ff ff       	call   80102b70 <end_op>
  curproc->cwd = 0;
80103ae5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103aec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103af3:	e8 38 06 00 00       	call   80104130 <acquire>
  wakeup1(curproc->parent);
80103af8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103afb:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b00:	eb 11                	jmp    80103b13 <exit+0x83>
80103b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b08:	83 ea 80             	sub    $0xffffff80,%edx
80103b0b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b11:	74 1d                	je     80103b30 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b13:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b17:	75 ef                	jne    80103b08 <exit+0x78>
80103b19:	3b 42 20             	cmp    0x20(%edx),%eax
80103b1c:	75 ea                	jne    80103b08 <exit+0x78>
      p->state = RUNNABLE;
80103b1e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b25:	83 ea 80             	sub    $0xffffff80,%edx
80103b28:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b2e:	75 e3                	jne    80103b13 <exit+0x83>
      p->parent = initproc;
80103b30:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b35:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b3a:	eb 0f                	jmp    80103b4b <exit+0xbb>
80103b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b40:	83 e9 80             	sub    $0xffffff80,%ecx
80103b43:	81 f9 54 4d 11 80    	cmp    $0x80114d54,%ecx
80103b49:	74 34                	je     80103b7f <exit+0xef>
    if(p->parent == curproc){
80103b4b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b4e:	75 f0                	jne    80103b40 <exit+0xb0>
      if(p->state == ZOMBIE)
80103b50:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103b54:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103b57:	75 e7                	jne    80103b40 <exit+0xb0>
80103b59:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b5e:	eb 0b                	jmp    80103b6b <exit+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b60:	83 ea 80             	sub    $0xffffff80,%edx
80103b63:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b69:	74 d5                	je     80103b40 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103b6b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b6f:	75 ef                	jne    80103b60 <exit+0xd0>
80103b71:	3b 42 20             	cmp    0x20(%edx),%eax
80103b74:	75 ea                	jne    80103b60 <exit+0xd0>
      p->state = RUNNABLE;
80103b76:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103b7d:	eb e1                	jmp    80103b60 <exit+0xd0>
  curproc->state = ZOMBIE;
80103b7f:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103b86:	e8 65 fe ff ff       	call   801039f0 <sched>
  panic("zombie exit");
80103b8b:	c7 04 24 9d 73 10 80 	movl   $0x8010739d,(%esp)
80103b92:	e8 c9 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103b97:	c7 04 24 90 73 10 80 	movl   $0x80107390,(%esp)
80103b9e:	e8 bd c7 ff ff       	call   80100360 <panic>
80103ba3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bb0 <yield>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103bb6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bbd:	e8 6e 05 00 00       	call   80104130 <acquire>
  myproc()->state = RUNNABLE;
80103bc2:	e8 c9 fa ff ff       	call   80103690 <myproc>
80103bc7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103bce:	e8 1d fe ff ff       	call   801039f0 <sched>
  release(&ptable.lock);
80103bd3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bda:	e8 41 06 00 00       	call   80104220 <release>
}
80103bdf:	c9                   	leave  
80103be0:	c3                   	ret    
80103be1:	eb 0d                	jmp    80103bf0 <sleep>
80103be3:	90                   	nop
80103be4:	90                   	nop
80103be5:	90                   	nop
80103be6:	90                   	nop
80103be7:	90                   	nop
80103be8:	90                   	nop
80103be9:	90                   	nop
80103bea:	90                   	nop
80103beb:	90                   	nop
80103bec:	90                   	nop
80103bed:	90                   	nop
80103bee:	90                   	nop
80103bef:	90                   	nop

80103bf0 <sleep>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	57                   	push   %edi
80103bf4:	56                   	push   %esi
80103bf5:	53                   	push   %ebx
80103bf6:	83 ec 1c             	sub    $0x1c,%esp
80103bf9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103bff:	e8 8c fa ff ff       	call   80103690 <myproc>
  if(p == 0)
80103c04:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103c06:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103c08:	0f 84 7c 00 00 00    	je     80103c8a <sleep+0x9a>
  if(lk == 0)
80103c0e:	85 f6                	test   %esi,%esi
80103c10:	74 6c                	je     80103c7e <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c12:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c18:	74 46                	je     80103c60 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c1a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c21:	e8 0a 05 00 00       	call   80104130 <acquire>
    release(lk);
80103c26:	89 34 24             	mov    %esi,(%esp)
80103c29:	e8 f2 05 00 00       	call   80104220 <release>
  p->chan = chan;
80103c2e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c31:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c38:	e8 b3 fd ff ff       	call   801039f0 <sched>
  p->chan = 0;
80103c3d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103c44:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c4b:	e8 d0 05 00 00       	call   80104220 <release>
    acquire(lk);
80103c50:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103c53:	83 c4 1c             	add    $0x1c,%esp
80103c56:	5b                   	pop    %ebx
80103c57:	5e                   	pop    %esi
80103c58:	5f                   	pop    %edi
80103c59:	5d                   	pop    %ebp
    acquire(lk);
80103c5a:	e9 d1 04 00 00       	jmp    80104130 <acquire>
80103c5f:	90                   	nop
  p->chan = chan;
80103c60:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103c63:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103c6a:	e8 81 fd ff ff       	call   801039f0 <sched>
  p->chan = 0;
80103c6f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103c76:	83 c4 1c             	add    $0x1c,%esp
80103c79:	5b                   	pop    %ebx
80103c7a:	5e                   	pop    %esi
80103c7b:	5f                   	pop    %edi
80103c7c:	5d                   	pop    %ebp
80103c7d:	c3                   	ret    
    panic("sleep without lk");
80103c7e:	c7 04 24 af 73 10 80 	movl   $0x801073af,(%esp)
80103c85:	e8 d6 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103c8a:	c7 04 24 a9 73 10 80 	movl   $0x801073a9,(%esp)
80103c91:	e8 ca c6 ff ff       	call   80100360 <panic>
80103c96:	8d 76 00             	lea    0x0(%esi),%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ca0 <wait>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	56                   	push   %esi
80103ca4:	53                   	push   %ebx
80103ca5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103ca8:	e8 e3 f9 ff ff       	call   80103690 <myproc>
  acquire(&ptable.lock);
80103cad:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103cb4:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103cb6:	e8 75 04 00 00       	call   80104130 <acquire>
    havekids = 0;
80103cbb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cbd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103cc2:	eb 0f                	jmp    80103cd3 <wait+0x33>
80103cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cc8:	83 eb 80             	sub    $0xffffff80,%ebx
80103ccb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103cd1:	74 1d                	je     80103cf0 <wait+0x50>
      if(p->parent != curproc)
80103cd3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103cd6:	75 f0                	jne    80103cc8 <wait+0x28>
      if(p->state == ZOMBIE){
80103cd8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103cdc:	74 2f                	je     80103d0d <wait+0x6d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cde:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103ce1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ce6:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103cec:	75 e5                	jne    80103cd3 <wait+0x33>
80103cee:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103cf0:	85 c0                	test   %eax,%eax
80103cf2:	74 6e                	je     80103d62 <wait+0xc2>
80103cf4:	8b 46 24             	mov    0x24(%esi),%eax
80103cf7:	85 c0                	test   %eax,%eax
80103cf9:	75 67                	jne    80103d62 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103cfb:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d02:	80 
80103d03:	89 34 24             	mov    %esi,(%esp)
80103d06:	e8 e5 fe ff ff       	call   80103bf0 <sleep>
  }
80103d0b:	eb ae                	jmp    80103cbb <wait+0x1b>
        kfree(p->kstack);
80103d0d:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103d10:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d13:	89 04 24             	mov    %eax,(%esp)
80103d16:	e8 c5 e5 ff ff       	call   801022e0 <kfree>
        freevm(p->pgdir);
80103d1b:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103d1e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d25:	89 04 24             	mov    %eax,(%esp)
80103d28:	e8 03 2c 00 00       	call   80106930 <freevm>
        release(&ptable.lock);
80103d2d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103d34:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d3b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d42:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103d46:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103d4d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103d54:	e8 c7 04 00 00       	call   80104220 <release>
}
80103d59:	83 c4 10             	add    $0x10,%esp
        return pid;
80103d5c:	89 f0                	mov    %esi,%eax
}
80103d5e:	5b                   	pop    %ebx
80103d5f:	5e                   	pop    %esi
80103d60:	5d                   	pop    %ebp
80103d61:	c3                   	ret    
      release(&ptable.lock);
80103d62:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d69:	e8 b2 04 00 00       	call   80104220 <release>
}
80103d6e:	83 c4 10             	add    $0x10,%esp
      return -1;
80103d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d76:	5b                   	pop    %ebx
80103d77:	5e                   	pop    %esi
80103d78:	5d                   	pop    %ebp
80103d79:	c3                   	ret    
80103d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d80 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	53                   	push   %ebx
80103d84:	83 ec 14             	sub    $0x14,%esp
80103d87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103d8a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d91:	e8 9a 03 00 00       	call   80104130 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d96:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d9b:	eb 0d                	jmp    80103daa <wakeup+0x2a>
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
80103da0:	83 e8 80             	sub    $0xffffff80,%eax
80103da3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103da8:	74 1e                	je     80103dc8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103daa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dae:	75 f0                	jne    80103da0 <wakeup+0x20>
80103db0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103db3:	75 eb                	jne    80103da0 <wakeup+0x20>
      p->state = RUNNABLE;
80103db5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dbc:	83 e8 80             	sub    $0xffffff80,%eax
80103dbf:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103dc4:	75 e4                	jne    80103daa <wakeup+0x2a>
80103dc6:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103dc8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103dcf:	83 c4 14             	add    $0x14,%esp
80103dd2:	5b                   	pop    %ebx
80103dd3:	5d                   	pop    %ebp
  release(&ptable.lock);
80103dd4:	e9 47 04 00 00       	jmp    80104220 <release>
80103dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103de0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 14             	sub    $0x14,%esp
80103de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103dea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103df1:	e8 3a 03 00 00       	call   80104130 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dfb:	eb 0d                	jmp    80103e0a <kill+0x2a>
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi
80103e00:	83 e8 80             	sub    $0xffffff80,%eax
80103e03:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e08:	74 36                	je     80103e40 <kill+0x60>
    if(p->pid == pid){
80103e0a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e0d:	75 f1                	jne    80103e00 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e0f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103e13:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103e1a:	74 14                	je     80103e30 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e1c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e23:	e8 f8 03 00 00       	call   80104220 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e28:	83 c4 14             	add    $0x14,%esp
      return 0;
80103e2b:	31 c0                	xor    %eax,%eax
}
80103e2d:	5b                   	pop    %ebx
80103e2e:	5d                   	pop    %ebp
80103e2f:	c3                   	ret    
        p->state = RUNNABLE;
80103e30:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e37:	eb e3                	jmp    80103e1c <kill+0x3c>
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103e40:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e47:	e8 d4 03 00 00       	call   80104220 <release>
}
80103e4c:	83 c4 14             	add    $0x14,%esp
  return -1;
80103e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e54:	5b                   	pop    %ebx
80103e55:	5d                   	pop    %ebp
80103e56:	c3                   	ret    
80103e57:	89 f6                	mov    %esi,%esi
80103e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e60 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103e6b:	83 ec 4c             	sub    $0x4c,%esp
80103e6e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103e71:	eb 20                	jmp    80103e93 <procdump+0x33>
80103e73:	90                   	nop
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103e78:	c7 04 24 3f 77 10 80 	movl   $0x8010773f,(%esp)
80103e7f:	e8 cc c7 ff ff       	call   80100650 <cprintf>
80103e84:	83 eb 80             	sub    $0xffffff80,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e87:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80103e8d:	0f 84 8d 00 00 00    	je     80103f20 <procdump+0xc0>
    if(p->state == UNUSED)
80103e93:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103e96:	85 c0                	test   %eax,%eax
80103e98:	74 ea                	je     80103e84 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103e9a:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103e9d:	ba c0 73 10 80       	mov    $0x801073c0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ea2:	77 11                	ja     80103eb5 <procdump+0x55>
80103ea4:	8b 14 85 20 74 10 80 	mov    -0x7fef8be0(,%eax,4),%edx
      state = "???";
80103eab:	b8 c0 73 10 80       	mov    $0x801073c0,%eax
80103eb0:	85 d2                	test   %edx,%edx
80103eb2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103eb5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103eb8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103ebc:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ec0:	c7 04 24 c4 73 10 80 	movl   $0x801073c4,(%esp)
80103ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ecb:	e8 80 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103ed0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103ed4:	75 a2                	jne    80103e78 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103ed6:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103edd:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103ee0:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103ee3:	8b 40 0c             	mov    0xc(%eax),%eax
80103ee6:	83 c0 08             	add    $0x8,%eax
80103ee9:	89 04 24             	mov    %eax,(%esp)
80103eec:	e8 6f 01 00 00       	call   80104060 <getcallerpcs>
80103ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103ef8:	8b 17                	mov    (%edi),%edx
80103efa:	85 d2                	test   %edx,%edx
80103efc:	0f 84 76 ff ff ff    	je     80103e78 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f02:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f06:	83 c7 04             	add    $0x4,%edi
80103f09:	c7 04 24 01 6e 10 80 	movl   $0x80106e01,(%esp)
80103f10:	e8 3b c7 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f15:	39 f7                	cmp    %esi,%edi
80103f17:	75 df                	jne    80103ef8 <procdump+0x98>
80103f19:	e9 5a ff ff ff       	jmp    80103e78 <procdump+0x18>
80103f1e:	66 90                	xchg   %ax,%ax
  }
}
80103f20:	83 c4 4c             	add    $0x4c,%esp
80103f23:	5b                   	pop    %ebx
80103f24:	5e                   	pop    %esi
80103f25:	5f                   	pop    %edi
80103f26:	5d                   	pop    %ebp
80103f27:	c3                   	ret    
80103f28:	66 90                	xchg   %ax,%ax
80103f2a:	66 90                	xchg   %ax,%ax
80103f2c:	66 90                	xchg   %ax,%ax
80103f2e:	66 90                	xchg   %ax,%ax

80103f30 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	53                   	push   %ebx
80103f34:	83 ec 14             	sub    $0x14,%esp
80103f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f3a:	c7 44 24 04 38 74 10 	movl   $0x80107438,0x4(%esp)
80103f41:	80 
80103f42:	8d 43 04             	lea    0x4(%ebx),%eax
80103f45:	89 04 24             	mov    %eax,(%esp)
80103f48:	e8 f3 00 00 00       	call   80104040 <initlock>
  lk->name = name;
80103f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f50:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f56:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103f5d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103f60:	83 c4 14             	add    $0x14,%esp
80103f63:	5b                   	pop    %ebx
80103f64:	5d                   	pop    %ebp
80103f65:	c3                   	ret    
80103f66:	8d 76 00             	lea    0x0(%esi),%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
80103f75:	83 ec 10             	sub    $0x10,%esp
80103f78:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103f7b:	8d 73 04             	lea    0x4(%ebx),%esi
80103f7e:	89 34 24             	mov    %esi,(%esp)
80103f81:	e8 aa 01 00 00       	call   80104130 <acquire>
  while (lk->locked) {
80103f86:	8b 13                	mov    (%ebx),%edx
80103f88:	85 d2                	test   %edx,%edx
80103f8a:	74 16                	je     80103fa2 <acquiresleep+0x32>
80103f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103f90:	89 74 24 04          	mov    %esi,0x4(%esp)
80103f94:	89 1c 24             	mov    %ebx,(%esp)
80103f97:	e8 54 fc ff ff       	call   80103bf0 <sleep>
  while (lk->locked) {
80103f9c:	8b 03                	mov    (%ebx),%eax
80103f9e:	85 c0                	test   %eax,%eax
80103fa0:	75 ee                	jne    80103f90 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103fa2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103fa8:	e8 e3 f6 ff ff       	call   80103690 <myproc>
80103fad:	8b 40 10             	mov    0x10(%eax),%eax
80103fb0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103fb3:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fb6:	83 c4 10             	add    $0x10,%esp
80103fb9:	5b                   	pop    %ebx
80103fba:	5e                   	pop    %esi
80103fbb:	5d                   	pop    %ebp
  release(&lk->lk);
80103fbc:	e9 5f 02 00 00       	jmp    80104220 <release>
80103fc1:	eb 0d                	jmp    80103fd0 <releasesleep>
80103fc3:	90                   	nop
80103fc4:	90                   	nop
80103fc5:	90                   	nop
80103fc6:	90                   	nop
80103fc7:	90                   	nop
80103fc8:	90                   	nop
80103fc9:	90                   	nop
80103fca:	90                   	nop
80103fcb:	90                   	nop
80103fcc:	90                   	nop
80103fcd:	90                   	nop
80103fce:	90                   	nop
80103fcf:	90                   	nop

80103fd0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
80103fd5:	83 ec 10             	sub    $0x10,%esp
80103fd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fdb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fde:	89 34 24             	mov    %esi,(%esp)
80103fe1:	e8 4a 01 00 00       	call   80104130 <acquire>
  lk->locked = 0;
80103fe6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fec:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103ff3:	89 1c 24             	mov    %ebx,(%esp)
80103ff6:	e8 85 fd ff ff       	call   80103d80 <wakeup>
  release(&lk->lk);
80103ffb:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103ffe:	83 c4 10             	add    $0x10,%esp
80104001:	5b                   	pop    %ebx
80104002:	5e                   	pop    %esi
80104003:	5d                   	pop    %ebp
  release(&lk->lk);
80104004:	e9 17 02 00 00       	jmp    80104220 <release>
80104009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104010 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
80104015:	83 ec 10             	sub    $0x10,%esp
80104018:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010401b:	8d 73 04             	lea    0x4(%ebx),%esi
8010401e:	89 34 24             	mov    %esi,(%esp)
80104021:	e8 0a 01 00 00       	call   80104130 <acquire>
  r = lk->locked;
80104026:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104028:	89 34 24             	mov    %esi,(%esp)
8010402b:	e8 f0 01 00 00       	call   80104220 <release>
  return r;
}
80104030:	83 c4 10             	add    $0x10,%esp
80104033:	89 d8                	mov    %ebx,%eax
80104035:	5b                   	pop    %ebx
80104036:	5e                   	pop    %esi
80104037:	5d                   	pop    %ebp
80104038:	c3                   	ret    
80104039:	66 90                	xchg   %ax,%ax
8010403b:	66 90                	xchg   %ax,%ax
8010403d:	66 90                	xchg   %ax,%ax
8010403f:	90                   	nop

80104040 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104046:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104049:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010404f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104052:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104059:	5d                   	pop    %ebp
8010405a:	c3                   	ret    
8010405b:	90                   	nop
8010405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104060 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104063:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104069:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010406a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010406d:	31 c0                	xor    %eax,%eax
8010406f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104070:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104076:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010407c:	77 1a                	ja     80104098 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010407e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104081:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104084:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104087:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104089:	83 f8 0a             	cmp    $0xa,%eax
8010408c:	75 e2                	jne    80104070 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010408e:	5b                   	pop    %ebx
8010408f:	5d                   	pop    %ebp
80104090:	c3                   	ret    
80104091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104098:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010409f:	83 c0 01             	add    $0x1,%eax
801040a2:	83 f8 0a             	cmp    $0xa,%eax
801040a5:	74 e7                	je     8010408e <getcallerpcs+0x2e>
    pcs[i] = 0;
801040a7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040ae:	83 c0 01             	add    $0x1,%eax
801040b1:	83 f8 0a             	cmp    $0xa,%eax
801040b4:	75 e2                	jne    80104098 <getcallerpcs+0x38>
801040b6:	eb d6                	jmp    8010408e <getcallerpcs+0x2e>
801040b8:	90                   	nop
801040b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040c0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801040c0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801040c1:	31 c0                	xor    %eax,%eax
{
801040c3:	89 e5                	mov    %esp,%ebp
801040c5:	53                   	push   %ebx
801040c6:	83 ec 04             	sub    $0x4,%esp
801040c9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801040cc:	8b 0a                	mov    (%edx),%ecx
801040ce:	85 c9                	test   %ecx,%ecx
801040d0:	74 10                	je     801040e2 <holding+0x22>
801040d2:	8b 5a 08             	mov    0x8(%edx),%ebx
801040d5:	e8 16 f5 ff ff       	call   801035f0 <mycpu>
801040da:	39 c3                	cmp    %eax,%ebx
801040dc:	0f 94 c0             	sete   %al
801040df:	0f b6 c0             	movzbl %al,%eax
}
801040e2:	83 c4 04             	add    $0x4,%esp
801040e5:	5b                   	pop    %ebx
801040e6:	5d                   	pop    %ebp
801040e7:	c3                   	ret    
801040e8:	90                   	nop
801040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 04             	sub    $0x4,%esp
801040f7:	9c                   	pushf  
801040f8:	5b                   	pop    %ebx
  asm volatile("cli");
801040f9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801040fa:	e8 f1 f4 ff ff       	call   801035f0 <mycpu>
801040ff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104105:	85 c0                	test   %eax,%eax
80104107:	75 11                	jne    8010411a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104109:	e8 e2 f4 ff ff       	call   801035f0 <mycpu>
8010410e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104114:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010411a:	e8 d1 f4 ff ff       	call   801035f0 <mycpu>
8010411f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104126:	83 c4 04             	add    $0x4,%esp
80104129:	5b                   	pop    %ebx
8010412a:	5d                   	pop    %ebp
8010412b:	c3                   	ret    
8010412c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104130 <acquire>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104137:	e8 b4 ff ff ff       	call   801040f0 <pushcli>
  if(holding(lk))
8010413c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010413f:	8b 02                	mov    (%edx),%eax
80104141:	85 c0                	test   %eax,%eax
80104143:	75 43                	jne    80104188 <acquire+0x58>
  asm volatile("lock; xchgl %0, %1" :
80104145:	b9 01 00 00 00       	mov    $0x1,%ecx
8010414a:	eb 07                	jmp    80104153 <acquire+0x23>
8010414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104150:	8b 55 08             	mov    0x8(%ebp),%edx
80104153:	89 c8                	mov    %ecx,%eax
80104155:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
80104158:	85 c0                	test   %eax,%eax
8010415a:	75 f4                	jne    80104150 <acquire+0x20>
  __sync_synchronize();
8010415c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010415f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104162:	e8 89 f4 ff ff       	call   801035f0 <mycpu>
80104167:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010416a:	8b 45 08             	mov    0x8(%ebp),%eax
8010416d:	83 c0 0c             	add    $0xc,%eax
80104170:	89 44 24 04          	mov    %eax,0x4(%esp)
80104174:	8d 45 08             	lea    0x8(%ebp),%eax
80104177:	89 04 24             	mov    %eax,(%esp)
8010417a:	e8 e1 fe ff ff       	call   80104060 <getcallerpcs>
}
8010417f:	83 c4 14             	add    $0x14,%esp
80104182:	5b                   	pop    %ebx
80104183:	5d                   	pop    %ebp
80104184:	c3                   	ret    
80104185:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104188:	8b 5a 08             	mov    0x8(%edx),%ebx
8010418b:	e8 60 f4 ff ff       	call   801035f0 <mycpu>
  if(holding(lk))
80104190:	39 c3                	cmp    %eax,%ebx
80104192:	74 05                	je     80104199 <acquire+0x69>
80104194:	8b 55 08             	mov    0x8(%ebp),%edx
80104197:	eb ac                	jmp    80104145 <acquire+0x15>
    panic("acquire");
80104199:	c7 04 24 43 74 10 80 	movl   $0x80107443,(%esp)
801041a0:	e8 bb c1 ff ff       	call   80100360 <panic>
801041a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041b0 <popcli>:

void
popcli(void)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041b6:	9c                   	pushf  
801041b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041b8:	f6 c4 02             	test   $0x2,%ah
801041bb:	75 49                	jne    80104206 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801041bd:	e8 2e f4 ff ff       	call   801035f0 <mycpu>
801041c2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801041c8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801041cb:	85 d2                	test   %edx,%edx
801041cd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801041d3:	78 25                	js     801041fa <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041d5:	e8 16 f4 ff ff       	call   801035f0 <mycpu>
801041da:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801041e0:	85 d2                	test   %edx,%edx
801041e2:	74 04                	je     801041e8 <popcli+0x38>
    sti();
}
801041e4:	c9                   	leave  
801041e5:	c3                   	ret    
801041e6:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041e8:	e8 03 f4 ff ff       	call   801035f0 <mycpu>
801041ed:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801041f3:	85 c0                	test   %eax,%eax
801041f5:	74 ed                	je     801041e4 <popcli+0x34>
  asm volatile("sti");
801041f7:	fb                   	sti    
}
801041f8:	c9                   	leave  
801041f9:	c3                   	ret    
    panic("popcli");
801041fa:	c7 04 24 62 74 10 80 	movl   $0x80107462,(%esp)
80104201:	e8 5a c1 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104206:	c7 04 24 4b 74 10 80 	movl   $0x8010744b,(%esp)
8010420d:	e8 4e c1 ff ff       	call   80100360 <panic>
80104212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <release>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	83 ec 10             	sub    $0x10,%esp
80104228:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010422b:	8b 03                	mov    (%ebx),%eax
8010422d:	85 c0                	test   %eax,%eax
8010422f:	75 0f                	jne    80104240 <release+0x20>
    panic("release");
80104231:	c7 04 24 69 74 10 80 	movl   $0x80107469,(%esp)
80104238:	e8 23 c1 ff ff       	call   80100360 <panic>
8010423d:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104240:	8b 73 08             	mov    0x8(%ebx),%esi
80104243:	e8 a8 f3 ff ff       	call   801035f0 <mycpu>
  if(!holding(lk))
80104248:	39 c6                	cmp    %eax,%esi
8010424a:	75 e5                	jne    80104231 <release+0x11>
  lk->pcs[0] = 0;
8010424c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104253:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010425a:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010425d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104263:	83 c4 10             	add    $0x10,%esp
80104266:	5b                   	pop    %ebx
80104267:	5e                   	pop    %esi
80104268:	5d                   	pop    %ebp
  popcli();
80104269:	e9 42 ff ff ff       	jmp    801041b0 <popcli>
8010426e:	66 90                	xchg   %ax,%ax

80104270 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	8b 55 08             	mov    0x8(%ebp),%edx
80104276:	57                   	push   %edi
80104277:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010427a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010427b:	f6 c2 03             	test   $0x3,%dl
8010427e:	75 05                	jne    80104285 <memset+0x15>
80104280:	f6 c1 03             	test   $0x3,%cl
80104283:	74 13                	je     80104298 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104285:	89 d7                	mov    %edx,%edi
80104287:	8b 45 0c             	mov    0xc(%ebp),%eax
8010428a:	fc                   	cld    
8010428b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010428d:	5b                   	pop    %ebx
8010428e:	89 d0                	mov    %edx,%eax
80104290:	5f                   	pop    %edi
80104291:	5d                   	pop    %ebp
80104292:	c3                   	ret    
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104298:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010429c:	c1 e9 02             	shr    $0x2,%ecx
8010429f:	89 f8                	mov    %edi,%eax
801042a1:	89 fb                	mov    %edi,%ebx
801042a3:	c1 e0 18             	shl    $0x18,%eax
801042a6:	c1 e3 10             	shl    $0x10,%ebx
801042a9:	09 d8                	or     %ebx,%eax
801042ab:	09 f8                	or     %edi,%eax
801042ad:	c1 e7 08             	shl    $0x8,%edi
801042b0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801042b2:	89 d7                	mov    %edx,%edi
801042b4:	fc                   	cld    
801042b5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801042b7:	5b                   	pop    %ebx
801042b8:	89 d0                	mov    %edx,%eax
801042ba:	5f                   	pop    %edi
801042bb:	5d                   	pop    %ebp
801042bc:	c3                   	ret    
801042bd:	8d 76 00             	lea    0x0(%esi),%esi

801042c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	8b 45 10             	mov    0x10(%ebp),%eax
801042c6:	57                   	push   %edi
801042c7:	56                   	push   %esi
801042c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042cb:	53                   	push   %ebx
801042cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801042cf:	85 c0                	test   %eax,%eax
801042d1:	8d 78 ff             	lea    -0x1(%eax),%edi
801042d4:	74 26                	je     801042fc <memcmp+0x3c>
    if(*s1 != *s2)
801042d6:	0f b6 03             	movzbl (%ebx),%eax
801042d9:	31 d2                	xor    %edx,%edx
801042db:	0f b6 0e             	movzbl (%esi),%ecx
801042de:	38 c8                	cmp    %cl,%al
801042e0:	74 16                	je     801042f8 <memcmp+0x38>
801042e2:	eb 24                	jmp    80104308 <memcmp+0x48>
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801042ed:	83 c2 01             	add    $0x1,%edx
801042f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801042f4:	38 c8                	cmp    %cl,%al
801042f6:	75 10                	jne    80104308 <memcmp+0x48>
  while(n-- > 0){
801042f8:	39 fa                	cmp    %edi,%edx
801042fa:	75 ec                	jne    801042e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801042fc:	5b                   	pop    %ebx
  return 0;
801042fd:	31 c0                	xor    %eax,%eax
}
801042ff:	5e                   	pop    %esi
80104300:	5f                   	pop    %edi
80104301:	5d                   	pop    %ebp
80104302:	c3                   	ret    
80104303:	90                   	nop
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104308:	5b                   	pop    %ebx
      return *s1 - *s2;
80104309:	29 c8                	sub    %ecx,%eax
}
8010430b:	5e                   	pop    %esi
8010430c:	5f                   	pop    %edi
8010430d:	5d                   	pop    %ebp
8010430e:	c3                   	ret    
8010430f:	90                   	nop

80104310 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	8b 45 08             	mov    0x8(%ebp),%eax
80104317:	56                   	push   %esi
80104318:	8b 75 0c             	mov    0xc(%ebp),%esi
8010431b:	53                   	push   %ebx
8010431c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010431f:	39 c6                	cmp    %eax,%esi
80104321:	73 35                	jae    80104358 <memmove+0x48>
80104323:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104326:	39 c8                	cmp    %ecx,%eax
80104328:	73 2e                	jae    80104358 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010432a:	85 db                	test   %ebx,%ebx
    d += n;
8010432c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010432f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104332:	74 1b                	je     8010434f <memmove+0x3f>
80104334:	f7 db                	neg    %ebx
80104336:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104339:	01 fb                	add    %edi,%ebx
8010433b:	90                   	nop
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104340:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104344:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104347:	83 ea 01             	sub    $0x1,%edx
8010434a:	83 fa ff             	cmp    $0xffffffff,%edx
8010434d:	75 f1                	jne    80104340 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010434f:	5b                   	pop    %ebx
80104350:	5e                   	pop    %esi
80104351:	5f                   	pop    %edi
80104352:	5d                   	pop    %ebp
80104353:	c3                   	ret    
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104358:	31 d2                	xor    %edx,%edx
8010435a:	85 db                	test   %ebx,%ebx
8010435c:	74 f1                	je     8010434f <memmove+0x3f>
8010435e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104360:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104364:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104367:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010436a:	39 da                	cmp    %ebx,%edx
8010436c:	75 f2                	jne    80104360 <memmove+0x50>
}
8010436e:	5b                   	pop    %ebx
8010436f:	5e                   	pop    %esi
80104370:	5f                   	pop    %edi
80104371:	5d                   	pop    %ebp
80104372:	c3                   	ret    
80104373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104380 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104383:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104384:	eb 8a                	jmp    80104310 <memmove>
80104386:	8d 76 00             	lea    0x0(%esi),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104390 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	8b 75 10             	mov    0x10(%ebp),%esi
80104397:	53                   	push   %ebx
80104398:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010439b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010439e:	85 f6                	test   %esi,%esi
801043a0:	74 30                	je     801043d2 <strncmp+0x42>
801043a2:	0f b6 01             	movzbl (%ecx),%eax
801043a5:	84 c0                	test   %al,%al
801043a7:	74 2f                	je     801043d8 <strncmp+0x48>
801043a9:	0f b6 13             	movzbl (%ebx),%edx
801043ac:	38 d0                	cmp    %dl,%al
801043ae:	75 46                	jne    801043f6 <strncmp+0x66>
801043b0:	8d 51 01             	lea    0x1(%ecx),%edx
801043b3:	01 ce                	add    %ecx,%esi
801043b5:	eb 14                	jmp    801043cb <strncmp+0x3b>
801043b7:	90                   	nop
801043b8:	0f b6 02             	movzbl (%edx),%eax
801043bb:	84 c0                	test   %al,%al
801043bd:	74 31                	je     801043f0 <strncmp+0x60>
801043bf:	0f b6 19             	movzbl (%ecx),%ebx
801043c2:	83 c2 01             	add    $0x1,%edx
801043c5:	38 d8                	cmp    %bl,%al
801043c7:	75 17                	jne    801043e0 <strncmp+0x50>
    n--, p++, q++;
801043c9:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
801043cb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801043cd:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
801043d0:	75 e6                	jne    801043b8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801043d2:	5b                   	pop    %ebx
    return 0;
801043d3:	31 c0                	xor    %eax,%eax
}
801043d5:	5e                   	pop    %esi
801043d6:	5d                   	pop    %ebp
801043d7:	c3                   	ret    
801043d8:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
801043db:	31 c0                	xor    %eax,%eax
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
801043e0:	0f b6 d3             	movzbl %bl,%edx
801043e3:	29 d0                	sub    %edx,%eax
}
801043e5:	5b                   	pop    %ebx
801043e6:	5e                   	pop    %esi
801043e7:	5d                   	pop    %ebp
801043e8:	c3                   	ret    
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801043f4:	eb ea                	jmp    801043e0 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
801043f6:	89 d3                	mov    %edx,%ebx
801043f8:	eb e6                	jmp    801043e0 <strncmp+0x50>
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	8b 45 08             	mov    0x8(%ebp),%eax
80104406:	56                   	push   %esi
80104407:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010440a:	53                   	push   %ebx
8010440b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010440e:	89 c2                	mov    %eax,%edx
80104410:	eb 19                	jmp    8010442b <strncpy+0x2b>
80104412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104418:	83 c3 01             	add    $0x1,%ebx
8010441b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010441f:	83 c2 01             	add    $0x1,%edx
80104422:	84 c9                	test   %cl,%cl
80104424:	88 4a ff             	mov    %cl,-0x1(%edx)
80104427:	74 09                	je     80104432 <strncpy+0x32>
80104429:	89 f1                	mov    %esi,%ecx
8010442b:	85 c9                	test   %ecx,%ecx
8010442d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104430:	7f e6                	jg     80104418 <strncpy+0x18>
    ;
  while(n-- > 0)
80104432:	31 c9                	xor    %ecx,%ecx
80104434:	85 f6                	test   %esi,%esi
80104436:	7e 0f                	jle    80104447 <strncpy+0x47>
    *s++ = 0;
80104438:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010443c:	89 f3                	mov    %esi,%ebx
8010443e:	83 c1 01             	add    $0x1,%ecx
80104441:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104443:	85 db                	test   %ebx,%ebx
80104445:	7f f1                	jg     80104438 <strncpy+0x38>
  return os;
}
80104447:	5b                   	pop    %ebx
80104448:	5e                   	pop    %esi
80104449:	5d                   	pop    %ebp
8010444a:	c3                   	ret    
8010444b:	90                   	nop
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104450 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104456:	56                   	push   %esi
80104457:	8b 45 08             	mov    0x8(%ebp),%eax
8010445a:	53                   	push   %ebx
8010445b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010445e:	85 c9                	test   %ecx,%ecx
80104460:	7e 26                	jle    80104488 <safestrcpy+0x38>
80104462:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104466:	89 c1                	mov    %eax,%ecx
80104468:	eb 17                	jmp    80104481 <safestrcpy+0x31>
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104470:	83 c2 01             	add    $0x1,%edx
80104473:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104477:	83 c1 01             	add    $0x1,%ecx
8010447a:	84 db                	test   %bl,%bl
8010447c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010447f:	74 04                	je     80104485 <safestrcpy+0x35>
80104481:	39 f2                	cmp    %esi,%edx
80104483:	75 eb                	jne    80104470 <safestrcpy+0x20>
    ;
  *s = 0;
80104485:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104488:	5b                   	pop    %ebx
80104489:	5e                   	pop    %esi
8010448a:	5d                   	pop    %ebp
8010448b:	c3                   	ret    
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104490 <strlen>:

int
strlen(const char *s)
{
80104490:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104491:	31 c0                	xor    %eax,%eax
{
80104493:	89 e5                	mov    %esp,%ebp
80104495:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104498:	80 3a 00             	cmpb   $0x0,(%edx)
8010449b:	74 0c                	je     801044a9 <strlen+0x19>
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
801044a0:	83 c0 01             	add    $0x1,%eax
801044a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044a7:	75 f7                	jne    801044a0 <strlen+0x10>
    ;
  return n;
}
801044a9:	5d                   	pop    %ebp
801044aa:	c3                   	ret    

801044ab <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801044b3:	55                   	push   %ebp
  pushl %ebx
801044b4:	53                   	push   %ebx
  pushl %esi
801044b5:	56                   	push   %esi
  pushl %edi
801044b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044b9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801044bb:	5f                   	pop    %edi
  popl %esi
801044bc:	5e                   	pop    %esi
  popl %ebx
801044bd:	5b                   	pop    %ebx
  popl %ebp
801044be:	5d                   	pop    %ebp
  ret
801044bf:	c3                   	ret    

801044c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
801044c6:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
801044cb:	77 0b                	ja     801044d8 <fetchint+0x18>
    return -1;
  *ip = *(int*)(addr);
801044cd:	8b 10                	mov    (%eax),%edx
801044cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801044d2:	89 10                	mov    %edx,(%eax)
  return 0;
801044d4:	31 c0                	xor    %eax,%eax
}
801044d6:	5d                   	pop    %ebp
801044d7:	c3                   	ret    
    return -1;
801044d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044dd:	5d                   	pop    %ebp
801044de:	c3                   	ret    
801044df:	90                   	nop

801044e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;

  if(addr >= (KERNBASE-1))
801044e6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801044ec:	77 21                	ja     8010450f <fetchstr+0x2f>
    return -1;

  *pp = (char*)addr;
801044ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801044f1:	89 d0                	mov    %edx,%eax
801044f3:	89 11                	mov    %edx,(%ecx)
  ep = (char*)(KERNBASE-1);

  for(s = *pp; s < ep; s++){
    if(*s == 0)
801044f5:	80 3a 00             	cmpb   $0x0,(%edx)
801044f8:	75 0b                	jne    80104505 <fetchstr+0x25>
801044fa:	eb 1c                	jmp    80104518 <fetchstr+0x38>
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104500:	80 38 00             	cmpb   $0x0,(%eax)
80104503:	74 13                	je     80104518 <fetchstr+0x38>
  for(s = *pp; s < ep; s++){
80104505:	83 c0 01             	add    $0x1,%eax
80104508:	3d ff ff ff 7f       	cmp    $0x7fffffff,%eax
8010450d:	75 f1                	jne    80104500 <fetchstr+0x20>
    return -1;
8010450f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104514:	5d                   	pop    %ebp
80104515:	c3                   	ret    
80104516:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104518:	29 d0                	sub    %edx,%eax
}
8010451a:	5d                   	pop    %ebp
8010451b:	c3                   	ret    
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104520 <argint>:
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104526:	e8 65 f1 ff ff       	call   80103690 <myproc>
8010452b:	8b 55 08             	mov    0x8(%ebp),%edx
8010452e:	8b 40 18             	mov    0x18(%eax),%eax
80104531:	8b 40 44             	mov    0x44(%eax),%eax
80104534:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
80104538:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
8010453d:	77 11                	ja     80104550 <argint+0x30>
  *ip = *(int*)(addr);
8010453f:	8b 10                	mov    (%eax),%edx
80104541:	8b 45 0c             	mov    0xc(%ebp),%eax
80104544:	89 10                	mov    %edx,(%eax)
  return 0;
80104546:	31 c0                	xor    %eax,%eax
}
80104548:	c9                   	leave  
80104549:	c3                   	ret    
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104555:	c9                   	leave  
80104556:	c3                   	ret    
80104557:	89 f6                	mov    %esi,%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 24             	sub    $0x24,%esp
80104567:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  //struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
8010456a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010456d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104571:	8b 45 08             	mov    0x8(%ebp),%eax
80104574:	89 04 24             	mov    %eax,(%esp)
80104577:	e8 a4 ff ff ff       	call   80104520 <argint>
8010457c:	85 c0                	test   %eax,%eax
8010457e:	78 20                	js     801045a0 <argptr+0x40>
    return -1;
  if(size < 0 || (uint)i >= (KERNBASE-1) || (uint)i+size > (KERNBASE-1))
80104580:	85 db                	test   %ebx,%ebx
80104582:	78 1c                	js     801045a0 <argptr+0x40>
80104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104587:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010458c:	77 12                	ja     801045a0 <argptr+0x40>
8010458e:	01 c3                	add    %eax,%ebx
80104590:	78 0e                	js     801045a0 <argptr+0x40>
    return -1;
  *pp = (char*)i;
80104592:	8b 55 0c             	mov    0xc(%ebp),%edx
80104595:	89 02                	mov    %eax,(%edx)
  return 0;
80104597:	31 c0                	xor    %eax,%eax
}
80104599:	83 c4 24             	add    $0x24,%esp
8010459c:	5b                   	pop    %ebx
8010459d:	5d                   	pop    %ebp
8010459e:	c3                   	ret    
8010459f:	90                   	nop
    return -1;
801045a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045a5:	eb f2                	jmp    80104599 <argptr+0x39>
801045a7:	89 f6                	mov    %esi,%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801045b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801045bd:	8b 45 08             	mov    0x8(%ebp),%eax
801045c0:	89 04 24             	mov    %eax,(%esp)
801045c3:	e8 58 ff ff ff       	call   80104520 <argint>
801045c8:	85 c0                	test   %eax,%eax
801045ca:	78 2b                	js     801045f7 <argstr+0x47>
    return -1;
  return fetchstr(addr, pp);
801045cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  if(addr >= (KERNBASE-1))
801045cf:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801045d5:	77 20                	ja     801045f7 <argstr+0x47>
  *pp = (char*)addr;
801045d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801045da:	89 d0                	mov    %edx,%eax
801045dc:	89 11                	mov    %edx,(%ecx)
    if(*s == 0)
801045de:	80 3a 00             	cmpb   $0x0,(%edx)
801045e1:	75 0a                	jne    801045ed <argstr+0x3d>
801045e3:	eb 1b                	jmp    80104600 <argstr+0x50>
801045e5:	8d 76 00             	lea    0x0(%esi),%esi
801045e8:	80 38 00             	cmpb   $0x0,(%eax)
801045eb:	74 13                	je     80104600 <argstr+0x50>
  for(s = *pp; s < ep; s++){
801045ed:	83 c0 01             	add    $0x1,%eax
801045f0:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801045f5:	76 f1                	jbe    801045e8 <argstr+0x38>
    return -1;
801045f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045fc:	c9                   	leave  
801045fd:	c3                   	ret    
801045fe:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104600:	29 d0                	sub    %edx,%eax
}
80104602:	c9                   	leave  
80104603:	c3                   	ret    
80104604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010460a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104610 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104618:	e8 73 f0 ff ff       	call   80103690 <myproc>

  num = curproc->tf->eax;
8010461d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104620:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104622:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104625:	8d 50 ff             	lea    -0x1(%eax),%edx
80104628:	83 fa 16             	cmp    $0x16,%edx
8010462b:	77 1b                	ja     80104648 <syscall+0x38>
8010462d:	8b 14 85 a0 74 10 80 	mov    -0x7fef8b60(,%eax,4),%edx
80104634:	85 d2                	test   %edx,%edx
80104636:	74 10                	je     80104648 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104638:	ff d2                	call   *%edx
8010463a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010463d:	83 c4 10             	add    $0x10,%esp
80104640:	5b                   	pop    %ebx
80104641:	5e                   	pop    %esi
80104642:	5d                   	pop    %ebp
80104643:	c3                   	ret    
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104648:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010464c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010464f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104653:	8b 43 10             	mov    0x10(%ebx),%eax
80104656:	c7 04 24 71 74 10 80 	movl   $0x80107471,(%esp)
8010465d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104661:	e8 ea bf ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104666:	8b 43 18             	mov    0x18(%ebx),%eax
80104669:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104670:	83 c4 10             	add    $0x10,%esp
80104673:	5b                   	pop    %ebx
80104674:	5e                   	pop    %esi
80104675:	5d                   	pop    %ebp
80104676:	c3                   	ret    
80104677:	66 90                	xchg   %ax,%ax
80104679:	66 90                	xchg   %ax,%ax
8010467b:	66 90                	xchg   %ax,%ax
8010467d:	66 90                	xchg   %ax,%ax
8010467f:	90                   	nop

80104680 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	53                   	push   %ebx
80104684:	89 c3                	mov    %eax,%ebx
80104686:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104689:	e8 02 f0 ff ff       	call   80103690 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010468e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104690:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104694:	85 c9                	test   %ecx,%ecx
80104696:	74 18                	je     801046b0 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104698:	83 c2 01             	add    $0x1,%edx
8010469b:	83 fa 10             	cmp    $0x10,%edx
8010469e:	75 f0                	jne    80104690 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801046a0:	83 c4 04             	add    $0x4,%esp
  return -1;
801046a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046a8:	5b                   	pop    %ebx
801046a9:	5d                   	pop    %ebp
801046aa:	c3                   	ret    
801046ab:	90                   	nop
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801046b0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
801046b4:	83 c4 04             	add    $0x4,%esp
      return fd;
801046b7:	89 d0                	mov    %edx,%eax
}
801046b9:	5b                   	pop    %ebx
801046ba:	5d                   	pop    %ebp
801046bb:	c3                   	ret    
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	57                   	push   %edi
801046c4:	56                   	push   %esi
801046c5:	53                   	push   %ebx
801046c6:	83 ec 4c             	sub    $0x4c,%esp
801046c9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801046cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046cf:	8d 5d da             	lea    -0x26(%ebp),%ebx
801046d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801046d6:	89 04 24             	mov    %eax,(%esp)
{
801046d9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801046dc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801046df:	e8 2c d8 ff ff       	call   80101f10 <nameiparent>
801046e4:	85 c0                	test   %eax,%eax
801046e6:	89 c7                	mov    %eax,%edi
801046e8:	0f 84 da 00 00 00    	je     801047c8 <create+0x108>
    return 0;
  ilock(dp);
801046ee:	89 04 24             	mov    %eax,(%esp)
801046f1:	e8 aa cf ff ff       	call   801016a0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801046f6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801046f9:	89 44 24 08          	mov    %eax,0x8(%esp)
801046fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104701:	89 3c 24             	mov    %edi,(%esp)
80104704:	e8 a7 d4 ff ff       	call   80101bb0 <dirlookup>
80104709:	85 c0                	test   %eax,%eax
8010470b:	89 c6                	mov    %eax,%esi
8010470d:	74 41                	je     80104750 <create+0x90>
    iunlockput(dp);
8010470f:	89 3c 24             	mov    %edi,(%esp)
80104712:	e8 e9 d1 ff ff       	call   80101900 <iunlockput>
    ilock(ip);
80104717:	89 34 24             	mov    %esi,(%esp)
8010471a:	e8 81 cf ff ff       	call   801016a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010471f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104724:	75 12                	jne    80104738 <create+0x78>
80104726:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010472b:	89 f0                	mov    %esi,%eax
8010472d:	75 09                	jne    80104738 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010472f:	83 c4 4c             	add    $0x4c,%esp
80104732:	5b                   	pop    %ebx
80104733:	5e                   	pop    %esi
80104734:	5f                   	pop    %edi
80104735:	5d                   	pop    %ebp
80104736:	c3                   	ret    
80104737:	90                   	nop
    iunlockput(ip);
80104738:	89 34 24             	mov    %esi,(%esp)
8010473b:	e8 c0 d1 ff ff       	call   80101900 <iunlockput>
}
80104740:	83 c4 4c             	add    $0x4c,%esp
    return 0;
80104743:	31 c0                	xor    %eax,%eax
}
80104745:	5b                   	pop    %ebx
80104746:	5e                   	pop    %esi
80104747:	5f                   	pop    %edi
80104748:	5d                   	pop    %ebp
80104749:	c3                   	ret    
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104750:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104754:	89 44 24 04          	mov    %eax,0x4(%esp)
80104758:	8b 07                	mov    (%edi),%eax
8010475a:	89 04 24             	mov    %eax,(%esp)
8010475d:	e8 ae cd ff ff       	call   80101510 <ialloc>
80104762:	85 c0                	test   %eax,%eax
80104764:	89 c6                	mov    %eax,%esi
80104766:	0f 84 bf 00 00 00    	je     8010482b <create+0x16b>
  ilock(ip);
8010476c:	89 04 24             	mov    %eax,(%esp)
8010476f:	e8 2c cf ff ff       	call   801016a0 <ilock>
  ip->major = major;
80104774:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104778:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010477c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104780:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104784:	b8 01 00 00 00       	mov    $0x1,%eax
80104789:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010478d:	89 34 24             	mov    %esi,(%esp)
80104790:	e8 4b ce ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104795:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010479a:	74 34                	je     801047d0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
8010479c:	8b 46 04             	mov    0x4(%esi),%eax
8010479f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047a3:	89 3c 24             	mov    %edi,(%esp)
801047a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801047aa:	e8 61 d6 ff ff       	call   80101e10 <dirlink>
801047af:	85 c0                	test   %eax,%eax
801047b1:	78 6c                	js     8010481f <create+0x15f>
  iunlockput(dp);
801047b3:	89 3c 24             	mov    %edi,(%esp)
801047b6:	e8 45 d1 ff ff       	call   80101900 <iunlockput>
}
801047bb:	83 c4 4c             	add    $0x4c,%esp
  return ip;
801047be:	89 f0                	mov    %esi,%eax
}
801047c0:	5b                   	pop    %ebx
801047c1:	5e                   	pop    %esi
801047c2:	5f                   	pop    %edi
801047c3:	5d                   	pop    %ebp
801047c4:	c3                   	ret    
801047c5:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801047c8:	31 c0                	xor    %eax,%eax
801047ca:	e9 60 ff ff ff       	jmp    8010472f <create+0x6f>
801047cf:	90                   	nop
    dp->nlink++;  // for ".."
801047d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801047d5:	89 3c 24             	mov    %edi,(%esp)
801047d8:	e8 03 ce ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801047dd:	8b 46 04             	mov    0x4(%esi),%eax
801047e0:	c7 44 24 04 1c 75 10 	movl   $0x8010751c,0x4(%esp)
801047e7:	80 
801047e8:	89 34 24             	mov    %esi,(%esp)
801047eb:	89 44 24 08          	mov    %eax,0x8(%esp)
801047ef:	e8 1c d6 ff ff       	call   80101e10 <dirlink>
801047f4:	85 c0                	test   %eax,%eax
801047f6:	78 1b                	js     80104813 <create+0x153>
801047f8:	8b 47 04             	mov    0x4(%edi),%eax
801047fb:	c7 44 24 04 1b 75 10 	movl   $0x8010751b,0x4(%esp)
80104802:	80 
80104803:	89 34 24             	mov    %esi,(%esp)
80104806:	89 44 24 08          	mov    %eax,0x8(%esp)
8010480a:	e8 01 d6 ff ff       	call   80101e10 <dirlink>
8010480f:	85 c0                	test   %eax,%eax
80104811:	79 89                	jns    8010479c <create+0xdc>
      panic("create dots");
80104813:	c7 04 24 0f 75 10 80 	movl   $0x8010750f,(%esp)
8010481a:	e8 41 bb ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010481f:	c7 04 24 1e 75 10 80 	movl   $0x8010751e,(%esp)
80104826:	e8 35 bb ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010482b:	c7 04 24 00 75 10 80 	movl   $0x80107500,(%esp)
80104832:	e8 29 bb ff ff       	call   80100360 <panic>
80104837:	89 f6                	mov    %esi,%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104840 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	89 c6                	mov    %eax,%esi
80104846:	53                   	push   %ebx
80104847:	89 d3                	mov    %edx,%ebx
80104849:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
8010484c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010484f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104853:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010485a:	e8 c1 fc ff ff       	call   80104520 <argint>
8010485f:	85 c0                	test   %eax,%eax
80104861:	78 2d                	js     80104890 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104863:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104867:	77 27                	ja     80104890 <argfd.constprop.0+0x50>
80104869:	e8 22 ee ff ff       	call   80103690 <myproc>
8010486e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104871:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104875:	85 c0                	test   %eax,%eax
80104877:	74 17                	je     80104890 <argfd.constprop.0+0x50>
  if(pfd)
80104879:	85 f6                	test   %esi,%esi
8010487b:	74 02                	je     8010487f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010487d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010487f:	85 db                	test   %ebx,%ebx
80104881:	74 1d                	je     801048a0 <argfd.constprop.0+0x60>
    *pf = f;
80104883:	89 03                	mov    %eax,(%ebx)
  return 0;
80104885:	31 c0                	xor    %eax,%eax
}
80104887:	83 c4 20             	add    $0x20,%esp
8010488a:	5b                   	pop    %ebx
8010488b:	5e                   	pop    %esi
8010488c:	5d                   	pop    %ebp
8010488d:	c3                   	ret    
8010488e:	66 90                	xchg   %ax,%ax
80104890:	83 c4 20             	add    $0x20,%esp
    return -1;
80104893:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104898:	5b                   	pop    %ebx
80104899:	5e                   	pop    %esi
8010489a:	5d                   	pop    %ebp
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
801048a0:	31 c0                	xor    %eax,%eax
801048a2:	eb e3                	jmp    80104887 <argfd.constprop.0+0x47>
801048a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048b0 <sys_dup>:
{
801048b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801048b1:	31 c0                	xor    %eax,%eax
{
801048b3:	89 e5                	mov    %esp,%ebp
801048b5:	53                   	push   %ebx
801048b6:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
801048b9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801048bc:	e8 7f ff ff ff       	call   80104840 <argfd.constprop.0>
801048c1:	85 c0                	test   %eax,%eax
801048c3:	78 23                	js     801048e8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801048c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c8:	e8 b3 fd ff ff       	call   80104680 <fdalloc>
801048cd:	85 c0                	test   %eax,%eax
801048cf:	89 c3                	mov    %eax,%ebx
801048d1:	78 15                	js     801048e8 <sys_dup+0x38>
  filedup(f);
801048d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d6:	89 04 24             	mov    %eax,(%esp)
801048d9:	e8 e2 c4 ff ff       	call   80100dc0 <filedup>
  return fd;
801048de:	89 d8                	mov    %ebx,%eax
}
801048e0:	83 c4 24             	add    $0x24,%esp
801048e3:	5b                   	pop    %ebx
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret    
801048e6:	66 90                	xchg   %ax,%ax
    return -1;
801048e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048ed:	eb f1                	jmp    801048e0 <sys_dup+0x30>
801048ef:	90                   	nop

801048f0 <sys_read>:
{
801048f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048f1:	31 c0                	xor    %eax,%eax
{
801048f3:	89 e5                	mov    %esp,%ebp
801048f5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801048fb:	e8 40 ff ff ff       	call   80104840 <argfd.constprop.0>
80104900:	85 c0                	test   %eax,%eax
80104902:	78 54                	js     80104958 <sys_read+0x68>
80104904:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104907:	89 44 24 04          	mov    %eax,0x4(%esp)
8010490b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104912:	e8 09 fc ff ff       	call   80104520 <argint>
80104917:	85 c0                	test   %eax,%eax
80104919:	78 3d                	js     80104958 <sys_read+0x68>
8010491b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010491e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104925:	89 44 24 08          	mov    %eax,0x8(%esp)
80104929:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010492c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104930:	e8 2b fc ff ff       	call   80104560 <argptr>
80104935:	85 c0                	test   %eax,%eax
80104937:	78 1f                	js     80104958 <sys_read+0x68>
  return fileread(f, p, n);
80104939:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010493c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104943:	89 44 24 04          	mov    %eax,0x4(%esp)
80104947:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010494a:	89 04 24             	mov    %eax,(%esp)
8010494d:	e8 ce c5 ff ff       	call   80100f20 <fileread>
}
80104952:	c9                   	leave  
80104953:	c3                   	ret    
80104954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010495d:	c9                   	leave  
8010495e:	c3                   	ret    
8010495f:	90                   	nop

80104960 <sys_write>:
{
80104960:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104961:	31 c0                	xor    %eax,%eax
{
80104963:	89 e5                	mov    %esp,%ebp
80104965:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104968:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010496b:	e8 d0 fe ff ff       	call   80104840 <argfd.constprop.0>
80104970:	85 c0                	test   %eax,%eax
80104972:	78 54                	js     801049c8 <sys_write+0x68>
80104974:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104977:	89 44 24 04          	mov    %eax,0x4(%esp)
8010497b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104982:	e8 99 fb ff ff       	call   80104520 <argint>
80104987:	85 c0                	test   %eax,%eax
80104989:	78 3d                	js     801049c8 <sys_write+0x68>
8010498b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010498e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104995:	89 44 24 08          	mov    %eax,0x8(%esp)
80104999:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010499c:	89 44 24 04          	mov    %eax,0x4(%esp)
801049a0:	e8 bb fb ff ff       	call   80104560 <argptr>
801049a5:	85 c0                	test   %eax,%eax
801049a7:	78 1f                	js     801049c8 <sys_write+0x68>
  return filewrite(f, p, n);
801049a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049ac:	89 44 24 08          	mov    %eax,0x8(%esp)
801049b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801049b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ba:	89 04 24             	mov    %eax,(%esp)
801049bd:	e8 fe c5 ff ff       	call   80100fc0 <filewrite>
}
801049c2:	c9                   	leave  
801049c3:	c3                   	ret    
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049cd:	c9                   	leave  
801049ce:	c3                   	ret    
801049cf:	90                   	nop

801049d0 <sys_close>:
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
801049d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801049d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049dc:	e8 5f fe ff ff       	call   80104840 <argfd.constprop.0>
801049e1:	85 c0                	test   %eax,%eax
801049e3:	78 23                	js     80104a08 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
801049e5:	e8 a6 ec ff ff       	call   80103690 <myproc>
801049ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049ed:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801049f4:	00 
  fileclose(f);
801049f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f8:	89 04 24             	mov    %eax,(%esp)
801049fb:	e8 10 c4 ff ff       	call   80100e10 <fileclose>
  return 0;
80104a00:	31 c0                	xor    %eax,%eax
}
80104a02:	c9                   	leave  
80104a03:	c3                   	ret    
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a0d:	c9                   	leave  
80104a0e:	c3                   	ret    
80104a0f:	90                   	nop

80104a10 <sys_fstat>:
{
80104a10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a11:	31 c0                	xor    %eax,%eax
{
80104a13:	89 e5                	mov    %esp,%ebp
80104a15:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a1b:	e8 20 fe ff ff       	call   80104840 <argfd.constprop.0>
80104a20:	85 c0                	test   %eax,%eax
80104a22:	78 34                	js     80104a58 <sys_fstat+0x48>
80104a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a27:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a2e:	00 
80104a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a3a:	e8 21 fb ff ff       	call   80104560 <argptr>
80104a3f:	85 c0                	test   %eax,%eax
80104a41:	78 15                	js     80104a58 <sys_fstat+0x48>
  return filestat(f, st);
80104a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a46:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a4d:	89 04 24             	mov    %eax,(%esp)
80104a50:	e8 7b c4 ff ff       	call   80100ed0 <filestat>
}
80104a55:	c9                   	leave  
80104a56:	c3                   	ret    
80104a57:	90                   	nop
    return -1;
80104a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a5d:	c9                   	leave  
80104a5e:	c3                   	ret    
80104a5f:	90                   	nop

80104a60 <sys_link>:
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	57                   	push   %edi
80104a64:	56                   	push   %esi
80104a65:	53                   	push   %ebx
80104a66:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104a69:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a77:	e8 34 fb ff ff       	call   801045b0 <argstr>
80104a7c:	85 c0                	test   %eax,%eax
80104a7e:	0f 88 e6 00 00 00    	js     80104b6a <sys_link+0x10a>
80104a84:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a92:	e8 19 fb ff ff       	call   801045b0 <argstr>
80104a97:	85 c0                	test   %eax,%eax
80104a99:	0f 88 cb 00 00 00    	js     80104b6a <sys_link+0x10a>
  begin_op();
80104a9f:	e8 5c e0 ff ff       	call   80102b00 <begin_op>
  if((ip = namei(old)) == 0){
80104aa4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104aa7:	89 04 24             	mov    %eax,(%esp)
80104aaa:	e8 41 d4 ff ff       	call   80101ef0 <namei>
80104aaf:	85 c0                	test   %eax,%eax
80104ab1:	89 c3                	mov    %eax,%ebx
80104ab3:	0f 84 ac 00 00 00    	je     80104b65 <sys_link+0x105>
  ilock(ip);
80104ab9:	89 04 24             	mov    %eax,(%esp)
80104abc:	e8 df cb ff ff       	call   801016a0 <ilock>
  if(ip->type == T_DIR){
80104ac1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ac6:	0f 84 91 00 00 00    	je     80104b5d <sys_link+0xfd>
  ip->nlink++;
80104acc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104ad1:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ad4:	89 1c 24             	mov    %ebx,(%esp)
80104ad7:	e8 04 cb ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104adc:	89 1c 24             	mov    %ebx,(%esp)
80104adf:	e8 9c cc ff ff       	call   80101780 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ae4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104ae7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104aeb:	89 04 24             	mov    %eax,(%esp)
80104aee:	e8 1d d4 ff ff       	call   80101f10 <nameiparent>
80104af3:	85 c0                	test   %eax,%eax
80104af5:	89 c6                	mov    %eax,%esi
80104af7:	74 4f                	je     80104b48 <sys_link+0xe8>
  ilock(dp);
80104af9:	89 04 24             	mov    %eax,(%esp)
80104afc:	e8 9f cb ff ff       	call   801016a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104b01:	8b 03                	mov    (%ebx),%eax
80104b03:	39 06                	cmp    %eax,(%esi)
80104b05:	75 39                	jne    80104b40 <sys_link+0xe0>
80104b07:	8b 43 04             	mov    0x4(%ebx),%eax
80104b0a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b0e:	89 34 24             	mov    %esi,(%esp)
80104b11:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b15:	e8 f6 d2 ff ff       	call   80101e10 <dirlink>
80104b1a:	85 c0                	test   %eax,%eax
80104b1c:	78 22                	js     80104b40 <sys_link+0xe0>
  iunlockput(dp);
80104b1e:	89 34 24             	mov    %esi,(%esp)
80104b21:	e8 da cd ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104b26:	89 1c 24             	mov    %ebx,(%esp)
80104b29:	e8 92 cc ff ff       	call   801017c0 <iput>
  end_op();
80104b2e:	e8 3d e0 ff ff       	call   80102b70 <end_op>
}
80104b33:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104b36:	31 c0                	xor    %eax,%eax
}
80104b38:	5b                   	pop    %ebx
80104b39:	5e                   	pop    %esi
80104b3a:	5f                   	pop    %edi
80104b3b:	5d                   	pop    %ebp
80104b3c:	c3                   	ret    
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104b40:	89 34 24             	mov    %esi,(%esp)
80104b43:	e8 b8 cd ff ff       	call   80101900 <iunlockput>
  ilock(ip);
80104b48:	89 1c 24             	mov    %ebx,(%esp)
80104b4b:	e8 50 cb ff ff       	call   801016a0 <ilock>
  ip->nlink--;
80104b50:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104b55:	89 1c 24             	mov    %ebx,(%esp)
80104b58:	e8 83 ca ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104b5d:	89 1c 24             	mov    %ebx,(%esp)
80104b60:	e8 9b cd ff ff       	call   80101900 <iunlockput>
  end_op();
80104b65:	e8 06 e0 ff ff       	call   80102b70 <end_op>
}
80104b6a:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b72:	5b                   	pop    %ebx
80104b73:	5e                   	pop    %esi
80104b74:	5f                   	pop    %edi
80104b75:	5d                   	pop    %ebp
80104b76:	c3                   	ret    
80104b77:	89 f6                	mov    %esi,%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <sys_unlink>:
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	57                   	push   %edi
80104b84:	56                   	push   %esi
80104b85:	53                   	push   %ebx
80104b86:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104b89:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b97:	e8 14 fa ff ff       	call   801045b0 <argstr>
80104b9c:	85 c0                	test   %eax,%eax
80104b9e:	0f 88 76 01 00 00    	js     80104d1a <sys_unlink+0x19a>
  begin_op();
80104ba4:	e8 57 df ff ff       	call   80102b00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ba9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104bac:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104baf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104bb3:	89 04 24             	mov    %eax,(%esp)
80104bb6:	e8 55 d3 ff ff       	call   80101f10 <nameiparent>
80104bbb:	85 c0                	test   %eax,%eax
80104bbd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104bc0:	0f 84 4f 01 00 00    	je     80104d15 <sys_unlink+0x195>
  ilock(dp);
80104bc6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104bc9:	89 34 24             	mov    %esi,(%esp)
80104bcc:	e8 cf ca ff ff       	call   801016a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104bd1:	c7 44 24 04 1c 75 10 	movl   $0x8010751c,0x4(%esp)
80104bd8:	80 
80104bd9:	89 1c 24             	mov    %ebx,(%esp)
80104bdc:	e8 9f cf ff ff       	call   80101b80 <namecmp>
80104be1:	85 c0                	test   %eax,%eax
80104be3:	0f 84 21 01 00 00    	je     80104d0a <sys_unlink+0x18a>
80104be9:	c7 44 24 04 1b 75 10 	movl   $0x8010751b,0x4(%esp)
80104bf0:	80 
80104bf1:	89 1c 24             	mov    %ebx,(%esp)
80104bf4:	e8 87 cf ff ff       	call   80101b80 <namecmp>
80104bf9:	85 c0                	test   %eax,%eax
80104bfb:	0f 84 09 01 00 00    	je     80104d0a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104c01:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c04:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c08:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c0c:	89 34 24             	mov    %esi,(%esp)
80104c0f:	e8 9c cf ff ff       	call   80101bb0 <dirlookup>
80104c14:	85 c0                	test   %eax,%eax
80104c16:	89 c3                	mov    %eax,%ebx
80104c18:	0f 84 ec 00 00 00    	je     80104d0a <sys_unlink+0x18a>
  ilock(ip);
80104c1e:	89 04 24             	mov    %eax,(%esp)
80104c21:	e8 7a ca ff ff       	call   801016a0 <ilock>
  if(ip->nlink < 1)
80104c26:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c2b:	0f 8e 24 01 00 00    	jle    80104d55 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c36:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c39:	74 7d                	je     80104cb8 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104c3b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104c42:	00 
80104c43:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c4a:	00 
80104c4b:	89 34 24             	mov    %esi,(%esp)
80104c4e:	e8 1d f6 ff ff       	call   80104270 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104c53:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c56:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104c5d:	00 
80104c5e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104c62:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c66:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c69:	89 04 24             	mov    %eax,(%esp)
80104c6c:	e8 df cd ff ff       	call   80101a50 <writei>
80104c71:	83 f8 10             	cmp    $0x10,%eax
80104c74:	0f 85 cf 00 00 00    	jne    80104d49 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104c7a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c7f:	0f 84 a3 00 00 00    	je     80104d28 <sys_unlink+0x1a8>
  iunlockput(dp);
80104c85:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c88:	89 04 24             	mov    %eax,(%esp)
80104c8b:	e8 70 cc ff ff       	call   80101900 <iunlockput>
  ip->nlink--;
80104c90:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c95:	89 1c 24             	mov    %ebx,(%esp)
80104c98:	e8 43 c9 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104c9d:	89 1c 24             	mov    %ebx,(%esp)
80104ca0:	e8 5b cc ff ff       	call   80101900 <iunlockput>
  end_op();
80104ca5:	e8 c6 de ff ff       	call   80102b70 <end_op>
}
80104caa:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104cad:	31 c0                	xor    %eax,%eax
}
80104caf:	5b                   	pop    %ebx
80104cb0:	5e                   	pop    %esi
80104cb1:	5f                   	pop    %edi
80104cb2:	5d                   	pop    %ebp
80104cb3:	c3                   	ret    
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104cb8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104cbc:	0f 86 79 ff ff ff    	jbe    80104c3b <sys_unlink+0xbb>
80104cc2:	bf 20 00 00 00       	mov    $0x20,%edi
80104cc7:	eb 15                	jmp    80104cde <sys_unlink+0x15e>
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd0:	8d 57 10             	lea    0x10(%edi),%edx
80104cd3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104cd6:	0f 83 5f ff ff ff    	jae    80104c3b <sys_unlink+0xbb>
80104cdc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cde:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104ce5:	00 
80104ce6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104cea:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cee:	89 1c 24             	mov    %ebx,(%esp)
80104cf1:	e8 5a cc ff ff       	call   80101950 <readi>
80104cf6:	83 f8 10             	cmp    $0x10,%eax
80104cf9:	75 42                	jne    80104d3d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104cfb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d00:	74 ce                	je     80104cd0 <sys_unlink+0x150>
    iunlockput(ip);
80104d02:	89 1c 24             	mov    %ebx,(%esp)
80104d05:	e8 f6 cb ff ff       	call   80101900 <iunlockput>
  iunlockput(dp);
80104d0a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d0d:	89 04 24             	mov    %eax,(%esp)
80104d10:	e8 eb cb ff ff       	call   80101900 <iunlockput>
  end_op();
80104d15:	e8 56 de ff ff       	call   80102b70 <end_op>
}
80104d1a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104d1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d22:	5b                   	pop    %ebx
80104d23:	5e                   	pop    %esi
80104d24:	5f                   	pop    %edi
80104d25:	5d                   	pop    %ebp
80104d26:	c3                   	ret    
80104d27:	90                   	nop
    dp->nlink--;
80104d28:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d2b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104d30:	89 04 24             	mov    %eax,(%esp)
80104d33:	e8 a8 c8 ff ff       	call   801015e0 <iupdate>
80104d38:	e9 48 ff ff ff       	jmp    80104c85 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104d3d:	c7 04 24 40 75 10 80 	movl   $0x80107540,(%esp)
80104d44:	e8 17 b6 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104d49:	c7 04 24 52 75 10 80 	movl   $0x80107552,(%esp)
80104d50:	e8 0b b6 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104d55:	c7 04 24 2e 75 10 80 	movl   $0x8010752e,(%esp)
80104d5c:	e8 ff b5 ff ff       	call   80100360 <panic>
80104d61:	eb 0d                	jmp    80104d70 <sys_open>
80104d63:	90                   	nop
80104d64:	90                   	nop
80104d65:	90                   	nop
80104d66:	90                   	nop
80104d67:	90                   	nop
80104d68:	90                   	nop
80104d69:	90                   	nop
80104d6a:	90                   	nop
80104d6b:	90                   	nop
80104d6c:	90                   	nop
80104d6d:	90                   	nop
80104d6e:	90                   	nop
80104d6f:	90                   	nop

80104d70 <sys_open>:

int
sys_open(void)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	56                   	push   %esi
80104d75:	53                   	push   %ebx
80104d76:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104d79:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d87:	e8 24 f8 ff ff       	call   801045b0 <argstr>
80104d8c:	85 c0                	test   %eax,%eax
80104d8e:	0f 88 d1 00 00 00    	js     80104e65 <sys_open+0xf5>
80104d94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104d97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104da2:	e8 79 f7 ff ff       	call   80104520 <argint>
80104da7:	85 c0                	test   %eax,%eax
80104da9:	0f 88 b6 00 00 00    	js     80104e65 <sys_open+0xf5>
    return -1;

  begin_op();
80104daf:	e8 4c dd ff ff       	call   80102b00 <begin_op>

  if(omode & O_CREATE){
80104db4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104db8:	0f 85 82 00 00 00    	jne    80104e40 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104dbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dc1:	89 04 24             	mov    %eax,(%esp)
80104dc4:	e8 27 d1 ff ff       	call   80101ef0 <namei>
80104dc9:	85 c0                	test   %eax,%eax
80104dcb:	89 c6                	mov    %eax,%esi
80104dcd:	0f 84 8d 00 00 00    	je     80104e60 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104dd3:	89 04 24             	mov    %eax,(%esp)
80104dd6:	e8 c5 c8 ff ff       	call   801016a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ddb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104de0:	0f 84 92 00 00 00    	je     80104e78 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104de6:	e8 65 bf ff ff       	call   80100d50 <filealloc>
80104deb:	85 c0                	test   %eax,%eax
80104ded:	89 c3                	mov    %eax,%ebx
80104def:	0f 84 93 00 00 00    	je     80104e88 <sys_open+0x118>
80104df5:	e8 86 f8 ff ff       	call   80104680 <fdalloc>
80104dfa:	85 c0                	test   %eax,%eax
80104dfc:	89 c7                	mov    %eax,%edi
80104dfe:	0f 88 94 00 00 00    	js     80104e98 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104e04:	89 34 24             	mov    %esi,(%esp)
80104e07:	e8 74 c9 ff ff       	call   80101780 <iunlock>
  end_op();
80104e0c:	e8 5f dd ff ff       	call   80102b70 <end_op>

  f->type = FD_INODE;
80104e11:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104e1a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104e1d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e24:	89 c2                	mov    %eax,%edx
80104e26:	83 e2 01             	and    $0x1,%edx
80104e29:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e2c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104e2e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104e31:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e33:	0f 95 43 09          	setne  0x9(%ebx)
}
80104e37:	83 c4 2c             	add    $0x2c,%esp
80104e3a:	5b                   	pop    %ebx
80104e3b:	5e                   	pop    %esi
80104e3c:	5f                   	pop    %edi
80104e3d:	5d                   	pop    %ebp
80104e3e:	c3                   	ret    
80104e3f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e43:	31 c9                	xor    %ecx,%ecx
80104e45:	ba 02 00 00 00       	mov    $0x2,%edx
80104e4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e51:	e8 6a f8 ff ff       	call   801046c0 <create>
    if(ip == 0){
80104e56:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104e58:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104e5a:	75 8a                	jne    80104de6 <sys_open+0x76>
80104e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104e60:	e8 0b dd ff ff       	call   80102b70 <end_op>
}
80104e65:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e6d:	5b                   	pop    %ebx
80104e6e:	5e                   	pop    %esi
80104e6f:	5f                   	pop    %edi
80104e70:	5d                   	pop    %ebp
80104e71:	c3                   	ret    
80104e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e7b:	85 c0                	test   %eax,%eax
80104e7d:	0f 84 63 ff ff ff    	je     80104de6 <sys_open+0x76>
80104e83:	90                   	nop
80104e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104e88:	89 34 24             	mov    %esi,(%esp)
80104e8b:	e8 70 ca ff ff       	call   80101900 <iunlockput>
80104e90:	eb ce                	jmp    80104e60 <sys_open+0xf0>
80104e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104e98:	89 1c 24             	mov    %ebx,(%esp)
80104e9b:	e8 70 bf ff ff       	call   80100e10 <fileclose>
80104ea0:	eb e6                	jmp    80104e88 <sys_open+0x118>
80104ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <sys_mkdir>:

int
sys_mkdir(void)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104eb6:	e8 45 dc ff ff       	call   80102b00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104ebb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ec2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ec9:	e8 e2 f6 ff ff       	call   801045b0 <argstr>
80104ece:	85 c0                	test   %eax,%eax
80104ed0:	78 2e                	js     80104f00 <sys_mkdir+0x50>
80104ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed5:	31 c9                	xor    %ecx,%ecx
80104ed7:	ba 01 00 00 00       	mov    $0x1,%edx
80104edc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ee3:	e8 d8 f7 ff ff       	call   801046c0 <create>
80104ee8:	85 c0                	test   %eax,%eax
80104eea:	74 14                	je     80104f00 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104eec:	89 04 24             	mov    %eax,(%esp)
80104eef:	e8 0c ca ff ff       	call   80101900 <iunlockput>
  end_op();
80104ef4:	e8 77 dc ff ff       	call   80102b70 <end_op>
  return 0;
80104ef9:	31 c0                	xor    %eax,%eax
}
80104efb:	c9                   	leave  
80104efc:	c3                   	ret    
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f00:	e8 6b dc ff ff       	call   80102b70 <end_op>
    return -1;
80104f05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f0a:	c9                   	leave  
80104f0b:	c3                   	ret    
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f10 <sys_mknod>:

int
sys_mknod(void)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104f16:	e8 e5 db ff ff       	call   80102b00 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104f1b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f29:	e8 82 f6 ff ff       	call   801045b0 <argstr>
80104f2e:	85 c0                	test   %eax,%eax
80104f30:	78 5e                	js     80104f90 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104f32:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f35:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f40:	e8 db f5 ff ff       	call   80104520 <argint>
  if((argstr(0, &path)) < 0 ||
80104f45:	85 c0                	test   %eax,%eax
80104f47:	78 47                	js     80104f90 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104f49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f50:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104f57:	e8 c4 f5 ff ff       	call   80104520 <argint>
     argint(1, &major) < 0 ||
80104f5c:	85 c0                	test   %eax,%eax
80104f5e:	78 30                	js     80104f90 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f60:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80104f64:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f69:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104f6d:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f73:	e8 48 f7 ff ff       	call   801046c0 <create>
80104f78:	85 c0                	test   %eax,%eax
80104f7a:	74 14                	je     80104f90 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f7c:	89 04 24             	mov    %eax,(%esp)
80104f7f:	e8 7c c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104f84:	e8 e7 db ff ff       	call   80102b70 <end_op>
  return 0;
80104f89:	31 c0                	xor    %eax,%eax
}
80104f8b:	c9                   	leave  
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f90:	e8 db db ff ff       	call   80102b70 <end_op>
    return -1;
80104f95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f9a:	c9                   	leave  
80104f9b:	c3                   	ret    
80104f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <sys_chdir>:

int
sys_chdir(void)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
80104fa5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104fa8:	e8 e3 e6 ff ff       	call   80103690 <myproc>
80104fad:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104faf:	e8 4c db ff ff       	call   80102b00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fbb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fc2:	e8 e9 f5 ff ff       	call   801045b0 <argstr>
80104fc7:	85 c0                	test   %eax,%eax
80104fc9:	78 4a                	js     80105015 <sys_chdir+0x75>
80104fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fce:	89 04 24             	mov    %eax,(%esp)
80104fd1:	e8 1a cf ff ff       	call   80101ef0 <namei>
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	89 c3                	mov    %eax,%ebx
80104fda:	74 39                	je     80105015 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
80104fdc:	89 04 24             	mov    %eax,(%esp)
80104fdf:	e8 bc c6 ff ff       	call   801016a0 <ilock>
  if(ip->type != T_DIR){
80104fe4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80104fe9:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
80104fec:	75 22                	jne    80105010 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
80104fee:	e8 8d c7 ff ff       	call   80101780 <iunlock>
  iput(curproc->cwd);
80104ff3:	8b 46 68             	mov    0x68(%esi),%eax
80104ff6:	89 04 24             	mov    %eax,(%esp)
80104ff9:	e8 c2 c7 ff ff       	call   801017c0 <iput>
  end_op();
80104ffe:	e8 6d db ff ff       	call   80102b70 <end_op>
  curproc->cwd = ip;
  return 0;
80105003:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105005:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105008:	83 c4 20             	add    $0x20,%esp
8010500b:	5b                   	pop    %ebx
8010500c:	5e                   	pop    %esi
8010500d:	5d                   	pop    %ebp
8010500e:	c3                   	ret    
8010500f:	90                   	nop
    iunlockput(ip);
80105010:	e8 eb c8 ff ff       	call   80101900 <iunlockput>
    end_op();
80105015:	e8 56 db ff ff       	call   80102b70 <end_op>
}
8010501a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010501d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105022:	5b                   	pop    %ebx
80105023:	5e                   	pop    %esi
80105024:	5d                   	pop    %ebp
80105025:	c3                   	ret    
80105026:	8d 76 00             	lea    0x0(%esi),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <sys_exec>:

int
sys_exec(void)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	57                   	push   %edi
80105034:	56                   	push   %esi
80105035:	53                   	push   %ebx
80105036:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010503c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105042:	89 44 24 04          	mov    %eax,0x4(%esp)
80105046:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010504d:	e8 5e f5 ff ff       	call   801045b0 <argstr>
80105052:	85 c0                	test   %eax,%eax
80105054:	0f 88 84 00 00 00    	js     801050de <sys_exec+0xae>
8010505a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105060:	89 44 24 04          	mov    %eax,0x4(%esp)
80105064:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010506b:	e8 b0 f4 ff ff       	call   80104520 <argint>
80105070:	85 c0                	test   %eax,%eax
80105072:	78 6a                	js     801050de <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105074:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010507a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010507c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105083:	00 
80105084:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010508a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105091:	00 
80105092:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105098:	89 04 24             	mov    %eax,(%esp)
8010509b:	e8 d0 f1 ff ff       	call   80104270 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801050a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801050a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801050aa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801050ad:	89 04 24             	mov    %eax,(%esp)
801050b0:	e8 0b f4 ff ff       	call   801044c0 <fetchint>
801050b5:	85 c0                	test   %eax,%eax
801050b7:	78 25                	js     801050de <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801050b9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801050bf:	85 c0                	test   %eax,%eax
801050c1:	74 2d                	je     801050f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801050c3:	89 74 24 04          	mov    %esi,0x4(%esp)
801050c7:	89 04 24             	mov    %eax,(%esp)
801050ca:	e8 11 f4 ff ff       	call   801044e0 <fetchstr>
801050cf:	85 c0                	test   %eax,%eax
801050d1:	78 0b                	js     801050de <sys_exec+0xae>
  for(i=0;; i++){
801050d3:	83 c3 01             	add    $0x1,%ebx
801050d6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801050d9:	83 fb 20             	cmp    $0x20,%ebx
801050dc:	75 c2                	jne    801050a0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
801050de:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
801050e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050e9:	5b                   	pop    %ebx
801050ea:	5e                   	pop    %esi
801050eb:	5f                   	pop    %edi
801050ec:	5d                   	pop    %ebp
801050ed:	c3                   	ret    
801050ee:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
801050f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801050f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801050fa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105100:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105107:	00 00 00 00 
  return exec(path, argv);
8010510b:	89 04 24             	mov    %eax,(%esp)
8010510e:	e8 8d b8 ff ff       	call   801009a0 <exec>
}
80105113:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105119:	5b                   	pop    %ebx
8010511a:	5e                   	pop    %esi
8010511b:	5f                   	pop    %edi
8010511c:	5d                   	pop    %ebp
8010511d:	c3                   	ret    
8010511e:	66 90                	xchg   %ax,%ax

80105120 <sys_pipe>:

int
sys_pipe(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	53                   	push   %ebx
80105124:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105127:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010512a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105131:	00 
80105132:	89 44 24 04          	mov    %eax,0x4(%esp)
80105136:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010513d:	e8 1e f4 ff ff       	call   80104560 <argptr>
80105142:	85 c0                	test   %eax,%eax
80105144:	78 6d                	js     801051b3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105146:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105149:	89 44 24 04          	mov    %eax,0x4(%esp)
8010514d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105150:	89 04 24             	mov    %eax,(%esp)
80105153:	e8 08 e0 ff ff       	call   80103160 <pipealloc>
80105158:	85 c0                	test   %eax,%eax
8010515a:	78 57                	js     801051b3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010515c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010515f:	e8 1c f5 ff ff       	call   80104680 <fdalloc>
80105164:	85 c0                	test   %eax,%eax
80105166:	89 c3                	mov    %eax,%ebx
80105168:	78 33                	js     8010519d <sys_pipe+0x7d>
8010516a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010516d:	e8 0e f5 ff ff       	call   80104680 <fdalloc>
80105172:	85 c0                	test   %eax,%eax
80105174:	78 1a                	js     80105190 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105176:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105179:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010517b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010517e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105181:	83 c4 24             	add    $0x24,%esp
  return 0;
80105184:	31 c0                	xor    %eax,%eax
}
80105186:	5b                   	pop    %ebx
80105187:	5d                   	pop    %ebp
80105188:	c3                   	ret    
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105190:	e8 fb e4 ff ff       	call   80103690 <myproc>
80105195:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010519c:	00 
    fileclose(rf);
8010519d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051a0:	89 04 24             	mov    %eax,(%esp)
801051a3:	e8 68 bc ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
801051a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ab:	89 04 24             	mov    %eax,(%esp)
801051ae:	e8 5d bc ff ff       	call   80100e10 <fileclose>
}
801051b3:	83 c4 24             	add    $0x24,%esp
    return -1;
801051b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051bb:	5b                   	pop    %ebx
801051bc:	5d                   	pop    %ebp
801051bd:	c3                   	ret    
801051be:	66 90                	xchg   %ax,%ax

801051c0 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
801051c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051d4:	e8 47 f3 ff ff       	call   80104520 <argint>
801051d9:	85 c0                	test   %eax,%eax
801051db:	78 33                	js     80105210 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
801051dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051e0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801051e7:	00 
801051e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051f3:	e8 68 f3 ff ff       	call   80104560 <argptr>
801051f8:	85 c0                	test   %eax,%eax
801051fa:	78 14                	js     80105210 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
801051fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80105203:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105206:	89 04 24             	mov    %eax,(%esp)
80105209:	e8 82 1b 00 00       	call   80106d90 <shm_open>
}
8010520e:	c9                   	leave  
8010520f:	c3                   	ret    
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105215:	c9                   	leave  
80105216:	c3                   	ret    
80105217:	89 f6                	mov    %esi,%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105220 <sys_shm_close>:

int sys_shm_close(void) {
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105226:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105229:	89 44 24 04          	mov    %eax,0x4(%esp)
8010522d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105234:	e8 e7 f2 ff ff       	call   80104520 <argint>
80105239:	85 c0                	test   %eax,%eax
8010523b:	78 13                	js     80105250 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
8010523d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105240:	89 04 24             	mov    %eax,(%esp)
80105243:	e8 58 1b 00 00       	call   80106da0 <shm_close>
}
80105248:	c9                   	leave  
80105249:	c3                   	ret    
8010524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105255:	c9                   	leave  
80105256:	c3                   	ret    
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <sys_fork>:

int
sys_fork(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105263:	5d                   	pop    %ebp
  return fork();
80105264:	e9 d7 e5 ff ff       	jmp    80103840 <fork>
80105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_exit>:

int
sys_exit(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 08             	sub    $0x8,%esp
  exit();
80105276:	e8 15 e8 ff ff       	call   80103a90 <exit>
  return 0;  // not reached
}
8010527b:	31 c0                	xor    %eax,%eax
8010527d:	c9                   	leave  
8010527e:	c3                   	ret    
8010527f:	90                   	nop

80105280 <sys_wait>:

int
sys_wait(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105283:	5d                   	pop    %ebp
  return wait();
80105284:	e9 17 ea ff ff       	jmp    80103ca0 <wait>
80105289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105290 <sys_kill>:

int
sys_kill(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105296:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105299:	89 44 24 04          	mov    %eax,0x4(%esp)
8010529d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052a4:	e8 77 f2 ff ff       	call   80104520 <argint>
801052a9:	85 c0                	test   %eax,%eax
801052ab:	78 13                	js     801052c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801052ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b0:	89 04 24             	mov    %eax,(%esp)
801052b3:	e8 28 eb ff ff       	call   80103de0 <kill>
}
801052b8:	c9                   	leave  
801052b9:	c3                   	ret    
801052ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052c5:	c9                   	leave  
801052c6:	c3                   	ret    
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052d0 <sys_getpid>:

int
sys_getpid(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801052d6:	e8 b5 e3 ff ff       	call   80103690 <myproc>
801052db:	8b 40 10             	mov    0x10(%eax),%eax
}
801052de:	c9                   	leave  
801052df:	c3                   	ret    

801052e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	53                   	push   %ebx
801052e4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801052e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052f5:	e8 26 f2 ff ff       	call   80104520 <argint>
801052fa:	85 c0                	test   %eax,%eax
801052fc:	78 22                	js     80105320 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801052fe:	e8 8d e3 ff ff       	call   80103690 <myproc>
  if(growproc(n) < 0)
80105303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
80105306:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105308:	89 14 24             	mov    %edx,(%esp)
8010530b:	e8 c0 e4 ff ff       	call   801037d0 <growproc>
80105310:	85 c0                	test   %eax,%eax
80105312:	78 0c                	js     80105320 <sys_sbrk+0x40>
    return -1;
  return addr;
80105314:	89 d8                	mov    %ebx,%eax
}
80105316:	83 c4 24             	add    $0x24,%esp
80105319:	5b                   	pop    %ebx
8010531a:	5d                   	pop    %ebp
8010531b:	c3                   	ret    
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105325:	eb ef                	jmp    80105316 <sys_sbrk+0x36>
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <sys_sleep>:

int
sys_sleep(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	53                   	push   %ebx
80105334:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105337:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010533e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105345:	e8 d6 f1 ff ff       	call   80104520 <argint>
8010534a:	85 c0                	test   %eax,%eax
8010534c:	78 7e                	js     801053cc <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010534e:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105355:	e8 d6 ed ff ff       	call   80104130 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010535a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010535d:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105363:	85 d2                	test   %edx,%edx
80105365:	75 29                	jne    80105390 <sys_sleep+0x60>
80105367:	eb 4f                	jmp    801053b8 <sys_sleep+0x88>
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105370:	c7 44 24 04 60 4d 11 	movl   $0x80114d60,0x4(%esp)
80105377:	80 
80105378:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
8010537f:	e8 6c e8 ff ff       	call   80103bf0 <sleep>
  while(ticks - ticks0 < n){
80105384:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105389:	29 d8                	sub    %ebx,%eax
8010538b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010538e:	73 28                	jae    801053b8 <sys_sleep+0x88>
    if(myproc()->killed){
80105390:	e8 fb e2 ff ff       	call   80103690 <myproc>
80105395:	8b 40 24             	mov    0x24(%eax),%eax
80105398:	85 c0                	test   %eax,%eax
8010539a:	74 d4                	je     80105370 <sys_sleep+0x40>
      release(&tickslock);
8010539c:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053a3:	e8 78 ee ff ff       	call   80104220 <release>
      return -1;
801053a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801053ad:	83 c4 24             	add    $0x24,%esp
801053b0:	5b                   	pop    %ebx
801053b1:	5d                   	pop    %ebp
801053b2:	c3                   	ret    
801053b3:	90                   	nop
801053b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
801053b8:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053bf:	e8 5c ee ff ff       	call   80104220 <release>
}
801053c4:	83 c4 24             	add    $0x24,%esp
  return 0;
801053c7:	31 c0                	xor    %eax,%eax
}
801053c9:	5b                   	pop    %ebx
801053ca:	5d                   	pop    %ebp
801053cb:	c3                   	ret    
    return -1;
801053cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d1:	eb da                	jmp    801053ad <sys_sleep+0x7d>
801053d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	53                   	push   %ebx
801053e4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801053e7:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053ee:	e8 3d ed ff ff       	call   80104130 <acquire>
  xticks = ticks;
801053f3:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801053f9:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105400:	e8 1b ee ff ff       	call   80104220 <release>
  return xticks;
}
80105405:	83 c4 14             	add    $0x14,%esp
80105408:	89 d8                	mov    %ebx,%eax
8010540a:	5b                   	pop    %ebx
8010540b:	5d                   	pop    %ebp
8010540c:	c3                   	ret    

8010540d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010540d:	1e                   	push   %ds
  pushl %es
8010540e:	06                   	push   %es
  pushl %fs
8010540f:	0f a0                	push   %fs
  pushl %gs
80105411:	0f a8                	push   %gs
  pushal
80105413:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105414:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105418:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010541a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010541c:	54                   	push   %esp
  call trap
8010541d:	e8 de 00 00 00       	call   80105500 <trap>
  addl $4, %esp
80105422:	83 c4 04             	add    $0x4,%esp

80105425 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105425:	61                   	popa   
  popl %gs
80105426:	0f a9                	pop    %gs
  popl %fs
80105428:	0f a1                	pop    %fs
  popl %es
8010542a:	07                   	pop    %es
  popl %ds
8010542b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010542c:	83 c4 08             	add    $0x8,%esp
  iret
8010542f:	cf                   	iret   

80105430 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105430:	31 c0                	xor    %eax,%eax
80105432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105438:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010543f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105444:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
8010544b:	80 
8010544c:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
80105453:	00 
80105454:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
8010545b:	8e 
8010545c:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105463:	80 
80105464:	c1 ea 10             	shr    $0x10,%edx
80105467:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
8010546e:	80 
  for(i = 0; i < 256; i++)
8010546f:	83 c0 01             	add    $0x1,%eax
80105472:	3d 00 01 00 00       	cmp    $0x100,%eax
80105477:	75 bf                	jne    80105438 <tvinit+0x8>
{
80105479:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010547a:	ba 08 00 00 00       	mov    $0x8,%edx
{
8010547f:	89 e5                	mov    %esp,%ebp
80105481:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105484:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105489:	c7 44 24 04 61 75 10 	movl   $0x80107561,0x4(%esp)
80105490:	80 
80105491:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105498:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
8010549f:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
801054a5:	c1 e8 10             	shr    $0x10,%eax
801054a8:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
801054af:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
801054b6:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
801054bc:	e8 7f eb ff ff       	call   80104040 <initlock>
}
801054c1:	c9                   	leave  
801054c2:	c3                   	ret    
801054c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054d0 <idtinit>:

void
idtinit(void)
{
801054d0:	55                   	push   %ebp
  pd[0] = size-1;
801054d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801054d6:	89 e5                	mov    %esp,%ebp
801054d8:	83 ec 10             	sub    $0x10,%esp
801054db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801054df:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
801054e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801054e8:	c1 e8 10             	shr    $0x10,%eax
801054eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801054ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801054f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801054f5:	c9                   	leave  
801054f6:	c3                   	ret    
801054f7:	89 f6                	mov    %esi,%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105500 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
80105505:	53                   	push   %ebx
80105506:	83 ec 3c             	sub    $0x3c,%esp
80105509:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010550c:	8b 43 30             	mov    0x30(%ebx),%eax
8010550f:	83 f8 40             	cmp    $0x40,%eax
80105512:	0f 84 a0 01 00 00    	je     801056b8 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105518:	83 e8 20             	sub    $0x20,%eax
8010551b:	83 f8 1f             	cmp    $0x1f,%eax
8010551e:	77 08                	ja     80105528 <trap+0x28>
80105520:	ff 24 85 08 76 10 80 	jmp    *-0x7fef89f8(,%eax,4)
80105527:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105528:	e8 63 e1 ff ff       	call   80103690 <myproc>
8010552d:	85 c0                	test   %eax,%eax
8010552f:	90                   	nop
80105530:	0f 84 fa 01 00 00    	je     80105730 <trap+0x230>
80105536:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010553a:	0f 84 f0 01 00 00    	je     80105730 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105540:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105543:	8b 53 38             	mov    0x38(%ebx),%edx
80105546:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105549:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010554c:	e8 1f e1 ff ff       	call   80103670 <cpuid>
80105551:	8b 73 30             	mov    0x30(%ebx),%esi
80105554:	89 c7                	mov    %eax,%edi
80105556:	8b 43 34             	mov    0x34(%ebx),%eax
80105559:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010555c:	e8 2f e1 ff ff       	call   80103690 <myproc>
80105561:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105564:	e8 27 e1 ff ff       	call   80103690 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105569:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010556c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105570:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105573:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105576:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010557a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010557e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105581:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105584:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105588:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010558c:	89 54 24 10          	mov    %edx,0x10(%esp)
80105590:	8b 40 10             	mov    0x10(%eax),%eax
80105593:	c7 04 24 c4 75 10 80 	movl   $0x801075c4,(%esp)
8010559a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010559e:	e8 ad b0 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801055a3:	e8 e8 e0 ff ff       	call   80103690 <myproc>
801055a8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801055af:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055b0:	e8 db e0 ff ff       	call   80103690 <myproc>
801055b5:	85 c0                	test   %eax,%eax
801055b7:	74 0c                	je     801055c5 <trap+0xc5>
801055b9:	e8 d2 e0 ff ff       	call   80103690 <myproc>
801055be:	8b 50 24             	mov    0x24(%eax),%edx
801055c1:	85 d2                	test   %edx,%edx
801055c3:	75 4b                	jne    80105610 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801055c5:	e8 c6 e0 ff ff       	call   80103690 <myproc>
801055ca:	85 c0                	test   %eax,%eax
801055cc:	74 0d                	je     801055db <trap+0xdb>
801055ce:	66 90                	xchg   %ax,%ax
801055d0:	e8 bb e0 ff ff       	call   80103690 <myproc>
801055d5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801055d9:	74 4d                	je     80105628 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055db:	e8 b0 e0 ff ff       	call   80103690 <myproc>
801055e0:	85 c0                	test   %eax,%eax
801055e2:	74 1d                	je     80105601 <trap+0x101>
801055e4:	e8 a7 e0 ff ff       	call   80103690 <myproc>
801055e9:	8b 40 24             	mov    0x24(%eax),%eax
801055ec:	85 c0                	test   %eax,%eax
801055ee:	74 11                	je     80105601 <trap+0x101>
801055f0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801055f4:	83 e0 03             	and    $0x3,%eax
801055f7:	66 83 f8 03          	cmp    $0x3,%ax
801055fb:	0f 84 e8 00 00 00    	je     801056e9 <trap+0x1e9>
    exit();
}
80105601:	83 c4 3c             	add    $0x3c,%esp
80105604:	5b                   	pop    %ebx
80105605:	5e                   	pop    %esi
80105606:	5f                   	pop    %edi
80105607:	5d                   	pop    %ebp
80105608:	c3                   	ret    
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105610:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105614:	83 e0 03             	and    $0x3,%eax
80105617:	66 83 f8 03          	cmp    $0x3,%ax
8010561b:	75 a8                	jne    801055c5 <trap+0xc5>
    exit();
8010561d:	e8 6e e4 ff ff       	call   80103a90 <exit>
80105622:	eb a1                	jmp    801055c5 <trap+0xc5>
80105624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105628:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105630:	75 a9                	jne    801055db <trap+0xdb>
    yield();
80105632:	e8 79 e5 ff ff       	call   80103bb0 <yield>
80105637:	eb a2                	jmp    801055db <trap+0xdb>
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105640:	e8 2b e0 ff ff       	call   80103670 <cpuid>
80105645:	85 c0                	test   %eax,%eax
80105647:	0f 84 b3 00 00 00    	je     80105700 <trap+0x200>
8010564d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105650:	e8 1b d1 ff ff       	call   80102770 <lapiceoi>
    break;
80105655:	e9 56 ff ff ff       	jmp    801055b0 <trap+0xb0>
8010565a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105660:	e8 5b cf ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
80105665:	e8 06 d1 ff ff       	call   80102770 <lapiceoi>
    break;
8010566a:	e9 41 ff ff ff       	jmp    801055b0 <trap+0xb0>
8010566f:	90                   	nop
    uartintr();
80105670:	e8 1b 02 00 00       	call   80105890 <uartintr>
    lapiceoi();
80105675:	e8 f6 d0 ff ff       	call   80102770 <lapiceoi>
    break;
8010567a:	e9 31 ff ff ff       	jmp    801055b0 <trap+0xb0>
8010567f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105680:	8b 7b 38             	mov    0x38(%ebx),%edi
80105683:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105687:	e8 e4 df ff ff       	call   80103670 <cpuid>
8010568c:	c7 04 24 6c 75 10 80 	movl   $0x8010756c,(%esp)
80105693:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105697:	89 74 24 08          	mov    %esi,0x8(%esp)
8010569b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010569f:	e8 ac af ff ff       	call   80100650 <cprintf>
    lapiceoi();
801056a4:	e8 c7 d0 ff ff       	call   80102770 <lapiceoi>
    break;
801056a9:	e9 02 ff ff ff       	jmp    801055b0 <trap+0xb0>
801056ae:	66 90                	xchg   %ax,%ax
    ideintr();
801056b0:	e8 bb c9 ff ff       	call   80102070 <ideintr>
801056b5:	eb 96                	jmp    8010564d <trap+0x14d>
801056b7:	90                   	nop
801056b8:	90                   	nop
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801056c0:	e8 cb df ff ff       	call   80103690 <myproc>
801056c5:	8b 70 24             	mov    0x24(%eax),%esi
801056c8:	85 f6                	test   %esi,%esi
801056ca:	75 2c                	jne    801056f8 <trap+0x1f8>
    myproc()->tf = tf;
801056cc:	e8 bf df ff ff       	call   80103690 <myproc>
801056d1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801056d4:	e8 37 ef ff ff       	call   80104610 <syscall>
    if(myproc()->killed)
801056d9:	e8 b2 df ff ff       	call   80103690 <myproc>
801056de:	8b 48 24             	mov    0x24(%eax),%ecx
801056e1:	85 c9                	test   %ecx,%ecx
801056e3:	0f 84 18 ff ff ff    	je     80105601 <trap+0x101>
}
801056e9:	83 c4 3c             	add    $0x3c,%esp
801056ec:	5b                   	pop    %ebx
801056ed:	5e                   	pop    %esi
801056ee:	5f                   	pop    %edi
801056ef:	5d                   	pop    %ebp
      exit();
801056f0:	e9 9b e3 ff ff       	jmp    80103a90 <exit>
801056f5:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
801056f8:	e8 93 e3 ff ff       	call   80103a90 <exit>
801056fd:	eb cd                	jmp    801056cc <trap+0x1cc>
801056ff:	90                   	nop
      acquire(&tickslock);
80105700:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105707:	e8 24 ea ff ff       	call   80104130 <acquire>
      wakeup(&ticks);
8010570c:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105713:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
8010571a:	e8 61 e6 ff ff       	call   80103d80 <wakeup>
      release(&tickslock);
8010571f:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105726:	e8 f5 ea ff ff       	call   80104220 <release>
8010572b:	e9 1d ff ff ff       	jmp    8010564d <trap+0x14d>
80105730:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105733:	8b 73 38             	mov    0x38(%ebx),%esi
80105736:	e8 35 df ff ff       	call   80103670 <cpuid>
8010573b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010573f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105743:	89 44 24 08          	mov    %eax,0x8(%esp)
80105747:	8b 43 30             	mov    0x30(%ebx),%eax
8010574a:	c7 04 24 90 75 10 80 	movl   $0x80107590,(%esp)
80105751:	89 44 24 04          	mov    %eax,0x4(%esp)
80105755:	e8 f6 ae ff ff       	call   80100650 <cprintf>
      panic("trap");
8010575a:	c7 04 24 66 75 10 80 	movl   $0x80107566,(%esp)
80105761:	e8 fa ab ff ff       	call   80100360 <panic>
80105766:	66 90                	xchg   %ax,%ax
80105768:	66 90                	xchg   %ax,%ax
8010576a:	66 90                	xchg   %ax,%ax
8010576c:	66 90                	xchg   %ax,%ax
8010576e:	66 90                	xchg   %ax,%ax

80105770 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105770:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105775:	55                   	push   %ebp
80105776:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105778:	85 c0                	test   %eax,%eax
8010577a:	74 14                	je     80105790 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010577c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105781:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105782:	a8 01                	test   $0x1,%al
80105784:	74 0a                	je     80105790 <uartgetc+0x20>
80105786:	b2 f8                	mov    $0xf8,%dl
80105788:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105789:	0f b6 c0             	movzbl %al,%eax
}
8010578c:	5d                   	pop    %ebp
8010578d:	c3                   	ret    
8010578e:	66 90                	xchg   %ax,%ax
    return -1;
80105790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105795:	5d                   	pop    %ebp
80105796:	c3                   	ret    
80105797:	89 f6                	mov    %esi,%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057a0 <uartputc>:
  if(!uart)
801057a0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
801057a5:	85 c0                	test   %eax,%eax
801057a7:	74 3f                	je     801057e8 <uartputc+0x48>
{
801057a9:	55                   	push   %ebp
801057aa:	89 e5                	mov    %esp,%ebp
801057ac:	56                   	push   %esi
801057ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801057b2:	53                   	push   %ebx
  if(!uart)
801057b3:	bb 80 00 00 00       	mov    $0x80,%ebx
{
801057b8:	83 ec 10             	sub    $0x10,%esp
801057bb:	eb 14                	jmp    801057d1 <uartputc+0x31>
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801057c0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801057c7:	e8 c4 cf ff ff       	call   80102790 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801057cc:	83 eb 01             	sub    $0x1,%ebx
801057cf:	74 07                	je     801057d8 <uartputc+0x38>
801057d1:	89 f2                	mov    %esi,%edx
801057d3:	ec                   	in     (%dx),%al
801057d4:	a8 20                	test   $0x20,%al
801057d6:	74 e8                	je     801057c0 <uartputc+0x20>
  outb(COM1+0, c);
801057d8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801057dc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801057e1:	ee                   	out    %al,(%dx)
}
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	5b                   	pop    %ebx
801057e6:	5e                   	pop    %esi
801057e7:	5d                   	pop    %ebp
801057e8:	f3 c3                	repz ret 
801057ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057f0 <uartinit>:
{
801057f0:	55                   	push   %ebp
801057f1:	31 c9                	xor    %ecx,%ecx
801057f3:	89 e5                	mov    %esp,%ebp
801057f5:	89 c8                	mov    %ecx,%eax
801057f7:	57                   	push   %edi
801057f8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801057fd:	56                   	push   %esi
801057fe:	89 fa                	mov    %edi,%edx
80105800:	53                   	push   %ebx
80105801:	83 ec 1c             	sub    $0x1c,%esp
80105804:	ee                   	out    %al,(%dx)
80105805:	be fb 03 00 00       	mov    $0x3fb,%esi
8010580a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010580f:	89 f2                	mov    %esi,%edx
80105811:	ee                   	out    %al,(%dx)
80105812:	b8 0c 00 00 00       	mov    $0xc,%eax
80105817:	b2 f8                	mov    $0xf8,%dl
80105819:	ee                   	out    %al,(%dx)
8010581a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010581f:	89 c8                	mov    %ecx,%eax
80105821:	89 da                	mov    %ebx,%edx
80105823:	ee                   	out    %al,(%dx)
80105824:	b8 03 00 00 00       	mov    $0x3,%eax
80105829:	89 f2                	mov    %esi,%edx
8010582b:	ee                   	out    %al,(%dx)
8010582c:	b2 fc                	mov    $0xfc,%dl
8010582e:	89 c8                	mov    %ecx,%eax
80105830:	ee                   	out    %al,(%dx)
80105831:	b8 01 00 00 00       	mov    $0x1,%eax
80105836:	89 da                	mov    %ebx,%edx
80105838:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105839:	b2 fd                	mov    $0xfd,%dl
8010583b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010583c:	3c ff                	cmp    $0xff,%al
8010583e:	74 42                	je     80105882 <uartinit+0x92>
  uart = 1;
80105840:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105847:	00 00 00 
8010584a:	89 fa                	mov    %edi,%edx
8010584c:	ec                   	in     (%dx),%al
8010584d:	b2 f8                	mov    $0xf8,%dl
8010584f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105850:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105857:	00 
  for(p="xv6...\n"; *p; p++)
80105858:	bb 88 76 10 80       	mov    $0x80107688,%ebx
  ioapicenable(IRQ_COM1, 0);
8010585d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105864:	e8 37 ca ff ff       	call   801022a0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105869:	b8 78 00 00 00       	mov    $0x78,%eax
8010586e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105870:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105873:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105876:	e8 25 ff ff ff       	call   801057a0 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010587b:	0f be 03             	movsbl (%ebx),%eax
8010587e:	84 c0                	test   %al,%al
80105880:	75 ee                	jne    80105870 <uartinit+0x80>
}
80105882:	83 c4 1c             	add    $0x1c,%esp
80105885:	5b                   	pop    %ebx
80105886:	5e                   	pop    %esi
80105887:	5f                   	pop    %edi
80105888:	5d                   	pop    %ebp
80105889:	c3                   	ret    
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105890 <uartintr>:

void
uartintr(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105896:	c7 04 24 70 57 10 80 	movl   $0x80105770,(%esp)
8010589d:	e8 0e af ff ff       	call   801007b0 <consoleintr>
}
801058a2:	c9                   	leave  
801058a3:	c3                   	ret    

801058a4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801058a4:	6a 00                	push   $0x0
  pushl $0
801058a6:	6a 00                	push   $0x0
  jmp alltraps
801058a8:	e9 60 fb ff ff       	jmp    8010540d <alltraps>

801058ad <vector1>:
.globl vector1
vector1:
  pushl $0
801058ad:	6a 00                	push   $0x0
  pushl $1
801058af:	6a 01                	push   $0x1
  jmp alltraps
801058b1:	e9 57 fb ff ff       	jmp    8010540d <alltraps>

801058b6 <vector2>:
.globl vector2
vector2:
  pushl $0
801058b6:	6a 00                	push   $0x0
  pushl $2
801058b8:	6a 02                	push   $0x2
  jmp alltraps
801058ba:	e9 4e fb ff ff       	jmp    8010540d <alltraps>

801058bf <vector3>:
.globl vector3
vector3:
  pushl $0
801058bf:	6a 00                	push   $0x0
  pushl $3
801058c1:	6a 03                	push   $0x3
  jmp alltraps
801058c3:	e9 45 fb ff ff       	jmp    8010540d <alltraps>

801058c8 <vector4>:
.globl vector4
vector4:
  pushl $0
801058c8:	6a 00                	push   $0x0
  pushl $4
801058ca:	6a 04                	push   $0x4
  jmp alltraps
801058cc:	e9 3c fb ff ff       	jmp    8010540d <alltraps>

801058d1 <vector5>:
.globl vector5
vector5:
  pushl $0
801058d1:	6a 00                	push   $0x0
  pushl $5
801058d3:	6a 05                	push   $0x5
  jmp alltraps
801058d5:	e9 33 fb ff ff       	jmp    8010540d <alltraps>

801058da <vector6>:
.globl vector6
vector6:
  pushl $0
801058da:	6a 00                	push   $0x0
  pushl $6
801058dc:	6a 06                	push   $0x6
  jmp alltraps
801058de:	e9 2a fb ff ff       	jmp    8010540d <alltraps>

801058e3 <vector7>:
.globl vector7
vector7:
  pushl $0
801058e3:	6a 00                	push   $0x0
  pushl $7
801058e5:	6a 07                	push   $0x7
  jmp alltraps
801058e7:	e9 21 fb ff ff       	jmp    8010540d <alltraps>

801058ec <vector8>:
.globl vector8
vector8:
  pushl $8
801058ec:	6a 08                	push   $0x8
  jmp alltraps
801058ee:	e9 1a fb ff ff       	jmp    8010540d <alltraps>

801058f3 <vector9>:
.globl vector9
vector9:
  pushl $0
801058f3:	6a 00                	push   $0x0
  pushl $9
801058f5:	6a 09                	push   $0x9
  jmp alltraps
801058f7:	e9 11 fb ff ff       	jmp    8010540d <alltraps>

801058fc <vector10>:
.globl vector10
vector10:
  pushl $10
801058fc:	6a 0a                	push   $0xa
  jmp alltraps
801058fe:	e9 0a fb ff ff       	jmp    8010540d <alltraps>

80105903 <vector11>:
.globl vector11
vector11:
  pushl $11
80105903:	6a 0b                	push   $0xb
  jmp alltraps
80105905:	e9 03 fb ff ff       	jmp    8010540d <alltraps>

8010590a <vector12>:
.globl vector12
vector12:
  pushl $12
8010590a:	6a 0c                	push   $0xc
  jmp alltraps
8010590c:	e9 fc fa ff ff       	jmp    8010540d <alltraps>

80105911 <vector13>:
.globl vector13
vector13:
  pushl $13
80105911:	6a 0d                	push   $0xd
  jmp alltraps
80105913:	e9 f5 fa ff ff       	jmp    8010540d <alltraps>

80105918 <vector14>:
.globl vector14
vector14:
  pushl $14
80105918:	6a 0e                	push   $0xe
  jmp alltraps
8010591a:	e9 ee fa ff ff       	jmp    8010540d <alltraps>

8010591f <vector15>:
.globl vector15
vector15:
  pushl $0
8010591f:	6a 00                	push   $0x0
  pushl $15
80105921:	6a 0f                	push   $0xf
  jmp alltraps
80105923:	e9 e5 fa ff ff       	jmp    8010540d <alltraps>

80105928 <vector16>:
.globl vector16
vector16:
  pushl $0
80105928:	6a 00                	push   $0x0
  pushl $16
8010592a:	6a 10                	push   $0x10
  jmp alltraps
8010592c:	e9 dc fa ff ff       	jmp    8010540d <alltraps>

80105931 <vector17>:
.globl vector17
vector17:
  pushl $17
80105931:	6a 11                	push   $0x11
  jmp alltraps
80105933:	e9 d5 fa ff ff       	jmp    8010540d <alltraps>

80105938 <vector18>:
.globl vector18
vector18:
  pushl $0
80105938:	6a 00                	push   $0x0
  pushl $18
8010593a:	6a 12                	push   $0x12
  jmp alltraps
8010593c:	e9 cc fa ff ff       	jmp    8010540d <alltraps>

80105941 <vector19>:
.globl vector19
vector19:
  pushl $0
80105941:	6a 00                	push   $0x0
  pushl $19
80105943:	6a 13                	push   $0x13
  jmp alltraps
80105945:	e9 c3 fa ff ff       	jmp    8010540d <alltraps>

8010594a <vector20>:
.globl vector20
vector20:
  pushl $0
8010594a:	6a 00                	push   $0x0
  pushl $20
8010594c:	6a 14                	push   $0x14
  jmp alltraps
8010594e:	e9 ba fa ff ff       	jmp    8010540d <alltraps>

80105953 <vector21>:
.globl vector21
vector21:
  pushl $0
80105953:	6a 00                	push   $0x0
  pushl $21
80105955:	6a 15                	push   $0x15
  jmp alltraps
80105957:	e9 b1 fa ff ff       	jmp    8010540d <alltraps>

8010595c <vector22>:
.globl vector22
vector22:
  pushl $0
8010595c:	6a 00                	push   $0x0
  pushl $22
8010595e:	6a 16                	push   $0x16
  jmp alltraps
80105960:	e9 a8 fa ff ff       	jmp    8010540d <alltraps>

80105965 <vector23>:
.globl vector23
vector23:
  pushl $0
80105965:	6a 00                	push   $0x0
  pushl $23
80105967:	6a 17                	push   $0x17
  jmp alltraps
80105969:	e9 9f fa ff ff       	jmp    8010540d <alltraps>

8010596e <vector24>:
.globl vector24
vector24:
  pushl $0
8010596e:	6a 00                	push   $0x0
  pushl $24
80105970:	6a 18                	push   $0x18
  jmp alltraps
80105972:	e9 96 fa ff ff       	jmp    8010540d <alltraps>

80105977 <vector25>:
.globl vector25
vector25:
  pushl $0
80105977:	6a 00                	push   $0x0
  pushl $25
80105979:	6a 19                	push   $0x19
  jmp alltraps
8010597b:	e9 8d fa ff ff       	jmp    8010540d <alltraps>

80105980 <vector26>:
.globl vector26
vector26:
  pushl $0
80105980:	6a 00                	push   $0x0
  pushl $26
80105982:	6a 1a                	push   $0x1a
  jmp alltraps
80105984:	e9 84 fa ff ff       	jmp    8010540d <alltraps>

80105989 <vector27>:
.globl vector27
vector27:
  pushl $0
80105989:	6a 00                	push   $0x0
  pushl $27
8010598b:	6a 1b                	push   $0x1b
  jmp alltraps
8010598d:	e9 7b fa ff ff       	jmp    8010540d <alltraps>

80105992 <vector28>:
.globl vector28
vector28:
  pushl $0
80105992:	6a 00                	push   $0x0
  pushl $28
80105994:	6a 1c                	push   $0x1c
  jmp alltraps
80105996:	e9 72 fa ff ff       	jmp    8010540d <alltraps>

8010599b <vector29>:
.globl vector29
vector29:
  pushl $0
8010599b:	6a 00                	push   $0x0
  pushl $29
8010599d:	6a 1d                	push   $0x1d
  jmp alltraps
8010599f:	e9 69 fa ff ff       	jmp    8010540d <alltraps>

801059a4 <vector30>:
.globl vector30
vector30:
  pushl $0
801059a4:	6a 00                	push   $0x0
  pushl $30
801059a6:	6a 1e                	push   $0x1e
  jmp alltraps
801059a8:	e9 60 fa ff ff       	jmp    8010540d <alltraps>

801059ad <vector31>:
.globl vector31
vector31:
  pushl $0
801059ad:	6a 00                	push   $0x0
  pushl $31
801059af:	6a 1f                	push   $0x1f
  jmp alltraps
801059b1:	e9 57 fa ff ff       	jmp    8010540d <alltraps>

801059b6 <vector32>:
.globl vector32
vector32:
  pushl $0
801059b6:	6a 00                	push   $0x0
  pushl $32
801059b8:	6a 20                	push   $0x20
  jmp alltraps
801059ba:	e9 4e fa ff ff       	jmp    8010540d <alltraps>

801059bf <vector33>:
.globl vector33
vector33:
  pushl $0
801059bf:	6a 00                	push   $0x0
  pushl $33
801059c1:	6a 21                	push   $0x21
  jmp alltraps
801059c3:	e9 45 fa ff ff       	jmp    8010540d <alltraps>

801059c8 <vector34>:
.globl vector34
vector34:
  pushl $0
801059c8:	6a 00                	push   $0x0
  pushl $34
801059ca:	6a 22                	push   $0x22
  jmp alltraps
801059cc:	e9 3c fa ff ff       	jmp    8010540d <alltraps>

801059d1 <vector35>:
.globl vector35
vector35:
  pushl $0
801059d1:	6a 00                	push   $0x0
  pushl $35
801059d3:	6a 23                	push   $0x23
  jmp alltraps
801059d5:	e9 33 fa ff ff       	jmp    8010540d <alltraps>

801059da <vector36>:
.globl vector36
vector36:
  pushl $0
801059da:	6a 00                	push   $0x0
  pushl $36
801059dc:	6a 24                	push   $0x24
  jmp alltraps
801059de:	e9 2a fa ff ff       	jmp    8010540d <alltraps>

801059e3 <vector37>:
.globl vector37
vector37:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $37
801059e5:	6a 25                	push   $0x25
  jmp alltraps
801059e7:	e9 21 fa ff ff       	jmp    8010540d <alltraps>

801059ec <vector38>:
.globl vector38
vector38:
  pushl $0
801059ec:	6a 00                	push   $0x0
  pushl $38
801059ee:	6a 26                	push   $0x26
  jmp alltraps
801059f0:	e9 18 fa ff ff       	jmp    8010540d <alltraps>

801059f5 <vector39>:
.globl vector39
vector39:
  pushl $0
801059f5:	6a 00                	push   $0x0
  pushl $39
801059f7:	6a 27                	push   $0x27
  jmp alltraps
801059f9:	e9 0f fa ff ff       	jmp    8010540d <alltraps>

801059fe <vector40>:
.globl vector40
vector40:
  pushl $0
801059fe:	6a 00                	push   $0x0
  pushl $40
80105a00:	6a 28                	push   $0x28
  jmp alltraps
80105a02:	e9 06 fa ff ff       	jmp    8010540d <alltraps>

80105a07 <vector41>:
.globl vector41
vector41:
  pushl $0
80105a07:	6a 00                	push   $0x0
  pushl $41
80105a09:	6a 29                	push   $0x29
  jmp alltraps
80105a0b:	e9 fd f9 ff ff       	jmp    8010540d <alltraps>

80105a10 <vector42>:
.globl vector42
vector42:
  pushl $0
80105a10:	6a 00                	push   $0x0
  pushl $42
80105a12:	6a 2a                	push   $0x2a
  jmp alltraps
80105a14:	e9 f4 f9 ff ff       	jmp    8010540d <alltraps>

80105a19 <vector43>:
.globl vector43
vector43:
  pushl $0
80105a19:	6a 00                	push   $0x0
  pushl $43
80105a1b:	6a 2b                	push   $0x2b
  jmp alltraps
80105a1d:	e9 eb f9 ff ff       	jmp    8010540d <alltraps>

80105a22 <vector44>:
.globl vector44
vector44:
  pushl $0
80105a22:	6a 00                	push   $0x0
  pushl $44
80105a24:	6a 2c                	push   $0x2c
  jmp alltraps
80105a26:	e9 e2 f9 ff ff       	jmp    8010540d <alltraps>

80105a2b <vector45>:
.globl vector45
vector45:
  pushl $0
80105a2b:	6a 00                	push   $0x0
  pushl $45
80105a2d:	6a 2d                	push   $0x2d
  jmp alltraps
80105a2f:	e9 d9 f9 ff ff       	jmp    8010540d <alltraps>

80105a34 <vector46>:
.globl vector46
vector46:
  pushl $0
80105a34:	6a 00                	push   $0x0
  pushl $46
80105a36:	6a 2e                	push   $0x2e
  jmp alltraps
80105a38:	e9 d0 f9 ff ff       	jmp    8010540d <alltraps>

80105a3d <vector47>:
.globl vector47
vector47:
  pushl $0
80105a3d:	6a 00                	push   $0x0
  pushl $47
80105a3f:	6a 2f                	push   $0x2f
  jmp alltraps
80105a41:	e9 c7 f9 ff ff       	jmp    8010540d <alltraps>

80105a46 <vector48>:
.globl vector48
vector48:
  pushl $0
80105a46:	6a 00                	push   $0x0
  pushl $48
80105a48:	6a 30                	push   $0x30
  jmp alltraps
80105a4a:	e9 be f9 ff ff       	jmp    8010540d <alltraps>

80105a4f <vector49>:
.globl vector49
vector49:
  pushl $0
80105a4f:	6a 00                	push   $0x0
  pushl $49
80105a51:	6a 31                	push   $0x31
  jmp alltraps
80105a53:	e9 b5 f9 ff ff       	jmp    8010540d <alltraps>

80105a58 <vector50>:
.globl vector50
vector50:
  pushl $0
80105a58:	6a 00                	push   $0x0
  pushl $50
80105a5a:	6a 32                	push   $0x32
  jmp alltraps
80105a5c:	e9 ac f9 ff ff       	jmp    8010540d <alltraps>

80105a61 <vector51>:
.globl vector51
vector51:
  pushl $0
80105a61:	6a 00                	push   $0x0
  pushl $51
80105a63:	6a 33                	push   $0x33
  jmp alltraps
80105a65:	e9 a3 f9 ff ff       	jmp    8010540d <alltraps>

80105a6a <vector52>:
.globl vector52
vector52:
  pushl $0
80105a6a:	6a 00                	push   $0x0
  pushl $52
80105a6c:	6a 34                	push   $0x34
  jmp alltraps
80105a6e:	e9 9a f9 ff ff       	jmp    8010540d <alltraps>

80105a73 <vector53>:
.globl vector53
vector53:
  pushl $0
80105a73:	6a 00                	push   $0x0
  pushl $53
80105a75:	6a 35                	push   $0x35
  jmp alltraps
80105a77:	e9 91 f9 ff ff       	jmp    8010540d <alltraps>

80105a7c <vector54>:
.globl vector54
vector54:
  pushl $0
80105a7c:	6a 00                	push   $0x0
  pushl $54
80105a7e:	6a 36                	push   $0x36
  jmp alltraps
80105a80:	e9 88 f9 ff ff       	jmp    8010540d <alltraps>

80105a85 <vector55>:
.globl vector55
vector55:
  pushl $0
80105a85:	6a 00                	push   $0x0
  pushl $55
80105a87:	6a 37                	push   $0x37
  jmp alltraps
80105a89:	e9 7f f9 ff ff       	jmp    8010540d <alltraps>

80105a8e <vector56>:
.globl vector56
vector56:
  pushl $0
80105a8e:	6a 00                	push   $0x0
  pushl $56
80105a90:	6a 38                	push   $0x38
  jmp alltraps
80105a92:	e9 76 f9 ff ff       	jmp    8010540d <alltraps>

80105a97 <vector57>:
.globl vector57
vector57:
  pushl $0
80105a97:	6a 00                	push   $0x0
  pushl $57
80105a99:	6a 39                	push   $0x39
  jmp alltraps
80105a9b:	e9 6d f9 ff ff       	jmp    8010540d <alltraps>

80105aa0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105aa0:	6a 00                	push   $0x0
  pushl $58
80105aa2:	6a 3a                	push   $0x3a
  jmp alltraps
80105aa4:	e9 64 f9 ff ff       	jmp    8010540d <alltraps>

80105aa9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105aa9:	6a 00                	push   $0x0
  pushl $59
80105aab:	6a 3b                	push   $0x3b
  jmp alltraps
80105aad:	e9 5b f9 ff ff       	jmp    8010540d <alltraps>

80105ab2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ab2:	6a 00                	push   $0x0
  pushl $60
80105ab4:	6a 3c                	push   $0x3c
  jmp alltraps
80105ab6:	e9 52 f9 ff ff       	jmp    8010540d <alltraps>

80105abb <vector61>:
.globl vector61
vector61:
  pushl $0
80105abb:	6a 00                	push   $0x0
  pushl $61
80105abd:	6a 3d                	push   $0x3d
  jmp alltraps
80105abf:	e9 49 f9 ff ff       	jmp    8010540d <alltraps>

80105ac4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ac4:	6a 00                	push   $0x0
  pushl $62
80105ac6:	6a 3e                	push   $0x3e
  jmp alltraps
80105ac8:	e9 40 f9 ff ff       	jmp    8010540d <alltraps>

80105acd <vector63>:
.globl vector63
vector63:
  pushl $0
80105acd:	6a 00                	push   $0x0
  pushl $63
80105acf:	6a 3f                	push   $0x3f
  jmp alltraps
80105ad1:	e9 37 f9 ff ff       	jmp    8010540d <alltraps>

80105ad6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ad6:	6a 00                	push   $0x0
  pushl $64
80105ad8:	6a 40                	push   $0x40
  jmp alltraps
80105ada:	e9 2e f9 ff ff       	jmp    8010540d <alltraps>

80105adf <vector65>:
.globl vector65
vector65:
  pushl $0
80105adf:	6a 00                	push   $0x0
  pushl $65
80105ae1:	6a 41                	push   $0x41
  jmp alltraps
80105ae3:	e9 25 f9 ff ff       	jmp    8010540d <alltraps>

80105ae8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ae8:	6a 00                	push   $0x0
  pushl $66
80105aea:	6a 42                	push   $0x42
  jmp alltraps
80105aec:	e9 1c f9 ff ff       	jmp    8010540d <alltraps>

80105af1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105af1:	6a 00                	push   $0x0
  pushl $67
80105af3:	6a 43                	push   $0x43
  jmp alltraps
80105af5:	e9 13 f9 ff ff       	jmp    8010540d <alltraps>

80105afa <vector68>:
.globl vector68
vector68:
  pushl $0
80105afa:	6a 00                	push   $0x0
  pushl $68
80105afc:	6a 44                	push   $0x44
  jmp alltraps
80105afe:	e9 0a f9 ff ff       	jmp    8010540d <alltraps>

80105b03 <vector69>:
.globl vector69
vector69:
  pushl $0
80105b03:	6a 00                	push   $0x0
  pushl $69
80105b05:	6a 45                	push   $0x45
  jmp alltraps
80105b07:	e9 01 f9 ff ff       	jmp    8010540d <alltraps>

80105b0c <vector70>:
.globl vector70
vector70:
  pushl $0
80105b0c:	6a 00                	push   $0x0
  pushl $70
80105b0e:	6a 46                	push   $0x46
  jmp alltraps
80105b10:	e9 f8 f8 ff ff       	jmp    8010540d <alltraps>

80105b15 <vector71>:
.globl vector71
vector71:
  pushl $0
80105b15:	6a 00                	push   $0x0
  pushl $71
80105b17:	6a 47                	push   $0x47
  jmp alltraps
80105b19:	e9 ef f8 ff ff       	jmp    8010540d <alltraps>

80105b1e <vector72>:
.globl vector72
vector72:
  pushl $0
80105b1e:	6a 00                	push   $0x0
  pushl $72
80105b20:	6a 48                	push   $0x48
  jmp alltraps
80105b22:	e9 e6 f8 ff ff       	jmp    8010540d <alltraps>

80105b27 <vector73>:
.globl vector73
vector73:
  pushl $0
80105b27:	6a 00                	push   $0x0
  pushl $73
80105b29:	6a 49                	push   $0x49
  jmp alltraps
80105b2b:	e9 dd f8 ff ff       	jmp    8010540d <alltraps>

80105b30 <vector74>:
.globl vector74
vector74:
  pushl $0
80105b30:	6a 00                	push   $0x0
  pushl $74
80105b32:	6a 4a                	push   $0x4a
  jmp alltraps
80105b34:	e9 d4 f8 ff ff       	jmp    8010540d <alltraps>

80105b39 <vector75>:
.globl vector75
vector75:
  pushl $0
80105b39:	6a 00                	push   $0x0
  pushl $75
80105b3b:	6a 4b                	push   $0x4b
  jmp alltraps
80105b3d:	e9 cb f8 ff ff       	jmp    8010540d <alltraps>

80105b42 <vector76>:
.globl vector76
vector76:
  pushl $0
80105b42:	6a 00                	push   $0x0
  pushl $76
80105b44:	6a 4c                	push   $0x4c
  jmp alltraps
80105b46:	e9 c2 f8 ff ff       	jmp    8010540d <alltraps>

80105b4b <vector77>:
.globl vector77
vector77:
  pushl $0
80105b4b:	6a 00                	push   $0x0
  pushl $77
80105b4d:	6a 4d                	push   $0x4d
  jmp alltraps
80105b4f:	e9 b9 f8 ff ff       	jmp    8010540d <alltraps>

80105b54 <vector78>:
.globl vector78
vector78:
  pushl $0
80105b54:	6a 00                	push   $0x0
  pushl $78
80105b56:	6a 4e                	push   $0x4e
  jmp alltraps
80105b58:	e9 b0 f8 ff ff       	jmp    8010540d <alltraps>

80105b5d <vector79>:
.globl vector79
vector79:
  pushl $0
80105b5d:	6a 00                	push   $0x0
  pushl $79
80105b5f:	6a 4f                	push   $0x4f
  jmp alltraps
80105b61:	e9 a7 f8 ff ff       	jmp    8010540d <alltraps>

80105b66 <vector80>:
.globl vector80
vector80:
  pushl $0
80105b66:	6a 00                	push   $0x0
  pushl $80
80105b68:	6a 50                	push   $0x50
  jmp alltraps
80105b6a:	e9 9e f8 ff ff       	jmp    8010540d <alltraps>

80105b6f <vector81>:
.globl vector81
vector81:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $81
80105b71:	6a 51                	push   $0x51
  jmp alltraps
80105b73:	e9 95 f8 ff ff       	jmp    8010540d <alltraps>

80105b78 <vector82>:
.globl vector82
vector82:
  pushl $0
80105b78:	6a 00                	push   $0x0
  pushl $82
80105b7a:	6a 52                	push   $0x52
  jmp alltraps
80105b7c:	e9 8c f8 ff ff       	jmp    8010540d <alltraps>

80105b81 <vector83>:
.globl vector83
vector83:
  pushl $0
80105b81:	6a 00                	push   $0x0
  pushl $83
80105b83:	6a 53                	push   $0x53
  jmp alltraps
80105b85:	e9 83 f8 ff ff       	jmp    8010540d <alltraps>

80105b8a <vector84>:
.globl vector84
vector84:
  pushl $0
80105b8a:	6a 00                	push   $0x0
  pushl $84
80105b8c:	6a 54                	push   $0x54
  jmp alltraps
80105b8e:	e9 7a f8 ff ff       	jmp    8010540d <alltraps>

80105b93 <vector85>:
.globl vector85
vector85:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $85
80105b95:	6a 55                	push   $0x55
  jmp alltraps
80105b97:	e9 71 f8 ff ff       	jmp    8010540d <alltraps>

80105b9c <vector86>:
.globl vector86
vector86:
  pushl $0
80105b9c:	6a 00                	push   $0x0
  pushl $86
80105b9e:	6a 56                	push   $0x56
  jmp alltraps
80105ba0:	e9 68 f8 ff ff       	jmp    8010540d <alltraps>

80105ba5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ba5:	6a 00                	push   $0x0
  pushl $87
80105ba7:	6a 57                	push   $0x57
  jmp alltraps
80105ba9:	e9 5f f8 ff ff       	jmp    8010540d <alltraps>

80105bae <vector88>:
.globl vector88
vector88:
  pushl $0
80105bae:	6a 00                	push   $0x0
  pushl $88
80105bb0:	6a 58                	push   $0x58
  jmp alltraps
80105bb2:	e9 56 f8 ff ff       	jmp    8010540d <alltraps>

80105bb7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $89
80105bb9:	6a 59                	push   $0x59
  jmp alltraps
80105bbb:	e9 4d f8 ff ff       	jmp    8010540d <alltraps>

80105bc0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105bc0:	6a 00                	push   $0x0
  pushl $90
80105bc2:	6a 5a                	push   $0x5a
  jmp alltraps
80105bc4:	e9 44 f8 ff ff       	jmp    8010540d <alltraps>

80105bc9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105bc9:	6a 00                	push   $0x0
  pushl $91
80105bcb:	6a 5b                	push   $0x5b
  jmp alltraps
80105bcd:	e9 3b f8 ff ff       	jmp    8010540d <alltraps>

80105bd2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105bd2:	6a 00                	push   $0x0
  pushl $92
80105bd4:	6a 5c                	push   $0x5c
  jmp alltraps
80105bd6:	e9 32 f8 ff ff       	jmp    8010540d <alltraps>

80105bdb <vector93>:
.globl vector93
vector93:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $93
80105bdd:	6a 5d                	push   $0x5d
  jmp alltraps
80105bdf:	e9 29 f8 ff ff       	jmp    8010540d <alltraps>

80105be4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105be4:	6a 00                	push   $0x0
  pushl $94
80105be6:	6a 5e                	push   $0x5e
  jmp alltraps
80105be8:	e9 20 f8 ff ff       	jmp    8010540d <alltraps>

80105bed <vector95>:
.globl vector95
vector95:
  pushl $0
80105bed:	6a 00                	push   $0x0
  pushl $95
80105bef:	6a 5f                	push   $0x5f
  jmp alltraps
80105bf1:	e9 17 f8 ff ff       	jmp    8010540d <alltraps>

80105bf6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105bf6:	6a 00                	push   $0x0
  pushl $96
80105bf8:	6a 60                	push   $0x60
  jmp alltraps
80105bfa:	e9 0e f8 ff ff       	jmp    8010540d <alltraps>

80105bff <vector97>:
.globl vector97
vector97:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $97
80105c01:	6a 61                	push   $0x61
  jmp alltraps
80105c03:	e9 05 f8 ff ff       	jmp    8010540d <alltraps>

80105c08 <vector98>:
.globl vector98
vector98:
  pushl $0
80105c08:	6a 00                	push   $0x0
  pushl $98
80105c0a:	6a 62                	push   $0x62
  jmp alltraps
80105c0c:	e9 fc f7 ff ff       	jmp    8010540d <alltraps>

80105c11 <vector99>:
.globl vector99
vector99:
  pushl $0
80105c11:	6a 00                	push   $0x0
  pushl $99
80105c13:	6a 63                	push   $0x63
  jmp alltraps
80105c15:	e9 f3 f7 ff ff       	jmp    8010540d <alltraps>

80105c1a <vector100>:
.globl vector100
vector100:
  pushl $0
80105c1a:	6a 00                	push   $0x0
  pushl $100
80105c1c:	6a 64                	push   $0x64
  jmp alltraps
80105c1e:	e9 ea f7 ff ff       	jmp    8010540d <alltraps>

80105c23 <vector101>:
.globl vector101
vector101:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $101
80105c25:	6a 65                	push   $0x65
  jmp alltraps
80105c27:	e9 e1 f7 ff ff       	jmp    8010540d <alltraps>

80105c2c <vector102>:
.globl vector102
vector102:
  pushl $0
80105c2c:	6a 00                	push   $0x0
  pushl $102
80105c2e:	6a 66                	push   $0x66
  jmp alltraps
80105c30:	e9 d8 f7 ff ff       	jmp    8010540d <alltraps>

80105c35 <vector103>:
.globl vector103
vector103:
  pushl $0
80105c35:	6a 00                	push   $0x0
  pushl $103
80105c37:	6a 67                	push   $0x67
  jmp alltraps
80105c39:	e9 cf f7 ff ff       	jmp    8010540d <alltraps>

80105c3e <vector104>:
.globl vector104
vector104:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $104
80105c40:	6a 68                	push   $0x68
  jmp alltraps
80105c42:	e9 c6 f7 ff ff       	jmp    8010540d <alltraps>

80105c47 <vector105>:
.globl vector105
vector105:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $105
80105c49:	6a 69                	push   $0x69
  jmp alltraps
80105c4b:	e9 bd f7 ff ff       	jmp    8010540d <alltraps>

80105c50 <vector106>:
.globl vector106
vector106:
  pushl $0
80105c50:	6a 00                	push   $0x0
  pushl $106
80105c52:	6a 6a                	push   $0x6a
  jmp alltraps
80105c54:	e9 b4 f7 ff ff       	jmp    8010540d <alltraps>

80105c59 <vector107>:
.globl vector107
vector107:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $107
80105c5b:	6a 6b                	push   $0x6b
  jmp alltraps
80105c5d:	e9 ab f7 ff ff       	jmp    8010540d <alltraps>

80105c62 <vector108>:
.globl vector108
vector108:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $108
80105c64:	6a 6c                	push   $0x6c
  jmp alltraps
80105c66:	e9 a2 f7 ff ff       	jmp    8010540d <alltraps>

80105c6b <vector109>:
.globl vector109
vector109:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $109
80105c6d:	6a 6d                	push   $0x6d
  jmp alltraps
80105c6f:	e9 99 f7 ff ff       	jmp    8010540d <alltraps>

80105c74 <vector110>:
.globl vector110
vector110:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $110
80105c76:	6a 6e                	push   $0x6e
  jmp alltraps
80105c78:	e9 90 f7 ff ff       	jmp    8010540d <alltraps>

80105c7d <vector111>:
.globl vector111
vector111:
  pushl $0
80105c7d:	6a 00                	push   $0x0
  pushl $111
80105c7f:	6a 6f                	push   $0x6f
  jmp alltraps
80105c81:	e9 87 f7 ff ff       	jmp    8010540d <alltraps>

80105c86 <vector112>:
.globl vector112
vector112:
  pushl $0
80105c86:	6a 00                	push   $0x0
  pushl $112
80105c88:	6a 70                	push   $0x70
  jmp alltraps
80105c8a:	e9 7e f7 ff ff       	jmp    8010540d <alltraps>

80105c8f <vector113>:
.globl vector113
vector113:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $113
80105c91:	6a 71                	push   $0x71
  jmp alltraps
80105c93:	e9 75 f7 ff ff       	jmp    8010540d <alltraps>

80105c98 <vector114>:
.globl vector114
vector114:
  pushl $0
80105c98:	6a 00                	push   $0x0
  pushl $114
80105c9a:	6a 72                	push   $0x72
  jmp alltraps
80105c9c:	e9 6c f7 ff ff       	jmp    8010540d <alltraps>

80105ca1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105ca1:	6a 00                	push   $0x0
  pushl $115
80105ca3:	6a 73                	push   $0x73
  jmp alltraps
80105ca5:	e9 63 f7 ff ff       	jmp    8010540d <alltraps>

80105caa <vector116>:
.globl vector116
vector116:
  pushl $0
80105caa:	6a 00                	push   $0x0
  pushl $116
80105cac:	6a 74                	push   $0x74
  jmp alltraps
80105cae:	e9 5a f7 ff ff       	jmp    8010540d <alltraps>

80105cb3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $117
80105cb5:	6a 75                	push   $0x75
  jmp alltraps
80105cb7:	e9 51 f7 ff ff       	jmp    8010540d <alltraps>

80105cbc <vector118>:
.globl vector118
vector118:
  pushl $0
80105cbc:	6a 00                	push   $0x0
  pushl $118
80105cbe:	6a 76                	push   $0x76
  jmp alltraps
80105cc0:	e9 48 f7 ff ff       	jmp    8010540d <alltraps>

80105cc5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105cc5:	6a 00                	push   $0x0
  pushl $119
80105cc7:	6a 77                	push   $0x77
  jmp alltraps
80105cc9:	e9 3f f7 ff ff       	jmp    8010540d <alltraps>

80105cce <vector120>:
.globl vector120
vector120:
  pushl $0
80105cce:	6a 00                	push   $0x0
  pushl $120
80105cd0:	6a 78                	push   $0x78
  jmp alltraps
80105cd2:	e9 36 f7 ff ff       	jmp    8010540d <alltraps>

80105cd7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $121
80105cd9:	6a 79                	push   $0x79
  jmp alltraps
80105cdb:	e9 2d f7 ff ff       	jmp    8010540d <alltraps>

80105ce0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $122
80105ce2:	6a 7a                	push   $0x7a
  jmp alltraps
80105ce4:	e9 24 f7 ff ff       	jmp    8010540d <alltraps>

80105ce9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $123
80105ceb:	6a 7b                	push   $0x7b
  jmp alltraps
80105ced:	e9 1b f7 ff ff       	jmp    8010540d <alltraps>

80105cf2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105cf2:	6a 00                	push   $0x0
  pushl $124
80105cf4:	6a 7c                	push   $0x7c
  jmp alltraps
80105cf6:	e9 12 f7 ff ff       	jmp    8010540d <alltraps>

80105cfb <vector125>:
.globl vector125
vector125:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $125
80105cfd:	6a 7d                	push   $0x7d
  jmp alltraps
80105cff:	e9 09 f7 ff ff       	jmp    8010540d <alltraps>

80105d04 <vector126>:
.globl vector126
vector126:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $126
80105d06:	6a 7e                	push   $0x7e
  jmp alltraps
80105d08:	e9 00 f7 ff ff       	jmp    8010540d <alltraps>

80105d0d <vector127>:
.globl vector127
vector127:
  pushl $0
80105d0d:	6a 00                	push   $0x0
  pushl $127
80105d0f:	6a 7f                	push   $0x7f
  jmp alltraps
80105d11:	e9 f7 f6 ff ff       	jmp    8010540d <alltraps>

80105d16 <vector128>:
.globl vector128
vector128:
  pushl $0
80105d16:	6a 00                	push   $0x0
  pushl $128
80105d18:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105d1d:	e9 eb f6 ff ff       	jmp    8010540d <alltraps>

80105d22 <vector129>:
.globl vector129
vector129:
  pushl $0
80105d22:	6a 00                	push   $0x0
  pushl $129
80105d24:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105d29:	e9 df f6 ff ff       	jmp    8010540d <alltraps>

80105d2e <vector130>:
.globl vector130
vector130:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $130
80105d30:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105d35:	e9 d3 f6 ff ff       	jmp    8010540d <alltraps>

80105d3a <vector131>:
.globl vector131
vector131:
  pushl $0
80105d3a:	6a 00                	push   $0x0
  pushl $131
80105d3c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105d41:	e9 c7 f6 ff ff       	jmp    8010540d <alltraps>

80105d46 <vector132>:
.globl vector132
vector132:
  pushl $0
80105d46:	6a 00                	push   $0x0
  pushl $132
80105d48:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105d4d:	e9 bb f6 ff ff       	jmp    8010540d <alltraps>

80105d52 <vector133>:
.globl vector133
vector133:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $133
80105d54:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105d59:	e9 af f6 ff ff       	jmp    8010540d <alltraps>

80105d5e <vector134>:
.globl vector134
vector134:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $134
80105d60:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105d65:	e9 a3 f6 ff ff       	jmp    8010540d <alltraps>

80105d6a <vector135>:
.globl vector135
vector135:
  pushl $0
80105d6a:	6a 00                	push   $0x0
  pushl $135
80105d6c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105d71:	e9 97 f6 ff ff       	jmp    8010540d <alltraps>

80105d76 <vector136>:
.globl vector136
vector136:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $136
80105d78:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105d7d:	e9 8b f6 ff ff       	jmp    8010540d <alltraps>

80105d82 <vector137>:
.globl vector137
vector137:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $137
80105d84:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105d89:	e9 7f f6 ff ff       	jmp    8010540d <alltraps>

80105d8e <vector138>:
.globl vector138
vector138:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $138
80105d90:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105d95:	e9 73 f6 ff ff       	jmp    8010540d <alltraps>

80105d9a <vector139>:
.globl vector139
vector139:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $139
80105d9c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105da1:	e9 67 f6 ff ff       	jmp    8010540d <alltraps>

80105da6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $140
80105da8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105dad:	e9 5b f6 ff ff       	jmp    8010540d <alltraps>

80105db2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $141
80105db4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105db9:	e9 4f f6 ff ff       	jmp    8010540d <alltraps>

80105dbe <vector142>:
.globl vector142
vector142:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $142
80105dc0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105dc5:	e9 43 f6 ff ff       	jmp    8010540d <alltraps>

80105dca <vector143>:
.globl vector143
vector143:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $143
80105dcc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105dd1:	e9 37 f6 ff ff       	jmp    8010540d <alltraps>

80105dd6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $144
80105dd8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105ddd:	e9 2b f6 ff ff       	jmp    8010540d <alltraps>

80105de2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $145
80105de4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105de9:	e9 1f f6 ff ff       	jmp    8010540d <alltraps>

80105dee <vector146>:
.globl vector146
vector146:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $146
80105df0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105df5:	e9 13 f6 ff ff       	jmp    8010540d <alltraps>

80105dfa <vector147>:
.globl vector147
vector147:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $147
80105dfc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105e01:	e9 07 f6 ff ff       	jmp    8010540d <alltraps>

80105e06 <vector148>:
.globl vector148
vector148:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $148
80105e08:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105e0d:	e9 fb f5 ff ff       	jmp    8010540d <alltraps>

80105e12 <vector149>:
.globl vector149
vector149:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $149
80105e14:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105e19:	e9 ef f5 ff ff       	jmp    8010540d <alltraps>

80105e1e <vector150>:
.globl vector150
vector150:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $150
80105e20:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105e25:	e9 e3 f5 ff ff       	jmp    8010540d <alltraps>

80105e2a <vector151>:
.globl vector151
vector151:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $151
80105e2c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105e31:	e9 d7 f5 ff ff       	jmp    8010540d <alltraps>

80105e36 <vector152>:
.globl vector152
vector152:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $152
80105e38:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105e3d:	e9 cb f5 ff ff       	jmp    8010540d <alltraps>

80105e42 <vector153>:
.globl vector153
vector153:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $153
80105e44:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105e49:	e9 bf f5 ff ff       	jmp    8010540d <alltraps>

80105e4e <vector154>:
.globl vector154
vector154:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $154
80105e50:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105e55:	e9 b3 f5 ff ff       	jmp    8010540d <alltraps>

80105e5a <vector155>:
.globl vector155
vector155:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $155
80105e5c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105e61:	e9 a7 f5 ff ff       	jmp    8010540d <alltraps>

80105e66 <vector156>:
.globl vector156
vector156:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $156
80105e68:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105e6d:	e9 9b f5 ff ff       	jmp    8010540d <alltraps>

80105e72 <vector157>:
.globl vector157
vector157:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $157
80105e74:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105e79:	e9 8f f5 ff ff       	jmp    8010540d <alltraps>

80105e7e <vector158>:
.globl vector158
vector158:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $158
80105e80:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105e85:	e9 83 f5 ff ff       	jmp    8010540d <alltraps>

80105e8a <vector159>:
.globl vector159
vector159:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $159
80105e8c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105e91:	e9 77 f5 ff ff       	jmp    8010540d <alltraps>

80105e96 <vector160>:
.globl vector160
vector160:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $160
80105e98:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105e9d:	e9 6b f5 ff ff       	jmp    8010540d <alltraps>

80105ea2 <vector161>:
.globl vector161
vector161:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $161
80105ea4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105ea9:	e9 5f f5 ff ff       	jmp    8010540d <alltraps>

80105eae <vector162>:
.globl vector162
vector162:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $162
80105eb0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105eb5:	e9 53 f5 ff ff       	jmp    8010540d <alltraps>

80105eba <vector163>:
.globl vector163
vector163:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $163
80105ebc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105ec1:	e9 47 f5 ff ff       	jmp    8010540d <alltraps>

80105ec6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $164
80105ec8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105ecd:	e9 3b f5 ff ff       	jmp    8010540d <alltraps>

80105ed2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $165
80105ed4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105ed9:	e9 2f f5 ff ff       	jmp    8010540d <alltraps>

80105ede <vector166>:
.globl vector166
vector166:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $166
80105ee0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105ee5:	e9 23 f5 ff ff       	jmp    8010540d <alltraps>

80105eea <vector167>:
.globl vector167
vector167:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $167
80105eec:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105ef1:	e9 17 f5 ff ff       	jmp    8010540d <alltraps>

80105ef6 <vector168>:
.globl vector168
vector168:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $168
80105ef8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105efd:	e9 0b f5 ff ff       	jmp    8010540d <alltraps>

80105f02 <vector169>:
.globl vector169
vector169:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $169
80105f04:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105f09:	e9 ff f4 ff ff       	jmp    8010540d <alltraps>

80105f0e <vector170>:
.globl vector170
vector170:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $170
80105f10:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105f15:	e9 f3 f4 ff ff       	jmp    8010540d <alltraps>

80105f1a <vector171>:
.globl vector171
vector171:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $171
80105f1c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105f21:	e9 e7 f4 ff ff       	jmp    8010540d <alltraps>

80105f26 <vector172>:
.globl vector172
vector172:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $172
80105f28:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105f2d:	e9 db f4 ff ff       	jmp    8010540d <alltraps>

80105f32 <vector173>:
.globl vector173
vector173:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $173
80105f34:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105f39:	e9 cf f4 ff ff       	jmp    8010540d <alltraps>

80105f3e <vector174>:
.globl vector174
vector174:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $174
80105f40:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105f45:	e9 c3 f4 ff ff       	jmp    8010540d <alltraps>

80105f4a <vector175>:
.globl vector175
vector175:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $175
80105f4c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105f51:	e9 b7 f4 ff ff       	jmp    8010540d <alltraps>

80105f56 <vector176>:
.globl vector176
vector176:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $176
80105f58:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105f5d:	e9 ab f4 ff ff       	jmp    8010540d <alltraps>

80105f62 <vector177>:
.globl vector177
vector177:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $177
80105f64:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105f69:	e9 9f f4 ff ff       	jmp    8010540d <alltraps>

80105f6e <vector178>:
.globl vector178
vector178:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $178
80105f70:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105f75:	e9 93 f4 ff ff       	jmp    8010540d <alltraps>

80105f7a <vector179>:
.globl vector179
vector179:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $179
80105f7c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105f81:	e9 87 f4 ff ff       	jmp    8010540d <alltraps>

80105f86 <vector180>:
.globl vector180
vector180:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $180
80105f88:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105f8d:	e9 7b f4 ff ff       	jmp    8010540d <alltraps>

80105f92 <vector181>:
.globl vector181
vector181:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $181
80105f94:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105f99:	e9 6f f4 ff ff       	jmp    8010540d <alltraps>

80105f9e <vector182>:
.globl vector182
vector182:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $182
80105fa0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105fa5:	e9 63 f4 ff ff       	jmp    8010540d <alltraps>

80105faa <vector183>:
.globl vector183
vector183:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $183
80105fac:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105fb1:	e9 57 f4 ff ff       	jmp    8010540d <alltraps>

80105fb6 <vector184>:
.globl vector184
vector184:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $184
80105fb8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105fbd:	e9 4b f4 ff ff       	jmp    8010540d <alltraps>

80105fc2 <vector185>:
.globl vector185
vector185:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $185
80105fc4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105fc9:	e9 3f f4 ff ff       	jmp    8010540d <alltraps>

80105fce <vector186>:
.globl vector186
vector186:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $186
80105fd0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105fd5:	e9 33 f4 ff ff       	jmp    8010540d <alltraps>

80105fda <vector187>:
.globl vector187
vector187:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $187
80105fdc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105fe1:	e9 27 f4 ff ff       	jmp    8010540d <alltraps>

80105fe6 <vector188>:
.globl vector188
vector188:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $188
80105fe8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105fed:	e9 1b f4 ff ff       	jmp    8010540d <alltraps>

80105ff2 <vector189>:
.globl vector189
vector189:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $189
80105ff4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105ff9:	e9 0f f4 ff ff       	jmp    8010540d <alltraps>

80105ffe <vector190>:
.globl vector190
vector190:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $190
80106000:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106005:	e9 03 f4 ff ff       	jmp    8010540d <alltraps>

8010600a <vector191>:
.globl vector191
vector191:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $191
8010600c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106011:	e9 f7 f3 ff ff       	jmp    8010540d <alltraps>

80106016 <vector192>:
.globl vector192
vector192:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $192
80106018:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010601d:	e9 eb f3 ff ff       	jmp    8010540d <alltraps>

80106022 <vector193>:
.globl vector193
vector193:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $193
80106024:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106029:	e9 df f3 ff ff       	jmp    8010540d <alltraps>

8010602e <vector194>:
.globl vector194
vector194:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $194
80106030:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106035:	e9 d3 f3 ff ff       	jmp    8010540d <alltraps>

8010603a <vector195>:
.globl vector195
vector195:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $195
8010603c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106041:	e9 c7 f3 ff ff       	jmp    8010540d <alltraps>

80106046 <vector196>:
.globl vector196
vector196:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $196
80106048:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010604d:	e9 bb f3 ff ff       	jmp    8010540d <alltraps>

80106052 <vector197>:
.globl vector197
vector197:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $197
80106054:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106059:	e9 af f3 ff ff       	jmp    8010540d <alltraps>

8010605e <vector198>:
.globl vector198
vector198:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $198
80106060:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106065:	e9 a3 f3 ff ff       	jmp    8010540d <alltraps>

8010606a <vector199>:
.globl vector199
vector199:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $199
8010606c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106071:	e9 97 f3 ff ff       	jmp    8010540d <alltraps>

80106076 <vector200>:
.globl vector200
vector200:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $200
80106078:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010607d:	e9 8b f3 ff ff       	jmp    8010540d <alltraps>

80106082 <vector201>:
.globl vector201
vector201:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $201
80106084:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106089:	e9 7f f3 ff ff       	jmp    8010540d <alltraps>

8010608e <vector202>:
.globl vector202
vector202:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $202
80106090:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106095:	e9 73 f3 ff ff       	jmp    8010540d <alltraps>

8010609a <vector203>:
.globl vector203
vector203:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $203
8010609c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801060a1:	e9 67 f3 ff ff       	jmp    8010540d <alltraps>

801060a6 <vector204>:
.globl vector204
vector204:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $204
801060a8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801060ad:	e9 5b f3 ff ff       	jmp    8010540d <alltraps>

801060b2 <vector205>:
.globl vector205
vector205:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $205
801060b4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801060b9:	e9 4f f3 ff ff       	jmp    8010540d <alltraps>

801060be <vector206>:
.globl vector206
vector206:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $206
801060c0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801060c5:	e9 43 f3 ff ff       	jmp    8010540d <alltraps>

801060ca <vector207>:
.globl vector207
vector207:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $207
801060cc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801060d1:	e9 37 f3 ff ff       	jmp    8010540d <alltraps>

801060d6 <vector208>:
.globl vector208
vector208:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $208
801060d8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801060dd:	e9 2b f3 ff ff       	jmp    8010540d <alltraps>

801060e2 <vector209>:
.globl vector209
vector209:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $209
801060e4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801060e9:	e9 1f f3 ff ff       	jmp    8010540d <alltraps>

801060ee <vector210>:
.globl vector210
vector210:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $210
801060f0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801060f5:	e9 13 f3 ff ff       	jmp    8010540d <alltraps>

801060fa <vector211>:
.globl vector211
vector211:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $211
801060fc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106101:	e9 07 f3 ff ff       	jmp    8010540d <alltraps>

80106106 <vector212>:
.globl vector212
vector212:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $212
80106108:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010610d:	e9 fb f2 ff ff       	jmp    8010540d <alltraps>

80106112 <vector213>:
.globl vector213
vector213:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $213
80106114:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106119:	e9 ef f2 ff ff       	jmp    8010540d <alltraps>

8010611e <vector214>:
.globl vector214
vector214:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $214
80106120:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106125:	e9 e3 f2 ff ff       	jmp    8010540d <alltraps>

8010612a <vector215>:
.globl vector215
vector215:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $215
8010612c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106131:	e9 d7 f2 ff ff       	jmp    8010540d <alltraps>

80106136 <vector216>:
.globl vector216
vector216:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $216
80106138:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010613d:	e9 cb f2 ff ff       	jmp    8010540d <alltraps>

80106142 <vector217>:
.globl vector217
vector217:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $217
80106144:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106149:	e9 bf f2 ff ff       	jmp    8010540d <alltraps>

8010614e <vector218>:
.globl vector218
vector218:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $218
80106150:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106155:	e9 b3 f2 ff ff       	jmp    8010540d <alltraps>

8010615a <vector219>:
.globl vector219
vector219:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $219
8010615c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106161:	e9 a7 f2 ff ff       	jmp    8010540d <alltraps>

80106166 <vector220>:
.globl vector220
vector220:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $220
80106168:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010616d:	e9 9b f2 ff ff       	jmp    8010540d <alltraps>

80106172 <vector221>:
.globl vector221
vector221:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $221
80106174:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106179:	e9 8f f2 ff ff       	jmp    8010540d <alltraps>

8010617e <vector222>:
.globl vector222
vector222:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $222
80106180:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106185:	e9 83 f2 ff ff       	jmp    8010540d <alltraps>

8010618a <vector223>:
.globl vector223
vector223:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $223
8010618c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106191:	e9 77 f2 ff ff       	jmp    8010540d <alltraps>

80106196 <vector224>:
.globl vector224
vector224:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $224
80106198:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010619d:	e9 6b f2 ff ff       	jmp    8010540d <alltraps>

801061a2 <vector225>:
.globl vector225
vector225:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $225
801061a4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801061a9:	e9 5f f2 ff ff       	jmp    8010540d <alltraps>

801061ae <vector226>:
.globl vector226
vector226:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $226
801061b0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801061b5:	e9 53 f2 ff ff       	jmp    8010540d <alltraps>

801061ba <vector227>:
.globl vector227
vector227:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $227
801061bc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801061c1:	e9 47 f2 ff ff       	jmp    8010540d <alltraps>

801061c6 <vector228>:
.globl vector228
vector228:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $228
801061c8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801061cd:	e9 3b f2 ff ff       	jmp    8010540d <alltraps>

801061d2 <vector229>:
.globl vector229
vector229:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $229
801061d4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801061d9:	e9 2f f2 ff ff       	jmp    8010540d <alltraps>

801061de <vector230>:
.globl vector230
vector230:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $230
801061e0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801061e5:	e9 23 f2 ff ff       	jmp    8010540d <alltraps>

801061ea <vector231>:
.globl vector231
vector231:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $231
801061ec:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801061f1:	e9 17 f2 ff ff       	jmp    8010540d <alltraps>

801061f6 <vector232>:
.globl vector232
vector232:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $232
801061f8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801061fd:	e9 0b f2 ff ff       	jmp    8010540d <alltraps>

80106202 <vector233>:
.globl vector233
vector233:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $233
80106204:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106209:	e9 ff f1 ff ff       	jmp    8010540d <alltraps>

8010620e <vector234>:
.globl vector234
vector234:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $234
80106210:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106215:	e9 f3 f1 ff ff       	jmp    8010540d <alltraps>

8010621a <vector235>:
.globl vector235
vector235:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $235
8010621c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106221:	e9 e7 f1 ff ff       	jmp    8010540d <alltraps>

80106226 <vector236>:
.globl vector236
vector236:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $236
80106228:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010622d:	e9 db f1 ff ff       	jmp    8010540d <alltraps>

80106232 <vector237>:
.globl vector237
vector237:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $237
80106234:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106239:	e9 cf f1 ff ff       	jmp    8010540d <alltraps>

8010623e <vector238>:
.globl vector238
vector238:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $238
80106240:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106245:	e9 c3 f1 ff ff       	jmp    8010540d <alltraps>

8010624a <vector239>:
.globl vector239
vector239:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $239
8010624c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106251:	e9 b7 f1 ff ff       	jmp    8010540d <alltraps>

80106256 <vector240>:
.globl vector240
vector240:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $240
80106258:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010625d:	e9 ab f1 ff ff       	jmp    8010540d <alltraps>

80106262 <vector241>:
.globl vector241
vector241:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $241
80106264:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106269:	e9 9f f1 ff ff       	jmp    8010540d <alltraps>

8010626e <vector242>:
.globl vector242
vector242:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $242
80106270:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106275:	e9 93 f1 ff ff       	jmp    8010540d <alltraps>

8010627a <vector243>:
.globl vector243
vector243:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $243
8010627c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106281:	e9 87 f1 ff ff       	jmp    8010540d <alltraps>

80106286 <vector244>:
.globl vector244
vector244:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $244
80106288:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010628d:	e9 7b f1 ff ff       	jmp    8010540d <alltraps>

80106292 <vector245>:
.globl vector245
vector245:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $245
80106294:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106299:	e9 6f f1 ff ff       	jmp    8010540d <alltraps>

8010629e <vector246>:
.globl vector246
vector246:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $246
801062a0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801062a5:	e9 63 f1 ff ff       	jmp    8010540d <alltraps>

801062aa <vector247>:
.globl vector247
vector247:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $247
801062ac:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801062b1:	e9 57 f1 ff ff       	jmp    8010540d <alltraps>

801062b6 <vector248>:
.globl vector248
vector248:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $248
801062b8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801062bd:	e9 4b f1 ff ff       	jmp    8010540d <alltraps>

801062c2 <vector249>:
.globl vector249
vector249:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $249
801062c4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801062c9:	e9 3f f1 ff ff       	jmp    8010540d <alltraps>

801062ce <vector250>:
.globl vector250
vector250:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $250
801062d0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801062d5:	e9 33 f1 ff ff       	jmp    8010540d <alltraps>

801062da <vector251>:
.globl vector251
vector251:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $251
801062dc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801062e1:	e9 27 f1 ff ff       	jmp    8010540d <alltraps>

801062e6 <vector252>:
.globl vector252
vector252:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $252
801062e8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801062ed:	e9 1b f1 ff ff       	jmp    8010540d <alltraps>

801062f2 <vector253>:
.globl vector253
vector253:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $253
801062f4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801062f9:	e9 0f f1 ff ff       	jmp    8010540d <alltraps>

801062fe <vector254>:
.globl vector254
vector254:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $254
80106300:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106305:	e9 03 f1 ff ff       	jmp    8010540d <alltraps>

8010630a <vector255>:
.globl vector255
vector255:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $255
8010630c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106311:	e9 f7 f0 ff ff       	jmp    8010540d <alltraps>
80106316:	66 90                	xchg   %ax,%ax
80106318:	66 90                	xchg   %ax,%ax
8010631a:	66 90                	xchg   %ax,%ax
8010631c:	66 90                	xchg   %ax,%ax
8010631e:	66 90                	xchg   %ax,%ax

80106320 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	57                   	push   %edi
80106324:	56                   	push   %esi
80106325:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106327:	c1 ea 16             	shr    $0x16,%edx
{
8010632a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010632b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010632e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106331:	8b 1f                	mov    (%edi),%ebx
80106333:	f6 c3 01             	test   $0x1,%bl
80106336:	74 28                	je     80106360 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106338:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010633e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106344:	c1 ee 0a             	shr    $0xa,%esi
}
80106347:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010634a:	89 f2                	mov    %esi,%edx
8010634c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106352:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106355:	5b                   	pop    %ebx
80106356:	5e                   	pop    %esi
80106357:	5f                   	pop    %edi
80106358:	5d                   	pop    %ebp
80106359:	c3                   	ret    
8010635a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106360:	85 c9                	test   %ecx,%ecx
80106362:	74 34                	je     80106398 <walkpgdir+0x78>
80106364:	e8 27 c1 ff ff       	call   80102490 <kalloc>
80106369:	85 c0                	test   %eax,%eax
8010636b:	89 c3                	mov    %eax,%ebx
8010636d:	74 29                	je     80106398 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
8010636f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106376:	00 
80106377:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010637e:	00 
8010637f:	89 04 24             	mov    %eax,(%esp)
80106382:	e8 e9 de ff ff       	call   80104270 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106387:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010638d:	83 c8 07             	or     $0x7,%eax
80106390:	89 07                	mov    %eax,(%edi)
80106392:	eb b0                	jmp    80106344 <walkpgdir+0x24>
80106394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80106398:	83 c4 1c             	add    $0x1c,%esp
      return 0;
8010639b:	31 c0                	xor    %eax,%eax
}
8010639d:	5b                   	pop    %ebx
8010639e:	5e                   	pop    %esi
8010639f:	5f                   	pop    %edi
801063a0:	5d                   	pop    %ebp
801063a1:	c3                   	ret    
801063a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	57                   	push   %edi
801063b4:	89 c7                	mov    %eax,%edi
801063b6:	56                   	push   %esi
801063b7:	89 d6                	mov    %edx,%esi
801063b9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801063ba:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801063c0:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
801063c3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801063c9:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801063cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801063ce:	72 3b                	jb     8010640b <deallocuvm.part.0+0x5b>
801063d0:	eb 5e                	jmp    80106430 <deallocuvm.part.0+0x80>
801063d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801063d8:	8b 10                	mov    (%eax),%edx
801063da:	f6 c2 01             	test   $0x1,%dl
801063dd:	74 22                	je     80106401 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801063df:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801063e5:	74 54                	je     8010643b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801063e7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801063ed:	89 14 24             	mov    %edx,(%esp)
801063f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063f3:	e8 e8 be ff ff       	call   801022e0 <kfree>
      *pte = 0;
801063f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106401:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106407:	39 f3                	cmp    %esi,%ebx
80106409:	73 25                	jae    80106430 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010640b:	31 c9                	xor    %ecx,%ecx
8010640d:	89 da                	mov    %ebx,%edx
8010640f:	89 f8                	mov    %edi,%eax
80106411:	e8 0a ff ff ff       	call   80106320 <walkpgdir>
    if(!pte)
80106416:	85 c0                	test   %eax,%eax
80106418:	75 be                	jne    801063d8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010641a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106420:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010642c:	39 f3                	cmp    %esi,%ebx
8010642e:	72 db                	jb     8010640b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106430:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106433:	83 c4 1c             	add    $0x1c,%esp
80106436:	5b                   	pop    %ebx
80106437:	5e                   	pop    %esi
80106438:	5f                   	pop    %edi
80106439:	5d                   	pop    %ebp
8010643a:	c3                   	ret    
        panic("kfree");
8010643b:	c7 04 24 26 70 10 80 	movl   $0x80107026,(%esp)
80106442:	e8 19 9f ff ff       	call   80100360 <panic>
80106447:	89 f6                	mov    %esi,%esi
80106449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106450 <seginit>:
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106456:	e8 15 d2 ff ff       	call   80103670 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010645b:	31 c9                	xor    %ecx,%ecx
8010645d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
80106462:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106468:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010646d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106471:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
80106476:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106479:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010647d:	31 c9                	xor    %ecx,%ecx
8010647f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106483:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106488:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010648c:	31 c9                	xor    %ecx,%ecx
8010648e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106492:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106497:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010649b:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010649d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
801064a1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064a5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
801064a9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064ad:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
801064b1:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064b5:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
801064b9:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
801064bd:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
801064c1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064c6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
801064ca:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064ce:	c6 40 14 00          	movb   $0x0,0x14(%eax)
801064d2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064d6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
801064da:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064de:	66 89 48 22          	mov    %cx,0x22(%eax)
801064e2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801064e6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801064ea:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801064ee:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801064f2:	c1 e8 10             	shr    $0x10,%eax
801064f5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801064f9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801064fc:	0f 01 10             	lgdtl  (%eax)
}
801064ff:	c9                   	leave  
80106500:	c3                   	ret    
80106501:	eb 0d                	jmp    80106510 <mappages>
80106503:	90                   	nop
80106504:	90                   	nop
80106505:	90                   	nop
80106506:	90                   	nop
80106507:	90                   	nop
80106508:	90                   	nop
80106509:	90                   	nop
8010650a:	90                   	nop
8010650b:	90                   	nop
8010650c:	90                   	nop
8010650d:	90                   	nop
8010650e:	90                   	nop
8010650f:	90                   	nop

80106510 <mappages>:
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	57                   	push   %edi
80106514:	56                   	push   %esi
80106515:	53                   	push   %ebx
80106516:	83 ec 1c             	sub    $0x1c,%esp
80106519:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010651c:	8b 55 10             	mov    0x10(%ebp),%edx
{
8010651f:	8b 7d 14             	mov    0x14(%ebp),%edi
    *pte = pa | perm | PTE_P;
80106522:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
80106526:	89 c3                	mov    %eax,%ebx
80106528:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010652e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106532:	29 df                	sub    %ebx,%edi
80106534:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106537:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
8010653e:	eb 15                	jmp    80106555 <mappages+0x45>
    if(*pte & PTE_P)
80106540:	f6 00 01             	testb  $0x1,(%eax)
80106543:	75 3d                	jne    80106582 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80106545:	0b 75 18             	or     0x18(%ebp),%esi
    if(a == last)
80106548:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010654b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010654d:	74 29                	je     80106578 <mappages+0x68>
    a += PGSIZE;
8010654f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106555:	8b 45 08             	mov    0x8(%ebp),%eax
80106558:	b9 01 00 00 00       	mov    $0x1,%ecx
8010655d:	89 da                	mov    %ebx,%edx
8010655f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106562:	e8 b9 fd ff ff       	call   80106320 <walkpgdir>
80106567:	85 c0                	test   %eax,%eax
80106569:	75 d5                	jne    80106540 <mappages+0x30>
}
8010656b:	83 c4 1c             	add    $0x1c,%esp
      return -1;
8010656e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106573:	5b                   	pop    %ebx
80106574:	5e                   	pop    %esi
80106575:	5f                   	pop    %edi
80106576:	5d                   	pop    %ebp
80106577:	c3                   	ret    
80106578:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010657b:	31 c0                	xor    %eax,%eax
}
8010657d:	5b                   	pop    %ebx
8010657e:	5e                   	pop    %esi
8010657f:	5f                   	pop    %edi
80106580:	5d                   	pop    %ebp
80106581:	c3                   	ret    
      panic("remap");
80106582:	c7 04 24 90 76 10 80 	movl   $0x80107690,(%esp)
80106589:	e8 d2 9d ff ff       	call   80100360 <panic>
8010658e:	66 90                	xchg   %ax,%ax

80106590 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106590:	a1 a4 55 11 80       	mov    0x801155a4,%eax
{
80106595:	55                   	push   %ebp
80106596:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106598:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010659d:	0f 22 d8             	mov    %eax,%cr3
}
801065a0:	5d                   	pop    %ebp
801065a1:	c3                   	ret    
801065a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065b0 <switchuvm>:
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	57                   	push   %edi
801065b4:	56                   	push   %esi
801065b5:	53                   	push   %ebx
801065b6:	83 ec 1c             	sub    $0x1c,%esp
801065b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801065bc:	85 f6                	test   %esi,%esi
801065be:	0f 84 cd 00 00 00    	je     80106691 <switchuvm+0xe1>
  if(p->kstack == 0)
801065c4:	8b 46 08             	mov    0x8(%esi),%eax
801065c7:	85 c0                	test   %eax,%eax
801065c9:	0f 84 da 00 00 00    	je     801066a9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801065cf:	8b 7e 04             	mov    0x4(%esi),%edi
801065d2:	85 ff                	test   %edi,%edi
801065d4:	0f 84 c3 00 00 00    	je     8010669d <switchuvm+0xed>
  pushcli();
801065da:	e8 11 db ff ff       	call   801040f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801065df:	e8 0c d0 ff ff       	call   801035f0 <mycpu>
801065e4:	89 c3                	mov    %eax,%ebx
801065e6:	e8 05 d0 ff ff       	call   801035f0 <mycpu>
801065eb:	89 c7                	mov    %eax,%edi
801065ed:	e8 fe cf ff ff       	call   801035f0 <mycpu>
801065f2:	83 c7 08             	add    $0x8,%edi
801065f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801065f8:	e8 f3 cf ff ff       	call   801035f0 <mycpu>
801065fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106600:	ba 67 00 00 00       	mov    $0x67,%edx
80106605:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010660c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106613:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010661a:	83 c1 08             	add    $0x8,%ecx
8010661d:	c1 e9 10             	shr    $0x10,%ecx
80106620:	83 c0 08             	add    $0x8,%eax
80106623:	c1 e8 18             	shr    $0x18,%eax
80106626:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010662c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106633:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106639:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010663e:	e8 ad cf ff ff       	call   801035f0 <mycpu>
80106643:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010664a:	e8 a1 cf ff ff       	call   801035f0 <mycpu>
8010664f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106654:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106658:	e8 93 cf ff ff       	call   801035f0 <mycpu>
8010665d:	8b 56 08             	mov    0x8(%esi),%edx
80106660:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106666:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106669:	e8 82 cf ff ff       	call   801035f0 <mycpu>
8010666e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106672:	b8 28 00 00 00       	mov    $0x28,%eax
80106677:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010667a:	8b 46 04             	mov    0x4(%esi),%eax
8010667d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106682:	0f 22 d8             	mov    %eax,%cr3
}
80106685:	83 c4 1c             	add    $0x1c,%esp
80106688:	5b                   	pop    %ebx
80106689:	5e                   	pop    %esi
8010668a:	5f                   	pop    %edi
8010668b:	5d                   	pop    %ebp
  popcli();
8010668c:	e9 1f db ff ff       	jmp    801041b0 <popcli>
    panic("switchuvm: no process");
80106691:	c7 04 24 96 76 10 80 	movl   $0x80107696,(%esp)
80106698:	e8 c3 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
8010669d:	c7 04 24 c1 76 10 80 	movl   $0x801076c1,(%esp)
801066a4:	e8 b7 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
801066a9:	c7 04 24 ac 76 10 80 	movl   $0x801076ac,(%esp)
801066b0:	e8 ab 9c ff ff       	call   80100360 <panic>
801066b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066c0 <inituvm>:
{
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	57                   	push   %edi
801066c4:	56                   	push   %esi
801066c5:	53                   	push   %ebx
801066c6:	83 ec 2c             	sub    $0x2c,%esp
801066c9:	8b 75 10             	mov    0x10(%ebp),%esi
801066cc:	8b 55 08             	mov    0x8(%ebp),%edx
801066cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801066d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801066d8:	77 64                	ja     8010673e <inituvm+0x7e>
801066da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
801066dd:	e8 ae bd ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
801066e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801066e9:	00 
801066ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801066f1:	00 
801066f2:	89 04 24             	mov    %eax,(%esp)
  mem = kalloc();
801066f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801066f7:	e8 74 db ff ff       	call   80104270 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801066fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801066ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106705:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010670c:	00 
8010670d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106711:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106718:	00 
80106719:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106720:	00 
80106721:	89 14 24             	mov    %edx,(%esp)
80106724:	e8 e7 fd ff ff       	call   80106510 <mappages>
  memmove(mem, init, sz);
80106729:	89 75 10             	mov    %esi,0x10(%ebp)
8010672c:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010672f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106732:	83 c4 2c             	add    $0x2c,%esp
80106735:	5b                   	pop    %ebx
80106736:	5e                   	pop    %esi
80106737:	5f                   	pop    %edi
80106738:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106739:	e9 d2 db ff ff       	jmp    80104310 <memmove>
    panic("inituvm: more than a page");
8010673e:	c7 04 24 d5 76 10 80 	movl   $0x801076d5,(%esp)
80106745:	e8 16 9c ff ff       	call   80100360 <panic>
8010674a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106750 <loaduvm>:
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	53                   	push   %ebx
80106756:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106759:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106760:	0f 85 98 00 00 00    	jne    801067fe <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106766:	8b 75 18             	mov    0x18(%ebp),%esi
80106769:	31 db                	xor    %ebx,%ebx
8010676b:	85 f6                	test   %esi,%esi
8010676d:	75 1a                	jne    80106789 <loaduvm+0x39>
8010676f:	eb 77                	jmp    801067e8 <loaduvm+0x98>
80106771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106778:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010677e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106784:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106787:	76 5f                	jbe    801067e8 <loaduvm+0x98>
80106789:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010678c:	31 c9                	xor    %ecx,%ecx
8010678e:	8b 45 08             	mov    0x8(%ebp),%eax
80106791:	01 da                	add    %ebx,%edx
80106793:	e8 88 fb ff ff       	call   80106320 <walkpgdir>
80106798:	85 c0                	test   %eax,%eax
8010679a:	74 56                	je     801067f2 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
8010679c:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
8010679e:	bf 00 10 00 00       	mov    $0x1000,%edi
801067a3:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
801067a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
801067ab:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801067b1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801067b4:	05 00 00 00 80       	add    $0x80000000,%eax
801067b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801067bd:	8b 45 10             	mov    0x10(%ebp),%eax
801067c0:	01 d9                	add    %ebx,%ecx
801067c2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801067c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801067ca:	89 04 24             	mov    %eax,(%esp)
801067cd:	e8 7e b1 ff ff       	call   80101950 <readi>
801067d2:	39 f8                	cmp    %edi,%eax
801067d4:	74 a2                	je     80106778 <loaduvm+0x28>
}
801067d6:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801067d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067de:	5b                   	pop    %ebx
801067df:	5e                   	pop    %esi
801067e0:	5f                   	pop    %edi
801067e1:	5d                   	pop    %ebp
801067e2:	c3                   	ret    
801067e3:	90                   	nop
801067e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067e8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801067eb:	31 c0                	xor    %eax,%eax
}
801067ed:	5b                   	pop    %ebx
801067ee:	5e                   	pop    %esi
801067ef:	5f                   	pop    %edi
801067f0:	5d                   	pop    %ebp
801067f1:	c3                   	ret    
      panic("loaduvm: address should exist");
801067f2:	c7 04 24 ef 76 10 80 	movl   $0x801076ef,(%esp)
801067f9:	e8 62 9b ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
801067fe:	c7 04 24 90 77 10 80 	movl   $0x80107790,(%esp)
80106805:	e8 56 9b ff ff       	call   80100360 <panic>
8010680a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106810 <allocuvm>:
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	57                   	push   %edi
80106814:	56                   	push   %esi
80106815:	53                   	push   %ebx
80106816:	83 ec 2c             	sub    $0x2c,%esp
80106819:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010681c:	85 ff                	test   %edi,%edi
8010681e:	0f 88 8f 00 00 00    	js     801068b3 <allocuvm+0xa3>
  if(newsz < oldsz)
80106824:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106827:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
8010682a:	0f 82 85 00 00 00    	jb     801068b5 <allocuvm+0xa5>
  a = PGROUNDUP(oldsz);
80106830:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106836:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010683c:	39 df                	cmp    %ebx,%edi
8010683e:	77 57                	ja     80106897 <allocuvm+0x87>
80106840:	eb 7e                	jmp    801068c0 <allocuvm+0xb0>
80106842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106848:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010684f:	00 
80106850:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106857:	00 
80106858:	89 04 24             	mov    %eax,(%esp)
8010685b:	e8 10 da ff ff       	call   80104270 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106860:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106866:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010686a:	8b 45 08             	mov    0x8(%ebp),%eax
8010686d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106874:	00 
80106875:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010687c:	00 
8010687d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106881:	89 04 24             	mov    %eax,(%esp)
80106884:	e8 87 fc ff ff       	call   80106510 <mappages>
80106889:	85 c0                	test   %eax,%eax
8010688b:	78 43                	js     801068d0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
8010688d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106893:	39 df                	cmp    %ebx,%edi
80106895:	76 29                	jbe    801068c0 <allocuvm+0xb0>
    mem = kalloc();
80106897:	e8 f4 bb ff ff       	call   80102490 <kalloc>
    if(mem == 0){
8010689c:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010689e:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801068a0:	75 a6                	jne    80106848 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
801068a2:	c7 04 24 0d 77 10 80 	movl   $0x8010770d,(%esp)
801068a9:	e8 a2 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801068ae:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801068b1:	77 47                	ja     801068fa <allocuvm+0xea>
      return 0;
801068b3:	31 c0                	xor    %eax,%eax
}
801068b5:	83 c4 2c             	add    $0x2c,%esp
801068b8:	5b                   	pop    %ebx
801068b9:	5e                   	pop    %esi
801068ba:	5f                   	pop    %edi
801068bb:	5d                   	pop    %ebp
801068bc:	c3                   	ret    
801068bd:	8d 76 00             	lea    0x0(%esi),%esi
801068c0:	83 c4 2c             	add    $0x2c,%esp
801068c3:	89 f8                	mov    %edi,%eax
801068c5:	5b                   	pop    %ebx
801068c6:	5e                   	pop    %esi
801068c7:	5f                   	pop    %edi
801068c8:	5d                   	pop    %ebp
801068c9:	c3                   	ret    
801068ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801068d0:	c7 04 24 25 77 10 80 	movl   $0x80107725,(%esp)
801068d7:	e8 74 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801068dc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801068df:	76 0d                	jbe    801068ee <allocuvm+0xde>
801068e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801068e4:	89 fa                	mov    %edi,%edx
801068e6:	8b 45 08             	mov    0x8(%ebp),%eax
801068e9:	e8 c2 fa ff ff       	call   801063b0 <deallocuvm.part.0>
      kfree(mem);
801068ee:	89 34 24             	mov    %esi,(%esp)
801068f1:	e8 ea b9 ff ff       	call   801022e0 <kfree>
      return 0;
801068f6:	31 c0                	xor    %eax,%eax
801068f8:	eb bb                	jmp    801068b5 <allocuvm+0xa5>
801068fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801068fd:	89 fa                	mov    %edi,%edx
801068ff:	8b 45 08             	mov    0x8(%ebp),%eax
80106902:	e8 a9 fa ff ff       	call   801063b0 <deallocuvm.part.0>
      return 0;
80106907:	31 c0                	xor    %eax,%eax
80106909:	eb aa                	jmp    801068b5 <allocuvm+0xa5>
8010690b:	90                   	nop
8010690c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106910 <deallocuvm>:
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	8b 55 0c             	mov    0xc(%ebp),%edx
80106916:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106919:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010691c:	39 d1                	cmp    %edx,%ecx
8010691e:	73 08                	jae    80106928 <deallocuvm+0x18>
}
80106920:	5d                   	pop    %ebp
80106921:	e9 8a fa ff ff       	jmp    801063b0 <deallocuvm.part.0>
80106926:	66 90                	xchg   %ax,%ax
80106928:	89 d0                	mov    %edx,%eax
8010692a:	5d                   	pop    %ebp
8010692b:	c3                   	ret    
8010692c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106930 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	56                   	push   %esi
80106934:	53                   	push   %ebx
80106935:	83 ec 10             	sub    $0x10,%esp
80106938:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010693b:	85 f6                	test   %esi,%esi
8010693d:	74 59                	je     80106998 <freevm+0x68>
8010693f:	31 c9                	xor    %ecx,%ecx
80106941:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106946:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106948:	31 db                	xor    %ebx,%ebx
8010694a:	e8 61 fa ff ff       	call   801063b0 <deallocuvm.part.0>
8010694f:	eb 12                	jmp    80106963 <freevm+0x33>
80106951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106958:	83 c3 01             	add    $0x1,%ebx
8010695b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106961:	74 27                	je     8010698a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106963:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106966:	f6 c2 01             	test   $0x1,%dl
80106969:	74 ed                	je     80106958 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010696b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106971:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106974:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010697a:	89 14 24             	mov    %edx,(%esp)
8010697d:	e8 5e b9 ff ff       	call   801022e0 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106982:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106988:	75 d9                	jne    80106963 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
8010698a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010698d:	83 c4 10             	add    $0x10,%esp
80106990:	5b                   	pop    %ebx
80106991:	5e                   	pop    %esi
80106992:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106993:	e9 48 b9 ff ff       	jmp    801022e0 <kfree>
    panic("freevm: no pgdir");
80106998:	c7 04 24 41 77 10 80 	movl   $0x80107741,(%esp)
8010699f:	e8 bc 99 ff ff       	call   80100360 <panic>
801069a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801069b0 <setupkvm>:
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	56                   	push   %esi
801069b4:	53                   	push   %ebx
801069b5:	83 ec 20             	sub    $0x20,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
801069b8:	e8 d3 ba ff ff       	call   80102490 <kalloc>
801069bd:	85 c0                	test   %eax,%eax
801069bf:	89 c6                	mov    %eax,%esi
801069c1:	74 75                	je     80106a38 <setupkvm+0x88>
  memset(pgdir, 0, PGSIZE);
801069c3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069ca:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801069cb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801069d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069d7:	00 
801069d8:	89 04 24             	mov    %eax,(%esp)
801069db:	e8 90 d8 ff ff       	call   80104270 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801069e0:	8b 53 0c             	mov    0xc(%ebx),%edx
801069e3:	8b 43 04             	mov    0x4(%ebx),%eax
801069e6:	89 34 24             	mov    %esi,(%esp)
801069e9:	89 54 24 10          	mov    %edx,0x10(%esp)
801069ed:	8b 53 08             	mov    0x8(%ebx),%edx
801069f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
801069f4:	29 c2                	sub    %eax,%edx
801069f6:	8b 03                	mov    (%ebx),%eax
801069f8:	89 54 24 08          	mov    %edx,0x8(%esp)
801069fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a00:	e8 0b fb ff ff       	call   80106510 <mappages>
80106a05:	85 c0                	test   %eax,%eax
80106a07:	78 17                	js     80106a20 <setupkvm+0x70>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a09:	83 c3 10             	add    $0x10,%ebx
80106a0c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106a12:	72 cc                	jb     801069e0 <setupkvm+0x30>
80106a14:	89 f0                	mov    %esi,%eax
}
80106a16:	83 c4 20             	add    $0x20,%esp
80106a19:	5b                   	pop    %ebx
80106a1a:	5e                   	pop    %esi
80106a1b:	5d                   	pop    %ebp
80106a1c:	c3                   	ret    
80106a1d:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
80106a20:	89 34 24             	mov    %esi,(%esp)
80106a23:	e8 08 ff ff ff       	call   80106930 <freevm>
}
80106a28:	83 c4 20             	add    $0x20,%esp
      return 0;
80106a2b:	31 c0                	xor    %eax,%eax
}
80106a2d:	5b                   	pop    %ebx
80106a2e:	5e                   	pop    %esi
80106a2f:	5d                   	pop    %ebp
80106a30:	c3                   	ret    
80106a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106a38:	31 c0                	xor    %eax,%eax
80106a3a:	eb da                	jmp    80106a16 <setupkvm+0x66>
80106a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a40 <kvmalloc>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106a46:	e8 65 ff ff ff       	call   801069b0 <setupkvm>
80106a4b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a50:	05 00 00 00 80       	add    $0x80000000,%eax
80106a55:	0f 22 d8             	mov    %eax,%cr3
}
80106a58:	c9                   	leave  
80106a59:	c3                   	ret    
80106a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106a60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a61:	31 c9                	xor    %ecx,%ecx
{
80106a63:	89 e5                	mov    %esp,%ebp
80106a65:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106a68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a6e:	e8 ad f8 ff ff       	call   80106320 <walkpgdir>
  if(pte == 0)
80106a73:	85 c0                	test   %eax,%eax
80106a75:	74 05                	je     80106a7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106a77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106a7a:	c9                   	leave  
80106a7b:	c3                   	ret    
    panic("clearpteu");
80106a7c:	c7 04 24 52 77 10 80 	movl   $0x80107752,(%esp)
80106a83:	e8 d8 98 ff ff       	call   80100360 <panic>
80106a88:	90                   	nop
80106a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
80106a96:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  struct proc *curproc = myproc();
80106a99:	e8 f2 cb ff ff       	call   80103690 <myproc>
80106a9e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  uint t = PGROUNDDOWN(KERNBASE-1);
  
  if((d = setupkvm()) == 0)
80106aa1:	e8 0a ff ff ff       	call   801069b0 <setupkvm>
80106aa6:	85 c0                	test   %eax,%eax
80106aa8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106aab:	0f 84 8d 01 00 00    	je     80106c3e <copyuvm+0x1ae>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ab4:	85 c0                	test   %eax,%eax
80106ab6:	0f 84 ac 00 00 00    	je     80106b68 <copyuvm+0xd8>
80106abc:	31 db                	xor    %ebx,%ebx
80106abe:	eb 51                	jmp    80106b11 <copyuvm+0x81>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ac0:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106ac6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106acd:	00 
80106ace:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106ad2:	89 04 24             	mov    %eax,(%esp)
80106ad5:	e8 36 d8 ff ff       	call   80104310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106add:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106ae3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106ae7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106aee:	00 
80106aef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106af3:	89 44 24 10          	mov    %eax,0x10(%esp)
80106af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106afa:	89 04 24             	mov    %eax,(%esp)
80106afd:	e8 0e fa ff ff       	call   80106510 <mappages>
80106b02:	85 c0                	test   %eax,%eax
80106b04:	78 4d                	js     80106b53 <copyuvm+0xc3>
  for(i = 0; i < sz; i += PGSIZE){
80106b06:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b0c:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106b0f:	76 57                	jbe    80106b68 <copyuvm+0xd8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b11:	8b 45 08             	mov    0x8(%ebp),%eax
80106b14:	31 c9                	xor    %ecx,%ecx
80106b16:	89 da                	mov    %ebx,%edx
80106b18:	e8 03 f8 ff ff       	call   80106320 <walkpgdir>
80106b1d:	85 c0                	test   %eax,%eax
80106b1f:	0f 84 2c 01 00 00    	je     80106c51 <copyuvm+0x1c1>
    if(!(*pte & PTE_P))
80106b25:	8b 30                	mov    (%eax),%esi
80106b27:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106b2d:	0f 84 12 01 00 00    	je     80106c45 <copyuvm+0x1b5>
    pa = PTE_ADDR(*pte);
80106b33:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106b35:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106b3b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106b3e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106b44:	e8 47 b9 ff ff       	call   80102490 <kalloc>
80106b49:	85 c0                	test   %eax,%eax
80106b4b:	89 c6                	mov    %eax,%esi
80106b4d:	0f 85 6d ff ff ff    	jne    80106ac0 <copyuvm+0x30>
  }
  
  return d;

bad:
  freevm(d);
80106b53:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b56:	89 04 24             	mov    %eax,(%esp)
80106b59:	e8 d2 fd ff ff       	call   80106930 <freevm>
  return 0;
80106b5e:	31 c0                	xor    %eax,%eax
}
80106b60:	83 c4 2c             	add    $0x2c,%esp
80106b63:	5b                   	pop    %ebx
80106b64:	5e                   	pop    %esi
80106b65:	5f                   	pop    %edi
80106b66:	5d                   	pop    %ebp
80106b67:	c3                   	ret    
  for(i = t; i > t - (curproc->stack_pages) * PGSIZE; i -= PGSIZE){
80106b68:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b6b:	8b 40 7c             	mov    0x7c(%eax),%eax
80106b6e:	f7 d8                	neg    %eax
80106b70:	c1 e0 0c             	shl    $0xc,%eax
80106b73:	05 00 f0 ff 7f       	add    $0x7ffff000,%eax
80106b78:	3d ff ef ff 7f       	cmp    $0x7fffefff,%eax
80106b7d:	0f 87 b0 00 00 00    	ja     80106c33 <copyuvm+0x1a3>
80106b83:	bb 00 f0 ff 7f       	mov    $0x7ffff000,%ebx
80106b88:	eb 6a                	jmp    80106bf4 <copyuvm+0x164>
80106b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106b90:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106b96:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b9d:	00 
80106b9e:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106ba2:	89 04 24             	mov    %eax,(%esp)
80106ba5:	e8 66 d7 ff ff       	call   80104310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bad:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106bb3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106bb7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bbe:	00 
80106bbf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106bc3:	89 44 24 10          	mov    %eax,0x10(%esp)
80106bc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bca:	89 04 24             	mov    %eax,(%esp)
80106bcd:	e8 3e f9 ff ff       	call   80106510 <mappages>
80106bd2:	85 c0                	test   %eax,%eax
80106bd4:	0f 88 79 ff ff ff    	js     80106b53 <copyuvm+0xc3>
  for(i = t; i > t - (curproc->stack_pages) * PGSIZE; i -= PGSIZE){
80106bda:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106bdd:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106be3:	8b 40 7c             	mov    0x7c(%eax),%eax
80106be6:	f7 d8                	neg    %eax
80106be8:	c1 e0 0c             	shl    $0xc,%eax
80106beb:	05 00 f0 ff 7f       	add    $0x7ffff000,%eax
80106bf0:	39 d8                	cmp    %ebx,%eax
80106bf2:	73 3f                	jae    80106c33 <copyuvm+0x1a3>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106bf4:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf7:	31 c9                	xor    %ecx,%ecx
80106bf9:	89 da                	mov    %ebx,%edx
80106bfb:	e8 20 f7 ff ff       	call   80106320 <walkpgdir>
80106c00:	85 c0                	test   %eax,%eax
80106c02:	74 4d                	je     80106c51 <copyuvm+0x1c1>
    if(!(*pte & PTE_P))
80106c04:	8b 30                	mov    (%eax),%esi
80106c06:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106c0c:	74 37                	je     80106c45 <copyuvm+0x1b5>
    pa = PTE_ADDR(*pte);
80106c0e:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106c10:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106c16:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106c19:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106c1f:	e8 6c b8 ff ff       	call   80102490 <kalloc>
80106c24:	85 c0                	test   %eax,%eax
80106c26:	89 c6                	mov    %eax,%esi
80106c28:	0f 85 62 ff ff ff    	jne    80106b90 <copyuvm+0x100>
80106c2e:	e9 20 ff ff ff       	jmp    80106b53 <copyuvm+0xc3>
80106c33:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80106c36:	83 c4 2c             	add    $0x2c,%esp
80106c39:	5b                   	pop    %ebx
80106c3a:	5e                   	pop    %esi
80106c3b:	5f                   	pop    %edi
80106c3c:	5d                   	pop    %ebp
80106c3d:	c3                   	ret    
    return 0;
80106c3e:	31 c0                	xor    %eax,%eax
80106c40:	e9 1b ff ff ff       	jmp    80106b60 <copyuvm+0xd0>
      panic("copyuvm: page not present");
80106c45:	c7 04 24 76 77 10 80 	movl   $0x80107776,(%esp)
80106c4c:	e8 0f 97 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106c51:	c7 04 24 5c 77 10 80 	movl   $0x8010775c,(%esp)
80106c58:	e8 03 97 ff ff       	call   80100360 <panic>
80106c5d:	8d 76 00             	lea    0x0(%esi),%esi

80106c60 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c61:	31 c9                	xor    %ecx,%ecx
{
80106c63:	89 e5                	mov    %esp,%ebp
80106c65:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106c68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c6e:	e8 ad f6 ff ff       	call   80106320 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106c73:	8b 00                	mov    (%eax),%eax
80106c75:	89 c2                	mov    %eax,%edx
80106c77:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106c7a:	83 fa 05             	cmp    $0x5,%edx
80106c7d:	75 11                	jne    80106c90 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106c7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c84:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106c89:	c9                   	leave  
80106c8a:	c3                   	ret    
80106c8b:	90                   	nop
80106c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106c90:	31 c0                	xor    %eax,%eax
}
80106c92:	c9                   	leave  
80106c93:	c3                   	ret    
80106c94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ca0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 1c             	sub    $0x1c,%esp
80106ca9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106caf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106cb2:	85 db                	test   %ebx,%ebx
80106cb4:	75 3a                	jne    80106cf0 <copyout+0x50>
80106cb6:	eb 68                	jmp    80106d20 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106cb8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cbb:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106cbd:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106cc1:	29 ca                	sub    %ecx,%edx
80106cc3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106cc9:	39 da                	cmp    %ebx,%edx
80106ccb:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106cce:	29 f1                	sub    %esi,%ecx
80106cd0:	01 c8                	add    %ecx,%eax
80106cd2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106cd6:	89 04 24             	mov    %eax,(%esp)
80106cd9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106cdc:	e8 2f d6 ff ff       	call   80104310 <memmove>
    len -= n;
    buf += n;
80106ce1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106ce4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106cea:	01 d7                	add    %edx,%edi
  while(len > 0){
80106cec:	29 d3                	sub    %edx,%ebx
80106cee:	74 30                	je     80106d20 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106cf0:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106cf3:	89 ce                	mov    %ecx,%esi
80106cf5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106cfb:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106cff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106d02:	89 04 24             	mov    %eax,(%esp)
80106d05:	e8 56 ff ff ff       	call   80106c60 <uva2ka>
    if(pa0 == 0)
80106d0a:	85 c0                	test   %eax,%eax
80106d0c:	75 aa                	jne    80106cb8 <copyout+0x18>
  }
  return 0;
}
80106d0e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d16:	5b                   	pop    %ebx
80106d17:	5e                   	pop    %esi
80106d18:	5f                   	pop    %edi
80106d19:	5d                   	pop    %ebp
80106d1a:	c3                   	ret    
80106d1b:	90                   	nop
80106d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d20:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106d23:	31 c0                	xor    %eax,%eax
}
80106d25:	5b                   	pop    %ebx
80106d26:	5e                   	pop    %esi
80106d27:	5f                   	pop    %edi
80106d28:	5d                   	pop    %ebp
80106d29:	c3                   	ret    
80106d2a:	66 90                	xchg   %ax,%ax
80106d2c:	66 90                	xchg   %ax,%ax
80106d2e:	66 90                	xchg   %ax,%ax

80106d30 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106d36:	c7 44 24 04 b4 77 10 	movl   $0x801077b4,0x4(%esp)
80106d3d:	80 
80106d3e:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106d45:	e8 f6 d2 ff ff       	call   80104040 <initlock>
  acquire(&(shm_table.lock));
80106d4a:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106d51:	e8 da d3 ff ff       	call   80104130 <acquire>
80106d56:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80106d5b:	90                   	nop
80106d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106d66:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80106d69:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80106d70:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
80106d77:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
80106d7c:	75 e2                	jne    80106d60 <shminit+0x30>
  }
  release(&(shm_table.lock));
80106d7e:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106d85:	e8 96 d4 ff ff       	call   80104220 <release>
}
80106d8a:	c9                   	leave  
80106d8b:	c3                   	ret    
80106d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d90 <shm_open>:

int shm_open(int id, char **pointer) {
80106d90:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106d91:	31 c0                	xor    %eax,%eax
int shm_open(int id, char **pointer) {
80106d93:	89 e5                	mov    %esp,%ebp
}
80106d95:	5d                   	pop    %ebp
80106d96:	c3                   	ret    
80106d97:	89 f6                	mov    %esi,%esi
80106d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106da0 <shm_close>:


int shm_close(int id) {
80106da0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106da1:	31 c0                	xor    %eax,%eax
int shm_close(int id) {
80106da3:	89 e5                	mov    %esp,%ebp
}
80106da5:	5d                   	pop    %ebp
80106da6:	c3                   	ret    
