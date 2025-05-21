use crate::generate::Chain;

pub struct ChainWithVal<C: Chain> {
    pub chain: C,
    pub iter: C::Iter,
}

impl<'a, C: Chain> Iterator for ChainWithVal<C> {
    type Item = C::Item;

    fn next(&mut self) -> Option<Self::Item> {
        self.chain.next(&mut self.iter)
    }
}

impl<'a, C: Chain> Chain for ChainWithVal<C> {
    type Val = ();

    type Iter = ();
    type Item = C::Item;

    fn upstream(&mut self, (): Self::Val) -> Self::Iter {}
    fn next(&mut self, (): &mut Self::Iter) -> Option<Self::Item> {
        Iterator::next(self)
    }
}
