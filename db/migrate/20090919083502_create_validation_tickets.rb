class CreateValidationTickets < ActiveRecord::Migration
  def self.up
    create_table :validation_tickets do |t|
      t.string :email, :null => false
      t.string :key, :null => false
    end

    remove_column :people, :validation_key
  end

  def self.down
    add_column :people, :validation_key, :text
    drop_table :validation_tickets
  end
end
