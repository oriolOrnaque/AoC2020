use std::fs::File;
use std::io::{BufRead, BufReader};

fn solve1_improved(entries: &Vec<i32>) {
    // O(n log(n))
    'outer: for num in entries.iter() {
        if entries.binary_search(&(2020 - num)).is_ok() {
            println!("{}", num * (2020 - num));
            break 'outer;
        }
    }
}

fn solve2_improved(entries: &Vec<i32>) {
    // O(n^2 logn)
    'outer: for num in entries.iter() {
        for num2 in entries.iter() {
            if entries.binary_search(&(2020 - num - num2)).is_ok() {
                println!("{}", num * num2 * (2020 - num - num2));
                break 'outer;
            }
        }
    }
}

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

    let mut entries: Vec<i32> = reader.lines().map(|line| line.unwrap().parse::<i32>().unwrap()).collect();

    entries.sort(); // nlogn

    solve1_improved(&entries);
    solve2_improved(&entries);

    Ok(())
}
