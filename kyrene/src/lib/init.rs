use athena::{
	controller::{drive_stage, eval_success},
	structures::{
		ApolloResult,
		ExitCode,
		PhaseError,
		StageOneData,
		StageResult,
	},
	log::console,
	traits::ExitCodeCompatible,
};
use super::{components, interact};
use crate::lib::components::stage_two::vsc_ext;

/// # First Things First
///
/// Coordinates greetings message and creates
/// an `ApolloResult` instance. Called as first
/// function in `main()`.
pub fn start() -> ApolloResult
{
	console::welcome(crate::VERSION);
	
	match std::process::Command::new("sudo")
		.arg("apt-get")
		.arg("--help")
		.output() {
		Ok(_) => (),
		Err(_) => ()
	};
	
	ApolloResult::new()
}

/// # Stage 1
///
/// Drives all functions necessary for stage
/// one to complete. These include
///
/// - creation and propagation of user choices
/// - adding of PPAs
pub fn stage_one() -> StageResult<StageOneData>
{
	use components::stage_one;
	use interact::stage_one::{choices_ok, user_choices};
	
	console::print_stage_start(1, "INITIALIZATION");
	let mut sod = loop {
		let choices = user_choices();
		if choices_ok() {
			break StageOneData::new(choices);
		}
		println!();
	};
	
	let mut sod = drive_stage(stage_one::add_ppas, &mut sod)?;
	let sod = drive_stage(stage_one::update_package_information, &mut sod)?;
	
	eval_success(sod)
}

/// # Stage 2
///
/// Drives all functions necessary for stage
/// two to complete. These include
///
/// - installing the packages the user chose
/// - installing the base packages
/// - remove unnecessary
pub fn stage_two(stage_one_data: StageOneData) -> StageResult<ExitCode>
{
	use components::stage_two;
	
	console::print_stage_start(2, "PACKAGING");
	let mut exit_code = drive_stage(stage_two::install_base, &mut ExitCode(0))?;
	
	if let Some(stage_result) = stage_two::install_choices(&stage_one_data.choices) {
		match stage_result {
			PhaseError::SoftError(ec) => {
				exit_code.set_exit_code(ec);
			}
			PhaseError::HardError(ec) => {
				console::finalize_stage(ec);
				exit_code.set_exit_code(ec);
				return Err(exit_code);
			}
		}
	}
	
	if stage_one_data.choices.vsc { drive_stage(vsc_ext, &mut exit_code)?; }
	
	let exit_code = drive_stage(stage_two::remove_unnecessary, &mut exit_code)?;
	
	eval_success(exit_code)
}

/// # Stage 3
///
/// Drives all functions necessary for stage
/// two to complete. These include
///
/// - copies configuration files
pub fn stage_three() -> StageResult<ExitCode>
{
	use components::stage_three;
	
	console::print_stage_start(3, "CONFIGURATION");
	
	let mut exit_code = drive_stage(stage_three::copy_configurations, &mut ExitCode(0))?;
	let exit_code = drive_stage(stage_three::install_fonts, &mut exit_code)?;
	
	eval_success(exit_code)
}
