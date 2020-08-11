use athena::{
	controller::{
		self,
		dpo,
		apt_install,
		get_home,
		recurse_json,
		vsc_extension_install,
	},
	log::console,
	structures::{Choices, PhaseResult},
};
use std::{fs, process::Command};
use serde_json::{self, Value};
use colored::Colorize;

const TPC2: u8 = 3;

/// # Base System Extension
///
/// Installs ***APOLLO***'s base packages onto
/// the OS.
///
/// Stage: 2,
/// Phase: 1 / TPC1
pub fn install_base() -> PhaseResult
{
	let cp = 1;
	
	console::print_phase_description(
		cp,
		TPC2,
		"Installing Programs");
	
	let path = controller::get_resource_path(
		"athena/resources/packages/programs.json",
		cp,
		TPC2)?;
	
	let json = match fs::read_to_string(path) {
		Ok(json_str) => json_str,
		Err(_) => return dpo(121, cp, TPC2)
	};
	
	let json_tree: Value = match serde_json::from_str(&json) {
		Ok(json_tree) => json_tree,
		Err(_) => return dpo(122, cp, TPC2)
	};
	
	let error_code = match recurse_json(&json_tree, &apt_install) {
		Ok(_) => 0,
		Err(code) => code
	};
	
	dpo(error_code, cp, TPC2)
}

/// # User Choices
///
/// Installs user choices.
///
/// Stage: 2,
/// Phase: 2 / TPC1
pub fn install_choices(choices: &Choices) -> PhaseResult
{
	let cp = 2;
	let mut exit_code = 0;
	
	console::print_phase_description(
		cp,
		TPC2,
		"Installing User-Choices");
	
	for program in *choices {
		if let Err(ec) = apt_install(program) {
			if ec != exit_code {
				if exit_code != 0 { exit_code = 25; }
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
			.output()
		{
			Ok(output) => {
				match output.status.success() {
					true => console::print_sub_phase_description("  ✔\n".green()),
					false => {
						println!("{:?}", output);
						console::print_sub_phase_description("  ✘\n".yellow());
						exit_code = 26;
					}
				}
			},
			Err(_) => exit_code = 27
		}

		vsc_ext();
	}
	
	if choices.dock {
		let mut local_ec: u8 = 0;
		
		if let Err(_) = apt_install("docker.io") {
			local_ec = 1;
		}

		console::print_sub_phase_description("     :: Installing Docker Compose");
		
		if let Ok(_) = Command::new("sudo")
			.arg("./athena/scripts/rd.sh")
			.arg("--docker-compose")
			.output()
		{
			local_ec = 1;
		}
		
		if local_ec != 0 {
			console::print_sub_phase_description("  ✘\n".yellow());
		} else {
			console::print_sub_phase_description("  ✔\n".green());
		}
	}
	
	if choices.rust {
		console::print_sub_phase_description("     :: Installing Rust");
		
		if let Err(_) = Command::new("./athena/scripts/rd.sh")
			.arg("--rust")
			.output()
		{
			console::print_sub_phase_description("  ✘\n".yellow());
		} else {
			console::print_sub_phase_description("  ✔\n".green());
		}
	}
	
	dpo(exit_code, cp, TPC2)
}

/// # VS Code Extensions
///
/// Hidden phase which installs Visual Studio
/// Code extensions.
///
/// Stage: 2,
/// Phase: 2+ (hidden) / TPC1
pub fn vsc_ext()
{
	let cp = 2;
	let mut exit_code = 0;

	console::print_sub_phase_description("     :: Installing VS Code extensions");
	
	let path = match controller::get_resource_path(
		"athena/resources/packages/vsc_extensions.json",
		cp,
		TPC2)
	{
		Ok(resource_path) => resource_path,
		Err(_) => {
			console::print_sub_phase_description("  ✘\n".yellow());
			return
		}
	};
	
	let json = match fs::read_to_string(path) {
		Ok(json_str) => json_str,
		Err(_) => {
			console::print_sub_phase_description("  ✘\n".yellow());
			return
		}
	};
	
	let extension_tree: Value = match serde_json::from_str(&json) {
		Ok(json_tree) => json_tree,
		Err(_) => {
			console::print_sub_phase_description("  ✘\n".yellow());
			return
		}
	};
	
	if let Err(code) = recurse_json(
		&extension_tree,
		&vsc_extension_install)
	{
		exit_code = code;
	}
	
	if exit_code == 0 {
		console::print_sub_phase_description("  ✔\n".green());
	} else {
		console::print_sub_phase_description("  ✘\n".yellow());
	}
}

/// # Cleanup
///
/// Removes all packages deemed unnecessary.
///
/// Stage: 2,
/// Phase: 3 / TPC1
pub fn cleanup() -> PhaseResult
{
	let cp = 3;
	let mut exit_code = 0;
	console::print_phase_description(
		cp,
		TPC2,
		"Cleanup");
	
	let mut home = get_home();
	home.push_str("/.Xresources");
	
	match Command::new("xrdb")
		.arg(home)
		.output()
	{
		Ok(_) => (),
		Err(_) => exit_code = 29
	};
	
	dpo(exit_code, cp, TPC2)
}
