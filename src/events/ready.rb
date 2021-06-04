# frozen_string_literal: true

require_relative "../app/app"

module RubyLab
  module Events
    def ready
      $client.ready do
        RubyLab::CONSOLE_LOGGER.info("Client login")
        $client.game = "Ruby <3"
      end
    end
    module_function :ready
  end
end
