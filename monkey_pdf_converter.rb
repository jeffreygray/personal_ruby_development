#!/usr/bin/env ruby

require 'pdf-reader'

def remove_hyperlinks(file_path)
  # Check if the file is a .txt file
  if file_path.end_with?(".txt")
    # Read the content of the .txt file
    text = File.read(file_path)
    # Use a regular expression to remove hyperlinks
    text_without_hyperlinks = text.gsub(/https?:\/\/\S+/, '')
    # Write the result to a .txt file
    output_file = File.new("output.txt", "w")
    output_file.puts(text_without_hyperlinks)
    output_file.close
    return text.scan(/https?:\/\/\S+/).count
  # Check if the file is a .pdf file
  elsif file_path.end_with?(".pdf")
    # Read the content of the .pdf file
    reader = PDF::Reader.new(file_path)
    text = ""
    reader.pages.each do |page|
      text << page.text
    end
    # Use a regular expression to remove hyperlinks
    text_without_hyperlinks = text.gsub(/https?:\/\/\S+/, '')
    # Write the result to a .txt file
    output_file = File.new("output.txt", "w")
    output_file.puts(text_without_hyperlinks)
    output_file.close
    return text.scan(/https?:\/\/\S+/).count
  else
    puts "Invalid file format. Only .txt and .pdf files are supported."
  end
end

# Get the file path from the command line argument
file_path = ARGV[0]

if ARGV.length != 1
  puts "Please supply exactly 1 argument, the path to a .txt or .pdf file."
  return
elsif file_path.nil?
  puts "Please specify the file path."
  return
else
  # Call the remove_hyperlinks function and pass the file path as an argument
  count = remove_hyperlinks(file_path)
  link_txt = count == 1 ? 'link' : 'links'
  out = "Monkey PDF converter successfully removed #{count} #{link_txt} from #{file_path}! Eeee!"
  out << "\n\tcheck output.txt"
  puts(out)
end
