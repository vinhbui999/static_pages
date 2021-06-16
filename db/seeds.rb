# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#Create a main sample users
# User.create!(name: "Example User",
#     email: "example@railstutorial.org",
#     password: "foobar",
#     password_confirmation: "foobar",
#     admin: true,
#     activated: true,
#     activated_at: Time.zone.now)


#create a bunch of additional users
# 99.times do |i|
#     name = "Faker::Name.name"
#     email = "example-#{i+1}@railstutorial.org"
#     password = "password"
#     User.create!(name: name,
#                 email: email,
#                 password: password,
#                 password_confirmation: password,
#                 admin: false,
#                 activated: true,
#                 activated_at: Time.zone.now)
# end

#create microposts for 6 first users
users = User.order(:create_at).take(6)
50.times do 
    content = "Random contents Bla..bla..bla"
    users.each {|user| user.microposts.create!(content: content)}
end
