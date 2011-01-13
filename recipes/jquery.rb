gem 'jquery-rails'

gsub_file 'config/application.rb', /(config.action_view.javascript_expansions\[:defaults\] = %w\(\))/, '# \1'

strategies << lambda do
  remove_file "public/javascripts/rails.js"
  generate 'jquery:install'
end