set :application, "wcradio"
set :repository,  "svn://tastytoasted.com/"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

set :stages, %w(staging production)
set :default_stage, "production"
require 'capistrano/ext/multistage'



default_run_options[:pty] = true

set :user, "wcradio-build"

set :scm_username, "cadwallion"
set :scm_password, "d9p4XYf32"

role :app, "wcradio.com"
role :web, "wcradio.com"
role :db,  "wcradio.com", :primary => true

after "deploy:update", "newrelic:notice_deployment"


namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

