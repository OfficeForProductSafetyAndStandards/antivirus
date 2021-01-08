require 'clamby'
require 'sinatra'
require 'sentry-ruby'

Clamby.configure(
  daemonize: true,
  error_clamscan_missing: true,
  error_clamscan_client_error: true,
  error_file_missing: true,
  error_file_virus: false
)

Sentry.init { |config| config.dsn = ENV['SENTRY_DSN'] }

use Sentry::Rack::CaptureExceptions

set :bind, '0.0.0.0'

helpers do
  def protect!(username, password)
    return if authorized?(username, password)

    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, 'Unauthorized'
  end

  def authorized?(username, password)
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials \
      && Rack::Utils.secure_compare(@auth.credentials[0], username) \
      && Rack::Utils.secure_compare(@auth.credentials[1], password)
  end
end

post '/safe' do
  protect!(ENV['ANTIVIRUS_USERNAME'], ENV['ANTIVIRUS_PASSWORD'])

  content_type :json

  file_path = params['file'][:tempfile].path
  File.chmod(0o777, file_path)
  { safe: Clamby.safe?(file_path) }.to_json
end

get '/health' do
  content_type :json

  begin
    status Clamby.safe?('./server.rb') ? 200 : 500

  # The ClamAV process takes a bit longer to start than the Sinatra process.
  # We can safely prevent Sentry capturing these exceptions but allow the
  # CloudFoundry health check to see the app is not healthy
  rescue Clamby::ClamscanClientError
    status 500
  end
end
