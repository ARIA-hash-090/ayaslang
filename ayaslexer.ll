; ModuleID = "ayas"
target triple = "unknown-unknown-unknown"
target datalayout = ""

declare i32 @"printf"(i8* %".1", ...)

declare i32 @"fflush"(i8* %".1")

declare double @"llvm.sin.f64"(double %".1")

declare double @"llvm.cos.f64"(double %".1")

declare i8* @"fopen"(i8* %".1", i8* %".2")

declare i32 @"fclose"(i8* %".1")

declare i64 @"fread"(i8* %".1", i64 %".2", i64 %".3", i8* %".4")

declare i64 @"fwrite"(i8* %".1", i64 %".2", i64 %".3", i8* %".4")

declare i32 @"fseek"(i8* %".1", i64 %".2", i32 %".3")

declare i64 @"ftell"(i8* %".1")

declare i64 @"strlen"(i8* %".1")

declare i8* @"malloc"(i64 %".1")

declare void @"free"(i8* %".1")

@"ayas_arena_buf" = internal global i8* null
@"ayas_arena_offset" = internal global i64 0
declare void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1", i8* %".2", i64 %".3", i1 %".4")

@"gconst_pos" = internal constant i64 0
@"gconst_line" = internal constant i64 1
@"gconst_CH_NEWLINE" = internal constant i64 10
@"gconst_CH_SPACE" = internal constant i64 32
@"gconst_CH_TAB" = internal constant i64 9
@"gconst_CH_CR" = internal constant i64 13
@"gconst_CH_0" = internal constant i64 48
@"gconst_CH_9" = internal constant i64 57
@"gconst_CH_a" = internal constant i64 97
@"gconst_CH_z" = internal constant i64 122
@"gconst_CH_A" = internal constant i64 65
@"gconst_CH_Z" = internal constant i64 90
@"gconst_CH_UNDER" = internal constant i64 95
@"gconst_CH_QUOTE" = internal constant i64 34
@"gconst_CH_SLASH" = internal constant i64 47
@"gconst_CH_PLUS" = internal constant i64 43
@"gconst_CH_MINUS" = internal constant i64 45
@"gconst_CH_STAR" = internal constant i64 42
@"gconst_CH_LBRACKET" = internal constant i64 91
@"gconst_CH_RBRACKET" = internal constant i64 93
@"gconst_CH_LBRACE" = internal constant i64 123
@"gconst_CH_RBRACE" = internal constant i64 125
@"gconst_CH_LPAREN" = internal constant i64 40
@"gconst_CH_RPAREN" = internal constant i64 41
@"gconst_CH_COMMA" = internal constant i64 44
@"gconst_CH_COLON" = internal constant i64 58
@"gconst_CH_DOT" = internal constant i64 46
@"gconst_CH_GT" = internal constant i64 62
@"gconst_CH_LT" = internal constant i64 60
@"gconst_CH_EQ" = internal constant i64 61
define i64 @"is_digit"(i64 %"c")
{
entry:
  %"c.1" = alloca i64, align 16
  store i64 %"c", i64* %"c.1"
  %"c.2" = load i64, i64* %"c.1"
  %".4" = icmp sge i64 %"c.2", 48
  %"c.3" = load i64, i64* %"c.1"
  %".5" = icmp sle i64 %"c.3", 57
  %".6" = and i1 %".4", %".5"
  %".7" = zext i1 %".6" to i64
  ret i64 %".7"
}

define i64 @"is_alpha"(i64 %"c")
{
entry:
  %"c.1" = alloca i64, align 16
  store i64 %"c", i64* %"c.1"
  %"c.2" = load i64, i64* %"c.1"
  %".4" = icmp sge i64 %"c.2", 97
  %"c.3" = load i64, i64* %"c.1"
  %".5" = icmp sle i64 %"c.3", 122
  %".6" = and i1 %".4", %".5"
  br i1 %".6", label %"when_body_0", label %"merge"
merge:
  %"c.4" = load i64, i64* %"c.1"
  %".9" = icmp sge i64 %"c.4", 65
  %"c.5" = load i64, i64* %"c.1"
  %".10" = icmp sle i64 %"c.5", 90
  %".11" = and i1 %".9", %".10"
  br i1 %".11", label %"when_body_0.1", label %"merge.1"
when_body_0:
  ret i64 1
merge.1:
  %"c.6" = load i64, i64* %"c.1"
  %".14" = icmp eq i64 %"c.6", 95
  br i1 %".14", label %"when_body_0.2", label %"merge.2"
when_body_0.1:
  ret i64 1
merge.2:
  ret i64 0
when_body_0.2:
  ret i64 1
}

define i64 @"is_alnum"(i64 %"c")
{
entry:
  %"c.1" = alloca i64, align 16
  store i64 %"c", i64* %"c.1"
  %"c.2" = load i64, i64* %"c.1"
  %".4" = icmp sge i64 %"c.2", 97
  %"c.3" = load i64, i64* %"c.1"
  %".5" = icmp sle i64 %"c.3", 122
  %".6" = and i1 %".4", %".5"
  br i1 %".6", label %"when_body_0", label %"merge"
merge:
  %"c.4" = load i64, i64* %"c.1"
  %".9" = icmp sge i64 %"c.4", 65
  %"c.5" = load i64, i64* %"c.1"
  %".10" = icmp sle i64 %"c.5", 90
  %".11" = and i1 %".9", %".10"
  br i1 %".11", label %"when_body_0.1", label %"merge.1"
when_body_0:
  ret i64 1
merge.1:
  %"c.6" = load i64, i64* %"c.1"
  %".14" = icmp sge i64 %"c.6", 48
  %"c.7" = load i64, i64* %"c.1"
  %".15" = icmp sle i64 %"c.7", 57
  %".16" = and i1 %".14", %".15"
  br i1 %".16", label %"when_body_0.2", label %"merge.2"
when_body_0.1:
  ret i64 1
merge.2:
  %"c.8" = load i64, i64* %"c.1"
  %".19" = icmp eq i64 %"c.8", 95
  br i1 %".19", label %"when_body_0.3", label %"merge.3"
when_body_0.2:
  ret i64 1
merge.3:
  ret i64 0
when_body_0.3:
  ret i64 1
}

define i8* @"int_to_str"(i64 %"n")
{
entry:
  %"n.1" = alloca i64, align 16
  store i64 %"n", i64* %"n.1"
  %".4" = load i64, i64* @"ayas_arena_offset"
  %".5" = load i8*, i8** @"ayas_arena_buf"
  %".6" = add i64 %".4", 32
  store i64 %".6", i64* @"ayas_arena_offset"
  %".8" = getelementptr i8, i8* %".5", i64 %".4"
  store i8 0, i8* %".8"
  %"buf" = alloca i8*, align 16
  store i8* %".8", i8** %"buf"
  %".11" = load i64, i64* @"ayas_arena_offset"
  %".12" = load i8*, i8** @"ayas_arena_buf"
  %".13" = add i64 %".11", 32
  store i64 %".13", i64* @"ayas_arena_offset"
  %".15" = getelementptr i8, i8* %".12", i64 %".11"
  store i8 0, i8* %".15"
  %"tmp" = alloca i8*, align 16
  store i8* %".15", i8** %"tmp"
  %"n.2" = load i64, i64* %"n.1"
  %"i" = alloca i64, align 16
  store i64 %"n.2", i64* %"i"
  %"tdone" = alloca i64, align 16
  store i64 0, i64* %"tdone"
  %"n.3" = load i64, i64* %"n.1"
  %".20" = icmp eq i64 %"n.3", 0
  br i1 %".20", label %"when_body_0", label %"merge"
merge:
  %"tloop" = alloca i64, align 16
  store i64 0, i64* %"tloop"
  br label %"repeat_in_check"
when_body_0:
  %"buf.1" = load i8*, i8** %"buf"
  %".22" = call i64 @"strlen"(i8* %"buf.1")
  %".23" = getelementptr i8, i8* %"buf.1", i64 %".22"
  %".24" = trunc i64 48 to i8
  store i8 %".24", i8* %".23"
  %".26" = add i64 %".22", 1
  %".27" = getelementptr i8, i8* %"buf.1", i64 %".26"
  store i8 0, i8* %".27"
  store i64 1, i64* %"tdone"
  br label %"merge"
repeat_in_check:
  %"tloop.1" = load i64, i64* %"tloop"
  %".33" = icmp slt i64 %"tloop.1", 20
  br i1 %".33", label %"repeat_in_body", label %"repeat_in_end"
repeat_in_body:
  %"tdone.1" = load i64, i64* %"tdone"
  %".35" = icmp eq i64 %"tdone.1", 0
  br i1 %".35", label %"when_body_0.1", label %"merge.1"
repeat_in_end:
  %"tmp.2" = load i8*, i8** %"tmp"
  %".63" = call i64 @"strlen"(i8* %"tmp.2")
  %"tlen" = alloca i64, align 16
  store i64 %".63", i64* %"tlen"
  %"tlen.1" = load i64, i64* %"tlen"
  %".65" = sub i64 %"tlen.1", 1
  %"ti" = alloca i64, align 16
  store i64 %".65", i64* %"ti"
  %"rdone" = alloca i64, align 16
  store i64 0, i64* %"rdone"
  %"rloop" = alloca i64, align 16
  store i64 0, i64* %"rloop"
  br label %"repeat_in_check.1"
merge.1:
  %"tloop.2" = load i64, i64* %"tloop"
  %".60" = add i64 %"tloop.2", 1
  store i64 %".60", i64* %"tloop"
  br label %"repeat_in_check"
when_body_0.1:
  %"i.1" = load i64, i64* %"i"
  %".37" = icmp sle i64 %"i.1", 0
  br i1 %".37", label %"when_body_0.2", label %"otherwise"
merge.2:
  br label %"merge.1"
when_body_0.2:
  store i64 1, i64* %"tdone"
  br label %"merge.2"
otherwise:
  %"i.2" = load i64, i64* %"i"
  %".41" = sdiv i64 %"i.2", 10
  %"d" = alloca i64, align 16
  store i64 %".41", i64* %"d"
  %"d.1" = load i64, i64* %"d"
  %".43" = mul i64 %"d.1", 10
  %"d.2" = alloca i64, align 16
  store i64 %".43", i64* %"d.2"
  %"i.3" = load i64, i64* %"i"
  %"d.3" = load i64, i64* %"d.2"
  %".45" = sub i64 %"i.3", %"d.3"
  %"d.4" = alloca i64, align 16
  store i64 %".45", i64* %"d.4"
  %"d.5" = load i64, i64* %"d.4"
  %".47" = add i64 %"d.5", 48
  %"d.6" = alloca i64, align 16
  store i64 %".47", i64* %"d.6"
  %"tmp.1" = load i8*, i8** %"tmp"
  %"d.7" = load i64, i64* %"d.6"
  %".49" = call i64 @"strlen"(i8* %"tmp.1")
  %".50" = getelementptr i8, i8* %"tmp.1", i64 %".49"
  %".51" = trunc i64 %"d.7" to i8
  store i8 %".51", i8* %".50"
  %".53" = add i64 %".49", 1
  %".54" = getelementptr i8, i8* %"tmp.1", i64 %".53"
  store i8 0, i8* %".54"
  %"i.4" = load i64, i64* %"i"
  %".56" = sdiv i64 %"i.4", 10
  store i64 %".56", i64* %"i"
  br label %"merge.2"
repeat_in_check.1:
  %"rloop.1" = load i64, i64* %"rloop"
  %".70" = icmp slt i64 %"rloop.1", 20
  br i1 %".70", label %"repeat_in_body.1", label %"repeat_in_end.1"
repeat_in_body.1:
  %"rdone.1" = load i64, i64* %"rdone"
  %".72" = icmp eq i64 %"rdone.1", 0
  br i1 %".72", label %"when_body_0.3", label %"merge.3"
repeat_in_end.1:
  %"buf.3" = load i8*, i8** %"buf"
  ret i8* %"buf.3"
merge.3:
  %"rloop.2" = load i64, i64* %"rloop"
  %".92" = add i64 %"rloop.2", 1
  store i64 %".92", i64* %"rloop"
  br label %"repeat_in_check.1"
when_body_0.3:
  %"ti.1" = load i64, i64* %"ti"
  %".74" = icmp slt i64 %"ti.1", 0
  br i1 %".74", label %"when_body_0.4", label %"otherwise.1"
merge.4:
  br label %"merge.3"
when_body_0.4:
  store i64 1, i64* %"rdone"
  br label %"merge.4"
otherwise.1:
  %"buf.2" = load i8*, i8** %"buf"
  %"tmp.3" = load i8*, i8** %"tmp"
  %"ti.2" = load i64, i64* %"ti"
  %".78" = getelementptr i8, i8* %"tmp.3", i64 %"ti.2"
  %".79" = load i8, i8* %".78"
  %".80" = zext i8 %".79" to i64
  %".81" = call i64 @"strlen"(i8* %"buf.2")
  %".82" = getelementptr i8, i8* %"buf.2", i64 %".81"
  %".83" = trunc i64 %".80" to i8
  store i8 %".83", i8* %".82"
  %".85" = add i64 %".81", 1
  %".86" = getelementptr i8, i8* %"buf.2", i64 %".85"
  store i8 0, i8* %".86"
  %"ti.3" = load i64, i64* %"ti"
  %".88" = sub i64 %"ti.3", 1
  store i64 %".88", i64* %"ti"
  br label %"merge.4"
}

