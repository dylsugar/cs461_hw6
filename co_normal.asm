
_co_normal:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <co_take_turns>:
static int nr_tasks;
static volatile int shared_var = 0;

  void
co_take_turns(void)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 10          	sub    $0x10,%rsp
  const int rank = shared_var++;
    100c:	48 b8 f4 28 00 00 00 	movabs $0x28f4,%rax
    1013:	00 00 00 
    1016:	8b 00                	mov    (%rax),%eax
    1018:	8d 50 01             	lea    0x1(%rax),%edx
    101b:	48 b9 f4 28 00 00 00 	movabs $0x28f4,%rcx
    1022:	00 00 00 
    1025:	89 11                	mov    %edx,(%rcx)
    1027:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (int i = 0; i < 6; i++) {
    102a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1031:	e9 a0 00 00 00       	jmpq   10d6 <co_take_turns+0xd6>
    co_yield();
    1036:	48 b8 68 21 00 00 00 	movabs $0x2168,%rax
    103d:	00 00 00 
    1040:	ff d0                	callq  *%rax
    if (rank == (shared_var % nr_tasks)) {
    1042:	48 b8 f4 28 00 00 00 	movabs $0x28f4,%rax
    1049:	00 00 00 
    104c:	8b 00                	mov    (%rax),%eax
    104e:	48 ba f0 28 00 00 00 	movabs $0x28f0,%rdx
    1055:	00 00 00 
    1058:	8b 0a                	mov    (%rdx),%ecx
    105a:	99                   	cltd   
    105b:	f7 f9                	idiv   %ecx
    105d:	89 d0                	mov    %edx,%eax
    105f:	39 45 f8             	cmp    %eax,-0x8(%rbp)
    1062:	75 42                	jne    10a6 <co_take_turns+0xa6>
      printf(1, " %d", rank);
    1064:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1067:	89 c2                	mov    %eax,%edx
    1069:	48 be 90 23 00 00 00 	movabs $0x2390,%rsi
    1070:	00 00 00 
    1073:	bf 01 00 00 00       	mov    $0x1,%edi
    1078:	b8 00 00 00 00       	mov    $0x0,%eax
    107d:	48 b9 73 18 00 00 00 	movabs $0x1873,%rcx
    1084:	00 00 00 
    1087:	ff d1                	callq  *%rcx
      shared_var++;
    1089:	48 b8 f4 28 00 00 00 	movabs $0x28f4,%rax
    1090:	00 00 00 
    1093:	8b 00                	mov    (%rax),%eax
    1095:	8d 50 01             	lea    0x1(%rax),%edx
    1098:	48 b8 f4 28 00 00 00 	movabs $0x28f4,%rax
    109f:	00 00 00 
    10a2:	89 10                	mov    %edx,(%rax)
    10a4:	eb 2c                	jmp    10d2 <co_take_turns+0xd2>
    } else {
      printf(1, "error: shared_var not updated by other coroutines\n");
    10a6:	48 be 98 23 00 00 00 	movabs $0x2398,%rsi
    10ad:	00 00 00 
    10b0:	bf 01 00 00 00       	mov    $0x1,%edi
    10b5:	b8 00 00 00 00       	mov    $0x0,%eax
    10ba:	48 ba 73 18 00 00 00 	movabs $0x1873,%rdx
    10c1:	00 00 00 
    10c4:	ff d2                	callq  *%rdx
      co_exit();
    10c6:	48 b8 0f 22 00 00 00 	movabs $0x220f,%rax
    10cd:	00 00 00 
    10d0:	ff d0                	callq  *%rax
  for (int i = 0; i < 6; i++) {
    10d2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10d6:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
    10da:	0f 8e 56 ff ff ff    	jle    1036 <co_take_turns+0x36>
    }
  }
}
    10e0:	90                   	nop
    10e1:	90                   	nop
    10e2:	c9                   	leaveq 
    10e3:	c3                   	retq   

00000000000010e4 <main>:


  int
