@* T81 LLVM Backend Definitions for HanoiVM.

This document defines the LLVM TableGen sources for the T81 ternary backend, including:

- General-purpose ternary registers (R0–R80)
- Instruction definitions (TADD, TSUB, TBRZ, etc.)
- Ternary-specialized operations (TENT, TDISPATCH, etc.)

Used by the HanoiVM compiler toolchain to emit `.hvm` or `.t81asm` from LLVM IR.

@<T81 Register Definitions@>
@<T81 Instruction Definitions@>
@<T81 Register Class Definition@>

@*1 T81 Register Definitions.

@<T81 Register Definitions@>=
include "llvm/Target/Target.td"

class T81Reg<string n, bits<16> num> : Register<n> {
  let HWEncoding = num;
}

// General-Purpose Ternary Registers R0–R80
@<R0 to R80 Declarations@>

@*1 T81 Register Class.

@<T81 Register Class Definition@>=
def T81GPR : RegisterClass<"T81", [i32], 32,
  (add @<Register List: R0–R80@>)> {
  let Size = 81;
}

@*1 T81 Instruction Definitions.

@<T81 Instruction Definitions@>=
include "llvm/Target/TargetInstrInfo.td"
include "T81RegisterInfo.td"

def T81Instrs : InstrInfo;

class T81InstBase<string opcstr> : Instruction {
  let Namespace = "T81";
  let OutOperandList = (outs);
  let InOperandList = (ins);
  let AsmString = !strconcat(opcstr, " $operands");
  let hasSideEffects = 0;
}

def TADD : T81InstBase<"tadd"> {
  let OutOperandList = (outs T81GPR:$dst);
  let InOperandList  = (ins T81GPR:$src1, T81GPR:$src2);
  let AsmString = "tadd $dst, $src1, $src2";
}

def TSUB : T81InstBase<"tsub"> {
  let OutOperandList = (outs T81GPR:$dst);
  let InOperandList  = (ins T81GPR:$src1, T81GPR:$src2);
  let AsmString = "tsub $dst, $src1, $src2";
}

def TMUL : T81InstBase<"tmul"> {
  let OutOperandList = (outs T81GPR:$dst);
  let InOperandList  = (ins T81GPR:$src1, T81GPR:$src2);
  let AsmString = "tmul $dst, $src1, $src2";
}

def TXOR3 : T81InstBase<"txor3"> {
  let OutOperandList = (outs T81GPR:$dst);
  let InOperandList  = (ins T81GPR:$src1, T81GPR:$src2);
  let AsmString = "txor3 $dst, $src1, $src2";
}

def TBRZ : T81InstBase<"tbrz"> {
  let InOperandList = (ins T81GPR:$cond, brtarget:$target);
  let AsmString = "tbrz $cond, $target";
}

def TLD : T81InstBase<"tld"> {
  let OutOperandList = (outs T81GPR:$dst);
  let InOperandList  = (ins T81GPR:$addr);
  let AsmString = "tld $dst, $addr";
}

def TENT : T81InstBase<"tent"> {
  let OutOperandList = (outs T81GPR:$dst);
  let InOperandList  = (ins T81GPR:$src);
  let AsmString = "tent $dst, $src";
}

def TDISPATCH : T81InstBase<"tdispatch"> {
  let InOperandList = (ins T81GPR:$macro);
  let AsmString = "tdispatch $macro";
}
