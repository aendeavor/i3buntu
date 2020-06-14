use crate::lib::data::PhaseResult;
use super::general::dpo;
use std::fs;
use dirs_next;

pub fn copy_configurations() -> PhaseResult
{
	let current_dir = match std::env::current_dir() {
		Ok(path) => path,
		Err(_) => return dpo(130, 1, 3)
	};
	
	let mut home = match dirs_next::home_dir() {
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
	
	dpo(0, 1, 3)
}