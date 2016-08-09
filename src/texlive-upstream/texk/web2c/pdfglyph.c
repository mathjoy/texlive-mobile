/*1:*/
#line 20 "./luatexdir/pdf/pdfglyph.w"


#include "ptexlib.h"
#include "pdf/pdfpage.h"

/*:1*//*2:*/
#line 27 "./luatexdir/pdf/pdfglyph.w"

#define e_tj 3 

/*:2*//*3:*/
#line 30 "./luatexdir/pdf/pdfglyph.w"

static int64_t pdf_char_width(pdfstructure*p,internal_font_number f,int i)
{

return i64round((double)char_width(f,i)/font_size(f)*ten_pow[e_tj+p->cw.e]);
}

/*:3*//*4:*/
#line 37 "./luatexdir/pdf/pdfglyph.w"

void pdf_print_charwidth(PDF pdf,internal_font_number f,int i)
{
pdffloat cw;
pdfstructure*p= pdf->pstruct;
cw.m= pdf_char_width(p,f,i);
cw.e= p->cw.e;
print_pdffloat(pdf,cw);
}

/*:4*//*5:*/
#line 47 "./luatexdir/pdf/pdfglyph.w"

static void setup_fontparameters(PDF pdf,internal_font_number f,int ex_glyph)
{
float slant,extend,expand,scale= 1.0;
float u= 1.0;
pdfstructure*p= pdf->pstruct;

if((font_format(f)==opentype_format||(font_format(f)==type1_format&&font_encodingbytes(f)==2))&&font_units_per_em(f)> 0)
u= font_units_per_em(f)/1000.0;
pdf->f_cur= f;
p->f_pdf= pdf_set_font(pdf,f);
p->fs.m= i64round(font_size(f)/u/by_one_bp*ten_pow[p->fs.e]);
slant= font_slant(f)/1000.0;
extend= font_extend(f)/1000.0;
expand= 1.0+(ex_glyph/1)/1000.0;
p->tj_delta.e= p->cw.e-1;

while(p->tj_delta.e> 0&&(double)font_size(f)/ten_pow[p->tj_delta.e+e_tj]<0.5)
p->tj_delta.e--;
p->tm[0].m= i64round(scale*expand*extend*ten_pow[p->tm[0].e]);
p->tm[2].m= i64round(slant*ten_pow[p->tm[2].e]);
p->tm[3].m= i64round(scale*ten_pow[p->tm[3].e]);
p->k2= ten_pow[e_tj+p->cw.e]*scale/(ten_pow[p->pdf.h.e]*pdf2double(p->fs)*pdf2double(p->tm[0]));
p->cur_ex= ex_glyph;
}


/*:5*//*6:*/
#line 74 "./luatexdir/pdf/pdfglyph.w"

static void set_font(PDF pdf)
{
pdfstructure*p= pdf->pstruct;
pdf_printf(pdf,"/F%d",(int)p->f_pdf);
pdf_print_resname_prefix(pdf);
pdf_out(pdf,' ');
print_pdffloat(pdf,p->fs);
pdf_puts(pdf," Tf ");
p->f_pdf_cur= p->f_pdf;
p->fs_cur.m= p->fs.m;
p->need_tf= false;
p->need_tm= true;
}

/*:6*//*7:*/
#line 89 "./luatexdir/pdf/pdfglyph.w"

static void set_textmatrix(PDF pdf,scaledpos pos)
{
boolean move;
pdfstructure*p= pdf->pstruct;
if(!is_textmode(p))
normal_error("pdf backend","text mode expected in set_textmatrix");
move= calc_pdfpos(p,pos);
if(p->need_tm||move){
print_pdf_matrix(pdf,p->tm);
pdf_puts(pdf," Tm ");
p->pdf.h.m= p->pdf_bt_pos.h.m+p->tm[4].m;
p->pdf.v.m= p->pdf_bt_pos.v.m+p->tm[5].m;
p->need_tm= false;
}
p->tm0_cur.m= p->tm[0].m;
}

/*:7*//*8:*/
#line 111 "./luatexdir/pdf/pdfglyph.w"

static void pdf_print_char(PDF pdf,int c)
{
if(c> 255)
return;

if(c<=32||c=='\\'||c=='('||c==')'||c> 127){
pdf_room(pdf,4);
pdf_quick_out(pdf,'\\');
pdf_quick_out(pdf,(unsigned char)('0'+((c>>6)&0x3)));
pdf_quick_out(pdf,(unsigned char)('0'+((c>>3)&0x7)));
pdf_quick_out(pdf,(unsigned char)('0'+(c&0x7)));
}else
pdf_out(pdf,c);
}

