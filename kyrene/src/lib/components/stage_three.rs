use athena::{
	structures::PhaseResult,
	log::console,
	controller::dpo
};
use std::process::Command;
use dirs_next;
use colored::Colorize;

pub fn copy_configurations() -> PhaseResult
{
	let mut exit_code = 0;
	console::print_phase_description(1, 3, "Copying Configuration Files");
	console::print_sub_phase_description("     :: Syncing ${{HOME}}/.config folder");
	
	let path = athena::controller::get_resource_path("athena/resources/config/home/", 1, 3)?;
	
	let _home = match dirs_next::home_dir() {
		Some(path) => path,
		None => return dpo(131, 1, 3)
	};
	
	console::print_sub_phase_description("  ✔\n".green());
	println!("{}", path);
	
	// if let Err(_) = Command::new("rsync")
	// 	.arg("-az")
	// 	.arg(current_dir)
	// 	.arg(home)
	// 	.output()
	// {
	// 	exit_code = 10;
	// 	console::stage_three::copy_config_folder_succ(false);
	// } else {
	// 	console::stage_three::copy_config_folder_succ(true);
	//
	// }
	
	dpo(exit_code, 1, 3)
}
