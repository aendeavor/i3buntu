use athena::{
	controller::{self, dpo},
	log::console,
	structures::{Choices, PhaseResult},
};
use std::{fs, process::Command};
use serde_json::{self, Value};
use colored::Colorize;

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
	console::print_phase_description(1, 3, "Installing Programs");
	
	let path = controller::get_resource_path("athena/resources/programs/programs.json", 1, 3)?;
	
	let json = match fs::read_to_string(path) {
		Ok(json_str) => json_str,
		Err(_) => return dpo(111, 1, 2)
	};
	
	let json_tree: Value = match serde_json::from_str(&json) {
		Ok(json_tree) => json_tree,
		Err(_) => return dpo(122, 1, 3)
	};
	
	// let error_code = match recurse_json(&json_tree) {
	// 	Ok(_) => 0,
	// 	Err(code) => code
	// };
	
	let error_code = 0;
	
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
	console::print_phase_description(2, 3, "Installing User-Choices");
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
	
	if choices.vsc {
	
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
	console::print_phase_description(3, 3, "Removing unnecessary packages");
	dpo(0, 3, 3)
}

/// # APT
///
/// Installs a program with apt.
///
fn apt_install(program: &str) -> Result<(), u8>
{
	console::print_sub_phase_description("     :: Installing ".to_owned() + program);
	
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
					console::print_sub_phase_description("  ✔\n".green());
					Ok(())
				},
				false => {
					// ! TODO Could use some error log to logfile
					// use log::debug to get debug msg
					// (this is a non-fatal error)
					console::print_sub_phase_description("  ✘\n".red());
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
