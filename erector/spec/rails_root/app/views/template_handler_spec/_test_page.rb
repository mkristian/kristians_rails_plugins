class Views::TemplateHandlerSpec::TestPage < Erector::Widget
  def render_partial
    div :class => 'partial' do
      text @foo
    end
  end
end
