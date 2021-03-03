
_ln:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 10          	sub    $0x10,%rsp
    100c:	89 7d fc             	mov    %edi,-0x4(%rbp)
    100f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(argc != 3){
    1013:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    1017:	74 2c                	je     1045 <main+0x45>
    printf(2, "Usage: ln old new\n");
    1019:	48 be 00 22 00 00 00 	movabs $0x2200,%rsi
    1020:	00 00 00 
    1023:	bf 02 00 00 00       	mov    $0x2,%edi
    1028:	b8 00 00 00 00       	mov    $0x0,%eax
    102d:	48 ba e7 16 00 00 00 	movabs $0x16e7,%rdx
    1034:	00 00 00 
    1037:	ff d2                	callq  *%rdx
    exit();
    1039:	48 b8 fd 13 00 00 00 	movabs $0x13fd,%rax
    1040:	00 00 00 
    1043:	ff d0                	callq  *%rax
  }
  if(link(argv[1], argv[2]) < 0)
    1045:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1049:	48 83 c0 10          	add    $0x10,%rax
    104d:	48 8b 10             	mov    (%rax),%rdx
    1050:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1054:	48 83 c0 08          	add    $0x8,%rax
    1058:	48 8b 00             	mov    (%rax),%rax
    105b:	48 89 d6             	mov    %rdx,%rsi
    105e:	48 89 c7             	mov    %rax,%rdi
    1061:	48 b8 99 14 00 00 00 	movabs $0x1499,%rax
    1068:	00 00 00 
    106b:	ff d0                	callq  *%rax
    106d:	85 c0                	test   %eax,%eax
    106f:	79 3d                	jns    10ae <main+0xae>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
    1071:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1075:	48 83 c0 10          	add    $0x10,%rax
    1079:	48 8b 10             	mov    (%rax),%rdx
    107c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1080:	48 83 c0 08          	add    $0x8,%rax
    1084:	48 8b 00             	mov    (%rax),%rax
    1087:	48 89 d1             	mov    %rdx,%rcx
    108a:	48 89 c2             	mov    %rax,%rdx
    108d:	48 be 13 22 00 00 00 	movabs $0x2213,%rsi
    1094:	00 00 00 
    1097:	bf 02 00 00 00       	mov    $0x2,%edi
    109c:	b8 00 00 00 00       	mov    $0x0,%eax
    10a1:	49 b8 e7 16 00 00 00 	movabs $0x16e7,%r8
    10a8:	00 00 00 
    10ab:	41 ff d0             	callq  *%r8
  exit();
    10ae:	48 b8 fd 13 00 00 00 	movabs $0x13fd,%rax
    10b5:	00 00 00 
    10b8:	ff d0                	callq  *%rax

00000000000010ba <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10ba:	f3 0f 1e fa          	endbr64 
    10be:	55                   	push   %rbp
    10bf:	48 89 e5             	mov    %rsp,%rbp
    10c2:	48 83 ec 10          	sub    $0x10,%rsp
    10c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10ca:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10cd:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10d0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10d4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10da:	48 89 ce             	mov    %rcx,%rsi
    10dd:	48 89 f7             	mov    %rsi,%rdi
    10e0:	89 d1                	mov    %edx,%ecx
    10e2:	fc                   	cld    
    10e3:	f3 aa                	rep stos %al,%es:(%rdi)
    10e5:	89 ca                	mov    %ecx,%edx
    10e7:	48 89 fe             	mov    %rdi,%rsi
    10ea:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10ee:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10f1:	90                   	nop
    10f2:	c9                   	leaveq 
    10f3:	c3                   	retq   

00000000000010f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10f4:	f3 0f 1e fa          	endbr64 
    10f8:	55                   	push   %rbp
    10f9:	48 89 e5             	mov    %rsp,%rbp
    10fc:	48 83 ec 20          	sub    $0x20,%rsp
    1100:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1104:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    110c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1110:	90                   	nop
    1111:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1115:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1119:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1121:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1125:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1129:	0f b6 12             	movzbl (%rdx),%edx
    112c:	88 10                	mov    %dl,(%rax)
    112e:	0f b6 00             	movzbl (%rax),%eax
    1131:	84 c0                	test   %al,%al
    1133:	75 dc                	jne    1111 <strcpy+0x1d>
    ;
  return os;
    1135:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1139:	c9                   	leaveq 
    113a:	c3                   	retq   

000000000000113b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    113b:	f3 0f 1e fa          	endbr64 
    113f:	55                   	push   %rbp
    1140:	48 89 e5             	mov    %rsp,%rbp
    1143:	48 83 ec 10          	sub    $0x10,%rsp
    1147:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    114b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    114f:	eb 0a                	jmp    115b <strcmp+0x20>
    p++, q++;
    1151:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1156:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    115b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    115f:	0f b6 00             	movzbl (%rax),%eax
    1162:	84 c0                	test   %al,%al
    1164:	74 12                	je     1178 <strcmp+0x3d>
    1166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    116a:	0f b6 10             	movzbl (%rax),%edx
    116d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1171:	0f b6 00             	movzbl (%rax),%eax
    1174:	38 c2                	cmp    %al,%dl
    1176:	74 d9                	je     1151 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    117c:	0f b6 00             	movzbl (%rax),%eax
    117f:	0f b6 d0             	movzbl %al,%edx
    1182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1186:	0f b6 00             	movzbl (%rax),%eax
    1189:	0f b6 c0             	movzbl %al,%eax
    118c:	29 c2                	sub    %eax,%edx
    118e:	89 d0                	mov    %edx,%eax
}
    1190:	c9                   	leaveq 
    1191:	c3                   	retq   

0000000000001192 <strlen>:

