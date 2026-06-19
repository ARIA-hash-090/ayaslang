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
  %".5" = load i64, i64* @"ayas_arena_offset"
  %".6" = load i8*, i8** @"ayas_arena_buf"
  %".7" = add i64 %".5", 8
  store i64 %".7", i64* @"ayas_arena_offset"
  %".9" = getelementptr i8, i8* %".6", i64 %".5"
  %".10" = ptrtoint i8* %".9" to i64
  %"p" = alloca i64, align 16
  store i64 %".10", i64* %"p"
  %"p.1" = load i64, i64* %"p"
  %".12" = inttoptr i64 %"p.1" to i64*
  store i64 42, i64* %".12"
  %"p.2" = load i64, i64* %"p"
  %".14" = inttoptr i64 %"p.2" to i64*
  %".15" = load i64, i64* %".14"
  %".16" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".17" = call i32 (i8*, ...) @"printf"(i8* %".16", i64 %".15")
  %".18" = call i32 @"fflush"(i8* null)
  %".19" = load i64, i64* @"ayas_arena_offset"
  %".20" = load i8*, i8** @"ayas_arena_buf"
  %".21" = add i64 %".19", 8
  store i64 %".21", i64* @"ayas_arena_offset"
  %".23" = getelementptr i8, i8* %".20", i64 %".19"
  %".24" = ptrtoint i8* %".23" to i64
  %"q" = alloca i64, align 16
  store i64 %".24", i64* %"q"
  %"q.1" = load i64, i64* %"q"
  %".26" = inttoptr i64 %"q.1" to i64*
  store i64 99, i64* %".26"
  %"q.2" = load i64, i64* %"q"
  %".28" = inttoptr i64 %"q.2" to i64*
  %".29" = load i64, i64* %".28"
  %".30" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".31" = call i32 (i8*, ...) @"printf"(i8* %".30", i64 %".29")
  %".32" = call i32 @"fflush"(i8* null)
  %"p.3" = load i64, i64* %"p"
  %".33" = inttoptr i64 %"p.3" to i64*
  %".34" = load i64, i64* %".33"
  %".35" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".36" = call i32 (i8*, ...) @"printf"(i8* %".35", i64 %".34")
  %".37" = call i32 @"fflush"(i8* null)
  store i64 0, i64* @"ayas_arena_offset"
  %".39" = load i64, i64* @"ayas_arena_offset"
  %".40" = load i8*, i8** @"ayas_arena_buf"
  %".41" = add i64 %".39", 8
  store i64 %".41", i64* @"ayas_arena_offset"
  %".43" = getelementptr i8, i8* %".40", i64 %".39"
  %".44" = ptrtoint i8* %".43" to i64
  %"r" = alloca i64, align 16
  store i64 %".44", i64* %"r"
  %"r.1" = load i64, i64* %"r"
  %".46" = inttoptr i64 %"r.1" to i64*
  store i64 7, i64* %".46"
  %"r.2" = load i64, i64* %"r"
  %".48" = inttoptr i64 %"r.2" to i64*
  %".49" = load i64, i64* %".48"
  %".50" = bitcast [7 x i8]* @"fmt_int" to i8*
  %".51" = call i32 (i8*, ...) @"printf"(i8* %".50", i64 %".49")
  %".52" = call i32 @"fflush"(i8* null)
  %".53" = load i8*, i8** @"ayas_arena_buf"
  call void @"free"(i8* %".53")
  ret i32 0
}

@"fmt_int" = internal constant [7 x i8] c"%lld\0a\00\00"