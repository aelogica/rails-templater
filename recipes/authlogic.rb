gem 'authlogic'
gem 'rails3-generators'

strategies << lambda do
  puts "Generating authlogic session"
  generate 'authlogic:session UserSession'
  
  puts "generating user model"
  generate 'model User login:string email:string crypted_password:string password_salt:string persistence_token:string'
  
  puts "editing user model"
  inject_into_file "app/models/user.rb",
    "\nacts_as_authentic",
    :after => 'class User < ActiveRecord::Base'
    
  puts "generating application controller"
  inject_into_file "app/controllers/application_controller.rb",
    load_template("app/controllers/application_controller.rb", 'authlogic'),
    :after => "protect_from_forgery"
    
  puts "generating user sessions controller"
  generate "controller UserSessions"
  
  inject_into_file "app/controllers/user_sessions_controller.rb",
    load_template("app/controllers/user_sessions_controller.rb", 'authlogic'),
    :after => "class UserSessionsController < ApplicationController"
  
  puts "replacing user sessions new.haml"  
  remove_file 'app/views/user_sessions/new.html.haml'
  create_file 'app/views/user_sessions/new.html.haml', load_template('app/views/user_sessions/new.html.haml', 'authlogic')
  
  puts "adding routes"
  route("resources :user_sessions")
  route("match 'login' => 'user_sessions#new', :as => :login")
  route("match 'logout' => 'user_sessions#destroy', :as => :logout")
  
  puts "generating seeds: user login: admin with password admin"
  append_file 'db/seeds.rb',
    "User.create(:login => 'admin', :email => 'test@tester.com', :password => 'admin', :password_confirmation => 'admin')"
    
  puts "migrating the databases"
  rake "db:migrate"
  puts "migrating for rails env test"
  rake "db:migrate RAILS_ENV=test"
  puts "seeding the database"
  rake "db:seed"
  puts "seeding test database"
  rake "db:seed RAILS_ENV=test"
end


