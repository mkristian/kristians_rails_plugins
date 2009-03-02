class Views::Layouts::Page < Erector::Widget

  def title_text
    "my app - #{self.class.name}"
  end
  
  def render
    instruct
    html :xmlns => "http://www.w3.org/1999/xhtml" do
      head do
        title title_text
        css "<%= File.exists?('public/stylesheets') ? '/stylesheets/' : '/' %>widgets.css"
      end
      body do
        div :id => 'header' do
          render_header
        end
        div :id => 'body' do
          render_body
        end
        div :id => 'footer' do
          render_footer
        end
      end
    end
  end

  def render_header
    a "MyApp Home", :href => "/"
  end

  def render_body 
    text "This page intentionally left blank."
  end

  def render_footer
    text "Copyright (c) <%= Date.today.year %>, Dagobert Duck"
  end
end
