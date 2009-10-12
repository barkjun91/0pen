class ChangeBodyOfRevision < ActiveRecord::Migration
  def self.up
    if adapter_name == 'MySQL'
      execute %{alter table revisions change body body longtext not null}
    else
      change_column :revisions, :body, :text, :null => false
    end
  end

  def self.down
    change_column :revisions, :body, :string, :null => false
  end
end
