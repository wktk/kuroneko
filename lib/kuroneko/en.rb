# -*- coding: utf-8 -*-

require 'kuroneko'

class Kuroneko
  # 英語版フォームでの問い合わせ
  class En < Kuroneko
    # @return [String] 問い合わせフォームの URL
    URL = 'http://track.kuronekoyamato.co.jp/english/tracking'.freeze

    # インスタンスを初期化する
    #
    # @param [Hash] options
    # @see Kuroneko#initialize
    def initialize(options={})
      super
      @url = URL.dup unless options[:url]
    end
  end
end
