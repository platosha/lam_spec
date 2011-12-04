default_environment['PATH'] = "/opt/ruby/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin"

set :user,                '<%= app_name %>'
set :application,         '<%= app_name %>'
set :deploy_to,           "/apps/#{user}/#{application}-git"

ssh_options[:paranoid] =  false
ssh_options[:port]     =  58022

role :app0, "188.127.242.241", :primary => true
role :app1, "188.127.242.242"

namespace :deploy do  
  task :default do
    update
    precompile_assets
    restart
  end
  
  task :light do
    update
    restart
  end

  task :update, :roles => [:app0, :app1] do
    run "cd #{deploy_to}; git checkout db/schema.rb; git pull; bundle install --deployment"
  end
  
  task :migrate do
    update
    run "cd #{deploy_to} && RAILS_ENV=production bundle exec rake db:migrate"
    precompile_assets
    restart
  end
  
  task :precompile_assets, :roles => [:app0, :app1] do
    run "cd #{deploy_to}; bundle exec rake assets:precompile"
  end
  
  task :restart, :roles => [:app0, :app1] do
    run "cd #{deploy_to}; mkdir -p tmp && touch tmp/restart.txt;"
  end
end