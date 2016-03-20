unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

compile_files = [
  'motion/core_ext/array/access.rb',
  'motion/core_ext/array/conversions.rb',
  'motion/core_ext/array/extract_options.rb',
  'motion/core_ext/array/grouping.rb',
  'motion/core_ext/array/prepend_and_append.rb',
  'motion/core_ext/array/wrap.rb',
  'motion/core_ext/array.rb'
]

compilation_dependencies = {
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
