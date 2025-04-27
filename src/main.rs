use std::io;


fn main() {
    println!("Hello from the Rust Dev Container!");
    // Add more code here
    let mut buffer = String::new(); // Create a buffer
    io::stdin().read_line(&mut buffer).unwrap(); // Wait for user input
}