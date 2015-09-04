require 'africas_talking_gateway.rb'
$smsGateway = AfricasTalkingGateway.new(ENV['AFRICAS_TALKING_USERNAME'],ENV['AFRICAS_TALKING_KEY'])