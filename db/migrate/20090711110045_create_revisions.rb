class CreateRevisions < ActiveRecord::Migration
  def self.up
    create_table :revisions do |t|
      t.integer :post_id, :null => false
      t.string :body, :null => false
      t.timestamp :created_at, :null => false
    end
  end

  def self.down
    drop_table :revisions
  end
end
