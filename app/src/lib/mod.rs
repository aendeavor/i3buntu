/// # Main Driver
///
/// Serves a sort of "runtime" for the application.
/// It coordinates the procedure of all functions
/// and regulates information exchange.
pub mod init;

/// # I/O
///
/// Handles user input.
mod interact;

/// # Actual Workers
///
/// Nearly all "work" is done here, i.e. installations,
/// configuration-file deployment, postconf, etc.
mod components;
