# heroku-env [![Gem Version](https://badge.fury.io/rb/heroku-env.svg)](https://rubygems.org/gems/heroku-env) [![RSS](https://stefansundin.github.io/img/feed.png)](https://github.com/stefansundin/heroku-env/releases.atom)

> Don't worry about the environment.

- [Installation](#installation)
- [Redis](#redis)
- [Memcache](#memcache)
- [Mongo](#mongo)
- [MySQL](#mysql)
- [Neo4j](#neo4j)
- [Elasticsearch](#elasticsearch)
- [SMTP](#smtp)
- [Airbrake](#airbrake)

This simple gem makes it easier for you to use different Heroku addons in a plug-and-play fashion. Normally, if you decide to add a Redis provider, you have to customize your code to use that addon's environment variables. The problem with this, however, is that if you want to switch provider, you have to update your code.

What I usually ended up doing was:

```ruby
ENV["REDIS_URL"] ||= ENV["REDISCLOUD_URL"] || ENV["REDISTOGO_URL"]
$redis = Redis.new
```

Doing this in every project started to become a little annoying, so I decided to make a gem.

The gem only supports addons with a free plan. The order that the addons are selected depends on how stable and feature-rich they are. So if you are deciding what provider you want to use, a good choice is probably the first one in the lists below.

The gem uses `||=` in all the assignments, so you can easily override any variable by manually setting it.


## Installation

Add to your Gemfile:

```ruby
gem "heroku-env", "~> 0.1.0"
```

If you use `dotenv-rails`, then you should put this gem lower than it in the Gemfile.

If you use Rails, then you should not need to do anything more, the gem has a Railtie hook which will do the initialization.

If not, then you might have to run this manually:

```ruby
require "heroku-env"
HerokuEnv.run
```

This gem is cryptographically signed, you can verify the installation with:

```bash
gem cert --add <(curl -Ls https://raw.githubusercontent.com/stefansundin/heroku-env/master/certs/stefansundin.pem)
gem install heroku-env -P HighSecurity
```


### Redis

Supports [Redis Cloud](https://elements.heroku.com/addons/rediscloud) and [Redis To Go](https://elements.heroku.com/addons/redistogo).

```ruby
$redis = Redis.new
```

### Memcache

Supports [MemCachier](https://elements.heroku.com/addons/memcachier) and [Memcached Cloud](https://elements.heroku.com/addons/memcachedcloud).

```ruby
$dc = Dalli::Client.new
```

### Mongo

Supports [MongoLab](https://elements.heroku.com/addons/mongolab) and [MongoSoup](https://elements.heroku.com/addons/mongosoup).

```ruby
$mongo = Mongo::Client.new ENV["MONGO_URL"]
```

### MySQL

Supports [ClearDB](https://elements.heroku.com/addons/cleardb) and [JawsDB](https://elements.heroku.com/addons/jawsdb-maria).

```ruby
config = URI.parse ENV["MYSQL_URL"]
$mysql = Mysql2::Client.new(
  host:     config.hostname,
  port:     config.port,
  username: config.user,
  password: config.password,
  database: config.path.sub(%r{^/},""),
  reconnect: true
)
```

### Neo4j

Supports [Graph Story](https://elements.heroku.com/addons/graphstory) and [GrapheneDB](https://elements.heroku.com/addons/graphenedb).

```ruby
$neo4j = Neo4j::Session.open :server_db, ENV["NEO4J_URL"]
```

### Elasticsearch

Supports [Bonsai](https://elements.heroku.com/addons/bonsai) and [SearchBox](https://elements.heroku.com/addons/searchbox).

```ruby
$elasticsearch = Elasticsearch::Client.new
```

### SMTP

Supports [Mandrill](https://elements.heroku.com/addons/mandrill), [SendGrid](https://elements.heroku.com/addons/sendgrid), [Mailgun](https://elements.heroku.com/addons/mailgun), [Postmark](https://elements.heroku.com/addons/postmark) and [SparkPost](https://elements.heroku.com/addons/sparkpost).

```ruby
Mail.defaults do
  delivery_method :smtp,
    address:              ENV["SMTP_HOST"],
    port:                 ENV["SMTP_PORT"],
    user_name:            ENV["SMTP_USERNAME"],
    password:             ENV["SMTP_PASSWORD"],
    authentication:       "plain",
    enable_starttls_auto: true
end
```

Then send an email with:

```ruby
Mail.deliver do
     from "Sender <#{ENV["MAIL_FROM"]}>"
       to "receiver@example.com"
  subject "Test email"
     body "Just testing heroku-env"
end
```

If you use Postmark, you have to manually set `MAIL_FROM`.

#### ActionMailer

If you use Rails, you might want to use this:

```ruby
ActionMailer::Base.smtp_settings = {
  address:        ENV["SMTP_HOST"],
  port:           ENV["SMTP_PORT"],
  user_name:      ENV["SMTP_USERNAME"],
  password:       ENV["SMTP_PASSWORD"],
  authentication: :plain,
}
```

### Airbrake

Supports [Airbrake](https://elements.heroku.com/addons/airbrake), [Raygun](https://elements.heroku.com/addons/raygun) and [Rollbar](https://elements.heroku.com/addons/rollbar).

```ruby
Airbrake.configure do |config|
  config.host = ENV["AIRBRAKE_HOST"]
  config.api_key = ENV["AIRBRAKE_KEY"]
  config.secure = true
end
```

Another Airbrake-compatible provider is [AppEnlight](https://appenlight.com/), it is free but they don't provide a Heroku addon. You can manually set `APPENLIGHT_APIKEY` to use it.


## Misc notes

- Postmark sends you some unwanted emails if you add the addon.