static void pdf_print_wide_char(PDF pdf,int c)
{
char hex[5];
snprintf(hex,5,"%04X",c);
pdf_out_block(pdf,(const char*)hex,4);
}

/*:8*//*9:*/
#line 134 "./luatexdir/pdf/pdfglyph.w"

static void begin_charmode(PDF pdf,internal_font_number f,pdfstructure*p)
{
if(!is_chararraymode(p))
normal_error("pdf backend","char array mode expected in begin_char_mode");
if(font_encodingbytes(f)==2){
p->ishex= 1;
pdf_out(pdf,'<');
}else{
p->ishex= 0;
pdf_out(pdf,'(');
}
p->mode= PMODE_CHAR;
}

/*:9*//*10:*/
#line 149 "./luatexdir/pdf/pdfglyph.w"

void end_charmode(PDF pdf)
{
pdfstructure*p= pdf->pstruct;
if(!is_charmode(p))
normal_error("pdf backend","char mode expected in end_char_mode");
if(p->ishex==1){
p->ishex= 0;
pdf_out(pdf,'>');
}else{
pdf_out(pdf,')');
}
p->mode= PMODE_CHARARRAY;
}

/*:10*//*11:*/
#line 164 "./luatexdir/pdf/pdfglyph.w"

static void begin_chararray(PDF pdf)
{
pdfstructure*p= pdf->pstruct;
if(!is_textmode(p))
normal_error("pdf backend","text mode expected in begin_char_array");
p->pdf_tj_pos= p->pdf;
p->cw.m= 0;
pdf_out(pdf,'[');
p->mode= PMODE_CHARARRAY;
}

/*:11*//*12:*/
#line 176 "./luatexdir/pdf/pdfglyph.w"

void end_chararray(PDF pdf)
{
pdfstructure*p= pdf->pstruct;
if(!is_chararraymode(p))
normal_error("pdf backend","char array mode expected in end_char_array");
pdf_puts(pdf,"]TJ\n");
p->pdf= p->pdf_tj_pos;
p->mode= PMODE_TEXT;
}

/*:12*//*13:*/
#line 194 "./luatexdir/pdf/pdfglyph.w"

void pdf_place_glyph(PDF pdf,internal_font_number f,int c,int ex)
{
boolean move;
pdfstructure*p= pdf->pstruct;
scaledpos pos= pdf->posstruct->pos;
if(!char_exists(f,c))
return;
if(p->need_tf||f!=pdf->f_cur||p->f_pdf!=p->f_pdf_cur||p->fs.m!=p->fs_cur.m||is_pagemode(p)){
pdf_goto_textmode(pdf);
setup_fontparameters(pdf,f,ex);
set_font(pdf);
}else if(p->tm0_cur.m!=p->tm[0].m||p->cur_ex!=ex){
setup_fontparameters(pdf,f,ex);
p->need_tm= true;
}

move= calc_pdfpos(p,pos);
if(move||p->need_tm){
if(p->need_tm||(p->wmode==WMODE_H&&(p->pdf_bt_pos.v.m+p->tm[5].m)!=p->pdf.v.m)
||(p->wmode==WMODE_V&&(p->pdf_bt_pos.h.m+p->tm[4].m)!=p->pdf.h.m)
||abs(p->tj_delta.m)>=1000000){
pdf_goto_textmode(pdf);
set_textmatrix(pdf,pos);
begin_chararray(pdf);
move= calc_pdfpos(p,pos);
}
if(move){
if(is_charmode(p))
end_charmode(pdf);
print_pdffloat(pdf,p->tj_delta);
p->cw.m-= p->tj_delta.m*ten_pow[p->cw.e-p->tj_delta.e];
}
}

if(is_chararraymode(p))
begin_charmode(pdf,f,p);
else if(!is_charmode(p))
normal_error("pdf backend","char (array) mode expected in place_glyph");
pdf_mark_char(f,c);
if(font_encodingbytes(f)==2)
pdf_print_wide_char(pdf,char_index(f,c));
else
pdf_print_char(pdf,c);
p->cw.m+= pdf_char_width(p,p->f_pdf,c);
}/*:13*/