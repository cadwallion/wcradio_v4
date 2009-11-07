	require 'rack'
  require 'rack/contrib'

  #use Rack::Profiler if ENV['RACK_ENV'] == 'development'

  #use Rack::ETag
  #use Rack::MailExceptions

	use Rack::TimeZone
	
  run theapp
