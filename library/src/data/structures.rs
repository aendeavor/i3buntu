use super::super::{
    log::console,
    traits::ExitCodeCompatible,
};
use std::{
    error::Error,
    fmt,
};
use serde::{
    Deserialize,
    Serialize,
};

/// # Stage Result
///
/// Resembles the outcome of a stage. These
/// outcomes must only implement `ExitCodeCompatible`.
#[allow(type_alias_bounds)]
pub type StageResult<D: ExitCodeCompatible> = Result<D, D>;

/// # Exit Code
///
/// Resembles the general exit code for
/// each subroutine. Used for error
/// propagation.
#[derive(Clone, Copy)]
pub struct ExitCode(pub u8);

impl ExitCode
{
    pub fn new() -> Self { Self::default() }

    pub const fn is_success(self) -> bool { self.0 == 0 }
}

impl std::default::Default for ExitCode
{
    fn default() -> Self { Self(0) }
}

impl ExitCodeCompatible for ExitCode
{
    fn set_exit_code(&mut self, exit_code: u8) { self.0 = exit_code; }

    fn get_exit_code(&self) -> u8 { self.0 }

    fn is_success(&self) -> bool { self.0 == 0 }
}

/// # Phase Error
///
/// Resembles the kinds of error
/// a phase can have.
pub enum PhaseError
{
    /// A phase ended normally, but a recoverable
    /// error occurred.
    SoftError(u8),
    /// A phase ended prematurely caused by an
    /// unrecoverable error.
    HardError(u8),
}

/// # Phase Result
///
/// Resembles the outcome of a phase. These always contain
/// `PhaseSuccess`-enums.
pub type PhaseResult = Option<PhaseError>;

impl std::convert::From<PhaseError> for std::option::NoneError
{
    fn from(_: PhaseError) -> Self { Self }
}

/// # `StageOneData`
///
/// All information provided by the completion
/// of stage one.
#[derive(Debug, Clone, Copy)]
pub struct StageOneData
{
    pub choices: Choices,
    exit_code:   u8,
    is_success:  bool,
}

impl StageOneData
{
    pub const fn new(choices: Choices) -> Self
    {
        Self {
            choices,
            exit_code: 0,
            is_success: true,
        }
    }

    pub const fn is_success(&self) -> bool { self.is_success }
}

impl ExitCodeCompatible for StageOneData
{
    fn set_exit_code(&mut self, exit_code: u8)
    {
        self.exit_code = exit_code;
        if exit_code == 0 {
            self.is_success = true;
        } else {
            self.is_success = false;
        }
    }

    fn get_exit_code(&self) -> u8 { self.exit_code }

    fn is_success(&self) -> bool { self.is_success() }
}

impl fmt::Display for StageOneData
{
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result
    {
        console::stage_one::fmt_stage_one_data(self, f)
    }
}

impl Error for StageOneData {}

/// # User Software Choices
///
/// `Choices` holds all the choices made by the user
/// about which packages to install, and which not to
/// install.
///
/// ## Special Implementation
///
/// `Choices` implements `Iterator`, so that one can
/// loop over this struct to get the entries to install
/// them.
#[allow(clippy::clippy::struct_excessive_bools)]
#[derive(Debug, Clone, Copy)]
pub struct Choices
{
    pub tex:  bool,
    pub java: bool,
    pub ct:   bool,
    pub be:   bool,
    pub oc:   bool,
    pub vsc:  bool,
    pub dock: bool,
    pub rust: bool,
    next:     u8,
}

#[allow(
    clippy::clippy::fn_params_excessive_bools,
    clippy::clippy::too_many_arguments
)]
impl Choices
{
    pub const fn new(
        tex: bool,
        java: bool,
        ct: bool,
        be: bool,
        oc: bool,
        dock: bool,
        vsc: bool,
        rust: bool,
    ) -> Self
    {
        Self {
            tex,
            java,
            ct,
            be,
            oc,
            dock,
            vsc,
            rust,
            next: 0,
        }
    }
}

impl Error for Choices {}

impl fmt::Display for Choices
{
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result
    {
        console::stage_one::fmt_choices(self, f)
    }
}

#[allow(clippy::copy_iterator)]
impl Iterator for Choices
{
    type Item = &'static str;

