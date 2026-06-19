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
  %".5" = mul i64 4, 8
  %".6" = load i64, i64* @"ayas_arena_offset"
  %".7" = load i8*, i8** @"ayas_arena_buf"
  %".8" = add i64 %".6", %".5"
  store i64 %".8", i64* @"ayas_arena_offset"
  %".10" = getelementptr i8, i8* %".7", i64 %".6"
  %".11" = mul i64 0, 8
  %".12" = getelementptr i8, i8* %".10", i64 %".11"
  %".13" = bitcast i8* %".12" to i64*
  store i64 10, i64* %".13"
  %".15" = mul i64 1, 8
  %".16" = getelementptr i8, i8* %".10", i64 %".15"
  %".17" = bitcast i8* %".16" to i64*
  store i64 20, i64* %".17"
  %".19" = mul i64 2, 8
  %".20" = getelementptr i8, i8* %".10", i64 %".19"
  %".21" = bitcast i8* %".20" to i64*
  store i64 30, i64* %".21"
  %".23" = insertvalue {i64, i64, i8*} undef, i64 3, 0
  %".24" = insertvalue {i64, i64, i8*} %".23", i64 4, 1
  %".25" = insertvalue {i64, i64, i8*} %".24", i8* %".10", 2
  %"scores" = alloca {i64, i64, i8*}, align 16
  store {i64, i64, i8*} %".25", {i64, i64, i8*}* %"scores"
  %".27" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".28" = extractvalue {i64, i64, i8*} %".27", 0
  %".29" = icmp slt i64 0, 0
  %".30" = icmp sge i64 0, %".28"
  %".31" = or i1 %".29", %".30"
  br i1 %".31", label %"bounds_fail", label %"bounds_ok"
bounds_ok:
  %".37" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".38" = extractvalue {i64, i64, i8*} %".37", 2
  %".39" = mul i64 0, 8
  %".40" = getelementptr i8, i8* %".38", i64 %".39"
  %".41" = bitcast i8* %".40" to i64*
  %".42" = load i64, i64* %".41"
  %".43" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".44" = call i32 (i8*, ...) @"printf"(i8* %".43", i64 %".42")
  %".45" = call i32 @"fflush"(i8* null)
  %".46" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".47" = extractvalue {i64, i64, i8*} %".46", 0
  %".48" = icmp slt i64 1, 0
  %".49" = icmp sge i64 1, %".47"
  %".50" = or i1 %".48", %".49"
  br i1 %".50", label %"bounds_fail.1", label %"bounds_ok.1"
bounds_fail:
  %".33" = bitcast [34 x i8]* @"str_oob_error" to i8*
  %".34" = call i32 (i8*, ...) @"printf"(i8* %".33")
  %".35" = call i32 @"fflush"(i8* null)
  ret i32 1
bounds_ok.1:
  %".56" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".57" = extractvalue {i64, i64, i8*} %".56", 2
  %".58" = mul i64 1, 8
  %".59" = getelementptr i8, i8* %".57", i64 %".58"
  %".60" = bitcast i8* %".59" to i64*
  %".61" = load i64, i64* %".60"
  %".62" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".63" = call i32 (i8*, ...) @"printf"(i8* %".62", i64 %".61")
  %".64" = call i32 @"fflush"(i8* null)
  %".65" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".66" = extractvalue {i64, i64, i8*} %".65", 0
  %".67" = icmp slt i64 2, 0
  %".68" = icmp sge i64 2, %".66"
  %".69" = or i1 %".67", %".68"
  br i1 %".69", label %"bounds_fail.2", label %"bounds_ok.2"
bounds_fail.1:
  %".52" = bitcast [34 x i8]* @"str_oob_error" to i8*
  %".53" = call i32 (i8*, ...) @"printf"(i8* %".52")
  %".54" = call i32 @"fflush"(i8* null)
  ret i32 1
