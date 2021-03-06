
_sh:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 40          	sub    $0x40,%rsp
    100c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    1010:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
    1015:	75 0c                	jne    1023 <runcmd+0x23>
    exit();
    1017:	48 b8 83 25 00 00 00 	movabs $0x2583,%rax
    101e:	00 00 00 
    1021:	ff d0                	callq  *%rax

  switch(cmd->type){
    1023:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1027:	8b 00                	mov    (%rax),%eax
    1029:	83 f8 05             	cmp    $0x5,%eax
    102c:	77 1d                	ja     104b <runcmd+0x4b>
    102e:	89 c0                	mov    %eax,%eax
    1030:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1037:	00 
    1038:	48 b8 b8 33 00 00 00 	movabs $0x33b8,%rax
    103f:	00 00 00 
    1042:	48 01 d0             	add    %rdx,%rax
    1045:	48 8b 00             	mov    (%rax),%rax
    1048:	3e ff e0             	notrack jmpq *%rax
  default:
    panic("runcmd");
    104b:	48 bf 88 33 00 00 00 	movabs $0x3388,%rdi
    1052:	00 00 00 
    1055:	48 b8 33 15 00 00 00 	movabs $0x1533,%rax
    105c:	00 00 00 
    105f:	ff d0                	callq  *%rax

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    1061:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1065:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    if(ecmd->argv[0] == 0)
    1069:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    106d:	48 8b 40 08          	mov    0x8(%rax),%rax
    1071:	48 85 c0             	test   %rax,%rax
    1074:	75 0c                	jne    1082 <runcmd+0x82>
      exit();
    1076:	48 b8 83 25 00 00 00 	movabs $0x2583,%rax
    107d:	00 00 00 
    1080:	ff d0                	callq  *%rax
    exec(ecmd->argv[0], ecmd->argv);
    1082:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1086:	48 8d 50 08          	lea    0x8(%rax),%rdx
    108a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    108e:	48 8b 40 08          	mov    0x8(%rax),%rax
    1092:	48 89 d6             	mov    %rdx,%rsi
    1095:	48 89 c7             	mov    %rax,%rdi
    1098:	48 b8 de 25 00 00 00 	movabs $0x25de,%rax
    109f:	00 00 00 
    10a2:	ff d0                	callq  *%rax
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    10a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    10a8:	48 8b 40 08          	mov    0x8(%rax),%rax
    10ac:	48 89 c2             	mov    %rax,%rdx
    10af:	48 be 8f 33 00 00 00 	movabs $0x338f,%rsi
    10b6:	00 00 00 
    10b9:	bf 02 00 00 00       	mov    $0x2,%edi
    10be:	b8 00 00 00 00       	mov    $0x0,%eax
    10c3:	48 b9 6d 28 00 00 00 	movabs $0x286d,%rcx
    10ca:	00 00 00 
    10cd:	ff d1                	callq  *%rcx
    break;
    10cf:	e9 62 02 00 00       	jmpq   1336 <runcmd+0x336>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    10d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    10d8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    close(rcmd->fd);
    10dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    10e0:	8b 40 24             	mov    0x24(%rax),%eax
    10e3:	89 c7                	mov    %eax,%edi
    10e5:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    10ec:	00 00 00 
    10ef:	ff d0                	callq  *%rax
    if(open(rcmd->file, rcmd->mode) < 0){
    10f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    10f5:	8b 50 20             	mov    0x20(%rax),%edx
    10f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    10fc:	48 8b 40 10          	mov    0x10(%rax),%rax
    1100:	89 d6                	mov    %edx,%esi
    1102:	48 89 c7             	mov    %rax,%rdi
    1105:	48 b8 eb 25 00 00 00 	movabs $0x25eb,%rax
    110c:	00 00 00 
    110f:	ff d0                	callq  *%rax
    1111:	85 c0                	test   %eax,%eax
    1113:	79 37                	jns    114c <runcmd+0x14c>
      printf(2, "open %s failed\n", rcmd->file);
    1115:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1119:	48 8b 40 10          	mov    0x10(%rax),%rax
    111d:	48 89 c2             	mov    %rax,%rdx
    1120:	48 be 9f 33 00 00 00 	movabs $0x339f,%rsi
    1127:	00 00 00 
    112a:	bf 02 00 00 00       	mov    $0x2,%edi
    112f:	b8 00 00 00 00       	mov    $0x0,%eax
    1134:	48 b9 6d 28 00 00 00 	movabs $0x286d,%rcx
    113b:	00 00 00 
    113e:	ff d1                	callq  *%rcx
      exit();
    1140:	48 b8 83 25 00 00 00 	movabs $0x2583,%rax
    1147:	00 00 00 
    114a:	ff d0                	callq  *%rax
    }
    runcmd(rcmd->cmd);
    114c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1150:	48 8b 40 08          	mov    0x8(%rax),%rax
    1154:	48 89 c7             	mov    %rax,%rdi
    1157:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    115e:	00 00 00 
    1161:	ff d0                	callq  *%rax
    break;
    1163:	e9 ce 01 00 00       	jmpq   1336 <runcmd+0x336>

  case LIST:
    lcmd = (struct listcmd*)cmd;
    1168:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    116c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(fork1() == 0)
    1170:	48 b8 76 15 00 00 00 	movabs $0x1576,%rax
    1177:	00 00 00 
    117a:	ff d0                	callq  *%rax
    117c:	85 c0                	test   %eax,%eax
    117e:	75 17                	jne    1197 <runcmd+0x197>
      runcmd(lcmd->left);
    1180:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1184:	48 8b 40 08          	mov    0x8(%rax),%rax
    1188:	48 89 c7             	mov    %rax,%rdi
    118b:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1192:	00 00 00 
    1195:	ff d0                	callq  *%rax
    wait();
    1197:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    119e:	00 00 00 
    11a1:	ff d0                	callq  *%rax
    runcmd(lcmd->right);
    11a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11a7:	48 8b 40 10          	mov    0x10(%rax),%rax
    11ab:	48 89 c7             	mov    %rax,%rdi
    11ae:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    11b5:	00 00 00 
    11b8:	ff d0                	callq  *%rax
    break;
    11ba:	e9 77 01 00 00       	jmpq   1336 <runcmd+0x336>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    11bf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    11c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(pipe(p) < 0)
    11c7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    11cb:	48 89 c7             	mov    %rax,%rdi
    11ce:	48 b8 9d 25 00 00 00 	movabs $0x259d,%rax
    11d5:	00 00 00 
    11d8:	ff d0                	callq  *%rax
    11da:	85 c0                	test   %eax,%eax
    11dc:	79 16                	jns    11f4 <runcmd+0x1f4>
      panic("pipe");
    11de:	48 bf af 33 00 00 00 	movabs $0x33af,%rdi
    11e5:	00 00 00 
    11e8:	48 b8 33 15 00 00 00 	movabs $0x1533,%rax
    11ef:	00 00 00 
    11f2:	ff d0                	callq  *%rax
    if(fork1() == 0){
    11f4:	48 b8 76 15 00 00 00 	movabs $0x1576,%rax
    11fb:	00 00 00 
    11fe:	ff d0                	callq  *%rax
    1200:	85 c0                	test   %eax,%eax
    1202:	75 5b                	jne    125f <runcmd+0x25f>
      close(1);
    1204:	bf 01 00 00 00       	mov    $0x1,%edi
    1209:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    1210:	00 00 00 
    1213:	ff d0                	callq  *%rax
      dup(p[1]);
    1215:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    1218:	89 c7                	mov    %eax,%edi
    121a:	48 b8 46 26 00 00 00 	movabs $0x2646,%rax
    1221:	00 00 00 
    1224:	ff d0                	callq  *%rax
      close(p[0]);
    1226:	8b 45 d0             	mov    -0x30(%rbp),%eax
    1229:	89 c7                	mov    %eax,%edi
    122b:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    1232:	00 00 00 
    1235:	ff d0                	callq  *%rax
      close(p[1]);
    1237:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    123a:	89 c7                	mov    %eax,%edi
    123c:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    1243:	00 00 00 
    1246:	ff d0                	callq  *%rax
      runcmd(pcmd->left);
    1248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    124c:	48 8b 40 08          	mov    0x8(%rax),%rax
    1250:	48 89 c7             	mov    %rax,%rdi
    1253:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    125a:	00 00 00 
    125d:	ff d0                	callq  *%rax
    }
    if(fork1() == 0){
    125f:	48 b8 76 15 00 00 00 	movabs $0x1576,%rax
    1266:	00 00 00 
    1269:	ff d0                	callq  *%rax
    126b:	85 c0                	test   %eax,%eax
    126d:	75 5b                	jne    12ca <runcmd+0x2ca>
      close(0);
    126f:	bf 00 00 00 00       	mov    $0x0,%edi
    1274:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    127b:	00 00 00 
    127e:	ff d0                	callq  *%rax
      dup(p[0]);
    1280:	8b 45 d0             	mov    -0x30(%rbp),%eax
    1283:	89 c7                	mov    %eax,%edi
    1285:	48 b8 46 26 00 00 00 	movabs $0x2646,%rax
    128c:	00 00 00 
    128f:	ff d0                	callq  *%rax
      close(p[0]);
    1291:	8b 45 d0             	mov    -0x30(%rbp),%eax
    1294:	89 c7                	mov    %eax,%edi
    1296:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    129d:	00 00 00 
    12a0:	ff d0                	callq  *%rax
      close(p[1]);
    12a2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    12a5:	89 c7                	mov    %eax,%edi
    12a7:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    12ae:	00 00 00 
    12b1:	ff d0                	callq  *%rax
      runcmd(pcmd->right);
    12b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12b7:	48 8b 40 10          	mov    0x10(%rax),%rax
    12bb:	48 89 c7             	mov    %rax,%rdi
    12be:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    12c5:	00 00 00 
    12c8:	ff d0                	callq  *%rax
    }
    close(p[0]);
    12ca:	8b 45 d0             	mov    -0x30(%rbp),%eax
    12cd:	89 c7                	mov    %eax,%edi
    12cf:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    12d6:	00 00 00 
    12d9:	ff d0                	callq  *%rax
    close(p[1]);
    12db:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    12de:	89 c7                	mov    %eax,%edi
    12e0:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    12e7:	00 00 00 
    12ea:	ff d0                	callq  *%rax
    wait();
    12ec:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    12f3:	00 00 00 
    12f6:	ff d0                	callq  *%rax
    wait();
    12f8:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    12ff:	00 00 00 
    1302:	ff d0                	callq  *%rax
    break;
    1304:	eb 30                	jmp    1336 <runcmd+0x336>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    1306:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    130a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(fork1() == 0)
    130e:	48 b8 76 15 00 00 00 	movabs $0x1576,%rax
    1315:	00 00 00 
    1318:	ff d0                	callq  *%rax
    131a:	85 c0                	test   %eax,%eax
    131c:	75 17                	jne    1335 <runcmd+0x335>
      runcmd(bcmd->cmd);
    131e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1322:	48 8b 40 08          	mov    0x8(%rax),%rax
    1326:	48 89 c7             	mov    %rax,%rdi
    1329:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1330:	00 00 00 
    1333:	ff d0                	callq  *%rax
    break;
    1335:	90                   	nop
  }
  exit();
    1336:	48 b8 83 25 00 00 00 	movabs $0x2583,%rax
    133d:	00 00 00 
    1340:	ff d0                	callq  *%rax

0000000000001342 <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
    1342:	f3 0f 1e fa          	endbr64 
    1346:	55                   	push   %rbp
    1347:	48 89 e5             	mov    %rsp,%rbp
    134a:	48 83 ec 10          	sub    $0x10,%rsp
    134e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1352:	89 75 f4             	mov    %esi,-0xc(%rbp)
  printf(2, "$ ");
    1355:	48 be e8 33 00 00 00 	movabs $0x33e8,%rsi
    135c:	00 00 00 
    135f:	bf 02 00 00 00       	mov    $0x2,%edi
    1364:	b8 00 00 00 00       	mov    $0x0,%eax
    1369:	48 ba 6d 28 00 00 00 	movabs $0x286d,%rdx
    1370:	00 00 00 
    1373:	ff d2                	callq  *%rdx
  memset(buf, 0, nbuf);
    1375:	8b 55 f4             	mov    -0xc(%rbp),%edx
    1378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    137c:	be 00 00 00 00       	mov    $0x0,%esi
    1381:	48 89 c7             	mov    %rax,%rdi
    1384:	48 b8 4e 23 00 00 00 	movabs $0x234e,%rax
    138b:	00 00 00 
    138e:	ff d0                	callq  *%rax
  gets(buf, nbuf);
    1390:	8b 55 f4             	mov    -0xc(%rbp),%edx
    1393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1397:	89 d6                	mov    %edx,%esi
    1399:	48 89 c7             	mov    %rax,%rdi
    139c:	48 b8 c5 23 00 00 00 	movabs $0x23c5,%rax
    13a3:	00 00 00 
    13a6:	ff d0                	callq  *%rax
  if(buf[0] == 0) // EOF
    13a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13ac:	0f b6 00             	movzbl (%rax),%eax
    13af:	84 c0                	test   %al,%al
    13b1:	75 07                	jne    13ba <getcmd+0x78>
    return -1;
    13b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13b8:	eb 05                	jmp    13bf <getcmd+0x7d>
  return 0;
    13ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13bf:	c9                   	leaveq 
    13c0:	c3                   	retq   

00000000000013c1 <main>:

