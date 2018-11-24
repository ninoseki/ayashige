# Ayashige

[![Build Status](https://travis-ci.org/ninoseki/ayashige.svg?branch=master)](https://travis-ci.org/ninoseki/ayashige)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/ayashige/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/ayashige?branch=master)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/249304b2af7c4a69ae5233ee93188c48)](https://www.codacy.com/app/ninoseki/ayashige)

Ayashige provides a list of suspicious newly registered domains as a JSON feed.

## How it works

- It collects newly registered domains via [WebAnalyzer](https://wa-com.com/).
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
REDIS_PASSWORD = YOUR_REDIS_PASSWORDE
```

### Run a Cron job

```
bundle exec ruby bin/cron_job.rb
```

- The job crawls WebAnalyzer website and parsed the latest registered domains.
- It checks a suspicious score of a given each domain and stores a suspicious one into a Redis instance.

### Run a Web app

```
bundle exec puma config.ru
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ninoseki/ayashige.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
