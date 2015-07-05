require 'kuroneko'
require 'twitter'

parcel_number = '1234-1234-1234'

last_status = nil
neko = Kuroneko.new
twitter = Twitter::REST::Client.new(
  consumer_key: '',
  consumer_secret: '',
  accesss_token: '',
  access_token_secret: '',
)

loop do
  status = neko.status(parcel_number)
  if status != last_status && !last_status.nil?
    twitter.update("配送状況が更新されました: #{status.status} (#{status.date} #{status.time}) @ #{status.branch}")
    break if status.status =~ /完了$/
  end
  last_status = status
  sleep 60
end
