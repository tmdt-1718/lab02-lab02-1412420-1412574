# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Message.delete_all


user = User.new
user.email = 'phanphuocdt@gmail.com'
user.name = 'Austin'
user.password = 'password'
user.save

10.times do |n| 
  user = User.new
  user.email = Faker::Internet.email
  user.name = Faker::Name.name 
  user.password = 'password'
  user.save
end 

users = User.all
users.each do |user|
  (1..5).to_a.sample.times do 
    friend = users.sample
    next if user.friend?(friend)
    user.friends << friend
  end 
end 

10.times do 
  messages = {items: {qty: Faker::Number.number(2), product: Faker::Coffee.blend_name}, 
              customer: Faker::Name.name}

  Message.create(messages: messages)
end 