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
  %".5" = insertvalue {double, double, i64} undef, double 0x4014000000000000, 0
  %".6" = insertvalue {double, double, i64} %".5", double 0x4024000000000000, 1
  %".7" = insertvalue {double, double, i64} %".6", i64 100, 2
  %"bad_guy" = alloca {double, double, i64}, align 16
  store {double, double, i64} %".7", {double, double, i64}* %"bad_guy"
  %"bad_guy.1" = load {double, double, i64}, {double, double, i64}* %"bad_guy"
  %".9" = extractvalue {double, double, i64} %"bad_guy.1", 0
  %".10" = fcmp olt double %".9",              0x0
  br i1 %".10", label %"entry.if", label %"entry.endif"
entry.if:
  %".12" = bitcast [2 x i8]* @"str_minus" to i8*
  %".13" = call i32 (i8*, ...) @"printf"(i8* %".12")
  %".14" = call i32 @"fflush"(i8* null)
  br label %"entry.endif"
entry.endif:
  %".16" = fneg double %".9"
  %".17" = select  i1 %".10", double %".16", double %".9"
  %".18" = fptosi double %".17" to i64
  %".19" = sitofp i64 %".18" to double
  %".20" = fsub double %".17", %".19"
  %".21" = fmul double %".20", 0x40c3880000000000
  %".22" = fadd double %".21", 0x3fe0000000000000
  %".23" = fptosi double %".22" to i64
  %".24" = icmp sge i64 %".23", 10000
  %".25" = add i64 %".18", 1
  %".26" = select  i1 %".24", i64 %".25", i64 %".18"
  %".27" = select  i1 %".24", i64 0, i64 %".23"
  %".28" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".29" = call i32 (i8*, ...) @"printf"(i8* %".28", i64 %".26")
  %".30" = call i32 @"fflush"(i8* null)
  %".31" = bitcast [2 x i8]* @"str_dot" to i8*
  %".32" = call i32 (i8*, ...) @"printf"(i8* %".31")
  %".33" = call i32 @"fflush"(i8* null)
  %".34" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".35" = call i32 (i8*, ...) @"printf"(i8* %".34", i64 %".27")
  %".36" = call i32 @"fflush"(i8* null)
  %".37" = bitcast [2 x i8]* @"str_newline" to i8*
  %".38" = call i32 (i8*, ...) @"printf"(i8* %".37")
  %".39" = call i32 @"fflush"(i8* null)
  %"bad_guy.2" = load {double, double, i64}, {double, double, i64}* %"bad_guy"
  %".40" = extractvalue {double, double, i64} %"bad_guy.2", 1
  %".41" = fcmp olt double %".40",              0x0
  br i1 %".41", label %"entry.endif.if", label %"entry.endif.endif"
entry.endif.if:
  %".43" = bitcast [2 x i8]* @"str_minus" to i8*
  %".44" = call i32 (i8*, ...) @"printf"(i8* %".43")
  %".45" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif"
entry.endif.endif:
  %".47" = fneg double %".40"
  %".48" = select  i1 %".41", double %".47", double %".40"
  %".49" = fptosi double %".48" to i64
  %".50" = sitofp i64 %".49" to double
  %".51" = fsub double %".48", %".50"
  %".52" = fmul double %".51", 0x40c3880000000000
  %".53" = fadd double %".52", 0x3fe0000000000000
  %".54" = fptosi double %".53" to i64
  %".55" = icmp sge i64 %".54", 10000
  %".56" = add i64 %".49", 1
  %".57" = select  i1 %".55", i64 %".56", i64 %".49"
  %".58" = select  i1 %".55", i64 0, i64 %".54"
  %".59" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".60" = call i32 (i8*, ...) @"printf"(i8* %".59", i64 %".57")
  %".61" = call i32 @"fflush"(i8* null)
  %".62" = bitcast [2 x i8]* @"str_dot" to i8*
  %".63" = call i32 (i8*, ...) @"printf"(i8* %".62")
  %".64" = call i32 @"fflush"(i8* null)
  %".65" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".66" = call i32 (i8*, ...) @"printf"(i8* %".65", i64 %".58")
  %".67" = call i32 @"fflush"(i8* null)
  %".68" = bitcast [2 x i8]* @"str_newline" to i8*
  %".69" = call i32 (i8*, ...) @"printf"(i8* %".68")
  %".70" = call i32 @"fflush"(i8* null)
  %"bad_guy.3" = load {double, double, i64}, {double, double, i64}* %"bad_guy"
  %".71" = extractvalue {double, double, i64} %"bad_guy.3", 2
  %".72" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".73" = call i32 (i8*, ...) @"printf"(i8* %".72", i64 %".71")
  %".74" = call i32 @"fflush"(i8* null)
  %"bad_guy.4" = load {double, double, i64}, {double, double, i64}* %"bad_guy"
  %".75" = insertvalue {double, double, i64} %"bad_guy.4", double 0x4034000000000000, 0
  store {double, double, i64} %".75", {double, double, i64}* %"bad_guy"
  %"bad_guy.5" = load {double, double, i64}, {double, double, i64}* %"bad_guy"
  %".77" = extractvalue {double, double, i64} %"bad_guy.5", 0
  %".78" = fcmp olt double %".77",              0x0
  br i1 %".78", label %"entry.endif.endif.if", label %"entry.endif.endif.endif"
entry.endif.endif.if:
  %".80" = bitcast [2 x i8]* @"str_minus" to i8*
  %".81" = call i32 (i8*, ...) @"printf"(i8* %".80")
  %".82" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif.endif"
entry.endif.endif.endif:
  %".84" = fneg double %".77"
  %".85" = select  i1 %".78", double %".84", double %".77"
  %".86" = fptosi double %".85" to i64
  %".87" = sitofp i64 %".86" to double
  %".88" = fsub double %".85", %".87"
  %".89" = fmul double %".88", 0x40c3880000000000
  %".90" = fadd double %".89", 0x3fe0000000000000
  %".91" = fptosi double %".90" to i64
  %".92" = icmp sge i64 %".91", 10000
  %".93" = add i64 %".86", 1
  %".94" = select  i1 %".92", i64 %".93", i64 %".86"
  %".95" = select  i1 %".92", i64 0, i64 %".91"
  %".96" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".97" = call i32 (i8*, ...) @"printf"(i8* %".96", i64 %".94")
  %".98" = call i32 @"fflush"(i8* null)
  %".99" = bitcast [2 x i8]* @"str_dot" to i8*
  %".100" = call i32 (i8*, ...) @"printf"(i8* %".99")
  %".101" = call i32 @"fflush"(i8* null)
  %".102" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".103" = call i32 (i8*, ...) @"printf"(i8* %".102", i64 %".95")
  %".104" = call i32 @"fflush"(i8* null)
  %".105" = bitcast [2 x i8]* @"str_newline" to i8*
  %".106" = call i32 (i8*, ...) @"printf"(i8* %".105")
  %".107" = call i32 @"fflush"(i8* null)
  %".108" = load i8*, i8** @"ayas_arena_buf"
  call void @"free"(i8* %".108")
  ret i32 0
}

@"str_minus" = internal constant [2 x i8] c"-\00"
@"fmt_int_plain" = internal constant [6 x i8] c"%lld\00\00"
@"str_dot" = internal constant [2 x i8] c".\00"
@"fmt_frac" = internal constant [8 x i8] c"%04lld\00\00"
@"str_newline" = internal constant [2 x i8] c"\0a\00"
@"fmt_int" = internal constant [7 x i8] c"%lld\0a\00\00"