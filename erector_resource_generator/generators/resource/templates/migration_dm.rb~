class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
<% for attribute in attributes -%>
      t.<%= attribute.type %> :<%= attribute.name %>, :null => false <% if attribute.type == :string or attribute.type == :text -%>, :limit => 32
<% end -%>
<% end -%>
<% unless options[:skip_timestamps] %>
      t.timestamps
<% end -%>
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
