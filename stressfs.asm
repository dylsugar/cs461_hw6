
_stressfs:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
    100f:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
    1015:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
  int fd, i;
  char path[] = "stressfs0";
    101c:	48 b8 73 74 72 65 73 	movabs $0x7366737365727473,%rax
    1023:	73 66 73 
    1026:	48 89 45 ee          	mov    %rax,-0x12(%rbp)
    102a:	66 c7 45 f6 30 00    	movw   $0x30,-0xa(%rbp)
  char data[512];

  printf(1, "stressfs starting\n");
    1030:	48 be 08 23 00 00 00 	movabs $0x2308,%rsi
    1037:	00 00 00 
    103a:	bf 01 00 00 00       	mov    $0x1,%edi
    103f:	b8 00 00 00 00       	mov    $0x0,%eax
    1044:	48 ba ec 17 00 00 00 	movabs $0x17ec,%rdx
    104b:	00 00 00 
    104e:	ff d2                	callq  *%rdx
  memset(data, 'a', sizeof(data));
    1050:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
    1057:	ba 00 02 00 00       	mov    $0x200,%edx
    105c:	be 61 00 00 00       	mov    $0x61,%esi
    1061:	48 89 c7             	mov    %rax,%rdi
    1064:	48 b8 cd 12 00 00 00 	movabs $0x12cd,%rax
    106b:	00 00 00 
    106e:	ff d0                	callq  *%rax

  for(i = 0; i < 4; i++)
    1070:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1077:	eb 14                	jmp    108d <main+0x8d>
    if(fork() > 0)
    1079:	48 b8 f5 14 00 00 00 	movabs $0x14f5,%rax
    1080:	00 00 00 
    1083:	ff d0                	callq  *%rax
    1085:	85 c0                	test   %eax,%eax
    1087:	7f 0c                	jg     1095 <main+0x95>
  for(i = 0; i < 4; i++)
    1089:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    108d:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    1091:	7e e6                	jle    1079 <main+0x79>
    1093:	eb 01                	jmp    1096 <main+0x96>
      break;
    1095:	90                   	nop

  printf(1, "write %d\n", i);
    1096:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1099:	89 c2                	mov    %eax,%edx
    109b:	48 be 1b 23 00 00 00 	movabs $0x231b,%rsi
    10a2:	00 00 00 
    10a5:	bf 01 00 00 00       	mov    $0x1,%edi
    10aa:	b8 00 00 00 00       	mov    $0x0,%eax
    10af:	48 b9 ec 17 00 00 00 	movabs $0x17ec,%rcx
    10b6:	00 00 00 
    10b9:	ff d1                	callq  *%rcx

  path[8] += i;
    10bb:	0f b6 45 f6          	movzbl -0xa(%rbp),%eax
    10bf:	89 c2                	mov    %eax,%edx
    10c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10c4:	01 d0                	add    %edx,%eax
    10c6:	88 45 f6             	mov    %al,-0xa(%rbp)
  fd = open(path, O_CREATE | O_RDWR);
    10c9:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    10cd:	be 02 02 00 00       	mov    $0x202,%esi
    10d2:	48 89 c7             	mov    %rax,%rdi
    10d5:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    10dc:	00 00 00 
    10df:	ff d0                	callq  *%rax
    10e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for(i = 0; i < 20; i++)
    10e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    10eb:	eb 24                	jmp    1111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
    10ed:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
    10f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
    10f7:	ba 00 02 00 00       	mov    $0x200,%edx
    10fc:	48 89 ce             	mov    %rcx,%rsi
    10ff:	89 c7                	mov    %eax,%edi
    1101:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    1108:	00 00 00 
    110b:	ff d0                	callq  *%rax
  for(i = 0; i < 20; i++)
    110d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1111:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    1115:	7e d6                	jle    10ed <main+0xed>
  close(fd);
    1117:	8b 45 f8             	mov    -0x8(%rbp),%eax
    111a:	89 c7                	mov    %eax,%edi
    111c:	48 b8 43 15 00 00 00 	movabs $0x1543,%rax
    1123:	00 00 00 
    1126:	ff d0                	callq  *%rax

  printf(1, "read\n");
    1128:	48 be 25 23 00 00 00 	movabs $0x2325,%rsi
    112f:	00 00 00 
    1132:	bf 01 00 00 00       	mov    $0x1,%edi
    1137:	b8 00 00 00 00       	mov    $0x0,%eax
    113c:	48 ba ec 17 00 00 00 	movabs $0x17ec,%rdx
    1143:	00 00 00 
    1146:	ff d2                	callq  *%rdx

  fd = open(path, O_RDONLY);
    1148:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    114c:	be 00 00 00 00       	mov    $0x0,%esi
    1151:	48 89 c7             	mov    %rax,%rdi
    1154:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    115b:	00 00 00 
    115e:	ff d0                	callq  *%rax
    1160:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (i = 0; i < 20; i++)
    1163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    116a:	eb 24                	jmp    1190 <main+0x190>
    read(fd, data, sizeof(data));
    116c:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
    1173:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1176:	ba 00 02 00 00       	mov    $0x200,%edx
    117b:	48 89 ce             	mov    %rcx,%rsi
    117e:	89 c7                	mov    %eax,%edi
    1180:	48 b8 29 15 00 00 00 	movabs $0x1529,%rax
    1187:	00 00 00 
    118a:	ff d0                	callq  *%rax
  for (i = 0; i < 20; i++)
    118c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1190:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    1194:	7e d6                	jle    116c <main+0x16c>
  close(fd);
    1196:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1199:	89 c7                	mov    %eax,%edi
    119b:	48 b8 43 15 00 00 00 	movabs $0x1543,%rax
    11a2:	00 00 00 
    11a5:	ff d0                	callq  *%rax

  wait();
    11a7:	48 b8 0f 15 00 00 00 	movabs $0x150f,%rax
    11ae:	00 00 00 
    11b1:	ff d0                	callq  *%rax

  exit();
    11b3:	48 b8 02 15 00 00 00 	movabs $0x1502,%rax
    11ba:	00 00 00 
    11bd:	ff d0                	callq  *%rax

00000000000011bf <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11bf:	f3 0f 1e fa          	endbr64 
    11c3:	55                   	push   %rbp
    11c4:	48 89 e5             	mov    %rsp,%rbp
    11c7:	48 83 ec 10          	sub    $0x10,%rsp
    11cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11cf:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11d2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    11d5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    11d9:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11df:	48 89 ce             	mov    %rcx,%rsi
    11e2:	48 89 f7             	mov    %rsi,%rdi
    11e5:	89 d1                	mov    %edx,%ecx
    11e7:	fc                   	cld    
    11e8:	f3 aa                	rep stos %al,%es:(%rdi)
    11ea:	89 ca                	mov    %ecx,%edx
    11ec:	48 89 fe             	mov    %rdi,%rsi
    11ef:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11f3:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11f6:	90                   	nop
    11f7:	c9                   	leaveq 
    11f8:	c3                   	retq   

00000000000011f9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11f9:	f3 0f 1e fa          	endbr64 
    11fd:	55                   	push   %rbp
    11fe:	48 89 e5             	mov    %rsp,%rbp
    1201:	48 83 ec 20          	sub    $0x20,%rsp
    1205:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1209:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    120d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1211:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1215:	90                   	nop
    1216:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    121a:	48 8d 42 01          	lea    0x1(%rdx),%rax
    121e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1226:	48 8d 48 01          	lea    0x1(%rax),%rcx
    122a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    122e:	0f b6 12             	movzbl (%rdx),%edx
    1231:	88 10                	mov    %dl,(%rax)
    1233:	0f b6 00             	movzbl (%rax),%eax
    1236:	84 c0                	test   %al,%al
    1238:	75 dc                	jne    1216 <strcpy+0x1d>
    ;
  return os;
    123a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    123e:	c9                   	leaveq 
    123f:	c3                   	retq   

