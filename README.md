# Ayashige

[![Python CI](https://github.com/ninoseki/ayashige/actions/workflows/test.yaml/badge.svg)](https://github.com/ninoseki/ayashige/actions/workflows/test.yaml)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/ayashige/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/ayashige?branch=master)

Ayashige provides a list of suspicious newly registered domains as a JSON feed.

## How it works

- It collects newly registered domains via Certififate Transparency log servers and [SecurityTrails](https://securitytrails.com/).
- It computes a suspicious score of a given domain.
  - The scoring rule comes from [x0rz/phishing_catcher](https://github.com/x0rz/phishing_catcher).
- It stores suspicious domains into a Redis instance.
- It provides suspicious domains as a JSON via `/api/v1/domains/` endpoint.

## Requirements

- Docker
- [SecurityTrails](https://securitytrails.com/) API key (Optional)

## Installation

```sh
git clone https://github.com/ninoseki/ayashige
cd ayashige
docker compose --env-file .env up -d
```

## Demo

- https://ayashige.herokuapp.com/

- Notes:
  - This app is hosted on Heroku free dyno.
  - I'm running this app just as a hobby and I cannot assure its consistency.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ninoseki/ayashige.

## License

The repository is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
