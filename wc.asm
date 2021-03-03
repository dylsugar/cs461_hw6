
_wc:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 30          	sub    $0x30,%rsp
    100c:	89 7d dc             	mov    %edi,-0x24(%rbp)
    100f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
    1013:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
    101a:	8b 45 f0             	mov    -0x10(%rbp),%eax
    101d:	89 45 f4             	mov    %eax,-0xc(%rbp)
    1020:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1023:	89 45 f8             	mov    %eax,-0x8(%rbp)
  inword = 0;
    1026:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    102d:	e9 81 00 00 00       	jmpq   10b3 <wc+0xb3>
    for(i=0; i<n; i++){
    1032:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1039:	eb 70                	jmp    10ab <wc+0xab>
      c++;
    103b:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
      if(buf[i] == '\n')
    103f:	48 ba 20 28 00 00 00 	movabs $0x2820,%rdx
    1046:	00 00 00 
    1049:	8b 45 fc             	mov    -0x4(%rbp),%eax
    104c:	48 98                	cltq   
    104e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1052:	3c 0a                	cmp    $0xa,%al
    1054:	75 04                	jne    105a <wc+0x5a>
        l++;
    1056:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
      if(strchr(" \r\t\n\v", buf[i]))
    105a:	48 ba 20 28 00 00 00 	movabs $0x2820,%rdx
    1061:	00 00 00 
    1064:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1067:	48 98                	cltq   
    1069:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    106d:	0f be c0             	movsbl %al,%eax
    1070:	89 c6                	mov    %eax,%esi
    1072:	48 bf b8 23 00 00 00 	movabs $0x23b8,%rdi
    1079:	00 00 00 
    107c:	48 b8 b0 13 00 00 00 	movabs $0x13b0,%rax
    1083:	00 00 00 
    1086:	ff d0                	callq  *%rax
    1088:	48 85 c0             	test   %rax,%rax
    108b:	74 09                	je     1096 <wc+0x96>
        inword = 0;
    108d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    1094:	eb 11                	jmp    10a7 <wc+0xa7>
      else if(!inword){
    1096:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    109a:	75 0b                	jne    10a7 <wc+0xa7>
        w++;
    109c:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
        inword = 1;
    10a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
    for(i=0; i<n; i++){
    10a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10ae:	3b 45 e8             	cmp    -0x18(%rbp),%eax
    10b1:	7c 88                	jl     103b <wc+0x3b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    10b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
    10b6:	ba 00 02 00 00       	mov    $0x200,%edx
    10bb:	48 be 20 28 00 00 00 	movabs $0x2820,%rsi
    10c2:	00 00 00 
    10c5:	89 c7                	mov    %eax,%edi
    10c7:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    10ce:	00 00 00 
    10d1:	ff d0                	callq  *%rax
    10d3:	89 45 e8             	mov    %eax,-0x18(%rbp)
    10d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    10da:	0f 8f 52 ff ff ff    	jg     1032 <wc+0x32>
      }
    }
  }
  if(n < 0){
    10e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    10e4:	79 2c                	jns    1112 <wc+0x112>
    printf(1, "wc: read error\n");
    10e6:	48 be be 23 00 00 00 	movabs $0x23be,%rsi
    10ed:	00 00 00 
    10f0:	bf 01 00 00 00       	mov    $0x1,%edi
    10f5:	b8 00 00 00 00       	mov    $0x0,%eax
    10fa:	48 ba 98 18 00 00 00 	movabs $0x1898,%rdx
    1101:	00 00 00 
    1104:	ff d2                	callq  *%rdx
    exit();
    1106:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    110d:	00 00 00 
    1110:	ff d0                	callq  *%rax
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
    1112:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
    1116:	8b 4d f0             	mov    -0x10(%rbp),%ecx
    1119:	8b 55 f4             	mov    -0xc(%rbp),%edx
    111c:	8b 45 f8             	mov    -0x8(%rbp),%eax
    111f:	49 89 f1             	mov    %rsi,%r9
    1122:	41 89 c8             	mov    %ecx,%r8d
    1125:	89 d1                	mov    %edx,%ecx
    1127:	89 c2                	mov    %eax,%edx
    1129:	48 be ce 23 00 00 00 	movabs $0x23ce,%rsi
    1130:	00 00 00 
    1133:	bf 01 00 00 00       	mov    $0x1,%edi
    1138:	b8 00 00 00 00       	mov    $0x0,%eax
    113d:	49 ba 98 18 00 00 00 	movabs $0x1898,%r10
    1144:	00 00 00 
    1147:	41 ff d2             	callq  *%r10
}
    114a:	90                   	nop
    114b:	c9                   	leaveq 
    114c:	c3                   	retq   

000000000000114d <main>:

int
main(int argc, char *argv[])
{
    114d:	f3 0f 1e fa          	endbr64 
    1151:	55                   	push   %rbp
    1152:	48 89 e5             	mov    %rsp,%rbp
    1155:	48 83 ec 20          	sub    $0x20,%rsp
    1159:	89 7d ec             	mov    %edi,-0x14(%rbp)
    115c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd, i;

  if(argc <= 1){
    1160:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1164:	7f 27                	jg     118d <main+0x40>
    wc(0, "");
    1166:	48 be db 23 00 00 00 	movabs $0x23db,%rsi
    116d:	00 00 00 
    1170:	bf 00 00 00 00       	mov    $0x0,%edi
    1175:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    117c:	00 00 00 
    117f:	ff d0                	callq  *%rax
    exit();
    1181:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    1188:	00 00 00 
    118b:	ff d0                	callq  *%rax
  }

  for(i = 1; i < argc; i++){
    118d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    1194:	e9 ba 00 00 00       	jmpq   1253 <main+0x106>
    if((fd = open(argv[i], 0)) < 0){
    1199:	8b 45 fc             	mov    -0x4(%rbp),%eax
    119c:	48 98                	cltq   
    119e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11a5:	00 
    11a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    11aa:	48 01 d0             	add    %rdx,%rax
    11ad:	48 8b 00             	mov    (%rax),%rax
    11b0:	be 00 00 00 00       	mov    $0x0,%esi
    11b5:	48 89 c7             	mov    %rax,%rdi
    11b8:	48 b8 16 16 00 00 00 	movabs $0x1616,%rax
    11bf:	00 00 00 
    11c2:	ff d0                	callq  *%rax
    11c4:	89 45 f8             	mov    %eax,-0x8(%rbp)
    11c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    11cb:	79 46                	jns    1213 <main+0xc6>
      printf(1, "wc: cannot open %s\n", argv[i]);
    11cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11d0:	48 98                	cltq   
    11d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    11d9:	00 
    11da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    11de:	48 01 d0             	add    %rdx,%rax
    11e1:	48 8b 00             	mov    (%rax),%rax
    11e4:	48 89 c2             	mov    %rax,%rdx
    11e7:	48 be dc 23 00 00 00 	movabs $0x23dc,%rsi
    11ee:	00 00 00 
    11f1:	bf 01 00 00 00       	mov    $0x1,%edi
    11f6:	b8 00 00 00 00       	mov    $0x0,%eax
    11fb:	48 b9 98 18 00 00 00 	movabs $0x1898,%rcx
    1202:	00 00 00 
    1205:	ff d1                	callq  *%rcx
      exit();
    1207:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    120e:	00 00 00 
    1211:	ff d0                	callq  *%rax
    }
    wc(fd, argv[i]);
    1213:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1216:	48 98                	cltq   
    1218:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    121f:	00 
    1220:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1224:	48 01 d0             	add    %rdx,%rax
    1227:	48 8b 10             	mov    (%rax),%rdx
    122a:	8b 45 f8             	mov    -0x8(%rbp),%eax
    122d:	48 89 d6             	mov    %rdx,%rsi
    1230:	89 c7                	mov    %eax,%edi
    1232:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1239:	00 00 00 
    123c:	ff d0                	callq  *%rax
    close(fd);
    123e:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1241:	89 c7                	mov    %eax,%edi
    1243:	48 b8 ef 15 00 00 00 	movabs $0x15ef,%rax
    124a:	00 00 00 
    124d:	ff d0                	callq  *%rax
  for(i = 1; i < argc; i++){
    124f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1253:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1256:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1259:	0f 8c 3a ff ff ff    	jl     1199 <main+0x4c>
  }
  exit();
    125f:	48 b8 ae 15 00 00 00 	movabs $0x15ae,%rax
    1266:	00 00 00 
    1269:	ff d0                	callq  *%rax

000000000000126b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    126b:	f3 0f 1e fa          	endbr64 
    126f:	55                   	push   %rbp
    1270:	48 89 e5             	mov    %rsp,%rbp
    1273:	48 83 ec 10          	sub    $0x10,%rsp
    1277:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    127b:	89 75 f4             	mov    %esi,-0xc(%rbp)
    127e:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1281:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1285:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1288:	8b 45 f4             	mov    -0xc(%rbp),%eax
    128b:	48 89 ce             	mov    %rcx,%rsi
    128e:	48 89 f7             	mov    %rsi,%rdi
    1291:	89 d1                	mov    %edx,%ecx
    1293:	fc                   	cld    
    1294:	f3 aa                	rep stos %al,%es:(%rdi)
    1296:	89 ca                	mov    %ecx,%edx
    1298:	48 89 fe             	mov    %rdi,%rsi
    129b:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    129f:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    12a2:	90                   	nop
    12a3:	c9                   	leaveq 
    12a4:	c3                   	retq   

00000000000012a5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    12a5:	f3 0f 1e fa          	endbr64 
    12a9:	55                   	push   %rbp
    12aa:	48 89 e5             	mov    %rsp,%rbp
    12ad:	48 83 ec 20          	sub    $0x20,%rsp
    12b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    12b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    12c1:	90                   	nop
    12c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12c6:	48 8d 42 01          	lea    0x1(%rdx),%rax
    12ca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    12ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12d2:	48 8d 48 01          	lea    0x1(%rax),%rcx
    12d6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    12da:	0f b6 12             	movzbl (%rdx),%edx
    12dd:	88 10                	mov    %dl,(%rax)
    12df:	0f b6 00             	movzbl (%rax),%eax
    12e2:	84 c0                	test   %al,%al
    12e4:	75 dc                	jne    12c2 <strcpy+0x1d>
    ;
  return os;
    12e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    12ea:	c9                   	leaveq 
    12eb:	c3                   	retq   

00000000000012ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12ec:	f3 0f 1e fa          	endbr64 
    12f0:	55                   	push   %rbp
    12f1:	48 89 e5             	mov    %rsp,%rbp
    12f4:	48 83 ec 10          	sub    $0x10,%rsp
    12f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1300:	eb 0a                	jmp    130c <strcmp+0x20>
    p++, q++;
    1302:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1307:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    130c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1310:	0f b6 00             	movzbl (%rax),%eax
    1313:	84 c0                	test   %al,%al
    1315:	74 12                	je     1329 <strcmp+0x3d>
    1317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    131b:	0f b6 10             	movzbl (%rax),%edx
    131e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1322:	0f b6 00             	movzbl (%rax),%eax
    1325:	38 c2                	cmp    %al,%dl
    1327:	74 d9                	je     1302 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    132d:	0f b6 00             	movzbl (%rax),%eax
    1330:	0f b6 d0             	movzbl %al,%edx
    1333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1337:	0f b6 00             	movzbl (%rax),%eax
    133a:	0f b6 c0             	movzbl %al,%eax
    133d:	29 c2                	sub    %eax,%edx
    133f:	89 d0                	mov    %edx,%eax
}
    1341:	c9                   	leaveq 
    1342:	c3                   	retq   

0000000000001343 <strlen>:

uint
strlen(char *s)
{
    1343:	f3 0f 1e fa          	endbr64 
    1347:	55                   	push   %rbp
    1348:	48 89 e5             	mov    %rsp,%rbp
    134b:	48 83 ec 18          	sub    $0x18,%rsp
    134f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1353:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    135a:	eb 04                	jmp    1360 <strlen+0x1d>
    135c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1360:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1363:	48 63 d0             	movslq %eax,%rdx
    1366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    136a:	48 01 d0             	add    %rdx,%rax
    136d:	0f b6 00             	movzbl (%rax),%eax
    1370:	84 c0                	test   %al,%al
    1372:	75 e8                	jne    135c <strlen+0x19>
    ;
  return n;
    1374:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1377:	c9                   	leaveq 
    1378:	c3                   	retq   

0000000000001379 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1379:	f3 0f 1e fa          	endbr64 
    137d:	55                   	push   %rbp
    137e:	48 89 e5             	mov    %rsp,%rbp
    1381:	48 83 ec 10          	sub    $0x10,%rsp
    1385:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1389:	89 75 f4             	mov    %esi,-0xc(%rbp)
    138c:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    138f:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1392:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    1395:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1399:	89 ce                	mov    %ecx,%esi
    139b:	48 89 c7             	mov    %rax,%rdi
    139e:	48 b8 6b 12 00 00 00 	movabs $0x126b,%rax
    13a5:	00 00 00 
    13a8:	ff d0                	callq  *%rax
  return dst;
    13aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    13ae:	c9                   	leaveq 
    13af:	c3                   	retq   

00000000000013b0 <strchr>:

char*
strchr(const char *s, char c)
{
    13b0:	f3 0f 1e fa          	endbr64 
    13b4:	55                   	push   %rbp
    13b5:	48 89 e5             	mov    %rsp,%rbp
    13b8:	48 83 ec 10          	sub    $0x10,%rsp
    13bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    13c0:	89 f0                	mov    %esi,%eax
    13c2:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    13c5:	eb 17                	jmp    13de <strchr+0x2e>
    if(*s == c)
    13c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13cb:	0f b6 00             	movzbl (%rax),%eax
    13ce:	38 45 f4             	cmp    %al,-0xc(%rbp)
    13d1:	75 06                	jne    13d9 <strchr+0x29>
      return (char*)s;
    13d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d7:	eb 15                	jmp    13ee <strchr+0x3e>
  for(; *s; s++)
    13d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    13de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13e2:	0f b6 00             	movzbl (%rax),%eax
    13e5:	84 c0                	test   %al,%al
    13e7:	75 de                	jne    13c7 <strchr+0x17>
  return 0;
    13e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13ee:	c9                   	leaveq 
    13ef:	c3                   	retq   

00000000000013f0 <gets>:

char*
gets(char *buf, int max)
{
    13f0:	f3 0f 1e fa          	endbr64 
    13f4:	55                   	push   %rbp
    13f5:	48 89 e5             	mov    %rsp,%rbp
    13f8:	48 83 ec 20          	sub    $0x20,%rsp
    13fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1400:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1403:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    140a:	eb 4f                	jmp    145b <gets+0x6b>
    cc = read(0, &c, 1);
    140c:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1410:	ba 01 00 00 00       	mov    $0x1,%edx
    1415:	48 89 c6             	mov    %rax,%rsi
    1418:	bf 00 00 00 00       	mov    $0x0,%edi
    141d:	48 b8 d5 15 00 00 00 	movabs $0x15d5,%rax
    1424:	00 00 00 
    1427:	ff d0                	callq  *%rax
    1429:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    142c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1430:	7e 36                	jle    1468 <gets+0x78>
      break;
    buf[i++] = c;
    1432:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1435:	8d 50 01             	lea    0x1(%rax),%edx
    1438:	89 55 fc             	mov    %edx,-0x4(%rbp)
    143b:	48 63 d0             	movslq %eax,%rdx
    143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1442:	48 01 c2             	add    %rax,%rdx
    1445:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1449:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    144b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    144f:	3c 0a                	cmp    $0xa,%al
    1451:	74 16                	je     1469 <gets+0x79>
    1453:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1457:	3c 0d                	cmp    $0xd,%al
    1459:	74 0e                	je     1469 <gets+0x79>
  for(i=0; i+1 < max; ){
    145b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    145e:	83 c0 01             	add    $0x1,%eax
    1461:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1464:	7f a6                	jg     140c <gets+0x1c>
    1466:	eb 01                	jmp    1469 <gets+0x79>
      break;
    1468:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1469:	8b 45 fc             	mov    -0x4(%rbp),%eax
    146c:	48 63 d0             	movslq %eax,%rdx
    146f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1473:	48 01 d0             	add    %rdx,%rax
    1476:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    147d:	c9                   	leaveq 
    147e:	c3                   	retq   

000000000000147f <stat>:

int
stat(char *n, struct stat *st)
{
    147f:	f3 0f 1e fa          	endbr64 
    1483:	55                   	push   %rbp
    1484:	48 89 e5             	mov    %rsp,%rbp
    1487:	48 83 ec 20          	sub    $0x20,%rsp
    148b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    148f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1497:	be 00 00 00 00       	mov    $0x0,%esi
    149c:	48 89 c7             	mov    %rax,%rdi
    149f:	48 b8 16 16 00 00 00 	movabs $0x1616,%rax
    14a6:	00 00 00 
    14a9:	ff d0                	callq  *%rax
    14ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    14ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    14b2:	79 07                	jns    14bb <stat+0x3c>
    return -1;
    14b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14b9:	eb 2f                	jmp    14ea <stat+0x6b>
  r = fstat(fd, st);
    14bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    14bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14c2:	48 89 d6             	mov    %rdx,%rsi
    14c5:	89 c7                	mov    %eax,%edi
    14c7:	48 b8 3d 16 00 00 00 	movabs $0x163d,%rax
    14ce:	00 00 00 
    14d1:	ff d0                	callq  *%rax
    14d3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    14d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14d9:	89 c7                	mov    %eax,%edi
    14db:	48 b8 ef 15 00 00 00 	movabs $0x15ef,%rax
    14e2:	00 00 00 
    14e5:	ff d0                	callq  *%rax
  return r;
    14e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    14ea:	c9                   	leaveq 
    14eb:	c3                   	retq   

00000000000014ec <atoi>:

int
atoi(const char *s)
{
    14ec:	f3 0f 1e fa          	endbr64 
    14f0:	55                   	push   %rbp
    14f1:	48 89 e5             	mov    %rsp,%rbp
    14f4:	48 83 ec 18          	sub    $0x18,%rsp
    14f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    14fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1503:	eb 28                	jmp    152d <atoi+0x41>
    n = n*10 + *s++ - '0';
    1505:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1508:	89 d0                	mov    %edx,%eax
    150a:	c1 e0 02             	shl    $0x2,%eax
    150d:	01 d0                	add    %edx,%eax
    150f:	01 c0                	add    %eax,%eax
    1511:	89 c1                	mov    %eax,%ecx
    1513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1517:	48 8d 50 01          	lea    0x1(%rax),%rdx
    151b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    151f:	0f b6 00             	movzbl (%rax),%eax
    1522:	0f be c0             	movsbl %al,%eax
    1525:	01 c8                	add    %ecx,%eax
    1527:	83 e8 30             	sub    $0x30,%eax
    152a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    152d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1531:	0f b6 00             	movzbl (%rax),%eax
    1534:	3c 2f                	cmp    $0x2f,%al
    1536:	7e 0b                	jle    1543 <atoi+0x57>
    1538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    153c:	0f b6 00             	movzbl (%rax),%eax
    153f:	3c 39                	cmp    $0x39,%al
    1541:	7e c2                	jle    1505 <atoi+0x19>
  return n;
    1543:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1546:	c9                   	leaveq 
    1547:	c3                   	retq   

0000000000001548 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1548:	f3 0f 1e fa          	endbr64 
    154c:	55                   	push   %rbp
    154d:	48 89 e5             	mov    %rsp,%rbp
    1550:	48 83 ec 28          	sub    $0x28,%rsp
    1554:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1558:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    155c:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    155f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1567:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    156b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    156f:	eb 1d                	jmp    158e <memmove+0x46>
    *dst++ = *src++;
    1571:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1575:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1579:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    157d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1581:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1585:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1589:	0f b6 12             	movzbl (%rdx),%edx
    158c:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    158e:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1591:	8d 50 ff             	lea    -0x1(%rax),%edx
    1594:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1597:	85 c0                	test   %eax,%eax
    1599:	7f d6                	jg     1571 <memmove+0x29>
  return vdst;
    159b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    159f:	c9                   	leaveq 
    15a0:	c3                   	retq   

00000000000015a1 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    15a1:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    15a8:	49 89 ca             	mov    %rcx,%r10
    15ab:	0f 05                	syscall 
    15ad:	c3                   	retq   

00000000000015ae <exit>:
SYSCALL(exit)
    15ae:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    15b5:	49 89 ca             	mov    %rcx,%r10
    15b8:	0f 05                	syscall 
    15ba:	c3                   	retq   

00000000000015bb <wait>:
SYSCALL(wait)
    15bb:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    15c2:	49 89 ca             	mov    %rcx,%r10
    15c5:	0f 05                	syscall 
    15c7:	c3                   	retq   

00000000000015c8 <pipe>:
SYSCALL(pipe)
    15c8:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    15cf:	49 89 ca             	mov    %rcx,%r10
    15d2:	0f 05                	syscall 
    15d4:	c3                   	retq   

00000000000015d5 <read>:
SYSCALL(read)
    15d5:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    15dc:	49 89 ca             	mov    %rcx,%r10
    15df:	0f 05                	syscall 
    15e1:	c3                   	retq   

00000000000015e2 <write>:
SYSCALL(write)
    15e2:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    15e9:	49 89 ca             	mov    %rcx,%r10
    15ec:	0f 05                	syscall 
    15ee:	c3                   	retq   

00000000000015ef <close>:
SYSCALL(close)
    15ef:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    15f6:	49 89 ca             	mov    %rcx,%r10
    15f9:	0f 05                	syscall 
    15fb:	c3                   	retq   

00000000000015fc <kill>:
SYSCALL(kill)
    15fc:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1603:	49 89 ca             	mov    %rcx,%r10
    1606:	0f 05                	syscall 
    1608:	c3                   	retq   

0000000000001609 <exec>:
SYSCALL(exec)
    1609:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1610:	49 89 ca             	mov    %rcx,%r10
    1613:	0f 05                	syscall 
    1615:	c3                   	retq   

0000000000001616 <open>:
SYSCALL(open)
    1616:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    161d:	49 89 ca             	mov    %rcx,%r10
    1620:	0f 05                	syscall 
    1622:	c3                   	retq   

0000000000001623 <mknod>:
SYSCALL(mknod)
    1623:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    162a:	49 89 ca             	mov    %rcx,%r10
    162d:	0f 05                	syscall 
    162f:	c3                   	retq   

0000000000001630 <unlink>:
SYSCALL(unlink)
    1630:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1637:	49 89 ca             	mov    %rcx,%r10
    163a:	0f 05                	syscall 
    163c:	c3                   	retq   

000000000000163d <fstat>:
SYSCALL(fstat)
    163d:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1644:	49 89 ca             	mov    %rcx,%r10
    1647:	0f 05                	syscall 
    1649:	c3                   	retq   

000000000000164a <link>:
SYSCALL(link)
    164a:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1651:	49 89 ca             	mov    %rcx,%r10
    1654:	0f 05                	syscall 
    1656:	c3                   	retq   

0000000000001657 <mkdir>:
SYSCALL(mkdir)
    1657:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    165e:	49 89 ca             	mov    %rcx,%r10
    1661:	0f 05                	syscall 
    1663:	c3                   	retq   

0000000000001664 <chdir>:
SYSCALL(chdir)
    1664:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    166b:	49 89 ca             	mov    %rcx,%r10
    166e:	0f 05                	syscall 
    1670:	c3                   	retq   

0000000000001671 <dup>:
SYSCALL(dup)
    1671:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1678:	49 89 ca             	mov    %rcx,%r10
    167b:	0f 05                	syscall 
    167d:	c3                   	retq   

000000000000167e <getpid>:
SYSCALL(getpid)
    167e:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1685:	49 89 ca             	mov    %rcx,%r10
    1688:	0f 05                	syscall 
    168a:	c3                   	retq   

000000000000168b <sbrk>:
SYSCALL(sbrk)
    168b:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1692:	49 89 ca             	mov    %rcx,%r10
    1695:	0f 05                	syscall 
    1697:	c3                   	retq   

0000000000001698 <sleep>:
SYSCALL(sleep)
    1698:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    169f:	49 89 ca             	mov    %rcx,%r10
    16a2:	0f 05                	syscall 
    16a4:	c3                   	retq   

00000000000016a5 <uptime>:
SYSCALL(uptime)
    16a5:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    16ac:	49 89 ca             	mov    %rcx,%r10
    16af:	0f 05                	syscall 
    16b1:	c3                   	retq   

00000000000016b2 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    16b2:	f3 0f 1e fa          	endbr64 
    16b6:	55                   	push   %rbp
    16b7:	48 89 e5             	mov    %rsp,%rbp
    16ba:	48 83 ec 10          	sub    $0x10,%rsp
    16be:	89 7d fc             	mov    %edi,-0x4(%rbp)
    16c1:	89 f0                	mov    %esi,%eax
    16c3:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    16c6:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    16ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16cd:	ba 01 00 00 00       	mov    $0x1,%edx
    16d2:	48 89 ce             	mov    %rcx,%rsi
    16d5:	89 c7                	mov    %eax,%edi
    16d7:	48 b8 e2 15 00 00 00 	movabs $0x15e2,%rax
    16de:	00 00 00 
    16e1:	ff d0                	callq  *%rax
}
    16e3:	90                   	nop
    16e4:	c9                   	leaveq 
    16e5:	c3                   	retq   

00000000000016e6 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    16e6:	f3 0f 1e fa          	endbr64 
    16ea:	55                   	push   %rbp
    16eb:	48 89 e5             	mov    %rsp,%rbp
    16ee:	48 83 ec 20          	sub    $0x20,%rsp
    16f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    16f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1700:	eb 35                	jmp    1737 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1702:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1706:	48 c1 e8 3c          	shr    $0x3c,%rax
    170a:	48 ba 00 28 00 00 00 	movabs $0x2800,%rdx
    1711:	00 00 00 
    1714:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1718:	0f be d0             	movsbl %al,%edx
    171b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    171e:	89 d6                	mov    %edx,%esi
    1720:	89 c7                	mov    %eax,%edi
    1722:	48 b8 b2 16 00 00 00 	movabs $0x16b2,%rax
    1729:	00 00 00 
    172c:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    172e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1732:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1737:	8b 45 fc             	mov    -0x4(%rbp),%eax
    173a:	83 f8 0f             	cmp    $0xf,%eax
    173d:	76 c3                	jbe    1702 <print_x64+0x1c>
}
    173f:	90                   	nop
    1740:	90                   	nop
    1741:	c9                   	leaveq 
    1742:	c3                   	retq   

0000000000001743 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1743:	f3 0f 1e fa          	endbr64 
    1747:	55                   	push   %rbp
    1748:	48 89 e5             	mov    %rsp,%rbp
    174b:	48 83 ec 20          	sub    $0x20,%rsp
    174f:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1752:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1755:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    175c:	eb 36                	jmp    1794 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    175e:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1761:	c1 e8 1c             	shr    $0x1c,%eax
    1764:	89 c2                	mov    %eax,%edx
    1766:	48 b8 00 28 00 00 00 	movabs $0x2800,%rax
    176d:	00 00 00 
    1770:	89 d2                	mov    %edx,%edx
    1772:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1776:	0f be d0             	movsbl %al,%edx
    1779:	8b 45 ec             	mov    -0x14(%rbp),%eax
    177c:	89 d6                	mov    %edx,%esi
    177e:	89 c7                	mov    %eax,%edi
    1780:	48 b8 b2 16 00 00 00 	movabs $0x16b2,%rax
    1787:	00 00 00 
    178a:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    178c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1790:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1794:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1797:	83 f8 07             	cmp    $0x7,%eax
    179a:	76 c2                	jbe    175e <print_x32+0x1b>
}
    179c:	90                   	nop
    179d:	90                   	nop
    179e:	c9                   	leaveq 
    179f:	c3                   	retq   

00000000000017a0 <print_d>:

  static void
print_d(int fd, int v)
{
    17a0:	f3 0f 1e fa          	endbr64 
    17a4:	55                   	push   %rbp
    17a5:	48 89 e5             	mov    %rsp,%rbp
    17a8:	48 83 ec 30          	sub    $0x30,%rsp
    17ac:	89 7d dc             	mov    %edi,-0x24(%rbp)
    17af:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    17b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
    17b5:	48 98                	cltq   
    17b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    17bb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17bf:	79 04                	jns    17c5 <print_d+0x25>
    x = -x;
    17c1:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    17c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    17cc:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    17d0:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    17d7:	66 66 66 
    17da:	48 89 c8             	mov    %rcx,%rax
    17dd:	48 f7 ea             	imul   %rdx
    17e0:	48 c1 fa 02          	sar    $0x2,%rdx
    17e4:	48 89 c8             	mov    %rcx,%rax
    17e7:	48 c1 f8 3f          	sar    $0x3f,%rax
    17eb:	48 29 c2             	sub    %rax,%rdx
    17ee:	48 89 d0             	mov    %rdx,%rax
    17f1:	48 c1 e0 02          	shl    $0x2,%rax
    17f5:	48 01 d0             	add    %rdx,%rax
    17f8:	48 01 c0             	add    %rax,%rax
    17fb:	48 29 c1             	sub    %rax,%rcx
    17fe:	48 89 ca             	mov    %rcx,%rdx
    1801:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1804:	8d 48 01             	lea    0x1(%rax),%ecx
    1807:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    180a:	48 b9 00 28 00 00 00 	movabs $0x2800,%rcx
    1811:	00 00 00 
    1814:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1818:	48 98                	cltq   
    181a:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    181e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1822:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1829:	66 66 66 
    182c:	48 89 c8             	mov    %rcx,%rax
    182f:	48 f7 ea             	imul   %rdx
    1832:	48 c1 fa 02          	sar    $0x2,%rdx
    1836:	48 89 c8             	mov    %rcx,%rax
    1839:	48 c1 f8 3f          	sar    $0x3f,%rax
    183d:	48 29 c2             	sub    %rax,%rdx
    1840:	48 89 d0             	mov    %rdx,%rax
    1843:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1847:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    184c:	0f 85 7a ff ff ff    	jne    17cc <print_d+0x2c>

  if (v < 0)
    1852:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1856:	79 32                	jns    188a <print_d+0xea>
    buf[i++] = '-';
    1858:	8b 45 f4             	mov    -0xc(%rbp),%eax
    185b:	8d 50 01             	lea    0x1(%rax),%edx
    185e:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1861:	48 98                	cltq   
    1863:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1868:	eb 20                	jmp    188a <print_d+0xea>
    putc(fd, buf[i]);
    186a:	8b 45 f4             	mov    -0xc(%rbp),%eax
    186d:	48 98                	cltq   
    186f:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1874:	0f be d0             	movsbl %al,%edx
    1877:	8b 45 dc             	mov    -0x24(%rbp),%eax
    187a:	89 d6                	mov    %edx,%esi
    187c:	89 c7                	mov    %eax,%edi
    187e:	48 b8 b2 16 00 00 00 	movabs $0x16b2,%rax
    1885:	00 00 00 
    1888:	ff d0                	callq  *%rax
  while (--i >= 0)
    188a:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    188e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1892:	79 d6                	jns    186a <print_d+0xca>
}
    1894:	90                   	nop
    1895:	90                   	nop
    1896:	c9                   	leaveq 
    1897:	c3                   	retq   

0000000000001898 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1898:	f3 0f 1e fa          	endbr64 
    189c:	55                   	push   %rbp
    189d:	48 89 e5             	mov    %rsp,%rbp
    18a0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    18a7:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    18ad:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    18b4:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    18bb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    18c2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    18c9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    18d0:	84 c0                	test   %al,%al
    18d2:	74 20                	je     18f4 <printf+0x5c>
    18d4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    18d8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    18dc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    18e0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    18e4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    18e8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    18ec:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    18f0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    18f4:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    18fb:	00 00 00 
    18fe:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1905:	00 00 00 
    1908:	48 8d 45 10          	lea    0x10(%rbp),%rax
    190c:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1913:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    191a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1921:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1928:	00 00 00 
    192b:	e9 41 03 00 00       	jmpq   1c71 <printf+0x3d9>
    if (c != '%') {
    1930:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1937:	74 24                	je     195d <printf+0xc5>
      putc(fd, c);
    1939:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    193f:	0f be d0             	movsbl %al,%edx
    1942:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1948:	89 d6                	mov    %edx,%esi
    194a:	89 c7                	mov    %eax,%edi
    194c:	48 b8 b2 16 00 00 00 	movabs $0x16b2,%rax
    1953:	00 00 00 
    1956:	ff d0                	callq  *%rax
      continue;
    1958:	e9 0d 03 00 00       	jmpq   1c6a <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    195d:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1964:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    196a:	48 63 d0             	movslq %eax,%rdx
    196d:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1974:	48 01 d0             	add    %rdx,%rax
    1977:	0f b6 00             	movzbl (%rax),%eax
    197a:	0f be c0             	movsbl %al,%eax
    197d:	25 ff 00 00 00       	and    $0xff,%eax
    1982:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1988:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    198f:	0f 84 0f 03 00 00    	je     1ca4 <printf+0x40c>
      break;
    switch(c) {
    1995:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    199c:	0f 84 74 02 00 00    	je     1c16 <printf+0x37e>
    19a2:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    19a9:	0f 8c 82 02 00 00    	jl     1c31 <printf+0x399>
    19af:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    19b6:	0f 8f 75 02 00 00    	jg     1c31 <printf+0x399>
    19bc:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    19c3:	0f 8c 68 02 00 00    	jl     1c31 <printf+0x399>
    19c9:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    19cf:	83 e8 63             	sub    $0x63,%eax
    19d2:	83 f8 15             	cmp    $0x15,%eax
    19d5:	0f 87 56 02 00 00    	ja     1c31 <printf+0x399>
    19db:	89 c0                	mov    %eax,%eax
    19dd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    19e4:	00 
    19e5:	48 b8 f8 23 00 00 00 	movabs $0x23f8,%rax
    19ec:	00 00 00 
    19ef:	48 01 d0             	add    %rdx,%rax
    19f2:	48 8b 00             	mov    (%rax),%rax
    19f5:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    19f8:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19fe:	83 f8 2f             	cmp    $0x2f,%eax
    1a01:	77 23                	ja     1a26 <printf+0x18e>
    1a03:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a0a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a10:	89 d2                	mov    %edx,%edx
    1a12:	48 01 d0             	add    %rdx,%rax
    1a15:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a1b:	83 c2 08             	add    $0x8,%edx
    1a1e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a24:	eb 12                	jmp    1a38 <printf+0x1a0>
    1a26:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a2d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a31:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a38:	8b 00                	mov    (%rax),%eax
    1a3a:	0f be d0             	movsbl %al,%edx
    1a3d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a43:	89 d6                	mov    %edx,%esi
    1a45:	89 c7                	mov    %eax,%edi
    1a47:	48 b8 b2 16 00 00 00 	movabs $0x16b2,%rax
    1a4e:	00 00 00 
    1a51:	ff d0                	callq  *%rax
      break;
    1a53:	e9 12 02 00 00       	jmpq   1c6a <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1a58:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a5e:	83 f8 2f             	cmp    $0x2f,%eax
    1a61:	77 23                	ja     1a86 <printf+0x1ee>
    1a63:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a6a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a70:	89 d2                	mov    %edx,%edx
    1a72:	48 01 d0             	add    %rdx,%rax
    1a75:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a7b:	83 c2 08             	add    $0x8,%edx
    1a7e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a84:	eb 12                	jmp    1a98 <printf+0x200>
    1a86:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a8d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a91:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a98:	8b 10                	mov    (%rax),%edx
    1a9a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aa0:	89 d6                	mov    %edx,%esi
    1aa2:	89 c7                	mov    %eax,%edi
    1aa4:	48 b8 a0 17 00 00 00 	movabs $0x17a0,%rax
    1aab:	00 00 00 
    1aae:	ff d0                	callq  *%rax
      break;
    1ab0:	e9 b5 01 00 00       	jmpq   1c6a <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1ab5:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1abb:	83 f8 2f             	cmp    $0x2f,%eax
    1abe:	77 23                	ja     1ae3 <printf+0x24b>
    1ac0:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ac7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1acd:	89 d2                	mov    %edx,%edx
    1acf:	48 01 d0             	add    %rdx,%rax
    1ad2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ad8:	83 c2 08             	add    $0x8,%edx
    1adb:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1ae1:	eb 12                	jmp    1af5 <printf+0x25d>
    1ae3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1aea:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1aee:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1af5:	8b 10                	mov    (%rax),%edx
    1af7:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1afd:	89 d6                	mov    %edx,%esi
    1aff:	89 c7                	mov    %eax,%edi
    1b01:	48 b8 43 17 00 00 00 	movabs $0x1743,%rax
    1b08:	00 00 00 
    1b0b:	ff d0                	callq  *%rax
      break;
    1b0d:	e9 58 01 00 00       	jmpq   1c6a <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1b12:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b18:	83 f8 2f             	cmp    $0x2f,%eax
    1b1b:	77 23                	ja     1b40 <printf+0x2a8>
    1b1d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b24:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b2a:	89 d2                	mov    %edx,%edx
    1b2c:	48 01 d0             	add    %rdx,%rax
    1b2f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b35:	83 c2 08             	add    $0x8,%edx
    1b38:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b3e:	eb 12                	jmp    1b52 <printf+0x2ba>
    1b40:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b47:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b4b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b52:	48 8b 10             	mov    (%rax),%rdx
    1b55:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b5b:	48 89 d6             	mov    %rdx,%rsi
    1b5e:	89 c7                	mov    %eax,%edi
    1b60:	48 b8 e6 16 00 00 00 	movabs $0x16e6,%rax
    1b67:	00 00 00 
    1b6a:	ff d0                	callq  *%rax
      break;
    1b6c:	e9 f9 00 00 00       	jmpq   1c6a <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1b71:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b77:	83 f8 2f             	cmp    $0x2f,%eax
    1b7a:	77 23                	ja     1b9f <printf+0x307>
    1b7c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b83:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b89:	89 d2                	mov    %edx,%edx
    1b8b:	48 01 d0             	add    %rdx,%rax
    1b8e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b94:	83 c2 08             	add    $0x8,%edx
    1b97:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b9d:	eb 12                	jmp    1bb1 <printf+0x319>
    1b9f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ba6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1baa:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1bb1:	48 8b 00             	mov    (%rax),%rax
    1bb4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1bbb:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1bc2:	00 
    1bc3:	75 41                	jne    1c06 <printf+0x36e>
        s = "(null)";
    1bc5:	48 b8 f0 23 00 00 00 	movabs $0x23f0,%rax
    1bcc:	00 00 00 
    1bcf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1bd6:	eb 2e                	jmp    1c06 <printf+0x36e>
        putc(fd, *(s++));
    1bd8:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1bdf:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1be3:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1bea:	0f b6 00             	movzbl (%rax),%eax
    1bed:	0f be d0             	movsbl %al,%edx
    1bf0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bf6:	89 d6                	mov    %edx,%esi
    1bf8:	89 c7                	mov    %eax,%edi
    1bfa:	48 b8 b2 16 00 00 00 	movabs $0x16b2,%rax
    1c01:	00 00 00 
    1c04:	ff d0                	callq  *%rax
      while (*s)
    1c06:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1c0d:	0f b6 00             	movzbl (%rax),%eax
    1c10:	84 c0                	test   %al,%al
    1c12:	75 c4                	jne    1bd8 <printf+0x340>
      break;
    1c14:	eb 54                	jmp    1c6a <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1c16:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c1c:	be 25 00 00 00       	mov    $0x25,%esi
    1c21:	89 c7                	mov    %eax,%edi
    1c23:	48 b8 b2 16 00 00 00 	movabs $0x16b2,%rax
    1c2a:	00 00 00 
    1c2d:	ff d0                	callq  *%rax
      break;
    1c2f:	eb 39                	jmp    1c6a <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1c31:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c37:	be 25 00 00 00       	mov    $0x25,%esi
    1c3c:	89 c7                	mov    %eax,%edi
    1c3e:	48 b8 b2 16 00 00 00 	movabs $0x16b2,%rax
    1c45:	00 00 00 
    1c48:	ff d0                	callq  *%rax
      putc(fd, c);
    1c4a:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1c50:	0f be d0             	movsbl %al,%edx
    1c53:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c59:	89 d6                	mov    %edx,%esi
    1c5b:	89 c7                	mov    %eax,%edi
    1c5d:	48 b8 b2 16 00 00 00 	movabs $0x16b2,%rax
    1c64:	00 00 00 
    1c67:	ff d0                	callq  *%rax
      break;
    1c69:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1c6a:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1c71:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1c77:	48 63 d0             	movslq %eax,%rdx
    1c7a:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1c81:	48 01 d0             	add    %rdx,%rax
    1c84:	0f b6 00             	movzbl (%rax),%eax
    1c87:	0f be c0             	movsbl %al,%eax
    1c8a:	25 ff 00 00 00       	and    $0xff,%eax
    1c8f:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1c95:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1c9c:	0f 85 8e fc ff ff    	jne    1930 <printf+0x98>
    }
  }
}
    1ca2:	eb 01                	jmp    1ca5 <printf+0x40d>
      break;
    1ca4:	90                   	nop
}
    1ca5:	90                   	nop
    1ca6:	c9                   	leaveq 
    1ca7:	c3                   	retq   

0000000000001ca8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ca8:	f3 0f 1e fa          	endbr64 
    1cac:	55                   	push   %rbp
    1cad:	48 89 e5             	mov    %rsp,%rbp
    1cb0:	48 83 ec 18          	sub    $0x18,%rsp
    1cb4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1cbc:	48 83 e8 10          	sub    $0x10,%rax
    1cc0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1cc4:	48 b8 30 2a 00 00 00 	movabs $0x2a30,%rax
    1ccb:	00 00 00 
    1cce:	48 8b 00             	mov    (%rax),%rax
    1cd1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1cd5:	eb 2f                	jmp    1d06 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1cd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cdb:	48 8b 00             	mov    (%rax),%rax
    1cde:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ce2:	72 17                	jb     1cfb <free+0x53>
    1ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1cec:	77 2f                	ja     1d1d <free+0x75>
    1cee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf2:	48 8b 00             	mov    (%rax),%rax
    1cf5:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cf9:	72 22                	jb     1d1d <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1cfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cff:	48 8b 00             	mov    (%rax),%rax
    1d02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1d06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d0a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1d0e:	76 c7                	jbe    1cd7 <free+0x2f>
    1d10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d14:	48 8b 00             	mov    (%rax),%rax
    1d17:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d1b:	73 ba                	jae    1cd7 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d21:	8b 40 08             	mov    0x8(%rax),%eax
    1d24:	89 c0                	mov    %eax,%eax
    1d26:	48 c1 e0 04          	shl    $0x4,%rax
    1d2a:	48 89 c2             	mov    %rax,%rdx
    1d2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d31:	48 01 c2             	add    %rax,%rdx
    1d34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d38:	48 8b 00             	mov    (%rax),%rax
    1d3b:	48 39 c2             	cmp    %rax,%rdx
    1d3e:	75 2d                	jne    1d6d <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d44:	8b 50 08             	mov    0x8(%rax),%edx
    1d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4b:	48 8b 00             	mov    (%rax),%rax
    1d4e:	8b 40 08             	mov    0x8(%rax),%eax
    1d51:	01 c2                	add    %eax,%edx
    1d53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d57:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1d5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d5e:	48 8b 00             	mov    (%rax),%rax
    1d61:	48 8b 10             	mov    (%rax),%rdx
    1d64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d68:	48 89 10             	mov    %rdx,(%rax)
    1d6b:	eb 0e                	jmp    1d7b <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d71:	48 8b 10             	mov    (%rax),%rdx
    1d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d78:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1d7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7f:	8b 40 08             	mov    0x8(%rax),%eax
    1d82:	89 c0                	mov    %eax,%eax
    1d84:	48 c1 e0 04          	shl    $0x4,%rax
    1d88:	48 89 c2             	mov    %rax,%rdx
    1d8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8f:	48 01 d0             	add    %rdx,%rax
    1d92:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1d96:	75 27                	jne    1dbf <free+0x117>
    p->s.size += bp->s.size;
    1d98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d9c:	8b 50 08             	mov    0x8(%rax),%edx
    1d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1da3:	8b 40 08             	mov    0x8(%rax),%eax
    1da6:	01 c2                	add    %eax,%edx
    1da8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dac:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1daf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1db3:	48 8b 10             	mov    (%rax),%rdx
    1db6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dba:	48 89 10             	mov    %rdx,(%rax)
    1dbd:	eb 0b                	jmp    1dca <free+0x122>
  } else
    p->s.ptr = bp;
    1dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1dc7:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1dca:	48 ba 30 2a 00 00 00 	movabs $0x2a30,%rdx
    1dd1:	00 00 00 
    1dd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd8:	48 89 02             	mov    %rax,(%rdx)
}
    1ddb:	90                   	nop
    1ddc:	c9                   	leaveq 
    1ddd:	c3                   	retq   

