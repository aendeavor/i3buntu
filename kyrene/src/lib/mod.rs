// * ———————————————————————————— PUBLIC MODULES

/// # Main Driver
///
/// `init` serves a sort of "runtime" for APOLLO. It
/// coordinates the procedure of all functions and
/// regulates information exchange.
pub mod init;

// * ———————————————————————————— PRIVATE MODULES

/// # I/O
///
/// `interact` handles user input.
///
/// ### ASYNC/AWAIT
///
/// TODO For I/O, Async/Await should be employed.
mod interact;

/// # Labours of Heracles
///
/// Nearly all "work" is done here, i.e. installations,
/// configuration-file deployment, postconf, etc.
mod components;
