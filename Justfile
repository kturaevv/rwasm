# Setup dev dependencies
default:
    just -l

setup:
    ./check_setup.sh
    git submodule update --init --recursive --depth 1
    cd ./extern/wabt && make clang-release-no-tests
    cd ./extern/binaryen && cmake . -DBUILD_TESTS=OFF && make

# Convert binary
wasm2wat *args="./target/wasm32-unknown-unknown/release/rwasm.wasm":
    ./extern/wabt/bin/wasm2wat {{args}}
