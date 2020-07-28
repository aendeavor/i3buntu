use athena::{
	controller::{self, dpo},
	log::console,
	structures::{PhaseResult, PPAs},
};
use std::{fs, process::Command};
use serde_json;

/// # Getting Dependencies Ready
///
/// This function in S1 sets up the necessary
/// package-dependencies via PPAs.
///
/// ## Context
///
/// Stage: 1,
/// Phase: 1 / 2
pub fn add_ppas() -> PhaseResult {
	println!();
	console::print_phase_description(1, 2, "Adding PPAs");
	let mut exit_code: u8 = 0;
	
	let path = controller::get_resource_path("athena/resources/programs/ppas.json", 1, 2)?;
	
	let json = match fs::read_to_string(path) {
		Ok(json_str) => json_str,
		Err(_) => return dpo(111, 1, 2)
	};
	
	let json_ppas: PPAs = match serde_json::from_str(&json) {
		Ok(json_ppas) => json_ppas,
		Err(_) => return dpo(112, 1, 2)
	};
	
	for ppa in json_ppas.critical() {
		if let Err(_) = Command::new("sudo")
			.arg("add-apt-repository")
			.arg("-y")
			.arg("-h")
			.arg(ppa)
			.output()
		{
			return dpo(113, 1, 2);
		}
	}

	for ppa in json_ppas.optional() {
		let ppa: &str = ppa.as_str();
		if let Err(_) = Command::new("sudo")
			.arg("add-apt-repository")
			.arg("-y")
			.arg("-h")
			.arg(ppa)
			.output()
		{
			exit_code = 10
		}
	}
	
	dpo(exit_code, 1, 2)
}

/// # Updating Dependencies
///
/// Executes `apt-get update`.
///
/// ## Context
///
/// Stage: 1,
/// Phase: 2 / 2
pub fn update_package_information() -> PhaseResult {
	console::print_phase_description(2, 2, "Updating APT Signatures");
	match Command::new("sudo")
		.arg("apt-get")
		.arg("-y")
		.arg("update")
		.output()
	{
		Ok(_) => dpo(0, 2, 2),
		Err(_) => dpo(114, 2, 2),
	}
}
