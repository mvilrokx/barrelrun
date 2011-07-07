require 'find'
require 'fileutils'

# replace action_mailer host
filepath = "config/environments/development.rb"
text = File.read(filepath)
replace = text.gsub(/replaced!/, "mark-server.dlinkddns.com:3000")
File.open(filepath, "w") {|file| file.puts replace}
