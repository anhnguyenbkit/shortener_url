require 'socket'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Simple bijective function
#   Basically encodes any integer into a base(n) string,   where n is
#   ALPHABET.length. Based on pseudocode from
#   http://stackoverflow.com/questions/742013/how-to-code-a-url-
#   shortener/742047#742047
  ALPHABET =
  	"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split(//)
  	# make your own alphabet using:
	# (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).shuffle.join

  def bijective_encode
  	# from http://refactormycode.com/codes/124-base-62-encoding
  	# with only minor modification
  	# return ALPHABET[0] if i == 0
  	# s = ''
  	# base = ALPHABET.length
  	# while i > 0
  	# 	s << ALPHABET[i.modulo(base)]
  	# 	i /= base
  	# end
  	# s.reverse + SecureRandom.hex(5 - s.length)
  	SecureRandom.hex(4)
  end

  def bijective_decode(s)
  	# based on base2dec() in Tcl translation
  	# ad http://rosetttacode.org/wiki/Non-decimal_radices/Convert#Ruby
  	i = 0
  	base = ALPHABET.length
  	s.each_char { |c| i = i * base + ALPHABET.index(c) }
  	i
  end

  def get_hostname
    ip_address = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address
    hostname = "http://#{ip_address}:#{request.port}/"
  end
  helper_method :get_hostname
end
