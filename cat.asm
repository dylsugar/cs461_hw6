
_cat:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    100f:	eb 51                	jmp    1062 <cat+0x62>
    if (write(1, buf, n) != n) {
    1011:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1014:	89 c2                	mov    %eax,%edx
    1016:	48 be 80 27 00 00 00 	movabs $0x2780,%rsi
    101d:	00 00 00 
    1020:	bf 01 00 00 00       	mov    $0x1,%edi
    1025:	48 b8 31 15 00 00 00 	movabs $0x1531,%rax
    102c:	00 00 00 
    102f:	ff d0                	callq  *%rax
    1031:	39 45 fc             	cmp    %eax,-0x4(%rbp)
    1034:	74 2c                	je     1062 <cat+0x62>
      printf(1, "cat: write error\n");
    1036:	48 be 00 23 00 00 00 	movabs $0x2300,%rsi
    103d:	00 00 00 
    1040:	bf 01 00 00 00       	mov    $0x1,%edi
    1045:	b8 00 00 00 00       	mov    $0x0,%eax
    104a:	48 ba e7 17 00 00 00 	movabs $0x17e7,%rdx
    1051:	00 00 00 
    1054:	ff d2                	callq  *%rdx
      exit();
    1056:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    105d:	00 00 00 
    1060:	ff d0                	callq  *%rax
  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1062:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1065:	ba 00 02 00 00       	mov    $0x200,%edx
    106a:	48 be 80 27 00 00 00 	movabs $0x2780,%rsi
    1071:	00 00 00 
    1074:	89 c7                	mov    %eax,%edi
    1076:	48 b8 24 15 00 00 00 	movabs $0x1524,%rax
    107d:	00 00 00 
    1080:	ff d0                	callq  *%rax
    1082:	89 45 fc             	mov    %eax,-0x4(%rbp)
    1085:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1089:	7f 86                	jg     1011 <cat+0x11>
    }
  }
  if(n < 0){
    108b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    108f:	79 2c                	jns    10bd <cat+0xbd>
    printf(1, "cat: read error\n");
    1091:	48 be 12 23 00 00 00 	movabs $0x2312,%rsi
    1098:	00 00 00 
    109b:	bf 01 00 00 00       	mov    $0x1,%edi
    10a0:	b8 00 00 00 00       	mov    $0x0,%eax
    10a5:	48 ba e7 17 00 00 00 	movabs $0x17e7,%rdx
    10ac:	00 00 00 
    10af:	ff d2                	callq  *%rdx
    exit();
    10b1:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    10b8:	00 00 00 
    10bb:	ff d0                	callq  *%rax
  }
}
    10bd:	90                   	nop
    10be:	c9                   	leaveq 
    10bf:	c3                   	retq   

00000000000010c0 <main>:

