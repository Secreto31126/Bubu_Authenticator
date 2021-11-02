# frozen_string_literal: true

puts "Bubu Authenticator (2021) - MIT LICENSE"
puts "Run #{$PROGRAM_NAME} -h to read the help guide"
puts

require "rubygems"
require "json"
require_relative "./Bubu_Authenticator/auth"
require_relative "./Bubu_Authenticator/input"
require_relative "./Bubu_Authenticator/version"

# Update json file
def save_to_json!(json)
  File.write("#{File.dirname(__FILE__)}/Data/data.json", JSON.pretty_generate(json))
end

# Prints all the posible user inputs with the name
def print_options(keys)
  keys.each_with_index do |object, index|
    puts "#{index + 1}: #{object["name"]}"
  end
end

def print_help
  puts "Usage: #{$PROGRAM_NAME} [command]"
  puts
  puts "-n (name) (code): Adds a new 2FA code to the list"
  puts "-r: Removes a 2FA from the list"
  puts "-h: This help guide"
  puts "-v: The app version"
end

if File.exist?("#{File.dirname(__FILE__)}/Data/data.json")
  # Reads the json file
  json = JSON.parse(File.read("#{File.dirname(__FILE__)}/Data/data.json"))
else
  # If data.json is not present, creates a new one
  File.open("#{File.dirname(__FILE__)}/Data/data.json", "w") do |file|
    file.puts JSON.pretty_generate({ "saved_keys": [] })
  end
  puts '.\\Data\\data.json created, backup this file to save your 2FA passwords'
  exit
end

# Main execution
Input.args.each_with_index do |argument, i|
  case argument
  when "-n"
    if ARGV.length > i + 2
      # Gets everything between the first and the last argument (excluded)
      name = (ARGV[(i + 1)..(ARGV.length - 2)]).join " "
      code = ARGV.last

      json["saved_keys"].push({ name: name, code: code })
      save_to_json! json
      puts "Added #{name} to the list"

      Auth.get_2fa(name, code)
    else
      puts "You need to specify a name and a code"
    end
    exit
  when "-r"
    if json.empty?
      puts "There's no data to delete"
    else
      puts "Which 2FA do you want to delete?"
      print_options(json["saved_keys"])

      input = Input.get_user_input(json["saved_keys"].length)
      name = json["saved_keys"][input]["name"]

      json["saved_keys"].delete_at(input)
      save_to_json! json

      # Display success message
      puts "Successfully deleted #{name} from the list"
    end
    exit
  when "-h"
    print_help
    exit
  when "-v"
    puts BubuAuthenticator::VERSION
    exit
  end
end

# If json is empty, exit
if json["saved_keys"].empty?
  puts "No codes found!"
  puts 'To add a new code, start the program with "-n [name] [code]" or manually add them to the data.json file'
  exit
end

puts "Which 2FA do you need?"
print_options(json["saved_keys"])

input = Input.get_user_input(json["saved_keys"].length)
choice = json["saved_keys"][input]

Auth.get_2fa(choice["name"], choice["code"])
puts "See you later 👋"
