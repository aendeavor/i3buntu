use crate::lib::{
	log::console::{self, stage_two},
	data::{
		PhaseResult,
		stage_one::Choices,
		stage_two::Programs}};
use super::general::dpo;
use std::{fs, path::Path, process::Command};
use serde_json;

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
	let mut error_code: u8 = 0;
	
	let mut destination = match std::env::current_dir() {
		Ok(dir) => dir,
		Err(_) => return dpo(120, 1, 3)
	};
	destination.push(Path::new("athena/resources/programs/programs.json"));
	
	let file_str = match fs::read_to_string(&destination) {
		Ok(file_str) => file_str,
		Err(_) => return dpo(121, 1, 3)
	};
	
	let mut programs: Programs = match serde_json::from_str(&file_str) {
		Ok(json_val) => json_val,
		Err(_) => return dpo(122, 1, 3)
	};
	
	for program in programs.audio {
		apt_install(&program);
	}
	// for (_, array) in json_val.entries_mut() {
	// 	if array.is_array() {
	// 		for index in 0..array.len() - 1 {
	// 			if let Some(program) = array.array_remove(index).as_str() {
	// 				if let Err(code) = apt_install(program) {
	// 					error_code = code;
	// 				}
	// 			}
	// 			// TODO remove
	// 			break;
	// 		}
	// 	}
	// }
	
	dpo(error_code, 1, 3)
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
	stage_two::install_program(program);
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
					stage_two::install_program_outcome(true);
					Ok(())
				},
				false => {
					// ! Could use some error log to logfile
					// use log::debug to get debug msg
					// (this is a non-fatal error)
					stage_two::install_program_outcome(false);
					Err(20)
				}
			}
			
		},
		Err(_) => {
			// ! Could use some error log to logfile
			// use log::debug to get debug msg
			// (this is a fatal/severe error)
			Err(21)
		}
	}
}