define i32 @"main"()
{
entry:
  %".2" = call i8* @"malloc"(i64 1048576)
  store i8* %".2", i8** @"ayas_arena_buf"
  store i64 0, i64* @"ayas_arena_offset"
  %".5" = bitcast [15 x i8]* @"str_lit_0" to i8*
  %".6" = bitcast [3 x i8]* @"str_mode_r" to i8*
  %".7" = call i8* @"fopen"(i8* %".5", i8* %".6")
  %".8" = icmp eq i8* %".7", null
  br i1 %".8", label %"open_fail", label %"open_ok"
open_fail:
  %".10" = bitcast [34 x i8]* @"str_open_fail" to i8*
  %".11" = call i32 (i8*, ...) @"printf"(i8* %".10")
  %".12" = call i32 @"fflush"(i8* null)
  ret i32 1
open_ok:
  %".14" = call i32 @"fseek"(i8* %".7", i64 0, i32 2)
  %".15" = call i64 @"ftell"(i8* %".7")
  %".16" = call i32 @"fseek"(i8* %".7", i64 0, i32 0)
  %".17" = add i64 %".15", 1
  %".18" = call i8* @"malloc"(i64 %".17")
  %".19" = call i64 @"fread"(i8* %".18", i64 1, i64 %".15", i8* %".7")
  %".20" = getelementptr i8, i8* %".18", i64 %".15"
  store i8 0, i8* %".20"
  %"source" = alloca i8*, align 16
  store i8* %".18", i8** %"source"
  %"source.1" = load i8*, i8** %"source"
  %".23" = call i64 @"strlen"(i8* %"source.1")
  %"length" = alloca i64, align 16
  store i64 %".23", i64* %"length"
  %"pos" = alloca i64, align 16
  store i64 0, i64* %"pos"
  %"line" = alloca i64, align 16
  store i64 1, i64* %"line"
  %"CH_NEWLINE" = alloca i64, align 16
  store i64 10, i64* %"CH_NEWLINE"
  %"CH_SPACE" = alloca i64, align 16
  store i64 32, i64* %"CH_SPACE"
  %"CH_TAB" = alloca i64, align 16
  store i64 9, i64* %"CH_TAB"
  %"CH_CR" = alloca i64, align 16
  store i64 13, i64* %"CH_CR"
  %"CH_0" = alloca i64, align 16
  store i64 48, i64* %"CH_0"
  %"CH_9" = alloca i64, align 16
  store i64 57, i64* %"CH_9"
  %"CH_a" = alloca i64, align 16
  store i64 97, i64* %"CH_a"
  %"CH_z" = alloca i64, align 16
  store i64 122, i64* %"CH_z"
  %"CH_A" = alloca i64, align 16
  store i64 65, i64* %"CH_A"
  %"CH_Z" = alloca i64, align 16
  store i64 90, i64* %"CH_Z"
  %"CH_UNDER" = alloca i64, align 16
  store i64 95, i64* %"CH_UNDER"
  %"CH_QUOTE" = alloca i64, align 16
  store i64 34, i64* %"CH_QUOTE"
  %"CH_SLASH" = alloca i64, align 16
  store i64 47, i64* %"CH_SLASH"
  %"CH_PLUS" = alloca i64, align 16
  store i64 43, i64* %"CH_PLUS"
  %"CH_MINUS" = alloca i64, align 16
  store i64 45, i64* %"CH_MINUS"
  %"CH_STAR" = alloca i64, align 16
  store i64 42, i64* %"CH_STAR"
  %"CH_LBRACKET" = alloca i64, align 16
  store i64 91, i64* %"CH_LBRACKET"
  %"CH_RBRACKET" = alloca i64, align 16
  store i64 93, i64* %"CH_RBRACKET"
  %"CH_LBRACE" = alloca i64, align 16
  store i64 123, i64* %"CH_LBRACE"
  %"CH_RBRACE" = alloca i64, align 16
  store i64 125, i64* %"CH_RBRACE"
  %"CH_LPAREN" = alloca i64, align 16
  store i64 40, i64* %"CH_LPAREN"
  %"CH_RPAREN" = alloca i64, align 16
  store i64 41, i64* %"CH_RPAREN"
  %"CH_COMMA" = alloca i64, align 16
  store i64 44, i64* %"CH_COMMA"
  %"CH_COLON" = alloca i64, align 16
  store i64 58, i64* %"CH_COLON"
  %"CH_DOT" = alloca i64, align 16
  store i64 46, i64* %"CH_DOT"
  %"CH_GT" = alloca i64, align 16
  store i64 62, i64* %"CH_GT"
  %"CH_LT" = alloca i64, align 16
  store i64 60, i64* %"CH_LT"
  %"CH_EQ" = alloca i64, align 16
  store i64 61, i64* %"CH_EQ"
  %"outer" = alloca i64, align 16
  store i64 0, i64* %"outer"
  %"length.1" = load i64, i64* %"length"
  br label %"repeat_in_check"
repeat_in_check:
  %"outer.1" = load i64, i64* %"outer"
  %".57" = icmp slt i64 %"outer.1", %"length.1"
  br i1 %".57", label %"repeat_in_body", label %"repeat_in_end"
repeat_in_body:
  %"pos.1" = load i64, i64* %"pos"
  %"length.2" = load i64, i64* %"length"
  %".59" = icmp sge i64 %"pos.1", %"length.2"
  br i1 %".59", label %"when_body_0", label %"otherwise"
repeat_in_end:
  %".1590" = bitcast [5 x i8]* @"str_lit_70" to i8*
  %"line.47" = load i64, i64* %"line"
  %".1591" = call i8* @"int_to_str"(i64 %"line.47")
  %".1592" = call i64 @"strlen"(i8* %".1590")
  %".1593" = call i64 @"strlen"(i8* %".1591")
  %".1594" = add i64 %".1592", %".1593"
  %".1595" = add i64 %".1594", 1
  %".1596" = load i64, i64* @"ayas_arena_offset"
  %".1597" = load i8*, i8** @"ayas_arena_buf"
  %".1598" = add i64 %".1596", %".1595"
  store i64 %".1598", i64* @"ayas_arena_offset"
  %".1600" = getelementptr i8, i8* %".1597", i64 %".1596"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1600", i8* %".1590", i64 %".1592", i1 0)
  %".1602" = getelementptr i8, i8* %".1600", i64 %".1592"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1602", i8* %".1591", i64 %".1593", i1 0)
  %".1604" = add i64 %".1592", %".1593"
  %".1605" = getelementptr i8, i8* %".1600", i64 %".1604"
  store i8 0, i8* %".1605"
  %".1607" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1608" = call i32 (i8*, ...) @"printf"(i8* %".1607", i8* %".1600")
  %".1609" = call i32 @"fflush"(i8* null)
  %".1610" = load i8*, i8** @"ayas_arena_buf"
  call void @"free"(i8* %".1610")
  ret i32 0
merge:
  %"outer.2" = load i64, i64* %"outer"
  %".1587" = add i64 %"outer.2", 1
  store i64 %".1587", i64* %"outer"
  br label %"repeat_in_check"
when_body_0:
  br label %"merge"
otherwise:
  %"source.2" = load i8*, i8** %"source"
  %"pos.2" = load i64, i64* %"pos"
  %".62" = getelementptr i8, i8* %"source.2", i64 %"pos.2"
  %".63" = load i8, i8* %".62"
  %".64" = zext i8 %".63" to i64
  %"c" = alloca i64, align 16
  store i64 %".64", i64* %"c"
  %"c.1" = load i64, i64* %"c"
  %".66" = icmp eq i64 %"c.1", 32
  %"c.2" = load i64, i64* %"c"
  %".67" = icmp eq i64 %"c.2", 9
  %".68" = or i1 %".66", %".67"
  %"c.3" = load i64, i64* %"c"
  %".69" = icmp eq i64 %"c.3", 13
  %".70" = or i1 %".68", %".69"
  br i1 %".70", label %"when_body_0.1", label %"when_check_1"
merge.1:
  br label %"merge"
when_body_0.1:
  %"pos.3" = load i64, i64* %"pos"
  %".72" = add i64 %"pos.3", 1
  store i64 %".72", i64* %"pos"
  br label %"merge.1"
when_check_1:
  %"c.4" = load i64, i64* %"c"
  %".75" = icmp eq i64 %"c.4", 10
  br i1 %".75", label %"when_body_1", label %"when_check_2"
when_body_1:
  %".77" = bitcast [13 x i8]* @"str_lit_1" to i8*
  %"line.1" = load i64, i64* %"line"
  %".78" = call i8* @"int_to_str"(i64 %"line.1")
  %".79" = call i64 @"strlen"(i8* %".77")
  %".80" = call i64 @"strlen"(i8* %".78")
  %".81" = add i64 %".79", %".80"
  %".82" = add i64 %".81", 1
  %".83" = load i64, i64* @"ayas_arena_offset"
  %".84" = load i8*, i8** @"ayas_arena_buf"
  %".85" = add i64 %".83", %".82"
  store i64 %".85", i64* @"ayas_arena_offset"
  %".87" = getelementptr i8, i8* %".84", i64 %".83"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".87", i8* %".77", i64 %".79", i1 0)
  %".89" = getelementptr i8, i8* %".87", i64 %".79"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".89", i8* %".78", i64 %".80", i1 0)
  %".91" = add i64 %".79", %".80"
  %".92" = getelementptr i8, i8* %".87", i64 %".91"
  store i8 0, i8* %".92"
  %".94" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".95" = call i32 (i8*, ...) @"printf"(i8* %".94", i8* %".87")
  %".96" = call i32 @"fflush"(i8* null)
  %"line.2" = load i64, i64* %"line"
  %".97" = add i64 %"line.2", 1
  store i64 %".97", i64* %"line"
  %"pos.4" = load i64, i64* %"pos"
  %".99" = add i64 %"pos.4", 1
  store i64 %".99", i64* %"pos"
  br label %"merge.1"
when_check_2:
  %"c.5" = load i64, i64* %"c"
  %".102" = icmp eq i64 %"c.5", 47
  br i1 %".102", label %"when_body_2", label %"when_check_3"
when_body_2:
  %"pos.5" = load i64, i64* %"pos"
  %".104" = add i64 %"pos.5", 1
  %"length.3" = load i64, i64* %"length"
  %".105" = icmp slt i64 %".104", %"length.3"
  %"source.3" = load i8*, i8** %"source"
  %"pos.6" = load i64, i64* %"pos"
  %".106" = add i64 %"pos.6", 1
  %".107" = getelementptr i8, i8* %"source.3", i64 %".106"
  %".108" = load i8, i8* %".107"
  %".109" = zext i8 %".108" to i64
  %".110" = icmp eq i64 %".109", 47
  %".111" = and i1 %".105", %".110"
  br i1 %".111", label %"when_body_0.2", label %"otherwise.1"
when_check_3:
  %"c.6" = load i64, i64* %"c"
  %".165" = icmp eq i64 %"c.6", 62
  br i1 %".165", label %"when_body_3", label %"when_check_4"
merge.2:
  br label %"merge.1"
when_body_0.2:
  %"pos.7" = load i64, i64* %"pos"
  %".113" = add i64 %"pos.7", 2
  store i64 %".113", i64* %"pos"
  %"cdone" = alloca i64, align 16
  store i64 0, i64* %"cdone"
  %"cskip" = alloca i64, align 16
  store i64 0, i64* %"cskip"
  %"length.4" = load i64, i64* %"length"
  br label %"repeat_in_check.1"
otherwise.1:
  %".141" = bitcast [5 x i8]* @"str_lit_2" to i8*
  %"line.3" = load i64, i64* %"line"
  %".142" = call i8* @"int_to_str"(i64 %"line.3")
  %".143" = call i64 @"strlen"(i8* %".141")
  %".144" = call i64 @"strlen"(i8* %".142")
  %".145" = add i64 %".143", %".144"
  %".146" = add i64 %".145", 1
  %".147" = load i64, i64* @"ayas_arena_offset"
  %".148" = load i8*, i8** @"ayas_arena_buf"
  %".149" = add i64 %".147", %".146"
  store i64 %".149", i64* @"ayas_arena_offset"
  %".151" = getelementptr i8, i8* %".148", i64 %".147"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".151", i8* %".141", i64 %".143", i1 0)
  %".153" = getelementptr i8, i8* %".151", i64 %".143"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".153", i8* %".142", i64 %".144", i1 0)
  %".155" = add i64 %".143", %".144"
  %".156" = getelementptr i8, i8* %".151", i64 %".155"
  store i8 0, i8* %".156"
  %".158" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".159" = call i32 (i8*, ...) @"printf"(i8* %".158", i8* %".151")
  %".160" = call i32 @"fflush"(i8* null)
  %"pos.11" = load i64, i64* %"pos"
  %".161" = add i64 %"pos.11", 1
  store i64 %".161", i64* %"pos"
  br label %"merge.2"
repeat_in_check.1:
  %"cskip.1" = load i64, i64* %"cskip"
  %".118" = icmp slt i64 %"cskip.1", %"length.4"
  br i1 %".118", label %"repeat_in_body.1", label %"repeat_in_end.1"
repeat_in_body.1:
  %"cdone.1" = load i64, i64* %"cdone"
  %".120" = icmp eq i64 %"cdone.1", 0
  br i1 %".120", label %"when_body_0.3", label %"merge.3"
repeat_in_end.1:
  br label %"merge.2"
merge.3:
  %"cskip.2" = load i64, i64* %"cskip"
  %".137" = add i64 %"cskip.2", 1
  store i64 %".137", i64* %"cskip"
  br label %"repeat_in_check.1"
when_body_0.3:
  %"pos.8" = load i64, i64* %"pos"
  %"length.5" = load i64, i64* %"length"
  %".122" = icmp sge i64 %"pos.8", %"length.5"
  br i1 %".122", label %"when_body_0.4", label %"when_check_1.1"
merge.4:
  br label %"merge.3"
when_body_0.4:
  store i64 1, i64* %"cdone"
  br label %"merge.4"
when_check_1.1:
  %"source.4" = load i8*, i8** %"source"
  %"pos.9" = load i64, i64* %"pos"
  %".126" = getelementptr i8, i8* %"source.4", i64 %"pos.9"
  %".127" = load i8, i8* %".126"
  %".128" = zext i8 %".127" to i64
  %".129" = icmp eq i64 %".128", 10
  br i1 %".129", label %"when_body_1.1", label %"otherwise.2"
when_body_1.1:
  store i64 1, i64* %"cdone"
  br label %"merge.4"
otherwise.2:
  %"pos.10" = load i64, i64* %"pos"
  %".133" = add i64 %"pos.10", 1
  store i64 %".133", i64* %"pos"
  br label %"merge.4"
when_body_3:
  %"pos.12" = load i64, i64* %"pos"
  %".167" = add i64 %"pos.12", 1
  %"length.6" = load i64, i64* %"length"
  %".168" = icmp slt i64 %".167", %"length.6"
  %"source.5" = load i8*, i8** %"source"
  %"pos.13" = load i64, i64* %"pos"
  %".169" = add i64 %"pos.13", 1
  %".170" = getelementptr i8, i8* %"source.5", i64 %".169"
  %".171" = load i8, i8* %".170"
  %".172" = zext i8 %".171" to i64
  %".173" = icmp eq i64 %".172", 61
  %".174" = and i1 %".168", %".173"
  br i1 %".174", label %"when_body_0.5", label %"otherwise.3"
when_check_4:
  %"c.7" = load i64, i64* %"c"
  %".223" = icmp eq i64 %"c.7", 60
  br i1 %".223", label %"when_body_4", label %"when_check_5"
merge.5:
  br label %"merge.1"
when_body_0.5:
  %".176" = bitcast [7 x i8]* @"str_lit_3" to i8*
  %"line.4" = load i64, i64* %"line"
  %".177" = call i8* @"int_to_str"(i64 %"line.4")
  %".178" = call i64 @"strlen"(i8* %".176")
  %".179" = call i64 @"strlen"(i8* %".177")
  %".180" = add i64 %".178", %".179"
  %".181" = add i64 %".180", 1
  %".182" = load i64, i64* @"ayas_arena_offset"
  %".183" = load i8*, i8** @"ayas_arena_buf"
  %".184" = add i64 %".182", %".181"
  store i64 %".184", i64* @"ayas_arena_offset"
  %".186" = getelementptr i8, i8* %".183", i64 %".182"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".186", i8* %".176", i64 %".178", i1 0)
  %".188" = getelementptr i8, i8* %".186", i64 %".178"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".188", i8* %".177", i64 %".179", i1 0)
  %".190" = add i64 %".178", %".179"
  %".191" = getelementptr i8, i8* %".186", i64 %".190"
  store i8 0, i8* %".191"
  %".193" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".194" = call i32 (i8*, ...) @"printf"(i8* %".193", i8* %".186")
  %".195" = call i32 @"fflush"(i8* null)
  %"pos.14" = load i64, i64* %"pos"
  %".196" = add i64 %"pos.14", 2
  store i64 %".196", i64* %"pos"
  br label %"merge.5"
otherwise.3:
  %".199" = bitcast [5 x i8]* @"str_lit_4" to i8*
  %"line.5" = load i64, i64* %"line"
  %".200" = call i8* @"int_to_str"(i64 %"line.5")
  %".201" = call i64 @"strlen"(i8* %".199")
  %".202" = call i64 @"strlen"(i8* %".200")
  %".203" = add i64 %".201", %".202"
  %".204" = add i64 %".203", 1
  %".205" = load i64, i64* @"ayas_arena_offset"
  %".206" = load i8*, i8** @"ayas_arena_buf"
  %".207" = add i64 %".205", %".204"
  store i64 %".207", i64* @"ayas_arena_offset"
  %".209" = getelementptr i8, i8* %".206", i64 %".205"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".209", i8* %".199", i64 %".201", i1 0)
  %".211" = getelementptr i8, i8* %".209", i64 %".201"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".211", i8* %".200", i64 %".202", i1 0)
  %".213" = add i64 %".201", %".202"
  %".214" = getelementptr i8, i8* %".209", i64 %".213"
  store i8 0, i8* %".214"
  %".216" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".217" = call i32 (i8*, ...) @"printf"(i8* %".216", i8* %".209")
  %".218" = call i32 @"fflush"(i8* null)
  %"pos.15" = load i64, i64* %"pos"
  %".219" = add i64 %"pos.15", 1
  store i64 %".219", i64* %"pos"
  br label %"merge.5"
