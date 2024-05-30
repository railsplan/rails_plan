# frozen_string_literal: true

module RailsPlan
  module Cli
    class FetchTemplate
      COMMANDS = %w[apply].freeze
      API_URL = 'https://railsplan.com/api/v1'

      def call(uid)
        response = RestClient.get(API_URL + "/bootstrap_plans/#{uid}") { |res| res }

        return if response.code != 200

        JSON.parse(response.body)
      end

      def gem_version
        response = RestClient.get(API_URL + "/bootstrap_plans/gem_current_version")
        parsed_response = JSON.parse(response.body)

        parsed_response['version']
      end
    end
  end
end
