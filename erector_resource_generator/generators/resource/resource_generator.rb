class ResourceGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false, :datamapper => false, :guard => false

  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_underscore_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_underscore_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name=base_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    require "activerecord" unless options[:datamapper]
    record do |m|
      postfix = options[:datamapper] ? "_dm" : "_ar"
      has_guard = options[:guard]
      has_timestamps = !options[:skip_timestamps]

      # Check for class naming collisions.
      m.class_collisions(controller_class_path, "#{controller_class_name}Controller")# , "#{controller_class_name}Helper")
      # TODO check for collisions without block regeneration !!!
      # m.class_collisions(controller_class_path, "#{controller_class_name}Helper")
      m.class_collisions(class_path, "#{class_name}")
      m.class_collisions class_path, class_name, "#{class_name}Test"

      # Controller, helper, views, and test directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/guards', controller_class_path)) if has_guard
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      m.directory(File.join('app/views/layouts', controller_class_path))
      m.directory(File.join('test/functional', controller_class_path))
      m.directory(File.join('test/unit', class_path))
      m.directory(File.join('test/fixtures', class_path))

      # Model class, unit test, and fixtures.
      m.template "model#{postfix}.rb",      File.join('app/models', class_path, "#{file_name}.rb")
      m.template 'guard.rb',      File.join('app/guards', class_path, "#{table_name}_guard.rb") if has_guard
      m.template 'unit_test.rb',  File.join('test/unit', class_path, "#{file_name}_test.rb")

      unless options[:skip_fixture] 
       	m.template 'fixtures.yml',  File.join('test/fixtures', "#{table_name}.yml"), :assigns => { :has_timestamps => has_timestamps}
      end

      unless options[:skip_migration] 
        if options[:datamapper]
          m.migration_template 'migration_dm.rb', 'db/migrate', :assigns => {
            :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
          }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"

        else
          m.migration_template 'migration.rb', 'db/migrate', :assigns => {
            :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
          }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
        end
      end

      for action in scaffold_views
        m.template(
          "view_#{action}.rb",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.rb"), :assigns => { :has_guard => has_guard, :has_timestamps => has_timestamps}
        )
      end

      # Layout and stylesheet.
      m.template("page#{postfix}.rb", File.join('app/views/layouts', controller_class_path, "page.rb"))
      # m.template('style.css', 'public/stylesheets/scaffold.css')

      #m.dependency 'model', [name] + @args, :collision => :skip

      m.template(
        "controller#{postfix}.rb", File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )

      m.template('functional_test.rb', File.join('test/functional', controller_class_path, "#{controller_file_name}_controller_test.rb"), :assigns => { :has_guard => has_guard, :datamapper => options[:datamapper]})
      m.template('helper.rb',          File.join('app/helpers',     controller_class_path, "#{controller_file_name}_helper.rb"))
      
      if options[:datamapper]
        environment(has_timestamps)
      end
      m.route_resources controller_file_name
    end
  end

  protected
    def environment(has_timestamps)
      if options[:datamapper]        
        unless options[:pretend]
          path = destination_path("config/environment.rb")
          content = File.read(path)
          has_datamapper = !content.match(/require\s.data_mapper./).nil?
          has_dm_timestamps = !content.match(/require\s.dm-timestamps./).nil?

          if has_datamapper 
            if not has_dm_timestamps and has_timestamps
              match = "require 'dm-validations'"
              replace = "require 'dm-timestamps'"
            end
          else
            match = "end"
            if has_timestamps
              replace = "#require 'data_mapper'
# validation does not work if data_mapper gets required first !!
require 'dm-validations'
require 'dm-aggregates'

DataMapper.setup(:default, {
   :adapter  => 'sqlite3',
   :database => \"db/#\{RAILS_ENV}.sqlite3\"
})

DataMapper::Logger.new('log/sql.log', 0)

#__auto_upgrade_marker__"
            else
              replace = "#require 'data_mapper'
# validation does not work if data_mapper gets required first !!
require 'dm-validations'
require 'dm-aggregates'
require 'dm-timestamps'

DataMapper.setup(:default, {
   :adapter  => 'sqlite3',
   :database => \"db/#\{RAILS_ENV}.sqlite3\"
})

DataMapper::Logger.new('log/sql.log', 0)

#__auto_upgrade_marker__"                         
            end
          end
          if match
            gsub_file 'config/environment.rb', /^#{match}/mi do |m|
              "#{match}\n#{replace}" 
            end
          end
          gsub_file 'config/environment.rb', /#__auto_upgrade_marker__/mi do |m|
            "#{class_name}.auto_upgrade!\n#__auto_upgrade_marker__" 
          end
        end
      end
    end

    def gsub_file(relative_destination, regexp, *args, &block)
      path = destination_path(relative_destination)
      content = File.read(path).gsub(regexp, *args, &block)
      File.open(path, 'wb') { |file| file.write(content) }
    end

    # Override with your own usage banner.
    def banner
      "Usage: #{$0} scaffold ModelName [field:type, field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration",
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
      opt.on("--datamapper",
             "Generate datamapper model") { |v| options[:datamapper] = v }
      opt.on("--guard",
             "Generate authorization guard for actions") { |v| options[:guard] = v }
    end

    def scaffold_views
      %w[ index show new edit ]
    end

    def model_name
      class_name.demodulize
    end
end