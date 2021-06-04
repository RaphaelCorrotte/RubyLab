# frozen_string_literal: true

require_relative "../../app/app"

module RubyLab
  module Commands
    def test
      RubyLab::Command.new({ :name => :test }) do |event, tools|
      end
    end
    module_function :test
  end
end
