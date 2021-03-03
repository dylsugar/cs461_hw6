
_init:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 10          	sub    $0x10,%rsp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    100c:	be 02 00 00 00       	mov    $0x2,%esi
    1011:	48 bf cb 22 00 00 00 	movabs $0x22cb,%rdi
    1018:	00 00 00 
    101b:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    1022:	00 00 00 
    1025:	ff d0                	callq  *%rax
    1027:	85 c0                	test   %eax,%eax
    1029:	79 3b                	jns    1066 <main+0x66>
    mknod("console", 1, 1);
    102b:	ba 01 00 00 00       	mov    $0x1,%edx
    1030:	be 01 00 00 00       	mov    $0x1,%esi
    1035:	48 bf cb 22 00 00 00 	movabs $0x22cb,%rdi
    103c:	00 00 00 
    103f:	48 b8 39 15 00 00 00 	movabs $0x1539,%rax
    1046:	00 00 00 
    1049:	ff d0                	callq  *%rax
    open("console", O_RDWR);
    104b:	be 02 00 00 00       	mov    $0x2,%esi
    1050:	48 bf cb 22 00 00 00 	movabs $0x22cb,%rdi
    1057:	00 00 00 
    105a:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    1061:	00 00 00 
    1064:	ff d0                	callq  *%rax
  }
  dup(0);  // stdout
    1066:	bf 00 00 00 00       	mov    $0x0,%edi
    106b:	48 b8 87 15 00 00 00 	movabs $0x1587,%rax
    1072:	00 00 00 
    1075:	ff d0                	callq  *%rax
  dup(0);  // stderr
    1077:	bf 00 00 00 00       	mov    $0x0,%edi
    107c:	48 b8 87 15 00 00 00 	movabs $0x1587,%rax
    1083:	00 00 00 
    1086:	ff d0                	callq  *%rax

  for(;;){
    printf(1, "init: starting sh\n");
    1088:	48 be d3 22 00 00 00 	movabs $0x22d3,%rsi
    108f:	00 00 00 
    1092:	bf 01 00 00 00       	mov    $0x1,%edi
    1097:	b8 00 00 00 00       	mov    $0x0,%eax
    109c:	48 ba ae 17 00 00 00 	movabs $0x17ae,%rdx
    10a3:	00 00 00 
    10a6:	ff d2                	callq  *%rdx
    pid = fork();
    10a8:	48 b8 b7 14 00 00 00 	movabs $0x14b7,%rax
    10af:	00 00 00 
    10b2:	ff d0                	callq  *%rax
    10b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(pid < 0){
    10b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10bb:	79 2c                	jns    10e9 <main+0xe9>
      printf(1, "init: fork failed\n");
    10bd:	48 be e6 22 00 00 00 	movabs $0x22e6,%rsi
    10c4:	00 00 00 
    10c7:	bf 01 00 00 00       	mov    $0x1,%edi
    10cc:	b8 00 00 00 00       	mov    $0x0,%eax
    10d1:	48 ba ae 17 00 00 00 	movabs $0x17ae,%rdx
    10d8:	00 00 00 
    10db:	ff d2                	callq  *%rdx
      exit();
    10dd:	48 b8 c4 14 00 00 00 	movabs $0x14c4,%rax
    10e4:	00 00 00 
    10e7:	ff d0                	callq  *%rax
    }
    if(pid == 0){
    10e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    10ed:	75 6c                	jne    115b <main+0x15b>
      exec("sh", argv);
    10ef:	48 be 10 27 00 00 00 	movabs $0x2710,%rsi
    10f6:	00 00 00 
    10f9:	48 bf c8 22 00 00 00 	movabs $0x22c8,%rdi
    1100:	00 00 00 
    1103:	48 b8 1f 15 00 00 00 	movabs $0x151f,%rax
    110a:	00 00 00 
    110d:	ff d0                	callq  *%rax
      printf(1, "init: exec sh failed\n");
    110f:	48 be f9 22 00 00 00 	movabs $0x22f9,%rsi
    1116:	00 00 00 
    1119:	bf 01 00 00 00       	mov    $0x1,%edi
    111e:	b8 00 00 00 00       	mov    $0x0,%eax
    1123:	48 ba ae 17 00 00 00 	movabs $0x17ae,%rdx
    112a:	00 00 00 
    112d:	ff d2                	callq  *%rdx
      exit();
    112f:	48 b8 c4 14 00 00 00 	movabs $0x14c4,%rax
    1136:	00 00 00 
    1139:	ff d0                	callq  *%rax
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
    113b:	48 be 0f 23 00 00 00 	movabs $0x230f,%rsi
    1142:	00 00 00 
    1145:	bf 01 00 00 00       	mov    $0x1,%edi
    114a:	b8 00 00 00 00       	mov    $0x0,%eax
    114f:	48 ba ae 17 00 00 00 	movabs $0x17ae,%rdx
    1156:	00 00 00 
    1159:	ff d2                	callq  *%rdx
    while((wpid=wait()) >= 0 && wpid != pid)
    115b:	48 b8 d1 14 00 00 00 	movabs $0x14d1,%rax
    1162:	00 00 00 
    1165:	ff d0                	callq  *%rax
    1167:	89 45 f8             	mov    %eax,-0x8(%rbp)
    116a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    116e:	0f 88 14 ff ff ff    	js     1088 <main+0x88>
    1174:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1177:	3b 45 fc             	cmp    -0x4(%rbp),%eax
    117a:	75 bf                	jne    113b <main+0x13b>
    printf(1, "init: starting sh\n");
    117c:	e9 07 ff ff ff       	jmpq   1088 <main+0x88>

0000000000001181 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1181:	f3 0f 1e fa          	endbr64 
    1185:	55                   	push   %rbp
    1186:	48 89 e5             	mov    %rsp,%rbp
    1189:	48 83 ec 10          	sub    $0x10,%rsp
    118d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1191:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1194:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1197:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    119b:	8b 55 f0             	mov    -0x10(%rbp),%edx
    119e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11a1:	48 89 ce             	mov    %rcx,%rsi
    11a4:	48 89 f7             	mov    %rsi,%rdi
    11a7:	89 d1                	mov    %edx,%ecx
    11a9:	fc                   	cld    
    11aa:	f3 aa                	rep stos %al,%es:(%rdi)
    11ac:	89 ca                	mov    %ecx,%edx
    11ae:	48 89 fe             	mov    %rdi,%rsi
    11b1:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11b5:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11b8:	90                   	nop
    11b9:	c9                   	leaveq 
    11ba:	c3                   	retq   

00000000000011bb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11bb:	f3 0f 1e fa          	endbr64 
    11bf:	55                   	push   %rbp
    11c0:	48 89 e5             	mov    %rsp,%rbp
    11c3:	48 83 ec 20          	sub    $0x20,%rsp
    11c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    11cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    11d7:	90                   	nop
    11d8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    11dc:	48 8d 42 01          	lea    0x1(%rdx),%rax
    11e0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    11e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11e8:	48 8d 48 01          	lea    0x1(%rax),%rcx
    11ec:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    11f0:	0f b6 12             	movzbl (%rdx),%edx
    11f3:	88 10                	mov    %dl,(%rax)
    11f5:	0f b6 00             	movzbl (%rax),%eax
    11f8:	84 c0                	test   %al,%al
    11fa:	75 dc                	jne    11d8 <strcpy+0x1d>
    ;
  return os;
    11fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1200:	c9                   	leaveq 
    1201:	c3                   	retq   

0000000000001202 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1202:	f3 0f 1e fa          	endbr64 
    1206:	55                   	push   %rbp
    1207:	48 89 e5             	mov    %rsp,%rbp
    120a:	48 83 ec 10          	sub    $0x10,%rsp
    120e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1212:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1216:	eb 0a                	jmp    1222 <strcmp+0x20>
    p++, q++;
    1218:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    121d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1226:	0f b6 00             	movzbl (%rax),%eax
    1229:	84 c0                	test   %al,%al
    122b:	74 12                	je     123f <strcmp+0x3d>
    122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1231:	0f b6 10             	movzbl (%rax),%edx
    1234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1238:	0f b6 00             	movzbl (%rax),%eax
    123b:	38 c2                	cmp    %al,%dl
    123d:	74 d9                	je     1218 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1243:	0f b6 00             	movzbl (%rax),%eax
    1246:	0f b6 d0             	movzbl %al,%edx
    1249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    124d:	0f b6 00             	movzbl (%rax),%eax
    1250:	0f b6 c0             	movzbl %al,%eax
    1253:	29 c2                	sub    %eax,%edx
    1255:	89 d0                	mov    %edx,%eax
}
    1257:	c9                   	leaveq 
    1258:	c3                   	retq   

0000000000001259 <strlen>:

uint
strlen(char *s)
{
    1259:	f3 0f 1e fa          	endbr64 
    125d:	55                   	push   %rbp
    125e:	48 89 e5             	mov    %rsp,%rbp
    1261:	48 83 ec 18          	sub    $0x18,%rsp
    1265:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1270:	eb 04                	jmp    1276 <strlen+0x1d>
    1272:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1276:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1279:	48 63 d0             	movslq %eax,%rdx
    127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1280:	48 01 d0             	add    %rdx,%rax
    1283:	0f b6 00             	movzbl (%rax),%eax
    1286:	84 c0                	test   %al,%al
    1288:	75 e8                	jne    1272 <strlen+0x19>
    ;
  return n;
    128a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    128d:	c9                   	leaveq 
    128e:	c3                   	retq   

000000000000128f <memset>:

void*
memset(void *dst, int c, uint n)
{
    128f:	f3 0f 1e fa          	endbr64 
    1293:	55                   	push   %rbp
    1294:	48 89 e5             	mov    %rsp,%rbp
    1297:	48 83 ec 10          	sub    $0x10,%rsp
    129b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    129f:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12a2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12a5:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12a8:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12af:	89 ce                	mov    %ecx,%esi
    12b1:	48 89 c7             	mov    %rax,%rdi
    12b4:	48 b8 81 11 00 00 00 	movabs $0x1181,%rax
    12bb:	00 00 00 
    12be:	ff d0                	callq  *%rax
  return dst;
    12c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12c4:	c9                   	leaveq 
    12c5:	c3                   	retq   

00000000000012c6 <strchr>:

char*
strchr(const char *s, char c)
{
    12c6:	f3 0f 1e fa          	endbr64 
    12ca:	55                   	push   %rbp
    12cb:	48 89 e5             	mov    %rsp,%rbp
    12ce:	48 83 ec 10          	sub    $0x10,%rsp
    12d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12d6:	89 f0                	mov    %esi,%eax
    12d8:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    12db:	eb 17                	jmp    12f4 <strchr+0x2e>
    if(*s == c)
    12dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12e1:	0f b6 00             	movzbl (%rax),%eax
    12e4:	38 45 f4             	cmp    %al,-0xc(%rbp)
    12e7:	75 06                	jne    12ef <strchr+0x29>
      return (char*)s;
    12e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ed:	eb 15                	jmp    1304 <strchr+0x3e>
  for(; *s; s++)
    12ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12f8:	0f b6 00             	movzbl (%rax),%eax
    12fb:	84 c0                	test   %al,%al
    12fd:	75 de                	jne    12dd <strchr+0x17>
  return 0;
    12ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1304:	c9                   	leaveq 
    1305:	c3                   	retq   

0000000000001306 <gets>:

char*
gets(char *buf, int max)
{
    1306:	f3 0f 1e fa          	endbr64 
    130a:	55                   	push   %rbp
    130b:	48 89 e5             	mov    %rsp,%rbp
    130e:	48 83 ec 20          	sub    $0x20,%rsp
    1312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1316:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1319:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1320:	eb 4f                	jmp    1371 <gets+0x6b>
    cc = read(0, &c, 1);
    1322:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1326:	ba 01 00 00 00       	mov    $0x1,%edx
    132b:	48 89 c6             	mov    %rax,%rsi
    132e:	bf 00 00 00 00       	mov    $0x0,%edi
    1333:	48 b8 eb 14 00 00 00 	movabs $0x14eb,%rax
    133a:	00 00 00 
    133d:	ff d0                	callq  *%rax
    133f:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1342:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1346:	7e 36                	jle    137e <gets+0x78>
      break;
    buf[i++] = c;
    1348:	8b 45 fc             	mov    -0x4(%rbp),%eax
    134b:	8d 50 01             	lea    0x1(%rax),%edx
    134e:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1351:	48 63 d0             	movslq %eax,%rdx
    1354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1358:	48 01 c2             	add    %rax,%rdx
    135b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    135f:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1361:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1365:	3c 0a                	cmp    $0xa,%al
    1367:	74 16                	je     137f <gets+0x79>
    1369:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    136d:	3c 0d                	cmp    $0xd,%al
    136f:	74 0e                	je     137f <gets+0x79>
  for(i=0; i+1 < max; ){
    1371:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1374:	83 c0 01             	add    $0x1,%eax
    1377:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    137a:	7f a6                	jg     1322 <gets+0x1c>
    137c:	eb 01                	jmp    137f <gets+0x79>
      break;
    137e:	90                   	nop
      break;
  }
  buf[i] = '\0';
    137f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1382:	48 63 d0             	movslq %eax,%rdx
    1385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1389:	48 01 d0             	add    %rdx,%rax
    138c:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    138f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1393:	c9                   	leaveq 
    1394:	c3                   	retq   

0000000000001395 <stat>:

int
stat(char *n, struct stat *st)
{
    1395:	f3 0f 1e fa          	endbr64 
    1399:	55                   	push   %rbp
    139a:	48 89 e5             	mov    %rsp,%rbp
    139d:	48 83 ec 20          	sub    $0x20,%rsp
    13a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13ad:	be 00 00 00 00       	mov    $0x0,%esi
    13b2:	48 89 c7             	mov    %rax,%rdi
    13b5:	48 b8 2c 15 00 00 00 	movabs $0x152c,%rax
    13bc:	00 00 00 
    13bf:	ff d0                	callq  *%rax
    13c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    13c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    13c8:	79 07                	jns    13d1 <stat+0x3c>
    return -1;
    13ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13cf:	eb 2f                	jmp    1400 <stat+0x6b>
  r = fstat(fd, st);
    13d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    13d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13d8:	48 89 d6             	mov    %rdx,%rsi
    13db:	89 c7                	mov    %eax,%edi
    13dd:	48 b8 53 15 00 00 00 	movabs $0x1553,%rax
    13e4:	00 00 00 
    13e7:	ff d0                	callq  *%rax
    13e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    13ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13ef:	89 c7                	mov    %eax,%edi
    13f1:	48 b8 05 15 00 00 00 	movabs $0x1505,%rax
    13f8:	00 00 00 
    13fb:	ff d0                	callq  *%rax
  return r;
    13fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1400:	c9                   	leaveq 
    1401:	c3                   	retq   

0000000000001402 <atoi>:

int
atoi(const char *s)
{
    1402:	f3 0f 1e fa          	endbr64 
    1406:	55                   	push   %rbp
    1407:	48 89 e5             	mov    %rsp,%rbp
    140a:	48 83 ec 18          	sub    $0x18,%rsp
    140e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1412:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1419:	eb 28                	jmp    1443 <atoi+0x41>
    n = n*10 + *s++ - '0';
    141b:	8b 55 fc             	mov    -0x4(%rbp),%edx
    141e:	89 d0                	mov    %edx,%eax
    1420:	c1 e0 02             	shl    $0x2,%eax
    1423:	01 d0                	add    %edx,%eax
    1425:	01 c0                	add    %eax,%eax
    1427:	89 c1                	mov    %eax,%ecx
    1429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    142d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1431:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1435:	0f b6 00             	movzbl (%rax),%eax
    1438:	0f be c0             	movsbl %al,%eax
    143b:	01 c8                	add    %ecx,%eax
    143d:	83 e8 30             	sub    $0x30,%eax
    1440:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1447:	0f b6 00             	movzbl (%rax),%eax
    144a:	3c 2f                	cmp    $0x2f,%al
    144c:	7e 0b                	jle    1459 <atoi+0x57>
    144e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1452:	0f b6 00             	movzbl (%rax),%eax
    1455:	3c 39                	cmp    $0x39,%al
    1457:	7e c2                	jle    141b <atoi+0x19>
  return n;
    1459:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    145c:	c9                   	leaveq 
    145d:	c3                   	retq   

000000000000145e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    145e:	f3 0f 1e fa          	endbr64 
    1462:	55                   	push   %rbp
    1463:	48 89 e5             	mov    %rsp,%rbp
    1466:	48 83 ec 28          	sub    $0x28,%rsp
    146a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    146e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1472:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1479:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    147d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1481:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1485:	eb 1d                	jmp    14a4 <memmove+0x46>
    *dst++ = *src++;
    1487:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    148b:	48 8d 42 01          	lea    0x1(%rdx),%rax
    148f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1497:	48 8d 48 01          	lea    0x1(%rax),%rcx
    149b:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    149f:	0f b6 12             	movzbl (%rdx),%edx
    14a2:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14a7:	8d 50 ff             	lea    -0x1(%rax),%edx
    14aa:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14ad:	85 c0                	test   %eax,%eax
    14af:	7f d6                	jg     1487 <memmove+0x29>
  return vdst;
    14b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14b5:	c9                   	leaveq 
    14b6:	c3                   	retq   

00000000000014b7 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14b7:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14be:	49 89 ca             	mov    %rcx,%r10
    14c1:	0f 05                	syscall 
    14c3:	c3                   	retq   

00000000000014c4 <exit>:
SYSCALL(exit)
    14c4:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    14cb:	49 89 ca             	mov    %rcx,%r10
    14ce:	0f 05                	syscall 
    14d0:	c3                   	retq   

00000000000014d1 <wait>:
SYSCALL(wait)
    14d1:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    14d8:	49 89 ca             	mov    %rcx,%r10
    14db:	0f 05                	syscall 
    14dd:	c3                   	retq   

00000000000014de <pipe>:
SYSCALL(pipe)
    14de:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    14e5:	49 89 ca             	mov    %rcx,%r10
    14e8:	0f 05                	syscall 
    14ea:	c3                   	retq   

00000000000014eb <read>:
SYSCALL(read)
    14eb:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    14f2:	49 89 ca             	mov    %rcx,%r10
    14f5:	0f 05                	syscall 
    14f7:	c3                   	retq   

00000000000014f8 <write>:
SYSCALL(write)
    14f8:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    14ff:	49 89 ca             	mov    %rcx,%r10
    1502:	0f 05                	syscall 
    1504:	c3                   	retq   

0000000000001505 <close>:
SYSCALL(close)
    1505:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    150c:	49 89 ca             	mov    %rcx,%r10
    150f:	0f 05                	syscall 
    1511:	c3                   	retq   

0000000000001512 <kill>:
SYSCALL(kill)
    1512:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1519:	49 89 ca             	mov    %rcx,%r10
    151c:	0f 05                	syscall 
    151e:	c3                   	retq   

000000000000151f <exec>:
SYSCALL(exec)
    151f:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1526:	49 89 ca             	mov    %rcx,%r10
    1529:	0f 05                	syscall 
    152b:	c3                   	retq   

000000000000152c <open>:
SYSCALL(open)
    152c:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1533:	49 89 ca             	mov    %rcx,%r10
    1536:	0f 05                	syscall 
    1538:	c3                   	retq   

0000000000001539 <mknod>:
SYSCALL(mknod)
    1539:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1540:	49 89 ca             	mov    %rcx,%r10
    1543:	0f 05                	syscall 
    1545:	c3                   	retq   

0000000000001546 <unlink>:
SYSCALL(unlink)
    1546:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    154d:	49 89 ca             	mov    %rcx,%r10
    1550:	0f 05                	syscall 
    1552:	c3                   	retq   

0000000000001553 <fstat>:
SYSCALL(fstat)
    1553:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    155a:	49 89 ca             	mov    %rcx,%r10
    155d:	0f 05                	syscall 
    155f:	c3                   	retq   

0000000000001560 <link>:
SYSCALL(link)
    1560:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1567:	49 89 ca             	mov    %rcx,%r10
    156a:	0f 05                	syscall 
    156c:	c3                   	retq   

000000000000156d <mkdir>:
SYSCALL(mkdir)
    156d:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1574:	49 89 ca             	mov    %rcx,%r10
    1577:	0f 05                	syscall 
    1579:	c3                   	retq   

000000000000157a <chdir>:
SYSCALL(chdir)
    157a:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1581:	49 89 ca             	mov    %rcx,%r10
    1584:	0f 05                	syscall 
    1586:	c3                   	retq   

0000000000001587 <dup>:
SYSCALL(dup)
    1587:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    158e:	49 89 ca             	mov    %rcx,%r10
    1591:	0f 05                	syscall 
    1593:	c3                   	retq   

0000000000001594 <getpid>:
SYSCALL(getpid)
    1594:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    159b:	49 89 ca             	mov    %rcx,%r10
    159e:	0f 05                	syscall 
    15a0:	c3                   	retq   

00000000000015a1 <sbrk>:
SYSCALL(sbrk)
    15a1:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15a8:	49 89 ca             	mov    %rcx,%r10
    15ab:	0f 05                	syscall 
    15ad:	c3                   	retq   

00000000000015ae <sleep>:
SYSCALL(sleep)
    15ae:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15b5:	49 89 ca             	mov    %rcx,%r10
    15b8:	0f 05                	syscall 
    15ba:	c3                   	retq   

00000000000015bb <uptime>:
SYSCALL(uptime)
    15bb:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    15c2:	49 89 ca             	mov    %rcx,%r10
    15c5:	0f 05                	syscall 
    15c7:	c3                   	retq   

00000000000015c8 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    15c8:	f3 0f 1e fa          	endbr64 
    15cc:	55                   	push   %rbp
    15cd:	48 89 e5             	mov    %rsp,%rbp
    15d0:	48 83 ec 10          	sub    $0x10,%rsp
    15d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
    15d7:	89 f0                	mov    %esi,%eax
    15d9:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    15dc:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    15e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15e3:	ba 01 00 00 00       	mov    $0x1,%edx
    15e8:	48 89 ce             	mov    %rcx,%rsi
    15eb:	89 c7                	mov    %eax,%edi
    15ed:	48 b8 f8 14 00 00 00 	movabs $0x14f8,%rax
    15f4:	00 00 00 
    15f7:	ff d0                	callq  *%rax
}
    15f9:	90                   	nop
    15fa:	c9                   	leaveq 
    15fb:	c3                   	retq   

00000000000015fc <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    15fc:	f3 0f 1e fa          	endbr64 
    1600:	55                   	push   %rbp
    1601:	48 89 e5             	mov    %rsp,%rbp
    1604:	48 83 ec 20          	sub    $0x20,%rsp
    1608:	89 7d ec             	mov    %edi,-0x14(%rbp)
    160b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    160f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1616:	eb 35                	jmp    164d <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1618:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    161c:	48 c1 e8 3c          	shr    $0x3c,%rax
    1620:	48 ba 20 27 00 00 00 	movabs $0x2720,%rdx
    1627:	00 00 00 
    162a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    162e:	0f be d0             	movsbl %al,%edx
    1631:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1634:	89 d6                	mov    %edx,%esi
    1636:	89 c7                	mov    %eax,%edi
    1638:	48 b8 c8 15 00 00 00 	movabs $0x15c8,%rax
    163f:	00 00 00 
    1642:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1644:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1648:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    164d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1650:	83 f8 0f             	cmp    $0xf,%eax
    1653:	76 c3                	jbe    1618 <print_x64+0x1c>
}
    1655:	90                   	nop
    1656:	90                   	nop
    1657:	c9                   	leaveq 
    1658:	c3                   	retq   

0000000000001659 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1659:	f3 0f 1e fa          	endbr64 
    165d:	55                   	push   %rbp
    165e:	48 89 e5             	mov    %rsp,%rbp
    1661:	48 83 ec 20          	sub    $0x20,%rsp
    1665:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1668:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    166b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1672:	eb 36                	jmp    16aa <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1674:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1677:	c1 e8 1c             	shr    $0x1c,%eax
    167a:	89 c2                	mov    %eax,%edx
    167c:	48 b8 20 27 00 00 00 	movabs $0x2720,%rax
    1683:	00 00 00 
    1686:	89 d2                	mov    %edx,%edx
    1688:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    168c:	0f be d0             	movsbl %al,%edx
    168f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1692:	89 d6                	mov    %edx,%esi
    1694:	89 c7                	mov    %eax,%edi
    1696:	48 b8 c8 15 00 00 00 	movabs $0x15c8,%rax
    169d:	00 00 00 
    16a0:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16a6:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16ad:	83 f8 07             	cmp    $0x7,%eax
    16b0:	76 c2                	jbe    1674 <print_x32+0x1b>
}
    16b2:	90                   	nop
    16b3:	90                   	nop
    16b4:	c9                   	leaveq 
    16b5:	c3                   	retq   

00000000000016b6 <print_d>:

  static void
print_d(int fd, int v)
{
    16b6:	f3 0f 1e fa          	endbr64 
    16ba:	55                   	push   %rbp
    16bb:	48 89 e5             	mov    %rsp,%rbp
    16be:	48 83 ec 30          	sub    $0x30,%rsp
    16c2:	89 7d dc             	mov    %edi,-0x24(%rbp)
    16c5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    16c8:	8b 45 d8             	mov    -0x28(%rbp),%eax
    16cb:	48 98                	cltq   
    16cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    16d1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16d5:	79 04                	jns    16db <print_d+0x25>
    x = -x;
    16d7:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    16db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    16e2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    16e6:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    16ed:	66 66 66 
    16f0:	48 89 c8             	mov    %rcx,%rax
    16f3:	48 f7 ea             	imul   %rdx
    16f6:	48 c1 fa 02          	sar    $0x2,%rdx
    16fa:	48 89 c8             	mov    %rcx,%rax
    16fd:	48 c1 f8 3f          	sar    $0x3f,%rax
    1701:	48 29 c2             	sub    %rax,%rdx
    1704:	48 89 d0             	mov    %rdx,%rax
    1707:	48 c1 e0 02          	shl    $0x2,%rax
    170b:	48 01 d0             	add    %rdx,%rax
    170e:	48 01 c0             	add    %rax,%rax
    1711:	48 29 c1             	sub    %rax,%rcx
    1714:	48 89 ca             	mov    %rcx,%rdx
    1717:	8b 45 f4             	mov    -0xc(%rbp),%eax
    171a:	8d 48 01             	lea    0x1(%rax),%ecx
    171d:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1720:	48 b9 20 27 00 00 00 	movabs $0x2720,%rcx
    1727:	00 00 00 
    172a:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    172e:	48 98                	cltq   
    1730:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1734:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1738:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    173f:	66 66 66 
    1742:	48 89 c8             	mov    %rcx,%rax
    1745:	48 f7 ea             	imul   %rdx
    1748:	48 c1 fa 02          	sar    $0x2,%rdx
    174c:	48 89 c8             	mov    %rcx,%rax
    174f:	48 c1 f8 3f          	sar    $0x3f,%rax
    1753:	48 29 c2             	sub    %rax,%rdx
    1756:	48 89 d0             	mov    %rdx,%rax
    1759:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    175d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1762:	0f 85 7a ff ff ff    	jne    16e2 <print_d+0x2c>

  if (v < 0)
    1768:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    176c:	79 32                	jns    17a0 <print_d+0xea>
    buf[i++] = '-';
    176e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1771:	8d 50 01             	lea    0x1(%rax),%edx
    1774:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1777:	48 98                	cltq   
    1779:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    177e:	eb 20                	jmp    17a0 <print_d+0xea>
    putc(fd, buf[i]);
    1780:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1783:	48 98                	cltq   
    1785:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    178a:	0f be d0             	movsbl %al,%edx
    178d:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1790:	89 d6                	mov    %edx,%esi
    1792:	89 c7                	mov    %eax,%edi
    1794:	48 b8 c8 15 00 00 00 	movabs $0x15c8,%rax
    179b:	00 00 00 
    179e:	ff d0                	callq  *%rax
  while (--i >= 0)
    17a0:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17a8:	79 d6                	jns    1780 <print_d+0xca>
}
    17aa:	90                   	nop
    17ab:	90                   	nop
    17ac:	c9                   	leaveq 
    17ad:	c3                   	retq   

00000000000017ae <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    17ae:	f3 0f 1e fa          	endbr64 
    17b2:	55                   	push   %rbp
    17b3:	48 89 e5             	mov    %rsp,%rbp
    17b6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    17bd:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    17c3:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    17ca:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    17d1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    17d8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    17df:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    17e6:	84 c0                	test   %al,%al
    17e8:	74 20                	je     180a <printf+0x5c>
    17ea:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    17ee:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    17f2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    17f6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    17fa:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    17fe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1802:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1806:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    180a:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1811:	00 00 00 
    1814:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    181b:	00 00 00 
    181e:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1822:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1829:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1830:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1837:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    183e:	00 00 00 
    1841:	e9 41 03 00 00       	jmpq   1b87 <printf+0x3d9>
    if (c != '%') {
    1846:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    184d:	74 24                	je     1873 <printf+0xc5>
      putc(fd, c);
    184f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1855:	0f be d0             	movsbl %al,%edx
    1858:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    185e:	89 d6                	mov    %edx,%esi
    1860:	89 c7                	mov    %eax,%edi
    1862:	48 b8 c8 15 00 00 00 	movabs $0x15c8,%rax
    1869:	00 00 00 
    186c:	ff d0                	callq  *%rax
      continue;
    186e:	e9 0d 03 00 00       	jmpq   1b80 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1873:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    187a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1880:	48 63 d0             	movslq %eax,%rdx
    1883:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    188a:	48 01 d0             	add    %rdx,%rax
    188d:	0f b6 00             	movzbl (%rax),%eax
    1890:	0f be c0             	movsbl %al,%eax
    1893:	25 ff 00 00 00       	and    $0xff,%eax
    1898:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    189e:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18a5:	0f 84 0f 03 00 00    	je     1bba <printf+0x40c>
      break;
    switch(c) {
    18ab:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18b2:	0f 84 74 02 00 00    	je     1b2c <printf+0x37e>
    18b8:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18bf:	0f 8c 82 02 00 00    	jl     1b47 <printf+0x399>
    18c5:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18cc:	0f 8f 75 02 00 00    	jg     1b47 <printf+0x399>
    18d2:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    18d9:	0f 8c 68 02 00 00    	jl     1b47 <printf+0x399>
    18df:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    18e5:	83 e8 63             	sub    $0x63,%eax
    18e8:	83 f8 15             	cmp    $0x15,%eax
    18eb:	0f 87 56 02 00 00    	ja     1b47 <printf+0x399>
    18f1:	89 c0                	mov    %eax,%eax
    18f3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    18fa:	00 
    18fb:	48 b8 20 23 00 00 00 	movabs $0x2320,%rax
    1902:	00 00 00 
    1905:	48 01 d0             	add    %rdx,%rax
    1908:	48 8b 00             	mov    (%rax),%rax
    190b:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    190e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1914:	83 f8 2f             	cmp    $0x2f,%eax
    1917:	77 23                	ja     193c <printf+0x18e>
    1919:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1920:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1926:	89 d2                	mov    %edx,%edx
    1928:	48 01 d0             	add    %rdx,%rax
    192b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1931:	83 c2 08             	add    $0x8,%edx
    1934:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    193a:	eb 12                	jmp    194e <printf+0x1a0>
    193c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1943:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1947:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    194e:	8b 00                	mov    (%rax),%eax
    1950:	0f be d0             	movsbl %al,%edx
    1953:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1959:	89 d6                	mov    %edx,%esi
    195b:	89 c7                	mov    %eax,%edi
    195d:	48 b8 c8 15 00 00 00 	movabs $0x15c8,%rax
    1964:	00 00 00 
    1967:	ff d0                	callq  *%rax
      break;
    1969:	e9 12 02 00 00       	jmpq   1b80 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    196e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1974:	83 f8 2f             	cmp    $0x2f,%eax
    1977:	77 23                	ja     199c <printf+0x1ee>
    1979:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1980:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1986:	89 d2                	mov    %edx,%edx
    1988:	48 01 d0             	add    %rdx,%rax
    198b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1991:	83 c2 08             	add    $0x8,%edx
    1994:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    199a:	eb 12                	jmp    19ae <printf+0x200>
    199c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19a3:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19a7:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19ae:	8b 10                	mov    (%rax),%edx
    19b0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19b6:	89 d6                	mov    %edx,%esi
    19b8:	89 c7                	mov    %eax,%edi
    19ba:	48 b8 b6 16 00 00 00 	movabs $0x16b6,%rax
    19c1:	00 00 00 
    19c4:	ff d0                	callq  *%rax
      break;
    19c6:	e9 b5 01 00 00       	jmpq   1b80 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    19cb:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19d1:	83 f8 2f             	cmp    $0x2f,%eax
    19d4:	77 23                	ja     19f9 <printf+0x24b>
    19d6:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19dd:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19e3:	89 d2                	mov    %edx,%edx
    19e5:	48 01 d0             	add    %rdx,%rax
    19e8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19ee:	83 c2 08             	add    $0x8,%edx
    19f1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19f7:	eb 12                	jmp    1a0b <printf+0x25d>
    19f9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a00:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a04:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a0b:	8b 10                	mov    (%rax),%edx
    1a0d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a13:	89 d6                	mov    %edx,%esi
    1a15:	89 c7                	mov    %eax,%edi
    1a17:	48 b8 59 16 00 00 00 	movabs $0x1659,%rax
    1a1e:	00 00 00 
    1a21:	ff d0                	callq  *%rax
      break;
    1a23:	e9 58 01 00 00       	jmpq   1b80 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a28:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a2e:	83 f8 2f             	cmp    $0x2f,%eax
    1a31:	77 23                	ja     1a56 <printf+0x2a8>
    1a33:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a3a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a40:	89 d2                	mov    %edx,%edx
    1a42:	48 01 d0             	add    %rdx,%rax
    1a45:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a4b:	83 c2 08             	add    $0x8,%edx
    1a4e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a54:	eb 12                	jmp    1a68 <printf+0x2ba>
    1a56:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a5d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a61:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a68:	48 8b 10             	mov    (%rax),%rdx
    1a6b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a71:	48 89 d6             	mov    %rdx,%rsi
    1a74:	89 c7                	mov    %eax,%edi
    1a76:	48 b8 fc 15 00 00 00 	movabs $0x15fc,%rax
    1a7d:	00 00 00 
    1a80:	ff d0                	callq  *%rax
      break;
    1a82:	e9 f9 00 00 00       	jmpq   1b80 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1a87:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a8d:	83 f8 2f             	cmp    $0x2f,%eax
    1a90:	77 23                	ja     1ab5 <printf+0x307>
    1a92:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a99:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a9f:	89 d2                	mov    %edx,%edx
    1aa1:	48 01 d0             	add    %rdx,%rax
    1aa4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aaa:	83 c2 08             	add    $0x8,%edx
    1aad:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1ab3:	eb 12                	jmp    1ac7 <printf+0x319>
    1ab5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1abc:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1ac0:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ac7:	48 8b 00             	mov    (%rax),%rax
    1aca:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1ad1:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1ad8:	00 
    1ad9:	75 41                	jne    1b1c <printf+0x36e>
        s = "(null)";
    1adb:	48 b8 18 23 00 00 00 	movabs $0x2318,%rax
    1ae2:	00 00 00 
    1ae5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1aec:	eb 2e                	jmp    1b1c <printf+0x36e>
        putc(fd, *(s++));
    1aee:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1af5:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1af9:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b00:	0f b6 00             	movzbl (%rax),%eax
    1b03:	0f be d0             	movsbl %al,%edx
    1b06:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b0c:	89 d6                	mov    %edx,%esi
    1b0e:	89 c7                	mov    %eax,%edi
    1b10:	48 b8 c8 15 00 00 00 	movabs $0x15c8,%rax
    1b17:	00 00 00 
    1b1a:	ff d0                	callq  *%rax
      while (*s)
    1b1c:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b23:	0f b6 00             	movzbl (%rax),%eax
    1b26:	84 c0                	test   %al,%al
    1b28:	75 c4                	jne    1aee <printf+0x340>
      break;
    1b2a:	eb 54                	jmp    1b80 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b2c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b32:	be 25 00 00 00       	mov    $0x25,%esi
    1b37:	89 c7                	mov    %eax,%edi
    1b39:	48 b8 c8 15 00 00 00 	movabs $0x15c8,%rax
    1b40:	00 00 00 
    1b43:	ff d0                	callq  *%rax
      break;
    1b45:	eb 39                	jmp    1b80 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b47:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b4d:	be 25 00 00 00       	mov    $0x25,%esi
    1b52:	89 c7                	mov    %eax,%edi
    1b54:	48 b8 c8 15 00 00 00 	movabs $0x15c8,%rax
    1b5b:	00 00 00 
    1b5e:	ff d0                	callq  *%rax
      putc(fd, c);
    1b60:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b66:	0f be d0             	movsbl %al,%edx
    1b69:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b6f:	89 d6                	mov    %edx,%esi
    1b71:	89 c7                	mov    %eax,%edi
    1b73:	48 b8 c8 15 00 00 00 	movabs $0x15c8,%rax
    1b7a:	00 00 00 
    1b7d:	ff d0                	callq  *%rax
      break;
    1b7f:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b80:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b87:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b8d:	48 63 d0             	movslq %eax,%rdx
    1b90:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1b97:	48 01 d0             	add    %rdx,%rax
    1b9a:	0f b6 00             	movzbl (%rax),%eax
    1b9d:	0f be c0             	movsbl %al,%eax
    1ba0:	25 ff 00 00 00       	and    $0xff,%eax
    1ba5:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1bab:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bb2:	0f 85 8e fc ff ff    	jne    1846 <printf+0x98>
    }
  }
}
    1bb8:	eb 01                	jmp    1bbb <printf+0x40d>
      break;
    1bba:	90                   	nop
}
    1bbb:	90                   	nop
    1bbc:	c9                   	leaveq 
    1bbd:	c3                   	retq   

0000000000001bbe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1bbe:	f3 0f 1e fa          	endbr64 
    1bc2:	55                   	push   %rbp
    1bc3:	48 89 e5             	mov    %rsp,%rbp
    1bc6:	48 83 ec 18          	sub    $0x18,%rsp
    1bca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1bce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bd2:	48 83 e8 10          	sub    $0x10,%rax
    1bd6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bda:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    1be1:	00 00 00 
    1be4:	48 8b 00             	mov    (%rax),%rax
    1be7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1beb:	eb 2f                	jmp    1c1c <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1bed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf1:	48 8b 00             	mov    (%rax),%rax
    1bf4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1bf8:	72 17                	jb     1c11 <free+0x53>
    1bfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bfe:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c02:	77 2f                	ja     1c33 <free+0x75>
    1c04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c08:	48 8b 00             	mov    (%rax),%rax
    1c0b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c0f:	72 22                	jb     1c33 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c15:	48 8b 00             	mov    (%rax),%rax
    1c18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c20:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c24:	76 c7                	jbe    1bed <free+0x2f>
    1c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c2a:	48 8b 00             	mov    (%rax),%rax
    1c2d:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c31:	73 ba                	jae    1bed <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c37:	8b 40 08             	mov    0x8(%rax),%eax
    1c3a:	89 c0                	mov    %eax,%eax
    1c3c:	48 c1 e0 04          	shl    $0x4,%rax
    1c40:	48 89 c2             	mov    %rax,%rdx
    1c43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c47:	48 01 c2             	add    %rax,%rdx
    1c4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c4e:	48 8b 00             	mov    (%rax),%rax
    1c51:	48 39 c2             	cmp    %rax,%rdx
    1c54:	75 2d                	jne    1c83 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1c56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c5a:	8b 50 08             	mov    0x8(%rax),%edx
    1c5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c61:	48 8b 00             	mov    (%rax),%rax
    1c64:	8b 40 08             	mov    0x8(%rax),%eax
    1c67:	01 c2                	add    %eax,%edx
    1c69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c6d:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1c70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c74:	48 8b 00             	mov    (%rax),%rax
    1c77:	48 8b 10             	mov    (%rax),%rdx
    1c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c7e:	48 89 10             	mov    %rdx,(%rax)
    1c81:	eb 0e                	jmp    1c91 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1c83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c87:	48 8b 10             	mov    (%rax),%rdx
    1c8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c8e:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1c91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c95:	8b 40 08             	mov    0x8(%rax),%eax
    1c98:	89 c0                	mov    %eax,%eax
    1c9a:	48 c1 e0 04          	shl    $0x4,%rax
    1c9e:	48 89 c2             	mov    %rax,%rdx
    1ca1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca5:	48 01 d0             	add    %rdx,%rax
    1ca8:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cac:	75 27                	jne    1cd5 <free+0x117>
    p->s.size += bp->s.size;
    1cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb2:	8b 50 08             	mov    0x8(%rax),%edx
    1cb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb9:	8b 40 08             	mov    0x8(%rax),%eax
    1cbc:	01 c2                	add    %eax,%edx
    1cbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc2:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc9:	48 8b 10             	mov    (%rax),%rdx
    1ccc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cd0:	48 89 10             	mov    %rdx,(%rax)
    1cd3:	eb 0b                	jmp    1ce0 <free+0x122>
  } else
    p->s.ptr = bp;
    1cd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1cdd:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1ce0:	48 ba 50 27 00 00 00 	movabs $0x2750,%rdx
    1ce7:	00 00 00 
    1cea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cee:	48 89 02             	mov    %rax,(%rdx)
}
    1cf1:	90                   	nop
    1cf2:	c9                   	leaveq 
    1cf3:	c3                   	retq   