bounds_ok.2:
  %".75" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".76" = extractvalue {i64, i64, i8*} %".75", 2
  %".77" = mul i64 2, 8
  %".78" = getelementptr i8, i8* %".76", i64 %".77"
  %".79" = bitcast i8* %".78" to i64*
  %".80" = load i64, i64* %".79"
  %".81" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".82" = call i32 (i8*, ...) @"printf"(i8* %".81", i64 %".80")
  %".83" = call i32 @"fflush"(i8* null)
  %".84" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".85" = extractvalue {i64, i64, i8*} %".84", 0
  %".86" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".87" = call i32 (i8*, ...) @"printf"(i8* %".86", i64 %".85")
  %".88" = call i32 @"fflush"(i8* null)
  %".89" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".90" = extractvalue {i64, i64, i8*} %".89", 0
  %".91" = icmp slt i64 1, 0
  %".92" = icmp sge i64 1, %".90"
  %".93" = or i1 %".91", %".92"
  br i1 %".93", label %"bounds_fail.3", label %"bounds_ok.3"
bounds_fail.2:
  %".71" = bitcast [34 x i8]* @"str_oob_error" to i8*
  %".72" = call i32 (i8*, ...) @"printf"(i8* %".71")
  %".73" = call i32 @"fflush"(i8* null)
  ret i32 1
bounds_ok.3:
  %".99" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".100" = extractvalue {i64, i64, i8*} %".99", 2
  %".101" = mul i64 1, 8
  %".102" = getelementptr i8, i8* %".100", i64 %".101"
  %".103" = bitcast i8* %".102" to i64*
  store i64 99, i64* %".103"
  %".105" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".106" = extractvalue {i64, i64, i8*} %".105", 0
  %".107" = icmp slt i64 1, 0
  %".108" = icmp sge i64 1, %".106"
  %".109" = or i1 %".107", %".108"
  br i1 %".109", label %"bounds_fail.4", label %"bounds_ok.4"
bounds_fail.3:
  %".95" = bitcast [34 x i8]* @"str_oob_error" to i8*
  %".96" = call i32 (i8*, ...) @"printf"(i8* %".95")
  %".97" = call i32 @"fflush"(i8* null)
  ret i32 1
bounds_ok.4:
  %".115" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".116" = extractvalue {i64, i64, i8*} %".115", 2
  %".117" = mul i64 1, 8
  %".118" = getelementptr i8, i8* %".116", i64 %".117"
  %".119" = bitcast i8* %".118" to i64*
  %".120" = load i64, i64* %".119"
  %".121" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".122" = call i32 (i8*, ...) @"printf"(i8* %".121", i64 %".120")
  %".123" = call i32 @"fflush"(i8* null)
  %".124" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".125" = extractvalue {i64, i64, i8*} %".124", 0
  %".126" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".127" = extractvalue {i64, i64, i8*} %".126", 1
  %".128" = icmp sge i64 %".125", %".127"
  br i1 %".128", label %"array_grow", label %"array_append_cont"
bounds_fail.4:
  %".111" = bitcast [34 x i8]* @"str_oob_error" to i8*
  %".112" = call i32 (i8*, ...) @"printf"(i8* %".111")
  %".113" = call i32 @"fflush"(i8* null)
  ret i32 1
array_grow:
  %".130" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".131" = extractvalue {i64, i64, i8*} %".130", 1
  %".132" = mul i64 %".131", 2
  %".133" = mul i64 %".132", 8
  %".134" = mul i64 %".131", 8
  %".135" = load i64, i64* @"ayas_arena_offset"
  %".136" = load i8*, i8** @"ayas_arena_buf"
  %".137" = add i64 %".135", %".133"
  store i64 %".137", i64* @"ayas_arena_offset"
  %".139" = getelementptr i8, i8* %".136", i64 %".135"
  %".140" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".141" = extractvalue {i64, i64, i8*} %".140", 2
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".139", i8* %".141", i64 %".134", i1 0)
  %".143" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".144" = insertvalue {i64, i64, i8*} %".143", i64 %".132", 1
  %".145" = insertvalue {i64, i64, i8*} %".144", i8* %".139", 2
  store {i64, i64, i8*} %".145", {i64, i64, i8*}* %"scores"
  br label %"array_append_cont"
array_append_cont:
  %".148" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".149" = extractvalue {i64, i64, i8*} %".148", 0
  %".150" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".151" = extractvalue {i64, i64, i8*} %".150", 2
  %".152" = mul i64 %".149", 8
  %".153" = getelementptr i8, i8* %".151", i64 %".152"
  %".154" = bitcast i8* %".153" to i64*
  store i64 40, i64* %".154"
  %".156" = add i64 %".149", 1
  %".157" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".158" = insertvalue {i64, i64, i8*} %".157", i64 %".156", 0
  store {i64, i64, i8*} %".158", {i64, i64, i8*}* %"scores"
  %".160" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".161" = extractvalue {i64, i64, i8*} %".160", 0
  %".162" = icmp slt i64 3, 0
  %".163" = icmp sge i64 3, %".161"
  %".164" = or i1 %".162", %".163"
  br i1 %".164", label %"bounds_fail.5", label %"bounds_ok.5"
