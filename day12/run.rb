# frozen_string_literal: true

require 'yaml'
require 'pry'

input = File.read('./test_input.txt')

alt_map = input.split("\n").map do |row|
  row.scan(/./).map(&:ord)
end
SIZE_H = alt_map.first.size
SIZE_V = alt_map.size

# S = 83
# E = 69
# a - z : 97 - 122

start_pos = nil
end_pos   = nil

alt_map.each_with_index do |row, i|
  row.each_with_index do |el, j|
    if el == 83
      start_pos = [i, j]
      alt_map[i][j] = 96
    end
    if el == 69
      end_pos = [i, j]
      alt_map[i][j] = 123
    end
  end
end

DIR_W = [0,1]
DIR_N = [-1,0]
DIR_E = [0,-1]
DIR_S = [1,0]

DIRS = [DIR_W, DIR_N, DIR_E, DIR_S]

def validate_pos(new_v, new_h)
  return false unless ((new_h >= 0) && (new_h < SIZE_H))
  return false unless ((new_v >= 0) && (new_v < SIZE_V))

  true
end

def validate_val(new_val, old_val)
  return true if new_val - old_val <= 1

  false
end

all_paths = []
#visited = []

def step(path, alt_map, all_paths)
  current_pos = path.last
  current_val = alt_map[current_pos.first][current_pos.last]
  #visited << [current_pos]

  DIRS.each do |diff_v, diff_h|
    new_v = current_pos.first + diff_v
    new_h = current_pos.last  + diff_h

    new_pos = [new_v, new_h]
    next if path.include?(new_pos) # || all_paths.any? { |path_| path_.include? new_pos }
    next unless validate_pos(*new_pos)

    new_val = alt_map[new_v][new_h]
    next unless validate_val(new_val, current_val)

    new_path = (path.dup << new_pos)

    if new_val == 123
      all_paths << new_path
      return
    end

    step(new_path, alt_map, all_paths)
  end
end


step([start_pos], alt_map, all_paths)

# screen = alt_map.map do |row|
#   Array.new(row.size, '|..|')
# end
sizes = all_paths.map {|x| x.size}
smallest_size = sizes.min
# smallest_path = all_paths.find {|x| x.size == smallest_size}

# smallest_path.each_with_index do |step, i|
#   screen[step.first][step.last] = "|#{i.to_s.ljust(2,'..')}|"
# end

# screen.each do |row|
#   puts row.join('')
# end
puts smallest_size -1
binding.pry
