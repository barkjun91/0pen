class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.string :name, :null => false
      t.string :title, :null => false
      t.text :description, :null => false
    end
  end

  def self.down
    drop_table :forums
  end
end
