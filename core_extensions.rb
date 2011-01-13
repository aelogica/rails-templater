module Rails
  module Generators
    module Actions

      attr_accessor :strategies
      attr_reader :template_options

      def initialize_templater
        @strategies = []
        @template_options = {}
      end
      
      def execute_strategies
        strategies.each {|stategy| stategy.call }
      end

      def load_options
        @template_options[:design] = ask("Which design framework? [none(default), compass]: ").downcase
        @template_options[:design] = "none" if @template_options[:design].nil?
      end

      def recipe(name)
        File.join File.dirname(__FILE__), 'recipes', "#{name}.rb"
      end

      # TODO: Refactor loading of files
      
      def load_snippet(name, group)
        path = File.expand_path name, snippet_path(group)
        File.read path
      end

      def load_template(name, group)
        path = File.expand_path name, template_path(group)
        File.read path
      end      

      def snippet_path(name)
        File.join(File.dirname(__FILE__), 'snippets', name)
      end

      def template_path(name)
        File.join(File.dirname(__FILE__), 'templates', name)
      end
      
      def check_rvmrc
        if yes?("Are you using RVM? [y|n]: ", Thor::Shell::Color::GREEN) 
          gemset = ask("What ruby version and gemset are you using? [e.g. 1.9.2-head@aelogica]").downcase
          create_file( ".rvmrc", "rvm use #{gemset}")
        end
      end

    end
  end
end
