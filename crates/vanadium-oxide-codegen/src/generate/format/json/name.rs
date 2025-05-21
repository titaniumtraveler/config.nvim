use serde::Serialize;
use std::{
    borrow::Cow,
    cmp::Ordering,
    fmt::{self, Display},
};

pub struct Name<'a>(Vec<Cow<'a, str>>);

impl Serialize for Name<'_> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        serializer.collect_str(self)
    }
}

impl Ord for Name<'_> {
    fn cmp(&self, other: &Self) -> Ordering {
        match self.0.len().cmp(&other.0.len()) {
            Ordering::Equal => self.0.cmp(&other.0),
            ord => ord,
        }
    }
}

impl PartialOrd for Name<'_> {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Eq for Name<'_> {}
impl PartialEq for Name<'_> {
    fn eq(&self, other: &Self) -> bool {
        self.0.eq(&other.0)
    }
}

impl<'a> From<&[Cow<'a, str>]> for Name<'a> {
    fn from(value: &[Cow<'a, str>]) -> Self {
        Name(value.to_owned())
    }
}

impl Display for Name<'_> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut iter = self.0.iter();
        let Some(first) = iter.next() else {
            return Ok(());
        };
        f.write_str(first)?;
        for i in iter {
            f.write_str("::")?;
            f.write_str(i)?;
        }
        Ok(())
    }
}
