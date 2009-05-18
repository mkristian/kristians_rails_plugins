class Views::<%= plural_name.camelize %>::<%= plural_name.camelize %>Widget < ErectorWidgets::EntitiesWidget

  def entities_symbol
    :<%= plural_name %>
  end

  def title
    <% if options[:i18n] -%>t("<%= plural_name %>.list")<% else -%>"<%= singular_name %>list"<% end -%>

  end
  
  def render_navigation
<% if options[:add_guard] -%>
    if allowed(:<%= plural_name %>, :new)
<% end -%>
      div :class => :nav_buttons do
        button_to <% if options[:i18n] -%>t('widget.new')<% else -%>'new'<% end-%>, new_<%= singular_name %>_path, :method => :get
      end
<% if options[:add_guard] %>    end
<% end -%>
  end

  def render_table_header
<% for attribute in attributes -%>
<% if attribute.field_type.to_s != 'text_area' -%>    th <% if options[:i18n] -%>t('<%= plural_name %>.<%= attribute.column.name %>')<% else -%>"<%= attribute.column.human_name %>"<% end -%>

<% end -%>
<% end -%>
  end

  def render_table_row(<%= singular_name %>)
<% attributes.each_with_index do |attribute, index| 
     if index == 0 -%>
    td do
<% if options[:add_guard] -%>
      args = {}
      if allowed(:<%= plural_name %>, :edit)
        args[:href] = edit_<%= singular_name %>_path(<%= singular_name %>.id)
      elsif allowed(:<%= plural_name %>, :show)
        args[:href] = <%= singular_name %>_path(<%= singular_name %>.id)
      end
<% end -%>
      a <%= singular_name %>.<%= attribute.name %>, <% if options[:add_guard] -%>args<% else -%>:href => edit_<%= singular_name %>_path(<%= singular_name %>.id)
<% end -%>

    end
<% else -%>
    <% if attribute.field_type.to_s != 'text_area' -%>td <%= singular_name %>.<%= attribute.name %>
<% end -%>
<%   end
   end -%>

    td :class => :cell_buttons do
<% if options[:add_guard] -%>
      if allowed(:<%= plural_name %>, :destroy)
<% end -%>
        form_for(:<%= singular_name %>, 
                 :url => <%= singular_name %>_path(<%= singular_name %>.id),
                 :html => { :method => :delete , #:confirm => 'Are you sure?'
                          }) do |f|
          rawtext(f.submit(<% if options[:i18n] -%>t('widget.delete')<% else -%>"delete"<% end -%>))
        end
<% if options[:add_guard] -%>
      end
<% end -%>
    end
  end
end
