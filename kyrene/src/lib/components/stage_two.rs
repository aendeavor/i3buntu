use athena::{
	controller::{self,
	             dpo,
	             apt_install,
	             get_home,
	             recurse_json,
	             vsc_extension_install},
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
	console::print_phase_description(1, 4, "Installing Programs");
	
	let path = controller::get_resource_path("athena/resources/packages/packages.json", 1, 3)?;
	
	let json = match fs::read_to_string(path) {
		Ok(json_str) => json_str,
		Err(_) => return dpo(121, 1, 4)
	};
	
	let _json_tree: Value = match serde_json::from_str(&json) {
		Ok(json_tree) => json_tree,
		Err(_) => return dpo(122, 1, 4)
	};
	
	// let error_code = match recurse_json(&json_tree, &apt_install) {
	// 	Ok(_) => 0,
	// 	Err(code) => code
	// };
	
	let error_code = 0;
	
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
	console::print_phase_description(2, 4, "Installing User-Choices");
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
		console::print_sub_phase_description("     :: Installing Visual Studio Code");
		match Command::new("sudo")
			.arg("snap")
			.arg("install")
			.arg("code")
			.arg("--classic")
			.output() {
			Ok(output) => {
				match output.status.success() {
					true => console::print_sub_phase_description("  ✔\n".green()),
					false => {
						println!("{:?}", output);
						console::print_sub_phase_description("  ✘\n".red());
						exit_code = 26;
					}
				}
			}
			Err(_) => exit_code = 27
		}
	}
	
	if choices.dock {
		console::print_sub_phase_description("     :: Installing Docker Compose");
		let mut local_ec = 0;
		
		if let Err(_) = apt_install("docker.io") {
			local_ec = 1;
		}
		
		if let Ok(_) = Command::new("sudo")
			.arg("./athena/scripts/rd.sh")
			.arg("--docker-compose")
			.output()
		{
			local_ec = 1;
		}
		
		if local_ec != 0 {
			console::print_sub_phase_description("  ✘\n".red());
		} else {
			console::print_sub_phase_description("  ✔\n".green());
		}
	}
	
	if choices.rust {
		console::print_sub_phase_description("     :: Installing Rust");
		
		if let Err(_) = Command::new("./athena/scripts/rd.sh").arg("--rust").output() {
			console::print_sub_phase_description("  ✘\n".red());
		} else {
			console::print_sub_phase_description("  ✔\n".green());
		}
	}
	
	dpo(exit_code, 2, 4)
}

pub fn vsc_ext() -> PhaseResult
{
	console::print_phase_description(3, 4, "Installing VS Code Extensions");
	
	let path = controller::get_resource_path("athena/resources/packages/vsc_extensions.json", 1, 3)?;
	
	let json = match fs::read_to_string(path) {
		Ok(json_str) => json_str,
		Err(_) => return dpo(123, 3, 4)
	};
	
	let extension_tree: Value = match serde_json::from_str(&json) {
		Ok(json_tree) => json_tree,
		Err(_) => return dpo(124, 3, 4)
	};
	
	let mut exit_code = 0;
	
	if let Err(code) = recurse_json(&extension_tree, &vsc_extension_install) {
		exit_code = code;
	}
	
	dpo(exit_code, 3, 4)
}

/// # No Uselessness
///
/// Removes all packages deemed unnecessary.
///
///
pub fn remove_unnecessary() -> PhaseResult
{
	let mut exit_code = 0;
	console::print_phase_description(4, 4, "Removing unnecessary packages");
	
	let mut home = get_home();
	home.push_str("/.Xresources");
	
	match Command::new("xrdb").arg(home).output() {
		Ok(_) => (),
		Err(_) => exit_code = 27
	};
	
	dpo(exit_code, 4, 4)
}
