/*1:*/
#line 20 "./luatexdir/tex/texnodes.w"


#include "ptexlib.h"
#include "lua/luatex-api.h"



/*:1*//*2:*/
#line 35 "./luatexdir/tex/texnodes.w"

#define attribute(A) eqtb[attribute_base+(A)].cint

#define uc_hyph int_par(uc_hyph_code)
#define cur_lang int_par(cur_lang_code)
#define left_hyphen_min int_par(left_hyphen_min_code)
#define right_hyphen_min int_par(right_hyphen_min_code)

#define MAX_CHAIN_SIZE 13 

#define CHECK_NODE_USAGE 1 

memory_word*volatile varmem= NULL;

#ifdef CHECK_NODE_USAGE
char*varmem_sizes= NULL;
#endif

halfword var_mem_max= 0;
halfword rover= 0;

halfword free_chain[MAX_CHAIN_SIZE]= {null};

static int my_prealloc= 0;

int fix_node_lists= 1;

halfword slow_get_node(int s);

#define fake_node 100
#define fake_node_size 2
#define fake_node_name "fake"

#define variable_node_size 2



const char*node_fields_list[]= {
"attr","width","depth","height","dir","shift","glue_order","glue_sign",
"glue_set","head",NULL
};
const char*node_fields_rule[]= {
"attr","width","depth","height","dir","index",NULL
};
const char*node_fields_insert[]= {
"attr","cost","depth","height","spec","head",NULL
};
const char*node_fields_mark[]= {
"attr","class","mark",NULL
};
const char*node_fields_adjust[]= {
"attr","head",NULL
};
const char*node_fields_disc[]= {
"attr","pre","post","replace","penalty",NULL
};
const char*node_fields_math[]= {
"attr","surround",NULL
};
const char*node_fields_glue[]= {
"attr","spec","leader",NULL
};
const char*node_fields_kern[]= {
"attr","kern","expansion_factor",NULL
};
const char*node_fields_penalty[]= {
"attr","penalty",NULL
};
const char*node_fields_unset[]= {
"attr","width","depth","height","dir","shrink","glue_order",
"glue_sign","stretch","span","head",NULL
};
const char*node_fields_margin_kern[]= {
"attr","width","glyph",NULL
};
const char*node_fields_glyph[]= {
"attr","char","font","lang","left","right","uchyph","components",
"xoffset","yoffset","width","height","depth","expansion_factor",NULL
};
const char*node_fields_inserting[]= {
"height","last_ins_ptr","best_ins_ptr",NULL
};
const char*node_fields_splitup[]= {
"height","last_ins_ptr","best_ins_ptr","broken_ptr","broken_ins",NULL
};
const char*node_fields_attribute[]= {
"number","value",NULL
};
const char*node_fields_glue_spec[]= {
"width","stretch","shrink","stretch_order","shrink_order","ref_count",
"writable",NULL
};
const char*node_fields_attribute_list[]= {
NULL
};
const char*node_fields_local_par[]= {
"attr","pen_inter","pen_broken","dir","box_left","box_left_width",
"box_right","box_right_width",NULL
};
const char*node_fields_dir[]= {
"attr","dir","level","dvi_ptr","dvi_h",NULL
};
const char*node_fields_boundary[]= {
"attr","value",NULL
};



const char*node_fields_noad[]= {
"attr","nucleus","sub","sup",NULL
};

#define node_fields_ord     node_fields_noad
#define node_fields_op      node_fields_noad
#define node_fields_bin     node_fields_noad
#define node_fields_rel     node_fields_noad
#define node_fields_open    node_fields_noad
#define node_fields_close   node_fields_noad
#define node_fields_punct   node_fields_noad
#define node_fields_inner   node_fields_noad
#define node_fields_under   node_fields_noad
#define node_fields_over    node_fields_noad
#define node_fields_vcenter node_fields_noad

const char*node_fields_style[]= {
"attr","style",NULL
};
const char*node_fields_choice[]= {
"attr","display","text","script","scriptscript",NULL
};
const char*node_fields_radical[]= {
"attr","nucleus","sub","sup","left","degree",NULL
};
const char*node_fields_fraction[]= {
"attr","width","num","denom","left","right",NULL
};
const char*node_fields_accent[]= {
"attr","nucleus","sub","sup","accent","bot_accent","top_accent",
"overlay_accent",NULL
};
const char*node_fields_fence[]= {
"attr","delim",NULL
};
const char*node_fields_math_char[]= {
"attr","fam","char",NULL
};
const char*node_fields_sub_box[]= {
"attr","head",NULL
};
const char*node_fields_sub_mlist[]= {
"attr","head",NULL
};
const char*node_fields_math_text_char[]= {
"attr","fam","char",NULL
};
const char*node_fields_delim[]= {
"attr","small_fam","small_char","large_fam","large_char",NULL
};



const char*node_fields_whatsit_open[]= {
"attr","stream","name","area","ext",NULL
};
const char*node_fields_whatsit_write[]= {
"attr","stream","data",NULL
};
const char*node_fields_whatsit_close[]= {
"attr","stream",NULL
};
const char*node_fields_whatsit_special[]= {
"attr","data",NULL
};
const char*node_fields_whatsit_save_pos[]= {
"attr",NULL
};
const char*node_fields_whatsit_late_lua[]= {
"attr","reg","data","name","string",NULL
};
const char*node_fields_whatsit_user_defined[]= {
"attr","user_id","type","value",NULL
};



const char*node_fields_whatsit_pdf_literal[]= {
"attr","mode","data",NULL
};
const char*node_fields_whatsit_pdf_refobj[]= {
"attr","objnum",NULL
};
const char*node_fields_whatsit_pdf_annot[]= {
"attr","width","depth","height","objnum","data",NULL
};
const char*node_fields_whatsit_pdf_start_link[]= {
"attr","width","depth","height","objnum","link_attr","action",NULL
};
const char*node_fields_whatsit_pdf_end_link[]= {
"attr",NULL
};
const char*node_fields_whatsit_pdf_dest[]= {
"attr","width","depth","height","named_id","dest_id","dest_type",
"xyz_zoom","objnum",NULL
};
const char*node_fields_whatsit_pdf_action[]= {
"action_type","named_id","action_id","file","new_window","data",
"ref_count",NULL
};
const char*node_fields_whatsit_pdf_thread[]= {
"attr","width","depth","height","named_id","thread_id","thread_attr",NULL
};
const char*node_fields_whatsit_pdf_start_thread[]= {
"attr","width","depth","height","named_id","thread_id","thread_attr",NULL
};
const char*node_fields_whatsit_pdf_end_thread[]= {
"attr",NULL
};
const char*node_fields_whatsit_pdf_colorstack[]= {
"attr","stack","cmd","data",NULL
};
const char*node_fields_whatsit_pdf_setmatrix[]= {
"attr","data",NULL
};
const char*node_fields_whatsit_pdf_save[]= {
"attr",NULL
};
const char*node_fields_whatsit_pdf_restore[]= {
"attr",NULL
};



const char*node_subtypes_glue[]= {
"userskip","lineskip","baselineskip","parskip","abovedisplayskip","belowdisplayskip",
"abovedisplayshortskip","belowdisplayshortskip","leftskip","rightskip","topskip",
"splittopskip","tabskip","spaceskip","xspaceskip","parfillskip","thinmuskip",
"medmuskip","thickmuskip","mathskip",NULL
};
const char*node_subtypes_leader[]= {
"leaders","cleaders","xleaders","gleaders",NULL
};
const char*node_subtypes_fill[]= {
"stretch","fi","fil","fill","filll",NULL
};
const char*node_subtypes_penalty[]= {
"userpenalty",NULL
};
const char*node_subtypes_kern[]= {
"fontkern","userkern","accentkern",NULL
};
const char*node_subtypes_rule[]= {
"normal","box","image","empty","user",NULL
};
const char*node_subtypes_glyph[]= {
"character","glyph","ligature","ghost","left","right",NULL
};
const char*node_subtypes_disc[]= {
"discretionary","explicit","automatic","regular","first","second",NULL
};
const char*node_subtypes_marginkern[]= {
"left","right",NULL
};
const char*node_subtypes_list[]= {
"unknown","line","box","indent","alignment","cell","equation","equationnumber",NULL
};
const char*node_subtypes_math[]= {
"beginmath","endmath",NULL
};
const char*node_subtypes_noad[]= {
"ord","opdisplaylimits","oplimits","opnolimits","bin","rel","open","close",
"punct","inner","under","over","vcenter",NULL
};
const char*node_subtypes_radical[]= {
"radical","uradical","uroot","uunderdelimiter","uoverdelimiter","udelimiterunder",
"udelimiterover",NULL
};
const char*node_subtypes_accent[]= {
"bothflexible","fixedtop","fixedbottom","fixedboth",NULL,
};
const char*node_subtypes_fence[]= {
"unset","left","middle","right",NULL
};

node_info node_data[]= {
{hlist_node,box_node_size,node_fields_list,"hlist",1},
{vlist_node,box_node_size,node_fields_list,"vlist",2},
{rule_node,rule_node_size,node_fields_rule,"rule",3},
{ins_node,ins_node_size,node_fields_insert,"ins",4},
{mark_node,mark_node_size,node_fields_mark,"mark",5},
{adjust_node,adjust_node_size,node_fields_adjust,"adjust",6},
{boundary_node,boundary_size,node_fields_boundary,"boundary",-1},
{disc_node,disc_node_size,node_fields_disc,"disc",8},
{whatsit_node,-1,NULL,"whatsit",9},
{local_par_node,local_par_size,node_fields_local_par,"local_par",-1},
{dir_node,dir_node_size,node_fields_dir,"dir",-1},
{math_node,math_node_size,node_fields_math,"math",10},
{glue_node,glue_node_size,node_fields_glue,"glue",11},
{kern_node,kern_node_size,node_fields_kern,"kern",12},
{penalty_node,penalty_node_size,node_fields_penalty,"penalty",13},
{unset_node,box_node_size,node_fields_unset,"unset",14},
{style_node,style_node_size,node_fields_style,"style",15},
{choice_node,style_node_size,node_fields_choice,"choice",15},
{simple_noad,noad_size,node_fields_ord,"noad",15},
{radical_noad,radical_noad_size,node_fields_radical,"radical",15},
{fraction_noad,fraction_noad_size,node_fields_fraction,"fraction",15},
{accent_noad,accent_noad_size,node_fields_accent,"accent",15},
{fence_noad,fence_noad_size,node_fields_fence,"fence",15},
{math_char_node,math_kernel_node_size,node_fields_math_char,"math_char",15},
{sub_box_node,math_kernel_node_size,node_fields_sub_box,"sub_box",15},
{sub_mlist_node,math_kernel_node_size,node_fields_sub_mlist,"sub_mlist",15},
{math_text_char_node,math_kernel_node_size,node_fields_math_text_char,"math_text_char",15},
{delim_node,math_shield_node_size,node_fields_delim,"delim",15},
{margin_kern_node,margin_kern_node_size,node_fields_margin_kern,"margin_kern",-1},
{glyph_node,glyph_node_size,node_fields_glyph,"glyph",0},
{align_record_node,box_node_size,NULL,"align_record",-1},
{pseudo_file_node,pseudo_file_node_size,NULL,"pseudo_file",-1},
{pseudo_line_node,variable_node_size,NULL,"pseudo_line",-1},
{inserting_node,page_ins_node_size,node_fields_inserting,"page_insert",-1},
{split_up_node,page_ins_node_size,node_fields_splitup,"split_insert",-1},
{expr_node,expr_node_size,NULL,"expr_stack",-1},
{nesting_node,nesting_node_size,NULL,"nested_list",-1},
{span_node,span_node_size,NULL,"span",-1},
{attribute_node,attribute_node_size,node_fields_attribute,"attribute",-1},
{glue_spec_node,glue_spec_size,node_fields_glue_spec,"glue_spec",-1},
{attribute_list_node,attribute_node_size,node_fields_attribute_list,"attribute_list",-1},
{temp_node,temp_node_size,NULL,"temp",-1},
{align_stack_node,align_stack_node_size,NULL,"align_stack",-1},
{movement_node,movement_node_size,NULL,"movement_stack",-1},
{if_node,if_node_size,NULL,"if_stack",-1},
{unhyphenated_node,active_node_size,NULL,"unhyphenated",-1},
{hyphenated_node,active_node_size,NULL,"hyphenated",-1},
{delta_node,delta_node_size,NULL,"delta",-1},
{passive_node,passive_node_size,NULL,"passive",-1},
{shape_node,variable_node_size,NULL,"shape",-1},
{-1,-1,NULL,NULL,-1},
};

