static PRIMES: &[i32] = &[2, 3, 5, 7, 11, 13, 17, 19, 23];

#[no_mangle]
extern "C" fn nth_prime(n: usize) -> i32 {
    PRIMES.get(n).copied().unwrap_or(-1)
}

#[no_mangle]
pub extern "C" fn add(left: usize, right: usize) -> usize {
    left + right
}
