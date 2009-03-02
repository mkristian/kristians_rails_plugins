class Views::<%= plural_name.camelize %>::New < Views::Layouts::Page

  def initialize(view, assigns, stream)
    super(view, assigns, stream)
    @<%= singular_name %>_widget = <%= singular_name.camelize %>Widget.new(view, assigns, stream)
  end

  def title_text
    @<%= singular_name %>_widget.title
  end

  def render_body
    @<%= singular_name %>_widget.render_to(self)
  end
end
