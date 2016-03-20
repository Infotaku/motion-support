unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

compile_files = [
  'motion/_stdlib/date.rb',
  'motion/_stdlib/time.rb',
  'motion/core_ext/date/acts_like.rb',
  'motion/core_ext/date/calculations.rb',
  'motion/core_ext/date/conversions.rb',
  'motion/core_ext/date_and_time/calculations.rb',
  'motion/core_ext/integer/time.rb',
  'motion/core_ext/numeric/time.rb',
  'motion/core_ext/object/acts_like.rb',
  'motion/core_ext/time/acts_like.rb',
  'motion/core_ext/time/calculations.rb',
  'motion/core_ext/time/conversions.rb',
  'motion/duration.rb'
]

compilation_dependencies = {
  'motion/core_ext/date/calculations.rb' => 'motion/core_ext/date_and_time/calculations.rb',
  'motion/core_ext/time/calculations.rb' => 'motion/core_ext/date_and_time/calculations.rb'
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
