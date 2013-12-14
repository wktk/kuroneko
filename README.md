# Kuroneko

クロネコヤマトの荷物追跡を照会する

See also: http://toi.kuronekoyamato.co.jp/cgi-bin/tneko

## Installation

Add this line to your application's Gemfile:

    gem 'kuroneko'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kuroneko

## Usage

``` ruby
require "kuroneko"

neko = Kuroneko.new

# 1 つの荷物の状態履歴
history = neko.history("1234-5678-9012")

# 複数の荷物の状態履歴
histories = neko.histories("1234-5678-9012", "1234-5678-9013", ... )

# 1 つの荷物の最新状態
status = neko.status("1234-5678-9012")
  # OR
  status = history.latest
  status = history.find(&:latest?)

# 複数の荷物の最新状態
statuses = neko.statuses("1234-5678-9012", "1234-5678-9013", ... )

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
