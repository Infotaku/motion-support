unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

require 'motion-support/callbacks'
require 'motion-support/concern'
require 'motion-support/core_ext'
require 'motion-support/inflector'

compilation_dependencies = {
  'motion/logger.rb' => 'motion/core_ext/module/attribute_accessors.rb'
}

Motion::Project::App.setup do |app|
  parent = File.join(File.dirname(__FILE__), '..')

  app.files.unshift Dir.glob(File.expand_path File.join(parent, "motion/**/*.rb"))

  app.files_dependencies compilation_dependencies.inject({}, &->(file_dependencies, (file, *dependencies)) do
    file = File.expand_path File.join(parent, file)
    dependencies = dependencies.flatten(1).map do |dependency|
      File.expand_path File.join(parent, dependency)
    end

    file_dependencies.merge({ file => dependencies })
  end)
end
