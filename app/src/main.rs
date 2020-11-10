#![deny(clippy::all)]
#![deny(clippy::nursery)]
#![deny(clippy::pedantic)]
#![allow(clippy::must_use_candidate)]
#![feature(termination_trait_lib)]
#![feature(in_band_lifetimes)]

#[macro_use] extern crate scan_rules;

mod lib;

use library::controller::check_abort;
use lib::init;

const VERSION: &str = "v0.4.2-production rc5 stable";

fn main()
{
	let mut app_result = init::start();

	let stage_one_data = match init::stage_one() {
		Ok(sod) => sod,
		Err(sod) => {
			check_abort(&mut app_result, sod);
			sod
		},
	};

	if let Err(exit_code) = init::stage_two(stage_one_data) {
		check_abort(&mut app_result, exit_code);
	}

	if let Err(exit_code) = init::stage_three() {
		check_abort(&mut app_result, exit_code);
	}

	println!("{}", app_result);
	std::process::exit(app_result.get_exit_code());
}
