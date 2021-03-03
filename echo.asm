
_echo:     file format elf64-x86-64


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

  for(i = 1; i < argc; i++)
    1013:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    101a:	eb 61                	jmp    107d <main+0x7d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    101c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    101f:	83 c0 01             	add    $0x1,%eax
    1022:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1025:	7e 0c                	jle    1033 <main+0x33>
    1027:	48 b8 d8 21 00 00 00 	movabs $0x21d8,%rax
    102e:	00 00 00 
    1031:	eb 0a                	jmp    103d <main+0x3d>
    1033:	48 b8 da 21 00 00 00 	movabs $0x21da,%rax
    103a:	00 00 00 
    103d:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1040:	48 63 d2             	movslq %edx,%rdx
    1043:	48 8d 0c d5 00 00 00 	lea    0x0(,%rdx,8),%rcx
    104a:	00 
    104b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    104f:	48 01 ca             	add    %rcx,%rdx
    1052:	48 8b 12             	mov    (%rdx),%rdx
    1055:	48 89 c1             	mov    %rax,%rcx
    1058:	48 be dc 21 00 00 00 	movabs $0x21dc,%rsi
    105f:	00 00 00 
    1062:	bf 01 00 00 00       	mov    $0x1,%edi
    1067:	b8 00 00 00 00       	mov    $0x0,%eax
    106c:	49 b8 be 16 00 00 00 	movabs $0x16be,%r8
    1073:	00 00 00 
    1076:	41 ff d0             	callq  *%r8
  for(i = 1; i < argc; i++)
    1079:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    107d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1080:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1083:	7c 97                	jl     101c <main+0x1c>
  exit();
    1085:	48 b8 d4 13 00 00 00 	movabs $0x13d4,%rax
    108c:	00 00 00 
    108f:	ff d0                	callq  *%rax

0000000000001091 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1091:	f3 0f 1e fa          	endbr64 
    1095:	55                   	push   %rbp
    1096:	48 89 e5             	mov    %rsp,%rbp
    1099:	48 83 ec 10          	sub    $0x10,%rsp
    109d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10a1:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10a4:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10a7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10ab:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10b1:	48 89 ce             	mov    %rcx,%rsi
    10b4:	48 89 f7             	mov    %rsi,%rdi
    10b7:	89 d1                	mov    %edx,%ecx
    10b9:	fc                   	cld    
    10ba:	f3 aa                	rep stos %al,%es:(%rdi)
    10bc:	89 ca                	mov    %ecx,%edx
    10be:	48 89 fe             	mov    %rdi,%rsi
    10c1:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10c5:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10c8:	90                   	nop
    10c9:	c9                   	leaveq 
    10ca:	c3                   	retq   

00000000000010cb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10cb:	f3 0f 1e fa          	endbr64 
    10cf:	55                   	push   %rbp
    10d0:	48 89 e5             	mov    %rsp,%rbp
    10d3:	48 83 ec 20          	sub    $0x20,%rsp
    10d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    10db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    10df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    10e7:	90                   	nop
    10e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    10ec:	48 8d 42 01          	lea    0x1(%rdx),%rax
    10f0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10f8:	48 8d 48 01          	lea    0x1(%rax),%rcx
    10fc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1100:	0f b6 12             	movzbl (%rdx),%edx
    1103:	88 10                	mov    %dl,(%rax)
    1105:	0f b6 00             	movzbl (%rax),%eax
    1108:	84 c0                	test   %al,%al
    110a:	75 dc                	jne    10e8 <strcpy+0x1d>
    ;
  return os;
    110c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1110:	c9                   	leaveq 
    1111:	c3                   	retq   

0000000000001112 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1112:	f3 0f 1e fa          	endbr64 
    1116:	55                   	push   %rbp
    1117:	48 89 e5             	mov    %rsp,%rbp
    111a:	48 83 ec 10          	sub    $0x10,%rsp
    111e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1122:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1126:	eb 0a                	jmp    1132 <strcmp+0x20>
    p++, q++;
    1128:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    112d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1136:	0f b6 00             	movzbl (%rax),%eax
    1139:	84 c0                	test   %al,%al
    113b:	74 12                	je     114f <strcmp+0x3d>
    113d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1141:	0f b6 10             	movzbl (%rax),%edx
    1144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1148:	0f b6 00             	movzbl (%rax),%eax
    114b:	38 c2                	cmp    %al,%dl
    114d:	74 d9                	je     1128 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    114f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1153:	0f b6 00             	movzbl (%rax),%eax
    1156:	0f b6 d0             	movzbl %al,%edx
    1159:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    115d:	0f b6 00             	movzbl (%rax),%eax
    1160:	0f b6 c0             	movzbl %al,%eax
    1163:	29 c2                	sub    %eax,%edx
    1165:	89 d0                	mov    %edx,%eax
}
    1167:	c9                   	leaveq 
    1168:	c3                   	retq   

0000000000001169 <strlen>:

uint
strlen(char *s)
{
    1169:	f3 0f 1e fa          	endbr64 
    116d:	55                   	push   %rbp
    116e:	48 89 e5             	mov    %rsp,%rbp
    1171:	48 83 ec 18          	sub    $0x18,%rsp
    1175:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1180:	eb 04                	jmp    1186 <strlen+0x1d>
    1182:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1186:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1189:	48 63 d0             	movslq %eax,%rdx
    118c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1190:	48 01 d0             	add    %rdx,%rax
    1193:	0f b6 00             	movzbl (%rax),%eax
    1196:	84 c0                	test   %al,%al
    1198:	75 e8                	jne    1182 <strlen+0x19>
    ;
  return n;
    119a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    119d:	c9                   	leaveq 
    119e:	c3                   	retq   

000000000000119f <memset>:

void*
memset(void *dst, int c, uint n)
{
    119f:	f3 0f 1e fa          	endbr64 
    11a3:	55                   	push   %rbp
    11a4:	48 89 e5             	mov    %rsp,%rbp
    11a7:	48 83 ec 10          	sub    $0x10,%rsp
    11ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11af:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11b2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11b5:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11b8:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11bf:	89 ce                	mov    %ecx,%esi
    11c1:	48 89 c7             	mov    %rax,%rdi
    11c4:	48 b8 91 10 00 00 00 	movabs $0x1091,%rax
    11cb:	00 00 00 
    11ce:	ff d0                	callq  *%rax
  return dst;
    11d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11d4:	c9                   	leaveq 
    11d5:	c3                   	retq   

00000000000011d6 <strchr>:

char*
strchr(const char *s, char c)
{
    11d6:	f3 0f 1e fa          	endbr64 
    11da:	55                   	push   %rbp
    11db:	48 89 e5             	mov    %rsp,%rbp
    11de:	48 83 ec 10          	sub    $0x10,%rsp
    11e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11e6:	89 f0                	mov    %esi,%eax
    11e8:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    11eb:	eb 17                	jmp    1204 <strchr+0x2e>
    if(*s == c)
    11ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11f1:	0f b6 00             	movzbl (%rax),%eax
    11f4:	38 45 f4             	cmp    %al,-0xc(%rbp)
    11f7:	75 06                	jne    11ff <strchr+0x29>
      return (char*)s;
    11f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11fd:	eb 15                	jmp    1214 <strchr+0x3e>
  for(; *s; s++)
    11ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1204:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1208:	0f b6 00             	movzbl (%rax),%eax
    120b:	84 c0                	test   %al,%al
    120d:	75 de                	jne    11ed <strchr+0x17>
  return 0;
    120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1214:	c9                   	leaveq 
    1215:	c3                   	retq   

0000000000001216 <gets>:

char*
gets(char *buf, int max)
{
    1216:	f3 0f 1e fa          	endbr64 
    121a:	55                   	push   %rbp
    121b:	48 89 e5             	mov    %rsp,%rbp
    121e:	48 83 ec 20          	sub    $0x20,%rsp
    1222:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1226:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1229:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1230:	eb 4f                	jmp    1281 <gets+0x6b>
    cc = read(0, &c, 1);
    1232:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1236:	ba 01 00 00 00       	mov    $0x1,%edx
    123b:	48 89 c6             	mov    %rax,%rsi
    123e:	bf 00 00 00 00       	mov    $0x0,%edi
    1243:	48 b8 fb 13 00 00 00 	movabs $0x13fb,%rax
    124a:	00 00 00 
    124d:	ff d0                	callq  *%rax
    124f:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1252:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1256:	7e 36                	jle    128e <gets+0x78>
      break;
    buf[i++] = c;
    1258:	8b 45 fc             	mov    -0x4(%rbp),%eax
    125b:	8d 50 01             	lea    0x1(%rax),%edx
    125e:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1261:	48 63 d0             	movslq %eax,%rdx
    1264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1268:	48 01 c2             	add    %rax,%rdx
    126b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    126f:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1271:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1275:	3c 0a                	cmp    $0xa,%al
    1277:	74 16                	je     128f <gets+0x79>
    1279:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    127d:	3c 0d                	cmp    $0xd,%al
    127f:	74 0e                	je     128f <gets+0x79>
  for(i=0; i+1 < max; ){
    1281:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1284:	83 c0 01             	add    $0x1,%eax
    1287:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    128a:	7f a6                	jg     1232 <gets+0x1c>
    128c:	eb 01                	jmp    128f <gets+0x79>
      break;
    128e:	90                   	nop
      break;
  }
  buf[i] = '\0';
    128f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1292:	48 63 d0             	movslq %eax,%rdx
    1295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1299:	48 01 d0             	add    %rdx,%rax
    129c:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12a3:	c9                   	leaveq 
    12a4:	c3                   	retq   

00000000000012a5 <stat>:

int
stat(char *n, struct stat *st)
{
    12a5:	f3 0f 1e fa          	endbr64 
    12a9:	55                   	push   %rbp
    12aa:	48 89 e5             	mov    %rsp,%rbp
    12ad:	48 83 ec 20          	sub    $0x20,%rsp
    12b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12bd:	be 00 00 00 00       	mov    $0x0,%esi
    12c2:	48 89 c7             	mov    %rax,%rdi
    12c5:	48 b8 3c 14 00 00 00 	movabs $0x143c,%rax
    12cc:	00 00 00 
    12cf:	ff d0                	callq  *%rax
    12d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12d8:	79 07                	jns    12e1 <stat+0x3c>
    return -1;
    12da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12df:	eb 2f                	jmp    1310 <stat+0x6b>
  r = fstat(fd, st);
    12e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12e8:	48 89 d6             	mov    %rdx,%rsi
    12eb:	89 c7                	mov    %eax,%edi
    12ed:	48 b8 63 14 00 00 00 	movabs $0x1463,%rax
    12f4:	00 00 00 
    12f7:	ff d0                	callq  *%rax
    12f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    12fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12ff:	89 c7                	mov    %eax,%edi
    1301:	48 b8 15 14 00 00 00 	movabs $0x1415,%rax
    1308:	00 00 00 
    130b:	ff d0                	callq  *%rax
  return r;
    130d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1310:	c9                   	leaveq 
    1311:	c3                   	retq   

0000000000001312 <atoi>:

int
atoi(const char *s)
{
    1312:	f3 0f 1e fa          	endbr64 
    1316:	55                   	push   %rbp
    1317:	48 89 e5             	mov    %rsp,%rbp
    131a:	48 83 ec 18          	sub    $0x18,%rsp
    131e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1322:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1329:	eb 28                	jmp    1353 <atoi+0x41>
    n = n*10 + *s++ - '0';
    132b:	8b 55 fc             	mov    -0x4(%rbp),%edx
    132e:	89 d0                	mov    %edx,%eax
    1330:	c1 e0 02             	shl    $0x2,%eax
    1333:	01 d0                	add    %edx,%eax
    1335:	01 c0                	add    %eax,%eax
    1337:	89 c1                	mov    %eax,%ecx
    1339:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    133d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1341:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1345:	0f b6 00             	movzbl (%rax),%eax
    1348:	0f be c0             	movsbl %al,%eax
    134b:	01 c8                	add    %ecx,%eax
    134d:	83 e8 30             	sub    $0x30,%eax
    1350:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1357:	0f b6 00             	movzbl (%rax),%eax
    135a:	3c 2f                	cmp    $0x2f,%al
    135c:	7e 0b                	jle    1369 <atoi+0x57>
    135e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1362:	0f b6 00             	movzbl (%rax),%eax
    1365:	3c 39                	cmp    $0x39,%al
    1367:	7e c2                	jle    132b <atoi+0x19>
  return n;
    1369:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    136c:	c9                   	leaveq 
    136d:	c3                   	retq   

000000000000136e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    136e:	f3 0f 1e fa          	endbr64 
    1372:	55                   	push   %rbp
    1373:	48 89 e5             	mov    %rsp,%rbp
    1376:	48 83 ec 28          	sub    $0x28,%rsp
    137a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    137e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1382:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1389:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    138d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1391:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1395:	eb 1d                	jmp    13b4 <memmove+0x46>
    *dst++ = *src++;
    1397:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    139b:	48 8d 42 01          	lea    0x1(%rdx),%rax
    139f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13a7:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13ab:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13af:	0f b6 12             	movzbl (%rdx),%edx
    13b2:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13b7:	8d 50 ff             	lea    -0x1(%rax),%edx
    13ba:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13bd:	85 c0                	test   %eax,%eax
    13bf:	7f d6                	jg     1397 <memmove+0x29>
  return vdst;
    13c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13c5:	c9                   	leaveq 
    13c6:	c3                   	retq   

00000000000013c7 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13c7:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13ce:	49 89 ca             	mov    %rcx,%r10
    13d1:	0f 05                	syscall 
    13d3:	c3                   	retq   

00000000000013d4 <exit>:
SYSCALL(exit)
    13d4:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    13db:	49 89 ca             	mov    %rcx,%r10
    13de:	0f 05                	syscall 
    13e0:	c3                   	retq   

00000000000013e1 <wait>:
SYSCALL(wait)
    13e1:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13e8:	49 89 ca             	mov    %rcx,%r10
    13eb:	0f 05                	syscall 
    13ed:	c3                   	retq   

00000000000013ee <pipe>:
SYSCALL(pipe)
    13ee:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13f5:	49 89 ca             	mov    %rcx,%r10
    13f8:	0f 05                	syscall 
    13fa:	c3                   	retq   

00000000000013fb <read>:
SYSCALL(read)
    13fb:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1402:	49 89 ca             	mov    %rcx,%r10
    1405:	0f 05                	syscall 
    1407:	c3                   	retq   

0000000000001408 <write>:
SYSCALL(write)
    1408:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    140f:	49 89 ca             	mov    %rcx,%r10
    1412:	0f 05                	syscall 
    1414:	c3                   	retq   

0000000000001415 <close>:
SYSCALL(close)
    1415:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    141c:	49 89 ca             	mov    %rcx,%r10
    141f:	0f 05                	syscall 
    1421:	c3                   	retq   

0000000000001422 <kill>:
SYSCALL(kill)
    1422:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1429:	49 89 ca             	mov    %rcx,%r10
    142c:	0f 05                	syscall 
    142e:	c3                   	retq   

000000000000142f <exec>:
SYSCALL(exec)
    142f:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1436:	49 89 ca             	mov    %rcx,%r10
    1439:	0f 05                	syscall 
    143b:	c3                   	retq   

000000000000143c <open>:
SYSCALL(open)
    143c:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1443:	49 89 ca             	mov    %rcx,%r10
    1446:	0f 05                	syscall 
    1448:	c3                   	retq   

0000000000001449 <mknod>:
SYSCALL(mknod)
    1449:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1450:	49 89 ca             	mov    %rcx,%r10
    1453:	0f 05                	syscall 
    1455:	c3                   	retq   

0000000000001456 <unlink>:
SYSCALL(unlink)
    1456:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    145d:	49 89 ca             	mov    %rcx,%r10
    1460:	0f 05                	syscall 
    1462:	c3                   	retq   

0000000000001463 <fstat>:
SYSCALL(fstat)
    1463:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    146a:	49 89 ca             	mov    %rcx,%r10
    146d:	0f 05                	syscall 
    146f:	c3                   	retq   

0000000000001470 <link>:
SYSCALL(link)
    1470:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1477:	49 89 ca             	mov    %rcx,%r10
    147a:	0f 05                	syscall 
    147c:	c3                   	retq   

000000000000147d <mkdir>:
SYSCALL(mkdir)
    147d:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1484:	49 89 ca             	mov    %rcx,%r10
    1487:	0f 05                	syscall 
    1489:	c3                   	retq   

000000000000148a <chdir>:
SYSCALL(chdir)
    148a:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1491:	49 89 ca             	mov    %rcx,%r10
    1494:	0f 05                	syscall 
    1496:	c3                   	retq   

0000000000001497 <dup>:
SYSCALL(dup)
    1497:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    149e:	49 89 ca             	mov    %rcx,%r10
    14a1:	0f 05                	syscall 
    14a3:	c3                   	retq   

00000000000014a4 <getpid>:
SYSCALL(getpid)
    14a4:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14ab:	49 89 ca             	mov    %rcx,%r10
    14ae:	0f 05                	syscall 
    14b0:	c3                   	retq   

00000000000014b1 <sbrk>:
SYSCALL(sbrk)
    14b1:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14b8:	49 89 ca             	mov    %rcx,%r10
    14bb:	0f 05                	syscall 
    14bd:	c3                   	retq   

00000000000014be <sleep>:
SYSCALL(sleep)
    14be:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14c5:	49 89 ca             	mov    %rcx,%r10
    14c8:	0f 05                	syscall 
    14ca:	c3                   	retq   

00000000000014cb <uptime>:
SYSCALL(uptime)
    14cb:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14d2:	49 89 ca             	mov    %rcx,%r10
    14d5:	0f 05                	syscall 
    14d7:	c3                   	retq   

00000000000014d8 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    14d8:	f3 0f 1e fa          	endbr64 
    14dc:	55                   	push   %rbp
    14dd:	48 89 e5             	mov    %rsp,%rbp
    14e0:	48 83 ec 10          	sub    $0x10,%rsp
    14e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
    14e7:	89 f0                	mov    %esi,%eax
    14e9:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    14ec:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    14f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14f3:	ba 01 00 00 00       	mov    $0x1,%edx
    14f8:	48 89 ce             	mov    %rcx,%rsi
    14fb:	89 c7                	mov    %eax,%edi
    14fd:	48 b8 08 14 00 00 00 	movabs $0x1408,%rax
    1504:	00 00 00 
    1507:	ff d0                	callq  *%rax
}
    1509:	90                   	nop
    150a:	c9                   	leaveq 
    150b:	c3                   	retq   

000000000000150c <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    150c:	f3 0f 1e fa          	endbr64 
    1510:	55                   	push   %rbp
    1511:	48 89 e5             	mov    %rsp,%rbp
    1514:	48 83 ec 20          	sub    $0x20,%rsp
    1518:	89 7d ec             	mov    %edi,-0x14(%rbp)
    151b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    151f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1526:	eb 35                	jmp    155d <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1528:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    152c:	48 c1 e8 3c          	shr    $0x3c,%rax
    1530:	48 ba e0 25 00 00 00 	movabs $0x25e0,%rdx
    1537:	00 00 00 
    153a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    153e:	0f be d0             	movsbl %al,%edx
    1541:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1544:	89 d6                	mov    %edx,%esi
    1546:	89 c7                	mov    %eax,%edi
    1548:	48 b8 d8 14 00 00 00 	movabs $0x14d8,%rax
    154f:	00 00 00 
    1552:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1554:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1558:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    155d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1560:	83 f8 0f             	cmp    $0xf,%eax
    1563:	76 c3                	jbe    1528 <print_x64+0x1c>
}
    1565:	90                   	nop
    1566:	90                   	nop
    1567:	c9                   	leaveq 
    1568:	c3                   	retq   

0000000000001569 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1569:	f3 0f 1e fa          	endbr64 
    156d:	55                   	push   %rbp
    156e:	48 89 e5             	mov    %rsp,%rbp
    1571:	48 83 ec 20          	sub    $0x20,%rsp
    1575:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1578:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    157b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1582:	eb 36                	jmp    15ba <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1584:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1587:	c1 e8 1c             	shr    $0x1c,%eax
    158a:	89 c2                	mov    %eax,%edx
    158c:	48 b8 e0 25 00 00 00 	movabs $0x25e0,%rax
    1593:	00 00 00 
    1596:	89 d2                	mov    %edx,%edx
    1598:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    159c:	0f be d0             	movsbl %al,%edx
    159f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15a2:	89 d6                	mov    %edx,%esi
    15a4:	89 c7                	mov    %eax,%edi
    15a6:	48 b8 d8 14 00 00 00 	movabs $0x14d8,%rax
    15ad:	00 00 00 
    15b0:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15b6:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15bd:	83 f8 07             	cmp    $0x7,%eax
    15c0:	76 c2                	jbe    1584 <print_x32+0x1b>
}
    15c2:	90                   	nop
    15c3:	90                   	nop
    15c4:	c9                   	leaveq 
    15c5:	c3                   	retq   

00000000000015c6 <print_d>:

  static void
print_d(int fd, int v)
{
    15c6:	f3 0f 1e fa          	endbr64 
    15ca:	55                   	push   %rbp
    15cb:	48 89 e5             	mov    %rsp,%rbp
    15ce:	48 83 ec 30          	sub    $0x30,%rsp
    15d2:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15d5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    15d8:	8b 45 d8             	mov    -0x28(%rbp),%eax
    15db:	48 98                	cltq   
    15dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    15e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    15e5:	79 04                	jns    15eb <print_d+0x25>
    x = -x;
    15e7:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    15eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    15f2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15f6:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    15fd:	66 66 66 
    1600:	48 89 c8             	mov    %rcx,%rax
    1603:	48 f7 ea             	imul   %rdx
    1606:	48 c1 fa 02          	sar    $0x2,%rdx
    160a:	48 89 c8             	mov    %rcx,%rax
    160d:	48 c1 f8 3f          	sar    $0x3f,%rax
    1611:	48 29 c2             	sub    %rax,%rdx
    1614:	48 89 d0             	mov    %rdx,%rax
    1617:	48 c1 e0 02          	shl    $0x2,%rax
    161b:	48 01 d0             	add    %rdx,%rax
    161e:	48 01 c0             	add    %rax,%rax
    1621:	48 29 c1             	sub    %rax,%rcx
    1624:	48 89 ca             	mov    %rcx,%rdx
    1627:	8b 45 f4             	mov    -0xc(%rbp),%eax
    162a:	8d 48 01             	lea    0x1(%rax),%ecx
    162d:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1630:	48 b9 e0 25 00 00 00 	movabs $0x25e0,%rcx
    1637:	00 00 00 
    163a:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    163e:	48 98                	cltq   
    1640:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1644:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1648:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    164f:	66 66 66 
    1652:	48 89 c8             	mov    %rcx,%rax
    1655:	48 f7 ea             	imul   %rdx
    1658:	48 c1 fa 02          	sar    $0x2,%rdx
    165c:	48 89 c8             	mov    %rcx,%rax
    165f:	48 c1 f8 3f          	sar    $0x3f,%rax
    1663:	48 29 c2             	sub    %rax,%rdx
    1666:	48 89 d0             	mov    %rdx,%rax
    1669:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    166d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1672:	0f 85 7a ff ff ff    	jne    15f2 <print_d+0x2c>

  if (v < 0)
    1678:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    167c:	79 32                	jns    16b0 <print_d+0xea>
    buf[i++] = '-';
    167e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1681:	8d 50 01             	lea    0x1(%rax),%edx
    1684:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1687:	48 98                	cltq   
    1689:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    168e:	eb 20                	jmp    16b0 <print_d+0xea>
    putc(fd, buf[i]);
    1690:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1693:	48 98                	cltq   
    1695:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    169a:	0f be d0             	movsbl %al,%edx
    169d:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16a0:	89 d6                	mov    %edx,%esi
    16a2:	89 c7                	mov    %eax,%edi
    16a4:	48 b8 d8 14 00 00 00 	movabs $0x14d8,%rax
    16ab:	00 00 00 
    16ae:	ff d0                	callq  *%rax
  while (--i >= 0)
    16b0:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16b8:	79 d6                	jns    1690 <print_d+0xca>
}
    16ba:	90                   	nop
    16bb:	90                   	nop
    16bc:	c9                   	leaveq 
    16bd:	c3                   	retq   

00000000000016be <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16be:	f3 0f 1e fa          	endbr64 
    16c2:	55                   	push   %rbp
    16c3:	48 89 e5             	mov    %rsp,%rbp
    16c6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16cd:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16d3:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    16da:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    16e1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    16e8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    16ef:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    16f6:	84 c0                	test   %al,%al
    16f8:	74 20                	je     171a <printf+0x5c>
    16fa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    16fe:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1702:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1706:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    170a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    170e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1712:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1716:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    171a:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1721:	00 00 00 
    1724:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    172b:	00 00 00 
    172e:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1732:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1739:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1740:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1747:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    174e:	00 00 00 
    1751:	e9 41 03 00 00       	jmpq   1a97 <printf+0x3d9>
    if (c != '%') {
    1756:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    175d:	74 24                	je     1783 <printf+0xc5>
      putc(fd, c);
    175f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1765:	0f be d0             	movsbl %al,%edx
    1768:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    176e:	89 d6                	mov    %edx,%esi
    1770:	89 c7                	mov    %eax,%edi
    1772:	48 b8 d8 14 00 00 00 	movabs $0x14d8,%rax
    1779:	00 00 00 
    177c:	ff d0                	callq  *%rax
      continue;
    177e:	e9 0d 03 00 00       	jmpq   1a90 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1783:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    178a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1790:	48 63 d0             	movslq %eax,%rdx
    1793:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    179a:	48 01 d0             	add    %rdx,%rax
    179d:	0f b6 00             	movzbl (%rax),%eax
    17a0:	0f be c0             	movsbl %al,%eax
    17a3:	25 ff 00 00 00       	and    $0xff,%eax
    17a8:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17ae:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17b5:	0f 84 0f 03 00 00    	je     1aca <printf+0x40c>
      break;
    switch(c) {
    17bb:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17c2:	0f 84 74 02 00 00    	je     1a3c <printf+0x37e>
    17c8:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17cf:	0f 8c 82 02 00 00    	jl     1a57 <printf+0x399>
    17d5:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17dc:	0f 8f 75 02 00 00    	jg     1a57 <printf+0x399>
    17e2:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    17e9:	0f 8c 68 02 00 00    	jl     1a57 <printf+0x399>
    17ef:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    17f5:	83 e8 63             	sub    $0x63,%eax
    17f8:	83 f8 15             	cmp    $0x15,%eax
    17fb:	0f 87 56 02 00 00    	ja     1a57 <printf+0x399>
    1801:	89 c0                	mov    %eax,%eax
    1803:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    180a:	00 
    180b:	48 b8 f0 21 00 00 00 	movabs $0x21f0,%rax
    1812:	00 00 00 
    1815:	48 01 d0             	add    %rdx,%rax
    1818:	48 8b 00             	mov    (%rax),%rax
    181b:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    181e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1824:	83 f8 2f             	cmp    $0x2f,%eax
    1827:	77 23                	ja     184c <printf+0x18e>
    1829:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1830:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1836:	89 d2                	mov    %edx,%edx
    1838:	48 01 d0             	add    %rdx,%rax
    183b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1841:	83 c2 08             	add    $0x8,%edx
    1844:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    184a:	eb 12                	jmp    185e <printf+0x1a0>
    184c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1853:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1857:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    185e:	8b 00                	mov    (%rax),%eax
    1860:	0f be d0             	movsbl %al,%edx
    1863:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1869:	89 d6                	mov    %edx,%esi
    186b:	89 c7                	mov    %eax,%edi
    186d:	48 b8 d8 14 00 00 00 	movabs $0x14d8,%rax
    1874:	00 00 00 
    1877:	ff d0                	callq  *%rax
      break;
    1879:	e9 12 02 00 00       	jmpq   1a90 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    187e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1884:	83 f8 2f             	cmp    $0x2f,%eax
    1887:	77 23                	ja     18ac <printf+0x1ee>
    1889:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1890:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1896:	89 d2                	mov    %edx,%edx
    1898:	48 01 d0             	add    %rdx,%rax
    189b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18a1:	83 c2 08             	add    $0x8,%edx
    18a4:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18aa:	eb 12                	jmp    18be <printf+0x200>
    18ac:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18b3:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18b7:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18be:	8b 10                	mov    (%rax),%edx
    18c0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18c6:	89 d6                	mov    %edx,%esi
    18c8:	89 c7                	mov    %eax,%edi
    18ca:	48 b8 c6 15 00 00 00 	movabs $0x15c6,%rax
    18d1:	00 00 00 
    18d4:	ff d0                	callq  *%rax
      break;
    18d6:	e9 b5 01 00 00       	jmpq   1a90 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    18db:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18e1:	83 f8 2f             	cmp    $0x2f,%eax
    18e4:	77 23                	ja     1909 <printf+0x24b>
    18e6:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18ed:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18f3:	89 d2                	mov    %edx,%edx
    18f5:	48 01 d0             	add    %rdx,%rax
    18f8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18fe:	83 c2 08             	add    $0x8,%edx
    1901:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1907:	eb 12                	jmp    191b <printf+0x25d>
    1909:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1910:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1914:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    191b:	8b 10                	mov    (%rax),%edx
    191d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1923:	89 d6                	mov    %edx,%esi
    1925:	89 c7                	mov    %eax,%edi
    1927:	48 b8 69 15 00 00 00 	movabs $0x1569,%rax
    192e:	00 00 00 
    1931:	ff d0                	callq  *%rax
      break;
    1933:	e9 58 01 00 00       	jmpq   1a90 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1938:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    193e:	83 f8 2f             	cmp    $0x2f,%eax
    1941:	77 23                	ja     1966 <printf+0x2a8>
    1943:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    194a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1950:	89 d2                	mov    %edx,%edx
    1952:	48 01 d0             	add    %rdx,%rax
    1955:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    195b:	83 c2 08             	add    $0x8,%edx
    195e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1964:	eb 12                	jmp    1978 <printf+0x2ba>
    1966:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    196d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1971:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1978:	48 8b 10             	mov    (%rax),%rdx
    197b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1981:	48 89 d6             	mov    %rdx,%rsi
    1984:	89 c7                	mov    %eax,%edi
    1986:	48 b8 0c 15 00 00 00 	movabs $0x150c,%rax
    198d:	00 00 00 
    1990:	ff d0                	callq  *%rax
      break;
    1992:	e9 f9 00 00 00       	jmpq   1a90 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1997:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    199d:	83 f8 2f             	cmp    $0x2f,%eax
    19a0:	77 23                	ja     19c5 <printf+0x307>
    19a2:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19a9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19af:	89 d2                	mov    %edx,%edx
    19b1:	48 01 d0             	add    %rdx,%rax
    19b4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19ba:	83 c2 08             	add    $0x8,%edx
    19bd:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19c3:	eb 12                	jmp    19d7 <printf+0x319>
    19c5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19cc:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19d0:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19d7:	48 8b 00             	mov    (%rax),%rax
    19da:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    19e1:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    19e8:	00 
    19e9:	75 41                	jne    1a2c <printf+0x36e>
        s = "(null)";
    19eb:	48 b8 e8 21 00 00 00 	movabs $0x21e8,%rax
    19f2:	00 00 00 
    19f5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    19fc:	eb 2e                	jmp    1a2c <printf+0x36e>
        putc(fd, *(s++));
    19fe:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a05:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a09:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a10:	0f b6 00             	movzbl (%rax),%eax
    1a13:	0f be d0             	movsbl %al,%edx
    1a16:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a1c:	89 d6                	mov    %edx,%esi
    1a1e:	89 c7                	mov    %eax,%edi
    1a20:	48 b8 d8 14 00 00 00 	movabs $0x14d8,%rax
    1a27:	00 00 00 
    1a2a:	ff d0                	callq  *%rax
      while (*s)
    1a2c:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a33:	0f b6 00             	movzbl (%rax),%eax
    1a36:	84 c0                	test   %al,%al
    1a38:	75 c4                	jne    19fe <printf+0x340>
      break;
    1a3a:	eb 54                	jmp    1a90 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a3c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a42:	be 25 00 00 00       	mov    $0x25,%esi
    1a47:	89 c7                	mov    %eax,%edi
    1a49:	48 b8 d8 14 00 00 00 	movabs $0x14d8,%rax
    1a50:	00 00 00 
    1a53:	ff d0                	callq  *%rax
      break;
    1a55:	eb 39                	jmp    1a90 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a57:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a5d:	be 25 00 00 00       	mov    $0x25,%esi
    1a62:	89 c7                	mov    %eax,%edi
    1a64:	48 b8 d8 14 00 00 00 	movabs $0x14d8,%rax
    1a6b:	00 00 00 
    1a6e:	ff d0                	callq  *%rax
      putc(fd, c);
    1a70:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a76:	0f be d0             	movsbl %al,%edx
    1a79:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a7f:	89 d6                	mov    %edx,%esi
    1a81:	89 c7                	mov    %eax,%edi
    1a83:	48 b8 d8 14 00 00 00 	movabs $0x14d8,%rax
    1a8a:	00 00 00 
    1a8d:	ff d0                	callq  *%rax
      break;
    1a8f:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1a90:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1a97:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1a9d:	48 63 d0             	movslq %eax,%rdx
    1aa0:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1aa7:	48 01 d0             	add    %rdx,%rax
    1aaa:	0f b6 00             	movzbl (%rax),%eax
    1aad:	0f be c0             	movsbl %al,%eax
    1ab0:	25 ff 00 00 00       	and    $0xff,%eax
    1ab5:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1abb:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ac2:	0f 85 8e fc ff ff    	jne    1756 <printf+0x98>
    }
  }
}
    1ac8:	eb 01                	jmp    1acb <printf+0x40d>
      break;
    1aca:	90                   	nop
}
    1acb:	90                   	nop
    1acc:	c9                   	leaveq 
    1acd:	c3                   	retq   

0000000000001ace <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ace:	f3 0f 1e fa          	endbr64 
    1ad2:	55                   	push   %rbp
    1ad3:	48 89 e5             	mov    %rsp,%rbp
    1ad6:	48 83 ec 18          	sub    $0x18,%rsp
    1ada:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1ade:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ae2:	48 83 e8 10          	sub    $0x10,%rax
    1ae6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1aea:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    1af1:	00 00 00 
    1af4:	48 8b 00             	mov    (%rax),%rax
    1af7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1afb:	eb 2f                	jmp    1b2c <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1afd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b01:	48 8b 00             	mov    (%rax),%rax
    1b04:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b08:	72 17                	jb     1b21 <free+0x53>
    1b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b0e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b12:	77 2f                	ja     1b43 <free+0x75>
    1b14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b18:	48 8b 00             	mov    (%rax),%rax
    1b1b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b1f:	72 22                	jb     1b43 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b25:	48 8b 00             	mov    (%rax),%rax
    1b28:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b30:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b34:	76 c7                	jbe    1afd <free+0x2f>
    1b36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b3a:	48 8b 00             	mov    (%rax),%rax
    1b3d:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b41:	73 ba                	jae    1afd <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b47:	8b 40 08             	mov    0x8(%rax),%eax
    1b4a:	89 c0                	mov    %eax,%eax
    1b4c:	48 c1 e0 04          	shl    $0x4,%rax
    1b50:	48 89 c2             	mov    %rax,%rdx
    1b53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b57:	48 01 c2             	add    %rax,%rdx
    1b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b5e:	48 8b 00             	mov    (%rax),%rax
    1b61:	48 39 c2             	cmp    %rax,%rdx
    1b64:	75 2d                	jne    1b93 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1b66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b6a:	8b 50 08             	mov    0x8(%rax),%edx
    1b6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b71:	48 8b 00             	mov    (%rax),%rax
    1b74:	8b 40 08             	mov    0x8(%rax),%eax
    1b77:	01 c2                	add    %eax,%edx
    1b79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b7d:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b84:	48 8b 00             	mov    (%rax),%rax
    1b87:	48 8b 10             	mov    (%rax),%rdx
    1b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b8e:	48 89 10             	mov    %rdx,(%rax)
    1b91:	eb 0e                	jmp    1ba1 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1b93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b97:	48 8b 10             	mov    (%rax),%rdx
    1b9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b9e:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1ba1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ba5:	8b 40 08             	mov    0x8(%rax),%eax
    1ba8:	89 c0                	mov    %eax,%eax
    1baa:	48 c1 e0 04          	shl    $0x4,%rax
    1bae:	48 89 c2             	mov    %rax,%rdx
    1bb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bb5:	48 01 d0             	add    %rdx,%rax
    1bb8:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bbc:	75 27                	jne    1be5 <free+0x117>
    p->s.size += bp->s.size;
    1bbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bc2:	8b 50 08             	mov    0x8(%rax),%edx
    1bc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bc9:	8b 40 08             	mov    0x8(%rax),%eax
    1bcc:	01 c2                	add    %eax,%edx
    1bce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd2:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd9:	48 8b 10             	mov    (%rax),%rdx
    1bdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be0:	48 89 10             	mov    %rdx,(%rax)
    1be3:	eb 0b                	jmp    1bf0 <free+0x122>
  } else
    p->s.ptr = bp;
    1be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1bed:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1bf0:	48 ba 10 26 00 00 00 	movabs $0x2610,%rdx
    1bf7:	00 00 00 
    1bfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfe:	48 89 02             	mov    %rax,(%rdx)
}
    1c01:	90                   	nop
    1c02:	c9                   	leaveq 
    1c03:	c3                   	retq   