when_body_4:
  %"pos.16" = load i64, i64* %"pos"
  %".225" = add i64 %"pos.16", 1
  %"length.7" = load i64, i64* %"length"
  %".226" = icmp slt i64 %".225", %"length.7"
  %"source.6" = load i8*, i8** %"source"
  %"pos.17" = load i64, i64* %"pos"
  %".227" = add i64 %"pos.17", 1
  %".228" = getelementptr i8, i8* %"source.6", i64 %".227"
  %".229" = load i8, i8* %".228"
  %".230" = zext i8 %".229" to i64
  %".231" = icmp eq i64 %".230", 61
  %".232" = and i1 %".226", %".231"
  br i1 %".232", label %"when_body_0.6", label %"otherwise.4"
when_check_5:
  %"c.8" = load i64, i64* %"c"
  %".281" = icmp eq i64 %"c.8", 34
  br i1 %".281", label %"when_body_5", label %"when_check_6"
merge.6:
  br label %"merge.1"
when_body_0.6:
  %".234" = bitcast [7 x i8]* @"str_lit_5" to i8*
  %"line.6" = load i64, i64* %"line"
  %".235" = call i8* @"int_to_str"(i64 %"line.6")
  %".236" = call i64 @"strlen"(i8* %".234")
  %".237" = call i64 @"strlen"(i8* %".235")
  %".238" = add i64 %".236", %".237"
  %".239" = add i64 %".238", 1
  %".240" = load i64, i64* @"ayas_arena_offset"
  %".241" = load i8*, i8** @"ayas_arena_buf"
  %".242" = add i64 %".240", %".239"
  store i64 %".242", i64* @"ayas_arena_offset"
  %".244" = getelementptr i8, i8* %".241", i64 %".240"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".244", i8* %".234", i64 %".236", i1 0)
  %".246" = getelementptr i8, i8* %".244", i64 %".236"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".246", i8* %".235", i64 %".237", i1 0)
  %".248" = add i64 %".236", %".237"
  %".249" = getelementptr i8, i8* %".244", i64 %".248"
  store i8 0, i8* %".249"
  %".251" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".252" = call i32 (i8*, ...) @"printf"(i8* %".251", i8* %".244")
  %".253" = call i32 @"fflush"(i8* null)
  %"pos.18" = load i64, i64* %"pos"
  %".254" = add i64 %"pos.18", 2
  store i64 %".254", i64* %"pos"
  br label %"merge.6"
otherwise.4:
  %".257" = bitcast [5 x i8]* @"str_lit_6" to i8*
  %"line.7" = load i64, i64* %"line"
  %".258" = call i8* @"int_to_str"(i64 %"line.7")
  %".259" = call i64 @"strlen"(i8* %".257")
  %".260" = call i64 @"strlen"(i8* %".258")
  %".261" = add i64 %".259", %".260"
  %".262" = add i64 %".261", 1
  %".263" = load i64, i64* @"ayas_arena_offset"
  %".264" = load i8*, i8** @"ayas_arena_buf"
  %".265" = add i64 %".263", %".262"
  store i64 %".265", i64* @"ayas_arena_offset"
  %".267" = getelementptr i8, i8* %".264", i64 %".263"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".267", i8* %".257", i64 %".259", i1 0)
  %".269" = getelementptr i8, i8* %".267", i64 %".259"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".269", i8* %".258", i64 %".260", i1 0)
  %".271" = add i64 %".259", %".260"
  %".272" = getelementptr i8, i8* %".267", i64 %".271"
  store i8 0, i8* %".272"
  %".274" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".275" = call i32 (i8*, ...) @"printf"(i8* %".274", i8* %".267")
  %".276" = call i32 @"fflush"(i8* null)
  %"pos.19" = load i64, i64* %"pos"
  %".277" = add i64 %"pos.19", 1
  store i64 %".277", i64* %"pos"
  br label %"merge.6"
when_body_5:
  %"pos.20" = load i64, i64* %"pos"
  %".283" = add i64 %"pos.20", 1
  store i64 %".283", i64* %"pos"
  %".285" = load i64, i64* @"ayas_arena_offset"
  %".286" = load i8*, i8** @"ayas_arena_buf"
  %".287" = add i64 %".285", 512
  store i64 %".287", i64* @"ayas_arena_offset"
  %".289" = getelementptr i8, i8* %".286", i64 %".285"
  store i8 0, i8* %".289"
  %"sbuf" = alloca i8*, align 16
  store i8* %".289", i8** %"sbuf"
  %"sdone" = alloca i64, align 16
  store i64 0, i64* %"sdone"
  %"sloop" = alloca i64, align 16
  store i64 0, i64* %"sloop"
  %"length.8" = load i64, i64* %"length"
  br label %"repeat_in_check.2"
when_check_6:
  %"c.9" = load i64, i64* %"c"
  %".383" = call i64 @"is_digit"(i64 %"c.9")
  %".384" = icmp ne i64 %".383", 0
  br i1 %".384", label %"when_body_6", label %"when_check_7"
repeat_in_check.2:
  %"sloop.1" = load i64, i64* %"sloop"
  %".295" = icmp slt i64 %"sloop.1", %"length.8"
  br i1 %".295", label %"repeat_in_body.2", label %"repeat_in_end.2"
repeat_in_body.2:
  %"sdone.1" = load i64, i64* %"sdone"
  %".297" = icmp eq i64 %"sdone.1", 0
  br i1 %".297", label %"when_body_0.7", label %"merge.7"
repeat_in_end.2:
  %".331" = bitcast [8 x i8]* @"str_lit_7" to i8*
  %"sbuf.2" = load i8*, i8** %"sbuf"
  %".332" = call i64 @"strlen"(i8* %".331")
  %".333" = call i64 @"strlen"(i8* %"sbuf.2")
  %".334" = add i64 %".332", %".333"
  %".335" = add i64 %".334", 1
  %".336" = load i64, i64* @"ayas_arena_offset"
  %".337" = load i8*, i8** @"ayas_arena_buf"
  %".338" = add i64 %".336", %".335"
  store i64 %".338", i64* @"ayas_arena_offset"
  %".340" = getelementptr i8, i8* %".337", i64 %".336"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".340", i8* %".331", i64 %".332", i1 0)
  %".342" = getelementptr i8, i8* %".340", i64 %".332"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".342", i8* %"sbuf.2", i64 %".333", i1 0)
  %".344" = add i64 %".332", %".333"
  %".345" = getelementptr i8, i8* %".340", i64 %".344"
  store i8 0, i8* %".345"
  %".347" = bitcast [2 x i8]* @"str_lit_8" to i8*
  %".348" = call i64 @"strlen"(i8* %".340")
  %".349" = call i64 @"strlen"(i8* %".347")
  %".350" = add i64 %".348", %".349"
  %".351" = add i64 %".350", 1
  %".352" = load i64, i64* @"ayas_arena_offset"
  %".353" = load i8*, i8** @"ayas_arena_buf"
  %".354" = add i64 %".352", %".351"
  store i64 %".354", i64* @"ayas_arena_offset"
  %".356" = getelementptr i8, i8* %".353", i64 %".352"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".356", i8* %".340", i64 %".348", i1 0)
  %".358" = getelementptr i8, i8* %".356", i64 %".348"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".358", i8* %".347", i64 %".349", i1 0)
  %".360" = add i64 %".348", %".349"
  %".361" = getelementptr i8, i8* %".356", i64 %".360"
  store i8 0, i8* %".361"
  %"line.8" = load i64, i64* %"line"
  %".363" = call i8* @"int_to_str"(i64 %"line.8")
  %".364" = call i64 @"strlen"(i8* %".356")
  %".365" = call i64 @"strlen"(i8* %".363")
  %".366" = add i64 %".364", %".365"
  %".367" = add i64 %".366", 1
  %".368" = load i64, i64* @"ayas_arena_offset"
  %".369" = load i8*, i8** @"ayas_arena_buf"
  %".370" = add i64 %".368", %".367"
  store i64 %".370", i64* @"ayas_arena_offset"
  %".372" = getelementptr i8, i8* %".369", i64 %".368"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".372", i8* %".356", i64 %".364", i1 0)
  %".374" = getelementptr i8, i8* %".372", i64 %".364"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".374", i8* %".363", i64 %".365", i1 0)
  %".376" = add i64 %".364", %".365"
  %".377" = getelementptr i8, i8* %".372", i64 %".376"
  store i8 0, i8* %".377"
  %".379" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".380" = call i32 (i8*, ...) @"printf"(i8* %".379", i8* %".372")
  %".381" = call i32 @"fflush"(i8* null)
  br label %"merge.1"
merge.7:
  %"sloop.2" = load i64, i64* %"sloop"
  %".328" = add i64 %"sloop.2", 1
  store i64 %".328", i64* %"sloop"
  br label %"repeat_in_check.2"
when_body_0.7:
  %"pos.21" = load i64, i64* %"pos"
  %"length.9" = load i64, i64* %"length"
  %".299" = icmp sge i64 %"pos.21", %"length.9"
  br i1 %".299", label %"when_body_0.8", label %"when_check_1.2"
merge.8:
  br label %"merge.7"
when_body_0.8:
  %".301" = bitcast [54 x i8]* @"str_fail_172" to i8*
  %".302" = call i32 (i8*, ...) @"printf"(i8* %".301")
  %".303" = call i32 @"fflush"(i8* null)
  ret i32 1
when_check_1.2:
  %"source.7" = load i8*, i8** %"source"
  %"pos.22" = load i64, i64* %"pos"
  %".305" = getelementptr i8, i8* %"source.7", i64 %"pos.22"
  %".306" = load i8, i8* %".305"
  %".307" = zext i8 %".306" to i64
  %".308" = icmp eq i64 %".307", 34
  br i1 %".308", label %"when_body_1.2", label %"otherwise.5"
when_body_1.2:
  %"pos.23" = load i64, i64* %"pos"
  %".310" = add i64 %"pos.23", 1
  store i64 %".310", i64* %"pos"
  store i64 1, i64* %"sdone"
  br label %"merge.8"
otherwise.5:
  %"sbuf.1" = load i8*, i8** %"sbuf"
  %"source.8" = load i8*, i8** %"source"
  %"pos.24" = load i64, i64* %"pos"
  %".314" = getelementptr i8, i8* %"source.8", i64 %"pos.24"
  %".315" = load i8, i8* %".314"
  %".316" = zext i8 %".315" to i64
  %".317" = call i64 @"strlen"(i8* %"sbuf.1")
  %".318" = getelementptr i8, i8* %"sbuf.1", i64 %".317"
  %".319" = trunc i64 %".316" to i8
  store i8 %".319", i8* %".318"
  %".321" = add i64 %".317", 1
  %".322" = getelementptr i8, i8* %"sbuf.1", i64 %".321"
  store i8 0, i8* %".322"
  %"pos.25" = load i64, i64* %"pos"
  %".324" = add i64 %"pos.25", 1
  store i64 %".324", i64* %"pos"
  br label %"merge.8"
when_body_6:
  %".386" = load i64, i64* @"ayas_arena_offset"
  %".387" = load i8*, i8** @"ayas_arena_buf"
  %".388" = add i64 %".386", 64
  store i64 %".388", i64* @"ayas_arena_offset"
  %".390" = getelementptr i8, i8* %".387", i64 %".386"
  store i8 0, i8* %".390"
  %"nbuf" = alloca i8*, align 16
  store i8* %".390", i8** %"nbuf"
  %"is_f" = alloca i64, align 16
  store i64 0, i64* %"is_f"
  %"ndone" = alloca i64, align 16
  store i64 0, i64* %"ndone"
  %"nloop" = alloca i64, align 16
  store i64 0, i64* %"nloop"
  %"length.10" = load i64, i64* %"length"
  br label %"repeat_in_check.3"
when_check_7:
  %"c.10" = load i64, i64* %"c"
  %".563" = call i64 @"is_alpha"(i64 %"c.10")
  %".564" = icmp ne i64 %".563", 0
  br i1 %".564", label %"when_body_7", label %"when_check_8"
repeat_in_check.3:
  %"nloop.1" = load i64, i64* %"nloop"
  %".397" = icmp slt i64 %"nloop.1", %"length.10"
  br i1 %".397", label %"repeat_in_body.3", label %"repeat_in_end.3"
repeat_in_body.3:
  %"ndone.1" = load i64, i64* %"ndone"
  %".399" = icmp eq i64 %"ndone.1", 0
  br i1 %".399", label %"when_body_0.9", label %"merge.9"
repeat_in_end.3:
  %"is_f.1" = load i64, i64* %"is_f"
  %".456" = icmp eq i64 %"is_f.1", 1
  br i1 %".456", label %"when_body_0.11", label %"otherwise.7"
merge.9:
  %"nloop.2" = load i64, i64* %"nloop"
  %".453" = add i64 %"nloop.2", 1
  store i64 %".453", i64* %"nloop"
  br label %"repeat_in_check.3"
when_body_0.9:
  %"pos.26" = load i64, i64* %"pos"
  %"length.11" = load i64, i64* %"length"
  %".401" = icmp sge i64 %"pos.26", %"length.11"
  br i1 %".401", label %"when_body_0.10", label %"when_check_1.3"
merge.10:
  br label %"merge.9"
when_body_0.10:
  store i64 1, i64* %"ndone"
  br label %"merge.10"
when_check_1.3:
  %"source.9" = load i8*, i8** %"source"
  %"pos.27" = load i64, i64* %"pos"
  %".405" = getelementptr i8, i8* %"source.9", i64 %"pos.27"
  %".406" = load i8, i8* %".405"
  %".407" = zext i8 %".406" to i64
  %".408" = call i64 @"is_digit"(i64 %".407")
  %".409" = icmp ne i64 %".408", 0
  br i1 %".409", label %"when_body_1.3", label %"when_check_2.1"
when_body_1.3:
  %"nbuf.1" = load i8*, i8** %"nbuf"
  %"source.10" = load i8*, i8** %"source"
  %"pos.28" = load i64, i64* %"pos"
  %".411" = getelementptr i8, i8* %"source.10", i64 %"pos.28"
  %".412" = load i8, i8* %".411"
  %".413" = zext i8 %".412" to i64
  %".414" = call i64 @"strlen"(i8* %"nbuf.1")
  %".415" = getelementptr i8, i8* %"nbuf.1", i64 %".414"
  %".416" = trunc i64 %".413" to i8
  store i8 %".416", i8* %".415"
  %".418" = add i64 %".414", 1
  %".419" = getelementptr i8, i8* %"nbuf.1", i64 %".418"
  store i8 0, i8* %".419"
  %"pos.29" = load i64, i64* %"pos"
  %".421" = add i64 %"pos.29", 1
  store i64 %".421", i64* %"pos"
  br label %"merge.10"
when_check_2.1:
  %"source.11" = load i8*, i8** %"source"
  %"pos.30" = load i64, i64* %"pos"
  %".424" = getelementptr i8, i8* %"source.11", i64 %"pos.30"
  %".425" = load i8, i8* %".424"
  %".426" = zext i8 %".425" to i64
  %".427" = icmp eq i64 %".426", 46
  %"pos.31" = load i64, i64* %"pos"
  %".428" = add i64 %"pos.31", 1
  %"length.12" = load i64, i64* %"length"
  %".429" = icmp slt i64 %".428", %"length.12"
  %".430" = and i1 %".427", %".429"
  %"source.12" = load i8*, i8** %"source"
  %"pos.32" = load i64, i64* %"pos"
  %".431" = add i64 %"pos.32", 1
  %".432" = getelementptr i8, i8* %"source.12", i64 %".431"
  %".433" = load i8, i8* %".432"
  %".434" = zext i8 %".433" to i64
  %".435" = call i64 @"is_digit"(i64 %".434")
  %".436" = icmp ne i64 %".435", 0
  %".437" = and i1 %".430", %".436"
  br i1 %".437", label %"when_body_2.1", label %"otherwise.6"