uint
strlen(char *s)
{
    1192:	f3 0f 1e fa          	endbr64 
    1196:	55                   	push   %rbp
    1197:	48 89 e5             	mov    %rsp,%rbp
    119a:	48 83 ec 18          	sub    $0x18,%rsp
    119e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    11a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11a9:	eb 04                	jmp    11af <strlen+0x1d>
    11ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11b2:	48 63 d0             	movslq %eax,%rdx
    11b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11b9:	48 01 d0             	add    %rdx,%rax
    11bc:	0f b6 00             	movzbl (%rax),%eax
    11bf:	84 c0                	test   %al,%al
    11c1:	75 e8                	jne    11ab <strlen+0x19>
    ;
  return n;
    11c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11c6:	c9                   	leaveq 
    11c7:	c3                   	retq   

00000000000011c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11c8:	f3 0f 1e fa          	endbr64 
    11cc:	55                   	push   %rbp
    11cd:	48 89 e5             	mov    %rsp,%rbp
    11d0:	48 83 ec 10          	sub    $0x10,%rsp
    11d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11d8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11db:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11de:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11e1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11e8:	89 ce                	mov    %ecx,%esi
    11ea:	48 89 c7             	mov    %rax,%rdi
    11ed:	48 b8 ba 10 00 00 00 	movabs $0x10ba,%rax
    11f4:	00 00 00 
    11f7:	ff d0                	callq  *%rax
  return dst;
    11f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11fd:	c9                   	leaveq 
    11fe:	c3                   	retq   

00000000000011ff <strchr>:

char*
strchr(const char *s, char c)
{
    11ff:	f3 0f 1e fa          	endbr64 
    1203:	55                   	push   %rbp
    1204:	48 89 e5             	mov    %rsp,%rbp
    1207:	48 83 ec 10          	sub    $0x10,%rsp
    120b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    120f:	89 f0                	mov    %esi,%eax
    1211:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1214:	eb 17                	jmp    122d <strchr+0x2e>
    if(*s == c)
    1216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    121a:	0f b6 00             	movzbl (%rax),%eax
    121d:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1220:	75 06                	jne    1228 <strchr+0x29>
      return (char*)s;
    1222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1226:	eb 15                	jmp    123d <strchr+0x3e>
  for(; *s; s++)
    1228:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1231:	0f b6 00             	movzbl (%rax),%eax
    1234:	84 c0                	test   %al,%al
    1236:	75 de                	jne    1216 <strchr+0x17>
  return 0;
    1238:	b8 00 00 00 00       	mov    $0x0,%eax
}
    123d:	c9                   	leaveq 
    123e:	c3                   	retq   

000000000000123f <gets>:

char*
gets(char *buf, int max)
{
    123f:	f3 0f 1e fa          	endbr64 
    1243:	55                   	push   %rbp
    1244:	48 89 e5             	mov    %rsp,%rbp
    1247:	48 83 ec 20          	sub    $0x20,%rsp
    124b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    124f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1259:	eb 4f                	jmp    12aa <gets+0x6b>
    cc = read(0, &c, 1);
    125b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    125f:	ba 01 00 00 00       	mov    $0x1,%edx
    1264:	48 89 c6             	mov    %rax,%rsi
    1267:	bf 00 00 00 00       	mov    $0x0,%edi
    126c:	48 b8 24 14 00 00 00 	movabs $0x1424,%rax
    1273:	00 00 00 
    1276:	ff d0                	callq  *%rax
    1278:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    127b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    127f:	7e 36                	jle    12b7 <gets+0x78>
      break;
    buf[i++] = c;
    1281:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1284:	8d 50 01             	lea    0x1(%rax),%edx
    1287:	89 55 fc             	mov    %edx,-0x4(%rbp)
    128a:	48 63 d0             	movslq %eax,%rdx
    128d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1291:	48 01 c2             	add    %rax,%rdx
    1294:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1298:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    129a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    129e:	3c 0a                	cmp    $0xa,%al
    12a0:	74 16                	je     12b8 <gets+0x79>
    12a2:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12a6:	3c 0d                	cmp    $0xd,%al
    12a8:	74 0e                	je     12b8 <gets+0x79>
  for(i=0; i+1 < max; ){
    12aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12ad:	83 c0 01             	add    $0x1,%eax
    12b0:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    12b3:	7f a6                	jg     125b <gets+0x1c>
    12b5:	eb 01                	jmp    12b8 <gets+0x79>
      break;
    12b7:	90                   	nop
      break;
  }
  buf[i] = '\0';
    12b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12bb:	48 63 d0             	movslq %eax,%rdx
    12be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12c2:	48 01 d0             	add    %rdx,%rax
    12c5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12cc:	c9                   	leaveq 
    12cd:	c3                   	retq   

00000000000012ce <stat>:

int
stat(char *n, struct stat *st)
{
    12ce:	f3 0f 1e fa          	endbr64 
    12d2:	55                   	push   %rbp
    12d3:	48 89 e5             	mov    %rsp,%rbp
    12d6:	48 83 ec 20          	sub    $0x20,%rsp
    12da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12e6:	be 00 00 00 00       	mov    $0x0,%esi
    12eb:	48 89 c7             	mov    %rax,%rdi
    12ee:	48 b8 65 14 00 00 00 	movabs $0x1465,%rax
    12f5:	00 00 00 
    12f8:	ff d0                	callq  *%rax
    12fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1301:	79 07                	jns    130a <stat+0x3c>
    return -1;
    1303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1308:	eb 2f                	jmp    1339 <stat+0x6b>
  r = fstat(fd, st);
    130a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    130e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1311:	48 89 d6             	mov    %rdx,%rsi
    1314:	89 c7                	mov    %eax,%edi
    1316:	48 b8 8c 14 00 00 00 	movabs $0x148c,%rax
    131d:	00 00 00 
    1320:	ff d0                	callq  *%rax
    1322:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1325:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1328:	89 c7                	mov    %eax,%edi
    132a:	48 b8 3e 14 00 00 00 	movabs $0x143e,%rax
    1331:	00 00 00 
    1334:	ff d0                	callq  *%rax
  return r;
    1336:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1339:	c9                   	leaveq 
    133a:	c3                   	retq   

000000000000133b <atoi>:

int
atoi(const char *s)
{
    133b:	f3 0f 1e fa          	endbr64 
    133f:	55                   	push   %rbp
    1340:	48 89 e5             	mov    %rsp,%rbp
    1343:	48 83 ec 18          	sub    $0x18,%rsp
    1347:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    134b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1352:	eb 28                	jmp    137c <atoi+0x41>
    n = n*10 + *s++ - '0';
    1354:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1357:	89 d0                	mov    %edx,%eax
    1359:	c1 e0 02             	shl    $0x2,%eax
    135c:	01 d0                	add    %edx,%eax
    135e:	01 c0                	add    %eax,%eax
    1360:	89 c1                	mov    %eax,%ecx
    1362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1366:	48 8d 50 01          	lea    0x1(%rax),%rdx
    136a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    136e:	0f b6 00             	movzbl (%rax),%eax
    1371:	0f be c0             	movsbl %al,%eax
    1374:	01 c8                	add    %ecx,%eax
    1376:	83 e8 30             	sub    $0x30,%eax
    1379:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    137c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1380:	0f b6 00             	movzbl (%rax),%eax
    1383:	3c 2f                	cmp    $0x2f,%al
    1385:	7e 0b                	jle    1392 <atoi+0x57>
    1387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    138b:	0f b6 00             	movzbl (%rax),%eax
    138e:	3c 39                	cmp    $0x39,%al
    1390:	7e c2                	jle    1354 <atoi+0x19>
  return n;
    1392:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1395:	c9                   	leaveq 
    1396:	c3                   	retq   

0000000000001397 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1397:	f3 0f 1e fa          	endbr64 
    139b:	55                   	push   %rbp
    139c:	48 89 e5             	mov    %rsp,%rbp
    139f:	48 83 ec 28          	sub    $0x28,%rsp
    13a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    13ab:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    13ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    13b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    13ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    13be:	eb 1d                	jmp    13dd <memmove+0x46>
    *dst++ = *src++;
    13c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13c4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13d4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13d8:	0f b6 12             	movzbl (%rdx),%edx
    13db:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13e0:	8d 50 ff             	lea    -0x1(%rax),%edx
    13e3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13e6:	85 c0                	test   %eax,%eax
    13e8:	7f d6                	jg     13c0 <memmove+0x29>
  return vdst;
    13ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13ee:	c9                   	leaveq 
    13ef:	c3                   	retq   

00000000000013f0 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13f0:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13f7:	49 89 ca             	mov    %rcx,%r10
    13fa:	0f 05                	syscall 
    13fc:	c3                   	retq   

00000000000013fd <exit>:
SYSCALL(exit)
    13fd:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1404:	49 89 ca             	mov    %rcx,%r10
    1407:	0f 05                	syscall 
    1409:	c3                   	retq   

000000000000140a <wait>:
SYSCALL(wait)
    140a:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1411:	49 89 ca             	mov    %rcx,%r10
    1414:	0f 05                	syscall 
    1416:	c3                   	retq   

0000000000001417 <pipe>:
SYSCALL(pipe)
    1417:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    141e:	49 89 ca             	mov    %rcx,%r10
    1421:	0f 05                	syscall 
    1423:	c3                   	retq   

0000000000001424 <read>:
SYSCALL(read)
    1424:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    142b:	49 89 ca             	mov    %rcx,%r10
    142e:	0f 05                	syscall 
    1430:	c3                   	retq   

0000000000001431 <write>:
SYSCALL(write)
    1431:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1438:	49 89 ca             	mov    %rcx,%r10
    143b:	0f 05                	syscall 
    143d:	c3                   	retq   

000000000000143e <close>:
SYSCALL(close)
    143e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1445:	49 89 ca             	mov    %rcx,%r10
    1448:	0f 05                	syscall 
    144a:	c3                   	retq   

000000000000144b <kill>:
SYSCALL(kill)
    144b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1452:	49 89 ca             	mov    %rcx,%r10
    1455:	0f 05                	syscall 
    1457:	c3                   	retq   

0000000000001458 <exec>:
SYSCALL(exec)
    1458:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    145f:	49 89 ca             	mov    %rcx,%r10
    1462:	0f 05                	syscall 
    1464:	c3                   	retq   

0000000000001465 <open>:
SYSCALL(open)
    1465:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    146c:	49 89 ca             	mov    %rcx,%r10
    146f:	0f 05                	syscall 
    1471:	c3                   	retq   

0000000000001472 <mknod>:
SYSCALL(mknod)
    1472:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1479:	49 89 ca             	mov    %rcx,%r10
    147c:	0f 05                	syscall 
    147e:	c3                   	retq   

000000000000147f <unlink>:
SYSCALL(unlink)
    147f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1486:	49 89 ca             	mov    %rcx,%r10
    1489:	0f 05                	syscall 
    148b:	c3                   	retq   

000000000000148c <fstat>:
SYSCALL(fstat)
    148c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1493:	49 89 ca             	mov    %rcx,%r10
    1496:	0f 05                	syscall 
    1498:	c3                   	retq   

0000000000001499 <link>:
SYSCALL(link)
    1499:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    14a0:	49 89 ca             	mov    %rcx,%r10
    14a3:	0f 05                	syscall 
    14a5:	c3                   	retq   

00000000000014a6 <mkdir>:
SYSCALL(mkdir)
    14a6:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    14ad:	49 89 ca             	mov    %rcx,%r10
    14b0:	0f 05                	syscall 
    14b2:	c3                   	retq   

00000000000014b3 <chdir>:
SYSCALL(chdir)
    14b3:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    14ba:	49 89 ca             	mov    %rcx,%r10
    14bd:	0f 05                	syscall 
    14bf:	c3                   	retq   

00000000000014c0 <dup>:
SYSCALL(dup)
    14c0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14c7:	49 89 ca             	mov    %rcx,%r10
    14ca:	0f 05                	syscall 
    14cc:	c3                   	retq   

00000000000014cd <getpid>:
SYSCALL(getpid)
    14cd:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14d4:	49 89 ca             	mov    %rcx,%r10
    14d7:	0f 05                	syscall 
    14d9:	c3                   	retq   

00000000000014da <sbrk>:
SYSCALL(sbrk)
    14da:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14e1:	49 89 ca             	mov    %rcx,%r10
    14e4:	0f 05                	syscall 
    14e6:	c3                   	retq   

00000000000014e7 <sleep>:
SYSCALL(sleep)
    14e7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14ee:	49 89 ca             	mov    %rcx,%r10
    14f1:	0f 05                	syscall 
    14f3:	c3                   	retq   

00000000000014f4 <uptime>:
SYSCALL(uptime)
    14f4:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14fb:	49 89 ca             	mov    %rcx,%r10
    14fe:	0f 05                	syscall 
    1500:	c3                   	retq   

0000000000001501 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1501:	f3 0f 1e fa          	endbr64 
    1505:	55                   	push   %rbp
    1506:	48 89 e5             	mov    %rsp,%rbp
    1509:	48 83 ec 10          	sub    $0x10,%rsp
    150d:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1510:	89 f0                	mov    %esi,%eax
    1512:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1515:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1519:	8b 45 fc             	mov    -0x4(%rbp),%eax
    151c:	ba 01 00 00 00       	mov    $0x1,%edx
    1521:	48 89 ce             	mov    %rcx,%rsi
    1524:	89 c7                	mov    %eax,%edi
    1526:	48 b8 31 14 00 00 00 	movabs $0x1431,%rax
    152d:	00 00 00 
    1530:	ff d0                	callq  *%rax
}
    1532:	90                   	nop
    1533:	c9                   	leaveq 
    1534:	c3                   	retq   

0000000000001535 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1535:	f3 0f 1e fa          	endbr64 
    1539:	55                   	push   %rbp
    153a:	48 89 e5             	mov    %rsp,%rbp
    153d:	48 83 ec 20          	sub    $0x20,%rsp
    1541:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1544:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1548:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    154f:	eb 35                	jmp    1586 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1551:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1555:	48 c1 e8 3c          	shr    $0x3c,%rax
    1559:	48 ba 20 26 00 00 00 	movabs $0x2620,%rdx
    1560:	00 00 00 
    1563:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1567:	0f be d0             	movsbl %al,%edx
    156a:	8b 45 ec             	mov    -0x14(%rbp),%eax
    156d:	89 d6                	mov    %edx,%esi
    156f:	89 c7                	mov    %eax,%edi
    1571:	48 b8 01 15 00 00 00 	movabs $0x1501,%rax
    1578:	00 00 00 
    157b:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    157d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1581:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1586:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1589:	83 f8 0f             	cmp    $0xf,%eax
    158c:	76 c3                	jbe    1551 <print_x64+0x1c>
}
    158e:	90                   	nop
    158f:	90                   	nop
    1590:	c9                   	leaveq 
    1591:	c3                   	retq   

0000000000001592 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1592:	f3 0f 1e fa          	endbr64 
    1596:	55                   	push   %rbp
    1597:	48 89 e5             	mov    %rsp,%rbp
    159a:	48 83 ec 20          	sub    $0x20,%rsp
    159e:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15a1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15ab:	eb 36                	jmp    15e3 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15ad:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15b0:	c1 e8 1c             	shr    $0x1c,%eax
    15b3:	89 c2                	mov    %eax,%edx
    15b5:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    15bc:	00 00 00 
    15bf:	89 d2                	mov    %edx,%edx
    15c1:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15c5:	0f be d0             	movsbl %al,%edx
    15c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15cb:	89 d6                	mov    %edx,%esi
    15cd:	89 c7                	mov    %eax,%edi
    15cf:	48 b8 01 15 00 00 00 	movabs $0x1501,%rax
    15d6:	00 00 00 
    15d9:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15df:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15e6:	83 f8 07             	cmp    $0x7,%eax
    15e9:	76 c2                	jbe    15ad <print_x32+0x1b>
}
    15eb:	90                   	nop
    15ec:	90                   	nop
    15ed:	c9                   	leaveq 
    15ee:	c3                   	retq   

00000000000015ef <print_d>:

  static void
print_d(int fd, int v)
{
    15ef:	f3 0f 1e fa          	endbr64 
    15f3:	55                   	push   %rbp
    15f4:	48 89 e5             	mov    %rsp,%rbp
    15f7:	48 83 ec 30          	sub    $0x30,%rsp
    15fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15fe:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1601:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1604:	48 98                	cltq   
    1606:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    160a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    160e:	79 04                	jns    1614 <print_d+0x25>
    x = -x;
    1610:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1614:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    161b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    161f:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1626:	66 66 66 
    1629:	48 89 c8             	mov    %rcx,%rax
    162c:	48 f7 ea             	imul   %rdx
    162f:	48 c1 fa 02          	sar    $0x2,%rdx
    1633:	48 89 c8             	mov    %rcx,%rax
    1636:	48 c1 f8 3f          	sar    $0x3f,%rax
    163a:	48 29 c2             	sub    %rax,%rdx
    163d:	48 89 d0             	mov    %rdx,%rax
    1640:	48 c1 e0 02          	shl    $0x2,%rax
    1644:	48 01 d0             	add    %rdx,%rax
    1647:	48 01 c0             	add    %rax,%rax
    164a:	48 29 c1             	sub    %rax,%rcx
    164d:	48 89 ca             	mov    %rcx,%rdx
    1650:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1653:	8d 48 01             	lea    0x1(%rax),%ecx
    1656:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1659:	48 b9 20 26 00 00 00 	movabs $0x2620,%rcx
    1660:	00 00 00 
    1663:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1667:	48 98                	cltq   
    1669:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    166d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1671:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1678:	66 66 66 
    167b:	48 89 c8             	mov    %rcx,%rax
    167e:	48 f7 ea             	imul   %rdx
    1681:	48 c1 fa 02          	sar    $0x2,%rdx
    1685:	48 89 c8             	mov    %rcx,%rax
    1688:	48 c1 f8 3f          	sar    $0x3f,%rax
    168c:	48 29 c2             	sub    %rax,%rdx
    168f:	48 89 d0             	mov    %rdx,%rax
    1692:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1696:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    169b:	0f 85 7a ff ff ff    	jne    161b <print_d+0x2c>

  if (v < 0)
    16a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16a5:	79 32                	jns    16d9 <print_d+0xea>
    buf[i++] = '-';
    16a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16aa:	8d 50 01             	lea    0x1(%rax),%edx
    16ad:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16b0:	48 98                	cltq   
    16b2:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16b7:	eb 20                	jmp    16d9 <print_d+0xea>
    putc(fd, buf[i]);
    16b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16bc:	48 98                	cltq   
    16be:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16c3:	0f be d0             	movsbl %al,%edx
    16c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16c9:	89 d6                	mov    %edx,%esi
    16cb:	89 c7                	mov    %eax,%edi
    16cd:	48 b8 01 15 00 00 00 	movabs $0x1501,%rax
    16d4:	00 00 00 
    16d7:	ff d0                	callq  *%rax
  while (--i >= 0)
    16d9:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16e1:	79 d6                	jns    16b9 <print_d+0xca>
}
    16e3:	90                   	nop
    16e4:	90                   	nop
    16e5:	c9                   	leaveq 
    16e6:	c3                   	retq   

00000000000016e7 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16e7:	f3 0f 1e fa          	endbr64 
    16eb:	55                   	push   %rbp
    16ec:	48 89 e5             	mov    %rsp,%rbp
    16ef:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16f6:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16fc:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1703:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    170a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1711:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1718:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    171f:	84 c0                	test   %al,%al
    1721:	74 20                	je     1743 <printf+0x5c>
    1723:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1727:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    172b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    172f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1733:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1737:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    173b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    173f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1743:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    174a:	00 00 00 
    174d:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1754:	00 00 00 
    1757:	48 8d 45 10          	lea    0x10(%rbp),%rax
    175b:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1762:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1769:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1770:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1777:	00 00 00 
    177a:	e9 41 03 00 00       	jmpq   1ac0 <printf+0x3d9>
    if (c != '%') {
    177f:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1786:	74 24                	je     17ac <printf+0xc5>
      putc(fd, c);
    1788:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    178e:	0f be d0             	movsbl %al,%edx
    1791:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1797:	89 d6                	mov    %edx,%esi
    1799:	89 c7                	mov    %eax,%edi
    179b:	48 b8 01 15 00 00 00 	movabs $0x1501,%rax
    17a2:	00 00 00 
    17a5:	ff d0                	callq  *%rax
      continue;
    17a7:	e9 0d 03 00 00       	jmpq   1ab9 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    17ac:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17b3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17b9:	48 63 d0             	movslq %eax,%rdx
    17bc:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17c3:	48 01 d0             	add    %rdx,%rax
    17c6:	0f b6 00             	movzbl (%rax),%eax
    17c9:	0f be c0             	movsbl %al,%eax
    17cc:	25 ff 00 00 00       	and    $0xff,%eax
    17d1:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17d7:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17de:	0f 84 0f 03 00 00    	je     1af3 <printf+0x40c>
      break;
    switch(c) {
    17e4:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17eb:	0f 84 74 02 00 00    	je     1a65 <printf+0x37e>
    17f1:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17f8:	0f 8c 82 02 00 00    	jl     1a80 <printf+0x399>
    17fe:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1805:	0f 8f 75 02 00 00    	jg     1a80 <printf+0x399>
    180b:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1812:	0f 8c 68 02 00 00    	jl     1a80 <printf+0x399>
    1818:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    181e:	83 e8 63             	sub    $0x63,%eax
    1821:	83 f8 15             	cmp    $0x15,%eax
    1824:	0f 87 56 02 00 00    	ja     1a80 <printf+0x399>
    182a:	89 c0                	mov    %eax,%eax
    182c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1833:	00 
    1834:	48 b8 30 22 00 00 00 	movabs $0x2230,%rax
    183b:	00 00 00 
    183e:	48 01 d0             	add    %rdx,%rax
    1841:	48 8b 00             	mov    (%rax),%rax
    1844:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1847:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    184d:	83 f8 2f             	cmp    $0x2f,%eax
    1850:	77 23                	ja     1875 <printf+0x18e>
    1852:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1859:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    185f:	89 d2                	mov    %edx,%edx
    1861:	48 01 d0             	add    %rdx,%rax
    1864:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    186a:	83 c2 08             	add    $0x8,%edx
    186d:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1873:	eb 12                	jmp    1887 <printf+0x1a0>
    1875:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    187c:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1880:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1887:	8b 00                	mov    (%rax),%eax
    1889:	0f be d0             	movsbl %al,%edx
    188c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1892:	89 d6                	mov    %edx,%esi
    1894:	89 c7                	mov    %eax,%edi
    1896:	48 b8 01 15 00 00 00 	movabs $0x1501,%rax
    189d:	00 00 00 
    18a0:	ff d0                	callq  *%rax
      break;
    18a2:	e9 12 02 00 00       	jmpq   1ab9 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18a7:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18ad:	83 f8 2f             	cmp    $0x2f,%eax
    18b0:	77 23                	ja     18d5 <printf+0x1ee>
    18b2:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18b9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18bf:	89 d2                	mov    %edx,%edx
    18c1:	48 01 d0             	add    %rdx,%rax
    18c4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18ca:	83 c2 08             	add    $0x8,%edx
    18cd:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18d3:	eb 12                	jmp    18e7 <printf+0x200>
    18d5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18dc:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18e0:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18e7:	8b 10                	mov    (%rax),%edx
    18e9:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18ef:	89 d6                	mov    %edx,%esi
    18f1:	89 c7                	mov    %eax,%edi
    18f3:	48 b8 ef 15 00 00 00 	movabs $0x15ef,%rax
    18fa:	00 00 00 
    18fd:	ff d0                	callq  *%rax
      break;
    18ff:	e9 b5 01 00 00       	jmpq   1ab9 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1904:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    190a:	83 f8 2f             	cmp    $0x2f,%eax
    190d:	77 23                	ja     1932 <printf+0x24b>
    190f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1916:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    191c:	89 d2                	mov    %edx,%edx
    191e:	48 01 d0             	add    %rdx,%rax
    1921:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1927:	83 c2 08             	add    $0x8,%edx
    192a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1930:	eb 12                	jmp    1944 <printf+0x25d>
    1932:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1939:	48 8d 50 08          	lea    0x8(%rax),%rdx
    193d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1944:	8b 10                	mov    (%rax),%edx
    1946:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    194c:	89 d6                	mov    %edx,%esi
    194e:	89 c7                	mov    %eax,%edi
    1950:	48 b8 92 15 00 00 00 	movabs $0x1592,%rax
    1957:	00 00 00 
    195a:	ff d0                	callq  *%rax
      break;
    195c:	e9 58 01 00 00       	jmpq   1ab9 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1961:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1967:	83 f8 2f             	cmp    $0x2f,%eax
    196a:	77 23                	ja     198f <printf+0x2a8>
    196c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1973:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1979:	89 d2                	mov    %edx,%edx
    197b:	48 01 d0             	add    %rdx,%rax
    197e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1984:	83 c2 08             	add    $0x8,%edx
    1987:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    198d:	eb 12                	jmp    19a1 <printf+0x2ba>
    198f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1996:	48 8d 50 08          	lea    0x8(%rax),%rdx
    199a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19a1:	48 8b 10             	mov    (%rax),%rdx
    19a4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19aa:	48 89 d6             	mov    %rdx,%rsi
    19ad:	89 c7                	mov    %eax,%edi
    19af:	48 b8 35 15 00 00 00 	movabs $0x1535,%rax
    19b6:	00 00 00 
    19b9:	ff d0                	callq  *%rax
      break;
    19bb:	e9 f9 00 00 00       	jmpq   1ab9 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19c0:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19c6:	83 f8 2f             	cmp    $0x2f,%eax
    19c9:	77 23                	ja     19ee <printf+0x307>
    19cb:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19d2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d8:	89 d2                	mov    %edx,%edx
    19da:	48 01 d0             	add    %rdx,%rax
    19dd:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19e3:	83 c2 08             	add    $0x8,%edx
    19e6:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19ec:	eb 12                	jmp    1a00 <printf+0x319>
    19ee:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19f5:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19f9:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a00:	48 8b 00             	mov    (%rax),%rax
    1a03:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a0a:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a11:	00 
    1a12:	75 41                	jne    1a55 <printf+0x36e>
        s = "(null)";
    1a14:	48 b8 28 22 00 00 00 	movabs $0x2228,%rax
    1a1b:	00 00 00 
    1a1e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a25:	eb 2e                	jmp    1a55 <printf+0x36e>
        putc(fd, *(s++));
    1a27:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a2e:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a32:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a39:	0f b6 00             	movzbl (%rax),%eax
    1a3c:	0f be d0             	movsbl %al,%edx
    1a3f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a45:	89 d6                	mov    %edx,%esi
    1a47:	89 c7                	mov    %eax,%edi
    1a49:	48 b8 01 15 00 00 00 	movabs $0x1501,%rax
    1a50:	00 00 00 
    1a53:	ff d0                	callq  *%rax
      while (*s)
    1a55:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a5c:	0f b6 00             	movzbl (%rax),%eax
    1a5f:	84 c0                	test   %al,%al
    1a61:	75 c4                	jne    1a27 <printf+0x340>
      break;
    1a63:	eb 54                	jmp    1ab9 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a65:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a6b:	be 25 00 00 00       	mov    $0x25,%esi
    1a70:	89 c7                	mov    %eax,%edi
    1a72:	48 b8 01 15 00 00 00 	movabs $0x1501,%rax
    1a79:	00 00 00 
    1a7c:	ff d0                	callq  *%rax
      break;
    1a7e:	eb 39                	jmp    1ab9 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a80:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a86:	be 25 00 00 00       	mov    $0x25,%esi
    1a8b:	89 c7                	mov    %eax,%edi
    1a8d:	48 b8 01 15 00 00 00 	movabs $0x1501,%rax
    1a94:	00 00 00 
    1a97:	ff d0                	callq  *%rax
      putc(fd, c);
    1a99:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a9f:	0f be d0             	movsbl %al,%edx
    1aa2:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aa8:	89 d6                	mov    %edx,%esi
    1aaa:	89 c7                	mov    %eax,%edi
    1aac:	48 b8 01 15 00 00 00 	movabs $0x1501,%rax
    1ab3:	00 00 00 
    1ab6:	ff d0                	callq  *%rax
      break;
    1ab8:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ab9:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ac0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ac6:	48 63 d0             	movslq %eax,%rdx
    1ac9:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ad0:	48 01 d0             	add    %rdx,%rax
    1ad3:	0f b6 00             	movzbl (%rax),%eax
    1ad6:	0f be c0             	movsbl %al,%eax
    1ad9:	25 ff 00 00 00       	and    $0xff,%eax
    1ade:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ae4:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1aeb:	0f 85 8e fc ff ff    	jne    177f <printf+0x98>
    }
  }
}
    1af1:	eb 01                	jmp    1af4 <printf+0x40d>
      break;
    1af3:	90                   	nop
}
    1af4:	90                   	nop
    1af5:	c9                   	leaveq 
    1af6:	c3                   	retq   

