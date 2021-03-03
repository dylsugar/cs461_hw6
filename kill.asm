
_kill:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  if(argc < 2){
    1013:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1017:	7f 2c                	jg     1045 <main+0x45>
    printf(2, "usage: kill pid...\n");
    1019:	48 be e0 21 00 00 00 	movabs $0x21e0,%rsi
    1020:	00 00 00 
    1023:	bf 02 00 00 00       	mov    $0x2,%edi
    1028:	b8 00 00 00 00       	mov    $0x0,%eax
    102d:	48 ba c7 16 00 00 00 	movabs $0x16c7,%rdx
    1034:	00 00 00 
    1037:	ff d2                	callq  *%rdx
    exit();
    1039:	48 b8 dd 13 00 00 00 	movabs $0x13dd,%rax
    1040:	00 00 00 
    1043:	ff d0                	callq  *%rax
  }
  for(i=1; i<argc; i++)
    1045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    104c:	eb 38                	jmp    1086 <main+0x86>
    kill(atoi(argv[i]));
    104e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1051:	48 98                	cltq   
    1053:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    105a:	00 
    105b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    105f:	48 01 d0             	add    %rdx,%rax
    1062:	48 8b 00             	mov    (%rax),%rax
    1065:	48 89 c7             	mov    %rax,%rdi
    1068:	48 b8 1b 13 00 00 00 	movabs $0x131b,%rax
    106f:	00 00 00 
    1072:	ff d0                	callq  *%rax
    1074:	89 c7                	mov    %eax,%edi
    1076:	48 b8 2b 14 00 00 00 	movabs $0x142b,%rax
    107d:	00 00 00 
    1080:	ff d0                	callq  *%rax
  for(i=1; i<argc; i++)
    1082:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1086:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1089:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    108c:	7c c0                	jl     104e <main+0x4e>
  exit();
    108e:	48 b8 dd 13 00 00 00 	movabs $0x13dd,%rax
    1095:	00 00 00 
    1098:	ff d0                	callq  *%rax

000000000000109a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    109a:	f3 0f 1e fa          	endbr64 
    109e:	55                   	push   %rbp
    109f:	48 89 e5             	mov    %rsp,%rbp
    10a2:	48 83 ec 10          	sub    $0x10,%rsp
    10a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10aa:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10ad:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10b0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10b4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10ba:	48 89 ce             	mov    %rcx,%rsi
    10bd:	48 89 f7             	mov    %rsi,%rdi
    10c0:	89 d1                	mov    %edx,%ecx
    10c2:	fc                   	cld    
    10c3:	f3 aa                	rep stos %al,%es:(%rdi)
    10c5:	89 ca                	mov    %ecx,%edx
    10c7:	48 89 fe             	mov    %rdi,%rsi
    10ca:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10ce:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10d1:	90                   	nop
    10d2:	c9                   	leaveq 
    10d3:	c3                   	retq   

00000000000010d4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10d4:	f3 0f 1e fa          	endbr64 
    10d8:	55                   	push   %rbp
    10d9:	48 89 e5             	mov    %rsp,%rbp
    10dc:	48 83 ec 20          	sub    $0x20,%rsp
    10e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    10e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    10e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    10f0:	90                   	nop
    10f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    10f5:	48 8d 42 01          	lea    0x1(%rdx),%rax
    10f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1101:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1105:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1109:	0f b6 12             	movzbl (%rdx),%edx
    110c:	88 10                	mov    %dl,(%rax)
    110e:	0f b6 00             	movzbl (%rax),%eax
    1111:	84 c0                	test   %al,%al
    1113:	75 dc                	jne    10f1 <strcpy+0x1d>
    ;
  return os;
    1115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1119:	c9                   	leaveq 
    111a:	c3                   	retq   

000000000000111b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    111b:	f3 0f 1e fa          	endbr64 
    111f:	55                   	push   %rbp
    1120:	48 89 e5             	mov    %rsp,%rbp
    1123:	48 83 ec 10          	sub    $0x10,%rsp
    1127:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    112b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    112f:	eb 0a                	jmp    113b <strcmp+0x20>
    p++, q++;
    1131:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1136:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    113b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    113f:	0f b6 00             	movzbl (%rax),%eax
    1142:	84 c0                	test   %al,%al
    1144:	74 12                	je     1158 <strcmp+0x3d>
    1146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    114a:	0f b6 10             	movzbl (%rax),%edx
    114d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1151:	0f b6 00             	movzbl (%rax),%eax
    1154:	38 c2                	cmp    %al,%dl
    1156:	74 d9                	je     1131 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    115c:	0f b6 00             	movzbl (%rax),%eax
    115f:	0f b6 d0             	movzbl %al,%edx
    1162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1166:	0f b6 00             	movzbl (%rax),%eax
    1169:	0f b6 c0             	movzbl %al,%eax
    116c:	29 c2                	sub    %eax,%edx
    116e:	89 d0                	mov    %edx,%eax
}
    1170:	c9                   	leaveq 
    1171:	c3                   	retq   

0000000000001172 <strlen>:

