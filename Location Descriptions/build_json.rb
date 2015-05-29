# Sorry, this isn't very readable

locations = File.open("locations.txt")
final = File.open("final.json", "w")

loc_objects = locations.readlines.map { |line|
  location = line.strip
  sections = File.open("locations/" + location + ".txt").read.split("\n\n\n")
  if sections.length != 3 then
    puts "Warning: Skipping " + location + " due to incorrect format."
    next nil
  end

  # The location id, mapped to a dictionary of 'what', 'description', and 'menu'
  "\"" + location + "\": " + "{\n" + (0..2).map { |i|
    title = "\"" + ["what", "description", "menu"][i] + "\":\n"
    content = "\"" + sections[i].strip + "\""
    title + content
  }.join(",\n\n") + "\n}"
}.compact.join(",\n\n\n")

final.write("{\n\n\n" + loc_objects + "\n\n\n}")

locations.close
final.close