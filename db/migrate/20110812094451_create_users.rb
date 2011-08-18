class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password

      t.timestamps
    end
    #Гарантируюем уникальность в бд
    add_index :users, :email, :unique => true
    add_index :users, :name, :unique => true
  end
end

