/// # Interaction for Stage 1
///
/// All user interaction in stage one is handled here.
pub mod stage_one
{
    use library::structures::Choices;

    /// Drives the asking process.
    pub fn user_choices() -> Choices
    {
        let choices = Choices::new(
            ask("LaTeX"),
            ask("OpenJDK"),
            ask("Cryptomator"),
            ask("Build-Essential"),
            ask("ownCloud"),
            ask("Docker"),
            ask("Visual Studio Code"),
            ask("Rust"),
        );

        println!("{}", choices);
        choices
    }

    /// Asks the user about a specific installation
    /// candidate provided as an argument.
    fn ask(package: impl std::fmt::Display) -> bool
    {
        print!("  Would you like to install {}? [Y/n] ", package);
        parse_input()
    }

    /// Separated from `ask()` due to compiler warnings
    /// originating in a macro.
    #[allow(clippy::cognitive_complexity)]
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

    /// Called by `lib::init` to check whether the user
    /// agreed to the choices he / she made.
    pub fn choices_ok() -> bool
    {
        print!("\n  Are these choices correct? [Y/n] ");
        parse_input()
    }
}