uint
strlen(char *s)
{
    1172:	f3 0f 1e fa          	endbr64 
    1176:	55                   	push   %rbp
    1177:	48 89 e5             	mov    %rsp,%rbp
    117a:	48 83 ec 18          	sub    $0x18,%rsp
    117e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1182:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1189:	eb 04                	jmp    118f <strlen+0x1d>
    118b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    118f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1192:	48 63 d0             	movslq %eax,%rdx
    1195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1199:	48 01 d0             	add    %rdx,%rax
    119c:	0f b6 00             	movzbl (%rax),%eax
    119f:	84 c0                	test   %al,%al
    11a1:	75 e8                	jne    118b <strlen+0x19>
    ;
  return n;
    11a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11a6:	c9                   	leaveq 
    11a7:	c3                   	retq   

00000000000011a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11a8:	f3 0f 1e fa          	endbr64 
    11ac:	55                   	push   %rbp
    11ad:	48 89 e5             	mov    %rsp,%rbp
    11b0:	48 83 ec 10          	sub    $0x10,%rsp
    11b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11b8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11bb:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11be:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11c1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11c8:	89 ce                	mov    %ecx,%esi
    11ca:	48 89 c7             	mov    %rax,%rdi
    11cd:	48 b8 9a 10 00 00 00 	movabs $0x109a,%rax
    11d4:	00 00 00 
    11d7:	ff d0                	callq  *%rax
  return dst;
    11d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11dd:	c9                   	leaveq 
    11de:	c3                   	retq   

00000000000011df <strchr>:

char*
strchr(const char *s, char c)
{
    11df:	f3 0f 1e fa          	endbr64 
    11e3:	55                   	push   %rbp
    11e4:	48 89 e5             	mov    %rsp,%rbp
    11e7:	48 83 ec 10          	sub    $0x10,%rsp
    11eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ef:	89 f0                	mov    %esi,%eax
    11f1:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    11f4:	eb 17                	jmp    120d <strchr+0x2e>
    if(*s == c)
    11f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11fa:	0f b6 00             	movzbl (%rax),%eax
    11fd:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1200:	75 06                	jne    1208 <strchr+0x29>
      return (char*)s;
    1202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1206:	eb 15                	jmp    121d <strchr+0x3e>
  for(; *s; s++)
    1208:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    120d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1211:	0f b6 00             	movzbl (%rax),%eax
    1214:	84 c0                	test   %al,%al
    1216:	75 de                	jne    11f6 <strchr+0x17>
  return 0;
    1218:	b8 00 00 00 00       	mov    $0x0,%eax
}
    121d:	c9                   	leaveq 
    121e:	c3                   	retq   

000000000000121f <gets>:

char*
gets(char *buf, int max)
{
    121f:	f3 0f 1e fa          	endbr64 
    1223:	55                   	push   %rbp
    1224:	48 89 e5             	mov    %rsp,%rbp
    1227:	48 83 ec 20          	sub    $0x20,%rsp
    122b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    122f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1239:	eb 4f                	jmp    128a <gets+0x6b>
    cc = read(0, &c, 1);
    123b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    123f:	ba 01 00 00 00       	mov    $0x1,%edx
    1244:	48 89 c6             	mov    %rax,%rsi
    1247:	bf 00 00 00 00       	mov    $0x0,%edi
    124c:	48 b8 04 14 00 00 00 	movabs $0x1404,%rax
    1253:	00 00 00 
    1256:	ff d0                	callq  *%rax
    1258:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    125b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    125f:	7e 36                	jle    1297 <gets+0x78>
      break;
    buf[i++] = c;
    1261:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1264:	8d 50 01             	lea    0x1(%rax),%edx
    1267:	89 55 fc             	mov    %edx,-0x4(%rbp)
    126a:	48 63 d0             	movslq %eax,%rdx
    126d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1271:	48 01 c2             	add    %rax,%rdx
    1274:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1278:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    127a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    127e:	3c 0a                	cmp    $0xa,%al
    1280:	74 16                	je     1298 <gets+0x79>
    1282:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1286:	3c 0d                	cmp    $0xd,%al
    1288:	74 0e                	je     1298 <gets+0x79>
  for(i=0; i+1 < max; ){
    128a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    128d:	83 c0 01             	add    $0x1,%eax
    1290:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1293:	7f a6                	jg     123b <gets+0x1c>
    1295:	eb 01                	jmp    1298 <gets+0x79>
      break;
    1297:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1298:	8b 45 fc             	mov    -0x4(%rbp),%eax
    129b:	48 63 d0             	movslq %eax,%rdx
    129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a2:	48 01 d0             	add    %rdx,%rax
    12a5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12ac:	c9                   	leaveq 
    12ad:	c3                   	retq   

00000000000012ae <stat>:

int
stat(char *n, struct stat *st)
{
    12ae:	f3 0f 1e fa          	endbr64 
    12b2:	55                   	push   %rbp
    12b3:	48 89 e5             	mov    %rsp,%rbp
    12b6:	48 83 ec 20          	sub    $0x20,%rsp
    12ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12c6:	be 00 00 00 00       	mov    $0x0,%esi
    12cb:	48 89 c7             	mov    %rax,%rdi
    12ce:	48 b8 45 14 00 00 00 	movabs $0x1445,%rax
    12d5:	00 00 00 
    12d8:	ff d0                	callq  *%rax
    12da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12e1:	79 07                	jns    12ea <stat+0x3c>
    return -1;
    12e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12e8:	eb 2f                	jmp    1319 <stat+0x6b>
  r = fstat(fd, st);
    12ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12f1:	48 89 d6             	mov    %rdx,%rsi
    12f4:	89 c7                	mov    %eax,%edi
    12f6:	48 b8 6c 14 00 00 00 	movabs $0x146c,%rax
    12fd:	00 00 00 
    1300:	ff d0                	callq  *%rax
    1302:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1305:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1308:	89 c7                	mov    %eax,%edi
    130a:	48 b8 1e 14 00 00 00 	movabs $0x141e,%rax
    1311:	00 00 00 
    1314:	ff d0                	callq  *%rax
  return r;
    1316:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1319:	c9                   	leaveq 
    131a:	c3                   	retq   

000000000000131b <atoi>:

int
atoi(const char *s)
{
    131b:	f3 0f 1e fa          	endbr64 
    131f:	55                   	push   %rbp
    1320:	48 89 e5             	mov    %rsp,%rbp
    1323:	48 83 ec 18          	sub    $0x18,%rsp
    1327:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    132b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1332:	eb 28                	jmp    135c <atoi+0x41>
    n = n*10 + *s++ - '0';
    1334:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1337:	89 d0                	mov    %edx,%eax
    1339:	c1 e0 02             	shl    $0x2,%eax
    133c:	01 d0                	add    %edx,%eax
    133e:	01 c0                	add    %eax,%eax
    1340:	89 c1                	mov    %eax,%ecx
    1342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1346:	48 8d 50 01          	lea    0x1(%rax),%rdx
    134a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    134e:	0f b6 00             	movzbl (%rax),%eax
    1351:	0f be c0             	movsbl %al,%eax
    1354:	01 c8                	add    %ecx,%eax
    1356:	83 e8 30             	sub    $0x30,%eax
    1359:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    135c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1360:	0f b6 00             	movzbl (%rax),%eax
    1363:	3c 2f                	cmp    $0x2f,%al
    1365:	7e 0b                	jle    1372 <atoi+0x57>
    1367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    136b:	0f b6 00             	movzbl (%rax),%eax
    136e:	3c 39                	cmp    $0x39,%al
    1370:	7e c2                	jle    1334 <atoi+0x19>
  return n;
    1372:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1375:	c9                   	leaveq 
    1376:	c3                   	retq   

0000000000001377 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1377:	f3 0f 1e fa          	endbr64 
    137b:	55                   	push   %rbp
    137c:	48 89 e5             	mov    %rsp,%rbp
    137f:	48 83 ec 28          	sub    $0x28,%rsp
    1383:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1387:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    138b:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1392:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    139a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    139e:	eb 1d                	jmp    13bd <memmove+0x46>
    *dst++ = *src++;
    13a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13a4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13b0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13b4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13b8:	0f b6 12             	movzbl (%rdx),%edx
    13bb:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13c0:	8d 50 ff             	lea    -0x1(%rax),%edx
    13c3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13c6:	85 c0                	test   %eax,%eax
    13c8:	7f d6                	jg     13a0 <memmove+0x29>
  return vdst;
    13ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13ce:	c9                   	leaveq 
    13cf:	c3                   	retq   

00000000000013d0 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13d0:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13d7:	49 89 ca             	mov    %rcx,%r10
    13da:	0f 05                	syscall 
    13dc:	c3                   	retq   

00000000000013dd <exit>:
SYSCALL(exit)
    13dd:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    13e4:	49 89 ca             	mov    %rcx,%r10
    13e7:	0f 05                	syscall 
    13e9:	c3                   	retq   

00000000000013ea <wait>:
SYSCALL(wait)
    13ea:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13f1:	49 89 ca             	mov    %rcx,%r10
    13f4:	0f 05                	syscall 
    13f6:	c3                   	retq   

00000000000013f7 <pipe>:
SYSCALL(pipe)
    13f7:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13fe:	49 89 ca             	mov    %rcx,%r10
    1401:	0f 05                	syscall 
    1403:	c3                   	retq   

0000000000001404 <read>:
SYSCALL(read)
    1404:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    140b:	49 89 ca             	mov    %rcx,%r10
    140e:	0f 05                	syscall 
    1410:	c3                   	retq   

0000000000001411 <write>:
SYSCALL(write)
    1411:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1418:	49 89 ca             	mov    %rcx,%r10
    141b:	0f 05                	syscall 
    141d:	c3                   	retq   

000000000000141e <close>:
SYSCALL(close)
    141e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1425:	49 89 ca             	mov    %rcx,%r10
    1428:	0f 05                	syscall 
    142a:	c3                   	retq   

000000000000142b <kill>:
SYSCALL(kill)
    142b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1432:	49 89 ca             	mov    %rcx,%r10
    1435:	0f 05                	syscall 
    1437:	c3                   	retq   

0000000000001438 <exec>:
SYSCALL(exec)
    1438:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    143f:	49 89 ca             	mov    %rcx,%r10
    1442:	0f 05                	syscall 
    1444:	c3                   	retq   

0000000000001445 <open>:
SYSCALL(open)
    1445:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    144c:	49 89 ca             	mov    %rcx,%r10
    144f:	0f 05                	syscall 
    1451:	c3                   	retq   

0000000000001452 <mknod>:
SYSCALL(mknod)
    1452:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1459:	49 89 ca             	mov    %rcx,%r10
    145c:	0f 05                	syscall 
    145e:	c3                   	retq   

000000000000145f <unlink>:
SYSCALL(unlink)
    145f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1466:	49 89 ca             	mov    %rcx,%r10
    1469:	0f 05                	syscall 
    146b:	c3                   	retq   

000000000000146c <fstat>:
SYSCALL(fstat)
    146c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1473:	49 89 ca             	mov    %rcx,%r10
    1476:	0f 05                	syscall 
    1478:	c3                   	retq   

0000000000001479 <link>:
SYSCALL(link)
    1479:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1480:	49 89 ca             	mov    %rcx,%r10
    1483:	0f 05                	syscall 
    1485:	c3                   	retq   

0000000000001486 <mkdir>:
SYSCALL(mkdir)
    1486:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    148d:	49 89 ca             	mov    %rcx,%r10
    1490:	0f 05                	syscall 
    1492:	c3                   	retq   

0000000000001493 <chdir>:
SYSCALL(chdir)
    1493:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    149a:	49 89 ca             	mov    %rcx,%r10
    149d:	0f 05                	syscall 
    149f:	c3                   	retq   

00000000000014a0 <dup>:
SYSCALL(dup)
    14a0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14a7:	49 89 ca             	mov    %rcx,%r10
    14aa:	0f 05                	syscall 
    14ac:	c3                   	retq   

00000000000014ad <getpid>:
SYSCALL(getpid)
    14ad:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14b4:	49 89 ca             	mov    %rcx,%r10
    14b7:	0f 05                	syscall 
    14b9:	c3                   	retq   

00000000000014ba <sbrk>:
SYSCALL(sbrk)
    14ba:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14c1:	49 89 ca             	mov    %rcx,%r10
    14c4:	0f 05                	syscall 
    14c6:	c3                   	retq   

00000000000014c7 <sleep>:
SYSCALL(sleep)
    14c7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14ce:	49 89 ca             	mov    %rcx,%r10
    14d1:	0f 05                	syscall 
    14d3:	c3                   	retq   

00000000000014d4 <uptime>:
SYSCALL(uptime)
    14d4:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14db:	49 89 ca             	mov    %rcx,%r10
    14de:	0f 05                	syscall 
    14e0:	c3                   	retq   

00000000000014e1 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    14e1:	f3 0f 1e fa          	endbr64 
    14e5:	55                   	push   %rbp
    14e6:	48 89 e5             	mov    %rsp,%rbp
    14e9:	48 83 ec 10          	sub    $0x10,%rsp
    14ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
    14f0:	89 f0                	mov    %esi,%eax
    14f2:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    14f5:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    14f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14fc:	ba 01 00 00 00       	mov    $0x1,%edx
    1501:	48 89 ce             	mov    %rcx,%rsi
    1504:	89 c7                	mov    %eax,%edi
    1506:	48 b8 11 14 00 00 00 	movabs $0x1411,%rax
    150d:	00 00 00 
    1510:	ff d0                	callq  *%rax
}
    1512:	90                   	nop
    1513:	c9                   	leaveq 
    1514:	c3                   	retq   

0000000000001515 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1515:	f3 0f 1e fa          	endbr64 
    1519:	55                   	push   %rbp
    151a:	48 89 e5             	mov    %rsp,%rbp
    151d:	48 83 ec 20          	sub    $0x20,%rsp
    1521:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1524:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1528:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    152f:	eb 35                	jmp    1566 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1531:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1535:	48 c1 e8 3c          	shr    $0x3c,%rax
    1539:	48 ba f0 25 00 00 00 	movabs $0x25f0,%rdx
    1540:	00 00 00 
    1543:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1547:	0f be d0             	movsbl %al,%edx
    154a:	8b 45 ec             	mov    -0x14(%rbp),%eax
    154d:	89 d6                	mov    %edx,%esi
    154f:	89 c7                	mov    %eax,%edi
    1551:	48 b8 e1 14 00 00 00 	movabs $0x14e1,%rax
    1558:	00 00 00 
    155b:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    155d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1561:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1566:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1569:	83 f8 0f             	cmp    $0xf,%eax
    156c:	76 c3                	jbe    1531 <print_x64+0x1c>
}
    156e:	90                   	nop
    156f:	90                   	nop
    1570:	c9                   	leaveq 
    1571:	c3                   	retq   

0000000000001572 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1572:	f3 0f 1e fa          	endbr64 
    1576:	55                   	push   %rbp
    1577:	48 89 e5             	mov    %rsp,%rbp
    157a:	48 83 ec 20          	sub    $0x20,%rsp
    157e:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1581:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1584:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    158b:	eb 36                	jmp    15c3 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    158d:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1590:	c1 e8 1c             	shr    $0x1c,%eax
    1593:	89 c2                	mov    %eax,%edx
    1595:	48 b8 f0 25 00 00 00 	movabs $0x25f0,%rax
    159c:	00 00 00 
    159f:	89 d2                	mov    %edx,%edx
    15a1:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15a5:	0f be d0             	movsbl %al,%edx
    15a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15ab:	89 d6                	mov    %edx,%esi
    15ad:	89 c7                	mov    %eax,%edi
    15af:	48 b8 e1 14 00 00 00 	movabs $0x14e1,%rax
    15b6:	00 00 00 
    15b9:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15bf:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15c6:	83 f8 07             	cmp    $0x7,%eax
    15c9:	76 c2                	jbe    158d <print_x32+0x1b>
}
    15cb:	90                   	nop
    15cc:	90                   	nop
    15cd:	c9                   	leaveq 
    15ce:	c3                   	retq   

00000000000015cf <print_d>:

  static void
print_d(int fd, int v)
{
    15cf:	f3 0f 1e fa          	endbr64 
    15d3:	55                   	push   %rbp
    15d4:	48 89 e5             	mov    %rsp,%rbp
    15d7:	48 83 ec 30          	sub    $0x30,%rsp
    15db:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15de:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    15e1:	8b 45 d8             	mov    -0x28(%rbp),%eax
    15e4:	48 98                	cltq   
    15e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    15ea:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    15ee:	79 04                	jns    15f4 <print_d+0x25>
    x = -x;
    15f0:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    15f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    15fb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15ff:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1606:	66 66 66 
    1609:	48 89 c8             	mov    %rcx,%rax
    160c:	48 f7 ea             	imul   %rdx
    160f:	48 c1 fa 02          	sar    $0x2,%rdx
    1613:	48 89 c8             	mov    %rcx,%rax
    1616:	48 c1 f8 3f          	sar    $0x3f,%rax
    161a:	48 29 c2             	sub    %rax,%rdx
    161d:	48 89 d0             	mov    %rdx,%rax
    1620:	48 c1 e0 02          	shl    $0x2,%rax
    1624:	48 01 d0             	add    %rdx,%rax
    1627:	48 01 c0             	add    %rax,%rax
    162a:	48 29 c1             	sub    %rax,%rcx
    162d:	48 89 ca             	mov    %rcx,%rdx
    1630:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1633:	8d 48 01             	lea    0x1(%rax),%ecx
    1636:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1639:	48 b9 f0 25 00 00 00 	movabs $0x25f0,%rcx
    1640:	00 00 00 
    1643:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1647:	48 98                	cltq   
    1649:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    164d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1651:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1658:	66 66 66 
    165b:	48 89 c8             	mov    %rcx,%rax
    165e:	48 f7 ea             	imul   %rdx
    1661:	48 c1 fa 02          	sar    $0x2,%rdx
    1665:	48 89 c8             	mov    %rcx,%rax
    1668:	48 c1 f8 3f          	sar    $0x3f,%rax
    166c:	48 29 c2             	sub    %rax,%rdx
    166f:	48 89 d0             	mov    %rdx,%rax
    1672:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1676:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    167b:	0f 85 7a ff ff ff    	jne    15fb <print_d+0x2c>

  if (v < 0)
    1681:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1685:	79 32                	jns    16b9 <print_d+0xea>
    buf[i++] = '-';
    1687:	8b 45 f4             	mov    -0xc(%rbp),%eax
    168a:	8d 50 01             	lea    0x1(%rax),%edx
    168d:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1690:	48 98                	cltq   
    1692:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1697:	eb 20                	jmp    16b9 <print_d+0xea>
    putc(fd, buf[i]);
    1699:	8b 45 f4             	mov    -0xc(%rbp),%eax
    169c:	48 98                	cltq   
    169e:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16a3:	0f be d0             	movsbl %al,%edx
    16a6:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16a9:	89 d6                	mov    %edx,%esi
    16ab:	89 c7                	mov    %eax,%edi
    16ad:	48 b8 e1 14 00 00 00 	movabs $0x14e1,%rax
    16b4:	00 00 00 
    16b7:	ff d0                	callq  *%rax
  while (--i >= 0)
    16b9:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16c1:	79 d6                	jns    1699 <print_d+0xca>
}
    16c3:	90                   	nop
    16c4:	90                   	nop
    16c5:	c9                   	leaveq 
    16c6:	c3                   	retq   

00000000000016c7 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16c7:	f3 0f 1e fa          	endbr64 
    16cb:	55                   	push   %rbp
    16cc:	48 89 e5             	mov    %rsp,%rbp
    16cf:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16d6:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16dc:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    16e3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    16ea:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    16f1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    16f8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    16ff:	84 c0                	test   %al,%al
    1701:	74 20                	je     1723 <printf+0x5c>
    1703:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1707:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    170b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    170f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1713:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1717:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    171b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    171f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1723:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    172a:	00 00 00 
    172d:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1734:	00 00 00 
    1737:	48 8d 45 10          	lea    0x10(%rbp),%rax
    173b:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1742:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1749:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1750:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1757:	00 00 00 
    175a:	e9 41 03 00 00       	jmpq   1aa0 <printf+0x3d9>
    if (c != '%') {
    175f:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1766:	74 24                	je     178c <printf+0xc5>
      putc(fd, c);
    1768:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    176e:	0f be d0             	movsbl %al,%edx
    1771:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1777:	89 d6                	mov    %edx,%esi
    1779:	89 c7                	mov    %eax,%edi
    177b:	48 b8 e1 14 00 00 00 	movabs $0x14e1,%rax
    1782:	00 00 00 
    1785:	ff d0                	callq  *%rax
      continue;
    1787:	e9 0d 03 00 00       	jmpq   1a99 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    178c:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1793:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1799:	48 63 d0             	movslq %eax,%rdx
    179c:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17a3:	48 01 d0             	add    %rdx,%rax
    17a6:	0f b6 00             	movzbl (%rax),%eax
    17a9:	0f be c0             	movsbl %al,%eax
    17ac:	25 ff 00 00 00       	and    $0xff,%eax
    17b1:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17b7:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17be:	0f 84 0f 03 00 00    	je     1ad3 <printf+0x40c>
      break;
    switch(c) {
    17c4:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17cb:	0f 84 74 02 00 00    	je     1a45 <printf+0x37e>
    17d1:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17d8:	0f 8c 82 02 00 00    	jl     1a60 <printf+0x399>
    17de:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17e5:	0f 8f 75 02 00 00    	jg     1a60 <printf+0x399>
    17eb:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    17f2:	0f 8c 68 02 00 00    	jl     1a60 <printf+0x399>
    17f8:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    17fe:	83 e8 63             	sub    $0x63,%eax
    1801:	83 f8 15             	cmp    $0x15,%eax
    1804:	0f 87 56 02 00 00    	ja     1a60 <printf+0x399>
    180a:	89 c0                	mov    %eax,%eax
    180c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1813:	00 
    1814:	48 b8 00 22 00 00 00 	movabs $0x2200,%rax
    181b:	00 00 00 
    181e:	48 01 d0             	add    %rdx,%rax
    1821:	48 8b 00             	mov    (%rax),%rax
    1824:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1827:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    182d:	83 f8 2f             	cmp    $0x2f,%eax
    1830:	77 23                	ja     1855 <printf+0x18e>
    1832:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1839:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    183f:	89 d2                	mov    %edx,%edx
    1841:	48 01 d0             	add    %rdx,%rax
    1844:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    184a:	83 c2 08             	add    $0x8,%edx
    184d:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1853:	eb 12                	jmp    1867 <printf+0x1a0>
    1855:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    185c:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1860:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1867:	8b 00                	mov    (%rax),%eax
    1869:	0f be d0             	movsbl %al,%edx
    186c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1872:	89 d6                	mov    %edx,%esi
    1874:	89 c7                	mov    %eax,%edi
    1876:	48 b8 e1 14 00 00 00 	movabs $0x14e1,%rax
    187d:	00 00 00 
    1880:	ff d0                	callq  *%rax
      break;
    1882:	e9 12 02 00 00       	jmpq   1a99 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1887:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    188d:	83 f8 2f             	cmp    $0x2f,%eax
    1890:	77 23                	ja     18b5 <printf+0x1ee>
    1892:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1899:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    189f:	89 d2                	mov    %edx,%edx
    18a1:	48 01 d0             	add    %rdx,%rax
    18a4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18aa:	83 c2 08             	add    $0x8,%edx
    18ad:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18b3:	eb 12                	jmp    18c7 <printf+0x200>
    18b5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18bc:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18c0:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18c7:	8b 10                	mov    (%rax),%edx
    18c9:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18cf:	89 d6                	mov    %edx,%esi
    18d1:	89 c7                	mov    %eax,%edi
    18d3:	48 b8 cf 15 00 00 00 	movabs $0x15cf,%rax
    18da:	00 00 00 
    18dd:	ff d0                	callq  *%rax
      break;
    18df:	e9 b5 01 00 00       	jmpq   1a99 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    18e4:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18ea:	83 f8 2f             	cmp    $0x2f,%eax
    18ed:	77 23                	ja     1912 <printf+0x24b>
    18ef:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18f6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18fc:	89 d2                	mov    %edx,%edx
    18fe:	48 01 d0             	add    %rdx,%rax
    1901:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1907:	83 c2 08             	add    $0x8,%edx
    190a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1910:	eb 12                	jmp    1924 <printf+0x25d>
    1912:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1919:	48 8d 50 08          	lea    0x8(%rax),%rdx
    191d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1924:	8b 10                	mov    (%rax),%edx
    1926:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    192c:	89 d6                	mov    %edx,%esi
    192e:	89 c7                	mov    %eax,%edi
    1930:	48 b8 72 15 00 00 00 	movabs $0x1572,%rax
    1937:	00 00 00 
    193a:	ff d0                	callq  *%rax
      break;
    193c:	e9 58 01 00 00       	jmpq   1a99 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1941:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1947:	83 f8 2f             	cmp    $0x2f,%eax
    194a:	77 23                	ja     196f <printf+0x2a8>
    194c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1953:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1959:	89 d2                	mov    %edx,%edx
    195b:	48 01 d0             	add    %rdx,%rax
    195e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1964:	83 c2 08             	add    $0x8,%edx
    1967:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    196d:	eb 12                	jmp    1981 <printf+0x2ba>
    196f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1976:	48 8d 50 08          	lea    0x8(%rax),%rdx
    197a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1981:	48 8b 10             	mov    (%rax),%rdx
    1984:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    198a:	48 89 d6             	mov    %rdx,%rsi
    198d:	89 c7                	mov    %eax,%edi
    198f:	48 b8 15 15 00 00 00 	movabs $0x1515,%rax
    1996:	00 00 00 
    1999:	ff d0                	callq  *%rax
      break;
    199b:	e9 f9 00 00 00       	jmpq   1a99 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19a0:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19a6:	83 f8 2f             	cmp    $0x2f,%eax
    19a9:	77 23                	ja     19ce <printf+0x307>
    19ab:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19b2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19b8:	89 d2                	mov    %edx,%edx
    19ba:	48 01 d0             	add    %rdx,%rax
    19bd:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19c3:	83 c2 08             	add    $0x8,%edx
    19c6:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19cc:	eb 12                	jmp    19e0 <printf+0x319>
    19ce:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19d5:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19d9:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19e0:	48 8b 00             	mov    (%rax),%rax
    19e3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    19ea:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    19f1:	00 
    19f2:	75 41                	jne    1a35 <printf+0x36e>
        s = "(null)";
    19f4:	48 b8 f8 21 00 00 00 	movabs $0x21f8,%rax
    19fb:	00 00 00 
    19fe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a05:	eb 2e                	jmp    1a35 <printf+0x36e>
        putc(fd, *(s++));
    1a07:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a0e:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a12:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a19:	0f b6 00             	movzbl (%rax),%eax
    1a1c:	0f be d0             	movsbl %al,%edx
    1a1f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a25:	89 d6                	mov    %edx,%esi
    1a27:	89 c7                	mov    %eax,%edi
    1a29:	48 b8 e1 14 00 00 00 	movabs $0x14e1,%rax
    1a30:	00 00 00 
    1a33:	ff d0                	callq  *%rax
      while (*s)
    1a35:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a3c:	0f b6 00             	movzbl (%rax),%eax
    1a3f:	84 c0                	test   %al,%al
    1a41:	75 c4                	jne    1a07 <printf+0x340>
      break;
    1a43:	eb 54                	jmp    1a99 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a45:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a4b:	be 25 00 00 00       	mov    $0x25,%esi
    1a50:	89 c7                	mov    %eax,%edi
    1a52:	48 b8 e1 14 00 00 00 	movabs $0x14e1,%rax
    1a59:	00 00 00 
    1a5c:	ff d0                	callq  *%rax
      break;
    1a5e:	eb 39                	jmp    1a99 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a60:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a66:	be 25 00 00 00       	mov    $0x25,%esi
    1a6b:	89 c7                	mov    %eax,%edi
    1a6d:	48 b8 e1 14 00 00 00 	movabs $0x14e1,%rax
    1a74:	00 00 00 
    1a77:	ff d0                	callq  *%rax
      putc(fd, c);
    1a79:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a7f:	0f be d0             	movsbl %al,%edx
    1a82:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a88:	89 d6                	mov    %edx,%esi
    1a8a:	89 c7                	mov    %eax,%edi
    1a8c:	48 b8 e1 14 00 00 00 	movabs $0x14e1,%rax
    1a93:	00 00 00 
    1a96:	ff d0                	callq  *%rax
      break;
    1a98:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1a99:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1aa0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1aa6:	48 63 d0             	movslq %eax,%rdx
    1aa9:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ab0:	48 01 d0             	add    %rdx,%rax
    1ab3:	0f b6 00             	movzbl (%rax),%eax
    1ab6:	0f be c0             	movsbl %al,%eax
    1ab9:	25 ff 00 00 00       	and    $0xff,%eax
    1abe:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ac4:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1acb:	0f 85 8e fc ff ff    	jne    175f <printf+0x98>
    }
  }
}
    1ad1:	eb 01                	jmp    1ad4 <printf+0x40d>
      break;
    1ad3:	90                   	nop
}
    1ad4:	90                   	nop
    1ad5:	c9                   	leaveq 
    1ad6:	c3                   	retq   