#define last_normal_node shape_node

const char*node_subtypes_pdf_destination[]= {
"xyz","fit","fith","fitv","fitb","fitbh","fitbv","fitr",NULL
};
const char*node_subtypes_pdf_literal[]= {
"origin","page","direct",NULL
};

node_info whatsit_node_data[]= {
{open_node,open_node_size,node_fields_whatsit_open,"open",-1},
{write_node,write_node_size,node_fields_whatsit_write,"write",-1},
{close_node,close_node_size,node_fields_whatsit_close,"close",-1},
{special_node,special_node_size,node_fields_whatsit_special,"special",-1},
{fake_node,fake_node_size,NULL,fake_node_name,-1},
{fake_node,fake_node_size,NULL,fake_node_name,-1},
{save_pos_node,save_pos_node_size,node_fields_whatsit_save_pos,"save_pos",-1},
{late_lua_node,late_lua_node_size,node_fields_whatsit_late_lua,"late_lua",-1},
{user_defined_node,user_defined_node_size,node_fields_whatsit_user_defined,"user_defined",-1},
{fake_node,fake_node_size,NULL,fake_node_name,-1},
{fake_node,fake_node_size,NULL,fake_node_name,-1},
{fake_node,fake_node_size,NULL,fake_node_name,-1},
{fake_node,fake_node_size,NULL,fake_node_name,-1},
{fake_node,fake_node_size,NULL,fake_node_name,-1},
{fake_node,fake_node_size,NULL,fake_node_name,-1},
{fake_node,fake_node_size,NULL,fake_node_name,-1},



{pdf_literal_node,write_node_size,node_fields_whatsit_pdf_literal,"pdf_literal",-1},
{pdf_refobj_node,pdf_refobj_node_size,node_fields_whatsit_pdf_refobj,"pdf_refobj",-1},
{pdf_annot_node,pdf_annot_node_size,node_fields_whatsit_pdf_annot,"pdf_annot",-1},
{pdf_start_link_node,pdf_annot_node_size,node_fields_whatsit_pdf_start_link,"pdf_start_link",-1},
{pdf_end_link_node,pdf_end_link_node_size,node_fields_whatsit_pdf_end_link,"pdf_end_link",-1},
{pdf_dest_node,pdf_dest_node_size,node_fields_whatsit_pdf_dest,"pdf_dest",-1},
{pdf_action_node,pdf_action_size,node_fields_whatsit_pdf_action,"pdf_action",-1},
{pdf_thread_node,pdf_thread_node_size,node_fields_whatsit_pdf_thread,"pdf_thread",-1},
{pdf_start_thread_node,pdf_thread_node_size,node_fields_whatsit_pdf_start_thread,"pdf_start_thread",-1},
{pdf_end_thread_node,pdf_end_thread_node_size,node_fields_whatsit_pdf_end_thread,"pdf_end_thread",-1},
{pdf_thread_data_node,pdf_thread_node_size,NULL,"pdf_thread_data",-1},
{pdf_link_data_node,pdf_annot_node_size,NULL,"pdf_link_data",-1},
{pdf_colorstack_node,pdf_colorstack_node_size,node_fields_whatsit_pdf_colorstack,"pdf_colorstack",-1},
{pdf_setmatrix_node,pdf_setmatrix_node_size,node_fields_whatsit_pdf_setmatrix,"pdf_setmatrix",-1},
{pdf_save_node,pdf_save_node_size,node_fields_whatsit_pdf_save,"pdf_save",-1},
{pdf_restore_node,pdf_restore_node_size,node_fields_whatsit_pdf_restore,"pdf_restore",-1},

{-1,-1,NULL,NULL,-1},
};

#define last_whatsit_node pdf_restore_node

/*:2*//*3:*/
#line 462 "./luatexdir/tex/texnodes.w"

int lua_properties_level= 0;
int lua_properties_enabled= 0;
int lua_properties_use_metatable= 0;

/*:3*//*4:*/
#line 471 "./luatexdir/tex/texnodes.w"

#define lua_properties_push do { \
    if (lua_properties_enabled) { \
        lua_properties_level =  lua_properties_level + 1 ; \
        if (lua_properties_level == 1) { \
            lua_rawgeti(Luas, LUA_REGISTRYINDEX, luaS_index(node_properties)); \
            lua_gettable(Luas, LUA_REGISTRYINDEX); \
        } \
    } \
} while(0)

#define lua_properties_pop do { \
    if (lua_properties_enabled) { \
        if (lua_properties_level == 1) \
            lua_pop(Luas,1); \
        lua_properties_level =  lua_properties_level - 1 ; \
    } \
} while(0)



#define lua_properties_set(target) do { \
} while(0)



#define lua_properties_reset(target) do { \
    if (lua_properties_enabled) { \
        if (lua_properties_level == 0) { \
            lua_rawgeti(Luas, LUA_REGISTRYINDEX, luaS_index(node_properties)); \
            lua_gettable(Luas, LUA_REGISTRYINDEX); \
            lua_pushnil(Luas); \
            lua_rawseti(Luas,-2,target); \
            lua_pop(Luas,1); \
        } else { \
            lua_pushnil(Luas); \
            lua_rawseti(Luas,-2,target); \
        } \
    } \
} while(0)






































#define lua_properties_copy(target,source) do { \
    if (lua_properties_enabled) { \
        if (lua_properties_level == 0) { \
            lua_rawgeti(Luas, LUA_REGISTRYINDEX, luaS_index(node_properties)); \
            lua_gettable(Luas, LUA_REGISTRYINDEX); \
            lua_rawgeti(Luas,-1,source); \
            if (lua_type(Luas,-1)==LUA_TTABLE) { \
                if (lua_properties_use_metatable) { \
                    lua_newtable(Luas); \
                    lua_insert(Luas,-2); \
                    lua_setfield(Luas,-2,"__index"); \
                    lua_newtable(Luas); \
                    lua_insert(Luas,-2); \
                    lua_setmetatable(Luas,-2); \
                } \
                lua_rawseti(Luas,-2,target); \
            } else { \
                lua_pop(Luas,1); \
            } \
            lua_pop(Luas,1); \
        } else { \
            lua_rawgeti(Luas,-1,source); \
            if (lua_type(Luas,-1)==LUA_TTABLE) { \
                if (lua_properties_use_metatable) { \
                    lua_newtable(Luas); \
                    lua_insert(Luas,-2); \
                    lua_setfield(Luas,-2,"__index"); \
                    lua_newtable(Luas); \
                    lua_insert(Luas,-2); \
                    lua_setmetatable(Luas,-2); \
                } \
                lua_rawseti(Luas,-2,target); \
            } else { \
                lua_pop(Luas,1); \
            } \
        } \
    } \
} while(0)



/*:4*//*5:*/
#line 590 "./luatexdir/tex/texnodes.w"

int valid_node(halfword p)
{
if(p> my_prealloc&&p<var_mem_max){
#ifdef CHECK_NODE_USAGE
if(varmem_sizes[p]> 0){
return 1;
}
#else
return 1;
#endif
}
return 0;
}

/*:5*//*6:*/
#line 605 "./luatexdir/tex/texnodes.w"

static int test_count= 1;

#define dorangetest(a,b,c)  do {                                 \
    if (!(b>=0 && b<c)) {                                        \
        fprintf(stdout,"For node p:=%d, 0<=%d<%d (l.%d,r.%d)\n", \
            (int)a, (int)b, (int)c, __LINE__,test_count);        \
        confusion("node range test failed");                     \
    } } while (0)

#define dotest(a,b,c) do {                                     \
    if (b!=c) {                                                \
        fprintf(stdout,"For node p:=%d, %d==%d (l.%d,r.%d)\n", \
            (int)a, (int)b, (int)c, __LINE__,test_count);      \
        confusion("node test failed");                         \
    } } while (0)

#define check_action_ref(a)    { dorangetest(p,a,var_mem_max); }
#define check_glue_ref(a)      { dorangetest(p,a,var_mem_max); }
#define check_attribute_ref(a) { dorangetest(p,a,var_mem_max); }
#define check_token_ref(a)     { confusion("fuzzy token cleanup in node"); }

#ifdef CHECK_NODE_USAGE

static void check_static_node_mem(void)
{
dotest(zero_glue,width(zero_glue),0);
dotest(zero_glue,type(zero_glue),glue_spec_node);
dotest(zero_glue,vlink(zero_glue),null);
dotest(zero_glue,stretch(zero_glue),0);
dotest(zero_glue,stretch_order(zero_glue),normal);
dotest(zero_glue,shrink(zero_glue),0);
dotest(zero_glue,shrink_order(zero_glue),normal);

dotest(sfi_glue,width(sfi_glue),0);
dotest(sfi_glue,type(sfi_glue),glue_spec_node);
dotest(sfi_glue,vlink(sfi_glue),null);
dotest(sfi_glue,stretch(sfi_glue),0);
dotest(sfi_glue,stretch_order(sfi_glue),sfi);
dotest(sfi_glue,shrink(sfi_glue),0);
dotest(sfi_glue,shrink_order(sfi_glue),normal);

dotest(fil_glue,width(fil_glue),0);
dotest(fil_glue,type(fil_glue),glue_spec_node);
dotest(fil_glue,vlink(fil_glue),null);
dotest(fil_glue,stretch(fil_glue),unity);
dotest(fil_glue,stretch_order(fil_glue),fil);
dotest(fil_glue,shrink(fil_glue),0);
dotest(fil_glue,shrink_order(fil_glue),normal);

dotest(fill_glue,width(fill_glue),0);
dotest(fill_glue,type(fill_glue),glue_spec_node);
dotest(fill_glue,vlink(fill_glue),null);
dotest(fill_glue,stretch(fill_glue),unity);
dotest(fill_glue,stretch_order(fill_glue),fill);
dotest(fill_glue,shrink(fill_glue),0);
dotest(fill_glue,shrink_order(fill_glue),normal);

dotest(ss_glue,width(ss_glue),0);
dotest(ss_glue,type(ss_glue),glue_spec_node);
dotest(ss_glue,vlink(ss_glue),null);
dotest(ss_glue,stretch(ss_glue),unity);
dotest(ss_glue,stretch_order(ss_glue),fil);
dotest(ss_glue,shrink(ss_glue),unity);
dotest(ss_glue,shrink_order(ss_glue),fil);

dotest(fil_neg_glue,width(fil_neg_glue),0);
dotest(fil_neg_glue,type(fil_neg_glue),glue_spec_node);
dotest(fil_neg_glue,vlink(fil_neg_glue),null);
dotest(fil_neg_glue,stretch(fil_neg_glue),-unity);
dotest(fil_neg_glue,stretch_order(fil_neg_glue),fil);
dotest(fil_neg_glue,shrink(fil_neg_glue),0);
dotest(fil_neg_glue,shrink_order(fil_neg_glue),normal);
}

