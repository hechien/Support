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

			if '200' == @@last_response.code then
				return @@last_response.body
			else
				@@last_exception = @@last_response.code
				return nil
			end
		rescue Exception => e
			@@last_exception = e
			return nil
		end
	end

	def self.error
		if @@last_exception.kind_of?(String) then
			return @@last_exception
		else
			return @@last_exception.message
		end
	end

	def self.debug
		if @@last_exception.kind_of?(String) then
			return 'HTTP_ERROR'
		else
			return @@last_exception.backtrace.inspect
		end
	end
end

# how to use
response = Send.request('http://google.com', data: { hello: 'world.' } )
response = Send.error if response.nil?
puts response