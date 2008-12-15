class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    <%= class_name %>.auto_upgrade!
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
