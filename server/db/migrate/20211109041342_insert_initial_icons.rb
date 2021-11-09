class InsertInitialIcons < ActiveRecord::Migration[6.1]
  def change
    10.times do |i|
      Icon.create(image: File.open(Rails.root.join("db/icons/Account-icon#{i+1}.png")))
    end
  end
end
