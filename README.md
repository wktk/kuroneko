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

### 最新状態を取得する

``` ruby
require "kuroneko"

neko = Kuroneko.new

status = neko.status("1234-5678-9012")
#=> #<struct Kuroneko::Status>

status.number
#=> "123456789012"

status.status
#=> "配達完了"

status.to_h
  => {
    number: "123456789012",
    status: "配達完了",
    date:   "12/31",
    time:   "12:59",
    branch: "北東京ベース店",
    branch_code: "030990"
  }
```

- 履歴のうち最新の `Kuroneko::Status` は `#latest?` に `true` を返します。
- `Kuroneko#statuses` で複数を一度に照会でき、結果は `Array` で返されます。

### 状態履歴を取得する

``` ruby
history = neko.history("1234-5678-9012")
#=> #<Kuroneko::History<Kuroneko::Status>>
```

- `History` は `Array` を継承していて、以下を追加で実装しています。
    - 履歴のうち最新の状態を返す `#latest`
    - 伝票番号を返す `#number`
- `Kuroneko#histories` で複数を一度に照会でき、結果は `Array` で返されます。

### 英語版を利用する

``` diff
- require "kuroneko"
- neko = Kuroneko.new
+ require "kuroneko/en"
+ neko = Kuroneko::En.new
```

英語版を使うと担当店 / 担当店コードは取得できません。

### 伝票番号

`#status`, `#statuses`, `#history`, `#histories` に渡す伝票番号は
そのまま問い合わせに使用するため、クロネコヤマト側が受け付ける形式であれば
どのようなものでも可能です。

`Kuroneko::History`, `Kuroneko::Status` から読み取る伝票番号は
照会結果から取得し、数字のみからなる __文字列__ で返ります。

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
