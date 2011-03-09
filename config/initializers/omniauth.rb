#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :youtube, 'mark-server.dlinkddns.com', 'jv7hmvF1j73pNpfT6pYlVE7y'
#end
ActionController::Dispatcher.middleware.use OmniAuth::Builder do
  provider :you_tube, 'mark-server.dlinkddns.com', 'jv7hmvF1j73pNpfT6pYlVE7y'
  provider :twitter, 'ZC7GVkVfCfIoPpgI6CrMA', '5cppBETFGH4JcvI8DBZ2dX1sTDwpf8frrzxjEtYUS0'
end

