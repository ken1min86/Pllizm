# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create seeds of icons
ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS=0;")
ActiveRecord::Base.connection.execute('TRUNCATE TABLE `icons`')
ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS=1;")

icons = ['Account-icon1.png', 'Account-icon2.png', 'Account-icon3.png', 'Account-icon4.png', 'Account-icon5.png', 'Account-icon6.png', 'Account-icon7.png', 'Account-icon8.png', 'Account-icon9.png', 'Account-icon10.png']
icons.each do |icon|
  Icon.create!(image: open("#{Rails.root}/db/icons/#{icon}"))
end

# Create seeds of users to followe immediately
users = [
  {
    userid: Settings.users_to_follow_immediately[0],
    username: '中村謙一',
    email: 'ken1dk1@yahoo.co.jp',
    password: 'qsefthuko;@]',
    password_confirmation: 'qsefthuko;@]'
  },
  {
    userid: Settings.users_to_follow_immediately[1],
    username: '岡田淳',
    email: 'ken1dd2@gmail.com',
    password: 'awdrgyjilp:[',
    password_confirmation: 'awdrgyjilp:['
  },
]
users.each do |user|
  User.create(
    userid: user[:userid],
    username: user[:username],
    email: user[:email],
    password: user[:password],
    password_confirmation: user[:password_confirmation])
end
