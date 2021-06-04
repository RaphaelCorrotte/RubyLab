# frozen_string_literal: true

require_relative "app"

module RubyLab::Utils
  # If a user has admin permissions
  # @param id [Integer] The user ID
  # @return [Boolean] if user is admin or not
  def authorized?(id)
    $client.config[:authorized].include?(id.to_i)
  end

  # Build the embed's body
  # @param embed [Discordrb::Webhooks::Embed] the embed to build
  # @return [Discordrb::Webhooks::Embed] the built embed
  def build_embed(embed = Discordrb::Webhooks::Embed.new, message = nil)
    embed.title = $client.bot_app.name
    embed.timestamp = Time.at(Time.now.to_i)
    if message
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Demandé par #{message.author.name}",
                                                      icon_url: message.author.avatar_url)
    end
    embed
  end

  # Add some fields to an embed
  # @param embed [Discordrb::Webhooks::Embed] the embed to build
  # @param fields [Object] The fields to add
  # @param inline [Boolean] if the fields ar inlined
  # @return [Discordrb::Webhooks::Embed] the built embed
  def add_fields(fields, inline, embed = Discordrb::Webhooks::Embed.new)
    if fields.respond_to?(:each)
      fields.each do |field|
        embed.add_field(name: field[:name].to_s, value: field[:value].to_s, inline: inline)
        embed
      end
    else false end
  end

  # Get a command by name
  # @param command_name [StringIO] the name of the command
  # @param props [Object] The props to return a command
  # @return [Method] call the method and get the command object
  def get_command(command_name, props = { boolean: false })
    if props[:boolean]
      return true if RubyLab::Commands.respond_to?(command_name)
      return false unless RubyLab::Commands.respond_to?(command_name)
    elsif RubyLab::Commands.respond_to?(command_name)
      RubyLab::Commands.method(command_name).call
    end
  end

  # Returns a displayed text
  # @param text [StringIO] The text to display
  # @return [StringIO] the displayed text
  def display(text)
    text.split(/\s+|_+/).map do |word|
      if word.size <= 2
        word.upcase
      else
        "#{word[0].upcase}#{word.slice(1, word.size).downcase}"
      end
    end
        .join(" ")
  end

  def get_member(tools, message_event, setting = { :include_author => true })
    if tools && message_event
      if tools[:args].empty? && setting[:include_author]
        message_event.author
      elsif !message_event.message.mentions.empty?
        message_event.server.users.filter { |usr| usr.id == message_event.message.mentions.first.id }.first
      elsif !message_event.server.members.filter { |usr| usr.id == tools[:args][0].to_i }.empty?
        message_event.server.members.filter { |usr| usr.id == tools[:args][0].to_i }.first
      elsif !message_event.channel.server.members.filter { |usr| usr.username.match(/#{tools[:args].join(" ")}/) }.empty?
        message_event.server.members.filter { |usr| usr.username.match(/#{tools[:args].join(" ")}/) }.first
      else
        :not_found
      end
    else false end
  end

  def get_channel(tools, message_event)
    if tools && message_event
      if tools[:args].empty?
        message_event.message.channel
      elsif !message_event.message.mentions.empty?
        message_event.server.channels.filter { |chn| chn.id == message_event.message.mentions.first.id }.first
      elsif !message_event.server.channels.filter { |chn| chn.id == tools[:args][0].to_i }.empty?
        message_event.server.channels.filter { |chn| chn.id == tools[:args][0].to_i }.first
      elsif !message_event.channel.server.channels.filter { |chn| chn.name.match(/#{tools[:args].join(" ")}/) }.empty?
        message_event.server.channels.filter { |chn| chn.name.match(/#{tools[:args].join(" ")}/) }.first
      else
        false
      end
    else false end
  end

  alias owner? authorized?
  alias find_command get_command
  module_function :authorized?,
                  :owner?,
                  :build_embed,
                  :get_command,
                  :find_command,
                  :add_fields,
                  :display,
                  :get_member,
                  :get_channel
end
