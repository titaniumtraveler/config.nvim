use crate::generate::{Chain, Layer};

pub struct Filter<C, F> {
    chain: C,
    f: F,
}

impl<C, F> Chain for Filter<C, F>
where
    C: Chain,
    F: FnMut(&C::Item) -> bool,
{
    type Val = C::Val;
    type Iter = C::Iter;
    type Item = C::Item;

    fn upstream(&mut self, in_val: Self::Val) -> Self::Iter {
        self.chain.upstream(in_val)
    }

    fn next(&mut self, iter: &mut Self::Iter) -> Option<Self::Item> {
        self.chain.next(iter).filter(&mut self.f)
    }
}

impl<C, F> Layer for Filter<C, F>
where
    C: Chain,
    F: FnMut(&<C as Chain>::Item) -> bool,
{
    type Init = F;
    type Parent = C;

    fn create_layer(chain: Self::Parent, init: Self::Init) -> Self {
        Self { chain, f: init }
    }
}
