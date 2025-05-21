#![allow(dead_code)]
use Entry::*;

pub trait VecEntryExt<T> {
    fn push_entry(&mut self) -> VacantEntry<'_, T>;
    fn pop_entry(&mut self) -> Entry<'_, T>;
}

impl<T> VecEntryExt<T> for Vec<T> {
    fn push_entry(&mut self) -> VacantEntry<'_, T> {
        // Reserve space for our entry!
        // Otherwise that would be allow for a out-of-bounds write from safe code!
        self.reserve(1);
        VacantEntry {
            index: self.len(),
            vec: self,
        }
    }

    fn pop_entry(&mut self) -> Entry<'_, T> {
        if self.is_empty() {
            self.reserve(1);
            Vacant(VacantEntry {
                index: 0,
                vec: self,
            })
        } else {
            Occupied(OccupiedEntry {
                index: self.len() - 1,
                vec: self,
            })
        }
    }
}

pub enum Entry<'a, T> {
    Vacant(VacantEntry<'a, T>),
    Occupied(OccupiedEntry<'a, T>),
}

impl<'a, T> Entry<'a, T> {
    pub fn or_insert(self, default: T) -> &'a mut T {
        match self {
            Vacant(entry) => entry.insert(default),
            Occupied(entry) => entry.into_mut(),
        }
    }
    pub fn or_insert_with<F: FnOnce() -> T>(self, default: F) -> &'a mut T {
        match self {
            Vacant(entry) => entry.insert(default()),
            Occupied(entry) => entry.into_mut(),
        }
    }
    pub fn and_modify<F: FnOnce(&mut T)>(self, f: F) -> Self {
        match self {
            Occupied(mut entry) => {
                f(entry.get_mut());
                Self::Occupied(entry)
            }
            entry => entry,
        }
    }
    pub fn insert_entry(self, value: T) -> OccupiedEntry<'a, T> {
        match self {
            Occupied(mut entry) => {
                entry.insert(value);
                entry
            }
            Vacant(entry) => entry.insert_entry(value),
        }
    }
}

impl<'a, T: Default> Entry<'a, T> {
    pub fn or_default(self) -> &'a mut T {
        match self {
            Vacant(entry) => entry.insert(Default::default()),
            Occupied(entry) => entry.into_mut(),
        }
    }
}

pub struct VacantEntry<'a, T> {
    vec: &'a mut Vec<T>,
    index: usize,
}

impl<'a, T> VacantEntry<'a, T> {
    pub fn insert(self, value: T) -> &'a mut T {
        self.insert_entry(value).into_mut()
    }

    pub fn insert_entry(self, value: T) -> OccupiedEntry<'a, T> {
        unsafe {
            self.vec.as_mut_ptr().add(self.index).write(value);
            self.vec.set_len(self.index);
            OccupiedEntry {
                vec: self.vec,
                index: self.index,
            }
        }
    }
}

pub struct OccupiedEntry<'a, T> {
    vec: &'a mut Vec<T>,
    index: usize,
}

impl<'a, T> OccupiedEntry<'a, T> {
    pub fn get(&self) -> &T {
        unsafe { &*self.vec.as_ptr().add(self.index) }
    }
    pub fn get_mut(&mut self) -> &mut T {
        unsafe { &mut *self.vec.as_mut_ptr().add(self.index) }
    }
    pub fn into_mut(self) -> &'a mut T {
        unsafe { &mut *self.vec.as_mut_ptr().add(self.index) }
    }
    pub fn insert(&mut self, value: T) -> T {
        unsafe { self.vec.as_mut_ptr().add(self.index).replace(value) }
    }
    pub fn remove(self) -> T {
        unsafe {
            self.vec.set_len(self.index - 1);
            self.vec.as_mut_ptr().add(self.index).read()
        }
    }
}
