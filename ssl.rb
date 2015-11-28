require 'uri'
require 'net/https'

$url = ARGV[0] # get a argument
$r_date_s = 30 # declare warning days

# show expiring days of SSL Web Server Certificate 
def GetCertDays(default_url)
	https = Net::HTTP.new(default_url, 443)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_NONE
	if cert = https.start do
			https.peer_cert
		end
	end

	days_until = ((cert.not_after - Time.now) / (60 * 60 * 24)).to_i
	puts "The remaining #{ days_until } days."
	
	if days_until <= 0
		puts "CRITICAL!!"
	elsif days_until > 0 && days_until <= 30
		puts "WARNING!!"
	else

	end
end

# reproduce argument and change argument to valid String 
tmp = ARGV[0].dup
$parsed_url = tmp[0..7]
$parsed2_url = tmp[-1]

# If argument is valid, Run GetCertDays function. else exit. return 1
if $parsed_url == "https://" 			
	if $parsed2_url == "/"
		tmp.chop!
	end
	tmp.slice!("https://")
	GetCertDays(tmp)
else
	puts "ERROR Check URL !!"
	exit 1
end

