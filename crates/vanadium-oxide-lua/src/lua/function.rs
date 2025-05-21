// pub trait LuaFn<'lua> {
//     type Args: IntoLuaMulti<'lua>;
//     type Results: FromLuaMulti<'lua>;
// }

// impl<'lua, T: LuaFn<'lua>, A> LuaRef<'lua, T, A> {
//     pub fn to_fn(&self) -> LuaFunction<'lua, T> {
//         todo!()
//     }
// }
//
// pub struct LuaFunction<'lua, F: LuaFn<'lua>> {
//     f: mlua::Function<'lua>,
//     _fn: F,
// }
//
// impl<'lua, F: LuaFn<'lua>> LuaFunction<'lua, F> {
//     pub fn call(&self, args: F::Args) -> Result<F::Results, mlua::Error> {
//         self.f.call(args)
//     }
// }
