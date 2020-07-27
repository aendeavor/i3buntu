#![feature(termination_trait_lib)]
#![feature(in_band_lifetimes)]
#![feature(try_trait)]

mod controller;
mod data;
mod log;

const VERSION: &'static str = "v0.1.0-alpha unstable";

pub use data::structures::ApolloResult;
pub use data::structures::Choices;
pub use data::structures::ExitCode;
pub use data::structures::PhaseError;
pub use data::structures::PhaseResult;
pub use data::structures::PPAs;
pub use data::structures::StageOneData;
pub use data::structures::StageResult;

pub use data::traits::ExitCodeCompatible;

pub use log::console;


pub fn get_resource_path(to_append: &str, cs: u8, sct: u8) -> Result<String, PhaseError>
{
	if let Ok(path) = std::env::current_dir() {
		if let Some(path) = path.to_str() {
			let mut path = String::from(path);
			path.push('/');
			path.push_str(to_append);
			return Ok(path)
		}
	}
	
	let result = PhaseError::HardError(190);
	console::finalize_phase(cs, sct, Some(&result));
	
	Err(result)
}

/// # Decide Phase Outcome (DPO)
///
/// Decides what a the result of a phase is,
/// i.e. whether it is `PhaseResult::Success`
/// `PhaseResult::SoftError(error_code)` or
/// `PhaseResult::HardError(error_code)`.
pub fn dpo(error_code: u8, cs: u8, sct: u8) -> PhaseResult
{
	let result = if error_code == 0 {
		return None
	} else if error_code > 100 {
		PhaseError::HardError(error_code)
	} else {
		PhaseError::SoftError(error_code)
	};
	
	console::finalize_phase(cs, sct, Some(&result));
	
	Some(result)
}