bounds_ok.5:
  %".170" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".171" = extractvalue {i64, i64, i8*} %".170", 2
  %".172" = mul i64 3, 8
  %".173" = getelementptr i8, i8* %".171", i64 %".172"
  %".174" = bitcast i8* %".173" to i64*
  %".175" = load i64, i64* %".174"
  %".176" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".177" = call i32 (i8*, ...) @"printf"(i8* %".176", i64 %".175")
  %".178" = call i32 @"fflush"(i8* null)
  %".179" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".180" = extractvalue {i64, i64, i8*} %".179", 0
  %".181" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".182" = call i32 (i8*, ...) @"printf"(i8* %".181", i64 %".180")
  %".183" = call i32 @"fflush"(i8* null)
  %".184" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".185" = extractvalue {i64, i64, i8*} %".184", 0
  %"show_arr_i" = alloca i64, align 16
  store i64 0, i64* %"show_arr_i"
  br label %"show_arr_check"
bounds_fail.5:
  %".166" = bitcast [34 x i8]* @"str_oob_error" to i8*
  %".167" = call i32 (i8*, ...) @"printf"(i8* %".166")
  %".168" = call i32 @"fflush"(i8* null)
  ret i32 1
show_arr_check:
  %".188" = load i64, i64* %"show_arr_i"
  %".189" = icmp slt i64 %".188", %".185"
  br i1 %".189", label %"show_arr_body", label %"show_arr_end"
show_arr_body:
  %".191" = bitcast [2 x i8]* @"str_arr_lb" to i8*
  %".192" = call i32 (i8*, ...) @"printf"(i8* %".191")
  %".193" = call i32 @"fflush"(i8* null)
  %".194" = bitcast [5 x i8]* @"fmt_arr_idx" to i8*
  %".195" = call i32 (i8*, ...) @"printf"(i8* %".194", i64 %".188")
  %".196" = call i32 @"fflush"(i8* null)
  %".197" = bitcast [4 x i8]* @"str_arr_colon" to i8*
  %".198" = call i32 (i8*, ...) @"printf"(i8* %".197")
  %".199" = call i32 @"fflush"(i8* null)
  %".200" = load {i64, i64, i8*}, {i64, i64, i8*}* %"scores"
  %".201" = extractvalue {i64, i64, i8*} %".200", 2
  %".202" = mul i64 %".188", 8
  %".203" = getelementptr i8, i8* %".201", i64 %".202"
  %".204" = bitcast i8* %".203" to i64*
  %".205" = load i64, i64* %".204"
  %".206" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".207" = call i32 (i8*, ...) @"printf"(i8* %".206", i64 %".205")
  %".208" = call i32 @"fflush"(i8* null)
  %".209" = add i64 %".188", 1
  store i64 %".209", i64* %"show_arr_i"
  br label %"show_arr_check"
show_arr_end:
  %".212" = mul i64 4, 8
  %".213" = load i64, i64* @"ayas_arena_offset"
  %".214" = load i8*, i8** @"ayas_arena_buf"
  %".215" = add i64 %".213", %".212"
  store i64 %".215", i64* @"ayas_arena_offset"
  %".217" = getelementptr i8, i8* %".214", i64 %".213"
  %".218" = bitcast double 0x3ff8000000000000 to i64
  %".219" = mul i64 0, 8
  %".220" = getelementptr i8, i8* %".217", i64 %".219"
  %".221" = bitcast i8* %".220" to i64*
  store i64 %".218", i64* %".221"
  %".223" = bitcast double 0x4004000000000000 to i64
  %".224" = mul i64 1, 8
  %".225" = getelementptr i8, i8* %".217", i64 %".224"
  %".226" = bitcast i8* %".225" to i64*
  store i64 %".223", i64* %".226"
  %".228" = bitcast double 0x400c000000000000 to i64
  %".229" = mul i64 2, 8
  %".230" = getelementptr i8, i8* %".217", i64 %".229"
  %".231" = bitcast i8* %".230" to i64*
  store i64 %".228", i64* %".231"
  %".233" = insertvalue {i64, i64, i8*} undef, i64 3, 0
  %".234" = insertvalue {i64, i64, i8*} %".233", i64 4, 1
  %".235" = insertvalue {i64, i64, i8*} %".234", i8* %".217", 2
  %"temps" = alloca {i64, i64, i8*}, align 16
  store {i64, i64, i8*} %".235", {i64, i64, i8*}* %"temps"
  %".237" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".238" = extractvalue {i64, i64, i8*} %".237", 0
  %".239" = icmp slt i64 0, 0
  %".240" = icmp sge i64 0, %".238"
  %".241" = or i1 %".239", %".240"
  br i1 %".241", label %"bounds_fail.6", label %"bounds_ok.6"
