#![allow(non_camel_case_types, non_upper_case_globals)]

use crate::lua::accessor::OkOrPanic;
use mlua_sys::{LUA_GLOBALSINDEX, lua_State};
use std::{ffi::c_int, marker::PhantomData};

pub mod access;
pub mod accessor;
pub mod function;

pub trait LuaType {
    type Parent;
    const NAME: &str;
    const INIT: Self;
}

pub struct LuaRef<'lua, T, A = OkOrPanic> {
    lua: *mut lua_State,
    idx: c_int,

    _marker: PhantomData<&'lua mut lua_State>,
    _type: PhantomData<T>,
    _accessor: PhantomData<A>,
}

impl<'lua> LuaRef<'lua, lua_globals> {
    pub fn globals(lua: *mut lua_State) -> Self {
        Self {
            lua,
            idx: LUA_GLOBALSINDEX,

            _marker: PhantomData,
            _type: PhantomData,
            _accessor: PhantomData,
        }
    }
}

pub struct lua_globals {
    pub vim: vim::vim,
}

impl LuaType for lua_globals {
    type Parent = ();
    const NAME: &str = "";
    const INIT: Self = lua_globals {
        vim: vim::vim::INIT,
    };
}

pub mod globals {
    use crate::lua::{LuaType, lua_globals, vim::vim};

    pub const lua_globals: lua_globals = lua_globals::INIT;
    pub const vim: vim = vim::INIT;
}

pub mod vim {

    use crate::lua::{LuaType, lua_globals};

    pub struct vim {
        pub lsp: lsp::lsp,
    }

    impl LuaType for vim {
        type Parent = lua_globals;
        const NAME: &str = "vim";
        const INIT: Self = vim {
            lsp: lsp::lsp::INIT,
        };
    }

    pub mod lsp {
        use crate::lua::LuaType;

        pub struct lsp {
            pub start: start::start,
        }

        impl LuaType for lsp {
            type Parent = super::vim;

            const NAME: &str = "lsp";
            const INIT: Self = lsp {
                start: start::start::INIT,
            };
        }
        mod start {

            use crate::lua::LuaType;

            pub struct start {}
            impl LuaType for start {
                type Parent = super::lsp;

                const NAME: &str = "start";
                const INIT: Self = start {};
            }

            // impl LuaFn<'_> for start {
            //     type Args = ();
            //     type Results = ();
            // }
        }
    }
}
