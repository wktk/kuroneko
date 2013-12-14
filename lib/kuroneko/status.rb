# -*- encoding: utf-8 -*-

class Kuroneko
  # 状態情報
  Status = Struct.new(:number, :status, :date, :time, :branch, :branch_code)

  class Status
    # @!attribute number
    #   @return [String] 伝票番号
    #   @example
    #     "123456789012"
    #   @note 数字以外 (ハイフン等) は含まない

    # @!attribute status
    #   @return [String] 状態名
    #   @example
    #     "配達完了"

    # @!attribute date
    #   @return [String] 状態発生日
    #   @example
    #     "12/31"

    # @!attribute time
    #   @return [String] 状態発生時刻
    #   @example
    #     "12:59"

    # @!attribute branch
    #   @return [String] 担当店
    #   @example
    #     "北東京ベース店"

    # @!attribute branch_code
    #   @return [String] 担当店コード
    #   @example
    #     "030990"

    # @param [String] number 伝票番号
    # @param [Nokogiri::XML::Element] status 状態情報のテーブル行
    # @param [Boolean] latest 最新の状態であるか
    def initialize(number, status, latest=nil)
      super(number, *parse(status))
      @latest = latest unless latest.nil?
    end

    # @return [Boolean] 最新の状態であるか
    def latest?
      @latest
    end

  private

    # 状態を解析する
    #
    # @param [Nokogiri::XML::Element] status 状態情報のテーブル行
    # @return [Array<String>] 状態
    def parse(status)
      return status unless status.is_a?(Nokogiri::XML::Element)
      attrs = status.css('td').to_a
      @latest = attrs.shift.css('img').attribute('alt').value == '最新'
      attrs.map!(&:text)
    end
  end
end
