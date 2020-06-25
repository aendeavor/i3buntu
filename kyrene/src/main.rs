#![feature(termination_trait_lib)]
#![feature(in_band_lifetimes)]
#[macro_use] extern crate scan_rules;

/// # Actual Library
///
/// Contains all submodules of ***KYRENE*** which
/// do the work, driven by `main()`.
mod lib;
use lib::init;
use lib::data::ExitCodeCompatible;

/// # Version & Stability Tag
///
/// Globally used version name of ***KYRENE***.
/// Stability identifier indicated release or
/// development branching.
const VERSION: &'static str = "v0.1.0-alpha unstable";

/// # Main
///
/// Drives APOLLO.
fn main()
{
	let mut apollo_result = init::start();

	// STAGE 1
	let stage_one_data = match init::stage_one() {
		Ok(sod) => sod,
		Err(sod) => {
			apollo_result.set_failure(sod.get_exit_code());
			check_abort(&apollo_result);
			sod
		},
	};
	
	// STAGE 2
	if let Err(exit_code) = init::stage_two(stage_one_data) {
		apollo_result.set_failure(exit_code.get_exit_code());
		check_abort(&apollo_result);
	}
	
	// STAGE 3
	if let Err(exit_code) = init::stage_three() {
		apollo_result.set_failure(exit_code.get_exit_code());
		check_abort(&apollo_result);
	}

	println!("{}", apollo_result);
	std::process::exit(apollo_result.get_exit_code());
}

/// Checks whether to abort on a given exit code
/// or not. An abort exit code ranges from 100 to
/// 199.
pub fn check_abort(result: &lib::data::end::ApolloResult)
{
	if result.is_abort() {
		result.show_abort();
		std::process::exit(result.get_exit_code());
	}
}