when_body_2.1:
  store i64 1, i64* %"is_f"
  %"nbuf.2" = load i8*, i8** %"nbuf"
  %".440" = call i64 @"strlen"(i8* %"nbuf.2")
  %".441" = getelementptr i8, i8* %"nbuf.2", i64 %".440"
  %".442" = trunc i64 46 to i8
  store i8 %".442", i8* %".441"
  %".444" = add i64 %".440", 1
  %".445" = getelementptr i8, i8* %"nbuf.2", i64 %".444"
  store i8 0, i8* %".445"
  %"pos.33" = load i64, i64* %"pos"
  %".447" = add i64 %"pos.33", 1
  store i64 %".447", i64* %"pos"
  br label %"merge.10"
otherwise.6:
  store i64 1, i64* %"ndone"
  br label %"merge.10"
merge.11:
  br label %"merge.1"
when_body_0.11:
  %".458" = bitcast [7 x i8]* @"str_lit_9" to i8*
  %"nbuf.3" = load i8*, i8** %"nbuf"
  %".459" = call i64 @"strlen"(i8* %".458")
  %".460" = call i64 @"strlen"(i8* %"nbuf.3")
  %".461" = add i64 %".459", %".460"
  %".462" = add i64 %".461", 1
  %".463" = load i64, i64* @"ayas_arena_offset"
  %".464" = load i8*, i8** @"ayas_arena_buf"
  %".465" = add i64 %".463", %".462"
  store i64 %".465", i64* @"ayas_arena_offset"
  %".467" = getelementptr i8, i8* %".464", i64 %".463"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".467", i8* %".458", i64 %".459", i1 0)
  %".469" = getelementptr i8, i8* %".467", i64 %".459"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".469", i8* %"nbuf.3", i64 %".460", i1 0)
  %".471" = add i64 %".459", %".460"
  %".472" = getelementptr i8, i8* %".467", i64 %".471"
  store i8 0, i8* %".472"
  %".474" = bitcast [2 x i8]* @"str_lit_8" to i8*
  %".475" = call i64 @"strlen"(i8* %".467")
  %".476" = call i64 @"strlen"(i8* %".474")
  %".477" = add i64 %".475", %".476"
  %".478" = add i64 %".477", 1
  %".479" = load i64, i64* @"ayas_arena_offset"
  %".480" = load i8*, i8** @"ayas_arena_buf"
  %".481" = add i64 %".479", %".478"
  store i64 %".481", i64* @"ayas_arena_offset"
  %".483" = getelementptr i8, i8* %".480", i64 %".479"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".483", i8* %".467", i64 %".475", i1 0)
  %".485" = getelementptr i8, i8* %".483", i64 %".475"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".485", i8* %".474", i64 %".476", i1 0)
  %".487" = add i64 %".475", %".476"
  %".488" = getelementptr i8, i8* %".483", i64 %".487"
  store i8 0, i8* %".488"
  %"line.9" = load i64, i64* %"line"
  %".490" = call i8* @"int_to_str"(i64 %"line.9")
  %".491" = call i64 @"strlen"(i8* %".483")
  %".492" = call i64 @"strlen"(i8* %".490")
  %".493" = add i64 %".491", %".492"
  %".494" = add i64 %".493", 1
  %".495" = load i64, i64* @"ayas_arena_offset"
  %".496" = load i8*, i8** @"ayas_arena_buf"
  %".497" = add i64 %".495", %".494"
  store i64 %".497", i64* @"ayas_arena_offset"
  %".499" = getelementptr i8, i8* %".496", i64 %".495"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".499", i8* %".483", i64 %".491", i1 0)
  %".501" = getelementptr i8, i8* %".499", i64 %".491"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".501", i8* %".490", i64 %".492", i1 0)
  %".503" = add i64 %".491", %".492"
  %".504" = getelementptr i8, i8* %".499", i64 %".503"
  store i8 0, i8* %".504"
  %".506" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".507" = call i32 (i8*, ...) @"printf"(i8* %".506", i8* %".499")
  %".508" = call i32 @"fflush"(i8* null)
  br label %"merge.11"
otherwise.7:
  %".510" = bitcast [8 x i8]* @"str_lit_10" to i8*
  %"nbuf.4" = load i8*, i8** %"nbuf"
  %".511" = call i64 @"strlen"(i8* %".510")
  %".512" = call i64 @"strlen"(i8* %"nbuf.4")
  %".513" = add i64 %".511", %".512"
  %".514" = add i64 %".513", 1
  %".515" = load i64, i64* @"ayas_arena_offset"
  %".516" = load i8*, i8** @"ayas_arena_buf"
  %".517" = add i64 %".515", %".514"
  store i64 %".517", i64* @"ayas_arena_offset"
  %".519" = getelementptr i8, i8* %".516", i64 %".515"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".519", i8* %".510", i64 %".511", i1 0)
  %".521" = getelementptr i8, i8* %".519", i64 %".511"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".521", i8* %"nbuf.4", i64 %".512", i1 0)
  %".523" = add i64 %".511", %".512"
  %".524" = getelementptr i8, i8* %".519", i64 %".523"
  store i8 0, i8* %".524"
  %".526" = bitcast [2 x i8]* @"str_lit_8" to i8*
  %".527" = call i64 @"strlen"(i8* %".519")
  %".528" = call i64 @"strlen"(i8* %".526")
  %".529" = add i64 %".527", %".528"
  %".530" = add i64 %".529", 1
  %".531" = load i64, i64* @"ayas_arena_offset"
  %".532" = load i8*, i8** @"ayas_arena_buf"
  %".533" = add i64 %".531", %".530"
  store i64 %".533", i64* @"ayas_arena_offset"
  %".535" = getelementptr i8, i8* %".532", i64 %".531"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".535", i8* %".519", i64 %".527", i1 0)
  %".537" = getelementptr i8, i8* %".535", i64 %".527"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".537", i8* %".526", i64 %".528", i1 0)
  %".539" = add i64 %".527", %".528"
  %".540" = getelementptr i8, i8* %".535", i64 %".539"
  store i8 0, i8* %".540"
  %"line.10" = load i64, i64* %"line"
  %".542" = call i8* @"int_to_str"(i64 %"line.10")
  %".543" = call i64 @"strlen"(i8* %".535")
  %".544" = call i64 @"strlen"(i8* %".542")
  %".545" = add i64 %".543", %".544"
  %".546" = add i64 %".545", 1
  %".547" = load i64, i64* @"ayas_arena_offset"
  %".548" = load i8*, i8** @"ayas_arena_buf"
  %".549" = add i64 %".547", %".546"
  store i64 %".549", i64* @"ayas_arena_offset"
  %".551" = getelementptr i8, i8* %".548", i64 %".547"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".551", i8* %".535", i64 %".543", i1 0)
  %".553" = getelementptr i8, i8* %".551", i64 %".543"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".553", i8* %".542", i64 %".544", i1 0)
  %".555" = add i64 %".543", %".544"
  %".556" = getelementptr i8, i8* %".551", i64 %".555"
  store i8 0, i8* %".556"
  %".558" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".559" = call i32 (i8*, ...) @"printf"(i8* %".558", i8* %".551")
  %".560" = call i32 @"fflush"(i8* null)
  br label %"merge.11"
when_body_7:
  %".566" = load i64, i64* @"ayas_arena_offset"
  %".567" = load i8*, i8** @"ayas_arena_buf"
  %".568" = add i64 %".566", 128
  store i64 %".568", i64* @"ayas_arena_offset"
  %".570" = getelementptr i8, i8* %".567", i64 %".566"
  store i8 0, i8* %".570"
  %"wbuf" = alloca i8*, align 16
  store i8* %".570", i8** %"wbuf"
  %"wdone" = alloca i64, align 16
  store i64 0, i64* %"wdone"
  %"wloop" = alloca i64, align 16
  store i64 0, i64* %"wloop"
  %"length.13" = load i64, i64* %"length"
  br label %"repeat_in_check.4"
when_check_8:
  %"c.11" = load i64, i64* %"c"
  %".1283" = icmp eq i64 %"c.11", 43
  br i1 %".1283", label %"when_body_8.1", label %"when_check_9.1"
repeat_in_check.4:
  %"wloop.1" = load i64, i64* %"wloop"
  %".576" = icmp slt i64 %"wloop.1", %"length.13"
  br i1 %".576", label %"repeat_in_body.4", label %"repeat_in_end.4"
repeat_in_body.4:
  %"wdone.1" = load i64, i64* %"wdone"
  %".578" = icmp eq i64 %"wdone.1", 0
  br i1 %".578", label %"when_body_0.12", label %"merge.12"
repeat_in_end.4:
  %"wbuf.2" = load i8*, i8** %"wbuf"
  %".609" = bitcast [4 x i8]* @"str_lit_11" to i8*
  %".610" = call i32 @"strcmp"(i8* %"wbuf.2", i8* %".609")
  %".611" = icmp eq i32 %".610", 0
  %".612" = zext i1 %".611" to i64
  %".613" = icmp ne i64 %".612", 0
  br i1 %".613", label %"when_body_0.14", label %"when_check_1.5"
merge.12:
  %"wloop.2" = load i64, i64* %"wloop"
  %".606" = add i64 %"wloop.2", 1
  store i64 %".606", i64* %"wloop"
  br label %"repeat_in_check.4"
when_body_0.12:
  %"pos.34" = load i64, i64* %"pos"
  %"length.14" = load i64, i64* %"length"
  %".580" = icmp sge i64 %"pos.34", %"length.14"
  br i1 %".580", label %"when_body_0.13", label %"when_check_1.4"
merge.13:
  br label %"merge.12"
when_body_0.13:
  store i64 1, i64* %"wdone"
  br label %"merge.13"
when_check_1.4:
  %"source.13" = load i8*, i8** %"source"
  %"pos.35" = load i64, i64* %"pos"
  %".584" = getelementptr i8, i8* %"source.13", i64 %"pos.35"
  %".585" = load i8, i8* %".584"
  %".586" = zext i8 %".585" to i64
  %".587" = call i64 @"is_alnum"(i64 %".586")
  %".588" = icmp ne i64 %".587", 0
  br i1 %".588", label %"when_body_1.4", label %"otherwise.8"
when_body_1.4:
  %"wbuf.1" = load i8*, i8** %"wbuf"
  %"source.14" = load i8*, i8** %"source"
  %"pos.36" = load i64, i64* %"pos"
  %".590" = getelementptr i8, i8* %"source.14", i64 %"pos.36"
  %".591" = load i8, i8* %".590"
  %".592" = zext i8 %".591" to i64
  %".593" = call i64 @"strlen"(i8* %"wbuf.1")
  %".594" = getelementptr i8, i8* %"wbuf.1", i64 %".593"
  %".595" = trunc i64 %".592" to i8
  store i8 %".595", i8* %".594"
  %".597" = add i64 %".593", 1
  %".598" = getelementptr i8, i8* %"wbuf.1", i64 %".597"
  store i8 0, i8* %".598"
  %"pos.37" = load i64, i64* %"pos"
  %".600" = add i64 %"pos.37", 1
  store i64 %".600", i64* %"pos"
  br label %"merge.13"
otherwise.8:
  store i64 1, i64* %"wdone"
  br label %"merge.13"
merge.14:
  br label %"merge.1"
when_body_0.14:
  %".615" = bitcast [9 x i8]* @"str_lit_12" to i8*
  %"line.11" = load i64, i64* %"line"
  %".616" = call i8* @"int_to_str"(i64 %"line.11")
  %".617" = call i64 @"strlen"(i8* %".615")
  %".618" = call i64 @"strlen"(i8* %".616")
  %".619" = add i64 %".617", %".618"
  %".620" = add i64 %".619", 1
  %".621" = load i64, i64* @"ayas_arena_offset"
  %".622" = load i8*, i8** @"ayas_arena_buf"
  %".623" = add i64 %".621", %".620"
  store i64 %".623", i64* @"ayas_arena_offset"
  %".625" = getelementptr i8, i8* %".622", i64 %".621"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".625", i8* %".615", i64 %".617", i1 0)
  %".627" = getelementptr i8, i8* %".625", i64 %".617"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".627", i8* %".616", i64 %".618", i1 0)
  %".629" = add i64 %".617", %".618"
  %".630" = getelementptr i8, i8* %".625", i64 %".629"
  store i8 0, i8* %".630"
  %".632" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".633" = call i32 (i8*, ...) @"printf"(i8* %".632", i8* %".625")
  %".634" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_1.5:
  %"wbuf.3" = load i8*, i8** %"wbuf"
  %".636" = bitcast [3 x i8]* @"str_lit_13" to i8*
  %".637" = call i32 @"strcmp"(i8* %"wbuf.3", i8* %".636")
  %".638" = icmp eq i32 %".637", 0
  %".639" = zext i1 %".638" to i64
  %".640" = icmp ne i64 %".639", 0
  br i1 %".640", label %"when_body_1.5", label %"when_check_2.2"
when_body_1.5:
  %".642" = bitcast [7 x i8]* @"str_lit_14" to i8*
  %"line.12" = load i64, i64* %"line"
  %".643" = call i8* @"int_to_str"(i64 %"line.12")
  %".644" = call i64 @"strlen"(i8* %".642")
  %".645" = call i64 @"strlen"(i8* %".643")
  %".646" = add i64 %".644", %".645"
  %".647" = add i64 %".646", 1
  %".648" = load i64, i64* @"ayas_arena_offset"
  %".649" = load i8*, i8** @"ayas_arena_buf"
  %".650" = add i64 %".648", %".647"
  store i64 %".650", i64* @"ayas_arena_offset"
  %".652" = getelementptr i8, i8* %".649", i64 %".648"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".652", i8* %".642", i64 %".644", i1 0)
  %".654" = getelementptr i8, i8* %".652", i64 %".644"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".654", i8* %".643", i64 %".645", i1 0)
  %".656" = add i64 %".644", %".645"
  %".657" = getelementptr i8, i8* %".652", i64 %".656"
  store i8 0, i8* %".657"
  %".659" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".660" = call i32 (i8*, ...) @"printf"(i8* %".659", i8* %".652")
  %".661" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_2.2:
  %"wbuf.4" = load i8*, i8** %"wbuf"
  %".663" = bitcast [4 x i8]* @"str_lit_15" to i8*
  %".664" = call i32 @"strcmp"(i8* %"wbuf.4", i8* %".663")
  %".665" = icmp eq i32 %".664", 0
  %".666" = zext i1 %".665" to i64
  %".667" = icmp ne i64 %".666", 0
  br i1 %".667", label %"when_body_2.2", label %"when_check_3.1"
when_body_2.2:
  %".669" = bitcast [9 x i8]* @"str_lit_16" to i8*
  %"line.13" = load i64, i64* %"line"
  %".670" = call i8* @"int_to_str"(i64 %"line.13")
  %".671" = call i64 @"strlen"(i8* %".669")
  %".672" = call i64 @"strlen"(i8* %".670")
  %".673" = add i64 %".671", %".672"
  %".674" = add i64 %".673", 1
  %".675" = load i64, i64* @"ayas_arena_offset"
  %".676" = load i8*, i8** @"ayas_arena_buf"
  %".677" = add i64 %".675", %".674"
  store i64 %".677", i64* @"ayas_arena_offset"
  %".679" = getelementptr i8, i8* %".676", i64 %".675"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".679", i8* %".669", i64 %".671", i1 0)
  %".681" = getelementptr i8, i8* %".679", i64 %".671"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".681", i8* %".670", i64 %".672", i1 0)
  %".683" = add i64 %".671", %".672"
  %".684" = getelementptr i8, i8* %".679", i64 %".683"
  store i8 0, i8* %".684"
  %".686" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".687" = call i32 (i8*, ...) @"printf"(i8* %".686", i8* %".679")
  %".688" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_3.1:
  %"wbuf.5" = load i8*, i8** %"wbuf"
  %".690" = bitcast [6 x i8]* @"str_lit_17" to i8*
  %".691" = call i32 @"strcmp"(i8* %"wbuf.5", i8* %".690")
  %".692" = icmp eq i32 %".691", 0
  %".693" = zext i1 %".692" to i64
  %".694" = icmp ne i64 %".693", 0
  br i1 %".694", label %"when_body_3.1", label %"when_check_4.1"
