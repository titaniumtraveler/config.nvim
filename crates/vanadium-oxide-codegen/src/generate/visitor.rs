// mod empty;
// mod id;
// mod passthrough;

// mod dedup_by_pointer;

// mod metatable_values;
// mod table;
// mod table_recursive;

trait LayerExt: Iterator {
    fn layer<L>(self, layer: L) -> Layer<Self, L>
    where
        Self: Sized,
    {
        Layer { iter: self, layer }
    }
}

pub struct Layer<I, L> {
    iter: I,
    layer: L,
}

pub struct LayerDown<L, I> {
    layer: L,
    iter: I,
}

pub struct LayerUp<L, I> {
    layer: L,
    iter: I,
}

#[test]
fn t() {
    let mut input = (0..5).into_iter();
}
