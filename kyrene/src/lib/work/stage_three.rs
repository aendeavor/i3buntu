use crate::lib::{
	log::console::{self, stage_three},
	data::PhaseResult
};

use super::general::{dpo, try_evade};
use std::{fs, path::Path, process::Command};
use dirs_next;

pub fn copy_configurations() -> PhaseResult
{
	let mut exit_code = 0;
	console::phase_init(1,3, "Copying Configuration Files");
	stage_three::copy_config_folder();
	
	let current_dir = match std::env::current_dir() {
		Ok(path) => path,
		Err(_) => return dpo(130, 1, 3)
	};
	
	let home = match dirs_next::home_dir() {
		Some(path) => path,
		None => return dpo(131, 1, 3)
	};

	let file_str = match try_evade(
		current_dir,
		Path::new("athena/resources/programs/ppas.json"))
	{
		Ok(file_str) => file_str,
		Err(error) => return error
	};

	stage_three::copy_config_folder_succ(true);

	if let Err(_) = Command::new("rsync")
		.arg("-az")
		.arg(current_dir)
		.arg(home)
		.output()
	{
		exit_code = 10;
		stage_three::copy_config_folder_succ(false);
	} else {
		stage_three::copy_config_folder_succ(true);

	}
	
	dpo(exit_code, 1, 3)
}
