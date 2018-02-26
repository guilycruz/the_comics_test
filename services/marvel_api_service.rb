require 'rest-client'
require 'digest/md5'
require 'logger'
# require 'pry'

class MarvelApiService

  def call(params)
    logger = Logger.new(STDOUT)
    # credentials = YAML::load(File.open(Rails.root.join('config/config.yml')))
    api_url = 'https://gateway.marvel.com:443/v1/public/'
    path = params.delete(:path)

    timestamp = Time.now.to_i.to_s
    params[:ts] = timestamp
    public_key = '9978ae9a00ae10aeaaa14a70b392c7ce'#credentials['marvel_api_public_key']
    params[:apikey] = public_key
    private_key = '2b254e4e333b90d32fe4527efd64a350b0911235'#credentials['marvel_api_private_key']
    hash = generate_md5_hash(timestamp, private_key, public_key)
    params[:hash] = hash

    begin
      puts "URL: #{api_url}#{path}"
      # puts "Params: #{params}"
      response = RestClient.get "#{api_url}#{path}", { params: params }
      # puts response.body
      response.body
    rescue RestClient::ExceptionWithResponse => e
      case e.http_code
      when 401
        logger.warn("Code: #{e.response.code} | Message: #{e.response.message}")
        response = { error: e.response.message }
      when 404
        logger.warn("Code: #{e}")
        # logger.warn("Code: #{e.response.code} | Message: #{e.response.message}")
        # response = { error: e.response.message }
      when 409
        logger.warn("Code: #{e.response.code} | Message: #{e.response.message}")
        response = { error: e.response.message }
      else
        logger.warn("Code: #{e.response.code} | Message: #{e.response.message}")
        response = { error: e.response.message }
      end
    else
      logger.info('Authentication successful!')
      return response
    end
  end

private

  def generate_md5_hash(timestamp, private_key, public_key)
    Digest::MD5.hexdigest(timestamp+private_key+public_key)
  end

end

# MarvelApiService.new.call({ path: 'characters', name: 'Hulk'})