0000000000001c04 <morecore>:

static Header*
morecore(uint nu)
{
    1c04:	f3 0f 1e fa          	endbr64 
    1c08:	55                   	push   %rbp
    1c09:	48 89 e5             	mov    %rsp,%rbp
    1c0c:	48 83 ec 20          	sub    $0x20,%rsp
    1c10:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c13:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c1a:	77 07                	ja     1c23 <morecore+0x1f>
    nu = 4096;
    1c1c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c23:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c26:	48 c1 e0 04          	shl    $0x4,%rax
    1c2a:	48 89 c7             	mov    %rax,%rdi
    1c2d:	48 b8 b1 14 00 00 00 	movabs $0x14b1,%rax
    1c34:	00 00 00 
    1c37:	ff d0                	callq  *%rax
    1c39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c3d:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c42:	75 07                	jne    1c4b <morecore+0x47>
    return 0;
    1c44:	b8 00 00 00 00       	mov    $0x0,%eax
    1c49:	eb 36                	jmp    1c81 <morecore+0x7d>
  hp = (Header*)p;
    1c4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c57:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c5a:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c61:	48 83 c0 10          	add    $0x10,%rax
    1c65:	48 89 c7             	mov    %rax,%rdi
    1c68:	48 b8 ce 1a 00 00 00 	movabs $0x1ace,%rax
    1c6f:	00 00 00 
    1c72:	ff d0                	callq  *%rax
  return freep;
    1c74:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    1c7b:	00 00 00 
    1c7e:	48 8b 00             	mov    (%rax),%rax
}
    1c81:	c9                   	leaveq 
    1c82:	c3                   	retq   

