require 'json'

module JsonRpcErrors
	ERRORS = {'ParseError' => -32700, 'InvalidRequest' => -32600, 'MethodNotFound' => -32601, 'InvalidParams' => -32602, 'InternalError' => -32603}

	class Error < StandardError
		CODE = nil

		attr_reader :data

		def code
			self.class::CODE
		end

		def initialize(message = "", data = nil)
			super message
			@data = data
		end

		def to_json(*a)
			error = {}
			error['code'] = code
			error['message'] = message
			error['data'] = data if !(data == nil)
			error.to_json(*a)
		end
	end

	def error_from_hash(inHash)
		c = self.class.const_get ERRORS.key(inHash['code'])
		c.new(inHash['message'], inHash['data'])
	end

	ERRORS.each do |className, errorCode|
		c = Class::new(Error) do
			const_set('CODE', errorCode)
		end
		const_set(className, c)
	end
end