when_body_3.1:
  %".696" = bitcast [13 x i8]* @"str_lit_18" to i8*
  %"line.14" = load i64, i64* %"line"
  %".697" = call i8* @"int_to_str"(i64 %"line.14")
  %".698" = call i64 @"strlen"(i8* %".696")
  %".699" = call i64 @"strlen"(i8* %".697")
  %".700" = add i64 %".698", %".699"
  %".701" = add i64 %".700", 1
  %".702" = load i64, i64* @"ayas_arena_offset"
  %".703" = load i8*, i8** @"ayas_arena_buf"
  %".704" = add i64 %".702", %".701"
  store i64 %".704", i64* @"ayas_arena_offset"
  %".706" = getelementptr i8, i8* %".703", i64 %".702"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".706", i8* %".696", i64 %".698", i1 0)
  %".708" = getelementptr i8, i8* %".706", i64 %".698"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".708", i8* %".697", i64 %".699", i1 0)
  %".710" = add i64 %".698", %".699"
  %".711" = getelementptr i8, i8* %".706", i64 %".710"
  store i8 0, i8* %".711"
  %".713" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".714" = call i32 (i8*, ...) @"printf"(i8* %".713", i8* %".706")
  %".715" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_4.1:
  %"wbuf.6" = load i8*, i8** %"wbuf"
  %".717" = bitcast [5 x i8]* @"str_lit_19" to i8*
  %".718" = call i32 @"strcmp"(i8* %"wbuf.6", i8* %".717")
  %".719" = icmp eq i32 %".718", 0
  %".720" = zext i1 %".719" to i64
  %".721" = icmp ne i64 %".720", 0
  br i1 %".721", label %"when_body_4.1", label %"when_check_5.1"
when_body_4.1:
  %".723" = bitcast [11 x i8]* @"str_lit_20" to i8*
  %"line.15" = load i64, i64* %"line"
  %".724" = call i8* @"int_to_str"(i64 %"line.15")
  %".725" = call i64 @"strlen"(i8* %".723")
  %".726" = call i64 @"strlen"(i8* %".724")
  %".727" = add i64 %".725", %".726"
  %".728" = add i64 %".727", 1
  %".729" = load i64, i64* @"ayas_arena_offset"
  %".730" = load i8*, i8** @"ayas_arena_buf"
  %".731" = add i64 %".729", %".728"
  store i64 %".731", i64* @"ayas_arena_offset"
  %".733" = getelementptr i8, i8* %".730", i64 %".729"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".733", i8* %".723", i64 %".725", i1 0)
  %".735" = getelementptr i8, i8* %".733", i64 %".725"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".735", i8* %".724", i64 %".726", i1 0)
  %".737" = add i64 %".725", %".726"
  %".738" = getelementptr i8, i8* %".733", i64 %".737"
  store i8 0, i8* %".738"
  %".740" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".741" = call i32 (i8*, ...) @"printf"(i8* %".740", i8* %".733")
  %".742" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_5.1:
  %"wbuf.7" = load i8*, i8** %"wbuf"
  %".744" = bitcast [7 x i8]* @"str_lit_21" to i8*
  %".745" = call i32 @"strcmp"(i8* %"wbuf.7", i8* %".744")
  %".746" = icmp eq i32 %".745", 0
  %".747" = zext i1 %".746" to i64
  %".748" = icmp ne i64 %".747", 0
  br i1 %".748", label %"when_body_5.1", label %"when_check_6.1"
when_body_5.1:
  %".750" = bitcast [15 x i8]* @"str_lit_22" to i8*
  %"line.16" = load i64, i64* %"line"
  %".751" = call i8* @"int_to_str"(i64 %"line.16")
  %".752" = call i64 @"strlen"(i8* %".750")
  %".753" = call i64 @"strlen"(i8* %".751")
  %".754" = add i64 %".752", %".753"
  %".755" = add i64 %".754", 1
  %".756" = load i64, i64* @"ayas_arena_offset"
  %".757" = load i8*, i8** @"ayas_arena_buf"
  %".758" = add i64 %".756", %".755"
  store i64 %".758", i64* @"ayas_arena_offset"
  %".760" = getelementptr i8, i8* %".757", i64 %".756"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".760", i8* %".750", i64 %".752", i1 0)
  %".762" = getelementptr i8, i8* %".760", i64 %".752"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".762", i8* %".751", i64 %".753", i1 0)
  %".764" = add i64 %".752", %".753"
  %".765" = getelementptr i8, i8* %".760", i64 %".764"
  store i8 0, i8* %".765"
  %".767" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".768" = call i32 (i8*, ...) @"printf"(i8* %".767", i8* %".760")
  %".769" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_6.1:
  %"wbuf.8" = load i8*, i8** %"wbuf"
  %".771" = bitcast [10 x i8]* @"str_lit_23" to i8*
  %".772" = call i32 @"strcmp"(i8* %"wbuf.8", i8* %".771")
  %".773" = icmp eq i32 %".772", 0
  %".774" = zext i1 %".773" to i64
  %".775" = icmp ne i64 %".774", 0
  br i1 %".775", label %"when_body_6.1", label %"when_check_7.1"
when_body_6.1:
  %".777" = bitcast [21 x i8]* @"str_lit_24" to i8*
  %"line.17" = load i64, i64* %"line"
  %".778" = call i8* @"int_to_str"(i64 %"line.17")
  %".779" = call i64 @"strlen"(i8* %".777")
  %".780" = call i64 @"strlen"(i8* %".778")
  %".781" = add i64 %".779", %".780"
  %".782" = add i64 %".781", 1
  %".783" = load i64, i64* @"ayas_arena_offset"
  %".784" = load i8*, i8** @"ayas_arena_buf"
  %".785" = add i64 %".783", %".782"
  store i64 %".785", i64* @"ayas_arena_offset"
  %".787" = getelementptr i8, i8* %".784", i64 %".783"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".787", i8* %".777", i64 %".779", i1 0)
  %".789" = getelementptr i8, i8* %".787", i64 %".779"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".789", i8* %".778", i64 %".780", i1 0)
  %".791" = add i64 %".779", %".780"
  %".792" = getelementptr i8, i8* %".787", i64 %".791"
  store i8 0, i8* %".792"
  %".794" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".795" = call i32 (i8*, ...) @"printf"(i8* %".794", i8* %".787")
  %".796" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_7.1:
  %"wbuf.9" = load i8*, i8** %"wbuf"
  %".798" = bitcast [7 x i8]* @"str_lit_25" to i8*
  %".799" = call i32 @"strcmp"(i8* %"wbuf.9", i8* %".798")
  %".800" = icmp eq i32 %".799", 0
  %".801" = zext i1 %".800" to i64
  %".802" = icmp ne i64 %".801", 0
  br i1 %".802", label %"when_body_7.1", label %"when_check_8.1"
when_body_7.1:
  %".804" = bitcast [15 x i8]* @"str_lit_26" to i8*
  %"line.18" = load i64, i64* %"line"
  %".805" = call i8* @"int_to_str"(i64 %"line.18")
  %".806" = call i64 @"strlen"(i8* %".804")
  %".807" = call i64 @"strlen"(i8* %".805")
  %".808" = add i64 %".806", %".807"
  %".809" = add i64 %".808", 1
  %".810" = load i64, i64* @"ayas_arena_offset"
  %".811" = load i8*, i8** @"ayas_arena_buf"
  %".812" = add i64 %".810", %".809"
  store i64 %".812", i64* @"ayas_arena_offset"
  %".814" = getelementptr i8, i8* %".811", i64 %".810"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".814", i8* %".804", i64 %".806", i1 0)
  %".816" = getelementptr i8, i8* %".814", i64 %".806"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".816", i8* %".805", i64 %".807", i1 0)
  %".818" = add i64 %".806", %".807"
  %".819" = getelementptr i8, i8* %".814", i64 %".818"
  store i8 0, i8* %".819"
  %".821" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".822" = call i32 (i8*, ...) @"printf"(i8* %".821", i8* %".814")
  %".823" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_8.1:
  %"wbuf.10" = load i8*, i8** %"wbuf"
  %".825" = bitcast [3 x i8]* @"str_lit_27" to i8*
  %".826" = call i32 @"strcmp"(i8* %"wbuf.10", i8* %".825")
  %".827" = icmp eq i32 %".826", 0
  %".828" = zext i1 %".827" to i64
  %".829" = icmp ne i64 %".828", 0
  br i1 %".829", label %"when_body_8", label %"when_check_9"
when_body_8:
  %".831" = bitcast [7 x i8]* @"str_lit_28" to i8*
  %"line.19" = load i64, i64* %"line"
  %".832" = call i8* @"int_to_str"(i64 %"line.19")
  %".833" = call i64 @"strlen"(i8* %".831")
  %".834" = call i64 @"strlen"(i8* %".832")
  %".835" = add i64 %".833", %".834"
  %".836" = add i64 %".835", 1
  %".837" = load i64, i64* @"ayas_arena_offset"
  %".838" = load i8*, i8** @"ayas_arena_buf"
  %".839" = add i64 %".837", %".836"
  store i64 %".839", i64* @"ayas_arena_offset"
  %".841" = getelementptr i8, i8* %".838", i64 %".837"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".841", i8* %".831", i64 %".833", i1 0)
  %".843" = getelementptr i8, i8* %".841", i64 %".833"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".843", i8* %".832", i64 %".834", i1 0)
  %".845" = add i64 %".833", %".834"
  %".846" = getelementptr i8, i8* %".841", i64 %".845"
  store i8 0, i8* %".846"
  %".848" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".849" = call i32 (i8*, ...) @"printf"(i8* %".848", i8* %".841")
  %".850" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_9:
  %"wbuf.11" = load i8*, i8** %"wbuf"
  %".852" = bitcast [3 x i8]* @"str_lit_29" to i8*
  %".853" = call i32 @"strcmp"(i8* %"wbuf.11", i8* %".852")
  %".854" = icmp eq i32 %".853", 0
  %".855" = zext i1 %".854" to i64
  %".856" = icmp ne i64 %".855", 0
  br i1 %".856", label %"when_body_9", label %"when_check_10"
when_body_9:
  %".858" = bitcast [7 x i8]* @"str_lit_30" to i8*
  %"line.20" = load i64, i64* %"line"
  %".859" = call i8* @"int_to_str"(i64 %"line.20")
  %".860" = call i64 @"strlen"(i8* %".858")
  %".861" = call i64 @"strlen"(i8* %".859")
  %".862" = add i64 %".860", %".861"
  %".863" = add i64 %".862", 1
  %".864" = load i64, i64* @"ayas_arena_offset"
  %".865" = load i8*, i8** @"ayas_arena_buf"
  %".866" = add i64 %".864", %".863"
  store i64 %".866", i64* @"ayas_arena_offset"
  %".868" = getelementptr i8, i8* %".865", i64 %".864"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".868", i8* %".858", i64 %".860", i1 0)
  %".870" = getelementptr i8, i8* %".868", i64 %".860"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".870", i8* %".859", i64 %".861", i1 0)
  %".872" = add i64 %".860", %".861"
  %".873" = getelementptr i8, i8* %".868", i64 %".872"
  store i8 0, i8* %".873"
  %".875" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".876" = call i32 (i8*, ...) @"printf"(i8* %".875", i8* %".868")
  %".877" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_10:
  %"wbuf.12" = load i8*, i8** %"wbuf"
  %".879" = bitcast [6 x i8]* @"str_lit_31" to i8*
  %".880" = call i32 @"strcmp"(i8* %"wbuf.12", i8* %".879")
  %".881" = icmp eq i32 %".880", 0
  %".882" = zext i1 %".881" to i64
  %".883" = icmp ne i64 %".882", 0
  br i1 %".883", label %"when_body_10", label %"when_check_11"
when_body_10:
  %".885" = bitcast [13 x i8]* @"str_lit_32" to i8*
  %"line.21" = load i64, i64* %"line"
  %".886" = call i8* @"int_to_str"(i64 %"line.21")
  %".887" = call i64 @"strlen"(i8* %".885")
  %".888" = call i64 @"strlen"(i8* %".886")
  %".889" = add i64 %".887", %".888"
  %".890" = add i64 %".889", 1
  %".891" = load i64, i64* @"ayas_arena_offset"
  %".892" = load i8*, i8** @"ayas_arena_buf"
  %".893" = add i64 %".891", %".890"
  store i64 %".893", i64* @"ayas_arena_offset"
  %".895" = getelementptr i8, i8* %".892", i64 %".891"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".895", i8* %".885", i64 %".887", i1 0)
  %".897" = getelementptr i8, i8* %".895", i64 %".887"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".897", i8* %".886", i64 %".888", i1 0)
  %".899" = add i64 %".887", %".888"
  %".900" = getelementptr i8, i8* %".895", i64 %".899"
  store i8 0, i8* %".900"
  %".902" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".903" = call i32 (i8*, ...) @"printf"(i8* %".902", i8* %".895")
  %".904" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_11:
  %"wbuf.13" = load i8*, i8** %"wbuf"
  %".906" = bitcast [5 x i8]* @"str_lit_33" to i8*
  %".907" = call i32 @"strcmp"(i8* %"wbuf.13", i8* %".906")
  %".908" = icmp eq i32 %".907", 0
  %".909" = zext i1 %".908" to i64
  %".910" = icmp ne i64 %".909", 0
  br i1 %".910", label %"when_body_11", label %"when_check_12"
when_body_11:
  %".912" = bitcast [11 x i8]* @"str_lit_34" to i8*
  %"line.22" = load i64, i64* %"line"
  %".913" = call i8* @"int_to_str"(i64 %"line.22")
  %".914" = call i64 @"strlen"(i8* %".912")
  %".915" = call i64 @"strlen"(i8* %".913")
  %".916" = add i64 %".914", %".915"
  %".917" = add i64 %".916", 1
  %".918" = load i64, i64* @"ayas_arena_offset"
  %".919" = load i8*, i8** @"ayas_arena_buf"
  %".920" = add i64 %".918", %".917"
  store i64 %".920", i64* @"ayas_arena_offset"
  %".922" = getelementptr i8, i8* %".919", i64 %".918"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".922", i8* %".912", i64 %".914", i1 0)
  %".924" = getelementptr i8, i8* %".922", i64 %".914"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".924", i8* %".913", i64 %".915", i1 0)
  %".926" = add i64 %".914", %".915"
  %".927" = getelementptr i8, i8* %".922", i64 %".926"
  store i8 0, i8* %".927"
  %".929" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".930" = call i32 (i8*, ...) @"printf"(i8* %".929", i8* %".922")
  %".931" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_12:
  %"wbuf.14" = load i8*, i8** %"wbuf"
  %".933" = bitcast [5 x i8]* @"str_lit_35" to i8*
  %".934" = call i32 @"strcmp"(i8* %"wbuf.14", i8* %".933")
  %".935" = icmp eq i32 %".934", 0
  %".936" = zext i1 %".935" to i64
  %".937" = icmp ne i64 %".936", 0
  br i1 %".937", label %"when_body_12", label %"when_check_13"
