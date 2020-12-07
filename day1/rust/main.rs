use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() -> std::io::Result<()> {

    let file = File::open("../input")?;
    let reader = BufReader::new(file);

    let entries: Vec<i32> = reader.lines().map(|line| line.unwrap().parse::<i32>().unwrap()).collect();

    'outer: for num in entries.iter() {
        for num2 in entries.iter() {
            if num + num2 == 2020 {
                println!("{}", num * num2);
                break 'outer;
            }
        }
    }

    Ok(())
}
