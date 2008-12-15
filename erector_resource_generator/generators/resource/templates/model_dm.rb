class <%= class_name %>

  include DataMapper::Resource

  property :id, Integer, :serial => true

<% for attribute in attributes -%>
  property :<%= attribute.name %>, <%= attribute.type == :datetime ? DateTime : attribute.type.to_s.capitalize %>, :nullable => false <% if attribute.type == :string or attribute.type == :text -%>, :format => /^[^<'&">]*$/, :length => 32
<% else -%>

<% end -%>
<% end -%>
<% unless options[:skip_timestamps] %>
  property :created_at, DateTime, :nullable => false
  property :updated_at, DateTime, :nullable => false

<% end -%>
end
