set :application, "lets_predict"

require "rvm/capistrano"
set :rvm_ruby_string, "1.9.3-p385@#{application}"
set :rvm_type, :system

require "bundler/capistrano"
set :bundle_without, [:development, :test]

ssh_options[:keys] = %w(/home/sathish/.ssh/id_rsa)
set :ssh_options, { :forward_agent => true }
default_run_options[:pty] = true
set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :repository,  "git@github.com:Imaginea/#{application}.git"
set :branch, "master"

set :user, 'root'
set :use_sudo, false
set :deploy_to, "/data/www/#{application}"
set :deploy_via, :remote_cache

role :web, "192.168.6.44"                          # Your HTTP server, Apache/etc
role :app, "192.168.6.44"                          # This may be the same as your `Web` server
role :db,  "192.168.6.44", :primary => true # This is where Rails migrations will run

before 'deploy:setup', 'rvm:create_gemset'
before 'deploy:migrate', 'deploy:setup_database_yml'
after 'bundle:install', 'deploy:migrate'
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :setup_database_yml do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end

require './config/boot'
#require 'airbrake/capistrano'