int
main(void)
{
    13c1:	f3 0f 1e fa          	endbr64 
    13c5:	55                   	push   %rbp
    13c6:	48 89 e5             	mov    %rsp,%rbp
    13c9:	48 83 ec 10          	sub    $0x10,%rsp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    13cd:	eb 19                	jmp    13e8 <main+0x27>
    if(fd >= 3){
    13cf:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
    13d3:	7e 13                	jle    13e8 <main+0x27>
      close(fd);
    13d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13d8:	89 c7                	mov    %eax,%edi
    13da:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    13e1:	00 00 00 
    13e4:	ff d0                	callq  *%rax
      break;
    13e6:	eb 24                	jmp    140c <main+0x4b>
  while((fd = open("console", O_RDWR)) >= 0){
    13e8:	be 02 00 00 00       	mov    $0x2,%esi
    13ed:	48 bf eb 33 00 00 00 	movabs $0x33eb,%rdi
    13f4:	00 00 00 
    13f7:	48 b8 eb 25 00 00 00 	movabs $0x25eb,%rax
    13fe:	00 00 00 
    1401:	ff d0                	callq  *%rax
    1403:	89 45 fc             	mov    %eax,-0x4(%rbp)
    1406:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    140a:	79 c3                	jns    13cf <main+0xe>
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    140c:	e9 f3 00 00 00       	jmpq   1504 <main+0x143>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    1411:	48 b8 20 3b 00 00 00 	movabs $0x3b20,%rax
    1418:	00 00 00 
    141b:	0f b6 00             	movzbl (%rax),%eax
    141e:	3c 63                	cmp    $0x63,%al
    1420:	0f 85 9d 00 00 00    	jne    14c3 <main+0x102>
    1426:	48 b8 20 3b 00 00 00 	movabs $0x3b20,%rax
    142d:	00 00 00 
    1430:	0f b6 40 01          	movzbl 0x1(%rax),%eax
    1434:	3c 64                	cmp    $0x64,%al
    1436:	0f 85 87 00 00 00    	jne    14c3 <main+0x102>
    143c:	48 b8 20 3b 00 00 00 	movabs $0x3b20,%rax
    1443:	00 00 00 
    1446:	0f b6 40 02          	movzbl 0x2(%rax),%eax
    144a:	3c 20                	cmp    $0x20,%al
    144c:	75 75                	jne    14c3 <main+0x102>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
    144e:	48 bf 20 3b 00 00 00 	movabs $0x3b20,%rdi
    1455:	00 00 00 
    1458:	48 b8 18 23 00 00 00 	movabs $0x2318,%rax
    145f:	00 00 00 
    1462:	ff d0                	callq  *%rax
    1464:	8d 50 ff             	lea    -0x1(%rax),%edx
    1467:	48 b8 20 3b 00 00 00 	movabs $0x3b20,%rax
    146e:	00 00 00 
    1471:	89 d2                	mov    %edx,%edx
    1473:	c6 04 10 00          	movb   $0x0,(%rax,%rdx,1)
      if(chdir(buf+3) < 0)
    1477:	48 b8 23 3b 00 00 00 	movabs $0x3b23,%rax
    147e:	00 00 00 
    1481:	48 89 c7             	mov    %rax,%rdi
    1484:	48 b8 39 26 00 00 00 	movabs $0x2639,%rax
    148b:	00 00 00 
    148e:	ff d0                	callq  *%rax
    1490:	85 c0                	test   %eax,%eax
    1492:	79 70                	jns    1504 <main+0x143>
        printf(2, "cannot cd %s\n", buf+3);
    1494:	48 b8 23 3b 00 00 00 	movabs $0x3b23,%rax
    149b:	00 00 00 
    149e:	48 89 c2             	mov    %rax,%rdx
    14a1:	48 be f3 33 00 00 00 	movabs $0x33f3,%rsi
    14a8:	00 00 00 
    14ab:	bf 02 00 00 00       	mov    $0x2,%edi
    14b0:	b8 00 00 00 00       	mov    $0x0,%eax
    14b5:	48 b9 6d 28 00 00 00 	movabs $0x286d,%rcx
    14bc:	00 00 00 
    14bf:	ff d1                	callq  *%rcx
      continue;
    14c1:	eb 41                	jmp    1504 <main+0x143>
    }
    if(fork1() == 0)
    14c3:	48 b8 76 15 00 00 00 	movabs $0x1576,%rax
    14ca:	00 00 00 
    14cd:	ff d0                	callq  *%rax
    14cf:	85 c0                	test   %eax,%eax
    14d1:	75 25                	jne    14f8 <main+0x137>
      runcmd(parsecmd(buf));
    14d3:	48 bf 20 3b 00 00 00 	movabs $0x3b20,%rdi
    14da:	00 00 00 
    14dd:	48 b8 24 1a 00 00 00 	movabs $0x1a24,%rax
    14e4:	00 00 00 
    14e7:	ff d0                	callq  *%rax
    14e9:	48 89 c7             	mov    %rax,%rdi
    14ec:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    14f3:	00 00 00 
    14f6:	ff d0                	callq  *%rax
    wait();
    14f8:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    14ff:	00 00 00 
    1502:	ff d0                	callq  *%rax
  while(getcmd(buf, sizeof(buf)) >= 0){
    1504:	be 64 00 00 00       	mov    $0x64,%esi
    1509:	48 bf 20 3b 00 00 00 	movabs $0x3b20,%rdi
    1510:	00 00 00 
    1513:	48 b8 42 13 00 00 00 	movabs $0x1342,%rax
    151a:	00 00 00 
    151d:	ff d0                	callq  *%rax
    151f:	85 c0                	test   %eax,%eax
    1521:	0f 89 ea fe ff ff    	jns    1411 <main+0x50>
  }
  exit();
    1527:	48 b8 83 25 00 00 00 	movabs $0x2583,%rax
    152e:	00 00 00 
    1531:	ff d0                	callq  *%rax

0000000000001533 <panic>:
}

void
panic(char *s)
{
    1533:	f3 0f 1e fa          	endbr64 
    1537:	55                   	push   %rbp
    1538:	48 89 e5             	mov    %rsp,%rbp
    153b:	48 83 ec 10          	sub    $0x10,%rsp
    153f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  printf(2, "%s\n", s);
    1543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1547:	48 89 c2             	mov    %rax,%rdx
    154a:	48 be 01 34 00 00 00 	movabs $0x3401,%rsi
    1551:	00 00 00 
    1554:	bf 02 00 00 00       	mov    $0x2,%edi
    1559:	b8 00 00 00 00       	mov    $0x0,%eax
    155e:	48 b9 6d 28 00 00 00 	movabs $0x286d,%rcx
    1565:	00 00 00 
    1568:	ff d1                	callq  *%rcx
  exit();
    156a:	48 b8 83 25 00 00 00 	movabs $0x2583,%rax
    1571:	00 00 00 
    1574:	ff d0                	callq  *%rax

0000000000001576 <fork1>:
}

int
fork1(void)
{
    1576:	f3 0f 1e fa          	endbr64 
    157a:	55                   	push   %rbp
    157b:	48 89 e5             	mov    %rsp,%rbp
    157e:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  pid = fork();
    1582:	48 b8 76 25 00 00 00 	movabs $0x2576,%rax
    1589:	00 00 00 
    158c:	ff d0                	callq  *%rax
    158e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(pid == -1)
    1591:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%rbp)
    1595:	75 16                	jne    15ad <fork1+0x37>
    panic("fork");
    1597:	48 bf 05 34 00 00 00 	movabs $0x3405,%rdi
    159e:	00 00 00 
    15a1:	48 b8 33 15 00 00 00 	movabs $0x1533,%rax
    15a8:	00 00 00 
    15ab:	ff d0                	callq  *%rax
  return pid;
    15ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    15b0:	c9                   	leaveq 
    15b1:	c3                   	retq   

00000000000015b2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
    15b2:	f3 0f 1e fa          	endbr64 
    15b6:	55                   	push   %rbp
    15b7:	48 89 e5             	mov    %rsp,%rbp
    15ba:	48 83 ec 10          	sub    $0x10,%rsp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    15be:	bf a8 00 00 00       	mov    $0xa8,%edi
    15c3:	48 b8 32 2e 00 00 00 	movabs $0x2e32,%rax
    15ca:	00 00 00 
    15cd:	ff d0                	callq  *%rax
    15cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(cmd, 0, sizeof(*cmd));
    15d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15d7:	ba a8 00 00 00       	mov    $0xa8,%edx
    15dc:	be 00 00 00 00       	mov    $0x0,%esi
    15e1:	48 89 c7             	mov    %rax,%rdi
    15e4:	48 b8 4e 23 00 00 00 	movabs $0x234e,%rax
    15eb:	00 00 00 
    15ee:	ff d0                	callq  *%rax
  cmd->type = EXEC;
    15f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15f4:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  return (struct cmd*)cmd;
    15fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    15fe:	c9                   	leaveq 
    15ff:	c3                   	retq   

0000000000001600 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
    1600:	f3 0f 1e fa          	endbr64 
    1604:	55                   	push   %rbp
    1605:	48 89 e5             	mov    %rsp,%rbp
    1608:	48 83 ec 30          	sub    $0x30,%rsp
    160c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1610:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1614:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    1618:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
    161b:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    161f:	bf 28 00 00 00       	mov    $0x28,%edi
    1624:	48 b8 32 2e 00 00 00 	movabs $0x2e32,%rax
    162b:	00 00 00 
    162e:	ff d0                	callq  *%rax
    1630:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(cmd, 0, sizeof(*cmd));
    1634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1638:	ba 28 00 00 00       	mov    $0x28,%edx
    163d:	be 00 00 00 00       	mov    $0x0,%esi
    1642:	48 89 c7             	mov    %rax,%rdi
    1645:	48 b8 4e 23 00 00 00 	movabs $0x234e,%rax
    164c:	00 00 00 
    164f:	ff d0                	callq  *%rax
  cmd->type = REDIR;
    1651:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1655:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
  cmd->cmd = subcmd;
    165b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    165f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1663:	48 89 50 08          	mov    %rdx,0x8(%rax)
  cmd->file = file;
    1667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    166b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    166f:	48 89 50 10          	mov    %rdx,0x10(%rax)
  cmd->efile = efile;
    1673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1677:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
    167b:	48 89 50 18          	mov    %rdx,0x18(%rax)
  cmd->mode = mode;
    167f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1683:	8b 55 d4             	mov    -0x2c(%rbp),%edx
    1686:	89 50 20             	mov    %edx,0x20(%rax)
  cmd->fd = fd;
    1689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    168d:	8b 55 d0             	mov    -0x30(%rbp),%edx
    1690:	89 50 24             	mov    %edx,0x24(%rax)
  return (struct cmd*)cmd;
    1693:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1697:	c9                   	leaveq 
    1698:	c3                   	retq   

0000000000001699 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
    1699:	f3 0f 1e fa          	endbr64 
    169d:	55                   	push   %rbp
    169e:	48 89 e5             	mov    %rsp,%rbp
    16a1:	48 83 ec 20          	sub    $0x20,%rsp
    16a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    16a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    16ad:	bf 18 00 00 00       	mov    $0x18,%edi
    16b2:	48 b8 32 2e 00 00 00 	movabs $0x2e32,%rax
    16b9:	00 00 00 
    16bc:	ff d0                	callq  *%rax
    16be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(cmd, 0, sizeof(*cmd));
    16c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    16c6:	ba 18 00 00 00       	mov    $0x18,%edx
    16cb:	be 00 00 00 00       	mov    $0x0,%esi
    16d0:	48 89 c7             	mov    %rax,%rdi
    16d3:	48 b8 4e 23 00 00 00 	movabs $0x234e,%rax
    16da:	00 00 00 
    16dd:	ff d0                	callq  *%rax
  cmd->type = PIPE;
    16df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    16e3:	c7 00 03 00 00 00    	movl   $0x3,(%rax)
  cmd->left = left;
    16e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    16ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    16f1:	48 89 50 08          	mov    %rdx,0x8(%rax)
  cmd->right = right;
    16f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    16f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    16fd:	48 89 50 10          	mov    %rdx,0x10(%rax)
  return (struct cmd*)cmd;
    1701:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1705:	c9                   	leaveq 
    1706:	c3                   	retq   

0000000000001707 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
    1707:	f3 0f 1e fa          	endbr64 
    170b:	55                   	push   %rbp
    170c:	48 89 e5             	mov    %rsp,%rbp
    170f:	48 83 ec 20          	sub    $0x20,%rsp
    1713:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1717:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    171b:	bf 18 00 00 00       	mov    $0x18,%edi
    1720:	48 b8 32 2e 00 00 00 	movabs $0x2e32,%rax
    1727:	00 00 00 
    172a:	ff d0                	callq  *%rax
    172c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(cmd, 0, sizeof(*cmd));
    1730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1734:	ba 18 00 00 00       	mov    $0x18,%edx
    1739:	be 00 00 00 00       	mov    $0x0,%esi
    173e:	48 89 c7             	mov    %rax,%rdi
    1741:	48 b8 4e 23 00 00 00 	movabs $0x234e,%rax
    1748:	00 00 00 
    174b:	ff d0                	callq  *%rax
  cmd->type = LIST;
    174d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1751:	c7 00 04 00 00 00    	movl   $0x4,(%rax)
  cmd->left = left;
    1757:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    175b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    175f:	48 89 50 08          	mov    %rdx,0x8(%rax)
  cmd->right = right;
    1763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1767:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    176b:	48 89 50 10          	mov    %rdx,0x10(%rax)
  return (struct cmd*)cmd;
    176f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1773:	c9                   	leaveq 
    1774:	c3                   	retq   

0000000000001775 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
    1775:	f3 0f 1e fa          	endbr64 
    1779:	55                   	push   %rbp
    177a:	48 89 e5             	mov    %rsp,%rbp
    177d:	48 83 ec 20          	sub    $0x20,%rsp
    1781:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1785:	bf 10 00 00 00       	mov    $0x10,%edi
    178a:	48 b8 32 2e 00 00 00 	movabs $0x2e32,%rax
    1791:	00 00 00 
    1794:	ff d0                	callq  *%rax
    1796:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(cmd, 0, sizeof(*cmd));
    179a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    179e:	ba 10 00 00 00       	mov    $0x10,%edx
    17a3:	be 00 00 00 00       	mov    $0x0,%esi
    17a8:	48 89 c7             	mov    %rax,%rdi
    17ab:	48 b8 4e 23 00 00 00 	movabs $0x234e,%rax
    17b2:	00 00 00 
    17b5:	ff d0                	callq  *%rax
  cmd->type = BACK;
    17b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    17bb:	c7 00 05 00 00 00    	movl   $0x5,(%rax)
  cmd->cmd = subcmd;
    17c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    17c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    17c9:	48 89 50 08          	mov    %rdx,0x8(%rax)
  return (struct cmd*)cmd;
    17cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    17d1:	c9                   	leaveq 
    17d2:	c3                   	retq   

00000000000017d3 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    17d3:	f3 0f 1e fa          	endbr64 
    17d7:	55                   	push   %rbp
    17d8:	48 89 e5             	mov    %rsp,%rbp
    17db:	48 83 ec 30          	sub    $0x30,%rsp
    17df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    17e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    17e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    17eb:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  char *s;
  int ret;

  s = *ps;
    17ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    17f3:	48 8b 00             	mov    (%rax),%rax
    17f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(s < es && strchr(whitespace, *s))
    17fa:	eb 05                	jmp    1801 <gettoken+0x2e>
    s++;
    17fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  while(s < es && strchr(whitespace, *s))
    1801:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1805:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
    1809:	73 27                	jae    1832 <gettoken+0x5f>
    180b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    180f:	0f b6 00             	movzbl (%rax),%eax
    1812:	0f be c0             	movsbl %al,%eax
    1815:	89 c6                	mov    %eax,%esi
    1817:	48 bf e0 3a 00 00 00 	movabs $0x3ae0,%rdi
    181e:	00 00 00 
    1821:	48 b8 85 23 00 00 00 	movabs $0x2385,%rax
    1828:	00 00 00 
    182b:	ff d0                	callq  *%rax
    182d:	48 85 c0             	test   %rax,%rax
    1830:	75 ca                	jne    17fc <gettoken+0x29>
  if(q)
    1832:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
    1837:	74 0b                	je     1844 <gettoken+0x71>
    *q = s;
    1839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    183d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    1841:	48 89 10             	mov    %rdx,(%rax)
  ret = *s;
    1844:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1848:	0f b6 00             	movzbl (%rax),%eax
    184b:	0f be c0             	movsbl %al,%eax
    184e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  switch(*s){
    1851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1855:	0f b6 00             	movzbl (%rax),%eax
    1858:	0f be c0             	movsbl %al,%eax
    185b:	83 f8 7c             	cmp    $0x7c,%eax
    185e:	74 30                	je     1890 <gettoken+0xbd>
    1860:	83 f8 7c             	cmp    $0x7c,%eax
    1863:	7f 53                	jg     18b8 <gettoken+0xe5>
    1865:	83 f8 3e             	cmp    $0x3e,%eax
    1868:	74 30                	je     189a <gettoken+0xc7>
    186a:	83 f8 3e             	cmp    $0x3e,%eax
    186d:	7f 49                	jg     18b8 <gettoken+0xe5>
    186f:	83 f8 3c             	cmp    $0x3c,%eax
    1872:	7f 44                	jg     18b8 <gettoken+0xe5>
    1874:	83 f8 3b             	cmp    $0x3b,%eax
    1877:	7d 17                	jge    1890 <gettoken+0xbd>
    1879:	83 f8 29             	cmp    $0x29,%eax
    187c:	7f 3a                	jg     18b8 <gettoken+0xe5>
    187e:	83 f8 28             	cmp    $0x28,%eax
    1881:	7d 0d                	jge    1890 <gettoken+0xbd>
    1883:	85 c0                	test   %eax,%eax
    1885:	0f 84 95 00 00 00    	je     1920 <gettoken+0x14d>
    188b:	83 f8 26             	cmp    $0x26,%eax
    188e:	75 28                	jne    18b8 <gettoken+0xe5>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    1890:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    break;
    1895:	e9 8d 00 00 00       	jmpq   1927 <gettoken+0x154>
  case '>':
    s++;
    189a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    if(*s == '>'){
    189f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    18a3:	0f b6 00             	movzbl (%rax),%eax
    18a6:	3c 3e                	cmp    $0x3e,%al
    18a8:	75 79                	jne    1923 <gettoken+0x150>
      ret = '+';
    18aa:	c7 45 f4 2b 00 00 00 	movl   $0x2b,-0xc(%rbp)
      s++;
    18b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    }
    break;
    18b6:	eb 6b                	jmp    1923 <gettoken+0x150>
  default:
    ret = 'a';
    18b8:	c7 45 f4 61 00 00 00 	movl   $0x61,-0xc(%rbp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    18bf:	eb 05                	jmp    18c6 <gettoken+0xf3>
      s++;
    18c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    18c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    18ca:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
    18ce:	73 56                	jae    1926 <gettoken+0x153>
    18d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    18d4:	0f b6 00             	movzbl (%rax),%eax
    18d7:	0f be c0             	movsbl %al,%eax
    18da:	89 c6                	mov    %eax,%esi
    18dc:	48 bf e0 3a 00 00 00 	movabs $0x3ae0,%rdi
    18e3:	00 00 00 
    18e6:	48 b8 85 23 00 00 00 	movabs $0x2385,%rax
    18ed:	00 00 00 
    18f0:	ff d0                	callq  *%rax
    18f2:	48 85 c0             	test   %rax,%rax
    18f5:	75 2f                	jne    1926 <gettoken+0x153>
    18f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    18fb:	0f b6 00             	movzbl (%rax),%eax
    18fe:	0f be c0             	movsbl %al,%eax
    1901:	89 c6                	mov    %eax,%esi
    1903:	48 bf e8 3a 00 00 00 	movabs $0x3ae8,%rdi
    190a:	00 00 00 
    190d:	48 b8 85 23 00 00 00 	movabs $0x2385,%rax
    1914:	00 00 00 
    1917:	ff d0                	callq  *%rax
    1919:	48 85 c0             	test   %rax,%rax
    191c:	74 a3                	je     18c1 <gettoken+0xee>
    break;
    191e:	eb 06                	jmp    1926 <gettoken+0x153>
    break;
    1920:	90                   	nop
    1921:	eb 04                	jmp    1927 <gettoken+0x154>
    break;
    1923:	90                   	nop
    1924:	eb 01                	jmp    1927 <gettoken+0x154>
    break;
    1926:	90                   	nop
  }
  if(eq)
    1927:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
    192c:	74 12                	je     1940 <gettoken+0x16d>
    *eq = s;
    192e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1932:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    1936:	48 89 10             	mov    %rdx,(%rax)

  while(s < es && strchr(whitespace, *s))
    1939:	eb 05                	jmp    1940 <gettoken+0x16d>
    s++;
    193b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  while(s < es && strchr(whitespace, *s))
    1940:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1944:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
    1948:	73 27                	jae    1971 <gettoken+0x19e>
    194a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    194e:	0f b6 00             	movzbl (%rax),%eax
    1951:	0f be c0             	movsbl %al,%eax
    1954:	89 c6                	mov    %eax,%esi
    1956:	48 bf e0 3a 00 00 00 	movabs $0x3ae0,%rdi
    195d:	00 00 00 
    1960:	48 b8 85 23 00 00 00 	movabs $0x2385,%rax
    1967:	00 00 00 
    196a:	ff d0                	callq  *%rax
    196c:	48 85 c0             	test   %rax,%rax
    196f:	75 ca                	jne    193b <gettoken+0x168>
  *ps = s;
    1971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1975:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    1979:	48 89 10             	mov    %rdx,(%rax)
  return ret;
    197c:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
    197f:	c9                   	leaveq 
    1980:	c3                   	retq   

0000000000001981 <peek>:

int
peek(char **ps, char *es, char *toks)
{
    1981:	f3 0f 1e fa          	endbr64 
    1985:	55                   	push   %rbp
    1986:	48 89 e5             	mov    %rsp,%rbp
    1989:	48 83 ec 30          	sub    $0x30,%rsp
    198d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1991:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1995:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  char *s;

  s = *ps;
    1999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    199d:	48 8b 00             	mov    (%rax),%rax
    19a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(s < es && strchr(whitespace, *s))
    19a4:	eb 05                	jmp    19ab <peek+0x2a>
    s++;
    19a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  while(s < es && strchr(whitespace, *s))
    19ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    19af:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
    19b3:	73 27                	jae    19dc <peek+0x5b>
    19b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    19b9:	0f b6 00             	movzbl (%rax),%eax
    19bc:	0f be c0             	movsbl %al,%eax
    19bf:	89 c6                	mov    %eax,%esi
    19c1:	48 bf e0 3a 00 00 00 	movabs $0x3ae0,%rdi
    19c8:	00 00 00 
    19cb:	48 b8 85 23 00 00 00 	movabs $0x2385,%rax
    19d2:	00 00 00 
    19d5:	ff d0                	callq  *%rax
    19d7:	48 85 c0             	test   %rax,%rax
    19da:	75 ca                	jne    19a6 <peek+0x25>
  *ps = s;
    19dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    19e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    19e4:	48 89 10             	mov    %rdx,(%rax)
  return *s && strchr(toks, *s);
    19e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    19eb:	0f b6 00             	movzbl (%rax),%eax
    19ee:	84 c0                	test   %al,%al
    19f0:	74 2b                	je     1a1d <peek+0x9c>
    19f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    19f6:	0f b6 00             	movzbl (%rax),%eax
    19f9:	0f be d0             	movsbl %al,%edx
    19fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1a00:	89 d6                	mov    %edx,%esi
    1a02:	48 89 c7             	mov    %rax,%rdi
    1a05:	48 b8 85 23 00 00 00 	movabs $0x2385,%rax
    1a0c:	00 00 00 
    1a0f:	ff d0                	callq  *%rax
    1a11:	48 85 c0             	test   %rax,%rax
    1a14:	74 07                	je     1a1d <peek+0x9c>
    1a16:	b8 01 00 00 00       	mov    $0x1,%eax
    1a1b:	eb 05                	jmp    1a22 <peek+0xa1>
    1a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1a22:	c9                   	leaveq 
    1a23:	c3                   	retq   

0000000000001a24 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
    1a24:	f3 0f 1e fa          	endbr64 
    1a28:	55                   	push   %rbp
    1a29:	48 89 e5             	mov    %rsp,%rbp
    1a2c:	53                   	push   %rbx
    1a2d:	48 83 ec 28          	sub    $0x28,%rsp
    1a31:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
    1a35:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
    1a39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1a3d:	48 89 c7             	mov    %rax,%rdi
    1a40:	48 b8 18 23 00 00 00 	movabs $0x2318,%rax
    1a47:	00 00 00 
    1a4a:	ff d0                	callq  *%rax
    1a4c:	89 c0                	mov    %eax,%eax
    1a4e:	48 01 d8             	add    %rbx,%rax
    1a51:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  cmd = parseline(&s, es);
    1a55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1a59:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
    1a5d:	48 89 d6             	mov    %rdx,%rsi
    1a60:	48 89 c7             	mov    %rax,%rdi
    1a63:	48 b8 fc 1a 00 00 00 	movabs $0x1afc,%rax
    1a6a:	00 00 00 
    1a6d:	ff d0                	callq  *%rax
    1a6f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  peek(&s, es, "");
    1a73:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
    1a77:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
    1a7b:	48 ba 0a 34 00 00 00 	movabs $0x340a,%rdx
    1a82:	00 00 00 
    1a85:	48 89 ce             	mov    %rcx,%rsi
    1a88:	48 89 c7             	mov    %rax,%rdi
    1a8b:	48 b8 81 19 00 00 00 	movabs $0x1981,%rax
    1a92:	00 00 00 
    1a95:	ff d0                	callq  *%rax
  if(s != es){
    1a97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1a9b:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
    1a9f:	74 3d                	je     1ade <parsecmd+0xba>
    printf(2, "leftovers: %s\n", s);
    1aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1aa5:	48 89 c2             	mov    %rax,%rdx
    1aa8:	48 be 0b 34 00 00 00 	movabs $0x340b,%rsi
    1aaf:	00 00 00 
    1ab2:	bf 02 00 00 00       	mov    $0x2,%edi
    1ab7:	b8 00 00 00 00       	mov    $0x0,%eax
    1abc:	48 b9 6d 28 00 00 00 	movabs $0x286d,%rcx
    1ac3:	00 00 00 
    1ac6:	ff d1                	callq  *%rcx
    panic("syntax");
    1ac8:	48 bf 1a 34 00 00 00 	movabs $0x341a,%rdi
    1acf:	00 00 00 
    1ad2:	48 b8 33 15 00 00 00 	movabs $0x1533,%rax
    1ad9:	00 00 00 
    1adc:	ff d0                	callq  *%rax
  }
  nulterminate(cmd);
    1ade:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1ae2:	48 89 c7             	mov    %rax,%rdi
    1ae5:	48 b8 ea 20 00 00 00 	movabs $0x20ea,%rax
    1aec:	00 00 00 
    1aef:	ff d0                	callq  *%rax
  return cmd;
    1af1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
}
    1af5:	48 83 c4 28          	add    $0x28,%rsp
    1af9:	5b                   	pop    %rbx
    1afa:	5d                   	pop    %rbp
    1afb:	c3                   	retq   

0000000000001afc <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
    1afc:	f3 0f 1e fa          	endbr64 
    1b00:	55                   	push   %rbp
    1b01:	48 89 e5             	mov    %rsp,%rbp
    1b04:	48 83 ec 20          	sub    $0x20,%rsp
    1b08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1b0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
    1b10:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1b14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b18:	48 89 d6             	mov    %rdx,%rsi
    1b1b:	48 89 c7             	mov    %rax,%rdi
    1b1e:	48 b8 16 1c 00 00 00 	movabs $0x1c16,%rax
    1b25:	00 00 00 
    1b28:	ff d0                	callq  *%rax
    1b2a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(peek(ps, es, "&")){
    1b2e:	eb 38                	jmp    1b68 <parseline+0x6c>
    gettoken(ps, es, 0, 0);
    1b30:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
    1b34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b38:	b9 00 00 00 00       	mov    $0x0,%ecx
    1b3d:	ba 00 00 00 00       	mov    $0x0,%edx
    1b42:	48 89 c7             	mov    %rax,%rdi
    1b45:	48 b8 d3 17 00 00 00 	movabs $0x17d3,%rax
    1b4c:	00 00 00 
    1b4f:	ff d0                	callq  *%rax
    cmd = backcmd(cmd);
    1b51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b55:	48 89 c7             	mov    %rax,%rdi
    1b58:	48 b8 75 17 00 00 00 	movabs $0x1775,%rax
    1b5f:	00 00 00 
    1b62:	ff d0                	callq  *%rax
    1b64:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(peek(ps, es, "&")){
    1b68:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b70:	48 ba 21 34 00 00 00 	movabs $0x3421,%rdx
    1b77:	00 00 00 
    1b7a:	48 89 ce             	mov    %rcx,%rsi
    1b7d:	48 89 c7             	mov    %rax,%rdi
    1b80:	48 b8 81 19 00 00 00 	movabs $0x1981,%rax
    1b87:	00 00 00 
    1b8a:	ff d0                	callq  *%rax
    1b8c:	85 c0                	test   %eax,%eax
    1b8e:	75 a0                	jne    1b30 <parseline+0x34>
  }
  if(peek(ps, es, ";")){
    1b90:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1b94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b98:	48 ba 23 34 00 00 00 	movabs $0x3423,%rdx
    1b9f:	00 00 00 
    1ba2:	48 89 ce             	mov    %rcx,%rsi
    1ba5:	48 89 c7             	mov    %rax,%rdi
    1ba8:	48 b8 81 19 00 00 00 	movabs $0x1981,%rax
    1baf:	00 00 00 
    1bb2:	ff d0                	callq  *%rax
    1bb4:	85 c0                	test   %eax,%eax
    1bb6:	74 58                	je     1c10 <parseline+0x114>
    gettoken(ps, es, 0, 0);
    1bb8:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
    1bbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bc0:	b9 00 00 00 00       	mov    $0x0,%ecx
    1bc5:	ba 00 00 00 00       	mov    $0x0,%edx
    1bca:	48 89 c7             	mov    %rax,%rdi
    1bcd:	48 b8 d3 17 00 00 00 	movabs $0x17d3,%rax
    1bd4:	00 00 00 
    1bd7:	ff d0                	callq  *%rax
    cmd = listcmd(cmd, parseline(ps, es));
    1bd9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1be1:	48 89 d6             	mov    %rdx,%rsi
    1be4:	48 89 c7             	mov    %rax,%rdi
    1be7:	48 b8 fc 1a 00 00 00 	movabs $0x1afc,%rax
    1bee:	00 00 00 
    1bf1:	ff d0                	callq  *%rax
    1bf3:	48 89 c2             	mov    %rax,%rdx
    1bf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfa:	48 89 d6             	mov    %rdx,%rsi
    1bfd:	48 89 c7             	mov    %rax,%rdi
    1c00:	48 b8 07 17 00 00 00 	movabs $0x1707,%rax
    1c07:	00 00 00 
    1c0a:	ff d0                	callq  *%rax
    1c0c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  return cmd;
    1c10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1c14:	c9                   	leaveq 
    1c15:	c3                   	retq   

0000000000001c16 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
    1c16:	f3 0f 1e fa          	endbr64 
    1c1a:	55                   	push   %rbp
    1c1b:	48 89 e5             	mov    %rsp,%rbp
    1c1e:	48 83 ec 20          	sub    $0x20,%rsp
    1c22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1c26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct cmd *cmd;

  cmd = parseexec(ps, es);
    1c2a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1c2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c32:	48 89 d6             	mov    %rdx,%rsi
    1c35:	48 89 c7             	mov    %rax,%rdi
    1c38:	48 b8 36 1f 00 00 00 	movabs $0x1f36,%rax
    1c3f:	00 00 00 
    1c42:	ff d0                	callq  *%rax
    1c44:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(peek(ps, es, "|")){
    1c48:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c50:	48 ba 25 34 00 00 00 	movabs $0x3425,%rdx
    1c57:	00 00 00 
    1c5a:	48 89 ce             	mov    %rcx,%rsi
    1c5d:	48 89 c7             	mov    %rax,%rdi
    1c60:	48 b8 81 19 00 00 00 	movabs $0x1981,%rax
    1c67:	00 00 00 
    1c6a:	ff d0                	callq  *%rax
    1c6c:	85 c0                	test   %eax,%eax
    1c6e:	74 58                	je     1cc8 <parsepipe+0xb2>
    gettoken(ps, es, 0, 0);
    1c70:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
    1c74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c78:	b9 00 00 00 00       	mov    $0x0,%ecx
    1c7d:	ba 00 00 00 00       	mov    $0x0,%edx
    1c82:	48 89 c7             	mov    %rax,%rdi
    1c85:	48 b8 d3 17 00 00 00 	movabs $0x17d3,%rax
    1c8c:	00 00 00 
    1c8f:	ff d0                	callq  *%rax
    cmd = pipecmd(cmd, parsepipe(ps, es));
    1c91:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1c95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c99:	48 89 d6             	mov    %rdx,%rsi
    1c9c:	48 89 c7             	mov    %rax,%rdi
    1c9f:	48 b8 16 1c 00 00 00 	movabs $0x1c16,%rax
    1ca6:	00 00 00 
    1ca9:	ff d0                	callq  *%rax
    1cab:	48 89 c2             	mov    %rax,%rdx
    1cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb2:	48 89 d6             	mov    %rdx,%rsi
    1cb5:	48 89 c7             	mov    %rax,%rdi
    1cb8:	48 b8 99 16 00 00 00 	movabs $0x1699,%rax
    1cbf:	00 00 00 
    1cc2:	ff d0                	callq  *%rax
    1cc4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  return cmd;
    1cc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1ccc:	c9                   	leaveq 
    1ccd:	c3                   	retq   

0000000000001cce <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
    1cce:	f3 0f 1e fa          	endbr64 
    1cd2:	55                   	push   %rbp
    1cd3:	48 89 e5             	mov    %rsp,%rbp
    1cd6:	48 83 ec 40          	sub    $0x40,%rsp
    1cda:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
    1cde:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    1ce2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    1ce6:	e9 01 01 00 00       	jmpq   1dec <parseredirs+0x11e>
    tok = gettoken(ps, es, 0, 0);
    1ceb:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
    1cef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1cf3:	b9 00 00 00 00       	mov    $0x0,%ecx
    1cf8:	ba 00 00 00 00       	mov    $0x0,%edx
    1cfd:	48 89 c7             	mov    %rax,%rdi
    1d00:	48 b8 d3 17 00 00 00 	movabs $0x17d3,%rax
    1d07:	00 00 00 
    1d0a:	ff d0                	callq  *%rax
    1d0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(gettoken(ps, es, &q, &eq) != 'a')
    1d0f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
    1d13:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
    1d17:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
    1d1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1d1f:	48 89 c7             	mov    %rax,%rdi
    1d22:	48 b8 d3 17 00 00 00 	movabs $0x17d3,%rax
    1d29:	00 00 00 
    1d2c:	ff d0                	callq  *%rax
    1d2e:	83 f8 61             	cmp    $0x61,%eax
    1d31:	74 16                	je     1d49 <parseredirs+0x7b>
      panic("missing file for redirection");
    1d33:	48 bf 27 34 00 00 00 	movabs $0x3427,%rdi
    1d3a:	00 00 00 
    1d3d:	48 b8 33 15 00 00 00 	movabs $0x1533,%rax
    1d44:	00 00 00 
    1d47:	ff d0                	callq  *%rax
    switch(tok){
    1d49:	83 7d fc 3e          	cmpl   $0x3e,-0x4(%rbp)
    1d4d:	74 46                	je     1d95 <parseredirs+0xc7>
    1d4f:	83 7d fc 3e          	cmpl   $0x3e,-0x4(%rbp)
    1d53:	0f 8f 93 00 00 00    	jg     1dec <parseredirs+0x11e>
    1d59:	83 7d fc 2b          	cmpl   $0x2b,-0x4(%rbp)
    1d5d:	74 62                	je     1dc1 <parseredirs+0xf3>
    1d5f:	83 7d fc 3c          	cmpl   $0x3c,-0x4(%rbp)
    1d63:	0f 85 83 00 00 00    	jne    1dec <parseredirs+0x11e>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
    1d69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1d6d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
    1d71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1d75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    1d7b:	b9 00 00 00 00       	mov    $0x0,%ecx
    1d80:	48 89 c7             	mov    %rax,%rdi
    1d83:	48 b8 00 16 00 00 00 	movabs $0x1600,%rax
    1d8a:	00 00 00 
    1d8d:	ff d0                	callq  *%rax
    1d8f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      break;
    1d93:	eb 57                	jmp    1dec <parseredirs+0x11e>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    1d95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1d99:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
    1d9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1da1:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    1da7:	b9 01 02 00 00       	mov    $0x201,%ecx
    1dac:	48 89 c7             	mov    %rax,%rdi
    1daf:	48 b8 00 16 00 00 00 	movabs $0x1600,%rax
    1db6:	00 00 00 
    1db9:	ff d0                	callq  *%rax
    1dbb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      break;
    1dbf:	eb 2b                	jmp    1dec <parseredirs+0x11e>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    1dc1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    1dc5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
    1dc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1dcd:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    1dd3:	b9 01 02 00 00       	mov    $0x201,%ecx
    1dd8:	48 89 c7             	mov    %rax,%rdi
    1ddb:	48 b8 00 16 00 00 00 	movabs $0x1600,%rax
    1de2:	00 00 00 
    1de5:	ff d0                	callq  *%rax
    1de7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      break;
    1deb:	90                   	nop
  while(peek(ps, es, "<>")){
    1dec:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
    1df0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1df4:	48 ba 44 34 00 00 00 	movabs $0x3444,%rdx
    1dfb:	00 00 00 
    1dfe:	48 89 ce             	mov    %rcx,%rsi
    1e01:	48 89 c7             	mov    %rax,%rdi
    1e04:	48 b8 81 19 00 00 00 	movabs $0x1981,%rax
    1e0b:	00 00 00 
    1e0e:	ff d0                	callq  *%rax
    1e10:	85 c0                	test   %eax,%eax
    1e12:	0f 85 d3 fe ff ff    	jne    1ceb <parseredirs+0x1d>
    }
  }
  return cmd;
    1e18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
}
    1e1c:	c9                   	leaveq 
    1e1d:	c3                   	retq   

0000000000001e1e <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
    1e1e:	f3 0f 1e fa          	endbr64 
    1e22:	55                   	push   %rbp
    1e23:	48 89 e5             	mov    %rsp,%rbp
    1e26:	48 83 ec 20          	sub    $0x20,%rsp
    1e2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1e2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    1e32:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1e36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e3a:	48 ba 47 34 00 00 00 	movabs $0x3447,%rdx
    1e41:	00 00 00 
    1e44:	48 89 ce             	mov    %rcx,%rsi
    1e47:	48 89 c7             	mov    %rax,%rdi
    1e4a:	48 b8 81 19 00 00 00 	movabs $0x1981,%rax
    1e51:	00 00 00 
    1e54:	ff d0                	callq  *%rax
    1e56:	85 c0                	test   %eax,%eax
    1e58:	75 16                	jne    1e70 <parseblock+0x52>
    panic("parseblock");
    1e5a:	48 bf 49 34 00 00 00 	movabs $0x3449,%rdi
    1e61:	00 00 00 
    1e64:	48 b8 33 15 00 00 00 	movabs $0x1533,%rax
    1e6b:	00 00 00 
    1e6e:	ff d0                	callq  *%rax
  gettoken(ps, es, 0, 0);
    1e70:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
    1e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e78:	b9 00 00 00 00       	mov    $0x0,%ecx
    1e7d:	ba 00 00 00 00       	mov    $0x0,%edx
    1e82:	48 89 c7             	mov    %rax,%rdi
    1e85:	48 b8 d3 17 00 00 00 	movabs $0x17d3,%rax
    1e8c:	00 00 00 
    1e8f:	ff d0                	callq  *%rax
  cmd = parseline(ps, es);
    1e91:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1e95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1e99:	48 89 d6             	mov    %rdx,%rsi
    1e9c:	48 89 c7             	mov    %rax,%rdi
    1e9f:	48 b8 fc 1a 00 00 00 	movabs $0x1afc,%rax
    1ea6:	00 00 00 
    1ea9:	ff d0                	callq  *%rax
    1eab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(!peek(ps, es, ")"))
    1eaf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1eb7:	48 ba 54 34 00 00 00 	movabs $0x3454,%rdx
    1ebe:	00 00 00 
    1ec1:	48 89 ce             	mov    %rcx,%rsi
    1ec4:	48 89 c7             	mov    %rax,%rdi
    1ec7:	48 b8 81 19 00 00 00 	movabs $0x1981,%rax
    1ece:	00 00 00 
    1ed1:	ff d0                	callq  *%rax
    1ed3:	85 c0                	test   %eax,%eax
    1ed5:	75 16                	jne    1eed <parseblock+0xcf>
    panic("syntax - missing )");
    1ed7:	48 bf 56 34 00 00 00 	movabs $0x3456,%rdi
    1ede:	00 00 00 
    1ee1:	48 b8 33 15 00 00 00 	movabs $0x1533,%rax
    1ee8:	00 00 00 
    1eeb:	ff d0                	callq  *%rax
  gettoken(ps, es, 0, 0);
    1eed:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
    1ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1ef5:	b9 00 00 00 00       	mov    $0x0,%ecx
    1efa:	ba 00 00 00 00       	mov    $0x0,%edx
    1eff:	48 89 c7             	mov    %rax,%rdi
    1f02:	48 b8 d3 17 00 00 00 	movabs $0x17d3,%rax
    1f09:	00 00 00 
    1f0c:	ff d0                	callq  *%rax
  cmd = parseredirs(cmd, ps, es);
    1f0e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1f12:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
    1f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f1a:	48 89 ce             	mov    %rcx,%rsi
    1f1d:	48 89 c7             	mov    %rax,%rdi
    1f20:	48 b8 ce 1c 00 00 00 	movabs $0x1cce,%rax
    1f27:	00 00 00 
    1f2a:	ff d0                	callq  *%rax
    1f2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return cmd;
    1f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1f34:	c9                   	leaveq 
    1f35:	c3                   	retq   

0000000000001f36 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
    1f36:	f3 0f 1e fa          	endbr64 
    1f3a:	55                   	push   %rbp
    1f3b:	48 89 e5             	mov    %rsp,%rbp
    1f3e:	48 83 ec 40          	sub    $0x40,%rsp
    1f42:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
    1f46:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    1f4a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
    1f4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1f52:	48 ba 47 34 00 00 00 	movabs $0x3447,%rdx
    1f59:	00 00 00 
    1f5c:	48 89 ce             	mov    %rcx,%rsi
    1f5f:	48 89 c7             	mov    %rax,%rdi
    1f62:	48 b8 81 19 00 00 00 	movabs $0x1981,%rax
    1f69:	00 00 00 
    1f6c:	ff d0                	callq  *%rax
    1f6e:	85 c0                	test   %eax,%eax
    1f70:	74 1f                	je     1f91 <parseexec+0x5b>
    return parseblock(ps, es);
    1f72:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
    1f76:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1f7a:	48 89 d6             	mov    %rdx,%rsi
    1f7d:	48 89 c7             	mov    %rax,%rdi
    1f80:	48 b8 1e 1e 00 00 00 	movabs $0x1e1e,%rax
    1f87:	00 00 00 
    1f8a:	ff d0                	callq  *%rax
    1f8c:	e9 57 01 00 00       	jmpq   20e8 <parseexec+0x1b2>

  ret = execcmd();
    1f91:	48 b8 b2 15 00 00 00 	movabs $0x15b2,%rax
    1f98:	00 00 00 
    1f9b:	ff d0                	callq  *%rax
    1f9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  cmd = (struct execcmd*)ret;
    1fa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fa5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  argc = 0;
    1fa9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  ret = parseredirs(ret, ps, es);
    1fb0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
    1fb4:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
    1fb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fbc:	48 89 ce             	mov    %rcx,%rsi
    1fbf:	48 89 c7             	mov    %rax,%rdi
    1fc2:	48 b8 ce 1c 00 00 00 	movabs $0x1cce,%rax
    1fc9:	00 00 00 
    1fcc:	ff d0                	callq  *%rax
    1fce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(!peek(ps, es, "|)&;")){
    1fd2:	e9 b4 00 00 00       	jmpq   208b <parseexec+0x155>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
    1fd7:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
    1fdb:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
    1fdf:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
    1fe3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    1fe7:	48 89 c7             	mov    %rax,%rdi
    1fea:	48 b8 d3 17 00 00 00 	movabs $0x17d3,%rax
    1ff1:	00 00 00 
    1ff4:	ff d0                	callq  *%rax
    1ff6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    1ff9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    1ffd:	0f 84 b6 00 00 00    	je     20b9 <parseexec+0x183>
      break;
    if(tok != 'a')
    2003:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
    2007:	74 16                	je     201f <parseexec+0xe9>
      panic("syntax");
    2009:	48 bf 1a 34 00 00 00 	movabs $0x341a,%rdi
    2010:	00 00 00 
    2013:	48 b8 33 15 00 00 00 	movabs $0x1533,%rax
    201a:	00 00 00 
    201d:	ff d0                	callq  *%rax
    cmd->argv[argc] = q;
    201f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
    2023:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2027:	8b 55 fc             	mov    -0x4(%rbp),%edx
    202a:	48 63 d2             	movslq %edx,%rdx
    202d:	48 89 4c d0 08       	mov    %rcx,0x8(%rax,%rdx,8)
    cmd->eargv[argc] = eq;
    2032:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
    2036:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    203a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    203d:	48 63 c9             	movslq %ecx,%rcx
    2040:	48 83 c1 0a          	add    $0xa,%rcx
    2044:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
    argc++;
    2049:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    if(argc >= MAXARGS)
    204d:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
    2051:	7e 16                	jle    2069 <parseexec+0x133>
      panic("too many args");
    2053:	48 bf 69 34 00 00 00 	movabs $0x3469,%rdi
    205a:	00 00 00 
    205d:	48 b8 33 15 00 00 00 	movabs $0x1533,%rax
    2064:	00 00 00 
    2067:	ff d0                	callq  *%rax
    ret = parseredirs(ret, ps, es);
    2069:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
    206d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
    2071:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2075:	48 89 ce             	mov    %rcx,%rsi
    2078:	48 89 c7             	mov    %rax,%rdi
    207b:	48 b8 ce 1c 00 00 00 	movabs $0x1cce,%rax
    2082:	00 00 00 
    2085:	ff d0                	callq  *%rax
    2087:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(!peek(ps, es, "|)&;")){
    208b:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
    208f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    2093:	48 ba 77 34 00 00 00 	movabs $0x3477,%rdx
    209a:	00 00 00 
    209d:	48 89 ce             	mov    %rcx,%rsi
    20a0:	48 89 c7             	mov    %rax,%rdi
    20a3:	48 b8 81 19 00 00 00 	movabs $0x1981,%rax
    20aa:	00 00 00 
    20ad:	ff d0                	callq  *%rax
    20af:	85 c0                	test   %eax,%eax
    20b1:	0f 84 20 ff ff ff    	je     1fd7 <parseexec+0xa1>
    20b7:	eb 01                	jmp    20ba <parseexec+0x184>
      break;
    20b9:	90                   	nop
  }
  cmd->argv[argc] = 0;
    20ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    20be:	8b 55 fc             	mov    -0x4(%rbp),%edx
    20c1:	48 63 d2             	movslq %edx,%rdx
    20c4:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
    20cb:	00 00 
  cmd->eargv[argc] = 0;
    20cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    20d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
    20d4:	48 63 d2             	movslq %edx,%rdx
    20d7:	48 83 c2 0a          	add    $0xa,%rdx
    20db:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
    20e2:	00 00 
  return ret;
    20e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    20e8:	c9                   	leaveq 
    20e9:	c3                   	retq   

00000000000020ea <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
    20ea:	f3 0f 1e fa          	endbr64 
    20ee:	55                   	push   %rbp
    20ef:	48 89 e5             	mov    %rsp,%rbp
    20f2:	48 83 ec 40          	sub    $0x40,%rsp
    20f6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    20fa:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
    20ff:	75 0a                	jne    210b <nulterminate+0x21>
    return 0;
    2101:	b8 00 00 00 00       	mov    $0x0,%eax
    2106:	e9 33 01 00 00       	jmpq   223e <nulterminate+0x154>

  switch(cmd->type){
    210b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    210f:	8b 00                	mov    (%rax),%eax
    2111:	83 f8 05             	cmp    $0x5,%eax
    2114:	0f 87 20 01 00 00    	ja     223a <nulterminate+0x150>
    211a:	89 c0                	mov    %eax,%eax
    211c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    2123:	00 
    2124:	48 b8 80 34 00 00 00 	movabs $0x3480,%rax
    212b:	00 00 00 
    212e:	48 01 d0             	add    %rdx,%rax
    2131:	48 8b 00             	mov    (%rax),%rax
    2134:	3e ff e0             	notrack jmpq *%rax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    2137:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    213b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    for(i=0; ecmd->argv[i]; i++)
    213f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2146:	eb 1a                	jmp    2162 <nulterminate+0x78>
      *ecmd->eargv[i] = 0;
    2148:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    214c:	8b 55 fc             	mov    -0x4(%rbp),%edx
    214f:	48 63 d2             	movslq %edx,%rdx
    2152:	48 83 c2 0a          	add    $0xa,%rdx
    2156:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
    215b:	c6 00 00             	movb   $0x0,(%rax)
    for(i=0; ecmd->argv[i]; i++)
    215e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2162:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    2166:	8b 55 fc             	mov    -0x4(%rbp),%edx
    2169:	48 63 d2             	movslq %edx,%rdx
    216c:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
    2171:	48 85 c0             	test   %rax,%rax
    2174:	75 d2                	jne    2148 <nulterminate+0x5e>
    break;
    2176:	e9 bf 00 00 00       	jmpq   223a <nulterminate+0x150>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    217b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    217f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    nulterminate(rcmd->cmd);
    2183:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    2187:	48 8b 40 08          	mov    0x8(%rax),%rax
    218b:	48 89 c7             	mov    %rax,%rdi
    218e:	48 b8 ea 20 00 00 00 	movabs $0x20ea,%rax
    2195:	00 00 00 
    2198:	ff d0                	callq  *%rax
    *rcmd->efile = 0;
    219a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    219e:	48 8b 40 18          	mov    0x18(%rax),%rax
    21a2:	c6 00 00             	movb   $0x0,(%rax)
    break;
    21a5:	e9 90 00 00 00       	jmpq   223a <nulterminate+0x150>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    21aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    21ae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    nulterminate(pcmd->left);
    21b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    21b6:	48 8b 40 08          	mov    0x8(%rax),%rax
    21ba:	48 89 c7             	mov    %rax,%rdi
    21bd:	48 b8 ea 20 00 00 00 	movabs $0x20ea,%rax
    21c4:	00 00 00 
    21c7:	ff d0                	callq  *%rax
    nulterminate(pcmd->right);
    21c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    21cd:	48 8b 40 10          	mov    0x10(%rax),%rax
    21d1:	48 89 c7             	mov    %rax,%rdi
    21d4:	48 b8 ea 20 00 00 00 	movabs $0x20ea,%rax
    21db:	00 00 00 
    21de:	ff d0                	callq  *%rax
    break;
    21e0:	eb 58                	jmp    223a <nulterminate+0x150>

  case LIST:
    lcmd = (struct listcmd*)cmd;
    21e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    21e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    nulterminate(lcmd->left);
    21ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    21ee:	48 8b 40 08          	mov    0x8(%rax),%rax
    21f2:	48 89 c7             	mov    %rax,%rdi
    21f5:	48 b8 ea 20 00 00 00 	movabs $0x20ea,%rax
    21fc:	00 00 00 
    21ff:	ff d0                	callq  *%rax
    nulterminate(lcmd->right);
    2201:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2205:	48 8b 40 10          	mov    0x10(%rax),%rax
    2209:	48 89 c7             	mov    %rax,%rdi
    220c:	48 b8 ea 20 00 00 00 	movabs $0x20ea,%rax
    2213:	00 00 00 
    2216:	ff d0                	callq  *%rax
    break;
    2218:	eb 20                	jmp    223a <nulterminate+0x150>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    221a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    221e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    nulterminate(bcmd->cmd);
    2222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2226:	48 8b 40 08          	mov    0x8(%rax),%rax
    222a:	48 89 c7             	mov    %rax,%rdi
    222d:	48 b8 ea 20 00 00 00 	movabs $0x20ea,%rax
    2234:	00 00 00 
    2237:	ff d0                	callq  *%rax
    break;
    2239:	90                   	nop
  }
  return cmd;
    223a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
    223e:	c9                   	leaveq 
    223f:	c3                   	retq   

0000000000002240 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    2240:	f3 0f 1e fa          	endbr64 
    2244:	55                   	push   %rbp
    2245:	48 89 e5             	mov    %rsp,%rbp
    2248:	48 83 ec 10          	sub    $0x10,%rsp
    224c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    2250:	89 75 f4             	mov    %esi,-0xc(%rbp)
    2253:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    2256:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    225a:	8b 55 f0             	mov    -0x10(%rbp),%edx
    225d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2260:	48 89 ce             	mov    %rcx,%rsi
    2263:	48 89 f7             	mov    %rsi,%rdi
    2266:	89 d1                	mov    %edx,%ecx
    2268:	fc                   	cld    
    2269:	f3 aa                	rep stos %al,%es:(%rdi)
    226b:	89 ca                	mov    %ecx,%edx
    226d:	48 89 fe             	mov    %rdi,%rsi
    2270:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    2274:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    2277:	90                   	nop
    2278:	c9                   	leaveq 
    2279:	c3                   	retq   

000000000000227a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    227a:	f3 0f 1e fa          	endbr64 
    227e:	55                   	push   %rbp
    227f:	48 89 e5             	mov    %rsp,%rbp
    2282:	48 83 ec 20          	sub    $0x20,%rsp
    2286:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    228a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    228e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2292:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    2296:	90                   	nop
    2297:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    229b:	48 8d 42 01          	lea    0x1(%rdx),%rax
    229f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    22a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    22a7:	48 8d 48 01          	lea    0x1(%rax),%rcx
    22ab:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    22af:	0f b6 12             	movzbl (%rdx),%edx
    22b2:	88 10                	mov    %dl,(%rax)
    22b4:	0f b6 00             	movzbl (%rax),%eax
    22b7:	84 c0                	test   %al,%al
    22b9:	75 dc                	jne    2297 <strcpy+0x1d>
    ;
  return os;
    22bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    22bf:	c9                   	leaveq 
    22c0:	c3                   	retq   

00000000000022c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    22c1:	f3 0f 1e fa          	endbr64 
    22c5:	55                   	push   %rbp
    22c6:	48 89 e5             	mov    %rsp,%rbp
    22c9:	48 83 ec 10          	sub    $0x10,%rsp
    22cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    22d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    22d5:	eb 0a                	jmp    22e1 <strcmp+0x20>
    p++, q++;
    22d7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    22dc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    22e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22e5:	0f b6 00             	movzbl (%rax),%eax
    22e8:	84 c0                	test   %al,%al
    22ea:	74 12                	je     22fe <strcmp+0x3d>
    22ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22f0:	0f b6 10             	movzbl (%rax),%edx
    22f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    22f7:	0f b6 00             	movzbl (%rax),%eax
    22fa:	38 c2                	cmp    %al,%dl
    22fc:	74 d9                	je     22d7 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    22fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2302:	0f b6 00             	movzbl (%rax),%eax
    2305:	0f b6 d0             	movzbl %al,%edx
    2308:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    230c:	0f b6 00             	movzbl (%rax),%eax
    230f:	0f b6 c0             	movzbl %al,%eax
    2312:	29 c2                	sub    %eax,%edx
    2314:	89 d0                	mov    %edx,%eax
}
    2316:	c9                   	leaveq 
    2317:	c3                   	retq   

0000000000002318 <strlen>:

uint
strlen(char *s)
{
    2318:	f3 0f 1e fa          	endbr64 
    231c:	55                   	push   %rbp
    231d:	48 89 e5             	mov    %rsp,%rbp
    2320:	48 83 ec 18          	sub    $0x18,%rsp
    2324:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    2328:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    232f:	eb 04                	jmp    2335 <strlen+0x1d>
    2331:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2335:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2338:	48 63 d0             	movslq %eax,%rdx
    233b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    233f:	48 01 d0             	add    %rdx,%rax
    2342:	0f b6 00             	movzbl (%rax),%eax
    2345:	84 c0                	test   %al,%al
    2347:	75 e8                	jne    2331 <strlen+0x19>
    ;
  return n;
    2349:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    234c:	c9                   	leaveq 
    234d:	c3                   	retq   

000000000000234e <memset>:

void*
memset(void *dst, int c, uint n)
{
    234e:	f3 0f 1e fa          	endbr64 
    2352:	55                   	push   %rbp
    2353:	48 89 e5             	mov    %rsp,%rbp
    2356:	48 83 ec 10          	sub    $0x10,%rsp
    235a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    235e:	89 75 f4             	mov    %esi,-0xc(%rbp)
    2361:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    2364:	8b 55 f0             	mov    -0x10(%rbp),%edx
    2367:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    236a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    236e:	89 ce                	mov    %ecx,%esi
    2370:	48 89 c7             	mov    %rax,%rdi
    2373:	48 b8 40 22 00 00 00 	movabs $0x2240,%rax
    237a:	00 00 00 
    237d:	ff d0                	callq  *%rax
  return dst;
    237f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    2383:	c9                   	leaveq 
    2384:	c3                   	retq   

0000000000002385 <strchr>:

char*
strchr(const char *s, char c)
{
    2385:	f3 0f 1e fa          	endbr64 
    2389:	55                   	push   %rbp
    238a:	48 89 e5             	mov    %rsp,%rbp
    238d:	48 83 ec 10          	sub    $0x10,%rsp
    2391:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    2395:	89 f0                	mov    %esi,%eax
    2397:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    239a:	eb 17                	jmp    23b3 <strchr+0x2e>
    if(*s == c)
    239c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    23a0:	0f b6 00             	movzbl (%rax),%eax
    23a3:	38 45 f4             	cmp    %al,-0xc(%rbp)
    23a6:	75 06                	jne    23ae <strchr+0x29>
      return (char*)s;
    23a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    23ac:	eb 15                	jmp    23c3 <strchr+0x3e>
  for(; *s; s++)
    23ae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    23b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    23b7:	0f b6 00             	movzbl (%rax),%eax
    23ba:	84 c0                	test   %al,%al
    23bc:	75 de                	jne    239c <strchr+0x17>
  return 0;
    23be:	b8 00 00 00 00       	mov    $0x0,%eax
}
    23c3:	c9                   	leaveq 
    23c4:	c3                   	retq   

00000000000023c5 <gets>:

char*
gets(char *buf, int max)
{
    23c5:	f3 0f 1e fa          	endbr64 
    23c9:	55                   	push   %rbp
    23ca:	48 89 e5             	mov    %rsp,%rbp
    23cd:	48 83 ec 20          	sub    $0x20,%rsp
    23d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    23d5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    23d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    23df:	eb 4f                	jmp    2430 <gets+0x6b>
    cc = read(0, &c, 1);
    23e1:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    23e5:	ba 01 00 00 00       	mov    $0x1,%edx
    23ea:	48 89 c6             	mov    %rax,%rsi
    23ed:	bf 00 00 00 00       	mov    $0x0,%edi
    23f2:	48 b8 aa 25 00 00 00 	movabs $0x25aa,%rax
    23f9:	00 00 00 
    23fc:	ff d0                	callq  *%rax
    23fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    2401:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    2405:	7e 36                	jle    243d <gets+0x78>
      break;
    buf[i++] = c;
    2407:	8b 45 fc             	mov    -0x4(%rbp),%eax
    240a:	8d 50 01             	lea    0x1(%rax),%edx
    240d:	89 55 fc             	mov    %edx,-0x4(%rbp)
    2410:	48 63 d0             	movslq %eax,%rdx
    2413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2417:	48 01 c2             	add    %rax,%rdx
    241a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    241e:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    2420:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    2424:	3c 0a                	cmp    $0xa,%al
    2426:	74 16                	je     243e <gets+0x79>
    2428:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    242c:	3c 0d                	cmp    $0xd,%al
    242e:	74 0e                	je     243e <gets+0x79>
  for(i=0; i+1 < max; ){
    2430:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2433:	83 c0 01             	add    $0x1,%eax
    2436:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    2439:	7f a6                	jg     23e1 <gets+0x1c>
    243b:	eb 01                	jmp    243e <gets+0x79>
      break;
    243d:	90                   	nop
      break;
  }
  buf[i] = '\0';
    243e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2441:	48 63 d0             	movslq %eax,%rdx
    2444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2448:	48 01 d0             	add    %rdx,%rax
    244b:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    244e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    2452:	c9                   	leaveq 
    2453:	c3                   	retq   

0000000000002454 <stat>:

int
stat(char *n, struct stat *st)
{
    2454:	f3 0f 1e fa          	endbr64 
    2458:	55                   	push   %rbp
    2459:	48 89 e5             	mov    %rsp,%rbp
    245c:	48 83 ec 20          	sub    $0x20,%rsp
    2460:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    2464:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    246c:	be 00 00 00 00       	mov    $0x0,%esi
    2471:	48 89 c7             	mov    %rax,%rdi
    2474:	48 b8 eb 25 00 00 00 	movabs $0x25eb,%rax
    247b:	00 00 00 
    247e:	ff d0                	callq  *%rax
    2480:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    2483:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2487:	79 07                	jns    2490 <stat+0x3c>
    return -1;
    2489:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    248e:	eb 2f                	jmp    24bf <stat+0x6b>
  r = fstat(fd, st);
    2490:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    2494:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2497:	48 89 d6             	mov    %rdx,%rsi
    249a:	89 c7                	mov    %eax,%edi
    249c:	48 b8 12 26 00 00 00 	movabs $0x2612,%rax
    24a3:	00 00 00 
    24a6:	ff d0                	callq  *%rax
    24a8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    24ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
    24ae:	89 c7                	mov    %eax,%edi
    24b0:	48 b8 c4 25 00 00 00 	movabs $0x25c4,%rax
    24b7:	00 00 00 
    24ba:	ff d0                	callq  *%rax
  return r;
    24bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    24bf:	c9                   	leaveq 
    24c0:	c3                   	retq   

00000000000024c1 <atoi>:

int
atoi(const char *s)
{
    24c1:	f3 0f 1e fa          	endbr64 
    24c5:	55                   	push   %rbp
    24c6:	48 89 e5             	mov    %rsp,%rbp
    24c9:	48 83 ec 18          	sub    $0x18,%rsp
    24cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    24d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    24d8:	eb 28                	jmp    2502 <atoi+0x41>
    n = n*10 + *s++ - '0';
    24da:	8b 55 fc             	mov    -0x4(%rbp),%edx
    24dd:	89 d0                	mov    %edx,%eax
    24df:	c1 e0 02             	shl    $0x2,%eax
    24e2:	01 d0                	add    %edx,%eax
    24e4:	01 c0                	add    %eax,%eax
    24e6:	89 c1                	mov    %eax,%ecx
    24e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    24ec:	48 8d 50 01          	lea    0x1(%rax),%rdx
    24f0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    24f4:	0f b6 00             	movzbl (%rax),%eax
    24f7:	0f be c0             	movsbl %al,%eax
    24fa:	01 c8                	add    %ecx,%eax
    24fc:	83 e8 30             	sub    $0x30,%eax
    24ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    2502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2506:	0f b6 00             	movzbl (%rax),%eax
    2509:	3c 2f                	cmp    $0x2f,%al
    250b:	7e 0b                	jle    2518 <atoi+0x57>
    250d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2511:	0f b6 00             	movzbl (%rax),%eax
    2514:	3c 39                	cmp    $0x39,%al
    2516:	7e c2                	jle    24da <atoi+0x19>
  return n;
    2518:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    251b:	c9                   	leaveq 
    251c:	c3                   	retq   

000000000000251d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    251d:	f3 0f 1e fa          	endbr64 
    2521:	55                   	push   %rbp
    2522:	48 89 e5             	mov    %rsp,%rbp
    2525:	48 83 ec 28          	sub    $0x28,%rsp
    2529:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    252d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    2531:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    2534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2538:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    253c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    2540:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    2544:	eb 1d                	jmp    2563 <memmove+0x46>
    *dst++ = *src++;
    2546:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    254a:	48 8d 42 01          	lea    0x1(%rdx),%rax
    254e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    2552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2556:	48 8d 48 01          	lea    0x1(%rax),%rcx
    255a:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    255e:	0f b6 12             	movzbl (%rdx),%edx
    2561:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    2563:	8b 45 dc             	mov    -0x24(%rbp),%eax
    2566:	8d 50 ff             	lea    -0x1(%rax),%edx
    2569:	89 55 dc             	mov    %edx,-0x24(%rbp)
    256c:	85 c0                	test   %eax,%eax
    256e:	7f d6                	jg     2546 <memmove+0x29>
  return vdst;
    2570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    2574:	c9                   	leaveq 
    2575:	c3                   	retq   

0000000000002576 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    2576:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    257d:	49 89 ca             	mov    %rcx,%r10
    2580:	0f 05                	syscall 
    2582:	c3                   	retq   

0000000000002583 <exit>:
SYSCALL(exit)
    2583:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    258a:	49 89 ca             	mov    %rcx,%r10
    258d:	0f 05                	syscall 
    258f:	c3                   	retq   

0000000000002590 <wait>:
SYSCALL(wait)
    2590:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    2597:	49 89 ca             	mov    %rcx,%r10
    259a:	0f 05                	syscall 
    259c:	c3                   	retq   

000000000000259d <pipe>:
SYSCALL(pipe)
    259d:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    25a4:	49 89 ca             	mov    %rcx,%r10
    25a7:	0f 05                	syscall 
    25a9:	c3                   	retq   

00000000000025aa <read>:
SYSCALL(read)
    25aa:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    25b1:	49 89 ca             	mov    %rcx,%r10
    25b4:	0f 05                	syscall 
    25b6:	c3                   	retq   

00000000000025b7 <write>:
SYSCALL(write)
    25b7:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    25be:	49 89 ca             	mov    %rcx,%r10
    25c1:	0f 05                	syscall 
    25c3:	c3                   	retq   

00000000000025c4 <close>:
SYSCALL(close)
    25c4:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    25cb:	49 89 ca             	mov    %rcx,%r10
    25ce:	0f 05                	syscall 
    25d0:	c3                   	retq   

00000000000025d1 <kill>:
SYSCALL(kill)
    25d1:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    25d8:	49 89 ca             	mov    %rcx,%r10
    25db:	0f 05                	syscall 
    25dd:	c3                   	retq   

00000000000025de <exec>:
SYSCALL(exec)
    25de:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    25e5:	49 89 ca             	mov    %rcx,%r10
    25e8:	0f 05                	syscall 
    25ea:	c3                   	retq   

00000000000025eb <open>:
SYSCALL(open)
    25eb:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    25f2:	49 89 ca             	mov    %rcx,%r10
    25f5:	0f 05                	syscall 
    25f7:	c3                   	retq   

00000000000025f8 <mknod>:
SYSCALL(mknod)
    25f8:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    25ff:	49 89 ca             	mov    %rcx,%r10
    2602:	0f 05                	syscall 
    2604:	c3                   	retq   

0000000000002605 <unlink>:
SYSCALL(unlink)
    2605:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    260c:	49 89 ca             	mov    %rcx,%r10
    260f:	0f 05                	syscall 
    2611:	c3                   	retq   

0000000000002612 <fstat>:
SYSCALL(fstat)
    2612:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    2619:	49 89 ca             	mov    %rcx,%r10
    261c:	0f 05                	syscall 
    261e:	c3                   	retq   

000000000000261f <link>:
SYSCALL(link)
    261f:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    2626:	49 89 ca             	mov    %rcx,%r10
    2629:	0f 05                	syscall 
    262b:	c3                   	retq   

000000000000262c <mkdir>:
SYSCALL(mkdir)
    262c:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    2633:	49 89 ca             	mov    %rcx,%r10
    2636:	0f 05                	syscall 
    2638:	c3                   	retq   

0000000000002639 <chdir>:
SYSCALL(chdir)
    2639:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    2640:	49 89 ca             	mov    %rcx,%r10
    2643:	0f 05                	syscall 
    2645:	c3                   	retq   

0000000000002646 <dup>:
SYSCALL(dup)
    2646:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    264d:	49 89 ca             	mov    %rcx,%r10
    2650:	0f 05                	syscall 
    2652:	c3                   	retq   

0000000000002653 <getpid>:
SYSCALL(getpid)
    2653:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    265a:	49 89 ca             	mov    %rcx,%r10
    265d:	0f 05                	syscall 
    265f:	c3                   	retq   

0000000000002660 <sbrk>:
SYSCALL(sbrk)
    2660:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    2667:	49 89 ca             	mov    %rcx,%r10
    266a:	0f 05                	syscall 
    266c:	c3                   	retq   

000000000000266d <sleep>:
SYSCALL(sleep)
    266d:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    2674:	49 89 ca             	mov    %rcx,%r10
    2677:	0f 05                	syscall 
    2679:	c3                   	retq   

000000000000267a <uptime>:
SYSCALL(uptime)
    267a:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    2681:	49 89 ca             	mov    %rcx,%r10
    2684:	0f 05                	syscall 
    2686:	c3                   	retq   

0000000000002687 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    2687:	f3 0f 1e fa          	endbr64 
    268b:	55                   	push   %rbp
    268c:	48 89 e5             	mov    %rsp,%rbp
    268f:	48 83 ec 10          	sub    $0x10,%rsp
    2693:	89 7d fc             	mov    %edi,-0x4(%rbp)
    2696:	89 f0                	mov    %esi,%eax
    2698:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    269b:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    269f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    26a2:	ba 01 00 00 00       	mov    $0x1,%edx
    26a7:	48 89 ce             	mov    %rcx,%rsi
    26aa:	89 c7                	mov    %eax,%edi
    26ac:	48 b8 b7 25 00 00 00 	movabs $0x25b7,%rax
    26b3:	00 00 00 
    26b6:	ff d0                	callq  *%rax
}
    26b8:	90                   	nop
    26b9:	c9                   	leaveq 
    26ba:	c3                   	retq   

00000000000026bb <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    26bb:	f3 0f 1e fa          	endbr64 
    26bf:	55                   	push   %rbp
    26c0:	48 89 e5             	mov    %rsp,%rbp
    26c3:	48 83 ec 20          	sub    $0x20,%rsp
    26c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
    26ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    26ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    26d5:	eb 35                	jmp    270c <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    26d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    26db:	48 c1 e8 3c          	shr    $0x3c,%rax
    26df:	48 ba f0 3a 00 00 00 	movabs $0x3af0,%rdx
    26e6:	00 00 00 
    26e9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    26ed:	0f be d0             	movsbl %al,%edx
    26f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
    26f3:	89 d6                	mov    %edx,%esi
    26f5:	89 c7                	mov    %eax,%edi
    26f7:	48 b8 87 26 00 00 00 	movabs $0x2687,%rax
    26fe:	00 00 00 
    2701:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    2703:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2707:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    270c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    270f:	83 f8 0f             	cmp    $0xf,%eax
    2712:	76 c3                	jbe    26d7 <print_x64+0x1c>
}
    2714:	90                   	nop
    2715:	90                   	nop
    2716:	c9                   	leaveq 
    2717:	c3                   	retq   

0000000000002718 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    2718:	f3 0f 1e fa          	endbr64 
    271c:	55                   	push   %rbp
    271d:	48 89 e5             	mov    %rsp,%rbp
    2720:	48 83 ec 20          	sub    $0x20,%rsp
    2724:	89 7d ec             	mov    %edi,-0x14(%rbp)
    2727:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    272a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2731:	eb 36                	jmp    2769 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    2733:	8b 45 e8             	mov    -0x18(%rbp),%eax
    2736:	c1 e8 1c             	shr    $0x1c,%eax
    2739:	89 c2                	mov    %eax,%edx
    273b:	48 b8 f0 3a 00 00 00 	movabs $0x3af0,%rax
    2742:	00 00 00 
    2745:	89 d2                	mov    %edx,%edx
    2747:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    274b:	0f be d0             	movsbl %al,%edx
    274e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2751:	89 d6                	mov    %edx,%esi
    2753:	89 c7                	mov    %eax,%edi
    2755:	48 b8 87 26 00 00 00 	movabs $0x2687,%rax
    275c:	00 00 00 
    275f:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    2761:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2765:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    2769:	8b 45 fc             	mov    -0x4(%rbp),%eax
    276c:	83 f8 07             	cmp    $0x7,%eax
    276f:	76 c2                	jbe    2733 <print_x32+0x1b>
}
    2771:	90                   	nop
    2772:	90                   	nop
    2773:	c9                   	leaveq 
    2774:	c3                   	retq   

0000000000002775 <print_d>:

  static void
print_d(int fd, int v)
{
    2775:	f3 0f 1e fa          	endbr64 
    2779:	55                   	push   %rbp
    277a:	48 89 e5             	mov    %rsp,%rbp
    277d:	48 83 ec 30          	sub    $0x30,%rsp
    2781:	89 7d dc             	mov    %edi,-0x24(%rbp)
    2784:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    2787:	8b 45 d8             	mov    -0x28(%rbp),%eax
    278a:	48 98                	cltq   
    278c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    2790:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    2794:	79 04                	jns    279a <print_d+0x25>
    x = -x;
    2796:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    279a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    27a1:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    27a5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    27ac:	66 66 66 
    27af:	48 89 c8             	mov    %rcx,%rax
    27b2:	48 f7 ea             	imul   %rdx
    27b5:	48 c1 fa 02          	sar    $0x2,%rdx
    27b9:	48 89 c8             	mov    %rcx,%rax
    27bc:	48 c1 f8 3f          	sar    $0x3f,%rax
    27c0:	48 29 c2             	sub    %rax,%rdx
    27c3:	48 89 d0             	mov    %rdx,%rax
    27c6:	48 c1 e0 02          	shl    $0x2,%rax
    27ca:	48 01 d0             	add    %rdx,%rax
    27cd:	48 01 c0             	add    %rax,%rax
    27d0:	48 29 c1             	sub    %rax,%rcx
    27d3:	48 89 ca             	mov    %rcx,%rdx
    27d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
    27d9:	8d 48 01             	lea    0x1(%rax),%ecx
    27dc:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    27df:	48 b9 f0 3a 00 00 00 	movabs $0x3af0,%rcx
    27e6:	00 00 00 
    27e9:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    27ed:	48 98                	cltq   
    27ef:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    27f3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    27f7:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    27fe:	66 66 66 
    2801:	48 89 c8             	mov    %rcx,%rax
    2804:	48 f7 ea             	imul   %rdx
    2807:	48 c1 fa 02          	sar    $0x2,%rdx
    280b:	48 89 c8             	mov    %rcx,%rax
    280e:	48 c1 f8 3f          	sar    $0x3f,%rax
    2812:	48 29 c2             	sub    %rax,%rdx
    2815:	48 89 d0             	mov    %rdx,%rax
    2818:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    281c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2821:	0f 85 7a ff ff ff    	jne    27a1 <print_d+0x2c>

  if (v < 0)
    2827:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    282b:	79 32                	jns    285f <print_d+0xea>
    buf[i++] = '-';
    282d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2830:	8d 50 01             	lea    0x1(%rax),%edx
    2833:	89 55 f4             	mov    %edx,-0xc(%rbp)
    2836:	48 98                	cltq   
    2838:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    283d:	eb 20                	jmp    285f <print_d+0xea>
    putc(fd, buf[i]);
    283f:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2842:	48 98                	cltq   
    2844:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    2849:	0f be d0             	movsbl %al,%edx
    284c:	8b 45 dc             	mov    -0x24(%rbp),%eax
    284f:	89 d6                	mov    %edx,%esi
    2851:	89 c7                	mov    %eax,%edi
    2853:	48 b8 87 26 00 00 00 	movabs $0x2687,%rax
    285a:	00 00 00 
    285d:	ff d0                	callq  *%rax
  while (--i >= 0)
    285f:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    2863:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2867:	79 d6                	jns    283f <print_d+0xca>
}
    2869:	90                   	nop
    286a:	90                   	nop
    286b:	c9                   	leaveq 
    286c:	c3                   	retq   

000000000000286d <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    286d:	f3 0f 1e fa          	endbr64 
    2871:	55                   	push   %rbp
    2872:	48 89 e5             	mov    %rsp,%rbp
    2875:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    287c:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    2882:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    2889:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    2890:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    2897:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    289e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    28a5:	84 c0                	test   %al,%al
    28a7:	74 20                	je     28c9 <printf+0x5c>
    28a9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    28ad:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    28b1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    28b5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    28b9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    28bd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    28c1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    28c5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    28c9:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    28d0:	00 00 00 
    28d3:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    28da:	00 00 00 
    28dd:	48 8d 45 10          	lea    0x10(%rbp),%rax
    28e1:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    28e8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    28ef:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    28f6:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    28fd:	00 00 00 
    2900:	e9 41 03 00 00       	jmpq   2c46 <printf+0x3d9>
    if (c != '%') {
    2905:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    290c:	74 24                	je     2932 <printf+0xc5>
      putc(fd, c);
    290e:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    2914:	0f be d0             	movsbl %al,%edx
    2917:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    291d:	89 d6                	mov    %edx,%esi
    291f:	89 c7                	mov    %eax,%edi
    2921:	48 b8 87 26 00 00 00 	movabs $0x2687,%rax
    2928:	00 00 00 
    292b:	ff d0                	callq  *%rax
      continue;
    292d:	e9 0d 03 00 00       	jmpq   2c3f <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    2932:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    2939:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    293f:	48 63 d0             	movslq %eax,%rdx
    2942:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    2949:	48 01 d0             	add    %rdx,%rax
    294c:	0f b6 00             	movzbl (%rax),%eax
    294f:	0f be c0             	movsbl %al,%eax
    2952:	25 ff 00 00 00       	and    $0xff,%eax
    2957:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    295d:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    2964:	0f 84 0f 03 00 00    	je     2c79 <printf+0x40c>
      break;
    switch(c) {
    296a:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    2971:	0f 84 74 02 00 00    	je     2beb <printf+0x37e>
    2977:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    297e:	0f 8c 82 02 00 00    	jl     2c06 <printf+0x399>
    2984:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    298b:	0f 8f 75 02 00 00    	jg     2c06 <printf+0x399>
    2991:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    2998:	0f 8c 68 02 00 00    	jl     2c06 <printf+0x399>
    299e:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    29a4:	83 e8 63             	sub    $0x63,%eax
    29a7:	83 f8 15             	cmp    $0x15,%eax
    29aa:	0f 87 56 02 00 00    	ja     2c06 <printf+0x399>
    29b0:	89 c0                	mov    %eax,%eax
    29b2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    29b9:	00 
    29ba:	48 b8 b8 34 00 00 00 	movabs $0x34b8,%rax
    29c1:	00 00 00 
    29c4:	48 01 d0             	add    %rdx,%rax
    29c7:	48 8b 00             	mov    (%rax),%rax
    29ca:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    29cd:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    29d3:	83 f8 2f             	cmp    $0x2f,%eax
    29d6:	77 23                	ja     29fb <printf+0x18e>
    29d8:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    29df:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    29e5:	89 d2                	mov    %edx,%edx
    29e7:	48 01 d0             	add    %rdx,%rax
    29ea:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    29f0:	83 c2 08             	add    $0x8,%edx
    29f3:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    29f9:	eb 12                	jmp    2a0d <printf+0x1a0>
    29fb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2a02:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2a06:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2a0d:	8b 00                	mov    (%rax),%eax
    2a0f:	0f be d0             	movsbl %al,%edx
    2a12:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2a18:	89 d6                	mov    %edx,%esi
    2a1a:	89 c7                	mov    %eax,%edi
    2a1c:	48 b8 87 26 00 00 00 	movabs $0x2687,%rax
    2a23:	00 00 00 
    2a26:	ff d0                	callq  *%rax
      break;
    2a28:	e9 12 02 00 00       	jmpq   2c3f <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    2a2d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2a33:	83 f8 2f             	cmp    $0x2f,%eax
    2a36:	77 23                	ja     2a5b <printf+0x1ee>
    2a38:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2a3f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2a45:	89 d2                	mov    %edx,%edx
    2a47:	48 01 d0             	add    %rdx,%rax
    2a4a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2a50:	83 c2 08             	add    $0x8,%edx
    2a53:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2a59:	eb 12                	jmp    2a6d <printf+0x200>
    2a5b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2a62:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2a66:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2a6d:	8b 10                	mov    (%rax),%edx
    2a6f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2a75:	89 d6                	mov    %edx,%esi
    2a77:	89 c7                	mov    %eax,%edi
    2a79:	48 b8 75 27 00 00 00 	movabs $0x2775,%rax
    2a80:	00 00 00 
    2a83:	ff d0                	callq  *%rax
      break;
    2a85:	e9 b5 01 00 00       	jmpq   2c3f <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    2a8a:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2a90:	83 f8 2f             	cmp    $0x2f,%eax
    2a93:	77 23                	ja     2ab8 <printf+0x24b>
    2a95:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2a9c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2aa2:	89 d2                	mov    %edx,%edx
    2aa4:	48 01 d0             	add    %rdx,%rax
    2aa7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2aad:	83 c2 08             	add    $0x8,%edx
    2ab0:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2ab6:	eb 12                	jmp    2aca <printf+0x25d>
    2ab8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2abf:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2ac3:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2aca:	8b 10                	mov    (%rax),%edx
    2acc:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2ad2:	89 d6                	mov    %edx,%esi
    2ad4:	89 c7                	mov    %eax,%edi
    2ad6:	48 b8 18 27 00 00 00 	movabs $0x2718,%rax
    2add:	00 00 00 
    2ae0:	ff d0                	callq  *%rax
      break;
    2ae2:	e9 58 01 00 00       	jmpq   2c3f <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    2ae7:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2aed:	83 f8 2f             	cmp    $0x2f,%eax
    2af0:	77 23                	ja     2b15 <printf+0x2a8>
    2af2:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2af9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2aff:	89 d2                	mov    %edx,%edx
    2b01:	48 01 d0             	add    %rdx,%rax
    2b04:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2b0a:	83 c2 08             	add    $0x8,%edx
    2b0d:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2b13:	eb 12                	jmp    2b27 <printf+0x2ba>
    2b15:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2b1c:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2b20:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2b27:	48 8b 10             	mov    (%rax),%rdx
    2b2a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2b30:	48 89 d6             	mov    %rdx,%rsi
    2b33:	89 c7                	mov    %eax,%edi
    2b35:	48 b8 bb 26 00 00 00 	movabs $0x26bb,%rax
    2b3c:	00 00 00 
    2b3f:	ff d0                	callq  *%rax
      break;
    2b41:	e9 f9 00 00 00       	jmpq   2c3f <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    2b46:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2b4c:	83 f8 2f             	cmp    $0x2f,%eax
    2b4f:	77 23                	ja     2b74 <printf+0x307>
    2b51:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2b58:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2b5e:	89 d2                	mov    %edx,%edx
    2b60:	48 01 d0             	add    %rdx,%rax
    2b63:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2b69:	83 c2 08             	add    $0x8,%edx
    2b6c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    2b72:	eb 12                	jmp    2b86 <printf+0x319>
    2b74:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2b7b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2b7f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2b86:	48 8b 00             	mov    (%rax),%rax
    2b89:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    2b90:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    2b97:	00 
    2b98:	75 41                	jne    2bdb <printf+0x36e>
        s = "(null)";
    2b9a:	48 b8 b0 34 00 00 00 	movabs $0x34b0,%rax
    2ba1:	00 00 00 
    2ba4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    2bab:	eb 2e                	jmp    2bdb <printf+0x36e>
        putc(fd, *(s++));
    2bad:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    2bb4:	48 8d 50 01          	lea    0x1(%rax),%rdx
    2bb8:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    2bbf:	0f b6 00             	movzbl (%rax),%eax
    2bc2:	0f be d0             	movsbl %al,%edx
    2bc5:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2bcb:	89 d6                	mov    %edx,%esi
    2bcd:	89 c7                	mov    %eax,%edi
    2bcf:	48 b8 87 26 00 00 00 	movabs $0x2687,%rax
    2bd6:	00 00 00 
    2bd9:	ff d0                	callq  *%rax
      while (*s)
    2bdb:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    2be2:	0f b6 00             	movzbl (%rax),%eax
    2be5:	84 c0                	test   %al,%al
    2be7:	75 c4                	jne    2bad <printf+0x340>
      break;
    2be9:	eb 54                	jmp    2c3f <printf+0x3d2>
    case '%':
      putc(fd, '%');
    2beb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2bf1:	be 25 00 00 00       	mov    $0x25,%esi
    2bf6:	89 c7                	mov    %eax,%edi
    2bf8:	48 b8 87 26 00 00 00 	movabs $0x2687,%rax
    2bff:	00 00 00 
    2c02:	ff d0                	callq  *%rax
      break;
    2c04:	eb 39                	jmp    2c3f <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    2c06:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2c0c:	be 25 00 00 00       	mov    $0x25,%esi
    2c11:	89 c7                	mov    %eax,%edi
    2c13:	48 b8 87 26 00 00 00 	movabs $0x2687,%rax
    2c1a:	00 00 00 
    2c1d:	ff d0                	callq  *%rax
      putc(fd, c);
    2c1f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    2c25:	0f be d0             	movsbl %al,%edx
    2c28:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2c2e:	89 d6                	mov    %edx,%esi
    2c30:	89 c7                	mov    %eax,%edi
    2c32:	48 b8 87 26 00 00 00 	movabs $0x2687,%rax
    2c39:	00 00 00 
    2c3c:	ff d0                	callq  *%rax
      break;
    2c3e:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    2c3f:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    2c46:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    2c4c:	48 63 d0             	movslq %eax,%rdx
    2c4f:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    2c56:	48 01 d0             	add    %rdx,%rax
    2c59:	0f b6 00             	movzbl (%rax),%eax
    2c5c:	0f be c0             	movsbl %al,%eax
    2c5f:	25 ff 00 00 00       	and    $0xff,%eax
    2c64:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    2c6a:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    2c71:	0f 85 8e fc ff ff    	jne    2905 <printf+0x98>
    }
  }
}
    2c77:	eb 01                	jmp    2c7a <printf+0x40d>
      break;
    2c79:	90                   	nop
}
    2c7a:	90                   	nop
    2c7b:	c9                   	leaveq 
    2c7c:	c3                   	retq   

0000000000002c7d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    2c7d:	f3 0f 1e fa          	endbr64 
    2c81:	55                   	push   %rbp
    2c82:	48 89 e5             	mov    %rsp,%rbp
    2c85:	48 83 ec 18          	sub    $0x18,%rsp
    2c89:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    2c8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2c91:	48 83 e8 10          	sub    $0x10,%rax
    2c95:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2c99:	48 b8 a0 3b 00 00 00 	movabs $0x3ba0,%rax
    2ca0:	00 00 00 
    2ca3:	48 8b 00             	mov    (%rax),%rax
    2ca6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    2caa:	eb 2f                	jmp    2cdb <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2cac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2cb0:	48 8b 00             	mov    (%rax),%rax
    2cb3:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2cb7:	72 17                	jb     2cd0 <free+0x53>
    2cb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2cbd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    2cc1:	77 2f                	ja     2cf2 <free+0x75>
    2cc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2cc7:	48 8b 00             	mov    (%rax),%rax
    2cca:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    2cce:	72 22                	jb     2cf2 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2cd4:	48 8b 00             	mov    (%rax),%rax
    2cd7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    2cdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2cdf:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    2ce3:	76 c7                	jbe    2cac <free+0x2f>
    2ce5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2ce9:	48 8b 00             	mov    (%rax),%rax
    2cec:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    2cf0:	73 ba                	jae    2cac <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    2cf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2cf6:	8b 40 08             	mov    0x8(%rax),%eax
    2cf9:	89 c0                	mov    %eax,%eax
    2cfb:	48 c1 e0 04          	shl    $0x4,%rax
    2cff:	48 89 c2             	mov    %rax,%rdx
    2d02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d06:	48 01 c2             	add    %rax,%rdx
    2d09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d0d:	48 8b 00             	mov    (%rax),%rax
    2d10:	48 39 c2             	cmp    %rax,%rdx
    2d13:	75 2d                	jne    2d42 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    2d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d19:	8b 50 08             	mov    0x8(%rax),%edx
    2d1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d20:	48 8b 00             	mov    (%rax),%rax
    2d23:	8b 40 08             	mov    0x8(%rax),%eax
    2d26:	01 c2                	add    %eax,%edx
    2d28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d2c:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    2d2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d33:	48 8b 00             	mov    (%rax),%rax
    2d36:	48 8b 10             	mov    (%rax),%rdx
    2d39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d3d:	48 89 10             	mov    %rdx,(%rax)
    2d40:	eb 0e                	jmp    2d50 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    2d42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d46:	48 8b 10             	mov    (%rax),%rdx
    2d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d4d:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    2d50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d54:	8b 40 08             	mov    0x8(%rax),%eax
    2d57:	89 c0                	mov    %eax,%eax
    2d59:	48 c1 e0 04          	shl    $0x4,%rax
    2d5d:	48 89 c2             	mov    %rax,%rdx
    2d60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d64:	48 01 d0             	add    %rdx,%rax
    2d67:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    2d6b:	75 27                	jne    2d94 <free+0x117>
    p->s.size += bp->s.size;
    2d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d71:	8b 50 08             	mov    0x8(%rax),%edx
    2d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d78:	8b 40 08             	mov    0x8(%rax),%eax
    2d7b:	01 c2                	add    %eax,%edx
    2d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d81:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    2d84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2d88:	48 8b 10             	mov    (%rax),%rdx
    2d8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d8f:	48 89 10             	mov    %rdx,(%rax)
    2d92:	eb 0b                	jmp    2d9f <free+0x122>
  } else
    p->s.ptr = bp;
    2d94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2d98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    2d9c:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    2d9f:	48 ba a0 3b 00 00 00 	movabs $0x3ba0,%rdx
    2da6:	00 00 00 
    2da9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2dad:	48 89 02             	mov    %rax,(%rdx)
}
    2db0:	90                   	nop
    2db1:	c9                   	leaveq 
    2db2:	c3                   	retq   

0000000000002db3 <morecore>:

static Header*
morecore(uint nu)
{
    2db3:	f3 0f 1e fa          	endbr64 
    2db7:	55                   	push   %rbp
    2db8:	48 89 e5             	mov    %rsp,%rbp
    2dbb:	48 83 ec 20          	sub    $0x20,%rsp
    2dbf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    2dc2:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    2dc9:	77 07                	ja     2dd2 <morecore+0x1f>
    nu = 4096;
    2dcb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    2dd2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2dd5:	48 c1 e0 04          	shl    $0x4,%rax
    2dd9:	48 89 c7             	mov    %rax,%rdi
    2ddc:	48 b8 60 26 00 00 00 	movabs $0x2660,%rax
    2de3:	00 00 00 
    2de6:	ff d0                	callq  *%rax
    2de8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    2dec:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    2df1:	75 07                	jne    2dfa <morecore+0x47>
    return 0;
    2df3:	b8 00 00 00 00       	mov    $0x0,%eax
    2df8:	eb 36                	jmp    2e30 <morecore+0x7d>
  hp = (Header*)p;
    2dfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2dfe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    2e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2e06:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2e09:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    2e0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2e10:	48 83 c0 10          	add    $0x10,%rax
    2e14:	48 89 c7             	mov    %rax,%rdi
    2e17:	48 b8 7d 2c 00 00 00 	movabs $0x2c7d,%rax
    2e1e:	00 00 00 
    2e21:	ff d0                	callq  *%rax
  return freep;
    2e23:	48 b8 a0 3b 00 00 00 	movabs $0x3ba0,%rax
    2e2a:	00 00 00 
    2e2d:	48 8b 00             	mov    (%rax),%rax
}
    2e30:	c9                   	leaveq 
    2e31:	c3                   	retq   

0000000000002e32 <malloc>:

void*
malloc(uint nbytes)
{
    2e32:	f3 0f 1e fa          	endbr64 
    2e36:	55                   	push   %rbp
    2e37:	48 89 e5             	mov    %rsp,%rbp
    2e3a:	48 83 ec 30          	sub    $0x30,%rsp
    2e3e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    2e41:	8b 45 dc             	mov    -0x24(%rbp),%eax
    2e44:	48 83 c0 0f          	add    $0xf,%rax
    2e48:	48 c1 e8 04          	shr    $0x4,%rax
    2e4c:	83 c0 01             	add    $0x1,%eax
    2e4f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    2e52:	48 b8 a0 3b 00 00 00 	movabs $0x3ba0,%rax
    2e59:	00 00 00 
    2e5c:	48 8b 00             	mov    (%rax),%rax
    2e5f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    2e63:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    2e68:	75 4a                	jne    2eb4 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    2e6a:	48 b8 90 3b 00 00 00 	movabs $0x3b90,%rax
    2e71:	00 00 00 
    2e74:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    2e78:	48 ba a0 3b 00 00 00 	movabs $0x3ba0,%rdx
    2e7f:	00 00 00 
    2e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2e86:	48 89 02             	mov    %rax,(%rdx)
    2e89:	48 b8 a0 3b 00 00 00 	movabs $0x3ba0,%rax
    2e90:	00 00 00 
    2e93:	48 8b 00             	mov    (%rax),%rax
    2e96:	48 ba 90 3b 00 00 00 	movabs $0x3b90,%rdx
    2e9d:	00 00 00 
    2ea0:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    2ea3:	48 b8 90 3b 00 00 00 	movabs $0x3b90,%rax
    2eaa:	00 00 00 
    2ead:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2eb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2eb8:	48 8b 00             	mov    (%rax),%rax
    2ebb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    2ebf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2ec3:	8b 40 08             	mov    0x8(%rax),%eax
    2ec6:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2ec9:	77 65                	ja     2f30 <malloc+0xfe>
      if(p->s.size == nunits)
    2ecb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2ecf:	8b 40 08             	mov    0x8(%rax),%eax
    2ed2:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2ed5:	75 10                	jne    2ee7 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    2ed7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2edb:	48 8b 10             	mov    (%rax),%rdx
    2ede:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2ee2:	48 89 10             	mov    %rdx,(%rax)
    2ee5:	eb 2e                	jmp    2f15 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    2ee7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2eeb:	8b 40 08             	mov    0x8(%rax),%eax
    2eee:	2b 45 ec             	sub    -0x14(%rbp),%eax
    2ef1:	89 c2                	mov    %eax,%edx
    2ef3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2ef7:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    2efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2efe:	8b 40 08             	mov    0x8(%rax),%eax
    2f01:	89 c0                	mov    %eax,%eax
    2f03:	48 c1 e0 04          	shl    $0x4,%rax
    2f07:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    2f0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f0f:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2f12:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    2f15:	48 ba a0 3b 00 00 00 	movabs $0x3ba0,%rdx
    2f1c:	00 00 00 
    2f1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2f23:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    2f26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f2a:	48 83 c0 10          	add    $0x10,%rax
    2f2e:	eb 4e                	jmp    2f7e <malloc+0x14c>
    }
    if(p == freep)
    2f30:	48 b8 a0 3b 00 00 00 	movabs $0x3ba0,%rax
    2f37:	00 00 00 
    2f3a:	48 8b 00             	mov    (%rax),%rax
    2f3d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    2f41:	75 23                	jne    2f66 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    2f43:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2f46:	89 c7                	mov    %eax,%edi
    2f48:	48 b8 b3 2d 00 00 00 	movabs $0x2db3,%rax
    2f4f:	00 00 00 
    2f52:	ff d0                	callq  *%rax
    2f54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    2f58:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2f5d:	75 07                	jne    2f66 <malloc+0x134>
        return 0;
    2f5f:	b8 00 00 00 00       	mov    $0x0,%eax
    2f64:	eb 18                	jmp    2f7e <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2f66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    2f6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2f72:	48 8b 00             	mov    (%rax),%rax
    2f75:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    2f79:	e9 41 ff ff ff       	jmpq   2ebf <malloc+0x8d>
  }
}
    2f7e:	c9                   	leaveq 
    2f7f:	c3                   	retq   

