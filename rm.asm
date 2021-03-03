
_rm:     file format elf64-x86-64


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
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  if(argc < 2){
    1013:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1017:	7f 2c                	jg     1045 <main+0x45>
    printf(2, "Usage: rm files...\n");
    1019:	48 be 18 22 00 00 00 	movabs $0x2218,%rsi
    1020:	00 00 00 
    1023:	bf 02 00 00 00       	mov    $0x2,%edi
    1028:	b8 00 00 00 00       	mov    $0x0,%eax
    102d:	48 ba f9 16 00 00 00 	movabs $0x16f9,%rdx
    1034:	00 00 00 
    1037:	ff d2                	callq  *%rdx
    exit();
    1039:	48 b8 0f 14 00 00 00 	movabs $0x140f,%rax
    1040:	00 00 00 
    1043:	ff d0                	callq  *%rax
  }

  for(i = 1; i < argc; i++){
    1045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    104c:	eb 6a                	jmp    10b8 <main+0xb8>
    if(unlink(argv[i]) < 0){
    104e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1051:	48 98                	cltq   
    1053:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    105a:	00 
    105b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    105f:	48 01 d0             	add    %rdx,%rax
    1062:	48 8b 00             	mov    (%rax),%rax
    1065:	48 89 c7             	mov    %rax,%rdi
    1068:	48 b8 91 14 00 00 00 	movabs $0x1491,%rax
    106f:	00 00 00 
    1072:	ff d0                	callq  *%rax
    1074:	85 c0                	test   %eax,%eax
    1076:	79 3c                	jns    10b4 <main+0xb4>
      printf(2, "rm: %s failed to delete\n", argv[i]);
    1078:	8b 45 fc             	mov    -0x4(%rbp),%eax
    107b:	48 98                	cltq   
    107d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1084:	00 
    1085:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1089:	48 01 d0             	add    %rdx,%rax
    108c:	48 8b 00             	mov    (%rax),%rax
    108f:	48 89 c2             	mov    %rax,%rdx
    1092:	48 be 2c 22 00 00 00 	movabs $0x222c,%rsi
    1099:	00 00 00 
    109c:	bf 02 00 00 00       	mov    $0x2,%edi
    10a1:	b8 00 00 00 00       	mov    $0x0,%eax
    10a6:	48 b9 f9 16 00 00 00 	movabs $0x16f9,%rcx
    10ad:	00 00 00 
    10b0:	ff d1                	callq  *%rcx
      break;
    10b2:	eb 0c                	jmp    10c0 <main+0xc0>
  for(i = 1; i < argc; i++){
    10b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10bb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    10be:	7c 8e                	jl     104e <main+0x4e>
    }
  }

  exit();
    10c0:	48 b8 0f 14 00 00 00 	movabs $0x140f,%rax
    10c7:	00 00 00 
    10ca:	ff d0                	callq  *%rax

00000000000010cc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10cc:	f3 0f 1e fa          	endbr64 
    10d0:	55                   	push   %rbp
    10d1:	48 89 e5             	mov    %rsp,%rbp
    10d4:	48 83 ec 10          	sub    $0x10,%rsp
    10d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10dc:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10df:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10e2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10e6:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10ec:	48 89 ce             	mov    %rcx,%rsi
    10ef:	48 89 f7             	mov    %rsi,%rdi
    10f2:	89 d1                	mov    %edx,%ecx
    10f4:	fc                   	cld    
    10f5:	f3 aa                	rep stos %al,%es:(%rdi)
    10f7:	89 ca                	mov    %ecx,%edx
    10f9:	48 89 fe             	mov    %rdi,%rsi
    10fc:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1100:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1103:	90                   	nop
    1104:	c9                   	leaveq 
    1105:	c3                   	retq   

0000000000001106 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1106:	f3 0f 1e fa          	endbr64 
    110a:	55                   	push   %rbp
    110b:	48 89 e5             	mov    %rsp,%rbp
    110e:	48 83 ec 20          	sub    $0x20,%rsp
    1112:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1116:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    111e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1122:	90                   	nop
    1123:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1127:	48 8d 42 01          	lea    0x1(%rdx),%rax
    112b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    112f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1133:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1137:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    113b:	0f b6 12             	movzbl (%rdx),%edx
    113e:	88 10                	mov    %dl,(%rax)
    1140:	0f b6 00             	movzbl (%rax),%eax
    1143:	84 c0                	test   %al,%al
    1145:	75 dc                	jne    1123 <strcpy+0x1d>
    ;
  return os;
    1147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    114b:	c9                   	leaveq 
    114c:	c3                   	retq   

000000000000114d <strcmp>:

int
strcmp(const char *p, const char *q)
{
    114d:	f3 0f 1e fa          	endbr64 
    1151:	55                   	push   %rbp
    1152:	48 89 e5             	mov    %rsp,%rbp
    1155:	48 83 ec 10          	sub    $0x10,%rsp
    1159:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    115d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1161:	eb 0a                	jmp    116d <strcmp+0x20>
    p++, q++;
    1163:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1168:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    116d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1171:	0f b6 00             	movzbl (%rax),%eax
    1174:	84 c0                	test   %al,%al
    1176:	74 12                	je     118a <strcmp+0x3d>
    1178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    117c:	0f b6 10             	movzbl (%rax),%edx
    117f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1183:	0f b6 00             	movzbl (%rax),%eax
    1186:	38 c2                	cmp    %al,%dl
    1188:	74 d9                	je     1163 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    118a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    118e:	0f b6 00             	movzbl (%rax),%eax
    1191:	0f b6 d0             	movzbl %al,%edx
    1194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1198:	0f b6 00             	movzbl (%rax),%eax
    119b:	0f b6 c0             	movzbl %al,%eax
    119e:	29 c2                	sub    %eax,%edx
    11a0:	89 d0                	mov    %edx,%eax
}
    11a2:	c9                   	leaveq 
    11a3:	c3                   	retq   

00000000000011a4 <strlen>:

uint
strlen(char *s)
{
    11a4:	f3 0f 1e fa          	endbr64 
    11a8:	55                   	push   %rbp
    11a9:	48 89 e5             	mov    %rsp,%rbp
    11ac:	48 83 ec 18          	sub    $0x18,%rsp
    11b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    11b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11bb:	eb 04                	jmp    11c1 <strlen+0x1d>
    11bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11c4:	48 63 d0             	movslq %eax,%rdx
    11c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11cb:	48 01 d0             	add    %rdx,%rax
    11ce:	0f b6 00             	movzbl (%rax),%eax
    11d1:	84 c0                	test   %al,%al
    11d3:	75 e8                	jne    11bd <strlen+0x19>
    ;
  return n;
    11d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11d8:	c9                   	leaveq 
    11d9:	c3                   	retq   

00000000000011da <memset>:

void*
memset(void *dst, int c, uint n)
{
    11da:	f3 0f 1e fa          	endbr64 
    11de:	55                   	push   %rbp
    11df:	48 89 e5             	mov    %rsp,%rbp
    11e2:	48 83 ec 10          	sub    $0x10,%rsp
    11e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ea:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11ed:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11f0:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11f3:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11fa:	89 ce                	mov    %ecx,%esi
    11fc:	48 89 c7             	mov    %rax,%rdi
    11ff:	48 b8 cc 10 00 00 00 	movabs $0x10cc,%rax
    1206:	00 00 00 
    1209:	ff d0                	callq  *%rax
  return dst;
    120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    120f:	c9                   	leaveq 
    1210:	c3                   	retq   

0000000000001211 <strchr>:

char*
strchr(const char *s, char c)
{
    1211:	f3 0f 1e fa          	endbr64 
    1215:	55                   	push   %rbp
    1216:	48 89 e5             	mov    %rsp,%rbp
    1219:	48 83 ec 10          	sub    $0x10,%rsp
    121d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1221:	89 f0                	mov    %esi,%eax
    1223:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1226:	eb 17                	jmp    123f <strchr+0x2e>
    if(*s == c)
    1228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    122c:	0f b6 00             	movzbl (%rax),%eax
    122f:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1232:	75 06                	jne    123a <strchr+0x29>
      return (char*)s;
    1234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1238:	eb 15                	jmp    124f <strchr+0x3e>
  for(; *s; s++)
    123a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1243:	0f b6 00             	movzbl (%rax),%eax
    1246:	84 c0                	test   %al,%al
    1248:	75 de                	jne    1228 <strchr+0x17>
  return 0;
    124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    124f:	c9                   	leaveq 
    1250:	c3                   	retq   

0000000000001251 <gets>:

char*
gets(char *buf, int max)
{
    1251:	f3 0f 1e fa          	endbr64 
    1255:	55                   	push   %rbp
    1256:	48 89 e5             	mov    %rsp,%rbp
    1259:	48 83 ec 20          	sub    $0x20,%rsp
    125d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1261:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    126b:	eb 4f                	jmp    12bc <gets+0x6b>
    cc = read(0, &c, 1);
    126d:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1271:	ba 01 00 00 00       	mov    $0x1,%edx
    1276:	48 89 c6             	mov    %rax,%rsi
    1279:	bf 00 00 00 00       	mov    $0x0,%edi
    127e:	48 b8 36 14 00 00 00 	movabs $0x1436,%rax
    1285:	00 00 00 
    1288:	ff d0                	callq  *%rax
    128a:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    128d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1291:	7e 36                	jle    12c9 <gets+0x78>
      break;
    buf[i++] = c;
    1293:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1296:	8d 50 01             	lea    0x1(%rax),%edx
    1299:	89 55 fc             	mov    %edx,-0x4(%rbp)
    129c:	48 63 d0             	movslq %eax,%rdx
    129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a3:	48 01 c2             	add    %rax,%rdx
    12a6:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12aa:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    12ac:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12b0:	3c 0a                	cmp    $0xa,%al
    12b2:	74 16                	je     12ca <gets+0x79>
    12b4:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12b8:	3c 0d                	cmp    $0xd,%al
    12ba:	74 0e                	je     12ca <gets+0x79>
  for(i=0; i+1 < max; ){
    12bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12bf:	83 c0 01             	add    $0x1,%eax
    12c2:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    12c5:	7f a6                	jg     126d <gets+0x1c>
    12c7:	eb 01                	jmp    12ca <gets+0x79>
      break;
    12c9:	90                   	nop
      break;
  }
  buf[i] = '\0';
    12ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12cd:	48 63 d0             	movslq %eax,%rdx
    12d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12d4:	48 01 d0             	add    %rdx,%rax
    12d7:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12de:	c9                   	leaveq 
    12df:	c3                   	retq   

00000000000012e0 <stat>:

int
stat(char *n, struct stat *st)
{
    12e0:	f3 0f 1e fa          	endbr64 
    12e4:	55                   	push   %rbp
    12e5:	48 89 e5             	mov    %rsp,%rbp
    12e8:	48 83 ec 20          	sub    $0x20,%rsp
    12ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12f8:	be 00 00 00 00       	mov    $0x0,%esi
    12fd:	48 89 c7             	mov    %rax,%rdi
    1300:	48 b8 77 14 00 00 00 	movabs $0x1477,%rax
    1307:	00 00 00 
    130a:	ff d0                	callq  *%rax
    130c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    130f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1313:	79 07                	jns    131c <stat+0x3c>
    return -1;
    1315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    131a:	eb 2f                	jmp    134b <stat+0x6b>
  r = fstat(fd, st);
    131c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1320:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1323:	48 89 d6             	mov    %rdx,%rsi
    1326:	89 c7                	mov    %eax,%edi
    1328:	48 b8 9e 14 00 00 00 	movabs $0x149e,%rax
    132f:	00 00 00 
    1332:	ff d0                	callq  *%rax
    1334:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1337:	8b 45 fc             	mov    -0x4(%rbp),%eax
    133a:	89 c7                	mov    %eax,%edi
    133c:	48 b8 50 14 00 00 00 	movabs $0x1450,%rax
    1343:	00 00 00 
    1346:	ff d0                	callq  *%rax
  return r;
    1348:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    134b:	c9                   	leaveq 
    134c:	c3                   	retq   

000000000000134d <atoi>:

int
atoi(const char *s)
{
    134d:	f3 0f 1e fa          	endbr64 
    1351:	55                   	push   %rbp
    1352:	48 89 e5             	mov    %rsp,%rbp
    1355:	48 83 ec 18          	sub    $0x18,%rsp
    1359:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    135d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1364:	eb 28                	jmp    138e <atoi+0x41>
    n = n*10 + *s++ - '0';
    1366:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1369:	89 d0                	mov    %edx,%eax
    136b:	c1 e0 02             	shl    $0x2,%eax
    136e:	01 d0                	add    %edx,%eax
    1370:	01 c0                	add    %eax,%eax
    1372:	89 c1                	mov    %eax,%ecx
    1374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1378:	48 8d 50 01          	lea    0x1(%rax),%rdx
    137c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1380:	0f b6 00             	movzbl (%rax),%eax
    1383:	0f be c0             	movsbl %al,%eax
    1386:	01 c8                	add    %ecx,%eax
    1388:	83 e8 30             	sub    $0x30,%eax
    138b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1392:	0f b6 00             	movzbl (%rax),%eax
    1395:	3c 2f                	cmp    $0x2f,%al
    1397:	7e 0b                	jle    13a4 <atoi+0x57>
    1399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    139d:	0f b6 00             	movzbl (%rax),%eax
    13a0:	3c 39                	cmp    $0x39,%al
    13a2:	7e c2                	jle    1366 <atoi+0x19>
  return n;
    13a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    13a7:	c9                   	leaveq 
    13a8:	c3                   	retq   

00000000000013a9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13a9:	f3 0f 1e fa          	endbr64 
    13ad:	55                   	push   %rbp
    13ae:	48 89 e5             	mov    %rsp,%rbp
    13b1:	48 83 ec 28          	sub    $0x28,%rsp
    13b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    13bd:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    13c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    13c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    13cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    13d0:	eb 1d                	jmp    13ef <memmove+0x46>
    *dst++ = *src++;
    13d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13d6:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13e2:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13e6:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13ea:	0f b6 12             	movzbl (%rdx),%edx
    13ed:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13f2:	8d 50 ff             	lea    -0x1(%rax),%edx
    13f5:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13f8:	85 c0                	test   %eax,%eax
    13fa:	7f d6                	jg     13d2 <memmove+0x29>
  return vdst;
    13fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1400:	c9                   	leaveq 
    1401:	c3                   	retq   

0000000000001402 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1402:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1409:	49 89 ca             	mov    %rcx,%r10
    140c:	0f 05                	syscall 
    140e:	c3                   	retq   

000000000000140f <exit>:
SYSCALL(exit)
    140f:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1416:	49 89 ca             	mov    %rcx,%r10
    1419:	0f 05                	syscall 
    141b:	c3                   	retq   

000000000000141c <wait>:
SYSCALL(wait)
    141c:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1423:	49 89 ca             	mov    %rcx,%r10
    1426:	0f 05                	syscall 
    1428:	c3                   	retq   

0000000000001429 <pipe>:
SYSCALL(pipe)
    1429:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1430:	49 89 ca             	mov    %rcx,%r10
    1433:	0f 05                	syscall 
    1435:	c3                   	retq   

0000000000001436 <read>:
SYSCALL(read)
    1436:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    143d:	49 89 ca             	mov    %rcx,%r10
    1440:	0f 05                	syscall 
    1442:	c3                   	retq   

0000000000001443 <write>:
SYSCALL(write)
    1443:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    144a:	49 89 ca             	mov    %rcx,%r10
    144d:	0f 05                	syscall 
    144f:	c3                   	retq   

0000000000001450 <close>:
SYSCALL(close)
    1450:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1457:	49 89 ca             	mov    %rcx,%r10
    145a:	0f 05                	syscall 
    145c:	c3                   	retq   

000000000000145d <kill>:
SYSCALL(kill)
    145d:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1464:	49 89 ca             	mov    %rcx,%r10
    1467:	0f 05                	syscall 
    1469:	c3                   	retq   

000000000000146a <exec>:
SYSCALL(exec)
    146a:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1471:	49 89 ca             	mov    %rcx,%r10
    1474:	0f 05                	syscall 
    1476:	c3                   	retq   

0000000000001477 <open>:
SYSCALL(open)
    1477:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    147e:	49 89 ca             	mov    %rcx,%r10
    1481:	0f 05                	syscall 
    1483:	c3                   	retq   

0000000000001484 <mknod>:
SYSCALL(mknod)
    1484:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    148b:	49 89 ca             	mov    %rcx,%r10
    148e:	0f 05                	syscall 
    1490:	c3                   	retq   

0000000000001491 <unlink>:
SYSCALL(unlink)
    1491:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1498:	49 89 ca             	mov    %rcx,%r10
    149b:	0f 05                	syscall 
    149d:	c3                   	retq   

000000000000149e <fstat>:
SYSCALL(fstat)
    149e:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    14a5:	49 89 ca             	mov    %rcx,%r10
    14a8:	0f 05                	syscall 
    14aa:	c3                   	retq   

00000000000014ab <link>:
SYSCALL(link)
    14ab:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    14b2:	49 89 ca             	mov    %rcx,%r10
    14b5:	0f 05                	syscall 
    14b7:	c3                   	retq   

00000000000014b8 <mkdir>:
SYSCALL(mkdir)
    14b8:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    14bf:	49 89 ca             	mov    %rcx,%r10
    14c2:	0f 05                	syscall 
    14c4:	c3                   	retq   

00000000000014c5 <chdir>:
SYSCALL(chdir)
    14c5:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    14cc:	49 89 ca             	mov    %rcx,%r10
    14cf:	0f 05                	syscall 
    14d1:	c3                   	retq   

00000000000014d2 <dup>:
SYSCALL(dup)
    14d2:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14d9:	49 89 ca             	mov    %rcx,%r10
    14dc:	0f 05                	syscall 
    14de:	c3                   	retq   

00000000000014df <getpid>:
SYSCALL(getpid)
    14df:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14e6:	49 89 ca             	mov    %rcx,%r10
    14e9:	0f 05                	syscall 
    14eb:	c3                   	retq   

00000000000014ec <sbrk>:
SYSCALL(sbrk)
    14ec:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14f3:	49 89 ca             	mov    %rcx,%r10
    14f6:	0f 05                	syscall 
    14f8:	c3                   	retq   

00000000000014f9 <sleep>:
SYSCALL(sleep)
    14f9:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1500:	49 89 ca             	mov    %rcx,%r10
    1503:	0f 05                	syscall 
    1505:	c3                   	retq   

0000000000001506 <uptime>:
SYSCALL(uptime)
    1506:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    150d:	49 89 ca             	mov    %rcx,%r10
    1510:	0f 05                	syscall 
    1512:	c3                   	retq   

0000000000001513 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1513:	f3 0f 1e fa          	endbr64 
    1517:	55                   	push   %rbp
    1518:	48 89 e5             	mov    %rsp,%rbp
    151b:	48 83 ec 10          	sub    $0x10,%rsp
    151f:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1522:	89 f0                	mov    %esi,%eax
    1524:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1527:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    152b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    152e:	ba 01 00 00 00       	mov    $0x1,%edx
    1533:	48 89 ce             	mov    %rcx,%rsi
    1536:	89 c7                	mov    %eax,%edi
    1538:	48 b8 43 14 00 00 00 	movabs $0x1443,%rax
    153f:	00 00 00 
    1542:	ff d0                	callq  *%rax
}
    1544:	90                   	nop
    1545:	c9                   	leaveq 
    1546:	c3                   	retq   

0000000000001547 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1547:	f3 0f 1e fa          	endbr64 
    154b:	55                   	push   %rbp
    154c:	48 89 e5             	mov    %rsp,%rbp
    154f:	48 83 ec 20          	sub    $0x20,%rsp
    1553:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1556:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    155a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1561:	eb 35                	jmp    1598 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1563:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1567:	48 c1 e8 3c          	shr    $0x3c,%rax
    156b:	48 ba 40 26 00 00 00 	movabs $0x2640,%rdx
    1572:	00 00 00 
    1575:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1579:	0f be d0             	movsbl %al,%edx
    157c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    157f:	89 d6                	mov    %edx,%esi
    1581:	89 c7                	mov    %eax,%edi
    1583:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    158a:	00 00 00 
    158d:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    158f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1593:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1598:	8b 45 fc             	mov    -0x4(%rbp),%eax
    159b:	83 f8 0f             	cmp    $0xf,%eax
    159e:	76 c3                	jbe    1563 <print_x64+0x1c>
}
    15a0:	90                   	nop
    15a1:	90                   	nop
    15a2:	c9                   	leaveq 
    15a3:	c3                   	retq   

00000000000015a4 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    15a4:	f3 0f 1e fa          	endbr64 
    15a8:	55                   	push   %rbp
    15a9:	48 89 e5             	mov    %rsp,%rbp
    15ac:	48 83 ec 20          	sub    $0x20,%rsp
    15b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15b3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15bd:	eb 36                	jmp    15f5 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15bf:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15c2:	c1 e8 1c             	shr    $0x1c,%eax
    15c5:	89 c2                	mov    %eax,%edx
    15c7:	48 b8 40 26 00 00 00 	movabs $0x2640,%rax
    15ce:	00 00 00 
    15d1:	89 d2                	mov    %edx,%edx
    15d3:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15d7:	0f be d0             	movsbl %al,%edx
    15da:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15dd:	89 d6                	mov    %edx,%esi
    15df:	89 c7                	mov    %eax,%edi
    15e1:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    15e8:	00 00 00 
    15eb:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15f1:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15f8:	83 f8 07             	cmp    $0x7,%eax
    15fb:	76 c2                	jbe    15bf <print_x32+0x1b>
}
    15fd:	90                   	nop
    15fe:	90                   	nop
    15ff:	c9                   	leaveq 
    1600:	c3                   	retq   

0000000000001601 <print_d>:

  static void
print_d(int fd, int v)
{
    1601:	f3 0f 1e fa          	endbr64 
    1605:	55                   	push   %rbp
    1606:	48 89 e5             	mov    %rsp,%rbp
    1609:	48 83 ec 30          	sub    $0x30,%rsp
    160d:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1610:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1613:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1616:	48 98                	cltq   
    1618:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    161c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1620:	79 04                	jns    1626 <print_d+0x25>
    x = -x;
    1622:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1626:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    162d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1631:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1638:	66 66 66 
    163b:	48 89 c8             	mov    %rcx,%rax
    163e:	48 f7 ea             	imul   %rdx
    1641:	48 c1 fa 02          	sar    $0x2,%rdx
    1645:	48 89 c8             	mov    %rcx,%rax
    1648:	48 c1 f8 3f          	sar    $0x3f,%rax
    164c:	48 29 c2             	sub    %rax,%rdx
    164f:	48 89 d0             	mov    %rdx,%rax
    1652:	48 c1 e0 02          	shl    $0x2,%rax
    1656:	48 01 d0             	add    %rdx,%rax
    1659:	48 01 c0             	add    %rax,%rax
    165c:	48 29 c1             	sub    %rax,%rcx
    165f:	48 89 ca             	mov    %rcx,%rdx
    1662:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1665:	8d 48 01             	lea    0x1(%rax),%ecx
    1668:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    166b:	48 b9 40 26 00 00 00 	movabs $0x2640,%rcx
    1672:	00 00 00 
    1675:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1679:	48 98                	cltq   
    167b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    167f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1683:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    168a:	66 66 66 
    168d:	48 89 c8             	mov    %rcx,%rax
    1690:	48 f7 ea             	imul   %rdx
    1693:	48 c1 fa 02          	sar    $0x2,%rdx
    1697:	48 89 c8             	mov    %rcx,%rax
    169a:	48 c1 f8 3f          	sar    $0x3f,%rax
    169e:	48 29 c2             	sub    %rax,%rdx
    16a1:	48 89 d0             	mov    %rdx,%rax
    16a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    16a8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    16ad:	0f 85 7a ff ff ff    	jne    162d <print_d+0x2c>

  if (v < 0)
    16b3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16b7:	79 32                	jns    16eb <print_d+0xea>
    buf[i++] = '-';
    16b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16bc:	8d 50 01             	lea    0x1(%rax),%edx
    16bf:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16c2:	48 98                	cltq   
    16c4:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16c9:	eb 20                	jmp    16eb <print_d+0xea>
    putc(fd, buf[i]);
    16cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16ce:	48 98                	cltq   
    16d0:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16d5:	0f be d0             	movsbl %al,%edx
    16d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16db:	89 d6                	mov    %edx,%esi
    16dd:	89 c7                	mov    %eax,%edi
    16df:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    16e6:	00 00 00 
    16e9:	ff d0                	callq  *%rax
  while (--i >= 0)
    16eb:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16f3:	79 d6                	jns    16cb <print_d+0xca>
}
    16f5:	90                   	nop
    16f6:	90                   	nop
    16f7:	c9                   	leaveq 
    16f8:	c3                   	retq   

00000000000016f9 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16f9:	f3 0f 1e fa          	endbr64 
    16fd:	55                   	push   %rbp
    16fe:	48 89 e5             	mov    %rsp,%rbp
    1701:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1708:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    170e:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1715:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    171c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1723:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    172a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1731:	84 c0                	test   %al,%al
    1733:	74 20                	je     1755 <printf+0x5c>
    1735:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1739:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    173d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1741:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1745:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1749:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    174d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1751:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1755:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    175c:	00 00 00 
    175f:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1766:	00 00 00 
    1769:	48 8d 45 10          	lea    0x10(%rbp),%rax
    176d:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1774:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    177b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1782:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1789:	00 00 00 
    178c:	e9 41 03 00 00       	jmpq   1ad2 <printf+0x3d9>
    if (c != '%') {
    1791:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1798:	74 24                	je     17be <printf+0xc5>
      putc(fd, c);
    179a:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    17a0:	0f be d0             	movsbl %al,%edx
    17a3:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    17a9:	89 d6                	mov    %edx,%esi
    17ab:	89 c7                	mov    %eax,%edi
    17ad:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    17b4:	00 00 00 
    17b7:	ff d0                	callq  *%rax
      continue;
    17b9:	e9 0d 03 00 00       	jmpq   1acb <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    17be:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17c5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17cb:	48 63 d0             	movslq %eax,%rdx
    17ce:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17d5:	48 01 d0             	add    %rdx,%rax
    17d8:	0f b6 00             	movzbl (%rax),%eax
    17db:	0f be c0             	movsbl %al,%eax
    17de:	25 ff 00 00 00       	and    $0xff,%eax
    17e3:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17e9:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17f0:	0f 84 0f 03 00 00    	je     1b05 <printf+0x40c>
      break;
    switch(c) {
    17f6:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17fd:	0f 84 74 02 00 00    	je     1a77 <printf+0x37e>
    1803:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    180a:	0f 8c 82 02 00 00    	jl     1a92 <printf+0x399>
    1810:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1817:	0f 8f 75 02 00 00    	jg     1a92 <printf+0x399>
    181d:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1824:	0f 8c 68 02 00 00    	jl     1a92 <printf+0x399>
    182a:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1830:	83 e8 63             	sub    $0x63,%eax
    1833:	83 f8 15             	cmp    $0x15,%eax
    1836:	0f 87 56 02 00 00    	ja     1a92 <printf+0x399>
    183c:	89 c0                	mov    %eax,%eax
    183e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1845:	00 
    1846:	48 b8 50 22 00 00 00 	movabs $0x2250,%rax
    184d:	00 00 00 
    1850:	48 01 d0             	add    %rdx,%rax
    1853:	48 8b 00             	mov    (%rax),%rax
    1856:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1859:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    185f:	83 f8 2f             	cmp    $0x2f,%eax
    1862:	77 23                	ja     1887 <printf+0x18e>
    1864:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    186b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1871:	89 d2                	mov    %edx,%edx
    1873:	48 01 d0             	add    %rdx,%rax
    1876:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    187c:	83 c2 08             	add    $0x8,%edx
    187f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1885:	eb 12                	jmp    1899 <printf+0x1a0>
    1887:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    188e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1892:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1899:	8b 00                	mov    (%rax),%eax
    189b:	0f be d0             	movsbl %al,%edx
    189e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18a4:	89 d6                	mov    %edx,%esi
    18a6:	89 c7                	mov    %eax,%edi
    18a8:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    18af:	00 00 00 
    18b2:	ff d0                	callq  *%rax
      break;
    18b4:	e9 12 02 00 00       	jmpq   1acb <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18b9:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18bf:	83 f8 2f             	cmp    $0x2f,%eax
    18c2:	77 23                	ja     18e7 <printf+0x1ee>
    18c4:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18cb:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18d1:	89 d2                	mov    %edx,%edx
    18d3:	48 01 d0             	add    %rdx,%rax
    18d6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18dc:	83 c2 08             	add    $0x8,%edx
    18df:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18e5:	eb 12                	jmp    18f9 <printf+0x200>
    18e7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18ee:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18f2:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18f9:	8b 10                	mov    (%rax),%edx
    18fb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1901:	89 d6                	mov    %edx,%esi
    1903:	89 c7                	mov    %eax,%edi
    1905:	48 b8 01 16 00 00 00 	movabs $0x1601,%rax
    190c:	00 00 00 
    190f:	ff d0                	callq  *%rax
      break;
    1911:	e9 b5 01 00 00       	jmpq   1acb <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1916:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    191c:	83 f8 2f             	cmp    $0x2f,%eax
    191f:	77 23                	ja     1944 <printf+0x24b>
    1921:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1928:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    192e:	89 d2                	mov    %edx,%edx
    1930:	48 01 d0             	add    %rdx,%rax
    1933:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1939:	83 c2 08             	add    $0x8,%edx
    193c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1942:	eb 12                	jmp    1956 <printf+0x25d>
    1944:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    194b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    194f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1956:	8b 10                	mov    (%rax),%edx
    1958:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    195e:	89 d6                	mov    %edx,%esi
    1960:	89 c7                	mov    %eax,%edi
    1962:	48 b8 a4 15 00 00 00 	movabs $0x15a4,%rax
    1969:	00 00 00 
    196c:	ff d0                	callq  *%rax
      break;
    196e:	e9 58 01 00 00       	jmpq   1acb <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1973:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1979:	83 f8 2f             	cmp    $0x2f,%eax
    197c:	77 23                	ja     19a1 <printf+0x2a8>
    197e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1985:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    198b:	89 d2                	mov    %edx,%edx
    198d:	48 01 d0             	add    %rdx,%rax
    1990:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1996:	83 c2 08             	add    $0x8,%edx
    1999:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    199f:	eb 12                	jmp    19b3 <printf+0x2ba>
    19a1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19a8:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19ac:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19b3:	48 8b 10             	mov    (%rax),%rdx
    19b6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19bc:	48 89 d6             	mov    %rdx,%rsi
    19bf:	89 c7                	mov    %eax,%edi
    19c1:	48 b8 47 15 00 00 00 	movabs $0x1547,%rax
    19c8:	00 00 00 
    19cb:	ff d0                	callq  *%rax
      break;
    19cd:	e9 f9 00 00 00       	jmpq   1acb <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19d2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19d8:	83 f8 2f             	cmp    $0x2f,%eax
    19db:	77 23                	ja     1a00 <printf+0x307>
    19dd:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19e4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19ea:	89 d2                	mov    %edx,%edx
    19ec:	48 01 d0             	add    %rdx,%rax
    19ef:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19f5:	83 c2 08             	add    $0x8,%edx
    19f8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19fe:	eb 12                	jmp    1a12 <printf+0x319>
    1a00:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a07:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a0b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a12:	48 8b 00             	mov    (%rax),%rax
    1a15:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a1c:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a23:	00 
    1a24:	75 41                	jne    1a67 <printf+0x36e>
        s = "(null)";
    1a26:	48 b8 48 22 00 00 00 	movabs $0x2248,%rax
    1a2d:	00 00 00 
    1a30:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a37:	eb 2e                	jmp    1a67 <printf+0x36e>
        putc(fd, *(s++));
    1a39:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a40:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a44:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a4b:	0f b6 00             	movzbl (%rax),%eax
    1a4e:	0f be d0             	movsbl %al,%edx
    1a51:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a57:	89 d6                	mov    %edx,%esi
    1a59:	89 c7                	mov    %eax,%edi
    1a5b:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    1a62:	00 00 00 
    1a65:	ff d0                	callq  *%rax
      while (*s)
    1a67:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a6e:	0f b6 00             	movzbl (%rax),%eax
    1a71:	84 c0                	test   %al,%al
    1a73:	75 c4                	jne    1a39 <printf+0x340>
      break;
    1a75:	eb 54                	jmp    1acb <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a77:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a7d:	be 25 00 00 00       	mov    $0x25,%esi
    1a82:	89 c7                	mov    %eax,%edi
    1a84:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    1a8b:	00 00 00 
    1a8e:	ff d0                	callq  *%rax
      break;
    1a90:	eb 39                	jmp    1acb <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a92:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a98:	be 25 00 00 00       	mov    $0x25,%esi
    1a9d:	89 c7                	mov    %eax,%edi
    1a9f:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    1aa6:	00 00 00 
    1aa9:	ff d0                	callq  *%rax
      putc(fd, c);
    1aab:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1ab1:	0f be d0             	movsbl %al,%edx
    1ab4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aba:	89 d6                	mov    %edx,%esi
    1abc:	89 c7                	mov    %eax,%edi
    1abe:	48 b8 13 15 00 00 00 	movabs $0x1513,%rax
    1ac5:	00 00 00 
    1ac8:	ff d0                	callq  *%rax
      break;
    1aca:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1acb:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ad2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ad8:	48 63 d0             	movslq %eax,%rdx
    1adb:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ae2:	48 01 d0             	add    %rdx,%rax
    1ae5:	0f b6 00             	movzbl (%rax),%eax
    1ae8:	0f be c0             	movsbl %al,%eax
    1aeb:	25 ff 00 00 00       	and    $0xff,%eax
    1af0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1af6:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1afd:	0f 85 8e fc ff ff    	jne    1791 <printf+0x98>
    }
  }
}
    1b03:	eb 01                	jmp    1b06 <printf+0x40d>
      break;
    1b05:	90                   	nop
}
    1b06:	90                   	nop
    1b07:	c9                   	leaveq 
    1b08:	c3                   	retq   

0000000000001b09 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b09:	f3 0f 1e fa          	endbr64 
    1b0d:	55                   	push   %rbp
    1b0e:	48 89 e5             	mov    %rsp,%rbp
    1b11:	48 83 ec 18          	sub    $0x18,%rsp
    1b15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b1d:	48 83 e8 10          	sub    $0x10,%rax
    1b21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b25:	48 b8 70 26 00 00 00 	movabs $0x2670,%rax
    1b2c:	00 00 00 
    1b2f:	48 8b 00             	mov    (%rax),%rax
    1b32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b36:	eb 2f                	jmp    1b67 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b3c:	48 8b 00             	mov    (%rax),%rax
    1b3f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b43:	72 17                	jb     1b5c <free+0x53>
    1b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b49:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b4d:	77 2f                	ja     1b7e <free+0x75>
    1b4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b53:	48 8b 00             	mov    (%rax),%rax
    1b56:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b5a:	72 22                	jb     1b7e <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b60:	48 8b 00             	mov    (%rax),%rax
    1b63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b6b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b6f:	76 c7                	jbe    1b38 <free+0x2f>
    1b71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b75:	48 8b 00             	mov    (%rax),%rax
    1b78:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b7c:	73 ba                	jae    1b38 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b82:	8b 40 08             	mov    0x8(%rax),%eax
    1b85:	89 c0                	mov    %eax,%eax
    1b87:	48 c1 e0 04          	shl    $0x4,%rax
    1b8b:	48 89 c2             	mov    %rax,%rdx
    1b8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b92:	48 01 c2             	add    %rax,%rdx
    1b95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b99:	48 8b 00             	mov    (%rax),%rax
    1b9c:	48 39 c2             	cmp    %rax,%rdx
    1b9f:	75 2d                	jne    1bce <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1ba1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba5:	8b 50 08             	mov    0x8(%rax),%edx
    1ba8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bac:	48 8b 00             	mov    (%rax),%rax
    1baf:	8b 40 08             	mov    0x8(%rax),%eax
    1bb2:	01 c2                	add    %eax,%edx
    1bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb8:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1bbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bbf:	48 8b 00             	mov    (%rax),%rax
    1bc2:	48 8b 10             	mov    (%rax),%rdx
    1bc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bc9:	48 89 10             	mov    %rdx,(%rax)
    1bcc:	eb 0e                	jmp    1bdc <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1bce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd2:	48 8b 10             	mov    (%rax),%rdx
    1bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd9:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be0:	8b 40 08             	mov    0x8(%rax),%eax
    1be3:	89 c0                	mov    %eax,%eax
    1be5:	48 c1 e0 04          	shl    $0x4,%rax
    1be9:	48 89 c2             	mov    %rax,%rdx
    1bec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf0:	48 01 d0             	add    %rdx,%rax
    1bf3:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bf7:	75 27                	jne    1c20 <free+0x117>
    p->s.size += bp->s.size;
    1bf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfd:	8b 50 08             	mov    0x8(%rax),%edx
    1c00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c04:	8b 40 08             	mov    0x8(%rax),%eax
    1c07:	01 c2                	add    %eax,%edx
    1c09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0d:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1c10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c14:	48 8b 10             	mov    (%rax),%rdx
    1c17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c1b:	48 89 10             	mov    %rdx,(%rax)
    1c1e:	eb 0b                	jmp    1c2b <free+0x122>
  } else
    p->s.ptr = bp;
    1c20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c28:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c2b:	48 ba 70 26 00 00 00 	movabs $0x2670,%rdx
    1c32:	00 00 00 
    1c35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c39:	48 89 02             	mov    %rax,(%rdx)
}
    1c3c:	90                   	nop
    1c3d:	c9                   	leaveq 
    1c3e:	c3                   	retq   