0000000000001af7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1af7:	f3 0f 1e fa          	endbr64 
    1afb:	55                   	push   %rbp
    1afc:	48 89 e5             	mov    %rsp,%rbp
    1aff:	48 83 ec 18          	sub    $0x18,%rsp
    1b03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b0b:	48 83 e8 10          	sub    $0x10,%rax
    1b0f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b13:	48 b8 50 26 00 00 00 	movabs $0x2650,%rax
    1b1a:	00 00 00 
    1b1d:	48 8b 00             	mov    (%rax),%rax
    1b20:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b24:	eb 2f                	jmp    1b55 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b2a:	48 8b 00             	mov    (%rax),%rax
    1b2d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b31:	72 17                	jb     1b4a <free+0x53>
    1b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b37:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b3b:	77 2f                	ja     1b6c <free+0x75>
    1b3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b41:	48 8b 00             	mov    (%rax),%rax
    1b44:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b48:	72 22                	jb     1b6c <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b4e:	48 8b 00             	mov    (%rax),%rax
    1b51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b59:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b5d:	76 c7                	jbe    1b26 <free+0x2f>
    1b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b63:	48 8b 00             	mov    (%rax),%rax
    1b66:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b6a:	73 ba                	jae    1b26 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b70:	8b 40 08             	mov    0x8(%rax),%eax
    1b73:	89 c0                	mov    %eax,%eax
    1b75:	48 c1 e0 04          	shl    $0x4,%rax
    1b79:	48 89 c2             	mov    %rax,%rdx
    1b7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b80:	48 01 c2             	add    %rax,%rdx
    1b83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b87:	48 8b 00             	mov    (%rax),%rax
    1b8a:	48 39 c2             	cmp    %rax,%rdx
    1b8d:	75 2d                	jne    1bbc <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1b8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b93:	8b 50 08             	mov    0x8(%rax),%edx
    1b96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b9a:	48 8b 00             	mov    (%rax),%rax
    1b9d:	8b 40 08             	mov    0x8(%rax),%eax
    1ba0:	01 c2                	add    %eax,%edx
    1ba2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba6:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1ba9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bad:	48 8b 00             	mov    (%rax),%rax
    1bb0:	48 8b 10             	mov    (%rax),%rdx
    1bb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb7:	48 89 10             	mov    %rdx,(%rax)
    1bba:	eb 0e                	jmp    1bca <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1bbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bc0:	48 8b 10             	mov    (%rax),%rdx
    1bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bc7:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bce:	8b 40 08             	mov    0x8(%rax),%eax
    1bd1:	89 c0                	mov    %eax,%eax
    1bd3:	48 c1 e0 04          	shl    $0x4,%rax
    1bd7:	48 89 c2             	mov    %rax,%rdx
    1bda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bde:	48 01 d0             	add    %rdx,%rax
    1be1:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1be5:	75 27                	jne    1c0e <free+0x117>
    p->s.size += bp->s.size;
    1be7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1beb:	8b 50 08             	mov    0x8(%rax),%edx
    1bee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bf2:	8b 40 08             	mov    0x8(%rax),%eax
    1bf5:	01 c2                	add    %eax,%edx
    1bf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfb:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1bfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c02:	48 8b 10             	mov    (%rax),%rdx
    1c05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c09:	48 89 10             	mov    %rdx,(%rax)
    1c0c:	eb 0b                	jmp    1c19 <free+0x122>
  } else
    p->s.ptr = bp;
    1c0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c16:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c19:	48 ba 50 26 00 00 00 	movabs $0x2650,%rdx
    1c20:	00 00 00 
    1c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c27:	48 89 02             	mov    %rax,(%rdx)
}
    1c2a:	90                   	nop
    1c2b:	c9                   	leaveq 
    1c2c:	c3                   	retq   

