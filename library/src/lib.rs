#![deny(clippy::all)]
#![deny(clippy::nursery)]
#![deny(clippy::pedantic)]
#![allow(clippy::must_use_candidate)]
#![feature(in_band_lifetimes)]
#![feature(try_trait)]

pub mod controller;
mod data;
pub mod log;

const VERSION: &str = "v0.3.0-stable";

pub use data::structures;
pub use data::traits;