0000000000002f80 <co_new>:
// you need to call swtch() from co_yield() and co_run()
extern void swtch(struct co_context ** pp_old, struct co_context * p_new);

  struct coroutine *
co_new(void (*func)(void))
{
    2f80:	f3 0f 1e fa          	endbr64 
    2f84:	55                   	push   %rbp
    2f85:	48 89 e5             	mov    %rsp,%rbp
    2f88:	48 83 ec 30          	sub    $0x30,%rsp
    2f8c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  struct coroutine * co1 = malloc(sizeof(*co1));
    2f90:	bf 18 00 00 00       	mov    $0x18,%edi
    2f95:	48 b8 32 2e 00 00 00 	movabs $0x2e32,%rax
    2f9c:	00 00 00 
    2f9f:	ff d0                	callq  *%rax
    2fa1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if (co1 == 0)
    2fa5:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    2faa:	75 0a                	jne    2fb6 <co_new+0x36>
    return 0;
    2fac:	b8 00 00 00 00       	mov    $0x0,%eax
    2fb1:	e9 e1 00 00 00       	jmpq   3097 <co_new+0x117>

  // prepare the context
  co1->stack = malloc(8192);
    2fb6:	bf 00 20 00 00       	mov    $0x2000,%edi
    2fbb:	48 b8 32 2e 00 00 00 	movabs $0x2e32,%rax
    2fc2:	00 00 00 
    2fc5:	ff d0                	callq  *%rax
    2fc7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    2fcb:	48 89 42 10          	mov    %rax,0x10(%rdx)
  if (co1->stack == 0) {
    2fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2fd3:	48 8b 40 10          	mov    0x10(%rax),%rax
    2fd7:	48 85 c0             	test   %rax,%rax
    2fda:	75 1d                	jne    2ff9 <co_new+0x79>
    free(co1);
    2fdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2fe0:	48 89 c7             	mov    %rax,%rdi
    2fe3:	48 b8 7d 2c 00 00 00 	movabs $0x2c7d,%rax
    2fea:	00 00 00 
    2fed:	ff d0                	callq  *%rax
    return 0;
    2fef:	b8 00 00 00 00       	mov    $0x0,%eax
    2ff4:	e9 9e 00 00 00       	jmpq   3097 <co_new+0x117>
  }
  u64 * ptr = co1->stack + 1000;
    2ff9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2ffd:	48 8b 40 10          	mov    0x10(%rax),%rax
    3001:	48 05 e8 03 00 00    	add    $0x3e8,%rax
    3007:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  ptr[6] = (u64)func;
    300b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    300f:	48 8d 50 30          	lea    0x30(%rax),%rdx
    3013:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    3017:	48 89 02             	mov    %rax,(%rdx)
  ptr[7] = (u64)co_exit;
    301a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    301e:	48 83 c0 38          	add    $0x38,%rax
    3022:	48 ba 09 32 00 00 00 	movabs $0x3209,%rdx
    3029:	00 00 00 
    302c:	48 89 10             	mov    %rdx,(%rax)
  co1->context = (void*) ptr;
    302f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    3033:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    3037:	48 89 10             	mov    %rdx,(%rax)
  
  if(co_list == 0)
    303a:	48 b8 b8 3b 00 00 00 	movabs $0x3bb8,%rax
    3041:	00 00 00 
    3044:	48 8b 00             	mov    (%rax),%rax
    3047:	48 85 c0             	test   %rax,%rax
    304a:	75 13                	jne    305f <co_new+0xdf>
  {
  	co_list = co1;
    304c:	48 ba b8 3b 00 00 00 	movabs $0x3bb8,%rdx
    3053:	00 00 00 
    3056:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    305a:	48 89 02             	mov    %rax,(%rdx)
    305d:	eb 34                	jmp    3093 <co_new+0x113>
  }else{
	struct coroutine * head = co_list;
    305f:	48 b8 b8 3b 00 00 00 	movabs $0x3bb8,%rax
    3066:	00 00 00 
    3069:	48 8b 00             	mov    (%rax),%rax
    306c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    3070:	eb 0c                	jmp    307e <co_new+0xfe>
	{
		head = head->next;
    3072:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3076:	48 8b 40 08          	mov    0x8(%rax),%rax
    307a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(head->next != 0)
    307e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3082:	48 8b 40 08          	mov    0x8(%rax),%rax
    3086:	48 85 c0             	test   %rax,%rax
    3089:	75 e7                	jne    3072 <co_new+0xf2>
	}
	head = co1;
    308b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    308f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  }
  
  // done
  return co1;
    3093:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
    3097:	c9                   	leaveq 
    3098:	c3                   	retq   

0000000000003099 <co_run>:

  int
co_run(void)
{
    3099:	f3 0f 1e fa          	endbr64 
    309d:	55                   	push   %rbp
    309e:	48 89 e5             	mov    %rsp,%rbp
	if(co_list != 0)
    30a1:	48 b8 b8 3b 00 00 00 	movabs $0x3bb8,%rax
    30a8:	00 00 00 
    30ab:	48 8b 00             	mov    (%rax),%rax
    30ae:	48 85 c0             	test   %rax,%rax
    30b1:	74 4a                	je     30fd <co_run+0x64>
	{
		co_current = co_list;
    30b3:	48 b8 b8 3b 00 00 00 	movabs $0x3bb8,%rax
    30ba:	00 00 00 
    30bd:	48 8b 00             	mov    (%rax),%rax
    30c0:	48 ba b0 3b 00 00 00 	movabs $0x3bb0,%rdx
    30c7:	00 00 00 
    30ca:	48 89 02             	mov    %rax,(%rdx)
		swtch(&host_context,co_current->context);
    30cd:	48 b8 b0 3b 00 00 00 	movabs $0x3bb0,%rax
    30d4:	00 00 00 
    30d7:	48 8b 00             	mov    (%rax),%rax
    30da:	48 8b 00             	mov    (%rax),%rax
    30dd:	48 89 c6             	mov    %rax,%rsi
    30e0:	48 bf a8 3b 00 00 00 	movabs $0x3ba8,%rdi
    30e7:	00 00 00 
    30ea:	48 b8 6b 33 00 00 00 	movabs $0x336b,%rax
    30f1:	00 00 00 
    30f4:	ff d0                	callq  *%rax
		return 1;
    30f6:	b8 01 00 00 00       	mov    $0x1,%eax
    30fb:	eb 05                	jmp    3102 <co_run+0x69>
	}
	return 0;
    30fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3102:	5d                   	pop    %rbp
    3103:	c3                   	retq   

0000000000003104 <co_run_all>:

  int
co_run_all(void)
{
    3104:	f3 0f 1e fa          	endbr64 
    3108:	55                   	push   %rbp
    3109:	48 89 e5             	mov    %rsp,%rbp
    310c:	48 83 ec 10          	sub    $0x10,%rsp
	if(co_list == 0){
    3110:	48 b8 b8 3b 00 00 00 	movabs $0x3bb8,%rax
    3117:	00 00 00 
    311a:	48 8b 00             	mov    (%rax),%rax
    311d:	48 85 c0             	test   %rax,%rax
    3120:	75 07                	jne    3129 <co_run_all+0x25>
		return 0;
    3122:	b8 00 00 00 00       	mov    $0x0,%eax
    3127:	eb 37                	jmp    3160 <co_run_all+0x5c>
	}else{
		struct coroutine * tmp = co_list;
    3129:	48 b8 b8 3b 00 00 00 	movabs $0x3bb8,%rax
    3130:	00 00 00 
    3133:	48 8b 00             	mov    (%rax),%rax
    3136:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    313a:	eb 18                	jmp    3154 <co_run_all+0x50>
			co_run();
    313c:	48 b8 99 30 00 00 00 	movabs $0x3099,%rax
    3143:	00 00 00 
    3146:	ff d0                	callq  *%rax
			tmp = tmp->next;
    3148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    314c:	48 8b 40 08          	mov    0x8(%rax),%rax
    3150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		while(tmp != 0){
    3154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    3159:	75 e1                	jne    313c <co_run_all+0x38>
		}
		return 1;
    315b:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
    3160:	c9                   	leaveq 
    3161:	c3                   	retq   

0000000000003162 <co_yield>:

  void
co_yield()
{
    3162:	f3 0f 1e fa          	endbr64 
    3166:	55                   	push   %rbp
    3167:	48 89 e5             	mov    %rsp,%rbp
    316a:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it must be safe to call co_yield() from a host context (or any non-coroutine)
  struct coroutine * tmp = co_current;
    316e:	48 b8 b0 3b 00 00 00 	movabs $0x3bb0,%rax
    3175:	00 00 00 
    3178:	48 8b 00             	mov    (%rax),%rax
    317b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(tmp->next != 0)
    317f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3183:	48 8b 40 08          	mov    0x8(%rax),%rax
    3187:	48 85 c0             	test   %rax,%rax
    318a:	74 46                	je     31d2 <co_yield+0x70>
  {
  	co_current = co_current->next;
    318c:	48 b8 b0 3b 00 00 00 	movabs $0x3bb0,%rax
    3193:	00 00 00 
    3196:	48 8b 00             	mov    (%rax),%rax
    3199:	48 8b 40 08          	mov    0x8(%rax),%rax
    319d:	48 ba b0 3b 00 00 00 	movabs $0x3bb0,%rdx
    31a4:	00 00 00 
    31a7:	48 89 02             	mov    %rax,(%rdx)
  	swtch(&tmp->context,co_current->context);
    31aa:	48 b8 b0 3b 00 00 00 	movabs $0x3bb0,%rax
    31b1:	00 00 00 
    31b4:	48 8b 00             	mov    (%rax),%rax
    31b7:	48 8b 10             	mov    (%rax),%rdx
    31ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    31be:	48 89 d6             	mov    %rdx,%rsi
    31c1:	48 89 c7             	mov    %rax,%rdi
    31c4:	48 b8 6b 33 00 00 00 	movabs $0x336b,%rax
    31cb:	00 00 00 
    31ce:	ff d0                	callq  *%rax
  }else{
	co_current = 0;
	swtch(&tmp->context,host_context);
  }
}
    31d0:	eb 34                	jmp    3206 <co_yield+0xa4>
	co_current = 0;
    31d2:	48 b8 b0 3b 00 00 00 	movabs $0x3bb0,%rax
    31d9:	00 00 00 
    31dc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	swtch(&tmp->context,host_context);
    31e3:	48 b8 a8 3b 00 00 00 	movabs $0x3ba8,%rax
    31ea:	00 00 00 
    31ed:	48 8b 10             	mov    (%rax),%rdx
    31f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    31f4:	48 89 d6             	mov    %rdx,%rsi
    31f7:	48 89 c7             	mov    %rax,%rdi
    31fa:	48 b8 6b 33 00 00 00 	movabs $0x336b,%rax
    3201:	00 00 00 
    3204:	ff d0                	callq  *%rax
}
    3206:	90                   	nop
    3207:	c9                   	leaveq 
    3208:	c3                   	retq   

0000000000003209 <co_exit>:

  void
co_exit(void)
{
    3209:	f3 0f 1e fa          	endbr64 
    320d:	55                   	push   %rbp
    320e:	48 89 e5             	mov    %rsp,%rbp
    3211:	48 83 ec 10          	sub    $0x10,%rsp
  // TODO: your code here
  // it makes no sense to co_exit from non-coroutine.
	if(!co_current)
    3215:	48 b8 b0 3b 00 00 00 	movabs $0x3bb0,%rax
    321c:	00 00 00 
    321f:	48 8b 00             	mov    (%rax),%rax
    3222:	48 85 c0             	test   %rax,%rax
    3225:	0f 84 ec 00 00 00    	je     3317 <co_exit+0x10e>
		return;
	struct coroutine *tmp = co_list;
    322b:	48 b8 b8 3b 00 00 00 	movabs $0x3bb8,%rax
    3232:	00 00 00 
    3235:	48 8b 00             	mov    (%rax),%rax
    3238:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct coroutine *prev;

	while(tmp){
    323c:	e9 c9 00 00 00       	jmpq   330a <co_exit+0x101>
		if(tmp == co_current)
    3241:	48 b8 b0 3b 00 00 00 	movabs $0x3bb0,%rax
    3248:	00 00 00 
    324b:	48 8b 00             	mov    (%rax),%rax
    324e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    3252:	0f 85 9e 00 00 00    	jne    32f6 <co_exit+0xed>
		{
			if(tmp->next)
    3258:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    325c:	48 8b 40 08          	mov    0x8(%rax),%rax
    3260:	48 85 c0             	test   %rax,%rax
    3263:	74 54                	je     32b9 <co_exit+0xb0>
			{
				if(prev)
    3265:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    326a:	74 10                	je     327c <co_exit+0x73>
				{
					prev->next = tmp->next;
    326c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3270:	48 8b 50 08          	mov    0x8(%rax),%rdx
    3274:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    3278:	48 89 50 08          	mov    %rdx,0x8(%rax)
				}
				co_list = tmp->next;
    327c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3280:	48 8b 40 08          	mov    0x8(%rax),%rax
    3284:	48 ba b8 3b 00 00 00 	movabs $0x3bb8,%rdx
    328b:	00 00 00 
    328e:	48 89 02             	mov    %rax,(%rdx)
				swtch(&co_current->context,tmp->context);
    3291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3295:	48 8b 00             	mov    (%rax),%rax
    3298:	48 ba b0 3b 00 00 00 	movabs $0x3bb0,%rdx
    329f:	00 00 00 
    32a2:	48 8b 12             	mov    (%rdx),%rdx
    32a5:	48 89 c6             	mov    %rax,%rsi
    32a8:	48 89 d7             	mov    %rdx,%rdi
    32ab:	48 b8 6b 33 00 00 00 	movabs $0x336b,%rax
    32b2:	00 00 00 
    32b5:	ff d0                	callq  *%rax
    32b7:	eb 3d                	jmp    32f6 <co_exit+0xed>
			}else{
				co_list = 0;
    32b9:	48 b8 b8 3b 00 00 00 	movabs $0x3bb8,%rax
    32c0:	00 00 00 
    32c3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
				swtch(&co_current->context,host_context);
    32ca:	48 b8 a8 3b 00 00 00 	movabs $0x3ba8,%rax
    32d1:	00 00 00 
    32d4:	48 8b 00             	mov    (%rax),%rax
    32d7:	48 ba b0 3b 00 00 00 	movabs $0x3bb0,%rdx
    32de:	00 00 00 
    32e1:	48 8b 12             	mov    (%rdx),%rdx
    32e4:	48 89 c6             	mov    %rax,%rsi
    32e7:	48 89 d7             	mov    %rdx,%rdi
    32ea:	48 b8 6b 33 00 00 00 	movabs $0x336b,%rax
    32f1:	00 00 00 
    32f4:	ff d0                	callq  *%rax
			}
		}
		prev = tmp;
    32f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    32fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		tmp = tmp->next;
    32fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3302:	48 8b 40 08          	mov    0x8(%rax),%rax
    3306:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while(tmp){
    330a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    330f:	0f 85 2c ff ff ff    	jne    3241 <co_exit+0x38>
    3315:	eb 01                	jmp    3318 <co_exit+0x10f>
		return;
    3317:	90                   	nop
	}
}
    3318:	c9                   	leaveq 
    3319:	c3                   	retq   

000000000000331a <co_destroy>:

  void
co_destroy(struct coroutine * const co)
{
    331a:	f3 0f 1e fa          	endbr64 
    331e:	55                   	push   %rbp
    331f:	48 89 e5             	mov    %rsp,%rbp
    3322:	48 83 ec 10          	sub    $0x10,%rsp
    3326:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if (co) {
    332a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    332f:	74 37                	je     3368 <co_destroy+0x4e>
    if (co->stack)
    3331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3335:	48 8b 40 10          	mov    0x10(%rax),%rax
    3339:	48 85 c0             	test   %rax,%rax
    333c:	74 17                	je     3355 <co_destroy+0x3b>
      free(co->stack);
    333e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3342:	48 8b 40 10          	mov    0x10(%rax),%rax
    3346:	48 89 c7             	mov    %rax,%rdi
    3349:	48 b8 7d 2c 00 00 00 	movabs $0x2c7d,%rax
    3350:	00 00 00 
    3353:	ff d0                	callq  *%rax
    free(co);
    3355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    3359:	48 89 c7             	mov    %rax,%rdi
    335c:	48 b8 7d 2c 00 00 00 	movabs $0x2c7d,%rax
    3363:	00 00 00 
    3366:	ff d0                	callq  *%rax
  }
}
    3368:	90                   	nop
    3369:	c9                   	leaveq 
    336a:	c3                   	retq   

000000000000336b <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
    336b:	55                   	push   %rbp
  pushq   %rbx
    336c:	53                   	push   %rbx
  pushq   %r12
    336d:	41 54                	push   %r12
  pushq   %r13
    336f:	41 55                	push   %r13
  pushq   %r14
    3371:	41 56                	push   %r14
  pushq   %r15
    3373:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
    3375:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
    3378:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
    337b:	41 5f                	pop    %r15
  popq    %r14
    337d:	41 5e                	pop    %r14
  popq    %r13
    337f:	41 5d                	pop    %r13
  popq    %r12
    3381:	41 5c                	pop    %r12
  popq    %rbx
    3383:	5b                   	pop    %rbx
  popq    %rbp
    3384:	5d                   	pop    %rbp

  retq #??
    3385:	c3                   	retq   
