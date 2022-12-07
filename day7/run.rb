# frozen_string_literal: true

input = File.read('./input.txt')

commands = input.split("\n")[1..]

current_folder = ['/']

files = {}

commands.each do |command|
  case
  when match = command.match(/\$ cd (?<folder>.*)/)
    if match[:folder] == '..'
      current_folder.pop
    else
      current_folder << match[:folder] + '/'
    end
  when match = command.match(/(?<size>\d.*) (?<file>.*)/)
    files[current_folder.dup << match[:file]] = match[:size]
  end
end

dirs = {}
files.each do |file, size|
  file = file.dup
  while file.size > 1
    file.pop
    dirs[file.dup] ||= 0
    dirs[file.dup] += size.to_i
  end
end

# PART 1
result_dirs = dirs.select do |_dir, size|
  size <= 100_000
end

puts result_dirs.values.sum

# PART 2

to_free_up = 30000000 - (70000000 - dirs[['/']])
candidates = dirs.values
candidates = candidates.select do |size|
  size >= to_free_up
end
puts candidates.min