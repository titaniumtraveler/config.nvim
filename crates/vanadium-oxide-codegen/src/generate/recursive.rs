use crate::generate::{
    Chain,
    vec_entry::{Entry, VecEntryExt},
};

pub struct Recursive<C: Chain, I> {
    chain: C,
    _marker2: PhantomData<I>,
}

pub struct RecursiveIter<Iter>(Vec<Iter>);

impl<C, I> Chain for Recursive<C, I>
where
    for<'v> C: Chain<Item<'v> = I, Val<'v> = &'v mut I, Iter = I>,
{
    type Val<'v> = &'v mut I;
    type Iter = RecursiveIter<C::Iter>;
    type Item<'v> = I;

    #[allow(clippy::unused_unit)]
    fn upstream<'a>(&mut self, in_val: &'a mut I) -> Self::Iter
    where
        I: 'a,
    {
        RecursiveIter(vec![self.chain.upstream(in_val)])
    }

    fn next(&mut self, iter: &mut Self::Iter) -> Option<Self::Item> {
        let stack = &mut iter.0;
        loop {
            let Entry::Occupied(mut entry) = stack.pop_entry() else {
                return None;
            };

            let Some(mut val) = self.chain.next(entry.get_mut()) else {
                entry.remove();
                continue;
            };

            let iter = self.chain.upstream(&mut val);
            drop(iter);
            break Some(val);
        }
    }
}

impl<C, I> Layer for Recursive<'_, C, I>
where
    for<'a> C: Chain<Item = I, Val = I>,
{
    type Init = ();
    type Parent = C;

    fn create_layer(chain: Self::Parent, (): Self::Init) -> Self {
        Self {
            chain,
            _marker: PhantomData,
        }
    }
}
