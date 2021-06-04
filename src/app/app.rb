# frozen_string_literal: true

require "discordrb"
require "json"
require "yaml"
require_relative "bot"
require_relative "logger"
require_relative "error"
require_relative "command_handler"
require_relative "event_handler"
require_relative "command"
require_relative "utils"
require_relative "date"

# GameBox is the module discord bot
module RubyLab
  include Discordrb
  include JSON
  include YAML
  CONSOLE_LOGGER = Logger.new(:console)
  FILE_LOGGER = Logger.new(:file)
end

$ruby_lab = RubyLab::Client.new(YAML.safe_load(File.read("src/private/config.yml"))[:token])
$client = $ruby_lab.client
