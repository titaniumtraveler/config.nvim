use crate::generate::visitor::Layer;

pub struct Empty;

impl Layer for Empty {
    type Iter = Empty;
}

impl Iterator for Empty {
    type Item = ();

    fn next(&mut self) -> Option<Self::Item> {
        None
    }
}
