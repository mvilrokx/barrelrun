# set :user, 'git'
set :user, 'mark'
set :domain, 'mark-server'
set :application, 'barrelrun'
set :rake, '/var/lib/gems/1.8/bin/rake'

# file paths

# I think it should be this
# set :repository, "#{user}@#{domain}:#{application}
set :repository, "git@#{domain}:#{application}.git"
# but this is what is in the book, just pick the one that works ...
#set :repository, "#{user}@#{domain}:git/#{application}.git"
# set :deploy_to, "/home/#{user}/#{domain}"
set :deploy_to, "/home/#{user}/#{domain}_production"

# distribute your applications across servers (the instructions below put them
# all on the same server, defined above as 'domain', adjust as necessary)
role :app, domain
role :web, domain
role :db, domain, :primary => true

# you might need to set this if you aren't seeing password prompts
# default_run_options[:pty] = true
# As Capistrano executes in a non-interactive mode and therefore doesn't cause
# any of your shell profile scripts to be run, the following might be needed
# if (for example) you have locally installed gems or applications. Note:
# this needs to contain the full values for the variables set, not simply
# the deltas.
# default_environment['PATH']='<your paths>:/usr/local/bin:/usr/bin:/bin'
# default_environment['GEM_PATH']='<your paths>:/usr/lib/ruby/gems/1.8'

# miscellaneous options
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false

# task which causes Passenger to initiate a restart
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# optional task to reconfigure databases
after "deploy:update_code", :configure_database

desc "copy database.yml into the current release path"
task :configure_database, :roles => :app do
#     db_config = "#{deploy_to}/config/database.yml"
#     run "cp #{db_config} #{release_path}/config/database.yml"
     run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
end

task :before_update_code, :roles => [:app] do
  thinking_sphinx.stop
end

task :after_update_code, :roles => [:app] do
  symlink_sphinx_indexes
  thinking_sphinx.configure
  thinking_sphinx.start
end

task :symlink_sphinx_indexes, :roles => [:app] do
  run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
end
