# heroku-env [![Gem Version](https://badge.fury.io/rb/heroku-env.svg)](https://rubygems.org/gems/heroku-env) [![RSS](https://stefansundin.github.io/img/feed.png)](https://rubygems.org/gems/heroku-env/versions.atom)

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

Doing this in every project started to become a little annoying, so I decided to make a gem. The goal is to handle all kinds of addons, but for now it only handles Redis and SMTP. Suggest more types by filing an issue.

The gem only supports addons with a free plan. The order that the addons are selected depends on how stable and easy I perceive them to be. So if you are deciding what provider you want to use, a good choice is probably the first one in the lists below.

The gem uses `||=` in all the assignments, so you can easily override any variable by manually setting it.


## Installation

Add to your Gemfile:

```ruby
gem "heroku-env"
```

Then run this once your ENV is loaded (e.g. after `dotenv`):

```ruby
HerokuEnv.run
```


### Redis

Supports [Redis Cloud](https://addons.heroku.com/rediscloud) and [Redis To Go](https://addons.heroku.com/redistogo).

```ruby
$redis = Redis.new
```

### Memcache

Supports [MemCachier](https://addons.heroku.com/memcachier) and [Memcached Cloud](https://addons.heroku.com/memcachedcloud).

```ruby
$dc = Dalli::Client.new
```

### Mongo

Supports [MongoLab](https://addons.heroku.com/mongolab) and [MongoSoup](https://addons.heroku.com/mongosoup).

```ruby
$mongo = Mongo::Client.new ENV["MONGO_URL"]
```

### MySQL

Supports [ClearDB](https://addons.heroku.com/cleardb).

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

Supports [Graph Story](https://addons.heroku.com/graphstory) and [GrapheneDB](https://addons.heroku.com/graphenedb).

```ruby
$neo4j = Neo4j::Session.open :server_db, ENV["NEO4J_URL"]
```

### Elasticsearch

Supports [Bonsai](https://addons.heroku.com/bonsai) and [SearchBox](https://addons.heroku.com/searchbox).

```ruby
$elasticsearch = Elasticsearch::Client.new
```

### SMTP

Supports [Mandrill](https://addons.heroku.com/mandrill), [SendGrid](https://addons.heroku.com/sendgrid), [Mailgun](https://addons.heroku.com/mailgun) and [Postmark](https://addons.heroku.com/postmark).

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

Supports [Raygun](https://addons.heroku.com/raygun) and [Rollbar](https://addons.heroku.com/rollbar).

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
