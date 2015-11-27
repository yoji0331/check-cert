require 'uri'
require 'net/https'

$url = ARGV[0] # 引数を取得
$r_date_s = 30 # 警告期限の宣言

# 引数で得たURLのSSL証明書の有効期限の表示
def GetCertDays(default_url)
	https = Net::HTTP.new(default_url, 443)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_NONE
	if cert = https.start do
			https.peer_cert
		end
	end

	days_until = ((cert.not_after - Time.now) / (60 * 60 * 24)).to_i
	p days_until
	
	if days_until <= 0
		puts "CRITICAL!!"
	elsif days_until > 0 && days_until <= 30
		puts "WARNING!!"
	else

	end
end

# 引数を複製して有効な文字列に変換
tmp = ARGV[0].dup
$parsed_url = tmp[0..7]
$parsed2_url = tmp[-1]

# 引数が有効なら実行、無効なら終了
if $parsed_url == "https://" 			
	if $parsed2_url == "/"
		tmp.chop!
	end
	tmp.slice!("https://")
	GetCertDays(tmp)
else
	puts "ERROR Check URL !!"
	exit 2
end

