class CreatePostThreads < ActiveRecord::Migration
  def self.up
    create_table :post_threads do |t|
      t.integer :forum_id, :null => false
      t.string :subject, :null => false
    end
  end

  def self.down
    drop_table :post_threads
  end
end