0000000000001dde <morecore>:

static Header*
morecore(uint nu)
{
    1dde:	f3 0f 1e fa          	endbr64 
    1de2:	55                   	push   %rbp
    1de3:	48 89 e5             	mov    %rsp,%rbp
    1de6:	48 83 ec 20          	sub    $0x20,%rsp
    1dea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1ded:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1df4:	77 07                	ja     1dfd <morecore+0x1f>
    nu = 4096;
    1df6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1dfd:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1e00:	48 c1 e0 04          	shl    $0x4,%rax
    1e04:	48 89 c7             	mov    %rax,%rdi
    1e07:	48 b8 8b 16 00 00 00 	movabs $0x168b,%rax
    1e0e:	00 00 00 
    1e11:	ff d0                	callq  *%rax
    1e13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1e17:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1e1c:	75 07                	jne    1e25 <morecore+0x47>
    return 0;
    1e1e:	b8 00 00 00 00       	mov    $0x0,%eax
    1e23:	eb 36                	jmp    1e5b <morecore+0x7d>
  hp = (Header*)p;
    1e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e29:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1e2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e31:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e34:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e3b:	48 83 c0 10          	add    $0x10,%rax
    1e3f:	48 89 c7             	mov    %rax,%rdi
    1e42:	48 b8 a8 1c 00 00 00 	movabs $0x1ca8,%rax
    1e49:	00 00 00 
    1e4c:	ff d0                	callq  *%rax
  return freep;
    1e4e:	48 b8 30 2a 00 00 00 	movabs $0x2a30,%rax
    1e55:	00 00 00 
    1e58:	48 8b 00             	mov    (%rax),%rax
}
    1e5b:	c9                   	leaveq 
    1e5c:	c3                   	retq   