0000000000001c3f <morecore>:

static Header*
morecore(uint nu)
{
    1c3f:	f3 0f 1e fa          	endbr64 
    1c43:	55                   	push   %rbp
    1c44:	48 89 e5             	mov    %rsp,%rbp
    1c47:	48 83 ec 20          	sub    $0x20,%rsp
    1c4b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c4e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c55:	77 07                	ja     1c5e <morecore+0x1f>
    nu = 4096;
    1c57:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c61:	48 c1 e0 04          	shl    $0x4,%rax
    1c65:	48 89 c7             	mov    %rax,%rdi
    1c68:	48 b8 ec 14 00 00 00 	movabs $0x14ec,%rax
    1c6f:	00 00 00 
    1c72:	ff d0                	callq  *%rax
    1c74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c78:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c7d:	75 07                	jne    1c86 <morecore+0x47>
    return 0;
    1c7f:	b8 00 00 00 00       	mov    $0x0,%eax
    1c84:	eb 36                	jmp    1cbc <morecore+0x7d>
  hp = (Header*)p;
    1c86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c8a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c92:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c95:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c9c:	48 83 c0 10          	add    $0x10,%rax
    1ca0:	48 89 c7             	mov    %rax,%rdi
    1ca3:	48 b8 09 1b 00 00 00 	movabs $0x1b09,%rax
    1caa:	00 00 00 
    1cad:	ff d0                	callq  *%rax
  return freep;
    1caf:	48 b8 70 26 00 00 00 	movabs $0x2670,%rax
    1cb6:	00 00 00 
    1cb9:	48 8b 00             	mov    (%rax),%rax
}
    1cbc:	c9                   	leaveq 
    1cbd:	c3                   	retq   