static void node_mem_dump(halfword p)
{
halfword r;
for(r= my_prealloc+1;r<var_mem_max;r++){
if(vlink(r)==p){
halfword s= r;
while(s> my_prealloc&&varmem_sizes[s]==0){
s--;
}
if(s!=null
&&s!=my_prealloc
&&s!=var_mem_max
&&(r-s)<get_node_size(type(s),subtype(s))
&&alink(s)!=p){
if(type(s)==disc_node){
fprintf(stdout,"  pointed to from %s node %d (vlink %d, alink %d): ",
get_node_name(type(s),subtype(s)),(int)s,
(int)vlink(s),(int)alink(s));
fprintf(stdout,"pre_break(%d,%d,%d), ",
(int)vlink_pre_break(s),(int)tlink(pre_break(s)),
(int)alink(pre_break(s)));
fprintf(stdout,"post_break(%d,%d,%d), ",
(int)vlink_post_break(s),
(int)tlink(post_break(s)),
(int)alink(post_break(s)));
fprintf(stdout,"no_break(%d,%d,%d)",
(int)vlink_no_break(s),(int)tlink(no_break(s)),
(int)alink(no_break(s)));
fprintf(stdout,"\n");
}else{
if(vlink(s)==p
||(type(s)==glyph_node&&lig_ptr(s)==p)
||(type(s)==vlist_node&&list_ptr(s)==p)
||(type(s)==hlist_node&&list_ptr(s)==p)
||(type(s)==unset_node&&list_ptr(s)==p)
||(type(s)==ins_node&&ins_ptr(s)==p)
){
fprintf(stdout,"  pointed to from %s node %d (vlink %d, alink %d): ",
get_node_name(type(s),subtype(s)),(int)s,
(int)vlink(s),(int)alink(s));
if(type(s)==glyph_node){
fprintf(stdout,"lig_ptr(%d)",(int)lig_ptr(s));
}else if(type(s)==vlist_node||type(s)==hlist_node){
fprintf(stdout,"list_ptr(%d)",(int)list_ptr(s));
}
fprintf(stdout,"\n");
}else{
if((type(s)!=penalty_node)&&(type(s)!=math_node)&&(type(s)!=kern_node)){
fprintf(stdout,"  pointed to from %s node %d\n",
get_node_name(type(s),subtype(s)),(int)s);
}
}
}
}
}
}
}

#endif

static int free_error(halfword p)
{
if(p> my_prealloc&&p<var_mem_max){
#ifdef CHECK_NODE_USAGE
int i;
if(varmem_sizes[p]==0){
check_static_node_mem();
for(i= (my_prealloc+1);i<var_mem_max;i++){
if(varmem_sizes[i]> 0){
check_node(i);
}
}
test_count++;
if(type(p)==glyph_node){
formatted_error("nodes","attempt to double-free glyph (%c) node %d, ignored",(int)character(p),(int)p);
}else{
formatted_error("nodes","attempt to double-free %s node %d, ignored",get_node_name(type(p),subtype(p)),(int)p);
}
node_mem_dump(p);
return 1;
}
#endif
}else{
formatted_error("nodes","attempt to free an impossible node %d",(int)p);
return 1;
}
return 0;
}

/*:6*//*7:*/
#line 769 "./luatexdir/tex/texnodes.w"

static int copy_error(halfword p)
{
if(p>=0&&p<var_mem_max){
#ifdef CHECK_NODE_USAGE
if(p> my_prealloc&&varmem_sizes[p]==0){
if(type(p)==glyph_node){
formatted_warning("nodes","attempt to copy free glyph (%c) node %d, ignored",(int)character(p),(int)p);
}else{
formatted_warning("nodes","attempt to copy free %s node %d, ignored",get_node_name(type(p),subtype(p)),(int)p);
}
return 1;
}
#endif
}else{
formatted_error("nodes","attempt to copy an impossible node %d",(int)p);
return 1;
}
return 0;
}

/*:7*//*8:*/
#line 790 "./luatexdir/tex/texnodes.w"

halfword new_node(int i,int j)
{
int s= get_node_size(i,j);
halfword n= get_node(s);







(void)memset((void*)(varmem+n+1),0,(sizeof(memory_word)*((unsigned)s-1)));
switch(i){
case glyph_node:
init_lang_data(n);
break;
case hlist_node:
case vlist_node:
box_dir(n)= -1;
break;
case disc_node:
pre_break(n)= pre_break_head(n);
type(pre_break(n))= nesting_node;
subtype(pre_break(n))= pre_break_head(0);
post_break(n)= post_break_head(n);
type(post_break(n))= nesting_node;
subtype(post_break(n))= post_break_head(0);
no_break(n)= no_break_head(n);
type(no_break(n))= nesting_node;
subtype(no_break(n))= no_break_head(0);
break;
case rule_node:
depth(n)= null_flag;
height(n)= null_flag;
width(n)= null_flag;
rule_dir(n)= -1;
rule_index(n)= 0;
rule_transform(n)= 0;
break;
case whatsit_node:
if(j==open_node){
open_name(n)= get_nullstr();
open_area(n)= open_name(n);
open_ext(n)= open_name(n);
}
break;
case unset_node:
width(n)= null_flag;
break;
case pseudo_line_node:
case shape_node:




if(j> 0){
free_node(n,variable_node_size);
n= slow_get_node(j);
(void)memset((void*)(varmem+n+1),0,(sizeof(memory_word)*((unsigned)j-1)));
}
break;
default:
break;
}
if(int_par(synctex_code)){

switch(i){
case math_node:
synctex_tag_math(n)= cur_input.synctex_tag_field;
synctex_line_math(n)= line;
break;
case glue_node:
synctex_tag_glue(n)= cur_input.synctex_tag_field;
synctex_line_glue(n)= line;
break;
case kern_node:
if(j!=0){
synctex_tag_kern(n)= cur_input.synctex_tag_field;
synctex_line_kern(n)= line;
}
break;
case hlist_node:
case vlist_node:
case unset_node:
synctex_tag_box(n)= cur_input.synctex_tag_field;
synctex_line_box(n)= line;
break;
case rule_node:
synctex_tag_rule(n)= cur_input.synctex_tag_field;
synctex_line_rule(n)= line;
break;
}
}

if(nodetype_has_attributes(i)){
build_attribute_list(n);

}
type(n)= (quarterword)i;
subtype(n)= (quarterword)j;
return n;
}

halfword raw_glyph_node(void)
{
register halfword n= get_node(glyph_node_size);
(void)memset((void*)(varmem+n+1),0,(sizeof(memory_word)*(glyph_node_size-1)));
type(n)= glyph_node;
subtype(n)= 0;
return n;
}

halfword new_glyph_node(void)
{
register halfword n= get_node(glyph_node_size);
(void)memset((void*)(varmem+n+1),0,(sizeof(memory_word)*(glyph_node_size-1)));
type(n)= glyph_node;
subtype(n)= 0;
build_attribute_list(n);

return n;
}

/*:8*//*9:*/
#line 917 "./luatexdir/tex/texnodes.w"

halfword do_copy_node_list(halfword p,halfword end)
{
halfword q= null;
halfword h= null;
register halfword s;
lua_properties_push;
while(p!=end){
s= copy_node(p);
if(h==null){
h= s;
}else{
couple_nodes(q,s);
}
q= s;
p= vlink(p);
}
lua_properties_pop;
return h;
}

halfword copy_node_list(halfword p)
{
return do_copy_node_list(p,null);
}

#define copy_sub_list(target,source) do { \
     if (source != null) { \
         s =  do_copy_node_list(source, null); \
         target =  s; \
     } else { \
         target =  null; \
     } \
 } while (0)

#define copy_sub_node(target,source) do { \
    if (source != null) { \
        s =  copy_node(source); \
        target =  s ; \
    } else { \
        target =  null; \
    } \
} while (0)

/*:9*//*10:*/
#line 963 "./luatexdir/tex/texnodes.w"

static void copy_node_wrapup_core(halfword p,halfword r)
{
halfword s;
switch(subtype(p)){
case write_node:
case special_node:
add_token_ref(write_tokens(p));
break;
case late_lua_node:
copy_late_lua(r,p);
break;
case user_defined_node:
switch(user_node_type(p)){
case'a':
add_node_attr_ref(user_node_value(p));
break;
case'l':
copy_user_lua(r,p);
break;
case'n':
s= copy_node_list(user_node_value(p));
user_node_value(r)= s;
break;
case's':

break;
case't':
add_token_ref(user_node_value(p));
break;
}
break;
default:
break;
}
}

void copy_node_wrapup_dvi(halfword p,halfword r)
{
}

void copy_node_wrapup_pdf(halfword p,halfword r)
{
switch(subtype(p)){
case pdf_literal_node:
copy_pdf_literal(r,p);
break;
case pdf_colorstack_node:
if(pdf_colorstack_cmd(p)<=colorstack_data)
add_token_ref(pdf_colorstack_data(p));
break;
case pdf_setmatrix_node:
add_token_ref(pdf_setmatrix_data(p));
break;
case pdf_annot_node:
add_token_ref(pdf_annot_data(p));
break;
case pdf_start_link_node:
if(pdf_link_attr(r)!=null)
add_token_ref(pdf_link_attr(r));
add_action_ref(pdf_link_action(r));
break;
case pdf_dest_node:
if(pdf_dest_named_id(p)> 0)
add_token_ref(pdf_dest_id(p));
break;
case pdf_thread_node:
case pdf_start_thread_node:
if(pdf_thread_named_id(p)> 0)
add_token_ref(pdf_thread_id(p));
if(pdf_thread_attr(p)!=null)
add_token_ref(pdf_thread_attr(p));
break;
default:
break;
}
}

halfword copy_node(const halfword p)
{
halfword r;
halfword w;
register halfword s;
register int i;
if(copy_error(p)){
r= new_node(temp_node,0);
return r;
}
i= get_node_size(type(p),subtype(p));
r= get_node(i);

(void)memcpy((void*)(varmem+r),(void*)(varmem+p),(sizeof(memory_word)*(unsigned)i));

if(int_par(synctex_code)){

switch(type(p)){
case math_node:
synctex_tag_math(r)= cur_input.synctex_tag_field;
synctex_line_math(r)= line;
break;
case kern_node:
synctex_tag_kern(r)= cur_input.synctex_tag_field;
synctex_line_kern(r)= line;
break;
}
}
if(nodetype_has_attributes(type(p))){
add_node_attr_ref(node_attr(p));
alink(r)= null;
lua_properties_copy(r,p);
}
vlink(r)= null;

switch(type(p)){
case glyph_node:
copy_sub_list(lig_ptr(r),lig_ptr(p));
break;
case glue_node:
add_glue_ref(glue_ptr(p));
copy_sub_list(leader_ptr(r),leader_ptr(p));
break;
case hlist_node:
case vlist_node:
case unset_node:
copy_sub_list(list_ptr(r),list_ptr(p));
break;
case disc_node:
pre_break(r)= pre_break_head(r);
if(vlink_pre_break(p)!=null){
s= copy_node_list(vlink_pre_break(p));
alink(s)= pre_break(r);
tlink_pre_break(r)= tail_of_list(s);
vlink_pre_break(r)= s;
}else{
assert(tlink(pre_break(r))==null);
}
post_break(r)= post_break_head(r);
if(vlink_post_break(p)!=null){
s= copy_node_list(vlink_post_break(p));
alink(s)= post_break(r);
tlink_post_break(r)= tail_of_list(s);
vlink_post_break(r)= s;
}else{
assert(tlink_post_break(r)==null);
}
no_break(r)= no_break_head(r);
if(vlink(no_break(p))!=null){
s= copy_node_list(vlink_no_break(p));
alink(s)= no_break(r);
tlink_no_break(r)= tail_of_list(s);
vlink_no_break(r)= s;
}else{
assert(tlink_no_break(r)==null);
}
break;
case math_node:
if(glue_ptr(p)!=zero_glue){
add_glue_ref(glue_ptr(p));
}
break;
case ins_node:
add_glue_ref(split_top_ptr(p));
copy_sub_list(ins_ptr(r),ins_ptr(p));
break;
case margin_kern_node:
copy_sub_node(margin_char(r),margin_char(p));
break;
case mark_node:
add_token_ref(mark_ptr(p));
break;
case adjust_node:
copy_sub_list(adjust_ptr(r),adjust_ptr(p));
break;
case choice_node:
copy_sub_list(display_mlist(r),display_mlist(p));
copy_sub_list(text_mlist(r),text_mlist(p));
copy_sub_list(script_mlist(r),script_mlist(p));
copy_sub_list(script_script_mlist(r),script_script_mlist(p));
break;
case simple_noad:
copy_sub_list(nucleus(r),nucleus(p));
copy_sub_list(subscr(r),subscr(p));
copy_sub_list(supscr(r),supscr(p));
break;
case radical_noad:
copy_sub_list(nucleus(r),nucleus(p));
copy_sub_list(subscr(r),subscr(p));
copy_sub_list(supscr(r),supscr(p));
copy_sub_node(left_delimiter(r),left_delimiter(p));
copy_sub_list(degree(r),degree(p));
break;
case accent_noad:
copy_sub_list(nucleus(r),nucleus(p));
copy_sub_list(subscr(r),subscr(p));
copy_sub_list(supscr(r),supscr(p));
copy_sub_list(top_accent_chr(r),top_accent_chr(p));
copy_sub_list(bot_accent_chr(r),bot_accent_chr(p));
copy_sub_list(overlay_accent_chr(r),overlay_accent_chr(p));
break;
case fence_noad:
copy_sub_node(delimiter(r),delimiter(p));
break;
case sub_box_node:
case sub_mlist_node:
copy_sub_list(math_list(r),math_list(p));
break;
case fraction_noad:
copy_sub_list(numerator(r),numerator(p));
copy_sub_list(denominator(r),denominator(p));
copy_sub_node(left_delimiter(r),left_delimiter(p));
copy_sub_node(right_delimiter(r),right_delimiter(p));
break;
case glue_spec_node:
glue_ref_count(r)= null;
break;
case dir_node:
case local_par_node:
case boundary_node:
break;
case whatsit_node:
w= subtype(p);
if(w>=backend_first_pdf_whatsit){
copy_node_wrapup_pdf(p,r);
}else if(w>=backend_first_dvi_whatsit){
copy_node_wrapup_dvi(p,r);
}else{
copy_node_wrapup_core(p,r);
}
break;
}
return r;
}



