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
  %".2" = insertvalue {double, double, i64} undef, double 0x4014000000000000, 0
  %".3" = insertvalue {double, double, i64} %".2", double 0x4024000000000000, 1
  %".4" = insertvalue {double, double, i64} %".3", i64 100, 2
  %"bad_guy" = alloca {double, double, i64}, align 16
  store {double, double, i64} %".4", {double, double, i64}* %"bad_guy"
  %"bad_guy.1" = load {double, double, i64}, {double, double, i64}* %"bad_guy"
  %".6" = extractvalue {double, double, i64} %"bad_guy.1", 0
  %".7" = fcmp olt double %".6",              0x0
  br i1 %".7", label %"entry.if", label %"entry.endif"
entry.if:
  %".9" = bitcast [2 x i8]* @"str_minus" to i8*
  %".10" = call i32 (i8*, ...) @"printf"(i8* %".9")
  %".11" = call i32 @"fflush"(i8* null)
  br label %"entry.endif"
entry.endif:
  %".13" = fneg double %".6"
  %".14" = select  i1 %".7", double %".13", double %".6"
  %".15" = fptosi double %".14" to i64
  %".16" = sitofp i64 %".15" to double
  %".17" = fsub double %".14", %".16"
  %".18" = fmul double %".17", 0x40c3880000000000
  %".19" = fadd double %".18", 0x3fe0000000000000
  %".20" = fptosi double %".19" to i64
  %".21" = icmp sge i64 %".20", 10000
  %".22" = add i64 %".15", 1
  %".23" = select  i1 %".21", i64 %".22", i64 %".15"
  %".24" = select  i1 %".21", i64 0, i64 %".20"
  %".25" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".26" = call i32 (i8*, ...) @"printf"(i8* %".25", i64 %".23")
  %".27" = call i32 @"fflush"(i8* null)
  %".28" = bitcast [2 x i8]* @"str_dot" to i8*
  %".29" = call i32 (i8*, ...) @"printf"(i8* %".28")
  %".30" = call i32 @"fflush"(i8* null)
  %".31" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".32" = call i32 (i8*, ...) @"printf"(i8* %".31", i64 %".24")
  %".33" = call i32 @"fflush"(i8* null)
  %".34" = bitcast [2 x i8]* @"str_newline" to i8*
  %".35" = call i32 (i8*, ...) @"printf"(i8* %".34")
  %".36" = call i32 @"fflush"(i8* null)
  %"bad_guy.2" = load {double, double, i64}, {double, double, i64}* %"bad_guy"
  %".37" = extractvalue {double, double, i64} %"bad_guy.2", 1
  %".38" = fcmp olt double %".37",              0x0
  br i1 %".38", label %"entry.endif.if", label %"entry.endif.endif"
entry.endif.if:
  %".40" = bitcast [2 x i8]* @"str_minus" to i8*
  %".41" = call i32 (i8*, ...) @"printf"(i8* %".40")
  %".42" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif"
entry.endif.endif:
  %".44" = fneg double %".37"
  %".45" = select  i1 %".38", double %".44", double %".37"
  %".46" = fptosi double %".45" to i64
  %".47" = sitofp i64 %".46" to double
  %".48" = fsub double %".45", %".47"
  %".49" = fmul double %".48", 0x40c3880000000000
  %".50" = fadd double %".49", 0x3fe0000000000000
  %".51" = fptosi double %".50" to i64
  %".52" = icmp sge i64 %".51", 10000
  %".53" = add i64 %".46", 1
  %".54" = select  i1 %".52", i64 %".53", i64 %".46"
  %".55" = select  i1 %".52", i64 0, i64 %".51"
  %".56" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".57" = call i32 (i8*, ...) @"printf"(i8* %".56", i64 %".54")
  %".58" = call i32 @"fflush"(i8* null)
  %".59" = bitcast [2 x i8]* @"str_dot" to i8*
  %".60" = call i32 (i8*, ...) @"printf"(i8* %".59")
  %".61" = call i32 @"fflush"(i8* null)
  %".62" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".63" = call i32 (i8*, ...) @"printf"(i8* %".62", i64 %".55")
  %".64" = call i32 @"fflush"(i8* null)
  %".65" = bitcast [2 x i8]* @"str_newline" to i8*
  %".66" = call i32 (i8*, ...) @"printf"(i8* %".65")
  %".67" = call i32 @"fflush"(i8* null)
  %"bad_guy.3" = load {double, double, i64}, {double, double, i64}* %"bad_guy"
  %".68" = extractvalue {double, double, i64} %"bad_guy.3", 2
  %".69" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".70" = call i32 (i8*, ...) @"printf"(i8* %".69", i64 %".68")
  %".71" = call i32 @"fflush"(i8* null)
  %"bad_guy.4" = load {double, double, i64}, {double, double, i64}* %"bad_guy"
  %".72" = insertvalue {double, double, i64} %"bad_guy.4", double 0x4034000000000000, 0
  store {double, double, i64} %".72", {double, double, i64}* %"bad_guy"
  %"bad_guy.5" = load {double, double, i64}, {double, double, i64}* %"bad_guy"
  %".74" = extractvalue {double, double, i64} %"bad_guy.5", 0
  %".75" = fcmp olt double %".74",              0x0
  br i1 %".75", label %"entry.endif.endif.if", label %"entry.endif.endif.endif"
entry.endif.endif.if:
  %".77" = bitcast [2 x i8]* @"str_minus" to i8*
  %".78" = call i32 (i8*, ...) @"printf"(i8* %".77")
  %".79" = call i32 @"fflush"(i8* null)
  br label %"entry.endif.endif.endif"
entry.endif.endif.endif:
  %".81" = fneg double %".74"
  %".82" = select  i1 %".75", double %".81", double %".74"
  %".83" = fptosi double %".82" to i64
  %".84" = sitofp i64 %".83" to double
  %".85" = fsub double %".82", %".84"
  %".86" = fmul double %".85", 0x40c3880000000000
  %".87" = fadd double %".86", 0x3fe0000000000000
  %".88" = fptosi double %".87" to i64
  %".89" = icmp sge i64 %".88", 10000
  %".90" = add i64 %".83", 1
  %".91" = select  i1 %".89", i64 %".90", i64 %".83"
  %".92" = select  i1 %".89", i64 0, i64 %".88"
  %".93" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".94" = call i32 (i8*, ...) @"printf"(i8* %".93", i64 %".91")
  %".95" = call i32 @"fflush"(i8* null)
  %".96" = bitcast [2 x i8]* @"str_dot" to i8*
  %".97" = call i32 (i8*, ...) @"printf"(i8* %".96")
  %".98" = call i32 @"fflush"(i8* null)
  %".99" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".100" = call i32 (i8*, ...) @"printf"(i8* %".99", i64 %".92")
  %".101" = call i32 @"fflush"(i8* null)
  %".102" = bitcast [2 x i8]* @"str_newline" to i8*
  %".103" = call i32 (i8*, ...) @"printf"(i8* %".102")
  %".104" = call i32 @"fflush"(i8* null)
  ret i32 0
}

@"str_minus" = internal constant [2 x i8] c"-\00"
@"fmt_int_plain" = internal constant [6 x i8] c"%lld\00\00"
@"str_dot" = internal constant [2 x i8] c".\00"
@"fmt_frac" = internal constant [8 x i8] c"%04lld\00\00"
@"str_newline" = internal constant [2 x i8] c"\0a\00"
@"fmt_int" = internal constant [7 x i8] c"%lld\0a\00\00"