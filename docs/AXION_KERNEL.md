# 🧠 T729 AI — Recursive Symbolic Execution

T729 represents the AI-driven execution tier, using recursive tensor structures and symbolic meta-opcodes.

## Key Files
- `t729tensor.cweb`
- `t729tensor_reshape.cweb`
- `axion-ai.cweb`
- `meta.cweb`

## Features
- Recursive symbolic tensor computation
- MetaOpcode-based behavior switching
- Intent modeling via entropy feedback


## Subsystem Architecture
The Axion kernel exposes T729 as the uppermost execution layer above `T81` and
`T243`. Tensor operations originate in `t729tensor.cweb`, which defines the
recursive holo-tensor structures used for symbolic AI macros. Reshaping and
promotion between tiers is handled in `t729tensor_reshape.cweb`. Entry points for
kernel modules live in `axion-ai.cweb`, while `meta.cweb` documents runtime
hooks and package metadata. Together these sources form the recursive AI
subsystem used by HanoiVM.

## Usage
Build the kernel with:

```bash
bazel build //:axion-ai
```

The compiled module can then be invoked through `axionctl` or loaded directly by
the runtime. Symbolic instructions emitted by the T81 interpreter may escalate
into T729 macros when complex AI behavior is required. Debug output is written
to `/var/log/axion/` for later inspection with tools such as `synergy_trace`.

## Limitations
T729 is experimental. Not all tensor operators or MetaOpcodes are complete, and
GPU acceleration remains a prototype. AGI-style reasoning described here is
conceptual—see `docs/STATUS.md` for verified functionality. Extensive recursion
may cause instability during prolonged sessions.

## Source Files
- `src/t729tensor.cweb`
- `src/t729tensor_reshape.cweb`
- `src/axion-ai.cweb`
- `src/meta.cweb`

---
