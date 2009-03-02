class Views::<%= plural_name.camelize %>::Index < Views::Layouts::Page

  def initialize(view, assigns, stream)
    super(view, assigns, stream)
    @<%= plural_name %>_widget = <%= plural_name.camelize %>Widget.new(view, assigns, stream)
  end

  def title_text
    @<%= plural_name %>_widget.title
  end

  def render_body
    @<%= plural_name %>_widget.render_to(self)
  end
end
