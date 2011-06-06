require 'json'
require_relative './Constants.rb'
require_relative './Errors.rb'

class JsonRpcServer
	include JsonRpcConstants
	include JsonRpcErrors

	def handle_message(inMessage)
		begin
			begin
				message = JSON.parse inMessage
			rescue JSON::ParserError => e
				raise(ParseError, e.message)
			end

			if message.class == Array	
				response = message.map{ |e| handle_request(e) }.to_json
				response.compact!
			else
				response = handle_request(message).to_json
			end
		rescue Error => e
			id = nil
			id = message['id'] if (message.class == Hash)
			error = create_message(id)
			error['error'] = e
			response = error.to_json
		ensure
			response
		end
	end

	def handle_request(inRequest)
		raise InvalidRequest if (inRequest.class != Hash)
		raise InvalidRequest if (inRequest['jsonrpc'] != VERSION)
		raise InvalidRequest if (!inRequest.key?('method'))
		
		begin
			method = method('r_' + inRequest['method'])
			params = inRequest['params']
			result = method.call(*params)
		rescue NameError => e
			raise(MethodNotFound, e.message)
		rescue ArgumentError => e
			raise(InvalidParams, e.message)
		end

		if inRequest.key?('id')
			response = create_message(inRequest['id'])
			response['result'] = result
			response
		else
			nil
		end
	end

	def create_message(inId = nil)
		message = {}
		message['jsonrpc'] = VERSION
		message['id'] = inId
		message
	end
end
