use library::{
    controller::{
        self,
        dpo,
    },
    log::console,
    structures::{
        PhaseResult,
        PPAs,
    },
};
use std::{
    fs,
    process::Command,
};

const PCT1: u8 = 2;

/// # Getting Dependencies Ready
///
/// Sets up the necessary package-dependencies via PPAs.
///
/// Stage: 1,
/// Phase: 1 / 2
pub fn add_ppas() -> PhaseResult
{
    let cp = 1;
    let mut exit_code = 0;

    println!();
    console::print_phase_description(cp, PCT1, "Adding PPAs");

    let path = controller::get_resource_path(
        "library/resources/packages/ppas.json",
        cp,
        PCT1,
    )?;

    let json = match fs::read_to_string(path) {
        Ok(json_str) => json_str,
        Err(_) => return dpo(111, cp, PCT1),
    };

    let json_ppas: PPAs = match serde_json::from_str(&json) {
        Ok(json_ppas) => json_ppas,
        Err(_) => return dpo(112, cp, PCT1),
    };

    for ppa in json_ppas.critical() {
        if Command::new("sudo")
            .arg("add-apt-repository")
            .arg("-y")
            .arg(ppa)
            .output()
            .is_err()
        {
            return dpo(113, cp, PCT1);
        }
    }

    for ppa in json_ppas.optional() {
        let ppa: &str = ppa.as_str();
        if Command::new("sudo")
            .arg("add-apt-repository")
            .arg("-y")
            .arg(ppa)
            .output()
            .is_err()
        {
            exit_code = 10
        }
    }

    dpo(exit_code, cp, PCT1)
}

/// # Updating Dependencies
///
/// Updates APT signatures.
///
/// Stage: 1,
/// Phase: 2 / 2
pub fn update_package_information() -> PhaseResult
{
    let cp = 2;

    console::print_phase_description(
        cp,
        PCT1,
        "Updating APT Signatures",
    );

    match Command::new("sudo")
        .arg("apt-get")
        .arg("-y")
        .arg("update")
        .output()
    {
        Ok(_) => dpo(0, cp, PCT1),
        Err(_) => dpo(114, cp, PCT1),
    }
}
