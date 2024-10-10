wasm_path := "./target/wasm32-unknown-unknown/release/rwasm.wasm"
wasm_opt_path := "./target/output.wasm"

default:
    just -l

# Setup dev dependencies
setup:
    ./check_setup.sh
    git submodule update --init --recursive --depth 1
    cd ./extern/wabt && make clang-release-no-tests
    cd ./extern/binaryen && cmake . -DBUILD_TESTS=OFF && make

# Read WASM in human readible form
wasm2wat *args=wasm_path:
    ./extern/wabt/bin/wasm2wat {{args}}

# Strip wasm from redundant data
llvm-strip *args=wasm_path:
    llvm-strip --keep-section=name {{args}}

# Optimize WASM
wasm-opt *args=wasm_path:
    ./extern/binaryen/bin/wasm-opt -O3 -o {{wasm_opt_path}} {{args}}

# Build release target WASM
build-release:
    cargo build --release --target wasm32-unknown-unknown

# Build optimized version and review with twiggy
release *args=wasm_path: build-release llvm-strip wasm-opt
    twiggy top {{wasm_opt_path}}
