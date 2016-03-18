unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

file_dependencies = {
  'motion/logger.rb' => ['motion/core_ext/module/attribute_accessors.rb'],
  'motion/callbacks.rb' => ['motion/concern.rb', 'motion/core_ext/class/attribute.rb'],
  'motion/core_ext/class/attribute_accessors.rb' => ['motion/core_ext/array/extract_options.rb'],
  'motion/core_ext/class/attribute.rb' => ['motion/core_ext/array/extract_options.rb', 'motion/core_ext/module/remove_method.rb'],
  'motion/inflections.rb' => ['motion/inflector/inflections.rb'],
  'motion/inflector/inflections.rb' => ['motion/core_ext/array/prepend_and_append.rb'],
  'motion/core_ext/ns_string.rb' => ['motion/core_ext/module/delegation.rb'],
  'motion/core_ext/ns_dictionary.rb' => ['motion/core_ext/module/delegation.rb'],
  'motion/core_ext/object/to_query.rb' => ['motion/core_ext/object/to_param.rb'],
  'motion/core_ext/time/acts_like.rb' => ['motion/core_ext/object/acts_like.rb'],
  'motion/core_ext/time/calculations.rb' => ['motion/core_ext/date_and_time/calculations.rb'],
  'motion/core_ext/date/calculations.rb' => ['motion/core_ext/date_and_time/calculations.rb'],
  'motion/core_ext/date/acts_like.rb' => ['motion/core_ext/object/acts_like.rb'],
  'motion/core_ext/range/include_range.rb' => 'motion/core_ext/module/aliasing.rb'
}

Motion::Project::App.setup do |app|
  parent = File.expand_path File.join(File.dirname(__FILE__), '..')

  app.files += Dir.glob(File.join(parent, "motion/**/*.rb"))

  app.files_dependencies file_dependencies.inject({}, &->(file_dependencies, (file, *dependencies)) do
    file = File.join(parent, file)
    dependencies = dependencies.flatten(1).map do |dependency|
      File.join(parent, dependency)
    end

    file_dependencies.merge({ file => dependencies })
  end)
end
