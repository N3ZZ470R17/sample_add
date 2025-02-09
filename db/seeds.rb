# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!(name: "Example User", email: "example@localhost.net", password: "foobar", password_confirmation: "foobar", admin: true, activated: true, activated_at: Time.zone.now)

99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@localhost.net"
    password = "password"
    User.create!(name: name, email: email, password: password, password_confirmation: password, activated: true, activated_at: Time.zone.now)
end

# Area de micropublicaciones
#   Genera microposts para una cierta cantidad de usuarios
users = User.order(:created_at).take(6)
50.times do
    content = Faker::Lorem.sentence(word_count: 5)
    users.each { |user| user.microposts.create!(content: content) }
end
