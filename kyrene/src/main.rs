#![feature(termination_trait_lib)]
#![feature(in_band_lifetimes)]

#[macro_use]
extern crate scan_rules;

mod lib;

use athena::controller::check_abort;
use lib::init;

const VERSION: &'static str = "v0.3.4-alpha rc1 unstable";

fn main()
{
	let mut apollo_result = init::start();
	
	let stage_one_data = match init::stage_one() {
		Ok(sod) => sod,
		Err(sod) => {
			check_abort(&mut apollo_result, sod);
			sod
		}
	};
	
	if let Err(exit_code) = init::stage_two(stage_one_data) {
		check_abort(&mut apollo_result, exit_code);
	}
	
	if let Err(exit_code) = init::stage_three() {
		check_abort(&mut apollo_result, exit_code);
	}
	
	println!("{}", apollo_result);
	std::process::exit(apollo_result.get_exit_code());
}
