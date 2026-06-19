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
  %"pi" = alloca double, align 16
  store double 0x400921f9f01b866e, double* %"pi"
  %"pi.1" = load double, double* %"pi"
  %".6" = fcmp olt double %"pi.1",              0x0
  br i1 %".6", label %"entry.if", label %"entry.endif"
entry.if:
  %".8" = bitcast [2 x i8]* @"str_minus" to i8*
  %".9" = call i32 (i8*, ...) @"printf"(i8* %".8")
  %".10" = call i32 @"fflush"(i8* null)
  br label %"entry.endif"
entry.endif:
  %".12" = fneg double %"pi.1"
  %".13" = select  i1 %".6", double %".12", double %"pi.1"
  %".14" = fptosi double %".13" to i64
  %".15" = sitofp i64 %".14" to double
  %".16" = fsub double %".13", %".15"
  %".17" = fmul double %".16", 0x40c3880000000000
  %".18" = fadd double %".17", 0x3fe0000000000000
  %".19" = fptosi double %".18" to i64
  %".20" = icmp sge i64 %".19", 10000
  %".21" = add i64 %".14", 1
  %".22" = select  i1 %".20", i64 %".21", i64 %".14"
  %".23" = select  i1 %".20", i64 0, i64 %".19"
  %".24" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".25" = call i32 (i8*, ...) @"printf"(i8* %".24", i64 %".22")
  %".26" = call i32 @"fflush"(i8* null)
  %".27" = bitcast [2 x i8]* @"str_dot" to i8*
  %".28" = call i32 (i8*, ...) @"printf"(i8* %".27")
  %".29" = call i32 @"fflush"(i8* null)
  %".30" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".31" = call i32 (i8*, ...) @"printf"(i8* %".30", i64 %".23")
  %".32" = call i32 @"fflush"(i8* null)
  %".33" = bitcast [2 x i8]* @"str_newline" to i8*
  %".34" = call i32 (i8*, ...) @"printf"(i8* %".33")
  %".35" = call i32 @"fflush"(i8* null)
  %"x" = alloca double, align 16
  store double 0x4004000000000000, double* %"x"
  %"y" = alloca i64, align 16
  store i64 4, i64* %"y"
  %"x.1" = load double, double* %"x"
  %"y.1" = load i64, i64* %"y"
  %".38" = sitofp i64 %"y.1" to double
  %".39" = fadd double %"x.1", %".38"
  %".40" = fcmp olt double %".39",              0x0
  br i1 %".40", label %"entry.endif.if", label %"entry.endif.endif"
entry.endif.if:
  %".42" = bitcast [2 x i8]* @"str_minus" to i8*
  %".43" = call i32 (i8*, ...) @"printf"(i8* %".42")
  %".44" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif"
entry.endif.endif:
  %".46" = fneg double %".39"
  %".47" = select  i1 %".40", double %".46", double %".39"
  %".48" = fptosi double %".47" to i64
  %".49" = sitofp i64 %".48" to double
  %".50" = fsub double %".47", %".49"
  %".51" = fmul double %".50", 0x40c3880000000000
  %".52" = fadd double %".51", 0x3fe0000000000000
  %".53" = fptosi double %".52" to i64
  %".54" = icmp sge i64 %".53", 10000
  %".55" = add i64 %".48", 1
  %".56" = select  i1 %".54", i64 %".55", i64 %".48"
  %".57" = select  i1 %".54", i64 0, i64 %".53"
  %".58" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".59" = call i32 (i8*, ...) @"printf"(i8* %".58", i64 %".56")
  %".60" = call i32 @"fflush"(i8* null)
  %".61" = bitcast [2 x i8]* @"str_dot" to i8*
  %".62" = call i32 (i8*, ...) @"printf"(i8* %".61")
  %".63" = call i32 @"fflush"(i8* null)
  %".64" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".65" = call i32 (i8*, ...) @"printf"(i8* %".64", i64 %".57")
  %".66" = call i32 @"fflush"(i8* null)
  %".67" = bitcast [2 x i8]* @"str_newline" to i8*
  %".68" = call i32 (i8*, ...) @"printf"(i8* %".67")
  %".69" = call i32 @"fflush"(i8* null)
  %"x.2" = load double, double* %"x"
  %".70" = fmul double %"x.2", 0x4000000000000000
  %".71" = fcmp olt double %".70",              0x0
  br i1 %".71", label %"entry.endif.endif.if", label %"entry.endif.endif.endif"
entry.endif.endif.if:
  %".73" = bitcast [2 x i8]* @"str_minus" to i8*
  %".74" = call i32 (i8*, ...) @"printf"(i8* %".73")
  %".75" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif.endif"
