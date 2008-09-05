default_run_options[:pty] = true
set :application, "vurl"
set :repository,  "git@github.com:veez/vurl.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "~/vurl"
set :deploy_via, :remote_cache

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, :git
set :branch, 'production'

role :app, "mattremsik.com"
role :web, "mattremsik.com"
role :db,  "mattremsik.com", :primary => true

set :user, "craftst"
set :scm_username, "veez"
set :use_sudo, false

after "deploy:update_code", "vurl_custom"
task :vurl_custom, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
