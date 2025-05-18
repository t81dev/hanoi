# 📜 CHANGELOG.md

## \[v0.9.2] - 2025-05-18

### ✨ Added

* **🧠 `synergy.cweb` – Global Project Integrator**

  * Introduced a dedicated synergy module to coordinate cross-cutting logic between T81Lang, Axion AI, GPU dispatch layers, and tier-aware recursion.
  * Centralized bridge logic for T243/T729 interop, entropy signaling, and AI-enhanced stack promotion.
  * Annotated function calls with Axion meta-feedback and symbolic tier callbacks.

* **📘 Documentation Refresh**

  * Fully revised `README.md` with synergy section, complete tier documentation, and unified GPU/AI model overview.
  * Refactored `ROADMAP.md` to include current project progress across Phase 6–9 with repository-aligned status.
  * Prepared new `synergy.cweb` documentation for CWEAVE integration.

* **🧪 Disassembler/Export Improvements**

  * Expanded `recursion_exporter.cweb` to include symbolic tier snapshots and Axion annotations in trace outputs.
  * Improved entropy delta calculation (`τ[27]`) across recursive stack frames.

* **📦 Archive Update**

  * Merged new `.cweb` files into `hanoivm-0.9.tar` package.
  * Improved Makefile and CWEAVE/TANGLE build integration.

### 🛠️ Changed

* **⚙️ Runtime Configuration (config\_.cweb)**

  * Added explicit tier-aware toggles and symbolic log modes.
  * Added fallback resolution mode for tier downgrade on entropy violation.

