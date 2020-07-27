use super::super::{
	log::console,
	traits::ExitCodeCompatible
};
use std::{fmt, error::Error};
use serde::{Serialize, Deserialize};

// * ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/// # Stage Result
///
/// Resembles the outcome of a stage. These
/// outcomes must only implement `ExitCodeCompatible`.
#[allow(type_alias_bounds)]
pub type StageResult<D: ExitCodeCompatible> = Result<D, D>;

// * ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/// # Exit Code
///
/// Resembles the general exit code for
/// each subroutine used for error
/// propagation.
pub struct ExitCode(pub u8);

impl ExitCode {
	pub fn is_success(&self) -> bool {
		if self.0 == 0 { true } else { false }
	}
}

impl ExitCodeCompatible for ExitCode {
	fn set_exit_code(&mut self, exit_code: u8) {
		self.0 = exit_code;
	}
	fn get_exit_code(&self) -> u8 { self.0 }
}

// * ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/// # Phase Error
/// 
/// Resembles the kinds of error
/// a phase can have.
pub enum PhaseError {
	/// A phase ended normally, but a recoverable
	/// error occurred.
	SoftError(u8),
	/// A phase ended prematurely caused by an
	/// unrecoverable error.
	HardError(u8),
}

// * ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/// # Phase Result
///
/// Resembles the outcome of a phase. These always contain
/// `PhaseSuccess`-enums.
pub type PhaseResult = Option<PhaseError>;

impl std::convert::From<PhaseError> for std::option::NoneError {
	fn from(_: PhaseError) -> Self {
		std::option::NoneError
	}
}

// * ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/// All information necessary after the completion
/// of stage one of the installation.
#[derive(Debug)]
pub struct StageOneData {
	pub choices: Choices,
	/// Exit code of stage one. Is later translated
	/// into an exit code for [`ApolloResult`](../end/struct.ApolloResult.html).
	exit_code: u8,
	is_success: bool,
}

impl StageOneData {
	/// Creates a new instance of `StageOneData`.
	pub fn new(choices: Choices) -> Self
	{
		StageOneData {
			choices,
			exit_code: 0,
			is_success: true,
		}
	}
	
	/// Simple getter to obtain information about
	/// whether the stage was successful or not.
	pub fn is_success(&self) -> bool { self.is_success }
}
	
impl ExitCodeCompatible for StageOneData {
	/// Sets a specific error code and alters `is_success`
	/// to reflect the status.
	fn set_exit_code(&mut self, exit_code: u8)
	{
		self.exit_code = exit_code;
		if exit_code == 0 {
			self.is_success = true;
		} else {
			self.is_success = false;
		}
	}
	
	fn get_exit_code(&self) -> u8 { self.exit_code }
}

impl fmt::Display for StageOneData {
	fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
		console::stage_one::fmt_stage_one_data(self, f)
	}
}
	
impl Error for StageOneData {}

/// # User Software Choices
///
/// `Choices` holds all the choices made by the user
/// about which packages to install, and which not to
/// install.
///
/// ## Special Implementation
///
/// `Choices` implements `Iterator`, so that one can
/// loop over this struct to get the entries to install
/// them.
#[derive(Debug, Clone, Copy)]
pub struct Choices {
	pub tex: bool,
	pub java: bool,
	pub ct: bool,
	pub be: bool,
	pub oc: bool,
	next: u8
}
	
impl Choices {
	/// Creates a new instance `Choices`.
	pub fn new(tex: bool, java: bool, ct: bool, be: bool, oc:bool) -> Self
	{
		Choices {
			tex, java,
			ct, be,
			oc, next: 0
		}
	}
}

impl Error for Choices {}

impl fmt::Display for Choices {
	fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
		console::stage_one::fmt_choices(self, f)
	}
}

impl Iterator for Choices {
	type Item = &'static str;
	
	fn next(&mut self) -> Option<Self::Item>
	{
		self.next += 1;
		
		if self.tex && self.next == 1 { return Some("texlive-full") };
		if self.java && self.next == 2 { return Some("openjdk-14-jdk") };
		if self.ct && self.next == 3 { return Some("cryptomator") };
		if self.be && self.next == 4 { return Some("build-essential") };
		if self.oc && self.next == 5 { return Some("owncloud-client") };
		
		self.next = 0;
		None
	}
}

/// # Personal Package Archives
///
/// This struct holds parsed PPAs. The critical
/// section has to be installed while the optional
/// section is not mandatory.
#[derive(Serialize, Deserialize, Debug)]
pub struct PPAs {
	critical: Vec<String>,
	optional: Vec<String>
}

impl PPAs {
	pub fn critical(&self) -> &Vec<String> {
			&self.critical
		}
	pub fn optional(&self) -> &Vec<String> {
			&self.optional
		}
}

/// * ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/// Used for error propagation to top level `main()`
/// and to decide whether the installation was a
/// success or a failure. In case of a failure,
/// there is also an indication whether the
/// installation ended in an abort.
#[derive(Debug)]
pub struct ApolloResult {
	success: bool,
	abort: bool,
	/// Exit codes between 0 - 99 indicate a recovered error.
	///
	/// Exit codes between 100 - 199 indicate unrecoverable errors.
	///
	/// Exit codes of >200 are reserved.
	exit_code: i32,
	abort_msg: Option<&'static str>,
}

impl ApolloResult {
	/// Creates a new instance of `ApolloResult`.
	pub fn new() -> Self
	{
		ApolloResult {
			success: true,
			abort: false,
			exit_code: 0,
			abort_msg: None
		}
	}
	
	/// Indicated whether APOLLO finished with
	/// exit code 0 or not (i.e. wether it is
	/// a success or not).
	pub fn is_success(&self) -> bool { self.success }
	
	/// Indicated that an abort is about to
	/// take place. Exit code is above 199.
	pub fn is_abort(&self) -> bool { self.abort }
		
	/// Indicates that the installation encountered
	/// an error (and is probably aborting).
	pub fn set_failure(&mut self, exit_code: u8)
	{
		if self.exit_code > 99 {
			panic!("Setting the error code twice is\
			not allowed when the first error code\
			indicated an abort.")
		}
		
		self.success = false;
		self.set_exit_code(exit_code);
		if exit_code > 99 { self.set_abort(); }
	}
		
	/// Indicates that the installation encountered
	/// ab unrecoverable error and is going to abort.
	fn set_abort(&mut self) {
		self.abort = true;
		match self.get_exit_code()
		{
			100 => {
				self.abort_msg = Some("EXIT CODE 100 - NEEDS MSG");
			},
			_ => panic!("Exit Code for abort not implemented in \
			lib::data::end::ApolloResult.set_abort. Exit code was: {}",
	            self.get_exit_code())
		}
	}
		
	pub fn get_exit_code(&self) -> i32 { self.exit_code	}
		
	/// Sets the exit code of the program.
	fn set_exit_code(&mut self, exit_code: u8) {
		self.exit_code = exit_code as i32;
	}
	
	/// Wrapper for log-function `show_abort()`
	/// Prints the abort information just before aborting
	/// in `main()`.
	pub fn show_abort(&self)
	{
		use colored::Colorize;
		
		println!("\n\n{}\n MESSAGE: {}\nEXIT CODE: {}",
		         "ABORT".red(),
		         self.abort_msg.unwrap(),
		         self.get_exit_code());
	}
}
	
impl Error for ApolloResult {}
	
impl fmt::Display for ApolloResult {
	fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
		console::fmt_final_result(self, f)
	}
}

