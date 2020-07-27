#![feature(termination_trait_lib)]
#![feature(in_band_lifetimes)]
#![feature(try_trait)]

pub mod controller;
mod data;
pub mod log;

const VERSION: &'static str = "v0.2.1-alpha unstable";

pub use data::traits;
pub use data::structures;