0000000000001ad7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ad7:	f3 0f 1e fa          	endbr64 
    1adb:	55                   	push   %rbp
    1adc:	48 89 e5             	mov    %rsp,%rbp
    1adf:	48 83 ec 18          	sub    $0x18,%rsp
    1ae3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1aeb:	48 83 e8 10          	sub    $0x10,%rax
    1aef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1af3:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    1afa:	00 00 00 
    1afd:	48 8b 00             	mov    (%rax),%rax
    1b00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b04:	eb 2f                	jmp    1b35 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b0a:	48 8b 00             	mov    (%rax),%rax
    1b0d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b11:	72 17                	jb     1b2a <free+0x53>
    1b13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b17:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b1b:	77 2f                	ja     1b4c <free+0x75>
    1b1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b21:	48 8b 00             	mov    (%rax),%rax
    1b24:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b28:	72 22                	jb     1b4c <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b2e:	48 8b 00             	mov    (%rax),%rax
    1b31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b39:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b3d:	76 c7                	jbe    1b06 <free+0x2f>
    1b3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b43:	48 8b 00             	mov    (%rax),%rax
    1b46:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b4a:	73 ba                	jae    1b06 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b50:	8b 40 08             	mov    0x8(%rax),%eax
    1b53:	89 c0                	mov    %eax,%eax
    1b55:	48 c1 e0 04          	shl    $0x4,%rax
    1b59:	48 89 c2             	mov    %rax,%rdx
    1b5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b60:	48 01 c2             	add    %rax,%rdx
    1b63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b67:	48 8b 00             	mov    (%rax),%rax
    1b6a:	48 39 c2             	cmp    %rax,%rdx
    1b6d:	75 2d                	jne    1b9c <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1b6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b73:	8b 50 08             	mov    0x8(%rax),%edx
    1b76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b7a:	48 8b 00             	mov    (%rax),%rax
    1b7d:	8b 40 08             	mov    0x8(%rax),%eax
    1b80:	01 c2                	add    %eax,%edx
    1b82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b86:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b8d:	48 8b 00             	mov    (%rax),%rax
    1b90:	48 8b 10             	mov    (%rax),%rdx
    1b93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b97:	48 89 10             	mov    %rdx,(%rax)
    1b9a:	eb 0e                	jmp    1baa <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1b9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba0:	48 8b 10             	mov    (%rax),%rdx
    1ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba7:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1baa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bae:	8b 40 08             	mov    0x8(%rax),%eax
    1bb1:	89 c0                	mov    %eax,%eax
    1bb3:	48 c1 e0 04          	shl    $0x4,%rax
    1bb7:	48 89 c2             	mov    %rax,%rdx
    1bba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bbe:	48 01 d0             	add    %rdx,%rax
    1bc1:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bc5:	75 27                	jne    1bee <free+0x117>
    p->s.size += bp->s.size;
    1bc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bcb:	8b 50 08             	mov    0x8(%rax),%edx
    1bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd2:	8b 40 08             	mov    0x8(%rax),%eax
    1bd5:	01 c2                	add    %eax,%edx
    1bd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bdb:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1bde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1be2:	48 8b 10             	mov    (%rax),%rdx
    1be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be9:	48 89 10             	mov    %rdx,(%rax)
    1bec:	eb 0b                	jmp    1bf9 <free+0x122>
  } else
    p->s.ptr = bp;
    1bee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1bf6:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1bf9:	48 ba 20 26 00 00 00 	movabs $0x2620,%rdx
    1c00:	00 00 00 
    1c03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c07:	48 89 02             	mov    %rax,(%rdx)
}
    1c0a:	90                   	nop
    1c0b:	c9                   	leaveq 
    1c0c:	c3                   	retq   

