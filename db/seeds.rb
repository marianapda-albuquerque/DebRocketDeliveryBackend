# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# We create a user to be able to login into our back office and test it
erica = User.create!(email: "erica.ger@gmail.com", name: "Erica Ger", password: "password")
erica_address = Address.create!(street_address: "123 CodeBoxx Boulevard", city: "Montreal", postal_code: "H4G52Z")

# Erica is an employee!
Employee.create!(user_id: erica.id, address_id: erica_address.id, phone: "5141231234", email: "erica.ger@codeboxxacademy.com")

# We create another user who's not an employee to be able to test the Back Office access
john = User.create!(email: "john@doe.com", name: "John Doe", password: "password")

# John has a restaurant!
john_restaurant_address = Address.create!(street_address: "6312 Learning Street", city: "New York", postal_code: "10008")
Restaurant.create!(user_id: john.id, address_id: john_restaurant_address.id, phone: "2124328554", email: "info@kingdomburg.com", name: "Kingdom Burg", price_range: 1, active: true)