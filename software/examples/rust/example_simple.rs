use std::{error::Error, io};

use tinkerforge::{ipconnection::IpConnection, load_cell_bricklet::*};

const HOST: &str = "127.0.0.1";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your Load Cell Bricklet

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection
    let load_cell_bricklet = LoadCellBricklet::new(UID, &ipcon); // Create device object

    ipcon.connect(HOST, PORT).recv()??; // Connect to brickd
                                        // Don't use device before ipcon is connected

    // Get current weight
    let weight = load_cell_bricklet.get_weight().recv()?;
    println!("Weight: {}{}", weight, " g");

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
