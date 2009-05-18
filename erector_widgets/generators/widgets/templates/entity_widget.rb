class Views::<%= plural_name.camelize %>::<%= singular_name.camelize %>Widget < ErectorWidgets::EntityWidget

  def entity_symbol 
    :<%= singular_name %>
  end
 
  def title
    if @<%= singular_name %>.new_record?
<% if options[:i18n] -%>
      t('<%= plural_name %>.new_<%= singular_name %>')
<% else -%>
      "new <%= singular_name %>"
<% end -%>
    else
<% if options[:i18n] -%>
      t('<%= plural_name %>.<%= singular_name %>') + " #{@<%= singular_name %>.<%= attributes[0].name%>}"
<% else -%>
      "<%= singular_name %> #{@<%= singular_name %>.<%= attributes[0].name%>}"
<% end -%>
    end
  end

  def render_navigation(disabled)
    super
    if disabled and not @<%= singular_name %>.new_record?
<% if options[:add_guard] -%>
      if allowed(:<%= plural_name %>, :new)
<% end -%>
        div :class => :nav_buttons do
          button_to <% if options[:i18n] -%>t('widget.new')<% else -%>'new'<% end-%>, new_<%= singular_name %>_path, :method => :get, :class => :button
        end
<% if options[:add_guard] %>      end
<% end -%>
<% if options[:add_guard] -%>
      if allowed(:<%= plural_name %>, :edit)
<% end -%>
        div :class => :nav_buttons do
          button_to <% if options[:i18n] -%>t('widget.edit')<% else -%>'edit'<% end -%>, edit_<%= singular_name %>_path(@<%= singular_name %>.id), :method => :get, :class => :button
        end
<% if options[:add_guard] %>      end
<% end -%>
    end
  end

  def render_entity(disabled)
    args = 
      if @<%= singular_name %>.new_record?
        {:url => <%= plural_name %>_path.to_s, :html => {:method => :post}}
      elsif disabled
        {:url => edit_<%= singular_name %>_path(@<%= singular_name %>.id).to_s, :html => {:method => :get} }
      else
        {:url => <%= singular_name %>_path(@<%= singular_name %>.id).to_s, :html => {:method => :put} }
      end
    
    form_for(:<%= singular_name %>, args) do |f|
      div :class => :scrollable do
<% attributes.each_with_index do |attribute, index| -%>
        div :class => <%= index % 2 == 0 ? ":second" : ":first" %> do
          b <% if options[:i18n] -%>t('<%= plural_name %>.<%= attribute.column.name %>')<% else -%>"<%= attribute.column.human_name %>"<% end -%>

          br
          rawtext (f.<%= attribute.field_type %>(:<%= attribute.name %>, :disabled => disabled))
        end

<% end -%>
      end
      unless disabled
        div :class => :action_button do
          if @<%= singular_name %>.new_record?
            rawtext(f.submit(<% if options[:i18n] -%>t('widget.create')<% else -%>"Create"<% end -%>))
          else
            rawtext(f.submit(<% if options[:i18n] -%>t('widget.update')<% else -%>"Update"<% end -%>))
          end
        end
      end
    end
  end
end
