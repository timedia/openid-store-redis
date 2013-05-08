require "openid/store/redis/version"
require "openid/store/interface"
require "redis"

module OpenID
  module Store
    class Redis < Interface
      attr_reader :prefix
      def initialize(client = ::Redis.current, prefix = "openid-store")
        @redis = client
        @prefix = prefix
      end

      # Store an Association in Redis
      def store_association(server_url, association)
        serialized = serialize(association)
        [nil, association.handle].each do |handle|
          key = assoc_key(server_url, handle)
          @redis.setex(key, association.lifetime, serialized)
        end
      end

      # Fetch and deserialize an Association object from Redis
      def get_association(server_url, handle=nil)
        if serialized = @redis.get(assoc_key(server_url, handle))
          deserialize(serialized)
        else
          nil
        end
      end

      # Remove matching association from Redis
      #
      # return true when data is removed, otherwise false
      def remove_association(url, handle)
        deleted = @redis.del(assoc_key(url, handle))
        assoc = get_association(url)
        if assoc && assoc.handle == handle
          deleted + @redis.del(assoc_key(url))
        else
          deleted
        end > 0
      end


      # Use nonce and store that it has been used in Redis temporarily
      #
      # Returns true if nonce has not been used before and is still usable,
      def use_nonce(server_url, timestamp, salt)
        return false if (timestamp - Time.now.to_i).abs > Nonce.skew
        ts = timestamp.to_s # base 10 seconds since epoch
        nonce_key = prefix + ':n:' + server_url + ':' + ts + ':' + salt
        if @redis.setnx(nonce_key, '')
          @redis.expire(nonce_key, Nonce.skew + 5)
          true
        else
          false
        end
      end

      def cleanup_nonces
      end

      def cleanup
      end

      def cleanup_associations
      end

      private

      def assoc_key(server_url, assoc_handle=nil)
        key = prefix + ':a:' + server_url
        if assoc_handle
          key + ':' + assoc_handle
        else
          key
        end
      end

      def serialize(assoc)
        Marshal.dump(assoc)
      end

      def deserialize(assoc_str)
        Marshal.load(assoc_str)
      end
    end
  end
end
