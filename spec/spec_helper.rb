require 'rubygems'
require 'bundler/setup'
require 'channeladvisor'
require 'fakeweb'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rr
end

Savon.configure do |config|
	config.log = false
end

HTTPI.log = false

FakeWeb.allow_net_connect = false

# def stub_response(*args)
#   service   = args[0].to_s.downcase
#   method    = args[1].to_s.downcase
#   result    = args[2].to_s.downcase
#   status    = args[3]
#   response = {:body => File.expand_path("../fixtures/responses/#{service}_service/#{method}/#{result}.xml", __FILE__)}
#   response.update(:status => status) unless status.nil?

#   FakeWeb.register_uri(
#     :post,
#     "https://api.channeladvisor.com/ChannelAdvisorAPI/v6/OrderService.asmx",
#     response
#   )
# end