0000000000001240 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1240:	f3 0f 1e fa          	endbr64 
    1244:	55                   	push   %rbp
    1245:	48 89 e5             	mov    %rsp,%rbp
    1248:	48 83 ec 10          	sub    $0x10,%rsp
    124c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1250:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1254:	eb 0a                	jmp    1260 <strcmp+0x20>
    p++, q++;
    1256:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    125b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1264:	0f b6 00             	movzbl (%rax),%eax
    1267:	84 c0                	test   %al,%al
    1269:	74 12                	je     127d <strcmp+0x3d>
    126b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    126f:	0f b6 10             	movzbl (%rax),%edx
    1272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1276:	0f b6 00             	movzbl (%rax),%eax
    1279:	38 c2                	cmp    %al,%dl
    127b:	74 d9                	je     1256 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    127d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1281:	0f b6 00             	movzbl (%rax),%eax
    1284:	0f b6 d0             	movzbl %al,%edx
    1287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    128b:	0f b6 00             	movzbl (%rax),%eax
    128e:	0f b6 c0             	movzbl %al,%eax
    1291:	29 c2                	sub    %eax,%edx
    1293:	89 d0                	mov    %edx,%eax
}
    1295:	c9                   	leaveq 
    1296:	c3                   	retq   

0000000000001297 <strlen>:

uint
strlen(char *s)
{
    1297:	f3 0f 1e fa          	endbr64 
    129b:	55                   	push   %rbp
    129c:	48 89 e5             	mov    %rsp,%rbp
    129f:	48 83 ec 18          	sub    $0x18,%rsp
    12a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    12a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12ae:	eb 04                	jmp    12b4 <strlen+0x1d>
    12b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    12b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12b7:	48 63 d0             	movslq %eax,%rdx
    12ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12be:	48 01 d0             	add    %rdx,%rax
    12c1:	0f b6 00             	movzbl (%rax),%eax
    12c4:	84 c0                	test   %al,%al
    12c6:	75 e8                	jne    12b0 <strlen+0x19>
    ;
  return n;
    12c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    12cb:	c9                   	leaveq 
    12cc:	c3                   	retq   

00000000000012cd <memset>:

void*
memset(void *dst, int c, uint n)
{
    12cd:	f3 0f 1e fa          	endbr64 
    12d1:	55                   	push   %rbp
    12d2:	48 89 e5             	mov    %rsp,%rbp
    12d5:	48 83 ec 10          	sub    $0x10,%rsp
    12d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12dd:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12e0:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12e3:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12e6:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ed:	89 ce                	mov    %ecx,%esi
    12ef:	48 89 c7             	mov    %rax,%rdi
    12f2:	48 b8 bf 11 00 00 00 	movabs $0x11bf,%rax
    12f9:	00 00 00 
    12fc:	ff d0                	callq  *%rax
  return dst;
    12fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1302:	c9                   	leaveq 
    1303:	c3                   	retq   

0000000000001304 <strchr>:

char*
strchr(const char *s, char c)
{
    1304:	f3 0f 1e fa          	endbr64 
    1308:	55                   	push   %rbp
    1309:	48 89 e5             	mov    %rsp,%rbp
    130c:	48 83 ec 10          	sub    $0x10,%rsp
    1310:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1314:	89 f0                	mov    %esi,%eax
    1316:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1319:	eb 17                	jmp    1332 <strchr+0x2e>
    if(*s == c)
    131b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    131f:	0f b6 00             	movzbl (%rax),%eax
    1322:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1325:	75 06                	jne    132d <strchr+0x29>
      return (char*)s;
    1327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    132b:	eb 15                	jmp    1342 <strchr+0x3e>
  for(; *s; s++)
    132d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1336:	0f b6 00             	movzbl (%rax),%eax
    1339:	84 c0                	test   %al,%al
    133b:	75 de                	jne    131b <strchr+0x17>
  return 0;
    133d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1342:	c9                   	leaveq 
    1343:	c3                   	retq   

0000000000001344 <gets>:

char*
gets(char *buf, int max)
{
    1344:	f3 0f 1e fa          	endbr64 
    1348:	55                   	push   %rbp
    1349:	48 89 e5             	mov    %rsp,%rbp
    134c:	48 83 ec 20          	sub    $0x20,%rsp
    1350:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1354:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1357:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    135e:	eb 4f                	jmp    13af <gets+0x6b>
    cc = read(0, &c, 1);
    1360:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1364:	ba 01 00 00 00       	mov    $0x1,%edx
    1369:	48 89 c6             	mov    %rax,%rsi
    136c:	bf 00 00 00 00       	mov    $0x0,%edi
    1371:	48 b8 29 15 00 00 00 	movabs $0x1529,%rax
    1378:	00 00 00 
    137b:	ff d0                	callq  *%rax
    137d:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1380:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1384:	7e 36                	jle    13bc <gets+0x78>
      break;
    buf[i++] = c;
    1386:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1389:	8d 50 01             	lea    0x1(%rax),%edx
    138c:	89 55 fc             	mov    %edx,-0x4(%rbp)
    138f:	48 63 d0             	movslq %eax,%rdx
    1392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1396:	48 01 c2             	add    %rax,%rdx
    1399:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    139d:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    139f:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13a3:	3c 0a                	cmp    $0xa,%al
    13a5:	74 16                	je     13bd <gets+0x79>
    13a7:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13ab:	3c 0d                	cmp    $0xd,%al
    13ad:	74 0e                	je     13bd <gets+0x79>
  for(i=0; i+1 < max; ){
    13af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13b2:	83 c0 01             	add    $0x1,%eax
    13b5:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    13b8:	7f a6                	jg     1360 <gets+0x1c>
    13ba:	eb 01                	jmp    13bd <gets+0x79>
      break;
    13bc:	90                   	nop
      break;
  }
  buf[i] = '\0';
    13bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13c0:	48 63 d0             	movslq %eax,%rdx
    13c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13c7:	48 01 d0             	add    %rdx,%rax
    13ca:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    13cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13d1:	c9                   	leaveq 
    13d2:	c3                   	retq   

00000000000013d3 <stat>:

int
stat(char *n, struct stat *st)
{
    13d3:	f3 0f 1e fa          	endbr64 
    13d7:	55                   	push   %rbp
    13d8:	48 89 e5             	mov    %rsp,%rbp
    13db:	48 83 ec 20          	sub    $0x20,%rsp
    13df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13eb:	be 00 00 00 00       	mov    $0x0,%esi
    13f0:	48 89 c7             	mov    %rax,%rdi
    13f3:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    13fa:	00 00 00 
    13fd:	ff d0                	callq  *%rax
    13ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1402:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1406:	79 07                	jns    140f <stat+0x3c>
    return -1;
    1408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    140d:	eb 2f                	jmp    143e <stat+0x6b>
  r = fstat(fd, st);
    140f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1413:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1416:	48 89 d6             	mov    %rdx,%rsi
    1419:	89 c7                	mov    %eax,%edi
    141b:	48 b8 91 15 00 00 00 	movabs $0x1591,%rax
    1422:	00 00 00 
    1425:	ff d0                	callq  *%rax
    1427:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    142a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    142d:	89 c7                	mov    %eax,%edi
    142f:	48 b8 43 15 00 00 00 	movabs $0x1543,%rax
    1436:	00 00 00 
    1439:	ff d0                	callq  *%rax
  return r;
    143b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    143e:	c9                   	leaveq 
    143f:	c3                   	retq   

0000000000001440 <atoi>:

int
atoi(const char *s)
{
    1440:	f3 0f 1e fa          	endbr64 
    1444:	55                   	push   %rbp
    1445:	48 89 e5             	mov    %rsp,%rbp
    1448:	48 83 ec 18          	sub    $0x18,%rsp
    144c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1450:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1457:	eb 28                	jmp    1481 <atoi+0x41>
    n = n*10 + *s++ - '0';
    1459:	8b 55 fc             	mov    -0x4(%rbp),%edx
    145c:	89 d0                	mov    %edx,%eax
    145e:	c1 e0 02             	shl    $0x2,%eax
    1461:	01 d0                	add    %edx,%eax
    1463:	01 c0                	add    %eax,%eax
    1465:	89 c1                	mov    %eax,%ecx
    1467:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    146b:	48 8d 50 01          	lea    0x1(%rax),%rdx
    146f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1473:	0f b6 00             	movzbl (%rax),%eax
    1476:	0f be c0             	movsbl %al,%eax
    1479:	01 c8                	add    %ecx,%eax
    147b:	83 e8 30             	sub    $0x30,%eax
    147e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1485:	0f b6 00             	movzbl (%rax),%eax
    1488:	3c 2f                	cmp    $0x2f,%al
    148a:	7e 0b                	jle    1497 <atoi+0x57>
    148c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1490:	0f b6 00             	movzbl (%rax),%eax
    1493:	3c 39                	cmp    $0x39,%al
    1495:	7e c2                	jle    1459 <atoi+0x19>
  return n;
    1497:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    149a:	c9                   	leaveq 
    149b:	c3                   	retq   

000000000000149c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    149c:	f3 0f 1e fa          	endbr64 
    14a0:	55                   	push   %rbp
    14a1:	48 89 e5             	mov    %rsp,%rbp
    14a4:	48 83 ec 28          	sub    $0x28,%rsp
    14a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    14b0:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    14b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    14bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    14c3:	eb 1d                	jmp    14e2 <memmove+0x46>
    *dst++ = *src++;
    14c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    14c9:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    14d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14d5:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14d9:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    14dd:	0f b6 12             	movzbl (%rdx),%edx
    14e0:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14e5:	8d 50 ff             	lea    -0x1(%rax),%edx
    14e8:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14eb:	85 c0                	test   %eax,%eax
    14ed:	7f d6                	jg     14c5 <memmove+0x29>
  return vdst;
    14ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14f3:	c9                   	leaveq 
    14f4:	c3                   	retq   

00000000000014f5 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14f5:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14fc:	49 89 ca             	mov    %rcx,%r10
    14ff:	0f 05                	syscall 
    1501:	c3                   	retq   

0000000000001502 <exit>:
SYSCALL(exit)
    1502:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1509:	49 89 ca             	mov    %rcx,%r10
    150c:	0f 05                	syscall 
    150e:	c3                   	retq   

000000000000150f <wait>:
SYSCALL(wait)
    150f:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1516:	49 89 ca             	mov    %rcx,%r10
    1519:	0f 05                	syscall 
    151b:	c3                   	retq   

000000000000151c <pipe>:
SYSCALL(pipe)
    151c:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1523:	49 89 ca             	mov    %rcx,%r10
    1526:	0f 05                	syscall 
    1528:	c3                   	retq   

0000000000001529 <read>:
SYSCALL(read)
    1529:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1530:	49 89 ca             	mov    %rcx,%r10
    1533:	0f 05                	syscall 
    1535:	c3                   	retq   

0000000000001536 <write>:
SYSCALL(write)
    1536:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    153d:	49 89 ca             	mov    %rcx,%r10
    1540:	0f 05                	syscall 
    1542:	c3                   	retq   

0000000000001543 <close>:
SYSCALL(close)
    1543:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    154a:	49 89 ca             	mov    %rcx,%r10
    154d:	0f 05                	syscall 
    154f:	c3                   	retq   

0000000000001550 <kill>:
SYSCALL(kill)
    1550:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1557:	49 89 ca             	mov    %rcx,%r10
    155a:	0f 05                	syscall 
    155c:	c3                   	retq   

000000000000155d <exec>:
SYSCALL(exec)
    155d:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1564:	49 89 ca             	mov    %rcx,%r10
    1567:	0f 05                	syscall 
    1569:	c3                   	retq   

000000000000156a <open>:
SYSCALL(open)
    156a:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1571:	49 89 ca             	mov    %rcx,%r10
    1574:	0f 05                	syscall 
    1576:	c3                   	retq   

0000000000001577 <mknod>:
SYSCALL(mknod)
    1577:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    157e:	49 89 ca             	mov    %rcx,%r10
    1581:	0f 05                	syscall 
    1583:	c3                   	retq   

0000000000001584 <unlink>:
SYSCALL(unlink)
    1584:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    158b:	49 89 ca             	mov    %rcx,%r10
    158e:	0f 05                	syscall 
    1590:	c3                   	retq   

0000000000001591 <fstat>:
SYSCALL(fstat)
    1591:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1598:	49 89 ca             	mov    %rcx,%r10
    159b:	0f 05                	syscall 
    159d:	c3                   	retq   

000000000000159e <link>:
SYSCALL(link)
    159e:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    15a5:	49 89 ca             	mov    %rcx,%r10
    15a8:	0f 05                	syscall 
    15aa:	c3                   	retq   

00000000000015ab <mkdir>:
SYSCALL(mkdir)
    15ab:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    15b2:	49 89 ca             	mov    %rcx,%r10
    15b5:	0f 05                	syscall 
    15b7:	c3                   	retq   

00000000000015b8 <chdir>:
SYSCALL(chdir)
    15b8:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    15bf:	49 89 ca             	mov    %rcx,%r10
    15c2:	0f 05                	syscall 
    15c4:	c3                   	retq   

00000000000015c5 <dup>:
SYSCALL(dup)
    15c5:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    15cc:	49 89 ca             	mov    %rcx,%r10
    15cf:	0f 05                	syscall 
    15d1:	c3                   	retq   

00000000000015d2 <getpid>:
SYSCALL(getpid)
    15d2:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    15d9:	49 89 ca             	mov    %rcx,%r10
    15dc:	0f 05                	syscall 
    15de:	c3                   	retq   

00000000000015df <sbrk>:
SYSCALL(sbrk)
    15df:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15e6:	49 89 ca             	mov    %rcx,%r10
    15e9:	0f 05                	syscall 
    15eb:	c3                   	retq   

00000000000015ec <sleep>:
SYSCALL(sleep)
    15ec:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15f3:	49 89 ca             	mov    %rcx,%r10
    15f6:	0f 05                	syscall 
    15f8:	c3                   	retq   

00000000000015f9 <uptime>:
SYSCALL(uptime)
    15f9:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1600:	49 89 ca             	mov    %rcx,%r10
    1603:	0f 05                	syscall 
    1605:	c3                   	retq   

0000000000001606 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1606:	f3 0f 1e fa          	endbr64 
    160a:	55                   	push   %rbp
    160b:	48 89 e5             	mov    %rsp,%rbp
    160e:	48 83 ec 10          	sub    $0x10,%rsp
    1612:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1615:	89 f0                	mov    %esi,%eax
    1617:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    161a:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    161e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1621:	ba 01 00 00 00       	mov    $0x1,%edx
    1626:	48 89 ce             	mov    %rcx,%rsi
    1629:	89 c7                	mov    %eax,%edi
    162b:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    1632:	00 00 00 
    1635:	ff d0                	callq  *%rax
}
    1637:	90                   	nop
    1638:	c9                   	leaveq 
    1639:	c3                   	retq   

000000000000163a <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    163a:	f3 0f 1e fa          	endbr64 
    163e:	55                   	push   %rbp
    163f:	48 89 e5             	mov    %rsp,%rbp
    1642:	48 83 ec 20          	sub    $0x20,%rsp
    1646:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1649:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    164d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1654:	eb 35                	jmp    168b <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1656:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    165a:	48 c1 e8 3c          	shr    $0x3c,%rax
    165e:	48 ba 20 27 00 00 00 	movabs $0x2720,%rdx
    1665:	00 00 00 
    1668:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    166c:	0f be d0             	movsbl %al,%edx
    166f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1672:	89 d6                	mov    %edx,%esi
    1674:	89 c7                	mov    %eax,%edi
    1676:	48 b8 06 16 00 00 00 	movabs $0x1606,%rax
    167d:	00 00 00 
    1680:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1682:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1686:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    168b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    168e:	83 f8 0f             	cmp    $0xf,%eax
    1691:	76 c3                	jbe    1656 <print_x64+0x1c>
}
    1693:	90                   	nop
    1694:	90                   	nop
    1695:	c9                   	leaveq 
    1696:	c3                   	retq   

0000000000001697 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1697:	f3 0f 1e fa          	endbr64 
    169b:	55                   	push   %rbp
    169c:	48 89 e5             	mov    %rsp,%rbp
    169f:	48 83 ec 20          	sub    $0x20,%rsp
    16a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16a6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16b0:	eb 36                	jmp    16e8 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    16b2:	8b 45 e8             	mov    -0x18(%rbp),%eax
    16b5:	c1 e8 1c             	shr    $0x1c,%eax
    16b8:	89 c2                	mov    %eax,%edx
    16ba:	48 b8 20 27 00 00 00 	movabs $0x2720,%rax
    16c1:	00 00 00 
    16c4:	89 d2                	mov    %edx,%edx
    16c6:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    16ca:	0f be d0             	movsbl %al,%edx
    16cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16d0:	89 d6                	mov    %edx,%esi
    16d2:	89 c7                	mov    %eax,%edi
    16d4:	48 b8 06 16 00 00 00 	movabs $0x1606,%rax
    16db:	00 00 00 
    16de:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16e0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16e4:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16eb:	83 f8 07             	cmp    $0x7,%eax
    16ee:	76 c2                	jbe    16b2 <print_x32+0x1b>
}
    16f0:	90                   	nop
    16f1:	90                   	nop
    16f2:	c9                   	leaveq 
    16f3:	c3                   	retq   

00000000000016f4 <print_d>:

  static void
print_d(int fd, int v)
{
    16f4:	f3 0f 1e fa          	endbr64 
    16f8:	55                   	push   %rbp
    16f9:	48 89 e5             	mov    %rsp,%rbp
    16fc:	48 83 ec 30          	sub    $0x30,%rsp
    1700:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1703:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1706:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1709:	48 98                	cltq   
    170b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    170f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1713:	79 04                	jns    1719 <print_d+0x25>
    x = -x;
    1715:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1719:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1720:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1724:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    172b:	66 66 66 
    172e:	48 89 c8             	mov    %rcx,%rax
    1731:	48 f7 ea             	imul   %rdx
    1734:	48 c1 fa 02          	sar    $0x2,%rdx
    1738:	48 89 c8             	mov    %rcx,%rax
    173b:	48 c1 f8 3f          	sar    $0x3f,%rax
    173f:	48 29 c2             	sub    %rax,%rdx
    1742:	48 89 d0             	mov    %rdx,%rax
    1745:	48 c1 e0 02          	shl    $0x2,%rax
    1749:	48 01 d0             	add    %rdx,%rax
    174c:	48 01 c0             	add    %rax,%rax
    174f:	48 29 c1             	sub    %rax,%rcx
    1752:	48 89 ca             	mov    %rcx,%rdx
    1755:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1758:	8d 48 01             	lea    0x1(%rax),%ecx
    175b:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    175e:	48 b9 20 27 00 00 00 	movabs $0x2720,%rcx
    1765:	00 00 00 
    1768:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    176c:	48 98                	cltq   
    176e:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1772:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1776:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    177d:	66 66 66 
    1780:	48 89 c8             	mov    %rcx,%rax
    1783:	48 f7 ea             	imul   %rdx
    1786:	48 c1 fa 02          	sar    $0x2,%rdx
    178a:	48 89 c8             	mov    %rcx,%rax
    178d:	48 c1 f8 3f          	sar    $0x3f,%rax
    1791:	48 29 c2             	sub    %rax,%rdx
    1794:	48 89 d0             	mov    %rdx,%rax
    1797:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    179b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    17a0:	0f 85 7a ff ff ff    	jne    1720 <print_d+0x2c>

  if (v < 0)
    17a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17aa:	79 32                	jns    17de <print_d+0xea>
    buf[i++] = '-';
    17ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17af:	8d 50 01             	lea    0x1(%rax),%edx
    17b2:	89 55 f4             	mov    %edx,-0xc(%rbp)
    17b5:	48 98                	cltq   
    17b7:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    17bc:	eb 20                	jmp    17de <print_d+0xea>
    putc(fd, buf[i]);
    17be:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17c1:	48 98                	cltq   
    17c3:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    17c8:	0f be d0             	movsbl %al,%edx
    17cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17ce:	89 d6                	mov    %edx,%esi
    17d0:	89 c7                	mov    %eax,%edi
    17d2:	48 b8 06 16 00 00 00 	movabs $0x1606,%rax
    17d9:	00 00 00 
    17dc:	ff d0                	callq  *%rax
  while (--i >= 0)
    17de:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17e6:	79 d6                	jns    17be <print_d+0xca>
}
    17e8:	90                   	nop
    17e9:	90                   	nop
    17ea:	c9                   	leaveq 
    17eb:	c3                   	retq   

00000000000017ec <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    17ec:	f3 0f 1e fa          	endbr64 
    17f0:	55                   	push   %rbp
    17f1:	48 89 e5             	mov    %rsp,%rbp
    17f4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    17fb:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1801:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1808:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    180f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1816:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    181d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1824:	84 c0                	test   %al,%al
    1826:	74 20                	je     1848 <printf+0x5c>
    1828:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    182c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1830:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1834:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1838:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    183c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1840:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1844:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1848:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    184f:	00 00 00 
    1852:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1859:	00 00 00 
    185c:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1860:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1867:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    186e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1875:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    187c:	00 00 00 
    187f:	e9 41 03 00 00       	jmpq   1bc5 <printf+0x3d9>
    if (c != '%') {
    1884:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    188b:	74 24                	je     18b1 <printf+0xc5>
      putc(fd, c);
    188d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1893:	0f be d0             	movsbl %al,%edx
    1896:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    189c:	89 d6                	mov    %edx,%esi
    189e:	89 c7                	mov    %eax,%edi
    18a0:	48 b8 06 16 00 00 00 	movabs $0x1606,%rax
    18a7:	00 00 00 
    18aa:	ff d0                	callq  *%rax
      continue;
    18ac:	e9 0d 03 00 00       	jmpq   1bbe <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    18b1:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    18b8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    18be:	48 63 d0             	movslq %eax,%rdx
    18c1:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    18c8:	48 01 d0             	add    %rdx,%rax
    18cb:	0f b6 00             	movzbl (%rax),%eax
    18ce:	0f be c0             	movsbl %al,%eax
    18d1:	25 ff 00 00 00       	and    $0xff,%eax
    18d6:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18dc:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18e3:	0f 84 0f 03 00 00    	je     1bf8 <printf+0x40c>
      break;
    switch(c) {
    18e9:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18f0:	0f 84 74 02 00 00    	je     1b6a <printf+0x37e>
    18f6:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18fd:	0f 8c 82 02 00 00    	jl     1b85 <printf+0x399>
    1903:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    190a:	0f 8f 75 02 00 00    	jg     1b85 <printf+0x399>
    1910:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1917:	0f 8c 68 02 00 00    	jl     1b85 <printf+0x399>
    191d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1923:	83 e8 63             	sub    $0x63,%eax
    1926:	83 f8 15             	cmp    $0x15,%eax
    1929:	0f 87 56 02 00 00    	ja     1b85 <printf+0x399>
    192f:	89 c0                	mov    %eax,%eax
    1931:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1938:	00 
    1939:	48 b8 38 23 00 00 00 	movabs $0x2338,%rax
    1940:	00 00 00 
    1943:	48 01 d0             	add    %rdx,%rax
    1946:	48 8b 00             	mov    (%rax),%rax
    1949:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    194c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1952:	83 f8 2f             	cmp    $0x2f,%eax
    1955:	77 23                	ja     197a <printf+0x18e>
    1957:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    195e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1964:	89 d2                	mov    %edx,%edx
    1966:	48 01 d0             	add    %rdx,%rax
    1969:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    196f:	83 c2 08             	add    $0x8,%edx
    1972:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1978:	eb 12                	jmp    198c <printf+0x1a0>
    197a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1981:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1985:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    198c:	8b 00                	mov    (%rax),%eax
    198e:	0f be d0             	movsbl %al,%edx
    1991:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1997:	89 d6                	mov    %edx,%esi
    1999:	89 c7                	mov    %eax,%edi
    199b:	48 b8 06 16 00 00 00 	movabs $0x1606,%rax
    19a2:	00 00 00 
    19a5:	ff d0                	callq  *%rax
      break;
    19a7:	e9 12 02 00 00       	jmpq   1bbe <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    19ac:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19b2:	83 f8 2f             	cmp    $0x2f,%eax
    19b5:	77 23                	ja     19da <printf+0x1ee>
    19b7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19be:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19c4:	89 d2                	mov    %edx,%edx
    19c6:	48 01 d0             	add    %rdx,%rax
    19c9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19cf:	83 c2 08             	add    $0x8,%edx
    19d2:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19d8:	eb 12                	jmp    19ec <printf+0x200>
    19da:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19e1:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19e5:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19ec:	8b 10                	mov    (%rax),%edx
    19ee:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19f4:	89 d6                	mov    %edx,%esi
    19f6:	89 c7                	mov    %eax,%edi
    19f8:	48 b8 f4 16 00 00 00 	movabs $0x16f4,%rax
    19ff:	00 00 00 
    1a02:	ff d0                	callq  *%rax
      break;
    1a04:	e9 b5 01 00 00       	jmpq   1bbe <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1a09:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a0f:	83 f8 2f             	cmp    $0x2f,%eax
    1a12:	77 23                	ja     1a37 <printf+0x24b>
    1a14:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a1b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a21:	89 d2                	mov    %edx,%edx
    1a23:	48 01 d0             	add    %rdx,%rax
    1a26:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a2c:	83 c2 08             	add    $0x8,%edx
    1a2f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a35:	eb 12                	jmp    1a49 <printf+0x25d>
    1a37:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a3e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a42:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a49:	8b 10                	mov    (%rax),%edx
    1a4b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a51:	89 d6                	mov    %edx,%esi
    1a53:	89 c7                	mov    %eax,%edi
    1a55:	48 b8 97 16 00 00 00 	movabs $0x1697,%rax
    1a5c:	00 00 00 
    1a5f:	ff d0                	callq  *%rax
      break;
    1a61:	e9 58 01 00 00       	jmpq   1bbe <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a66:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a6c:	83 f8 2f             	cmp    $0x2f,%eax
    1a6f:	77 23                	ja     1a94 <printf+0x2a8>
    1a71:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a78:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a7e:	89 d2                	mov    %edx,%edx
    1a80:	48 01 d0             	add    %rdx,%rax
    1a83:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a89:	83 c2 08             	add    $0x8,%edx
    1a8c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a92:	eb 12                	jmp    1aa6 <printf+0x2ba>
    1a94:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a9b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a9f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1aa6:	48 8b 10             	mov    (%rax),%rdx
    1aa9:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aaf:	48 89 d6             	mov    %rdx,%rsi
    1ab2:	89 c7                	mov    %eax,%edi
    1ab4:	48 b8 3a 16 00 00 00 	movabs $0x163a,%rax
    1abb:	00 00 00 
    1abe:	ff d0                	callq  *%rax
      break;
    1ac0:	e9 f9 00 00 00       	jmpq   1bbe <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1ac5:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1acb:	83 f8 2f             	cmp    $0x2f,%eax
    1ace:	77 23                	ja     1af3 <printf+0x307>
    1ad0:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ad7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1add:	89 d2                	mov    %edx,%edx
    1adf:	48 01 d0             	add    %rdx,%rax
    1ae2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ae8:	83 c2 08             	add    $0x8,%edx
    1aeb:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1af1:	eb 12                	jmp    1b05 <printf+0x319>
    1af3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1afa:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1afe:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b05:	48 8b 00             	mov    (%rax),%rax
    1b08:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1b0f:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b16:	00 
    1b17:	75 41                	jne    1b5a <printf+0x36e>
        s = "(null)";
    1b19:	48 b8 30 23 00 00 00 	movabs $0x2330,%rax
    1b20:	00 00 00 
    1b23:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b2a:	eb 2e                	jmp    1b5a <printf+0x36e>
        putc(fd, *(s++));
    1b2c:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b33:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b37:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b3e:	0f b6 00             	movzbl (%rax),%eax
    1b41:	0f be d0             	movsbl %al,%edx
    1b44:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b4a:	89 d6                	mov    %edx,%esi
    1b4c:	89 c7                	mov    %eax,%edi
    1b4e:	48 b8 06 16 00 00 00 	movabs $0x1606,%rax
    1b55:	00 00 00 
    1b58:	ff d0                	callq  *%rax
      while (*s)
    1b5a:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b61:	0f b6 00             	movzbl (%rax),%eax
    1b64:	84 c0                	test   %al,%al
    1b66:	75 c4                	jne    1b2c <printf+0x340>
      break;
    1b68:	eb 54                	jmp    1bbe <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b6a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b70:	be 25 00 00 00       	mov    $0x25,%esi
    1b75:	89 c7                	mov    %eax,%edi
    1b77:	48 b8 06 16 00 00 00 	movabs $0x1606,%rax
    1b7e:	00 00 00 
    1b81:	ff d0                	callq  *%rax
      break;
    1b83:	eb 39                	jmp    1bbe <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b85:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b8b:	be 25 00 00 00       	mov    $0x25,%esi
    1b90:	89 c7                	mov    %eax,%edi
    1b92:	48 b8 06 16 00 00 00 	movabs $0x1606,%rax
    1b99:	00 00 00 
    1b9c:	ff d0                	callq  *%rax
      putc(fd, c);
    1b9e:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1ba4:	0f be d0             	movsbl %al,%edx
    1ba7:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bad:	89 d6                	mov    %edx,%esi
    1baf:	89 c7                	mov    %eax,%edi
    1bb1:	48 b8 06 16 00 00 00 	movabs $0x1606,%rax
    1bb8:	00 00 00 
    1bbb:	ff d0                	callq  *%rax
      break;
    1bbd:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1bbe:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1bc5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1bcb:	48 63 d0             	movslq %eax,%rdx
    1bce:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bd5:	48 01 d0             	add    %rdx,%rax
    1bd8:	0f b6 00             	movzbl (%rax),%eax
    1bdb:	0f be c0             	movsbl %al,%eax
    1bde:	25 ff 00 00 00       	and    $0xff,%eax
    1be3:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1be9:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bf0:	0f 85 8e fc ff ff    	jne    1884 <printf+0x98>
    }
  }
}
    1bf6:	eb 01                	jmp    1bf9 <printf+0x40d>
      break;
    1bf8:	90                   	nop
}
    1bf9:	90                   	nop
    1bfa:	c9                   	leaveq 
    1bfb:	c3                   	retq   

0000000000001bfc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1bfc:	f3 0f 1e fa          	endbr64 
    1c00:	55                   	push   %rbp
    1c01:	48 89 e5             	mov    %rsp,%rbp
    1c04:	48 83 ec 18          	sub    $0x18,%rsp
    1c08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c10:	48 83 e8 10          	sub    $0x10,%rax
    1c14:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c18:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    1c1f:	00 00 00 
    1c22:	48 8b 00             	mov    (%rax),%rax
    1c25:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c29:	eb 2f                	jmp    1c5a <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c2f:	48 8b 00             	mov    (%rax),%rax
    1c32:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c36:	72 17                	jb     1c4f <free+0x53>
    1c38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c3c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c40:	77 2f                	ja     1c71 <free+0x75>
    1c42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c46:	48 8b 00             	mov    (%rax),%rax
    1c49:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c4d:	72 22                	jb     1c71 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c53:	48 8b 00             	mov    (%rax),%rax
    1c56:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c5e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c62:	76 c7                	jbe    1c2b <free+0x2f>
    1c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c68:	48 8b 00             	mov    (%rax),%rax
    1c6b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c6f:	73 ba                	jae    1c2b <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c75:	8b 40 08             	mov    0x8(%rax),%eax
    1c78:	89 c0                	mov    %eax,%eax
    1c7a:	48 c1 e0 04          	shl    $0x4,%rax
    1c7e:	48 89 c2             	mov    %rax,%rdx
    1c81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c85:	48 01 c2             	add    %rax,%rdx
    1c88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c8c:	48 8b 00             	mov    (%rax),%rax
    1c8f:	48 39 c2             	cmp    %rax,%rdx
    1c92:	75 2d                	jne    1cc1 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1c94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c98:	8b 50 08             	mov    0x8(%rax),%edx
    1c9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c9f:	48 8b 00             	mov    (%rax),%rax
    1ca2:	8b 40 08             	mov    0x8(%rax),%eax
    1ca5:	01 c2                	add    %eax,%edx
    1ca7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cab:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb2:	48 8b 00             	mov    (%rax),%rax
    1cb5:	48 8b 10             	mov    (%rax),%rdx
    1cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cbc:	48 89 10             	mov    %rdx,(%rax)
    1cbf:	eb 0e                	jmp    1ccf <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1cc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc5:	48 8b 10             	mov    (%rax),%rdx
    1cc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ccc:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1ccf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cd3:	8b 40 08             	mov    0x8(%rax),%eax
    1cd6:	89 c0                	mov    %eax,%eax
    1cd8:	48 c1 e0 04          	shl    $0x4,%rax
    1cdc:	48 89 c2             	mov    %rax,%rdx
    1cdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ce3:	48 01 d0             	add    %rdx,%rax
    1ce6:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cea:	75 27                	jne    1d13 <free+0x117>
    p->s.size += bp->s.size;
    1cec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf0:	8b 50 08             	mov    0x8(%rax),%edx
    1cf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cf7:	8b 40 08             	mov    0x8(%rax),%eax
    1cfa:	01 c2                	add    %eax,%edx
    1cfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d00:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d07:	48 8b 10             	mov    (%rax),%rdx
    1d0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d0e:	48 89 10             	mov    %rdx,(%rax)
    1d11:	eb 0b                	jmp    1d1e <free+0x122>
  } else
    p->s.ptr = bp;
    1d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1d1b:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1d1e:	48 ba 50 27 00 00 00 	movabs $0x2750,%rdx
    1d25:	00 00 00 
    1d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2c:	48 89 02             	mov    %rax,(%rdx)
}
    1d2f:	90                   	nop
    1d30:	c9                   	leaveq 
    1d31:	c3                   	retq   