0000000000001c83 <malloc>:

void*
malloc(uint nbytes)
{
    1c83:	f3 0f 1e fa          	endbr64 
    1c87:	55                   	push   %rbp
    1c88:	48 89 e5             	mov    %rsp,%rbp
    1c8b:	48 83 ec 30          	sub    $0x30,%rsp
    1c8f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c92:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1c95:	48 83 c0 0f          	add    $0xf,%rax
    1c99:	48 c1 e8 04          	shr    $0x4,%rax
    1c9d:	83 c0 01             	add    $0x1,%eax
    1ca0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1ca3:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    1caa:	00 00 00 
    1cad:	48 8b 00             	mov    (%rax),%rax
    1cb0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cb4:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cb9:	75 4a                	jne    1d05 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1cbb:	48 b8 00 26 00 00 00 	movabs $0x2600,%rax
    1cc2:	00 00 00 
    1cc5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cc9:	48 ba 10 26 00 00 00 	movabs $0x2610,%rdx
    1cd0:	00 00 00 
    1cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd7:	48 89 02             	mov    %rax,(%rdx)
    1cda:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    1ce1:	00 00 00 
    1ce4:	48 8b 00             	mov    (%rax),%rax
    1ce7:	48 ba 00 26 00 00 00 	movabs $0x2600,%rdx
    1cee:	00 00 00 
    1cf1:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1cf4:	48 b8 00 26 00 00 00 	movabs $0x2600,%rax
    1cfb:	00 00 00 
    1cfe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d09:	48 8b 00             	mov    (%rax),%rax
    1d0c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d14:	8b 40 08             	mov    0x8(%rax),%eax
    1d17:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d1a:	77 65                	ja     1d81 <malloc+0xfe>
      if(p->s.size == nunits)
    1d1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d20:	8b 40 08             	mov    0x8(%rax),%eax
    1d23:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d26:	75 10                	jne    1d38 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2c:	48 8b 10             	mov    (%rax),%rdx
    1d2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d33:	48 89 10             	mov    %rdx,(%rax)
    1d36:	eb 2e                	jmp    1d66 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d3c:	8b 40 08             	mov    0x8(%rax),%eax
    1d3f:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d42:	89 c2                	mov    %eax,%edx
    1d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d48:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4f:	8b 40 08             	mov    0x8(%rax),%eax
    1d52:	89 c0                	mov    %eax,%eax
    1d54:	48 c1 e0 04          	shl    $0x4,%rax
    1d58:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d60:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d63:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d66:	48 ba 10 26 00 00 00 	movabs $0x2610,%rdx
    1d6d:	00 00 00 
    1d70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d74:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7b:	48 83 c0 10          	add    $0x10,%rax
    1d7f:	eb 4e                	jmp    1dcf <malloc+0x14c>
    }
    if(p == freep)
    1d81:	48 b8 10 26 00 00 00 	movabs $0x2610,%rax
    1d88:	00 00 00 
    1d8b:	48 8b 00             	mov    (%rax),%rax
    1d8e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d92:	75 23                	jne    1db7 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1d94:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d97:	89 c7                	mov    %eax,%edi
    1d99:	48 b8 04 1c 00 00 00 	movabs $0x1c04,%rax
    1da0:	00 00 00 
    1da3:	ff d0                	callq  *%rax
    1da5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1da9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1dae:	75 07                	jne    1db7 <malloc+0x134>
        return 0;
    1db0:	b8 00 00 00 00       	mov    $0x0,%eax
    1db5:	eb 18                	jmp    1dcf <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1db7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dbb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc3:	48 8b 00             	mov    (%rax),%rax
    1dc6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1dca:	e9 41 ff ff ff       	jmpq   1d10 <malloc+0x8d>
  }
}
    1dcf:	c9                   	leaveq 
    1dd0:	c3                   	retq   