0000000000001c2d <morecore>:

static Header*
morecore(uint nu)
{
    1c2d:	f3 0f 1e fa          	endbr64 
    1c31:	55                   	push   %rbp
    1c32:	48 89 e5             	mov    %rsp,%rbp
    1c35:	48 83 ec 20          	sub    $0x20,%rsp
    1c39:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c3c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c43:	77 07                	ja     1c4c <morecore+0x1f>
    nu = 4096;
    1c45:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c4f:	48 c1 e0 04          	shl    $0x4,%rax
    1c53:	48 89 c7             	mov    %rax,%rdi
    1c56:	48 b8 da 14 00 00 00 	movabs $0x14da,%rax
    1c5d:	00 00 00 
    1c60:	ff d0                	callq  *%rax
    1c62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c66:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c6b:	75 07                	jne    1c74 <morecore+0x47>
    return 0;
    1c6d:	b8 00 00 00 00       	mov    $0x0,%eax
    1c72:	eb 36                	jmp    1caa <morecore+0x7d>
  hp = (Header*)p;
    1c74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c78:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c80:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c83:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c8a:	48 83 c0 10          	add    $0x10,%rax
    1c8e:	48 89 c7             	mov    %rax,%rdi
    1c91:	48 b8 f7 1a 00 00 00 	movabs $0x1af7,%rax
    1c98:	00 00 00 
    1c9b:	ff d0                	callq  *%rax
  return freep;
    1c9d:	48 b8 50 26 00 00 00 	movabs $0x2650,%rax
    1ca4:	00 00 00 
    1ca7:	48 8b 00             	mov    (%rax),%rax
}
    1caa:	c9                   	leaveq 
    1cab:	c3                   	retq   