0000000000001c0d <morecore>:

static Header*
morecore(uint nu)
{
    1c0d:	f3 0f 1e fa          	endbr64 
    1c11:	55                   	push   %rbp
    1c12:	48 89 e5             	mov    %rsp,%rbp
    1c15:	48 83 ec 20          	sub    $0x20,%rsp
    1c19:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c1c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c23:	77 07                	ja     1c2c <morecore+0x1f>
    nu = 4096;
    1c25:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c2f:	48 c1 e0 04          	shl    $0x4,%rax
    1c33:	48 89 c7             	mov    %rax,%rdi
    1c36:	48 b8 ba 14 00 00 00 	movabs $0x14ba,%rax
    1c3d:	00 00 00 
    1c40:	ff d0                	callq  *%rax
    1c42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c46:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c4b:	75 07                	jne    1c54 <morecore+0x47>
    return 0;
    1c4d:	b8 00 00 00 00       	mov    $0x0,%eax
    1c52:	eb 36                	jmp    1c8a <morecore+0x7d>
  hp = (Header*)p;
    1c54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c60:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c63:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c6a:	48 83 c0 10          	add    $0x10,%rax
    1c6e:	48 89 c7             	mov    %rax,%rdi
    1c71:	48 b8 d7 1a 00 00 00 	movabs $0x1ad7,%rax
    1c78:	00 00 00 
    1c7b:	ff d0                	callq  *%rax
  return freep;
    1c7d:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    1c84:	00 00 00 
    1c87:	48 8b 00             	mov    (%rax),%rax
}
    1c8a:	c9                   	leaveq 
    1c8b:	c3                   	retq   

