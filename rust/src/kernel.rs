// 入口
pub mod entry {
    use super::kernel::init;

    pub fn init_freefeos_kernel() {
        init();
    }
}

// 内核
mod kernel {

    pub fn init() {}
}
