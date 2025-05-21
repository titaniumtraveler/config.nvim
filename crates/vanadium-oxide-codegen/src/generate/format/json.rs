use crate::generate::format::{
    Format, PrepareContext,
    json::{id::Id, name::Name, value_description::ValueDescription},
};
use anyhow::anyhow;
use mlua::Value;
use serde::Serialize;
use std::{
    borrow::Cow,
    collections::{BTreeMap, btree_map::Entry},
    io::{self, BufWriter, Write},
};

mod id;
mod name;
mod value_description;

#[derive(Serialize)]
pub struct Json<'a> {
    names: BTreeMap<Name<'a>, Id>,
    values: BTreeMap<Id, ValueDescription<'a>>,
}

impl Json<'_> {
    pub fn new() -> Self {
        Self {
            names: Default::default(),
            values: Default::default(),
        }
    }
}

impl Default for Json<'_> {
    fn default() -> Self {
        Self::new()
    }
}

impl<'a> Format<'a> for Json<'a> {
    type Context = Cow<'a, str>;
    type Error = anyhow::Error;

    fn visit(
        &mut self,
        context: &[Self::Context],
        value: &mlua::Value<'a>,
    ) -> Result<(), Self::Error> {
        let value_id = value.into();
        if let Entry::Vacant(vacant) = self.values.entry(value_id) {
            vacant.insert(value.try_into()?);
        }
        match self.names.entry(context.into()) {
            Entry::Vacant(vacant_entry) => {
                vacant_entry.insert(value_id);
                Ok(())
            }
            Entry::Occupied(occupied_entry) => Err(anyhow!(
                "duplicate name {key}={val}",
                key = occupied_entry.key(),
                val = occupied_entry.get()
            )),
        }
    }

    fn finish(self) -> Result<(), Self::Error> {
        let mut write = BufWriter::new(io::stdout().lock());
        serde_json::to_writer_pretty(&mut write, &self)?;
        write.write_all(b"\n")?;
        write.flush()?;
        Ok(())
    }
}

impl<'a> PrepareContext<'a, Value<'a>> for Json<'a> {
    fn prepare_context(&mut self, context: Value<'a>) -> Result<Self::Context, Self::Error> {
        context.to_string().map(Into::into).map_err(Into::into)
    }
}