0000000000001cac <malloc>:

void*
malloc(uint nbytes)
{
    1cac:	f3 0f 1e fa          	endbr64 
    1cb0:	55                   	push   %rbp
    1cb1:	48 89 e5             	mov    %rsp,%rbp
    1cb4:	48 83 ec 30          	sub    $0x30,%rsp
    1cb8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1cbb:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cbe:	48 83 c0 0f          	add    $0xf,%rax
    1cc2:	48 c1 e8 04          	shr    $0x4,%rax
    1cc6:	83 c0 01             	add    $0x1,%eax
    1cc9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1ccc:	48 b8 50 26 00 00 00 	movabs $0x2650,%rax
    1cd3:	00 00 00 
    1cd6:	48 8b 00             	mov    (%rax),%rax
    1cd9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cdd:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1ce2:	75 4a                	jne    1d2e <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1ce4:	48 b8 40 26 00 00 00 	movabs $0x2640,%rax
    1ceb:	00 00 00 
    1cee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cf2:	48 ba 50 26 00 00 00 	movabs $0x2650,%rdx
    1cf9:	00 00 00 
    1cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d00:	48 89 02             	mov    %rax,(%rdx)
    1d03:	48 b8 50 26 00 00 00 	movabs $0x2650,%rax
    1d0a:	00 00 00 
    1d0d:	48 8b 00             	mov    (%rax),%rax
    1d10:	48 ba 40 26 00 00 00 	movabs $0x2640,%rdx
    1d17:	00 00 00 
    1d1a:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d1d:	48 b8 40 26 00 00 00 	movabs $0x2640,%rax
    1d24:	00 00 00 
    1d27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d32:	48 8b 00             	mov    (%rax),%rax
    1d35:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d3d:	8b 40 08             	mov    0x8(%rax),%eax
    1d40:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d43:	77 65                	ja     1daa <malloc+0xfe>
      if(p->s.size == nunits)
    1d45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d49:	8b 40 08             	mov    0x8(%rax),%eax
    1d4c:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d4f:	75 10                	jne    1d61 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d55:	48 8b 10             	mov    (%rax),%rdx
    1d58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d5c:	48 89 10             	mov    %rdx,(%rax)
    1d5f:	eb 2e                	jmp    1d8f <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d65:	8b 40 08             	mov    0x8(%rax),%eax
    1d68:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d6b:	89 c2                	mov    %eax,%edx
    1d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d71:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d78:	8b 40 08             	mov    0x8(%rax),%eax
    1d7b:	89 c0                	mov    %eax,%eax
    1d7d:	48 c1 e0 04          	shl    $0x4,%rax
    1d81:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d89:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d8c:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d8f:	48 ba 50 26 00 00 00 	movabs $0x2650,%rdx
    1d96:	00 00 00 
    1d99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d9d:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1da0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da4:	48 83 c0 10          	add    $0x10,%rax
    1da8:	eb 4e                	jmp    1df8 <malloc+0x14c>
    }
    if(p == freep)
    1daa:	48 b8 50 26 00 00 00 	movabs $0x2650,%rax
    1db1:	00 00 00 
    1db4:	48 8b 00             	mov    (%rax),%rax
    1db7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1dbb:	75 23                	jne    1de0 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1dbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1dc0:	89 c7                	mov    %eax,%edi
    1dc2:	48 b8 2d 1c 00 00 00 	movabs $0x1c2d,%rax
    1dc9:	00 00 00 
    1dcc:	ff d0                	callq  *%rax
    1dce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1dd2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1dd7:	75 07                	jne    1de0 <malloc+0x134>
        return 0;
    1dd9:	b8 00 00 00 00       	mov    $0x0,%eax
    1dde:	eb 18                	jmp    1df8 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1de0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1de4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1de8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dec:	48 8b 00             	mov    (%rax),%rax
    1def:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1df3:	e9 41 ff ff ff       	jmpq   1d39 <malloc+0x8d>
  }
}
    1df8:	c9                   	leaveq 
    1df9:	c3                   	retq   

