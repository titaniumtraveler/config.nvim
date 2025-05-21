use crate::generate::{
    Chain, ChainExt, Layer, LayerExt,
    vec_entry::{Entry, VecEntryExt},
};
use std::marker::PhantomData;

pub struct Closure<T: ClosureType> {
    parent: <Self as Layer>::Parent,

    shared: T::Shared,
    up: T::Up,
    down: T::Down,
}

pub trait ClosureType: Sized
where
    Self::Down:,
{
    type Parent: Chain;
    type Shared;

    type Up: FnMut(&mut Self::Parent, &mut Self::Shared, Self::Val) -> Self::Iter;
    type Down: FnMut(&mut Self::Parent, &mut Self::Shared, &mut Self::Iter) -> Option<Self::Item>;

    type Val;
    type Iter;
    type Item;
}
impl<
    Parent: Chain,
    Shared,
    Up: FnMut(&mut Parent, &mut Shared, Val) -> Iter,
    Down: FnMut(&mut Parent, &mut Shared, &mut Iter) -> Option<Item>,
    Val,
    Iter,
    Item,
> ClosureType for ((Parent, (Shared, Up, Down), Val, Iter, Item),)
{
    type Parent = Parent;
    type Shared = Shared;

    type Up = Up;
    type Down = Down;

    type Val = Val;
    type Iter = Iter;
    type Item = Item;
}

impl<T: ClosureType> Chain for Closure<T> {
    type Val = T::Val;
    type Iter = T::Iter;
    type Item = T::Item;

    fn upstream(&mut self, in_val: Self::Val) -> Self::Iter {
        (self.up)(&mut self.parent, &mut self.shared, in_val)
    }

    fn next(&mut self, iter: &mut Self::Iter) -> Option<Self::Item> {
        (self.down)(&mut self.parent, &mut self.shared, iter)
    }
}

impl<T: ClosureType> Layer for Closure<T> {
    type Init = (T::Shared, T::Up, T::Down);
    type Parent = T::Parent;

    fn create_layer(parent: Self::Parent, (shared, up, down): Self::Init) -> Self {
        Self {
            parent,
            shared,
            up,
            down,
        }
    }
}

struct Void<Val, Item>(PhantomData<(Val, Item)>);
impl<Val, Item> Chain for Void<Val, Item> {
    type Val = Val;
    type Iter = ();
    type Item = Item;

    fn upstream(&mut self, _: Self::Val) -> Self::Iter {}

    fn next(&mut self, (): &mut Self::Iter) -> Option<Self::Item> {
        None
    }
}

struct Rec<Iter>(Vec<Iter>);

fn t<P, Item: 'static>(parent: P, mut val: Item)
where
    P: Chain<Iter = Item, Item = Item>,
{
    parent
        .layer::<Closure<(_,)>>((
            (), //
            |parent: &mut P, shared: &mut (), val: &mut Item| todo!(),
            |parent: &mut P, _, iter: &mut P::Iter| {
                //
                parent.next(iter)
            },
        ))
        .layer::<Closure<(_,)>>((
            (),
            |parent, _, val| Rec(vec![parent.upstream(val)]),
            |parent, _, iter| {
                let stack = &mut iter.0;
                loop {
                    let Entry::Occupied(mut entry) = stack.pop_entry() else {
                        return None;
                    };

                    let Some(mut val) = parent.next(entry.get_mut()) else {
                        entry.remove();
                        continue;
                    };

                    // let _ = parent.upstream(&mut val);
                    break Some(val);
                }
            },
        ))
        .with_val(&mut val);

    todo!()
}
