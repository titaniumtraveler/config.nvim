use crate::traits::{LuaType, LuaValue};
use std::{convert::Infallible, marker::PhantomData};

pub trait LuaAccessor: Sized {
    type Err;
    fn access<T: LuaType>(
        lua_value: LuaValue<T::Parent, Self>,
    ) -> Result<LuaValue<T, Self>, Self::Err>;
}

pub struct OkOrPanic;
impl LuaAccessor for OkOrPanic {
    type Err = Infallible;

    fn access<T: LuaType>(lua_value: LuaValue<T::Parent>) -> Result<LuaValue<T>, Self::Err> {
        let table = lua_value.table.get(T::NAME).unwrap();
        Ok(LuaValue {
            table,
            _type: PhantomData,
            _accessor: PhantomData,
        })
    }
}

pub struct OkOrMluaErr;

impl LuaAccessor for OkOrMluaErr {
    type Err = Box<dyn std::error::Error>;

    fn access<T: LuaType>(
        lua_value: LuaValue<T::Parent, Self>,
    ) -> Result<LuaValue<T, Self>, Self::Err> {
        let table = lua_value.table.get(T::NAME)?;
        Ok(LuaValue {
            table,
            _type: PhantomData,
            _accessor: PhantomData,
        })
    }
}
