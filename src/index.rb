# frozen_string_literal: true

require_relative "app/app"

cmds = RubyLab::CommandHandler.load_commands
$client.commands = []

cmds.each { |cmd| $client.commands << RubyLab::Commands.method(cmd).call if RubyLab::Commands.respond_to?(cmd) }

events = RubyLab::EventHandler.load_events

events.each do |evt|
  RubyLab::Events.method(evt).call
end

begin
  $client.run
rescue StandardError => e
  RubyLab::CONSOLE_LOGGER.error(e.message)
end
