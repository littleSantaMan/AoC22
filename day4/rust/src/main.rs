use std::fs;
use std::collections::HashSet;
use std::time::Instant;

fn main() {
    let start = Instant::now();
    let contents: String = fs::read_to_string("../ls_input.txt")
        .expect("Should have been able to read the file");

    let split: Vec<&str> = contents.split("\n").collect();
    // println!("{:?}", split);
    let separator_0: &str = "-";
    let separator_1: &str = ",";

    let mut nr_overlap = 0;

    for row in split {
        let row_elements: Vec<&str>  = split_custom(&row, &separator_1);

        let first_range:  HashSet<i32>   = str_to_range(row_elements[0], &separator_0);
        let last_range:   HashSet<i32>   = str_to_range(row_elements[1], &separator_0);
        //println!("{:?}", row_elements);

        if first_range.intersection(&last_range).count() > 0 {
            nr_overlap += 1
        }
    }
    println!("{}", nr_overlap);

    let duration = start.elapsed();
    println!("Time elapsed is: {:?}", duration);
}

// Splits the 'string' into an array with a 'separator'
fn split_custom<'a>(string: &'a str, separator: &'a str) -> Vec<&'a str> {
    return string.split(separator).collect();
}

// Creates an array of integers between 'start' and 'end'
fn gen_range(start: &str, end: &str) -> HashSet<i32> {
    let start_int: i32 = start.parse::<i32>().unwrap();
    let end_int:   i32 =   end.parse::<i32>().unwrap();
    return HashSet::from_iter(start_int..=end_int);
}

// Creates an array of integers as dictated in the 'range_str'
// (e.g input "3-6")
// (e.g output [3,4,5,6])
fn str_to_range(range_str: &str, separator: &str) -> HashSet<i32> {
    let first_elements: Vec<&str>  = split_custom(range_str, &separator);
    return gen_range(first_elements[0], first_elements[1]);
}
