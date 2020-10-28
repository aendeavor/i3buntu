use super::super::{
    data::structures::{
        ApolloResult,
        PhaseError,
        PhaseResult,
        StageResult,
    },
    data::traits::ExitCodeCompatible,
    log::console,
};

/// # Abort Early
///
/// Checks whether to abort on a given exit code
/// or not. An abort exit code ranges from 100 to 199.
pub fn check_abort<T: ExitCodeCompatible>(result: &mut ApolloResult, exit_code: T)
{
    result.set_failure(exit_code.get_exit_code());

    if result.is_abort() {
        result.show_abort();
        std::process::exit(result.get_exit_code());
    }
}

/// # Phase Driver
///
/// Drives a phase and decides the outcome. This
/// result is the propagated with the `?` Opera-
/// tor.
pub fn drive_phase<'a, F, D>(phase: F, data: &mut D) -> StageResult<D>
where
    F: Fn() -> PhaseResult,
    D: ExitCodeCompatible + Clone + 'a,
{
    if let Some(phase_error) = phase() {
        return match phase_error {
            PhaseError::SoftError(ec) => {
                data.set_exit_code(ec);
                Ok(data.clone())
            },
            PhaseError::HardError(ec) => {
                console::finalize_stage(ec);
                data.set_exit_code(ec);
                Err(data.clone())
            },
        };
    }

    Ok(data.clone())
}

/// # Decide Phase Outcome (DPO)
///
/// Decides what a the result of a phase is,
/// i.e. whether it is `PhaseResult::Success`
/// `PhaseResult::SoftError(error_code)` or
/// `PhaseResult::HardError(error_code)`.
pub fn dpo(error_code: u8, cp: u8, tpc: u8) -> PhaseResult
{
    let result = if error_code == 0 {
        return None;
    } else if error_code > 100 {
        PhaseError::HardError(error_code)
    } else {
        PhaseError::SoftError(error_code)
    };

    console::finalize_phase(cp, tpc, Some(&result));

    Some(result)
}

/// # Evaluate Stage Ending
///
/// Checks the exit code and returns
/// an `Ok()` or `Err()` value.
pub fn eval_success<T>(exit_code: T) -> StageResult<T>
where
    T: ExitCodeCompatible,
{
    if exit_code.is_success() {
        console::finalize_stage(exit_code.get_exit_code());
        Ok(exit_code)
    } else {
        console::finalize_stage(exit_code.get_exit_code());
        Err(exit_code)
    }
}