bounds_ok.6:
  %".247" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".248" = extractvalue {i64, i64, i8*} %".247", 2
  %".249" = mul i64 0, 8
  %".250" = getelementptr i8, i8* %".248", i64 %".249"
  %".251" = bitcast i8* %".250" to i64*
  %".252" = load i64, i64* %".251"
  %".253" = bitcast i64 %".252" to double
  %".254" = fcmp olt double %".253",              0x0
  br i1 %".254", label %"bounds_ok.6.if", label %"bounds_ok.6.endif"
bounds_fail.6:
  %".243" = bitcast [34 x i8]* @"str_oob_error" to i8*
  %".244" = call i32 (i8*, ...) @"printf"(i8* %".243")
  %".245" = call i32 @"fflush"(i8* null)
  ret i32 1
bounds_ok.6.if:
  %".256" = bitcast [2 x i8]* @"str_minus" to i8*
  %".257" = call i32 (i8*, ...) @"printf"(i8* %".256")
  %".258" = call i32 @"fflush"(i8* null)
  br label %"bounds_ok.6.endif"
bounds_ok.6.endif:
  %".260" = fneg double %".253"
  %".261" = select  i1 %".254", double %".260", double %".253"
  %".262" = fptosi double %".261" to i64
  %".263" = sitofp i64 %".262" to double
  %".264" = fsub double %".261", %".263"
  %".265" = fmul double %".264", 0x40c3880000000000
  %".266" = fadd double %".265", 0x3fe0000000000000
  %".267" = fptosi double %".266" to i64
  %".268" = icmp sge i64 %".267", 10000
  %".269" = add i64 %".262", 1
  %".270" = select  i1 %".268", i64 %".269", i64 %".262"
  %".271" = select  i1 %".268", i64 0, i64 %".267"
  %".272" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".273" = call i32 (i8*, ...) @"printf"(i8* %".272", i64 %".270")
  %".274" = call i32 @"fflush"(i8* null)
  %".275" = bitcast [2 x i8]* @"str_dot" to i8*
  %".276" = call i32 (i8*, ...) @"printf"(i8* %".275")
  %".277" = call i32 @"fflush"(i8* null)
  %".278" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".279" = call i32 (i8*, ...) @"printf"(i8* %".278", i64 %".271")
  %".280" = call i32 @"fflush"(i8* null)
  %".281" = bitcast [2 x i8]* @"str_newline" to i8*
  %".282" = call i32 (i8*, ...) @"printf"(i8* %".281")
  %".283" = call i32 @"fflush"(i8* null)
  %".284" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".285" = extractvalue {i64, i64, i8*} %".284", 0
  %".286" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".287" = extractvalue {i64, i64, i8*} %".286", 1
  %".288" = icmp sge i64 %".285", %".287"
  br i1 %".288", label %"array_grow.1", label %"array_append_cont.1"
array_grow.1:
  %".290" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".291" = extractvalue {i64, i64, i8*} %".290", 1
  %".292" = mul i64 %".291", 2
  %".293" = mul i64 %".292", 8
  %".294" = mul i64 %".291", 8
  %".295" = load i64, i64* @"ayas_arena_offset"
  %".296" = load i8*, i8** @"ayas_arena_buf"
  %".297" = add i64 %".295", %".293"
  store i64 %".297", i64* @"ayas_arena_offset"
  %".299" = getelementptr i8, i8* %".296", i64 %".295"
  %".300" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".301" = extractvalue {i64, i64, i8*} %".300", 2
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".299", i8* %".301", i64 %".294", i1 0)
  %".303" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".304" = insertvalue {i64, i64, i8*} %".303", i64 %".292", 1
  %".305" = insertvalue {i64, i64, i8*} %".304", i8* %".299", 2
  store {i64, i64, i8*} %".305", {i64, i64, i8*}* %"temps"
  br label %"array_append_cont.1"