#define free_sub_list(source) if (source != null) flush_node_list(source);
#define free_sub_node(source) if (source != null) flush_node(source);

/*:10*//*11:*/
#line 1201 "./luatexdir/tex/texnodes.w"


static void flush_node_wrapup_core(halfword p)
{
switch(subtype(p)){
case open_node:
case write_node:
case close_node:
case save_pos_node:
break;
case special_node:
delete_token_ref(write_tokens(p));
break;
case late_lua_node:
free_late_lua(p);
break;
case user_defined_node:
switch(user_node_type(p)){
case'a':
delete_attribute_ref(user_node_value(p));
break;
case'd':
break;
case'n':
flush_node_list(user_node_value(p));
break;
case's':

break;
case't':
delete_token_ref(user_node_value(p));
break;
default:
{
const char*hlp[]= {
"The type of the value in a user defined whatsit node should be one",
"of 'a' (attribute list), 'd' (number), 'n' (node list), 's' (string),",
"or 't' (tokenlist). Yours has an unknown type, and therefore I don't",
"know how to free the node's value. A memory leak may result.",
NULL
};
tex_error("Unidentified user defined whatsit",hlp);
}
break;
}
break;
}
}

void flush_node_wrapup_dvi(halfword p)
{
}

void flush_node_wrapup_pdf(halfword p)
{
switch(subtype(p)){
case pdf_save_node:
case pdf_restore_node:
case pdf_refobj_node:
case pdf_end_link_node:
case pdf_end_thread_node:
break;
case pdf_literal_node:
free_pdf_literal(p);
break;
case pdf_colorstack_node:
if(pdf_colorstack_cmd(p)<=colorstack_data)
delete_token_ref(pdf_colorstack_data(p));
break;
case pdf_setmatrix_node:
delete_token_ref(pdf_setmatrix_data(p));
break;
case pdf_annot_node:
delete_token_ref(pdf_annot_data(p));
break;
case pdf_link_data_node:
break;
case pdf_start_link_node:
if(pdf_link_attr(p)!=null)
delete_token_ref(pdf_link_attr(p));
delete_action_ref(pdf_link_action(p));
break;
case pdf_dest_node:
if(pdf_dest_named_id(p)> 0)
delete_token_ref(pdf_dest_id(p));
break;
case pdf_action_node:
if(pdf_action_type(p)==pdf_action_user){
delete_token_ref(pdf_action_tokens(p));
}else{
if(pdf_action_file(p)!=null)
delete_token_ref(pdf_action_file(p));
if(pdf_action_type(p)==pdf_action_page)
delete_token_ref(pdf_action_tokens(p));
else if(pdf_action_named_id(p)> 0)
delete_token_ref(pdf_action_id(p));
}
break;
case pdf_thread_data_node:
break;
case pdf_thread_node:
case pdf_start_thread_node:
if(pdf_thread_named_id(p)> 0)
delete_token_ref(pdf_thread_id(p));
if(pdf_thread_attr(p)!=null)
delete_token_ref(pdf_thread_attr(p));
break;
}
}

void flush_node(halfword p)
{
halfword w;
if(p==null)
return;
if(free_error(p))
return;
switch(type(p)){
case glyph_node:
free_sub_list(lig_ptr(p));
break;
case glue_node:
delete_glue_ref(glue_ptr(p));
free_sub_list(leader_ptr(p));
break;
case hlist_node:
case vlist_node:
case unset_node:
free_sub_list(list_ptr(p));
break;
case disc_node:

free_sub_list(vlink(pre_break(p)));
free_sub_list(vlink(post_break(p)));
free_sub_list(vlink(no_break(p)));
break;
case rule_node:
case kern_node:
case penalty_node:
break;
case math_node:

if(glue_ptr(p)!=zero_glue){
delete_glue_ref(glue_ptr(p));
}

break;
case glue_spec_node:

if(valid_node(p)){
if(glue_ref_count(p)!=null){
decr(glue_ref_count(p));
}else{
free_node(p,get_node_size(type(p),subtype(p)));
}
}
return;
break;
case dir_node:
case local_par_node:
case boundary_node:
break;
case whatsit_node:
w= subtype(p);
if(w>=backend_first_pdf_whatsit){
flush_node_wrapup_pdf(p);
}else if(w>=backend_first_dvi_whatsit){
flush_node_wrapup_dvi(p);
}else{
flush_node_wrapup_core(p);
}
break;
case ins_node:
flush_node_list(ins_ptr(p));
delete_glue_ref(split_top_ptr(p));
break;
case margin_kern_node:
flush_node(margin_char(p));
break;
case mark_node:
delete_token_ref(mark_ptr(p));
break;
case adjust_node:
flush_node_list(adjust_ptr(p));
break;
case style_node:
break;
case choice_node:
free_sub_list(display_mlist(p));
free_sub_list(text_mlist(p));
free_sub_list(script_mlist(p));
free_sub_list(script_script_mlist(p));
break;
case simple_noad:
free_sub_list(nucleus(p));
free_sub_list(subscr(p));
free_sub_list(supscr(p));
break;
case radical_noad:
free_sub_list(nucleus(p));
free_sub_list(subscr(p));
free_sub_list(supscr(p));
free_sub_node(left_delimiter(p));
free_sub_list(degree(p));
break;
case accent_noad:
free_sub_list(nucleus(p));
free_sub_list(subscr(p));
free_sub_list(supscr(p));
free_sub_list(top_accent_chr(p));
free_sub_list(bot_accent_chr(p));
free_sub_list(overlay_accent_chr(p));
break;
case fence_noad:
free_sub_list(delimiter(p));
break;
case delim_node:
case math_char_node:
case math_text_char_node:
break;
case sub_box_node:
case sub_mlist_node:
free_sub_list(math_list(p));
break;
case fraction_noad:
free_sub_list(numerator(p));
free_sub_list(denominator(p));
free_sub_node(left_delimiter(p));
free_sub_node(right_delimiter(p));
break;
case pseudo_file_node:
free_sub_list(pseudo_lines(p));
break;
case pseudo_line_node:
case shape_node:
free_node(p,subtype(p));
return;
break;
case align_stack_node:
case span_node:
case movement_node:
case if_node:
case nesting_node:
case unhyphenated_node:
case hyphenated_node:
case delta_node:
case passive_node:
case inserting_node:
case split_up_node:
case expr_node:
case attribute_node:
case attribute_list_node:
case temp_node:
break;
default:
formatted_error("nodes","flushing weird node type %d",type(p));
return;
}
if(nodetype_has_attributes(type(p))){
delete_attribute_ref(node_attr(p));
lua_properties_reset(p);
}
free_node(p,get_node_size(type(p),subtype(p)));
return;
}

/*:11*//*12:*/
#line 1467 "./luatexdir/tex/texnodes.w"

void flush_node_list(halfword pp)
{
register halfword p= pp;
if(p==null)
return;
if(free_error(p))
return;
lua_properties_push;
while(p!=null){
register halfword q= vlink(p);
flush_node(p);
p= q;
}
lua_properties_pop;
}

/*:12*//*13:*/
#line 1484 "./luatexdir/tex/texnodes.w"

static void check_node_wrapup_core(halfword p)
{
switch(subtype(p)){

case special_node:
check_token_ref(write_tokens(p));
break;
case user_defined_node:
switch(user_node_type(p)){
case'a':
check_attribute_ref(user_node_value(p));
break;
case't':
check_token_ref(user_node_value(p));
break;
case'n':
dorangetest(p,user_node_value(p),var_mem_max);
break;
case's':
case'd':
break;
default:
confusion("unknown user node type");
break;
}
break;
case open_node:
case write_node:
case close_node:
case save_pos_node:
break;
}
}

void check_node_wrapup_dvi(halfword p)
{
}

void check_node_wrapup_pdf(halfword p)
{
switch(subtype(p)){
case pdf_literal_node:
if(pdf_literal_type(p)==normal)
check_token_ref(pdf_literal_data(p));
break;
case pdf_colorstack_node:
if(pdf_colorstack_cmd(p)<=colorstack_data)
check_token_ref(pdf_colorstack_data(p));
break;
case pdf_setmatrix_node:
check_token_ref(pdf_setmatrix_data(p));
break;
case late_lua_node:
if(late_lua_name(p)> 0)
check_token_ref(late_lua_name(p));
if(late_lua_type(p)==normal)
check_token_ref(late_lua_data(p));
break;
case pdf_annot_node:
check_token_ref(pdf_annot_data(p));
break;
case pdf_start_link_node:
if(pdf_link_attr(p)!=null)
check_token_ref(pdf_link_attr(p));
check_action_ref(pdf_link_action(p));
break;
case pdf_dest_node:
if(pdf_dest_named_id(p)> 0)
check_token_ref(pdf_dest_id(p));
break;
case pdf_thread_node:
case pdf_start_thread_node:
if(pdf_thread_named_id(p)> 0)
check_token_ref(pdf_thread_id(p));
if(pdf_thread_attr(p)!=null)
check_token_ref(pdf_thread_attr(p));
break;
case pdf_save_node:
case pdf_restore_node:
case pdf_refobj_node:
case pdf_end_link_node:
case pdf_end_thread_node:
break;
default:
confusion("wrapup pdf nodes");
break;
}
}

