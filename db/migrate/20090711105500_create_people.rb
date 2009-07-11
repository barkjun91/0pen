class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :email, :null => false
      t.string :password_hash, :null => false
      t.string :name
      t.string :nick, :null => false
      t.string :url

      t.timestamp :created_at, :null => false
      t.timestamp :updated_at, :null => false
    end
  end

  def self.down
    drop_table :people
  end
end
