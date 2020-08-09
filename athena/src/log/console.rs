use super::super::data::structures::{ApolloResult, PhaseError};
use colored::Colorize;
use std::{
    fmt,
    io::{self, Write},
};

/// # Greetings
///
/// Creates the greetings-message upon starting APOLLO.
pub fn welcome(app_version: &'static str)
{
    println!("\nWelcome to {}\n\nLIB {}\nAPP {}\n\nWe are going to walk you through a few steps\nto complete the setup. These include:\n\n  1. \
	Initialization\n  2. Installation of Software\n  3. Deployment of Configuration Files\n  4. Cleanup and Post-Configuration\n\nAs we need sup\
	eruser privileges to install\nprograms and to reach some locations, please\ninput your password if prompted.\n",
	         "APOLLO".bold().magenta(),
	         crate::VERSION,
	         app_version);
	
	match std::process::Command::new("sudo")
		.arg("apt-get")
		.arg("--help")
		.output()
	{
		Ok(_) => (),
		Err(_) => ()
	};
}

/// # Stages
///
/// Stages are the main blocks where work
/// is divided into. Stages consist of
/// phases.
pub fn print_stage_start(stage_number: u8, stage_name: &str) {
    println!("\nSTAGE {}\n{} {{\n", stage_number, stage_name.magenta());
}

/// # Phases
///
/// Phases are sub-sections of stages. Stages
/// consist of phases. This logger wraps the
/// beginning of a phase with the number of
/// the phase and a description
pub fn print_phase_description(current_phase: u8, total_phase_count: u8, msg: &str) {
    print!("  ({}/{}) {}\n", current_phase, total_phase_count, msg);

    flush();
}

/// # Descriptions
///
/// As work id done in phases, they will
/// log information on the console to in-
/// form the user about the progess.
pub fn print_sub_phase_description<T>(message: T)
where
    T: fmt::Display,
{
    print!("{}", message);
    flush();
}

/// # Closing a Phase
///
/// Does exactly the opposite of `phase_init()`.
/// Ends a phase and indicates success.
pub fn finalize_phase(current_stage: u8, stage_count_total: u8, result: Option<&PhaseError>) {
    if let Some(phase_error) = result {
        match phase_error {
            PhaseError::SoftError(ec) => {
                print!(
                    "  ({}/{}) {} — Error {}",
                    current_stage,
                    stage_count_total,
                    "✘".yellow(),
                    ec
                );
            }
            PhaseError::HardError(ec) => {
                print!(
                    "  ({}/{}) {} — Error {}",
                    current_stage,
                    stage_count_total,
                    "✘".red(),
                    ec
                );
            }
        }
    } else {
        print!(
            "  ({}/{}) {}",
            current_stage,
            stage_count_total,
            "✔".green()
        );
    }

    flush();
    println!();
}

/// # Closing a Stage
///
/// Ends a stage and indicates success.
pub fn finalize_stage(ec: u8) {
    match ec {
        0 => println!("\n}} {}", "✔".green()),
        1..=99 => println!("\n}} {} ({})", "✘".yellow(), ec),
        _ => println!("\n}} {} ({})", "✘".red(), ec),
    }
}

#[allow(dead_code)]
/// # Debug(ging on the console is always a good idea)
///
/// Prints useful debugging information onto the console
/// during testing.
pub fn debug<S: fmt::Display>(msg: S, obj: impl std::fmt::Debug) {
    println!(
        "This is a {} message!\nMESSAGE: {}\nERROR:  {:#?}",
        "DEBUG".blue(),
        msg,
        obj
    );
}

fn flush() {
    io::stdout()
        .flush()
        .ok()
        .expect("Couldn't flush stdout in ::log::console::flush()");
}

/// # Stage 1
///
/// Prints all the information that is needed
/// during S1 onto the console.
pub mod stage_one {
    use super::super::super::data::{
        structures::{Choices, StageOneData},
        traits::ExitCodeCompatible,
    };
    use colored::Colorize;
    use std::fmt;

    /// For displaying what the user choice are.
    /// If a user pressed the wrong button, he can
    /// accept to enter his choices again. This is
    /// a visual representation.
    pub fn fmt_choices(choices: &Choices, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "\n  Your installation candidates:\n              \
			LaTeX  {}\n            OpenJDK  {}\n        Cryptomator  {}\n    \
			Build-Essential  {}\n           ownCloud  {}\n             Docker  {}\
			\n Visual Studio Code  {}\n               Rust  {}",
            tb(choices.tex),
            tb(choices.java),
            tb(choices.ct),
            tb(choices.be),
            tb(choices.oc),
            tb(choices.dock),
            tb(choices.vsc),
            tb(choices.rust),
	        
        )
    }

    /// For debugging purposes, to display what
    /// the `StageOneData` struct holds.
    pub fn fmt_stage_one_data(sod: &StageOneData, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}\nSTAGE 1\n{} {{\n{}\n  EXIT CODE: {}\n  SUCCESS: {}",
            "DATA".red(),
            "INITIALIZATION".magenta(),
            sod.choices,
            sod.get_exit_code(),
            sod.is_success()
        )
    }

    /// Helper function. Translates the given boolean into
    /// a string representation. ("Translate Boolean")
    fn tb(val: bool) -> &'static char {
        if val {
            &'✔'
        } else {
            &'✘'
        }
    }
}

/// # Final Console Output
///
/// Formats the final console output returned before exiting `main()`.
pub fn fmt_final_result(apollo: &ApolloResult, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    println!();
    let label = "APOLLO".magenta().bold();
    if apollo.is_success() {
        write!(f, "{} has finished. There were no errors.", label)
    } else if !apollo.is_abort() {
        write!(
            f,
            "{} has finished, but there were minor errors. Final exit code was {}.",
            label,
            apollo.get_exit_code()
        )
    } else {
        write!(
            f,
            "{} has finished early. An unrecoverable situation was encountered. Exit code was {}",
            label,
            apollo.get_exit_code()
        )
    }
}
