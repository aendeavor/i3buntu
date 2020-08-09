use athena::{
	controller::{
		dpo,
		drive_sync,
		get_home
	},
	log::console,
	structures::PhaseResult,
};
use std::process::Command;
use colored::Colorize;

const TPC3: u8 = 2;

/// # Configuration Files
///
/// Copies all configuration files to their
/// corresponding locations.
///
/// Stage: 3,
/// Phase: 1 / TPC3
pub fn copy_configurations() -> PhaseResult
{
	let cp = 1;
	let mut exit_code = 0;
	
	console::print_phase_description(
		cp,
		TPC3,
		"Copying Configuration Files");
	
	let home = get_home();
	
	drive_sync(
		"     :: Syncing over ${{HOME}}",
		"home/",
		&home,
		false,
		&mut exit_code)?;
	
	drive_sync(
		"     :: Syncing LightDM main config",
		"lightdm.conf",
		"/etc/lightdm/",
		true,
		&mut exit_code)?;
	
	drive_sync(
		"     :: Syncing LightDM greeter config",
		"slick-greeter.conf",
		"/etc/lightdm/",
		true,
		&mut exit_code)?;
	
	drive_sync(
		"     :: Syncing Xorg config",
		"xorg.conf",
		"/etc/X11/",
		true,
		&mut exit_code)?;
	
	console::print_sub_phase_description("     :: Unpacking themes");
	
	let mut color_theme = home.clone();
	color_theme.push_str("/.theme/whiteSur.tar.xz");
	
	let mut icon_theme = home.clone();
	icon_theme.push_str("/.local/share/icons/whiteSur.tar.xz");
	
	if let Err(_) = Command::new("tar")
		.arg("-xf")
		.arg(color_theme)
		.output()
	{
		exit_code = 30;
	};
	
	if let Err(_) = Command::new("tar")
		.arg("-xf")
		.arg(icon_theme)
		.output()
	{
		exit_code = 31;
	};
	
	if exit_code == 30 || exit_code == 31 {
		console::print_sub_phase_description("  ✘\n".yellow());
	} else {
		console::print_sub_phase_description("  ✔\n".green());
	}
	
	dpo(exit_code, cp, TPC3)
}

/// # Fonts
///
/// Unpacks the fonts in their specified
/// directories.
///
/// Stage: 3,
/// Phase: 2 / TPC3
pub fn install_fonts() -> PhaseResult
{
	let cp = 2;
	let mut exit_code: u8 = 0;
	
	console::print_phase_description(
		cp,
		TPC3,
		"Unpacking fonts");
	
	let home = get_home();
	
	let mut fira_code = String::from(&home);
	fira_code.push_str("/.local/share/fonts/FiraCode.tar.xz");
	
	let mut fira_mono = String::from(&home);
	fira_mono.push_str("/.local/share/fonts/FiraMono.tar.xz");
	
	if let Err(_) = Command::new("tar")
		.arg("-xf")
		.arg(fira_code)
		.output()
	{
		exit_code = 30;
	};
	
	if let Err(_) = Command::new("tar")
		.arg("-xf")
		.arg(fira_mono)
		.output()
	{
		exit_code = 31;
	};
	
	dpo(exit_code, cp, TPC3)
}