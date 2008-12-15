class Views::<%= plural_name.camelize %>:: New < Views::Layouts::Page

  def initialize(view, assigns, stream)
    super(view, assigns, stream, "new <%= singular_name %>")
  end

  def render_body
    fieldset :class => :<%= plural_name %> do
      legend "new <%= singular_name %>"

      error_messages_for :<%= singular_name %>

      form_for(@<%= singular_name %>) do |f|
<% for attribute in attributes -%>
        p do
          b "<%= attribute.column.human_name %>"
          br
          text raw(f.<%= attribute.field_type %>(:<%= attribute.name %>))
        end

<% end -%>
        p { text raw(f.submit("Create")) }
      end

      button_to 'Back', <%= plural_name %>_path, :method => :get, :class => :button
    end
  end
end