array_append_cont.1:
  %".308" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".309" = extractvalue {i64, i64, i8*} %".308", 0
  %".310" = bitcast double 0x4012000000000000 to i64
  %".311" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".312" = extractvalue {i64, i64, i8*} %".311", 2
  %".313" = mul i64 %".309", 8
  %".314" = getelementptr i8, i8* %".312", i64 %".313"
  %".315" = bitcast i8* %".314" to i64*
  store i64 %".310", i64* %".315"
  %".317" = add i64 %".309", 1
  %".318" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".319" = insertvalue {i64, i64, i8*} %".318", i64 %".317", 0
  store {i64, i64, i8*} %".319", {i64, i64, i8*}* %"temps"
  %".321" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".322" = extractvalue {i64, i64, i8*} %".321", 0
  %".323" = icmp slt i64 3, 0
  %".324" = icmp sge i64 3, %".322"
  %".325" = or i1 %".323", %".324"
  br i1 %".325", label %"bounds_fail.7", label %"bounds_ok.7"
bounds_ok.7:
  %".331" = load {i64, i64, i8*}, {i64, i64, i8*}* %"temps"
  %".332" = extractvalue {i64, i64, i8*} %".331", 2
  %".333" = mul i64 3, 8
  %".334" = getelementptr i8, i8* %".332", i64 %".333"
  %".335" = bitcast i8* %".334" to i64*
  %".336" = load i64, i64* %".335"
  %".337" = bitcast i64 %".336" to double
  %".338" = fcmp olt double %".337",              0x0
  br i1 %".338", label %"bounds_ok.7.if", label %"bounds_ok.7.endif"
bounds_fail.7:
  %".327" = bitcast [34 x i8]* @"str_oob_error" to i8*
  %".328" = call i32 (i8*, ...) @"printf"(i8* %".327")
  %".329" = call i32 @"fflush"(i8* null)
  ret i32 1
bounds_ok.7.if:
  %".340" = bitcast [2 x i8]* @"str_minus" to i8*
  %".341" = call i32 (i8*, ...) @"printf"(i8* %".340")
  %".342" = call i32 @"fflush"(i8* null)
  br label %"bounds_ok.7.endif"
bounds_ok.7.endif:
  %".344" = fneg double %".337"
  %".345" = select  i1 %".338", double %".344", double %".337"
  %".346" = fptosi double %".345" to i64
  %".347" = sitofp i64 %".346" to double
  %".348" = fsub double %".345", %".347"
  %".349" = fmul double %".348", 0x40c3880000000000
  %".350" = fadd double %".349", 0x3fe0000000000000
  %".351" = fptosi double %".350" to i64
  %".352" = icmp sge i64 %".351", 10000
  %".353" = add i64 %".346", 1
  %".354" = select  i1 %".352", i64 %".353", i64 %".346"
  %".355" = select  i1 %".352", i64 0, i64 %".351"
  %".356" = bitcast [6 x i8]* @"fmt_int_plain" to i8*
  %".357" = call i32 (i8*, ...) @"printf"(i8* %".356", i64 %".354")
  %".358" = call i32 @"fflush"(i8* null)
  %".359" = bitcast [2 x i8]* @"str_dot" to i8*
  %".360" = call i32 (i8*, ...) @"printf"(i8* %".359")
  %".361" = call i32 @"fflush"(i8* null)
  %".362" = bitcast [8 x i8]* @"fmt_frac" to i8*
  %".363" = call i32 (i8*, ...) @"printf"(i8* %".362", i64 %".355")
  %".364" = call i32 @"fflush"(i8* null)
  %".365" = bitcast [2 x i8]* @"str_newline" to i8*
  %".366" = call i32 (i8*, ...) @"printf"(i8* %".365")
  %".367" = call i32 @"fflush"(i8* null)
  %".368" = mul i64 4, 8
  %".369" = load i64, i64* @"ayas_arena_offset"
  %".370" = load i8*, i8** @"ayas_arena_buf"
  %".371" = add i64 %".369", %".368"
  store i64 %".371", i64* @"ayas_arena_offset"
  %".373" = getelementptr i8, i8* %".370", i64 %".369"
  %".374" = mul i64 0, 8
  %".375" = getelementptr i8, i8* %".373", i64 %".374"
  %".376" = bitcast i8* %".375" to i64*
  store i64 1, i64* %".376"
  %".378" = mul i64 1, 8
  %".379" = getelementptr i8, i8* %".373", i64 %".378"
  %".380" = bitcast i8* %".379" to i64*
  store i64 2, i64* %".380"
  %".382" = mul i64 2, 8
  %".383" = getelementptr i8, i8* %".373", i64 %".382"
  %".384" = bitcast i8* %".383" to i64*
  store i64 3, i64* %".384"
  %".386" = mul i64 3, 8
  %".387" = getelementptr i8, i8* %".373", i64 %".386"
  %".388" = bitcast i8* %".387" to i64*
  store i64 4, i64* %".388"
  %".390" = insertvalue {i64, i64, i8*} undef, i64 4, 0
  %".391" = insertvalue {i64, i64, i8*} %".390", i64 4, 1
  %".392" = insertvalue {i64, i64, i8*} %".391", i8* %".373", 2
  %"nums" = alloca {i64, i64, i8*}, align 16
  store {i64, i64, i8*} %".392", {i64, i64, i8*}* %"nums"
  %".394" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".395" = extractvalue {i64, i64, i8*} %".394", 0
  %".396" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".397" = extractvalue {i64, i64, i8*} %".396", 1
  %".398" = icmp sge i64 %".395", %".397"
  br i1 %".398", label %"array_grow.2", label %"array_append_cont.2"
