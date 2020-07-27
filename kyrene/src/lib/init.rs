use athena::{
	log::console,
	structures::{
		ApolloResult,
		ExitCode,
		PhaseError,
		PhaseResult,
		StageOneData,
		StageResult
	},
	traits::ExitCodeCompatible
};
use super::{components, interact};

// TODO uncomment
/// # First Things First
///
/// Coordinates greetings message and creates
/// an `ApolloResult` instance. Called as first
/// function in `main()`.
pub fn start() -> ApolloResult
{
	console::welcome(crate::VERSION);
	
	// match std::process::Command::new("sudo")
	// 	.arg("apt-get")
	// 	.arg("--help")
	// 	.output() {
	// 	Ok(_) => (),
	// 	Err(_) => ()
	// };
	
	ApolloResult::new()
}

/// Drives a phase and decides the outcome. This
/// result is the propagated with the `?` Opera-
/// tor.
fn drive<'a, F, D>(phase: F, mut data: D) -> StageResult<D>
	where F: Fn() -> PhaseResult,
		  D: ExitCodeCompatible + 'a
{
	if let Some(phase_success) = phase() {
		return match phase_success {
			PhaseError::SoftError(ec) => {
				data.set_exit_code(ec);
				Ok(data)
			},
			PhaseError::HardError(ec) => {
				console::finalize_stage(ec);
				data.set_exit_code(ec);
				Err(data)
			}
		}
	}
	
	Ok(data)
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
	use interact::stage_one::{choices_ok, user_choices};
	
	console::print_stage_start(1, "INITIALIZATION");
	let sod = loop {
		let choices = user_choices();
		if choices_ok() {
			break StageOneData::new(choices);
		}
	};
	
	let sod = drive(components::stage_one::add_ppas, sod)?;
	let sod = drive(components::stage_one::update_package_information, sod)?;

	if sod.is_success() {
		console::finalize_stage(sod.get_exit_code());
		Ok(sod)
	} else {
		console::finalize_stage(sod.get_exit_code());
		Err(sod)
	}
}

/// # Stage 2
///
/// Drives all functions necessary for stage
/// one to complete. These include
///
/// - installing the packages the user chose
/// - installing the base packages
/// - remove unnecessary
pub fn stage_two(stage_one_data: StageOneData) -> StageResult<ExitCode>
{
	console::print_stage_start(2, "PACKAGING");
	let mut exit_code = drive(components::stage_two::install_base, ExitCode(0))?;
	
	if let Some(stage_result) = components::stage_two::install_choices(&stage_one_data.choices) {
		match stage_result {
			PhaseError::SoftError(ec) => {
				exit_code.set_exit_code(ec);
			},
			PhaseError::HardError(ec) => {
				console::finalize_stage(ec);
				exit_code.set_exit_code(ec);
				return Err(exit_code);
			}
		}
	}

	let exit_code = drive(components::stage_two::remove_unnecessary, exit_code)?;
	
	if exit_code.is_success() {
		console::finalize_stage(exit_code.0);
		Ok(exit_code)
	} else {
		console::finalize_stage(exit_code.0);
		Err(exit_code)
	}
}

pub fn stage_three() -> StageResult<ExitCode>
{
	console::print_stage_start(3, "CONFIGURATION");
	
	let exit_code = drive(components::stage_three::copy_configurations, ExitCode(0))?;
	
	if exit_code.is_success() {
		console::finalize_stage(exit_code.0);
		Ok(exit_code)
	} else {
		console::finalize_stage(exit_code.0);
		Err(exit_code)
	}
}
