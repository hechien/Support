#!/usr/bin/env ruby
#encoding: UTF-8

# load library
require 'net/http'
require 'uri'

# esay send http request
class Send
	@@last_response = nil
	@@last_exception = nil

	def self.request (url, options = {})
		options[:useragent] = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0) ' if options[:useragent].nil?

		begin
			uri = URI.parse(url)
			http = Net::HTTP.new(uri.host, uri.port)
			request = Net::HTTP::Post.new(uri.request_uri, 'User-Agent' => options[:useragent])
			request.set_form_data(options[:data])
			@@last_response = http.request(request)
			return @@last_response.body
		rescue Exception => e
			@@last_exception = e
			return nil
		end
	end

	def self.error
		return @@last_exception.message
	end

	def self.debug
		return @@last_exception.backtrace.inspect
	end
end

# how to use
# puts Send.request('http://google.com', data: { hello: 'world.' } )
# puts Send.error