void check_node(halfword p)
{
halfword w;
switch(type(p)){
case glyph_node:
dorangetest(p,lig_ptr(p),var_mem_max);
break;
case glue_node:
check_glue_ref(glue_ptr(p));
dorangetest(p,leader_ptr(p),var_mem_max);
break;
case hlist_node:
case vlist_node:
case unset_node:
case align_record_node:
dorangetest(p,list_ptr(p),var_mem_max);
break;
case ins_node:
dorangetest(p,ins_ptr(p),var_mem_max);
check_glue_ref(split_top_ptr(p));
break;
case whatsit_node:
w= subtype(p);
if(w>=backend_first_pdf_whatsit){
check_node_wrapup_pdf(p);
}else if(w>=backend_first_dvi_whatsit){
check_node_wrapup_dvi(p);
}else{
check_node_wrapup_core(p);
}
break;
case margin_kern_node:
check_node(margin_char(p));
break;
case math_node:

if(glue_ptr(p)!=zero_glue){
check_glue_ref(glue_ptr(p));
}

break;
case disc_node:
dorangetest(p,vlink(pre_break(p)),var_mem_max);
dorangetest(p,vlink(post_break(p)),var_mem_max);
dorangetest(p,vlink(no_break(p)),var_mem_max);
break;
case adjust_node:
dorangetest(p,adjust_ptr(p),var_mem_max);
break;
case pseudo_file_node:
dorangetest(p,pseudo_lines(p),var_mem_max);
break;
case pseudo_line_node:
case shape_node:
break;
case choice_node:
dorangetest(p,display_mlist(p),var_mem_max);
dorangetest(p,text_mlist(p),var_mem_max);
dorangetest(p,script_mlist(p),var_mem_max);
dorangetest(p,script_script_mlist(p),var_mem_max);
break;
case fraction_noad:
dorangetest(p,numerator(p),var_mem_max);
dorangetest(p,denominator(p),var_mem_max);
dorangetest(p,left_delimiter(p),var_mem_max);
dorangetest(p,right_delimiter(p),var_mem_max);
break;
case simple_noad:
dorangetest(p,nucleus(p),var_mem_max);
dorangetest(p,subscr(p),var_mem_max);
dorangetest(p,supscr(p),var_mem_max);
break;
case radical_noad:
dorangetest(p,nucleus(p),var_mem_max);
dorangetest(p,subscr(p),var_mem_max);
dorangetest(p,supscr(p),var_mem_max);
dorangetest(p,degree(p),var_mem_max);
dorangetest(p,left_delimiter(p),var_mem_max);
break;
case accent_noad:
dorangetest(p,nucleus(p),var_mem_max);
dorangetest(p,subscr(p),var_mem_max);
dorangetest(p,supscr(p),var_mem_max);
dorangetest(p,top_accent_chr(p),var_mem_max);
dorangetest(p,bot_accent_chr(p),var_mem_max);
dorangetest(p,overlay_accent_chr(p),var_mem_max);
break;
case fence_noad:
dorangetest(p,delimiter(p),var_mem_max);
break;



























}
}

/*:13*//*14:*/
#line 1694 "./luatexdir/tex/texnodes.w"

void fix_node_list(halfword head)
{
halfword p,q;
if(head==null)
return;
p= head;
q= vlink(p);
while(q!=null){
alink(q)= p;
p= q;
q= vlink(p);
}
}

/*:14*//*15:*/
#line 1709 "./luatexdir/tex/texnodes.w"

halfword get_node(int s)
{
register halfword r;

if(s<MAX_CHAIN_SIZE){
r= free_chain[s];
if(r!=null){
free_chain[s]= vlink(r);
#ifdef CHECK_NODE_USAGE
varmem_sizes[r]= (char)s;
#endif
vlink(r)= null;
var_used+= s;
return r;
}

return slow_get_node(s);
}else{
normal_error("nodes","there is a problem in getting a node, case 1");
return null;
}
}

/*:15*//*16:*/
#line 1733 "./luatexdir/tex/texnodes.w"

void free_node(halfword p,int s)
{
if(p<=my_prealloc){
formatted_error("nodes","node number %d of type %d should not be freed",(int)p,type(p));
return;
}
#ifdef CHECK_NODE_USAGE
varmem_sizes[p]= 0;
#endif
if(s<MAX_CHAIN_SIZE){
vlink(p)= free_chain[s];
free_chain[s]= p;
}else{

node_size(p)= s;
vlink(p)= rover;
while(vlink(rover)!=vlink(p)){
rover= vlink(rover);
}
vlink(rover)= p;
}

var_used-= s;
}

/*:16*//*17:*/
#line 1759 "./luatexdir/tex/texnodes.w"

static void free_node_chain(halfword q,int s)
{
register halfword p= q;
while(vlink(p)!=null){
#ifdef CHECK_NODE_USAGE
varmem_sizes[p]= 0;
#endif
var_used-= s;
p= vlink(p);
}
var_used-= s;
#ifdef CHECK_NODE_USAGE
varmem_sizes[p]= 0;
#endif
vlink(p)= free_chain[s];
free_chain[s]= q;
}

/*:17*//*18:*/
#line 1778 "./luatexdir/tex/texnodes.w"

void init_node_mem(int t)
{
my_prealloc= var_mem_stat_max;







varmem= (memory_word*)realloc((void*)varmem,sizeof(memory_word)*(unsigned)t);
if(varmem==NULL){
overflow("node memory size",(unsigned)var_mem_max);
}
memset((void*)(varmem),0,(unsigned)t*sizeof(memory_word));
#ifdef CHECK_NODE_USAGE
varmem_sizes= (char*)realloc(varmem_sizes,sizeof(char)*(unsigned)t);
if(varmem_sizes==NULL){
overflow("node memory size",(unsigned)var_mem_max);
}
memset((void*)varmem_sizes,0,sizeof(char)*(unsigned)t);
#endif
var_mem_max= t;
rover= var_mem_stat_max+1;
vlink(rover)= rover;
node_size(rover)= (t-rover);
var_used= 0;

glue_ref_count(zero_glue)= null+1;
width(zero_glue)= 0;
type(zero_glue)= glue_spec_node;
vlink(zero_glue)= null;
stretch(zero_glue)= 0;
stretch_order(zero_glue)= normal;
shrink(zero_glue)= 0;
shrink_order(zero_glue)= normal;
glue_ref_count(sfi_glue)= null+1;
width(sfi_glue)= 0;
type(sfi_glue)= glue_spec_node;
vlink(sfi_glue)= null;
stretch(sfi_glue)= 0;
stretch_order(sfi_glue)= sfi;
shrink(sfi_glue)= 0;
shrink_order(sfi_glue)= normal;
glue_ref_count(fil_glue)= null+1;
width(fil_glue)= 0;
type(fil_glue)= glue_spec_node;
vlink(fil_glue)= null;
stretch(fil_glue)= unity;
stretch_order(fil_glue)= fil;
shrink(fil_glue)= 0;
shrink_order(fil_glue)= normal;
glue_ref_count(fill_glue)= null+1;
width(fill_glue)= 0;
type(fill_glue)= glue_spec_node;
vlink(fill_glue)= null;
stretch(fill_glue)= unity;
stretch_order(fill_glue)= fill;
shrink(fill_glue)= 0;
shrink_order(fill_glue)= normal;
glue_ref_count(ss_glue)= null+1;
width(ss_glue)= 0;
type(ss_glue)= glue_spec_node;
vlink(ss_glue)= null;
stretch(ss_glue)= unity;
stretch_order(ss_glue)= fil;
shrink(ss_glue)= unity;
shrink_order(ss_glue)= fil;
glue_ref_count(fil_neg_glue)= null+1;
width(fil_neg_glue)= 0;
type(fil_neg_glue)= glue_spec_node;
vlink(fil_neg_glue)= null;
stretch(fil_neg_glue)= -unity;
stretch_order(fil_neg_glue)= fil;
shrink(fil_neg_glue)= 0;
shrink_order(fil_neg_glue)= normal;

vinfo(page_ins_head)= 0;
type(page_ins_head)= temp_node;
vlink(page_ins_head)= null;
alink(page_ins_head)= null;
vinfo(contrib_head)= 0;
type(contrib_head)= temp_node;
vlink(contrib_head)= null;
alink(contrib_head)= null;
vinfo(page_head)= 0;
type(page_head)= temp_node;
vlink(page_head)= null;
alink(page_head)= null;
vinfo(temp_head)= 0;
type(temp_head)= temp_node;
vlink(temp_head)= null;
alink(temp_head)= null;
vinfo(hold_head)= 0;
type(hold_head)= temp_node;
vlink(hold_head)= null;
alink(hold_head)= null;
vinfo(adjust_head)= 0;
type(adjust_head)= temp_node;
vlink(adjust_head)= null;
alink(adjust_head)= null;
vinfo(pre_adjust_head)= 0;
type(pre_adjust_head)= temp_node;
vlink(pre_adjust_head)= null;
alink(pre_adjust_head)= null;
vinfo(active)= 0;
type(active)= unhyphenated_node;
vlink(active)= null;
alink(active)= null;
vinfo(align_head)= 0;
type(align_head)= temp_node;
vlink(align_head)= null;
alink(align_head)= null;
vinfo(end_span)= 0;
type(end_span)= span_node;
vlink(end_span)= null;
alink(end_span)= null;
type(begin_point)= glyph_node;
subtype(begin_point)= 0;
vlink(begin_point)= null;
vinfo(begin_point+1)= null;
alink(begin_point)= null;
font(begin_point)= 0;
character(begin_point)= '.';
vinfo(begin_point+3)= 0;
vlink(begin_point+3)= 0;
vinfo(begin_point+4)= 0;
vlink(begin_point+4)= 0;
type(end_point)= glyph_node;
subtype(end_point)= 0;
vlink(end_point)= null;
vinfo(end_point+1)= null;
alink(end_point)= null;
font(end_point)= 0;
character(end_point)= '.';
vinfo(end_point+3)= 0;
vlink(end_point+3)= 0;
vinfo(end_point+4)= 0;
vlink(end_point+4)= 0;
}

/*:18*//*19:*/
#line 1920 "./luatexdir/tex/texnodes.w"

void dump_node_mem(void)
{
dump_int(var_mem_max);
dump_int(rover);
dump_things(varmem[0],var_mem_max);
#ifdef CHECK_NODE_USAGE
dump_things(varmem_sizes[0],var_mem_max);
#endif
dump_things(free_chain[0],MAX_CHAIN_SIZE);
dump_int(var_used);
dump_int(my_prealloc);
}

/*:19*//*20:*/
#line 1935 "./luatexdir/tex/texnodes.w"


void undump_node_mem(void)
{
int x;
undump_int(x);
undump_int(rover);
var_mem_max= (x<100000?100000:x);
varmem= xmallocarray(memory_word,(unsigned)var_mem_max);
undump_things(varmem[0],x);
#ifdef CHECK_NODE_USAGE
varmem_sizes= xmallocarray(char,(unsigned)var_mem_max);
memset((void*)varmem_sizes,0,(unsigned)var_mem_max*sizeof(char));
undump_things(varmem_sizes[0],x);
#endif
undump_things(free_chain[0],MAX_CHAIN_SIZE);
undump_int(var_used);
undump_int(my_prealloc);
if(var_mem_max> x){

vlink(x)= rover;
node_size(x)= (var_mem_max-x);
while(vlink(rover)!=vlink(x)){
rover= vlink(rover);
}
vlink(rover)= x;
}
}

/*:20*//*21:*/
#line 1964 "./luatexdir/tex/texnodes.w"

