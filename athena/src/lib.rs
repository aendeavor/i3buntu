#![feature(in_band_lifetimes)]
#![feature(try_trait)]

pub mod controller;
mod data;
pub mod log;

const VERSION: &'static str = "v0.2.2-alpha rc1 unstable";

pub use data::structures;
pub use data::traits;
