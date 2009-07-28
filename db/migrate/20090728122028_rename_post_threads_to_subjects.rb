class RenamePostThreadsToSubjects < ActiveRecord::Migration
  def self.up
    rename_column :post_threads, :subject, :title
    rename_table :post_threads, :subjects
    rename_column :posts, :thread_id, :subject_id
  end

  def self.down
    rename_column :posts, :subject_id, :thread_id
    rename_table :subjects, :post_threads
    rename_column :post_threads, :title, :subject
  end
end