0000000000001e5d <malloc>:

void*
malloc(uint nbytes)
{
    1e5d:	f3 0f 1e fa          	endbr64 
    1e61:	55                   	push   %rbp
    1e62:	48 89 e5             	mov    %rsp,%rbp
    1e65:	48 83 ec 30          	sub    $0x30,%rsp
    1e69:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1e6c:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1e6f:	48 83 c0 0f          	add    $0xf,%rax
    1e73:	48 c1 e8 04          	shr    $0x4,%rax
    1e77:	83 c0 01             	add    $0x1,%eax
    1e7a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1e7d:	48 b8 30 2a 00 00 00 	movabs $0x2a30,%rax
    1e84:	00 00 00 
    1e87:	48 8b 00             	mov    (%rax),%rax
    1e8a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e8e:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1e93:	75 4a                	jne    1edf <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1e95:	48 b8 20 2a 00 00 00 	movabs $0x2a20,%rax
    1e9c:	00 00 00 
    1e9f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1ea3:	48 ba 30 2a 00 00 00 	movabs $0x2a30,%rdx
    1eaa:	00 00 00 
    1ead:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1eb1:	48 89 02             	mov    %rax,(%rdx)
    1eb4:	48 b8 30 2a 00 00 00 	movabs $0x2a30,%rax
    1ebb:	00 00 00 
    1ebe:	48 8b 00             	mov    (%rax),%rax
    1ec1:	48 ba 20 2a 00 00 00 	movabs $0x2a20,%rdx
    1ec8:	00 00 00 
    1ecb:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1ece:	48 b8 20 2a 00 00 00 	movabs $0x2a20,%rax
    1ed5:	00 00 00 
    1ed8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1edf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ee3:	48 8b 00             	mov    (%rax),%rax
    1ee6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1eea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eee:	8b 40 08             	mov    0x8(%rax),%eax
    1ef1:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1ef4:	77 65                	ja     1f5b <malloc+0xfe>
      if(p->s.size == nunits)
    1ef6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1efa:	8b 40 08             	mov    0x8(%rax),%eax
    1efd:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1f00:	75 10                	jne    1f12 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1f02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f06:	48 8b 10             	mov    (%rax),%rdx
    1f09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f0d:	48 89 10             	mov    %rdx,(%rax)
    1f10:	eb 2e                	jmp    1f40 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f16:	8b 40 08             	mov    0x8(%rax),%eax
    1f19:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1f1c:	89 c2                	mov    %eax,%edx
    1f1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f22:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1f25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f29:	8b 40 08             	mov    0x8(%rax),%eax
    1f2c:	89 c0                	mov    %eax,%eax
    1f2e:	48 c1 e0 04          	shl    $0x4,%rax
    1f32:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1f36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f3a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1f3d:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1f40:	48 ba 30 2a 00 00 00 	movabs $0x2a30,%rdx
    1f47:	00 00 00 
    1f4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f4e:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1f51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f55:	48 83 c0 10          	add    $0x10,%rax
    1f59:	eb 4e                	jmp    1fa9 <malloc+0x14c>
    }
    if(p == freep)
    1f5b:	48 b8 30 2a 00 00 00 	movabs $0x2a30,%rax
    1f62:	00 00 00 
    1f65:	48 8b 00             	mov    (%rax),%rax
    1f68:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f6c:	75 23                	jne    1f91 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1f6e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1f71:	89 c7                	mov    %eax,%edi
    1f73:	48 b8 de 1d 00 00 00 	movabs $0x1dde,%rax
    1f7a:	00 00 00 
    1f7d:	ff d0                	callq  *%rax
    1f7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f83:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1f88:	75 07                	jne    1f91 <malloc+0x134>
        return 0;
    1f8a:	b8 00 00 00 00       	mov    $0x0,%eax
    1f8f:	eb 18                	jmp    1fa9 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1f91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f95:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1f99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f9d:	48 8b 00             	mov    (%rax),%rax
    1fa0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1fa4:	e9 41 ff ff ff       	jmpq   1eea <malloc+0x8d>
  }
}
    1fa9:	c9                   	leaveq 
    1faa:	c3                   	retq   

