use crate::generate::visitor::Layer;
use mlua::{TablePairs, Value};
use std::{collections::HashSet, ffi::c_void};

#[derive(Debug, Default)]
pub struct TablesVisitor(HashSet<*const c_void>);

// impl<'a> Layer<'a> for TablesVisitor {
//     type Context = Value<'a>;
//     type Error = mlua::Error;
//     type Iter = TablePairs<'a, Value<'a>, Value<'a>>;
//
//     fn recurse(&mut self, value: Value<'a>) -> Option<Self::Iter> {
//         if let Value::Table(table) = value {
//             if self.0.insert(table.to_pointer()) {
//                 return Some(table.pairs());
//             }
//         }
//         None
//     }
//
//     fn finish(self) -> Result<(), Self::Error> {
//         Ok(())
//     }
// }
