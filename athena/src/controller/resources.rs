use super::super::{data::structures::PhaseError, log::console};
use std::{ffi::OsStr, process::Command};
use colored::Colorize;
use dirs_next;
use serde_json::{self, Value};

/// # Local resource path
///
/// Provides
pub fn get_resource_path(to_append: &str, cs: u8, sct: u8) -> Result<String, PhaseError>
{
    if let Ok(path) = std::env::current_dir() {
        if let Some(path) = path.to_str() {
            let mut path = String::from(path);
            path.push('/');
            path.push_str(to_append);
            return Ok(path);
        }
    }

    let result = PhaseError::HardError(190);
    console::finalize_phase(
	    cs,
	    sct,
	    Some(&result));

    Err(result)
}

/// # File copy with `rsync`
///
/// Copies files by executing `rsync`.
fn sync_files<S, T>(from: S, to: &T, sudo: bool) -> Option<u8>
	where S: AsRef<OsStr>,
	      T: AsRef<OsStr> + ?Sized
{
	let mut command = if sudo {
		Command::new("sudo")
	} else {
		Command::new("rsync")
	};
	
	if sudo { command.arg("rsync"); };
	
	return if let Err(_) = command
		.arg("-azr")
		.arg("--dry-run")
		.arg(from)
		.arg(to)
		.output()
	{
		console::print_sub_phase_description("  ✘\n".yellow());
		Some(30)
	} else {
		console::print_sub_phase_description("  ✔\n".green());
		None
	};
}

/// # Wrapping file synchronization
///
/// Wraps `sync_files()` for easier access.
pub fn drive_sync<R, T>(
	description: R,
	from: &str,
	to: &T,
	sudo: bool,
	exit_code: &mut u8) -> Result<(), PhaseError>
	where R: std::fmt::Display,
	      T: AsRef<OsStr> + ?Sized
{
	console::print_sub_phase_description(description);
	
	let mut base = String::from("athena/resources/config/");
	base.push_str(from);
	
	let mut backup_location = get_home();
	backup_location.push_str("/.backup/");

	// current backup solution
	sync_files(to, &backup_location, sudo);
	
	if let Some(ec) = sync_files(
		&super::get_resource_path(&base, 1, 3)?,
		to,
		sudo)
	{
		*exit_code = ec;
	}
	
	Ok(())
}

/// # Parses & processes JSON
///
/// Recursing through the given tree / enum of JSON
/// values until every leaf has been used.
pub fn recurse_json<T>(value: &serde_json::Value, subroutine: &T) -> Result<(), u8>
	where T: Fn(&str) -> Result<(), u8>
{
	let mut exit_code: u8 = 0;
	
	match value
	{
		Value::Object(obj) => {
			for (_, key) in obj.iter() {
				if let Err(code) = recurse_json(key, subroutine) {
					exit_code = code;
				}
			}
		},
		Value::Array(vec) => {
			for entry in vec {
				if let Err(code) = recurse_json(entry, subroutine) {
					exit_code = code;
				}
			}
		},
		Value::String(program) => {
			if let Err(code) = subroutine(&program) {
				exit_code = code;
			}
		},
		_ => ()
	};
	
	if exit_code == 0 { Ok(()) } else { Err(exit_code) }
}

/// # APT
///
/// Installs a program with APT.
///
pub fn apt_install(program: &str) -> Result<(), u8>
{
	console::print_sub_phase_description("     :: Installing ".to_owned() + program);
	
	match Command::new("sudo")
		.arg("apt-get")
		.arg("install")
		.arg("--yes")
		.arg("--allow-unauthenticated")
		.arg("--allow-downgrades")
		.arg("--allow-remove-essential")
		.arg("--allow-change-held-packages")
		.arg(program)
		.output()
	{
		Ok(output) => {
			match output.status.success() {
				true => {
					console::print_sub_phase_description("  ✔\n".green());
					Ok(())
				},
				false => {
					console::print_sub_phase_description("  ✘\n".red());
					Err(20)
				}
			}
		},
		Err(_) => Err(21)
	}
}

pub fn vsc_extension_install(extension: &str) -> Result<(), u8>
{
	match Command::new("code")
		.arg("--install-extension")
		.arg(extension)
		.output() {
		Ok(output) => {
			match output.status.success() {
				true => Ok(()),
				false => Err(22)
			}
		},
		Err(_) => Err(23)
	}
}

pub fn get_home() -> String
{
	if let Some(home) = dirs_next::home_dir() {
		if let Some(home) = home.to_str() {
			return String::from(home)
		}
	}
	
	String::from("~")
}
