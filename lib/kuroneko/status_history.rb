# -*- encoding: utf-8 -*-

class Kuroneko
  # 状態履歴
  class StatusHistory < Array
    # @return [String] 伝票番号
    # @note 数字以外 (ハイフン等) は含まない
    attr_reader :number

    # @param [String] number 伝票番号
    # @param [Nokogiri::XML::Element] table 状態履歴テーブル
    def initialize(number, table)
      @number = number
      super(parse(table))
    end

    # @return [Kuroneko::Status] 履歴のうち最新の状態
    def latest
      find(&:latest?) || last
    end

  private

    # 状態履歴テーブルを解析する
    #
    # @param [Nokogiri::XML::Element] table 状態履歴テーブル
    # @return [Array<Kuroneko::Status>] 状態
    def parse(table)
      return table unless table.is_a?(Nokogiri::XML::Element)
      statuses = table.css('tr').to_a
      statuses.shift
      statuses.map! { |status| Status.new(number, status) }
    end
  end
end
