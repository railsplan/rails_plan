# frozen_string_literal: true

module RailsPlan
  module Cli
    class FetchTemplate
      API_URL = 'https://railsplan.com/api/v1'

      def call(uid)
        response = RestClient.get(API_URL + "/plans/#{uid}") { |res| res }

        return if response.code != 200

        JSON.parse(response.body)
      end
    end
  end
end
