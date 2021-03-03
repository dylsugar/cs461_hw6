
_zombie:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
  if(fork() > 0)
    1008:	48 b8 6b 13 00 00 00 	movabs $0x136b,%rax
    100f:	00 00 00 
    1012:	ff d0                	callq  *%rax
    1014:	85 c0                	test   %eax,%eax
    1016:	7e 11                	jle    1029 <main+0x29>
    sleep(5);  // Let child exit before parent.
    1018:	bf 05 00 00 00       	mov    $0x5,%edi
    101d:	48 b8 62 14 00 00 00 	movabs $0x1462,%rax
    1024:	00 00 00 
    1027:	ff d0                	callq  *%rax
  exit();
    1029:	48 b8 78 13 00 00 00 	movabs $0x1378,%rax
    1030:	00 00 00 
    1033:	ff d0                	callq  *%rax

0000000000001035 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1035:	f3 0f 1e fa          	endbr64 
    1039:	55                   	push   %rbp
    103a:	48 89 e5             	mov    %rsp,%rbp
    103d:	48 83 ec 10          	sub    $0x10,%rsp
    1041:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1045:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1048:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    104b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    104f:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1052:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1055:	48 89 ce             	mov    %rcx,%rsi
    1058:	48 89 f7             	mov    %rsi,%rdi
    105b:	89 d1                	mov    %edx,%ecx
    105d:	fc                   	cld    
    105e:	f3 aa                	rep stos %al,%es:(%rdi)
    1060:	89 ca                	mov    %ecx,%edx
    1062:	48 89 fe             	mov    %rdi,%rsi
    1065:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1069:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    106c:	90                   	nop
    106d:	c9                   	leaveq 
    106e:	c3                   	retq   

000000000000106f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    106f:	f3 0f 1e fa          	endbr64 
    1073:	55                   	push   %rbp
    1074:	48 89 e5             	mov    %rsp,%rbp
    1077:	48 83 ec 20          	sub    $0x20,%rsp
    107b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    107f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1083:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1087:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    108b:	90                   	nop
    108c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1090:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1094:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    109c:	48 8d 48 01          	lea    0x1(%rax),%rcx
    10a0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    10a4:	0f b6 12             	movzbl (%rdx),%edx
    10a7:	88 10                	mov    %dl,(%rax)
    10a9:	0f b6 00             	movzbl (%rax),%eax
    10ac:	84 c0                	test   %al,%al
    10ae:	75 dc                	jne    108c <strcpy+0x1d>
    ;
  return os;
    10b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    10b4:	c9                   	leaveq 
    10b5:	c3                   	retq   

00000000000010b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10b6:	f3 0f 1e fa          	endbr64 
    10ba:	55                   	push   %rbp
    10bb:	48 89 e5             	mov    %rsp,%rbp
    10be:	48 83 ec 10          	sub    $0x10,%rsp
    10c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    10ca:	eb 0a                	jmp    10d6 <strcmp+0x20>
    p++, q++;
    10cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    10d1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    10d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10da:	0f b6 00             	movzbl (%rax),%eax
    10dd:	84 c0                	test   %al,%al
    10df:	74 12                	je     10f3 <strcmp+0x3d>
    10e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10e5:	0f b6 10             	movzbl (%rax),%edx
    10e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    10ec:	0f b6 00             	movzbl (%rax),%eax
    10ef:	38 c2                	cmp    %al,%dl
    10f1:	74 d9                	je     10cc <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    10f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10f7:	0f b6 00             	movzbl (%rax),%eax
    10fa:	0f b6 d0             	movzbl %al,%edx
    10fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1101:	0f b6 00             	movzbl (%rax),%eax
    1104:	0f b6 c0             	movzbl %al,%eax
    1107:	29 c2                	sub    %eax,%edx
    1109:	89 d0                	mov    %edx,%eax
}
    110b:	c9                   	leaveq 
    110c:	c3                   	retq   

000000000000110d <strlen>:

