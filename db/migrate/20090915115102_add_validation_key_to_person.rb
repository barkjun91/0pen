class AddValidationKeyToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :validation_key, :text
  end

  def self.down
    remove_column :people, :validation_key
  end
end
