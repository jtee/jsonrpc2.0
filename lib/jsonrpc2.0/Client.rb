require 'json'
require_relative './Constants.rb'
require_relative './Errors.rb'

class JsonRpcClient
	include JsonRpcConstants
	include JsonRpcErrors

	def method_missing(inMethod, *inParams)
		if (inMethod.to_s[(0..1)] == 'r_')
			fire_request(inMethod.to_s[(2..-1)].to_sym, *inParams)
		else
			super(inMethod, *inParams)
		end
	end

	def fire_request(inMethod, *inParams)
		request = create_message(inMethod, *inParams)
		request['id'] = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join

		response = send_request request.to_json
		response = JSON.parse response
		
		raise error_from_hash(response['error']) if response.key?('error')

		result = response['result']
		result
	end

	def fire_notification(inMethod, *inParams)
		send_notification create_message(inMethod, *inParams).to_json
		nil
	end

	
	private

	def create_message(inMethod, *inParams)
		message = {}
		message['jsonrpc'] = VERSION
		message['method'] = inMethod
		message['params'] = inParams if !inParams.empty?
		message
	end
end
