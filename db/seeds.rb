# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'SETTING UP ROLES'
adminRole = Role.create! :name => 'Admin'
managerRole = Role.create! :name => 'Manager'
employeeRole = Role.create! :name => 'Employee'
developerRole = Role.create! :name => 'Developer'

puts 'SETTING UP ADMIN USER'
admin = User.create! :username => 'Admin', :email => 'admin@localhost.com', :password => 'admin123', :password_confirmation => 'admin123', :working_hours => 40
admin.roles.push adminRole
puts 'New user created: ' << admin.username