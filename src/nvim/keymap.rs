use std::{borrow::Cow, collections::BTreeMap};

use keymap_rhs::Rhs;

pub use self::keymap_mode::{Mode, mode};

mod keymap_mode;
mod keymap_rhs;

pub enum KeymapOrKeys {
    Keymap(Keymap),
    Key(Key),
}

pub struct Keymap {
    map: BTreeMap<Cow<'static, str>, KeymapOrKeys>,
}

impl Keymap {
    pub fn new() -> Self {
        Self {
            map: BTreeMap::default(),
        }
    }

    pub fn key(mut self, lhs: impl Into<Cow<'static, str>>, key: KeyBuilder) -> Self {
        self.map.insert(lhs.into(), KeymapOrKeys::Key(key.0));
        self
    }
}

pub struct Key {
    keys: Vec<(Mode, Rhs)>,
}

pub struct KeyBuilder(Key);

impl Key {
    pub fn new() -> KeyBuilder {
        KeyBuilder::new()
    }

    pub fn mode(mode: Mode, rhs: impl Into<Rhs>) -> KeyBuilder {
        KeyBuilder::new().mode(mode, rhs)
    }
}

impl KeyBuilder {
    pub fn new() -> Self {
        KeyBuilder(Key { keys: Vec::new() })
    }

    pub fn mode(mut self, mode: Mode, rhs: impl Into<Rhs>) -> Self {
        self.0.keys.push((mode, rhs.into()));
        self
    }
}
