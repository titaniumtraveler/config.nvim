use crate::generate::visitor::{AddToLayer, Empty, Layer};
use std::{collections::HashSet, ffi::c_void};

#[derive(Debug, Default)]
pub struct DedupByPointer<L = Empty<()>>(L, HashSet<*const c_void>);
