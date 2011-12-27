default_environment['PATH'] = "/opt/ruby/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin"

set :user,                "<%= app_name %>"
set :application,         "<%= app_name %>"
set :deploy_to,           "/apps/#{user}/#{application}-git"
set :repository,          "ssh://git@git.lookatme.ru:58022/<%= app_name %>.git"

ssh_options[:paranoid] =  false
ssh_options[:port]     =  58022

role :app0, "188.127.242.241", :primary => true
role :app1, "188.127.242.242"
roles_options = {:roles => [:app0, :app1]}

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
  
  task :setup, roles_options do
    run "git clone #{repository} #{deploy_to}"
    run "cd #{deploy_to}; mkdir -p log tmp; cp config/database.yml.production config/database.yml; cp config/lam_auth.yml.production config/lam_auth.yml"
    run "cd #{deploy_to}/public; ln -s . #{application}"
  end

  task :update, roles_options do
    run "cd #{deploy_to}; git checkout db/schema.rb; git pull; bundle install --deployment --without development test"
  end
  
  task :migrate, roles_options do
    update
    run "cd #{deploy_to} && RAILS_ENV=production bundle exec rake db:migrate"
    precompile_assets
    restart
  end
  
  task :precompile_assets, roles_options do
    run "cd #{deploy_to}; bundle exec rake assets:precompile"
  end
  
  task :restart, roles_options do
    run "cd #{deploy_to}; touch tmp/restart.txt;"
  end
end