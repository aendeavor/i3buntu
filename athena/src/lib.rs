#![feature(termination_trait_lib)]
#![feature(in_band_lifetimes)]

mod controller;
mod data;
mod log;

const VERSION: &'static str = "v0.1.0-alpha unstable";

pub use data::structures::ExitCode;
pub use data::structures::Choices;
pub use data::structures::PhaseResult;
pub use data::structures::StageResult;
pub use data::structures::StageOneData;
pub use data::structures::ApolloResult;

pub use data::traits::ExitCodeCompatible;

pub use log::console;