when_body_12:
  %".939" = bitcast [11 x i8]* @"str_lit_36" to i8*
  %"line.23" = load i64, i64* %"line"
  %".940" = call i8* @"int_to_str"(i64 %"line.23")
  %".941" = call i64 @"strlen"(i8* %".939")
  %".942" = call i64 @"strlen"(i8* %".940")
  %".943" = add i64 %".941", %".942"
  %".944" = add i64 %".943", 1
  %".945" = load i64, i64* @"ayas_arena_offset"
  %".946" = load i8*, i8** @"ayas_arena_buf"
  %".947" = add i64 %".945", %".944"
  store i64 %".947", i64* @"ayas_arena_offset"
  %".949" = getelementptr i8, i8* %".946", i64 %".945"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".949", i8* %".939", i64 %".941", i1 0)
  %".951" = getelementptr i8, i8* %".949", i64 %".941"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".951", i8* %".940", i64 %".942", i1 0)
  %".953" = add i64 %".941", %".942"
  %".954" = getelementptr i8, i8* %".949", i64 %".953"
  store i8 0, i8* %".954"
  %".956" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".957" = call i32 (i8*, ...) @"printf"(i8* %".956", i8* %".949")
  %".958" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_13:
  %"wbuf.15" = load i8*, i8** %"wbuf"
  %".960" = bitcast [5 x i8]* @"str_lit_37" to i8*
  %".961" = call i32 @"strcmp"(i8* %"wbuf.15", i8* %".960")
  %".962" = icmp eq i32 %".961", 0
  %".963" = zext i1 %".962" to i64
  %".964" = icmp ne i64 %".963", 0
  br i1 %".964", label %"when_body_13", label %"when_check_14"
when_body_13:
  %".966" = bitcast [11 x i8]* @"str_lit_38" to i8*
  %"line.24" = load i64, i64* %"line"
  %".967" = call i8* @"int_to_str"(i64 %"line.24")
  %".968" = call i64 @"strlen"(i8* %".966")
  %".969" = call i64 @"strlen"(i8* %".967")
  %".970" = add i64 %".968", %".969"
  %".971" = add i64 %".970", 1
  %".972" = load i64, i64* @"ayas_arena_offset"
  %".973" = load i8*, i8** @"ayas_arena_buf"
  %".974" = add i64 %".972", %".971"
  store i64 %".974", i64* @"ayas_arena_offset"
  %".976" = getelementptr i8, i8* %".973", i64 %".972"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".976", i8* %".966", i64 %".968", i1 0)
  %".978" = getelementptr i8, i8* %".976", i64 %".968"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".978", i8* %".967", i64 %".969", i1 0)
  %".980" = add i64 %".968", %".969"
  %".981" = getelementptr i8, i8* %".976", i64 %".980"
  store i8 0, i8* %".981"
  %".983" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".984" = call i32 (i8*, ...) @"printf"(i8* %".983", i8* %".976")
  %".985" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_14:
  %"wbuf.16" = load i8*, i8** %"wbuf"
  %".987" = bitcast [5 x i8]* @"str_lit_39" to i8*
  %".988" = call i32 @"strcmp"(i8* %"wbuf.16", i8* %".987")
  %".989" = icmp eq i32 %".988", 0
  %".990" = zext i1 %".989" to i64
  %".991" = icmp ne i64 %".990", 0
  br i1 %".991", label %"when_body_14", label %"when_check_15"
when_body_14:
  %".993" = bitcast [11 x i8]* @"str_lit_40" to i8*
  %"line.25" = load i64, i64* %"line"
  %".994" = call i8* @"int_to_str"(i64 %"line.25")
  %".995" = call i64 @"strlen"(i8* %".993")
  %".996" = call i64 @"strlen"(i8* %".994")
  %".997" = add i64 %".995", %".996"
  %".998" = add i64 %".997", 1
  %".999" = load i64, i64* @"ayas_arena_offset"
  %".1000" = load i8*, i8** @"ayas_arena_buf"
  %".1001" = add i64 %".999", %".998"
  store i64 %".1001", i64* @"ayas_arena_offset"
  %".1003" = getelementptr i8, i8* %".1000", i64 %".999"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1003", i8* %".993", i64 %".995", i1 0)
  %".1005" = getelementptr i8, i8* %".1003", i64 %".995"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1005", i8* %".994", i64 %".996", i1 0)
  %".1007" = add i64 %".995", %".996"
  %".1008" = getelementptr i8, i8* %".1003", i64 %".1007"
  store i8 0, i8* %".1008"
  %".1010" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1011" = call i32 (i8*, ...) @"printf"(i8* %".1010", i8* %".1003")
  %".1012" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_15:
  %"wbuf.17" = load i8*, i8** %"wbuf"
  %".1014" = bitcast [3 x i8]* @"str_lit_41" to i8*
  %".1015" = call i32 @"strcmp"(i8* %"wbuf.17", i8* %".1014")
  %".1016" = icmp eq i32 %".1015", 0
  %".1017" = zext i1 %".1016" to i64
  %".1018" = icmp ne i64 %".1017", 0
  br i1 %".1018", label %"when_body_15", label %"when_check_16"
when_body_15:
  %".1020" = bitcast [7 x i8]* @"str_lit_42" to i8*
  %"line.26" = load i64, i64* %"line"
  %".1021" = call i8* @"int_to_str"(i64 %"line.26")
  %".1022" = call i64 @"strlen"(i8* %".1020")
  %".1023" = call i64 @"strlen"(i8* %".1021")
  %".1024" = add i64 %".1022", %".1023"
  %".1025" = add i64 %".1024", 1
  %".1026" = load i64, i64* @"ayas_arena_offset"
  %".1027" = load i8*, i8** @"ayas_arena_buf"
  %".1028" = add i64 %".1026", %".1025"
  store i64 %".1028", i64* @"ayas_arena_offset"
  %".1030" = getelementptr i8, i8* %".1027", i64 %".1026"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1030", i8* %".1020", i64 %".1022", i1 0)
  %".1032" = getelementptr i8, i8* %".1030", i64 %".1022"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1032", i8* %".1021", i64 %".1023", i1 0)
  %".1034" = add i64 %".1022", %".1023"
  %".1035" = getelementptr i8, i8* %".1030", i64 %".1034"
  store i8 0, i8* %".1035"
  %".1037" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1038" = call i32 (i8*, ...) @"printf"(i8* %".1037", i8* %".1030")
  %".1039" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_16:
  %"wbuf.18" = load i8*, i8** %"wbuf"
  %".1041" = bitcast [4 x i8]* @"str_lit_43" to i8*
  %".1042" = call i32 @"strcmp"(i8* %"wbuf.18", i8* %".1041")
  %".1043" = icmp eq i32 %".1042", 0
  %".1044" = zext i1 %".1043" to i64
  %".1045" = icmp ne i64 %".1044", 0
  br i1 %".1045", label %"when_body_16", label %"when_check_17"
when_body_16:
  %".1047" = bitcast [9 x i8]* @"str_lit_44" to i8*
  %"line.27" = load i64, i64* %"line"
  %".1048" = call i8* @"int_to_str"(i64 %"line.27")
  %".1049" = call i64 @"strlen"(i8* %".1047")
  %".1050" = call i64 @"strlen"(i8* %".1048")
  %".1051" = add i64 %".1049", %".1050"
  %".1052" = add i64 %".1051", 1
  %".1053" = load i64, i64* @"ayas_arena_offset"
  %".1054" = load i8*, i8** @"ayas_arena_buf"
  %".1055" = add i64 %".1053", %".1052"
  store i64 %".1055", i64* @"ayas_arena_offset"
  %".1057" = getelementptr i8, i8* %".1054", i64 %".1053"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1057", i8* %".1047", i64 %".1049", i1 0)
  %".1059" = getelementptr i8, i8* %".1057", i64 %".1049"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1059", i8* %".1048", i64 %".1050", i1 0)
  %".1061" = add i64 %".1049", %".1050"
  %".1062" = getelementptr i8, i8* %".1057", i64 %".1061"
  store i8 0, i8* %".1062"
  %".1064" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1065" = call i32 (i8*, ...) @"printf"(i8* %".1064", i8* %".1057")
  %".1066" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_17:
  %"wbuf.19" = load i8*, i8** %"wbuf"
  %".1068" = bitcast [4 x i8]* @"str_lit_45" to i8*
  %".1069" = call i32 @"strcmp"(i8* %"wbuf.19", i8* %".1068")
  %".1070" = icmp eq i32 %".1069", 0
  %".1071" = zext i1 %".1070" to i64
  %".1072" = icmp ne i64 %".1071", 0
  br i1 %".1072", label %"when_body_17", label %"when_check_18"
when_body_17:
  %".1074" = bitcast [9 x i8]* @"str_lit_46" to i8*
  %"line.28" = load i64, i64* %"line"
  %".1075" = call i8* @"int_to_str"(i64 %"line.28")
  %".1076" = call i64 @"strlen"(i8* %".1074")
  %".1077" = call i64 @"strlen"(i8* %".1075")
  %".1078" = add i64 %".1076", %".1077"
  %".1079" = add i64 %".1078", 1
  %".1080" = load i64, i64* @"ayas_arena_offset"
  %".1081" = load i8*, i8** @"ayas_arena_buf"
  %".1082" = add i64 %".1080", %".1079"
  store i64 %".1082", i64* @"ayas_arena_offset"
  %".1084" = getelementptr i8, i8* %".1081", i64 %".1080"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1084", i8* %".1074", i64 %".1076", i1 0)
  %".1086" = getelementptr i8, i8* %".1084", i64 %".1076"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1086", i8* %".1075", i64 %".1077", i1 0)
  %".1088" = add i64 %".1076", %".1077"
  %".1089" = getelementptr i8, i8* %".1084", i64 %".1088"
  store i8 0, i8* %".1089"
  %".1091" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1092" = call i32 (i8*, ...) @"printf"(i8* %".1091", i8* %".1084")
  %".1093" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_18:
  %"wbuf.20" = load i8*, i8** %"wbuf"
  %".1095" = bitcast [3 x i8]* @"str_lit_47" to i8*
  %".1096" = call i32 @"strcmp"(i8* %"wbuf.20", i8* %".1095")
  %".1097" = icmp eq i32 %".1096", 0
  %".1098" = zext i1 %".1097" to i64
  %".1099" = icmp ne i64 %".1098", 0
  br i1 %".1099", label %"when_body_18", label %"when_check_19"
when_body_18:
  %".1101" = bitcast [7 x i8]* @"str_lit_48" to i8*
  %"line.29" = load i64, i64* %"line"
  %".1102" = call i8* @"int_to_str"(i64 %"line.29")
  %".1103" = call i64 @"strlen"(i8* %".1101")
  %".1104" = call i64 @"strlen"(i8* %".1102")
  %".1105" = add i64 %".1103", %".1104"
  %".1106" = add i64 %".1105", 1
  %".1107" = load i64, i64* @"ayas_arena_offset"
  %".1108" = load i8*, i8** @"ayas_arena_buf"
  %".1109" = add i64 %".1107", %".1106"
  store i64 %".1109", i64* @"ayas_arena_offset"
  %".1111" = getelementptr i8, i8* %".1108", i64 %".1107"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1111", i8* %".1101", i64 %".1103", i1 0)
  %".1113" = getelementptr i8, i8* %".1111", i64 %".1103"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1113", i8* %".1102", i64 %".1104", i1 0)
  %".1115" = add i64 %".1103", %".1104"
  %".1116" = getelementptr i8, i8* %".1111", i64 %".1115"
  store i8 0, i8* %".1116"
  %".1118" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1119" = call i32 (i8*, ...) @"printf"(i8* %".1118", i8* %".1111")
  %".1120" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_19:
  %"wbuf.21" = load i8*, i8** %"wbuf"
  %".1122" = bitcast [6 x i8]* @"str_lit_49" to i8*
  %".1123" = call i32 @"strcmp"(i8* %"wbuf.21", i8* %".1122")
  %".1124" = icmp eq i32 %".1123", 0
  %".1125" = zext i1 %".1124" to i64
  %".1126" = icmp ne i64 %".1125", 0
  br i1 %".1126", label %"when_body_19", label %"when_check_20"
when_body_19:
  %".1128" = bitcast [13 x i8]* @"str_lit_50" to i8*
  %"line.30" = load i64, i64* %"line"
  %".1129" = call i8* @"int_to_str"(i64 %"line.30")
  %".1130" = call i64 @"strlen"(i8* %".1128")
  %".1131" = call i64 @"strlen"(i8* %".1129")
  %".1132" = add i64 %".1130", %".1131"
  %".1133" = add i64 %".1132", 1
  %".1134" = load i64, i64* @"ayas_arena_offset"
  %".1135" = load i8*, i8** @"ayas_arena_buf"
  %".1136" = add i64 %".1134", %".1133"
  store i64 %".1136", i64* @"ayas_arena_offset"
  %".1138" = getelementptr i8, i8* %".1135", i64 %".1134"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1138", i8* %".1128", i64 %".1130", i1 0)
  %".1140" = getelementptr i8, i8* %".1138", i64 %".1130"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1140", i8* %".1129", i64 %".1131", i1 0)
  %".1142" = add i64 %".1130", %".1131"
  %".1143" = getelementptr i8, i8* %".1138", i64 %".1142"
  store i8 0, i8* %".1143"
  %".1145" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1146" = call i32 (i8*, ...) @"printf"(i8* %".1145", i8* %".1138")
  %".1147" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_20:
  %"wbuf.22" = load i8*, i8** %"wbuf"
  %".1149" = bitcast [6 x i8]* @"str_lit_51" to i8*
  %".1150" = call i32 @"strcmp"(i8* %"wbuf.22", i8* %".1149")
  %".1151" = icmp eq i32 %".1150", 0
  %".1152" = zext i1 %".1151" to i64
  %".1153" = icmp ne i64 %".1152", 0
  br i1 %".1153", label %"when_body_20", label %"when_check_21"
when_body_20:
  %".1155" = bitcast [13 x i8]* @"str_lit_52" to i8*
  %"line.31" = load i64, i64* %"line"
  %".1156" = call i8* @"int_to_str"(i64 %"line.31")
  %".1157" = call i64 @"strlen"(i8* %".1155")
  %".1158" = call i64 @"strlen"(i8* %".1156")
  %".1159" = add i64 %".1157", %".1158"
  %".1160" = add i64 %".1159", 1
  %".1161" = load i64, i64* @"ayas_arena_offset"
  %".1162" = load i8*, i8** @"ayas_arena_buf"
  %".1163" = add i64 %".1161", %".1160"
  store i64 %".1163", i64* @"ayas_arena_offset"
  %".1165" = getelementptr i8, i8* %".1162", i64 %".1161"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1165", i8* %".1155", i64 %".1157", i1 0)
  %".1167" = getelementptr i8, i8* %".1165", i64 %".1157"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1167", i8* %".1156", i64 %".1158", i1 0)
  %".1169" = add i64 %".1157", %".1158"
  %".1170" = getelementptr i8, i8* %".1165", i64 %".1169"
  store i8 0, i8* %".1170"
  %".1172" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1173" = call i32 (i8*, ...) @"printf"(i8* %".1172", i8* %".1165")
  %".1174" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_21:
  %"wbuf.23" = load i8*, i8** %"wbuf"
  %".1176" = bitcast [5 x i8]* @"str_lit_53" to i8*
  %".1177" = call i32 @"strcmp"(i8* %"wbuf.23", i8* %".1176")
  %".1178" = icmp eq i32 %".1177", 0
  %".1179" = zext i1 %".1178" to i64
  %".1180" = icmp ne i64 %".1179", 0
  br i1 %".1180", label %"when_body_21", label %"when_check_22"
when_body_21:
  %".1182" = bitcast [11 x i8]* @"str_lit_54" to i8*
  %"line.32" = load i64, i64* %"line"
  %".1183" = call i8* @"int_to_str"(i64 %"line.32")
  %".1184" = call i64 @"strlen"(i8* %".1182")
  %".1185" = call i64 @"strlen"(i8* %".1183")
  %".1186" = add i64 %".1184", %".1185"
  %".1187" = add i64 %".1186", 1
  %".1188" = load i64, i64* @"ayas_arena_offset"
  %".1189" = load i8*, i8** @"ayas_arena_buf"
  %".1190" = add i64 %".1188", %".1187"
  store i64 %".1190", i64* @"ayas_arena_offset"
  %".1192" = getelementptr i8, i8* %".1189", i64 %".1188"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1192", i8* %".1182", i64 %".1184", i1 0)
  %".1194" = getelementptr i8, i8* %".1192", i64 %".1184"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1194", i8* %".1183", i64 %".1185", i1 0)
  %".1196" = add i64 %".1184", %".1185"
  %".1197" = getelementptr i8, i8* %".1192", i64 %".1196"
  store i8 0, i8* %".1197"
  %".1199" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1200" = call i32 (i8*, ...) @"printf"(i8* %".1199", i8* %".1192")
  %".1201" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_check_22:
  %"wbuf.24" = load i8*, i8** %"wbuf"
  %".1203" = bitcast [6 x i8]* @"str_lit_55" to i8*
  %".1204" = call i32 @"strcmp"(i8* %"wbuf.24", i8* %".1203")
  %".1205" = icmp eq i32 %".1204", 0
  %".1206" = zext i1 %".1205" to i64
  %".1207" = icmp ne i64 %".1206", 0
  br i1 %".1207", label %"when_body_22", label %"otherwise.9"
