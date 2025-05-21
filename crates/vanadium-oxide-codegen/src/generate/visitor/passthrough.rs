use crate::generate::visitor::{AddToLayer, Layer, empty::Empty};

pub struct Passthrough<L>(L);
