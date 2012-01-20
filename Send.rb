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
		options[:useragent] ||= 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0) '

		begin
			uri = URI.parse(url)
			http = Net::HTTP.new(uri.host, uri.port)
			request = Net::HTTP::Post.new(uri.request_uri, 'User-Agent' => options[:useragent])
			request.set_form_data(options[:data])
			@@last_response = http.request(request)
      return @@last_response.body if @@last_response.code == '200'
      
      @@last_exception = @@last_response.code
		rescue Exception => e
			@@last_exception = e
		end
    
    return nil
	end

	def self.error
    return @@last_exception if @@last_exception.kind_of?(String)
    return @@last_exception.message
	end

	def self.debug
    return 'HTTP_ERROR' if @@last_exception.kind_of?(String)
    return @@last_exception.backtrace.inspect
	end
end

# how to use
response = Send.request('http://localhost:4567', {data: { p: 'world.' }} )
response = Send.error if response.nil?
puts response