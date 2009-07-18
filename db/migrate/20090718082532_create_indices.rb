class CreateIndices < ActiveRecord::Migration
  def self.up
    add_index :forums, :name, :unique => true
    add_index :people, :email, :unique => true
    add_index :post_threads, :forum_id
    add_index :post_threads, :subject
    add_index :posts, :thread_id
    add_index :posts, :person_id
    add_index :revisions, :post_id
    add_index :revisions, :created_at
  end

  def self.down
    remove_index :forums
    remove_index :people
    remove_index :post_threads
    remove_index :post_threads
    remove_index :posts
    remove_index :posts
    remove_index :revisions
    remove_index :revisions
  end
end
