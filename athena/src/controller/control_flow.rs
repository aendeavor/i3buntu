use super::super::{
    data::structures::{PhaseError, PhaseResult},
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

fn sync_files<S, T>(from: S, to: &T, sudo: bool) -> Option<u8>
	where S: AsRef<OsStr>,
	      T: AsRef<OsStr> + ?Sized
{
	let mut command = if sudo {
		Command::new("sudo")
	} else {
		Command::new("rsync")
	};
	
	if sudo { command.arg("rsync"); };
	
	return if let Err(_) = command
		.arg("-azr")
		.arg("--dry-run")
		.arg(from)
		.arg(to)
		.output()
	{
		console::print_sub_phase_description("  ✘\n".yellow());
		Some(30)
	} else {
		console::print_sub_phase_description("  ✔\n".green());
		None
	};
}

pub fn drive_sync<R, T>(description: R,
                    from: &str,
                    to: &T,
                    sudo: bool,
                    exit_code: &mut u8) -> Result<(), PhaseError>
	where R: std::fmt::Display,
	      T: AsRef<OsStr> + ?Sized
{
	console::print_sub_phase_description(description);
	
	let mut base = String::from("athena/resources/config/");
	base.push_str(from);
	
	if let Some(ec) = sync_files(
		&controller::get_resource_path(&base, 1, 3)?,
		to,
		sudo)
	{
		*exit_code = ec;
	}
	
	Ok(())
}
