void parsearguments (void);
void initialize (void);
void showerrorcontext (void);
void fillbuffer (void);
void getkeywordchar (void);
void getnext (void);
void skiptoendofitem (void);
void finishtheproperty (void);
void lookup (void);
void zentername (byte v);
#define entername(v) zentername((byte) (v))
void getname (void);
byte getbyte (void);
void getfourbytes (void);
fixword getfix (void);
pointer zsortin (pointer h,fixword d);
#define sortin(h, d) zsortin((pointer) (h), (fixword) (d))
integer zmincover (pointer h,fixword d);
#define mincover(h, d) zmincover((pointer) (h), (fixword) (d))
fixword zshorten (pointer h,integer m);
#define shorten(h, m) zshorten((pointer) (h), (integer) (m))
void zsetindices (pointer h,fixword d);
#define setindices(h, d) zsetindices((pointer) (h), (fixword) (d))
void junkerror (void);
void zreadfourbytes (headerindex l);
#define readfourbytes(l) zreadfourbytes((headerindex) (l))
void zreadBCPL (headerindex l,byte n);
#define readBCPL(l, n) zreadBCPL((headerindex) (l), (byte) (n))
void zchecktag (byte c);
#define checktag(c) zchecktag((byte) (c))
void zprintoctal (byte c);
#define printoctal(c) zprintoctal((byte) (c))
boolean zhashinput (indx p,indx c);
#define hashinput(p, c) zhashinput((indx) (p), (indx) (c))
indx zf (indx h,indx x,indx y);
#define f(h, x, y) zf((indx) (h), (indx) (x), (indx) (y))
indx zeval (indx x,indx y);
#define eval(x, y) zeval((indx) (x), (indx) (y))
indx zf (indx h,indx x,indx y);
#define f(h, x, y) zf((indx) (h), (indx) (x), (indx) (y))
void zoutscaled (fixword x);
#define outscaled(x) zoutscaled((fixword) (x))
byte getnextraw (void);
byte ztodig (byte ch);
#define todig(ch) ztodig((byte) (ch))
void zprintjishex (integer jiscode);
#define printjishex(jiscode) zprintjishex((integer) (jiscode))
boolean zvalidjiscode (integer cx);
#define validjiscode(cx) zvalidjiscode((integer) (cx))
integer zjistoindex (integer jis);
#define jistoindex(jis) zjistoindex((integer) (jis))
integer zindextojis (integer ix);
#define indextojis(ix) zindextojis((integer) (ix))
integer getkanji (void);
void paramenter (void);
void nameenter (void);
void readligkern (void);
void readcharinfo (void);
void readinput (void);
void corrandcheck (void);
void readkanjiinfo (void);
void readgluekern (void);
void readcharsintype (void);
void readdirection (void);