int
main(int argc, char *argv[])
{
    10c0:	f3 0f 1e fa          	endbr64 
    10c4:	55                   	push   %rbp
    10c5:	48 89 e5             	mov    %rsp,%rbp
    10c8:	48 83 ec 20          	sub    $0x20,%rsp
    10cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
    10cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd, i;

  if(argc <= 1){
    10d3:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    10d7:	7f 1d                	jg     10f6 <main+0x36>
    cat(0);
    10d9:	bf 00 00 00 00       	mov    $0x0,%edi
    10de:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    10e5:	00 00 00 
    10e8:	ff d0                	callq  *%rax
    exit();
    10ea:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    10f1:	00 00 00 
    10f4:	ff d0                	callq  *%rax
  }

  for(i = 1; i < argc; i++){
    10f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    10fd:	e9 a0 00 00 00       	jmpq   11a2 <main+0xe2>
    if((fd = open(argv[i], 0)) < 0){
    1102:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1105:	48 98                	cltq   
    1107:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    110e:	00 
    110f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1113:	48 01 d0             	add    %rdx,%rax
    1116:	48 8b 00             	mov    (%rax),%rax
    1119:	be 00 00 00 00       	mov    $0x0,%esi
    111e:	48 89 c7             	mov    %rax,%rdi
    1121:	48 b8 65 15 00 00 00 	movabs $0x1565,%rax
    1128:	00 00 00 
    112b:	ff d0                	callq  *%rax
    112d:	89 45 f8             	mov    %eax,-0x8(%rbp)
    1130:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1134:	79 46                	jns    117c <main+0xbc>
      printf(1, "cat: cannot open %s\n", argv[i]);
    1136:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1139:	48 98                	cltq   
    113b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1142:	00 
    1143:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1147:	48 01 d0             	add    %rdx,%rax
    114a:	48 8b 00             	mov    (%rax),%rax
    114d:	48 89 c2             	mov    %rax,%rdx
    1150:	48 be 23 23 00 00 00 	movabs $0x2323,%rsi
    1157:	00 00 00 
    115a:	bf 01 00 00 00       	mov    $0x1,%edi
    115f:	b8 00 00 00 00       	mov    $0x0,%eax
    1164:	48 b9 e7 17 00 00 00 	movabs $0x17e7,%rcx
    116b:	00 00 00 
    116e:	ff d1                	callq  *%rcx
      exit();
    1170:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    1177:	00 00 00 
    117a:	ff d0                	callq  *%rax
    }
    cat(fd);
    117c:	8b 45 f8             	mov    -0x8(%rbp),%eax
    117f:	89 c7                	mov    %eax,%edi
    1181:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1188:	00 00 00 
    118b:	ff d0                	callq  *%rax
    close(fd);
    118d:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1190:	89 c7                	mov    %eax,%edi
    1192:	48 b8 3e 15 00 00 00 	movabs $0x153e,%rax
    1199:	00 00 00 
    119c:	ff d0                	callq  *%rax
  for(i = 1; i < argc; i++){
    119e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11a5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    11a8:	0f 8c 54 ff ff ff    	jl     1102 <main+0x42>
  }
  exit();
    11ae:	48 b8 fd 14 00 00 00 	movabs $0x14fd,%rax
    11b5:	00 00 00 
    11b8:	ff d0                	callq  *%rax

00000000000011ba <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11ba:	f3 0f 1e fa          	endbr64 
    11be:	55                   	push   %rbp
    11bf:	48 89 e5             	mov    %rsp,%rbp
    11c2:	48 83 ec 10          	sub    $0x10,%rsp
    11c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ca:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11cd:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    11d0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    11d4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11da:	48 89 ce             	mov    %rcx,%rsi
    11dd:	48 89 f7             	mov    %rsi,%rdi
    11e0:	89 d1                	mov    %edx,%ecx
    11e2:	fc                   	cld    
    11e3:	f3 aa                	rep stos %al,%es:(%rdi)
    11e5:	89 ca                	mov    %ecx,%edx
    11e7:	48 89 fe             	mov    %rdi,%rsi
    11ea:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11ee:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11f1:	90                   	nop
    11f2:	c9                   	leaveq 
    11f3:	c3                   	retq   

00000000000011f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11f4:	f3 0f 1e fa          	endbr64 
    11f8:	55                   	push   %rbp
    11f9:	48 89 e5             	mov    %rsp,%rbp
    11fc:	48 83 ec 20          	sub    $0x20,%rsp
    1200:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1204:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    120c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1210:	90                   	nop
    1211:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1215:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1219:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    121d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1221:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1225:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1229:	0f b6 12             	movzbl (%rdx),%edx
    122c:	88 10                	mov    %dl,(%rax)
    122e:	0f b6 00             	movzbl (%rax),%eax
    1231:	84 c0                	test   %al,%al
    1233:	75 dc                	jne    1211 <strcpy+0x1d>
    ;
  return os;
    1235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1239:	c9                   	leaveq 
    123a:	c3                   	retq   

000000000000123b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    123b:	f3 0f 1e fa          	endbr64 
    123f:	55                   	push   %rbp
    1240:	48 89 e5             	mov    %rsp,%rbp
    1243:	48 83 ec 10          	sub    $0x10,%rsp
    1247:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    124b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    124f:	eb 0a                	jmp    125b <strcmp+0x20>
    p++, q++;
    1251:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1256:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    125f:	0f b6 00             	movzbl (%rax),%eax
    1262:	84 c0                	test   %al,%al
    1264:	74 12                	je     1278 <strcmp+0x3d>
    1266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    126a:	0f b6 10             	movzbl (%rax),%edx
    126d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1271:	0f b6 00             	movzbl (%rax),%eax
    1274:	38 c2                	cmp    %al,%dl
    1276:	74 d9                	je     1251 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    127c:	0f b6 00             	movzbl (%rax),%eax
    127f:	0f b6 d0             	movzbl %al,%edx
    1282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1286:	0f b6 00             	movzbl (%rax),%eax
    1289:	0f b6 c0             	movzbl %al,%eax
    128c:	29 c2                	sub    %eax,%edx
    128e:	89 d0                	mov    %edx,%eax
}
    1290:	c9                   	leaveq 
    1291:	c3                   	retq   

0000000000001292 <strlen>:

uint
strlen(char *s)
{
    1292:	f3 0f 1e fa          	endbr64 
    1296:	55                   	push   %rbp
    1297:	48 89 e5             	mov    %rsp,%rbp
    129a:	48 83 ec 18          	sub    $0x18,%rsp
    129e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    12a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12a9:	eb 04                	jmp    12af <strlen+0x1d>
    12ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    12af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12b2:	48 63 d0             	movslq %eax,%rdx
    12b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12b9:	48 01 d0             	add    %rdx,%rax
    12bc:	0f b6 00             	movzbl (%rax),%eax
    12bf:	84 c0                	test   %al,%al
    12c1:	75 e8                	jne    12ab <strlen+0x19>
    ;
  return n;
    12c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    12c6:	c9                   	leaveq 
    12c7:	c3                   	retq   

00000000000012c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    12c8:	f3 0f 1e fa          	endbr64 
    12cc:	55                   	push   %rbp
    12cd:	48 89 e5             	mov    %rsp,%rbp
    12d0:	48 83 ec 10          	sub    $0x10,%rsp
    12d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12d8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12db:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12de:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12e1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12e8:	89 ce                	mov    %ecx,%esi
    12ea:	48 89 c7             	mov    %rax,%rdi
    12ed:	48 b8 ba 11 00 00 00 	movabs $0x11ba,%rax
    12f4:	00 00 00 
    12f7:	ff d0                	callq  *%rax
  return dst;
    12f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12fd:	c9                   	leaveq 
    12fe:	c3                   	retq   

00000000000012ff <strchr>:

char*
strchr(const char *s, char c)
{
    12ff:	f3 0f 1e fa          	endbr64 
    1303:	55                   	push   %rbp
    1304:	48 89 e5             	mov    %rsp,%rbp
    1307:	48 83 ec 10          	sub    $0x10,%rsp
    130b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    130f:	89 f0                	mov    %esi,%eax
    1311:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1314:	eb 17                	jmp    132d <strchr+0x2e>
    if(*s == c)
    1316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    131a:	0f b6 00             	movzbl (%rax),%eax
    131d:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1320:	75 06                	jne    1328 <strchr+0x29>
      return (char*)s;
    1322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1326:	eb 15                	jmp    133d <strchr+0x3e>
  for(; *s; s++)
    1328:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1331:	0f b6 00             	movzbl (%rax),%eax
    1334:	84 c0                	test   %al,%al
    1336:	75 de                	jne    1316 <strchr+0x17>
  return 0;
    1338:	b8 00 00 00 00       	mov    $0x0,%eax
}
    133d:	c9                   	leaveq 
    133e:	c3                   	retq   

000000000000133f <gets>:

char*
gets(char *buf, int max)
{
    133f:	f3 0f 1e fa          	endbr64 
    1343:	55                   	push   %rbp
    1344:	48 89 e5             	mov    %rsp,%rbp
    1347:	48 83 ec 20          	sub    $0x20,%rsp
    134b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    134f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1352:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1359:	eb 4f                	jmp    13aa <gets+0x6b>
    cc = read(0, &c, 1);
    135b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    135f:	ba 01 00 00 00       	mov    $0x1,%edx
    1364:	48 89 c6             	mov    %rax,%rsi
    1367:	bf 00 00 00 00       	mov    $0x0,%edi
    136c:	48 b8 24 15 00 00 00 	movabs $0x1524,%rax
    1373:	00 00 00 
    1376:	ff d0                	callq  *%rax
    1378:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    137b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    137f:	7e 36                	jle    13b7 <gets+0x78>
      break;
    buf[i++] = c;
    1381:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1384:	8d 50 01             	lea    0x1(%rax),%edx
    1387:	89 55 fc             	mov    %edx,-0x4(%rbp)
    138a:	48 63 d0             	movslq %eax,%rdx
    138d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1391:	48 01 c2             	add    %rax,%rdx
    1394:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1398:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    139a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    139e:	3c 0a                	cmp    $0xa,%al
    13a0:	74 16                	je     13b8 <gets+0x79>
    13a2:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13a6:	3c 0d                	cmp    $0xd,%al
    13a8:	74 0e                	je     13b8 <gets+0x79>
  for(i=0; i+1 < max; ){
    13aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13ad:	83 c0 01             	add    $0x1,%eax
    13b0:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    13b3:	7f a6                	jg     135b <gets+0x1c>
    13b5:	eb 01                	jmp    13b8 <gets+0x79>
      break;
    13b7:	90                   	nop
      break;
  }
  buf[i] = '\0';
    13b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13bb:	48 63 d0             	movslq %eax,%rdx
    13be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13c2:	48 01 d0             	add    %rdx,%rax
    13c5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    13c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13cc:	c9                   	leaveq 
    13cd:	c3                   	retq   

00000000000013ce <stat>:

int
stat(char *n, struct stat *st)
{
    13ce:	f3 0f 1e fa          	endbr64 
    13d2:	55                   	push   %rbp
    13d3:	48 89 e5             	mov    %rsp,%rbp
    13d6:	48 83 ec 20          	sub    $0x20,%rsp
    13da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13e6:	be 00 00 00 00       	mov    $0x0,%esi
    13eb:	48 89 c7             	mov    %rax,%rdi
    13ee:	48 b8 65 15 00 00 00 	movabs $0x1565,%rax
    13f5:	00 00 00 
    13f8:	ff d0                	callq  *%rax
    13fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    13fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1401:	79 07                	jns    140a <stat+0x3c>
    return -1;
    1403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1408:	eb 2f                	jmp    1439 <stat+0x6b>
  r = fstat(fd, st);
    140a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    140e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1411:	48 89 d6             	mov    %rdx,%rsi
    1414:	89 c7                	mov    %eax,%edi
    1416:	48 b8 8c 15 00 00 00 	movabs $0x158c,%rax
    141d:	00 00 00 
    1420:	ff d0                	callq  *%rax
    1422:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1425:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1428:	89 c7                	mov    %eax,%edi
    142a:	48 b8 3e 15 00 00 00 	movabs $0x153e,%rax
    1431:	00 00 00 
    1434:	ff d0                	callq  *%rax
  return r;
    1436:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1439:	c9                   	leaveq 
    143a:	c3                   	retq   

000000000000143b <atoi>:

int
atoi(const char *s)
{
    143b:	f3 0f 1e fa          	endbr64 
    143f:	55                   	push   %rbp
    1440:	48 89 e5             	mov    %rsp,%rbp
    1443:	48 83 ec 18          	sub    $0x18,%rsp
    1447:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    144b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1452:	eb 28                	jmp    147c <atoi+0x41>
    n = n*10 + *s++ - '0';
    1454:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1457:	89 d0                	mov    %edx,%eax
    1459:	c1 e0 02             	shl    $0x2,%eax
    145c:	01 d0                	add    %edx,%eax
    145e:	01 c0                	add    %eax,%eax
    1460:	89 c1                	mov    %eax,%ecx
    1462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1466:	48 8d 50 01          	lea    0x1(%rax),%rdx
    146a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    146e:	0f b6 00             	movzbl (%rax),%eax
    1471:	0f be c0             	movsbl %al,%eax
    1474:	01 c8                	add    %ecx,%eax
    1476:	83 e8 30             	sub    $0x30,%eax
    1479:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    147c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1480:	0f b6 00             	movzbl (%rax),%eax
    1483:	3c 2f                	cmp    $0x2f,%al
    1485:	7e 0b                	jle    1492 <atoi+0x57>
    1487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    148b:	0f b6 00             	movzbl (%rax),%eax
    148e:	3c 39                	cmp    $0x39,%al
    1490:	7e c2                	jle    1454 <atoi+0x19>
  return n;
    1492:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1495:	c9                   	leaveq 
    1496:	c3                   	retq   

0000000000001497 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1497:	f3 0f 1e fa          	endbr64 
    149b:	55                   	push   %rbp
    149c:	48 89 e5             	mov    %rsp,%rbp
    149f:	48 83 ec 28          	sub    $0x28,%rsp
    14a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    14ab:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    14ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    14b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    14be:	eb 1d                	jmp    14dd <memmove+0x46>
    *dst++ = *src++;
    14c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    14c4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    14cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14d0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14d4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    14d8:	0f b6 12             	movzbl (%rdx),%edx
    14db:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14e0:	8d 50 ff             	lea    -0x1(%rax),%edx
    14e3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14e6:	85 c0                	test   %eax,%eax
    14e8:	7f d6                	jg     14c0 <memmove+0x29>
  return vdst;
    14ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14ee:	c9                   	leaveq 
    14ef:	c3                   	retq   

00000000000014f0 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14f0:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14f7:	49 89 ca             	mov    %rcx,%r10
    14fa:	0f 05                	syscall 
    14fc:	c3                   	retq   

00000000000014fd <exit>:
SYSCALL(exit)
    14fd:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1504:	49 89 ca             	mov    %rcx,%r10
    1507:	0f 05                	syscall 
    1509:	c3                   	retq   

000000000000150a <wait>:
SYSCALL(wait)
    150a:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1511:	49 89 ca             	mov    %rcx,%r10
    1514:	0f 05                	syscall 
    1516:	c3                   	retq   

0000000000001517 <pipe>:
SYSCALL(pipe)
    1517:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    151e:	49 89 ca             	mov    %rcx,%r10
    1521:	0f 05                	syscall 
    1523:	c3                   	retq   

0000000000001524 <read>:
SYSCALL(read)
    1524:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    152b:	49 89 ca             	mov    %rcx,%r10
    152e:	0f 05                	syscall 
    1530:	c3                   	retq   

0000000000001531 <write>:
SYSCALL(write)
    1531:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1538:	49 89 ca             	mov    %rcx,%r10
    153b:	0f 05                	syscall 
    153d:	c3                   	retq   

000000000000153e <close>:
SYSCALL(close)
    153e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1545:	49 89 ca             	mov    %rcx,%r10
    1548:	0f 05                	syscall 
    154a:	c3                   	retq   

000000000000154b <kill>:
SYSCALL(kill)
    154b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1552:	49 89 ca             	mov    %rcx,%r10
    1555:	0f 05                	syscall 
    1557:	c3                   	retq   

0000000000001558 <exec>:
SYSCALL(exec)
    1558:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    155f:	49 89 ca             	mov    %rcx,%r10
    1562:	0f 05                	syscall 
    1564:	c3                   	retq   

0000000000001565 <open>:
SYSCALL(open)
    1565:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    156c:	49 89 ca             	mov    %rcx,%r10
    156f:	0f 05                	syscall 
    1571:	c3                   	retq   

0000000000001572 <mknod>:
SYSCALL(mknod)
    1572:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1579:	49 89 ca             	mov    %rcx,%r10
    157c:	0f 05                	syscall 
    157e:	c3                   	retq   

000000000000157f <unlink>:
SYSCALL(unlink)
    157f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1586:	49 89 ca             	mov    %rcx,%r10
    1589:	0f 05                	syscall 
    158b:	c3                   	retq   

000000000000158c <fstat>:
SYSCALL(fstat)
    158c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1593:	49 89 ca             	mov    %rcx,%r10
    1596:	0f 05                	syscall 
    1598:	c3                   	retq   

0000000000001599 <link>:
SYSCALL(link)
    1599:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    15a0:	49 89 ca             	mov    %rcx,%r10
    15a3:	0f 05                	syscall 
    15a5:	c3                   	retq   

00000000000015a6 <mkdir>:
SYSCALL(mkdir)
    15a6:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    15ad:	49 89 ca             	mov    %rcx,%r10
    15b0:	0f 05                	syscall 
    15b2:	c3                   	retq   

00000000000015b3 <chdir>:
SYSCALL(chdir)
    15b3:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    15ba:	49 89 ca             	mov    %rcx,%r10
    15bd:	0f 05                	syscall 
    15bf:	c3                   	retq   

00000000000015c0 <dup>:
SYSCALL(dup)
    15c0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    15c7:	49 89 ca             	mov    %rcx,%r10
    15ca:	0f 05                	syscall 
    15cc:	c3                   	retq   

00000000000015cd <getpid>:
SYSCALL(getpid)
    15cd:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    15d4:	49 89 ca             	mov    %rcx,%r10
    15d7:	0f 05                	syscall 
    15d9:	c3                   	retq   

00000000000015da <sbrk>:
SYSCALL(sbrk)
    15da:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15e1:	49 89 ca             	mov    %rcx,%r10
    15e4:	0f 05                	syscall 
    15e6:	c3                   	retq   

00000000000015e7 <sleep>:
SYSCALL(sleep)
    15e7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15ee:	49 89 ca             	mov    %rcx,%r10
    15f1:	0f 05                	syscall 
    15f3:	c3                   	retq   

00000000000015f4 <uptime>:
SYSCALL(uptime)
    15f4:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    15fb:	49 89 ca             	mov    %rcx,%r10
    15fe:	0f 05                	syscall 
    1600:	c3                   	retq   

0000000000001601 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1601:	f3 0f 1e fa          	endbr64 
    1605:	55                   	push   %rbp
    1606:	48 89 e5             	mov    %rsp,%rbp
    1609:	48 83 ec 10          	sub    $0x10,%rsp
    160d:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1610:	89 f0                	mov    %esi,%eax
    1612:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1615:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1619:	8b 45 fc             	mov    -0x4(%rbp),%eax
    161c:	ba 01 00 00 00       	mov    $0x1,%edx
    1621:	48 89 ce             	mov    %rcx,%rsi
    1624:	89 c7                	mov    %eax,%edi
    1626:	48 b8 31 15 00 00 00 	movabs $0x1531,%rax
    162d:	00 00 00 
    1630:	ff d0                	callq  *%rax
}
    1632:	90                   	nop
    1633:	c9                   	leaveq 
    1634:	c3                   	retq   

0000000000001635 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1635:	f3 0f 1e fa          	endbr64 
    1639:	55                   	push   %rbp
    163a:	48 89 e5             	mov    %rsp,%rbp
    163d:	48 83 ec 20          	sub    $0x20,%rsp
    1641:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1644:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1648:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    164f:	eb 35                	jmp    1686 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1651:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1655:	48 c1 e8 3c          	shr    $0x3c,%rax
    1659:	48 ba 50 27 00 00 00 	movabs $0x2750,%rdx
    1660:	00 00 00 
    1663:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1667:	0f be d0             	movsbl %al,%edx
    166a:	8b 45 ec             	mov    -0x14(%rbp),%eax
    166d:	89 d6                	mov    %edx,%esi
    166f:	89 c7                	mov    %eax,%edi
    1671:	48 b8 01 16 00 00 00 	movabs $0x1601,%rax
    1678:	00 00 00 
    167b:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    167d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1681:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1686:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1689:	83 f8 0f             	cmp    $0xf,%eax
    168c:	76 c3                	jbe    1651 <print_x64+0x1c>
}
    168e:	90                   	nop
    168f:	90                   	nop
    1690:	c9                   	leaveq 
    1691:	c3                   	retq   

0000000000001692 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1692:	f3 0f 1e fa          	endbr64 
    1696:	55                   	push   %rbp
    1697:	48 89 e5             	mov    %rsp,%rbp
    169a:	48 83 ec 20          	sub    $0x20,%rsp
    169e:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16a1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16ab:	eb 36                	jmp    16e3 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    16ad:	8b 45 e8             	mov    -0x18(%rbp),%eax
    16b0:	c1 e8 1c             	shr    $0x1c,%eax
    16b3:	89 c2                	mov    %eax,%edx
    16b5:	48 b8 50 27 00 00 00 	movabs $0x2750,%rax
    16bc:	00 00 00 
    16bf:	89 d2                	mov    %edx,%edx
    16c1:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    16c5:	0f be d0             	movsbl %al,%edx
    16c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16cb:	89 d6                	mov    %edx,%esi
    16cd:	89 c7                	mov    %eax,%edi
    16cf:	48 b8 01 16 00 00 00 	movabs $0x1601,%rax
    16d6:	00 00 00 
    16d9:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16df:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16e6:	83 f8 07             	cmp    $0x7,%eax
    16e9:	76 c2                	jbe    16ad <print_x32+0x1b>
}
    16eb:	90                   	nop
    16ec:	90                   	nop
    16ed:	c9                   	leaveq 
    16ee:	c3                   	retq   

00000000000016ef <print_d>:

  static void
print_d(int fd, int v)
{
    16ef:	f3 0f 1e fa          	endbr64 
    16f3:	55                   	push   %rbp
    16f4:	48 89 e5             	mov    %rsp,%rbp
    16f7:	48 83 ec 30          	sub    $0x30,%rsp
    16fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
    16fe:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1701:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1704:	48 98                	cltq   
    1706:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    170a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    170e:	79 04                	jns    1714 <print_d+0x25>
    x = -x;
    1710:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1714:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    171b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    171f:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1726:	66 66 66 
    1729:	48 89 c8             	mov    %rcx,%rax
    172c:	48 f7 ea             	imul   %rdx
    172f:	48 c1 fa 02          	sar    $0x2,%rdx
    1733:	48 89 c8             	mov    %rcx,%rax
    1736:	48 c1 f8 3f          	sar    $0x3f,%rax
    173a:	48 29 c2             	sub    %rax,%rdx
    173d:	48 89 d0             	mov    %rdx,%rax
    1740:	48 c1 e0 02          	shl    $0x2,%rax
    1744:	48 01 d0             	add    %rdx,%rax
    1747:	48 01 c0             	add    %rax,%rax
    174a:	48 29 c1             	sub    %rax,%rcx
    174d:	48 89 ca             	mov    %rcx,%rdx
    1750:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1753:	8d 48 01             	lea    0x1(%rax),%ecx
    1756:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1759:	48 b9 50 27 00 00 00 	movabs $0x2750,%rcx
    1760:	00 00 00 
    1763:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1767:	48 98                	cltq   
    1769:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    176d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1771:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1778:	66 66 66 
    177b:	48 89 c8             	mov    %rcx,%rax
    177e:	48 f7 ea             	imul   %rdx
    1781:	48 c1 fa 02          	sar    $0x2,%rdx
    1785:	48 89 c8             	mov    %rcx,%rax
    1788:	48 c1 f8 3f          	sar    $0x3f,%rax
    178c:	48 29 c2             	sub    %rax,%rdx
    178f:	48 89 d0             	mov    %rdx,%rax
    1792:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1796:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    179b:	0f 85 7a ff ff ff    	jne    171b <print_d+0x2c>

  if (v < 0)
    17a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17a5:	79 32                	jns    17d9 <print_d+0xea>
    buf[i++] = '-';
    17a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17aa:	8d 50 01             	lea    0x1(%rax),%edx
    17ad:	89 55 f4             	mov    %edx,-0xc(%rbp)
    17b0:	48 98                	cltq   
    17b2:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    17b7:	eb 20                	jmp    17d9 <print_d+0xea>
    putc(fd, buf[i]);
    17b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17bc:	48 98                	cltq   
    17be:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    17c3:	0f be d0             	movsbl %al,%edx
    17c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17c9:	89 d6                	mov    %edx,%esi
    17cb:	89 c7                	mov    %eax,%edi
    17cd:	48 b8 01 16 00 00 00 	movabs $0x1601,%rax
    17d4:	00 00 00 
    17d7:	ff d0                	callq  *%rax
  while (--i >= 0)
    17d9:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17e1:	79 d6                	jns    17b9 <print_d+0xca>
}
    17e3:	90                   	nop
    17e4:	90                   	nop
    17e5:	c9                   	leaveq 
    17e6:	c3                   	retq   

00000000000017e7 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    17e7:	f3 0f 1e fa          	endbr64 
    17eb:	55                   	push   %rbp
    17ec:	48 89 e5             	mov    %rsp,%rbp
    17ef:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    17f6:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    17fc:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1803:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    180a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1811:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1818:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    181f:	84 c0                	test   %al,%al
    1821:	74 20                	je     1843 <printf+0x5c>
    1823:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1827:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    182b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    182f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1833:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1837:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    183b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    183f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1843:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    184a:	00 00 00 
    184d:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1854:	00 00 00 
    1857:	48 8d 45 10          	lea    0x10(%rbp),%rax
    185b:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1862:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1869:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1870:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1877:	00 00 00 
    187a:	e9 41 03 00 00       	jmpq   1bc0 <printf+0x3d9>
    if (c != '%') {
    187f:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1886:	74 24                	je     18ac <printf+0xc5>
      putc(fd, c);
    1888:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    188e:	0f be d0             	movsbl %al,%edx
    1891:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1897:	89 d6                	mov    %edx,%esi
    1899:	89 c7                	mov    %eax,%edi
    189b:	48 b8 01 16 00 00 00 	movabs $0x1601,%rax
    18a2:	00 00 00 
    18a5:	ff d0                	callq  *%rax
      continue;
    18a7:	e9 0d 03 00 00       	jmpq   1bb9 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    18ac:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    18b3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    18b9:	48 63 d0             	movslq %eax,%rdx
    18bc:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    18c3:	48 01 d0             	add    %rdx,%rax
    18c6:	0f b6 00             	movzbl (%rax),%eax
    18c9:	0f be c0             	movsbl %al,%eax
    18cc:	25 ff 00 00 00       	and    $0xff,%eax
    18d1:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18d7:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18de:	0f 84 0f 03 00 00    	je     1bf3 <printf+0x40c>
      break;
    switch(c) {
    18e4:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18eb:	0f 84 74 02 00 00    	je     1b65 <printf+0x37e>
    18f1:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18f8:	0f 8c 82 02 00 00    	jl     1b80 <printf+0x399>
    18fe:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1905:	0f 8f 75 02 00 00    	jg     1b80 <printf+0x399>
    190b:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1912:	0f 8c 68 02 00 00    	jl     1b80 <printf+0x399>
    1918:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    191e:	83 e8 63             	sub    $0x63,%eax
    1921:	83 f8 15             	cmp    $0x15,%eax
    1924:	0f 87 56 02 00 00    	ja     1b80 <printf+0x399>
    192a:	89 c0                	mov    %eax,%eax
    192c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1933:	00 
    1934:	48 b8 40 23 00 00 00 	movabs $0x2340,%rax
    193b:	00 00 00 
    193e:	48 01 d0             	add    %rdx,%rax
    1941:	48 8b 00             	mov    (%rax),%rax
    1944:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1947:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    194d:	83 f8 2f             	cmp    $0x2f,%eax
    1950:	77 23                	ja     1975 <printf+0x18e>
    1952:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1959:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    195f:	89 d2                	mov    %edx,%edx
    1961:	48 01 d0             	add    %rdx,%rax
    1964:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    196a:	83 c2 08             	add    $0x8,%edx
    196d:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1973:	eb 12                	jmp    1987 <printf+0x1a0>
    1975:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    197c:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1980:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1987:	8b 00                	mov    (%rax),%eax
    1989:	0f be d0             	movsbl %al,%edx
    198c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1992:	89 d6                	mov    %edx,%esi
    1994:	89 c7                	mov    %eax,%edi
    1996:	48 b8 01 16 00 00 00 	movabs $0x1601,%rax
    199d:	00 00 00 
    19a0:	ff d0                	callq  *%rax
      break;
    19a2:	e9 12 02 00 00       	jmpq   1bb9 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    19a7:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19ad:	83 f8 2f             	cmp    $0x2f,%eax
    19b0:	77 23                	ja     19d5 <printf+0x1ee>
    19b2:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19b9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19bf:	89 d2                	mov    %edx,%edx
    19c1:	48 01 d0             	add    %rdx,%rax
    19c4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19ca:	83 c2 08             	add    $0x8,%edx
    19cd:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19d3:	eb 12                	jmp    19e7 <printf+0x200>
    19d5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19dc:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19e0:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19e7:	8b 10                	mov    (%rax),%edx
    19e9:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19ef:	89 d6                	mov    %edx,%esi
    19f1:	89 c7                	mov    %eax,%edi
    19f3:	48 b8 ef 16 00 00 00 	movabs $0x16ef,%rax
    19fa:	00 00 00 
    19fd:	ff d0                	callq  *%rax
      break;
    19ff:	e9 b5 01 00 00       	jmpq   1bb9 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1a04:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a0a:	83 f8 2f             	cmp    $0x2f,%eax
    1a0d:	77 23                	ja     1a32 <printf+0x24b>
    1a0f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a16:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a1c:	89 d2                	mov    %edx,%edx
    1a1e:	48 01 d0             	add    %rdx,%rax
    1a21:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a27:	83 c2 08             	add    $0x8,%edx
    1a2a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a30:	eb 12                	jmp    1a44 <printf+0x25d>
    1a32:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a39:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a3d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a44:	8b 10                	mov    (%rax),%edx
    1a46:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a4c:	89 d6                	mov    %edx,%esi
    1a4e:	89 c7                	mov    %eax,%edi
    1a50:	48 b8 92 16 00 00 00 	movabs $0x1692,%rax
    1a57:	00 00 00 
    1a5a:	ff d0                	callq  *%rax
      break;
    1a5c:	e9 58 01 00 00       	jmpq   1bb9 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a61:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a67:	83 f8 2f             	cmp    $0x2f,%eax
    1a6a:	77 23                	ja     1a8f <printf+0x2a8>
    1a6c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a73:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a79:	89 d2                	mov    %edx,%edx
    1a7b:	48 01 d0             	add    %rdx,%rax
    1a7e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a84:	83 c2 08             	add    $0x8,%edx
    1a87:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a8d:	eb 12                	jmp    1aa1 <printf+0x2ba>
    1a8f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a96:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a9a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1aa1:	48 8b 10             	mov    (%rax),%rdx
    1aa4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aaa:	48 89 d6             	mov    %rdx,%rsi
    1aad:	89 c7                	mov    %eax,%edi
    1aaf:	48 b8 35 16 00 00 00 	movabs $0x1635,%rax
    1ab6:	00 00 00 
    1ab9:	ff d0                	callq  *%rax
      break;
    1abb:	e9 f9 00 00 00       	jmpq   1bb9 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1ac0:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ac6:	83 f8 2f             	cmp    $0x2f,%eax
    1ac9:	77 23                	ja     1aee <printf+0x307>
    1acb:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ad2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ad8:	89 d2                	mov    %edx,%edx
    1ada:	48 01 d0             	add    %rdx,%rax
    1add:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ae3:	83 c2 08             	add    $0x8,%edx
    1ae6:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1aec:	eb 12                	jmp    1b00 <printf+0x319>
    1aee:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1af5:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1af9:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b00:	48 8b 00             	mov    (%rax),%rax
    1b03:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1b0a:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b11:	00 
    1b12:	75 41                	jne    1b55 <printf+0x36e>
        s = "(null)";
    1b14:	48 b8 38 23 00 00 00 	movabs $0x2338,%rax
    1b1b:	00 00 00 
    1b1e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b25:	eb 2e                	jmp    1b55 <printf+0x36e>
        putc(fd, *(s++));
    1b27:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b2e:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b32:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b39:	0f b6 00             	movzbl (%rax),%eax
    1b3c:	0f be d0             	movsbl %al,%edx
    1b3f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b45:	89 d6                	mov    %edx,%esi
    1b47:	89 c7                	mov    %eax,%edi
    1b49:	48 b8 01 16 00 00 00 	movabs $0x1601,%rax
    1b50:	00 00 00 
    1b53:	ff d0                	callq  *%rax
      while (*s)
    1b55:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b5c:	0f b6 00             	movzbl (%rax),%eax
    1b5f:	84 c0                	test   %al,%al
    1b61:	75 c4                	jne    1b27 <printf+0x340>
      break;
    1b63:	eb 54                	jmp    1bb9 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b65:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b6b:	be 25 00 00 00       	mov    $0x25,%esi
    1b70:	89 c7                	mov    %eax,%edi
    1b72:	48 b8 01 16 00 00 00 	movabs $0x1601,%rax
    1b79:	00 00 00 
    1b7c:	ff d0                	callq  *%rax
      break;
    1b7e:	eb 39                	jmp    1bb9 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b80:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b86:	be 25 00 00 00       	mov    $0x25,%esi
    1b8b:	89 c7                	mov    %eax,%edi
    1b8d:	48 b8 01 16 00 00 00 	movabs $0x1601,%rax
    1b94:	00 00 00 
    1b97:	ff d0                	callq  *%rax
      putc(fd, c);
    1b99:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b9f:	0f be d0             	movsbl %al,%edx
    1ba2:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ba8:	89 d6                	mov    %edx,%esi
    1baa:	89 c7                	mov    %eax,%edi
    1bac:	48 b8 01 16 00 00 00 	movabs $0x1601,%rax
    1bb3:	00 00 00 
    1bb6:	ff d0                	callq  *%rax
      break;
    1bb8:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1bb9:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1bc0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1bc6:	48 63 d0             	movslq %eax,%rdx
    1bc9:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bd0:	48 01 d0             	add    %rdx,%rax
    1bd3:	0f b6 00             	movzbl (%rax),%eax
    1bd6:	0f be c0             	movsbl %al,%eax
    1bd9:	25 ff 00 00 00       	and    $0xff,%eax
    1bde:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1be4:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1beb:	0f 85 8e fc ff ff    	jne    187f <printf+0x98>
    }
  }
}
    1bf1:	eb 01                	jmp    1bf4 <printf+0x40d>
      break;
    1bf3:	90                   	nop
}
    1bf4:	90                   	nop
    1bf5:	c9                   	leaveq 
    1bf6:	c3                   	retq   

