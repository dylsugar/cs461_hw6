
_co_easy:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <co_hello>:
#include "user.h"
#include "param.h"

  void
co_hello(void)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "Hello coroutine!\n");
    1008:	48 be b8 22 00 00 00 	movabs $0x22b8,%rsi
    100f:	00 00 00 
    1012:	bf 01 00 00 00       	mov    $0x1,%edi
    1017:	b8 00 00 00 00       	mov    $0x0,%eax
    101c:	48 ba 9e 17 00 00 00 	movabs $0x179e,%rdx
    1023:	00 00 00 
    1026:	ff d2                	callq  *%rdx
  co_yield();
    1028:	48 b8 93 20 00 00 00 	movabs $0x2093,%rax
    102f:	00 00 00 
    1032:	ff d0                	callq  *%rax
  printf(1, "Hello Again!\n");
    1034:	48 be ca 22 00 00 00 	movabs $0x22ca,%rsi
    103b:	00 00 00 
    103e:	bf 01 00 00 00       	mov    $0x1,%edi
    1043:	b8 00 00 00 00       	mov    $0x0,%eax
    1048:	48 ba 9e 17 00 00 00 	movabs $0x179e,%rdx
    104f:	00 00 00 
    1052:	ff d2                	callq  *%rdx
}
    1054:	90                   	nop
    1055:	5d                   	pop    %rbp
    1056:	c3                   	retq   

0000000000001057 <main>:

  int
main(int argc, char ** argv)
{
    1057:	f3 0f 1e fa          	endbr64 
    105b:	55                   	push   %rbp
    105c:	48 89 e5             	mov    %rsp,%rbp
    105f:	48 83 ec 20          	sub    $0x20,%rsp
    1063:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1066:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct coroutine * co = co_new(co_hello);
    106a:	48 bf 00 10 00 00 00 	movabs $0x1000,%rdi
    1071:	00 00 00 
    1074:	48 b8 b1 1e 00 00 00 	movabs $0x1eb1,%rax
    107b:	00 00 00 
    107e:	ff d0                	callq  *%rax
    1080:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  printf(1, "host: one coroutine created!\n");
    1084:	48 be d8 22 00 00 00 	movabs $0x22d8,%rsi
    108b:	00 00 00 
    108e:	bf 01 00 00 00       	mov    $0x1,%edi
    1093:	b8 00 00 00 00       	mov    $0x0,%eax
    1098:	48 ba 9e 17 00 00 00 	movabs $0x179e,%rdx
    109f:	00 00 00 
    10a2:	ff d2                	callq  *%rdx
  if (co_run() == 0) {
    10a4:	48 b8 ca 1f 00 00 00 	movabs $0x1fca,%rax
    10ab:	00 00 00 
    10ae:	ff d0                	callq  *%rax
    10b0:	85 c0                	test   %eax,%eax
    10b2:	75 2c                	jne    10e0 <main+0x89>
    printf(1, "host: co_run() failed (1st)\n");
    10b4:	48 be f6 22 00 00 00 	movabs $0x22f6,%rsi
    10bb:	00 00 00 
    10be:	bf 01 00 00 00       	mov    $0x1,%edi
    10c3:	b8 00 00 00 00       	mov    $0x0,%eax
    10c8:	48 ba 9e 17 00 00 00 	movabs $0x179e,%rdx
    10cf:	00 00 00 
    10d2:	ff d2                	callq  *%rdx
    exit();
    10d4:	48 b8 b4 14 00 00 00 	movabs $0x14b4,%rax
    10db:	00 00 00 
    10de:	ff d0                	callq  *%rax
  } else {
    printf(1, "host: Expecting one more Hello after this line\n");
    10e0:	48 be 18 23 00 00 00 	movabs $0x2318,%rsi
    10e7:	00 00 00 
    10ea:	bf 01 00 00 00       	mov    $0x1,%edi
    10ef:	b8 00 00 00 00       	mov    $0x0,%eax
    10f4:	48 ba 9e 17 00 00 00 	movabs $0x179e,%rdx
    10fb:	00 00 00 
    10fe:	ff d2                	callq  *%rdx
  }
  if (co_run() == 0) {
    1100:	48 b8 ca 1f 00 00 00 	movabs $0x1fca,%rax
    1107:	00 00 00 
    110a:	ff d0                	callq  *%rax
    110c:	85 c0                	test   %eax,%eax
    110e:	75 22                	jne    1132 <main+0xdb>
    printf(1, "host: co_run() failed (2nd)\n");
    1110:	48 be 48 23 00 00 00 	movabs $0x2348,%rsi
    1117:	00 00 00 
    111a:	bf 01 00 00 00       	mov    $0x1,%edi
    111f:	b8 00 00 00 00       	mov    $0x0,%eax
    1124:	48 ba 9e 17 00 00 00 	movabs $0x179e,%rdx
    112b:	00 00 00 
    112e:	ff d2                	callq  *%rdx
    1130:	eb 20                	jmp    1152 <main+0xfb>
  } else {
    printf(1, "host: coroutine returned\n");
    1132:	48 be 65 23 00 00 00 	movabs $0x2365,%rsi
    1139:	00 00 00 
    113c:	bf 01 00 00 00       	mov    $0x1,%edi
    1141:	b8 00 00 00 00       	mov    $0x0,%eax
    1146:	48 ba 9e 17 00 00 00 	movabs $0x179e,%rdx
    114d:	00 00 00 
    1150:	ff d2                	callq  *%rdx
  }
  co_destroy(co);
    1152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1156:	48 89 c7             	mov    %rax,%rdi
    1159:	48 b8 4b 22 00 00 00 	movabs $0x224b,%rax
    1160:	00 00 00 
    1163:	ff d0                	callq  *%rax
  exit();
    1165:	48 b8 b4 14 00 00 00 	movabs $0x14b4,%rax
    116c:	00 00 00 
    116f:	ff d0                	callq  *%rax

0000000000001171 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1171:	f3 0f 1e fa          	endbr64 
    1175:	55                   	push   %rbp
    1176:	48 89 e5             	mov    %rsp,%rbp
    1179:	48 83 ec 10          	sub    $0x10,%rsp
    117d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1181:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1184:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1187:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    118b:	8b 55 f0             	mov    -0x10(%rbp),%edx
    118e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1191:	48 89 ce             	mov    %rcx,%rsi
    1194:	48 89 f7             	mov    %rsi,%rdi
    1197:	89 d1                	mov    %edx,%ecx
    1199:	fc                   	cld    
    119a:	f3 aa                	rep stos %al,%es:(%rdi)
    119c:	89 ca                	mov    %ecx,%edx
    119e:	48 89 fe             	mov    %rdi,%rsi
    11a1:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11a5:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11a8:	90                   	nop
    11a9:	c9                   	leaveq 
    11aa:	c3                   	retq   

00000000000011ab <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11ab:	f3 0f 1e fa          	endbr64 
    11af:	55                   	push   %rbp
    11b0:	48 89 e5             	mov    %rsp,%rbp
    11b3:	48 83 ec 20          	sub    $0x20,%rsp
    11b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    11bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    11c7:	90                   	nop
    11c8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    11cc:	48 8d 42 01          	lea    0x1(%rdx),%rax
    11d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    11d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11d8:	48 8d 48 01          	lea    0x1(%rax),%rcx
    11dc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    11e0:	0f b6 12             	movzbl (%rdx),%edx
    11e3:	88 10                	mov    %dl,(%rax)
    11e5:	0f b6 00             	movzbl (%rax),%eax
    11e8:	84 c0                	test   %al,%al
    11ea:	75 dc                	jne    11c8 <strcpy+0x1d>
    ;
  return os;
    11ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11f0:	c9                   	leaveq 
    11f1:	c3                   	retq   

00000000000011f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    11f2:	f3 0f 1e fa          	endbr64 
    11f6:	55                   	push   %rbp
    11f7:	48 89 e5             	mov    %rsp,%rbp
    11fa:	48 83 ec 10          	sub    $0x10,%rsp
    11fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1206:	eb 0a                	jmp    1212 <strcmp+0x20>
    p++, q++;
    1208:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    120d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1216:	0f b6 00             	movzbl (%rax),%eax
    1219:	84 c0                	test   %al,%al
    121b:	74 12                	je     122f <strcmp+0x3d>
    121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1221:	0f b6 10             	movzbl (%rax),%edx
    1224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1228:	0f b6 00             	movzbl (%rax),%eax
    122b:	38 c2                	cmp    %al,%dl
    122d:	74 d9                	je     1208 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    122f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1233:	0f b6 00             	movzbl (%rax),%eax
    1236:	0f b6 d0             	movzbl %al,%edx
    1239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    123d:	0f b6 00             	movzbl (%rax),%eax
    1240:	0f b6 c0             	movzbl %al,%eax
    1243:	29 c2                	sub    %eax,%edx
    1245:	89 d0                	mov    %edx,%eax
}
    1247:	c9                   	leaveq 
    1248:	c3                   	retq   

