; ModuleID = "ayas"
target triple = "unknown-unknown-unknown"
target datalayout = ""

declare i32 @"printf"(i8* %".1", ...)

declare i32 @"fflush"(i8* %".1")

declare double @"llvm.sin.f64"(double %".1")

declare double @"llvm.cos.f64"(double %".1")

define i32 @"main"()
{
entry:
  %".2" = call double @"llvm.sin.f64"(double 0x3ff921fb54442d18)
  %".3" = call double @"llvm.cos.f64"(double 0x3ff921fb54442d18)
  %".4" = fneg double %".2"
  %".5" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double %".3", i32 0
  %".6" = insertelement <4 x double> %".5", double %".4", i32 1
  %".7" = insertelement <4 x double> %".6", double              0x0, i32 2
  %".8" = insertelement <4 x double> %".7", double              0x0, i32 3
  %".9" = insertvalue [4 x <4 x double>] undef, <4 x double> %".8", 0
  %".10" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double %".2", i32 0
  %".11" = insertelement <4 x double> %".10", double %".3", i32 1
  %".12" = insertelement <4 x double> %".11", double              0x0, i32 2
  %".13" = insertelement <4 x double> %".12", double              0x0, i32 3
  %".14" = insertvalue [4 x <4 x double>] %".9", <4 x double> %".13", 1
  %".15" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double              0x0, i32 0
  %".16" = insertelement <4 x double> %".15", double              0x0, i32 1
  %".17" = insertelement <4 x double> %".16", double 0x3ff0000000000000, i32 2
  %".18" = insertelement <4 x double> %".17", double              0x0, i32 3
  %".19" = insertvalue [4 x <4 x double>] %".14", <4 x double> %".18", 2
  %".20" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double              0x0, i32 0
  %".21" = insertelement <4 x double> %".20", double              0x0, i32 1
  %".22" = insertelement <4 x double> %".21", double              0x0, i32 2
  %".23" = insertelement <4 x double> %".22", double 0x3ff0000000000000, i32 3
  %".24" = insertvalue [4 x <4 x double>] %".19", <4 x double> %".23", 3
  %"r" = alloca [4 x <4 x double>], align 16
  store [4 x <4 x double>] %".24", [4 x <4 x double>]* %"r"
  %".26" = sitofp i64 1 to double
  %".27" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double %".26", i32 0
  %".28" = sitofp i64 0 to double
  %".29" = insertelement <4 x double> %".27", double %".28", i32 1
  %".30" = sitofp i64 0 to double
  %".31" = insertelement <4 x double> %".29", double %".30", i32 2
  %".32" = sitofp i64 1 to double
  %".33" = insertelement <4 x double> %".31", double %".32", i32 3
  %"p" = alloca <4 x double>, align 16
  store <4 x double> %".33", <4 x double>* %"p"
  %"r.1" = load [4 x <4 x double>], [4 x <4 x double>]* %"r"
  %"p.1" = load <4 x double>, <4 x double>* %"p"
  %".35" = extractvalue [4 x <4 x double>] %"r.1", 0
  %".36" = fmul <4 x double> %".35", %"p.1"
  %".37" = extractelement <4 x double> %".36", i32 0
  %".38" = extractelement <4 x double> %".36", i32 1
  %".39" = fadd double %".37", %".38"
  %".40" = extractelement <4 x double> %".36", i32 2
  %".41" = fadd double %".39", %".40"
  %".42" = extractelement <4 x double> %".36", i32 3
  %".43" = fadd double %".41", %".42"
  %".44" = insertelement <4 x double> <double undef, double undef, double undef, double undef>, double %".43", i32 0
  %".45" = extractvalue [4 x <4 x double>] %"r.1", 1
  %".46" = fmul <4 x double> %".45", %"p.1"
  %".47" = extractelement <4 x double> %".46", i32 0
  %".48" = extractelement <4 x double> %".46", i32 1
  %".49" = fadd double %".47", %".48"
  %".50" = extractelement <4 x double> %".46", i32 2
  %".51" = fadd double %".49", %".50"
  %".52" = extractelement <4 x double> %".46", i32 3
  %".53" = fadd double %".51", %".52"
  %".54" = insertelement <4 x double> %".44", double %".53", i32 1
  %".55" = extractvalue [4 x <4 x double>] %"r.1", 2
  %".56" = fmul <4 x double> %".55", %"p.1"
  %".57" = extractelement <4 x double> %".56", i32 0
  %".58" = extractelement <4 x double> %".56", i32 1
  %".59" = fadd double %".57", %".58"
  %".60" = extractelement <4 x double> %".56", i32 2
  %".61" = fadd double %".59", %".60"
  %".62" = extractelement <4 x double> %".56", i32 3
  %".63" = fadd double %".61", %".62"
  %".64" = insertelement <4 x double> %".54", double %".63", i32 2
  %".65" = extractvalue [4 x <4 x double>] %"r.1", 3
  %".66" = fmul <4 x double> %".65", %"p.1"
  %".67" = extractelement <4 x double> %".66", i32 0
  %".68" = extractelement <4 x double> %".66", i32 1
  %".69" = fadd double %".67", %".68"
  %".70" = extractelement <4 x double> %".66", i32 2
  %".71" = fadd double %".69", %".70"
  %".72" = extractelement <4 x double> %".66", i32 3
  %".73" = fadd double %".71", %".72"
  %".74" = insertelement <4 x double> %".64", double %".73", i32 3
  %".75" = bitcast [2 x i8]* @"str_lparen" to i8*
  %".76" = call i32 (i8*, ...) @"printf"(i8* %".75")
  %".77" = call i32 @"fflush"(i8* null)
  %".78" = extractelement <4 x double> %".74", i32 0
  %".79" = fcmp olt double %".78",              0x0
  br i1 %".79", label %"entry.if", label %"entry.endif"
entry.if:
  %".81" = bitcast [2 x i8]* @"str_minus" to i8*
  %".82" = call i32 (i8*, ...) @"printf"(i8* %".81")
  %".83" = call i32 @"fflush"(i8* null)
  br label %"entry.endif"
entry.endif:
  %".85" = fneg double %".78"
  %".86" = select  i1 %".79", double %".85", double %".78"
  %".87" = fptosi double %".86" to i64
  %".88" = sitofp i64 %".87" to double
  %".89" = fsub double %".86", %".88"
  %".90" = fmul double %".89", 0x40c3880000000000
  %".91" = fadd double %".90", 0x3fe0000000000000
  %".92" = fptosi double %".91" to i64
  %".93" = icmp sge i64 %".92", 10000
  %".94" = add i64 %".87", 1
  %".95" = select  i1 %".93", i64 %".94", i64 %".87"
  %".96" = select  i1 %".93", i64 0, i64 %".92"
  %".97" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".98" = call i32 (i8*, ...) @"printf"(i8* %".97", i64 %".95")
  %".99" = call i32 @"fflush"(i8* null)
  %".100" = bitcast [2 x i8]* @"str_dot" to i8*
  %".101" = call i32 (i8*, ...) @"printf"(i8* %".100")
  %".102" = call i32 @"fflush"(i8* null)
  %".103" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".104" = call i32 (i8*, ...) @"printf"(i8* %".103", i64 %".96")
  %".105" = call i32 @"fflush"(i8* null)
  %".106" = bitcast [3 x i8]* @"str_comma_space" to i8*
  %".107" = call i32 (i8*, ...) @"printf"(i8* %".106")
  %".108" = call i32 @"fflush"(i8* null)
  %".109" = extractelement <4 x double> %".74", i32 1
  %".110" = fcmp olt double %".109",              0x0
  br i1 %".110", label %"entry.endif.if", label %"entry.endif.endif"
entry.endif.if:
  %".112" = bitcast [2 x i8]* @"str_minus" to i8*
  %".113" = call i32 (i8*, ...) @"printf"(i8* %".112")
  %".114" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif"
entry.endif.endif:
  %".116" = fneg double %".109"
  %".117" = select  i1 %".110", double %".116", double %".109"
  %".118" = fptosi double %".117" to i64
  %".119" = sitofp i64 %".118" to double
  %".120" = fsub double %".117", %".119"
  %".121" = fmul double %".120", 0x40c3880000000000
  %".122" = fadd double %".121", 0x3fe0000000000000
  %".123" = fptosi double %".122" to i64
  %".124" = icmp sge i64 %".123", 10000
  %".125" = add i64 %".118", 1
  %".126" = select  i1 %".124", i64 %".125", i64 %".118"
  %".127" = select  i1 %".124", i64 0, i64 %".123"
  %".128" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".129" = call i32 (i8*, ...) @"printf"(i8* %".128", i64 %".126")
  %".130" = call i32 @"fflush"(i8* null)
  %".131" = bitcast [2 x i8]* @"str_dot" to i8*
  %".132" = call i32 (i8*, ...) @"printf"(i8* %".131")
  %".133" = call i32 @"fflush"(i8* null)
  %".134" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".135" = call i32 (i8*, ...) @"printf"(i8* %".134", i64 %".127")
  %".136" = call i32 @"fflush"(i8* null)
  %".137" = bitcast [3 x i8]* @"str_comma_space" to i8*
  %".138" = call i32 (i8*, ...) @"printf"(i8* %".137")
  %".139" = call i32 @"fflush"(i8* null)
  %".140" = extractelement <4 x double> %".74", i32 2
  %".141" = fcmp olt double %".140",              0x0
  br i1 %".141", label %"entry.endif.endif.if", label %"entry.endif.endif.endif"
entry.endif.endif.if:
  %".143" = bitcast [2 x i8]* @"str_minus" to i8*
  %".144" = call i32 (i8*, ...) @"printf"(i8* %".143")
  %".145" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif.endif"
entry.endif.endif.endif:
  %".147" = fneg double %".140"
  %".148" = select  i1 %".141", double %".147", double %".140"
  %".149" = fptosi double %".148" to i64
  %".150" = sitofp i64 %".149" to double
  %".151" = fsub double %".148", %".150"
  %".152" = fmul double %".151", 0x40c3880000000000
  %".153" = fadd double %".152", 0x3fe0000000000000
  %".154" = fptosi double %".153" to i64
  %".155" = icmp sge i64 %".154", 10000
  %".156" = add i64 %".149", 1
  %".157" = select  i1 %".155", i64 %".156", i64 %".149"
  %".158" = select  i1 %".155", i64 0, i64 %".154"
  %".159" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".160" = call i32 (i8*, ...) @"printf"(i8* %".159", i64 %".157")
  %".161" = call i32 @"fflush"(i8* null)
  %".162" = bitcast [2 x i8]* @"str_dot" to i8*
  %".163" = call i32 (i8*, ...) @"printf"(i8* %".162")
  %".164" = call i32 @"fflush"(i8* null)
  %".165" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".166" = call i32 (i8*, ...) @"printf"(i8* %".165", i64 %".158")
  %".167" = call i32 @"fflush"(i8* null)
  %".168" = bitcast [3 x i8]* @"str_comma_space" to i8*
  %".169" = call i32 (i8*, ...) @"printf"(i8* %".168")
  %".170" = call i32 @"fflush"(i8* null)
  %".171" = extractelement <4 x double> %".74", i32 3
  %".172" = fcmp olt double %".171",              0x0
  br i1 %".172", label %"entry.endif.endif.endif.if", label %"entry.endif.endif.endif.endif"
entry.endif.endif.endif.if:
  %".174" = bitcast [2 x i8]* @"str_minus" to i8*
  %".175" = call i32 (i8*, ...) @"printf"(i8* %".174")
  %".176" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif.endif.endif"
entry.endif.endif.endif.endif:
  %".178" = fneg double %".171"
  %".179" = select  i1 %".172", double %".178", double %".171"
  %".180" = fptosi double %".179" to i64
  %".181" = sitofp i64 %".180" to double
  %".182" = fsub double %".179", %".181"
  %".183" = fmul double %".182", 0x40c3880000000000
  %".184" = fadd double %".183", 0x3fe0000000000000
  %".185" = fptosi double %".184" to i64
  %".186" = icmp sge i64 %".185", 10000
  %".187" = add i64 %".180", 1
  %".188" = select  i1 %".186", i64 %".187", i64 %".180"
  %".189" = select  i1 %".186", i64 0, i64 %".185"
  %".190" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".191" = call i32 (i8*, ...) @"printf"(i8* %".190", i64 %".188")
  %".192" = call i32 @"fflush"(i8* null)
  %".193" = bitcast [2 x i8]* @"str_dot" to i8*
  %".194" = call i32 (i8*, ...) @"printf"(i8* %".193")
  %".195" = call i32 @"fflush"(i8* null)
  %".196" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".197" = call i32 (i8*, ...) @"printf"(i8* %".196", i64 %".189")
  %".198" = call i32 @"fflush"(i8* null)
  %".199" = bitcast [3 x i8]* @"str_rparen_nl" to i8*
  %".200" = call i32 (i8*, ...) @"printf"(i8* %".199")
  %".201" = call i32 @"fflush"(i8* null)
  ret i32 0
}

@"str_lparen" = internal constant [2 x i8] c"(\00"
@"str_minus" = internal constant [2 x i8] c"-\00"
@"fmt_int_plain" = internal constant [6 x i8] c"%lld\00\00"
@"str_dot" = internal constant [2 x i8] c".\00"
@"fmt_frac" = internal constant [8 x i8] c"%04lld\00\00"
@"str_comma_space" = internal constant [3 x i8] c", \00"
@"str_rparen_nl" = internal constant [3 x i8] c")\0a\00"