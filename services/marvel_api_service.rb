require 'rest-client'
require 'digest/md5'
require 'sinatra/config_file'

class MarvelApiService
  def call(params)
    api_url = App::settings.api_url
    path = params.delete(:path)

    timestamp = Time.now.to_i.to_s
    params[:ts] = timestamp
    public_key = App::settings.public_key
    params[:apikey] = public_key
    private_key = App::settings.private_key
    hash = generate_md5_hash(timestamp, private_key, public_key)
    params[:hash] = hash

    begin
      # puts "URL: #{api_url}#{path}"
      # puts "Params: #{params}"
      response = RestClient.get "#{api_url}#{path}", { params: params }
      response.body
    rescue RestClient::ExceptionWithResponse => e
      response = { error: e.response.message }.to_json
    else
      return response
    end
  end

private
  def generate_md5_hash(timestamp, private_key, public_key)
    Digest::MD5.hexdigest(timestamp+private_key+public_key)
  end
end