0000000000001bf7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1bf7:	f3 0f 1e fa          	endbr64 
    1bfb:	55                   	push   %rbp
    1bfc:	48 89 e5             	mov    %rsp,%rbp
    1bff:	48 83 ec 18          	sub    $0x18,%rsp
    1c03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c0b:	48 83 e8 10          	sub    $0x10,%rax
    1c0f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c13:	48 b8 90 29 00 00 00 	movabs $0x2990,%rax
    1c1a:	00 00 00 
    1c1d:	48 8b 00             	mov    (%rax),%rax
    1c20:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c24:	eb 2f                	jmp    1c55 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c2a:	48 8b 00             	mov    (%rax),%rax
    1c2d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c31:	72 17                	jb     1c4a <free+0x53>
    1c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c37:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c3b:	77 2f                	ja     1c6c <free+0x75>
    1c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c41:	48 8b 00             	mov    (%rax),%rax
    1c44:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c48:	72 22                	jb     1c6c <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c4e:	48 8b 00             	mov    (%rax),%rax
    1c51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c59:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c5d:	76 c7                	jbe    1c26 <free+0x2f>
    1c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c63:	48 8b 00             	mov    (%rax),%rax
    1c66:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c6a:	73 ba                	jae    1c26 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c70:	8b 40 08             	mov    0x8(%rax),%eax
    1c73:	89 c0                	mov    %eax,%eax
    1c75:	48 c1 e0 04          	shl    $0x4,%rax
    1c79:	48 89 c2             	mov    %rax,%rdx
    1c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c80:	48 01 c2             	add    %rax,%rdx
    1c83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c87:	48 8b 00             	mov    (%rax),%rax
    1c8a:	48 39 c2             	cmp    %rax,%rdx
    1c8d:	75 2d                	jne    1cbc <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c93:	8b 50 08             	mov    0x8(%rax),%edx
    1c96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c9a:	48 8b 00             	mov    (%rax),%rax
    1c9d:	8b 40 08             	mov    0x8(%rax),%eax
    1ca0:	01 c2                	add    %eax,%edx
    1ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca6:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1ca9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cad:	48 8b 00             	mov    (%rax),%rax
    1cb0:	48 8b 10             	mov    (%rax),%rdx
    1cb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb7:	48 89 10             	mov    %rdx,(%rax)
    1cba:	eb 0e                	jmp    1cca <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc0:	48 8b 10             	mov    (%rax),%rdx
    1cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc7:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1cca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cce:	8b 40 08             	mov    0x8(%rax),%eax
    1cd1:	89 c0                	mov    %eax,%eax
    1cd3:	48 c1 e0 04          	shl    $0x4,%rax
    1cd7:	48 89 c2             	mov    %rax,%rdx
    1cda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cde:	48 01 d0             	add    %rdx,%rax
    1ce1:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1ce5:	75 27                	jne    1d0e <free+0x117>
    p->s.size += bp->s.size;
    1ce7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ceb:	8b 50 08             	mov    0x8(%rax),%edx
    1cee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cf2:	8b 40 08             	mov    0x8(%rax),%eax
    1cf5:	01 c2                	add    %eax,%edx
    1cf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cfb:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1cfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d02:	48 8b 10             	mov    (%rax),%rdx
    1d05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d09:	48 89 10             	mov    %rdx,(%rax)
    1d0c:	eb 0b                	jmp    1d19 <free+0x122>
  } else
    p->s.ptr = bp;
    1d0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1d16:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1d19:	48 ba 90 29 00 00 00 	movabs $0x2990,%rdx
    1d20:	00 00 00 
    1d23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d27:	48 89 02             	mov    %rax,(%rdx)
}
    1d2a:	90                   	nop
    1d2b:	c9                   	leaveq 
    1d2c:	c3                   	retq   