0000000000001c8c <malloc>:

void*
malloc(uint nbytes)
{
    1c8c:	f3 0f 1e fa          	endbr64 
    1c90:	55                   	push   %rbp
    1c91:	48 89 e5             	mov    %rsp,%rbp
    1c94:	48 83 ec 30          	sub    $0x30,%rsp
    1c98:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c9b:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1c9e:	48 83 c0 0f          	add    $0xf,%rax
    1ca2:	48 c1 e8 04          	shr    $0x4,%rax
    1ca6:	83 c0 01             	add    $0x1,%eax
    1ca9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cac:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    1cb3:	00 00 00 
    1cb6:	48 8b 00             	mov    (%rax),%rax
    1cb9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cbd:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cc2:	75 4a                	jne    1d0e <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1cc4:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    1ccb:	00 00 00 
    1cce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cd2:	48 ba 20 26 00 00 00 	movabs $0x2620,%rdx
    1cd9:	00 00 00 
    1cdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce0:	48 89 02             	mov    %rax,(%rdx)
    1ce3:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    1cea:	00 00 00 
    1ced:	48 8b 00             	mov    (%rax),%rax
    1cf0:	48 ba 10 26 00 00 00 	movabs $0x2610,%rdx
    1cf7:	00 00 00 
    1cfa:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1cfd:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    1d04:	00 00 00 
    1d07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d12:	48 8b 00             	mov    (%rax),%rax
    1d15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d1d:	8b 40 08             	mov    0x8(%rax),%eax
    1d20:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d23:	77 65                	ja     1d8a <malloc+0xfe>
      if(p->s.size == nunits)
    1d25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d29:	8b 40 08             	mov    0x8(%rax),%eax
    1d2c:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d2f:	75 10                	jne    1d41 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d35:	48 8b 10             	mov    (%rax),%rdx
    1d38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d3c:	48 89 10             	mov    %rdx,(%rax)
    1d3f:	eb 2e                	jmp    1d6f <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d45:	8b 40 08             	mov    0x8(%rax),%eax
    1d48:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d4b:	89 c2                	mov    %eax,%edx
    1d4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d51:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d58:	8b 40 08             	mov    0x8(%rax),%eax
    1d5b:	89 c0                	mov    %eax,%eax
    1d5d:	48 c1 e0 04          	shl    $0x4,%rax
    1d61:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d69:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d6c:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d6f:	48 ba 20 26 00 00 00 	movabs $0x2620,%rdx
    1d76:	00 00 00 
    1d79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d7d:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d84:	48 83 c0 10          	add    $0x10,%rax
    1d88:	eb 4e                	jmp    1dd8 <malloc+0x14c>
    }
    if(p == freep)
    1d8a:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    1d91:	00 00 00 
    1d94:	48 8b 00             	mov    (%rax),%rax
    1d97:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d9b:	75 23                	jne    1dc0 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1d9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1da0:	89 c7                	mov    %eax,%edi
    1da2:	48 b8 0d 1c 00 00 00 	movabs $0x1c0d,%rax
    1da9:	00 00 00 
    1dac:	ff d0                	callq  *%rax
    1dae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1db2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1db7:	75 07                	jne    1dc0 <malloc+0x134>
        return 0;
    1db9:	b8 00 00 00 00       	mov    $0x0,%eax
    1dbe:	eb 18                	jmp    1dd8 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dcc:	48 8b 00             	mov    (%rax),%rax
    1dcf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1dd3:	e9 41 ff ff ff       	jmpq   1d19 <malloc+0x8d>
  }
}
    1dd8:	c9                   	leaveq 
    1dd9:	c3                   	retq   

