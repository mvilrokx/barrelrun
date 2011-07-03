# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

# Added by Mark Vilrokx -- THIS WORKED JUST FINE ON DEVELOPMENT!!!!
config.action_mailer.delivery_method = :sendmail
config.action_mailer.sendmail_settings = {
  :location       => '/usr/sbin/sendmail',
  :arguments      => '-i -t -f support@barrelrun.com'
}

#config.action_mailer.default_url_options = { :host => 'mark-server.dlinkddns.com:3000' }

# Added by Mark Vilrokx -- THIS WORKED JUST FINE
# NOTE THAT YOU CAN ONLY SEND 500 e-mails/day from GoDaddy!!!!
#config.action_mailer.delivery_method = :smtp
#config.action_mailer.server_settings = {
#  :address => 'smtpout.secureserver.net',
#  :domain  => 'www.barrelrun.com',
#  :port      => 80,
#  :user_name => 'jinbkim',
#  :password => 'acctpro1',
#  :authentication => :plain
#}

config.action_mailer.default_url_options = { :host => 'mark-server.dlinkddns.com:3000' }

config.after_initialize do
  Braintree::Configuration.environment = :sandbox
  Braintree::Configuration.merchant_id = "wj6wnxrgdvh5v5rx"
  Braintree::Configuration.public_key = "cdcsdmnwsfdtmf2j"
  Braintree::Configuration.private_key = "6k4b8m868p44dqpt"
end

