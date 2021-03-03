
_ls:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	53                   	push   %rbx
    1009:	48 83 ec 28          	sub    $0x28,%rsp
    100d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    1011:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1015:	48 89 c7             	mov    %rax,%rdi
    1018:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    101f:	00 00 00 
    1022:	ff d0                	callq  *%rax
    1024:	89 c2                	mov    %eax,%edx
    1026:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    102a:	48 01 d0             	add    %rdx,%rax
    102d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    1031:	eb 05                	jmp    1038 <fmtname+0x38>
    1033:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
    1038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    103c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
    1040:	72 0b                	jb     104d <fmtname+0x4d>
    1042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1046:	0f b6 00             	movzbl (%rax),%eax
    1049:	3c 2f                	cmp    $0x2f,%al
    104b:	75 e6                	jne    1033 <fmtname+0x33>
    ;
  p++;
    104d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    1052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1056:	48 89 c7             	mov    %rax,%rdi
    1059:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    1060:	00 00 00 
    1063:	ff d0                	callq  *%rax
    1065:	83 f8 0d             	cmp    $0xd,%eax
    1068:	76 09                	jbe    1073 <fmtname+0x73>
    return p;
    106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    106e:	e9 90 00 00 00       	jmpq   1103 <fmtname+0x103>
  memmove(buf, p, strlen(p));
    1073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1077:	48 89 c7             	mov    %rax,%rdi
    107a:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    1081:	00 00 00 
    1084:	ff d0                	callq  *%rax
    1086:	89 c2                	mov    %eax,%edx
    1088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    108c:	48 89 c6             	mov    %rax,%rsi
    108f:	48 bf a0 2a 00 00 00 	movabs $0x2aa0,%rdi
    1096:	00 00 00 
    1099:	48 b8 7f 17 00 00 00 	movabs $0x177f,%rax
    10a0:	00 00 00 
    10a3:	ff d0                	callq  *%rax
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    10a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10a9:	48 89 c7             	mov    %rax,%rdi
    10ac:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    10b3:	00 00 00 
    10b6:	ff d0                	callq  *%rax
    10b8:	ba 0e 00 00 00       	mov    $0xe,%edx
    10bd:	89 d3                	mov    %edx,%ebx
    10bf:	29 c3                	sub    %eax,%ebx
    10c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10c5:	48 89 c7             	mov    %rax,%rdi
    10c8:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    10cf:	00 00 00 
    10d2:	ff d0                	callq  *%rax
    10d4:	89 c2                	mov    %eax,%edx
    10d6:	48 b8 a0 2a 00 00 00 	movabs $0x2aa0,%rax
    10dd:	00 00 00 
    10e0:	48 01 d0             	add    %rdx,%rax
    10e3:	89 da                	mov    %ebx,%edx
    10e5:	be 20 00 00 00       	mov    $0x20,%esi
    10ea:	48 89 c7             	mov    %rax,%rdi
    10ed:	48 b8 b0 15 00 00 00 	movabs $0x15b0,%rax
    10f4:	00 00 00 
    10f7:	ff d0                	callq  *%rax
  return buf;
    10f9:	48 b8 a0 2a 00 00 00 	movabs $0x2aa0,%rax
    1100:	00 00 00 
}
    1103:	48 83 c4 28          	add    $0x28,%rsp
    1107:	5b                   	pop    %rbx
    1108:	5d                   	pop    %rbp
    1109:	c3                   	retq   

000000000000110a <ls>:

void
ls(char *path)
{
    110a:	f3 0f 1e fa          	endbr64 
    110e:	55                   	push   %rbp
    110f:	48 89 e5             	mov    %rsp,%rbp
    1112:	41 55                	push   %r13
    1114:	41 54                	push   %r12
    1116:	53                   	push   %rbx
    1117:	48 81 ec 58 02 00 00 	sub    $0x258,%rsp
    111e:	48 89 bd 98 fd ff ff 	mov    %rdi,-0x268(%rbp)
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    1125:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    112c:	be 00 00 00 00       	mov    $0x0,%esi
    1131:	48 89 c7             	mov    %rax,%rdi
    1134:	48 b8 4d 18 00 00 00 	movabs $0x184d,%rax
    113b:	00 00 00 
    113e:	ff d0                	callq  *%rax
    1140:	89 45 dc             	mov    %eax,-0x24(%rbp)
    1143:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    1147:	79 2f                	jns    1178 <ls+0x6e>
    printf(2, "ls: cannot open %s\n", path);
    1149:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    1150:	48 89 c2             	mov    %rax,%rdx
    1153:	48 be e8 25 00 00 00 	movabs $0x25e8,%rsi
    115a:	00 00 00 
    115d:	bf 02 00 00 00       	mov    $0x2,%edi
    1162:	b8 00 00 00 00       	mov    $0x0,%eax
    1167:	48 b9 cf 1a 00 00 00 	movabs $0x1acf,%rcx
    116e:	00 00 00 
    1171:	ff d1                	callq  *%rcx
    return;
    1173:	e9 9a 02 00 00       	jmpq   1412 <ls+0x308>
  }

  if(fstat(fd, &st) < 0){
    1178:	48 8d 95 a0 fd ff ff 	lea    -0x260(%rbp),%rdx
    117f:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1182:	48 89 d6             	mov    %rdx,%rsi
    1185:	89 c7                	mov    %eax,%edi
    1187:	48 b8 74 18 00 00 00 	movabs $0x1874,%rax
    118e:	00 00 00 
    1191:	ff d0                	callq  *%rax
    1193:	85 c0                	test   %eax,%eax
    1195:	79 40                	jns    11d7 <ls+0xcd>
    printf(2, "ls: cannot stat %s\n", path);
    1197:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    119e:	48 89 c2             	mov    %rax,%rdx
    11a1:	48 be fc 25 00 00 00 	movabs $0x25fc,%rsi
    11a8:	00 00 00 
    11ab:	bf 02 00 00 00       	mov    $0x2,%edi
    11b0:	b8 00 00 00 00       	mov    $0x0,%eax
    11b5:	48 b9 cf 1a 00 00 00 	movabs $0x1acf,%rcx
    11bc:	00 00 00 
    11bf:	ff d1                	callq  *%rcx
    close(fd);
    11c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
    11c4:	89 c7                	mov    %eax,%edi
    11c6:	48 b8 26 18 00 00 00 	movabs $0x1826,%rax
    11cd:	00 00 00 
    11d0:	ff d0                	callq  *%rax
    return;
    11d2:	e9 3b 02 00 00       	jmpq   1412 <ls+0x308>
  }

  switch(st.type){
    11d7:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    11de:	98                   	cwtl   
    11df:	83 f8 01             	cmp    $0x1,%eax
    11e2:	74 68                	je     124c <ls+0x142>
    11e4:	83 f8 02             	cmp    $0x2,%eax
    11e7:	0f 85 14 02 00 00    	jne    1401 <ls+0x2f7>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    11ed:	44 8b ad b0 fd ff ff 	mov    -0x250(%rbp),%r13d
    11f4:	44 8b a5 a8 fd ff ff 	mov    -0x258(%rbp),%r12d
    11fb:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    1202:	0f bf d8             	movswl %ax,%ebx
    1205:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    120c:	48 89 c7             	mov    %rax,%rdi
    120f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1216:	00 00 00 
    1219:	ff d0                	callq  *%rax
    121b:	45 89 e9             	mov    %r13d,%r9d
    121e:	45 89 e0             	mov    %r12d,%r8d
    1221:	89 d9                	mov    %ebx,%ecx
    1223:	48 89 c2             	mov    %rax,%rdx
    1226:	48 be 10 26 00 00 00 	movabs $0x2610,%rsi
    122d:	00 00 00 
    1230:	bf 01 00 00 00       	mov    $0x1,%edi
    1235:	b8 00 00 00 00       	mov    $0x0,%eax
    123a:	49 ba cf 1a 00 00 00 	movabs $0x1acf,%r10
    1241:	00 00 00 
    1244:	41 ff d2             	callq  *%r10
    break;
    1247:	e9 b5 01 00 00       	jmpq   1401 <ls+0x2f7>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    124c:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    1253:	48 89 c7             	mov    %rax,%rdi
    1256:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    125d:	00 00 00 
    1260:	ff d0                	callq  *%rax
    1262:	83 c0 10             	add    $0x10,%eax
    1265:	3d 00 02 00 00       	cmp    $0x200,%eax
    126a:	76 25                	jbe    1291 <ls+0x187>
      printf(1, "ls: path too long\n");
    126c:	48 be 1d 26 00 00 00 	movabs $0x261d,%rsi
    1273:	00 00 00 
    1276:	bf 01 00 00 00       	mov    $0x1,%edi
    127b:	b8 00 00 00 00       	mov    $0x0,%eax
    1280:	48 ba cf 1a 00 00 00 	movabs $0x1acf,%rdx
    1287:	00 00 00 
    128a:	ff d2                	callq  *%rdx
      break;
    128c:	e9 70 01 00 00       	jmpq   1401 <ls+0x2f7>
    }
    strcpy(buf, path);
    1291:	48 8b 95 98 fd ff ff 	mov    -0x268(%rbp),%rdx
    1298:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    129f:	48 89 d6             	mov    %rdx,%rsi
    12a2:	48 89 c7             	mov    %rax,%rdi
    12a5:	48 b8 dc 14 00 00 00 	movabs $0x14dc,%rax
    12ac:	00 00 00 
    12af:	ff d0                	callq  *%rax
    p = buf+strlen(buf);
    12b1:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    12b8:	48 89 c7             	mov    %rax,%rdi
    12bb:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    12c2:	00 00 00 
    12c5:	ff d0                	callq  *%rax
    12c7:	89 c2                	mov    %eax,%edx
    12c9:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    12d0:	48 01 d0             	add    %rdx,%rax
    12d3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    *p++ = '/';
    12d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    12db:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12df:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
    12e3:	c6 00 2f             	movb   $0x2f,(%rax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    12e6:	e9 ec 00 00 00       	jmpq   13d7 <ls+0x2cd>
      if(de.inum == 0)
    12eb:	0f b7 85 c0 fd ff ff 	movzwl -0x240(%rbp),%eax
    12f2:	66 85 c0             	test   %ax,%ax
    12f5:	75 05                	jne    12fc <ls+0x1f2>
        continue;
    12f7:	e9 db 00 00 00       	jmpq   13d7 <ls+0x2cd>
      memmove(p, de.name, DIRSIZ);
    12fc:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
    1303:	48 8d 48 02          	lea    0x2(%rax),%rcx
    1307:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    130b:	ba 0e 00 00 00       	mov    $0xe,%edx
    1310:	48 89 ce             	mov    %rcx,%rsi
    1313:	48 89 c7             	mov    %rax,%rdi
    1316:	48 b8 7f 17 00 00 00 	movabs $0x177f,%rax
    131d:	00 00 00 
    1320:	ff d0                	callq  *%rax
      p[DIRSIZ] = 0;
    1322:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1326:	48 83 c0 0e          	add    $0xe,%rax
    132a:	c6 00 00             	movb   $0x0,(%rax)
      if(stat(buf, &st) < 0){
    132d:	48 8d 95 a0 fd ff ff 	lea    -0x260(%rbp),%rdx
    1334:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    133b:	48 89 d6             	mov    %rdx,%rsi
    133e:	48 89 c7             	mov    %rax,%rdi
    1341:	48 b8 b6 16 00 00 00 	movabs $0x16b6,%rax
    1348:	00 00 00 
    134b:	ff d0                	callq  *%rax
    134d:	85 c0                	test   %eax,%eax
    134f:	79 2c                	jns    137d <ls+0x273>
        printf(1, "ls: cannot stat %s\n", buf);
    1351:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    1358:	48 89 c2             	mov    %rax,%rdx
    135b:	48 be fc 25 00 00 00 	movabs $0x25fc,%rsi
    1362:	00 00 00 
    1365:	bf 01 00 00 00       	mov    $0x1,%edi
    136a:	b8 00 00 00 00       	mov    $0x0,%eax
    136f:	48 b9 cf 1a 00 00 00 	movabs $0x1acf,%rcx
    1376:	00 00 00 
    1379:	ff d1                	callq  *%rcx
        continue;
    137b:	eb 5a                	jmp    13d7 <ls+0x2cd>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    137d:	44 8b ad b0 fd ff ff 	mov    -0x250(%rbp),%r13d
    1384:	44 8b a5 a8 fd ff ff 	mov    -0x258(%rbp),%r12d
    138b:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    1392:	0f bf d8             	movswl %ax,%ebx
    1395:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    139c:	48 89 c7             	mov    %rax,%rdi
    139f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    13a6:	00 00 00 
    13a9:	ff d0                	callq  *%rax
    13ab:	45 89 e9             	mov    %r13d,%r9d
    13ae:	45 89 e0             	mov    %r12d,%r8d
    13b1:	89 d9                	mov    %ebx,%ecx
    13b3:	48 89 c2             	mov    %rax,%rdx
    13b6:	48 be 10 26 00 00 00 	movabs $0x2610,%rsi
    13bd:	00 00 00 
    13c0:	bf 01 00 00 00       	mov    $0x1,%edi
    13c5:	b8 00 00 00 00       	mov    $0x0,%eax
    13ca:	49 ba cf 1a 00 00 00 	movabs $0x1acf,%r10
    13d1:	00 00 00 
    13d4:	41 ff d2             	callq  *%r10
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    13d7:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
    13de:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13e1:	ba 10 00 00 00       	mov    $0x10,%edx
    13e6:	48 89 ce             	mov    %rcx,%rsi
    13e9:	89 c7                	mov    %eax,%edi
    13eb:	48 b8 0c 18 00 00 00 	movabs $0x180c,%rax
    13f2:	00 00 00 
    13f5:	ff d0                	callq  *%rax
    13f7:	83 f8 10             	cmp    $0x10,%eax
    13fa:	0f 84 eb fe ff ff    	je     12eb <ls+0x1e1>
    }
    break;
    1400:	90                   	nop
  }
  close(fd);
    1401:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1404:	89 c7                	mov    %eax,%edi
    1406:	48 b8 26 18 00 00 00 	movabs $0x1826,%rax
    140d:	00 00 00 
    1410:	ff d0                	callq  *%rax
}
    1412:	48 81 c4 58 02 00 00 	add    $0x258,%rsp
    1419:	5b                   	pop    %rbx
    141a:	41 5c                	pop    %r12
    141c:	41 5d                	pop    %r13
    141e:	5d                   	pop    %rbp
    141f:	c3                   	retq   

