use std::{
    ffi::{OsStr, OsString},
    path::Path,
    process::Command,
};

pub fn command(_load_library: LoadLibrary) -> Command {
    let mut command = Command::new("nvim");
    command
        .args(["-u", "NONE", "--headless"])
        .args(["-i", "NONE"])
        .args(["-c", "set noswapfile"])
        .arg("-c")
        .arg(r#"lua require "vanadium_oxide_codegen" "#);
    // .arg(load_library.to_os_string());
    command
}

pub struct LoadLibrary<'a> {
    pub lib_path: &'a Path,
    pub load_function: &'a OsStr,
}

impl LoadLibrary<'_> {
    pub fn to_os_string(&self) -> OsString {
        OsString::from_iter([
            "lua (package.loadlib([[".as_ref(),
            self.lib_path.as_ref(),
            "]], 'luaopen_".as_ref(),
            self.load_function,
            "'))()".as_ref(),
        ])
    }
}
