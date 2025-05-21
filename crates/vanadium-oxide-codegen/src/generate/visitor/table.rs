use crate::generate::visitor::{AddToLayer, Layer};
use mlua::{TablePairs, Value};

pub struct Table<'a> {
    table: TablePairs<'a, Value<'a>, Value<'a>>,
}

impl<'a> Layer for Table<'a> {}

impl<'a> Iterator for Table<'a> {
    type Item = mlua::Result<(Value<'a>, Value<'a>)>;

    fn next(&mut self) -> Option<Self::Item> {
        self.table.next()
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        self.table.size_hint()
    }
}
