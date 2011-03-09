require 'rubygems'
require 'oauth'

KEY = "mark-server.dlinkddns.com"
SECRET = "jv7hmvF1j73pNpfT6pYlVE7y"

consumer = OAuth::Consumer.new(KEY, SECRET, {
  :site=>"https://www.google.com", 
  :request_token_path=>"/accounts/OAuthGetRequestToken",
  :authorize_path=>"/accounts/OAuthAuthorizeToken",
  :access_token_path=>"/accounts/OAuthGetAccessToken"})

request_token = consumer.get_request_token({}, {
  :scope => "http://gdata.youtube.com"})

p request_token.token          # The request token itself
p request_token.secret         # The request tokens' secret
p request_token.authorize_url  # The authorization URL at Google