halfword slow_get_node(int s)
{
register int t;

RETRY:
t= node_size(rover);
if(vlink(rover)<var_mem_max&&vlink(rover)!=0){
if(t> s){

register halfword r= rover;
rover+= s;
vlink(rover)= vlink(r);
node_size(rover)= node_size(r)-s;
if(vlink(rover)!=r){
halfword q= r;
while(vlink(q)!=r){
q= vlink(q);
}
vlink(q)+= s;
}else{
vlink(rover)+= s;
}
if(vlink(rover)<var_mem_max){
#ifdef CHECK_NODE_USAGE
varmem_sizes[r]= (char)(s> 127?127:s);
#endif
vlink(r)= null;
var_used+= s;
return r;
}else{
normal_error("nodes","there is a problem in getting a node, case 2");
return null;
}
}else{

int x;
if(vlink(rover)!=rover){
if(t<MAX_CHAIN_SIZE){
halfword l= vlink(rover);
vlink(rover)= free_chain[t];
free_chain[t]= rover;
rover= l;
while(vlink(l)!=free_chain[t]){
l= vlink(l);
}
vlink(l)= rover;
goto RETRY;
}else{
halfword l= rover;
while(vlink(rover)!=l){
if(node_size(rover)> s){
goto RETRY;
}
rover= vlink(rover);
}
}
}

x= (var_mem_max>>2)+s;
varmem= (memory_word*)realloc((void*)varmem,sizeof(memory_word)*(unsigned)(var_mem_max+x));
if(varmem==NULL){
overflow("node memory size",(unsigned)var_mem_max);
}
memset((void*)(varmem+var_mem_max),0,(unsigned)x*sizeof(memory_word));
#ifdef CHECK_NODE_USAGE
varmem_sizes= (char*)realloc(varmem_sizes,sizeof(char)*(unsigned)(var_mem_max+x));
if(varmem_sizes==NULL){
overflow("node memory size",(unsigned)var_mem_max);
}
memset((void*)(varmem_sizes+var_mem_max),0,(unsigned)(x)*sizeof(char));
#endif

vlink(var_mem_max)= rover;
node_size(var_mem_max)= x;
while(vlink(rover)!=vlink(var_mem_max)){
rover= vlink(rover);
}
vlink(rover)= var_mem_max;
rover= var_mem_max;
var_mem_max+= x;
goto RETRY;
}
}else{
normal_error("nodes","there is a problem in getting a node, case 3");
return null;
}
}

/*:21*//*22:*/
#line 2053 "./luatexdir/tex/texnodes.w"

char*sprint_node_mem_usage(void)
{
char*s;
#ifdef CHECK_NODE_USAGE
char*ss;
int i;
int b= 0;
char msg[256];
int node_counts[last_normal_node+last_whatsit_node+2]= {0};
s= strdup("");
for(i= (var_mem_max-1);i> my_prealloc;i--){
if(varmem_sizes[i]> 0){
if(type(i)> last_normal_node+last_whatsit_node){
node_counts[last_normal_node+last_whatsit_node+1]++;
}else if(type(i)==whatsit_node){
node_counts[(subtype(i)+last_normal_node+1)]++;
}else{
node_counts[type(i)]++;
}
}
}
for(i= 0;i<last_normal_node+last_whatsit_node+2;i++){
if(node_counts[i]> 0){
int j= 
(i> (last_normal_node+1)?(i-last_normal_node-1):0);
snprintf(msg,255,"%s%d %s",(b?", ":""),(int)node_counts[i],
get_node_name((i> last_normal_node?whatsit_node:i),j));
ss= xmalloc((unsigned)(strlen(s)+strlen(msg)+1));
strcpy(ss,s);
strcat(ss,msg);
free(s);
s= ss;
b= 1;
}
}
#else
s= strdup("");
#endif
return s;
}

/*:22*//*23:*/
#line 2095 "./luatexdir/tex/texnodes.w"

halfword list_node_mem_usage(void)
{
halfword q= null;
#ifdef CHECK_NODE_USAGE
halfword p= null;
halfword i,j;
char*saved_varmem_sizes= xmallocarray(char,(unsigned)var_mem_max);
memcpy(saved_varmem_sizes,varmem_sizes,(size_t)var_mem_max);
for(i= my_prealloc+1;i<(var_mem_max-1);i++){
if(saved_varmem_sizes[i]> 0){
j= copy_node(i);
if(p==null){
q= j;
}else{
vlink(p)= j;
}
p= j;
}
}
free(saved_varmem_sizes);
#endif
return q;
}

/*:23*//*24:*/
#line 2120 "./luatexdir/tex/texnodes.w"

void print_node_mem_stats(void)
{
int i,b;
halfword j;
char msg[256];
char*s;
int free_chain_counts[MAX_CHAIN_SIZE]= {0};
snprintf(msg,255," %d words of node memory still in use:",(int)(var_used+my_prealloc));
tprint_nl(msg);
s= sprint_node_mem_usage();
tprint_nl("   ");
tprint(s);
free(s);
tprint(" nodes");
tprint_nl("   avail lists: ");
b= 0;
for(i= 1;i<MAX_CHAIN_SIZE;i++){
for(j= free_chain[i];j!=null;j= vlink(j))
free_chain_counts[i]++;
if(free_chain_counts[i]> 0){
snprintf(msg,255,"%s%d:%d",(b?",":""),i,(int)free_chain_counts[i]);
tprint(msg);
b= 1;
}
}

print_nlp();
}



halfword new_span_node(halfword n,int s,scaled w)
{
halfword p= new_node(span_node,0);
span_link(p)= n;
span_span(p)= s;
width(p)= w;
return p;
}

/*:24*//*25:*/
#line 2163 "./luatexdir/tex/texnodes.w"

static halfword new_attribute_node(unsigned int i,int v)
{
register halfword r= get_node(attribute_node_size);
type(r)= attribute_node;
attribute_id(r)= (halfword)i;
attribute_value(r)= v;

subtype(r)= 0;
return r;
}

/*:25*//*26:*/
#line 2175 "./luatexdir/tex/texnodes.w"

halfword copy_attribute_list(halfword n)
{
halfword q= get_node(attribute_node_size);
register halfword p= q;
type(p)= attribute_list_node;
attr_list_ref(p)= 0;
n= vlink(n);
while(n!=null){
register halfword r= get_node(attribute_node_size);

(void)memcpy((void*)(varmem+r),(void*)(varmem+n),
(sizeof(memory_word)*attribute_node_size));
vlink(p)= r;
p= r;
n= vlink(n);
}
return q;
}

/*:26*//*27:*/
#line 2195 "./luatexdir/tex/texnodes.w"

void update_attribute_cache(void)
{
halfword p;
register int i;
attr_list_cache= get_node(attribute_node_size);
type(attr_list_cache)= attribute_list_node;
attr_list_ref(attr_list_cache)= 0;
p= attr_list_cache;
for(i= 0;i<=max_used_attr;i++){
register int v= attribute(i);
if(v> UNUSED_ATTRIBUTE){
register halfword r= new_attribute_node((unsigned)i,v);
vlink(p)= r;
p= r;
}
}
if(vlink(attr_list_cache)==null){
free_node(attr_list_cache,attribute_node_size);
attr_list_cache= null;
}
return;
}

/*:27*//*28:*/
#line 2219 "./luatexdir/tex/texnodes.w"

void build_attribute_list(halfword b)
{
if(max_used_attr>=0){
if(attr_list_cache==cache_disabled||attr_list_cache==null){
update_attribute_cache();
if(attr_list_cache==null)
return;
}
attr_list_ref(attr_list_cache)++;
node_attr(b)= attr_list_cache;
}
}

/*:28*//*29:*/
#line 2233 "./luatexdir/tex/texnodes.w"

halfword current_attribute_list(void)
{
if(max_used_attr>=0){
if(attr_list_cache==cache_disabled){
update_attribute_cache();
}
return attr_list_cache;
}
return null;
}


/*:29*//*30:*/
#line 2246 "./luatexdir/tex/texnodes.w"

void reassign_attribute(halfword n,halfword new)
{
halfword old;
old= node_attr(n);
if(new==null){

if(old!=null)
delete_attribute_ref(old);
}else if(old==null){

assign_attribute_ref(n,new);
}else if(old!=new){

delete_attribute_ref(old);
assign_attribute_ref(n,new);
}

node_attr(n)= new;
}

/*:30*//*31:*/
#line 2267 "./luatexdir/tex/texnodes.w"

void delete_attribute_ref(halfword b)
{
if(b!=null){
if(type(b)==attribute_list_node){
attr_list_ref(b)--;
if(attr_list_ref(b)==0){
if(b==attr_list_cache)
attr_list_cache= cache_disabled;
free_node_chain(b,attribute_node_size);
}

if(attr_list_ref(b)<0){
attr_list_ref(b)= 0;
}
}else{
normal_error("nodes","trying to delete an attribute reference of a non attribute node");
}
}
}

void reset_node_properties(halfword b)
{
if(b!=null){
lua_properties_reset(b);
}
}

/*:31*//*32:*/
#line 2296 "./luatexdir/tex/texnodes.w"

halfword do_set_attribute(halfword p,int i,int val)
{
register halfword q;
register int j= 0;
if(p==null){
q= get_node(attribute_node_size);
type(q)= attribute_list_node;
attr_list_ref(q)= 1;
p= new_attribute_node((unsigned)i,val);
vlink(q)= p;
return q;
}
q= p;
if(vlink(p)!=null){
while(vlink(p)!=null){
int t= attribute_id(vlink(p));
if(t==i&&attribute_value(vlink(p))==val)
return q;
if(t>=i)
break;
j++;
p= vlink(p);
}

p= q;
while(j--> 0)
p= vlink(p);
if(attribute_id(vlink(p))==i){
attribute_value(vlink(p))= val;
}else{
halfword r= new_attribute_node((unsigned)i,val);
vlink(r)= vlink(p);
vlink(p)= r;
}
return q;
}else{
normal_error("nodes","trying to set an attribute fails, case 1");
return null;
}
}

/*:32*//*33:*/
#line 2338 "./luatexdir/tex/texnodes.w"

void set_attribute(halfword n,int i,int val)
{
register halfword p;
register int j= 0;

if(!nodetype_has_attributes(type(n)))
return;

p= node_attr(n);
if(p==null){
p= get_node(attribute_node_size);
type(p)= attribute_list_node;
attr_list_ref(p)= 1;
node_attr(n)= p;
p= new_attribute_node((unsigned)i,val);
vlink(node_attr(n))= p;
return;
}

if(vlink(p)!=null){
while(vlink(p)!=null){
int t= attribute_id(vlink(p));
if(t==i&&attribute_value(vlink(p))==val)
return;
if(t>=i)
break;
j++;
p= vlink(p);
}

p= node_attr(n);

if(attr_list_ref(p)==0){

formatted_warning("nodes","node %d has an attribute list that is free already, case 1",(int)n);

attr_list_ref(p)= 1;
}else if(attr_list_ref(p)==1){

if(p==attr_list_cache){



p= copy_attribute_list(p);
node_attr(n)= p;

attr_list_ref(p)= 1;
}
}else{

p= copy_attribute_list(p);

delete_attribute_ref(node_attr(n));
node_attr(n)= p;

attr_list_ref(p)= 1;
}



while(j--> 0)
p= vlink(p);

if(attribute_id(vlink(p))==i){
attribute_value(vlink(p))= val;
}else{
halfword r= new_attribute_node((unsigned)i,val);
vlink(r)= vlink(p);
vlink(p)= r;
}
}else{
normal_error("nodes","trying to set an attribute fails, case 2");
}
}

/*:33*//*34:*/
#line 2414 "./luatexdir/tex/texnodes.w"

int unset_attribute(halfword n,int i,int val)
{
register halfword p;
register int t;
register int j= 0;

if(!nodetype_has_attributes(type(n)))
return null;
p= node_attr(n);
if(p==null)
return UNUSED_ATTRIBUTE;
if(attr_list_ref(p)==0){
formatted_warning("nodes","node %d has an attribute list that is free already, case 2",(int)n);
return UNUSED_ATTRIBUTE;
}
if(vlink(p)!=null){
while(vlink(p)!=null){
t= attribute_id(vlink(p));
if(t> i)
return UNUSED_ATTRIBUTE;
if(t==i){
p= vlink(p);
break;
}
j++;
p= vlink(p);
}
if(attribute_id(p)!=i)
return UNUSED_ATTRIBUTE;

p= node_attr(n);
if(attr_list_ref(p)> 1||p==attr_list_cache){
halfword q= copy_attribute_list(p);
if(attr_list_ref(p)> 1){
delete_attribute_ref(node_attr(n));
}
attr_list_ref(q)= 1;
node_attr(n)= q;
}
p= vlink(node_attr(n));
while(j--> 0)
p= vlink(p);
t= attribute_value(p);
if(val==UNUSED_ATTRIBUTE||t==val){
attribute_value(p)= UNUSED_ATTRIBUTE;
}
return t;
}else{
normal_error("nodes","trying to unset an attribute fails");
return null;
}
}

