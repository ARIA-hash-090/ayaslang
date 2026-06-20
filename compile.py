import sys
import os
import json
import time
import shutil
import subprocess
import llvmlite.binding as llvm

# #region agent log
_DEBUG_LOG = os.path.join(os.path.dirname(os.path.abspath(__file__)), "debug-3f30cb.log")

def _debug_log(hypothesis_id, location, message, data=None, run_id="pre-fix"):
    entry = {
        "sessionId": "3f30cb",
        "runId": run_id,
        "hypothesisId": hypothesis_id,
        "location": location,
        "message": message,
        "data": data or {},
        "timestamp": int(time.time() * 1000),
    }
    with open(_DEBUG_LOG, "a", encoding="utf-8") as f:
        f.write(json.dumps(entry) + "\n")
# #endregion

# We use one of these as a *linker driver* only — to glue the object file
# we generate with the C runtime startup code (crt0) and libc, so `printf`
# and program startup work. None of these compile any source code; ayas
# never produces or processes a single line of C. This is a placeholder
# until ayas gets its own freestanding runtime + linker step.
LINKER_CANDIDATES = ["clang", "gcc", "cc"]


def find_linker():
    for candidate in LINKER_CANDIDATES:
        path = shutil.which(candidate)
        if path:
            return path
    return None


def linker_extra_args():
    """Extra linker-driver flags needed beyond the object file itself.

    mat4_rotate_x/y/z use sin/cos (via the llvm.sin.f64/llvm.cos.f64
    intrinsics), which on Linux/macOS resolve to symbols in libm — a
    library that must be explicitly linked with `-lm`, since gcc/clang
    don't link it by default for a bare object file with no C source.

    On Windows, sin/cos live directly in the standard CRT (ucrt/msvcrt)
    rather than in a separate libm, and there is no `-lm`/`libm.lib` to
    find — passing `-lm` there would make the link fail outright. So
    this flag is added only on platforms that actually have a separate
    libm to link against.
    """
    if sys.platform.startswith(("linux", "darwin")):
        return ["-lm"]
    return []

from lexer import Lexer
from ayasparser import Parser, ShowNode
from codegen import Codegen


def _python_lexer_lines(path):
    """Reference output: one token per line as 'TYPE value line'."""
    with open(path, "r", encoding="utf-8") as f:
        source = f.read()
    lines = []
    for t in Lexer(source).tokenize():
        if t.type.value == "EOF":
            lines.append(f"EOF {t.line}")
        else:
            lines.append(f"{t.type.value} {t.value} {t.line}")
    return lines, source


def _debug_lexer_compare(source_path, exe_path):
    """Compare ayaslexer.exe output against the Python reference lexer."""
    testinput = os.path.join(os.path.dirname(source_path), "testinput.ayas")
    if not os.path.isfile(testinput):
        _debug_log("H4", "compile.py:_debug_lexer_compare", "testinput.ayas missing", {"path": testinput})
        return

    expected_lines, source_text = _python_lexer_lines(testinput)
    _debug_log(
        "H4", "compile.py:_debug_lexer_compare", "testinput.ayas loaded",
        {"bytes": len(source_text), "preview": repr(source_text[:80]), "token_count": len(expected_lines)},
    )

    actual_raw = ""
    run_ok = False
    if os.path.isfile(exe_path):
        try:
            run_result = subprocess.run(
                [os.path.abspath(exe_path)],
                capture_output=True, text=True, cwd=os.path.dirname(exe_path),
            )
            actual_raw = run_result.stdout
            run_ok = True
            _debug_log(
                "H5", "compile.py:_debug_lexer_compare", "ayaslexer.exe ran",
                {"exit_code": run_result.returncode, "stdout_repr": repr(actual_raw), "stderr": run_result.stderr},
            )
        except OSError as e:
            _debug_log(
                "H5", "compile.py:_debug_lexer_compare", "ayaslexer.exe run failed",
                {"error": str(e), "winerror": getattr(e, "winerror", None)},
            )
    else:
        _debug_log("H5", "compile.py:_debug_lexer_compare", "exe not found", {"exe_path": exe_path})

    # Actual output uses disp/show which may split across lines; normalize for compare.
    actual_lines = [ln.strip() for ln in actual_raw.splitlines() if ln.strip()]
    expected_joined = "\n".join(expected_lines)
    actual_joined = " ".join(actual_lines)

    _debug_log(
        "H1", "compile.py:_debug_lexer_compare", "output format comparison",
        {
            "expected_lines": expected_lines,
            "actual_split_lines": actual_lines,
            "expected_joined": expected_joined,
            "actual_joined": actual_joined,
            "match_if_single_line": expected_joined.replace(" ", "") == actual_joined.replace(" ", ""),
            "run_ok": run_ok,
        },
    )


