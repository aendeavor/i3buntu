use athena::{console, PhaseResult, dpo};
use std::process::Command;
use dirs_next;

pub fn copy_configurations() -> PhaseResult
{
	let mut exit_code = 0;
	console::phase_init(1,3, "Copying Configuration Files");
	console::stage_three::copy_config_folder();
	
	let path = athena::get_resource_path("athena/resources/config/home/", 1, 3)?;
	
	let _home = match dirs_next::home_dir() {
		Some(path) => path,
		None => return dpo(131, 1, 3)
	};
	
	console::stage_three::copy_config_folder_succ(true);
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