0000000000001420 <main>:

int
main(int argc, char *argv[])
{
    1420:	f3 0f 1e fa          	endbr64 
    1424:	55                   	push   %rbp
    1425:	48 89 e5             	mov    %rsp,%rbp
    1428:	48 83 ec 20          	sub    $0x20,%rsp
    142c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    142f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  if(argc < 2){
    1433:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1437:	7f 22                	jg     145b <main+0x3b>
    ls(".");
    1439:	48 bf 30 26 00 00 00 	movabs $0x2630,%rdi
    1440:	00 00 00 
    1443:	48 b8 0a 11 00 00 00 	movabs $0x110a,%rax
    144a:	00 00 00 
    144d:	ff d0                	callq  *%rax
    exit();
    144f:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    1456:	00 00 00 
    1459:	ff d0                	callq  *%rax
  }
  for(i=1; i<argc; i++)
    145b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    1462:	eb 2a                	jmp    148e <main+0x6e>
    ls(argv[i]);
    1464:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1467:	48 98                	cltq   
    1469:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1470:	00 
    1471:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1475:	48 01 d0             	add    %rdx,%rax
    1478:	48 8b 00             	mov    (%rax),%rax
    147b:	48 89 c7             	mov    %rax,%rdi
    147e:	48 b8 0a 11 00 00 00 	movabs $0x110a,%rax
    1485:	00 00 00 
    1488:	ff d0                	callq  *%rax
  for(i=1; i<argc; i++)
    148a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    148e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1491:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1494:	7c ce                	jl     1464 <main+0x44>
  exit();
    1496:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    149d:	00 00 00 
    14a0:	ff d0                	callq  *%rax

00000000000014a2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    14a2:	f3 0f 1e fa          	endbr64 
    14a6:	55                   	push   %rbp
    14a7:	48 89 e5             	mov    %rsp,%rbp
    14aa:	48 83 ec 10          	sub    $0x10,%rsp
    14ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    14b2:	89 75 f4             	mov    %esi,-0xc(%rbp)
    14b5:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    14b8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    14bc:	8b 55 f0             	mov    -0x10(%rbp),%edx
    14bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
    14c2:	48 89 ce             	mov    %rcx,%rsi
    14c5:	48 89 f7             	mov    %rsi,%rdi
    14c8:	89 d1                	mov    %edx,%ecx
    14ca:	fc                   	cld    
    14cb:	f3 aa                	rep stos %al,%es:(%rdi)
    14cd:	89 ca                	mov    %ecx,%edx
    14cf:	48 89 fe             	mov    %rdi,%rsi
    14d2:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    14d6:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    14d9:	90                   	nop
    14da:	c9                   	leaveq 
    14db:	c3                   	retq   

00000000000014dc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    14dc:	f3 0f 1e fa          	endbr64 
    14e0:	55                   	push   %rbp
    14e1:	48 89 e5             	mov    %rsp,%rbp
    14e4:	48 83 ec 20          	sub    $0x20,%rsp
    14e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    14f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    14f8:	90                   	nop
    14f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    14fd:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1501:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1509:	48 8d 48 01          	lea    0x1(%rax),%rcx
    150d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1511:	0f b6 12             	movzbl (%rdx),%edx
    1514:	88 10                	mov    %dl,(%rax)
    1516:	0f b6 00             	movzbl (%rax),%eax
    1519:	84 c0                	test   %al,%al
    151b:	75 dc                	jne    14f9 <strcpy+0x1d>
    ;
  return os;
    151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1521:	c9                   	leaveq 
    1522:	c3                   	retq   

0000000000001523 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1523:	f3 0f 1e fa          	endbr64 
    1527:	55                   	push   %rbp
    1528:	48 89 e5             	mov    %rsp,%rbp
    152b:	48 83 ec 10          	sub    $0x10,%rsp
    152f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1533:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1537:	eb 0a                	jmp    1543 <strcmp+0x20>
    p++, q++;
    1539:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    153e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1547:	0f b6 00             	movzbl (%rax),%eax
    154a:	84 c0                	test   %al,%al
    154c:	74 12                	je     1560 <strcmp+0x3d>
    154e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1552:	0f b6 10             	movzbl (%rax),%edx
    1555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1559:	0f b6 00             	movzbl (%rax),%eax
    155c:	38 c2                	cmp    %al,%dl
    155e:	74 d9                	je     1539 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1560:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1564:	0f b6 00             	movzbl (%rax),%eax
    1567:	0f b6 d0             	movzbl %al,%edx
    156a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    156e:	0f b6 00             	movzbl (%rax),%eax
    1571:	0f b6 c0             	movzbl %al,%eax
    1574:	29 c2                	sub    %eax,%edx
    1576:	89 d0                	mov    %edx,%eax
}
    1578:	c9                   	leaveq 
    1579:	c3                   	retq   

