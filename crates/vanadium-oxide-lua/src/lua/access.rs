use crate::lua::{LuaAccessor, LuaRef, LuaType};
use std::convert::Infallible;

pub trait LuaAccess<F, C>: Sized + LuaType {
    fn try_access<A: LuaAccessor>(self, lua_value: LuaRef<F, A>)
    -> Result<LuaRef<Self, A>, A::Err>;
}

pub trait LuaAccessExt<F, C>: LuaAccess<F, C> {
    fn access<A: LuaAccessor<Err = Infallible>>(self, lua_value: LuaRef<F, A>) -> LuaRef<Self, A>;
}

impl<T: LuaAccess<F, C>, F, C> LuaAccessExt<F, C> for T {
    fn access<A: LuaAccessor<Err = Infallible>>(self, lua_value: LuaRef<F, A>) -> LuaRef<Self, A> {
        let Ok(val) = self.try_access(lua_value);
        val
    }
}

pub struct Base;
pub struct Step<S>(S);

impl<F: LuaType> LuaAccess<F::Parent, Base> for F {
    fn try_access<A>(self, lua_value: LuaRef<F::Parent, A>) -> Result<LuaRef<Self, A>, A::Err>
    where
        A: LuaAccessor,
    {
        A::access::<Self>(lua_value)
    }
}

impl<F: LuaType, T: LuaType<Parent: LuaType>, S> LuaAccess<F, Step<S>> for T
where
    Self::Parent: LuaAccess<F, S>,
{
    fn try_access<A>(self, lua_value: LuaRef<F, A>) -> Result<LuaRef<T, A>, A::Err>
    where
        A: LuaAccessor,
    {
        let parent_t =
            <Self::Parent as LuaAccess<F, S>>::try_access::<A>(Self::Parent::INIT, lua_value)?;
        A::access::<Self>(parent_t)
    }
}
