Gem::Specification.new do |s|
	s.name = 'jsonrpc2.0'
	s.version = '0.1.1'
	s.summary = 'A server and client implementation of the JsonRpc 2.0 protocol.'
	s.authors = ['Jannik Theiß']
	s.email = 'dev@coldsun.org'
	s.homepage = 'https://github.com/jtee/jsonrpc2.0'
	s.files = ['jsonrpc2.0.gemspec', 'lib/jsonrpc2.0.rb', 'lib/jsonrpc2.0/Client.rb', 'lib/jsonrpc2.0/Constants.rb', 'lib/jsonrpc2.0/Errors.rb', 'lib/jsonrpc2.0/Server.rb']
	s.required_ruby_version = '>= 1.9.2'
end
