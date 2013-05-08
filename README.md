# OpenID::Store::Redis [![Build Status](https://travis-ci.org/RallySoftware/openid-store-redis.png)](https://travis-ci.org/RallySoftware/openid-store-redis)

A Redis storage backend for ruby-openid

## Installation

Add this line to your application's Gemfile:

    gem 'openid-store-redis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openid-store-redis

## Usage

Set up OpenID consumer (or provider) using Redis store

```ruby
redis = Redis.new
store = OpenID::Store::Redis.new(redis)
@consumer = OpenID::Consumer.new(session, store)
```

If you're using Omniauth

```ruby
use OmniAuth::Builder do
  provider :open_id, :store => OpenID::Store::Redis.new(Redis.new)
end
```

Redis store defaults to ```Redis.current``` when Redis client is not given as
argument to store.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

© Rally Software Development Corp. Released under MIT license, see
[LICENSE](https://github.com/RallySoftware/openid-store-redis/blob/master/LICENSE.txt)
for details.
