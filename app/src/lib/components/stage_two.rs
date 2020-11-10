use library::{
	controller::{
		self,
		dpo,
		apt_install,
		get_home,
		recurse_json,
		vsc_extension_install,
	},
	log::console,
	structures::{
		Choices,
		PhaseResult,
	},
};
use std::{
	fs,
	process::Command,
};
use serde_json::{
	self,
	Value,
};
use colored::Colorize;

const TPC2: u8 = 3;

/// # Base System Extension
///
/// Installs the app's base packages onto
/// the OS.
///
/// Stage: 2,
/// Phase: 1 / TPC1
pub fn install_base() -> PhaseResult
{
	let cp = 1;

	console::print_phase_description(cp, TPC2, "Installing Programs");

	let path = controller::get_resource_path(
		"library/resources/packages/programs.json",
		cp,
		TPC2,
	)?;

	let json = match fs::read_to_string(path) {
		Ok(json_str) => json_str,
		Err(_) => return dpo(121, cp, TPC2),
	};

	let json_tree: Value = match serde_json::from_str(&json) {
		Ok(json_tree) => json_tree,
		Err(_) => return dpo(122, cp, TPC2),
	};

	let error_code = match recurse_json(&json_tree, &apt_install) {
		Ok(_) => 0,
		Err(code) => code,
	};

	dpo(error_code, cp, TPC2)
}

/// # User Choices
///
/// Installs user choices.
///
/// Stage: 2,
/// Phase: 2 / TPC1
pub fn install_choices(choices: &Choices) -> PhaseResult
{
	let cp = 2;
	let mut exit_code = 0;

	console::print_phase_description(
		cp,
		TPC2,
		"Installing User-Choices",
	);

	for program in *choices {
		if let Err(ec) = apt_install(program) {
			if ec != exit_code && exit_code != 0 {
				exit_code = 25;
			}
		}
	}

	if choices.vsc {
		console::pspd("     :: Installing Visual Studio Code");

		let mut code_success = false;

		if Command::new("sudo")
			.arg("./library/scripts/rdv.sh")
			.arg("--visual-studio-code")
			.output()
			.is_err()
		{
			console::pspd("  \u{2718}\n".yellow());
			exit_code = 27;
		} else {
			code_success = true;
			console::pspd("  \u{2714}\n".green());
		}

		if code_success {
			vsc_ext(&mut exit_code);
		}
	}

	if choices.dock {
		let mut local_ec: u8 = 0;

		if apt_install("docker.io").is_err() {
			local_ec = 1;
		};

		console::pspd("     :: Installing Docker Compose");

		if Command::new("sudo")
			.arg("./library/scripts/rdv.sh")
			.arg("--docker-compose")
			.output()
			.is_err()
		{
			local_ec = 1;
		}

		if local_ec == 0 {
			console::pspd("  \u{2714}\n".green());
		} else {
			console::pspd("  \u{2718}\n".yellow());
			exit_code = 28
		}
	}

	if choices.rust {
		console::pspd("     :: Installing Rust");

		if Command::new("./library/scripts/rdv.sh")
			.arg("--rust")
			.output()
			.is_err()
		{
			console::pspd("  \u{2718}\n".yellow());
			exit_code = 29
		} else {
			console::pspd("  \u{2714}\n".green());
		}
	}

	dpo(exit_code, cp, TPC2)
}

/// # VS Code Extensions
///
/// Hidden phase which installs Visual Studio
/// Code extensions.
///
/// Stage: 2,
/// Phase: 2+ (hidden) / TPC1
pub fn vsc_ext(error_code: &mut u8)
{
	let cp = 2;
	let mut exit_code = 0;

	console::pspd("     :: Installing VS Code extensions");

	let path = if let Ok(resource_path) =
		controller::get_resource_path(
			"library/resources/packages/vsc_extensions.json",
			cp,
			TPC2,
		) {
		resource_path
	} else {
		console::pspd("  \u{2718}\n".yellow());
		return;
	};

	let json = if let Ok(json_str) = fs::read_to_string(path) {
		json_str
	} else {
		console::pspd("  \u{2718}\n".yellow());
		return;
	};

	let extension_tree: Value =
		if let Ok(json_tree) = serde_json::from_str(&json) {
			json_tree
		} else {
			console::pspd("  \u{2718}\n".yellow());
			return;
		};

	if let Err(code) =
		recurse_json(&extension_tree, &vsc_extension_install)
	{
		exit_code = code;
	}

	if exit_code == 0 {
		console::pspd("  \u{2714}\n".green());
	} else {
		console::pspd("  \u{2718}\n".yellow());
		*error_code = exit_code;
	}
}

/// # Cleanup
///
/// Removes all packages deemed unnecessary.
///
/// Stage: 2,
/// Phase: 3 / TPC1
pub fn cleanup() -> PhaseResult
{
	let cp = 3;
	let mut exit_code = 0;
	console::print_phase_description(cp, TPC2, "Cleanup");

	let mut home = get_home();
	home.push_str("/.Xresources");

	match Command::new("xrdb").arg(home).output() {
		Ok(_) => (),
		Err(_) => exit_code = 29,
	};

	dpo(exit_code, cp, TPC2)
}
