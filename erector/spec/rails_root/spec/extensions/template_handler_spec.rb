require File.expand_path("#{File.dirname(__FILE__)}/../rails_spec_helper")

module TemplateHandlerSpec
  
  class TemplateHandlerSpecController < ActionController::Base
  end
  
  describe ActionView::TemplateHandlers::Erector do
    attr_reader :controller, :view, :request, :response
    before do
      @controller = TemplateHandlerSpecController.new
      @request = ActionController::TestRequest.new
      @response = ActionController::TestResponse.new
      @controller.send(:initialize_template_class, @response)
      @controller.send(:assign_shortcuts, @request, @response)
      class << @controller
        public :render
      end
      controller.instance_variable_set('@foo', "foo")
      @view = @response.template
    end

    it "assigns locals" do
      controller.render :template => "template_handler_spec/test_page"
      response.body.should == "<div class=\"page\"><div class=\"partial\">foo</div></div>"
    end
  end

end
