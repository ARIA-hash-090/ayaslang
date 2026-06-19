; ModuleID = "ayas"
target triple = "unknown-unknown-unknown"
target datalayout = ""

declare i32 @"printf"(i8* %".1", ...)

declare i32 @"fflush"(i8* %".1")

declare double @"llvm.sin.f64"(double %".1")

declare double @"llvm.cos.f64"(double %".1")

declare i8* @"malloc"(i64 %".1")

declare void @"free"(i8* %".1")

@"ayas_arena_buf" = internal global i8* null
@"ayas_arena_offset" = internal global i64 0
declare void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1", i8* %".2", i64 %".3", i1 %".4")

define i32 @"main"()
{
entry:
  %".2" = call i8* @"malloc"(i64 1048576)
  store i8* %".2", i8** @"ayas_arena_buf"
  store i64 0, i64* @"ayas_arena_offset"
  %".5" = call double @"llvm.sin.f64"(double 0x3ff921fb54442d18)
  %".6" = call double @"llvm.cos.f64"(double 0x3ff921fb54442d18)
  %".7" = fneg double %".5"
  %".8" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double %".6", i32 0
  %".9" = insertelement <4 x double> %".8", double %".7", i32 1
  %".10" = insertelement <4 x double> %".9", double              0x0, i32 2
  %".11" = insertelement <4 x double> %".10", double              0x0, i32 3
  %".12" = insertvalue [4 x <4 x double>] undef, <4 x double> %".11", 0
  %".13" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double %".5", i32 0
  %".14" = insertelement <4 x double> %".13", double %".6", i32 1
  %".15" = insertelement <4 x double> %".14", double              0x0, i32 2
  %".16" = insertelement <4 x double> %".15", double              0x0, i32 3
  %".17" = insertvalue [4 x <4 x double>] %".12", <4 x double> %".16", 1
  %".18" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double              0x0, i32 0
  %".19" = insertelement <4 x double> %".18", double              0x0, i32 1
  %".20" = insertelement <4 x double> %".19", double 0x3ff0000000000000, i32 2
  %".21" = insertelement <4 x double> %".20", double              0x0, i32 3
  %".22" = insertvalue [4 x <4 x double>] %".17", <4 x double> %".21", 2
  %".23" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double              0x0, i32 0
  %".24" = insertelement <4 x double> %".23", double              0x0, i32 1
  %".25" = insertelement <4 x double> %".24", double              0x0, i32 2
  %".26" = insertelement <4 x double> %".25", double 0x3ff0000000000000, i32 3
  %".27" = insertvalue [4 x <4 x double>] %".22", <4 x double> %".26", 3
  %"r" = alloca [4 x <4 x double>], align 16
  store [4 x <4 x double>] %".27", [4 x <4 x double>]* %"r"
  %".29" = sitofp i64 1 to double
  %".30" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double %".29", i32 0
  %".31" = sitofp i64 0 to double
  %".32" = insertelement <4 x double> %".30", double %".31", i32 1
  %".33" = sitofp i64 0 to double
  %".34" = insertelement <4 x double> %".32", double %".33", i32 2
  %".35" = sitofp i64 1 to double
  %".36" = insertelement <4 x double> %".34", double %".35", i32 3
  %"p" = alloca <4 x double>, align 16
  store <4 x double> %".36", <4 x double>* %"p"
  %"r.1" = load [4 x <4 x double>], [4 x <4 x double>]* %"r"
  %"p.1" = load <4 x double>, <4 x double>* %"p"
  %".38" = extractvalue [4 x <4 x double>] %"r.1", 0
  %".39" = fmul <4 x double> %".38", %"p.1"
  %".40" = extractelement <4 x double> %".39", i32 0
  %".41" = extractelement <4 x double> %".39", i32 1
  %".42" = fadd double %".40", %".41"
  %".43" = extractelement <4 x double> %".39", i32 2
  %".44" = fadd double %".42", %".43"
  %".45" = extractelement <4 x double> %".39", i32 3
  %".46" = fadd double %".44", %".45"
  %".47" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double %".46", i32 0
  %".48" = extractvalue [4 x <4 x double>] %"r.1", 1
  %".49" = fmul <4 x double> %".48", %"p.1"
  %".50" = extractelement <4 x double> %".49", i32 0
  %".51" = extractelement <4 x double> %".49", i32 1
  %".52" = fadd double %".50", %".51"
  %".53" = extractelement <4 x double> %".49", i32 2
  %".54" = fadd double %".52", %".53"
  %".55" = extractelement <4 x double> %".49", i32 3
  %".56" = fadd double %".54", %".55"
  %".57" = insertelement <4 x double> %".47", double %".56", i32 1
  %".58" = extractvalue [4 x <4 x double>] %"r.1", 2
  %".59" = fmul <4 x double> %".58", %"p.1"
  %".60" = extractelement <4 x double> %".59", i32 0
  %".61" = extractelement <4 x double> %".59", i32 1
  %".62" = fadd double %".60", %".61"
  %".63" = extractelement <4 x double> %".59", i32 2
  %".64" = fadd double %".62", %".63"
  %".65" = extractelement <4 x double> %".59", i32 3
  %".66" = fadd double %".64", %".65"
  %".67" = insertelement <4 x double> %".57", double %".66", i32 2
  %".68" = extractvalue [4 x <4 x double>] %"r.1", 3
  %".69" = fmul <4 x double> %".68", %"p.1"
  %".70" = extractelement <4 x double> %".69", i32 0
  %".71" = extractelement <4 x double> %".69", i32 1
  %".72" = fadd double %".70", %".71"
  %".73" = extractelement <4 x double> %".69", i32 2
  %".74" = fadd double %".72", %".73"
  %".75" = extractelement <4 x double> %".69", i32 3
  %".76" = fadd double %".74", %".75"
  %".77" = insertelement <4 x double> %".67", double %".76", i32 3
  %".78" = bitcast [2 x i8]* @"str_lparen" to i8*
  %".79" = call i32 (i8*, ...) @"printf"(i8* %".78")
  %".80" = call i32 @"fflush"(i8* null)
  %".81" = extractelement <4 x double> %".77", i32 0
  %".82" = fcmp olt double %".81",              0x0
  br i1 %".82", label %"entry.if", label %"entry.endif"
entry.if:
  %".84" = bitcast [2 x i8]* @"str_minus" to i8*
  %".85" = call i32 (i8*, ...) @"printf"(i8* %".84")
  %".86" = call i32 @"fflush"(i8* null)
  br label %"entry.endif"
entry.endif:
  %".88" = fneg double %".81"
  %".89" = select  i1 %".82", double %".88", double %".81"
  %".90" = fptosi double %".89" to i64
  %".91" = sitofp i64 %".90" to double
  %".92" = fsub double %".89", %".91"
  %".93" = fmul double %".92", 0x40c3880000000000
  %".94" = fadd double %".93", 0x3fe0000000000000
  %".95" = fptosi double %".94" to i64
  %".96" = icmp sge i64 %".95", 10000
  %".97" = add i64 %".90", 1
  %".98" = select  i1 %".96", i64 %".97", i64 %".90"
  %".99" = select  i1 %".96", i64 0, i64 %".95"
  %".100" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".101" = call i32 (i8*, ...) @"printf"(i8* %".100", i64 %".98")
  %".102" = call i32 @"fflush"(i8* null)
  %".103" = bitcast [2 x i8]* @"str_dot" to i8*
  %".104" = call i32 (i8*, ...) @"printf"(i8* %".103")
  %".105" = call i32 @"fflush"(i8* null)
  %".106" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".107" = call i32 (i8*, ...) @"printf"(i8* %".106", i64 %".99")
  %".108" = call i32 @"fflush"(i8* null)
  %".109" = bitcast [3 x i8]* @"str_comma_space" to i8*
  %".110" = call i32 (i8*, ...) @"printf"(i8* %".109")
  %".111" = call i32 @"fflush"(i8* null)
  %".112" = extractelement <4 x double> %".77", i32 1
  %".113" = fcmp olt double %".112",              0x0
  br i1 %".113", label %"entry.endif.if", label %"entry.endif.endif"
entry.endif.if:
  %".115" = bitcast [2 x i8]* @"str_minus" to i8*
  %".116" = call i32 (i8*, ...) @"printf"(i8* %".115")
  %".117" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif"
entry.endif.endif:
  %".119" = fneg double %".112"
  %".120" = select  i1 %".113", double %".119", double %".112"
  %".121" = fptosi double %".120" to i64
  %".122" = sitofp i64 %".121" to double
  %".123" = fsub double %".120", %".122"
  %".124" = fmul double %".123", 0x40c3880000000000
  %".125" = fadd double %".124", 0x3fe0000000000000
  %".126" = fptosi double %".125" to i64
  %".127" = icmp sge i64 %".126", 10000
  %".128" = add i64 %".121", 1
  %".129" = select  i1 %".127", i64 %".128", i64 %".121"
  %".130" = select  i1 %".127", i64 0, i64 %".126"
  %".131" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".132" = call i32 (i8*, ...) @"printf"(i8* %".131", i64 %".129")
  %".133" = call i32 @"fflush"(i8* null)
  %".134" = bitcast [2 x i8]* @"str_dot" to i8*
  %".135" = call i32 (i8*, ...) @"printf"(i8* %".134")
  %".136" = call i32 @"fflush"(i8* null)
  %".137" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".138" = call i32 (i8*, ...) @"printf"(i8* %".137", i64 %".130")
  %".139" = call i32 @"fflush"(i8* null)
  %".140" = bitcast [3 x i8]* @"str_comma_space" to i8*
  %".141" = call i32 (i8*, ...) @"printf"(i8* %".140")
  %".142" = call i32 @"fflush"(i8* null)
  %".143" = extractelement <4 x double> %".77", i32 2
  %".144" = fcmp olt double %".143",              0x0
  br i1 %".144", label %"entry.endif.endif.if", label %"entry.endif.endif.endif"
entry.endif.endif.if:
  %".146" = bitcast [2 x i8]* @"str_minus" to i8*
  %".147" = call i32 (i8*, ...) @"printf"(i8* %".146")
  %".148" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif.endif"
entry.endif.endif.endif:
  %".150" = fneg double %".143"
  %".151" = select  i1 %".144", double %".150", double %".143"
  %".152" = fptosi double %".151" to i64
  %".153" = sitofp i64 %".152" to double
  %".154" = fsub double %".151", %".153"
  %".155" = fmul double %".154", 0x40c3880000000000
  %".156" = fadd double %".155", 0x3fe0000000000000
  %".157" = fptosi double %".156" to i64
  %".158" = icmp sge i64 %".157", 10000
  %".159" = add i64 %".152", 1
  %".160" = select  i1 %".158", i64 %".159", i64 %".152"
  %".161" = select  i1 %".158", i64 0, i64 %".157"
  %".162" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".163" = call i32 (i8*, ...) @"printf"(i8* %".162", i64 %".160")
  %".164" = call i32 @"fflush"(i8* null)
  %".165" = bitcast [2 x i8]* @"str_dot" to i8*
  %".166" = call i32 (i8*, ...) @"printf"(i8* %".165")
  %".167" = call i32 @"fflush"(i8* null)
  %".168" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".169" = call i32 (i8*, ...) @"printf"(i8* %".168", i64 %".161")
  %".170" = call i32 @"fflush"(i8* null)
  %".171" = bitcast [3 x i8]* @"str_comma_space" to i8*
  %".172" = call i32 (i8*, ...) @"printf"(i8* %".171")
  %".173" = call i32 @"fflush"(i8* null)
  %".174" = extractelement <4 x double> %".77", i32 3
  %".175" = fcmp olt double %".174",              0x0
  br i1 %".175", label %"entry.endif.endif.endif.if", label %"entry.endif.endif.endif.endif"
entry.endif.endif.endif.if:
  %".177" = bitcast [2 x i8]* @"str_minus" to i8*
  %".178" = call i32 (i8*, ...) @"printf"(i8* %".177")
  %".179" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif.endif.endif"
entry.endif.endif.endif.endif:
  %".181" = fneg double %".174"
  %".182" = select  i1 %".175", double %".181", double %".174"
  %".183" = fptosi double %".182" to i64
  %".184" = sitofp i64 %".183" to double
  %".185" = fsub double %".182", %".184"
  %".186" = fmul double %".185", 0x40c3880000000000
  %".187" = fadd double %".186", 0x3fe0000000000000
  %".188" = fptosi double %".187" to i64
  %".189" = icmp sge i64 %".188", 10000
  %".190" = add i64 %".183", 1
  %".191" = select  i1 %".189", i64 %".190", i64 %".183"
  %".192" = select  i1 %".189", i64 0, i64 %".188"
  %".193" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".194" = call i32 (i8*, ...) @"printf"(i8* %".193", i64 %".191")
  %".195" = call i32 @"fflush"(i8* null)
  %".196" = bitcast [2 x i8]* @"str_dot" to i8*
  %".197" = call i32 (i8*, ...) @"printf"(i8* %".196")
  %".198" = call i32 @"fflush"(i8* null)
  %".199" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".200" = call i32 (i8*, ...) @"printf"(i8* %".199", i64 %".192")
  %".201" = call i32 @"fflush"(i8* null)
  %".202" = bitcast [3 x i8]* @"str_rparen_nl" to i8*
  %".203" = call i32 (i8*, ...) @"printf"(i8* %".202")
  %".204" = call i32 @"fflush"(i8* null)
  %".205" = load i8*, i8** @"ayas_arena_buf"
  call void @"free"(i8* %".205")
  ret i32 0
}

@"str_lparen" = internal constant [2 x i8] c"(\00"
@"str_minus" = internal constant [2 x i8] c"-\00"
@"fmt_int_plain" = internal constant [6 x i8] c"%lld\00\00"
@"str_dot" = internal constant [2 x i8] c".\00"
@"fmt_frac" = internal constant [8 x i8] c"%04lld\00\00"
@"str_comma_space" = internal constant [3 x i8] c", \00"
@"str_rparen_nl" = internal constant [3 x i8] c")\0a\00"