/*:34*//*35:*/
#line 2468 "./luatexdir/tex/texnodes.w"

int has_attribute(halfword n,int i,int val)
{
register halfword p;
if(!nodetype_has_attributes(type(n)))
return UNUSED_ATTRIBUTE;
p= node_attr(n);
if(p==null||vlink(p)==null)
return UNUSED_ATTRIBUTE;
p= vlink(p);
while(p!=null){
if(attribute_id(p)==i){
int ret= attribute_value(p);
if(val==UNUSED_ATTRIBUTE||val==ret)
return ret;
return UNUSED_ATTRIBUTE;
}else if(attribute_id(p)> i){
return UNUSED_ATTRIBUTE;
}
p= vlink(p);
}
return UNUSED_ATTRIBUTE;
}

/*:35*//*36:*/
#line 2492 "./luatexdir/tex/texnodes.w"

void print_short_node_contents(halfword p)
{
switch(type(p)){
case hlist_node:
case vlist_node:
case ins_node:
case whatsit_node:
case mark_node:
case adjust_node:
case unset_node:
print_char('[');
print_char(']');
break;
case rule_node:
print_char('|');
break;
case glue_node:
if(glue_ptr(p)!=zero_glue)
print_char(' ');
break;
case math_node:
print_char('$');
break;
case disc_node:
short_display(vlink(pre_break(p)));
short_display(vlink(post_break(p)));
break;
}
}

/*:36*//*37:*/
#line 2523 "./luatexdir/tex/texnodes.w"

static void show_pdftex_whatsit_rule_spec(int p)
{
tprint("(");
print_rule_dimen(height(p));
print_char('+');
print_rule_dimen(depth(p));
tprint(")x");
print_rule_dimen(width(p));
}

/*:37*//*38:*/
#line 2539 "./luatexdir/tex/texnodes.w"

static void print_write_whatsit(const char*s,pointer p)
{
tprint_esc(s);
if(write_stream(p)<16)
print_int(write_stream(p));
else if(write_stream(p)==16)
print_char('*');
else
print_char('-');
}

/*:38*//*39:*/
#line 2551 "./luatexdir/tex/texnodes.w"

static void show_node_wrapup_core(int p)
{
switch(subtype(p)){
case open_node:
print_write_whatsit("openout",p);
print_char('=');
print_file_name(open_name(p),open_area(p),open_ext(p));
break;
case write_node:
print_write_whatsit("write",p);
print_mark(write_tokens(p));
break;
case close_node:
print_write_whatsit("closeout",p);
break;
case special_node:
tprint_esc("special");
print_mark(write_tokens(p));
break;
case late_lua_node:
show_late_lua(p);
break;
case save_pos_node:
tprint_esc("savepos");
break;
case user_defined_node:
tprint_esc("whatsit");
print_int(user_node_id(p));
print_char('=');
switch(user_node_type(p)){
case'a':
tprint("<>");
break;
case'n':
tprint("[");
show_node_list(user_node_value(p));
tprint("]");
break;
case's':
print_char('"');
print(user_node_value(p));
print_char('"');
break;
case't':
print_mark(user_node_value(p));
break;
default:
print_int(user_node_value(p));
break;
}
break;
}
}

void show_node_wrapup_dvi(int p)
{
}

void show_node_wrapup_pdf(int p)
{
switch(subtype(p)){
case pdf_literal_node:
show_pdf_literal(p);
break;
case pdf_colorstack_node:
tprint_esc("pdfcolorstack ");
print_int(pdf_colorstack_stack(p));
switch(pdf_colorstack_cmd(p)){
case colorstack_set:
tprint(" set ");
break;
case colorstack_push:
tprint(" push ");
break;
case colorstack_pop:
tprint(" pop");
break;
case colorstack_current:
tprint(" current");
break;
default:
confusion("colorstack");
break;
}
if(pdf_colorstack_cmd(p)<=colorstack_data)
print_mark(pdf_colorstack_data(p));
break;
case pdf_setmatrix_node:
tprint_esc("pdfsetmatrix");
print_mark(pdf_setmatrix_data(p));
break;
case pdf_save_node:
tprint_esc("pdfsave");
break;
case pdf_restore_node:
tprint_esc("pdfrestore");
break;
case pdf_refobj_node:
tprint_esc("pdfrefobj");
if(obj_obj_is_stream(static_pdf,pdf_obj_objnum(p))){
if(obj_obj_stream_attr(static_pdf,pdf_obj_objnum(p))!=LUA_NOREF){
tprint(" attr");
lua_rawgeti(Luas,LUA_REGISTRYINDEX,
obj_obj_stream_attr(static_pdf,pdf_obj_objnum(p)));
print_char(' ');
tprint((const char*)lua_tostring(Luas,-1));
lua_pop(Luas,1);
}
tprint(" stream");
}
if(obj_obj_is_file(static_pdf,pdf_obj_objnum(p)))
tprint(" file");
if(obj_obj_data(static_pdf,pdf_obj_objnum(p))!=LUA_NOREF){
lua_rawgeti(Luas,LUA_REGISTRYINDEX,
obj_obj_data(static_pdf,pdf_obj_objnum(p)));
print_char(' ');
tprint((const char*)lua_tostring(Luas,-1));
lua_pop(Luas,1);
}
break;
case pdf_annot_node:
tprint_esc("pdfannot");
show_pdftex_whatsit_rule_spec(p);
print_mark(pdf_annot_data(p));
break;
case pdf_start_link_node:
tprint_esc("pdfstartlink");
show_pdftex_whatsit_rule_spec(p);
if(pdf_link_attr(p)!=null){
tprint(" attr");
print_mark(pdf_link_attr(p));
}
tprint(" action");
if(pdf_action_type(pdf_link_action(p))==pdf_action_user){
tprint(" user");
print_mark(pdf_action_tokens(pdf_link_action(p)));
return;
}
if(pdf_action_file(pdf_link_action(p))!=null){
tprint(" file");
print_mark(pdf_action_file(pdf_link_action(p)));
}
switch(pdf_action_type(pdf_link_action(p))){
case pdf_action_goto:
if(pdf_action_named_id(pdf_link_action(p))> 0){
tprint(" goto name");
print_mark(pdf_action_id(pdf_link_action(p)));
}else{
tprint(" goto num");
print_int(pdf_action_id(pdf_link_action(p)));
}
break;
case pdf_action_page:
tprint(" page");
print_int(pdf_action_id(pdf_link_action(p)));
print_mark(pdf_action_tokens(pdf_link_action(p)));
break;
case pdf_action_thread:
if(pdf_action_named_id(pdf_link_action(p))> 0){
tprint(" thread name");
print_mark(pdf_action_id(pdf_link_action(p)));
}else{
tprint(" thread num");
print_int(pdf_action_id(pdf_link_action(p)));
}
break;
default:
normal_error("pdf backend","unknown action type for link");
break;
}
break;
case pdf_end_link_node:
tprint_esc("pdfendlink");
break;
case pdf_dest_node:
tprint_esc("pdfdest");
if(pdf_dest_named_id(p)> 0){
tprint(" name");
print_mark(pdf_dest_id(p));
}else{
tprint(" num");
print_int(pdf_dest_id(p));
}
print_char(' ');
switch(pdf_dest_type(p)){
case pdf_dest_xyz:
tprint("xyz");
if(pdf_dest_xyz_zoom(p)!=null){
tprint(" zoom");
print_int(pdf_dest_xyz_zoom(p));
}
break;
case pdf_dest_fitbh:
tprint("fitbh");
break;
case pdf_dest_fitbv:
tprint("fitbv");
break;
case pdf_dest_fitb:
tprint("fitb");
break;
case pdf_dest_fith:
tprint("fith");
break;
case pdf_dest_fitv:
tprint("fitv");
break;
case pdf_dest_fitr:
tprint("fitr");
show_pdftex_whatsit_rule_spec(p);
break;
case pdf_dest_fit:
tprint("fit");
break;
default:
tprint("unknown!");
break;
}
break;
case pdf_thread_node:
case pdf_start_thread_node:
if(subtype(p)==pdf_thread_node)
tprint_esc("pdfthread");
else
tprint_esc("pdfstartthread");
tprint("(");
print_rule_dimen(height(p));
print_char('+');
print_rule_dimen(depth(p));
tprint(")x");
print_rule_dimen(width(p));
if(pdf_thread_attr(p)!=null){
tprint(" attr");
print_mark(pdf_thread_attr(p));
}
if(pdf_thread_named_id(p)> 0){
tprint(" name");
print_mark(pdf_thread_id(p));
}else{
tprint(" num");
print_int(pdf_thread_id(p));
}
break;
case pdf_end_thread_node:
tprint_esc("pdfendthread");
break;
default:
break;
}
}

/*:39*//*42:*/
#line 2818 "./luatexdir/tex/texnodes.w"

#define node_list_display(A) do { \
    append_char('.');             \
    show_node_list(A);            \
    flush_char();                 \
} while (0)



