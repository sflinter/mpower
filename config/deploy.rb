set :repo_user, "sflinter"
set :user, 'flintero'
set :domain, 'mpower.flinter.org'
set :host, "aether.site5.com"
set :application, "mpower"
set :repository,  "git://github.com/#{repo_user}/#{application}.git"
set :deploy_to, "/home/#{user}/#{application}"
#default_run_options[:pty] = true

# misc options
set :scm, 'git'
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :group_writable, false

set :keep_releases, 10

role :app, host
role :web, host
role :db,  host, :primary => true

namespace :deploy do
  desc "Restart the web server"
  task :restart, :roles => :app do
    run "cd /home/#{user}/public_html ; rm #{domain} ; ln -s #{current_path}/public ./#{domain}"
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nsf #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'
