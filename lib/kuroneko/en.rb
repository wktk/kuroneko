# -*- coding: utf-8 -*-

require 'kuroneko'

class Kuroneko
  module En
    # @return [String] 問い合わせフォームの URL
    URL = 'http://track.kuronekoyamato.co.jp/english/tracking'.freeze

    class << self
      # 英語版で初期化する
      #
      # @return [Kuroneko]
      def new(option={})
        obj = Kuroneko.new
        obj.url = option[:url] || URL.dup
        obj
      end
    end
  end
end
