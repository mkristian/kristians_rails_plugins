class Views::<%= plural_name.camelize %>::Show < Views::Layouts::Page

  def initialize(view, assigns, stream)
    super(view, assigns, stream, "show <%= singular_name %>")
  end

  def render_body    
    fieldset :class => :<%= plural_name %> do
      legend "show <%= singular_name %>"
  
<% for attribute in attributes -%>
      p do
        b "<%= attribute.column.human_name %>"
        br
        text @<%= singular_name %>.<%= attribute.name %>
      end

<% end -%>
<% if has_timestamps -%>
      p :class => :timestamps do
        text "created at #{@<%= singular_name %>.created_at}" 
        text " last updated at #{@<%= singular_name %>.updated_at}"
      end
<% end -%>
<% if has_guard -%>
      if allowed(:<%= plural_name %>, :edit)
        button_to 'Edit', edit_<%= singular_name %>_path(@<%= singular_name %>.id), :method => :get, :class => :button
      end
<% else -%>
      button_to 'Edit', edit_<%= singular_name %>_path(@<%= singular_name %>.id), :method => :get, :class => :button
<% end -%>
      button_to 'Back', <%= plural_name %>_path, :method => :get, :class => :button
    end
  end
end
