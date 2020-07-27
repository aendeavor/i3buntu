/// # Stage 1
///
/// Worker for the first stage are found here. These
/// include `add_ppas()`.
pub mod stage_one;

/// # Stage 2
///
/// Worker for the second stage are found here. These
/// include
///
/// - `install_choices()` which processes user-choices
/// - `apt_install()` which installed the base packets.
pub mod stage_two;

/// # Stage 3
///
pub mod stage_three;
