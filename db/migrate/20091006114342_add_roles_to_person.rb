class AddRolesToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :roles, :string, :default => "\n", :null => false
  end

  def self.down
    remove_column :people, :roles
  end
end