when_body_22:
  %".1209" = bitcast [12 x i8]* @"str_lit_56" to i8*
  %"line.33" = load i64, i64* %"line"
  %".1210" = call i8* @"int_to_str"(i64 %"line.33")
  %".1211" = call i64 @"strlen"(i8* %".1209")
  %".1212" = call i64 @"strlen"(i8* %".1210")
  %".1213" = add i64 %".1211", %".1212"
  %".1214" = add i64 %".1213", 1
  %".1215" = load i64, i64* @"ayas_arena_offset"
  %".1216" = load i8*, i8** @"ayas_arena_buf"
  %".1217" = add i64 %".1215", %".1214"
  store i64 %".1217", i64* @"ayas_arena_offset"
  %".1219" = getelementptr i8, i8* %".1216", i64 %".1215"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1219", i8* %".1209", i64 %".1211", i1 0)
  %".1221" = getelementptr i8, i8* %".1219", i64 %".1211"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1221", i8* %".1210", i64 %".1212", i1 0)
  %".1223" = add i64 %".1211", %".1212"
  %".1224" = getelementptr i8, i8* %".1219", i64 %".1223"
  store i8 0, i8* %".1224"
  %".1226" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1227" = call i32 (i8*, ...) @"printf"(i8* %".1226", i8* %".1219")
  %".1228" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
otherwise.9:
  %".1230" = bitcast [12 x i8]* @"str_lit_57" to i8*
  %"wbuf.25" = load i8*, i8** %"wbuf"
  %".1231" = call i64 @"strlen"(i8* %".1230")
  %".1232" = call i64 @"strlen"(i8* %"wbuf.25")
  %".1233" = add i64 %".1231", %".1232"
  %".1234" = add i64 %".1233", 1
  %".1235" = load i64, i64* @"ayas_arena_offset"
  %".1236" = load i8*, i8** @"ayas_arena_buf"
  %".1237" = add i64 %".1235", %".1234"
  store i64 %".1237", i64* @"ayas_arena_offset"
  %".1239" = getelementptr i8, i8* %".1236", i64 %".1235"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1239", i8* %".1230", i64 %".1231", i1 0)
  %".1241" = getelementptr i8, i8* %".1239", i64 %".1231"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1241", i8* %"wbuf.25", i64 %".1232", i1 0)
  %".1243" = add i64 %".1231", %".1232"
  %".1244" = getelementptr i8, i8* %".1239", i64 %".1243"
  store i8 0, i8* %".1244"
  %".1246" = bitcast [2 x i8]* @"str_lit_8" to i8*
  %".1247" = call i64 @"strlen"(i8* %".1239")
  %".1248" = call i64 @"strlen"(i8* %".1246")
  %".1249" = add i64 %".1247", %".1248"
  %".1250" = add i64 %".1249", 1
  %".1251" = load i64, i64* @"ayas_arena_offset"
  %".1252" = load i8*, i8** @"ayas_arena_buf"
  %".1253" = add i64 %".1251", %".1250"
  store i64 %".1253", i64* @"ayas_arena_offset"
  %".1255" = getelementptr i8, i8* %".1252", i64 %".1251"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1255", i8* %".1239", i64 %".1247", i1 0)
  %".1257" = getelementptr i8, i8* %".1255", i64 %".1247"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1257", i8* %".1246", i64 %".1248", i1 0)
  %".1259" = add i64 %".1247", %".1248"
  %".1260" = getelementptr i8, i8* %".1255", i64 %".1259"
  store i8 0, i8* %".1260"
  %"line.34" = load i64, i64* %"line"
  %".1262" = call i8* @"int_to_str"(i64 %"line.34")
  %".1263" = call i64 @"strlen"(i8* %".1255")
  %".1264" = call i64 @"strlen"(i8* %".1262")
  %".1265" = add i64 %".1263", %".1264"
  %".1266" = add i64 %".1265", 1
  %".1267" = load i64, i64* @"ayas_arena_offset"
  %".1268" = load i8*, i8** @"ayas_arena_buf"
  %".1269" = add i64 %".1267", %".1266"
  store i64 %".1269", i64* @"ayas_arena_offset"
  %".1271" = getelementptr i8, i8* %".1268", i64 %".1267"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1271", i8* %".1255", i64 %".1263", i1 0)
  %".1273" = getelementptr i8, i8* %".1271", i64 %".1263"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1273", i8* %".1262", i64 %".1264", i1 0)
  %".1275" = add i64 %".1263", %".1264"
  %".1276" = getelementptr i8, i8* %".1271", i64 %".1275"
  store i8 0, i8* %".1276"
  %".1278" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1279" = call i32 (i8*, ...) @"printf"(i8* %".1278", i8* %".1271")
  %".1280" = call i32 @"fflush"(i8* null)
  br label %"merge.14"
when_body_8.1:
  %".1285" = bitcast [5 x i8]* @"str_lit_58" to i8*
  %"line.35" = load i64, i64* %"line"
  %".1286" = call i8* @"int_to_str"(i64 %"line.35")
  %".1287" = call i64 @"strlen"(i8* %".1285")
  %".1288" = call i64 @"strlen"(i8* %".1286")
  %".1289" = add i64 %".1287", %".1288"
  %".1290" = add i64 %".1289", 1
  %".1291" = load i64, i64* @"ayas_arena_offset"
  %".1292" = load i8*, i8** @"ayas_arena_buf"
  %".1293" = add i64 %".1291", %".1290"
  store i64 %".1293", i64* @"ayas_arena_offset"
  %".1295" = getelementptr i8, i8* %".1292", i64 %".1291"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1295", i8* %".1285", i64 %".1287", i1 0)
  %".1297" = getelementptr i8, i8* %".1295", i64 %".1287"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1297", i8* %".1286", i64 %".1288", i1 0)
  %".1299" = add i64 %".1287", %".1288"
  %".1300" = getelementptr i8, i8* %".1295", i64 %".1299"
  store i8 0, i8* %".1300"
  %".1302" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1303" = call i32 (i8*, ...) @"printf"(i8* %".1302", i8* %".1295")
  %".1304" = call i32 @"fflush"(i8* null)
  %"pos.38" = load i64, i64* %"pos"
  %".1305" = add i64 %"pos.38", 1
  store i64 %".1305", i64* %"pos"
  br label %"merge.1"
when_check_9.1:
  %"c.12" = load i64, i64* %"c"
  %".1308" = icmp eq i64 %"c.12", 45
  br i1 %".1308", label %"when_body_9.1", label %"when_check_10.1"
when_body_9.1:
  %".1310" = bitcast [5 x i8]* @"str_lit_59" to i8*
  %"line.36" = load i64, i64* %"line"
  %".1311" = call i8* @"int_to_str"(i64 %"line.36")
  %".1312" = call i64 @"strlen"(i8* %".1310")
  %".1313" = call i64 @"strlen"(i8* %".1311")
  %".1314" = add i64 %".1312", %".1313"
  %".1315" = add i64 %".1314", 1
  %".1316" = load i64, i64* @"ayas_arena_offset"
  %".1317" = load i8*, i8** @"ayas_arena_buf"
  %".1318" = add i64 %".1316", %".1315"
  store i64 %".1318", i64* @"ayas_arena_offset"
  %".1320" = getelementptr i8, i8* %".1317", i64 %".1316"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1320", i8* %".1310", i64 %".1312", i1 0)
  %".1322" = getelementptr i8, i8* %".1320", i64 %".1312"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1322", i8* %".1311", i64 %".1313", i1 0)
  %".1324" = add i64 %".1312", %".1313"
  %".1325" = getelementptr i8, i8* %".1320", i64 %".1324"
  store i8 0, i8* %".1325"
  %".1327" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1328" = call i32 (i8*, ...) @"printf"(i8* %".1327", i8* %".1320")
  %".1329" = call i32 @"fflush"(i8* null)
  %"pos.39" = load i64, i64* %"pos"
  %".1330" = add i64 %"pos.39", 1
  store i64 %".1330", i64* %"pos"
  br label %"merge.1"
when_check_10.1:
  %"c.13" = load i64, i64* %"c"
  %".1333" = icmp eq i64 %"c.13", 42
  br i1 %".1333", label %"when_body_10.1", label %"when_check_11.1"
when_body_10.1:
  %".1335" = bitcast [5 x i8]* @"str_lit_60" to i8*
  %"line.37" = load i64, i64* %"line"
  %".1336" = call i8* @"int_to_str"(i64 %"line.37")
  %".1337" = call i64 @"strlen"(i8* %".1335")
  %".1338" = call i64 @"strlen"(i8* %".1336")
  %".1339" = add i64 %".1337", %".1338"
  %".1340" = add i64 %".1339", 1
  %".1341" = load i64, i64* @"ayas_arena_offset"
  %".1342" = load i8*, i8** @"ayas_arena_buf"
  %".1343" = add i64 %".1341", %".1340"
  store i64 %".1343", i64* @"ayas_arena_offset"
  %".1345" = getelementptr i8, i8* %".1342", i64 %".1341"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1345", i8* %".1335", i64 %".1337", i1 0)
  %".1347" = getelementptr i8, i8* %".1345", i64 %".1337"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1347", i8* %".1336", i64 %".1338", i1 0)
  %".1349" = add i64 %".1337", %".1338"
  %".1350" = getelementptr i8, i8* %".1345", i64 %".1349"
  store i8 0, i8* %".1350"
  %".1352" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1353" = call i32 (i8*, ...) @"printf"(i8* %".1352", i8* %".1345")
  %".1354" = call i32 @"fflush"(i8* null)
  %"pos.40" = load i64, i64* %"pos"
  %".1355" = add i64 %"pos.40", 1
  store i64 %".1355", i64* %"pos"
  br label %"merge.1"
when_check_11.1:
  %"c.14" = load i64, i64* %"c"
  %".1358" = icmp eq i64 %"c.14", 91
  br i1 %".1358", label %"when_body_11.1", label %"when_check_12.1"
when_body_11.1:
  %".1360" = bitcast [5 x i8]* @"str_lit_61" to i8*
  %"line.38" = load i64, i64* %"line"
  %".1361" = call i8* @"int_to_str"(i64 %"line.38")
  %".1362" = call i64 @"strlen"(i8* %".1360")
  %".1363" = call i64 @"strlen"(i8* %".1361")
  %".1364" = add i64 %".1362", %".1363"
  %".1365" = add i64 %".1364", 1
  %".1366" = load i64, i64* @"ayas_arena_offset"
  %".1367" = load i8*, i8** @"ayas_arena_buf"
  %".1368" = add i64 %".1366", %".1365"
  store i64 %".1368", i64* @"ayas_arena_offset"
  %".1370" = getelementptr i8, i8* %".1367", i64 %".1366"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1370", i8* %".1360", i64 %".1362", i1 0)
  %".1372" = getelementptr i8, i8* %".1370", i64 %".1362"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1372", i8* %".1361", i64 %".1363", i1 0)
  %".1374" = add i64 %".1362", %".1363"
  %".1375" = getelementptr i8, i8* %".1370", i64 %".1374"
  store i8 0, i8* %".1375"
  %".1377" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1378" = call i32 (i8*, ...) @"printf"(i8* %".1377", i8* %".1370")
  %".1379" = call i32 @"fflush"(i8* null)
  %"pos.41" = load i64, i64* %"pos"
  %".1380" = add i64 %"pos.41", 1
  store i64 %".1380", i64* %"pos"
  br label %"merge.1"
when_check_12.1:
  %"c.15" = load i64, i64* %"c"
  %".1383" = icmp eq i64 %"c.15", 93
  br i1 %".1383", label %"when_body_12.1", label %"when_check_13.1"
when_body_12.1:
  %".1385" = bitcast [5 x i8]* @"str_lit_62" to i8*
  %"line.39" = load i64, i64* %"line"
  %".1386" = call i8* @"int_to_str"(i64 %"line.39")
  %".1387" = call i64 @"strlen"(i8* %".1385")
  %".1388" = call i64 @"strlen"(i8* %".1386")
  %".1389" = add i64 %".1387", %".1388"
  %".1390" = add i64 %".1389", 1
  %".1391" = load i64, i64* @"ayas_arena_offset"
  %".1392" = load i8*, i8** @"ayas_arena_buf"
  %".1393" = add i64 %".1391", %".1390"
  store i64 %".1393", i64* @"ayas_arena_offset"
  %".1395" = getelementptr i8, i8* %".1392", i64 %".1391"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1395", i8* %".1385", i64 %".1387", i1 0)
  %".1397" = getelementptr i8, i8* %".1395", i64 %".1387"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1397", i8* %".1386", i64 %".1388", i1 0)
  %".1399" = add i64 %".1387", %".1388"
  %".1400" = getelementptr i8, i8* %".1395", i64 %".1399"
  store i8 0, i8* %".1400"
  %".1402" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1403" = call i32 (i8*, ...) @"printf"(i8* %".1402", i8* %".1395")
  %".1404" = call i32 @"fflush"(i8* null)
  %"pos.42" = load i64, i64* %"pos"
  %".1405" = add i64 %"pos.42", 1
  store i64 %".1405", i64* %"pos"
  br label %"merge.1"
when_check_13.1:
  %"c.16" = load i64, i64* %"c"
  %".1408" = icmp eq i64 %"c.16", 123
  br i1 %".1408", label %"when_body_13.1", label %"when_check_14.1"
when_body_13.1:
  %".1410" = bitcast [5 x i8]* @"str_lit_63" to i8*
  %"line.40" = load i64, i64* %"line"
  %".1411" = call i8* @"int_to_str"(i64 %"line.40")
  %".1412" = call i64 @"strlen"(i8* %".1410")
  %".1413" = call i64 @"strlen"(i8* %".1411")
  %".1414" = add i64 %".1412", %".1413"
  %".1415" = add i64 %".1414", 1
  %".1416" = load i64, i64* @"ayas_arena_offset"
  %".1417" = load i8*, i8** @"ayas_arena_buf"
  %".1418" = add i64 %".1416", %".1415"
  store i64 %".1418", i64* @"ayas_arena_offset"
  %".1420" = getelementptr i8, i8* %".1417", i64 %".1416"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1420", i8* %".1410", i64 %".1412", i1 0)
  %".1422" = getelementptr i8, i8* %".1420", i64 %".1412"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1422", i8* %".1411", i64 %".1413", i1 0)
  %".1424" = add i64 %".1412", %".1413"
  %".1425" = getelementptr i8, i8* %".1420", i64 %".1424"
  store i8 0, i8* %".1425"
  %".1427" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1428" = call i32 (i8*, ...) @"printf"(i8* %".1427", i8* %".1420")
  %".1429" = call i32 @"fflush"(i8* null)
  %"pos.43" = load i64, i64* %"pos"
  %".1430" = add i64 %"pos.43", 1
  store i64 %".1430", i64* %"pos"
  br label %"merge.1"
when_check_14.1:
  %"c.17" = load i64, i64* %"c"
  %".1433" = icmp eq i64 %"c.17", 125
  br i1 %".1433", label %"when_body_14.1", label %"when_check_15.1"
