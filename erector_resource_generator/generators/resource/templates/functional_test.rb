require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../test_helper'

class <%= controller_class_name %>ControllerTest < ActionController::TestCase

  def test_should_get_index
<% if has_guard -%>
    login_as_with_role :root, :root
<% end -%>
    get :index
    assert_response :success
    assert_not_nil assigns(:<%= table_name %>)
  end

  def test_should_get_new
<% if has_guard -%>
    login_as_with_role :root, :root
<% end -%>
    get :new
    assert_response :success
  end

  def test_should_create_<%= file_name %>
<% if has_guard -%>
    login_as_with_role :root, :root
<% end -%>
    assert_difference('<%= class_name %>.count') do
      post :create, :<%= file_name %> => {
        <% first = true
       for attribute in attributes 
       if first
         first = false
       else
        -%><%= "," %><% end -%> :<%= attribute.name %> => <% if attribute.type == :string || attribute.type == :text|| attribute.type == :datetime || attribute.type == :date || attribute.type == :time -%><%= "\"#{attribute.default}\"" %><% else -%><%= attribute.default %><% end -%>
<% end -%>

      }
    end

    assert_redirected_to <%= file_name %>_path(assigns(:<%= file_name %>).id)
  end

  def test_should_not_create_<%= file_name %>
<% if has_guard -%>
    login_as_with_role :root, :root
<% end -%>
    assert_no_difference('<%= class_name %>.count') do
      post :create, :<%= file_name %> => { }
    end

    assert_response :success
  end

  def test_should_show_<%= file_name %>
<% if has_guard -%>
    login_as_with_role :root, :root
<% end -%>
    get :show, :id => <% if datamapper -%>1
<% else -%><%= table_name %>(:one).id
<% end -%>
    assert_response :success
  end

  def test_should_get_edit
<% if has_guard -%>
    login_as_with_role :root, :root
<% end -%>
    get :edit, :id => <% if datamapper -%>1
<% else -%><%= table_name %>(:one).id
<% end -%>
    assert_response :success
  end

  def test_should_update_<%= file_name %>
<% if has_guard -%>
    login_as_with_role :root, :root
<% end -%>
    put :update, :id => <% if datamapper -%>1<% else -%><%= table_name %>(:one).id<% end -%>, :<%= file_name %> => {
        <% first = true
       for attribute in attributes 
       if first
         first = false
       else
        -%><%= "," %><% end -%> :<%= attribute.name %> => <% if attribute.type == :string || attribute.type == :text -%><%= "\"" + attribute.default  + "Next\"" %><% else -%><%= attribute.default %><% end -%>
<% end -%>

 }
    assert_redirected_to <%= file_name %>_path(assigns(:<%= file_name %>).id)
  end

  def test_should_not_update_<%= file_name %>
<% if has_guard -%>
    login_as_with_role :root, :root
<% end -%>
    put :update, :id => <% if datamapper -%>1<% else -%><%= table_name %>(:one).id<% end -%>, :<%= file_name %> => {
<% first = true
       for attribute in attributes 
       if first
         first = false 
       else
        -%><%= "," %><% end -%> :<%= attribute.name %> => <% if attribute.type == :string || attribute.type == :text -%><%= "\"<script>\"" %><% else -%><%= attribute.default %><% end 
       end-%>

      }
    assert_response :success
  end

  def test_should_destroy_<%= file_name %>
<% if has_guard -%>
    login_as_with_role :root, :root
<% end -%>
    assert_difference('<%= class_name %>.count', -1) do
      delete :destroy, :id => <% if datamapper -%>2
<% else -%><%= table_name %>(:two).id
<% end -%>
    end

    assert_redirected_to <%= table_name %>_path
  end
end
