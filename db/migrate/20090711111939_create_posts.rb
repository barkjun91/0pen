class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :thread_id, :null => false
      t.integer :person_id, :null => false
    end
  end

  def self.down
    drop_table :posts
  end
end
