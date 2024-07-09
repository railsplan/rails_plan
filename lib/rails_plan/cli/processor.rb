# frozen_string_literal: true

module RailsPlan
  module Cli
    class Processor
      COMMANDS = %w[start apply].freeze

      InvalidCommand = Class.new(StandardError)
      InvalidUid = Class.new(StandardError)

      def initialize(args)
        @command = args[0]
        @uid = args[1]
      end

      def call
        validate_command

        raise InvalidUid, "Bootstrap plan or feature not found for #{@uid}" if json_template.nil?

        if @command == 'start'
          ::RailsPlan.start(json_template)
        elsif @command == 'apply'
          ::RailsPlan.apply(json_template)
        end
      end

      private

      def validate_command
        raise InvalidCommand, "command #{@command} is not supported!" unless COMMANDS.include?(@command.to_s.downcase)
      end

      def json_template
        return @json_template if defined?(@json_template)

        @json_template = if @command == 'start'
          ::RailsPlan::Cli::FetchTemplate.new.call(@uid)
        else
          ::RailsPlan::Cli::FetchBranch.new.call(@uid)
        end
      end
    end
  end
end
