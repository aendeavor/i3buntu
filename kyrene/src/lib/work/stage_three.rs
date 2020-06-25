use crate::lib::{
	log::console::{self, stage_three},
	data::PhaseResult
};
use super::general::dpo;
use std::fs;
use dirs_next;

pub fn copy_configurations() -> PhaseResult
{
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
	
	let mut x_resources = home.to_path_buf();
	x_resources.push(".config/regolith/Xresources");
	
	// TODO current dir is obviously wrong
	match fs::copy(current_dir, x_resources) {
		Ok(_) => (),
		Err(_) => ()
	};
	
	stage_three::copy_config_folder_succ(true);
	
	dpo(0, 1, 3)
}