0000000000001dda <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1dda:	f3 0f 1e fa          	endbr64 
    1dde:	55                   	push   %rbp
    1ddf:	48 89 e5             	mov    %rsp,%rbp
    1de2:	48 83 ec 30          	sub    $0x30,%rsp
    1de6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1dea:	bf 18 00 00 00       	mov    $0x18,%edi
    1def:	48 b8 8c 1c 00 00 00 	movabs $0x1c8c,%rax
    1df6:	00 00 00 
    1df9:	ff d0                	callq  *%rax
    1dfb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1dff:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1e04:	75 0a                	jne    1e10 <co_new+0x36>
    return 0;
    1e06:	b8 00 00 00 00       	mov    $0x0,%eax
    1e0b:	e9 e1 00 00 00       	jmpq   1ef1 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1e10:	bf 00 20 00 00       	mov    $0x2000,%edi
    1e15:	48 b8 8c 1c 00 00 00 	movabs $0x1c8c,%rax
    1e1c:	00 00 00 
    1e1f:	ff d0                	callq  *%rax
    1e21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1e25:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e2d:	48 8b 40 10          	mov    0x10(%rax),%rax
    1e31:	48 85 c0             	test   %rax,%rax
    1e34:	75 1d                	jne    1e53 <co_new+0x79>
    free(co1);
    1e36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e3a:	48 89 c7             	mov    %rax,%rdi
    1e3d:	48 b8 d7 1a 00 00 00 	movabs $0x1ad7,%rax
    1e44:	00 00 00 
    1e47:	ff d0                	callq  *%rax
    return 0;
    1e49:	b8 00 00 00 00       	mov    $0x0,%eax
    1e4e:	e9 9e 00 00 00       	jmpq   1ef1 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e57:	48 8b 40 10          	mov    0x10(%rax),%rax
    1e5b:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    1e61:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    1e65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e69:	48 8d 50 30          	lea    0x30(%rax),%rdx
    1e6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1e71:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    1e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e78:	48 83 c0 38          	add    $0x38,%rax
    1e7c:	48 ba 63 20 00 00 00 	movabs $0x2063,%rdx
    1e83:	00 00 00 
    1e86:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    1e89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1e91:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    1e94:	48 b8 38 26 00 00 00 	movabs $0x2638,%rax
    1e9b:	00 00 00 
    1e9e:	48 8b 00             	mov    (%rax),%rax
    1ea1:	48 85 c0             	test   %rax,%rax
    1ea4:	75 13                	jne    1eb9 <co_new+0xdf>
  {
  	co_list = co1;
    1ea6:	48 ba 38 26 00 00 00 	movabs $0x2638,%rdx
    1ead:	00 00 00 
    1eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1eb4:	48 89 02             	mov    %rax,(%rdx)
    1eb7:	eb 34                	jmp    1eed <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    1eb9:	48 b8 38 26 00 00 00 	movabs $0x2638,%rax
    1ec0:	00 00 00 
    1ec3:	48 8b 00             	mov    (%rax),%rax
    1ec6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1eca:	eb 0c                	jmp    1ed8 <co_new+0xfe>
	{
		head = head->next;
    1ecc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ed0:	48 8b 40 08          	mov    0x8(%rax),%rax
    1ed4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1ed8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1edc:	48 8b 40 08          	mov    0x8(%rax),%rax
    1ee0:	48 85 c0             	test   %rax,%rax
    1ee3:	75 e7                	jne    1ecc <co_new+0xf2>
	}
	head = co1;
    1ee5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ee9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    1eed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    1ef1:	c9                   	leaveq 
    1ef2:	c3                   	retq   

0000000000001ef3 <co_run>:

  int
co_run(void)
{
    1ef3:	f3 0f 1e fa          	endbr64 
    1ef7:	55                   	push   %rbp
    1ef8:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    1efb:	48 b8 38 26 00 00 00 	movabs $0x2638,%rax
    1f02:	00 00 00 
    1f05:	48 8b 00             	mov    (%rax),%rax
    1f08:	48 85 c0             	test   %rax,%rax
    1f0b:	74 4a                	je     1f57 <co_run+0x64>
	{
		co_current = co_list;
    1f0d:	48 b8 38 26 00 00 00 	movabs $0x2638,%rax
    1f14:	00 00 00 
    1f17:	48 8b 00             	mov    (%rax),%rax
    1f1a:	48 ba 30 26 00 00 00 	movabs $0x2630,%rdx
    1f21:	00 00 00 
    1f24:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    1f27:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    1f2e:	00 00 00 
    1f31:	48 8b 00             	mov    (%rax),%rax
    1f34:	48 8b 00             	mov    (%rax),%rax
    1f37:	48 89 c6             	mov    %rax,%rsi
    1f3a:	48 bf 28 26 00 00 00 	movabs $0x2628,%rdi
    1f41:	00 00 00 
    1f44:	48 b8 c5 21 00 00 00 	movabs $0x21c5,%rax
    1f4b:	00 00 00 
    1f4e:	ff d0                	callq  *%rax
		return 1;
    1f50:	b8 01 00 00 00       	mov    $0x1,%eax
    1f55:	eb 05                	jmp    1f5c <co_run+0x69>
	}
	return 0;
    1f57:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1f5c:	5d                   	pop    %rbp
    1f5d:	c3                   	retq   

0000000000001f5e <co_run_all>:

  int
co_run_all(void)
{
    1f5e:	f3 0f 1e fa          	endbr64 
    1f62:	55                   	push   %rbp
    1f63:	48 89 e5             	mov    %rsp,%rbp
    1f66:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    1f6a:	48 b8 38 26 00 00 00 	movabs $0x2638,%rax
    1f71:	00 00 00 
    1f74:	48 8b 00             	mov    (%rax),%rax
    1f77:	48 85 c0             	test   %rax,%rax
    1f7a:	75 07                	jne    1f83 <co_run_all+0x25>
		return 0;
    1f7c:	b8 00 00 00 00       	mov    $0x0,%eax
    1f81:	eb 37                	jmp    1fba <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    1f83:	48 b8 38 26 00 00 00 	movabs $0x2638,%rax
    1f8a:	00 00 00 
    1f8d:	48 8b 00             	mov    (%rax),%rax
    1f90:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    1f94:	eb 18                	jmp    1fae <co_run_all+0x50>
			co_run();
    1f96:	48 b8 f3 1e 00 00 00 	movabs $0x1ef3,%rax
    1f9d:	00 00 00 
    1fa0:	ff d0                	callq  *%rax
			tmp = tmp->next;
    1fa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fa6:	48 8b 40 08          	mov    0x8(%rax),%rax
    1faa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    1fae:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1fb3:	75 e1                	jne    1f96 <co_run_all+0x38>
		}
		return 1;
    1fb5:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    1fba:	c9                   	leaveq 
    1fbb:	c3                   	retq   

0000000000001fbc <co_yield>:

  void
co_yield()
{
    1fbc:	f3 0f 1e fa          	endbr64 
    1fc0:	55                   	push   %rbp
    1fc1:	48 89 e5             	mov    %rsp,%rbp
    1fc4:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    1fc8:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    1fcf:	00 00 00 
    1fd2:	48 8b 00             	mov    (%rax),%rax
    1fd5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    1fd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fdd:	48 8b 40 08          	mov    0x8(%rax),%rax
    1fe1:	48 85 c0             	test   %rax,%rax
    1fe4:	74 46                	je     202c <co_yield+0x70>
  {
  	co_current = co_current->next;
    1fe6:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    1fed:	00 00 00 
    1ff0:	48 8b 00             	mov    (%rax),%rax
    1ff3:	48 8b 40 08          	mov    0x8(%rax),%rax
    1ff7:	48 ba 30 26 00 00 00 	movabs $0x2630,%rdx
    1ffe:	00 00 00 
    2001:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    2004:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    200b:	00 00 00 
    200e:	48 8b 00             	mov    (%rax),%rax
    2011:	48 8b 10             	mov    (%rax),%rdx
    2014:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2018:	48 89 d6             	mov    %rdx,%rsi
    201b:	48 89 c7             	mov    %rax,%rdi
    201e:	48 b8 c5 21 00 00 00 	movabs $0x21c5,%rax
    2025:	00 00 00 
    2028:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    202a:	eb 34                	jmp    2060 <co_yield+0xa4>
	co_current = 0;
    202c:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    2033:	00 00 00 
    2036:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    203d:	48 b8 28 26 00 00 00 	movabs $0x2628,%rax
    2044:	00 00 00 
    2047:	48 8b 10             	mov    (%rax),%rdx
    204a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    204e:	48 89 d6             	mov    %rdx,%rsi
    2051:	48 89 c7             	mov    %rax,%rdi
    2054:	48 b8 c5 21 00 00 00 	movabs $0x21c5,%rax
    205b:	00 00 00 
    205e:	ff d0                	callq  *%rax
}
    2060:	90                   	nop
    2061:	c9                   	leaveq 
    2062:	c3                   	retq   

0000000000002063 <co_exit>:

  void
co_exit(void)
{
    2063:	f3 0f 1e fa          	endbr64 
    2067:	55                   	push   %rbp
    2068:	48 89 e5             	mov    %rsp,%rbp
    206b:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    206f:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    2076:	00 00 00 
    2079:	48 8b 00             	mov    (%rax),%rax
    207c:	48 85 c0             	test   %rax,%rax
    207f:	0f 84 ec 00 00 00    	je     2171 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    2085:	48 b8 38 26 00 00 00 	movabs $0x2638,%rax
    208c:	00 00 00 
    208f:	48 8b 00             	mov    (%rax),%rax
    2092:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    2096:	e9 c9 00 00 00       	jmpq   2164 <co_exit+0x101>
		if(tmp == co_current)
    209b:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    20a2:	00 00 00 
    20a5:	48 8b 00             	mov    (%rax),%rax
    20a8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    20ac:	0f 85 9e 00 00 00    	jne    2150 <co_exit+0xed>
		{
			if(tmp->next)
    20b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20b6:	48 8b 40 08          	mov    0x8(%rax),%rax
    20ba:	48 85 c0             	test   %rax,%rax
    20bd:	74 54                	je     2113 <co_exit+0xb0>
			{
				if(prev)
    20bf:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20c4:	74 10                	je     20d6 <co_exit+0x73>
				{
					prev->next = tmp->next;
    20c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20ca:	48 8b 50 08          	mov    0x8(%rax),%rdx
    20ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20d2:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    20d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20da:	48 8b 40 08          	mov    0x8(%rax),%rax
    20de:	48 ba 38 26 00 00 00 	movabs $0x2638,%rdx
    20e5:	00 00 00 
    20e8:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    20eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20ef:	48 8b 00             	mov    (%rax),%rax
    20f2:	48 ba 30 26 00 00 00 	movabs $0x2630,%rdx
    20f9:	00 00 00 
    20fc:	48 8b 12             	mov    (%rdx),%rdx
    20ff:	48 89 c6             	mov    %rax,%rsi
    2102:	48 89 d7             	mov    %rdx,%rdi
    2105:	48 b8 c5 21 00 00 00 	movabs $0x21c5,%rax
    210c:	00 00 00 
    210f:	ff d0                	callq  *%rax
    2111:	eb 3d                	jmp    2150 <co_exit+0xed>
			}else{
				co_list = 0;
    2113:	48 b8 38 26 00 00 00 	movabs $0x2638,%rax
    211a:	00 00 00 
    211d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    2124:	48 b8 28 26 00 00 00 	movabs $0x2628,%rax
    212b:	00 00 00 
    212e:	48 8b 00             	mov    (%rax),%rax
    2131:	48 ba 30 26 00 00 00 	movabs $0x2630,%rdx
    2138:	00 00 00 
    213b:	48 8b 12             	mov    (%rdx),%rdx
    213e:	48 89 c6             	mov    %rax,%rsi
    2141:	48 89 d7             	mov    %rdx,%rdi
    2144:	48 b8 c5 21 00 00 00 	movabs $0x21c5,%rax
    214b:	00 00 00 
    214e:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    2150:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2154:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    2158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    215c:	48 8b 40 08          	mov    0x8(%rax),%rax
    2160:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    2164:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2169:	0f 85 2c ff ff ff    	jne    209b <co_exit+0x38>
    216f:	eb 01                	jmp    2172 <co_exit+0x10f>
		return;
    2171:	90                   	nop
	}
}
    2172:	c9                   	leaveq 
    2173:	c3                   	retq   

0000000000002174 <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    2174:	f3 0f 1e fa          	endbr64 
    2178:	55                   	push   %rbp
    2179:	48 89 e5             	mov    %rsp,%rbp
    217c:	48 83 ec 10          	sub    $0x10,%rsp
    2180:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    2184:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2189:	74 37                	je     21c2 <co_destroy+0x4e>
    if (co->stack)
    218b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    218f:	48 8b 40 10          	mov    0x10(%rax),%rax
    2193:	48 85 c0             	test   %rax,%rax
    2196:	74 17                	je     21af <co_destroy+0x3b>
      free(co->stack);
    2198:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    219c:	48 8b 40 10          	mov    0x10(%rax),%rax
    21a0:	48 89 c7             	mov    %rax,%rdi
    21a3:	48 b8 d7 1a 00 00 00 	movabs $0x1ad7,%rax
    21aa:	00 00 00 
    21ad:	ff d0                	callq  *%rax
    free(co);
    21af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21b3:	48 89 c7             	mov    %rax,%rdi
    21b6:	48 b8 d7 1a 00 00 00 	movabs $0x1ad7,%rax
    21bd:	00 00 00 
    21c0:	ff d0                	callq  *%rax
  }
}
    21c2:	90                   	nop
    21c3:	c9                   	leaveq 
    21c4:	c3                   	retq   

00000000000021c5 <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    21c5:	55                   	push   %rbp
  pushq   %rbx
    21c6:	53                   	push   %rbx
  pushq   %r12
    21c7:	41 54                	push   %r12
  pushq   %r13
    21c9:	41 55                	push   %r13
  pushq   %r14
    21cb:	41 56                	push   %r14
  pushq   %r15
    21cd:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    21cf:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    21d2:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    21d5:	41 5f                	pop    %r15
  popq    %r14
    21d7:	41 5e                	pop    %r14
  popq    %r13
    21d9:	41 5d                	pop    %r13
  popq    %r12
    21db:	41 5c                	pop    %r12
  popq    %rbx
    21dd:	5b                   	pop    %rbx
  popq    %rbp
    21de:	5d                   	pop    %rbp

  retq #??
    21df:	c3                   	retq   