main(int argc, char ** argv)
{
    10e4:	f3 0f 1e fa          	endbr64 
    10e8:	55                   	push   %rbp
    10e9:	48 89 e5             	mov    %rsp,%rbp
    10ec:	48 83 ec 50          	sub    $0x50,%rsp
    10f0:	89 7d bc             	mov    %edi,-0x44(%rbp)
    10f3:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  struct coroutine * co[6];
  nr_tasks = 6;
    10f7:	48 b8 f0 28 00 00 00 	movabs $0x28f0,%rax
    10fe:	00 00 00 
    1101:	c7 00 06 00 00 00    	movl   $0x6,(%rax)
  for (int i = 0; i < 6; i++) {
    1107:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    110e:	eb 60                	jmp    1170 <main+0x8c>
    co[i] = co_new(co_take_turns);
    1110:	48 bf 00 10 00 00 00 	movabs $0x1000,%rdi
    1117:	00 00 00 
    111a:	48 b8 86 1f 00 00 00 	movabs $0x1f86,%rax
    1121:	00 00 00 
    1124:	ff d0                	callq  *%rax
    1126:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1129:	48 63 d2             	movslq %edx,%rdx
    112c:	48 89 44 d5 c0       	mov    %rax,-0x40(%rbp,%rdx,8)
    if (!co[i]) {
    1131:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1134:	48 98                	cltq   
    1136:	48 8b 44 c5 c0       	mov    -0x40(%rbp,%rax,8),%rax
    113b:	48 85 c0             	test   %rax,%rax
    113e:	75 2c                	jne    116c <main+0x88>
      printf(1, "host: create co[%d] failed\n");
    1140:	48 be cb 23 00 00 00 	movabs $0x23cb,%rsi
    1147:	00 00 00 
    114a:	bf 01 00 00 00       	mov    $0x1,%edi
    114f:	b8 00 00 00 00       	mov    $0x0,%eax
    1154:	48 ba 73 18 00 00 00 	movabs $0x1873,%rdx
    115b:	00 00 00 
    115e:	ff d2                	callq  *%rdx
      exit();
    1160:	48 b8 89 15 00 00 00 	movabs $0x1589,%rax
    1167:	00 00 00 
    116a:	ff d0                	callq  *%rax
  for (int i = 0; i < 6; i++) {
    116c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1170:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
    1174:	7e 9a                	jle    1110 <main+0x2c>
    }
  }
  printf(1, "host: coroutines created!\n");
    1176:	48 be e7 23 00 00 00 	movabs $0x23e7,%rsi
    117d:	00 00 00 
    1180:	bf 01 00 00 00       	mov    $0x1,%edi
    1185:	b8 00 00 00 00       	mov    $0x0,%eax
    118a:	48 ba 73 18 00 00 00 	movabs $0x1873,%rdx
    1191:	00 00 00 
    1194:	ff d2                	callq  *%rdx
  if (co_run_all()) {
    1196:	48 b8 0a 21 00 00 00 	movabs $0x210a,%rax
    119d:	00 00 00 
    11a0:	ff d0                	callq  *%rax
    11a2:	85 c0                	test   %eax,%eax
    11a4:	74 48                	je     11ee <main+0x10a>
    printf(1, "\nhost: co_run_all() returned; shared_var == %d"
    11a6:	48 b8 f0 28 00 00 00 	movabs $0x28f0,%rax
    11ad:	00 00 00 
    11b0:	8b 10                	mov    (%rax),%edx
    11b2:	89 d0                	mov    %edx,%eax
    11b4:	c1 e0 03             	shl    $0x3,%eax
    11b7:	29 d0                	sub    %edx,%eax
    11b9:	89 c2                	mov    %eax,%edx
    11bb:	48 b8 f4 28 00 00 00 	movabs $0x28f4,%rax
    11c2:	00 00 00 
    11c5:	8b 00                	mov    (%rax),%eax
    11c7:	89 d1                	mov    %edx,%ecx
    11c9:	89 c2                	mov    %eax,%edx
    11cb:	48 be 08 24 00 00 00 	movabs $0x2408,%rsi
    11d2:	00 00 00 
    11d5:	bf 01 00 00 00       	mov    $0x1,%edi
    11da:	b8 00 00 00 00       	mov    $0x0,%eax
    11df:	49 b8 73 18 00 00 00 	movabs $0x1873,%r8
    11e6:	00 00 00 
    11e9:	41 ff d0             	callq  *%r8
    11ec:	eb 20                	jmp    120e <main+0x12a>
        " (expecting %d, the answer to the Ultimate Question of Life, the Universe, and Everything)\n",
        shared_var, nr_tasks * 7);
  } else {
    printf(1, "\nhost: error: co_run_all() failed\n");
    11ee:	48 be 98 24 00 00 00 	movabs $0x2498,%rsi
    11f5:	00 00 00 
    11f8:	bf 01 00 00 00       	mov    $0x1,%edi
    11fd:	b8 00 00 00 00       	mov    $0x0,%eax
    1202:	48 ba 73 18 00 00 00 	movabs $0x1873,%rdx
    1209:	00 00 00 
    120c:	ff d2                	callq  *%rdx
  }
  for (int i = 0; i < 6; i++) {
    120e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    1215:	eb 1d                	jmp    1234 <main+0x150>
  	co_destroy(co[i]);
    1217:	8b 45 f8             	mov    -0x8(%rbp),%eax
    121a:	48 98                	cltq   
    121c:	48 8b 44 c5 c0       	mov    -0x40(%rbp,%rax,8),%rax
    1221:	48 89 c7             	mov    %rax,%rdi
    1224:	48 b8 20 23 00 00 00 	movabs $0x2320,%rax
    122b:	00 00 00 
    122e:	ff d0                	callq  *%rax
  for (int i = 0; i < 6; i++) {
    1230:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    1234:	83 7d f8 05          	cmpl   $0x5,-0x8(%rbp)
    1238:	7e dd                	jle    1217 <main+0x133>
  }
  exit();
    123a:	48 b8 89 15 00 00 00 	movabs $0x1589,%rax
    1241:	00 00 00 
    1244:	ff d0                	callq  *%rax

0000000000001246 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1246:	f3 0f 1e fa          	endbr64 
    124a:	55                   	push   %rbp
    124b:	48 89 e5             	mov    %rsp,%rbp
    124e:	48 83 ec 10          	sub    $0x10,%rsp
    1252:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1256:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1259:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    125c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1260:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1263:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1266:	48 89 ce             	mov    %rcx,%rsi
    1269:	48 89 f7             	mov    %rsi,%rdi
    126c:	89 d1                	mov    %edx,%ecx
    126e:	fc                   	cld    
    126f:	f3 aa                	rep stos %al,%es:(%rdi)
    1271:	89 ca                	mov    %ecx,%edx
    1273:	48 89 fe             	mov    %rdi,%rsi
    1276:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    127a:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    127d:	90                   	nop
    127e:	c9                   	leaveq 
    127f:	c3                   	retq   

0000000000001280 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1280:	f3 0f 1e fa          	endbr64 
    1284:	55                   	push   %rbp
    1285:	48 89 e5             	mov    %rsp,%rbp
    1288:	48 83 ec 20          	sub    $0x20,%rsp
    128c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1290:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1298:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    129c:	90                   	nop
    129d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12a1:	48 8d 42 01          	lea    0x1(%rdx),%rax
    12a5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    12a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12ad:	48 8d 48 01          	lea    0x1(%rax),%rcx
    12b1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    12b5:	0f b6 12             	movzbl (%rdx),%edx
    12b8:	88 10                	mov    %dl,(%rax)
    12ba:	0f b6 00             	movzbl (%rax),%eax
    12bd:	84 c0                	test   %al,%al
    12bf:	75 dc                	jne    129d <strcpy+0x1d>
    ;
  return os;
    12c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12c5:	c9                   	leaveq 
    12c6:	c3                   	retq   

00000000000012c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12c7:	f3 0f 1e fa          	endbr64 
    12cb:	55                   	push   %rbp
    12cc:	48 89 e5             	mov    %rsp,%rbp
    12cf:	48 83 ec 10          	sub    $0x10,%rsp
    12d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    12db:	eb 0a                	jmp    12e7 <strcmp+0x20>
    p++, q++;
    12dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12e2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    12e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12eb:	0f b6 00             	movzbl (%rax),%eax
    12ee:	84 c0                	test   %al,%al
    12f0:	74 12                	je     1304 <strcmp+0x3d>
    12f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12f6:	0f b6 10             	movzbl (%rax),%edx
    12f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12fd:	0f b6 00             	movzbl (%rax),%eax
    1300:	38 c2                	cmp    %al,%dl
    1302:	74 d9                	je     12dd <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1308:	0f b6 00             	movzbl (%rax),%eax
    130b:	0f b6 d0             	movzbl %al,%edx
    130e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1312:	0f b6 00             	movzbl (%rax),%eax
    1315:	0f b6 c0             	movzbl %al,%eax
    1318:	29 c2                	sub    %eax,%edx
    131a:	89 d0                	mov    %edx,%eax
}
    131c:	c9                   	leaveq 
    131d:	c3                   	retq   

000000000000131e <strlen>:

uint
strlen(char *s)
{
    131e:	f3 0f 1e fa          	endbr64 
    1322:	55                   	push   %rbp
    1323:	48 89 e5             	mov    %rsp,%rbp
    1326:	48 83 ec 18          	sub    $0x18,%rsp
    132a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    132e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1335:	eb 04                	jmp    133b <strlen+0x1d>
    1337:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    133b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    133e:	48 63 d0             	movslq %eax,%rdx
    1341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1345:	48 01 d0             	add    %rdx,%rax
    1348:	0f b6 00             	movzbl (%rax),%eax
    134b:	84 c0                	test   %al,%al
    134d:	75 e8                	jne    1337 <strlen+0x19>
    ;
  return n;
    134f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1352:	c9                   	leaveq 
    1353:	c3                   	retq   

0000000000001354 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1354:	f3 0f 1e fa          	endbr64 
    1358:	55                   	push   %rbp
    1359:	48 89 e5             	mov    %rsp,%rbp
    135c:	48 83 ec 10          	sub    $0x10,%rsp
    1360:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1364:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1367:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    136a:	8b 55 f0             	mov    -0x10(%rbp),%edx
    136d:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    1370:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1374:	89 ce                	mov    %ecx,%esi
    1376:	48 89 c7             	mov    %rax,%rdi
    1379:	48 b8 46 12 00 00 00 	movabs $0x1246,%rax
    1380:	00 00 00 
    1383:	ff d0                	callq  *%rax
  return dst;
    1385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1389:	c9                   	leaveq 
    138a:	c3                   	retq   

000000000000138b <strchr>:

char*
strchr(const char *s, char c)
{
    138b:	f3 0f 1e fa          	endbr64 
    138f:	55                   	push   %rbp
    1390:	48 89 e5             	mov    %rsp,%rbp
    1393:	48 83 ec 10          	sub    $0x10,%rsp
    1397:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    139b:	89 f0                	mov    %esi,%eax
    139d:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    13a0:	eb 17                	jmp    13b9 <strchr+0x2e>
    if(*s == c)
    13a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13a6:	0f b6 00             	movzbl (%rax),%eax
    13a9:	38 45 f4             	cmp    %al,-0xc(%rbp)
    13ac:	75 06                	jne    13b4 <strchr+0x29>
      return (char*)s;
    13ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13b2:	eb 15                	jmp    13c9 <strchr+0x3e>
  for(; *s; s++)
    13b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    13b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13bd:	0f b6 00             	movzbl (%rax),%eax
    13c0:	84 c0                	test   %al,%al
    13c2:	75 de                	jne    13a2 <strchr+0x17>
  return 0;
    13c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13c9:	c9                   	leaveq 
    13ca:	c3                   	retq   

00000000000013cb <gets>:

char*
gets(char *buf, int max)
{
    13cb:	f3 0f 1e fa          	endbr64 
    13cf:	55                   	push   %rbp
    13d0:	48 89 e5             	mov    %rsp,%rbp
    13d3:	48 83 ec 20          	sub    $0x20,%rsp
    13d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13db:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    13e5:	eb 4f                	jmp    1436 <gets+0x6b>
    cc = read(0, &c, 1);
    13e7:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    13eb:	ba 01 00 00 00       	mov    $0x1,%edx
    13f0:	48 89 c6             	mov    %rax,%rsi
    13f3:	bf 00 00 00 00       	mov    $0x0,%edi
    13f8:	48 b8 b0 15 00 00 00 	movabs $0x15b0,%rax
    13ff:	00 00 00 
    1402:	ff d0                	callq  *%rax
    1404:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1407:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    140b:	7e 36                	jle    1443 <gets+0x78>
      break;
    buf[i++] = c;
    140d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1410:	8d 50 01             	lea    0x1(%rax),%edx
    1413:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1416:	48 63 d0             	movslq %eax,%rdx
    1419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    141d:	48 01 c2             	add    %rax,%rdx
    1420:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1424:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1426:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    142a:	3c 0a                	cmp    $0xa,%al
    142c:	74 16                	je     1444 <gets+0x79>
    142e:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1432:	3c 0d                	cmp    $0xd,%al
    1434:	74 0e                	je     1444 <gets+0x79>
  for(i=0; i+1 < max; ){
    1436:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1439:	83 c0 01             	add    $0x1,%eax
    143c:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    143f:	7f a6                	jg     13e7 <gets+0x1c>
    1441:	eb 01                	jmp    1444 <gets+0x79>
      break;
    1443:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1444:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1447:	48 63 d0             	movslq %eax,%rdx
    144a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    144e:	48 01 d0             	add    %rdx,%rax
    1451:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1458:	c9                   	leaveq 
    1459:	c3                   	retq   

000000000000145a <stat>:

int
stat(char *n, struct stat *st)
{
    145a:	f3 0f 1e fa          	endbr64 
    145e:	55                   	push   %rbp
    145f:	48 89 e5             	mov    %rsp,%rbp
    1462:	48 83 ec 20          	sub    $0x20,%rsp
    1466:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    146a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    146e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1472:	be 00 00 00 00       	mov    $0x0,%esi
    1477:	48 89 c7             	mov    %rax,%rdi
    147a:	48 b8 f1 15 00 00 00 	movabs $0x15f1,%rax
    1481:	00 00 00 
    1484:	ff d0                	callq  *%rax
    1486:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1489:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    148d:	79 07                	jns    1496 <stat+0x3c>
    return -1;
    148f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1494:	eb 2f                	jmp    14c5 <stat+0x6b>
  r = fstat(fd, st);
    1496:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    149a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    149d:	48 89 d6             	mov    %rdx,%rsi
    14a0:	89 c7                	mov    %eax,%edi
    14a2:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    14a9:	00 00 00 
    14ac:	ff d0                	callq  *%rax
    14ae:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    14b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14b4:	89 c7                	mov    %eax,%edi
    14b6:	48 b8 ca 15 00 00 00 	movabs $0x15ca,%rax
    14bd:	00 00 00 
    14c0:	ff d0                	callq  *%rax
  return r;
    14c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    14c5:	c9                   	leaveq 
    14c6:	c3                   	retq   

00000000000014c7 <atoi>:

int
atoi(const char *s)
{
    14c7:	f3 0f 1e fa          	endbr64 
    14cb:	55                   	push   %rbp
    14cc:	48 89 e5             	mov    %rsp,%rbp
    14cf:	48 83 ec 18          	sub    $0x18,%rsp
    14d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    14d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    14de:	eb 28                	jmp    1508 <atoi+0x41>
    n = n*10 + *s++ - '0';
    14e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
    14e3:	89 d0                	mov    %edx,%eax
    14e5:	c1 e0 02             	shl    $0x2,%eax
    14e8:	01 d0                	add    %edx,%eax
    14ea:	01 c0                	add    %eax,%eax
    14ec:	89 c1                	mov    %eax,%ecx
    14ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
    14f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    14fa:	0f b6 00             	movzbl (%rax),%eax
    14fd:	0f be c0             	movsbl %al,%eax
    1500:	01 c8                	add    %ecx,%eax
    1502:	83 e8 30             	sub    $0x30,%eax
    1505:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1508:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    150c:	0f b6 00             	movzbl (%rax),%eax
    150f:	3c 2f                	cmp    $0x2f,%al
    1511:	7e 0b                	jle    151e <atoi+0x57>
    1513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1517:	0f b6 00             	movzbl (%rax),%eax
    151a:	3c 39                	cmp    $0x39,%al
    151c:	7e c2                	jle    14e0 <atoi+0x19>
  return n;
    151e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1521:	c9                   	leaveq 
    1522:	c3                   	retq   

0000000000001523 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1523:	f3 0f 1e fa          	endbr64 
    1527:	55                   	push   %rbp
    1528:	48 89 e5             	mov    %rsp,%rbp
    152b:	48 83 ec 28          	sub    $0x28,%rsp
    152f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1533:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1537:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    153a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    153e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1542:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1546:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    154a:	eb 1d                	jmp    1569 <memmove+0x46>
    *dst++ = *src++;
    154c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1550:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1554:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    155c:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1560:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1564:	0f b6 12             	movzbl (%rdx),%edx
    1567:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1569:	8b 45 dc             	mov    -0x24(%rbp),%eax
    156c:	8d 50 ff             	lea    -0x1(%rax),%edx
    156f:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1572:	85 c0                	test   %eax,%eax
    1574:	7f d6                	jg     154c <memmove+0x29>
  return vdst;
    1576:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    157a:	c9                   	leaveq 
    157b:	c3                   	retq   

000000000000157c <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    157c:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1583:	49 89 ca             	mov    %rcx,%r10
    1586:	0f 05                	syscall 
    1588:	c3                   	retq   

0000000000001589 <exit>:
SYSCALL(exit)
    1589:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1590:	49 89 ca             	mov    %rcx,%r10
    1593:	0f 05                	syscall 
    1595:	c3                   	retq   

0000000000001596 <wait>:
SYSCALL(wait)
    1596:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    159d:	49 89 ca             	mov    %rcx,%r10
    15a0:	0f 05                	syscall 
    15a2:	c3                   	retq   

00000000000015a3 <pipe>:
SYSCALL(pipe)
    15a3:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    15aa:	49 89 ca             	mov    %rcx,%r10
    15ad:	0f 05                	syscall 
    15af:	c3                   	retq   

00000000000015b0 <read>:
SYSCALL(read)
    15b0:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    15b7:	49 89 ca             	mov    %rcx,%r10
    15ba:	0f 05                	syscall 
    15bc:	c3                   	retq   

00000000000015bd <write>:
SYSCALL(write)
    15bd:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    15c4:	49 89 ca             	mov    %rcx,%r10
    15c7:	0f 05                	syscall 
    15c9:	c3                   	retq   

00000000000015ca <close>:
SYSCALL(close)
    15ca:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    15d1:	49 89 ca             	mov    %rcx,%r10
    15d4:	0f 05                	syscall 
    15d6:	c3                   	retq   

00000000000015d7 <kill>:
SYSCALL(kill)
    15d7:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    15de:	49 89 ca             	mov    %rcx,%r10
    15e1:	0f 05                	syscall 
    15e3:	c3                   	retq   

00000000000015e4 <exec>:
SYSCALL(exec)
    15e4:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    15eb:	49 89 ca             	mov    %rcx,%r10
    15ee:	0f 05                	syscall 
    15f0:	c3                   	retq   

00000000000015f1 <open>:
SYSCALL(open)
    15f1:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    15f8:	49 89 ca             	mov    %rcx,%r10
    15fb:	0f 05                	syscall 
    15fd:	c3                   	retq   

00000000000015fe <mknod>:
SYSCALL(mknod)
    15fe:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1605:	49 89 ca             	mov    %rcx,%r10
    1608:	0f 05                	syscall 
    160a:	c3                   	retq   

000000000000160b <unlink>:
SYSCALL(unlink)
    160b:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1612:	49 89 ca             	mov    %rcx,%r10
    1615:	0f 05                	syscall 
    1617:	c3                   	retq   

0000000000001618 <fstat>:
SYSCALL(fstat)
    1618:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    161f:	49 89 ca             	mov    %rcx,%r10
    1622:	0f 05                	syscall 
    1624:	c3                   	retq   

0000000000001625 <link>:
SYSCALL(link)
    1625:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    162c:	49 89 ca             	mov    %rcx,%r10
    162f:	0f 05                	syscall 
    1631:	c3                   	retq   

0000000000001632 <mkdir>:
SYSCALL(mkdir)
    1632:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1639:	49 89 ca             	mov    %rcx,%r10
    163c:	0f 05                	syscall 
    163e:	c3                   	retq   

000000000000163f <chdir>:
SYSCALL(chdir)
    163f:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1646:	49 89 ca             	mov    %rcx,%r10
    1649:	0f 05                	syscall 
    164b:	c3                   	retq   

000000000000164c <dup>:
SYSCALL(dup)
    164c:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1653:	49 89 ca             	mov    %rcx,%r10
    1656:	0f 05                	syscall 
    1658:	c3                   	retq   

0000000000001659 <getpid>:
SYSCALL(getpid)
    1659:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1660:	49 89 ca             	mov    %rcx,%r10
    1663:	0f 05                	syscall 
    1665:	c3                   	retq   

0000000000001666 <sbrk>:
SYSCALL(sbrk)
    1666:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    166d:	49 89 ca             	mov    %rcx,%r10
    1670:	0f 05                	syscall 
    1672:	c3                   	retq   

0000000000001673 <sleep>:
SYSCALL(sleep)
    1673:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    167a:	49 89 ca             	mov    %rcx,%r10
    167d:	0f 05                	syscall 
    167f:	c3                   	retq   

0000000000001680 <uptime>:
SYSCALL(uptime)
    1680:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1687:	49 89 ca             	mov    %rcx,%r10
    168a:	0f 05                	syscall 
    168c:	c3                   	retq   

000000000000168d <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    168d:	f3 0f 1e fa          	endbr64 
    1691:	55                   	push   %rbp
    1692:	48 89 e5             	mov    %rsp,%rbp
    1695:	48 83 ec 10          	sub    $0x10,%rsp
    1699:	89 7d fc             	mov    %edi,-0x4(%rbp)
    169c:	89 f0                	mov    %esi,%eax
    169e:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    16a1:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    16a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16a8:	ba 01 00 00 00       	mov    $0x1,%edx
    16ad:	48 89 ce             	mov    %rcx,%rsi
    16b0:	89 c7                	mov    %eax,%edi
    16b2:	48 b8 bd 15 00 00 00 	movabs $0x15bd,%rax
    16b9:	00 00 00 
    16bc:	ff d0                	callq  *%rax
}
    16be:	90                   	nop
    16bf:	c9                   	leaveq 
    16c0:	c3                   	retq   

00000000000016c1 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    16c1:	f3 0f 1e fa          	endbr64 
    16c5:	55                   	push   %rbp
    16c6:	48 89 e5             	mov    %rsp,%rbp
    16c9:	48 83 ec 20          	sub    $0x20,%rsp
    16cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    16d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16db:	eb 35                	jmp    1712 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    16dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    16e1:	48 c1 e8 3c          	shr    $0x3c,%rax
    16e5:	48 ba d0 28 00 00 00 	movabs $0x28d0,%rdx
    16ec:	00 00 00 
    16ef:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    16f3:	0f be d0             	movsbl %al,%edx
    16f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16f9:	89 d6                	mov    %edx,%esi
    16fb:	89 c7                	mov    %eax,%edi
    16fd:	48 b8 8d 16 00 00 00 	movabs $0x168d,%rax
    1704:	00 00 00 
    1707:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1709:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    170d:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1712:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1715:	83 f8 0f             	cmp    $0xf,%eax
    1718:	76 c3                	jbe    16dd <print_x64+0x1c>
}
    171a:	90                   	nop
    171b:	90                   	nop
    171c:	c9                   	leaveq 
    171d:	c3                   	retq   

000000000000171e <print_x32>:

  static void
print_x32(int fd, uint x)
{
    171e:	f3 0f 1e fa          	endbr64 
    1722:	55                   	push   %rbp
    1723:	48 89 e5             	mov    %rsp,%rbp
    1726:	48 83 ec 20          	sub    $0x20,%rsp
    172a:	89 7d ec             	mov    %edi,-0x14(%rbp)
    172d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1730:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1737:	eb 36                	jmp    176f <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1739:	8b 45 e8             	mov    -0x18(%rbp),%eax
    173c:	c1 e8 1c             	shr    $0x1c,%eax
    173f:	89 c2                	mov    %eax,%edx
    1741:	48 b8 d0 28 00 00 00 	movabs $0x28d0,%rax
    1748:	00 00 00 
    174b:	89 d2                	mov    %edx,%edx
    174d:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1751:	0f be d0             	movsbl %al,%edx
    1754:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1757:	89 d6                	mov    %edx,%esi
    1759:	89 c7                	mov    %eax,%edi
    175b:	48 b8 8d 16 00 00 00 	movabs $0x168d,%rax
    1762:	00 00 00 
    1765:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1767:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    176b:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    176f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1772:	83 f8 07             	cmp    $0x7,%eax
    1775:	76 c2                	jbe    1739 <print_x32+0x1b>
}
    1777:	90                   	nop
    1778:	90                   	nop
    1779:	c9                   	leaveq 
    177a:	c3                   	retq   

000000000000177b <print_d>:

  static void
print_d(int fd, int v)
{
    177b:	f3 0f 1e fa          	endbr64 
    177f:	55                   	push   %rbp
    1780:	48 89 e5             	mov    %rsp,%rbp
    1783:	48 83 ec 30          	sub    $0x30,%rsp
    1787:	89 7d dc             	mov    %edi,-0x24(%rbp)
    178a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    178d:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1790:	48 98                	cltq   
    1792:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1796:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    179a:	79 04                	jns    17a0 <print_d+0x25>
    x = -x;
    179c:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    17a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    17a7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    17ab:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    17b2:	66 66 66 
    17b5:	48 89 c8             	mov    %rcx,%rax
    17b8:	48 f7 ea             	imul   %rdx
    17bb:	48 c1 fa 02          	sar    $0x2,%rdx
    17bf:	48 89 c8             	mov    %rcx,%rax
    17c2:	48 c1 f8 3f          	sar    $0x3f,%rax
    17c6:	48 29 c2             	sub    %rax,%rdx
    17c9:	48 89 d0             	mov    %rdx,%rax
    17cc:	48 c1 e0 02          	shl    $0x2,%rax
    17d0:	48 01 d0             	add    %rdx,%rax
    17d3:	48 01 c0             	add    %rax,%rax
    17d6:	48 29 c1             	sub    %rax,%rcx
    17d9:	48 89 ca             	mov    %rcx,%rdx
    17dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17df:	8d 48 01             	lea    0x1(%rax),%ecx
    17e2:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    17e5:	48 b9 d0 28 00 00 00 	movabs $0x28d0,%rcx
    17ec:	00 00 00 
    17ef:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    17f3:	48 98                	cltq   
    17f5:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    17f9:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    17fd:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1804:	66 66 66 
    1807:	48 89 c8             	mov    %rcx,%rax
    180a:	48 f7 ea             	imul   %rdx
    180d:	48 c1 fa 02          	sar    $0x2,%rdx
    1811:	48 89 c8             	mov    %rcx,%rax
    1814:	48 c1 f8 3f          	sar    $0x3f,%rax
    1818:	48 29 c2             	sub    %rax,%rdx
    181b:	48 89 d0             	mov    %rdx,%rax
    181e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1822:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1827:	0f 85 7a ff ff ff    	jne    17a7 <print_d+0x2c>

  if (v < 0)
    182d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1831:	79 32                	jns    1865 <print_d+0xea>
    buf[i++] = '-';
    1833:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1836:	8d 50 01             	lea    0x1(%rax),%edx
    1839:	89 55 f4             	mov    %edx,-0xc(%rbp)
    183c:	48 98                	cltq   
    183e:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1843:	eb 20                	jmp    1865 <print_d+0xea>
    putc(fd, buf[i]);
    1845:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1848:	48 98                	cltq   
    184a:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    184f:	0f be d0             	movsbl %al,%edx
    1852:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1855:	89 d6                	mov    %edx,%esi
    1857:	89 c7                	mov    %eax,%edi
    1859:	48 b8 8d 16 00 00 00 	movabs $0x168d,%rax
    1860:	00 00 00 
    1863:	ff d0                	callq  *%rax
  while (--i >= 0)
    1865:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1869:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    186d:	79 d6                	jns    1845 <print_d+0xca>
}
    186f:	90                   	nop
    1870:	90                   	nop
    1871:	c9                   	leaveq 
    1872:	c3                   	retq   

0000000000001873 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1873:	f3 0f 1e fa          	endbr64 
    1877:	55                   	push   %rbp
    1878:	48 89 e5             	mov    %rsp,%rbp
    187b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1882:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1888:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    188f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1896:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    189d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    18a4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    18ab:	84 c0                	test   %al,%al
    18ad:	74 20                	je     18cf <printf+0x5c>
    18af:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    18b3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    18b7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    18bb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    18bf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    18c3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    18c7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    18cb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    18cf:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    18d6:	00 00 00 
    18d9:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    18e0:	00 00 00 
    18e3:	48 8d 45 10          	lea    0x10(%rbp),%rax
    18e7:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    18ee:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    18f5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    18fc:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1903:	00 00 00 
    1906:	e9 41 03 00 00       	jmpq   1c4c <printf+0x3d9>
    if (c != '%') {
    190b:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1912:	74 24                	je     1938 <printf+0xc5>
      putc(fd, c);
    1914:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    191a:	0f be d0             	movsbl %al,%edx
    191d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1923:	89 d6                	mov    %edx,%esi
    1925:	89 c7                	mov    %eax,%edi
    1927:	48 b8 8d 16 00 00 00 	movabs $0x168d,%rax
    192e:	00 00 00 
    1931:	ff d0                	callq  *%rax
      continue;
    1933:	e9 0d 03 00 00       	jmpq   1c45 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1938:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    193f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1945:	48 63 d0             	movslq %eax,%rdx
    1948:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    194f:	48 01 d0             	add    %rdx,%rax
    1952:	0f b6 00             	movzbl (%rax),%eax
    1955:	0f be c0             	movsbl %al,%eax
    1958:	25 ff 00 00 00       	and    $0xff,%eax
    195d:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1963:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    196a:	0f 84 0f 03 00 00    	je     1c7f <printf+0x40c>
      break;
    switch(c) {
    1970:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1977:	0f 84 74 02 00 00    	je     1bf1 <printf+0x37e>
    197d:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1984:	0f 8c 82 02 00 00    	jl     1c0c <printf+0x399>
    198a:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1991:	0f 8f 75 02 00 00    	jg     1c0c <printf+0x399>
    1997:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    199e:	0f 8c 68 02 00 00    	jl     1c0c <printf+0x399>
    19a4:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    19aa:	83 e8 63             	sub    $0x63,%eax
    19ad:	83 f8 15             	cmp    $0x15,%eax
    19b0:	0f 87 56 02 00 00    	ja     1c0c <printf+0x399>
    19b6:	89 c0                	mov    %eax,%eax
    19b8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    19bf:	00 
    19c0:	48 b8 c8 24 00 00 00 	movabs $0x24c8,%rax
    19c7:	00 00 00 
    19ca:	48 01 d0             	add    %rdx,%rax
    19cd:	48 8b 00             	mov    (%rax),%rax
    19d0:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    19d3:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19d9:	83 f8 2f             	cmp    $0x2f,%eax
    19dc:	77 23                	ja     1a01 <printf+0x18e>
    19de:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19e5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19eb:	89 d2                	mov    %edx,%edx
    19ed:	48 01 d0             	add    %rdx,%rax
    19f0:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19f6:	83 c2 08             	add    $0x8,%edx
    19f9:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19ff:	eb 12                	jmp    1a13 <printf+0x1a0>
    1a01:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a08:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a0c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a13:	8b 00                	mov    (%rax),%eax
    1a15:	0f be d0             	movsbl %al,%edx
    1a18:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a1e:	89 d6                	mov    %edx,%esi
    1a20:	89 c7                	mov    %eax,%edi
    1a22:	48 b8 8d 16 00 00 00 	movabs $0x168d,%rax
    1a29:	00 00 00 
    1a2c:	ff d0                	callq  *%rax
      break;
    1a2e:	e9 12 02 00 00       	jmpq   1c45 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1a33:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a39:	83 f8 2f             	cmp    $0x2f,%eax
    1a3c:	77 23                	ja     1a61 <printf+0x1ee>
    1a3e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a45:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a4b:	89 d2                	mov    %edx,%edx
    1a4d:	48 01 d0             	add    %rdx,%rax
    1a50:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a56:	83 c2 08             	add    $0x8,%edx
    1a59:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a5f:	eb 12                	jmp    1a73 <printf+0x200>
    1a61:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a68:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a6c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a73:	8b 10                	mov    (%rax),%edx
    1a75:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a7b:	89 d6                	mov    %edx,%esi
    1a7d:	89 c7                	mov    %eax,%edi
    1a7f:	48 b8 7b 17 00 00 00 	movabs $0x177b,%rax
    1a86:	00 00 00 
    1a89:	ff d0                	callq  *%rax
      break;
    1a8b:	e9 b5 01 00 00       	jmpq   1c45 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1a90:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a96:	83 f8 2f             	cmp    $0x2f,%eax
    1a99:	77 23                	ja     1abe <printf+0x24b>
    1a9b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1aa2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aa8:	89 d2                	mov    %edx,%edx
    1aaa:	48 01 d0             	add    %rdx,%rax
    1aad:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ab3:	83 c2 08             	add    $0x8,%edx
    1ab6:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1abc:	eb 12                	jmp    1ad0 <printf+0x25d>
    1abe:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ac5:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1ac9:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ad0:	8b 10                	mov    (%rax),%edx
    1ad2:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ad8:	89 d6                	mov    %edx,%esi
    1ada:	89 c7                	mov    %eax,%edi
    1adc:	48 b8 1e 17 00 00 00 	movabs $0x171e,%rax
    1ae3:	00 00 00 
    1ae6:	ff d0                	callq  *%rax
      break;
    1ae8:	e9 58 01 00 00       	jmpq   1c45 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1aed:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1af3:	83 f8 2f             	cmp    $0x2f,%eax
    1af6:	77 23                	ja     1b1b <printf+0x2a8>
    1af8:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1aff:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b05:	89 d2                	mov    %edx,%edx
    1b07:	48 01 d0             	add    %rdx,%rax
    1b0a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b10:	83 c2 08             	add    $0x8,%edx
    1b13:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b19:	eb 12                	jmp    1b2d <printf+0x2ba>
    1b1b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b22:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b26:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b2d:	48 8b 10             	mov    (%rax),%rdx
    1b30:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b36:	48 89 d6             	mov    %rdx,%rsi
    1b39:	89 c7                	mov    %eax,%edi
    1b3b:	48 b8 c1 16 00 00 00 	movabs $0x16c1,%rax
    1b42:	00 00 00 
    1b45:	ff d0                	callq  *%rax
      break;
    1b47:	e9 f9 00 00 00       	jmpq   1c45 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1b4c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b52:	83 f8 2f             	cmp    $0x2f,%eax
    1b55:	77 23                	ja     1b7a <printf+0x307>
    1b57:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b5e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b64:	89 d2                	mov    %edx,%edx
    1b66:	48 01 d0             	add    %rdx,%rax
    1b69:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b6f:	83 c2 08             	add    $0x8,%edx
    1b72:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b78:	eb 12                	jmp    1b8c <printf+0x319>
    1b7a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b81:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b85:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b8c:	48 8b 00             	mov    (%rax),%rax
    1b8f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1b96:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b9d:	00 
    1b9e:	75 41                	jne    1be1 <printf+0x36e>
        s = "(null)";
    1ba0:	48 b8 c0 24 00 00 00 	movabs $0x24c0,%rax
    1ba7:	00 00 00 
    1baa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1bb1:	eb 2e                	jmp    1be1 <printf+0x36e>
        putc(fd, *(s++));
    1bb3:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1bba:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1bbe:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1bc5:	0f b6 00             	movzbl (%rax),%eax
    1bc8:	0f be d0             	movsbl %al,%edx
    1bcb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bd1:	89 d6                	mov    %edx,%esi
    1bd3:	89 c7                	mov    %eax,%edi
    1bd5:	48 b8 8d 16 00 00 00 	movabs $0x168d,%rax
    1bdc:	00 00 00 
    1bdf:	ff d0                	callq  *%rax
      while (*s)
    1be1:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1be8:	0f b6 00             	movzbl (%rax),%eax
    1beb:	84 c0                	test   %al,%al
    1bed:	75 c4                	jne    1bb3 <printf+0x340>
      break;
    1bef:	eb 54                	jmp    1c45 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1bf1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bf7:	be 25 00 00 00       	mov    $0x25,%esi
    1bfc:	89 c7                	mov    %eax,%edi
    1bfe:	48 b8 8d 16 00 00 00 	movabs $0x168d,%rax
    1c05:	00 00 00 
    1c08:	ff d0                	callq  *%rax
      break;
    1c0a:	eb 39                	jmp    1c45 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1c0c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c12:	be 25 00 00 00       	mov    $0x25,%esi
    1c17:	89 c7                	mov    %eax,%edi
    1c19:	48 b8 8d 16 00 00 00 	movabs $0x168d,%rax
    1c20:	00 00 00 
    1c23:	ff d0                	callq  *%rax
      putc(fd, c);
    1c25:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1c2b:	0f be d0             	movsbl %al,%edx
    1c2e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c34:	89 d6                	mov    %edx,%esi
    1c36:	89 c7                	mov    %eax,%edi
    1c38:	48 b8 8d 16 00 00 00 	movabs $0x168d,%rax
    1c3f:	00 00 00 
    1c42:	ff d0                	callq  *%rax
      break;
    1c44:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1c45:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1c4c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1c52:	48 63 d0             	movslq %eax,%rdx
    1c55:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1c5c:	48 01 d0             	add    %rdx,%rax
    1c5f:	0f b6 00             	movzbl (%rax),%eax
    1c62:	0f be c0             	movsbl %al,%eax
    1c65:	25 ff 00 00 00       	and    $0xff,%eax
    1c6a:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1c70:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1c77:	0f 85 8e fc ff ff    	jne    190b <printf+0x98>
    }
  }
}
    1c7d:	eb 01                	jmp    1c80 <printf+0x40d>
      break;
    1c7f:	90                   	nop
}
    1c80:	90                   	nop
    1c81:	c9                   	leaveq 
    1c82:	c3                   	retq   

0000000000001c83 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1c83:	f3 0f 1e fa          	endbr64 
    1c87:	55                   	push   %rbp
    1c88:	48 89 e5             	mov    %rsp,%rbp
    1c8b:	48 83 ec 18          	sub    $0x18,%rsp
    1c8f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1c93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c97:	48 83 e8 10          	sub    $0x10,%rax
    1c9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c9f:	48 b8 10 29 00 00 00 	movabs $0x2910,%rax
    1ca6:	00 00 00 
    1ca9:	48 8b 00             	mov    (%rax),%rax
    1cac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1cb0:	eb 2f                	jmp    1ce1 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1cb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb6:	48 8b 00             	mov    (%rax),%rax
    1cb9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1cbd:	72 17                	jb     1cd6 <free+0x53>
    1cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1cc7:	77 2f                	ja     1cf8 <free+0x75>
    1cc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ccd:	48 8b 00             	mov    (%rax),%rax
    1cd0:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cd4:	72 22                	jb     1cf8 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1cd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cda:	48 8b 00             	mov    (%rax),%rax
    1cdd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ce1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1ce9:	76 c7                	jbe    1cb2 <free+0x2f>
    1ceb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cef:	48 8b 00             	mov    (%rax),%rax
    1cf2:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cf6:	73 ba                	jae    1cb2 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1cf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cfc:	8b 40 08             	mov    0x8(%rax),%eax
    1cff:	89 c0                	mov    %eax,%eax
    1d01:	48 c1 e0 04          	shl    $0x4,%rax
    1d05:	48 89 c2             	mov    %rax,%rdx
    1d08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d0c:	48 01 c2             	add    %rax,%rdx
    1d0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d13:	48 8b 00             	mov    (%rax),%rax
    1d16:	48 39 c2             	cmp    %rax,%rdx
    1d19:	75 2d                	jne    1d48 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d1f:	8b 50 08             	mov    0x8(%rax),%edx
    1d22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d26:	48 8b 00             	mov    (%rax),%rax
    1d29:	8b 40 08             	mov    0x8(%rax),%eax
    1d2c:	01 c2                	add    %eax,%edx
    1d2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d32:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1d35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d39:	48 8b 00             	mov    (%rax),%rax
    1d3c:	48 8b 10             	mov    (%rax),%rdx
    1d3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d43:	48 89 10             	mov    %rdx,(%rax)
    1d46:	eb 0e                	jmp    1d56 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1d48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4c:	48 8b 10             	mov    (%rax),%rdx
    1d4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d53:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1d56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d5a:	8b 40 08             	mov    0x8(%rax),%eax
    1d5d:	89 c0                	mov    %eax,%eax
    1d5f:	48 c1 e0 04          	shl    $0x4,%rax
    1d63:	48 89 c2             	mov    %rax,%rdx
    1d66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d6a:	48 01 d0             	add    %rdx,%rax
    1d6d:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d71:	75 27                	jne    1d9a <free+0x117>
    p->s.size += bp->s.size;
    1d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d77:	8b 50 08             	mov    0x8(%rax),%edx
    1d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d7e:	8b 40 08             	mov    0x8(%rax),%eax
    1d81:	01 c2                	add    %eax,%edx
    1d83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d87:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d8e:	48 8b 10             	mov    (%rax),%rdx
    1d91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d95:	48 89 10             	mov    %rdx,(%rax)
    1d98:	eb 0b                	jmp    1da5 <free+0x122>
  } else
    p->s.ptr = bp;
    1d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d9e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1da2:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1da5:	48 ba 10 29 00 00 00 	movabs $0x2910,%rdx
    1dac:	00 00 00 
    1daf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1db3:	48 89 02             	mov    %rax,(%rdx)
}
    1db6:	90                   	nop
    1db7:	c9                   	leaveq 
    1db8:	c3                   	retq   

0000000000001db9 <morecore>:

static Header*
morecore(uint nu)
{
    1db9:	f3 0f 1e fa          	endbr64 
    1dbd:	55                   	push   %rbp
    1dbe:	48 89 e5             	mov    %rsp,%rbp
    1dc1:	48 83 ec 20          	sub    $0x20,%rsp
    1dc5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1dc8:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1dcf:	77 07                	ja     1dd8 <morecore+0x1f>
    nu = 4096;
    1dd1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1dd8:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ddb:	48 c1 e0 04          	shl    $0x4,%rax
    1ddf:	48 89 c7             	mov    %rax,%rdi
    1de2:	48 b8 66 16 00 00 00 	movabs $0x1666,%rax
    1de9:	00 00 00 
    1dec:	ff d0                	callq  *%rax
    1dee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1df2:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1df7:	75 07                	jne    1e00 <morecore+0x47>
    return 0;
    1df9:	b8 00 00 00 00       	mov    $0x0,%eax
    1dfe:	eb 36                	jmp    1e36 <morecore+0x7d>
  hp = (Header*)p;
    1e00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e04:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1e08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e0c:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e0f:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1e12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e16:	48 83 c0 10          	add    $0x10,%rax
    1e1a:	48 89 c7             	mov    %rax,%rdi
    1e1d:	48 b8 83 1c 00 00 00 	movabs $0x1c83,%rax
    1e24:	00 00 00 
    1e27:	ff d0                	callq  *%rax
  return freep;
    1e29:	48 b8 10 29 00 00 00 	movabs $0x2910,%rax
    1e30:	00 00 00 
    1e33:	48 8b 00             	mov    (%rax),%rax
}
    1e36:	c9                   	leaveq 
    1e37:	c3                   	retq   

0000000000001e38 <malloc>:

void*
malloc(uint nbytes)
{
    1e38:	f3 0f 1e fa          	endbr64 
    1e3c:	55                   	push   %rbp
    1e3d:	48 89 e5             	mov    %rsp,%rbp
    1e40:	48 83 ec 30          	sub    $0x30,%rsp
    1e44:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1e47:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1e4a:	48 83 c0 0f          	add    $0xf,%rax
    1e4e:	48 c1 e8 04          	shr    $0x4,%rax
    1e52:	83 c0 01             	add    $0x1,%eax
    1e55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1e58:	48 b8 10 29 00 00 00 	movabs $0x2910,%rax
    1e5f:	00 00 00 
    1e62:	48 8b 00             	mov    (%rax),%rax
    1e65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e69:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1e6e:	75 4a                	jne    1eba <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1e70:	48 b8 00 29 00 00 00 	movabs $0x2900,%rax
    1e77:	00 00 00 
    1e7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e7e:	48 ba 10 29 00 00 00 	movabs $0x2910,%rdx
    1e85:	00 00 00 
    1e88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e8c:	48 89 02             	mov    %rax,(%rdx)
    1e8f:	48 b8 10 29 00 00 00 	movabs $0x2910,%rax
    1e96:	00 00 00 
    1e99:	48 8b 00             	mov    (%rax),%rax
    1e9c:	48 ba 00 29 00 00 00 	movabs $0x2900,%rdx
    1ea3:	00 00 00 
    1ea6:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1ea9:	48 b8 00 29 00 00 00 	movabs $0x2900,%rax
    1eb0:	00 00 00 
    1eb3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1eba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ebe:	48 8b 00             	mov    (%rax),%rax
    1ec1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ec5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ec9:	8b 40 08             	mov    0x8(%rax),%eax
    1ecc:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1ecf:	77 65                	ja     1f36 <malloc+0xfe>
      if(p->s.size == nunits)
    1ed1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ed5:	8b 40 08             	mov    0x8(%rax),%eax
    1ed8:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1edb:	75 10                	jne    1eed <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1edd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ee1:	48 8b 10             	mov    (%rax),%rdx
    1ee4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ee8:	48 89 10             	mov    %rdx,(%rax)
    1eeb:	eb 2e                	jmp    1f1b <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef1:	8b 40 08             	mov    0x8(%rax),%eax
    1ef4:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1ef7:	89 c2                	mov    %eax,%edx
    1ef9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1efd:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1f00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f04:	8b 40 08             	mov    0x8(%rax),%eax
    1f07:	89 c0                	mov    %eax,%eax
    1f09:	48 c1 e0 04          	shl    $0x4,%rax
    1f0d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1f11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f15:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1f18:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1f1b:	48 ba 10 29 00 00 00 	movabs $0x2910,%rdx
    1f22:	00 00 00 
    1f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f29:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1f2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f30:	48 83 c0 10          	add    $0x10,%rax
    1f34:	eb 4e                	jmp    1f84 <malloc+0x14c>
    }
    if(p == freep)
    1f36:	48 b8 10 29 00 00 00 	movabs $0x2910,%rax
    1f3d:	00 00 00 
    1f40:	48 8b 00             	mov    (%rax),%rax
    1f43:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f47:	75 23                	jne    1f6c <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1f49:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1f4c:	89 c7                	mov    %eax,%edi
    1f4e:	48 b8 b9 1d 00 00 00 	movabs $0x1db9,%rax
    1f55:	00 00 00 
    1f58:	ff d0                	callq  *%rax
    1f5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f5e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1f63:	75 07                	jne    1f6c <malloc+0x134>
        return 0;
    1f65:	b8 00 00 00 00       	mov    $0x0,%eax
    1f6a:	eb 18                	jmp    1f84 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1f6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f70:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1f74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f78:	48 8b 00             	mov    (%rax),%rax
    1f7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f7f:	e9 41 ff ff ff       	jmpq   1ec5 <malloc+0x8d>
  }
}
    1f84:	c9                   	leaveq 
    1f85:	c3                   	retq   

