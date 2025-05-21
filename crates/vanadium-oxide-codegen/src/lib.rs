use core::ffi::c_int;
use mlua_sys::{LUA_TSTRING, lua::lua_State, lua_gettop, lua_pop, lua_tolstring, lua_type};
use std::{ffi::OsStr, os::unix::ffi::OsStrExt, ptr::slice_from_raw_parts};

pub mod command;
pub mod generate;

pub const PLUGIN_ENTRY: &[u8] = b"vanadium_oxide_codegen";

/// # Safety
/// See [`mlua_sys::lua51::lua_CFunction`]
#[unsafe(no_mangle)]
pub unsafe extern "C-unwind" fn luaopen_vanadium_oxide_codegen(
    #[allow(non_snake_case)] L: *mut lua_State,
) -> c_int {
    unsafe {
        let n = lua_gettop(L);
        assert_eq!(n, 1);
        assert_eq!(lua_type(L, n), LUA_TSTRING);
        let mut len = 0;
        let str = lua_tolstring(L, 1, &mut len) as *const u8;
        assert!(!str.is_null());
        let str = &*slice_from_raw_parts(str, len);
        assert_eq!(PLUGIN_ENTRY, str);

        println!(
            "LUA_CPATH: {:#?}",
            std::env::var_os("LUA_CPATH").unwrap_or_default()
        );
        println!("plugin: {:#?}", OsStr::from_bytes(str));

        lua_pop(L, n);

        0
    }
}

// pub extern "C" fn luaopen_vanadium_oxide_codegen(lua: lua_State) -> c_int {
//     Generator {
//         format: format::Json::new(),
//         visitor: (), // TablesVisitor::default(),
//     };
//     .run::<Box<dyn std::error::Error + Send + Sync>>(lua)
//     .map_err(nvim_oxi::mlua::Error::external)?;
//     nvim_oxi::api::exec2("qall!", &ExecOpts::builder().output(false).build()).unwrap();
//     0
// }
