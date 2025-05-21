use std::iter::Empty;

use crate::generate::visitor::{AddToLayer, Layer};

pub struct Id;
pub struct IdLayer<L>(L);
pub struct IdWithLayer<'a, L>(&'a mut L);

impl Layer for Id {
    type Iter = Empty<()>;
}

impl<L: Layer> AddToLayer<Id, L::Item> for L {
    type Layer = IdLayer<L>;
    fn add_to_layer(self, Id: Id) -> Self::Layer {
        IdLayer(self)
    }

    type WithLayer<'a> = IdWithLayer<'a, L>;
    fn with_layer<'a>(
        layer: &'a mut Self,
        iter: &'a mut <Id as Layer>::Iter,
    ) -> Self::WithLayer<'a> {
        todo!()
    }
}

impl Iterator for Id {
    type Item = ();

    fn next(&mut self) -> Option<Self::Item> {
        None
    }
}

impl<L: Iterator> Iterator for IdWithLayer<'_, L> {
    type Item = L::Item;

    fn next(&mut self) -> Option<Self::Item> {
        todo!()
    }
}
