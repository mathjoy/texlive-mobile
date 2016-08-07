#define MFT
#include "cpascal.h"
#define maxbytes ( 60000L ) 
#define maxnames ( 6000 ) 
#define hashsize ( 353 ) 
#define bufsize ( 3000 ) 
#define linelength ( 79 ) 
typedef unsigned char ASCIIcode  ;
typedef text /* of  ASCIIcode */ textfile  ;
typedef unsigned char eightbits  ;
typedef unsigned short sixteenbits  ;
typedef integer namepointer  ;
unsigned char history  ;
ASCIIcode xord[256]  ;
ASCIIcode xchr[256]  ;
textfile mffile  ;
textfile changefile  ;
textfile stylefile  ;
textfile texfile  ;
ASCIIcode buffer[bufsize + 1]  ;
integer line  ;
integer otherline  ;
integer templine  ;
integer limit  ;
integer loc  ;
boolean inputhasended  ;
boolean changing  ;
boolean styling  ;
ASCIIcode changebuffer[bufsize + 1]  ;
integer changelimit  ;
ASCIIcode bytemem[maxbytes + 1]  ;
sixteenbits bytestart[maxnames + 1]  ;
sixteenbits link[maxnames + 1]  ;
sixteenbits ilk[maxnames + 1]  ;
namepointer nameptr  ;
integer byteptr  ;
integer idfirst  ;
integer idloc  ;
sixteenbits hash[hashsize + 1]  ;
namepointer translation[256]  ;
ASCIIcode i  ;
namepointer trle, trge, trne, tramp, trsharp, trskip, trps, trquad  ;
eightbits curtype  ;
integer curtok  ;
eightbits prevtype  ;
integer prevtok  ;
unsigned char scannerstatus  ;
boolean startofline  ;
boolean emptybuffer  ;
unsigned char charclass[256]  ;
ASCIIcode outbuf[linelength + 1]  ;
integer outptr  ;
integer outline  ;
constcstring changename, texname  ;
constcstring stylename[32]  ;
cinttype nstylename  ;
cinttype istylename  ;
cinttype metapost  ;

