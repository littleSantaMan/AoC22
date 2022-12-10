# frozen_string_literal: true

CYCLE_COST = {
  'addx' => 2,
  'noop' => 1
}.freeze

input = File.read('./input.txt')

instructions = input.split("\n").map do |row|
  command, value = row.split(' ')
  [command, value.to_i]
end

cycles = []
current_x = 1

instructions.each do |command, value|
  CYCLE_COST[command].times.each { cycles << current_x }
  current_x += value
end
cycles << current_x

target_cycles = (1..6).map { |i| 40 * i - 20 }
sig_strengths = target_cycles.map do |cycle|
  cycle * cycles[cycle - 1]
end

# PART 1
puts sig_strengths.sum

# --------------------------------------

PIXELS = {
  true => '#',
  false => '.'
}.freeze

pixels = []
screen_size = 40

pixel_row = []
cycles.each_with_index do |cycle, x|
  x = x % screen_size
  if x.zero?
    pixels << pixel_row
    pixel_row = []
  end
  sprite = (cycle - 1..cycle + 1)
  pixel_row << PIXELS[sprite.include?(x)]
end

# PART 2
pixels[1..].each do |row|
  print "#{row.join('')}\n"
end

####...##..##..####.###...##..#....#..#.
#.......#.#..#.#....#..#.#..#.#....#..#.
###.....#.#....###..#..#.#....#....####.
#.......#.#....#....###..#.##.#....#..#.
#....#..#.#..#.#....#....#..#.#....#..#.
####..##...##..#....#.....###.####.#..#.
