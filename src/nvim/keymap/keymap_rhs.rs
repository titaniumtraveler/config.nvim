use bitflags::bitflags;
use std::borrow::Cow;

pub struct Rhs<F = fn()> {
    rhs: RhsInner<F>,
    desc: Option<Cow<'static, str>>,
    opts: RhsOpts,
}

impl<F> Default for Rhs<F> {
    fn default() -> Self {
        Self {
            rhs: RhsInner::Rhs("".into()),
            desc: None,
            opts: RhsOpts::DEFAULT,
        }
    }
}

impl Rhs {
    pub fn rhs(rhs: impl Into<Cow<'static, str>>) -> Self {
        Self {
            rhs: RhsInner::Rhs(rhs.into()),
            ..Default::default()
        }
    }
    pub fn callback<F>(callback: F) -> Rhs<F> {
        Rhs {
            rhs: RhsInner::Callback(callback),
            ..Default::default()
        }
    }
}

pub trait IntoRhs
where
    Self: Sized,
    RhsInner: From<Self>,
{
}

impl<T> From<T> for Rhs
where
    T: IntoRhs,
    RhsInner: From<T>,
{
    fn from(value: T) -> Self {
        Rhs {
            rhs: value.into(),
            ..Default::default()
        }
    }
}

impl<T, D> From<(T, D)> for Rhs
where
    Cow<'static, str>: From<D>,
    T: IntoRhs,
    RhsInner: From<T>,
{
    fn from(value: (T, D)) -> Self {
        Rhs {
            rhs: value.0.into(),
            desc: Some(value.1.into()),
            ..Default::default()
        }
    }
}

impl<T> From<(T, RhsOpts)> for Rhs
where
    T: IntoRhs,
    RhsInner: From<T>,
{
    fn from(value: (T, RhsOpts)) -> Self {
        Rhs {
            rhs: value.0.into(),
            opts: value.1,
            ..Default::default()
        }
    }
}

impl<T, D> From<(T, RhsOpts, D)> for Rhs
where
    Cow<'static, str>: From<D>,
    T: IntoRhs,
    RhsInner: From<T>,
{
    fn from(value: (T, RhsOpts, D)) -> Self {
        Rhs {
            rhs: value.0.into(),
            opts: value.1,
            desc: Some(value.2.into()),
        }
    }
}

impl IntoRhs for Cow<'static, str> {}
impl From<Cow<'static, str>> for RhsInner {
    fn from(value: Cow<'static, str>) -> Self {
        RhsInner::Rhs(value)
    }
}

impl IntoRhs for &'static str {}
impl From<&'static str> for RhsInner {
    fn from(value: &'static str) -> Self {
        RhsInner::Rhs(value.into())
    }
}

impl IntoRhs for String {}
impl From<String> for RhsInner {
    fn from(value: String) -> Self {
        RhsInner::Rhs(value.into())
    }
}

enum RhsInner<F = fn()> {
    Rhs(Cow<'static, str>),
    Callback(F),
}

bitflags! {
    pub struct RhsOpts: u8 {
        const REMAP            = 1 << 0;
        const WAIT             = 1 << 1;
        const SILENT           = 1 << 2;
        const SCRIPT           = 1 << 3;
        const EXPR             = 1 << 4;
        const UNIQUE           = 1 << 5;
        const REPLACE_KEYCODES = 1 << 6;

        const DEFAULT          = RhsOpts::REMAP.bits() | RhsOpts::WAIT.bits();
    }
}

pub mod rhs {
    use super::RhsOpts;

    pub const REMAP: RhsOpts = RhsOpts::REMAP;
    pub const WAIT: RhsOpts = RhsOpts::WAIT;
    pub const SILENT: RhsOpts = RhsOpts::SILENT;
    pub const SCRIPT: RhsOpts = RhsOpts::SCRIPT;
    pub const EXPR: RhsOpts = RhsOpts::EXPR;
    pub const UNIQUE: RhsOpts = RhsOpts::UNIQUE;
    pub const REPLACE_KEYCODES: RhsOpts = RhsOpts::REPLACE_KEYCODES;

    pub const DEFAULT: RhsOpts = RhsOpts::DEFAULT;
}
