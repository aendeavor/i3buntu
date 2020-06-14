// * ———————————————————————————— PUBLIC MODULES

/// # Main Driver
///
/// `init` serves a sort of "runtime" for APOLLO. It
/// coordinates the procedure of all functions and
/// regulates information exchange.
pub mod init;

/// # Database
///
/// `data` provides information about stages and their
/// sub-data types. Mainly structs are found here,
/// including their (trait) implementations and methods.
pub mod data;

// * ———————————————————————————— PRIVATE MODULES

/// # I/O
///
/// `interact` handles user input.
///
/// ### ASYNC/AWAIT
///
/// TODO For I/O, Async/Await should be employed.
mod interact;

/// # Console & Logfile
///
/// `log` provides all logging functionality for APOLLO.
/// Console output and logfile creation and use are done
/// here.
mod log;

/// # Labours of Heracles
///
/// Nearly all "work" is done here, i.e. installations,
/// configuration-file deployment, postconf, etc.
mod work;
