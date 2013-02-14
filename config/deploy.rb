set :stages, %w(production)
set :default_stage, "production"
require 'capistrano/ext/multistage'

task :pwd do
  run "pwd"
end
