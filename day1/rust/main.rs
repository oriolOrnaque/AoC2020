use std::fs::File;
use std::io::{BufRead, BufReader};

fn solve1(entries: &Vec<i32>) {
    // O(n^2)
    // Could be improved to O(n logn)
    'outer: for num in entries.iter() {
        for num2 in entries.iter() {
            if num + num2 == 2020 {
                println!("{}", num * num2);
                break 'outer;
            }
        }
    }
}

fn solve2(entries: &Vec<i32>) {
    // O(n^3)
    // Could be improved to O(n^2 logn)
    'outer: for num in entries.iter() {
        for num2 in entries.iter() {
            for num3 in entries.iter() {
                if num + num2 + num3 == 2020 {
                    println!("{}", num * num2 * num3);
                    break 'outer;
                }
            }
        }
    }
}

fn main() -> std::io::Result<()> {

    let file = File::open("../input")?;
    let reader = BufReader::new(file);

    let entries: Vec<i32> = reader.lines().map(|line| line.unwrap().parse::<i32>().unwrap()).collect();

    solve1(&entries);

    solve2(&entries);

    Ok(())
}
