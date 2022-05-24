require 'openssl'
require 'base64'

class PaymentType
  PUBLIC_KEY_FILE = "./config/rsa/public.pem"

  def encrypt(string)
    public_key = OpenSSL::PKey::RSA.new(File.read(PUBLIC_KEY_FILE))
    Base64.encode64(public_key.public_encrypt(string.to_s))
  end
end
