require 'openssl'
require 'base64'

module Preventurl
  extend self
  def cipher
    OpenSSL::Cipher::Cipher.new('aes-256-cbc')
  end

  def cipher_key
    OpenSSL::Digest::SHA256.new('facial').digest
  end

  def decrypt(value)
    c = cipher.decrypt
    c.key = cipher_key
    c.update(Base64.decode64(value.to_s)) + c.final
  end

  def encrypt(value)
    c = cipher.encrypt
    c.key = cipher_key
    Base64.encode64(c.update(value.to_s) + c.final)
  end
end


####################by 128 #####################################

# module Preventurl
#   extend self
#   def cipher
#     OpenSSL::Cipher::Cipher.new('aes-128-cbc')
#   end

#   def cipher_key
#     OpenSSL::Digest::SHA128.new('nightapp').digest
#   end

#   def decrypt(value)
#     c = cipher.decrypt
#     c.key = cipher_key
#     c.update(Base64.decode64(value.to_s)) + c.final
#   end

#   def encrypt(value)
#     c = cipher.encrypt
#     c.key = cipher_key
#     Base64.encode64(c.update(value.to_s) + c.final)
#   end
# end

# iv = Base64.decode64("kT+uMuPwUk2LH4cFbK0GiA==")

# key = ["6476b3f5ec6dcaddb637e9c9654aa687"].pack("H*")

# cipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')

# cipher.encrypt

# cipher.key = key

# cipher.iv = iv

# text = cipher.update("test") + cipher.final

# encrypted_text = Base64.strict_encode64(text)