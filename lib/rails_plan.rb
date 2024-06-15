# frozen_string_literal: true

require 'rest-client'
require 'json'
require 'fileutils'
require 'thor'

require 'rails_plan/cli/fetch_template'
require 'rails_plan/cli/processor'
require 'rails_plan/version'
require 'rails_plan/rails_app'
require 'rails_plan/gem_version'

module RailsPlan
  RailsNotInstalled = Class.new(StandardError)

  class << self
    def start(template)
      ::RailsPlan::GemVersion.validate!

      verify_rails_installation
      
      generate_project(template)
      generate_files(template['files'])
      run_commands(template['before_commands'])
      clone_files(template['clones'])
      inject_code(template['inject_code'])
      append_code(template['append_code'])
      update_files(template['gsub'])

      template['steps'].each do |step|
        puts step['title'] if step['title']
        run_commands(step['before_commands'])
        generate_files(step['files'])
        prepend_to_file(step['prepend_code'])
        run_commands(step['after_commands'])
      end
    end

    private

    def verify_rails_installation
      return if system("gem list ^rails$ --version #{RailsPlan::RAILS_VERSION} -i")

      raise RailsNotInstalled, "Please install Rails #{RailsPlan::RAILS_VERSION} and retry"
    end

    def generate_project(template)
      system template['installation_command']

      Dir.chdir(template['name'])
    end

    def generate_files(files)
      files.each do |file|
        puts "-> \e[1;32;49mCreate\e[0m #{file['file_path']}"
        file_path = File.join(Dir.pwd, file['file_path'])
        FileUtils.mkdir_p(File.dirname(file_path))
        File.write(file_path, file['content'])
      end
    end

    def run_commands(commands)
      commands.each do |command|
        puts "-> \e[1;32;49mRun\e[0m #{command}"
        system command
      end
    end

    def inject_code(injections)
      return if injections.nil? || injections.empty?

      thor_app = ::RailsPlan::RailsApp.new

      injections.each do |injection|
        thor_app.inject_into_class(injection['file_path'], injection['class_name'], injection['content'])
      end
    end

    def prepend_to_file(injections)
      return if injections.nil? || injections.empty?

      thor_app = ::RailsPlan::RailsApp.new

      injections.each do |injection|
        thor_app.insert_into_file(injection['file_path'], injection['content'], after: injection['after'])
      end
    end

    def append_code(appends)
      return if appends.nil? || appends.empty?

      thor_app = ::RailsPlan::RailsApp.new

      appends.each do |append|
        thor_app.append_to_file(append['file_path'], append['content'])
      end
    end

    def update_files(updates)
      return if updates.nil? || updates.empty?

      thor_app = ::RailsPlan::RailsApp.new

      updates.each do |update|
        thor_app.gsub_file(update['file_path'], update['pattern'], update['value'])
      end
    end

    def clone_files(files)
      return if files.nil? || files.empty?

      files.each do |file|
        FileUtils.cp(file['from'], file['to'])
      end
    end
  end
end