000000000000157a <strlen>:

uint
strlen(char *s)
{
    157a:	f3 0f 1e fa          	endbr64 
    157e:	55                   	push   %rbp
    157f:	48 89 e5             	mov    %rsp,%rbp
    1582:	48 83 ec 18          	sub    $0x18,%rsp
    1586:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    158a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1591:	eb 04                	jmp    1597 <strlen+0x1d>
    1593:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1597:	8b 45 fc             	mov    -0x4(%rbp),%eax
    159a:	48 63 d0             	movslq %eax,%rdx
    159d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    15a1:	48 01 d0             	add    %rdx,%rax
    15a4:	0f b6 00             	movzbl (%rax),%eax
    15a7:	84 c0                	test   %al,%al
    15a9:	75 e8                	jne    1593 <strlen+0x19>
    ;
  return n;
    15ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    15ae:	c9                   	leaveq 
    15af:	c3                   	retq   

00000000000015b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    15b0:	f3 0f 1e fa          	endbr64 
    15b4:	55                   	push   %rbp
    15b5:	48 89 e5             	mov    %rsp,%rbp
    15b8:	48 83 ec 10          	sub    $0x10,%rsp
    15bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15c0:	89 75 f4             	mov    %esi,-0xc(%rbp)
    15c3:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    15c6:	8b 55 f0             	mov    -0x10(%rbp),%edx
    15c9:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    15cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15d0:	89 ce                	mov    %ecx,%esi
    15d2:	48 89 c7             	mov    %rax,%rdi
    15d5:	48 b8 a2 14 00 00 00 	movabs $0x14a2,%rax
    15dc:	00 00 00 
    15df:	ff d0                	callq  *%rax
  return dst;
    15e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    15e5:	c9                   	leaveq 
    15e6:	c3                   	retq   

00000000000015e7 <strchr>:

char*
strchr(const char *s, char c)
{
    15e7:	f3 0f 1e fa          	endbr64 
    15eb:	55                   	push   %rbp
    15ec:	48 89 e5             	mov    %rsp,%rbp
    15ef:	48 83 ec 10          	sub    $0x10,%rsp
    15f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15f7:	89 f0                	mov    %esi,%eax
    15f9:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    15fc:	eb 17                	jmp    1615 <strchr+0x2e>
    if(*s == c)
    15fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1602:	0f b6 00             	movzbl (%rax),%eax
    1605:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1608:	75 06                	jne    1610 <strchr+0x29>
      return (char*)s;
    160a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    160e:	eb 15                	jmp    1625 <strchr+0x3e>
  for(; *s; s++)
    1610:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1615:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1619:	0f b6 00             	movzbl (%rax),%eax
    161c:	84 c0                	test   %al,%al
    161e:	75 de                	jne    15fe <strchr+0x17>
  return 0;
    1620:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1625:	c9                   	leaveq 
    1626:	c3                   	retq   

0000000000001627 <gets>:

char*
gets(char *buf, int max)
{
    1627:	f3 0f 1e fa          	endbr64 
    162b:	55                   	push   %rbp
    162c:	48 89 e5             	mov    %rsp,%rbp
    162f:	48 83 ec 20          	sub    $0x20,%rsp
    1633:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1637:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    163a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1641:	eb 4f                	jmp    1692 <gets+0x6b>
    cc = read(0, &c, 1);
    1643:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1647:	ba 01 00 00 00       	mov    $0x1,%edx
    164c:	48 89 c6             	mov    %rax,%rsi
    164f:	bf 00 00 00 00       	mov    $0x0,%edi
    1654:	48 b8 0c 18 00 00 00 	movabs $0x180c,%rax
    165b:	00 00 00 
    165e:	ff d0                	callq  *%rax
    1660:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1663:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1667:	7e 36                	jle    169f <gets+0x78>
      break;
    buf[i++] = c;
    1669:	8b 45 fc             	mov    -0x4(%rbp),%eax
    166c:	8d 50 01             	lea    0x1(%rax),%edx
    166f:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1672:	48 63 d0             	movslq %eax,%rdx
    1675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1679:	48 01 c2             	add    %rax,%rdx
    167c:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1680:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1682:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1686:	3c 0a                	cmp    $0xa,%al
    1688:	74 16                	je     16a0 <gets+0x79>
    168a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    168e:	3c 0d                	cmp    $0xd,%al
    1690:	74 0e                	je     16a0 <gets+0x79>
  for(i=0; i+1 < max; ){
    1692:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1695:	83 c0 01             	add    $0x1,%eax
    1698:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    169b:	7f a6                	jg     1643 <gets+0x1c>
    169d:	eb 01                	jmp    16a0 <gets+0x79>
      break;
    169f:	90                   	nop
      break;
  }
  buf[i] = '\0';
    16a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16a3:	48 63 d0             	movslq %eax,%rdx
    16a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16aa:	48 01 d0             	add    %rdx,%rax
    16ad:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    16b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    16b4:	c9                   	leaveq 
    16b5:	c3                   	retq   

00000000000016b6 <stat>:

int
stat(char *n, struct stat *st)
{
    16b6:	f3 0f 1e fa          	endbr64 
    16ba:	55                   	push   %rbp
    16bb:	48 89 e5             	mov    %rsp,%rbp
    16be:	48 83 ec 20          	sub    $0x20,%rsp
    16c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    16c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    16ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16ce:	be 00 00 00 00       	mov    $0x0,%esi
    16d3:	48 89 c7             	mov    %rax,%rdi
    16d6:	48 b8 4d 18 00 00 00 	movabs $0x184d,%rax
    16dd:	00 00 00 
    16e0:	ff d0                	callq  *%rax
    16e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    16e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    16e9:	79 07                	jns    16f2 <stat+0x3c>
    return -1;
    16eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    16f0:	eb 2f                	jmp    1721 <stat+0x6b>
  r = fstat(fd, st);
    16f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    16f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16f9:	48 89 d6             	mov    %rdx,%rsi
    16fc:	89 c7                	mov    %eax,%edi
    16fe:	48 b8 74 18 00 00 00 	movabs $0x1874,%rax
    1705:	00 00 00 
    1708:	ff d0                	callq  *%rax
    170a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    170d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1710:	89 c7                	mov    %eax,%edi
    1712:	48 b8 26 18 00 00 00 	movabs $0x1826,%rax
    1719:	00 00 00 
    171c:	ff d0                	callq  *%rax
  return r;
    171e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1721:	c9                   	leaveq 
    1722:	c3                   	retq   

0000000000001723 <atoi>:

int
atoi(const char *s)
{
    1723:	f3 0f 1e fa          	endbr64 
    1727:	55                   	push   %rbp
    1728:	48 89 e5             	mov    %rsp,%rbp
    172b:	48 83 ec 18          	sub    $0x18,%rsp
    172f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1733:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    173a:	eb 28                	jmp    1764 <atoi+0x41>
    n = n*10 + *s++ - '0';
    173c:	8b 55 fc             	mov    -0x4(%rbp),%edx
    173f:	89 d0                	mov    %edx,%eax
    1741:	c1 e0 02             	shl    $0x2,%eax
    1744:	01 d0                	add    %edx,%eax
    1746:	01 c0                	add    %eax,%eax
    1748:	89 c1                	mov    %eax,%ecx
    174a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    174e:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1752:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1756:	0f b6 00             	movzbl (%rax),%eax
    1759:	0f be c0             	movsbl %al,%eax
    175c:	01 c8                	add    %ecx,%eax
    175e:	83 e8 30             	sub    $0x30,%eax
    1761:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1768:	0f b6 00             	movzbl (%rax),%eax
    176b:	3c 2f                	cmp    $0x2f,%al
    176d:	7e 0b                	jle    177a <atoi+0x57>
    176f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1773:	0f b6 00             	movzbl (%rax),%eax
    1776:	3c 39                	cmp    $0x39,%al
    1778:	7e c2                	jle    173c <atoi+0x19>
  return n;
    177a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    177d:	c9                   	leaveq 
    177e:	c3                   	retq   

000000000000177f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    177f:	f3 0f 1e fa          	endbr64 
    1783:	55                   	push   %rbp
    1784:	48 89 e5             	mov    %rsp,%rbp
    1787:	48 83 ec 28          	sub    $0x28,%rsp
    178b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    178f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1793:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    179a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    179e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    17a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    17a6:	eb 1d                	jmp    17c5 <memmove+0x46>
    *dst++ = *src++;
    17a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    17ac:	48 8d 42 01          	lea    0x1(%rdx),%rax
    17b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    17b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    17b8:	48 8d 48 01          	lea    0x1(%rax),%rcx
    17bc:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    17c0:	0f b6 12             	movzbl (%rdx),%edx
    17c3:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    17c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17c8:	8d 50 ff             	lea    -0x1(%rax),%edx
    17cb:	89 55 dc             	mov    %edx,-0x24(%rbp)
    17ce:	85 c0                	test   %eax,%eax
    17d0:	7f d6                	jg     17a8 <memmove+0x29>
  return vdst;
    17d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    17d6:	c9                   	leaveq 
    17d7:	c3                   	retq   

00000000000017d8 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    17d8:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    17df:	49 89 ca             	mov    %rcx,%r10
    17e2:	0f 05                	syscall 
    17e4:	c3                   	retq   

00000000000017e5 <exit>:
SYSCALL(exit)
    17e5:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    17ec:	49 89 ca             	mov    %rcx,%r10
    17ef:	0f 05                	syscall 
    17f1:	c3                   	retq   

00000000000017f2 <wait>:
SYSCALL(wait)
    17f2:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    17f9:	49 89 ca             	mov    %rcx,%r10
    17fc:	0f 05                	syscall 
    17fe:	c3                   	retq   

00000000000017ff <pipe>:
SYSCALL(pipe)
    17ff:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1806:	49 89 ca             	mov    %rcx,%r10
    1809:	0f 05                	syscall 
    180b:	c3                   	retq   

000000000000180c <read>:
SYSCALL(read)
    180c:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1813:	49 89 ca             	mov    %rcx,%r10
    1816:	0f 05                	syscall 
    1818:	c3                   	retq   

0000000000001819 <write>:
SYSCALL(write)
    1819:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1820:	49 89 ca             	mov    %rcx,%r10
    1823:	0f 05                	syscall 
    1825:	c3                   	retq   

0000000000001826 <close>:
SYSCALL(close)
    1826:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    182d:	49 89 ca             	mov    %rcx,%r10
    1830:	0f 05                	syscall 
    1832:	c3                   	retq   

0000000000001833 <kill>:
SYSCALL(kill)
    1833:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    183a:	49 89 ca             	mov    %rcx,%r10
    183d:	0f 05                	syscall 
    183f:	c3                   	retq   

0000000000001840 <exec>:
SYSCALL(exec)
    1840:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1847:	49 89 ca             	mov    %rcx,%r10
    184a:	0f 05                	syscall 
    184c:	c3                   	retq   

000000000000184d <open>:
SYSCALL(open)
    184d:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1854:	49 89 ca             	mov    %rcx,%r10
    1857:	0f 05                	syscall 
    1859:	c3                   	retq   

000000000000185a <mknod>:
SYSCALL(mknod)
    185a:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1861:	49 89 ca             	mov    %rcx,%r10
    1864:	0f 05                	syscall 
    1866:	c3                   	retq   

0000000000001867 <unlink>:
SYSCALL(unlink)
    1867:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    186e:	49 89 ca             	mov    %rcx,%r10
    1871:	0f 05                	syscall 
    1873:	c3                   	retq   

0000000000001874 <fstat>:
SYSCALL(fstat)
    1874:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    187b:	49 89 ca             	mov    %rcx,%r10
    187e:	0f 05                	syscall 
    1880:	c3                   	retq   

0000000000001881 <link>:
SYSCALL(link)
    1881:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1888:	49 89 ca             	mov    %rcx,%r10
    188b:	0f 05                	syscall 
    188d:	c3                   	retq   

000000000000188e <mkdir>:
SYSCALL(mkdir)
    188e:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1895:	49 89 ca             	mov    %rcx,%r10
    1898:	0f 05                	syscall 
    189a:	c3                   	retq   

000000000000189b <chdir>:
SYSCALL(chdir)
    189b:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    18a2:	49 89 ca             	mov    %rcx,%r10
    18a5:	0f 05                	syscall 
    18a7:	c3                   	retq   

00000000000018a8 <dup>:
SYSCALL(dup)
    18a8:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    18af:	49 89 ca             	mov    %rcx,%r10
    18b2:	0f 05                	syscall 
    18b4:	c3                   	retq   

00000000000018b5 <getpid>:
SYSCALL(getpid)
    18b5:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    18bc:	49 89 ca             	mov    %rcx,%r10
    18bf:	0f 05                	syscall 
    18c1:	c3                   	retq   

00000000000018c2 <sbrk>:
SYSCALL(sbrk)
    18c2:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    18c9:	49 89 ca             	mov    %rcx,%r10
    18cc:	0f 05                	syscall 
    18ce:	c3                   	retq   

00000000000018cf <sleep>:
SYSCALL(sleep)
    18cf:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    18d6:	49 89 ca             	mov    %rcx,%r10
    18d9:	0f 05                	syscall 
    18db:	c3                   	retq   

00000000000018dc <uptime>:
SYSCALL(uptime)
    18dc:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    18e3:	49 89 ca             	mov    %rcx,%r10
    18e6:	0f 05                	syscall 
    18e8:	c3                   	retq   

00000000000018e9 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    18e9:	f3 0f 1e fa          	endbr64 
    18ed:	55                   	push   %rbp
    18ee:	48 89 e5             	mov    %rsp,%rbp
    18f1:	48 83 ec 10          	sub    $0x10,%rsp
    18f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
    18f8:	89 f0                	mov    %esi,%eax
    18fa:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    18fd:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1901:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1904:	ba 01 00 00 00       	mov    $0x1,%edx
    1909:	48 89 ce             	mov    %rcx,%rsi
    190c:	89 c7                	mov    %eax,%edi
    190e:	48 b8 19 18 00 00 00 	movabs $0x1819,%rax
    1915:	00 00 00 
    1918:	ff d0                	callq  *%rax
}
    191a:	90                   	nop
    191b:	c9                   	leaveq 
    191c:	c3                   	retq   

000000000000191d <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    191d:	f3 0f 1e fa          	endbr64 
    1921:	55                   	push   %rbp
    1922:	48 89 e5             	mov    %rsp,%rbp
    1925:	48 83 ec 20          	sub    $0x20,%rsp
    1929:	89 7d ec             	mov    %edi,-0x14(%rbp)
    192c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1930:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1937:	eb 35                	jmp    196e <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1939:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    193d:	48 c1 e8 3c          	shr    $0x3c,%rax
    1941:	48 ba 80 2a 00 00 00 	movabs $0x2a80,%rdx
    1948:	00 00 00 
    194b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    194f:	0f be d0             	movsbl %al,%edx
    1952:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1955:	89 d6                	mov    %edx,%esi
    1957:	89 c7                	mov    %eax,%edi
    1959:	48 b8 e9 18 00 00 00 	movabs $0x18e9,%rax
    1960:	00 00 00 
    1963:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1965:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1969:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    196e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1971:	83 f8 0f             	cmp    $0xf,%eax
    1974:	76 c3                	jbe    1939 <print_x64+0x1c>
}
    1976:	90                   	nop
    1977:	90                   	nop
    1978:	c9                   	leaveq 
    1979:	c3                   	retq   

000000000000197a <print_x32>:

  static void
print_x32(int fd, uint x)
{
    197a:	f3 0f 1e fa          	endbr64 
    197e:	55                   	push   %rbp
    197f:	48 89 e5             	mov    %rsp,%rbp
    1982:	48 83 ec 20          	sub    $0x20,%rsp
    1986:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1989:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    198c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1993:	eb 36                	jmp    19cb <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1995:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1998:	c1 e8 1c             	shr    $0x1c,%eax
    199b:	89 c2                	mov    %eax,%edx
    199d:	48 b8 80 2a 00 00 00 	movabs $0x2a80,%rax
    19a4:	00 00 00 
    19a7:	89 d2                	mov    %edx,%edx
    19a9:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    19ad:	0f be d0             	movsbl %al,%edx
    19b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
    19b3:	89 d6                	mov    %edx,%esi
    19b5:	89 c7                	mov    %eax,%edi
    19b7:	48 b8 e9 18 00 00 00 	movabs $0x18e9,%rax
    19be:	00 00 00 
    19c1:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    19c3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    19c7:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    19cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
    19ce:	83 f8 07             	cmp    $0x7,%eax
    19d1:	76 c2                	jbe    1995 <print_x32+0x1b>
}
    19d3:	90                   	nop
    19d4:	90                   	nop
    19d5:	c9                   	leaveq 
    19d6:	c3                   	retq   

00000000000019d7 <print_d>:

  static void
print_d(int fd, int v)
{
    19d7:	f3 0f 1e fa          	endbr64 
    19db:	55                   	push   %rbp
    19dc:	48 89 e5             	mov    %rsp,%rbp
    19df:	48 83 ec 30          	sub    $0x30,%rsp
    19e3:	89 7d dc             	mov    %edi,-0x24(%rbp)
    19e6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    19e9:	8b 45 d8             	mov    -0x28(%rbp),%eax
    19ec:	48 98                	cltq   
    19ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    19f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    19f6:	79 04                	jns    19fc <print_d+0x25>
    x = -x;
    19f8:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    19fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1a03:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a07:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a0e:	66 66 66 
    1a11:	48 89 c8             	mov    %rcx,%rax
    1a14:	48 f7 ea             	imul   %rdx
    1a17:	48 c1 fa 02          	sar    $0x2,%rdx
    1a1b:	48 89 c8             	mov    %rcx,%rax
    1a1e:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a22:	48 29 c2             	sub    %rax,%rdx
    1a25:	48 89 d0             	mov    %rdx,%rax
    1a28:	48 c1 e0 02          	shl    $0x2,%rax
    1a2c:	48 01 d0             	add    %rdx,%rax
    1a2f:	48 01 c0             	add    %rax,%rax
    1a32:	48 29 c1             	sub    %rax,%rcx
    1a35:	48 89 ca             	mov    %rcx,%rdx
    1a38:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a3b:	8d 48 01             	lea    0x1(%rax),%ecx
    1a3e:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1a41:	48 b9 80 2a 00 00 00 	movabs $0x2a80,%rcx
    1a48:	00 00 00 
    1a4b:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1a4f:	48 98                	cltq   
    1a51:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1a55:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a59:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a60:	66 66 66 
    1a63:	48 89 c8             	mov    %rcx,%rax
    1a66:	48 f7 ea             	imul   %rdx
    1a69:	48 c1 fa 02          	sar    $0x2,%rdx
    1a6d:	48 89 c8             	mov    %rcx,%rax
    1a70:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a74:	48 29 c2             	sub    %rax,%rdx
    1a77:	48 89 d0             	mov    %rdx,%rax
    1a7a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1a7e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1a83:	0f 85 7a ff ff ff    	jne    1a03 <print_d+0x2c>

  if (v < 0)
    1a89:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1a8d:	79 32                	jns    1ac1 <print_d+0xea>
    buf[i++] = '-';
    1a8f:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a92:	8d 50 01             	lea    0x1(%rax),%edx
    1a95:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1a98:	48 98                	cltq   
    1a9a:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1a9f:	eb 20                	jmp    1ac1 <print_d+0xea>
    putc(fd, buf[i]);
    1aa1:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1aa4:	48 98                	cltq   
    1aa6:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1aab:	0f be d0             	movsbl %al,%edx
    1aae:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1ab1:	89 d6                	mov    %edx,%esi
    1ab3:	89 c7                	mov    %eax,%edi
    1ab5:	48 b8 e9 18 00 00 00 	movabs $0x18e9,%rax
    1abc:	00 00 00 
    1abf:	ff d0                	callq  *%rax
  while (--i >= 0)
    1ac1:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1ac9:	79 d6                	jns    1aa1 <print_d+0xca>
}
    1acb:	90                   	nop
    1acc:	90                   	nop
    1acd:	c9                   	leaveq 
    1ace:	c3                   	retq   

0000000000001acf <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1acf:	f3 0f 1e fa          	endbr64 
    1ad3:	55                   	push   %rbp
    1ad4:	48 89 e5             	mov    %rsp,%rbp
    1ad7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1ade:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1ae4:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1aeb:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1af2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1af9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1b00:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1b07:	84 c0                	test   %al,%al
    1b09:	74 20                	je     1b2b <printf+0x5c>
    1b0b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1b0f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1b13:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1b17:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1b1b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1b1f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1b23:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1b27:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1b2b:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1b32:	00 00 00 
    1b35:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1b3c:	00 00 00 
    1b3f:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1b43:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1b4a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1b51:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b58:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1b5f:	00 00 00 
    1b62:	e9 41 03 00 00       	jmpq   1ea8 <printf+0x3d9>
    if (c != '%') {
    1b67:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1b6e:	74 24                	je     1b94 <printf+0xc5>
      putc(fd, c);
    1b70:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b76:	0f be d0             	movsbl %al,%edx
    1b79:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b7f:	89 d6                	mov    %edx,%esi
    1b81:	89 c7                	mov    %eax,%edi
    1b83:	48 b8 e9 18 00 00 00 	movabs $0x18e9,%rax
    1b8a:	00 00 00 
    1b8d:	ff d0                	callq  *%rax
      continue;
    1b8f:	e9 0d 03 00 00       	jmpq   1ea1 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1b94:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b9b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ba1:	48 63 d0             	movslq %eax,%rdx
    1ba4:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bab:	48 01 d0             	add    %rdx,%rax
    1bae:	0f b6 00             	movzbl (%rax),%eax
    1bb1:	0f be c0             	movsbl %al,%eax
    1bb4:	25 ff 00 00 00       	and    $0xff,%eax
    1bb9:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1bbf:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bc6:	0f 84 0f 03 00 00    	je     1edb <printf+0x40c>
      break;
    switch(c) {
    1bcc:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1bd3:	0f 84 74 02 00 00    	je     1e4d <printf+0x37e>
    1bd9:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1be0:	0f 8c 82 02 00 00    	jl     1e68 <printf+0x399>
    1be6:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1bed:	0f 8f 75 02 00 00    	jg     1e68 <printf+0x399>
    1bf3:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1bfa:	0f 8c 68 02 00 00    	jl     1e68 <printf+0x399>
    1c00:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1c06:	83 e8 63             	sub    $0x63,%eax
    1c09:	83 f8 15             	cmp    $0x15,%eax
    1c0c:	0f 87 56 02 00 00    	ja     1e68 <printf+0x399>
    1c12:	89 c0                	mov    %eax,%eax
    1c14:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1c1b:	00 
    1c1c:	48 b8 40 26 00 00 00 	movabs $0x2640,%rax
    1c23:	00 00 00 
    1c26:	48 01 d0             	add    %rdx,%rax
    1c29:	48 8b 00             	mov    (%rax),%rax
    1c2c:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1c2f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c35:	83 f8 2f             	cmp    $0x2f,%eax
    1c38:	77 23                	ja     1c5d <printf+0x18e>
    1c3a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c41:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c47:	89 d2                	mov    %edx,%edx
    1c49:	48 01 d0             	add    %rdx,%rax
    1c4c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c52:	83 c2 08             	add    $0x8,%edx
    1c55:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c5b:	eb 12                	jmp    1c6f <printf+0x1a0>
    1c5d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c64:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c68:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c6f:	8b 00                	mov    (%rax),%eax
    1c71:	0f be d0             	movsbl %al,%edx
    1c74:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c7a:	89 d6                	mov    %edx,%esi
    1c7c:	89 c7                	mov    %eax,%edi
    1c7e:	48 b8 e9 18 00 00 00 	movabs $0x18e9,%rax
    1c85:	00 00 00 
    1c88:	ff d0                	callq  *%rax
      break;
    1c8a:	e9 12 02 00 00       	jmpq   1ea1 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1c8f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c95:	83 f8 2f             	cmp    $0x2f,%eax
    1c98:	77 23                	ja     1cbd <printf+0x1ee>
    1c9a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ca1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ca7:	89 d2                	mov    %edx,%edx
    1ca9:	48 01 d0             	add    %rdx,%rax
    1cac:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1cb2:	83 c2 08             	add    $0x8,%edx
    1cb5:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1cbb:	eb 12                	jmp    1ccf <printf+0x200>
    1cbd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1cc4:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1cc8:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ccf:	8b 10                	mov    (%rax),%edx
    1cd1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1cd7:	89 d6                	mov    %edx,%esi
    1cd9:	89 c7                	mov    %eax,%edi
    1cdb:	48 b8 d7 19 00 00 00 	movabs $0x19d7,%rax
    1ce2:	00 00 00 
    1ce5:	ff d0                	callq  *%rax
      break;
    1ce7:	e9 b5 01 00 00       	jmpq   1ea1 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1cec:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1cf2:	83 f8 2f             	cmp    $0x2f,%eax
    1cf5:	77 23                	ja     1d1a <printf+0x24b>
    1cf7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1cfe:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d04:	89 d2                	mov    %edx,%edx
    1d06:	48 01 d0             	add    %rdx,%rax
    1d09:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d0f:	83 c2 08             	add    $0x8,%edx
    1d12:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d18:	eb 12                	jmp    1d2c <printf+0x25d>
    1d1a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d21:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d25:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d2c:	8b 10                	mov    (%rax),%edx
    1d2e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d34:	89 d6                	mov    %edx,%esi
    1d36:	89 c7                	mov    %eax,%edi
    1d38:	48 b8 7a 19 00 00 00 	movabs $0x197a,%rax
    1d3f:	00 00 00 
    1d42:	ff d0                	callq  *%rax
      break;
    1d44:	e9 58 01 00 00       	jmpq   1ea1 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1d49:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d4f:	83 f8 2f             	cmp    $0x2f,%eax
    1d52:	77 23                	ja     1d77 <printf+0x2a8>
    1d54:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d5b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d61:	89 d2                	mov    %edx,%edx
    1d63:	48 01 d0             	add    %rdx,%rax
    1d66:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d6c:	83 c2 08             	add    $0x8,%edx
    1d6f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d75:	eb 12                	jmp    1d89 <printf+0x2ba>
    1d77:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d7e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d82:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d89:	48 8b 10             	mov    (%rax),%rdx
    1d8c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d92:	48 89 d6             	mov    %rdx,%rsi
    1d95:	89 c7                	mov    %eax,%edi
    1d97:	48 b8 1d 19 00 00 00 	movabs $0x191d,%rax
    1d9e:	00 00 00 
    1da1:	ff d0                	callq  *%rax
      break;
    1da3:	e9 f9 00 00 00       	jmpq   1ea1 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1da8:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1dae:	83 f8 2f             	cmp    $0x2f,%eax
    1db1:	77 23                	ja     1dd6 <printf+0x307>
    1db3:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1dba:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1dc0:	89 d2                	mov    %edx,%edx
    1dc2:	48 01 d0             	add    %rdx,%rax
    1dc5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1dcb:	83 c2 08             	add    $0x8,%edx
    1dce:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1dd4:	eb 12                	jmp    1de8 <printf+0x319>
    1dd6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1ddd:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1de1:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1de8:	48 8b 00             	mov    (%rax),%rax
    1deb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1df2:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1df9:	00 
    1dfa:	75 41                	jne    1e3d <printf+0x36e>
        s = "(null)";
    1dfc:	48 b8 38 26 00 00 00 	movabs $0x2638,%rax
    1e03:	00 00 00 
    1e06:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1e0d:	eb 2e                	jmp    1e3d <printf+0x36e>
        putc(fd, *(s++));
    1e0f:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e16:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1e1a:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1e21:	0f b6 00             	movzbl (%rax),%eax
    1e24:	0f be d0             	movsbl %al,%edx
    1e27:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e2d:	89 d6                	mov    %edx,%esi
    1e2f:	89 c7                	mov    %eax,%edi
    1e31:	48 b8 e9 18 00 00 00 	movabs $0x18e9,%rax
    1e38:	00 00 00 
    1e3b:	ff d0                	callq  *%rax
      while (*s)
    1e3d:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e44:	0f b6 00             	movzbl (%rax),%eax
    1e47:	84 c0                	test   %al,%al
    1e49:	75 c4                	jne    1e0f <printf+0x340>
      break;
    1e4b:	eb 54                	jmp    1ea1 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1e4d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e53:	be 25 00 00 00       	mov    $0x25,%esi
    1e58:	89 c7                	mov    %eax,%edi
    1e5a:	48 b8 e9 18 00 00 00 	movabs $0x18e9,%rax
    1e61:	00 00 00 
    1e64:	ff d0                	callq  *%rax
      break;
    1e66:	eb 39                	jmp    1ea1 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1e68:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e6e:	be 25 00 00 00       	mov    $0x25,%esi
    1e73:	89 c7                	mov    %eax,%edi
    1e75:	48 b8 e9 18 00 00 00 	movabs $0x18e9,%rax
    1e7c:	00 00 00 
    1e7f:	ff d0                	callq  *%rax
      putc(fd, c);
    1e81:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1e87:	0f be d0             	movsbl %al,%edx
    1e8a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e90:	89 d6                	mov    %edx,%esi
    1e92:	89 c7                	mov    %eax,%edi
    1e94:	48 b8 e9 18 00 00 00 	movabs $0x18e9,%rax
    1e9b:	00 00 00 
    1e9e:	ff d0                	callq  *%rax
      break;
    1ea0:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ea1:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ea8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1eae:	48 63 d0             	movslq %eax,%rdx
    1eb1:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1eb8:	48 01 d0             	add    %rdx,%rax
    1ebb:	0f b6 00             	movzbl (%rax),%eax
    1ebe:	0f be c0             	movsbl %al,%eax
    1ec1:	25 ff 00 00 00       	and    $0xff,%eax
    1ec6:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ecc:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ed3:	0f 85 8e fc ff ff    	jne    1b67 <printf+0x98>
    }
  }
}
    1ed9:	eb 01                	jmp    1edc <printf+0x40d>
      break;
    1edb:	90                   	nop
}
    1edc:	90                   	nop
    1edd:	c9                   	leaveq 
    1ede:	c3                   	retq   

0000000000001edf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1edf:	f3 0f 1e fa          	endbr64 
    1ee3:	55                   	push   %rbp
    1ee4:	48 89 e5             	mov    %rsp,%rbp
    1ee7:	48 83 ec 18          	sub    $0x18,%rsp
    1eeb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ef3:	48 83 e8 10          	sub    $0x10,%rax
    1ef7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1efb:	48 b8 c0 2a 00 00 00 	movabs $0x2ac0,%rax
    1f02:	00 00 00 
    1f05:	48 8b 00             	mov    (%rax),%rax
    1f08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f0c:	eb 2f                	jmp    1f3d <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1f0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f12:	48 8b 00             	mov    (%rax),%rax
    1f15:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f19:	72 17                	jb     1f32 <free+0x53>
    1f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f1f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1f23:	77 2f                	ja     1f54 <free+0x75>
    1f25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f29:	48 8b 00             	mov    (%rax),%rax
    1f2c:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f30:	72 22                	jb     1f54 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f36:	48 8b 00             	mov    (%rax),%rax
    1f39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f41:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1f45:	76 c7                	jbe    1f0e <free+0x2f>
    1f47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f4b:	48 8b 00             	mov    (%rax),%rax
    1f4e:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f52:	73 ba                	jae    1f0e <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1f54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f58:	8b 40 08             	mov    0x8(%rax),%eax
    1f5b:	89 c0                	mov    %eax,%eax
    1f5d:	48 c1 e0 04          	shl    $0x4,%rax
    1f61:	48 89 c2             	mov    %rax,%rdx
    1f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f68:	48 01 c2             	add    %rax,%rdx
    1f6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f6f:	48 8b 00             	mov    (%rax),%rax
    1f72:	48 39 c2             	cmp    %rax,%rdx
    1f75:	75 2d                	jne    1fa4 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1f77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f7b:	8b 50 08             	mov    0x8(%rax),%edx
    1f7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f82:	48 8b 00             	mov    (%rax),%rax
    1f85:	8b 40 08             	mov    0x8(%rax),%eax
    1f88:	01 c2                	add    %eax,%edx
    1f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f8e:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1f91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f95:	48 8b 00             	mov    (%rax),%rax
    1f98:	48 8b 10             	mov    (%rax),%rdx
    1f9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f9f:	48 89 10             	mov    %rdx,(%rax)
    1fa2:	eb 0e                	jmp    1fb2 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1fa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fa8:	48 8b 10             	mov    (%rax),%rdx
    1fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1faf:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1fb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb6:	8b 40 08             	mov    0x8(%rax),%eax
    1fb9:	89 c0                	mov    %eax,%eax
    1fbb:	48 c1 e0 04          	shl    $0x4,%rax
    1fbf:	48 89 c2             	mov    %rax,%rdx
    1fc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fc6:	48 01 d0             	add    %rdx,%rax
    1fc9:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1fcd:	75 27                	jne    1ff6 <free+0x117>
    p->s.size += bp->s.size;
    1fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd3:	8b 50 08             	mov    0x8(%rax),%edx
    1fd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fda:	8b 40 08             	mov    0x8(%rax),%eax
    1fdd:	01 c2                	add    %eax,%edx
    1fdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fe3:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1fe6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fea:	48 8b 10             	mov    (%rax),%rdx
    1fed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ff1:	48 89 10             	mov    %rdx,(%rax)
    1ff4:	eb 0b                	jmp    2001 <free+0x122>
  } else
    p->s.ptr = bp;
    1ff6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ffa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1ffe:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    2001:	48 ba c0 2a 00 00 00 	movabs $0x2ac0,%rdx
    2008:	00 00 00 
    200b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    200f:	48 89 02             	mov    %rax,(%rdx)
}
    2012:	90                   	nop
    2013:	c9                   	leaveq 
    2014:	c3                   	retq   