uint
strlen(char *s)
{
    110d:	f3 0f 1e fa          	endbr64 
    1111:	55                   	push   %rbp
    1112:	48 89 e5             	mov    %rsp,%rbp
    1115:	48 83 ec 18          	sub    $0x18,%rsp
    1119:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    111d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1124:	eb 04                	jmp    112a <strlen+0x1d>
    1126:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    112d:	48 63 d0             	movslq %eax,%rdx
    1130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1134:	48 01 d0             	add    %rdx,%rax
    1137:	0f b6 00             	movzbl (%rax),%eax
    113a:	84 c0                	test   %al,%al
    113c:	75 e8                	jne    1126 <strlen+0x19>
    ;
  return n;
    113e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1141:	c9                   	leaveq 
    1142:	c3                   	retq   

0000000000001143 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1143:	f3 0f 1e fa          	endbr64 
    1147:	55                   	push   %rbp
    1148:	48 89 e5             	mov    %rsp,%rbp
    114b:	48 83 ec 10          	sub    $0x10,%rsp
    114f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1153:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1156:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1159:	8b 55 f0             	mov    -0x10(%rbp),%edx
    115c:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    115f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1163:	89 ce                	mov    %ecx,%esi
    1165:	48 89 c7             	mov    %rax,%rdi
    1168:	48 b8 35 10 00 00 00 	movabs $0x1035,%rax
    116f:	00 00 00 
    1172:	ff d0                	callq  *%rax
  return dst;
    1174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1178:	c9                   	leaveq 
    1179:	c3                   	retq   

000000000000117a <strchr>:

char*
strchr(const char *s, char c)
{
    117a:	f3 0f 1e fa          	endbr64 
    117e:	55                   	push   %rbp
    117f:	48 89 e5             	mov    %rsp,%rbp
    1182:	48 83 ec 10          	sub    $0x10,%rsp
    1186:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    118a:	89 f0                	mov    %esi,%eax
    118c:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    118f:	eb 17                	jmp    11a8 <strchr+0x2e>
    if(*s == c)
    1191:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1195:	0f b6 00             	movzbl (%rax),%eax
    1198:	38 45 f4             	cmp    %al,-0xc(%rbp)
    119b:	75 06                	jne    11a3 <strchr+0x29>
      return (char*)s;
    119d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11a1:	eb 15                	jmp    11b8 <strchr+0x3e>
  for(; *s; s++)
    11a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11ac:	0f b6 00             	movzbl (%rax),%eax
    11af:	84 c0                	test   %al,%al
    11b1:	75 de                	jne    1191 <strchr+0x17>
  return 0;
    11b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11b8:	c9                   	leaveq 
    11b9:	c3                   	retq   

00000000000011ba <gets>:

char*
gets(char *buf, int max)
{
    11ba:	f3 0f 1e fa          	endbr64 
    11be:	55                   	push   %rbp
    11bf:	48 89 e5             	mov    %rsp,%rbp
    11c2:	48 83 ec 20          	sub    $0x20,%rsp
    11c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11d4:	eb 4f                	jmp    1225 <gets+0x6b>
    cc = read(0, &c, 1);
    11d6:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    11da:	ba 01 00 00 00       	mov    $0x1,%edx
    11df:	48 89 c6             	mov    %rax,%rsi
    11e2:	bf 00 00 00 00       	mov    $0x0,%edi
    11e7:	48 b8 9f 13 00 00 00 	movabs $0x139f,%rax
    11ee:	00 00 00 
    11f1:	ff d0                	callq  *%rax
    11f3:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    11f6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    11fa:	7e 36                	jle    1232 <gets+0x78>
      break;
    buf[i++] = c;
    11fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11ff:	8d 50 01             	lea    0x1(%rax),%edx
    1202:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1205:	48 63 d0             	movslq %eax,%rdx
    1208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    120c:	48 01 c2             	add    %rax,%rdx
    120f:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1213:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1215:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1219:	3c 0a                	cmp    $0xa,%al
    121b:	74 16                	je     1233 <gets+0x79>
    121d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1221:	3c 0d                	cmp    $0xd,%al
    1223:	74 0e                	je     1233 <gets+0x79>
  for(i=0; i+1 < max; ){
    1225:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1228:	83 c0 01             	add    $0x1,%eax
    122b:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    122e:	7f a6                	jg     11d6 <gets+0x1c>
    1230:	eb 01                	jmp    1233 <gets+0x79>
      break;
    1232:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1233:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1236:	48 63 d0             	movslq %eax,%rdx
    1239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    123d:	48 01 d0             	add    %rdx,%rax
    1240:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1247:	c9                   	leaveq 
    1248:	c3                   	retq   

0000000000001249 <stat>:

int
stat(char *n, struct stat *st)
{
    1249:	f3 0f 1e fa          	endbr64 
    124d:	55                   	push   %rbp
    124e:	48 89 e5             	mov    %rsp,%rbp
    1251:	48 83 ec 20          	sub    $0x20,%rsp
    1255:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1259:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    125d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1261:	be 00 00 00 00       	mov    $0x0,%esi
    1266:	48 89 c7             	mov    %rax,%rdi
    1269:	48 b8 e0 13 00 00 00 	movabs $0x13e0,%rax
    1270:	00 00 00 
    1273:	ff d0                	callq  *%rax
    1275:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1278:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    127c:	79 07                	jns    1285 <stat+0x3c>
    return -1;
    127e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1283:	eb 2f                	jmp    12b4 <stat+0x6b>
  r = fstat(fd, st);
    1285:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1289:	8b 45 fc             	mov    -0x4(%rbp),%eax
    128c:	48 89 d6             	mov    %rdx,%rsi
    128f:	89 c7                	mov    %eax,%edi
    1291:	48 b8 07 14 00 00 00 	movabs $0x1407,%rax
    1298:	00 00 00 
    129b:	ff d0                	callq  *%rax
    129d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    12a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12a3:	89 c7                	mov    %eax,%edi
    12a5:	48 b8 b9 13 00 00 00 	movabs $0x13b9,%rax
    12ac:	00 00 00 
    12af:	ff d0                	callq  *%rax
  return r;
    12b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    12b4:	c9                   	leaveq 
    12b5:	c3                   	retq   

00000000000012b6 <atoi>:

int
atoi(const char *s)
{
    12b6:	f3 0f 1e fa          	endbr64 
    12ba:	55                   	push   %rbp
    12bb:	48 89 e5             	mov    %rsp,%rbp
    12be:	48 83 ec 18          	sub    $0x18,%rsp
    12c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    12c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    12cd:	eb 28                	jmp    12f7 <atoi+0x41>
    n = n*10 + *s++ - '0';
    12cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
    12d2:	89 d0                	mov    %edx,%eax
    12d4:	c1 e0 02             	shl    $0x2,%eax
    12d7:	01 d0                	add    %edx,%eax
    12d9:	01 c0                	add    %eax,%eax
    12db:	89 c1                	mov    %eax,%ecx
    12dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12e1:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    12e9:	0f b6 00             	movzbl (%rax),%eax
    12ec:	0f be c0             	movsbl %al,%eax
    12ef:	01 c8                	add    %ecx,%eax
    12f1:	83 e8 30             	sub    $0x30,%eax
    12f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    12f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12fb:	0f b6 00             	movzbl (%rax),%eax
    12fe:	3c 2f                	cmp    $0x2f,%al
    1300:	7e 0b                	jle    130d <atoi+0x57>
    1302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1306:	0f b6 00             	movzbl (%rax),%eax
    1309:	3c 39                	cmp    $0x39,%al
    130b:	7e c2                	jle    12cf <atoi+0x19>
  return n;
    130d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1310:	c9                   	leaveq 
    1311:	c3                   	retq   

0000000000001312 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1312:	f3 0f 1e fa          	endbr64 
    1316:	55                   	push   %rbp
    1317:	48 89 e5             	mov    %rsp,%rbp
    131a:	48 83 ec 28          	sub    $0x28,%rsp
    131e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1322:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1326:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    132d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1331:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1335:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1339:	eb 1d                	jmp    1358 <memmove+0x46>
    *dst++ = *src++;
    133b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    133f:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1343:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    134b:	48 8d 48 01          	lea    0x1(%rax),%rcx
    134f:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1353:	0f b6 12             	movzbl (%rdx),%edx
    1356:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1358:	8b 45 dc             	mov    -0x24(%rbp),%eax
    135b:	8d 50 ff             	lea    -0x1(%rax),%edx
    135e:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1361:	85 c0                	test   %eax,%eax
    1363:	7f d6                	jg     133b <memmove+0x29>
  return vdst;
    1365:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1369:	c9                   	leaveq 
    136a:	c3                   	retq   

000000000000136b <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    136b:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1372:	49 89 ca             	mov    %rcx,%r10
    1375:	0f 05                	syscall 
    1377:	c3                   	retq   

0000000000001378 <exit>:
SYSCALL(exit)
    1378:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    137f:	49 89 ca             	mov    %rcx,%r10
    1382:	0f 05                	syscall 
    1384:	c3                   	retq   

0000000000001385 <wait>:
SYSCALL(wait)
    1385:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    138c:	49 89 ca             	mov    %rcx,%r10
    138f:	0f 05                	syscall 
    1391:	c3                   	retq   

0000000000001392 <pipe>:
SYSCALL(pipe)
    1392:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1399:	49 89 ca             	mov    %rcx,%r10
    139c:	0f 05                	syscall 
    139e:	c3                   	retq   

000000000000139f <read>:
SYSCALL(read)
    139f:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    13a6:	49 89 ca             	mov    %rcx,%r10
    13a9:	0f 05                	syscall 
    13ab:	c3                   	retq   

00000000000013ac <write>:
SYSCALL(write)
    13ac:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    13b3:	49 89 ca             	mov    %rcx,%r10
    13b6:	0f 05                	syscall 
    13b8:	c3                   	retq   

00000000000013b9 <close>:
SYSCALL(close)
    13b9:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    13c0:	49 89 ca             	mov    %rcx,%r10
    13c3:	0f 05                	syscall 
    13c5:	c3                   	retq   

00000000000013c6 <kill>:
SYSCALL(kill)
    13c6:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    13cd:	49 89 ca             	mov    %rcx,%r10
    13d0:	0f 05                	syscall 
    13d2:	c3                   	retq   

00000000000013d3 <exec>:
SYSCALL(exec)
    13d3:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    13da:	49 89 ca             	mov    %rcx,%r10
    13dd:	0f 05                	syscall 
    13df:	c3                   	retq   

00000000000013e0 <open>:
SYSCALL(open)
    13e0:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    13e7:	49 89 ca             	mov    %rcx,%r10
    13ea:	0f 05                	syscall 
    13ec:	c3                   	retq   

00000000000013ed <mknod>:
SYSCALL(mknod)
    13ed:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    13f4:	49 89 ca             	mov    %rcx,%r10
    13f7:	0f 05                	syscall 
    13f9:	c3                   	retq   

00000000000013fa <unlink>:
SYSCALL(unlink)
    13fa:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1401:	49 89 ca             	mov    %rcx,%r10
    1404:	0f 05                	syscall 
    1406:	c3                   	retq   

0000000000001407 <fstat>:
SYSCALL(fstat)
    1407:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    140e:	49 89 ca             	mov    %rcx,%r10
    1411:	0f 05                	syscall 
    1413:	c3                   	retq   

0000000000001414 <link>:
SYSCALL(link)
    1414:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    141b:	49 89 ca             	mov    %rcx,%r10
    141e:	0f 05                	syscall 
    1420:	c3                   	retq   

0000000000001421 <mkdir>:
SYSCALL(mkdir)
    1421:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1428:	49 89 ca             	mov    %rcx,%r10
    142b:	0f 05                	syscall 
    142d:	c3                   	retq   

000000000000142e <chdir>:
SYSCALL(chdir)
    142e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1435:	49 89 ca             	mov    %rcx,%r10
    1438:	0f 05                	syscall 
    143a:	c3                   	retq   

000000000000143b <dup>:
SYSCALL(dup)
    143b:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1442:	49 89 ca             	mov    %rcx,%r10
    1445:	0f 05                	syscall 
    1447:	c3                   	retq   

0000000000001448 <getpid>:
SYSCALL(getpid)
    1448:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    144f:	49 89 ca             	mov    %rcx,%r10
    1452:	0f 05                	syscall 
    1454:	c3                   	retq   

0000000000001455 <sbrk>:
SYSCALL(sbrk)
    1455:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    145c:	49 89 ca             	mov    %rcx,%r10
    145f:	0f 05                	syscall 
    1461:	c3                   	retq   

0000000000001462 <sleep>:
SYSCALL(sleep)
    1462:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1469:	49 89 ca             	mov    %rcx,%r10
    146c:	0f 05                	syscall 
    146e:	c3                   	retq   

000000000000146f <uptime>:
SYSCALL(uptime)
    146f:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1476:	49 89 ca             	mov    %rcx,%r10
    1479:	0f 05                	syscall 
    147b:	c3                   	retq   

000000000000147c <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    147c:	f3 0f 1e fa          	endbr64 
    1480:	55                   	push   %rbp
    1481:	48 89 e5             	mov    %rsp,%rbp
    1484:	48 83 ec 10          	sub    $0x10,%rsp
    1488:	89 7d fc             	mov    %edi,-0x4(%rbp)
    148b:	89 f0                	mov    %esi,%eax
    148d:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1490:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1494:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1497:	ba 01 00 00 00       	mov    $0x1,%edx
    149c:	48 89 ce             	mov    %rcx,%rsi
    149f:	89 c7                	mov    %eax,%edi
    14a1:	48 b8 ac 13 00 00 00 	movabs $0x13ac,%rax
    14a8:	00 00 00 
    14ab:	ff d0                	callq  *%rax
}
    14ad:	90                   	nop
    14ae:	c9                   	leaveq 
    14af:	c3                   	retq   

00000000000014b0 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    14b0:	f3 0f 1e fa          	endbr64 
    14b4:	55                   	push   %rbp
    14b5:	48 89 e5             	mov    %rsp,%rbp
    14b8:	48 83 ec 20          	sub    $0x20,%rsp
    14bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
    14bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    14c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    14ca:	eb 35                	jmp    1501 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    14cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14d0:	48 c1 e8 3c          	shr    $0x3c,%rax
    14d4:	48 ba 70 25 00 00 00 	movabs $0x2570,%rdx
    14db:	00 00 00 
    14de:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    14e2:	0f be d0             	movsbl %al,%edx
    14e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    14e8:	89 d6                	mov    %edx,%esi
    14ea:	89 c7                	mov    %eax,%edi
    14ec:	48 b8 7c 14 00 00 00 	movabs $0x147c,%rax
    14f3:	00 00 00 
    14f6:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    14f8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    14fc:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1501:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1504:	83 f8 0f             	cmp    $0xf,%eax
    1507:	76 c3                	jbe    14cc <print_x64+0x1c>
}
    1509:	90                   	nop
    150a:	90                   	nop
    150b:	c9                   	leaveq 
    150c:	c3                   	retq   

000000000000150d <print_x32>:

  static void
print_x32(int fd, uint x)
{
    150d:	f3 0f 1e fa          	endbr64 
    1511:	55                   	push   %rbp
    1512:	48 89 e5             	mov    %rsp,%rbp
    1515:	48 83 ec 20          	sub    $0x20,%rsp
    1519:	89 7d ec             	mov    %edi,-0x14(%rbp)
    151c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    151f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1526:	eb 36                	jmp    155e <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1528:	8b 45 e8             	mov    -0x18(%rbp),%eax
    152b:	c1 e8 1c             	shr    $0x1c,%eax
    152e:	89 c2                	mov    %eax,%edx
    1530:	48 b8 70 25 00 00 00 	movabs $0x2570,%rax
    1537:	00 00 00 
    153a:	89 d2                	mov    %edx,%edx
    153c:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1540:	0f be d0             	movsbl %al,%edx
    1543:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1546:	89 d6                	mov    %edx,%esi
    1548:	89 c7                	mov    %eax,%edi
    154a:	48 b8 7c 14 00 00 00 	movabs $0x147c,%rax
    1551:	00 00 00 
    1554:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1556:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    155a:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    155e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1561:	83 f8 07             	cmp    $0x7,%eax
    1564:	76 c2                	jbe    1528 <print_x32+0x1b>
}
    1566:	90                   	nop
    1567:	90                   	nop
    1568:	c9                   	leaveq 
    1569:	c3                   	retq   

000000000000156a <print_d>:

  static void
print_d(int fd, int v)
{
    156a:	f3 0f 1e fa          	endbr64 
    156e:	55                   	push   %rbp
    156f:	48 89 e5             	mov    %rsp,%rbp
    1572:	48 83 ec 30          	sub    $0x30,%rsp
    1576:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1579:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    157c:	8b 45 d8             	mov    -0x28(%rbp),%eax
    157f:	48 98                	cltq   
    1581:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1585:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1589:	79 04                	jns    158f <print_d+0x25>
    x = -x;
    158b:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    158f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1596:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    159a:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    15a1:	66 66 66 
    15a4:	48 89 c8             	mov    %rcx,%rax
    15a7:	48 f7 ea             	imul   %rdx
    15aa:	48 c1 fa 02          	sar    $0x2,%rdx
    15ae:	48 89 c8             	mov    %rcx,%rax
    15b1:	48 c1 f8 3f          	sar    $0x3f,%rax
    15b5:	48 29 c2             	sub    %rax,%rdx
    15b8:	48 89 d0             	mov    %rdx,%rax
    15bb:	48 c1 e0 02          	shl    $0x2,%rax
    15bf:	48 01 d0             	add    %rdx,%rax
    15c2:	48 01 c0             	add    %rax,%rax
    15c5:	48 29 c1             	sub    %rax,%rcx
    15c8:	48 89 ca             	mov    %rcx,%rdx
    15cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
    15ce:	8d 48 01             	lea    0x1(%rax),%ecx
    15d1:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    15d4:	48 b9 70 25 00 00 00 	movabs $0x2570,%rcx
    15db:	00 00 00 
    15de:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    15e2:	48 98                	cltq   
    15e4:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    15e8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15ec:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    15f3:	66 66 66 
    15f6:	48 89 c8             	mov    %rcx,%rax
    15f9:	48 f7 ea             	imul   %rdx
    15fc:	48 c1 fa 02          	sar    $0x2,%rdx
    1600:	48 89 c8             	mov    %rcx,%rax
    1603:	48 c1 f8 3f          	sar    $0x3f,%rax
    1607:	48 29 c2             	sub    %rax,%rdx
    160a:	48 89 d0             	mov    %rdx,%rax
    160d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1611:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1616:	0f 85 7a ff ff ff    	jne    1596 <print_d+0x2c>

  if (v < 0)
    161c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1620:	79 32                	jns    1654 <print_d+0xea>
    buf[i++] = '-';
    1622:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1625:	8d 50 01             	lea    0x1(%rax),%edx
    1628:	89 55 f4             	mov    %edx,-0xc(%rbp)
    162b:	48 98                	cltq   
    162d:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1632:	eb 20                	jmp    1654 <print_d+0xea>
    putc(fd, buf[i]);
    1634:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1637:	48 98                	cltq   
    1639:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    163e:	0f be d0             	movsbl %al,%edx
    1641:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1644:	89 d6                	mov    %edx,%esi
    1646:	89 c7                	mov    %eax,%edi
    1648:	48 b8 7c 14 00 00 00 	movabs $0x147c,%rax
    164f:	00 00 00 
    1652:	ff d0                	callq  *%rax
  while (--i >= 0)
    1654:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1658:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    165c:	79 d6                	jns    1634 <print_d+0xca>
}
    165e:	90                   	nop
    165f:	90                   	nop
    1660:	c9                   	leaveq 
    1661:	c3                   	retq   

0000000000001662 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1662:	f3 0f 1e fa          	endbr64 
    1666:	55                   	push   %rbp
    1667:	48 89 e5             	mov    %rsp,%rbp
    166a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1671:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1677:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    167e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1685:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    168c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1693:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    169a:	84 c0                	test   %al,%al
    169c:	74 20                	je     16be <printf+0x5c>
    169e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    16a2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    16a6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    16aa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    16ae:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    16b2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    16b6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    16ba:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    16be:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    16c5:	00 00 00 
    16c8:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    16cf:	00 00 00 
    16d2:	48 8d 45 10          	lea    0x10(%rbp),%rax
    16d6:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    16dd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    16e4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    16eb:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    16f2:	00 00 00 
    16f5:	e9 41 03 00 00       	jmpq   1a3b <printf+0x3d9>
    if (c != '%') {
    16fa:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1701:	74 24                	je     1727 <printf+0xc5>
      putc(fd, c);
    1703:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1709:	0f be d0             	movsbl %al,%edx
    170c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1712:	89 d6                	mov    %edx,%esi
    1714:	89 c7                	mov    %eax,%edi
    1716:	48 b8 7c 14 00 00 00 	movabs $0x147c,%rax
    171d:	00 00 00 
    1720:	ff d0                	callq  *%rax
      continue;
    1722:	e9 0d 03 00 00       	jmpq   1a34 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1727:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    172e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1734:	48 63 d0             	movslq %eax,%rdx
    1737:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    173e:	48 01 d0             	add    %rdx,%rax
    1741:	0f b6 00             	movzbl (%rax),%eax
    1744:	0f be c0             	movsbl %al,%eax
    1747:	25 ff 00 00 00       	and    $0xff,%eax
    174c:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1752:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1759:	0f 84 0f 03 00 00    	je     1a6e <printf+0x40c>
      break;
    switch(c) {
    175f:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1766:	0f 84 74 02 00 00    	je     19e0 <printf+0x37e>
    176c:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1773:	0f 8c 82 02 00 00    	jl     19fb <printf+0x399>
    1779:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1780:	0f 8f 75 02 00 00    	jg     19fb <printf+0x399>
    1786:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    178d:	0f 8c 68 02 00 00    	jl     19fb <printf+0x399>
    1793:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1799:	83 e8 63             	sub    $0x63,%eax
    179c:	83 f8 15             	cmp    $0x15,%eax
    179f:	0f 87 56 02 00 00    	ja     19fb <printf+0x399>
    17a5:	89 c0                	mov    %eax,%eax
    17a7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    17ae:	00 
    17af:	48 b8 88 21 00 00 00 	movabs $0x2188,%rax
    17b6:	00 00 00 
    17b9:	48 01 d0             	add    %rdx,%rax
    17bc:	48 8b 00             	mov    (%rax),%rax
    17bf:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    17c2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    17c8:	83 f8 2f             	cmp    $0x2f,%eax
    17cb:	77 23                	ja     17f0 <printf+0x18e>
    17cd:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    17d4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    17da:	89 d2                	mov    %edx,%edx
    17dc:	48 01 d0             	add    %rdx,%rax
    17df:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    17e5:	83 c2 08             	add    $0x8,%edx
    17e8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    17ee:	eb 12                	jmp    1802 <printf+0x1a0>
    17f0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    17f7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    17fb:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1802:	8b 00                	mov    (%rax),%eax
    1804:	0f be d0             	movsbl %al,%edx
    1807:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    180d:	89 d6                	mov    %edx,%esi
    180f:	89 c7                	mov    %eax,%edi
    1811:	48 b8 7c 14 00 00 00 	movabs $0x147c,%rax
    1818:	00 00 00 
    181b:	ff d0                	callq  *%rax
      break;
    181d:	e9 12 02 00 00       	jmpq   1a34 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1822:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1828:	83 f8 2f             	cmp    $0x2f,%eax
    182b:	77 23                	ja     1850 <printf+0x1ee>
    182d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1834:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    183a:	89 d2                	mov    %edx,%edx
    183c:	48 01 d0             	add    %rdx,%rax
    183f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1845:	83 c2 08             	add    $0x8,%edx
    1848:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    184e:	eb 12                	jmp    1862 <printf+0x200>
    1850:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1857:	48 8d 50 08          	lea    0x8(%rax),%rdx
    185b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1862:	8b 10                	mov    (%rax),%edx
    1864:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    186a:	89 d6                	mov    %edx,%esi
    186c:	89 c7                	mov    %eax,%edi
    186e:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    1875:	00 00 00 
    1878:	ff d0                	callq  *%rax
      break;
    187a:	e9 b5 01 00 00       	jmpq   1a34 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    187f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1885:	83 f8 2f             	cmp    $0x2f,%eax
    1888:	77 23                	ja     18ad <printf+0x24b>
    188a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1891:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1897:	89 d2                	mov    %edx,%edx
    1899:	48 01 d0             	add    %rdx,%rax
    189c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18a2:	83 c2 08             	add    $0x8,%edx
    18a5:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18ab:	eb 12                	jmp    18bf <printf+0x25d>
    18ad:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18b4:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18b8:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18bf:	8b 10                	mov    (%rax),%edx
    18c1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18c7:	89 d6                	mov    %edx,%esi
    18c9:	89 c7                	mov    %eax,%edi
    18cb:	48 b8 0d 15 00 00 00 	movabs $0x150d,%rax
    18d2:	00 00 00 
    18d5:	ff d0                	callq  *%rax
      break;
    18d7:	e9 58 01 00 00       	jmpq   1a34 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    18dc:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18e2:	83 f8 2f             	cmp    $0x2f,%eax
    18e5:	77 23                	ja     190a <printf+0x2a8>
    18e7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18ee:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18f4:	89 d2                	mov    %edx,%edx
    18f6:	48 01 d0             	add    %rdx,%rax
    18f9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18ff:	83 c2 08             	add    $0x8,%edx
    1902:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1908:	eb 12                	jmp    191c <printf+0x2ba>
    190a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1911:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1915:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    191c:	48 8b 10             	mov    (%rax),%rdx
    191f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1925:	48 89 d6             	mov    %rdx,%rsi
    1928:	89 c7                	mov    %eax,%edi
    192a:	48 b8 b0 14 00 00 00 	movabs $0x14b0,%rax
    1931:	00 00 00 
    1934:	ff d0                	callq  *%rax
      break;
    1936:	e9 f9 00 00 00       	jmpq   1a34 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    193b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1941:	83 f8 2f             	cmp    $0x2f,%eax
    1944:	77 23                	ja     1969 <printf+0x307>
    1946:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    194d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1953:	89 d2                	mov    %edx,%edx
    1955:	48 01 d0             	add    %rdx,%rax
    1958:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    195e:	83 c2 08             	add    $0x8,%edx
    1961:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1967:	eb 12                	jmp    197b <printf+0x319>
    1969:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1970:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1974:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    197b:	48 8b 00             	mov    (%rax),%rax
    197e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1985:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    198c:	00 
    198d:	75 41                	jne    19d0 <printf+0x36e>
        s = "(null)";
    198f:	48 b8 80 21 00 00 00 	movabs $0x2180,%rax
    1996:	00 00 00 
    1999:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    19a0:	eb 2e                	jmp    19d0 <printf+0x36e>
        putc(fd, *(s++));
    19a2:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    19a9:	48 8d 50 01          	lea    0x1(%rax),%rdx
    19ad:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    19b4:	0f b6 00             	movzbl (%rax),%eax
    19b7:	0f be d0             	movsbl %al,%edx
    19ba:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19c0:	89 d6                	mov    %edx,%esi
    19c2:	89 c7                	mov    %eax,%edi
    19c4:	48 b8 7c 14 00 00 00 	movabs $0x147c,%rax
    19cb:	00 00 00 
    19ce:	ff d0                	callq  *%rax
      while (*s)
    19d0:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    19d7:	0f b6 00             	movzbl (%rax),%eax
    19da:	84 c0                	test   %al,%al
    19dc:	75 c4                	jne    19a2 <printf+0x340>
      break;
    19de:	eb 54                	jmp    1a34 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    19e0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19e6:	be 25 00 00 00       	mov    $0x25,%esi
    19eb:	89 c7                	mov    %eax,%edi
    19ed:	48 b8 7c 14 00 00 00 	movabs $0x147c,%rax
    19f4:	00 00 00 
    19f7:	ff d0                	callq  *%rax
      break;
    19f9:	eb 39                	jmp    1a34 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    19fb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a01:	be 25 00 00 00       	mov    $0x25,%esi
    1a06:	89 c7                	mov    %eax,%edi
    1a08:	48 b8 7c 14 00 00 00 	movabs $0x147c,%rax
    1a0f:	00 00 00 
    1a12:	ff d0                	callq  *%rax
      putc(fd, c);
    1a14:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a1a:	0f be d0             	movsbl %al,%edx
    1a1d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a23:	89 d6                	mov    %edx,%esi
    1a25:	89 c7                	mov    %eax,%edi
    1a27:	48 b8 7c 14 00 00 00 	movabs $0x147c,%rax
    1a2e:	00 00 00 
    1a31:	ff d0                	callq  *%rax
      break;
    1a33:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1a34:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1a3b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1a41:	48 63 d0             	movslq %eax,%rdx
    1a44:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1a4b:	48 01 d0             	add    %rdx,%rax
    1a4e:	0f b6 00             	movzbl (%rax),%eax
    1a51:	0f be c0             	movsbl %al,%eax
    1a54:	25 ff 00 00 00       	and    $0xff,%eax
    1a59:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1a5f:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1a66:	0f 85 8e fc ff ff    	jne    16fa <printf+0x98>
    }
  }
}
    1a6c:	eb 01                	jmp    1a6f <printf+0x40d>
      break;
    1a6e:	90                   	nop
}
    1a6f:	90                   	nop
    1a70:	c9                   	leaveq 
    1a71:	c3                   	retq   

0000000000001a72 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1a72:	f3 0f 1e fa          	endbr64 
    1a76:	55                   	push   %rbp
    1a77:	48 89 e5             	mov    %rsp,%rbp
    1a7a:	48 83 ec 18          	sub    $0x18,%rsp
    1a7e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1a82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1a86:	48 83 e8 10          	sub    $0x10,%rax
    1a8a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a8e:	48 b8 a0 25 00 00 00 	movabs $0x25a0,%rax
    1a95:	00 00 00 
    1a98:	48 8b 00             	mov    (%rax),%rax
    1a9b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1a9f:	eb 2f                	jmp    1ad0 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1aa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1aa5:	48 8b 00             	mov    (%rax),%rax
    1aa8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1aac:	72 17                	jb     1ac5 <free+0x53>
    1aae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ab2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1ab6:	77 2f                	ja     1ae7 <free+0x75>
    1ab8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1abc:	48 8b 00             	mov    (%rax),%rax
    1abf:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1ac3:	72 22                	jb     1ae7 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1ac5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ac9:	48 8b 00             	mov    (%rax),%rax
    1acc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ad0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ad4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1ad8:	76 c7                	jbe    1aa1 <free+0x2f>
    1ada:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ade:	48 8b 00             	mov    (%rax),%rax
    1ae1:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1ae5:	73 ba                	jae    1aa1 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1ae7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1aeb:	8b 40 08             	mov    0x8(%rax),%eax
    1aee:	89 c0                	mov    %eax,%eax
    1af0:	48 c1 e0 04          	shl    $0x4,%rax
    1af4:	48 89 c2             	mov    %rax,%rdx
    1af7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1afb:	48 01 c2             	add    %rax,%rdx
    1afe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b02:	48 8b 00             	mov    (%rax),%rax
    1b05:	48 39 c2             	cmp    %rax,%rdx
    1b08:	75 2d                	jne    1b37 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b0e:	8b 50 08             	mov    0x8(%rax),%edx
    1b11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b15:	48 8b 00             	mov    (%rax),%rax
    1b18:	8b 40 08             	mov    0x8(%rax),%eax
    1b1b:	01 c2                	add    %eax,%edx
    1b1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b21:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b28:	48 8b 00             	mov    (%rax),%rax
    1b2b:	48 8b 10             	mov    (%rax),%rdx
    1b2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b32:	48 89 10             	mov    %rdx,(%rax)
    1b35:	eb 0e                	jmp    1b45 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b3b:	48 8b 10             	mov    (%rax),%rdx
    1b3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b42:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1b45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b49:	8b 40 08             	mov    0x8(%rax),%eax
    1b4c:	89 c0                	mov    %eax,%eax
    1b4e:	48 c1 e0 04          	shl    $0x4,%rax
    1b52:	48 89 c2             	mov    %rax,%rdx
    1b55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b59:	48 01 d0             	add    %rdx,%rax
    1b5c:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b60:	75 27                	jne    1b89 <free+0x117>
    p->s.size += bp->s.size;
    1b62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b66:	8b 50 08             	mov    0x8(%rax),%edx
    1b69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b6d:	8b 40 08             	mov    0x8(%rax),%eax
    1b70:	01 c2                	add    %eax,%edx
    1b72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b76:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1b79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b7d:	48 8b 10             	mov    (%rax),%rdx
    1b80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b84:	48 89 10             	mov    %rdx,(%rax)
    1b87:	eb 0b                	jmp    1b94 <free+0x122>
  } else
    p->s.ptr = bp;
    1b89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b8d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1b91:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1b94:	48 ba a0 25 00 00 00 	movabs $0x25a0,%rdx
    1b9b:	00 00 00 
    1b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba2:	48 89 02             	mov    %rax,(%rdx)
}
    1ba5:	90                   	nop
    1ba6:	c9                   	leaveq 
    1ba7:	c3                   	retq   