0000000000001cf4 <morecore>:

static Header*
morecore(uint nu)
{
    1cf4:	f3 0f 1e fa          	endbr64 
    1cf8:	55                   	push   %rbp
    1cf9:	48 89 e5             	mov    %rsp,%rbp
    1cfc:	48 83 ec 20          	sub    $0x20,%rsp
    1d00:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d03:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d0a:	77 07                	ja     1d13 <morecore+0x1f>
    nu = 4096;
    1d0c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d13:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d16:	48 c1 e0 04          	shl    $0x4,%rax
    1d1a:	48 89 c7             	mov    %rax,%rdi
    1d1d:	48 b8 a1 15 00 00 00 	movabs $0x15a1,%rax
    1d24:	00 00 00 
    1d27:	ff d0                	callq  *%rax
    1d29:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d2d:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d32:	75 07                	jne    1d3b <morecore+0x47>
    return 0;
    1d34:	b8 00 00 00 00       	mov    $0x0,%eax
    1d39:	eb 36                	jmp    1d71 <morecore+0x7d>
  hp = (Header*)p;
    1d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d3f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d47:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d4a:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d51:	48 83 c0 10          	add    $0x10,%rax
    1d55:	48 89 c7             	mov    %rax,%rdi
    1d58:	48 b8 be 1b 00 00 00 	movabs $0x1bbe,%rax
    1d5f:	00 00 00 
    1d62:	ff d0                	callq  *%rax
  return freep;
    1d64:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    1d6b:	00 00 00 
    1d6e:	48 8b 00             	mov    (%rax),%rax
}
    1d71:	c9                   	leaveq 
    1d72:	c3                   	retq   