0000000000002015 <morecore>:

static Header*
morecore(uint nu)
{
    2015:	f3 0f 1e fa          	endbr64 
    2019:	55                   	push   %rbp
    201a:	48 89 e5             	mov    %rsp,%rbp
    201d:	48 83 ec 20          	sub    $0x20,%rsp
    2021:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    2024:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    202b:	77 07                	ja     2034 <morecore+0x1f>
    nu = 4096;
    202d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    2034:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2037:	48 c1 e0 04          	shl    $0x4,%rax
    203b:	48 89 c7             	mov    %rax,%rdi
    203e:	48 b8 c2 18 00 00 00 	movabs $0x18c2,%rax
    2045:	00 00 00 
    2048:	ff d0                	callq  *%rax
    204a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    204e:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    2053:	75 07                	jne    205c <morecore+0x47>
    return 0;
    2055:	b8 00 00 00 00       	mov    $0x0,%eax
    205a:	eb 36                	jmp    2092 <morecore+0x7d>
  hp = (Header*)p;
    205c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2060:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    2064:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2068:	8b 55 ec             	mov    -0x14(%rbp),%edx
    206b:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    206e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2072:	48 83 c0 10          	add    $0x10,%rax
    2076:	48 89 c7             	mov    %rax,%rdi
    2079:	48 b8 df 1e 00 00 00 	movabs $0x1edf,%rax
    2080:	00 00 00 
    2083:	ff d0                	callq  *%rax
  return freep;
    2085:	48 b8 c0 2a 00 00 00 	movabs $0x2ac0,%rax
    208c:	00 00 00 
    208f:	48 8b 00             	mov    (%rax),%rax
}
    2092:	c9                   	leaveq 
    2093:	c3                   	retq   

