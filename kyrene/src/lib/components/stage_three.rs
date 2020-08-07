use athena::{
	controller::{dpo, drive_sync},
	log::console,
	structures::PhaseResult,
};
use dirs_next;

pub fn copy_configurations() -> PhaseResult
{
	let mut exit_code = 0;
	console::print_phase_description(1, 1, "Copying Configuration Files");
	
	let home = match dirs_next::home_dir() {
		Some(path) => path,
		None => return dpo(131, 1, 1)
	};
	
	drive_sync("     :: Syncing over ${{HOME}}", "home/",
	           &home, false, &mut exit_code)?;
	
	drive_sync("     :: Syncing LightDM main config", "lightdm.conf",
	           "/etc/lightdm/", true, &mut exit_code)?;
	
	drive_sync("     :: Syncing LightDM greeter config", "slick-greeter.conf",
	           "/etc/lightdm/", true, &mut exit_code)?;
	
	drive_sync("     :: Syncing Xorg config", "xorg.conf",
	           "/etc/X11/", true, &mut exit_code)?;
	
	console::print_sub_phase_description("     :: Unpacking themes");
	
	let mut c_theme = String::from(&home);
	c_theme.push_str("/.theme/whiteSur.tar.xz");
	
	let mut i_theme = String::from(&home);
	i_theme.push_str("/.local/share/icons/whiteSur.tar.xz");
	
	let tar = std::process::Command::new("tar").arg("-xf");

	if let Err(_) = tar.arg(c_theme).output() {
		exit_code = 30;
	};
	
	if let Err(_) = tar.arg(i_theme).output() {
		exit_code = 31;
	};
	
	use colored::Colorize;
	if error_code == 30 || error_code == 31 {
		console::print_sub_phase_description("  ✘\n".yellow());
	} else {
		console::print_sub_phase_description("  ✔\n".green());
	}
	
	dpo(exit_code, 1, 1)
}
