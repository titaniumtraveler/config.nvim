use crate::generate::Chain;
use mlua::Value;

use std::marker::PhantomData;

pub struct Children<'a, C, V> {
    chain: C,
    val: PhantomData<&'a V>,
}

impl<'lua, C, V, T> Chain for Children<'lua, C, V>
where
    for<'a> C: Chain<Val<'a> = T>,
    V: AsRef<Value<'lua>>,
{
    type Val<'a> = T;
    type Iter = ChildrenIter<C>;
    type Item = (Value<'lua>, Value<'lua>);

    fn upstream(&mut self, val: Self::Val<'_>) -> Self::Iter {
        ChildrenIter(self.chain.upstream(val))
    }

    fn next(&mut self, iter: &mut Self::Iter) -> Option<Self::Item> {
        let item = self.chain.next(&mut iter.0)?;
        todo!()
    }
}

pub struct ChildrenIter<C: Chain>(C::Iter);
