# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

user_one = User.create(name: "Austin", email: "austin@hackathon.com", password: "tandahackathon2026")

puts "Successfully seeded the database"