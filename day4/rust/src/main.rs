use std::fs;
use array_tool::vec::Intersect;

fn main() {
    let contents: String = fs::read_to_string("../ls_input.txt")
        .expect("Should have been able to read the file");

    let split: Vec<&str> = contents.split("\n").collect();
    
    let separator_0: &str = "-";
    let separator_1: &str = ",";

    let mut nr_overlap = 0;

    for row in split {
        let row_elements: Vec<&str>  = split_custom(&row, &separator_1);

        let first_range:  Vec<i32>   = str_to_range(row_elements[0], &separator_0);
        let last_range:   Vec<i32>   = str_to_range(row_elements[1], &separator_0);
        // println!("{:?}", first_range);

        if first_range.intersect(last_range).len() > 0 {
            nr_overlap += 1
        }
    }
    println!("{}", nr_overlap)
}

// Splits the 'string' into an array with a 'separator'
fn split_custom<'a>(string: &'a str, separator: &'a str) -> Vec<&'a str> {
    return string.split(separator).collect();
}

// Creates an array of integers between 'start' and 'end'
fn gen_range(start: &str, end: &str) -> Vec<i32> {
    let start_int: i32 = start.parse::<i32>().unwrap();
    let end_int:   i32 =   end.parse::<i32>().unwrap();
    return (start_int..=end_int).collect();
}

// Creates an array of integers as dictated in the 'range_str'
// (e.g input "3-6")
// (e.g output [3,4,5,6])
fn str_to_range(range_str: &str, separator: &str) -> Vec<i32> {
    let first_elements: Vec<&str>  = split_custom(range_str, &separator);
    return gen_range(first_elements[0], first_elements[1]);
}
