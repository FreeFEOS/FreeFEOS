use flutter_rust_bridge::{frb, setup_default_user_utils};

#[frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[frb(init)]
pub fn init_kernel() {
    // Default utilities - feel free to customize
    setup_default_user_utils();
}
