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
  (4..6).to_a.sample.times do 
    friend = users.reject { |u| u == user }.sample 
    next if user.friend?(friend)
    user.friends << friend
  end 
end 

user_ids = users.ids

users.each do |user|
  sender_id = user.id
  receiver_id = user_ids.reject { |e| e == sender_id }.sample 
  [3, 5].sample.times do 
    content = Faker::Lorem.sentence
    message = UserMessage.new(sender_id: sender_id, receiver_id: receiver_id, content: content)
    message.save
  end
  
  [3, 5].sample.times do 
    content = Faker::Lorem.sentence
    message = UserMessage.new(sender_id: receiver_id, receiver_id: sender_id, content: content)
    message.save
  end
end 
