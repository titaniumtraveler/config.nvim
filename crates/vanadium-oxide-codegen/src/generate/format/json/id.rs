use mlua::Value;
use serde::Serialize;
use std::{
    ffi::c_void,
    fmt::{self, Display},
};

#[derive(Eq, Ord, PartialEq, PartialOrd, Clone, Copy)]
pub struct Id(pub u64);

impl From<&Value<'_>> for Id {
    fn from(value: &Value) -> Self {
        Id(value.to_pointer() as u64)
    }
}

impl From<*const c_void> for Id {
    fn from(value: *const c_void) -> Self {
        Self(value as u64)
    }
}

impl From<*mut c_void> for Id {
    fn from(value: *mut c_void) -> Self {
        Self(value as u64)
    }
}

impl Serialize for Id {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        let ptr = self.0;
        if serializer.is_human_readable() {
            serializer.collect_str(&format_args!("{ptr:#016x}"))
        } else {
            serializer.serialize_u64(ptr)
        }
    }
}

impl Display for Id {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{ptr:#016x}", ptr = self.0)
    }
}
