ActiveServiceClient.configure do |config|

  config.headers = { :content_type => :json, :accept => :json,
                     'Global-id' => lambda { |request| request.headers['Global-id'] || SecureRandom.uuid }
  }
  config.endpoints_path = 'config/endpoints.yml'

end