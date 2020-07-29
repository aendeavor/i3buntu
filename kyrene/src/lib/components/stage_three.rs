use athena::{
	controller::{dpo, drive_sync},
	log::console,
	structures::PhaseResult,
};
use dirs_next;

pub fn copy_configurations() -> PhaseResult
{
	let mut exit_code = 0;
	console::print_phase_description(1, 1, "Copying Configuration Files");
	
	let home = match dirs_next::home_dir() {
		Some(path) => path,
		None => return dpo(131, 1, 3)
	};
	
	drive_sync("     :: Syncing over ${{HOME}}", "home/",
	           &home, false, &mut exit_code)?;
	
	drive_sync("     :: Syncing LightDM main config", "lightdm.conf",
	           "/etc/lightdm/", true, &mut exit_code)?;
	
	drive_sync("     :: Syncing LightDM greeter config", "slick-greeter.conf",
	           "/etc/lightdm/", true, &mut exit_code)?;
	
	drive_sync("     :: Syncing Xorg config", "xorg.conf",
	           "/etc/X11/", true, &mut exit_code)?;
	
	dpo(exit_code, 1, 3)
}