0000000000001249 <strlen>:

uint
strlen(char *s)
{
    1249:	f3 0f 1e fa          	endbr64 
    124d:	55                   	push   %rbp
    124e:	48 89 e5             	mov    %rsp,%rbp
    1251:	48 83 ec 18          	sub    $0x18,%rsp
    1255:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1260:	eb 04                	jmp    1266 <strlen+0x1d>
    1262:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1266:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1269:	48 63 d0             	movslq %eax,%rdx
    126c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1270:	48 01 d0             	add    %rdx,%rax
    1273:	0f b6 00             	movzbl (%rax),%eax
    1276:	84 c0                	test   %al,%al
    1278:	75 e8                	jne    1262 <strlen+0x19>
    ;
  return n;
    127a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    127d:	c9                   	leaveq 
    127e:	c3                   	retq   

000000000000127f <memset>:

void*
memset(void *dst, int c, uint n)
{
    127f:	f3 0f 1e fa          	endbr64 
    1283:	55                   	push   %rbp
    1284:	48 89 e5             	mov    %rsp,%rbp
    1287:	48 83 ec 10          	sub    $0x10,%rsp
    128b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    128f:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1292:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1295:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1298:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    129b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    129f:	89 ce                	mov    %ecx,%esi
    12a1:	48 89 c7             	mov    %rax,%rdi
    12a4:	48 b8 71 11 00 00 00 	movabs $0x1171,%rax
    12ab:	00 00 00 
    12ae:	ff d0                	callq  *%rax
  return dst;
    12b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12b4:	c9                   	leaveq 
    12b5:	c3                   	retq   

00000000000012b6 <strchr>:

char*
strchr(const char *s, char c)
{
    12b6:	f3 0f 1e fa          	endbr64 
    12ba:	55                   	push   %rbp
    12bb:	48 89 e5             	mov    %rsp,%rbp
    12be:	48 83 ec 10          	sub    $0x10,%rsp
    12c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12c6:	89 f0                	mov    %esi,%eax
    12c8:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    12cb:	eb 17                	jmp    12e4 <strchr+0x2e>
    if(*s == c)
    12cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12d1:	0f b6 00             	movzbl (%rax),%eax
    12d4:	38 45 f4             	cmp    %al,-0xc(%rbp)
    12d7:	75 06                	jne    12df <strchr+0x29>
      return (char*)s;
    12d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12dd:	eb 15                	jmp    12f4 <strchr+0x3e>
  for(; *s; s++)
    12df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12e8:	0f b6 00             	movzbl (%rax),%eax
    12eb:	84 c0                	test   %al,%al
    12ed:	75 de                	jne    12cd <strchr+0x17>
  return 0;
    12ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12f4:	c9                   	leaveq 
    12f5:	c3                   	retq   

00000000000012f6 <gets>:

char*
gets(char *buf, int max)
{
    12f6:	f3 0f 1e fa          	endbr64 
    12fa:	55                   	push   %rbp
    12fb:	48 89 e5             	mov    %rsp,%rbp
    12fe:	48 83 ec 20          	sub    $0x20,%rsp
    1302:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1306:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1309:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1310:	eb 4f                	jmp    1361 <gets+0x6b>
    cc = read(0, &c, 1);
    1312:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1316:	ba 01 00 00 00       	mov    $0x1,%edx
    131b:	48 89 c6             	mov    %rax,%rsi
    131e:	bf 00 00 00 00       	mov    $0x0,%edi
    1323:	48 b8 db 14 00 00 00 	movabs $0x14db,%rax
    132a:	00 00 00 
    132d:	ff d0                	callq  *%rax
    132f:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1332:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1336:	7e 36                	jle    136e <gets+0x78>
      break;
    buf[i++] = c;
    1338:	8b 45 fc             	mov    -0x4(%rbp),%eax
    133b:	8d 50 01             	lea    0x1(%rax),%edx
    133e:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1341:	48 63 d0             	movslq %eax,%rdx
    1344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1348:	48 01 c2             	add    %rax,%rdx
    134b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    134f:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1351:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1355:	3c 0a                	cmp    $0xa,%al
    1357:	74 16                	je     136f <gets+0x79>
    1359:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    135d:	3c 0d                	cmp    $0xd,%al
    135f:	74 0e                	je     136f <gets+0x79>
  for(i=0; i+1 < max; ){
    1361:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1364:	83 c0 01             	add    $0x1,%eax
    1367:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    136a:	7f a6                	jg     1312 <gets+0x1c>
    136c:	eb 01                	jmp    136f <gets+0x79>
      break;
    136e:	90                   	nop
      break;
  }
  buf[i] = '\0';
    136f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1372:	48 63 d0             	movslq %eax,%rdx
    1375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1379:	48 01 d0             	add    %rdx,%rax
    137c:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    137f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1383:	c9                   	leaveq 
    1384:	c3                   	retq   

0000000000001385 <stat>:

int
stat(char *n, struct stat *st)
{
    1385:	f3 0f 1e fa          	endbr64 
    1389:	55                   	push   %rbp
    138a:	48 89 e5             	mov    %rsp,%rbp
    138d:	48 83 ec 20          	sub    $0x20,%rsp
    1391:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1395:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    139d:	be 00 00 00 00       	mov    $0x0,%esi
    13a2:	48 89 c7             	mov    %rax,%rdi
    13a5:	48 b8 1c 15 00 00 00 	movabs $0x151c,%rax
    13ac:	00 00 00 
    13af:	ff d0                	callq  *%rax
    13b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    13b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    13b8:	79 07                	jns    13c1 <stat+0x3c>
    return -1;
    13ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13bf:	eb 2f                	jmp    13f0 <stat+0x6b>
  r = fstat(fd, st);
    13c1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    13c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13c8:	48 89 d6             	mov    %rdx,%rsi
    13cb:	89 c7                	mov    %eax,%edi
    13cd:	48 b8 43 15 00 00 00 	movabs $0x1543,%rax
    13d4:	00 00 00 
    13d7:	ff d0                	callq  *%rax
    13d9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    13dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13df:	89 c7                	mov    %eax,%edi
    13e1:	48 b8 f5 14 00 00 00 	movabs $0x14f5,%rax
    13e8:	00 00 00 
    13eb:	ff d0                	callq  *%rax
  return r;
    13ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    13f0:	c9                   	leaveq 
    13f1:	c3                   	retq   

00000000000013f2 <atoi>:

int
atoi(const char *s)
{
    13f2:	f3 0f 1e fa          	endbr64 
    13f6:	55                   	push   %rbp
    13f7:	48 89 e5             	mov    %rsp,%rbp
    13fa:	48 83 ec 18          	sub    $0x18,%rsp
    13fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1409:	eb 28                	jmp    1433 <atoi+0x41>
    n = n*10 + *s++ - '0';
    140b:	8b 55 fc             	mov    -0x4(%rbp),%edx
    140e:	89 d0                	mov    %edx,%eax
    1410:	c1 e0 02             	shl    $0x2,%eax
    1413:	01 d0                	add    %edx,%eax
    1415:	01 c0                	add    %eax,%eax
    1417:	89 c1                	mov    %eax,%ecx
    1419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    141d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1421:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1425:	0f b6 00             	movzbl (%rax),%eax
    1428:	0f be c0             	movsbl %al,%eax
    142b:	01 c8                	add    %ecx,%eax
    142d:	83 e8 30             	sub    $0x30,%eax
    1430:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1437:	0f b6 00             	movzbl (%rax),%eax
    143a:	3c 2f                	cmp    $0x2f,%al
    143c:	7e 0b                	jle    1449 <atoi+0x57>
    143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1442:	0f b6 00             	movzbl (%rax),%eax
    1445:	3c 39                	cmp    $0x39,%al
    1447:	7e c2                	jle    140b <atoi+0x19>
  return n;
    1449:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    144c:	c9                   	leaveq 
    144d:	c3                   	retq   

000000000000144e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    144e:	f3 0f 1e fa          	endbr64 
    1452:	55                   	push   %rbp
    1453:	48 89 e5             	mov    %rsp,%rbp
    1456:	48 83 ec 28          	sub    $0x28,%rsp
    145a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    145e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1462:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1469:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    146d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1471:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1475:	eb 1d                	jmp    1494 <memmove+0x46>
    *dst++ = *src++;
    1477:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    147b:	48 8d 42 01          	lea    0x1(%rdx),%rax
    147f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1487:	48 8d 48 01          	lea    0x1(%rax),%rcx
    148b:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    148f:	0f b6 12             	movzbl (%rdx),%edx
    1492:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1494:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1497:	8d 50 ff             	lea    -0x1(%rax),%edx
    149a:	89 55 dc             	mov    %edx,-0x24(%rbp)
    149d:	85 c0                	test   %eax,%eax
    149f:	7f d6                	jg     1477 <memmove+0x29>
  return vdst;
    14a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14a5:	c9                   	leaveq 
    14a6:	c3                   	retq   

00000000000014a7 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14a7:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14ae:	49 89 ca             	mov    %rcx,%r10
    14b1:	0f 05                	syscall 
    14b3:	c3                   	retq   

00000000000014b4 <exit>:
SYSCALL(exit)
    14b4:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    14bb:	49 89 ca             	mov    %rcx,%r10
    14be:	0f 05                	syscall 
    14c0:	c3                   	retq   

00000000000014c1 <wait>:
SYSCALL(wait)
    14c1:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    14c8:	49 89 ca             	mov    %rcx,%r10
    14cb:	0f 05                	syscall 
    14cd:	c3                   	retq   

00000000000014ce <pipe>:
SYSCALL(pipe)
    14ce:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    14d5:	49 89 ca             	mov    %rcx,%r10
    14d8:	0f 05                	syscall 
    14da:	c3                   	retq   

00000000000014db <read>:
SYSCALL(read)
    14db:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    14e2:	49 89 ca             	mov    %rcx,%r10
    14e5:	0f 05                	syscall 
    14e7:	c3                   	retq   

00000000000014e8 <write>:
SYSCALL(write)
    14e8:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    14ef:	49 89 ca             	mov    %rcx,%r10
    14f2:	0f 05                	syscall 
    14f4:	c3                   	retq   

00000000000014f5 <close>:
SYSCALL(close)
    14f5:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    14fc:	49 89 ca             	mov    %rcx,%r10
    14ff:	0f 05                	syscall 
    1501:	c3                   	retq   

0000000000001502 <kill>:
SYSCALL(kill)
    1502:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1509:	49 89 ca             	mov    %rcx,%r10
    150c:	0f 05                	syscall 
    150e:	c3                   	retq   

000000000000150f <exec>:
SYSCALL(exec)
    150f:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1516:	49 89 ca             	mov    %rcx,%r10
    1519:	0f 05                	syscall 
    151b:	c3                   	retq   

000000000000151c <open>:
SYSCALL(open)
    151c:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1523:	49 89 ca             	mov    %rcx,%r10
    1526:	0f 05                	syscall 
    1528:	c3                   	retq   

0000000000001529 <mknod>:
SYSCALL(mknod)
    1529:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1530:	49 89 ca             	mov    %rcx,%r10
    1533:	0f 05                	syscall 
    1535:	c3                   	retq   

0000000000001536 <unlink>:
SYSCALL(unlink)
    1536:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    153d:	49 89 ca             	mov    %rcx,%r10
    1540:	0f 05                	syscall 
    1542:	c3                   	retq   

0000000000001543 <fstat>:
SYSCALL(fstat)
    1543:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    154a:	49 89 ca             	mov    %rcx,%r10
    154d:	0f 05                	syscall 
    154f:	c3                   	retq   

0000000000001550 <link>:
SYSCALL(link)
    1550:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1557:	49 89 ca             	mov    %rcx,%r10
    155a:	0f 05                	syscall 
    155c:	c3                   	retq   

000000000000155d <mkdir>:
SYSCALL(mkdir)
    155d:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1564:	49 89 ca             	mov    %rcx,%r10
    1567:	0f 05                	syscall 
    1569:	c3                   	retq   

000000000000156a <chdir>:
SYSCALL(chdir)
    156a:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1571:	49 89 ca             	mov    %rcx,%r10
    1574:	0f 05                	syscall 
    1576:	c3                   	retq   

0000000000001577 <dup>:
SYSCALL(dup)
    1577:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    157e:	49 89 ca             	mov    %rcx,%r10
    1581:	0f 05                	syscall 
    1583:	c3                   	retq   

0000000000001584 <getpid>:
SYSCALL(getpid)
    1584:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    158b:	49 89 ca             	mov    %rcx,%r10
    158e:	0f 05                	syscall 
    1590:	c3                   	retq   

0000000000001591 <sbrk>:
SYSCALL(sbrk)
    1591:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1598:	49 89 ca             	mov    %rcx,%r10
    159b:	0f 05                	syscall 
    159d:	c3                   	retq   

000000000000159e <sleep>:
SYSCALL(sleep)
    159e:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15a5:	49 89 ca             	mov    %rcx,%r10
    15a8:	0f 05                	syscall 
    15aa:	c3                   	retq   

00000000000015ab <uptime>:
SYSCALL(uptime)
    15ab:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    15b2:	49 89 ca             	mov    %rcx,%r10
    15b5:	0f 05                	syscall 
    15b7:	c3                   	retq   

00000000000015b8 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    15b8:	f3 0f 1e fa          	endbr64 
    15bc:	55                   	push   %rbp
    15bd:	48 89 e5             	mov    %rsp,%rbp
    15c0:	48 83 ec 10          	sub    $0x10,%rsp
    15c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
    15c7:	89 f0                	mov    %esi,%eax
    15c9:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    15cc:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    15d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15d3:	ba 01 00 00 00       	mov    $0x1,%edx
    15d8:	48 89 ce             	mov    %rcx,%rsi
    15db:	89 c7                	mov    %eax,%edi
    15dd:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    15e4:	00 00 00 
    15e7:	ff d0                	callq  *%rax
}
    15e9:	90                   	nop
    15ea:	c9                   	leaveq 
    15eb:	c3                   	retq   

00000000000015ec <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    15ec:	f3 0f 1e fa          	endbr64 
    15f0:	55                   	push   %rbp
    15f1:	48 89 e5             	mov    %rsp,%rbp
    15f4:	48 83 ec 20          	sub    $0x20,%rsp
    15f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    15ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1606:	eb 35                	jmp    163d <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1608:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    160c:	48 c1 e8 3c          	shr    $0x3c,%rax
    1610:	48 ba 90 27 00 00 00 	movabs $0x2790,%rdx
    1617:	00 00 00 
    161a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    161e:	0f be d0             	movsbl %al,%edx
    1621:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1624:	89 d6                	mov    %edx,%esi
    1626:	89 c7                	mov    %eax,%edi
    1628:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    162f:	00 00 00 
    1632:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1634:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1638:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    163d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1640:	83 f8 0f             	cmp    $0xf,%eax
    1643:	76 c3                	jbe    1608 <print_x64+0x1c>
}
    1645:	90                   	nop
    1646:	90                   	nop
    1647:	c9                   	leaveq 
    1648:	c3                   	retq   

0000000000001649 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1649:	f3 0f 1e fa          	endbr64 
    164d:	55                   	push   %rbp
    164e:	48 89 e5             	mov    %rsp,%rbp
    1651:	48 83 ec 20          	sub    $0x20,%rsp
    1655:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1658:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    165b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1662:	eb 36                	jmp    169a <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1664:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1667:	c1 e8 1c             	shr    $0x1c,%eax
    166a:	89 c2                	mov    %eax,%edx
    166c:	48 b8 90 27 00 00 00 	movabs $0x2790,%rax
    1673:	00 00 00 
    1676:	89 d2                	mov    %edx,%edx
    1678:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    167c:	0f be d0             	movsbl %al,%edx
    167f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1682:	89 d6                	mov    %edx,%esi
    1684:	89 c7                	mov    %eax,%edi
    1686:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    168d:	00 00 00 
    1690:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1692:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1696:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    169a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    169d:	83 f8 07             	cmp    $0x7,%eax
    16a0:	76 c2                	jbe    1664 <print_x32+0x1b>
}
    16a2:	90                   	nop
    16a3:	90                   	nop
    16a4:	c9                   	leaveq 
    16a5:	c3                   	retq   

00000000000016a6 <print_d>:

  static void
print_d(int fd, int v)
{
    16a6:	f3 0f 1e fa          	endbr64 
    16aa:	55                   	push   %rbp
    16ab:	48 89 e5             	mov    %rsp,%rbp
    16ae:	48 83 ec 30          	sub    $0x30,%rsp
    16b2:	89 7d dc             	mov    %edi,-0x24(%rbp)
    16b5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    16b8:	8b 45 d8             	mov    -0x28(%rbp),%eax
    16bb:	48 98                	cltq   
    16bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    16c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16c5:	79 04                	jns    16cb <print_d+0x25>
    x = -x;
    16c7:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    16cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    16d2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    16d6:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    16dd:	66 66 66 
    16e0:	48 89 c8             	mov    %rcx,%rax
    16e3:	48 f7 ea             	imul   %rdx
    16e6:	48 c1 fa 02          	sar    $0x2,%rdx
    16ea:	48 89 c8             	mov    %rcx,%rax
    16ed:	48 c1 f8 3f          	sar    $0x3f,%rax
    16f1:	48 29 c2             	sub    %rax,%rdx
    16f4:	48 89 d0             	mov    %rdx,%rax
    16f7:	48 c1 e0 02          	shl    $0x2,%rax
    16fb:	48 01 d0             	add    %rdx,%rax
    16fe:	48 01 c0             	add    %rax,%rax
    1701:	48 29 c1             	sub    %rax,%rcx
    1704:	48 89 ca             	mov    %rcx,%rdx
    1707:	8b 45 f4             	mov    -0xc(%rbp),%eax
    170a:	8d 48 01             	lea    0x1(%rax),%ecx
    170d:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1710:	48 b9 90 27 00 00 00 	movabs $0x2790,%rcx
    1717:	00 00 00 
    171a:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    171e:	48 98                	cltq   
    1720:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1724:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1728:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    172f:	66 66 66 
    1732:	48 89 c8             	mov    %rcx,%rax
    1735:	48 f7 ea             	imul   %rdx
    1738:	48 c1 fa 02          	sar    $0x2,%rdx
    173c:	48 89 c8             	mov    %rcx,%rax
    173f:	48 c1 f8 3f          	sar    $0x3f,%rax
    1743:	48 29 c2             	sub    %rax,%rdx
    1746:	48 89 d0             	mov    %rdx,%rax
    1749:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    174d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1752:	0f 85 7a ff ff ff    	jne    16d2 <print_d+0x2c>

  if (v < 0)
    1758:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    175c:	79 32                	jns    1790 <print_d+0xea>
    buf[i++] = '-';
    175e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1761:	8d 50 01             	lea    0x1(%rax),%edx
    1764:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1767:	48 98                	cltq   
    1769:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    176e:	eb 20                	jmp    1790 <print_d+0xea>
    putc(fd, buf[i]);
    1770:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1773:	48 98                	cltq   
    1775:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    177a:	0f be d0             	movsbl %al,%edx
    177d:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1780:	89 d6                	mov    %edx,%esi
    1782:	89 c7                	mov    %eax,%edi
    1784:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    178b:	00 00 00 
    178e:	ff d0                	callq  *%rax
  while (--i >= 0)
    1790:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1794:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1798:	79 d6                	jns    1770 <print_d+0xca>
}
    179a:	90                   	nop
    179b:	90                   	nop
    179c:	c9                   	leaveq 
    179d:	c3                   	retq   

000000000000179e <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    179e:	f3 0f 1e fa          	endbr64 
    17a2:	55                   	push   %rbp
    17a3:	48 89 e5             	mov    %rsp,%rbp
    17a6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    17ad:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    17b3:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    17ba:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    17c1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    17c8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    17cf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    17d6:	84 c0                	test   %al,%al
    17d8:	74 20                	je     17fa <printf+0x5c>
    17da:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    17de:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    17e2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    17e6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    17ea:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    17ee:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    17f2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    17f6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    17fa:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1801:	00 00 00 
    1804:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    180b:	00 00 00 
    180e:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1812:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1819:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1820:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1827:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    182e:	00 00 00 
    1831:	e9 41 03 00 00       	jmpq   1b77 <printf+0x3d9>
    if (c != '%') {
    1836:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    183d:	74 24                	je     1863 <printf+0xc5>
      putc(fd, c);
    183f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1845:	0f be d0             	movsbl %al,%edx
    1848:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    184e:	89 d6                	mov    %edx,%esi
    1850:	89 c7                	mov    %eax,%edi
    1852:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1859:	00 00 00 
    185c:	ff d0                	callq  *%rax
      continue;
    185e:	e9 0d 03 00 00       	jmpq   1b70 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1863:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    186a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1870:	48 63 d0             	movslq %eax,%rdx
    1873:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    187a:	48 01 d0             	add    %rdx,%rax
    187d:	0f b6 00             	movzbl (%rax),%eax
    1880:	0f be c0             	movsbl %al,%eax
    1883:	25 ff 00 00 00       	and    $0xff,%eax
    1888:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    188e:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1895:	0f 84 0f 03 00 00    	je     1baa <printf+0x40c>
      break;
    switch(c) {
    189b:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18a2:	0f 84 74 02 00 00    	je     1b1c <printf+0x37e>
    18a8:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18af:	0f 8c 82 02 00 00    	jl     1b37 <printf+0x399>
    18b5:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    18bc:	0f 8f 75 02 00 00    	jg     1b37 <printf+0x399>
    18c2:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    18c9:	0f 8c 68 02 00 00    	jl     1b37 <printf+0x399>
    18cf:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    18d5:	83 e8 63             	sub    $0x63,%eax
    18d8:	83 f8 15             	cmp    $0x15,%eax
    18db:	0f 87 56 02 00 00    	ja     1b37 <printf+0x399>
    18e1:	89 c0                	mov    %eax,%eax
    18e3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    18ea:	00 
    18eb:	48 b8 88 23 00 00 00 	movabs $0x2388,%rax
    18f2:	00 00 00 
    18f5:	48 01 d0             	add    %rdx,%rax
    18f8:	48 8b 00             	mov    (%rax),%rax
    18fb:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    18fe:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1904:	83 f8 2f             	cmp    $0x2f,%eax
    1907:	77 23                	ja     192c <printf+0x18e>
    1909:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1910:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1916:	89 d2                	mov    %edx,%edx
    1918:	48 01 d0             	add    %rdx,%rax
    191b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1921:	83 c2 08             	add    $0x8,%edx
    1924:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    192a:	eb 12                	jmp    193e <printf+0x1a0>
    192c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1933:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1937:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    193e:	8b 00                	mov    (%rax),%eax
    1940:	0f be d0             	movsbl %al,%edx
    1943:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1949:	89 d6                	mov    %edx,%esi
    194b:	89 c7                	mov    %eax,%edi
    194d:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1954:	00 00 00 
    1957:	ff d0                	callq  *%rax
      break;
    1959:	e9 12 02 00 00       	jmpq   1b70 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    195e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1964:	83 f8 2f             	cmp    $0x2f,%eax
    1967:	77 23                	ja     198c <printf+0x1ee>
    1969:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1970:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1976:	89 d2                	mov    %edx,%edx
    1978:	48 01 d0             	add    %rdx,%rax
    197b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1981:	83 c2 08             	add    $0x8,%edx
    1984:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    198a:	eb 12                	jmp    199e <printf+0x200>
    198c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1993:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1997:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    199e:	8b 10                	mov    (%rax),%edx
    19a0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19a6:	89 d6                	mov    %edx,%esi
    19a8:	89 c7                	mov    %eax,%edi
    19aa:	48 b8 a6 16 00 00 00 	movabs $0x16a6,%rax
    19b1:	00 00 00 
    19b4:	ff d0                	callq  *%rax
      break;
    19b6:	e9 b5 01 00 00       	jmpq   1b70 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    19bb:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19c1:	83 f8 2f             	cmp    $0x2f,%eax
    19c4:	77 23                	ja     19e9 <printf+0x24b>
    19c6:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19cd:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d3:	89 d2                	mov    %edx,%edx
    19d5:	48 01 d0             	add    %rdx,%rax
    19d8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19de:	83 c2 08             	add    $0x8,%edx
    19e1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19e7:	eb 12                	jmp    19fb <printf+0x25d>
    19e9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19f0:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19f4:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19fb:	8b 10                	mov    (%rax),%edx
    19fd:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a03:	89 d6                	mov    %edx,%esi
    1a05:	89 c7                	mov    %eax,%edi
    1a07:	48 b8 49 16 00 00 00 	movabs $0x1649,%rax
    1a0e:	00 00 00 
    1a11:	ff d0                	callq  *%rax
      break;
    1a13:	e9 58 01 00 00       	jmpq   1b70 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a18:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a1e:	83 f8 2f             	cmp    $0x2f,%eax
    1a21:	77 23                	ja     1a46 <printf+0x2a8>
    1a23:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a2a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a30:	89 d2                	mov    %edx,%edx
    1a32:	48 01 d0             	add    %rdx,%rax
    1a35:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a3b:	83 c2 08             	add    $0x8,%edx
    1a3e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a44:	eb 12                	jmp    1a58 <printf+0x2ba>
    1a46:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a4d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a51:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a58:	48 8b 10             	mov    (%rax),%rdx
    1a5b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a61:	48 89 d6             	mov    %rdx,%rsi
    1a64:	89 c7                	mov    %eax,%edi
    1a66:	48 b8 ec 15 00 00 00 	movabs $0x15ec,%rax
    1a6d:	00 00 00 
    1a70:	ff d0                	callq  *%rax
      break;
    1a72:	e9 f9 00 00 00       	jmpq   1b70 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1a77:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a7d:	83 f8 2f             	cmp    $0x2f,%eax
    1a80:	77 23                	ja     1aa5 <printf+0x307>
    1a82:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a89:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a8f:	89 d2                	mov    %edx,%edx
    1a91:	48 01 d0             	add    %rdx,%rax
    1a94:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a9a:	83 c2 08             	add    $0x8,%edx
    1a9d:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1aa3:	eb 12                	jmp    1ab7 <printf+0x319>
    1aa5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1aac:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1ab0:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ab7:	48 8b 00             	mov    (%rax),%rax
    1aba:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1ac1:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1ac8:	00 
    1ac9:	75 41                	jne    1b0c <printf+0x36e>
        s = "(null)";
    1acb:	48 b8 80 23 00 00 00 	movabs $0x2380,%rax
    1ad2:	00 00 00 
    1ad5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1adc:	eb 2e                	jmp    1b0c <printf+0x36e>
        putc(fd, *(s++));
    1ade:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1ae5:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1ae9:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1af0:	0f b6 00             	movzbl (%rax),%eax
    1af3:	0f be d0             	movsbl %al,%edx
    1af6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1afc:	89 d6                	mov    %edx,%esi
    1afe:	89 c7                	mov    %eax,%edi
    1b00:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1b07:	00 00 00 
    1b0a:	ff d0                	callq  *%rax
      while (*s)
    1b0c:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b13:	0f b6 00             	movzbl (%rax),%eax
    1b16:	84 c0                	test   %al,%al
    1b18:	75 c4                	jne    1ade <printf+0x340>
      break;
    1b1a:	eb 54                	jmp    1b70 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b1c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b22:	be 25 00 00 00       	mov    $0x25,%esi
    1b27:	89 c7                	mov    %eax,%edi
    1b29:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1b30:	00 00 00 
    1b33:	ff d0                	callq  *%rax
      break;
    1b35:	eb 39                	jmp    1b70 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b37:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b3d:	be 25 00 00 00       	mov    $0x25,%esi
    1b42:	89 c7                	mov    %eax,%edi
    1b44:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1b4b:	00 00 00 
    1b4e:	ff d0                	callq  *%rax
      putc(fd, c);
    1b50:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b56:	0f be d0             	movsbl %al,%edx
    1b59:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b5f:	89 d6                	mov    %edx,%esi
    1b61:	89 c7                	mov    %eax,%edi
    1b63:	48 b8 b8 15 00 00 00 	movabs $0x15b8,%rax
    1b6a:	00 00 00 
    1b6d:	ff d0                	callq  *%rax
      break;
    1b6f:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b70:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b77:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b7d:	48 63 d0             	movslq %eax,%rdx
    1b80:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1b87:	48 01 d0             	add    %rdx,%rax
    1b8a:	0f b6 00             	movzbl (%rax),%eax
    1b8d:	0f be c0             	movsbl %al,%eax
    1b90:	25 ff 00 00 00       	and    $0xff,%eax
    1b95:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1b9b:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ba2:	0f 85 8e fc ff ff    	jne    1836 <printf+0x98>
    }
  }
}
    1ba8:	eb 01                	jmp    1bab <printf+0x40d>
      break;
    1baa:	90                   	nop
}
    1bab:	90                   	nop
    1bac:	c9                   	leaveq 
    1bad:	c3                   	retq   

0000000000001bae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1bae:	f3 0f 1e fa          	endbr64 
    1bb2:	55                   	push   %rbp
    1bb3:	48 89 e5             	mov    %rsp,%rbp
    1bb6:	48 83 ec 18          	sub    $0x18,%rsp
    1bba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1bbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bc2:	48 83 e8 10          	sub    $0x10,%rax
    1bc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bca:	48 b8 c0 27 00 00 00 	movabs $0x27c0,%rax
    1bd1:	00 00 00 
    1bd4:	48 8b 00             	mov    (%rax),%rax
    1bd7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1bdb:	eb 2f                	jmp    1c0c <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1bdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be1:	48 8b 00             	mov    (%rax),%rax
    1be4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1be8:	72 17                	jb     1c01 <free+0x53>
    1bea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bee:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1bf2:	77 2f                	ja     1c23 <free+0x75>
    1bf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf8:	48 8b 00             	mov    (%rax),%rax
    1bfb:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bff:	72 22                	jb     1c23 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c05:	48 8b 00             	mov    (%rax),%rax
    1c08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c10:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c14:	76 c7                	jbe    1bdd <free+0x2f>
    1c16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c1a:	48 8b 00             	mov    (%rax),%rax
    1c1d:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c21:	73 ba                	jae    1bdd <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c27:	8b 40 08             	mov    0x8(%rax),%eax
    1c2a:	89 c0                	mov    %eax,%eax
    1c2c:	48 c1 e0 04          	shl    $0x4,%rax
    1c30:	48 89 c2             	mov    %rax,%rdx
    1c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c37:	48 01 c2             	add    %rax,%rdx
    1c3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c3e:	48 8b 00             	mov    (%rax),%rax
    1c41:	48 39 c2             	cmp    %rax,%rdx
    1c44:	75 2d                	jne    1c73 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1c46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c4a:	8b 50 08             	mov    0x8(%rax),%edx
    1c4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c51:	48 8b 00             	mov    (%rax),%rax
    1c54:	8b 40 08             	mov    0x8(%rax),%eax
    1c57:	01 c2                	add    %eax,%edx
    1c59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c5d:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1c60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c64:	48 8b 00             	mov    (%rax),%rax
    1c67:	48 8b 10             	mov    (%rax),%rdx
    1c6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c6e:	48 89 10             	mov    %rdx,(%rax)
    1c71:	eb 0e                	jmp    1c81 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1c73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c77:	48 8b 10             	mov    (%rax),%rdx
    1c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c7e:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1c81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c85:	8b 40 08             	mov    0x8(%rax),%eax
    1c88:	89 c0                	mov    %eax,%eax
    1c8a:	48 c1 e0 04          	shl    $0x4,%rax
    1c8e:	48 89 c2             	mov    %rax,%rdx
    1c91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c95:	48 01 d0             	add    %rdx,%rax
    1c98:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c9c:	75 27                	jne    1cc5 <free+0x117>
    p->s.size += bp->s.size;
    1c9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ca2:	8b 50 08             	mov    0x8(%rax),%edx
    1ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca9:	8b 40 08             	mov    0x8(%rax),%eax
    1cac:	01 c2                	add    %eax,%edx
    1cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb2:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1cb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb9:	48 8b 10             	mov    (%rax),%rdx
    1cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc0:	48 89 10             	mov    %rdx,(%rax)
    1cc3:	eb 0b                	jmp    1cd0 <free+0x122>
  } else
    p->s.ptr = bp;
    1cc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1ccd:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1cd0:	48 ba c0 27 00 00 00 	movabs $0x27c0,%rdx
    1cd7:	00 00 00 
    1cda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cde:	48 89 02             	mov    %rax,(%rdx)
}
    1ce1:	90                   	nop
    1ce2:	c9                   	leaveq 
    1ce3:	c3                   	retq   