0000000000001d32 <morecore>:

static Header*
morecore(uint nu)
{
    1d32:	f3 0f 1e fa          	endbr64 
    1d36:	55                   	push   %rbp
    1d37:	48 89 e5             	mov    %rsp,%rbp
    1d3a:	48 83 ec 20          	sub    $0x20,%rsp
    1d3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d41:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d48:	77 07                	ja     1d51 <morecore+0x1f>
    nu = 4096;
    1d4a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d51:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d54:	48 c1 e0 04          	shl    $0x4,%rax
    1d58:	48 89 c7             	mov    %rax,%rdi
    1d5b:	48 b8 df 15 00 00 00 	movabs $0x15df,%rax
    1d62:	00 00 00 
    1d65:	ff d0                	callq  *%rax
    1d67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d6b:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d70:	75 07                	jne    1d79 <morecore+0x47>
    return 0;
    1d72:	b8 00 00 00 00       	mov    $0x0,%eax
    1d77:	eb 36                	jmp    1daf <morecore+0x7d>
  hp = (Header*)p;
    1d79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d85:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d88:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d8f:	48 83 c0 10          	add    $0x10,%rax
    1d93:	48 89 c7             	mov    %rax,%rdi
    1d96:	48 b8 fc 1b 00 00 00 	movabs $0x1bfc,%rax
    1d9d:	00 00 00 
    1da0:	ff d0                	callq  *%rax
  return freep;
    1da2:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    1da9:	00 00 00 
    1dac:	48 8b 00             	mov    (%rax),%rax
}
    1daf:	c9                   	leaveq 
    1db0:	c3                   	retq   

