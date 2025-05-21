pub use self::ext::{ChainExt, LayerExt, with_val::ChainWithVal};

mod ext;

mod closure;
// mod filter;
// mod recursive;

mod vec_entry;

pub trait Chain: Sized {
    type Val;
    type Iter;
    type Item;

    fn upstream(&mut self, val: Self::Val) -> Self::Iter;
    fn next(&mut self, iter: &mut Self::Iter) -> Option<Self::Item>;
}

pub trait Layer: Chain + Sized {
    type Init;

    type Parent: Chain;
    fn create_layer(chain: Self::Parent, init: Self::Init) -> Self;
}
