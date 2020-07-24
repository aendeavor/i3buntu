use athena::PhaseResult;
use athena::console;

use std::{fs, path::{Path, PathBuf}};

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
	
	console::finalize_phase(cs, sct, &result);
	result
}

pub fn try_evade(mut base_path: PathBuf, dest: &Path) -> Result<String, PhaseResult>
{
	let mut debug_dest = base_path.clone();
	base_path.push(dest);
	
	match fs::read_to_string(&base_path)
	{
		Ok(file_str) => Ok(file_str),
		Err(_) => {
			debug_dest.push(Path::new("../"));
			debug_dest.push(dest);
			match fs::read_to_string(&debug_dest) {
				Ok(file_str) => Ok(file_str),
				Err(_) => Err(dpo(190, 1, 3))
			}
		}
	}
}