module RailsPlan
  class RailsApp < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end
  end
end
