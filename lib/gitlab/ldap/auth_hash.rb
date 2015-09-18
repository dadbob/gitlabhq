# Class to parse and transform the info provided by omniauth
#
module Gitlab
  module LDAP
    class AuthHash < Gitlab::OAuth::AuthHash
      private

      def get_info(key)
        attributes = ldap_config.attributes[key]
        return super unless attributes

        attributes = Array(attributes)

        value = nil
        attributes.each do |attribute|
          value = get_raw(attribute)
          break if value.present?
        end
        
        return super unless value

        Gitlab::Utils.force_utf8(value)
        value
      end

      def get_raw(key)
        auth_hash.extra[:raw_info][key]
      end

      def ldap_config
        @ldap_config ||= Gitlab::LDAP::Config.new(self.provider)
      end
    end
  end
end