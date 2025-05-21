use mlua::Value;

pub use self::{json::Json, stdout::Stdout};

mod json;
mod stdout;

pub trait Format<'a> {
    type Context;
    type Error;
    fn visit(&mut self, context: &[Self::Context], value: &Value<'a>) -> Result<(), Self::Error>;
    fn finish(self) -> Result<(), Self::Error>;
}

pub trait PrepareContext<'a, C>: Format<'a> {
    fn prepare_context(&mut self, context: C) -> Result<Self::Context, Self::Error>;
}
