puts "# This assumes that you have installed these gems:"
puts "# gem install bundler"
puts "# gem install rails"
puts "# "
puts "# ---------- IMPORTANT! ------------ "
puts "# This also assumes that you are using a gemset with the same name as your app"
puts "# Please ensure that you already have an rvm gemset in use otherwise this will all install in your currrent gem environment"
puts "# rails new my_new_app -m aelogica.rb"
puts "# will generate an rvmrc file like this:"
puts "# rvm use 1.9.2-head@my_new_app"

require File.join(File.dirname(__FILE__), 'core_extensions.rb')

initialize_templater

check_rvmrc

required_recipes = %w(default jquery haml rspec factory_girl)
required_recipes.each {|required_recipe| apply recipe(required_recipe)}

load_options
apply(recipe('cucumber')) if yes?("Would you like to add integration testing with Cucumber? [y|n]: ", Thor::Shell::Color::GREEN)  
apply recipe('design')
apply(recipe('authlogic')) if yes?("Would you like to add authlogic? [y|n]: ", Thor::Shell::Color::GREEN)

run 'bundle install'

execute_strategies

environment load_snippet('generators', 'rails')

git :add => "."
git :commit => "-m 'Initial commit'"  

puts "---------- Congratulations! Your app was successfully generated! ---------------"
puts "# if you have included authlogic, you will now have a user in the database named 'admin' with the password 'admin'. Enjoy!"
puts "--------------------------------------------------------------------------------"