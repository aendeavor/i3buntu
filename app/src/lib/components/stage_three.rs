use library::{
	controller::{
		dpo,
		drive_sync,
		get_home,
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
		"Copying Configuration Files",
	);

	let home = get_home();

	drive_sync(
		"     :: Syncing over ${HOME}",
		"home/",
		&home,
		false,
		&mut exit_code,
	)?;

	drive_sync(
		"     :: Syncing LightDM main config",
		"lightdm.conf",
		"/etc/lightdm/",
		true,
		&mut exit_code,
	)?;

	drive_sync(
		"     :: Syncing LightDM wallpaper",
		"home/images/background.png",
		"/usr/share/lightdm/",
		true,
		&mut exit_code,
	)?;

	drive_sync(
		"     :: Syncing LightDM greeter config",
		"slick-greeter.conf",
		"/etc/lightdm/",
		true,
		&mut exit_code,
	)?;

	drive_sync(
		"     :: Syncing Xorg config",
		"xorg.conf",
		"/etc/X11/",
		true,
		&mut exit_code,
	)?;

	console::pspd("     :: Unpacking themes");

	let mut theme_dir = home.clone();
	theme_dir.push_str("/.themes/");

	let mut icon_dir = home.clone();
	icon_dir.push_str("/.local/share/");

	let mut color_theme = home.clone();
	color_theme.push_str("/.themes/whiteSur.tar.xz");

	let mut icon_theme = home.clone();
	icon_theme.push_str("/.local/share/icons.tar.xz");

	if Command::new("tar")
		.arg("-xf")
		.arg(color_theme)
		.arg("-C")
		.arg(theme_dir)
		.output()
		.is_err()
	{
		exit_code = 30;
	};

	if Command::new("tar")
		.arg("-xf")
		.arg(icon_theme)
		.arg("-C")
		.arg(icon_dir)
		.output()
		.is_err()
	{
		exit_code = 31;
	};

	if exit_code == 0 {
		console::pspd("  \u{2714}\n".green());
	} else {
		console::pspd("  \u{2718}\n".yellow());
	}

	exit_code = 0;

	console::pspd("     :: Acquiring Vim-Plug");

	let mut vim_plug_dir = home;
	vim_plug_dir
		.push_str("/.local/share/nvim/site/autoload/plug.vim");

	let url = "https://raw.githubusercontent.com/\
		junegunn/vim-plug/master/plug.vim";
	if Command::new("curl")
		.args(&["-fLo", vim_plug_dir.as_str(), "--create-dirs", url])
		.output()
		.is_err()
	{
		exit_code = 33;
	};

	if exit_code == 0 {
		console::pspd("  \u{2714}\n".green());
	} else {
		console::pspd("  \u{2718}\n".yellow());
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

	console::print_phase_description(cp, TPC3, "Unpacking fonts");

	let home = get_home();

	let mut font_dir = String::from(&home);
	font_dir.push_str("/.local/share/fonts/");

	let mut fira_code = String::from(&home);
	fira_code.push_str("/.local/share/fonts/FiraCode.tar.xz");

	let mut fira_mono = String::from(&home);
	fira_mono.push_str("/.local/share/fonts/FiraMono.tar.xz");

	if Command::new("tar")
		.arg("-xf")
		.arg(fira_code)
		.arg("-C")
		.arg(font_dir.clone())
		.output()
		.is_err()
	{
		exit_code = 30;
	};

	if Command::new("tar")
		.arg("-xf")
		.arg(fira_mono)
		.arg("-C")
		.arg(font_dir)
		.output()
		.is_err()
	{
		exit_code = 31;
	};

	dpo(exit_code, cp, TPC3)
}
