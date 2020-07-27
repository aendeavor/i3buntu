use athena::{console, Choices, dpo, PhaseResult};
use std::process::Command;
use serde_json::{self, Value};

/// # Base System Extension
///
/// Installs ***APOLLO***'s base packages onto
/// the OS.
///
/// ## Context
///
/// Stage: 2,
/// Phase: 1 / 3
pub fn install_base() -> PhaseResult
{
	console::phase_init(1, 3, "Installing Programs");
	
	let path = athena::get_resource_path("athena/resources/programs/programs.json", 1, 3)?;
	
	let json_tree: Value = match serde_json::from_str(&path) {
		Ok(json_tree) => json_tree,
		Err(_) => return dpo(122, 1, 3)
	};
	
	let error_code = match recurse_json(&json_tree) {
		Ok(_) => 0,
		Err(code) => code
	};
	
	dpo(error_code, 1, 3)
}

/// # Parses JSON
///
/// Recursing through the given tree / enum of JSON
/// values until every leaf has been used.
fn recurse_json(value: &serde_json::Value) -> Result<(), u8>
{
	let mut exit_code: u8 = 0;
	match value
	{
		Value::Object(obj) => {
			for (_, key) in obj.iter() {
				if let Err(code) = recurse_json(key) {
					exit_code = code;
				}
			}
		},
		Value::Array(vec) => {
			for entry in vec {
				if let Err(code) = recurse_json(entry) {
					exit_code = code;
				}
			}
		},
		Value::String(program) => {
			if let Err(code) = apt_install(&program) {
				exit_code = code;
			}
		},
		_ => ()
	};
	
	if exit_code == 0 { Ok(()) } else { Err(exit_code) }
}

/// # User Choices
///
/// Installs user choices.
///
/// ## Context
///
/// Stage. 2,
/// Phase: 2 / 3
pub fn install_choices(choices: &Choices) -> PhaseResult
{
	console::phase_init(2, 3, "Installing User-Choices");
	let mut exit_code = 0;
	
	for program in *choices {
		if let Err(ec) = apt_install(program) {
			if ec != exit_code {
				if exit_code == 0 {
					exit_code = ec;
				} else {
					exit_code = 25;
				}
			}
		}
	}
	
	dpo(exit_code, 2, 3)
}

/// # No Uselessness
///
/// Removes all packages deemed unnecessary.
///
///
pub fn remove_unnecessary() -> PhaseResult
{
	console::phase_init(3, 3, "Removing unnecessary packages");
	dpo(0, 3, 3)
}

/// # APT
///
/// Installs a program with apt.
///
fn apt_install(program: &str) -> Result<(), u8>
{
	console::stage_two::install_program(program);
	match Command::new("sudo")
		.arg("apt")
		.arg("show")
		// .arg("--yes")
		// .arg("--allow-unauthenticated")
		// .arg("--allow-downgrades")
		// .arg("--allow-remove-essential")
		// .arg("--allow-change-held-packages")
		.arg(program)
		.output() {
		Ok(output) => {
			match output.status.success() {
				true => {
					console::stage_two::install_program_outcome(true);
					Ok(())
				},
				false => {
					// ! TODO Could use some error log to logfile
					// use log::debug to get debug msg
					// (this is a non-fatal error)
					console::stage_two::install_program_outcome(false);
					Err(20)
				}
			}
			
		},
		Err(_) => {
			// ! TODO Could use some error log to logfile
			// use log::debug to get debug msg
			// (this is a fatal/severe error)
			Err(21)
		}
	}
}