0000000000001cbe <malloc>:

void*
malloc(uint nbytes)
{
    1cbe:	f3 0f 1e fa          	endbr64 
    1cc2:	55                   	push   %rbp
    1cc3:	48 89 e5             	mov    %rsp,%rbp
    1cc6:	48 83 ec 30          	sub    $0x30,%rsp
    1cca:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1ccd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cd0:	48 83 c0 0f          	add    $0xf,%rax
    1cd4:	48 c1 e8 04          	shr    $0x4,%rax
    1cd8:	83 c0 01             	add    $0x1,%eax
    1cdb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cde:	48 b8 70 26 00 00 00 	movabs $0x2670,%rax
    1ce5:	00 00 00 
    1ce8:	48 8b 00             	mov    (%rax),%rax
    1ceb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cef:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cf4:	75 4a                	jne    1d40 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1cf6:	48 b8 60 26 00 00 00 	movabs $0x2660,%rax
    1cfd:	00 00 00 
    1d00:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d04:	48 ba 70 26 00 00 00 	movabs $0x2670,%rdx
    1d0b:	00 00 00 
    1d0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d12:	48 89 02             	mov    %rax,(%rdx)
    1d15:	48 b8 70 26 00 00 00 	movabs $0x2670,%rax
    1d1c:	00 00 00 
    1d1f:	48 8b 00             	mov    (%rax),%rax
    1d22:	48 ba 60 26 00 00 00 	movabs $0x2660,%rdx
    1d29:	00 00 00 
    1d2c:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d2f:	48 b8 60 26 00 00 00 	movabs $0x2660,%rax
    1d36:	00 00 00 
    1d39:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d44:	48 8b 00             	mov    (%rax),%rax
    1d47:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4f:	8b 40 08             	mov    0x8(%rax),%eax
    1d52:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d55:	77 65                	ja     1dbc <malloc+0xfe>
      if(p->s.size == nunits)
    1d57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d5b:	8b 40 08             	mov    0x8(%rax),%eax
    1d5e:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d61:	75 10                	jne    1d73 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d67:	48 8b 10             	mov    (%rax),%rdx
    1d6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d6e:	48 89 10             	mov    %rdx,(%rax)
    1d71:	eb 2e                	jmp    1da1 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d77:	8b 40 08             	mov    0x8(%rax),%eax
    1d7a:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d7d:	89 c2                	mov    %eax,%edx
    1d7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d83:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8a:	8b 40 08             	mov    0x8(%rax),%eax
    1d8d:	89 c0                	mov    %eax,%eax
    1d8f:	48 c1 e0 04          	shl    $0x4,%rax
    1d93:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d9b:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d9e:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1da1:	48 ba 70 26 00 00 00 	movabs $0x2670,%rdx
    1da8:	00 00 00 
    1dab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1daf:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db6:	48 83 c0 10          	add    $0x10,%rax
    1dba:	eb 4e                	jmp    1e0a <malloc+0x14c>
    }
    if(p == freep)
    1dbc:	48 b8 70 26 00 00 00 	movabs $0x2670,%rax
    1dc3:	00 00 00 
    1dc6:	48 8b 00             	mov    (%rax),%rax
    1dc9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1dcd:	75 23                	jne    1df2 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1dcf:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1dd2:	89 c7                	mov    %eax,%edi
    1dd4:	48 b8 3f 1c 00 00 00 	movabs $0x1c3f,%rax
    1ddb:	00 00 00 
    1dde:	ff d0                	callq  *%rax
    1de0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1de4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1de9:	75 07                	jne    1df2 <malloc+0x134>
        return 0;
    1deb:	b8 00 00 00 00       	mov    $0x0,%eax
    1df0:	eb 18                	jmp    1e0a <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1df2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1df6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dfe:	48 8b 00             	mov    (%rax),%rax
    1e01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e05:	e9 41 ff ff ff       	jmpq   1d4b <malloc+0x8d>
  }
}
    1e0a:	c9                   	leaveq 
    1e0b:	c3                   	retq   

