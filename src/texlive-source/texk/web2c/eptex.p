{4:}{9:}{$C-,A+,D-}ifdef('TEXMF_DEBUG'){$C+,D+}
endif('TEXMF_DEBUG'){:9}program ETEX;const{11:}hashoffset=514;
trieopsize=35111;negtrieopsize=-35111;mintrieop=0;maxtrieop=65535;
poolname=TEXMFPOOLNAME;enginename=TEXMFENGINENAME;infmembot=0;
supmembot=1;infmainmemory=3000;supmainmemory=256000000;inftriesize=8000;
suptriesize=4194303;infmaxstrings=3000;supmaxstrings=2097151;
infstringsfree=100;supstringsfree=supmaxstrings;infbufsize=500;
supbufsize=30000000;infnestsize=40;supnestsize=4000;infmaxinopen=6;
supmaxinopen=127;infparamsize=60;supparamsize=32767;infsavesize=600;
supsavesize=80000;infstacksize=200;supstacksize=30000;infdvibufsize=800;
supdvibufsize=65536;inffontmemsize=20000;supfontmemsize=147483647;
supfontmax=9000;inffontmax=50;infpoolsize=32000;suppoolsize=40000000;
infpoolfree=1000;suppoolfree=suppoolsize;infstringvacancies=8000;
supstringvacancies=suppoolsize-23000;suphashextra=supmaxstrings;
infhashextra=0;suphyphsize=65535;infhyphsize=610;infexpanddepth=10;
supexpanddepth=10000000;{:11}type{18:}ASCIIcode=0..255;
KANJIcode=0..65535;{:18}{25:}eightbits=0..255;sixteenbits=0..65535;
alphafile=packed file of ASCIIcode;bytefile=packed file of eightbits;
{:25}{39:}poolpointer=integer;strnumber=0..2097151;
packedASCIIcode=0..255;{:39}{102:}scaled=integer;
nonnegativeinteger=0..2147483647;smallnumber=0..63;
{:102}{110:}{:110}{114:}quarterword=0..65535;
halfword=-268435455..268435455;twochoices=1..2;fourchoices=1..4;
#include "texmfmem.h";wordfile=file of memoryword;
{:114}{156:}glueord=0..4;
{:156}{218:}liststaterecord=record modefield:-227..227;
dirfield,adjdirfield:-4..4;pdispfield:scaled;
headfield,tailfield,pnodefield,lastjchrfield:halfword;
eTeXauxfield:halfword;pgfield,mlfield:integer;auxfield:memoryword;end;
{:218}{279:}groupcode=0..16;
{:279}{310:}instaterecord=record statefield,indexfield:quarterword;
startfield,locfield,limitfield,namefield:halfword;
synctextagfield:integer;end;{:310}{565:}internalfontnumber=integer;
fontindex=integer;ninebits=0..256;{:565}{611:}dviindex=0..dvibufsize;
{:611}{937:}triepointer=0..4194303;trieopcode=0..65535;
{:937}{942:}hyphpointer=0..65535;{:942}{1428:}savepointer=0..savesize;
{:1428}var{13:}bad:integer;{:13}{20:}xord:array[ASCIIcode]of ASCIIcode;
xchr:array[ASCIIcode]of ASCIIcode;xprn:array[ASCIIcode]of ASCIIcode;
{:20}{26:}nameoffile:^ASCIIcode;namelength:0..maxint;
{:26}{31:}buffer:^ASCIIcode;first:0..bufsize;last:0..bufsize;
maxbufstack:0..bufsize;{:31}{33:}ifdef('INITEX')iniversion:boolean;
dumpoption:boolean;dumpline:boolean;
endif('INITEX')dumpname:constcstring;bounddefault:integer;
boundname:constcstring;membot:integer;mainmemory:integer;
extramembot:integer;memmin:integer;memtop:integer;extramemtop:integer;
memmax:integer;errorline:integer;halferrorline:integer;
maxprintline:integer;maxstrings:integer;stringsfree:integer;
stringvacancies:integer;poolsize:integer;poolfree:integer;
fontmemsize:integer;fontmax:integer;fontk:integer;hyphsize:integer;
triesize:integer;bufsize:integer;stacksize:integer;maxinopen:integer;
paramsize:integer;nestsize:integer;savesize:integer;dvibufsize:integer;
expanddepth:integer;parsefirstlinep:cinttype;
filelineerrorstylep:cinttype;eightbitp:cinttype;haltonerrorp:cinttype;
quotedfilename:boolean;srcspecialsp:boolean;
insertsrcspecialauto:boolean;insertsrcspecialeverypar:boolean;
insertsrcspecialeveryparend:boolean;insertsrcspecialeverycr:boolean;
insertsrcspecialeverymath:boolean;insertsrcspecialeveryhbox:boolean;
insertsrcspecialeveryvbox:boolean;insertsrcspecialeverydisplay:boolean;
{:33}{40:}strpool:^packedASCIIcode;strstart:^poolpointer;
poolptr:poolpointer;strptr:strnumber;initpoolptr:poolpointer;
initstrptr:strnumber;{:40}{51:}ifdef('INITEX')poolfile:alphafile;
endif('INITEX'){:51}{55:}logfile:alphafile;selector:0..21;
dig:array[0..22]of 0..15;tally:integer;termoffset:0..maxprintline;
fileoffset:0..maxprintline;trickbuf:array[0..255]of ASCIIcode;
trickbuf2:array[0..255]of 0..2;kcodepos:0..2;prevchar:ASCIIcode;
trickcount:integer;firstcount:integer;{:55}{74:}interaction:0..3;
interactionoption:0..4;{:74}{77:}deletionsallowed:boolean;
setboxallowed:boolean;history:0..3;errorcount:-1..100;
{:77}{80:}helpline:array[0..5]of strnumber;helpptr:0..6;
useerrhelp:boolean;{:80}{97:}interrupt:integer;OKtointerrupt:boolean;
{:97}{105:}aritherror:boolean;texremainder:scaled;
{:105}{116:}tempptr:halfword;{:116}{117:}yzmem:^memoryword;
zmem:^memoryword;lomemmax:halfword;himemmin:halfword;
{:117}{118:}varused,dynused:integer;{:118}{119:}avail:halfword;
memend:halfword;{:119}{125:}rover:halfword;
{:125}{171:}ifdef('TEXMF_DEBUG')freearr:packed array[0..9]of boolean;
wasfree:packed array[0..9]of boolean;
wasmemend,waslomax,washimin:halfword;panicking:boolean;
endif('TEXMF_DEBUG'){:171}{179:}fontinshortdisplay:integer;
{:179}{187:}depththreshold:integer;breadthmax:integer;
{:187}{219:}nest:^liststaterecord;nestptr:0..nestsize;
maxneststack:0..nestsize;curlist:liststaterecord;shownmode:-227..227;
{:219}{252:}oldsetting:0..21;{:252}{259:}zeqtb:^memoryword;
xeqlevel:array[28931..30050]of quarterword;{:259}{262:}hash:^twohalves;
yhash:^twohalves;hashused:halfword;hashextra:halfword;hashtop:halfword;
eqtbtop:halfword;hashhigh:halfword;nonewcontrolsequence:boolean;
cscount:integer;{:262}{263:}prim:array[0..2100]of twohalves;
primused:halfword;primeqtb:array[0..2100]of memoryword;
{:263}{281:}savestack:^memoryword;saveptr:0..savesize;
maxsavestack:0..savesize;curlevel:quarterword;curgroup:groupcode;
curboundary:0..savesize;{:281}{296:}magset:integer;
{:296}{307:}curcmd:eightbits;curchr:halfword;curcs:halfword;
curtok:halfword;{:307}{311:}inputstack:^instaterecord;
inputptr:0..stacksize;maxinstack:0..stacksize;curinput:instaterecord;
{:311}{314:}inopen:0..maxinopen;openparens:0..maxinopen;
inputfile:^alphafile;line:integer;linestack:^integer;
sourcefilenamestack:^strnumber;fullsourcefilenamestack:^strnumber;
{:314}{315:}scannerstatus:0..5;warningindex:halfword;defref:halfword;
{:315}{318:}paramstack:^halfword;paramptr:0..paramsize;
maxparamstack:integer;{:318}{319:}alignstate:integer;
{:319}{320:}baseptr:0..stacksize;{:320}{343:}parloc:halfword;
partoken:halfword;{:343}{358:}skipmode:boolean;
{:358}{373:}forceeof:boolean;{:373}{379:}expanddepthcount:integer;
{:379}{399:}curmark:array[0..4]of halfword;
{:399}{404:}longstate:123..126;
{:404}{405:}pstack:array[0..8]of halfword;{:405}{427:}curval:integer;
curval1:integer;curvallevel:0..5;{:427}{455:}radix:smallnumber;
{:455}{464:}curorder:glueord;
{:464}{497:}readfile:array[0..15]of alphafile;
readopen:array[0..16]of 0..2;{:497}{506:}condptr:halfword;iflimit:0..4;
curif:smallnumber;ifline:integer;{:506}{510:}skipline:integer;
{:510}{529:}curname:strnumber;curarea:strnumber;curext:strnumber;
{:529}{530:}areadelimiter:poolpointer;extdelimiter:poolpointer;
{:530}{537:}formatdefaultlength:integer;TEXformatdefault:cstring;
{:537}{544:}nameinprogress:boolean;jobname:strnumber;logopened:boolean;
{:544}{549:}dvifile:bytefile;outputfilename:strnumber;
texmflogname:strnumber;{:549}{556:}tfmfile:bytefile;
{:556}{566:}fontinfo:^memoryword;fontdir:^eightbits;fontnumext:^integer;
fmemptr:fontindex;fontptr:internalfontnumber;fontcheck:^fourquarters;
fontsize:^scaled;fontdsize:^scaled;fontparams:^fontindex;
fontname:^strnumber;fontarea:^strnumber;fontbc:^eightbits;
fontec:^eightbits;fontglue:^halfword;fontused:^boolean;
hyphenchar:^integer;skewchar:^integer;bcharlabel:^fontindex;
fontbchar:^ninebits;fontfalsebchar:^ninebits;
{:566}{567:}charbase:^integer;ctypebase:^integer;widthbase:^integer;
heightbase:^integer;depthbase:^integer;italicbase:^integer;
ligkernbase:^integer;kernbase:^integer;extenbase:^integer;
parambase:^integer;{:567}{572:}nullcharacter:fourquarters;
{:572}{609:}totalpages:integer;maxv:scaled;maxh:scaled;maxpush:integer;
lastbop:integer;deadcycles:integer;doingleaders:boolean;c:quarterword;
f:internalfontnumber;dirused:boolean;ruleht,ruledp,rulewd:scaled;
g:halfword;lq,lr:integer;{:609}{612:}dvibuf:^eightbits;halfbuf:integer;
dvilimit:integer;dviptr:integer;dvioffset:integer;dvigone:integer;
{:612}{622:}downptr,rightptr:halfword;{:622}{633:}dvih,dviv:scaled;
curh,curv:scaled;dvif:internalfontnumber;curs:integer;
{:633}{663:}totalstretch,totalshrink:array[glueord]of scaled;
lastbadness:integer;{:663}{664:}adjusttail:halfword;lastdisp:scaled;
curkanjiskip:halfword;curxkanjiskip:halfword;
{:664}{678:}packbeginline:integer;{:678}{701:}emptyfield:twohalves;
nulldelimiter:fourquarters;{:701}{736:}curmlist:halfword;
curstyle:smallnumber;cursize:integer;curmu:scaled;
mlistpenalties:boolean;{:736}{741:}curf:internalfontnumber;
curc:quarterword;curi:fourquarters;{:741}{781:}magicoffset:integer;
{:781}{787:}curalign:halfword;curspan:halfword;curloop:halfword;
alignptr:halfword;curhead,curtail:halfword;{:787}{831:}justbox:halfword;
{:831}{838:}passive:halfword;printednode:halfword;passnumber:halfword;
{:838}{840:}activewidth:array[1..7]of scaled;
curactivewidth:array[1..7]of scaled;background:array[1..7]of scaled;
breakwidth:array[1..7]of scaled;{:840}{842:}noshrinkerroryet:boolean;
{:842}{845:}curp:halfword;chain:boolean;secondpass:boolean;
finalpass:boolean;threshold:integer;
{:845}{850:}minimaldemerits:array[0..3]of integer;
minimumdemerits:integer;bestplace:array[0..3]of halfword;
bestplline:array[0..3]of halfword;{:850}{856:}discwidth:scaled;
{:856}{864:}easyline:halfword;lastspecialline:halfword;
firstwidth:scaled;secondwidth:scaled;firstindent:scaled;
secondindent:scaled;{:864}{889:}bestbet:halfword;fewestdemerits:integer;
bestline:halfword;actuallooseness:integer;linediff:integer;
{:889}{909:}hc:array[0..65]of 0..256;hn:smallnumber;ha,hb:halfword;
hf:internalfontnumber;hu:array[0..63]of 0..256;hyfchar:integer;
curlang,initcurlang:ASCIIcode;lhyf,rhyf,initlhyf,initrhyf:integer;
hyfbchar:halfword;{:909}{917:}hyf:array[0..64]of 0..9;initlist:halfword;
initlig:boolean;initlft:boolean;{:917}{922:}hyphenpassed:smallnumber;
{:922}{924:}curl,curr:halfword;curq:halfword;ligstack:halfword;
ligaturepresent:boolean;lfthit,rthit:boolean;
{:924}{938:}trietrl:^triepointer;trietro:^triepointer;
trietrc:^quarterword;hyfdistance:array[1..trieopsize]of smallnumber;
hyfnum:array[1..trieopsize]of smallnumber;
hyfnext:array[1..trieopsize]of trieopcode;
opstart:array[ASCIIcode]of 0..trieopsize;
{:938}{943:}hyphword:^strnumber;hyphlist:^halfword;
hyphlink:^hyphpointer;hyphcount:integer;hyphnext:integer;
{:943}{960:}ifdef('INITEX')trieophash:array[negtrieopsize..trieopsize]of
0..trieopsize;trieused:array[ASCIIcode]of trieopcode;
trieoplang:array[1..trieopsize]of ASCIIcode;
trieopval:array[1..trieopsize]of trieopcode;trieopptr:0..trieopsize;
endif('INITEX')maxopused:trieopcode;smallop:boolean;
{:960}{964:}ifdef('INITEX')triec:^packedASCIIcode;trieo:^trieopcode;
triel:^triepointer;trier:^triepointer;trieptr:triepointer;
triehash:^triepointer;
endif('INITEX'){:964}{967:}ifdef('INITEX')trietaken:^boolean;
triemin:array[ASCIIcode]of triepointer;triemax:triepointer;
trienotready:boolean;
endif('INITEX'){:967}{988:}bestheightplusdepth:scaled;
{:988}{997:}pagetail:halfword;pagecontents:0..2;pagemaxdepth:scaled;
bestpagebreak:halfword;leastpagecost:integer;bestsize:scaled;
{:997}{999:}pagesofar:array[0..8]of scaled;lastglue:halfword;
lastpenalty:integer;lastkern:scaled;lastnodetype:integer;
insertpenalties:integer;{:999}{1006:}outputactive:boolean;
{:1006}{1049:}mainf:internalfontnumber;maini:fourquarters;
mainj:fourquarters;maink:fontindex;mainp:halfword;mains:integer;
bchar:halfword;falsebchar:halfword;cancelboundary:boolean;
insdisc:boolean;{:1049}{1092:}curbox:halfword;
{:1092}{1285:}aftertoken:halfword;{:1285}{1300:}longhelpseen:boolean;
{:1300}{1318:}formatident:strnumber;{:1318}{1324:}fmtfile:wordfile;
{:1324}{1350:}readyalready:integer;
{:1350}{1361:}writefile:array[0..15]of alphafile;
writeopen:array[0..17]of boolean;{:1361}{1364:}writeloc:halfword;
{:1364}{1402:}eTeXmode:0..1;etexp:boolean;
{:1402}{1410:}eofseen:^boolean;{:1410}{1455:}revdisp:scaled;
LRptr:halfword;LRproblems:integer;curdir:smallnumber;
{:1455}{1504:}pseudofiles:halfword;{:1504}{1527:}grpstack:^savepointer;
ifstack:^halfword;{:1527}{1568:}maxregnum:halfword;
maxreghelpline:strnumber;{:1568}{1570:}saroot:array[0..6]of halfword;
curptr:halfword;sanull:memoryword;{:1570}{1589:}sachain:halfword;
salevel:quarterword;{:1589}{1596:}lastlinefill:halfword;
dolastlinefit:boolean;activenodesize:smallnumber;
fillwidth:array[0..3]of scaled;bestplshort:array[0..3]of scaled;
bestplglue:array[0..3]of scaled;{:1596}{1612:}hyphstart:triepointer;
hyphindex:triepointer;{:1612}{1613:}discptr:array[1..3]of halfword;
{:1613}{1621:}editnamestart:poolpointer;editnamelength,editline:integer;
ipcon:cinttype;stopatspace:boolean;{:1621}{1623:}savestrptr:strnumber;
savepoolptr:poolpointer;shellenabledp:cinttype;restrictedshell:cinttype;
outputcomment:^char;k,l:0..255;{:1623}{1625:}debugformatfile:boolean;
{:1625}{1633:}mltexp:boolean;{:1633}{1634:}mltexenabledp:boolean;
{:1634}{1639:}accentc,basec,replacec:integer;iac,ibc:fourquarters;
baseslant,accentslant:real;basexheight:scaled;
basewidth,baseheight:scaled;accentwidth,accentheight:scaled;
delta:scaled;{:1639}{1647:}synctexoption:integer;
{:1647}{1652:}synctexoffset:integer;
{:1652}{1694:}inhibitglueflag:boolean;{:1694}{1710:}dvidir:integer;
curdirhv:integer;pagedir:eightbits;{:1710}{1713:}firstchar:halfword;
lastchar:halfword;findfirstchar:boolean;
{:1713}{1738:}isprintutf8:boolean;{:1738}{1741:}curpagewidth:scaled;
curpageheight:scaled;pdflastxpos:integer;pdflastypos:integer;
{:1741}{1747:}isprintutf8:boolean;lasttokensstring:strnumber;
{:1747}procedure initialize;var{19:}i:integer;{:19}{169:}k:integer;
{:169}{944:}z:hyphpointer;{:944}begin{8:}{21:}xchr[32]:=' ';
xchr[33]:='!';xchr[34]:='"';xchr[35]:='#';xchr[36]:='$';xchr[37]:='%';
xchr[38]:='&';xchr[39]:='''';xchr[40]:='(';xchr[41]:=')';xchr[42]:='*';
xchr[43]:='+';xchr[44]:=',';xchr[45]:='-';xchr[46]:='.';xchr[47]:='/';
xchr[48]:='0';xchr[49]:='1';xchr[50]:='2';xchr[51]:='3';xchr[52]:='4';
xchr[53]:='5';xchr[54]:='6';xchr[55]:='7';xchr[56]:='8';xchr[57]:='9';
xchr[58]:=':';xchr[59]:=';';xchr[60]:='<';xchr[61]:='=';xchr[62]:='>';
xchr[63]:='?';xchr[64]:='@';xchr[65]:='A';xchr[66]:='B';xchr[67]:='C';
xchr[68]:='D';xchr[69]:='E';xchr[70]:='F';xchr[71]:='G';xchr[72]:='H';
xchr[73]:='I';xchr[74]:='J';xchr[75]:='K';xchr[76]:='L';xchr[77]:='M';
xchr[78]:='N';xchr[79]:='O';xchr[80]:='P';xchr[81]:='Q';xchr[82]:='R';
xchr[83]:='S';xchr[84]:='T';xchr[85]:='U';xchr[86]:='V';xchr[87]:='W';
xchr[88]:='X';xchr[89]:='Y';xchr[90]:='Z';xchr[91]:='[';xchr[92]:='\';
xchr[93]:=']';xchr[94]:='^';xchr[95]:='_';xchr[96]:='`';xchr[97]:='a';
xchr[98]:='b';xchr[99]:='c';xchr[100]:='d';xchr[101]:='e';
xchr[102]:='f';xchr[103]:='g';xchr[104]:='h';xchr[105]:='i';
xchr[106]:='j';xchr[107]:='k';xchr[108]:='l';xchr[109]:='m';
xchr[110]:='n';xchr[111]:='o';xchr[112]:='p';xchr[113]:='q';
xchr[114]:='r';xchr[115]:='s';xchr[116]:='t';xchr[117]:='u';
xchr[118]:='v';xchr[119]:='w';xchr[120]:='x';xchr[121]:='y';
xchr[122]:='z';xchr[123]:='{';xchr[124]:='|';xchr[125]:='}';
xchr[126]:='~';{:21}{23:}for i:=0 to 31 do xchr[i]:=i;
for i:=127 to 255 do xchr[i]:=i;
{:23}{24:}for i:=0 to 255 do xord[chr(i)]:=127;
for i:=128 to 255 do xord[xchr[i]]:=i;
for i:=0 to 126 do xord[xchr[i]]:=i;
for i:=0 to 255 do xprn[i]:=(eightbitp or((i>=32)and(i<=126)));
if translatefilename then readtcxfile;
{:24}{75:}if interactionoption=4 then interaction:=3 else interaction:=
interactionoption;{:75}{78:}deletionsallowed:=true;setboxallowed:=true;
errorcount:=0;{:78}{81:}helpptr:=0;useerrhelp:=false;
{:81}{98:}interrupt:=0;OKtointerrupt:=true;
{:98}{172:}ifdef('TEXMF_DEBUG')wasmemend:=memmin;waslomax:=memmin;
washimin:=memmax;panicking:=false;
endif('TEXMF_DEBUG'){:172}{221:}nestptr:=0;maxneststack:=0;
curlist.modefield:=1;curlist.headfield:=memtop-1;
curlist.tailfield:=memtop-1;curlist.pnodefield:=curlist.tailfield;
curlist.dirfield:=4;curlist.adjdirfield:=curlist.dirfield;
curlist.pdispfield:=0;curlist.lastjchrfield:=-268435455;
curlist.eTeXauxfield:=-268435455;curlist.auxfield.int:=-65536000;
curlist.mlfield:=0;curlist.pgfield:=0;shownmode:=0;pagecontents:=0;
pagetail:=memtop-2;lastglue:=268435455;lastpenalty:=0;lastkern:=0;
pagesofar[8]:=0;pagemaxdepth:=0;
{:221}{260:}for k:=28931 to 30050 do xeqlevel[k]:=1;
{:260}{264:}nonewcontrolsequence:=true;prim[0].lh:=0;prim[0].rh:=0;
for k:=1 to 2100 do prim[k]:=prim[0];primeqtb[0].hh.b1:=0;
primeqtb[0].hh.b0:=113;primeqtb[0].hh.rh:=-268435455;
for k:=1 to 2100 do primeqtb[k]:=primeqtb[0];{:264}{282:}saveptr:=0;
curlevel:=1;curgroup:=0;curboundary:=0;maxsavestack:=0;
{:282}{297:}magset:=0;{:297}{359:}skipmode:=true;
{:359}{380:}expanddepthcount:=0;{:380}{400:}curmark[0]:=-268435455;
curmark[1]:=-268435455;curmark[2]:=-268435455;curmark[3]:=-268435455;
curmark[4]:=-268435455;{:400}{456:}curval:=0;curvallevel:=0;radix:=0;
curorder:=0;{:456}{498:}for k:=0 to 16 do readopen[k]:=2;
{:498}{507:}condptr:=-268435455;iflimit:=0;curif:=0;ifline:=0;
{:507}{568:}{:568}{573:}nullcharacter.b0:=0;nullcharacter.b1:=0;
nullcharacter.b2:=0;nullcharacter.b3:=0;{:573}{610:}totalpages:=0;
maxv:=0;maxh:=0;maxpush:=0;lastbop:=-1;doingleaders:=false;
deadcycles:=0;curs:=-1;dirused:=false;
{:610}{613:}halfbuf:=dvibufsize div 2;dvilimit:=dvibufsize;dviptr:=0;
dvioffset:=0;dvigone:=0;{:613}{623:}downptr:=-268435455;
rightptr:=-268435455;{:623}{665:}adjusttail:=-268435455;lastbadness:=0;
curkanjiskip:=membot;curxkanjiskip:=membot;{:665}{679:}packbeginline:=0;
{:679}{702:}emptyfield.rh:=0;emptyfield.lh:=-268435455;
nulldelimiter.b0:=0;nulldelimiter.b1:=0;nulldelimiter.b2:=0;
nulldelimiter.b3:=0;{:702}{788:}alignptr:=-268435455;
curalign:=-268435455;curspan:=-268435455;curloop:=-268435455;
curhead:=-268435455;curtail:=-268435455;
{:788}{945:}for z:=0 to hyphsize do begin hyphword[z]:=0;
hyphlist[z]:=-268435455;hyphlink[z]:=0;end;hyphcount:=0;hyphnext:=608;
if hyphnext>hyphsize then hyphnext:=607;
{:945}{1007:}outputactive:=false;insertpenalties:=0;
{:1007}{1050:}ligaturepresent:=false;cancelboundary:=false;
lfthit:=false;rthit:=false;insdisc:=false;{:1050}{1286:}aftertoken:=0;
{:1286}{1301:}longhelpseen:=false;{:1301}{1319:}formatident:=0;
{:1319}{1362:}for k:=0 to 17 do writeopen[k]:=false;
{:1362}{1456:}LRptr:=-268435455;LRproblems:=0;curdir:=0;
{:1456}{1505:}pseudofiles:=-268435455;
{:1505}{1571:}saroot[6]:=-268435455;sanull.hh.lh:=-268435455;
sanull.hh.rh:=-268435455;{:1571}{1590:}sachain:=-268435455;salevel:=0;
{:1590}{1614:}discptr[2]:=-268435455;discptr[3]:=-268435455;
{:1614}{1622:}editnamestart:=0;stopatspace:=true;
{:1622}{1626:}ifdef('TEXMF_DEBUG')debugformatfile:=true;
endif('TEXMF_DEBUG');{:1626}{1635:}mltexenabledp:=false;
{:1635}{1695:}inhibitglueflag:=false;{:1695}{1711:}pagedir:=4;
{:1711}ifdef('INITEX')if iniversion then begin{170:}for k:=membot+1 to
membot+23 do mem[k].int:=0;k:=membot;
while k<=membot+23 do begin mem[k].hh.rh:=-268435454;mem[k].hh.b0:=0;
mem[k].hh.b1:=0;k:=k+4;end;mem[membot+6].int:=65536;
mem[membot+4].hh.b0:=1;mem[membot+10].int:=65536;mem[membot+8].hh.b0:=2;
mem[membot+14].int:=65536;mem[membot+12].hh.b0:=3;
mem[membot+18].int:=65536;mem[membot+16].hh.b0:=2;
mem[membot+19].int:=65536;mem[membot+16].hh.b1:=2;
mem[membot+22].int:=-65536;mem[membot+20].hh.b0:=2;rover:=membot+24;
mem[rover].hh.rh:=268435455;mem[rover].hh.lh:=1000;
mem[rover+1].hh.lh:=rover;mem[rover+1].hh.rh:=rover;
lomemmax:=rover+1000;mem[lomemmax].hh.rh:=-268435455;
mem[lomemmax].hh.lh:=-268435455;
for k:=memtop-13 to memtop do mem[k]:=mem[lomemmax];
{807:}mem[memtop-10].hh.lh:=81054;
{:807}{814:}mem[memtop-9].hh.rh:=65536;mem[memtop-9].hh.lh:=-268435455;
{:814}{837:}mem[memtop-7].hh.b0:=1;mem[memtop-6].hh.lh:=268435455;
mem[memtop-7].hh.b1:=0;{:837}{998:}mem[memtop].hh.b1:=255;
mem[memtop].hh.b0:=1;mem[memtop].hh.rh:=memtop;
{:998}{1005:}mem[memtop-2].hh.b0:=12;mem[memtop-2].hh.b1:=0;{:1005};
avail:=-268435455;memend:=memtop;himemmin:=memtop-13;
varused:=membot+24-membot;dynused:=14;
{:170}{228:}eqtb[24527].hh.b0:=113;eqtb[24527].hh.rh:=-268435455;
eqtb[24527].hh.b1:=0;for k:=1 to eqtbtop do eqtb[k]:=eqtb[24527];
{:228}{234:}eqtb[24528].hh.rh:=membot;eqtb[24528].hh.b1:=1;
eqtb[24528].hh.b0:=129;for k:=24529 to 25060 do eqtb[k]:=eqtb[24528];
mem[membot].hh.rh:=mem[membot].hh.rh+533;
{:234}{238:}eqtb[25061].hh.rh:=-268435455;eqtb[25061].hh.b0:=130;
eqtb[25061].hh.b1:=1;for k:=25328 to 25331 do eqtb[k]:=eqtb[25061];
for k:=25062 to 25327 do eqtb[k]:=eqtb[24527];
eqtb[25332].hh.rh:=-268435455;eqtb[25332].hh.b0:=131;
eqtb[25332].hh.b1:=1;for k:=25333 to 25587 do eqtb[k]:=eqtb[25332];
eqtb[25588].hh.rh:=0;eqtb[25588].hh.b0:=132;eqtb[25588].hh.b1:=1;
eqtb[26357].hh.rh:=0;eqtb[26357].hh.b0:=132;eqtb[26357].hh.b1:=1;
eqtb[26358].hh.rh:=0;eqtb[26358].hh.b0:=132;eqtb[26358].hh.b1:=1;
for k:=25589 to 26356 do eqtb[k]:=eqtb[25588];eqtb[26361].hh.rh:=0;
eqtb[26361].hh.b0:=132;eqtb[26361].hh.b1:=1;
for k:=26362 to 28930 do eqtb[k]:=eqtb[26361];eqtb[26359]:=eqtb[26361];
eqtb[26360]:=eqtb[26361];
for k:=0 to 255 do begin eqtb[26361+k].hh.rh:=12;
eqtb[26617+k].hh.rh:=18;eqtb[28419+k].hh.rh:=k;
eqtb[28163+k].hh.rh:=1000;eqtb[26873+k].hh.rh:=0;eqtb[27129+k].hh.rh:=0;
eqtb[27129+k].hh.b0:=0;eqtb[27385+k].hh.rh:=0;eqtb[27385+k].hh.b0:=0;
end;eqtb[26374].hh.rh:=5;eqtb[26393].hh.rh:=10;eqtb[26453].hh.rh:=0;
eqtb[26398].hh.rh:=14;eqtb[26488].hh.rh:=15;eqtb[26361].hh.rh:=9;
for k:=48 to 57 do begin eqtb[28419+k].hh.rh:=k+458752;
eqtb[26873+k].hh.rh:=3;end;eqtb[27641].hh.rh:=toDVI(fromJIS(8507));
eqtb[27642].hh.rh:=toDVI(fromJIS(12396));
eqtb[27643].hh.rh:=toDVI(fromJIS(18035));
eqtb[27644].hh.rh:=toDVI(fromJIS(15152));
eqtb[27645].hh.rh:=toDVI(fromJIS(15181));
eqtb[27646].hh.rh:=toDVI(fromJIS(14430));
eqtb[27647].hh.rh:=toDVI(fromJIS(20283));
eqtb[27648].hh.rh:=toDVI(fromJIS(15415));
eqtb[27649].hh.rh:=toDVI(fromJIS(18476));
eqtb[27650].hh.rh:=toDVI(fromJIS(13925));
for k:=65 to 90 do begin eqtb[26361+k].hh.rh:=11;
eqtb[26361+k+32].hh.rh:=11;eqtb[28419+k].hh.rh:=k+459008;
eqtb[28419+k+32].hh.rh:=k+459040;eqtb[27651+k].hh.rh:=k+32;
eqtb[27651+k+32].hh.rh:=k+32;eqtb[27907+k].hh.rh:=k;
eqtb[27907+k+32].hh.rh:=k;eqtb[26873+k].hh.rh:=3;
eqtb[26873+k+32].hh.rh:=3;eqtb[28163+k].hh.rh:=999;end;
eqtb[26650].hh.rh:=18;eqtb[26651].hh.rh:=18;
for k:=3 to 6 do eqtb[26649+k].hh.rh:=17;
for k:=7 to 8 do eqtb[26649+k].hh.rh:=18;
for k:=16 to 84 do eqtb[26649+k].hh.rh:=16;
{:238}{246:}for k:=28931 to 29257 do eqtb[k].int:=0;
eqtb[28988].int:=256;eqtb[28989].int:=-1;eqtb[28948].int:=1000;
eqtb[28932].int:=10000;eqtb[28972].int:=1;eqtb[28971].int:=25;
eqtb[28977].int:=92;eqtb[28980].int:=13;
for k:=0 to 255 do begin eqtb[29258+k].int:=-1;
setintone(eqtb[29258+k],-1);end;eqtb[29304].int:=0;
setintone(eqtb[29304],0);
{:246}{256:}for k:=29514 to 30050 do eqtb[k].int:=0;
{:256}{265:}hashused:=15514;hashhigh:=0;cscount:=0;
eqtb[15523].hh.b0:=128;primused:=2100;hash[15523].rh:=538;
eqtb[15525].hh.b0:=42;eqtb[15525].hh.rh:=1;eqtb[15525].hh.b1:=1;
hash[15525].rh:=539;
{:265}{569:}{:569}{963:}for k:=-trieopsize to trieopsize do trieophash[k
]:=0;for k:=0 to 255 do trieused[k]:=mintrieop;maxopused:=mintrieop;
trieopptr:=0;{:963}{968:}trienotready:=true;
{:968}{1234:}hash[15514].rh:=1315;
{:1234}{1320:}if iniversion then formatident:=1390;
{:1320}{1388:}hash[15522].rh:=1433;eqtb[15522].hh.b1:=1;
eqtb[15522].hh.b0:=125;eqtb[15522].hh.rh:=-268435455;
{:1388}{1403:}eTeXmode:=0;{1566:}maxregnum:=255;maxreghelpline:=749;
{:1566}{:1403}{1572:}for i:=0 to 5 do saroot[i]:=-268435455;
{:1572}{1608:}{:1608}end;endif('INITEX'){:8}{1653:}synctexoffset:=28991;
{:1653}end;{58:}procedure println;
begin case selector of 19:begin if kcodepos=1 then begin write(stdout,
' ');write(logfile,' ');end;writeln(stdout);writeln(logfile);
termoffset:=0;fileoffset:=0;end;
18:begin if kcodepos=1 then write(logfile,' ');writeln(logfile);
fileoffset:=0;end;17:begin if kcodepos=1 then write(stdout,' ');
writeln(stdout);termoffset:=0;end;16,20,21:;
others:writeln(writefile[selector])end;kcodepos:=0;end;
{:58}{59:}procedure printchar(s:ASCIIcode);label 10;
begin if{250:}s=eqtb[28981].int{:250}then if selector<20 then begin
println;goto 10;end;
if kcodepos=1 then kcodepos:=2 else if iskanji1(xchr[s])then begin
kcodepos:=1;
if(selector=19)or(selector=18)then if fileoffset>=maxprintline-1 then
begin writeln(logfile);fileoffset:=0;end;
if(selector=19)or(selector=17)then if termoffset>=maxprintline-1 then
begin writeln(stdout);termoffset:=0;end;end else kcodepos:=0;
case selector of 19:begin write(stdout,xchr[s]);incr(termoffset);
if termoffset=maxprintline then begin writeln(stdout);termoffset:=0;end;
write(logfile,xchr[s]);incr(fileoffset);
if fileoffset=maxprintline then begin writeln(logfile);fileoffset:=0;
end;end;18:begin write(logfile,xchr[s]);incr(fileoffset);
if fileoffset=maxprintline then println;end;
17:begin write(stdout,xchr[s]);incr(termoffset);
if termoffset=maxprintline then println;end;16:;
20:if tally<trickcount then begin trickbuf[tally mod errorline]:=s;
trickbuf2[tally mod errorline]:=kcodepos;end;
21:begin if poolptr<poolsize then begin strpool[poolptr]:=s;
incr(poolptr);end;end;others:write(writefile[selector],xchr[s])end;
incr(tally);10:end;{:59}{60:}procedure print(s:integer);label 10;
var j:poolpointer;nl:integer;
begin if s>=strptr then s:=260 else if s<256 then if s<0 then s:=260
else begin if selector>20 then begin printchar(s);goto 10;end;
if({250:}s=eqtb[28981].int{:250})then if selector<20 then begin println;
goto 10;end;nl:=eqtb[28981].int;eqtb[28981].int:=-1;j:=strstart[s];
while j<strstart[s+1]do begin printchar(strpool[j]);incr(j);end;
eqtb[28981].int:=nl;goto 10;end;j:=strstart[s];
while j<strstart[s+1]do begin printchar(strpool[j]);incr(j);end;10:end;
{:60}{61:}procedure slowprint(s:integer);var j:poolpointer;
begin if(s>=strptr)or(s<256)then print(s)else begin j:=strstart[s];
while j<strstart[s+1]do begin print(strpool[j]);incr(j);end;end;end;
{:61}{63:}procedure printnl(s:strnumber);
begin if((termoffset>0)and(odd(selector)))or((fileoffset>0)and(selector
>=18))then println;print(s);end;
{:63}{64:}procedure printesc(s:strnumber);var c:integer;
begin{249:}c:=eqtb[28977].int{:249};if c>=0 then if c<256 then print(c);
slowprint(s);end;{:64}{65:}procedure printthedigs(k:eightbits);
begin while k>0 do begin decr(k);
if dig[k]<10 then printchar(48+dig[k])else printchar(55+dig[k]);end;end;
{:65}{66:}procedure printint(n:integer);var k:0..23;m:integer;
begin k:=0;if n<0 then begin printchar(45);
if n>-100000000 then n:=-n else begin m:=-1-n;n:=m div 10;
m:=(m mod 10)+1;k:=1;if m<10 then dig[0]:=m else begin dig[0]:=0;
incr(n);end;end;end;repeat dig[k]:=n mod 10;n:=n div 10;incr(k);
until n=0;printthedigs(k);end;{:66}{272:}procedure printcs(p:integer);
begin if p<514 then if p>=257 then if p=513 then begin printesc(542);
printesc(543);printchar(32);end else begin printesc(p-257);
if eqtb[26361+p-257].hh.rh=11 then printchar(32);
end else if p<1 then printesc(544)else print(p-1)else if((p>=24527)and(p
<=30050))or(p>eqtbtop)then printesc(544)else if(hash[p].rh>=strptr)then
printesc(545)else begin printesc(hash[p].rh);printchar(32);end;end;
{:272}{273:}procedure sprintcs(p:halfword);
begin if p<514 then if p<257 then print(p-1)else if p<513 then printesc(
p-257)else begin printesc(542);printesc(543);
end else printesc(hash[p].rh);end;
{:273}{535:}procedure printfilename(n,a,e:integer);
var mustquote:boolean;j:poolpointer;begin mustquote:=false;
if a<>0 then begin j:=strstart[a];
while(not mustquote)and(j<strstart[a+1])do begin mustquote:=strpool[j]=
32;incr(j);end;end;if n<>0 then begin j:=strstart[n];
while(not mustquote)and(j<strstart[n+1])do begin mustquote:=strpool[j]=
32;incr(j);end;end;if e<>0 then begin j:=strstart[e];
while(not mustquote)and(j<strstart[e+1])do begin mustquote:=strpool[j]=
32;incr(j);end;end;if mustquote then printchar(34);
if a<>0 then for j:=strstart[a]to strstart[a+1]-1 do if strpool[j]<>34
then print(strpool[j]);
if n<>0 then for j:=strstart[n]to strstart[n+1]-1 do if strpool[j]<>34
then print(strpool[j]);
if e<>0 then for j:=strstart[e]to strstart[e+1]-1 do if strpool[j]<>34
then print(strpool[j]);if mustquote then printchar(34);end;
{:535}{716:}procedure printsize(s:integer);
begin if s=0 then printesc(433)else if s=256 then printesc(434)else
printesc(435);end;{:716}{1374:}procedure printwritewhatsit(s:strnumber;
p:halfword);begin printesc(s);
if mem[p+1].hh.lh<16 then printint(mem[p+1].hh.lh)else if mem[p+1].hh.lh
=16 then printchar(42)else printchar(45);end;
{:1374}{1576:}procedure printsanum(q:halfword);var n:halfword;
begin if mem[q].hh.b0<32 then n:=mem[q+1].hh.rh else begin n:=mem[q].hh.
b0 mod 16;q:=mem[q].hh.rh;n:=n+16*mem[q].hh.b0;q:=mem[q].hh.rh;
n:=n+256*(mem[q].hh.b0+16*mem[mem[q].hh.rh].hh.b0);
q:=mem[mem[q].hh.rh].hh.rh;n:=n+65536*mem[q].hh.b0;end;printint(n);end;
{:1576}{1624:}procedure printcsnames(hstart:integer;hfinish:integer);
var c,h:integer;
begin writeln(stderr,'fmtdebug:csnames from ',hstart,' to ',hfinish,':')
;for h:=hstart to hfinish do begin if hash[h].rh>0 then begin for c:=
strstart[hash[h].rh]to strstart[hash[h].rh+1]-1 do begin putbyte(strpool
[c],stderr);end;writeln(stderr,'|');end;end;end;
{:1624}{1627:}procedure printfileline;var level:0..maxinopen;
begin level:=inopen;
while(level>0)and(fullsourcefilenamestack[level]=0)do decr(level);
if level=0 then printnl(263)else begin printnl(343);
print(fullsourcefilenamestack[level]);print(58);
if level=inopen then printint(line)else printint(linestack[level+1]);
print(617);end;end;{:1627}{1731:}procedure printdir(dir:eightbits);
begin if dir=4 then printchar(89)else if dir=3 then printchar(84)else if
dir=1 then printchar(68)end;procedure printdirectionalt(d:integer);
var x:boolean;begin x:=false;case abs(d)of 4:begin print(1591);x:=true;
end;3:begin print(1592);x:=true;end;1:begin print(1593);x:=true;end;end;
if x then begin if d<0 then print(1594);print(1595);end;end;
procedure printdirection(d:integer);begin case abs(d)of 4:print(1162);
3:print(1161);1:print(1163);end;if d<0 then print(1594);print(1595);end;
{:1731}{1737:}procedure printkanji(s:integer);
begin if s>255 then begin if isprintutf8 then begin s:=UCStoUTF8(toUCS(s
));if BYTE1(s)<>0 then printchar(BYTE1(s));
if BYTE2(s)<>0 then printchar(BYTE2(s));
if BYTE3(s)<>0 then printchar(BYTE3(s));printchar(BYTE4(s));
end else begin printchar(Hi(s));printchar(Lo(s));end;
end else printchar(s);end;{:1737}{79:}procedure normalizeselector;
forward;procedure gettoken;forward;procedure terminput;forward;
procedure showcontext;forward;procedure beginfilereading;forward;
procedure openlogfile;forward;procedure closefilesandterminate;forward;
procedure clearforerrorprompt;forward;procedure giveerrhelp;forward;
ifdef('TEXMF_DEBUG')procedure debughelp;forward;
endif('TEXMF_DEBUG'){:79}{82:}noreturn procedure jumpout;
begin closefilesandterminate;begin fflush(stdout);readyalready:=0;
if(history<>0)and(history<>1)then uexit(1)else uexit(0);end;end;
{:82}{83:}procedure error;label 22,10;var c:ASCIIcode;
s1,s2,s3,s4:integer;begin if history<2 then history:=2;printchar(46);
showcontext;if(haltonerrorp)then begin history:=3;jumpout;end;
if interaction=3 then{84:}while true do begin 22:clearforerrorprompt;
begin;print(265);terminput;end;if last=first then goto 10;
c:=buffer[first];if c>=97 then c:=c-32;
{85:}case c of 48,49,50,51,52,53,54,55,56,57:if deletionsallowed then
{89:}begin s1:=curtok;s2:=curcmd;s3:=curchr;s4:=alignstate;
alignstate:=1000000;OKtointerrupt:=false;
if(last>first+1)and(buffer[first+1]>=48)and(buffer[first+1]<=57)then c:=
c*10+buffer[first+1]-48*11 else c:=c-48;while c>0 do begin gettoken;
decr(c);end;curtok:=s1;curcmd:=s2;curchr:=s3;alignstate:=s4;
OKtointerrupt:=true;begin helpptr:=2;helpline[1]:=278;helpline[0]:=279;
end;showcontext;goto 22;end{:89};ifdef('TEXMF_DEBUG')68:begin debughelp;
goto 22;end;
endif('TEXMF_DEBUG')69:if baseptr>0 then begin editnamestart:=strstart[
inputstack[baseptr].namefield];
editnamelength:=strstart[inputstack[baseptr].namefield+1]-strstart[
inputstack[baseptr].namefield];editline:=line;jumpout;end;
72:{90:}begin if useerrhelp then begin giveerrhelp;useerrhelp:=false;
end else begin if helpptr=0 then begin helpptr:=2;helpline[1]:=280;
helpline[0]:=281;end;repeat decr(helpptr);print(helpline[helpptr]);
println;until helpptr=0;end;begin helpptr:=4;helpline[3]:=282;
helpline[2]:=281;helpline[1]:=283;helpline[0]:=284;end;goto 22;end{:90};
73:{88:}begin beginfilereading;
if last>first+1 then begin curinput.locfield:=first+1;buffer[first]:=32;
end else begin begin;print(277);terminput;end;curinput.locfield:=first;
end;first:=last;curinput.limitfield:=last-1;goto 10;end{:88};
81,82,83:{87:}begin errorcount:=0;interaction:=0+c-81;print(272);
case c of 81:begin printesc(273);decr(selector);end;82:printesc(274);
83:printesc(275);end;print(276);println;fflush(stdout);goto 10;end{:87};
88:begin interaction:=2;jumpout;end;others:end;{86:}begin print(266);
printnl(267);printnl(268);if baseptr>0 then print(269);
if deletionsallowed then printnl(270);printnl(271);end{:86}{:85};
end{:84};incr(errorcount);if errorcount=100 then begin printnl(264);
history:=3;jumpout;end;{91:}if interaction>0 then decr(selector);
if useerrhelp then begin println;giveerrhelp;
end else while helpptr>0 do begin decr(helpptr);
printnl(helpline[helpptr]);end;println;
if interaction>0 then incr(selector);println{:91};10:end;
{:83}{94:}noreturn procedure fatalerror(s:strnumber);
begin normalizeselector;begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(286);
end;begin helpptr:=1;helpline[0]:=s;end;
begin if interaction=3 then interaction:=2;if logopened then error;
ifdef('TEXMF_DEBUG')if interaction>0 then debughelp;
endif('TEXMF_DEBUG')history:=3;jumpout;end;end;
{:94}{95:}noreturn procedure overflow(s:strnumber;n:integer);
begin normalizeselector;begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(287);
end;print(s);printchar(61);printint(n);printchar(93);begin helpptr:=2;
helpline[1]:=288;helpline[0]:=289;end;
begin if interaction=3 then interaction:=2;if logopened then error;
ifdef('TEXMF_DEBUG')if interaction>0 then debughelp;
endif('TEXMF_DEBUG')history:=3;jumpout;end;end;
{:95}{96:}noreturn procedure confusion(s:strnumber);
begin normalizeselector;
if history<2 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(290);
end;print(s);printchar(41);begin helpptr:=1;helpline[0]:=291;end;
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(292);
end;begin helpptr:=2;helpline[1]:=293;helpline[0]:=294;end;end;
begin if interaction=3 then interaction:=2;if logopened then error;
ifdef('TEXMF_DEBUG')if interaction>0 then debughelp;
endif('TEXMF_DEBUG')history:=3;jumpout;end;end;
{:96}{:4}{32:}{[36:]begin curinput.locfield:=first;
curinput.limitfield:=last-1;overflow(257,bufsize);end[:36]}
{:32}{38:}function initterminal:boolean;label 10;begin topenin;
if last>first then begin curinput.locfield:=first;
while(curinput.locfield<last)and(buffer[curinput.locfield]=' ')do incr(
curinput.locfield);
if curinput.locfield<last then begin initterminal:=true;goto 10;end;end;
while true do begin;write(stdout,'**');fflush(stdout);
if not inputln(stdin,true)then begin writeln(stdout);
writeln(stdout,'! End of file on the terminal... why?');
initterminal:=false;goto 10;end;curinput.locfield:=first;
while(curinput.locfield<last)and(buffer[curinput.locfield]=32)do incr(
curinput.locfield);
if curinput.locfield<last then begin initterminal:=true;goto 10;end;
writeln(stdout,'Please type the name of your input file.');end;10:end;
{:38}{44:}function makestring:strnumber;
begin if strptr=maxstrings then overflow(259,maxstrings-initstrptr);
incr(strptr);strstart[strptr]:=poolptr;makestring:=strptr-1;end;
{:44}{46:}function streqbuf(s:strnumber;k:integer):boolean;label 45;
var j:poolpointer;result:boolean;begin j:=strstart[s];
while j<strstart[s+1]do begin if strpool[j]<>buffer[k]then begin result
:=false;goto 45;end;incr(j);incr(k);end;result:=true;
45:streqbuf:=result;end;
{:46}{47:}function streqstr(s,t:strnumber):boolean;label 45;
var j,k:poolpointer;result:boolean;begin result:=false;
if(strstart[s+1]-strstart[s])<>(strstart[t+1]-strstart[t])then goto 45;
j:=strstart[s];k:=strstart[t];
while j<strstart[s+1]do begin if strpool[j]<>strpool[k]then goto 45;
incr(j);incr(k);end;result:=true;45:streqstr:=result;end;
{:47}{48:}{1631:}function searchstring(search:strnumber):strnumber;
label 40;var result:strnumber;s:strnumber;len:integer;begin result:=0;
len:=(strstart[search+1]-strstart[search]);
if len=0 then begin result:=343;goto 40;end else begin s:=search-1;
while s>255 do begin if(strstart[s+1]-strstart[s])=len then if streqstr(
s,search)then begin result:=s;goto 40;end;decr(s);end;end;
40:searchstring:=result;end;
{:1631}{1632:}function slowmakestring:strnumber;label 10;
var s:strnumber;t:strnumber;begin t:=makestring;s:=searchstring(t);
if s>0 then begin begin decr(strptr);poolptr:=strstart[strptr];end;
slowmakestring:=s;goto 10;end;slowmakestring:=t;10:end;
{:1632}ifdef('INITEX')function getstringsstarted:boolean;label 30,10;
var k,l:KANJIcode;g:strnumber;begin poolptr:=0;strptr:=0;strstart[0]:=0;
{49:}for k:=0 to 255 do begin if({50:}not(ismultiprn(k)or xprn[k]){:50})
then begin begin strpool[poolptr]:=94;incr(poolptr);end;
begin strpool[poolptr]:=94;incr(poolptr);end;
if k<64 then begin strpool[poolptr]:=k+64;incr(poolptr);
end else if k<128 then begin strpool[poolptr]:=k-64;incr(poolptr);
end else begin l:=k div 16;if l<10 then begin strpool[poolptr]:=l+48;
incr(poolptr);end else begin strpool[poolptr]:=l+87;incr(poolptr);end;
l:=k mod 16;if l<10 then begin strpool[poolptr]:=l+48;incr(poolptr);
end else begin strpool[poolptr]:=l+87;incr(poolptr);end;end;
end else begin strpool[poolptr]:=k;incr(poolptr);end;g:=makestring;
end{:49};{52:}g:=loadpoolstrings((poolsize-stringvacancies));
if g=0 then begin;writeln(stdout,'! You have to increase POOLSIZE.');
getstringsstarted:=false;goto 10;end;getstringsstarted:=true;{:52};
10:end;endif('INITEX'){:48}{67:}procedure printtwo(n:integer);
begin n:=abs(n)mod 100;printchar(48+(n div 10));
printchar(48+(n mod 10));end;{:67}{68:}procedure printhex(n:integer);
var k:0..22;begin k:=0;printchar(34);repeat dig[k]:=n mod 16;
n:=n div 16;incr(k);until n=0;printthedigs(k);end;
{:68}{70:}procedure printromanint(n:integer);label 10;
var j,k:poolpointer;u,v:nonnegativeinteger;begin j:=strstart[261];
v:=1000;while true do begin while n>=v do begin printchar(strpool[j]);
n:=n-v;end;if n<=0 then goto 10;k:=j+2;u:=v div(strpool[k-1]-48);
if strpool[k-1]=50 then begin k:=k+2;u:=u div(strpool[k-1]-48);end;
if n+u>=v then begin printchar(strpool[k]);n:=n+u;end else begin j:=j+2;
v:=v div(strpool[j-1]-48);end;end;10:end;
{:70}{71:}procedure printcurrentstring;var j:poolpointer;
begin j:=strstart[strptr];
while j<poolptr do begin printchar(strpool[j]);incr(j);end;end;
{:71}{72:}procedure terminput;var k:0..bufsize;begin fflush(stdout);
if not inputln(stdin,true)then fatalerror(262);termoffset:=0;
decr(selector);
if last<>first then for k:=first to last-1 do print(buffer[k]);println;
incr(selector);end;{:72}{92:}procedure interror(n:integer);
begin print(285);printint(n);printchar(41);error;end;
{:92}{93:}procedure normalizeselector;
begin if logopened then selector:=19 else selector:=17;
if jobname=0 then openlogfile;if interaction=0 then decr(selector);end;
{:93}{99:}procedure pauseforinstructions;
begin if OKtointerrupt then begin interaction:=3;
if(selector=18)or(selector=16)then incr(selector);
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(295);
end;begin helpptr:=3;helpline[2]:=296;helpline[1]:=297;helpline[0]:=298;
end;deletionsallowed:=false;error;deletionsallowed:=true;interrupt:=0;
end;end;{:99}{101:}function half(x:integer):integer;
begin if odd(x)then half:=(x+1)div 2 else half:=x div 2;end;
{:101}{103:}function rounddecimals(k:smallnumber):scaled;var a:integer;
begin a:=0;while k>0 do begin decr(k);a:=(a+dig[k]*131072)div 10;end;
rounddecimals:=(a+1)div 2;end;
{:103}{104:}procedure printscaled(s:scaled);var delta:scaled;
begin if s<0 then begin printchar(45);s:=-s;end;printint(s div 65536);
printchar(46);s:=10*(s mod 65536)+5;delta:=10;
repeat if delta>65536 then s:=s-17232;printchar(48+(s div 65536));
s:=10*(s mod 65536);delta:=delta*10;until s<=delta;end;
{:104}{106:}function multandadd(n:integer;x,y,maxanswer:scaled):scaled;
begin if n<0 then begin x:=-x;n:=-n;end;
if n=0 then multandadd:=y else if((x<=(maxanswer-y)div n)and(-x<=(
maxanswer+y)div n))then multandadd:=n*x+y else begin aritherror:=true;
multandadd:=0;end;end;{:106}{107:}function xovern(x:scaled;
n:integer):scaled;var negative:boolean;begin negative:=false;
if n=0 then begin aritherror:=true;xovern:=0;texremainder:=x;
end else begin if n<0 then begin x:=-x;n:=-n;negative:=true;end;
if x>=0 then begin xovern:=x div n;texremainder:=x mod n;
end else begin xovern:=-((-x)div n);texremainder:=-((-x)mod n);end;end;
if negative then texremainder:=-texremainder;end;
{:107}{108:}function xnoverd(x:scaled;n,d:integer):scaled;
var positive:boolean;t,u,v:nonnegativeinteger;
begin if x>=0 then positive:=true else begin x:=-x;positive:=false;end;
t:=(x mod 32768)*n;u:=(x div 32768)*n+(t div 32768);
v:=(u mod d)*32768+(t mod 32768);
if u div d>=32768 then aritherror:=true else u:=32768*(u div d)+(v div d
);if positive then begin xnoverd:=u;texremainder:=v mod d;
end else begin xnoverd:=-u;texremainder:=-(v mod d);end;end;
{:108}{109:}function badness(t,s:scaled):halfword;var r:integer;
begin if t=0 then badness:=0 else if s<=0 then badness:=10000 else begin
if t<=7230584 then r:=(t*297)div s else if s>=1663497 then r:=t div(s
div 297)else r:=t;
if r>1290 then badness:=10000 else badness:=(r*r*r+131072)div 262144;
end;end;
{:109}{115:}ifdef('TEXMF_DEBUG')procedure printword(w:memoryword);
begin printint(w.int);printchar(32);printscaled(w.int);printchar(32);
printscaled(round(65536*w.gr));println;printint(w.hh.lh);printchar(61);
printint(w.hh.b0);printchar(58);printint(w.hh.b1);printchar(59);
printint(w.hh.rh);printchar(32);printint(w.qqqq.b0);printchar(58);
printint(w.qqqq.b1);printchar(58);printint(w.qqqq.b2);printchar(58);
printint(w.qqqq.b3);end;
endif('TEXMF_DEBUG'){:115}{120:}{302:}procedure showtokenlist(p,q:
integer;l:integer);label 10;var m,c:integer;matchchr:ASCIIcode;
n:ASCIIcode;begin matchchr:=35;n:=48;tally:=0;
while(p<>-268435455)and(tally<l)do begin if p=q then{330:}begin
firstcount:=tally;
if(firstcount>0)and(trickbuf2[(firstcount-1)mod errorline]=1)then incr(
firstcount);trickcount:=firstcount+1+errorline-halferrorline;
if trickcount<errorline then trickcount:=errorline;end{:330};
{303:}if(p<himemmin)or(p>memend)then begin printesc(313);goto 10;end;
if mem[p].hh.lh>=65535 then printcs(mem[p].hh.lh-65535)else begin if
checkkanji(mem[p].hh.lh)then begin m:=eqtb[26617+kcatcodekey(mem[p].hh.
lh)].hh.rh;c:=mem[p].hh.lh;end else begin m:=Hi(mem[p].hh.lh);
c:=Lo(mem[p].hh.lh);end;
if(m<16)and(c>256)then printesc(603)else{304:}case m of 16,17,18:
printkanji(c);1,2,3,4,7,8,10,11,12:print(c);6:begin print(c);print(c);
end;5:begin print(matchchr);
if c<=9 then printchar(c+48)else begin printchar(33);goto 10;end;end;
13:begin matchchr:=c;print(c);incr(n);printchar(n);if n>57 then goto 10;
end;14:if c=0 then print(604);others:printesc(603)end{:304};end{:303};
p:=mem[p].hh.rh;end;if p<>-268435455 then printesc(429);10:end;
{:302}{316:}procedure runaway;var p:halfword;
begin if scannerstatus>1 then begin case scannerstatus of 2:begin
printnl(619);p:=defref;end;3:begin printnl(620);p:=memtop-3;end;
4:begin printnl(621);p:=memtop-4;end;5:begin printnl(622);p:=defref;end;
end;printchar(63);println;
showtokenlist(mem[p].hh.rh,-268435455,errorline-10);end;end;
{:316}{:120}{121:}function getavail:halfword;var p:halfword;
begin p:=avail;
if p<>-268435455 then avail:=mem[avail].hh.rh else if memend<memmax then
begin incr(memend);p:=memend;end else begin decr(himemmin);p:=himemmin;
if himemmin<=lomemmax then begin runaway;overflow(299,memmax+1-memmin);
end;end;mem[p].hh.rh:=-268435455;ifdef('STAT')incr(dynused);
endif('STAT')getavail:=p;end;
{:121}{124:}procedure flushlist(p:halfword);var q,r:halfword;
begin if p<>-268435455 then begin r:=p;repeat q:=r;r:=mem[r].hh.rh;
ifdef('STAT')decr(dynused);endif('STAT')until r=-268435455;
mem[q].hh.rh:=avail;avail:=p;end;end;
{:124}{126:}function getnode(s:integer):halfword;label 40,10,20;
var p:halfword;q:halfword;r:integer;t:integer;begin 20:p:=rover;
repeat{128:}q:=p+mem[p].hh.lh;
while(mem[q].hh.rh=268435455)do begin t:=mem[q+1].hh.rh;
if q=rover then rover:=t;mem[t+1].hh.lh:=mem[q+1].hh.lh;
mem[mem[q+1].hh.lh+1].hh.rh:=t;q:=q+mem[q].hh.lh;end;r:=q-s;
if r>p+1 then{129:}begin mem[p].hh.lh:=r-p;rover:=p;goto 40;end{:129};
if r=p then if mem[p+1].hh.rh<>p then{130:}begin rover:=mem[p+1].hh.rh;
t:=mem[p+1].hh.lh;mem[rover+1].hh.lh:=t;mem[t+1].hh.rh:=rover;goto 40;
end{:130};mem[p].hh.lh:=q-p{:128};p:=mem[p+1].hh.rh;until p=rover;
if s=1073741824 then begin getnode:=268435455;goto 10;end;
if lomemmax+2<himemmin then if lomemmax+2<=membot+268435455 then{127:}
begin if himemmin-lomemmax>=1998 then t:=lomemmax+1000 else t:=lomemmax
+1+(himemmin-lomemmax)div 2;p:=mem[rover+1].hh.lh;q:=lomemmax;
mem[p+1].hh.rh:=q;mem[rover+1].hh.lh:=q;
if t>membot+268435455 then t:=membot+268435455;mem[q+1].hh.rh:=rover;
mem[q+1].hh.lh:=p;mem[q].hh.rh:=268435455;mem[q].hh.lh:=t-lomemmax;
lomemmax:=t;mem[lomemmax].hh.rh:=-268435455;
mem[lomemmax].hh.lh:=-268435455;rover:=q;goto 20;end{:127};
overflow(299,memmax+1-memmin);40:mem[r].hh.rh:=-268435455;
ifdef('STAT')varused:=varused+s;
endif('STAT'){1657:}if s>=4 then begin mem[r+s-2].int:=curinput.
synctextagfield;mem[r+s-1].int:=line;end;{:1657};getnode:=r;10:end;
{:126}{131:}procedure freenode(p:halfword;s:halfword);var q:halfword;
begin mem[p].hh.lh:=s;mem[p].hh.rh:=268435455;q:=mem[rover+1].hh.lh;
mem[p+1].hh.lh:=q;mem[p+1].hh.rh:=rover;mem[rover+1].hh.lh:=p;
mem[q+1].hh.rh:=p;ifdef('STAT')varused:=varused-s;endif('STAT')end;
{:131}{132:}ifdef('INITEX')procedure sortavail;var p,q,r:halfword;
oldrover:halfword;begin p:=getnode(1073741824);p:=mem[rover+1].hh.rh;
mem[rover+1].hh.rh:=268435455;oldrover:=rover;
while p<>oldrover do{133:}if p<rover then begin q:=p;p:=mem[q+1].hh.rh;
mem[q+1].hh.rh:=rover;rover:=q;end else begin q:=rover;
while mem[q+1].hh.rh<p do q:=mem[q+1].hh.rh;r:=mem[p+1].hh.rh;
mem[p+1].hh.rh:=mem[q+1].hh.rh;mem[q+1].hh.rh:=p;p:=r;end{:133};
p:=rover;
while mem[p+1].hh.rh<>268435455 do begin mem[mem[p+1].hh.rh+1].hh.lh:=p;
p:=mem[p+1].hh.rh;end;mem[p+1].hh.rh:=rover;mem[rover+1].hh.lh:=p;end;
endif('INITEX'){:132}{137:}function newnullbox:halfword;var p:halfword;
begin p:=getnode(10);mem[p].hh.b0:=0;mem[p].hh.b1:=0;mem[p+1].int:=0;
mem[p+2].int:=0;mem[p+3].int:=0;mem[p+4].int:=0;
mem[p+5].hh.rh:=-268435455;mem[p+5].hh.b0:=0;mem[p+5].hh.b1:=0;
mem[p+6].gr:=0.0;mem[p+7].hh.rh:=membot;mem[p+7].hh.lh:=membot;
incr(mem[membot].hh.rh);incr(mem[membot].hh.rh);newnullbox:=p;end;
{:137}{139:}function newdirnode(b:halfword;dir:eightbits):halfword;
var p:halfword;begin if mem[b].hh.b0>1 then confusion(300);
p:=newnullbox;mem[p].hh.b0:=2;mem[p].hh.b1:=((mem[p].hh.b1)div 8)*8+dir;
case((mem[b].hh.b1)mod 8)of 4:{140:}case dir of 3:begin mem[p+1].int:=
mem[b+3].int+mem[b+2].int;mem[p+2].int:=mem[b+1].int/2;
mem[p+3].int:=mem[b+1].int-mem[p+2].int;end;
1:begin mem[p+1].int:=mem[b+3].int+mem[b+2].int;mem[p+2].int:=0;
mem[p+3].int:=mem[b+1].int;end;others:confusion(302);end{:140};
3:{141:}case dir of 4:begin mem[p+1].int:=mem[b+3].int+mem[b+2].int;
mem[p+2].int:=0;mem[p+3].int:=mem[b+1].int;end;
1:begin mem[p+1].int:=mem[b+1].int;mem[p+2].int:=mem[b+3].int;
mem[p+3].int:=mem[b+2].int;end;others:confusion(303);end{:141};
1:{142:}case dir of 4:begin mem[p+1].int:=mem[b+3].int+mem[b+2].int;
mem[p+2].int:=0;mem[p+3].int:=mem[b+1].int;end;
3:begin mem[p+1].int:=mem[b+1].int;mem[p+2].int:=mem[b+3].int;
mem[p+3].int:=mem[b+2].int;end;others:confusion(304);end{:142};
others:confusion(301);end;mem[b].hh.rh:=-268435455;mem[p+5].hh.rh:=b;
newdirnode:=p;end;{:139}{144:}function newrule:halfword;var p:halfword;
begin p:=getnode(6);mem[p].hh.b0:=3;mem[p].hh.b1:=0;
mem[p+1].int:=-1073741824;mem[p+2].int:=-1073741824;
mem[p+3].int:=-1073741824;newrule:=p;end;
{:144}{150:}function newligature(f:internalfontnumber;c:quarterword;
q:halfword):halfword;var p:halfword;begin p:=getnode(2);mem[p].hh.b0:=8;
mem[p+1].hh.b0:=f;mem[p+1].hh.b1:=c;mem[p+1].hh.rh:=q;mem[p].hh.b1:=0;
newligature:=p;end;function newligitem(c:quarterword):halfword;
var p:halfword;begin p:=getnode(2);mem[p].hh.b1:=c;
mem[p+1].hh.rh:=-268435455;newligitem:=p;end;
{:150}{151:}function newdisc:halfword;var p:halfword;
begin p:=getnode(2);mem[p].hh.b0:=9;mem[p].hh.b1:=0;
mem[p+1].hh.lh:=-268435455;mem[p+1].hh.rh:=-268435455;newdisc:=p;end;
{:151}{153:}function newmath(w:scaled;s:smallnumber):halfword;
var p:halfword;begin p:=getnode(4);mem[p].hh.b0:=11;mem[p].hh.b1:=s;
mem[p+1].int:=w;newmath:=p;end;
{:153}{157:}function newspec(p:halfword):halfword;var q:halfword;
begin q:=getnode(4);mem[q]:=mem[p];mem[q].hh.rh:=-268435455;
mem[q+1].int:=mem[p+1].int;mem[q+2].int:=mem[p+2].int;
mem[q+3].int:=mem[p+3].int;newspec:=q;end;
{:157}{158:}function newparamglue(n:smallnumber):halfword;
var p:halfword;q:halfword;begin p:=getnode(4);mem[p].hh.b0:=12;
mem[p].hh.b1:=n+1;mem[p+1].hh.rh:=-268435455;
q:={230:}eqtb[24528+n].hh.rh{:230};mem[p+1].hh.lh:=q;incr(mem[q].hh.rh);
newparamglue:=p;end;{:158}{159:}function newglue(q:halfword):halfword;
var p:halfword;begin p:=getnode(4);mem[p].hh.b0:=12;mem[p].hh.b1:=0;
mem[p+1].hh.rh:=-268435455;mem[p+1].hh.lh:=q;incr(mem[q].hh.rh);
newglue:=p;end;
{:159}{160:}function newskipparam(n:smallnumber):halfword;
var p:halfword;begin tempptr:=newspec({230:}eqtb[24528+n].hh.rh{:230});
p:=newglue(tempptr);mem[tempptr].hh.rh:=-268435455;mem[p].hh.b1:=n+1;
newskipparam:=p;end;{:160}{162:}function newkern(w:scaled):halfword;
var p:halfword;begin p:=getnode(4);mem[p].hh.b0:=13;mem[p].hh.b1:=0;
mem[p+1].int:=w;newkern:=p;end;
{:162}{164:}function newpenalty(m:integer):halfword;var p:halfword;
begin p:=getnode(4);mem[p].hh.b0:=14;mem[p].hh.b1:=0;mem[p+1].int:=m;
newpenalty:=p;end;
{:164}{173:}ifdef('TEXMF_DEBUG')procedure checkmem(printlocs:boolean);
label 31,32;var p,q:halfword;clobbered:boolean;
begin for p:=memmin to lomemmax do freearr[p]:=false;
for p:=himemmin to memend do freearr[p]:=false;{174:}p:=avail;
q:=-268435455;clobbered:=false;
while p<>-268435455 do begin if(p>memend)or(p<himemmin)then clobbered:=
true else if freearr[p]then clobbered:=true;
if clobbered then begin printnl(305);printint(q);goto 31;end;
freearr[p]:=true;q:=p;p:=mem[q].hh.rh;end;31:{:174};{175:}p:=rover;
q:=-268435455;clobbered:=false;
repeat if(p>=lomemmax)or(p<memmin)then clobbered:=true else if(mem[p+1].
hh.rh>=lomemmax)or(mem[p+1].hh.rh<memmin)then clobbered:=true else if
not((mem[p].hh.rh=268435455))or(mem[p].hh.lh<2)or(p+mem[p].hh.lh>
lomemmax)or(mem[mem[p+1].hh.rh+1].hh.lh<>p)then clobbered:=true;
if clobbered then begin printnl(306);printint(q);goto 32;end;
for q:=p to p+mem[p].hh.lh-1 do begin if freearr[q]then begin printnl(
307);printint(q);goto 32;end;freearr[q]:=true;end;q:=p;
p:=mem[p+1].hh.rh;until p=rover;32:{:175};{176:}p:=memmin;
while p<=lomemmax do begin if(mem[p].hh.rh=268435455)then begin printnl(
308);printint(p);end;while(p<=lomemmax)and not freearr[p]do incr(p);
while(p<=lomemmax)and freearr[p]do incr(p);end{:176};
if printlocs then{177:}begin printnl(309);
for p:=memmin to lomemmax do if not freearr[p]and((p>waslomax)or wasfree
[p])then begin printchar(32);printint(p);end;
for p:=himemmin to memend do if not freearr[p]and((p<washimin)or(p>
wasmemend)or wasfree[p])then begin printchar(32);printint(p);end;
end{:177};for p:=memmin to lomemmax do wasfree[p]:=freearr[p];
for p:=himemmin to memend do wasfree[p]:=freearr[p];wasmemend:=memend;
waslomax:=lomemmax;washimin:=himemmin;end;
endif('TEXMF_DEBUG'){:173}{178:}ifdef('TEXMF_DEBUG')procedure searchmem(
p:halfword);var q:integer;
begin for q:=memmin to lomemmax do begin if mem[q].hh.rh=p then begin
printnl(310);printint(q);printchar(41);end;
if mem[q].hh.lh=p then begin printnl(311);printint(q);printchar(41);end;
end;
for q:=himemmin to memend do begin if mem[q].hh.rh=p then begin printnl(
310);printint(q);printchar(41);end;
if mem[q].hh.lh=p then begin printnl(311);printint(q);printchar(41);end;
end;
{261:}for q:=1 to 25587 do begin if eqtb[q].hh.rh=p then begin printnl(
537);printint(q);printchar(41);end;end{:261};
{295:}if saveptr>0 then for q:=0 to saveptr-1 do begin if savestack[q].
hh.rh=p then begin printnl(595);printint(q);printchar(41);end;end{:295};
{950:}for q:=0 to hyphsize do begin if hyphlist[q]=p then begin printnl(
1035);printint(q);printchar(41);end;end{:950};end;
endif('TEXMF_DEBUG'){1739:}procedure pdferror(t,p:strnumber);
begin normalizeselector;begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1596);
end;if t<>0 then begin print(285);print(t);print(41);end;print(617);
print(p);begin if interaction=3 then interaction:=2;
if logopened then error;
ifdef('TEXMF_DEBUG')if interaction>0 then debughelp;
endif('TEXMF_DEBUG')history:=3;jumpout;end;end;
{:1739}{1749:}function tokenstostring(p:halfword):strnumber;
begin if selector=21 then pdferror(1597,1598);oldsetting:=selector;
selector:=21;showtokenlist(mem[p].hh.rh,-268435455,poolsize-poolptr);
selector:=oldsetting;lasttokensstring:=makestring;
tokenstostring:=lasttokensstring;end;procedure flushstr(s:strnumber);
begin if(s=strptr-1)then begin decr(strptr);poolptr:=strstart[strptr];
end;end;{:1749}{:178}{180:}procedure shortdisplay(p:integer);
var n:integer;
begin while p>memmin do begin if(p>=himemmin)then begin if p<=memend
then begin if mem[p].hh.b0<>fontinshortdisplay then begin if(mem[p].hh.
b0>fontmax)then printchar(42)else{277:}printesc(hash[15526+mem[p].hh.b0]
.rh){:277};printchar(32);fontinshortdisplay:=mem[p].hh.b0;end;
if fontdir[mem[p].hh.b0]<>0 then begin p:=mem[p].hh.rh;
printkanji(mem[p].hh.lh);end else print(mem[p].hh.b1);end;
end else{181:}case mem[p].hh.b0 of 0,1,2,4,10,6,7,15:print(312);
3:printchar(124);12:if mem[p+1].hh.lh<>membot then printchar(32);
11:if mem[p].hh.b1>=4 then print(312)else printchar(36);
8:shortdisplay(mem[p+1].hh.rh);9:begin shortdisplay(mem[p+1].hh.lh);
shortdisplay(mem[p+1].hh.rh);n:=mem[p].hh.b1;
while n>0 do begin if mem[p].hh.rh<>-268435455 then p:=mem[p].hh.rh;
decr(n);end;end;others:end{:181};p:=mem[p].hh.rh;end;end;
{:180}{182:}procedure printfontandchar(p:integer);
begin if p>memend then printesc(313)else begin if(mem[p].hh.b0>fontmax)
then printchar(42)else{277:}printesc(hash[15526+mem[p].hh.b0].rh){:277};
printchar(32);if fontdir[mem[p].hh.b0]<>0 then begin p:=mem[p].hh.rh;
printkanji(mem[p].hh.lh);end else print(mem[p].hh.b1);end;end;
procedure printmark(p:integer);begin printchar(123);
if(p<himemmin)or(p>memend)then printesc(313)else showtokenlist(mem[p].hh
.rh,-268435455,maxprintline-10);printchar(125);end;
procedure printruledimen(d:scaled);
begin if(d=-1073741824)then printchar(42)else printscaled(d);end;
{:182}{183:}procedure printglue(d:scaled;order:integer;s:strnumber);
begin printscaled(d);
if(order<0)or(order>4)then print(314)else if order>0 then begin print(
315);while order>1 do begin printchar(108);decr(order);end;
end else if s<>0 then print(s);end;
{:183}{184:}procedure printspec(p:integer;s:strnumber);
begin if(p<memmin)or(p>=lomemmax)then printchar(42)else begin
printscaled(mem[p+1].int);if s<>0 then print(s);
if mem[p+2].int<>0 then begin print(316);
printglue(mem[p+2].int,mem[p].hh.b0,s);end;
if mem[p+3].int<>0 then begin print(317);
printglue(mem[p+3].int,mem[p].hh.b1,s);end;end;end;
{:184}{185:}{708:}procedure printfamandchar(p:halfword;t:integer);
var cx:KANJIcode;begin printesc(490);printint(mem[p].hh.b0);
printchar(32);
if t=1 then print(mem[p].hh.b1)else begin cx:=mem[p+3].hh.lh;
printkanji(cx);end;end;procedure printdelimiter(p:halfword);
var a:integer;begin a:=mem[p].qqqq.b0*256+mem[p].qqqq.b1;
a:=a*4096+mem[p].qqqq.b2*256+mem[p].qqqq.b3;
if a<0 then printint(a)else printhex(a);end;
{:708}{709:}procedure showinfo;forward;
procedure printsubsidiarydata(p:halfword;c:ASCIIcode);
begin if(poolptr-strstart[strptr])>=depththreshold then begin if mem[p].
hh.rh<>0 then print(318);end else begin begin strpool[poolptr]:=c;
incr(poolptr);end;tempptr:=p;case mem[p].hh.rh of 1,5:begin println;
printcurrentstring;printfamandchar(p,mem[p].hh.rh);end;2:showinfo;
3:if mem[p].hh.lh=-268435455 then begin println;printcurrentstring;
print(953);end else showinfo;others:end;decr(poolptr);end;end;
{:709}{711:}procedure printstyle(c:integer);
begin case c div 2 of 0:printesc(954);1:printesc(955);2:printesc(956);
3:printesc(957);others:print(958)end;end;
{:711}{231:}procedure printskipparam(n:integer);
begin case n of 0:printesc(394);1:printesc(395);2:printesc(396);
3:printesc(397);4:printesc(398);5:printesc(399);6:printesc(400);
7:printesc(401);8:printesc(402);9:printesc(403);10:printesc(404);
11:printesc(405);12:printesc(406);13:printesc(407);14:printesc(408);
17:printesc(409);18:printesc(410);19:printesc(411);15:printesc(412);
16:printesc(413);20:print(414);others:print(415)end;end;
{:231}{:185}{188:}procedure shownodelist(p:integer);label 10;
var n:integer;g:real;
begin if(poolptr-strstart[strptr])>depththreshold then begin if p>
-268435455 then print(318);goto 10;end;n:=0;
while p>memmin do begin println;printcurrentstring;
if p>memend then begin print(319);goto 10;end;incr(n);
if n>breadthmax then begin print(320);goto 10;end;
{189:}if(p>=himemmin)then begin printfontandchar(p);
if fontdir[mem[p].hh.b0]<>0 then p:=mem[p].hh.rh end else case mem[p].hh
.b0 of 0,1,2,15:{190:}begin case mem[p].hh.b0 of 0:printesc(104);
1:printesc(118);2:printesc(323);others:printesc(324)end;print(325);
printscaled(mem[p+3].int);printchar(43);printscaled(mem[p+2].int);
print(326);printscaled(mem[p+1].int);
if mem[p].hh.b0=15 then{191:}begin if mem[p].hh.b1<>0 then begin print(
285);printint(mem[p].hh.b1+1);print(328);end;
if mem[p+6].int<>0 then begin print(329);
printglue(mem[p+6].int,mem[p+5].hh.b1,0);end;
if mem[p+4].int<>0 then begin print(330);
printglue(mem[p+4].int,mem[p+5].hh.b0,0);end;
end{:191}else begin{192:}g:=mem[p+6].gr;
if(g<>0.0)and(mem[p+5].hh.b0<>0)then begin print(331);
if mem[p+5].hh.b0=2 then print(332);
if fabs(g)>20000.0 then begin if g>0.0 then printchar(62)else print(333)
;printglue(20000*65536,mem[p+5].hh.b1,0);
end else printglue(round(65536*g),mem[p+5].hh.b1,0);end{:192};
if mem[p+4].int<>0 then begin print(327);printscaled(mem[p+4].int);end;
if(eTeXmode=1)then{1454:}if(mem[p].hh.b0=0)and(((mem[p].hh.b1)div 8)=2)
then print(1509){:1454};
if((mem[p].hh.b1)mod 8)<>0 then begin printdirectionalt(((mem[p].hh.b1)
mod 8));end;end;begin begin strpool[poolptr]:=46;incr(poolptr);end;
shownodelist(mem[p+5].hh.rh);decr(poolptr);end;end{:190};
3:{193:}begin printesc(334);printruledimen(mem[p+3].int);printchar(43);
printruledimen(mem[p+2].int);print(326);printruledimen(mem[p+1].int);
end{:193};4:{194:}begin printesc(335);printint(mem[p].hh.b1);
printdir(mem[p+5].hh.b1);print(336);printscaled(mem[p+3].int);
print(337);printspec(mem[p+4].hh.rh,0);printchar(44);
printscaled(mem[p+2].int);print(338);printint(mem[p+1].int);
begin begin strpool[poolptr]:=46;incr(poolptr);end;
shownodelist(mem[p+4].hh.lh);decr(poolptr);end;end{:194};
10:{1375:}case mem[p].hh.b1 of 0:begin printwritewhatsit(1421,p);
printchar(61);
printfilename(mem[p+1].hh.rh,mem[p+2].hh.lh,mem[p+2].hh.rh);end;
1:begin printwritewhatsit(644,p);printmark(mem[p+1].hh.rh);end;
2:printwritewhatsit(1422,p);3:begin printesc(1423);
printmark(mem[p+1].hh.rh);end;4:begin printesc(1425);
printint(mem[p+1].hh.rh);print(1429);printint(mem[p+1].hh.b0);
printchar(44);printint(mem[p+1].hh.b1);printchar(41);end;
6:printesc(1426);others:print(1430)end{:1375};5:begin printesc(321);
printscaled(mem[p+1].int);end;
12:{195:}if mem[p].hh.b1>=100 then{196:}begin printesc(343);
if mem[p].hh.b1=101 then printchar(99)else if mem[p].hh.b1=102 then
printchar(120);print(344);printspec(mem[p+1].hh.lh,0);
begin begin strpool[poolptr]:=46;incr(poolptr);end;
shownodelist(mem[p+1].hh.rh);decr(poolptr);end;
end{:196}else begin printesc(339);
if mem[p].hh.b1<>0 then begin printchar(40);
if mem[p].hh.b1<98 then printskipparam(mem[p].hh.b1-1)else if mem[p].hh.
b1=98 then printesc(340)else printesc(341);printchar(41);end;
if mem[p].hh.b1<>98 then begin printchar(32);
if mem[p].hh.b1<98 then printspec(mem[p+1].hh.lh,0)else printspec(mem[p
+1].hh.lh,342);end;end{:195};
13:{197:}if mem[p].hh.b1<>99 then begin printesc(345);
if mem[p].hh.b1<>0 then printchar(32);printscaled(mem[p+1].int);
if mem[p].hh.b1=2 then print(346);end else begin printesc(347);
printscaled(mem[p+1].int);print(342);end{:197};
11:{198:}if mem[p].hh.b1>1 then begin if odd(mem[p].hh.b1)then printesc(
348)else printesc(349);
if mem[p].hh.b1>8 then printchar(82)else if mem[p].hh.b1>4 then
printchar(76)else printchar(77);end else begin printesc(350);
if mem[p].hh.b1=0 then print(351)else print(352);
if mem[p+1].int<>0 then begin print(353);printscaled(mem[p+1].int);end;
end{:198};8:{199:}begin printfontandchar(p+1);print(354);
if mem[p].hh.b1>1 then printchar(124);
fontinshortdisplay:=mem[p+1].hh.b0;shortdisplay(mem[p+1].hh.rh);
if odd(mem[p].hh.b1)then printchar(124);printchar(41);end{:199};
14:{200:}begin printesc(355);printint(mem[p+1].int);
if mem[p].hh.b1=1 then print(356)else if mem[p].hh.b1=2 then print(357);
end{:200};9:{201:}begin printesc(358);
if mem[p].hh.b1>0 then begin print(359);printint(mem[p].hh.b1);end;
begin begin strpool[poolptr]:=46;incr(poolptr);end;
shownodelist(mem[p+1].hh.lh);decr(poolptr);end;
begin strpool[poolptr]:=124;incr(poolptr);end;
shownodelist(mem[p+1].hh.rh);decr(poolptr);end{:201};
6:{202:}begin printesc(360);
if mem[p+1].hh.lh<>0 then begin printchar(115);printint(mem[p+1].hh.lh);
end;printmark(mem[p+1].hh.rh);end{:202};7:{203:}begin printesc(361);
begin begin strpool[poolptr]:=46;incr(poolptr);end;
shownodelist(mem[p+1].int);decr(poolptr);end;end{:203};
{707:}16:printstyle(mem[p].hh.b1);17:{712:}begin printesc(568);
begin strpool[poolptr]:=68;incr(poolptr);end;
shownodelist(mem[p+1].hh.lh);decr(poolptr);begin strpool[poolptr]:=84;
incr(poolptr);end;shownodelist(mem[p+1].hh.rh);decr(poolptr);
begin strpool[poolptr]:=83;incr(poolptr);end;
shownodelist(mem[p+2].hh.lh);decr(poolptr);begin strpool[poolptr]:=115;
incr(poolptr);end;shownodelist(mem[p+2].hh.rh);decr(poolptr);end{:712};
18,19,20,21,22,23,24,25,26,29,28,31,30,32,33:{713:}begin case mem[p].hh.
b0 of 18:printesc(959);19:printesc(960);20:printesc(961);
21:printesc(962);22:printesc(963);23:printesc(964);24:printesc(965);
25:printesc(966);29:printesc(967);28:printesc(968);31:printesc(584);
26:begin printesc(577);printdelimiter(p+5);end;30:begin printesc(546);
printfamandchar(p+5,1);end;32:begin printesc(969);printdelimiter(p+1);
end;33:begin if mem[p].hh.b1=0 then printesc(970)else printesc(971);
printdelimiter(p+1);end;end;
if mem[p].hh.b0<32 then begin if mem[p].hh.b1<>0 then if mem[p].hh.b1=1
then printesc(972)else printesc(973);printsubsidiarydata(p+1,46);end;
printsubsidiarydata(p+2,94);printsubsidiarydata(p+3,95);end{:713};
27:{714:}begin printesc(974);
if mem[p+1].int=1073741824 then print(975)else printscaled(mem[p+1].int)
;
if(mem[p+5].qqqq.b0<>0)or(mem[p+5].qqqq.b1<>0)or(mem[p+5].qqqq.b2<>0)or(
mem[p+5].qqqq.b3<>0)then begin print(976);printdelimiter(p+5);end;
if(mem[p+4].qqqq.b0<>0)or(mem[p+4].qqqq.b1<>0)or(mem[p+4].qqqq.b2<>0)or(
mem[p+4].qqqq.b3<>0)then begin print(977);printdelimiter(p+4);end;
printsubsidiarydata(p+2,92);printsubsidiarydata(p+3,47);end{:714};
{:707}others:print(322)end{:189};p:=mem[p].hh.rh;end;10:end;
{:188}{204:}procedure showbox(p:halfword);
begin{242:}depththreshold:=eqtb[28956].int;
breadthmax:=eqtb[28955].int{:242};if breadthmax<=0 then breadthmax:=5;
if poolptr+depththreshold>=poolsize then depththreshold:=poolsize-
poolptr-1;shownodelist(p);println;end;
{:204}{206:}procedure deletetokenref(p:halfword);
begin if mem[p].hh.lh=-268435455 then flushlist(p)else decr(mem[p].hh.lh
);end;{:206}{207:}procedure deleteglueref(p:halfword);
begin if mem[p].hh.rh=-268435455 then freenode(p,4)else decr(mem[p].hh.
rh);end;{:207}{208:}procedure flushnodelist(p:halfword);label 30;
var q:halfword;begin while p<>-268435455 do begin q:=mem[p].hh.rh;
if(p>=himemmin)then begin mem[p].hh.rh:=avail;avail:=p;
ifdef('STAT')decr(dynused);
endif('STAT')end else begin case mem[p].hh.b0 of 0,1,2,15:begin
flushnodelist(mem[p+5].hh.rh);
begin if mem[mem[p+7].hh.rh].hh.rh=-268435455 then freenode(mem[p+7].hh.
rh,4)else decr(mem[mem[p+7].hh.rh].hh.rh);end;
begin if mem[mem[p+7].hh.lh].hh.rh=-268435455 then freenode(mem[p+7].hh.
lh,4)else decr(mem[mem[p+7].hh.lh].hh.rh);end;freenode(p,10);goto 30;
end;3:begin freenode(p,6);goto 30;end;
4:begin flushnodelist(mem[p+4].hh.lh);deleteglueref(mem[p+4].hh.rh);
freenode(p,6);goto 30;end;
10:{1377:}begin case mem[p].hh.b1 of 0:freenode(p,3);
1,3:begin deletetokenref(mem[p+1].hh.rh);freenode(p,2);goto 30;end;
2,4:freenode(p,2);6:freenode(p,2);others:confusion(1432)end;goto 30;
end{:1377};
12:begin begin if mem[mem[p+1].hh.lh].hh.rh=-268435455 then freenode(mem
[p+1].hh.lh,4)else decr(mem[mem[p+1].hh.lh].hh.rh);end;
if mem[p+1].hh.rh<>-268435455 then flushnodelist(mem[p+1].hh.rh);
freenode(p,4);goto 30;end;5:;13,11,14:begin freenode(p,4);goto 30;end;
8:flushnodelist(mem[p+1].hh.rh);6:deletetokenref(mem[p+1].hh.rh);
9:begin flushnodelist(mem[p+1].hh.lh);flushnodelist(mem[p+1].hh.rh);end;
7:flushnodelist(mem[p+1].int);{715:}16:begin freenode(p,3);goto 30;end;
17:begin flushnodelist(mem[p+1].hh.lh);flushnodelist(mem[p+1].hh.rh);
flushnodelist(mem[p+2].hh.lh);flushnodelist(mem[p+2].hh.rh);
freenode(p,3);goto 30;end;
18,19,20,21,22,23,24,25,26,29,28,31,30:begin if(mem[p+1].hh.rh>=2)and(
mem[p+1].hh.rh<>5)and(mem[p+1].hh.rh<>6)then flushnodelist(mem[p+1].hh.
lh);
if mem[p+2].hh.rh>=2 and(mem[p+2].hh.rh<>5)and(mem[p+2].hh.rh<>6)then
flushnodelist(mem[p+2].hh.lh);
if mem[p+3].hh.rh>=2 and(mem[p+3].hh.rh<>5)and(mem[p+3].hh.rh<>6)then
flushnodelist(mem[p+3].hh.lh);
if mem[p].hh.b0=26 then freenode(p,6)else if mem[p].hh.b0=30 then
freenode(p,6)else freenode(p,5);goto 30;end;32,33:begin freenode(p,5);
goto 30;end;27:begin flushnodelist(mem[p+2].hh.lh);
flushnodelist(mem[p+3].hh.lh);freenode(p,6);goto 30;end;
{:715}others:confusion(362)end;freenode(p,2);30:end;p:=q;end;end;
{:208}{210:}function copynodelist(p:halfword):halfword;var h:halfword;
q:halfword;r:halfword;words:0..5;begin h:=getavail;q:=h;
while p<>-268435455 do begin{211:}words:=1;
if(p>=himemmin)then r:=getavail else{212:}case mem[p].hh.b0 of 2,0,1,15:
begin r:=getnode(10);{1676:}mem[r+8].int:=mem[p+8].int;
mem[r+9].int:=mem[p+9].int;{:1676};mem[r+7]:=mem[p+7];
mem[r+6]:=mem[p+6];mem[r+5]:=mem[p+5];incr(mem[mem[r+7].hh.rh].hh.rh);
incr(mem[mem[r+7].hh.lh].hh.rh);
mem[r+5].hh.rh:=copynodelist(mem[p+5].hh.rh);words:=5;end;
3:begin r:=getnode(6);words:=4;{1677:}{:1677};end;4:begin r:=getnode(6);
mem[r+5]:=mem[p+5];mem[r+4]:=mem[p+4];incr(mem[mem[p+4].hh.rh].hh.rh);
mem[r+4].hh.lh:=copynodelist(mem[p+4].hh.lh);words:=4;end;
10:{1376:}case mem[p].hh.b1 of 0:begin r:=getnode(3);words:=3;end;
1,3:begin r:=getnode(2);incr(mem[mem[p+1].hh.rh].hh.lh);words:=2;end;
2,4:begin r:=getnode(2);words:=2;end;6:r:=getnode(2);
others:confusion(1431)end{:1376};12:begin r:=getnode(4);
incr(mem[mem[p+1].hh.lh].hh.rh);{1678:}mem[r+2].int:=mem[p+2].int;
mem[r+3].int:=mem[p+3].int;{:1678};mem[r+1].hh.lh:=mem[p+1].hh.lh;
mem[r+1].hh.rh:=copynodelist(mem[p+1].hh.rh);end;5:begin r:=getnode(2);
words:=2;end;13,11,14:begin r:=getnode(4);words:=4;end;
8:begin r:=getnode(2);mem[r+1]:=mem[p+1];
mem[r+1].hh.rh:=copynodelist(mem[p+1].hh.rh);end;9:begin r:=getnode(2);
mem[r+1].hh.lh:=copynodelist(mem[p+1].hh.lh);
mem[r+1].hh.rh:=copynodelist(mem[p+1].hh.rh);end;6:begin r:=getnode(2);
incr(mem[mem[p+1].hh.rh].hh.lh);words:=2;end;7:begin r:=getnode(2);
mem[r+1].int:=copynodelist(mem[p+1].int);end;
others:confusion(363)end{:212};while words>0 do begin decr(words);
mem[r+words]:=mem[p+words];end{:211};mem[q].hh.rh:=r;q:=r;
p:=mem[p].hh.rh;end;mem[q].hh.rh:=-268435455;q:=mem[h].hh.rh;
begin mem[h].hh.rh:=avail;avail:=h;ifdef('STAT')decr(dynused);
endif('STAT')end;copynodelist:=q;end;
{:210}{217:}procedure printmode(m:integer);
begin if m>0 then case m div(113)of 0:print(364);1:print(365);
2:print(366);
end else if m=0 then print(367)else case(-m)div(113)of 0:print(368);
1:print(369);2:print(370);end;end;procedure printinmode(m:integer);
begin if m>0 then case m div(113)of 0:print(371);1:print(372);
2:print(373);
end else if m=0 then print(374)else case(-m)div(113)of 0:print(375);
1:print(376);2:print(377);end;end;{:217}{222:}procedure pushnest;
begin if nestptr>maxneststack then begin maxneststack:=nestptr;
if nestptr=nestsize then overflow(378,nestsize);end;
nest[nestptr]:=curlist;incr(nestptr);curlist.headfield:=newnullbox;
curlist.tailfield:=curlist.headfield;
curlist.pnodefield:=curlist.tailfield;curlist.pgfield:=0;
curlist.pdispfield:=0;curlist.lastjchrfield:=-268435455;
curlist.mlfield:=line;curlist.eTeXauxfield:=-268435455;end;
{:222}{223:}procedure popnest;
begin begin if mem[mem[curlist.headfield+7].hh.rh].hh.rh=-268435455 then
freenode(mem[curlist.headfield+7].hh.rh,4)else decr(mem[mem[curlist.
headfield+7].hh.rh].hh.rh);end;
begin if mem[mem[curlist.headfield+7].hh.lh].hh.rh=-268435455 then
freenode(mem[curlist.headfield+7].hh.lh,4)else decr(mem[mem[curlist.
headfield+7].hh.lh].hh.rh);end;freenode(curlist.headfield,10);
decr(nestptr);curlist:=nest[nestptr];end;
{:223}{224:}procedure printtotals;forward;procedure showactivities;
var p:0..nestsize;m:-227..227;a:memoryword;q,r:halfword;t:integer;
begin nest[nestptr]:=curlist;printnl(343);println;
for p:=nestptr downto 0 do begin m:=nest[p].modefield;
a:=nest[p].auxfield;printnl(379);printdirection(nest[p].dirfield);
print(380);printmode(m);print(381);printint(abs(nest[p].mlfield));
if m=114 then if nest[p].pgfield<>8585216 then begin print(382);
printint(nest[p].pgfield mod 65536);print(383);
printint(nest[p].pgfield div 4194304);printchar(44);
printint((nest[p].pgfield div 65536)mod 64);printchar(41);end;
if nest[p].mlfield<0 then print(384);
if p=0 then begin{1003:}if memtop-2<>pagetail then begin printnl(1077);
if outputactive then print(1078);showbox(mem[memtop-2].hh.rh);
if pagecontents>0 then begin printnl(1079);printtotals;printnl(1080);
printscaled(pagesofar[0]);r:=mem[memtop].hh.rh;
while r<>memtop do begin println;printesc(335);t:=mem[r].hh.b1;
printint(t);print(1081);
if eqtb[29002+t].int=1000 then t:=mem[r+3].int else t:=xovern(mem[r+3].
int,1000)*eqtb[29002+t].int;printscaled(t);
if mem[r].hh.b0=1 then begin q:=memtop-2;t:=0;repeat q:=mem[q].hh.rh;
if(mem[q].hh.b0=4)and(mem[q].hh.b1=mem[r].hh.b1)then incr(t);
until q=mem[r+1].hh.lh;print(1082);printint(t);print(1083);end;
r:=mem[r].hh.rh;end;end;end{:1003};
if mem[memtop-1].hh.rh<>-268435455 then printnl(385);end;
showbox(mem[nest[p].headfield].hh.rh);
{225:}case abs(m)div(113)of 0:begin printnl(386);
if a.int<=-65536000 then print(387)else printscaled(a.int);
if nest[p].pgfield<>0 then begin print(388);printint(nest[p].pgfield);
if nest[p].pgfield<>1 then print(389)else print(390);end;end;
1:begin printnl(391);printint(a.hh.lh);
if m>0 then if a.hh.rh>0 then begin print(392);printint(a.hh.rh);end;
end;2:if a.int<>-268435455 then begin print(393);showbox(a.int);end;
end{:225};end;end;{:224}{243:}procedure printparam(n:integer);
begin case n of 0:printesc(446);1:printesc(447);2:printesc(448);
3:printesc(449);4:printesc(450);5:printesc(451);6:printesc(452);
7:printesc(453);8:printesc(454);9:printesc(455);10:printesc(456);
11:printesc(457);12:printesc(458);13:printesc(459);14:printesc(460);
15:printesc(461);16:printesc(462);17:printesc(463);18:printesc(464);
19:printesc(465);20:printesc(466);21:printesc(467);22:printesc(468);
23:printesc(469);24:printesc(470);25:printesc(471);26:printesc(472);
27:printesc(473);28:printesc(474);29:printesc(475);30:printesc(476);
31:printesc(477);32:printesc(478);33:printesc(479);34:printesc(480);
35:printesc(481);36:printesc(482);37:printesc(483);38:printesc(484);
39:printesc(485);40:printesc(486);41:printesc(487);42:printesc(488);
43:printesc(489);44:printesc(490);46:printesc(491);47:printesc(492);
48:printesc(493);49:printesc(494);50:printesc(495);45:printesc(496);
56:printesc(497);51:printesc(498);52:printesc(499);53:printesc(500);
54:printesc(501);55:printesc(502);57:printesc(503);58:printesc(504);
59:printesc(505);{1650:}60:printesc(1559);
{:1650}{1409:}61:printesc(1456);62:printesc(1457);63:printesc(1458);
64:printesc(1459);65:printesc(1460);66:printesc(1461);67:printesc(1462);
68:printesc(1463);69:printesc(1464);{:1409}{1450:}70:printesc(1504);
{:1450}others:print(506)end;end;{:243}{251:}procedure begindiagnostic;
begin oldsetting:=selector;
if(eqtb[28960].int<=0)and(selector=19)then begin decr(selector);
if history=0 then history:=1;end;end;
procedure enddiagnostic(blankline:boolean);begin printnl(343);
if blankline then println;selector:=oldsetting;end;
{:251}{253:}procedure printlengthparam(n:integer);
begin case n of 0:printesc(509);1:printesc(510);2:printesc(511);
3:printesc(512);4:printesc(513);5:printesc(514);6:printesc(515);
7:printesc(516);8:printesc(517);9:printesc(518);10:printesc(519);
11:printesc(520);12:printesc(521);13:printesc(522);14:printesc(523);
15:printesc(524);16:printesc(525);17:printesc(526);18:printesc(527);
19:printesc(528);21:printesc(529);22:printesc(530);20:printesc(531);
23:printesc(532);24:printesc(533);others:print(534)end;end;
{:253}{258:}{308:}procedure printcmdchr(cmd:quarterword;
chrcode:halfword);var n:integer;begin case cmd of 1:begin print(605);
print(chrcode);end;2:begin print(606);print(chrcode);end;
3:begin print(607);print(chrcode);end;6:begin print(608);print(chrcode);
end;7:begin print(609);print(chrcode);end;8:begin print(610);
print(chrcode);end;9:print(611);10:begin print(612);print(chrcode);end;
11:begin print(613);print(chrcode);end;12:begin print(614);
print(chrcode);end;16,17,18:begin print(615);printkanji(chrcode);end;
{233:}81,82:if chrcode<24549 then printskipparam(chrcode-24528)else if
chrcode<24805 then begin printesc(416);printint(chrcode-24549);
end else begin printesc(417);printint(chrcode-24805);end;
{:233}{237:}78:if chrcode>=25072 then begin printesc(428);
printint(chrcode-25072);end else case chrcode of 25062:printesc(419);
25063:printesc(420);25064:printesc(421);25065:printesc(422);
25066:printesc(423);25067:printesc(424);25068:printesc(425);
25069:printesc(426);{1408:}25071:printesc(1455);
{:1408}others:printesc(427)end;
{:237}{245:}79:if chrcode<29002 then printparam(chrcode-28931)else begin
printesc(507);printint(chrcode-29002);end;
{:245}{255:}80:if chrcode<29539 then printlengthparam(chrcode-29514)else
begin printesc(535);printint(chrcode-29539);end;
{:255}{276:}48:printesc(546);101:printesc(547);43:printesc(548);
44:printesc(549);83:printesc(560);64:printesc(550);45:printesc(575);
19:printesc(551);119:printesc(542);97:printesc(557);98:printesc(558);
99:printesc(559);15:printesc(552);103:printesc(554);70:printesc(543);
65:printesc(555);67:printesc(32);
114:if chrcode=0 then printesc(556){1517:}else printesc(865){:1517};
35:printesc(561);39:printesc(562);
42:if chrcode=0 then printesc(563)else printesc(539);40:printesc(335);
47:printesc(47);21:begin printesc(360);if chrcode>0 then printchar(115);
end;49:printesc(564);20:printesc(565);57:printesc(568);
102:printesc(569);37:printesc(570);68:printesc(571);
115:if chrcode=0 then printesc(572)else printesc(539);58:printesc(340);
66:printesc(573);69:printesc(577);
107:if chrcode=0 then printesc(579){1514:}else printesc(1519){:1514};
0:printesc(580);109:printesc(581);89:printesc(576);
93:case chrcode of 25061:printesc(574);{1619:}25328:printesc(1552);
25329:printesc(1553);25330:printesc(1554);25331:printesc(1555);
{:1619}end;
121:if chrcode=0 then printesc(582){1437:}else if chrcode=1 then
printesc(1494)else printesc(1495){:1437};77:{1587:}begin printesc(428);
if chrcode<>membot then printsanum(chrcode);end{:1587};41:printesc(361);
36:if chrcode=0 then printesc(583){1452:}else case chrcode of 6:printesc
(1505);7:printesc(1506);10:printesc(1507);
others:printesc(1508)end{:1452};59:printesc(584);38:printesc(585);
{:276}{345:}13:printesc(647);
{:345}{394:}116:if chrcode=0 then printesc(685){1502:}else if chrcode=2
then printesc(1517){:1502}else printesc(686);
{:394}{402:}122:begin case(chrcode mod 5)of 1:printesc(688);
2:printesc(689);3:printesc(690);4:printesc(691);others:printesc(687)end;
if chrcode>=5 then printchar(115);end;
{:402}{429:}100:{1586:}begin if(chrcode<membot)or(chrcode>membot+23)then
cmd:=(mem[chrcode].hh.b0 div 16)else begin cmd:=chrcode-membot;
chrcode:=-268435455;end;
if cmd=0 then printesc(507)else if cmd=1 then printesc(535)else if cmd=2
then printesc(416)else printesc(417);
if chrcode<>-268435455 then printsanum(chrcode);end{:1586};
{:429}{434:}88:if chrcode=1 then printesc(730)else printesc(729);
91:if chrcode=0 then printesc(731){1443:}else if chrcode=2 then printesc
(1500){:1443}else printesc(732);
92:if chrcode=1 then printesc(733)else if chrcode=3 then printesc(734)
else printesc(735);74:case chrcode of 0:printesc(736);1:printesc(737);
2:printesc(738);5:printesc(739);{1400:}3:printesc(1448);
4:printesc(1449);10:printesc(1450);7:printesc(1451);8:printesc(1452);
9:printesc(1453);{:1400}{1414:}11:printesc(1479);12:printesc(1480);
{:1414}{1417:}13:printesc(1481);14:printesc(1482);15:printesc(1483);
{:1417}{1420:}18:printesc(1484);19:printesc(1485);20:printesc(1486);
21:printesc(1487);{:1420}{1423:}22:printesc(1488);23:printesc(1489);
24:printesc(1490);{:1423}{1533:}29:printesc(1528);30:printesc(1529);
31:printesc(1530);32:printesc(1531);{:1533}{1556:}16:printesc(1535);
17:printesc(1536);25:printesc(1537);26:printesc(1538);
{:1556}{1560:}27:printesc(1539);28:printesc(1540);
{:1560}others:printesc(740)end;
{:434}{486:}120:case chrcode of 0:printesc(801);1:printesc(802);
3:printesc(803);4:printesc(804);5:printesc(805);2:printesc(806);
6:printesc(807);7:printesc(808);8:printesc(809);9:printesc(810);
10:printesc(812);11:printesc(813);12:printesc(814);13:printesc(815);
14:printesc(816);15:printesc(817);16:printesc(818);
others:printesc(811)end;
{:486}{505:}117:begin if chrcode>=32 then printesc(865);
case chrcode mod 32 of 1:printesc(842);2:printesc(843);3:printesc(844);
4:printesc(845);5:printesc(846);6:printesc(847);7:printesc(848);
8:printesc(849);9:printesc(850);10:printesc(851);11:printesc(852);
12:printesc(853);13:printesc(854);14:printesc(855);15:printesc(856);
16:printesc(857);20:printesc(858);21:printesc(859);22:printesc(860);
23:printesc(861);24:printesc(862);25:printesc(863);26:printesc(864);
27:printesc(866);{1518:}17:printesc(1520);18:printesc(1521);
19:printesc(1522);{:1518}others:printesc(841)end;end;
{:505}{509:}118:if chrcode=2 then printesc(315)else if chrcode=4 then
printesc(867)else printesc(868);
{:509}{798:}4:if chrcode=256 then printesc(993)else begin print(997);
print(chrcode);end;
5:if chrcode=257 then printesc(994)else printesc(995);
{:798}{1001:}90:case chrcode of 0:printesc(1065);1:printesc(1066);
2:printesc(1067);3:printesc(1068);4:printesc(1069);5:printesc(1070);
6:printesc(1071);7:printesc(1072);others:printesc(1073)end;
{:1001}{1071:}14:if chrcode=1 then printesc(1123)else printesc(348);
{:1071}{1077:}29:case chrcode of 5:printesc(1124);0:printesc(1125);
1:printesc(1126);2:printesc(1127);3:printesc(1128);
others:printesc(1129)end;30:case chrcode of 5:printesc(1130);
0:printesc(1131);1:printesc(1132);2:printesc(1133);3:printesc(1134);
others:printesc(1135)end;31:printesc(341);32:printesc(345);
33:printesc(347);
{:1077}{1090:}24:if chrcode=1 then printesc(1153)else printesc(1154);
25:if chrcode=1 then printesc(1155)else printesc(1156);
23:case chrcode of 0:printesc(430);1:printesc(1157);2:printesc(1158);
3:printesc(1060);4:printesc(1159);5:printesc(1062);
others:printesc(1160)end;76:case chrcode of 4:printesc(1162);
3:printesc(1161);1:printesc(1163);end;
34:if chrcode=100 then printesc(1165)else if chrcode=101 then printesc(
1166)else if chrcode=102 then printesc(1167)else printesc(1164);
{:1090}{1107:}46:if chrcode=0 then printesc(1195)else printesc(1194);
{:1107}{1126:}28:if chrcode=12 then printesc(1208)else if chrcode=13
then printesc(1207)else printesc(1206);
26:if chrcode=1 then printesc(1210)else printesc(1209);
27:if chrcode=1 then printesc(1212){1616:}else if chrcode=2 then
printesc(1550)else if chrcode=3 then printesc(1551){:1616}else printesc(
1211);{:1126}{1133:}50:if chrcode=1 then printesc(45)else printesc(358);
{:1133}{1161:}51:if chrcode=1 then printesc(1246)else printesc(1245);
{:1161}{1175:}53:case chrcode of 18:printesc(959);19:printesc(960);
20:printesc(961);21:printesc(962);22:printesc(963);23:printesc(964);
24:printesc(965);25:printesc(966);28:printesc(968);
others:printesc(967)end;
54:if chrcode=1 then printesc(972)else if chrcode=2 then printesc(973)
else printesc(1250);{:1175}{1188:}56:printstyle(chrcode);
{:1188}{1197:}55:case chrcode of 1:printesc(1269);2:printesc(1270);
3:printesc(1271);4:printesc(1272);5:printesc(1273);
others:printesc(1268)end;
{:1197}{1207:}52:if chrcode=32 then printesc(969){1448:}else if chrcode=
1 then printesc(971){:1448}else printesc(970);
{:1207}{1227:}104:if chrcode=1 then printesc(1293)else if chrcode=2 then
printesc(1294){1525:}else if chrcode=8 then printesc(1307){:1525}else
printesc(1295);
108:if chrcode=0 then printesc(1296)else if chrcode=1 then printesc(1297
)else if chrcode=2 then printesc(1298)else printesc(1299);
{:1227}{1238:}105:if chrcode<>0 then printesc(1317)else printesc(1316);
{:1238}{1241:}106:case chrcode of 0:printesc(1318);1:printesc(1319);
2:printesc(1320);3:printesc(1321);4:printesc(1322);5:printesc(1323);
6:printesc(1324);8:printesc(1326);others:printesc(1325)end;
71:begin printesc(551);printhex(chrcode);end;72:begin printesc(565);
printhex(chrcode);end;73:begin printesc(567);printhex(chrcode);end;
{:1241}{1249:}94:if chrcode=26361 then printesc(436)else if chrcode=
26617 then printesc(437)else if chrcode=26873 then printesc(438)else if
chrcode=28419 then printesc(445)else if chrcode=28547 then printesc(1331
)else if chrcode=27651 then printesc(442)else if chrcode=27907 then
printesc(443)else if chrcode=28163 then printesc(444)else if chrcode=
29258 then printesc(508)else printesc(1332);95:printsize(chrcode-25589);
{:1249}{1270:}110:if chrcode=1 then printesc(1048)else printesc(1036);
{:1270}{1274:}84:if chrcode=0 then printesc(1351)else printesc(1352);
{:1274}{1280:}96:begin print(1360);slowprint(fontname[chrcode]);
if fontsize[chrcode]<>fontdsize[chrcode]then begin print(826);
printscaled(fontsize[chrcode]);print(418);end;end;
{:1280}{1282:}111:case chrcode of 0:printesc(273);1:printesc(274);
2:printesc(275);others:printesc(1361)end;
{:1282}{1292:}63:if chrcode=0 then printesc(1363)else printesc(1362);
{:1292}{1297:}61:if chrcode=0 then printesc(1364)else printesc(1365);
{:1297}{1306:}60:if chrcode=27651 then printesc(1371)else printesc(1372)
;{:1306}{1311:}22:case chrcode of 1:printesc(1374);2:printesc(1375);
3:printesc(1376);{1426:}4:printesc(1491);{:1426}{1435:}5:printesc(1493);
{:1435}{1440:}6:printesc(1496);{:1440}7:printesc(1377);
others:printesc(1373)end;{:1311}{1314:}113:print(1384);
123,124,125,126:begin n:=cmd-123;
if mem[mem[chrcode].hh.rh].hh.lh=3585 then n:=n+4;
if odd(n div 4)then printesc(1307);if odd(n)then printesc(1293);
if odd(n div 2)then printesc(1294);if n>0 then printchar(32);
print(1385);end;127:printesc(1386);
{:1314}{1365:}62:case chrcode of 0:printesc(1421);1:printesc(644);
2:printesc(1422);3:printesc(1423);4:printesc(1424);5:printesc(1425);
6:printesc(1426);others:print(1427)end;{:1365}{1686:}87:printesc(441);
{:1686}{1691:}112:begin if(chrcode mod 2)=0 then printesc(1567)else
printesc(1568);if chrcode<2 then print(1569)else print(1570);end;
{:1691}{1698:}75:printesc(1575);86:printesc(1576);
{:1698}{1703:}85:case chrcode of 1:printesc(1579);2:printesc(1580);end;
{:1703}others:print(616)end;end;
{:308}ifdef('STAT')procedure showeqtb(n:halfword);
begin if n<1 then printchar(63)else if(n<24528)or((n>30050)and(n<=
eqtbtop))then{229:}begin sprintcs(n);printchar(61);
printcmdchr(eqtb[n].hh.b0,eqtb[n].hh.rh);
if eqtb[n].hh.b0>=123 then begin printchar(58);
showtokenlist(mem[eqtb[n].hh.rh].hh.rh,-268435455,32);end;
end{:229}else if n<25061 then{235:}if n<24549 then begin printskipparam(
n-24528);printchar(61);
if n<24545 then printspec(eqtb[n].hh.rh,418)else printspec(eqtb[n].hh.rh
,342);end else if n<24805 then begin printesc(416);printint(n-24549);
printchar(61);printspec(eqtb[n].hh.rh,418);end else begin printesc(417);
printint(n-24805);printchar(61);printspec(eqtb[n].hh.rh,342);
end{:235}else if n<28931 then{239:}if(n=25061)or((n>=25328)and(n<25332))
then begin printcmdchr(93,n);printchar(61);
if eqtb[n].hh.rh=-268435455 then printchar(48)else if n>25061 then begin
printint(mem[eqtb[n].hh.rh+1].int);printchar(32);
printint(mem[eqtb[n].hh.rh+2].int);
if mem[eqtb[n].hh.rh+1].int>1 then printesc(429);
end else printint(mem[eqtb[25061].hh.rh].hh.lh);
end else if n<25072 then begin printcmdchr(78,n);printchar(61);
if eqtb[n].hh.rh<>-268435455 then showtokenlist(mem[eqtb[n].hh.rh].hh.rh
,-268435455,32);end else if n<25332 then begin printesc(428);
printint(n-25072);printchar(61);
if eqtb[n].hh.rh<>-268435455 then showtokenlist(mem[eqtb[n].hh.rh].hh.rh
,-268435455,32);end else if n<25588 then begin printesc(430);
printint(n-25332);printchar(61);
if eqtb[n].hh.rh=-268435455 then print(431)else begin depththreshold:=0;
breadthmax:=1;shownodelist(eqtb[n].hh.rh);end;
end else if n<26361 then{240:}begin if n=25588 then print(432)else if n<
25845 then begin printesc(433);printint(n-25589);
end else if n<26101 then begin printesc(434);printint(n-25845);
end else begin printesc(435);printint(n-26101);end;printchar(61);
printesc(hash[15526+eqtb[n].hh.rh].rh);
end{:240}else{241:}if n<28419 then begin if n<26617 then begin printesc(
436);printint(n-26361);end else if n<26873 then begin printesc(437);
printint(n-26617);end else if n<27129 then begin printesc(438);
printint(n-26873);end else if n<27385 then begin print(439);
printint(n-27129);end else if n<27641 then begin print(440);
printint(n-27385);end else if n<27651 then begin printesc(441);
printint(n-27641);end else if n<27907 then begin printesc(442);
printint(n-27651);end else if n<28163 then begin printesc(443);
printint(n-27907);end else begin printesc(444);printint(n-28163);end;
printchar(61);printint(eqtb[n].hh.rh);end else begin printesc(445);
printint(n-28419);printchar(61);printint(eqtb[n].hh.rh);
end{:241}{:239}else if n<29514 then{248:}begin if n<29002 then
printparam(n-28931)else if n<29258 then begin printesc(507);
printint(n-29002);end else begin printesc(508);printint(n-29258);end;
printchar(61);printint(eqtb[n].int);
end{:248}else if n<29795 then{257:}begin if n<29539 then
printlengthparam(n-29514)else begin printesc(535);printint(n-29539);end;
printchar(61);printscaled(eqtb[n].int);print(418);
end{:257}else if n<=30050 then print(536)else printchar(63);end;
endif('STAT'){:258}{266:}function idlookup(j,l:integer):halfword;
label 40;var h:integer;d:integer;p:halfword;k:halfword;
begin{268:}h:=buffer[j];for k:=j+1 to j+l-1 do begin h:=h+h+buffer[k];
while h>=8501 do h:=h-8501;end{:268};p:=h+514;
while true do begin if hash[p].rh>0 then if(strstart[hash[p].rh+1]-
strstart[hash[p].rh])=l then if streqbuf(hash[p].rh,j)then goto 40;
if hash[p].lh=0 then begin if nonewcontrolsequence then p:=24527 else
{267:}begin if hash[p].rh>0 then begin if hashhigh<hashextra then begin
incr(hashhigh);hash[p].lh:=hashhigh+30050;p:=hashhigh+30050;
end else begin repeat if(hashused=514)then overflow(540,15000+hashextra)
;decr(hashused);until hash[hashused].rh=0;hash[p].lh:=hashused;
p:=hashused;end;end;
begin if poolptr+l>poolsize then overflow(258,poolsize-initpoolptr);end;
d:=(poolptr-strstart[strptr]);
while poolptr>strstart[strptr]do begin decr(poolptr);
strpool[poolptr+l]:=strpool[poolptr];end;
for k:=j to j+l-1 do begin strpool[poolptr]:=buffer[k];incr(poolptr);
end;hash[p].rh:=makestring;poolptr:=poolptr+d;
ifdef('STAT')incr(cscount);endif('STAT')end{:267};goto 40;end;
p:=hash[p].lh;end;40:idlookup:=p;end;
{:266}{269:}function primlookup(s:strnumber):halfword;label 40;
var h:integer;p:halfword;k:halfword;j,l:integer;
begin if s<256 then begin p:=s;if(p<0)or(primeqtb[p].hh.b1<>1)then p:=0;
end else begin j:=strstart[s];
if s=strptr then l:=(poolptr-strstart[strptr])else l:=(strstart[s+1]-
strstart[s]);{271:}h:=strpool[j];
for k:=j+1 to j+l-1 do begin h:=h+h+strpool[k];
while h>=1777 do h:=h-1777;end{:271};p:=h+1;
while true do begin if prim[p].rh>0 then if(strstart[prim[p].rh+1]-
strstart[prim[p].rh])=l then if streqstr(prim[p].rh,s)then goto 40;
if prim[p].lh=0 then begin if nonewcontrolsequence then p:=0 else{270:}
begin if prim[p].rh>0 then begin repeat if(primused=1)then overflow(541,
2100);decr(primused);until prim[primused].rh=0;prim[p].lh:=primused;
p:=primused;end;prim[p].rh:=s;end{:270};goto 40;end;p:=prim[p].lh;end;
end;40:primlookup:=p;end;
{:269}{274:}ifdef('INITEX')procedure primitive(s:strnumber;
c:quarterword;o:halfword);var k:poolpointer;primval:integer;
j:0..bufsize;l:smallnumber;begin if s<256 then begin curval:=s+257;
primval:=s;end else begin k:=strstart[s];l:=strstart[s+1]-k;
if first+l>bufsize+1 then overflow(257,bufsize);
for j:=0 to l-1 do buffer[first+j]:=strpool[k+j];
curval:=idlookup(first,l);begin decr(strptr);poolptr:=strstart[strptr];
end;hash[curval].rh:=s;primval:=primlookup(s);end;eqtb[curval].hh.b1:=1;
eqtb[curval].hh.b0:=c;eqtb[curval].hh.rh:=o;primeqtb[primval].hh.b1:=1;
primeqtb[primval].hh.b0:=c;primeqtb[primval].hh.rh:=o;end;
endif('INITEX'){:274}{278:}{294:}ifdef('STAT')procedure restoretrace(p:
halfword;s:strnumber);begin begindiagnostic;printchar(123);print(s);
printchar(32);showeqtb(p);printchar(125);enddiagnostic(false);end;
endif('STAT'){:294}{1411:}procedure printgroup(e:boolean);label 10;
begin case curgroup of 0:begin print(1465);goto 10;end;
1,14:begin if curgroup=14 then print(1466);print(1467);end;
2,3:begin if curgroup=3 then print(1468);print(1160);end;4:print(1062);
5:print(1159);6,7:begin if curgroup=7 then print(1469);print(1470);end;
8:print(419);10:print(1471);11:print(335);12:print(584);
9,13,15,16:begin print(350);
if curgroup=13 then print(1472)else if curgroup=15 then print(1473)else
if curgroup=16 then print(1474);end;end;print(1475);printint(curlevel);
printchar(41);
if savestack[saveptr-1].int<>0 then begin if e then print(381)else print
(1476);printint(savestack[saveptr-1].int);end;10:end;
{:1411}{1412:}ifdef('STAT')procedure grouptrace(e:boolean);
begin begindiagnostic;printchar(123);
if e then print(1477)else print(1478);printgroup(e);printchar(125);
enddiagnostic(false);end;
endif('STAT'){:1412}{1510:}function pseudoinput:boolean;var p:halfword;
sz:integer;w:fourquarters;r:halfword;begin last:=first;
p:=mem[pseudofiles].hh.lh;
if p=-268435455 then pseudoinput:=false else begin mem[pseudofiles].hh.
lh:=mem[p].hh.rh;sz:=mem[p].hh.lh;
if 4*sz-3>=bufsize-last then{36:}begin curinput.locfield:=first;
curinput.limitfield:=last-1;overflow(257,bufsize);end{:36};last:=first;
for r:=p+1 to p+sz-1 do begin w:=mem[r].qqqq;buffer[last]:=w.b0;
buffer[last+1]:=w.b1;buffer[last+2]:=w.b2;buffer[last+3]:=w.b3;
last:=last+4;end;if last>=maxbufstack then maxbufstack:=last+1;
while(last>first)and(buffer[last-1]=32)do decr(last);freenode(p,sz);
pseudoinput:=true;end;end;{:1510}{1511:}procedure pseudoclose;
var p,q:halfword;begin p:=mem[pseudofiles].hh.rh;
q:=mem[pseudofiles].hh.lh;begin mem[pseudofiles].hh.rh:=avail;
avail:=pseudofiles;ifdef('STAT')decr(dynused);endif('STAT')end;
pseudofiles:=p;while q<>-268435455 do begin p:=q;q:=mem[p].hh.rh;
freenode(p,mem[p].hh.lh);end;end;{:1511}{1528:}procedure groupwarning;
var i:0..maxinopen;w:boolean;begin baseptr:=inputptr;
inputstack[baseptr]:=curinput;i:=inopen;w:=false;
while(grpstack[i]=curboundary)and(i>0)do begin{1529:}if eqtb[28996].int>
0 then begin while(inputstack[baseptr].statefield=0)or(inputstack[
baseptr].indexfield>i)do decr(baseptr);
if inputstack[baseptr].namefield>17 then w:=true;end{:1529};
grpstack[i]:=savestack[saveptr].hh.rh;decr(i);end;
if w then begin printnl(1524);printgroup(true);print(1525);println;
if eqtb[28996].int>1 then showcontext;if history=0 then history:=1;end;
end;{:1528}{1530:}procedure ifwarning;var i:0..maxinopen;w:boolean;
begin baseptr:=inputptr;inputstack[baseptr]:=curinput;i:=inopen;
w:=false;
while ifstack[i]=condptr do begin{1529:}if eqtb[28996].int>0 then begin
while(inputstack[baseptr].statefield=0)or(inputstack[baseptr].indexfield
>i)do decr(baseptr);if inputstack[baseptr].namefield>17 then w:=true;
end{:1529};ifstack[i]:=mem[condptr].hh.rh;decr(i);end;
if w then begin printnl(1524);printcmdchr(117,curif);
if ifline<>0 then begin print(1497);printint(ifline);end;print(1525);
println;if eqtb[28996].int>1 then showcontext;
if history=0 then history:=1;end;end;
{:1530}{1531:}procedure filewarning;var p:halfword;l:quarterword;
c:quarterword;i:integer;begin p:=saveptr;l:=curlevel;c:=curgroup;
saveptr:=curboundary;
while grpstack[inopen]<>saveptr do begin decr(curlevel);printnl(1526);
printgroup(true);print(1527);curgroup:=savestack[saveptr].hh.b1;
saveptr:=savestack[saveptr].hh.rh end;saveptr:=p;curlevel:=l;
curgroup:=c;p:=condptr;l:=iflimit;c:=curif;i:=ifline;
while ifstack[inopen]<>condptr do begin printnl(1526);
printcmdchr(117,curif);if iflimit=2 then printesc(868);
if ifline<>0 then begin print(1497);printint(ifline);end;print(1527);
ifline:=mem[condptr+1].int;curif:=mem[condptr].hh.b1;
iflimit:=mem[condptr].hh.b0;condptr:=mem[condptr].hh.rh;end;condptr:=p;
iflimit:=l;curif:=c;ifline:=i;println;
if eqtb[28996].int>1 then showcontext;if history=0 then history:=1;end;
{:1531}{1575:}procedure deletesaref(q:halfword);label 10;var p:halfword;
i:smallnumber;s:smallnumber;begin decr(mem[q+1].hh.lh);
if mem[q+1].hh.lh<>-268435455 then goto 10;
if mem[q].hh.b0<32 then if mem[q+2].int=0 then s:=3 else goto 10 else
begin if mem[q].hh.b0<64 then if mem[q+1].hh.rh=membot then
deleteglueref(membot)else goto 10 else if mem[q+1].hh.rh<>-268435455
then goto 10;s:=2;end;repeat i:=mem[q].hh.b0 mod 16;p:=q;
q:=mem[p].hh.rh;freenode(p,s);
if q=-268435455 then begin saroot[i]:=-268435455;goto 10;end;
begin if odd(i)then mem[q+(i div 2)+1].hh.rh:=-268435455 else mem[q+(i
div 2)+1].hh.lh:=-268435455;decr(mem[q].hh.b1);end;s:=9;
until mem[q].hh.b1>0;10:end;
{:1575}{1577:}ifdef('STAT')procedure showsa(p:halfword;s:strnumber);
var t:smallnumber;begin begindiagnostic;printchar(123);print(s);
printchar(32);
if p=-268435455 then printchar(63)else begin t:=(mem[p].hh.b0 div 16);
if t<4 then printcmdchr(100,p)else if t=4 then begin printesc(430);
printsanum(p);end else if t=5 then printcmdchr(77,p)else printchar(63);
printchar(61);
if t=0 then printint(mem[p+2].int)else if t=1 then begin printscaled(mem
[p+2].int);print(418);end else begin p:=mem[p+1].hh.rh;
if t=2 then printspec(p,418)else if t=3 then printspec(p,342)else if t=4
then if p=-268435455 then print(431)else begin depththreshold:=0;
breadthmax:=1;shownodelist(p);
end else if t=5 then begin if p<>-268435455 then showtokenlist(mem[p].hh
.rh,-268435455,32);end else printchar(63);end;end;printchar(125);
enddiagnostic(false);end;
endif('STAT'){:1577}{1591:}procedure sasave(p:halfword);var q:halfword;
i:quarterword;
begin if curlevel<>salevel then begin if saveptr>maxsavestack then begin
maxsavestack:=saveptr;
if maxsavestack>savesize-7 then overflow(586,savesize);end;
savestack[saveptr].hh.b0:=4;savestack[saveptr].hh.b1:=salevel;
savestack[saveptr].hh.rh:=sachain;incr(saveptr);sachain:=-268435455;
salevel:=curlevel;end;i:=mem[p].hh.b0;
if i<32 then begin if mem[p+2].int=0 then begin q:=getnode(2);i:=96;
end else begin q:=getnode(3);mem[q+2].int:=mem[p+2].int;end;
mem[q+1].hh.rh:=-268435455;end else begin q:=getnode(2);
mem[q+1].hh.rh:=mem[p+1].hh.rh;end;mem[q+1].hh.lh:=p;mem[q].hh.b0:=i;
mem[q].hh.b1:=mem[p].hh.b1;mem[q].hh.rh:=sachain;sachain:=q;
incr(mem[p+1].hh.lh);end;{:1591}{1592:}procedure sadestroy(p:halfword);
begin if mem[p].hh.b0<64 then deleteglueref(mem[p+1].hh.rh)else if mem[p
+1].hh.rh<>-268435455 then if mem[p].hh.b0<80 then flushnodelist(mem[p+1
].hh.rh)else deletetokenref(mem[p+1].hh.rh);end;
{:1592}{1593:}procedure sadef(p:halfword;e:halfword);
begin incr(mem[p+1].hh.lh);
if mem[p+1].hh.rh=e then begin ifdef('STAT')if eqtb[28992].int>0 then
showsa(p,588);endif('STAT')sadestroy(p);
end else begin ifdef('STAT')if eqtb[28992].int>0 then showsa(p,589);
endif('STAT')if mem[p].hh.b1=curlevel then sadestroy(p)else sasave(p);
mem[p].hh.b1:=curlevel;mem[p+1].hh.rh:=e;
ifdef('STAT')if eqtb[28992].int>0 then showsa(p,590);endif('STAT')end;
deletesaref(p);end;procedure sawdef(p:halfword;w:integer);
begin incr(mem[p+1].hh.lh);
if mem[p+2].int=w then begin ifdef('STAT')if eqtb[28992].int>0 then
showsa(p,588);
endif('STAT')end else begin ifdef('STAT')if eqtb[28992].int>0 then
showsa(p,589);endif('STAT')if mem[p].hh.b1<>curlevel then sasave(p);
mem[p].hh.b1:=curlevel;mem[p+2].int:=w;
ifdef('STAT')if eqtb[28992].int>0 then showsa(p,590);endif('STAT')end;
deletesaref(p);end;{:1593}{1594:}procedure gsadef(p:halfword;
e:halfword);begin incr(mem[p+1].hh.lh);
ifdef('STAT')if eqtb[28992].int>0 then showsa(p,591);
endif('STAT')sadestroy(p);mem[p].hh.b1:=1;mem[p+1].hh.rh:=e;
ifdef('STAT')if eqtb[28992].int>0 then showsa(p,590);
endif('STAT')deletesaref(p);end;procedure gsawdef(p:halfword;w:integer);
begin incr(mem[p+1].hh.lh);
ifdef('STAT')if eqtb[28992].int>0 then showsa(p,591);
endif('STAT')mem[p].hh.b1:=1;mem[p+2].int:=w;
ifdef('STAT')if eqtb[28992].int>0 then showsa(p,590);
endif('STAT')deletesaref(p);end;{:1594}{1595:}procedure sarestore;
var p:halfword;begin repeat p:=mem[sachain+1].hh.lh;
if mem[p].hh.b1=1 then begin if mem[p].hh.b0>=32 then sadestroy(sachain)
;ifdef('STAT')if eqtb[28968].int>0 then showsa(p,593);
endif('STAT')end else begin if mem[p].hh.b0<32 then if mem[sachain].hh.
b0<32 then mem[p+2].int:=mem[sachain+2].int else mem[p+2].int:=0 else
begin sadestroy(p);mem[p+1].hh.rh:=mem[sachain+1].hh.rh;end;
mem[p].hh.b1:=mem[sachain].hh.b1;
ifdef('STAT')if eqtb[28968].int>0 then showsa(p,594);endif('STAT')end;
deletesaref(p);p:=sachain;sachain:=mem[p].hh.rh;
if mem[p].hh.b0<32 then freenode(p,3)else freenode(p,2);
until sachain=-268435455;end;
{:1595}{:278}{284:}procedure newsavelevel(c:groupcode);
begin if saveptr>maxsavestack then begin maxsavestack:=saveptr;
if maxsavestack>savesize-7 then overflow(586,savesize);end;
if(eTeXmode=1)then begin savestack[saveptr+0].int:=line;incr(saveptr);
end;savestack[saveptr].hh.b0:=3;savestack[saveptr].hh.b1:=curgroup;
savestack[saveptr].hh.rh:=curboundary;
if curlevel=65535 then overflow(587,65535);curboundary:=saveptr;
curgroup:=c;ifdef('STAT')if eqtb[28993].int>0 then grouptrace(false);
endif('STAT')incr(curlevel);incr(saveptr);end;
{:284}{285:}procedure eqdestroy(w:memoryword);var q:halfword;
begin case w.hh.b0 of 123,124,125,126:deletetokenref(w.hh.rh);
129:deleteglueref(w.hh.rh);130:begin q:=w.hh.rh;
if q<>-268435455 then freenode(q,mem[q].hh.lh+mem[q].hh.lh+1);end;
131:flushnodelist(w.hh.rh);
{1588:}77,100:if(w.hh.rh<membot)or(w.hh.rh>membot+23)then deletesaref(w.
hh.rh);{:1588}others:end;end;{:285}{286:}procedure eqsave(p:halfword;
l:quarterword);
begin if saveptr>maxsavestack then begin maxsavestack:=saveptr;
if maxsavestack>savesize-7 then overflow(586,savesize);end;
if l=0 then savestack[saveptr].hh.b0:=1 else begin savestack[saveptr]:=
eqtb[p];incr(saveptr);savestack[saveptr].hh.b0:=0;end;
savestack[saveptr].hh.b1:=l;savestack[saveptr].hh.rh:=p;incr(saveptr);
end;{:286}{287:}procedure eqdefine(p:halfword;t:quarterword;e:halfword);
label 10;
begin if(eTeXmode=1)and(eqtb[p].hh.b0=t)and(eqtb[p].hh.rh=e)then begin
ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,588);
endif('STAT')eqdestroy(eqtb[p]);goto 10;end;
ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,589);
endif('STAT')if eqtb[p].hh.b1=curlevel then eqdestroy(eqtb[p])else if
curlevel>1 then eqsave(p,eqtb[p].hh.b1);eqtb[p].hh.b1:=curlevel;
eqtb[p].hh.b0:=t;eqtb[p].hh.rh:=e;
ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,590);
endif('STAT')10:end;{:287}{288:}procedure eqworddefine(p:halfword;
w:integer);label 10;
begin if(eTeXmode=1)and(eqtb[p].int=w)then begin ifdef('STAT')if eqtb[
28992].int>0 then restoretrace(p,588);endif('STAT')goto 10;end;
ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,589);
endif('STAT')if xeqlevel[p]<>curlevel then begin eqsave(p,xeqlevel[p]);
xeqlevel[p]:=curlevel;end;eqtb[p].int:=w;
ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,590);
endif('STAT')10:end;procedure deleqworddefine(p:halfword;
w,wone:integer);label 10;
begin if(eTeXmode=1)and(eqtb[p].int=w)and(getintone(eqtb[p])=wone)then
begin ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,588);
endif('STAT')goto 10;end;
ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,589);
endif('STAT')if xeqlevel[p]<>curlevel then begin eqsave(p,xeqlevel[p]);
xeqlevel[p]:=curlevel;end;eqtb[p].int:=w;setintone(eqtb[p],wone);
ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,590);
endif('STAT')10:end;{:288}{289:}procedure geqdefine(p:halfword;
t:quarterword;e:halfword);
begin ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,591);
endif('STAT')begin eqdestroy(eqtb[p]);eqtb[p].hh.b1:=1;eqtb[p].hh.b0:=t;
eqtb[p].hh.rh:=e;end;
ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,590);
endif('STAT')end;procedure geqworddefine(p:halfword;w:integer);
begin ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,591);
endif('STAT')begin eqtb[p].int:=w;xeqlevel[p]:=1;end;
ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,590);
endif('STAT')end;procedure delgeqworddefine(p:halfword;w,wone:integer);
begin ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,591);
endif('STAT')begin eqtb[p].int:=w;setintone(eqtb[p],wone);
xeqlevel[p]:=1;end;
ifdef('STAT')if eqtb[28992].int>0 then restoretrace(p,590);
endif('STAT')end;{:289}{290:}procedure saveforafter(t:halfword);
begin if curlevel>1 then begin if saveptr>maxsavestack then begin
maxsavestack:=saveptr;
if maxsavestack>savesize-7 then overflow(586,savesize);end;
savestack[saveptr].hh.b0:=2;savestack[saveptr].hh.b1:=0;
savestack[saveptr].hh.rh:=t;incr(saveptr);end;end;
{:290}{291:}procedure backinput;forward;procedure unsave;label 30;
var p:halfword;l:quarterword;t:halfword;a:boolean;begin a:=false;
if curlevel>1 then begin decr(curlevel);
{292:}while true do begin decr(saveptr);
if savestack[saveptr].hh.b0=3 then goto 30;p:=savestack[saveptr].hh.rh;
if savestack[saveptr].hh.b0=2 then{336:}begin t:=curtok;curtok:=p;
if a then begin p:=getavail;mem[p].hh.lh:=curtok;
mem[p].hh.rh:=curinput.locfield;curinput.locfield:=p;
curinput.startfield:=p;
if curtok<768 then if curtok<512 then decr(alignstate)else incr(
alignstate);end else begin backinput;a:=(eTeXmode=1);end;curtok:=t;
end{:336}else if savestack[saveptr].hh.b0=4 then begin sarestore;
sachain:=p;salevel:=savestack[saveptr].hh.b1;
end else begin if savestack[saveptr].hh.b0=0 then begin l:=savestack[
saveptr].hh.b1;decr(saveptr);end else savestack[saveptr]:=eqtb[24527];
{293:}if(p<28931)or(p>30050)then if eqtb[p].hh.b1=1 then begin eqdestroy
(savestack[saveptr]);
ifdef('STAT')if eqtb[28968].int>0 then restoretrace(p,593);
endif('STAT')end else begin eqdestroy(eqtb[p]);
eqtb[p]:=savestack[saveptr];
ifdef('STAT')if eqtb[28968].int>0 then restoretrace(p,594);
endif('STAT')end else if xeqlevel[p]<>1 then begin eqtb[p]:=savestack[
saveptr];xeqlevel[p]:=l;
ifdef('STAT')if eqtb[28968].int>0 then restoretrace(p,594);
endif('STAT')end else begin ifdef('STAT')if eqtb[28968].int>0 then
restoretrace(p,593);endif('STAT')end{:293};end;end;
30:ifdef('STAT')if eqtb[28993].int>0 then grouptrace(true);
endif('STAT')if grpstack[inopen]=curboundary then groupwarning;
curgroup:=savestack[saveptr].hh.b1;
curboundary:=savestack[saveptr].hh.rh;
if(eTeXmode=1)then decr(saveptr){:292};end else confusion(592);end;
{:291}{298:}procedure preparemag;
begin if(magset>0)and(eqtb[28948].int<>magset)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(596);
end;printint(eqtb[28948].int);print(597);printnl(598);begin helpptr:=2;
helpline[1]:=599;helpline[0]:=600;end;interror(magset);
geqworddefine(28948,magset);end;
if(eqtb[28948].int<=0)or(eqtb[28948].int>32768)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(601);
end;begin helpptr:=1;helpline[0]:=602;end;interror(eqtb[28948].int);
geqworddefine(28948,1000);end;magset:=eqtb[28948].int;end;
{:298}{305:}procedure tokenshow(p:halfword);
begin if p<>-268435455 then showtokenlist(mem[p].hh.rh,-268435455,
10000000);end;{:305}{306:}procedure printmeaning;
begin printcmdchr(curcmd,curchr);
if curcmd>=123 then begin printchar(58);println;tokenshow(curchr);
end else if(curcmd=122)and(curchr<5)then begin printchar(58);println;
tokenshow(curmark[curchr]);end;end;{:306}{309:}procedure showcurcmdchr;
var n:integer;l:integer;p:halfword;begin begindiagnostic;printnl(123);
if curlist.modefield<>shownmode then begin printmode(curlist.modefield);
print(617);shownmode:=curlist.modefield;end;printcmdchr(curcmd,curchr);
if eqtb[28994].int>0 then if curcmd>=117 then if curcmd<=118 then begin
print(617);if curcmd=118 then begin printcmdchr(117,curif);
printchar(32);n:=0;l:=ifline;end else begin n:=1;l:=line;end;p:=condptr;
while p<>-268435455 do begin incr(n);p:=mem[p].hh.rh;end;print(618);
printint(n);printchar(41);if l<>0 then begin print(1497);printint(l);
end;end;printchar(125);enddiagnostic(false);end;
{:309}{321:}procedure showcontext;label 30,31;var oldsetting:0..21;
s:halfword;nn:integer;bottomline:boolean;{325:}i:0..bufsize;
j:0..bufsize;l:0..halferrorline;m:integer;n:0..errorline;p:integer;
q:integer;{:325}begin baseptr:=inputptr;inputstack[baseptr]:=curinput;
nn:=-1;bottomline:=false;
while true do begin curinput:=inputstack[baseptr];
if(curinput.statefield<>0)then if(curinput.namefield>19)or(baseptr=0)
then bottomline:=true;
if(baseptr=inputptr)or bottomline or(nn<eqtb[28986].int)then{322:}begin
if(baseptr=inputptr)or(curinput.statefield<>0)or(curinput.indexfield<>3)
or(curinput.locfield<>-268435455)then begin tally:=0;
oldsetting:=selector;
if curinput.statefield<>0 then begin{323:}if curinput.namefield<=17 then
if(curinput.namefield=0)then if baseptr=0 then printnl(623)else printnl(
624)else begin printnl(625);
if curinput.namefield=17 then printchar(42)else printint(curinput.
namefield-1);printchar(62);end else begin printnl(626);
if curinput.indexfield=inopen then printint(line)else printint(linestack
[curinput.indexfield+1]);end;printchar(32){:323};{328:}begin l:=tally;
tally:=0;selector:=20;kcodepos:=0;trickcount:=1000000;end;
if buffer[curinput.limitfield]=eqtb[28980].int then j:=curinput.
limitfield else j:=curinput.limitfield+1;
if j>0 then for i:=curinput.startfield to j-1 do begin if i=curinput.
locfield then begin firstcount:=tally;
if(firstcount>0)and(trickbuf2[(firstcount-1)mod errorline]=1)then incr(
firstcount);trickcount:=firstcount+1+errorline-halferrorline;
if trickcount<errorline then trickcount:=errorline;end;print(buffer[i]);
end{:328};
end else begin{324:}case curinput.indexfield of 0:printnl(627);
1,2:printnl(628);
3:if curinput.locfield=-268435455 then printnl(629)else printnl(630);
4:printnl(631);5:begin println;printcs(curinput.namefield);end;
6:printnl(632);7:printnl(633);8:printnl(634);9:printnl(635);
10:printnl(636);11:printnl(637);12:printnl(638);13:printnl(639);
14:printnl(640);15:printnl(641);16:printnl(642);
others:printnl(63)end{:324};{329:}begin l:=tally;tally:=0;selector:=20;
kcodepos:=0;trickcount:=1000000;end;
if curinput.indexfield<5 then begin if(curinput.indexfield=3)and(
curinput.locfield<>-268435455)then begin if(mem[curinput.startfield].hh.
rh=-268435455)and(checkkanji(mem[curinput.startfield].hh.lh))then begin
curinput:=inputstack[baseptr-1];s:=getavail;
mem[s].hh.lh:=Lo(mem[curinput.locfield].hh.lh);
curinput:=inputstack[baseptr];mem[curinput.startfield].hh.rh:=s;
showtokenlist(curinput.startfield,curinput.locfield,100000);
begin mem[s].hh.rh:=avail;avail:=s;ifdef('STAT')decr(dynused);
endif('STAT')end;mem[curinput.startfield].hh.rh:=-268435455;goto 31;end;
end;showtokenlist(curinput.startfield,curinput.locfield,100000);
end else showtokenlist(mem[curinput.startfield].hh.rh,curinput.locfield,
100000);31:{:329};end;selector:=oldsetting;
{327:}if trickcount=1000000 then begin firstcount:=tally;
if(firstcount>0)and(trickbuf2[(firstcount-1)mod errorline]=1)then incr(
firstcount);trickcount:=firstcount+1+errorline-halferrorline;
if trickcount<errorline then trickcount:=errorline;end;
if tally<trickcount then m:=tally-firstcount else m:=trickcount-
firstcount;if l+firstcount<=halferrorline then begin p:=0;
n:=l+firstcount;end else begin print(276);
p:=l+firstcount-halferrorline+3;n:=halferrorline;end;
if trickbuf2[p mod errorline]=2 then begin p:=p+1;n:=n-1;end;
for q:=p to firstcount-1 do printchar(trickbuf[q mod errorline]);
println;for q:=1 to n do printchar(32);
if m+n<=errorline then p:=firstcount+m else p:=firstcount+(errorline-n-3
);if trickbuf2[(p-1)mod errorline]=1 then p:=p-1;
for q:=firstcount to p-1 do printchar(trickbuf[q mod errorline]);
if m+n>errorline then print(276){:327};incr(nn);end;
end{:322}else if nn=eqtb[28986].int then begin printnl(276);incr(nn);
end;if bottomline then goto 30;decr(baseptr);end;
30:curinput:=inputstack[inputptr];end;
{:321}{333:}procedure begintokenlist(p:halfword;t:quarterword);
begin begin if inputptr>maxinstack then begin maxinstack:=inputptr;
if inputptr=stacksize then overflow(643,stacksize);end;
inputstack[inputptr]:=curinput;incr(inputptr);end;
curinput.statefield:=0;curinput.startfield:=p;curinput.indexfield:=t;
if t>=5 then begin incr(mem[p].hh.lh);
if t=5 then curinput.limitfield:=paramptr else begin curinput.locfield:=
mem[p].hh.rh;if eqtb[28961].int>1 then begin begindiagnostic;
printnl(343);case t of 14:printesc(360);16:printesc(644);
others:printcmdchr(78,t+25056)end;print(604);tokenshow(p);
enddiagnostic(false);end;end;end else curinput.locfield:=p;end;
{:333}{334:}procedure endtokenlist;
begin if curinput.indexfield>=3 then begin if curinput.indexfield<=4
then flushlist(curinput.startfield)else begin deletetokenref(curinput.
startfield);
if curinput.indexfield=5 then while paramptr>curinput.limitfield do
begin decr(paramptr);flushlist(paramstack[paramptr]);end;end;
end else if curinput.indexfield=1 then if alignstate>500000 then
alignstate:=0 else fatalerror(645);begin decr(inputptr);
curinput:=inputstack[inputptr];end;
begin if interrupt<>0 then pauseforinstructions;end;end;
{:334}{335:}procedure backinput;var p:halfword;
begin while(curinput.statefield=0)and(curinput.locfield=-268435455)and(
curinput.indexfield<>2)do endtokenlist;p:=getavail;mem[p].hh.lh:=curtok;
if curtok<768 then if curtok<512 then decr(alignstate)else incr(
alignstate);
begin if inputptr>maxinstack then begin maxinstack:=inputptr;
if inputptr=stacksize then overflow(643,stacksize);end;
inputstack[inputptr]:=curinput;incr(inputptr);end;
curinput.statefield:=0;curinput.startfield:=p;curinput.indexfield:=3;
curinput.locfield:=p;end;{:335}{337:}procedure backerror;
begin OKtointerrupt:=false;backinput;OKtointerrupt:=true;error;end;
procedure inserror;begin OKtointerrupt:=false;backinput;
curinput.indexfield:=4;OKtointerrupt:=true;error;end;
{:337}{338:}procedure beginfilereading;
begin if inopen=maxinopen then overflow(646,maxinopen);
if first=bufsize then overflow(257,bufsize);incr(inopen);
begin if inputptr>maxinstack then begin maxinstack:=inputptr;
if inputptr=stacksize then overflow(643,stacksize);end;
inputstack[inputptr]:=curinput;incr(inputptr);end;
curinput.indexfield:=inopen;sourcefilenamestack[curinput.indexfield]:=0;
fullsourcefilenamestack[curinput.indexfield]:=0;
eofseen[curinput.indexfield]:=false;
grpstack[curinput.indexfield]:=curboundary;
ifstack[curinput.indexfield]:=condptr;
linestack[curinput.indexfield]:=line;curinput.startfield:=first;
curinput.statefield:=1;curinput.namefield:=0;
{1660:}curinput.synctextagfield:=0;{:1660};end;
{:338}{339:}procedure endfilereading;begin first:=curinput.startfield;
line:=linestack[curinput.indexfield];
if(curinput.namefield=18)or(curinput.namefield=19)then pseudoclose else
if curinput.namefield>17 then aclose(inputfile[curinput.indexfield]);
begin decr(inputptr);curinput:=inputstack[inputptr];end;decr(inopen);
end;{:339}{340:}procedure clearforerrorprompt;
begin while(curinput.statefield<>0)and(curinput.namefield=0)and(inputptr
>0)and(curinput.locfield>curinput.limitfield)do endfilereading;println;;
end;{:340}{346:}procedure checkoutervalidity;var p:halfword;q:halfword;
begin if scannerstatus<>0 then begin deletionsallowed:=false;
{347:}if curcs<>0 then begin if(curinput.statefield=0)or(curinput.
namefield<1)or(curinput.namefield>17)then begin p:=getavail;
mem[p].hh.lh:=65535+curcs;begintokenlist(p,3);end;curcmd:=10;curchr:=32;
end{:347};if scannerstatus>1 then{348:}begin runaway;
if curcs=0 then begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(654);
end else begin curcs:=0;begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(655);
end;end;{349:}p:=getavail;case scannerstatus of 2:begin print(661);
mem[p].hh.lh:=637;end;3:begin print(662);mem[p].hh.lh:=partoken;
longstate:=125;end;4:begin print(663);mem[p].hh.lh:=637;q:=p;
p:=getavail;mem[p].hh.rh:=q;mem[p].hh.lh:=81050;alignstate:=-1000000;
end;5:begin print(664);mem[p].hh.lh:=637;end;end;
begintokenlist(p,4){:349};print(656);sprintcs(warningindex);
begin helpptr:=4;helpline[3]:=657;helpline[2]:=658;helpline[1]:=659;
helpline[0]:=660;end;error;
end{:348}else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(648);
end;printcmdchr(117,curif);print(649);printint(skipline);
begin helpptr:=3;helpline[2]:=650;helpline[1]:=651;helpline[0]:=652;end;
if curcs<>0 then curcs:=0 else helpline[2]:=653;curtok:=81053;inserror;
end;deletionsallowed:=true;end;end;{:346}{350:}procedure firmuptheline;
forward;{:350}{351:}procedure getnext;label 20,25,21,26,40,10;
var k:0..bufsize;t:halfword;cat:0..18;l:0..bufsize;c,cc:ASCIIcode;
d:2..3;begin 20:curcs:=0;
if curinput.statefield<>0 then{353:}begin 25:if curinput.locfield<=
curinput.limitfield then begin curchr:=buffer[curinput.locfield];
incr(curinput.locfield);
if multistrlen(ustringcast(buffer),curinput.limitfield+1,curinput.
locfield-1)=2 then begin curchr:=fromBUFF(ustringcast(buffer),curinput.
limitfield+1,curinput.locfield-1);
curcmd:=eqtb[26617+kcatcodekey(curchr)].hh.rh;incr(curinput.locfield);
end else 21:curcmd:=eqtb[26361+curchr].hh.rh;
{354:}case curinput.statefield+curcmd of{355:}10,29,48,67,49,68{:355}:
goto 25;
1,20,39,58:{366:}begin if curinput.locfield>curinput.limitfield then
curcs:=513 else begin k:=curinput.locfield;curchr:=buffer[k];incr(k);
if multistrlen(ustringcast(buffer),curinput.limitfield+1,k-1)=2 then
begin cat:=eqtb[26617+kcatcodekey(fromBUFF(ustringcast(buffer),curinput.
limitfield+1,k-1))].hh.rh;incr(k);
end else cat:=eqtb[26361+curchr].hh.rh;
26:if(cat=11)or(cat=16)or(cat=17)then curinput.statefield:=39 else if
cat=10 then curinput.statefield:=39 else curinput.statefield:=1;
if cat=18 then begin curcs:=idlookup(curinput.locfield,k-curinput.
locfield);curinput.locfield:=k;goto 40;
end else if((cat=11)or(cat=16)or(cat=17))and(k<=curinput.limitfield)then
{368:}begin repeat curchr:=buffer[k];incr(k);
if multistrlen(ustringcast(buffer),curinput.limitfield+1,k-1)=2 then
begin cat:=eqtb[26617+kcatcodekey(fromBUFF(ustringcast(buffer),curinput.
limitfield+1,k-1))].hh.rh;incr(k);
end else cat:=eqtb[26361+curchr].hh.rh;
while(buffer[k]=curchr)and(cat=7)and(k<curinput.limitfield)do begin c:=
buffer[k+1];if c<128 then begin d:=2;
if(((c>=48)and(c<=57))or((c>=97)and(c<=102)))then if k+2<=curinput.
limitfield then begin cc:=buffer[k+2];
if(((cc>=48)and(cc<=57))or((cc>=97)and(cc<=102)))then incr(d);end;
if d>2 then begin if c<=57 then curchr:=c-48 else curchr:=c-87;
if cc<=57 then curchr:=16*curchr+cc-48 else curchr:=16*curchr+cc-87;
end else if c<64 then curchr:=c+64 else curchr:=c-64;
cat:=eqtb[26361+curchr].hh.rh;
if(cat=11)or(cat=7)then begin buffer[k-1]:=curchr;
curinput.limitfield:=curinput.limitfield-d;first:=first-d;l:=k;
while l<=curinput.limitfield do begin buffer[l]:=buffer[l+d];incr(l);
end;end;end;end;
until not((cat=11)or(cat=16)or(cat=17))or(k>curinput.limitfield);
if not((cat=11)or(cat=16)or(cat=17))then decr(k);if cat=18 then decr(k);
if k>curinput.locfield+1 then begin curcs:=idlookup(curinput.locfield,k-
curinput.locfield);curinput.locfield:=k;goto 40;end;
end{:368}else{367:}begin if buffer[k]=curchr then if cat=7 then if k<
curinput.limitfield then begin c:=buffer[k+1];if c<128 then begin d:=2;
if(((c>=48)and(c<=57))or((c>=97)and(c<=102)))then if k+2<=curinput.
limitfield then begin cc:=buffer[k+2];
if(((cc>=48)and(cc<=57))or((cc>=97)and(cc<=102)))then incr(d);end;
if d>2 then begin if c<=57 then curchr:=c-48 else curchr:=c-87;
if cc<=57 then curchr:=16*curchr+cc-48 else curchr:=16*curchr+cc-87;
buffer[k-1]:=curchr;
end else if c<64 then buffer[k-1]:=c+64 else buffer[k-1]:=c-64;
curinput.limitfield:=curinput.limitfield-d;first:=first-d;l:=k;
curchr:=buffer[k-1];cat:=eqtb[26361+curchr].hh.rh;
while l<=curinput.limitfield do begin buffer[l]:=buffer[l+d];incr(l);
end;goto 26;end;end;end{:367};curcs:=257+buffer[curinput.locfield];
incr(curinput.locfield);end;40:curcmd:=eqtb[curcs].hh.b0;
curchr:=eqtb[curcs].hh.rh;if curcmd>=125 then checkoutervalidity;
end{:366};14,33,52,71:{365:}begin curcs:=curchr+1;
curcmd:=eqtb[curcs].hh.b0;curchr:=eqtb[curcs].hh.rh;
curinput.statefield:=1;if curcmd>=125 then checkoutervalidity;end{:365};
8,27,46,65:{364:}begin if curchr=buffer[curinput.locfield]then if
curinput.locfield<curinput.limitfield then begin c:=buffer[curinput.
locfield+1];if c<128 then begin curinput.locfield:=curinput.locfield+2;
if(((c>=48)and(c<=57))or((c>=97)and(c<=102)))then if curinput.locfield<=
curinput.limitfield then begin cc:=buffer[curinput.locfield];
if(((cc>=48)and(cc<=57))or((cc>=97)and(cc<=102)))then begin incr(
curinput.locfield);if c<=57 then curchr:=c-48 else curchr:=c-87;
if cc<=57 then curchr:=16*curchr+cc-48 else curchr:=16*curchr+cc-87;
goto 21;end;end;if c<64 then curchr:=c+64 else curchr:=c-64;goto 21;end;
end;curinput.statefield:=1;end{:364};
16,35,54,73:{356:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(665);
end;begin helpptr:=2;helpline[1]:=666;helpline[0]:=667;end;
deletionsallowed:=false;error;deletionsallowed:=true;goto 20;end{:356};
{357:}30,11:{361:}begin curinput.statefield:=39;curchr:=32;end{:361};
6:{360:}begin curinput.locfield:=curinput.limitfield+1;curcmd:=10;
curchr:=32;end{:360};
25:if skipmode then{362:}begin curinput.locfield:=curinput.limitfield+1;
goto 25;
end{:362}else{360:}begin curinput.locfield:=curinput.limitfield+1;
curcmd:=10;curchr:=32;end{:360};
44,15,34,53,72:{362:}begin curinput.locfield:=curinput.limitfield+1;
goto 25;end{:362};
63:{363:}begin curinput.locfield:=curinput.limitfield+1;curcs:=parloc;
curcmd:=eqtb[curcs].hh.b0;curchr:=eqtb[curcs].hh.rh;
if curcmd>=125 then checkoutervalidity;end{:363};2,21:incr(alignstate);
40,59:begin curinput.statefield:=1;incr(alignstate);end;
3,22:decr(alignstate);41,60:begin curinput.statefield:=1;
decr(alignstate);end;
42,43,45,47,50,51,61,62,64,66,69,70,23,24,26,28,31,32:curinput.
statefield:=1;55,56,57,74,75,76,17,18,19:curinput.statefield:=20;
{:357}others:end{:354};end else begin curinput.statefield:=58;
{372:}if curinput.namefield>17 then{374:}begin incr(line);
first:=curinput.startfield;
if not forceeof then if curinput.namefield<=19 then begin if pseudoinput
then firmuptheline else if(eqtb[25071].hh.rh<>-268435455)and not eofseen
[curinput.indexfield]then begin curinput.limitfield:=first-1;
eofseen[curinput.indexfield]:=true;begintokenlist(eqtb[25071].hh.rh,15);
goto 20;end else forceeof:=true;
end else begin if inputln(inputfile[curinput.indexfield],true)then
firmuptheline else if(eqtb[25071].hh.rh<>-268435455)and not eofseen[
curinput.indexfield]then begin curinput.limitfield:=first-1;
eofseen[curinput.indexfield]:=true;begintokenlist(eqtb[25071].hh.rh,15);
goto 20;end else forceeof:=true;end;
if forceeof then begin if eqtb[28996].int>0 then if(grpstack[inopen]<>
curboundary)or(ifstack[inopen]<>condptr)then filewarning;
if curinput.namefield>=19 then begin printchar(41);decr(openparens);
fflush(stdout);end;forceeof:=false;endfilereading;checkoutervalidity;
goto 20;end;
if(eqtb[28980].int<0)or(eqtb[28980].int>255)then decr(curinput.
limitfield)else buffer[curinput.limitfield]:=eqtb[28980].int;
first:=curinput.limitfield+1;curinput.locfield:=curinput.startfield;
end{:374}else begin if not(curinput.namefield=0)then begin curcmd:=0;
curchr:=0;goto 10;end;if inputptr>0 then begin endfilereading;goto 20;
end;if selector<18 then openlogfile;
if interaction>1 then begin if(eqtb[28980].int<0)or(eqtb[28980].int>255)
then incr(curinput.limitfield);
if curinput.limitfield=curinput.startfield then printnl(668);println;
first:=curinput.startfield;begin;print(42);terminput;end;
curinput.limitfield:=last;
if(eqtb[28980].int<0)or(eqtb[28980].int>255)then decr(curinput.
limitfield)else buffer[curinput.limitfield]:=eqtb[28980].int;
first:=curinput.limitfield+1;curinput.locfield:=curinput.startfield;
end else fatalerror(669);end{:372};
begin if interrupt<>0 then pauseforinstructions;end;goto 25;end;
end{:353}else{369:}if curinput.locfield<>-268435455 then begin t:=mem[
curinput.locfield].hh.lh;
curinput.locfield:=mem[curinput.locfield].hh.rh;
if t>=65535 then begin curcs:=t-65535;curcmd:=eqtb[curcs].hh.b0;
curchr:=eqtb[curcs].hh.rh;
if curcmd>=125 then if curcmd=128 then{370:}begin curcs:=mem[curinput.
locfield].hh.lh-65535;curinput.locfield:=-268435455;
curcmd:=eqtb[curcs].hh.b0;curchr:=eqtb[curcs].hh.rh;
if curcmd>112 then begin curcmd:=0;curchr:=257;end;
end{:370}else checkoutervalidity;
end else if checkkanji(t)then begin curchr:=t;
curcmd:=eqtb[26617+kcatcodekey(t)].hh.rh;end else begin curcmd:=Hi(t);
curchr:=Lo(t);case curcmd of 1:incr(alignstate);2:decr(alignstate);
5:{371:}begin begintokenlist(paramstack[curinput.limitfield+curchr-1],0)
;goto 20;end{:371};others:end;end;end else begin endtokenlist;goto 20;
end{:369};
{352:}if curcmd<=5 then if curcmd>=4 then if alignstate=0 then{806:}
begin if(scannerstatus=4)or(curalign=-268435455)then fatalerror(645);
curcmd:=mem[curalign+5].hh.lh;mem[curalign+5].hh.lh:=curchr;
if curcmd=66 then begintokenlist(memtop-10,2)else begintokenlist(mem[
curalign+2].int,2);alignstate:=1000000;goto 20;end{:806}{:352};10:end;
{:351}{375:}procedure firmuptheline;var k:0..bufsize;
begin curinput.limitfield:=last;
if eqtb[28959].int>0 then if interaction>1 then begin;println;
if curinput.startfield<curinput.limitfield then for k:=curinput.
startfield to curinput.limitfield-1 do print(buffer[k]);
first:=curinput.limitfield;begin;print(670);terminput;end;
if last>first then begin for k:=first to last-1 do buffer[k+curinput.
startfield-first]:=buffer[k];
curinput.limitfield:=curinput.startfield+last-first;end;end;end;
{:375}{377:}procedure gettoken;begin nonewcontrolsequence:=false;
getnext;nonewcontrolsequence:=true;
if curcs=0 then if(curcmd=16)or(curcmd=17)or(curcmd=18)then curtok:=
curchr else curtok:=(curcmd*256)+curchr else curtok:=65535+curcs;end;
{:377}{381:}{406:}procedure macrocall;label 10,22,30,31,40;
var r:halfword;p:halfword;q:halfword;s:halfword;t:halfword;u,v:halfword;
rbraceptr:halfword;n:smallnumber;unbalance:halfword;m:halfword;
refcount:halfword;savescannerstatus:smallnumber;
savewarningindex:halfword;matchchr:ASCIIcode;
begin savescannerstatus:=scannerstatus;savewarningindex:=warningindex;
warningindex:=curcs;refcount:=curchr;r:=mem[refcount].hh.rh;n:=0;
if eqtb[28961].int>0 then{418:}begin begindiagnostic;println;
printcs(warningindex);tokenshow(refcount);enddiagnostic(false);
end{:418};if mem[r].hh.lh=3585 then r:=mem[r].hh.rh;
if mem[r].hh.lh<>3584 then{408:}begin scannerstatus:=3;unbalance:=0;
longstate:=eqtb[curcs].hh.b0;
if longstate>=125 then longstate:=longstate-2;
repeat mem[memtop-3].hh.rh:=-268435455;
if(mem[r].hh.lh>3583)or(mem[r].hh.lh<3328)then s:=-268435455 else begin
matchchr:=mem[r].hh.lh-3328;s:=mem[r].hh.rh;r:=s;p:=memtop-3;m:=0;end;
{409:}22:gettoken;
if curtok=mem[r].hh.lh then{411:}begin r:=mem[r].hh.rh;
if(mem[r].hh.lh>=3328)and(mem[r].hh.lh<=3584)then begin if curtok<512
then decr(alignstate);goto 40;end else goto 22;end{:411};
{414:}if s<>r then if s=-268435455 then{415:}begin begin if interaction=
3 then;if filelineerrorstylep then printfileline else printnl(263);
print(706);end;sprintcs(warningindex);print(707);begin helpptr:=4;
helpline[3]:=708;helpline[2]:=709;helpline[1]:=710;helpline[0]:=711;end;
error;goto 10;end{:415}else begin t:=s;repeat begin q:=getavail;
mem[p].hh.rh:=q;mem[q].hh.lh:=mem[t].hh.lh;p:=q;end;incr(m);
u:=mem[t].hh.rh;v:=s;
while true do begin if u=r then if curtok<>mem[v].hh.lh then goto 30
else begin r:=mem[v].hh.rh;goto 22;end;
if mem[u].hh.lh<>mem[v].hh.lh then goto 30;u:=mem[u].hh.rh;
v:=mem[v].hh.rh;end;30:t:=mem[t].hh.rh;until t=r;r:=s;end{:414};
if curtok=partoken then if longstate<>124 then{413:}begin if longstate=
123 then begin runaway;begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(701);
end;sprintcs(warningindex);print(702);begin helpptr:=3;helpline[2]:=703;
helpline[1]:=704;helpline[0]:=705;end;backerror;end;
pstack[n]:=mem[memtop-3].hh.rh;alignstate:=alignstate-unbalance;
for m:=0 to n do flushlist(pstack[m]);goto 10;end{:413};
if curtok<768 then if curtok<512 then{416:}begin unbalance:=1;
while true do begin begin begin q:=avail;
if q=-268435455 then q:=getavail else begin avail:=mem[q].hh.rh;
mem[q].hh.rh:=-268435455;ifdef('STAT')incr(dynused);endif('STAT')end;
end;mem[p].hh.rh:=q;mem[q].hh.lh:=curtok;p:=q;end;gettoken;
if curtok=partoken then if longstate<>124 then{413:}begin if longstate=
123 then begin runaway;begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(701);
end;sprintcs(warningindex);print(702);begin helpptr:=3;helpline[2]:=703;
helpline[1]:=704;helpline[0]:=705;end;backerror;end;
pstack[n]:=mem[memtop-3].hh.rh;alignstate:=alignstate-unbalance;
for m:=0 to n do flushlist(pstack[m]);goto 10;end{:413};
if curtok<768 then if curtok<512 then incr(unbalance)else begin decr(
unbalance);if unbalance=0 then goto 31;end;end;31:rbraceptr:=p;
begin q:=getavail;mem[p].hh.rh:=q;mem[q].hh.lh:=curtok;p:=q;end;
end{:416}else{412:}begin backinput;begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(693);
end;sprintcs(warningindex);print(694);begin helpptr:=6;helpline[5]:=695;
helpline[4]:=696;helpline[3]:=697;helpline[2]:=698;helpline[1]:=699;
helpline[0]:=700;end;incr(alignstate);longstate:=123;curtok:=partoken;
inserror;goto 22;
end{:412}else{410:}begin if curtok=2592 then if mem[r].hh.lh<=3584 then
if mem[r].hh.lh>=3328 then goto 22;begin q:=getavail;mem[p].hh.rh:=q;
mem[q].hh.lh:=curtok;p:=q;end;end{:410};incr(m);
if mem[r].hh.lh>3584 then goto 22;if mem[r].hh.lh<3328 then goto 22;
40:if s<>-268435455 then{417:}begin if(m=1)and(mem[p].hh.lh<768)and(p<>
memtop-3)then begin mem[rbraceptr].hh.rh:=-268435455;
begin mem[p].hh.rh:=avail;avail:=p;ifdef('STAT')decr(dynused);
endif('STAT')end;p:=mem[memtop-3].hh.rh;pstack[n]:=mem[p].hh.rh;
begin mem[p].hh.rh:=avail;avail:=p;ifdef('STAT')decr(dynused);
endif('STAT')end;end else pstack[n]:=mem[memtop-3].hh.rh;incr(n);
if eqtb[28961].int>0 then begin begindiagnostic;printnl(matchchr);
printint(n);print(712);showtokenlist(pstack[n-1],-268435455,1000);
enddiagnostic(false);end;end{:417}{:409};until mem[r].hh.lh=3584;
end{:408};
{407:}while(curinput.statefield=0)and(curinput.locfield=-268435455)and(
curinput.indexfield<>2)do endtokenlist;begintokenlist(refcount,5);
curinput.namefield:=warningindex;curinput.locfield:=mem[r].hh.rh;
if n>0 then begin if paramptr+n>maxparamstack then begin maxparamstack:=
paramptr+n;if maxparamstack>paramsize then overflow(692,paramsize);end;
for m:=0 to n-1 do paramstack[paramptr+m]:=pstack[m];
paramptr:=paramptr+n;end{:407};10:scannerstatus:=savescannerstatus;
warningindex:=savewarningindex;end;{:406}{396:}procedure insertrelax;
begin curtok:=65535+curcs;backinput;curtok:=81056;backinput;
curinput.indexfield:=4;end;{:396}{1506:}procedure pseudostart;forward;
{:1506}{1564:}procedure scanregisternum;forward;
{:1564}{1569:}procedure newindex(i:quarterword;q:halfword);
var k:smallnumber;begin curptr:=getnode(9);mem[curptr].hh.b0:=i;
mem[curptr].hh.b1:=0;mem[curptr].hh.rh:=q;
for k:=1 to 8 do mem[curptr+k]:=sanull;end;
{:1569}{1573:}procedure findsaelement(t:smallnumber;n:halfword;
w:boolean);label 45,46,47,48,49,50,10;var q:halfword;i:smallnumber;
begin curptr:=saroot[t];
begin if curptr=-268435455 then if w then goto 45 else goto 10;end;
q:=curptr;i:=n div 65536;
if odd(i)then curptr:=mem[q+(i div 2)+1].hh.rh else curptr:=mem[q+(i div
2)+1].hh.lh;
begin if curptr=-268435455 then if w then goto 46 else goto 10;end;
q:=curptr;i:=(n div 4096)mod 16;
if odd(i)then curptr:=mem[q+(i div 2)+1].hh.rh else curptr:=mem[q+(i div
2)+1].hh.lh;
begin if curptr=-268435455 then if w then goto 47 else goto 10;end;
q:=curptr;i:=(n div 256)mod 16;
if odd(i)then curptr:=mem[q+(i div 2)+1].hh.rh else curptr:=mem[q+(i div
2)+1].hh.lh;
begin if curptr=-268435455 then if w then goto 48 else goto 10;end;
q:=curptr;i:=(n div 16)mod 16;
if odd(i)then curptr:=mem[q+(i div 2)+1].hh.rh else curptr:=mem[q+(i div
2)+1].hh.lh;
begin if curptr=-268435455 then if w then goto 49 else goto 10;end;
q:=curptr;i:=n mod 16;
if odd(i)then curptr:=mem[q+(i div 2)+1].hh.rh else curptr:=mem[q+(i div
2)+1].hh.lh;if(curptr=-268435455)and w then goto 50;goto 10;
45:newindex(t,-268435455);saroot[t]:=curptr;q:=curptr;i:=n div 65536;
46:newindex(i,q);
begin if odd(i)then mem[q+(i div 2)+1].hh.rh:=curptr else mem[q+(i div 2
)+1].hh.lh:=curptr;incr(mem[q].hh.b1);end;q:=curptr;
i:=(n div 4096)mod 16;47:newindex(i,q);
begin if odd(i)then mem[q+(i div 2)+1].hh.rh:=curptr else mem[q+(i div 2
)+1].hh.lh:=curptr;incr(mem[q].hh.b1);end;q:=curptr;
i:=(n div 256)mod 16;48:newindex(i,q);
begin if odd(i)then mem[q+(i div 2)+1].hh.rh:=curptr else mem[q+(i div 2
)+1].hh.lh:=curptr;incr(mem[q].hh.b1);end;q:=curptr;i:=(n div 16)mod 16;
49:newindex(i,q);
begin if odd(i)then mem[q+(i div 2)+1].hh.rh:=curptr else mem[q+(i div 2
)+1].hh.lh:=curptr;incr(mem[q].hh.b1);end;q:=curptr;i:=n mod 16;
50:{1574:}if t=6 then begin curptr:=getnode(4);mem[curptr+1]:=sanull;
mem[curptr+2]:=sanull;mem[curptr+3]:=sanull;
end else begin if t<=1 then begin curptr:=getnode(3);
mem[curptr+2].int:=0;mem[curptr+1].hh.rh:=n;
end else begin curptr:=getnode(2);
if t<=3 then begin mem[curptr+1].hh.rh:=membot;incr(mem[membot].hh.rh);
end else mem[curptr+1].hh.rh:=-268435455;end;
mem[curptr+1].hh.lh:=-268435455;end;mem[curptr].hh.b0:=16*t+i;
mem[curptr].hh.b1:=1{:1574};mem[curptr].hh.rh:=q;
begin if odd(i)then mem[q+(i div 2)+1].hh.rh:=curptr else mem[q+(i div 2
)+1].hh.lh:=curptr;incr(mem[q].hh.b1);end;10:end;
{:1573}procedure passtext;forward;procedure startinput;forward;
procedure conditional;forward;procedure getxtoken;forward;
procedure convtoks;forward;procedure insthetoks;forward;
procedure expand;label 21;var t:halfword;p,q,r:halfword;j:0..bufsize;
cvbackup:integer;cvlbackup,radixbackup,cobackup:smallnumber;
backupbackup:halfword;savescannerstatus:smallnumber;
begin incr(expanddepthcount);
if expanddepthcount>=expanddepth then overflow(671,expanddepth);
cvbackup:=curval;cvlbackup:=curvallevel;radixbackup:=radix;
cobackup:=curorder;backupbackup:=mem[memtop-13].hh.rh;
21:if curcmd<123 then{382:}begin if eqtb[28967].int>1 then showcurcmdchr
;case curcmd of 122:{403:}begin t:=curchr mod 5;
if curchr>=5 then scanregisternum else curval:=0;
if curval=0 then curptr:=curmark[t]else{1578:}begin findsaelement(6,
curval,false);
if curptr<>-268435455 then if odd(t)then curptr:=mem[curptr+(t div 2)+1]
.hh.rh else curptr:=mem[curptr+(t div 2)+1].hh.lh;end{:1578};
if curptr<>-268435455 then begintokenlist(curptr,14);end{:403};
114:if curchr=0 then{383:}begin gettoken;t:=curtok;gettoken;
if curcmd>112 then expand else backinput;curtok:=t;backinput;
end{:383}else{1519:}begin gettoken;
if(curcmd=117)and(curchr<>16)then begin curchr:=curchr+32;goto 21;end;
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(746);
end;printesc(865);print(1523);printcmdchr(curcmd,curchr);printchar(39);
begin helpptr:=1;helpline[0]:=667;end;backerror;end{:1519};
115:if curchr=0 then{384:}begin savescannerstatus:=scannerstatus;
scannerstatus:=0;gettoken;scannerstatus:=savescannerstatus;t:=curtok;
backinput;if t>=65535 then begin p:=getavail;mem[p].hh.lh:=81058;
mem[p].hh.rh:=curinput.locfield;curinput.startfield:=p;
curinput.locfield:=p;end;
end{:384}else{385:}begin savescannerstatus:=scannerstatus;
scannerstatus:=0;gettoken;scannerstatus:=savescannerstatus;
if curcs<514 then curcs:=primlookup(curcs-257)else curcs:=primlookup(
hash[curcs].rh);if curcs<>0 then begin t:=primeqtb[curcs].hh.b0;
if t>112 then begin curcmd:=t;curchr:=primeqtb[curcs].hh.rh;
curtok:=(curcmd*256)+curchr;curcs:=0;goto 21;end else begin backinput;
p:=getavail;mem[p].hh.lh:=81060;mem[p].hh.rh:=curinput.locfield;
curinput.locfield:=p;curinput.startfield:=p;end;
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(672);
end;begin helpptr:=2;helpline[1]:=673;helpline[0]:=674;end;backerror;
end;end{:385};119:{389:}begin r:=getavail;p:=r;repeat getxtoken;
if curcs=0 then begin q:=getavail;mem[p].hh.rh:=q;mem[q].hh.lh:=curtok;
p:=q;end;until curcs<>0;
if curcmd<>70 then{390:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(681);
end;printesc(543);print(682);begin helpptr:=2;helpline[1]:=683;
helpline[0]:=684;end;backerror;end{:390};{391:}j:=first;p:=mem[r].hh.rh;
while p<>-268435455 do begin if j>=maxbufstack then begin maxbufstack:=j
+1;if maxbufstack=bufsize then overflow(257,bufsize);end;
if checkkanji(mem[p].hh.lh)then begin buffer[j]:=Hi(mem[p].hh.lh);
incr(j);end;buffer[j]:=Lo(mem[p].hh.lh);incr(j);p:=mem[p].hh.rh;end;
if j>first+1 then begin nonewcontrolsequence:=false;
curcs:=idlookup(first,j-first);nonewcontrolsequence:=true;
end else if j=first then curcs:=513 else curcs:=257+buffer[first]{:391};
flushlist(r);if eqtb[curcs].hh.b0=113 then begin eqdefine(curcs,0,256);
end;curtok:=curcs+65535;backinput;end{:389};120:convtoks;121:insthetoks;
117:conditional;
118:{527:}begin if eqtb[28994].int>0 then if eqtb[28967].int<=1 then
showcurcmdchr;
if curchr>iflimit then if iflimit=1 then insertrelax else begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(869);
end;printcmdchr(118,curchr);begin helpptr:=1;helpline[0]:=870;end;error;
end else begin while curchr<>2 do passtext;
{513:}begin if ifstack[inopen]=condptr then ifwarning;p:=condptr;
ifline:=mem[p+1].int;curif:=mem[p].hh.b1;iflimit:=mem[p].hh.b0;
condptr:=mem[p].hh.rh;freenode(p,2);end{:513};end;end{:527};
116:{395:}if curchr=1 then forceeof:=true{1503:}else if curchr=2 then
pseudostart{:1503}else if nameinprogress then insertrelax else
startinput{:395};others:{387:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(675);
end;begin helpptr:=5;helpline[4]:=676;helpline[3]:=677;helpline[2]:=678;
helpline[1]:=679;helpline[0]:=680;end;error;end{:387}end;
end{:382}else if curcmd<127 then macrocall else{392:}begin curtok:=81055
;backinput;end{:392};curval:=cvbackup;curvallevel:=cvlbackup;
radix:=radixbackup;curorder:=cobackup;
mem[memtop-13].hh.rh:=backupbackup;decr(expanddepthcount);end;
{:381}{397:}procedure getxtoken;label 20,30;begin 20:getnext;
if curcmd<=112 then goto 30;
if curcmd>=123 then if curcmd<127 then macrocall else begin curcs:=15520
;curcmd:=9;goto 30;end else expand;goto 20;
30:if curcs=0 then if(curcmd=16)or(curcmd=17)or(curcmd=18)then curtok:=
curchr else curtok:=(curcmd*256)+curchr else curtok:=65535+curcs;end;
{:397}{398:}procedure xtoken;begin while curcmd>112 do begin expand;
getnext;end;
if curcs=0 then if(curcmd=16)or(curcmd=17)or(curcmd=18)then curtok:=
curchr else curtok:=(curcmd*256)+curchr else curtok:=65535+curcs;end;
{:398}{420:}procedure scanleftbrace;begin{421:}repeat getxtoken;
until(curcmd<>10)and(curcmd<>0){:421};
if curcmd<>1 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(713);
end;begin helpptr:=4;helpline[3]:=714;helpline[2]:=715;helpline[1]:=716;
helpline[0]:=717;end;backerror;curtok:=379;curcmd:=1;curchr:=123;
incr(alignstate);end;end;{:420}{422:}procedure scanoptionalequals;
begin{423:}repeat getxtoken;until curcmd<>10{:423};
if curtok<>3133 then backinput;end;
{:422}{424:}function scankeyword(s:strnumber):boolean;label 10;
var p:halfword;q:halfword;k:poolpointer;begin p:=memtop-13;
mem[p].hh.rh:=-268435455;k:=strstart[s];
while k<strstart[s+1]do begin getxtoken;
if(curcs=0)and((curchr=strpool[k])or(curchr=strpool[k]-32))then begin
begin q:=getavail;mem[p].hh.rh:=q;mem[q].hh.lh:=curtok;p:=q;end;incr(k);
end else if(curcmd<>10)or(p<>memtop-13)then begin backinput;
if p<>memtop-13 then begintokenlist(mem[memtop-13].hh.rh,3);
scankeyword:=false;goto 10;end;end;flushlist(mem[memtop-13].hh.rh);
scankeyword:=true;10:end;{:424}{425:}procedure muerror;
begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(718);
end;begin helpptr:=1;helpline[0]:=719;end;error;end;
{:425}{426:}procedure scanint;forward;{450:}procedure scaneightbitint;
begin scanint;
if(curval<0)or(curval>255)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(748);
end;begin helpptr:=2;helpline[1]:=749;helpline[0]:=722;end;
interror(curval);curval:=0;end;end;{:450}{451:}procedure scancharnum;
begin scanint;
if not ischarascii(curval)and not ischarkanji(curval)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(750);
end;begin helpptr:=2;helpline[1]:=751;helpline[0]:=722;end;
interror(curval);curval:=0;end;end;{:451}{452:}procedure scanfourbitint;
begin scanint;
if(curval<0)or(curval>15)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(752);
end;begin helpptr:=2;helpline[1]:=753;helpline[0]:=722;end;
interror(curval);curval:=0;end;end;procedure scanbigfourbitint;
begin scanint;
if(curval<0)or(curval>255)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(752);
end;begin helpptr:=2;helpline[1]:=754;helpline[0]:=722;end;
interror(curval);curval:=0;end;end;
{:452}{453:}procedure scanfifteenbitint;begin scanint;
if(curval<0)or(curval>32767)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(755);
end;begin helpptr:=2;helpline[1]:=756;helpline[0]:=722;end;
interror(curval);curval:=0;end;
curval:=((curval div 4096)*65536)+(curval mod 4096);end;
procedure scanrealfifteenbitint;begin scanint;
if(curval<0)or(curval>32767)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(755);
end;begin helpptr:=2;helpline[1]:=756;helpline[0]:=722;end;
interror(curval);curval:=0;end;end;procedure scanbigfifteenbitint;
begin scanint;
if(curval<0)or(curval>134217727)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(757);
end;begin helpptr:=2;helpline[1]:=758;helpline[0]:=722;end;
interror(curval);curval:=0;end;
curval:=((curval div 65536)*256)+(curval mod 256);end;
procedure scanomegafifteenbitint;begin scanint;
if(curval<0)or(curval>134217727)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(757);
end;begin helpptr:=2;helpline[1]:=758;helpline[0]:=722;end;
interror(curval);curval:=0;end;end;
{:453}{454:}procedure scantwentysevenbitint;begin scanint;
if(curval<0)or(curval>134217727)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(759);
end;begin helpptr:=2;helpline[1]:=724;helpline[0]:=722;end;
interror(curval);curval:=0;end;curval1:=curval mod 4096;
curval:=curval div 4096;
curval:=((curval div 4096)*65536)+(curval mod 4096);end;
procedure scanfiftyonebitint;var iiii:integer;begin scanint;
if(curval<0)or(curval>134217727)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(759);
end;begin helpptr:=2;helpline[1]:=760;helpline[0]:=722;end;
interror(curval);curval:=0;end;
iiii:=((curval div 65536)*256)+(curval mod 256);scanint;
if(curval<0)or(curval>16777215)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(759);
end;begin helpptr:=2;helpline[1]:=761;helpline[0]:=722;end;
interror(curval);curval:=0;end;
curval1:=((curval div 65536)*256)+(curval mod 256);curval:=iiii;end;
{:454}{1565:}procedure scanregisternum;begin scanint;
if(curval<0)or(curval>maxregnum)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(748);
end;begin helpptr:=2;helpline[1]:=maxreghelpline;helpline[0]:=722;end;
interror(curval);curval:=0;end;end;
{:1565}{1628:}procedure scanfourbitintor18;begin scanint;
if(curval<0)or((curval>15)and(curval<>18))then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(752);
end;begin helpptr:=2;helpline[1]:=753;helpline[0]:=722;end;
interror(curval);curval:=0;end;end;
{:1628}{1432:}procedure scangeneraltext;forward;
{:1432}{1526:}procedure getxorprotected;label 10;
begin while true do begin gettoken;if curcmd<=112 then goto 10;
if(curcmd>=123)and(curcmd<127)then if mem[mem[curchr].hh.rh].hh.lh=3585
then goto 10;expand;end;10:end;{:1526}{1535:}procedure scanexpr;forward;
{:1535}{1540:}procedure scannormalglue;forward;procedure scanmuglue;
forward;{:1540}{1636:}function effectivechar(errp:boolean;
f:internalfontnumber;c:quarterword):integer;label 40;var basec:integer;
result:integer;begin result:=c;if not mltexenabledp then goto 40;
if fontec[f]>=c then if fontbc[f]<=c then if(fontinfo[charbase[f]+c].
qqqq.b0>0)then goto 40;
if c>=eqtb[28988].int then if c<=eqtb[28989].int then if(eqtb[28675+c].
hh.rh>0)then begin basec:=(eqtb[28675+c].hh.rh mod 256);result:=basec;
if not errp then goto 40;
if fontec[f]>=basec then if fontbc[f]<=basec then if(fontinfo[charbase[f
]+basec].qqqq.b0>0)then goto 40;end;if errp then begin begindiagnostic;
printnl(917);print(1556);print(c);print(918);slowprint(fontname[f]);
printchar(33);enddiagnostic(false);result:=fontbc[f];end;
40:effectivechar:=result;end;{:1636}{594:}procedure scanfontident;
var f:internalfontnumber;m:halfword;begin{423:}repeat getxtoken;
until curcmd<>10{:423};
if curcmd=98 then f:=eqtb[26357].hh.rh else if curcmd=99 then f:=eqtb[
26358].hh.rh else if curcmd=97 then f:=eqtb[25588].hh.rh else if curcmd=
96 then f:=curchr else if curcmd=95 then begin m:=curchr;
scanbigfourbitint;f:=eqtb[m+curval].hh.rh;
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(909);
end;begin helpptr:=2;helpline[1]:=910;helpline[0]:=911;end;backerror;
f:=0;end;curval:=f;end;
{:594}{595:}procedure findfontdimen(writing:boolean);
var f:internalfontnumber;n:integer;begin scanint;n:=curval;
scanfontident;f:=curval;
if n<=0 then curval:=fmemptr else begin if writing and(n<=4)and(n>=2)and
(fontglue[f]<>-268435455)then begin deleteglueref(fontglue[f]);
fontglue[f]:=-268435455;end;
if n>fontparams[f]then if f<fontptr then curval:=fmemptr else{597:}begin
repeat if fmemptr=fontmemsize then overflow(916,fontmemsize);
fontinfo[fmemptr].int:=0;incr(fmemptr);incr(fontparams[f]);
until n=fontparams[f];curval:=fmemptr-1;
end{:597}else curval:=n+parambase[f];end;
{596:}if curval=fmemptr then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(894);
end;printesc(hash[15526+f].rh);print(912);printint(fontparams[f]);
print(913);begin helpptr:=2;helpline[1]:=914;helpline[0]:=915;end;error;
end{:596};end;{:595}{1680:}function getjfmpos(kcode:KANJIcode;
f:internalfontnumber):eightbits;var jc:KANJIcode;sp,mp,ep:halfword;
begin if f=0 then begin getjfmpos:=fontinfo[ctypebase[0]+0].hh.lhfield;
goto 10;end;jc:=toDVI(kcode);sp:=1;ep:=fontnumext[f]-1;
if(ep>=1)and(fontinfo[ctypebase[f]+sp].hh.rh<=jc)and(jc<=fontinfo[
ctypebase[f]+ep].hh.rh)then begin while(sp<=ep)do begin mp:=sp+((ep-sp)
div 2);
if jc<fontinfo[ctypebase[f]+mp].hh.rh then ep:=mp-1 else if jc>fontinfo[
ctypebase[f]+mp].hh.rh then sp:=mp+1 else begin getjfmpos:=fontinfo[
ctypebase[f]+mp].hh.lhfield;goto 10;end;end;end;
getjfmpos:=fontinfo[ctypebase[f]+0].hh.lhfield;end;
{:1680}{:426}{430:}{1689:}procedure printkansuji(n:integer);var k:0..23;
cx:KANJIcode;begin k:=0;if n<0 then goto 10;repeat dig[k]:=n mod 10;
n:=n div 10;incr(k);until n=0;begin while k>0 do begin decr(k);
cx:=eqtb[27641+dig[k]].hh.rh;printkanji(fromDVI(cx));end;end;end;
{:1689}{1699:}function getinhibitpos(c:KANJIcode;
n:smallnumber):halfword;label 30,31;var p,s:halfword;
begin s:=calcpos(c);p:=s;
if n=0 then begin repeat if(eqtb[27129+p].hh.rh=0)or(eqtb[27129+p].hh.rh
=c)then goto 30;incr(p);if p>255 then p:=0;until s=p;p:=1000;
end else begin repeat if eqtb[27129+p].hh.rh=0 then goto 31;
if eqtb[27129+p].hh.rh=c then goto 30;incr(p);if p>255 then p:=0;
until s=p;31:p:=1000;end;30:getinhibitpos:=p;end;
{:1699}{1704:}function getkinsokupos(c:KANJIcode;
n:smallnumber):halfword;label 30,31;var p,s:halfword;
begin s:=calcpos(c);p:=s;ifdef('TEXMF_DEBUG')println;print(1581);
printint(c);print(1582);printint(s);if p+27385<0 then begin print(1583);
println;end;
endif('TEXMF_DEBUG')if n=0 then begin repeat if(eqtb[27385+p].hh.b0=0)or
(eqtb[27385+p].hh.rh=c)then goto 30;incr(p);if p>255 then p:=0;
until s=p;p:=1000;
end else begin repeat if eqtb[27385+p].hh.b0=0 then goto 31;
if eqtb[27385+p].hh.rh=c then goto 30;incr(p);if p>255 then p:=0;
until s=p;31:p:=1000;end;30:getkinsokupos:=p;end;
{:1704}procedure scansomethinginternal(level:smallnumber;
negative:boolean);label 10,20;var m:halfword;tx:halfword;qx:halfword;
i:fourquarters;p:0..nestsize;q,r:halfword;begin 20:m:=curchr;
case curcmd of 85:{1706:}begin scanint;q:=getkinsokupos(curval,1);
curvallevel:=0;curval:=0;
if(q<>1000)and(m=eqtb[27385+q].hh.b0)then begin curval:=eqtb[29795+q].
int;curvallevel:=0;end;end{:1706};86:{1701:}begin scanint;
q:=getinhibitpos(curval,1);curvallevel:=0;curval:=3;
if q<>1000 then curval:=eqtb[27129+q].hh.b0;end{:1701};
94:{431:}begin scancharnum;
if m=28419 then begin curval1:=eqtb[28419+curval].hh.rh;
if((curval1 div 65536)>8)or(((curval1 mod 65536)div 256)>15)then begin
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(720);
end;begin helpptr:=2;helpline[1]:=721;helpline[0]:=722;end;
interror(curval1);begin curval:=0;curvallevel:=0;end end;
curval1:=(curval1 div 65536)*4096+curval1 mod 4096;
begin curval:=curval1;curvallevel:=0;end;
end else if m=(28547)then begin curval1:=eqtb[28419+curval].hh.rh;
curval:=(curval1 div 65536)*16777216+((curval1 div 256)mod 256)*65536+(
curval1 mod 256);begin curval:=curval;curvallevel:=0;end;
end else if m=29258 then begin curval1:=eqtb[29258+curval].int;
curval:=getintone(eqtb[29258+curval]);
if((curval1 div 256)mod 256>=16)or(curval>=4096)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(723);
end;begin helpptr:=2;helpline[1]:=724;helpline[0]:=722;end;error;
begin curval:=0;curvallevel:=0;end;
end else begin curval:=curval1*4096+curval;curvallevel:=0;end;
end else if m=(29386)then begin begin curval:=-1;curvallevel:=0;end;
end else if m=26617 then begin curval:=eqtb[m+kcatcodekey(curval)].hh.rh
;curvallevel:=0;
end else if m<28419 then begin if not ischarascii(curval)then begin
curval:=eqtb[m+Hi(curval)].hh.rh;curvallevel:=0;
end else begin curval:=eqtb[m+curval].hh.rh;curvallevel:=0;
end end else begin if not ischarascii(curval)then begin curval:=eqtb[m+
Hi(curval)].int;curvallevel:=0;
end else begin curval:=eqtb[m+curval].int;curvallevel:=0;end end;
end{:431};
77,78,95,96,97,98,99:{432:}if level<>5 then begin begin if interaction=3
then;if filelineerrorstylep then printfileline else printnl(263);
print(725);end;begin helpptr:=3;helpline[2]:=726;helpline[1]:=727;
helpline[0]:=728;end;backerror;begin curval:=0;curvallevel:=1;end;
end else if curcmd<=78 then begin if curcmd<78 then if m=membot then
begin scanregisternum;
if curval<256 then curval:=eqtb[25072+curval].hh.rh else begin
findsaelement(5,curval,false);
if curptr=-268435455 then curval:=-268435455 else curval:=mem[curptr+1].
hh.rh;end;end else curval:=mem[m+1].hh.rh else curval:=eqtb[m].hh.rh;
curvallevel:=5;end else begin backinput;scanfontident;
begin curval:=15526+curval;curvallevel:=4;end;end{:432};
79:begin curval:=eqtb[m].int;curvallevel:=0;end;
80:begin curval:=eqtb[m].int;curvallevel:=1;end;
81:begin curval:=eqtb[m].hh.rh;curvallevel:=2;end;
82:begin curval:=eqtb[m].hh.rh;curvallevel:=3;end;
88:{435:}if abs(curlist.modefield)<>m then begin begin if interaction=3
then;if filelineerrorstylep then printfileline else printnl(263);
print(741);end;printcmdchr(88,m);begin helpptr:=4;helpline[3]:=742;
helpline[2]:=743;helpline[1]:=744;helpline[0]:=745;end;error;
if level<>5 then begin curval:=0;curvallevel:=1;
end else begin curval:=0;curvallevel:=0;end;
end else if m=1 then begin curval:=curlist.auxfield.int;curvallevel:=1;
end else begin curval:=curlist.auxfield.hh.lh;curvallevel:=0;end{:435};
89:{439:}if curlist.modefield=0 then begin curval:=0;curvallevel:=0;
end else begin nest[nestptr]:=curlist;p:=nestptr;
while abs(nest[p].modefield)<>1 do decr(p);
begin curval:=nest[p].pgfield;curvallevel:=0;end;end{:439};
91:{436:}begin if m=0 then curval:=deadcycles{1444:}else if m=2 then
curval:=interaction{:1444}else curval:=insertpenalties;curvallevel:=0;
end{:436};
90:{438:}begin if(pagecontents=0)and(not outputactive)then if m=0 then
curval:=1073741823 else curval:=0 else curval:=pagesofar[m];
curvallevel:=1;end{:438};
93:{440:}begin if m>25061 then{1620:}begin scanint;
if(eqtb[m].hh.rh=-268435455)or(curval<0)then curval:=0 else begin if
curval>mem[eqtb[m].hh.rh+1].int then curval:=mem[eqtb[m].hh.rh+1].int;
curval:=mem[eqtb[m].hh.rh+curval+1].int;end;
end{:1620}else if eqtb[25061].hh.rh=-268435455 then curval:=0 else
curval:=mem[eqtb[25061].hh.rh].hh.lh;curvallevel:=0;end{:440};
92:{437:}begin scanregisternum;
if curval<256 then q:=eqtb[25332+curval].hh.rh else begin findsaelement(
4,curval,false);
if curptr=-268435455 then q:=-268435455 else q:=mem[curptr+1].hh.rh;end;
if q=-268435455 then curval:=0 else begin qx:=q;
while(q<>-268435455)and(((mem[q].hh.b1)mod 8)<>abs(curlist.dirfield))do
q:=mem[q].hh.rh;if q=-268435455 then begin r:=mem[qx].hh.rh;
mem[qx].hh.rh:=-268435455;q:=newdirnode(qx,abs(curlist.dirfield));
mem[qx].hh.rh:=r;curval:=mem[q+m].int;deleteglueref(mem[q+7].hh.rh);
deleteglueref(mem[q+7].hh.lh);freenode(q,10);
end else curval:=mem[q+m].int;end;curvallevel:=1;end{:437};
73,71,72:begin curval:=curchr;curvallevel:=0;end;
83:{442:}begin findfontdimen(false);fontinfo[fmemptr].int:=0;
begin curval:=fontinfo[curval].int;curvallevel:=1;end;end{:442};
84:{443:}begin scanfontident;
if m=0 then begin curval:=hyphenchar[curval];curvallevel:=0;
end else begin curval:=skewchar[curval];curvallevel:=0;end;end{:443};
100:{444:}begin if(m<membot)or(m>membot+23)then begin curvallevel:=(mem[
m].hh.b0 div 16);
if curvallevel<2 then curval:=mem[m+2].int else curval:=mem[m+1].hh.rh;
end else begin scanregisternum;curvallevel:=m-membot;
if curval>255 then begin findsaelement(curvallevel,curval,false);
if curptr=-268435455 then if curvallevel<2 then curval:=0 else curval:=
membot else if curvallevel<2 then curval:=mem[curptr+2].int else curval
:=mem[curptr+1].hh.rh;
end else case curvallevel of 0:curval:=eqtb[29002+curval].int;
1:curval:=eqtb[29539+curval].int;2:curval:=eqtb[24549+curval].hh.rh;
3:curval:=eqtb[24805+curval].hh.rh;end;end;end{:444};
74:{441:}if m>=5 then if m>=27 then{1534:}begin if m<28 then begin case
m of{1561:}27:scanmuglue;{:1561}end;curvallevel:=2;
end else if m<29 then begin case m of{1562:}28:scannormalglue;
{:1562}end;curvallevel:=3;end else begin curvallevel:=m-29;scanexpr;end;
while curvallevel>level do begin if curvallevel=2 then begin m:=curval;
curval:=mem[m+1].int;deleteglueref(m);
end else if curvallevel=3 then muerror;decr(curvallevel);end;
if negative then if curvallevel>=2 then begin m:=curval;
curval:=newspec(m);deleteglueref(m);
{448:}begin mem[curval+1].int:=-mem[curval+1].int;
mem[curval+2].int:=-mem[curval+2].int;
mem[curval+3].int:=-mem[curval+3].int;end{:448};
end else curval:=-curval;goto 10;
end{:1534}else if m>=18 then begin case m of{1421:}18,19,20,21:begin
scanfontident;q:=curval;scancharnum;
if fontdir[q]<>0 then begin if curval>=256 then begin curval:=getjfmpos(
curval,q);i:=fontinfo[charbase[q]+curval].qqqq;
case m of 18:curval:=fontinfo[widthbase[q]+i.b0].int;
19:curval:=fontinfo[heightbase[q]+(i.b1)div 16].int;
20:curval:=fontinfo[depthbase[q]+(i.b1)mod 16].int;
21:curval:=fontinfo[italicbase[q]+(i.b2)div 4].int;end;
end else curval:=0;
end else if(fontbc[q]<=curval)and(fontec[q]>=curval)then begin i:=
fontinfo[charbase[q]+curval].qqqq;
case m of 18:curval:=fontinfo[widthbase[q]+i.b0].int;
19:curval:=fontinfo[heightbase[q]+(i.b1)div 16].int;
20:curval:=fontinfo[depthbase[q]+(i.b1)mod 16].int;
21:curval:=fontinfo[italicbase[q]+(i.b2)div 4].int;end;
end else curval:=0;end;{:1421}{1424:}22,23,24:begin q:=curchr-22;
scanint;
if(eqtb[25061].hh.rh=-268435455)or(curval<=0)then curval:=0 else begin
if q=2 then begin q:=curval mod 2;curval:=(curval+q)div 2;end;
if curval>mem[eqtb[25061].hh.rh].hh.lh then curval:=mem[eqtb[25061].hh.
rh].hh.lh;curval:=mem[eqtb[25061].hh.rh+2*curval-q].int;end;
curvallevel:=1;end;{:1424}{1558:}25,26:begin scannormalglue;q:=curval;
if m=25 then curval:=mem[q+2].int else curval:=mem[q+3].int;
deleteglueref(q);end;{:1558}end;curvallevel:=1;
end else begin case m of 5:curval:=line;6:curval:=lastbadness;
{1401:}10:curval:=2;7:curval:=pdflastxpos;8:curval:=pdflastypos;
9:begin if shellenabledp then begin if restrictedshell then curval:=2
else curval:=1;end else curval:=0;end;
{:1401}{1415:}11:curval:=curlevel-1;12:curval:=curgroup;
{:1415}{1418:}13:begin q:=condptr;curval:=0;
while q<>-268435455 do begin incr(curval);q:=mem[q].hh.rh;end;end;
14:if condptr=-268435455 then curval:=0 else if curif<32 then curval:=
curif+1 else curval:=-(curif-31);
15:if(iflimit=4)or(iflimit=3)then curval:=1 else if iflimit=2 then
curval:=-1 else curval:=0;{:1418}{1557:}16,17:begin scannormalglue;
q:=curval;if m=16 then curval:=mem[q].hh.b0 else curval:=mem[q].hh.b1;
if curval>0 then curval:=curval-1;deleteglueref(q);end;{:1557}end;
curvallevel:=0;
end else begin if curchr=2 then curval:=membot else curval:=0;
tx:=curlist.tailfield;
if not(tx>=himemmin)then if mem[tx].hh.b0=5 then tx:=curlist.pnodefield;
if not(tx>=himemmin)then if(mem[tx].hh.b0=5)or((mem[tx].hh.b0=11)and(mem
[tx].hh.b1=3))then begin r:=curlist.headfield;
q:=mem[curlist.headfield].hh.rh;
while q<>tx do begin if(q>=himemmin)then r:=q else if(mem[q].hh.b0<>5)
and((mem[q].hh.b0<>11)or(mem[q].hh.b1<>3))then r:=q;q:=mem[q].hh.rh;end;
tx:=r;end;if curchr=3 then begin curvallevel:=0;
if(tx=curlist.headfield)or(curlist.modefield=0)then curval:=-1;
end else if curchr=4 then begin curvallevel:=0;curval:=-1;
end else curvallevel:=curchr;
if(curchr=4)and((tx>=himemmin))and(tx<>curlist.headfield)then begin r:=
curlist.headfield;q:=curlist.headfield;while q<>tx do begin r:=q;
q:=mem[q].hh.rh;end;
if(r<>curlist.headfield)and(r>=himemmin)then if fontdir[mem[r].hh.b0]<>0
then tx:=r;
if fontdir[mem[tx].hh.b0]<>0 then curval:=mem[mem[tx].hh.rh].hh.lh else
curval:=mem[tx].hh.b1;end;
if not(tx>=himemmin)and(tx<>curlist.headfield)and(curlist.modefield<>0)
then case curchr of 0:if mem[tx].hh.b0=14 then curval:=mem[tx+1].int;
1:if mem[tx].hh.b0=13 then curval:=mem[tx+1].int;
2:if mem[tx].hh.b0=12 then begin curval:=mem[tx+1].hh.lh;
if mem[tx].hh.b1=99 then curvallevel:=3;end;
3:if mem[tx].hh.b0<=15 then begin if mem[tx].hh.b0=2 then tx:=mem[tx+5].
hh.rh;curval:=mem[tx].hh.b0;
if curval<2 then curval:=curval+1 else if curval>5 then curval:=curval-1
;end else curval:=15;
4:begin if((mem[tx].hh.b0=12)and(mem[tx].hh.b1=21))or((mem[tx].hh.b0=14)
and(mem[tx].hh.b1=2))then tx:=curlist.lastjchrfield else if(mem[tx].hh.
b0=13)and(mem[tx].hh.b1=0)then begin r:=curlist.headfield;
q:=mem[curlist.headfield].hh.rh;while q<>tx do begin r:=q;
if(q>=himemmin)then if fontdir[mem[q].hh.b0]<>0 then q:=mem[q].hh.rh;
q:=mem[q].hh.rh;end;
if((mem[r].hh.b0=14)and(mem[r].hh.b1=2))then tx:=curlist.lastjchrfield
else tx:=r;end;
if not(tx>=himemmin)then begin if mem[tx].hh.b0=8 then begin r:=mem[tx+1
].hh.rh;while mem[r].hh.rh<>-268435455 do r:=mem[r].hh.rh;
curval:=mem[r].hh.b1;
end end else if fontdir[mem[tx].hh.b0]<>0 then curval:=mem[mem[tx].hh.rh
].hh.lh else curval:=mem[tx].hh.b1;end;
end else if(curlist.modefield=1)and(tx=curlist.headfield)then case
curchr of 0:curval:=lastpenalty;1:curval:=lastkern;
2:if lastglue<>268435455 then curval:=lastglue;3:curval:=lastnodetype;
end;end{:441};42:if curchr=1 then{386:}begin gettoken;
curcs:=primlookup(hash[curcs].rh);
if curcs<>0 then begin curcmd:=primeqtb[curcs].hh.b0;
curchr:=primeqtb[curcs].hh.rh;curtok:=(curcmd*256)+curchr;
end else begin curcmd:=0;curchr:=0;curtok:=81056;curcs:=15521;end;
goto 20;end{:386};others:{445:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(746);
end;printcmdchr(curcmd,curchr);print(747);printesc(582);
begin helpptr:=1;helpline[0]:=745;end;error;
if level<>5 then begin curval:=0;curvallevel:=1;
end else begin curval:=0;curvallevel:=0;end;end{:445}end;
while curvallevel>level do{446:}begin if curvallevel=2 then curval:=mem[
curval+1].int else if curvallevel=3 then muerror;decr(curvallevel);
end{:446};
{447:}if negative then if curvallevel>=2 then begin curval:=newspec(
curval);{448:}begin mem[curval+1].int:=-mem[curval+1].int;
mem[curval+2].int:=-mem[curval+2].int;
mem[curval+3].int:=-mem[curval+3].int;end{:448};
end else curval:=-curval else if(curvallevel>=2)and(curvallevel<=3)then
incr(mem[curval].hh.rh){:447};end;{:430}{457:}procedure scanint;
label 30,20;var negative:boolean;m:integer;d:smallnumber;
vacuous:boolean;OKsofar:boolean;begin radix:=0;OKsofar:=true;
{458:}negative:=false;repeat{423:}repeat getxtoken;
until curcmd<>10{:423};if curtok=3117 then begin negative:=not negative;
curtok:=3115;end;until curtok<>3115{:458};
20:if curtok=3168 then{459:}begin gettoken;
if curtok<65535 then if(curcmd=16)or(curcmd=17)or(curcmd=18)then begin
skipmode:=false;curval:=curchr;end else begin curval:=curchr;
if curcmd<=2 then if curcmd=2 then incr(alignstate)else decr(alignstate)
;end else if curtok<65792 then curval:=curtok-65536 else curval:=curtok
-65792;if(curval>255)and((curcmd<16)or(curcmd>18))then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(762);
end;begin helpptr:=2;helpline[1]:=763;helpline[0]:=764;end;curval:=48;
backerror;end else{460:}begin getxtoken;if curcmd<>10 then backinput;
end{:460};skipmode:=true;
end{:459}else if curtok=81060 then{386:}begin gettoken;
curcs:=primlookup(hash[curcs].rh);
if curcs<>0 then begin curcmd:=primeqtb[curcs].hh.b0;
curchr:=primeqtb[curcs].hh.rh;curtok:=(curcmd*256)+curchr;
end else begin curcmd:=0;curchr:=0;curtok:=81056;curcs:=15521;end;
goto 20;
end{:386}else if(curcmd>=71)and(curcmd<=100)then scansomethinginternal(0
,false)else{461:}begin radix:=10;m:=214748364;
if curtok=3111 then begin radix:=8;m:=268435456;getxtoken;
end else if curtok=3106 then begin radix:=16;m:=134217728;getxtoken;end;
vacuous:=true;curval:=0;
{462:}while true do begin if(curtok<3120+radix)and(curtok>=3120)and(
curtok<=3129)then d:=curtok-3120 else if radix=16 then if(curtok<=2886)
and(curtok>=2881)then d:=curtok-2871 else if(curtok<=3142)and(curtok>=
3137)then d:=curtok-3127 else goto 30 else goto 30;vacuous:=false;
if(curval>=m)and((curval>m)or(d>7)or(radix<>10))then begin if OKsofar
then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(765);
end;begin helpptr:=2;helpline[1]:=766;helpline[0]:=767;end;error;
curval:=2147483647;OKsofar:=false;end;end else curval:=curval*radix+d;
getxtoken;end;30:{:462};
if vacuous then{463:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(725);
end;begin helpptr:=3;helpline[2]:=726;helpline[1]:=727;helpline[0]:=728;
end;backerror;end{:463}else if curcmd<>10 then backinput;end{:461};
if negative then curval:=-curval;end;
{:457}{465:}procedure scandimen(mu,inf,shortcut:boolean);
label 30,31,32,40,45,88,89;var negative:boolean;f:integer;
{467:}num,denom:1..65536;k,kk:smallnumber;p,q:halfword;v:scaled;
savecurval:integer;{:467}{1681:}t:eightbits;{:1681}begin f:=0;
aritherror:=false;curorder:=0;negative:=false;
if not shortcut then begin{458:}negative:=false;
repeat{423:}repeat getxtoken;until curcmd<>10{:423};
if curtok=3117 then begin negative:=not negative;curtok:=3115;end;
until curtok<>3115{:458};
if(curcmd>=71)and(curcmd<=100)then{466:}if mu then begin
scansomethinginternal(3,false);
{468:}if curvallevel>=2 then begin v:=mem[curval+1].int;
deleteglueref(curval);curval:=v;end{:468};if curvallevel=3 then goto 89;
if curvallevel<>0 then muerror;
end else begin scansomethinginternal(1,false);
if curvallevel=1 then goto 89;end{:466}else begin backinput;
if curtok=3116 then curtok:=3118;
if curtok<>3118 then scanint else begin radix:=10;curval:=0;end;
if curtok=3116 then curtok:=3118;
if(radix=10)and(curtok=3118)then{469:}begin k:=0;p:=-268435455;gettoken;
while true do begin getxtoken;
if(curtok>3129)or(curtok<3120)then goto 31;
if k<17 then begin q:=getavail;mem[q].hh.rh:=p;
mem[q].hh.lh:=curtok-3120;p:=q;incr(k);end;end;
31:for kk:=k downto 1 do begin dig[kk-1]:=mem[p].hh.lh;q:=p;
p:=mem[p].hh.rh;begin mem[q].hh.rh:=avail;avail:=q;
ifdef('STAT')decr(dynused);endif('STAT')end;end;f:=rounddecimals(k);
if curcmd<>10 then backinput;end{:469};end;end;
if curval<0 then begin negative:=not negative;curval:=-curval;end;
{470:}if inf then{471:}if scankeyword(315)then begin curorder:=1;
while scankeyword(108)do begin if curorder=4 then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(769);
end;print(770);begin helpptr:=1;helpline[0]:=771;end;error;
end else incr(curorder);end;goto 88;end{:471};{472:}savecurval:=curval;
{423:}repeat getxtoken;until curcmd<>10{:423};
if(curcmd<71)or(curcmd>100)then backinput else begin if mu then begin
scansomethinginternal(3,false);
{468:}if curvallevel>=2 then begin v:=mem[curval+1].int;
deleteglueref(curval);curval:=v;end{:468};
if curvallevel<>3 then muerror;end else scansomethinginternal(1,false);
v:=curval;goto 40;end;if mu then goto 45;
if scankeyword(772)then v:=({575:}fontinfo[6+parambase[eqtb[25588].hh.rh
]].int{:575})else if scankeyword(773)then v:=({576:}fontinfo[5+parambase
[eqtb[25588].hh.rh]].int{:576})else if scankeyword(774)then{1682:}if
curlist.dirfield=3 then v:=fontinfo[widthbase[eqtb[26358].hh.rh]+
fontinfo[charbase[eqtb[26358].hh.rh]+0].qqqq.b0].int else v:=fontinfo[
widthbase[eqtb[26357].hh.rh]+fontinfo[charbase[eqtb[26357].hh.rh]+0].
qqqq.b0].int{:1682}else if scankeyword(775)then{1683:}if curlist.
dirfield=3 then begin t:=fontinfo[charbase[eqtb[26358].hh.rh]+0].qqqq.b1
;v:=fontinfo[heightbase[eqtb[26358].hh.rh]+(t)div 16].int+fontinfo[
depthbase[eqtb[26358].hh.rh]+(t)mod 16].int;
end else begin t:=fontinfo[charbase[eqtb[26357].hh.rh]+0].qqqq.b1;
v:=fontinfo[heightbase[eqtb[26357].hh.rh]+(t)div 16].int+fontinfo[
depthbase[eqtb[26357].hh.rh]+(t)mod 16].int;end{:1683}else goto 45;
{460:}begin getxtoken;if curcmd<>10 then backinput;end{:460};
40:curval:=multandadd(savecurval,v,xnoverd(v,f,65536),1073741823);
goto 89;45:{:472};
if mu then{473:}if scankeyword(342)then goto 88 else begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(769);
end;print(776);begin helpptr:=4;helpline[3]:=777;helpline[2]:=778;
helpline[1]:=779;helpline[0]:=780;end;error;goto 88;end{:473};
if scankeyword(768)then{474:}begin preparemag;
if eqtb[28948].int<>1000 then begin curval:=xnoverd(curval,1000,eqtb[
28948].int);f:=(1000*f+65536*texremainder)div eqtb[28948].int;
curval:=curval+(f div 65536);f:=f mod 65536;end;end{:474};
if scankeyword(418)then goto 88;
{475:}if scankeyword(781)then begin num:=7227;denom:=100;
end else if scankeyword(782)then begin num:=12;denom:=1;
end else if scankeyword(783)then begin num:=7227;denom:=254;
end else if scankeyword(784)then begin num:=7227;denom:=2540;
end else if scankeyword(785)then begin num:=7227;denom:=7200;
end else if scankeyword(786)then begin num:=1238;denom:=1157;
end else if scankeyword(787)then begin num:=14856;denom:=1157;
end else if scankeyword(72)then begin num:=7227;denom:=10160;
end else if scankeyword(81)then begin num:=7227;denom:=10160;
end else if scankeyword(788)then goto 30 else{476:}begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(769);
end;print(789);begin helpptr:=6;helpline[5]:=790;helpline[4]:=791;
helpline[3]:=792;helpline[2]:=778;helpline[1]:=779;helpline[0]:=780;end;
error;goto 32;end{:476};curval:=xnoverd(curval,num,denom);
f:=(num*f+65536*texremainder)div denom;curval:=curval+(f div 65536);
f:=f mod 65536;32:{:475};
88:if curval>=16384 then aritherror:=true else curval:=curval*65536+f;
30:{:470};{460:}begin getxtoken;if curcmd<>10 then backinput;end{:460};
89:if aritherror or(abs(curval)>=1073741824)then{477:}begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(793);
end;begin helpptr:=2;helpline[1]:=794;helpline[0]:=795;end;error;
curval:=1073741823;aritherror:=false;end{:477};
if negative then curval:=-curval;end;
{:465}{478:}procedure scanglue(level:smallnumber);label 10;
var negative:boolean;q:halfword;mu:boolean;begin mu:=(level=3);
{458:}negative:=false;repeat{423:}repeat getxtoken;
until curcmd<>10{:423};if curtok=3117 then begin negative:=not negative;
curtok:=3115;end;until curtok<>3115{:458};
if(curcmd>=71)and(curcmd<=100)then begin scansomethinginternal(level,
negative);
if curvallevel>=2 then begin if curvallevel<>level then muerror;goto 10;
end;if curvallevel=0 then scandimen(mu,false,true)else if level=3 then
muerror;end else begin backinput;scandimen(mu,false,false);
if negative then curval:=-curval;end;{479:}q:=newspec(membot);
mem[q+1].int:=curval;
if scankeyword(796)then begin scandimen(mu,true,false);
mem[q+2].int:=curval;mem[q].hh.b0:=curorder;end;
if scankeyword(797)then begin scandimen(mu,true,false);
mem[q+3].int:=curval;mem[q].hh.b1:=curorder;end;curval:=q{:479};10:end;
{1536:}{1547:}function addorsub(x,y,maxanswer:integer;
negative:boolean):integer;var a:integer;begin if negative then y:=-y;
if x>=0 then if y<=maxanswer-x then a:=x+y else begin aritherror:=true;
a:=0;
end else if y>=-maxanswer-x then a:=x+y else begin aritherror:=true;
a:=0;end;addorsub:=a;end;
{:1547}{1551:}function quotient(n,d:integer):integer;
var negative:boolean;a:integer;begin if d=0 then begin aritherror:=true;
a:=0;end else begin if d>0 then negative:=false else begin d:=-d;
negative:=true;end;if n<0 then begin n:=-n;negative:=not negative;end;
a:=n div d;n:=n-a*d;d:=n-d;if d+n>=0 then incr(a);
if negative then a:=-a;end;quotient:=a;end;
{:1551}{1553:}function fract(x,n,d,maxanswer:integer):integer;
label 40,41,88,30;var negative:boolean;a:integer;f:integer;h:integer;
r:integer;t:integer;begin if d=0 then goto 88;a:=0;
if d>0 then negative:=false else begin d:=-d;negative:=true;end;
if x<0 then begin x:=-x;negative:=not negative;
end else if x=0 then goto 30;if n<0 then begin n:=-n;
negative:=not negative;end;t:=n div d;if t>maxanswer div x then goto 88;
a:=t*x;n:=n-t*d;if n=0 then goto 40;t:=x div d;
if t>(maxanswer-a)div n then goto 88;a:=a+t*n;x:=x-t*d;
if x=0 then goto 40;if x<n then begin t:=x;x:=n;n:=t;end;{1554:}f:=0;
r:=(d div 2)-d;h:=-r;while true do begin if odd(n)then begin r:=r+x;
if r>=0 then begin r:=r-d;incr(f);end;end;n:=n div 2;
if n=0 then goto 41;if x<h then x:=x+x else begin t:=x-d;x:=t+x;f:=f+n;
if x<n then begin if x=0 then goto 41;t:=x;x:=n;n:=t;end;end;end;
41:{:1554}if f>(maxanswer-a)then goto 88;a:=a+f;
40:if negative then a:=-a;goto 30;88:begin aritherror:=true;a:=0;end;
30:fract:=a;end;{:1553}procedure scanexpr;label 20,22,40;
var a,b:boolean;l:smallnumber;r:smallnumber;s:smallnumber;o:smallnumber;
e:integer;t:integer;f:integer;n:integer;p:halfword;q:halfword;
begin l:=curvallevel;a:=aritherror;b:=false;p:=-268435455;
{1537:}20:r:=0;e:=0;s:=0;t:=0;n:=0;22:if s=0 then o:=l else o:=0;
{1539:}{423:}repeat getxtoken;until curcmd<>10{:423};
if curtok=3112 then{1542:}begin q:=getnode(4);mem[q].hh.rh:=p;
mem[q].hh.b0:=l;mem[q].hh.b1:=4*s+r;mem[q+1].int:=e;mem[q+2].int:=t;
mem[q+3].int:=n;p:=q;l:=o;goto 20;end{:1542};backinput;
if o=0 then scanint else if o=1 then scandimen(false,false,false)else if
o=2 then scannormalglue else scanmuglue;f:=curval{:1539};
40:{1538:}{423:}repeat getxtoken;until curcmd<>10{:423};
if curtok=3115 then o:=1 else if curtok=3117 then o:=2 else if curtok=
3114 then o:=3 else if curtok=3119 then o:=4 else begin o:=0;
if p=-268435455 then begin if curcmd<>0 then backinput;
end else if curtok<>3113 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1533);
end;begin helpptr:=1;helpline[0]:=1534;end;backerror;end;end{:1538};
aritherror:=b;
{1544:}if(l=0)or(s>2)then begin if(f>2147483647)or(f<-2147483647)then
begin aritherror:=true;f:=0;end;
end else if l=1 then begin if abs(f)>1073741823 then begin aritherror:=
true;f:=0;end;
end else begin if(abs(mem[f+1].int)>1073741823)or(abs(mem[f+2].int)>
1073741823)or(abs(mem[f+3].int)>1073741823)then begin aritherror:=true;
deleteglueref(f);f:=newspec(membot);end;end{:1544};
case s of{1545:}0:if(l>=2)and(o<>0)then begin t:=newspec(f);
deleteglueref(f);if mem[t+2].int=0 then mem[t].hh.b0:=0;
if mem[t+3].int=0 then mem[t].hh.b1:=0;end else t:=f;
{:1545}{1549:}3:if o=4 then begin n:=f;o:=5;
end else if l=0 then t:=multandadd(t,f,0,2147483647)else if l=1 then t:=
multandadd(t,f,0,1073741823)else begin mem[t+1].int:=multandadd(mem[t+1]
.int,f,0,1073741823);
mem[t+2].int:=multandadd(mem[t+2].int,f,0,1073741823);
mem[t+3].int:=multandadd(mem[t+3].int,f,0,1073741823);end;
{:1549}{1550:}4:if l<2 then t:=quotient(t,f)else begin mem[t+1].int:=
quotient(mem[t+1].int,f);mem[t+2].int:=quotient(mem[t+2].int,f);
mem[t+3].int:=quotient(mem[t+3].int,f);end;
{:1550}{1552:}5:if l=0 then t:=fract(t,n,f,2147483647)else if l=1 then t
:=fract(t,n,f,1073741823)else begin mem[t+1].int:=fract(mem[t+1].int,n,f
,1073741823);mem[t+2].int:=fract(mem[t+2].int,n,f,1073741823);
mem[t+3].int:=fract(mem[t+3].int,n,f,1073741823);end;{:1552}end;
if o>2 then s:=o else{1546:}begin s:=0;
if r=0 then e:=t else if l=0 then e:=addorsub(e,t,2147483647,r=2)else if
l=1 then e:=addorsub(e,t,1073741823,r=2)else{1548:}begin mem[e+1].int:=
addorsub(mem[e+1].int,mem[t+1].int,1073741823,r=2);
if mem[e].hh.b0=mem[t].hh.b0 then mem[e+2].int:=addorsub(mem[e+2].int,
mem[t+2].int,1073741823,r=2)else if(mem[e].hh.b0<mem[t].hh.b0)and(mem[t
+2].int<>0)then begin mem[e+2].int:=mem[t+2].int;
mem[e].hh.b0:=mem[t].hh.b0;end;
if mem[e].hh.b1=mem[t].hh.b1 then mem[e+3].int:=addorsub(mem[e+3].int,
mem[t+3].int,1073741823,r=2)else if(mem[e].hh.b1<mem[t].hh.b1)and(mem[t
+3].int<>0)then begin mem[e+3].int:=mem[t+3].int;
mem[e].hh.b1:=mem[t].hh.b1;end;deleteglueref(t);
if mem[e+2].int=0 then mem[e].hh.b0:=0;
if mem[e+3].int=0 then mem[e].hh.b1:=0;end{:1548};r:=o;end{:1546};
b:=aritherror;if o<>0 then goto 22;
if p<>-268435455 then{1543:}begin f:=e;q:=p;e:=mem[q+1].int;
t:=mem[q+2].int;n:=mem[q+3].int;s:=mem[q].hh.b1 div 4;
r:=mem[q].hh.b1 mod 4;l:=mem[q].hh.b0;p:=mem[q].hh.rh;freenode(q,4);
goto 40;end{:1543}{:1537};if b then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1341);
end;begin helpptr:=2;helpline[1]:=1532;helpline[0]:=1343;end;error;
if l>=2 then begin deleteglueref(e);e:=membot;incr(mem[e].hh.rh);
end else e:=0;end;aritherror:=a;curval:=e;curvallevel:=l;end;
{:1536}{1541:}procedure scannormalglue;begin scanglue(2);end;
procedure scanmuglue;begin scanglue(3);end;
{:1541}{:478}{480:}function scanrulespec:halfword;label 21;
var q:halfword;begin q:=newrule;
if curcmd=38 then mem[q+1].int:=26214 else begin mem[q+3].int:=26214;
mem[q+2].int:=0;end;
21:if scankeyword(798)then begin scandimen(false,false,false);
mem[q+1].int:=curval;goto 21;end;
if scankeyword(799)then begin scandimen(false,false,false);
mem[q+3].int:=curval;goto 21;end;
if scankeyword(800)then begin scandimen(false,false,false);
mem[q+2].int:=curval;goto 21;end;scanrulespec:=q;end;
{:480}{481:}{1433:}procedure scangeneraltext;label 40;var s:0..5;
w:halfword;d:halfword;p:halfword;q:halfword;unbalance:halfword;
begin s:=scannerstatus;w:=warningindex;d:=defref;scannerstatus:=5;
warningindex:=curcs;defref:=getavail;mem[defref].hh.lh:=-268435455;
p:=defref;scanleftbrace;unbalance:=1;while true do begin gettoken;
if curtok<768 then if curcmd<2 then incr(unbalance)else begin decr(
unbalance);if unbalance=0 then goto 40;end;begin q:=getavail;
mem[p].hh.rh:=q;mem[q].hh.lh:=curtok;p:=q;end;end;
40:q:=mem[defref].hh.rh;begin mem[defref].hh.rh:=avail;avail:=defref;
ifdef('STAT')decr(dynused);endif('STAT')end;
if q=-268435455 then curval:=memtop-3 else curval:=p;
mem[memtop-3].hh.rh:=q;scannerstatus:=s;warningindex:=w;defref:=d;end;
{:1433}{1507:}procedure pseudostart;var oldsetting:0..21;s:strnumber;
l,m:poolpointer;p,q,r:halfword;w:fourquarters;nl,sz:integer;
begin scangeneraltext;oldsetting:=selector;selector:=21;
tokenshow(memtop-3);selector:=oldsetting;flushlist(mem[memtop-3].hh.rh);
begin if poolptr+1>poolsize then overflow(258,poolsize-initpoolptr);end;
s:=makestring;{1508:}strpool[poolptr]:=32;l:=strstart[s];
nl:=eqtb[28981].int;p:=getavail;q:=p;while l<poolptr do begin m:=l;
while(l<poolptr)and(strpool[l]<>nl)do incr(l);sz:=(l-m+7)div 4;
if sz=1 then sz:=2;r:=getnode(sz);mem[q].hh.rh:=r;q:=r;mem[q].hh.lh:=sz;
while sz>2 do begin decr(sz);incr(r);w.b0:=strpool[m];
w.b1:=strpool[m+1];w.b2:=strpool[m+2];w.b3:=strpool[m+3];mem[r].qqqq:=w;
m:=m+4;end;w.b0:=32;w.b1:=32;w.b2:=32;w.b3:=32;
if l>m then begin w.b0:=strpool[m];
if l>m+1 then begin w.b1:=strpool[m+1];
if l>m+2 then begin w.b2:=strpool[m+2];if l>m+3 then w.b3:=strpool[m+3];
end;end;end;mem[r+1].qqqq:=w;if strpool[l]=nl then incr(l);end;
mem[p].hh.lh:=mem[p].hh.rh;mem[p].hh.rh:=pseudofiles;
pseudofiles:=p{:1508};begin decr(strptr);poolptr:=strstart[strptr];end;
{1509:}beginfilereading;line:=0;
curinput.limitfield:=curinput.startfield;
curinput.locfield:=curinput.limitfield+1;
if eqtb[28995].int>0 then begin if termoffset>maxprintline-3 then
println else if(termoffset>0)or(fileoffset>0)then printchar(32);
curinput.namefield:=19;print(1518);incr(openparens);fflush(stdout);
end else begin curinput.namefield:=18;
{1661:}curinput.synctextagfield:=0;{:1661};end{:1509};end;
{:1507}function strtoks(b:poolpointer):halfword;var p:halfword;
q:halfword;t:halfword;k:poolpointer;
begin begin if poolptr+1>poolsize then overflow(258,poolsize-initpoolptr
);end;p:=memtop-3;mem[p].hh.rh:=-268435455;k:=b;
while k<poolptr do begin t:=strpool[k];
if multistrlen(ustringcast(strpool),poolptr,k)=2 then begin t:=fromBUFF(
ustringcast(strpool),poolptr,k);incr(k);
end else if t=32 then t:=2592 else t:=3072+t;begin begin q:=avail;
if q=-268435455 then q:=getavail else begin avail:=mem[q].hh.rh;
mem[q].hh.rh:=-268435455;ifdef('STAT')incr(dynused);endif('STAT')end;
end;mem[p].hh.rh:=q;mem[q].hh.lh:=t;p:=q;end;incr(k);end;poolptr:=b;
strtoks:=p;end;{:481}{482:}function thetoks:halfword;label 10;
var oldsetting:0..21;p,q,r:halfword;b:poolpointer;c:smallnumber;
begin{1438:}if odd(curchr)then begin c:=curchr;scangeneraltext;
if c=1 then thetoks:=curval else begin oldsetting:=selector;
selector:=21;b:=poolptr;p:=getavail;mem[p].hh.rh:=mem[memtop-3].hh.rh;
tokenshow(p);flushlist(p);selector:=oldsetting;thetoks:=strtoks(b);end;
goto 10;end{:1438};getxtoken;scansomethinginternal(5,false);
if curvallevel>=4 then{483:}begin p:=memtop-3;mem[p].hh.rh:=-268435455;
if curvallevel=4 then begin q:=getavail;mem[p].hh.rh:=q;
mem[q].hh.lh:=65535+curval;p:=q;
end else if curval<>-268435455 then begin r:=mem[curval].hh.rh;
while r<>-268435455 do begin begin begin q:=avail;
if q=-268435455 then q:=getavail else begin avail:=mem[q].hh.rh;
mem[q].hh.rh:=-268435455;ifdef('STAT')incr(dynused);endif('STAT')end;
end;mem[p].hh.rh:=q;mem[q].hh.lh:=mem[r].hh.lh;p:=q;end;r:=mem[r].hh.rh;
end;end;thetoks:=p;end{:483}else begin oldsetting:=selector;
selector:=21;b:=poolptr;case curvallevel of 0:printint(curval);
1:begin printscaled(curval);print(418);end;
2:begin printspec(curval,418);deleteglueref(curval);end;
3:begin printspec(curval,342);deleteglueref(curval);end;end;
selector:=oldsetting;thetoks:=strtoks(b);end;10:end;
{:482}{484:}procedure insthetoks;begin mem[memtop-12].hh.rh:=thetoks;
begintokenlist(mem[memtop-3].hh.rh,4);end;
{:484}{487:}procedure convtoks;var oldsetting:0..21;cx:KANJIcode;
c:0..17;savescannerstatus:smallnumber;savedefref:halfword;
savewarningindex:halfword;bool:boolean;u:strnumber;s:strnumber;
i:integer;j:integer;b:poolpointer;begin c:=curchr;{488:}cx:=0;
case c of 0,1,2,6,7,8,9:scanint;
3,4:begin savescannerstatus:=scannerstatus;scannerstatus:=0;gettoken;
if(curcmd=16)or(curcmd=17)or(curcmd=18)then cx:=curtok;
scannerstatus:=savescannerstatus;end;5:scanfontident;10:;
11:begin savescannerstatus:=scannerstatus;savedefref:=defref;
if strstart[strptr]<poolptr then u:=makestring else u:=0;comparestrings;
defref:=savedefref;scannerstatus:=savescannerstatus;
if u<>0 then decr(strptr);end;12:begin b:=poolptr;getcreationdate;
mem[memtop-12].hh.rh:=strtoks(b);begintokenlist(mem[memtop-3].hh.rh,4);
goto 10;end;13:begin savescannerstatus:=scannerstatus;
savewarningindex:=warningindex;savedefref:=defref;
if strstart[strptr]<poolptr then u:=makestring else u:=0;scanpdfexttoks;
s:=tokenstostring(defref);deletetokenref(defref);defref:=savedefref;
warningindex:=savewarningindex;scannerstatus:=savescannerstatus;
b:=poolptr;getfilemoddate(s);mem[memtop-12].hh.rh:=strtoks(b);
flushstr(s);begintokenlist(mem[memtop-3].hh.rh,4);
if u<>0 then decr(strptr);goto 10;end;
14:begin savescannerstatus:=scannerstatus;
savewarningindex:=warningindex;savedefref:=defref;
if strstart[strptr]<poolptr then u:=makestring else u:=0;scanpdfexttoks;
s:=tokenstostring(defref);deletetokenref(defref);defref:=savedefref;
warningindex:=savewarningindex;scannerstatus:=savescannerstatus;
b:=poolptr;getfilesize(s);mem[memtop-12].hh.rh:=strtoks(b);flushstr(s);
begintokenlist(mem[memtop-3].hh.rh,4);if u<>0 then decr(strptr);goto 10;
end;15:begin savescannerstatus:=scannerstatus;
savewarningindex:=warningindex;savedefref:=defref;
if strstart[strptr]<poolptr then u:=makestring else u:=0;
bool:=scankeyword(819);scanpdfexttoks;
if bool then s:=tokenstostring(defref)else begin isprintutf8:=true;
s:=tokenstostring(defref);isprintutf8:=false;end;deletetokenref(defref);
defref:=savedefref;warningindex:=savewarningindex;
scannerstatus:=savescannerstatus;b:=poolptr;getmd5sum(s,bool);
mem[memtop-12].hh.rh:=strtoks(b);flushstr(s);
begintokenlist(mem[memtop-3].hh.rh,4);if u<>0 then decr(strptr);goto 10;
end;16:begin savescannerstatus:=scannerstatus;
savewarningindex:=warningindex;savedefref:=defref;
if strstart[strptr]<poolptr then u:=makestring else u:=0;curval:=0;
if(scankeyword(820))then begin scanint;
if(curval<0)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(821);
end;begin helpptr:=2;helpline[1]:=822;helpline[0]:=722;end;
interror(curval);curval:=0;end;end;i:=curval;curval:=0;
if(scankeyword(823))then begin scanint;
if(curval<0)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(824);
end;begin helpptr:=2;helpline[1]:=825;helpline[0]:=722;end;
interror(curval);curval:=0;end;end;j:=curval;scanpdfexttoks;
s:=tokenstostring(defref);deletetokenref(defref);defref:=savedefref;
warningindex:=savewarningindex;scannerstatus:=savescannerstatus;
b:=poolptr;getfiledump(s,i,j);mem[memtop-12].hh.rh:=strtoks(b);
flushstr(s);begintokenlist(mem[memtop-3].hh.rh,4);
if u<>0 then decr(strptr);goto 10;end;17:if jobname=0 then openlogfile;
end{:488};u:=0;oldsetting:=selector;selector:=21;b:=poolptr;
{489:}case c of 0:printint(curval);1:printromanint(curval);
8:printint(fromJIS(curval));6:printint(fromEUC(curval));
7:printint(fromSJIS(curval));9:printint(fromKUTEN(curval));
2:printkansuji(curval);
3:if curcs<>0 then sprintcs(curcs)else if cx=0 then printchar(curchr)
else printkanji(cx);4:printmeaning;5:begin print(fontname[curval]);
if fontsize[curval]<>fontdsize[curval]then begin print(826);
printscaled(fontsize[curval]);print(418);end;end;10:print(256);
11:printint(curval);17:print(jobname);end{:489};selector:=oldsetting;
mem[memtop-12].hh.rh:=strtoks(b);begintokenlist(mem[memtop-3].hh.rh,4);
end;{:487}{490:}function scantoks(macrodef,xpand:boolean):halfword;
label 40,30,31,32;var t:halfword;s:halfword;p:halfword;q:halfword;
unbalance:halfword;hashbrace:halfword;
begin if macrodef then scannerstatus:=2 else scannerstatus:=5;
warningindex:=curcs;defref:=getavail;mem[defref].hh.lh:=-268435455;
p:=defref;hashbrace:=0;t:=3120;
if macrodef then{491:}begin while true do begin gettoken;
if curtok<768 then goto 31;if curcmd=6 then{493:}begin s:=3328+curchr;
gettoken;if curcmd=1 then begin hashbrace:=curtok;begin q:=getavail;
mem[p].hh.rh:=q;mem[q].hh.lh:=curtok;p:=q;end;begin q:=getavail;
mem[p].hh.rh:=q;mem[q].hh.lh:=3584;p:=q;end;goto 30;end;
if t=3129 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(829);
end;begin helpptr:=1;helpline[0]:=830;end;error;end else begin incr(t);
if curtok<>t then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(831);
end;begin helpptr:=2;helpline[1]:=832;helpline[0]:=833;end;backerror;
end;curtok:=s;end;end{:493};begin q:=getavail;mem[p].hh.rh:=q;
mem[q].hh.lh:=curtok;p:=q;end;end;31:begin q:=getavail;mem[p].hh.rh:=q;
mem[q].hh.lh:=3584;p:=q;end;
if curcmd=2 then{492:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(713);
end;incr(alignstate);begin helpptr:=2;helpline[1]:=827;helpline[0]:=828;
end;error;goto 40;end{:492};30:end{:491}else scanleftbrace;
{494:}unbalance:=1;
while true do begin if xpand then{495:}begin while true do begin getnext
;if curcmd>=123 then if mem[mem[curchr].hh.rh].hh.lh=3585 then begin
curcmd:=0;curchr:=257;end;if curcmd<=112 then goto 32;
if curcmd<>121 then expand else begin q:=thetoks;
if mem[memtop-3].hh.rh<>-268435455 then begin mem[p].hh.rh:=mem[memtop-3
].hh.rh;p:=q;end;end;end;32:xtoken end{:495}else gettoken;
if curtok<768 then if curcmd<2 then incr(unbalance)else begin decr(
unbalance);if unbalance=0 then goto 40;
end else if curcmd=6 then if macrodef then{496:}begin s:=curtok;
if xpand then getxtoken else gettoken;
if curcmd<>6 then if(curtok<=3120)or(curtok>t)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(834);
end;sprintcs(warningindex);begin helpptr:=3;helpline[2]:=835;
helpline[1]:=836;helpline[0]:=837;end;backerror;curtok:=s;
end else curtok:=1232+curchr;end{:496};begin q:=getavail;
mem[p].hh.rh:=q;mem[q].hh.lh:=curtok;p:=q;end;end{:494};
40:scannerstatus:=0;if hashbrace<>0 then begin q:=getavail;
mem[p].hh.rh:=q;mem[q].hh.lh:=hashbrace;p:=q;end;scantoks:=p;end;
{:490}{499:}procedure readtoks(n:integer;r:halfword;j:halfword);
label 30;var p:halfword;q:halfword;s:integer;m:smallnumber;
begin scannerstatus:=2;warningindex:=r;defref:=getavail;
mem[defref].hh.lh:=-268435455;p:=defref;begin q:=getavail;
mem[p].hh.rh:=q;mem[q].hh.lh:=3584;p:=q;end;
if(n<0)or(n>15)then m:=16 else m:=n;s:=alignstate;alignstate:=1000000;
repeat{500:}beginfilereading;curinput.namefield:=m+1;
if readopen[m]=2 then{501:}if interaction>1 then if n<0 then begin;
print(343);terminput;end else begin;println;sprintcs(r);begin;print(61);
terminput;end;n:=-1;
end else fatalerror(838){:501}else if readopen[m]=1 then{502:}if inputln
(readfile[m],false)then readopen[m]:=0 else begin aclose(readfile[m]);
readopen[m]:=2;
end{:502}else{503:}begin if not inputln(readfile[m],true)then begin
aclose(readfile[m]);readopen[m]:=2;
if alignstate<>1000000 then begin runaway;begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(839);
end;printesc(579);begin helpptr:=1;helpline[0]:=840;end;
alignstate:=1000000;error;end;end;end{:503};curinput.limitfield:=last;
if(eqtb[28980].int<0)or(eqtb[28980].int>255)then decr(curinput.
limitfield)else buffer[curinput.limitfield]:=eqtb[28980].int;
first:=curinput.limitfield+1;curinput.locfield:=curinput.startfield;
curinput.statefield:=58;
{1515:}if j=1 then begin while curinput.locfield<=curinput.limitfield do
begin curchr:=buffer[curinput.locfield];incr(curinput.locfield);
if curchr=32 then curtok:=2592 else curtok:=curchr+3072;
begin q:=getavail;mem[p].hh.rh:=q;mem[q].hh.lh:=curtok;p:=q;end;end;
goto 30;end{:1515};while true do begin gettoken;
if curtok=0 then goto 30;
if alignstate<1000000 then begin repeat gettoken;until curtok=0;
alignstate:=1000000;goto 30;end;begin q:=getavail;mem[p].hh.rh:=q;
mem[q].hh.lh:=curtok;p:=q;end;end;30:endfilereading{:500};
until alignstate=1000000;curval:=defref;scannerstatus:=0;alignstate:=s;
end;{:499}{511:}procedure passtext;label 30;var l:integer;
savescannerstatus:smallnumber;begin savescannerstatus:=scannerstatus;
scannerstatus:=1;l:=0;skipline:=line;while true do begin getnext;
if curcmd=118 then begin if l=0 then goto 30;if curchr=2 then decr(l);
end else if curcmd=117 then incr(l);end;
30:scannerstatus:=savescannerstatus;
if eqtb[28994].int>0 then showcurcmdchr;end;
{:511}{514:}procedure changeiflimit(l:smallnumber;p:halfword);label 10;
var q:halfword;begin if p=condptr then iflimit:=l else begin q:=condptr;
while true do begin if q=-268435455 then confusion(841);
if mem[q].hh.rh=p then begin mem[q].hh.b0:=l;goto 10;end;
q:=mem[q].hh.rh;end;end;10:end;{:514}{515:}procedure conditional;
label 10,50;var b:boolean;r:60..62;m,n:integer;p,q:halfword;
savescannerstatus:smallnumber;savecondptr:halfword;thisif:smallnumber;
isunless:boolean;
begin if eqtb[28994].int>0 then if eqtb[28967].int<=1 then showcurcmdchr
;{512:}begin p:=getnode(2);mem[p].hh.rh:=condptr;mem[p].hh.b0:=iflimit;
mem[p].hh.b1:=curif;mem[p+1].int:=ifline;condptr:=p;curif:=curchr;
iflimit:=1;ifline:=line;end{:512};savecondptr:=condptr;
isunless:=(curchr>=32);thisif:=curchr mod 32;
{518:}case thisif of 0,1:{523:}begin begin getxtoken;
if curcmd=0 then if curchr=257 then begin curcmd:=13;
curchr:=curtok-65536;end;end;
if(curcmd=16)or(curcmd=17)or(curcmd=18)then begin m:=curcmd;n:=curchr;
end else if(curcmd>13)or(curchr>255)then begin m:=0;n:=256;
end else begin m:=curcmd;n:=curchr;end;begin getxtoken;
if curcmd=0 then if curchr=257 then begin curcmd:=13;
curchr:=curtok-65536;end;end;
if(curcmd=16)or(curcmd=17)or(curcmd=18)then begin curcmd:=curcmd;
end else if(curcmd>13)or(curchr>255)then begin curcmd:=0;curchr:=256;
end;if thisif=0 then b:=(n=curchr)else b:=(m=curcmd);end{:523};
2,3:{520:}begin if thisif=2 then scanint else scandimen(false,false,
false);n:=curval;{423:}repeat getxtoken;until curcmd<>10{:423};
if(curtok>=3132)and(curtok<=3134)then r:=curtok-3072 else begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(873);
end;printcmdchr(117,thisif);begin helpptr:=1;helpline[0]:=874;end;
backerror;r:=61;end;
if thisif=2 then scanint else scandimen(false,false,false);
case r of 60:b:=(n<curval);61:b:=(n=curval);62:b:=(n>curval);end;
end{:520};4:{521:}begin scanint;b:=odd(curval);end{:521};
5:b:=(abs(curlist.modefield)=1);6:b:=(abs(curlist.modefield)=114);
7:b:=(abs(curlist.modefield)=227);8:b:=(curlist.modefield<0);
20:b:=(abs(curlist.dirfield)=3);21:b:=(abs(curlist.dirfield)=4);
22:b:=(abs(curlist.dirfield)=1);23:b:=(curlist.dirfield<0);
9,10,11,24,25,26:{522:}begin scanregisternum;
if curval<256 then p:=eqtb[25332+curval].hh.rh else begin findsaelement(
4,curval,false);
if curptr=-268435455 then p:=-268435455 else p:=mem[curptr+1].hh.rh;end;
if thisif=9 then b:=(p=-268435455)else if p=-268435455 then b:=false
else begin if mem[p].hh.b0=2 then p:=mem[p+5].hh.rh;
if thisif=10 then b:=(mem[p].hh.b0=0)else if thisif=11 then b:=(mem[p].
hh.b0=1)else if thisif=24 then b:=(((mem[p].hh.b1)mod 8)=3)else if
thisif=25 then b:=(((mem[p].hh.b1)mod 8)=4)else b:=(((mem[p].hh.b1)mod 8
)=1);end end{:522};27:begin savescannerstatus:=scannerstatus;
scannerstatus:=0;getnext;scannerstatus:=savescannerstatus;
if curcs<514 then m:=primlookup(curcs-257)else m:=primlookup(hash[curcs]
.rh);b:=((curcmd<>113)and(m<>0)and(curcmd=primeqtb[m].hh.b0)and(curchr=
primeqtb[m].hh.rh));end;12:{524:}begin savescannerstatus:=scannerstatus;
scannerstatus:=0;getnext;n:=curcs;p:=curcmd;q:=curchr;getnext;
if curcmd<>p then b:=false else if curcmd<123 then b:=(curchr=q)else
{525:}begin p:=mem[curchr].hh.rh;q:=mem[eqtb[n].hh.rh].hh.rh;
if p=q then b:=true else begin while(p<>-268435455)and(q<>-268435455)do
if mem[p].hh.lh<>mem[q].hh.lh then p:=-268435455 else begin p:=mem[p].hh
.rh;q:=mem[q].hh.rh;end;b:=((p=-268435455)and(q=-268435455));end;
end{:525};scannerstatus:=savescannerstatus;end{:524};
13:begin scanfourbitintor18;
if curval=18 then b:=not shellenabledp else b:=(readopen[curval]=2);end;
14:b:=true;15:b:=false;{1520:}17:begin savescannerstatus:=scannerstatus;
scannerstatus:=0;getnext;b:=(curcmd<>113);
scannerstatus:=savescannerstatus;end;{:1520}{1521:}18:begin n:=getavail;
p:=n;repeat getxtoken;if curcs=0 then begin q:=getavail;mem[p].hh.rh:=q;
mem[q].hh.lh:=curtok;p:=q;end;until curcs<>0;
if curcmd<>70 then{390:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(681);
end;printesc(543);print(682);begin helpptr:=2;helpline[1]:=683;
helpline[0]:=684;end;backerror;end{:390};{1522:}m:=first;
p:=mem[n].hh.rh;
while p<>-268435455 do begin if m>=maxbufstack then begin maxbufstack:=m
+1;if maxbufstack=bufsize then overflow(257,bufsize);end;
if checkkanji(mem[p].hh.lh)then begin buffer[m]:=Hi(mem[p].hh.lh);
incr(m);end;buffer[m]:=Lo(mem[p].hh.lh);incr(m);p:=mem[p].hh.rh;end;
if m>first+1 then curcs:=idlookup(first,m-first)else if m=first then
curcs:=513 else curcs:=257+buffer[first]{:1522};flushlist(n);
b:=(eqtb[curcs].hh.b0<>113);end;{:1521}{1523:}19:begin scanfontident;
n:=curval;scancharnum;
if(fontbc[n]<=curval)and(fontec[n]>=curval)then b:=(fontinfo[charbase[n]
+curval].qqqq.b0>0)else b:=false;end;{:1523}16:{526:}begin scanint;
n:=curval;if eqtb[28967].int>1 then begin begindiagnostic;print(875);
printint(n);printchar(125);enddiagnostic(false);end;
while n<>0 do begin passtext;
if condptr=savecondptr then if curchr=4 then decr(n)else goto 50 else if
curchr=2 then{513:}begin if ifstack[inopen]=condptr then ifwarning;
p:=condptr;ifline:=mem[p+1].int;curif:=mem[p].hh.b1;
iflimit:=mem[p].hh.b0;condptr:=mem[p].hh.rh;freenode(p,2);end{:513};end;
changeiflimit(4,savecondptr);goto 10;end{:526};end{:518};
if isunless then b:=not b;
if eqtb[28967].int>1 then{519:}begin begindiagnostic;
if b then print(871)else print(872);enddiagnostic(false);end{:519};
if b then begin changeiflimit(3,savecondptr);goto 10;end;
{517:}while true do begin passtext;
if condptr=savecondptr then begin if curchr<>4 then goto 50;
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(869);
end;printesc(867);begin helpptr:=1;helpline[0]:=870;end;error;
end else if curchr=2 then{513:}begin if ifstack[inopen]=condptr then
ifwarning;p:=condptr;ifline:=mem[p+1].int;curif:=mem[p].hh.b1;
iflimit:=mem[p].hh.b0;condptr:=mem[p].hh.rh;freenode(p,2);end{:513};
end{:517};
50:if curchr=2 then{513:}begin if ifstack[inopen]=condptr then ifwarning
;p:=condptr;ifline:=mem[p+1].int;curif:=mem[p].hh.b1;
iflimit:=mem[p].hh.b0;condptr:=mem[p].hh.rh;freenode(p,2);
end{:513}else iflimit:=2;10:end;{:515}{532:}procedure beginname;
begin areadelimiter:=0;extdelimiter:=0;quotedfilename:=false;
prevchar:=0;end;{:532}{533:}function morename(c:ASCIIcode):boolean;
begin if(c=32)and stopatspace and(not quotedfilename)then morename:=
false else if c=34 then begin quotedfilename:=not quotedfilename;
morename:=true;
end else begin begin if poolptr+1>poolsize then overflow(258,poolsize-
initpoolptr);end;begin strpool[poolptr]:=c;incr(poolptr);end;
if(ISDIRSEP(c)and(notkanjicharseq(prevchar,c)))then begin areadelimiter
:=(poolptr-strstart[strptr]);extdelimiter:=0;
end else if c=46 then extdelimiter:=(poolptr-strstart[strptr]);
morename:=true;end;prevchar:=c;end;{:533}{534:}procedure endname;
var tempstr:strnumber;j,s,t:poolpointer;mustquote:boolean;
begin if strptr+3>maxstrings then overflow(259,maxstrings-initstrptr);
begin if poolptr+6>poolsize then overflow(258,poolsize-initpoolptr);end;
if areadelimiter<>0 then begin mustquote:=false;s:=strstart[strptr];
t:=strstart[strptr]+areadelimiter;j:=s;
while(not mustquote)and(j<t)do begin mustquote:=strpool[j]=32;incr(j);
end;if mustquote then begin for j:=poolptr-1 downto t do strpool[j+2]:=
strpool[j];strpool[t+1]:=34;
for j:=t-1 downto s do strpool[j+1]:=strpool[j];strpool[s]:=34;
if extdelimiter<>0 then extdelimiter:=extdelimiter+2;
areadelimiter:=areadelimiter+2;poolptr:=poolptr+2;end;end;
s:=strstart[strptr]+areadelimiter;
if extdelimiter=0 then t:=poolptr else t:=strstart[strptr]+extdelimiter
-1;mustquote:=false;j:=s;
while(not mustquote)and(j<t)do begin mustquote:=strpool[j]=32;incr(j);
end;if mustquote then begin for j:=poolptr-1 downto t do strpool[j+2]:=
strpool[j];strpool[t+1]:=34;
for j:=t-1 downto s do strpool[j+1]:=strpool[j];strpool[s]:=34;
if extdelimiter<>0 then extdelimiter:=extdelimiter+2;poolptr:=poolptr+2;
end;if extdelimiter<>0 then begin s:=strstart[strptr]+extdelimiter-1;
t:=poolptr;mustquote:=false;j:=s;
while(not mustquote)and(j<t)do begin mustquote:=strpool[j]=32;incr(j);
end;if mustquote then begin strpool[t+1]:=34;
for j:=t-1 downto s do strpool[j+1]:=strpool[j];strpool[s]:=34;
poolptr:=poolptr+2;end;end;
if areadelimiter=0 then curarea:=343 else begin curarea:=strptr;
strstart[strptr+1]:=strstart[strptr]+areadelimiter;incr(strptr);
tempstr:=searchstring(curarea);if tempstr>0 then begin curarea:=tempstr;
decr(strptr);
for j:=strstart[strptr+1]to poolptr-1 do begin strpool[j-areadelimiter]
:=strpool[j];end;poolptr:=poolptr-areadelimiter;end;end;
if extdelimiter=0 then begin curext:=343;curname:=slowmakestring;
end else begin curname:=strptr;
strstart[strptr+1]:=strstart[strptr]+extdelimiter-areadelimiter-1;
incr(strptr);curext:=makestring;decr(strptr);
tempstr:=searchstring(curname);if tempstr>0 then begin curname:=tempstr;
decr(strptr);
for j:=strstart[strptr+1]to poolptr-1 do begin strpool[j-extdelimiter+
areadelimiter+1]:=strpool[j];end;
poolptr:=poolptr-extdelimiter+areadelimiter+1;end;
curext:=slowmakestring;end;end;
{:534}{536:}procedure packfilename(n,a,e:strnumber);var k:integer;
c:ASCIIcode;j:poolpointer;begin k:=0;
if nameoffile then libcfree(nameoffile);
nameoffile:=xmallocarray(ASCIIcode,(strstart[a+1]-strstart[a])+(strstart
[n+1]-strstart[n])+(strstart[e+1]-strstart[e])+1);
for j:=strstart[a]to strstart[a+1]-1 do begin c:=strpool[j];
if not(c=34)then begin incr(k);if k<=maxint then nameoffile[k]:=xchr[c];
end end;for j:=strstart[n]to strstart[n+1]-1 do begin c:=strpool[j];
if not(c=34)then begin incr(k);if k<=maxint then nameoffile[k]:=xchr[c];
end end;for j:=strstart[e]to strstart[e+1]-1 do begin c:=strpool[j];
if not(c=34)then begin incr(k);if k<=maxint then nameoffile[k]:=xchr[c];
end end;if k<=maxint then namelength:=k else namelength:=maxint;
nameoffile[namelength+1]:=0;end;
{:536}{540:}procedure packbufferedname(n:smallnumber;a,b:integer);
var k:integer;c:ASCIIcode;j:integer;
begin if n+b-a+5>maxint then b:=a+maxint-n-5;k:=0;
if nameoffile then libcfree(nameoffile);
nameoffile:=xmallocarray(ASCIIcode,n+(b-a+1)+5);
for j:=1 to n do begin c:=xord[ucharcast(TEXformatdefault[j])];
if not(c=34)then begin incr(k);if k<=maxint then nameoffile[k]:=xchr[c];
end end;for j:=a to b do begin c:=buffer[j];
if not(c=34)then begin incr(k);if k<=maxint then nameoffile[k]:=xchr[c];
end end;
for j:=formatdefaultlength-3 to formatdefaultlength do begin c:=xord[
ucharcast(TEXformatdefault[j])];if not(c=34)then begin incr(k);
if k<=maxint then nameoffile[k]:=xchr[c];end end;
if k<=maxint then namelength:=k else namelength:=maxint;
nameoffile[namelength+1]:=0;end;
{:540}{542:}function makenamestring:strnumber;var k:1..maxint;
saveareadelimiter,saveextdelimiter:poolpointer;
savenameinprogress,savestopatspace:boolean;
begin if(poolptr+namelength>poolsize)or(strptr=maxstrings)or((poolptr-
strstart[strptr])>0)then makenamestring:=63 else begin for k:=1 to
namelength do begin strpool[poolptr]:=xord[nameoffile[k]];incr(poolptr);
end;makenamestring:=makestring;saveareadelimiter:=areadelimiter;
saveextdelimiter:=extdelimiter;savenameinprogress:=nameinprogress;
savestopatspace:=stopatspace;nameinprogress:=true;beginname;
stopatspace:=false;k:=1;
while(k<=namelength)and(morename(nameoffile[k]))do incr(k);
stopatspace:=savestopatspace;endname;nameinprogress:=savenameinprogress;
areadelimiter:=saveareadelimiter;extdelimiter:=saveextdelimiter;end;end;
function amakenamestring(var f:alphafile):strnumber;
begin amakenamestring:=makenamestring;end;
function bmakenamestring(var f:bytefile):strnumber;
begin bmakenamestring:=makenamestring;end;
function wmakenamestring(var f:wordfile):strnumber;
begin wmakenamestring:=makenamestring;end;
{:542}{543:}procedure scanfilename;label 30;begin nameinprogress:=true;
beginname;{423:}repeat getxtoken;until curcmd<>10{:423};skipmode:=false;
while true do begin if(curcmd=16)or(curcmd=17)or(curcmd=18)then begin
begin if poolptr+2>poolsize then overflow(258,poolsize-initpoolptr);end;
begin strpool[poolptr]:=Hi(curchr);incr(poolptr);end;
begin strpool[poolptr]:=Lo(curchr);incr(poolptr);end;
end else if(curcmd>12)or(curchr>255)then begin backinput;goto 30;
end else if((curchr=32)and(curinput.statefield<>0)and(curinput.locfield>
curinput.limitfield))or not morename(curchr)then goto 30;getxtoken;end;
30:endname;nameinprogress:=false;skipmode:=true;end;
{:543}{546:}procedure packjobname(s:strnumber);begin curarea:=343;
curext:=s;curname:=jobname;packfilename(curname,curarea,curext);end;
{:546}{547:}procedure promptfilename(s,e:strnumber);label 30;
var k:0..bufsize;savedcurname:strnumber;savedcurext:strnumber;
savedcurarea:strnumber;begin if interaction=2 then;
if s=877 then begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(878);
end else begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(879);
end;printfilename(curname,curarea,curext);print(880);
if(e=881)or(e=343)then showcontext;println;
printcstring(promptfilenamehelpmsg);if(e<>343)then begin print(882);
print(e);print(39);end;print(41);println;printnl(883);print(s);
if interaction<2 then fatalerror(884);savedcurname:=curname;
savedcurext:=curext;savedcurarea:=curarea;;begin;print(617);terminput;
end;{548:}begin beginname;k:=first;
while(buffer[k]=32)and(k<last)do incr(k);
while true do begin if k=last then goto 30;
if not morename(buffer[k])then goto 30;incr(k);end;30:endname;end{:548};
if((strstart[curname+1]-strstart[curname])=0)and(curext=343)and(curarea=
343)then begin curname:=savedcurname;curext:=savedcurext;
curarea:=savedcurarea;end else if curext=343 then curext:=e;
packfilename(curname,curarea,curext);end;
{:547}{551:}procedure openlogfile;var oldsetting:0..21;k:0..bufsize;
l:0..bufsize;months:constcstring;begin oldsetting:=selector;
if jobname=0 then jobname:=getjobname(887);packjobname(888);
recorderchangefilename(stringcast(nameoffile+1));packjobname(889);
while not aopenout(logfile)do{552:}begin selector:=17;
promptfilename(891,889);end{:552};
texmflogname:=amakenamestring(logfile);selector:=18;logopened:=true;
{553:}begin if srcspecialsp or filelineerrorstylep or parsefirstlinep
then write(logfile,'This is e-pTeX, Version 3.14159265','-p3.7',
'-150805','-2.6')else write(logfile,'This is e-pTeX, Version 3.14159265'
,'-p3.7','-150805','-2.6');write(logfile,' (');
write(logfile,conststringcast(getencstring));write(logfile,')');
write(logfile,versionstring);slowprint(formatident);print(892);
printint(eqtb[28952].int);printchar(32);
months:=' JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC';
for k:=3*eqtb[28953].int-2 to 3*eqtb[28953].int do write(logfile,months[
k]);printchar(32);printint(eqtb[28954].int);printchar(32);
printtwo(eqtb[28951].int div 60);printchar(58);
printtwo(eqtb[28951].int mod 60);if(eTeXmode=1)then begin;
writeln(logfile);write(logfile,'entering extended mode');end;
if shellenabledp then begin writeln(logfile);write(logfile,' ');
if restrictedshell then begin write(logfile,'restricted ');end;
write(logfile,'\write18 enabled.')end;
if srcspecialsp then begin writeln(logfile);
write(logfile,' Source specials enabled.')end;
if filelineerrorstylep then begin writeln(logfile);
write(logfile,' file:line:error style messages enabled.')end;
if parsefirstlinep then begin writeln(logfile);
write(logfile,' %&-line parsing enabled.');end;
if translatefilename then begin writeln(logfile);write(logfile,' (');
fputs(translatefilename,logfile);write(logfile,')');end;end{:553};
if mltexenabledp then begin writeln(logfile);
write(logfile,'MLTeX v2.2 enabled');end;inputstack[inputptr]:=curinput;
printnl(890);l:=inputstack[0].limitfield;
if buffer[l]=eqtb[28980].int then decr(l);
for k:=1 to l do print(buffer[k]);println;selector:=oldsetting+2;end;
{:551}{554:}procedure startinput;label 30;var tempstr:strnumber;
begin scanfilename;packfilename(curname,curarea,curext);
while true do begin beginfilereading;texinputtype:=1;
if kpseinnameok(stringcast(nameoffile+1))and aopenin(inputfile[curinput.
indexfield],kpsetexformat)then goto 30;endfilereading;
promptfilename(877,343);end;
30:curinput.namefield:=amakenamestring(inputfile[curinput.indexfield]);
sourcefilenamestack[inopen]:=curinput.namefield;
fullsourcefilenamestack[inopen]:=makefullnamestring;
if curinput.namefield=strptr-1 then begin tempstr:=searchstring(curinput
.namefield);if tempstr>0 then begin curinput.namefield:=tempstr;
begin decr(strptr);poolptr:=strstart[strptr];end;end;end;
if jobname=0 then begin jobname:=getjobname(curname);openlogfile;end;
if termoffset+(strstart[fullsourcefilenamestack[inopen]+1]-strstart[
fullsourcefilenamestack[inopen]])>maxprintline-2 then println else if(
termoffset>0)or(fileoffset>0)then printchar(32);printchar(40);
incr(openparens);slowprint(fullsourcefilenamestack[inopen]);
fflush(stdout);curinput.statefield:=58;{1659:}synctexstartinput;{:1659};
{555:}begin line:=1;
if inputln(inputfile[curinput.indexfield],false)then;firmuptheline;
if(eqtb[28980].int<0)or(eqtb[28980].int>255)then decr(curinput.
limitfield)else buffer[curinput.limitfield]:=eqtb[28980].int;
first:=curinput.limitfield+1;curinput.locfield:=curinput.startfield;
end{:555};end;
{:554}{577:}{1637:}function effectivecharinfo(f:internalfontnumber;
c:quarterword):fourquarters;label 10;var ci:fourquarters;basec:integer;
begin if not mltexenabledp then begin effectivecharinfo:=fontinfo[
charbase[f]+c].qqqq;goto 10;end;
if fontec[f]>=c then if fontbc[f]<=c then begin ci:=fontinfo[charbase[f]
+c].qqqq;if(ci.b0>0)then begin effectivecharinfo:=ci;goto 10;end;end;
if c>=eqtb[28988].int then if c<=eqtb[28989].int then if(eqtb[28675+c].
hh.rh>0)then begin basec:=(eqtb[28675+c].hh.rh mod 256);
if fontec[f]>=basec then if fontbc[f]<=basec then begin ci:=fontinfo[
charbase[f]+basec].qqqq;if(ci.b0>0)then begin effectivecharinfo:=ci;
goto 10;end;end;end;effectivecharinfo:=nullcharacter;10:end;
{:1637}function readfontinfo(u:halfword;nom,aire:strnumber;
s:scaled):internalfontnumber;label 30,11,45;var k:fontindex;
jfmflag:0..3;nt:halfword;cx:KANJIcode;nametoolong:boolean;
fileopened:boolean;lf,lh,bc,ec,nw,nh,nd,ni,nl,nk,ne,np:halfword;
f:internalfontnumber;g:internalfontnumber;a,b,c,d:eightbits;
qw:fourquarters;sw:scaled;bchlabel:integer;bchar:0..256;z:scaled;
alpha:integer;beta:1..16;begin g:=0;{579:}{580:}fileopened:=false;
nametoolong:=((strstart[nom+1]-strstart[nom])>255)or((strstart[aire+1]-
strstart[aire])>255);if nametoolong then goto 11;
packfilename(nom,aire,343);if not bopenin(tfmfile)then goto 11;
fileopened:=true{:580};{582:}begin begin lf:=tfmtemp;
if lf>127 then goto 11;tfmtemp:=getc(tfmfile);lf:=lf*256+tfmtemp;end;
tfmtemp:=getc(tfmfile);begin lh:=tfmtemp;if lh>127 then goto 11;
tfmtemp:=getc(tfmfile);lh:=lh*256+tfmtemp;end;
if lf=11 then begin jfmflag:=4;nt:=lh;tfmtemp:=getc(tfmfile);
begin lf:=tfmtemp;if lf>127 then goto 11;tfmtemp:=getc(tfmfile);
lf:=lf*256+tfmtemp;end;tfmtemp:=getc(tfmfile);begin lh:=tfmtemp;
if lh>127 then goto 11;tfmtemp:=getc(tfmfile);lh:=lh*256+tfmtemp;end;
end else if lf=9 then begin jfmflag:=3;nt:=lh;tfmtemp:=getc(tfmfile);
begin lf:=tfmtemp;if lf>127 then goto 11;tfmtemp:=getc(tfmfile);
lf:=lf*256+tfmtemp;end;tfmtemp:=getc(tfmfile);begin lh:=tfmtemp;
if lh>127 then goto 11;tfmtemp:=getc(tfmfile);lh:=lh*256+tfmtemp;end;
end else begin jfmflag:=0;nt:=0;end;tfmtemp:=getc(tfmfile);
begin bc:=tfmtemp;if bc>127 then goto 11;tfmtemp:=getc(tfmfile);
bc:=bc*256+tfmtemp;end;tfmtemp:=getc(tfmfile);begin ec:=tfmtemp;
if ec>127 then goto 11;tfmtemp:=getc(tfmfile);ec:=ec*256+tfmtemp;end;
if(bc>ec+1)or(ec>255)then goto 11;if bc>255 then begin bc:=1;ec:=0;end;
tfmtemp:=getc(tfmfile);begin nw:=tfmtemp;if nw>127 then goto 11;
tfmtemp:=getc(tfmfile);nw:=nw*256+tfmtemp;end;tfmtemp:=getc(tfmfile);
begin nh:=tfmtemp;if nh>127 then goto 11;tfmtemp:=getc(tfmfile);
nh:=nh*256+tfmtemp;end;tfmtemp:=getc(tfmfile);begin nd:=tfmtemp;
if nd>127 then goto 11;tfmtemp:=getc(tfmfile);nd:=nd*256+tfmtemp;end;
tfmtemp:=getc(tfmfile);begin ni:=tfmtemp;if ni>127 then goto 11;
tfmtemp:=getc(tfmfile);ni:=ni*256+tfmtemp;end;tfmtemp:=getc(tfmfile);
begin nl:=tfmtemp;if nl>127 then goto 11;tfmtemp:=getc(tfmfile);
nl:=nl*256+tfmtemp;end;tfmtemp:=getc(tfmfile);begin nk:=tfmtemp;
if nk>127 then goto 11;tfmtemp:=getc(tfmfile);nk:=nk*256+tfmtemp;end;
tfmtemp:=getc(tfmfile);begin ne:=tfmtemp;if ne>127 then goto 11;
tfmtemp:=getc(tfmfile);ne:=ne*256+tfmtemp;end;tfmtemp:=getc(tfmfile);
begin np:=tfmtemp;if np>127 then goto 11;tfmtemp:=getc(tfmfile);
np:=np*256+tfmtemp;end;
if jfmflag<>0 then begin if lf<>7+lh+nt+(ec-bc+1)+nw+nh+nd+ni+nl+nk+ne+
np then goto 11;
end else begin if lf<>6+lh+(ec-bc+1)+nw+nh+nd+ni+nl+nk+ne+np then goto
11;end;if(nw=0)or(nh=0)or(nd=0)or(ni=0)then goto 11;end{:582};
{583:}if jfmflag<>0 then lf:=lf-7-lh else lf:=lf-6-lh;
if np<7 then lf:=lf+7-np;
if(fontptr=fontmax)or(fmemptr+lf>fontmemsize)then{584:}begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(894);
end;sprintcs(u);printchar(61);printfilename(nom,aire,343);
if s>=0 then begin print(826);printscaled(s);print(418);
end else if s<>-1000 then begin print(895);printint(-s);end;print(904);
begin helpptr:=4;helpline[3]:=905;helpline[2]:=906;helpline[1]:=907;
helpline[0]:=908;end;error;goto 30;end{:584};f:=fontptr+1;
fontdir[f]:=jfmflag;fontnumext[f]:=nt;ctypebase[f]:=fmemptr;
charbase[f]:=ctypebase[f]+nt-bc;widthbase[f]:=charbase[f]+ec+1;
heightbase[f]:=widthbase[f]+nw;depthbase[f]:=heightbase[f]+nh;
italicbase[f]:=depthbase[f]+nd;ligkernbase[f]:=italicbase[f]+ni;
kernbase[f]:=ligkernbase[f]+nl-256*(128);
extenbase[f]:=kernbase[f]+256*(128)+nk;parambase[f]:=extenbase[f]+ne;
{:583};{585:}begin if lh<2 then goto 11;begin tfmtemp:=getc(tfmfile);
a:=tfmtemp;qw.b0:=a;tfmtemp:=getc(tfmfile);b:=tfmtemp;qw.b1:=b;
tfmtemp:=getc(tfmfile);c:=tfmtemp;qw.b2:=c;tfmtemp:=getc(tfmfile);
d:=tfmtemp;qw.b3:=d;fontcheck[f]:=qw;end;tfmtemp:=getc(tfmfile);
begin z:=tfmtemp;if z>127 then goto 11;tfmtemp:=getc(tfmfile);
z:=z*256+tfmtemp;end;tfmtemp:=getc(tfmfile);z:=z*256+tfmtemp;
tfmtemp:=getc(tfmfile);z:=(z*16)+(tfmtemp div 16);
if z<65536 then goto 11;while lh>2 do begin tfmtemp:=getc(tfmfile);
tfmtemp:=getc(tfmfile);tfmtemp:=getc(tfmfile);tfmtemp:=getc(tfmfile);
decr(lh);end;fontdsize[f]:=z;
if s<>-1000 then if s>=0 then z:=s else z:=xnoverd(z,-s,1000);
fontsize[f]:=z;end{:585};
{586:}if jfmflag<>0 then for k:=ctypebase[f]to ctypebase[f]+nt-1 do
begin tfmtemp:=getc(tfmfile);begin cx:=tfmtemp;if cx>127 then goto 11;
tfmtemp:=getc(tfmfile);cx:=cx*256+tfmtemp;end;fontinfo[k].hh.rh:=cx;
tfmtemp:=getc(tfmfile);begin cx:=tfmtemp;if cx>127 then goto 11;
tfmtemp:=getc(tfmfile);cx:=cx*256+tfmtemp;end;
fontinfo[k].hh.lhfield:=cx;end;
for k:=charbase[f]+bc to widthbase[f]-1 do begin begin tfmtemp:=getc(
tfmfile);a:=tfmtemp;qw.b0:=a;tfmtemp:=getc(tfmfile);b:=tfmtemp;qw.b1:=b;
tfmtemp:=getc(tfmfile);c:=tfmtemp;qw.b2:=c;tfmtemp:=getc(tfmfile);
d:=tfmtemp;qw.b3:=d;fontinfo[k].qqqq:=qw;end;
if(a>=nw)or(b div 16>=nh)or(b mod 16>=nd)or(c div 4>=ni)then goto 11;
case c mod 4 of 1:if d>=nl then goto 11;3:if d>=ne then goto 11;
2:{587:}begin begin if(d<bc)or(d>ec)then goto 11 end;
while d<k-charbase[f]do begin qw:=fontinfo[charbase[f]+d].qqqq;
if((qw.b2)mod 4)<>2 then goto 45;d:=qw.b3;end;
if d=k-charbase[f]then goto 11;45:end{:587};others:end;end{:586};
{588:}begin{589:}begin alpha:=16;while z>=8388608 do begin z:=z div 2;
alpha:=alpha+alpha;end;beta:=256 div alpha;alpha:=alpha*z;end{:589};
for k:=widthbase[f]to ligkernbase[f]-1 do begin tfmtemp:=getc(tfmfile);
a:=tfmtemp;tfmtemp:=getc(tfmfile);b:=tfmtemp;tfmtemp:=getc(tfmfile);
c:=tfmtemp;tfmtemp:=getc(tfmfile);d:=tfmtemp;
sw:=(((((d*z)div 256)+(c*z))div 256)+(b*z))div beta;
if a=0 then fontinfo[k].int:=sw else if a=255 then fontinfo[k].int:=sw-
alpha else goto 11;end;if fontinfo[widthbase[f]].int<>0 then goto 11;
if fontinfo[heightbase[f]].int<>0 then goto 11;
if fontinfo[depthbase[f]].int<>0 then goto 11;
if fontinfo[italicbase[f]].int<>0 then goto 11;end{:588};
{590:}bchlabel:=32767;bchar:=256;
if nl>0 then begin for k:=ligkernbase[f]to kernbase[f]+256*(128)-1 do
begin begin tfmtemp:=getc(tfmfile);a:=tfmtemp;qw.b0:=a;
tfmtemp:=getc(tfmfile);b:=tfmtemp;qw.b1:=b;tfmtemp:=getc(tfmfile);
c:=tfmtemp;qw.b2:=c;tfmtemp:=getc(tfmfile);d:=tfmtemp;qw.b3:=d;
fontinfo[k].qqqq:=qw;end;
if a>128 then begin if 256*c+d>=nl then goto 11;
if a=255 then if k=ligkernbase[f]then bchar:=b;
end else begin if b<>bchar then begin begin if(b<bc)or(b>ec)then goto 11
end;qw:=fontinfo[charbase[f]+b].qqqq;if not(qw.b0>0)then goto 11;end;
if c<128 then begin if jfmflag<>0 then begin if d>=ne then goto 11;
end else begin begin if(d<bc)or(d>ec)then goto 11 end;
qw:=fontinfo[charbase[f]+d].qqqq;if not(qw.b0>0)then goto 11;end;
end else if 256*(c-128)+d>=nk then goto 11;
if a<128 then if k-ligkernbase[f]+a+1>=nl then goto 11;end;end;
if a=255 then bchlabel:=256*c+d;end;
for k:=kernbase[f]+256*(128)to extenbase[f]-1 do begin tfmtemp:=getc(
tfmfile);a:=tfmtemp;tfmtemp:=getc(tfmfile);b:=tfmtemp;
tfmtemp:=getc(tfmfile);c:=tfmtemp;tfmtemp:=getc(tfmfile);d:=tfmtemp;
sw:=(((((d*z)div 256)+(c*z))div 256)+(b*z))div beta;
if a=0 then fontinfo[k].int:=sw else if a=255 then fontinfo[k].int:=sw-
alpha else goto 11;end;{:590};
{591:}if jfmflag<>0 then for k:=extenbase[f]to parambase[f]-1 do begin
tfmtemp:=getc(tfmfile);a:=tfmtemp;tfmtemp:=getc(tfmfile);b:=tfmtemp;
tfmtemp:=getc(tfmfile);c:=tfmtemp;tfmtemp:=getc(tfmfile);d:=tfmtemp;
sw:=(((((d*z)div 256)+(c*z))div 256)+(b*z))div beta;
if a=0 then fontinfo[k].int:=sw else if a=255 then fontinfo[k].int:=sw-
alpha else goto 11;
end else for k:=extenbase[f]to parambase[f]-1 do begin begin tfmtemp:=
getc(tfmfile);a:=tfmtemp;qw.b0:=a;tfmtemp:=getc(tfmfile);b:=tfmtemp;
qw.b1:=b;tfmtemp:=getc(tfmfile);c:=tfmtemp;qw.b2:=c;
tfmtemp:=getc(tfmfile);d:=tfmtemp;qw.b3:=d;fontinfo[k].qqqq:=qw;end;
if a<>0 then begin begin if(a<bc)or(a>ec)then goto 11 end;
qw:=fontinfo[charbase[f]+a].qqqq;if not(qw.b0>0)then goto 11;end;
if b<>0 then begin begin if(b<bc)or(b>ec)then goto 11 end;
qw:=fontinfo[charbase[f]+b].qqqq;if not(qw.b0>0)then goto 11;end;
if c<>0 then begin begin if(c<bc)or(c>ec)then goto 11 end;
qw:=fontinfo[charbase[f]+c].qqqq;if not(qw.b0>0)then goto 11;end;
begin begin if(d<bc)or(d>ec)then goto 11 end;
qw:=fontinfo[charbase[f]+d].qqqq;if not(qw.b0>0)then goto 11;end;
end{:591};
{592:}begin for k:=1 to np do if k=1 then begin tfmtemp:=getc(tfmfile);
sw:=tfmtemp;if sw>127 then sw:=sw-256;tfmtemp:=getc(tfmfile);
sw:=sw*256+tfmtemp;tfmtemp:=getc(tfmfile);sw:=sw*256+tfmtemp;
tfmtemp:=getc(tfmfile);
fontinfo[parambase[f]].int:=(sw*16)+(tfmtemp div 16);
end else begin tfmtemp:=getc(tfmfile);a:=tfmtemp;tfmtemp:=getc(tfmfile);
b:=tfmtemp;tfmtemp:=getc(tfmfile);c:=tfmtemp;tfmtemp:=getc(tfmfile);
d:=tfmtemp;sw:=(((((d*z)div 256)+(c*z))div 256)+(b*z))div beta;
if a=0 then fontinfo[parambase[f]+k-1].int:=sw else if a=255 then
fontinfo[parambase[f]+k-1].int:=sw-alpha else goto 11;end;
if feof(tfmfile)then goto 11;
for k:=np+1 to 7 do fontinfo[parambase[f]+k-1].int:=0;end{:592};
{593:}if np>=7 then fontparams[f]:=np else fontparams[f]:=7;
hyphenchar[f]:=eqtb[28978].int;skewchar[f]:=eqtb[28979].int;
if bchlabel<nl then bcharlabel[f]:=bchlabel+ligkernbase[f]else
bcharlabel[f]:=0;fontbchar[f]:=bchar;fontfalsebchar[f]:=bchar;
if bchar<=ec then if bchar>=bc then begin qw:=fontinfo[charbase[f]+bchar
].qqqq;if(qw.b0>0)then fontfalsebchar[f]:=256;end;fontname[f]:=nom;
fontarea[f]:=aire;fontbc[f]:=bc;fontec[f]:=ec;fontglue[f]:=-268435455;
ctypebase[f]:=ctypebase[f];charbase[f]:=charbase[f];
widthbase[f]:=widthbase[f];ligkernbase[f]:=ligkernbase[f];
kernbase[f]:=kernbase[f];extenbase[f]:=extenbase[f];decr(parambase[f]);
fmemptr:=fmemptr+lf;fontptr:=f;g:=f;goto 30{:593}{:579};
11:{578:}begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(894);
end;sprintcs(u);printchar(61);printfilename(nom,aire,343);
if s>=0 then begin print(826);printscaled(s);print(418);
end else if s<>-1000 then begin print(895);printint(-s);end;
if fileopened then print(896)else if nametoolong then print(897)else
print(898);begin helpptr:=5;helpline[4]:=899;helpline[3]:=900;
helpline[2]:=901;helpline[1]:=902;helpline[0]:=903;end;error{:578};
30:if fileopened then bclose(tfmfile);readfontinfo:=g;end;
{:577}{598:}procedure charwarning(f:internalfontnumber;c:eightbits);
var l:0..255;oldsetting:integer;
begin if eqtb[28966].int>0 then begin oldsetting:=eqtb[28960].int;
if(eTeXmode=1)and(eqtb[28966].int>1)then eqtb[28960].int:=1;
begin begindiagnostic;printnl(917);
if(c<32)or(c>126)then begin printchar(94);printchar(94);
if c<64 then printchar(c+64)else if c<128 then printchar(c-64)else begin
l:=c div 16;if l<10 then printchar(l+48)else printchar(l+87);
l:=c mod 16;if l<10 then printchar(l+48)else printchar(l+87);
end end else print(c);print(918);slowprint(fontname[f]);printchar(33);
enddiagnostic(false);end;eqtb[28960].int:=oldsetting;end;end;
{:598}{599:}function newcharacter(f:internalfontnumber;
c:eightbits):halfword;label 10;var p:halfword;ec:quarterword;
begin ec:=effectivechar(false,f,c);
if fontbc[f]<=ec then if fontec[f]>=ec then if(fontinfo[charbase[f]+ec].
qqqq.b0>0)then begin p:=getavail;mem[p].hh.b0:=f;mem[p].hh.b1:=c;
newcharacter:=p;goto 10;end;charwarning(f,c);newcharacter:=-268435455;
10:end;{:599}{615:}procedure dviswap;
begin if dviptr>(2147483647-dvioffset)then begin curs:=-2;
fatalerror(919);end;
if dvilimit=dvibufsize then begin writedvi(0,halfbuf-1);
dvilimit:=halfbuf;dvioffset:=dvioffset+dvibufsize;dviptr:=0;
end else begin writedvi(halfbuf,dvibufsize-1);dvilimit:=dvibufsize;end;
dvigone:=dvigone+halfbuf;end;{:615}{617:}procedure dvifour(x:integer);
begin if x>=0 then begin dvibuf[dviptr]:=x div 16777216;incr(dviptr);
if dviptr=dvilimit then dviswap;end else begin x:=x+1073741824;
x:=x+1073741824;begin dvibuf[dviptr]:=(x div 16777216)+128;incr(dviptr);
if dviptr=dvilimit then dviswap;end;end;x:=x mod 16777216;
begin dvibuf[dviptr]:=x div 65536;incr(dviptr);
if dviptr=dvilimit then dviswap;end;x:=x mod 65536;
begin dvibuf[dviptr]:=x div 256;incr(dviptr);
if dviptr=dvilimit then dviswap;end;begin dvibuf[dviptr]:=x mod 256;
incr(dviptr);if dviptr=dvilimit then dviswap;end;end;
{:617}{618:}procedure dvipop(l:integer);
begin if(l=dvioffset+dviptr)and(dviptr>0)then decr(dviptr)else begin
dvibuf[dviptr]:=142;incr(dviptr);if dviptr=dvilimit then dviswap;end;
end;{:618}{619:}procedure dvifontdef(f:internalfontnumber);
var k:poolpointer;begin if f<=256 then begin begin dvibuf[dviptr]:=243;
incr(dviptr);if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=f-1;incr(dviptr);if dviptr=dvilimit then dviswap;
end;end else begin begin dvibuf[dviptr]:=244;incr(dviptr);
if dviptr=dvilimit then dviswap;end;begin dvibuf[dviptr]:=(f-1)div 256;
incr(dviptr);if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=(f-1)mod 256;incr(dviptr);
if dviptr=dvilimit then dviswap;end;end;
begin dvibuf[dviptr]:=fontcheck[f].b0;incr(dviptr);
if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=fontcheck[f].b1;incr(dviptr);
if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=fontcheck[f].b2;incr(dviptr);
if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=fontcheck[f].b3;incr(dviptr);
if dviptr=dvilimit then dviswap;end;dvifour(fontsize[f]);
dvifour(fontdsize[f]);
begin dvibuf[dviptr]:=(strstart[fontarea[f]+1]-strstart[fontarea[f]]);
incr(dviptr);if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=(strstart[fontname[f]+1]-strstart[fontname[f]]);
incr(dviptr);if dviptr=dvilimit then dviswap;end;
{620:}for k:=strstart[fontarea[f]]to strstart[fontarea[f]+1]-1 do begin
dvibuf[dviptr]:=strpool[k];incr(dviptr);if dviptr=dvilimit then dviswap;
end;
for k:=strstart[fontname[f]]to strstart[fontname[f]+1]-1 do begin dvibuf
[dviptr]:=strpool[k];incr(dviptr);if dviptr=dvilimit then dviswap;
end{:620};end;{:619}{624:}procedure movement(w:scaled;o:eightbits);
label 10,40,45,2,1;var mstate:smallnumber;p,q:halfword;k:integer;
begin q:=getnode(3);mem[q+1].int:=w;mem[q+2].int:=dvioffset+dviptr;
if o=157 then begin mem[q].hh.rh:=downptr;downptr:=q;
end else begin mem[q].hh.rh:=rightptr;rightptr:=q;end;
{628:}p:=mem[q].hh.rh;mstate:=0;
while p<>-268435455 do begin if mem[p+1].int=w then{629:}case mstate+mem
[p].hh.lh of 3,4,15,16:if mem[p+2].int<dvigone then goto 45 else{630:}
begin k:=mem[p+2].int-dvioffset;if k<0 then k:=k+dvibufsize;
dvibuf[k]:=dvibuf[k]+5;mem[p].hh.lh:=1;goto 40;end{:630};
5,9,11:if mem[p+2].int<dvigone then goto 45 else{631:}begin k:=mem[p+2].
int-dvioffset;if k<0 then k:=k+dvibufsize;dvibuf[k]:=dvibuf[k]+10;
mem[p].hh.lh:=2;goto 40;end{:631};1,2,8,13:goto 40;
others:end{:629}else case mstate+mem[p].hh.lh of 1:mstate:=6;
2:mstate:=12;8,13:goto 45;others:end;p:=mem[p].hh.rh;end;45:{:628};
{627:}mem[q].hh.lh:=3;
if abs(w)>=8388608 then begin begin dvibuf[dviptr]:=o+3;incr(dviptr);
if dviptr=dvilimit then dviswap;end;dvifour(w);goto 10;end;
if abs(w)>=32768 then begin begin dvibuf[dviptr]:=o+2;incr(dviptr);
if dviptr=dvilimit then dviswap;end;if w<0 then w:=w+16777216;
begin dvibuf[dviptr]:=w div 65536;incr(dviptr);
if dviptr=dvilimit then dviswap;end;w:=w mod 65536;goto 2;end;
if abs(w)>=128 then begin begin dvibuf[dviptr]:=o+1;incr(dviptr);
if dviptr=dvilimit then dviswap;end;if w<0 then w:=w+65536;goto 2;end;
begin dvibuf[dviptr]:=o;incr(dviptr);if dviptr=dvilimit then dviswap;
end;if w<0 then w:=w+256;goto 1;2:begin dvibuf[dviptr]:=w div 256;
incr(dviptr);if dviptr=dvilimit then dviswap;end;
1:begin dvibuf[dviptr]:=w mod 256;incr(dviptr);
if dviptr=dvilimit then dviswap;end;goto 10{:627};
40:{626:}mem[q].hh.lh:=mem[p].hh.lh;
if mem[q].hh.lh=1 then begin begin dvibuf[dviptr]:=o+4;incr(dviptr);
if dviptr=dvilimit then dviswap;end;
while mem[q].hh.rh<>p do begin q:=mem[q].hh.rh;
case mem[q].hh.lh of 3:mem[q].hh.lh:=5;4:mem[q].hh.lh:=6;others:end;end;
end else begin begin dvibuf[dviptr]:=o+9;incr(dviptr);
if dviptr=dvilimit then dviswap;end;
while mem[q].hh.rh<>p do begin q:=mem[q].hh.rh;
case mem[q].hh.lh of 3:mem[q].hh.lh:=4;5:mem[q].hh.lh:=6;others:end;end;
end{:626};10:end;{:624}{632:}procedure prunemovements(l:integer);
label 30,10;var p:halfword;
begin while downptr<>-268435455 do begin if mem[downptr+2].int<l then
goto 30;p:=downptr;downptr:=mem[p].hh.rh;freenode(p,3);end;
30:while rightptr<>-268435455 do begin if mem[rightptr+2].int<l then
goto 10;p:=rightptr;rightptr:=mem[p].hh.rh;freenode(p,3);end;10:end;
{:632}{635:}procedure vlistout;forward;
{:635}{636:}{1387:}procedure specialout(p:halfword);label 30;
var oldsetting:0..21;k:poolpointer;s,t,cw:scaled;bl:boolean;
i:smallnumber;begin if curh<>dvih then begin movement(curh-dvih,143);
dvih:=curh;end;if curv<>dviv then begin movement(curv-dviv,157);
dviv:=curv;end;oldsetting:=selector;selector:=21;
showtokenlist(mem[mem[p+1].hh.rh].hh.rh,-268435455,poolsize-poolptr);
selector:=oldsetting;
begin if poolptr+1>poolsize then overflow(258,poolsize-initpoolptr);end;
if(poolptr-strstart[strptr])<256 then begin begin dvibuf[dviptr]:=239;
incr(dviptr);if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=(poolptr-strstart[strptr]);incr(dviptr);
if dviptr=dvilimit then dviswap;end;
end else begin begin dvibuf[dviptr]:=242;incr(dviptr);
if dviptr=dvilimit then dviswap;end;dvifour((poolptr-strstart[strptr]));
end;
for k:=strstart[strptr]to poolptr-1 do begin dvibuf[dviptr]:=strpool[k];
incr(dviptr);if dviptr=dvilimit then dviswap;end;
{1745:}if poolptr-strstart[strptr]<=10 then goto 30;k:=strstart[strptr];
if(strpool[(k+0)]<>'p')or(strpool[(k+1)]<>'a')or(strpool[(k+2)]<>'p')or(
strpool[(k+3)]<>'e')or(strpool[(k+4)]<>'r')or(strpool[(k+5)]<>'s')or(
strpool[(k+6)]<>'i')or(strpool[(k+7)]<>'z')or(strpool[(k+8)]<>'e')then
goto 30;k:=k+9;
if k=poolptr then goto 30 else if strpool[(k)]='='then incr(k);
{1746:}s:=1;t:=0;bl:=true;
while(k<poolptr)and(bl)do begin if(strpool[(k)]>='0')and(strpool[(k)]<=
'9')then begin t:=10*t+strpool[(k)]-'0';incr(k);
end else begin bl:=false;end;end;t:=t*65536;
if k=poolptr then goto 30 else if strpool[(k)]='.'then begin incr(k);
bl:=true;i:=0;
while(k<poolptr)and(bl)and(i<=17)do begin if(strpool[(k)]>='0')and(
strpool[(k)]<='9')then begin dig[i]:=strpool[(k)]-'0';incr(k);incr(i);
end else begin bl:=false;incr(k);incr(i);end;end;
t:=s*(t+rounddecimals(i-1));
end else if(strpool[(k)]>='0')and(strpool[(k)]<='9')then goto 30 else
begin t:=s*t;incr(k);end;
if k=poolptr then goto 30 else if strpool[(k-1)]<>'p'then goto 30;
if k=poolptr then goto 30 else if strpool[(k)]<>'t'then goto 30;{:1746};
incr(k);
if k=poolptr then goto 30 else if strpool[(k)]<>','then goto 30 else
incr(k);cw:=t;{1746:}s:=1;t:=0;bl:=true;
while(k<poolptr)and(bl)do begin if(strpool[(k)]>='0')and(strpool[(k)]<=
'9')then begin t:=10*t+strpool[(k)]-'0';incr(k);
end else begin bl:=false;end;end;t:=t*65536;
if k=poolptr then goto 30 else if strpool[(k)]='.'then begin incr(k);
bl:=true;i:=0;
while(k<poolptr)and(bl)and(i<=17)do begin if(strpool[(k)]>='0')and(
strpool[(k)]<='9')then begin dig[i]:=strpool[(k)]-'0';incr(k);incr(i);
end else begin bl:=false;incr(k);incr(i);end;end;
t:=s*(t+rounddecimals(i-1));
end else if(strpool[(k)]>='0')and(strpool[(k)]<='9')then goto 30 else
begin t:=s*t;incr(k);end;
if k=poolptr then goto 30 else if strpool[(k-1)]<>'p'then goto 30;
if k=poolptr then goto 30 else if strpool[(k)]<>'t'then goto 30;{:1746};
geqworddefine(29537,cw);geqworddefine(29538,t);curpageheight:=t;
curpagewidth:=cw;if(dvidir=3)or(dvidir=1)then begin t:=curpageheight;
curpageheight:=curpagewidth;curpagewidth:=t;end;{:1745};
30:poolptr:=strstart[strptr];end;
{:1387}{1389:}procedure writeout(p:halfword);var oldsetting:0..21;
oldmode:integer;j:smallnumber;q,r:halfword;d:integer;clobbered:boolean;
runsystemret:integer;begin{1390:}q:=getavail;mem[q].hh.lh:=637;
r:=getavail;mem[q].hh.rh:=r;mem[r].hh.lh:=81057;begintokenlist(q,4);
begintokenlist(mem[p+1].hh.rh,16);q:=getavail;mem[q].hh.lh:=379;
begintokenlist(q,4);oldmode:=curlist.modefield;curlist.modefield:=0;
curcs:=writeloc;q:=scantoks(false,true);gettoken;
if curtok<>81057 then{1391:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1442);
end;begin helpptr:=2;helpline[1]:=1443;helpline[0]:=1111;end;error;
repeat gettoken;until curtok=81057;end{:1391};
curlist.modefield:=oldmode;endtokenlist{:1390};oldsetting:=selector;
j:=mem[p+1].hh.lh;
if j=18 then selector:=21 else if writeopen[j]then selector:=j else
begin if(j=17)and(selector=19)then selector:=18;printnl(343);end;
tokenshow(defref);println;flushlist(defref);
if j=18 then begin if(eqtb[28960].int<=0)then selector:=18 else selector
:=19;if not logopened then selector:=17;printnl(1434);
for d:=0 to(poolptr-strstart[strptr])-1 do begin print(strpool[strstart[
strptr]+d]);end;print(1435);
if shellenabledp then begin begin if poolptr+1>poolsize then overflow(
258,poolsize-initpoolptr);end;begin strpool[poolptr]:=0;incr(poolptr);
end;clobbered:=false;
for d:=0 to(poolptr-strstart[strptr])-1 do begin strpool[strstart[strptr
]+d]:=xchr[strpool[strstart[strptr]+d]];
if(strpool[strstart[strptr]+d]=0)and(d<(poolptr-strstart[strptr])-1)then
clobbered:=true;end;
if clobbered then print(1436)else begin runsystemret:=runsystem(
conststringcast(addressof(strpool[strstart[strptr]])));
if runsystemret=-1 then print(1437)else if runsystemret=0 then print(
1438)else if runsystemret=1 then print(1439)else if runsystemret=2 then
print(1440)end;end else begin print(1441);end;printchar(46);
printnl(343);println;poolptr:=strstart[strptr];end;selector:=oldsetting;
end;{:1389}{1392:}procedure outwhat(p:halfword);var j:smallnumber;
oldsetting:0..21;
begin case mem[p].hh.b1 of 0,1,2:{1393:}if not doingleaders then begin j
:=mem[p+1].hh.lh;
if mem[p].hh.b1=1 then writeout(p)else begin if writeopen[j]then aclose(
writefile[j]);
if mem[p].hh.b1=2 then writeopen[j]:=false else if j<16 then begin
curname:=mem[p+1].hh.rh;curarea:=mem[p+2].hh.lh;curext:=mem[p+2].hh.rh;
if curext=343 then curext:=881;packfilename(curname,curarea,curext);
while not kpseoutnameok(stringcast(nameoffile+1))or not aopenout(
writefile[j])do promptfilename(1445,881);writeopen[j]:=true;
if logopened then begin oldsetting:=selector;
if(eqtb[28960].int<=0)then selector:=18 else selector:=19;printnl(1446);
printint(j);print(1447);printfilename(curname,curarea,curext);
print(880);printnl(343);println;selector:=oldsetting;end;end;end;
end{:1393};3:specialout(p);4:;
6:{1743:}begin case dvidir of 4:begin pdflastxpos:=curh;
pdflastypos:=curv;end;3:begin pdflastxpos:=-curv;pdflastypos:=curh;end;
1:begin pdflastxpos:=curv;pdflastypos:=-curh;end;end;
pdflastxpos:=pdflastxpos+4736286;
case dvidir of 3,1:pdflastypos:=curpagewidth-pdflastypos-4736286;
4:pdflastypos:=curpageheight-pdflastypos-4736286;end;end{:1743};
others:confusion(1444)end;end;
{:1392}{1469:}function newedge(s:smallnumber;w:scaled):halfword;
var p:halfword;begin p:=getnode(3);mem[p].hh.b0:=16;mem[p].hh.b1:=s;
mem[p+1].int:=w;mem[p+2].int:=0;newedge:=p;end;
{:1469}{1473:}function reverse(thisbox,t:halfword;var curg:scaled;
var curglue:real):halfword;label 21,15,30;var l,la:halfword;
disp,disp2:scaled;disped:boolean;p:halfword;q:halfword;gorder:glueord;
gsign:0..2;gluetemp:real;m,n:halfword;
begin gorder:=mem[thisbox+5].hh.b1;gsign:=mem[thisbox+5].hh.b0;
disp:=revdisp;disped:=false;l:=t;p:=tempptr;m:=-268435455;n:=-268435455;
while true do begin while p<>-268435455 do{1478:}21:if(p>=himemmin)then
repeat f:=mem[p].hh.b0;c:=mem[p].hh.b1;
curh:=curh+fontinfo[widthbase[f]+fontinfo[charbase[f]+effectivechar(true
,f,c)].qqqq.b0].int;if fontdir[f]<>0 then begin q:=mem[p].hh.rh;la:=l;
l:=p;p:=mem[q].hh.rh;mem[q].hh.rh:=la;end else begin q:=mem[p].hh.rh;
mem[p].hh.rh:=l;l:=p;p:=q;end;
until not(p>=himemmin)else{1479:}begin q:=mem[p].hh.rh;
case mem[p].hh.b0 of 0,1,3,13:rulewd:=mem[p+1].int;
{1480:}12:begin g:=mem[p+1].hh.lh;rulewd:=mem[g+1].int-curg;
if gsign<>0 then begin if gsign=1 then begin if mem[g].hh.b0=gorder then
begin curglue:=curglue+mem[g+2].int;gluetemp:=mem[thisbox+6].gr*curglue;
if gluetemp>1000000000.0 then gluetemp:=1000000000.0 else if gluetemp<
-1000000000.0 then gluetemp:=-1000000000.0;curg:=round(gluetemp);end;
end else if mem[g].hh.b1=gorder then begin curglue:=curglue-mem[g+3].int
;gluetemp:=mem[thisbox+6].gr*curglue;
if gluetemp>1000000000.0 then gluetemp:=1000000000.0 else if gluetemp<
-1000000000.0 then gluetemp:=-1000000000.0;curg:=round(gluetemp);end;
end;rulewd:=rulewd+curg;
{1449:}if(((gsign=1)and(mem[g].hh.b0=gorder))or((gsign=2)and(mem[g].hh.
b1=gorder)))then begin begin if mem[g].hh.rh=-268435455 then freenode(g,
4)else decr(mem[g].hh.rh);end;
if mem[p].hh.b1<100 then begin mem[p].hh.b0:=13;mem[p+1].int:=rulewd;
end else begin g:=getnode(4);mem[g].hh.b0:=5;mem[g].hh.b1:=5;
mem[g+1].int:=rulewd;mem[g+2].int:=0;mem[g+3].int:=0;mem[p+1].hh.lh:=g;
end;end{:1449};end;{:1480}{1481:}8:begin flushnodelist(mem[p+1].hh.rh);
tempptr:=p;p:=getavail;mem[p]:=mem[tempptr+1];mem[p].hh.rh:=q;
freenode(tempptr,2);goto 21;end;
{:1481}{1482:}11:begin rulewd:=mem[p+1].int;
if odd(mem[p].hh.b1)then if mem[LRptr].hh.lh<>(4*(mem[p].hh.b1 div 4)+3)
then begin mem[p].hh.b0:=13;incr(LRproblems);
end else begin begin tempptr:=LRptr;LRptr:=mem[tempptr].hh.rh;
begin mem[tempptr].hh.rh:=avail;avail:=tempptr;
ifdef('STAT')decr(dynused);endif('STAT')end;end;
if n>-268435455 then begin decr(n);decr(mem[p].hh.b1);
end else begin mem[p].hh.b0:=13;
if m>-268435455 then decr(m)else{1483:}begin freenode(p,4);
mem[t].hh.rh:=q;mem[t+1].int:=rulewd;mem[t+2].int:=-curh-rulewd;goto 30;
end{:1483};end;end else begin begin tempptr:=getavail;
mem[tempptr].hh.lh:=(4*(mem[p].hh.b1 div 4)+3);
mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;end;
if(n>-268435455)or((mem[p].hh.b1 div 8)<>curdir)then begin incr(n);
incr(mem[p].hh.b1);end else begin mem[p].hh.b0:=13;incr(m);end;end;end;
{:1482}16:confusion(1514);5:begin disp2:=mem[p+1].int;
mem[p+1].int:=disp;disp:=disp2;if not disped then disped:=true;end;
others:goto 15 end;curh:=curh+rulewd;15:mem[p].hh.rh:=l;
if mem[p].hh.b0=13 then if(rulewd=0)or(l=-268435455)then begin freenode(
p,4);p:=l;end;l:=p;p:=q;end{:1479}{:1478};
if(t=-268435455)and(m=-268435455)and(n=-268435455)then goto 30;
p:=newmath(0,mem[LRptr].hh.lh);LRproblems:=LRproblems+10000;end;
30:if(l<>-268435455)and(mem[l].hh.b0<>5)then begin p:=getnode(2);
mem[p].hh.b0:=5;mem[p+1].int:=disp;mem[p].hh.rh:=l;reverse:=p;
end else reverse:=l;end;
{:1473}{1474:}{[1475:]function newsegment(s:smallnumber;
f:halfword):halfword;var p:halfword;begin p:=getnode(3);
mem[p].hh.b0:=16;mem[p].hh.b1:=s;mem[p+1].int:=0;mem[p+2].hh.lh:=f;
mem[p+2].hh.rh:=f;newsegment:=p;end;
[:1475][1477:]function haswhatsit(p:halfword):boolean;label 10;
begin p:=mem[p+5].hh.rh;haswhatsit:=true;
while p<>-268435455 do begin if not(p>=himemmin)then case mem[p].hh.b0
of 0,1:if haswhatsit(p)then goto 10;10:goto 10;others:end;
p:=mem[p].hh.rh;end;haswhatsit:=false;10:end;
[:1477]function reverse(thisbox,t:halfword;var curg:scaled;
var curglue:real):halfword;label 21,15,30;var l:halfword;p:halfword;
q:halfword;gorder:glueord;gsign:0..2;gluetemp:real;m,n:halfword;
begin gorder:=mem[thisbox+5].hh.b1;gsign:=mem[thisbox+5].hh.b0;
[1476:]begin end[:1476];l:=t;p:=tempptr;m:=-268435455;n:=-268435455;
while true do begin while p<>-268435455 do[1478:]21:if(p>=himemmin)then
repeat f:=mem[p].hh.b0;c:=mem[p].hh.b1;
curh:=curh+fontinfo[widthbase[f]+fontinfo[charbase[f]+effectivechar(true
,f,c)].qqqq.b0].int;if fontdir[f]<>0 then begin q:=mem[p].hh.rh;la:=l;
l:=p;p:=mem[q].hh.rh;mem[q].hh.rh:=la;end else begin q:=mem[p].hh.rh;
mem[p].hh.rh:=l;l:=p;p:=q;end;
until not(p>=himemmin)else[1479:]begin q:=mem[p].hh.rh;
case mem[p].hh.b0 of 0,1,3,13:rulewd:=mem[p+1].int;
[1480:]12:begin g:=mem[p+1].hh.lh;rulewd:=mem[g+1].int-curg;
if gsign<>0 then begin if gsign=1 then begin if mem[g].hh.b0=gorder then
begin curglue:=curglue+mem[g+2].int;gluetemp:=mem[thisbox+6].gr*curglue;
if gluetemp>1000000000.0 then gluetemp:=1000000000.0 else if gluetemp<
-1000000000.0 then gluetemp:=-1000000000.0;curg:=round(gluetemp);end;
end else if mem[g].hh.b1=gorder then begin curglue:=curglue-mem[g+3].int
;gluetemp:=mem[thisbox+6].gr*curglue;
if gluetemp>1000000000.0 then gluetemp:=1000000000.0 else if gluetemp<
-1000000000.0 then gluetemp:=-1000000000.0;curg:=round(gluetemp);end;
end;rulewd:=rulewd+curg;
[1449:]if(((gsign=1)and(mem[g].hh.b0=gorder))or((gsign=2)and(mem[g].hh.
b1=gorder)))then begin begin if mem[g].hh.rh=-268435455 then freenode(g,
4)else decr(mem[g].hh.rh);end;
if mem[p].hh.b1<100 then begin mem[p].hh.b0:=13;mem[p+1].int:=rulewd;
end else begin g:=getnode(4);mem[g].hh.b0:=5;mem[g].hh.b1:=5;
mem[g+1].int:=rulewd;mem[g+2].int:=0;mem[g+3].int:=0;mem[p+1].hh.lh:=g;
end;end[:1449];end;[:1480][1481:]8:begin flushnodelist(mem[p+1].hh.rh);
tempptr:=p;p:=getavail;mem[p]:=mem[tempptr+1];mem[p].hh.rh:=q;
freenode(tempptr,2);goto 21;end;
[:1481][1482:]11:begin rulewd:=mem[p+1].int;
if odd(mem[p].hh.b1)then if mem[LRptr].hh.lh<>(4*(mem[p].hh.b1 div 4)+3)
then begin mem[p].hh.b0:=13;incr(LRproblems);
end else begin begin tempptr:=LRptr;LRptr:=mem[tempptr].hh.rh;
begin mem[tempptr].hh.rh:=avail;avail:=tempptr;
ifdef('STAT')decr(dynused);endif('STAT')end;end;
if n>-268435455 then begin decr(n);decr(mem[p].hh.b1);
end else begin mem[p].hh.b0:=13;
if m>-268435455 then decr(m)else[1483:]begin freenode(p,4);
mem[t].hh.rh:=q;mem[t+1].int:=rulewd;mem[t+2].int:=-curh-rulewd;goto 30;
end[:1483];end;end else begin begin tempptr:=getavail;
mem[tempptr].hh.lh:=(4*(mem[p].hh.b1 div 4)+3);
mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;end;
if(n>-268435455)or((mem[p].hh.b1 div 8)<>curdir)then begin incr(n);
incr(mem[p].hh.b1);end else begin mem[p].hh.b0:=13;incr(m);end;end;end;
[:1482]16:confusion(1514);5:begin disp2:=mem[p+1].int;
mem[p+1].int:=disp;disp:=disp2;if not disped then disped:=true;end;
others:goto 15 end;curh:=curh+rulewd;15:mem[p].hh.rh:=l;
if mem[p].hh.b0=13 then if(rulewd=0)or(l=-268435455)then begin freenode(
p,4);p:=l;end;l:=p;p:=q;end[:1479][:1478];
if(t=-268435455)and(m=-268435455)and(n=-268435455)then goto 30;
p:=newmath(0,mem[LRptr].hh.lh);LRproblems:=LRproblems+10000;end;
30:reverse:=l;end;}{:1474}{1712:}procedure synchdir;var tmp:scaled;
begin case curdirhv of 4:if dvidir<>curdirhv then begin if curh<>dvih
then begin movement(curh-dvih,143);dvih:=curh;end;
if curv<>dviv then begin movement(curv-dviv,157);dviv:=curv;end;
begin dvibuf[dviptr]:=255;incr(dviptr);if dviptr=dvilimit then dviswap;
end;begin dvibuf[dviptr]:=0;incr(dviptr);
if dviptr=dvilimit then dviswap;end;dirused:=true;
case dvidir of 3:begin tmp:=curh;curh:=-curv;curv:=tmp end;
1:begin tmp:=curh;curh:=curv;curv:=-tmp end;end;dvih:=curh;dviv:=curv;
dvidir:=curdirhv;end;
3:if dvidir<>curdirhv then begin if curh<>dvih then begin movement(curh-
dvih,143);dvih:=curh;end;
if curv<>dviv then begin movement(curv-dviv,157);dviv:=curv;end;
begin dvibuf[dviptr]:=255;incr(dviptr);if dviptr=dvilimit then dviswap;
end;begin dvibuf[dviptr]:=1;incr(dviptr);
if dviptr=dvilimit then dviswap;end;dirused:=true;
case dvidir of 4:begin tmp:=curh;curh:=curv;curv:=-tmp end;
1:begin curv:=-curv;curh:=-curh;end;end;dvih:=curh;dviv:=curv;
dvidir:=curdirhv;end;
1:if dvidir<>curdirhv then begin if curh<>dvih then begin movement(curh-
dvih,143);dvih:=curh;end;
if curv<>dviv then begin movement(curv-dviv,157);dviv:=curv;end;
begin dvibuf[dviptr]:=255;incr(dviptr);if dviptr=dvilimit then dviswap;
end;begin dvibuf[dviptr]:=3;incr(dviptr);
if dviptr=dvilimit then dviswap;end;dirused:=true;
case dvidir of 4:begin tmp:=curh;curh:=-curv;curv:=tmp end;
3:begin curv:=-curv;curh:=-curh;end;end;dvih:=curh;dviv:=curv;
dvidir:=curdirhv;end;others:confusion(1589);end end;
{:1712}{1714:}function checkbox(boxp:halfword):boolean;label 30;
var p:halfword;flag:boolean;begin flag:=false;p:=boxp;
while p<>-268435455 do begin if(p>=himemmin)then repeat if findfirstchar
then begin firstchar:=p;findfirstchar:=false end;lastchar:=p;flag:=true;
if fontdir[mem[p].hh.b0]<>0 then p:=mem[p].hh.rh;p:=mem[p].hh.rh;
if p=-268435455 then goto 30;until not(p>=himemmin);
case mem[p].hh.b0 of 0:begin flag:=true;
if mem[p+4].int=0 then begin if checkbox(mem[p+5].hh.rh)then flag:=true;
end else if findfirstchar then findfirstchar:=false else lastchar:=
-268435455;end;8:if checkbox(mem[p+1].hh.rh)then flag:=true;
4,5,6,7,10,14:;
11:if(mem[p].hh.b1=0)or(mem[p].hh.b1=1)then begin if findfirstchar then
begin findfirstchar:=false;firstchar:=p;end;lastchar:=p;flag:=true;
end else;others:begin flag:=true;
if findfirstchar then findfirstchar:=false else lastchar:=-268435455;
end;end;p:=mem[p].hh.rh;end;30:checkbox:=flag;end;
{:1714}{1715:}procedure adjusthlist(p:halfword;pf:boolean);label 10;
var q,s,t,u,v,x,z:halfword;i,k:halfword;a:halfword;insertskip:0..2;
cx:KANJIcode;ax:ASCIIcode;doins:boolean;
begin if mem[p].hh.rh=-268435455 then goto 10;
if eqtb[26359].hh.rh>0 then begin deleteglueref(mem[p+7].hh.rh);
mem[p+7].hh.rh:=eqtb[24543].hh.rh;incr(mem[eqtb[24543].hh.rh].hh.rh);
end;if eqtb[26360].hh.rh>0 then begin deleteglueref(mem[p+7].hh.lh);
mem[p+7].hh.lh:=eqtb[24544].hh.rh;incr(mem[eqtb[24544].hh.rh].hh.rh);
end;u:=mem[p+7].hh.rh;incr(mem[u].hh.rh);s:=mem[p+7].hh.lh;
incr(mem[s].hh.rh);
if not(mem[p].hh.rh>=himemmin)and(mem[mem[p].hh.rh].hh.b0=12)and(mem[mem
[p].hh.rh].hh.b1=21)then begin v:=mem[p].hh.rh;
mem[p].hh.rh:=mem[v].hh.rh;
begin if mem[mem[v+1].hh.lh].hh.rh=-268435455 then freenode(mem[v+1].hh.
lh,4)else decr(mem[mem[v+1].hh.lh].hh.rh);end;freenode(v,2);end;i:=0;
insertskip:=0;p:=mem[p].hh.rh;v:=p;q:=p;
while p<>-268435455 do begin if(p>=himemmin)then begin repeat{1716:}if
fontdir[mem[p].hh.b0]<>0 then begin cx:=mem[mem[p].hh.rh].hh.lh;
if insertskip=1 then{1723:}begin begin x:=getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=1)then
doins:=false else doins:=true else doins:=true;end;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;end{:1723};
p:=mem[p].hh.rh;insertskip:=2;end else begin ax:=mem[p].hh.b1;
if insertskip=2 then{1724:}begin if(eqtb[26873+ax].hh.rh mod 2)=1 then
begin x:=getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=2)then
doins:=false else doins:=true else doins:=true;end else doins:=false;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;end{:1724};
if eqtb[26873+ax].hh.rh>=2 then insertskip:=1 else insertskip:=0;
end{:1716};q:=p;p:=mem[p].hh.rh;incr(i);
if(i>5)and pf then begin if(v>=himemmin)then if fontdir[mem[v].hh.b0]<>0
then v:=mem[v].hh.rh;v:=mem[v].hh.rh;end;until not(p>=himemmin);
end else begin case mem[p].hh.b0 of 0:{1717:}begin findfirstchar:=true;
firstchar:=-268435455;lastchar:=-268435455;
if mem[p+4].int=0 then begin if checkbox(mem[p+5].hh.rh)then begin if
firstchar<>-268435455 then{1718:}if mem[firstchar].hh.b0=11 then begin
ax:=48;
if insertskip=2 then{1724:}begin if(eqtb[26873+ax].hh.rh mod 2)=1 then
begin x:=getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=2)then
doins:=false else doins:=true else doins:=true;end else doins:=false;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;end{:1724};
end else if fontdir[mem[firstchar].hh.b0]<>0 then begin cx:=mem[mem[
firstchar].hh.rh].hh.lh;
if insertskip=1 then{1723:}begin begin x:=getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=1)then
doins:=false else doins:=true else doins:=true;end;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;
end{:1723}else if insertskip=2 then{1725:}begin z:=newglue(u);
mem[z].hh.b1:=16;mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;
end{:1725};end else begin ax:=mem[firstchar].hh.b1;
if insertskip=2 then{1724:}begin if(eqtb[26873+ax].hh.rh mod 2)=1 then
begin x:=getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=2)then
doins:=false else doins:=true else doins:=true;end else doins:=false;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;end{:1724};end;
{:1718};
if lastchar<>-268435455 then begin{1719:}if mem[lastchar].hh.b0=11 then
begin ax:=48;
if eqtb[26873+ax].hh.rh>=2 then insertskip:=1 else insertskip:=0;
end else if fontdir[mem[lastchar].hh.b0]<>0 then begin insertskip:=2;
cx:=mem[mem[lastchar].hh.rh].hh.lh;
if(mem[p].hh.rh>=himemmin)and(fontdir[mem[mem[p].hh.rh].hh.b0]<>0)then
begin{1726:}begin z:=newglue(u);mem[z].hh.b1:=16;
mem[z].hh.rh:=mem[p].hh.rh;mem[p].hh.rh:=z;p:=mem[z].hh.rh;q:=z;
end{:1726};p:=mem[p].hh.rh;end;end else begin ax:=mem[lastchar].hh.b1;
if eqtb[26873+ax].hh.rh>=2 then insertskip:=1 else insertskip:=0;end;
{:1719};end else insertskip:=0;end else insertskip:=0;
end else insertskip:=0;end{:1717};8:{1721:}begin t:=mem[p+1].hh.rh;
if(t>=himemmin)then begin ax:=mem[t].hh.b1;
if insertskip=2 then{1724:}begin if(eqtb[26873+ax].hh.rh mod 2)=1 then
begin x:=getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=2)then
doins:=false else doins:=true else doins:=true;end else doins:=false;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;end{:1724};
while mem[t].hh.rh<>-268435455 do t:=mem[t].hh.rh;
if(t>=himemmin)then begin ax:=mem[t].hh.b1;
if eqtb[26873+ax].hh.rh>=2 then insertskip:=1 else insertskip:=0;end;
end;end{:1721};
14,5:{1722:}begin if(mem[p].hh.rh>=himemmin)then begin q:=p;
p:=mem[p].hh.rh;
if fontdir[mem[p].hh.b0]<>0 then begin cx:=mem[mem[p].hh.rh].hh.lh;
if insertskip=1 then{1723:}begin begin x:=getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=1)then
doins:=false else doins:=true else doins:=true;end;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;
end{:1723}else if insertskip=2 then{1725:}begin z:=newglue(u);
mem[z].hh.b1:=16;mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;
end{:1725};p:=mem[p].hh.rh;insertskip:=2;
end else begin ax:=mem[p].hh.b1;
if insertskip=2 then{1724:}begin if(eqtb[26873+ax].hh.rh mod 2)=1 then
begin x:=getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=2)then
doins:=false else doins:=true else doins:=true;end else doins:=false;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;end{:1724};
if eqtb[26873+ax].hh.rh>=2 then insertskip:=1 else insertskip:=0;end;
end end{:1722};
13:if mem[p].hh.b1=1 then insertskip:=0 else if mem[p].hh.b1=2 then
begin if q=p then begin t:=mem[p].hh.rh;
if(t>=himemmin)then if fontdir[mem[t].hh.b0]<>0 then t:=mem[t].hh.rh;
p:=mem[mem[t].hh.rh].hh.rh;
if fontdir[mem[p].hh.b0]<>0 then begin p:=mem[p].hh.rh;insertskip:=2;
end else insertskip:=1;end else begin a:=p;t:=mem[p].hh.rh;
if(t>=himemmin)then if fontdir[mem[t].hh.b0]<>0 then t:=mem[t].hh.rh;
t:=mem[mem[t].hh.rh].hh.rh;mem[q].hh.rh:=t;p:=t;
{1716:}if fontdir[mem[p].hh.b0]<>0 then begin cx:=mem[mem[p].hh.rh].hh.
lh;if insertskip=1 then{1723:}begin begin x:=getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=1)then
doins:=false else doins:=true else doins:=true;end;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;end{:1723};
p:=mem[p].hh.rh;insertskip:=2;end else begin ax:=mem[p].hh.b1;
if insertskip=2 then{1724:}begin if(eqtb[26873+ax].hh.rh mod 2)=1 then
begin x:=getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=2)then
doins:=false else doins:=true else doins:=true;end else doins:=false;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;end{:1724};
if eqtb[26873+ax].hh.rh>=2 then insertskip:=1 else insertskip:=0;
end{:1716};incr(i);
if(i>5)and pf then begin if(v>=himemmin)then if fontdir[mem[v].hh.b0]<>0
then v:=mem[v].hh.rh;v:=mem[v].hh.rh;end;
if mem[q].hh.rh<>t then mem[mem[q].hh.rh].hh.rh:=a else mem[q].hh.rh:=a;
end;end;
11:{1720:}begin if(mem[p].hh.b1=0)and(insertskip=2)then begin ax:=48;
{1724:}begin if(eqtb[26873+ax].hh.rh mod 2)=1 then begin x:=
getinhibitpos(cx,1);
if x<>1000 then if(eqtb[27129+x].hh.b0=0)or(eqtb[27129+x].hh.b0=2)then
doins:=false else doins:=true else doins:=true;end else doins:=false;
if doins then begin z:=newglue(s);mem[z].hh.b1:=17;
mem[z].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=z;q:=z;end;end{:1724};
insertskip:=0;end else if mem[p].hh.b1=1 then begin ax:=48;
if eqtb[26873+ax].hh.rh>=2 then insertskip:=1 else insertskip:=0;
end else insertskip:=0;end{:1720};6,7,4,10:;others:insertskip:=0;end;
q:=p;p:=mem[p].hh.rh;end;end;
if not(q>=himemmin)and(mem[q].hh.b0=12)and(mem[q].hh.b1=21)then begin
begin if mem[mem[q+1].hh.lh].hh.rh=-268435455 then freenode(mem[q+1].hh.
lh,4)else decr(mem[mem[q+1].hh.lh].hh.rh);end;mem[q+1].hh.lh:=membot;
incr(mem[membot].hh.rh);end;deleteglueref(u);deleteglueref(s);
if(v<>-268435455)and pf and(i>5)then{1727:}begin q:=v;p:=mem[v].hh.rh;
if(v>=himemmin)and(fontdir[mem[v].hh.b0]<>0)then begin q:=p;
p:=mem[p].hh.rh;end;t:=q;s:=-268435455;
{1728:}while(p<>-268435455)do begin if(p>=himemmin)then begin if fontdir
[mem[p].hh.b0]<>0 then begin cx:=mem[mem[p].hh.rh].hh.lh;
i:=eqtb[26617+kcatcodekey(cx)].hh.rh;k:=0;
if(i=16)or(i=17)then begin t:=q;s:=p;end;p:=mem[p].hh.rh;q:=p;
end else begin k:=k+1;if k>1 then begin q:=p;s:=-268435455;end;end;
end else begin case mem[p].hh.b0 of 14,6,7,10,12,13,11,5:;
others:begin q:=p;s:=-268435455;end;end;end;p:=mem[p].hh.rh;end{:1728};
if s<>-268435455 then begin s:=mem[t].hh.rh;
if not(s>=himemmin)and(mem[s].hh.b0=14)then mem[s+1].int:=mem[s+1].int+
eqtb[28987].int else if eqtb[28987].int<>0 then begin s:=newpenalty(eqtb
[28987].int);mem[s].hh.b1:=1;mem[s].hh.rh:=mem[t].hh.rh;mem[t].hh.rh:=s;
t:=mem[s].hh.rh;
while(not(t>=himemmin))do begin if(mem[t].hh.b0=12)or(mem[t].hh.b0=13)
then goto 10;t:=mem[t].hh.rh;end;z:=newglue(u);mem[z].hh.b1:=16;
mem[z].hh.rh:=mem[s].hh.rh;mem[s].hh.rh:=z;end;end;end;{:1727};10:end;
{:1715}{1729:}procedure dirout;var thisbox:halfword;
begin thisbox:=tempptr;tempptr:=mem[thisbox+5].hh.rh;
if(mem[tempptr].hh.b0<>0)and(mem[tempptr].hh.b0<>1)then confusion(1590);
case((mem[thisbox].hh.b1)mod 8)of 4:case((mem[tempptr].hh.b1)mod 8)of 3:
begin curv:=curv-mem[thisbox+3].int;curh:=curh+mem[tempptr+2].int end;
1:begin curv:=curv+mem[thisbox+2].int;curh:=curh+mem[tempptr+3].int end;
end;
3:case((mem[tempptr].hh.b1)mod 8)of 4:begin curv:=curv+mem[thisbox+2].
int;curh:=curh+mem[tempptr+3].int end;
1:begin curv:=curv+mem[thisbox+2].int-mem[tempptr+3].int;
curh:=curh+mem[tempptr+1].int end;end;
1:case((mem[tempptr].hh.b1)mod 8)of 4:begin curv:=curv-mem[thisbox+3].
int;curh:=curh+mem[tempptr+2].int end;
3:begin curv:=curv+mem[thisbox+2].int-mem[tempptr+3].int;
curh:=curh+mem[tempptr+1].int end;end;end;
curdirhv:=((mem[tempptr].hh.b1)mod 8);
if mem[tempptr].hh.b0=1 then vlistout else hlistout;end;
{:1729}procedure hlistout;label 21,13,14,15,22,40;var baseline:scaled;
disp:scaled;savedir:eightbits;jc:KANJIcode;kspptr:halfword;
leftedge:scaled;saveh,savev:scaled;thisbox:halfword;gorder:glueord;
gsign:0..2;p:halfword;saveloc:integer;leaderbox:halfword;
leaderwd:scaled;lx:scaled;outerdoingleaders:boolean;edge:scaled;
prevp:halfword;gluetemp:real;curglue:real;curg:scaled;begin curg:=0;
curglue:=0.0;thisbox:=tempptr;gorder:=mem[thisbox+5].hh.b1;
gsign:=mem[thisbox+5].hh.b0;p:=mem[thisbox+5].hh.rh;
kspptr:=mem[thisbox+7].hh.rh;incr(curs);
if curs>0 then begin dvibuf[dviptr]:=141;incr(dviptr);
if dviptr=dvilimit then dviswap;end;if curs>maxpush then maxpush:=curs;
saveloc:=dvioffset+dviptr;synchdir;baseline:=curv;disp:=0;revdisp:=0;
prevp:=thisbox+5;
{1464:}if(eTeXmode=1)then begin{1460:}begin tempptr:=getavail;
mem[tempptr].hh.lh:=0;mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;
end{:1460};
if((mem[thisbox].hh.b1)div 8)=2 then if curdir=1 then begin curdir:=0;
curh:=curh-mem[thisbox+1].int;
end else mem[thisbox].hh.b1:=((mem[thisbox].hh.b1)mod 8)+8*(0);
if(curdir=1)and(((mem[thisbox].hh.b1)div 8)<>1)then{1471:}begin saveh:=
curh;tempptr:=p;p:=newkern(0);mem[p+2].int:=0;mem[prevp].hh.rh:=p;
curh:=0;mem[p].hh.rh:=reverse(thisbox,-268435455,curg,curglue);
mem[p+1].int:=-curh;curh:=saveh;
mem[thisbox].hh.b1:=((mem[thisbox].hh.b1)mod 8)+8*(1);end{:1471};
end{:1464};leftedge:=curh;{1668:}synctexhlist(thisbox);{:1668};
while p<>-268435455 do{637:}21:if(p>=himemmin)then begin if curh<>dvih
then begin movement(curh-dvih,143);dvih:=curh;end;
if curv<>dviv then begin movement(curv-dviv,157);dviv:=curv;end;
chain:=false;repeat f:=mem[p].hh.b0;c:=mem[p].hh.b1;
if f<>dvif then{638:}begin if not fontused[f]then begin dvifontdef(f);
fontused[f]:=true;end;if f<=64 then begin dvibuf[dviptr]:=f+170;
incr(dviptr);if dviptr=dvilimit then dviswap;
end else if f<=256 then begin begin dvibuf[dviptr]:=235;incr(dviptr);
if dviptr=dvilimit then dviswap;end;begin dvibuf[dviptr]:=f-1;
incr(dviptr);if dviptr=dvilimit then dviswap;end;
end else begin begin dvibuf[dviptr]:=236;incr(dviptr);
if dviptr=dvilimit then dviswap;end;begin dvibuf[dviptr]:=(f-1)div 256;
incr(dviptr);if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=(f-1)mod 256;incr(dviptr);
if dviptr=dvilimit then dviswap;end;end;dvif:=f;end{:638};
if fontdir[f]=0 then begin chain:=false;
if fontec[f]>=c then if fontbc[f]<=c then if(fontinfo[charbase[f]+c].
qqqq.b0>0)then begin if c>=128 then begin dvibuf[dviptr]:=128;
incr(dviptr);if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=c;incr(dviptr);if dviptr=dvilimit then dviswap;
end;
curh:=curh+fontinfo[widthbase[f]+fontinfo[charbase[f]+c].qqqq.b0].int;
goto 22;end;
if mltexenabledp then{1638:}begin{1640:}if c>=eqtb[28988].int then if c
<=eqtb[28989].int then if(eqtb[28675+c].hh.rh>0)then begin basec:=(eqtb[
28675+c].hh.rh mod 256);accentc:=(eqtb[28675+c].hh.rh div 256);
if(fontec[f]>=basec)then if(fontbc[f]<=basec)then if(fontec[f]>=accentc)
then if(fontbc[f]<=accentc)then begin iac:=fontinfo[charbase[f]+
effectivechar(true,f,accentc)].qqqq;
ibc:=fontinfo[charbase[f]+effectivechar(true,f,basec)].qqqq;
if(ibc.b0>0)then if(iac.b0>0)then goto 40;end;begindiagnostic;
printnl(1557);print(c);print(1328);print(accentc);print(32);
print(basec);print(918);slowprint(fontname[f]);printchar(33);
enddiagnostic(false);goto 22;end;begindiagnostic;printnl(917);
print(1556);print(c);print(918);slowprint(fontname[f]);printchar(33);
enddiagnostic(false);goto 22{:1640};
40:{1641:}if eqtb[28966].int>99 then begin begindiagnostic;
printnl(1558);print(c);print(1328);print(accentc);print(32);
print(basec);print(918);slowprint(fontname[f]);printchar(46);
enddiagnostic(false);end{:1641};
{1642:}basexheight:=fontinfo[5+parambase[f]].int;
baseslant:=fontinfo[1+parambase[f]].int/65536.0;accentslant:=baseslant;
basewidth:=fontinfo[widthbase[f]+ibc.b0].int;
baseheight:=fontinfo[heightbase[f]+(ibc.b1)div 16].int;
accentwidth:=fontinfo[widthbase[f]+iac.b0].int;
accentheight:=fontinfo[heightbase[f]+(iac.b1)div 16].int;
delta:=round((basewidth-accentwidth)/2.0+baseheight*baseslant-
basexheight*accentslant);dvih:=curh;curh:=curh+delta;
if curh<>dvih then begin movement(curh-dvih,143);dvih:=curh;end;
if((baseheight<>basexheight)and(accentheight>0))then begin curv:=
baseline+(basexheight-baseheight);
if curv<>dviv then begin movement(curv-dviv,157);dviv:=curv;end;
if accentc>=128 then begin dvibuf[dviptr]:=128;incr(dviptr);
if dviptr=dvilimit then dviswap;end;begin dvibuf[dviptr]:=accentc;
incr(dviptr);if dviptr=dvilimit then dviswap;end;curv:=baseline;
end else begin if curv<>dviv then begin movement(curv-dviv,157);
dviv:=curv;end;if accentc>=128 then begin dvibuf[dviptr]:=128;
incr(dviptr);if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=accentc;incr(dviptr);
if dviptr=dvilimit then dviswap;end;end;curh:=curh+accentwidth;
dvih:=curh;curh:=curh+(-accentwidth-delta);
if curh<>dvih then begin movement(curh-dvih,143);dvih:=curh;end;
if curv<>dviv then begin movement(curv-dviv,157);dviv:=curv;end;
if basec>=128 then begin dvibuf[dviptr]:=128;incr(dviptr);
if dviptr=dvilimit then dviswap;end;begin dvibuf[dviptr]:=basec;
incr(dviptr);if dviptr=dvilimit then dviswap;end;curh:=curh+basewidth;
dvih:=curh{:1642};end{:1638};
22:end else begin if chain=false then chain:=true else begin curh:=curh+
mem[kspptr+1].int;
if gsign<>0 then begin if gsign=1 then begin if mem[kspptr].hh.b0=gorder
then curh:=curh+round(mem[thisbox+6].gr*mem[kspptr+2].int);
end else begin if mem[kspptr].hh.b1=gorder then curh:=curh-round(mem[
thisbox+6].gr*mem[kspptr+3].int);end;end;
if curh<>dvih then begin movement(curh-dvih,143);dvih:=curh;end;end;
prevp:=mem[prevp].hh.rh;p:=mem[p].hh.rh;jc:=toDVI(mem[p].hh.lh);
begin dvibuf[dviptr]:=129;incr(dviptr);if dviptr=dvilimit then dviswap;
end;begin dvibuf[dviptr]:=Hi(jc);incr(dviptr);
if dviptr=dvilimit then dviswap;end;begin dvibuf[dviptr]:=Lo(jc);
incr(dviptr);if dviptr=dvilimit then dviswap;end;
curh:=curh+fontinfo[widthbase[f]+fontinfo[charbase[f]+c].qqqq.b0].int;
end;dvih:=curh;p:=mem[p].hh.rh;until not(p>=himemmin);
{1671:}synctexcurrent;{:1671};chain:=false;
end else{639:}begin case mem[p].hh.b0 of 0,1,2:{640:}if mem[p+5].hh.rh=
-268435455 then begin if mem[p].hh.b0<>2 then{1670:}if mem[p].hh.b0=1
then begin synctexvoidvlist(p,thisbox);
end else begin synctexvoidhlist(p,thisbox);end;{:1670};
curh:=curh+mem[p+1].int;end else begin saveh:=dvih;savev:=dviv;
savedir:=dvidir;curv:=baseline+disp+mem[p+4].int;tempptr:=p;
edge:=curh+mem[p+1].int;if curdir=1 then curh:=edge;
case mem[p].hh.b0 of 0:hlistout;1:vlistout;2:dirout;end;dvih:=saveh;
dviv:=savev;dvidir:=savedir;curh:=edge;curv:=baseline+disp;
curdirhv:=savedir;end{:640};3:begin ruleht:=mem[p+3].int;
ruledp:=mem[p+2].int;rulewd:=mem[p+1].int;goto 14;end;
10:{1386:}outwhat(p){:1386};5:begin disp:=mem[p+1].int;revdisp:=disp;
curv:=baseline+disp;end;12:{642:}begin g:=mem[p+1].hh.lh;
rulewd:=mem[g+1].int-curg;
if gsign<>0 then begin if gsign=1 then begin if mem[g].hh.b0=gorder then
begin curglue:=curglue+mem[g+2].int;gluetemp:=mem[thisbox+6].gr*curglue;
if gluetemp>1000000000.0 then gluetemp:=1000000000.0 else if gluetemp<
-1000000000.0 then gluetemp:=-1000000000.0;curg:=round(gluetemp);end;
end else if mem[g].hh.b1=gorder then begin curglue:=curglue-mem[g+3].int
;gluetemp:=mem[thisbox+6].gr*curglue;
if gluetemp>1000000000.0 then gluetemp:=1000000000.0 else if gluetemp<
-1000000000.0 then gluetemp:=-1000000000.0;curg:=round(gluetemp);end;
end;rulewd:=rulewd+curg;
if(eTeXmode=1)then{1449:}if(((gsign=1)and(mem[g].hh.b0=gorder))or((gsign
=2)and(mem[g].hh.b1=gorder)))then begin begin if mem[g].hh.rh=-268435455
then freenode(g,4)else decr(mem[g].hh.rh);end;
if mem[p].hh.b1<100 then begin mem[p].hh.b0:=13;mem[p+1].int:=rulewd;
end else begin g:=getnode(4);mem[g].hh.b0:=5;mem[g].hh.b1:=5;
mem[g+1].int:=rulewd;mem[g+2].int:=0;mem[g+3].int:=0;mem[p+1].hh.lh:=g;
end;end{:1449};
if mem[p].hh.b1>=100 then{643:}begin leaderbox:=mem[p+1].hh.rh;
if mem[leaderbox].hh.b0=3 then begin ruleht:=mem[leaderbox+3].int;
ruledp:=mem[leaderbox+2].int;goto 14;end;leaderwd:=mem[leaderbox+1].int;
if(leaderwd>0)and(rulewd>0)then begin rulewd:=rulewd+10;
if curdir=1 then curh:=curh-10;edge:=curh+rulewd;lx:=0;
{644:}if mem[p].hh.b1=100 then begin saveh:=curh;
curh:=leftedge+leaderwd*((curh-leftedge)div leaderwd);
if curh<saveh then curh:=curh+leaderwd;
end else begin lq:=rulewd div leaderwd;lr:=rulewd mod leaderwd;
if mem[p].hh.b1=101 then curh:=curh+(lr div 2)else begin lx:=lr div(lq+1
);curh:=curh+((lr-(lq-1)*lx)div 2);end;end{:644};
while curh+leaderwd<=edge do{645:}begin curv:=baseline+disp+mem[
leaderbox+4].int;if curv<>dviv then begin movement(curv-dviv,157);
dviv:=curv;end;savev:=dviv;
if curh<>dvih then begin movement(curh-dvih,143);dvih:=curh;end;
saveh:=dvih;savedir:=dvidir;tempptr:=leaderbox;
if curdir=1 then curh:=curh+leaderwd;outerdoingleaders:=doingleaders;
doingleaders:=true;case mem[leaderbox].hh.b0 of 0:hlistout;1:vlistout;
2:dirout;end;doingleaders:=outerdoingleaders;dviv:=savev;dvih:=saveh;
dvidir:=savedir;curv:=baseline;curh:=saveh+leaderwd+lx;
curdirhv:=savedir;end{:645};
if curdir=1 then curh:=edge else curh:=edge-10;goto 15;end;end{:643};
goto 13;end{:642};13:begin{1673:}synctexkern(p,thisbox);{:1673};
curh:=curh+mem[p+1].int;end;11:begin{1674:}synctexmath(p,thisbox);
{:1674};
{1466:}begin if(eTeXmode=1)then{1467:}begin if odd(mem[p].hh.b1)then if
mem[LRptr].hh.lh=(4*(mem[p].hh.b1 div 4)+3)then begin tempptr:=LRptr;
LRptr:=mem[tempptr].hh.rh;begin mem[tempptr].hh.rh:=avail;
avail:=tempptr;ifdef('STAT')decr(dynused);endif('STAT')end;
end else begin if mem[p].hh.b1>4 then incr(LRproblems);
end else begin begin tempptr:=getavail;
mem[tempptr].hh.lh:=(4*(mem[p].hh.b1 div 4)+3);
mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;end;
if(mem[p].hh.b1 div 8)<>curdir then{1472:}begin saveh:=curh;
tempptr:=mem[p].hh.rh;rulewd:=mem[p+1].int;freenode(p,4);
curdir:=1-curdir;p:=newedge(curdir,rulewd);mem[prevp].hh.rh:=p;
curh:=curh-leftedge+rulewd;
mem[p].hh.rh:=reverse(thisbox,newedge(1-curdir,0),curg,curglue);
mem[p+2].int:=curh;curdir:=1-curdir;curh:=saveh;goto 21;end{:1472};end;
mem[p].hh.b0:=13;end{:1467};curh:=curh+mem[p+1].int;end{:1466};end;
8:{669:}begin mem[memtop-12]:=mem[p+1];
mem[memtop-12].hh.rh:=mem[p].hh.rh;p:=memtop-12;goto 21;end{:669};
{1470:}16:begin curh:=curh+mem[p+1].int;leftedge:=curh+mem[p+2].int;
curdir:=mem[p].hh.b1;end;{:1470}others:end;goto 15;
14:{641:}if(ruleht=-1073741824)then ruleht:=mem[thisbox+3].int+disp;
if(ruledp=-1073741824)then ruledp:=mem[thisbox+2].int-disp;
ruleht:=ruleht+ruledp;
if(ruleht>0)and(rulewd>0)then begin if curh<>dvih then begin movement(
curh-dvih,143);dvih:=curh;end;curv:=baseline+ruledp;
if curv<>dviv then begin movement(curv-dviv,157);dviv:=curv;end;
begin dvibuf[dviptr]:=132;incr(dviptr);if dviptr=dvilimit then dviswap;
end;dvifour(ruleht);dvifour(rulewd);curv:=baseline;dvih:=dvih+rulewd;
end{:641};13:begin curh:=curh+rulewd;
{1672:}synctexhorizontalruleorglue(p,thisbox);{:1672};end;15:prevp:=p;
p:=mem[p].hh.rh;end{:639}{:637};{1669:}synctextsilh(thisbox);{:1669};
{1465:}if(eTeXmode=1)then begin{1468:}begin while mem[LRptr].hh.lh<>0 do
begin if mem[LRptr].hh.lh>4 then LRproblems:=LRproblems+10000;
begin tempptr:=LRptr;LRptr:=mem[tempptr].hh.rh;
begin mem[tempptr].hh.rh:=avail;avail:=tempptr;
ifdef('STAT')decr(dynused);endif('STAT')end;end;end;
begin tempptr:=LRptr;LRptr:=mem[tempptr].hh.rh;
begin mem[tempptr].hh.rh:=avail;avail:=tempptr;
ifdef('STAT')decr(dynused);endif('STAT')end;end;end{:1468};
if((mem[thisbox].hh.b1)div 8)=2 then curdir:=1;end{:1465};
prunemovements(saveloc);if curs>0 then dvipop(saveloc);decr(curs);end;
{:636}{646:}procedure vlistout;label 13,14,15;var leftedge:scaled;
topedge:scaled;saveh,savev:scaled;thisbox:halfword;gorder:glueord;
gsign:0..2;p:halfword;saveloc:integer;leaderbox:halfword;
leaderht:scaled;lx:scaled;outerdoingleaders:boolean;edge:scaled;
gluetemp:real;curglue:real;curg:scaled;savedir:integer;begin curg:=0;
curglue:=0.0;thisbox:=tempptr;gorder:=mem[thisbox+5].hh.b1;
gsign:=mem[thisbox+5].hh.b0;p:=mem[thisbox+5].hh.rh;incr(curs);
if curs>0 then begin dvibuf[dviptr]:=141;incr(dviptr);
if dviptr=dvilimit then dviswap;end;if curs>maxpush then maxpush:=curs;
saveloc:=dvioffset+dviptr;synchdir;leftedge:=curh;
{1666:}synctexvlist(thisbox);{:1666};curv:=curv-mem[thisbox+3].int;
topedge:=curv;
while p<>-268435455 do{647:}begin if(p>=himemmin)then confusion(921)else
{648:}begin case mem[p].hh.b0 of 0,1,2:{649:}if mem[p+5].hh.rh=
-268435455 then begin curv:=curv+mem[p+3].int;
if mem[p].hh.b0<>2 then{1670:}if mem[p].hh.b0=1 then begin
synctexvoidvlist(p,thisbox);end else begin synctexvoidhlist(p,thisbox);
end;{:1670};curv:=curv+mem[p+2].int;
end else begin curv:=curv+mem[p+3].int;
if curv<>dviv then begin movement(curv-dviv,157);dviv:=curv;end;
saveh:=dvih;savev:=dviv;savedir:=dvidir;
if curdir=1 then curh:=leftedge-mem[p+4].int else curh:=leftedge+mem[p+4
].int;tempptr:=p;case mem[p].hh.b0 of 0:hlistout;1:vlistout;2:dirout;
end;dvih:=saveh;dviv:=savev;dvidir:=savedir;curv:=savev+mem[p+2].int;
curh:=leftedge;curdirhv:=savedir;end{:649};3:begin ruleht:=mem[p+3].int;
ruledp:=mem[p+2].int;rulewd:=mem[p+1].int;goto 14;end;
10:{1385:}outwhat(p){:1385};12:{651:}begin g:=mem[p+1].hh.lh;
ruleht:=mem[g+1].int-curg;
if gsign<>0 then begin if gsign=1 then begin if mem[g].hh.b0=gorder then
begin curglue:=curglue+mem[g+2].int;gluetemp:=mem[thisbox+6].gr*curglue;
if gluetemp>1000000000.0 then gluetemp:=1000000000.0 else if gluetemp<
-1000000000.0 then gluetemp:=-1000000000.0;curg:=round(gluetemp);end;
end else if mem[g].hh.b1=gorder then begin curglue:=curglue-mem[g+3].int
;gluetemp:=mem[thisbox+6].gr*curglue;
if gluetemp>1000000000.0 then gluetemp:=1000000000.0 else if gluetemp<
-1000000000.0 then gluetemp:=-1000000000.0;curg:=round(gluetemp);end;
end;ruleht:=ruleht+curg;
if mem[p].hh.b1>=100 then{652:}begin leaderbox:=mem[p+1].hh.rh;
if mem[leaderbox].hh.b0=3 then begin rulewd:=mem[leaderbox+1].int;
ruledp:=0;goto 14;end;
leaderht:=mem[leaderbox+3].int+mem[leaderbox+2].int;
if(leaderht>0)and(ruleht>0)then begin ruleht:=ruleht+10;
edge:=curv+ruleht;lx:=0;
{653:}if mem[p].hh.b1=100 then begin savev:=curv;
curv:=topedge+leaderht*((curv-topedge)div leaderht);
if curv<savev then curv:=curv+leaderht;
end else begin lq:=ruleht div leaderht;lr:=ruleht mod leaderht;
if mem[p].hh.b1=101 then curv:=curv+(lr div 2)else begin lx:=lr div(lq+1
);curv:=curv+((lr-(lq-1)*lx)div 2);end;end{:653};
while curv+leaderht<=edge do{654:}begin if curdir=1 then curh:=leftedge-
mem[leaderbox+4].int else curh:=leftedge+mem[leaderbox+4].int;
if curh<>dvih then begin movement(curh-dvih,143);dvih:=curh;end;
saveh:=dvih;curv:=curv+mem[leaderbox+3].int;
if curv<>dviv then begin movement(curv-dviv,157);dviv:=curv;end;
savev:=dviv;savedir:=dvidir;tempptr:=leaderbox;
outerdoingleaders:=doingleaders;doingleaders:=true;
case mem[leaderbox].hh.b0 of 0:hlistout;1:vlistout;2:dirout;end;
doingleaders:=outerdoingleaders;dviv:=savev;dvih:=saveh;dvidir:=savedir;
curh:=leftedge;curv:=savev-mem[leaderbox+3].int+leaderht+lx;
curdirhv:=savedir;end{:654};curv:=edge-10;goto 15;end;end{:652};goto 13;
end{:651};13:curv:=curv+mem[p+1].int;others:end;goto 15;
14:{650:}if(rulewd=-1073741824)then rulewd:=mem[thisbox+1].int;
ruleht:=ruleht+ruledp;curv:=curv+ruleht;
if(ruleht>0)and(rulewd>0)then begin if curdir=1 then curh:=curh-rulewd;
if curh<>dvih then begin movement(curh-dvih,143);dvih:=curh;end;
if curv<>dviv then begin movement(curv-dviv,157);dviv:=curv;end;
begin dvibuf[dviptr]:=137;incr(dviptr);if dviptr=dvilimit then dviswap;
end;dvifour(ruleht);dvifour(rulewd);curh:=leftedge;end;goto 15{:650};
13:curv:=curv+ruleht;end{:648};15:p:=mem[p].hh.rh;end{:647};
{1667:}synctextsilv(thisbox);{:1667};prunemovements(saveloc);
if curs>0 then dvipop(saveloc);decr(curs);end;
{:646}{655:}procedure shipout(p:halfword);label 30;var pageloc:integer;
delnode:halfword;j,k:0..9;s:poolpointer;oldsetting:0..21;t:scaled;
begin{1664:}synctexsheet(eqtb[28948].int);{:1664};
begin if eqtb[28965].int>0 then begin printnl(343);println;print(922);
end;if termoffset>maxprintline-9 then println else if(termoffset>0)or(
fileoffset>0)then printchar(32);printchar(91);j:=9;
while(eqtb[29002+j].int=0)and(j>0)do decr(j);
for k:=0 to j do begin printint(eqtb[29002+k].int);
if k<j then printchar(46);end;fflush(stdout);
if eqtb[28965].int>0 then begin printchar(93);begindiagnostic;
showbox(p);enddiagnostic(true);end;
if mem[p].hh.b0=2 then begin delnode:=p;p:=mem[p+5].hh.rh;
deleteglueref(mem[delnode+7].hh.rh);deleteglueref(mem[delnode+7].hh.lh);
freenode(delnode,10);end;flushnodelist(mem[p].hh.rh);
mem[p].hh.rh:=-268435455;
if((mem[p].hh.b1)mod 8)<>4 then p:=newdirnode(p,4);
{657:}{658:}if(mem[p+3].int>1073741823)or(mem[p+2].int>1073741823)or(mem
[p+3].int+mem[p+2].int+eqtb[29533].int>1073741823)or(mem[p+1].int+eqtb[
29532].int>1073741823)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(926);
end;begin helpptr:=2;helpline[1]:=927;helpline[0]:=928;end;error;
if eqtb[28965].int<=0 then begin begindiagnostic;printnl(929);
showbox(p);enddiagnostic(true);end;goto 30;end;
if mem[p+3].int+mem[p+2].int+eqtb[29533].int>maxv then maxv:=mem[p+3].
int+mem[p+2].int+eqtb[29533].int;
if mem[p+1].int+eqtb[29532].int>maxh then maxh:=mem[p+1].int+eqtb[29532]
.int{:658};
{634:}{1744:}if eqtb[29538].int<>0 then curpageheight:=eqtb[29538].int
else curpageheight:=mem[p+3].int+mem[p+2].int+2*eqtb[29533].int+2
*4736286;if eqtb[29537].int<>0 then curpagewidth:=eqtb[29537].int else
curpagewidth:=mem[p+1].int+2*eqtb[29532].int+2*4736286;
if(mem[p].hh.b0=2)then if(((mem[mem[p+5].hh.rh].hh.b1)mod 8)=3)or(((mem[
mem[p+5].hh.rh].hh.b1)mod 8)=1)then begin t:=curpageheight;
curpageheight:=curpagewidth;curpagewidth:=t;end;{:1744};dvih:=0;dviv:=0;
curh:=eqtb[29532].int;dvif:=0;dvidir:=4;curdirhv:=dvidir;
if outputfilename=0 then begin if jobname=0 then openlogfile;
packjobname(885);while not bopenout(dvifile)do promptfilename(886,885);
outputfilename:=bmakenamestring(dvifile);end;
if totalpages=0 then begin begin dvibuf[dviptr]:=247;incr(dviptr);
if dviptr=dvilimit then dviswap;end;begin dvibuf[dviptr]:=2;
incr(dviptr);if dviptr=dvilimit then dviswap;end;dvifour(25400000);
dvifour(473628672);preparemag;dvifour(eqtb[28948].int);
if outputcomment then begin l:=strlen(outputcomment);
begin dvibuf[dviptr]:=l;incr(dviptr);if dviptr=dvilimit then dviswap;
end;for s:=0 to l-1 do begin dvibuf[dviptr]:=outputcomment[s];
incr(dviptr);if dviptr=dvilimit then dviswap;end;
end else begin oldsetting:=selector;selector:=21;print(920);
printint(eqtb[28954].int);printchar(46);printtwo(eqtb[28953].int);
printchar(46);printtwo(eqtb[28952].int);printchar(58);
printtwo(eqtb[28951].int div 60);printtwo(eqtb[28951].int mod 60);
selector:=oldsetting;begin dvibuf[dviptr]:=(poolptr-strstart[strptr]);
incr(dviptr);if dviptr=dvilimit then dviswap;end;
for s:=strstart[strptr]to poolptr-1 do begin dvibuf[dviptr]:=strpool[s];
incr(dviptr);if dviptr=dvilimit then dviswap;end;
poolptr:=strstart[strptr];end;end{:634};pageloc:=dvioffset+dviptr;
begin dvibuf[dviptr]:=139;incr(dviptr);if dviptr=dvilimit then dviswap;
end;for k:=0 to 9 do dvifour(eqtb[29002+k].int);dvifour(lastbop);
lastbop:=pageloc;curv:=mem[p+3].int+eqtb[29533].int;tempptr:=p;
case mem[p].hh.b0 of 0:hlistout;1:vlistout;2:dirout;end;
begin dvibuf[dviptr]:=140;incr(dviptr);if dviptr=dvilimit then dviswap;
end;incr(totalpages);curs:=-1;
ifdef('IPC')if ipcon>0 then begin if dvilimit=halfbuf then begin
writedvi(halfbuf,dvibufsize-1);flushdvi;dvigone:=dvigone+halfbuf;end;
if dviptr>(2147483647-dvioffset)then begin curs:=-2;fatalerror(919);end;
if dviptr>0 then begin writedvi(0,dviptr-1);flushdvi;
dvioffset:=dvioffset+dviptr;dvigone:=dvigone+dviptr;end;dviptr:=0;
dvilimit:=dvibufsize;ipcpage(dvigone);end;endif('IPC');30:{:657};
if(eTeXmode=1)then{1484:}begin if LRproblems>0 then begin{1463:}begin
println;printnl(1511);printint(LRproblems div 10000);print(1512);
printint(LRproblems mod 10000);print(1513);LRproblems:=0;end{:1463};
printchar(41);println;end;
if(LRptr<>-268435455)or(curdir<>0)then confusion(1515);end{:1484};
if eqtb[28965].int<=0 then printchar(93);deadcycles:=0;fflush(stdout);
{656:}ifdef('STAT')if eqtb[28962].int>1 then begin printnl(923);
printint(varused);printchar(38);printint(dynused);printchar(59);end;
endif('STAT')flushnodelist(p);
ifdef('STAT')if eqtb[28962].int>1 then begin print(924);
printint(varused);printchar(38);printint(dynused);print(925);
printint(himemmin-lomemmax-1);println;end;endif('STAT'){:656};end;
{1665:}synctexteehs;{:1665};end;
{:655}{662:}procedure scanspec(c:groupcode;threecodes:boolean);label 40;
var s:integer;speccode:0..1;
begin if threecodes then s:=savestack[saveptr+0].int;
if scankeyword(935)then speccode:=0 else if scankeyword(936)then
speccode:=1 else begin speccode:=1;curval:=0;goto 40;end;
scandimen(false,false,false);
40:if threecodes then begin savestack[saveptr+0].int:=s;incr(saveptr);
end;savestack[saveptr+0].int:=speccode;savestack[saveptr+1].int:=curval;
saveptr:=saveptr+2;newsavelevel(c);scanleftbrace;end;
{:662}{666:}function hpack(p:halfword;w:scaled;m:smallnumber):halfword;
label 21,50,10;var r:halfword;k:halfword;disp:scaled;q:halfword;
h,d,x:scaled;s:scaled;g:halfword;o:glueord;f:internalfontnumber;
i:fourquarters;hd:eightbits;begin lastbadness:=0;r:=getnode(10);
mem[r].hh.b0:=0;mem[r].hh.b1:=0;mem[r+4].int:=0;
mem[r+7].hh.rh:=curkanjiskip;mem[r+7].hh.lh:=curxkanjiskip;
incr(mem[curkanjiskip].hh.rh);incr(mem[curxkanjiskip].hh.rh);
k:=curkanjiskip;q:=r+5;mem[q].hh.rh:=p;h:=0;{667:}d:=0;x:=0;
totalstretch[0]:=0;totalshrink[0]:=0;totalstretch[1]:=0;
totalshrink[1]:=0;totalstretch[2]:=0;totalshrink[2]:=0;
totalstretch[3]:=0;totalshrink[3]:=0;totalstretch[4]:=0;
totalshrink[4]:=0{:667};disp:=0;
if(eqtb[29001].int>0)then{1460:}begin tempptr:=getavail;
mem[tempptr].hh.lh:=0;mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;
end{:1460};while p<>-268435455 do{668:}begin 21:chain:=false;
while(p>=himemmin)do{671:}begin f:=mem[p].hh.b0;
i:=fontinfo[charbase[f]+effectivechar(true,f,mem[p].hh.b1)].qqqq;
hd:=i.b1;x:=x+fontinfo[widthbase[f]+i.b0].int;
s:=fontinfo[heightbase[f]+(hd)div 16].int-disp;if s>h then h:=s;
s:=fontinfo[depthbase[f]+(hd)mod 16].int+disp;if s>d then d:=s;
if fontdir[f]<>0 then begin p:=mem[p].hh.rh;
if chain then begin x:=x+mem[k+1].int;o:=mem[k].hh.b0;
totalstretch[o]:=totalstretch[o]+mem[k+2].int;o:=mem[k].hh.b1;
totalshrink[o]:=totalshrink[o]+mem[k+3].int;end else chain:=true;
end else chain:=false;p:=mem[p].hh.rh;end{:671};
if p<>-268435455 then begin case mem[p].hh.b0 of 0,1,2,3,15:{670:}begin
x:=x+mem[p+1].int;
if mem[p].hh.b0>=3 then s:=disp else s:=mem[p+4].int+disp;
if mem[p+3].int-s>h then h:=mem[p+3].int-s;
if mem[p+2].int+s>d then d:=mem[p+2].int+s;end{:670};
4,6,7:if adjusttail<>-268435455 then{672:}begin while mem[q].hh.rh<>p do
q:=mem[q].hh.rh;
if mem[p].hh.b0=7 then begin mem[adjusttail].hh.rh:=mem[p+1].int;
while mem[adjusttail].hh.rh<>-268435455 do adjusttail:=mem[adjusttail].
hh.rh;p:=mem[p].hh.rh;freenode(mem[q].hh.rh,2);
end else begin mem[adjusttail].hh.rh:=p;adjusttail:=p;p:=mem[p].hh.rh;
end;mem[q].hh.rh:=p;p:=q;end{:672};10:{1379:}{:1379};
5:begin disp:=mem[p+1].int;revdisp:=disp;end;
12:{673:}begin g:=mem[p+1].hh.lh;x:=x+mem[g+1].int;o:=mem[g].hh.b0;
totalstretch[o]:=totalstretch[o]+mem[g+2].int;o:=mem[g].hh.b1;
totalshrink[o]:=totalshrink[o]+mem[g+3].int;
if mem[p].hh.b1>=100 then begin g:=mem[p+1].hh.rh;
if mem[g+3].int>h then h:=mem[g+3].int;
if mem[g+2].int>d then d:=mem[g+2].int;end;end{:673};
13:x:=x+mem[p+1].int;11:begin x:=x+mem[p+1].int;
if(eqtb[29001].int>0)then{1461:}if odd(mem[p].hh.b1)then if mem[LRptr].
hh.lh=(4*(mem[p].hh.b1 div 4)+3)then begin tempptr:=LRptr;
LRptr:=mem[tempptr].hh.rh;begin mem[tempptr].hh.rh:=avail;
avail:=tempptr;ifdef('STAT')decr(dynused);endif('STAT')end;
end else begin incr(LRproblems);mem[p].hh.b0:=13;mem[p].hh.b1:=1;
end else begin tempptr:=getavail;
mem[tempptr].hh.lh:=(4*(mem[p].hh.b1 div 4)+3);
mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;end{:1461};end;
8:{669:}begin mem[memtop-12]:=mem[p+1];
mem[memtop-12].hh.rh:=mem[p].hh.rh;p:=memtop-12;goto 21;end{:669};
others:end;p:=mem[p].hh.rh;end;end{:668};
if adjusttail<>-268435455 then mem[adjusttail].hh.rh:=-268435455;
mem[r+3].int:=h;mem[r+2].int:=d;{674:}if m=1 then w:=x+w;
mem[r+1].int:=w;x:=w-x;if x=0 then begin mem[r+5].hh.b0:=0;
mem[r+5].hh.b1:=0;mem[r+6].gr:=0.0;goto 10;
end else if x>0 then{675:}begin{676:}if totalstretch[4]<>0 then o:=4
else if totalstretch[3]<>0 then o:=3 else if totalstretch[2]<>0 then o:=
2 else if totalstretch[1]<>0 then o:=1 else o:=0{:676};
mem[r+5].hh.b1:=o;mem[r+5].hh.b0:=1;
if totalstretch[o]<>0 then mem[r+6].gr:=x/totalstretch[o]else begin mem[
r+5].hh.b0:=0;mem[r+6].gr:=0.0;end;
if o=0 then if mem[r+5].hh.rh<>-268435455 then{677:}begin lastbadness:=
badness(x,totalstretch[0]);
if lastbadness>eqtb[28957].int then begin println;
if lastbadness>100 then printnl(937)else printnl(938);print(939);
printint(lastbadness);goto 50;end;end{:677};goto 10;
end{:675}else{681:}begin{682:}if totalshrink[4]<>0 then o:=4 else if
totalshrink[3]<>0 then o:=3 else if totalshrink[2]<>0 then o:=2 else if
totalshrink[1]<>0 then o:=1 else o:=0{:682};mem[r+5].hh.b1:=o;
mem[r+5].hh.b0:=2;
if totalshrink[o]<>0 then mem[r+6].gr:=(-x)/totalshrink[o]else begin mem
[r+5].hh.b0:=0;mem[r+6].gr:=0.0;end;
if(totalshrink[o]<-x)and(o=0)and(mem[r+5].hh.rh<>-268435455)then begin
lastbadness:=1000000;mem[r+6].gr:=1.0;
{683:}if(-x-totalshrink[0]>eqtb[29522].int)or(eqtb[28957].int<100)then
begin if(eqtb[29530].int>0)and(-x-totalshrink[0]>eqtb[29522].int)then
begin while mem[q].hh.rh<>-268435455 do q:=mem[q].hh.rh;
mem[q].hh.rh:=newrule;mem[mem[q].hh.rh+1].int:=eqtb[29530].int;end;
println;printnl(945);printscaled(-x-totalshrink[0]);print(946);goto 50;
end{:683};
end else if o=0 then if mem[r+5].hh.rh<>-268435455 then{684:}begin
lastbadness:=badness(-x,totalshrink[0]);
if lastbadness>eqtb[28957].int then begin println;printnl(947);
printint(lastbadness);goto 50;end;end{:684};goto 10;end{:681}{:674};
50:{680:}if outputactive then print(940)else begin if packbeginline<>0
then begin if packbeginline>0 then print(941)else print(942);
printint(abs(packbeginline));print(943);end else print(944);
printint(line);end;println;fontinshortdisplay:=0;
shortdisplay(mem[r+5].hh.rh);println;begindiagnostic;showbox(r);
enddiagnostic(true){:680};10:lastdisp:=disp;
if(eqtb[29001].int>0)then{1462:}begin if mem[LRptr].hh.lh<>0 then begin
while mem[q].hh.rh<>-268435455 do q:=mem[q].hh.rh;repeat tempptr:=q;
q:=newmath(0,mem[LRptr].hh.lh);mem[tempptr].hh.rh:=q;
LRproblems:=LRproblems+10000;begin tempptr:=LRptr;
LRptr:=mem[tempptr].hh.rh;begin mem[tempptr].hh.rh:=avail;
avail:=tempptr;ifdef('STAT')decr(dynused);endif('STAT')end;end;
until mem[LRptr].hh.lh=0;end;
if LRproblems>0 then begin{1463:}begin println;printnl(1511);
printint(LRproblems div 10000);print(1512);
printint(LRproblems mod 10000);print(1513);LRproblems:=0;end{:1463};
goto 50;end;begin tempptr:=LRptr;LRptr:=mem[tempptr].hh.rh;
begin mem[tempptr].hh.rh:=avail;avail:=tempptr;
ifdef('STAT')decr(dynused);endif('STAT')end;end;
if LRptr<>-268435455 then confusion(1510);end{:1462};hpack:=r;end;
{:666}{685:}function vpackage(p:halfword;h:scaled;m:smallnumber;
l:scaled):halfword;label 50,10;var r:halfword;w,d,x:scaled;s:scaled;
g:halfword;o:glueord;begin lastbadness:=0;r:=getnode(10);
mem[r].hh.b0:=1;mem[r].hh.b1:=0;mem[r+4].int:=0;mem[r+7].hh.rh:=membot;
mem[r+7].hh.lh:=membot;incr(mem[membot].hh.rh);incr(mem[membot].hh.rh);
mem[r+5].hh.rh:=p;w:=0;{667:}d:=0;x:=0;totalstretch[0]:=0;
totalshrink[0]:=0;totalstretch[1]:=0;totalshrink[1]:=0;
totalstretch[2]:=0;totalshrink[2]:=0;totalstretch[3]:=0;
totalshrink[3]:=0;totalstretch[4]:=0;totalshrink[4]:=0{:667};
while p<>-268435455 do{686:}begin if(p>=himemmin)then confusion(948)else
case mem[p].hh.b0 of 0,1,2,3,15:{687:}begin x:=x+d+mem[p+3].int;
d:=mem[p+2].int;if mem[p].hh.b0>=3 then s:=0 else s:=mem[p+4].int;
if mem[p+1].int+s>w then w:=mem[p+1].int+s;end{:687};10:{1378:}{:1378};
12:{688:}begin x:=x+d;d:=0;g:=mem[p+1].hh.lh;x:=x+mem[g+1].int;
o:=mem[g].hh.b0;totalstretch[o]:=totalstretch[o]+mem[g+2].int;
o:=mem[g].hh.b1;totalshrink[o]:=totalshrink[o]+mem[g+3].int;
if mem[p].hh.b1>=100 then begin g:=mem[p+1].hh.rh;
if mem[g+1].int>w then w:=mem[g+1].int;end;end{:688};
13:begin x:=x+d+mem[p+1].int;d:=0;end;others:end;p:=mem[p].hh.rh;
end{:686};mem[r+1].int:=w;if d>l then begin x:=x+d-l;mem[r+2].int:=l;
end else mem[r+2].int:=d;{689:}if m=1 then h:=x+h;mem[r+3].int:=h;
x:=h-x;if x=0 then begin mem[r+5].hh.b0:=0;mem[r+5].hh.b1:=0;
mem[r+6].gr:=0.0;goto 10;
end else if x>0 then{690:}begin{676:}if totalstretch[4]<>0 then o:=4
else if totalstretch[3]<>0 then o:=3 else if totalstretch[2]<>0 then o:=
2 else if totalstretch[1]<>0 then o:=1 else o:=0{:676};
mem[r+5].hh.b1:=o;mem[r+5].hh.b0:=1;
if totalstretch[o]<>0 then mem[r+6].gr:=x/totalstretch[o]else begin mem[
r+5].hh.b0:=0;mem[r+6].gr:=0.0;end;
if o=0 then if mem[r+5].hh.rh<>-268435455 then{691:}begin lastbadness:=
badness(x,totalstretch[0]);
if lastbadness>eqtb[28958].int then begin println;
if lastbadness>100 then printnl(937)else printnl(938);print(949);
printint(lastbadness);goto 50;end;end{:691};goto 10;
end{:690}else{693:}begin{682:}if totalshrink[4]<>0 then o:=4 else if
totalshrink[3]<>0 then o:=3 else if totalshrink[2]<>0 then o:=2 else if
totalshrink[1]<>0 then o:=1 else o:=0{:682};mem[r+5].hh.b1:=o;
mem[r+5].hh.b0:=2;
if totalshrink[o]<>0 then mem[r+6].gr:=(-x)/totalshrink[o]else begin mem
[r+5].hh.b0:=0;mem[r+6].gr:=0.0;end;
if(totalshrink[o]<-x)and(o=0)and(mem[r+5].hh.rh<>-268435455)then begin
lastbadness:=1000000;mem[r+6].gr:=1.0;
{694:}if(-x-totalshrink[0]>eqtb[29523].int)or(eqtb[28958].int<100)then
begin println;printnl(950);printscaled(-x-totalshrink[0]);print(951);
goto 50;end{:694};
end else if o=0 then if mem[r+5].hh.rh<>-268435455 then{695:}begin
lastbadness:=badness(-x,totalshrink[0]);
if lastbadness>eqtb[28958].int then begin println;printnl(952);
printint(lastbadness);goto 50;end;end{:695};goto 10;end{:693}{:689};
50:{692:}if outputactive then print(940)else begin if packbeginline<>0
then begin print(942);printint(abs(packbeginline));print(943);
end else print(944);printint(line);println;end;begindiagnostic;
showbox(r);enddiagnostic(true){:692};10:vpackage:=r;end;
{:685}{696:}procedure appendtovlist(b:halfword);var d:scaled;p:halfword;
begin if curlist.auxfield.int>-65536000 then begin d:=mem[eqtb[24529].hh
.rh+1].int-curlist.auxfield.int-mem[b+3].int;
if d<eqtb[29516].int then p:=newparamglue(0)else begin p:=newskipparam(1
);mem[tempptr+1].int:=d;end;mem[curlist.tailfield].hh.rh:=p;
curlist.tailfield:=p;end;mem[curlist.tailfield].hh.rh:=b;
curlist.tailfield:=b;curlist.auxfield.int:=mem[b+2].int;end;
{:696}{703:}function newnoad:halfword;var p:halfword;
begin p:=getnode(5);mem[p].hh.b0:=18;mem[p].hh.b1:=0;
mem[p+1].hh:=emptyfield;mem[p+3].hh:=emptyfield;mem[p+2].hh:=emptyfield;
mem[p+4].hh:=emptyfield;newnoad:=p;end;
{:703}{705:}function newstyle(s:smallnumber):halfword;var p:halfword;
begin p:=getnode(3);mem[p].hh.b0:=16;mem[p].hh.b1:=s;mem[p+1].int:=0;
mem[p+2].int:=0;newstyle:=p;end;{:705}{706:}function newchoice:halfword;
var p:halfword;begin p:=getnode(3);mem[p].hh.b0:=17;mem[p].hh.b1:=0;
mem[p+1].hh.lh:=-268435455;mem[p+1].hh.rh:=-268435455;
mem[p+2].hh.lh:=-268435455;mem[p+2].hh.rh:=-268435455;newchoice:=p;end;
{:706}{710:}procedure showinfo;begin shownodelist(mem[tempptr].hh.lh);
end;{:710}{721:}function fractionrule(t:scaled):halfword;var p:halfword;
begin p:=newrule;mem[p+3].int:=t;mem[p+2].int:=0;fractionrule:=p;end;
{:721}{722:}function overbar(b:halfword;k,t:scaled):halfword;
var p,q:halfword;begin p:=newkern(k);mem[p].hh.rh:=b;q:=fractionrule(t);
mem[q].hh.rh:=p;p:=newkern(t);mem[p].hh.rh:=q;
overbar:=vpackage(p,0,1,1073741823);end;
{:722}{723:}{726:}function charbox(f:internalfontnumber;
c:quarterword):halfword;var q:fourquarters;hd:eightbits;b,p:halfword;
begin q:=fontinfo[charbase[f]+effectivechar(true,f,c)].qqqq;hd:=q.b1;
b:=newnullbox;
mem[b+1].int:=fontinfo[widthbase[f]+q.b0].int+fontinfo[italicbase[f]+(q.
b2)div 4].int;mem[b+3].int:=fontinfo[heightbase[f]+(hd)div 16].int;
mem[b+2].int:=fontinfo[depthbase[f]+(hd)mod 16].int;p:=getavail;
mem[p].hh.b1:=c;mem[p].hh.b0:=f;mem[b+5].hh.rh:=p;charbox:=b;end;
{:726}{728:}procedure stackintobox(b:halfword;f:internalfontnumber;
c:quarterword);var p:halfword;begin p:=charbox(f,c);
mem[p].hh.rh:=mem[b+5].hh.rh;mem[b+5].hh.rh:=p;
mem[b+3].int:=mem[p+3].int;end;
{:728}{729:}function heightplusdepth(f:internalfontnumber;
c:quarterword):scaled;var q:fourquarters;hd:eightbits;
begin q:=fontinfo[charbase[f]+effectivechar(true,f,c)].qqqq;hd:=q.b1;
heightplusdepth:=fontinfo[heightbase[f]+(hd)div 16].int+fontinfo[
depthbase[f]+(hd)mod 16].int;end;{:729}function vardelimiter(d:halfword;
s:integer;v:scaled):halfword;label 40,22;var b:halfword;
f,g:internalfontnumber;c,x,y:quarterword;m,n:integer;u:scaled;w:scaled;
q:fourquarters;hd:eightbits;r:fourquarters;z:integer;
largeattempt:boolean;begin f:=0;w:=0;largeattempt:=false;
z:=mem[d].qqqq.b0;x:=mem[d].qqqq.b1;
while true do begin{724:}if(z<>0)or(x<>0)then begin z:=z+s+256;
repeat z:=z-256;g:=eqtb[25589+z].hh.rh;if g<>0 then{725:}begin y:=x;
if(y>=fontbc[g])and(y<=fontec[g])then begin 22:q:=fontinfo[charbase[g]+y
].qqqq;if(q.b0>0)then begin if((q.b2)mod 4)=3 then begin f:=g;c:=y;
goto 40;end;hd:=q.b1;
u:=fontinfo[heightbase[g]+(hd)div 16].int+fontinfo[depthbase[g]+(hd)mod
16].int;if u>w then begin f:=g;c:=y;w:=u;if u>=v then goto 40;end;
if((q.b2)mod 4)=2 then begin y:=q.b3;goto 22;end;end;end;end{:725};
until z<256;end{:724};if largeattempt then goto 40;largeattempt:=true;
z:=mem[d].qqqq.b2;x:=mem[d].qqqq.b3;end;
40:if f<>0 then{727:}if((q.b2)mod 4)=3 then{730:}begin b:=newnullbox;
mem[b].hh.b0:=1;r:=fontinfo[extenbase[f]+q.b3].qqqq;{731:}c:=r.b3;
u:=heightplusdepth(f,c);w:=0;
q:=fontinfo[charbase[f]+effectivechar(true,f,c)].qqqq;
mem[b+1].int:=fontinfo[widthbase[f]+q.b0].int+fontinfo[italicbase[f]+(q.
b2)div 4].int;c:=r.b2;if c<>0 then w:=w+heightplusdepth(f,c);c:=r.b1;
if c<>0 then w:=w+heightplusdepth(f,c);c:=r.b0;
if c<>0 then w:=w+heightplusdepth(f,c);n:=0;
if u>0 then while w<v do begin w:=w+u;incr(n);if r.b1<>0 then w:=w+u;
end{:731};c:=r.b2;if c<>0 then stackintobox(b,f,c);c:=r.b3;
for m:=1 to n do stackintobox(b,f,c);c:=r.b1;
if c<>0 then begin stackintobox(b,f,c);c:=r.b3;
for m:=1 to n do stackintobox(b,f,c);end;c:=r.b0;
if c<>0 then stackintobox(b,f,c);mem[b+2].int:=w-mem[b+3].int;
end{:730}else b:=charbox(f,c){:727}else begin b:=newnullbox;
mem[b+1].int:=eqtb[29525].int;end;
mem[b+4].int:=half(mem[b+3].int-mem[b+2].int)-fontinfo[22+parambase[eqtb
[25591+s].hh.rh]].int;vardelimiter:=b;end;
{:723}{732:}function rebox(b:halfword;w:scaled):halfword;var p:halfword;
f:internalfontnumber;v:scaled;
begin if(mem[b+1].int<>w)and(mem[b+5].hh.rh<>-268435455)then begin if
mem[b].hh.b0<>0 then b:=hpack(b,0,1);p:=mem[b+5].hh.rh;
if(p>=himemmin)then if fontdir[mem[p].hh.b0]<>0 then begin if mem[mem[p]
.hh.rh].hh.rh=-268435455 then begin f:=mem[p].hh.b0;
v:=fontinfo[widthbase[f]+fontinfo[charbase[f]+mem[p].hh.b1].qqqq.b0].int
;
if v<>mem[b+1].int then mem[mem[p].hh.rh].hh.rh:=newkern(mem[b+1].int-v)
;end end else if mem[p].hh.rh=-268435455 then begin f:=mem[p].hh.b0;
v:=fontinfo[widthbase[f]+fontinfo[charbase[f]+mem[p].hh.b1].qqqq.b0].int
;if v<>mem[b+1].int then mem[p].hh.rh:=newkern(mem[b+1].int-v);end;
deleteglueref(mem[b+7].hh.rh);deleteglueref(mem[b+7].hh.lh);
freenode(b,10);b:=newglue(membot+16);mem[b].hh.rh:=p;
while mem[p].hh.rh<>-268435455 do p:=mem[p].hh.rh;
mem[p].hh.rh:=newglue(membot+16);rebox:=hpack(b,w,0);
end else begin mem[b+1].int:=w;rebox:=b;end;end;
{:732}{733:}function mathglue(g:halfword;m:scaled):halfword;
var p:halfword;n:integer;f:scaled;begin n:=xovern(m,65536);
f:=texremainder;if f<0 then begin decr(n);f:=f+65536;end;p:=getnode(4);
mem[p+1].int:=multandadd(n,mem[g+1].int,xnoverd(mem[g+1].int,f,65536),
1073741823);mem[p].hh.b0:=mem[g].hh.b0;
if mem[p].hh.b0=0 then mem[p+2].int:=multandadd(n,mem[g+2].int,xnoverd(
mem[g+2].int,f,65536),1073741823)else mem[p+2].int:=mem[g+2].int;
mem[p].hh.b1:=mem[g].hh.b1;
if mem[p].hh.b1=0 then mem[p+3].int:=multandadd(n,mem[g+3].int,xnoverd(
mem[g+3].int,f,65536),1073741823)else mem[p+3].int:=mem[g+3].int;
mathglue:=p;end;{:733}{734:}procedure mathkern(p:halfword;m:scaled);
var n:integer;f:scaled;
begin if mem[p].hh.b1=99 then begin n:=xovern(m,65536);f:=texremainder;
if f<0 then begin decr(n);f:=f+65536;end;
mem[p+1].int:=multandadd(n,mem[p+1].int,xnoverd(mem[p+1].int,f,65536),
1073741823);mem[p].hh.b1:=1;end;end;{:734}{735:}procedure flushmath;
begin flushnodelist(mem[curlist.headfield].hh.rh);
flushnodelist(curlist.auxfield.int);
mem[curlist.headfield].hh.rh:=-268435455;
curlist.tailfield:=curlist.headfield;curlist.auxfield.int:=-268435455;
end;{:735}{737:}procedure mlisttohlist;forward;
function cleanbox(p:halfword;s:smallnumber;jc:halfword):halfword;
label 40;var q:halfword;savestyle:smallnumber;x:halfword;r:halfword;
begin case mem[p].hh.rh of 1:begin curmlist:=newnoad;
mem[curmlist+1]:=mem[p];end;5:begin curmlist:=newnoad;
mem[curmlist+1]:=mem[p];mem[curmlist+4].hh.lh:=jc;end;
2:begin q:=mem[p].hh.lh;goto 40;end;3:curmlist:=mem[p].hh.lh;
others:begin q:=newnullbox;goto 40;end end;savestyle:=curstyle;
curstyle:=s;mlistpenalties:=false;mlisttohlist;q:=mem[memtop-3].hh.rh;
curstyle:=savestyle;
{720:}begin if curstyle<4 then cursize:=0 else cursize:=256*((curstyle-2
)div 2);
curmu:=xovern(fontinfo[6+parambase[eqtb[25591+cursize].hh.rh]].int,18);
end{:720};
40:if(q>=himemmin)or(q=-268435455)then x:=hpack(q,0,1)else if(mem[q].hh.
rh=-268435455)and(mem[q].hh.b0<=2)and(mem[q+4].int=0)then x:=q else x:=
hpack(q,0,1);{738:}q:=mem[x+5].hh.rh;
if(q>=himemmin)then begin if fontdir[mem[q].hh.b0]<>0 then q:=mem[q].hh.
rh;r:=mem[q].hh.rh;
if r<>-268435455 then if mem[r].hh.rh=-268435455 then if not(r>=himemmin
)then if mem[r].hh.b0=13 then begin freenode(r,4);
mem[q].hh.rh:=-268435455;end;end{:738};cleanbox:=x;end;
{:737}{739:}procedure fetch(a:halfword);begin curc:=mem[a].hh.b1;
curf:=eqtb[25589+mem[a].hh.b0+cursize].hh.rh;
if curf=0 then{740:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(343);
end;printsize(cursize);printchar(32);printint(mem[a].hh.b0);print(978);
print(curc);printchar(41);begin helpptr:=4;helpline[3]:=979;
helpline[2]:=980;helpline[1]:=981;helpline[0]:=982;end;error;
curi:=nullcharacter;mem[a].hh.rh:=0;
end{:740}else begin if fontdir[curf]<>0 then curc:=getjfmpos(mem[a+3].hh
.lh,curf);
if(curc>=fontbc[curf])and(curc<=fontec[curf])then curi:=fontinfo[
charbase[curf]+curc].qqqq else curi:=nullcharacter;
if not((curi.b0>0))then begin charwarning(curf,curc);mem[a].hh.rh:=0;
end;end;end;{:739}{743:}{751:}procedure makeover(q:halfword);
begin mem[q+1].hh.lh:=overbar(cleanbox(q+1,2*(curstyle div 2)+1,mem[q+4]
.hh.lh),3*fontinfo[8+parambase[eqtb[25592+cursize].hh.rh]].int,fontinfo[
8+parambase[eqtb[25592+cursize].hh.rh]].int);mem[q+1].hh.rh:=2;end;
{:751}{752:}procedure makeunder(q:halfword);var p,x,y:halfword;
delta:scaled;begin x:=cleanbox(q+1,curstyle,mem[q+4].hh.lh);
p:=newkern(3*fontinfo[8+parambase[eqtb[25592+cursize].hh.rh]].int);
mem[x].hh.rh:=p;
mem[p].hh.rh:=fractionrule(fontinfo[8+parambase[eqtb[25592+cursize].hh.
rh]].int);y:=vpackage(x,0,1,1073741823);
delta:=mem[y+3].int+mem[y+2].int+fontinfo[8+parambase[eqtb[25592+cursize
].hh.rh]].int;mem[y+3].int:=mem[x+3].int;
mem[y+2].int:=delta-mem[y+3].int;mem[q+1].hh.lh:=y;mem[q+1].hh.rh:=2;
end;{:752}{753:}procedure makevcenter(q:halfword);var v:halfword;
delta:scaled;begin v:=mem[q+1].hh.lh;
if mem[v].hh.b0=2 then begin if mem[mem[v+5].hh.rh].hh.b0<>1 then
confusion(984)end else begin if mem[v].hh.b0<>1 then confusion(584)end;
delta:=mem[v+3].int+mem[v+2].int;
mem[v+3].int:=fontinfo[22+parambase[eqtb[25591+cursize].hh.rh]].int+half
(delta);mem[v+2].int:=delta-mem[v+3].int;end;
{:753}{754:}procedure makeradical(q:halfword);var x,y:halfword;
delta,clr:scaled;
begin x:=cleanbox(q+1,2*(curstyle div 2)+1,mem[q+4].hh.lh);
if curstyle<2 then clr:=fontinfo[8+parambase[eqtb[25592+cursize].hh.rh]]
.int+(abs(fontinfo[5+parambase[eqtb[25591+cursize].hh.rh]].int)div 4)
else begin clr:=fontinfo[8+parambase[eqtb[25592+cursize].hh.rh]].int;
clr:=clr+(abs(clr)div 4);end;
y:=vardelimiter(q+5,cursize,mem[x+3].int+mem[x+2].int+clr+fontinfo[8+
parambase[eqtb[25592+cursize].hh.rh]].int);
delta:=mem[y+2].int-(mem[x+3].int+mem[x+2].int+clr);
if delta>0 then clr:=clr+half(delta);mem[y+4].int:=-(mem[x+3].int+clr);
mem[y].hh.rh:=overbar(x,clr,mem[y+3].int);mem[q+1].hh.lh:=hpack(y,0,1);
mem[q+1].hh.rh:=2;end;{:754}{755:}procedure makemathaccent(q:halfword);
label 30,31;var p,x,y:halfword;a:integer;c:quarterword;
f:internalfontnumber;i:fourquarters;s:scaled;h:scaled;delta:scaled;
w:scaled;begin fetch(q+5);if(curi.b0>0)then begin i:=curi;c:=curc;
f:=curf;{758:}s:=0;if mem[q+1].hh.rh=1 then begin fetch(q+1);
if((curi.b2)mod 4)=1 then begin a:=ligkernbase[curf]+curi.b3;
curi:=fontinfo[a].qqqq;
if curi.b0>128 then begin a:=ligkernbase[curf]+256*curi.b2+curi.b3
+32768-256*(128);curi:=fontinfo[a].qqqq;end;
while true do begin if curi.b1=skewchar[curf]then begin if curi.b2>=128
then if curi.b0<=128 then s:=fontinfo[kernbase[curf]+256*curi.b2+curi.b3
].int;goto 31;end;if curi.b0>=128 then goto 31;a:=a+curi.b0+1;
curi:=fontinfo[a].qqqq;end;end;end;31:{:758};
x:=cleanbox(q+1,2*(curstyle div 2)+1,mem[q+4].hh.lh);w:=mem[x+1].int;
h:=mem[x+3].int;
{757:}while true do begin if((i.b2)mod 4)<>2 then goto 30;y:=i.b3;
i:=fontinfo[charbase[f]+y].qqqq;if not(i.b0>0)then goto 30;
if fontinfo[widthbase[f]+i.b0].int>w then goto 30;c:=y;end;30:{:757};
if h<fontinfo[5+parambase[f]].int then delta:=h else delta:=fontinfo[5+
parambase[f]].int;
if(mem[q+2].hh.rh<>0)or(mem[q+3].hh.rh<>0)then if mem[q+1].hh.rh=1 then
{759:}begin flushnodelist(x);x:=newnoad;mem[x+1]:=mem[q+1];
mem[x+2]:=mem[q+2];mem[x+3]:=mem[q+3];mem[q+2].hh:=emptyfield;
mem[q+3].hh:=emptyfield;mem[q+1].hh.rh:=3;mem[q+1].hh.lh:=x;
x:=cleanbox(q+1,curstyle,mem[q+4].hh.lh);delta:=delta+mem[x+3].int-h;
h:=mem[x+3].int;end{:759};y:=charbox(f,c);
mem[y+4].int:=s+half(w-mem[y+1].int);mem[y+1].int:=0;p:=newkern(-delta);
mem[p].hh.rh:=x;mem[y].hh.rh:=p;y:=vpackage(y,0,1,1073741823);
mem[y+1].int:=mem[x+1].int;
if mem[y+3].int<h then{756:}begin p:=newkern(h-mem[y+3].int);
mem[p].hh.rh:=mem[y+5].hh.rh;mem[y+5].hh.rh:=p;mem[y+3].int:=h;
end{:756};mem[q+1].hh.lh:=y;mem[q+1].hh.rh:=2;end;end;
{:755}{760:}procedure makefraction(q:halfword);var p,v,x,y,z:halfword;
delta,delta1,delta2,shiftup,shiftdown,clr:scaled;
begin if mem[q+1].int=1073741824 then mem[q+1].int:=fontinfo[8+parambase
[eqtb[25592+cursize].hh.rh]].int;
{761:}x:=cleanbox(q+2,curstyle+2-2*(curstyle div 6),mem[q+4].hh.lh);
z:=cleanbox(q+3,2*(curstyle div 2)+3-2*(curstyle div 6),mem[q+4].hh.lh);
if mem[x+1].int<mem[z+1].int then x:=rebox(x,mem[z+1].int)else z:=rebox(
z,mem[x+1].int);
if curstyle<2 then begin shiftup:=fontinfo[8+parambase[eqtb[25591+
cursize].hh.rh]].int;
shiftdown:=fontinfo[11+parambase[eqtb[25591+cursize].hh.rh]].int;
end else begin shiftdown:=fontinfo[12+parambase[eqtb[25591+cursize].hh.
rh]].int;
if mem[q+1].int<>0 then shiftup:=fontinfo[9+parambase[eqtb[25591+cursize
].hh.rh]].int else shiftup:=fontinfo[10+parambase[eqtb[25591+cursize].hh
.rh]].int;end{:761};
if mem[q+1].int=0 then{762:}begin if curstyle<2 then clr:=7*fontinfo[8+
parambase[eqtb[25592+cursize].hh.rh]].int else clr:=3*fontinfo[8+
parambase[eqtb[25592+cursize].hh.rh]].int;
delta:=half(clr-((shiftup-mem[x+2].int)-(mem[z+3].int-shiftdown)));
if delta>0 then begin shiftup:=shiftup+delta;shiftdown:=shiftdown+delta;
end;
end{:762}else{763:}begin if curstyle<2 then clr:=3*mem[q+1].int else clr
:=mem[q+1].int;delta:=half(mem[q+1].int);
delta1:=clr-((shiftup-mem[x+2].int)-(fontinfo[22+parambase[eqtb[25591+
cursize].hh.rh]].int+delta));
delta2:=clr-((fontinfo[22+parambase[eqtb[25591+cursize].hh.rh]].int-
delta)-(mem[z+3].int-shiftdown));
if delta1>0 then shiftup:=shiftup+delta1;
if delta2>0 then shiftdown:=shiftdown+delta2;end{:763};
{764:}v:=newnullbox;mem[v].hh.b0:=1;mem[v+3].int:=shiftup+mem[x+3].int;
mem[v+2].int:=mem[z+2].int+shiftdown;mem[v+1].int:=mem[x+1].int;
if mem[q+1].int=0 then begin p:=newkern((shiftup-mem[x+2].int)-(mem[z+3]
.int-shiftdown));mem[p].hh.rh:=z;
end else begin y:=fractionrule(mem[q+1].int);
p:=newkern((fontinfo[22+parambase[eqtb[25591+cursize].hh.rh]].int-delta)
-(mem[z+3].int-shiftdown));mem[y].hh.rh:=p;mem[p].hh.rh:=z;
p:=newkern((shiftup-mem[x+2].int)-(fontinfo[22+parambase[eqtb[25591+
cursize].hh.rh]].int+delta));mem[p].hh.rh:=y;end;mem[x].hh.rh:=p;
mem[v+5].hh.rh:=x{:764};
{765:}if curstyle<2 then delta:=fontinfo[20+parambase[eqtb[25591+cursize
].hh.rh]].int else delta:=fontinfo[21+parambase[eqtb[25591+cursize].hh.
rh]].int;x:=vardelimiter(q+5,cursize,delta);mem[x].hh.rh:=v;
z:=vardelimiter(q+4,cursize,delta);mem[v].hh.rh:=z;
mem[q+1].int:=hpack(x,0,1){:765};end;
{:760}{766:}function makeop(q:halfword):scaled;var delta:scaled;
p,v,x,y,z:halfword;c:quarterword;i:fourquarters;
shiftup,shiftdown:scaled;
begin if(mem[q].hh.b1=0)and(curstyle<2)then mem[q].hh.b1:=1;
if mem[q+1].hh.rh=1 then begin fetch(q+1);
if(curstyle<2)and(((curi.b2)mod 4)=2)then begin c:=curi.b3;
i:=fontinfo[charbase[curf]+c].qqqq;if(i.b0>0)then begin curc:=c;curi:=i;
mem[q+1].hh.b1:=c;end;end;
delta:=fontinfo[italicbase[curf]+(curi.b2)div 4].int;
x:=cleanbox(q+1,curstyle,mem[q+4].hh.lh);
if(mem[q+3].hh.rh<>0)and(mem[q].hh.b1<>1)then mem[x+1].int:=mem[x+1].int
-delta;
mem[x+4].int:=half(mem[x+3].int-mem[x+2].int)-fontinfo[22+parambase[eqtb
[25591+cursize].hh.rh]].int;mem[q+1].hh.rh:=2;mem[q+1].hh.lh:=x;
end else delta:=0;
if mem[q].hh.b1=1 then{767:}begin x:=cleanbox(q+2,2*(curstyle div 4)+4+(
curstyle mod 2),mem[q+4].hh.lh);
y:=cleanbox(q+1,curstyle,mem[q+4].hh.lh);
z:=cleanbox(q+3,2*(curstyle div 4)+5,mem[q+4].hh.lh);v:=newnullbox;
mem[v].hh.b0:=1;mem[v+1].int:=mem[y+1].int;
if mem[x+1].int>mem[v+1].int then mem[v+1].int:=mem[x+1].int;
if mem[z+1].int>mem[v+1].int then mem[v+1].int:=mem[z+1].int;
x:=rebox(x,mem[v+1].int);y:=rebox(y,mem[v+1].int);
z:=rebox(z,mem[v+1].int);mem[x+4].int:=half(delta);
mem[z+4].int:=-mem[x+4].int;mem[v+3].int:=mem[y+3].int;
mem[v+2].int:=mem[y+2].int;
{768:}if mem[q+2].hh.rh=0 then begin deleteglueref(mem[x+7].hh.rh);
deleteglueref(mem[x+7].hh.lh);freenode(x,10);mem[v+5].hh.rh:=y;
end else begin shiftup:=fontinfo[11+parambase[eqtb[25592+cursize].hh.rh]
].int-mem[x+2].int;
if shiftup<fontinfo[9+parambase[eqtb[25592+cursize].hh.rh]].int then
shiftup:=fontinfo[9+parambase[eqtb[25592+cursize].hh.rh]].int;
p:=newkern(shiftup);mem[p].hh.rh:=y;mem[x].hh.rh:=p;
p:=newkern(fontinfo[13+parambase[eqtb[25592+cursize].hh.rh]].int);
mem[p].hh.rh:=x;mem[v+5].hh.rh:=p;
mem[v+3].int:=mem[v+3].int+fontinfo[13+parambase[eqtb[25592+cursize].hh.
rh]].int+mem[x+3].int+mem[x+2].int+shiftup;end;
if mem[q+3].hh.rh=0 then begin deleteglueref(mem[z+7].hh.rh);
deleteglueref(mem[z+7].hh.lh);
freenode(z,10)end else begin shiftdown:=fontinfo[12+parambase[eqtb[
25592+cursize].hh.rh]].int-mem[z+3].int;
if shiftdown<fontinfo[10+parambase[eqtb[25592+cursize].hh.rh]].int then
shiftdown:=fontinfo[10+parambase[eqtb[25592+cursize].hh.rh]].int;
p:=newkern(shiftdown);mem[y].hh.rh:=p;mem[p].hh.rh:=z;
p:=newkern(fontinfo[13+parambase[eqtb[25592+cursize].hh.rh]].int);
mem[z].hh.rh:=p;
mem[v+2].int:=mem[v+2].int+fontinfo[13+parambase[eqtb[25592+cursize].hh.
rh]].int+mem[z+3].int+mem[z+2].int+shiftdown;end{:768};mem[q+1].int:=v;
end{:767};makeop:=delta;end;{:766}{769:}procedure makeord(q:halfword);
label 20,10;var a:integer;gp,gq,p,r:halfword;rr:halfword;
begin 20:if(mem[q+3].hh.rh=0)and(mem[q+2].hh.rh=0)and((mem[q+1].hh.rh=1)
or(mem[q+1].hh.rh=5))then begin p:=mem[q].hh.rh;
if p<>-268435455 then if(mem[p].hh.b0>=18)and(mem[p].hh.b0<=24)then if
mem[p+1].hh.b0=mem[q+1].hh.b0 then if mem[p+1].hh.rh=1 then begin mem[q
+1].hh.rh:=4;fetch(q+1);
if((curi.b2)mod 4)=1 then begin a:=ligkernbase[curf]+curi.b3;
curc:=mem[p+1].hh.b1;curi:=fontinfo[a].qqqq;
if curi.b0>128 then begin a:=ligkernbase[curf]+256*curi.b2+curi.b3
+32768-256*(128);curi:=fontinfo[a].qqqq;end;
while true do begin{770:}if curi.b1=curc then if curi.b0<=128 then if
curi.b2>=128 then begin p:=newkern(fontinfo[kernbase[curf]+256*curi.b2+
curi.b3].int);mem[p].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=p;goto 10;
end else begin begin if interrupt<>0 then pauseforinstructions;end;
case curi.b2 of 1,5:mem[q+1].hh.b1:=curi.b3;2,6:mem[p+1].hh.b1:=curi.b3;
3,7,11:begin r:=newnoad;mem[r+1].hh.b1:=curi.b3;
mem[r+1].hh.b0:=mem[q+1].hh.b0;mem[q].hh.rh:=r;mem[r].hh.rh:=p;
if curi.b2<11 then mem[r+1].hh.rh:=1 else mem[r+1].hh.rh:=4;end;
others:begin mem[q].hh.rh:=mem[p].hh.rh;mem[q+1].hh.b1:=curi.b3;
mem[q+3]:=mem[p+3];mem[q+2]:=mem[p+2];freenode(p,5);end end;
if curi.b2>3 then goto 10;mem[q+1].hh.rh:=1;goto 20;end{:770};
if curi.b0>=128 then goto 10;a:=a+curi.b0+1;curi:=fontinfo[a].qqqq;end;
end;end else if mem[p+1].hh.rh=5 then begin mem[q+1].hh.rh:=6;
fetch(p+1);a:=curc;fetch(q+1);if((curi.b2)mod 4)=1 then begin curc:=a;
a:=ligkernbase[curf]+curi.b3;repeat curi:=fontinfo[a].qqqq;
if curi.b1=curc then if curi.b2<128 then begin gp:=fontglue[curf];
rr:=curi.b3;
if gp<>-268435455 then begin while((mem[gp].hh.b0<>rr)and(mem[gp].hh.rh
<>-268435455))do begin gp:=mem[gp].hh.rh;end;gq:=mem[gp+1].hh.lh;
end else begin gp:=getnode(2);fontglue[curf]:=gp;gq:=-268435455;end;
if gq=-268435455 then begin mem[gp].hh.b0:=rr;gq:=newspec(membot);
mem[gp+1].hh.lh:=gq;a:=extenbase[curf]+(rr)*3;
mem[gq+1].int:=fontinfo[a].int;mem[gq+2].int:=fontinfo[a+1].int;
mem[gq+3].int:=fontinfo[a+2].int;incr(mem[gq].hh.rh);
mem[gp].hh.rh:=getnode(2);gp:=mem[gp].hh.rh;mem[gp+1].hh.lh:=-268435455;
mem[gp].hh.rh:=-268435455;end;p:=newglue(gq);mem[p].hh.rh:=mem[q].hh.rh;
mem[q].hh.rh:=p;goto 10;
end else begin p:=newkern(fontinfo[kernbase[curf]+256*curi.b2+curi.b3].
int);mem[p].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=p;goto 10;end;incr(a);
until curi.b0>=128;end;end;end;10:end;
{:769}{773:}procedure makescripts(q:halfword;delta:scaled);
var p,x,y,z:halfword;shiftup,shiftdown,clr:scaled;t:integer;
begin p:=mem[q+1].int;if(p>=himemmin)then begin shiftup:=0;shiftdown:=0;
end else begin z:=hpack(p,0,1);if curstyle<4 then t:=256 else t:=512;
shiftup:=mem[z+3].int-fontinfo[18+parambase[eqtb[25591+t].hh.rh]].int;
shiftdown:=mem[z+2].int+fontinfo[19+parambase[eqtb[25591+t].hh.rh]].int;
deleteglueref(mem[z+7].hh.rh);deleteglueref(mem[z+7].hh.lh);
freenode(z,10);end;
if mem[q+2].hh.rh=0 then{774:}begin x:=cleanbox(q+3,2*(curstyle div 4)+5
,mem[q+4].hh.lh);mem[x+1].int:=mem[x+1].int+eqtb[29526].int;
if shiftdown<fontinfo[16+parambase[eqtb[25591+cursize].hh.rh]].int then
shiftdown:=fontinfo[16+parambase[eqtb[25591+cursize].hh.rh]].int;
clr:=mem[x+3].int-(abs(fontinfo[5+parambase[eqtb[25591+cursize].hh.rh]].
int*4)div 5);if shiftdown<clr then shiftdown:=clr;
mem[x+4].int:=shiftdown;
end{:774}else begin{775:}begin x:=cleanbox(q+2,2*(curstyle div 4)+4+(
curstyle mod 2),mem[q+4].hh.lh);
mem[x+1].int:=mem[x+1].int+eqtb[29526].int;
if odd(curstyle)then clr:=fontinfo[15+parambase[eqtb[25591+cursize].hh.
rh]].int else if curstyle<2 then clr:=fontinfo[13+parambase[eqtb[25591+
cursize].hh.rh]].int else clr:=fontinfo[14+parambase[eqtb[25591+cursize]
.hh.rh]].int;if shiftup<clr then shiftup:=clr;
clr:=mem[x+2].int+(abs(fontinfo[5+parambase[eqtb[25591+cursize].hh.rh]].
int)div 4);if shiftup<clr then shiftup:=clr;end{:775};
if mem[q+3].hh.rh=0 then mem[x+4].int:=-shiftup else{776:}begin y:=
cleanbox(q+3,2*(curstyle div 4)+5,mem[q+4].hh.lh);
mem[y+1].int:=mem[y+1].int+eqtb[29526].int;
if shiftdown<fontinfo[17+parambase[eqtb[25591+cursize].hh.rh]].int then
shiftdown:=fontinfo[17+parambase[eqtb[25591+cursize].hh.rh]].int;
clr:=4*fontinfo[8+parambase[eqtb[25592+cursize].hh.rh]].int-((shiftup-
mem[x+2].int)-(mem[y+3].int-shiftdown));
if clr>0 then begin shiftdown:=shiftdown+clr;
clr:=(abs(fontinfo[5+parambase[eqtb[25591+cursize].hh.rh]].int*4)div 5)-
(shiftup-mem[x+2].int);if clr>0 then begin shiftup:=shiftup+clr;
shiftdown:=shiftdown-clr;end;end;mem[x+4].int:=delta;
p:=newkern((shiftup-mem[x+2].int)-(mem[y+3].int-shiftdown));
mem[x].hh.rh:=p;mem[p].hh.rh:=y;x:=vpackage(x,0,1,1073741823);
mem[x+4].int:=shiftdown;end{:776};end;
if mem[q+1].int=-268435455 then mem[q+1].int:=x else begin p:=mem[q+1].
int;while mem[p].hh.rh<>-268435455 do p:=mem[p].hh.rh;mem[p].hh.rh:=x;
end;end;{:773}{779:}function makeleftright(q:halfword;style:smallnumber;
maxd,maxh:scaled):smallnumber;var delta,delta1,delta2:scaled;
begin curstyle:=style;
{720:}begin if curstyle<4 then cursize:=0 else cursize:=256*((curstyle-2
)div 2);
curmu:=xovern(fontinfo[6+parambase[eqtb[25591+cursize].hh.rh]].int,18);
end{:720};
delta2:=maxd+fontinfo[22+parambase[eqtb[25591+cursize].hh.rh]].int;
delta1:=maxh+maxd-delta2;if delta2>delta1 then delta1:=delta2;
delta:=(delta1 div 500)*eqtb[28949].int;
delta2:=delta1+delta1-eqtb[29524].int;
if delta<delta2 then delta:=delta2;
mem[q+1].int:=vardelimiter(q+1,cursize,delta);
makeleftright:=mem[q].hh.b0-(10);end;{:779}procedure mlisttohlist;
label 21,82,80,81,83,30;var mlist:halfword;penalties:boolean;
style:smallnumber;u:halfword;savestyle:smallnumber;q:halfword;
r:halfword;rtype:smallnumber;t:smallnumber;p,x,y,z:halfword;pen:integer;
s:integer;maxh,maxd:scaled;delta:scaled;begin mlist:=curmlist;
penalties:=mlistpenalties;style:=curstyle;q:=mlist;r:=-268435455;
rtype:=19;maxh:=0;maxd:=0;
{720:}begin if curstyle<4 then cursize:=0 else cursize:=256*((curstyle-2
)div 2);
curmu:=xovern(fontinfo[6+parambase[eqtb[25591+cursize].hh.rh]].int,18);
end{:720};while q<>-268435455 do{744:}begin{745:}21:delta:=0;
case mem[q].hh.b0 of 20:case rtype of 20,19,21,22,24,32:begin mem[q].hh.
b0:=18;goto 21;end;others:end;
21,23,24,33:begin{746:}if rtype=20 then mem[r].hh.b0:=18{:746};
if mem[q].hh.b0=33 then goto 80;end;{750:}32:goto 80;
27:begin makefraction(q);goto 82;end;19:begin delta:=makeop(q);
if mem[q].hh.b1=1 then goto 82;end;18:makeord(q);22,25:;
26:makeradical(q);29:makeover(q);28:makeunder(q);30:makemathaccent(q);
31:makevcenter(q);{:750}{747:}16:begin curstyle:=mem[q].hh.b1;
{720:}begin if curstyle<4 then cursize:=0 else cursize:=256*((curstyle-2
)div 2);
curmu:=xovern(fontinfo[6+parambase[eqtb[25591+cursize].hh.rh]].int,18);
end{:720};goto 81;end;
17:{748:}begin case curstyle div 2 of 0:begin p:=mem[q+1].hh.lh;
mem[q+1].hh.lh:=-268435455;end;1:begin p:=mem[q+1].hh.rh;
mem[q+1].hh.rh:=-268435455;end;2:begin p:=mem[q+2].hh.lh;
mem[q+2].hh.lh:=-268435455;end;3:begin p:=mem[q+2].hh.rh;
mem[q+2].hh.rh:=-268435455;end;end;flushnodelist(mem[q+1].hh.lh);
flushnodelist(mem[q+1].hh.rh);flushnodelist(mem[q+2].hh.lh);
flushnodelist(mem[q+2].hh.rh);mem[q].hh.b0:=16;mem[q].hh.b1:=curstyle;
mem[q+1].int:=0;mem[q+2].int:=0;
if p<>-268435455 then begin z:=mem[q].hh.rh;mem[q].hh.rh:=p;
while mem[p].hh.rh<>-268435455 do p:=mem[p].hh.rh;mem[p].hh.rh:=z;end;
goto 81;end{:748};4,6,7,10,14,9:goto 81;
3:begin if mem[q+3].int>maxh then maxh:=mem[q+3].int;
if mem[q+2].int>maxd then maxd:=mem[q+2].int;goto 81;end;
12:begin{749:}if mem[q].hh.b1=99 then begin x:=mem[q+1].hh.lh;
y:=mathglue(x,curmu);deleteglueref(x);mem[q+1].hh.lh:=y;mem[q].hh.b1:=0;
end else if(cursize<>0)and(mem[q].hh.b1=98)then begin p:=mem[q].hh.rh;
if p<>-268435455 then if(mem[p].hh.b0=12)or(mem[p].hh.b0=13)then begin
mem[q].hh.rh:=mem[p].hh.rh;mem[p].hh.rh:=-268435455;flushnodelist(p);
end;end{:749};goto 81;end;13:begin mathkern(q,curmu);goto 81;end;
5:goto 81;{:747}others:confusion(983)end;
{771:}case mem[q+1].hh.rh of 1,4,5,6:{772:}begin fetch(q+1);
if(curi.b0>0)then begin delta:=fontinfo[italicbase[curf]+(curi.b2)div 4]
.int;p:=newcharacter(curf,curc);u:=p;
if fontdir[curf]<>0 then begin mem[u].hh.rh:=getavail;u:=mem[u].hh.rh;
mem[u].hh.lh:=mem[q+4].hh.lh;end;
if((mem[q+1].hh.rh=4)or(mem[q+1].hh.rh=6))and(fontinfo[2+parambase[curf]
].int<>0)then delta:=0;
if(mem[q+3].hh.rh=0)and(delta<>0)then begin mem[u].hh.rh:=newkern(delta)
;delta:=0;end;end else p:=-268435455;end{:772};0:p:=-268435455;
2:p:=mem[q+1].hh.lh;3:begin curmlist:=mem[q+1].hh.lh;
savestyle:=curstyle;mlistpenalties:=false;mlisttohlist;
curstyle:=savestyle;
{720:}begin if curstyle<4 then cursize:=0 else cursize:=256*((curstyle-2
)div 2);
curmu:=xovern(fontinfo[6+parambase[eqtb[25591+cursize].hh.rh]].int,18);
end{:720};p:=hpack(mem[memtop-3].hh.rh,0,1);end;
others:confusion(985)end;mem[q+1].int:=p;
if(mem[q+3].hh.rh=0)and(mem[q+2].hh.rh=0)then goto 82;
makescripts(q,delta){:771}{:745};82:z:=hpack(mem[q+1].int,0,1);
if mem[z+3].int>maxh then maxh:=mem[z+3].int;
if mem[z+2].int>maxd then maxd:=mem[z+2].int;
deleteglueref(mem[z+7].hh.rh);deleteglueref(mem[z+7].hh.lh);
freenode(z,10);80:r:=q;rtype:=mem[r].hh.b0;
if rtype=33 then begin rtype:=32;curstyle:=style;
{720:}begin if curstyle<4 then cursize:=0 else cursize:=256*((curstyle-2
)div 2);
curmu:=xovern(fontinfo[6+parambase[eqtb[25591+cursize].hh.rh]].int,18);
end{:720};end;81:q:=mem[q].hh.rh;end{:744};
{746:}if rtype=20 then mem[r].hh.b0:=18{:746};{777:}p:=memtop-3;
mem[p].hh.rh:=-268435455;q:=mlist;rtype:=0;curstyle:=style;
{720:}begin if curstyle<4 then cursize:=0 else cursize:=256*((curstyle-2
)div 2);
curmu:=xovern(fontinfo[6+parambase[eqtb[25591+cursize].hh.rh]].int,18);
end{:720};while q<>-268435455 do begin{778:}t:=18;s:=5;pen:=10000;
case mem[q].hh.b0 of 19,22,23,24,25:t:=mem[q].hh.b0;20:begin t:=20;
pen:=eqtb[28940].int;end;21:begin t:=21;pen:=eqtb[28941].int;end;
18,31,29,28:;26:s:=6;30:s:=6;27:begin t:=25;s:=6;end;
32,33:t:=makeleftright(q,style,maxd,maxh);
16:{780:}begin curstyle:=mem[q].hh.b1;s:=3;
{720:}begin if curstyle<4 then cursize:=0 else cursize:=256*((curstyle-2
)div 2);
curmu:=xovern(fontinfo[6+parambase[eqtb[25591+cursize].hh.rh]].int,18);
end{:720};goto 83;end{:780};10,14,3,9,7,4,6,12,13:begin mem[p].hh.rh:=q;
p:=q;q:=mem[q].hh.rh;mem[p].hh.rh:=-268435455;goto 30;end;
5:begin mem[p].hh.rh:=q;p:=q;q:=mem[q].hh.rh;mem[p].hh.rh:=-268435455;
goto 30;end;others:confusion(986)end{:778};
{783:}if rtype>0 then begin case strpool[rtype*8+t+magicoffset]of 48:x:=
0;49:if curstyle<4 then x:=17 else x:=0;50:x:=17;
51:if curstyle<4 then x:=18 else x:=0;
52:if curstyle<4 then x:=19 else x:=0;others:confusion(988)end;
if x<>0 then begin y:=mathglue(eqtb[24528+x].hh.rh,curmu);z:=newglue(y);
mem[y].hh.rh:=-268435455;mem[p].hh.rh:=z;p:=z;mem[z].hh.b1:=x+1;end;
end{:783};
{784:}if mem[q+1].int<>-268435455 then begin mem[p].hh.rh:=mem[q+1].int;
repeat p:=mem[p].hh.rh;until mem[p].hh.rh=-268435455;end;
if penalties then if mem[q].hh.rh<>-268435455 then if pen<10000 then
begin rtype:=mem[mem[q].hh.rh].hh.b0;
if rtype<>14 then if rtype<>21 then begin z:=newpenalty(pen);
mem[p].hh.rh:=z;p:=z;end;end{:784};if mem[q].hh.b0=33 then t:=22;
rtype:=t;83:r:=q;q:=mem[q].hh.rh;freenode(r,s);30:end{:777};
p:=newnullbox;mem[p].hh.rh:=mem[memtop-3].hh.rh;adjusthlist(p,false);
mem[memtop-3].hh.rh:=mem[p].hh.rh;deleteglueref(mem[p+7].hh.rh);
deleteglueref(mem[p+7].hh.lh);freenode(p,10);end;
{:743}{789:}procedure pushalignment;var p:halfword;begin p:=getnode(5);
mem[p].hh.rh:=alignptr;mem[p].hh.lh:=curalign;
mem[p+1].hh.lh:=mem[memtop-8].hh.rh;mem[p+1].hh.rh:=curspan;
mem[p+2].int:=curloop;mem[p+3].int:=alignstate;mem[p+4].hh.lh:=curhead;
mem[p+4].hh.rh:=curtail;alignptr:=p;curhead:=getavail;end;
procedure popalignment;var p:halfword;
begin begin mem[curhead].hh.rh:=avail;avail:=curhead;
ifdef('STAT')decr(dynused);endif('STAT')end;p:=alignptr;
curtail:=mem[p+4].hh.rh;curhead:=mem[p+4].hh.lh;
alignstate:=mem[p+3].int;curloop:=mem[p+2].int;curspan:=mem[p+1].hh.rh;
mem[memtop-8].hh.rh:=mem[p+1].hh.lh;curalign:=mem[p].hh.lh;
alignptr:=mem[p].hh.rh;freenode(p,5);end;
{:789}{791:}{799:}procedure getpreambletoken;label 20;begin 20:gettoken;
while(curchr=256)and(curcmd=4)do begin gettoken;
if curcmd>112 then begin expand;gettoken;end;end;
if curcmd=9 then fatalerror(645);
if(curcmd=81)and(curchr=24539)then begin scanoptionalequals;scanglue(2);
if eqtb[28974].int>0 then geqdefine(24539,129,curval)else eqdefine(24539
,129,curval);goto 20;end;end;{:799}procedure alignpeek;forward;
procedure normalparagraph;forward;procedure initalign;label 30,31,32,22;
var savecsptr:halfword;p:halfword;begin savecsptr:=curcs;pushalignment;
alignstate:=-1000000;
{793:}if(curlist.modefield=227)and((curlist.tailfield<>curlist.headfield
)or(curlist.auxfield.int<>-268435455))then begin begin if interaction=3
then;if filelineerrorstylep then printfileline else printnl(263);
print(741);end;printesc(561);print(989);begin helpptr:=3;
helpline[2]:=990;helpline[1]:=991;helpline[0]:=992;end;error;flushmath;
end{:793};pushnest;
{792:}if curlist.modefield=227 then begin curlist.modefield:=-1;
curlist.auxfield.int:=nest[nestptr-2].auxfield.int;
end else if curlist.modefield>0 then curlist.modefield:=-curlist.
modefield{:792};scanspec(6,false);{794:}mem[memtop-8].hh.rh:=-268435455;
curalign:=memtop-8;curloop:=-268435455;scannerstatus:=4;
warningindex:=savecsptr;alignstate:=-1000000;
while true do begin{795:}mem[curalign].hh.rh:=newparamglue(11);
curalign:=mem[curalign].hh.rh{:795};if curcmd=5 then goto 30;
{796:}{800:}p:=memtop-4;mem[p].hh.rh:=-268435455;
while true do begin getpreambletoken;if curcmd=6 then goto 31;
if(curcmd<=5)and(curcmd>=4)and(alignstate=-1000000)then if(p=memtop-4)
and(curloop=-268435455)and(curcmd=4)then curloop:=curalign else begin
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(998);
end;begin helpptr:=3;helpline[2]:=999;helpline[1]:=1000;
helpline[0]:=1001;end;backerror;goto 31;
end else if(curcmd<>10)or(p<>memtop-4)then begin mem[p].hh.rh:=getavail;
p:=mem[p].hh.rh;mem[p].hh.lh:=curtok;end;end;31:{:800};
mem[curalign].hh.rh:=newnullbox;curalign:=mem[curalign].hh.rh;
mem[curalign].hh.lh:=memtop-9;mem[curalign+1].int:=-1073741824;
mem[curalign+3].int:=mem[memtop-4].hh.rh;{801:}p:=memtop-4;
mem[p].hh.rh:=-268435455;while true do begin 22:getpreambletoken;
if(curcmd<=5)and(curcmd>=4)and(alignstate=-1000000)then goto 32;
if curcmd=6 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1002);
end;begin helpptr:=3;helpline[2]:=999;helpline[1]:=1000;
helpline[0]:=1003;end;error;goto 22;end;mem[p].hh.rh:=getavail;
p:=mem[p].hh.rh;mem[p].hh.lh:=curtok;end;32:mem[p].hh.rh:=getavail;
p:=mem[p].hh.rh;mem[p].hh.lh:=81054{:801};
mem[curalign+2].int:=mem[memtop-4].hh.rh{:796};end;
30:scannerstatus:=0{:794};newsavelevel(6);
if eqtb[25069].hh.rh<>-268435455 then begintokenlist(eqtb[25069].hh.rh,
13);alignpeek;end;{:791}{803:}{804:}procedure initspan(p:halfword);
begin pushnest;
if curlist.modefield=-114 then curlist.auxfield.hh.lh:=1000 else begin
curlist.auxfield.int:=-65536000;normalparagraph;end;curspan:=p;end;
{:804}procedure initrow;begin pushnest;
curlist.modefield:=(-115)-curlist.modefield;
if curlist.modefield=-114 then curlist.auxfield.hh.lh:=0 else curlist.
auxfield.int:=0;
begin mem[curlist.tailfield].hh.rh:=newglue(mem[mem[memtop-8].hh.rh+1].
hh.lh);curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=12;
curalign:=mem[mem[memtop-8].hh.rh].hh.rh;curtail:=curhead;
initspan(curalign);end;{:803}{805:}procedure initcol;
begin mem[curalign+5].hh.lh:=curcmd;
if curcmd=66 then alignstate:=0 else begin backinput;
begintokenlist(mem[curalign+3].int,1);end;end;
{:805}{808:}function fincol:boolean;label 10;var p:halfword;
q,r:halfword;s:halfword;u:halfword;w:scaled;o:glueord;n:halfword;
begin if curalign=-268435455 then confusion(1004);
q:=mem[curalign].hh.rh;if q=-268435455 then confusion(1004);
if alignstate<500000 then fatalerror(645);p:=mem[q].hh.rh;
{809:}if(p=-268435455)and(mem[curalign+5].hh.lh<257)then if curloop<>
-268435455 then{810:}begin mem[q].hh.rh:=newnullbox;p:=mem[q].hh.rh;
mem[p].hh.lh:=memtop-9;mem[p+1].int:=-1073741824;
curloop:=mem[curloop].hh.rh;{811:}q:=memtop-4;r:=mem[curloop+3].int;
while r<>-268435455 do begin mem[q].hh.rh:=getavail;q:=mem[q].hh.rh;
mem[q].hh.lh:=mem[r].hh.lh;r:=mem[r].hh.rh;end;mem[q].hh.rh:=-268435455;
mem[p+3].int:=mem[memtop-4].hh.rh;q:=memtop-4;r:=mem[curloop+2].int;
while r<>-268435455 do begin mem[q].hh.rh:=getavail;q:=mem[q].hh.rh;
mem[q].hh.lh:=mem[r].hh.lh;r:=mem[r].hh.rh;end;mem[q].hh.rh:=-268435455;
mem[p+2].int:=mem[memtop-4].hh.rh{:811};curloop:=mem[curloop].hh.rh;
mem[p].hh.rh:=newglue(mem[curloop+1].hh.lh);
end{:810}else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1005);
end;printesc(994);begin helpptr:=3;helpline[2]:=1006;helpline[1]:=1007;
helpline[0]:=1008;end;mem[curalign+5].hh.lh:=257;error;end{:809};
if mem[curalign+5].hh.lh<>256 then begin unsave;newsavelevel(6);
{813:}begin if curlist.modefield=-114 then begin adjusttail:=curtail;
adjusthlist(curlist.headfield,false);deleteglueref(curkanjiskip);
deleteglueref(curxkanjiskip);
curkanjiskip:=mem[curlist.headfield+7].hh.rh;
curxkanjiskip:=mem[curlist.headfield+7].hh.lh;
incr(mem[curkanjiskip].hh.rh);incr(mem[curxkanjiskip].hh.rh);
u:=hpack(mem[curlist.headfield].hh.rh,0,1);w:=mem[u+1].int;
curtail:=adjusttail;adjusttail:=-268435455;
end else begin u:=vpackage(mem[curlist.headfield].hh.rh,0,1,0);
w:=mem[u+3].int;end;n:=0;
if curspan<>curalign then{815:}begin q:=curspan;repeat incr(n);
q:=mem[mem[q].hh.rh].hh.rh;until q=curalign;
if n>65535 then confusion(1009);q:=curspan;
while mem[mem[q].hh.lh].hh.rh<n do q:=mem[q].hh.lh;
if mem[mem[q].hh.lh].hh.rh>n then begin s:=getnode(2);
mem[s].hh.lh:=mem[q].hh.lh;mem[s].hh.rh:=n;mem[q].hh.lh:=s;
mem[s+1].int:=w;
end else if mem[mem[q].hh.lh+1].int<w then mem[mem[q].hh.lh+1].int:=w;
end{:815}else if w>mem[curalign+1].int then mem[curalign+1].int:=w;
mem[u].hh.b0:=15;mem[u].hh.b1:=n;
{676:}if totalstretch[4]<>0 then o:=4 else if totalstretch[3]<>0 then o
:=3 else if totalstretch[2]<>0 then o:=2 else if totalstretch[1]<>0 then
o:=1 else o:=0{:676};mem[u+5].hh.b1:=o;mem[u+6].int:=totalstretch[o];
{682:}if totalshrink[4]<>0 then o:=4 else if totalshrink[3]<>0 then o:=3
else if totalshrink[2]<>0 then o:=2 else if totalshrink[1]<>0 then o:=1
else o:=0{:682};mem[u+5].hh.b0:=o;mem[u+4].int:=totalshrink[o];popnest;
mem[curlist.tailfield].hh.rh:=u;curlist.tailfield:=u;end{:813};
{812:}begin mem[curlist.tailfield].hh.rh:=newglue(mem[mem[curalign].hh.
rh+1].hh.lh);curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=12{:812};
if mem[curalign+5].hh.lh>=257 then begin fincol:=true;goto 10;end;
initspan(p);end;alignstate:=1000000;repeat getxorprotected;
until curcmd<>10;curalign:=p;initcol;fincol:=false;10:end;
{:808}{816:}procedure finrow;var p:halfword;
begin if curlist.modefield=-114 then begin adjusthlist(curlist.headfield
,false);deleteglueref(curkanjiskip);deleteglueref(curxkanjiskip);
curkanjiskip:=mem[curlist.headfield+7].hh.rh;
curxkanjiskip:=mem[curlist.headfield+7].hh.lh;
incr(mem[curkanjiskip].hh.rh);incr(mem[curxkanjiskip].hh.rh);
p:=hpack(mem[curlist.headfield].hh.rh,0,1);popnest;appendtovlist(p);
if curhead<>curtail then begin mem[curlist.tailfield].hh.rh:=mem[curhead
].hh.rh;curlist.tailfield:=curtail;end;
end else begin p:=vpackage(mem[curlist.headfield].hh.rh,0,1,1073741823);
popnest;mem[curlist.tailfield].hh.rh:=p;curlist.tailfield:=p;
curlist.auxfield.hh.lh:=1000;end;mem[p].hh.b0:=15;mem[p+6].int:=0;
if eqtb[25069].hh.rh<>-268435455 then begintokenlist(eqtb[25069].hh.rh,
13);alignpeek;end;{:816}{817:}procedure doassignments;forward;
procedure resumeafterdisplay;forward;procedure buildpage;forward;
procedure finalign;var p,q,r,s,u,v,z:halfword;t,w:scaled;o:scaled;
n:halfword;rulesave:scaled;auxsave:memoryword;
begin if curgroup<>6 then confusion(1010);unsave;
if curgroup<>6 then confusion(1011);unsave;
if nest[nestptr-1].modefield=227 then o:=eqtb[29529].int else o:=0;
{818:}q:=mem[mem[memtop-8].hh.rh].hh.rh;repeat flushlist(mem[q+3].int);
flushlist(mem[q+2].int);p:=mem[mem[q].hh.rh].hh.rh;
if mem[q+1].int=-1073741824 then{819:}begin mem[q+1].int:=0;
r:=mem[q].hh.rh;s:=mem[r+1].hh.lh;
if s<>membot then begin incr(mem[membot].hh.rh);deleteglueref(s);
mem[r+1].hh.lh:=membot;end;end{:819};
if mem[q].hh.lh<>memtop-9 then{820:}begin t:=mem[q+1].int+mem[mem[mem[q]
.hh.rh+1].hh.lh+1].int;r:=mem[q].hh.lh;s:=memtop-9;mem[s].hh.lh:=p;n:=1;
repeat mem[r+1].int:=mem[r+1].int-t;u:=mem[r].hh.lh;
while mem[r].hh.rh>n do begin s:=mem[s].hh.lh;
n:=mem[mem[s].hh.lh].hh.rh+1;end;
if mem[r].hh.rh<n then begin mem[r].hh.lh:=mem[s].hh.lh;mem[s].hh.lh:=r;
decr(mem[r].hh.rh);s:=r;
end else begin if mem[r+1].int>mem[mem[s].hh.lh+1].int then mem[mem[s].
hh.lh+1].int:=mem[r+1].int;freenode(r,2);end;r:=u;until r=memtop-9;
end{:820};mem[q].hh.b0:=15;mem[q].hh.b1:=0;mem[q+3].int:=0;
mem[q+2].int:=0;mem[q+5].hh.b1:=0;mem[q+5].hh.b0:=0;mem[q+6].int:=0;
mem[q+4].int:=0;q:=p;until q=-268435455{:818};{821:}saveptr:=saveptr-2;
packbeginline:=-curlist.mlfield;
if curlist.modefield=-1 then begin rulesave:=eqtb[29530].int;
eqtb[29530].int:=0;z:=newnullbox;mem[z].hh.rh:=mem[memtop-8].hh.rh;
adjusthlist(z,false);deleteglueref(curkanjiskip);
deleteglueref(curxkanjiskip);curkanjiskip:=mem[z+7].hh.rh;
curxkanjiskip:=mem[z+7].hh.lh;incr(mem[curkanjiskip].hh.rh);
incr(mem[curxkanjiskip].hh.rh);
p:=hpack(mem[memtop-8].hh.rh,savestack[saveptr+1].int,savestack[saveptr
+0].int);eqtb[29530].int:=rulesave;deleteglueref(mem[z+7].hh.rh);
deleteglueref(mem[z+7].hh.lh);freenode(z,10);
end else begin q:=mem[mem[memtop-8].hh.rh].hh.rh;
repeat mem[q+3].int:=mem[q+1].int;mem[q+1].int:=0;
q:=mem[mem[q].hh.rh].hh.rh;until q=-268435455;
p:=vpackage(mem[memtop-8].hh.rh,savestack[saveptr+1].int,savestack[
saveptr+0].int,1073741823);q:=mem[mem[memtop-8].hh.rh].hh.rh;
repeat mem[q+1].int:=mem[q+3].int;mem[q+3].int:=0;
q:=mem[mem[q].hh.rh].hh.rh;until q=-268435455;end;
packbeginline:=0{:821};{822:}q:=mem[curlist.headfield].hh.rh;
s:=curlist.headfield;
while q<>-268435455 do begin if not(q>=himemmin)then if mem[q].hh.b0=15
then{824:}begin if curlist.modefield=-1 then begin mem[q].hh.b0:=0;
mem[q+1].int:=mem[p+1].int;
if nest[nestptr-1].modefield=227 then mem[q].hh.b1:=((mem[q].hh.b1)mod 8
)+8*(2);end else begin mem[q].hh.b0:=1;mem[q+3].int:=mem[p+3].int;end;
mem[q].hh.b1:=((mem[q].hh.b1)div 8)*8+abs(curlist.dirfield);
mem[q+5].hh.b1:=mem[p+5].hh.b1;mem[q+5].hh.b0:=mem[p+5].hh.b0;
mem[q+6].gr:=mem[p+6].gr;mem[q+4].int:=o;r:=mem[mem[q+5].hh.rh].hh.rh;
s:=mem[mem[p+5].hh.rh].hh.rh;repeat{825:}n:=mem[r].hh.b1;
t:=mem[s+1].int;w:=t;u:=memtop-4;
mem[r].hh.b1:=((mem[r].hh.b1)mod 8)+8*(0);while n>0 do begin decr(n);
{826:}s:=mem[s].hh.rh;v:=mem[s+1].hh.lh;mem[u].hh.rh:=newglue(v);
u:=mem[u].hh.rh;mem[u].hh.b1:=12;t:=t+mem[v+1].int;
if mem[p+5].hh.b0=1 then begin if mem[v].hh.b0=mem[p+5].hh.b1 then t:=t+
round(mem[p+6].gr*mem[v+2].int);
end else if mem[p+5].hh.b0=2 then begin if mem[v].hh.b1=mem[p+5].hh.b1
then t:=t-round(mem[p+6].gr*mem[v+3].int);end;s:=mem[s].hh.rh;
mem[u].hh.rh:=newnullbox;u:=mem[u].hh.rh;t:=t+mem[s+1].int;
if curlist.modefield=-1 then mem[u+1].int:=mem[s+1].int else begin mem[u
].hh.b0:=1;mem[u+3].int:=mem[s+1].int;end;
mem[u].hh.b1:=((mem[u].hh.b1)div 8)*8+abs(curlist.dirfield){:826};end;
if curlist.modefield=-1 then{827:}begin mem[r+3].int:=mem[q+3].int;
mem[r+2].int:=mem[q+2].int;
if t=mem[r+1].int then begin mem[r+5].hh.b0:=0;mem[r+5].hh.b1:=0;
mem[r+6].gr:=0.0;
end else if t>mem[r+1].int then begin mem[r+5].hh.b0:=1;
if mem[r+6].int=0 then mem[r+6].gr:=0.0 else mem[r+6].gr:=(t-mem[r+1].
int)/mem[r+6].int;end else begin mem[r+5].hh.b1:=mem[r+5].hh.b0;
mem[r+5].hh.b0:=2;
if mem[r+4].int=0 then mem[r+6].gr:=0.0 else if(mem[r+5].hh.b1=0)and(mem
[r+1].int-t>mem[r+4].int)then mem[r+6].gr:=1.0 else mem[r+6].gr:=(mem[r
+1].int-t)/mem[r+4].int;end;mem[r+1].int:=w;mem[r].hh.b0:=0;
mem[r].hh.b1:=((mem[r].hh.b1)div 8)*8+abs(curlist.dirfield);
end{:827}else{828:}begin mem[r+1].int:=mem[q+1].int;
if t=mem[r+3].int then begin mem[r+5].hh.b0:=0;mem[r+5].hh.b1:=0;
mem[r+6].gr:=0.0;
end else if t>mem[r+3].int then begin mem[r+5].hh.b0:=1;
if mem[r+6].int=0 then mem[r+6].gr:=0.0 else mem[r+6].gr:=(t-mem[r+3].
int)/mem[r+6].int;end else begin mem[r+5].hh.b1:=mem[r+5].hh.b0;
mem[r+5].hh.b0:=2;
if mem[r+4].int=0 then mem[r+6].gr:=0.0 else if(mem[r+5].hh.b1=0)and(mem
[r+3].int-t>mem[r+4].int)then mem[r+6].gr:=1.0 else mem[r+6].gr:=(mem[r
+3].int-t)/mem[r+4].int;end;mem[r+3].int:=w;mem[r].hh.b0:=1;
mem[r].hh.b1:=((mem[r].hh.b1)div 8)*8+abs(curlist.dirfield);end{:828};
mem[r+4].int:=0;if u<>memtop-4 then begin mem[u].hh.rh:=mem[r].hh.rh;
mem[r].hh.rh:=mem[memtop-4].hh.rh;r:=u;end{:825};
r:=mem[mem[r].hh.rh].hh.rh;s:=mem[mem[s].hh.rh].hh.rh;
until r=-268435455;
end{:824}else if mem[q].hh.b0=3 then{823:}begin if(mem[q+1].int=
-1073741824)then mem[q+1].int:=mem[p+1].int;
if(mem[q+3].int=-1073741824)then mem[q+3].int:=mem[p+3].int;
if(mem[q+2].int=-1073741824)then mem[q+2].int:=mem[p+2].int;
if o<>0 then begin r:=mem[q].hh.rh;mem[q].hh.rh:=-268435455;
q:=hpack(q,0,1);mem[q+4].int:=o;mem[q].hh.rh:=r;mem[s].hh.rh:=q;end;
end{:823};s:=q;q:=mem[q].hh.rh;end{:822};flushnodelist(p);popalignment;
{829:}auxsave:=curlist.auxfield;p:=mem[curlist.headfield].hh.rh;
q:=curlist.tailfield;popnest;
if curlist.modefield=227 then{1224:}begin doassignments;
if curcmd<>3 then{1225:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1292);
end;begin helpptr:=2;helpline[1]:=990;helpline[0]:=991;end;backerror;
end{:1225}else{1215:}begin getxtoken;
if curcmd<>3 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1288);
end;begin helpptr:=2;helpline[1]:=1289;helpline[0]:=1290;end;backerror;
end;end{:1215};flushnodelist(curlist.eTeXauxfield);popnest;
begin mem[curlist.tailfield].hh.rh:=newpenalty(eqtb[28942].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
begin mem[curlist.tailfield].hh.rh:=newparamglue(3);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.rh:=p;
if p<>-268435455 then curlist.tailfield:=q;
begin mem[curlist.tailfield].hh.rh:=newpenalty(eqtb[28943].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
begin mem[curlist.tailfield].hh.rh:=newparamglue(4);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
curlist.auxfield.int:=auxsave.int;resumeafterdisplay;
end{:1224}else begin curlist.auxfield:=auxsave;
mem[curlist.tailfield].hh.rh:=p;
if p<>-268435455 then curlist.tailfield:=q;
if curlist.modefield=1 then buildpage;end{:829};end;
{802:}procedure alignpeek;label 20;begin 20:alignstate:=1000000;
repeat getxorprotected;until curcmd<>10;
if curcmd=37 then begin scanleftbrace;newsavelevel(7);
if curlist.modefield=-1 then normalparagraph;
end else if curcmd=2 then finalign else if(curcmd=5)and(curchr=258)then
goto 20 else begin initrow;initcol;end;end;
{:802}{:817}{832:}{843:}function finiteshrink(p:halfword):halfword;
var q:halfword;
begin if noshrinkerroryet then begin noshrinkerroryet:=false;
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1012);
end;begin helpptr:=5;helpline[4]:=1013;helpline[3]:=1014;
helpline[2]:=1015;helpline[1]:=1016;helpline[0]:=1017;end;error;end;
q:=newspec(p);mem[q].hh.b1:=0;deleteglueref(p);finiteshrink:=q;end;
{:843}{846:}procedure trybreak(pi:integer;breaktype:smallnumber);
label 10,30,31,22,60,40,45;var r:halfword;prevr:halfword;oldl:halfword;
nobreakyet:boolean;{847:}prevprevr:halfword;s:halfword;q:halfword;
v:halfword;t:integer;f:internalfontnumber;l:halfword;
noderstaysactive:boolean;linewidth:scaled;fitclass:0..3;b:halfword;
d:integer;artificialdemerits:boolean;savelink:halfword;shortfall:scaled;
{:847}{1598:}g:scaled;
{:1598}begin{848:}if abs(pi)>=10000 then if pi>0 then goto 10 else pi:=
-10000{:848};nobreakyet:=true;prevr:=memtop-7;oldl:=0;
curactivewidth[1]:=activewidth[1];curactivewidth[2]:=activewidth[2];
curactivewidth[3]:=activewidth[3];curactivewidth[4]:=activewidth[4];
curactivewidth[5]:=activewidth[5];curactivewidth[6]:=activewidth[6];
curactivewidth[7]:=activewidth[7];
while true do begin 22:r:=mem[prevr].hh.rh;
{849:}if mem[r].hh.b0=2 then begin curactivewidth[1]:=curactivewidth[1]+
mem[r+1].int;curactivewidth[2]:=curactivewidth[2]+mem[r+2].int;
curactivewidth[3]:=curactivewidth[3]+mem[r+3].int;
curactivewidth[4]:=curactivewidth[4]+mem[r+4].int;
curactivewidth[5]:=curactivewidth[5]+mem[r+5].int;
curactivewidth[6]:=curactivewidth[6]+mem[r+6].int;
curactivewidth[7]:=curactivewidth[7]+mem[r+7].int;prevprevr:=prevr;
prevr:=r;goto 22;end{:849};{852:}begin l:=mem[r+1].hh.lh;
if l>oldl then begin if(minimumdemerits<1073741823)and((oldl<>easyline)
or(r=memtop-7))then{853:}begin if nobreakyet then{854:}begin nobreakyet
:=false;breakwidth[1]:=background[1];breakwidth[2]:=background[2];
breakwidth[3]:=background[3];breakwidth[4]:=background[4];
breakwidth[5]:=background[5];breakwidth[6]:=background[6];
breakwidth[7]:=background[7];s:=curp;
if breaktype>0 then if curp<>-268435455 then{857:}begin t:=mem[curp].hh.
b1;v:=curp;s:=mem[curp+1].hh.rh;while t>0 do begin decr(t);
v:=mem[v].hh.rh;{858:}if(v>=himemmin)then begin f:=mem[v].hh.b0;
breakwidth[1]:=breakwidth[1]-fontinfo[widthbase[f]+fontinfo[charbase[f]+
mem[v].hh.b1].qqqq.b0].int;if fontdir[f]<>0 then v:=mem[v].hh.rh;
end else case mem[v].hh.b0 of 8:begin f:=mem[v+1].hh.b0;
breakwidth[1]:=breakwidth[1]-fontinfo[widthbase[f]+fontinfo[charbase[f]+
mem[v+1].hh.b1].qqqq.b0].int;end;
0,1,2,3,13:breakwidth[1]:=breakwidth[1]-mem[v+1].int;5:;
others:confusion(1018)end{:858};end;
while s<>-268435455 do begin{859:}if(s>=himemmin)then begin f:=mem[s].hh
.b0;
breakwidth[1]:=breakwidth[1]+fontinfo[widthbase[f]+fontinfo[charbase[f]+
mem[s].hh.b1].qqqq.b0].int;if fontdir[f]<>0 then s:=mem[s].hh.rh;
end else case mem[s].hh.b0 of 8:begin f:=mem[s+1].hh.b0;
breakwidth[1]:=breakwidth[1]+fontinfo[widthbase[f]+fontinfo[charbase[f]+
mem[s+1].hh.b1].qqqq.b0].int;end;
0,1,2,3,13:breakwidth[1]:=breakwidth[1]+mem[s+1].int;5:;
others:confusion(1019)end{:859};s:=mem[s].hh.rh;end;
breakwidth[1]:=breakwidth[1]+discwidth;
if mem[curp+1].hh.rh=-268435455 then s:=mem[v].hh.rh;end{:857};
while s<>-268435455 do begin if(s>=himemmin)then begin if chain then
begin breakwidth[1]:=breakwidth[1]-mem[curkanjiskip+1].int;
breakwidth[2+mem[curkanjiskip].hh.b0]:=breakwidth[2+mem[curkanjiskip].hh
.b0]-mem[curkanjiskip+2].int;
breakwidth[7]:=breakwidth[7]-mem[curkanjiskip+3].int;end;goto 30 end;
case mem[s].hh.b0 of 12:{855:}begin v:=mem[s+1].hh.lh;
breakwidth[1]:=breakwidth[1]-mem[v+1].int;
breakwidth[2+mem[v].hh.b0]:=breakwidth[2+mem[v].hh.b0]-mem[v+2].int;
breakwidth[7]:=breakwidth[7]-mem[v+3].int;end{:855};14:;
11:breakwidth[1]:=breakwidth[1]-mem[s+1].int;
13:if(mem[s].hh.b1<>1)and(mem[s].hh.b1<>3)then goto 30 else breakwidth[1
]:=breakwidth[1]-mem[s+1].int;others:goto 30 end;s:=mem[s].hh.rh;end;
30:end{:854};
{860:}if mem[prevr].hh.b0=2 then begin mem[prevr+1].int:=mem[prevr+1].
int-curactivewidth[1]+breakwidth[1];
mem[prevr+2].int:=mem[prevr+2].int-curactivewidth[2]+breakwidth[2];
mem[prevr+3].int:=mem[prevr+3].int-curactivewidth[3]+breakwidth[3];
mem[prevr+4].int:=mem[prevr+4].int-curactivewidth[4]+breakwidth[4];
mem[prevr+5].int:=mem[prevr+5].int-curactivewidth[5]+breakwidth[5];
mem[prevr+6].int:=mem[prevr+6].int-curactivewidth[6]+breakwidth[6];
mem[prevr+7].int:=mem[prevr+7].int-curactivewidth[7]+breakwidth[7];
end else if prevr=memtop-7 then begin activewidth[1]:=breakwidth[1];
activewidth[2]:=breakwidth[2];activewidth[3]:=breakwidth[3];
activewidth[4]:=breakwidth[4];activewidth[5]:=breakwidth[5];
activewidth[6]:=breakwidth[6];activewidth[7]:=breakwidth[7];
end else begin q:=getnode(8);mem[q].hh.rh:=r;mem[q].hh.b0:=2;
mem[q].hh.b1:=0;mem[q+1].int:=breakwidth[1]-curactivewidth[1];
mem[q+2].int:=breakwidth[2]-curactivewidth[2];
mem[q+3].int:=breakwidth[3]-curactivewidth[3];
mem[q+4].int:=breakwidth[4]-curactivewidth[4];
mem[q+5].int:=breakwidth[5]-curactivewidth[5];
mem[q+6].int:=breakwidth[6]-curactivewidth[6];
mem[q+7].int:=breakwidth[7]-curactivewidth[7];mem[prevr].hh.rh:=q;
prevprevr:=prevr;prevr:=q;end{:860};
if abs(eqtb[28947].int)>=1073741823-minimumdemerits then minimumdemerits
:=1073741822 else minimumdemerits:=minimumdemerits+abs(eqtb[28947].int);
for fitclass:=0 to 3 do begin if minimaldemerits[fitclass]<=
minimumdemerits then{862:}begin q:=getnode(2);mem[q].hh.rh:=passive;
passive:=q;mem[q+1].hh.rh:=curp;ifdef('STAT')incr(passnumber);
mem[q].hh.lh:=passnumber;
endif('STAT')mem[q+1].hh.lh:=bestplace[fitclass];
q:=getnode(activenodesize);mem[q+1].hh.rh:=passive;
mem[q+1].hh.lh:=bestplline[fitclass]+1;mem[q].hh.b1:=fitclass;
mem[q].hh.b0:=breaktype;mem[q+2].int:=minimaldemerits[fitclass];
if dolastlinefit then{1605:}begin mem[q+3].int:=bestplshort[fitclass];
mem[q+4].int:=bestplglue[fitclass];end{:1605};mem[q].hh.rh:=r;
mem[prevr].hh.rh:=q;prevr:=q;
ifdef('STAT')if eqtb[28963].int>0 then{863:}begin printnl(1020);
printint(mem[passive].hh.lh);print(1021);printint(mem[q+1].hh.lh-1);
printchar(46);printint(fitclass);if breaktype=1 then printchar(45);
print(1022);printint(mem[q+2].int);
if dolastlinefit then{1606:}begin print(1548);printscaled(mem[q+3].int);
if curp=-268435455 then print(1549)else print(1093);
printscaled(mem[q+4].int);end{:1606};print(1023);
if mem[passive+1].hh.lh=-268435455 then printchar(48)else printint(mem[
mem[passive+1].hh.lh].hh.lh);end{:863};endif('STAT')end{:862};
minimaldemerits[fitclass]:=1073741823;end;minimumdemerits:=1073741823;
{861:}if r<>memtop-7 then begin q:=getnode(8);mem[q].hh.rh:=r;
mem[q].hh.b0:=2;mem[q].hh.b1:=0;
mem[q+1].int:=curactivewidth[1]-breakwidth[1];
mem[q+2].int:=curactivewidth[2]-breakwidth[2];
mem[q+3].int:=curactivewidth[3]-breakwidth[3];
mem[q+4].int:=curactivewidth[4]-breakwidth[4];
mem[q+5].int:=curactivewidth[5]-breakwidth[5];
mem[q+6].int:=curactivewidth[6]-breakwidth[6];
mem[q+7].int:=curactivewidth[7]-breakwidth[7];mem[prevr].hh.rh:=q;
prevprevr:=prevr;prevr:=q;end{:861};end{:853};
if r=memtop-7 then goto 10;
{867:}if l>easyline then begin linewidth:=secondwidth;oldl:=268435454;
end else begin oldl:=l;
if l>lastspecialline then linewidth:=secondwidth else if eqtb[25061].hh.
rh=-268435455 then linewidth:=firstwidth else linewidth:=mem[eqtb[25061]
.hh.rh+2*l].int;end{:867};end;end{:852};
{868:}begin artificialdemerits:=false;
shortfall:=linewidth-curactivewidth[1];
if shortfall>0 then{869:}if(curactivewidth[3]<>0)or(curactivewidth[4]<>0
)or(curactivewidth[5]<>0)or(curactivewidth[6]<>0)then begin if
dolastlinefit then begin if curp=-268435455 then{1600:}begin if(mem[r+3]
.int=0)or(mem[r+4].int<=0)then goto 45;
if(curactivewidth[3]<>fillwidth[0])or(curactivewidth[4]<>fillwidth[1])or
(curactivewidth[5]<>fillwidth[2])or(curactivewidth[6]<>fillwidth[3])then
goto 45;
if mem[r+3].int>0 then g:=curactivewidth[2]else g:=curactivewidth[7];
if g<=0 then goto 45;aritherror:=false;
g:=fract(g,mem[r+3].int,mem[r+4].int,1073741823);
if eqtb[28998].int<1000 then g:=fract(g,eqtb[28998].int,1000,1073741823)
;if aritherror then if mem[r+3].int>0 then g:=1073741823 else g:=
-1073741823;if g>0 then{1601:}begin if g>shortfall then g:=shortfall;
if g>7230584 then if curactivewidth[2]<1663497 then begin b:=10000;
fitclass:=0;goto 40;end;b:=badness(g,curactivewidth[2]);
if b>12 then if b>99 then fitclass:=0 else fitclass:=1 else fitclass:=2;
goto 40;
end{:1601}else if g<0 then{1602:}begin if-g>curactivewidth[7]then g:=-
curactivewidth[7];b:=badness(-g,curactivewidth[7]);
if b>12 then fitclass:=3 else fitclass:=2;goto 40;end{:1602};
45:end{:1600};shortfall:=0;end;b:=0;fitclass:=2;
end else begin if shortfall>7230584 then if curactivewidth[2]<1663497
then begin b:=10000;fitclass:=0;goto 31;end;
b:=badness(shortfall,curactivewidth[2]);
if b>12 then if b>99 then fitclass:=0 else fitclass:=1 else fitclass:=2;
31:end{:869}else{870:}begin if-shortfall>curactivewidth[7]then b:=10001
else b:=badness(-shortfall,curactivewidth[7]);
if b>12 then fitclass:=3 else fitclass:=2;end{:870};
if dolastlinefit then{1603:}begin if curp=-268435455 then shortfall:=0;
if shortfall>0 then g:=curactivewidth[2]else if shortfall<0 then g:=
curactivewidth[7]else g:=0;end{:1603};
40:if(b>10000)or(pi=-10000)then{871:}begin if finalpass and(
minimumdemerits=1073741823)and(mem[r].hh.rh=memtop-7)and(prevr=memtop-7)
then artificialdemerits:=true else if b>threshold then goto 60;
noderstaysactive:=false;end{:871}else begin prevr:=r;
if b>threshold then goto 22;noderstaysactive:=true;end;
{872:}if artificialdemerits then d:=0 else{876:}begin d:=eqtb[28933].int
+b;if abs(d)>=10000 then d:=100000000 else d:=d*d;
if pi<>0 then if pi>0 then d:=d+pi*pi else if pi>-10000 then d:=d-pi*pi;
if(breaktype=1)and(mem[r].hh.b0=1)then if curp<>-268435455 then d:=d+
eqtb[28945].int else d:=d+eqtb[28946].int;
if abs(fitclass-mem[r].hh.b1)>1 then d:=d+eqtb[28947].int;end{:876};
ifdef('STAT')if eqtb[28963].int>0 then{873:}begin if printednode<>curp
then{874:}begin printnl(343);
if curp=-268435455 then shortdisplay(mem[printednode].hh.rh)else begin
savelink:=mem[curp].hh.rh;mem[curp].hh.rh:=-268435455;printnl(343);
shortdisplay(mem[printednode].hh.rh);mem[curp].hh.rh:=savelink;end;
printednode:=curp;end{:874};printnl(64);
if curp=-268435455 then printesc(647)else if(mem[curp].hh.b0<>12)and(not
(curp>=himemmin))then begin if mem[curp].hh.b0=14 then printesc(575)else
if mem[curp].hh.b0=9 then printesc(358)else if mem[curp].hh.b0=13 then
printesc(345)else printesc(350);end;print(1024);
if mem[r+1].hh.rh=-268435455 then printchar(48)else printint(mem[mem[r+1
].hh.rh].hh.lh);print(1025);
if b>10000 then printchar(42)else printint(b);print(1026);printint(pi);
print(1027);if artificialdemerits then printchar(42)else printint(d);
end{:873};endif('STAT')d:=d+mem[r+2].int;
if d<=minimaldemerits[fitclass]then begin minimaldemerits[fitclass]:=d;
bestplace[fitclass]:=mem[r+1].hh.rh;bestplline[fitclass]:=l;
if dolastlinefit then{1604:}begin bestplshort[fitclass]:=shortfall;
bestplglue[fitclass]:=g;end{:1604};
if d<minimumdemerits then minimumdemerits:=d;end{:872};
if noderstaysactive then goto 22;
60:{877:}mem[prevr].hh.rh:=mem[r].hh.rh;freenode(r,activenodesize);
if prevr=memtop-7 then{878:}begin r:=mem[memtop-7].hh.rh;
if mem[r].hh.b0=2 then begin activewidth[1]:=activewidth[1]+mem[r+1].int
;activewidth[2]:=activewidth[2]+mem[r+2].int;
activewidth[3]:=activewidth[3]+mem[r+3].int;
activewidth[4]:=activewidth[4]+mem[r+4].int;
activewidth[5]:=activewidth[5]+mem[r+5].int;
activewidth[6]:=activewidth[6]+mem[r+6].int;
activewidth[7]:=activewidth[7]+mem[r+7].int;
curactivewidth[1]:=activewidth[1];curactivewidth[2]:=activewidth[2];
curactivewidth[3]:=activewidth[3];curactivewidth[4]:=activewidth[4];
curactivewidth[5]:=activewidth[5];curactivewidth[6]:=activewidth[6];
curactivewidth[7]:=activewidth[7];mem[memtop-7].hh.rh:=mem[r].hh.rh;
freenode(r,8);end;
end{:878}else if mem[prevr].hh.b0=2 then begin r:=mem[prevr].hh.rh;
if r=memtop-7 then begin curactivewidth[1]:=curactivewidth[1]-mem[prevr
+1].int;curactivewidth[2]:=curactivewidth[2]-mem[prevr+2].int;
curactivewidth[3]:=curactivewidth[3]-mem[prevr+3].int;
curactivewidth[4]:=curactivewidth[4]-mem[prevr+4].int;
curactivewidth[5]:=curactivewidth[5]-mem[prevr+5].int;
curactivewidth[6]:=curactivewidth[6]-mem[prevr+6].int;
curactivewidth[7]:=curactivewidth[7]-mem[prevr+7].int;
mem[prevprevr].hh.rh:=memtop-7;freenode(prevr,8);prevr:=prevprevr;
end else if mem[r].hh.b0=2 then begin curactivewidth[1]:=curactivewidth[
1]+mem[r+1].int;curactivewidth[2]:=curactivewidth[2]+mem[r+2].int;
curactivewidth[3]:=curactivewidth[3]+mem[r+3].int;
curactivewidth[4]:=curactivewidth[4]+mem[r+4].int;
curactivewidth[5]:=curactivewidth[5]+mem[r+5].int;
curactivewidth[6]:=curactivewidth[6]+mem[r+6].int;
curactivewidth[7]:=curactivewidth[7]+mem[r+7].int;
mem[prevr+1].int:=mem[prevr+1].int+mem[r+1].int;
mem[prevr+2].int:=mem[prevr+2].int+mem[r+2].int;
mem[prevr+3].int:=mem[prevr+3].int+mem[r+3].int;
mem[prevr+4].int:=mem[prevr+4].int+mem[r+4].int;
mem[prevr+5].int:=mem[prevr+5].int+mem[r+5].int;
mem[prevr+6].int:=mem[prevr+6].int+mem[r+6].int;
mem[prevr+7].int:=mem[prevr+7].int+mem[r+7].int;
mem[prevr].hh.rh:=mem[r].hh.rh;freenode(r,8);end;end{:877};end{:868};
end;
10:ifdef('STAT'){875:}if curp=printednode then if curp<>-268435455 then
if mem[curp].hh.b0=9 then begin t:=mem[curp].hh.b1;
while t>0 do begin decr(t);printednode:=mem[printednode].hh.rh;end;
end{:875}endif('STAT')end;
{:846}{894:}procedure postlinebreak(d:boolean);label 30,31;
var q,r,s:halfword;discbreak:boolean;postdiscbreak:boolean;
curwidth:scaled;curindent:scaled;t:quarterword;pen:integer;
curline:halfword;LRptr:halfword;begin LRptr:=curlist.eTeXauxfield;
{895:}q:=mem[bestbet+1].hh.rh;curp:=-268435455;repeat r:=q;
q:=mem[q+1].hh.lh;mem[r+1].hh.lh:=curp;curp:=r;until q=-268435455{:895};
curline:=curlist.pgfield+1;lastdisp:=0;
repeat{897:}if(eqtb[29001].int>0)then{1457:}begin q:=mem[memtop-3].hh.rh
;if LRptr<>-268435455 then begin tempptr:=LRptr;r:=q;
repeat s:=newmath(0,(mem[tempptr].hh.lh-1));mem[s].hh.rh:=r;r:=s;
tempptr:=mem[tempptr].hh.rh;until tempptr=-268435455;
mem[memtop-3].hh.rh:=r;end;
while q<>mem[curp+1].hh.rh do begin if not(q>=himemmin)then if mem[q].hh
.b0=11 then{1458:}if odd(mem[q].hh.b1)then begin if LRptr<>-268435455
then if mem[LRptr].hh.lh=(4*(mem[q].hh.b1 div 4)+3)then begin tempptr:=
LRptr;LRptr:=mem[tempptr].hh.rh;begin mem[tempptr].hh.rh:=avail;
avail:=tempptr;ifdef('STAT')decr(dynused);endif('STAT')end;end;
end else begin tempptr:=getavail;
mem[tempptr].hh.lh:=(4*(mem[q].hh.b1 div 4)+3);
mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;end{:1458};q:=mem[q].hh.rh;end;
end{:1457};{898:}q:=mem[curp+1].hh.rh;discbreak:=false;
postdiscbreak:=false;
if q<>-268435455 then begin if not(q>=himemmin)then if mem[q].hh.b0=12
then begin deleteglueref(mem[q+1].hh.lh);
mem[q+1].hh.lh:=eqtb[24536].hh.rh;mem[q].hh.b1:=9;
incr(mem[eqtb[24536].hh.rh].hh.rh);goto 30;
end else begin if mem[q].hh.b0=9 then{899:}begin t:=mem[q].hh.b1;
{900:}if t=0 then r:=mem[q].hh.rh else begin r:=q;
while t>1 do begin r:=mem[r].hh.rh;decr(t);end;s:=mem[r].hh.rh;
r:=mem[s].hh.rh;mem[s].hh.rh:=-268435455;flushnodelist(mem[q].hh.rh);
mem[q].hh.b1:=0;end{:900};
if mem[q+1].hh.rh<>-268435455 then{901:}begin s:=mem[q+1].hh.rh;
while mem[s].hh.rh<>-268435455 do s:=mem[s].hh.rh;mem[s].hh.rh:=r;
r:=mem[q+1].hh.rh;mem[q+1].hh.rh:=-268435455;postdiscbreak:=true;
end{:901};
if mem[q+1].hh.lh<>-268435455 then{902:}begin s:=mem[q+1].hh.lh;
mem[q].hh.rh:=s;while mem[s].hh.rh<>-268435455 do s:=mem[s].hh.rh;
mem[q+1].hh.lh:=-268435455;q:=s;end{:902};mem[q].hh.rh:=r;
discbreak:=true;
end{:899}else if mem[q].hh.b0=13 then mem[q+1].int:=0 else if mem[q].hh.
b0=11 then begin mem[q+1].int:=0;
if(eqtb[29001].int>0)then{1458:}if odd(mem[q].hh.b1)then begin if LRptr
<>-268435455 then if mem[LRptr].hh.lh=(4*(mem[q].hh.b1 div 4)+3)then
begin tempptr:=LRptr;LRptr:=mem[tempptr].hh.rh;
begin mem[tempptr].hh.rh:=avail;avail:=tempptr;
ifdef('STAT')decr(dynused);endif('STAT')end;end;
end else begin tempptr:=getavail;
mem[tempptr].hh.lh:=(4*(mem[q].hh.b1 div 4)+3);
mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;end{:1458};end;
end end else begin q:=memtop-3;
while mem[q].hh.rh<>-268435455 do q:=mem[q].hh.rh;end;
{903:}r:=newparamglue(8);mem[r].hh.rh:=mem[q].hh.rh;mem[q].hh.rh:=r;
q:=r{:903};30:{:898};
if(eqtb[29001].int>0)then{1459:}if LRptr<>-268435455 then begin s:=
memtop-3;r:=mem[s].hh.rh;while r<>q do begin s:=r;r:=mem[s].hh.rh;end;
r:=LRptr;while r<>-268435455 do begin tempptr:=newmath(0,mem[r].hh.lh);
mem[s].hh.rh:=tempptr;s:=tempptr;r:=mem[r].hh.rh;end;mem[s].hh.rh:=q;
end{:1459};{904:}r:=mem[q].hh.rh;mem[q].hh.rh:=-268435455;
q:=mem[memtop-3].hh.rh;mem[memtop-3].hh.rh:=r;
if lastdisp<>0 then begin r:=getnode(2);mem[r].hh.b0:=5;
mem[r+1].int:=lastdisp;mem[r].hh.rh:=q;q:=r;end;
if eqtb[24535].hh.rh<>membot then begin r:=newparamglue(7);
mem[r].hh.rh:=q;q:=r;end{:904};
{906:}if curline>lastspecialline then begin curwidth:=secondwidth;
curindent:=secondindent;
end else if eqtb[25061].hh.rh=-268435455 then begin curwidth:=firstwidth
;curindent:=firstindent;
end else begin curwidth:=mem[eqtb[25061].hh.rh+2*curline].int;
curindent:=mem[eqtb[25061].hh.rh+2*curline-1].int;end;
adjusttail:=memtop-5;justbox:=hpack(q,curwidth,0);
mem[justbox+4].int:=curindent{:906};{905:}appendtovlist(justbox);
if memtop-5<>adjusttail then begin mem[curlist.tailfield].hh.rh:=mem[
memtop-5].hh.rh;curlist.tailfield:=adjusttail;end;
adjusttail:=-268435455{:905};
{907:}if curline+1<>bestline then begin q:=eqtb[25328].hh.rh;
if q<>-268435455 then begin r:=curline;
if r>mem[q+1].int then r:=mem[q+1].int;pen:=mem[q+r+1].int;
end else pen:=eqtb[28944].int;q:=eqtb[25329].hh.rh;
if q<>-268435455 then begin r:=curline-curlist.pgfield;
if r>mem[q+1].int then r:=mem[q+1].int;pen:=pen+mem[q+r+1].int;
end else if curline=curlist.pgfield+1 then pen:=pen+eqtb[28936].int;
if d then q:=eqtb[25331].hh.rh else q:=eqtb[25330].hh.rh;
if q<>-268435455 then begin r:=bestline-curline-1;
if r>mem[q+1].int then r:=mem[q+1].int;pen:=pen+mem[q+r+1].int;
end else if curline+2=bestline then if d then pen:=pen+eqtb[28938].int
else pen:=pen+eqtb[28937].int;
if discbreak then pen:=pen+eqtb[28939].int;
if pen<>0 then begin r:=newpenalty(pen);mem[curlist.tailfield].hh.rh:=r;
curlist.tailfield:=r;end;end{:907}{:897};incr(curline);
curp:=mem[curp+1].hh.lh;
if curp<>-268435455 then if not postdiscbreak then{896:}begin r:=memtop
-3;while true do begin q:=mem[r].hh.rh;
if q=mem[curp+1].hh.rh then goto 31;if(q>=himemmin)then goto 31;
if(mem[q].hh.b0<11)then goto 31;
if mem[q].hh.b0=13 then if(mem[q].hh.b1<>1)and(mem[q].hh.b1<>3)then goto
31;r:=q;
if mem[q].hh.b0=11 then if(eqtb[29001].int>0)then{1458:}if odd(mem[q].hh
.b1)then begin if LRptr<>-268435455 then if mem[LRptr].hh.lh=(4*(mem[q].
hh.b1 div 4)+3)then begin tempptr:=LRptr;LRptr:=mem[tempptr].hh.rh;
begin mem[tempptr].hh.rh:=avail;avail:=tempptr;
ifdef('STAT')decr(dynused);endif('STAT')end;end;
end else begin tempptr:=getavail;
mem[tempptr].hh.lh:=(4*(mem[q].hh.b1 div 4)+3);
mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;end{:1458};end;
31:if r<>memtop-3 then begin mem[r].hh.rh:=-268435455;
flushnodelist(mem[memtop-3].hh.rh);mem[memtop-3].hh.rh:=q;end;end{:896};
until curp=-268435455;
if(curline<>bestline)or(mem[memtop-3].hh.rh<>-268435455)then confusion(
1034);curlist.pgfield:=bestline-1;curlist.eTeXauxfield:=LRptr;end;
{:894}{912:}{923:}function reconstitute(j,n:smallnumber;
bchar,hchar:halfword):smallnumber;label 22,30;var p:halfword;t:halfword;
q:fourquarters;currh:halfword;testchar:halfword;w:scaled;k:fontindex;
begin hyphenpassed:=0;t:=memtop-4;w:=0;mem[memtop-4].hh.rh:=-268435455;
{925:}curl:=hu[j];curq:=t;if j=0 then begin ligaturepresent:=initlig;
p:=initlist;if ligaturepresent then lfthit:=initlft;
while p>-268435455 do begin begin mem[t].hh.rh:=getavail;
t:=mem[t].hh.rh;mem[t].hh.b0:=hf;mem[t].hh.b1:=mem[p].hh.b1;end;
p:=mem[p].hh.rh;end;
end else if curl<256 then begin mem[t].hh.rh:=getavail;t:=mem[t].hh.rh;
mem[t].hh.b0:=hf;mem[t].hh.b1:=curl;end;ligstack:=-268435455;
begin if j<n then curr:=hu[j+1]else curr:=bchar;
if odd(hyf[j])then currh:=hchar else currh:=256;end{:925};
22:{926:}if curl=256 then begin k:=bcharlabel[hf];
if k=0 then goto 30 else q:=fontinfo[k].qqqq;
end else begin q:=fontinfo[charbase[hf]+effectivechar(true,hf,curl)].
qqqq;if((q.b2)mod 4)<>1 then goto 30;k:=ligkernbase[hf]+q.b3;
q:=fontinfo[k].qqqq;
if q.b0>128 then begin k:=ligkernbase[hf]+256*q.b2+q.b3+32768-256*(128);
q:=fontinfo[k].qqqq;end;end;
if currh<256 then testchar:=currh else testchar:=curr;
while true do begin if q.b1=testchar then if q.b0<=128 then if currh<256
then begin hyphenpassed:=j;hchar:=256;currh:=256;goto 22;
end else begin if hchar<256 then if odd(hyf[j])then begin hyphenpassed:=
j;hchar:=256;end;
if q.b2<128 then{928:}begin if curl=256 then lfthit:=true;
if j=n then if ligstack=-268435455 then rthit:=true;
begin if interrupt<>0 then pauseforinstructions;end;
case q.b2 of 1,5:begin curl:=q.b3;ligaturepresent:=true;end;
2,6:begin curr:=q.b3;
if ligstack>-268435455 then mem[ligstack].hh.b1:=curr else begin
ligstack:=newligitem(curr);
if j=n then bchar:=256 else begin p:=getavail;mem[ligstack+1].hh.rh:=p;
mem[p].hh.b1:=hu[j+1];mem[p].hh.b0:=hf;end;end;end;3:begin curr:=q.b3;
p:=ligstack;ligstack:=newligitem(curr);mem[ligstack].hh.rh:=p;end;
7,11:begin if ligaturepresent then begin p:=newligature(hf,curl,mem[curq
].hh.rh);if lfthit then begin mem[p].hh.b1:=2;lfthit:=false;end;
if false then if ligstack=-268435455 then begin incr(mem[p].hh.b1);
rthit:=false;end;mem[curq].hh.rh:=p;t:=p;ligaturepresent:=false;end;
curq:=t;curl:=q.b3;ligaturepresent:=true;end;others:begin curl:=q.b3;
ligaturepresent:=true;
if ligstack>-268435455 then begin if mem[ligstack+1].hh.rh>-268435455
then begin mem[t].hh.rh:=mem[ligstack+1].hh.rh;t:=mem[t].hh.rh;incr(j);
end;p:=ligstack;ligstack:=mem[p].hh.rh;freenode(p,2);
if ligstack=-268435455 then begin if j<n then curr:=hu[j+1]else curr:=
bchar;if odd(hyf[j])then currh:=hchar else currh:=256;
end else curr:=mem[ligstack].hh.b1;
end else if j=n then goto 30 else begin begin mem[t].hh.rh:=getavail;
t:=mem[t].hh.rh;mem[t].hh.b0:=hf;mem[t].hh.b1:=curr;end;incr(j);
begin if j<n then curr:=hu[j+1]else curr:=bchar;
if odd(hyf[j])then currh:=hchar else currh:=256;end;end;end end;
if q.b2>4 then if q.b2<>7 then goto 30;goto 22;end{:928};
w:=fontinfo[kernbase[hf]+256*q.b2+q.b3].int;goto 30;end;
if q.b0>=128 then if currh=256 then goto 30 else begin currh:=256;
goto 22;end;k:=k+q.b0+1;q:=fontinfo[k].qqqq;end;30:{:926};
{927:}if ligaturepresent then begin p:=newligature(hf,curl,mem[curq].hh.
rh);if lfthit then begin mem[p].hh.b1:=2;lfthit:=false;end;
if rthit then if ligstack=-268435455 then begin incr(mem[p].hh.b1);
rthit:=false;end;mem[curq].hh.rh:=p;t:=p;ligaturepresent:=false;end;
if w<>0 then begin mem[t].hh.rh:=newkern(w);t:=mem[t].hh.rh;w:=0;
mem[t+2].int:=0;end;if ligstack>-268435455 then begin curq:=t;
curl:=mem[ligstack].hh.b1;ligaturepresent:=true;
begin if mem[ligstack+1].hh.rh>-268435455 then begin mem[t].hh.rh:=mem[
ligstack+1].hh.rh;t:=mem[t].hh.rh;incr(j);end;p:=ligstack;
ligstack:=mem[p].hh.rh;freenode(p,2);
if ligstack=-268435455 then begin if j<n then curr:=hu[j+1]else curr:=
bchar;if odd(hyf[j])then currh:=hchar else currh:=256;
end else curr:=mem[ligstack].hh.b1;end;goto 22;end{:927};
reconstitute:=j;end;{:923}procedure hyphenate;
label 50,30,40,41,42,45,10;var{918:}i,j,l:0..65;q,r,s:halfword;
bchar:halfword;{:918}{929:}majortail,minortail:halfword;c:ASCIIcode;
cloc:0..63;rcount:integer;hyfnode:halfword;{:929}{939:}z:triepointer;
v:integer;{:939}{946:}h:hyphpointer;k:strnumber;u:poolpointer;
{:946}begin{940:}for j:=0 to hn do hyf[j]:=0;{947:}h:=hc[1];incr(hn);
hc[hn]:=curlang;for j:=2 to hn do h:=(h+h+hc[j])mod 607;
while true do begin{948:}k:=hyphword[h];if k=0 then goto 45;
if(strstart[k+1]-strstart[k])=hn then begin j:=1;u:=strstart[k];
repeat if strpool[u]<>hc[j]then goto 30;incr(j);incr(u);until j>hn;
{949:}s:=hyphlist[h];while s<>-268435455 do begin hyf[mem[s].hh.lh]:=1;
s:=mem[s].hh.rh;end{:949};decr(hn);goto 40;end;30:{:948};h:=hyphlink[h];
if h=0 then goto 45;decr(h);end;45:decr(hn){:947};
if trietrc[curlang+1]<>curlang then goto 10;hc[0]:=0;hc[hn+1]:=0;
hc[hn+2]:=256;
for j:=0 to hn-rhyf+1 do begin z:=trietrl[curlang+1]+hc[j];l:=j;
while hc[l]=trietrc[z]do begin if trietro[z]<>mintrieop then{941:}begin
v:=trietro[z];repeat v:=v+opstart[curlang];i:=l-hyfdistance[v];
if hyfnum[v]>hyf[i]then hyf[i]:=hyfnum[v];v:=hyfnext[v];
until v=mintrieop;end{:941};incr(l);z:=trietrl[z]+hc[l];end;end;
40:for j:=0 to lhyf-1 do hyf[j]:=0;
for j:=0 to rhyf-1 do hyf[hn-j]:=0{:940};
{919:}for j:=lhyf to hn-rhyf do if odd(hyf[j])then goto 41;goto 10;
41:{:919};{920:}q:=mem[hb].hh.rh;mem[hb].hh.rh:=-268435455;
r:=mem[ha].hh.rh;mem[ha].hh.rh:=-268435455;bchar:=hyfbchar;
if(ha>=himemmin)then if mem[ha].hh.b0<>hf then goto 42 else begin
initlist:=ha;initlig:=false;hu[0]:=mem[ha].hh.b1;
end else if mem[ha].hh.b0=8 then if mem[ha+1].hh.b0<>hf then goto 42
else begin initlist:=mem[ha+1].hh.rh;initlig:=true;
initlft:=(mem[ha].hh.b1>1);hu[0]:=mem[ha+1].hh.b1;
if initlist=-268435455 then if initlft then begin hu[0]:=256;
initlig:=false;end;freenode(ha,2);
end else begin if not(r>=himemmin)then if mem[r].hh.b0=8 then if mem[r].
hh.b1>1 then goto 42;j:=1;s:=ha;initlist:=-268435455;goto 50;end;
s:=curp;while mem[s].hh.rh<>ha do s:=mem[s].hh.rh;j:=0;goto 50;42:s:=ha;
j:=0;hu[0]:=256;initlig:=false;initlist:=-268435455;50:flushnodelist(r);
{930:}repeat l:=j;j:=reconstitute(j,hn,bchar,hyfchar)+1;
if hyphenpassed=0 then begin mem[s].hh.rh:=mem[memtop-4].hh.rh;
while mem[s].hh.rh>-268435455 do s:=mem[s].hh.rh;
if odd(hyf[j-1])then begin l:=j;hyphenpassed:=j-1;
mem[memtop-4].hh.rh:=-268435455;end;end;
if hyphenpassed>0 then{931:}repeat r:=getnode(2);
mem[r].hh.rh:=mem[memtop-4].hh.rh;mem[r].hh.b0:=9;majortail:=r;
rcount:=0;
while mem[majortail].hh.rh>-268435455 do begin majortail:=mem[majortail]
.hh.rh;incr(rcount);end;i:=hyphenpassed;hyf[i]:=0;
{932:}minortail:=-268435455;mem[r+1].hh.lh:=-268435455;
hyfnode:=newcharacter(hf,hyfchar);
if hyfnode<>-268435455 then begin incr(i);c:=hu[i];hu[i]:=hyfchar;
begin mem[hyfnode].hh.rh:=avail;avail:=hyfnode;
ifdef('STAT')decr(dynused);endif('STAT')end;end;
while l<=i do begin l:=reconstitute(l,i,fontbchar[hf],256)+1;
if mem[memtop-4].hh.rh>-268435455 then begin if minortail=-268435455
then mem[r+1].hh.lh:=mem[memtop-4].hh.rh else mem[minortail].hh.rh:=mem[
memtop-4].hh.rh;minortail:=mem[memtop-4].hh.rh;
while mem[minortail].hh.rh>-268435455 do minortail:=mem[minortail].hh.rh
;end;end;if hyfnode<>-268435455 then begin hu[i]:=c;l:=i;decr(i);
end{:932};{933:}minortail:=-268435455;mem[r+1].hh.rh:=-268435455;
cloc:=0;if bcharlabel[hf]<>0 then begin decr(l);c:=hu[l];cloc:=l;
hu[l]:=256;end;
while l<j do begin repeat l:=reconstitute(l,hn,bchar,256)+1;
if cloc>0 then begin hu[cloc]:=c;cloc:=0;end;
if mem[memtop-4].hh.rh>-268435455 then begin if minortail=-268435455
then mem[r+1].hh.rh:=mem[memtop-4].hh.rh else mem[minortail].hh.rh:=mem[
memtop-4].hh.rh;minortail:=mem[memtop-4].hh.rh;
while mem[minortail].hh.rh>-268435455 do minortail:=mem[minortail].hh.rh
;end;until l>=j;
while l>j do{934:}begin j:=reconstitute(j,hn,bchar,256)+1;
mem[majortail].hh.rh:=mem[memtop-4].hh.rh;
while mem[majortail].hh.rh>-268435455 do begin majortail:=mem[majortail]
.hh.rh;incr(rcount);end;end{:934};end{:933};
{935:}if rcount>127 then begin mem[s].hh.rh:=mem[r].hh.rh;
mem[r].hh.rh:=-268435455;flushnodelist(r);
end else begin mem[s].hh.rh:=r;mem[r].hh.b1:=rcount;end;
s:=majortail{:935};hyphenpassed:=j-1;mem[memtop-4].hh.rh:=-268435455;
until not odd(hyf[j-1]){:931};until j>hn;mem[s].hh.rh:=q{:930};
flushlist(initlist){:920};10:end;
{:912}{959:}ifdef('INITEX'){961:}function newtrieop(d,n:smallnumber;
v:trieopcode):trieopcode;label 10;var h:negtrieopsize..trieopsize;
u:trieopcode;l:0..trieopsize;
begin h:=abs(n+313*d+361*v+1009*curlang)mod(trieopsize-negtrieopsize)+
negtrieopsize;while true do begin l:=trieophash[h];
if l=0 then begin if trieopptr=trieopsize then overflow(1044,trieopsize)
;u:=trieused[curlang];
if u=maxtrieop then overflow(1045,maxtrieop-mintrieop);incr(trieopptr);
incr(u);trieused[curlang]:=u;if u>maxopused then maxopused:=u;
hyfdistance[trieopptr]:=d;hyfnum[trieopptr]:=n;hyfnext[trieopptr]:=v;
trieoplang[trieopptr]:=curlang;trieophash[h]:=trieopptr;
trieopval[trieopptr]:=u;newtrieop:=u;goto 10;end;
if(hyfdistance[l]=d)and(hyfnum[l]=n)and(hyfnext[l]=v)and(trieoplang[l]=
curlang)then begin newtrieop:=trieopval[l];goto 10;end;
if h>-trieopsize then decr(h)else h:=trieopsize;end;10:end;
{:961}{965:}function trienode(p:triepointer):triepointer;label 10;
var h:triepointer;q:triepointer;
begin h:=abs(triec[p]+1009*trieo[p]+2718*triel[p]+3142*trier[p])mod
triesize;while true do begin q:=triehash[h];
if q=0 then begin triehash[h]:=p;trienode:=p;goto 10;end;
if(triec[q]=triec[p])and(trieo[q]=trieo[p])and(triel[q]=triel[p])and(
trier[q]=trier[p])then begin trienode:=q;goto 10;end;
if h>0 then decr(h)else h:=triesize;end;10:end;
{:965}{966:}function compresstrie(p:triepointer):triepointer;
begin if p=0 then compresstrie:=0 else begin triel[p]:=compresstrie(
triel[p]);trier[p]:=compresstrie(trier[p]);compresstrie:=trienode(p);
end;end;{:966}{970:}procedure firstfit(p:triepointer);label 45,40;
var h:triepointer;z:triepointer;q:triepointer;c:ASCIIcode;
l,r:triepointer;ll:1..256;begin c:=triec[p];z:=triemin[c];
while true do begin h:=z-c;
{971:}if triemax<h+256 then begin if triesize<=h+256 then overflow(1046,
triesize);repeat incr(triemax);trietaken[triemax]:=false;
trietrl[triemax]:=triemax+1;trietro[triemax]:=triemax-1;
until triemax=h+256;end{:971};if trietaken[h]then goto 45;
{972:}q:=trier[p];
while q>0 do begin if trietrl[h+triec[q]]=0 then goto 45;q:=trier[q];
end;goto 40{:972};45:z:=trietrl[z];end;40:{973:}trietaken[h]:=true;
triehash[p]:=h;q:=p;repeat z:=h+triec[q];l:=trietro[z];r:=trietrl[z];
trietro[r]:=l;trietrl[l]:=r;trietrl[z]:=0;
if l<256 then begin if z<256 then ll:=z else ll:=256;
repeat triemin[l]:=r;incr(l);until l=ll;end;q:=trier[q];until q=0{:973};
end;{:970}{974:}procedure triepack(p:triepointer);var q:triepointer;
begin repeat q:=triel[p];
if(q>0)and(triehash[q]=0)then begin firstfit(q);triepack(q);end;
p:=trier[p];until p=0;end;{:974}{976:}procedure triefix(p:triepointer);
var q:triepointer;c:ASCIIcode;z:triepointer;begin z:=triehash[p];
repeat q:=triel[p];c:=triec[p];trietrl[z+c]:=triehash[q];
trietrc[z+c]:=c;trietro[z+c]:=trieo[p];if q>0 then triefix(q);
p:=trier[p];until p=0;end;{:976}{977:}procedure newpatterns;label 30,31;
var k,l:0..64;digitsensed:boolean;v:trieopcode;p,q:triepointer;
firstchild:boolean;c:ASCIIcode;
begin if trienotready then begin if eqtb[28982].int<=0 then curlang:=0
else if eqtb[28982].int>255 then curlang:=0 else curlang:=eqtb[28982].
int;scanleftbrace;{978:}k:=0;hyf[0]:=0;digitsensed:=false;
while true do begin getxtoken;
case curcmd of 11,12:{979:}if digitsensed or(curchr<48)or(curchr>57)then
begin if curchr=46 then curchr:=0 else begin curchr:=eqtb[27651+curchr].
hh.rh;if curchr=0 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1052);
end;begin helpptr:=1;helpline[0]:=1051;end;error;end;end;
if k<63 then begin incr(k);hc[k]:=curchr;hyf[k]:=0;digitsensed:=false;
end;end else if k<63 then begin hyf[k]:=curchr-48;digitsensed:=true;
end{:979};
10,2:begin if k>0 then{980:}begin{982:}if hc[1]=0 then hyf[0]:=0;
if hc[k]=0 then hyf[k]:=0;l:=k;v:=mintrieop;
while true do begin if hyf[l]<>0 then v:=newtrieop(k-l,hyf[l],v);
if l>0 then decr(l)else goto 31;end;31:{:982};q:=0;hc[0]:=curlang;
while l<=k do begin c:=hc[l];incr(l);p:=triel[q];firstchild:=true;
while(p>0)and(c>triec[p])do begin q:=p;p:=trier[q];firstchild:=false;
end;
if(p=0)or(c<triec[p])then{981:}begin if trieptr=triesize then overflow(
1046,triesize);incr(trieptr);trier[trieptr]:=p;p:=trieptr;triel[p]:=0;
if firstchild then triel[q]:=p else trier[q]:=p;triec[p]:=c;
trieo[p]:=mintrieop;end{:981};q:=p;end;
if trieo[q]<>mintrieop then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1053);
end;begin helpptr:=1;helpline[0]:=1051;end;error;end;trieo[q]:=v;
end{:980};if curcmd=2 then goto 30;k:=0;hyf[0]:=0;digitsensed:=false;
end;others:begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1050);
end;printesc(1048);begin helpptr:=1;helpline[0]:=1051;end;error;end end;
end;30:{:978};if eqtb[29000].int>0 then{1609:}begin c:=curlang;
firstchild:=false;p:=0;repeat q:=p;p:=trier[q];
until(p=0)or(c<=triec[p]);
if(p=0)or(c<triec[p])then{981:}begin if trieptr=triesize then overflow(
1046,triesize);incr(trieptr);trier[trieptr]:=p;p:=trieptr;triel[p]:=0;
if firstchild then triel[q]:=p else trier[q]:=p;triec[p]:=c;
trieo[p]:=mintrieop;end{:981};q:=p;{1610:}p:=triel[q];firstchild:=true;
for c:=0 to 255 do if(eqtb[27651+c].hh.rh>0)or((c=255)and firstchild)
then begin if p=0 then{981:}begin if trieptr=triesize then overflow(1046
,triesize);incr(trieptr);trier[trieptr]:=p;p:=trieptr;triel[p]:=0;
if firstchild then triel[q]:=p else trier[q]:=p;triec[p]:=c;
trieo[p]:=mintrieop;end{:981}else triec[p]:=c;
trieo[p]:=eqtb[27651+c].hh.rh;q:=p;p:=trier[q];firstchild:=false;end;
if firstchild then triel[q]:=0 else trier[q]:=0{:1610};end{:1609};
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1047);
end;printesc(1048);begin helpptr:=1;helpline[0]:=1049;end;error;
mem[memtop-12].hh.rh:=scantoks(false,false);flushlist(defref);end;end;
{:977}{983:}procedure inittrie;var p:triepointer;j,k,t:integer;
r,s:triepointer;begin{969:}{962:}opstart[0]:=-mintrieop;
for j:=1 to 255 do opstart[j]:=opstart[j-1]+trieused[j-1];
for j:=1 to trieopptr do trieophash[j]:=opstart[trieoplang[j]]+trieopval
[j];
for j:=1 to trieopptr do while trieophash[j]>j do begin k:=trieophash[j]
;t:=hyfdistance[k];hyfdistance[k]:=hyfdistance[j];hyfdistance[j]:=t;
t:=hyfnum[k];hyfnum[k]:=hyfnum[j];hyfnum[j]:=t;t:=hyfnext[k];
hyfnext[k]:=hyfnext[j];hyfnext[j]:=t;trieophash[j]:=trieophash[k];
trieophash[k]:=k;end{:962};for p:=0 to triesize do triehash[p]:=0;
trier[0]:=compresstrie(trier[0]);triel[0]:=compresstrie(triel[0]);
for p:=0 to trieptr do triehash[p]:=0;
for p:=0 to 255 do triemin[p]:=p+1;trietrl[0]:=1;triemax:=0{:969};
if triel[0]<>0 then begin firstfit(triel[0]);triepack(triel[0]);end;
if trier[0]<>0 then{1611:}begin if triel[0]=0 then for p:=0 to 255 do
triemin[p]:=p+2;firstfit(trier[0]);triepack(trier[0]);
hyphstart:=triehash[trier[0]];end{:1611};
{975:}if triemax=0 then begin for r:=0 to 256 do begin trietrl[r]:=0;
trietro[r]:=mintrieop;trietrc[r]:=0;end;triemax:=256;
end else begin if trier[0]>0 then triefix(trier[0]);
if triel[0]>0 then triefix(triel[0]);r:=0;repeat s:=trietrl[r];
begin trietrl[r]:=0;trietro[r]:=mintrieop;trietrc[r]:=0;end;r:=s;
until r>triemax;end;trietrc[0]:=63;{:975};trienotready:=false;end;
{:983}endif('INITEX'){:959}procedure linebreak(d:boolean);
label 30,31,32,33,34,35,22;var{879:}autobreaking:boolean;prevp:halfword;
q,r,s,prevs:halfword;f,postf:internalfontnumber;postp:halfword;
cc:ASCIIcode;firstuse:boolean;{:879}{910:}j:smallnumber;c:0..255;
{:910}begin packbeginline:=curlist.mlfield;{833:}firstuse:=true;
chain:=false;deleteglueref(curkanjiskip);deleteglueref(curxkanjiskip);
curkanjiskip:=mem[curlist.headfield+7].hh.rh;
curxkanjiskip:=mem[curlist.headfield+7].hh.lh;
incr(mem[curkanjiskip].hh.rh);incr(mem[curxkanjiskip].hh.rh);
mem[memtop-3].hh.rh:=mem[curlist.headfield].hh.rh;
if not(curlist.tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=5)
then begin freenode(curlist.tailfield,2);
curlist.tailfield:=curlist.pnodefield;
mem[curlist.tailfield].hh.rh:=-268435455 end;
if(curlist.tailfield>=himemmin)then begin mem[curlist.tailfield].hh.rh:=
newpenalty(10000);curlist.tailfield:=mem[curlist.tailfield].hh.rh;
end else if mem[curlist.tailfield].hh.b0<>12 then begin mem[curlist.
tailfield].hh.rh:=newpenalty(10000);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;
end else begin mem[curlist.tailfield].hh.b0:=14;
deleteglueref(mem[curlist.tailfield+1].hh.lh);
flushnodelist(mem[curlist.tailfield+1].hh.rh);
mem[curlist.tailfield+1].int:=10000;end;
mem[curlist.tailfield].hh.rh:=newparamglue(14);
lastlinefill:=mem[curlist.tailfield].hh.rh;
initcurlang:=curlist.pgfield mod 65536;
initlhyf:=curlist.pgfield div 4194304;
initrhyf:=(curlist.pgfield div 65536)mod 64;popnest;
{:833}{844:}noshrinkerroryet:=true;
if(mem[eqtb[24535].hh.rh].hh.b1<>0)and(mem[eqtb[24535].hh.rh+3].int<>0)
then begin eqtb[24535].hh.rh:=finiteshrink(eqtb[24535].hh.rh);end;
if(mem[eqtb[24536].hh.rh].hh.b1<>0)and(mem[eqtb[24536].hh.rh+3].int<>0)
then begin eqtb[24536].hh.rh:=finiteshrink(eqtb[24536].hh.rh);end;
q:=eqtb[24535].hh.rh;r:=eqtb[24536].hh.rh;
background[1]:=mem[q+1].int+mem[r+1].int;background[2]:=0;
background[3]:=0;background[4]:=0;background[5]:=0;background[6]:=0;
background[2+mem[q].hh.b0]:=mem[q+2].int;
background[2+mem[r].hh.b0]:=background[2+mem[r].hh.b0]+mem[r+2].int;
background[7]:=mem[q+3].int+mem[r+3].int;{1597:}dolastlinefit:=false;
activenodesize:=3;
if eqtb[28998].int>0 then begin q:=mem[lastlinefill+1].hh.lh;
if(mem[q+2].int>0)and(mem[q].hh.b0>0)then if(background[3]=0)and(
background[4]=0)and(background[5]=0)and(background[6]=0)then begin
dolastlinefit:=true;activenodesize:=5;fillwidth[0]:=0;fillwidth[1]:=0;
fillwidth[2]:=0;fillwidth[3]:=0;fillwidth[mem[q].hh.b0-1]:=mem[q+2].int;
end;end{:1597};{:844}{851:}minimumdemerits:=1073741823;
minimaldemerits[3]:=1073741823;minimaldemerits[2]:=1073741823;
minimaldemerits[1]:=1073741823;minimaldemerits[0]:=1073741823;
{:851}{865:}if eqtb[25061].hh.rh=-268435455 then if eqtb[29531].int=0
then begin lastspecialline:=0;secondwidth:=eqtb[29517].int;
secondindent:=0;
end else{866:}begin lastspecialline:=abs(eqtb[28972].int);
if eqtb[28972].int<0 then begin firstwidth:=eqtb[29517].int-abs(eqtb[
29531].int);
if eqtb[29531].int>=0 then firstindent:=eqtb[29531].int else firstindent
:=0;secondwidth:=eqtb[29517].int;secondindent:=0;
end else begin firstwidth:=eqtb[29517].int;firstindent:=0;
secondwidth:=eqtb[29517].int-abs(eqtb[29531].int);
if eqtb[29531].int>=0 then secondindent:=eqtb[29531].int else
secondindent:=0;end;
end{:866}else begin lastspecialline:=mem[eqtb[25061].hh.rh].hh.lh-1;
secondwidth:=mem[eqtb[25061].hh.rh+2*(lastspecialline+1)].int;
secondindent:=mem[eqtb[25061].hh.rh+2*lastspecialline+1].int;end;
if eqtb[28950].int=0 then easyline:=lastspecialline else easyline:=
268435455{:865};{880:}threshold:=eqtb[28931].int;
if threshold>=0 then begin ifdef('STAT')if eqtb[28963].int>0 then begin
begindiagnostic;printnl(1028);end;endif('STAT')secondpass:=false;
finalpass:=false;end else begin threshold:=eqtb[28932].int;
secondpass:=true;finalpass:=(eqtb[29534].int<=0);
ifdef('STAT')if eqtb[28963].int>0 then begindiagnostic;endif('STAT')end;
while true do begin if threshold>10000 then threshold:=10000;
if secondpass then{908:}begin ifdef('INITEX')if trienotready then
inittrie;endif('INITEX')curlang:=initcurlang;lhyf:=initlhyf;
rhyf:=initrhyf;
if trietrc[hyphstart+curlang]<>curlang then hyphindex:=0 else hyphindex
:=trietrl[hyphstart+curlang];end{:908};{881:}q:=getnode(activenodesize);
mem[q].hh.b0:=0;mem[q].hh.b1:=2;mem[q].hh.rh:=memtop-7;
mem[q+1].hh.rh:=-268435455;mem[q+1].hh.lh:=curlist.pgfield+1;
mem[q+2].int:=0;mem[memtop-7].hh.rh:=q;
if dolastlinefit then{1599:}begin mem[q+3].int:=0;mem[q+4].int:=0;
end{:1599};activewidth[1]:=background[1];activewidth[2]:=background[2];
activewidth[3]:=background[3];activewidth[4]:=background[4];
activewidth[5]:=background[5];activewidth[6]:=background[6];
activewidth[7]:=background[7];passive:=-268435455;printednode:=memtop-3;
passnumber:=0;fontinshortdisplay:=0{:881};curp:=mem[memtop-3].hh.rh;
autobreaking:=true;prevp:=curp;
while(curp<>-268435455)and(mem[memtop-7].hh.rh<>memtop-7)do{883:}begin
if(curp>=himemmin)then{884:}begin chain:=false;
if(curp>=himemmin)then if fontdir[mem[curp].hh.b0]<>0 then begin case
mem[prevp].hh.b0 of 0,1,2,3,8,9,11:begin curp:=prevp;trybreak(0,0);
curp:=mem[curp].hh.rh;end;others:;end;end;prevp:=curp;postp:=curp;
postf:=mem[postp].hh.b0;repeat f:=postf;cc:=mem[curp].hh.b1;
activewidth[1]:=activewidth[1]+fontinfo[widthbase[f]+fontinfo[charbase[f
]+cc].qqqq.b0].int;postp:=mem[curp].hh.rh;
if fontdir[f]<>0 then begin prevp:=curp;curp:=postp;
postp:=mem[postp].hh.rh;
if(postp>=himemmin)then begin postf:=mem[postp].hh.b0;
if fontdir[postf]<>0 then chain:=true else chain:=false;trybreak(0,0);
end else begin chain:=false;
case mem[postp].hh.b0 of 0,1,2,3,8,9,11:trybreak(0,0);others:;end;end;
if chain then begin if firstuse then begin if(mem[curkanjiskip].hh.b1<>0
)and(mem[curkanjiskip+3].int<>0)then begin curkanjiskip:=finiteshrink(
curkanjiskip);end;firstuse:=false;end;
activewidth[1]:=activewidth[1]+mem[curkanjiskip+1].int;
activewidth[2+mem[curkanjiskip].hh.b0]:=activewidth[2+mem[curkanjiskip].
hh.b0]+mem[curkanjiskip+2].int;
activewidth[7]:=activewidth[7]+mem[curkanjiskip+3].int;end;prevp:=curp;
end else if(postp>=himemmin)then begin postf:=mem[postp].hh.b0;
chain:=false;if fontdir[postf]<>0 then trybreak(0,0);end;curp:=postp;
until not(curp>=himemmin);chain:=false;end{:884};
case mem[curp].hh.b0 of 0,1,2,3:activewidth[1]:=activewidth[1]+mem[curp
+1].int;
10:{1381:}if mem[curp].hh.b1=4 then begin curlang:=mem[curp+1].hh.rh;
lhyf:=mem[curp+1].hh.b0;rhyf:=mem[curp+1].hh.b1;
if trietrc[hyphstart+curlang]<>curlang then hyphindex:=0 else hyphindex
:=trietrl[hyphstart+curlang];end{:1381};
12:begin{885:}if autobreaking then begin if(prevp>=himemmin)then
trybreak(0,0)else if(mem[prevp].hh.b0<11)then trybreak(0,0)else if mem[
prevp].hh.b0=13 then if(mem[prevp].hh.b1<>1)and(mem[prevp].hh.b1<>3)then
trybreak(0,0);end;
if(mem[mem[curp+1].hh.lh].hh.b1<>0)and(mem[mem[curp+1].hh.lh+3].int<>0)
then begin mem[curp+1].hh.lh:=finiteshrink(mem[curp+1].hh.lh);end;
q:=mem[curp+1].hh.lh;activewidth[1]:=activewidth[1]+mem[q+1].int;
activewidth[2+mem[q].hh.b0]:=activewidth[2+mem[q].hh.b0]+mem[q+2].int;
activewidth[7]:=activewidth[7]+mem[q+3].int{:885};
if secondpass and autobreaking then{911:}begin prevs:=curp;
s:=mem[prevs].hh.rh;
if s<>-268435455 then begin{913:}while true do begin if(s>=himemmin)then
begin hf:=mem[s].hh.b0;if fontdir[hf]<>0 then begin prevs:=s;
s:=mem[prevs].hh.rh;c:=mem[s].hh.lh;goto 22;end else c:=mem[s].hh.b1;
end else if mem[s].hh.b0=5 then goto 22 else if(mem[s].hh.b0=14)and(not
mem[s].hh.b1=0)then goto 22 else if mem[s].hh.b0=8 then if mem[s+1].hh.
rh=-268435455 then goto 22 else begin q:=mem[s+1].hh.rh;c:=mem[q].hh.b1;
hf:=mem[q].hh.b0;
end else if(mem[s].hh.b0=13)and(mem[s].hh.b1=0)then goto 22 else if(mem[
s].hh.b0=11)and(mem[s].hh.b1>=4)then goto 22 else if mem[s].hh.b0=10
then begin{1382:}if mem[s].hh.b1=4 then begin curlang:=mem[s+1].hh.rh;
lhyf:=mem[s+1].hh.b0;rhyf:=mem[s+1].hh.b1;
if trietrc[hyphstart+curlang]<>curlang then hyphindex:=0 else hyphindex
:=trietrl[hyphstart+curlang];end{:1382};goto 22;end else goto 31;
if hyphindex=0 then hc[0]:=eqtb[27651+c].hh.rh else if trietrc[hyphindex
+c]<>c then hc[0]:=0 else hc[0]:=trietro[hyphindex+c];
if hc[0]<>0 then if(hc[0]=c)or(eqtb[28969].int>0)then goto 32 else goto
31;22:prevs:=s;s:=mem[prevs].hh.rh;end;32:hyfchar:=hyphenchar[hf];
if hyfchar<0 then goto 31;if hyfchar>255 then goto 31;ha:=prevs{:913};
if lhyf+rhyf>63 then goto 31;{914:}hn:=0;
while true do begin if(s>=himemmin)then begin if mem[s].hh.b0<>hf then
goto 33;hyfbchar:=mem[s].hh.b1;c:=hyfbchar;
if hyphindex=0 then hc[0]:=eqtb[27651+c].hh.rh else if trietrc[hyphindex
+c]<>c then hc[0]:=0 else hc[0]:=trietro[hyphindex+c];
if hc[0]=0 then goto 33;if hn=63 then goto 33;hb:=s;incr(hn);hu[hn]:=c;
hc[hn]:=hc[0];hyfbchar:=256;
end else if mem[s].hh.b0=8 then{915:}begin if mem[s+1].hh.b0<>hf then
goto 33;j:=hn;q:=mem[s+1].hh.rh;
if q>-268435455 then hyfbchar:=mem[q].hh.b1;
while q>-268435455 do begin c:=mem[q].hh.b1;
if hyphindex=0 then hc[0]:=eqtb[27651+c].hh.rh else if trietrc[hyphindex
+c]<>c then hc[0]:=0 else hc[0]:=trietro[hyphindex+c];
if hc[0]=0 then goto 33;if j=63 then goto 33;incr(j);hu[j]:=c;
hc[j]:=hc[0];q:=mem[q].hh.rh;end;hb:=s;hn:=j;
if odd(mem[s].hh.b1)then hyfbchar:=fontbchar[hf]else hyfbchar:=256;
end{:915}else if(mem[s].hh.b0=13)and(mem[s].hh.b1=0)then begin hb:=s;
hyfbchar:=fontbchar[hf];end else goto 33;s:=mem[s].hh.rh;end;33:{:914};
{916:}if hn<lhyf+rhyf then goto 31;
while true do begin if not((s>=himemmin))then case mem[s].hh.b0 of 8:;
13:if mem[s].hh.b1<>0 then goto 34;5:;10,12,14,4,7,6:goto 34;
11:if mem[s].hh.b1>=4 then goto 34 else goto 31;others:goto 31 end;
s:=mem[s].hh.rh;end;34:{:916};hyphenate;end;31:end{:911};end;
13:if(mem[curp].hh.b1=1)or(mem[curp].hh.b1=3)then begin if not(mem[curp]
.hh.rh>=himemmin)and autobreaking then if mem[mem[curp].hh.rh].hh.b0=12
then trybreak(0,0);activewidth[1]:=activewidth[1]+mem[curp+1].int;
end else activewidth[1]:=activewidth[1]+mem[curp+1].int;
8:begin f:=mem[curp+1].hh.b0;
activewidth[1]:=activewidth[1]+fontinfo[widthbase[f]+fontinfo[charbase[f
]+effectivechar(true,f,mem[curp+1].hh.b1)].qqqq.b0].int;end;
9:{886:}begin s:=mem[curp+1].hh.lh;discwidth:=0;
if s=-268435455 then trybreak(eqtb[28935].int,1)else begin repeat{887:}
if(s>=himemmin)then begin f:=mem[s].hh.b0;
discwidth:=discwidth+fontinfo[widthbase[f]+fontinfo[charbase[f]+mem[s].
hh.b1].qqqq.b0].int;
if fontdir[f]<>0 then s:=mem[s].hh.rh end else case mem[s].hh.b0 of 8:
begin f:=mem[s+1].hh.b0;
discwidth:=discwidth+fontinfo[widthbase[f]+fontinfo[charbase[f]+mem[s+1]
.hh.b1].qqqq.b0].int;end;0,1,2,3,13:discwidth:=discwidth+mem[s+1].int;
5:;others:confusion(1032)end{:887};s:=mem[s].hh.rh;until s=-268435455;
activewidth[1]:=activewidth[1]+discwidth;trybreak(eqtb[28934].int,1);
activewidth[1]:=activewidth[1]-discwidth;end;r:=mem[curp].hh.b1;
s:=mem[curp].hh.rh;
while r>0 do begin{888:}if(s>=himemmin)then begin f:=mem[s].hh.b0;
activewidth[1]:=activewidth[1]+fontinfo[widthbase[f]+fontinfo[charbase[f
]+mem[s].hh.b1].qqqq.b0].int;
if fontdir[f]<>0 then s:=mem[s].hh.rh end else case mem[s].hh.b0 of 8:
begin f:=mem[s+1].hh.b0;
activewidth[1]:=activewidth[1]+fontinfo[widthbase[f]+fontinfo[charbase[f
]+mem[s+1].hh.b1].qqqq.b0].int;end;
0,1,2,3,13:activewidth[1]:=activewidth[1]+mem[s+1].int;5:;
others:confusion(1033)end{:888};decr(r);s:=mem[s].hh.rh;end;prevp:=curp;
curp:=s;goto 35;end{:886};
11:begin if mem[curp].hh.b1<4 then autobreaking:=odd(mem[curp].hh.b1);
begin if not(mem[curp].hh.rh>=himemmin)and autobreaking then if mem[mem[
curp].hh.rh].hh.b0=12 then trybreak(0,0);
activewidth[1]:=activewidth[1]+mem[curp+1].int;end;end;
14:trybreak(mem[curp+1].int,0);5,6,4,7:;others:confusion(1031)end;
prevp:=curp;curp:=mem[curp].hh.rh;35:end{:883};
if curp=-268435455 then{890:}begin trybreak(-10000,1);
if mem[memtop-7].hh.rh<>memtop-7 then begin{891:}r:=mem[memtop-7].hh.rh;
fewestdemerits:=1073741823;
repeat if mem[r].hh.b0<>2 then if mem[r+2].int<fewestdemerits then begin
fewestdemerits:=mem[r+2].int;bestbet:=r;end;r:=mem[r].hh.rh;
until r=memtop-7;bestline:=mem[bestbet+1].hh.lh{:891};
if eqtb[28950].int=0 then goto 30;{892:}begin r:=mem[memtop-7].hh.rh;
actuallooseness:=0;
repeat if mem[r].hh.b0<>2 then begin linediff:=mem[r+1].hh.lh-bestline;
if((linediff<actuallooseness)and(eqtb[28950].int<=linediff))or((linediff
>actuallooseness)and(eqtb[28950].int>=linediff))then begin bestbet:=r;
actuallooseness:=linediff;fewestdemerits:=mem[r+2].int;
end else if(linediff=actuallooseness)and(mem[r+2].int<fewestdemerits)
then begin bestbet:=r;fewestdemerits:=mem[r+2].int;end;end;
r:=mem[r].hh.rh;until r=memtop-7;bestline:=mem[bestbet+1].hh.lh;
end{:892};if(actuallooseness=eqtb[28950].int)or finalpass then goto 30;
end;end{:890};{882:}q:=mem[memtop-7].hh.rh;
while q<>memtop-7 do begin curp:=mem[q].hh.rh;
if mem[q].hh.b0=2 then freenode(q,8)else freenode(q,activenodesize);
q:=curp;end;q:=passive;while q<>-268435455 do begin curp:=mem[q].hh.rh;
freenode(q,2);q:=curp;end{:882};
if not secondpass then begin ifdef('STAT')if eqtb[28963].int>0 then
printnl(1029);endif('STAT')threshold:=eqtb[28932].int;secondpass:=true;
finalpass:=(eqtb[29534].int<=0);
end else begin ifdef('STAT')if eqtb[28963].int>0 then printnl(1030);
endif('STAT')background[2]:=background[2]+eqtb[29534].int;
finalpass:=true;end;end;
30:ifdef('STAT')if eqtb[28963].int>0 then begin enddiagnostic(true);
normalizeselector;end;
endif('STAT')if dolastlinefit then{1607:}if mem[bestbet+3].int=0 then
dolastlinefit:=false else begin q:=newspec(mem[lastlinefill+1].hh.lh);
deleteglueref(mem[lastlinefill+1].hh.lh);
mem[q+1].int:=mem[q+1].int+mem[bestbet+3].int-mem[bestbet+4].int;
mem[q+2].int:=0;mem[lastlinefill+1].hh.lh:=q;end{:1607};{:880};
{893:}postlinebreak(d){:893};{882:}q:=mem[memtop-7].hh.rh;
while q<>memtop-7 do begin curp:=mem[q].hh.rh;
if mem[q].hh.b0=2 then freenode(q,8)else freenode(q,activenodesize);
q:=curp;end;q:=passive;while q<>-268435455 do begin curp:=mem[q].hh.rh;
freenode(q,2);q:=curp;end{:882};packbeginline:=0;end;
{1406:}function eTeXenabled(b:boolean;j:quarterword;k:halfword):boolean;
begin if not b then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(741);
end;printcmdchr(j,k);begin helpptr:=1;helpline[0]:=1454;end;error;end;
eTeXenabled:=b;end;{:1406}{1429:}procedure showsavegroups;
label 41,42,40,30;var p:0..nestsize;m:-227..227;v:savepointer;
l:quarterword;c:groupcode;a:-1..1;i:integer;j:quarterword;s:strnumber;
begin p:=nestptr;nest[p]:=curlist;v:=saveptr;l:=curlevel;c:=curgroup;
saveptr:=curboundary;decr(curlevel);a:=1;printnl(343);println;
while true do begin printnl(379);printgroup(true);
if curgroup=0 then goto 30;repeat m:=nest[p].modefield;
if p>0 then decr(p)else m:=1;until m<>114;print(285);
case curgroup of 1:begin incr(p);goto 42;end;2,3:s:=1160;4:s:=1062;
5:s:=1159;6:if a=0 then begin if m=-1 then s:=561 else s:=583;a:=1;
goto 41;end else begin if a=1 then print(1492)else printesc(994);
if p>=a then p:=p-a;a:=0;goto 40;end;7:begin incr(p);a:=-1;
printesc(570);goto 42;end;8:begin printesc(419);goto 40;end;9:goto 42;
10,13:begin if curgroup=10 then printesc(358)else printesc(568);
for i:=1 to 3 do if i<=savestack[saveptr-2].int then print(953);goto 42;
end;
11:begin if savestack[saveptr-2].int=255 then printesc(361)else begin
printesc(335);printint(savestack[saveptr-2].int);end;goto 42;end;
12:begin s:=584;goto 41;end;14:begin incr(p);printesc(550);goto 40;end;
15:begin if m=227 then printchar(36)else if nest[p].modefield=227 then
begin printcmdchr(51,savestack[saveptr-2].int);goto 40;end;
printchar(36);goto 40;end;
16:begin if mem[nest[p+1].eTeXauxfield].hh.b0=32 then printesc(969)else
printesc(971);goto 40;end;end;{1431:}i:=savestack[saveptr-4].int;
if i<>0 then if i<1073741824 then begin if abs(nest[p].modefield)=1 then
j:=24 else j:=25;if i>0 then printcmdchr(j,0)else printcmdchr(j,1);
printscaled(abs(i));print(418);
end else if i<1073872896 then begin if i>=1073807360 then begin printesc
(1295);i:=i-(65536);end;printesc(581);printint(i-1073741824);
printchar(61);end else printcmdchr(34,i-(1073872797)){:1431};
41:printesc(s);
{1430:}if savestack[saveptr-2].int<>0 then begin printchar(32);
if savestack[saveptr-3].int=0 then print(935)else print(936);
printscaled(savestack[saveptr-2].int);print(418);end{:1430};
42:printchar(123);40:printchar(41);decr(curlevel);
curgroup:=savestack[saveptr].hh.b1;
saveptr:=savestack[saveptr].hh.rh end;30:saveptr:=v;curlevel:=l;
curgroup:=c;end;{:1429}{1445:}procedure newinteraction;forward;
{:1445}{:832}{951:}procedure newhyphexceptions;label 21,10,40,45,46;
var n:0..64;j:0..64;h:hyphpointer;k:strnumber;p:halfword;q:halfword;
s:strnumber;u,v:poolpointer;begin scanleftbrace;
if eqtb[28982].int<=0 then curlang:=0 else if eqtb[28982].int>255 then
curlang:=0 else curlang:=eqtb[28982].int;
ifdef('INITEX')if trienotready then begin hyphindex:=0;goto 46;end;
endif('INITEX')if trietrc[hyphstart+curlang]<>curlang then hyphindex:=0
else hyphindex:=trietrl[hyphstart+curlang];46:{952:}n:=0;p:=-268435455;
while true do begin getxtoken;
21:case curcmd of 11,12,71:{954:}if curchr=45 then{955:}begin if n<63
then begin q:=getavail;mem[q].hh.rh:=p;mem[q].hh.lh:=n;p:=q;end;
end{:955}else begin if hyphindex=0 then hc[0]:=eqtb[27651+curchr].hh.rh
else if trietrc[hyphindex+curchr]<>curchr then hc[0]:=0 else hc[0]:=
trietro[hyphindex+curchr];
if hc[0]=0 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1040);
end;begin helpptr:=2;helpline[1]:=1041;helpline[0]:=1042;end;error;
end else if n<63 then begin incr(n);hc[n]:=hc[0];end;end{:954};
19:begin scancharnum;curchr:=curval;curcmd:=71;goto 21;end;
10,2:begin if n>1 then{956:}begin incr(n);hc[n]:=curlang;
begin if poolptr+n>poolsize then overflow(258,poolsize-initpoolptr);end;
h:=0;for j:=1 to n do begin h:=(h+h+hc[j])mod 607;
begin strpool[poolptr]:=hc[j];incr(poolptr);end;end;s:=makestring;
{957:}if hyphnext<=607 then while(hyphnext>0)and(hyphword[hyphnext-1]>0)
do decr(hyphnext);
if(hyphcount=hyphsize)or(hyphnext=0)then overflow(1043,hyphsize);
incr(hyphcount);while hyphword[h]<>0 do begin{958:}k:=hyphword[h];
if(strstart[k+1]-strstart[k])<>(strstart[s+1]-strstart[s])then goto 45;
u:=strstart[k];v:=strstart[s];
repeat if strpool[u]<>strpool[v]then goto 45;incr(u);incr(v);
until u=strstart[k+1];begin decr(strptr);poolptr:=strstart[strptr];end;
s:=hyphword[h];decr(hyphcount);goto 40;45:{:958};
if hyphlink[h]=0 then begin hyphlink[h]:=hyphnext;
if hyphnext>=hyphsize then hyphnext:=607;
if hyphnext>607 then incr(hyphnext);end;h:=hyphlink[h]-1;end;
40:hyphword[h]:=s;hyphlist[h]:=p{:957};end{:956};
if curcmd=2 then goto 10;n:=0;p:=-268435455;end;
others:{953:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(741);
end;printesc(1036);print(1037);begin helpptr:=2;helpline[1]:=1038;
helpline[0]:=1039;end;error;end{:953}end;end{:952};10:end;
{:951}{985:}function prunepagetop(p:halfword;s:boolean):halfword;
var prevp:halfword;q,r:halfword;begin prevp:=memtop-3;
mem[memtop-3].hh.rh:=p;
while p<>-268435455 do case mem[p].hh.b0 of 2,0,1,3:{986:}begin q:=
newskipparam(10);mem[prevp].hh.rh:=q;mem[q].hh.rh:=p;
if mem[tempptr+1].int>mem[p+3].int then mem[tempptr+1].int:=mem[tempptr
+1].int-mem[p+3].int else mem[tempptr+1].int:=0;p:=-268435455;end{:986};
10,6,4:begin prevp:=p;p:=mem[prevp].hh.rh;end;12,13,14:begin q:=p;
p:=mem[q].hh.rh;mem[q].hh.rh:=-268435455;mem[prevp].hh.rh:=p;
if s then begin if discptr[3]=-268435455 then discptr[3]:=q else mem[r].
hh.rh:=q;r:=q;end else flushnodelist(q);end;others:confusion(1054)end;
prunepagetop:=mem[memtop-3].hh.rh;end;
{:985}{987:}function vertbreak(p:halfword;h,d:scaled):halfword;
label 30,45,90;var prevp:halfword;q,r:halfword;pi:integer;b:integer;
leastcost:integer;bestplace:halfword;prevdp:scaled;t:smallnumber;
begin prevp:=p;leastcost:=1073741823;activewidth[1]:=0;
activewidth[2]:=0;activewidth[3]:=0;activewidth[4]:=0;activewidth[5]:=0;
activewidth[6]:=0;activewidth[7]:=0;prevdp:=0;
while true do begin{989:}if p=-268435455 then pi:=-10000 else{990:}case
mem[p].hh.b0 of 2,0,1,3:begin activewidth[1]:=activewidth[1]+prevdp+mem[
p+3].int;prevdp:=mem[p+2].int;goto 45;end;10:{1384:}goto 45{:1384};
12:if(mem[prevp].hh.b0<11)then pi:=0 else goto 90;
13:begin if mem[p].hh.rh=-268435455 then t:=14 else t:=mem[mem[p].hh.rh]
.hh.b0;if t=12 then pi:=0 else goto 90;end;14:pi:=mem[p+1].int;
6,4:goto 45;others:confusion(1055)end{:990};
{991:}if pi<10000 then begin{992:}if activewidth[1]<h then if(
activewidth[3]<>0)or(activewidth[4]<>0)or(activewidth[5]<>0)or(
activewidth[6]<>0)then b:=0 else b:=badness(h-activewidth[1],activewidth
[2])else if activewidth[1]-h>activewidth[7]then b:=1073741823 else b:=
badness(activewidth[1]-h,activewidth[7]){:992};
if b<1073741823 then if pi<=-10000 then b:=pi else if b<10000 then b:=b+
pi else b:=100000;if b<=leastcost then begin bestplace:=p;leastcost:=b;
bestheightplusdepth:=activewidth[1]+prevdp;end;
if(b=1073741823)or(pi<=-10000)then goto 30;end{:991};
if(mem[p].hh.b0<12)or(mem[p].hh.b0>13)then goto 45;
90:{993:}if mem[p].hh.b0=13 then q:=p else begin q:=mem[p+1].hh.lh;
activewidth[2+mem[q].hh.b0]:=activewidth[2+mem[q].hh.b0]+mem[q+2].int;
activewidth[7]:=activewidth[7]+mem[q+3].int;
if(mem[q].hh.b1<>0)and(mem[q+3].int<>0)then begin begin if interaction=3
then;if filelineerrorstylep then printfileline else printnl(263);
print(1056);end;begin helpptr:=4;helpline[3]:=1057;helpline[2]:=1058;
helpline[1]:=1059;helpline[0]:=1017;end;error;r:=newspec(q);
mem[r].hh.b1:=0;deleteglueref(q);mem[p+1].hh.lh:=r;q:=r;end;end;
activewidth[1]:=activewidth[1]+prevdp+mem[q+1].int;prevdp:=0{:993};
45:if prevdp>d then begin activewidth[1]:=activewidth[1]+prevdp-d;
prevdp:=d;end;{:989};prevp:=p;p:=mem[prevp].hh.rh;end;
30:vertbreak:=bestplace;end;
{:987}{994:}{1579:}function domarks(a,l:smallnumber;q:halfword):boolean;
var i:smallnumber;
begin if l<5 then begin for i:=0 to 15 do begin if odd(i)then curptr:=
mem[q+(i div 2)+1].hh.rh else curptr:=mem[q+(i div 2)+1].hh.lh;
if curptr<>-268435455 then if domarks(a,l+1,curptr)then begin if odd(i)
then mem[q+(i div 2)+1].hh.rh:=-268435455 else mem[q+(i div 2)+1].hh.lh
:=-268435455;decr(mem[q].hh.b1);end;end;
if mem[q].hh.b1=0 then begin freenode(q,9);q:=-268435455;end;
end else begin case a of{1580:}0:if mem[q+2].hh.rh<>-268435455 then
begin deletetokenref(mem[q+2].hh.rh);mem[q+2].hh.rh:=-268435455;
deletetokenref(mem[q+3].hh.lh);mem[q+3].hh.lh:=-268435455;end;
{:1580}{1582:}1:if mem[q+2].hh.lh<>-268435455 then begin if mem[q+1].hh.
lh<>-268435455 then deletetokenref(mem[q+1].hh.lh);
deletetokenref(mem[q+1].hh.rh);mem[q+1].hh.rh:=-268435455;
if mem[mem[q+2].hh.lh].hh.rh=-268435455 then begin deletetokenref(mem[q
+2].hh.lh);mem[q+2].hh.lh:=-268435455;
end else incr(mem[mem[q+2].hh.lh].hh.lh);mem[q+1].hh.lh:=mem[q+2].hh.lh;
end;{:1582}{1583:}2:if(mem[q+1].hh.lh<>-268435455)and(mem[q+1].hh.rh=
-268435455)then begin mem[q+1].hh.rh:=mem[q+1].hh.lh;
incr(mem[mem[q+1].hh.lh].hh.lh);end;
{:1583}{1585:}ifdef('INITEX')3:for i:=0 to 4 do begin if odd(i)then
curptr:=mem[q+(i div 2)+1].hh.rh else curptr:=mem[q+(i div 2)+1].hh.lh;
if curptr<>-268435455 then begin deletetokenref(curptr);
if odd(i)then mem[q+(i div 2)+1].hh.rh:=-268435455 else mem[q+(i div 2)
+1].hh.lh:=-268435455;end;end;endif('INITEX'){:1585}end;
if mem[q+2].hh.lh=-268435455 then if mem[q+3].hh.lh=-268435455 then
begin freenode(q,4);q:=-268435455;end;end;domarks:=(q=-268435455);end;
{:1579}function vsplit(n:halfword;h:scaled):halfword;label 10,30;
var v:halfword;w:halfword;p:halfword;q:halfword;begin curval:=n;
if curval<256 then v:=eqtb[25332+curval].hh.rh else begin findsaelement(
4,curval,false);
if curptr=-268435455 then v:=-268435455 else v:=mem[curptr+1].hh.rh;end;
flushnodelist(discptr[3]);discptr[3]:=-268435455;
if saroot[6]<>-268435455 then if domarks(0,0,saroot[6])then saroot[6]:=
-268435455;
if curmark[3]<>-268435455 then begin deletetokenref(curmark[3]);
curmark[3]:=-268435455;deletetokenref(curmark[4]);
curmark[4]:=-268435455;end;
{995:}if v=-268435455 then begin vsplit:=-268435455;goto 10;end;
if mem[v].hh.b0=2 then begin w:=v;v:=mem[v+5].hh.rh;
deleteglueref(mem[w+7].hh.rh);deleteglueref(mem[w+7].hh.lh);
freenode(w,10);end;
if mem[v].hh.b0<>1 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(343);
end;printesc(1060);print(1061);printesc(1062);begin helpptr:=2;
helpline[1]:=1063;helpline[0]:=1064;end;error;vsplit:=-268435455;
goto 10;end;flushnodelist(mem[v].hh.rh);mem[v].hh.rh:=-268435455{:995};
q:=vertbreak(mem[v+5].hh.rh,h,eqtb[29520].int);{996:}p:=mem[v+5].hh.rh;
if p=q then mem[v+5].hh.rh:=-268435455 else while true do begin if mem[p
].hh.b0=6 then if mem[p+1].hh.lh<>0 then{1581:}begin findsaelement(6,mem
[p+1].hh.lh,true);
if mem[curptr+2].hh.rh=-268435455 then begin mem[curptr+2].hh.rh:=mem[p
+1].hh.rh;incr(mem[mem[p+1].hh.rh].hh.lh);
end else deletetokenref(mem[curptr+3].hh.lh);
mem[curptr+3].hh.lh:=mem[p+1].hh.rh;incr(mem[mem[p+1].hh.rh].hh.lh);
end{:1581}else if curmark[3]=-268435455 then begin curmark[3]:=mem[p+1].
hh.rh;curmark[4]:=curmark[3];
mem[curmark[3]].hh.lh:=mem[curmark[3]].hh.lh+2;
end else begin deletetokenref(curmark[4]);curmark[4]:=mem[p+1].hh.rh;
incr(mem[curmark[4]].hh.lh);end;
if mem[p].hh.rh=q then begin mem[p].hh.rh:=-268435455;goto 30;end;
p:=mem[p].hh.rh;end;30:{:996};q:=prunepagetop(q,eqtb[28999].int>0);
p:=mem[v+5].hh.rh;
if q<>-268435455 then begin q:=vpackage(q,0,1,1073741823);
mem[q].hh.b1:=((mem[q].hh.b1)div 8)*8+((mem[v].hh.b1)mod 8);end;
if curval<256 then eqtb[25332+curval].hh.rh:=q else begin findsaelement(
4,curval,false);if curptr<>-268435455 then begin mem[curptr+1].hh.rh:=q;
incr(mem[curptr+1].hh.lh);deletesaref(curptr);end;end;
q:=vpackage(p,h,0,eqtb[29520].int);
mem[q].hh.b1:=((mem[q].hh.b1)div 8)*8+((mem[v].hh.b1)mod 8);
deleteglueref(mem[v+7].hh.rh);deleteglueref(mem[v+7].hh.lh);
freenode(v,10);vsplit:=q;10:end;{:994}{1002:}procedure printtotals;
begin printscaled(pagesofar[1]);
if pagesofar[2]<>0 then begin print(316);printscaled(pagesofar[2]);
print(343);end;if pagesofar[3]<>0 then begin print(316);
printscaled(pagesofar[3]);print(315);end;
if pagesofar[4]<>0 then begin print(316);printscaled(pagesofar[4]);
print(1074);end;if pagesofar[5]<>0 then begin print(316);
printscaled(pagesofar[5]);print(1075);end;
if pagesofar[6]<>0 then begin print(316);printscaled(pagesofar[6]);
print(1076);end;if pagesofar[7]<>0 then begin print(317);
printscaled(pagesofar[7]);end;end;
{:1002}{1004:}procedure freezepagespecs(s:smallnumber);
begin pagecontents:=s;pagesofar[0]:=eqtb[29518].int;
pagemaxdepth:=eqtb[29519].int;pagesofar[8]:=0;pagesofar[1]:=0;
pagesofar[2]:=0;pagesofar[3]:=0;pagesofar[4]:=0;pagesofar[5]:=0;
pagesofar[6]:=0;pagesofar[7]:=0;leastpagecost:=1073741823;
ifdef('STAT')if eqtb[28964].int>0 then begin begindiagnostic;
printnl(1084);printscaled(pagesofar[0]);print(1085);
printscaled(pagemaxdepth);enddiagnostic(false);end;endif('STAT')end;
{:1004}{1009:}procedure boxerror(n:eightbits);begin error;
begindiagnostic;printnl(929);showbox(eqtb[25332+n].hh.rh);
enddiagnostic(true);flushnodelist(eqtb[25332+n].hh.rh);
eqtb[25332+n].hh.rh:=-268435455;end;
{:1009}{1010:}procedure ensurevbox(n:eightbits);var p:halfword;
begin p:=eqtb[25332+n].hh.rh;
if p<>-268435455 then if mem[p].hh.b0=2 then begin p:=mem[p+5].hh.rh;
deleteglueref(mem[eqtb[25332+n].hh.rh+7].hh.rh);
deleteglueref(mem[eqtb[25332+n].hh.rh+7].hh.lh);
freenode(eqtb[25332+n].hh.rh,10);eqtb[25332+n].hh.rh:=p end;
if p<>-268435455 then if mem[p].hh.b0<>1 then begin begin if interaction
=3 then;if filelineerrorstylep then printfileline else printnl(263);
print(1086);end;begin helpptr:=3;helpline[2]:=1087;helpline[1]:=1088;
helpline[0]:=1089;end;boxerror(n);end;end;
{:1010}{1011:}{1029:}procedure fireup(c:halfword);label 10;
var p,q,r,s:halfword;prevp:halfword;n:0..255;wait:boolean;
savevbadness:integer;savevfuzz:scaled;savesplittopskip:halfword;
begin{1030:}if mem[bestpagebreak].hh.b0=14 then begin geqworddefine(
28970,mem[bestpagebreak+1].int);mem[bestpagebreak+1].int:=10000;
end else geqworddefine(28970,10000){:1030};
if saroot[6]<>-268435455 then if domarks(1,0,saroot[6])then saroot[6]:=
-268435455;
if curmark[2]<>-268435455 then begin if curmark[0]<>-268435455 then
deletetokenref(curmark[0]);curmark[0]:=curmark[2];
incr(mem[curmark[0]].hh.lh);deletetokenref(curmark[1]);
curmark[1]:=-268435455;end;
{1031:}if c=bestpagebreak then bestpagebreak:=-268435455;
{1032:}if eqtb[25587].hh.rh<>-268435455 then begin begin if interaction=
3 then;if filelineerrorstylep then printfileline else printnl(263);
print(343);end;printesc(430);print(1102);begin helpptr:=2;
helpline[1]:=1103;helpline[0]:=1089;end;boxerror(255);end{:1032};
insertpenalties:=0;savesplittopskip:=eqtb[24538].hh.rh;
if eqtb[28985].int<=0 then{1035:}begin r:=mem[memtop].hh.rh;
while r<>memtop do begin if mem[r+2].hh.lh<>-268435455 then begin n:=mem
[r].hh.b1;ensurevbox(n);
if eqtb[25332+n].hh.rh=-268435455 then eqtb[25332+n].hh.rh:=newnullbox;
p:=eqtb[25332+n].hh.rh+5;
while mem[p].hh.rh<>-268435455 do p:=mem[p].hh.rh;mem[r+2].hh.rh:=p;end;
r:=mem[r].hh.rh;end;end{:1035};q:=memtop-4;mem[q].hh.rh:=-268435455;
prevp:=memtop-2;p:=mem[prevp].hh.rh;
while p<>bestpagebreak do begin if mem[p].hh.b0=4 then begin if eqtb[
28985].int<=0 then{1037:}begin r:=mem[memtop].hh.rh;
while mem[r].hh.b1<>mem[p].hh.b1 do r:=mem[r].hh.rh;
if mem[r+2].hh.lh=-268435455 then wait:=true else begin wait:=false;
n:=mem[p].hh.b1;
case((mem[eqtb[25332+n].hh.rh].hh.b1)mod 8)of 4,3,1:if mem[p+5].hh.b1<>(
(mem[eqtb[25332+n].hh.rh].hh.b1)mod 8)then begin begin if interaction=3
then;if filelineerrorstylep then printfileline else printnl(263);
print(1095);end;begin helpptr:=3;helpline[2]:=1087;helpline[1]:=1096;
helpline[0]:=1089;end;boxerror(n);eqtb[25332+n].hh.rh:=newnullbox;
mem[r+2].hh.rh:=eqtb[25332+n].hh.rh+5;end;
others:mem[eqtb[25332+n].hh.rh].hh.b1:=((mem[eqtb[25332+n].hh.rh].hh.b1)
div 8)*8+mem[p+5].hh.b1;end;s:=mem[r+2].hh.rh;
mem[s].hh.rh:=mem[p+4].hh.lh;
if mem[r+2].hh.lh=p then{1038:}begin if mem[r].hh.b0=1 then if(mem[r+1].
hh.lh=p)and(mem[r+1].hh.rh<>-268435455)then begin while mem[s].hh.rh<>
mem[r+1].hh.rh do s:=mem[s].hh.rh;mem[s].hh.rh:=-268435455;
eqtb[24538].hh.rh:=mem[p+4].hh.rh;
mem[p+4].hh.lh:=prunepagetop(mem[r+1].hh.rh,false);
if mem[p+4].hh.lh<>-268435455 then begin tempptr:=vpackage(mem[p+4].hh.
lh,0,1,1073741823);mem[p+3].int:=mem[tempptr+3].int+mem[tempptr+2].int;
deleteglueref(mem[tempptr+7].hh.rh);deleteglueref(mem[tempptr+7].hh.lh);
freenode(tempptr,10);wait:=true;end;end;mem[r+2].hh.lh:=-268435455;
n:=mem[r].hh.b1;tempptr:=mem[eqtb[25332+n].hh.rh+5].hh.rh;
deleteglueref(mem[eqtb[25332+n].hh.rh+7].hh.rh);
deleteglueref(mem[eqtb[25332+n].hh.rh+7].hh.lh);
flushnodelist(mem[eqtb[25332+n].hh.rh].hh.rh);
freenode(eqtb[25332+n].hh.rh,10);
eqtb[25332+n].hh.rh:=vpackage(tempptr,0,1,1073741823);
mem[eqtb[25332+n].hh.rh].hh.b1:=((mem[eqtb[25332+n].hh.rh].hh.b1)div 8)
*8+mem[p+5].hh.b1;
end{:1038}else begin while mem[s].hh.rh<>-268435455 do s:=mem[s].hh.rh;
mem[r+2].hh.rh:=s;end;end;{1039:}mem[prevp].hh.rh:=mem[p].hh.rh;
mem[p].hh.rh:=-268435455;if wait then begin mem[q].hh.rh:=p;q:=p;
incr(insertpenalties);end else begin deleteglueref(mem[p+4].hh.rh);
freenode(p,6);end;p:=prevp{:1039};end{:1037};
end else if mem[p].hh.b0=6 then if mem[p+1].hh.lh<>0 then{1584:}begin
findsaelement(6,mem[p+1].hh.lh,true);
if mem[curptr+1].hh.rh=-268435455 then begin mem[curptr+1].hh.rh:=mem[p
+1].hh.rh;incr(mem[mem[p+1].hh.rh].hh.lh);end;
if mem[curptr+2].hh.lh<>-268435455 then deletetokenref(mem[curptr+2].hh.
lh);mem[curptr+2].hh.lh:=mem[p+1].hh.rh;incr(mem[mem[p+1].hh.rh].hh.lh);
end{:1584}else{1033:}begin if curmark[1]=-268435455 then begin curmark[1
]:=mem[p+1].hh.rh;incr(mem[curmark[1]].hh.lh);end;
if curmark[2]<>-268435455 then deletetokenref(curmark[2]);
curmark[2]:=mem[p+1].hh.rh;incr(mem[curmark[2]].hh.lh);end{:1033};
prevp:=p;p:=mem[prevp].hh.rh;end;eqtb[24538].hh.rh:=savesplittopskip;
{1034:}if p<>-268435455 then begin if mem[memtop-1].hh.rh=-268435455
then if nestptr=0 then curlist.tailfield:=pagetail else nest[0].
tailfield:=pagetail;mem[pagetail].hh.rh:=mem[memtop-1].hh.rh;
mem[memtop-1].hh.rh:=p;mem[prevp].hh.rh:=-268435455;end;
savevbadness:=eqtb[28958].int;eqtb[28958].int:=10000;
savevfuzz:=eqtb[29523].int;eqtb[29523].int:=1073741823;
eqtb[25587].hh.rh:=vpackage(mem[memtop-2].hh.rh,bestsize,0,pagemaxdepth)
;mem[eqtb[25587].hh.rh].hh.b1:=((mem[eqtb[25587].hh.rh].hh.b1)div 8)*8+
pagedir;eqtb[28958].int:=savevbadness;eqtb[29523].int:=savevfuzz;
if lastglue<>268435455 then deleteglueref(lastglue);
{1008:}pagecontents:=0;pagetail:=memtop-2;
mem[memtop-2].hh.rh:=-268435455;lastglue:=268435455;lastpenalty:=0;
lastkern:=0;lastnodetype:=-1;pagesofar[8]:=0;pagemaxdepth:=0{:1008};
if q<>memtop-4 then begin mem[memtop-2].hh.rh:=mem[memtop-4].hh.rh;
pagetail:=q;end{:1034};{1036:}r:=mem[memtop].hh.rh;
while r<>memtop do begin q:=mem[r].hh.rh;freenode(r,4);r:=q;end;
mem[memtop].hh.rh:=memtop{:1036}{:1031};
if saroot[6]<>-268435455 then if domarks(2,0,saroot[6])then saroot[6]:=
-268435455;
if(curmark[0]<>-268435455)and(curmark[1]=-268435455)then begin curmark[1
]:=curmark[0];incr(mem[curmark[0]].hh.lh);end;
if eqtb[25062].hh.rh<>-268435455 then if deadcycles>=eqtb[28971].int
then{1041:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1104);
end;printint(deadcycles);print(1105);begin helpptr:=3;helpline[2]:=1106;
helpline[1]:=1107;helpline[0]:=1108;end;error;
end{:1041}else{1042:}begin outputactive:=true;incr(deadcycles);pushnest;
curlist.modefield:=-1;curlist.auxfield.int:=-65536000;
curlist.mlfield:=-line;begintokenlist(eqtb[25062].hh.rh,6);
newsavelevel(8);normalparagraph;scanleftbrace;goto 10;end{:1042};
{1040:}begin if mem[memtop-2].hh.rh<>-268435455 then begin if mem[memtop
-1].hh.rh=-268435455 then if nestptr=0 then curlist.tailfield:=pagetail
else nest[0].tailfield:=pagetail else mem[pagetail].hh.rh:=mem[memtop-1]
.hh.rh;mem[memtop-1].hh.rh:=mem[memtop-2].hh.rh;
mem[memtop-2].hh.rh:=-268435455;pagetail:=memtop-2;end;
flushnodelist(discptr[2]);discptr[2]:=-268435455;
shipout(eqtb[25587].hh.rh);eqtb[25587].hh.rh:=-268435455;end{:1040};
10:end;{:1029}procedure buildpage;label 10,30,31,22,80,90;
var p:halfword;q,r:halfword;b,c:integer;pi:integer;n:0..255;
delta,h,w:scaled;
begin if(mem[memtop-1].hh.rh=-268435455)or outputactive then goto 10;
repeat 22:p:=mem[memtop-1].hh.rh;
{1013:}if lastglue<>268435455 then deleteglueref(lastglue);
lastpenalty:=0;lastkern:=0;
if mem[p].hh.b0<2 then lastnodetype:=mem[p].hh.b0+1 else if mem[p].hh.b0
=2 then lastnodetype:=mem[mem[p+5].hh.rh].hh.b0+1 else if mem[p].hh.b0<5
then lastnodetype:=mem[p].hh.b0 else lastnodetype:=mem[p].hh.b0-1;
if mem[p].hh.b0=12 then begin lastglue:=mem[p+1].hh.lh;
incr(mem[lastglue].hh.rh);end else begin lastglue:=268435455;
if mem[p].hh.b0=14 then lastpenalty:=mem[p+1].int else if mem[p].hh.b0=
13 then lastkern:=mem[p+1].int;end{:1013};
{1014:}{1017:}case mem[p].hh.b0 of 0,1,2,3:if pagecontents<2 then{1018:}
begin if pagecontents=0 then freezepagespecs(2)else pagecontents:=2;
q:=newskipparam(9);
if mem[tempptr+1].int>mem[p+3].int then mem[tempptr+1].int:=mem[tempptr
+1].int-mem[p+3].int else mem[tempptr+1].int:=0;mem[q].hh.rh:=p;
mem[memtop-1].hh.rh:=q;goto 22;
end{:1018}else{1019:}begin pagesofar[1]:=pagesofar[1]+pagesofar[8]+mem[p
+3].int;pagesofar[8]:=mem[p+2].int;goto 80;end{:1019};
10:{1383:}goto 80{:1383};
12:if pagecontents<2 then goto 31 else if(mem[pagetail].hh.b0<11)then pi
:=0 else goto 90;
13:if pagecontents<2 then goto 31 else if mem[p].hh.rh=-268435455 then
goto 10 else if mem[mem[p].hh.rh].hh.b0=12 then pi:=0 else goto 90;
14:if pagecontents<2 then goto 31 else pi:=mem[p+1].int;6:goto 80;
4:{1025:}begin if pagecontents=0 then freezepagespecs(1);
n:=mem[p].hh.b1;r:=memtop;
while n>=mem[mem[r].hh.rh].hh.b1 do r:=mem[r].hh.rh;n:=n;
if mem[r].hh.b1<>n then{1026:}begin q:=getnode(4);
mem[q].hh.rh:=mem[r].hh.rh;mem[r].hh.rh:=q;r:=q;mem[r].hh.b1:=n;
mem[r].hh.b0:=0;ensurevbox(n);
if eqtb[25332+n].hh.rh=-268435455 then mem[r+3].int:=0 else begin if mem
[p+5].hh.b1<>((mem[eqtb[25332+n].hh.rh].hh.b1)mod 8)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1095);
end;begin helpptr:=3;helpline[2]:=1087;helpline[1]:=1096;
helpline[0]:=1089;end;
boxerror(n)end else mem[r+3].int:=mem[eqtb[25332+n].hh.rh+3].int+mem[
eqtb[25332+n].hh.rh+2].int;end;mem[r+2].hh.lh:=-268435455;
q:=eqtb[24549+n].hh.rh;
if eqtb[29002+n].int=1000 then h:=mem[r+3].int else h:=xovern(mem[r+3].
int,1000)*eqtb[29002+n].int;pagesofar[0]:=pagesofar[0]-h-mem[q+1].int;
pagesofar[2+mem[q].hh.b0]:=pagesofar[2+mem[q].hh.b0]+mem[q+2].int;
pagesofar[7]:=pagesofar[7]+mem[q+3].int;
if(mem[q].hh.b1<>0)and(mem[q+3].int<>0)then begin begin if interaction=3
then;if filelineerrorstylep then printfileline else printnl(263);
print(1097);end;printesc(416);printint(n);begin helpptr:=3;
helpline[2]:=1098;helpline[1]:=1099;helpline[0]:=1017;end;error;end;
end{:1026};
if mem[r].hh.b0=1 then insertpenalties:=insertpenalties+mem[p+1].int
else begin mem[r+2].hh.rh:=p;
delta:=pagesofar[0]-pagesofar[1]-pagesofar[8]+pagesofar[7];
if eqtb[29002+n].int=1000 then h:=mem[p+3].int else h:=xovern(mem[p+3].
int,1000)*eqtb[29002+n].int;
if((h<=0)or(h<=delta))and(mem[p+3].int+mem[r+3].int<=eqtb[29539+n].int)
then begin pagesofar[0]:=pagesofar[0]-h;
mem[r+3].int:=mem[r+3].int+mem[p+3].int;
end else{1027:}begin if eqtb[29002+n].int<=0 then w:=1073741823 else
begin w:=pagesofar[0]-pagesofar[1]-pagesofar[8];
if eqtb[29002+n].int<>1000 then w:=xovern(w,eqtb[29002+n].int)*1000;end;
if w>eqtb[29539+n].int-mem[r+3].int then w:=eqtb[29539+n].int-mem[r+3].
int;q:=vertbreak(mem[p+4].hh.lh,w,mem[p+2].int);
mem[r+3].int:=mem[r+3].int+bestheightplusdepth;
ifdef('STAT')if eqtb[28964].int>0 then{1028:}begin begindiagnostic;
printnl(1100);printint(n);print(1101);printscaled(w);printchar(44);
printscaled(bestheightplusdepth);print(1026);
if q=-268435455 then printint(-10000)else if mem[q].hh.b0=14 then
printint(mem[q+1].int)else printchar(48);enddiagnostic(false);
end{:1028};
endif('STAT')if eqtb[29002+n].int<>1000 then bestheightplusdepth:=xovern
(bestheightplusdepth,1000)*eqtb[29002+n].int;
pagesofar[0]:=pagesofar[0]-bestheightplusdepth;mem[r].hh.b0:=1;
mem[r+1].hh.rh:=q;mem[r+1].hh.lh:=p;
if q=-268435455 then insertpenalties:=insertpenalties-10000 else if mem[
q].hh.b0=14 then insertpenalties:=insertpenalties+mem[q+1].int;
end{:1027};end;goto 80;end{:1025};others:confusion(1090)end{:1017};
{1022:}if pi<10000 then begin{1024:}if pagesofar[1]<pagesofar[0]then if(
pagesofar[3]<>0)or(pagesofar[4]<>0)or(pagesofar[5]<>0)or(pagesofar[6]<>0
)then b:=0 else b:=badness(pagesofar[0]-pagesofar[1],pagesofar[2])else
if pagesofar[1]-pagesofar[0]>pagesofar[7]then b:=1073741823 else b:=
badness(pagesofar[1]-pagesofar[0],pagesofar[7]){:1024};
if b<1073741823 then if pi<=-10000 then c:=pi else if b<10000 then c:=b+
pi+insertpenalties else c:=100000 else c:=b;
if insertpenalties>=10000 then c:=1073741823;
ifdef('STAT')if eqtb[28964].int>0 then{1023:}begin begindiagnostic;
printnl(37);print(1022);printtotals;print(1093);
printscaled(pagesofar[0]);print(1025);
if b=1073741823 then printchar(42)else printint(b);print(1026);
printint(pi);print(1094);
if c=1073741823 then printchar(42)else printint(c);
if c<=leastpagecost then printchar(35);enddiagnostic(false);end{:1023};
endif('STAT')if c<=leastpagecost then begin bestpagebreak:=p;
bestsize:=pagesofar[0];leastpagecost:=c;r:=mem[memtop].hh.rh;
while r<>memtop do begin mem[r+2].hh.lh:=mem[r+2].hh.rh;r:=mem[r].hh.rh;
end;end;if(c=1073741823)or(pi<=-10000)then begin fireup(p);
if outputactive then goto 10;goto 30;end;end{:1022};
if(mem[p].hh.b0<12)or(mem[p].hh.b0>13)then goto 80;
90:{1021:}if mem[p].hh.b0=13 then q:=p else begin q:=mem[p+1].hh.lh;
pagesofar[2+mem[q].hh.b0]:=pagesofar[2+mem[q].hh.b0]+mem[q+2].int;
pagesofar[7]:=pagesofar[7]+mem[q+3].int;
if(mem[q].hh.b1<>0)and(mem[q+3].int<>0)then begin begin if interaction=3
then;if filelineerrorstylep then printfileline else printnl(263);
print(1091);end;begin helpptr:=4;helpline[3]:=1092;helpline[2]:=1058;
helpline[1]:=1059;helpline[0]:=1017;end;error;r:=newspec(q);
mem[r].hh.b1:=0;deleteglueref(q);mem[p+1].hh.lh:=r;q:=r;end;end;
pagesofar[1]:=pagesofar[1]+pagesofar[8]+mem[q+1].int;
pagesofar[8]:=0{:1021};
80:{1020:}if pagesofar[8]>pagemaxdepth then begin pagesofar[1]:=
pagesofar[1]+pagesofar[8]-pagemaxdepth;pagesofar[8]:=pagemaxdepth;end;
{:1020};{1015:}mem[pagetail].hh.rh:=p;pagetail:=p;
mem[memtop-1].hh.rh:=mem[p].hh.rh;mem[p].hh.rh:=-268435455;
goto 30{:1015};31:{1016:}mem[memtop-1].hh.rh:=mem[p].hh.rh;
mem[p].hh.rh:=-268435455;
if eqtb[28999].int>0 then begin if discptr[2]=-268435455 then discptr[2]
:=p else mem[discptr[1]].hh.rh:=p;discptr[1]:=p;
end else flushnodelist(p){:1016};30:{:1014};
until mem[memtop-1].hh.rh=-268435455;
{1012:}if nestptr=0 then curlist.tailfield:=memtop-1 else nest[0].
tailfield:=memtop-1{:1012};10:end;
{:1011}{1047:}{1061:}procedure appspace;var q:halfword;
begin if(curlist.auxfield.hh.lh>=2000)and(eqtb[24541].hh.rh<>membot)then
q:=newparamglue(13)else begin if eqtb[24540].hh.rh<>membot then mainp:=
eqtb[24540].hh.rh else{1060:}begin mainp:=fontglue[eqtb[25588].hh.rh];
if mainp=-268435455 then begin mainp:=newspec(membot);
maink:=parambase[eqtb[25588].hh.rh]+2;
mem[mainp+1].int:=fontinfo[maink].int;
mem[mainp+2].int:=fontinfo[maink+1].int;
mem[mainp+3].int:=fontinfo[maink+2].int;
fontglue[eqtb[25588].hh.rh]:=mainp;end;end{:1060};mainp:=newspec(mainp);
{1062:}if curlist.auxfield.hh.lh>=2000 then mem[mainp+1].int:=mem[mainp
+1].int+fontinfo[7+parambase[eqtb[25588].hh.rh]].int;
mem[mainp+2].int:=xnoverd(mem[mainp+2].int,curlist.auxfield.hh.lh,1000);
mem[mainp+3].int:=xnoverd(mem[mainp+3].int,1000,curlist.auxfield.hh.lh)
{:1062};q:=newglue(mainp);mem[mainp].hh.rh:=-268435455;end;
if not(curlist.tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=5)
then begin mem[curlist.pnodefield].hh.rh:=q;
mem[q].hh.rh:=curlist.tailfield;curlist.pnodefield:=q;
end else begin mem[curlist.tailfield].hh.rh:=q;curlist.tailfield:=q;
end end;{:1061}{1065:}procedure insertdollarsign;begin backinput;
curtok:=804;begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1116);
end;begin helpptr:=2;helpline[1]:=1117;helpline[0]:=1118;end;inserror;
end;{:1065}{1067:}procedure youcant;begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(746);
end;printcmdchr(curcmd,curchr);printinmode(curlist.modefield);end;
{:1067}{1068:}procedure reportillegalcase;begin youcant;
begin helpptr:=4;helpline[3]:=1119;helpline[2]:=1120;helpline[1]:=1121;
helpline[0]:=1122;end;error;end;
{:1068}{1069:}function privileged:boolean;
begin if curlist.modefield>0 then privileged:=true else begin
reportillegalcase;privileged:=false;end;end;
{:1069}{1072:}function itsallover:boolean;label 10;
begin if privileged then begin if(memtop-2=pagetail)and(curlist.
headfield=curlist.tailfield)and(deadcycles=0)then begin itsallover:=true
;goto 10;end;backinput;begin mem[curlist.tailfield].hh.rh:=newnullbox;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield+1].int:=eqtb[29517].int;
begin mem[curlist.tailfield].hh.rh:=newglue(membot+12);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
begin mem[curlist.tailfield].hh.rh:=newpenalty(-1073741824);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;buildpage;end;
itsallover:=false;10:end;{:1072}{1078:}procedure appendglue;
var s:smallnumber;begin s:=curchr;case s of 0:curval:=membot+4;
1:curval:=membot+8;2:curval:=membot+12;3:curval:=membot+16;
4:curval:=membot+20;5:scanglue(2);6:scanglue(3);end;
begin mem[curlist.tailfield].hh.rh:=newglue(curval);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
inhibitglueflag:=false;if s>=5 then begin decr(mem[curval].hh.rh);
if s>5 then mem[curlist.tailfield].hh.b1:=99;end;end;
{:1078}{1079:}procedure appendkern;var s:quarterword;begin s:=curchr;
scandimen(s=99,false,false);inhibitglueflag:=false;
if not(curlist.tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=5)
then begin begin mem[curlist.pnodefield].hh.rh:=newkern(curval);
mem[mem[curlist.pnodefield].hh.rh].hh.rh:=curlist.tailfield;
curlist.pnodefield:=mem[curlist.pnodefield].hh.rh;end;
mem[curlist.pnodefield].hh.b1:=s;
end else begin begin mem[curlist.tailfield].hh.rh:=newkern(curval);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=s;end;end;{:1079}{1082:}procedure offsave;
var p:halfword;
begin if curgroup=0 then{1084:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(869);
end;printcmdchr(curcmd,curchr);begin helpptr:=1;helpline[0]:=1142;end;
error;end{:1084}else begin backinput;p:=getavail;mem[memtop-3].hh.rh:=p;
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(681);
end;{1083:}case curgroup of 14:begin mem[p].hh.lh:=81051;printesc(555);
end;15:begin mem[p].hh.lh:=804;printchar(36);end;
16:begin mem[p].hh.lh:=81052;mem[p].hh.rh:=getavail;p:=mem[p].hh.rh;
mem[p].hh.lh:=3118;printesc(1141);end;others:begin mem[p].hh.lh:=637;
printchar(125);end end{:1083};print(682);
begintokenlist(mem[memtop-3].hh.rh,4);begin helpptr:=5;
helpline[4]:=1136;helpline[3]:=1137;helpline[2]:=1138;helpline[1]:=1139;
helpline[0]:=1140;end;error;end;end;
{:1082}{1087:}procedure extrarightbrace;
begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1147);
end;case curgroup of 14:printesc(555);15:printchar(36);16:printesc(970);
end;begin helpptr:=5;helpline[4]:=1148;helpline[3]:=1149;
helpline[2]:=1150;helpline[1]:=1151;helpline[0]:=1152;end;error;
incr(alignstate);end;{:1087}{1088:}procedure normalparagraph;
begin if eqtb[28950].int<>0 then eqworddefine(28950,0);
if eqtb[29531].int<>0 then eqworddefine(29531,0);
if eqtb[28972].int<>1 then eqworddefine(28972,1);
if eqtb[25061].hh.rh<>-268435455 then eqdefine(25061,130,-268435455);
if eqtb[25328].hh.rh<>-268435455 then eqdefine(25328,130,-268435455);
end;{:1088}{1093:}procedure boxend(boxcontext:integer);var p:halfword;
q:halfword;a:smallnumber;
begin if boxcontext<1073741824 then{1094:}begin if curbox<>-268435455
then begin p:=mem[curbox].hh.rh;mem[curbox].hh.rh:=-268435455;
while p<>-268435455 do begin q:=p;p:=mem[p].hh.rh;
if((mem[q].hh.b1)mod 8)=abs(curlist.dirfield)then begin mem[q+5].hh.rh:=
curbox;curbox:=q;mem[curbox].hh.rh:=-268435455;
end else begin deleteglueref(mem[q+7].hh.rh);
deleteglueref(mem[q+7].hh.lh);freenode(q,10);end;end;
if((mem[curbox].hh.b1)mod 8)<>abs(curlist.dirfield)then curbox:=
newdirnode(curbox,abs(curlist.dirfield));mem[curbox+4].int:=boxcontext;
if abs(curlist.modefield)=1 then begin appendtovlist(curbox);
if adjusttail<>-268435455 then begin if memtop-5<>adjusttail then begin
mem[curlist.tailfield].hh.rh:=mem[memtop-5].hh.rh;
curlist.tailfield:=adjusttail;end;adjusttail:=-268435455;end;
if curlist.modefield>0 then buildpage;
end else begin if abs(curlist.modefield)=114 then curlist.auxfield.hh.lh
:=1000 else begin p:=newnoad;mem[p+1].hh.rh:=2;mem[p+1].hh.lh:=curbox;
curbox:=p;end;mem[curlist.tailfield].hh.rh:=curbox;
curlist.tailfield:=curbox;end;end;
end{:1094}else if boxcontext<1073872896 then{1095:}begin if boxcontext<
1073807360 then begin curval:=boxcontext-1073741824;a:=0;
end else begin curval:=boxcontext-1073807360;a:=4;end;
if curval<256 then if(a>=4)then geqdefine(25332+curval,131,curbox)else
eqdefine(25332+curval,131,curbox)else begin findsaelement(4,curval,true)
;if(a>=4)then gsadef(curptr,curbox)else sadef(curptr,curbox);end;
end{:1095}else if curbox<>-268435455 then if boxcontext>1073872896 then
{1096:}begin{421:}repeat getxtoken;
until(curcmd<>10)and(curcmd<>0){:421};
if((curcmd=29)and(abs(curlist.modefield)<>1))or((curcmd=30)and(abs(
curlist.modefield)=1))then begin appendglue;
mem[curlist.tailfield].hh.b1:=boxcontext-(1073872797);
if mem[curbox].hh.b0<=2 then begin p:=mem[curbox].hh.rh;
mem[curbox].hh.rh:=-268435455;while p<>-268435455 do begin q:=p;
p:=mem[p].hh.rh;
if((mem[q].hh.b1)mod 8)=abs(curlist.dirfield)then begin mem[q+5].hh.rh:=
curbox;curbox:=q;mem[curbox].hh.rh:=-268435455;
end else begin deleteglueref(mem[q+7].hh.rh);
deleteglueref(mem[q+7].hh.lh);freenode(q,10);end;end;
if((mem[curbox].hh.b1)mod 8)<>abs(curlist.dirfield)then curbox:=
newdirnode(curbox,abs(curlist.dirfield));end;
mem[curlist.tailfield+1].hh.rh:=curbox;
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1175);
end;begin helpptr:=3;helpline[2]:=1176;helpline[1]:=1177;
helpline[0]:=1178;end;backerror;flushnodelist(curbox);end;
end{:1096}else shipout(curbox);end;
{:1093}{1097:}procedure beginbox(boxcontext:integer);label 10,30;
var p,q:halfword;r:halfword;s:halfword;t:halfword;fm:integer;gm:integer;
fd,gd:integer;disp,pdisp:scaled;adir:eightbits;tx:halfword;
m:quarterword;k:halfword;n:halfword;
begin case curchr of 0:begin scanregisternum;
if curval<256 then curbox:=eqtb[25332+curval].hh.rh else begin
findsaelement(4,curval,false);
if curptr=-268435455 then curbox:=-268435455 else curbox:=mem[curptr+1].
hh.rh;end;
if curval<256 then eqtb[25332+curval].hh.rh:=-268435455 else begin
findsaelement(4,curval,false);
if curptr<>-268435455 then begin mem[curptr+1].hh.rh:=-268435455;
incr(mem[curptr+1].hh.lh);deletesaref(curptr);end;end;end;
1:begin scanregisternum;
if curval<256 then q:=eqtb[25332+curval].hh.rh else begin findsaelement(
4,curval,false);
if curptr=-268435455 then q:=-268435455 else q:=mem[curptr+1].hh.rh;end;
curbox:=copynodelist(q);end;2:{1098:}begin curbox:=-268435455;
if abs(curlist.modefield)=227 then begin youcant;begin helpptr:=1;
helpline[0]:=1184;end;error;
end else if(curlist.modefield=1)and(curlist.headfield=curlist.tailfield)
then begin youcant;begin helpptr:=2;helpline[1]:=1185;helpline[0]:=1186;
end;error;end else begin tx:=curlist.tailfield;
if not(tx>=himemmin)then if mem[tx].hh.b0=5 then tx:=curlist.pnodefield;
if not(tx>=himemmin)then if(mem[tx].hh.b0=5)or((mem[tx].hh.b0=11)and(mem
[tx].hh.b1=3))then begin r:=curlist.headfield;
q:=mem[curlist.headfield].hh.rh;
while q<>tx do begin if(q>=himemmin)then r:=q else if(mem[q].hh.b0<>5)
and((mem[q].hh.b0<>11)or(mem[q].hh.b1<>3))then r:=q;q:=mem[q].hh.rh;end;
tx:=r;end;
if not(tx>=himemmin)and(curlist.headfield<>tx)then if(mem[tx].hh.b0=0)or
(mem[tx].hh.b0=1)or(mem[tx].hh.b0=2)then{1099:}begin q:=curlist.
headfield;p:=-268435455;r:=-268435455;fm:=0;fd:=0;disp:=0;pdisp:=0;
repeat s:=r;r:=p;p:=q;fm:=fm div 2;fd:=fd div 2;
if not(q>=himemmin)then if mem[q].hh.b0=9 then begin for m:=1 to mem[q].
hh.b1 do begin p:=mem[p].hh.rh;if p=tx then goto 30;
end end else if(mem[q].hh.b0=11)and(mem[q].hh.b1=2)then fm:=2 else if
mem[q].hh.b0=5 then begin pdisp:=disp;disp:=mem[q+1].int;fd:=2;end;
q:=mem[p].hh.rh;until q=tx;q:=mem[tx].hh.rh;mem[p].hh.rh:=q;
mem[tx].hh.rh:=-268435455;
if q=-268435455 then begin curlist.tailfield:=p;gm:=0;gd:=0;
end else begin if mem[q].hh.b0=11 then begin gm:=2;
if mem[q].hh.rh=-268435455 then gd:=0 else if mem[mem[q].hh.rh].hh.b0=5
then gd:=1 else confusion(1180);
end else if mem[q].hh.b0=5 then begin curlist.pnodefield:=p;gd:=2;
if mem[q].hh.rh=-268435455 then gm:=0 else if mem[mem[q].hh.rh].hh.b0=11
then gm:=1 else confusion(1181);end else confusion(1182);end;
if gm=0 then if fm=2 then confusion(1179)else if fm=1 then confusion(
1183);if(fm+fd)=1 then begin fm:=0;fd:=0;end;if gm=0 then fm:=0;
if gd=0 then fd:=0;if fd>0 then begin if gm=0 then begin t:=q;
q:=-268435455;mem[p].hh.rh:=q;curlist.tailfield:=p;
end else if gm=1 then begin t:=q;q:=mem[q].hh.rh;mem[p].hh.rh:=q;gm:=2;
end else begin t:=mem[q].hh.rh;mem[q].hh.rh:=-268435455;
curlist.tailfield:=q;end;if fd=1 then begin curlist.pnodefield:=s;
mem[r+1].int:=mem[t+1].int;end else begin curlist.pnodefield:=r;
mem[p+1].int:=mem[t+1].int;end;curlist.pdispfield:=pdisp;freenode(t,2);
gd:=0;end;if fm>0 then begin if gd=0 then begin t:=q;q:=-268435455;
mem[p].hh.rh:=q;curlist.tailfield:=p;end else if gd=1 then begin t:=q;
q:=mem[q].hh.rh;mem[p].hh.rh:=q;curlist.pnodefield:=p;
mem[t].hh.rh:=-268435455 end else begin t:=mem[q].hh.rh;
mem[q].hh.rh:=-268435455;curlist.tailfield:=q;end;
if fm=1 then begin mem[s].hh.rh:=p;mem[r].hh.rh:=t;t:=r;
curlist.pnodefield:=s;end else begin mem[r].hh.rh:=q;mem[p].hh.rh:=t;
t:=p;
if q=-268435455 then curlist.tailfield:=r else curlist.pnodefield:=r;
end;flushnodelist(t);end;curbox:=tx;mem[curbox+4].int:=0;
if mem[curbox].hh.b0=2 then begin mem[mem[curbox+5].hh.rh].hh.rh:=curbox
;curbox:=mem[curbox+5].hh.rh;mem[mem[curbox].hh.rh+5].hh.rh:=-268435455;
end else if((mem[curbox].hh.b1)mod 8)=0 then mem[curbox].hh.b1:=((mem[
curbox].hh.b1)div 8)*8+abs(curlist.dirfield);end{:1099};30:end;
end{:1098};3:{1100:}begin scanregisternum;n:=curval;
if not scankeyword(935)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1187);
end;begin helpptr:=2;helpline[1]:=1188;helpline[0]:=1189;end;error;end;
scandimen(false,false,false);curbox:=vsplit(n,curval);end{:1100};
others:{1101:}begin k:=curchr-4;savestack[saveptr+0].int:=boxcontext;
adir:=curlist.adjdirfield;
if k=114 then if(boxcontext<1073741824)and(abs(curlist.modefield)=1)then
begin adir:=abs(curlist.dirfield);scanspec(3,true);
end else scanspec(2,true)else begin if k=1 then scanspec(4,true)else
begin scanspec(5,true);k:=1;end;normalparagraph;end;pushnest;
curlist.modefield:=-k;curlist.adjdirfield:=adir;
if k=1 then begin curlist.auxfield.int:=-65536000;
if eqtb[25067].hh.rh<>-268435455 then begintokenlist(eqtb[25067].hh.rh,
11);end else begin curlist.auxfield.hh.lh:=1000;
if eqtb[25066].hh.rh<>-268435455 then begintokenlist(eqtb[25066].hh.rh,
10);end;goto 10;end{:1101}end;boxend(boxcontext);10:end;
{:1097}{1102:}procedure scanbox(boxcontext:integer);
begin{421:}repeat getxtoken;until(curcmd<>10)and(curcmd<>0){:421};
if curcmd=23 then beginbox(boxcontext)else if(boxcontext>=1073872897)and
((curcmd=39)or(curcmd=38))then begin curbox:=scanrulespec;
boxend(boxcontext);end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1190);
end;begin helpptr:=3;helpline[2]:=1191;helpline[1]:=1192;
helpline[0]:=1193;end;backerror;end;end;
{:1102}{1104:}procedure package(c:smallnumber);var h:scaled;p:halfword;
d:scaled;begin d:=eqtb[29521].int;deleteglueref(curkanjiskip);
deleteglueref(curxkanjiskip);
if eqtb[26359].hh.rh>0 then curkanjiskip:=eqtb[24543].hh.rh else
curkanjiskip:=membot;
if eqtb[26360].hh.rh>0 then curxkanjiskip:=eqtb[24544].hh.rh else
curxkanjiskip:=membot;incr(mem[curkanjiskip].hh.rh);
incr(mem[curxkanjiskip].hh.rh);unsave;saveptr:=saveptr-3;
if curlist.modefield=-114 then begin curbox:=hpack(mem[curlist.headfield
].hh.rh,savestack[saveptr+2].int,savestack[saveptr+1].int);
mem[curbox].hh.b1:=((mem[curbox].hh.b1)div 8)*8+abs(curlist.dirfield);
popnest;
end else begin curbox:=vpackage(mem[curlist.headfield].hh.rh,savestack[
saveptr+2].int,savestack[saveptr+1].int,d);
mem[curbox].hh.b1:=((mem[curbox].hh.b1)div 8)*8+abs(curlist.dirfield);
popnest;if c=4 then{1105:}begin h:=0;p:=mem[curbox+5].hh.rh;
if p<>-268435455 then if mem[p].hh.b0<=3 then h:=mem[p+3].int;
mem[curbox+2].int:=mem[curbox+2].int-h+mem[curbox+3].int;
mem[curbox+3].int:=h;end{:1105};end;boxend(savestack[saveptr+0].int);
end;{:1104}{1109:}function normmin(h:integer):smallnumber;
begin if h<=0 then normmin:=1 else if h>=63 then normmin:=63 else
normmin:=h;end;procedure newgraf(indented:boolean);
begin curlist.pgfield:=0;
if(curlist.modefield=1)or(curlist.headfield<>curlist.tailfield)then
begin mem[curlist.tailfield].hh.rh:=newparamglue(2);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
inhibitglueflag:=false;pushnest;
curlist.adjdirfield:=abs(curlist.dirfield);curlist.modefield:=114;
curlist.auxfield.hh.lh:=1000;
if eqtb[28982].int<=0 then curlang:=0 else if eqtb[28982].int>255 then
curlang:=0 else curlang:=eqtb[28982].int;
curlist.auxfield.hh.rh:=curlang;
curlist.pgfield:=(normmin(eqtb[28983].int)*64+normmin(eqtb[28984].int))
*65536+curlang;if indented then begin curlist.tailfield:=newnullbox;
mem[curlist.headfield].hh.rh:=curlist.tailfield;
mem[curlist.tailfield+1].int:=eqtb[29514].int;
if(insertsrcspecialeverypar)then insertsrcspecial;end;
if eqtb[25063].hh.rh<>-268435455 then begintokenlist(eqtb[25063].hh.rh,7
);if nestptr=1 then buildpage;end;{:1109}{1111:}procedure indentinhmode;
var p,q:halfword;begin if curchr>0 then begin p:=newnullbox;
mem[p+1].int:=eqtb[29514].int;
if abs(curlist.modefield)=114 then curlist.auxfield.hh.lh:=1000 else
begin q:=newnoad;mem[q+1].hh.rh:=2;mem[q+1].hh.lh:=p;p:=q;end;
begin mem[curlist.tailfield].hh.rh:=p;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;end;end;
{:1111}{1113:}procedure headforvmode;
begin if curlist.modefield<0 then if curcmd<>39 then offsave else begin
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(746);
end;printesc(562);print(1196);begin helpptr:=2;helpline[1]:=1197;
helpline[0]:=1198;end;error;end else begin backinput;curtok:=partoken;
backinput;curinput.indexfield:=4;end;end;
{:1113}{1114:}procedure endgraf;
begin if curlist.modefield=114 then begin if curlist.headfield=curlist.
tailfield then popnest else begin adjusthlist(curlist.headfield,true);
linebreak(false)end;
if curlist.eTeXauxfield<>-268435455 then begin flushlist(curlist.
eTeXauxfield);curlist.eTeXauxfield:=-268435455;end;normalparagraph;
errorcount:=0;end;end;{:1114}{1117:}procedure begininsertoradjust;
begin if curcmd=41 then curval:=255 else begin scaneightbitint;
if curval=255 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1199);
end;printesc(335);printint(255);begin helpptr:=1;helpline[0]:=1200;end;
error;curval:=0;end;end;savestack[saveptr+0].int:=curval;incr(saveptr);
newsavelevel(11);scanleftbrace;normalparagraph;pushnest;
curlist.modefield:=-1;curlist.dirfield:=curlist.adjdirfield;
curlist.auxfield.int:=-65536000;end;{:1117}{1119:}procedure makemark;
var p:halfword;c:halfword;
begin if curchr=0 then c:=0 else begin scanregisternum;c:=curval;end;
p:=scantoks(false,true);p:=getnode(2);mem[p+1].hh.lh:=c;mem[p].hh.b0:=6;
mem[p].hh.b1:=0;mem[p+1].hh.rh:=defref;
if not(curlist.tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=5)
then begin mem[curlist.pnodefield].hh.rh:=p;
mem[mem[curlist.pnodefield].hh.rh].hh.rh:=curlist.tailfield;
curlist.pnodefield:=mem[curlist.pnodefield].hh.rh;
end else begin mem[curlist.tailfield].hh.rh:=p;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;end;
{:1119}{1121:}procedure appendpenalty;begin scanint;
if not(curlist.tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=5)
then begin mem[curlist.pnodefield].hh.rh:=newpenalty(curval);
mem[mem[curlist.pnodefield].hh.rh].hh.rh:=curlist.tailfield;
curlist.pnodefield:=mem[curlist.pnodefield].hh.rh;
end else begin mem[curlist.tailfield].hh.rh:=newpenalty(curval);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
if curlist.modefield=1 then buildpage;end;
{:1121}{1123:}procedure deletelast;label 10;var p,q:halfword;r:halfword;
s:halfword;t:halfword;fm:integer;gm:integer;fd,gd:integer;
disp,pdisp:scaled;tx:halfword;m:quarterword;
begin if(curlist.modefield=1)and(curlist.tailfield=curlist.headfield)
then{1124:}begin if(curchr<>12)or(lastglue<>268435455)then begin youcant
;begin helpptr:=2;helpline[1]:=1185;helpline[0]:=1203;end;
if curchr=13 then helpline[0]:=(1204)else if curchr<>12 then helpline[0]
:=(1205);error;end;end{:1124}else begin tx:=curlist.tailfield;
if not(tx>=himemmin)then if mem[tx].hh.b0=5 then tx:=curlist.pnodefield;
if not(tx>=himemmin)then if(mem[tx].hh.b0=5)or((mem[tx].hh.b0=11)and(mem
[tx].hh.b1=3))then begin r:=curlist.headfield;
q:=mem[curlist.headfield].hh.rh;
while q<>tx do begin if(q>=himemmin)then r:=q else if(mem[q].hh.b0<>5)
and((mem[q].hh.b0<>11)or(mem[q].hh.b1<>3))then r:=q;q:=mem[q].hh.rh;end;
tx:=r;end;
if not(tx>=himemmin)then if mem[tx].hh.b0=curchr then begin q:=curlist.
headfield;p:=-268435455;r:=-268435455;fm:=0;fd:=0;disp:=0;pdisp:=0;
repeat s:=r;r:=p;p:=q;fm:=fm div 2;fd:=fd div 2;
if not(q>=himemmin)then if mem[q].hh.b0=9 then begin for m:=1 to mem[q].
hh.b1 do begin p:=mem[p].hh.rh;if p=tx then goto 10;
end end else if(mem[q].hh.b0=11)and(mem[q].hh.b1=2)then fm:=2 else if
mem[q].hh.b0=5 then begin pdisp:=disp;disp:=mem[q+1].int;fd:=2;end;
q:=mem[p].hh.rh;until q=tx;q:=mem[tx].hh.rh;mem[p].hh.rh:=q;
mem[tx].hh.rh:=-268435455;
if q=-268435455 then begin curlist.tailfield:=p;gm:=0;gd:=0;
end else begin if mem[q].hh.b0=11 then begin gm:=2;
if mem[q].hh.rh=-268435455 then gd:=0 else if mem[mem[q].hh.rh].hh.b0=5
then gd:=1 else confusion(1180);
end else if mem[q].hh.b0=5 then begin curlist.pnodefield:=p;gd:=2;
if mem[q].hh.rh=-268435455 then gm:=0 else if mem[mem[q].hh.rh].hh.b0=11
then gm:=1 else confusion(1181);end else confusion(1182);end;
if gm=0 then if fm=2 then confusion(1179)else if fm=1 then confusion(
1183);if(fm+fd)=1 then begin fm:=0;fd:=0;end;if gm=0 then fm:=0;
if gd=0 then fd:=0;if fd>0 then begin if gm=0 then begin t:=q;
q:=-268435455;mem[p].hh.rh:=q;curlist.tailfield:=p;
end else if gm=1 then begin t:=q;q:=mem[q].hh.rh;mem[p].hh.rh:=q;gm:=2;
end else begin t:=mem[q].hh.rh;mem[q].hh.rh:=-268435455;
curlist.tailfield:=q;end;if fd=1 then begin curlist.pnodefield:=s;
mem[r+1].int:=mem[t+1].int;end else begin curlist.pnodefield:=r;
mem[p+1].int:=mem[t+1].int;end;curlist.pdispfield:=pdisp;freenode(t,2);
gd:=0;end;if fm>0 then begin if gd=0 then begin t:=q;q:=-268435455;
mem[p].hh.rh:=q;curlist.tailfield:=p;end else if gd=1 then begin t:=q;
q:=mem[q].hh.rh;mem[p].hh.rh:=q;curlist.pnodefield:=p;
mem[t].hh.rh:=-268435455 end else begin t:=mem[q].hh.rh;
mem[q].hh.rh:=-268435455;curlist.tailfield:=q;end;
if fm=1 then begin mem[s].hh.rh:=p;mem[r].hh.rh:=t;t:=r;
curlist.pnodefield:=s;end else begin mem[r].hh.rh:=q;mem[p].hh.rh:=t;
t:=p;
if q=-268435455 then curlist.tailfield:=r else curlist.pnodefield:=r;
end;flushnodelist(t);end;flushnodelist(tx);end;end;10:end;
{:1123}{1128:}procedure unpackage;label 30,10;var p:halfword;c:0..1;
disp:scaled;
begin if curchr>1 then{1617:}begin mem[curlist.tailfield].hh.rh:=discptr
[curchr];discptr[curchr]:=-268435455;goto 30;end{:1617};c:=curchr;
scanregisternum;
if curval<256 then p:=eqtb[25332+curval].hh.rh else begin findsaelement(
4,curval,false);
if curptr=-268435455 then p:=-268435455 else p:=mem[curptr+1].hh.rh;end;
if p=-268435455 then goto 10;if mem[p].hh.b0=2 then p:=mem[p+5].hh.rh;
if(abs(curlist.modefield)=227)or((abs(curlist.modefield)=1)and(mem[p].hh
.b0<>1))or((abs(curlist.modefield)=114)and(mem[p].hh.b0<>0))then begin
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1213);
end;begin helpptr:=3;helpline[2]:=1214;helpline[1]:=1215;
helpline[0]:=1216;end;error;goto 10;end;
case((mem[p].hh.b1)mod 8)of 4,3,1:if abs(curlist.dirfield)<>((mem[p].hh.
b1)mod 8)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1217);
end;begin helpptr:=2;helpline[1]:=1214;helpline[0]:=1218;end;error;
goto 10;end;end;disp:=0;
if c=1 then mem[curlist.tailfield].hh.rh:=copynodelist(mem[p+5].hh.rh)
else begin if mem[p].hh.b0=2 then begin deleteglueref(mem[p+7].hh.rh);
deleteglueref(mem[p+7].hh.lh);freenode(p,10);end;
flushnodelist(mem[p].hh.rh);
mem[curlist.tailfield].hh.rh:=mem[p+5].hh.rh;
if curval<256 then eqtb[25332+curval].hh.rh:=-268435455 else begin
findsaelement(4,curval,false);
if curptr<>-268435455 then begin mem[curptr+1].hh.rh:=-268435455;
incr(mem[curptr+1].hh.lh);deletesaref(curptr);end;end;
deleteglueref(mem[p+7].hh.rh);deleteglueref(mem[p+7].hh.lh);
freenode(p,10);end;
30:while mem[curlist.tailfield].hh.rh<>-268435455 do begin p:=curlist.
tailfield;curlist.tailfield:=mem[curlist.tailfield].hh.rh;
if not(curlist.tailfield>=himemmin)then case mem[curlist.tailfield].hh.
b0 of 12:if(mem[curlist.tailfield].hh.b1=16)or(mem[curlist.tailfield].hh
.b1=17)then begin mem[p].hh.rh:=mem[curlist.tailfield].hh.rh;
deleteglueref(mem[curlist.tailfield+1].hh.lh);
freenode(curlist.tailfield,2);curlist.tailfield:=p;end;
14:if mem[curlist.tailfield].hh.b1=1 then begin mem[p].hh.rh:=mem[
curlist.tailfield].hh.rh;freenode(curlist.tailfield,2);
curlist.tailfield:=p;end;5:begin curlist.pdispfield:=disp;
disp:=mem[curlist.tailfield+1].int;curlist.pnodefield:=p;end;end;end;
10:end;{:1128}{1131:}procedure appenditaliccorrection;label 10;
var p:halfword;f:internalfontnumber;d:halfword;
begin if curlist.tailfield<>curlist.headfield then begin if not(curlist.
tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=5)then begin d:=
curlist.tailfield;curlist.tailfield:=curlist.pnodefield;
end else d:=-268435455;
if(curlist.lastjchrfield<>-268435455)and(mem[curlist.lastjchrfield].hh.
rh=curlist.tailfield)and((curlist.tailfield>=himemmin))then p:=curlist.
lastjchrfield else if(curlist.tailfield>=himemmin)then p:=curlist.
tailfield else if mem[curlist.tailfield].hh.b0=8 then p:=curlist.
tailfield+1 else goto 10;f:=mem[p].hh.b0;
begin mem[curlist.tailfield].hh.rh:=newkern(fontinfo[italicbase[f]+(
fontinfo[charbase[f]+effectivechar(true,f,mem[p].hh.b1)].qqqq.b2)div 4].
int);curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=3;
if d<>-268435455 then begin curlist.pnodefield:=curlist.tailfield;
begin mem[curlist.tailfield].hh.rh:=d;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;end;end;10:end;
{:1131}{1135:}procedure appenddiscretionary;var c:integer;
begin begin mem[curlist.tailfield].hh.rh:=newdisc;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
if curchr=1 then begin c:=hyphenchar[eqtb[25588].hh.rh];
if c>=0 then if c<256 then mem[curlist.tailfield+1].hh.lh:=newcharacter(
eqtb[25588].hh.rh,c);end else begin incr(saveptr);
savestack[saveptr-1].int:=0;newsavelevel(10);scanleftbrace;pushnest;
curlist.modefield:=-114;curlist.auxfield.hh.lh:=1000;end;end;
{:1135}{1137:}procedure builddiscretionary;label 30,10;var p,q:halfword;
n:integer;begin unsave;{1139:}q:=curlist.headfield;p:=mem[q].hh.rh;n:=0;
while p<>-268435455 do begin if not(p>=himemmin)then if(mem[p].hh.b0>3)
and(mem[p].hh.b0<>13)and(mem[p].hh.b0<>8)and(mem[p].hh.b0<>5)then if(mem
[p].hh.b0=14)and(mem[p].hh.b1<>0)then begin mem[q].hh.rh:=mem[p].hh.rh;
freenode(p,2);p:=q;end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1225);
end;begin helpptr:=1;helpline[0]:=1226;end;error;begindiagnostic;
printnl(1227);showbox(p);enddiagnostic(true);flushnodelist(p);
mem[q].hh.rh:=-268435455;goto 30;end;q:=p;p:=mem[q].hh.rh;incr(n);end;
30:{:1139};p:=mem[curlist.headfield].hh.rh;popnest;
case savestack[saveptr-1].int of 0:mem[curlist.tailfield+1].hh.lh:=p;
1:mem[curlist.tailfield+1].hh.rh:=p;
2:{1138:}begin if(n>0)and(abs(curlist.modefield)=227)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1219);
end;printesc(358);begin helpptr:=2;helpline[1]:=1220;helpline[0]:=1221;
end;flushnodelist(p);n:=0;error;
end else mem[curlist.tailfield].hh.rh:=p;
if n<=65535 then mem[curlist.tailfield].hh.b1:=n else begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1222);
end;begin helpptr:=2;helpline[1]:=1223;helpline[0]:=1224;end;error;end;
if n>0 then curlist.tailfield:=q;decr(saveptr);
curlist.pnodefield:=curlist.tailfield;
begin mem[curlist.tailfield].hh.rh:=getnode(2);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=5;mem[curlist.tailfield+1].int:=0;
curlist.pdispfield:=0;goto 10;end{:1138};end;
incr(savestack[saveptr-1].int);newsavelevel(10);scanleftbrace;pushnest;
curlist.modefield:=-114;curlist.auxfield.hh.lh:=1000;10:end;
{:1137}{1141:}procedure makeaccent;var s,t:real;disp:scaled;
cx:KANJIcode;p,q,r:halfword;f:internalfontnumber;a,h,x,w,delta:scaled;
i:fourquarters;begin scancharnum;
if not ischarascii(curval)then begin cx:=curval;
if curlist.dirfield=3 then f:=eqtb[26358].hh.rh else f:=eqtb[26357].hh.
rh;p:=newcharacter(f,getjfmpos(cx,f));
if p<>-268435455 then begin mem[p].hh.rh:=getavail;
mem[mem[p].hh.rh].hh.lh:=cx;end;end else begin f:=eqtb[25588].hh.rh;
p:=newcharacter(f,curval);end;
if p<>-268435455 then begin x:=fontinfo[5+parambase[f]].int;
s:=fontinfo[1+parambase[f]].int/65536.0;
a:=fontinfo[widthbase[f]+fontinfo[charbase[f]+effectivechar(true,f,mem[p
].hh.b1)].qqqq.b0].int;doassignments;{1142:}q:=-268435455;
f:=eqtb[25588].hh.rh;cx:=0;
if(curcmd=11)or(curcmd=12)then q:=newcharacter(f,curchr)else if(curcmd=
16)or(curcmd=17)or(curcmd=18)then begin if curlist.dirfield=3 then f:=
eqtb[26358].hh.rh else f:=eqtb[26357].hh.rh;cx:=curchr;
end else if curcmd=71 then if ischarascii(curchr)then q:=newcharacter(f,
curchr)else begin if curlist.dirfield=3 then f:=eqtb[26358].hh.rh else f
:=eqtb[26357].hh.rh;
cx:=curchr end else if curcmd=19 then begin scancharnum;
if ischarascii(curval)then q:=newcharacter(f,curval)else begin if
curlist.dirfield=3 then f:=eqtb[26358].hh.rh else f:=eqtb[26357].hh.rh;
cx:=curval end end else backinput;
if curlist.dirfield=3 then begin if fontdir[f]=3 then disp:=0 else if
fontdir[f]=4 then disp:=eqtb[29535].int-eqtb[29536].int else disp:=eqtb[
29535].int end else begin if fontdir[f]=4 then disp:=0 else if fontdir[f
]=3 then disp:=eqtb[29536].int-eqtb[29535].int else disp:=eqtb[29536].
int end;{1734:}begin if not(curlist.tailfield>=himemmin)and(mem[curlist.
tailfield].hh.b0=5)then begin if curlist.pdispfield=disp then begin
freenode(curlist.tailfield,2);curlist.tailfield:=curlist.pnodefield;
mem[curlist.tailfield].hh.rh:=-268435455;
end else mem[curlist.tailfield+1].int:=disp;
end else if disp<>0 then begin curlist.pnodefield:=curlist.tailfield;
begin mem[curlist.tailfield].hh.rh:=getnode(2);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=5;mem[curlist.tailfield+1].int:=disp;
curlist.pdispfield:=disp;end;end;{:1734};
if cx<>0 then begin q:=newcharacter(f,getjfmpos(cx,f));
mem[q].hh.rh:=getavail;mem[mem[q].hh.rh].hh.lh:=cx;
curlist.lastjchrfield:=q;end;{:1142};
if q<>-268435455 then{1143:}begin t:=fontinfo[1+parambase[f]].int
/65536.0;
i:=fontinfo[charbase[f]+effectivechar(true,f,mem[q].hh.b1)].qqqq;
w:=fontinfo[widthbase[f]+i.b0].int;
h:=fontinfo[heightbase[f]+(i.b1)div 16].int;
if h<>x then begin deleteglueref(curkanjiskip);
deleteglueref(curxkanjiskip);curkanjiskip:=membot;curxkanjiskip:=membot;
incr(mem[curkanjiskip].hh.rh);incr(mem[curxkanjiskip].hh.rh);
p:=hpack(p,0,1);mem[p+4].int:=x-h;end;delta:=round((w-a)/2.0+h*t-x*s);
r:=newkern(delta);mem[r].hh.b1:=2;mem[curlist.tailfield].hh.rh:=r;
mem[r].hh.rh:=p;curlist.tailfield:=newkern(-a-delta);
mem[curlist.tailfield].hh.b1:=2;
if h=x then begin if fontdir[mem[p].hh.b0]<>0 then mem[mem[p].hh.rh].hh.
rh:=curlist.tailfield else mem[p].hh.rh:=curlist.tailfield;
end else mem[p].hh.rh:=curlist.tailfield;p:=q;end{:1143};
mem[curlist.tailfield].hh.rh:=p;
if mem[p].hh.rh<>-268435455 then curlist.tailfield:=mem[p].hh.rh else
curlist.tailfield:=p;
{1735:}if disp<>0 then begin if not(curlist.tailfield>=himemmin)and(mem[
curlist.tailfield].hh.b0=5)then begin mem[curlist.tailfield+1].int:=0;
end else begin curlist.pnodefield:=curlist.tailfield;
begin mem[curlist.tailfield].hh.rh:=getnode(2);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=5;mem[curlist.tailfield+1].int:=0;
curlist.pdispfield:=disp;end;end;{:1735};curlist.auxfield.hh.lh:=1000;
end;end;{:1141}{1145:}procedure alignerror;
begin if abs(alignstate)>2 then{1146:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1232);
end;printcmdchr(curcmd,curchr);
if curtok=1062 then begin begin helpptr:=6;helpline[5]:=1233;
helpline[4]:=1234;helpline[3]:=1235;helpline[2]:=1236;helpline[1]:=1237;
helpline[0]:=1238;end;end else begin begin helpptr:=5;helpline[4]:=1233;
helpline[3]:=1239;helpline[2]:=1236;helpline[1]:=1237;helpline[0]:=1238;
end;end;error;end{:1146}else begin backinput;
if alignstate<0 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(713);
end;incr(alignstate);curtok:=379;
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1228);
end;decr(alignstate);curtok:=637;end;begin helpptr:=3;helpline[2]:=1229;
helpline[1]:=1230;helpline[0]:=1231;end;inserror;end;end;
{:1145}{1147:}procedure noalignerror;begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1232);
end;printesc(570);begin helpptr:=2;helpline[1]:=1240;helpline[0]:=1241;
end;error;end;procedure omiterror;begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1232);
end;printesc(573);begin helpptr:=2;helpline[1]:=1242;helpline[0]:=1241;
end;error;end;{:1147}{1149:}procedure doendv;begin baseptr:=inputptr;
inputstack[baseptr]:=curinput;
while(inputstack[baseptr].indexfield<>2)and(inputstack[baseptr].locfield
=-268435455)and(inputstack[baseptr].statefield=0)do decr(baseptr);
if(inputstack[baseptr].indexfield<>2)or(inputstack[baseptr].locfield<>
-268435455)or(inputstack[baseptr].statefield<>0)then fatalerror(645);
if curgroup=6 then begin endgraf;if fincol then finrow;end else offsave;
end;{:1149}{1153:}procedure cserror;begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(869);
end;printesc(543);begin helpptr:=1;helpline[0]:=1244;end;error;end;
{:1153}{1154:}procedure pushmath(c:groupcode);begin pushnest;
curlist.modefield:=-227;curlist.auxfield.int:=-268435455;
newsavelevel(c);end;
{:1154}{1156:}{1487:}procedure justcopy(p,h,t:halfword);label 40,45;
var r:halfword;words:0..5;begin while p<>-268435455 do begin words:=1;
if(p>=himemmin)then r:=getavail else case mem[p].hh.b0 of 2,0,1:begin r
:=getnode(10);{1676:}mem[r+8].int:=mem[p+8].int;
mem[r+9].int:=mem[p+9].int;{:1676};mem[r+7]:=mem[p+7];
mem[r+6]:=mem[p+6];mem[r+5]:=mem[p+5];incr(mem[mem[r+7].hh.rh].hh.rh);
incr(mem[mem[r+7].hh.lh].hh.rh);words:=5;mem[r+5].hh.rh:=-268435455;end;
3:begin r:=getnode(6);words:=6;end;8:begin r:=getavail;mem[r]:=mem[p+1];
goto 40;end;13,11:begin words:=4;r:=getnode(words);end;
12:begin r:=getnode(4);incr(mem[mem[p+1].hh.lh].hh.rh);
{1678:}mem[r+2].int:=mem[p+2].int;mem[r+3].int:=mem[p+3].int;{:1678};
mem[r+1].hh.lh:=mem[p+1].hh.lh;mem[r+1].hh.rh:=-268435455;end;
10:{1376:}case mem[p].hh.b1 of 0:begin r:=getnode(3);words:=3;end;
1,3:begin r:=getnode(2);incr(mem[mem[p+1].hh.rh].hh.lh);words:=2;end;
2,4:begin r:=getnode(2);words:=2;end;6:r:=getnode(2);
others:confusion(1431)end{:1376};others:goto 45 end;
while words>0 do begin decr(words);mem[r+words]:=mem[p+words];end;
40:mem[h].hh.rh:=r;h:=r;45:p:=mem[p].hh.rh;end;mem[h].hh.rh:=t;end;
{:1487}{1492:}procedure justreverse(p:halfword);label 30;var l:halfword;
t:halfword;q:halfword;m,n:halfword;begin m:=-268435455;n:=-268435455;
if mem[memtop-3].hh.rh=-268435455 then begin justcopy(mem[p].hh.rh,
memtop-3,-268435455);q:=mem[memtop-3].hh.rh;
end else begin q:=mem[p].hh.rh;mem[p].hh.rh:=-268435455;
flushnodelist(mem[memtop-3].hh.rh);end;t:=newedge(curdir,0);l:=t;
curdir:=1-curdir;while q<>-268435455 do if(q>=himemmin)then repeat p:=q;
q:=mem[p].hh.rh;mem[p].hh.rh:=l;l:=p;
until not(q>=himemmin)else begin p:=q;q:=mem[p].hh.rh;
if mem[p].hh.b0=11 then{1493:}if odd(mem[p].hh.b1)then if mem[LRptr].hh.
lh<>(4*(mem[p].hh.b1 div 4)+3)then begin mem[p].hh.b0:=13;
incr(LRproblems);end else begin begin tempptr:=LRptr;
LRptr:=mem[tempptr].hh.rh;begin mem[tempptr].hh.rh:=avail;
avail:=tempptr;ifdef('STAT')decr(dynused);endif('STAT')end;end;
if n>-268435455 then begin decr(n);decr(mem[p].hh.b1);
end else begin if m>-268435455 then decr(m)else begin mem[t+1].int:=mem[
p+1].int;mem[t].hh.rh:=q;freenode(p,4);goto 30;end;mem[p].hh.b0:=13;end;
end else begin begin tempptr:=getavail;
mem[tempptr].hh.lh:=(4*(mem[p].hh.b1 div 4)+3);
mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;end;
if(n>-268435455)or((mem[p].hh.b1 div 8)<>curdir)then begin incr(n);
incr(mem[p].hh.b1);end else begin mem[p].hh.b0:=13;incr(m);end;
end{:1493};mem[p].hh.rh:=l;l:=p;end;goto 30;mem[t+1].int:=mem[p+1].int;
mem[t].hh.rh:=q;freenode(p,2);30:mem[memtop-3].hh.rh:=l;end;
{:1492}procedure initmath;label 21,40,45,30;var w:scaled;j:halfword;
x:integer;l:scaled;s:scaled;p:halfword;q:halfword;f:internalfontnumber;
n:integer;v:scaled;d:scaled;begin gettoken;
if(curcmd=3)and(curlist.modefield>0)then{1163:}begin j:=-268435455;
w:=-1073741823;
if curlist.headfield=curlist.tailfield then{1486:}begin popnest;
{1485:}if curlist.eTeXauxfield=-268435455 then x:=0 else if mem[curlist.
eTeXauxfield].hh.lh>=8 then x:=-1 else x:=1{:1485};
end{:1486}else begin adjusthlist(curlist.headfield,true);
linebreak(true);
{1164:}{1488:}if(eTeXmode=1)then{1494:}begin if eqtb[24536].hh.rh=membot
then j:=newkern(0)else j:=newparamglue(8);
if eqtb[24535].hh.rh=membot then p:=newkern(0)else p:=newparamglue(7);
mem[p].hh.rh:=j;j:=newnullbox;mem[j+1].int:=mem[justbox+1].int;
mem[j+4].int:=mem[justbox+4].int;mem[j+5].hh.rh:=p;
mem[j+5].hh.b1:=mem[justbox+5].hh.b1;
mem[j+5].hh.b0:=mem[justbox+5].hh.b0;mem[j+6].gr:=mem[justbox+6].gr;
end{:1494};v:=mem[justbox+4].int;
{1485:}if curlist.eTeXauxfield=-268435455 then x:=0 else if mem[curlist.
eTeXauxfield].hh.lh>=8 then x:=-1 else x:=1{:1485};
if x>=0 then begin p:=mem[justbox+5].hh.rh;
mem[memtop-3].hh.rh:=-268435455;end else begin v:=-v-mem[justbox+1].int;
p:=newmath(0,6);mem[memtop-3].hh.rh:=p;
justcopy(mem[justbox+5].hh.rh,p,newmath(0,7));curdir:=1;end;
v:=v+2*fontinfo[6+parambase[eqtb[25588].hh.rh]].int;
if(eqtb[29001].int>0)then{1460:}begin tempptr:=getavail;
mem[tempptr].hh.lh:=0;mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;
end{:1460}{:1488};
while p<>-268435455 do begin{1165:}21:if(p>=himemmin)then begin f:=mem[p
].hh.b0;
d:=fontinfo[widthbase[f]+fontinfo[charbase[f]+mem[p].hh.b1].qqqq.b0].int
;if fontdir[f]<>0 then p:=mem[p].hh.rh;goto 40;end;
case mem[p].hh.b0 of 0,1,2,3:begin d:=mem[p+1].int;goto 40;end;
8:{669:}begin mem[memtop-12]:=mem[p+1];
mem[memtop-12].hh.rh:=mem[p].hh.rh;p:=memtop-12;goto 21;end{:669};
13:d:=mem[p+1].int;{1490:}11:begin d:=mem[p+1].int;
if(eqtb[29001].int>0)then{1491:}if odd(mem[p].hh.b1)then begin if mem[
LRptr].hh.lh=(4*(mem[p].hh.b1 div 4)+3)then begin tempptr:=LRptr;
LRptr:=mem[tempptr].hh.rh;begin mem[tempptr].hh.rh:=avail;
avail:=tempptr;ifdef('STAT')decr(dynused);endif('STAT')end;
end else if mem[p].hh.b1>4 then begin w:=1073741823;goto 30;
end end else begin begin tempptr:=getavail;
mem[tempptr].hh.lh:=(4*(mem[p].hh.b1 div 4)+3);
mem[tempptr].hh.rh:=LRptr;LRptr:=tempptr;end;
if(mem[p].hh.b1 div 8)<>curdir then begin justreverse(p);p:=memtop-3;
end;end{:1491}else if mem[p].hh.b1>=4 then begin w:=1073741823;goto 30;
end;end;16:begin d:=mem[p+1].int;curdir:=mem[p].hh.b1;end;
{:1490}12:{1166:}begin q:=mem[p+1].hh.lh;d:=mem[q+1].int;
if mem[justbox+5].hh.b0=1 then begin if(mem[justbox+5].hh.b1=mem[q].hh.
b0)and(mem[q+2].int<>0)then v:=1073741823;
end else if mem[justbox+5].hh.b0=2 then begin if(mem[justbox+5].hh.b1=
mem[q].hh.b1)and(mem[q+3].int<>0)then v:=1073741823;end;
if mem[p].hh.b1>=100 then goto 40;end{:1166};10:{1380:}d:=0{:1380};
others:d:=0 end{:1165};if v<1073741823 then v:=v+d;goto 45;
40:if v<1073741823 then begin v:=v+d;w:=v;end else begin w:=1073741823;
goto 30;end;45:p:=mem[p].hh.rh;end;
30:{1489:}if(eqtb[29001].int>0)then begin while LRptr<>-268435455 do
begin tempptr:=LRptr;LRptr:=mem[tempptr].hh.rh;
begin mem[tempptr].hh.rh:=avail;avail:=tempptr;
ifdef('STAT')decr(dynused);endif('STAT')end;end;
if LRproblems<>0 then begin w:=1073741823;LRproblems:=0;end;end;
curdir:=0;flushnodelist(mem[memtop-3].hh.rh){:1489}{:1164};end;
{1167:}if eqtb[25061].hh.rh=-268435455 then if(eqtb[29531].int<>0)and(((
eqtb[28972].int>=0)and(curlist.pgfield+2>eqtb[28972].int))or(curlist.
pgfield+1<-eqtb[28972].int))then begin l:=eqtb[29517].int-abs(eqtb[29531
].int);if eqtb[29531].int>0 then s:=eqtb[29531].int else s:=0;
end else begin l:=eqtb[29517].int;s:=0;
end else begin n:=mem[eqtb[25061].hh.rh].hh.lh;
if curlist.pgfield+2>=n then p:=eqtb[25061].hh.rh+2*n else p:=eqtb[25061
].hh.rh+2*(curlist.pgfield+2);s:=mem[p-1].int;l:=mem[p].int;end{:1167};
pushmath(15);curlist.modefield:=227;eqworddefine(28975,-1);
eqworddefine(29527,w);curlist.eTeXauxfield:=j;
if(eTeXmode=1)then eqworddefine(28997,x);eqworddefine(29528,l);
eqworddefine(29529,s);
if eqtb[25065].hh.rh<>-268435455 then begintokenlist(eqtb[25065].hh.rh,9
);if nestptr=1 then buildpage;end{:1163}else begin backinput;
{1157:}begin pushmath(15);eqworddefine(28975,-1);
if(insertsrcspecialeverymath)then insertsrcspecial;
if eqtb[25064].hh.rh<>-268435455 then begintokenlist(eqtb[25064].hh.rh,8
);end{:1157};end;curlist.dirfield:=-abs(curlist.dirfield);end;
{:1156}{1160:}procedure starteqno;
begin savestack[saveptr+0].int:=curchr;incr(saveptr);
{1157:}begin pushmath(15);eqworddefine(28975,-1);
if(insertsrcspecialeverymath)then insertsrcspecial;
if eqtb[25064].hh.rh<>-268435455 then begintokenlist(eqtb[25064].hh.rh,8
);end{:1157};end;{:1160}{1169:}procedure scanmath(p,q:halfword);
label 20,21,10;var c:integer;cx:KANJIcode;begin cx:=0;
20:{421:}repeat getxtoken;until(curcmd<>10)and(curcmd<>0){:421};
21:case curcmd of 11,12,71:if(ischarascii(curchr)or(curchr=256))then
begin c:=eqtb[28419+curchr].hh.rh;
if c=524288 then begin{1170:}begin curcs:=curchr+1;
curcmd:=eqtb[curcs].hh.b0;curchr:=eqtb[curcs].hh.rh;xtoken;backinput;
end{:1170};goto 20;end;end else cx:=curchr;16,17,18:cx:=curchr;
19:begin scancharnum;curchr:=curval;curcmd:=71;goto 21;end;
20:begin if curchr=0 then scanfifteenbitint else scanbigfifteenbitint;
c:=curval;end;72:c:=((curchr div 4096)*65536)+(curchr mod 4096);
73:c:=((curchr div 65536)*256)+(curchr mod 256);
15:begin if curchr=0 then scantwentysevenbitint else scanfiftyonebitint;
c:=curval;end;others:{1171:}begin backinput;scanleftbrace;
savestack[saveptr+0].int:=p;incr(saveptr);pushmath(9);goto 10;
end{:1171}end;if cx=0 then begin mem[p].hh.rh:=1;
mem[p].hh.b1:=c mod 256;
if(c>=458752)and(((eqtb[28975].int>=0)and(eqtb[28975].int<256)))then mem
[p].hh.b0:=eqtb[28975].int else mem[p].hh.b0:=(c div 256)mod 256;
if fontdir[eqtb[25589+mem[p].hh.b0+cursize].hh.rh]<>0 then begin begin
if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1247);
end;begin helpptr:=1;helpline[0]:=1248;end;error;
end end else begin if q=-268435455 then begin mem[p].hh.rh:=3;
mem[p].hh.lh:=newnoad;p:=mem[p].hh.lh+1;q:=p+3;end;mem[p].hh.rh:=5;
mem[p].hh.b0:=eqtb[28976].int;mem[p].hh.b1:=0;mem[p+3].hh.lh:=cx;
if fontdir[eqtb[25589+mem[p].hh.b0+cursize].hh.rh]=0 then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1249);
end;begin helpptr:=1;helpline[0]:=1248;end;error;end end;10:end;
{:1169}{1173:}procedure setmathchar(c:integer);var p:halfword;
begin if c>=524288 then{1170:}begin curcs:=curchr+1;
curcmd:=eqtb[curcs].hh.b0;curchr:=eqtb[curcs].hh.rh;xtoken;backinput;
end{:1170}else begin p:=newnoad;mem[p+1].hh.rh:=1;
mem[p+1].hh.b1:=c mod 256;mem[p+1].hh.b0:=(c div 256)mod 256;
if c>=458752 then begin if((eqtb[28975].int>=0)and(eqtb[28975].int<256))
then mem[p+1].hh.b0:=eqtb[28975].int;mem[p].hh.b0:=18;
end else mem[p].hh.b0:=18+(c div 65536);mem[curlist.tailfield].hh.rh:=p;
curlist.tailfield:=p;
if fontdir[eqtb[25589+mem[p+1].hh.b0+cursize].hh.rh]<>0 then begin begin
if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1247);
end;begin helpptr:=1;helpline[0]:=1248;end;error;end;
inhibitglueflag:=false;end;end;{:1173}{1177:}procedure mathlimitswitch;
label 10;
begin if curlist.headfield<>curlist.tailfield then if mem[curlist.
tailfield].hh.b0=19 then begin mem[curlist.tailfield].hh.b1:=curchr;
goto 10;end;begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1251);
end;begin helpptr:=1;helpline[0]:=1252;end;error;10:end;
{:1177}{1178:}procedure scandelimiter(p:halfword;r:boolean);
begin if r=1 then scantwentysevenbitint else if r=2 then
scanfiftyonebitint else begin{421:}repeat getxtoken;
until(curcmd<>10)and(curcmd<>0){:421};
case curcmd of 11,12:begin curval:=eqtb[29258+curchr].int;
curval1:=getintone(eqtb[29258+curchr]);end;
15:if curchr=0 then scantwentysevenbitint else scanfiftyonebitint;
others:begin curval:=-1;curval1:=-1;end;end;end;
if curval<0 then begin{1179:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1253);
end;begin helpptr:=6;helpline[5]:=1254;helpline[4]:=1255;
helpline[3]:=1256;helpline[2]:=1257;helpline[1]:=1258;helpline[0]:=1259;
end;backerror;curval:=0;end{:1179};curval1:=0;end;
mem[p].qqqq.b0:=(curval div 256)mod 256;mem[p].qqqq.b1:=curval mod 256;
mem[p].qqqq.b2:=(curval1 div 256)mod 256;
mem[p].qqqq.b3:=curval1 mod 256;end;{:1178}{1181:}procedure mathradical;
begin begin mem[curlist.tailfield].hh.rh:=getnode(6);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=26;mem[curlist.tailfield].hh.b1:=0;
mem[curlist.tailfield+1].hh:=emptyfield;
mem[curlist.tailfield+3].hh:=emptyfield;
mem[curlist.tailfield+2].hh:=emptyfield;
scandelimiter(curlist.tailfield+5,curchr+1);
scanmath(curlist.tailfield+1,curlist.tailfield+4);end;
{:1181}{1183:}procedure mathac;
begin if curcmd=48 then{1184:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1260);
end;printesc(564);print(1261);begin helpptr:=2;helpline[1]:=1262;
helpline[0]:=1263;end;error;end{:1184};
begin mem[curlist.tailfield].hh.rh:=getnode(6);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=30;mem[curlist.tailfield].hh.b1:=0;
mem[curlist.tailfield+1].hh:=emptyfield;
mem[curlist.tailfield+3].hh:=emptyfield;
mem[curlist.tailfield+2].hh:=emptyfield;
mem[curlist.tailfield+5].hh.rh:=1;
if curchr=0 then scanfifteenbitint else scanbigfifteenbitint;
mem[curlist.tailfield+5].hh.b1:=curval mod 256;
if(curval>=458752)and((eqtb[28975].int>=0)and(eqtb[28975].int<256))then
mem[curlist.tailfield+5].hh.b0:=eqtb[28975].int else mem[curlist.
tailfield+5].hh.b0:=(curval div 256)mod 256;
scanmath(curlist.tailfield+1,curlist.tailfield+4);end;
{:1183}{1190:}procedure appendchoices;
begin begin mem[curlist.tailfield].hh.rh:=newchoice;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;incr(saveptr);
savestack[saveptr-1].int:=0;pushmath(13);scanleftbrace;end;
{:1190}{1192:}{1202:}function finmlist(p:halfword):halfword;
var q:halfword;
begin if curlist.auxfield.int<>-268435455 then{1203:}begin mem[curlist.
auxfield.int+3].hh.rh:=3;
mem[curlist.auxfield.int+3].hh.lh:=mem[curlist.headfield].hh.rh;
if p=-268435455 then q:=curlist.auxfield.int else begin q:=mem[curlist.
auxfield.int+2].hh.lh;
if(mem[q].hh.b0<>32)or(curlist.eTeXauxfield=-268435455)then confusion(
970);mem[curlist.auxfield.int+2].hh.lh:=mem[curlist.eTeXauxfield].hh.rh;
mem[curlist.eTeXauxfield].hh.rh:=curlist.auxfield.int;
mem[curlist.auxfield.int].hh.rh:=p;end;
end{:1203}else begin mem[curlist.tailfield].hh.rh:=p;
q:=mem[curlist.headfield].hh.rh;end;popnest;finmlist:=q;end;
{:1202}procedure buildchoices;label 10;var p:halfword;begin unsave;
p:=finmlist(-268435455);
case savestack[saveptr-1].int of 0:mem[curlist.tailfield+1].hh.lh:=p;
1:mem[curlist.tailfield+1].hh.rh:=p;2:mem[curlist.tailfield+2].hh.lh:=p;
3:begin mem[curlist.tailfield+2].hh.rh:=p;decr(saveptr);goto 10;end;end;
incr(savestack[saveptr-1].int);pushmath(13);scanleftbrace;10:end;
{:1192}{1194:}procedure subsup;var t:smallnumber;p:halfword;begin t:=0;
p:=-268435455;inhibitglueflag:=false;
if curlist.tailfield<>curlist.headfield then if(mem[curlist.tailfield].
hh.b0>=18)and(mem[curlist.tailfield].hh.b0<32)then begin p:=curlist.
tailfield+2+curcmd-7;t:=mem[p].hh.rh;end;
if(p=-268435455)or(t<>0)then{1195:}begin begin mem[curlist.tailfield].hh
.rh:=newnoad;curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
p:=curlist.tailfield+2+curcmd-7;
if t<>0 then begin if curcmd=7 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1264);
end;begin helpptr:=1;helpline[0]:=1265;end;
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1266);
end;begin helpptr:=1;helpline[0]:=1267;end;end;error;end;end{:1195};
scanmath(p,-268435455);end;{:1194}{1199:}procedure mathfraction;
var c:smallnumber;begin c:=curchr;inhibitglueflag:=false;
if curlist.auxfield.int<>-268435455 then{1201:}begin if c>=3 then begin
scandelimiter(memtop-12,false);scandelimiter(memtop-12,false);end;
if c mod 3=0 then scandimen(false,false,false);
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1274);
end;begin helpptr:=3;helpline[2]:=1275;helpline[1]:=1276;
helpline[0]:=1277;end;error;
end{:1201}else begin curlist.auxfield.int:=getnode(6);
mem[curlist.auxfield.int].hh.b0:=27;mem[curlist.auxfield.int].hh.b1:=0;
mem[curlist.auxfield.int+2].hh.rh:=3;
mem[curlist.auxfield.int+2].hh.lh:=mem[curlist.headfield].hh.rh;
mem[curlist.auxfield.int+3].hh:=emptyfield;
mem[curlist.auxfield.int+5].qqqq:=nulldelimiter;
mem[curlist.auxfield.int+4].qqqq:=nulldelimiter;
mem[curlist.headfield].hh.rh:=-268435455;
curlist.tailfield:=curlist.headfield;
{1200:}if c>=3 then begin scandelimiter(curlist.auxfield.int+5,false);
scandelimiter(curlist.auxfield.int+4,false);end;
case c mod 3 of 0:begin scandimen(false,false,false);
mem[curlist.auxfield.int+1].int:=curval;end;
1:mem[curlist.auxfield.int+1].int:=1073741824;
2:mem[curlist.auxfield.int+1].int:=0;end{:1200};end;end;
{:1199}{1209:}procedure mathleftright;var t:smallnumber;p:halfword;
q:halfword;begin t:=curchr;inhibitglueflag:=false;
if(t<>32)and(curgroup<>16)then{1210:}begin if curgroup=15 then begin
scandelimiter(memtop-12,false);begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(869);
end;if t=1 then begin printesc(971);begin helpptr:=1;helpline[0]:=1278;
end;end else begin printesc(970);begin helpptr:=1;helpline[0]:=1279;end;
end;error;end else offsave;end{:1210}else begin p:=newnoad;
mem[p].hh.b0:=t;scandelimiter(p+1,false);
if t=1 then begin mem[p].hh.b0:=33;mem[p].hh.b1:=1;end;
if t=32 then q:=p else begin q:=finmlist(p);unsave;end;
if t<>33 then begin pushmath(16);mem[curlist.headfield].hh.rh:=q;
curlist.tailfield:=p;curlist.eTeXauxfield:=p;
end else begin begin mem[curlist.tailfield].hh.rh:=newnoad;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=25;mem[curlist.tailfield+1].hh.rh:=3;
mem[curlist.tailfield+1].hh.lh:=q;end;end;end;
{:1209}{1212:}{1498:}procedure appdisplay(j,b:halfword;d:scaled);
var z:scaled;s:scaled;e:scaled;x:integer;p,q,r,t,u:halfword;
begin s:=eqtb[29529].int;x:=eqtb[28997].int;
if x=0 then mem[b+4].int:=s+d else begin z:=eqtb[29528].int;p:=b;
{1499:}if x>0 then e:=z-d-mem[p+1].int else begin e:=d;
d:=z-e-mem[p+1].int;end;if j<>-268435455 then begin b:=copynodelist(j);
mem[b+3].int:=mem[p+3].int;mem[b+2].int:=mem[p+2].int;s:=s-mem[b+4].int;
d:=d+s;e:=e+mem[b+1].int-z-s;end;
if((mem[p].hh.b1)div 8)=2 then q:=p else begin r:=mem[p+5].hh.rh;
freenode(p,10);if r=-268435455 then confusion(1516);
if x>0 then begin p:=r;repeat q:=r;r:=mem[r].hh.rh;until r=-268435455;
end else begin p:=-268435455;q:=r;repeat t:=mem[r].hh.rh;
mem[r].hh.rh:=p;p:=r;r:=t;until r=-268435455;end;end{:1499};
{1500:}if j=-268435455 then begin r:=newkern(0);t:=newkern(0);
end else begin r:=mem[b+5].hh.rh;t:=mem[r].hh.rh;end;u:=newmath(0,3);
if mem[t].hh.b0=12 then begin j:=newskipparam(8);mem[q].hh.rh:=j;
mem[j].hh.rh:=u;j:=mem[t+1].hh.lh;mem[tempptr].hh.b0:=mem[j].hh.b0;
mem[tempptr].hh.b1:=mem[j].hh.b1;mem[tempptr+1].int:=e-mem[j+1].int;
mem[tempptr+2].int:=-mem[j+2].int;mem[tempptr+3].int:=-mem[j+3].int;
mem[u].hh.rh:=t;end else begin mem[t+1].int:=e;mem[t].hh.rh:=u;
mem[q].hh.rh:=t;end;u:=newmath(0,2);
if mem[r].hh.b0=12 then begin j:=newskipparam(7);mem[u].hh.rh:=j;
mem[j].hh.rh:=p;j:=mem[r+1].hh.lh;mem[tempptr].hh.b0:=mem[j].hh.b0;
mem[tempptr].hh.b1:=mem[j].hh.b1;mem[tempptr+1].int:=d-mem[j+1].int;
mem[tempptr+2].int:=-mem[j+2].int;mem[tempptr+3].int:=-mem[j+3].int;
mem[r].hh.rh:=u;end else begin mem[r+1].int:=d;mem[r].hh.rh:=p;
mem[u].hh.rh:=r;if j=-268435455 then begin b:=hpack(u,0,1);
mem[b+4].int:=s;end else mem[b+5].hh.rh:=u;end{:1500};end;
appendtovlist(b);end;{:1498}procedure aftermath;var l:boolean;
disp:scaled;danger:boolean;m:integer;p:halfword;a:halfword;
{1216:}b:halfword;w:scaled;z:scaled;e:scaled;q:scaled;d:scaled;s:scaled;
g1,g2:smallnumber;r:halfword;t:halfword;{:1216}{1495:}j:halfword;
{:1495}begin danger:=false;
{1496:}if curlist.modefield=227 then j:=curlist.eTeXauxfield{:1496};
{1213:}if(fontparams[eqtb[25591].hh.rh]<22)or(fontparams[eqtb[25847].hh.
rh]<22)or(fontparams[eqtb[26103].hh.rh]<22)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1280);
end;begin helpptr:=3;helpline[2]:=1281;helpline[1]:=1282;
helpline[0]:=1283;end;error;flushmath;danger:=true;
end else if(fontparams[eqtb[25592].hh.rh]<13)or(fontparams[eqtb[25848].
hh.rh]<13)or(fontparams[eqtb[26104].hh.rh]<13)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1284);
end;begin helpptr:=3;helpline[2]:=1285;helpline[1]:=1286;
helpline[0]:=1287;end;error;flushmath;danger:=true;end{:1213};
deleteglueref(curkanjiskip);deleteglueref(curxkanjiskip);
if eqtb[26359].hh.rh>0 then curkanjiskip:=eqtb[24543].hh.rh else
curkanjiskip:=membot;
if eqtb[26360].hh.rh>0 then curxkanjiskip:=eqtb[24544].hh.rh else
curxkanjiskip:=membot;incr(mem[curkanjiskip].hh.rh);
incr(mem[curxkanjiskip].hh.rh);m:=curlist.modefield;l:=false;
p:=finmlist(-268435455);
if curlist.modefield=-m then begin{1215:}begin getxtoken;
if curcmd<>3 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1288);
end;begin helpptr:=2;helpline[1]:=1289;helpline[0]:=1290;end;backerror;
end;end{:1215};curmlist:=p;curstyle:=2;mlistpenalties:=false;
mlisttohlist;a:=hpack(mem[memtop-3].hh.rh,0,1);
mem[a].hh.b1:=((mem[a].hh.b1)mod 8)+8*(2);unsave;decr(saveptr);
if savestack[saveptr+0].int=1 then l:=true;danger:=false;
{1496:}if curlist.modefield=227 then j:=curlist.eTeXauxfield{:1496};
{1213:}if(fontparams[eqtb[25591].hh.rh]<22)or(fontparams[eqtb[25847].hh.
rh]<22)or(fontparams[eqtb[26103].hh.rh]<22)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1280);
end;begin helpptr:=3;helpline[2]:=1281;helpline[1]:=1282;
helpline[0]:=1283;end;error;flushmath;danger:=true;
end else if(fontparams[eqtb[25592].hh.rh]<13)or(fontparams[eqtb[25848].
hh.rh]<13)or(fontparams[eqtb[26104].hh.rh]<13)then begin begin if
interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1284);
end;begin helpptr:=3;helpline[2]:=1285;helpline[1]:=1286;
helpline[0]:=1287;end;error;flushmath;danger:=true;end{:1213};
m:=curlist.modefield;p:=finmlist(-268435455);end else a:=-268435455;
if m<0 then{1214:}begin if curlist.dirfield=3 then disp:=eqtb[29535].int
else disp:=eqtb[29536].int;
{1734:}begin if not(curlist.tailfield>=himemmin)and(mem[curlist.
tailfield].hh.b0=5)then begin if curlist.pdispfield=disp then begin
freenode(curlist.tailfield,2);curlist.tailfield:=curlist.pnodefield;
mem[curlist.tailfield].hh.rh:=-268435455;
end else mem[curlist.tailfield+1].int:=disp;
end else if disp<>0 then begin curlist.pnodefield:=curlist.tailfield;
begin mem[curlist.tailfield].hh.rh:=getnode(2);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=5;mem[curlist.tailfield+1].int:=disp;
curlist.pdispfield:=disp;end;end;{:1734};
begin mem[curlist.tailfield].hh.rh:=newmath(eqtb[29515].int,0);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;curmlist:=p;
curstyle:=2;mlistpenalties:=(curlist.modefield>0);mlisttohlist;
mem[curlist.tailfield].hh.rh:=mem[memtop-3].hh.rh;
while mem[curlist.tailfield].hh.rh<>-268435455 do curlist.tailfield:=mem
[curlist.tailfield].hh.rh;
begin mem[curlist.tailfield].hh.rh:=newmath(eqtb[29515].int,1);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
{1735:}if disp<>0 then begin if not(curlist.tailfield>=himemmin)and(mem[
curlist.tailfield].hh.b0=5)then begin mem[curlist.tailfield+1].int:=0;
end else begin curlist.pnodefield:=curlist.tailfield;
begin mem[curlist.tailfield].hh.rh:=getnode(2);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=5;mem[curlist.tailfield+1].int:=0;
curlist.pdispfield:=disp;end;end;{:1735};curlist.auxfield.hh.lh:=1000;
unsave;end{:1214}else begin if a=-268435455 then{1215:}begin getxtoken;
if curcmd<>3 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1288);
end;begin helpptr:=2;helpline[1]:=1289;helpline[0]:=1290;end;backerror;
end;end{:1215};{1217:}curmlist:=p;curstyle:=0;mlistpenalties:=false;
mlisttohlist;p:=mem[memtop-3].hh.rh;adjusttail:=memtop-5;
b:=hpack(p,0,1);p:=mem[b+5].hh.rh;t:=adjusttail;adjusttail:=-268435455;
w:=mem[b+1].int;z:=eqtb[29528].int;s:=eqtb[29529].int;
if eqtb[28997].int<0 then s:=-s-z;
if(a=-268435455)or danger then begin e:=0;q:=0;
end else begin e:=mem[a+1].int;
q:=e+fontinfo[6+parambase[eqtb[25591].hh.rh]].int;end;
if w+q>z then{1219:}begin if(e<>0)and((w-totalshrink[0]+q<=z)or(
totalshrink[1]<>0)or(totalshrink[2]<>0)or(totalshrink[3]<>0)or(
totalshrink[4]<>0))then begin deleteglueref(mem[b+7].hh.rh);
deleteglueref(mem[b+7].hh.lh);freenode(b,10);b:=hpack(p,z-q,0);
end else begin e:=0;if w>z then begin deleteglueref(mem[b+7].hh.rh);
deleteglueref(mem[b+7].hh.lh);freenode(b,10);b:=hpack(p,z,0);end;end;
w:=mem[b+1].int;end{:1219};
{1220:}mem[b].hh.b1:=((mem[b].hh.b1)mod 8)+8*(2);d:=half(z-w);
if(e>0)and(d<2*e)then begin d:=half(z-w-e);
if p<>-268435455 then if not(p>=himemmin)then if mem[p].hh.b0=12 then d
:=0;end{:1220};
{1221:}begin mem[curlist.tailfield].hh.rh:=newpenalty(eqtb[28942].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
if(d+s<=eqtb[29527].int)or l then begin g1:=3;g2:=4;
end else begin g1:=5;g2:=6;end;
if l and(e=0)then begin appdisplay(j,a,0);
begin mem[curlist.tailfield].hh.rh:=newpenalty(10000);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
end else begin mem[curlist.tailfield].hh.rh:=newparamglue(g1);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end{:1221};
{1222:}if e<>0 then begin r:=newkern(z-w-e-d);
if l then begin mem[a].hh.rh:=r;mem[r].hh.rh:=b;b:=a;d:=0;
end else begin mem[b].hh.rh:=r;mem[r].hh.rh:=a;end;b:=hpack(b,0,1);end;
appdisplay(j,b,d){:1222};
{1223:}if(a<>-268435455)and(e=0)and not l then begin begin mem[curlist.
tailfield].hh.rh:=newpenalty(10000);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
appdisplay(j,a,z-mem[a+1].int);g2:=0;end;
if t<>memtop-5 then begin mem[curlist.tailfield].hh.rh:=mem[memtop-5].hh
.rh;curlist.tailfield:=t;end;
begin mem[curlist.tailfield].hh.rh:=newpenalty(eqtb[28943].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
if g2>0 then begin mem[curlist.tailfield].hh.rh:=newparamglue(g2);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end{:1223};
{1497:}flushnodelist(j){:1497};resumeafterdisplay{:1217};end;end;
{:1212}{1218:}procedure resumeafterdisplay;
begin if curgroup<>15 then confusion(1291);unsave;
curlist.pgfield:=curlist.pgfield+3;pushnest;
curlist.adjdirfield:=abs(curlist.dirfield);curlist.modefield:=114;
curlist.auxfield.hh.lh:=1000;
if eqtb[28982].int<=0 then curlang:=0 else if eqtb[28982].int>255 then
curlang:=0 else curlang:=eqtb[28982].int;
curlist.auxfield.hh.rh:=curlang;
curlist.pgfield:=(normmin(eqtb[28983].int)*64+normmin(eqtb[28984].int))
*65536+curlang;{460:}begin getxtoken;if curcmd<>10 then backinput;
end{:460};if nestptr=1 then buildpage;end;
{:1218}{1229:}{1233:}procedure getrtoken;label 20;
begin 20:repeat gettoken;until curtok<>2592;
if(curcs=0)or(curcs>eqtbtop)or((curcs>15514)and(curcs<=30050))then begin
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1309);
end;begin helpptr:=5;helpline[4]:=1310;helpline[3]:=1311;
helpline[2]:=1312;helpline[1]:=1313;helpline[0]:=1314;end;
if curcs=0 then backinput;curtok:=81049;inserror;goto 20;end;end;
{:1233}{1247:}procedure trapzeroglue;
begin if(mem[curval+1].int=0)and(mem[curval+2].int=0)and(mem[curval+3].
int=0)then begin incr(mem[membot].hh.rh);deleteglueref(curval);
curval:=membot;end;end;
{:1247}{1255:}procedure doregistercommand(a:smallnumber);label 40,10;
var l,q,r,s:halfword;p:0..3;e:boolean;w:integer;begin q:=curcmd;
e:=false;{1256:}begin if q<>100 then begin getxtoken;
if(curcmd>=79)and(curcmd<=82)then begin l:=curchr;p:=curcmd-79;goto 40;
end;if curcmd<>100 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(746);
end;printcmdchr(curcmd,curchr);print(747);printcmdchr(q,0);
begin helpptr:=1;helpline[0]:=1344;end;error;goto 10;end;end;
if(curchr<membot)or(curchr>membot+23)then begin l:=curchr;
p:=(mem[l].hh.b0 div 16);e:=true;end else begin p:=curchr-membot;
scanregisternum;if curval>255 then begin findsaelement(p,curval,true);
l:=curptr;e:=true;end else case p of 0:l:=curval+29002;
1:l:=curval+29539;2:l:=curval+24549;3:l:=curval+24805;end;end;end;
40:if p<2 then if e then w:=mem[l+2].int else w:=eqtb[l].int else if e
then s:=mem[l+1].hh.rh else s:=eqtb[l].hh.rh{:1256};
if q=100 then scanoptionalequals else if scankeyword(1340)then;
aritherror:=false;
if q<102 then{1257:}if p<2 then begin if p=0 then scanint else scandimen
(false,false,false);if q=101 then curval:=curval+w;
end else begin scanglue(p);if q=101 then{1258:}begin q:=newspec(curval);
r:=s;deleteglueref(curval);mem[q+1].int:=mem[q+1].int+mem[r+1].int;
if mem[q+2].int=0 then mem[q].hh.b0:=0;
if mem[q].hh.b0=mem[r].hh.b0 then mem[q+2].int:=mem[q+2].int+mem[r+2].
int else if(mem[q].hh.b0<mem[r].hh.b0)and(mem[r+2].int<>0)then begin mem
[q+2].int:=mem[r+2].int;mem[q].hh.b0:=mem[r].hh.b0;end;
if mem[q+3].int=0 then mem[q].hh.b1:=0;
if mem[q].hh.b1=mem[r].hh.b1 then mem[q+3].int:=mem[q+3].int+mem[r+3].
int else if(mem[q].hh.b1<mem[r].hh.b1)and(mem[r+3].int<>0)then begin mem
[q+3].int:=mem[r+3].int;mem[q].hh.b1:=mem[r].hh.b1;end;curval:=q;
end{:1258};end{:1257}else{1259:}begin scanint;
if p<2 then if q=102 then if p=0 then curval:=multandadd(w,curval,0,
2147483647)else curval:=multandadd(w,curval,0,1073741823)else curval:=
xovern(w,curval)else begin r:=newspec(s);
if q=102 then begin mem[r+1].int:=multandadd(mem[s+1].int,curval,0,
1073741823);mem[r+2].int:=multandadd(mem[s+2].int,curval,0,1073741823);
mem[r+3].int:=multandadd(mem[s+3].int,curval,0,1073741823);
end else begin mem[r+1].int:=xovern(mem[s+1].int,curval);
mem[r+2].int:=xovern(mem[s+2].int,curval);
mem[r+3].int:=xovern(mem[s+3].int,curval);end;curval:=r;end;end{:1259};
if aritherror then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1341);
end;begin helpptr:=2;helpline[1]:=1342;helpline[0]:=1343;end;
if p>=2 then deleteglueref(curval);error;goto 10;end;
if p<2 then if e then if(a>=4)then gsawdef(l,curval)else sawdef(l,curval
)else if(a>=4)then geqworddefine(l,curval)else eqworddefine(l,curval)
else begin trapzeroglue;
if e then if(a>=4)then gsadef(l,curval)else sadef(l,curval)else if(a>=4)
then geqdefine(l,129,curval)else eqdefine(l,129,curval);end;10:end;
{:1255}{1262:}procedure alteraux;var c:halfword;
begin if curchr<>abs(curlist.modefield)then reportillegalcase else begin
c:=curchr;scanoptionalequals;
if c=1 then begin scandimen(false,false,false);
curlist.auxfield.int:=curval;end else begin scanint;
if(curval<=0)or(curval>32767)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1347);
end;begin helpptr:=1;helpline[0]:=1348;end;interror(curval);
end else curlist.auxfield.hh.lh:=curval;end;end;end;
{:1262}{1263:}procedure alterprevgraf;var p:0..nestsize;
begin nest[nestptr]:=curlist;p:=nestptr;
while abs(nest[p].modefield)<>1 do decr(p);scanoptionalequals;scanint;
if curval<0 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1050);
end;printesc(576);begin helpptr:=1;helpline[0]:=1349;end;
interror(curval);end else begin nest[p].pgfield:=curval;
curlist:=nest[nestptr];end;end;{:1263}{1264:}procedure alterpagesofar;
var c:0..7;begin c:=curchr;scanoptionalequals;
scandimen(false,false,false);pagesofar[c]:=curval;end;
{:1264}{1265:}procedure alterinteger;var c:smallnumber;begin c:=curchr;
scanoptionalequals;scanint;
if c=0 then deadcycles:=curval{1446:}else if c=2 then begin if(curval<0)
or(curval>3)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1501);
end;begin helpptr:=2;helpline[1]:=1502;helpline[0]:=1503;end;
interror(curval);end else begin curchr:=curval;newinteraction;end;
end{:1446}else insertpenalties:=curval;end;
{:1265}{1266:}procedure alterboxdimen;var c:smallnumber;p,q:halfword;
b:halfword;begin c:=curchr;scanregisternum;
if curval<256 then b:=eqtb[25332+curval].hh.rh else begin findsaelement(
4,curval,false);
if curptr=-268435455 then b:=-268435455 else b:=mem[curptr+1].hh.rh;end;
scanoptionalequals;scandimen(false,false,false);
if b<>-268435455 then begin q:=b;p:=mem[q].hh.rh;
while p<>-268435455 do begin if abs(curlist.dirfield)=((mem[p].hh.b1)mod
8)then q:=p;p:=mem[p].hh.rh;end;
if((mem[q].hh.b1)mod 8)<>abs(curlist.dirfield)then begin p:=mem[b].hh.rh
;mem[b].hh.rh:=-268435455;q:=newdirnode(q,abs(curlist.dirfield));
mem[q+5].hh.rh:=-268435455;mem[q].hh.rh:=p;mem[b].hh.rh:=q;end;
mem[q+c].int:=curval;end;end;
{:1266}{1276:}procedure newfont(a:smallnumber);label 50;var u:halfword;
s:scaled;f:internalfontnumber;t:strnumber;oldsetting:0..21;
begin if jobname=0 then openlogfile;getrtoken;u:=curcs;
if u>=514 then t:=hash[u].rh else if u>=257 then if u=513 then t:=1353
else t:=u-257 else begin oldsetting:=selector;selector:=21;print(1353);
print(u-1);selector:=oldsetting;
begin if poolptr+1>poolsize then overflow(258,poolsize-initpoolptr);end;
t:=makestring;end;if(a>=4)then geqdefine(u,96,0)else eqdefine(u,96,0);
scanoptionalequals;scanfilename;{1277:}nameinprogress:=true;
if scankeyword(1354)then{1278:}begin scandimen(false,false,false);
s:=curval;
if(s<=0)or(s>=134217728)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1356);
end;printscaled(s);print(1357);begin helpptr:=2;helpline[1]:=1358;
helpline[0]:=1359;end;error;s:=10*65536;end;
end{:1278}else if scankeyword(1355)then begin scanint;s:=-curval;
if(curval<=0)or(curval>32768)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(601);
end;begin helpptr:=1;helpline[0]:=602;end;interror(curval);s:=-1000;end;
end else s:=-1000;nameinprogress:=false{:1277};
{1279:}for f:=1 to fontptr do if streqstr(fontname[f],curname)and
streqstr(fontarea[f],curarea)then begin if s>0 then begin if s=fontsize[
f]then goto 50;
end else if fontsize[f]=xnoverd(fontdsize[f],-s,1000)then goto 50;
end{:1279};f:=readfontinfo(u,curname,curarea,s);
50:if(a>=4)then geqdefine(u,96,f)else eqdefine(u,96,f);
eqtb[15526+f]:=eqtb[u];hash[15526+f].rh:=t;end;
{:1276}{1284:}procedure newinteraction;begin println;
interaction:=curchr;
if interaction=0 then kpsemaketexdiscarderrors:=1 else
kpsemaketexdiscarderrors:=0;
{76:}if interaction=0 then selector:=16 else selector:=17{:76};
if logopened then selector:=selector+2;end;
{:1284}procedure prefixedcommand;label 30,10;var a:smallnumber;
m:integer;f:internalfontnumber;j:halfword;k:fontindex;p,q:halfword;
n:integer;e:boolean;begin a:=0;
while curcmd=104 do begin if not odd(a div curchr)then a:=a+curchr;
{421:}repeat getxtoken;until(curcmd<>10)and(curcmd<>0){:421};
if curcmd<=76 then{1230:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1301);
end;printcmdchr(curcmd,curchr);printchar(39);begin helpptr:=1;
helpline[0]:=1302;end;if(eTeXmode=1)then helpline[0]:=1303;backerror;
goto 10;end{:1230};
if eqtb[28967].int>2 then if(eTeXmode=1)then showcurcmdchr;end;
{1231:}if a>=8 then begin j:=3585;a:=a-8;end else j:=0;
if(curcmd<>108)and((a mod 4<>0)or(j<>0))then begin begin if interaction=
3 then;if filelineerrorstylep then printfileline else printnl(263);
print(746);end;printesc(1293);print(1304);printesc(1294);
begin helpptr:=1;helpline[0]:=1305;end;
if(eTeXmode=1)then begin helpline[0]:=1306;print(1304);printesc(1307);
end;print(1308);printcmdchr(curcmd,curchr);printchar(39);error;
end{:1231};
{1232:}if eqtb[28974].int<>0 then if eqtb[28974].int<0 then begin if(a>=
4)then a:=a-4;end else begin if not(a>=4)then a:=a+4;end{:1232};
case curcmd of{1235:}96:begin if fontdir[curchr]=4 then if(a>=4)then
geqdefine(26357,132,curchr)else eqdefine(26357,132,curchr)else if
fontdir[curchr]=3 then if(a>=4)then geqdefine(26358,132,curchr)else
eqdefine(26358,132,curchr)else if(a>=4)then geqdefine(25588,132,curchr)
else eqdefine(25588,132,curchr)end;
{:1235}{1236:}108:begin if odd(curchr)and not(a>=4)and(eqtb[28974].int>=
0)then a:=a+4;e:=(curchr>=2);getrtoken;p:=curcs;q:=scantoks(true,e);
if j<>0 then begin q:=getavail;mem[q].hh.lh:=j;
mem[q].hh.rh:=mem[defref].hh.rh;mem[defref].hh.rh:=q;end;
if(a>=4)then geqdefine(p,123+(a mod 4),defref)else eqdefine(p,123+(a mod
4),defref);end;{:1236}{1239:}105:begin n:=curchr;getrtoken;p:=curcs;
if n=0 then begin repeat gettoken;until curcmd<>10;
if curtok=3133 then begin gettoken;if curcmd=10 then gettoken;end;
end else begin gettoken;q:=curtok;gettoken;backinput;curtok:=q;
backinput;end;
if curcmd>=123 then incr(mem[curchr].hh.lh)else if(curcmd=100)or(curcmd=
77)then if(curchr<membot)or(curchr>membot+23)then incr(mem[curchr+1].hh.
lh);
if(a>=4)then geqdefine(p,curcmd,curchr)else eqdefine(p,curcmd,curchr);
end;{:1239}{1242:}106:if curchr=8 then begin scancharnum;
p:=28675+curval;scanoptionalequals;scancharnum;n:=curval;scancharnum;
if(eqtb[28990].int>0)then begin begindiagnostic;printnl(1327);
print(p-28675);print(1328);print(n);printchar(32);print(curval);
enddiagnostic(false);end;n:=n*256+curval;
if(a>=4)then geqdefine(p,132,n)else eqdefine(p,132,n);
if(p-28675)<eqtb[28988].int then if(a>=4)then geqworddefine(28988,p
-28675)else eqworddefine(28988,p-28675);
if(p-28675)>eqtb[28989].int then if(a>=4)then geqworddefine(28989,p
-28675)else eqworddefine(28989,p-28675);end else begin n:=curchr;
getrtoken;p:=curcs;
if(a>=4)then geqdefine(p,0,256)else eqdefine(p,0,256);
scanoptionalequals;case n of 0:begin scancharnum;
if(a>=4)then geqdefine(p,71,curval)else eqdefine(p,71,curval);end;
1:begin scanrealfifteenbitint;
if(a>=4)then geqdefine(p,72,curval)else eqdefine(p,72,curval);end;
2:begin scanomegafifteenbitint;
if(a>=4)then geqdefine(p,73,curval)else eqdefine(p,73,curval);end;
others:begin scanregisternum;if curval>255 then begin j:=n-3;
if j>3 then j:=5;findsaelement(j,curval,true);incr(mem[curptr+1].hh.lh);
if j=5 then j:=77 else j:=100;
if(a>=4)then geqdefine(p,j,curptr)else eqdefine(p,j,curptr);
end else case n of 3:if(a>=4)then geqdefine(p,79,29002+curval)else
eqdefine(p,79,29002+curval);
4:if(a>=4)then geqdefine(p,80,29539+curval)else eqdefine(p,80,29539+
curval);
5:if(a>=4)then geqdefine(p,81,24549+curval)else eqdefine(p,81,24549+
curval);
6:if(a>=4)then geqdefine(p,82,24805+curval)else eqdefine(p,82,24805+
curval);
7:if(a>=4)then geqdefine(p,78,25072+curval)else eqdefine(p,78,25072+
curval);end;end end;end;{:1242}{1243:}107:begin j:=curchr;scanint;
n:=curval;if not scankeyword(935)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1187);
end;begin helpptr:=2;helpline[1]:=1329;helpline[0]:=1330;end;error;end;
getrtoken;p:=curcs;readtoks(n,p,j);
if(a>=4)then geqdefine(p,123,curval)else eqdefine(p,123,curval);end;
{:1243}{1244:}77,78:begin q:=curcs;e:=false;
if curcmd=77 then if curchr=membot then begin scanregisternum;
if curval>255 then begin findsaelement(5,curval,true);curchr:=curptr;
e:=true;end else curchr:=25072+curval;end else e:=true;p:=curchr;
scanoptionalequals;{421:}repeat getxtoken;
until(curcmd<>10)and(curcmd<>0){:421};
if curcmd<>1 then{1245:}if(curcmd=77)or(curcmd=78)then begin if curcmd=
77 then if curchr=membot then begin scanregisternum;
if curval<256 then q:=eqtb[25072+curval].hh.rh else begin findsaelement(
5,curval,false);
if curptr=-268435455 then q:=-268435455 else q:=mem[curptr+1].hh.rh;end;
end else q:=mem[curchr+1].hh.rh else q:=eqtb[curchr].hh.rh;
if q=-268435455 then if e then if(a>=4)then gsadef(p,-268435455)else
sadef(p,-268435455)else if(a>=4)then geqdefine(p,113,-268435455)else
eqdefine(p,113,-268435455)else begin incr(mem[q].hh.lh);
if e then if(a>=4)then gsadef(p,q)else sadef(p,q)else if(a>=4)then
geqdefine(p,123,q)else eqdefine(p,123,q);end;goto 30;end{:1245};
backinput;curcs:=q;q:=scantoks(false,false);
if mem[defref].hh.rh=-268435455 then begin if e then if(a>=4)then gsadef
(p,-268435455)else sadef(p,-268435455)else if(a>=4)then geqdefine(p,113,
-268435455)else eqdefine(p,113,-268435455);
begin mem[defref].hh.rh:=avail;avail:=defref;ifdef('STAT')decr(dynused);
endif('STAT')end;
end else begin if(p=25062)and not e then begin mem[q].hh.rh:=getavail;
q:=mem[q].hh.rh;mem[q].hh.lh:=637;q:=getavail;mem[q].hh.lh:=379;
mem[q].hh.rh:=mem[defref].hh.rh;mem[defref].hh.rh:=q;end;
if e then if(a>=4)then gsadef(p,defref)else sadef(p,defref)else if(a>=4)
then geqdefine(p,123,defref)else eqdefine(p,123,defref);end;end;
{:1244}{1246:}79:begin p:=curchr;scanoptionalequals;scanint;
if p=28975 then begin if fontdir[eqtb[25589+curval].hh.rh]<>0 then if(a
>=4)then geqworddefine(28976,curval)else eqworddefine(28976,curval)else
if(a>=4)then geqworddefine(p,curval)else eqworddefine(p,curval);
end else if(a>=4)then geqworddefine(p,curval)else eqworddefine(p,curval)
;end;80:begin p:=curchr;scanoptionalequals;scandimen(false,false,false);
if(a>=4)then geqworddefine(p,curval)else eqworddefine(p,curval);end;
81,82:begin p:=curchr;n:=curcmd;scanoptionalequals;
if n=82 then scanglue(3)else scanglue(2);trapzeroglue;
if(a>=4)then geqdefine(p,129,curval)else eqdefine(p,129,curval);end;
{:1246}{1250:}94:begin if curchr=(29386)then begin p:=curchr-128;
scancharnum;p:=p+curval;scanoptionalequals;scanint;curval1:=curval;
scanint;
if(curval1>16777215)or(curval>16777215)then begin begin if interaction=3
then;if filelineerrorstylep then printfileline else printnl(263);
print(1333);end;printint(curval1);print(32);printint(curval);
print(1334);begin helpptr:=1;helpline[0]:=1335;end;error;curval1:=0;
curval:=0;end;curval1:=(curval1 div 65536)*256+(curval1 mod 256);
curval:=(curval div 65536)*256+(curval mod 256);
if(a>=4)then delgeqworddefine(p,curval1,curval)else deleqworddefine(p,
curval1,curval);
end else begin{1251:}if curchr=26617 then m:=16 else m:=0{:1251};
{1252:}if curchr=26361 then n:=15 else if curchr=26617 then n:=18 else
if curchr=28419 then n:=32768 else if curchr=(28547)then n:=134217728
else if curchr=28163 then n:=32767 else if curchr=29258 then n:=16777215
else n:=255{:1252};p:=curchr;curval1:=p;scancharnum;
if p=26617 then p:=p+kcatcodekey(curval)else if not ischarascii(curval)
then p:=p+Hi(curval)else p:=p+curval;scanoptionalequals;scanint;
if((curval<m)and(p<29258))or(curval>n)then begin begin if interaction=3
then;if filelineerrorstylep then printfileline else printnl(263);
print(1333);end;printint(curval);if p<29258 then begin print(1336);
printint(m);print(1337);end else print(1338);printint(n);
if m=0 then begin begin helpptr:=1;helpline[0]:=1335;end;error;
end else begin begin helpptr:=1;helpline[0]:=1339;end;error;end;
curval:=m;end;
if p<28419 then if(a>=4)then geqdefine(p,132,curval)else eqdefine(p,132,
curval)else if curval1=28419 then begin if curval=32768 then curval:=
524288 else curval:=((curval div 4096)*65536)+(curval mod 4096);
if(a>=4)then geqdefine(p,132,curval)else eqdefine(p,132,curval);
end else if curval1=28547 then begin curval:=((curval div 65536)*256)+(
curval mod 256);
if(a>=4)then geqdefine(p-128,132,curval)else eqdefine(p-128,132,curval);
end else if curval1=29258 then begin curval1:=curval div 4096;
curval1:=(curval1 div 4096)*65536+curval1 mod 4096;
curval:=curval mod 4096;
if(a>=4)then delgeqworddefine(p,curval1,curval)else deleqworddefine(p,
curval1,curval);
end else if(a>=4)then geqdefine(p,132,curval)else eqdefine(p,132,curval)
;end;end;{:1250}{1253:}95:begin p:=curchr;scanbigfourbitint;p:=p+curval;
scanoptionalequals;scanfontident;
if(a>=4)then geqdefine(p,132,curval)else eqdefine(p,132,curval);end;
{:1253}{1254:}100,101,102,103:doregistercommand(a);
{:1254}{1260:}109:begin scanregisternum;
if(a>=4)then n:=1073807360+curval else n:=1073741824+curval;
scanoptionalequals;
if setboxallowed then scanbox(n)else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(741);
end;printesc(581);begin helpptr:=2;helpline[1]:=1345;helpline[0]:=1346;
end;error;end;end;{:1260}{1261:}88:alteraux;89:alterprevgraf;
90:alterpagesofar;91:alterinteger;92:alterboxdimen;
{:1261}{1267:}93:begin q:=curchr;scanoptionalequals;scanint;n:=curval;
if n<=0 then p:=-268435455 else if q>25061 then begin n:=(curval div 2)
+1;p:=getnode(2*n+1);mem[p].hh.lh:=n;n:=curval;mem[p+1].int:=n;
for j:=p+2 to p+n+1 do begin scanint;mem[j].int:=curval;end;
if not odd(n)then mem[p+n+2].int:=0;end else begin p:=getnode(2*n+1);
mem[p].hh.lh:=n;for j:=1 to n do begin scandimen(false,false,false);
mem[p+2*j-1].int:=curval;scandimen(false,false,false);
mem[p+2*j].int:=curval;end;end;
if(a>=4)then geqdefine(q,130,p)else eqdefine(q,130,p);end;
{:1267}{1271:}110:if curchr=1 then begin ifdef('INITEX')if iniversion
then begin newpatterns;goto 30;end;
endif('INITEX')begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1350);
end;helpptr:=0;error;repeat gettoken;until curcmd=2;goto 10;
end else begin newhyphexceptions;goto 30;end;
{:1271}{1272:}83:begin findfontdimen(true);k:=curval;scanoptionalequals;
scandimen(false,false,false);fontinfo[k].int:=curval;end;
84:begin n:=curchr;scanfontident;f:=curval;scanoptionalequals;scanint;
if n=0 then hyphenchar[f]:=curval else skewchar[f]:=curval;end;
{:1272}{1275:}99,98,97:newfont(a);{:1275}{1283:}111:newinteraction;
{:1283}{1687:}87:begin p:=curchr;scanint;n:=curval;scanoptionalequals;
scanint;
if not ischarkanji(curval)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1560);
end;printhex(curval);printchar(41);begin helpptr:=1;helpline[0]:=1561;
end;error;goto 10;
end else if(n<0)or(n>9)then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1562);
end;printint(n);printchar(41);begin helpptr:=1;helpline[0]:=1561;end;
error;goto 10;
end else if(a>=4)then geqdefine(27641+n,n,toDVI(curval))else eqdefine(
27641+n,n,toDVI(curval));end;
{:1687}{1692:}112:begin if curchr<2 then p:=26359 else begin p:=26360;
curchr:=(curchr mod 2);end;
if(a>=4)then geqdefine(p,132,curchr)else eqdefine(p,132,curchr);end;
{:1692}{1700:}86:begin p:=curchr;scanint;n:=curval;scanoptionalequals;
scanint;if ischarkanji(n)then begin j:=getinhibitpos(n,0);
if j=1000 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1577);
end;begin helpptr:=1;helpline[0]:=1561;end;error;goto 10;end;
if(a>=4)then geqdefine(27129+j,curval,n)else eqdefine(27129+j,curval,n);
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1578);
end;printhex(n);printchar(41);begin helpptr:=1;helpline[0]:=1561;end;
error;goto 10;end;end;{:1700}{1705:}85:begin p:=curchr;scanint;
n:=curval;scanoptionalequals;scanint;
if ischarascii(n)or ischarkanji(n)then begin j:=getkinsokupos(n,0);
if j=1000 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1584);
end;begin helpptr:=1;helpline[0]:=1561;end;error;goto 10;end;
if(p=1)or(p=2)then begin if(a>=4)then geqdefine(27385+j,p,n)else
eqdefine(27385+j,p,n);
if(a>=4)then geqworddefine(29795+j,curval)else eqworddefine(29795+j,
curval);end else confusion(536);
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1585);
end;
if p=1 then print(1586)else if p=2 then print(1587)else printchar(63);
print(1588);printhex(n);printchar(41);begin helpptr:=1;
helpline[0]:=1561;end;error;goto 10;end;end;
{:1705}others:confusion(1300)end;
30:{1288:}if aftertoken<>0 then begin curtok:=aftertoken;backinput;
aftertoken:=0;end{:1288};10:end;{:1229}{1289:}procedure doassignments;
label 10;begin while true do begin{421:}repeat getxtoken;
until(curcmd<>10)and(curcmd<>0){:421};if curcmd<=76 then goto 10;
setboxallowed:=false;prefixedcommand;setboxallowed:=true;end;10:end;
{:1289}{1294:}procedure openorclosein;var c:0..1;n:0..15;
begin c:=curchr;scanfourbitint;n:=curval;
if readopen[n]<>2 then begin aclose(readfile[n]);readopen[n]:=2;end;
if c<>0 then begin scanoptionalequals;scanfilename;
packfilename(curname,curarea,curext);texinputtype:=0;
if kpseinnameok(stringcast(nameoffile+1))and aopenin(readfile[n],
kpsetexformat)then readopen[n]:=1;end;end;
{:1294}{1298:}procedure issuemessage;var oldsetting:0..21;c:0..1;
s:strnumber;begin c:=curchr;mem[memtop-12].hh.rh:=scantoks(false,true);
oldsetting:=selector;selector:=21;tokenshow(defref);
selector:=oldsetting;flushlist(defref);
begin if poolptr+1>poolsize then overflow(258,poolsize-initpoolptr);end;
s:=makestring;
if c=0 then{1299:}begin if termoffset+(strstart[s+1]-strstart[s])>
maxprintline-2 then println else if(termoffset>0)or(fileoffset>0)then
printchar(32);slowprint(s);fflush(stdout);
end{:1299}else{1302:}begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(343);
end;slowprint(s);
if eqtb[25070].hh.rh<>-268435455 then useerrhelp:=true else if
longhelpseen then begin helpptr:=1;helpline[0]:=1366;
end else begin if interaction<3 then longhelpseen:=true;
begin helpptr:=4;helpline[3]:=1367;helpline[2]:=1368;helpline[1]:=1369;
helpline[0]:=1370;end;end;error;useerrhelp:=false;end{:1302};
begin decr(strptr);poolptr:=strstart[strptr];end;end;
{:1298}{1307:}procedure shiftcase;var b:halfword;p:halfword;t:halfword;
c:eightbits;begin b:=curchr;p:=scantoks(false,false);
p:=mem[defref].hh.rh;while p<>-268435455 do begin{1308:}t:=mem[p].hh.lh;
if(t<65792)and(not checkkanji(t))then begin c:=t mod 256;
if eqtb[b+c].hh.rh<>0 then mem[p].hh.lh:=t-c+eqtb[b+c].hh.rh;end{:1308};
p:=mem[p].hh.rh;end;begintokenlist(mem[defref].hh.rh,3);
begin mem[defref].hh.rh:=avail;avail:=defref;ifdef('STAT')decr(dynused);
endif('STAT')end;end;{:1307}{1312:}procedure showwhatever;label 50;
var p:halfword;t:smallnumber;m:0..4;l:integer;n:integer;
begin case curchr of 3:begin begindiagnostic;showactivities;end;
1:{1315:}begin scanregisternum;
if curval<256 then p:=eqtb[25332+curval].hh.rh else begin findsaelement(
4,curval,false);
if curptr=-268435455 then p:=-268435455 else p:=mem[curptr+1].hh.rh;end;
begindiagnostic;printnl(1387);printint(curval);printchar(61);
if p=-268435455 then print(431)else showbox(p);end{:1315};
0:{1313:}begin gettoken;if interaction=3 then;printnl(1383);
if curcs<>0 then begin sprintcs(curcs);printchar(61);end;printmeaning;
goto 50;end{:1313};7:{1693:}begin printnl(1383);
if eqtb[26359].hh.rh>0 then print(1571)else print(1572);printnl(1383);
if eqtb[26360].hh.rh>0 then print(1573)else print(1574);goto 50;
end{:1693};{1427:}4:begin begindiagnostic;showsavegroups;end;
{:1427}{1441:}6:begin begindiagnostic;printnl(343);println;
if condptr=-268435455 then begin printnl(379);print(1498);
end else begin p:=condptr;n:=0;repeat incr(n);p:=mem[p].hh.rh;
until p=-268435455;p:=condptr;t:=curif;l:=ifline;m:=iflimit;
repeat printnl(1499);printint(n);print(617);printcmdchr(117,t);
if m=2 then printesc(868);if l<>0 then begin print(1497);printint(l);
end;decr(n);t:=mem[p].hh.b1;l:=mem[p+1].int;m:=mem[p].hh.b0;
p:=mem[p].hh.rh;until p=-268435455;end;end;
{:1441}others:{1316:}begin p:=thetoks;if interaction=3 then;
printnl(1383);tokenshow(memtop-3);flushlist(mem[memtop-3].hh.rh);
goto 50;end{:1316}end;{1317:}enddiagnostic(true);
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1388);
end;if selector=19 then if eqtb[28960].int<=0 then begin selector:=17;
print(1389);selector:=19;end{:1317};
50:if interaction<3 then begin helpptr:=0;decr(errorcount);
end else if eqtb[28960].int>0 then begin begin helpptr:=3;
helpline[2]:=1378;helpline[1]:=1379;helpline[0]:=1380;end;
end else begin begin helpptr:=5;helpline[4]:=1378;helpline[3]:=1379;
helpline[2]:=1380;helpline[1]:=1381;helpline[0]:=1382;end;end;error;end;
{:1312}{1321:}ifdef('INITEX')procedure storefmtfile;label 41,42,31,32;
var j,k,l:integer;p,q:halfword;x:integer;formatengine:^ASCIIcode;
begin{1323:}if saveptr<>0 then begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1391);
end;begin helpptr:=1;helpline[0]:=1392;end;
begin if interaction=3 then interaction:=2;if logopened then error;
ifdef('TEXMF_DEBUG')if interaction>0 then debughelp;
endif('TEXMF_DEBUG')history:=3;jumpout;end;end{:1323};
{1347:}selector:=21;print(1408);print(jobname);printchar(32);
printint(eqtb[28954].int);printchar(46);printint(eqtb[28953].int);
printchar(46);printint(eqtb[28952].int);printchar(41);
if interaction=0 then selector:=18 else selector:=19;
begin if poolptr+1>poolsize then overflow(258,poolsize-initpoolptr);end;
formatident:=makestring;packjobname(876);
while not wopenout(fmtfile)do promptfilename(1409,876);printnl(1410);
slowprint(wmakenamestring(fmtfile));begin decr(strptr);
poolptr:=strstart[strptr];end;printnl(343);
slowprint(formatident){:1347};{1326:}dumpint(1462916184);
x:=strlen(enginename);formatengine:=xmallocarray(ASCIIcode,x+4);
strcpy(stringcast(formatengine),enginename);
for k:=x to x+3 do formatengine[k]:=0;x:=x+4-(x mod 4);dumpint(x);
dumpthings(formatengine[0],x);libcfree(formatengine);dumpint(173755214);
{1629:}dumpthings(xord[0],256);dumpthings(xchr[0],256);
dumpthings(xprn[0],256);{:1629};dumpint(268435455);dumpint(hashhigh);
{1404:}dumpint(eTeXmode);for j:=0 to-0 do eqtb[29001+j].int:=0;
{:1404}{1512:}while pseudofiles<>-268435455 do pseudoclose;
{:1512}dumpint(membot);dumpint(memtop);dumpint(30050);dumpint(8501);
dumpint(607){:1326};{1643:}dumpint(1296847960);
if mltexp then dumpint(1)else dumpint(0);{:1643};
{1328:}dumpint(poolptr);dumpint(strptr);
dumpthings(strstart[0],strptr+1);dumpthings(strpool[0],poolptr);println;
printint(strptr);print(1393);printint(poolptr){:1328};{1330:}sortavail;
varused:=0;dumpint(lomemmax);dumpint(rover);
if(eTeXmode=1)then for k:=0 to 5 do dumpint(saroot[k]);p:=membot;
q:=rover;x:=0;repeat dumpthings(mem[p],q+2-p);x:=x+q+2-p;
varused:=varused+q-p;p:=q+mem[q].hh.lh;q:=mem[q+1].hh.rh;until q=rover;
varused:=varused+lomemmax-p;dynused:=memend+1-himemmin;
dumpthings(mem[p],lomemmax+1-p);x:=x+lomemmax+1-p;dumpint(himemmin);
dumpint(avail);dumpthings(mem[himemmin],memend+1-himemmin);
x:=x+memend+1-himemmin;p:=avail;
while p<>-268435455 do begin decr(dynused);p:=mem[p].hh.rh;end;
dumpint(varused);dumpint(dynused);println;printint(x);print(1394);
printint(varused);printchar(38);printint(dynused){:1330};
{1332:}{1334:}k:=1;repeat j:=k;
while j<28930 do begin if(eqtb[j].hh.rh=eqtb[j+1].hh.rh)and(eqtb[j].hh.
b0=eqtb[j+1].hh.b0)and(eqtb[j].hh.b1=eqtb[j+1].hh.b1)then goto 41;
incr(j);end;l:=28931;goto 31;41:incr(j);l:=j;
while j<28930 do begin if(eqtb[j].hh.rh<>eqtb[j+1].hh.rh)or(eqtb[j].hh.
b0<>eqtb[j+1].hh.b0)or(eqtb[j].hh.b1<>eqtb[j+1].hh.b1)then goto 31;
incr(j);end;31:dumpint(l-k);dumpthings(eqtb[k],l-k);k:=j+1;dumpint(k-l);
until k=28931{:1334};{1335:}repeat j:=k;
while j<30050 do begin if(eqtb[j].int=eqtb[j+1].int)and(getintone(eqtb[j
])=getintone(eqtb[j+1]))then goto 42;incr(j);end;l:=30051;goto 32;
42:incr(j);l:=j;
while j<30050 do begin if(eqtb[j].int<>eqtb[j+1].int)or(getintone(eqtb[j
])<>getintone(eqtb[j+1]))then goto 32;incr(j);end;32:dumpint(l-k);
dumpthings(eqtb[k],l-k);k:=j+1;dumpint(k-l);until k>30050;
if hashhigh>0 then dumpthings(eqtb[30051],hashhigh);{:1335};
dumpint(parloc);dumpint(writeloc);
{1337:}for p:=0 to 2100 do dumphh(prim[p]);
for p:=0 to 2100 do dumpwd(primeqtb[p]);dumpint(hashused);
cscount:=15513-hashused+hashhigh;
for p:=514 to hashused do if hash[p].rh<>0 then begin dumpint(p);
dumphh(hash[p]);incr(cscount);end;
dumpthings(hash[hashused+1],24526-hashused);
if hashhigh>0 then dumpthings(hash[30051],hashhigh);dumpint(cscount);
println;printint(cscount);print(1395){:1337}{:1332};
{1339:}dumpint(fmemptr);dumpthings(fontinfo[0],fmemptr);
dumpint(fontptr);{1341:}begin dumpthings(fontdir[0],fontptr+1);
dumpthings(fontnumext[0],fontptr+1);dumpthings(fontcheck[0],fontptr+1);
dumpthings(fontsize[0],fontptr+1);dumpthings(fontdsize[0],fontptr+1);
dumpthings(fontparams[0],fontptr+1);dumpthings(hyphenchar[0],fontptr+1);
dumpthings(skewchar[0],fontptr+1);dumpthings(fontname[0],fontptr+1);
dumpthings(fontarea[0],fontptr+1);dumpthings(fontbc[0],fontptr+1);
dumpthings(fontec[0],fontptr+1);dumpthings(ctypebase[0],fontptr+1);
dumpthings(charbase[0],fontptr+1);dumpthings(widthbase[0],fontptr+1);
dumpthings(heightbase[0],fontptr+1);dumpthings(depthbase[0],fontptr+1);
dumpthings(italicbase[0],fontptr+1);
dumpthings(ligkernbase[0],fontptr+1);dumpthings(kernbase[0],fontptr+1);
dumpthings(extenbase[0],fontptr+1);dumpthings(parambase[0],fontptr+1);
dumpthings(fontglue[0],fontptr+1);dumpthings(bcharlabel[0],fontptr+1);
dumpthings(fontbchar[0],fontptr+1);
dumpthings(fontfalsebchar[0],fontptr+1);
for k:=0 to fontptr do begin printnl(1399);printesc(hash[15526+k].rh);
printchar(61);printfilename(fontname[k],fontarea[k],343);
if fontsize[k]<>fontdsize[k]then begin print(826);
printscaled(fontsize[k]);print(418);end;end;end{:1341};println;
printint(fmemptr-7);print(1396);printint(fontptr-0);
if fontptr<>1 then print(1397)else print(1398){:1339};
{1343:}dumpint(hyphcount);if hyphnext<=607 then hyphnext:=hyphsize;
dumpint(hyphnext);
for k:=0 to hyphsize do if hyphword[k]<>0 then begin dumpint(k+65536*
hyphlink[k]);dumpint(hyphword[k]);dumpint(hyphlist[k]);end;println;
printint(hyphcount);if hyphcount<>1 then print(1400)else print(1401);
if trienotready then inittrie;dumpint(triemax);dumpint(hyphstart);
dumpthings(trietrl[0],triemax+1);dumpthings(trietro[0],triemax+1);
dumpthings(trietrc[0],triemax+1);dumpint(trieopptr);
dumpthings(hyfdistance[1],trieopptr);dumpthings(hyfnum[1],trieopptr);
dumpthings(hyfnext[1],trieopptr);printnl(1402);printint(triemax);
print(1403);printint(trieopptr);
if trieopptr<>1 then print(1404)else print(1405);print(1406);
printint(trieopsize);
for k:=255 downto 0 do if trieused[k]>0 then begin printnl(892);
printint(trieused[k]);print(1407);printint(k);dumpint(k);
dumpint(trieused[k]);end{:1343};{1345:}dumpint(interaction);
dumpint(formatident);dumpint(69069);eqtb[28962].int:=0{:1345};
{1348:}wclose(fmtfile){:1348};end;
endif('INITEX'){:1321}{1367:}{1368:}procedure newwhatsit(s:smallnumber;
w:smallnumber);var p:halfword;begin p:=getnode(w);mem[p].hh.b0:=10;
mem[p].hh.b1:=s;mem[curlist.tailfield].hh.rh:=p;curlist.tailfield:=p;
end;{:1368}{1369:}procedure newwritewhatsit(w:smallnumber);
begin newwhatsit(curchr,w);
if w<>2 then scanfourbitint else begin scanint;
if curval<0 then curval:=17 else if(curval>15)and(curval<>18)then curval
:=16;end;mem[curlist.tailfield+1].hh.lh:=curval;end;
{:1369}{1740:}procedure comparestrings;label 30;var s1,s2:strnumber;
i1,i2,j1,j2:poolpointer;begin begin if scantoks(false,true)<>0 then end;
isprintutf8:=true;s1:=tokenstostring(defref);isprintutf8:=false;
deletetokenref(defref);begin if scantoks(false,true)<>0 then end;
isprintutf8:=true;s2:=tokenstostring(defref);isprintutf8:=false;
deletetokenref(defref);i1:=strstart[s1];j1:=strstart[s1+1];
i2:=strstart[s2];j2:=strstart[s2+1];
while(i1<j1)and(i2<j2)do begin if strpool[i1]<strpool[i2]then begin
curval:=-1;goto 30;end;if strpool[i1]>strpool[i2]then begin curval:=1;
goto 30;end;incr(i1);incr(i2);end;
if(i1=j1)and(i2=j2)then curval:=0 else if i1<j1 then curval:=1 else
curval:=-1;30:flushstr(s2);flushstr(s1);curvallevel:=0;end;
{:1740}{1748:}procedure scanpdfexttoks;
begin begin if scantoks(false,true)<>0 then end;end;
{:1748}procedure doextension;var k:integer;p:halfword;
begin case curchr of 0:{1370:}begin newwritewhatsit(3);
scanoptionalequals;scanfilename;mem[curlist.tailfield+1].hh.rh:=curname;
mem[curlist.tailfield+2].hh.lh:=curarea;
mem[curlist.tailfield+2].hh.rh:=curext;end{:1370};
1:{1371:}begin k:=curcs;newwritewhatsit(2);curcs:=k;
p:=scantoks(false,false);mem[curlist.tailfield+1].hh.rh:=defref;
end{:1371};2:{1372:}begin newwritewhatsit(2);
mem[curlist.tailfield+1].hh.rh:=-268435455;end{:1372};
3:{1373:}begin newwhatsit(3,2);
mem[curlist.tailfield+1].hh.lh:=-268435455;p:=scantoks(false,true);
mem[curlist.tailfield+1].hh.rh:=defref;end{:1373};
4:{1394:}begin getxtoken;
if(curcmd=62)and(curchr<=2)then begin p:=curlist.tailfield;doextension;
outwhat(curlist.tailfield);flushnodelist(curlist.tailfield);
curlist.tailfield:=p;mem[p].hh.rh:=-268435455;end else backinput;
end{:1394};
5:{1396:}if abs(curlist.modefield)<>114 then reportillegalcase else
begin newwhatsit(4,2);scanint;
if curval<=0 then curlist.auxfield.hh.rh:=0 else if curval>255 then
curlist.auxfield.hh.rh:=0 else curlist.auxfield.hh.rh:=curval;
mem[curlist.tailfield+1].hh.rh:=curlist.auxfield.hh.rh;
mem[curlist.tailfield+1].hh.b0:=normmin(eqtb[28983].int);
mem[curlist.tailfield+1].hh.b1:=normmin(eqtb[28984].int);end{:1396};
6:{1742:}begin newwhatsit(6,2);end{:1742};others:confusion(1428)end;end;
{:1367}{1395:}procedure fixlanguage;var l:ASCIIcode;
begin if eqtb[28982].int<=0 then l:=0 else if eqtb[28982].int>255 then l
:=0 else l:=eqtb[28982].int;
if l<>curlist.auxfield.hh.rh then begin newwhatsit(4,2);
mem[curlist.tailfield+1].hh.rh:=l;curlist.auxfield.hh.rh:=l;
mem[curlist.tailfield+1].hh.b0:=normmin(eqtb[28983].int);
mem[curlist.tailfield+1].hh.b1:=normmin(eqtb[28984].int);end;end;
{:1395}{1732:}procedure setmathkchar(c:integer);var p:halfword;
begin p:=newnoad;mem[p+1].hh.rh:=5;inhibitglueflag:=false;
mem[p+1].hh.b1:=0;mem[p+4].hh.lh:=c;mem[p+1].hh.b0:=eqtb[28976].int;
if fontdir[eqtb[25589+mem[p+1].hh.b0+cursize].hh.rh]=0 then begin begin
if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1249);
end;begin helpptr:=1;helpline[0]:=1248;end;error;end;mem[p].hh.b0:=18;
mem[curlist.tailfield].hh.rh:=p;curlist.tailfield:=p;end;
{:1732}{1751:}procedure insertsrcspecial;var toklist,p,q:halfword;
begin if(sourcefilenamestack[inopen]>0 and isnewsource(
sourcefilenamestack[inopen],line))then begin toklist:=getavail;
p:=toklist;mem[p].hh.lh:=81059;mem[p].hh.rh:=getavail;p:=mem[p].hh.rh;
mem[p].hh.lh:=379;
q:=strtoks(makesrcspecial(sourcefilenamestack[inopen],line));
mem[p].hh.rh:=mem[memtop-3].hh.rh;p:=q;mem[p].hh.rh:=getavail;
p:=mem[p].hh.rh;mem[p].hh.lh:=637;begintokenlist(toklist,4);
remembersourceinfo(sourcefilenamestack[inopen],line);end;end;
procedure appendsrcspecial;var q:halfword;
begin if(sourcefilenamestack[inopen]>0 and isnewsource(
sourcefilenamestack[inopen],line))then begin newwhatsit(3,2);
mem[curlist.tailfield+1].hh.lh:=0;defref:=getavail;
mem[defref].hh.lh:=-268435455;
q:=strtoks(makesrcspecial(sourcefilenamestack[inopen],line));
mem[defref].hh.rh:=mem[memtop-3].hh.rh;
mem[curlist.tailfield+1].hh.rh:=defref;
remembersourceinfo(sourcefilenamestack[inopen],line);end;end;
{:1751}{1086:}procedure handlerightbrace;var p,q:halfword;r:halfword;
d:scaled;f:integer;begin case curgroup of 1:unsave;
0:begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1143);
end;begin helpptr:=2;helpline[1]:=1144;helpline[0]:=1145;end;error;end;
14,15,16:extrarightbrace;
{1103:}2:begin adjusthlist(curlist.headfield,false);package(0);end;
3:begin adjusthlist(curlist.headfield,false);adjusttail:=memtop-5;
package(0);end;4:begin endgraf;package(0);end;5:begin endgraf;
package(4);end;{:1103}{1118:}11:begin endgraf;q:=eqtb[24538].hh.rh;
incr(mem[q].hh.rh);d:=eqtb[29520].int;f:=eqtb[28973].int;unsave;
decr(saveptr);p:=vpackage(mem[curlist.headfield].hh.rh,0,1,1073741823);
mem[p].hh.b1:=((mem[p].hh.b1)div 8)*8+abs(curlist.dirfield);popnest;
if savestack[saveptr+0].int<255 then begin r:=getnode(6);
mem[r].hh.b0:=4;mem[r].hh.b1:=savestack[saveptr+0].int;
mem[r+3].int:=mem[p+3].int+mem[p+2].int;mem[r+4].hh.lh:=mem[p+5].hh.rh;
mem[r+4].hh.rh:=q;mem[r+2].int:=d;mem[r+1].int:=f;
mem[r+5].hh.b1:=((mem[p].hh.b1)mod 8);
if not(curlist.tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=5)
then begin mem[curlist.pnodefield].hh.rh:=r;
mem[mem[curlist.pnodefield].hh.rh].hh.rh:=curlist.tailfield;
curlist.pnodefield:=mem[curlist.pnodefield].hh.rh;
end else begin mem[curlist.tailfield].hh.rh:=r;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
end else begin if((mem[p].hh.b1)mod 8)<>curlist.adjdirfield then begin
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1201);
end;begin helpptr:=1;helpline[0]:=1202;end;error;
flushnodelist(mem[p+5].hh.rh);end else begin r:=getnode(2);
mem[r].hh.b0:=7;mem[r+1].int:=mem[p+5].hh.rh;deleteglueref(q);
if not(curlist.tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=5)
then begin mem[curlist.pnodefield].hh.rh:=r;
mem[mem[curlist.pnodefield].hh.rh].hh.rh:=curlist.tailfield;
curlist.pnodefield:=mem[curlist.pnodefield].hh.rh;
end else begin mem[curlist.tailfield].hh.rh:=r;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;end;end;
deleteglueref(mem[p+7].hh.rh);deleteglueref(mem[p+7].hh.lh);
freenode(p,10);if nestptr=0 then buildpage;end;
8:{1043:}begin if(curinput.locfield<>-268435455)or((curinput.indexfield
<>6)and(curinput.indexfield<>3))then{1044:}begin begin if interaction=3
then;if filelineerrorstylep then printfileline else printnl(263);
print(1109);end;begin helpptr:=2;helpline[1]:=1110;helpline[0]:=1111;
end;error;repeat gettoken;until curinput.locfield=-268435455;end{:1044};
endtokenlist;endgraf;unsave;outputactive:=false;insertpenalties:=0;
{1045:}if eqtb[25587].hh.rh<>-268435455 then begin begin if interaction=
3 then;if filelineerrorstylep then printfileline else printnl(263);
print(1112);end;printesc(430);printint(255);begin helpptr:=3;
helpline[2]:=1113;helpline[1]:=1114;helpline[0]:=1115;end;boxerror(255);
end{:1045};
if curlist.tailfield<>curlist.headfield then begin mem[pagetail].hh.rh:=
mem[curlist.headfield].hh.rh;pagetail:=curlist.tailfield;end;
if mem[memtop-2].hh.rh<>-268435455 then begin if mem[memtop-1].hh.rh=
-268435455 then nest[0].tailfield:=pagetail;
mem[pagetail].hh.rh:=mem[memtop-1].hh.rh;
mem[memtop-1].hh.rh:=mem[memtop-2].hh.rh;
mem[memtop-2].hh.rh:=-268435455;pagetail:=memtop-2;end;
flushnodelist(discptr[2]);discptr[2]:=-268435455;popnest;buildpage;
end{:1043};{:1118}{1136:}10:builddiscretionary;
{:1136}{1150:}6:begin backinput;curtok:=81050;
begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(681);
end;printesc(994);print(682);begin helpptr:=1;helpline[0]:=1243;end;
inserror;end;{:1150}{1151:}7:begin endgraf;unsave;alignpeek;end;
{:1151}{1186:}12:begin endgraf;unsave;saveptr:=saveptr-2;
p:=vpackage(mem[curlist.headfield].hh.rh,savestack[saveptr+1].int,
savestack[saveptr+0].int,1073741823);
mem[p].hh.b1:=((mem[p].hh.b1)div 8)*8+abs(curlist.dirfield);popnest;
if((mem[p].hh.b1)mod 8)<>abs(curlist.dirfield)then p:=newdirnode(p,abs(
curlist.dirfield));begin mem[curlist.tailfield].hh.rh:=newnoad;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=31;mem[curlist.tailfield+1].hh.rh:=2;
mem[curlist.tailfield+1].hh.lh:=p;end;{:1186}{1191:}13:buildchoices;
{:1191}{1204:}9:begin unsave;decr(saveptr);
mem[savestack[saveptr+0].int].hh.rh:=3;p:=finmlist(-268435455);
mem[savestack[saveptr+0].int].hh.lh:=p;
if p<>-268435455 then if mem[p].hh.rh=-268435455 then if mem[p].hh.b0=18
then begin if mem[p+3].hh.rh=0 then if((mem[p+2].hh.rh=0)and(mem[p+4].hh
.lh=-268435455))then begin mem[savestack[saveptr+0].int].hh:=mem[p+1].hh
;freenode(p,5);end;
end else if mem[p].hh.b0=30 then if savestack[saveptr+0].int=curlist.
tailfield+1 then if mem[curlist.tailfield].hh.b0=18 then{1205:}begin q:=
curlist.headfield;
while mem[q].hh.rh<>curlist.tailfield do q:=mem[q].hh.rh;
mem[q].hh.rh:=p;freenode(curlist.tailfield,5);curlist.tailfield:=p;
end{:1205};end;{:1204}others:confusion(1146)end;end;
{:1086}procedure maincontrol;
label 60,21,70,80,130,131,133,141,150,90,91,92,95,100,101,110,111,112,
120,10;var t:integer;cx:KANJIcode;kp:halfword;gp,gq:halfword;
disp:scaled;inskp:boolean;
begin if eqtb[25068].hh.rh<>-268435455 then begintokenlist(eqtb[25068].
hh.rh,12);60:getxtoken;
21:{1048:}if interrupt<>0 then if OKtointerrupt then begin backinput;
begin if interrupt<>0 then pauseforinstructions;end;goto 60;end;
ifdef('TEXMF_DEBUG')if panicking then checkmem(false);
endif('TEXMF_DEBUG')if eqtb[28967].int>0 then showcurcmdchr{:1048};
inskp:=false;case abs(curlist.modefield)+curcmd of 125,126:goto 70;
130,131,132:goto 130;
185:if ischarascii(curchr)then goto 70 else goto 130;
133:begin scancharnum;curchr:=curval;
if ischarascii(curchr)then goto 70 else goto 130;end;
182:begin getxtoken;
if(curcmd=11)or(curcmd=12)or(curcmd=16)or(curcmd=17)or(curcmd=18)or(
curcmd=71)or(curcmd=19)then cancelboundary:=true;goto 21;end;
124:if curlist.auxfield.hh.lh=1000 then goto 120 else appspace;
181,294:goto 120;{1063:}1,114,227,11,237,295:;
43,156,269:begin if curchr=0 then begin{423:}repeat getxtoken;
until curcmd<>10{:423};goto 21;end else begin t:=scannerstatus;
scannerstatus:=0;getnext;scannerstatus:=t;
if curcs<514 then curcs:=primlookup(curcs-257)else curcs:=primlookup(
hash[curcs].rh);if curcs<>0 then begin curcmd:=primeqtb[curcs].hh.b0;
curchr:=primeqtb[curcs].hh.rh;goto 21;end;end;end;
15:if itsallover then goto 10;
{1066:}26,138,251,75,188,301,{:1066}{1116:}42,{:1116}{1129:}48,{:1129}
{1162:}52,165,{:1162}7,120,233:reportillegalcase;
{1064:}8,121,9,122,21,134,73,186,74,187,54,167,16,129,53,166,56,169,70,
183,57,170,58,171,60,173,59,172,34,147,55,168,32,145,50,163,236,240,241,
257,254,263,266{:1064}:insertdollarsign;
{1074:}40,152,265:begin begin mem[curlist.tailfield].hh.rh:=scanrulespec
;curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
if abs(curlist.modefield)=1 then curlist.auxfield.int:=-65536000 else if
abs(curlist.modefield)=114 then curlist.auxfield.hh.lh:=1000;end;
{:1074}{1075:}31,143,256,258:appendglue;33,146,259,260:appendkern;
{:1075}{1081:}2,115:newsavelevel(1);65,178,291:newsavelevel(14);
66,179,292:if curgroup=14 then unsave else offsave;
{:1081}{1085:}3,116,229:handlerightbrace;
{:1085}{1091:}25,139,252:begin t:=curchr;scandimen(false,false,false);
if t=0 then scanbox(curval)else scanbox(-curval);end;
35,148,261:scanbox(1073872797+curchr);24,137,250:beginbox(0);
77,190,303:begin if curgroup<>6 then if curlist.headfield=curlist.
tailfield then begin curlist.dirfield:=curchr;
if curlist.modefield=1 then pagedir:=curchr;
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(1168);
end;printcmdchr(curcmd,curchr);print(1169);begin helpptr:=2;
helpline[1]:=1170;helpline[0]:=1171;end;error;
end else begin begin if interaction=3 then;
if filelineerrorstylep then printfileline else printnl(263);print(746);
end;printcmdchr(curcmd,curchr);print(1172);begin helpptr:=2;
helpline[1]:=1173;helpline[0]:=1174;end;error;end end;
{:1091}{1108:}47:newgraf(curchr>0);
12,13,20,72,4,27,39,49,51,30,37,17,18,19,68,69:begin backinput;
newgraf(true);end;{:1108}{1110:}160,273:indentinhmode;
{:1110}{1112:}14:begin normalparagraph;
if curlist.modefield>0 then buildpage;end;
127:begin if alignstate<0 then offsave;endgraf;
if curlist.modefield=1 then buildpage;end;
128,144,153,141,149:headforvmode;
{:1112}{1115:}41,154,267,155,268:begininsertoradjust;
22,135,248:makemark;{:1115}{1120:}46,159,272:appendpenalty;
{:1120}{1122:}29,142,255:deletelast;{:1122}{1127:}28,140,253:unpackage;
{:1127}{1130:}161:appenditaliccorrection;
274:begin mem[curlist.tailfield].hh.rh:=newkern(0);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
{:1130}{1134:}164,277:appenddiscretionary;{:1134}{1140:}162:makeaccent;
{:1140}{1144:}6,119,232,5,118,231:alignerror;38,151,264:noalignerror;
67,180,293:omiterror;{:1144}{1148:}36:initalign;
150:{1453:}if curchr>0 then begin if eTeXenabled((eqtb[29001].int>0),
curcmd,curchr)then begin mem[curlist.tailfield].hh.rh:=newmath(0,curchr)
;curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
end else{:1453}initalign;
262:if privileged then if curgroup=15 then initalign else offsave;
10,123:doendv;{:1148}{1152:}71,184,297:cserror;
{:1152}{1155:}117:initmath;
{:1155}{1158:}278:if privileged then if curgroup=15 then starteqno else
offsave;
{:1158}{1168:}228:begin begin mem[curlist.tailfield].hh.rh:=newnoad;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;backinput;
scanmath(curlist.tailfield+1,curlist.tailfield+4);end;
{:1168}{1172:}238,239,298:if ischarascii(curchr)then if curchr<128 then
setmathchar(eqtb[28419+curchr].hh.rh)else setmathchar(curchr)else
setmathkchar(curchr);243,244,245:begin cx:=curchr;setmathkchar(cx);end;
246:begin scancharnum;curchr:=curval;
if ischarascii(curchr)then if curchr<128 then setmathchar(eqtb[28419+
curchr].hh.rh)else setmathchar(curchr)else setmathkchar(curchr);end;
247:begin if curchr=0 then scanfifteenbitint else scanbigfifteenbitint;
setmathchar(curval);end;
299:begin setmathchar(((curchr div 4096)*65536)+(curchr mod 4096));end;
300:begin setmathchar(((curchr div 65536)*256)+(curchr mod 256));end;
242:begin if curchr=0 then scantwentysevenbitint else scanfiftyonebitint
;setmathchar(curval);end;
{:1172}{1176:}280:begin begin mem[curlist.tailfield].hh.rh:=newnoad;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=curchr;
scanmath(curlist.tailfield+1,curlist.tailfield+4);end;
281:mathlimitswitch;{:1176}{1180:}296:mathradical;
{:1180}{1182:}275,276:mathac;{:1182}{1185:}286:begin scanspec(12,false);
normalparagraph;inhibitglueflag:=false;pushnest;curlist.modefield:=-1;
curlist.auxfield.int:=-65536000;
if(insertsrcspecialeveryvbox)then insertsrcspecial;
if eqtb[25067].hh.rh<>-268435455 then begintokenlist(eqtb[25067].hh.rh,
11);end;
{:1185}{1189:}283:begin mem[curlist.tailfield].hh.rh:=newstyle(curchr);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
285:begin begin mem[curlist.tailfield].hh.rh:=newglue(membot);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=98;end;284:appendchoices;
{:1189}{1193:}235,234:subsup;{:1193}{1198:}282:mathfraction;
{:1198}{1208:}279:mathleftright;
{:1208}{1211:}230:if curgroup=15 then aftermath else offsave;
{:1211}{1228:}86,199,312,87,200,313,113,226,339,88,201,314,78,191,304,79
,192,305,80,193,306,99,212,325,100,213,326,81,194,307,82,195,308,83,196,
309,84,197,310,85,198,311,89,202,315,90,203,316,91,204,317,92,205,318,93
,206,319,94,207,320,95,208,321,96,209,322,97,210,323,98,211,324,101,214,
327,102,215,328,103,216,329,104,217,330,105,218,331,106,219,332,107,220,
333,108,221,334,109,222,335,110,223,336,111,224,337,112,225,338:
prefixedcommand;{:1228}{1287:}44,157,270:begin gettoken;
aftertoken:=curtok;end;{:1287}{1290:}45,158,271:begin gettoken;
saveforafter(curtok);end;{:1290}{1293:}64,177,290:openorclosein;
{:1293}{1295:}62,175,288:issuemessage;
{:1295}{1304:}61,174,287:shiftcase;
{:1304}{1309:}23,136,249:showwhatever;
{:1309}{1696:}76,189,302:inhibitglueflag:=true;
{:1696}{1366:}63,176,289:doextension;{:1366}{:1063}end;goto 60;
130:{1733:}if(curlist.tailfield>=himemmin)then begin cx:=mem[curlist.
tailfield].hh.b1;{1709:}begin kp:=getkinsokupos(cx,1);
if kp<>1000 then begin if eqtb[27385+kp].hh.b0=2 then begin begin mem[
curlist.tailfield].hh.rh:=newpenalty(eqtb[29795+kp].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=2;end;end;end;{:1709};
end else if mem[curlist.tailfield].hh.b0=8 then begin cx:=mem[curlist.
tailfield+1].hh.b1;{1709:}begin kp:=getkinsokupos(cx,1);
if kp<>1000 then begin if eqtb[27385+kp].hh.b0=2 then begin begin mem[
curlist.tailfield].hh.rh:=newpenalty(eqtb[29795+kp].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=2;end;end;end;{:1709};end;
if curlist.dirfield=3 then begin if fontdir[mainf]=3 then disp:=0 else
if fontdir[mainf]=4 then disp:=eqtb[29535].int-eqtb[29536].int else disp
:=eqtb[29535].int;mainf:=eqtb[26358].hh.rh;
end else begin if fontdir[mainf]=4 then disp:=0 else if fontdir[mainf]=3
then disp:=eqtb[29536].int-eqtb[29535].int else disp:=eqtb[29536].int;
mainf:=eqtb[26357].hh.rh;end;
{1735:}if disp<>0 then begin if not(curlist.tailfield>=himemmin)and(mem[
curlist.tailfield].hh.b0=5)then begin mem[curlist.tailfield+1].int:=0;
end else begin curlist.pnodefield:=curlist.tailfield;
begin mem[curlist.tailfield].hh.rh:=getnode(2);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=5;mem[curlist.tailfield+1].int:=0;
curlist.pdispfield:=disp;end;end;{:1735};inskp:=false;
ligaturepresent:=false;curl:=getjfmpos(curchr,mainf);
maini:=fontinfo[charbase[mainf]+0].qqqq;goto 133;
131:curlist.auxfield.hh.lh:=1000;
if mainf<>0 then begin begin mainp:=avail;
if mainp=-268435455 then mainp:=getavail else begin avail:=mem[mainp].hh
.rh;mem[mainp].hh.rh:=-268435455;ifdef('STAT')incr(dynused);
endif('STAT')end;end;mem[mainp].hh.b0:=mainf;mem[mainp].hh.b1:=curl;
mem[curlist.tailfield].hh.rh:=mainp;curlist.tailfield:=mainp;
curlist.lastjchrfield:=curlist.tailfield;begin mainp:=avail;
if mainp=-268435455 then mainp:=getavail else begin avail:=mem[mainp].hh
.rh;mem[mainp].hh.rh:=-268435455;ifdef('STAT')incr(dynused);
endif('STAT')end;end;mem[mainp].hh.lh:=curchr;
mem[curlist.tailfield].hh.rh:=mainp;curlist.tailfield:=mainp;cx:=curchr;
{1707:}begin kp:=getkinsokupos(cx,1);
if kp<>1000 then begin if eqtb[27385+kp].hh.b0=1 then begin if not(curq
>=himemmin)and(mem[curq].hh.b0=14)then mem[curq+1].int:=mem[curq+1].int+
eqtb[29795+kp].int else begin mainp:=mem[curq].hh.rh;
mem[curq].hh.rh:=newpenalty(eqtb[29795+kp].int);
mem[mem[curq].hh.rh].hh.b1:=2;mem[mem[curq].hh.rh].hh.rh:=mainp;end;
end else if eqtb[27385+kp].hh.b0=2 then begin begin mem[curlist.
tailfield].hh.rh:=newpenalty(eqtb[29795+kp].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=2;end;end;end;{:1707};end;inskp:=false;
150:getnext;maini:=fontinfo[charbase[mainf]+curl].qqqq;
case curcmd of 16,17,18:begin curl:=getjfmpos(curchr,mainf);goto 133;
end;11,12:begin inskp:=true;curl:=0;goto 133;end;end;xtoken;
case curcmd of 16,17,18:curl:=getjfmpos(curchr,mainf);
11,12:begin inskp:=true;curl:=0;end;
71:begin if ischarascii(curchr)then begin inskp:=true;curl:=0;
end else curl:=getjfmpos(curchr,mainf);end;19:begin scancharnum;
curchr:=curval;if ischarascii(curchr)then begin inskp:=true;curl:=0;
end else curl:=getjfmpos(curchr,mainf);end;
75:begin inhibitglueflag:=true;goto 150;end;
others:begin inskp:=268435455;curl:=0;curr:=256;ligstack:=-268435455;
end;end;133:if inskp=true then{1708:}begin kp:=getkinsokupos(curchr,1);
if kp<>1000 then begin if eqtb[27385+kp].hh.b0=1 then if not(curlist.
tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=14)then mem[curlist
.tailfield+1].int:=mem[curlist.tailfield+1].int+eqtb[29795+kp].int else
begin begin mem[curlist.tailfield].hh.rh:=newpenalty(eqtb[29795+kp].int)
;curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=2;end;end;end;{:1708};
if mainf<>0 then begin{1736:}curq:=curlist.tailfield;
if inhibitglueflag<>true then begin if((maini.b2)mod 4)=1 then begin
maink:=ligkernbase[mainf]+maini.b3;repeat mainj:=fontinfo[maink].qqqq;
if mainj.b1=curl then begin if mainj.b2<128 then begin gp:=fontglue[
mainf];curr:=mainj.b3;
if gp<>-268435455 then begin while((mem[gp].hh.b0<>curr)and(mem[gp].hh.
rh<>-268435455))do gp:=mem[gp].hh.rh;gq:=mem[gp+1].hh.lh;
end else begin gp:=getnode(2);fontglue[mainf]:=gp;gq:=-268435455;end;
if gq=-268435455 then begin mem[gp].hh.b0:=curr;gq:=newspec(membot);
mem[gp+1].hh.lh:=gq;maink:=extenbase[mainf]+(curr)*3;
mem[gq+1].int:=fontinfo[maink].int;mem[gq+2].int:=fontinfo[maink+1].int;
mem[gq+3].int:=fontinfo[maink+2].int;incr(mem[gq].hh.rh);
mem[gp].hh.rh:=getnode(2);gp:=mem[gp].hh.rh;mem[gp+1].hh.lh:=-268435455;
mem[gp].hh.rh:=-268435455;end;
begin mem[curlist.tailfield].hh.rh:=newglue(gq);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=21;goto 141;
end else begin begin mem[curlist.tailfield].hh.rh:=newkern(fontinfo[
kernbase[mainf]+256*mainj.b2+mainj.b3].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;goto 141;end;end;
incr(maink);until mainj.b0>=128;end;end;141:inhibitglueflag:=false;
{:1736};end else inhibitglueflag:=false;
if inskp=false then begin goto 131;
end else if inskp=true then begin inskp:=false;goto 70;
end else begin goto 21;end;{:1733};70:inhibitglueflag:=false;
{1051:}if((curlist.headfield=curlist.tailfield)and(curlist.modefield>0))
then begin if(insertsrcspecialauto)then appendsrcspecial;end;
mains:=eqtb[28163+curchr].hh.rh;
if mains=1000 then curlist.auxfield.hh.lh:=1000 else if mains<1000 then
begin if mains>0 then curlist.auxfield.hh.lh:=mains;
end else if curlist.auxfield.hh.lh<1000 then curlist.auxfield.hh.lh:=
1000 else curlist.auxfield.hh.lh:=mains;
if curlist.dirfield=3 then disp:=eqtb[29535].int else disp:=eqtb[29536].
int;{1734:}begin if not(curlist.tailfield>=himemmin)and(mem[curlist.
tailfield].hh.b0=5)then begin if curlist.pdispfield=disp then begin
freenode(curlist.tailfield,2);curlist.tailfield:=curlist.pnodefield;
mem[curlist.tailfield].hh.rh:=-268435455;
end else mem[curlist.tailfield+1].int:=disp;
end else if disp<>0 then begin curlist.pnodefield:=curlist.tailfield;
begin mem[curlist.tailfield].hh.rh:=getnode(2);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=5;mem[curlist.tailfield+1].int:=disp;
curlist.pdispfield:=disp;end;end;{:1734};mainf:=eqtb[25588].hh.rh;
bchar:=fontbchar[mainf];falsebchar:=fontfalsebchar[mainf];
if curlist.modefield>0 then if eqtb[28982].int<>curlist.auxfield.hh.rh
then fixlanguage;begin ligstack:=avail;
if ligstack=-268435455 then ligstack:=getavail else begin avail:=mem[
ligstack].hh.rh;mem[ligstack].hh.rh:=-268435455;
ifdef('STAT')incr(dynused);endif('STAT')end;end;
mem[ligstack].hh.b0:=mainf;curl:=curchr;mem[ligstack].hh.b1:=curl;
curq:=curlist.tailfield;
if cancelboundary then begin cancelboundary:=false;maink:=0;
end else maink:=bcharlabel[mainf];if maink=0 then goto 92;curr:=curl;
curl:=256;goto 111;
80:{1052:}if curl<256 then begin if mem[curq].hh.rh>-268435455 then if
mem[curlist.tailfield].hh.b1=hyphenchar[mainf]then insdisc:=true;
if ligaturepresent then begin mainp:=newligature(mainf,curl,mem[curq].hh
.rh);if lfthit then begin mem[mainp].hh.b1:=2;lfthit:=false;end;
if rthit then if ligstack=-268435455 then begin incr(mem[mainp].hh.b1);
rthit:=false;end;mem[curq].hh.rh:=mainp;curlist.tailfield:=mainp;
ligaturepresent:=false;end;if insdisc then begin insdisc:=false;
if curlist.modefield>0 then begin mem[curlist.tailfield].hh.rh:=newdisc;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;end;end{:1052};
90:{1053:}if ligstack=-268435455 then begin{1735:}if disp<>0 then begin
if not(curlist.tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=5)
then begin mem[curlist.tailfield+1].int:=0;
end else begin curlist.pnodefield:=curlist.tailfield;
begin mem[curlist.tailfield].hh.rh:=getnode(2);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b0:=5;mem[curlist.tailfield+1].int:=0;
curlist.pdispfield:=disp;end;end;{:1735};goto 21;end;
curq:=curlist.tailfield;curl:=mem[ligstack].hh.b1;
91:if not(ligstack>=himemmin)then goto 95;
92:if(effectivechar(false,mainf,curchr)>fontec[mainf])or(effectivechar(
false,mainf,curchr)<fontbc[mainf])then begin charwarning(mainf,curchr);
begin mem[ligstack].hh.rh:=avail;avail:=ligstack;
ifdef('STAT')decr(dynused);endif('STAT')end;goto 60;end;
maini:=effectivecharinfo(mainf,curl);
if not(maini.b0>0)then begin charwarning(mainf,curchr);
begin mem[ligstack].hh.rh:=avail;avail:=ligstack;
ifdef('STAT')decr(dynused);endif('STAT')end;goto 60;end;
mem[curlist.tailfield].hh.rh:=ligstack;
curlist.tailfield:=ligstack{:1053};100:{1055:}getnext;
if curcmd=11 then goto 101;
if(curcmd=16)or(curcmd=17)or(curcmd=18)then{1056:}begin bchar:=256;
curr:=bchar;ligstack:=-268435455;
if ligaturepresent then begin mainp:=newligature(mainf,curl,mem[curq].hh
.rh);if lfthit then begin mem[mainp].hh.b1:=2;lfthit:=false;end;
if rthit then if ligstack=-268435455 then begin incr(mem[mainp].hh.b1);
rthit:=false;end;mem[curq].hh.rh:=mainp;curlist.tailfield:=mainp;
ligaturepresent:=false;end;if inskp=true then begin cx:=curl;
{1707:}begin kp:=getkinsokupos(cx,1);
if kp<>1000 then begin if eqtb[27385+kp].hh.b0=1 then begin if not(curq
>=himemmin)and(mem[curq].hh.b0=14)then mem[curq+1].int:=mem[curq+1].int+
eqtb[29795+kp].int else begin mainp:=mem[curq].hh.rh;
mem[curq].hh.rh:=newpenalty(eqtb[29795+kp].int);
mem[mem[curq].hh.rh].hh.b1:=2;mem[mem[curq].hh.rh].hh.rh:=mainp;end;
end else if eqtb[27385+kp].hh.b0=2 then begin begin mem[curlist.
tailfield].hh.rh:=newpenalty(eqtb[29795+kp].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=2;end;end;end;{:1707};end;inskp:=false;
goto 130;end{:1056};if curcmd=12 then goto 101;
if curcmd=71 then begin if ischarascii(curchr)then goto 101 else{1056:}
begin bchar:=256;curr:=bchar;ligstack:=-268435455;
if ligaturepresent then begin mainp:=newligature(mainf,curl,mem[curq].hh
.rh);if lfthit then begin mem[mainp].hh.b1:=2;lfthit:=false;end;
if rthit then if ligstack=-268435455 then begin incr(mem[mainp].hh.b1);
rthit:=false;end;mem[curq].hh.rh:=mainp;curlist.tailfield:=mainp;
ligaturepresent:=false;end;if inskp=true then begin cx:=curl;
{1707:}begin kp:=getkinsokupos(cx,1);
if kp<>1000 then begin if eqtb[27385+kp].hh.b0=1 then begin if not(curq
>=himemmin)and(mem[curq].hh.b0=14)then mem[curq+1].int:=mem[curq+1].int+
eqtb[29795+kp].int else begin mainp:=mem[curq].hh.rh;
mem[curq].hh.rh:=newpenalty(eqtb[29795+kp].int);
mem[mem[curq].hh.rh].hh.b1:=2;mem[mem[curq].hh.rh].hh.rh:=mainp;end;
end else if eqtb[27385+kp].hh.b0=2 then begin begin mem[curlist.
tailfield].hh.rh:=newpenalty(eqtb[29795+kp].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=2;end;end;end;{:1707};end;inskp:=false;
goto 130;end{:1056};end;xtoken;if curcmd=11 then goto 101;
if(curcmd=16)or(curcmd=17)or(curcmd=18)then{1056:}begin bchar:=256;
curr:=bchar;ligstack:=-268435455;
if ligaturepresent then begin mainp:=newligature(mainf,curl,mem[curq].hh
.rh);if lfthit then begin mem[mainp].hh.b1:=2;lfthit:=false;end;
if rthit then if ligstack=-268435455 then begin incr(mem[mainp].hh.b1);
rthit:=false;end;mem[curq].hh.rh:=mainp;curlist.tailfield:=mainp;
ligaturepresent:=false;end;if inskp=true then begin cx:=curl;
{1707:}begin kp:=getkinsokupos(cx,1);
if kp<>1000 then begin if eqtb[27385+kp].hh.b0=1 then begin if not(curq
>=himemmin)and(mem[curq].hh.b0=14)then mem[curq+1].int:=mem[curq+1].int+
eqtb[29795+kp].int else begin mainp:=mem[curq].hh.rh;
mem[curq].hh.rh:=newpenalty(eqtb[29795+kp].int);
mem[mem[curq].hh.rh].hh.b1:=2;mem[mem[curq].hh.rh].hh.rh:=mainp;end;
end else if eqtb[27385+kp].hh.b0=2 then begin begin mem[curlist.
tailfield].hh.rh:=newpenalty(eqtb[29795+kp].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=2;end;end;end;{:1707};end;inskp:=false;
goto 130;end{:1056};if curcmd=12 then goto 101;
if curcmd=71 then begin if ischarascii(curchr)then goto 101 else{1056:}
begin bchar:=256;curr:=bchar;ligstack:=-268435455;
if ligaturepresent then begin mainp:=newligature(mainf,curl,mem[curq].hh
.rh);if lfthit then begin mem[mainp].hh.b1:=2;lfthit:=false;end;
if rthit then if ligstack=-268435455 then begin incr(mem[mainp].hh.b1);
rthit:=false;end;mem[curq].hh.rh:=mainp;curlist.tailfield:=mainp;
ligaturepresent:=false;end;if inskp=true then begin cx:=curl;
{1707:}begin kp:=getkinsokupos(cx,1);
if kp<>1000 then begin if eqtb[27385+kp].hh.b0=1 then begin if not(curq
>=himemmin)and(mem[curq].hh.b0=14)then mem[curq+1].int:=mem[curq+1].int+
eqtb[29795+kp].int else begin mainp:=mem[curq].hh.rh;
mem[curq].hh.rh:=newpenalty(eqtb[29795+kp].int);
mem[mem[curq].hh.rh].hh.b1:=2;mem[mem[curq].hh.rh].hh.rh:=mainp;end;
end else if eqtb[27385+kp].hh.b0=2 then begin begin mem[curlist.
tailfield].hh.rh:=newpenalty(eqtb[29795+kp].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=2;end;end;end;{:1707};end;inskp:=false;
goto 130;end{:1056};end;if curcmd=19 then begin scancharnum;
curchr:=curval;
if ischarascii(curchr)then goto 101 else{1056:}begin bchar:=256;
curr:=bchar;ligstack:=-268435455;
if ligaturepresent then begin mainp:=newligature(mainf,curl,mem[curq].hh
.rh);if lfthit then begin mem[mainp].hh.b1:=2;lfthit:=false;end;
if rthit then if ligstack=-268435455 then begin incr(mem[mainp].hh.b1);
rthit:=false;end;mem[curq].hh.rh:=mainp;curlist.tailfield:=mainp;
ligaturepresent:=false;end;if inskp=true then begin cx:=curl;
{1707:}begin kp:=getkinsokupos(cx,1);
if kp<>1000 then begin if eqtb[27385+kp].hh.b0=1 then begin if not(curq
>=himemmin)and(mem[curq].hh.b0=14)then mem[curq+1].int:=mem[curq+1].int+
eqtb[29795+kp].int else begin mainp:=mem[curq].hh.rh;
mem[curq].hh.rh:=newpenalty(eqtb[29795+kp].int);
mem[mem[curq].hh.rh].hh.b1:=2;mem[mem[curq].hh.rh].hh.rh:=mainp;end;
end else if eqtb[27385+kp].hh.b0=2 then begin begin mem[curlist.
tailfield].hh.rh:=newpenalty(eqtb[29795+kp].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;
mem[curlist.tailfield].hh.b1:=2;end;end;end;{:1707};end;inskp:=false;
goto 130;end{:1056};end;if curcmd=75 then begin inhibitglueflag:=true;
goto 100;end;if curcmd=68 then bchar:=256;curr:=bchar;
ligstack:=-268435455;goto 110;101:mains:=eqtb[28163+curchr].hh.rh;
if mains=1000 then curlist.auxfield.hh.lh:=1000 else if mains<1000 then
begin if mains>0 then curlist.auxfield.hh.lh:=mains;
end else if curlist.auxfield.hh.lh<1000 then curlist.auxfield.hh.lh:=
1000 else curlist.auxfield.hh.lh:=mains;inhibitglueflag:=false;
begin ligstack:=avail;
if ligstack=-268435455 then ligstack:=getavail else begin avail:=mem[
ligstack].hh.rh;mem[ligstack].hh.rh:=-268435455;
ifdef('STAT')incr(dynused);endif('STAT')end;end;
mem[ligstack].hh.b0:=mainf;curr:=curchr;mem[ligstack].hh.b1:=curr;
if curr=falsebchar then curr:=256{:1055};
110:{1057:}if((maini.b2)mod 4)<>1 then goto 80;if curr=256 then goto 80;
maink:=ligkernbase[mainf]+maini.b3;mainj:=fontinfo[maink].qqqq;
if mainj.b0<=128 then goto 112;
maink:=ligkernbase[mainf]+256*mainj.b2+mainj.b3+32768-256*(128);
111:mainj:=fontinfo[maink].qqqq;
112:if mainj.b1=curr then if mainj.b0<=128 then{1058:}begin if mainj.b2
>=128 then begin if curl<256 then begin if mem[curq].hh.rh>-268435455
then if mem[curlist.tailfield].hh.b1=hyphenchar[mainf]then insdisc:=true
;
if ligaturepresent then begin mainp:=newligature(mainf,curl,mem[curq].hh
.rh);if lfthit then begin mem[mainp].hh.b1:=2;lfthit:=false;end;
if rthit then if ligstack=-268435455 then begin incr(mem[mainp].hh.b1);
rthit:=false;end;mem[curq].hh.rh:=mainp;curlist.tailfield:=mainp;
ligaturepresent:=false;end;if insdisc then begin insdisc:=false;
if curlist.modefield>0 then begin mem[curlist.tailfield].hh.rh:=newdisc;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;end;end;
begin mem[curlist.tailfield].hh.rh:=newkern(fontinfo[kernbase[mainf]+256
*mainj.b2+mainj.b3].int);
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;goto 90;end;
if curl=256 then lfthit:=true else if ligstack=-268435455 then rthit:=
true;begin if interrupt<>0 then pauseforinstructions;end;
case mainj.b2 of 1,5:begin curl:=mainj.b3;
maini:=fontinfo[charbase[mainf]+effectivechar(true,mainf,curl)].qqqq;
ligaturepresent:=true;end;2,6:begin curr:=mainj.b3;
if ligstack=-268435455 then begin ligstack:=newligitem(curr);bchar:=256;
end else if(ligstack>=himemmin)then begin mainp:=ligstack;
ligstack:=newligitem(curr);mem[ligstack+1].hh.rh:=mainp;
end else mem[ligstack].hh.b1:=curr;end;3:begin curr:=mainj.b3;
mainp:=ligstack;ligstack:=newligitem(curr);mem[ligstack].hh.rh:=mainp;
end;
7,11:begin if curl<256 then begin if mem[curq].hh.rh>-268435455 then if
mem[curlist.tailfield].hh.b1=hyphenchar[mainf]then insdisc:=true;
if ligaturepresent then begin mainp:=newligature(mainf,curl,mem[curq].hh
.rh);if lfthit then begin mem[mainp].hh.b1:=2;lfthit:=false;end;
if false then if ligstack=-268435455 then begin incr(mem[mainp].hh.b1);
rthit:=false;end;mem[curq].hh.rh:=mainp;curlist.tailfield:=mainp;
ligaturepresent:=false;end;if insdisc then begin insdisc:=false;
if curlist.modefield>0 then begin mem[curlist.tailfield].hh.rh:=newdisc;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;end;end;
curq:=curlist.tailfield;curl:=mainj.b3;
maini:=fontinfo[charbase[mainf]+effectivechar(true,mainf,curl)].qqqq;
ligaturepresent:=true;end;others:begin curl:=mainj.b3;
ligaturepresent:=true;if ligstack=-268435455 then goto 80 else goto 91;
end end;if mainj.b2>4 then if mainj.b2<>7 then goto 80;
if curl<256 then goto 110;maink:=bcharlabel[mainf];goto 111;end{:1058};
if mainj.b0=0 then incr(maink)else begin if mainj.b0>=128 then goto 80;
maink:=maink+mainj.b0+1;end;goto 111{:1057};
95:{1054:}mainp:=mem[ligstack+1].hh.rh;
if mainp>-268435455 then begin mem[curlist.tailfield].hh.rh:=mainp;
curlist.tailfield:=mem[curlist.tailfield].hh.rh;end;tempptr:=ligstack;
ligstack:=mem[tempptr].hh.rh;freenode(tempptr,2);
maini:=fontinfo[charbase[mainf]+effectivechar(true,mainf,curl)].qqqq;
ligaturepresent:=true;
if ligstack=-268435455 then if mainp>-268435455 then goto 100 else curr
:=bchar else curr:=mem[ligstack].hh.b1;goto 110{:1054}{:1051};
120:{1059:}if eqtb[24540].hh.rh=membot then begin{1060:}begin mainp:=
fontglue[eqtb[25588].hh.rh];
if mainp=-268435455 then begin mainp:=newspec(membot);
maink:=parambase[eqtb[25588].hh.rh]+2;
mem[mainp+1].int:=fontinfo[maink].int;
mem[mainp+2].int:=fontinfo[maink+1].int;
mem[mainp+3].int:=fontinfo[maink+2].int;
fontglue[eqtb[25588].hh.rh]:=mainp;end;end{:1060};
tempptr:=newglue(mainp);end else tempptr:=newparamglue(12);
if not(curlist.tailfield>=himemmin)and(mem[curlist.tailfield].hh.b0=5)
then begin mem[curlist.pnodefield].hh.rh:=tempptr;
mem[tempptr].hh.rh:=curlist.tailfield;curlist.pnodefield:=tempptr;
end else begin mem[curlist.tailfield].hh.rh:=tempptr;
curlist.tailfield:=tempptr;end;goto 60{:1059};10:end;
{:1047}{1303:}procedure giveerrhelp;begin tokenshow(eqtb[25070].hh.rh);
end;{:1303}{1322:}{541:}function openfmtfile:boolean;label 40,10;
var j:0..bufsize;begin j:=curinput.locfield;
if buffer[curinput.locfield]=38 then begin incr(curinput.locfield);
j:=curinput.locfield;buffer[last]:=32;while buffer[j]<>32 do incr(j);
packbufferedname(0,curinput.locfield,j-1);
if wopenin(fmtfile)then goto 40;;
write(stdout,'Sorry, I can''t find the format `');
fputs(stringcast(nameoffile+1),stdout);write(stdout,'''; will try `');
fputs(TEXformatdefault+1,stdout);writeln(stdout,'''.');fflush(stdout);
end;packbufferedname(formatdefaultlength-4,1,0);
if not wopenin(fmtfile)then begin;
write(stdout,'I can''t find the format file `');
fputs(TEXformatdefault+1,stdout);writeln(stdout,'''!');
openfmtfile:=false;goto 10;end;40:curinput.locfield:=j;
openfmtfile:=true;10:end;{:541}function loadfmtfile:boolean;
label 6666,10;var j,k:integer;p,q:halfword;x:integer;
formatengine:^ASCIIcode;dummyxord:ASCIIcode;dummyxchr:ASCIIcode;
dummyxprn:ASCIIcode;
begin{1327:}ifdef('INITEX')if iniversion then begin libcfree(fontinfo);
libcfree(strpool);libcfree(strstart);libcfree(yhash);libcfree(zeqtb);
libcfree(yzmem);end;endif('INITEX')undumpint(x);
if debugformatfile then begin write(stderr,'fmtdebug:',
'format magic number');writeln(stderr,' = ',x);end;;
if x<>1462916184 then goto 6666;undumpint(x);
if debugformatfile then begin write(stderr,'fmtdebug:',
'engine name size');writeln(stderr,' = ',x);end;;
if(x<0)or(x>256)then goto 6666;formatengine:=xmallocarray(ASCIIcode,x);
undumpthings(formatengine[0],x);formatengine[x-1]:=0;
if strcmp(enginename,stringcast(formatengine))then begin;
writeln(stdout,'---! ',stringcast(nameoffile+1),' was written by ',
formatengine);libcfree(formatengine);goto 6666;end;
libcfree(formatengine);undumpint(x);
if debugformatfile then begin write(stderr,'fmtdebug:',
'string pool checksum');writeln(stderr,' = ',x);end;;
if x<>173755214 then begin;
writeln(stdout,'---! ',stringcast(nameoffile+1),' doesn''t match ',
poolname);goto 6666;end;
{1630:}if translatefilename then begin for k:=0 to 255 do undumpthings(
dummyxord,1);for k:=0 to 255 do undumpthings(dummyxchr,1);
for k:=0 to 255 do undumpthings(dummyxprn,1);
end else begin undumpthings(xord[0],256);undumpthings(xchr[0],256);
undumpthings(xprn[0],256);
if eightbitp then for k:=0 to 255 do xprn[k]:=1;end;{:1630};
undumpint(x);if x<>268435455 then goto 6666;undumpint(hashhigh);
if(hashhigh<0)or(hashhigh>suphashextra)then goto 6666;
if hashextra<hashhigh then hashextra:=hashhigh;eqtbtop:=30050+hashextra;
if hashextra=0 then hashtop:=24527 else hashtop:=eqtbtop;
yhash:=xmallocarray(twohalves,1+hashtop-hashoffset);
hash:=yhash-hashoffset;hash[514].lh:=0;hash[514].rh:=0;
for x:=515 to hashtop do hash[x]:=hash[514];
zeqtb:=xmallocarray(memoryword,eqtbtop+1);eqtb:=zeqtb;
eqtb[24527].hh.b0:=113;eqtb[24527].hh.rh:=-268435455;
eqtb[24527].hh.b1:=0;for x:=30051 to eqtbtop do eqtb[x]:=eqtb[24527];
{1405:}begin undumpint(x);if(x<0)or(x>1)then goto 6666 else eTeXmode:=x;
end;if(eTeXmode=1)then begin{1567:}maxregnum:=65535;
maxreghelpline:=1547;{:1567}end else begin{1566:}maxregnum:=255;
maxreghelpline:=749;{:1566}end;{:1405}undumpint(x);
if debugformatfile then begin write(stderr,'fmtdebug:','mem_bot');
writeln(stderr,' = ',x);end;;if x<>membot then goto 6666;
undumpint(memtop);
if debugformatfile then begin write(stderr,'fmtdebug:','mem_top');
writeln(stderr,' = ',memtop);end;;if membot+1100>memtop then goto 6666;
curlist.headfield:=memtop-1;curlist.tailfield:=memtop-1;
pagetail:=memtop-2;memmin:=membot-extramembot;
memmax:=memtop+extramemtop;
yzmem:=xmallocarray(memoryword,memmax-memmin+1);zmem:=yzmem-memmin;
mem:=zmem;undumpint(x);if x<>30050 then goto 6666;undumpint(x);
if x<>8501 then goto 6666;undumpint(x);if x<>607 then goto 6666{:1327};
{1644:}undumpint(x);if x<>1296847960 then goto 6666;undumpint(x);
if x=1 then mltexenabledp:=true else if x<>0 then goto 6666;{:1644};
{1329:}begin undumpint(x);if x<0 then goto 6666;
if x>suppoolsize-poolfree then begin;
writeln(stdout,'---! Must increase the ','string pool size');goto 6666;
end else if debugformatfile then begin write(stderr,'fmtdebug:',
'string pool size');writeln(stderr,' = ',x);end;;poolptr:=x;end;
if poolsize<poolptr+poolfree then poolsize:=poolptr+poolfree;
begin undumpint(x);if x<0 then goto 6666;
if x>supmaxstrings-stringsfree then begin;
writeln(stdout,'---! Must increase the ','sup strings');goto 6666;
end else if debugformatfile then begin write(stderr,'fmtdebug:',
'sup strings');writeln(stderr,' = ',x);end;;strptr:=x;end;
if maxstrings<strptr+stringsfree then maxstrings:=strptr+stringsfree;
strstart:=xmallocarray(poolpointer,maxstrings);
undumpcheckedthings(0,poolptr,strstart[0],strptr+1);
strpool:=xmallocarray(packedASCIIcode,poolsize);
undumpthings(strpool[0],poolptr);initstrptr:=strptr;
initpoolptr:=poolptr{:1329};{1331:}begin undumpint(x);
if(x<membot+1023)or(x>memtop-14)then goto 6666 else lomemmax:=x;end;
begin undumpint(x);
if(x<membot+24)or(x>lomemmax)then goto 6666 else rover:=x;end;
if(eTeXmode=1)then for k:=0 to 5 do begin undumpint(x);
if(x<-268435455)or(x>lomemmax)then goto 6666 else saroot[k]:=x;end;
p:=membot;q:=rover;repeat undumpthings(mem[p],q+2-p);p:=q+mem[q].hh.lh;
if(p>lomemmax)or((q>=mem[q+1].hh.rh)and(mem[q+1].hh.rh<>rover))then goto
6666;q:=mem[q+1].hh.rh;until q=rover;undumpthings(mem[p],lomemmax+1-p);
if memmin<membot-2 then begin p:=mem[rover+1].hh.lh;q:=memmin+1;
mem[memmin].hh.rh:=-268435455;mem[memmin].hh.lh:=-268435455;
mem[p+1].hh.rh:=q;mem[rover+1].hh.lh:=q;mem[q+1].hh.rh:=rover;
mem[q+1].hh.lh:=p;mem[q].hh.rh:=268435455;mem[q].hh.lh:=membot-q;end;
begin undumpint(x);
if(x<lomemmax+1)or(x>memtop-13)then goto 6666 else himemmin:=x;end;
begin undumpint(x);
if(x<-268435455)or(x>memtop)then goto 6666 else avail:=x;end;
memend:=memtop;undumpthings(mem[himemmin],memend+1-himemmin);
undumpint(varused);undumpint(dynused){:1331};{1333:}{1336:}k:=1;
repeat undumpint(x);if(x<1)or(k+x>30051)then goto 6666;
undumpthings(eqtb[k],x);k:=k+x;undumpint(x);
if(x<0)or(k+x>30051)then goto 6666;
for j:=k to k+x-1 do eqtb[j]:=eqtb[k-1];k:=k+x;until k>30050;
if hashhigh>0 then undumpthings(eqtb[30051],hashhigh);{:1336};
begin undumpint(x);if(x<514)or(x>hashtop)then goto 6666 else parloc:=x;
end;partoken:=65535+parloc;begin undumpint(x);
if(x<514)or(x>hashtop)then goto 6666 else writeloc:=x;end;
{1338:}for p:=0 to 2100 do undumphh(prim[p]);
for p:=0 to 2100 do undumpwd(primeqtb[p]);begin undumpint(x);
if(x<514)or(x>15514)then goto 6666 else hashused:=x;end;p:=513;
repeat begin undumpint(x);
if(x<p+1)or(x>hashused)then goto 6666 else p:=x;end;undumphh(hash[p]);
until p=hashused;undumpthings(hash[hashused+1],24526-hashused);
if debugformatfile then begin printcsnames(514,24526);end;
if hashhigh>0 then begin undumpthings(hash[30051],hashhigh);
if debugformatfile then begin printcsnames(30051,hashhigh-(30051));end;
end;undumpint(cscount){:1338}{:1333};{1340:}begin undumpint(x);
if x<7 then goto 6666;if x>supfontmemsize then begin;
writeln(stdout,'---! Must increase the ','font mem size');goto 6666;
end else if debugformatfile then begin write(stderr,'fmtdebug:',
'font mem size');writeln(stderr,' = ',x);end;;fmemptr:=x;end;
if fmemptr>fontmemsize then fontmemsize:=fmemptr;
fontinfo:=xmallocarray(memoryword,fontmemsize);
undumpthings(fontinfo[0],fmemptr);begin undumpint(x);
if x<0 then goto 6666;if x>9000 then begin;
writeln(stdout,'---! Must increase the ','font max');goto 6666;
end else if debugformatfile then begin write(stderr,'fmtdebug:',
'font max');writeln(stderr,' = ',x);end;;fontptr:=x;end;
{1342:}begin fontdir:=xmallocarray(eightbits,fontmax);
fontnumext:=xmallocarray(integer,fontmax);
fontcheck:=xmallocarray(fourquarters,fontmax);
fontsize:=xmallocarray(scaled,fontmax);
fontdsize:=xmallocarray(scaled,fontmax);
fontparams:=xmallocarray(fontindex,fontmax);
fontname:=xmallocarray(strnumber,fontmax);
fontarea:=xmallocarray(strnumber,fontmax);
fontbc:=xmallocarray(eightbits,fontmax);
fontec:=xmallocarray(eightbits,fontmax);
fontglue:=xmallocarray(halfword,fontmax);
hyphenchar:=xmallocarray(integer,fontmax);
skewchar:=xmallocarray(integer,fontmax);
bcharlabel:=xmallocarray(fontindex,fontmax);
fontbchar:=xmallocarray(ninebits,fontmax);
fontfalsebchar:=xmallocarray(ninebits,fontmax);
ctypebase:=xmallocarray(integer,fontmax);
charbase:=xmallocarray(integer,fontmax);
widthbase:=xmallocarray(integer,fontmax);
heightbase:=xmallocarray(integer,fontmax);
depthbase:=xmallocarray(integer,fontmax);
italicbase:=xmallocarray(integer,fontmax);
ligkernbase:=xmallocarray(integer,fontmax);
kernbase:=xmallocarray(integer,fontmax);
extenbase:=xmallocarray(integer,fontmax);
parambase:=xmallocarray(integer,fontmax);
undumpthings(fontdir[0],fontptr+1);
undumpthings(fontnumext[0],fontptr+1);
undumpthings(fontcheck[0],fontptr+1);
undumpthings(fontsize[0],fontptr+1);
undumpthings(fontdsize[0],fontptr+1);
undumpcheckedthings(-268435455,268435455,fontparams[0],fontptr+1);
undumpthings(hyphenchar[0],fontptr+1);
undumpthings(skewchar[0],fontptr+1);
undumpuppercheckthings(strptr,fontname[0],fontptr+1);
undumpuppercheckthings(strptr,fontarea[0],fontptr+1);
undumpthings(fontbc[0],fontptr+1);undumpthings(fontec[0],fontptr+1);
undumpthings(ctypebase[0],fontptr+1);
undumpthings(charbase[0],fontptr+1);
undumpthings(widthbase[0],fontptr+1);
undumpthings(heightbase[0],fontptr+1);
undumpthings(depthbase[0],fontptr+1);
undumpthings(italicbase[0],fontptr+1);
undumpthings(ligkernbase[0],fontptr+1);
undumpthings(kernbase[0],fontptr+1);
undumpthings(extenbase[0],fontptr+1);
undumpthings(parambase[0],fontptr+1);
undumpcheckedthings(-268435455,lomemmax,fontglue[0],fontptr+1);
undumpcheckedthings(0,fmemptr-1,bcharlabel[0],fontptr+1);
undumpcheckedthings(0,256,fontbchar[0],fontptr+1);
undumpcheckedthings(0,256,fontfalsebchar[0],fontptr+1);end{:1342};
{:1340};{1344:}begin undumpint(x);if x<0 then goto 6666;
if x>hyphsize then begin;
writeln(stdout,'---! Must increase the ','hyph_size');goto 6666;
end else if debugformatfile then begin write(stderr,'fmtdebug:',
'hyph_size');writeln(stderr,' = ',x);end;;hyphcount:=x;end;
begin undumpint(x);if x<607 then goto 6666;if x>hyphsize then begin;
writeln(stdout,'---! Must increase the ','hyph_size');goto 6666;
end else if debugformatfile then begin write(stderr,'fmtdebug:',
'hyph_size');writeln(stderr,' = ',x);end;;hyphnext:=x;end;j:=0;
for k:=1 to hyphcount do begin undumpint(j);if j<0 then goto 6666;
if j>65535 then begin hyphnext:=j div 65536;j:=j-hyphnext*65536;
end else hyphnext:=0;if(j>=hyphsize)or(hyphnext>hyphsize)then goto 6666;
hyphlink[j]:=hyphnext;begin undumpint(x);
if(x<0)or(x>strptr)then goto 6666 else hyphword[j]:=x;end;
begin undumpint(x);
if(x<-268435455)or(x>268435455)then goto 6666 else hyphlist[j]:=x;end;
end;incr(j);if j<607 then j:=607;hyphnext:=j;
if hyphnext>=hyphsize then hyphnext:=607 else if hyphnext>=607 then incr
(hyphnext);begin undumpint(x);if x<0 then goto 6666;
if x>triesize then begin;
writeln(stdout,'---! Must increase the ','trie size');goto 6666;
end else if debugformatfile then begin write(stderr,'fmtdebug:',
'trie size');writeln(stderr,' = ',x);end;;j:=x;end;
ifdef('INITEX')triemax:=j;endif('INITEX')begin undumpint(x);
if(x<0)or(x>j)then goto 6666 else hyphstart:=x;end;
if not trietrl then trietrl:=xmallocarray(triepointer,j+1);
undumpthings(trietrl[0],j+1);
if not trietro then trietro:=xmallocarray(triepointer,j+1);
undumpthings(trietro[0],j+1);
if not trietrc then trietrc:=xmallocarray(quarterword,j+1);
undumpthings(trietrc[0],j+1);begin undumpint(x);if x<0 then goto 6666;
if x>trieopsize then begin;
writeln(stdout,'---! Must increase the ','trie op size');goto 6666;
end else if debugformatfile then begin write(stderr,'fmtdebug:',
'trie op size');writeln(stderr,' = ',x);end;;j:=x;end;
ifdef('INITEX')trieopptr:=j;
endif('INITEX')undumpthings(hyfdistance[1],j);undumpthings(hyfnum[1],j);
undumpuppercheckthings(maxtrieop,hyfnext[1],j);
ifdef('INITEX')for k:=0 to 255 do trieused[k]:=0;endif('INITEX')k:=256;
while j>0 do begin begin undumpint(x);
if(x<0)or(x>k-1)then goto 6666 else k:=x;end;begin undumpint(x);
if(x<1)or(x>j)then goto 6666 else x:=x;end;
ifdef('INITEX')trieused[k]:=x;endif('INITEX')j:=j-x;opstart[k]:=j;end;
ifdef('INITEX')trienotready:=false endif('INITEX'){:1344};
{1346:}begin undumpint(x);
if(x<0)or(x>3)then goto 6666 else interaction:=x;end;
if interactionoption<>4 then interaction:=interactionoption;
begin undumpint(x);
if(x<0)or(x>strptr)then goto 6666 else formatident:=x;end;undumpint(x);
if x<>69069 then goto 6666{:1346};loadfmtfile:=true;goto 10;6666:;
writeln(stdout,'(Fatal format file error; I''m stymied)');
loadfmtfile:=false;10:end;
{:1322}{1349:}{1352:}procedure closefilesandterminate;var k:integer;
begin{1397:}for k:=0 to 15 do if writeopen[k]then aclose(writefile[k])
{:1397};
ifdef('STAT')if eqtb[28962].int>0 then{1353:}if logopened then begin
writeln(logfile,' ');
writeln(logfile,'Here is how much of TeX''s memory',' you used:');
write(logfile,' ',strptr-initstrptr:1,' string');
if strptr<>initstrptr+1 then write(logfile,'s');
writeln(logfile,' out of ',maxstrings-initstrptr:1);
writeln(logfile,' ',poolptr-initpoolptr:1,' string characters out of ',
poolsize-initpoolptr:1);
writeln(logfile,' ',lomemmax-memmin+memend-himemmin+2:1,
' words of memory out of ',memend+1-memmin:1);
writeln(logfile,' ',cscount:1,' multiletter control sequences out of ',
15000:1,'+',hashextra:1);
write(logfile,' ',fmemptr:1,' words of font info for ',fontptr-0:1,
' font');if fontptr<>1 then write(logfile,'s');
writeln(logfile,', out of ',fontmemsize:1,' for ',fontmax-0:1);
write(logfile,' ',hyphcount:1,' hyphenation exception');
if hyphcount<>1 then write(logfile,'s');
writeln(logfile,' out of ',hyphsize:1);
writeln(logfile,' ',maxinstack:1,'i,',maxneststack:1,'n,',maxparamstack:
1,'p,',maxbufstack+1:1,'b,',maxsavestack+6:1,'s stack positions out of '
,stacksize:1,'i,',nestsize:1,'n,',paramsize:1,'p,',bufsize:1,'b,',
savesize:1,'s');end{:1353};endif('STAT');
{659:}while curs>-1 do begin if curs>0 then begin dvibuf[dviptr]:=142;
incr(dviptr);if dviptr=dvilimit then dviswap;
end else begin begin dvibuf[dviptr]:=140;incr(dviptr);
if dviptr=dvilimit then dviswap;end;incr(totalpages);end;decr(curs);end;
if totalpages=0 then printnl(930)else if curs<>-2 then begin begin
dvibuf[dviptr]:=248;incr(dviptr);if dviptr=dvilimit then dviswap;end;
dvifour(lastbop);lastbop:=dvioffset+dviptr-5;dvifour(25400000);
dvifour(473628672);preparemag;dvifour(eqtb[28948].int);dvifour(maxv);
dvifour(maxh);begin dvibuf[dviptr]:=maxpush div 256;incr(dviptr);
if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=maxpush mod 256;incr(dviptr);
if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=(totalpages div 256)mod 256;incr(dviptr);
if dviptr=dvilimit then dviswap;end;
begin dvibuf[dviptr]:=totalpages mod 256;incr(dviptr);
if dviptr=dvilimit then dviswap;end;
{660:}while fontptr>0 do begin if fontused[fontptr]then dvifontdef(
fontptr);decr(fontptr);end{:660};begin dvibuf[dviptr]:=249;incr(dviptr);
if dviptr=dvilimit then dviswap;end;dvifour(lastbop);
if dirused then begin dvibuf[dviptr]:=3;incr(dviptr);
if dviptr=dvilimit then dviswap;end else begin dvibuf[dviptr]:=2;
incr(dviptr);if dviptr=dvilimit then dviswap;end;
ifdef('IPC')k:=7-((3+dvioffset+dviptr)mod 4);
endif('IPC')ifndef('IPC')k:=4+((dvibufsize-dviptr)mod 4);
endifn('IPC')while k>0 do begin begin dvibuf[dviptr]:=223;incr(dviptr);
if dviptr=dvilimit then dviswap;end;decr(k);end;
{616:}if dvilimit=halfbuf then writedvi(halfbuf,dvibufsize-1);
if dviptr>(2147483647-dvioffset)then begin curs:=-2;fatalerror(919);end;
if dviptr>0 then writedvi(0,dviptr-1){:616};printnl(931);
printfilename(0,outputfilename,0);print(285);printint(totalpages);
if totalpages<>1 then print(932)else print(933);print(380);
printint(dvioffset+dviptr);print(934);bclose(dvifile);end{:659};
{1662:}synctexterminate(logopened);{:1662};
if logopened then begin writeln(logfile);aclose(logfile);
selector:=selector-2;if selector=17 then begin printnl(1411);
printfilename(0,texmflogname,0);printchar(46);end;end;println;
if(editnamestart<>0)and(interaction>0)then calledit(strpool,
editnamestart,editnamelength,editline);end;
{:1352}{1354:}procedure finalcleanup;label 10;var c:smallnumber;
begin c:=curchr;if jobname=0 then openlogfile;
while inputptr>0 do if curinput.statefield=0 then endtokenlist else
endfilereading;while openparens>0 do begin print(1412);decr(openparens);
end;if curlevel>1 then begin printnl(40);printesc(1413);print(1414);
printint(curlevel-1);printchar(41);if(eTeXmode=1)then showsavegroups;
end;while condptr<>-268435455 do begin printnl(40);printesc(1413);
print(1415);printcmdchr(117,curif);if ifline<>0 then begin print(1416);
printint(ifline);end;print(1417);ifline:=mem[condptr+1].int;
curif:=mem[condptr].hh.b1;tempptr:=condptr;condptr:=mem[condptr].hh.rh;
freenode(tempptr,2);end;
if history<>0 then if((history=1)or(interaction<3))then if selector=19
then begin selector:=17;printnl(1418);selector:=19;end;
if c=1 then begin ifdef('INITEX')if iniversion then begin for c:=0 to 4
do if curmark[c]<>-268435455 then deletetokenref(curmark[c]);
if saroot[6]<>-268435455 then if domarks(3,0,saroot[6])then saroot[6]:=
-268435455;for c:=2 to 3 do flushnodelist(discptr[c]);
if lastglue<>268435455 then deleteglueref(lastglue);storefmtfile;
goto 10;end;endif('INITEX')printnl(1419);goto 10;end;10:end;
{:1354}{1355:}ifdef('INITEX')procedure initprim;
begin nonewcontrolsequence:=false;first:=0;
{232:}primitive(394,81,24528);primitive(395,81,24529);
primitive(396,81,24530);primitive(397,81,24531);primitive(398,81,24532);
primitive(399,81,24533);primitive(400,81,24534);primitive(401,81,24535);
primitive(402,81,24536);primitive(403,81,24537);primitive(404,81,24538);
primitive(405,81,24539);primitive(406,81,24540);primitive(407,81,24541);
primitive(408,81,24542);primitive(409,82,24545);primitive(410,82,24546);
primitive(411,82,24547);primitive(412,81,24543);primitive(413,81,24544);
{:232}{236:}primitive(419,78,25062);primitive(420,78,25063);
primitive(421,78,25064);primitive(422,78,25065);primitive(423,78,25066);
primitive(424,78,25067);primitive(425,78,25068);primitive(426,78,25069);
primitive(427,78,25070);{:236}{244:}primitive(446,79,28931);
primitive(447,79,28932);primitive(448,79,28933);primitive(449,79,28934);
primitive(450,79,28935);primitive(451,79,28936);primitive(452,79,28937);
primitive(453,79,28938);primitive(454,79,28939);primitive(455,79,28940);
primitive(456,79,28941);primitive(457,79,28942);primitive(458,79,28943);
primitive(459,79,28944);primitive(460,79,28945);primitive(461,79,28946);
primitive(462,79,28947);primitive(463,79,28948);primitive(464,79,28949);
primitive(465,79,28950);primitive(466,79,28951);primitive(467,79,28952);
primitive(468,79,28953);primitive(469,79,28954);primitive(470,79,28955);
primitive(471,79,28956);primitive(472,79,28957);primitive(473,79,28958);
primitive(474,79,28959);primitive(475,79,28960);primitive(476,79,28961);
primitive(477,79,28962);primitive(478,79,28963);primitive(479,79,28964);
primitive(480,79,28965);primitive(481,79,28966);primitive(482,79,28967);
primitive(483,79,28968);primitive(484,79,28969);primitive(485,79,28970);
primitive(486,79,28971);primitive(487,79,28972);primitive(488,79,28973);
primitive(489,79,28974);primitive(490,79,28975);primitive(491,79,28977);
primitive(492,79,28978);primitive(493,79,28979);primitive(494,79,28980);
primitive(495,79,28981);primitive(496,79,28976);primitive(497,79,28987);
primitive(498,79,28982);primitive(499,79,28983);primitive(500,79,28984);
primitive(501,79,28985);primitive(502,79,28986);
if mltexp then begin mltexenabledp:=true;
if false then primitive(503,79,28988);primitive(504,79,28989);
primitive(505,79,28990);end;{:244}{254:}primitive(509,80,29514);
primitive(510,80,29515);primitive(511,80,29516);primitive(512,80,29517);
primitive(513,80,29518);primitive(514,80,29519);primitive(515,80,29520);
primitive(516,80,29521);primitive(517,80,29522);primitive(518,80,29523);
primitive(519,80,29524);primitive(520,80,29525);primitive(521,80,29526);
primitive(522,80,29527);primitive(523,80,29528);primitive(524,80,29529);
primitive(525,80,29530);primitive(526,80,29531);primitive(527,80,29532);
primitive(528,80,29533);primitive(529,80,29535);primitive(530,80,29536);
primitive(531,80,29534);{:254}{275:}primitive(32,67,0);
primitive(47,47,0);primitive(546,48,0);primitive(547,101,0);
primitive(548,43,0);primitive(549,44,0);primitive(550,64,0);
primitive(551,19,0);primitive(542,119,0);primitive(552,15,0);
primitive(553,15,1);primitive(554,103,0);primitive(543,70,0);
primitive(555,65,0);hash[15516].rh:=555;eqtb[15516]:=eqtb[curval];
primitive(556,114,0);primitive(557,97,0);primitive(558,98,0);
primitive(559,99,0);primitive(560,83,0);primitive(561,35,0);
primitive(562,39,0);primitive(563,42,0);primitive(335,40,0);
primitive(360,21,0);primitive(564,49,0);primitive(565,20,0);
primitive(566,49,1);primitive(567,20,1);primitive(568,57,0);
primitive(569,102,0);primitive(570,37,0);primitive(571,68,0);
primitive(572,115,0);primitive(340,58,0);primitive(573,66,0);
primitive(574,93,25061);primitive(575,45,0);primitive(576,89,0);
primitive(577,69,0);primitive(578,69,1);primitive(579,107,0);
primitive(580,0,256);hash[15521].rh:=580;eqtb[15521]:=eqtb[curval];
primitive(581,109,0);primitive(582,121,0);primitive(428,77,membot);
primitive(361,41,0);primitive(583,36,0);primitive(584,59,0);
primitive(585,38,0);{:275}{344:}primitive(647,13,256);parloc:=curval;
partoken:=65535+parloc;{:344}{393:}primitive(685,116,0);
primitive(686,116,1);{:393}{401:}primitive(687,122,0);
primitive(688,122,1);primitive(689,122,2);primitive(690,122,3);
primitive(691,122,4);{:401}{428:}primitive(507,100,membot+0);
primitive(535,100,membot+1);primitive(416,100,membot+2);
primitive(417,100,membot+3);{:428}{433:}primitive(729,88,114);
primitive(730,88,1);primitive(731,91,0);primitive(732,91,1);
primitive(733,92,1);primitive(734,92,3);primitive(735,92,2);
primitive(736,74,0);primitive(737,74,1);primitive(738,74,2);
primitive(739,74,5);primitive(740,74,6);
{:433}{485:}primitive(801,120,0);primitive(802,120,1);
primitive(803,120,3);primitive(804,120,4);primitive(805,120,5);
primitive(806,120,2);primitive(807,120,6);primitive(808,120,7);
primitive(809,120,8);primitive(810,120,9);primitive(811,120,17);
{:485}{504:}primitive(841,117,0);primitive(842,117,1);
primitive(843,117,2);primitive(844,117,3);primitive(845,117,4);
primitive(846,117,5);primitive(847,117,6);primitive(848,117,7);
primitive(849,117,8);primitive(850,117,9);primitive(851,117,10);
primitive(852,117,11);primitive(853,117,12);primitive(854,117,13);
primitive(855,117,14);primitive(856,117,15);primitive(857,117,16);
primitive(858,117,20);primitive(859,117,21);primitive(860,117,22);
primitive(861,117,23);primitive(862,117,24);primitive(863,117,25);
primitive(864,117,26);{:504}{508:}primitive(315,118,2);
hash[15518].rh:=315;eqtb[15518]:=eqtb[curval];primitive(867,118,4);
primitive(868,118,3);{:508}{570:}primitive(893,96,0);
hash[15526].rh:=893;eqtb[15526]:=eqtb[curval];
{:570}{797:}primitive(993,4,256);primitive(994,5,257);
hash[15515].rh:=994;eqtb[15515]:=eqtb[curval];primitive(995,5,258);
hash[15519].rh:=996;hash[15520].rh:=996;eqtb[15520].hh.b0:=9;
eqtb[15520].hh.rh:=memtop-11;eqtb[15520].hh.b1:=1;
eqtb[15519]:=eqtb[15520];eqtb[15519].hh.b0:=127;
{:797}{1000:}primitive(1065,90,0);primitive(1066,90,1);
primitive(1067,90,2);primitive(1068,90,3);primitive(1069,90,4);
primitive(1070,90,5);primitive(1071,90,6);primitive(1072,90,7);
primitive(1073,90,8);{:1000}{1070:}primitive(348,14,0);
primitive(1123,14,1);{:1070}{1076:}primitive(1124,29,5);
primitive(1125,29,0);primitive(1126,29,1);primitive(1127,29,2);
primitive(1128,29,3);primitive(1129,29,4);primitive(1130,30,5);
primitive(1131,30,0);primitive(1132,30,1);primitive(1133,30,2);
primitive(1134,30,3);primitive(1135,30,4);primitive(341,31,6);
primitive(345,32,1);primitive(347,33,99);
{:1076}{1089:}primitive(1153,24,1);primitive(1154,24,0);
primitive(1155,25,1);primitive(1156,25,0);primitive(430,23,0);
primitive(1157,23,1);primitive(1158,23,2);primitive(1060,23,3);
primitive(1159,23,4);primitive(1062,23,5);primitive(1160,23,118);
primitive(1161,76,3);primitive(1162,76,4);primitive(1163,76,1);
primitive(1164,34,99);primitive(1165,34,100);primitive(1166,34,101);
primitive(1167,34,102);{:1089}{1106:}primitive(1194,46,1);
primitive(1195,46,0);{:1106}{1125:}primitive(1206,28,14);
primitive(1207,28,13);primitive(1208,28,12);primitive(1209,26,0);
primitive(1210,26,1);primitive(1211,27,0);primitive(1212,27,1);
{:1125}{1132:}primitive(45,50,1);primitive(358,50,0);
{:1132}{1159:}primitive(1245,51,0);primitive(1246,51,1);
{:1159}{1174:}primitive(959,53,18);primitive(960,53,19);
primitive(961,53,20);primitive(962,53,21);primitive(963,53,22);
primitive(964,53,23);primitive(965,53,24);primitive(966,53,25);
primitive(968,53,28);primitive(967,53,29);primitive(1250,54,0);
primitive(972,54,1);primitive(973,54,2);
{:1174}{1187:}primitive(954,56,0);primitive(955,56,2);
primitive(956,56,4);primitive(957,56,6);
{:1187}{1196:}primitive(1268,55,0);primitive(1269,55,1);
primitive(1270,55,2);primitive(1271,55,3);primitive(1272,55,4);
primitive(1273,55,5);{:1196}{1206:}primitive(969,52,32);
primitive(970,52,33);hash[15517].rh:=970;eqtb[15517]:=eqtb[curval];
{:1206}{1226:}primitive(1293,104,1);primitive(1294,104,2);
primitive(1295,104,4);primitive(1296,108,0);primitive(1297,108,1);
primitive(1298,108,2);primitive(1299,108,3);
{:1226}{1237:}primitive(1316,105,0);primitive(1317,105,1);
{:1237}{1240:}primitive(1318,106,0);primitive(1319,106,1);
primitive(1320,106,2);primitive(1321,106,3);primitive(1322,106,4);
primitive(1323,106,5);primitive(1324,106,6);primitive(1325,106,7);
if mltexp then begin primitive(1326,106,8);end;
{:1240}{1248:}primitive(436,94,26361);primitive(437,94,26617);
primitive(438,94,26873);primitive(445,94,28419);
primitive(1331,94,28547);primitive(442,94,27651);
primitive(443,94,27907);primitive(444,94,28163);primitive(508,94,29258);
primitive(1332,94,29386);primitive(433,95,25589);
primitive(434,95,25845);primitive(435,95,26101);
{:1248}{1269:}primitive(1036,110,0);primitive(1048,110,1);
{:1269}{1273:}primitive(1351,84,0);primitive(1352,84,1);
{:1273}{1281:}primitive(273,111,0);primitive(274,111,1);
primitive(275,111,2);primitive(1361,111,3);
{:1281}{1291:}primitive(1362,63,1);primitive(1363,63,0);
{:1291}{1296:}primitive(1364,61,0);primitive(1365,61,1);
{:1296}{1305:}primitive(1371,60,27651);primitive(1372,60,27907);
{:1305}{1310:}primitive(1373,22,0);primitive(1374,22,1);
primitive(1375,22,2);primitive(1376,22,3);primitive(1377,22,7);
{:1310}{1363:}primitive(1421,62,0);primitive(644,62,1);writeloc:=curval;
primitive(1422,62,2);primitive(1423,62,3);hash[15524].rh:=1423;
eqtb[15524]:=eqtb[curval];primitive(1424,62,4);primitive(1425,62,5);
{:1363}{1649:}primitive(1559,79,28991);
{:1649}{1685:}primitive(441,87,0);{:1685}{1690:}primitive(1563,112,1);
primitive(1564,112,0);primitive(1565,112,3);primitive(1566,112,2);
{:1690}{1697:}primitive(1575,75,0);primitive(1576,86,27129);
{:1697}{1702:}primitive(1579,85,1);primitive(1580,85,2);{:1702};
nonewcontrolsequence:=true;end;
endif('INITEX'){:1355}{1357:}ifdef('TEXMF_DEBUG')procedure debughelp;
label 888,10;var k,l,m,n:integer;begin while true do begin;
printnl(1420);fflush(stdout);read(stdin,m);
if m<0 then goto 10 else if m=0 then dumpcore else begin read(stdin,n);
case m of{1358:}1:printword(mem[n]);2:printint(mem[n].hh.lh);
3:printint(mem[n].hh.rh);4:printword(eqtb[n]);
5:begin printscaled(fontinfo[n].int);printchar(32);
printint(fontinfo[n].qqqq.b0);printchar(58);
printint(fontinfo[n].qqqq.b1);printchar(58);
printint(fontinfo[n].qqqq.b2);printchar(58);
printint(fontinfo[n].qqqq.b3);end;6:printword(savestack[n]);
7:showbox(n);8:begin breadthmax:=10000;
depththreshold:=poolsize-poolptr-10;shownodelist(n);end;
9:showtokenlist(n,-268435455,1000);10:slowprint(n);11:checkmem(n>0);
12:searchmem(n);13:begin read(stdin,l);printcmdchr(n,l);end;
14:for k:=0 to n do print(buffer[k]);15:begin fontinshortdisplay:=0;
shortdisplay(n);end;16:panicking:=not panicking;
{:1358}others:print(63)end;end;end;10:end;
endif('TEXMF_DEBUG'){:1357}{:1349}{1351:}procedure mainbody;
begin bounddefault:=0;boundname:='mem_bot';
setupboundvariable(addressof(membot),boundname,bounddefault);
bounddefault:=250000;boundname:='main_memory';
setupboundvariable(addressof(mainmemory),boundname,bounddefault);
bounddefault:=0;boundname:='extra_mem_top';
setupboundvariable(addressof(extramemtop),boundname,bounddefault);
bounddefault:=0;boundname:='extra_mem_bot';
setupboundvariable(addressof(extramembot),boundname,bounddefault);
bounddefault:=200000;boundname:='pool_size';
setupboundvariable(addressof(poolsize),boundname,bounddefault);
bounddefault:=75000;boundname:='string_vacancies';
setupboundvariable(addressof(stringvacancies),boundname,bounddefault);
bounddefault:=5000;boundname:='pool_free';
setupboundvariable(addressof(poolfree),boundname,bounddefault);
bounddefault:=15000;boundname:='max_strings';
setupboundvariable(addressof(maxstrings),boundname,bounddefault);
bounddefault:=100;boundname:='strings_free';
setupboundvariable(addressof(stringsfree),boundname,bounddefault);
bounddefault:=100000;boundname:='font_mem_size';
setupboundvariable(addressof(fontmemsize),boundname,bounddefault);
bounddefault:=500;boundname:='font_max';
setupboundvariable(addressof(fontmax),boundname,bounddefault);
bounddefault:=20000;boundname:='trie_size';
setupboundvariable(addressof(triesize),boundname,bounddefault);
bounddefault:=659;boundname:='hyph_size';
setupboundvariable(addressof(hyphsize),boundname,bounddefault);
bounddefault:=3000;boundname:='buf_size';
setupboundvariable(addressof(bufsize),boundname,bounddefault);
bounddefault:=50;boundname:='nest_size';
setupboundvariable(addressof(nestsize),boundname,bounddefault);
bounddefault:=15;boundname:='max_in_open';
setupboundvariable(addressof(maxinopen),boundname,bounddefault);
bounddefault:=60;boundname:='param_size';
setupboundvariable(addressof(paramsize),boundname,bounddefault);
bounddefault:=4000;boundname:='save_size';
setupboundvariable(addressof(savesize),boundname,bounddefault);
bounddefault:=300;boundname:='stack_size';
setupboundvariable(addressof(stacksize),boundname,bounddefault);
bounddefault:=16384;boundname:='dvi_buf_size';
setupboundvariable(addressof(dvibufsize),boundname,bounddefault);
bounddefault:=79;boundname:='error_line';
setupboundvariable(addressof(errorline),boundname,bounddefault);
bounddefault:=50;boundname:='half_error_line';
setupboundvariable(addressof(halferrorline),boundname,bounddefault);
bounddefault:=79;boundname:='max_print_line';
setupboundvariable(addressof(maxprintline),boundname,bounddefault);
bounddefault:=0;boundname:='hash_extra';
setupboundvariable(addressof(hashextra),boundname,bounddefault);
bounddefault:=10000;boundname:='expand_depth';
setupboundvariable(addressof(expanddepth),boundname,bounddefault);
begin if membot<infmembot then membot:=infmembot else if membot>
supmembot then membot:=supmembot end;
begin if mainmemory<infmainmemory then mainmemory:=infmainmemory else if
mainmemory>supmainmemory then mainmemory:=supmainmemory end;
ifdef('INITEX')if iniversion then begin extramemtop:=0;extramembot:=0;
end;endif('INITEX')if extramembot>supmainmemory then extramembot:=
supmainmemory;
if extramemtop>supmainmemory then extramemtop:=supmainmemory;
memtop:=membot+mainmemory-1;memmin:=membot;memmax:=memtop;
begin if triesize<inftriesize then triesize:=inftriesize else if
triesize>suptriesize then triesize:=suptriesize end;
begin if hyphsize<infhyphsize then hyphsize:=infhyphsize else if
hyphsize>suphyphsize then hyphsize:=suphyphsize end;
begin if bufsize<infbufsize then bufsize:=infbufsize else if bufsize>
supbufsize then bufsize:=supbufsize end;
begin if nestsize<infnestsize then nestsize:=infnestsize else if
nestsize>supnestsize then nestsize:=supnestsize end;
begin if maxinopen<infmaxinopen then maxinopen:=infmaxinopen else if
maxinopen>supmaxinopen then maxinopen:=supmaxinopen end;
begin if paramsize<infparamsize then paramsize:=infparamsize else if
paramsize>supparamsize then paramsize:=supparamsize end;
begin if savesize<infsavesize then savesize:=infsavesize else if
savesize>supsavesize then savesize:=supsavesize end;
begin if stacksize<infstacksize then stacksize:=infstacksize else if
stacksize>supstacksize then stacksize:=supstacksize end;
begin if dvibufsize<infdvibufsize then dvibufsize:=infdvibufsize else if
dvibufsize>supdvibufsize then dvibufsize:=supdvibufsize end;
begin if poolsize<infpoolsize then poolsize:=infpoolsize else if
poolsize>suppoolsize then poolsize:=suppoolsize end;
begin if stringvacancies<infstringvacancies then stringvacancies:=
infstringvacancies else if stringvacancies>supstringvacancies then
stringvacancies:=supstringvacancies end;
begin if poolfree<infpoolfree then poolfree:=infpoolfree else if
poolfree>suppoolfree then poolfree:=suppoolfree end;
begin if maxstrings<infmaxstrings then maxstrings:=infmaxstrings else if
maxstrings>supmaxstrings then maxstrings:=supmaxstrings end;
begin if stringsfree<infstringsfree then stringsfree:=infstringsfree
else if stringsfree>supstringsfree then stringsfree:=supstringsfree end;
begin if fontmemsize<inffontmemsize then fontmemsize:=inffontmemsize
else if fontmemsize>supfontmemsize then fontmemsize:=supfontmemsize end;
begin if fontmax<inffontmax then fontmax:=inffontmax else if fontmax>
supfontmax then fontmax:=supfontmax end;
begin if hashextra<infhashextra then hashextra:=infhashextra else if
hashextra>suphashextra then hashextra:=suphashextra end;
if errorline>255 then errorline:=255;
buffer:=xmallocarray(ASCIIcode,bufsize);
nest:=xmallocarray(liststaterecord,nestsize);
savestack:=xmallocarray(memoryword,savesize);
inputstack:=xmallocarray(instaterecord,stacksize);
inputfile:=xmallocarray(alphafile,maxinopen);
linestack:=xmallocarray(integer,maxinopen);
eofseen:=xmallocarray(boolean,maxinopen);
grpstack:=xmallocarray(savepointer,maxinopen);
ifstack:=xmallocarray(halfword,maxinopen);
sourcefilenamestack:=xmallocarray(strnumber,maxinopen);
fullsourcefilenamestack:=xmallocarray(strnumber,maxinopen);
paramstack:=xmallocarray(halfword,paramsize);
dvibuf:=xmallocarray(eightbits,dvibufsize);
hyphword:=xmallocarray(strnumber,hyphsize);
hyphlist:=xmallocarray(halfword,hyphsize);
hyphlink:=xmallocarray(hyphpointer,hyphsize);
ifdef('INITEX')if iniversion then begin yzmem:=xmallocarray(memoryword,
memtop-membot+1);zmem:=yzmem-membot;eqtbtop:=30050+hashextra;
if hashextra=0 then hashtop:=24527 else hashtop:=eqtbtop;
yhash:=xmallocarray(twohalves,1+hashtop-hashoffset);
hash:=yhash-hashoffset;hash[514].lh:=0;hash[514].rh:=0;
for hashused:=515 to hashtop do hash[hashused]:=hash[514];
zeqtb:=xmallocarray(memoryword,eqtbtop);eqtb:=zeqtb;
strstart:=xmallocarray(poolpointer,maxstrings);
strpool:=xmallocarray(packedASCIIcode,poolsize);
fontinfo:=xmallocarray(memoryword,fontmemsize);end;
endif('INITEX')history:=3;;if readyalready=314159 then goto 1;
{14:}bad:=0;
if(halferrorline<30)or(halferrorline>errorline-15)then bad:=1;
if maxprintline<60 then bad:=2;if dvibufsize mod 8<>0 then bad:=3;
if membot+1100>memtop then bad:=4;if 8501>15000 then bad:=5;
if maxinopen>=128 then bad:=6;if memtop<267 then bad:=7;
{:14}{112:}ifdef('INITEX')if(memmin<>membot)or(memmax<>memtop)then bad:=
10;endif('INITEX')if(memmin>membot)or(memmax<memtop)then bad:=10;
if(0>0)or(65535<127)then bad:=11;
if(-268435455>0)or(268435455<32767)then bad:=12;
if(0<-268435455)or(65535>268435455)then bad:=13;
if(membot-supmainmemory<-268435455)or(memtop+supmainmemory>=268435455)or
(0<>0)then bad:=14;if(9000<-268435455)or(9000>268435455)then bad:=15;
if fontmax>9000 then bad:=16;
if(savesize>268435455)or(maxstrings>268435455)then bad:=17;
if bufsize>268435455 then bad:=18;if 65535<255 then bad:=19;
{:112}{300:}if 95585+hashextra>268435455 then bad:=21;
if(hashoffset<0)or(hashoffset>514)then bad:=42;
{:300}{539:}if formatdefaultlength>maxint then bad:=31;
{:539}{1268:}if 2*268435455<memtop-memmin then bad:=41;
{:1268}if bad>0 then begin writeln(stdout,
'Ouch---my internal constants have been clobbered!','---case ',bad:1);
goto 9999;end;initialize;
ifdef('INITEX')if iniversion then begin if not getstringsstarted then
goto 9999;initprim;initstrptr:=strptr;initpoolptr:=poolptr;
dateandtime(eqtb[28951].int,eqtb[28952].int,eqtb[28953].int,eqtb[28954].
int);end;endif('INITEX')readyalready:=314159;1:{56:}selector:=17;
tally:=0;termoffset:=0;fileoffset:=0;kcodepos:=0;
{:56}{62:}if srcspecialsp or filelineerrorstylep or parsefirstlinep then
write(stdout,'This is e-pTeX, Version 3.14159265','-p3.7','-150805',
'-2.6')else write(stdout,'This is e-pTeX, Version 3.14159265','-p3.7',
'-150805','-2.6');write(stdout,' (');
write(stdout,conststringcast(getencstring));write(stdout,')');
write(stdout,versionstring);
if formatident=0 then writeln(stdout,' (preloaded format=',dumpname,')')
else begin slowprint(formatident);println;end;
if shellenabledp then begin write(stdout,' ');
if restrictedshell then begin write(stdout,'restricted ');end;
writeln(stdout,'\write18 enabled.');end;
if srcspecialsp then begin writeln(stdout,' Source specials enabled.')
end;if translatefilename then begin write(stdout,' (');
fputs(translatefilename,stdout);writeln(stdout,')');end;fflush(stdout);
{:62}{545:}jobname:=0;nameinprogress:=false;logopened:=false;
{:545}{550:}outputfilename:=0;{:550};
{1356:}begin{341:}begin inputptr:=0;maxinstack:=0;
sourcefilenamestack[0]:=0;fullsourcefilenamestack[0]:=0;inopen:=0;
openparens:=0;maxbufstack:=0;grpstack[0]:=0;ifstack[0]:=-268435455;
paramptr:=0;maxparamstack:=0;first:=bufsize;repeat buffer[first]:=0;
decr(first);until first=0;scannerstatus:=0;warningindex:=-268435455;
first:=1;curinput.statefield:=58;curinput.startfield:=1;
curinput.indexfield:=0;line:=0;curinput.namefield:=0;forceeof:=false;
alignstate:=1000000;if not initterminal then goto 9999;
curinput.limitfield:=last;first:=last+1;end{:341};
{1398:}ifdef('INITEX')if(etexp or(buffer[curinput.locfield]=42))and(
formatident=1390)then begin nonewcontrolsequence:=false;
{1399:}primitive(1448,74,3);primitive(1449,74,4);primitive(1450,74,10);
primitive(812,120,10);primitive(539,115,1);primitive(813,120,11);
primitive(814,120,12);primitive(815,120,13);primitive(816,120,14);
primitive(817,120,15);primitive(818,120,16);primitive(1426,62,6);
primitive(532,80,29537);primitive(533,80,29538);primitive(1451,74,7);
primitive(1452,74,8);primitive(1453,74,9);primitive(866,117,27);
{:1399}{1407:}primitive(1455,78,25071);primitive(1456,79,28992);
primitive(1457,79,28993);primitive(1458,79,28994);
primitive(1459,79,28995);primitive(1460,79,28996);
primitive(1461,79,28997);primitive(1462,79,28998);
primitive(1463,79,28999);primitive(1464,79,29000);
{:1407}{1413:}primitive(1479,74,11);primitive(1480,74,12);
{:1413}{1416:}primitive(1481,74,13);primitive(1482,74,14);
primitive(1483,74,15);{:1416}{1419:}primitive(1484,74,18);
primitive(1485,74,19);primitive(1486,74,20);primitive(1487,74,21);
{:1419}{1422:}primitive(1488,74,22);primitive(1489,74,23);
primitive(1490,74,24);{:1422}{1425:}primitive(1491,22,4);
{:1425}{1434:}primitive(1493,22,5);{:1434}{1436:}primitive(1494,121,1);
primitive(1495,121,5);{:1436}{1439:}primitive(1496,22,6);
{:1439}{1442:}primitive(1500,91,2);{:1442}{1447:}primitive(971,52,1);
{:1447}{1451:}primitive(1504,79,29001);primitive(1505,36,6);
primitive(1506,36,7);primitive(1507,36,10);primitive(1508,36,11);
{:1451}{1501:}primitive(1517,116,2);{:1501}{1513:}primitive(1519,107,1);
{:1513}{1516:}primitive(865,114,1);primitive(1520,117,17);
primitive(1521,117,18);primitive(1522,117,19);
{:1516}{1524:}primitive(1307,104,8);{:1524}{1532:}primitive(1528,74,29);
primitive(1529,74,30);primitive(1530,74,31);primitive(1531,74,32);
{:1532}{1555:}primitive(1535,74,16);primitive(1536,74,17);
primitive(1537,74,25);primitive(1538,74,26);
{:1555}{1559:}primitive(1539,74,27);primitive(1540,74,28);
{:1559}{1563:}primitive(1541,21,5);primitive(1542,122,5);
primitive(1543,122,6);primitive(1544,122,7);primitive(1545,122,8);
primitive(1546,122,9);{:1563}{1615:}primitive(1550,27,2);
primitive(1551,27,3);{:1615}{1618:}primitive(1552,93,25328);
primitive(1553,93,25329);primitive(1554,93,25330);
primitive(1555,93,25331);
{:1618}if(buffer[curinput.locfield]=42)then incr(curinput.locfield);
eTeXmode:=1;{1567:}maxregnum:=65535;maxreghelpline:=1547;{:1567}end;
endif('INITEX')if not nonewcontrolsequence then nonewcontrolsequence:=
true else{:1398}if(formatident=0)or(buffer[curinput.locfield]=38)or
dumpline then begin if formatident<>0 then initialize;
if not openfmtfile then goto 9999;
if not loadfmtfile then begin wclose(fmtfile);goto 9999;end;
wclose(fmtfile);eqtb:=zeqtb;
while(curinput.locfield<curinput.limitfield)and(buffer[curinput.locfield
]=32)do incr(curinput.locfield);end;
if(eTeXmode=1)then writeln(stdout,'entering extended mode');
if(eqtb[28980].int<0)or(eqtb[28980].int>255)then decr(curinput.
limitfield)else buffer[curinput.limitfield]:=eqtb[28980].int;
if mltexenabledp then begin writeln(stdout,'MLTeX v2.2 enabled');end;
dateandtime(eqtb[28951].int,eqtb[28952].int,eqtb[28953].int,eqtb[28954].
int);isprintutf8:=false;
ifdef('INITEX')if trienotready then begin trietrl:=xmallocarray(
triepointer,triesize);trietro:=xmallocarray(triepointer,triesize);
trietrc:=xmallocarray(quarterword,triesize);
triec:=xmallocarray(packedASCIIcode,triesize);
trieo:=xmallocarray(trieopcode,triesize);
triel:=xmallocarray(triepointer,triesize);
trier:=xmallocarray(triepointer,triesize);
triehash:=xmallocarray(triepointer,triesize);
trietaken:=xmallocarray(boolean,triesize);triel[0]:=0;triec[0]:=0;
trieptr:=0;trier[0]:=0;hyphstart:=0;
fontdir:=xmallocarray(eightbits,fontmax);
fontnumext:=xmallocarray(integer,fontmax);
fontcheck:=xmallocarray(fourquarters,fontmax);
fontsize:=xmallocarray(scaled,fontmax);
fontdsize:=xmallocarray(scaled,fontmax);
fontparams:=xmallocarray(fontindex,fontmax);
fontname:=xmallocarray(strnumber,fontmax);
fontarea:=xmallocarray(strnumber,fontmax);
fontbc:=xmallocarray(eightbits,fontmax);
fontec:=xmallocarray(eightbits,fontmax);
fontglue:=xmallocarray(halfword,fontmax);
hyphenchar:=xmallocarray(integer,fontmax);
skewchar:=xmallocarray(integer,fontmax);
bcharlabel:=xmallocarray(fontindex,fontmax);
fontbchar:=xmallocarray(ninebits,fontmax);
fontfalsebchar:=xmallocarray(ninebits,fontmax);
ctypebase:=xmallocarray(integer,fontmax);
charbase:=xmallocarray(integer,fontmax);
widthbase:=xmallocarray(integer,fontmax);
heightbase:=xmallocarray(integer,fontmax);
depthbase:=xmallocarray(integer,fontmax);
italicbase:=xmallocarray(integer,fontmax);
ligkernbase:=xmallocarray(integer,fontmax);
kernbase:=xmallocarray(integer,fontmax);
extenbase:=xmallocarray(integer,fontmax);
parambase:=xmallocarray(integer,fontmax);fontptr:=0;fmemptr:=7;
fontdir[0]:=0;fontnumext[0]:=0;fontname[0]:=893;fontarea[0]:=343;
hyphenchar[0]:=45;skewchar[0]:=-1;bcharlabel[0]:=0;fontbchar[0]:=256;
fontfalsebchar[0]:=256;fontbc[0]:=1;fontec[0]:=0;fontsize[0]:=0;
fontdsize[0]:=0;ctypebase[0]:=0;charbase[0]:=0;widthbase[0]:=0;
heightbase[0]:=0;depthbase[0]:=0;italicbase[0]:=0;ligkernbase[0]:=0;
kernbase[0]:=0;extenbase[0]:=0;fontglue[0]:=-268435455;fontparams[0]:=7;
parambase[0]:=-1;for fontk:=0 to 6 do fontinfo[fontk].int:=0;end;
endif('INITEX')fontused:=xmallocarray(boolean,fontmax);
for fontk:=0 to fontmax do fontused[fontk]:=false;
{782:}magicoffset:=strstart[987]-9*18{:782};
{76:}if interaction=0 then selector:=16 else selector:=17{:76};
if(curinput.locfield<curinput.limitfield)and(eqtb[26361+buffer[curinput.
locfield]].hh.rh<>0)then startinput;end{:1356};history:=0;
{1654:}synctexinitcommand;{:1654}maincontrol;finalcleanup;
closefilesandterminate;9999:begin fflush(stdout);readyalready:=0;
if(history<>0)and(history<>1)then uexit(1)else uexit(0);end;end;
{:1351}{1752:}function getnullstr:strnumber;begin getnullstr:=343;end;
{:1752}