    fn next(&mut self) -> Option<Self::Item>
    {
        self.next += 1;

        if self.tex && self.next == 1 {
            return Some("texlive-full");
        } else if self.next < 2 {
            self.next = 2;
        }

        if self.java && self.next == 2 {
            return Some("openjdk-14-jdk");
        } else if self.next < 3 {
            self.next = 3;
        }

        if self.ct && self.next == 3 {
            return Some("cryptomator");
        } else if self.next < 4 {
            self.next = 4;
        }

        if self.be && self.next == 4 {
            return Some("build-essential");
        } else if self.next < 5 {
            self.next = 5;
        }

        if self.oc && self.next == 5 {
            return Some("owncloud-client");
        } else if self.next < 6 {
            self.next = 6;
        }

        if self.dock && self.next == 5 {
            return Some("docker.io");
        }

        self.next = 0;
        None
    }
}

/// # Personal Package Archives
///
/// This struct holds parsed PPAs. The critical
/// section has to be installed while the optional
/// section is not mandatory.
#[derive(Serialize, Deserialize, Debug)]
pub struct PPAs
{
    critical: Vec<String>,
    optional: Vec<String>,
}

impl PPAs
{
    pub const fn critical(&self) -> &Vec<String> { &self.critical }

    pub const fn optional(&self) -> &Vec<String> { &self.optional }
}

/// # `AppResult`
///
/// Used for error propagation to top level `main()`
/// and to decide whether the installation was a
/// success or a failure. In case of a failure,
/// there is also an indication whether the
/// installation ended in an abort.
#[derive(Debug)]
pub struct AppResult
{
    success:   bool,
    abort:     bool,
    /// Exit codes between 0 - 99 indicate a recoverable
    /// error.
    ///
    /// Exit codes between 100 - 199 indicate unrecoverable
    /// errors.
    ///
    /// Exit codes >200 are reserved.
    exit_code: i32,
    abort_msg: Option<&'static str>,
}

impl AppResult
{
    pub fn new() -> Self { Self::default() }

    pub const fn is_success(&self) -> bool { self.success }

    pub const fn is_abort(&self) -> bool { self.abort }

    pub fn set_failure(&mut self, exit_code: u8)
    {
        if self.exit_code > 99 {
            panic!(
                "Setting the error code twice is not allowed when \
                 the first error code indicated an abort."
            )
        }

        self.success = false;
        self.set_exit_code(exit_code);
        if exit_code > 99 {
            self.set_abort();
        }
    }

    fn set_abort(&mut self)
    {
        self.abort = true;

        match self.get_exit_code() {
            111 => {
                self.abort_msg = Some(
                    "S1P1 - Could not read from path to JSON string",
                )
            },
            112 => {
                self.abort_msg =
                    Some("S1P1 - Could not parse PPAs from JSON")
            },
            113 => {
                self.abort_msg = Some(
                    "S1P1 - Could not add a critical APT repository",
                )
            },
            114 => {
                self.abort_msg =
                    Some("S1P2 - Could not update APT signatures")
            },
            121 => {
                self.abort_msg = Some(
                    "S2P1 - Could not read from path to JSON string",
                )
            },
            122 => {
                self.abort_msg =
                    Some("S2P1 - Could not parse programs from JSON")
            },
            _ => panic!(
                "Exit Code for abort not implemented in \
                 lib::data::end::AppResult.set_abort. Exit code \
                 was: {}",
                self.get_exit_code()
            ),
        }
    }

    pub const fn get_exit_code(&self) -> i32 { self.exit_code }

    #[allow(clippy::cast_lossless)]
    fn set_exit_code(&mut self, exit_code: u8)
    {
        self.exit_code = exit_code as i32;
    }

    /// Wrapper for log-function `show_abort()`
    /// Prints the abort information just before aborting
    /// in `main()`.
    pub fn show_abort(&self)
    {
        use colored::Colorize;

        println!(
            "\n\n{}\n MESSAGE: {}\nEXIT CODE: {}",
            "ABORT".red(),
            self.abort_msg.unwrap(),
            self.get_exit_code()
        );
    }
}

impl std::default::Default for AppResult
{
    fn default() -> Self
    {
        Self {
            success:   true,
            abort:     false,
            exit_code: 0,
            abort_msg: None,
        }
    }
}

impl Error for AppResult {}

impl fmt::Display for AppResult
{
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result
    {
        console::fmt_final_result(self, f)
    }
}
