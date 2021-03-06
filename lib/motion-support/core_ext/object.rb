unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

compile_files = [
  'motion/_stdlib/cgi.rb',
  'motion/core_ext/object/acts_like.rb',
  'motion/core_ext/object/blank.rb',
  'motion/core_ext/object/deep_dup.rb',
  'motion/core_ext/object/duplicable.rb',
  'motion/core_ext/object/instance_variables.rb',
  'motion/core_ext/object/to_param.rb',
  'motion/core_ext/object/to_query.rb',
  'motion/core_ext/object/try.rb'
]

compilation_dependencies = {
  'motion/core_ext/object/to_query.rb' => 'motion/core_ext/object/to_param.rb'
}

Motion::Project::App.setup do |app|
  parent = File.join(File.dirname(__FILE__), '../../..')

  app.files.unshift(compile_files.map{ |file| File.expand_path File.join(parent, file) }.reject do |file|
    app.files.include? file
  end)

  app.files_dependencies compilation_dependencies.inject({}, &->(file_dependencies, (file, *dependencies)) do
    file = File.expand_path File.join(parent, file)
    dependencies = dependencies.flatten(1).map do |dependency|
      File.expand_path File.join(parent, dependency)
    end

    file_dependencies.merge({ file => dependencies })
  end)
end
