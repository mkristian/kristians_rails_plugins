class Views::<%= plural_name.camelize %>::Edit < Views::Layouts::Page

  def initialize(view, assigns, stream)
    super(view, assigns, stream, "edit <%= singular_name %>")
  end

  def render_body    
    fieldset :class => :<%= plural_name %> do
      legend "edit <%= singular_name %>"

      error_messages_for :<%= singular_name %>

      form_for(:<%= singular_name %>, :url => <%= singular_name %>_path(@<%= singular_name %>.id).to_s, :html => {:method => :put}) do |f|
<% for attribute in attributes -%>
        p do
          b "<%= attribute.column.human_name %>"
          br
          text raw(f.<%= attribute.field_type %>(:<%= attribute.name %>))
        end

<% end -%>
        p { text raw(f.submit("Update")) }
      end

      button_to 'Back', <%= plural_name %>_path, :method => :get, :class => :button
    end
  end
end
