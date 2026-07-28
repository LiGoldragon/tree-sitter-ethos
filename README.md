# tree-sitter-ethos

Tree-sitter grammar and editor highlighting support for authored Ethos
`.ethos` files.

This grammar is structural-macro-aware: it parses Ethos positions and names
the typed macro forms that the Ethos toolchain currently lowers from NOTA:

- root input and output enum vectors
- namespace struct, enum, alias, stream, and family declarations
- enum variant signatures, including `opens` and `belongs` stream relations
- type reference macros: `Vec`, `Vector`, `Optional`, `Option`, `ScopeOf`,
  `Scope`, `Map`, `KeyValue`, and `Bytes`
- relation blocks such as `Equivalence`

## Local Checks

```sh
nix build
nix flake check
```

The parser also accepts raw-core single-map files and
`SchemaMacro` library source so existing `.ethos` files do not render as a
wall of errors while edited. `SchemaMacro` is the unchanged spelling of a
schema-generation construct, not the language name; retaining it keeps this
terminology train behavior-free.

The flake builds `tree-sitter-ethos.wasm` through a Nix-native WASI toolchain.
It does not use tree-sitter's downloaded upstream wasi-sdk. The check path
regenerates the parser, runs tree-sitter corpus/highlight tests, parses the
valid Ethos fixture set, byte-compiles the Emacs mode, and checks that
the WASM artifact is a WebAssembly module.

```sh
nix build .#default
ls -l result/tree-sitter-ethos.wasm
```

## Editor Support

- `queries/highlights.scm`, `queries/locals.scm`, and `queries/folds.scm` are
  the canonical tree-sitter query files.
- `editors/emacs/ethos-ts-mode.el` provides an Emacs 29+ tree-sitter major
  mode with differentiated faces for Ethos object kinds.
- `editors/vscodium/` contains a VSCodium language-registration extension and
  `tree-sitter-vscode` settings for semantic-token highlighting.
