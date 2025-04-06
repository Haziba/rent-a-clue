require 'net/http'
require 'uri'
require 'json'
require 'logger'

class DiscordLogger < Logger
  include Singleton

  def initialize
    @webhook_url = ENV['DISCORD_LOG_WEBHOOK_URL']
    super(nil)
  end

  def add(severity, message = nil, progname = nil, &block)
    msg = message || (block && block.call) || progname
    send_to_discord(severity_label(severity), msg)

    true
  end

  private

  def send_to_discord(level, message)
    puts "Sending to Discord: #{message}"
    return unless @webhook_url.present?

    uri = URI.parse(@webhook_url)
    body = {
      embeds: [
        {
          title: "Rails #{level} Log",
          description: "```\n#{message.to_s.truncate(1900)}\n```",
          color: discord_color_for(level)
        }
      ]
    }.to_json

    Net::HTTP.post(uri, body, { 'Content-Type': 'application/json' })
  rescue => e
    Rails.logger.error("[DiscordLogger] Failed to post: #{e.message}")
  end

  def severity_label(severity)
    case severity
    when Logger::DEBUG then "DEBUG"
    when Logger::INFO then "INFO"
    when Logger::WARN then "WARNING"
    when Logger::ERROR then "ERROR"
    when Logger::FATAL then "FATAL"
    else "UNKNOWN"
    end
  end

  def discord_color_for(level)
    {
      "DEBUG" => 0x95a5a6,
      "INFO" => 0x3498db,
      "WARNING" => 0xf1c40f,
      "ERROR" => 0xe74c3c,
      "FATAL" => 0xc0392b
    }[level] || 0x34495e
  end
end
