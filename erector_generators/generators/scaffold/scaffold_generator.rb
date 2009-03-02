class ScaffoldGenerator < Rails::Generator::NamedBase
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
      
      m.dependency 'rspec_dm_model', [name] + @args, :collision => options[:collision]

      m.dependency 'controllers', [name], :collision => options[:collision]

      m.dependency 'views', [name] + @args, :collision => options[:collision]
    end
  end

  protected
  
  def banner
    "Usage: #{$0} scaffold ModelName [field:type, field:type]"
  end
  
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-timestamps",
           "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
  end
  
  def model_name
    class_name.demodulize
  end
end
