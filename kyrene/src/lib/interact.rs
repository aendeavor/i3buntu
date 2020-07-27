/// # Interaction for Stage 1
///
/// All user interaction in stage one is handled here.
pub mod stage_one {
	use athena::structures::Choices;
	
	/// The actual caller who drives the asking.
	pub fn user_choices() -> Choices
	{
		println!();
		let tex: bool   = ask("LaTeX");
		let java: bool  = ask("OpenJDK");
		let ct: bool    = ask("Cryptomator");
		let be: bool    = ask("Build-Essential");
		let oc: bool    = ask("ownCloud");
		
		let choices = Choices::new(tex, java, ct, be, oc);
		println!("{}", choices);
		
		choices
	}
	
	fn ask(package: impl std::fmt::Display) -> bool {
		print!("{} {}? [Y/n] ",
		       "  Would you like to install",
		       package);
		parse_input()
	}
	
	/// ! Separated from `ask()` due to compiler warnings
	/// originating in a macro.
	fn parse_input() -> bool
	{
		readln! {
			("") => true,
			("y") => true,
			("Y") => true,
			("yes") => true,
			("Yes") => true,
			(.._) => false
		}
	}
	
	/// Called by lib::init to check whether the user agreed
	/// to the choices he / she made.
	pub fn choices_ok() -> bool {
		print!("\n  Are these choices correct? [Y/n] ");
		parse_input()
	}
}
