use crate::lib::{data::PhaseResult, log};
use super::general::dpo;
use std::{fs, path::Path, process::Command};

/// # Getting Dependencies Ready
///
/// This function in S1 sets up the necessary
/// package-dependencies via PPAs.
///
/// ## Context
///
/// Stage: 1,
/// Phase: 1 / 2
pub fn add_ppas() -> PhaseResult
{
	println!();
	log::console::phase_init(1, 2, "Adding PPAs");
	let mut exit_code: u8 = 0;
	
	let mut destination = match std::env::current_dir() {
		Ok(dir) => dir,
		Err(_) => return dpo(120, 1, 3)
	};
	destination.push(Path::new("athena/resources/programs/ppas.json"));

	
	let file_str = match fs::read_to_string(&destination) {
		Ok(file_str) => file_str,
		Err(_) => return dpo(121, 1, 3)
	};
	
	let mut json_val = match json::parse(&file_str) {
		Ok(json_val) => json_val,
		Err(_) => return dpo(122, 1, 3)
	};
	
	println!("{:#?}", json_val);
	for (_, array) in json_val.entries_mut() {
		for index in 0..array.len() {
			println!("{}", index);
			// TODO weird behavior
			if let Some(ppa) = array.array_remove(index).as_str() {
				println!("{}", ppa);
				match Command::new("sudo")
					.arg("add-apt-repository")
					.arg("-y")
					.arg("-n")
					.arg(ppa)
					.output() {
					Ok(_) => {
						continue;
					},
					Err(_) => {
						match ppa {
							"ppa:git-core/ppa" => {
								exit_code = 10;
							},
							"ppa:ubuntu-mozilla-security/ppa" => {
								if exit_code != 10 {
									exit_code = 11;
								} else {
									exit_code = 12;
								}
							},
							_ => {
								return dpo(113, 1, 1);
							}
						}
					}
				}
			} else {
				return dpo(114, 1, 1)
			}
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
pub fn update_package_information() -> PhaseResult
{
	log::console::phase_init(2, 2, "Updating APT");
	
	match Command::new("sudo")
		.arg("apt-get")
		.arg("-y")
		.arg("update")
		.output() {
		Ok(_) => dpo(0, 2, 2),
		Err(_) => {
			dpo(114, 2, 2)
		}
	}
}
