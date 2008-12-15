class Views::Layouts::Page < Erector::Widget
  def initialize(view, assigns, stream, title = self.class.name)
    super(view, assigns, stream)
    @title = title
  end

  def error_messages_for(entities)
    if entities.instance_of? Symbol
      entities = [entities]
    end
    size = 0
    errortext = ""
    entities.each do |entity|
      name = "@#{entity.to_s}"
      instance = instance_variable_get(name)
      if instance.errors.size > 0
        size = size + instance.errors.size
        errortext = "#{errortext}<br />#{instance.errors.full_messages.join('<br />')}" 
      end
    end
    if size > 0
      fieldset :class => :errors do
        legend "input errors"
        rawtext errortext
      end
    end
  end

  def error_message_on(entity, attribute)
    name = "@#{entity.to_s}"
    instance = instance_variable_get(name)
    if instance.errors[attribute.to_sym].size > 0
      fieldset :class => :errors do
        legend "input errors"
        rawtext "#{instance.errors[attribute.to_sym].join('<br />')}"
      end
    end
  end

  def render
    instruct
    html :xmlns => "http://www.w3.org/1999/xhtml" do
      head do
        title "my app - #{@title}"
        #css "scaffold.css"
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
