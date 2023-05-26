use std::fs;
use std::str::FromStr;

#[derive(Clone)]
struct Monkey<'a> {
    items:           Vec<i32>,
    operation:       &'a str, // * or +
    operand:         &'a str, // the other number or 'old'
    decision_number: i32,
    when_true:       usize, //i32,
    when_false:      usize // i32
}

fn main() {
    let contents: String = fs::read_to_string("../test_input.txt")
        .expect("Should have been able to read the file");

    let monkey_strings:    Vec<&str>     = contents.split("\n\n").collect();
    let mut monkeys:       Vec<Monkey>   = monkey_strings.iter().map( |&monkey_string| { extract_monkey(monkey_string) } ).collect();
    let mut monkeys_items: Vec<Vec<i32>> = monkeys.iter().map( |monkey|  { monkey.items.clone() } ).collect();
    let mut new_monkeys:   Vec<Monkey>   = monkeys.clone();

    for n in 0..20 {
        for (i, monkey) in monkeys.iter().enumerate() {
            let items: Vec<i32> = monkeys_items[i].clone();
            monkeys_items[i] = vec![];
            for item in items {
                let operand: i32;
                if monkey.operand == "old" {
                    operand = item;
                } else {
                    operand = FromStr::from_str(monkey.operand).unwrap();
                }

                let new_item: i32;
                if monkey.operation == "*" {
                    new_item = item * operand
                } else {
                    new_item = item + operand
                }

                let final_item: i32 = new_item / 3;
                if final_item % monkey.decision_number == 0 {
                    monkeys_items[monkey.when_true].push(final_item)
                } else {
                    monkeys_items[monkey.when_false].push(final_item)
                }
            }
        }
    }

    println!("{:?}", monkeys_items[0]);
    println!("{:?}", monkeys_items[1]);
    println!("{:?}", monkeys_items[2]);
    println!("{:?}", monkeys_items[3]);
}


// ...
fn get_monkey_string_lines(monkey_string: &str) -> Vec<&str> {
    return monkey_string.split("\n").collect();
}

// ...
fn get_item_list(items_line: &str) -> Vec<i32> {
    let items_string:   &str      = items_line.split(":").collect::<Vec<&str>>()[1];
    let items_list:     Vec<&str> = items_string.split(",").collect();
    return items_list.iter().map( |nr| { FromStr::from_str(nr.trim()).unwrap() } ).collect();
}

fn get_oper(operation_line: &str) -> (&str,  &str) {
    let operation:            &str = operation_line.split("Operation: new = old ").collect::<Vec<&str>>()[1];
    let operation_parts: Vec<&str> = operation.split(" ").collect::<Vec<&str>>();
    let operation_type: &str = operation_parts[0];
    let operand:        &str = operation_parts[1];
    return (operation_type, operand);
}

fn get_decision(decision_line: &str) -> i32 {
    let divident:   &str = decision_line.split("Test: divisible by ").collect::<Vec<&str>>()[1];
    return divident.parse::<i32>().unwrap();
}

fn get_next_monkey(condition_line: &str, boolean: &str) -> usize {
    let separator = format!("    If {}: throw to monkey ", boolean);
    let number = condition_line.split(&separator).collect::<Vec<&str>>()[1];
    return number.parse::<usize>().unwrap();
}

// ...
fn extract_monkey(monkey_string: &str) -> Monkey {
    let lines: Vec<&str> = get_monkey_string_lines(monkey_string);

    let items_int_list: Vec<i32>  = get_item_list(lines[1]);

    let (operation_type, operand) = get_oper(lines[2]);
    let decision_number           = get_decision(lines[3]);
    let next_true_monkey          = get_next_monkey(lines[4], "true");
    let next_false_monkey         = get_next_monkey(lines[5], "false");

    return Monkey {
        items: items_int_list,
        operation: operation_type,
        operand: operand,
        decision_number: decision_number,
        when_true: next_true_monkey,
        when_false: next_false_monkey
    };
}
