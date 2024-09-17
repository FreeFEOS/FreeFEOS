use super::kernel::entry::init_freefeos_kernel;
use flutter_rust_bridge::{frb, setup_default_user_utils};

#[frb(sync)] // Synchronous mode for simplicity of the demo
pub(crate) fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[frb(init)]
pub(crate) fn init_kernel() {
    // Default utilities - feel free to customize
    setup_default_user_utils();
    init_freefeos_kernel();
}
