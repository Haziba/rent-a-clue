require 'net/http'
require 'json'

class SendCloud::Client
  BASE_URL = 'https://panel.sendcloud.sc/api/v2'

  def initialize
    @api_key = ENV['SENDCLOUD_API_KEY']
    @api_secret = ENV['SENDCLOUD_API_SECRET']
  end

  def create_parcel(parcel_data)
    uri = URI("#{BASE_URL}/parcels")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@api_key, @api_secret)
    request.content_type = 'application/json'
    request.body = parcel_data.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def bulk_print_labels(parcel_ids)
    uri = URI("#{BASE_URL}/labels/normal_printer?ids=#{parcel_ids.join(',')}")
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(@api_key, @api_secret)
    request.content_type = 'application/json'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    response.body
  end

  def shipping_methods(is_return:)
    uri = URI("#{BASE_URL}/shipping_methods?is_return=#{is_return ? 'true' : 'false'}")

    request = Net::HTTP::Get.new(uri)
    request.basic_auth(@api_key, @api_secret)
    request.content_type = 'application/json'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def get_parcel_status(parcel_id)
    uri = URI("#{BASE_URL}/parcels/#{parcel_id}")

    request = Net::HTTP::Get.new(uri)
    request.basic_auth(@api_key, @api_secret)
    request.content_type = 'application/json'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)['parcel']['status']
  end
end