0000000000001d2d <morecore>:

static Header*
morecore(uint nu)
{
    1d2d:	f3 0f 1e fa          	endbr64 
    1d31:	55                   	push   %rbp
    1d32:	48 89 e5             	mov    %rsp,%rbp
    1d35:	48 83 ec 20          	sub    $0x20,%rsp
    1d39:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d3c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d43:	77 07                	ja     1d4c <morecore+0x1f>
    nu = 4096;
    1d45:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d4f:	48 c1 e0 04          	shl    $0x4,%rax
    1d53:	48 89 c7             	mov    %rax,%rdi
    1d56:	48 b8 da 15 00 00 00 	movabs $0x15da,%rax
    1d5d:	00 00 00 
    1d60:	ff d0                	callq  *%rax
    1d62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d66:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d6b:	75 07                	jne    1d74 <morecore+0x47>
    return 0;
    1d6d:	b8 00 00 00 00       	mov    $0x0,%eax
    1d72:	eb 36                	jmp    1daa <morecore+0x7d>
  hp = (Header*)p;
    1d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d78:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d80:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d83:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d8a:	48 83 c0 10          	add    $0x10,%rax
    1d8e:	48 89 c7             	mov    %rax,%rdi
    1d91:	48 b8 f7 1b 00 00 00 	movabs $0x1bf7,%rax
    1d98:	00 00 00 
    1d9b:	ff d0                	callq  *%rax
  return freep;
    1d9d:	48 b8 90 29 00 00 00 	movabs $0x2990,%rax
    1da4:	00 00 00 
    1da7:	48 8b 00             	mov    (%rax),%rax
}
    1daa:	c9                   	leaveq 
    1dab:	c3                   	retq   

