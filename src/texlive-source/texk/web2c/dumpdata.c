/*1:*/
#line 20 "./luatexdir/tex/dumpdata.w"



#include "ptexlib.h"

#define font_id_text(A) cs_text(font_id_base+(A))
#define prev_depth cur_list.prev_depth_field



#define FORMAT_ID (907+11)
#if ((FORMAT_ID>=0) && (FORMAT_ID<=256))
#error Wrong value for FORMAT_ID.
#endif


/*:1*//*2:*/
#line 54 "./luatexdir/tex/dumpdata.w"

str_number format_ident;
str_number format_name;


/*:2*//*3:*/
#line 62 "./luatexdir/tex/dumpdata.w"

FILE*fmt_file;

/*:3*//*4:*/
#line 65 "./luatexdir/tex/dumpdata.w"

void store_fmt_file(void)
{
int j,k,l;
halfword p;
int x;
char*format_engine;
int callback_id;
char*fmtname= NULL;




if(save_ptr!=0){
print_err("You can't dump inside a group");
help1("`{...\\dump}' is a no-no.");
succumb();
}



callback_id= callback_defined(pre_dump_callback);
if(callback_id> 0){
(void)run_callback(callback_id,"->");
}
selector= new_string;
tprint(" (format=");
print(job_name);
print_char(' ');
print_int(int_par(year_code));
print_char('.');
print_int(int_par(month_code));
print_char('.');
print_int(int_par(day_code));
print_char(')');
str_room(2);
format_ident= make_string();
print(job_name);
format_name= make_string();
if(interaction==batch_mode)
selector= log_only;
else
selector= term_and_log;

fmtname= pack_job_name(format_extension);
while(!zopen_w_output(&fmt_file,fmtname,FOPEN_WBIN_MODE)){
fmtname= prompt_file_name("format file name",format_extension);
}
tprint_nl("Beginning to dump on file ");
tprint(fmtname);
free(fmtname);
tprint_nl("");
print(format_ident);





dump_int(0x57325458);
dump_int(FORMAT_ID);


x= (int)strlen(engine_name);
format_engine= xmalloc((unsigned)(x+4));
strcpy(format_engine,engine_name);
for(k= x;k<=x+3;k++)
format_engine[k]= 0;
x= x+4-(x%4);
dump_int(x);
dump_things(format_engine[0],x);
xfree(format_engine);
dump_int(0x57325458);
dump_int(max_halfword);
dump_int(hash_high);
dump_int(eqtb_size);
dump_int(hash_prime);


k= dump_string_pool();
print_ln();
print_int(k);
tprint(" strings using ");
print_int((longinteger)pool_size);
tprint(" bytes");









dump_node_mem();
dump_int(temp_token_head);
dump_int(hold_token_head);
dump_int(omit_template);
dump_int(null_list);
dump_int(backup_head);
dump_int(garbage);
x= (int)fix_mem_min;
dump_int(x);
x= (int)fix_mem_max;
dump_int(x);
x= (int)fix_mem_end;
dump_int(x);
dump_int(avail);
dyn_used= (int)fix_mem_end+1;
dump_things(fixmem[fix_mem_min],fix_mem_end-fix_mem_min+1);
x= x+(int)(fix_mem_end+1-fix_mem_min);
p= avail;
while(p!=null){
decr(dyn_used);
p= token_link(p);
}
dump_int(dyn_used);
print_ln();
print_int(x);
tprint(" memory locations dumped; current usage is ");
print_int(var_used);
print_char('&');
print_int(dyn_used);








k= null_cs;
do{
j= k;
while(j<int_base-1){
if((equiv(j)==equiv(j+1))&&(eq_type(j)==eq_type(j+1))&&
(eq_level(j)==eq_level(j+1)))
goto FOUND1;
incr(j);
}
l= int_base;
goto DONE1;
FOUND1:
incr(j);
l= j;
while(j<int_base-1){
if((equiv(j)!=equiv(j+1))||(eq_type(j)!=eq_type(j+1))||
(eq_level(j)!=eq_level(j+1)))
goto DONE1;
incr(j);
}
DONE1:
dump_int(l-k);
dump_things(eqtb[k],l-k);
k= j+1;
dump_int(k-l);
}while(k!=int_base);


do{
j= k;
while(j<eqtb_size){
if(eqtb[j].cint==eqtb[j+1].cint)
goto FOUND2;
incr(j);
}
l= eqtb_size+1;
goto DONE2;
FOUND2:
incr(j);
l= j;
while(j<eqtb_size){
if(eqtb[j].cint!=eqtb[j+1].cint)
goto DONE2;
incr(j);
}
DONE2:
dump_int(l-k);
dump_things(eqtb[k],l-k);
k= j+1;
dump_int(k-l);
}while(k<=eqtb_size);
if(hash_high> 0)
dump_things(eqtb[eqtb_size+1],hash_high);

dump_int(par_loc);
dump_int(write_loc);
dump_math_codes();
dump_text_codes();






dump_primitives();
dump_int(hash_used);
cs_count= frozen_control_sequence-1-hash_used+hash_high;
for(p= hash_base;p<=hash_used;p++){
if(cs_text(p)!=0){
dump_int(p);
dump_hh(hash[p]);
incr(cs_count);
}
}
dump_things(hash[hash_used+1],
undefined_control_sequence-1-hash_used);
if(hash_high> 0)
dump_things(hash[eqtb_size+1],hash_high);
dump_int(cs_count);
print_ln();
print_int(cs_count);
tprint(" multiletter control sequences");


dump_int(max_font_id());
for(k= 0;k<=max_font_id();k++){

dump_font(k);
tprint_nl("\\font");
print_esc(font_id_text(k));
print_char('=');
tprint_file_name((unsigned char*)font_name(k),
(unsigned char*)font_area(k),NULL);
if(font_size(k)!=font_dsize(k)){
tprint(" at ");
print_scaled(font_size(k));
tprint("pt");
}
}
print_ln();
print_int(max_font_id());
tprint(" preloaded font");
if(max_font_id()!=1)
print_char('s');
dump_math_data();


dump_language_data();


dump_int(interaction);
dump_int(format_ident);
dump_int(format_name);
dump_int(69069);


int_par(tracing_stats_code)= 0;


dump_luac_registers();


zwclose(fmt_file);
}