0000000000001d73 <malloc>:

void*
malloc(uint nbytes)
{
    1d73:	f3 0f 1e fa          	endbr64 
    1d77:	55                   	push   %rbp
    1d78:	48 89 e5             	mov    %rsp,%rbp
    1d7b:	48 83 ec 30          	sub    $0x30,%rsp
    1d7f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1d82:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1d85:	48 83 c0 0f          	add    $0xf,%rax
    1d89:	48 c1 e8 04          	shr    $0x4,%rax
    1d8d:	83 c0 01             	add    $0x1,%eax
    1d90:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1d93:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    1d9a:	00 00 00 
    1d9d:	48 8b 00             	mov    (%rax),%rax
    1da0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1da4:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1da9:	75 4a                	jne    1df5 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1dab:	48 b8 40 27 00 00 00 	movabs $0x2740,%rax
    1db2:	00 00 00 
    1db5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1db9:	48 ba 50 27 00 00 00 	movabs $0x2750,%rdx
    1dc0:	00 00 00 
    1dc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dc7:	48 89 02             	mov    %rax,(%rdx)
    1dca:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    1dd1:	00 00 00 
    1dd4:	48 8b 00             	mov    (%rax),%rax
    1dd7:	48 ba 40 27 00 00 00 	movabs $0x2740,%rdx
    1dde:	00 00 00 
    1de1:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1de4:	48 b8 40 27 00 00 00 	movabs $0x2740,%rax
    1deb:	00 00 00 
    1dee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1df5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1df9:	48 8b 00             	mov    (%rax),%rax
    1dfc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e04:	8b 40 08             	mov    0x8(%rax),%eax
    1e07:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e0a:	77 65                	ja     1e71 <malloc+0xfe>
      if(p->s.size == nunits)
    1e0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e10:	8b 40 08             	mov    0x8(%rax),%eax
    1e13:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e16:	75 10                	jne    1e28 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1e18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e1c:	48 8b 10             	mov    (%rax),%rdx
    1e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e23:	48 89 10             	mov    %rdx,(%rax)
    1e26:	eb 2e                	jmp    1e56 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e2c:	8b 40 08             	mov    0x8(%rax),%eax
    1e2f:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e32:	89 c2                	mov    %eax,%edx
    1e34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e38:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e3f:	8b 40 08             	mov    0x8(%rax),%eax
    1e42:	89 c0                	mov    %eax,%eax
    1e44:	48 c1 e0 04          	shl    $0x4,%rax
    1e48:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e50:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e53:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e56:	48 ba 50 27 00 00 00 	movabs $0x2750,%rdx
    1e5d:	00 00 00 
    1e60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e64:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1e67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e6b:	48 83 c0 10          	add    $0x10,%rax
    1e6f:	eb 4e                	jmp    1ebf <malloc+0x14c>
    }
    if(p == freep)
    1e71:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    1e78:	00 00 00 
    1e7b:	48 8b 00             	mov    (%rax),%rax
    1e7e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1e82:	75 23                	jne    1ea7 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1e84:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1e87:	89 c7                	mov    %eax,%edi
    1e89:	48 b8 f4 1c 00 00 00 	movabs $0x1cf4,%rax
    1e90:	00 00 00 
    1e93:	ff d0                	callq  *%rax
    1e95:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1e99:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1e9e:	75 07                	jne    1ea7 <malloc+0x134>
        return 0;
    1ea0:	b8 00 00 00 00       	mov    $0x0,%eax
    1ea5:	eb 18                	jmp    1ebf <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ea7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1eaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eb3:	48 8b 00             	mov    (%rax),%rax
    1eb6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1eba:	e9 41 ff ff ff       	jmpq   1e00 <malloc+0x8d>
  }
}
    1ebf:	c9                   	leaveq 
    1ec0:	c3                   	retq   

