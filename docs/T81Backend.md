# T81Backend.md — LLVM Backend for Ternary Architecture

## 📌 Overview
The T81 LLVM backend provides a complete toolchain extension to support the **T81 ternary instruction set architecture (TISC)**. It transforms LLVM IR into `.t81asm` symbolic ternary code for execution on the **HanoiVM**, an experimental recursive virtual machine powered by ternary logic and symbolic AI.

This backend targets `t81-unknown-none` and is compatible with frontends such as Clang and Rust with minimal integration overhead.

---

## 🔧 Key Features
- **Ternary Register File**: 81 symbolic registers (`R0`–`R80`)
- **Custom Instructions**: Arithmetic (`TADD`, `TSUB`, `TMUL`), branching (`TBRZ`), memory (`TLD`), and AI macros (`TDISPATCH`)
- **Symbolic Metadata**: Entropy-driven AI tags (planned)
- **Target Triple**: `t81-unknown-none`

---

## 🧠 Architecture Components

### Register Definitions
```llvm
def R0 : T81Reg<"R0", 0>; ... def R80 : T81Reg<"R80", 80>;
```
- Declared in `T81RegisterInfo.td`
- 81 general-purpose ternary registers

### Register Class
```llvm
def T81GPR : RegisterClass<"T81", [i32], 32, (add R0...R80)> {
  let Size = 81;
}
```

### Instructions
```llvm
def TADD : T81InstBase<"tadd"> {
  let OutOperandList = (outs T81GPR:$dst);
  let InOperandList = (ins T81GPR:$src1, T81GPR:$src2);
  let AsmString = "tadd $dst, $src1, $src2";
}
```

Supported Ops:
- `TADD`, `TSUB`, `TMUL`, `TXOR3`
- `TBRZ`, `TLD`, `TENT`, `TDISPATCH`

### IR Lowering
```cpp
SDValue T81TargetLowering::LowerOperation(...) {
  switch (Op.getOpcode()) {
    case ISD::ADD: return DAG.getMachineNode(T81::TADD, ...);
  }
}
```

---

## ⚙️ ABI and Calling Convention
To be defined in:
- `T81CallingConv.td`
- `T81FrameLowering.cpp`

Proposed layout:
- Return values in `R0`
- Arguments passed via `R1`–`R8`
- Ternary stack frame alignment

---

## 📤 Toolchain Usage

### Build Backend
```bash
cmake -DLLVM_TARGETS_TO_BUILD=T81 ..
make llc
```

### Emit T81 Assembly
```bash
llc -march=t81 input.ll -o output.t81asm
```

### (Planned) Clang Support
```bash
clang --target=t81-unknown-none -c file.c -o file.t81asm
```

---

## 📊 Future Work
| Feature              | Status      |
|----------------------|-------------|
| Backend Core         | ✅ Working  |
| ABI Spec             | 🚧 Planned  |
| Clang Integration    | 🚧 Planned  |
| T729 AI Opcodes      | 🧪 Experimental |
| Debug Metadata       | 🧪 Optional |
| MLIR Dialect         | 🔍 Under Review |

---

## 📚 References
- [LLVM Backend Tutorial](https://llvm.org/docs/WritingAnLLVMBackend.html)
- [HanoiVM Project](https://github.com/t81dev/hanoi)
- [Axion AI Runtime](https://github.com/t81dev/hanoi/tree/main/src)

---

## 🛠 Maintainers
This backend is maintained by the **HanoiVM development group**. Contributions, issues, and pull requests are welcome!

---
