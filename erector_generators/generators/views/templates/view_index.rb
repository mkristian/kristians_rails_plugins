class Views::<%= plural_name.camelize %>::Index < Views::Layouts::Page

  def initialize(view, assigns, stream)
    super(view, assigns, stream, "list <%= plural_name %>")
  end

  def render_body
    fieldset :class => :<%= plural_name %> do
      legend "list <%= plural_name %>"
  
      table :class => :index do
        tr do
<% for attribute in attributes -%>
          th "<%= attribute.column.human_name %>"
<% end -%>
        end

        for <%= singular_name %> in @<%= plural_name %>
          tr do
<% for attribute in attributes -%>
            td <%= singular_name %>.<%= attribute.name %>
<% end -%>
            td do 
              button_to 'Show', <%= singular_name %>_path(<%= singular_name %>.id), :method => :get, :class => :button
            end
            td do 
              button_to 'Edit', edit_<%= singular_name %>_path(<%= singular_name %>.id), :method => :get, :class => :button
            end
            td do
              button_to 'Destroy', <%= singular_name %>_path(<%= singular_name %>.id), :confirm => 'Are you sure?', :method => :delete, :class => :button
            end
          end
        end
      end

      br

      button_to 'New', new_<%= singular_name %>_path, :method => :get, :class => :button             
    end
  end
end
