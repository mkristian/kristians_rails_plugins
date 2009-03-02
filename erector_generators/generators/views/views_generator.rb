require "activerecord"
class ViewsGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false

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
        m.template("view_#{action}.rb",
                   File.join('app/views', controller_class_path, controller_file_name, "#{action}.rb"))
      end

      # Layout and stylesheet.
      m.template('page.rb', File.join('app/views/layouts', controller_class_path, "page.rb"))
      m.template('style.css', 'public/stylesheets/scaffold.css') if File.exists?('public/stylesheets')
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
           "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
  end
  
  def scaffold_views
    %w[ index show new edit ]
  end
  
  def model_name
    class_name.demodulize
  end
end
