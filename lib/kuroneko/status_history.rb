# -*- encoding: utf-8 -*-

class Kuroneko
  # 状態履歴
  class StatusHistory < Array
    # @return [String] 伝票番号
    # @note 数字以外 (ハイフン等) は含まない
    attr_reader :number

    # @param [String] number 伝票番号
    # @param [Array<Kuroneko::Status>] history 状態履歴
    def initialize(number, history)
      @number = number
      super(history)
    end

    # @return [Kuroneko::Status] 履歴のうち最新の状態
    def latest
      find(&:latest?) || last
    end

  end
end
