use super::super::{
	data::structures::PhaseError,
	log::console
};

/// # Local Resource Path
///
/// Provides
pub fn get_resource_path(to_append: &str, cs: u8, sct: u8) -> Result<String, PhaseError>
{
	if let Ok(path) = std::env::current_dir() {
		if let Some(path) = path.to_str() {
			let mut path = String::from(path);
			path.push('/');
			path.push_str(to_append);
			return Ok(path)
		}
	}
	
	let result = PhaseError::HardError(190);
	console::finalize_phase(cs, sct, Some(&result));
	
	Err(result)
}
