unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

file_dependencies = {
  'motion/callbacks.rb' => ['motion/concern.rb']
}

Motion::Project::App.setup do |app|
  parent = File.join(File.dirname(__FILE__), '..')

  app.files += Dir.glob(File.join(parent, "motion/**/*.rb"))

  app.files_dependencies file_dependencies.inject({}, &->(file_dependencies, (file, *dependencies)) do
    file = File.join(parent, file)
    dependencies = [dependencies].flatten(1).map do |dependency|
      File.join(parent, dependency)
    end

    file_dependencies.merge({ file => dependencies })
  end)
end
