use crate::generate::format::{Format, PrepareContext};
use mlua::Value;

pub struct Stdout;

impl Format<'_> for Stdout {
    type Context = String;
    type Error = anyhow::Error;

    fn visit(&mut self, context: &[Self::Context], value: &mlua::Value) -> Result<(), Self::Error> {
        println!("{}={}", context.join("::"), value.to_string()?);
        Ok(())
    }
    fn finish(self) -> Result<(), Self::Error> {
        Ok(())
    }
}

impl<'a> PrepareContext<'a, Value<'a>> for Stdout {
    fn prepare_context(&mut self, context: Value<'a>) -> Result<Self::Context, Self::Error> {
        context.to_string().map_err(Into::into)
    }
}
