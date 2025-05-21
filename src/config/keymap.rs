use crate::nvim::keymap::{
    Key, Keymap,
    mode::{C, I, L, N, O, S, T, V, X},
};

pub struct Keymaps {}

impl Keymaps {
    pub fn load() -> Keymap {
        Keymap::new()
            .key(
                "<C-j>",
                Key::new()
                    .mode(N | I | C | V | X | S | O | L, "<esc>")
                    .mode(T, "<C-\\><C-n>"),
            )
            .key("<C-l>", Key::new().mode(N | I | C, "<CR>"))
    }
}
