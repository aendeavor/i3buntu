use crate::lib::{
	data::{stage_one::PPAs, PhaseResult},
	log,
};
use super::general::{dpo, try_evade};
use std::{path::Path, process::Command};
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
	log::console::phase_init(1, 2, "Adding PPAs");
	let mut exit_code: u8 = 0;
	
	let destination = match std::env::current_dir() {
		Ok(dir) => dir,
		Err(_) => return dpo(110, 1, 3),
	};
	
	let file_str = match try_evade(
		destination,
		Path::new("athena/resources/programs/ppas.json"))
	{
		Ok(file_str) => file_str,
		Err(error) => return error
	};

	let json_ppas: PPAs = match serde_json::from_str(&file_str) {
		Ok(json_ppas) => json_ppas,
		Err(_) => return dpo(112, 1, 3),
	};
	
	for ppa in json_ppas.critical() {
		let ppa: &str = ppa.as_str();
		if let Err(_) = Command::new("sudo")
			.arg("add-apt-repository")
			.arg("-y")
			.arg("-n")
			.arg("-h")
			.arg(ppa)
			.output()
		{
			return dpo(113, 1, 1);
		}
	}

	for ppa in json_ppas.optional() {
		let ppa: &str = ppa.as_str();
		if let Err(_) = Command::new("sudo")
			.arg("add-apt-repository")
			.arg("-y")
			.arg("-n")
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
	log::console::phase_init(2, 2, "Updating APT");
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
