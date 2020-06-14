use crate::lib::{data::PhaseResult, log};

/// # Decide Phase Outcome (DPO)
///
/// Decides what a the result of a phase is,
/// i.e. whether it is `PhaseResult::Success`
/// or a `PhaseResult::SoftError(error_code)`.
pub fn dpo(error_code: u8, cs: u8, sct: u8) -> PhaseResult
{
	let result = if error_code == 0 {
		PhaseResult::Success
	} else if error_code > 100 {
		PhaseResult::HardError(error_code)
	} else {
		PhaseResult::SoftError(error_code)
	};
	
	log::console::finalize_phase(cs, sct, &result);
	result
}