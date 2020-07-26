#![feature(termination_trait_lib)]
#![feature(in_band_lifetimes)]

mod controller;
mod data;
mod log;

const VERSION: &'static str = "v0.1.0-alpha unstable";

pub use data::structures::ApolloResult;
pub use data::structures::Choices;
pub use data::structures::ExitCode;
pub use data::structures::PhaseResult;
pub use data::structures::PPAs;
pub use data::structures::StageOneData;
pub use data::structures::StageResult;

pub use data::traits::ExitCodeCompatible;

pub use log::console;

use std::path::PathBuf;
use std::io::Result;
pub fn get_current_dir() -> Result<PathBuf>
{
	std::env::current_dir()
}
