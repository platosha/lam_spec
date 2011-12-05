@template = File.expand_path(File.join(File.dirname(__FILE__)))

inject_into_file 'config/application.rb', :after => "config.assets.version = '1.0'\n" do
  <<-RUBY

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.test_framework  :rspec, :fixture => false
      g.stylesheets     false
      g.javascripts     false
      g.controller      :test_framework => false, :helper => false, :assets => false
    end
  RUBY
end
 
gsub_file 'config/application.rb', '# config.autoload_paths += %W(#{config.root}/extras)', 'config.autoload_paths += %W(#{config.root}/lib)'
gsub_file 'config/application.rb', %|# config.time_zone = 'Central Time (US & Canada)'|, %|config.time_zone = 'Moscow'|
gsub_file 'config/application.rb', %|# config.i18n.default_locale = :de|, %|config.i18n.default_locale = :ru|

gsub_file 'config/environments/production.rb', %|config.assets.compile = false|, %|config.assets.compile = true| 
gsub_file 'config/environments/production.rb', %|# config.action_controller.asset_host = "http://assets.example.com"|, %|config.action_controller.asset_host = "http://assets0.specials.lookatme.ru/#{app_name}"| 

%w{
  Gemfile
  README
  app/assets/images/rails.png
  app/helpers/application_helper.rb
  app/views/layouts/application.html.erb
  config/database.yml
  config/locales/en.yml
  config/routes.rb
  doc
  public/index.html
  public/robots.txt
  .gitignore
}.each do |f|
  remove_file f
end

%w{
  Capfile
  Gemfile
  app/assets/images/og_logo_lookatme.png
  app/controllers/pages_controller.rb
  app/helpers/application_helper.rb
  app/views/_shared/_google_analytics.html.erb
  app/views/_shared/_meta_properties.html.erb
  app/views/_shared/_sharing_includes.html.erb
  app/views/_shared/login_required.html.erb
  app/views/layouts/admin.html.erb
  app/views/layouts/application.html.erb
  app/views/layouts/facebook_tags.html.erb
  app/views/layouts/global.html.erb
  app/views/pages/index.html.erb
  config/initializers/ids.rb
  config/initializers/locale.rb
  config/initializers/paperclip.rb
  config/initializers/permalink.rb
  config/initializers/simple_form.rb
  config/locales/activerecord.ru.yml
  config/locales/defaults.ru.yml
  config/locales/ru.rb
  config/locales/ru.yml
  config/locales/simple_form.ru.yml
  config/locales/titles.ru.yml
  lib/admin_panel.rb
  lib/default_inherited_resource.rb
  lib/image_size.rb
}.each do |f|
  copy_file File.join(@template, f), f
end

%w{
  config/routes.rb
  config/deploy.rb
  config/database.yml
  script/setup
}.each do |f|
  template File.join(@template, f), f
end

template File.join(@template, "gitignore"), ".gitignore"

inject_into_class("app/controllers/application_controller.rb", 'ApplicationController', "  include AdminPanel\n")

run 'bundle install'
rake 'db:create:all'
generate 'rspec:install'
generate 'lam_auth User'
rake 'db:migrate'

git :init
git :add => '.'