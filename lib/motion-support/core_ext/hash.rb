unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

compile_files = [
  'motion/core_ext/hash/deep_merge.rb',
  'motion/core_ext/hash/except.rb',
  'motion/core_ext/hash/indifferent_access.rb',
  'motion/core_ext/hash/keys.rb',
  'motion/core_ext/hash/reverse_merge.rb',
  'motion/core_ext/hash/slice.rb',
  'motion/core_ext/hash/deep_delete_if.rb',
  'motion/core_ext/module/delegation.rb',
  'motion/core_ext/ns_dictionary.rb',
  'motion/hash_with_indifferent_access.rb'
]

compilation_dependencies = {
  'motion/core_ext/ns_dictionary.rb' => 'motion/core_ext/module/delegation.rb',
  'motion/hash_with_indifferent_access.rb' => 'motion/core_ext/hash/keys.rb'
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
