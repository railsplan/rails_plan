# frozen_string_literal: true

require 'rest-client'
require 'json'
require 'fileutils'

require 'rails_plan/cli/fetch_template'
require 'rails_plan/cli/processor'
require 'rails_plan/version'

module RailsPlan
  class << self
    def build(files)
      dir_name = "rails_plan_app-#{Time.now.strftime('%Y%m%d%H%M%S')}"
      FileUtils.mkdir_p(dir_name)
      Dir.chdir(dir_name)

      files.each do |file|
        puts "-> \e[1;32;49mCreate\e[0m #{file['path']}"
        file_path = File.join(Dir.pwd, file['path'])
        FileUtils.mkdir_p(File.dirname(file_path))
        File.write(file_path, file['content'])
      end
    end
  end
end
