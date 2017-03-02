class AlmondGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  no_tasks { attr_accessor :model_attributes, :controller_actions }
  #argument :scaffold_name, :type => :string, :required => true, :banner => 'ModelName'
  argument :args_for_c_m, :type => :array, :default => [], :banner => 'controller_actions and model:attributes'
  class_option :adapter, :desc => 'database adapter', :default => 'mysql2', :type => :string
  class_option :database_name, :desc => 'database name', :default => 'test', :type => :string
  class_option :username, :desc => 'database username', :default => 'root', :type => :string
  class_option :password, :desc => 'database password', :default => '', :type => :string
  class_option :socket, :desc => 'database socket', :default => '', :type => :string
  class_option :encoding, :desc => 'database encoding', :default=> 'utf8', :type => :string
  class_option :pool, :desc => 'database pool', :default => 5, :type => :string
  class_option :host, :desc => 'database host', :default => 'localhost', :type => :string


  def initialize(*args, &block)
    super

    #print_usage unless scaffold_name.underscore =~ /^[a-z][a-z0-9_\/]+$/

    @controller_actions = []
    @model_attributes = []

    args_for_c_m.each do |arg|
      if arg == '!'
        @invert_actions = true
      elsif arg.include?(':')
        temp_attr = arg.split(':')
        name = temp_attr[0]
        type = temp_attr[1]
        extra = temp_attr[2..-1]
        att = {:required => false, :disabled => false}
        if extra.present?
          if extra.include?('required')
            att[:required] = true
          end
          if extra.include?('disabled')
            att[:disabled] = true
          end
          if extra.include?('email')
            type = 'email'
          elsif extra.include?('password')
            type = 'password'
          elsif (extra.include?('numeric'))
            type = 'number'
            size = extra.map {|x| Integer(x) rescue nil }.compact
            att[:min] = size[0] if size[0]
            att[:max] = size[1] if size[1]
          elsif (extra.include?('date'))
            type = 'date'
          elsif (extra.include?('datetime'))
            type = 'datetime'
          end
          if extra.include?('date')
            att[:class] = "date"
          end
          if extra.include?('datetime')
            att[:class] = "datetime"
          end
        end
        #html_clas = temp_attr[2..-1].join(" ")
        @model_attributes << Rails::Generators::GeneratedAttribute.new(name,type,index_type=false, attr_options={:class=> att})
      else
        @controller_actions << arg
        @controller_actions << 'create' if arg == 'new'
        @controller_actions << 'update' if arg == 'edit'
      end
    end

    @controller_actions.uniq!
    @model_attributes.uniq!

    if @invert_actions || @controller_actions.empty?
      @controller_actions = all_actions - @controller_actions
    end

    if @model_attributes.empty?
      @skip_model = true # skip model if no attributes
      if model_exists?
        model_columns_for_attributes.each do |column|
          @model_attributes << Rails::Generators::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      else
        @model_attributes << Rails::Generators::GeneratedAttribute.new('name', 'string')
      end
    end
  end

  def create_model
    template 'model.rb', "app/models/#{model_path}.rb"
  end

  def create_controller
    unless options.skip_controller?
      template 'controller.rb', "app/controllers/#{plural_name}_controller.rb"

      template 'helper.rb', "app/helpers/#{plural_name}_helper.rb"

      controller_actions.each do |action|
        if %w[index show new edit].include?(action) # Actions with templates
          template "views/#{view_language}/#{action}.html.#{view_language}", "app/views/#{plural_name}/#{action}.html.#{view_language}"
        end
      end

      if form_partial?
        template "views/#{view_language}/_form.html.#{view_language}", "app/views/#{plural_name}/_form.html.#{view_language}"
      end

      namespaces = plural_name.split('/')
      resource = namespaces.pop
      route namespaces.reverse.inject("resources :#{resource}") { |acc, namespace|
        "namespace(:#{namespace}){ #{acc} }"
      }

    end
  end

  def create_bundle
    template 'bundle/scaffold.html.erb', "public/bundles/#{Time.now.to_i}-#{plural_name}/scaffold.html"
    template 'bundle/js/jquery.js', "public/bundles/#{Time.now.to_i}-#{plural_name}/javascripts/jquery.js"
    template 'bundle/js/bootstrap.js', "public/bundles/#{Time.now.to_i}-#{plural_name}/javascripts/bootstrap.js"
    template 'bundle/js/jquery.datatables.min.js', "public/bundles/#{Time.now.to_i}-#{plural_name}/javascripts/jquery.datatables.min.js"
    template 'bundle/css/bootstrap.css', "public/bundles/#{Time.now.to_i}-#{plural_name}/stylesheets/bootstrap.css"
    template 'bundle/css/form.css', "public/bundles/#{Time.now.to_i}-#{plural_name}/stylesheets/form.css"
    template 'bundle/css/jquery.datatables.css', "public/bundles/#{Time.now.to_i}-#{plural_name}/stylesheets/jquery.datatables.css"
  end

  private

  def db_config
    conf = {}
    conf[:adapter] = options.adapter
    conf[:username] = options.username
    conf[:password] = options.password
    conf[:database] = options.database_name
    conf[:pool] = options.pool.to_i
    conf[:encoding] = options.encoding
    conf[:host] = options.host
    return conf
  end

  def form_partial?
    actions? :new, :edit
  end

  def all_actions
    %w[index new create edit update]
  end

  def action?(name)
    controller_actions.include? name.to_s
  end

  def actions?(*names)
    names.all? { |name| action? name }
  end

  def singular_name

    name.underscore.singularize
  end

  def plural_name
    name.pluralize.underscore
  end

  def table_name
    name
    # if name.include?('::') && @namespace_model
    #   plural_name.gsub('/', '_')
    # end
  end

  def class_name
    if @namespace_model
      name.singularize.camelize
    else
      name.split('::').last.singularize.camelize
    end
  end

  def model_path
    class_name.underscore
  end

  def plural_class_name
    plural_name.camelize
  end

  def instance_name
    if @namespace_model
      singular_name.gsub('/','_')
    else
      singular_name.split('/').last
    end
  end

  def instances_name
    instance_name.pluralize
  end

  def controller_methods(dir_name)
    controller_actions.map do |action|
      read_template("#{dir_name}/#{action}.rb")
    end.join("\n").strip
  end

  def render_form
    if form_partial?
      if options.haml?
        "= render \"form\""
      else
        "<%= render \"form\" %>"
      end
    else
      read_template("views/#{view_language}/_form.html.#{view_language}")
    end
  end

  def item_resource
    name.underscore.gsub('/','_')
  end

  def items_path
    if action? :index
      "#{item_resource.pluralize}_path"
    else
      "root_path"
    end
  end

  def item_path(options = {})
    name = options[:instance_variable] ? "@#{instance_name}" : instance_name
    suffix = options[:full_url] ? "url" : "path"
    if options[:action].to_s == "new"
      "new_#{item_resource}_#{suffix}"
    elsif options[:action].to_s == "edit"
      "edit_#{item_resource}_#{suffix}(#{name})"
    else
      if name.include?('::') && !@namespace_model
        namespace = singular_name.split('/')[0..-2]
        "[:#{namespace.join(', :')}, #{name}]"
      else
        name
      end
    end
  end

  def item_url
    if action? :show
      item_path(:full_url => true, :instance_variable => true)
    else
      items_url
    end
  end

  def items_url
    if action? :index
      item_resource.pluralize + '_url'
    else
      "root_url"
    end
  end

  def item_path_for_spec(suffix = 'path')
    if action? :show
      "#{item_resource}_#{suffix}(assigns[:#{instance_name}])"
    else
      if suffix == 'path'
        items_path
      else
        items_url
      end
    end
  end

  def item_path_for_test(suffix = 'path')
    if action? :show
      "#{item_resource}_#{suffix}(assigns(:#{instance_name}))"
    else
      if suffix == 'path'
        items_path
      else
        items_url
      end
    end
  end

  def model_columns_for_attributes
    class_name.constantize.columns.reject do |column|
      column.name.to_s =~ /^(id|created_at|updated_at)$/
    end
  end

  def view_language
    options.haml? ? 'haml' : 'erb'
  end

  def model_exists?
    File.exist? destination_path("app/models/#{singular_name}.rb")
  end

  def read_template(relative_path)
    ERB.new(File.read(find_in_source_paths(relative_path)), nil, '-').result(binding)
  end

  def destination_path(path)
    File.join(destination_root, path)
  end

end
