use crate::generate::{Chain, ChainWithVal, Layer};

pub mod with_val;

pub trait ChainExt: Chain {
    fn into_iter(mut self) -> ChainWithVal<Self>
    where
        Self: Chain<Val = ()>,
        for<'a> <Self as Chain>::Iter: 'a,
    {
        ChainWithVal {
            iter: self.upstream(()),
            chain: self,
        }
    }

    fn with_val(mut self, val: Self::Val) -> ChainWithVal<Self>
    where
        for<'a> <Self as Chain>::Iter: 'a,
    {
        ChainWithVal {
            iter: self.upstream(val),
            chain: self,
        }
    }
}
impl<T: Chain> ChainExt for T {}

pub trait LayerExt: Sized {
    fn layer<'a, C>(self, init: C::Init) -> C
    where
        C: Layer<Parent = Self>,
    {
        C::create_layer(self, init)
    }
}
impl<T: Chain> LayerExt for T {}
