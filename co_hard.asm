
_co_hard:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <co_lock_worker>:
static volatile int shared_var = 0;
static volatile int locked = 0;

  void
co_lock_worker(void)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 10          	sub    $0x10,%rsp
  const int rank = shared_var++;
    100c:	48 b8 70 28 00 00 00 	movabs $0x2870,%rax
    1013:	00 00 00 
    1016:	8b 00                	mov    (%rax),%eax
    1018:	8d 50 01             	lea    0x1(%rax),%edx
    101b:	48 b9 70 28 00 00 00 	movabs $0x2870,%rcx
    1022:	00 00 00 
    1025:	89 11                	mov    %edx,(%rcx)
    1027:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if (locked) {
    102a:	48 b8 74 28 00 00 00 	movabs $0x2874,%rax
    1031:	00 00 00 
    1034:	8b 00                	mov    (%rax),%eax
    1036:	85 c0                	test   %eax,%eax
    1038:	74 79                	je     10b3 <co_lock_worker+0xb3>
    int counter = 0;
    103a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    do {
      if (counter == 0)
    1041:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1045:	75 27                	jne    106e <co_lock_worker+0x6e>
        printf(1, "co[%d] waiting for the lock\n", rank);
    1047:	8b 45 f4             	mov    -0xc(%rbp),%eax
    104a:	89 c2                	mov    %eax,%edx
    104c:	48 be 70 23 00 00 00 	movabs $0x2370,%rsi
    1053:	00 00 00 
    1056:	bf 01 00 00 00       	mov    $0x1,%edi
    105b:	b8 00 00 00 00       	mov    $0x0,%eax
    1060:	48 b9 51 18 00 00 00 	movabs $0x1851,%rcx
    1067:	00 00 00 
    106a:	ff d1                	callq  *%rcx
    106c:	eb 25                	jmp    1093 <co_lock_worker+0x93>
      else
        printf(1, "co[%d] the lock is still unavailable :(\n", rank);
    106e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1071:	89 c2                	mov    %eax,%edx
    1073:	48 be 90 23 00 00 00 	movabs $0x2390,%rsi
    107a:	00 00 00 
    107d:	bf 01 00 00 00       	mov    $0x1,%edi
    1082:	b8 00 00 00 00       	mov    $0x0,%eax
    1087:	48 b9 51 18 00 00 00 	movabs $0x1851,%rcx
    108e:	00 00 00 
    1091:	ff d1                	callq  *%rcx

      counter++;
    1093:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
      co_yield();
    1097:	48 b8 46 21 00 00 00 	movabs $0x2146,%rax
    109e:	00 00 00 
    10a1:	ff d0                	callq  *%rax
    } while (locked);
    10a3:	48 b8 74 28 00 00 00 	movabs $0x2874,%rax
    10aa:	00 00 00 
    10ad:	8b 00                	mov    (%rax),%eax
    10af:	85 c0                	test   %eax,%eax
    10b1:	75 8e                	jne    1041 <co_lock_worker+0x41>
  }
  locked = 1;
    10b3:	48 b8 74 28 00 00 00 	movabs $0x2874,%rax
    10ba:	00 00 00 
    10bd:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  printf(1, "co[%d] lock acquired :)\n", rank);
    10c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10c6:	89 c2                	mov    %eax,%edx
    10c8:	48 be b9 23 00 00 00 	movabs $0x23b9,%rsi
    10cf:	00 00 00 
    10d2:	bf 01 00 00 00       	mov    $0x1,%edi
    10d7:	b8 00 00 00 00       	mov    $0x0,%eax
    10dc:	48 b9 51 18 00 00 00 	movabs $0x1851,%rcx
    10e3:	00 00 00 
    10e6:	ff d1                	callq  *%rcx
  for (int i = 0; i < 10; i++) { // pretend to be doing something important while holding the lock
    10e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    10ef:	eb 10                	jmp    1101 <co_lock_worker+0x101>
    co_yield();
    10f1:	48 b8 46 21 00 00 00 	movabs $0x2146,%rax
    10f8:	00 00 00 
    10fb:	ff d0                	callq  *%rax
  for (int i = 0; i < 10; i++) { // pretend to be doing something important while holding the lock
    10fd:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    1101:	83 7d f8 09          	cmpl   $0x9,-0x8(%rbp)
    1105:	7e ea                	jle    10f1 <co_lock_worker+0xf1>
  }
  locked = 0; // unlock
    1107:	48 b8 74 28 00 00 00 	movabs $0x2874,%rax
    110e:	00 00 00 
    1111:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
    1117:	90                   	nop
    1118:	c9                   	leaveq 
    1119:	c3                   	retq   

000000000000111a <main>:

  int
main(int argc, char ** argv)
{
    111a:	f3 0f 1e fa          	endbr64 
    111e:	55                   	push   %rbp
    111f:	48 89 e5             	mov    %rsp,%rbp
    1122:	48 83 ec 30          	sub    $0x30,%rsp
    1126:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1129:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  struct coroutine * co[3];
  for (int i = 0; i < 3; i++) {
    112d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1134:	eb 60                	jmp    1196 <main+0x7c>
    co[i] = co_new(co_lock_worker);
    1136:	48 bf 00 10 00 00 00 	movabs $0x1000,%rdi
    113d:	00 00 00 
    1140:	48 b8 64 1f 00 00 00 	movabs $0x1f64,%rax
    1147:	00 00 00 
    114a:	ff d0                	callq  *%rax
    114c:	8b 55 fc             	mov    -0x4(%rbp),%edx
    114f:	48 63 d2             	movslq %edx,%rdx
    1152:	48 89 44 d5 e0       	mov    %rax,-0x20(%rbp,%rdx,8)
    if (!co[i]) {
    1157:	8b 45 fc             	mov    -0x4(%rbp),%eax
    115a:	48 98                	cltq   
    115c:	48 8b 44 c5 e0       	mov    -0x20(%rbp,%rax,8),%rax
    1161:	48 85 c0             	test   %rax,%rax
    1164:	75 2c                	jne    1192 <main+0x78>
      printf(1, "host: create co[%d] failed\n");
    1166:	48 be d2 23 00 00 00 	movabs $0x23d2,%rsi
    116d:	00 00 00 
    1170:	bf 01 00 00 00       	mov    $0x1,%edi
    1175:	b8 00 00 00 00       	mov    $0x0,%eax
    117a:	48 ba 51 18 00 00 00 	movabs $0x1851,%rdx
    1181:	00 00 00 
    1184:	ff d2                	callq  *%rdx
      exit();
    1186:	48 b8 67 15 00 00 00 	movabs $0x1567,%rax
    118d:	00 00 00 
    1190:	ff d0                	callq  *%rax
  for (int i = 0; i < 3; i++) {
    1192:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1196:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
    119a:	7e 9a                	jle    1136 <main+0x1c>
    }
  }
  printf(1, "host: coroutines created!\n");
    119c:	48 be ee 23 00 00 00 	movabs $0x23ee,%rsi
    11a3:	00 00 00 
    11a6:	bf 01 00 00 00       	mov    $0x1,%edi
    11ab:	b8 00 00 00 00       	mov    $0x0,%eax
    11b0:	48 ba 51 18 00 00 00 	movabs $0x1851,%rdx
    11b7:	00 00 00 
    11ba:	ff d2                	callq  *%rdx
  if (!co_run_all()) {
    11bc:	48 b8 e8 20 00 00 00 	movabs $0x20e8,%rax
    11c3:	00 00 00 
    11c6:	ff d0                	callq  *%rax
    11c8:	85 c0                	test   %eax,%eax
    11ca:	75 20                	jne    11ec <main+0xd2>
    printf(1, "\nhost: error: co_run_all() failed\n");
    11cc:	48 be 10 24 00 00 00 	movabs $0x2410,%rsi
    11d3:	00 00 00 
    11d6:	bf 01 00 00 00       	mov    $0x1,%edi
    11db:	b8 00 00 00 00       	mov    $0x0,%eax
    11e0:	48 ba 51 18 00 00 00 	movabs $0x1851,%rdx
    11e7:	00 00 00 
    11ea:	ff d2                	callq  *%rdx
  }
  for (int i = 0; i < 3; i++) {
    11ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    11f3:	eb 1d                	jmp    1212 <main+0xf8>
    co_destroy(co[i]);
    11f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
    11f8:	48 98                	cltq   
    11fa:	48 8b 44 c5 e0       	mov    -0x20(%rbp,%rax,8),%rax
    11ff:	48 89 c7             	mov    %rax,%rdi
    1202:	48 b8 fe 22 00 00 00 	movabs $0x22fe,%rax
    1209:	00 00 00 
    120c:	ff d0                	callq  *%rax
  for (int i = 0; i < 3; i++) {
    120e:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    1212:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
    1216:	7e dd                	jle    11f5 <main+0xdb>
  }
  exit();
    1218:	48 b8 67 15 00 00 00 	movabs $0x1567,%rax
    121f:	00 00 00 
    1222:	ff d0                	callq  *%rax

0000000000001224 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1224:	f3 0f 1e fa          	endbr64 
    1228:	55                   	push   %rbp
    1229:	48 89 e5             	mov    %rsp,%rbp
    122c:	48 83 ec 10          	sub    $0x10,%rsp
    1230:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1234:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1237:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    123a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    123e:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1241:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1244:	48 89 ce             	mov    %rcx,%rsi
    1247:	48 89 f7             	mov    %rsi,%rdi
    124a:	89 d1                	mov    %edx,%ecx
    124c:	fc                   	cld    
    124d:	f3 aa                	rep stos %al,%es:(%rdi)
    124f:	89 ca                	mov    %ecx,%edx
    1251:	48 89 fe             	mov    %rdi,%rsi
    1254:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1258:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    125b:	90                   	nop
    125c:	c9                   	leaveq 
    125d:	c3                   	retq   

000000000000125e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    125e:	f3 0f 1e fa          	endbr64 
    1262:	55                   	push   %rbp
    1263:	48 89 e5             	mov    %rsp,%rbp
    1266:	48 83 ec 20          	sub    $0x20,%rsp
    126a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    126e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1276:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    127a:	90                   	nop
    127b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    127f:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1283:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    128b:	48 8d 48 01          	lea    0x1(%rax),%rcx
    128f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1293:	0f b6 12             	movzbl (%rdx),%edx
    1296:	88 10                	mov    %dl,(%rax)
    1298:	0f b6 00             	movzbl (%rax),%eax
    129b:	84 c0                	test   %al,%al
    129d:	75 dc                	jne    127b <strcpy+0x1d>
    ;
  return os;
    129f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12a3:	c9                   	leaveq 
    12a4:	c3                   	retq   

00000000000012a5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12a5:	f3 0f 1e fa          	endbr64 
    12a9:	55                   	push   %rbp
    12aa:	48 89 e5             	mov    %rsp,%rbp
    12ad:	48 83 ec 10          	sub    $0x10,%rsp
    12b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    12b9:	eb 0a                	jmp    12c5 <strcmp+0x20>
    p++, q++;
    12bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12c0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    12c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12c9:	0f b6 00             	movzbl (%rax),%eax
    12cc:	84 c0                	test   %al,%al
    12ce:	74 12                	je     12e2 <strcmp+0x3d>
    12d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12d4:	0f b6 10             	movzbl (%rax),%edx
    12d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12db:	0f b6 00             	movzbl (%rax),%eax
    12de:	38 c2                	cmp    %al,%dl
    12e0:	74 d9                	je     12bb <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    12e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12e6:	0f b6 00             	movzbl (%rax),%eax
    12e9:	0f b6 d0             	movzbl %al,%edx
    12ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    12f0:	0f b6 00             	movzbl (%rax),%eax
    12f3:	0f b6 c0             	movzbl %al,%eax
    12f6:	29 c2                	sub    %eax,%edx
    12f8:	89 d0                	mov    %edx,%eax
}
    12fa:	c9                   	leaveq 
    12fb:	c3                   	retq   

00000000000012fc <strlen>:

uint
strlen(char *s)
{
    12fc:	f3 0f 1e fa          	endbr64 
    1300:	55                   	push   %rbp
    1301:	48 89 e5             	mov    %rsp,%rbp
    1304:	48 83 ec 18          	sub    $0x18,%rsp
    1308:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    130c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1313:	eb 04                	jmp    1319 <strlen+0x1d>
    1315:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1319:	8b 45 fc             	mov    -0x4(%rbp),%eax
    131c:	48 63 d0             	movslq %eax,%rdx
    131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1323:	48 01 d0             	add    %rdx,%rax
    1326:	0f b6 00             	movzbl (%rax),%eax
    1329:	84 c0                	test   %al,%al
    132b:	75 e8                	jne    1315 <strlen+0x19>
    ;
  return n;
    132d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1330:	c9                   	leaveq 
    1331:	c3                   	retq   

0000000000001332 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1332:	f3 0f 1e fa          	endbr64 
    1336:	55                   	push   %rbp
    1337:	48 89 e5             	mov    %rsp,%rbp
    133a:	48 83 ec 10          	sub    $0x10,%rsp
    133e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1342:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1345:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1348:	8b 55 f0             	mov    -0x10(%rbp),%edx
    134b:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1352:	89 ce                	mov    %ecx,%esi
    1354:	48 89 c7             	mov    %rax,%rdi
    1357:	48 b8 24 12 00 00 00 	movabs $0x1224,%rax
    135e:	00 00 00 
    1361:	ff d0                	callq  *%rax
  return dst;
    1363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1367:	c9                   	leaveq 
    1368:	c3                   	retq   

0000000000001369 <strchr>:

char*
strchr(const char *s, char c)
{
    1369:	f3 0f 1e fa          	endbr64 
    136d:	55                   	push   %rbp
    136e:	48 89 e5             	mov    %rsp,%rbp
    1371:	48 83 ec 10          	sub    $0x10,%rsp
    1375:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1379:	89 f0                	mov    %esi,%eax
    137b:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    137e:	eb 17                	jmp    1397 <strchr+0x2e>
    if(*s == c)
    1380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1384:	0f b6 00             	movzbl (%rax),%eax
    1387:	38 45 f4             	cmp    %al,-0xc(%rbp)
    138a:	75 06                	jne    1392 <strchr+0x29>
      return (char*)s;
    138c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1390:	eb 15                	jmp    13a7 <strchr+0x3e>
  for(; *s; s++)
    1392:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    139b:	0f b6 00             	movzbl (%rax),%eax
    139e:	84 c0                	test   %al,%al
    13a0:	75 de                	jne    1380 <strchr+0x17>
  return 0;
    13a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13a7:	c9                   	leaveq 
    13a8:	c3                   	retq   

00000000000013a9 <gets>:

char*
gets(char *buf, int max)
{
    13a9:	f3 0f 1e fa          	endbr64 
    13ad:	55                   	push   %rbp
    13ae:	48 89 e5             	mov    %rsp,%rbp
    13b1:	48 83 ec 20          	sub    $0x20,%rsp
    13b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13b9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    13c3:	eb 4f                	jmp    1414 <gets+0x6b>
    cc = read(0, &c, 1);
    13c5:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    13c9:	ba 01 00 00 00       	mov    $0x1,%edx
    13ce:	48 89 c6             	mov    %rax,%rsi
    13d1:	bf 00 00 00 00       	mov    $0x0,%edi
    13d6:	48 b8 8e 15 00 00 00 	movabs $0x158e,%rax
    13dd:	00 00 00 
    13e0:	ff d0                	callq  *%rax
    13e2:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    13e5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    13e9:	7e 36                	jle    1421 <gets+0x78>
      break;
    buf[i++] = c;
    13eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13ee:	8d 50 01             	lea    0x1(%rax),%edx
    13f1:	89 55 fc             	mov    %edx,-0x4(%rbp)
    13f4:	48 63 d0             	movslq %eax,%rdx
    13f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13fb:	48 01 c2             	add    %rax,%rdx
    13fe:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1402:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1404:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1408:	3c 0a                	cmp    $0xa,%al
    140a:	74 16                	je     1422 <gets+0x79>
    140c:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1410:	3c 0d                	cmp    $0xd,%al
    1412:	74 0e                	je     1422 <gets+0x79>
  for(i=0; i+1 < max; ){
    1414:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1417:	83 c0 01             	add    $0x1,%eax
    141a:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    141d:	7f a6                	jg     13c5 <gets+0x1c>
    141f:	eb 01                	jmp    1422 <gets+0x79>
      break;
    1421:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1422:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1425:	48 63 d0             	movslq %eax,%rdx
    1428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    142c:	48 01 d0             	add    %rdx,%rax
    142f:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1436:	c9                   	leaveq 
    1437:	c3                   	retq   

0000000000001438 <stat>:

int
stat(char *n, struct stat *st)
{
    1438:	f3 0f 1e fa          	endbr64 
    143c:	55                   	push   %rbp
    143d:	48 89 e5             	mov    %rsp,%rbp
    1440:	48 83 ec 20          	sub    $0x20,%rsp
    1444:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1448:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    144c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1450:	be 00 00 00 00       	mov    $0x0,%esi
    1455:	48 89 c7             	mov    %rax,%rdi
    1458:	48 b8 cf 15 00 00 00 	movabs $0x15cf,%rax
    145f:	00 00 00 
    1462:	ff d0                	callq  *%rax
    1464:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1467:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    146b:	79 07                	jns    1474 <stat+0x3c>
    return -1;
    146d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1472:	eb 2f                	jmp    14a3 <stat+0x6b>
  r = fstat(fd, st);
    1474:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1478:	8b 45 fc             	mov    -0x4(%rbp),%eax
    147b:	48 89 d6             	mov    %rdx,%rsi
    147e:	89 c7                	mov    %eax,%edi
    1480:	48 b8 f6 15 00 00 00 	movabs $0x15f6,%rax
    1487:	00 00 00 
    148a:	ff d0                	callq  *%rax
    148c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    148f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1492:	89 c7                	mov    %eax,%edi
    1494:	48 b8 a8 15 00 00 00 	movabs $0x15a8,%rax
    149b:	00 00 00 
    149e:	ff d0                	callq  *%rax
  return r;
    14a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    14a3:	c9                   	leaveq 
    14a4:	c3                   	retq   

00000000000014a5 <atoi>:

int
atoi(const char *s)
{
    14a5:	f3 0f 1e fa          	endbr64 
    14a9:	55                   	push   %rbp
    14aa:	48 89 e5             	mov    %rsp,%rbp
    14ad:	48 83 ec 18          	sub    $0x18,%rsp
    14b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    14b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    14bc:	eb 28                	jmp    14e6 <atoi+0x41>
    n = n*10 + *s++ - '0';
    14be:	8b 55 fc             	mov    -0x4(%rbp),%edx
    14c1:	89 d0                	mov    %edx,%eax
    14c3:	c1 e0 02             	shl    $0x2,%eax
    14c6:	01 d0                	add    %edx,%eax
    14c8:	01 c0                	add    %eax,%eax
    14ca:	89 c1                	mov    %eax,%ecx
    14cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
    14d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    14d8:	0f b6 00             	movzbl (%rax),%eax
    14db:	0f be c0             	movsbl %al,%eax
    14de:	01 c8                	add    %ecx,%eax
    14e0:	83 e8 30             	sub    $0x30,%eax
    14e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    14e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14ea:	0f b6 00             	movzbl (%rax),%eax
    14ed:	3c 2f                	cmp    $0x2f,%al
    14ef:	7e 0b                	jle    14fc <atoi+0x57>
    14f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14f5:	0f b6 00             	movzbl (%rax),%eax
    14f8:	3c 39                	cmp    $0x39,%al
    14fa:	7e c2                	jle    14be <atoi+0x19>
  return n;
    14fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    14ff:	c9                   	leaveq 
    1500:	c3                   	retq   

0000000000001501 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1501:	f3 0f 1e fa          	endbr64 
    1505:	55                   	push   %rbp
    1506:	48 89 e5             	mov    %rsp,%rbp
    1509:	48 83 ec 28          	sub    $0x28,%rsp
    150d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1511:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1515:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    151c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1520:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1524:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1528:	eb 1d                	jmp    1547 <memmove+0x46>
    *dst++ = *src++;
    152a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    152e:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1532:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1536:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    153a:	48 8d 48 01          	lea    0x1(%rax),%rcx
    153e:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1542:	0f b6 12             	movzbl (%rdx),%edx
    1545:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1547:	8b 45 dc             	mov    -0x24(%rbp),%eax
    154a:	8d 50 ff             	lea    -0x1(%rax),%edx
    154d:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1550:	85 c0                	test   %eax,%eax
    1552:	7f d6                	jg     152a <memmove+0x29>
  return vdst;
    1554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1558:	c9                   	leaveq 
    1559:	c3                   	retq   

000000000000155a <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    155a:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1561:	49 89 ca             	mov    %rcx,%r10
    1564:	0f 05                	syscall 
    1566:	c3                   	retq   

0000000000001567 <exit>:
SYSCALL(exit)
    1567:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    156e:	49 89 ca             	mov    %rcx,%r10
    1571:	0f 05                	syscall 
    1573:	c3                   	retq   

0000000000001574 <wait>:
SYSCALL(wait)
    1574:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    157b:	49 89 ca             	mov    %rcx,%r10
    157e:	0f 05                	syscall 
    1580:	c3                   	retq   

0000000000001581 <pipe>:
SYSCALL(pipe)
    1581:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1588:	49 89 ca             	mov    %rcx,%r10
    158b:	0f 05                	syscall 
    158d:	c3                   	retq   

000000000000158e <read>:
SYSCALL(read)
    158e:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1595:	49 89 ca             	mov    %rcx,%r10
    1598:	0f 05                	syscall 
    159a:	c3                   	retq   

000000000000159b <write>:
SYSCALL(write)
    159b:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    15a2:	49 89 ca             	mov    %rcx,%r10
    15a5:	0f 05                	syscall 
    15a7:	c3                   	retq   

00000000000015a8 <close>:
SYSCALL(close)
    15a8:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    15af:	49 89 ca             	mov    %rcx,%r10
    15b2:	0f 05                	syscall 
    15b4:	c3                   	retq   

00000000000015b5 <kill>:
SYSCALL(kill)
    15b5:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    15bc:	49 89 ca             	mov    %rcx,%r10
    15bf:	0f 05                	syscall 
    15c1:	c3                   	retq   

00000000000015c2 <exec>:
SYSCALL(exec)
    15c2:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    15c9:	49 89 ca             	mov    %rcx,%r10
    15cc:	0f 05                	syscall 
    15ce:	c3                   	retq   

00000000000015cf <open>:
SYSCALL(open)
    15cf:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    15d6:	49 89 ca             	mov    %rcx,%r10
    15d9:	0f 05                	syscall 
    15db:	c3                   	retq   

00000000000015dc <mknod>:
SYSCALL(mknod)
    15dc:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    15e3:	49 89 ca             	mov    %rcx,%r10
    15e6:	0f 05                	syscall 
    15e8:	c3                   	retq   

00000000000015e9 <unlink>:
SYSCALL(unlink)
    15e9:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    15f0:	49 89 ca             	mov    %rcx,%r10
    15f3:	0f 05                	syscall 
    15f5:	c3                   	retq   

00000000000015f6 <fstat>:
SYSCALL(fstat)
    15f6:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    15fd:	49 89 ca             	mov    %rcx,%r10
    1600:	0f 05                	syscall 
    1602:	c3                   	retq   

0000000000001603 <link>:
SYSCALL(link)
    1603:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    160a:	49 89 ca             	mov    %rcx,%r10
    160d:	0f 05                	syscall 
    160f:	c3                   	retq   

0000000000001610 <mkdir>:
SYSCALL(mkdir)
    1610:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1617:	49 89 ca             	mov    %rcx,%r10
    161a:	0f 05                	syscall 
    161c:	c3                   	retq   

000000000000161d <chdir>:
SYSCALL(chdir)
    161d:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1624:	49 89 ca             	mov    %rcx,%r10
    1627:	0f 05                	syscall 
    1629:	c3                   	retq   

000000000000162a <dup>:
SYSCALL(dup)
    162a:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1631:	49 89 ca             	mov    %rcx,%r10
    1634:	0f 05                	syscall 
    1636:	c3                   	retq   

0000000000001637 <getpid>:
SYSCALL(getpid)
    1637:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    163e:	49 89 ca             	mov    %rcx,%r10
    1641:	0f 05                	syscall 
    1643:	c3                   	retq   

0000000000001644 <sbrk>:
SYSCALL(sbrk)
    1644:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    164b:	49 89 ca             	mov    %rcx,%r10
    164e:	0f 05                	syscall 
    1650:	c3                   	retq   

0000000000001651 <sleep>:
SYSCALL(sleep)
    1651:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1658:	49 89 ca             	mov    %rcx,%r10
    165b:	0f 05                	syscall 
    165d:	c3                   	retq   

000000000000165e <uptime>:
SYSCALL(uptime)
    165e:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1665:	49 89 ca             	mov    %rcx,%r10
    1668:	0f 05                	syscall 
    166a:	c3                   	retq   

000000000000166b <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    166b:	f3 0f 1e fa          	endbr64 
    166f:	55                   	push   %rbp
    1670:	48 89 e5             	mov    %rsp,%rbp
    1673:	48 83 ec 10          	sub    $0x10,%rsp
    1677:	89 7d fc             	mov    %edi,-0x4(%rbp)
    167a:	89 f0                	mov    %esi,%eax
    167c:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    167f:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1683:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1686:	ba 01 00 00 00       	mov    $0x1,%edx
    168b:	48 89 ce             	mov    %rcx,%rsi
    168e:	89 c7                	mov    %eax,%edi
    1690:	48 b8 9b 15 00 00 00 	movabs $0x159b,%rax
    1697:	00 00 00 
    169a:	ff d0                	callq  *%rax
}
    169c:	90                   	nop
    169d:	c9                   	leaveq 
    169e:	c3                   	retq   

000000000000169f <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    169f:	f3 0f 1e fa          	endbr64 
    16a3:	55                   	push   %rbp
    16a4:	48 89 e5             	mov    %rsp,%rbp
    16a7:	48 83 ec 20          	sub    $0x20,%rsp
    16ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    16b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16b9:	eb 35                	jmp    16f0 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    16bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    16bf:	48 c1 e8 3c          	shr    $0x3c,%rax
    16c3:	48 ba 50 28 00 00 00 	movabs $0x2850,%rdx
    16ca:	00 00 00 
    16cd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    16d1:	0f be d0             	movsbl %al,%edx
    16d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16d7:	89 d6                	mov    %edx,%esi
    16d9:	89 c7                	mov    %eax,%edi
    16db:	48 b8 6b 16 00 00 00 	movabs $0x166b,%rax
    16e2:	00 00 00 
    16e5:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    16e7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16eb:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    16f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16f3:	83 f8 0f             	cmp    $0xf,%eax
    16f6:	76 c3                	jbe    16bb <print_x64+0x1c>
}
    16f8:	90                   	nop
    16f9:	90                   	nop
    16fa:	c9                   	leaveq 
    16fb:	c3                   	retq   

00000000000016fc <print_x32>:

  static void
print_x32(int fd, uint x)
{
    16fc:	f3 0f 1e fa          	endbr64 
    1700:	55                   	push   %rbp
    1701:	48 89 e5             	mov    %rsp,%rbp
    1704:	48 83 ec 20          	sub    $0x20,%rsp
    1708:	89 7d ec             	mov    %edi,-0x14(%rbp)
    170b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1715:	eb 36                	jmp    174d <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1717:	8b 45 e8             	mov    -0x18(%rbp),%eax
    171a:	c1 e8 1c             	shr    $0x1c,%eax
    171d:	89 c2                	mov    %eax,%edx
    171f:	48 b8 50 28 00 00 00 	movabs $0x2850,%rax
    1726:	00 00 00 
    1729:	89 d2                	mov    %edx,%edx
    172b:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    172f:	0f be d0             	movsbl %al,%edx
    1732:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1735:	89 d6                	mov    %edx,%esi
    1737:	89 c7                	mov    %eax,%edi
    1739:	48 b8 6b 16 00 00 00 	movabs $0x166b,%rax
    1740:	00 00 00 
    1743:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1745:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1749:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    174d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1750:	83 f8 07             	cmp    $0x7,%eax
    1753:	76 c2                	jbe    1717 <print_x32+0x1b>
}
    1755:	90                   	nop
    1756:	90                   	nop
    1757:	c9                   	leaveq 
    1758:	c3                   	retq   

0000000000001759 <print_d>:

  static void
print_d(int fd, int v)
{
    1759:	f3 0f 1e fa          	endbr64 
    175d:	55                   	push   %rbp
    175e:	48 89 e5             	mov    %rsp,%rbp
    1761:	48 83 ec 30          	sub    $0x30,%rsp
    1765:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1768:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    176b:	8b 45 d8             	mov    -0x28(%rbp),%eax
    176e:	48 98                	cltq   
    1770:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1774:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1778:	79 04                	jns    177e <print_d+0x25>
    x = -x;
    177a:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    177e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1785:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1789:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1790:	66 66 66 
    1793:	48 89 c8             	mov    %rcx,%rax
    1796:	48 f7 ea             	imul   %rdx
    1799:	48 c1 fa 02          	sar    $0x2,%rdx
    179d:	48 89 c8             	mov    %rcx,%rax
    17a0:	48 c1 f8 3f          	sar    $0x3f,%rax
    17a4:	48 29 c2             	sub    %rax,%rdx
    17a7:	48 89 d0             	mov    %rdx,%rax
    17aa:	48 c1 e0 02          	shl    $0x2,%rax
    17ae:	48 01 d0             	add    %rdx,%rax
    17b1:	48 01 c0             	add    %rax,%rax
    17b4:	48 29 c1             	sub    %rax,%rcx
    17b7:	48 89 ca             	mov    %rcx,%rdx
    17ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17bd:	8d 48 01             	lea    0x1(%rax),%ecx
    17c0:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    17c3:	48 b9 50 28 00 00 00 	movabs $0x2850,%rcx
    17ca:	00 00 00 
    17cd:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    17d1:	48 98                	cltq   
    17d3:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    17d7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    17db:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    17e2:	66 66 66 
    17e5:	48 89 c8             	mov    %rcx,%rax
    17e8:	48 f7 ea             	imul   %rdx
    17eb:	48 c1 fa 02          	sar    $0x2,%rdx
    17ef:	48 89 c8             	mov    %rcx,%rax
    17f2:	48 c1 f8 3f          	sar    $0x3f,%rax
    17f6:	48 29 c2             	sub    %rax,%rdx
    17f9:	48 89 d0             	mov    %rdx,%rax
    17fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1800:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1805:	0f 85 7a ff ff ff    	jne    1785 <print_d+0x2c>

  if (v < 0)
    180b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    180f:	79 32                	jns    1843 <print_d+0xea>
    buf[i++] = '-';
    1811:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1814:	8d 50 01             	lea    0x1(%rax),%edx
    1817:	89 55 f4             	mov    %edx,-0xc(%rbp)
    181a:	48 98                	cltq   
    181c:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1821:	eb 20                	jmp    1843 <print_d+0xea>
    putc(fd, buf[i]);
    1823:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1826:	48 98                	cltq   
    1828:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    182d:	0f be d0             	movsbl %al,%edx
    1830:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1833:	89 d6                	mov    %edx,%esi
    1835:	89 c7                	mov    %eax,%edi
    1837:	48 b8 6b 16 00 00 00 	movabs $0x166b,%rax
    183e:	00 00 00 
    1841:	ff d0                	callq  *%rax
  while (--i >= 0)
    1843:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1847:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    184b:	79 d6                	jns    1823 <print_d+0xca>
}
    184d:	90                   	nop
    184e:	90                   	nop
    184f:	c9                   	leaveq 
    1850:	c3                   	retq   

0000000000001851 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1851:	f3 0f 1e fa          	endbr64 
    1855:	55                   	push   %rbp
    1856:	48 89 e5             	mov    %rsp,%rbp
    1859:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1860:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1866:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    186d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1874:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    187b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1882:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1889:	84 c0                	test   %al,%al
    188b:	74 20                	je     18ad <printf+0x5c>
    188d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1891:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1895:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1899:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    189d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    18a1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    18a5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    18a9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    18ad:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    18b4:	00 00 00 
    18b7:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    18be:	00 00 00 
    18c1:	48 8d 45 10          	lea    0x10(%rbp),%rax
    18c5:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    18cc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    18d3:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    18da:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    18e1:	00 00 00 
    18e4:	e9 41 03 00 00       	jmpq   1c2a <printf+0x3d9>
    if (c != '%') {
    18e9:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18f0:	74 24                	je     1916 <printf+0xc5>
      putc(fd, c);
    18f2:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    18f8:	0f be d0             	movsbl %al,%edx
    18fb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1901:	89 d6                	mov    %edx,%esi
    1903:	89 c7                	mov    %eax,%edi
    1905:	48 b8 6b 16 00 00 00 	movabs $0x166b,%rax
    190c:	00 00 00 
    190f:	ff d0                	callq  *%rax
      continue;
    1911:	e9 0d 03 00 00       	jmpq   1c23 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1916:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    191d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1923:	48 63 d0             	movslq %eax,%rdx
    1926:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    192d:	48 01 d0             	add    %rdx,%rax
    1930:	0f b6 00             	movzbl (%rax),%eax
    1933:	0f be c0             	movsbl %al,%eax
    1936:	25 ff 00 00 00       	and    $0xff,%eax
    193b:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1941:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1948:	0f 84 0f 03 00 00    	je     1c5d <printf+0x40c>
      break;
    switch(c) {
    194e:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1955:	0f 84 74 02 00 00    	je     1bcf <printf+0x37e>
    195b:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1962:	0f 8c 82 02 00 00    	jl     1bea <printf+0x399>
    1968:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    196f:	0f 8f 75 02 00 00    	jg     1bea <printf+0x399>
    1975:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    197c:	0f 8c 68 02 00 00    	jl     1bea <printf+0x399>
    1982:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1988:	83 e8 63             	sub    $0x63,%eax
    198b:	83 f8 15             	cmp    $0x15,%eax
    198e:	0f 87 56 02 00 00    	ja     1bea <printf+0x399>
    1994:	89 c0                	mov    %eax,%eax
    1996:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    199d:	00 
    199e:	48 b8 40 24 00 00 00 	movabs $0x2440,%rax
    19a5:	00 00 00 
    19a8:	48 01 d0             	add    %rdx,%rax
    19ab:	48 8b 00             	mov    (%rax),%rax
    19ae:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    19b1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19b7:	83 f8 2f             	cmp    $0x2f,%eax
    19ba:	77 23                	ja     19df <printf+0x18e>
    19bc:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19c3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19c9:	89 d2                	mov    %edx,%edx
    19cb:	48 01 d0             	add    %rdx,%rax
    19ce:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d4:	83 c2 08             	add    $0x8,%edx
    19d7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19dd:	eb 12                	jmp    19f1 <printf+0x1a0>
    19df:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19e6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19ea:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19f1:	8b 00                	mov    (%rax),%eax
    19f3:	0f be d0             	movsbl %al,%edx
    19f6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19fc:	89 d6                	mov    %edx,%esi
    19fe:	89 c7                	mov    %eax,%edi
    1a00:	48 b8 6b 16 00 00 00 	movabs $0x166b,%rax
    1a07:	00 00 00 
    1a0a:	ff d0                	callq  *%rax
      break;
    1a0c:	e9 12 02 00 00       	jmpq   1c23 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1a11:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a17:	83 f8 2f             	cmp    $0x2f,%eax
    1a1a:	77 23                	ja     1a3f <printf+0x1ee>
    1a1c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a23:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a29:	89 d2                	mov    %edx,%edx
    1a2b:	48 01 d0             	add    %rdx,%rax
    1a2e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a34:	83 c2 08             	add    $0x8,%edx
    1a37:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a3d:	eb 12                	jmp    1a51 <printf+0x200>
    1a3f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a46:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a4a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a51:	8b 10                	mov    (%rax),%edx
    1a53:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a59:	89 d6                	mov    %edx,%esi
    1a5b:	89 c7                	mov    %eax,%edi
    1a5d:	48 b8 59 17 00 00 00 	movabs $0x1759,%rax
    1a64:	00 00 00 
    1a67:	ff d0                	callq  *%rax
      break;
    1a69:	e9 b5 01 00 00       	jmpq   1c23 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1a6e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a74:	83 f8 2f             	cmp    $0x2f,%eax
    1a77:	77 23                	ja     1a9c <printf+0x24b>
    1a79:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a80:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a86:	89 d2                	mov    %edx,%edx
    1a88:	48 01 d0             	add    %rdx,%rax
    1a8b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a91:	83 c2 08             	add    $0x8,%edx
    1a94:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a9a:	eb 12                	jmp    1aae <printf+0x25d>
    1a9c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1aa3:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1aa7:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1aae:	8b 10                	mov    (%rax),%edx
    1ab0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ab6:	89 d6                	mov    %edx,%esi
    1ab8:	89 c7                	mov    %eax,%edi
    1aba:	48 b8 fc 16 00 00 00 	movabs $0x16fc,%rax
    1ac1:	00 00 00 
    1ac4:	ff d0                	callq  *%rax
      break;
    1ac6:	e9 58 01 00 00       	jmpq   1c23 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1acb:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ad1:	83 f8 2f             	cmp    $0x2f,%eax
    1ad4:	77 23                	ja     1af9 <printf+0x2a8>
    1ad6:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1add:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ae3:	89 d2                	mov    %edx,%edx
    1ae5:	48 01 d0             	add    %rdx,%rax
    1ae8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aee:	83 c2 08             	add    $0x8,%edx
    1af1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1af7:	eb 12                	jmp    1b0b <printf+0x2ba>
    1af9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b00:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b04:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b0b:	48 8b 10             	mov    (%rax),%rdx
    1b0e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b14:	48 89 d6             	mov    %rdx,%rsi
    1b17:	89 c7                	mov    %eax,%edi
    1b19:	48 b8 9f 16 00 00 00 	movabs $0x169f,%rax
    1b20:	00 00 00 
    1b23:	ff d0                	callq  *%rax
      break;
    1b25:	e9 f9 00 00 00       	jmpq   1c23 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1b2a:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b30:	83 f8 2f             	cmp    $0x2f,%eax
    1b33:	77 23                	ja     1b58 <printf+0x307>
    1b35:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b3c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b42:	89 d2                	mov    %edx,%edx
    1b44:	48 01 d0             	add    %rdx,%rax
    1b47:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b4d:	83 c2 08             	add    $0x8,%edx
    1b50:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b56:	eb 12                	jmp    1b6a <printf+0x319>
    1b58:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b5f:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b63:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b6a:	48 8b 00             	mov    (%rax),%rax
    1b6d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1b74:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b7b:	00 
    1b7c:	75 41                	jne    1bbf <printf+0x36e>
        s = "(null)";
    1b7e:	48 b8 38 24 00 00 00 	movabs $0x2438,%rax
    1b85:	00 00 00 
    1b88:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b8f:	eb 2e                	jmp    1bbf <printf+0x36e>
        putc(fd, *(s++));
    1b91:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b98:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b9c:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1ba3:	0f b6 00             	movzbl (%rax),%eax
    1ba6:	0f be d0             	movsbl %al,%edx
    1ba9:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1baf:	89 d6                	mov    %edx,%esi
    1bb1:	89 c7                	mov    %eax,%edi
    1bb3:	48 b8 6b 16 00 00 00 	movabs $0x166b,%rax
    1bba:	00 00 00 
    1bbd:	ff d0                	callq  *%rax
      while (*s)
    1bbf:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1bc6:	0f b6 00             	movzbl (%rax),%eax
    1bc9:	84 c0                	test   %al,%al
    1bcb:	75 c4                	jne    1b91 <printf+0x340>
      break;
    1bcd:	eb 54                	jmp    1c23 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1bcf:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bd5:	be 25 00 00 00       	mov    $0x25,%esi
    1bda:	89 c7                	mov    %eax,%edi
    1bdc:	48 b8 6b 16 00 00 00 	movabs $0x166b,%rax
    1be3:	00 00 00 
    1be6:	ff d0                	callq  *%rax
      break;
    1be8:	eb 39                	jmp    1c23 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1bea:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bf0:	be 25 00 00 00       	mov    $0x25,%esi
    1bf5:	89 c7                	mov    %eax,%edi
    1bf7:	48 b8 6b 16 00 00 00 	movabs $0x166b,%rax
    1bfe:	00 00 00 
    1c01:	ff d0                	callq  *%rax
      putc(fd, c);
    1c03:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1c09:	0f be d0             	movsbl %al,%edx
    1c0c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c12:	89 d6                	mov    %edx,%esi
    1c14:	89 c7                	mov    %eax,%edi
    1c16:	48 b8 6b 16 00 00 00 	movabs $0x166b,%rax
    1c1d:	00 00 00 
    1c20:	ff d0                	callq  *%rax
      break;
    1c22:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1c23:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1c2a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1c30:	48 63 d0             	movslq %eax,%rdx
    1c33:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1c3a:	48 01 d0             	add    %rdx,%rax
    1c3d:	0f b6 00             	movzbl (%rax),%eax
    1c40:	0f be c0             	movsbl %al,%eax
    1c43:	25 ff 00 00 00       	and    $0xff,%eax
    1c48:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1c4e:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1c55:	0f 85 8e fc ff ff    	jne    18e9 <printf+0x98>
    }
  }
}
    1c5b:	eb 01                	jmp    1c5e <printf+0x40d>
      break;
    1c5d:	90                   	nop
}
    1c5e:	90                   	nop
    1c5f:	c9                   	leaveq 
    1c60:	c3                   	retq   

0000000000001c61 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1c61:	f3 0f 1e fa          	endbr64 
    1c65:	55                   	push   %rbp
    1c66:	48 89 e5             	mov    %rsp,%rbp
    1c69:	48 83 ec 18          	sub    $0x18,%rsp
    1c6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1c71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c75:	48 83 e8 10          	sub    $0x10,%rax
    1c79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c7d:	48 b8 90 28 00 00 00 	movabs $0x2890,%rax
    1c84:	00 00 00 
    1c87:	48 8b 00             	mov    (%rax),%rax
    1c8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c8e:	eb 2f                	jmp    1cbf <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c94:	48 8b 00             	mov    (%rax),%rax
    1c97:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c9b:	72 17                	jb     1cb4 <free+0x53>
    1c9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca1:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1ca5:	77 2f                	ja     1cd6 <free+0x75>
    1ca7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cab:	48 8b 00             	mov    (%rax),%rax
    1cae:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cb2:	72 22                	jb     1cd6 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1cb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb8:	48 8b 00             	mov    (%rax),%rax
    1cbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1cc7:	76 c7                	jbe    1c90 <free+0x2f>
    1cc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ccd:	48 8b 00             	mov    (%rax),%rax
    1cd0:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cd4:	73 ba                	jae    1c90 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1cd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cda:	8b 40 08             	mov    0x8(%rax),%eax
    1cdd:	89 c0                	mov    %eax,%eax
    1cdf:	48 c1 e0 04          	shl    $0x4,%rax
    1ce3:	48 89 c2             	mov    %rax,%rdx
    1ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cea:	48 01 c2             	add    %rax,%rdx
    1ced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf1:	48 8b 00             	mov    (%rax),%rax
    1cf4:	48 39 c2             	cmp    %rax,%rdx
    1cf7:	75 2d                	jne    1d26 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1cf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cfd:	8b 50 08             	mov    0x8(%rax),%edx
    1d00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d04:	48 8b 00             	mov    (%rax),%rax
    1d07:	8b 40 08             	mov    0x8(%rax),%eax
    1d0a:	01 c2                	add    %eax,%edx
    1d0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d10:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d17:	48 8b 00             	mov    (%rax),%rax
    1d1a:	48 8b 10             	mov    (%rax),%rdx
    1d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d21:	48 89 10             	mov    %rdx,(%rax)
    1d24:	eb 0e                	jmp    1d34 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2a:	48 8b 10             	mov    (%rax),%rdx
    1d2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d31:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1d34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d38:	8b 40 08             	mov    0x8(%rax),%eax
    1d3b:	89 c0                	mov    %eax,%eax
    1d3d:	48 c1 e0 04          	shl    $0x4,%rax
    1d41:	48 89 c2             	mov    %rax,%rdx
    1d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d48:	48 01 d0             	add    %rdx,%rax
    1d4b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d4f:	75 27                	jne    1d78 <free+0x117>
    p->s.size += bp->s.size;
    1d51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d55:	8b 50 08             	mov    0x8(%rax),%edx
    1d58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d5c:	8b 40 08             	mov    0x8(%rax),%eax
    1d5f:	01 c2                	add    %eax,%edx
    1d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d65:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1d68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d6c:	48 8b 10             	mov    (%rax),%rdx
    1d6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d73:	48 89 10             	mov    %rdx,(%rax)
    1d76:	eb 0b                	jmp    1d83 <free+0x122>
  } else
    p->s.ptr = bp;
    1d78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1d80:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1d83:	48 ba 90 28 00 00 00 	movabs $0x2890,%rdx
    1d8a:	00 00 00 
    1d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d91:	48 89 02             	mov    %rax,(%rdx)
}
    1d94:	90                   	nop
    1d95:	c9                   	leaveq 
    1d96:	c3                   	retq   

0000000000001d97 <morecore>:

static Header*
morecore(uint nu)
{
    1d97:	f3 0f 1e fa          	endbr64 
    1d9b:	55                   	push   %rbp
    1d9c:	48 89 e5             	mov    %rsp,%rbp
    1d9f:	48 83 ec 20          	sub    $0x20,%rsp
    1da3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1da6:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1dad:	77 07                	ja     1db6 <morecore+0x1f>
    nu = 4096;
    1daf:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1db6:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1db9:	48 c1 e0 04          	shl    $0x4,%rax
    1dbd:	48 89 c7             	mov    %rax,%rdi
    1dc0:	48 b8 44 16 00 00 00 	movabs $0x1644,%rax
    1dc7:	00 00 00 
    1dca:	ff d0                	callq  *%rax
    1dcc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1dd0:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1dd5:	75 07                	jne    1dde <morecore+0x47>
    return 0;
    1dd7:	b8 00 00 00 00       	mov    $0x0,%eax
    1ddc:	eb 36                	jmp    1e14 <morecore+0x7d>
  hp = (Header*)p;
    1dde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1de2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1de6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dea:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1ded:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1df0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1df4:	48 83 c0 10          	add    $0x10,%rax
    1df8:	48 89 c7             	mov    %rax,%rdi
    1dfb:	48 b8 61 1c 00 00 00 	movabs $0x1c61,%rax
    1e02:	00 00 00 
    1e05:	ff d0                	callq  *%rax
  return freep;
    1e07:	48 b8 90 28 00 00 00 	movabs $0x2890,%rax
    1e0e:	00 00 00 
    1e11:	48 8b 00             	mov    (%rax),%rax
}
    1e14:	c9                   	leaveq 
    1e15:	c3                   	retq   

0000000000001e16 <malloc>:

void*
malloc(uint nbytes)
{
    1e16:	f3 0f 1e fa          	endbr64 
    1e1a:	55                   	push   %rbp
    1e1b:	48 89 e5             	mov    %rsp,%rbp
    1e1e:	48 83 ec 30          	sub    $0x30,%rsp
    1e22:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1e25:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1e28:	48 83 c0 0f          	add    $0xf,%rax
    1e2c:	48 c1 e8 04          	shr    $0x4,%rax
    1e30:	83 c0 01             	add    $0x1,%eax
    1e33:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1e36:	48 b8 90 28 00 00 00 	movabs $0x2890,%rax
    1e3d:	00 00 00 
    1e40:	48 8b 00             	mov    (%rax),%rax
    1e43:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e47:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1e4c:	75 4a                	jne    1e98 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1e4e:	48 b8 80 28 00 00 00 	movabs $0x2880,%rax
    1e55:	00 00 00 
    1e58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e5c:	48 ba 90 28 00 00 00 	movabs $0x2890,%rdx
    1e63:	00 00 00 
    1e66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e6a:	48 89 02             	mov    %rax,(%rdx)
    1e6d:	48 b8 90 28 00 00 00 	movabs $0x2890,%rax
    1e74:	00 00 00 
    1e77:	48 8b 00             	mov    (%rax),%rax
    1e7a:	48 ba 80 28 00 00 00 	movabs $0x2880,%rdx
    1e81:	00 00 00 
    1e84:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1e87:	48 b8 80 28 00 00 00 	movabs $0x2880,%rax
    1e8e:	00 00 00 
    1e91:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e9c:	48 8b 00             	mov    (%rax),%rax
    1e9f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ea3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ea7:	8b 40 08             	mov    0x8(%rax),%eax
    1eaa:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1ead:	77 65                	ja     1f14 <malloc+0xfe>
      if(p->s.size == nunits)
    1eaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eb3:	8b 40 08             	mov    0x8(%rax),%eax
    1eb6:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1eb9:	75 10                	jne    1ecb <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1ebb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ebf:	48 8b 10             	mov    (%rax),%rdx
    1ec2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ec6:	48 89 10             	mov    %rdx,(%rax)
    1ec9:	eb 2e                	jmp    1ef9 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1ecb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ecf:	8b 40 08             	mov    0x8(%rax),%eax
    1ed2:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1ed5:	89 c2                	mov    %eax,%edx
    1ed7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1edb:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1ede:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ee2:	8b 40 08             	mov    0x8(%rax),%eax
    1ee5:	89 c0                	mov    %eax,%eax
    1ee7:	48 c1 e0 04          	shl    $0x4,%rax
    1eeb:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1eef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef3:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1ef6:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1ef9:	48 ba 90 28 00 00 00 	movabs $0x2890,%rdx
    1f00:	00 00 00 
    1f03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f07:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f0e:	48 83 c0 10          	add    $0x10,%rax
    1f12:	eb 4e                	jmp    1f62 <malloc+0x14c>
    }
    if(p == freep)
    1f14:	48 b8 90 28 00 00 00 	movabs $0x2890,%rax
    1f1b:	00 00 00 
    1f1e:	48 8b 00             	mov    (%rax),%rax
    1f21:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f25:	75 23                	jne    1f4a <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1f27:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1f2a:	89 c7                	mov    %eax,%edi
    1f2c:	48 b8 97 1d 00 00 00 	movabs $0x1d97,%rax
    1f33:	00 00 00 
    1f36:	ff d0                	callq  *%rax
    1f38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f3c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1f41:	75 07                	jne    1f4a <malloc+0x134>
        return 0;
    1f43:	b8 00 00 00 00       	mov    $0x0,%eax
    1f48:	eb 18                	jmp    1f62 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1f4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f4e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1f52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f56:	48 8b 00             	mov    (%rax),%rax
    1f59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f5d:	e9 41 ff ff ff       	jmpq   1ea3 <malloc+0x8d>
  }
}
    1f62:	c9                   	leaveq 
    1f63:	c3                   	retq   

0000000000001f64 <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1f64:	f3 0f 1e fa          	endbr64 
    1f68:	55                   	push   %rbp
    1f69:	48 89 e5             	mov    %rsp,%rbp
    1f6c:	48 83 ec 30          	sub    $0x30,%rsp
    1f70:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1f74:	bf 18 00 00 00       	mov    $0x18,%edi
    1f79:	48 b8 16 1e 00 00 00 	movabs $0x1e16,%rax
    1f80:	00 00 00 
    1f83:	ff d0                	callq  *%rax
    1f85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1f89:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1f8e:	75 0a                	jne    1f9a <co_new+0x36>
    return 0;
    1f90:	b8 00 00 00 00       	mov    $0x0,%eax
    1f95:	e9 e1 00 00 00       	jmpq   207b <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1f9a:	bf 00 20 00 00       	mov    $0x2000,%edi
    1f9f:	48 b8 16 1e 00 00 00 	movabs $0x1e16,%rax
    1fa6:	00 00 00 
    1fa9:	ff d0                	callq  *%rax
    1fab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1faf:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fb7:	48 8b 40 10          	mov    0x10(%rax),%rax
    1fbb:	48 85 c0             	test   %rax,%rax
    1fbe:	75 1d                	jne    1fdd <co_new+0x79>
    free(co1);
    1fc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fc4:	48 89 c7             	mov    %rax,%rdi
    1fc7:	48 b8 61 1c 00 00 00 	movabs $0x1c61,%rax
    1fce:	00 00 00 
    1fd1:	ff d0                	callq  *%rax
    return 0;
    1fd3:	b8 00 00 00 00       	mov    $0x0,%eax
    1fd8:	e9 9e 00 00 00       	jmpq   207b <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    1fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fe1:	48 8b 40 10          	mov    0x10(%rax),%rax
    1fe5:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    1feb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    1fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ff3:	48 8d 50 30          	lea    0x30(%rax),%rdx
    1ff7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1ffb:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    1ffe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2002:	48 83 c0 38          	add    $0x38,%rax
    2006:	48 ba ed 21 00 00 00 	movabs $0x21ed,%rdx
    200d:	00 00 00 
    2010:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    2013:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2017:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    201b:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    201e:	48 b8 a8 28 00 00 00 	movabs $0x28a8,%rax
    2025:	00 00 00 
    2028:	48 8b 00             	mov    (%rax),%rax
    202b:	48 85 c0             	test   %rax,%rax
    202e:	75 13                	jne    2043 <co_new+0xdf>
  {
  	co_list = co1;
    2030:	48 ba a8 28 00 00 00 	movabs $0x28a8,%rdx
    2037:	00 00 00 
    203a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    203e:	48 89 02             	mov    %rax,(%rdx)
    2041:	eb 34                	jmp    2077 <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    2043:	48 b8 a8 28 00 00 00 	movabs $0x28a8,%rax
    204a:	00 00 00 
    204d:	48 8b 00             	mov    (%rax),%rax
    2050:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    2054:	eb 0c                	jmp    2062 <co_new+0xfe>
	{
		head = head->next;
    2056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    205a:	48 8b 40 08          	mov    0x8(%rax),%rax
    205e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    2062:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2066:	48 8b 40 08          	mov    0x8(%rax),%rax
    206a:	48 85 c0             	test   %rax,%rax
    206d:	75 e7                	jne    2056 <co_new+0xf2>
	}
	head = co1;
    206f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2073:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    2077:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    207b:	c9                   	leaveq 
    207c:	c3                   	retq   

000000000000207d <co_run>:

  int
co_run(void)
{
    207d:	f3 0f 1e fa          	endbr64 
    2081:	55                   	push   %rbp
    2082:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    2085:	48 b8 a8 28 00 00 00 	movabs $0x28a8,%rax
    208c:	00 00 00 
    208f:	48 8b 00             	mov    (%rax),%rax
    2092:	48 85 c0             	test   %rax,%rax
    2095:	74 4a                	je     20e1 <co_run+0x64>
	{
		co_current = co_list;
    2097:	48 b8 a8 28 00 00 00 	movabs $0x28a8,%rax
    209e:	00 00 00 
    20a1:	48 8b 00             	mov    (%rax),%rax
    20a4:	48 ba a0 28 00 00 00 	movabs $0x28a0,%rdx
    20ab:	00 00 00 
    20ae:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    20b1:	48 b8 a0 28 00 00 00 	movabs $0x28a0,%rax
    20b8:	00 00 00 
    20bb:	48 8b 00             	mov    (%rax),%rax
    20be:	48 8b 00             	mov    (%rax),%rax
    20c1:	48 89 c6             	mov    %rax,%rsi
    20c4:	48 bf 98 28 00 00 00 	movabs $0x2898,%rdi
    20cb:	00 00 00 
    20ce:	48 b8 4f 23 00 00 00 	movabs $0x234f,%rax
    20d5:	00 00 00 
    20d8:	ff d0                	callq  *%rax
		return 1;
    20da:	b8 01 00 00 00       	mov    $0x1,%eax
    20df:	eb 05                	jmp    20e6 <co_run+0x69>
	}
	return 0;
    20e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
    20e6:	5d                   	pop    %rbp
    20e7:	c3                   	retq   

00000000000020e8 <co_run_all>:

  int
co_run_all(void)
{
    20e8:	f3 0f 1e fa          	endbr64 
    20ec:	55                   	push   %rbp
    20ed:	48 89 e5             	mov    %rsp,%rbp
    20f0:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    20f4:	48 b8 a8 28 00 00 00 	movabs $0x28a8,%rax
    20fb:	00 00 00 
    20fe:	48 8b 00             	mov    (%rax),%rax
    2101:	48 85 c0             	test   %rax,%rax
    2104:	75 07                	jne    210d <co_run_all+0x25>
		return 0;
    2106:	b8 00 00 00 00       	mov    $0x0,%eax
    210b:	eb 37                	jmp    2144 <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    210d:	48 b8 a8 28 00 00 00 	movabs $0x28a8,%rax
    2114:	00 00 00 
    2117:	48 8b 00             	mov    (%rax),%rax
    211a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    211e:	eb 18                	jmp    2138 <co_run_all+0x50>
			co_run();
    2120:	48 b8 7d 20 00 00 00 	movabs $0x207d,%rax
    2127:	00 00 00 
    212a:	ff d0                	callq  *%rax
			tmp = tmp->next;
    212c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2130:	48 8b 40 08          	mov    0x8(%rax),%rax
    2134:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    2138:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    213d:	75 e1                	jne    2120 <co_run_all+0x38>
		}
		return 1;
    213f:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    2144:	c9                   	leaveq 
    2145:	c3                   	retq   

0000000000002146 <co_yield>:

  void
co_yield()
{
    2146:	f3 0f 1e fa          	endbr64 
    214a:	55                   	push   %rbp
    214b:	48 89 e5             	mov    %rsp,%rbp
    214e:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    2152:	48 b8 a0 28 00 00 00 	movabs $0x28a0,%rax
    2159:	00 00 00 
    215c:	48 8b 00             	mov    (%rax),%rax
    215f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    2163:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2167:	48 8b 40 08          	mov    0x8(%rax),%rax
    216b:	48 85 c0             	test   %rax,%rax
    216e:	74 46                	je     21b6 <co_yield+0x70>
  {
  	co_current = co_current->next;
    2170:	48 b8 a0 28 00 00 00 	movabs $0x28a0,%rax
    2177:	00 00 00 
    217a:	48 8b 00             	mov    (%rax),%rax
    217d:	48 8b 40 08          	mov    0x8(%rax),%rax
    2181:	48 ba a0 28 00 00 00 	movabs $0x28a0,%rdx
    2188:	00 00 00 
    218b:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    218e:	48 b8 a0 28 00 00 00 	movabs $0x28a0,%rax
    2195:	00 00 00 
    2198:	48 8b 00             	mov    (%rax),%rax
    219b:	48 8b 10             	mov    (%rax),%rdx
    219e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21a2:	48 89 d6             	mov    %rdx,%rsi
    21a5:	48 89 c7             	mov    %rax,%rdi
    21a8:	48 b8 4f 23 00 00 00 	movabs $0x234f,%rax
    21af:	00 00 00 
    21b2:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    21b4:	eb 34                	jmp    21ea <co_yield+0xa4>
	co_current = 0;
    21b6:	48 b8 a0 28 00 00 00 	movabs $0x28a0,%rax
    21bd:	00 00 00 
    21c0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    21c7:	48 b8 98 28 00 00 00 	movabs $0x2898,%rax
    21ce:	00 00 00 
    21d1:	48 8b 10             	mov    (%rax),%rdx
    21d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21d8:	48 89 d6             	mov    %rdx,%rsi
    21db:	48 89 c7             	mov    %rax,%rdi
    21de:	48 b8 4f 23 00 00 00 	movabs $0x234f,%rax
    21e5:	00 00 00 
    21e8:	ff d0                	callq  *%rax
}
    21ea:	90                   	nop
    21eb:	c9                   	leaveq 
    21ec:	c3                   	retq   

00000000000021ed <co_exit>:

  void
co_exit(void)
{
    21ed:	f3 0f 1e fa          	endbr64 
    21f1:	55                   	push   %rbp
    21f2:	48 89 e5             	mov    %rsp,%rbp
    21f5:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    21f9:	48 b8 a0 28 00 00 00 	movabs $0x28a0,%rax
    2200:	00 00 00 
    2203:	48 8b 00             	mov    (%rax),%rax
    2206:	48 85 c0             	test   %rax,%rax
    2209:	0f 84 ec 00 00 00    	je     22fb <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    220f:	48 b8 a8 28 00 00 00 	movabs $0x28a8,%rax
    2216:	00 00 00 
    2219:	48 8b 00             	mov    (%rax),%rax
    221c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    2220:	e9 c9 00 00 00       	jmpq   22ee <co_exit+0x101>
		if(tmp == co_current)
    2225:	48 b8 a0 28 00 00 00 	movabs $0x28a0,%rax
    222c:	00 00 00 
    222f:	48 8b 00             	mov    (%rax),%rax
    2232:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2236:	0f 85 9e 00 00 00    	jne    22da <co_exit+0xed>
		{
			if(tmp->next)
    223c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2240:	48 8b 40 08          	mov    0x8(%rax),%rax
    2244:	48 85 c0             	test   %rax,%rax
    2247:	74 54                	je     229d <co_exit+0xb0>
			{
				if(prev)
    2249:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    224e:	74 10                	je     2260 <co_exit+0x73>
				{
					prev->next = tmp->next;
    2250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2254:	48 8b 50 08          	mov    0x8(%rax),%rdx
    2258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    225c:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    2260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2264:	48 8b 40 08          	mov    0x8(%rax),%rax
    2268:	48 ba a8 28 00 00 00 	movabs $0x28a8,%rdx
    226f:	00 00 00 
    2272:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    2275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2279:	48 8b 00             	mov    (%rax),%rax
    227c:	48 ba a0 28 00 00 00 	movabs $0x28a0,%rdx
    2283:	00 00 00 
    2286:	48 8b 12             	mov    (%rdx),%rdx
    2289:	48 89 c6             	mov    %rax,%rsi
    228c:	48 89 d7             	mov    %rdx,%rdi
    228f:	48 b8 4f 23 00 00 00 	movabs $0x234f,%rax
    2296:	00 00 00 
    2299:	ff d0                	callq  *%rax
    229b:	eb 3d                	jmp    22da <co_exit+0xed>
			}else{
				co_list = 0;
    229d:	48 b8 a8 28 00 00 00 	movabs $0x28a8,%rax
    22a4:	00 00 00 
    22a7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    22ae:	48 b8 98 28 00 00 00 	movabs $0x2898,%rax
    22b5:	00 00 00 
    22b8:	48 8b 00             	mov    (%rax),%rax
    22bb:	48 ba a0 28 00 00 00 	movabs $0x28a0,%rdx
    22c2:	00 00 00 
    22c5:	48 8b 12             	mov    (%rdx),%rdx
    22c8:	48 89 c6             	mov    %rax,%rsi
    22cb:	48 89 d7             	mov    %rdx,%rdi
    22ce:	48 b8 4f 23 00 00 00 	movabs $0x234f,%rax
    22d5:	00 00 00 
    22d8:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    22da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    22e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22e6:	48 8b 40 08          	mov    0x8(%rax),%rax
    22ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    22ee:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    22f3:	0f 85 2c ff ff ff    	jne    2225 <co_exit+0x38>
    22f9:	eb 01                	jmp    22fc <co_exit+0x10f>
		return;
    22fb:	90                   	nop
	}
}
    22fc:	c9                   	leaveq 
    22fd:	c3                   	retq   

00000000000022fe <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    22fe:	f3 0f 1e fa          	endbr64 
    2302:	55                   	push   %rbp
    2303:	48 89 e5             	mov    %rsp,%rbp
    2306:	48 83 ec 10          	sub    $0x10,%rsp
    230a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    230e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2313:	74 37                	je     234c <co_destroy+0x4e>
    if (co->stack)
    2315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2319:	48 8b 40 10          	mov    0x10(%rax),%rax
    231d:	48 85 c0             	test   %rax,%rax
    2320:	74 17                	je     2339 <co_destroy+0x3b>
      free(co->stack);
    2322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2326:	48 8b 40 10          	mov    0x10(%rax),%rax
    232a:	48 89 c7             	mov    %rax,%rdi
    232d:	48 b8 61 1c 00 00 00 	movabs $0x1c61,%rax
    2334:	00 00 00 
    2337:	ff d0                	callq  *%rax
    free(co);
    2339:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    233d:	48 89 c7             	mov    %rax,%rdi
    2340:	48 b8 61 1c 00 00 00 	movabs $0x1c61,%rax
    2347:	00 00 00 
    234a:	ff d0                	callq  *%rax
  }
}
    234c:	90                   	nop
    234d:	c9                   	leaveq 
    234e:	c3                   	retq   

000000000000234f <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    234f:	55                   	push   %rbp
  pushq   %rbx
    2350:	53                   	push   %rbx
  pushq   %r12
    2351:	41 54                	push   %r12
  pushq   %r13
    2353:	41 55                	push   %r13
  pushq   %r14
    2355:	41 56                	push   %r14
  pushq   %r15
    2357:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    2359:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    235c:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    235f:	41 5f                	pop    %r15
  popq    %r14
    2361:	41 5e                	pop    %r14
  popq    %r13
    2363:	41 5d                	pop    %r13
  popq    %r12
    2365:	41 5c                	pop    %r12
  popq    %rbx
    2367:	5b                   	pop    %rbx
  popq    %rbp
    2368:	5d                   	pop    %rbp

  retq #??
    2369:	c3                   	retq   
