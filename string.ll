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
define i32 @"main"()
{
entry:
  %".2" = call i8* @"malloc"(i64 1048576)
  store i8* %".2", i8** @"ayas_arena_buf"
  store i64 0, i64* @"ayas_arena_offset"
  %".5" = bitcast [13 x i8]* @"str_lit_0" to i8*
  %".6" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".7" = call i32 (i8*, ...) @"printf"(i8* %".6", i8* %".5")
  %".8" = call i32 @"fflush"(i8* null)
  %".9" = bitcast [21 x i8]* @"str_lit_1" to i8*
  %"greeting" = alloca i8*, align 16
  store i8* %".9", i8** %"greeting"
  %"greeting.1" = load i8*, i8** %"greeting"
  %".11" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".12" = call i32 (i8*, ...) @"printf"(i8* %".11", i8* %"greeting.1")
  %".13" = call i32 @"fflush"(i8* null)
  %".14" = bitcast [9 x i8]* @"str_lit_2" to i8*
  %".15" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".16" = call i32 (i8*, ...) @"printf"(i8* %".15", i8* %".14")
  %".17" = call i32 @"fflush"(i8* null)
  %"n" = alloca i64, align 16
  store i64 42, i64* %"n"
  %"n.1" = load i64, i64* %"n"
  %".19" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".20" = call i32 (i8*, ...) @"printf"(i8* %".19", i64 %"n.1")
  %".21" = call i32 @"fflush"(i8* null)
  %".22" = bitcast [30 x i8]* @"str_lit_3" to i8*
  %".23" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".24" = call i32 (i8*, ...) @"printf"(i8* %".23", i8* %".22")
  %".25" = call i32 @"fflush"(i8* null)
  %".26" = bitcast [10 x i8]* @"str_lit_4" to i8*
  %".27" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".28" = call i32 (i8*, ...) @"printf"(i8* %".27", i8* %".26")
  %".29" = call i32 @"fflush"(i8* null)
  %".30" = bitcast [10 x i8]* @"str_lit_4" to i8*
  %".31" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".32" = call i32 (i8*, ...) @"printf"(i8* %".31", i8* %".30")
  %".33" = call i32 @"fflush"(i8* null)
  %".34" = load i8*, i8** @"ayas_arena_buf"
  call void @"free"(i8* %".34")
  ret i32 0
}

@"str_lit_0" = internal constant [13 x i8] c"Hello, Ayas!\00"
@"fmt_string" = internal constant [4 x i8] c"%s\0a\00"
@"str_lit_1" = internal constant [21 x i8] c"Stored in a variable\00"
@"str_lit_2" = internal constant [9 x i8] c"via disp\00"
@"fmt_int" = internal constant [7 x i8] c"%lld\0a\00\00"
@"str_lit_3" = internal constant [30 x i8] c"Two identical literals below:\00"
@"str_lit_4" = internal constant [10 x i8] c"same text\00"