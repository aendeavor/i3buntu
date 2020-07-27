use super::super::{
	data::structures::{PhaseResult, PhaseError},
	log::console
};

/// # Decide Phase Outcome (DPO)
///
/// Decides what a the result of a phase is,
/// i.e. whether it is `PhaseResult::Success`
/// `PhaseResult::SoftError(error_code)` or
/// `PhaseResult::HardError(error_code)`.
pub fn dpo(error_code: u8, cs: u8, sct: u8) -> PhaseResult
{
	let result = if error_code == 0 {
		return None
	} else if error_code > 100 {
		PhaseError::HardError(error_code)
	} else {
		PhaseError::SoftError(error_code)
	};
	
	console::finalize_phase(cs, sct, Some(&result));
	
	Some(result)
}
