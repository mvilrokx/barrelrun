require 'find'
require 'fileutils'

run "ln -nfs #{shared_path}/config/sphinx #{release_path}/config/sphinx"
run "ln -nfs #{shared_path}/config/sphinx.yml #{release_path}/config/sphinx.yml"

puts "replace action_mailer host on development environment"
host = nil
puts node[:environment][:framework_env]
if node[:environment][:framework_env]=="development"
  node[:engineyard][:environment][:instances].each do |instance|
    puts "========================="
    puts instance
    puts "========================="
    puts instance[:public_hostname]
    puts "========================="
    host = instance[:public_hostname]
  end
end

filepath = "#{release_path}/config/environments/development.rb"
text = File.read(filepath)
replace = text.gsub(/mark-server.dlinkddns.com:3000/, host)
File.open(filepath, "w") {|file| file.puts replace}