0000000000001db1 <malloc>:

void*
malloc(uint nbytes)
{
    1db1:	f3 0f 1e fa          	endbr64 
    1db5:	55                   	push   %rbp
    1db6:	48 89 e5             	mov    %rsp,%rbp
    1db9:	48 83 ec 30          	sub    $0x30,%rsp
    1dbd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1dc0:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1dc3:	48 83 c0 0f          	add    $0xf,%rax
    1dc7:	48 c1 e8 04          	shr    $0x4,%rax
    1dcb:	83 c0 01             	add    $0x1,%eax
    1dce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1dd1:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    1dd8:	00 00 00 
    1ddb:	48 8b 00             	mov    (%rax),%rax
    1dde:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1de2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1de7:	75 4a                	jne    1e33 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1de9:	48 b8 40 27 00 00 00 	movabs $0x2740,%rax
    1df0:	00 00 00 
    1df3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1df7:	48 ba 50 27 00 00 00 	movabs $0x2750,%rdx
    1dfe:	00 00 00 
    1e01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e05:	48 89 02             	mov    %rax,(%rdx)
    1e08:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    1e0f:	00 00 00 
    1e12:	48 8b 00             	mov    (%rax),%rax
    1e15:	48 ba 40 27 00 00 00 	movabs $0x2740,%rdx
    1e1c:	00 00 00 
    1e1f:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1e22:	48 b8 40 27 00 00 00 	movabs $0x2740,%rax
    1e29:	00 00 00 
    1e2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e37:	48 8b 00             	mov    (%rax),%rax
    1e3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e42:	8b 40 08             	mov    0x8(%rax),%eax
    1e45:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e48:	77 65                	ja     1eaf <malloc+0xfe>
      if(p->s.size == nunits)
    1e4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e4e:	8b 40 08             	mov    0x8(%rax),%eax
    1e51:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e54:	75 10                	jne    1e66 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1e56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e5a:	48 8b 10             	mov    (%rax),%rdx
    1e5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e61:	48 89 10             	mov    %rdx,(%rax)
    1e64:	eb 2e                	jmp    1e94 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e6a:	8b 40 08             	mov    0x8(%rax),%eax
    1e6d:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e70:	89 c2                	mov    %eax,%edx
    1e72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e76:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e7d:	8b 40 08             	mov    0x8(%rax),%eax
    1e80:	89 c0                	mov    %eax,%eax
    1e82:	48 c1 e0 04          	shl    $0x4,%rax
    1e86:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e8e:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e91:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e94:	48 ba 50 27 00 00 00 	movabs $0x2750,%rdx
    1e9b:	00 00 00 
    1e9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ea2:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1ea5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ea9:	48 83 c0 10          	add    $0x10,%rax
    1ead:	eb 4e                	jmp    1efd <malloc+0x14c>
    }
    if(p == freep)
    1eaf:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    1eb6:	00 00 00 
    1eb9:	48 8b 00             	mov    (%rax),%rax
    1ebc:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ec0:	75 23                	jne    1ee5 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1ec2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ec5:	89 c7                	mov    %eax,%edi
    1ec7:	48 b8 32 1d 00 00 00 	movabs $0x1d32,%rax
    1ece:	00 00 00 
    1ed1:	ff d0                	callq  *%rax
    1ed3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ed7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1edc:	75 07                	jne    1ee5 <malloc+0x134>
        return 0;
    1ede:	b8 00 00 00 00       	mov    $0x0,%eax
    1ee3:	eb 18                	jmp    1efd <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ee5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ee9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef1:	48 8b 00             	mov    (%rax),%rax
    1ef4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ef8:	e9 41 ff ff ff       	jmpq   1e3e <malloc+0x8d>
  }
}
    1efd:	c9                   	leaveq 
    1efe:	c3                   	retq   

