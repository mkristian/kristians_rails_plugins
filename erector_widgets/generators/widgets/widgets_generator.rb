require "activerecord"
class WidgetsGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_page => false, :add_guard => false, :i18n => false

  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_singular_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_singular_name, @controller_plural_name = inflect_names(base_name)

    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions("#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_name)
      
      # Controller, helper, views, and test directories.
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      m.directory(File.join('app/views/layouts', controller_class_path))
            
      for action in scaffold_views
        m.template("#{action}.rb",
                   File.join('app/views', controller_class_path, controller_file_name, "#{action}.rb"))
      end

      m.template("entity_widget.rb",
                 File.join('app/views', controller_class_path, controller_file_name, "#{singular_name}_widget.rb"))

      m.template("entities_widget.rb",
                 File.join('app/views', controller_class_path, controller_file_name, "#{plural_name}_widget.rb"))

      # Layout and stylesheet.
      unless options[:skip_page]
        m.template('page.rb', File.join('app/views/layouts', controller_class_path, "page.rb"))
      end
      if File.exists?('public/stylesheets')
        m.template('style.css', 'public/stylesheets/widgets.css') 
      else
        m.template('style.css', 'public/widgets.css')
      end
    end
  end

  protected
  
  def banner
    "Usage: #{$0} views ModelName [field:type, field:type]"
  end
  
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-timestamps",
           "Don't add timestamps for this model") { |v| options[:skip_timestamps] = v }
    opt.on("--skip-page",
           "Skip layout page") { |v| options[:skip_page] = v }
    opt.on("--add-guard",
           "Add guards for the actions on this model") { |v| options[:add_guard] = v }
    opt.on("--i18n",
           "use i18n keys instead of text") { |v| options[:i18n] = v }
  end
  
  def scaffold_views
    %w[ index show new edit ]
  end
  
  def model_name
    class_name.demodulize
  end
end