void show_node_list(int p)
{
int n= 0;
halfword w;
real g;
if((int)cur_length> depth_threshold){
if(p> null)
tprint(" []");
return;
}
while(p!=null){
print_ln();
print_current_string();
if(int_par(tracing_online_code)<-2)
print_int(p);
incr(n);
if(n> breadth_max){
tprint("etc.");
return;
}

if(is_char_node(p)){
print_font_and_char(p);
if(is_ligature(p)){

tprint(" (ligature ");
if(is_leftboundary(p))
print_char('|');
font_in_short_display= font(p);
short_display(lig_ptr(p));
if(is_rightboundary(p))
print_char('|');
print_char(')');
}
}else{
switch(type(p)){
case hlist_node:
case vlist_node:
case unset_node:

if(type(p)==hlist_node)
tprint_esc("h");
else if(type(p)==vlist_node)
tprint_esc("v");
else
tprint_esc("unset");
tprint("box(");
print_scaled(height(p));
print_char('+');
print_scaled(depth(p));
tprint(")x");
print_scaled(width(p));
if(type(p)==unset_node){

if(span_count(p)!=min_quarterword){
tprint(" (");
print_int(span_count(p)+1);
tprint(" columns)");
}
if(glue_stretch(p)!=0){
tprint(", stretch ");
print_glue(glue_stretch(p),glue_order(p),NULL);
}
if(glue_shrink(p)!=0){
tprint(", shrink ");
print_glue(glue_shrink(p),glue_sign(p),NULL);
}
}else{










g= (real)(glue_set(p));
if((g!=0.0)&&(glue_sign(p)!=normal)){
tprint(", glue set ");
if(glue_sign(p)==shrinking)
tprint("- ");
if(g> 20000.0||g<-20000.0){
if(g> 0.0)
print_char('>');
else
tprint("< -");
print_glue(20000*unity,glue_order(p),NULL);
}else{
print_glue(round(unity*g),glue_order(p),NULL);
}
}

if(shift_amount(p)!=0){
tprint(", shifted ");
print_scaled(shift_amount(p));
}
tprint(", direction ");
print_dir(box_dir(p));
}
node_list_display(list_ptr(p));
break;
case rule_node:

if(subtype(p)==normal_rule){
tprint_esc("rule(");
}else if(subtype(p)==empty_rule){
tprint_esc("norule(");
}else if(subtype(p)==user_rule){
tprint_esc("userrule(");
}else if(subtype(p)==box_rule){
tprint_esc("box(");
}else if(subtype(p)==image_rule){
tprint_esc("image(");
}
print_rule_dimen(height(p));
print_char('+');
print_rule_dimen(depth(p));
tprint(")x");
print_rule_dimen(width(p));
break;
case ins_node:

tprint_esc("insert");
print_int(subtype(p));
tprint(", natural size ");
print_scaled(height(p));
tprint("; split(");
print_spec(split_top_ptr(p),NULL);
print_char(',');
print_scaled(depth(p));
tprint("); float cost ");
print_int(float_cost(p));
node_list_display(ins_ptr(p));
break;
case dir_node:
if(dir_dir(p)<0){
tprint_esc("enddir");
print_char(' ');
print_dir(dir_dir(p)+dir_swap);
}else{
tprint_esc("begindir");
print_char(' ');
print_dir(dir_dir(p));
}
break;
case local_par_node:
tprint_esc("localpar");
append_char('.');
print_ln();
print_current_string();
tprint_esc("localinterlinepenalty");
print_char('=');
print_int(local_pen_inter(p));
print_ln();
print_current_string();
tprint_esc("localbrokenpenalty");
print_char('=');
print_int(local_pen_broken(p));
print_ln();
print_current_string();
tprint_esc("localleftbox");
if(local_box_left(p)==null){
tprint("=null");
}else{
append_char('.');
show_node_list(local_box_left(p));
decr(cur_length);
}
print_ln();
print_current_string();
tprint_esc("localrightbox");
if(local_box_right(p)==null){
tprint("=null");
}else{
append_char('.');
show_node_list(local_box_right(p));
decr(cur_length);
}
decr(cur_length);
break;
case boundary_node:
if(subtype(p)==0){
tprint_esc("noboundary");
}else{
tprint_esc("boundary");
print_char('=');
print_int(subtype(p));
print_char(':');
print_int(boundary_value(p));
}
break;
case whatsit_node:
w= subtype(p);
if(w>=backend_first_pdf_whatsit){
show_node_wrapup_pdf(p);
}else if(w>=backend_first_dvi_whatsit){
show_node_wrapup_dvi(p);
}else{
show_node_wrapup_core(p);
}
break;
case glue_node:

if(subtype(p)>=a_leaders){

tprint_esc("");
switch(subtype(p)){
case a_leaders:
break;
case c_leaders:
print_char('c');
break;
case x_leaders:
print_char('x');
break;
case g_leaders:
print_char('g');
break;
default:
normal_warning("nodes","weird glue leader subtype ignored");
}
tprint("leaders ");
print_spec(glue_ptr(p),NULL);
node_list_display(leader_ptr(p));
}else{
tprint_esc("glue");
if(subtype(p)!=normal){
print_char('(');
if((subtype(p)-1)<thin_mu_skip_code){
print_cmd_chr(assign_glue_cmd,
glue_base+(subtype(p)-1));
}else if(subtype(p)<cond_math_glue){
print_cmd_chr(assign_mu_glue_cmd,
glue_base+(subtype(p)-1));
}else if(subtype(p)==cond_math_glue){
tprint_esc("nonscript");
}else{
tprint_esc("mskip");
}
print_char(')');
}
if(subtype(p)!=cond_math_glue){
print_char(' ');
if(subtype(p)<cond_math_glue)
print_spec(glue_ptr(p),NULL);
else
print_spec(glue_ptr(p),"mu");
}
}
break;
case margin_kern_node:
tprint_esc("kern");
print_scaled(width(p));
if(subtype(p)==left_side)
tprint(" (left margin)");
else
tprint(" (right margin)");
break;
case kern_node:


if(subtype(p)!=mu_glue){
tprint_esc("kern");
if(subtype(p)!=normal)
print_char(' ');
print_scaled(width(p));
if(subtype(p)==acc_kern)
tprint(" (for accent)");
}else{
tprint_esc("mkern");
print_scaled(width(p));
tprint("mu");
}
break;
case math_node:

tprint_esc("math");
if(subtype(p)==before)
tprint("on");
else
tprint("off");
if(width(p)!=0){
tprint(", surrounded ");
print_scaled(width(p));
}
break;
case penalty_node:

tprint_esc("penalty ");
print_int(penalty(p));
break;
case disc_node:



tprint_esc("discretionary");
print_int(disc_penalty(p));
print_char('|');
if(vlink(no_break(p))!=null){
tprint(" replacing ");
node_list_display(vlink(no_break(p)));
}
node_list_display(vlink(pre_break(p)));
append_char('|');
show_node_list(vlink(post_break(p)));
flush_char();
break;
case mark_node:

tprint_esc("mark");
if(mark_class(p)!=0){
print_char('s');
print_int(mark_class(p));
}
print_mark(mark_ptr(p));
break;
case adjust_node:

tprint_esc("vadjust");
if(subtype(p)!=0)
tprint(" pre ");
node_list_display(adjust_ptr(p));
break;
case glue_spec_node:
tprint("<glue_spec ");
print_spec(p,NULL);
tprint(">");
break;
default:
show_math_node(p);
break;
}
}
p= vlink(p);
}
}

/*:42*//*43:*/
#line 3169 "./luatexdir/tex/texnodes.w"

pointer actual_box_width(pointer r,scaled base_width)
{
pointer q;
scaled d;
scaled w= -max_dimen;
scaled v= shift_amount(r)+base_width;
pointer p= list_ptr(r);
while(p!=null){
if(is_char_node(p)){
d= glyph_width(p);
goto FOUND;
}
switch(type(p)){
case hlist_node:
case vlist_node:
case rule_node:
d= width(p);
goto FOUND;
break;
case margin_kern_node:
d= width(p);
break;
case kern_node:
d= width(p);
break;
case math_node:

if(glue_ptr(p)==zero_glue){
d= surround(p);
break;
}else{

}

case glue_node:






q= glue_ptr(p);
d= width(q);
if(glue_sign(r)==stretching){
if((glue_order(r)==stretch_order(q))
&&(stretch(q)!=0))
v= max_dimen;
}else if(glue_sign(r)==shrinking){
if((glue_order(r)==shrink_order(q))
&&(shrink(q)!=0))
v= max_dimen;
}
if(subtype(p)>=a_leaders)
goto FOUND;
break;
default:
d= 0;
break;
}
if(v<max_dimen)
v= v+d;
goto NOT_FOUND;
FOUND:
if(v<max_dimen){
v= v+d;
w= v;
}else{
w= max_dimen;
break;
}
NOT_FOUND:
p= vlink(p);
}
return w;
}

/*:43*//*44:*/
#line 3246 "./luatexdir/tex/texnodes.w"

halfword tail_of_list(halfword p)
{
halfword q= p;
while(vlink(q)!=null)
q= vlink(q);
return q;
}

/*:44*//*45:*/
#line 3258 "./luatexdir/tex/texnodes.w"

void delete_glue_ref(halfword p)
{
if(type(p)==glue_spec_node){
if(glue_ref_count(p)==null){
flush_node(p);
}else{
decr(glue_ref_count(p));
}
}else{
normal_error("nodes","invalid glue spec node");
}
}

/*:45*//*46:*/
#line 3272 "./luatexdir/tex/texnodes.w"

int var_used;
halfword temp_ptr;

/*:46*//*47:*/
#line 3283 "./luatexdir/tex/texnodes.w"

int max_used_attr;
halfword attr_list_cache;

/*:47*//*50:*/
#line 3323 "./luatexdir/tex/texnodes.w"

halfword new_null_box(void)
{
halfword p= new_node(hlist_node,min_quarterword);
box_dir(p)= text_direction;
return p;
}

/*:50*//*53:*/
#line 3345 "./luatexdir/tex/texnodes.w"

halfword new_rule(int s)
{
halfword p= new_node(rule_node,s);
return p;
}

/*:53*//*57:*/
#line 3394 "./luatexdir/tex/texnodes.w"

halfword new_glyph(int f,int c)
{
halfword p= null;
if((f==0)||(char_exists(f,c))){
p= new_glyph_node();
set_to_glyph(p);
font(p)= f;
character(p)= c;
}
return p;
}

/*:57*//*58:*/
#line 3426 "./luatexdir/tex/texnodes.w"

quarterword norm_min(int h)
{
if(h<=0)
return 1;
else if(h>=255)
return 255;
else
return(quarterword)h;
}

halfword new_char(int f,int c)
{
halfword p;
p= new_glyph_node();
set_to_character(p);
font(p)= f;
character(p)= c;
lang_data(p)= make_lang_data(uc_hyph,cur_lang,left_hyphen_min,right_hyphen_min);
return p;
}

/*:58*//*60:*/
#line 3454 "./luatexdir/tex/texnodes.w"

scaled glyph_width(halfword p)
{
scaled w= char_width(font(p),character(p));
return w;
}

scaled glyph_height(halfword p)
{
scaled w= char_height(font(p),character(p))+y_displace(p);
if(w<0)
w= 0;
return w;
}

scaled glyph_depth(halfword p)
{
scaled w= char_depth(font(p),character(p));
if(y_displace(p)> 0)
w= w-y_displace(p);
if(w<0)
w= 0;
return w;
}

/*:60*//*61:*/
#line 3498 "./luatexdir/tex/texnodes.w"

halfword new_disc(void)
{
halfword p= new_node(disc_node,0);
disc_penalty(p)= int_par(hyphen_penalty_code);
return p;
}

/*:61*//*63:*/
#line 3527 "./luatexdir/tex/texnodes.w"

halfword new_math(scaled w,int s)
{
halfword p= new_node(math_node,s);
surround(p)= w;
return p;
}

/*:63*//*68:*/
#line 3586 "./luatexdir/tex/texnodes.w"

halfword new_spec(halfword p)
{
halfword q= copy_node(p);
glue_ref_count(q)= null;
return q;
}

/*:68*//*69:*/
#line 3599 "./luatexdir/tex/texnodes.w"

halfword new_param_glue(int n)
{
halfword p= new_node(glue_node,n+1);
halfword q= glue_par(n);
glue_ptr(p)= q;
incr(glue_ref_count(q));
return p;
}

/*:69*//*70:*/
#line 3612 "./luatexdir/tex/texnodes.w"

halfword new_glue(halfword q)
{
halfword p= new_node(glue_node,normal);
glue_ptr(p)= q;
incr(glue_ref_count(q));
return p;
}

/*:70*//*71:*/
#line 3628 "./luatexdir/tex/texnodes.w"

halfword new_skip_param(int n)
{
halfword p;
temp_ptr= new_spec(glue_par(n));
p= new_glue(temp_ptr);
glue_ref_count(temp_ptr)= null;
subtype(p)= (quarterword)(n+1);
return p;
}

/*:71*//*73:*/
#line 3652 "./luatexdir/tex/texnodes.w"

halfword new_kern(scaled w)
{
halfword p= new_node(kern_node,normal);
width(p)= w;
return p;
}

/*:73*//*75:*/
#line 3670 "./luatexdir/tex/texnodes.w"

halfword new_penalty(int m)
{
halfword p= new_node(penalty_node,0);
penalty(p)= m;
return p;
}

/*:75*//*77:*/
#line 3709 "./luatexdir/tex/texnodes.w"


halfword make_local_par_node(void)
{
halfword q;
halfword p= new_node(local_par_node,0);
local_pen_inter(p)= local_inter_line_penalty;
local_pen_broken(p)= local_broken_penalty;
if(local_left_box!=null){
q= copy_node_list(local_left_box);
local_box_left(p)= q;
local_box_left_width(p)= width(local_left_box);
}
if(local_right_box!=null){
q= copy_node_list(local_right_box);
local_box_right(p)= q;
local_box_right_width(p)= width(local_right_box);
}
local_par_dir(p)= par_direction;
return p;
}/*:77*/