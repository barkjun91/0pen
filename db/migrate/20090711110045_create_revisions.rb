class CreateRevisions < ActiveRecord::Migration
  def self.up
    create_table :revisions do |t|
      t.integer :post
      t.string :body
      t.timestamp :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :revisions
  end
end
