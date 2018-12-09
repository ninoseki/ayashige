# Ayashige

[![Build Status](https://travis-ci.org/ninoseki/ayashige.svg?branch=master)](https://travis-ci.org/ninoseki/ayashige)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/ayashige/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/ayashige?branch=master)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/249304b2af7c4a69ae5233ee93188c48)](https://www.codacy.com/app/ninoseki/ayashige)

Ayashige provides a list of suspicious newly registered domains as a JSON feed.

## How it works

- It collects newly registered domains via [WebAnalyzer](https://wa-com.com/), [WhoisDS](https://whoisds.com/), [DomainWatch](https://domainwat.ch/) and a Certififate Transparency log server (Google Rocketeer).
- It computes a suspicious score of a given domain.
  - The scoring rule comes from [x0rz/phishing_catcher](https://github.com/x0rz/phishing_catcher).
- It stores suspicious domains into a Redis instance.
- It provides suspicious domains as a JSON via `/feed` endpoint.

## Installation

```sh
git clone https://github.com/ninoseki/ayashige
bundle install --path vendor/bundle
```

## Usage

Please set following environmental values before using.

```sh
REDIS_HOST = YOUR_REDIS_HOST
REDIS_PORT = YOUR_REDIS_PORT
REDIS_PASSWORD = YOUR_REDIS_PASSWORD
```

### Run Cron jobs

```sh
bundle exec ruby bin/web_analyzer_job.rb
bundle exec ruby bin/whoisds_job.rb
bundle exec ruby bin/domain_watch_job.rb
```

- The jobs collects the latest registered domains from WebAnalyzer, WhoisDS & DomainWatch.
- It checks a suspicious score of a given each domain and stores a suspicious one into a Redis instance.

### Run a Web app

```sh
bundle exec puma config.ru
```

## Demo

- https://ayashige.herokuapp.com/feed

- Notes:
  - This app is hosted on Heroku free dyno.
  - The Cron job is triggered at 20:00 UTC+0 every day.
  - The data in the Redis instance will expire after 48 hours.
  - I'm running this app just as a hobby and I cannot assure its consistency.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ninoseki/ayashige.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
