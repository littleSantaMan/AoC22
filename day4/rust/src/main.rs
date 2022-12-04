use std::fs;
use array_tool::vec::Intersect;

fn main() {
    let contents: String = fs::read_to_string("../input.txt")
        .expect("Should have been able to read the file");

    let split: Vec<&str> = contents.split("\n").collect();
    
    let mut nr_overlap = 0;

    for row in split {
        // println!("{}", row);
        let row_elements: Vec<&str> = row.split(",").collect();
        let first: &str = row_elements[0];
        let last:  &str = row_elements[1];

        let first_elements: Vec<&str> = first.split("-").collect();
        let first_start: &str = first_elements[0];
        let first_end:   &str = first_elements[1];
        let first_start_int: i32 = first_start.parse::<i32>().unwrap();
        let first_end_int:   i32 =   first_end.parse::<i32>().unwrap();

        let first_range: Vec<i32> = (first_start_int..=first_end_int).collect();

        let last_elements: Vec<&str> = last.split("-").collect();
        let last_start: &str = last_elements[0];
        let last_end:   &str = last_elements[1];
        let last_start_int: i32 = last_start.parse::<i32>().unwrap();
        let last_end_int:   i32 =   last_end.parse::<i32>().unwrap();

        let last_range: Vec<i32> = (last_start_int..=last_end_int).collect();

        //  println!("{:?}", first_range);
        //  println!("{:?}", last_range);
        // println!("{}", vec![1,2,3].intersect(vec![3,4,5]).len());
        // println!("{}", first_range.intersect(last_range).len());

        if first_range.intersect(last_range).len() > 0 {
            nr_overlap += 1
        }

    }

    println!("{}", nr_overlap)
}

// fn split_by(string: &String, by: &str) -> Vec<&str> {
//     return string.split(by).collect();
// }

// fn get_range(start: &str, end: &str) -> String {
//    return String::from("hello");
// }