0000000000001ce4 <morecore>:

static Header*
morecore(uint nu)
{
    1ce4:	f3 0f 1e fa          	endbr64 
    1ce8:	55                   	push   %rbp
    1ce9:	48 89 e5             	mov    %rsp,%rbp
    1cec:	48 83 ec 20          	sub    $0x20,%rsp
    1cf0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1cf3:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1cfa:	77 07                	ja     1d03 <morecore+0x1f>
    nu = 4096;
    1cfc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d03:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d06:	48 c1 e0 04          	shl    $0x4,%rax
    1d0a:	48 89 c7             	mov    %rax,%rdi
    1d0d:	48 b8 91 15 00 00 00 	movabs $0x1591,%rax
    1d14:	00 00 00 
    1d17:	ff d0                	callq  *%rax
    1d19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d1d:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d22:	75 07                	jne    1d2b <morecore+0x47>
    return 0;
    1d24:	b8 00 00 00 00       	mov    $0x0,%eax
    1d29:	eb 36                	jmp    1d61 <morecore+0x7d>
  hp = (Header*)p;
    1d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d37:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d3a:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d41:	48 83 c0 10          	add    $0x10,%rax
    1d45:	48 89 c7             	mov    %rax,%rdi
    1d48:	48 b8 ae 1b 00 00 00 	movabs $0x1bae,%rax
    1d4f:	00 00 00 
    1d52:	ff d0                	callq  *%rax
  return freep;
    1d54:	48 b8 c0 27 00 00 00 	movabs $0x27c0,%rax
    1d5b:	00 00 00 
    1d5e:	48 8b 00             	mov    (%rax),%rax
}
    1d61:	c9                   	leaveq 
    1d62:	c3                   	retq   

