require __dir__ + "/server.rb"
require "prometheus/middleware/collector"
require "prometheus/middleware/exporter"

use Rack::Deflater
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter
run Sinatra::Application
