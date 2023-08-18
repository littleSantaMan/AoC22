
use std::collections::HashSet;

fn main() {
    // let mut map: HashMap<u8, u8> = HashMap::new();
    // let values = map.entry(3).or_default();
    // println!("{:?}", values);
    // println!("{:?}", map);
}

// Solve the given puzzle in place, no need to return a copy
fn sudoku(puzzle: &mut [[u8; 4]; 4]) {
    println!("---");
    let n: usize = 4;
    let s_n: usize = n/2;
    let ref_set: HashSet<u8> = [1,2,3,4].iter().cloned().collect();

    println!("{:?}", puzzle);
    let nr_of_spots: u8 = 4 * 4;
    let mut unfinished: bool = true;
    let mut count = 0u32;
    while unfinished {
        unfinished = false;
        count += 1;
        for i in 0..nr_of_spots {
            let row_nr:    usize = i as usize / 4;
            let column_nr: usize = i as usize % 4;

            if puzzle[row_nr][column_nr] > 0 { continue }

            unfinished = true;
            let row:    HashSet<u8> = puzzle[row_nr].iter().cloned().collect();
            let column: HashSet<u8> = puzzle.iter().map(|row| row[column_nr]).collect();
            let square: HashSet<u8> = (0..n).map( |k| puzzle[s_n*(row_nr/s_n) + k/s_n][s_n*(column_nr/s_n) + k%s_n]).collect(); // sudoku[3*i + k/3][3*j + k%3]


            let candidates: HashSet<_> = &(&(&ref_set - &row) - &column) - &square;

            // println!("{:?}", candidates);
            if candidates.len() == 1 { puzzle[row_nr][column_nr] = *candidates.iter().next().unwrap(); }
           //println!("{:?}", );
        }
    }

    //println!("{:?}", &ref_set2 - &ref_set);
    println!("{:?}", puzzle);
}

#[cfg(test)]
mod tests {
    use super::sudoku;

    #[test]
    fn puzzle_1() {
        let mut puzzle = [
            [3, 0,   0, 0],
            [0, 0,   2, 0],

            [0, 1,   0, 0],
            [0, 0,   0, 2],
        ];
        let solution = [
            [3, 2,   4, 1],
            [1, 4,   2, 3],

            [2, 1,   3, 4],
            [4, 3,   1, 2],
        ];

        sudoku(&mut puzzle);
        assert_eq!(puzzle, solution, "\nYour solution (left) did not match the correct solution (right)");
    }

    #[test]
    fn puzzle_2() {
        let mut puzzle = [
            [0, 0,   0, 3],
            [0, 0,   1, 2],

            [1, 2,   0, 0],
            [4, 0,   0, 0],
        ];
        let solution = [
            [2, 1,   4, 3],
            [3, 4,   1, 2],

            [1, 2,   3, 4],
            [4, 3,   2, 1],
        ];

        sudoku(&mut puzzle);
        assert_eq!(puzzle, solution, "\nYour solution (left) did not match the correct solution (right)");
    }
}