0000000000001d63 <malloc>:

void*
malloc(uint nbytes)
{
    1d63:	f3 0f 1e fa          	endbr64 
    1d67:	55                   	push   %rbp
    1d68:	48 89 e5             	mov    %rsp,%rbp
    1d6b:	48 83 ec 30          	sub    $0x30,%rsp
    1d6f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1d72:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1d75:	48 83 c0 0f          	add    $0xf,%rax
    1d79:	48 c1 e8 04          	shr    $0x4,%rax
    1d7d:	83 c0 01             	add    $0x1,%eax
    1d80:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1d83:	48 b8 c0 27 00 00 00 	movabs $0x27c0,%rax
    1d8a:	00 00 00 
    1d8d:	48 8b 00             	mov    (%rax),%rax
    1d90:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d94:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1d99:	75 4a                	jne    1de5 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1d9b:	48 b8 b0 27 00 00 00 	movabs $0x27b0,%rax
    1da2:	00 00 00 
    1da5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1da9:	48 ba c0 27 00 00 00 	movabs $0x27c0,%rdx
    1db0:	00 00 00 
    1db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1db7:	48 89 02             	mov    %rax,(%rdx)
    1dba:	48 b8 c0 27 00 00 00 	movabs $0x27c0,%rax
    1dc1:	00 00 00 
    1dc4:	48 8b 00             	mov    (%rax),%rax
    1dc7:	48 ba b0 27 00 00 00 	movabs $0x27b0,%rdx
    1dce:	00 00 00 
    1dd1:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1dd4:	48 b8 b0 27 00 00 00 	movabs $0x27b0,%rax
    1ddb:	00 00 00 
    1dde:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1de5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1de9:	48 8b 00             	mov    (%rax),%rax
    1dec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1df0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1df4:	8b 40 08             	mov    0x8(%rax),%eax
    1df7:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1dfa:	77 65                	ja     1e61 <malloc+0xfe>
      if(p->s.size == nunits)
    1dfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e00:	8b 40 08             	mov    0x8(%rax),%eax
    1e03:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e06:	75 10                	jne    1e18 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e0c:	48 8b 10             	mov    (%rax),%rdx
    1e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e13:	48 89 10             	mov    %rdx,(%rax)
    1e16:	eb 2e                	jmp    1e46 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e1c:	8b 40 08             	mov    0x8(%rax),%eax
    1e1f:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e22:	89 c2                	mov    %eax,%edx
    1e24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e28:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e2f:	8b 40 08             	mov    0x8(%rax),%eax
    1e32:	89 c0                	mov    %eax,%eax
    1e34:	48 c1 e0 04          	shl    $0x4,%rax
    1e38:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e40:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e43:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e46:	48 ba c0 27 00 00 00 	movabs $0x27c0,%rdx
    1e4d:	00 00 00 
    1e50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e54:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1e57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e5b:	48 83 c0 10          	add    $0x10,%rax
    1e5f:	eb 4e                	jmp    1eaf <malloc+0x14c>
    }
    if(p == freep)
    1e61:	48 b8 c0 27 00 00 00 	movabs $0x27c0,%rax
    1e68:	00 00 00 
    1e6b:	48 8b 00             	mov    (%rax),%rax
    1e6e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1e72:	75 23                	jne    1e97 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1e74:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1e77:	89 c7                	mov    %eax,%edi
    1e79:	48 b8 e4 1c 00 00 00 	movabs $0x1ce4,%rax
    1e80:	00 00 00 
    1e83:	ff d0                	callq  *%rax
    1e85:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1e89:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1e8e:	75 07                	jne    1e97 <malloc+0x134>
        return 0;
    1e90:	b8 00 00 00 00       	mov    $0x0,%eax
    1e95:	eb 18                	jmp    1eaf <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ea3:	48 8b 00             	mov    (%rax),%rax
    1ea6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1eaa:	e9 41 ff ff ff       	jmpq   1df0 <malloc+0x8d>
  }
}
    1eaf:	c9                   	leaveq 
    1eb0:	c3                   	retq   

