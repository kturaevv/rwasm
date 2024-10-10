### Collection of tools for WASM binary size optimizations

Main takeaways:
    - profile (twiggy)
    - use lto
    - use `[no_mangle]`
    - use C ABI with extern C
    - build with --release
    - strip (llvm-strip)
    - optimize wasm modules (binaryen)

Unoptimized wasm binary weighs 1.3MB! After applying above optimization the final binary is reduced to ~240B.
