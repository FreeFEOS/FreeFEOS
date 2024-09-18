use super::kernel::entry::init_freefeos_kernel;

#[test]
fn it_works() {
    println!("Hello, world!");
}

#[test]
fn start_kernel() {
    init_freefeos_kernel();
}