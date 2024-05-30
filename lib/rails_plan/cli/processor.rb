# frozen_string_literal: true

module RailsPlan
  module Cli
    class Processor
      COMMANDS = %w[start].freeze

      InvalidCommand = Class.new(StandardError)
      InvalidUid = Class.new(StandardError)

      def initialize(args)
        @command = args[0]
        @uid = args[1]
      end

      def call
        validate_command

        raise InvalidUid, "Bootstrap plan not found for #{@uid}" if json_template.nil?

        ::RailsPlan.start(json_template)
      end

      private

      def validate_command
        raise InvalidCommand, "command #{@command} is not supported!" unless COMMANDS.include?(@command.to_s.downcase)
      end

      def json_template
        return @json_template if defined?(@json_template)

        @json_template = ::RailsPlan::Cli::FetchTemplate.new.call(@uid)
      end
    end
  end
end
