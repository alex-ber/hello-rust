//use std::io;


fn main() {
    println!("Hello from the Rust Dev Container!");
    // Add more code here
    //let mut buffer = String::new(); // Create a buffer
    //io::stdin().read_line(&mut buffer).unwrap(); // Wait for user input
    let liteal: &str = "Hello";
    let result: String =  newstr(liteal);
    print!("{:#?}", result);
    println!();

    let intarray: [i32;5] = [10,12,22, 34, 56];
    let result:  Vec<i32> = newints(&intarray[..intarray.len()-1]);
    print!("{:#?}", result);
}

fn newstr(s: &str) -> String {
    let mut result: String = String::from(s); // Create an owned, mutable String
    result.push_str("a");           // Append the slice "&str"
    result         
}

fn newints(intslice: &[i32]) -> Vec<i32> {
    let mut vec = intslice.to_vec();
    vec.push(42);
    vec

}