0000000000001eff <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1eff:	f3 0f 1e fa          	endbr64 
    1f03:	55                   	push   %rbp
    1f04:	48 89 e5             	mov    %rsp,%rbp
    1f07:	48 83 ec 30          	sub    $0x30,%rsp
    1f0b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1f0f:	bf 18 00 00 00       	mov    $0x18,%edi
    1f14:	48 b8 b1 1d 00 00 00 	movabs $0x1db1,%rax
    1f1b:	00 00 00 
    1f1e:	ff d0                	callq  *%rax
    1f20:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1f24:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1f29:	75 0a                	jne    1f35 <co_new+0x36>
    return 0;
    1f2b:	b8 00 00 00 00       	mov    $0x0,%eax
    1f30:	e9 e1 00 00 00       	jmpq   2016 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1f35:	bf 00 20 00 00       	mov    $0x2000,%edi
    1f3a:	48 b8 b1 1d 00 00 00 	movabs $0x1db1,%rax
    1f41:	00 00 00 
    1f44:	ff d0                	callq  *%rax
    1f46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1f4a:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1f4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f52:	48 8b 40 10          	mov    0x10(%rax),%rax
    1f56:	48 85 c0             	test   %rax,%rax
    1f59:	75 1d                	jne    1f78 <co_new+0x79>
    free(co1);
    1f5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f5f:	48 89 c7             	mov    %rax,%rdi
    1f62:	48 b8 fc 1b 00 00 00 	movabs $0x1bfc,%rax
    1f69:	00 00 00 
    1f6c:	ff d0                	callq  *%rax
    return 0;
    1f6e:	b8 00 00 00 00       	mov    $0x0,%eax
    1f73:	e9 9e 00 00 00       	jmpq   2016 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1f78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f7c:	48 8b 40 10          	mov    0x10(%rax),%rax
    1f80:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    1f86:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    1f8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f8e:	48 8d 50 30          	lea    0x30(%rax),%rdx
    1f92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1f96:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    1f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f9d:	48 83 c0 38          	add    $0x38,%rax
    1fa1:	48 ba 88 21 00 00 00 	movabs $0x2188,%rdx
    1fa8:	00 00 00 
    1fab:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    1fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1fb6:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    1fb9:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    1fc0:	00 00 00 
    1fc3:	48 8b 00             	mov    (%rax),%rax
    1fc6:	48 85 c0             	test   %rax,%rax
    1fc9:	75 13                	jne    1fde <co_new+0xdf>
  {
  	co_list = co1;
    1fcb:	48 ba 68 27 00 00 00 	movabs $0x2768,%rdx
    1fd2:	00 00 00 
    1fd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fd9:	48 89 02             	mov    %rax,(%rdx)
    1fdc:	eb 34                	jmp    2012 <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    1fde:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    1fe5:	00 00 00 
    1fe8:	48 8b 00             	mov    (%rax),%rax
    1feb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1fef:	eb 0c                	jmp    1ffd <co_new+0xfe>
	{
		head = head->next;
    1ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ff5:	48 8b 40 08          	mov    0x8(%rax),%rax
    1ff9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1ffd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2001:	48 8b 40 08          	mov    0x8(%rax),%rax
    2005:	48 85 c0             	test   %rax,%rax
    2008:	75 e7                	jne    1ff1 <co_new+0xf2>
	}
	head = co1;
    200a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    200e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    2012:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    2016:	c9                   	leaveq 
    2017:	c3                   	retq   

0000000000002018 <co_run>:

  int
co_run(void)
{
    2018:	f3 0f 1e fa          	endbr64 
    201c:	55                   	push   %rbp
    201d:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    2020:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    2027:	00 00 00 
    202a:	48 8b 00             	mov    (%rax),%rax
    202d:	48 85 c0             	test   %rax,%rax
    2030:	74 4a                	je     207c <co_run+0x64>
	{
		co_current = co_list;
    2032:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    2039:	00 00 00 
    203c:	48 8b 00             	mov    (%rax),%rax
    203f:	48 ba 60 27 00 00 00 	movabs $0x2760,%rdx
    2046:	00 00 00 
    2049:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    204c:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    2053:	00 00 00 
    2056:	48 8b 00             	mov    (%rax),%rax
    2059:	48 8b 00             	mov    (%rax),%rax
    205c:	48 89 c6             	mov    %rax,%rsi
    205f:	48 bf 58 27 00 00 00 	movabs $0x2758,%rdi
    2066:	00 00 00 
    2069:	48 b8 ea 22 00 00 00 	movabs $0x22ea,%rax
    2070:	00 00 00 
    2073:	ff d0                	callq  *%rax
		return 1;
    2075:	b8 01 00 00 00       	mov    $0x1,%eax
    207a:	eb 05                	jmp    2081 <co_run+0x69>
	}
	return 0;
    207c:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2081:	5d                   	pop    %rbp
    2082:	c3                   	retq   

0000000000002083 <co_run_all>:

  int
co_run_all(void)
{
    2083:	f3 0f 1e fa          	endbr64 
    2087:	55                   	push   %rbp
    2088:	48 89 e5             	mov    %rsp,%rbp
    208b:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    208f:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    2096:	00 00 00 
    2099:	48 8b 00             	mov    (%rax),%rax
    209c:	48 85 c0             	test   %rax,%rax
    209f:	75 07                	jne    20a8 <co_run_all+0x25>
		return 0;
    20a1:	b8 00 00 00 00       	mov    $0x0,%eax
    20a6:	eb 37                	jmp    20df <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    20a8:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    20af:	00 00 00 
    20b2:	48 8b 00             	mov    (%rax),%rax
    20b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    20b9:	eb 18                	jmp    20d3 <co_run_all+0x50>
			co_run();
    20bb:	48 b8 18 20 00 00 00 	movabs $0x2018,%rax
    20c2:	00 00 00 
    20c5:	ff d0                	callq  *%rax
			tmp = tmp->next;
    20c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20cb:	48 8b 40 08          	mov    0x8(%rax),%rax
    20cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    20d3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    20d8:	75 e1                	jne    20bb <co_run_all+0x38>
		}
		return 1;
    20da:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    20df:	c9                   	leaveq 
    20e0:	c3                   	retq   

00000000000020e1 <co_yield>:

  void
co_yield()
{
    20e1:	f3 0f 1e fa          	endbr64 
    20e5:	55                   	push   %rbp
    20e6:	48 89 e5             	mov    %rsp,%rbp
    20e9:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    20ed:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    20f4:	00 00 00 
    20f7:	48 8b 00             	mov    (%rax),%rax
    20fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    20fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2102:	48 8b 40 08          	mov    0x8(%rax),%rax
    2106:	48 85 c0             	test   %rax,%rax
    2109:	74 46                	je     2151 <co_yield+0x70>
  {
  	co_current = co_current->next;
    210b:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    2112:	00 00 00 
    2115:	48 8b 00             	mov    (%rax),%rax
    2118:	48 8b 40 08          	mov    0x8(%rax),%rax
    211c:	48 ba 60 27 00 00 00 	movabs $0x2760,%rdx
    2123:	00 00 00 
    2126:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    2129:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    2130:	00 00 00 
    2133:	48 8b 00             	mov    (%rax),%rax
    2136:	48 8b 10             	mov    (%rax),%rdx
    2139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    213d:	48 89 d6             	mov    %rdx,%rsi
    2140:	48 89 c7             	mov    %rax,%rdi
    2143:	48 b8 ea 22 00 00 00 	movabs $0x22ea,%rax
    214a:	00 00 00 
    214d:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    214f:	eb 34                	jmp    2185 <co_yield+0xa4>
	co_current = 0;
    2151:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    2158:	00 00 00 
    215b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    2162:	48 b8 58 27 00 00 00 	movabs $0x2758,%rax
    2169:	00 00 00 
    216c:	48 8b 10             	mov    (%rax),%rdx
    216f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2173:	48 89 d6             	mov    %rdx,%rsi
    2176:	48 89 c7             	mov    %rax,%rdi
    2179:	48 b8 ea 22 00 00 00 	movabs $0x22ea,%rax
    2180:	00 00 00 
    2183:	ff d0                	callq  *%rax
}
    2185:	90                   	nop
    2186:	c9                   	leaveq 
    2187:	c3                   	retq   

0000000000002188 <co_exit>:

  void
co_exit(void)
{
    2188:	f3 0f 1e fa          	endbr64 
    218c:	55                   	push   %rbp
    218d:	48 89 e5             	mov    %rsp,%rbp
    2190:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    2194:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    219b:	00 00 00 
    219e:	48 8b 00             	mov    (%rax),%rax
    21a1:	48 85 c0             	test   %rax,%rax
    21a4:	0f 84 ec 00 00 00    	je     2296 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    21aa:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    21b1:	00 00 00 
    21b4:	48 8b 00             	mov    (%rax),%rax
    21b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    21bb:	e9 c9 00 00 00       	jmpq   2289 <co_exit+0x101>
		if(tmp == co_current)
    21c0:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    21c7:	00 00 00 
    21ca:	48 8b 00             	mov    (%rax),%rax
    21cd:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    21d1:	0f 85 9e 00 00 00    	jne    2275 <co_exit+0xed>
		{
			if(tmp->next)
    21d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21db:	48 8b 40 08          	mov    0x8(%rax),%rax
    21df:	48 85 c0             	test   %rax,%rax
    21e2:	74 54                	je     2238 <co_exit+0xb0>
			{
				if(prev)
    21e4:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    21e9:	74 10                	je     21fb <co_exit+0x73>
				{
					prev->next = tmp->next;
    21eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21ef:	48 8b 50 08          	mov    0x8(%rax),%rdx
    21f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    21f7:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    21fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21ff:	48 8b 40 08          	mov    0x8(%rax),%rax
    2203:	48 ba 68 27 00 00 00 	movabs $0x2768,%rdx
    220a:	00 00 00 
    220d:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    2210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2214:	48 8b 00             	mov    (%rax),%rax
    2217:	48 ba 60 27 00 00 00 	movabs $0x2760,%rdx
    221e:	00 00 00 
    2221:	48 8b 12             	mov    (%rdx),%rdx
    2224:	48 89 c6             	mov    %rax,%rsi
    2227:	48 89 d7             	mov    %rdx,%rdi
    222a:	48 b8 ea 22 00 00 00 	movabs $0x22ea,%rax
    2231:	00 00 00 
    2234:	ff d0                	callq  *%rax
    2236:	eb 3d                	jmp    2275 <co_exit+0xed>
			}else{
				co_list = 0;
    2238:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    223f:	00 00 00 
    2242:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    2249:	48 b8 58 27 00 00 00 	movabs $0x2758,%rax
    2250:	00 00 00 
    2253:	48 8b 00             	mov    (%rax),%rax
    2256:	48 ba 60 27 00 00 00 	movabs $0x2760,%rdx
    225d:	00 00 00 
    2260:	48 8b 12             	mov    (%rdx),%rdx
    2263:	48 89 c6             	mov    %rax,%rsi
    2266:	48 89 d7             	mov    %rdx,%rdi
    2269:	48 b8 ea 22 00 00 00 	movabs $0x22ea,%rax
    2270:	00 00 00 
    2273:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    2275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2279:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    227d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2281:	48 8b 40 08          	mov    0x8(%rax),%rax
    2285:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    2289:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    228e:	0f 85 2c ff ff ff    	jne    21c0 <co_exit+0x38>
    2294:	eb 01                	jmp    2297 <co_exit+0x10f>
		return;
    2296:	90                   	nop
	}
}
    2297:	c9                   	leaveq 
    2298:	c3                   	retq   

0000000000002299 <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    2299:	f3 0f 1e fa          	endbr64 
    229d:	55                   	push   %rbp
    229e:	48 89 e5             	mov    %rsp,%rbp
    22a1:	48 83 ec 10          	sub    $0x10,%rsp
    22a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    22a9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    22ae:	74 37                	je     22e7 <co_destroy+0x4e>
    if (co->stack)
    22b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22b4:	48 8b 40 10          	mov    0x10(%rax),%rax
    22b8:	48 85 c0             	test   %rax,%rax
    22bb:	74 17                	je     22d4 <co_destroy+0x3b>
      free(co->stack);
    22bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22c1:	48 8b 40 10          	mov    0x10(%rax),%rax
    22c5:	48 89 c7             	mov    %rax,%rdi
    22c8:	48 b8 fc 1b 00 00 00 	movabs $0x1bfc,%rax
    22cf:	00 00 00 
    22d2:	ff d0                	callq  *%rax
    free(co);
    22d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22d8:	48 89 c7             	mov    %rax,%rdi
    22db:	48 b8 fc 1b 00 00 00 	movabs $0x1bfc,%rax
    22e2:	00 00 00 
    22e5:	ff d0                	callq  *%rax
  }
}
    22e7:	90                   	nop
    22e8:	c9                   	leaveq 
    22e9:	c3                   	retq   

00000000000022ea <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    22ea:	55                   	push   %rbp
  pushq   %rbx
    22eb:	53                   	push   %rbx
  pushq   %r12
    22ec:	41 54                	push   %r12
  pushq   %r13
    22ee:	41 55                	push   %r13
  pushq   %r14
    22f0:	41 56                	push   %r14
  pushq   %r15
    22f2:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    22f4:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    22f7:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    22fa:	41 5f                	pop    %r15
  popq    %r14
    22fc:	41 5e                	pop    %r14
  popq    %r13
    22fe:	41 5d                	pop    %r13
  popq    %r12
    2300:	41 5c                	pop    %r12
  popq    %rbx
    2302:	5b                   	pop    %rbx
  popq    %rbp
    2303:	5d                   	pop    %rbp

  retq #??
    2304:	c3                   	retq   
