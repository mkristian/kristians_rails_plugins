en:
  <%= plural_name %>:
    created: <%= class_name %> was successfully created.
    updated: <%= class_name %> was successfully updated.
    deleted: <%= class_name %> was successfully deleted.
    new_<%= singular_name %>: new <%= singular_name %>
    <%= singular_name %>: <%= singular_name %>
    list: <%= singular_name %>list
<% for attribute in attributes -%>
    <%= attribute.column.name %>: <%= attribute.column.human_name %>
<% end -%>     