0000000000001dfa <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1dfa:	f3 0f 1e fa          	endbr64 
    1dfe:	55                   	push   %rbp
    1dff:	48 89 e5             	mov    %rsp,%rbp
    1e02:	48 83 ec 30          	sub    $0x30,%rsp
    1e06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1e0a:	bf 18 00 00 00       	mov    $0x18,%edi
    1e0f:	48 b8 ac 1c 00 00 00 	movabs $0x1cac,%rax
    1e16:	00 00 00 
    1e19:	ff d0                	callq  *%rax
    1e1b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1e1f:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1e24:	75 0a                	jne    1e30 <co_new+0x36>
    return 0;
    1e26:	b8 00 00 00 00       	mov    $0x0,%eax
    1e2b:	e9 e1 00 00 00       	jmpq   1f11 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1e30:	bf 00 20 00 00       	mov    $0x2000,%edi
    1e35:	48 b8 ac 1c 00 00 00 	movabs $0x1cac,%rax
    1e3c:	00 00 00 
    1e3f:	ff d0                	callq  *%rax
    1e41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1e45:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1e49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e4d:	48 8b 40 10          	mov    0x10(%rax),%rax
    1e51:	48 85 c0             	test   %rax,%rax
    1e54:	75 1d                	jne    1e73 <co_new+0x79>
    free(co1);
    1e56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e5a:	48 89 c7             	mov    %rax,%rdi
    1e5d:	48 b8 f7 1a 00 00 00 	movabs $0x1af7,%rax
    1e64:	00 00 00 
    1e67:	ff d0                	callq  *%rax
    return 0;
    1e69:	b8 00 00 00 00       	mov    $0x0,%eax
    1e6e:	e9 9e 00 00 00       	jmpq   1f11 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1e73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e77:	48 8b 40 10          	mov    0x10(%rax),%rax
    1e7b:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    1e81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    1e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e89:	48 8d 50 30          	lea    0x30(%rax),%rdx
    1e8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1e91:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    1e94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e98:	48 83 c0 38          	add    $0x38,%rax
    1e9c:	48 ba 83 20 00 00 00 	movabs $0x2083,%rdx
    1ea3:	00 00 00 
    1ea6:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    1ea9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ead:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1eb1:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    1eb4:	48 b8 68 26 00 00 00 	movabs $0x2668,%rax
    1ebb:	00 00 00 
    1ebe:	48 8b 00             	mov    (%rax),%rax
    1ec1:	48 85 c0             	test   %rax,%rax
    1ec4:	75 13                	jne    1ed9 <co_new+0xdf>
  {
  	co_list = co1;
    1ec6:	48 ba 68 26 00 00 00 	movabs $0x2668,%rdx
    1ecd:	00 00 00 
    1ed0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ed4:	48 89 02             	mov    %rax,(%rdx)
    1ed7:	eb 34                	jmp    1f0d <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    1ed9:	48 b8 68 26 00 00 00 	movabs $0x2668,%rax
    1ee0:	00 00 00 
    1ee3:	48 8b 00             	mov    (%rax),%rax
    1ee6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1eea:	eb 0c                	jmp    1ef8 <co_new+0xfe>
	{
		head = head->next;
    1eec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef0:	48 8b 40 08          	mov    0x8(%rax),%rax
    1ef4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1ef8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1efc:	48 8b 40 08          	mov    0x8(%rax),%rax
    1f00:	48 85 c0             	test   %rax,%rax
    1f03:	75 e7                	jne    1eec <co_new+0xf2>
	}
	head = co1;
    1f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    1f0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    1f11:	c9                   	leaveq 
    1f12:	c3                   	retq   

0000000000001f13 <co_run>:

  int
co_run(void)
{
    1f13:	f3 0f 1e fa          	endbr64 
    1f17:	55                   	push   %rbp
    1f18:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    1f1b:	48 b8 68 26 00 00 00 	movabs $0x2668,%rax
    1f22:	00 00 00 
    1f25:	48 8b 00             	mov    (%rax),%rax
    1f28:	48 85 c0             	test   %rax,%rax
    1f2b:	74 4a                	je     1f77 <co_run+0x64>
	{
		co_current = co_list;
    1f2d:	48 b8 68 26 00 00 00 	movabs $0x2668,%rax
    1f34:	00 00 00 
    1f37:	48 8b 00             	mov    (%rax),%rax
    1f3a:	48 ba 60 26 00 00 00 	movabs $0x2660,%rdx
    1f41:	00 00 00 
    1f44:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    1f47:	48 b8 60 26 00 00 00 	movabs $0x2660,%rax
    1f4e:	00 00 00 
    1f51:	48 8b 00             	mov    (%rax),%rax
    1f54:	48 8b 00             	mov    (%rax),%rax
    1f57:	48 89 c6             	mov    %rax,%rsi
    1f5a:	48 bf 58 26 00 00 00 	movabs $0x2658,%rdi
    1f61:	00 00 00 
    1f64:	48 b8 e5 21 00 00 00 	movabs $0x21e5,%rax
    1f6b:	00 00 00 
    1f6e:	ff d0                	callq  *%rax
		return 1;
    1f70:	b8 01 00 00 00       	mov    $0x1,%eax
    1f75:	eb 05                	jmp    1f7c <co_run+0x69>
	}
	return 0;
    1f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1f7c:	5d                   	pop    %rbp
    1f7d:	c3                   	retq   

0000000000001f7e <co_run_all>:

  int
co_run_all(void)
{
    1f7e:	f3 0f 1e fa          	endbr64 
    1f82:	55                   	push   %rbp
    1f83:	48 89 e5             	mov    %rsp,%rbp
    1f86:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    1f8a:	48 b8 68 26 00 00 00 	movabs $0x2668,%rax
    1f91:	00 00 00 
    1f94:	48 8b 00             	mov    (%rax),%rax
    1f97:	48 85 c0             	test   %rax,%rax
    1f9a:	75 07                	jne    1fa3 <co_run_all+0x25>
		return 0;
    1f9c:	b8 00 00 00 00       	mov    $0x0,%eax
    1fa1:	eb 37                	jmp    1fda <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    1fa3:	48 b8 68 26 00 00 00 	movabs $0x2668,%rax
    1faa:	00 00 00 
    1fad:	48 8b 00             	mov    (%rax),%rax
    1fb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    1fb4:	eb 18                	jmp    1fce <co_run_all+0x50>
			co_run();
    1fb6:	48 b8 13 1f 00 00 00 	movabs $0x1f13,%rax
    1fbd:	00 00 00 
    1fc0:	ff d0                	callq  *%rax
			tmp = tmp->next;
    1fc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fc6:	48 8b 40 08          	mov    0x8(%rax),%rax
    1fca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    1fce:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1fd3:	75 e1                	jne    1fb6 <co_run_all+0x38>
		}
		return 1;
    1fd5:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    1fda:	c9                   	leaveq 
    1fdb:	c3                   	retq   

0000000000001fdc <co_yield>:

  void
co_yield()
{
    1fdc:	f3 0f 1e fa          	endbr64 
    1fe0:	55                   	push   %rbp
    1fe1:	48 89 e5             	mov    %rsp,%rbp
    1fe4:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    1fe8:	48 b8 60 26 00 00 00 	movabs $0x2660,%rax
    1fef:	00 00 00 
    1ff2:	48 8b 00             	mov    (%rax),%rax
    1ff5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    1ff9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ffd:	48 8b 40 08          	mov    0x8(%rax),%rax
    2001:	48 85 c0             	test   %rax,%rax
    2004:	74 46                	je     204c <co_yield+0x70>
  {
  	co_current = co_current->next;
    2006:	48 b8 60 26 00 00 00 	movabs $0x2660,%rax
    200d:	00 00 00 
    2010:	48 8b 00             	mov    (%rax),%rax
    2013:	48 8b 40 08          	mov    0x8(%rax),%rax
    2017:	48 ba 60 26 00 00 00 	movabs $0x2660,%rdx
    201e:	00 00 00 
    2021:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    2024:	48 b8 60 26 00 00 00 	movabs $0x2660,%rax
    202b:	00 00 00 
    202e:	48 8b 00             	mov    (%rax),%rax
    2031:	48 8b 10             	mov    (%rax),%rdx
    2034:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2038:	48 89 d6             	mov    %rdx,%rsi
    203b:	48 89 c7             	mov    %rax,%rdi
    203e:	48 b8 e5 21 00 00 00 	movabs $0x21e5,%rax
    2045:	00 00 00 
    2048:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    204a:	eb 34                	jmp    2080 <co_yield+0xa4>
	co_current = 0;
    204c:	48 b8 60 26 00 00 00 	movabs $0x2660,%rax
    2053:	00 00 00 
    2056:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    205d:	48 b8 58 26 00 00 00 	movabs $0x2658,%rax
    2064:	00 00 00 
    2067:	48 8b 10             	mov    (%rax),%rdx
    206a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    206e:	48 89 d6             	mov    %rdx,%rsi
    2071:	48 89 c7             	mov    %rax,%rdi
    2074:	48 b8 e5 21 00 00 00 	movabs $0x21e5,%rax
    207b:	00 00 00 
    207e:	ff d0                	callq  *%rax
}
    2080:	90                   	nop
    2081:	c9                   	leaveq 
    2082:	c3                   	retq   

0000000000002083 <co_exit>:

  void
co_exit(void)
{
    2083:	f3 0f 1e fa          	endbr64 
    2087:	55                   	push   %rbp
    2088:	48 89 e5             	mov    %rsp,%rbp
    208b:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    208f:	48 b8 60 26 00 00 00 	movabs $0x2660,%rax
    2096:	00 00 00 
    2099:	48 8b 00             	mov    (%rax),%rax
    209c:	48 85 c0             	test   %rax,%rax
    209f:	0f 84 ec 00 00 00    	je     2191 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    20a5:	48 b8 68 26 00 00 00 	movabs $0x2668,%rax
    20ac:	00 00 00 
    20af:	48 8b 00             	mov    (%rax),%rax
    20b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    20b6:	e9 c9 00 00 00       	jmpq   2184 <co_exit+0x101>
		if(tmp == co_current)
    20bb:	48 b8 60 26 00 00 00 	movabs $0x2660,%rax
    20c2:	00 00 00 
    20c5:	48 8b 00             	mov    (%rax),%rax
    20c8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    20cc:	0f 85 9e 00 00 00    	jne    2170 <co_exit+0xed>
		{
			if(tmp->next)
    20d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20d6:	48 8b 40 08          	mov    0x8(%rax),%rax
    20da:	48 85 c0             	test   %rax,%rax
    20dd:	74 54                	je     2133 <co_exit+0xb0>
			{
				if(prev)
    20df:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20e4:	74 10                	je     20f6 <co_exit+0x73>
				{
					prev->next = tmp->next;
    20e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20ea:	48 8b 50 08          	mov    0x8(%rax),%rdx
    20ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20f2:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    20f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20fa:	48 8b 40 08          	mov    0x8(%rax),%rax
    20fe:	48 ba 68 26 00 00 00 	movabs $0x2668,%rdx
    2105:	00 00 00 
    2108:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    210b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    210f:	48 8b 00             	mov    (%rax),%rax
    2112:	48 ba 60 26 00 00 00 	movabs $0x2660,%rdx
    2119:	00 00 00 
    211c:	48 8b 12             	mov    (%rdx),%rdx
    211f:	48 89 c6             	mov    %rax,%rsi
    2122:	48 89 d7             	mov    %rdx,%rdi
    2125:	48 b8 e5 21 00 00 00 	movabs $0x21e5,%rax
    212c:	00 00 00 
    212f:	ff d0                	callq  *%rax
    2131:	eb 3d                	jmp    2170 <co_exit+0xed>
			}else{
				co_list = 0;
    2133:	48 b8 68 26 00 00 00 	movabs $0x2668,%rax
    213a:	00 00 00 
    213d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    2144:	48 b8 58 26 00 00 00 	movabs $0x2658,%rax
    214b:	00 00 00 
    214e:	48 8b 00             	mov    (%rax),%rax
    2151:	48 ba 60 26 00 00 00 	movabs $0x2660,%rdx
    2158:	00 00 00 
    215b:	48 8b 12             	mov    (%rdx),%rdx
    215e:	48 89 c6             	mov    %rax,%rsi
    2161:	48 89 d7             	mov    %rdx,%rdi
    2164:	48 b8 e5 21 00 00 00 	movabs $0x21e5,%rax
    216b:	00 00 00 
    216e:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    2170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2174:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    2178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    217c:	48 8b 40 08          	mov    0x8(%rax),%rax
    2180:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    2184:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2189:	0f 85 2c ff ff ff    	jne    20bb <co_exit+0x38>
    218f:	eb 01                	jmp    2192 <co_exit+0x10f>
		return;
    2191:	90                   	nop
	}
}
    2192:	c9                   	leaveq 
    2193:	c3                   	retq   

0000000000002194 <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    2194:	f3 0f 1e fa          	endbr64 
    2198:	55                   	push   %rbp
    2199:	48 89 e5             	mov    %rsp,%rbp
    219c:	48 83 ec 10          	sub    $0x10,%rsp
    21a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    21a4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    21a9:	74 37                	je     21e2 <co_destroy+0x4e>
    if (co->stack)
    21ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21af:	48 8b 40 10          	mov    0x10(%rax),%rax
    21b3:	48 85 c0             	test   %rax,%rax
    21b6:	74 17                	je     21cf <co_destroy+0x3b>
      free(co->stack);
    21b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21bc:	48 8b 40 10          	mov    0x10(%rax),%rax
    21c0:	48 89 c7             	mov    %rax,%rdi
    21c3:	48 b8 f7 1a 00 00 00 	movabs $0x1af7,%rax
    21ca:	00 00 00 
    21cd:	ff d0                	callq  *%rax
    free(co);
    21cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21d3:	48 89 c7             	mov    %rax,%rdi
    21d6:	48 b8 f7 1a 00 00 00 	movabs $0x1af7,%rax
    21dd:	00 00 00 
    21e0:	ff d0                	callq  *%rax
  }
}
    21e2:	90                   	nop
    21e3:	c9                   	leaveq 
    21e4:	c3                   	retq   

00000000000021e5 <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    21e5:	55                   	push   %rbp
  pushq   %rbx
    21e6:	53                   	push   %rbx
  pushq   %r12
    21e7:	41 54                	push   %r12
  pushq   %r13
    21e9:	41 55                	push   %r13
  pushq   %r14
    21eb:	41 56                	push   %r14
  pushq   %r15
    21ed:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    21ef:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    21f2:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    21f5:	41 5f                	pop    %r15
  popq    %r14
    21f7:	41 5e                	pop    %r14
  popq    %r13
    21f9:	41 5d                	pop    %r13
  popq    %r12
    21fb:	41 5c                	pop    %r12
  popq    %rbx
    21fd:	5b                   	pop    %rbx
  popq    %rbp
    21fe:	5d                   	pop    %rbp

  retq #??
    21ff:	c3                   	retq   
