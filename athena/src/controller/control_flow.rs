use super::super::{
    data::structures::{PhaseError, PhaseResult, StageResult},
    data::traits::ExitCodeCompatible,
    log::console,
};

/// # Decide Phase Outcome (DPO)
///
/// Decides what a the result of a phase is,
/// i.e. whether it is `PhaseResult::Success`
/// `PhaseResult::SoftError(error_code)` or
/// `PhaseResult::HardError(error_code)`.
pub fn dpo(error_code: u8, cs: u8, sct: u8) -> PhaseResult {
    let result = if error_code == 0 {
        return None;
    } else if error_code > 100 {
        PhaseError::HardError(error_code)
    } else {
        PhaseError::SoftError(error_code)
    };

    console::finalize_phase(cs, sct, Some(&result));

    Some(result)
}

// * ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/// Drives a phase and decides the outcome. This
/// result is the propagated with the `?` Opera-
/// tor.
pub fn drive_stage<'a, F, D>(phase: F, data: &mut D) -> StageResult<D>
	where F: Fn() -> PhaseResult,
	      D: ExitCodeCompatible + Clone + 'a
{
	if let Some(phase_success) = phase() {
		return match phase_success {
			PhaseError::SoftError(ec) => {
				data.set_exit_code(ec);
				Ok(data.to_owned())
			},
			PhaseError::HardError(ec) => {
				console::finalize_stage(ec);
				data.set_exit_code(ec);
				Err(data.to_owned())
			}
		}
	}
	
	Ok(data.to_owned())
}

/// # Evaluate Stage Ending
///
/// Checks the exit code and returns
/// an `Ok()` or `Err()` value.
pub fn eval_success<T>(exit_code: T) -> StageResult<T>
	where T: ExitCodeCompatible
{
	if exit_code.is_success() {
		console::finalize_stage(exit_code.get_exit_code());
		Ok(exit_code)
	} else {
		console::finalize_stage(exit_code.get_exit_code());
		Err(exit_code)
	}
}