def compile_ayas(source_path):
    with open(source_path, "r") as f:
        source = f.read()

    lexer  = Lexer(source)
    tokens = lexer.tokenize()

    parser = Parser(tokens)
    ast    = parser.parse()

    # #region agent log
    disp_nodes = sum(
        1 for stmt in ast
        if isinstance(stmt, ShowNode) and getattr(stmt, "no_newline", False)
    )
    show_nodes = sum(
        1 for stmt in ast
        if isinstance(stmt, ShowNode) and not getattr(stmt, "no_newline", False)
    )
    _debug_log(
        "H1", "compile.py:compile_ayas", "parsed show/disp counts (top-level only)",
        {"source": source_path, "disp_nodes": disp_nodes, "show_nodes": show_nodes},
    )
    # #endregion

    codegen = Codegen()
    module  = codegen.generate(ast)
    ir_str  = str(module)

    llvm.initialize_native_target()
    llvm.initialize_native_asmprinter()
    llvm.initialize_all_targets()

    llvm_mod = llvm.parse_assembly(ir_str)
    llvm_mod.verify()

    triple         = llvm.get_default_triple()
    target         = llvm.Target.from_triple(triple)
    target_machine = target.create_target_machine(reloc="pic", codemodel="default")

    base     = os.path.splitext(source_path)[0]
    obj_path = base + ".o"
    exe_path = base + ".exe"
    ll_path  = base + ".ll"

    # Always dump the IR — useful for diagnosing target-specific issues.
    with open(ll_path, "w") as f:
        f.write(ir_str)

    with open(obj_path, "wb") as f:
        f.write(target_machine.emit_object(llvm_mod))

    print(f"[ayas] object file written: {obj_path}")
    print(f"[ayas] LLVM IR written:     {ll_path}")
    print(f"[ayas] target triple:       {triple}")

    linker = find_linker()
    if linker is None:
        print("[ayas] error: no linker driver found (tried: " + ", ".join(LINKER_CANDIDATES) + ")")
        print("[ayas] install one of these to produce an executable")
        sys.exit(1)

    print(f"[ayas] linker driver:       {linker}")

    result = subprocess.run(
        [linker, obj_path, "-o", exe_path] + linker_extra_args(),
        capture_output=True, text=True
    )

    if result.returncode != 0:
        print("[ayas] linker error:")
        print(result.stderr)
        sys.exit(1)

    print(f"[ayas] compiled successfully: {exe_path}")

    # Run it immediately and report everything — output, stderr, exit code —
    # so a single `python compile.py <file>` gives the full picture.
    print(f"[ayas] running {exe_path} ...")
    print("[ayas] ---- program output (stdout) ----")
    run_result = subprocess.run(
        [os.path.abspath(exe_path)],
        capture_output=True, text=True
    )
    sys.stdout.write(run_result.stdout)
    print("[ayas] ---- program output (stderr) ----")
    sys.stdout.write(run_result.stderr)
    print("[ayas] ---- end of program output ----")
    print(f"[ayas] exit code: {run_result.returncode}")

    # #region agent log
    if os.path.basename(source_path) == "ayaslexer.ayas":
        _debug_lexer_compare(source_path, exe_path)
    # #endregion


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python compile.py <file.ayas>")
        sys.exit(1)

    compile_ayas(sys.argv[1])