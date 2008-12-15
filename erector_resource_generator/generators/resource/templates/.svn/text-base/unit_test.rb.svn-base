require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../test_helper'

class <%= class_name %>Test < ActiveSupport::TestCase
  
  def test_should_create_<%= singular_name %>
    assert_difference '<%= class_name %>.count' do
      <%= singular_name %> = create_<%= singular_name %>
      assert !<%= singular_name %>.new_record?, "#{<%= singular_name %>.errors.full_messages.to_sentence}"
    end
  end
<% for attribute in attributes 
  if attribute.type == :string or attribute.type == :text -%>

  def test_should_require_<%= attribute.name %>
    assert_no_difference '<%= class_name %>.count' do
      <%= singular_name %> = create_<%= singular_name %>(:<%= attribute.name %> => nil)
      assert <%= singular_name %>.errors.on(:<%= attribute.name %>)
    end
  end

  def test_should_not_match_<%= attribute.name %>
    assert_no_difference '<%= class_name %>.count' do
      <%= singular_name %> = create_<%= singular_name %>(:<%= attribute.name %> => "<script>" )
      assert <%= singular_name %>.errors.on(:<%= attribute.name %>)
    end
  end
<% elsif attribute.type == :integer %>
  def test_should_be_numerical_<%= attribute.name %>
    assert_no_difference '<%= class_name %>.count' do
      <%= singular_name %> = create_<%= singular_name %>(:<%= attribute.name %> => "string123" )
      assert_equal nil, <%= singular_name %>.<%= attribute.name %>, "none parsable integer are set to nil"
    end
  end
<%   end
end -%>

  protected
  def create_<%= singular_name %>(options = {})
    <%= class_name %>.create({ 
    <% first = true
       for attribute in attributes 
       if first
         first = false 
       else
         -%><%= "," %><% end -%> :<%= attribute.name %> => <% if attribute.type == :string || attribute.type == :text || attribute.type == :datetime || attribute.type == :date || attribute.type == :time -%><%= "\"#{attribute.default}\"" %><% else -%><%= attribute.default %><% end -%>
<% end -%>
       }.merge(options))
  end
end