0000000000002094 <malloc>:

void*
malloc(uint nbytes)
{
    2094:	f3 0f 1e fa          	endbr64 
    2098:	55                   	push   %rbp
    2099:	48 89 e5             	mov    %rsp,%rbp
    209c:	48 83 ec 30          	sub    $0x30,%rsp
    20a0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    20a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
    20a6:	48 83 c0 0f          	add    $0xf,%rax
    20aa:	48 c1 e8 04          	shr    $0x4,%rax
    20ae:	83 c0 01             	add    $0x1,%eax
    20b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    20b4:	48 b8 c0 2a 00 00 00 	movabs $0x2ac0,%rax
    20bb:	00 00 00 
    20be:	48 8b 00             	mov    (%rax),%rax
    20c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20c5:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20ca:	75 4a                	jne    2116 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    20cc:	48 b8 b0 2a 00 00 00 	movabs $0x2ab0,%rax
    20d3:	00 00 00 
    20d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20da:	48 ba c0 2a 00 00 00 	movabs $0x2ac0,%rdx
    20e1:	00 00 00 
    20e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20e8:	48 89 02             	mov    %rax,(%rdx)
    20eb:	48 b8 c0 2a 00 00 00 	movabs $0x2ac0,%rax
    20f2:	00 00 00 
    20f5:	48 8b 00             	mov    (%rax),%rax
    20f8:	48 ba b0 2a 00 00 00 	movabs $0x2ab0,%rdx
    20ff:	00 00 00 
    2102:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    2105:	48 b8 b0 2a 00 00 00 	movabs $0x2ab0,%rax
    210c:	00 00 00 
    210f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2116:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    211a:	48 8b 00             	mov    (%rax),%rax
    211d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    2121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2125:	8b 40 08             	mov    0x8(%rax),%eax
    2128:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    212b:	77 65                	ja     2192 <malloc+0xfe>
      if(p->s.size == nunits)
    212d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2131:	8b 40 08             	mov    0x8(%rax),%eax
    2134:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2137:	75 10                	jne    2149 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    2139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    213d:	48 8b 10             	mov    (%rax),%rdx
    2140:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2144:	48 89 10             	mov    %rdx,(%rax)
    2147:	eb 2e                	jmp    2177 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    2149:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    214d:	8b 40 08             	mov    0x8(%rax),%eax
    2150:	2b 45 ec             	sub    -0x14(%rbp),%eax
    2153:	89 c2                	mov    %eax,%edx
    2155:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2159:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    215c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2160:	8b 40 08             	mov    0x8(%rax),%eax
    2163:	89 c0                	mov    %eax,%eax
    2165:	48 c1 e0 04          	shl    $0x4,%rax
    2169:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    216d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2171:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2174:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    2177:	48 ba c0 2a 00 00 00 	movabs $0x2ac0,%rdx
    217e:	00 00 00 
    2181:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2185:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    2188:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    218c:	48 83 c0 10          	add    $0x10,%rax
    2190:	eb 4e                	jmp    21e0 <malloc+0x14c>
    }
    if(p == freep)
    2192:	48 b8 c0 2a 00 00 00 	movabs $0x2ac0,%rax
    2199:	00 00 00 
    219c:	48 8b 00             	mov    (%rax),%rax
    219f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    21a3:	75 23                	jne    21c8 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    21a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    21a8:	89 c7                	mov    %eax,%edi
    21aa:	48 b8 15 20 00 00 00 	movabs $0x2015,%rax
    21b1:	00 00 00 
    21b4:	ff d0                	callq  *%rax
    21b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    21ba:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    21bf:	75 07                	jne    21c8 <malloc+0x134>
        return 0;
    21c1:	b8 00 00 00 00       	mov    $0x0,%eax
    21c6:	eb 18                	jmp    21e0 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    21c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    21d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21d4:	48 8b 00             	mov    (%rax),%rax
    21d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    21db:	e9 41 ff ff ff       	jmpq   2121 <malloc+0x8d>
  }
}
    21e0:	c9                   	leaveq 
    21e1:	c3                   	retq   

