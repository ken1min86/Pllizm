# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create seeds of icons
ActiveRecord::Base.connection.execute('TRUNCATE TABLE `icons`')

icons = ['Account-icon1.png', 'Account-icon2.png', 'Account-icon3.png', 'Account-icon4.png', 'Account-icon5.png', 'Account-icon6.png', 'Account-icon7.png', 'Account-icon8.png', 'Account-icon9.png', 'Account-icon10.png']
icons.each do |icon|
  Icon.create!(image: open("#{Rails.root}/db/icons/#{icon}"))
end