0000000000001dac <malloc>:

void*
malloc(uint nbytes)
{
    1dac:	f3 0f 1e fa          	endbr64 
    1db0:	55                   	push   %rbp
    1db1:	48 89 e5             	mov    %rsp,%rbp
    1db4:	48 83 ec 30          	sub    $0x30,%rsp
    1db8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1dbb:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1dbe:	48 83 c0 0f          	add    $0xf,%rax
    1dc2:	48 c1 e8 04          	shr    $0x4,%rax
    1dc6:	83 c0 01             	add    $0x1,%eax
    1dc9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1dcc:	48 b8 90 29 00 00 00 	movabs $0x2990,%rax
    1dd3:	00 00 00 
    1dd6:	48 8b 00             	mov    (%rax),%rax
    1dd9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ddd:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1de2:	75 4a                	jne    1e2e <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1de4:	48 b8 80 29 00 00 00 	movabs $0x2980,%rax
    1deb:	00 00 00 
    1dee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1df2:	48 ba 90 29 00 00 00 	movabs $0x2990,%rdx
    1df9:	00 00 00 
    1dfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e00:	48 89 02             	mov    %rax,(%rdx)
    1e03:	48 b8 90 29 00 00 00 	movabs $0x2990,%rax
    1e0a:	00 00 00 
    1e0d:	48 8b 00             	mov    (%rax),%rax
    1e10:	48 ba 80 29 00 00 00 	movabs $0x2980,%rdx
    1e17:	00 00 00 
    1e1a:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1e1d:	48 b8 80 29 00 00 00 	movabs $0x2980,%rax
    1e24:	00 00 00 
    1e27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e32:	48 8b 00             	mov    (%rax),%rax
    1e35:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e3d:	8b 40 08             	mov    0x8(%rax),%eax
    1e40:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e43:	77 65                	ja     1eaa <malloc+0xfe>
      if(p->s.size == nunits)
    1e45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e49:	8b 40 08             	mov    0x8(%rax),%eax
    1e4c:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e4f:	75 10                	jne    1e61 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1e51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e55:	48 8b 10             	mov    (%rax),%rdx
    1e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e5c:	48 89 10             	mov    %rdx,(%rax)
    1e5f:	eb 2e                	jmp    1e8f <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e65:	8b 40 08             	mov    0x8(%rax),%eax
    1e68:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e6b:	89 c2                	mov    %eax,%edx
    1e6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e71:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e78:	8b 40 08             	mov    0x8(%rax),%eax
    1e7b:	89 c0                	mov    %eax,%eax
    1e7d:	48 c1 e0 04          	shl    $0x4,%rax
    1e81:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e89:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e8c:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e8f:	48 ba 90 29 00 00 00 	movabs $0x2990,%rdx
    1e96:	00 00 00 
    1e99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e9d:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ea4:	48 83 c0 10          	add    $0x10,%rax
    1ea8:	eb 4e                	jmp    1ef8 <malloc+0x14c>
    }
    if(p == freep)
    1eaa:	48 b8 90 29 00 00 00 	movabs $0x2990,%rax
    1eb1:	00 00 00 
    1eb4:	48 8b 00             	mov    (%rax),%rax
    1eb7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ebb:	75 23                	jne    1ee0 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1ebd:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ec0:	89 c7                	mov    %eax,%edi
    1ec2:	48 b8 2d 1d 00 00 00 	movabs $0x1d2d,%rax
    1ec9:	00 00 00 
    1ecc:	ff d0                	callq  *%rax
    1ece:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ed2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1ed7:	75 07                	jne    1ee0 <malloc+0x134>
        return 0;
    1ed9:	b8 00 00 00 00       	mov    $0x0,%eax
    1ede:	eb 18                	jmp    1ef8 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ee0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ee4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ee8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eec:	48 8b 00             	mov    (%rax),%rax
    1eef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ef3:	e9 41 ff ff ff       	jmpq   1e39 <malloc+0x8d>
  }
}
    1ef8:	c9                   	leaveq 
    1ef9:	c3                   	retq   