0000000000001dd1 <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1dd1:	f3 0f 1e fa          	endbr64 
    1dd5:	55                   	push   %rbp
    1dd6:	48 89 e5             	mov    %rsp,%rbp
    1dd9:	48 83 ec 30          	sub    $0x30,%rsp
    1ddd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1de1:	bf 18 00 00 00       	mov    $0x18,%edi
    1de6:	48 b8 83 1c 00 00 00 	movabs $0x1c83,%rax
    1ded:	00 00 00 
    1df0:	ff d0                	callq  *%rax
    1df2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1df6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1dfb:	75 0a                	jne    1e07 <co_new+0x36>
    return 0;
    1dfd:	b8 00 00 00 00       	mov    $0x0,%eax
    1e02:	e9 e1 00 00 00       	jmpq   1ee8 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1e07:	bf 00 20 00 00       	mov    $0x2000,%edi
    1e0c:	48 b8 83 1c 00 00 00 	movabs $0x1c83,%rax
    1e13:	00 00 00 
    1e16:	ff d0                	callq  *%rax
    1e18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1e1c:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1e20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e24:	48 8b 40 10          	mov    0x10(%rax),%rax
    1e28:	48 85 c0             	test   %rax,%rax
    1e2b:	75 1d                	jne    1e4a <co_new+0x79>
    free(co1);
    1e2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e31:	48 89 c7             	mov    %rax,%rdi
    1e34:	48 b8 ce 1a 00 00 00 	movabs $0x1ace,%rax
    1e3b:	00 00 00 
    1e3e:	ff d0                	callq  *%rax
    return 0;
    1e40:	b8 00 00 00 00       	mov    $0x0,%eax
    1e45:	e9 9e 00 00 00       	jmpq   1ee8 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1e4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e4e:	48 8b 40 10          	mov    0x10(%rax),%rax
    1e52:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    1e58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    1e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e60:	48 8d 50 30          	lea    0x30(%rax),%rdx
    1e64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1e68:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    1e6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e6f:	48 83 c0 38          	add    $0x38,%rax
    1e73:	48 ba 5a 20 00 00 00 	movabs $0x205a,%rdx
    1e7a:	00 00 00 
    1e7d:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    1e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1e88:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    1e8b:	48 b8 28 26 00 00 00 	movabs $0x2628,%rax
    1e92:	00 00 00 
    1e95:	48 8b 00             	mov    (%rax),%rax
    1e98:	48 85 c0             	test   %rax,%rax
    1e9b:	75 13                	jne    1eb0 <co_new+0xdf>
  {
  	co_list = co1;
    1e9d:	48 ba 28 26 00 00 00 	movabs $0x2628,%rdx
    1ea4:	00 00 00 
    1ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1eab:	48 89 02             	mov    %rax,(%rdx)
    1eae:	eb 34                	jmp    1ee4 <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    1eb0:	48 b8 28 26 00 00 00 	movabs $0x2628,%rax
    1eb7:	00 00 00 
    1eba:	48 8b 00             	mov    (%rax),%rax
    1ebd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1ec1:	eb 0c                	jmp    1ecf <co_new+0xfe>
	{
		head = head->next;
    1ec3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ec7:	48 8b 40 08          	mov    0x8(%rax),%rax
    1ecb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    1ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ed3:	48 8b 40 08          	mov    0x8(%rax),%rax
    1ed7:	48 85 c0             	test   %rax,%rax
    1eda:	75 e7                	jne    1ec3 <co_new+0xf2>
	}
	head = co1;
    1edc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ee0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    1ee4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    1ee8:	c9                   	leaveq 
    1ee9:	c3                   	retq   

0000000000001eea <co_run>:

  int
co_run(void)
{
    1eea:	f3 0f 1e fa          	endbr64 
    1eee:	55                   	push   %rbp
    1eef:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    1ef2:	48 b8 28 26 00 00 00 	movabs $0x2628,%rax
    1ef9:	00 00 00 
    1efc:	48 8b 00             	mov    (%rax),%rax
    1eff:	48 85 c0             	test   %rax,%rax
    1f02:	74 4a                	je     1f4e <co_run+0x64>
	{
		co_current = co_list;
    1f04:	48 b8 28 26 00 00 00 	movabs $0x2628,%rax
    1f0b:	00 00 00 
    1f0e:	48 8b 00             	mov    (%rax),%rax
    1f11:	48 ba 20 26 00 00 00 	movabs $0x2620,%rdx
    1f18:	00 00 00 
    1f1b:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    1f1e:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    1f25:	00 00 00 
    1f28:	48 8b 00             	mov    (%rax),%rax
    1f2b:	48 8b 00             	mov    (%rax),%rax
    1f2e:	48 89 c6             	mov    %rax,%rsi
    1f31:	48 bf 18 26 00 00 00 	movabs $0x2618,%rdi
    1f38:	00 00 00 
    1f3b:	48 b8 bc 21 00 00 00 	movabs $0x21bc,%rax
    1f42:	00 00 00 
    1f45:	ff d0                	callq  *%rax
		return 1;
    1f47:	b8 01 00 00 00       	mov    $0x1,%eax
    1f4c:	eb 05                	jmp    1f53 <co_run+0x69>
	}
	return 0;
    1f4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1f53:	5d                   	pop    %rbp
    1f54:	c3                   	retq   

0000000000001f55 <co_run_all>:

  int
co_run_all(void)
{
    1f55:	f3 0f 1e fa          	endbr64 
    1f59:	55                   	push   %rbp
    1f5a:	48 89 e5             	mov    %rsp,%rbp
    1f5d:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    1f61:	48 b8 28 26 00 00 00 	movabs $0x2628,%rax
    1f68:	00 00 00 
    1f6b:	48 8b 00             	mov    (%rax),%rax
    1f6e:	48 85 c0             	test   %rax,%rax
    1f71:	75 07                	jne    1f7a <co_run_all+0x25>
		return 0;
    1f73:	b8 00 00 00 00       	mov    $0x0,%eax
    1f78:	eb 37                	jmp    1fb1 <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    1f7a:	48 b8 28 26 00 00 00 	movabs $0x2628,%rax
    1f81:	00 00 00 
    1f84:	48 8b 00             	mov    (%rax),%rax
    1f87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    1f8b:	eb 18                	jmp    1fa5 <co_run_all+0x50>
			co_run();
    1f8d:	48 b8 ea 1e 00 00 00 	movabs $0x1eea,%rax
    1f94:	00 00 00 
    1f97:	ff d0                	callq  *%rax
			tmp = tmp->next;
    1f99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f9d:	48 8b 40 08          	mov    0x8(%rax),%rax
    1fa1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    1fa5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1faa:	75 e1                	jne    1f8d <co_run_all+0x38>
		}
		return 1;
    1fac:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    1fb1:	c9                   	leaveq 
    1fb2:	c3                   	retq   

0000000000001fb3 <co_yield>:

  void
co_yield()
{
    1fb3:	f3 0f 1e fa          	endbr64 
    1fb7:	55                   	push   %rbp
    1fb8:	48 89 e5             	mov    %rsp,%rbp
    1fbb:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    1fbf:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    1fc6:	00 00 00 
    1fc9:	48 8b 00             	mov    (%rax),%rax
    1fcc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    1fd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd4:	48 8b 40 08          	mov    0x8(%rax),%rax
    1fd8:	48 85 c0             	test   %rax,%rax
    1fdb:	74 46                	je     2023 <co_yield+0x70>
  {
  	co_current = co_current->next;
    1fdd:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    1fe4:	00 00 00 
    1fe7:	48 8b 00             	mov    (%rax),%rax
    1fea:	48 8b 40 08          	mov    0x8(%rax),%rax
    1fee:	48 ba 20 26 00 00 00 	movabs $0x2620,%rdx
    1ff5:	00 00 00 
    1ff8:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    1ffb:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    2002:	00 00 00 
    2005:	48 8b 00             	mov    (%rax),%rax
    2008:	48 8b 10             	mov    (%rax),%rdx
    200b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    200f:	48 89 d6             	mov    %rdx,%rsi
    2012:	48 89 c7             	mov    %rax,%rdi
    2015:	48 b8 bc 21 00 00 00 	movabs $0x21bc,%rax
    201c:	00 00 00 
    201f:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    2021:	eb 34                	jmp    2057 <co_yield+0xa4>
	co_current = 0;
    2023:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    202a:	00 00 00 
    202d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    2034:	48 b8 18 26 00 00 00 	movabs $0x2618,%rax
    203b:	00 00 00 
    203e:	48 8b 10             	mov    (%rax),%rdx
    2041:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2045:	48 89 d6             	mov    %rdx,%rsi
    2048:	48 89 c7             	mov    %rax,%rdi
    204b:	48 b8 bc 21 00 00 00 	movabs $0x21bc,%rax
    2052:	00 00 00 
    2055:	ff d0                	callq  *%rax
}
    2057:	90                   	nop
    2058:	c9                   	leaveq 
    2059:	c3                   	retq   

000000000000205a <co_exit>:

  void
co_exit(void)
{
    205a:	f3 0f 1e fa          	endbr64 
    205e:	55                   	push   %rbp
    205f:	48 89 e5             	mov    %rsp,%rbp
    2062:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    2066:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    206d:	00 00 00 
    2070:	48 8b 00             	mov    (%rax),%rax
    2073:	48 85 c0             	test   %rax,%rax
    2076:	0f 84 ec 00 00 00    	je     2168 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    207c:	48 b8 28 26 00 00 00 	movabs $0x2628,%rax
    2083:	00 00 00 
    2086:	48 8b 00             	mov    (%rax),%rax
    2089:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    208d:	e9 c9 00 00 00       	jmpq   215b <co_exit+0x101>
		if(tmp == co_current)
    2092:	48 b8 20 26 00 00 00 	movabs $0x2620,%rax
    2099:	00 00 00 
    209c:	48 8b 00             	mov    (%rax),%rax
    209f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    20a3:	0f 85 9e 00 00 00    	jne    2147 <co_exit+0xed>
		{
			if(tmp->next)
    20a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20ad:	48 8b 40 08          	mov    0x8(%rax),%rax
    20b1:	48 85 c0             	test   %rax,%rax
    20b4:	74 54                	je     210a <co_exit+0xb0>
			{
				if(prev)
    20b6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20bb:	74 10                	je     20cd <co_exit+0x73>
				{
					prev->next = tmp->next;
    20bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20c1:	48 8b 50 08          	mov    0x8(%rax),%rdx
    20c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20c9:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    20cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20d1:	48 8b 40 08          	mov    0x8(%rax),%rax
    20d5:	48 ba 28 26 00 00 00 	movabs $0x2628,%rdx
    20dc:	00 00 00 
    20df:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    20e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20e6:	48 8b 00             	mov    (%rax),%rax
    20e9:	48 ba 20 26 00 00 00 	movabs $0x2620,%rdx
    20f0:	00 00 00 
    20f3:	48 8b 12             	mov    (%rdx),%rdx
    20f6:	48 89 c6             	mov    %rax,%rsi
    20f9:	48 89 d7             	mov    %rdx,%rdi
    20fc:	48 b8 bc 21 00 00 00 	movabs $0x21bc,%rax
    2103:	00 00 00 
    2106:	ff d0                	callq  *%rax
    2108:	eb 3d                	jmp    2147 <co_exit+0xed>
			}else{
				co_list = 0;
    210a:	48 b8 28 26 00 00 00 	movabs $0x2628,%rax
    2111:	00 00 00 
    2114:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    211b:	48 b8 18 26 00 00 00 	movabs $0x2618,%rax
    2122:	00 00 00 
    2125:	48 8b 00             	mov    (%rax),%rax
    2128:	48 ba 20 26 00 00 00 	movabs $0x2620,%rdx
    212f:	00 00 00 
    2132:	48 8b 12             	mov    (%rdx),%rdx
    2135:	48 89 c6             	mov    %rax,%rsi
    2138:	48 89 d7             	mov    %rdx,%rdi
    213b:	48 b8 bc 21 00 00 00 	movabs $0x21bc,%rax
    2142:	00 00 00 
    2145:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    2147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    214b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    214f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2153:	48 8b 40 08          	mov    0x8(%rax),%rax
    2157:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    215b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2160:	0f 85 2c ff ff ff    	jne    2092 <co_exit+0x38>
    2166:	eb 01                	jmp    2169 <co_exit+0x10f>
		return;
    2168:	90                   	nop
	}
}
    2169:	c9                   	leaveq 
    216a:	c3                   	retq   

000000000000216b <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    216b:	f3 0f 1e fa          	endbr64 
    216f:	55                   	push   %rbp
    2170:	48 89 e5             	mov    %rsp,%rbp
    2173:	48 83 ec 10          	sub    $0x10,%rsp
    2177:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    217b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2180:	74 37                	je     21b9 <co_destroy+0x4e>
    if (co->stack)
    2182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2186:	48 8b 40 10          	mov    0x10(%rax),%rax
    218a:	48 85 c0             	test   %rax,%rax
    218d:	74 17                	je     21a6 <co_destroy+0x3b>
      free(co->stack);
    218f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2193:	48 8b 40 10          	mov    0x10(%rax),%rax
    2197:	48 89 c7             	mov    %rax,%rdi
    219a:	48 b8 ce 1a 00 00 00 	movabs $0x1ace,%rax
    21a1:	00 00 00 
    21a4:	ff d0                	callq  *%rax
    free(co);
    21a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21aa:	48 89 c7             	mov    %rax,%rdi
    21ad:	48 b8 ce 1a 00 00 00 	movabs $0x1ace,%rax
    21b4:	00 00 00 
    21b7:	ff d0                	callq  *%rax
  }
}
    21b9:	90                   	nop
    21ba:	c9                   	leaveq 
    21bb:	c3                   	retq   

00000000000021bc <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    21bc:	55                   	push   %rbp
  pushq   %rbx
    21bd:	53                   	push   %rbx
  pushq   %r12
    21be:	41 54                	push   %r12
  pushq   %r13
    21c0:	41 55                	push   %r13
  pushq   %r14
    21c2:	41 56                	push   %r14
  pushq   %r15
    21c4:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    21c6:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    21c9:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    21cc:	41 5f                	pop    %r15
  popq    %r14
    21ce:	41 5e                	pop    %r14
  popq    %r13
    21d0:	41 5d                	pop    %r13
  popq    %r12
    21d2:	41 5c                	pop    %r12
  popq    %rbx
    21d4:	5b                   	pop    %rbx
  popq    %rbp
    21d5:	5d                   	pop    %rbp

  retq #??
    21d6:	c3                   	retq   
