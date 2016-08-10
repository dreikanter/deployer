module Operations
  module DeploymentKey
    class Create < Operations::Base
      attr_reader :record
      attr_reader :form

      def perform
        @form = DeploymentKeyForm.new(::DeploymentKey.new)
        return unless @form.validate(form_params)
        @record = ::DeploymentKey.create(key_attributes)
      end

      private

      def key_attributes
        cipher = OpenSSL::Cipher.new(cipher_algorithm)
        cipher.encrypt
        iv = cipher.random_iv
        cipher.key = ENV.fetch('deployment_key_passphrase')

        {
          encrypted_private: rsa_key.to_pem(cipher, passphrase),
          public: rsa_key.public_key.to_s,
          iv: Base64.encode64(iv),
          name: form_params[:name],
          cipher_algorithm: cipher_algorithm
        }
      end

      def cipher_algorithm
        @cipher_algorithm ||= ENV.fetch('open_ssl_cipher', 'aes-256-cbc')
      end

      def rsa_key
        @rsa_key ||= OpenSSL::PKey::RSA.new(2048)
      end

      def passphrase
        ENV.fetch('deployment_key_passphrase')
      end

      def form_params
        params[:deployment_key]
      end
    end
  end
end
