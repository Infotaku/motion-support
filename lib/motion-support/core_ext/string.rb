unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

compile_files = [
  'motion/core_ext/module/delegation.rb',
  'motion/core_ext/string/access.rb',
  'motion/core_ext/string/behavior.rb',
  'motion/core_ext/string/exclude.rb',
  'motion/core_ext/string/filters.rb',
  'motion/core_ext/string/indent.rb',
  'motion/core_ext/string/inflections.rb',
  'motion/core_ext/string/starts_ends_with.rb',
  'motion/core_ext/string/strip.rb',
  'motion/core_ext/ns_string.rb'
]

compilation_dependencies = {
  'motion/core_ext/ns_string.rb' => 'motion/core_ext/module/delegation.rb'
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