when_body_14.1:
  %".1435" = bitcast [5 x i8]* @"str_lit_64" to i8*
  %"line.41" = load i64, i64* %"line"
  %".1436" = call i8* @"int_to_str"(i64 %"line.41")
  %".1437" = call i64 @"strlen"(i8* %".1435")
  %".1438" = call i64 @"strlen"(i8* %".1436")
  %".1439" = add i64 %".1437", %".1438"
  %".1440" = add i64 %".1439", 1
  %".1441" = load i64, i64* @"ayas_arena_offset"
  %".1442" = load i8*, i8** @"ayas_arena_buf"
  %".1443" = add i64 %".1441", %".1440"
  store i64 %".1443", i64* @"ayas_arena_offset"
  %".1445" = getelementptr i8, i8* %".1442", i64 %".1441"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1445", i8* %".1435", i64 %".1437", i1 0)
  %".1447" = getelementptr i8, i8* %".1445", i64 %".1437"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1447", i8* %".1436", i64 %".1438", i1 0)
  %".1449" = add i64 %".1437", %".1438"
  %".1450" = getelementptr i8, i8* %".1445", i64 %".1449"
  store i8 0, i8* %".1450"
  %".1452" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1453" = call i32 (i8*, ...) @"printf"(i8* %".1452", i8* %".1445")
  %".1454" = call i32 @"fflush"(i8* null)
  %"pos.44" = load i64, i64* %"pos"
  %".1455" = add i64 %"pos.44", 1
  store i64 %".1455", i64* %"pos"
  br label %"merge.1"
when_check_15.1:
  %"c.18" = load i64, i64* %"c"
  %".1458" = icmp eq i64 %"c.18", 40
  br i1 %".1458", label %"when_body_15.1", label %"when_check_16.1"
when_body_15.1:
  %".1460" = bitcast [5 x i8]* @"str_lit_65" to i8*
  %"line.42" = load i64, i64* %"line"
  %".1461" = call i8* @"int_to_str"(i64 %"line.42")
  %".1462" = call i64 @"strlen"(i8* %".1460")
  %".1463" = call i64 @"strlen"(i8* %".1461")
  %".1464" = add i64 %".1462", %".1463"
  %".1465" = add i64 %".1464", 1
  %".1466" = load i64, i64* @"ayas_arena_offset"
  %".1467" = load i8*, i8** @"ayas_arena_buf"
  %".1468" = add i64 %".1466", %".1465"
  store i64 %".1468", i64* @"ayas_arena_offset"
  %".1470" = getelementptr i8, i8* %".1467", i64 %".1466"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1470", i8* %".1460", i64 %".1462", i1 0)
  %".1472" = getelementptr i8, i8* %".1470", i64 %".1462"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1472", i8* %".1461", i64 %".1463", i1 0)
  %".1474" = add i64 %".1462", %".1463"
  %".1475" = getelementptr i8, i8* %".1470", i64 %".1474"
  store i8 0, i8* %".1475"
  %".1477" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1478" = call i32 (i8*, ...) @"printf"(i8* %".1477", i8* %".1470")
  %".1479" = call i32 @"fflush"(i8* null)
  %"pos.45" = load i64, i64* %"pos"
  %".1480" = add i64 %"pos.45", 1
  store i64 %".1480", i64* %"pos"
  br label %"merge.1"
when_check_16.1:
  %"c.19" = load i64, i64* %"c"
  %".1483" = icmp eq i64 %"c.19", 41
  br i1 %".1483", label %"when_body_16.1", label %"when_check_17.1"
when_body_16.1:
  %".1485" = bitcast [5 x i8]* @"str_lit_66" to i8*
  %"line.43" = load i64, i64* %"line"
  %".1486" = call i8* @"int_to_str"(i64 %"line.43")
  %".1487" = call i64 @"strlen"(i8* %".1485")
  %".1488" = call i64 @"strlen"(i8* %".1486")
  %".1489" = add i64 %".1487", %".1488"
  %".1490" = add i64 %".1489", 1
  %".1491" = load i64, i64* @"ayas_arena_offset"
  %".1492" = load i8*, i8** @"ayas_arena_buf"
  %".1493" = add i64 %".1491", %".1490"
  store i64 %".1493", i64* @"ayas_arena_offset"
  %".1495" = getelementptr i8, i8* %".1492", i64 %".1491"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1495", i8* %".1485", i64 %".1487", i1 0)
  %".1497" = getelementptr i8, i8* %".1495", i64 %".1487"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1497", i8* %".1486", i64 %".1488", i1 0)
  %".1499" = add i64 %".1487", %".1488"
  %".1500" = getelementptr i8, i8* %".1495", i64 %".1499"
  store i8 0, i8* %".1500"
  %".1502" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1503" = call i32 (i8*, ...) @"printf"(i8* %".1502", i8* %".1495")
  %".1504" = call i32 @"fflush"(i8* null)
  %"pos.46" = load i64, i64* %"pos"
  %".1505" = add i64 %"pos.46", 1
  store i64 %".1505", i64* %"pos"
  br label %"merge.1"
when_check_17.1:
  %"c.20" = load i64, i64* %"c"
  %".1508" = icmp eq i64 %"c.20", 44
  br i1 %".1508", label %"when_body_17.1", label %"when_check_18.1"
when_body_17.1:
  %".1510" = bitcast [5 x i8]* @"str_lit_67" to i8*
  %"line.44" = load i64, i64* %"line"
  %".1511" = call i8* @"int_to_str"(i64 %"line.44")
  %".1512" = call i64 @"strlen"(i8* %".1510")
  %".1513" = call i64 @"strlen"(i8* %".1511")
  %".1514" = add i64 %".1512", %".1513"
  %".1515" = add i64 %".1514", 1
  %".1516" = load i64, i64* @"ayas_arena_offset"
  %".1517" = load i8*, i8** @"ayas_arena_buf"
  %".1518" = add i64 %".1516", %".1515"
  store i64 %".1518", i64* @"ayas_arena_offset"
  %".1520" = getelementptr i8, i8* %".1517", i64 %".1516"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1520", i8* %".1510", i64 %".1512", i1 0)
  %".1522" = getelementptr i8, i8* %".1520", i64 %".1512"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1522", i8* %".1511", i64 %".1513", i1 0)
  %".1524" = add i64 %".1512", %".1513"
  %".1525" = getelementptr i8, i8* %".1520", i64 %".1524"
  store i8 0, i8* %".1525"
  %".1527" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1528" = call i32 (i8*, ...) @"printf"(i8* %".1527", i8* %".1520")
  %".1529" = call i32 @"fflush"(i8* null)
  %"pos.47" = load i64, i64* %"pos"
  %".1530" = add i64 %"pos.47", 1
  store i64 %".1530", i64* %"pos"
  br label %"merge.1"
when_check_18.1:
  %"c.21" = load i64, i64* %"c"
  %".1533" = icmp eq i64 %"c.21", 58
  br i1 %".1533", label %"when_body_18.1", label %"when_check_19.1"
when_body_18.1:
  %".1535" = bitcast [5 x i8]* @"str_lit_68" to i8*
  %"line.45" = load i64, i64* %"line"
  %".1536" = call i8* @"int_to_str"(i64 %"line.45")
  %".1537" = call i64 @"strlen"(i8* %".1535")
  %".1538" = call i64 @"strlen"(i8* %".1536")
  %".1539" = add i64 %".1537", %".1538"
  %".1540" = add i64 %".1539", 1
  %".1541" = load i64, i64* @"ayas_arena_offset"
  %".1542" = load i8*, i8** @"ayas_arena_buf"
  %".1543" = add i64 %".1541", %".1540"
  store i64 %".1543", i64* @"ayas_arena_offset"
  %".1545" = getelementptr i8, i8* %".1542", i64 %".1541"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1545", i8* %".1535", i64 %".1537", i1 0)
  %".1547" = getelementptr i8, i8* %".1545", i64 %".1537"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1547", i8* %".1536", i64 %".1538", i1 0)
  %".1549" = add i64 %".1537", %".1538"
  %".1550" = getelementptr i8, i8* %".1545", i64 %".1549"
  store i8 0, i8* %".1550"
  %".1552" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1553" = call i32 (i8*, ...) @"printf"(i8* %".1552", i8* %".1545")
  %".1554" = call i32 @"fflush"(i8* null)
  %"pos.48" = load i64, i64* %"pos"
  %".1555" = add i64 %"pos.48", 1
  store i64 %".1555", i64* %"pos"
  br label %"merge.1"
when_check_19.1:
  %"c.22" = load i64, i64* %"c"
  %".1558" = icmp eq i64 %"c.22", 46
  br i1 %".1558", label %"when_body_19.1", label %"otherwise.10"
when_body_19.1:
  %".1560" = bitcast [5 x i8]* @"str_lit_69" to i8*
  %"line.46" = load i64, i64* %"line"
  %".1561" = call i8* @"int_to_str"(i64 %"line.46")
  %".1562" = call i64 @"strlen"(i8* %".1560")
  %".1563" = call i64 @"strlen"(i8* %".1561")
  %".1564" = add i64 %".1562", %".1563"
  %".1565" = add i64 %".1564", 1
  %".1566" = load i64, i64* @"ayas_arena_offset"
  %".1567" = load i8*, i8** @"ayas_arena_buf"
  %".1568" = add i64 %".1566", %".1565"
  store i64 %".1568", i64* @"ayas_arena_offset"
  %".1570" = getelementptr i8, i8* %".1567", i64 %".1566"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1570", i8* %".1560", i64 %".1562", i1 0)
  %".1572" = getelementptr i8, i8* %".1570", i64 %".1562"
  call void @"llvm.memcpy.p0i8.p0i8.i64"(i8* %".1572", i8* %".1561", i64 %".1563", i1 0)
  %".1574" = add i64 %".1562", %".1563"
  %".1575" = getelementptr i8, i8* %".1570", i64 %".1574"
  store i8 0, i8* %".1575"
  %".1577" = bitcast [4 x i8]* @"fmt_string" to i8*
  %".1578" = call i32 (i8*, ...) @"printf"(i8* %".1577", i8* %".1570")
  %".1579" = call i32 @"fflush"(i8* null)
  %"pos.49" = load i64, i64* %"pos"
  %".1580" = add i64 %"pos.49", 1
  store i64 %".1580", i64* %"pos"
  br label %"merge.1"
otherwise.10:
  %"pos.50" = load i64, i64* %"pos"
  %".1583" = add i64 %"pos.50", 1
  store i64 %".1583", i64* %"pos"
  br label %"merge.1"
}

@"str_lit_0" = internal constant [15 x i8] c"testinput.ayas\00"
@"str_mode_r" = internal constant [3 x i8] c"rb\00"
@"str_open_fail" = internal constant [34 x i8] c"skill issue: could not open file\0a\00"
@"str_lit_1" = internal constant [13 x i8] c"NEWLINE \5c\5cn \00"
@"fmt_string" = internal constant [4 x i8] c"%s\0a\00"
@"str_lit_2" = internal constant [5 x i8] c"/ / \00"
@"str_lit_3" = internal constant [7 x i8] c">= >= \00"
@"str_lit_4" = internal constant [5 x i8] c"> > \00"
@"str_lit_5" = internal constant [7 x i8] c"<= <= \00"
@"str_lit_6" = internal constant [5 x i8] c"< < \00"
@"str_fail_172" = internal constant [54 x i8] c"skill issue at line 172: unterminated string literal\0a\00"
@"str_lit_7" = internal constant [8 x i8] c"STRING \00"
@"str_lit_8" = internal constant [2 x i8] c" \00"
@"str_lit_9" = internal constant [7 x i8] c"FLOAT \00"
@"str_lit_10" = internal constant [8 x i8] c"NUMBER \00"
@"str_lit_11" = internal constant [4 x i8] c"let\00"
declare i32 @"strcmp"(i8* %".1", i8* %".2")

@"str_lit_12" = internal constant [9 x i8] c"let let \00"
@"str_lit_13" = internal constant [3 x i8] c"be\00"
@"str_lit_14" = internal constant [7 x i8] c"be be \00"
@"str_lit_15" = internal constant [4 x i8] c"fun\00"
@"str_lit_16" = internal constant [9 x i8] c"fun fun \00"
@"str_lit_17" = internal constant [6 x i8] c"thing\00"
@"str_lit_18" = internal constant [13 x i8] c"thing thing \00"
@"str_lit_19" = internal constant [5 x i8] c"when\00"
@"str_lit_20" = internal constant [11 x i8] c"when when \00"
@"str_lit_21" = internal constant [7 x i8] c"rather\00"
@"str_lit_22" = internal constant [15 x i8] c"rather rather \00"
@"str_lit_23" = internal constant [10 x i8] c"otherwise\00"
@"str_lit_24" = internal constant [21 x i8] c"otherwise otherwise \00"
@"str_lit_25" = internal constant [7 x i8] c"repeat\00"
@"str_lit_26" = internal constant [15 x i8] c"repeat repeat \00"
@"str_lit_27" = internal constant [3 x i8] c"in\00"
@"str_lit_28" = internal constant [7 x i8] c"in in \00"
@"str_lit_29" = internal constant [3 x i8] c"to\00"
@"str_lit_30" = internal constant [7 x i8] c"to to \00"
@"str_lit_31" = internal constant [6 x i8] c"times\00"
@"str_lit_32" = internal constant [13 x i8] c"times times \00"
@"str_lit_33" = internal constant [5 x i8] c"show\00"
@"str_lit_34" = internal constant [11 x i8] c"show show \00"
@"str_lit_35" = internal constant [5 x i8] c"disp\00"
@"str_lit_36" = internal constant [11 x i8] c"disp disp \00"
@"str_lit_37" = internal constant [5 x i8] c"give\00"
@"str_lit_38" = internal constant [11 x i8] c"give give \00"
@"str_lit_39" = internal constant [5 x i8] c"back\00"
@"str_lit_40" = internal constant [11 x i8] c"back back \00"
@"str_lit_41" = internal constant [3 x i8] c"is\00"
@"str_lit_42" = internal constant [7 x i8] c"is is \00"
@"str_lit_43" = internal constant [4 x i8] c"not\00"
@"str_lit_44" = internal constant [9 x i8] c"not not \00"
@"str_lit_45" = internal constant [4 x i8] c"and\00"
@"str_lit_46" = internal constant [9 x i8] c"and and \00"
@"str_lit_47" = internal constant [3 x i8] c"or\00"
@"str_lit_48" = internal constant [7 x i8] c"or or \00"
@"str_lit_49" = internal constant [6 x i8] c"skill\00"
@"str_lit_50" = internal constant [13 x i8] c"skill skill \00"
@"str_lit_51" = internal constant [6 x i8] c"issue\00"
@"str_lit_52" = internal constant [13 x i8] c"issue issue \00"
@"str_lit_53" = internal constant [5 x i8] c"true\00"
@"str_lit_54" = internal constant [11 x i8] c"BOOL true \00"
@"str_lit_55" = internal constant [6 x i8] c"false\00"
@"str_lit_56" = internal constant [12 x i8] c"BOOL false \00"
@"str_lit_57" = internal constant [12 x i8] c"IDENTIFIER \00"
@"str_lit_58" = internal constant [5 x i8] c"+ + \00"
@"str_lit_59" = internal constant [5 x i8] c"- - \00"
@"str_lit_60" = internal constant [5 x i8] c"* * \00"
@"str_lit_61" = internal constant [5 x i8] c"[ [ \00"
@"str_lit_62" = internal constant [5 x i8] c"] ] \00"
@"str_lit_63" = internal constant [5 x i8] c"{ { \00"
@"str_lit_64" = internal constant [5 x i8] c"} } \00"
@"str_lit_65" = internal constant [5 x i8] c"( ( \00"
@"str_lit_66" = internal constant [5 x i8] c") ) \00"
@"str_lit_67" = internal constant [5 x i8] c", , \00"
@"str_lit_68" = internal constant [5 x i8] c": : \00"
@"str_lit_69" = internal constant [5 x i8] c". . \00"
@"str_lit_70" = internal constant [5 x i8] c"EOF \00"