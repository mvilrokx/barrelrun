require 'find'
require 'fileutils'

run "ln -nfs #{shared_path}/config/sphinx #{release_path}/config/sphinx"
run "ln -nfs #{shared_path}/config/sphinx.yml #{release_path}/config/sphinx.yml"

# replace action_mailer host
filepath = "#{release_path}/config/environments/development.rb"
text = File.read(filepath)
replace = text.gsub(/mark-server.dlinkddns.com:3000/, "#{node[:engineyard][:environemnts][:instances[0][:public_hostname]")
File.open(filepath, "w") {|file| file.puts replace}
