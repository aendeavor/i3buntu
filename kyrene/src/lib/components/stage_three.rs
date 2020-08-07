use athena::{
	controller::{dpo, drive_sync},
	log::console,
	structures::PhaseResult,
};
use std::process::Command;
use dirs_next;
use colored::Colorize;

pub fn copy_configurations() -> PhaseResult
{
	let mut exit_code = 0;
	console::print_phase_description(1, 2, "Copying Configuration Files");
	
	let home = match dirs_next::home_dir() {
		Some(path) => path,
		None => return dpo(131, 1, 2)
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
	
	let tar = Command::new("tar").arg("-xf");

	if let Err(_) = tar.arg(c_theme).output() {
		exit_code = 30;
	};
	
	if let Err(_) = tar.arg(i_theme).output() {
		exit_code = 31;
	};
	
	if exit_code == 30 || exit_code == 31 {
		console::print_sub_phase_description("  ✘\n".yellow());
	} else {
		console::print_sub_phase_description("  ✔\n".green());
	}
	
	dpo(exit_code, 1, 2)
}

pub fn install_fonts() -> PhaseResult
{
	let mut exit_code: u8 = 0;
	console::print_phase_description(1, 2, "Unpacking fonts");
	
	let home = match dirs_next::home_dir() {
		Some(path) => String::from(path),
		None => return dpo(132, 1, 1)
	};
	
	let fire_code = String::from(&home);
	c_theme.push_str("/.local/share/fonts/FiraCode.tar.xz");
	
	let fira_mono = String::from(&home);
	i_theme.push_str("/.local/share/fonts/FiraMono.tar.xz");
	
	let tar = Command::new("tar").arg("-xf");
	
	if let Err(_) = tar.arg(fire_code).output() {
		exit_code = 30;
	};
	
	if let Err(_) = tar.arg(fira_mono).output() {
		exit_code = 31;
	};
	
	dpo(exit_code, 1, 2)
}

