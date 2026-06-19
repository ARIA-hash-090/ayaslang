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

define i64 @"add"(i64 %"a", i64 %"b")
{
entry:
  %"a.1" = alloca i64, align 16
  store i64 %"a", i64* %"a.1"
  %"b.1" = alloca i64, align 16
  store i64 %"b", i64* %"b.1"
  %"a.2" = load i64, i64* %"a.1"
  %"b.2" = load i64, i64* %"b.1"
  %".6" = add i64 %"a.2", %"b.2"
  ret i64 %".6"
}

define i32 @"main"()
{
entry:
  %".2" = call i8* @"malloc"(i64 1048576)
  store i8* %".2", i8** @"ayas_arena_buf"
  store i64 0, i64* @"ayas_arena_offset"
  %"i" = alloca i64, align 16
  store i64 0, i64* %"i"
  br label %"repeat_in_check"
repeat_in_check:
  %"i.1" = load i64, i64* %"i"
  %".7" = icmp slt i64 %"i.1", 5
  br i1 %".7", label %"repeat_in_body", label %"repeat_in_end"
repeat_in_body:
  %"i.2" = load i64, i64* %"i"
  %".9" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".10" = call i32 (i8*, ...) @"printf"(i8* %".9", i64 %"i.2")
  %".11" = call i32 @"fflush"(i8* null)
  %"i.3" = load i64, i64* %"i"
  %".12" = add i64 %"i.3", 1
  store i64 %".12", i64* %"i"
  br label %"repeat_in_check"
repeat_in_end:
  %"n" = alloca i64, align 16
  store i64 3, i64* %"n"
  %"j" = alloca i64, align 16
  store i64 0, i64* %"j"
  %"n.1" = load i64, i64* %"n"
  br label %"repeat_in_check.1"
repeat_in_check.1:
  %"j.1" = load i64, i64* %"j"
  %".18" = icmp slt i64 %"j.1", %"n.1"
  br i1 %".18", label %"repeat_in_body.1", label %"repeat_in_end.1"
repeat_in_body.1:
  %"j.2" = load i64, i64* %"j"
  %".20" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".21" = call i32 (i8*, ...) @"printf"(i8* %".20", i64 %"j.2")
  %".22" = call i32 @"fflush"(i8* null)
  %"j.3" = load i64, i64* %"j"
  %".23" = add i64 %"j.3", 1
  store i64 %".23", i64* %"j"
  br label %"repeat_in_check.1"
repeat_in_end.1:
  %".26" = call i64 @"add"(i64 3, i64 4)
  %".27" = mul i64 4, 8
  %".28" = load i64, i64* @"ayas_arena_offset"
  %".29" = load i8*, i8** @"ayas_arena_buf"
  %".30" = add i64 %".28", %".27"
  store i64 %".30", i64* @"ayas_arena_offset"
  %".32" = getelementptr i8, i8* %".29", i64 %".28"
  %".33" = call i64 @"add"(i64 3, i64 4)
  %".34" = mul i64 0, 8
  %".35" = getelementptr i8, i8* %".32", i64 %".34"
  %".36" = bitcast i8* %".35" to i64*
  store i64 %".33", i64* %".36"
  %".38" = insertvalue {i64, i64, i8*} undef, i64 1, 0
  %".39" = insertvalue {i64, i64, i8*} %".38", i64 4, 1
  %".40" = insertvalue {i64, i64, i8*} %".39", i8* %".32", 2
  %"result" = alloca {i64, i64, i8*}, align 16
  store {i64, i64, i8*} %".40", {i64, i64, i8*}* %"result"
  %".42" = load {i64, i64, i8*}, {i64, i64, i8*}* %"result"
  %".43" = extractvalue {i64, i64, i8*} %".42", 0
  %"show_arr_i" = alloca i64, align 16
  store i64 0, i64* %"show_arr_i"
  br label %"show_arr_check"
show_arr_check:
  %".46" = load i64, i64* %"show_arr_i"
  %".47" = icmp slt i64 %".46", %".43"
  br i1 %".47", label %"show_arr_body", label %"show_arr_end"
show_arr_body:
  %".49" = bitcast [2 x i8]* @"str_arr_lb" to i8*
  %".50" = call i32 (i8*, ...) @"printf"(i8* %".49")
  %".51" = call i32 @"fflush"(i8* null)
  %".52" = bitcast [5 x i8]* @"fmt_arr_idx" to i8*
  %".53" = call i32 (i8*, ...) @"printf"(i8* %".52", i64 %".46")
  %".54" = call i32 @"fflush"(i8* null)
  %".55" = bitcast [4 x i8]* @"str_arr_colon" to i8*
  %".56" = call i32 (i8*, ...) @"printf"(i8* %".55")
  %".57" = call i32 @"fflush"(i8* null)
  %".58" = load {i64, i64, i8*}, {i64, i64, i8*}* %"result"
  %".59" = extractvalue {i64, i64, i8*} %".58", 2
  %".60" = mul i64 %".46", 8
  %".61" = getelementptr i8, i8* %".59", i64 %".60"
  %".62" = bitcast i8* %".61" to i64*
  %".63" = load i64, i64* %".62"
  %".64" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".65" = call i32 (i8*, ...) @"printf"(i8* %".64", i64 %".63")
  %".66" = call i32 @"fflush"(i8* null)
  %".67" = add i64 %".46", 1
  store i64 %".67", i64* %"show_arr_i"
  br label %"show_arr_check"
show_arr_end:
  %".70" = load i8*, i8** @"ayas_arena_buf"
  call void @"free"(i8* %".70")
  ret i32 0
}

@"fmt_int" = internal constant [7 x i8] c"%lld\0a\00\00"
@"str_arr_lb" = internal constant [2 x i8] c"[\00"
@"fmt_arr_idx" = internal constant [5 x i8] c"%lld\00"
@"str_arr_colon" = internal constant [4 x i8] c"]: \00"