0000000000001ec1 <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1ec1:	f3 0f 1e fa          	endbr64 
    1ec5:	55                   	push   %rbp
    1ec6:	48 89 e5             	mov    %rsp,%rbp
    1ec9:	48 83 ec 30          	sub    $0x30,%rsp
    1ecd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1ed1:	bf 18 00 00 00       	mov    $0x18,%edi
    1ed6:	48 b8 73 1d 00 00 00 	movabs $0x1d73,%rax
    1edd:	00 00 00 
    1ee0:	ff d0                	callq  *%rax
    1ee2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1ee6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1eeb:	75 0a                	jne    1ef7 <co_new+0x36>
    return 0;
    1eed:	b8 00 00 00 00       	mov    $0x0,%eax
    1ef2:	e9 e1 00 00 00       	jmpq   1fd8 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1ef7:	bf 00 20 00 00       	mov    $0x2000,%edi
    1efc:	48 b8 73 1d 00 00 00 	movabs $0x1d73,%rax
    1f03:	00 00 00 
    1f06:	ff d0                	callq  *%rax
    1f08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1f0c:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f14:	48 8b 40 10          	mov    0x10(%rax),%rax
    1f18:	48 85 c0             	test   %rax,%rax
    1f1b:	75 1d                	jne    1f3a <co_new+0x79>
    free(co1);
    1f1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f21:	48 89 c7             	mov    %rax,%rdi
    1f24:	48 b8 be 1b 00 00 00 	movabs $0x1bbe,%rax
    1f2b:	00 00 00 
    1f2e:	ff d0                	callq  *%rax
    return 0;
    1f30:	b8 00 00 00 00       	mov    $0x0,%eax
    1f35:	e9 9e 00 00 00       	jmpq   1fd8 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f3e:	48 8b 40 10          	mov    0x10(%rax),%rax
    1f42:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    1f48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    1f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f50:	48 8d 50 30          	lea    0x30(%rax),%rdx
    1f54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1f58:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    1f5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f5f:	48 83 c0 38          	add    $0x38,%rax
    1f63:	48 ba 4a 21 00 00 00 	movabs $0x214a,%rdx
    1f6a:	00 00 00 
    1f6d:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    1f70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1f78:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    1f7b:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    1f82:	00 00 00 
    1f85:	48 8b 00             	mov    (%rax),%rax
    1f88:	48 85 c0             	test   %rax,%rax
    1f8b:	75 13                	jne    1fa0 <co_new+0xdf>
  {
  	co_list = co1;
    1f8d:	48 ba 68 27 00 00 00 	movabs $0x2768,%rdx
    1f94:	00 00 00 
    1f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f9b:	48 89 02             	mov    %rax,(%rdx)
    1f9e:	eb 34                	jmp    1fd4 <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    1fa0:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    1fa7:	00 00 00 
    1faa:	48 8b 00             	mov    (%rax),%rax
    1fad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1fb1:	eb 0c                	jmp    1fbf <co_new+0xfe>
	{
		head = head->next;
    1fb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb7:	48 8b 40 08          	mov    0x8(%rax),%rax
    1fbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fc3:	48 8b 40 08          	mov    0x8(%rax),%rax
    1fc7:	48 85 c0             	test   %rax,%rax
    1fca:	75 e7                	jne    1fb3 <co_new+0xf2>
	}
	head = co1;
    1fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fd0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    1fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    1fd8:	c9                   	leaveq 
    1fd9:	c3                   	retq   

0000000000001fda <co_run>:

  int
co_run(void)
{
    1fda:	f3 0f 1e fa          	endbr64 
    1fde:	55                   	push   %rbp
    1fdf:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    1fe2:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    1fe9:	00 00 00 
    1fec:	48 8b 00             	mov    (%rax),%rax
    1fef:	48 85 c0             	test   %rax,%rax
    1ff2:	74 4a                	je     203e <co_run+0x64>
	{
		co_current = co_list;
    1ff4:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    1ffb:	00 00 00 
    1ffe:	48 8b 00             	mov    (%rax),%rax
    2001:	48 ba 60 27 00 00 00 	movabs $0x2760,%rdx
    2008:	00 00 00 
    200b:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    200e:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    2015:	00 00 00 
    2018:	48 8b 00             	mov    (%rax),%rax
    201b:	48 8b 00             	mov    (%rax),%rax
    201e:	48 89 c6             	mov    %rax,%rsi
    2021:	48 bf 58 27 00 00 00 	movabs $0x2758,%rdi
    2028:	00 00 00 
    202b:	48 b8 ac 22 00 00 00 	movabs $0x22ac,%rax
    2032:	00 00 00 
    2035:	ff d0                	callq  *%rax
		return 1;
    2037:	b8 01 00 00 00       	mov    $0x1,%eax
    203c:	eb 05                	jmp    2043 <co_run+0x69>
	}
	return 0;
    203e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2043:	5d                   	pop    %rbp
    2044:	c3                   	retq   

0000000000002045 <co_run_all>:

  int
co_run_all(void)
{
    2045:	f3 0f 1e fa          	endbr64 
    2049:	55                   	push   %rbp
    204a:	48 89 e5             	mov    %rsp,%rbp
    204d:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    2051:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    2058:	00 00 00 
    205b:	48 8b 00             	mov    (%rax),%rax
    205e:	48 85 c0             	test   %rax,%rax
    2061:	75 07                	jne    206a <co_run_all+0x25>
		return 0;
    2063:	b8 00 00 00 00       	mov    $0x0,%eax
    2068:	eb 37                	jmp    20a1 <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    206a:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    2071:	00 00 00 
    2074:	48 8b 00             	mov    (%rax),%rax
    2077:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    207b:	eb 18                	jmp    2095 <co_run_all+0x50>
			co_run();
    207d:	48 b8 da 1f 00 00 00 	movabs $0x1fda,%rax
    2084:	00 00 00 
    2087:	ff d0                	callq  *%rax
			tmp = tmp->next;
    2089:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    208d:	48 8b 40 08          	mov    0x8(%rax),%rax
    2091:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    2095:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    209a:	75 e1                	jne    207d <co_run_all+0x38>
		}
		return 1;
    209c:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    20a1:	c9                   	leaveq 
    20a2:	c3                   	retq   

00000000000020a3 <co_yield>:

  void
co_yield()
{
    20a3:	f3 0f 1e fa          	endbr64 
    20a7:	55                   	push   %rbp
    20a8:	48 89 e5             	mov    %rsp,%rbp
    20ab:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    20af:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    20b6:	00 00 00 
    20b9:	48 8b 00             	mov    (%rax),%rax
    20bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    20c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20c4:	48 8b 40 08          	mov    0x8(%rax),%rax
    20c8:	48 85 c0             	test   %rax,%rax
    20cb:	74 46                	je     2113 <co_yield+0x70>
  {
  	co_current = co_current->next;
    20cd:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    20d4:	00 00 00 
    20d7:	48 8b 00             	mov    (%rax),%rax
    20da:	48 8b 40 08          	mov    0x8(%rax),%rax
    20de:	48 ba 60 27 00 00 00 	movabs $0x2760,%rdx
    20e5:	00 00 00 
    20e8:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    20eb:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    20f2:	00 00 00 
    20f5:	48 8b 00             	mov    (%rax),%rax
    20f8:	48 8b 10             	mov    (%rax),%rdx
    20fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20ff:	48 89 d6             	mov    %rdx,%rsi
    2102:	48 89 c7             	mov    %rax,%rdi
    2105:	48 b8 ac 22 00 00 00 	movabs $0x22ac,%rax
    210c:	00 00 00 
    210f:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    2111:	eb 34                	jmp    2147 <co_yield+0xa4>
	co_current = 0;
    2113:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    211a:	00 00 00 
    211d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    2124:	48 b8 58 27 00 00 00 	movabs $0x2758,%rax
    212b:	00 00 00 
    212e:	48 8b 10             	mov    (%rax),%rdx
    2131:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2135:	48 89 d6             	mov    %rdx,%rsi
    2138:	48 89 c7             	mov    %rax,%rdi
    213b:	48 b8 ac 22 00 00 00 	movabs $0x22ac,%rax
    2142:	00 00 00 
    2145:	ff d0                	callq  *%rax
}
    2147:	90                   	nop
    2148:	c9                   	leaveq 
    2149:	c3                   	retq   

000000000000214a <co_exit>:

  void
co_exit(void)
{
    214a:	f3 0f 1e fa          	endbr64 
    214e:	55                   	push   %rbp
    214f:	48 89 e5             	mov    %rsp,%rbp
    2152:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    2156:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    215d:	00 00 00 
    2160:	48 8b 00             	mov    (%rax),%rax
    2163:	48 85 c0             	test   %rax,%rax
    2166:	0f 84 ec 00 00 00    	je     2258 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    216c:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    2173:	00 00 00 
    2176:	48 8b 00             	mov    (%rax),%rax
    2179:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    217d:	e9 c9 00 00 00       	jmpq   224b <co_exit+0x101>
		if(tmp == co_current)
    2182:	48 b8 60 27 00 00 00 	movabs $0x2760,%rax
    2189:	00 00 00 
    218c:	48 8b 00             	mov    (%rax),%rax
    218f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2193:	0f 85 9e 00 00 00    	jne    2237 <co_exit+0xed>
		{
			if(tmp->next)
    2199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    219d:	48 8b 40 08          	mov    0x8(%rax),%rax
    21a1:	48 85 c0             	test   %rax,%rax
    21a4:	74 54                	je     21fa <co_exit+0xb0>
			{
				if(prev)
    21a6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    21ab:	74 10                	je     21bd <co_exit+0x73>
				{
					prev->next = tmp->next;
    21ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21b1:	48 8b 50 08          	mov    0x8(%rax),%rdx
    21b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    21b9:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    21bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21c1:	48 8b 40 08          	mov    0x8(%rax),%rax
    21c5:	48 ba 68 27 00 00 00 	movabs $0x2768,%rdx
    21cc:	00 00 00 
    21cf:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    21d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21d6:	48 8b 00             	mov    (%rax),%rax
    21d9:	48 ba 60 27 00 00 00 	movabs $0x2760,%rdx
    21e0:	00 00 00 
    21e3:	48 8b 12             	mov    (%rdx),%rdx
    21e6:	48 89 c6             	mov    %rax,%rsi
    21e9:	48 89 d7             	mov    %rdx,%rdi
    21ec:	48 b8 ac 22 00 00 00 	movabs $0x22ac,%rax
    21f3:	00 00 00 
    21f6:	ff d0                	callq  *%rax
    21f8:	eb 3d                	jmp    2237 <co_exit+0xed>
			}else{
				co_list = 0;
    21fa:	48 b8 68 27 00 00 00 	movabs $0x2768,%rax
    2201:	00 00 00 
    2204:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    220b:	48 b8 58 27 00 00 00 	movabs $0x2758,%rax
    2212:	00 00 00 
    2215:	48 8b 00             	mov    (%rax),%rax
    2218:	48 ba 60 27 00 00 00 	movabs $0x2760,%rdx
    221f:	00 00 00 
    2222:	48 8b 12             	mov    (%rdx),%rdx
    2225:	48 89 c6             	mov    %rax,%rsi
    2228:	48 89 d7             	mov    %rdx,%rdi
    222b:	48 b8 ac 22 00 00 00 	movabs $0x22ac,%rax
    2232:	00 00 00 
    2235:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    2237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    223b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    223f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2243:	48 8b 40 08          	mov    0x8(%rax),%rax
    2247:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    224b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2250:	0f 85 2c ff ff ff    	jne    2182 <co_exit+0x38>
    2256:	eb 01                	jmp    2259 <co_exit+0x10f>
		return;
    2258:	90                   	nop
	}
}
    2259:	c9                   	leaveq 
    225a:	c3                   	retq   

000000000000225b <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    225b:	f3 0f 1e fa          	endbr64 
    225f:	55                   	push   %rbp
    2260:	48 89 e5             	mov    %rsp,%rbp
    2263:	48 83 ec 10          	sub    $0x10,%rsp
    2267:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    226b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2270:	74 37                	je     22a9 <co_destroy+0x4e>
    if (co->stack)
    2272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2276:	48 8b 40 10          	mov    0x10(%rax),%rax
    227a:	48 85 c0             	test   %rax,%rax
    227d:	74 17                	je     2296 <co_destroy+0x3b>
      free(co->stack);
    227f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2283:	48 8b 40 10          	mov    0x10(%rax),%rax
    2287:	48 89 c7             	mov    %rax,%rdi
    228a:	48 b8 be 1b 00 00 00 	movabs $0x1bbe,%rax
    2291:	00 00 00 
    2294:	ff d0                	callq  *%rax
    free(co);
    2296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    229a:	48 89 c7             	mov    %rax,%rdi
    229d:	48 b8 be 1b 00 00 00 	movabs $0x1bbe,%rax
    22a4:	00 00 00 
    22a7:	ff d0                	callq  *%rax
  }
}
    22a9:	90                   	nop
    22aa:	c9                   	leaveq 
    22ab:	c3                   	retq   

00000000000022ac <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    22ac:	55                   	push   %rbp
  pushq   %rbx
    22ad:	53                   	push   %rbx
  pushq   %r12
    22ae:	41 54                	push   %r12
  pushq   %r13
    22b0:	41 55                	push   %r13
  pushq   %r14
    22b2:	41 56                	push   %r14
  pushq   %r15
    22b4:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    22b6:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    22b9:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    22bc:	41 5f                	pop    %r15
  popq    %r14
    22be:	41 5e                	pop    %r14
  popq    %r13
    22c0:	41 5d                	pop    %r13
  popq    %r12
    22c2:	41 5c                	pop    %r12
  popq    %rbx
    22c4:	5b                   	pop    %rbx
  popq    %rbp
    22c5:	5d                   	pop    %rbp

  retq #??
    22c6:	c3                   	retq   