array_grow.2:
  %".400" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".401" = extractvalue {i64, i64, i8*} %".400", 1
  %".402" = mul i64 %".401", 2
  %".403" = mul i64 %".402", 8
  %".404" = mul i64 %".401", 8
  %".405" = load i64, i64* @"ayas_arena_offset"
  %".406" = load i8*, i8** @"ayas_arena_buf"
  %".407" = add i64 %".405", %".403"
  store i64 %".407", i64* @"ayas_arena_offset"
  %".409" = getelementptr i8, i8* %".406", i64 %".405"
  %".410" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".411" = extractvalue {i64, i64, i8*} %".410", 2
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".409", i8* %".411", i64 %".404", i1 0)
  %".413" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".414" = insertvalue {i64, i64, i8*} %".413", i64 %".402", 1
  %".415" = insertvalue {i64, i64, i8*} %".414", i8* %".409", 2
  store {i64, i64, i8*} %".415", {i64, i64, i8*}* %"nums"
  br label %"array_append_cont.2"
array_append_cont.2:
  %".418" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".419" = extractvalue {i64, i64, i8*} %".418", 0
  %".420" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".421" = extractvalue {i64, i64, i8*} %".420", 2
  %".422" = mul i64 %".419", 8
  %".423" = getelementptr i8, i8* %".421", i64 %".422"
  %".424" = bitcast i8* %".423" to i64*
  store i64 5, i64* %".424"
  %".426" = add i64 %".419", 1
  %".427" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".428" = insertvalue {i64, i64, i8*} %".427", i64 %".426", 0
  store {i64, i64, i8*} %".428", {i64, i64, i8*}* %"nums"
  %".430" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".431" = extractvalue {i64, i64, i8*} %".430", 0
  %".432" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".433" = extractvalue {i64, i64, i8*} %".432", 1
  %".434" = icmp sge i64 %".431", %".433"
  br i1 %".434", label %"array_grow.3", label %"array_append_cont.3"
array_grow.3:
  %".436" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".437" = extractvalue {i64, i64, i8*} %".436", 1
  %".438" = mul i64 %".437", 2
  %".439" = mul i64 %".438", 8
  %".440" = mul i64 %".437", 8
  %".441" = load i64, i64* @"ayas_arena_offset"
  %".442" = load i8*, i8** @"ayas_arena_buf"
  %".443" = add i64 %".441", %".439"
  store i64 %".443", i64* @"ayas_arena_offset"
  %".445" = getelementptr i8, i8* %".442", i64 %".441"
  %".446" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".447" = extractvalue {i64, i64, i8*} %".446", 2
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".445", i8* %".447", i64 %".440", i1 0)
  %".449" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".450" = insertvalue {i64, i64, i8*} %".449", i64 %".438", 1
  %".451" = insertvalue {i64, i64, i8*} %".450", i8* %".445", 2
  store {i64, i64, i8*} %".451", {i64, i64, i8*}* %"nums"
  br label %"array_append_cont.3"
