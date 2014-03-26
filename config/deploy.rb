#set :application, 'my_app_name'
#set :repo_url, 'git@example.com:me/my_repo.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
# set :scm, :git

# set :format, :pretty
set :log_level, :debug

set :pty, true
set :application, 'olj'
set :user, '~~~REMOVED~~~'
set :password, '~~~REMOVED~~~'
set :use_sudo, true

# setup repo details
set :scm, :git
set :repo_url, '~~~REMOVED~~~'
set :scm_user, '~~~REMOVED~~~'
set :scm_password, '~~~REMOVED~~~'

set :deploy_to, '/webapps/onelinejournal'

# setup rvm.
#set :rbenv_type, :system
#set :rbenv_ruby, '2.0.0p247'
#set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
#set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# how many old releases do we want to keep
set :keep_releases, 5
set :ssh_options, {
    #verbose: :debug,
    user: fetch(:user),
    auth_methods: %w(password),
    password: '~~~REMOVED~~~'
}
#default_run_options[:pty] = true

# files we want symlinking to specific entries in shared.
#set :linked_files, %w{config/database.yml config/application.yml}

# dirs we want symlinking to shared
#set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  local_env.yml
  database.yml
))

# which config files should be made executable after copying
# by deploy:setup_config
=begin
set(:executable_config_files, %w(
  unicorn_init.sh
))
=end

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
=begin
# init scripts etc.
set(:symlinks, [
    {
        source: "nginx.conf",
        link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
    },
    {
        source: "unicorn_init.sh",
        link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
    },
    {
        source: "log_rotation",
        link: "/etc/logrotate.d/#{fetch(:full_app_name)}"
    },
    {
        source: "monit",
        link: "/etc/monit/conf.d/#{fetch(:full_app_name)}.conf"
    }
])
=end


# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for `cap stage deploy`
desc 'Restart Passenger app'
task :restart do
  run "#{ try_sudo } touch #{ File.join(current_path, 'tmp', 'restart.txt') }"
end
namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # make sure we're deploying what we think we're deploying
  #before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  # before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  #after 'deploy', 'deploy:symlink:shared'
  after 'deploy', 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

=begin
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
=end