# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'guclink_auth_www'
set :repo_url, 'git@github.com:ah450/guclink-auth-www.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'
set :deploy_to, '/root/guclink_auth_www'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 1

namespace :deploy do

  desc 'Install node modules'
  task :install_node_modules do
    on roles(:web) do
      within release_path do
        execute :npm, 'install'
      end
    end
  end

  desc 'Deploy application'
  task :deploy_npm do
    on roles(:web) do
      within release_path do
        execute :npm, 'run', 'deploy'
      end
    end
  end

  desc 'Chown srv to nginx'
  task :set_nginx_permissions do
    on roles(:web) do
      execute :chown, '-R', 'nginx:nginx', '/srv/www'
      execute :restorecon, '-R', '-v', '/srv/www'
    end
  end

  after :updated, :install_node_modules
  after :updated, :deploy_npm
  after :publishing, :set_nginx_permissions
end