0000000000001ba8 <morecore>:

static Header*
morecore(uint nu)
{
    1ba8:	f3 0f 1e fa          	endbr64 
    1bac:	55                   	push   %rbp
    1bad:	48 89 e5             	mov    %rsp,%rbp
    1bb0:	48 83 ec 20          	sub    $0x20,%rsp
    1bb4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1bb7:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1bbe:	77 07                	ja     1bc7 <morecore+0x1f>
    nu = 4096;
    1bc0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1bc7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1bca:	48 c1 e0 04          	shl    $0x4,%rax
    1bce:	48 89 c7             	mov    %rax,%rdi
    1bd1:	48 b8 55 14 00 00 00 	movabs $0x1455,%rax
    1bd8:	00 00 00 
    1bdb:	ff d0                	callq  *%rax
    1bdd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1be1:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1be6:	75 07                	jne    1bef <morecore+0x47>
    return 0;
    1be8:	b8 00 00 00 00       	mov    $0x0,%eax
    1bed:	eb 36                	jmp    1c25 <morecore+0x7d>
  hp = (Header*)p;
    1bef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1bf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bfb:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1bfe:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c05:	48 83 c0 10          	add    $0x10,%rax
    1c09:	48 89 c7             	mov    %rax,%rdi
    1c0c:	48 b8 72 1a 00 00 00 	movabs $0x1a72,%rax
    1c13:	00 00 00 
    1c16:	ff d0                	callq  *%rax
  return freep;
    1c18:	48 b8 a0 25 00 00 00 	movabs $0x25a0,%rax
    1c1f:	00 00 00 
    1c22:	48 8b 00             	mov    (%rax),%rax
}
    1c25:	c9                   	leaveq 
    1c26:	c3                   	retq   

