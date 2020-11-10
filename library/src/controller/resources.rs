use super::super::{
	data::structures::PhaseError,
	log::console,
};
use std::{
	ffi::OsStr,
	process::Command,
};
use colored::Colorize;
use serde_json::{
	self,
	Value,
};

/// # Local resource path
///
/// Provides the resource file path to
/// the caller.
///
/// ## Errors
///
/// If the current directory cannot be obtained
/// a critical error is issued.
pub fn get_resource_path(
	to_append: &str,
	cs: u8,
	sct: u8,
) -> Result<String, PhaseError>
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
	console::finalize_phase(cs, sct, Some(&result));

	Err(result)
}

/// # File copy with `rsync`
///
/// Copies files by executing `rsync`.
fn sync_files<S, T>(
	from: S,
	to: &T,
	sudo: bool,
	log: bool,
) -> Option<u8>
where
	S: AsRef<OsStr>,
	T: AsRef<OsStr> + ?Sized,
{
	let mut command = if sudo {
		Command::new("sudo")
	} else {
		Command::new("rsync")
	};

	if sudo {
		command.arg("rsync");
	};

	return if command.arg("-azr").arg(from).arg(to).output().is_err()
	{
		if log {
			console::pspd("  \u{2718}\n".yellow());
		}
		Some(30)
	} else {
		if log {
			console::pspd("  \u{2714}\n".green());
		}
		None
	};
}

/// # Wrapping file synchronization
///
/// Wraps `sync_files()` for easier access.
///
/// ## Errors
///
/// No errors are issued by this function.
pub fn drive_sync<R, T>(
	description: R,
	from: &str,
	to: &T,
	sudo: bool,
	exit_code: &mut u8,
) -> Result<(), PhaseError>
where
	R: std::fmt::Display,
	T: AsRef<OsStr> + ?Sized,
{
	console::pspd(description);

	let mut base = String::from("library/resources/config/");
	base.push_str(from);

	if Command::new("sudo")
		.args(&["mkdir", "-p", "/backup"])
		.output()
		.is_ok()
	{
		// current backup solution
		sync_files(to, "/backup/", true, false);
	} else {
		*exit_code = 70;
	}

	if let Some(ec) = sync_files(
		&super::get_resource_path(&base, 1, 3)?,
		to,
		sudo,
		true,
	) {
		if *exit_code == 0 {
			*exit_code = ec;
		}
	}

	Ok(())
}

/// # Parses & processes JSON
///
/// Recursing through the given tree / enum of JSON
/// values until every leaf has been used.
///
/// ## Errors
///
/// Errors are returned if the applied programs issues
/// a non-zero exit code.
pub fn recurse_json<T>(
	value: &serde_json::Value,
	subroutine: &T,
) -> Result<(), u8>
where
	T: Fn(&str) -> Result<(), u8>,
{
	let mut exit_code: u8 = 0;

	match value {
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
			if let Err(code) = subroutine(program) {
				exit_code = code;
			}
		},
		_ => (),
	};

	if exit_code == 0 {
		Ok(())
	} else {
		Err(exit_code)
	}
}

/// # APT
///
/// Installs a program with APT.
///
/// ## Errors
///
/// If the installation via APT is not successful,
/// an error is returned.
pub fn apt_install(program: &str) -> Result<(), u8>
{
	console::pspd("     :: Installing ".to_owned() + program);

	match Command::new("sudo")
		.arg("apt-get")
		.arg("install")
		.arg("--yes")
		.arg("--allow-unauthenticated")
		.arg("--allow-downgrades")
		.arg("--allow-remove-essential")
		.arg("--allow-change-held-packages")
		.arg("--no-install-recommends")
		.arg(program)
		.output()
	{
		Ok(output) => {
			if output.status.success() {
				console::pspd("  \u{2714}\n".green());
				Ok(())
			} else {
				console::pspd("  \u{2718}\n".red());
				Err(20)
			}
		},
		Err(_) => Err(21),
	}
}

/// # Install a VS Code Extension
///
/// Issues the code command to install an extension.
///
/// ## Errors
///
/// If the installation is unsuccessful, an error is
/// returned.
pub fn vsc_extension_install(extension: &str) -> Result<(), u8>
{
	match Command::new("code")
		.arg("--install-extension")
		.arg(extension)
		.output()
	{
		Ok(output) => {
			if output.status.success() {
				Ok(())
			} else {
				Err(22)
			}
		},
		Err(_) => Err(23),
	}
}

pub fn get_home() -> String
{
	if let Some(home) = dirs_next::home_dir() {
		if let Some(home) = home.to_str() {
			return String::from(home);
		}
	}

	String::from("~")
}
