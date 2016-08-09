{2:}program OVP2OVF(vplfile,vffile,tfmfile,output);const{3:}ofmtype=0;
maxchar=1114111;xmaxchar=1114112;xxmaxchar=1114113;memsize=4456452;
maxfont=1000;xmaxfont=1001;xxmaxfont=1002;maxwidth=65535;maxheight=255;
maxdepth=255;maxitalic=255;bufsize=3000;maxheaderbytes=100;
vfsize=800000;maxstack=100;maxparamwords=100;maxligsteps=800000;
xmaxlabel=800001;hashsize=130003;hashmult=16007;maxkerns=100000;{:3}
{213:}rulearrays=20;ruleentries=200;{:213}{225:}gluearrays=20;
glueentries=200;{:225}{237:}penaltyarrays=20;penaltyentries=200;{:237}
{249:}mvaluearrays=20;mvalueentries=200;{:249}{261:}fvaluearrays=20;
fvalueentries=200;{:261}{273:}ivaluearrays=20;ivalueentries=200;{:273}
type{23:}bytetype=0..65535;ASCIIcode=32..127;{:23}{66:}
fourbytes=record b0:bytetype;b1:bytetype;b2:bytetype;b3:bytetype;end;
{:66}{71:}fixword=integer;unsignedinteger=integer;{:71}{78:}
chartype=0..maxchar;xchartype=0..xmaxchar;xxchartype=0..xxmaxchar;
fonttype=0..maxfont;xfonttype=0..xmaxfont;headerindex=0..maxheaderbytes;
indx=xxchartype;{:78}{81:}pointer=0..memsize;{:81}{214:}
rulearraytype=0..rulearrays;ruleentrytype=0..ruleentries;
rulenode=record rnwidth:fixword;rnheight:fixword;rndepth:fixword;end;
{:214}{226:}gluearraytype=0..gluearrays;glueentrytype=0..glueentries;
gluenode=record gnwidth:fixword;gnstretch:fixword;gnshrink:fixword;
gntype:integer;gnargtype:0..2;gnstretchorder:integer;
gnshrinkorder:integer;gnargument:integer;end;{:226}{238:}
penaltyarraytype=0..penaltyarrays;penaltyentrytype=0..penaltyentries;
penaltynode=record pnval:integer;end;{:238}{250:}
mvaluearraytype=0..mvaluearrays;mvalueentrytype=0..mvalueentries;
mvaluenode=record fnval:fixword;end;{:250}{262:}
fvaluearraytype=0..fvaluearrays;fvalueentrytype=0..fvalueentries;
fvaluenode=record fnval:fixword;end;{:262}{274:}
ivaluearraytype=0..ivaluearrays;ivalueentrytype=0..ivalueentries;
ivaluenode=record inval:integer;end;{:274}var{5:}vplfile:text;{:5}{21:}
vffile:packed file of 0..255;tfmfile:packed file of 0..255;{:21}{24:}
xord:array[0..255]of ASCIIcode;{:24}{27:}line:integer;
goodindent:integer;indent:integer;level:integer;{:27}{29:}
leftln,rightln:boolean;limit:0..bufsize;loc:0..bufsize;
buffer:array[1..bufsize]of 0..255;inputhasended:boolean;{:29}{31:}
charsonline:0..9;perfect:boolean;{:31}{36:}curchar:ASCIIcode;{:36}{44:}
start:array[1..300]of 0..3000;dictionary:array[0..3000]of ASCIIcode;
startptr:0..300;dictptr:0..3000;{:44}{46:}
curname:array[1..20]of ASCIIcode;namelength:0..20;nameptr:0..300;{:46}
{47:}nhash:array[0..306]of 0..300;curhash:0..306;{:47}{52:}
equiv:array[0..300]of bytetype;curcode:bytetype;{:52}{67:}
curbytes:fourbytes;zerobytes:fourbytes;{:67}{75:}
fractiondigits:array[1..7]of integer;{:75}{77:}
headerbytes:array[headerindex]of bytetype;headerptr:headerindex;
designsize:fixword;designunits:fixword;frozendu:boolean;
sevenbitsafeflag:boolean;ligkern:array[0..maxligsteps]of fourbytes;
nl:unsignedinteger;minnl:unsignedinteger;
kern:array[0..maxkerns]of fixword;nk:0..maxkerns;
exten:array[chartype]of fourbytes;ne:xchartype;
param:array[1..maxparamwords]of fixword;np:0..maxparamwords;
checksumspecified:boolean;bchar:xchartype;fontdir:integer;
vf:array[0..vfsize]of bytetype;vfptr:0..vfsize;vtitlestart:0..vfsize;
vtitlelength:bytetype;packetstart:array[chartype]of 0..vfsize;
packetlength:array[chartype]of integer;fontptr:xfonttype;
curfont:xfonttype;fnamestart:array[fonttype]of 0..vfsize;
fnamelength:array[fonttype]of bytetype;
fareastart:array[fonttype]of 0..vfsize;
farealength:array[fonttype]of bytetype;
fontchecksum:array[fonttype]of fourbytes;
fontnumber:array[xfonttype]of integer;fontat:array[fonttype]of fixword;
fontdsize:array[fonttype]of fixword;{:77}{82:}
memory:array[pointer]of fixword;memptr:pointer;
link:array[pointer]of pointer;charwd:array[chartype]of pointer;
charht:array[chartype]of pointer;chardp:array[chartype]of pointer;
charic:array[chartype]of pointer;chartag:array[chartype]of 0..3;
charremainder:array[xchartype]of xchartype;
topwidth,topheight,topdepth,topitalic:integer;{:82}{86:}nextd:fixword;
{:86}{89:}indexvar:array[pointer]of bytetype;excess:bytetype;{:89}{91:}
c:integer;cprime:chartype;crange:chartype;x:fixword;k:integer;{:91}
{113:}lkstepended:boolean;krnptr:0..maxkerns;{:113}{118:}
categoryremainders:array[0..256]of integer;
ivaluecategory,maxivaluecategory:integer;
gluecategory,maxgluecategory:integer;
penaltycategory,maxpenaltycategory:integer;{:118}{125:}
charextendedtag:array[chartype]of boolean;{:125}{128:}
tablesread:boolean;{:128}{131:}charoriginal:array[0..maxchar]of integer;
charrepeats:array[0..maxchar]of integer;diff:boolean;
neededspace,extrabytes:integer;{:131}{134:}
chartable:array[0..maxchar,0..8]of integer;chtable,chentry:integer;
tempvalue:integer;{:134}{140:}HEX:constcstring;{:140}{142:}
dig:array[0..32]of integer;{:142}{147:}hstack:array[0..maxstack]of 0..2;
vstack:array[0..maxstack]of 0..2;
wstack,xstack,ystack,zstack:array[0..maxstack]of fixword;
stackptr:0..maxstack;{:147}{160:}sevenunsafe:boolean;{:160}{165:}
delta:fixword;{:165}{169:}ligptr:0..maxligsteps;
hash:array[0..hashsize]of integer64;classvar:array[0..hashsize]of 0..4;
ligz:array[0..hashsize]of xxchartype;hashptr:0..hashsize;
hashlist:array[0..hashsize]of 0..hashsize;h,hh:0..hashsize;tt:indx;
xligcycle,yligcycle:xchartype;{:169}{180:}bc:chartype;ec:chartype;
lh:chartype;lf:unsignedinteger;notfound:boolean;tempwidth:fixword;
ncw,nco,npc:integer;{:180}{184:}j:0..maxheaderbytes;p:pointer;q:1..4;
parptr:0..maxparamwords;{:184}{187:}tab:integer;{:187}{192:}
labeltable:array[xchartype]of record rr:-1..xmaxlabel;cc:chartype;end;
labelptr:xchartype;sortptr:xchartype;lkoffset:xchartype;t:0..xmaxlabel;
extralocneeded:boolean;{:192}{200:}vcount:integer;{:200}{207:}
ofmlevel:integer;{:207}{215:}
rules:array[rulearraytype,ruleentrytype]of rulenode;
npr:array[rulearraytype]of integer;nkr:integer;nwr:integer;
rarray:integer;rnumber:integer;{:215}{227:}
glues:array[gluearraytype,glueentrytype]of gluenode;
npg:array[gluearraytype]of integer;nkg:integer;nwg:integer;
garray:integer;gbyte:integer;gnumber:integer;{:227}{239:}
penalties:array[penaltyarraytype,penaltyentrytype]of penaltynode;
npp:array[penaltyarraytype]of integer;nkp:integer;nwp:integer;
parray:integer;pnumber:integer;{:239}{251:}
mvalues:array[mvaluearraytype,mvalueentrytype]of mvaluenode;
npm:array[mvaluearraytype]of integer;nkm:integer;nwm:integer;
marray:integer;mnumber:integer;{:251}{263:}
fvalues:array[fvaluearraytype,fvalueentrytype]of fvaluenode;
npf:array[fvaluearraytype]of integer;nkf:integer;nwf:integer;
farray:integer;fnumber:integer;{:263}{275:}
ivalues:array[ivaluearraytype,ivalueentrytype]of ivaluenode;
npi:array[ivaluearraytype]of integer;fontiarray:boolean;nki:integer;
nwi:integer;iarray:integer;inumber:integer;{:275}{291:}verbose:cinttype;
{:291}{294:}vplname,tfmname,vfname:constcstring;{:294}{287:}
procedure parsearguments;const noptions=3;
var longoptions:array[0..noptions]of getoptstruct;
getoptreturnval:integer;optionindex:cinttype;currentoption:0..noptions;
begin{292:}verbose:=false;{:292};{288:}currentoption:=0;
longoptions[currentoption].name:='help';
longoptions[currentoption].hasarg:=0;longoptions[currentoption].flag:=0;
longoptions[currentoption].val:=0;currentoption:=currentoption+1;{:288}
{289:}longoptions[currentoption].name:='version';
longoptions[currentoption].hasarg:=0;longoptions[currentoption].flag:=0;
longoptions[currentoption].val:=0;currentoption:=currentoption+1;{:289}
{290:}longoptions[currentoption].name:='verbose';
longoptions[currentoption].hasarg:=0;
longoptions[currentoption].flag:=addressof(verbose);
longoptions[currentoption].val:=1;currentoption:=currentoption+1;{:290}
{293:}longoptions[currentoption].name:=0;
longoptions[currentoption].hasarg:=0;longoptions[currentoption].flag:=0;
longoptions[currentoption].val:=0;{:293};
repeat getoptreturnval:=getoptlongonly(argc,argv,'',longoptions,
addressof(optionindex));if getoptreturnval=-1 then begin;
end else if getoptreturnval=63 then begin usage('ovp2ovf');
end else if(strcmp(longoptions[optionindex].name,'help')=0)then begin
usagehelp(OVP2OVFHELP,nil);
end else if(strcmp(longoptions[optionindex].name,'version')=0)then begin
printversionandexit('This is OVP2OVF, Version 1.13',nil,
'J. Plaice, Y. Haralambous, D.E. Knuth',nil);end;
until getoptreturnval=-1;
if(optind+1<>argc)and(optind+2<>argc)and(optind+3<>argc)then begin
writeln(stderr,'ovp2ovf',': Need one to three file arguments.');
usage('ovp2ovf');end;vplname:=extendfilename(cmdline(optind),'ovp');
if optind+2<=argc then begin vfname:=extendfilename(cmdline(optind+1),
'ovf');
if optind+3<=argc then begin tfmname:=extendfilename(cmdline(optind+2),
'ofm');end else begin tfmname:=makesuffix(cmdline(optind+1),'ofm');end;
end else begin vfname:=basenamechangesuffix(vplname,'.ovp','.ovf');
tfmname:=basenamechangesuffix(vplname,'.ovp','.ofm');end;end;{:287}
procedure initialize;var{25:}k:integer;{:25}{48:}h:0..306;{:48}{79:}
d:headerindex;{:79}{83:}c:integer;{:83}
begin kpsesetprogramname(argv[0],'ovp2ovf');parsearguments;{6:}
reset(vplfile,vplname);
if verbose then begin write(stderr,'This is OVP2OVF, Version 1.13');
writeln(stderr,versionstring);end;{:6}{22:}rewritebin(vffile,vfname);
rewritebin(tfmfile,tfmname);{:22}{26:}
for k:=0 to 127 do xord[chr(k)]:=127;xord[' ']:=32;xord['!']:=33;
xord['"']:=34;xord['#']:=35;xord['$']:=36;xord['%']:=37;xord['&']:=38;
xord['''']:=39;xord['(']:=40;xord[')']:=41;xord['*']:=42;xord['+']:=43;
xord[',']:=44;xord['-']:=45;xord['.']:=46;xord['/']:=47;xord['0']:=48;
xord['1']:=49;xord['2']:=50;xord['3']:=51;xord['4']:=52;xord['5']:=53;
xord['6']:=54;xord['7']:=55;xord['8']:=56;xord['9']:=57;xord[':']:=58;
xord[';']:=59;xord['<']:=60;xord['=']:=61;xord['>']:=62;xord['?']:=63;
xord['@']:=64;xord['A']:=65;xord['B']:=66;xord['C']:=67;xord['D']:=68;
xord['E']:=69;xord['F']:=70;xord['G']:=71;xord['H']:=72;xord['I']:=73;
xord['J']:=74;xord['K']:=75;xord['L']:=76;xord['M']:=77;xord['N']:=78;
xord['O']:=79;xord['P']:=80;xord['Q']:=81;xord['R']:=82;xord['S']:=83;
xord['T']:=84;xord['U']:=85;xord['V']:=86;xord['W']:=87;xord['X']:=88;
xord['Y']:=89;xord['Z']:=90;xord['[']:=91;xord['\']:=92;xord[']']:=93;
xord['^']:=94;xord['_']:=95;xord['`']:=96;xord['a']:=97;xord['b']:=98;
xord['c']:=99;xord['d']:=100;xord['e']:=101;xord['f']:=102;
xord['g']:=103;xord['h']:=104;xord['i']:=105;xord['j']:=106;
xord['k']:=107;xord['l']:=108;xord['m']:=109;xord['n']:=110;
xord['o']:=111;xord['p']:=112;xord['q']:=113;xord['r']:=114;
xord['s']:=115;xord['t']:=116;xord['u']:=117;xord['v']:=118;
xord['w']:=119;xord['x']:=120;xord['y']:=121;xord['z']:=122;
xord['{']:=123;xord['|']:=124;xord['}']:=125;xord['~']:=126;{:26}{28:}
line:=0;goodindent:=0;indent:=0;level:=0;{:28}{30:}limit:=0;loc:=0;
leftln:=true;rightln:=true;inputhasended:=false;{:30}{32:}
charsonline:=0;perfect:=true;{:32}{45:}startptr:=1;start[1]:=0;
dictptr:=0;{:45}{49:}for h:=0 to 306 do nhash[h]:=0;{:49}{68:}
zerobytes.b0:=0;zerobytes.b1:=0;zerobytes.b2:=0;zerobytes.b3:=0;{:68}
{80:}for d:=0 to 18*4-1 do headerbytes[d]:=0;headerbytes[8]:=11;
headerbytes[9]:=85;headerbytes[10]:=78;headerbytes[11]:=83;
headerbytes[12]:=80;headerbytes[13]:=69;headerbytes[14]:=67;
headerbytes[15]:=73;headerbytes[16]:=70;headerbytes[17]:=73;
headerbytes[18]:=69;headerbytes[19]:=68;
for d:=48 to 59 do headerbytes[d]:=headerbytes[d-40];
designsize:=10*1048576;designunits:=1048576;frozendu:=false;
sevenbitsafeflag:=false;headerptr:=18*4;nl:=0;minnl:=0;nk:=0;ne:=0;
np:=0;checksumspecified:=false;bchar:=xmaxchar;fontdir:=0;vfptr:=0;
vtitlestart:=0;vtitlelength:=0;fontptr:=0;
for k:=0 to maxchar do packetstart[k]:=vfsize;
for k:=0 to 127 do packetlength[k]:=1;
for k:=128 to 255 do packetlength[k]:=2;
for k:=256 to 65535 do packetlength[k]:=3;
for k:=65536 to maxchar do packetlength[k]:=4;{:80}{84:}
charremainder[xmaxchar]:=xmaxlabel;
for c:=0 to maxchar do begin charwd[c]:=0;charht[c]:=0;chardp[c]:=0;
charic[c]:=0;chartag[c]:=0;charremainder[c]:=0;end;
memory[0]:=2147483647;memory[1]:=0;link[1]:=0;memory[2]:=0;link[2]:=0;
memory[3]:=0;link[3]:=0;memory[4]:=0;link[4]:=0;memptr:=4;{:84}{119:}
for ivaluecategory:=0 to 256 do begin categoryremainders[ivaluecategory]
:=-1;end;maxivaluecategory:=-1;maxgluecategory:=-1;
maxpenaltycategory:=-1;{:119}{126:}
for c:=0 to maxchar do charextendedtag[c]:=false;{:126}{129:}
tablesread:=false;{:129}{132:}
for chentry:=0 to maxchar do begin charoriginal[chentry]:=chentry;
charrepeats[chentry]:=0;end;{:132}{135:}
for c:=0 to maxchar do for chtable:=0 to 8 do chartable[c,chtable]:=0;
{:135}{141:}HEX:=' 0123456789ABCDEF';{:141}{170:}hashptr:=0;
yligcycle:=xmaxchar;for k:=0 to hashsize do hash[k]:=0;{:170}{181:}
npc:=-1;{:181}{208:}ofmlevel:=-1;{:208}{216:}
for rarray:=0 to rulearrays do begin npr[rarray]:=0;{219:}
begin rules[rarray,npr[rarray]].rnwidth:=0;
rules[rarray,npr[rarray]].rndepth:=0;
rules[rarray,npr[rarray]].rnheight:=0;end{:219};end;nkr:=-1;{:216}{228:}
for garray:=0 to gluearrays do begin npg[garray]:=0;{231:}
begin glues[garray,npg[garray]].gnwidth:=0;
glues[garray,npg[garray]].gnstretch:=0;
glues[garray,npg[garray]].gnshrink:=0;
glues[garray,npg[garray]].gntype:=0;
glues[garray,npg[garray]].gnargtype:=0;
glues[garray,npg[garray]].gnstretchorder:=0;
glues[garray,npg[garray]].gnshrinkorder:=0;
glues[garray,npg[garray]].gnargument:=0;end{:231};end;nkg:=-1;{:228}
{240:}for parray:=0 to penaltyarrays do begin npp[parray]:=0;{243:}
begin penalties[parray,npp[parray]].pnval:=0;end{:243};end;nkp:=-1;
{:240}{252:}for marray:=0 to mvaluearrays do begin npm[marray]:=0;{255:}
begin mvalues[marray,npm[marray]].fnval:=0;end{:255};end;nkm:=-1;{:252}
{264:}for farray:=0 to fvaluearrays do begin npf[farray]:=0;{267:}
begin fvalues[farray,npf[farray]].fnval:=0;end{:267};end;nkf:=-1;{:264}
{276:}for iarray:=0 to ivaluearrays do begin npi[iarray]:=0;{279:}
begin ivalues[iarray,npi[iarray]].inval:=0;end{:279};end;nki:=-1;{:276}
end;{:2}{33:}procedure showerrorcontext;var k:0..bufsize;
begin writeln(stderr,' (line ',line:1,').');
if not leftln then write(stderr,'...');
for k:=1 to loc do write(stderr,buffer[k]);writeln(stderr,' ');
if not leftln then write(stderr,'   ');
for k:=1 to loc do write(stderr,' ');
for k:=loc+1 to limit do write(stderr,buffer[k]);
if rightln then writeln(stderr,' ')else writeln(stderr,'...');
charsonline:=0;perfect:=false;end;{:33}{34:}procedure fillbuffer;
begin leftln:=rightln;limit:=0;loc:=0;
if leftln then begin if line>0 then readln(vplfile);line:=line+1;end;
if eof(vplfile)then begin limit:=1;buffer[1]:=')';rightln:=false;
inputhasended:=true;
end else begin while(limit<bufsize-2)and(not eoln(vplfile))do begin
limit:=limit+1;read(vplfile,buffer[limit]);end;buffer[limit+1]:=' ';
rightln:=eoln(vplfile);if rightln then begin limit:=limit+1;
buffer[limit+1]:=' ';end;if leftln then{35:}
begin while(loc<limit)and(buffer[loc+1]=' ')do loc:=loc+1;
if loc<limit then begin if level=0 then if loc=0 then goodindent:=
goodindent+1 else begin if goodindent>=10 then begin if charsonline>0
then writeln(stderr,' ');
write(stderr,'Warning: Indented line occurred at level zero');
showerrorcontext;end;goodindent:=0;indent:=0;
end else if indent=0 then if loc mod level=0 then begin indent:=loc div
level;goodindent:=1;
end else goodindent:=0 else if indent*level=loc then goodindent:=
goodindent+1 else begin if goodindent>=10 then begin if charsonline>0
then writeln(stderr,' ');
write(stderr,'Warning: Inconsistent indentation; ',
'you are at parenthesis level ',level:1);showerrorcontext;end;
goodindent:=0;indent:=0;end;end;end{:35};end;end;{:34}{37:}
procedure getkeywordchar;begin while loc=limit do fillbuffer;
begin curchar:=xord[buffer[loc+1]];
if curchar>=97 then curchar:=curchar-32;
if((curchar>=48)and(curchar<=57))then loc:=loc+1 else if((curchar>=65)
and(curchar<=90))then loc:=loc+1 else if curchar=47 then loc:=loc+1 else
if curchar=62 then loc:=loc+1 else curchar:=32;end;end;{:37}{38:}
procedure getnext;begin while loc=limit do fillbuffer;loc:=loc+1;
curchar:=xord[buffer[loc]];
if curchar>=97 then if curchar<=122 then curchar:=curchar-32 else begin
if curchar=127 then begin begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Illegal character in the file');showerrorcontext;end;
curchar:=63;end;end else if(curchar<=41)and(curchar>=40)then loc:=loc-1;
end;{:38}{39:}function gethex:bytetype;var a:integer;
begin repeat getnext;until curchar<>32;a:=curchar-41;
if a>0 then begin a:=curchar-48;
if curchar>57 then if curchar<65 then a:=-1 else a:=curchar-55;end;
if(a<0)or(a>15)then begin begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Illegal hexadecimal digit');showerrorcontext;end;
gethex:=0;end else gethex:=a;end;{:39}{40:}procedure skiptoendofitem;
var l:integer;begin l:=level;
while level>=l do begin while loc=limit do fillbuffer;loc:=loc+1;
if buffer[loc]=')'then level:=level-1 else if buffer[loc]='('then level
:=level+1;end;
if inputhasended then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'File ended unexpectedly: No closing ")"');
showerrorcontext;end;curchar:=32;end;{:40}{41:}
procedure copytoendofitem;label 30;var l:integer;nonblankfound:boolean;
begin l:=level;nonblankfound:=false;
while true do begin while loc=limit do fillbuffer;
if buffer[loc+1]=')'then if level=l then goto 30 else level:=level-1;
loc:=loc+1;if buffer[loc]='('then level:=level+1;
if buffer[loc]<>' 'then nonblankfound:=true;
if nonblankfound then if xord[buffer[loc]]=127 then begin begin if
charsonline>0 then writeln(stderr,' ');
write(stderr,'Illegal character in the file');showerrorcontext;end;
begin vf[vfptr]:=63;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;
end else begin vf[vfptr]:=xord[buffer[loc]];
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;end;30:end;{:41}{43:}
procedure finishtheproperty;begin while curchar=32 do getnext;
if curchar<>41 then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Junk after property value will be ignored');
showerrorcontext;end;skiptoendofitem;end;{:43}{50:}procedure lookup;
var k:0..20;j:0..3000;notfound:boolean;curhashreset:boolean;begin{51:}
curhash:=curname[1];
for k:=2 to namelength do curhash:=(curhash+curhash+curname[k])mod 307{:
51};notfound:=true;curhashreset:=false;
while notfound do begin if(curhash=0)and(curhashreset)then notfound:=
false else begin if curhash=0 then begin curhash:=306;
curhashreset:=true end else curhash:=curhash-1;
if nhash[curhash]=0 then notfound:=false else begin j:=start[nhash[
curhash]];
if start[nhash[curhash]+1]=j+namelength then begin notfound:=false;
for k:=1 to namelength do if dictionary[j+k-1]<>curname[k]then notfound
:=true;end end end end;nameptr:=nhash[curhash];end;{:50}{53:}
procedure entername(v:bytetype);var k:0..20;
begin for k:=1 to namelength do curname[k]:=curname[k+20-namelength];
lookup;nhash[curhash]:=startptr;equiv[startptr]:=v;
for k:=1 to namelength do begin dictionary[dictptr]:=curname[k];
dictptr:=dictptr+1;end;startptr:=startptr+1;start[startptr]:=dictptr;
end;{:53}{58:}procedure getname;begin loc:=loc+1;level:=level+1;
curchar:=32;while curchar=32 do getnext;
if(curchar>41)or(curchar<40)then loc:=loc-1;namelength:=0;
getkeywordchar;
while curchar<>32 do begin if namelength=20 then curname[1]:=88 else
namelength:=namelength+1;curname[namelength]:=curchar;getkeywordchar;
end;lookup;
if nameptr=0 then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Sorry, I don''t know that property name');
showerrorcontext;end;curcode:=equiv[nameptr];end;{:58}{60:}
function getcharcode:integer;var acc:integer;t:ASCIIcode;
begin repeat getnext;until curchar<>32;t:=curchar;acc:=0;repeat getnext;
until curchar<>32;if t=67 then{61:}
if(curchar>=33)and(curchar<=126)and((curchar<40)or(curchar>41))then acc
:=xord[buffer[loc]]else begin begin if charsonline>0 then writeln(stderr
,' ');write(stderr,'"C" value must be standard ASCII and not a paren');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);
end{:61}else if t=68 then{62:}
begin while(curchar>=48)and(curchar<=57)do begin acc:=acc*10+curchar-48;
if acc>1114111 then begin begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This value shouldn''t exceed 1114111');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);end;
acc:=0;curchar:=32;end else getnext;end;
begin if(curchar>41)or(curchar<40)then loc:=loc-1;end;end{:62}
else if t=79 then{63:}
begin while(curchar>=48)and(curchar<=55)do begin acc:=acc*8+curchar-48;
if acc>1114111 then begin begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This value shouldn''t exceed ''4177777');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);end;
acc:=0;curchar:=32;end else getnext;end;
begin if(curchar>41)or(curchar<40)then loc:=loc-1;end;end{:63}
else if t=72 then{64:}
begin while((curchar>=48)and(curchar<=57))or((curchar>=65)and(curchar<=
70))do begin if curchar>=65 then curchar:=curchar-7;
acc:=acc*16+curchar-48;
if acc>1114111 then begin begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This value shouldn''t exceed "10FFFF');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);end;
acc:=0;curchar:=32;end else getnext;end;
begin if(curchar>41)or(curchar<40)then loc:=loc-1;end;end{:64}
else if t=70 then{65:}
begin if curchar=66 then acc:=2 else if curchar=76 then acc:=4 else if
curchar<>77 then acc:=18;getnext;
if curchar=73 then acc:=acc+1 else if curchar<>82 then acc:=18;getnext;
if curchar=67 then acc:=acc+6 else if curchar=69 then acc:=acc+12 else
if curchar<>82 then acc:=18;
if acc>=18 then begin begin begin if charsonline>0 then writeln(stderr,
' ');write(stderr,'Illegal face code, I changed it to MRR');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);end;
acc:=0;end;end{:65}
else begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'You need "C" or "D" or "O" or "H" or "F" here');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);end;
curchar:=32;getcharcode:=acc;end;function getbyte:integer;
var acc:integer;begin acc:=getcharcode;
if acc>65535 then begin begin begin if charsonline>0 then writeln(stderr
,' ');write(stderr,'This value shouldn''t exceed "FFFF');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);end;
acc:=0;curchar:=32;end;getbyte:=acc;end;{:60}{69:}
procedure getfourbytes;var c:integer;r:integer;begin repeat getnext;
until curchar<>32;r:=0;curbytes:=zerobytes;
if curchar=72 then r:=16 else if curchar=79 then r:=8 else if curchar=68
then r:=10 else begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,
'Decimal ("D"), octal ("O"), or hex ("H") value needed here');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);end;
if r>0 then begin repeat getnext;until curchar<>32;
while((curchar>=48)and(curchar<=57))or((curchar>=65)and(curchar<=70))do{
70:}begin if curchar>=65 then curchar:=curchar-7;
if curchar>=48+r then begin begin if charsonline>0 then writeln(stderr,
' ');write(stderr,'Illegal digit');showerrorcontext;end;
repeat getnext until(curchar=40)or(curchar=41);
end else begin c:=curbytes.b3*r+curchar-48;curbytes.b3:=c mod 256;
c:=curbytes.b2*r+c div 256;curbytes.b2:=c mod 256;
c:=curbytes.b1*r+c div 256;curbytes.b1:=c mod 256;
c:=curbytes.b0*r+c div 256;
if c<256 then curbytes.b0:=c else begin curbytes:=zerobytes;
if r=8 then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Sorry, the maximum octal value is O 37777777777');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);
end else if r=10 then begin begin if charsonline>0 then writeln(stderr,
' ');write(stderr,'Sorry, the maximum decimal value is D 4294967295');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);
end else begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Sorry, the maximum hex value is H FFFFFFFF');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);end;
end;getnext;end;end{:70};end;end;function getinteger:integer;
var a:integer;begin getfourbytes;a:=curbytes.b0;if a>=128 then a:=a-256;
getinteger:=(a*16777216)+(curbytes.b1*65536)+(curbytes.b2*256)+curbytes.
b3;end;{:69}{72:}function getfix:fixword;var negative:boolean;
acc:integer;intpart:integer;j:0..7;begin repeat getnext;
until curchar<>32;negative:=false;acc:=0;
if(curchar<>82)and(curchar<>68)then begin begin if charsonline>0 then
writeln(stderr,' ');write(stderr,'An "R" or "D" value is needed here');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);
end else begin{73:}repeat getnext;if curchar=45 then begin curchar:=32;
negative:=not negative;end else if curchar=43 then curchar:=32;
until curchar<>32{:73};while(curchar>=48)and(curchar<=57)do{74:}
begin acc:=acc*10+curchar-48;
if acc>=2048 then begin begin begin if charsonline>0 then writeln(stderr
,' ');write(stderr,'Real constants must be less than 2048');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);end;
acc:=0;curchar:=32;end else getnext;end{:74};intpart:=acc;acc:=0;
if curchar=46 then{76:}begin j:=0;getnext;
while(curchar>=48)and(curchar<=57)do begin if j<7 then begin j:=j+1;
fractiondigits[j]:=2097152*(curchar-48);end;getnext;end;acc:=0;
while j>0 do begin acc:=fractiondigits[j]+(acc div 10);j:=j-1;end;
acc:=(acc+10)div 20;end{:76};
if(acc>=1048576)and(intpart=2047)then begin begin if charsonline>0 then
writeln(stderr,' ');
write(stderr,'Real constants must be less than 2048');showerrorcontext;
end;repeat getnext until(curchar=40)or(curchar=41);
end else acc:=intpart*1048576+acc;end;
if negative then getfix:=-acc else getfix:=acc;end;{:72}{85:}
function sortin(h:pointer;d:fixword):pointer;var p:pointer;
begin if(d=0)and(h<>1)then sortin:=0 else begin p:=h;
while d>=memory[link[p]]do p:=link[p];
if(d=memory[p])and(p<>h)then sortin:=p else if memptr=memsize then begin
begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Memory overflow: too many widths, etc');showerrorcontext;
end;writeln(stderr,'Congratulations! It''s hard to make this error.');
sortin:=p;end else begin memptr:=memptr+1;memory[memptr]:=d;
link[memptr]:=link[p];link[p]:=memptr;memory[h]:=memory[h]+1;
sortin:=memptr;end;end;end;{:85}{87:}function mincover(h:pointer;
d:fixword):integer;var p:pointer;l:fixword;m:integer;begin m:=0;
p:=link[h];nextd:=memory[0];while p<>0 do begin m:=m+1;l:=memory[p];
while memory[link[p]]<=l+d do p:=link[p];p:=link[p];
if memory[p]-l<nextd then nextd:=memory[p]-l;end;mincover:=m;end;{:87}
{88:}function shorten(h:pointer;m:integer):fixword;var d:fixword;
k:integer;begin if memory[h]>m then begin excess:=memory[h]-m;
k:=mincover(h,0);d:=nextd;repeat d:=d+d;k:=mincover(h,d);until k<=m;
d:=d div 2;k:=mincover(h,d);while k>m do begin d:=nextd;
k:=mincover(h,d);end;shorten:=d;end else shorten:=0;end;{:88}{90:}
procedure setindices(h:pointer;d:fixword);var p:pointer;q:pointer;
m:bytetype;l:fixword;begin q:=h;p:=link[q];m:=0;
while p<>0 do begin m:=m+1;l:=memory[p];indexvar[p]:=m;
while memory[link[p]]<=l+d do begin p:=link[p];indexvar[p]:=m;
excess:=excess-1;if excess=0 then d:=0;end;link[q]:=p;
memory[p]:=l+(memory[p]-l)div 2;q:=p;p:=link[p];end;memory[h]:=m;end;
{:90}{93:}procedure junkerror;
begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'There''s junk here that is not in parentheses');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);end;
{:93}{96:}procedure readfourbytes(l:headerindex);begin getfourbytes;
headerbytes[l]:=curbytes.b0;headerbytes[l+1]:=curbytes.b1;
headerbytes[l+2]:=curbytes.b2;headerbytes[l+3]:=curbytes.b3;end;{:96}
{97:}procedure readBCPL(l:headerindex;n:bytetype);var k:headerindex;
begin k:=l;while curchar=32 do getnext;
while(curchar<>40)and(curchar<>41)do begin if k<l+n then k:=k+1;
if k<l+n then headerbytes[k]:=curchar;getnext;end;
if k=l+n then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'String is too long; its first ',n-1:1,
' characters will be kept');showerrorcontext;end;k:=k-1;end;
headerbytes[l]:=k-l;while k<l+n-1 do begin k:=k+1;headerbytes[k]:=0;end;
end;{:97}{111:}procedure checktag(c:integer);begin case chartag[c]of 0:;
1:begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This character already appeared in a LIGTABLE LABEL');
showerrorcontext;end;2:begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This character already has a NEXTLARGER spec');
showerrorcontext;end;3:begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This character already has a VARCHAR spec');
showerrorcontext;end;end;end;{:111}{143:}procedure printdigs(j:integer);
begin repeat j:=j-1;write(stderr,HEX[1+dig[j]]);until j=0;end;{:143}
{144:}procedure printnumber(c:integer;form:integer);var j:0..32;
begin j:=0;if(c<0)then begin writeln(stderr,
'Internal error: print_number (negative value)');c:=0;end;
if form=8 then write(stderr,'''')else if form=16 then write(stderr,'"')
else if form<>10 then begin writeln(stderr,
'Internal error: print_number (form)');form:=16;end;
while(c>0)or(j=0)do begin dig[j]:=c mod form;c:=c div form;j:=j+1;end;
printdigs(j);end;{:144}{146:}procedure vfstoreset(x:integer);
var o:bytetype;begin o:=128;
if(x<256)and(x>=0)then begin if(o<>128)or(x>127)then if(o=235)and(x<64)
then x:=x+171 else begin vf[vfptr]:=o;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;
end else begin if(x<65536)and(x>=0)then begin vf[vfptr]:=o+1;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;
end else begin if(x<16777216)and(x>=0)then begin vf[vfptr]:=o+2;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;
end else begin begin vf[vfptr]:=o+3;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;
if x>=0 then begin vf[vfptr]:=x div 16777216;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end else begin x:=x+1073741824;
x:=x+1073741824;begin vf[vfptr]:=(x div 16777216)+128;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;x:=x mod 16777216;end;
begin vf[vfptr]:=x div 65536;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;x:=x mod 65536;end;
begin vf[vfptr]:=x div 65536;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;x:=x mod 65536;end;
begin vf[vfptr]:=x div 256;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;x:=x mod 256;end;
begin vf[vfptr]:=x;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;end;
procedure vfoutset(x:integer);var o:bytetype;begin o:=128;
if(x<256)and(x>=0)then begin if(o<>128)or(x>127)then if(o=235)and(x<64)
then x:=x+171 else putbyte(o,vffile);
end else begin if(x<65536)and(x>=0)then putbyte(o+1,vffile)else begin if
(x<16777216)and(x>=0)then putbyte(o+2,vffile)else begin putbyte(o+3,
vffile);
if x>=0 then putbyte(x div 16777216,vffile)else begin x:=x+1073741824;
x:=x+1073741824;putbyte((x div 16777216)+128,vffile);x:=x mod 16777216;
end;putbyte(x div 65536,vffile);x:=x mod 65536;end;
putbyte(x div 65536,vffile);x:=x mod 65536;end;
putbyte(x div 256,vffile);x:=x mod 256;end;putbyte(x,vffile);end;
procedure vfstorefnt(x:integer);var o:bytetype;begin o:=235;
if(x<256)and(x>=0)then begin if(o<>128)or(x>127)then if(o=235)and(x<64)
then x:=x+171 else begin vf[vfptr]:=o;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;
end else begin if(x<65536)and(x>=0)then begin vf[vfptr]:=o+1;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;
end else begin if(x<16777216)and(x>=0)then begin vf[vfptr]:=o+2;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;
end else begin begin vf[vfptr]:=o+3;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;
if x>=0 then begin vf[vfptr]:=x div 16777216;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end else begin x:=x+1073741824;
x:=x+1073741824;begin vf[vfptr]:=(x div 16777216)+128;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;x:=x mod 16777216;end;
begin vf[vfptr]:=x div 65536;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;x:=x mod 65536;end;
begin vf[vfptr]:=x div 65536;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;x:=x mod 65536;end;
begin vf[vfptr]:=x div 256;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;x:=x mod 256;end;
begin vf[vfptr]:=x;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;end;
procedure vfoutfntdef(x:integer);var o:bytetype;begin o:=243;
if(x<256)and(x>=0)then begin if(o<>128)or(x>127)then if(o=235)and(x<64)
then x:=x+171 else putbyte(o,vffile);
end else begin if(x<65536)and(x>=0)then putbyte(o+1,vffile)else begin if
(x<16777216)and(x>=0)then putbyte(o+2,vffile)else begin putbyte(o+3,
vffile);
if x>=0 then putbyte(x div 16777216,vffile)else begin x:=x+1073741824;
x:=x+1073741824;putbyte((x div 16777216)+128,vffile);x:=x mod 16777216;
end;putbyte(x div 65536,vffile);x:=x mod 65536;end;
putbyte(x div 65536,vffile);x:=x mod 65536;end;
putbyte(x div 256,vffile);x:=x mod 256;end;putbyte(x,vffile);end;
procedure vfoutchar(x:integer);
begin if x>=0 then putbyte(x div 16777216,vffile)else begin x:=x
+1073741824;x:=x+1073741824;putbyte((x div 16777216)+128,vffile);end;
x:=x mod 16777216;putbyte(x div 65536,vffile);x:=x mod 65536;
putbyte(x div 256,vffile);putbyte(x mod 256,vffile);end;{:146}{148:}
{152:}procedure vffix(opcode:bytetype;x:fixword);var negative:boolean;
k:0..4;t:integer;begin frozendu:=true;
if designunits<>1048576 then x:=round((x/designunits)*1048576.0);
if x>=0 then negative:=false else begin negative:=true;x:=-1-x;end;
if opcode=0 then begin k:=4;t:=16777216;end else begin t:=127;k:=1;
while x>t do begin t:=256*t+255;k:=k+1;end;begin vf[vfptr]:=opcode+k-1;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;t:=t div 128+1;end;
repeat if negative then begin begin vf[vfptr]:=255-(x div t);
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;negative:=false;
x:=(x div t)*t+t-1-x;end else begin vf[vfptr]:=(x div t)mod 256;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;k:=k-1;t:=t div 256;
until k=0;end;{:152}procedure readpacket(c:integer);var cc:chartype;
x:fixword;h,v:0..2;specialstart:0..vfsize;k:0..vfsize;
begin packetstart[c]:=vfptr;stackptr:=0;h:=0;v:=0;curfont:=0;
while level=2 do begin while curchar=32 do getnext;
if curchar=40 then{149:}begin getname;
if curcode=0 then skiptoendofitem else if(curcode<210)or(curcode>220)
then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a MAP list');
showerrorcontext;end;skiptoendofitem;
end else begin case curcode of 210:{150:}
begin fontnumber[fontptr]:=getinteger;curfont:=0;
while fontnumber[fontptr]<>fontnumber[curfont]do curfont:=curfont+1;
if curfont=fontptr then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Undefined MAPFONT cannot be selected');showerrorcontext;
end else vfstorefnt(curfont);end{:150};211:{151:}
if curfont=fontptr then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Character cannot be typeset in undefined font');
showerrorcontext;end else begin cc:=getcharcode;vfstoreset(cc);end{:151}
;212:{153:}begin begin vf[vfptr]:=132;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;vffix(0,getfix);
vffix(0,getfix);end{:153};213,214:{154:}
begin if curcode=213 then x:=getfix else x:=-getfix;
if h=0 then begin wstack[stackptr]:=x;h:=1;vffix(148,x);
end else if x=wstack[stackptr]then begin vf[vfptr]:=147;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;
end else if h=1 then begin xstack[stackptr]:=x;h:=2;vffix(153,x);
end else if x=xstack[stackptr]then begin vf[vfptr]:=152;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end else vffix(143,x);end{:154}
;215,216:{155:}begin if curcode=215 then x:=getfix else x:=-getfix;
if v=0 then begin ystack[stackptr]:=x;v:=1;vffix(162,x);
end else if x=ystack[stackptr]then begin vf[vfptr]:=161;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;
end else if v=1 then begin zstack[stackptr]:=x;v:=2;vffix(167,x);
end else if x=zstack[stackptr]then begin vf[vfptr]:=166;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end else vffix(157,x);end{:155}
;217:{156:}
if stackptr=maxstack then begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Don''t push so much---stack is full!');showerrorcontext;
end else begin begin vf[vfptr]:=141;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;hstack[stackptr]:=h;
vstack[stackptr]:=v;stackptr:=stackptr+1;h:=0;v:=0;end{:156};218:{157:}
if stackptr=0 then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Empty stack cannot be popped');showerrorcontext;
end else begin begin vf[vfptr]:=142;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;stackptr:=stackptr-1;
h:=hstack[stackptr];v:=vstack[stackptr];end{:157};219,220:{158:}
begin begin vf[vfptr]:=239;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;begin vf[vfptr]:=0;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;specialstart:=vfptr;
if curcode=219 then copytoendofitem else begin repeat x:=gethex;
if curchar>41 then begin vf[vfptr]:=x*16+gethex;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;until curchar<=41;end;
if vfptr-specialstart>255 then{159:}
if vfptr+3>vfsize then begin begin if charsonline>0 then writeln(stderr,
' ');write(stderr,'Special command being clipped---no room left!');
showerrorcontext;end;vfptr:=specialstart+255;vf[specialstart-1]:=255;
end else begin for k:=vfptr downto specialstart do vf[k+3]:=vf[k];
x:=vfptr-specialstart;vfptr:=vfptr+3;vf[specialstart-2]:=242;
vf[specialstart-1]:=x div 16777216;
vf[specialstart]:=(x div 65536)mod 256;
vf[specialstart+1]:=(x div 256)mod 256;vf[specialstart+2]:=x mod 256;
end{:159}else vf[specialstart-1]:=vfptr-specialstart;end{:158};end;
finishtheproperty;end;end{:149}
else if curchar=41 then skiptoendofitem else junkerror;end;
while stackptr>0 do begin begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Missing POP supplied');showerrorcontext;end;
begin vf[vfptr]:=142;
if vfptr=vfsize then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'I''m out of memory---increase my vfsize!');
showerrorcontext;end else vfptr:=vfptr+1;end;stackptr:=stackptr-1;end;
packetlength[c]:=vfptr-packetstart[c];begin loc:=loc-1;level:=level+1;
curchar:=41;end;end;{:148}{172:}function hashinput(p,c:indx):boolean;
label 30;var cc:0..3;zz:chartype;y:chartype;key:integer64;t64:integer64;
t:integer;begin if hashptr=hashsize then begin hashinput:=false;goto 30;
end;{173:}y:=ligkern[p].b1;t:=ligkern[p].b2;cc:=0;zz:=ligkern[p].b3;
if t>=128 then zz:=y else begin case t of 0,6:;5,11:zz:=y;1,7:cc:=1;
2:cc:=2;3:cc:=3;end;end{:173};key:=int64cast(xmaxchar)*c+y+1;
h:=(hashmult*key)mod hashsize;
while hash[h]>0 do begin if hash[h]<=key then begin if hash[h]=key then
begin hashinput:=false;goto 30;end;t64:=hash[h];hash[h]:=key;key:=t64;
t:=classvar[h];classvar[h]:=cc;cc:=t;t:=ligz[h];ligz[h]:=zz;zz:=t;end;
if h>0 then h:=h-1 else h:=hashsize;end;hash[h]:=key;classvar[h]:=cc;
ligz[h]:=zz;hashptr:=hashptr+1;hashlist[hashptr]:=h;hashinput:=true;
30:end;{:172}{174:}ifdef('notdef')function f(h,x,y:indx):indx;begin end;
endif('notdef')function eval(x,y:indx):indx;var key:integer64;
begin key:=int64cast(xmaxchar)*x+y+1;h:=(hashmult*key)mod hashsize;
while hash[h]>key do if h>0 then h:=h-1 else h:=hashsize;
if hash[h]<key then eval:=y else eval:=f(h,x,y);end;{:174}{175:}
function f(h,x,y:indx):indx;begin case classvar[h]of 0:;
1:begin classvar[h]:=4;ligz[h]:=eval(ligz[h],y);classvar[h]:=0;end;
2:begin classvar[h]:=4;ligz[h]:=eval(x,ligz[h]);classvar[h]:=0;end;
3:begin classvar[h]:=4;ligz[h]:=eval(eval(x,ligz[h]),y);classvar[h]:=0;
end;4:begin xligcycle:=x;yligcycle:=y;ligz[h]:=xxmaxchar;classvar[h]:=0;
end;end;f:=ligz[h];end;{:175}{178:}procedure outint(x:integer);
begin if x>=0 then putbyte(x div 16777216,tfmfile)else begin x:=x
+1073741824;x:=x+1073741824;putbyte((x div 16777216)+128,tfmfile);end;
x:=x mod 16777216;putbyte(x div 65536,tfmfile);x:=x mod 65536;
putbyte(x div 256,tfmfile);putbyte(x mod 256,tfmfile);end;{:178}{190:}
procedure outscaled(x:fixword);var n:bytetype;m:0..65535;
begin if fabs(x/designunits)>=16.0 then begin write(stderr,
'The relative dimension ');fprintreal(stderr,x/1048576,1,3);
writeln(stderr,' is too large.');
write(stderr,'  (Must be less than 16*designsize');
if designunits<>1048576 then begin write(stderr,' =');
fprintreal(stderr,designunits/65536,1,3);write(stderr,' designunits');
end;writeln(stderr,')');x:=0;end;
if designunits<>1048576 then x:=round((x/designunits)*1048576.0);
if x<0 then begin putbyte(255,tfmfile);x:=x+16777216;if x<=0 then x:=1;
end else begin putbyte(0,tfmfile);if x>=16777216 then x:=16777215;end;
n:=x div 65536;m:=x mod 65536;putbyte(n,tfmfile);
putbyte(m div 256,tfmfile);putbyte(m mod 256,tfmfile);end;{:190}{201:}
procedure voutint(x:integer);
begin if x>=0 then putbyte(x div 16777216,vffile)else begin putbyte(255,
vffile);x:=x+16777216;end;putbyte((x div 65536)mod 256,vffile);
putbyte((x div 256)mod 256,vffile);putbyte(x mod 256,vffile);end;{:201}
{205:}procedure paramenter;begin{57:}namelength:=5;curname[16]:=83;
curname[17]:=76;curname[18]:=65;curname[19]:=78;curname[20]:=84;
entername(31);namelength:=5;curname[16]:=83;curname[17]:=80;
curname[18]:=65;curname[19]:=67;curname[20]:=69;entername(32);
namelength:=7;curname[14]:=83;curname[15]:=84;curname[16]:=82;
curname[17]:=69;curname[18]:=84;curname[19]:=67;curname[20]:=72;
entername(33);namelength:=6;curname[15]:=83;curname[16]:=72;
curname[17]:=82;curname[18]:=73;curname[19]:=78;curname[20]:=75;
entername(34);namelength:=7;curname[14]:=88;curname[15]:=72;
curname[16]:=69;curname[17]:=73;curname[18]:=71;curname[19]:=72;
curname[20]:=84;entername(35);namelength:=4;curname[17]:=81;
curname[18]:=85;curname[19]:=65;curname[20]:=68;entername(36);
namelength:=10;curname[11]:=69;curname[12]:=88;curname[13]:=84;
curname[14]:=82;curname[15]:=65;curname[16]:=83;curname[17]:=80;
curname[18]:=65;curname[19]:=67;curname[20]:=69;entername(37);
namelength:=4;curname[17]:=78;curname[18]:=85;curname[19]:=77;
curname[20]:=49;entername(38);namelength:=4;curname[17]:=78;
curname[18]:=85;curname[19]:=77;curname[20]:=50;entername(39);
namelength:=4;curname[17]:=78;curname[18]:=85;curname[19]:=77;
curname[20]:=51;entername(40);namelength:=6;curname[15]:=68;
curname[16]:=69;curname[17]:=78;curname[18]:=79;curname[19]:=77;
curname[20]:=49;entername(41);namelength:=6;curname[15]:=68;
curname[16]:=69;curname[17]:=78;curname[18]:=79;curname[19]:=77;
curname[20]:=50;entername(42);namelength:=4;curname[17]:=83;
curname[18]:=85;curname[19]:=80;curname[20]:=49;entername(43);
namelength:=4;curname[17]:=83;curname[18]:=85;curname[19]:=80;
curname[20]:=50;entername(44);namelength:=4;curname[17]:=83;
curname[18]:=85;curname[19]:=80;curname[20]:=51;entername(45);
namelength:=4;curname[17]:=83;curname[18]:=85;curname[19]:=66;
curname[20]:=49;entername(46);namelength:=4;curname[17]:=83;
curname[18]:=85;curname[19]:=66;curname[20]:=50;entername(47);
namelength:=7;curname[14]:=83;curname[15]:=85;curname[16]:=80;
curname[17]:=68;curname[18]:=82;curname[19]:=79;curname[20]:=80;
entername(48);namelength:=7;curname[14]:=83;curname[15]:=85;
curname[16]:=66;curname[17]:=68;curname[18]:=82;curname[19]:=79;
curname[20]:=80;entername(49);namelength:=6;curname[15]:=68;
curname[16]:=69;curname[17]:=76;curname[18]:=73;curname[19]:=77;
curname[20]:=49;entername(50);namelength:=6;curname[15]:=68;
curname[16]:=69;curname[17]:=76;curname[18]:=73;curname[19]:=77;
curname[20]:=50;entername(51);namelength:=10;curname[11]:=65;
curname[12]:=88;curname[13]:=73;curname[14]:=83;curname[15]:=72;
curname[16]:=69;curname[17]:=73;curname[18]:=71;curname[19]:=72;
curname[20]:=84;entername(52);namelength:=20;curname[1]:=68;
curname[2]:=69;curname[3]:=70;curname[4]:=65;curname[5]:=85;
curname[6]:=76;curname[7]:=84;curname[8]:=82;curname[9]:=85;
curname[10]:=76;curname[11]:=69;curname[12]:=84;curname[13]:=72;
curname[14]:=73;curname[15]:=67;curname[16]:=75;curname[17]:=78;
curname[18]:=69;curname[19]:=83;curname[20]:=83;entername(38);
namelength:=13;curname[8]:=66;curname[9]:=73;curname[10]:=71;
curname[11]:=79;curname[12]:=80;curname[13]:=83;curname[14]:=80;
curname[15]:=65;curname[16]:=67;curname[17]:=73;curname[18]:=78;
curname[19]:=71;curname[20]:=49;entername(39);namelength:=13;
curname[8]:=66;curname[9]:=73;curname[10]:=71;curname[11]:=79;
curname[12]:=80;curname[13]:=83;curname[14]:=80;curname[15]:=65;
curname[16]:=67;curname[17]:=73;curname[18]:=78;curname[19]:=71;
curname[20]:=50;entername(40);namelength:=13;curname[8]:=66;
curname[9]:=73;curname[10]:=71;curname[11]:=79;curname[12]:=80;
curname[13]:=83;curname[14]:=80;curname[15]:=65;curname[16]:=67;
curname[17]:=73;curname[18]:=78;curname[19]:=71;curname[20]:=51;
entername(41);namelength:=13;curname[8]:=66;curname[9]:=73;
curname[10]:=71;curname[11]:=79;curname[12]:=80;curname[13]:=83;
curname[14]:=80;curname[15]:=65;curname[16]:=67;curname[17]:=73;
curname[18]:=78;curname[19]:=71;curname[20]:=52;entername(42);
namelength:=13;curname[8]:=66;curname[9]:=73;curname[10]:=71;
curname[11]:=79;curname[12]:=80;curname[13]:=83;curname[14]:=80;
curname[15]:=65;curname[16]:=67;curname[17]:=73;curname[18]:=78;
curname[19]:=71;curname[20]:=53;entername(43);{:57};end;
procedure vplenter;begin{56:}namelength:=6;curname[15]:=86;
curname[16]:=84;curname[17]:=73;curname[18]:=84;curname[19]:=76;
curname[20]:=69;entername(12);namelength:=7;curname[14]:=77;
curname[15]:=65;curname[16]:=80;curname[17]:=70;curname[18]:=79;
curname[19]:=78;curname[20]:=84;entername(13);namelength:=3;
curname[18]:=77;curname[19]:=65;curname[20]:=80;entername(101);
namelength:=8;curname[13]:=70;curname[14]:=79;curname[15]:=78;
curname[16]:=84;curname[17]:=78;curname[18]:=65;curname[19]:=77;
curname[20]:=69;entername(200);namelength:=8;curname[13]:=70;
curname[14]:=79;curname[15]:=78;curname[16]:=84;curname[17]:=65;
curname[18]:=82;curname[19]:=69;curname[20]:=65;entername(201);
namelength:=12;curname[9]:=70;curname[10]:=79;curname[11]:=78;
curname[12]:=84;curname[13]:=67;curname[14]:=72;curname[15]:=69;
curname[16]:=67;curname[17]:=75;curname[18]:=83;curname[19]:=85;
curname[20]:=77;entername(202);namelength:=6;curname[15]:=70;
curname[16]:=79;curname[17]:=78;curname[18]:=84;curname[19]:=65;
curname[20]:=84;entername(203);namelength:=9;curname[12]:=70;
curname[13]:=79;curname[14]:=78;curname[15]:=84;curname[16]:=68;
curname[17]:=83;curname[18]:=73;curname[19]:=90;curname[20]:=69;
entername(204);namelength:=10;curname[11]:=83;curname[12]:=69;
curname[13]:=76;curname[14]:=69;curname[15]:=67;curname[16]:=84;
curname[17]:=70;curname[18]:=79;curname[19]:=78;curname[20]:=84;
entername(210);namelength:=7;curname[14]:=83;curname[15]:=69;
curname[16]:=84;curname[17]:=67;curname[18]:=72;curname[19]:=65;
curname[20]:=82;entername(211);namelength:=7;curname[14]:=83;
curname[15]:=69;curname[16]:=84;curname[17]:=82;curname[18]:=85;
curname[19]:=76;curname[20]:=69;entername(212);namelength:=9;
curname[12]:=77;curname[13]:=79;curname[14]:=86;curname[15]:=69;
curname[16]:=82;curname[17]:=73;curname[18]:=71;curname[19]:=72;
curname[20]:=84;entername(213);namelength:=8;curname[13]:=77;
curname[14]:=79;curname[15]:=86;curname[16]:=69;curname[17]:=76;
curname[18]:=69;curname[19]:=70;curname[20]:=84;entername(214);
namelength:=8;curname[13]:=77;curname[14]:=79;curname[15]:=86;
curname[16]:=69;curname[17]:=68;curname[18]:=79;curname[19]:=87;
curname[20]:=78;entername(215);namelength:=6;curname[15]:=77;
curname[16]:=79;curname[17]:=86;curname[18]:=69;curname[19]:=85;
curname[20]:=80;entername(216);namelength:=4;curname[17]:=80;
curname[18]:=85;curname[19]:=83;curname[20]:=72;entername(217);
namelength:=3;curname[18]:=80;curname[19]:=79;curname[20]:=80;
entername(218);namelength:=7;curname[14]:=83;curname[15]:=80;
curname[16]:=69;curname[17]:=67;curname[18]:=73;curname[19]:=65;
curname[20]:=76;entername(219);namelength:=10;curname[11]:=83;
curname[12]:=80;curname[13]:=69;curname[14]:=67;curname[15]:=73;
curname[16]:=65;curname[17]:=76;curname[18]:=72;curname[19]:=69;
curname[20]:=88;entername(220);{:56};end;procedure nameenter;begin{55:}
equiv[0]:=0;namelength:=8;curname[13]:=67;curname[14]:=72;
curname[15]:=69;curname[16]:=67;curname[17]:=75;curname[18]:=83;
curname[19]:=85;curname[20]:=77;entername(1);namelength:=10;
curname[11]:=68;curname[12]:=69;curname[13]:=83;curname[14]:=73;
curname[15]:=71;curname[16]:=78;curname[17]:=83;curname[18]:=73;
curname[19]:=90;curname[20]:=69;entername(2);namelength:=11;
curname[10]:=68;curname[11]:=69;curname[12]:=83;curname[13]:=73;
curname[14]:=71;curname[15]:=78;curname[16]:=85;curname[17]:=78;
curname[18]:=73;curname[19]:=84;curname[20]:=83;entername(3);
namelength:=12;curname[9]:=67;curname[10]:=79;curname[11]:=68;
curname[12]:=73;curname[13]:=78;curname[14]:=71;curname[15]:=83;
curname[16]:=67;curname[17]:=72;curname[18]:=69;curname[19]:=77;
curname[20]:=69;entername(4);namelength:=6;curname[15]:=70;
curname[16]:=65;curname[17]:=77;curname[18]:=73;curname[19]:=76;
curname[20]:=89;entername(5);namelength:=4;curname[17]:=70;
curname[18]:=65;curname[19]:=67;curname[20]:=69;entername(6);
namelength:=16;curname[5]:=83;curname[6]:=69;curname[7]:=86;
curname[8]:=69;curname[9]:=78;curname[10]:=66;curname[11]:=73;
curname[12]:=84;curname[13]:=83;curname[14]:=65;curname[15]:=70;
curname[16]:=69;curname[17]:=70;curname[18]:=76;curname[19]:=65;
curname[20]:=71;entername(7);namelength:=6;curname[15]:=72;
curname[16]:=69;curname[17]:=65;curname[18]:=68;curname[19]:=69;
curname[20]:=82;entername(8);namelength:=9;curname[12]:=70;
curname[13]:=79;curname[14]:=78;curname[15]:=84;curname[16]:=68;
curname[17]:=73;curname[18]:=77;curname[19]:=69;curname[20]:=78;
entername(9);namelength:=8;curname[13]:=76;curname[14]:=73;
curname[15]:=71;curname[16]:=84;curname[17]:=65;curname[18]:=66;
curname[19]:=76;curname[20]:=69;entername(10);namelength:=12;
curname[9]:=66;curname[10]:=79;curname[11]:=85;curname[12]:=78;
curname[13]:=68;curname[14]:=65;curname[15]:=82;curname[16]:=89;
curname[17]:=67;curname[18]:=72;curname[19]:=65;curname[20]:=82;
entername(11);namelength:=9;curname[12]:=67;curname[13]:=72;
curname[14]:=65;curname[15]:=82;curname[16]:=65;curname[17]:=67;
curname[18]:=84;curname[19]:=69;curname[20]:=82;entername(14);
namelength:=9;curname[12]:=80;curname[13]:=65;curname[14]:=82;
curname[15]:=65;curname[16]:=77;curname[17]:=69;curname[18]:=84;
curname[19]:=69;curname[20]:=82;entername(30);namelength:=6;
curname[15]:=67;curname[16]:=72;curname[17]:=65;curname[18]:=82;
curname[19]:=87;curname[20]:=68;entername(71);namelength:=6;
curname[15]:=67;curname[16]:=72;curname[17]:=65;curname[18]:=82;
curname[19]:=72;curname[20]:=84;entername(72);namelength:=6;
curname[15]:=67;curname[16]:=72;curname[17]:=65;curname[18]:=82;
curname[19]:=68;curname[20]:=80;entername(73);namelength:=6;
curname[15]:=67;curname[16]:=72;curname[17]:=65;curname[18]:=82;
curname[19]:=73;curname[20]:=67;entername(74);namelength:=5;
curname[16]:=83;curname[17]:=69;curname[18]:=67;curname[19]:=87;
curname[20]:=68;entername(75);namelength:=5;curname[16]:=83;
curname[17]:=69;curname[18]:=67;curname[19]:=72;curname[20]:=84;
entername(76);namelength:=5;curname[16]:=83;curname[17]:=69;
curname[18]:=67;curname[19]:=68;curname[20]:=80;entername(77);
namelength:=5;curname[16]:=83;curname[17]:=69;curname[18]:=67;
curname[19]:=73;curname[20]:=67;entername(78);namelength:=6;
curname[15]:=65;curname[16]:=67;curname[17]:=67;curname[18]:=69;
curname[19]:=78;curname[20]:=84;entername(79);namelength:=11;
curname[10]:=80;curname[11]:=82;curname[12]:=73;curname[13]:=77;
curname[14]:=84;curname[15]:=79;curname[16]:=80;curname[17]:=65;
curname[18]:=88;curname[19]:=73;curname[20]:=83;entername(80);
namelength:=14;curname[7]:=80;curname[8]:=82;curname[9]:=73;
curname[10]:=77;curname[11]:=84;curname[12]:=79;curname[13]:=80;
curname[14]:=65;curname[15]:=88;curname[16]:=73;curname[17]:=83;
curname[18]:=66;curname[19]:=73;curname[20]:=83;entername(81);
namelength:=11;curname[10]:=80;curname[11]:=82;curname[12]:=73;
curname[13]:=77;curname[14]:=66;curname[15]:=79;curname[16]:=84;
curname[17]:=65;curname[18]:=88;curname[19]:=73;curname[20]:=83;
entername(82);namelength:=14;curname[7]:=80;curname[8]:=82;
curname[9]:=73;curname[10]:=77;curname[11]:=66;curname[12]:=79;
curname[13]:=84;curname[14]:=65;curname[15]:=88;curname[16]:=73;
curname[17]:=83;curname[18]:=66;curname[19]:=73;curname[20]:=83;
entername(83);namelength:=10;curname[11]:=80;curname[12]:=82;
curname[13]:=73;curname[14]:=77;curname[15]:=77;curname[16]:=73;
curname[17]:=68;curname[18]:=72;curname[19]:=79;curname[20]:=82;
entername(84);namelength:=10;curname[11]:=80;curname[12]:=82;
curname[13]:=73;curname[14]:=77;curname[15]:=77;curname[16]:=73;
curname[17]:=68;curname[18]:=86;curname[19]:=69;curname[20]:=82;
entername(85);namelength:=13;curname[8]:=80;curname[9]:=82;
curname[10]:=73;curname[11]:=77;curname[12]:=66;curname[13]:=65;
curname[14]:=83;curname[15]:=69;curname[16]:=83;curname[17]:=76;
curname[18]:=65;curname[19]:=78;curname[20]:=84;entername(86);
namelength:=10;curname[11]:=83;curname[12]:=69;curname[13]:=67;
curname[14]:=84;curname[15]:=79;curname[16]:=80;curname[17]:=65;
curname[18]:=88;curname[19]:=73;curname[20]:=83;entername(87);
namelength:=13;curname[8]:=83;curname[9]:=69;curname[10]:=67;
curname[11]:=84;curname[12]:=79;curname[13]:=80;curname[14]:=65;
curname[15]:=88;curname[16]:=73;curname[17]:=83;curname[18]:=66;
curname[19]:=73;curname[20]:=83;entername(88);namelength:=10;
curname[11]:=83;curname[12]:=69;curname[13]:=67;curname[14]:=66;
curname[15]:=79;curname[16]:=84;curname[17]:=65;curname[18]:=88;
curname[19]:=73;curname[20]:=83;entername(89);namelength:=13;
curname[8]:=83;curname[9]:=69;curname[10]:=67;curname[11]:=66;
curname[12]:=79;curname[13]:=84;curname[14]:=65;curname[15]:=88;
curname[16]:=73;curname[17]:=83;curname[18]:=66;curname[19]:=73;
curname[20]:=83;entername(90);namelength:=9;curname[12]:=83;
curname[13]:=69;curname[14]:=67;curname[15]:=77;curname[16]:=73;
curname[17]:=68;curname[18]:=72;curname[19]:=79;curname[20]:=82;
entername(91);namelength:=9;curname[12]:=83;curname[13]:=69;
curname[14]:=67;curname[15]:=77;curname[16]:=73;curname[17]:=68;
curname[18]:=86;curname[19]:=69;curname[20]:=82;entername(92);
namelength:=12;curname[9]:=83;curname[10]:=69;curname[11]:=67;
curname[12]:=66;curname[13]:=65;curname[14]:=83;curname[15]:=69;
curname[16]:=83;curname[17]:=76;curname[18]:=65;curname[19]:=78;
curname[20]:=84;entername(93);namelength:=10;curname[11]:=78;
curname[12]:=69;curname[13]:=88;curname[14]:=84;curname[15]:=76;
curname[16]:=65;curname[17]:=82;curname[18]:=71;curname[19]:=69;
curname[20]:=82;entername(100);namelength:=7;curname[14]:=86;
curname[15]:=65;curname[16]:=82;curname[17]:=67;curname[18]:=72;
curname[19]:=65;curname[20]:=82;entername(117);namelength:=3;
curname[18]:=84;curname[19]:=79;curname[20]:=80;entername(118);
namelength:=3;curname[18]:=77;curname[19]:=73;curname[20]:=68;
entername(119);namelength:=3;curname[18]:=66;curname[19]:=79;
curname[20]:=84;entername(120);namelength:=3;curname[18]:=82;
curname[19]:=69;curname[20]:=80;entername(121);namelength:=3;
curname[18]:=69;curname[19]:=88;curname[20]:=84;entername(121);
namelength:=7;curname[14]:=67;curname[15]:=79;curname[16]:=77;
curname[17]:=77;curname[18]:=69;curname[19]:=78;curname[20]:=84;
entername(0);namelength:=5;curname[16]:=76;curname[17]:=65;
curname[18]:=66;curname[19]:=69;curname[20]:=76;entername(130);
namelength:=4;curname[17]:=83;curname[18]:=84;curname[19]:=79;
curname[20]:=80;entername(131);namelength:=4;curname[17]:=83;
curname[18]:=75;curname[19]:=73;curname[20]:=80;entername(132);
namelength:=3;curname[18]:=75;curname[19]:=82;curname[20]:=78;
entername(133);namelength:=3;curname[18]:=76;curname[19]:=73;
curname[20]:=71;entername(134);namelength:=4;curname[17]:=47;
curname[18]:=76;curname[19]:=73;curname[20]:=71;entername(136);
namelength:=5;curname[16]:=47;curname[17]:=76;curname[18]:=73;
curname[19]:=71;curname[20]:=62;entername(140);namelength:=4;
curname[17]:=76;curname[18]:=73;curname[19]:=71;curname[20]:=47;
entername(135);namelength:=5;curname[16]:=76;curname[17]:=73;
curname[18]:=71;curname[19]:=47;curname[20]:=62;entername(139);
namelength:=5;curname[16]:=47;curname[17]:=76;curname[18]:=73;
curname[19]:=71;curname[20]:=47;entername(137);namelength:=6;
curname[15]:=47;curname[16]:=76;curname[17]:=73;curname[18]:=71;
curname[19]:=47;curname[20]:=62;entername(141);namelength:=7;
curname[14]:=47;curname[15]:=76;curname[16]:=73;curname[17]:=71;
curname[18]:=47;curname[19]:=62;curname[20]:=62;entername(145);
namelength:=6;curname[15]:=67;curname[16]:=76;curname[17]:=65;
curname[18]:=66;curname[19]:=69;curname[20]:=76;entername(150);
namelength:=4;curname[17]:=67;curname[18]:=80;curname[19]:=69;
curname[20]:=78;entername(151);namelength:=5;curname[16]:=67;
curname[17]:=71;curname[18]:=76;curname[19]:=85;curname[20]:=69;
entername(152);namelength:=8;curname[13]:=67;curname[14]:=80;
curname[15]:=69;curname[16]:=78;curname[17]:=71;curname[18]:=76;
curname[19]:=85;curname[20]:=69;entername(153);namelength:=4;
curname[17]:=67;curname[18]:=75;curname[19]:=82;curname[20]:=78;
entername(154);namelength:=8;curname[13]:=79;curname[14]:=70;
curname[15]:=77;curname[16]:=76;curname[17]:=69;curname[18]:=86;
curname[19]:=69;curname[20]:=76;entername(17);namelength:=7;
curname[14]:=70;curname[15]:=79;curname[16]:=78;curname[17]:=84;
curname[18]:=68;curname[19]:=73;curname[20]:=82;entername(15);
namelength:=8;curname[13]:=78;curname[14]:=70;curname[15]:=79;
curname[16]:=78;curname[17]:=84;curname[18]:=68;curname[19]:=73;
curname[20]:=82;entername(16);namelength:=14;curname[7]:=78;
curname[8]:=65;curname[9]:=84;curname[10]:=85;curname[11]:=82;
curname[12]:=65;curname[13]:=76;curname[14]:=70;curname[15]:=79;
curname[16]:=78;curname[17]:=84;curname[18]:=68;curname[19]:=73;
curname[20]:=82;entername(16);namelength:=10;curname[11]:=67;
curname[12]:=72;curname[13]:=65;curname[14]:=82;curname[15]:=82;
curname[16]:=69;curname[17]:=80;curname[18]:=69;curname[19]:=65;
curname[20]:=84;entername(24);namelength:=10;curname[11]:=67;
curname[12]:=72;curname[13]:=65;curname[14]:=82;curname[15]:=73;
curname[16]:=86;curname[17]:=65;curname[18]:=76;curname[19]:=85;
curname[20]:=69;entername(111);namelength:=10;curname[11]:=67;
curname[12]:=72;curname[13]:=65;curname[14]:=82;curname[15]:=70;
curname[16]:=86;curname[17]:=65;curname[18]:=76;curname[19]:=85;
curname[20]:=69;entername(112);namelength:=10;curname[11]:=67;
curname[12]:=72;curname[13]:=65;curname[14]:=82;curname[15]:=77;
curname[16]:=86;curname[17]:=65;curname[18]:=76;curname[19]:=85;
curname[20]:=69;entername(113);namelength:=8;curname[13]:=67;
curname[14]:=72;curname[15]:=65;curname[16]:=82;curname[17]:=82;
curname[18]:=85;curname[19]:=76;curname[20]:=69;entername(114);
namelength:=8;curname[13]:=67;curname[14]:=72;curname[15]:=65;
curname[16]:=82;curname[17]:=71;curname[18]:=76;curname[19]:=85;
curname[20]:=69;entername(115);namelength:=11;curname[10]:=67;
curname[11]:=72;curname[12]:=65;curname[13]:=82;curname[14]:=80;
curname[15]:=69;curname[16]:=78;curname[17]:=65;curname[18]:=76;
curname[19]:=84;curname[20]:=89;entername(116);namelength:=8;
curname[13]:=70;curname[14]:=79;curname[15]:=78;curname[16]:=84;
curname[17]:=82;curname[18]:=85;curname[19]:=76;curname[20]:=69;
entername(18);namelength:=4;curname[17]:=82;curname[18]:=85;
curname[19]:=76;curname[20]:=69;entername(161);namelength:=6;
curname[15]:=82;curname[16]:=85;curname[17]:=76;curname[18]:=69;
curname[19]:=87;curname[20]:=68;entername(162);namelength:=6;
curname[15]:=82;curname[16]:=85;curname[17]:=76;curname[18]:=69;
curname[19]:=72;curname[20]:=84;entername(163);namelength:=6;
curname[15]:=82;curname[16]:=85;curname[17]:=76;curname[18]:=69;
curname[19]:=68;curname[20]:=80;entername(164);namelength:=8;
curname[13]:=70;curname[14]:=79;curname[15]:=78;curname[16]:=84;
curname[17]:=71;curname[18]:=76;curname[19]:=85;curname[20]:=69;
entername(19);namelength:=4;curname[17]:=71;curname[18]:=76;
curname[19]:=85;curname[20]:=69;entername(171);namelength:=8;
curname[13]:=71;curname[14]:=76;curname[15]:=85;curname[16]:=69;
curname[17]:=84;curname[18]:=89;curname[19]:=80;curname[20]:=69;
entername(172);namelength:=16;curname[5]:=71;curname[6]:=76;
curname[7]:=85;curname[8]:=69;curname[9]:=83;curname[10]:=84;
curname[11]:=82;curname[12]:=69;curname[13]:=84;curname[14]:=67;
curname[15]:=72;curname[16]:=79;curname[17]:=82;curname[18]:=68;
curname[19]:=69;curname[20]:=82;entername(173);namelength:=15;
curname[6]:=71;curname[7]:=76;curname[8]:=85;curname[9]:=69;
curname[10]:=83;curname[11]:=72;curname[12]:=82;curname[13]:=73;
curname[14]:=78;curname[15]:=75;curname[16]:=79;curname[17]:=82;
curname[18]:=68;curname[19]:=69;curname[20]:=82;entername(174);
namelength:=8;curname[13]:=71;curname[14]:=76;curname[15]:=85;
curname[16]:=69;curname[17]:=82;curname[18]:=85;curname[19]:=76;
curname[20]:=69;entername(179);namelength:=8;curname[13]:=71;
curname[14]:=76;curname[15]:=85;curname[16]:=69;curname[17]:=67;
curname[18]:=72;curname[19]:=65;curname[20]:=82;entername(178);
namelength:=6;curname[15]:=71;curname[16]:=76;curname[17]:=85;
curname[18]:=69;curname[19]:=87;curname[20]:=68;entername(175);
namelength:=11;curname[10]:=71;curname[11]:=76;curname[12]:=85;
curname[13]:=69;curname[14]:=83;curname[15]:=84;curname[16]:=82;
curname[17]:=69;curname[18]:=84;curname[19]:=67;curname[20]:=72;
entername(176);namelength:=10;curname[11]:=71;curname[12]:=76;
curname[13]:=85;curname[14]:=69;curname[15]:=83;curname[16]:=72;
curname[17]:=82;curname[18]:=73;curname[19]:=78;curname[20]:=75;
entername(177);namelength:=11;curname[10]:=70;curname[11]:=79;
curname[12]:=78;curname[13]:=84;curname[14]:=80;curname[15]:=69;
curname[16]:=78;curname[17]:=65;curname[18]:=76;curname[19]:=84;
curname[20]:=89;entername(20);namelength:=7;curname[14]:=80;
curname[15]:=69;curname[16]:=78;curname[17]:=65;curname[18]:=76;
curname[19]:=84;curname[20]:=89;entername(191);namelength:=10;
curname[11]:=80;curname[12]:=69;curname[13]:=78;curname[14]:=65;
curname[15]:=76;curname[16]:=84;curname[17]:=89;curname[18]:=86;
curname[19]:=65;curname[20]:=76;entername(192);namelength:=10;
curname[11]:=70;curname[12]:=79;curname[13]:=78;curname[14]:=84;
curname[15]:=77;curname[16]:=86;curname[17]:=65;curname[18]:=76;
curname[19]:=85;curname[20]:=69;entername(21);namelength:=6;
curname[15]:=77;curname[16]:=86;curname[17]:=65;curname[18]:=76;
curname[19]:=85;curname[20]:=69;entername(193);namelength:=9;
curname[12]:=77;curname[13]:=86;curname[14]:=65;curname[15]:=76;
curname[16]:=85;curname[17]:=69;curname[18]:=86;curname[19]:=65;
curname[20]:=76;entername(194);namelength:=10;curname[11]:=70;
curname[12]:=79;curname[13]:=78;curname[14]:=84;curname[15]:=70;
curname[16]:=86;curname[17]:=65;curname[18]:=76;curname[19]:=85;
curname[20]:=69;entername(22);namelength:=6;curname[15]:=70;
curname[16]:=86;curname[17]:=65;curname[18]:=76;curname[19]:=85;
curname[20]:=69;entername(195);namelength:=9;curname[12]:=70;
curname[13]:=86;curname[14]:=65;curname[15]:=76;curname[16]:=85;
curname[17]:=69;curname[18]:=86;curname[19]:=65;curname[20]:=76;
entername(196);namelength:=10;curname[11]:=70;curname[12]:=79;
curname[13]:=78;curname[14]:=84;curname[15]:=73;curname[16]:=86;
curname[17]:=65;curname[18]:=76;curname[19]:=85;curname[20]:=69;
entername(23);namelength:=6;curname[15]:=73;curname[16]:=86;
curname[17]:=65;curname[18]:=76;curname[19]:=85;curname[20]:=69;
entername(197);namelength:=9;curname[12]:=73;curname[13]:=86;
curname[14]:=65;curname[15]:=76;curname[16]:=85;curname[17]:=69;
curname[18]:=86;curname[19]:=65;curname[20]:=76;entername(198);{:55};
vplenter;paramenter;end;procedure readligkern;begin{109:}
begin lkstepended:=false;
while level=1 do begin while curchar=32 do getnext;
if curchar=40 then readligkerncommand else if curchar=41 then
skiptoendofitem else junkerror;end;begin loc:=loc-1;level:=level+1;
curchar:=41;end;end{:109};end;procedure outputnewinformationofm;
begin{286:}begin{284:}
begin for iarray:=0 to nki-1 do begin putbyte((npi[iarray])div 16777216,
tfmfile);putbyte(((npi[iarray])mod 16777216)div 65536,tfmfile);
putbyte(((npi[iarray])mod 65536)div 256,tfmfile);
putbyte((npi[iarray])mod 256,tfmfile);end;end{:284};{272:}
begin for farray:=0 to nkf-1 do begin putbyte((npf[farray])div 16777216,
tfmfile);putbyte(((npf[farray])mod 16777216)div 65536,tfmfile);
putbyte(((npf[farray])mod 65536)div 256,tfmfile);
putbyte((npf[farray])mod 256,tfmfile);end;end{:272};{260:}
begin for marray:=0 to nkm-1 do begin putbyte((npm[marray])div 16777216,
tfmfile);putbyte(((npm[marray])mod 16777216)div 65536,tfmfile);
putbyte(((npm[marray])mod 65536)div 256,tfmfile);
putbyte((npm[marray])mod 256,tfmfile);end;end{:260};{224:}
begin for rarray:=0 to nkr-1 do begin putbyte((npr[rarray])div 16777216,
tfmfile);putbyte(((npr[rarray])mod 16777216)div 65536,tfmfile);
putbyte(((npr[rarray])mod 65536)div 256,tfmfile);
putbyte((npr[rarray])mod 256,tfmfile);end;end{:224};{236:}
begin for garray:=0 to nkg-1 do begin putbyte((npg[garray])div 16777216,
tfmfile);putbyte(((npg[garray])mod 16777216)div 65536,tfmfile);
putbyte(((npg[garray])mod 65536)div 256,tfmfile);
putbyte((npg[garray])mod 256,tfmfile);end;end{:236};{248:}
begin for parray:=0 to nkp-1 do begin putbyte((npp[parray])div 16777216,
tfmfile);putbyte(((npp[parray])mod 16777216)div 65536,tfmfile);
putbyte(((npp[parray])mod 65536)div 256,tfmfile);
putbyte((npp[parray])mod 256,tfmfile);end;end{:248};{283:}
begin for iarray:=0 to nki-1 do for inumber:=0 to npi[iarray]-1 do begin
outint(ivalues[iarray,inumber].inval);end;end{:283};{271:}
begin for farray:=0 to nkf-1 do for fnumber:=0 to npf[farray]-1 do begin
outscaled(fvalues[farray,fnumber].fnval);end;end{:271};{259:}
begin for marray:=0 to nkm-1 do for mnumber:=0 to npm[marray]-1 do begin
outscaled(mvalues[marray,mnumber].fnval);end;end{:259};{223:}
begin for rarray:=0 to nkr-1 do for rnumber:=0 to npr[rarray]-1 do begin
outscaled(rules[rarray,rnumber].rnwidth);
outscaled(rules[rarray,rnumber].rnheight);
outscaled(rules[rarray,rnumber].rndepth);end;end{:223};{235:}
begin for garray:=0 to nkg-1 do for gnumber:=0 to npg[garray]-1 do begin
gbyte:=glues[garray,gnumber].gntype*16+glues[garray,gnumber].gnargtype;
putbyte(gbyte,tfmfile);
gbyte:=glues[garray,gnumber].gnstretchorder*16+glues[garray,gnumber].
gnshrinkorder;putbyte(gbyte,tfmfile);
gbyte:=glues[garray,gnumber].gnargument div 256;putbyte(gbyte,tfmfile);
gbyte:=glues[garray,gnumber].gnargument mod 256;putbyte(gbyte,tfmfile);
outscaled(glues[garray,gnumber].gnwidth);
outscaled(glues[garray,gnumber].gnstretch);
outscaled(glues[garray,gnumber].gnshrink);end;end{:235};{247:}
begin for parray:=0 to nkp-1 do for pnumber:=0 to npp[parray]-1 do begin
outint(penalties[parray,pnumber].pnval);end;end{:247};end{:286};end;
procedure computenewheaderofm;begin{285:}begin{282:}begin nwi:=0;
for iarray:=0 to nki do begin npi[iarray]:=npi[iarray]+1;
nwi:=nwi+npi[iarray];end;nki:=nki+1;end{:282};{270:}begin nwf:=0;
for farray:=0 to nkf do begin npf[farray]:=npf[farray]+1;
nwf:=nwf+npf[farray];end;nkf:=nkf+1;end{:270};{258:}begin nwm:=0;
for marray:=0 to nkm do begin npm[marray]:=npm[marray]+1;
nwm:=nwm+npm[marray];end;nkm:=nkm+1;end{:258};{222:}begin nwr:=0;
for rarray:=0 to nkr do begin npr[rarray]:=npr[rarray]+1;
nwr:=nwr+3*npr[rarray];end;nkr:=nkr+1;end{:222};{234:}begin nwg:=0;
for garray:=0 to nkg do begin npg[garray]:=npg[garray]+1;
nwg:=nwg+4*npg[garray];end;nkg:=nkg+1;end{:234};{246:}begin nwp:=0;
for parray:=0 to nkp do begin npp[parray]:=npp[parray]+1;
nwp:=nwp+npp[parray];end;nkp:=nkp+1;end{:246};end{:285};end;
procedure finishextendedfont;begin{127:}
begin if maxpenaltycategory>0 then begin if nkp=0 then begin if
charsonline>0 then writeln(stderr,' ');write(stderr,'No PENALTY table');
showerrorcontext;
end else if npp[0]<maxpenaltycategory then begin if charsonline>0 then
writeln(stderr,' ');write(stderr,'Not enough PENALTY entries');
showerrorcontext;end;end;
if maxgluecategory>0 then begin if nkg=0 then begin if charsonline>0
then writeln(stderr,' ');write(stderr,'No GLUE table');showerrorcontext;
end else if npg[0]<maxgluecategory then begin if charsonline>0 then
writeln(stderr,' ');write(stderr,'Not enough GLUE entries');
showerrorcontext;end;end;
if maxivaluecategory>0 then begin if nki=0 then begin if charsonline>0
then writeln(stderr,' ');write(stderr,'No IVALUE table');
showerrorcontext;
end else if npi[0]<maxivaluecategory then begin if charsonline>0 then
writeln(stderr,' ');write(stderr,'Not enough IVALUE entries');
showerrorcontext;
end else begin for c:=0 to maxchar do begin if(charwd[c]<>0)then begin
for j:=0 to maxivaluecategory do if chartable[c,0]=j then begin if
categoryremainders[j]<>-1 then begin if chartag[c]<>0 then begin if
charsonline>0 then writeln(stderr,' ');
write(stderr,'Character already has a tag');showerrorcontext;
end else begin charextendedtag[c]:=true;
charremainder[c]:=categoryremainders[j];end;end;end;end;end;end;end;
end{:127};end;procedure outputsubfilesizes;begin{183:}
case ofmlevel of-1:begin putbyte((lf)div 256,tfmfile);
putbyte((lf)mod 256,tfmfile);putbyte((lh)div 256,tfmfile);
putbyte((lh)mod 256,tfmfile);putbyte((bc)div 256,tfmfile);
putbyte((bc)mod 256,tfmfile);putbyte((ec)div 256,tfmfile);
putbyte((ec)mod 256,tfmfile);putbyte((memory[1])div 256,tfmfile);
putbyte((memory[1])mod 256,tfmfile);putbyte((memory[2])div 256,tfmfile);
putbyte((memory[2])mod 256,tfmfile);putbyte((memory[3])div 256,tfmfile);
putbyte((memory[3])mod 256,tfmfile);putbyte((memory[4])div 256,tfmfile);
putbyte((memory[4])mod 256,tfmfile);
putbyte((nl+lkoffset)div 256,tfmfile);
putbyte((nl+lkoffset)mod 256,tfmfile);putbyte((nk)div 256,tfmfile);
putbyte((nk)mod 256,tfmfile);putbyte((ne)div 256,tfmfile);
putbyte((ne)mod 256,tfmfile);putbyte((np)div 256,tfmfile);
putbyte((np)mod 256,tfmfile);end;
0:begin putbyte((0)div 16777216,tfmfile);
putbyte(((0)mod 16777216)div 65536,tfmfile);
putbyte(((0)mod 65536)div 256,tfmfile);putbyte((0)mod 256,tfmfile);
putbyte((lf)div 16777216,tfmfile);
putbyte(((lf)mod 16777216)div 65536,tfmfile);
putbyte(((lf)mod 65536)div 256,tfmfile);putbyte((lf)mod 256,tfmfile);
putbyte((lh)div 16777216,tfmfile);
putbyte(((lh)mod 16777216)div 65536,tfmfile);
putbyte(((lh)mod 65536)div 256,tfmfile);putbyte((lh)mod 256,tfmfile);
putbyte((bc)div 16777216,tfmfile);
putbyte(((bc)mod 16777216)div 65536,tfmfile);
putbyte(((bc)mod 65536)div 256,tfmfile);putbyte((bc)mod 256,tfmfile);
putbyte((ec)div 16777216,tfmfile);
putbyte(((ec)mod 16777216)div 65536,tfmfile);
putbyte(((ec)mod 65536)div 256,tfmfile);putbyte((ec)mod 256,tfmfile);
putbyte((memory[1])div 16777216,tfmfile);
putbyte(((memory[1])mod 16777216)div 65536,tfmfile);
putbyte(((memory[1])mod 65536)div 256,tfmfile);
putbyte((memory[1])mod 256,tfmfile);
putbyte((memory[2])div 16777216,tfmfile);
putbyte(((memory[2])mod 16777216)div 65536,tfmfile);
putbyte(((memory[2])mod 65536)div 256,tfmfile);
putbyte((memory[2])mod 256,tfmfile);
putbyte((memory[3])div 16777216,tfmfile);
putbyte(((memory[3])mod 16777216)div 65536,tfmfile);
putbyte(((memory[3])mod 65536)div 256,tfmfile);
putbyte((memory[3])mod 256,tfmfile);
putbyte((memory[4])div 16777216,tfmfile);
putbyte(((memory[4])mod 16777216)div 65536,tfmfile);
putbyte(((memory[4])mod 65536)div 256,tfmfile);
putbyte((memory[4])mod 256,tfmfile);
putbyte((nl+lkoffset)div 16777216,tfmfile);
putbyte(((nl+lkoffset)mod 16777216)div 65536,tfmfile);
putbyte(((nl+lkoffset)mod 65536)div 256,tfmfile);
putbyte((nl+lkoffset)mod 256,tfmfile);putbyte((nk)div 16777216,tfmfile);
putbyte(((nk)mod 16777216)div 65536,tfmfile);
putbyte(((nk)mod 65536)div 256,tfmfile);putbyte((nk)mod 256,tfmfile);
putbyte((ne)div 16777216,tfmfile);
putbyte(((ne)mod 16777216)div 65536,tfmfile);
putbyte(((ne)mod 65536)div 256,tfmfile);putbyte((ne)mod 256,tfmfile);
putbyte((np)div 16777216,tfmfile);
putbyte(((np)mod 16777216)div 65536,tfmfile);
putbyte(((np)mod 65536)div 256,tfmfile);putbyte((np)mod 256,tfmfile);
putbyte((fontdir)div 16777216,tfmfile);
putbyte(((fontdir)mod 16777216)div 65536,tfmfile);
putbyte(((fontdir)mod 65536)div 256,tfmfile);
putbyte((fontdir)mod 256,tfmfile);end;
1:begin putbyte((1)div 16777216,tfmfile);
putbyte(((1)mod 16777216)div 65536,tfmfile);
putbyte(((1)mod 65536)div 256,tfmfile);putbyte((1)mod 256,tfmfile);
putbyte((lf)div 16777216,tfmfile);
putbyte(((lf)mod 16777216)div 65536,tfmfile);
putbyte(((lf)mod 65536)div 256,tfmfile);putbyte((lf)mod 256,tfmfile);
putbyte((lh)div 16777216,tfmfile);
putbyte(((lh)mod 16777216)div 65536,tfmfile);
putbyte(((lh)mod 65536)div 256,tfmfile);putbyte((lh)mod 256,tfmfile);
putbyte((bc)div 16777216,tfmfile);
putbyte(((bc)mod 16777216)div 65536,tfmfile);
putbyte(((bc)mod 65536)div 256,tfmfile);putbyte((bc)mod 256,tfmfile);
putbyte((ec)div 16777216,tfmfile);
putbyte(((ec)mod 16777216)div 65536,tfmfile);
putbyte(((ec)mod 65536)div 256,tfmfile);putbyte((ec)mod 256,tfmfile);
putbyte((memory[1])div 16777216,tfmfile);
putbyte(((memory[1])mod 16777216)div 65536,tfmfile);
putbyte(((memory[1])mod 65536)div 256,tfmfile);
putbyte((memory[1])mod 256,tfmfile);
putbyte((memory[2])div 16777216,tfmfile);
putbyte(((memory[2])mod 16777216)div 65536,tfmfile);
putbyte(((memory[2])mod 65536)div 256,tfmfile);
putbyte((memory[2])mod 256,tfmfile);
putbyte((memory[3])div 16777216,tfmfile);
putbyte(((memory[3])mod 16777216)div 65536,tfmfile);
putbyte(((memory[3])mod 65536)div 256,tfmfile);
putbyte((memory[3])mod 256,tfmfile);
putbyte((memory[4])div 16777216,tfmfile);
putbyte(((memory[4])mod 16777216)div 65536,tfmfile);
putbyte(((memory[4])mod 65536)div 256,tfmfile);
putbyte((memory[4])mod 256,tfmfile);
putbyte((nl+lkoffset)div 16777216,tfmfile);
putbyte(((nl+lkoffset)mod 16777216)div 65536,tfmfile);
putbyte(((nl+lkoffset)mod 65536)div 256,tfmfile);
putbyte((nl+lkoffset)mod 256,tfmfile);putbyte((nk)div 16777216,tfmfile);
putbyte(((nk)mod 16777216)div 65536,tfmfile);
putbyte(((nk)mod 65536)div 256,tfmfile);putbyte((nk)mod 256,tfmfile);
putbyte((ne)div 16777216,tfmfile);
putbyte(((ne)mod 16777216)div 65536,tfmfile);
putbyte(((ne)mod 65536)div 256,tfmfile);putbyte((ne)mod 256,tfmfile);
putbyte((np)div 16777216,tfmfile);
putbyte(((np)mod 16777216)div 65536,tfmfile);
putbyte(((np)mod 65536)div 256,tfmfile);putbyte((np)mod 256,tfmfile);
putbyte((fontdir)div 16777216,tfmfile);
putbyte(((fontdir)mod 16777216)div 65536,tfmfile);
putbyte(((fontdir)mod 65536)div 256,tfmfile);
putbyte((fontdir)mod 256,tfmfile);putbyte((nco)div 16777216,tfmfile);
putbyte(((nco)mod 16777216)div 65536,tfmfile);
putbyte(((nco)mod 65536)div 256,tfmfile);putbyte((nco)mod 256,tfmfile);
putbyte((ncw)div 16777216,tfmfile);
putbyte(((ncw)mod 16777216)div 65536,tfmfile);
putbyte(((ncw)mod 65536)div 256,tfmfile);putbyte((ncw)mod 256,tfmfile);
putbyte((npc)div 16777216,tfmfile);
putbyte(((npc)mod 16777216)div 65536,tfmfile);
putbyte(((npc)mod 65536)div 256,tfmfile);putbyte((npc)mod 256,tfmfile);
putbyte((nki)div 16777216,tfmfile);
putbyte(((nki)mod 16777216)div 65536,tfmfile);
putbyte(((nki)mod 65536)div 256,tfmfile);putbyte((nki)mod 256,tfmfile);
putbyte((nwi)div 16777216,tfmfile);
putbyte(((nwi)mod 16777216)div 65536,tfmfile);
putbyte(((nwi)mod 65536)div 256,tfmfile);putbyte((nwi)mod 256,tfmfile);
putbyte((nkf)div 16777216,tfmfile);
putbyte(((nkf)mod 16777216)div 65536,tfmfile);
putbyte(((nkf)mod 65536)div 256,tfmfile);putbyte((nkf)mod 256,tfmfile);
putbyte((nwf)div 16777216,tfmfile);
putbyte(((nwf)mod 16777216)div 65536,tfmfile);
putbyte(((nwf)mod 65536)div 256,tfmfile);putbyte((nwf)mod 256,tfmfile);
putbyte((nkm)div 16777216,tfmfile);
putbyte(((nkm)mod 16777216)div 65536,tfmfile);
putbyte(((nkm)mod 65536)div 256,tfmfile);putbyte((nkm)mod 256,tfmfile);
putbyte((nwm)div 16777216,tfmfile);
putbyte(((nwm)mod 16777216)div 65536,tfmfile);
putbyte(((nwm)mod 65536)div 256,tfmfile);putbyte((nwm)mod 256,tfmfile);
putbyte((nkr)div 16777216,tfmfile);
putbyte(((nkr)mod 16777216)div 65536,tfmfile);
putbyte(((nkr)mod 65536)div 256,tfmfile);putbyte((nkr)mod 256,tfmfile);
putbyte((nwr)div 16777216,tfmfile);
putbyte(((nwr)mod 16777216)div 65536,tfmfile);
putbyte(((nwr)mod 65536)div 256,tfmfile);putbyte((nwr)mod 256,tfmfile);
putbyte((nkg)div 16777216,tfmfile);
putbyte(((nkg)mod 16777216)div 65536,tfmfile);
putbyte(((nkg)mod 65536)div 256,tfmfile);putbyte((nkg)mod 256,tfmfile);
putbyte((nwg)div 16777216,tfmfile);
putbyte(((nwg)mod 16777216)div 65536,tfmfile);
putbyte(((nwg)mod 65536)div 256,tfmfile);putbyte((nwg)mod 256,tfmfile);
putbyte((nkp)div 16777216,tfmfile);
putbyte(((nkp)mod 16777216)div 65536,tfmfile);
putbyte(((nkp)mod 65536)div 256,tfmfile);putbyte((nkp)mod 256,tfmfile);
putbyte((nwp)div 16777216,tfmfile);
putbyte(((nwp)mod 16777216)div 65536,tfmfile);
putbyte(((nwp)mod 65536)div 256,tfmfile);putbyte((nwp)mod 256,tfmfile);
end;end;{:183};end;procedure computesubfilesizes;begin{182:}
lh:=headerptr div 4;notfound:=true;bc:=0;
if(ofmlevel=-1)then ec:=255 else ec:=maxchar;
while notfound do if(charwd[bc]>0)or(bc=ec)then notfound:=false else bc
:=bc+1;notfound:=true;
while notfound do if(charwd[ec]>0)or(ec=0)then notfound:=false else ec:=
ec-1;if bc>ec then bc:=1;memory[1]:=memory[1]+1;memory[2]:=memory[2]+1;
memory[3]:=memory[3]+1;memory[4]:=memory[4]+1;{193:}{194:}labelptr:=0;
labeltable[0].rr:=-1;
for c:=bc to ec do if chartag[c]=1 then begin sortptr:=labelptr;
while labeltable[sortptr].rr>charremainder[c]do begin labeltable[sortptr
+1]:=labeltable[sortptr];sortptr:=sortptr-1;end;
labeltable[sortptr+1].cc:=c;labeltable[sortptr+1].rr:=charremainder[c];
labelptr:=labelptr+1;end{:194};
if bchar<xmaxchar then begin extralocneeded:=true;lkoffset:=1;
end else begin extralocneeded:=false;lkoffset:=0;end;{195:}
begin sortptr:=labelptr;
if ofmlevel=-1 then begin if labeltable[sortptr].rr+lkoffset>255 then
begin lkoffset:=0;extralocneeded:=false;
repeat charremainder[labeltable[sortptr].cc]:=lkoffset;
while labeltable[sortptr-1].rr=labeltable[sortptr].rr do begin sortptr:=
sortptr-1;charremainder[labeltable[sortptr].cc]:=lkoffset;end;
lkoffset:=lkoffset+1;sortptr:=sortptr-1;
until lkoffset+labeltable[sortptr].rr<256;end;
end else begin if labeltable[sortptr].rr+lkoffset>65535 then begin
lkoffset:=0;extralocneeded:=false;
repeat charremainder[labeltable[sortptr].cc]:=lkoffset;
while labeltable[sortptr-1].rr=labeltable[sortptr].rr do begin sortptr:=
sortptr-1;charremainder[labeltable[sortptr].cc]:=lkoffset;end;
lkoffset:=lkoffset+1;sortptr:=sortptr-1;
until lkoffset+labeltable[sortptr].rr<65536;end;end;
if lkoffset>0 then while sortptr>0 do begin charremainder[labeltable[
sortptr].cc]:=charremainder[labeltable[sortptr].cc]+lkoffset;
sortptr:=sortptr-1;end;end{:195};
if charremainder[xmaxchar]<xmaxlabel then begin if ofmlevel=-1 then
begin ligkern[nl-1].b2:=(charremainder[xmaxchar]+lkoffset)div 256;
ligkern[nl-1].b3:=(charremainder[xmaxchar]+lkoffset)mod 256;
end else begin ligkern[nl-1].b2:=(charremainder[xmaxchar]+lkoffset)div
65536;ligkern[nl-1].b3:=(charremainder[xmaxchar]+lkoffset)mod 65536;
end end{:193};
case ofmlevel of-1:begin lf:=6+lh+(ec-bc+1)+memory[1]+memory[2]+memory[3
]+memory[4]+nl+lkoffset+nk+ne+np;end;
0:begin lf:=14+lh+2*(ec-bc+1)+memory[1]+memory[2]+memory[3]+memory[4]+2*
(nl+lkoffset)+nk+2*ne+np;end;1:begin{188:}
if ofmlevel=1 then begin ncw:=0;npc:=npc+1;neededspace:=(12+npc*2)div 4;
extrabytes:=(neededspace*4)-(10+npc*2);
for c:=bc to ec do begin if charoriginal[c]=c then begin cprime:=c+1;
diff:=false;
while(not diff)and(cprime<=ec)and(cprime-c<65536)do begin if indexvar[
charwd[c]]<>indexvar[charwd[cprime]]then diff:=true;
if indexvar[charht[c]]<>indexvar[charht[cprime]]then diff:=true;
if indexvar[chardp[c]]<>indexvar[chardp[cprime]]then diff:=true;
if indexvar[charic[c]]<>indexvar[charic[cprime]]then diff:=true;
if chartag[c]<>chartag[cprime]then diff:=true;
if charremainder[c]<>charremainder[cprime]then diff:=true;
for tab:=0 to npc-1 do begin if chartable[c,tab]<>chartable[cprime,tab]
then diff:=true;end;if not diff then begin charoriginal[cprime]:=c;
cprime:=cprime+1;end;end;
if cprime>(c+1)then begin charrepeats[c]:=cprime-c-1;end;
ncw:=ncw+neededspace;end;end;end;{:188};
lf:=29+lh+ncw+memory[1]+memory[2]+memory[3]+memory[4]+2*(nl+lkoffset)+nk
+2*ne+np+nki+nwi+nkf+nwf+nkm+nwm+nkr+nwr+nkg+nwg+nkp+nwp;
nco:=29+lh+nki+nwi+nkf+nwf+nkm+nwm+nkr+nwr+nkg+nwg+nkp+nwp;end;end;
{:182};end;procedure outputcharacterinfo;begin{189:}indexvar[0]:=0;
for c:=bc to ec do case ofmlevel of-1:begin putbyte(indexvar[charwd[c]],
tfmfile);putbyte(indexvar[charht[c]]*16+indexvar[chardp[c]],tfmfile);
putbyte(indexvar[charic[c]]*4+chartag[c],tfmfile);
putbyte(charremainder[c],tfmfile);end;
0:begin putbyte(indexvar[charwd[c]]div 256,tfmfile);
putbyte(indexvar[charwd[c]]mod 256,tfmfile);
putbyte(indexvar[charht[c]],tfmfile);
putbyte(indexvar[chardp[c]],tfmfile);
putbyte(indexvar[charic[c]],tfmfile);putbyte(chartag[c],tfmfile);
putbyte(charremainder[c]div 256,tfmfile);
putbyte(charremainder[c]mod 256,tfmfile);end;
1:begin if c=charoriginal[c]then begin putbyte(indexvar[charwd[c]]div
256,tfmfile);putbyte(indexvar[charwd[c]]mod 256,tfmfile);
putbyte(indexvar[charht[c]],tfmfile);
putbyte(indexvar[chardp[c]],tfmfile);
putbyte(indexvar[charic[c]],tfmfile);tab:=chartag[c];
if charextendedtag[c]then begin tab:=5;end;putbyte(tab,tfmfile);
putbyte(charremainder[c]div 256,tfmfile);
putbyte(charremainder[c]mod 256,tfmfile);
putbyte((charrepeats[c])div 256,tfmfile);
putbyte((charrepeats[c])mod 256,tfmfile);
for tab:=0 to npc-1 do begin putbyte(chartable[c,tab]div 256,tfmfile);
putbyte(chartable[c,tab]mod 256,tfmfile);end;
for tab:=1 to extrabytes do begin putbyte(0,tfmfile);end;end;end;end;
{:189};end;procedure readfontrulelist;begin{217:}
begin if tablesread then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'All parameter tables must appear before character info');
showerrorcontext;end;skiptoendofitem;end;rarray:=getinteger;
if rarray>rulearrays then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'This FONTRULE table index is too big for my present size')
;showerrorcontext;end;skiptoendofitem;
end else if rarray<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This FONTRULE index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin if rarray>nkr then nkr:=rarray;
while level=1 do begin while curchar=32 do getnext;
if curchar=40 then{218:}begin getname;
if curcode=0 then skiptoendofitem else if curcode<>161 then begin begin
if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a FONTRULE list');
showerrorcontext;end;skiptoendofitem;end else begin rnumber:=getinteger;
if rnumber>ruleentries then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'This RULE index is too big for my present table size');
showerrorcontext;end;skiptoendofitem;
end else if rnumber<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This RULE index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin while npr[rarray]<rnumber do begin npr[rarray]:=npr[
rarray]+1;{219:}begin rules[rarray,npr[rarray]].rnwidth:=0;
rules[rarray,npr[rarray]].rndepth:=0;
rules[rarray,npr[rarray]].rnheight:=0;end{:219};end;{220:}
begin while level=2 do begin while curchar=32 do getnext;
if curchar=40 then{221:}begin getname;
if curcode=0 then skiptoendofitem else if(curcode<162)or(curcode>164)
then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a RULE list');
showerrorcontext;end;skiptoendofitem;
end else begin case curcode of 162:rules[rarray,rnumber].rnwidth:=getfix
;163:rules[rarray,rnumber].rnheight:=getfix;
164:rules[rarray,rnumber].rndepth:=getfix;end;finishtheproperty;end;
end{:221}else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end{:220};
finishtheproperty;end;end;end{:218}
else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end;end{:217};end;
procedure readfontgluelist;begin{229:}
begin if tablesread then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'All parameter tables must appear before character info');
showerrorcontext;end;skiptoendofitem;end;garray:=getinteger;
if garray>gluearrays then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'This FONTGLUE table index is too big for my present size')
;showerrorcontext;end;skiptoendofitem;
end else if garray<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This FONTGLUE index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin if garray>nkg then nkg:=garray;
while level=1 do begin while curchar=32 do getnext;
if curchar=40 then{230:}begin getname;
if curcode=0 then skiptoendofitem else if curcode<>171 then begin begin
if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a FONTGLUE list');
showerrorcontext;end;skiptoendofitem;end else begin gnumber:=getinteger;
if gnumber>glueentries then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'This GLUE index is too big for my present table size');
showerrorcontext;end;skiptoendofitem;
end else if gnumber<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This GLUE index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin while npg[garray]<gnumber do begin npg[garray]:=npg[
garray]+1;{231:}begin glues[garray,npg[garray]].gnwidth:=0;
glues[garray,npg[garray]].gnstretch:=0;
glues[garray,npg[garray]].gnshrink:=0;
glues[garray,npg[garray]].gntype:=0;
glues[garray,npg[garray]].gnargtype:=0;
glues[garray,npg[garray]].gnstretchorder:=0;
glues[garray,npg[garray]].gnshrinkorder:=0;
glues[garray,npg[garray]].gnargument:=0;end{:231};end;{232:}
begin while level=2 do begin while curchar=32 do getnext;
if curchar=40 then{233:}begin getname;
if curcode=0 then skiptoendofitem else if(curcode<172)or(curcode>179)
then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a GLUE list');
showerrorcontext;end;skiptoendofitem;
end else begin case curcode of 175:glues[garray,gnumber].gnwidth:=getfix
;176:glues[garray,gnumber].gnstretch:=getfix;
177:glues[garray,gnumber].gnshrink:=getfix;172:begin gbyte:=getinteger;
if(gbyte<0)or(gbyte>3)then begin gbyte:=0;end;
glues[garray,gnumber].gntype:=gbyte;end;173:begin gbyte:=getinteger;
if(gbyte<0)or(gbyte>4)then begin gbyte:=0;end;
glues[garray,gnumber].gnstretchorder:=gbyte;end;
174:begin gbyte:=getinteger;if(gbyte<0)or(gbyte>4)then begin gbyte:=0;
end;glues[garray,gnumber].gnshrinkorder:=gbyte;end;
178:begin glues[garray,gnumber].gnargument:=getinteger;
glues[garray,gnumber].gnargtype:=2;end;
179:begin glues[garray,gnumber].gnargument:=getinteger;
glues[garray,gnumber].gnargtype:=1;end;end;finishtheproperty;end;
end{:233}else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end{:232};
finishtheproperty;end;end;end{:230}
else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end;end{:229};end;
procedure readfontpenaltylist;begin{241:}
begin if tablesread then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'All parameter tables must appear before character info');
showerrorcontext;end;skiptoendofitem;end;parray:=getinteger;
if parray>penaltyarrays then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,
'This FONTPENALTY table index is too big for my present size');
showerrorcontext;end;skiptoendofitem;
end else if parray<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This FONTPENALTY index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin if parray>nkp then nkp:=parray;
while level=1 do begin while curchar=32 do getnext;
if curchar=40 then{242:}begin getname;
if curcode=0 then skiptoendofitem else if curcode<>191 then begin begin
if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a FONTPENALTY list')
;showerrorcontext;end;skiptoendofitem;
end else begin pnumber:=getinteger;
if pnumber>penaltyentries then begin begin if charsonline>0 then writeln
(stderr,' ');
write(stderr,'This PENALTY index is too big for my present table size');
showerrorcontext;end;skiptoendofitem;
end else if pnumber<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This PENALTY index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin while npp[parray]<pnumber do begin npp[parray]:=npp[
parray]+1;{243:}begin penalties[parray,npp[parray]].pnval:=0;end{:243};
end;{244:}begin while level=2 do begin while curchar=32 do getnext;
if curchar=40 then{245:}begin getname;
if curcode=0 then skiptoendofitem else if curcode<>192 then begin begin
if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a PENALTY list');
showerrorcontext;end;skiptoendofitem;
end else begin penalties[parray,pnumber].pnval:=getinteger;
finishtheproperty;end;end{:245}
else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end{:244};
finishtheproperty;end;end;end{:242}
else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end;end{:241};end;
procedure readfontmvaluelist;begin{253:}
begin if tablesread then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'All parameter tables must appear before character info');
showerrorcontext;end;skiptoendofitem;end;marray:=getinteger;
if marray>mvaluearrays then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,
'This FONTMVALUE table index is too big for my present size');
showerrorcontext;end;skiptoendofitem;
end else if marray<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This FONTMVALUE index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin if marray>nkm then nkm:=marray;
while level=1 do begin while curchar=32 do getnext;
if curchar=40 then{254:}begin getname;
if curcode=0 then skiptoendofitem else if curcode<>193 then begin begin
if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in an FONTMVALUE list')
;showerrorcontext;end;skiptoendofitem;
end else begin mnumber:=getinteger;
if mnumber>mvalueentries then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'This MVALUE index is too big for my present table size');
showerrorcontext;end;skiptoendofitem;
end else if mnumber<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This MVALUE index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin while npm[marray]<mnumber do begin npm[marray]:=npm[
marray]+1;{255:}begin mvalues[marray,npm[marray]].fnval:=0;end{:255};
end;{256:}begin while level=2 do begin while curchar=32 do getnext;
if curchar=40 then{257:}begin getname;
if curcode=0 then skiptoendofitem else if curcode<>194 then begin begin
if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a MVALUE list');
showerrorcontext;end;skiptoendofitem;
end else begin mvalues[marray,mnumber].fnval:=getfix;finishtheproperty;
end;end{:257}else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end{:256};
finishtheproperty;end;end;end{:254}
else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end;end{:253};end;
procedure readfontfvaluelist;begin{265:}
begin if tablesread then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'All parameter tables must appear before character info');
showerrorcontext;end;skiptoendofitem;end;farray:=getinteger;
if farray>fvaluearrays then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,
'This FONTFVALUE table index is too big for my present size');
showerrorcontext;end;skiptoendofitem;
end else if farray<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This FONTFVALUE index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin if farray>nkf then nkf:=farray;
while level=1 do begin while curchar=32 do getnext;
if curchar=40 then{266:}begin getname;
if curcode=0 then skiptoendofitem else if curcode<>195 then begin begin
if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in an FONTFVALUE list')
;showerrorcontext;end;skiptoendofitem;
end else begin fnumber:=getinteger;
if fnumber>fvalueentries then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'This FVALUE index is too big for my present table size');
showerrorcontext;end;skiptoendofitem;
end else if fnumber<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This FVALUE index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin while npf[farray]<fnumber do begin npf[farray]:=npf[
farray]+1;{267:}begin fvalues[farray,npf[farray]].fnval:=0;end{:267};
end;{268:}begin while level=2 do begin while curchar=32 do getnext;
if curchar=40 then{269:}begin getname;
if curcode=0 then skiptoendofitem else if curcode<>196 then begin begin
if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a FVALUE list');
showerrorcontext;end;skiptoendofitem;
end else begin fvalues[farray,fnumber].fnval:=getfix;finishtheproperty;
end;end{:269}else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end{:268};
finishtheproperty;end;end;end{:266}
else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end;end{:265};end;
procedure readfontivaluelist;begin{277:}
begin if tablesread then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'All parameter tables must appear before character info');
showerrorcontext;end;skiptoendofitem;end;iarray:=getinteger;
if iarray>ivaluearrays then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,
'This FONTIVALUE table index is too big for my present size');
showerrorcontext;end;skiptoendofitem;
end else if iarray<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This FONTIVALUE index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin if iarray>nki then nki:=iarray;
while level=1 do begin while curchar=32 do getnext;
if curchar=40 then{278:}begin getname;
if curcode=0 then skiptoendofitem else if curcode<>197 then begin begin
if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in an FONTIVALUE list')
;showerrorcontext;end;skiptoendofitem;
end else begin inumber:=getinteger;
if inumber>ivalueentries then begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'This IVALUE index is too big for my present table size');
showerrorcontext;end;skiptoendofitem;
end else if inumber<0 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'This IVALUE index is negative');
showerrorcontext;end;skiptoendofitem;
end else begin while npi[iarray]<inumber do begin npi[iarray]:=npi[
iarray]+1;{279:}begin ivalues[iarray,npi[iarray]].inval:=0;end{:279};
end;{280:}begin while level=2 do begin while curchar=32 do getnext;
if curchar=40 then{281:}begin getname;
if curcode=0 then skiptoendofitem else if curcode<>198 then begin begin
if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a IVALUE list');
showerrorcontext;end;skiptoendofitem;
end else begin ivalues[iarray,inumber].inval:=getinteger;
finishtheproperty;end;end{:281}
else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end{:280};
finishtheproperty;end;end;end{:278}
else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end;end{:277};end;
procedure readrepeatedcharacterinfo;begin{133:}
begin if not tablesread then begin computenewheaderofm;tablesread:=true;
end;c:=getcharcode;if verbose then{145:}
begin if charsonline>=8 then begin writeln(stderr,' ');charsonline:=1;
end else begin if charsonline>0 then write(stderr,' ');
charsonline:=charsonline+1;end;printnumber(c,16);end{:145};
crange:=getbyte;
if(crange<0)then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Character ranges must be positive');showerrorcontext;end;
crange:=0;end;
if((c+crange)>maxchar)then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'Character range too large');showerrorcontext;
end;crange:=0;end;if verbose then begin write(stderr,'-');
printnumber(c+crange,16);charsonline:=charsonline+1;end;
while level=1 do begin while curchar=32 do getnext;
if curchar=40 then readcharacterproperty else if curchar=41 then
skiptoendofitem else junkerror;end;
if charwd[c]=0 then charwd[c]:=sortin(1,0);begin loc:=loc-1;
level:=level+1;curchar:=41;end;cprime:=c;
for c:=(cprime+1)to(cprime+crange)do begin charwd[c]:=charwd[cprime];
charht[c]:=charht[cprime];chardp[c]:=chardp[cprime];
charic[c]:=charic[cprime];chartag[c]:=chartag[cprime];
charremainder[c]:=charremainder[cprime];
packetstart[c]:=packetstart[cprime];
packetlength[c]:=packetlength[cprime];
for tab:=0 to(nki+nkf+nkm+nkr+nkg+nkp-1)do begin chartable[c,tab]:=
chartable[cprime,tab];end;end;end{:133};end;
procedure readligkerncommand;begin{110:}begin getname;
if curcode=0 then skiptoendofitem else if(curcode<130)or(curcode>154)
then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a LIGTABLE list');
showerrorcontext;end;skiptoendofitem;
end else begin case curcode of 130:{112:}
begin while curchar=32 do getnext;
if curchar=66 then begin charremainder[xmaxchar]:=nl;
repeat getnext until(curchar=40)or(curchar=41);
end else begin begin if(curchar>41)or(curchar<40)then loc:=loc-1;end;
c:=getcharcode;checktag(c);chartag[c]:=1;charremainder[c]:=nl;end;
if minnl<=nl then minnl:=nl+1;lkstepended:=false;end{:112};131:{114:}
if not lkstepended then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'STOP must follow LIG or KRN');showerrorcontext;
end else begin ligkern[nl-1].b0:=ligkern[nl-1].b0 div 256*256+128;
lkstepended:=false;end{:114};132:{115:}
if not lkstepended then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'SKIP must follow LIG or KRN');showerrorcontext;
end else begin c:=getbyte;
if c>=128 then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Maximum SKIP amount is 127');showerrorcontext;
end else if nl+c>=maxligsteps then begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'Sorry, LIGTABLE too long for me to handle');
showerrorcontext;end else begin ligkern[nl-1].b0:=c;
if minnl<=nl+c then minnl:=nl+c+1;end;lkstepended:=false;end{:115};
133:{117:}begin ligkern[nl].b0:=0;ligkern[nl].b1:=getbyte;
kern[nk]:=getfix;krnptr:=0;
while kern[krnptr]<>kern[nk]do krnptr:=krnptr+1;
if krnptr=nk then begin if nk<maxkerns then nk:=nk+1 else begin begin if
charsonline>0 then writeln(stderr,' ');
write(stderr,'Sorry, too many different kerns for me to handle');
showerrorcontext;end;krnptr:=krnptr-1;end;end;
if ofmlevel=-1 then begin ligkern[nl].b2:=128+(krnptr div 256);
ligkern[nl].b3:=krnptr mod 256;
end else begin ligkern[nl].b2:=128+(krnptr div 65536);
ligkern[nl].b3:=krnptr mod 65536;end;
if nl>=maxligsteps-1 then begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Sorry, LIGTABLE too long for me to handle');
showerrorcontext;end else nl:=nl+1;lkstepended:=true;end{:117};
134,135,136,137,139,140,141,145:{116:}begin ligkern[nl].b0:=0;
ligkern[nl].b2:=curcode-134;ligkern[nl].b1:=getbyte;
ligkern[nl].b3:=getbyte;
if nl>=maxligsteps-1 then begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Sorry, LIGTABLE too long for me to handle');
showerrorcontext;end else nl:=nl+1;lkstepended:=true;end{:116};
150:{120:}begin c:=getcharcode;categoryremainders[c]:=nl;
if maxivaluecategory<c then maxivaluecategory:=c;
if minnl<=nl then minnl:=nl+1;lkstepended:=false;end{:120};151:{121:}
begin ligkern[nl].b0:=256;ligkern[nl].b1:=getbyte;ligkern[nl].b2:=17;
penaltycategory:=getbyte;
if maxpenaltycategory<penaltycategory then maxpenaltycategory:=
penaltycategory;ligkern[nl].b3:=penaltycategory;
if nl>=maxligsteps-1 then begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Sorry, LIGTABLE too long for me to handle');
showerrorcontext;end else nl:=nl+1;lkstepended:=true;end{:121};
152:{122:}begin ligkern[nl].b0:=256;ligkern[nl].b1:=getbyte;
ligkern[nl].b2:=18;gluecategory:=getbyte;
if maxgluecategory<gluecategory then maxgluecategory:=gluecategory;
ligkern[nl].b3:=gluecategory;
if nl>=maxligsteps-1 then begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Sorry, LIGTABLE too long for me to handle');
showerrorcontext;end else nl:=nl+1;lkstepended:=true;end{:122};
153:{123:}begin ligkern[nl].b0:=256;ligkern[nl].b1:=getbyte;
ligkern[nl].b2:=19;penaltycategory:=getbyte;
if maxpenaltycategory<penaltycategory then maxpenaltycategory:=
penaltycategory;gluecategory:=getbyte;
if maxgluecategory<gluecategory then maxgluecategory:=gluecategory;
ligkern[nl].b3:=penaltycategory*256+gluecategory;
if nl>=maxligsteps-1 then begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Sorry, LIGTABLE too long for me to handle');
showerrorcontext;end else nl:=nl+1;lkstepended:=true;end{:123};
154:{124:}begin ligkern[nl].b0:=256;ligkern[nl].b1:=getbyte;
ligkern[nl].b2:=20;kern[nk]:=getfix;krnptr:=0;
while kern[krnptr]<>kern[nk]do krnptr:=krnptr+1;
if krnptr=nk then begin if nk<maxkerns then nk:=nk+1 else begin begin if
charsonline>0 then writeln(stderr,' ');
write(stderr,'Sorry, too many different kerns for me to handle');
showerrorcontext;end;krnptr:=krnptr-1;end;end;
if krnptr>65535 then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Sorry, too many different kerns for me to handle');
showerrorcontext;end;ligkern[nl].b3:=krnptr;
if nl>=maxligsteps-1 then begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Sorry, LIGTABLE too long for me to handle');
showerrorcontext;end else nl:=nl+1;lkstepended:=true;end{:124};end;
finishtheproperty;end;end{:110};end;procedure readcharacterproperty;
begin{136:}begin getname;
if curcode=0 then skiptoendofitem else if(curcode<71)or(curcode>117)then
begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a CHARACTER list');
showerrorcontext;end;skiptoendofitem;
end else begin case curcode of 71:charwd[c]:=sortin(1,getfix);
72:charht[c]:=sortin(2,getfix);73:chardp[c]:=sortin(3,getfix);
74:charic[c]:=sortin(4,getfix);
75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93:tempvalue:=
getfix;100:begin checktag(c);chartag[c]:=2;charremainder[c]:=getbyte;
end;101:readpacket(c);117:{137:}
begin if ne=xmaxchar then begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Sorry, too many VARCHAR specs');showerrorcontext;
end else begin checktag(c);chartag[c]:=3;charremainder[c]:=ne;
exten[ne]:=zerobytes;while level=2 do begin while curchar=32 do getnext;
if curchar=40 then{138:}begin getname;
if curcode=0 then skiptoendofitem else if(curcode<118)or(curcode>121)
then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a VARCHAR list');
showerrorcontext;end;skiptoendofitem;
end else begin case curcode-(118)of 0:exten[ne].b0:=getbyte;
1:exten[ne].b1:=getbyte;2:exten[ne].b2:=getbyte;3:exten[ne].b3:=getbyte;
end;finishtheproperty;end;end{:138}
else if curchar=41 then skiptoendofitem else junkerror;end;ne:=ne+1;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end;end{:137};
111:begin chtable:=getinteger;
if(chtable<0)or(chtable>=nki)then begin begin if charsonline>0 then
writeln(stderr,' ');
write(stderr,'Character property index out of range');showerrorcontext;
end;skiptoendofitem;end else begin chtable:=chtable+0;
if chtable>8 then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Character property exceeds table size');showerrorcontext;
end;skiptoendofitem;end else begin if chtable>npc then npc:=chtable;
chartable[c,chtable]:=getinteger;end;end;end;
112:begin chtable:=getinteger;
if(chtable<0)or(chtable>=nkf)then begin begin if charsonline>0 then
writeln(stderr,' ');
write(stderr,'Character property index out of range');showerrorcontext;
end;skiptoendofitem;end else begin chtable:=chtable+nki;
if chtable>8 then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Character property exceeds table size');showerrorcontext;
end;skiptoendofitem;end else begin if chtable>npc then npc:=chtable;
chartable[c,chtable]:=getinteger;end;end;end;
113:begin chtable:=getinteger;
if(chtable<0)or(chtable>=nkm)then begin begin if charsonline>0 then
writeln(stderr,' ');
write(stderr,'Character property index out of range');showerrorcontext;
end;skiptoendofitem;end else begin chtable:=chtable+nki+nkf;
if chtable>8 then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Character property exceeds table size');showerrorcontext;
end;skiptoendofitem;end else begin if chtable>npc then npc:=chtable;
chartable[c,chtable]:=getinteger;end;end;end;
114:begin chtable:=getinteger;
if(chtable<0)or(chtable>=nkr)then begin begin if charsonline>0 then
writeln(stderr,' ');
write(stderr,'Character property index out of range');showerrorcontext;
end;skiptoendofitem;end else begin chtable:=chtable+nki+nkf+nkm;
if chtable>8 then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Character property exceeds table size');showerrorcontext;
end;skiptoendofitem;end else begin if chtable>npc then npc:=chtable;
chartable[c,chtable]:=getinteger;end;end;end;
115:begin chtable:=getinteger;
if(chtable<0)or(chtable>=nkg)then begin begin if charsonline>0 then
writeln(stderr,' ');
write(stderr,'Character property index out of range');showerrorcontext;
end;skiptoendofitem;end else begin chtable:=chtable+nki+nkf+nkm+nkr;
if chtable>8 then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Character property exceeds table size');showerrorcontext;
end;skiptoendofitem;end else begin if chtable>npc then npc:=chtable;
chartable[c,chtable]:=getinteger;end;end;end;
116:begin chtable:=getinteger;
if(chtable<0)or(chtable>=nkp)then begin begin if charsonline>0 then
writeln(stderr,' ');
write(stderr,'Character property index out of range');showerrorcontext;
end;skiptoendofitem;end else begin chtable:=chtable+nki+nkf+nkm+nkr+nkg;
if chtable>8 then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Character property exceeds table size');showerrorcontext;
end;skiptoendofitem;end else begin if chtable>npc then npc:=chtable;
chartable[c,chtable]:=getinteger;end;end;end;end;finishtheproperty;end;
end{:136};end;procedure readcharinfo;begin{130:}
begin if not tablesread then begin{285:}begin{282:}begin nwi:=0;
for iarray:=0 to nki do begin npi[iarray]:=npi[iarray]+1;
nwi:=nwi+npi[iarray];end;nki:=nki+1;end{:282};{270:}begin nwf:=0;
for farray:=0 to nkf do begin npf[farray]:=npf[farray]+1;
nwf:=nwf+npf[farray];end;nkf:=nkf+1;end{:270};{258:}begin nwm:=0;
for marray:=0 to nkm do begin npm[marray]:=npm[marray]+1;
nwm:=nwm+npm[marray];end;nkm:=nkm+1;end{:258};{222:}begin nwr:=0;
for rarray:=0 to nkr do begin npr[rarray]:=npr[rarray]+1;
nwr:=nwr+3*npr[rarray];end;nkr:=nkr+1;end{:222};{234:}begin nwg:=0;
for garray:=0 to nkg do begin npg[garray]:=npg[garray]+1;
nwg:=nwg+4*npg[garray];end;nkg:=nkg+1;end{:234};{246:}begin nwp:=0;
for parray:=0 to nkp do begin npp[parray]:=npp[parray]+1;
nwp:=nwp+npp[parray];end;nkp:=nkp+1;end{:246};end{:285};
tablesread:=true;end;c:=getcharcode;if verbose then{145:}
begin if charsonline>=8 then begin writeln(stderr,' ');charsonline:=1;
end else begin if charsonline>0 then write(stderr,' ');
charsonline:=charsonline+1;end;printnumber(c,16);end{:145};
while level=1 do begin while curchar=32 do getnext;
if curchar=40 then readcharacterproperty else if curchar=41 then
skiptoendofitem else junkerror;end;
if charwd[c]=0 then charwd[c]:=sortin(1,0);begin loc:=loc-1;
level:=level+1;curchar:=41;end;end{:130};end;procedure readinput;
var c:bytetype;begin{92:}curchar:=32;repeat while curchar=32 do getnext;
if curchar=40 then{94:}begin getname;
if curcode=0 then skiptoendofitem else if curcode>24 then begin begin if
charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong on the outer level');
showerrorcontext;end;skiptoendofitem;end else begin{95:}
case curcode of 1:begin checksumspecified:=true;readfourbytes(0);end;
2:{98:}begin nextd:=getfix;
if nextd<1048576 then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'The design size must be at least 1');showerrorcontext;
end else designsize:=nextd;end{:98};3:{99:}begin nextd:=getfix;
if nextd<=0 then begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'The number of units per design size must be positive');
showerrorcontext;
end else if frozendu then begin if charsonline>0 then writeln(stderr,' '
);write(stderr,'Sorry, it''s too late to change the design units');
showerrorcontext;end else designunits:=nextd;end{:99};4:readBCPL(8,40);
5:readBCPL(48,20);6:begin c:=getbyte;
if c>255 then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'FACE clipped to 255');showerrorcontext;end;c:=255 end;
headerbytes[71]:=c end;7:{100:}begin while curchar=32 do getnext;
if curchar=84 then sevenbitsafeflag:=true else if curchar=70 then
sevenbitsafeflag:=false else begin if charsonline>0 then writeln(stderr,
' ');write(stderr,'The flag value should be "TRUE" or "FALSE"');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);
end{:100};8:{101:}begin c:=getbyte;
if c<18 then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'HEADER indices should be 18 or more');showerrorcontext;
end;repeat getnext until(curchar=40)or(curchar=41);
end else if 4*c+4>maxheaderbytes then begin begin if charsonline>0 then
writeln(stderr,' ');
write(stderr,'This HEADER index is too big for my present table size');
showerrorcontext;end;repeat getnext until(curchar=40)or(curchar=41);
end else begin while headerptr<4*c+4 do begin headerbytes[headerptr]:=0;
headerptr:=headerptr+1;end;readfourbytes(4*c);end;end{:101};9:{102:}
begin while level=1 do begin while curchar=32 do getnext;
if curchar=40 then{103:}begin getname;
if curcode=0 then skiptoendofitem else if(curcode<30)or(curcode>=71)then
begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a FONTDIMEN list');
showerrorcontext;end;skiptoendofitem;
end else begin if curcode=30 then c:=getinteger else c:=curcode-30;
if c<1 then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'PARAMETER index must be at least 1');showerrorcontext;end;
skiptoendofitem;
end else if c>maxparamwords then begin begin if charsonline>0 then
writeln(stderr,' ');
write(stderr,'This PARAMETER index is too big for my present table size'
);showerrorcontext;end;skiptoendofitem;
end else begin while np<c do begin np:=np+1;param[np]:=0;end;
param[c]:=getfix;finishtheproperty;end;end;end{:103}
else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end{:102};
10:readligkern;11:bchar:=getbyte;12:begin vtitlestart:=vfptr;
copytoendofitem;
if vfptr>vtitlestart+255 then begin begin if charsonline>0 then writeln(
stderr,' ');write(stderr,'VTITLE clipped to 255 characters');
showerrorcontext;end;vtitlelength:=255;
end else vtitlelength:=vfptr-vtitlestart;end;13:{104:}
begin fontnumber[fontptr]:=getinteger;curfont:=0;
while fontnumber[fontptr]<>fontnumber[curfont]do curfont:=curfont+1;
if curfont=fontptr then if fontptr<xmaxfont then{105:}
begin fontptr:=fontptr+1;fnamestart[curfont]:=vfsize;
fnamelength[curfont]:=4;fareastart[curfont]:=vfsize;
farealength[curfont]:=0;fontchecksum[curfont]:=zerobytes;
fontat[curfont]:=1048576;fontdsize[curfont]:=10485760;end{:105}
else begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'Sorry, too many different mapfonts');showerrorcontext;end;
if curfont=fontptr then skiptoendofitem else while level=1 do begin
while curchar=32 do getnext;if curchar=40 then{106:}begin getname;
if curcode=0 then skiptoendofitem else if(curcode<200)or(curcode>204)
then begin begin if charsonline>0 then writeln(stderr,' ');
write(stderr,'This property name doesn''t belong in a MAPFONT list');
showerrorcontext;end;skiptoendofitem;
end else begin case curcode of 200:{107:}
begin fnamestart[curfont]:=vfptr;copytoendofitem;
if vfptr>fnamestart[curfont]+255 then begin begin if charsonline>0 then
writeln(stderr,' ');write(stderr,'FONTNAME clipped to 255 characters');
showerrorcontext;end;fnamelength[curfont]:=255;
end else fnamelength[curfont]:=vfptr-fnamestart[curfont];end{:107};
201:{108:}begin fareastart[curfont]:=vfptr;copytoendofitem;
if vfptr>fareastart[curfont]+255 then begin begin if charsonline>0 then
writeln(stderr,' ');write(stderr,'FONTAREA clipped to 255 characters');
showerrorcontext;end;farealength[curfont]:=255;
end else farealength[curfont]:=vfptr-fareastart[curfont];end{:108};
202:begin getfourbytes;fontchecksum[curfont]:=curbytes;end;
203:begin frozendu:=true;
if designunits=1048576 then fontat[curfont]:=getfix else fontat[curfont]
:=round((getfix/designunits)*1048576.0);end;
204:fontdsize[curfont]:=getfix;end;finishtheproperty;end;end{:106}
else if curchar=41 then skiptoendofitem else junkerror;end;
begin loc:=loc-1;level:=level+1;curchar:=41;end;end{:104};
14:readcharinfo;17:{209:}begin ofmlevel:=getinteger;
if(ofmlevel<0)or(ofmlevel>1)then begin begin begin if charsonline>0 then
writeln(stderr,' ');
write(stderr,'OFMLEVEL must be 0 or 1 -- 1 assumed');showerrorcontext;
end;skiptoendofitem;end;ofmlevel:=1;end;end{:209};15:{210:}
begin fontdir:=-1;repeat getnext;until curchar<>32;
case curchar of 84:begin getnext;
if curchar=76 then fontdir:=0 else if curchar=82 then fontdir:=2;end;
66:begin getnext;
if curchar=76 then fontdir:=4 else if curchar=82 then fontdir:=6;end;
82:begin getnext;
if curchar=84 then fontdir:=5 else if curchar=66 then fontdir:=7;end;
76:begin getnext;
if curchar=84 then fontdir:=1 else if curchar=66 then fontdir:=3;end;
end;while curchar<>41 do getnext;
if fontdir=-1 then begin begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'FONTDIR must be valid direction, -- TL assumed');
showerrorcontext;end;skiptoendofitem;end;fontdir:=0;end;end{:210};
16:{211:}begin fontdir:=-1;repeat getnext;until curchar<>32;
case curchar of 84:begin getnext;
if curchar=76 then fontdir:=8 else if curchar=82 then fontdir:=10;end;
66:begin getnext;
if curchar=76 then fontdir:=12 else if curchar=82 then fontdir:=14;end;
82:begin getnext;
if curchar=84 then fontdir:=13 else if curchar=66 then fontdir:=15;end;
76:begin getnext;
if curchar=84 then fontdir:=9 else if curchar=66 then fontdir:=11;end;
end;while curchar<>41 do getnext;
if fontdir=-1 then begin begin begin if charsonline>0 then writeln(
stderr,' ');
write(stderr,'NFONTDIR must be valid direction, -- TL assumed');
showerrorcontext;end;skiptoendofitem;end;fontdir:=8;end;end{:211};
24:readrepeatedcharacterinfo;18:readfontrulelist;19:readfontgluelist;
20:readfontpenaltylist;21:readfontmvaluelist;22:readfontfvaluelist;
23:readfontivaluelist;end{:95};finishtheproperty;end;end{:94}
else if(curchar=41)and not inputhasended then begin begin if charsonline
>0 then writeln(stderr,' ');write(stderr,'Extra right parenthesis');
showerrorcontext;end;loc:=loc+1;curchar:=32;
end else if not inputhasended then junkerror;until inputhasended{:92};
end;procedure corrandcheck;var c:xchartype;hh:0..hashsize;
ligptr:0..maxligsteps;g:bytetype;begin{161:}if nl>0 then{167:}
begin if charremainder[xmaxchar]<xmaxlabel then begin ligkern[nl].b0:=
255;ligkern[nl].b1:=0;ligkern[nl].b2:=0;ligkern[nl].b3:=0;nl:=nl+1;end;
while minnl>nl do begin ligkern[nl].b0:=255;ligkern[nl].b1:=0;
ligkern[nl].b2:=0;ligkern[nl].b3:=0;nl:=nl+1;end;
if(ligkern[nl-1].b0 mod 256)=0 then ligkern[nl-1].b0:=ligkern[nl-1].b0
div 256*256+128;end{:167};sevenunsafe:=false;
for c:=0 to maxchar do if charwd[c]<>0 then{162:}case chartag[c]of 0:;
1:{171:}begin ligptr:=charremainder[c];
if ligkern[ligptr].b0<256 then begin repeat if hashinput(ligptr,c)then
begin if ligkern[ligptr].b2<128 then begin if ligkern[ligptr].b1<>bchar
then begin g:=ligkern[ligptr].b1;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'LIG character examined by',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;
begin g:=ligkern[ligptr].b3;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'LIG character generated by',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;
if ligkern[ligptr].b3>=128 then if(c<128)or(c=bchar)then if(ligkern[
ligptr].b1<128)or(ligkern[ligptr].b1=bchar)then sevenunsafe:=true;
end else if ligkern[ligptr].b1<>bchar then begin g:=ligkern[ligptr].b1;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'KRN character examined by',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;end;
if ligkern[ligptr].b0>=128 then ligptr:=nl else ligptr:=ligptr+1+ligkern
[ligptr].b0;until ligptr>=nl;end;end{:171};2:begin g:=charremainder[c];
if(g>=128)and(c<128)then sevenunsafe:=true;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'The character NEXTLARGER than',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;3:{163:}
begin if exten[charremainder[c]].b0>0 then begin g:=exten[charremainder[
c]].b0;if(g>=128)and(c<128)then sevenunsafe:=true;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'TOP piece of character',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;
if exten[charremainder[c]].b1>0 then begin g:=exten[charremainder[c]].b1
;if(g>=128)and(c<128)then sevenunsafe:=true;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'MID piece of character',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;
if exten[charremainder[c]].b2>0 then begin g:=exten[charremainder[c]].b2
;if(g>=128)and(c<128)then sevenunsafe:=true;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'BOT piece of character',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;
begin g:=exten[charremainder[c]].b3;
if(g>=128)and(c<128)then sevenunsafe:=true;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'REP piece of character',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;end{:163};end{:162};
if charremainder[xmaxchar]<xmaxlabel then begin c:=xmaxchar;{171:}
begin ligptr:=charremainder[c];
if ligkern[ligptr].b0<256 then begin repeat if hashinput(ligptr,c)then
begin if ligkern[ligptr].b2<128 then begin if ligkern[ligptr].b1<>bchar
then begin g:=ligkern[ligptr].b1;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'LIG character examined by',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;
begin g:=ligkern[ligptr].b3;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'LIG character generated by',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;
if ligkern[ligptr].b3>=128 then if(c<128)or(c=bchar)then if(ligkern[
ligptr].b1<128)or(ligkern[ligptr].b1=bchar)then sevenunsafe:=true;
end else if ligkern[ligptr].b1<>bchar then begin g:=ligkern[ligptr].b1;
if charwd[g]=0 then begin charwd[g]:=sortin(1,0);
write(stderr,'KRN character examined by',' ');printnumber(c,16);
writeln(stderr,' had no CHARACTER spec.');end;end;end;
if ligkern[ligptr].b0>=128 then ligptr:=nl else ligptr:=ligptr+1+ligkern
[ligptr].b0;until ligptr>=nl;end;end{:171};end;
if sevenbitsafeflag and sevenunsafe then writeln(stderr,
'The font is not really seven-bit-safe!');{176:}
if hashptr<hashsize then for hh:=1 to hashptr do begin tt:=hashlist[hh];
if classvar[tt]>0 then tt:=f(tt,(hash[tt]-1)div xmaxchar,(hash[tt]-1)mod
xmaxchar);end;
if(hashptr=hashsize)or(yligcycle<xmaxchar)then begin if hashptr<hashsize
then begin write(stderr,'Infinite ligature loop starting with ');
if xligcycle=xmaxchar then write(stderr,'boundary')else printnumber(
xligcycle,16);write(stderr,' and ');printnumber(yligcycle,16);
writeln(stderr,'!');end else writeln(stderr,
'Sorry, I haven''t room for so many ligature/kern pairs!');
writeln(stderr,'All ligatures will be cleared.');
for c:=0 to maxchar do if chartag[c]=1 then begin chartag[c]:=0;
charremainder[c]:=0;end;nl:=0;bchar:=xmaxchar;
charremainder[xmaxchar]:=xmaxlabel;end{:176};{177:}
if nl>0 then for ligptr:=0 to nl-1 do if(ligkern[ligptr].b0 div 256)=0
then begin if ligkern[ligptr].b2<128 then begin if ligkern[ligptr].b0<
255 then begin begin c:=ligkern[ligptr].b1;
if charwd[c]=0 then if c<>bchar then begin ligkern[ligptr].b1:=0;
if charwd[0]=0 then charwd[0]:=sortin(1,0);
write(stderr,'Unused ','LIG step',' refers to nonexistent character ');
printnumber(c,16);writeln(stderr,'!');end;end;
begin c:=ligkern[ligptr].b3;
if charwd[c]=0 then if c<>bchar then begin ligkern[ligptr].b3:=0;
if charwd[0]=0 then charwd[0]:=sortin(1,0);
write(stderr,'Unused ','LIG step',' refers to nonexistent character ');
printnumber(c,16);writeln(stderr,'!');end;end;end;
end else begin c:=ligkern[ligptr].b1;
if charwd[c]=0 then if c<>bchar then begin ligkern[ligptr].b1:=0;
if charwd[0]=0 then charwd[0]:=sortin(1,0);
write(stderr,'Unused ','KRN step',' refers to nonexistent character ');
printnumber(c,16);writeln(stderr,'!');end;end;end;
if ne>0 then for g:=0 to ne-1 do begin begin c:=exten[g].b0;
if c>0 then if charwd[c]=0 then begin exten[g].b0:=0;
if charwd[0]=0 then charwd[0]:=sortin(1,0);
write(stderr,'Unused ','VARCHAR TOP',' refers to nonexistent character '
);printnumber(c,16);writeln(stderr,'!');end;end;begin c:=exten[g].b1;
if c>0 then if charwd[c]=0 then begin exten[g].b1:=0;
if charwd[0]=0 then charwd[0]:=sortin(1,0);
write(stderr,'Unused ','VARCHAR MID',' refers to nonexistent character '
);printnumber(c,16);writeln(stderr,'!');end;end;begin c:=exten[g].b2;
if c>0 then if charwd[c]=0 then begin exten[g].b2:=0;
if charwd[0]=0 then charwd[0]:=sortin(1,0);
write(stderr,'Unused ','VARCHAR BOT',' refers to nonexistent character '
);printnumber(c,16);writeln(stderr,'!');end;end;begin c:=exten[g].b3;
if charwd[c]=0 then begin exten[g].b3:=0;
if charwd[0]=0 then charwd[0]:=sortin(1,0);
write(stderr,'Unused ','VARCHAR REP',' refers to nonexistent character '
);printnumber(c,16);writeln(stderr,'!');end;end;end{:177};
finishextendedfont;for c:=0 to maxchar do{164:}
if chartag[c]=2 then begin g:=charremainder[c];
while(g<c)and(chartag[g]=2)do g:=charremainder[g];
if g=c then begin chartag[c]:=0;
write(stderr,'A cycle of NEXTLARGER characters has been broken at ');
printnumber(c,16);writeln(stderr,'.');end;end{:164};{166:}
case ofmlevel of-1:begin topwidth:=255;topdepth:=15;topheight:=15;
topitalic:=63;end;0:begin topwidth:=65535;topdepth:=255;topheight:=255;
topitalic:=255;end;1:begin topwidth:=65535;topdepth:=255;topheight:=255;
topitalic:=255;end;end;delta:=shorten(1,topwidth);setindices(1,delta);
if delta>0 then begin write(stderr,'I had to round some ','width',
's by ');fprintreal(stderr,(((delta+1)div 2)/1048576),1,7);
writeln(stderr,' units.');end;delta:=shorten(2,topheight);
setindices(2,delta);
if delta>0 then begin write(stderr,'I had to round some ','height',
's by ');fprintreal(stderr,(((delta+1)div 2)/1048576),1,7);
writeln(stderr,' units.');end;delta:=shorten(3,topdepth);
setindices(3,delta);
if delta>0 then begin write(stderr,'I had to round some ','depth',
's by ');fprintreal(stderr,(((delta+1)div 2)/1048576),1,7);
writeln(stderr,' units.');end;delta:=shorten(4,topitalic);
setindices(4,delta);
if delta>0 then begin write(stderr,'I had to round some ',
'italic correction','s by ');
fprintreal(stderr,(((delta+1)div 2)/1048576),1,7);
writeln(stderr,' units.');end;{:166}{:161}end;procedure vfoutput;
var c:chartype;curfont:xfonttype;k:integer;begin{202:}
putbyte(247,vffile);putbyte(202,vffile);putbyte(vtitlelength,vffile);
for k:=0 to vtitlelength-1 do putbyte(vf[vtitlestart+k],vffile);
for k:=0 to 7 do putbyte(headerbytes[k],vffile);vcount:=vtitlelength+11;
for curfont:=0 to fontptr-1 do{203:}begin vfoutfntdef(curfont);
putbyte(fontchecksum[curfont].b0,vffile);
putbyte(fontchecksum[curfont].b1,vffile);
putbyte(fontchecksum[curfont].b2,vffile);
putbyte(fontchecksum[curfont].b3,vffile);voutint(fontat[curfont]);
voutint(fontdsize[curfont]);putbyte(farealength[curfont],vffile);
putbyte(fnamelength[curfont],vffile);
for k:=0 to farealength[curfont]-1 do putbyte(vf[fareastart[curfont]+k],
vffile);if fnamestart[curfont]=vfsize then begin putbyte(78,vffile);
putbyte(85,vffile);putbyte(76,vffile);putbyte(76,vffile);
end else for k:=0 to fnamelength[curfont]-1 do putbyte(vf[fnamestart[
curfont]+k],vffile);
vcount:=vcount+12+farealength[curfont]+fnamelength[curfont];end{:203};
for c:=bc to ec do if charwd[c]>0 then{204:}begin x:=memory[charwd[c]];
if designunits<>1048576 then x:=round((x/designunits)*1048576.0);
if(packetlength[c]>241)or(x<0)or(x>=16777216)or(c<0)or(c>255)then begin
putbyte(242,vffile);voutint(packetlength[c]);vfoutchar(c);voutint(x);
vcount:=vcount+13+packetlength[c];
end else begin putbyte(packetlength[c],vffile);putbyte(c,vffile);
putbyte(x div 65536,vffile);putbyte((x div 256)mod 256,vffile);
putbyte(x mod 256,vffile);vcount:=vcount+5+packetlength[c];end;
if packetstart[c]=vfsize then vfoutset(c)else for k:=0 to packetlength[c
]-1 do putbyte(vf[packetstart[c]+k],vffile);end{:204};
repeat putbyte(248,vffile);vcount:=vcount+1;until vcount mod 4=0{:202};
end;{:205}{206:}begin initialize;nameenter;readinput;
if verbose then writeln(stderr,'.');corrandcheck;{179:}
computesubfilesizes;outputsubfilesizes;{185:}
if not checksumspecified then{186:}begin curbytes.b0:=bc;
curbytes.b1:=ec;curbytes.b2:=bc;curbytes.b3:=ec;
for c:=bc to ec do if charwd[c]>0 then begin tempwidth:=memory[charwd[c]
];if designunits<>1048576 then tempwidth:=round((tempwidth/designunits)
*1048576.0);tempwidth:=tempwidth+(c+4)*4194304;
curbytes.b0:=(curbytes.b0+curbytes.b0+tempwidth)mod 255;
curbytes.b1:=(curbytes.b1+curbytes.b1+tempwidth)mod 253;
curbytes.b2:=(curbytes.b2+curbytes.b2+tempwidth)mod 251;
curbytes.b3:=(curbytes.b3+curbytes.b3+tempwidth)mod 247;end;
headerbytes[0]:=curbytes.b0;headerbytes[1]:=curbytes.b1;
headerbytes[2]:=curbytes.b2;headerbytes[3]:=curbytes.b3;end{:186};
headerbytes[4]:=designsize div 16777216;
headerbytes[5]:=(designsize div 65536)mod 256;
headerbytes[6]:=(designsize div 256)mod 256;
headerbytes[7]:=designsize mod 256;
if(not sevenunsafe)and(ofmlevel=-1)then headerbytes[68]:=128;
for j:=0 to headerptr-1 do putbyte(headerbytes[j],tfmfile);{:185};
outputnewinformationofm;outputcharacterinfo;{191:}
for q:=1 to 4 do begin putbyte(0,tfmfile);putbyte(0,tfmfile);
putbyte(0,tfmfile);putbyte(0,tfmfile);p:=link[q];
while p>0 do begin outscaled(memory[p]);p:=link[p];end;end;{:191};{196:}
if ofmlevel=-1 then begin if extralocneeded then begin putbyte(255,
tfmfile);putbyte(bchar,tfmfile);putbyte(0,tfmfile);putbyte(0,tfmfile);
end else for sortptr:=1 to lkoffset do begin t:=labeltable[labelptr].rr;
if bchar<256 then begin putbyte(255,tfmfile);putbyte(bchar,tfmfile);
end else begin putbyte(254,tfmfile);putbyte(0,tfmfile);end;
putbyte((t+lkoffset)div 256,tfmfile);
putbyte((t+lkoffset)mod 256,tfmfile);repeat labelptr:=labelptr-1;
until labeltable[labelptr].rr<t;end;
if nl>0 then for ligptr:=0 to nl-1 do begin putbyte(ligkern[ligptr].b0,
tfmfile);putbyte(ligkern[ligptr].b1,tfmfile);
putbyte(ligkern[ligptr].b2,tfmfile);putbyte(ligkern[ligptr].b3,tfmfile);
end;
if nk>0 then for krnptr:=0 to nk-1 do outscaled(kern[krnptr])end else
begin if extralocneeded then begin putbyte((255)div 256,tfmfile);
putbyte((255)mod 256,tfmfile);putbyte((bchar)div 256,tfmfile);
putbyte((bchar)mod 256,tfmfile);putbyte((0)div 256,tfmfile);
putbyte((0)mod 256,tfmfile);putbyte((0)div 256,tfmfile);
putbyte((0)mod 256,tfmfile);
end else for sortptr:=1 to lkoffset do begin t:=labeltable[labelptr].rr;
if bchar<xmaxchar then begin putbyte((255)div 256,tfmfile);
putbyte((255)mod 256,tfmfile);putbyte((bchar)div 256,tfmfile);
putbyte((bchar)mod 256,tfmfile);
end else begin putbyte((254)div 256,tfmfile);
putbyte((254)mod 256,tfmfile);putbyte((0)div 256,tfmfile);
putbyte((0)mod 256,tfmfile);end;
putbyte(((t+lkoffset)div 256)div 256,tfmfile);
putbyte(((t+lkoffset)div 256)mod 256,tfmfile);
putbyte(((t+lkoffset)mod 256)div 256,tfmfile);
putbyte(((t+lkoffset)mod 256)mod 256,tfmfile);
repeat labelptr:=labelptr-1;until labeltable[labelptr].rr<t;end;
if nl>0 then for ligptr:=0 to nl-1 do begin putbyte((ligkern[ligptr].b0)
div 256,tfmfile);putbyte((ligkern[ligptr].b0)mod 256,tfmfile);
putbyte((ligkern[ligptr].b1)div 256,tfmfile);
putbyte((ligkern[ligptr].b1)mod 256,tfmfile);
putbyte((ligkern[ligptr].b2)div 256,tfmfile);
putbyte((ligkern[ligptr].b2)mod 256,tfmfile);
putbyte((ligkern[ligptr].b3)div 256,tfmfile);
putbyte((ligkern[ligptr].b3)mod 256,tfmfile);end;
if nk>0 then for krnptr:=0 to nk-1 do outscaled(kern[krnptr])end{:196};
{197:}
if ofmlevel=-1 then begin if ne>0 then for c:=0 to ne-1 do begin putbyte
(exten[c].b0,tfmfile);putbyte(exten[c].b1,tfmfile);
putbyte(exten[c].b2,tfmfile);putbyte(exten[c].b3,tfmfile);end;
end else begin if ne>0 then for c:=0 to ne-1 do begin putbyte((exten[c].
b0)div 256,tfmfile);putbyte((exten[c].b0)mod 256,tfmfile);
putbyte((exten[c].b1)div 256,tfmfile);
putbyte((exten[c].b1)mod 256,tfmfile);
putbyte((exten[c].b2)div 256,tfmfile);
putbyte((exten[c].b2)mod 256,tfmfile);
putbyte((exten[c].b3)div 256,tfmfile);
putbyte((exten[c].b3)mod 256,tfmfile);end;end;{:197};{198:}
for parptr:=1 to np do begin if parptr=1 then{199:}
begin if param[1]<0 then begin param[1]:=param[1]+1073741824;
putbyte((param[1]div 16777216)+192,tfmfile);
end else putbyte(param[1]div 16777216,tfmfile);
putbyte((param[1]div 65536)mod 256,tfmfile);
putbyte((param[1]div 256)mod 256,tfmfile);
putbyte(param[1]mod 256,tfmfile);end{:199}else outscaled(param[parptr]);
end{:198}{:179};vfoutput;if not perfect then uexit(1);end.{:206}