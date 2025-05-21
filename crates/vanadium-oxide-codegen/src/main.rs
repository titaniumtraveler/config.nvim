use cargo_metadata::Message;
use std::{
    env::consts::DLL_SUFFIX,
    ffi::OsStr,
    os::unix::ffi::OsStrExt,
    process::{self, Command, Stdio},
};
use vanadium_oxide_codegen::{
    PLUGIN_ENTRY,
    command::{self, LoadLibrary},
};

fn main() {
    let mut command = Command::new("cargo")
        .args(["build", "--message-format=json-render-diagnostics"])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap();

    let reader = std::io::BufReader::new(command.stdout.take().unwrap());
    let lib_path = cargo_metadata::Message::parse_stream(reader)
        .filter_map(|message| match message.unwrap() {
            Message::CompilerArtifact(artifact)
                if artifact.manifest_path == env!("CARGO_MANIFEST_PATH")
                    && artifact.target.is_cdylib() =>
            {
                artifact
                    .filenames
                    .into_iter()
                    .find(|name| name.as_str().ends_with(DLL_SUFFIX))
            }
            _ => None,
        })
        .next()
        .unwrap();
    command.wait().expect("Couldn't get cargo's exit status");

    let mut command = command::command(LoadLibrary {
        lib_path: lib_path.as_std_path(),
        load_function: OsStr::from_bytes(PLUGIN_ENTRY),
    });
    command.env("LUA_CPATH", lib_path);
    match command.status() {
        Ok(exit) => process::exit(exit.code().unwrap_or(0)),
        Err(err) => {
            eprintln!("{err}");
            process::exit(0)
        }
    }
}
