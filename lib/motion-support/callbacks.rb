unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

compile_files = [
  'motion/_stdlib/array.rb',
  'motion/core_ext/array/extract_options.rb',
  'motion/core_ext/class/attribute.rb',
  'motion/core_ext/kernel/singleton_class.rb',
  'motion/core_ext/module/remove_method.rb',
  'motion/callbacks.rb',
  'motion/concern.rb',
  'motion/descendants_tracker.rb'
]

compilation_dependencies = {
  'motion/callbacks.rb' => ['motion/concern.rb', 'motion/core_ext/class/attribute.rb'],
  'motion/core_ext/class/attribute.rb' => ['motion/core_ext/array/extract_options.rb', 'motion/core_ext/module/remove_method.rb']
}

Motion::Project::App.setup do |app|
  parent = File.join(File.dirname(__FILE__), '../..')

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
