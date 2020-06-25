/// # Consoles & Shells
///
/// Provides logging functionality for printing log
/// onto the console / shell session.
pub mod console {
	use super::super::data::PhaseResult;
	use std::{fmt, io::{self, Write}};
	use colored::Colorize;
	
	/// Creates the greetings-message upon starting APOLLO.
	pub fn welcome()
	{
		println!("\nWelcome to {} {}", "APOLLO".bold().magenta(), crate::VERSION);

		let procedure: &'static str = "We are going to walk you through a few steps\nto complete the setup. These include:\n\n  1. Initialization\n  2. Installation of Software\n  3. Deployment of Configuration Files\n  4. Cleanup and Post-Configuration\n\nAs we need superuser privileges to install\nprograms and to reach some locations, please\ninput your password if prompted.\n";
		println!("\n{}", procedure);
	}
	
	/// # Phases
	///
	/// Phases are sub-sections of stages. Stages
	/// consist of phases. This logger wraps the
	/// beginning of a phase with the number of
	/// the phase and a description
	pub fn phase_init(current_stage: u8, stage_count_total: u8, msg: &str)
	{
		print!("  ({}/{}) {}\n",
			current_stage,
			stage_count_total,
			msg);
		io::stdout().flush().ok().expect("Could not flush stdout\
			in lib::log::phase_init");
	}
	
	/// # Dichotomy to `phase_init()`
	///
	/// Does exactly the opposite of `phase_init()`.
	/// Ends a phase and indicates success.
	pub fn finalize_phase(current_stage: u8, stage_count_total: u8, result: &PhaseResult)
	{
		match result {
			PhaseResult::Success => {
				print!("  ({}/{}) {}",
			       current_stage,
			       stage_count_total,
			       "✔".green());
			},
			PhaseResult::SoftError(ec) => {
				print!("  ({}/{}) {} — Error {}",
			       current_stage,
			       stage_count_total,
				   "✘".yellow(),
					ec);
			},
			PhaseResult::HardError(ec) => {
				print!("  ({}/{}) {} — Error {}",
			       current_stage,
			       stage_count_total,
				   "✘".red(),
					ec);
			}
		}

		io::stdout().flush().ok().expect("Could not flush stdout");
		println!();
	}
	
	/// # Like `phase_init()` for Stages
	///
	/// Ends a phase and indicates success.
	pub fn finalize_stage(ec: u8)
	{
		match ec {
			0 => println!("\n}} {}", "✔".green()),
			1..=99 => println!("\n}} {} ({})", "✘".yellow(), ec),
			_ => println!("\n}} {} ({})", "✘".red(), ec),
		}
	}
	
	#[allow(dead_code)]
	/// # Debug(ging on the console is always a good idea)
	///
	/// Prints useful debugging information onto the console
	/// during testing.
	pub fn debug<S: fmt::Display>(msg: S, obj: impl std::fmt::Debug)
	{
		println!("This is a {} message!\nMESSAGE: {}\nERROR:  {:#?}",
		         "DEBUG".blue(),
		         msg,
		         obj);
	}
	
	/// Prints the abort information just before aborting
	/// in `main()`.
	pub fn show_abort(msg: impl fmt::Display, exit_code: i32)
	{
		println!("\n\n{}\n MESSAGE: {}\nEXIT CODE: {}",
		         "ABORT".red(),
		         msg,
		         exit_code);
	}
	fn flush()
	{
		io::stdout().flush().ok().expect("Could not flush stdout\
			in lib::log::stage_two::install_program");
	}

	/// # Stage 1
	///
	/// Prints all the information that is needed
	/// during S1 onto the console.
	pub mod stage_one {
		use crate::lib::data::{ExitCodeCompatible, stage_one::{Choices, StageOneData}};
		use std::fmt;
		use colored::Colorize;
		
		/// Prints the beginning of S1
		pub fn init() {	println!("\nSTAGE 1\n{} {{", "INITIALIZATION".magenta()); }

		/// For displaying what the user choice are.
		/// If a user pressed the wrong button, he can
		/// accept to enter his choices again. This is
		/// a visual representation.
		pub fn fmt_choices(choices: &Choices, f: &mut fmt::Formatter<'_>) -> fmt::Result {
			write!(f, "\n  Your installation candidates:\n              \
				LaTeX  {}\n            OpenJDK  {}\n        Cryptomator  {}\n    \
				Build-Essential  {}\n           ownCloud  {}",
			       tb(choices.tex),
			       tb(choices.java),
			       tb(choices.ct),
			       tb(choices.be),
			       tb(choices.oc))
		}
		
		/// For debugging purposes, to display what
		/// the `StageOneData` struct holds.
		pub fn fmt_stage_one_data(sod: &StageOneData, f: &mut fmt::Formatter<'_>) -> fmt::Result {
			write!(f, "{}\nSTAGE 1\n{} {{\n{}\n  EXIT CODE: {}\n  SUCCESS: {}",
			        "DATA".red(),
			        "INITIALIZATION".magenta(),
			       sod.choices,
			       sod.get_exit_code(),
			       sod.is_success())
		}

		/// Helper function. Translates the given boolean into
		/// a string representation. ("Translate Boolean")
		fn tb(val: bool) -> &'static char {
			if val { &'✔' } else { &'✘' }
		}
	}
	
	/// # Stage 2
	///
	/// Prints all the information that is needed
	// 	during S2 onto the console.
	pub mod stage_two {
		use colored::Colorize;
		
		pub fn init() {	println!("\nSTAGE 2\n{} {{\n", "PACKAGING".magenta()); }
		
		pub fn install_program(program: &str)
		{
			print!("     :: Installing {}", program);
			super::flush();
		}
		
		pub fn install_program_outcome(success: bool)
		{
			if success { print!("  ✔\n"); } else { print!("  ✘\n"); }
			super::flush();
		}
	}
	
	pub mod stage_three {
		use colored::Colorize;
		
		pub fn init() { println!("\nSTAGE 3\n{} {{\n", "CONFIGURATION".magenta()); }
		
		pub fn copy_config_folder()
		{
			print!("     :: Syncing ${{HOME}}.config folder");
			super::flush();
		}
		
		pub fn copy_config_folder_succ(success: bool)
		{
			if success { print!("  ✔\n"); } else { print!("  ✘\n"); }
			super::flush();
		}
	}
}

#[allow(dead_code)]
/// Provides logging functionality for printing log
/// to a logfile.
pub mod file {

}

/// Only used for `ApolloResult` structs, which are finalized during
/// expected end of program or unexpected abort.
pub mod end {
	use crate::lib::data::end::ApolloResult;
	use std::fmt;
	use colored::Colorize;
	
	/// Formats the final console output returned before exiting main().
	pub fn fmt_apollo_result(apollo: &ApolloResult, f: &mut fmt::Formatter<'_>) -> fmt::Result
	{
		println!();
		let label = "APOLLO".magenta().bold();
		if apollo.is_success() {
			write!(f, "{} has finished. There were no errors.",
			       label)
		} else if ! apollo.is_abort() {
			write!(f, "{} has finished, but there were minor errors. Final exit code was {}.",
			       label,
			       apollo.get_exit_code())
		} else {
			write!(f, "{} has finished early. An unrecoverable situation was encountered. Exit code was {}",
			       label,
			       apollo.get_exit_code())
		}
	}
}
