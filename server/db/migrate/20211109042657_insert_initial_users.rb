class InsertInitialUsers < ActiveRecord::Migration[6.1]
  def change
    User.create(
      username: ENV['INITIAL_USER1_USERNAME'],
      userid: ENV['INITIAL_USER1_USERID'],
      email: ENV['INITIAL_USER1_EMAIL'],
      bio: ENV['INITIAL_USER1_BIO'],
      password: ENV['INITIAL_USER1_PASSWORD'],
      image: File.open(Rails.root.join("db/icons/ken10806-icon.png"))
    )
    User.create(
      username: ENV['INITIAL_USER2_USERNAME'],
      userid: ENV['INITIAL_USER2_USERID'],
      email: ENV['INITIAL_USER2_EMAIL'],
      bio: ENV['INITIAL_USER2_BIO'],
      password: ENV['INITIAL_USER2_PASSWORD'],
      image: File.open(Rails.root.join("db/icons/jun_okada-icon.png"))
    )
  end
end