0000000000001c27 <malloc>:

void*
malloc(uint nbytes)
{
    1c27:	f3 0f 1e fa          	endbr64 
    1c2b:	55                   	push   %rbp
    1c2c:	48 89 e5             	mov    %rsp,%rbp
    1c2f:	48 83 ec 30          	sub    $0x30,%rsp
    1c33:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c36:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1c39:	48 83 c0 0f          	add    $0xf,%rax
    1c3d:	48 c1 e8 04          	shr    $0x4,%rax
    1c41:	83 c0 01             	add    $0x1,%eax
    1c44:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1c47:	48 b8 a0 25 00 00 00 	movabs $0x25a0,%rax
    1c4e:	00 00 00 
    1c51:	48 8b 00             	mov    (%rax),%rax
    1c54:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1c58:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1c5d:	75 4a                	jne    1ca9 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1c5f:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    1c66:	00 00 00 
    1c69:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1c6d:	48 ba a0 25 00 00 00 	movabs $0x25a0,%rdx
    1c74:	00 00 00 
    1c77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c7b:	48 89 02             	mov    %rax,(%rdx)
    1c7e:	48 b8 a0 25 00 00 00 	movabs $0x25a0,%rax
    1c85:	00 00 00 
    1c88:	48 8b 00             	mov    (%rax),%rax
    1c8b:	48 ba 90 25 00 00 00 	movabs $0x2590,%rdx
    1c92:	00 00 00 
    1c95:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1c98:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    1c9f:	00 00 00 
    1ca2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ca9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cad:	48 8b 00             	mov    (%rax),%rax
    1cb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1cb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb8:	8b 40 08             	mov    0x8(%rax),%eax
    1cbb:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1cbe:	77 65                	ja     1d25 <malloc+0xfe>
      if(p->s.size == nunits)
    1cc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc4:	8b 40 08             	mov    0x8(%rax),%eax
    1cc7:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1cca:	75 10                	jne    1cdc <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1ccc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cd0:	48 8b 10             	mov    (%rax),%rdx
    1cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd7:	48 89 10             	mov    %rdx,(%rax)
    1cda:	eb 2e                	jmp    1d0a <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1cdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ce0:	8b 40 08             	mov    0x8(%rax),%eax
    1ce3:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1ce6:	89 c2                	mov    %eax,%edx
    1ce8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cec:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1cef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf3:	8b 40 08             	mov    0x8(%rax),%eax
    1cf6:	89 c0                	mov    %eax,%eax
    1cf8:	48 c1 e0 04          	shl    $0x4,%rax
    1cfc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d04:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d07:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d0a:	48 ba a0 25 00 00 00 	movabs $0x25a0,%rdx
    1d11:	00 00 00 
    1d14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d18:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d1f:	48 83 c0 10          	add    $0x10,%rax
    1d23:	eb 4e                	jmp    1d73 <malloc+0x14c>
    }
    if(p == freep)
    1d25:	48 b8 a0 25 00 00 00 	movabs $0x25a0,%rax
    1d2c:	00 00 00 
    1d2f:	48 8b 00             	mov    (%rax),%rax
    1d32:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d36:	75 23                	jne    1d5b <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1d38:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d3b:	89 c7                	mov    %eax,%edi
    1d3d:	48 b8 a8 1b 00 00 00 	movabs $0x1ba8,%rax
    1d44:	00 00 00 
    1d47:	ff d0                	callq  *%rax
    1d49:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1d4d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1d52:	75 07                	jne    1d5b <malloc+0x134>
        return 0;
    1d54:	b8 00 00 00 00       	mov    $0x0,%eax
    1d59:	eb 18                	jmp    1d73 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d5f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d67:	48 8b 00             	mov    (%rax),%rax
    1d6a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d6e:	e9 41 ff ff ff       	jmpq   1cb4 <malloc+0x8d>
  }
}
    1d73:	c9                   	leaveq 
    1d74:	c3                   	retq   

