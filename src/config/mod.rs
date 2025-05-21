use crate::config::keymap::Keymaps;

mod keymap;

pub struct Config {}

impl Config {
    pub fn run() -> nvim_oxi::Result<()> {
        Keymaps::load();
        Ok(())
    }
}
