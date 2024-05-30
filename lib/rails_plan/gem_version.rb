module RailsPlan
  class GemVersion
    NotUpdatedGem = Class.new(StandardError)

    def self.validate!
      newest_version = RailsPlan::Cli::FetchTemplate.new.gem_version

      return if system("gem list ^rails_plan$ --version #{newest_version} -i")

      raise NotUpdatedGem, "Please update the gem to newest version #{newest_version} and retry"
    end
  end
end