/*:4*//*5:*/
#line 324 "./luatexdir/tex/dumpdata.w"

#define too_small(A) do {     \
 wake_up_terminal();     \
 wterm_cr();      \
 fprintf(term_out,"---! Must increase the %s",(A)); \
 goto BAD_FMT;      \
    } while (0)

/*:5*//*6:*/
#line 336 "./luatexdir/tex/dumpdata.w"

#define undump(A,B,C) do {      \
 undump_int(x);       \
 if (x<(A) || x> (B)) goto BAD_FMT;    \
 else (C) =  x;       \
    } while (0)


#define format_debug(A,B) do {     \
 if (debug_format_file) {    \
     fprintf (stderr, "fmtdebug: %s=%d", (A), (int)(B)); \
 }       \
    } while (0)

#define undump_size(A,B,C,D) do {     \
 undump_int(x);       \
 if (x<(A))  goto BAD_FMT;     \
 if (x> (B))  too_small(C);     \
 else format_debug (C,x);     \
 (D) =  x;       \
    } while (0)


/*:6*//*7:*/
#line 359 "./luatexdir/tex/dumpdata.w"

boolean load_fmt_file(const char*fmtname)
{
int j,k;
halfword p;
int x;
char*format_engine;

if(ini_version){
libcfree(hash);
libcfree(eqtb);
libcfree(fixmem);
libcfree(varmem);
}
undump_int(x);
format_debug("format magic number",x);
if(x!=0x57325458)
goto BAD_FMT;

undump_int(x);
format_debug("format id",x);
if(x!=FORMAT_ID)
goto BAD_FMT;

undump_int(x);
format_debug("engine name size",x);
if((x<0)||(x> 256))
goto BAD_FMT;

format_engine= xmalloc((unsigned)x);
undump_things(format_engine[0],x);
format_engine[x-1]= 0;
if(strcmp(engine_name,format_engine)){
wake_up_terminal();
wterm_cr();
fprintf(term_out,"---! %s was written by %s",fmtname,format_engine);
xfree(format_engine);
goto BAD_FMT;
}
xfree(format_engine);
undump_int(x);
format_debug("string pool checksum",x);
if(x!=0x57325458){
wake_up_terminal();
wterm_cr();
fprintf(term_out,"---! %s was written by a different version",
fmtname);
goto BAD_FMT;
}
undump_int(x);
if(x!=max_halfword)
goto BAD_FMT;
undump_int(hash_high);
if((hash_high<0)||(hash_high> sup_hash_extra))
goto BAD_FMT;
if(hash_extra<hash_high)
hash_extra= hash_high;
eqtb_top= eqtb_size+hash_extra;
if(hash_extra==0)
hash_top= undefined_control_sequence;
else
hash_top= eqtb_top;
hash= xmallocarray(two_halves,(unsigned)(1+hash_top));
memset(hash,0,sizeof(two_halves)*(unsigned)(hash_top+1));
eqtb= xmallocarray(memory_word,(unsigned)(eqtb_top+1));
set_eq_type(undefined_control_sequence,undefined_cs_cmd);
set_equiv(undefined_control_sequence,null);
set_eq_level(undefined_control_sequence,level_zero);
for(x= eqtb_size+1;x<=eqtb_top;x++)
eqtb[x]= eqtb[undefined_control_sequence];
undump_int(x);
if(x!=eqtb_size)
goto BAD_FMT;
undump_int(x);
if(x!=hash_prime)
goto BAD_FMT;


str_ptr= undump_string_pool();

undump_node_mem();
undump_int(temp_token_head);
undump_int(hold_token_head);
undump_int(omit_template);
undump_int(null_list);
undump_int(backup_head);
undump_int(garbage);
undump_int(fix_mem_min);
undump_int(fix_mem_max);
fixmem= xmallocarray(smemory_word,fix_mem_max+1);
memset(voidcast(fixmem),0,(fix_mem_max+1)*sizeof(smemory_word));
undump_int(fix_mem_end);
undump_int(avail);
undump_things(fixmem[fix_mem_min],fix_mem_end-fix_mem_min+1);
undump_int(dyn_used);



k= null_cs;
do{
undump_int(x);
if((x<1)||(k+x> eqtb_size+1))
goto BAD_FMT;
undump_things(eqtb[k],x);
k= k+x;
undump_int(x);
if((x<0)||(k+x> eqtb_size+1))
goto BAD_FMT;
for(j= k;j<=k+x-1;j++)
eqtb[j]= eqtb[k-1];
k= k+x;
}while(k<=eqtb_size);
if(hash_high> 0)
undump_things(eqtb[eqtb_size+1],hash_high);

undump(hash_base,hash_top,par_loc);
par_token= cs_token_flag+par_loc;
undump(hash_base,hash_top,write_loc);
undump_math_codes();
undump_text_codes();

undump_primitives();
undump(hash_base,frozen_control_sequence,hash_used);
p= hash_base-1;
do{
undump(p+1,hash_used,p);
undump_hh(hash[p]);
}while(p!=hash_used);
undump_things(hash[hash_used+1],
undefined_control_sequence-1-hash_used);
if(debug_format_file)
print_csnames(hash_base,undefined_control_sequence-1);
if(hash_high> 0){
undump_things(hash[eqtb_size+1],hash_high);
if(debug_format_file)
print_csnames(eqtb_size+1,hash_high-(eqtb_size+1));
}
undump_int(cs_count);


undump_int(x);
set_max_font_id(x);
for(k= 0;k<=max_font_id();k++){

undump_font(k);
}
undump_math_data();


undump_language_data();


undump(batch_mode,error_stop_mode,interaction);
if(interactionoption!=unspecified_mode)
interaction= interactionoption;
undump(0,str_ptr,format_ident);
undump(0,str_ptr,format_name);
undump_int(x);
if(x!=69069)
goto BAD_FMT;


undump_luac_registers();

prev_depth= ignore_depth;
return true;
BAD_FMT:
wake_up_terminal();
wterm_cr();
fprintf(term_out,"(Fatal format file error; I'm stymied)");
return false;
}/*:7*/