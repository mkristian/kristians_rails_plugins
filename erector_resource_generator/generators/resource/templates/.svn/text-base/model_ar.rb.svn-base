class <%= class_name %> < ActiveRecord::Base

<% for attribute in attributes 
    if attribute.type == :integer -%>
  validates_numericality_of :<%= attribute.name %>
<% elsif attribute.type == :string or attribute.type == :text %>
validates_format_of :<%= attribute.name %>, :with => /^[^<'&">]*$/
<% end 
end -%>
end