0000000000001eb1 <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1eb1:	f3 0f 1e fa          	endbr64 
    1eb5:	55                   	push   %rbp
    1eb6:	48 89 e5             	mov    %rsp,%rbp
    1eb9:	48 83 ec 30          	sub    $0x30,%rsp
    1ebd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1ec1:	bf 18 00 00 00       	mov    $0x18,%edi
    1ec6:	48 b8 63 1d 00 00 00 	movabs $0x1d63,%rax
    1ecd:	00 00 00 
    1ed0:	ff d0                	callq  *%rax
    1ed2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1ed6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1edb:	75 0a                	jne    1ee7 <co_new+0x36>
    return 0;
    1edd:	b8 00 00 00 00       	mov    $0x0,%eax
    1ee2:	e9 e1 00 00 00       	jmpq   1fc8 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1ee7:	bf 00 20 00 00       	mov    $0x2000,%edi
    1eec:	48 b8 63 1d 00 00 00 	movabs $0x1d63,%rax
    1ef3:	00 00 00 
    1ef6:	ff d0                	callq  *%rax
    1ef8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1efc:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f04:	48 8b 40 10          	mov    0x10(%rax),%rax
    1f08:	48 85 c0             	test   %rax,%rax
    1f0b:	75 1d                	jne    1f2a <co_new+0x79>
    free(co1);
    1f0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f11:	48 89 c7             	mov    %rax,%rdi
    1f14:	48 b8 ae 1b 00 00 00 	movabs $0x1bae,%rax
    1f1b:	00 00 00 
    1f1e:	ff d0                	callq  *%rax
    return 0;
    1f20:	b8 00 00 00 00       	mov    $0x0,%eax
    1f25:	e9 9e 00 00 00       	jmpq   1fc8 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1f2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f2e:	48 8b 40 10          	mov    0x10(%rax),%rax
    1f32:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    1f38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    1f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f40:	48 8d 50 30          	lea    0x30(%rax),%rdx
    1f44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1f48:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    1f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f4f:	48 83 c0 38          	add    $0x38,%rax
    1f53:	48 ba 3a 21 00 00 00 	movabs $0x213a,%rdx
    1f5a:	00 00 00 
    1f5d:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    1f60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1f68:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    1f6b:	48 b8 d8 27 00 00 00 	movabs $0x27d8,%rax
    1f72:	00 00 00 
    1f75:	48 8b 00             	mov    (%rax),%rax
    1f78:	48 85 c0             	test   %rax,%rax
    1f7b:	75 13                	jne    1f90 <co_new+0xdf>
  {
  	co_list = co1;
    1f7d:	48 ba d8 27 00 00 00 	movabs $0x27d8,%rdx
    1f84:	00 00 00 
    1f87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f8b:	48 89 02             	mov    %rax,(%rdx)
    1f8e:	eb 34                	jmp    1fc4 <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    1f90:	48 b8 d8 27 00 00 00 	movabs $0x27d8,%rax
    1f97:	00 00 00 
    1f9a:	48 8b 00             	mov    (%rax),%rax
    1f9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1fa1:	eb 0c                	jmp    1faf <co_new+0xfe>
	{
		head = head->next;
    1fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fa7:	48 8b 40 08          	mov    0x8(%rax),%rax
    1fab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1faf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb3:	48 8b 40 08          	mov    0x8(%rax),%rax
    1fb7:	48 85 c0             	test   %rax,%rax
    1fba:	75 e7                	jne    1fa3 <co_new+0xf2>
	}
	head = co1;
    1fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fc0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    1fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    1fc8:	c9                   	leaveq 
    1fc9:	c3                   	retq   

0000000000001fca <co_run>:

  int
co_run(void)
{
    1fca:	f3 0f 1e fa          	endbr64 
    1fce:	55                   	push   %rbp
    1fcf:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    1fd2:	48 b8 d8 27 00 00 00 	movabs $0x27d8,%rax
    1fd9:	00 00 00 
    1fdc:	48 8b 00             	mov    (%rax),%rax
    1fdf:	48 85 c0             	test   %rax,%rax
    1fe2:	74 4a                	je     202e <co_run+0x64>
	{
		co_current = co_list;
    1fe4:	48 b8 d8 27 00 00 00 	movabs $0x27d8,%rax
    1feb:	00 00 00 
    1fee:	48 8b 00             	mov    (%rax),%rax
    1ff1:	48 ba d0 27 00 00 00 	movabs $0x27d0,%rdx
    1ff8:	00 00 00 
    1ffb:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    1ffe:	48 b8 d0 27 00 00 00 	movabs $0x27d0,%rax
    2005:	00 00 00 
    2008:	48 8b 00             	mov    (%rax),%rax
    200b:	48 8b 00             	mov    (%rax),%rax
    200e:	48 89 c6             	mov    %rax,%rsi
    2011:	48 bf c8 27 00 00 00 	movabs $0x27c8,%rdi
    2018:	00 00 00 
    201b:	48 b8 9c 22 00 00 00 	movabs $0x229c,%rax
    2022:	00 00 00 
    2025:	ff d0                	callq  *%rax
		return 1;
    2027:	b8 01 00 00 00       	mov    $0x1,%eax
    202c:	eb 05                	jmp    2033 <co_run+0x69>
	}
	return 0;
    202e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2033:	5d                   	pop    %rbp
    2034:	c3                   	retq   

0000000000002035 <co_run_all>:

  int
co_run_all(void)
{
    2035:	f3 0f 1e fa          	endbr64 
    2039:	55                   	push   %rbp
    203a:	48 89 e5             	mov    %rsp,%rbp
    203d:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    2041:	48 b8 d8 27 00 00 00 	movabs $0x27d8,%rax
    2048:	00 00 00 
    204b:	48 8b 00             	mov    (%rax),%rax
    204e:	48 85 c0             	test   %rax,%rax
    2051:	75 07                	jne    205a <co_run_all+0x25>
		return 0;
    2053:	b8 00 00 00 00       	mov    $0x0,%eax
    2058:	eb 37                	jmp    2091 <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    205a:	48 b8 d8 27 00 00 00 	movabs $0x27d8,%rax
    2061:	00 00 00 
    2064:	48 8b 00             	mov    (%rax),%rax
    2067:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    206b:	eb 18                	jmp    2085 <co_run_all+0x50>
			co_run();
    206d:	48 b8 ca 1f 00 00 00 	movabs $0x1fca,%rax
    2074:	00 00 00 
    2077:	ff d0                	callq  *%rax
			tmp = tmp->next;
    2079:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    207d:	48 8b 40 08          	mov    0x8(%rax),%rax
    2081:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    2085:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    208a:	75 e1                	jne    206d <co_run_all+0x38>
		}
		return 1;
    208c:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    2091:	c9                   	leaveq 
    2092:	c3                   	retq   

0000000000002093 <co_yield>:

  void
co_yield()
{
    2093:	f3 0f 1e fa          	endbr64 
    2097:	55                   	push   %rbp
    2098:	48 89 e5             	mov    %rsp,%rbp
    209b:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    209f:	48 b8 d0 27 00 00 00 	movabs $0x27d0,%rax
    20a6:	00 00 00 
    20a9:	48 8b 00             	mov    (%rax),%rax
    20ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    20b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20b4:	48 8b 40 08          	mov    0x8(%rax),%rax
    20b8:	48 85 c0             	test   %rax,%rax
    20bb:	74 46                	je     2103 <co_yield+0x70>
  {
  	co_current = co_current->next;
    20bd:	48 b8 d0 27 00 00 00 	movabs $0x27d0,%rax
    20c4:	00 00 00 
    20c7:	48 8b 00             	mov    (%rax),%rax
    20ca:	48 8b 40 08          	mov    0x8(%rax),%rax
    20ce:	48 ba d0 27 00 00 00 	movabs $0x27d0,%rdx
    20d5:	00 00 00 
    20d8:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    20db:	48 b8 d0 27 00 00 00 	movabs $0x27d0,%rax
    20e2:	00 00 00 
    20e5:	48 8b 00             	mov    (%rax),%rax
    20e8:	48 8b 10             	mov    (%rax),%rdx
    20eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20ef:	48 89 d6             	mov    %rdx,%rsi
    20f2:	48 89 c7             	mov    %rax,%rdi
    20f5:	48 b8 9c 22 00 00 00 	movabs $0x229c,%rax
    20fc:	00 00 00 
    20ff:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    2101:	eb 34                	jmp    2137 <co_yield+0xa4>
	co_current = 0;
    2103:	48 b8 d0 27 00 00 00 	movabs $0x27d0,%rax
    210a:	00 00 00 
    210d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    2114:	48 b8 c8 27 00 00 00 	movabs $0x27c8,%rax
    211b:	00 00 00 
    211e:	48 8b 10             	mov    (%rax),%rdx
    2121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2125:	48 89 d6             	mov    %rdx,%rsi
    2128:	48 89 c7             	mov    %rax,%rdi
    212b:	48 b8 9c 22 00 00 00 	movabs $0x229c,%rax
    2132:	00 00 00 
    2135:	ff d0                	callq  *%rax
}
    2137:	90                   	nop
    2138:	c9                   	leaveq 
    2139:	c3                   	retq   

000000000000213a <co_exit>:

  void
co_exit(void)
{
    213a:	f3 0f 1e fa          	endbr64 
    213e:	55                   	push   %rbp
    213f:	48 89 e5             	mov    %rsp,%rbp
    2142:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    2146:	48 b8 d0 27 00 00 00 	movabs $0x27d0,%rax
    214d:	00 00 00 
    2150:	48 8b 00             	mov    (%rax),%rax
    2153:	48 85 c0             	test   %rax,%rax
    2156:	0f 84 ec 00 00 00    	je     2248 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    215c:	48 b8 d8 27 00 00 00 	movabs $0x27d8,%rax
    2163:	00 00 00 
    2166:	48 8b 00             	mov    (%rax),%rax
    2169:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    216d:	e9 c9 00 00 00       	jmpq   223b <co_exit+0x101>
		if(tmp == co_current)
    2172:	48 b8 d0 27 00 00 00 	movabs $0x27d0,%rax
    2179:	00 00 00 
    217c:	48 8b 00             	mov    (%rax),%rax
    217f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2183:	0f 85 9e 00 00 00    	jne    2227 <co_exit+0xed>
		{
			if(tmp->next)
    2189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    218d:	48 8b 40 08          	mov    0x8(%rax),%rax
    2191:	48 85 c0             	test   %rax,%rax
    2194:	74 54                	je     21ea <co_exit+0xb0>
			{
				if(prev)
    2196:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    219b:	74 10                	je     21ad <co_exit+0x73>
				{
					prev->next = tmp->next;
    219d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21a1:	48 8b 50 08          	mov    0x8(%rax),%rdx
    21a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    21a9:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    21ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21b1:	48 8b 40 08          	mov    0x8(%rax),%rax
    21b5:	48 ba d8 27 00 00 00 	movabs $0x27d8,%rdx
    21bc:	00 00 00 
    21bf:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    21c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21c6:	48 8b 00             	mov    (%rax),%rax
    21c9:	48 ba d0 27 00 00 00 	movabs $0x27d0,%rdx
    21d0:	00 00 00 
    21d3:	48 8b 12             	mov    (%rdx),%rdx
    21d6:	48 89 c6             	mov    %rax,%rsi
    21d9:	48 89 d7             	mov    %rdx,%rdi
    21dc:	48 b8 9c 22 00 00 00 	movabs $0x229c,%rax
    21e3:	00 00 00 
    21e6:	ff d0                	callq  *%rax
    21e8:	eb 3d                	jmp    2227 <co_exit+0xed>
			}else{
				co_list = 0;
    21ea:	48 b8 d8 27 00 00 00 	movabs $0x27d8,%rax
    21f1:	00 00 00 
    21f4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    21fb:	48 b8 c8 27 00 00 00 	movabs $0x27c8,%rax
    2202:	00 00 00 
    2205:	48 8b 00             	mov    (%rax),%rax
    2208:	48 ba d0 27 00 00 00 	movabs $0x27d0,%rdx
    220f:	00 00 00 
    2212:	48 8b 12             	mov    (%rdx),%rdx
    2215:	48 89 c6             	mov    %rax,%rsi
    2218:	48 89 d7             	mov    %rdx,%rdi
    221b:	48 b8 9c 22 00 00 00 	movabs $0x229c,%rax
    2222:	00 00 00 
    2225:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    2227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    222b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    222f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2233:	48 8b 40 08          	mov    0x8(%rax),%rax
    2237:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    223b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2240:	0f 85 2c ff ff ff    	jne    2172 <co_exit+0x38>
    2246:	eb 01                	jmp    2249 <co_exit+0x10f>
		return;
    2248:	90                   	nop
	}
}
    2249:	c9                   	leaveq 
    224a:	c3                   	retq   

000000000000224b <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    224b:	f3 0f 1e fa          	endbr64 
    224f:	55                   	push   %rbp
    2250:	48 89 e5             	mov    %rsp,%rbp
    2253:	48 83 ec 10          	sub    $0x10,%rsp
    2257:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    225b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2260:	74 37                	je     2299 <co_destroy+0x4e>
    if (co->stack)
    2262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2266:	48 8b 40 10          	mov    0x10(%rax),%rax
    226a:	48 85 c0             	test   %rax,%rax
    226d:	74 17                	je     2286 <co_destroy+0x3b>
      free(co->stack);
    226f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2273:	48 8b 40 10          	mov    0x10(%rax),%rax
    2277:	48 89 c7             	mov    %rax,%rdi
    227a:	48 b8 ae 1b 00 00 00 	movabs $0x1bae,%rax
    2281:	00 00 00 
    2284:	ff d0                	callq  *%rax
    free(co);
    2286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    228a:	48 89 c7             	mov    %rax,%rdi
    228d:	48 b8 ae 1b 00 00 00 	movabs $0x1bae,%rax
    2294:	00 00 00 
    2297:	ff d0                	callq  *%rax
  }
}
    2299:	90                   	nop
    229a:	c9                   	leaveq 
    229b:	c3                   	retq   

000000000000229c <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    229c:	55                   	push   %rbp
  pushq   %rbx
    229d:	53                   	push   %rbx
  pushq   %r12
    229e:	41 54                	push   %r12
  pushq   %r13
    22a0:	41 55                	push   %r13
  pushq   %r14
    22a2:	41 56                	push   %r14
  pushq   %r15
    22a4:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    22a6:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    22a9:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    22ac:	41 5f                	pop    %r15
  popq    %r14
    22ae:	41 5e                	pop    %r14
  popq    %r13
    22b0:	41 5d                	pop    %r13
  popq    %r12
    22b2:	41 5c                	pop    %r12
  popq    %rbx
    22b4:	5b                   	pop    %rbx
  popq    %rbp
    22b5:	5d                   	pop    %rbp

  retq #??
    22b6:	c3                   	retq   
