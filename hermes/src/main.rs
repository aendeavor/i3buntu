#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;

use rocket::config::{Config, Environment, LoggingLevel};
use rocket::response::Redirect;

fn main() {
	let application: rocket::Rocket = rocket::custom(configure());
    application
        .mount("/", routes![root])
        .launch();
}

fn configure() -> Config {
    let secret_key = "AfMs5/uaxAeYoNQSnJlbOgp2Z1vyDC0N8AHTxIdQL+U=";

    Config::build(Environment::Production)
        .address("0.0.0.0")
        .port(8080)
        .log_level(LoggingLevel::Normal)
        .secret_key(secret_key)
        .finalize()
        .expect("Configuration resulted in an error. Aborting.")
}

#[get("/")]
pub fn root() -> Redirect {
	Redirect::to("https://raw.githubusercontent.com/aendeavor/i3buntu/init/apollo/hermes/init.sh")
}