0000000000001efa <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1efa:	f3 0f 1e fa          	endbr64 
    1efe:	55                   	push   %rbp
    1eff:	48 89 e5             	mov    %rsp,%rbp
    1f02:	48 83 ec 30          	sub    $0x30,%rsp
    1f06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1f0a:	bf 18 00 00 00       	mov    $0x18,%edi
    1f0f:	48 b8 ac 1d 00 00 00 	movabs $0x1dac,%rax
    1f16:	00 00 00 
    1f19:	ff d0                	callq  *%rax
    1f1b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1f1f:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1f24:	75 0a                	jne    1f30 <co_new+0x36>
    return 0;
    1f26:	b8 00 00 00 00       	mov    $0x0,%eax
    1f2b:	e9 e1 00 00 00       	jmpq   2011 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1f30:	bf 00 20 00 00       	mov    $0x2000,%edi
    1f35:	48 b8 ac 1d 00 00 00 	movabs $0x1dac,%rax
    1f3c:	00 00 00 
    1f3f:	ff d0                	callq  *%rax
    1f41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1f45:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1f49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f4d:	48 8b 40 10          	mov    0x10(%rax),%rax
    1f51:	48 85 c0             	test   %rax,%rax
    1f54:	75 1d                	jne    1f73 <co_new+0x79>
    free(co1);
    1f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f5a:	48 89 c7             	mov    %rax,%rdi
    1f5d:	48 b8 f7 1b 00 00 00 	movabs $0x1bf7,%rax
    1f64:	00 00 00 
    1f67:	ff d0                	callq  *%rax
    return 0;
    1f69:	b8 00 00 00 00       	mov    $0x0,%eax
    1f6e:	e9 9e 00 00 00       	jmpq   2011 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1f73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f77:	48 8b 40 10          	mov    0x10(%rax),%rax
    1f7b:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    1f81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    1f85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f89:	48 8d 50 30          	lea    0x30(%rax),%rdx
    1f8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1f91:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    1f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f98:	48 83 c0 38          	add    $0x38,%rax
    1f9c:	48 ba 83 21 00 00 00 	movabs $0x2183,%rdx
    1fa3:	00 00 00 
    1fa6:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    1fa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1fb1:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    1fb4:	48 b8 a8 29 00 00 00 	movabs $0x29a8,%rax
    1fbb:	00 00 00 
    1fbe:	48 8b 00             	mov    (%rax),%rax
    1fc1:	48 85 c0             	test   %rax,%rax
    1fc4:	75 13                	jne    1fd9 <co_new+0xdf>
  {
  	co_list = co1;
    1fc6:	48 ba a8 29 00 00 00 	movabs $0x29a8,%rdx
    1fcd:	00 00 00 
    1fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fd4:	48 89 02             	mov    %rax,(%rdx)
    1fd7:	eb 34                	jmp    200d <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    1fd9:	48 b8 a8 29 00 00 00 	movabs $0x29a8,%rax
    1fe0:	00 00 00 
    1fe3:	48 8b 00             	mov    (%rax),%rax
    1fe6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1fea:	eb 0c                	jmp    1ff8 <co_new+0xfe>
	{
		head = head->next;
    1fec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ff0:	48 8b 40 08          	mov    0x8(%rax),%rax
    1ff4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1ff8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ffc:	48 8b 40 08          	mov    0x8(%rax),%rax
    2000:	48 85 c0             	test   %rax,%rax
    2003:	75 e7                	jne    1fec <co_new+0xf2>
	}
	head = co1;
    2005:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2009:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    200d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    2011:	c9                   	leaveq 
    2012:	c3                   	retq   

0000000000002013 <co_run>:

  int
co_run(void)
{
    2013:	f3 0f 1e fa          	endbr64 
    2017:	55                   	push   %rbp
    2018:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    201b:	48 b8 a8 29 00 00 00 	movabs $0x29a8,%rax
    2022:	00 00 00 
    2025:	48 8b 00             	mov    (%rax),%rax
    2028:	48 85 c0             	test   %rax,%rax
    202b:	74 4a                	je     2077 <co_run+0x64>
	{
		co_current = co_list;
    202d:	48 b8 a8 29 00 00 00 	movabs $0x29a8,%rax
    2034:	00 00 00 
    2037:	48 8b 00             	mov    (%rax),%rax
    203a:	48 ba a0 29 00 00 00 	movabs $0x29a0,%rdx
    2041:	00 00 00 
    2044:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    2047:	48 b8 a0 29 00 00 00 	movabs $0x29a0,%rax
    204e:	00 00 00 
    2051:	48 8b 00             	mov    (%rax),%rax
    2054:	48 8b 00             	mov    (%rax),%rax
    2057:	48 89 c6             	mov    %rax,%rsi
    205a:	48 bf 98 29 00 00 00 	movabs $0x2998,%rdi
    2061:	00 00 00 
    2064:	48 b8 e5 22 00 00 00 	movabs $0x22e5,%rax
    206b:	00 00 00 
    206e:	ff d0                	callq  *%rax
		return 1;
    2070:	b8 01 00 00 00       	mov    $0x1,%eax
    2075:	eb 05                	jmp    207c <co_run+0x69>
	}
	return 0;
    2077:	b8 00 00 00 00       	mov    $0x0,%eax
}
    207c:	5d                   	pop    %rbp
    207d:	c3                   	retq   

000000000000207e <co_run_all>:

  int
co_run_all(void)
{
    207e:	f3 0f 1e fa          	endbr64 
    2082:	55                   	push   %rbp
    2083:	48 89 e5             	mov    %rsp,%rbp
    2086:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    208a:	48 b8 a8 29 00 00 00 	movabs $0x29a8,%rax
    2091:	00 00 00 
    2094:	48 8b 00             	mov    (%rax),%rax
    2097:	48 85 c0             	test   %rax,%rax
    209a:	75 07                	jne    20a3 <co_run_all+0x25>
		return 0;
    209c:	b8 00 00 00 00       	mov    $0x0,%eax
    20a1:	eb 37                	jmp    20da <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    20a3:	48 b8 a8 29 00 00 00 	movabs $0x29a8,%rax
    20aa:	00 00 00 
    20ad:	48 8b 00             	mov    (%rax),%rax
    20b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    20b4:	eb 18                	jmp    20ce <co_run_all+0x50>
			co_run();
    20b6:	48 b8 13 20 00 00 00 	movabs $0x2013,%rax
    20bd:	00 00 00 
    20c0:	ff d0                	callq  *%rax
			tmp = tmp->next;
    20c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20c6:	48 8b 40 08          	mov    0x8(%rax),%rax
    20ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    20ce:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    20d3:	75 e1                	jne    20b6 <co_run_all+0x38>
		}
		return 1;
    20d5:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    20da:	c9                   	leaveq 
    20db:	c3                   	retq   

00000000000020dc <co_yield>:

  void
co_yield()
{
    20dc:	f3 0f 1e fa          	endbr64 
    20e0:	55                   	push   %rbp
    20e1:	48 89 e5             	mov    %rsp,%rbp
    20e4:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    20e8:	48 b8 a0 29 00 00 00 	movabs $0x29a0,%rax
    20ef:	00 00 00 
    20f2:	48 8b 00             	mov    (%rax),%rax
    20f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    20f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20fd:	48 8b 40 08          	mov    0x8(%rax),%rax
    2101:	48 85 c0             	test   %rax,%rax
    2104:	74 46                	je     214c <co_yield+0x70>
  {
  	co_current = co_current->next;
    2106:	48 b8 a0 29 00 00 00 	movabs $0x29a0,%rax
    210d:	00 00 00 
    2110:	48 8b 00             	mov    (%rax),%rax
    2113:	48 8b 40 08          	mov    0x8(%rax),%rax
    2117:	48 ba a0 29 00 00 00 	movabs $0x29a0,%rdx
    211e:	00 00 00 
    2121:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    2124:	48 b8 a0 29 00 00 00 	movabs $0x29a0,%rax
    212b:	00 00 00 
    212e:	48 8b 00             	mov    (%rax),%rax
    2131:	48 8b 10             	mov    (%rax),%rdx
    2134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2138:	48 89 d6             	mov    %rdx,%rsi
    213b:	48 89 c7             	mov    %rax,%rdi
    213e:	48 b8 e5 22 00 00 00 	movabs $0x22e5,%rax
    2145:	00 00 00 
    2148:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    214a:	eb 34                	jmp    2180 <co_yield+0xa4>
	co_current = 0;
    214c:	48 b8 a0 29 00 00 00 	movabs $0x29a0,%rax
    2153:	00 00 00 
    2156:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    215d:	48 b8 98 29 00 00 00 	movabs $0x2998,%rax
    2164:	00 00 00 
    2167:	48 8b 10             	mov    (%rax),%rdx
    216a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    216e:	48 89 d6             	mov    %rdx,%rsi
    2171:	48 89 c7             	mov    %rax,%rdi
    2174:	48 b8 e5 22 00 00 00 	movabs $0x22e5,%rax
    217b:	00 00 00 
    217e:	ff d0                	callq  *%rax
}
    2180:	90                   	nop
    2181:	c9                   	leaveq 
    2182:	c3                   	retq   

0000000000002183 <co_exit>:

  void
co_exit(void)
{
    2183:	f3 0f 1e fa          	endbr64 
    2187:	55                   	push   %rbp
    2188:	48 89 e5             	mov    %rsp,%rbp
    218b:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    218f:	48 b8 a0 29 00 00 00 	movabs $0x29a0,%rax
    2196:	00 00 00 
    2199:	48 8b 00             	mov    (%rax),%rax
    219c:	48 85 c0             	test   %rax,%rax
    219f:	0f 84 ec 00 00 00    	je     2291 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    21a5:	48 b8 a8 29 00 00 00 	movabs $0x29a8,%rax
    21ac:	00 00 00 
    21af:	48 8b 00             	mov    (%rax),%rax
    21b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    21b6:	e9 c9 00 00 00       	jmpq   2284 <co_exit+0x101>
		if(tmp == co_current)
    21bb:	48 b8 a0 29 00 00 00 	movabs $0x29a0,%rax
    21c2:	00 00 00 
    21c5:	48 8b 00             	mov    (%rax),%rax
    21c8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    21cc:	0f 85 9e 00 00 00    	jne    2270 <co_exit+0xed>
		{
			if(tmp->next)
    21d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21d6:	48 8b 40 08          	mov    0x8(%rax),%rax
    21da:	48 85 c0             	test   %rax,%rax
    21dd:	74 54                	je     2233 <co_exit+0xb0>
			{
				if(prev)
    21df:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    21e4:	74 10                	je     21f6 <co_exit+0x73>
				{
					prev->next = tmp->next;
    21e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21ea:	48 8b 50 08          	mov    0x8(%rax),%rdx
    21ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    21f2:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    21f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21fa:	48 8b 40 08          	mov    0x8(%rax),%rax
    21fe:	48 ba a8 29 00 00 00 	movabs $0x29a8,%rdx
    2205:	00 00 00 
    2208:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    220b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    220f:	48 8b 00             	mov    (%rax),%rax
    2212:	48 ba a0 29 00 00 00 	movabs $0x29a0,%rdx
    2219:	00 00 00 
    221c:	48 8b 12             	mov    (%rdx),%rdx
    221f:	48 89 c6             	mov    %rax,%rsi
    2222:	48 89 d7             	mov    %rdx,%rdi
    2225:	48 b8 e5 22 00 00 00 	movabs $0x22e5,%rax
    222c:	00 00 00 
    222f:	ff d0                	callq  *%rax
    2231:	eb 3d                	jmp    2270 <co_exit+0xed>
			}else{
				co_list = 0;
    2233:	48 b8 a8 29 00 00 00 	movabs $0x29a8,%rax
    223a:	00 00 00 
    223d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    2244:	48 b8 98 29 00 00 00 	movabs $0x2998,%rax
    224b:	00 00 00 
    224e:	48 8b 00             	mov    (%rax),%rax
    2251:	48 ba a0 29 00 00 00 	movabs $0x29a0,%rdx
    2258:	00 00 00 
    225b:	48 8b 12             	mov    (%rdx),%rdx
    225e:	48 89 c6             	mov    %rax,%rsi
    2261:	48 89 d7             	mov    %rdx,%rdi
    2264:	48 b8 e5 22 00 00 00 	movabs $0x22e5,%rax
    226b:	00 00 00 
    226e:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    2270:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2274:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    2278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    227c:	48 8b 40 08          	mov    0x8(%rax),%rax
    2280:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    2284:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2289:	0f 85 2c ff ff ff    	jne    21bb <co_exit+0x38>
    228f:	eb 01                	jmp    2292 <co_exit+0x10f>
		return;
    2291:	90                   	nop
	}
}
    2292:	c9                   	leaveq 
    2293:	c3                   	retq   

0000000000002294 <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    2294:	f3 0f 1e fa          	endbr64 
    2298:	55                   	push   %rbp
    2299:	48 89 e5             	mov    %rsp,%rbp
    229c:	48 83 ec 10          	sub    $0x10,%rsp
    22a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    22a4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    22a9:	74 37                	je     22e2 <co_destroy+0x4e>
    if (co->stack)
    22ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22af:	48 8b 40 10          	mov    0x10(%rax),%rax
    22b3:	48 85 c0             	test   %rax,%rax
    22b6:	74 17                	je     22cf <co_destroy+0x3b>
      free(co->stack);
    22b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22bc:	48 8b 40 10          	mov    0x10(%rax),%rax
    22c0:	48 89 c7             	mov    %rax,%rdi
    22c3:	48 b8 f7 1b 00 00 00 	movabs $0x1bf7,%rax
    22ca:	00 00 00 
    22cd:	ff d0                	callq  *%rax
    free(co);
    22cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22d3:	48 89 c7             	mov    %rax,%rdi
    22d6:	48 b8 f7 1b 00 00 00 	movabs $0x1bf7,%rax
    22dd:	00 00 00 
    22e0:	ff d0                	callq  *%rax
  }
}
    22e2:	90                   	nop
    22e3:	c9                   	leaveq 
    22e4:	c3                   	retq   

00000000000022e5 <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    22e5:	55                   	push   %rbp
  pushq   %rbx
    22e6:	53                   	push   %rbx
  pushq   %r12
    22e7:	41 54                	push   %r12
  pushq   %r13
    22e9:	41 55                	push   %r13
  pushq   %r14
    22eb:	41 56                	push   %r14
  pushq   %r15
    22ed:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    22ef:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    22f2:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    22f5:	41 5f                	pop    %r15
  popq    %r14
    22f7:	41 5e                	pop    %r14
  popq    %r13
    22f9:	41 5d                	pop    %r13
  popq    %r12
    22fb:	41 5c                	pop    %r12
  popq    %rbx
    22fd:	5b                   	pop    %rbx
  popq    %rbp
    22fe:	5d                   	pop    %rbp

  retq #??
    22ff:	c3                   	retq   
