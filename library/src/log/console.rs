use super::super::data::{
	self,
	structures::{
		AppResult,
		PhaseError,
	},
};
use std::{
	fmt,
	io::{
		self,
		Write,
	},
};
use colored::Colorize;

/// # Greetings
///
/// Creates the greetings-message upon starting i3buntu.
pub fn welcome(app_version: &str)
{
	// editorconfig-checker-disable
	println!(
		"\nWelcome to {}\n\nLIB {}\nAPP {}\n\nWe are going to walk \
		 you through a few steps\nto complete the setup. These \
		 include:\n\n  1. Initialization\n  2. Installation of \
		 Software\n  3. Deployment of Configuration Files\n\nAs we \
		 need superuser privileges to install\nprograms and to \
		 reach some locations, please\ninput your password if \
		 prompted.\n",
		"i3buntu".bold().yellow(),
		crate::VERSION,
		app_version
	);
	// editorconfig-checker-enable

	let _ = std::process::Command::new("sudo")
		.arg("apt-get")
		.arg("--help")
		.output();
}

/// # Beginning of a stage
///
/// Stages are the main blocks work is
/// divided into. Stages consist of phases.
pub fn print_stage_start(stage_number: u8, stage_name: &str)
{
	println!(
		"\nSTAGE {}\n{} {{\n",
		stage_number,
		stage_name.yellow()
	);
}

/// # Phase descriptions
///
/// Phases are sub-sections of stages. This
/// logger wraps the beginning of a phase with
/// the number of the phase and a description
pub fn print_phase_description(
	current_phase: u8,
	total_phase_count: u8,
	msg: &str,
)
{
	println!("  ({}/{}) {}", current_phase, total_phase_count, msg);
	flush();
}

/// # Sub phase descriptions
///
/// As work id done in phases, they will log
/// information on the console to inform the
/// user about the progress.
pub fn pspd<T: fmt::Display>(message: T)
{
	print!("{}", message);
	flush();
}

/// # Closing a phase
///
/// Logs the end of a phase and indicates success.
pub fn finalize_phase(
	current_phase: u8,
	total_phase_count: u8,
	result: Option<&PhaseError>,
)
{
	if let Some(phase_error) = result {
		let (indicator, ec) = match phase_error {
			PhaseError::SoftError(ec) => ("\u{2718}".yellow(), *ec),
			PhaseError::HardError(ec) => ("\u{2718}".red(), *ec),
		};

		println!(
			"  ({}/{}) {} \u{2014} Error {}",
			current_phase, total_phase_count, indicator, ec
		);
	} else {
		println!(
			"  ({}/{}) {}",
			current_phase,
			total_phase_count,
			"\u{2714}".green()
		);
	}

	flush();
}

/// # Closing a stage
///
/// Logs the end of a stage and indicates success.
pub fn finalize_stage(ec: u8)
{
	match ec {
		0 => println!("\n}} {}", "\u{2714}".green()),
		1..=99 => println!("\n}} {} ({})", "\u{2718}".yellow(), ec),
		_ => println!("\n}} {} ({})", "\u{2718}".red(), ec),
	}
}

/// # Debugging
///
/// on the console is always a good idea.
///
/// Prints useful debugging information onto the console
/// during testing.
#[allow(dead_code)]
pub fn debug<S, T>(msg: S, obj: T)
where
	S: fmt::Display,
	T: fmt::Debug,
{
	println!(
		"This is a {} message!\nMESSAGE: {}\nERROR:  {:#?}",
		"DEBUG".blue(),
		msg,
		obj
	);
}

/// # Flush `print!(...)`
///
/// Helper to flush the `print!(...)`-macro.
fn flush() { io::stdout().flush().ok().unwrap_or_default() }

/// # Console logging stage 1
///
/// Prints all the information that is needed
/// during S1 onto the console.
pub mod stage_one
{
	use super::data::{
		structures::{
			Choices,
			StageOneData,
		},
		traits::ExitCodeCompatible,
	};
	use std::fmt;
	use colored::Colorize;

	/// # Display User Choices
	///
	/// Displays user choices. If a user pressed the wrong
	/// button, he / she can accept to enter his choices
	/// again. This is a visual representation.
	///
	/// ## Errors
	///
	/// Propagates the result from the `write!()` macro.
	pub fn fmt_choices(
		choices: &Choices,
		f: &mut fmt::Formatter<'_>,
	) -> fmt::Result
	{
		write!(
			f,
			"\n  Your installation candidates:\n              \
			LaTeX  {}\n            OpenJDK  {}\n        \
			Cryptomator  {}\n    Build-Essential  {}\n           \
			ownCloud  {}\n             Docker  {}\
			\n            VS Code  {}\n               Rust  {}",
			tb(choices.tex),
			tb(choices.java),
			tb(choices.ct),
			tb(choices.be),
			tb(choices.oc),
			tb(choices.dock),
			tb(choices.vsc),
			tb(choices.rust))
	}

	/// # Debugging
	///
	/// For debugging purposes, to display what the
	/// `StageOneData` struct holds.
	/// # Errors
	///
	/// Propagates the result from the `write!()` macro.
	pub fn fmt_stage_one_data(
		sod: &StageOneData,
		f: &mut fmt::Formatter<'_>,
	) -> fmt::Result
	{
		write!(
			f,
			"{}\nSTAGE 1\n{} {{\n{}\n  EXIT CODE: {}\n  SUCCESS: {}",
			"DATA".red(),
			"INITIALIZATION".yellow(),
			sod.choices,
			sod.get_exit_code(),
			sod.is_success()
		)
	}

	/// Translates the given boolean into a string
	/// representation.
	const fn tb(val: bool) -> &'static str
	{
		if val {
			"yes"
		} else {
			"no"
		}
	}
}

/// # Final Console Output
///
/// Formats the final console output returned before exiting
/// `main()`.
///
/// ## Errors
///
/// Propagates the result from the `write!()` macro.
pub fn fmt_final_result(
	result: &AppResult,
	f: &mut fmt::Formatter<'_>,
) -> fmt::Result
{
	println!();
	let label = "result".yellow().bold();

	if result.is_success() {
		write!(f, "{} has finished. There were no errors.", label)
	} else if result.is_abort() {
		write!(
			f,
			// editorconfig-checker-disable
			"{} has finished early. An unrecoverable situation was \
			 encountered. Exit code was {}",
			// editorconfig-checker-enable
			label,
			result.get_exit_code()
		)
	} else {
		write!(
			f,
			// editorconfig-checker-disable
			"{} has finished, but there were minor errors. Final \
			 exit code was {}.",
			// editorconfig-checker-enable
			label,
			result.get_exit_code()
		)
	}
}