array_append_cont.3:
  %".454" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".455" = extractvalue {i64, i64, i8*} %".454", 0
  %".456" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".457" = extractvalue {i64, i64, i8*} %".456", 2
  %".458" = mul i64 %".455", 8
  %".459" = getelementptr i8, i8* %".457", i64 %".458"
  %".460" = bitcast i8* %".459" to i64*
  store i64 6, i64* %".460"
  %".462" = add i64 %".455", 1
  %".463" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".464" = insertvalue {i64, i64, i8*} %".463", i64 %".462", 0
  store {i64, i64, i8*} %".464", {i64, i64, i8*}* %"nums"
  %".466" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".467" = extractvalue {i64, i64, i8*} %".466", 0
  %".468" = icmp slt i64 4, 0
  %".469" = icmp sge i64 4, %".467"
  %".470" = or i1 %".468", %".469"
  br i1 %".470", label %"bounds_fail.8", label %"bounds_ok.8"
bounds_ok.8:
  %".476" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".477" = extractvalue {i64, i64, i8*} %".476", 2
  %".478" = mul i64 4, 8
  %".479" = getelementptr i8, i8* %".477", i64 %".478"
  %".480" = bitcast i8* %".479" to i64*
  %".481" = load i64, i64* %".480"
  %".482" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".483" = call i32 (i8*, ...) @"printf"(i8* %".482", i64 %".481")
  %".484" = call i32 @"fflush"(i8* null)
  %".485" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".486" = extractvalue {i64, i64, i8*} %".485", 0
  %".487" = icmp slt i64 5, 0
  %".488" = icmp sge i64 5, %".486"
  %".489" = or i1 %".487", %".488"
  br i1 %".489", label %"bounds_fail.9", label %"bounds_ok.9"
bounds_fail.8:
  %".472" = bitcast [34 x i8]* @"str_oob_error" to i8*
  %".473" = call i32 (i8*, ...) @"printf"(i8* %".472")
  %".474" = call i32 @"fflush"(i8* null)
  ret i32 1
bounds_ok.9:
  %".495" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".496" = extractvalue {i64, i64, i8*} %".495", 2
  %".497" = mul i64 5, 8
  %".498" = getelementptr i8, i8* %".496", i64 %".497"
  %".499" = bitcast i8* %".498" to i64*
  %".500" = load i64, i64* %".499"
  %".501" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".502" = call i32 (i8*, ...) @"printf"(i8* %".501", i64 %".500")
  %".503" = call i32 @"fflush"(i8* null)
  %".504" = load {i64, i64, i8*}, {i64, i64, i8*}* %"nums"
  %".505" = extractvalue {i64, i64, i8*} %".504", 0
  %".506" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".507" = call i32 (i8*, ...) @"printf"(i8* %".506", i64 %".505")
  %".508" = call i32 @"fflush"(i8* null)
  %".509" = load i8*, i8** @"ayas_arena_buf"
  call void @"free"(i8* %".509")
  ret i32 0
bounds_fail.9:
  %".491" = bitcast [34 x i8]* @"str_oob_error" to i8*
  %".492" = call i32 (i8*, ...) @"printf"(i8* %".491")
  %".493" = call i32 @"fflush"(i8* null)
  ret i32 1
}

@"str_oob_error" = internal constant [34 x i8] c"Error: array index out of bounds\0a\00"
@"fmt_int" = internal constant [7 x i8] c"%lld\0a\00\00"
@"str_arr_lb" = internal constant [2 x i8] c"[\00"
@"fmt_arr_idx" = internal constant [5 x i8] c"%lld\00"
@"str_arr_colon" = internal constant [4 x i8] c"]: \00"
@"str_minus" = internal constant [2 x i8] c"-\00"
@"fmt_int_plain" = internal constant [6 x i8] c"%lld\00\00"
@"str_dot" = internal constant [2 x i8] c".\00"
@"fmt_frac" = internal constant [8 x i8] c"%04lld\00\00"
@"str_newline" = internal constant [2 x i8] c"\0a\00"