00000000000021e2 <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    21e2:	f3 0f 1e fa          	endbr64 
    21e6:	55                   	push   %rbp
    21e7:	48 89 e5             	mov    %rsp,%rbp
    21ea:	48 83 ec 30          	sub    $0x30,%rsp
    21ee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    21f2:	bf 18 00 00 00       	mov    $0x18,%edi
    21f7:	48 b8 94 20 00 00 00 	movabs $0x2094,%rax
    21fe:	00 00 00 
    2201:	ff d0                	callq  *%rax
    2203:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    2207:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    220c:	75 0a                	jne    2218 <co_new+0x36>
    return 0;
    220e:	b8 00 00 00 00       	mov    $0x0,%eax
    2213:	e9 e1 00 00 00       	jmpq   22f9 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    2218:	bf 00 20 00 00       	mov    $0x2000,%edi
    221d:	48 b8 94 20 00 00 00 	movabs $0x2094,%rax
    2224:	00 00 00 
    2227:	ff d0                	callq  *%rax
    2229:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    222d:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    2231:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2235:	48 8b 40 10          	mov    0x10(%rax),%rax
    2239:	48 85 c0             	test   %rax,%rax
    223c:	75 1d                	jne    225b <co_new+0x79>
    free(co1);
    223e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2242:	48 89 c7             	mov    %rax,%rdi
    2245:	48 b8 df 1e 00 00 00 	movabs $0x1edf,%rax
    224c:	00 00 00 
    224f:	ff d0                	callq  *%rax
    return 0;
    2251:	b8 00 00 00 00       	mov    $0x0,%eax
    2256:	e9 9e 00 00 00       	jmpq   22f9 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    225b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    225f:	48 8b 40 10          	mov    0x10(%rax),%rax
    2263:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    2269:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    226d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2271:	48 8d 50 30          	lea    0x30(%rax),%rdx
    2275:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    2279:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    227c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2280:	48 83 c0 38          	add    $0x38,%rax
    2284:	48 ba 6b 24 00 00 00 	movabs $0x246b,%rdx
    228b:	00 00 00 
    228e:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    2291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2295:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    2299:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    229c:	48 b8 d8 2a 00 00 00 	movabs $0x2ad8,%rax
    22a3:	00 00 00 
    22a6:	48 8b 00             	mov    (%rax),%rax
    22a9:	48 85 c0             	test   %rax,%rax
    22ac:	75 13                	jne    22c1 <co_new+0xdf>
  {
  	co_list = co1;
    22ae:	48 ba d8 2a 00 00 00 	movabs $0x2ad8,%rdx
    22b5:	00 00 00 
    22b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    22bc:	48 89 02             	mov    %rax,(%rdx)
    22bf:	eb 34                	jmp    22f5 <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    22c1:	48 b8 d8 2a 00 00 00 	movabs $0x2ad8,%rax
    22c8:	00 00 00 
    22cb:	48 8b 00             	mov    (%rax),%rax
    22ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    22d2:	eb 0c                	jmp    22e0 <co_new+0xfe>
	{
		head = head->next;
    22d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22d8:	48 8b 40 08          	mov    0x8(%rax),%rax
    22dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    22e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22e4:	48 8b 40 08          	mov    0x8(%rax),%rax
    22e8:	48 85 c0             	test   %rax,%rax
    22eb:	75 e7                	jne    22d4 <co_new+0xf2>
	}
	head = co1;
    22ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    22f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    22f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    22f9:	c9                   	leaveq 
    22fa:	c3                   	retq   

00000000000022fb <co_run>:

  int
co_run(void)
{
    22fb:	f3 0f 1e fa          	endbr64 
    22ff:	55                   	push   %rbp
    2300:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    2303:	48 b8 d8 2a 00 00 00 	movabs $0x2ad8,%rax
    230a:	00 00 00 
    230d:	48 8b 00             	mov    (%rax),%rax
    2310:	48 85 c0             	test   %rax,%rax
    2313:	74 4a                	je     235f <co_run+0x64>
	{
		co_current = co_list;
    2315:	48 b8 d8 2a 00 00 00 	movabs $0x2ad8,%rax
    231c:	00 00 00 
    231f:	48 8b 00             	mov    (%rax),%rax
    2322:	48 ba d0 2a 00 00 00 	movabs $0x2ad0,%rdx
    2329:	00 00 00 
    232c:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    232f:	48 b8 d0 2a 00 00 00 	movabs $0x2ad0,%rax
    2336:	00 00 00 
    2339:	48 8b 00             	mov    (%rax),%rax
    233c:	48 8b 00             	mov    (%rax),%rax
    233f:	48 89 c6             	mov    %rax,%rsi
    2342:	48 bf c8 2a 00 00 00 	movabs $0x2ac8,%rdi
    2349:	00 00 00 
    234c:	48 b8 cd 25 00 00 00 	movabs $0x25cd,%rax
    2353:	00 00 00 
    2356:	ff d0                	callq  *%rax
		return 1;
    2358:	b8 01 00 00 00       	mov    $0x1,%eax
    235d:	eb 05                	jmp    2364 <co_run+0x69>
	}
	return 0;
    235f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    2364:	5d                   	pop    %rbp
    2365:	c3                   	retq   

0000000000002366 <co_run_all>:

  int
co_run_all(void)
{
    2366:	f3 0f 1e fa          	endbr64 
    236a:	55                   	push   %rbp
    236b:	48 89 e5             	mov    %rsp,%rbp
    236e:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    2372:	48 b8 d8 2a 00 00 00 	movabs $0x2ad8,%rax
    2379:	00 00 00 
    237c:	48 8b 00             	mov    (%rax),%rax
    237f:	48 85 c0             	test   %rax,%rax
    2382:	75 07                	jne    238b <co_run_all+0x25>
		return 0;
    2384:	b8 00 00 00 00       	mov    $0x0,%eax
    2389:	eb 37                	jmp    23c2 <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    238b:	48 b8 d8 2a 00 00 00 	movabs $0x2ad8,%rax
    2392:	00 00 00 
    2395:	48 8b 00             	mov    (%rax),%rax
    2398:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    239c:	eb 18                	jmp    23b6 <co_run_all+0x50>
			co_run();
    239e:	48 b8 fb 22 00 00 00 	movabs $0x22fb,%rax
    23a5:	00 00 00 
    23a8:	ff d0                	callq  *%rax
			tmp = tmp->next;
    23aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    23ae:	48 8b 40 08          	mov    0x8(%rax),%rax
    23b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    23b6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    23bb:	75 e1                	jne    239e <co_run_all+0x38>
		}
		return 1;
    23bd:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    23c2:	c9                   	leaveq 
    23c3:	c3                   	retq   

00000000000023c4 <co_yield>:

  void
co_yield()
{
    23c4:	f3 0f 1e fa          	endbr64 
    23c8:	55                   	push   %rbp
    23c9:	48 89 e5             	mov    %rsp,%rbp
    23cc:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    23d0:	48 b8 d0 2a 00 00 00 	movabs $0x2ad0,%rax
    23d7:	00 00 00 
    23da:	48 8b 00             	mov    (%rax),%rax
    23dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    23e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    23e5:	48 8b 40 08          	mov    0x8(%rax),%rax
    23e9:	48 85 c0             	test   %rax,%rax
    23ec:	74 46                	je     2434 <co_yield+0x70>
  {
  	co_current = co_current->next;
    23ee:	48 b8 d0 2a 00 00 00 	movabs $0x2ad0,%rax
    23f5:	00 00 00 
    23f8:	48 8b 00             	mov    (%rax),%rax
    23fb:	48 8b 40 08          	mov    0x8(%rax),%rax
    23ff:	48 ba d0 2a 00 00 00 	movabs $0x2ad0,%rdx
    2406:	00 00 00 
    2409:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    240c:	48 b8 d0 2a 00 00 00 	movabs $0x2ad0,%rax
    2413:	00 00 00 
    2416:	48 8b 00             	mov    (%rax),%rax
    2419:	48 8b 10             	mov    (%rax),%rdx
    241c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2420:	48 89 d6             	mov    %rdx,%rsi
    2423:	48 89 c7             	mov    %rax,%rdi
    2426:	48 b8 cd 25 00 00 00 	movabs $0x25cd,%rax
    242d:	00 00 00 
    2430:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    2432:	eb 34                	jmp    2468 <co_yield+0xa4>
	co_current = 0;
    2434:	48 b8 d0 2a 00 00 00 	movabs $0x2ad0,%rax
    243b:	00 00 00 
    243e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    2445:	48 b8 c8 2a 00 00 00 	movabs $0x2ac8,%rax
    244c:	00 00 00 
    244f:	48 8b 10             	mov    (%rax),%rdx
    2452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2456:	48 89 d6             	mov    %rdx,%rsi
    2459:	48 89 c7             	mov    %rax,%rdi
    245c:	48 b8 cd 25 00 00 00 	movabs $0x25cd,%rax
    2463:	00 00 00 
    2466:	ff d0                	callq  *%rax
}
    2468:	90                   	nop
    2469:	c9                   	leaveq 
    246a:	c3                   	retq   

000000000000246b <co_exit>:

  void
co_exit(void)
{
    246b:	f3 0f 1e fa          	endbr64 
    246f:	55                   	push   %rbp
    2470:	48 89 e5             	mov    %rsp,%rbp
    2473:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    2477:	48 b8 d0 2a 00 00 00 	movabs $0x2ad0,%rax
    247e:	00 00 00 
    2481:	48 8b 00             	mov    (%rax),%rax
    2484:	48 85 c0             	test   %rax,%rax
    2487:	0f 84 ec 00 00 00    	je     2579 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    248d:	48 b8 d8 2a 00 00 00 	movabs $0x2ad8,%rax
    2494:	00 00 00 
    2497:	48 8b 00             	mov    (%rax),%rax
    249a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    249e:	e9 c9 00 00 00       	jmpq   256c <co_exit+0x101>
		if(tmp == co_current)
    24a3:	48 b8 d0 2a 00 00 00 	movabs $0x2ad0,%rax
    24aa:	00 00 00 
    24ad:	48 8b 00             	mov    (%rax),%rax
    24b0:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    24b4:	0f 85 9e 00 00 00    	jne    2558 <co_exit+0xed>
		{
			if(tmp->next)
    24ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    24be:	48 8b 40 08          	mov    0x8(%rax),%rax
    24c2:	48 85 c0             	test   %rax,%rax
    24c5:	74 54                	je     251b <co_exit+0xb0>
			{
				if(prev)
    24c7:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    24cc:	74 10                	je     24de <co_exit+0x73>
				{
					prev->next = tmp->next;
    24ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    24d2:	48 8b 50 08          	mov    0x8(%rax),%rdx
    24d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    24da:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    24de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    24e2:	48 8b 40 08          	mov    0x8(%rax),%rax
    24e6:	48 ba d8 2a 00 00 00 	movabs $0x2ad8,%rdx
    24ed:	00 00 00 
    24f0:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    24f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    24f7:	48 8b 00             	mov    (%rax),%rax
    24fa:	48 ba d0 2a 00 00 00 	movabs $0x2ad0,%rdx
    2501:	00 00 00 
    2504:	48 8b 12             	mov    (%rdx),%rdx
    2507:	48 89 c6             	mov    %rax,%rsi
    250a:	48 89 d7             	mov    %rdx,%rdi
    250d:	48 b8 cd 25 00 00 00 	movabs $0x25cd,%rax
    2514:	00 00 00 
    2517:	ff d0                	callq  *%rax
    2519:	eb 3d                	jmp    2558 <co_exit+0xed>
			}else{
				co_list = 0;
    251b:	48 b8 d8 2a 00 00 00 	movabs $0x2ad8,%rax
    2522:	00 00 00 
    2525:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    252c:	48 b8 c8 2a 00 00 00 	movabs $0x2ac8,%rax
    2533:	00 00 00 
    2536:	48 8b 00             	mov    (%rax),%rax
    2539:	48 ba d0 2a 00 00 00 	movabs $0x2ad0,%rdx
    2540:	00 00 00 
    2543:	48 8b 12             	mov    (%rdx),%rdx
    2546:	48 89 c6             	mov    %rax,%rsi
    2549:	48 89 d7             	mov    %rdx,%rdi
    254c:	48 b8 cd 25 00 00 00 	movabs $0x25cd,%rax
    2553:	00 00 00 
    2556:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    2558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    255c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    2560:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2564:	48 8b 40 08          	mov    0x8(%rax),%rax
    2568:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    256c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2571:	0f 85 2c ff ff ff    	jne    24a3 <co_exit+0x38>
    2577:	eb 01                	jmp    257a <co_exit+0x10f>
		return;
    2579:	90                   	nop
	}
}
    257a:	c9                   	leaveq 
    257b:	c3                   	retq   

000000000000257c <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    257c:	f3 0f 1e fa          	endbr64 
    2580:	55                   	push   %rbp
    2581:	48 89 e5             	mov    %rsp,%rbp
    2584:	48 83 ec 10          	sub    $0x10,%rsp
    2588:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    258c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2591:	74 37                	je     25ca <co_destroy+0x4e>
    if (co->stack)
    2593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2597:	48 8b 40 10          	mov    0x10(%rax),%rax
    259b:	48 85 c0             	test   %rax,%rax
    259e:	74 17                	je     25b7 <co_destroy+0x3b>
      free(co->stack);
    25a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    25a4:	48 8b 40 10          	mov    0x10(%rax),%rax
    25a8:	48 89 c7             	mov    %rax,%rdi
    25ab:	48 b8 df 1e 00 00 00 	movabs $0x1edf,%rax
    25b2:	00 00 00 
    25b5:	ff d0                	callq  *%rax
    free(co);
    25b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    25bb:	48 89 c7             	mov    %rax,%rdi
    25be:	48 b8 df 1e 00 00 00 	movabs $0x1edf,%rax
    25c5:	00 00 00 
    25c8:	ff d0                	callq  *%rax
  }
}
    25ca:	90                   	nop
    25cb:	c9                   	leaveq 
    25cc:	c3                   	retq   

00000000000025cd <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    25cd:	55                   	push   %rbp
  pushq   %rbx
    25ce:	53                   	push   %rbx
  pushq   %r12
    25cf:	41 54                	push   %r12
  pushq   %r13
    25d1:	41 55                	push   %r13
  pushq   %r14
    25d3:	41 56                	push   %r14
  pushq   %r15
    25d5:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    25d7:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    25da:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    25dd:	41 5f                	pop    %r15
  popq    %r14
    25df:	41 5e                	pop    %r14
  popq    %r13
    25e1:	41 5d                	pop    %r13
  popq    %r12
    25e3:	41 5c                	pop    %r12
  popq    %rbx
    25e5:	5b                   	pop    %rbx
  popq    %rbp
    25e6:	5d                   	pop    %rbp

  retq #??
    25e7:	c3                   	retq   
