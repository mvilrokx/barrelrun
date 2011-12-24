# Rails 3.x
Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :you_tube, 'mark-server.dlinkddns.com', 'jv7hmvF1j73pNpfT6pYlVE7y'
  provider :you_tube, 'www.barrelrun.com', 'ewUXcSj3rH59UWo5jmzZ1K3l'
#  provider :twitter, 'ZC7GVkVfCfIoPpgI6CrMA', '5cppBETFGH4JcvI8DBZ2dX1sTDwpf8frrzxjEtYUS0'
end

## Rails 2.3.x
#ActionController::Dispatcher.middleware.use OmniAuth::Builder do
##  provider :you_tube, 'mark-server.dlinkddns.com', 'jv7hmvF1j73pNpfT6pYlVE7y'
#  provider :you_tube, 'www.barrelrun.com', 'ewUXcSj3rH59UWo5jmzZ1K3l'
#  provider :twitter, 'ZC7GVkVfCfIoPpgI6CrMA', '5cppBETFGH4JcvI8DBZ2dX1sTDwpf8frrzxjEtYUS0'
#end