#include "mft.h"
void 
error ( void ) 
{
  integer k, l  ;
  {
    if ( styling ) 
    Fputs ( stdout ,  ". (style file " ) ;
    else if ( changing ) 
    Fputs ( stdout ,  ". (change file " ) ;
    else
    Fputs ( stdout ,  ". (" ) ;
    fprintf ( stdout , "%s%ld%c\n",  "l." , (long)line , ')' ) ;
    if ( loc >= limit ) 
    l = limit ;
    else l = loc ;
    {register integer for_end; k = 1 ;for_end = l ; if ( k <= for_end) do 
      putc ( xchr [buffer [k - 1 ]],  stdout );
    while ( k++ < for_end ) ;} 
    putc ('\n',  stdout );
    {register integer for_end; k = 1 ;for_end = l ; if ( k <= for_end) do 
      putc ( ' ' ,  stdout );
    while ( k++ < for_end ) ;} 
    {register integer for_end; k = l + 1 ;for_end = limit ; if ( k <= 
    for_end) do 
      putc ( xchr [buffer [k - 1 ]],  stdout );
    while ( k++ < for_end ) ;} 
  } 
  fflush ( stdout ) ;
  history = 2 ;
} 
void 
jumpout ( void ) 
{
  switch ( history ) 
  {case 0 : 
    {
      putc ('\n',  stdout );
      Fputs ( stdout ,  "(No errors were found.)" ) ;
    } 
    break ;
  case 1 : 
    {
      putc ('\n',  stdout );
      Fputs ( stdout ,  "(Did you see the warning message above?)" ) ;
    } 
    break ;
  case 2 : 
    {
      putc ('\n',  stdout );
      Fputs ( stdout ,  "(Pardon me, but I think I spotted something wrong.)" ) 
      ;
    } 
    break ;
  case 3 : 
    {
      putc ('\n',  stdout );
      Fputs ( stdout ,  "(That was a fatal error, my friend.)" ) ;
    } 
    break ;
  } 
  putc ('\n',  stdout );
  if ( ( history != 0 ) && ( history != 1 ) ) 
  uexit ( 1 ) ;
  else uexit ( 0 ) ;
} 
void 
parsearguments ( void ) 
{
  
#define noptions ( 5 ) 
  getoptstruct longoptions[noptions + 1]  ;
  integer getoptreturnval  ;
  cinttype optionindex  ;
  integer currentoption  ;
  constcstring suffix  ;
  metapost = false ;
  currentoption = 0 ;
  longoptions [currentoption ].name = "help" ;
  longoptions [currentoption ].hasarg = 0 ;
  longoptions [currentoption ].flag = 0 ;
  longoptions [currentoption ].val = 0 ;
  currentoption = currentoption + 1 ;
  longoptions [currentoption ].name = "version" ;
  longoptions [currentoption ].hasarg = 0 ;
  longoptions [currentoption ].flag = 0 ;
  longoptions [currentoption ].val = 0 ;
  currentoption = currentoption + 1 ;
  longoptions [currentoption ].name = "change" ;
  longoptions [currentoption ].hasarg = 1 ;
  longoptions [currentoption ].flag = 0 ;
  longoptions [currentoption ].val = 0 ;
  currentoption = currentoption + 1 ;
  longoptions [currentoption ].name = "style" ;
  longoptions [currentoption ].hasarg = 1 ;
  longoptions [currentoption ].flag = 0 ;
  longoptions [currentoption ].val = 0 ;
  currentoption = currentoption + 1 ;
  longoptions [currentoption ].name = "metapost" ;
  longoptions [currentoption ].hasarg = 0 ;
  longoptions [currentoption ].flag = addressof ( metapost ) ;
  longoptions [currentoption ].val = 1 ;
  currentoption = currentoption + 1 ;
  longoptions [currentoption ].name = 0 ;
  longoptions [currentoption ].hasarg = 0 ;
  longoptions [currentoption ].flag = 0 ;
  longoptions [currentoption ].val = 0 ;
  nstylename = 0 ;
  do {
      getoptreturnval = getoptlongonly ( argc , argv , "" , longoptions , 
    addressof ( optionindex ) ) ;
    if ( getoptreturnval == -1 ) 
    {
      ;
    } 
    else if ( getoptreturnval == 63 ) 
    {
      usage ( "mft" ) ;
    } 
    else if ( ( strcmp ( longoptions [optionindex ].name , "help" ) == 0 ) ) 
    {
      usagehelp ( MFTHELP , nil ) ;
    } 
    else if ( ( strcmp ( longoptions [optionindex ].name , "version" ) == 0 
    ) ) 
    {
      printversionandexit ( "This is MFT, Version 2.0" , nil , 
      "D.E. Knuth  (MP changes by W. Bzyl)" , nil ) ;
    } 
    else if ( ( strcmp ( longoptions [optionindex ].name , "change" ) == 0 ) 
    ) 
    {
      changename = extendfilename ( optarg , "ch" ) ;
    } 
    else if ( ( strcmp ( longoptions [optionindex ].name , "style" ) == 0 ) 
    ) 
    {
      if ( ( nstylename == 32 ) ) 
      {
	{
	  putc ('\n',  stdout );
	  Fputs ( stdout ,  "Too many style files specified." ) ;
	  error () ;
	  history = 3 ;
	  jumpout () ;
	} 
	usage ( "mft" ) ;
      } 
      stylename [nstylename ]= extendfilename ( optarg , "mft" ) ;
      nstylename = nstylename + 1 ;
    } 
  } while ( ! ( getoptreturnval == -1 ) ) ;
  if ( ( optind + 1 != argc ) ) 
  {
    fprintf ( stderr , "%s%s\n",  "mft" , ": Need exactly one file argument." ) ;
    usage ( "mft" ) ;
  } 
  suffix = findsuffix ( cmdline ( optind ) ) ;
  if ( suffix && ( strcmp ( suffix , "mp" ) == 0 ) ) 
  {
    metapost = true ;
    texname = basenamechangesuffix ( cmdline ( optind ) , ".mp" , ".tex" ) ;
  } 
  else {
      
    texname = basenamechangesuffix ( cmdline ( optind ) , ".mf" , ".tex" ) ;
  } 
  if ( ( nstylename == 0 ) ) 
  {
    if ( metapost ) 
    stylename [0 ]= "mplain.mft" ;
    else stylename [0 ]= "plain.mft" ;
    nstylename = 1 ;
  } 
} 
void 
initialize ( void ) 
{
  unsigned char i  ;
  integer h  ;
  kpsesetprogramname ( argv [0 ], "mft" ) ;
  parsearguments () ;
  history = 0 ;
  xchr [32 ]= ' ' ;
  xchr [33 ]= '!' ;
  xchr [34 ]= '"' ;
  xchr [35 ]= '#' ;
  xchr [36 ]= '$' ;
  xchr [37 ]= '%' ;
  xchr [38 ]= '&' ;
  xchr [39 ]= '\'' ;
  xchr [40 ]= '(' ;
  xchr [41 ]= ')' ;
  xchr [42 ]= '*' ;
  xchr [43 ]= '+' ;
  xchr [44 ]= ',' ;
  xchr [45 ]= '-' ;
  xchr [46 ]= '.' ;
  xchr [47 ]= '/' ;
  xchr [48 ]= '0' ;
  xchr [49 ]= '1' ;
  xchr [50 ]= '2' ;
  xchr [51 ]= '3' ;
  xchr [52 ]= '4' ;
  xchr [53 ]= '5' ;
  xchr [54 ]= '6' ;
  xchr [55 ]= '7' ;
  xchr [56 ]= '8' ;
  xchr [57 ]= '9' ;
  xchr [58 ]= ':' ;
  xchr [59 ]= ';' ;
  xchr [60 ]= '<' ;
  xchr [61 ]= '=' ;
  xchr [62 ]= '>' ;
  xchr [63 ]= '?' ;
  xchr [64 ]= '@' ;
  xchr [65 ]= 'A' ;
  xchr [66 ]= 'B' ;
  xchr [67 ]= 'C' ;
  xchr [68 ]= 'D' ;
  xchr [69 ]= 'E' ;
  xchr [70 ]= 'F' ;
  xchr [71 ]= 'G' ;
  xchr [72 ]= 'H' ;
  xchr [73 ]= 'I' ;
  xchr [74 ]= 'J' ;
  xchr [75 ]= 'K' ;
  xchr [76 ]= 'L' ;
  xchr [77 ]= 'M' ;
  xchr [78 ]= 'N' ;
  xchr [79 ]= 'O' ;
  xchr [80 ]= 'P' ;
  xchr [81 ]= 'Q' ;
  xchr [82 ]= 'R' ;
  xchr [83 ]= 'S' ;
  xchr [84 ]= 'T' ;
  xchr [85 ]= 'U' ;
  xchr [86 ]= 'V' ;
  xchr [87 ]= 'W' ;
  xchr [88 ]= 'X' ;
  xchr [89 ]= 'Y' ;
  xchr [90 ]= 'Z' ;
  xchr [91 ]= '[' ;
  xchr [92 ]= '\\' ;
  xchr [93 ]= ']' ;
  xchr [94 ]= '^' ;
  xchr [95 ]= '_' ;
  xchr [96 ]= '`' ;
  xchr [97 ]= 'a' ;
  xchr [98 ]= 'b' ;
  xchr [99 ]= 'c' ;
  xchr [100 ]= 'd' ;
  xchr [101 ]= 'e' ;
  xchr [102 ]= 'f' ;
  xchr [103 ]= 'g' ;
  xchr [104 ]= 'h' ;
  xchr [105 ]= 'i' ;
  xchr [106 ]= 'j' ;
  xchr [107 ]= 'k' ;
  xchr [108 ]= 'l' ;
  xchr [109 ]= 'm' ;
  xchr [110 ]= 'n' ;
  xchr [111 ]= 'o' ;
  xchr [112 ]= 'p' ;
  xchr [113 ]= 'q' ;
  xchr [114 ]= 'r' ;
  xchr [115 ]= 's' ;
  xchr [116 ]= 't' ;
  xchr [117 ]= 'u' ;
  xchr [118 ]= 'v' ;
  xchr [119 ]= 'w' ;
  xchr [120 ]= 'x' ;
  xchr [121 ]= 'y' ;
  xchr [122 ]= 'z' ;
  xchr [123 ]= '{' ;
  xchr [124 ]= '|' ;
  xchr [125 ]= '}' ;
  xchr [126 ]= '~' ;
  {register integer for_end; i = 1 ;for_end = 31 ; if ( i <= for_end) do 
    xchr [i ]= chr ( i ) ;
  while ( i++ < for_end ) ;} 
  {register integer for_end; i = 127 ;for_end = 255 ; if ( i <= for_end) do 
    xchr [i ]= chr ( i ) ;
  while ( i++ < for_end ) ;} 
  {register integer for_end; i = 0 ;for_end = 255 ; if ( i <= for_end) do 
    xord [chr ( i ) ]= 127 ;
  while ( i++ < for_end ) ;} 
  {register integer for_end; i = 128 ;for_end = 255 ; if ( i <= for_end) do 
    xord [xchr [i ]]= i ;
  while ( i++ < for_end ) ;} 
  {register integer for_end; i = 1 ;for_end = 126 ; if ( i <= for_end) do 
    xord [xchr [i ]]= i ;
  while ( i++ < for_end ) ;} 
  rewrite ( texfile , texname ) ;
  bytestart [0 ]= 0 ;
  byteptr = 0 ;
  bytestart [1 ]= 0 ;
  nameptr = 1 ;
  {register integer for_end; h = 0 ;for_end = hashsize - 1 ; if ( h <= 
  for_end) do 
    hash [h ]= 0 ;
  while ( h++ < for_end ) ;} 
  curtype = 1 ;
  curtok = 0 ;
  {register integer for_end; i = 48 ;for_end = 57 ; if ( i <= for_end) do 
    charclass [i ]= 0 ;
  while ( i++ < for_end ) ;} 
  charclass [46 ]= 1 ;
  charclass [32 ]= 2 ;
  charclass [37 ]= 3 ;
  charclass [34 ]= 4 ;
  charclass [44 ]= 5 ;
  charclass [59 ]= 6 ;
  charclass [40 ]= 7 ;
  charclass [41 ]= 8 ;
  {register integer for_end; i = 65 ;for_end = 90 ; if ( i <= for_end) do 
    charclass [i ]= 9 ;
  while ( i++ < for_end ) ;} 
  {register integer for_end; i = 97 ;for_end = 122 ; if ( i <= for_end) do 
    charclass [i ]= 9 ;
  while ( i++ < for_end ) ;} 
  charclass [95 ]= 9 ;
  charclass [60 ]= 10 ;
  charclass [61 ]= 10 ;
  charclass [62 ]= 10 ;
  charclass [58 ]= 10 ;
  charclass [124 ]= 10 ;
  charclass [96 ]= 11 ;
  charclass [39 ]= 11 ;
  charclass [43 ]= 12 ;
  charclass [45 ]= 12 ;
  charclass [47 ]= 13 ;
  charclass [42 ]= 13 ;
  charclass [92 ]= 13 ;
  charclass [33 ]= 14 ;
  charclass [63 ]= 14 ;
  charclass [35 ]= 15 ;
  charclass [38 ]= 15 ;
  charclass [64 ]= 15 ;
  charclass [36 ]= 15 ;
  charclass [94 ]= 16 ;
  charclass [126 ]= 16 ;
  charclass [91 ]= 17 ;
  charclass [93 ]= 18 ;
  charclass [123 ]= 19 ;
  charclass [125 ]= 19 ;
  {register integer for_end; i = 0 ;for_end = 31 ; if ( i <= for_end) do 
    charclass [i ]= 9 ;
  while ( i++ < for_end ) ;} 
  {register integer for_end; i = 127 ;for_end = 255 ; if ( i <= for_end) do 
    charclass [i ]= 9 ;
  while ( i++ < for_end ) ;} 
  charclass [13 ]= 21 ;
  charclass [9 ]= 2 ;
  charclass [12 ]= 2 ;
  outptr = 1 ;
  outbuf [1 ]= 32 ;
  outline = 1 ;
  if ( metapost ) 
  {
    Fputs ( texfile ,  "\\input mptmac" ) ;
  } 
  else
  Fputs ( texfile ,  "\\input mftmac" ) ;
  outbuf [0 ]= 92 ;
} 
void 
openinput ( void ) 
{
  if ( metapost ) 
  mffile = kpseopenfile ( cmdline ( optind ) , kpsempformat ) ;
  else mffile = kpseopenfile ( cmdline ( optind ) , kpsemfformat ) ;
  if ( changename ) 
  {
    if ( metapost ) 
    changefile = kpseopenfile ( changename , kpsempformat ) ;
    else changefile = kpseopenfile ( changename , kpsemfformat ) ;
  } 
  stylefile = kpseopenfile ( stylename [0 ], kpsemftformat ) ;
  istylename = 1 ;
} 
boolean 
zinputln ( textfile f ) 
{
  register boolean Result; integer finallimit  ;
  limit = 0 ;
  finallimit = 0 ;
  if ( eof ( f ) ) 
  Result = false ;
  else {
      
    while ( ! eoln ( f ) ) {
	
      buffer [limit ]= xord [getc ( f ) ];
      limit = limit + 1 ;
      if ( buffer [limit - 1 ]!= 32 ) 
      finallimit = limit ;
      if ( limit == bufsize ) 
      {
	while ( ! eoln ( f ) ) vgetc ( f ) ;
	limit = limit - 1 ;
	if ( finallimit > limit ) 
	finallimit = limit ;
	{
	  putc ('\n',  stdout );
	  Fputs ( stdout ,  "! Input line too long" ) ;
	} 
	loc = 0 ;
	error () ;
      } 
    } 
    readln ( f ) ;
    limit = finallimit ;
    Result = true ;
  } 
  return Result ;
} 
boolean 
linesdontmatch ( void ) 
{
  /* 10 */ register boolean Result; integer k  ;
  Result = true ;
  if ( changelimit != limit ) 
  goto lab10 ;
  if ( limit > 0 ) 
  {register integer for_end; k = 0 ;for_end = limit - 1 ; if ( k <= for_end) 
  do 
    if ( changebuffer [k ]!= buffer [k ]) 
    goto lab10 ;
  while ( k++ < for_end ) ;} 
  Result = false ;
  lab10: ;
  return Result ;
} 
void 
primethechangebuffer ( void ) 
{
  /* 22 30 10 */ integer k  ;
  changelimit = 0 ;
  while ( true ) {
      
    line = line + 1 ;
    if ( ! inputln ( changefile ) ) 
    goto lab10 ;
    if ( limit < 2 ) 
    goto lab22 ;
    if ( buffer [0 ]!= 64 ) 
    goto lab22 ;
    if ( ( buffer [1 ]>= 88 ) && ( buffer [1 ]<= 90 ) ) 
    buffer [1 ]= buffer [1 ]+ 32 ;
    if ( buffer [1 ]== 120 ) 
    goto lab30 ;
    if ( ( buffer [1 ]== 121 ) || ( buffer [1 ]== 122 ) ) 
    {
      loc = 2 ;
      {
	putc ('\n',  stdout );
	Fputs ( stdout ,  "! Where is the matching @x?" ) ;
	error () ;
      } 
    } 
    lab22: ;
  } 
  lab30: ;
  do {
      line = line + 1 ;
    if ( ! inputln ( changefile ) ) 
    {
      {
	putc ('\n',  stdout );
	Fputs ( stdout ,  "! Change file ended after @x" ) ;
	error () ;
      } 
      goto lab10 ;
    } 
  } while ( ! ( limit > 0 ) ) ;
  {
    changelimit = limit ;
    if ( limit > 0 ) 
    {register integer for_end; k = 0 ;for_end = limit - 1 ; if ( k <= 
    for_end) do 
      changebuffer [k ]= buffer [k ];
    while ( k++ < for_end ) ;} 
  } 
  lab10: ;
} 
void 
checkchange ( void ) 
{
  /* 10 */ integer n  ;
  integer k  ;
  if ( linesdontmatch () ) 
  goto lab10 ;
  n = 0 ;
  while ( true ) {
      
    changing = ! changing ;
    templine = otherline ;
    otherline = line ;
    line = templine ;
    line = line + 1 ;
    if ( ! inputln ( changefile ) ) 
    {
      {
	putc ('\n',  stdout );
	Fputs ( stdout ,  "! Change file ended before @y" ) ;
	error () ;
      } 
      changelimit = 0 ;
      changing = ! changing ;
      templine = otherline ;
      otherline = line ;
      line = templine ;
      goto lab10 ;
    } 
    if ( limit > 1 ) {
	
      if ( buffer [0 ]== 64 ) 
      {
	if ( ( buffer [1 ]>= 88 ) && ( buffer [1 ]<= 90 ) ) 
	buffer [1 ]= buffer [1 ]+ 32 ;
	if ( ( buffer [1 ]== 120 ) || ( buffer [1 ]== 122 ) ) 
	{
	  loc = 2 ;
	  {
	    putc ('\n',  stdout );
	    Fputs ( stdout ,  "! Where is the matching @y?" ) ;
	    error () ;
	  } 
	} 
	else if ( buffer [1 ]== 121 ) 
	{
	  if ( n > 0 ) 
	  {
	    loc = 2 ;
	    {
	      putc ('\n',  stdout );
	      fprintf ( stdout , "%s%ld%s",  "! Hmm... " , (long)n ,               " of the preceding lines failed to match" ) ;
	      error () ;
	    } 
	  } 
	  goto lab10 ;
	} 
      } 
    } 
    {
      changelimit = limit ;
      if ( limit > 0 ) 
      {register integer for_end; k = 0 ;for_end = limit - 1 ; if ( k <= 
      for_end) do 
	changebuffer [k ]= buffer [k ];
      while ( k++ < for_end ) ;} 
    } 
    changing = ! changing ;
    templine = otherline ;
    otherline = line ;
    line = templine ;
    line = line + 1 ;
    if ( ! inputln ( mffile ) ) 
    {
      {
	putc ('\n',  stdout );
	Fputs ( stdout ,  "! MF file ended during a change" ) ;
	error () ;
      } 
      inputhasended = true ;
      goto lab10 ;
    } 
    if ( linesdontmatch () ) 
    n = n + 1 ;
  } 
  lab10: ;
} 
void 
getline ( void ) 
{
  /* 20 */ lab20: if ( styling ) 
  {
    line = line + 1 ;
    if ( ! inputln ( stylefile ) ) 
    {
      if ( istylename != nstylename ) 
      {
	xfclose ( stylefile , stylename [istylename - 1 ]) ;
	stylefile = kpseopenfile ( stylename [istylename ], kpsemftformat ) 
	;
	istylename = istylename + 1 ;
      } 
      else {
	  
	styling = false ;
      } 
      line = 0 ;
    } 
  } 
  if ( ! styling ) 
  {
    if ( changing ) 
    {
      line = line + 1 ;
      if ( ! inputln ( changefile ) ) 
      {
	{
	  putc ('\n',  stdout );
	  Fputs ( stdout ,  "! Change file ended without @z" ) ;
	  error () ;
	} 
	buffer [0 ]= 64 ;
	buffer [1 ]= 122 ;
	limit = 2 ;
      } 
      if ( limit > 1 ) {
	  
	if ( buffer [0 ]== 64 ) 
	{
	  if ( ( buffer [1 ]>= 88 ) && ( buffer [1 ]<= 90 ) ) 
	  buffer [1 ]= buffer [1 ]+ 32 ;
	  if ( ( buffer [1 ]== 120 ) || ( buffer [1 ]== 121 ) ) 
	  {
	    loc = 2 ;
	    {
	      putc ('\n',  stdout );
	      Fputs ( stdout ,  "! Where is the matching @z?" ) ;
	      error () ;
	    } 
	  } 
	  else if ( buffer [1 ]== 122 ) 
	  {
	    primethechangebuffer () ;
	    changing = ! changing ;
	    templine = otherline ;
	    otherline = line ;
	    line = templine ;
	  } 
	} 
      } 
    } 
    if ( ! changing ) 
    {
      {
	line = line + 1 ;
	if ( ! inputln ( mffile ) ) 
	inputhasended = true ;
	else if ( limit == changelimit ) {
	    
	  if ( buffer [0 ]== changebuffer [0 ]) {
	      
	    if ( changelimit > 0 ) 
	    checkchange () ;
	  } 
	} 
      } 
      if ( changing ) 
      goto lab20 ;
    } 
  } 
} 
namepointer 
lookup ( void ) 
{
  /* 31 */ register namepointer Result; integer i  ;
  integer h  ;
  integer k  ;
  integer l  ;
  namepointer p  ;
  l = idloc - idfirst ;
  h = buffer [idfirst ];
  i = idfirst + 1 ;
  while ( i < idloc ) {
      
    h = ( h + h + buffer [i ]) % hashsize ;
    i = i + 1 ;
  } 
  p = hash [h ];
  while ( p != 0 ) {
      
    if ( bytestart [p + 1 ]- bytestart [p ]== l ) 
    {
      i = idfirst ;
      k = bytestart [p ];
      while ( ( i < idloc ) && ( buffer [i ]== bytemem [k ]) ) {
	  
	i = i + 1 ;
	k = k + 1 ;
      } 
      if ( i == idloc ) 
      goto lab31 ;
    } 
    p = link [p ];
  } 
  p = nameptr ;
  link [p ]= hash [h ];
  hash [h ]= p ;
  lab31: ;
  if ( p == nameptr ) 
  {
    if ( byteptr + l > maxbytes ) 
    {
      putc ('\n',  stdout );
      fprintf ( stdout , "%s%s%s",  "! Sorry, " , "byte memory" , " capacity exceeded" ) ;
      error () ;
      history = 3 ;
      jumpout () ;
    } 
    if ( nameptr + 1 > maxnames ) 
    {
      putc ('\n',  stdout );
      fprintf ( stdout , "%s%s%s",  "! Sorry, " , "name" , " capacity exceeded" ) ;
      error () ;
      history = 3 ;
      jumpout () ;
    } 
    i = idfirst ;
    while ( i < idloc ) {
	
      bytemem [byteptr ]= buffer [i ];
      byteptr = byteptr + 1 ;
      i = i + 1 ;
    } 
    nameptr = nameptr + 1 ;
    bytestart [nameptr ]= byteptr ;
    ilk [p ]= 36 ;
  } 
  Result = p ;
  return Result ;
} 
void 
getnext ( void ) 
{
  /* 25 85 86 30 31 10 */ ASCIIcode c  ;
  ASCIIcode classvar  ;
  prevtype = curtype ;
  prevtok = curtok ;
  if ( emptybuffer ) 
  {
    getline () ;
    if ( inputhasended ) 
    {
      curtype = 2 ;
      curtok = idfirst ;
      goto lab10 ;
    } 
    buffer [limit ]= 13 ;
    loc = 0 ;
    startofline = true ;
    emptybuffer = false ;
  } 
  lab25: c = buffer [loc ];
  idfirst = loc ;
  loc = loc + 1 ;
  classvar = charclass [c ];
  switch ( classvar ) 
  {case 0 : 
    goto lab85 ;
    break ;
  case 1 : 
    {
      classvar = charclass [buffer [loc ]];
      if ( classvar > 1 ) 
      goto lab25 ;
      else if ( classvar < 1 ) 
      goto lab86 ;
    } 
    break ;
  case 2 : 
    if ( startofline || scannerstatus > 0 ) 
    {
      curtype = 0 ;
      curtok = idfirst ;
      goto lab10 ;
    } 
    else goto lab25 ;
    break ;
  case 21 : 
    {
      curtype = 1 ;
      curtok = idfirst ;
      goto lab10 ;
    } 
    break ;
  case 4 : 
    while ( true ) {
	
      if ( buffer [loc ]== 34 ) 
      {
	loc = loc + 1 ;
	{
	  curtype = 7 ;
	  curtok = idfirst ;
	  goto lab10 ;
	} 
      } 
      if ( loc == limit ) 
      {
	{
	  putc ('\n',  stdout );
	  Fputs ( stdout ,  "! Incomplete string will be ignored" ) ;
	  error () ;
	} 
	goto lab25 ;
      } 
      loc = loc + 1 ;
    } 
    break ;
  case 5 : 
  case 6 : 
  case 7 : 
  case 8 : 
    goto lab31 ;
    break ;
  case 20 : 
    {
      {
	putc ('\n',  stdout );
	Fputs ( stdout ,  "! Invalid character will be ignored" ) ;
	error () ;
      } 
      goto lab25 ;
    } 
    break ;
    default: 
    ;
    break ;
  } 
  while ( charclass [buffer [loc ]]== classvar ) loc = loc + 1 ;
  goto lab31 ;
  lab85: while ( charclass [buffer [loc ]]== 0 ) loc = loc + 1 ;
  if ( buffer [loc ]!= 46 ) 
  goto lab30 ;
  if ( charclass [buffer [loc + 1 ]]!= 0 ) 
  goto lab30 ;
  loc = loc + 1 ;
  lab86: do {
      loc = loc + 1 ;
  } while ( ! ( charclass [buffer [loc ]]!= 0 ) ) ;
  lab30: {
      
    curtype = 6 ;
    curtok = idfirst ;
    goto lab10 ;
  } 
  lab31: idloc = loc ;
  curtok = lookup () ;
  curtype = ilk [curtok ];
  lab10: ;
} 
void 
zflushbuffer ( eightbits b , boolean percent ) 
{
  /* 30 */ integer j, k  ;
  j = b ;
  if ( ! percent ) 
  while ( true ) {
      
    if ( j == 0 ) 
    goto lab30 ;
    if ( outbuf [j ]!= 32 ) 
    goto lab30 ;
    j = j - 1 ;
  } 
  lab30: {
      register integer for_end; k = 1 ;for_end = j ; if ( k <= for_end) 
  do 
    putc ( xchr [outbuf [k ]],  texfile );
  while ( k++ < for_end ) ;} 
  if ( percent ) 
  putc ( xchr [37 ],  texfile );
  putc ('\n',  texfile );
  outline = outline + 1 ;
  if ( b < outptr ) 
  {register integer for_end; k = b + 1 ;for_end = outptr ; if ( k <= 
  for_end) do 
    outbuf [k - b ]= outbuf [k ];
  while ( k++ < for_end ) ;} 
  outptr = outptr - b ;
} 
void 
breakout ( void ) 
{
  /* 10 */ integer k  ;
  ASCIIcode d  ;
  k = outptr ;
  while ( true ) {
      
    if ( k == 0 ) 
    {
      {
	putc ('\n',  stdout );
	fprintf ( stdout , "%s%ld",  "! Line had to be broken (output l." , (long)outline ) ;
      } 
      fprintf ( stdout , "%s\n",  "):" ) ;
      {register integer for_end; k = 1 ;for_end = outptr - 1 ; if ( k <= 
      for_end) do 
	putc ( xchr [outbuf [k ]],  stdout );
      while ( k++ < for_end ) ;} 
      putc ('\n',  stdout );
      if ( history == 0 ) 
      history = 1 ;
      flushbuffer ( outptr - 1 , true ) ;
      goto lab10 ;
    } 
    d = outbuf [k ];
    if ( d == 32 ) 
    {
      flushbuffer ( k , false ) ;
      goto lab10 ;
    } 
    if ( ( d == 92 ) && ( outbuf [k - 1 ]!= 92 ) ) 
    {
      flushbuffer ( k - 1 , true ) ;
      goto lab10 ;
    } 
    k = k - 1 ;
  } 
  lab10: ;
} 
void 
zoutstr ( namepointer p ) 
{
  integer k  ;
  {register integer for_end; k = bytestart [p ];for_end = bytestart [p + 
  1 ]- 1 ; if ( k <= for_end) do 
    {
      if ( outptr == linelength ) 
      breakout () ;
      outptr = outptr + 1 ;
      outbuf [outptr ]= bytemem [k ];
    } 
  while ( k++ < for_end ) ;} 
} 
void 
zoutname ( namepointer p ) 
{
  integer k  ;
  namepointer t  ;
  {register integer for_end; k = bytestart [p ];for_end = bytestart [p + 
  1 ]- 1 ; if ( k <= for_end) do 
    {
      t = translation [bytemem [k ]];
      if ( t == 0 ) 
      {
	if ( outptr == linelength ) 
	breakout () ;
	outptr = outptr + 1 ;
	outbuf [outptr ]= bytemem [k ];
      } 
      else outstr ( t ) ;
    } 
  while ( k++ < for_end ) ;} 
} 
void 
zoutmacandname ( ASCIIcode n , namepointer p ) 
{
  {
    if ( outptr == linelength ) 
    breakout () ;
    outptr = outptr + 1 ;
    outbuf [outptr ]= 92 ;
  } 
  {
    if ( outptr == linelength ) 
    breakout () ;
    outptr = outptr + 1 ;
    outbuf [outptr ]= n ;
  } 
  if ( bytestart [p + 1 ]- bytestart [p ]== 1 ) 
  outname ( p ) ;
  else {
      
    {
      if ( outptr == linelength ) 
      breakout () ;
      outptr = outptr + 1 ;
      outbuf [outptr ]= 123 ;
    } 
    outname ( p ) ;
    {
      if ( outptr == linelength ) 
      breakout () ;
      outptr = outptr + 1 ;
      outbuf [outptr ]= 125 ;
    } 
  } 
} 
void 
zcopy ( integer firstloc ) 
{
  integer k  ;
  {register integer for_end; k = firstloc ;for_end = loc - 1 ; if ( k <= 
  for_end) do 
    {
      if ( outptr == linelength ) 
      breakout () ;
      outptr = outptr + 1 ;
      outbuf [outptr ]= buffer [k ];
    } 
  while ( k++ < for_end ) ;} 
} 
void 
dothetranslation ( void ) 
{
  /* 20 21 30 10 */ integer k  ;
  integer t  ;
  lab20: if ( outptr > 0 ) 
  flushbuffer ( outptr , false ) ;
  emptybuffer = true ;
  while ( true ) {
      
    getnext () ;
    if ( startofline ) {
	
      if ( curtype >= 6 ) 
      {
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 36 ;
	} 
	startofline = false ;
	switch ( curtype ) 
	{case 10 : 
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 92 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 33 ;
	  } 
	  break ;
	case 11 : 
	case 12 : 
	case 13 : 
	case 14 : 
	case 15 : 
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 123 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 125 ;
	  } 
	  break ;
	  default: 
	  ;
	  break ;
	} 
      } 
      else if ( curtype == 1 ) 
      {
	outstr ( trskip ) ;
	goto lab20 ;
      } 
      else if ( curtype == 5 ) 
      goto lab20 ;
    } 
    lab21: switch ( curtype ) 
    {case 6 : 
      if ( buffer [loc ]== 47 ) {
	  
	if ( charclass [buffer [loc + 1 ]]== 0 ) 
	{
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 92 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 102 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 114 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 97 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 99 ;
	  } 
	  copy ( curtok ) ;
	  getnext () ;
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 47 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 123 ;
	  } 
	  getnext () ;
	  copy ( curtok ) ;
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 125 ;
	  } 
	} 
	else copy ( curtok ) ;
      } 
      else copy ( curtok ) ;
      break ;
    case 7 : 
      {
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 92 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 55 ;
	} 
	copy ( curtok ) ;
      } 
      break ;
    case 33 : 
    case 32 : 
      {
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 92 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 109 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 102 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 116 ;
	} 
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 98 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 101 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 103 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 105 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 110 ;
	} 
	if ( curtype == 33 ) 
	{
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 86 ;
	  } 
	  scannerstatus = 1 ;
	} 
	else if ( curtype == 32 ) 
	{
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 66 ;
	  } 
	  scannerstatus = 2 ;
	} 
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 123 ;
	} 
	outname ( curtok ) ;
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 125 ;
	} 
	getnext () ;
	while ( curtype != 34 ) {
	    
	  if ( curtype == 0 ) 
	  {
	    {
	      if ( outptr == linelength ) 
	      breakout () ;
	      outptr = outptr + 1 ;
	      outbuf [outptr ]= 32 ;
	    } 
	  } 
	  else if ( curtype == 1 ) 
	  {
	    flushbuffer ( outptr , false ) ;
	    emptybuffer = true ;
	  } 
	  else copy ( idfirst ) ;
	  getnext () ;
	} 
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 92 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 109 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 102 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 116 ;
	} 
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 101 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 110 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 100 ;
	} 
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 123 ;
	} 
	outname ( curtok ) ;
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 125 ;
	} 
	if ( scannerstatus == 1 ) 
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 36 ;
	} 
	scannerstatus = 0 ;
      } 
      break ;
    case 0 : 
      outstr ( trquad ) ;
      break ;
    case 1 : 
    case 5 : 
      {
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 36 ;
	} 
	if ( ( loc < limit ) && ( curtype == 1 ) ) 
	{
	  curtype = 29 ;
	  goto lab21 ;
	} 
	else {
	    
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 92 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 112 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 97 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 114 ;
	  } 
	  goto lab20 ;
	} 
      } 
      break ;
    case 2 : 
      goto lab10 ;
      break ;
    case 8 : 
      outmacandname ( 49 , curtok ) ;
      break ;
    case 9 : 
      outmacandname ( 50 , curtok ) ;
      break ;
    case 18 : 
      if ( prevtype == 9 ) 
      outmacandname ( 49 , curtok ) ;
      else outmacandname ( 50 , curtok ) ;
      break ;
    case 10 : 
      outmacandname ( 51 , curtok ) ;
      break ;
    case 13 : 
      outmacandname ( 52 , curtok ) ;
      break ;
    case 17 : 
      outmacandname ( 53 , curtok ) ;
      break ;
    case 11 : 
      outmacandname ( 54 , curtok ) ;
      break ;
    case 19 : 
      outmacandname ( 56 , curtok ) ;
      break ;
    case 20 : 
      outmacandname ( 63 , curtok ) ;
      break ;
    case 16 : 
    case 27 : 
    case 12 : 
      outname ( curtok ) ;
      break ;
    case 23 : 
      {
	if ( outptr == linelength ) 
	breakout () ;
	outptr = outptr + 1 ;
	outbuf [outptr ]= 92 ;
	if ( outptr == linelength ) 
	breakout () ;
	outptr = outptr + 1 ;
	outbuf [outptr ]= 59 ;
      } 
      break ;
    case 21 : 
      {
	outname ( curtok ) ;
	getnext () ;
	if ( curtype != 1 ) {
	    
	  if ( curtype != 10 ) 
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 92 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 32 ;
	  } 
	} 
	goto lab21 ;
      } 
      break ;
    case 22 : 
      outstr ( translation [92 ]) ;
      break ;
    case 15 : 
      outstr ( trps ) ;
      break ;
    case 24 : 
      outstr ( trle ) ;
      break ;
    case 25 : 
      outstr ( trge ) ;
      break ;
    case 26 : 
      outstr ( trne ) ;
      break ;
    case 14 : 
      outstr ( tramp ) ;
      break ;
    case 31 : 
      {
	outmacandname ( 50 , curtok ) ;
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 92 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 104 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 98 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 111 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 120 ;
	} 
	while ( buffer [loc ]== 32 ) loc = loc + 1 ;
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 123 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 92 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 116 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 116 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 32 ;
	} 
	while ( ( buffer [loc ]!= 32 ) && ( buffer [loc ]!= 37 ) && ( 
	buffer [loc ]!= 59 ) && ( loc < limit ) ) {
	    
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= buffer [loc ];
	  } 
	  loc = loc + 1 ;
	} 
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 125 ;
	} 
      } 
      break ;
    case 28 : 
    case 29 : 
      {
	if ( curtype == 28 ) 
	{
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 92 ;
	  if ( outptr == linelength ) 
	  breakout () ;
	  outptr = outptr + 1 ;
	  outbuf [outptr ]= 57 ;
	} 
	idfirst = loc ;
	while ( ( loc < limit ) && ( buffer [loc ]!= 124 ) ) loc = loc + 1 ;
	copy ( idfirst ) ;
	if ( loc < limit ) 
	{
	  startofline = true ;
	  loc = loc + 1 ;
	  k = loc ;
	  while ( ( k < limit ) && ( buffer [k ]!= 124 ) ) k = k + 1 ;
	  buffer [k ]= 13 ;
	} 
	else {
	    
	  if ( outbuf [outptr ]== 92 ) 
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 32 ;
	  } 
	  {
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 92 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 112 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 97 ;
	    if ( outptr == linelength ) 
	    breakout () ;
	    outptr = outptr + 1 ;
	    outbuf [outptr ]= 114 ;
	  } 
	  goto lab20 ;
	} 
      } 
      break ;
    case 3 : 
      {
	idfirst = loc ;
	loc = limit ;
	copy ( idfirst ) ;
	if ( outptr == 0 ) 
	{
	  outptr = 1 ;
	  outbuf [1 ]= 32 ;
	} 
	goto lab20 ;
      } 
      break ;
    case 4 : 
      {
	startofline = false ;
	getnext () ;
	t = curtype ;
	while ( curtype >= 8 ) {
	    
	  getnext () ;
	  if ( curtype >= 8 ) 
	  ilk [curtok ]= t ;
	} 
	if ( curtype != 1 ) {
	    
	  if ( curtype != 5 ) 
	  {
	    {
	      putc ('\n',  stdout );
	      Fputs ( stdout ,                "! Only symbolic tokens should appear after %%%" ) ;
	      error () ;
	    } 
	    goto lab21 ;
	  } 
	} 
	emptybuffer = true ;
	goto lab20 ;
      } 
      break ;
    case 30 : 
    case 35 : 
    case 36 : 
      {
	if ( bytestart [curtok + 1 ]- bytestart [curtok ]== 1 ) 
	outname ( curtok ) ;
	else outmacandname ( 92 , curtok ) ;
	getnext () ;
	if ( bytemem [bytestart [prevtok ]]== 39 ) 
	goto lab21 ;
	switch ( prevtype ) 
	{case 30 : 
	  {
	    if ( ( curtype == 6 ) || ( curtype >= 30 ) ) 
	    {
	      if ( outptr == linelength ) 
	      breakout () ;
	      outptr = outptr + 1 ;
	      outbuf [outptr ]= 92 ;
	      if ( outptr == linelength ) 
	      breakout () ;
	      outptr = outptr + 1 ;
	      outbuf [outptr ]= 44 ;
	    } 
	    goto lab21 ;
	  } 
	  break ;
	case 35 : 
	  if ( curtype < 30 ) 
	  goto lab21 ;
	  else {
	      
	    {
	      if ( outptr == linelength ) 
	      breakout () ;
	      outptr = outptr + 1 ;
	      outbuf [outptr ]= 46 ;
	    } 
	    curtype = 30 ;
	    goto lab21 ;
	  } 
	  break ;
	case 36 : 
	  {
	    if ( curtype == 36 ) {
		
	      if ( bytemem [bytestart [curtok ]]== 39 ) 
	      goto lab21 ;
	    } 
	    if ( ( curtype == 6 ) || ( curtype >= 30 ) ) 
	    {
	      {
		if ( outptr == linelength ) 
		breakout () ;
		outptr = outptr + 1 ;
		outbuf [outptr ]= 95 ;
		if ( outptr == linelength ) 
		breakout () ;
		outptr = outptr + 1 ;
		outbuf [outptr ]= 123 ;
	      } 
	      while ( true ) {
		  
		if ( curtype >= 30 ) 
		outname ( curtok ) ;
		else copy ( curtok ) ;
		if ( prevtype == 35 ) 
		{
		  getnext () ;
		  goto lab30 ;
		} 
		getnext () ;
		if ( curtype < 30 ) {
		    
		  if ( curtype != 6 ) 
		  goto lab30 ;
		} 
		if ( curtype == prevtype ) {
		    
		  if ( curtype == 6 ) 
		  {
		    if ( outptr == linelength ) 
		    breakout () ;
		    outptr = outptr + 1 ;
		    outbuf [outptr ]= 92 ;
		    if ( outptr == linelength ) 
		    breakout () ;
		    outptr = outptr + 1 ;
		    outbuf [outptr ]= 44 ;
		  } 
		  else if ( charclass [bytemem [bytestart [curtok ]]]== 
		  charclass [bytemem [bytestart [prevtok ]]]) {
		      
		    if ( bytemem [bytestart [prevtok ]]!= 46 ) 
		    {
		      if ( outptr == linelength ) 
		      breakout () ;
		      outptr = outptr + 1 ;
		      outbuf [outptr ]= 46 ;
		    } 
		    else {
			
		      if ( outptr == linelength ) 
		      breakout () ;
		      outptr = outptr + 1 ;
		      outbuf [outptr ]= 92 ;
		      if ( outptr == linelength ) 
		      breakout () ;
		      outptr = outptr + 1 ;
		      outbuf [outptr ]= 44 ;
		    } 
		  } 
		} 
	      } 
	      lab30: {
		  
		if ( outptr == linelength ) 
		breakout () ;
		outptr = outptr + 1 ;
		outbuf [outptr ]= 125 ;
	      } 
	      goto lab21 ;
	    } 
	    else if ( curtype == 27 ) 
	    outstr ( trsharp ) ;
	    else goto lab21 ;
	  } 
	  break ;
	} 
      } 
      break ;
    } 
  } 
  lab10: ;
} 
void mainbody( void ) {
    
  initialize () ;
  Fputs ( stdout ,  "This is MFT, Version 2.0" ) ;
  fprintf ( stdout , "%s\n",  versionstring ) ;
  idloc = 18 ;
  idfirst = 16 ;
  buffer [16 ]= 46 ;
  buffer [17 ]= 46 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 19 ) ;
  idfirst = 17 ;
  buffer [17 ]= 91 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 17 ;
  buffer [17 ]= 93 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 17 ;
  buffer [17 ]= 125 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 17 ;
  buffer [17 ]= 123 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 17 ;
  buffer [17 ]= 58 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 20 ) ;
  idfirst = 16 ;
  buffer [16 ]= 58 ;
  buffer [17 ]= 58 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 20 ) ;
  idfirst = 15 ;
  buffer [15 ]= 124 ;
  buffer [16 ]= 124 ;
  buffer [17 ]= 58 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 20 ) ;
  idfirst = 16 ;
  buffer [16 ]= 58 ;
  buffer [17 ]= 61 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 17 ;
  buffer [17 ]= 44 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 17 ;
  buffer [17 ]= 59 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 21 ) ;
  idfirst = 17 ;
  buffer [17 ]= 92 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 22 ) ;
  idfirst = 16 ;
  buffer [16 ]= 92 ;
  buffer [17 ]= 92 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 23 ) ;
  idfirst = 13 ;
  buffer [13 ]= 97 ;
  buffer [14 ]= 100 ;
  buffer [15 ]= 100 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 111 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 16 ;
  buffer [16 ]= 97 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 13 ) ;
  idfirst = 11 ;
  buffer [11 ]= 97 ;
  buffer [12 ]= 116 ;
  buffer [13 ]= 108 ;
  buffer [14 ]= 101 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 115 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 8 ;
  buffer [8 ]= 98 ;
  buffer [9 ]= 101 ;
  buffer [10 ]= 103 ;
  buffer [11 ]= 105 ;
  buffer [12 ]= 110 ;
  buffer [13 ]= 103 ;
  buffer [14 ]= 114 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 117 ;
  buffer [17 ]= 112 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 10 ;
  buffer [10 ]= 99 ;
  buffer [11 ]= 111 ;
  buffer [12 ]= 110 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 114 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 108 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 14 ;
  buffer [14 ]= 99 ;
  buffer [15 ]= 117 ;
  buffer [16 ]= 108 ;
  buffer [17 ]= 108 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 14 ;
  buffer [14 ]= 99 ;
  buffer [15 ]= 117 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 108 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 8 ;
  buffer [8 ]= 100 ;
  buffer [9 ]= 101 ;
  buffer [10 ]= 108 ;
  buffer [11 ]= 105 ;
  buffer [12 ]= 109 ;
  buffer [13 ]= 105 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 10 ;
  buffer [10 ]= 101 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 100 ;
  buffer [13 ]= 103 ;
  buffer [14 ]= 114 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 117 ;
  buffer [17 ]= 112 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 10 ) ;
  idfirst = 10 ;
  buffer [10 ]= 101 ;
  buffer [11 ]= 118 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 114 ;
  buffer [14 ]= 121 ;
  buffer [15 ]= 106 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 98 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 12 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 120 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 116 ;
  buffer [16 ]= 105 ;
  buffer [17 ]= 102 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 7 ;
  buffer [7 ]= 101 ;
  buffer [8 ]= 120 ;
  buffer [9 ]= 112 ;
  buffer [10 ]= 97 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 100 ;
  buffer [13 ]= 97 ;
  buffer [14 ]= 102 ;
  buffer [15 ]= 116 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 14 ;
  buffer [14 ]= 102 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 109 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 13 ) ;
  idfirst = 11 ;
  buffer [11 ]= 105 ;
  buffer [12 ]= 110 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 101 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 105 ;
  buffer [17 ]= 109 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 15 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 7 ;
  buffer [7 ]= 110 ;
  buffer [8 ]= 101 ;
  buffer [9 ]= 119 ;
  buffer [10 ]= 105 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 116 ;
  buffer [13 ]= 101 ;
  buffer [14 ]= 114 ;
  buffer [15 ]= 110 ;
  buffer [16 ]= 97 ;
  buffer [17 ]= 108 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 16 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 102 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 8 ;
  buffer [8 ]= 114 ;
  buffer [9 ]= 97 ;
  buffer [10 ]= 110 ;
  buffer [11 ]= 100 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 109 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 14 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 118 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 8 ;
  buffer [8 ]= 115 ;
  buffer [9 ]= 99 ;
  buffer [10 ]= 97 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 116 ;
  buffer [13 ]= 111 ;
  buffer [14 ]= 107 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 11 ;
  buffer [11 ]= 115 ;
  buffer [12 ]= 104 ;
  buffer [13 ]= 105 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 117 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 14 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 116 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 112 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 13 ) ;
  idfirst = 15 ;
  buffer [15 ]= 115 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 11 ;
  buffer [11 ]= 116 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 16 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 111 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 13 ) ;
  idfirst = 13 ;
  buffer [13 ]= 117 ;
  buffer [14 ]= 110 ;
  buffer [15 ]= 116 ;
  buffer [16 ]= 105 ;
  buffer [17 ]= 108 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 13 ) ;
  idfirst = 15 ;
  buffer [15 ]= 100 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 102 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 12 ;
  buffer [12 ]= 118 ;
  buffer [13 ]= 97 ;
  buffer [14 ]= 114 ;
  buffer [15 ]= 100 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 102 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 8 ;
  buffer [8 ]= 112 ;
  buffer [9 ]= 114 ;
  buffer [10 ]= 105 ;
  buffer [11 ]= 109 ;
  buffer [12 ]= 97 ;
  buffer [13 ]= 114 ;
  buffer [14 ]= 121 ;
  buffer [15 ]= 100 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 102 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 6 ;
  buffer [6 ]= 115 ;
  buffer [7 ]= 101 ;
  buffer [8 ]= 99 ;
  buffer [9 ]= 111 ;
  buffer [10 ]= 110 ;
  buffer [11 ]= 100 ;
  buffer [12 ]= 97 ;
  buffer [13 ]= 114 ;
  buffer [14 ]= 121 ;
  buffer [15 ]= 100 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 102 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 7 ;
  buffer [7 ]= 116 ;
  buffer [8 ]= 101 ;
  buffer [9 ]= 114 ;
  buffer [10 ]= 116 ;
  buffer [11 ]= 105 ;
  buffer [12 ]= 97 ;
  buffer [13 ]= 114 ;
  buffer [14 ]= 121 ;
  buffer [15 ]= 100 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 102 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 12 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 100 ;
  buffer [15 ]= 100 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 102 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 10 ) ;
  idfirst = 15 ;
  buffer [15 ]= 102 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 7 ;
  buffer [7 ]= 102 ;
  buffer [8 ]= 111 ;
  buffer [9 ]= 114 ;
  buffer [10 ]= 115 ;
  buffer [11 ]= 117 ;
  buffer [12 ]= 102 ;
  buffer [13 ]= 102 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 120 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 11 ;
  buffer [11 ]= 102 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 114 ;
  buffer [14 ]= 101 ;
  buffer [15 ]= 118 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 12 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 100 ;
  buffer [15 ]= 102 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 10 ) ;
  idfirst = 13 ;
  buffer [13 ]= 113 ;
  buffer [14 ]= 117 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 14 ;
  buffer [14 ]= 101 ;
  buffer [15 ]= 120 ;
  buffer [16 ]= 112 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 12 ;
  buffer [12 ]= 115 ;
  buffer [13 ]= 117 ;
  buffer [14 ]= 102 ;
  buffer [15 ]= 102 ;
  buffer [16 ]= 105 ;
  buffer [17 ]= 120 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 14 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 120 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 11 ;
  buffer [11 ]= 112 ;
  buffer [12 ]= 114 ;
  buffer [13 ]= 105 ;
  buffer [14 ]= 109 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 121 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 9 ;
  buffer [9 ]= 115 ;
  buffer [10 ]= 101 ;
  buffer [11 ]= 99 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 100 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 121 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 10 ;
  buffer [10 ]= 116 ;
  buffer [11 ]= 101 ;
  buffer [12 ]= 114 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 121 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 13 ;
  buffer [13 ]= 105 ;
  buffer [14 ]= 110 ;
  buffer [15 ]= 112 ;
  buffer [16 ]= 117 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 31 ) ;
  idfirst = 10 ;
  buffer [10 ]= 101 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 100 ;
  buffer [13 ]= 105 ;
  buffer [14 ]= 110 ;
  buffer [15 ]= 112 ;
  buffer [16 ]= 117 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 16 ;
  buffer [16 ]= 105 ;
  buffer [17 ]= 102 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 16 ;
  buffer [16 ]= 102 ;
  buffer [17 ]= 105 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 10 ) ;
  idfirst = 14 ;
  buffer [14 ]= 101 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 115 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 12 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 108 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 105 ;
  buffer [17 ]= 102 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 14 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 117 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 13 ;
  buffer [13 ]= 102 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 115 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 7 ;
  buffer [7 ]= 110 ;
  buffer [8 ]= 117 ;
  buffer [9 ]= 108 ;
  buffer [10 ]= 108 ;
  buffer [11 ]= 112 ;
  buffer [12 ]= 105 ;
  buffer [13 ]= 99 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 117 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 11 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 117 ;
  buffer [13 ]= 108 ;
  buffer [14 ]= 108 ;
  buffer [15 ]= 112 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 11 ;
  buffer [11 ]= 106 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 98 ;
  buffer [14 ]= 110 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 109 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 8 ;
  buffer [8 ]= 114 ;
  buffer [9 ]= 101 ;
  buffer [10 ]= 97 ;
  buffer [11 ]= 100 ;
  buffer [12 ]= 115 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 114 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 103 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 9 ;
  buffer [9 ]= 112 ;
  buffer [10 ]= 101 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 99 ;
  buffer [13 ]= 105 ;
  buffer [14 ]= 114 ;
  buffer [15 ]= 99 ;
  buffer [16 ]= 108 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 16 ;
  buffer [16 ]= 61 ;
  buffer [17 ]= 58 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 15 ;
  buffer [15 ]= 61 ;
  buffer [16 ]= 58 ;
  buffer [17 ]= 124 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 14 ;
  buffer [14 ]= 61 ;
  buffer [15 ]= 58 ;
  buffer [16 ]= 124 ;
  buffer [17 ]= 62 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 15 ;
  buffer [15 ]= 124 ;
  buffer [16 ]= 61 ;
  buffer [17 ]= 58 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 14 ;
  buffer [14 ]= 124 ;
  buffer [15 ]= 61 ;
  buffer [16 ]= 58 ;
  buffer [17 ]= 62 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 14 ;
  buffer [14 ]= 124 ;
  buffer [15 ]= 61 ;
  buffer [16 ]= 58 ;
  buffer [17 ]= 124 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 13 ;
  buffer [13 ]= 124 ;
  buffer [14 ]= 61 ;
  buffer [15 ]= 58 ;
  buffer [16 ]= 124 ;
  buffer [17 ]= 62 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 12 ;
  buffer [12 ]= 124 ;
  buffer [13 ]= 61 ;
  buffer [14 ]= 58 ;
  buffer [15 ]= 124 ;
  buffer [16 ]= 62 ;
  buffer [17 ]= 62 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 14 ;
  buffer [14 ]= 107 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 12 ;
  buffer [12 ]= 115 ;
  buffer [13 ]= 107 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 112 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 111 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 5 ;
  buffer [5 ]= 110 ;
  buffer [6 ]= 111 ;
  buffer [7 ]= 114 ;
  buffer [8 ]= 109 ;
  buffer [9 ]= 97 ;
  buffer [10 ]= 108 ;
  buffer [11 ]= 100 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 118 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 15 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 100 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 13 ;
  buffer [13 ]= 107 ;
  buffer [14 ]= 110 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 119 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 11 ;
  buffer [11 ]= 117 ;
  buffer [12 ]= 110 ;
  buffer [13 ]= 107 ;
  buffer [14 ]= 110 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 119 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 15 ;
  buffer [15 ]= 110 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 11 ;
  buffer [11 ]= 100 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 99 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 109 ;
  buffer [16 ]= 97 ;
  buffer [17 ]= 108 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 11 ;
  buffer [11 ]= 114 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 118 ;
  buffer [14 ]= 101 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 115 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 10 ;
  buffer [10 ]= 109 ;
  buffer [11 ]= 97 ;
  buffer [12 ]= 107 ;
  buffer [13 ]= 101 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 104 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 11 ;
  buffer [11 ]= 109 ;
  buffer [12 ]= 97 ;
  buffer [13 ]= 107 ;
  buffer [14 ]= 101 ;
  buffer [15 ]= 112 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 15 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 99 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 15 ;
  buffer [15 ]= 104 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 120 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 13 ;
  buffer [13 ]= 65 ;
  buffer [14 ]= 83 ;
  buffer [15 ]= 67 ;
  buffer [16 ]= 73 ;
  buffer [17 ]= 73 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 14 ;
  buffer [14 ]= 99 ;
  buffer [15 ]= 104 ;
  buffer [16 ]= 97 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 12 ;
  buffer [12 ]= 108 ;
  buffer [13 ]= 101 ;
  buffer [14 ]= 110 ;
  buffer [15 ]= 103 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 104 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 5 ;
  buffer [5 ]= 116 ;
  buffer [6 ]= 117 ;
  buffer [7 ]= 114 ;
  buffer [8 ]= 110 ;
  buffer [9 ]= 105 ;
  buffer [10 ]= 110 ;
  buffer [11 ]= 103 ;
  buffer [12 ]= 110 ;
  buffer [13 ]= 117 ;
  buffer [14 ]= 109 ;
  buffer [15 ]= 98 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 13 ;
  buffer [13 ]= 120 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 13 ;
  buffer [13 ]= 121 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 12 ;
  buffer [12 ]= 120 ;
  buffer [13 ]= 120 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 12 ;
  buffer [12 ]= 120 ;
  buffer [13 ]= 121 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 12 ;
  buffer [12 ]= 121 ;
  buffer [13 ]= 120 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 12 ;
  buffer [12 ]= 121 ;
  buffer [13 ]= 121 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 14 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 113 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 14 ;
  buffer [14 ]= 109 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 120 ;
  buffer [17 ]= 112 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 14 ;
  buffer [14 ]= 109 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 103 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 14 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 14 ;
  buffer [14 ]= 99 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 115 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 13 ;
  buffer [13 ]= 102 ;
  buffer [14 ]= 108 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 4 ;
  buffer [4 ]= 117 ;
  buffer [5 ]= 110 ;
  buffer [6 ]= 105 ;
  buffer [7 ]= 102 ;
  buffer [8 ]= 111 ;
  buffer [9 ]= 114 ;
  buffer [10 ]= 109 ;
  buffer [11 ]= 100 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 118 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 8 ;
  buffer [8 ]= 99 ;
  buffer [9 ]= 104 ;
  buffer [10 ]= 97 ;
  buffer [11 ]= 114 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 120 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 115 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 13 ;
  buffer [13 ]= 97 ;
  buffer [14 ]= 110 ;
  buffer [15 ]= 103 ;
  buffer [16 ]= 108 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 13 ;
  buffer [13 ]= 99 ;
  buffer [14 ]= 121 ;
  buffer [15 ]= 99 ;
  buffer [16 ]= 108 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 8 ) ;
  idfirst = 5 ;
  buffer [5 ]= 116 ;
  buffer [6 ]= 114 ;
  buffer [7 ]= 97 ;
  buffer [8 ]= 99 ;
  buffer [9 ]= 105 ;
  buffer [10 ]= 110 ;
  buffer [11 ]= 103 ;
  buffer [12 ]= 116 ;
  buffer [13 ]= 105 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 2 ;
  buffer [2 ]= 116 ;
  buffer [3 ]= 114 ;
  buffer [4 ]= 97 ;
  buffer [5 ]= 99 ;
  buffer [6 ]= 105 ;
  buffer [7 ]= 110 ;
  buffer [8 ]= 103 ;
  buffer [9 ]= 101 ;
  buffer [10 ]= 113 ;
  buffer [11 ]= 117 ;
  buffer [12 ]= 97 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 3 ;
  buffer [3 ]= 116 ;
  buffer [4 ]= 114 ;
  buffer [5 ]= 97 ;
  buffer [6 ]= 99 ;
  buffer [7 ]= 105 ;
  buffer [8 ]= 110 ;
  buffer [9 ]= 103 ;
  buffer [10 ]= 99 ;
  buffer [11 ]= 97 ;
  buffer [12 ]= 112 ;
  buffer [13 ]= 115 ;
  buffer [14 ]= 117 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 4 ;
  buffer [4 ]= 116 ;
  buffer [5 ]= 114 ;
  buffer [6 ]= 97 ;
  buffer [7 ]= 99 ;
  buffer [8 ]= 105 ;
  buffer [9 ]= 110 ;
  buffer [10 ]= 103 ;
  buffer [11 ]= 99 ;
  buffer [12 ]= 104 ;
  buffer [13 ]= 111 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 99 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 6 ;
  buffer [6 ]= 116 ;
  buffer [7 ]= 114 ;
  buffer [8 ]= 97 ;
  buffer [9 ]= 99 ;
  buffer [10 ]= 105 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 103 ;
  buffer [13 ]= 115 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 99 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 7 ;
  buffer [7 ]= 116 ;
  buffer [8 ]= 114 ;
  buffer [9 ]= 97 ;
  buffer [10 ]= 99 ;
  buffer [11 ]= 105 ;
  buffer [12 ]= 110 ;
  buffer [13 ]= 103 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 3 ;
  buffer [3 ]= 116 ;
  buffer [4 ]= 114 ;
  buffer [5 ]= 97 ;
  buffer [6 ]= 99 ;
  buffer [7 ]= 105 ;
  buffer [8 ]= 110 ;
  buffer [9 ]= 103 ;
  buffer [10 ]= 99 ;
  buffer [11 ]= 111 ;
  buffer [12 ]= 109 ;
  buffer [13 ]= 109 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 110 ;
  buffer [16 ]= 100 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 5 ;
  buffer [5 ]= 116 ;
  buffer [6 ]= 114 ;
  buffer [7 ]= 97 ;
  buffer [8 ]= 99 ;
  buffer [9 ]= 105 ;
  buffer [10 ]= 110 ;
  buffer [11 ]= 103 ;
  buffer [12 ]= 109 ;
  buffer [13 ]= 97 ;
  buffer [14 ]= 99 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 5 ;
  buffer [5 ]= 116 ;
  buffer [6 ]= 114 ;
  buffer [7 ]= 97 ;
  buffer [8 ]= 99 ;
  buffer [9 ]= 105 ;
  buffer [10 ]= 110 ;
  buffer [11 ]= 103 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 117 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 112 ;
  buffer [16 ]= 117 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 6 ;
  buffer [6 ]= 116 ;
  buffer [7 ]= 114 ;
  buffer [8 ]= 97 ;
  buffer [9 ]= 99 ;
  buffer [10 ]= 105 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 103 ;
  buffer [13 ]= 115 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 5 ;
  buffer [5 ]= 116 ;
  buffer [6 ]= 114 ;
  buffer [7 ]= 97 ;
  buffer [8 ]= 99 ;
  buffer [9 ]= 105 ;
  buffer [10 ]= 110 ;
  buffer [11 ]= 103 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 108 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 14 ;
  buffer [14 ]= 121 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 97 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 13 ;
  buffer [13 ]= 109 ;
  buffer [14 ]= 111 ;
  buffer [15 ]= 110 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 104 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 15 ;
  buffer [15 ]= 100 ;
  buffer [16 ]= 97 ;
  buffer [17 ]= 121 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 14 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 109 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 10 ;
  buffer [10 ]= 99 ;
  buffer [11 ]= 104 ;
  buffer [12 ]= 97 ;
  buffer [13 ]= 114 ;
  buffer [14 ]= 99 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 100 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 12 ;
  buffer [12 ]= 99 ;
  buffer [13 ]= 104 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 119 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 12 ;
  buffer [12 ]= 99 ;
  buffer [13 ]= 104 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 104 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 12 ;
  buffer [12 ]= 99 ;
  buffer [13 ]= 104 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 100 ;
  buffer [17 ]= 112 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 12 ;
  buffer [12 ]= 99 ;
  buffer [13 ]= 104 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 105 ;
  buffer [17 ]= 99 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 12 ;
  buffer [12 ]= 99 ;
  buffer [13 ]= 104 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 100 ;
  buffer [17 ]= 120 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 12 ;
  buffer [12 ]= 99 ;
  buffer [13 ]= 104 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 100 ;
  buffer [17 ]= 121 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 8 ;
  buffer [8 ]= 100 ;
  buffer [9 ]= 101 ;
  buffer [10 ]= 115 ;
  buffer [11 ]= 105 ;
  buffer [12 ]= 103 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 122 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 11 ;
  buffer [11 ]= 120 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 102 ;
  buffer [14 ]= 102 ;
  buffer [15 ]= 115 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 11 ;
  buffer [11 ]= 121 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 102 ;
  buffer [14 ]= 102 ;
  buffer [15 ]= 115 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 11 ;
  buffer [11 ]= 112 ;
  buffer [12 ]= 97 ;
  buffer [13 ]= 117 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 103 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 6 ;
  buffer [6 ]= 115 ;
  buffer [7 ]= 104 ;
  buffer [8 ]= 111 ;
  buffer [9 ]= 119 ;
  buffer [10 ]= 115 ;
  buffer [11 ]= 116 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 112 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 103 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 8 ;
  buffer [8 ]= 102 ;
  buffer [9 ]= 111 ;
  buffer [10 ]= 110 ;
  buffer [11 ]= 116 ;
  buffer [12 ]= 109 ;
  buffer [13 ]= 97 ;
  buffer [14 ]= 107 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 103 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 10 ;
  buffer [10 ]= 112 ;
  buffer [11 ]= 114 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 111 ;
  buffer [14 ]= 102 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 103 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 6 ;
  buffer [6 ]= 116 ;
  buffer [7 ]= 117 ;
  buffer [8 ]= 114 ;
  buffer [9 ]= 110 ;
  buffer [10 ]= 105 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 103 ;
  buffer [13 ]= 99 ;
  buffer [14 ]= 104 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 99 ;
  buffer [17 ]= 107 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 6 ;
  buffer [6 ]= 119 ;
  buffer [7 ]= 97 ;
  buffer [8 ]= 114 ;
  buffer [9 ]= 110 ;
  buffer [10 ]= 105 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 103 ;
  buffer [13 ]= 99 ;
  buffer [14 ]= 104 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 99 ;
  buffer [17 ]= 107 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 6 ;
  buffer [6 ]= 98 ;
  buffer [7 ]= 111 ;
  buffer [8 ]= 117 ;
  buffer [9 ]= 110 ;
  buffer [10 ]= 100 ;
  buffer [11 ]= 97 ;
  buffer [12 ]= 114 ;
  buffer [13 ]= 121 ;
  buffer [14 ]= 99 ;
  buffer [15 ]= 104 ;
  buffer [16 ]= 97 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 30 ) ;
  idfirst = 17 ;
  buffer [17 ]= 43 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 12 ) ;
  idfirst = 17 ;
  buffer [17 ]= 45 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 12 ) ;
  idfirst = 17 ;
  buffer [17 ]= 42 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 12 ) ;
  idfirst = 17 ;
  buffer [17 ]= 47 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 16 ;
  buffer [16 ]= 43 ;
  buffer [17 ]= 43 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 15 ;
  buffer [15 ]= 43 ;
  buffer [16 ]= 45 ;
  buffer [17 ]= 43 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 15 ) ;
  idfirst = 15 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 16 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 17 ;
  buffer [17 ]= 60 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 16 ;
  buffer [16 ]= 60 ;
  buffer [17 ]= 61 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 24 ) ;
  idfirst = 17 ;
  buffer [17 ]= 62 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 16 ;
  buffer [16 ]= 62 ;
  buffer [17 ]= 61 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 25 ) ;
  idfirst = 17 ;
  buffer [17 ]= 61 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 16 ) ;
  idfirst = 16 ;
  buffer [16 ]= 60 ;
  buffer [17 ]= 62 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 26 ) ;
  idfirst = 9 ;
  buffer [9 ]= 115 ;
  buffer [10 ]= 117 ;
  buffer [11 ]= 98 ;
  buffer [12 ]= 115 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 114 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 103 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 11 ;
  buffer [11 ]= 115 ;
  buffer [12 ]= 117 ;
  buffer [13 ]= 98 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 104 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 5 ;
  buffer [5 ]= 100 ;
  buffer [6 ]= 105 ;
  buffer [7 ]= 114 ;
  buffer [8 ]= 101 ;
  buffer [9 ]= 99 ;
  buffer [10 ]= 116 ;
  buffer [11 ]= 105 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 109 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 13 ;
  buffer [13 ]= 112 ;
  buffer [14 ]= 111 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 8 ;
  buffer [8 ]= 112 ;
  buffer [9 ]= 114 ;
  buffer [10 ]= 101 ;
  buffer [11 ]= 99 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 108 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 7 ;
  buffer [7 ]= 112 ;
  buffer [8 ]= 111 ;
  buffer [9 ]= 115 ;
  buffer [10 ]= 116 ;
  buffer [11 ]= 99 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 108 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 9 ;
  buffer [9 ]= 112 ;
  buffer [10 ]= 101 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 102 ;
  buffer [14 ]= 102 ;
  buffer [15 ]= 115 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 17 ;
  buffer [17 ]= 38 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 14 ) ;
  idfirst = 11 ;
  buffer [11 ]= 114 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 116 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 11 ;
  buffer [11 ]= 115 ;
  buffer [12 ]= 108 ;
  buffer [13 ]= 97 ;
  buffer [14 ]= 110 ;
  buffer [15 ]= 116 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 12 ;
  buffer [12 ]= 115 ;
  buffer [13 ]= 99 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 11 ;
  buffer [11 ]= 115 ;
  buffer [12 ]= 104 ;
  buffer [13 ]= 105 ;
  buffer [14 ]= 102 ;
  buffer [15 ]= 116 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 7 ;
  buffer [7 ]= 116 ;
  buffer [8 ]= 114 ;
  buffer [9 ]= 97 ;
  buffer [10 ]= 110 ;
  buffer [11 ]= 115 ;
  buffer [12 ]= 102 ;
  buffer [13 ]= 111 ;
  buffer [14 ]= 114 ;
  buffer [15 ]= 109 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 11 ;
  buffer [11 ]= 120 ;
  buffer [12 ]= 115 ;
  buffer [13 ]= 99 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 11 ;
  buffer [11 ]= 121 ;
  buffer [12 ]= 115 ;
  buffer [13 ]= 99 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 11 ;
  buffer [11 ]= 122 ;
  buffer [12 ]= 115 ;
  buffer [13 ]= 99 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 1 ;
  buffer [1 ]= 105 ;
  buffer [2 ]= 110 ;
  buffer [3 ]= 116 ;
  buffer [4 ]= 101 ;
  buffer [5 ]= 114 ;
  buffer [6 ]= 115 ;
  buffer [7 ]= 101 ;
  buffer [8 ]= 99 ;
  buffer [9 ]= 116 ;
  buffer [10 ]= 105 ;
  buffer [11 ]= 111 ;
  buffer [12 ]= 110 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 109 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 11 ) ;
  idfirst = 11 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 117 ;
  buffer [13 ]= 109 ;
  buffer [14 ]= 101 ;
  buffer [15 ]= 114 ;
  buffer [16 ]= 105 ;
  buffer [17 ]= 99 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 18 ) ;
  idfirst = 12 ;
  buffer [12 ]= 115 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 114 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 103 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 18 ) ;
  idfirst = 11 ;
  buffer [11 ]= 98 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 111 ;
  buffer [14 ]= 108 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 97 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 18 ) ;
  idfirst = 14 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 104 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 18 ) ;
  idfirst = 15 ;
  buffer [15 ]= 112 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 18 ) ;
  idfirst = 11 ;
  buffer [11 ]= 112 ;
  buffer [12 ]= 105 ;
  buffer [13 ]= 99 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 117 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 18 ) ;
  idfirst = 9 ;
  buffer [9 ]= 116 ;
  buffer [10 ]= 114 ;
  buffer [11 ]= 97 ;
  buffer [12 ]= 110 ;
  buffer [13 ]= 115 ;
  buffer [14 ]= 102 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 114 ;
  buffer [17 ]= 109 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 18 ) ;
  idfirst = 14 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 105 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 18 ) ;
  idfirst = 15 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 110 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 10 ) ;
  idfirst = 14 ;
  buffer [14 ]= 100 ;
  buffer [15 ]= 117 ;
  buffer [16 ]= 109 ;
  buffer [17 ]= 112 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 10 ) ;
  idfirst = 9 ;
  buffer [9 ]= 98 ;
  buffer [10 ]= 97 ;
  buffer [11 ]= 116 ;
  buffer [12 ]= 99 ;
  buffer [13 ]= 104 ;
  buffer [14 ]= 109 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 100 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 7 ;
  buffer [7 ]= 110 ;
  buffer [8 ]= 111 ;
  buffer [9 ]= 110 ;
  buffer [10 ]= 115 ;
  buffer [11 ]= 116 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 112 ;
  buffer [14 ]= 109 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 100 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 8 ;
  buffer [8 ]= 115 ;
  buffer [9 ]= 99 ;
  buffer [10 ]= 114 ;
  buffer [11 ]= 111 ;
  buffer [12 ]= 108 ;
  buffer [13 ]= 108 ;
  buffer [14 ]= 109 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 100 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 5 ;
  buffer [5 ]= 101 ;
  buffer [6 ]= 114 ;
  buffer [7 ]= 114 ;
  buffer [8 ]= 111 ;
  buffer [9 ]= 114 ;
  buffer [10 ]= 115 ;
  buffer [11 ]= 116 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 112 ;
  buffer [14 ]= 109 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 100 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 13 ;
  buffer [13 ]= 105 ;
  buffer [14 ]= 110 ;
  buffer [15 ]= 110 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 13 ;
  buffer [13 ]= 111 ;
  buffer [14 ]= 117 ;
  buffer [15 ]= 116 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 9 ;
  buffer [9 ]= 115 ;
  buffer [10 ]= 104 ;
  buffer [11 ]= 111 ;
  buffer [12 ]= 119 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 111 ;
  buffer [15 ]= 107 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 9 ;
  buffer [9 ]= 115 ;
  buffer [10 ]= 104 ;
  buffer [11 ]= 111 ;
  buffer [12 ]= 119 ;
  buffer [13 ]= 115 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 14 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 104 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 119 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 6 ;
  buffer [6 ]= 115 ;
  buffer [7 ]= 104 ;
  buffer [8 ]= 111 ;
  buffer [9 ]= 119 ;
  buffer [10 ]= 118 ;
  buffer [11 ]= 97 ;
  buffer [12 ]= 114 ;
  buffer [13 ]= 105 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 98 ;
  buffer [16 ]= 108 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 2 ;
  buffer [2 ]= 115 ;
  buffer [3 ]= 104 ;
  buffer [4 ]= 111 ;
  buffer [5 ]= 119 ;
  buffer [6 ]= 100 ;
  buffer [7 ]= 101 ;
  buffer [8 ]= 112 ;
  buffer [9 ]= 101 ;
  buffer [10 ]= 110 ;
  buffer [11 ]= 100 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 99 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 115 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 17 ) ;
  idfirst = 11 ;
  buffer [11 ]= 99 ;
  buffer [12 ]= 111 ;
  buffer [13 ]= 110 ;
  buffer [14 ]= 116 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 117 ;
  buffer [17 ]= 114 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 8 ;
  buffer [8 ]= 100 ;
  buffer [9 ]= 111 ;
  buffer [10 ]= 117 ;
  buffer [11 ]= 98 ;
  buffer [12 ]= 108 ;
  buffer [13 ]= 101 ;
  buffer [14 ]= 112 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 104 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 14 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 108 ;
  buffer [16 ]= 115 ;
  buffer [17 ]= 111 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 11 ;
  buffer [11 ]= 119 ;
  buffer [12 ]= 105 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 104 ;
  buffer [15 ]= 112 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 11 ;
  buffer [11 ]= 109 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 115 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 103 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 8 ;
  buffer [8 ]= 101 ;
  buffer [9 ]= 114 ;
  buffer [10 ]= 114 ;
  buffer [11 ]= 109 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 115 ;
  buffer [14 ]= 115 ;
  buffer [15 ]= 97 ;
  buffer [16 ]= 103 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 11 ;
  buffer [11 ]= 101 ;
  buffer [12 ]= 114 ;
  buffer [13 ]= 114 ;
  buffer [14 ]= 104 ;
  buffer [15 ]= 101 ;
  buffer [16 ]= 108 ;
  buffer [17 ]= 112 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 10 ;
  buffer [10 ]= 99 ;
  buffer [11 ]= 104 ;
  buffer [12 ]= 97 ;
  buffer [13 ]= 114 ;
  buffer [14 ]= 108 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 115 ;
  buffer [17 ]= 116 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 10 ;
  buffer [10 ]= 108 ;
  buffer [11 ]= 105 ;
  buffer [12 ]= 103 ;
  buffer [13 ]= 116 ;
  buffer [14 ]= 97 ;
  buffer [15 ]= 98 ;
  buffer [16 ]= 108 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 8 ;
  buffer [8 ]= 101 ;
  buffer [9 ]= 120 ;
  buffer [10 ]= 116 ;
  buffer [11 ]= 101 ;
  buffer [12 ]= 110 ;
  buffer [13 ]= 115 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 98 ;
  buffer [16 ]= 108 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 8 ;
  buffer [8 ]= 104 ;
  buffer [9 ]= 101 ;
  buffer [10 ]= 97 ;
  buffer [11 ]= 100 ;
  buffer [12 ]= 101 ;
  buffer [13 ]= 114 ;
  buffer [14 ]= 98 ;
  buffer [15 ]= 121 ;
  buffer [16 ]= 116 ;
  buffer [17 ]= 101 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 9 ;
  buffer [9 ]= 102 ;
  buffer [10 ]= 111 ;
  buffer [11 ]= 110 ;
  buffer [12 ]= 116 ;
  buffer [13 ]= 100 ;
  buffer [14 ]= 105 ;
  buffer [15 ]= 109 ;
  buffer [16 ]= 101 ;
  buffer [17 ]= 110 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 11 ;
  buffer [11 ]= 115 ;
  buffer [12 ]= 112 ;
  buffer [13 ]= 101 ;
  buffer [14 ]= 99 ;
  buffer [15 ]= 105 ;
  buffer [16 ]= 97 ;
  buffer [17 ]= 108 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 9 ) ;
  idfirst = 17 ;
  buffer [17 ]= 37 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 28 ) ;
  idfirst = 16 ;
  buffer [16 ]= 37 ;
  buffer [17 ]= 37 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 3 ) ;
  idfirst = 15 ;
  buffer [15 ]= 37 ;
  buffer [16 ]= 37 ;
  buffer [17 ]= 37 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 4 ) ;
  idfirst = 14 ;
  buffer [14 ]= 37 ;
  buffer [15 ]= 37 ;
  buffer [16 ]= 37 ;
  buffer [17 ]= 37 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 5 ) ;
  idfirst = 17 ;
  buffer [17 ]= 35 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 27 ) ;
  idfirst = 14 ;
  buffer [14 ]= 103 ;
  buffer [15 ]= 111 ;
  buffer [16 ]= 111 ;
  buffer [17 ]= 100 ;
  curtok = lookup () ;
  ilk [curtok ]= ( 35 ) ;
  if ( ! metapost ) 
  {
    idfirst = 6 ;
    buffer [6 ]= 97 ;
    buffer [7 ]= 117 ;
    buffer [8 ]= 116 ;
    buffer [9 ]= 111 ;
    buffer [10 ]= 114 ;
    buffer [11 ]= 111 ;
    buffer [12 ]= 117 ;
    buffer [13 ]= 110 ;
    buffer [14 ]= 100 ;
    buffer [15 ]= 105 ;
    buffer [16 ]= 110 ;
    buffer [17 ]= 103 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 11 ;
    buffer [11 ]= 99 ;
    buffer [12 ]= 104 ;
    buffer [13 ]= 97 ;
    buffer [14 ]= 114 ;
    buffer [15 ]= 102 ;
    buffer [16 ]= 97 ;
    buffer [17 ]= 109 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 10 ;
    buffer [10 ]= 100 ;
    buffer [11 ]= 114 ;
    buffer [12 ]= 111 ;
    buffer [13 ]= 112 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 105 ;
    buffer [16 ]= 110 ;
    buffer [17 ]= 103 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
    idfirst = 11 ;
    buffer [11 ]= 100 ;
    buffer [12 ]= 105 ;
    buffer [13 ]= 115 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 108 ;
    buffer [16 ]= 97 ;
    buffer [17 ]= 121 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
    idfirst = 12 ;
    buffer [12 ]= 102 ;
    buffer [13 ]= 105 ;
    buffer [14 ]= 108 ;
    buffer [15 ]= 108 ;
    buffer [16 ]= 105 ;
    buffer [17 ]= 110 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 7 ;
    buffer [7 ]= 103 ;
    buffer [8 ]= 114 ;
    buffer [9 ]= 97 ;
    buffer [10 ]= 110 ;
    buffer [11 ]= 117 ;
    buffer [12 ]= 108 ;
    buffer [13 ]= 97 ;
    buffer [14 ]= 114 ;
    buffer [15 ]= 105 ;
    buffer [16 ]= 116 ;
    buffer [17 ]= 121 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 10 ;
    buffer [10 ]= 105 ;
    buffer [11 ]= 110 ;
    buffer [12 ]= 119 ;
    buffer [13 ]= 105 ;
    buffer [14 ]= 110 ;
    buffer [15 ]= 100 ;
    buffer [16 ]= 111 ;
    buffer [17 ]= 119 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 13 ) ;
    idfirst = 14 ;
    buffer [14 ]= 104 ;
    buffer [15 ]= 112 ;
    buffer [16 ]= 112 ;
    buffer [17 ]= 112 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 11 ;
    buffer [11 ]= 107 ;
    buffer [12 ]= 101 ;
    buffer [13 ]= 101 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 105 ;
    buffer [16 ]= 110 ;
    buffer [17 ]= 103 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
    idfirst = 8 ;
    buffer [8 ]= 110 ;
    buffer [9 ]= 117 ;
    buffer [10 ]= 109 ;
    buffer [11 ]= 115 ;
    buffer [12 ]= 112 ;
    buffer [13 ]= 101 ;
    buffer [14 ]= 99 ;
    buffer [15 ]= 105 ;
    buffer [16 ]= 97 ;
    buffer [17 ]= 108 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
    idfirst = 8 ;
    buffer [8 ]= 111 ;
    buffer [9 ]= 112 ;
    buffer [10 ]= 101 ;
    buffer [11 ]= 110 ;
    buffer [12 ]= 119 ;
    buffer [13 ]= 105 ;
    buffer [14 ]= 110 ;
    buffer [15 ]= 100 ;
    buffer [16 ]= 111 ;
    buffer [17 ]= 119 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
    idfirst = 9 ;
    buffer [9 ]= 115 ;
    buffer [10 ]= 109 ;
    buffer [11 ]= 111 ;
    buffer [12 ]= 111 ;
    buffer [13 ]= 116 ;
    buffer [14 ]= 104 ;
    buffer [15 ]= 105 ;
    buffer [16 ]= 110 ;
    buffer [17 ]= 103 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 14 ;
    buffer [14 ]= 118 ;
    buffer [15 ]= 112 ;
    buffer [16 ]= 112 ;
    buffer [17 ]= 112 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 7 ;
    buffer [7 ]= 116 ;
    buffer [8 ]= 111 ;
    buffer [9 ]= 116 ;
    buffer [10 ]= 97 ;
    buffer [11 ]= 108 ;
    buffer [12 ]= 119 ;
    buffer [13 ]= 101 ;
    buffer [14 ]= 105 ;
    buffer [15 ]= 103 ;
    buffer [16 ]= 104 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 6 ;
    buffer [6 ]= 116 ;
    buffer [7 ]= 114 ;
    buffer [8 ]= 97 ;
    buffer [9 ]= 99 ;
    buffer [10 ]= 105 ;
    buffer [11 ]= 110 ;
    buffer [12 ]= 103 ;
    buffer [13 ]= 101 ;
    buffer [14 ]= 100 ;
    buffer [15 ]= 103 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 115 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 8 ;
    buffer [8 ]= 119 ;
    buffer [9 ]= 105 ;
    buffer [10 ]= 116 ;
    buffer [11 ]= 104 ;
    buffer [12 ]= 119 ;
    buffer [13 ]= 101 ;
    buffer [14 ]= 105 ;
    buffer [15 ]= 103 ;
    buffer [16 ]= 104 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
  } 
  if ( metapost ) 
  {
    idfirst = 9 ;
    buffer [9 ]= 97 ;
    buffer [10 ]= 114 ;
    buffer [11 ]= 99 ;
    buffer [12 ]= 108 ;
    buffer [13 ]= 101 ;
    buffer [14 ]= 110 ;
    buffer [15 ]= 103 ;
    buffer [16 ]= 116 ;
    buffer [17 ]= 104 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 11 ;
    buffer [11 ]= 97 ;
    buffer [12 ]= 114 ;
    buffer [13 ]= 99 ;
    buffer [14 ]= 116 ;
    buffer [15 ]= 105 ;
    buffer [16 ]= 109 ;
    buffer [17 ]= 101 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
    idfirst = 10 ;
    buffer [10 ]= 98 ;
    buffer [11 ]= 108 ;
    buffer [12 ]= 117 ;
    buffer [13 ]= 101 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 97 ;
    buffer [16 ]= 114 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 11 ;
    buffer [11 ]= 98 ;
    buffer [12 ]= 111 ;
    buffer [13 ]= 117 ;
    buffer [14 ]= 110 ;
    buffer [15 ]= 100 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 100 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 14 ;
    buffer [14 ]= 98 ;
    buffer [15 ]= 116 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 120 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 32 ) ;
    idfirst = 14 ;
    buffer [14 ]= 99 ;
    buffer [15 ]= 108 ;
    buffer [16 ]= 105 ;
    buffer [17 ]= 112 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
    idfirst = 11 ;
    buffer [11 ]= 99 ;
    buffer [12 ]= 108 ;
    buffer [13 ]= 105 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 112 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 100 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 9 ;
    buffer [9 ]= 99 ;
    buffer [10 ]= 108 ;
    buffer [11 ]= 111 ;
    buffer [12 ]= 115 ;
    buffer [13 ]= 101 ;
    buffer [14 ]= 102 ;
    buffer [15 ]= 114 ;
    buffer [16 ]= 111 ;
    buffer [17 ]= 109 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 31 ) ;
    idfirst = 13 ;
    buffer [13 ]= 99 ;
    buffer [14 ]= 111 ;
    buffer [15 ]= 108 ;
    buffer [16 ]= 111 ;
    buffer [17 ]= 114 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 18 ) ;
    idfirst = 12 ;
    buffer [12 ]= 100 ;
    buffer [13 ]= 97 ;
    buffer [14 ]= 115 ;
    buffer [15 ]= 104 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 100 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
    idfirst = 10 ;
    buffer [10 ]= 100 ;
    buffer [11 ]= 97 ;
    buffer [12 ]= 115 ;
    buffer [13 ]= 104 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 97 ;
    buffer [16 ]= 114 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 14 ;
    buffer [14 ]= 101 ;
    buffer [15 ]= 116 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 120 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 34 ) ;
    idfirst = 12 ;
    buffer [12 ]= 102 ;
    buffer [13 ]= 105 ;
    buffer [14 ]= 108 ;
    buffer [15 ]= 108 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 100 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 10 ;
    buffer [10 ]= 102 ;
    buffer [11 ]= 111 ;
    buffer [12 ]= 110 ;
    buffer [13 ]= 116 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 97 ;
    buffer [16 ]= 114 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 10 ;
    buffer [10 ]= 102 ;
    buffer [11 ]= 111 ;
    buffer [12 ]= 110 ;
    buffer [13 ]= 116 ;
    buffer [14 ]= 115 ;
    buffer [15 ]= 105 ;
    buffer [16 ]= 122 ;
    buffer [17 ]= 101 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 9 ;
    buffer [9 ]= 103 ;
    buffer [10 ]= 114 ;
    buffer [11 ]= 101 ;
    buffer [12 ]= 101 ;
    buffer [13 ]= 110 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 97 ;
    buffer [16 ]= 114 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 12 ;
    buffer [12 ]= 105 ;
    buffer [13 ]= 110 ;
    buffer [14 ]= 102 ;
    buffer [15 ]= 111 ;
    buffer [16 ]= 110 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 11 ) ;
    idfirst = 10 ;
    buffer [10 ]= 108 ;
    buffer [11 ]= 105 ;
    buffer [12 ]= 110 ;
    buffer [13 ]= 101 ;
    buffer [14 ]= 106 ;
    buffer [15 ]= 111 ;
    buffer [16 ]= 105 ;
    buffer [17 ]= 110 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 11 ;
    buffer [11 ]= 108 ;
    buffer [12 ]= 105 ;
    buffer [13 ]= 110 ;
    buffer [14 ]= 101 ;
    buffer [15 ]= 99 ;
    buffer [16 ]= 97 ;
    buffer [17 ]= 112 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 10 ;
    buffer [10 ]= 108 ;
    buffer [11 ]= 108 ;
    buffer [12 ]= 99 ;
    buffer [13 ]= 111 ;
    buffer [14 ]= 114 ;
    buffer [15 ]= 110 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 114 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 10 ;
    buffer [10 ]= 108 ;
    buffer [11 ]= 114 ;
    buffer [12 ]= 99 ;
    buffer [13 ]= 111 ;
    buffer [14 ]= 114 ;
    buffer [15 ]= 110 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 114 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 8 ;
    buffer [8 ]= 109 ;
    buffer [9 ]= 105 ;
    buffer [10 ]= 116 ;
    buffer [11 ]= 101 ;
    buffer [12 ]= 114 ;
    buffer [13 ]= 108 ;
    buffer [14 ]= 105 ;
    buffer [15 ]= 109 ;
    buffer [16 ]= 105 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 10 ;
    buffer [10 ]= 109 ;
    buffer [11 ]= 112 ;
    buffer [12 ]= 120 ;
    buffer [13 ]= 98 ;
    buffer [14 ]= 114 ;
    buffer [15 ]= 101 ;
    buffer [16 ]= 97 ;
    buffer [17 ]= 107 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 17 ) ;
    idfirst = 10 ;
    buffer [10 ]= 112 ;
    buffer [11 ]= 97 ;
    buffer [12 ]= 116 ;
    buffer [13 ]= 104 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 97 ;
    buffer [16 ]= 114 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 11 ;
    buffer [11 ]= 112 ;
    buffer [12 ]= 101 ;
    buffer [13 ]= 110 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 97 ;
    buffer [16 ]= 114 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 9 ;
    buffer [9 ]= 112 ;
    buffer [10 ]= 114 ;
    buffer [11 ]= 111 ;
    buffer [12 ]= 108 ;
    buffer [13 ]= 111 ;
    buffer [14 ]= 103 ;
    buffer [15 ]= 117 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 115 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 11 ;
    buffer [11 ]= 114 ;
    buffer [12 ]= 101 ;
    buffer [13 ]= 100 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 97 ;
    buffer [16 ]= 114 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 10 ;
    buffer [10 ]= 114 ;
    buffer [11 ]= 101 ;
    buffer [12 ]= 97 ;
    buffer [13 ]= 100 ;
    buffer [14 ]= 102 ;
    buffer [15 ]= 114 ;
    buffer [16 ]= 111 ;
    buffer [17 ]= 109 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 31 ) ;
    idfirst = 9 ;
    buffer [9 ]= 115 ;
    buffer [10 ]= 101 ;
    buffer [11 ]= 116 ;
    buffer [12 ]= 98 ;
    buffer [13 ]= 111 ;
    buffer [14 ]= 117 ;
    buffer [15 ]= 110 ;
    buffer [16 ]= 100 ;
    buffer [17 ]= 115 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
    idfirst = 11 ;
    buffer [11 ]= 115 ;
    buffer [12 ]= 116 ;
    buffer [13 ]= 114 ;
    buffer [14 ]= 111 ;
    buffer [15 ]= 107 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 100 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 10 ;
    buffer [10 ]= 116 ;
    buffer [11 ]= 101 ;
    buffer [12 ]= 120 ;
    buffer [13 ]= 116 ;
    buffer [14 ]= 112 ;
    buffer [15 ]= 97 ;
    buffer [16 ]= 114 ;
    buffer [17 ]= 116 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 11 ;
    buffer [11 ]= 116 ;
    buffer [12 ]= 101 ;
    buffer [13 ]= 120 ;
    buffer [14 ]= 116 ;
    buffer [15 ]= 117 ;
    buffer [16 ]= 97 ;
    buffer [17 ]= 108 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 2 ;
    buffer [2 ]= 116 ;
    buffer [3 ]= 114 ;
    buffer [4 ]= 97 ;
    buffer [5 ]= 99 ;
    buffer [6 ]= 105 ;
    buffer [7 ]= 110 ;
    buffer [8 ]= 103 ;
    buffer [9 ]= 108 ;
    buffer [10 ]= 111 ;
    buffer [11 ]= 115 ;
    buffer [12 ]= 116 ;
    buffer [13 ]= 99 ;
    buffer [14 ]= 104 ;
    buffer [15 ]= 97 ;
    buffer [16 ]= 114 ;
    buffer [17 ]= 115 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 7 ;
    buffer [7 ]= 116 ;
    buffer [8 ]= 114 ;
    buffer [9 ]= 117 ;
    buffer [10 ]= 101 ;
    buffer [11 ]= 99 ;
    buffer [12 ]= 111 ;
    buffer [13 ]= 114 ;
    buffer [14 ]= 110 ;
    buffer [15 ]= 101 ;
    buffer [16 ]= 114 ;
    buffer [17 ]= 115 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 30 ) ;
    idfirst = 10 ;
    buffer [10 ]= 117 ;
    buffer [11 ]= 108 ;
    buffer [12 ]= 99 ;
    buffer [13 ]= 111 ;
    buffer [14 ]= 114 ;
    buffer [15 ]= 110 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 114 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 10 ;
    buffer [10 ]= 117 ;
    buffer [11 ]= 114 ;
    buffer [12 ]= 99 ;
    buffer [13 ]= 111 ;
    buffer [14 ]= 114 ;
    buffer [15 ]= 110 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 114 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 8 ) ;
    idfirst = 7 ;
    buffer [7 ]= 118 ;
    buffer [8 ]= 101 ;
    buffer [9 ]= 114 ;
    buffer [10 ]= 98 ;
    buffer [11 ]= 97 ;
    buffer [12 ]= 116 ;
    buffer [13 ]= 105 ;
    buffer [14 ]= 109 ;
    buffer [15 ]= 116 ;
    buffer [16 ]= 101 ;
    buffer [17 ]= 120 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 33 ) ;
    idfirst = 12 ;
    buffer [12 ]= 119 ;
    buffer [13 ]= 105 ;
    buffer [14 ]= 116 ;
    buffer [15 ]= 104 ;
    buffer [16 ]= 105 ;
    buffer [17 ]= 110 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 13 ) ;
    idfirst = 9 ;
    buffer [9 ]= 119 ;
    buffer [10 ]= 105 ;
    buffer [11 ]= 116 ;
    buffer [12 ]= 104 ;
    buffer [13 ]= 99 ;
    buffer [14 ]= 111 ;
    buffer [15 ]= 108 ;
    buffer [16 ]= 111 ;
    buffer [17 ]= 114 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
    idfirst = 13 ;
    buffer [13 ]= 119 ;
    buffer [14 ]= 114 ;
    buffer [15 ]= 105 ;
    buffer [16 ]= 116 ;
    buffer [17 ]= 101 ;
    curtok = lookup () ;
    ilk [curtok ]= ( 9 ) ;
  } 
  {register integer for_end; i = 0 ;for_end = 255 ; if ( i <= for_end) do 
    translation [i ]= 0 ;
  while ( i++ < for_end ) ;} 
  byteptr = byteptr + 2 ;
  bytemem [byteptr - 2 ]= 92 ;
  bytemem [byteptr - 1 ]= 36 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [36 ]= curtok ;
  byteptr = byteptr + 2 ;
  bytemem [byteptr - 2 ]= 92 ;
  bytemem [byteptr - 1 ]= 35 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [35 ]= curtok ;
  byteptr = byteptr + 2 ;
  bytemem [byteptr - 2 ]= 92 ;
  bytemem [byteptr - 1 ]= 38 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [38 ]= curtok ;
  byteptr = byteptr + 2 ;
  bytemem [byteptr - 2 ]= 92 ;
  bytemem [byteptr - 1 ]= 123 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [123 ]= curtok ;
  byteptr = byteptr + 2 ;
  bytemem [byteptr - 2 ]= 92 ;
  bytemem [byteptr - 1 ]= 125 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [125 ]= curtok ;
  byteptr = byteptr + 2 ;
  bytemem [byteptr - 2 ]= 92 ;
  bytemem [byteptr - 1 ]= 95 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [95 ]= curtok ;
  byteptr = byteptr + 2 ;
  bytemem [byteptr - 2 ]= 92 ;
  bytemem [byteptr - 1 ]= 37 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [37 ]= curtok ;
  byteptr = byteptr + 4 ;
  bytemem [byteptr - 4 ]= 92 ;
  bytemem [byteptr - 3 ]= 66 ;
  bytemem [byteptr - 2 ]= 83 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [92 ]= curtok ;
  byteptr = byteptr + 4 ;
  bytemem [byteptr - 4 ]= 92 ;
  bytemem [byteptr - 3 ]= 72 ;
  bytemem [byteptr - 2 ]= 65 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [94 ]= curtok ;
  byteptr = byteptr + 4 ;
  bytemem [byteptr - 4 ]= 92 ;
  bytemem [byteptr - 3 ]= 84 ;
  bytemem [byteptr - 2 ]= 73 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [126 ]= curtok ;
  byteptr = byteptr + 5 ;
  bytemem [byteptr - 5 ]= 92 ;
  bytemem [byteptr - 4 ]= 97 ;
  bytemem [byteptr - 3 ]= 115 ;
  bytemem [byteptr - 2 ]= 116 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  translation [42 ]= curtok ;
  byteptr = byteptr + 4 ;
  bytemem [byteptr - 4 ]= 92 ;
  bytemem [byteptr - 3 ]= 65 ;
  bytemem [byteptr - 2 ]= 77 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  tramp = curtok ;
  byteptr = byteptr + 4 ;
  bytemem [byteptr - 4 ]= 92 ;
  bytemem [byteptr - 3 ]= 66 ;
  bytemem [byteptr - 2 ]= 76 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  trskip = curtok ;
  byteptr = byteptr + 4 ;
  bytemem [byteptr - 4 ]= 92 ;
  bytemem [byteptr - 3 ]= 83 ;
  bytemem [byteptr - 2 ]= 72 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  trsharp = curtok ;
  byteptr = byteptr + 4 ;
  bytemem [byteptr - 4 ]= 92 ;
  bytemem [byteptr - 3 ]= 80 ;
  bytemem [byteptr - 2 ]= 83 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  trps = curtok ;
  byteptr = byteptr + 4 ;
  bytemem [byteptr - 4 ]= 92 ;
  bytemem [byteptr - 3 ]= 108 ;
  bytemem [byteptr - 2 ]= 101 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  trle = curtok ;
  byteptr = byteptr + 4 ;
  bytemem [byteptr - 4 ]= 92 ;
  bytemem [byteptr - 3 ]= 103 ;
  bytemem [byteptr - 2 ]= 101 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  trge = curtok ;
  byteptr = byteptr + 4 ;
  bytemem [byteptr - 4 ]= 92 ;
  bytemem [byteptr - 3 ]= 110 ;
  bytemem [byteptr - 2 ]= 101 ;
  bytemem [byteptr - 1 ]= 32 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  trne = curtok ;
  byteptr = byteptr + 5 ;
  bytemem [byteptr - 5 ]= 92 ;
  bytemem [byteptr - 4 ]= 113 ;
  bytemem [byteptr - 3 ]= 117 ;
  bytemem [byteptr - 2 ]= 97 ;
  bytemem [byteptr - 1 ]= 100 ;
  curtok = nameptr ;
  nameptr = nameptr + 1 ;
  bytestart [nameptr ]= byteptr ;
  trquad = curtok ;
  {
    openinput () ;
    line = 0 ;
    otherline = 0 ;
    changing = true ;
    primethechangebuffer () ;
    changing = ! changing ;
    templine = otherline ;
    otherline = line ;
    line = templine ;
    styling = true ;
    limit = 0 ;
    loc = 1 ;
    buffer [0 ]= 32 ;
    inputhasended = false ;
  } 
  dothetranslation () ;
  if ( changelimit != 0 ) 
  {
    {register integer for_end; loc = 0 ;for_end = changelimit ; if ( loc <= 
    for_end) do 
      buffer [loc ]= changebuffer [loc ];
    while ( loc++ < for_end ) ;} 
    limit = changelimit ;
    changing = true ;
    line = otherline ;
    loc = changelimit ;
    {
      putc ('\n',  stdout );
      Fputs ( stdout ,  "! Change file entry did not match" ) ;
      error () ;
    } 
  } 
  switch ( history ) 
  {case 0 : 
    {
      putc ('\n',  stdout );
      Fputs ( stdout ,  "(No errors were found.)" ) ;
    } 
    break ;
  case 1 : 
    {
      putc ('\n',  stdout );
      Fputs ( stdout ,  "(Did you see the warning message above?)" ) ;
    } 
    break ;
  case 2 : 
    {
      putc ('\n',  stdout );
      Fputs ( stdout ,  "(Pardon me, but I think I spotted something wrong.)" ) 
      ;
    } 
    break ;
  case 3 : 
    {
      putc ('\n',  stdout );
      Fputs ( stdout ,  "(That was a fatal error, my friend.)" ) ;
    } 
    break ;
  } 
  putc ('\n',  stdout );
  if ( ( history != 0 ) && ( history != 1 ) ) 
  uexit ( 1 ) ;
  else uexit ( 0 ) ;
} 