require __dir__ + "/server.rb"

use Rack::Deflater
run Sinatra::Application