0000000000001d75 <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1d75:	f3 0f 1e fa          	endbr64 
    1d79:	55                   	push   %rbp
    1d7a:	48 89 e5             	mov    %rsp,%rbp
    1d7d:	48 83 ec 30          	sub    $0x30,%rsp
    1d81:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1d85:	bf 18 00 00 00       	mov    $0x18,%edi
    1d8a:	48 b8 27 1c 00 00 00 	movabs $0x1c27,%rax
    1d91:	00 00 00 
    1d94:	ff d0                	callq  *%rax
    1d96:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1d9a:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1d9f:	75 0a                	jne    1dab <co_new+0x36>
    return 0;
    1da1:	b8 00 00 00 00       	mov    $0x0,%eax
    1da6:	e9 e1 00 00 00       	jmpq   1e8c <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1dab:	bf 00 20 00 00       	mov    $0x2000,%edi
    1db0:	48 b8 27 1c 00 00 00 	movabs $0x1c27,%rax
    1db7:	00 00 00 
    1dba:	ff d0                	callq  *%rax
    1dbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1dc0:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1dc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dc8:	48 8b 40 10          	mov    0x10(%rax),%rax
    1dcc:	48 85 c0             	test   %rax,%rax
    1dcf:	75 1d                	jne    1dee <co_new+0x79>
    free(co1);
    1dd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dd5:	48 89 c7             	mov    %rax,%rdi
    1dd8:	48 b8 72 1a 00 00 00 	movabs $0x1a72,%rax
    1ddf:	00 00 00 
    1de2:	ff d0                	callq  *%rax
    return 0;
    1de4:	b8 00 00 00 00       	mov    $0x0,%eax
    1de9:	e9 9e 00 00 00       	jmpq   1e8c <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1df2:	48 8b 40 10          	mov    0x10(%rax),%rax
    1df6:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    1dfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    1e00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e04:	48 8d 50 30          	lea    0x30(%rax),%rdx
    1e08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1e0c:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    1e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e13:	48 83 c0 38          	add    $0x38,%rax
    1e17:	48 ba fe 1f 00 00 00 	movabs $0x1ffe,%rdx
    1e1e:	00 00 00 
    1e21:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    1e24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1e2c:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    1e2f:	48 b8 b8 25 00 00 00 	movabs $0x25b8,%rax
    1e36:	00 00 00 
    1e39:	48 8b 00             	mov    (%rax),%rax
    1e3c:	48 85 c0             	test   %rax,%rax
    1e3f:	75 13                	jne    1e54 <co_new+0xdf>
  {
  	co_list = co1;
    1e41:	48 ba b8 25 00 00 00 	movabs $0x25b8,%rdx
    1e48:	00 00 00 
    1e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e4f:	48 89 02             	mov    %rax,(%rdx)
    1e52:	eb 34                	jmp    1e88 <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    1e54:	48 b8 b8 25 00 00 00 	movabs $0x25b8,%rax
    1e5b:	00 00 00 
    1e5e:	48 8b 00             	mov    (%rax),%rax
    1e61:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1e65:	eb 0c                	jmp    1e73 <co_new+0xfe>
	{
		head = head->next;
    1e67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e6b:	48 8b 40 08          	mov    0x8(%rax),%rax
    1e6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1e73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e77:	48 8b 40 08          	mov    0x8(%rax),%rax
    1e7b:	48 85 c0             	test   %rax,%rax
    1e7e:	75 e7                	jne    1e67 <co_new+0xf2>
	}
	head = co1;
    1e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    1e88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    1e8c:	c9                   	leaveq 
    1e8d:	c3                   	retq   

0000000000001e8e <co_run>:

  int
co_run(void)
{
    1e8e:	f3 0f 1e fa          	endbr64 
    1e92:	55                   	push   %rbp
    1e93:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    1e96:	48 b8 b8 25 00 00 00 	movabs $0x25b8,%rax
    1e9d:	00 00 00 
    1ea0:	48 8b 00             	mov    (%rax),%rax
    1ea3:	48 85 c0             	test   %rax,%rax
    1ea6:	74 4a                	je     1ef2 <co_run+0x64>
	{
		co_current = co_list;
    1ea8:	48 b8 b8 25 00 00 00 	movabs $0x25b8,%rax
    1eaf:	00 00 00 
    1eb2:	48 8b 00             	mov    (%rax),%rax
    1eb5:	48 ba b0 25 00 00 00 	movabs $0x25b0,%rdx
    1ebc:	00 00 00 
    1ebf:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    1ec2:	48 b8 b0 25 00 00 00 	movabs $0x25b0,%rax
    1ec9:	00 00 00 
    1ecc:	48 8b 00             	mov    (%rax),%rax
    1ecf:	48 8b 00             	mov    (%rax),%rax
    1ed2:	48 89 c6             	mov    %rax,%rsi
    1ed5:	48 bf a8 25 00 00 00 	movabs $0x25a8,%rdi
    1edc:	00 00 00 
    1edf:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1ee6:	00 00 00 
    1ee9:	ff d0                	callq  *%rax
		return 1;
    1eeb:	b8 01 00 00 00       	mov    $0x1,%eax
    1ef0:	eb 05                	jmp    1ef7 <co_run+0x69>
	}
	return 0;
    1ef2:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1ef7:	5d                   	pop    %rbp
    1ef8:	c3                   	retq   

0000000000001ef9 <co_run_all>:

  int
co_run_all(void)
{
    1ef9:	f3 0f 1e fa          	endbr64 
    1efd:	55                   	push   %rbp
    1efe:	48 89 e5             	mov    %rsp,%rbp
    1f01:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    1f05:	48 b8 b8 25 00 00 00 	movabs $0x25b8,%rax
    1f0c:	00 00 00 
    1f0f:	48 8b 00             	mov    (%rax),%rax
    1f12:	48 85 c0             	test   %rax,%rax
    1f15:	75 07                	jne    1f1e <co_run_all+0x25>
		return 0;
    1f17:	b8 00 00 00 00       	mov    $0x0,%eax
    1f1c:	eb 37                	jmp    1f55 <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    1f1e:	48 b8 b8 25 00 00 00 	movabs $0x25b8,%rax
    1f25:	00 00 00 
    1f28:	48 8b 00             	mov    (%rax),%rax
    1f2b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    1f2f:	eb 18                	jmp    1f49 <co_run_all+0x50>
			co_run();
    1f31:	48 b8 8e 1e 00 00 00 	movabs $0x1e8e,%rax
    1f38:	00 00 00 
    1f3b:	ff d0                	callq  *%rax
			tmp = tmp->next;
    1f3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f41:	48 8b 40 08          	mov    0x8(%rax),%rax
    1f45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    1f49:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1f4e:	75 e1                	jne    1f31 <co_run_all+0x38>
		}
		return 1;
    1f50:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    1f55:	c9                   	leaveq 
    1f56:	c3                   	retq   

0000000000001f57 <co_yield>:

  void
co_yield()
{
    1f57:	f3 0f 1e fa          	endbr64 
    1f5b:	55                   	push   %rbp
    1f5c:	48 89 e5             	mov    %rsp,%rbp
    1f5f:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    1f63:	48 b8 b0 25 00 00 00 	movabs $0x25b0,%rax
    1f6a:	00 00 00 
    1f6d:	48 8b 00             	mov    (%rax),%rax
    1f70:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    1f74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f78:	48 8b 40 08          	mov    0x8(%rax),%rax
    1f7c:	48 85 c0             	test   %rax,%rax
    1f7f:	74 46                	je     1fc7 <co_yield+0x70>
  {
  	co_current = co_current->next;
    1f81:	48 b8 b0 25 00 00 00 	movabs $0x25b0,%rax
    1f88:	00 00 00 
    1f8b:	48 8b 00             	mov    (%rax),%rax
    1f8e:	48 8b 40 08          	mov    0x8(%rax),%rax
    1f92:	48 ba b0 25 00 00 00 	movabs $0x25b0,%rdx
    1f99:	00 00 00 
    1f9c:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    1f9f:	48 b8 b0 25 00 00 00 	movabs $0x25b0,%rax
    1fa6:	00 00 00 
    1fa9:	48 8b 00             	mov    (%rax),%rax
    1fac:	48 8b 10             	mov    (%rax),%rdx
    1faf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb3:	48 89 d6             	mov    %rdx,%rsi
    1fb6:	48 89 c7             	mov    %rax,%rdi
    1fb9:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1fc0:	00 00 00 
    1fc3:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    1fc5:	eb 34                	jmp    1ffb <co_yield+0xa4>
	co_current = 0;
    1fc7:	48 b8 b0 25 00 00 00 	movabs $0x25b0,%rax
    1fce:	00 00 00 
    1fd1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    1fd8:	48 b8 a8 25 00 00 00 	movabs $0x25a8,%rax
    1fdf:	00 00 00 
    1fe2:	48 8b 10             	mov    (%rax),%rdx
    1fe5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fe9:	48 89 d6             	mov    %rdx,%rsi
    1fec:	48 89 c7             	mov    %rax,%rdi
    1fef:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1ff6:	00 00 00 
    1ff9:	ff d0                	callq  *%rax
}
    1ffb:	90                   	nop
    1ffc:	c9                   	leaveq 
    1ffd:	c3                   	retq   

0000000000001ffe <co_exit>:

  void
co_exit(void)
{
    1ffe:	f3 0f 1e fa          	endbr64 
    2002:	55                   	push   %rbp
    2003:	48 89 e5             	mov    %rsp,%rbp
    2006:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    200a:	48 b8 b0 25 00 00 00 	movabs $0x25b0,%rax
    2011:	00 00 00 
    2014:	48 8b 00             	mov    (%rax),%rax
    2017:	48 85 c0             	test   %rax,%rax
    201a:	0f 84 ec 00 00 00    	je     210c <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    2020:	48 b8 b8 25 00 00 00 	movabs $0x25b8,%rax
    2027:	00 00 00 
    202a:	48 8b 00             	mov    (%rax),%rax
    202d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    2031:	e9 c9 00 00 00       	jmpq   20ff <co_exit+0x101>
		if(tmp == co_current)
    2036:	48 b8 b0 25 00 00 00 	movabs $0x25b0,%rax
    203d:	00 00 00 
    2040:	48 8b 00             	mov    (%rax),%rax
    2043:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2047:	0f 85 9e 00 00 00    	jne    20eb <co_exit+0xed>
		{
			if(tmp->next)
    204d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2051:	48 8b 40 08          	mov    0x8(%rax),%rax
    2055:	48 85 c0             	test   %rax,%rax
    2058:	74 54                	je     20ae <co_exit+0xb0>
			{
				if(prev)
    205a:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    205f:	74 10                	je     2071 <co_exit+0x73>
				{
					prev->next = tmp->next;
    2061:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2065:	48 8b 50 08          	mov    0x8(%rax),%rdx
    2069:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    206d:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    2071:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2075:	48 8b 40 08          	mov    0x8(%rax),%rax
    2079:	48 ba b8 25 00 00 00 	movabs $0x25b8,%rdx
    2080:	00 00 00 
    2083:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    2086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    208a:	48 8b 00             	mov    (%rax),%rax
    208d:	48 ba b0 25 00 00 00 	movabs $0x25b0,%rdx
    2094:	00 00 00 
    2097:	48 8b 12             	mov    (%rdx),%rdx
    209a:	48 89 c6             	mov    %rax,%rsi
    209d:	48 89 d7             	mov    %rdx,%rdi
    20a0:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    20a7:	00 00 00 
    20aa:	ff d0                	callq  *%rax
    20ac:	eb 3d                	jmp    20eb <co_exit+0xed>
			}else{
				co_list = 0;
    20ae:	48 b8 b8 25 00 00 00 	movabs $0x25b8,%rax
    20b5:	00 00 00 
    20b8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    20bf:	48 b8 a8 25 00 00 00 	movabs $0x25a8,%rax
    20c6:	00 00 00 
    20c9:	48 8b 00             	mov    (%rax),%rax
    20cc:	48 ba b0 25 00 00 00 	movabs $0x25b0,%rdx
    20d3:	00 00 00 
    20d6:	48 8b 12             	mov    (%rdx),%rdx
    20d9:	48 89 c6             	mov    %rax,%rsi
    20dc:	48 89 d7             	mov    %rdx,%rdi
    20df:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    20e6:	00 00 00 
    20e9:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    20eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20ef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    20f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20f7:	48 8b 40 08          	mov    0x8(%rax),%rax
    20fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    20ff:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2104:	0f 85 2c ff ff ff    	jne    2036 <co_exit+0x38>
    210a:	eb 01                	jmp    210d <co_exit+0x10f>
		return;
    210c:	90                   	nop
	}
}
    210d:	c9                   	leaveq 
    210e:	c3                   	retq   

000000000000210f <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    210f:	f3 0f 1e fa          	endbr64 
    2113:	55                   	push   %rbp
    2114:	48 89 e5             	mov    %rsp,%rbp
    2117:	48 83 ec 10          	sub    $0x10,%rsp
    211b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    211f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2124:	74 37                	je     215d <co_destroy+0x4e>
    if (co->stack)
    2126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    212a:	48 8b 40 10          	mov    0x10(%rax),%rax
    212e:	48 85 c0             	test   %rax,%rax
    2131:	74 17                	je     214a <co_destroy+0x3b>
      free(co->stack);
    2133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2137:	48 8b 40 10          	mov    0x10(%rax),%rax
    213b:	48 89 c7             	mov    %rax,%rdi
    213e:	48 b8 72 1a 00 00 00 	movabs $0x1a72,%rax
    2145:	00 00 00 
    2148:	ff d0                	callq  *%rax
    free(co);
    214a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    214e:	48 89 c7             	mov    %rax,%rdi
    2151:	48 b8 72 1a 00 00 00 	movabs $0x1a72,%rax
    2158:	00 00 00 
    215b:	ff d0                	callq  *%rax
  }
}
    215d:	90                   	nop
    215e:	c9                   	leaveq 
    215f:	c3                   	retq   

0000000000002160 <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    2160:	55                   	push   %rbp
  pushq   %rbx
    2161:	53                   	push   %rbx
  pushq   %r12
    2162:	41 54                	push   %r12
  pushq   %r13
    2164:	41 55                	push   %r13
  pushq   %r14
    2166:	41 56                	push   %r14
  pushq   %r15
    2168:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    216a:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    216d:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    2170:	41 5f                	pop    %r15
  popq    %r14
    2172:	41 5e                	pop    %r14
  popq    %r13
    2174:	41 5d                	pop    %r13
  popq    %r12
    2176:	41 5c                	pop    %r12
  popq    %rbx
    2178:	5b                   	pop    %rbx
  popq    %rbp
    2179:	5d                   	pop    %rbp

  retq #??
    217a:	c3                   	retq   
