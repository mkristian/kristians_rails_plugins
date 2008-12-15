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
<% if has_guard -%>
              if allowed(:<%= plural_name %>, :show)
                button_to 'Show', <%= singular_name %>_path(<%= singular_name %>.id), :method => :get, :class => :button
              else
                " "
              end
<% else -%>
              button_to 'Show', <%= singular_name %>_path(<%= singular_name %>.id), :method => :get, :class => :button
<% end -%>
            end
            td do 
<% if has_guard -%>
              if allowed(:<%= plural_name %>, :edit)
                button_to 'Edit', edit_<%= singular_name %>_path(<%= singular_name %>.id), :method => :get
              else
                " "
              end
<% else -%>
              button_to 'Edit', edit_<%= singular_name %>_path(<%= singular_name %>.id), :method => :get
<% end -%>
            end
            td do
<% if has_guard -%> 
              if allowed(:<%= plural_name %>, :destroy)
                button_to 'Destroy', <%= singular_name %>_path(<%= singular_name %>.id), :confirm => 'Are you sure?', :method => :delete, :class => :button
              else
                " "
              end
<% else -%>
              button_to 'Destroy', <%= singular_name %>_path(<%= singular_name %>.id), :confirm => 'Are you sure?', :method => :delete, :class => :button
<% end -%>              
            end
          end
        end
      end

<% if has_guard -%> 
      if allowed(:<%= plural_name %>, :new)
        br

        button_to 'New', new_<%= singular_name %>_path, :method => :get, :class => :button
      end
<% else -%>
      br

      button_to 'New', new_<%= singular_name %>_path, :method => :get, :class => :button
<% end -%>              
    end
  end
end