* **🌐 README + ROADMAP Synergy**

  * Rewritten `README.md` with tier symbols, AI flow logic, and direct mapping to `.cweb` components.
  * Synced all ROADMAP phases with live GitHub repository milestones at [t81dev/hanoi](https://github.com/t81dev/hanoi).

* **🔁 Interpreter Stack Improvements**

  * Integrated symbolic tier fallback into interpreter (`interpret_hvm`) with Axion context switching.
  * Linked `t81_stack` to `gaia_handle_request` and `cuda_handle_request` as dynamic macro executors.

### 🚗 Fixed

* **🧩 Recursive Frame Capture**

  * Corrected local frame offset indexing in `recursion_exporter.cweb` under symbolic promotion.
  * Patched null-symbol fallback in `get_symbolic_opcode()` and `get_symbolic_intent()` macros.

* **🔍 Entropy Signal Drift**

  * Addressed edge-case anomalies when Axion meta-opcodes rapidly shifted tiers during nested recursion.

* **💡 AI Signal Stabilization**

  * Fixed Axion AI optimization score race condition during stack collapse suggestions.

---

## 🔮 Notes & Reflections

This release finalizes the structural convergence of:

* Recursive logic
* AI introspection
* Ternary symbolic execution
* GPU-tier dispatch

The introduction of `synergy.cweb` marks a shift toward unified, intelligent orchestration between all symbolic components.

---

> *"The stack isn’t just execution—it's a dialogue between logic and entropy."* — `synergy.cweb`

## \[v0.9.1] - 2025-05-03

### ✨ Added

* **📁 Archive + Packaging Tools**

  * Added `.tar.gz` packaging workflow for modular `.cweb` source bundles
  * Support for `TISCQueryCompiler.tar.gz` with buildable Makefile and test query

* **📜 Documentation Updates**

  * `ROADMAP.md` updated to include Phase 9: TISC Query Compiler & Semantic Search
  * `README.md` enhanced with `TISCQueryCompiler.cweb` listing and project status entry
  * `CHANGELOG.md` updated to reflect all changes as of 2025-05-03

### 🧪 Tests & Validation

* Test query added for `TISCQueryCompiler` module to validate NLP → TISC compilation
* Verified end-to-end `.tar.gz` packaging and unpacking support across environments

### 🛠️ Changed

* Minor formatting and section consistency in all project markdown files for better legibility and structure

---

## \[v0.9] - 2025-03-27

### ✨ Added

* **📦 LLVM Backend Integration**

  * Target triple (`t81-unknown-none`) registered
  * Custom 81-trit integer type (`i81`) added to LLVM IR
  * Instruction Selection DAG patterns (`ISelLowering.cpp`, `DAGISel.cpp`)
  * Assembly generation via `T81AsmPrinter.cpp`
  * Machine instruction lowering (`T81MCInstLower.cpp`)
  * Updated `.cweb` documentation (`t81_codegen.cweb`, `t81_llvm_backend.cweb`)

* **🔌 GPU Symbolic Execution Enhancements**

  * CUDA backend (`cuda_handle_request.cu`) fully operational with symbolic tensor dispatch
  * ROCm backend (`gaia_handle_request.cweb`) mirrors CUDA FFT & symbolic macro capabilities

* **💻 Developer Tooling & UX**

  * Comprehensive recursion visualization via `FrameSceneBuilder.cweb`
  * JSON schema-defined tier introspection for Project Looking Glass
  * Axion log inspection enhanced with `logviewer.cweb`

* **📈 Profiling & Performance Benchmarks**

  * New opcode profiling metrics (`Opcode_Execution_Frequency`, `Memory_Access_Heatmap`)
  * VM benchmarks (`VM_Benchmark_Comparison.csv`) and acceleration analysis published

* **🔍 TISC Query Compiler Integration**

  * `TISCQueryCompiler.cweb` module added for semantic query-to-TISC compilation
  * NLP tokenization → symbolic opcode mapping (`OP_LOOKUP`, `OP_TAG`, etc.)
  * Entropy-aware scoring and stack-mutating execution model
  * Test harness + example queries included for inference path verification

### 🧪 Tests & Validation

* LLVM backend unit tests established for instruction lowering (`lit`, `FileCheck`)
* GPU backend validation through FFT symbolic operations
* TISCQueryCompiler tests added for natural language → opcode transformation
* VM interpreter and compiler pipeline fully end-to-end tested with ternary symbolic logic

### ⚖️ Changed

* **⚙️ LLVM IR & Opcode Refinements**

  * Improved DataLayout (`"e-p:81:81-i81:81:81-n81:81-S81"`) for optimal ternary alignment
  * Extended DAG instruction selection logic for comprehensive `i81` support

* **🧠 GPU Integration**

  * Consolidated symbolic tensor API calls (`T729HoloTensor`) across CUDA and ROCm
  * Optimized GPU backend dispatch logic for reduced latency and improved symbolic entropy handling

* **🌀 Symbolic Stack Optimization**

  * Enhanced tier promotion/demotion logic based on Axion entropy signals
  * Improved recursive depth management and symbolic overflow protection

### 🚗 Fixed

* **🚨 LLVM IR DataLayout**

  * Fixed misalignment in ternary pointer arithmetic causing potential IR optimization issues

* **🔍 GPU Backend Stability**

  * Resolved memory leaks in CUDA symbolic tensor operations (`cuda_handle_request.cu`)
  * Corrected edge-case entropy calculation overflow (`T729Intent`)

* **🩵 Axion Logging Reliability**

  * Fixed malformed metadata entries (`axion.meta.json`) for certain symbolic opcodes under rapid context switching

---

## \[v0.8] - 2025-03-26

### 🚀 Added

* **🧠 Symbolic Execution Extensions (T243/T729)**

  * FSM vectors (`T243StateVector`), entropy-aware dispatch (`T729Intent`)
  * Symbolic FFT tensor operations (`T729HoloTensor`)

* **📦 Literate Documentation**

  * Added comprehensive project philosophy and structure (`manifesto.cweb`, `t243_t729.md`)

* **🖼️ Initial Project Looking Glass Visualization**

  * Implemented first-generation recursive visualization via `FrameSceneBuilder.cweb`

---

## 🔮 Notes & Future Directions

This release fully establishes HanoiVM's LLVM backend infrastructure, deep GPU integration, developer tooling, and semantic symbolic search with entropy scoring.

Future releases will include:

* Full GPU graph execution pipelines
* Axion-enhanced semantic search visual tools
* `.cwebpkg` distribution flows
* CI/CD optimization
* Live REPLs and LLVM hybrid execution modes

---

> *"Recursion isn't merely repeated calls; it's the echo of infinite potential."* — `manifesto.cweb`