0000000000001f86 <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1f86:	f3 0f 1e fa          	endbr64 
    1f8a:	55                   	push   %rbp
    1f8b:	48 89 e5             	mov    %rsp,%rbp
    1f8e:	48 83 ec 30          	sub    $0x30,%rsp
    1f92:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1f96:	bf 18 00 00 00       	mov    $0x18,%edi
    1f9b:	48 b8 38 1e 00 00 00 	movabs $0x1e38,%rax
    1fa2:	00 00 00 
    1fa5:	ff d0                	callq  *%rax
    1fa7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1fab:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1fb0:	75 0a                	jne    1fbc <co_new+0x36>
    return 0;
    1fb2:	b8 00 00 00 00       	mov    $0x0,%eax
    1fb7:	e9 e1 00 00 00       	jmpq   209d <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1fbc:	bf 00 20 00 00       	mov    $0x2000,%edi
    1fc1:	48 b8 38 1e 00 00 00 	movabs $0x1e38,%rax
    1fc8:	00 00 00 
    1fcb:	ff d0                	callq  *%rax
    1fcd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1fd1:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1fd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fd9:	48 8b 40 10          	mov    0x10(%rax),%rax
    1fdd:	48 85 c0             	test   %rax,%rax
    1fe0:	75 1d                	jne    1fff <co_new+0x79>
    free(co1);
    1fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fe6:	48 89 c7             	mov    %rax,%rdi
    1fe9:	48 b8 83 1c 00 00 00 	movabs $0x1c83,%rax
    1ff0:	00 00 00 
    1ff3:	ff d0                	callq  *%rax
    return 0;
    1ff5:	b8 00 00 00 00       	mov    $0x0,%eax
    1ffa:	e9 9e 00 00 00       	jmpq   209d <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1fff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2003:	48 8b 40 10          	mov    0x10(%rax),%rax
    2007:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    200d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    2011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2015:	48 8d 50 30          	lea    0x30(%rax),%rdx
    2019:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    201d:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    2020:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2024:	48 83 c0 38          	add    $0x38,%rax
    2028:	48 ba 0f 22 00 00 00 	movabs $0x220f,%rdx
    202f:	00 00 00 
    2032:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    2035:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2039:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    203d:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    2040:	48 b8 28 29 00 00 00 	movabs $0x2928,%rax
    2047:	00 00 00 
    204a:	48 8b 00             	mov    (%rax),%rax
    204d:	48 85 c0             	test   %rax,%rax
    2050:	75 13                	jne    2065 <co_new+0xdf>
  {
  	co_list = co1;
    2052:	48 ba 28 29 00 00 00 	movabs $0x2928,%rdx
    2059:	00 00 00 
    205c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2060:	48 89 02             	mov    %rax,(%rdx)
    2063:	eb 34                	jmp    2099 <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    2065:	48 b8 28 29 00 00 00 	movabs $0x2928,%rax
    206c:	00 00 00 
    206f:	48 8b 00             	mov    (%rax),%rax
    2072:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    2076:	eb 0c                	jmp    2084 <co_new+0xfe>
	{
		head = head->next;
    2078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    207c:	48 8b 40 08          	mov    0x8(%rax),%rax
    2080:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    2084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2088:	48 8b 40 08          	mov    0x8(%rax),%rax
    208c:	48 85 c0             	test   %rax,%rax
    208f:	75 e7                	jne    2078 <co_new+0xf2>
	}
	head = co1;
    2091:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2095:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    2099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    209d:	c9                   	leaveq 
    209e:	c3                   	retq   

000000000000209f <co_run>:

  int
co_run(void)
{
    209f:	f3 0f 1e fa          	endbr64 
    20a3:	55                   	push   %rbp
    20a4:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    20a7:	48 b8 28 29 00 00 00 	movabs $0x2928,%rax
    20ae:	00 00 00 
    20b1:	48 8b 00             	mov    (%rax),%rax
    20b4:	48 85 c0             	test   %rax,%rax
    20b7:	74 4a                	je     2103 <co_run+0x64>
	{
		co_current = co_list;
    20b9:	48 b8 28 29 00 00 00 	movabs $0x2928,%rax
    20c0:	00 00 00 
    20c3:	48 8b 00             	mov    (%rax),%rax
    20c6:	48 ba 20 29 00 00 00 	movabs $0x2920,%rdx
    20cd:	00 00 00 
    20d0:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    20d3:	48 b8 20 29 00 00 00 	movabs $0x2920,%rax
    20da:	00 00 00 
    20dd:	48 8b 00             	mov    (%rax),%rax
    20e0:	48 8b 00             	mov    (%rax),%rax
    20e3:	48 89 c6             	mov    %rax,%rsi
    20e6:	48 bf 18 29 00 00 00 	movabs $0x2918,%rdi
    20ed:	00 00 00 
    20f0:	48 b8 71 23 00 00 00 	movabs $0x2371,%rax
    20f7:	00 00 00 
    20fa:	ff d0                	callq  *%rax
		return 1;
    20fc:	b8 01 00 00 00       	mov    $0x1,%eax
    2101:	eb 05                	jmp    2108 <co_run+0x69>
	}
	return 0;
    2103:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2108:	5d                   	pop    %rbp
    2109:	c3                   	retq   

000000000000210a <co_run_all>:

  int
co_run_all(void)
{
    210a:	f3 0f 1e fa          	endbr64 
    210e:	55                   	push   %rbp
    210f:	48 89 e5             	mov    %rsp,%rbp
    2112:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    2116:	48 b8 28 29 00 00 00 	movabs $0x2928,%rax
    211d:	00 00 00 
    2120:	48 8b 00             	mov    (%rax),%rax
    2123:	48 85 c0             	test   %rax,%rax
    2126:	75 07                	jne    212f <co_run_all+0x25>
		return 0;
    2128:	b8 00 00 00 00       	mov    $0x0,%eax
    212d:	eb 37                	jmp    2166 <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    212f:	48 b8 28 29 00 00 00 	movabs $0x2928,%rax
    2136:	00 00 00 
    2139:	48 8b 00             	mov    (%rax),%rax
    213c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    2140:	eb 18                	jmp    215a <co_run_all+0x50>
			co_run();
    2142:	48 b8 9f 20 00 00 00 	movabs $0x209f,%rax
    2149:	00 00 00 
    214c:	ff d0                	callq  *%rax
			tmp = tmp->next;
    214e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2152:	48 8b 40 08          	mov    0x8(%rax),%rax
    2156:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    215a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    215f:	75 e1                	jne    2142 <co_run_all+0x38>
		}
		return 1;
    2161:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    2166:	c9                   	leaveq 
    2167:	c3                   	retq   

0000000000002168 <co_yield>:

  void
co_yield()
{
    2168:	f3 0f 1e fa          	endbr64 
    216c:	55                   	push   %rbp
    216d:	48 89 e5             	mov    %rsp,%rbp
    2170:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    2174:	48 b8 20 29 00 00 00 	movabs $0x2920,%rax
    217b:	00 00 00 
    217e:	48 8b 00             	mov    (%rax),%rax
    2181:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    2185:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2189:	48 8b 40 08          	mov    0x8(%rax),%rax
    218d:	48 85 c0             	test   %rax,%rax
    2190:	74 46                	je     21d8 <co_yield+0x70>
  {
  	co_current = co_current->next;
    2192:	48 b8 20 29 00 00 00 	movabs $0x2920,%rax
    2199:	00 00 00 
    219c:	48 8b 00             	mov    (%rax),%rax
    219f:	48 8b 40 08          	mov    0x8(%rax),%rax
    21a3:	48 ba 20 29 00 00 00 	movabs $0x2920,%rdx
    21aa:	00 00 00 
    21ad:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    21b0:	48 b8 20 29 00 00 00 	movabs $0x2920,%rax
    21b7:	00 00 00 
    21ba:	48 8b 00             	mov    (%rax),%rax
    21bd:	48 8b 10             	mov    (%rax),%rdx
    21c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21c4:	48 89 d6             	mov    %rdx,%rsi
    21c7:	48 89 c7             	mov    %rax,%rdi
    21ca:	48 b8 71 23 00 00 00 	movabs $0x2371,%rax
    21d1:	00 00 00 
    21d4:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    21d6:	eb 34                	jmp    220c <co_yield+0xa4>
	co_current = 0;
    21d8:	48 b8 20 29 00 00 00 	movabs $0x2920,%rax
    21df:	00 00 00 
    21e2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    21e9:	48 b8 18 29 00 00 00 	movabs $0x2918,%rax
    21f0:	00 00 00 
    21f3:	48 8b 10             	mov    (%rax),%rdx
    21f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21fa:	48 89 d6             	mov    %rdx,%rsi
    21fd:	48 89 c7             	mov    %rax,%rdi
    2200:	48 b8 71 23 00 00 00 	movabs $0x2371,%rax
    2207:	00 00 00 
    220a:	ff d0                	callq  *%rax
}
    220c:	90                   	nop
    220d:	c9                   	leaveq 
    220e:	c3                   	retq   

000000000000220f <co_exit>:

  void
co_exit(void)
{
    220f:	f3 0f 1e fa          	endbr64 
    2213:	55                   	push   %rbp
    2214:	48 89 e5             	mov    %rsp,%rbp
    2217:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    221b:	48 b8 20 29 00 00 00 	movabs $0x2920,%rax
    2222:	00 00 00 
    2225:	48 8b 00             	mov    (%rax),%rax
    2228:	48 85 c0             	test   %rax,%rax
    222b:	0f 84 ec 00 00 00    	je     231d <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    2231:	48 b8 28 29 00 00 00 	movabs $0x2928,%rax
    2238:	00 00 00 
    223b:	48 8b 00             	mov    (%rax),%rax
    223e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    2242:	e9 c9 00 00 00       	jmpq   2310 <co_exit+0x101>
		if(tmp == co_current)
    2247:	48 b8 20 29 00 00 00 	movabs $0x2920,%rax
    224e:	00 00 00 
    2251:	48 8b 00             	mov    (%rax),%rax
    2254:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2258:	0f 85 9e 00 00 00    	jne    22fc <co_exit+0xed>
		{
			if(tmp->next)
    225e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2262:	48 8b 40 08          	mov    0x8(%rax),%rax
    2266:	48 85 c0             	test   %rax,%rax
    2269:	74 54                	je     22bf <co_exit+0xb0>
			{
				if(prev)
    226b:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    2270:	74 10                	je     2282 <co_exit+0x73>
				{
					prev->next = tmp->next;
    2272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2276:	48 8b 50 08          	mov    0x8(%rax),%rdx
    227a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    227e:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    2282:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2286:	48 8b 40 08          	mov    0x8(%rax),%rax
    228a:	48 ba 28 29 00 00 00 	movabs $0x2928,%rdx
    2291:	00 00 00 
    2294:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    2297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    229b:	48 8b 00             	mov    (%rax),%rax
    229e:	48 ba 20 29 00 00 00 	movabs $0x2920,%rdx
    22a5:	00 00 00 
    22a8:	48 8b 12             	mov    (%rdx),%rdx
    22ab:	48 89 c6             	mov    %rax,%rsi
    22ae:	48 89 d7             	mov    %rdx,%rdi
    22b1:	48 b8 71 23 00 00 00 	movabs $0x2371,%rax
    22b8:	00 00 00 
    22bb:	ff d0                	callq  *%rax
    22bd:	eb 3d                	jmp    22fc <co_exit+0xed>
			}else{
				co_list = 0;
    22bf:	48 b8 28 29 00 00 00 	movabs $0x2928,%rax
    22c6:	00 00 00 
    22c9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    22d0:	48 b8 18 29 00 00 00 	movabs $0x2918,%rax
    22d7:	00 00 00 
    22da:	48 8b 00             	mov    (%rax),%rax
    22dd:	48 ba 20 29 00 00 00 	movabs $0x2920,%rdx
    22e4:	00 00 00 
    22e7:	48 8b 12             	mov    (%rdx),%rdx
    22ea:	48 89 c6             	mov    %rax,%rsi
    22ed:	48 89 d7             	mov    %rdx,%rdi
    22f0:	48 b8 71 23 00 00 00 	movabs $0x2371,%rax
    22f7:	00 00 00 
    22fa:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    22fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2300:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    2304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2308:	48 8b 40 08          	mov    0x8(%rax),%rax
    230c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    2310:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2315:	0f 85 2c ff ff ff    	jne    2247 <co_exit+0x38>
    231b:	eb 01                	jmp    231e <co_exit+0x10f>
		return;
    231d:	90                   	nop
	}
}
    231e:	c9                   	leaveq 
    231f:	c3                   	retq   

0000000000002320 <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    2320:	f3 0f 1e fa          	endbr64 
    2324:	55                   	push   %rbp
    2325:	48 89 e5             	mov    %rsp,%rbp
    2328:	48 83 ec 10          	sub    $0x10,%rsp
    232c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    2330:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2335:	74 37                	je     236e <co_destroy+0x4e>
    if (co->stack)
    2337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    233b:	48 8b 40 10          	mov    0x10(%rax),%rax
    233f:	48 85 c0             	test   %rax,%rax
    2342:	74 17                	je     235b <co_destroy+0x3b>
      free(co->stack);
    2344:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2348:	48 8b 40 10          	mov    0x10(%rax),%rax
    234c:	48 89 c7             	mov    %rax,%rdi
    234f:	48 b8 83 1c 00 00 00 	movabs $0x1c83,%rax
    2356:	00 00 00 
    2359:	ff d0                	callq  *%rax
    free(co);
    235b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    235f:	48 89 c7             	mov    %rax,%rdi
    2362:	48 b8 83 1c 00 00 00 	movabs $0x1c83,%rax
    2369:	00 00 00 
    236c:	ff d0                	callq  *%rax
  }
}
    236e:	90                   	nop
    236f:	c9                   	leaveq 
    2370:	c3                   	retq   

0000000000002371 <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    2371:	55                   	push   %rbp
  pushq   %rbx
    2372:	53                   	push   %rbx
  pushq   %r12
    2373:	41 54                	push   %r12
  pushq   %r13
    2375:	41 55                	push   %r13
  pushq   %r14
    2377:	41 56                	push   %r14
  pushq   %r15
    2379:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    237b:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    237e:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    2381:	41 5f                	pop    %r15
  popq    %r14
    2383:	41 5e                	pop    %r14
  popq    %r13
    2385:	41 5d                	pop    %r13
  popq    %r12
    2387:	41 5c                	pop    %r12
  popq    %rbx
    2389:	5b                   	pop    %rbx
  popq    %rbp
    238a:	5d                   	pop    %rbp

  retq #??
    238b:	c3                   	retq   
