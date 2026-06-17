import sys
import os
import shutil
import subprocess
import llvmlite.binding as llvm

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
from ayasparser import Parser
from codegen import Codegen


def compile_ayas(source_path):
    with open(source_path, "r") as f:
        source = f.read()

    lexer  = Lexer(source)
    tokens = lexer.tokenize()

    parser = Parser(tokens)
    ast    = parser.parse()

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


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python compile.py <file.ayas>")
        sys.exit(1)

    compile_ayas(sys.argv[1])