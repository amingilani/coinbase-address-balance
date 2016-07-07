#!/usr/local/bin/ruby

require 'coinbase/wallet'
require 'http'

coinbase = Coinbase::Wallet::Client.new(
  api_key: '2KGd0yk7sP1ZMsnd',
  api_secret: 'Gy0wAa2SZat96jJqjXviIGDz5qh3MTuH'
)

file = File.new('/Users/gilani/Sandbox/balance/balances.txt', 'w')

puts 'Initialized all the elements, my Lord'
puts 'Fetching accounts, my Lord'
accounts = coinbase.accounts
puts 'Fetched accounts, my Lord'

puts 'Fetching addresses, my Lord'
addresses = accounts
            .map { |a| coinbase.addresses(a['id']) }
            .flatten.map { |e| e['address'] }
puts 'Fetched all the addresses, my Lord.'

puts 'Fetching balances, my Lord'
balances = []
addresses = addresses.each_slice(5).to_a # convert addresses into chunks of 5
addresses.each do |address_chunk|
  uri = "http://btc.blockr.io/api/v1/address/balance/#{address_chunk.join(',')}"
  puts "fetching #{uri}"
  response = HTTP.get uri
  balances << response.parse['data']
  puts balances.last
end
balances.flatten!
puts 'Fetched all the balances, my Lord.'

addresses_with_money = balances
                       .select { |a| a['balance'] > 0 }
                       .map { |a| [a['address'], a['balance']] }

file.puts addresses_with_money
file.close
puts 'Saved the file, my Lord'