entry.endif.endif.endif:
  %".77" = fneg double %".70"
  %".78" = select  i1 %".71", double %".77", double %".70"
  %".79" = fptosi double %".78" to i64
  %".80" = sitofp i64 %".79" to double
  %".81" = fsub double %".78", %".80"
  %".82" = fmul double %".81", 0x40c3880000000000
  %".83" = fadd double %".82", 0x3fe0000000000000
  %".84" = fptosi double %".83" to i64
  %".85" = icmp sge i64 %".84", 10000
  %".86" = add i64 %".79", 1
  %".87" = select  i1 %".85", i64 %".86", i64 %".79"
  %".88" = select  i1 %".85", i64 0, i64 %".84"
  %".89" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".90" = call i32 (i8*, ...) @"printf"(i8* %".89", i64 %".87")
  %".91" = call i32 @"fflush"(i8* null)
  %".92" = bitcast [2 x i8]* @"str_dot" to i8*
  %".93" = call i32 (i8*, ...) @"printf"(i8* %".92")
  %".94" = call i32 @"fflush"(i8* null)
  %".95" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".96" = call i32 (i8*, ...) @"printf"(i8* %".95", i64 %".88")
  %".97" = call i32 @"fflush"(i8* null)
  %".98" = bitcast [2 x i8]* @"str_newline" to i8*
  %".99" = call i32 (i8*, ...) @"printf"(i8* %".98")
  %".100" = call i32 @"fflush"(i8* null)
  %"x.3" = load double, double* %"x"
  %".101" = fsub double %"x.3", 0x3fe0000000000000
  store double %".101", double* %"x"
  %"x.4" = load double, double* %"x"
  %".103" = fcmp olt double %"x.4",              0x0
  br i1 %".103", label %"entry.endif.endif.endif.if", label %"entry.endif.endif.endif.endif"
entry.endif.endif.endif.if:
  %".105" = bitcast [2 x i8]* @"str_minus" to i8*
  %".106" = call i32 (i8*, ...) @"printf"(i8* %".105")
  %".107" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif.endif.endif"
entry.endif.endif.endif.endif:
  %".109" = fneg double %"x.4"
  %".110" = select  i1 %".103", double %".109", double %"x.4"
  %".111" = fptosi double %".110" to i64
  %".112" = sitofp i64 %".111" to double
  %".113" = fsub double %".110", %".112"
  %".114" = fmul double %".113", 0x40c3880000000000
  %".115" = fadd double %".114", 0x3fe0000000000000
  %".116" = fptosi double %".115" to i64
  %".117" = icmp sge i64 %".116", 10000
  %".118" = add i64 %".111", 1
  %".119" = select  i1 %".117", i64 %".118", i64 %".111"
  %".120" = select  i1 %".117", i64 0, i64 %".116"
  %".121" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".122" = call i32 (i8*, ...) @"printf"(i8* %".121", i64 %".119")
  %".123" = call i32 @"fflush"(i8* null)
  %".124" = bitcast [2 x i8]* @"str_dot" to i8*
  %".125" = call i32 (i8*, ...) @"printf"(i8* %".124")
  %".126" = call i32 @"fflush"(i8* null)
  %".127" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".128" = call i32 (i8*, ...) @"printf"(i8* %".127", i64 %".120")
  %".129" = call i32 @"fflush"(i8* null)
  %".130" = bitcast [2 x i8]* @"str_newline" to i8*
  %".131" = call i32 (i8*, ...) @"printf"(i8* %".130")
  %".132" = call i32 @"fflush"(i8* null)
  %"x.5" = load double, double* %"x"
  %".133" = fcmp ogt double %"x.5", 0x3ff0000000000000
  br i1 %".133", label %"when_body_0", label %"otherwise"
merge:
  %"i" = alloca i64, align 16
  store i64 0, i64* %"i"
  %"repeat_counter" = alloca i64, align 16
  store i64 0, i64* %"repeat_counter"
  br label %"repeat_check"
when_body_0:
  %".135" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".136" = call i32 (i8*, ...) @"printf"(i8* %".135", i64 1)
  %".137" = call i32 @"fflush"(i8* null)
  br label %"merge"
otherwise:
  %".139" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".140" = call i32 (i8*, ...) @"printf"(i8* %".139", i64 0)
  %".141" = call i32 @"fflush"(i8* null)
  br label %"merge"
repeat_check:
  %"counter" = load i64, i64* %"repeat_counter"
  %".146" = icmp slt i64 %"counter", 3
  br i1 %".146", label %"repeat_body", label %"repeat_end"
repeat_body:
  %"i.1" = load i64, i64* %"i"
  %".148" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".149" = call i32 (i8*, ...) @"printf"(i8* %".148", i64 %"i.1")
  %".150" = call i32 @"fflush"(i8* null)
  %"i.2" = load i64, i64* %"i"
  %".151" = add i64 %"i.2", 1
  store i64 %".151", i64* %"i"
  %"counter.1" = load i64, i64* %"repeat_counter"
  %".153" = add i64 %"counter.1", 1
  store i64 %".153", i64* %"repeat_counter"
  br label %"repeat_check"
repeat_end:
  %".156" = load i8*, i8** @"ayas_arena_buf"
  call void @"free"(i8* %".156")
  ret i32 0
}

@"str_minus" = internal constant [2 x i8] c"-\00"
@"fmt_int_plain" = internal constant [6 x i8] c"%lld\00\00"
@"str_dot" = internal constant [2 x i8] c".\00"
@"fmt_frac" = internal constant [8 x i8] c"%04lld\00\00"
@"str_newline" = internal constant [2 x i8] c"\0a\00"
@"fmt_int" = internal constant [7 x i8] c"%lld\0a\00\00"