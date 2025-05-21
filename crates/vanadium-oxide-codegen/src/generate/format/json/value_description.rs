use crate::format::json::id::Id;
use mlua::{FunctionInfo, String, Value};
use serde::Serialize;

pub use self::remote_def::FunctionInfoDef;

#[derive(Serialize)]
pub enum ValueDescription<'a> {
    Nil,
    Boolean(bool),
    LightUserData(Id),
    Integer(i64),
    Number(f64),
    String(String<'a>),
    Table {
        id: Id,
        metatable: Option<Id>,
    },
    Function {
        id: Id,
        #[serde(with = "FunctionInfoDef")]
        info: FunctionInfo,
        environment: Option<Id>,
    },
    Thread {
        id: Id,
    },
    UserData {
        id: Id,
    },
}

impl<'a> TryFrom<&Value<'a>> for ValueDescription<'a> {
    type Error = mlua::Error;

    fn try_from(value: &Value<'a>) -> Result<Self, Self::Error> {
        use ValueDescription::*;

        Ok(match value {
            Value::Nil => Nil,
            Value::Boolean(b) => Boolean(*b),
            Value::LightUserData(light_user_data) => LightUserData(light_user_data.0.into()),
            Value::Integer(i) => Integer(*i),
            Value::Number(n) => Number(*n),
            Value::String(str) => String(str.clone()),
            Value::Table(table) => Table {
                id: table.to_pointer().into(),
                metatable: table.get_metatable().map(|table| table.to_pointer().into()),
            },
            Value::Function(function) => Function {
                id: function.to_pointer().into(),
                info: function.info(),
                environment: function.environment().map(|env| env.to_pointer().into()),
            },
            Value::Thread(thread) => Thread {
                id: thread.to_pointer().into(),
            },
            Value::UserData(any_user_data) => UserData {
                id: any_user_data.to_pointer().into(),
            },
            Value::Error(error) => return Err(error.clone()),
        })
    }
}

mod remote_def {
    use mlua::FunctionInfo;
    use serde::Serialize;

    #[derive(Serialize)]
    #[serde(remote = "FunctionInfo")]
    pub struct FunctionInfoDef {
        pub name: Option<std::string::String>,
        pub name_what: Option<&'static str>,
        pub what: &'static str,
        pub source: Option<String>,
        pub short_src: Option<String>,
        pub line_defined: Option<usize>,
        pub last_line_defined: Option<usize>,
    }
}