0000000000001fab <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    1fab:	f3 0f 1e fa          	endbr64 
    1faf:	55                   	push   %rbp
    1fb0:	48 89 e5             	mov    %rsp,%rbp
    1fb3:	48 83 ec 30          	sub    $0x30,%rsp
    1fb7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    1fbb:	bf 18 00 00 00       	mov    $0x18,%edi
    1fc0:	48 b8 5d 1e 00 00 00 	movabs $0x1e5d,%rax
    1fc7:	00 00 00 
    1fca:	ff d0                	callq  *%rax
    1fcc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    1fd0:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1fd5:	75 0a                	jne    1fe1 <co_new+0x36>
    return 0;
    1fd7:	b8 00 00 00 00       	mov    $0x0,%eax
    1fdc:	e9 e1 00 00 00       	jmpq   20c2 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    1fe1:	bf 00 20 00 00       	mov    $0x2000,%edi
    1fe6:	48 b8 5d 1e 00 00 00 	movabs $0x1e5d,%rax
    1fed:	00 00 00 
    1ff0:	ff d0                	callq  *%rax
    1ff2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1ff6:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    1ffa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ffe:	48 8b 40 10          	mov    0x10(%rax),%rax
    2002:	48 85 c0             	test   %rax,%rax
    2005:	75 1d                	jne    2024 <co_new+0x79>
    free(co1);
    2007:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    200b:	48 89 c7             	mov    %rax,%rdi
    200e:	48 b8 a8 1c 00 00 00 	movabs $0x1ca8,%rax
    2015:	00 00 00 
    2018:	ff d0                	callq  *%rax
    return 0;
    201a:	b8 00 00 00 00       	mov    $0x0,%eax
    201f:	e9 9e 00 00 00       	jmpq   20c2 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    2024:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2028:	48 8b 40 10          	mov    0x10(%rax),%rax
    202c:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    2032:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    2036:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    203a:	48 8d 50 30          	lea    0x30(%rax),%rdx
    203e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    2042:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    2045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2049:	48 83 c0 38          	add    $0x38,%rax
    204d:	48 ba 34 22 00 00 00 	movabs $0x2234,%rdx
    2054:	00 00 00 
    2057:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    205a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    205e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    2062:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    2065:	48 b8 48 2a 00 00 00 	movabs $0x2a48,%rax
    206c:	00 00 00 
    206f:	48 8b 00             	mov    (%rax),%rax
    2072:	48 85 c0             	test   %rax,%rax
    2075:	75 13                	jne    208a <co_new+0xdf>
  {
  	co_list = co1;
    2077:	48 ba 48 2a 00 00 00 	movabs $0x2a48,%rdx
    207e:	00 00 00 
    2081:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2085:	48 89 02             	mov    %rax,(%rdx)
    2088:	eb 34                	jmp    20be <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    208a:	48 b8 48 2a 00 00 00 	movabs $0x2a48,%rax
    2091:	00 00 00 
    2094:	48 8b 00             	mov    (%rax),%rax
    2097:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    209b:	eb 0c                	jmp    20a9 <co_new+0xfe>
	{
		head = head->next;
    209d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20a1:	48 8b 40 08          	mov    0x8(%rax),%rax
    20a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    20a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    20ad:	48 8b 40 08          	mov    0x8(%rax),%rax
    20b1:	48 85 c0             	test   %rax,%rax
    20b4:	75 e7                	jne    209d <co_new+0xf2>
	}
	head = co1;
    20b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    20be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    20c2:	c9                   	leaveq 
    20c3:	c3                   	retq   

00000000000020c4 <co_run>:

  int
co_run(void)
{
    20c4:	f3 0f 1e fa          	endbr64 
    20c8:	55                   	push   %rbp
    20c9:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    20cc:	48 b8 48 2a 00 00 00 	movabs $0x2a48,%rax
    20d3:	00 00 00 
    20d6:	48 8b 00             	mov    (%rax),%rax
    20d9:	48 85 c0             	test   %rax,%rax
    20dc:	74 4a                	je     2128 <co_run+0x64>
	{
		co_current = co_list;
    20de:	48 b8 48 2a 00 00 00 	movabs $0x2a48,%rax
    20e5:	00 00 00 
    20e8:	48 8b 00             	mov    (%rax),%rax
    20eb:	48 ba 40 2a 00 00 00 	movabs $0x2a40,%rdx
    20f2:	00 00 00 
    20f5:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    20f8:	48 b8 40 2a 00 00 00 	movabs $0x2a40,%rax
    20ff:	00 00 00 
    2102:	48 8b 00             	mov    (%rax),%rax
    2105:	48 8b 00             	mov    (%rax),%rax
    2108:	48 89 c6             	mov    %rax,%rsi
    210b:	48 bf 38 2a 00 00 00 	movabs $0x2a38,%rdi
    2112:	00 00 00 
    2115:	48 b8 96 23 00 00 00 	movabs $0x2396,%rax
    211c:	00 00 00 
    211f:	ff d0                	callq  *%rax
		return 1;
    2121:	b8 01 00 00 00       	mov    $0x1,%eax
    2126:	eb 05                	jmp    212d <co_run+0x69>
	}
	return 0;
    2128:	b8 00 00 00 00       	mov    $0x0,%eax
}
    212d:	5d                   	pop    %rbp
    212e:	c3                   	retq   

000000000000212f <co_run_all>:

  int
co_run_all(void)
{
    212f:	f3 0f 1e fa          	endbr64 
    2133:	55                   	push   %rbp
    2134:	48 89 e5             	mov    %rsp,%rbp
    2137:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    213b:	48 b8 48 2a 00 00 00 	movabs $0x2a48,%rax
    2142:	00 00 00 
    2145:	48 8b 00             	mov    (%rax),%rax
    2148:	48 85 c0             	test   %rax,%rax
    214b:	75 07                	jne    2154 <co_run_all+0x25>
		return 0;
    214d:	b8 00 00 00 00       	mov    $0x0,%eax
    2152:	eb 37                	jmp    218b <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    2154:	48 b8 48 2a 00 00 00 	movabs $0x2a48,%rax
    215b:	00 00 00 
    215e:	48 8b 00             	mov    (%rax),%rax
    2161:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    2165:	eb 18                	jmp    217f <co_run_all+0x50>
			co_run();
    2167:	48 b8 c4 20 00 00 00 	movabs $0x20c4,%rax
    216e:	00 00 00 
    2171:	ff d0                	callq  *%rax
			tmp = tmp->next;
    2173:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2177:	48 8b 40 08          	mov    0x8(%rax),%rax
    217b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    217f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2184:	75 e1                	jne    2167 <co_run_all+0x38>
		}
		return 1;
    2186:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    218b:	c9                   	leaveq 
    218c:	c3                   	retq   

000000000000218d <co_yield>:

  void
co_yield()
{
    218d:	f3 0f 1e fa          	endbr64 
    2191:	55                   	push   %rbp
    2192:	48 89 e5             	mov    %rsp,%rbp
    2195:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    2199:	48 b8 40 2a 00 00 00 	movabs $0x2a40,%rax
    21a0:	00 00 00 
    21a3:	48 8b 00             	mov    (%rax),%rax
    21a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    21aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21ae:	48 8b 40 08          	mov    0x8(%rax),%rax
    21b2:	48 85 c0             	test   %rax,%rax
    21b5:	74 46                	je     21fd <co_yield+0x70>
  {
  	co_current = co_current->next;
    21b7:	48 b8 40 2a 00 00 00 	movabs $0x2a40,%rax
    21be:	00 00 00 
    21c1:	48 8b 00             	mov    (%rax),%rax
    21c4:	48 8b 40 08          	mov    0x8(%rax),%rax
    21c8:	48 ba 40 2a 00 00 00 	movabs $0x2a40,%rdx
    21cf:	00 00 00 
    21d2:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    21d5:	48 b8 40 2a 00 00 00 	movabs $0x2a40,%rax
    21dc:	00 00 00 
    21df:	48 8b 00             	mov    (%rax),%rax
    21e2:	48 8b 10             	mov    (%rax),%rdx
    21e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21e9:	48 89 d6             	mov    %rdx,%rsi
    21ec:	48 89 c7             	mov    %rax,%rdi
    21ef:	48 b8 96 23 00 00 00 	movabs $0x2396,%rax
    21f6:	00 00 00 
    21f9:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    21fb:	eb 34                	jmp    2231 <co_yield+0xa4>
	co_current = 0;
    21fd:	48 b8 40 2a 00 00 00 	movabs $0x2a40,%rax
    2204:	00 00 00 
    2207:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    220e:	48 b8 38 2a 00 00 00 	movabs $0x2a38,%rax
    2215:	00 00 00 
    2218:	48 8b 10             	mov    (%rax),%rdx
    221b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    221f:	48 89 d6             	mov    %rdx,%rsi
    2222:	48 89 c7             	mov    %rax,%rdi
    2225:	48 b8 96 23 00 00 00 	movabs $0x2396,%rax
    222c:	00 00 00 
    222f:	ff d0                	callq  *%rax
}
    2231:	90                   	nop
    2232:	c9                   	leaveq 
    2233:	c3                   	retq   

0000000000002234 <co_exit>:

  void
co_exit(void)
{
    2234:	f3 0f 1e fa          	endbr64 
    2238:	55                   	push   %rbp
    2239:	48 89 e5             	mov    %rsp,%rbp
    223c:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    2240:	48 b8 40 2a 00 00 00 	movabs $0x2a40,%rax
    2247:	00 00 00 
    224a:	48 8b 00             	mov    (%rax),%rax
    224d:	48 85 c0             	test   %rax,%rax
    2250:	0f 84 ec 00 00 00    	je     2342 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    2256:	48 b8 48 2a 00 00 00 	movabs $0x2a48,%rax
    225d:	00 00 00 
    2260:	48 8b 00             	mov    (%rax),%rax
    2263:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    2267:	e9 c9 00 00 00       	jmpq   2335 <co_exit+0x101>
		if(tmp == co_current)
    226c:	48 b8 40 2a 00 00 00 	movabs $0x2a40,%rax
    2273:	00 00 00 
    2276:	48 8b 00             	mov    (%rax),%rax
    2279:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    227d:	0f 85 9e 00 00 00    	jne    2321 <co_exit+0xed>
		{
			if(tmp->next)
    2283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2287:	48 8b 40 08          	mov    0x8(%rax),%rax
    228b:	48 85 c0             	test   %rax,%rax
    228e:	74 54                	je     22e4 <co_exit+0xb0>
			{
				if(prev)
    2290:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    2295:	74 10                	je     22a7 <co_exit+0x73>
				{
					prev->next = tmp->next;
    2297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    229b:	48 8b 50 08          	mov    0x8(%rax),%rdx
    229f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    22a3:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    22a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22ab:	48 8b 40 08          	mov    0x8(%rax),%rax
    22af:	48 ba 48 2a 00 00 00 	movabs $0x2a48,%rdx
    22b6:	00 00 00 
    22b9:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    22bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22c0:	48 8b 00             	mov    (%rax),%rax
    22c3:	48 ba 40 2a 00 00 00 	movabs $0x2a40,%rdx
    22ca:	00 00 00 
    22cd:	48 8b 12             	mov    (%rdx),%rdx
    22d0:	48 89 c6             	mov    %rax,%rsi
    22d3:	48 89 d7             	mov    %rdx,%rdi
    22d6:	48 b8 96 23 00 00 00 	movabs $0x2396,%rax
    22dd:	00 00 00 
    22e0:	ff d0                	callq  *%rax
    22e2:	eb 3d                	jmp    2321 <co_exit+0xed>
			}else{
				co_list = 0;
    22e4:	48 b8 48 2a 00 00 00 	movabs $0x2a48,%rax
    22eb:	00 00 00 
    22ee:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    22f5:	48 b8 38 2a 00 00 00 	movabs $0x2a38,%rax
    22fc:	00 00 00 
    22ff:	48 8b 00             	mov    (%rax),%rax
    2302:	48 ba 40 2a 00 00 00 	movabs $0x2a40,%rdx
    2309:	00 00 00 
    230c:	48 8b 12             	mov    (%rdx),%rdx
    230f:	48 89 c6             	mov    %rax,%rsi
    2312:	48 89 d7             	mov    %rdx,%rdi
    2315:	48 b8 96 23 00 00 00 	movabs $0x2396,%rax
    231c:	00 00 00 
    231f:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    2321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2325:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    2329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    232d:	48 8b 40 08          	mov    0x8(%rax),%rax
    2331:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    2335:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    233a:	0f 85 2c ff ff ff    	jne    226c <co_exit+0x38>
    2340:	eb 01                	jmp    2343 <co_exit+0x10f>
		return;
    2342:	90                   	nop
	}
}
    2343:	c9                   	leaveq 
    2344:	c3                   	retq   

0000000000002345 <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    2345:	f3 0f 1e fa          	endbr64 
    2349:	55                   	push   %rbp
    234a:	48 89 e5             	mov    %rsp,%rbp
    234d:	48 83 ec 10          	sub    $0x10,%rsp
    2351:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    2355:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    235a:	74 37                	je     2393 <co_destroy+0x4e>
    if (co->stack)
    235c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2360:	48 8b 40 10          	mov    0x10(%rax),%rax
    2364:	48 85 c0             	test   %rax,%rax
    2367:	74 17                	je     2380 <co_destroy+0x3b>
      free(co->stack);
    2369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    236d:	48 8b 40 10          	mov    0x10(%rax),%rax
    2371:	48 89 c7             	mov    %rax,%rdi
    2374:	48 b8 a8 1c 00 00 00 	movabs $0x1ca8,%rax
    237b:	00 00 00 
    237e:	ff d0                	callq  *%rax
    free(co);
    2380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2384:	48 89 c7             	mov    %rax,%rdi
    2387:	48 b8 a8 1c 00 00 00 	movabs $0x1ca8,%rax
    238e:	00 00 00 
    2391:	ff d0                	callq  *%rax
  }
}
    2393:	90                   	nop
    2394:	c9                   	leaveq 
    2395:	c3                   	retq   

0000000000002396 <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    2396:	55                   	push   %rbp
  pushq   %rbx
    2397:	53                   	push   %rbx
  pushq   %r12
    2398:	41 54                	push   %r12
  pushq   %r13
    239a:	41 55                	push   %r13
  pushq   %r14
    239c:	41 56                	push   %r14
  pushq   %r15
    239e:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    23a0:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    23a3:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    23a6:	41 5f                	pop    %r15
  popq    %r14
    23a8:	41 5e                	pop    %r14
  popq    %r13
    23aa:	41 5d                	pop    %r13
  popq    %r12
    23ac:	41 5c                	pop    %r12
  popq    %rbx
    23ae:	5b                   	pop    %rbx
  popq    %rbp
    23af:	5d                   	pop    %rbp

  retq #??
    23b0:	c3                   	retq   