0000000000001e0c <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1e0c:	f3 0f 1e fa          	endbr64 
    1e10:	55                   	push   %rbp
    1e11:	48 89 e5             	mov    %rsp,%rbp
    1e14:	48 83 ec 30          	sub    $0x30,%rsp
    1e18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1e1c:	bf 18 00 00 00       	mov    $0x18,%edi
    1e21:	48 b8 be 1c 00 00 00 	movabs $0x1cbe,%rax
    1e28:	00 00 00 
    1e2b:	ff d0                	callq  *%rax
    1e2d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1e31:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1e36:	75 0a                	jne    1e42 <co_new+0x36>
    return 0;
    1e38:	b8 00 00 00 00       	mov    $0x0,%eax
    1e3d:	e9 e1 00 00 00       	jmpq   1f23 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1e42:	bf 00 20 00 00       	mov    $0x2000,%edi
    1e47:	48 b8 be 1c 00 00 00 	movabs $0x1cbe,%rax
    1e4e:	00 00 00 
    1e51:	ff d0                	callq  *%rax
    1e53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1e57:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1e5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e5f:	48 8b 40 10          	mov    0x10(%rax),%rax
    1e63:	48 85 c0             	test   %rax,%rax
    1e66:	75 1d                	jne    1e85 <co_new+0x79>
    free(co1);
    1e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e6c:	48 89 c7             	mov    %rax,%rdi
    1e6f:	48 b8 09 1b 00 00 00 	movabs $0x1b09,%rax
    1e76:	00 00 00 
    1e79:	ff d0                	callq  *%rax
    return 0;
    1e7b:	b8 00 00 00 00       	mov    $0x0,%eax
    1e80:	e9 9e 00 00 00       	jmpq   1f23 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1e85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e89:	48 8b 40 10          	mov    0x10(%rax),%rax
    1e8d:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    1e93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    1e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e9b:	48 8d 50 30          	lea    0x30(%rax),%rdx
    1e9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1ea3:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    1ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1eaa:	48 83 c0 38          	add    $0x38,%rax
    1eae:	48 ba 95 20 00 00 00 	movabs $0x2095,%rdx
    1eb5:	00 00 00 
    1eb8:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    1ebb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ebf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1ec3:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    1ec6:	48 b8 88 26 00 00 00 	movabs $0x2688,%rax
    1ecd:	00 00 00 
    1ed0:	48 8b 00             	mov    (%rax),%rax
    1ed3:	48 85 c0             	test   %rax,%rax
    1ed6:	75 13                	jne    1eeb <co_new+0xdf>
  {
  	co_list = co1;
    1ed8:	48 ba 88 26 00 00 00 	movabs $0x2688,%rdx
    1edf:	00 00 00 
    1ee2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ee6:	48 89 02             	mov    %rax,(%rdx)
    1ee9:	eb 34                	jmp    1f1f <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    1eeb:	48 b8 88 26 00 00 00 	movabs $0x2688,%rax
    1ef2:	00 00 00 
    1ef5:	48 8b 00             	mov    (%rax),%rax
    1ef8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1efc:	eb 0c                	jmp    1f0a <co_new+0xfe>
	{
		head = head->next;
    1efe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f02:	48 8b 40 08          	mov    0x8(%rax),%rax
    1f06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f0e:	48 8b 40 08          	mov    0x8(%rax),%rax
    1f12:	48 85 c0             	test   %rax,%rax
    1f15:	75 e7                	jne    1efe <co_new+0xf2>
	}
	head = co1;
    1f17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f1b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    1f1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    1f23:	c9                   	leaveq 
    1f24:	c3                   	retq   

0000000000001f25 <co_run>:

  int
co_run(void)
{
    1f25:	f3 0f 1e fa          	endbr64 
    1f29:	55                   	push   %rbp
    1f2a:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    1f2d:	48 b8 88 26 00 00 00 	movabs $0x2688,%rax
    1f34:	00 00 00 
    1f37:	48 8b 00             	mov    (%rax),%rax
    1f3a:	48 85 c0             	test   %rax,%rax
    1f3d:	74 4a                	je     1f89 <co_run+0x64>
	{
		co_current = co_list;
    1f3f:	48 b8 88 26 00 00 00 	movabs $0x2688,%rax
    1f46:	00 00 00 
    1f49:	48 8b 00             	mov    (%rax),%rax
    1f4c:	48 ba 80 26 00 00 00 	movabs $0x2680,%rdx
    1f53:	00 00 00 
    1f56:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    1f59:	48 b8 80 26 00 00 00 	movabs $0x2680,%rax
    1f60:	00 00 00 
    1f63:	48 8b 00             	mov    (%rax),%rax
    1f66:	48 8b 00             	mov    (%rax),%rax
    1f69:	48 89 c6             	mov    %rax,%rsi
    1f6c:	48 bf 78 26 00 00 00 	movabs $0x2678,%rdi
    1f73:	00 00 00 
    1f76:	48 b8 f7 21 00 00 00 	movabs $0x21f7,%rax
    1f7d:	00 00 00 
    1f80:	ff d0                	callq  *%rax
		return 1;
    1f82:	b8 01 00 00 00       	mov    $0x1,%eax
    1f87:	eb 05                	jmp    1f8e <co_run+0x69>
	}
	return 0;
    1f89:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1f8e:	5d                   	pop    %rbp
    1f8f:	c3                   	retq   

0000000000001f90 <co_run_all>:

  int
co_run_all(void)
{
    1f90:	f3 0f 1e fa          	endbr64 
    1f94:	55                   	push   %rbp
    1f95:	48 89 e5             	mov    %rsp,%rbp
    1f98:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    1f9c:	48 b8 88 26 00 00 00 	movabs $0x2688,%rax
    1fa3:	00 00 00 
    1fa6:	48 8b 00             	mov    (%rax),%rax
    1fa9:	48 85 c0             	test   %rax,%rax
    1fac:	75 07                	jne    1fb5 <co_run_all+0x25>
		return 0;
    1fae:	b8 00 00 00 00       	mov    $0x0,%eax
    1fb3:	eb 37                	jmp    1fec <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    1fb5:	48 b8 88 26 00 00 00 	movabs $0x2688,%rax
    1fbc:	00 00 00 
    1fbf:	48 8b 00             	mov    (%rax),%rax
    1fc2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    1fc6:	eb 18                	jmp    1fe0 <co_run_all+0x50>
			co_run();
    1fc8:	48 b8 25 1f 00 00 00 	movabs $0x1f25,%rax
    1fcf:	00 00 00 
    1fd2:	ff d0                	callq  *%rax
			tmp = tmp->next;
    1fd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd8:	48 8b 40 08          	mov    0x8(%rax),%rax
    1fdc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    1fe0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1fe5:	75 e1                	jne    1fc8 <co_run_all+0x38>
		}
		return 1;
    1fe7:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    1fec:	c9                   	leaveq 
    1fed:	c3                   	retq   

0000000000001fee <co_yield>:

  void
co_yield()
{
    1fee:	f3 0f 1e fa          	endbr64 
    1ff2:	55                   	push   %rbp
    1ff3:	48 89 e5             	mov    %rsp,%rbp
    1ff6:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    1ffa:	48 b8 80 26 00 00 00 	movabs $0x2680,%rax
    2001:	00 00 00 
    2004:	48 8b 00             	mov    (%rax),%rax
    2007:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    200b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    200f:	48 8b 40 08          	mov    0x8(%rax),%rax
    2013:	48 85 c0             	test   %rax,%rax
    2016:	74 46                	je     205e <co_yield+0x70>
  {
  	co_current = co_current->next;
    2018:	48 b8 80 26 00 00 00 	movabs $0x2680,%rax
    201f:	00 00 00 
    2022:	48 8b 00             	mov    (%rax),%rax
    2025:	48 8b 40 08          	mov    0x8(%rax),%rax
    2029:	48 ba 80 26 00 00 00 	movabs $0x2680,%rdx
    2030:	00 00 00 
    2033:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    2036:	48 b8 80 26 00 00 00 	movabs $0x2680,%rax
    203d:	00 00 00 
    2040:	48 8b 00             	mov    (%rax),%rax
    2043:	48 8b 10             	mov    (%rax),%rdx
    2046:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    204a:	48 89 d6             	mov    %rdx,%rsi
    204d:	48 89 c7             	mov    %rax,%rdi
    2050:	48 b8 f7 21 00 00 00 	movabs $0x21f7,%rax
    2057:	00 00 00 
    205a:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    205c:	eb 34                	jmp    2092 <co_yield+0xa4>
	co_current = 0;
    205e:	48 b8 80 26 00 00 00 	movabs $0x2680,%rax
    2065:	00 00 00 
    2068:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    206f:	48 b8 78 26 00 00 00 	movabs $0x2678,%rax
    2076:	00 00 00 
    2079:	48 8b 10             	mov    (%rax),%rdx
    207c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2080:	48 89 d6             	mov    %rdx,%rsi
    2083:	48 89 c7             	mov    %rax,%rdi
    2086:	48 b8 f7 21 00 00 00 	movabs $0x21f7,%rax
    208d:	00 00 00 
    2090:	ff d0                	callq  *%rax
}
    2092:	90                   	nop
    2093:	c9                   	leaveq 
    2094:	c3                   	retq   

0000000000002095 <co_exit>:

  void
co_exit(void)
{
    2095:	f3 0f 1e fa          	endbr64 
    2099:	55                   	push   %rbp
    209a:	48 89 e5             	mov    %rsp,%rbp
    209d:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    20a1:	48 b8 80 26 00 00 00 	movabs $0x2680,%rax
    20a8:	00 00 00 
    20ab:	48 8b 00             	mov    (%rax),%rax
    20ae:	48 85 c0             	test   %rax,%rax
    20b1:	0f 84 ec 00 00 00    	je     21a3 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    20b7:	48 b8 88 26 00 00 00 	movabs $0x2688,%rax
    20be:	00 00 00 
    20c1:	48 8b 00             	mov    (%rax),%rax
    20c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    20c8:	e9 c9 00 00 00       	jmpq   2196 <co_exit+0x101>
		if(tmp == co_current)
    20cd:	48 b8 80 26 00 00 00 	movabs $0x2680,%rax
    20d4:	00 00 00 
    20d7:	48 8b 00             	mov    (%rax),%rax
    20da:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    20de:	0f 85 9e 00 00 00    	jne    2182 <co_exit+0xed>
		{
			if(tmp->next)
    20e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20e8:	48 8b 40 08          	mov    0x8(%rax),%rax
    20ec:	48 85 c0             	test   %rax,%rax
    20ef:	74 54                	je     2145 <co_exit+0xb0>
			{
				if(prev)
    20f1:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20f6:	74 10                	je     2108 <co_exit+0x73>
				{
					prev->next = tmp->next;
    20f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
    2100:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2104:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    2108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    210c:	48 8b 40 08          	mov    0x8(%rax),%rax
    2110:	48 ba 88 26 00 00 00 	movabs $0x2688,%rdx
    2117:	00 00 00 
    211a:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    211d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2121:	48 8b 00             	mov    (%rax),%rax
    2124:	48 ba 80 26 00 00 00 	movabs $0x2680,%rdx
    212b:	00 00 00 
    212e:	48 8b 12             	mov    (%rdx),%rdx
    2131:	48 89 c6             	mov    %rax,%rsi
    2134:	48 89 d7             	mov    %rdx,%rdi
    2137:	48 b8 f7 21 00 00 00 	movabs $0x21f7,%rax
    213e:	00 00 00 
    2141:	ff d0                	callq  *%rax
    2143:	eb 3d                	jmp    2182 <co_exit+0xed>
			}else{
				co_list = 0;
    2145:	48 b8 88 26 00 00 00 	movabs $0x2688,%rax
    214c:	00 00 00 
    214f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    2156:	48 b8 78 26 00 00 00 	movabs $0x2678,%rax
    215d:	00 00 00 
    2160:	48 8b 00             	mov    (%rax),%rax
    2163:	48 ba 80 26 00 00 00 	movabs $0x2680,%rdx
    216a:	00 00 00 
    216d:	48 8b 12             	mov    (%rdx),%rdx
    2170:	48 89 c6             	mov    %rax,%rsi
    2173:	48 89 d7             	mov    %rdx,%rdi
    2176:	48 b8 f7 21 00 00 00 	movabs $0x21f7,%rax
    217d:	00 00 00 
    2180:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    2182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2186:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    218a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    218e:	48 8b 40 08          	mov    0x8(%rax),%rax
    2192:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    2196:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    219b:	0f 85 2c ff ff ff    	jne    20cd <co_exit+0x38>
    21a1:	eb 01                	jmp    21a4 <co_exit+0x10f>
		return;
    21a3:	90                   	nop
	}
}
    21a4:	c9                   	leaveq 
    21a5:	c3                   	retq   

00000000000021a6 <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    21a6:	f3 0f 1e fa          	endbr64 
    21aa:	55                   	push   %rbp
    21ab:	48 89 e5             	mov    %rsp,%rbp
    21ae:	48 83 ec 10          	sub    $0x10,%rsp
    21b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    21b6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    21bb:	74 37                	je     21f4 <co_destroy+0x4e>
    if (co->stack)
    21bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21c1:	48 8b 40 10          	mov    0x10(%rax),%rax
    21c5:	48 85 c0             	test   %rax,%rax
    21c8:	74 17                	je     21e1 <co_destroy+0x3b>
      free(co->stack);
    21ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21ce:	48 8b 40 10          	mov    0x10(%rax),%rax
    21d2:	48 89 c7             	mov    %rax,%rdi
    21d5:	48 b8 09 1b 00 00 00 	movabs $0x1b09,%rax
    21dc:	00 00 00 
    21df:	ff d0                	callq  *%rax
    free(co);
    21e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21e5:	48 89 c7             	mov    %rax,%rdi
    21e8:	48 b8 09 1b 00 00 00 	movabs $0x1b09,%rax
    21ef:	00 00 00 
    21f2:	ff d0                	callq  *%rax
  }
}
    21f4:	90                   	nop
    21f5:	c9                   	leaveq 
    21f6:	c3                   	retq   

00000000000021f7 <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    21f7:	55                   	push   %rbp
  pushq   %rbx
    21f8:	53                   	push   %rbx
  pushq   %r12
    21f9:	41 54                	push   %r12
  pushq   %r13
    21fb:	41 55                	push   %r13
  pushq   %r14
    21fd:	41 56                	push   %r14
  pushq   %r15
    21ff:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    2201:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    2204:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    2207:	41 5f                	pop    %r15
  popq    %r14
    2209:	41 5e                	pop    %r14
  popq    %r13
    220b:	41 5d                	pop    %r13
  popq    %r12
    220d:	41 5c                	pop    %r12
  popq    %rbx
    220f:	5b                   	pop    %rbx
  popq    %rbp
    2210:	5d                   	pop    %rbp

  retq #??
    2211:	c3                   	retq   
