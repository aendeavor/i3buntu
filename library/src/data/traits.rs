/// # Being Able to Set an Exit Code
///
/// This trait allows types to be able to set
/// and get an exit code from a structure.
pub trait ExitCodeCompatible: Clone + Copy
{
	fn set_exit_code(&mut self, exit_code: u8);
	fn get_exit_code(&self) -> u8;
	fn is_success(&self) -> bool;
}
